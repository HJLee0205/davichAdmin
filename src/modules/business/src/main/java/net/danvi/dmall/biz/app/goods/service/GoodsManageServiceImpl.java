package net.danvi.dmall.biz.app.goods.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.*;
import dmall.framework.common.util.*;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdVO;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigVO;
import net.danvi.dmall.biz.app.setup.personcertify.service.PersonCertifyConfigService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.vision.model.VisionGunVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.cmmn.service.LogService;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductMappingBundleReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductMappingBundleResDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductSearchReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductSearchResDTO;
import net.danvi.dmall.biz.ifapi.prd.service.ProductService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.*;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("goodsManageService")
@Transactional(rollbackFor = Exception.class)
public class GoodsManageServiceImpl extends BaseService implements GoodsManageService {

    final static String CODE_FOR_GOODS_SALE_STATUS_SOLD_OUT = "2"; // 품절
    final static String CODE_FOR_GOODS_SALE_STATUS_SALE_START = "1"; // 판매중
    final static String CODE_FOR_GOODS_SALE_STATUS_SALE_STOP = "4"; // 판매중지

    final static String DATE_FORMAT_FOR_GOODS_NO = "yyMMddHHmm";

    final static String DELIMETER_FOR_GROUP_CONCAT = "#@#";

    @Value("#{system['system.upload.editor.image.path']}")
    private String imageFilePath;

    @Value("#{system['system.upload.editor.temp.image.path']}")
    private String tempImageFilePath;

    @Resource(name = "personCertifyConfigService")
    private PersonCertifyConfigService personCertifyConfigService;

    @Resource(name = "editorService")
    private EditorService editorService;

    /** 상품 이미지 업로드 경로 */
    @Value("#{system['system.upload.goods.image.path']}")
    private String goodsImageFilePath;

    /** 상품 이미지 임시 업로드 경로 */
    @Value("#{system['system.upload.goods.temp.image.path']}")
    private String goodsTempImageFilePath;

    @Value("#{system['system.upload.path']}")
    private String uplaodFilePath;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Resource(name = "bizService")
    private BizService bizService;

    @Value("#{datasource['main.database.type']}")
    private String dbType;

    @Resource(name = "productService")
    private ProductService productService;

    @Resource(name = "logService")
    private LogService logService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "filterManageService")
    private FilterManageService filterManageService;

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * selectGoodsList(GoodsSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<GoodsVO> selectGoodsList(GoodsSO so) {

        if (so.getSearchPriceFrom() != null) {
            so.setSearchPriceFrom(so.getSearchPriceFrom().replaceAll(",", ""));
        }
        if (so.getSearchPriceTo() != null) {
            so.setSearchPriceTo(so.getSearchPriceTo().replaceAll(",", ""));
        }
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }

        if(so.getSrchGoodsContsGbCd()!=null && !so.getSrchGoodsContsGbCd().equals("")){
            so.setGoodsContsGbCd(so.getSrchGoodsContsGbCd());
        }

        //실물(01) default 설정..
        if(so.getGoodsContsGbCd()==null || so.getGoodsContsGbCd().equals("")){
            so.setGoodsContsGbCd("01");
        }

        log.info("selectGoodsList param so = {}", so);
        if(so.getFilters() != null && so.getFilters().matches(".*[0-9].*")) {
            String[] filterNos = so.getFilters().split(",");
            so.setSearchFilters(filterNos);
        }
        ResultListModel<GoodsVO> resultList = proxyDao.selectListPage(MapperConstants.GOODS_MANAGE + "selectGoodsListPaging", so);

        List<GoodsVO> goodslist = resultList.getResultList();
        if(goodslist!=null) {
            for (int j = 0; j < goodslist.size(); j++) {

                if (goodslist.get(j).getCouponAvlInfo() != null && !goodslist.get(j).getCouponAvlInfo().equals("")) {
                    GoodsVO dispVo = goodslist.get(j);
                    int avlLen = goodslist.get(j).getCouponAvlInfo().split("\\|").length;

                    for (int l = 0; l < avlLen; l++) {
                        if (l == 0)
                            dispVo.setCouponApplyAmt(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                        if (l == 1)
                            dispVo.setCouponDcAmt(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                        if (l == 2)
                            dispVo.setCouponDcRate(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                        if (l == 3)
                            dispVo.setCouponDcValue(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                        if (l == 4)
                            dispVo.setCouponBnfCd(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                        if (l == 5)
                            dispVo.setCouponBnfValue(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                        if (l == 6)
                            dispVo.setCouponBnfTxt(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                    }
                }
                if (goodslist.get(j).getGoodsTypeCd() == null && goodslist.get(j).getCtgName() != null) {
                    GoodsVO goodsVo = goodslist.get(j);

                    if(goodslist.get(j).getCtgName().contains("안경테")) {
                        goodsVo.setGoodsTypeCd("01");
                    } else if(goodslist.get(j).getCtgName().contains("선글라스")) {
                        goodsVo.setGoodsTypeCd("02");
                    } else if(goodslist.get(j).getCtgName().contains("안경렌즈")) {
                        goodsVo.setGoodsTypeCd("03");
                    } else if(goodslist.get(j).getCtgName().contains("콘택트렌즈")) {
                        goodsVo.setGoodsTypeCd("04");
                    } else if(goodslist.get(j).getCtgName().contains("소모품")) {
                        goodsVo.setGoodsTypeCd("05");
                    }
                }
            }
        }


        return resultList;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#selectCtgList(
     * CtgVO)
     */
    @Override
    @Transactional(readOnly = true)
    public List<CtgVO> selectCtgList(CtgVO vo) {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectCtgList", vo);
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * selectBrandList(BrandVO)
     */
    @Override
    @Transactional(readOnly = true)
    public List<BrandVO> selectBrandList(BrandVO vo) {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectBrandList", vo);
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * selectContactWearBrandList(BrandVO)
     */
    @Override
    @Transactional(readOnly = true)
    public List<BrandVO> selectContactWearBrandList(BrandVO vo) {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectContactWearBrandList", vo);
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * selectBrandCategoryList(BrandVO)
     */
    @Override
    @Transactional(readOnly = true)
    public List<BrandVO> selectBrandCategoryList(BrandVO vo) {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectBrandCategoryList", vo);
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#updateSoldOut(
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> updateSoldOut(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setGoodsSaleStatusCd(CODE_FOR_GOODS_SALE_STATUS_SOLD_OUT);
            po.setDispYn(null);

            // 품절시 장바구니 삭제 여부 취득
            SiteSO so = new SiteSO();
            so.setSiteNo(po.getSiteNo());
            String soldOutDeleteYn = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectSoldOutDeleteYn", so);
            po.setSoldOutDeleteYn(soldOutDeleteYn);

            // 품절 처리
            // 품절시 장바구니 삭제 여부 = 'Y'의 경우 품절 처리시 장바구니에서 해당 상품정보 삭제
            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoods", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#updateSoldOut(
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> updateDisplay(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            // 전시 처리
            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoods", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#updateSaleStop(
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> updateSaleStop(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setGoodsSaleStatusCd(CODE_FOR_GOODS_SALE_STATUS_SALE_STOP);
            po.setDispYn(null);

            // 판매중지 처리
            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoods", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#updateSaleStart(
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> updateSaleStart(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setGoodsSaleStatusCd(CODE_FOR_GOODS_SALE_STATUS_SALE_START);
            po.setDispYn("Y");

            // 판매승인 처리
            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoods", po);

            // 상품 승인완료면 판매자에게 sms 전송
            if (!StringUtils.isEmpty(po.getAprvYn())) {
                GoodsDetailVO goodsDetailVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsBasicInfo", po);

                ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
                smsReplaceVO.setGoodsNm(goodsDetailVO.getGoodsNm());

                SmsSendSO smsSendSO = new SmsSendSO();
                smsSendSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                smsSendSO.setSendTypeCd("38");
                smsSendSO.setSellerNo(Long.parseLong(goodsDetailVO.getSellerNo()));
                smsSendSO.setSellerTemplateCode("mk051");

                try {
                    smsSendService.sendAutoSms(smsSendSO, smsReplaceVO);
                } catch (Exception e) {
                    resultModel.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
                    return resultModel;
                }
            }
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#updateSaleStart(
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> updateDlvrExpectDays(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setGoodsSaleStatusCd(null);
            po.setDispYn(null);
            // 예상 배송 소요일 처리
            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoods", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#updateSaleStart(
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> updateDlvrCost(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setGoodsSaleStatusCd(null);
            po.setDispYn(null);
            // 예상 배송 소요일 처리
            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoods", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#updateSaleStart(
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> updateEventWords(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setGoodsSaleStatusCd(null);
            po.setDispYn(null);
            // 예상 배송 소요일 처리
            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoods", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    @Override
    public ResultModel<GoodsPO> updateSalePrice(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        for (GoodsPO po : wrapper.getList()) {
            // 상품의 아이템 정보 조회
            List<GoodsItemVO> goodsItemList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsItemInfo", po);

            for (GoodsItemVO itemVO : goodsItemList) {
                // 가격 변화 검증
                if (po.getSalePrice() != itemVO.getSalePrice()) {
                    GoodsItemPO itemPO = new GoodsItemPO();
                    // ITEM_VER ++
                    itemPO.setItemVer(itemVO.getItemVer() + 1);
                    // 기존 가격이 변경할 가격보다 크면
                    if(itemVO.getSalePrice() > po.getSalePrice()) {
                        // 인하
                        itemPO.setPriceChgCd("00");
                        itemPO.setSaleChdPrice(itemVO.getSalePrice() - po.getSalePrice());
                    } else {
                        // 인상
                        // 정상가 (소비자가격) 보다 큰지 검증
                        if (itemVO.getCustomerPrice() < po.getSalePrice()) {
                            resultModel.setSuccess(false);
                            resultModel.setMessage("변경할 판매가는 정상가보다 클 수 없습니다.");
                            return resultModel;
                        }

                        itemPO.setPriceChgCd("01");
                        itemPO.setSaleChdPrice(po.getSalePrice() - itemVO.getSalePrice());
                    }
                    // 필수값 세팅
                    itemPO.setItemNo(itemVO.getItemNo());
                    itemPO.setItemNm(itemVO.getItemNm());
                    itemPO.setRegrNo(memberNo);
                    itemPO.setUseYn(itemVO.getUseYn());
                    itemPO.setSupplyPrice(itemVO.getSupplyPrice());
                    itemPO.setSepSupplyPriceYn(itemVO.getSepSupplyPriceYn());
                    itemPO.setApplyDavisionStockYn(itemVO.getApplyDavisionStockYn());
                    itemPO.setCost(itemVO.getCost());
                    itemPO.setCustomerPrice(itemVO.getCustomerPrice());
                    itemPO.setSalePrice(po.getSalePrice());
                    itemPO.setDcPriceApplyAlwaysYn(po.getDcPriceApplyAlwaysYn());
                    itemPO.setDcStartDttm(po.getDcStartDttm());
                    itemPO.setDcEndDttm(po.getDcEndDttm());
                    itemPO.setUpdrNo(memberNo);

                    // 아이템 가격 변경 이력 테이블에 등록
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", itemPO);
                    // 단품 정보 수정
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", itemPO);
                }
            }
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    @Override
    public ResultModel<GoodsPO> updateGoodsIcon(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        for (GoodsPO po : wrapper.getList()) {
            //String soldOutDeleteYn = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectMultiOptYn", po);
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(memberNo);
            po.setRegrNo(memberNo);
            GoodsPO goodsPO = new GoodsPO();
            goodsPO.setGoodsNo(po.getGoodsNo());
            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsIcon", goodsPO);
            if (!"N".equals(po.getIconNo())) {
                proxyDao.update(MapperConstants.GOODS_MANAGE + "insertGoodsIcon", po);
            }
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*류
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * updateGoodsStatus(net.danvi.dmall.biz.app.goods.model.
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> updateGoodsStatus(GoodsPOListWrapper wrapper) throws Exception {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        // 품절시 장바구니 삭제 여부 취득
        SiteSO so = new SiteSO();
        so.setSiteNo(wrapper.getSiteNo());
        String soldOutDeleteYn = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectSoldOutDeleteYn", so);

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            // 상품 판매 코드가 품절일 경우 품절 처리
            if ("2".equals(po.getGoodsSaleStatusCd())) {
                po.setSoldOutDeleteYn(soldOutDeleteYn);
            }
            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoods", po);

            // 단품 정보 수정 (속성이외)
            GoodsItemPO goodsItemPO = new GoodsItemPO();
            goodsItemPO.setSiteNo(po.getSiteNo());
            goodsItemPO.setGoodsNo(po.getGoodsNo());
            goodsItemPO.setItemNo(po.getItemNo());
            goodsItemPO.setSalePrice(po.getSalePrice());
            goodsItemPO.setSupplyPrice(po.getSupplyPrice());
            goodsItemPO.setStockQtt(po.getStockQtt());
            goodsItemPO.setUpdrNo(sessionInfo.getSession().getMemberNo());

            // 연관 아이템 가격도 함게 변경하도록 설정한다.
            goodsItemPO.setRelationPriceUpdate(true);
            updateItemInfo(goodsItemPO, false);
        }

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#deleteGoods(
     * GoodsPOListWrapper)
     */
    @Override
    public ResultModel<GoodsPO> deleteGoods(GoodsPOListWrapper wrapper) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();

        for (GoodsPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            // 삭제 정보 설정
            po.setDelYn("Y");
            po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            GoodsDetailVO goodsDispImageVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsDispImageInfo", po);

            proxyDao.update(MapperConstants.GOODS_MANAGE + "deleteItems", po);
            proxyDao.update(MapperConstants.GOODS_MANAGE + "deleteGoods", po);

            if (goodsDispImageVO != null) {
                // 상품 전시 이미지 명
                // 비교 이미지명이 변경 되었을 경우 기존 이미지 삭제 처리
                try {
                    if (!StringUtils.isEmpty(goodsDispImageVO.getDispImgNmTypeA())
                            && !StringUtils.isEmpty(goodsDispImageVO.getDispImgPathTypeA())) {
                        deleteGoodsImg(goodsDispImageVO.getDispImgPathTypeA(), goodsDispImageVO.getDispImgNmTypeA());
                    }
                    if (!StringUtils.isEmpty(goodsDispImageVO.getDispImgNmTypeB())
                            && !StringUtils.isEmpty(goodsDispImageVO.getDispImgPathTypeB())) {
                        deleteGoodsImg(goodsDispImageVO.getDispImgPathTypeB(), goodsDispImageVO.getDispImgNmTypeB());
                    }
                    if (!StringUtils.isEmpty(goodsDispImageVO.getDispImgNmTypeC())
                            && !StringUtils.isEmpty(goodsDispImageVO.getDispImgPathTypeC())) {
                        deleteGoodsImg(goodsDispImageVO.getDispImgPathTypeC(), goodsDispImageVO.getDispImgNmTypeC());
                    }
                    if (!StringUtils.isEmpty(goodsDispImageVO.getDispImgNmTypeD())
                            && !StringUtils.isEmpty(goodsDispImageVO.getDispImgPathTypeD())) {
                        deleteGoodsImg(goodsDispImageVO.getDispImgPathTypeD(), goodsDispImageVO.getDispImgNmTypeD());
                    }
                    if (!StringUtils.isEmpty(goodsDispImageVO.getDispImgNmTypeE())
                            && !StringUtils.isEmpty(goodsDispImageVO.getDispImgPathTypeE())) {
                        deleteGoodsImg(goodsDispImageVO.getDispImgPathTypeE(), goodsDispImageVO.getDispImgNmTypeE());
                    }
                } catch (Exception e) {
                    log.debug("{}", e);
                }
            }
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * selectGoodsNotifyItemList(net.danvi.dmall.biz.app.goods.model.
     * GoodsNotifySO)
     */
    @Override
    @Transactional(readOnly = true)
    public List<GoodsNotifyVO> selectGoodsNotifyItemList(GoodsNotifySO so) {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsNotifyItemList", so);
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * getGoodsDetailInfo(GoodsDetailSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<GoodsDisplayInfoVO> getDefaultDisplayInfo(GoodsDetailSO so) {
        ResultModel<GoodsDisplayInfoVO> resultModel = new ResultModel<>();

        // 상품 리사이징 정보는 리사이징에서만 참조(08.31 수정)

        // GoodsDisplayInfoVO goodsDisplayInfoVO =
        // proxyDao.selectOne(MapperConstants.GOODS_MANAGE +
        // "selectGoodsSiteInfo",
        // so);
        // if (1 > goodsDisplayInfoVO.getGoodsDefaultImgWidth() || 1 >
        // goodsDisplayInfoVO.getGoodsDefaultImgHeight()) {
        // goodsDisplayInfoVO.setGoodsDefaultImgWidth(240);
        // goodsDisplayInfoVO.setGoodsDefaultImgHeight(240);
        // }
        // if (1 > goodsDisplayInfoVO.getGoodsListImgWidth() || 1 >
        // goodsDisplayInfoVO.getGoodsListImgHeight()) {
        // goodsDisplayInfoVO.setGoodsListImgWidth(90);
        // goodsDisplayInfoVO.setGoodsListImgHeight(90);
        // }

        GoodsDisplayInfoVO goodsDisplayInfoVO = new GoodsDisplayInfoVO();

        // 성인 인증 설정 여부 확인
        /*PersonCertifyConfigVO vo = new PersonCertifyConfigVO();
        vo.setSiteNo(so.getSiteNo());
        String isAdultCertifyConfig = personCertifyConfigService.checkAdultCertifyConfig(vo);
        goodsDisplayInfoVO.setIsAdultCertifyConfig(isAdultCertifyConfig);*/

        // 고시정보 조회용 SO
        GoodsNotifySO goodsNotifySO = new GoodsNotifySO();

        goodsNotifySO.setGoodsNo(so.getGoodsNo());
        goodsNotifySO.setNotifyNo(so.getNotifyNo());
        // 고시 목록 정보 조회
        /*List<GoodsNotifyVO> notifyList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectNotifyList",goodsNotifySO);
        if (!StringUtils.isEmpty(so.getNotifyNo())) {
            goodsNotifySO.setNotifyNo(so.getNotifyNo());

        } else {
            // 취득한 고시목록의 첫번째 값을 셋팅
            if (notifyList != null && notifyList.size() > 0) {
                goodsNotifySO.setNotifyNo(notifyList.get(0).getNotifyNo());
            }
        }*/

        // 고시 항목 정보 조회
        List<GoodsNotifyVO> goodsNotifyItemList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsNotifyItemList", goodsNotifySO);
        // 고시 정보 값 셋팅
        //goodsDisplayInfoVO.setNotifyOptionList(notifyList);
        goodsDisplayInfoVO.setGoodsNotifyItemList(goodsNotifyItemList);

        /*// filter 정보 조회
        List<FilterVO> goodsFilterList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectFilterList", so);
        goodsDisplayInfoVO.setFilterList(goodsFilterList);*/
        // 브랜드 정보 조회
        List<BrandVO> goodsBrandList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectBrandList", so);
        // 브랜드 값 셋팅
        goodsDisplayInfoVO.setBrandList(goodsBrandList);
        log.info("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ goodsBrandList : {}", goodsBrandList);
        /*// HS코드 정보 조회 : 22.09.23 불필요 정보
        List<HscdVO> hscdList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectHscdList", so);
        // HS코드 값 셋팅
        goodsDisplayInfoVO.setHscdList(hscdList);*/

        // 아이콘 정보 조회
        List<GoodsIconVO> goodsIconList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsIconList", so);
        // 아이콘 정보 값 셋팅
        goodsDisplayInfoVO.setGoodsIconList(goodsIconList);

        /*// 비전체크 군 정보 조회 : 22.09.23 불필요 정보
        List<VisionGunVO> gunList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGunList", so);
        // 비전체크 군 정보 값 셋팅
        goodsDisplayInfoVO.setGunList(gunList);*/

        // 최근 등록 옵션 정보 조회
        List<GoodsOptionVO> goodsOptionList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectRecentOptList",so);
        // 최근 등록 옵션 정보 값 셋팅
        goodsDisplayInfoVO.setGoodsOptionList(goodsOptionList);

        // 리턴모델에 VO셋팅
        resultModel.setData(goodsDisplayInfoVO);
        log.info("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ resultModel : {}", resultModel);
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * getGoodsDetailInfo(GoodsDetailSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<GoodsDetailVO> selectGoodsInfo(GoodsDetailSO so) {
        ResultModel<GoodsDetailVO> resultModel = new ResultModel<>();
        GoodsDetailVO goodsDetailVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsBasicInfo", so);
        log.info("goodsDetailVO = "+goodsDetailVO);
        int avlLen = 0;

        if(goodsDetailVO.getCouponAvlInfo()!=null && !goodsDetailVO.getCouponAvlInfo().equals("")) {
            avlLen = goodsDetailVO.getCouponAvlInfo().split("\\|").length;

            for (int j = 0; j < avlLen; j++) {
                if (j == 0)
                    goodsDetailVO.setCouponApplyAmt(goodsDetailVO.getCouponAvlInfo().split("\\|")[j]);
                if (j == 1)
                    goodsDetailVO.setCouponDcAmt(goodsDetailVO.getCouponAvlInfo().split("\\|")[j]);
                if (j == 2)
                    goodsDetailVO.setCouponDcRate(goodsDetailVO.getCouponAvlInfo().split("\\|")[j]);
                if (j == 3)
                    goodsDetailVO.setCouponDcValue(goodsDetailVO.getCouponAvlInfo().split("\\|")[j]);
                if (j == 4)
                    goodsDetailVO.setCouponBnfCd(goodsDetailVO.getCouponAvlInfo().split("\\|")[j]);
                if (j == 5)
                    goodsDetailVO.setCouponBnfValue(goodsDetailVO.getCouponAvlInfo().split("\\|")[j]);
                if (j == 6)
                    goodsDetailVO.setCouponBnfTxt(goodsDetailVO.getCouponAvlInfo().split("\\|")[j]);
            }
        }
        if (goodsDetailVO.getGoodsTypeCd() == null && goodsDetailVO.getCtgName() != null) {

            if(goodsDetailVO.getCtgName().contains("안경테")) {
                goodsDetailVO.setGoodsTypeCd("01");
            } else if(goodsDetailVO.getCtgName().contains("선글라스")) {
                goodsDetailVO.setGoodsTypeCd("02");
            } else if(goodsDetailVO.getCtgName().contains("안경렌즈")) {
                goodsDetailVO.setGoodsTypeCd("03");
            } else if(goodsDetailVO.getCtgName().contains("콘택트렌즈")) {
                goodsDetailVO.setGoodsTypeCd("04");
            }
        }
        //lucyfilter unescape
        //goodsDetailVO.setGoodsNm(XssPreventer.unescape(goodsDetailVO.getGoodsNm()));
        //goodsDetailVO.setPrWords(XssPreventer.unescape(goodsDetailVO.getPrWords()));

        if (goodsDetailVO == null) {
            return resultModel;
        }


        // 단품 정보 조회
        if ("Y".equals(goodsDetailVO.getMultiOptYn())) {
            List<GoodsItemVO> goodsItemList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsItemInfo",so);
            goodsDetailVO.setGoodsItemList(goodsItemList);

            List<Map<String, Object>> optionMapList = new ArrayList<>();
            List<GoodsOptionVO> goodsOptionList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsOption", so);
            Map<String, Object> goodsOptionMap = null;
            for (GoodsOptionVO goodsOption : goodsOptionList) {
                goodsOptionMap = new HashMap<>();
                goodsOptionMap.put("optNo", goodsOption.getOptNo());
                goodsOptionMap.put("optNm", goodsOption.getOptNm());
                // goodsOptionMap.put("regSeq", goodsOption.getRegSeq());

                List<Map<String, Object>> attrMapList = new ArrayList<>();
                if (!StringUtil.isEmpty(goodsOption.getAttrNoArr())) {
                    String[] attrNoArr = (goodsOption.getAttrNoArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                    String[] attrNmArr = (goodsOption.getAttrNmArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                    Map<String, Object> attrMap = null;
                    for (int i = 0; i < attrNoArr.length; i++) {
                        String attrNm = (attrNmArr.length < i + 1) ? "" : attrNmArr[i];

                        attrMap = new HashMap<>();
                        attrMap.put("attrNo", attrNoArr[i]);
                        attrMap.put("attrNm", attrNm);
                        attrMap.put("registFlag", "L");
                        attrMapList.add(attrMap);
                    }
                }
                goodsOptionMap.put("attrValueList", attrMapList);
                optionMapList.add(goodsOptionMap);
            }
            goodsDetailVO.setGoodsOptionList(optionMapList);
        }

        // 추가 옵션 삭제
        // 추가 옵션 정보 조회
        // if ("Y".equals(goodsDetailVO.getAddOptUseYn())) {
        /*List<GoodsAddOptionVO> goodsAddOptionList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsAddOptInfo", so);
        // 추가옵션에 설정된 추가옵션 상세 정보는 ','로 구분자인 Str형태로 DB에서 취득
        // ',' 구분자로 배열을 취득하여 List 형태로 재가공한다.
        if (goodsAddOptionList != null) {
            List<GoodsAddOptionDtlVO> goodsAddOptDtlList = null;
            for (GoodsAddOptionVO goodsAddOption : goodsAddOptionList) {
                goodsAddOptDtlList = new ArrayList<>();
                String addOptDtlSeq = goodsAddOption.getAddOptDtlSeqArr();
                if (StringUtils.isNotEmpty(addOptDtlSeq)) {
                    String[] addOptDtlSeqArr = addOptDtlSeq.split(DELIMETER_FOR_GROUP_CONCAT);
                    String[] addOptValueArr = (goodsAddOption.getAddOptValueArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                    String[] addOptAmtChgCdArr = (goodsAddOption.getAddOptAmtChgCdArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                    String[] addOptAmtArr = (goodsAddOption.getAddOptAmtArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                    String[] optVerArr = (goodsAddOption.getOptVerArr()).split(DELIMETER_FOR_GROUP_CONCAT);

                    GoodsAddOptionDtlVO goodsAddOptionDtl = null;
                    for (int i = 0; i < addOptDtlSeqArr.length; i++) {
                        goodsAddOptionDtl = new GoodsAddOptionDtlVO();
                        goodsAddOptionDtl.setGoodsNo(goodsAddOption.getGoodsNo());
                        goodsAddOptionDtl.setAddOptNo(goodsAddOption.getAddOptNo());
                        goodsAddOptionDtl.setAddOptDtlSeq(Long.valueOf(addOptDtlSeqArr[i]));
                        goodsAddOptionDtl.setAddOptValue((addOptValueArr.length < i + 1) ? "" : addOptValueArr[i]);
                        goodsAddOptionDtl.setAddOptAmtChgCd((addOptAmtChgCdArr.length < i + 1) ? "" : addOptAmtChgCdArr[i]);
                        goodsAddOptionDtl.setAddOptAmt((addOptAmtArr.length < i + 1) ? "" : addOptAmtArr[i]);
                        goodsAddOptionDtl.setOptVer((optVerArr.length < i + 1) ? "" : optVerArr[i]);
                        goodsAddOptionDtl.setRegistFlag("L");
                        goodsAddOptDtlList.add(goodsAddOptionDtl);
                    }
                }
                goodsAddOption.setAddOptionValueList(goodsAddOptDtlList);
            }
        }
        goodsDetailVO.setGoodsAddOptionList(goodsAddOptionList);*/
        // }

        String goodsNo = so.getGoodsNo();

        // 상품 카테고리 정보 설정
        // 상품에 설정된 카테고리 정보는 ','로 구분자인 Str형태로 DB에서 취득
        // ',' 구분자로 배열을 취득하여 List 형태로 재가공한다.
        List<GoodsCtgVO> goodsCtgList = new ArrayList<>();
        String ctgNoStr = goodsDetailVO.getCtgNoArr();
        if (StringUtils.isNotEmpty(ctgNoStr)) {
            String[] ctgNoArr = ctgNoStr.split(DELIMETER_FOR_GROUP_CONCAT);
            String[] ctgCmsRateArr = (goodsDetailVO.getCtgCmsRateArr()).split(DELIMETER_FOR_GROUP_CONCAT);
            String[] ctgNameArr = (goodsDetailVO.getCtgNameArr()).split(DELIMETER_FOR_GROUP_CONCAT);
            String[] dlgtCtgYnArr = (goodsDetailVO.getDlgtCtgYnArr()).split(DELIMETER_FOR_GROUP_CONCAT);


            GoodsCtgVO goodsCtg = null;
            for (int i = 0; i < ctgNoArr.length; i++) {
                goodsCtg = new GoodsCtgVO();
                goodsCtg.setGoodsNo(goodsNo);
                goodsCtg.setCtgNo(ctgNoArr[i]);
                goodsCtg.setCtgDisplayNm((ctgNameArr.length < i + 1) ? "" : ctgNameArr[i]);
                goodsCtg.setDlgtCtgYn((dlgtCtgYnArr.length < i + 1) ? "" : dlgtCtgYnArr[i]);
                goodsCtg.setExpsYn("Y");
                goodsCtg.setRegistFlag("U");
                goodsCtg.setExpsPriorRank(String.valueOf(i));
                goodsCtg.setCtgCmsRate((ctgNameArr.length < i + 1) ? "0" : ctgCmsRateArr[i]);
                goodsCtgList.add(goodsCtg);
            }
        }

        log.info("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ goodsCtgList : {}", goodsCtgList);
        goodsDetailVO.setGoodsCtgList(goodsCtgList);

        try {
             //내부광고/배너분석 용
            //HttpServletRequest request = HttpUtil.getHttpServletRequest();
            List<GoodsIconVO> goodsIconList = new ArrayList<>();
            if (StringUtils.isNotEmpty(goodsDetailVO.getIconArray())) {
                String[] goodsIconArr = goodsDetailVO.getIconArray().split(DELIMETER_FOR_GROUP_CONCAT);
                GoodsIconVO iconVO = null;
                for (int i = 0; i < goodsIconArr.length; i++) {
                    iconVO = new GoodsIconVO();
                    iconVO.setIconNo(Long.parseLong(goodsIconArr[i]));
                    iconVO.setRegistFlag("U");
                    goodsIconList.add(iconVO);
                    /*if(goodsIconArr[i].equals("1")){        //NEW
                        request.setAttribute("http_OZ","NEW");
                    }else if(goodsIconArr[i].equals("5")){  //BEST
                        request.setAttribute("http_OZ","BEST");
                    }*/
                }
            } else {

            }
            log.info("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ goodsIconList : {}", goodsIconList);
            goodsDetailVO.setGoodsIconList(goodsIconList);
        }catch(Exception e){

        }
        //비전체크 군 리스트
       /*List<VisionGunVO> gunList = new ArrayList<>();
        if (StringUtils.isNotEmpty(goodsDetailVO.getGunArray())) {
            String[] goodsGunArr = goodsDetailVO.getGunArray().split(DELIMETER_FOR_GROUP_CONCAT);
            VisionGunVO gunVO = null;
            for (int i = 0; i < goodsGunArr.length; i++) {
                gunVO = new VisionGunVO();
                gunVO.setGunNo(Integer.parseInt(goodsGunArr[i]));
                gunVO.setRegistFlag("U");
                gunList.add(gunVO);
            }
        }
        goodsDetailVO.setGunList(gunList);*/

        // 카테고리 레벨별 정보를 취득
        if (!StringUtil.isEmpty(goodsDetailVO.getGoodsCtgNoArr())) {
            String[] goodsCtgNoArr = (goodsDetailVO.getGoodsCtgNoArr()).split(",");
            if (goodsCtgNoArr.length > 0) {
                goodsDetailVO.setGoodsCtgNo1(goodsCtgNoArr[0]);
            }
            if (goodsCtgNoArr.length > 1) {
                goodsDetailVO.setGoodsCtgNo2(goodsCtgNoArr[1]);
            }
            if (goodsCtgNoArr.length > 2) {
                goodsDetailVO.setGoodsCtgNo3(goodsCtgNoArr[2]);
            }
            if (goodsCtgNoArr.length > 3) {
                goodsDetailVO.setGoodsCtgNo4(goodsCtgNoArr[3]);
            }
        }

        // 관련 상품 카테고리 레벨별 정보를 취득
        if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsApplyCtgNoArr())) {
            String[] goodsCtgNoArr = (goodsDetailVO.getRelateGoodsApplyCtgNoArr()).split(DELIMETER_FOR_GROUP_CONCAT);
            String[] goodsCtgNmArr = (goodsDetailVO.getRelateGoodsApplyCtgNmArr()).split(DELIMETER_FOR_GROUP_CONCAT);

            if (goodsCtgNoArr.length > 0 && goodsCtgNmArr.length > 0) {
                goodsDetailVO.setRelateGoodsApplyCtgNo1(goodsCtgNoArr[0]);
                goodsDetailVO.setRelateGoodsApplyCtgNm1(goodsCtgNmArr[0]);
            }
            if (goodsCtgNoArr.length > 1 && goodsCtgNmArr.length > 1) {
                goodsDetailVO.setRelateGoodsApplyCtgNo2(goodsCtgNoArr[1]);
                goodsDetailVO.setRelateGoodsApplyCtgNm2(goodsCtgNmArr[1]);
            }
            if (goodsCtgNoArr.length > 2 && goodsCtgNmArr.length > 2) {
                goodsDetailVO.setRelateGoodsApplyCtgNo3(goodsCtgNoArr[2]);
                goodsDetailVO.setRelateGoodsApplyCtgNm3(goodsCtgNmArr[2]);
            }
            if (goodsCtgNoArr.length > 3 && goodsCtgNmArr.length > 3) {
                goodsDetailVO.setRelateGoodsApplyCtgNo4(goodsCtgNoArr[3]);
                goodsDetailVO.setRelateGoodsApplyCtgNm4(goodsCtgNmArr[3]);
            }
        }

        // 관련 상품 처리 ('3'(관련상품 없음)이 아닐 경우)
        if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsApplyTypeCd())) {
            // 관련 상품 직접 선정의 경우
            if ("2".equals(goodsDetailVO.getRelateGoodsApplyTypeCd())) {
                List<GoodsVO> relateGoodsList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectRelateGoodsList", so);
                goodsDetailVO.setRelateGoodsList(relateGoodsList);

            } else if ("1".equals(goodsDetailVO.getRelateGoodsApplyTypeCd())) {
                GoodsSO goodsSo = new GoodsSO();
                goodsSo.setSiteNo(so.getSiteNo());

                // 관련 상품 카테고리 1
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsApplyCtgNo1())) {
                    goodsSo.setSearchCtg1(goodsDetailVO.getRelateGoodsApplyCtgNo1());
                }
                // 관련 상품 카테고리 2
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsApplyCtgNo2())) {
                    goodsSo.setSearchCtg1(goodsDetailVO.getRelateGoodsApplyCtgNo2());
                }
                // 관련 상품 카테고리 3
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsApplyCtgNo3())) {
                    goodsSo.setSearchCtg1(goodsDetailVO.getRelateGoodsApplyCtgNo3());
                }
                // 관련 상품 카테고리 4
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsApplyCtgNo4())) {
                    goodsSo.setSearchCtg1(goodsDetailVO.getRelateGoodsApplyCtgNo4());
                }
                // 관련 상품 판매가격 시작
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsSalePriceStart())) {
                    goodsSo.setSearchPriceFrom(goodsDetailVO.getRelateGoodsSalePriceStart().replaceAll(",", ""));
                }
                // 관련 상품 판매가격 끝
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsSalePriceEnd())) {
                    goodsSo.setSearchPriceTo(goodsDetailVO.getRelateGoodsSalePriceEnd().replaceAll(",", ""));
                }
                // 판매상태
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsSaleStatusCd())) {
                    String statusCd = goodsDetailVO.getRelateGoodsSaleStatusCd();
                    if (!"0".equals(statusCd)) {
                        goodsSo.setGoodsStatus(new String[] { statusCd });
                    }
                }
                // 전시상태
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsDispStatusCd())) {
                    String dispCd = goodsDetailVO.getRelateGoodsDispStatusCd();
                    if ("2".equals(dispCd)) {
                        goodsSo.setGoodsDisplay(new String[] { "Y" });
                    } else if ("3".equals(dispCd)) {
                        goodsSo.setGoodsDisplay(new String[] { "N" });
                    }
                }
                // 정렬 순서
                if (!StringUtil.isEmpty(goodsDetailVO.getRelateGoodsAutoExpsSortCd())) {
                    switch (goodsDetailVO.getRelateGoodsAutoExpsSortCd()) {
                    case "01":
                        goodsSo.setSidx("REG_DTTM");
                        break;
                    case "02":
                        goodsSo.setSidx("ACCM_SALE_AMT");
                        break;
                    case "03":
                        goodsSo.setSidx("ACCM_SALE_CNT");
                        break;
                    case "04":
                        goodsSo.setSidx("ACCM_GOODSLETT_CNT");
                        break;
                    case "05":
                        goodsSo.setSidx("BASKET_SET_CNT");
                        break;
                    case "06":
                        goodsSo.setSidx("FAVGOODS_SET_CNT");
                        break;
                    case "07":
                        goodsSo.setSidx("GOODS_INQ_CNT");
                        break;
                    }
                    goodsSo.setSord("DESC");
                }

                int viewGoodsCnt = 5;
                goodsSo.setLimit(0);
                goodsSo.setSaleYn("Y");
                String goodsDisplay[] = { "Y" }; // 전시여부
                goodsSo.setGoodsDisplay(goodsDisplay);

                goodsSo.setOffset(viewGoodsCnt + 1);

                if(goodsSo.getSearchCtg1() == null || goodsSo.getSearchCtg1().equals("")){
                    goodsSo.setSearchCtg1(goodsDetailVO.getGoodsCtgNo1());
                }


                //List<GoodsVO> relateGoodsList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsListPaging", goodsSo);
                List<GoodsVO> relateGoodsList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsRelListPaging", goodsSo);

                // log.debug("=================> KWT 1:" + relateGoodsList);

                if (relateGoodsList != null && relateGoodsList.size() > 0) {
                    int removeIdx = -1;
                    for (int i = 0; i < relateGoodsList.size(); i++) {
                        GoodsVO vo = relateGoodsList.get(i);
                        if (so.getGoodsNo().equals(vo.getGoodsNo())) {
                            removeIdx = i;
                        }
                    }
                    if (removeIdx < 0 && relateGoodsList.size() > viewGoodsCnt) {
                        removeIdx = viewGoodsCnt;
                    }
                    if (removeIdx > -1) {
                        relateGoodsList.remove(removeIdx);
                    }
                }

                log.info("=================> relateGoodsList = " + relateGoodsList);

                goodsDetailVO.setRelateGoodsList(relateGoodsList);

            }
        }

        //비슷한 상품 조회
        GoodsSO gs = new GoodsSO();
        BeanUtils.copyProperties(so, gs);
        String goodsDisplay[] = { "Y" }; // 전시여부
        gs.setGoodsDisplay(goodsDisplay);
        gs.setLimit(0);
        gs.setSaleYn("Y");
        gs.setOffset(6);
        // 판매순
        gs.setSidx("ACCM_SALE_AMT");
        gs.setSord("DESC");

        gs.setSearchCtg1(goodsDetailVO.getGoodsCtgNo1());
        gs.setSearchCtg2(goodsDetailVO.getGoodsCtgNo2());
        gs.setSearchCtg3(goodsDetailVO.getGoodsCtgNo3());
        gs.setSearchCtg4(goodsDetailVO.getGoodsCtgNo4());

        /*
            // 신상품순
            gs.setSidx("REG_DTTM");
            gs.setSord("DESC");
            // 낮은가격순
            gs.setSidx("SALE_PRICE");
            gs.setSord("ASC");
            // 높은가격순
             gs.setSidx("SALE_PRICE");
            gs.setSord("DESC");
            // 상품평 많은순
            gs.setSidx("ACCM_GOODSLETT_CNT");
            gs.setSord("DESC");
        */

        /*List<GoodsVO> similarGoodsList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsListPaging", gs);
        goodsDetailVO.setSimilarGoodsList(similarGoodsList);*/


        // 고시정보 설정
        // List<GoodsNotifyVO> goodsNotifyList = new ArrayList<>();
        List<Map<String, String>> goodsNotifyList = new ArrayList<>();
        String notifyItemNoStr = goodsDetailVO.getNotifyItemNoArr();
        if (StringUtils.isNotEmpty(notifyItemNoStr)) {
            String[] notifyItemNoArr = notifyItemNoStr.split(DELIMETER_FOR_GROUP_CONCAT);
            String[] notifyItemValueArr = (goodsDetailVO.getNotifyItemValueArr()).split(DELIMETER_FOR_GROUP_CONCAT);

            Map<String, String> notifyInfo = null;
            for (int i = 0; i < notifyItemNoArr.length; i++) {
                // 값이 없을 경우 Array에 설정 안됨
                String itemValue = (notifyItemValueArr.length < i + 1) ? "" : notifyItemValueArr[i];
                notifyInfo = new HashMap<>();
                notifyInfo.put("itemNo", notifyItemNoArr[i]);
                notifyInfo.put("itemValue", itemValue);
                notifyInfo.put("notifyNo", goodsDetailVO.getNotifyNo());
                notifyInfo.put("goodsNo", goodsNo);
                notifyInfo.put("registFlag", "L");

                goodsNotifyList.add(notifyInfo);
            }
        }
        goodsDetailVO.setGoodsNotifyList(goodsNotifyList);

        List<GoodsImageDtlVO> goodsImageInfoList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsImageInfo", so);
        long prevImgSetNo = -1;
        Map<String, Object> imgSetMap = null;
        Map<String, Object> imgDtlMap = null;
        List<Map<String, Object>> imgSetList = new ArrayList<>();
        List<Map<String, Object>> imgDtlList = null;
        for (GoodsImageDtlVO goodsImageInfo : goodsImageInfoList) {
            long goodsImgSetNo = goodsImageInfo.getGoodsImgsetNo();
            if (prevImgSetNo != goodsImgSetNo) {
                imgSetMap = new HashMap<>();
                imgSetMap.put("goodsNo", goodsImageInfo.getGoodsNo());
                imgSetMap.put("goodsImgsetNo", goodsImgSetNo);
                imgSetMap.put("dlgtImgYn", goodsImageInfo.getDlgtImgYn());
                imgSetMap.put("registFlag", "L");

                imgDtlList = new ArrayList<>();
                imgSetMap.put("goodsImageDtlList", imgDtlList);
                imgSetList.add(imgSetMap);
                prevImgSetNo = goodsImageInfo.getGoodsImgsetNo();
            }

            if (imgSetList != null && imgSetList.size() > 0) {
                Map<String, Object> targetMap = null;
                for (Map<String, Object> imgSet : imgSetList) {
                    if (goodsImgSetNo == (long) imgSet.get("goodsImgsetNo")) {
                        targetMap = imgSet;
                        break;
                    }
                }
                imgDtlMap = new HashMap<>();
                imgDtlMap.put("goodsImgType", goodsImageInfo.getGoodsImgType());
                imgDtlMap.put("imgPath", goodsImageInfo.getImgPath());
                imgDtlMap.put("imgNm", goodsImageInfo.getImgNm());
                imgDtlMap.put("imgWidth", goodsImageInfo.getImgWidth());
                imgDtlMap.put("imgHeight", goodsImageInfo.getImgHeight());
                imgDtlMap.put("imgSize", goodsImageInfo.getImgSize());

                imgDtlMap.put("imgUrl", "/image/image-view?type=GOODSDTL&id1=" + goodsImageInfo.getImgPath() + "_"+ goodsImageInfo.getImgNm());
                if (null != goodsImageInfo.getImgNm()) {
                    String imgNm = goodsImageInfo.getImgNm();
                    String fileNm = imgNm.substring(0, imgNm.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;

                    log.info("$$$$$$$$$$$$$$$$ imgNm :" + imgNm);
                    log.info("$$$$$$$$$$$$$$$$ fileNm :" + fileNm);

                    imgDtlMap.put("thumbUrl","/image/image-view?type=GOODSDTL&id1=" + goodsImageInfo.getImgPath() + "_" + fileNm);
                }
                imgDtlMap.put("registFlag", "L");
                List<Map<String, Object>> tempImgDtlList = (List<Map<String, Object>>) targetMap.get("goodsImageDtlList");
                if (tempImgDtlList != null) {
                    tempImgDtlList.add(imgDtlMap);
                }
            }
        }
        goodsDetailVO.setGoodsImageSetList(imgSetList);


        /*List<WearImageDtlVO> wearImageInfoList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectWearImageInfo", so);
        prevImgSetNo = -1;
        imgSetMap = null;
        imgDtlMap = null;
        imgSetList = new ArrayList<>();
        imgDtlList = null;
        for (WearImageDtlVO wearImageInfo : wearImageInfoList) {
            long wearImgSetNo = wearImageInfo.getWearImgsetNo();
            if (prevImgSetNo != wearImgSetNo) {
                imgSetMap = new HashMap<>();
                imgSetMap.put("goodsNo", wearImageInfo.getGoodsNo());
                imgSetMap.put("wearImgsetNo", wearImgSetNo);
                *//*imgSetMap.put("dlgtImgYn", wearImageInfo.getDlgtImgYn());*//*
                imgSetMap.put("registFlag", "L");

                imgDtlList = new ArrayList<>();
                imgSetMap.put("goodsWearImageList", imgDtlList);
                imgSetList.add(imgSetMap);
                prevImgSetNo = wearImageInfo.getWearImgsetNo();
            }

            if (imgSetList != null && imgSetList.size() > 0) {
                Map<String, Object> targetMap = null;
                for (Map<String, Object> imgSet : imgSetList) {
                    if (wearImgSetNo == (long) imgSet.get("wearImgsetNo")) {
                        targetMap = imgSet;
                        break;
                    }
                }
                imgDtlMap = new HashMap<>();
                imgDtlMap.put("wearImgType", wearImageInfo.getWearImgType());
                imgDtlMap.put("imgPath", wearImageInfo.getImgPath());
                imgDtlMap.put("imgNm", wearImageInfo.getImgNm());
                imgDtlMap.put("imgWidth", wearImageInfo.getImgWidth());
                imgDtlMap.put("imgHeight", wearImageInfo.getImgHeight());
                imgDtlMap.put("imgSize", wearImageInfo.getImgSize());

                imgDtlMap.put("imgUrl", CommonConstants.IMAGE_TEMP_GOODS_URL + wearImageInfo.getImgPath() + "_"+ wearImageInfo.getImgNm());

                imgDtlMap.put("wearGoodsNm",wearImageInfo.getWearGoodsNm());
                imgDtlMap.put("colorValue",wearImageInfo.getColorValue());
                imgDtlMap.put("wearCycle",wearImageInfo.getWearCycle());
                imgDtlMap.put("grpDmtr",wearImageInfo.getGrpDmtr());
                imgDtlMap.put("materialValue",wearImageInfo.getMaterialValue());
                imgDtlMap.put("uvInterceptionValue",wearImageInfo.getUvInterceptionValue());
                imgDtlMap.put("qttValue",wearImageInfo.getQttValue());
                imgDtlMap.put("salePriceValue",wearImageInfo.getSalePriceValue());
                imgDtlMap.put("mktBnfValue",wearImageInfo.getMktBnfValue());


                if (null != wearImageInfo.getImgNm()) {
                    String imgNm = wearImageInfo.getImgNm();
                    String fileNm = imgNm.substring(0, imgNm.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;

                    log.info("$$$$$$$$$$$$$$$$ imgNm :" + imgNm);
                    log.info("$$$$$$$$$$$$$$$$ fileNm :" + fileNm);

                    imgDtlMap.put("thumbUrl","/image/image-view?type=GOODSDTL&id1=" + wearImageInfo.getImgPath() + "_" + fileNm);
                }
                imgDtlMap.put("registFlag", "L");
                List<Map<String, Object>> tempImgDtlList = (List<Map<String, Object>>) targetMap.get("goodsWearImageList");
                if (tempImgDtlList != null) {
                    tempImgDtlList.add(imgDtlMap);
                }
            }
        }
        goodsDetailVO.setGoodsWearImageSetList(imgSetList);*/

        // 상품 필터 정보 설정
        List<GoodsFilterVO> goodsFilterList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsFilter", so);
        if (goodsFilterList != null && goodsFilterList.size() > 0) {
            goodsDetailVO.setGoodsFilterList(goodsFilterList);
        }
        if(goodsDetailVO.getGoodsNo() != null && goodsDetailVO.getGoodsNo() != ""
                && goodsDetailVO.getGoodsTypeCd() != null && goodsDetailVO.getGoodsTypeCd().equals("04")) { // contact lens edit
            if (goodsFilterList != null && goodsFilterList.size() > 0) {
                FilterSO filterSO = new FilterSO();
                filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                filterSO.setFilterNo(goodsFilterList.get(0).getFilterNo());
                FilterVO goodsFilterLvl2 = proxyDao.selectOne(MapperConstants.FILTER_MANAGE + "selectFilterLvl2", filterSO);
                //log.info("$$$$$$$$$$$$$$$$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& goodsFilterLvl2 :" + goodsFilterLvl2);
                goodsDetailVO.setFilterNoLvl2(goodsFilterLvl2.getUpFilterNo());
            }
        }

        // face code 정보 설정
        GoodsFaceCdVO goodsFaceCdVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsFace", so);

        if (goodsFaceCdVO != null) {
            goodsDetailVO.setFdSize(goodsFaceCdVO.getFdSize());
            goodsDetailVO.setFdShape(goodsFaceCdVO.getFdShape());
            goodsDetailVO.setFdTone(goodsFaceCdVO.getFdTone());
            goodsDetailVO.setFdStyle(goodsFaceCdVO.getFdStyle());
            goodsDetailVO.setEdShape(goodsFaceCdVO.getEdShape());
            goodsDetailVO.setEdSize(goodsFaceCdVO.getEdSize());
            goodsDetailVO.setEdStyle(goodsFaceCdVO.getEdStyle());
            goodsDetailVO.setEdColor(goodsFaceCdVO.getEdColor());
        }
        log.info("$$$$$$$$$$$$$$$$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& goodsFaceCdVO :" + goodsFaceCdVO);
        log.info("$$$$$$$$$$$$$$$$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& goodsDetailVO :" + goodsDetailVO);
        // 선택된 안경테, 선글라스 사이즈 정보 설정
        if(goodsDetailVO.getGoodsTypeCd() != null && (goodsDetailVO.getGoodsTypeCd().equals("01") || goodsDetailVO.getGoodsTypeCd().equals("02"))) {
            GoodsSizeCdVO sizeCdVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsSize", goodsDetailVO);
            if (sizeCdVO != null) {
                goodsDetailVO.setGoodsNo(sizeCdVO.getGoodsNo());
                goodsDetailVO.setFullSize(sizeCdVO.getFullSize());
                goodsDetailVO.setBridgeSize(sizeCdVO.getBridgeSize());
                goodsDetailVO.setHorizontalLensSize(sizeCdVO.getHorizontalLensSize());
                goodsDetailVO.setVerticalLensSize(sizeCdVO.getVerticalLensSize());
                goodsDetailVO.setTempleSize(sizeCdVO.getTempleSize());
            }
        }

        // 선택된 사은품 정보 설정
        List<GoodsFreebieGoodsVO> freebieGoodsList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsFreebie", goodsDetailVO);
        if (freebieGoodsList != null && freebieGoodsList.size() > 0) {
            goodsDetailVO.setFreebieGoodsList(freebieGoodsList);
        }

        //상품 조회수 update front조회시에만 처리
        HttpServletRequest request =  HttpUtil.getHttpServletRequest();
        String referer = request.getHeader("referer");
        if(referer!=null && referer.indexOf("/front")>-1) {
            GoodsPO po = new GoodsPO();
            po.setGoodsNo(so.getGoodsNo());
            updateGoodsInqCnt(po);
        }

        goodsDetailVO.setCtgNoArr(null);
        goodsDetailVO.setCtgNameArr(null);
        goodsDetailVO.setDlgtCtgYnArr(null);
        goodsDetailVO.setIconArray(null);
        goodsDetailVO.setNotifyItemNoArr(null);
        goodsDetailVO.setNotifyItemValueArr(null);

        // 리턴모델에 VO셋팅
        resultModel.setData(goodsDetailVO);
        return resultModel;

    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<GoodsDetailVO> selectVegemilGoodsInfo(GoodsDetailSO so) {
        ResultModel<GoodsDetailVO> resultModel = new ResultModel<>();
        GoodsDetailVO goodsDetailVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsBasicInfo", so);
        int avlLen = 0;

        if (goodsDetailVO == null) {
            return resultModel;
        }

        // 단품 정보 조회
        if ("Y".equals(goodsDetailVO.getMultiOptYn())) {
            List<GoodsItemVO> goodsItemList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsItemInfo",so);
            goodsDetailVO.setGoodsItemList(goodsItemList);

            List<Map<String, Object>> optionMapList = new ArrayList<>();
            List<GoodsOptionVO> goodsOptionList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsOption", so);
            Map<String, Object> goodsOptionMap = null;
            for (GoodsOptionVO goodsOption : goodsOptionList) {
                goodsOptionMap = new HashMap<>();
                goodsOptionMap.put("optNo", goodsOption.getOptNo());
                goodsOptionMap.put("optNm", goodsOption.getOptNm());
                // goodsOptionMap.put("regSeq", goodsOption.getRegSeq());

                List<Map<String, Object>> attrMapList = new ArrayList<>();
                if (!StringUtil.isEmpty(goodsOption.getAttrNoArr())) {
                    String[] attrNoArr = (goodsOption.getAttrNoArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                    String[] attrNmArr = (goodsOption.getAttrNmArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                    Map<String, Object> attrMap = null;
                    for (int i = 0; i < attrNoArr.length; i++) {
                        String attrNm = (attrNmArr.length < i + 1) ? "" : attrNmArr[i];

                        attrMap = new HashMap<>();
                        attrMap.put("attrNo", attrNoArr[i]);
                        attrMap.put("attrNm", attrNm);
                        attrMap.put("registFlag", "L");
                        attrMapList.add(attrMap);
                    }
                }
                goodsOptionMap.put("attrValueList", attrMapList);
                optionMapList.add(goodsOptionMap);
            }
            goodsDetailVO.setGoodsOptionList(optionMapList);
        }

        // 리턴모델에 VO셋팅
        resultModel.setData(goodsDetailVO);
        return resultModel;

    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<Map<String, Object>> selectRecentOption(GoodsOptionVO vo) throws Exception {
        ResultListModel<Map<String, Object>> result = new ResultListModel<>();
        List<Map<String, Object>> optionMapList = new ArrayList<>();
        List<GoodsOptionVO> goodsOptionList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectRecentOption",vo);
        Map<String, Object> goodsOptionMap = null;
        for (GoodsOptionVO goodsOption : goodsOptionList) {
            goodsOptionMap = new HashMap<>();
            // goodsOptionMap.put("optNo", goodsOption.getOptNo());
            goodsOptionMap.put("optNm", goodsOption.getOptNm());
            goodsOptionMap.put("registFlag", "I");
            goodsOptionMap.put("regSeq", "0");

            List<Map<String, Object>> attrMapList = new ArrayList<>();
            if (!StringUtil.isEmpty(goodsOption.getAttrNoArr())) {
                String[] attrNoArr = (goodsOption.getAttrNoArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                String[] attrNmArr = (goodsOption.getAttrNmArr()).split(DELIMETER_FOR_GROUP_CONCAT);
                Map<String, Object> attrMap = null;
                for (int i = 0; i < attrNoArr.length; i++) {
                    String attrNm = (attrNmArr.length < i + 1) ? "" : attrNmArr[i];

                    attrMap = new HashMap<>();
                    // attrMap.put("attrNo", attrNoArr[i]);
                    attrMap.put("attrNm", attrNm);
                    attrMap.put("registFlag", "L");
                    attrMapList.add(attrMap);
                }
            }
            goodsOptionMap.put("attrValueList", attrMapList);
            optionMapList.add(goodsOptionMap);
        }

        log.info("size : " + optionMapList.size());
        result.setResultList(optionMapList);
        return result;
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * getGoodsDetailInfo(GoodsDetailSO)
     */
    @Override
    public ResultModel<GoodsVO> getNewGoodsNo(GoodsSO so) {
        ResultModel<GoodsVO> resultModel = new ResultModel<>();
        GoodsVO vo = new GoodsVO();
        String goodsNo = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectNewGoodsNo", so);
        StringBuffer sb = new StringBuffer().append("G").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(goodsNo, "0", 4));

        log.info("$$$$$$$$$$$$$$$$$$$$$$$$$ goodsNo {} " + sb.toString());
        vo.setGoodsNo(sb.toString());
        vo.setEditModeYn("N");
        resultModel.setData(vo);
        log.info("$$$$$$$$$$$$$$$$$$$$$$$$$ getNewGoodsNo resultModel {} " + resultModel);
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * selectGoodsExcelList(GoodsSO)
     */
    @Override
    public ResultListModel<GoodsVO> selectGoodsExcelList(GoodsSO so) {
        ResultListModel<GoodsVO> resultListModel = new ResultListModel<>();
        List<GoodsVO> list = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsExcelList", so);
        resultListModel.setResultList(list);

        return resultListModel;
    }

    @Override
    public ResultModel<GoodsDetailPO> insertGoodsInfo(GoodsDetailPO po) throws Exception {
        ResultModel<GoodsDetailPO> result = new ResultModel<>();

        try {

            /**  [0] 상품 기본 정보 등록 **/
            if (null != po.getSaleStartDt()) {
                po.setSaleStartDt(po.getSaleStartDt().replaceAll("-", ""));
            }
            if (null != po.getSaleEndDt()) {
                po.setSaleEndDt(po.getSaleEndDt().replaceAll("-", ""));
            }

            if (null != po.getDcStartDttm()) {
                po.setDcStartDttm(po.getDcStartDttm().replaceAll("-", ""));
            }
            if (null != po.getDcEndDttm()) {
                po.setDcEndDttm(po.getDcEndDttm().replaceAll("-", ""));
            }

            String targetPath = goodsImageFilePath;
            String sourcePath = goodsTempImageFilePath;

            Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
            targetPath += File.separator + siteNo;
            sourcePath += File.separator + siteNo;

            if (StringUtils.isEmpty(po.getRelateGoodsSalePriceStart())) {
                po.setRelateGoodsSalePriceStart(null);
            }
            if (StringUtils.isEmpty(po.getRelateGoodsSalePriceEnd())) {
                po.setRelateGoodsSalePriceEnd(null);
            }

            String saleYn = "Y";
            // 판매기간 입력 시 판매시작일이 미래일 경우
            // 전시상태 미전시, 상품 판매 상태 판매대기 로 강제 변경
            String saleStatus = po.getGoodsSaleStatusCd();
            String dispYn = po.getDispYn();

            if ("Y".equals(po.getSaleForeverYn())) {
                saleYn = "Y";
                po.setSaleStartDt(null);
                po.setSaleEndDt(null);
            } else {
                if(StringUtils.contains("2,3,4", saleStatus)) {
                    saleYn = "N";

                    Integer timedealGoodsCnt = proxyDao.selectOne(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealTargetGoodsExist", po);
                    if(timedealGoodsCnt > 0) {
                        po.setDelrNo(SessionDetailHelper.getSession().getMemberNo());
                        proxyDao.delete(MapperConstants.PROMOTION_TIMEDEAL + "deleteTimeDealByGoodsNo", po);
                    }
                }
            }

            po.setSaleYn(saleYn);
            po.setGoodsSaleStatusCd(saleStatus);
            po.setDispYn(dispYn);

            // 품절시 장바구니 삭제 여부 취득
            if ("2".equals(po.getGoodsSaleStatusCd())) {
                SiteSO so = new SiteSO();
                so.setSiteNo(po.getSiteNo());
                String soldOutDeleteYn = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectSoldOutDeleteYn", so);
                po.setSoldOutDeleteYn(soldOutDeleteYn);
            }

            /** 상품 기본정보 등록 **/
            //마켓포인트 적립 기본 정책여부 setting...
            /*if(po.getGoodsSvmnPolicyCd()!=null && po.getGoodsSvmnPolicyCd().equals("01")){
                po.setGoodsSvmnPolicyUseYn("Y");
            }else{
                po.setGoodsSvmnPolicyUseYn("N");
            }*/
            if (po.getGoodsStampTypeCd() == null || po.getGoodsStampTypeCd().equals("00")){
                po.setStampYn("N");
            } else {
                po.setStampYn("Y");
            }
            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsBasicInfo", po);

            /**
            * 상품 유형별 속성정보 등록
            * 01	안경테
            * 02	선글라스
            * 03	안경렌즈
            * 04	콘택트렌즈
            * 05	보청기
            * **/
            // 필터 정보 변경
            /*if(po.getGoodsTypeCd()!=null) {
                // 속성정보 삭제
                proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteAttrInfo", po);

                if (po.getGoodsTypeCd().equals("01")) {
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertFramesInfo", po);
                } else if (po.getGoodsTypeCd().equals("02")) {
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertSunglassInfo", po);
                } else if (po.getGoodsTypeCd().equals("03")) {
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGlassesLensInfo", po);
                } else if (po.getGoodsTypeCd().equals("04")) {
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertContactLensInfo", po);
                } else if (po.getGoodsTypeCd().equals("05")) {
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertHearingAidInfo", po);
                } else {

                }
            }*/

            // 비전체크 기능 삭제
            //비전체크 군 삭제후 저장
            /*List<VisionGunVO> gunList = po.getGunList();
            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGunAttr", po);
            if(gunList!=null && gunList.size()>0) {
                for (VisionGunVO gunVo : gunList) {
                    gunVo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGunAttr", gunVo);
                }
            }*/

            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
            	if((po.getMobileModeYn() == null || !po.getMobileModeYn().equals("Y"))
            			&& (po.getGoodsSaleStatusCd() != null
            				&& po.getGoodsSaleStatusCd().equals("2")
            				&& po.getSoldOutDeleteYn() != null
            				&& po.getSoldOutDeleteYn().equals("Y"))){
                    proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsBasketOpt", po);
                    proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsBasket", po);
            	}
            }

            /**  [1] 단품 정보 등록 **/
            // 다중 옵션 여부 취득
            String multiOptYn = po.getMultiOptYn();
            String itemNo = po.getItemNo();
            boolean isNewVersion = false;

            // 다중 옵션의 경우
            if ("Y".equals(multiOptYn)) {
                // 옵션 정보 처리
                Map<String, Long> attrMap = new HashMap<>();
                List<GoodsOptionPO> optionList = po.getOptionList();

                // 새로 설정 된 옵션의 경우, 기존 정보를 삭제한다.
                String changeFlag = po.getChangeFlag();

                if (!StringUtil.isEmpty(changeFlag)) {
                    GoodsOptionPO goodsOptionPO = new GoodsOptionPO();
                    goodsOptionPO.setGoodsNo(po.getGoodsNo());
                    goodsOptionPO.setUseYn("N");
                    // 기존 단품 정보 사용 여부 'N'으로 변경
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateItemUseYnByGoodsNo", goodsOptionPO);
                    // 기존 상품 옵션 정보 삭제
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "deleteGoodsOption", goodsOptionPO);
                }

                if (optionList != null && optionList.size() > 0) {

                    Long regSeq = -1L;
                    // 옵션 새로 생성일 경우 만 옵션 번호를 새로 취득
                    if ("C".equals(po.getChangeFlag())) {
//                        regSeq = bizService.getSequence("OPT_SEQ", po.getSiteNo());
                        regSeq = bizService.getSequence("OPT_SEQ", new Long(0));
                    }

                    // 옵션별 처리
                    for (GoodsOptionPO option : optionList) {
                        if (option != null) {

                            // 새로 설정 된 옵션, 옵션 불러오기의 경우, 모든 옵션을 새로 등록한다.
                            if (!StringUtil.isEmpty(changeFlag)) {
                                option.setRegistFlag("I");
                            }

                            option.setSiteNo(po.getSiteNo());
                            option.setGoodsNo(po.getGoodsNo());
                            option.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                            option.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                            if ("D".equals(option.getRegistFlag()) && !StringUtil.isEmpty(option.getOptNo())) {
                                option.setUseYn("N");
                                isNewVersion = true;
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateOption", option);

                                // 기존 옵션 수정의 경우(기존 옵션은 사용여부를 'N'으로 수정 후 새 옵션을 등록한다.)
                            } else if ("U".equals(option.getRegistFlag()) && !StringUtil.isEmpty(option.getOptNo())) {
                                option.setUseYn("N");
                                isNewVersion = true;
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateOption", option);
                                option.setUseYn("Y");

                                if (CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                                    option.setOptNo(bizService.getSequence("OPT_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertOption", option);
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsOption", option);

                                // 신규 옵션 등록의 경우 (옵션은 수정이 없음, 삭제 or 등록)
                            } else if ("I".equals(option.getRegistFlag())) {
                                if (regSeq > -1) {
                                    option.setRegSeq(regSeq);
                                }
                                option.setUseYn("Y");
                                isNewVersion = true;

                                if (CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                                    option.setOptNo(bizService.getSequence("OPT_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertOption", option);
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsOption", option);
                            }

                            // 옵션 별 속성 리스트 처리
                            List<GoodsOptionAttrPO> optionValueList = option.getOptionValueList();
                            for (GoodsOptionAttrPO optionValue : optionValueList) {
                                // 옵션이 신규등록이면 속성도 등록 (삭제된 속성은 제외)
                                if (!"D".equals(optionValue.getRegistFlag()) && "I".equals(option.getRegistFlag())) {
                                    optionValue.setRegistFlag("I");
                                }

                                optionValue.setOptNo(option.getOptNo());
                                optionValue.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                optionValue.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                                // 속성 삭제의 경우
                                long attrNo = optionValue.getAttrNo();
                                if ("D".equals(optionValue.getRegistFlag()) && attrNo > 0) {
                                    optionValue.setUseYn("N");
                                    isNewVersion = true;
                                    proxyDao.update(MapperConstants.GOODS_MANAGE + "updateAttrUseYn", optionValue);

                                    // 속성 추가의 경우
                                } else if ("I".equals(optionValue.getRegistFlag())) {
                                    optionValue.setUseYn("Y");
                                    isNewVersion = true;

                                    if (CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                                        optionValue.setAttrNo(bizService.getSequence("ATTR_NO"));
                                    }
                                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", optionValue);
                                    attrNo = optionValue.getAttrNo();

                                    // 속성 수정의 경우 (속성명 수정만 가능)
                                } else if ("U".equals(optionValue.getRegistFlag()) && attrNo > 0) {

                                    boolean isDelete = true;
                                    String attrNm = optionValue.getPreAttrNm();
                                    List<GoodsItemPO> goodsItemList = po.getGoodsItemList();
                                    if (goodsItemList != null && goodsItemList.size() > 0) {
                                        for (GoodsItemPO goodsItemPO : goodsItemList) {
                                            if (attrNm.equals(goodsItemPO.getAttrValue1())
                                                    || attrNm.equals(goodsItemPO.getAttrValue2())
                                                    || attrNm.equals(goodsItemPO.getAttrValue3())
                                                    || attrNm.equals(goodsItemPO.getAttrValue4())) {
                                                isDelete = false;
                                                break;
                                            }
                                        }
                                    }
                                    if (isDelete) {
                                        optionValue.setUseYn("N");
                                        proxyDao.update(MapperConstants.GOODS_MANAGE + "updateAttrUseYn", optionValue);
                                    }

                                    optionValue.setUseYn("Y");

                                    if (CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                                        optionValue.setAttrNo(bizService.getSequence("ATTR_NO"));
                                    }
                                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", optionValue);
                                    attrNo = optionValue.getAttrNo();

                                    isNewVersion = true;
                                }
                                attrMap.put(option.getOptNo() + "_" + optionValue.getAttrNm(), attrNo);
                            }
                        }
                    }
                }

                List<GoodsItemPO> goodsItemList = po.getGoodsItemList();
                StringBuffer sb = null;
                if (goodsItemList != null && goodsItemList.size() > 0) {
                    for (GoodsItemPO goodsItemPO : goodsItemList) {
                        Long lAttrVer = null == goodsItemPO.getAttrVer() ? 0L : goodsItemPO.getAttrVer();

                        log.info("goodsItemList goodsItemPO = "+goodsItemPO);
                        goodsItemPO.setGoodsNo(po.getGoodsNo());
                        goodsItemPO.setSiteNo(po.getSiteNo());
                        goodsItemPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                        goodsItemPO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                        goodsItemPO.setItemNm(goodsItemPO.getAttrValue1()+ " " + goodsItemPO.getAttrValue2() + " " + goodsItemPO.getAttrValue3() + " " + goodsItemPO.getAttrValue4());
                        goodsItemPO.setItemNm(goodsItemPO.getItemNm().replaceAll("null", ""));
                        goodsItemPO.setItemNm(goodsItemPO.getItemNm().trim());


                        if ("D".equals(goodsItemPO.getRegistFlag()) && !StringUtil.isEmpty(goodsItemPO.getItemNo())) {
                            // 단품 삭제 처리 (사용여부를 'N'으로 수정)
                            goodsItemPO.setUseYn("N");
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", goodsItemPO);

                            if(StringUtil.isNotEmpty(goodsItemPO.getFilePath()) && StringUtil.isNotEmpty(goodsItemPO.getFileNm())) {
                                deleteGoodsItemImg(goodsItemPO.getFilePath(), goodsItemPO.getFileNm());
                            }

                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsItemImage",goodsItemPO);

                        } else if ("N".equals(goodsItemPO.getRegistFlag())
                                && !StringUtil.isEmpty(goodsItemPO.getItemNo())) {

                            lAttrVer = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectNewAttrVer",goodsItemPO.getItemNo());

                        } else if ("U".equals(goodsItemPO.getRegistFlag())
                                && !StringUtil.isEmpty(goodsItemPO.getItemNo())) {

                            // 단품 정보 수정 (속성이외)
                            updateItemInfo(goodsItemPO, false);

                            if ("Y".equals(goodsItemPO.getStandardPriceYn())) {
                                itemNo = goodsItemPO.getItemNo();
                            }

                        } else if ("I".equals(goodsItemPO.getRegistFlag())) {
                            // 신규등록의 경우
                            if (goodsItemPO.getItemNo() == null) {
                                Long itemSeq = bizService.getSequence("ITEM_NO");
                                sb = new StringBuffer().append("I").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                                goodsItemPO.setItemNo(sb.toString());
                                lAttrVer = 1L;
                                // 기존 속성에 추가의 경우
                            } else {
                                lAttrVer = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectNewAttrVer",goodsItemPO.getItemNo());
                            }
                            goodsItemPO.setSiteNo(po.getSiteNo());
                            goodsItemPO.setGoodsNo(po.getGoodsNo());

                            // proxyDao.insert(MapperConstants.GOODS_MANAGE +
                            // "insertGoodsItemOne", goodsItemPO);
                            updateItemInfo(goodsItemPO, false);

                            // 상품 대표 단품 번호 설정
                            if ("Y".equals(goodsItemPO.getStandardPriceYn())) {
                                itemNo = goodsItemPO.getItemNo();
                            }
                        }

                        if (isNewVersion) {
                            if (!StringUtil.isEmpty(goodsItemPO.getAttrValue1())) {
                                GoodsOptionPO option = optionList.get(0);
                                if (goodsItemPO.getOptNo1() == null) {
                                    goodsItemPO.setOptNo1(option.getOptNo());
                                }
                                goodsItemPO.setAttrNo1(attrMap.get(option.getOptNo() + "_" + goodsItemPO.getAttrValue1()));
                            }

                            if (!StringUtil.isEmpty(goodsItemPO.getAttrValue2())) {
                                GoodsOptionPO option = optionList.get(1);
                                if (goodsItemPO.getOptNo2() == null) {
                                    goodsItemPO.setOptNo2(option.getOptNo());
                                }
                                goodsItemPO.setAttrNo2(attrMap.get(option.getOptNo() + "_" + goodsItemPO.getAttrValue2()));
                            }

                            if (!StringUtil.isEmpty(goodsItemPO.getAttrValue3())) {
                                GoodsOptionPO option = optionList.get(2);
                                if (goodsItemPO.getOptNo3() == null) {
                                    goodsItemPO.setOptNo3(option.getOptNo());
                                }
                                goodsItemPO.setAttrNo3(attrMap.get(option.getOptNo() + "_" + goodsItemPO.getAttrValue3()));
                            }

                            if (!StringUtil.isEmpty(goodsItemPO.getAttrValue4())) {
                                GoodsOptionPO option = optionList.get(3);
                                if (goodsItemPO.getOptNo4() == null) {
                                    goodsItemPO.setOptNo4(option.getOptNo());
                                }
                                goodsItemPO.setAttrNo4(attrMap.get(option.getOptNo() + "_" + goodsItemPO.getAttrValue4()));
                            }
                        }
                        if (lAttrVer > 0) {
                            goodsItemPO.setAttrVer(lAttrVer);
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAttr", goodsItemPO);
                        }
                    }
                }
            } else { // 단일 옵션의 경우

                GoodsOptionPO goodsOptionPO = new GoodsOptionPO();
                goodsOptionPO.setGoodsNo(po.getGoodsNo());
                goodsOptionPO.setUseYn("N");
                // 기존 단품 정보 사용 여부 'N'으로 변경
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateItemUseYnByGoodsNo", goodsOptionPO);
                // 기존 상품 옵션 정보 삭제
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "deleteGoodsOption", goodsOptionPO);

                if (StringUtils.isEmpty(itemNo)) {
                    Long itemSeq = bizService.getSequence("ITEM_NO");
                    StringBuffer sb = new StringBuffer().append("I").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                    itemNo = sb.toString();
                }

                GoodsItemPO itemPO = new GoodsItemPO();
                itemPO.setItemNo(itemNo);
                // 단일 상품의 경우 단품이름에 상품 이름 셋팅
                itemPO.setItemNm(po.getGoodsNm());
                itemPO.setSiteNo(po.getSiteNo());
                itemPO.setGoodsNo(po.getGoodsNo());

                if (po.getCost() == null) {
                    itemPO.setCost(0L);
                } else {
                    itemPO.setCost(po.getCost());
                }
                if (po.getCustomerPrice() == null) {
                    itemPO.setCustomerPrice(0L);
                } else {
                    itemPO.setCustomerPrice(po.getCustomerPrice());
                }
                if (po.getSupplyPrice() == null) {
                    itemPO.setSupplyPrice(0L);
                } else {
                    itemPO.setSupplyPrice(po.getSupplyPrice());
                }
                if (po.getSalePrice() == null) {
                    itemPO.setSalePrice(0L);
                } else {
                    itemPO.setSalePrice(po.getSalePrice());
                }
                if (po.getStockQtt() == null) {
                    itemPO.setStockQtt(0L);
                } else {
                    itemPO.setStockQtt(po.getStockQtt());
                }
                if (po.getSaleQtt() == null) {
                    itemPO.setSaleQtt(0L);
                } else {
                    itemPO.setSaleQtt(po.getSaleQtt());
                }
                if (po.getSepSupplyPriceYn() == null) {
                    itemPO.setSepSupplyPriceYn("N");
                } else {
                    itemPO.setSepSupplyPriceYn(po.getSepSupplyPriceYn());
                }
                if(po.getApplyDavisionStockYn() == null) {
                    itemPO.setApplyDavisionStockYn("N");
                } else {
                    itemPO.setApplyDavisionStockYn(po.getApplyDavisionStockYn());
                }
                if (po.getDcStartDttm() != null) {
                    itemPO.setDcStartDttm(po.getDcStartDttm());
                }
                if (po.getDcEndDttm() != null) {
                    itemPO.setDcEndDttm(po.getDcEndDttm());
                }
                if (po.getDcPriceApplyAlwaysYn() != null) {
                    itemPO.setDcPriceApplyAlwaysYn(po.getDcPriceApplyAlwaysYn());
                }
                /**  단품상품정보 수정 **/
                this.updateItemInfo(itemPO, false);
            }

            /** [2] 대표단품 번호 등록 **/
            if (itemNo != null && !itemNo.equals(po.getItemNo())) {
                po.setItemNo(itemNo);
                proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsItemNo", po);
            }

            // 모바일용 추가 2016-08-18 - 모바일 여부
            // 모바일이 아닐 경우
            if (po.getMobileModeYn() == null || "Y".equals(po.getMobileModeYn()) == false) {
                // 추가 옵션 삭제
                // [3] 추가옵션 처리
                /*String addOptUseYn = po.getAddOptUseYn();
                if ("Y".equals(addOptUseYn)) {
                    List<GoodsAddOptionPO> addOptList = po.getGoodsAddOptionList();
                    for (GoodsAddOptionPO addOpt : addOptList) {
                        addOpt.setGoodsNo(po.getGoodsNo());
                        Long addOptNo = addOpt.getAddOptNo();

                        // 추가옵션 신규 등록의 경우
                        if ("I".equals(addOpt.getRegistFlag())) {
                            addOptNo = bizService.getSequence("ADD_OPT_NO", po.getSiteNo());
                            addOpt.setAddOptNo(addOptNo);
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAddOption", addOpt);

                        } else if ("U".equals(addOpt.getRegistFlag())) {
                            if (!StringUtils.isEmpty(addOpt.getGoodsNo()) && addOpt.getAddOptNo() > 0) {
                                proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsAddOption", addOpt);
                            }

                        } else if ("D".equals(addOpt.getRegistFlag())) {
                            List<GoodsAddOptionDtlPO> addOptValueList = addOpt.getAddOptionValueList();
                            for (GoodsAddOptionDtlPO addOptValue : addOptValueList) {
                                if (!StringUtils.isEmpty(addOptValue.getGoodsNo()) && addOptValue.getAddOptDtlSeq() > 0 && addOptValue.getAddOptNo() > 0) {
                                    proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsAddOptionValue",addOptValue);
                                }
                            }
                            if (!StringUtils.isEmpty(addOpt.getGoodsNo()) && addOpt.getAddOptNo() > 0) {
                                proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsAddOption", addOpt);
                            }
                        }

                        // 추가옵션 상세 정보 처리
                        List<GoodsAddOptionDtlPO> addOptValueList = addOpt.getAddOptionValueList();
                        for (GoodsAddOptionDtlPO addOptValue : addOptValueList) {
                            if ("I".equals(addOptValue.getRegistFlag())) {
                                Long addOptDtlSeq = bizService.getSequence("ADD_OPT_DTL_NO", po.getSiteNo());
                                addOptValue.setGoodsNo(po.getGoodsNo());
                                addOptValue.setAddOptNo(addOptNo);
                                addOptValue.setAddOptDtlSeq(addOptDtlSeq);
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAddOptionValue",addOptValue);
                            } else if ("U".equals(addOptValue.getRegistFlag())) {
                                if (!StringUtils.isEmpty(addOptValue.getGoodsNo()) && addOptValue.getAddOptDtlSeq() > 0 && addOptValue.getAddOptNo() > 0) {
                                    proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsAddOptionValue",addOptValue);
                                }
                            } else if ("D".equals(addOptValue.getRegistFlag())) {
                                if (!StringUtils.isEmpty(addOptValue.getGoodsNo()) && addOptValue.getAddOptDtlSeq() > 0 && addOptValue.getAddOptNo() > 0) {
                                    proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsAddOptionValue", addOptValue);
                                }
                            }
                        }
                    }
                }*/

                // 선택된 카테고리 정보 등록
                List<GoodsCtgPO> goodsCtgList = po.getGoodsCtgList();
                if(goodsCtgList != null && goodsCtgList.size() > 0) {
                    for (GoodsCtgPO goodsCtg : goodsCtgList) {
                        goodsCtg.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
                        if ("D".equals(goodsCtg.getRegistFlag())) {
                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsCtg", goodsCtg);

                        } else {
                            goodsCtg.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                            goodsCtg.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                            goodsCtg.setDelYn("N");
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsCtg", goodsCtg);
                        }
                    }
                }

                if("05".equals(po.getGoodsTypeCd())) {
                    GoodsCtgPO ctgPO = new GoodsCtgPO();
                    ctgPO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
                    ctgPO.setGoodsNo(po.getGoodsNo());
                    ctgPO.setCtgNo("1014");
                    ctgPO.setDlgtCtgYn("Y");
                    ctgPO.setExpsYn("Y");
                    ctgPO.setExpsPriorRank("0");
                    ctgPO.setDelYn("N");
                    ctgPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    ctgPO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsCtg", ctgPO);
                }

                // 선택된 필터 정보 등록
                List<GoodsFilterPO> goodsFilterList = po.getGoodsFilterList();
                if(goodsFilterList != null && goodsFilterList.size() > 0) {
                    proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsFilter", po);
                    for (GoodsFilterPO filterPO : goodsFilterList) {
                        filterPO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());


                        filterPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                        filterPO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                        filterPO.setDelYn("N");
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsFilter", filterPO);
                    }
                }

                // 선택된 아이콘 정보 등록
                if(po.getGoodsIcon() == null || po.getGoodsIcon().equals("N")) { // 적용 안함 선택 일때 다 지움
                    po.setGoodsIcon("");
                }
                proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsIcon", po);
                if (!po.getGoodsIcon().equals("")) {
                    GoodsIconPO goodsIcon = new GoodsIconPO();
                    goodsIcon.setGoodsNo(po.getGoodsNo());
                    goodsIcon.setIconNo(Long.parseLong(po.getGoodsIcon()));
                    goodsIcon.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    goodsIcon.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsIcon", goodsIcon);
                }

                // 선택된 face code 정보 등록
                GoodsFaceCdPO goodsFaceCdPO = new GoodsFaceCdPO();
                //proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsFace", po);
                goodsFaceCdPO.setGoodsNo(po.getGoodsNo());
                goodsFaceCdPO.setFdSize(po.getFdSize());
                goodsFaceCdPO.setFdShape(po.getFdShape());
                goodsFaceCdPO.setFdTone(po.getFdTone());
                goodsFaceCdPO.setFdStyle(po.getFdStyle());
                goodsFaceCdPO.setEdShape(po.getEdShape());
                goodsFaceCdPO.setEdSize(po.getEdSize());
                goodsFaceCdPO.setEdStyle(po.getEdStyle());
                goodsFaceCdPO.setEdColor(po.getEdColor());
                goodsFaceCdPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                goodsFaceCdPO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertFaceCd", goodsFaceCdPO);

                // 선택된 안경테, 선글라스 사이즈 정보 등록
                if(po.getGoodsTypeCd().equals("01") || po.getGoodsTypeCd().equals("02")) {
                    GoodsSizeCdPO sizeCdPO = new GoodsSizeCdPO();
                    sizeCdPO.setGoodsNo(po.getGoodsNo());
                    sizeCdPO.setFullSize(po.getFullSize());
                    sizeCdPO.setBridgeSize(po.getBridgeSize());
                    sizeCdPO.setHorizontalLensSize(po.getHorizontalLensSize());
                    sizeCdPO.setVerticalLensSize(po.getVerticalLensSize());
                    sizeCdPO.setTempleSize(po.getTempleSize());
                    sizeCdPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    sizeCdPO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertSizeCd", sizeCdPO);
                }

                // 선택된 사은품 정보 등록
                //proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsFreebie", po);
                List<GoodsFreebieGoodsPO> freebieGoodsList = po.getFreebieGoodsList();
                if(freebieGoodsList != null && freebieGoodsList.size() > 0) {
                    for (GoodsFreebieGoodsPO freebieGoodsPO : freebieGoodsList) {

                        if ("D".equals(freebieGoodsPO.getRegistFlag())) {
                            freebieGoodsPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                            freebieGoodsPO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsFreebie", freebieGoodsPO);

                            // 관련 상품 등록의 경우
                        } else if ("I".equals(freebieGoodsPO.getRegistFlag())) {
                            freebieGoodsPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                            freebieGoodsPO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsFreebie", freebieGoodsPO);

                            // 관련 상품 수정의 경우
                        }
                    }
                }

                // 관련 상품 처리
                if (!StringUtil.isEmpty(po.getRelateGoodsApplyTypeCd())) {
                    // '3'(관련상품 없음)의 경우
                    if ("3".equals(po.getRelateGoodsApplyTypeCd())) {

                        // 직접 선정 되었던 관련 상품 정보가 있을 경우 삭제
                        proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteDirectSetRelateGoods", po);

                        // 관련 상품 조건 CLEAR
                        po.setRelectsSelCtg1(null);
                        po.setRelectsSelCtg2(null);
                        po.setRelectsSelCtg3(null);
                        po.setRelectsSelCtg4(null);
                        po.setRelateGoodsApplyCtg(null);
                        po.setRelateGoodsSalePriceStart(null);
                        po.setRelateGoodsSalePriceEnd(null);
                        po.setRelateGoodsSaleStatusCd(null);
                        po.setRelateGoodsDispStatusCd(null);
                        po.setRelateGoodsAutoExpsSortCd(null);

                        // 관련 상품 자동 선정의 경우
                        // 관련상품 검색 조건은 상품 기본 정보 처리시 등록, 별도 처리 필요 없음
                    } else if ("1".equals(po.getRelateGoodsApplyTypeCd())) {

                        // 직접 선정 되었던 관련 상품 정보가 있을 경우 삭제
                        proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteDirectSetRelateGoods", po);

                        // 컬러 상품으로 활용
                        // 관련 상품 직접 선정의 경우
                    } else if ("2".equals(po.getRelateGoodsApplyTypeCd())) {
                        po.setRelectsSelCtg1(null);
                        po.setRelectsSelCtg2(null);
                        po.setRelectsSelCtg3(null);
                        po.setRelectsSelCtg4(null);
                        po.setRelateGoodsApplyCtg(null);
                        po.setRelateGoodsSalePriceStart(null);
                        po.setRelateGoodsSalePriceEnd(null);
                        po.setRelateGoodsSaleStatusCd(null);
                        po.setRelateGoodsDispStatusCd(null);
                        po.setRelateGoodsAutoExpsSortCd(null);

                        // 선택된 관련상품 직접 설정 정보 등록
                        List<GoodsRelateGoodsPO> relateGoodsList = po.getRelateGoodsList();
                        if(relateGoodsList != null && relateGoodsList.size() > 0) {
                            for (GoodsRelateGoodsPO relateGoods : relateGoodsList) {
                                relateGoods.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                relateGoods.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                // 관련 상품이 삭제 되었을 경우
                                if ("D".equals(relateGoods.getRegistFlag())) {
                                    proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteRelateGoods", relateGoods);

                                    // 관련 상품 등록의 경우
                                } else if ("I".equals(relateGoods.getRegistFlag())) {
                                    long priorRank = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectRelateGoodsPriorRank", relateGoods);
                                    relateGoods.setPriorRank(String.valueOf(priorRank));
                                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertRelateGoods", relateGoods);

                                    if ("Y".equals(relateGoods.getEachRegSetYn())) {
                                        GoodsRelateGoodsPO tempPo = new GoodsRelateGoodsPO();
                                        tempPo.setGoodsNo(relateGoods.getRelateGoodsNo());
                                        tempPo.setRelateGoodsNo(relateGoods.getGoodsNo());
                                        tempPo.setEachRegSetYn("Y");
                                        tempPo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                        tempPo.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                        long priorRank2 = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectRelateGoodsPriorRank", tempPo);

                                        // 서로등록 상품이 관련 상품 직접 설정이 아닐 경우, 관련상품으로 등록 안함
                                        if (priorRank2 > -1) {
                                            tempPo.setPriorRank(String.valueOf(priorRank2));
                                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateRelateGoods", tempPo);
                                        }
                                    }
                                    // 관련 상품 수정의 경우
                                } else if ("U".equals(relateGoods.getRegistFlag())) {
                                    if (!StringUtil.isEmpty(relateGoods.getEachRegSetYn())) {
                                        GoodsRelateGoodsPO tempPo1 = new GoodsRelateGoodsPO();
                                        tempPo1.setGoodsNo(relateGoods.getGoodsNo());
                                        tempPo1.setRelateGoodsNo(relateGoods.getRelateGoodsNo());
                                        tempPo1.setEachRegSetYn(relateGoods.getEachRegSetYn());
                                        tempPo1.setPriorRank(String.valueOf(relateGoods.getPriorRank()));
                                        tempPo1.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                        tempPo1.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateRelateGoods", tempPo1);

                                        GoodsRelateGoodsPO tempPo2 = new GoodsRelateGoodsPO();
                                        tempPo2.setGoodsNo(relateGoods.getRelateGoodsNo());
                                        tempPo2.setRelateGoodsNo(relateGoods.getGoodsNo());
                                        tempPo2.setEachRegSetYn(relateGoods.getEachRegSetYn());
                                        tempPo2.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                        tempPo2.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                                        long priorRank = proxyDao.selectOne(
                                                MapperConstants.GOODS_MANAGE + "selectRelateGoodsPriorRank", tempPo2);

                                        // 서로등록 상품이 관련 상품 직접 설정이 아닐 경우, 관련상품으로 등록 안함
                                        if (priorRank > -1) {
                                            tempPo2.setPriorRank(String.valueOf(priorRank));
                                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateRelateGoods", tempPo2);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                /**  상품 고시정보 등록 **/
                // 고시정보가 변경되었을 경우 기존 고시항목 설정값을 삭제한다.
                if (!StringUtil.isEmpty(po.getPrevGoodsNotifyNo()) && (!po.getPrevGoodsNotifyNo().equals(po.getNotifyNo()))) {
                    GoodsNotifyPO goodsNotify = new GoodsNotifyPO();
                    goodsNotify.setGoodsNo(po.getGoodsNo());
                    proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsNotify", goodsNotify);
                }
                List<GoodsNotifyPO> goodsNotifyList = po.getGoodsNotifyList();
                if (goodsNotifyList != null && goodsNotifyList.size() > 0) {
                    for (GoodsNotifyPO goodsNotify : goodsNotifyList) {
                        if ("I".equals(goodsNotify.getRegistFlag())) {
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsNotify", goodsNotify);
                        } else if ("U".equals(goodsNotify.getRegistFlag())) {
                            if (!StringUtils.isEmpty(goodsNotify.getGoodsNo()) && goodsNotify.getItemNo() > 0) {
                                proxyDao.update(MapperConstants.GOODS_MANAGE + "insertGoodsNotify", goodsNotify);
                            }
                        } else if ("D".equals(goodsNotify.getRegistFlag())) {
                            if (!StringUtils.isEmpty(goodsNotify.getGoodsNo()) && goodsNotify.getItemNo() > 0) {
                                proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsNotify", goodsNotify);
                            }
                        }
                    }
                }

                // 이미지 삭제 처리를 위해 기존 이미지 정보를 취득한다.
                List<GoodsImageDtlVO> goodsImageInfoList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsImageInfo", po);

                // 이미지 정보 등록
                List<GoodsImageSetPO> goodsImageSetList = po.getGoodsImageSetList();
                if (goodsImageSetList != null && goodsImageSetList.size() > 0) {
                    for (GoodsImageSetPO goodsImageSet : goodsImageSetList) {
                        long imgSetNo = goodsImageSet.getGoodsImgsetNo();
                        boolean isImageInfo = false;
                        List<GoodsImageDtlPO> goodsImageDtlList = goodsImageSet.getGoodsImageDtlList();

                        if (goodsImageDtlList != null && goodsImageDtlList.size() > 0) {
                            isImageInfo = true;
                        }
                        if (isImageInfo && "I".equals(goodsImageSet.getRegistFlag())) {
                        	if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                            	goodsImageSet.setGoodsImgsetNo((long)bizService.getSequence("GOODS_IMGSET_NO"));
                        	}
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsImageSet", goodsImageSet);
                            imgSetNo = goodsImageSet.getGoodsImgsetNo();
                        } else if ("U".equals(goodsImageSet.getRegistFlag())) {
                            if (!StringUtils.isEmpty(goodsImageSet.getGoodsNo())
                                    && goodsImageSet.getGoodsImgsetNo() > 0) {
                                proxyDao.update(MapperConstants.GOODS_MANAGE + "insertGoodsImageSet", goodsImageSet);
                            }
                        } else if ("D".equals(goodsImageSet.getRegistFlag())) {
                            if (!StringUtils.isEmpty(goodsImageSet.getGoodsNo()) && goodsImageSet.getGoodsImgsetNo() > 0) {
                                proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsImageDtlSet", goodsImageSet);
                                proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsImageSet", goodsImageSet);
                                // 변경 전 이미지 삭제 처리
                                if (goodsImageInfoList != null && goodsImageInfoList.size() > 0) {
                                    for (GoodsImageDtlVO imageDtl : goodsImageInfoList) {
                                        if (goodsImageSet.getGoodsImgsetNo() == imageDtl.getGoodsImgsetNo()
                                                && !StringUtils.isEmpty(imageDtl.getImgPath())
                                                && !StringUtils.isEmpty(imageDtl.getImgNm())) {
                                            // 이전 이미지 삭제 처리
                                            deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                                        }
                                    }
                                }
                            }
                        }
                        if (isImageInfo) {
                            for (GoodsImageDtlPO goodsImageDtl : goodsImageDtlList) {
                                String tempFileNm = goodsImageDtl.getTempFileNm();
                                if (!StringUtils.isEmpty(tempFileNm)) {
                                    String tempThumFileNm = tempFileNm.substring(0, tempFileNm.lastIndexOf("_")) + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;
                                    if ("I".equals(goodsImageDtl.getRegistFlag())) {
                                        // 변경 전 이미지 삭제 처리
                                        if (goodsImageInfoList != null && goodsImageInfoList.size() > 0) {
                                            for (GoodsImageDtlVO imageDtl : goodsImageInfoList) {
                                                if (!StringUtil.isEmpty(goodsImageDtl.getGoodsImgsetNo())
                                                        && !StringUtil.isEmpty(goodsImageDtl.getGoodsImgType())
                                                        && goodsImageDtl.getGoodsImgsetNo()
                                                                .compareTo(imageDtl.getGoodsImgsetNo()) == 0
                                                        && goodsImageDtl.getGoodsImgType()
                                                                .equals(imageDtl.getGoodsImgType())
                                                        && !StringUtils.isEmpty(imageDtl.getImgPath())
                                                        && !StringUtils.isEmpty(imageDtl.getImgNm())) {
                                                    // 이전 이미지 삭제 처리
                                                    deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                                                    break;
                                                }
                                            }
                                        }

                                        goodsImageDtl.setGoodsImgsetNo(imgSetNo);
                                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsImageDtl",goodsImageDtl);

                                        // 임시 경로의 이미지를 실제 서비스 경로로 복사
                                        FileUtil.copyGoodsImage(tempFileNm);
                                        FileUtil.copyGoodsImage(tempThumFileNm);

                                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempFileNm);
                                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempThumFileNm);

                                    } else if ("U".equals(goodsImageDtl.getRegistFlag())) {
                                        if (goodsImageDtl.getGoodsImgsetNo() > 0 && !StringUtils.isEmpty(goodsImageDtl.getGoodsImgType())) {

                                            // 변경 전 이미지 삭제 처리
                                            if (goodsImageInfoList != null && goodsImageInfoList.size() > 0) {
                                                for (GoodsImageDtlVO imageDtl : goodsImageInfoList) {

                                                    if (goodsImageDtl.getGoodsImgsetNo()
                                                            .compareTo(imageDtl.getGoodsImgsetNo()) == 0
                                                            && goodsImageDtl.getGoodsImgType().equals(imageDtl.getGoodsImgType())
                                                            && !StringUtils.isEmpty(imageDtl.getImgPath())
                                                            && !StringUtils.isEmpty(imageDtl.getImgNm())) {
                                                        // 이전 이미지 삭제 처리
                                                        deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                                                        break;
                                                    }
                                                }
                                            }

                                            proxyDao.update(MapperConstants.GOODS_MANAGE + "insertGoodsImageDtl",goodsImageDtl);

                                            // 임시 경로의 이미지를 실제 서비스 경로로 복사
                                            FileUtil.copyGoodsImage(tempFileNm);
                                            FileUtil.copyGoodsImage(tempThumFileNm);

                                            deleteTempGoodsImageFile(goodsTempImageFilePath, tempFileNm);
                                            deleteTempGoodsImageFile(goodsTempImageFilePath, tempThumFileNm);
                                        }
                                    } else if ("D".equals(goodsImageDtl.getRegistFlag())) {
                                        if (goodsImageDtl.getGoodsImgsetNo() > 0
                                                && !StringUtils.isEmpty(goodsImageDtl.getGoodsImgType())) {

                                            // 변경 전 이미지 삭제 처리
                                            if (goodsImageInfoList != null && goodsImageInfoList.size() > 0) {
                                                for (GoodsImageDtlVO imageDtl : goodsImageInfoList) {
                                                    if (goodsImageDtl.getGoodsImgsetNo()
                                                            .compareTo(imageDtl.getGoodsImgsetNo()) == 0
                                                            && goodsImageDtl.getGoodsImgType()
                                                                    .equals(imageDtl.getGoodsImgType())
                                                            && !StringUtils.isEmpty(imageDtl.getImgPath())
                                                            && !StringUtils.isEmpty(imageDtl.getImgNm())) {
                                                        // 이전 이미지 삭제 처리
                                                        deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                                                        break;
                                                    }
                                                }
                                            }

                                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsImageDtl",goodsImageDtl);
                                        }
                                    }

                                }
                            }
                        }
                    }
                }


                // 착용샷 이미지 등록 START
                // 이미지 삭제 처리를 위해 기존 이미지 정보를 취득한다.
                /*List<WearImageDtlVO> wearImageInfoList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectWearImageInfo", po);
                List<WearImageSetPO> goodsWearImageSetList = po.getWearImageSetList();
                if (goodsWearImageSetList != null && goodsWearImageSetList.size() > 0) {
                    for (WearImageSetPO wearImageSet : goodsWearImageSetList) {
                        long imgSetNo = wearImageSet.getWearImgsetNo();
                        boolean isImageInfo = false;

                        List<WearImageDtlPO> goodsWearImageList = wearImageSet.getGoodsWearImageList();

                        if (goodsWearImageList != null && goodsWearImageList.size() > 0) {
                            isImageInfo = true;
                        }

                        if (isImageInfo && "I".equals(wearImageSet.getRegistFlag())) {
                        	if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                            	wearImageSet.setWearImgsetNo((long)bizService.getSequence("GOODS_IMGSET_NO"));
                        	}

                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertWearImageSet", wearImageSet);
                            imgSetNo = wearImageSet.getWearImgsetNo();


                        } else if ("U".equals(wearImageSet.getRegistFlag())) {
                            if (!StringUtils.isEmpty(wearImageSet.getGoodsNo())
                                    && wearImageSet.getWearImgsetNo() > 0) {
                                proxyDao.update(MapperConstants.GOODS_MANAGE + "insertWearImageSet", wearImageSet);
                            }
                        } else if ("D".equals(wearImageSet.getRegistFlag())) {
                            if (!StringUtils.isEmpty(wearImageSet.getGoodsNo()) && wearImageSet.getWearImgsetNo() > 0) {
                                proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteWearImageDtlSet", wearImageSet);
                                proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteWearImageSet", wearImageSet);
                                // 변경 전 이미지 삭제 처리
                                if (wearImageInfoList != null && wearImageInfoList.size() > 0) {
                                    for (WearImageDtlVO imageDtl : wearImageInfoList) {
                                        if (wearImageSet.getWearImgsetNo() == imageDtl.getWearImgsetNo()
                                                && !StringUtils.isEmpty(imageDtl.getImgPath())
                                                && !StringUtils.isEmpty(imageDtl.getImgNm())) {
                                            // 이전 이미지 삭제 처리
                                            deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                                        }
                                    }
                                }
                            }
                        }
                        if (isImageInfo) {
                            for (WearImageDtlPO wearImageDtl : goodsWearImageList) {
                                String tempFileNm = wearImageDtl.getTempFileNm();
                                if (!StringUtils.isEmpty(tempFileNm)) {
                                    String tempThumFileNm = tempFileNm.substring(0, tempFileNm.lastIndexOf("_")) + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;
                                    if ("I".equals(wearImageDtl.getRegistFlag())) {
                                        // 변경 전 이미지 삭제 처리
                                        if (wearImageInfoList != null && wearImageInfoList.size() > 0) {
                                            for (WearImageDtlVO imageDtl : wearImageInfoList) {
                                                if (!StringUtil.isEmpty(wearImageDtl.getWearImgsetNo())
                                                        && !StringUtil.isEmpty(wearImageDtl.getWearImgType())
                                                        && wearImageDtl.getWearImgsetNo()
                                                                .compareTo(imageDtl.getWearImgsetNo()) == 0
                                                        && wearImageDtl.getWearImgType()
                                                                .equals(imageDtl.getGoodsImgType())
                                                        && !StringUtils.isEmpty(imageDtl.getImgPath())
                                                        && !StringUtils.isEmpty(imageDtl.getImgNm())) {
                                                    // 이전 이미지 삭제 처리
                                                    deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                                                    break;
                                                }
                                            }
                                        }

                                        wearImageDtl.setWearImgsetNo(imgSetNo);
                                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertWearImageDtl",wearImageDtl);

                                        // 임시 경로의 이미지를 실제 서비스 경로로 복사
                                        FileUtil.copyGoodsImage(tempFileNm);
                                        FileUtil.copyGoodsImage(tempThumFileNm);

                                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempFileNm);
                                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempThumFileNm);

                                        // 착용샷 정보 등록

                                    }else if ("U".equals(wearImageDtl.getRegistFlag())) {
                                        if (wearImageDtl.getWearImgsetNo() > 0 && !StringUtils.isEmpty(wearImageDtl.getWearImgType())) {

                                            // 변경 전 이미지 삭제 처리
                                            if (wearImageInfoList != null && wearImageInfoList.size() > 0) {
                                                for (WearImageDtlVO imageDtl : wearImageInfoList) {

                                                    if (wearImageDtl.getWearImgsetNo()
                                                            .compareTo(imageDtl.getWearImgsetNo()) == 0
                                                            && wearImageDtl.getWearImgType().equals(imageDtl.getGoodsImgType())
                                                            && !StringUtils.isEmpty(imageDtl.getImgPath())
                                                            && !StringUtils.isEmpty(imageDtl.getImgNm())) {
                                                        // 이전 이미지 삭제 처리
                                                        deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                                                        break;
                                                    }
                                                }
                                            }

                                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertWearImageDtl",wearImageDtl);

                                            // 임시 경로의 이미지를 실제 서비스 경로로 복사
                                            FileUtil.copyGoodsImage(tempFileNm);
                                            FileUtil.copyGoodsImage(tempThumFileNm);

                                            deleteTempGoodsImageFile(goodsTempImageFilePath, tempFileNm);
                                            deleteTempGoodsImageFile(goodsTempImageFilePath, tempThumFileNm);
                                        }
                                    } else if ("D".equals(wearImageDtl.getRegistFlag())) {
                                        if (wearImageDtl.getWearImgsetNo() > 0
                                                && !StringUtils.isEmpty(wearImageDtl.getWearImgType())) {

                                            // 변경 전 이미지 삭제 처리
                                            if (wearImageInfoList != null && wearImageInfoList.size() > 0) {
                                                for (WearImageDtlVO imageDtl : wearImageInfoList) {
                                                    if (wearImageDtl.getWearImgsetNo()
                                                            .compareTo(imageDtl.getWearImgsetNo()) == 0
                                                            && wearImageDtl.getWearImgType()
                                                                    .equals(imageDtl.getGoodsImgType())
                                                            && !StringUtils.isEmpty(imageDtl.getImgPath())
                                                            && !StringUtils.isEmpty(imageDtl.getImgNm())) {
                                                        // 이전 이미지 삭제 처리
                                                        deleteGoodsImg(imageDtl.getImgPath(), imageDtl.getImgNm());
                                                        break;
                                                    }
                                                }
                                            }

                                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteWearImageDtl",wearImageDtl);
                                        }
                                    }
                                }
                            }
                        }

                        proxyDao.update(MapperConstants.GOODS_MANAGE + "updateWearInfoDtl",wearImageSet);
                    }
                }*/


                // 착용샷 이미지 & 정보 등록 STOP

                // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
                // log.info("########################################### "  po.getAttachImages());

                editorService.setEditorImageToService(po, po.getGoodsNo(), "GOODS_CONT");
                //editorService.setEditorImageToService(po, po.getGoodsNo(), "GOODS_MOBILE_CONT");

                // 파일 구분세팅 및 파일명 세팅
                FileUtil.setEditorImageList(po, "GOODS_CONT", po.getAttachImages());
                for (CmnAtchFilePO p : po.getAttachImages()) {
                    if (p.getTemp()) {
                        p.setRefNo(po.getGoodsNo()); // 참조의 번호(게시판 번호, 팝업번호 등...)
                        editorService.insertCmnAtchFile(p);
                    }
                }
                /*FileUtil.setEditorImageList(po, "GOODS_MOBILE_CONT", po.getMobileAttachImages());
                for (CmnAtchFilePO p : po.getMobileAttachImages()) {
                    if (p.getTemp()) {
                        p.setRefNo(po.getGoodsNo()); // 참조의 번호(게시판 번호, 팝업번호 등...)
                        editorService.insertCmnAtchFile(p);
                    }
                }*/

                //이미지 서버 분리 후 저장할때는 이미지 도메인을 빼고 저장한다.
                HttpServletRequest request = HttpUtil.getHttpServletRequest();
                po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
                //po.setMobileContent(StringUtil.replaceAll(po.getMobileContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
                // 에디터 내용의 업로드 이미지 정보 변경
                po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
                //po.setMobileContent(StringUtil.replaceAll(po.getMobileContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
                // po.getAttachImages());
                // 수정 실행
                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
                    int cnt = proxyDao.selectOne("checkGoodsDescriptCnt", po);
                    if (cnt > 0) {
                        proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsDescript", po);
                    } else {
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsDescript", po);
                    }
                }else {
                    proxyDao.update(MapperConstants.GOODS_MANAGE + "insertGoodsContents", po);
                }

                // 임시 경로의 이미지 삭제
                FileUtil.deleteEditorTempImageList(po.getAttachImages());
                FileUtil.deleteEditorTempImageList(po.getMobileAttachImages());
            }

            // 상품 매핑 삭제 목록
            List<Map<String, Object>> itmCodeMapDelList = new ArrayList<>();
            // 상품 매핑 등록 목록
            List<Map<String, Object>> itmCodeMapInsList = new ArrayList<>();

            // 상품번호 기준으로 일단 다 지우고
            Map<String, Object> itmCodeDelMap = new HashMap<>();
            itmCodeDelMap.put("mallGoodsNo", po.getGoodsNo());
            itmCodeMapDelList.add(itmCodeDelMap);

            // 다시 새로 등록
            if("Y".equals(po.getMultiOptYn())) {
            	// 멀티 옵션인 경우
                if(po.getGoodsItemErpItmCodeList() != null && po.getGoodsItemErpItmCodeList().size() > 0) {
                    for(GoodsItemPO itm : po.getGoodsItemErpItmCodeList()) {
                        if(StringUtil.isEmpty(itm.getErpItmCode())) {
                            // 다비젼 상품 코드 없는 건 빼고
                            continue;
                        }
                        Map<String, Object> ifParam = new HashMap<>();
                        ifParam.put("mallGoodsNo", po.getGoodsNo());
                        ifParam.put("mallItmCode", itm.getItemNo());
                        ifParam.put("erpItmCode", itm.getErpItmCode());
                        if(!itmCodeMapInsList.contains(ifParam)) {
                        	itmCodeMapInsList.add(ifParam);
                        }
                    }
                }

            	if(po.getGoodsItemList() != null && po.getGoodsItemList().size() > 0) {
            		for(GoodsItemPO itm : po.getGoodsItemList()) {
            			if("D".equals(itm.getRegistFlag())) {
            				// 삭제는 빼고..
            				continue;
            			} else if(StringUtil.isEmpty(itm.getErpItmCode())) {
            				// 다비젼 상품 코드 없는 건 빼고
            				continue;
            			}
                		Map<String, Object> ifParam = new HashMap<>();
                		ifParam.put("mallGoodsNo", po.getGoodsNo());
                		ifParam.put("mallItmCode", itm.getItemNo());
                		ifParam.put("erpItmCode", itm.getErpItmCode());
                		if(!itmCodeMapInsList.contains(ifParam)) {
                        	itmCodeMapInsList.add(ifParam);
                        }
            		}
            	}
            } else {
            	// 다중옵션이 아닌 경우
            	if(StringUtil.isNotEmpty(po.getErpItmCode())) {
            		// 다비젼 상품코드 있을때만
            		Map<String, Object> ifParam = new HashMap<>();
            		ifParam.put("mallGoodsNo", po.getGoodsNo());
            		ifParam.put("mallItmCode", itemNo);
            		ifParam.put("erpItmCode", po.getErpItmCode());
            		itmCodeMapInsList.add(ifParam);
            	}
            }


            if(!itmCodeMapInsList.isEmpty() || !itmCodeMapDelList.isEmpty()) {
            	// 둘중에 하나라도 변경사항이 있을때만 호출
            	Map<String, Object> ifParam = new HashMap<>();
            	ifParam.put("insertList", itmCodeMapInsList);
            	ifParam.put("deleteList", itmCodeMapDelList);

                log.info("ifParam = "+ifParam);
                /*Map<String, Object> ifResult = (Map<String, Object>)*/ ifBundleProductMapping(ifParam); // interface_block_temp
            	/*Map<String, Object> ifResult = InterfaceUtil.send("IF_PRD_007", ifParam);

            	if(!"1".equals(ifResult.get("result"))) {
            		// 매핑정보 등록 실패인 경우
            		throw new CustomException("biz.exception.gds.goodsinsert");
            	}
                if ("1".equals(ifResult.get("result"))) {
                    result.setSuccess(true);
                }else{
                    throw new Exception(String.valueOf(ifResult.get("message")));
                }*/
            }

            // 등록성공 메세지 설정
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.gds.goodsinsert", new Object[] { "신규상품등록" }, e);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 23.
     * 작성자 : dong
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 23. dong - 최초생성
     * </pre>
     *
     * @param tempFileName
     * @throws Exception
     */
    private void copyTempDispImageFile(String tempFileName) throws Exception {
        if (!StringUtils.isEmpty(tempFileName)) {
            String tempThumFileNm = tempFileName.substring(0, tempFileName.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;
            // 임시 경로의 이미지를 실제 서비스 경로로 복사
            FileUtil.copyGoodsImage(tempFileName);
            FileUtil.copyGoodsImage(tempThumFileNm);

            FileUtil.deleteTempFile(tempFileName); // 이미지 삭제
            FileUtil.deleteTempFile(tempThumFileNm); // 이미지 삭제
        }
    }

    private String[] getCopyImgFileInfo(String imgPath, String imgNm, List<File> fileList) throws Exception {
        String[] rstArray = new String[] { imgPath, imgNm };
        if (!StringUtils.isEmpty(imgPath) && !StringUtils.isEmpty(imgNm)) {
            String orgFileName = imgPath + "_" + imgNm;
            String imgFileInfo = orgFileName.substring(orgFileName.lastIndexOf("_"));
            String preFileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + ".");
            String newfileName = preFileName + imgFileInfo;
            String newfilePathNm = DateUtil.getNowDate();
            String newfilePath = newfilePathNm.substring(0, 4) + File.separator + newfilePathNm.substring(4, 6)
                    + File.separator + newfilePathNm.substring(6);

            String tempThumFileNm = orgFileName.substring(0, orgFileName.lastIndexOf("_"))
                    + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;
            String newTempThumFileNm = newfileName.substring(0, newfileName.lastIndexOf("_"))
                    + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;

            log.debug("원본파일 : {}", orgFileName);
            log.debug("대상파일 : {}", FileUtil.getCombinedPath(newfilePath, newfileName));

            copyGoodsImage(orgFileName, FileUtil.getCombinedPath(newfilePath, newfileName));
            copyGoodsImage(tempThumFileNm, FileUtil.getCombinedPath(newfilePath, newTempThumFileNm));

            if (fileList != null) {
                fileList.add(
                        new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE,
                                UploadConstants.PATH_GOODS, FileUtil.getCombinedPath(newfilePath, newfileName))));
                fileList.add(
                        new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE,
                                UploadConstants.PATH_GOODS, FileUtil.getCombinedPath(newfilePath, newTempThumFileNm))));
            }
            rstArray = new String[] { newfilePathNm, newfileName };
        }
        return rstArray;
    }

    /*
     * (non-Javadoc)
     *
     * @see
     * GoodsManageService#copyGoodsInfo(
     * GoodsPO)
     */
    @Override
    public ResultModel<GoodsDetailVO> copyGoodsInfo(GoodsPO po) throws Exception {
        ResultModel<GoodsDetailVO> result = new ResultModel<>();
        List<File> tempFileList = new ArrayList<File>();

        try {

            log.debug("################### TARGET : " + po.getGoodsNo());

            // [0] 복사 대상 상품 정보 취득
            GoodsDetailVO goodsDetailVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsBasicInfo", po);
            String oldItemNo = goodsDetailVO.getItemNo();

            // 신규 GOODS_NO 취득
            String goodsNoSeq = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectNewGoodsNo", po);
            StringBuffer sb = new StringBuffer().append("G").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(goodsNoSeq, "0", 4));

            String newGoodsNo = sb.toString();
            String newGoodsNm = goodsDetailVO.getGoodsNm() + "(복사본)";
            String targetGoodsNo = po.getGoodsNo();
            Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

            // log.debug("################### NEW : " + newGoodsNo);
            String[] typeAInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeA(),goodsDetailVO.getDispImgNmTypeA(), tempFileList);
            String[] typeBInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeB(),goodsDetailVO.getDispImgNmTypeB(), tempFileList);
            String[] typeCInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeC(),goodsDetailVO.getDispImgNmTypeC(), tempFileList);
            String[] typeDInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeD(),goodsDetailVO.getDispImgNmTypeD(), tempFileList);
            String[] typeEInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeE(),goodsDetailVO.getDispImgNmTypeE(), tempFileList);
            String[] typeFInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeF(),goodsDetailVO.getDispImgNmTypeF(), tempFileList);
            String[] typeGInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeG(),goodsDetailVO.getDispImgNmTypeG(), tempFileList);
            String[] typeSInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeS(),goodsDetailVO.getDispImgNmTypeS(), tempFileList);
            String[] typeMInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeM(),goodsDetailVO.getDispImgNmTypeM(), tempFileList);
            String[] typeOInfo = getCopyImgFileInfo(goodsDetailVO.getDispImgPathTypeO(),goodsDetailVO.getDispImgNmTypeO(), tempFileList);

            log.debug("################### tempFileList : {}", tempFileList);

            // [1] 상품 기본 정보 복사
            GoodsCopyVO goodsVO = new GoodsCopyVO();
            goodsVO.setNewGoodsNo(newGoodsNo);
            goodsVO.setTargetGoodsNo(targetGoodsNo);
            goodsVO.setNewGoodsNm(newGoodsNm);
            goodsVO.setRegrNo(memberNo);
            goodsVO.setUpdrNo(memberNo);

            if (typeAInfo != null && typeAInfo.length > 1) {
                goodsVO.setDispImgPathTypeA(typeAInfo[0]);
                goodsVO.setDispImgNmTypeA(typeAInfo[1]);
            }
            if (typeBInfo != null && typeBInfo.length > 1) {
                goodsVO.setDispImgPathTypeB(typeBInfo[0]);
                goodsVO.setDispImgNmTypeB(typeBInfo[1]);
            }
            if (typeCInfo != null && typeCInfo.length > 1) {
                goodsVO.setDispImgPathTypeC(typeCInfo[0]);
                goodsVO.setDispImgNmTypeC(typeCInfo[1]);
            }
            if (typeDInfo != null && typeDInfo.length > 1) {
                goodsVO.setDispImgPathTypeD(typeDInfo[0]);
                goodsVO.setDispImgNmTypeD(typeDInfo[1]);
            }
            if (typeEInfo != null && typeEInfo.length > 1) {
                goodsVO.setDispImgPathTypeE(typeEInfo[0]);
                goodsVO.setDispImgNmTypeE(typeEInfo[1]);
            }

            if (typeFInfo != null && typeFInfo.length > 1) {
                goodsVO.setDispImgPathTypeF(typeFInfo[0]);
                goodsVO.setDispImgNmTypeF(typeFInfo[1]);
            }
            if (typeGInfo != null && typeGInfo.length > 1) {
                goodsVO.setDispImgPathTypeG(typeGInfo[0]);
                goodsVO.setDispImgNmTypeG(typeGInfo[1]);
            }
            if (typeSInfo != null && typeSInfo.length > 1) {
                goodsVO.setDispImgPathTypeS(typeSInfo[0]);
                goodsVO.setDispImgNmTypeS(typeSInfo[1]);
            }
            if (typeMInfo != null && typeMInfo.length > 1) {
                goodsVO.setDispImgPathTypeM(typeMInfo[0]);
                goodsVO.setDispImgNmTypeM(typeMInfo[1]);
            }
            if (typeOInfo != null && typeOInfo.length > 1) {
                goodsVO.setDispImgPathTypeO(typeOInfo[0]);
                goodsVO.setDispImgNmTypeO(typeOInfo[1]);
            }

            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertCopyGoods", goodsVO);

            // [2] 상품 관련 옵션정보 취득 및 복사
            List<GoodsCopyOptVO> optList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectCopyGoodsOpt",goodsVO);
            Map<Long, Long> optNoMap = new HashMap<Long, Long>();
            Map<Long, Long> AttrNoMap = new HashMap<Long, Long>();
            if (optList != null && optList.size() > 0) {
                Long preOptNo = 0L;
                Long newOptNo = 0L;
                Long newAttrNo = 0L;

                for (GoodsCopyOptVO optVO : optList) {
                    optVO.setGoodsNo(newGoodsNo);
                    optVO.setUseYn("Y");
                    optVO.setRegrNo(memberNo);
                    optVO.setUpdrNo(memberNo);

                    if (!preOptNo.equals(optVO.getTargetOptNo())) {
                        optVO.setOptNo(null);
                        if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                        	optVO.setOptNo(bizService.getSequence("OPT_NO"));
                        }
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertOption", optVO);
                        newOptNo = optVO.getOptNo();
                        preOptNo = optVO.getTargetOptNo();
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsOption", optVO);
                        optNoMap.put(preOptNo, newOptNo);
                    } else {
                        optVO.setOptNo(newOptNo);
                    }
                    optVO.setAttrNo(null);

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	optVO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", optVO);
                    newAttrNo = optVO.getAttrNo();
                    AttrNoMap.put(optVO.getTargetAttrNo(), newAttrNo);
                }
            }

            // [3] 단품 취득 및 복사
            List<GoodsCopyItemVO> itemList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectCopyGoodsItem",goodsVO);

            String itemNo = null;

            if (itemList != null && itemList.size() > 0) {
                for (GoodsCopyItemVO itemVO : itemList) {
                    Long itemSeq = bizService.getSequence("ITEM_NO");
                    StringBuffer sbItemNo = new StringBuffer().append("I").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                    String newItemNo = sbItemNo.toString();
                    String targetItemNo = itemVO.getItemNo();

                    itemVO.setGoodsNo(newGoodsNo);
                    itemVO.setItemNo(newItemNo);
                    itemVO.setAttrVer(0L);
                    itemVO.setUseYn("Y");
                    itemVO.setRegrNo(memberNo);
                    itemVO.setUpdrNo(memberNo);

                    // 복사 대상 단품 번호가 기존의 상품 대표 단품 번호와 같을 경우, 새로운 상품 정보의 대표단품번호에
                    // 새로운 단품 번호를 등록한다.
                    if (targetItemNo.equals(oldItemNo)) {
                        // 상품 대표 단품 번호 수정
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateGoodsItemNo", itemVO);
                        itemNo = newItemNo;
                    }
                    // 단품 정보 등록
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", itemVO);

                    if ("Y".equals(goodsDetailVO.getMultiOptYn()) && itemVO.getAttrVer() != null) {
                        // 단품 속성 정보 등록
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAttr", itemVO);
                    }
                    // 단품 가격 변경 이력 테이블에 등록 ("01" : 인상)
                    itemVO.setPriceChgCd("01");
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", itemVO);
                    // 단품 수량 변경 이력 테이블에 등록 ("01" : 입고)
                    itemVO.setStockChgCd("01");
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemStockChgHist", itemVO);
                }

            }

            // [4] ICON 정보 복사
            String iconNoArray = goodsDetailVO.getIconArray();
            if (!StringUtils.isEmpty(iconNoArray)) {
                String[] goodsIconArr = iconNoArray.split(DELIMETER_FOR_GROUP_CONCAT);
                GoodsIconPO iconPO = null;
                for (int i = 0; i < goodsIconArr.length; i++) {
                    iconPO = new GoodsIconPO();
                    iconPO.setGoodsNo(newGoodsNo);
                    iconPO.setIconNo(Long.parseLong(goodsIconArr[i]));
                    iconPO.setRegrNo(memberNo);
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsIcon", iconPO);
                }
            }

            // [5] 카테고리 정보 복사
            String ctgNoArray = goodsDetailVO.getCtgNoArr();
            if (!StringUtils.isEmpty(ctgNoArray)) {
                String[] goodsCtgNoArr = ctgNoArray.split(DELIMETER_FOR_GROUP_CONCAT);

                GoodsCtgPO ctgPO = null;
                for (int i = 0; i < goodsCtgNoArr.length; i++) {
                    ctgPO = new GoodsCtgPO();
                    ctgPO.setSiteNo(po.getSiteNo());
                    ctgPO.setNewGoodsNo(newGoodsNo);
                    ctgPO.setTargetGoodsNo(targetGoodsNo);
                    ctgPO.setCtgNo(goodsCtgNoArr[i]);
                    ctgPO.setRegrNo(memberNo);
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertCopyGoodsCtg", ctgPO);
                }
            }

            // [6] 상품 고시 정보 복사
            String notifyArray = goodsDetailVO.getNotifyItemNoArr();
            if (!StringUtils.isEmpty(notifyArray)) {
                String[] goodsNotifyNoArr = notifyArray.split(DELIMETER_FOR_GROUP_CONCAT);

                GoodsNotifyPO notifyPO = null;
                for (int i = 0; i < goodsNotifyNoArr.length; i++) {
                    notifyPO = new GoodsNotifyPO();
                    notifyPO.setNewGoodsNo(newGoodsNo);
                    notifyPO.setTargetGoodsNo(targetGoodsNo);
                    notifyPO.setItemNo(Long.valueOf(goodsNotifyNoArr[i]));
                    notifyPO.setRegrNo(memberNo);
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertCopyGoodsNotify", notifyPO);
                }
            }

            // [7] 추가 옵션 정보 취득 및 복사
            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertCopyGoodsAddOpt", goodsVO);
            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertCopyGoodsAddOptDtl", goodsVO);

            // [8] 이미지 정보 취득 및 복사
            List<GoodsImageDtlVO> imageList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectCopyGoodsImage",goodsVO);
            if (imageList != null && imageList.size() > 0) {
                Long preImgSetNo = 0L;
                Long newImgSetNo = 0L;
                String preFileName = "";
                for (GoodsImageDtlVO imageVO : imageList) {
                    String orgFileName = imageVO.getImgPath() + "_" + imageVO.getImgNm();
                    String imgFileInfo = orgFileName.substring(orgFileName.lastIndexOf("_"));

                    if (!preImgSetNo.equals(imageVO.getGoodsImgsetNo())) {
                        preFileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + ".");
                    }
                    String newfileName = preFileName + imgFileInfo;
                    String newfilePathNm = DateUtil.getNowDate();
                    String newfilePath = newfilePathNm.substring(0, 4) + File.separator + newfilePathNm.substring(4, 6)+ File.separator + newfilePathNm.substring(6);

                    log.debug("원본파일 : {}", orgFileName);
                    log.debug("대상파일 : {}", FileUtil.getCombinedPath(newfilePath, newfileName));
                    copyGoodsImage(orgFileName, FileUtil.getCombinedPath(newfilePath, newfileName));

                    GoodsImageDtlPO imagePO = new GoodsImageDtlPO();
                    imagePO.setGoodsNo(newGoodsNo);
                    imagePO.setGoodsImgType(imageVO.getGoodsImgType());
                    imagePO.setDlgtImgYn(imageVO.getDlgtImgYn());
                    imagePO.setImgPath(newfilePathNm);
                    imagePO.setImgNm(newfileName);
                    imagePO.setImgWidth(imageVO.getImgWidth());
                    imagePO.setImgHeight(imageVO.getImgHeight());

                    if (!preImgSetNo.equals(imageVO.getGoodsImgsetNo())) {
                        //imagePO.setGoodsImgsetNo(null);
                        if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                            imagePO.setGoodsImgsetNo((long)bizService.getSequence("GOODS_IMGSET_NO"));
                        }
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsImageSet", imagePO);
                        newImgSetNo = imagePO.getGoodsImgsetNo();
                        preImgSetNo = imageVO.getGoodsImgsetNo();
                    } else {

                        imagePO.setGoodsImgsetNo(newImgSetNo);
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsImageDtl", imagePO);
                }
            }
            // [9] 상품 상세 정보 취득 및 복사
            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertCopyGoodsContent", goodsVO);

            // [10] 관련상품 설정 정보 취득 및 복사
            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertCopyGoodsRelateGoods", goodsVO);

            // 등록성공 메세지 설정
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

            goodsDetailVO.setGoodsNo(newGoodsNo);
            goodsDetailVO.setGoodsNm(newGoodsNm);
            goodsDetailVO.setItemNo(itemNo);
            result.setData(goodsDetailVO);

        } catch (Exception e) {
            if (tempFileList != null && tempFileList.size() > 0) {
                for (File file : tempFileList) {
                    if (file.exists()) { // 존재한다면 삭제
                        FileUtil.delete(file);
                    }
                }
            }
            throw new CustomException("biz.exception.gds.goodscopy", new Object[] {}, e);
        }
        return result;
    }

    public static void copyGoodsImage(String orgFileName, String newFileName) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath();
        String targetPath = path + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS);
        File orgFile = new File(targetPath + File.separator + FileUtil.getDatePath(orgFileName));

        if (!orgFile.exists()) {
            log.debug("소스 파일 없음:{}", orgFile.getAbsolutePath());
            return;
        }
        File targetFile = new File(targetPath + newFileName);

        if (!targetFile.getParentFile().exists()) {
            targetFile.getParentFile().mkdirs();
        }

        log.debug("이미지 파일 복사 : {} -> {}", orgFile, targetFile);
        FileUtil.copy(orgFile, targetFile);
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 단품 정보 변경시 이전 정보를 취득하여 판매가격, 재고 수량 변경시 이력 테이블에 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void updateItemInfo(GoodsItemPO po, boolean isFirstFlag) throws Exception {
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setUseYn("Y");

        String itemNo = null;
        // 기존 단품 정보의 경우
        if (!StringUtils.isEmpty(po.getItemNo())) {
            itemNo = po.getItemNo();

            String tempFileNm = po.getTempFileNm();
            GoodsItemVO vo = null;
            if (isFirstFlag) {
                po.setItemVer(1L);

            } else {
                // 이전 정보 검색용
                GoodsItemVO vo1 = new GoodsItemVO();
                vo1.setItemNo(itemNo);
                // 이전 데이터 검색
                vo = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsItem", vo1);

                if (vo != null) {
                    Long preSalePrice = vo.getSalePrice();
                    Long newSalePrice = po.getSalePrice();
                    Long preStockQtt = vo.getStockQtt();
                    Long newStockQtt = po.getStockQtt();

                    String preFileNm = StringUtil.isEmpty(vo.getFileNm()) ? "" : vo.getFileNm();
                    String newFileNm = StringUtil.isEmpty(po.getFileNm()) ? "" : po.getFileNm();
                    String preFilePath = vo.getFilePath();
                    String newFilePath = po.getFilePath();

                    /** 필수값 이전값(vo)으로 세팅.. Start */
                    // item 명
                    if(po.getItemNm()==null)
                        po.setItemNm(vo.getItemNm());

                    // 원가
                    if(po.getCost() == null)
                        po.setCost(vo.getCost());

                    //소비자가격
                    if(po.getCustomerPrice()==null)
                        po.setCustomerPrice(vo.getCustomerPrice());

                    //공급가격
                    if(po.getSupplyPrice()==null)
                        po.setSupplyPrice(vo.getSupplyPrice());

                    //별도 공급가 여부
                    if(po.getSepSupplyPriceYn()==null)
                        po.setSepSupplyPriceYn(vo.getSepSupplyPriceYn());

                    //재고 다비전 연동 여부
                    if(po.getApplyDavisionStockYn()==null)
                        po.setApplyDavisionStockYn(vo.getApplyDavisionStockYn());

                    //재고
                    if(po.getStockQtt()==null)
                        po.setStockQtt(vo.getStockQtt());

                    //사용여부
                    if(po.getUseYn()==null)
                        po.setUseYn(vo.getUseYn());

                    //판매수량
                    if(po.getSaleQtt()==null)
                        po.setSaleQtt(vo.getSaleQtt());

                    if (po.getDcStartDttm() == null) {
                        po.setDcStartDttm(vo.getDcStartDttm());
                    }
                    if (po.getDcEndDttm() == null) {
                        po.setDcEndDttm(vo.getDcEndDttm());
                    }
                    if (po.getDcPriceApplyAlwaysYn() == null) {
                        po.setDcPriceApplyAlwaysYn(vo.getDcPriceApplyAlwaysYn());
                    }
                    if (po.getFileNm() == null) {
                        po.setFileNm(vo.getFileNm());
                    }
                    if (po.getFilePath() == null) {
                        po.setFilePath(vo.getFilePath());
                    }
                    /** 필수값 이전값(vo)으로 세팅.. End */


                    /** 판매가격 변경 시 */
                    if (newSalePrice != null && !newSalePrice.equals(preSalePrice)) {
                        // 가격 변경 시 ITEM_VER 을 변경
                        po.setItemVer(vo.getItemVer() + 1);
                        // 증감 코드 설정('00':인하, '01':인상)
                        if (preSalePrice > newSalePrice) {
                            po.setPriceChgCd("00");
                            po.setSaleChdPrice(preSalePrice - newSalePrice);
                        } else {
                            po.setPriceChgCd("01");
                            po.setSaleChdPrice(newSalePrice - preSalePrice);
                        }

                        // 단품 가격 변경 이력 테이블에 등록
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", po);
                    }

                    /** 재고 수량 변경 시 */
                    if (newStockQtt != null && !newStockQtt.equals(preStockQtt)) {
                        // 증감 코드 설정('00':출고, '01':입고)
                        if (preStockQtt > newStockQtt) {
                            po.setStockChgCd("00");
                            po.setStockChdQtt(preStockQtt - newStockQtt);
                        } else {
                            po.setStockChgCd("01");
                            po.setStockChdQtt(newStockQtt - preStockQtt);
                        }
                        // 단품 수량 변경 이력 테이블에 등록
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemStockChgHist", po);
                    }

                    log.info("newFileNm = "+newFileNm);
                    log.info("preFileNm = "+preFileNm);
                    /** 이미지 변경 시 */
                    if (newFileNm != null && !newFileNm.equals(preFileNm)) {
                        if(StringUtil.isEmpty(newFileNm)) {
                            if (!StringUtils.isEmpty(preFilePath)
                                    && !StringUtils.isEmpty(preFileNm)) {
                                // 이전 이미지 삭제 처리
                                deleteGoodsItemImg(preFilePath, preFileNm);
                            }
                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsItemImage", po);
                        } else {
                            po.setFileNm(newFileNm);
                            po.setFilePath(newFilePath);

                            if (!StringUtils.isEmpty(preFilePath)
                                    && !StringUtils.isEmpty(preFileNm)) {
                                // 이전 이미지 삭제 처리
                                deleteGoodsItemImg(preFilePath, preFileNm);
                            }
                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsItemImage", po);
                            // 단품 수량 변경 이력 테이블에 등록
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemImage", po);

                            log.info("tempFileNm = " + tempFileNm);
                            FileUtil.copyGoodsItemImage(tempFileNm);

                            deleteTempGoodsImageFile(goodsTempImageFilePath, tempFileNm);
                        }
                    }

                    // 판매기간 입력 시 판매가 무제한 적용 및 판매가 할인율에 따라 GOODS_DC_CHANGE_DTTM 셋팅
                    if(po.getDcPriceApplyAlwaysYn() != null && po.getDcPriceApplyAlwaysYn().equals("Y")) { // 판매가 무제한 적용
                        if (!Objects.equals(po.getCustomerPrice(), po.getSalePrice())) {                   // 정상가와 판매가가 같지 않을때 할인율 적용으로 봄
                            po.setIsDcPriceChanged(true);
                        } else {
                            po.setIsDcPriceChanged(false);
                        }
                    } else {
                        // 판매기간 입력 시 판매가 적용일 및 판매가 할인율에 따라 GOODS_DC_CHANGE_DTTM 셋팅
                        String nowDate = DateUtil.getNowDate();

                        if (!StringUtils.isEmpty(po.getDcStartDttm()) && !StringUtils.isEmpty(po.getDcEndDttm())) {
                            if (DateUtil.compareToCalerdar(nowDate, po.getDcStartDttm()) < 0) { // 판매가 적용 시작일이 미래일 경우
                                po.setIsDcPriceChanged(false);
                            } else {
                                if (!StringUtils.isEmpty(po.getDcEndDttm())) {
                                    if (DateUtil.compareToCalerdar(nowDate, po.getDcEndDttm()) > 0) { // 판매가 적용 종료일이 과거일 경우
                                        po.setIsDcPriceChanged(false);
                                    } else { // 등록 일자가 판매가 적용일 내 일때
                                        if (!Objects.equals(po.getCustomerPrice(), po.getSalePrice())) { // 정상가와 판매가가 같지 않을때 할인율 적용으로 봄
                                            po.setIsDcPriceChanged(true);
                                        } else {
                                            po.setIsDcPriceChanged(false);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // 단품 정보 수정
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", po);
                    if(po.getRelationPriceUpdate()){
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "updateGoodsAllItemPrice", po);
                    }
                } else {
                    /**  신규 단품 정보의 경우 */
                    po.setItemVer(1L);
                    /** 이미지 변경 시 */

                    /*if (!StringUtils.isEmpty(po.getFileNm())
                            && !StringUtils.isEmpty(po.getFilePath())) {
                        // 이전 이미지 삭제 처리
                        deleteGoodsItemImg(po.getFilePath(), po.getFileNm());
                    }*/
                    if(StringUtil.isNotEmpty(po.getFileNm())) {
                        // 단품 수량 변경 이력 테이블에 등록
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemImage", po);

                        FileUtil.copyGoodsImage(tempFileNm);

                        deleteTempGoodsImageFile(goodsTempImageFilePath, tempFileNm);
                    }

                    // 판매기간 입력 시 판매가 무제한 적용 및 판매가 할인율에 따라 GOODS_DC_CHANGE_DTTM 셋팅
                    if(po.getDcPriceApplyAlwaysYn() != null && po.getDcPriceApplyAlwaysYn().equals("Y")) { // 판매가 무제한 적용
                        if (!Objects.equals(po.getCustomerPrice(), po.getSalePrice())) {                   // 정상가와 판매가가 같지 않을때 할인율 적용으로 봄
                            po.setIsDcPriceChanged(true);
                        } else {
                            po.setIsDcPriceChanged(false);
                        }
                    } else {
                        // 판매기간 입력 시 판매가 적용일 및 판매가 할인율에 따라 GOODS_DC_CHANGE_DTTM 셋팅
                        String nowDate = DateUtil.getNowDate();

                        if (!StringUtils.isEmpty(po.getDcStartDttm()) && !StringUtils.isEmpty(po.getDcEndDttm())) {
                            if (DateUtil.compareToCalerdar(nowDate, po.getDcStartDttm()) < 0) { // 판매가 적용 시작일이 미래일 경우
                                po.setIsDcPriceChanged(false);
                            } else {
                                if (!StringUtils.isEmpty(po.getDcEndDttm())) {
                                    if (DateUtil.compareToCalerdar(nowDate, po.getDcEndDttm()) > 0) { // 판매가 적용 종료일이 과거일 경우
                                        po.setIsDcPriceChanged(false);
                                    } else { // 등록 일자가 판매가 적용일 내 일때
                                        if (!Objects.equals(po.getCustomerPrice(), po.getSalePrice())) { // 정상가와 판매가가 같지 않을때 할인율 적용으로 봄
                                            po.setIsDcPriceChanged(true);
                                        } else {
                                            po.setIsDcPriceChanged(false);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // 단품 정보 등록
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", po);
                    // 단품 가격 변경 이력 테이블에 등록 ("01" : 인상)
                    if (po.getSalePrice() != null) {
                        po.setPriceChgCd("01");
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", po);
                    }
                    // 단품 수량 변경 이력 테이블에 등록 ("01" : 입고)
                    if (po.getStockQtt() != null) {
                        po.setStockChgCd("01");
                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemStockChgHist", po);
                    }
                }
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 상품 상세설명(주의사항) 저장 서비스 *
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    @Override
    public ResultModel<GoodsContentsPO> saveGoodsContents(GoodsContentsPO po) throws Exception {
        ResultModel<GoodsContentsPO> resultModel = new ResultModel<>();
        String refNo = po.getGoodsNo();

        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        editorService.setEditorImageToService(po, refNo, "GOODS_CONT");

        // 에디터 내용의 업로드 이미지 정보 변경
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));

        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "GOODS_CONT", po.getAttachImages());
        // po.getAttachImages());

        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 수정 실행
        if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
            int cnt = proxyDao.selectOne("checkGoodsDescriptCnt", po);
            if (cnt > 0) {
                proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsDescript", po);
            } else {
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsDescript", po);
            }
        }else {
            proxyDao.update(MapperConstants.GOODS_MANAGE + "insertGoodsContents", po);
        }
        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<GoodsContentsVO> selectGoodsContents(GoodsContentsVO vo) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<GoodsContentsVO> result = new ResultModel<>();
        log.info("selectGoodsContents param = " + vo);
        GoodsContentsVO contents = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsContents", vo);
        log.info("selectGoodsContents contents = " + contents);
        if (contents != null) {
            contents.setContent(StringUtil.replaceAll(contents.getContent(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
            //contents.setMobileContent(StringUtil.replaceAll(contents.getMobileContent(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));

            List<CmnAtchFileSO> soList = new ArrayList<>();
            // 이미지 정보 조회 조건 세팅
            CmnAtchFileSO fileso = new CmnAtchFileSO();

            fileso.setSiteNo(vo.getSiteNo());
            fileso.setRefNo(vo.getGoodsNo());
            fileso.setFileGb("GOODS_CONT");
            soList.add(fileso);
            fileso = new CmnAtchFileSO();
            fileso.setSiteNo(vo.getSiteNo());
            fileso.setRefNo(vo.getGoodsNo());
            fileso.setFileGb("GOODS_MOBILE_CONT");
            soList.add(fileso);

            // 공통 첨부 파일 조회
            //editorService.setCmnAtchFileToEditorVO(soList, contents);
        }
        result.setData(contents);
        return result;
    }

    private static void deleteTempGoodsImageFile(String path, String tempFileNm) throws Exception {
        FileUtil.deleteTempFile(tempFileNm); // 이미지 삭제
        // 섬네일 삭제
        // FileUtil.deleteEditorTempImage(
        // tempFileNm.substring(0, tempFileNm.lastIndexOf("_")) +
        // CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<GoodsItemVO> selectItemInfo(GoodsItemSO so) {
        ResultModel<GoodsItemVO> resultModel = new ResultModel<>();
        GoodsItemVO goodsItem = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectItemInfo", so);
        resultModel.setData(goodsItem);
        return resultModel;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<GoodsDetailVO> selectGoodsImageList(GoodsDetailSO so) {
        List<GoodsImageDtlVO> goodsImageInfoList = proxyDao
                .selectList(MapperConstants.GOODS_MANAGE + "selectGoodsImageInfo", so);
        long prevImgSetNo = -1;
        Map<String, Object> imgSetMap = null;
        Map<String, Object> imgDtlMap = null;
        List<Map<String, Object>> imgSetList = new ArrayList<>();
        List<Map<String, Object>> imgDtlList = null;
        for (GoodsImageDtlVO goodsImageInfo : goodsImageInfoList) {
            long goodsImgSetNo = goodsImageInfo.getGoodsImgsetNo();
            if (prevImgSetNo != goodsImgSetNo) {
                imgSetMap = new HashMap<>();
                imgSetMap.put("goodsNo", goodsImageInfo.getGoodsNo());
                imgSetMap.put("goodsImgsetNo", goodsImgSetNo);
                imgSetMap.put("dlgtImgYn", goodsImageInfo.getDlgtImgYn());
                imgSetMap.put("registFlag", "L");

                imgDtlList = new ArrayList<>();
                imgSetMap.put("goodsImageDtlList", imgDtlList);
                imgSetList.add(imgSetMap);
                prevImgSetNo = goodsImageInfo.getGoodsImgsetNo();
            }

            log.debug("getDlgtImgYn : " + goodsImageInfo.getDlgtImgYn());

            if (imgSetList != null && imgSetList.size() > 0) {
                Map<String, Object> targetMap = null;
                for (Map<String, Object> imgSet : imgSetList) {
                    if (goodsImgSetNo == (long) imgSet.get("goodsImgsetNo")) {
                        targetMap = imgSet;
                        break;
                    }
                }
                imgDtlMap = new HashMap<>();
                imgDtlMap.put("goodsImgType", goodsImageInfo.getGoodsImgType());
                imgDtlMap.put("imgPath", goodsImageInfo.getImgPath());
                imgDtlMap.put("imgNm", goodsImageInfo.getImgNm());
                imgDtlMap.put("imgWidth", goodsImageInfo.getImgWidth());
                imgDtlMap.put("imgHeight", goodsImageInfo.getImgHeight());
                imgDtlMap.put("imgUrl", CommonConstants.IMAGE_TEMP_GOODS_URL + goodsImageInfo.getImgPath() + "_"
                        + goodsImageInfo.getImgNm());

                if (null != goodsImageInfo.getImgNm()) {
                    String imgNm = goodsImageInfo.getImgNm();
                    String fileNm = imgNm.substring(0, imgNm.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;
                    imgDtlMap.put("thumbUrl","/image/image-view?type=GOODSDTL&id1=" + goodsImageInfo.getImgPath() + "_" + fileNm);
                }

                imgDtlMap.put("registFlag", "L");
                List<Map<String, Object>> tempImgDtlList = (List<Map<String, Object>>) targetMap
                        .get("goodsImageDtlList");
                if (tempImgDtlList != null) {
                    tempImgDtlList.add(imgDtlMap);
                }
            }
        }
        ResultModel<GoodsDetailVO> result = new ResultModel<>();
        GoodsDetailVO goodsDetailVO = new GoodsDetailVO();
        goodsDetailVO.setGoodsImageSetList(imgSetList);
        result.setData(goodsDetailVO);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsItemHistoryVO> selectItemPriceHist(GoodsItemHistoryVO vo) throws Exception {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectItemPriceChgHistory", vo);
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsItemHistoryVO> selectItemQttHist(GoodsItemHistoryVO vo) throws Exception {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectItemQttChgHistory", vo);
    }

    @Override
    public ResultModel<GoodsPO> updateGoodsInqCnt(GoodsPO po) {
        ResultModel<GoodsPO> resultModel = new ResultModel<>();
        proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsInqCnt", po);
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * saveGoodsContents(GoodsContentsPO)
     */
    @Override
    public List<GoodsDetailPO> uploadGoodsInsertList(List<Map<String, Object>> plist,
            MultipartHttpServletRequest mRequest) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        List<GoodsDetailPO> list = new ArrayList<GoodsDetailPO>();
        GoodsDetailPO po = null;

        Long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        String prevGoodsNm = null;
        String prevGoodsNo = null;

        List<String> optList = null;
        List<String> optValue1List = null;
        List<String> optValue2List = null;
        List<String> optValue3List = null;
        List<String> optValue4List = null;

        List<GoodsItemPO> optItemList = null;
        for (Map<String, Object> map : plist) {
            // 신규 GOODS_NO 취득
            String goodsNm = (String) getExcelInputValue(map.get("상품명(필수)"), "string");
            String goodsNo = null;

            if (StringUtils.isEmpty(goodsNm)) {

            } else {

                if ("goodsNm".equals(goodsNm)) {
                    continue;
                }

                String optNm1 = (String) getExcelInputValue(map.get("옵션명1"), "string");
                String optNm2 = (String) getExcelInputValue(map.get("옵션명2"), "string");
                String optNm3 = (String) getExcelInputValue(map.get("옵션명3"), "string");
                String optNm4 = (String) getExcelInputValue(map.get("옵션명4"), "string");

                String optValue1 = (String) getExcelInputValue(map.get("옵션값1"), "string");
                String optValue2 = (String) getExcelInputValue(map.get("옵션값2"), "string");
                String optValue3 = (String) getExcelInputValue(map.get("옵션값3"), "string");
                String optValue4 = (String) getExcelInputValue(map.get("옵션값4"), "string");

                // 이전 상품명과 상품명이 다를 경우 새로운 상품으로 등록
                if (!goodsNm.equals(prevGoodsNm)) {
                    po = new GoodsDetailPO();
                    po.setSiteNo(siteNo);

                    // 새로운 상품번호 취득
                    String goodsNoSeq = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectNewGoodsNo", po);
                    StringBuffer sbGoodsNo = new StringBuffer().append("G").append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_").append(StringUtil.padLeft(goodsNoSeq, "0", 4));
                    goodsNo = sbGoodsNo.toString();

                    // 상품 정보 설정
                    po.setGoodsNo(goodsNo);
                    po.setGoodsNm(goodsNm);

                    // 상품고시정보
                    String notifyNo = (String) getExcelInputValue(map.get("고시번호"), "string");
                    po.setNotifyNo(notifyNo);
                    GoodsNotifySO notifySO = new GoodsNotifySO();
                    notifySO.setNotifyNo(notifyNo);
                    List<GoodsNotifyVO> notifyList = this.selectGoodsNotifyItemList(notifySO);
                    for(int i=0;i<notifyList.size();i++) {
                    	GoodsNotifyPO notifyPO = new GoodsNotifyPO();
                    	notifyPO.setItemNo(Long.valueOf(notifyList.get(i).getItemNo()));
                    	notifyPO.setGoodsNo(po.getGoodsNo());
                    	notifyPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    	notifyPO.setItemValue("상품 상세설명 참조");
                    	proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsNotify", notifyPO);
                    }

                    po.setSellerNo((String) getExcelInputValue(map.get("판매자번호"), "string"));
                    po.setGoodsSaleStatusCd((String) getExcelInputValue(map.get("상품판매상태"), "string"));
                    po.setSaleStartDt((String) getExcelInputValue(map.get("판매시작일자"), "string"));
                    po.setSaleEndDt((String) getExcelInputValue(map.get("판매종료일자"), "string"));
                    po.setPrWords((String) getExcelInputValue(map.get("간단설명"), "string"));
                    po.setContent((String) getExcelInputValue(map.get("상품상세설명"), "string"));
                    po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
                    po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
                    po.setMmft((String) getExcelInputValue(map.get("제조사"), "string"));
                    po.setHabitat((String) getExcelInputValue(map.get("원산지"), "string"));
                    po.setSeoSearchWord((String) getExcelInputValue(map.get("SEO검색용태그"), "string"));

                    // 배송 정보 설정
                    po.setDlvrSetCd((String) getExcelInputValue(map.get("배송정책"), "string"));
                    po.setGoodseachDlvrc((String) getExcelInputValue(map.get("상품별배송비"), "string"));
                    po.setPackMaxUnit((String) getExcelInputValue(map.get("포장최대단위"), "string"));
                    po.setPackUnitDlvrc((String) getExcelInputValue(map.get("포장별배송비"), "string"));

                    po.setDispYn("Y");
                    po.setReturnPsbYn("N");
                    po.setAdultCertifyYn("N");
                    po.setMaxOrdLimitYn("N");
                    po.setMinOrdLimitYn("N");
                    po.setGoodsContsGbCd("01");

                    // 상품 과세, 비과세 정보 설정
                    po.setTaxGbCd((String) getExcelInputValue(map.get("과세/비과세"), "string"));

                    // 상품 단일, 다중 옵션 정보 설정
                    String multiOptGb = (String) getExcelInputValue(map.get("상품판매정보"), "string");
                    po.setMultiOptYn(multiOptGb);

                    if (!StringUtils.isEmpty(multiOptGb)) {
                        // 다중 옵션형 상품 처리
                        if ("Y".equals(multiOptGb)) {
                            // 상품 정보 등록
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsBasicInfo", po);

                            // 옵션 정보 저장 Object 생성
                            optList = new ArrayList<String>();
                            optItemList = new ArrayList<>();

                            if (!StringUtils.isEmpty(optNm1)) {
                                optValue1List = new ArrayList<String>();
                            }
                            if (!StringUtils.isEmpty(optNm2)) {
                                optValue2List = new ArrayList<String>();
                            }
                            if (!StringUtils.isEmpty(optNm3)) {
                                optValue3List = new ArrayList<String>();
                            }
                            if (!StringUtils.isEmpty(optNm4)) {
                                optValue4List = new ArrayList<String>();
                            }

                            // 단일 옵션 상품 처리
                        } else {
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsBasicInfo", po);

                            Long itemSeq = bizService.getSequence("ITEM_NO");
                            StringBuffer sbItem = new StringBuffer().append("I")
                                    .append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_")
                                    .append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                            String itemNo = sbItem.toString();

                            GoodsItemPO itemPO = new GoodsItemPO();
                            itemPO.setSiteNo(siteNo);
                            itemPO.setGoodsNo(goodsNo);
                            itemPO.setItemNo(itemNo);
                            itemPO.setSepSupplyPriceYn("Y"); //별도공급가적용
                            itemPO.setSaleQtt(0L);
                            itemPO.setSupplyPrice((Long) getExcelInputValue(map.get("공급가"), "long"));
                            itemPO.setCustomerPrice((Long) getExcelInputValue(map.get("소비자가"), "long"));
                            itemPO.setSalePrice((Long) getExcelInputValue(map.get("판매가"), "long"));
                            itemPO.setStockQtt((Long) getExcelInputValue(map.get("재고"), "long"));

                            // 단품 정보 등록
                            itemPO.setItemVer(1L);
                            updateItemInfo(itemPO, false);
                            // 상품 대표 단품 번호 변경
                            po.setItemNo(itemNo);
                            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsItemNo", po);
                        }
                    }

                    // 상품명이 변경되었으나 단품 리스트에 정보가 그대로 남아 있을 경우
                    // 이전 상품 정보의 다중 옵션 등록 처리를 한다.
                    if (prevGoodsNo != null && optItemList != null && optList != null) {
                        List<String> uniqueOptValue1List = null;
                        List<String> uniqueOptValue2List = null;
                        List<String> uniqueOptValue3List = null;
                        List<String> uniqueOptValue4List = null;

                        Map<String, Long> optNoMap = new HashMap<>();
                        Map<String, Long> attrNoMap = new HashMap<>();

                        long optSeq = 0L;
                        for (String option : optList) {
                            GoodsOptionPO optionPO = new GoodsOptionPO();
                            optionPO.setSiteNo(siteNo);
                            optionPO.setGoodsNo(prevGoodsNo); // (주의)현 상품이 아닌 이전
                                                              // 상품정보 처리
                            optionPO.setOptNm(option);
                            optionPO.setOptSeq(optSeq++);
                            optionPO.setUseYn("Y");
                            optionPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                            if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                            	optionPO.setOptNo(bizService.getSequence("OPT_NO"));
                            }
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertOption", optionPO);
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsOption", optionPO);

                            optNoMap.put(option, optionPO.getOptNo());
                        }

                        if (optValue1List != null && optValue1List.size() > 0 && optList.size() > 0) {
                            uniqueOptValue1List = new ArrayList<String>(new HashSet<String>(optValue1List));

                            String optNm = optList.get(0);
                            long optNo = optNoMap.get(optNm);

                            for (String attrNm : uniqueOptValue1List) {
                                GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                                attrPO.setSiteNo(siteNo);
                                attrPO.setOptNo(optNo);
                                attrPO.setAttrNm(attrNm);
                                attrPO.setUseYn("Y");
                                attrPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                                	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                                attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                            }
                        }
                        if (optValue2List != null && optValue2List.size() > 0 && optList.size() > 1) {
                            uniqueOptValue2List = new ArrayList<String>(new HashSet<String>(optValue2List));

                            String optNm = optList.get(1);
                            long optNo = optNoMap.get(optNm);

                            for (String attrNm : uniqueOptValue2List) {
                                GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                                attrPO.setSiteNo(siteNo);
                                attrPO.setOptNo(optNo);
                                attrPO.setAttrNm(attrNm);
                                attrPO.setUseYn("Y");
                                attrPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                                	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                                attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                            }
                        }
                        if (optValue3List != null && optValue3List.size() > 0 && optList.size() > 2) {
                            uniqueOptValue3List = new ArrayList<String>(new HashSet<String>(optValue3List));

                            String optNm = optList.get(2);
                            long optNo = optNoMap.get(optNm);

                            for (String attrNm : uniqueOptValue3List) {
                                GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                                attrPO.setSiteNo(siteNo);
                                attrPO.setOptNo(optNo);
                                attrPO.setAttrNm(attrNm);
                                attrPO.setUseYn("Y");
                                attrPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                                	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                                attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                            }
                        }
                        if (optValue4List != null && optValue4List.size() > 0 && optList.size() > 3) {
                            uniqueOptValue4List = new ArrayList<String>(new HashSet<String>(optValue4List));

                            String optNm = optList.get(3);
                            long optNo = optNoMap.get(optNm);

                            for (String attrNm : uniqueOptValue4List) {
                                GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                                attrPO.setSiteNo(siteNo);
                                attrPO.setOptNo(optNo);
                                attrPO.setAttrNm(attrNm);
                                attrPO.setUseYn("Y");
                                attrPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                                	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                                }
                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                                attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                            }
                        }

                        for (GoodsItemPO itemPO : optItemList) {
                            // 단품 정보 등록
                            itemPO.setItemVer(1L);
                            updateItemInfo(itemPO, false);

                            // 옵션1, 속성 정보 설정
                            if (!StringUtil.isEmpty(itemPO.getOptValue1())
                                    && !StringUtil.isEmpty(itemPO.getAttrValue1())) {
                                long optNo = optNoMap.get(itemPO.getOptValue1());
                                itemPO.setOptNo1(optNo);
                                itemPO.setAttrNo1(attrNoMap.get(optNo + "_" + itemPO.getAttrValue1()));
                            }
                            // 옵션2, 속성 정보 설정
                            if (!StringUtil.isEmpty(itemPO.getOptValue2())
                                    && !StringUtil.isEmpty(itemPO.getAttrValue2())) {
                                long optNo = optNoMap.get(itemPO.getOptValue2());
                                itemPO.setOptNo2(optNo);
                                itemPO.setAttrNo2(attrNoMap.get(optNo + "_" + itemPO.getAttrValue2()));
                            }
                            // 옵션3, 속성 정보 설정
                            if (!StringUtil.isEmpty(itemPO.getOptValue3())
                                    && !StringUtil.isEmpty(itemPO.getAttrValue3())) {
                                long optNo = optNoMap.get(itemPO.getOptValue3());
                                itemPO.setOptNo3(optNo);
                                itemPO.setAttrNo3(attrNoMap.get(optNo + "_" + itemPO.getAttrValue3()));
                            }
                            // 옵션4, 속성 정보 설정
                            if (!StringUtil.isEmpty(itemPO.getOptValue4())
                                    && !StringUtil.isEmpty(itemPO.getAttrValue4())) {
                                long optNo = optNoMap.get(itemPO.getOptValue4());
                                itemPO.setOptNo4(optNo);
                                itemPO.setAttrNo4(attrNoMap.get(optNo + "_" + itemPO.getAttrValue4()));
                            }
                            itemPO.setAttrVer(1L);
                            // 옵션 속성 정보 등록
                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAttr", itemPO);

                        }

                        // 상품 대표 단품 번호 변경
                        if (optItemList != null && optItemList.size() > 0) {
                            GoodsItemPO item = optItemList.get(0);
                            proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsItemNo", item);
                        }

                        // 이전 상품 정보 초기화
                        optList = null;
                        optValue1List = null;
                        optValue2List = null;
                        optValue3List = null;
                        optValue4List = null;
                        optItemList = null;
                    }

                    // 상품상세설명
                    GoodsDetailPO detailPO = new GoodsDetailPO();
                    detailPO.setGoodsNo(po.getGoodsNo());
                    detailPO.setSvcGbCd("01");
                    String content = (String) getExcelInputValue(map.get("상품상세설명"), "string");
                    detailPO.setContent(StringUtil.replaceAll(content, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
                    detailPO.setContent(StringUtil.replaceAll(content, UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));

                    //detailPO.setMobileContent(StringUtil.replaceAll(content, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
                    //detailPO.setMobileContent(StringUtil.replaceAll(content, UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));

                    detailPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsDescript", detailPO);

                }


                if (prevGoodsNm == null || goodsNm.equals(prevGoodsNm)) {
                    if (prevGoodsNm == null) {
                        goodsNo = po.getGoodsNo();
                    } else {
                        goodsNo = prevGoodsNo;
                    }
                    po.setGoodsNo(goodsNo);
                    // 단품 정보 설정 Object 설정
                    Long itemSeq = bizService.getSequence("ITEM_NO");
                    StringBuffer sbItem = new StringBuffer().append("I")
                            .append(DateUtil.calDate(DATE_FORMAT_FOR_GOODS_NO)).append("_")
                            .append(StringUtil.padLeft(String.valueOf(itemSeq), "0", 4));
                    String itemNo = sbItem.toString();

                    GoodsItemPO itemPO = new GoodsItemPO();
                    itemPO.setSiteNo(siteNo);
                    itemPO.setGoodsNo(goodsNo);
                    itemPO.setItemNo(itemNo);
                    itemPO.setSaleQtt(0L);
                    itemPO.setSepSupplyPriceYn("Y"); //별도공급가적용
                    itemPO.setStockQtt((Long) getExcelInputValue(map.get("옵션재고"), "long"));
                    itemPO.setSupplyPrice((Long) getExcelInputValue(map.get("옵션공급가"), "long"));
                    itemPO.setCustomerPrice((Long) getExcelInputValue(map.get("옵션소비자가"), "long"));
                    itemPO.setSalePrice((Long) getExcelInputValue(map.get("옵션판매가"), "long"));

                    if (!StringUtils.isEmpty(optNm1)) {
                        itemPO.setOptValue1(optNm1);
                        if (optList != null) {
                            optList.add(optNm1);
                        }
                    }
                    if (!StringUtils.isEmpty(optNm2)) {
                        itemPO.setOptValue2(optNm2);
                        if (optList != null) {
                            optList.add(optNm2);
                        }
                    }
                    if (!StringUtils.isEmpty(optNm3)) {
                        itemPO.setOptValue3(optNm3);
                        if (optList != null) {
                            optList.add(optNm3);
                        }
                    }
                    if (!StringUtils.isEmpty(optNm4)) {
                        itemPO.setOptValue4(optNm4);
                        if (optList != null) {
                            optList.add(optNm4);
                        }
                    }

                    if (optValue1List != null && optValue1 != null) {
                        optValue1List.add(optValue1);
                        itemPO.setAttrValue1(optValue1);
                    }
                    if (optValue2List != null && optValue2 != null) {
                        optValue2List.add(optValue2);
                        itemPO.setAttrValue2(optValue2);
                    }
                    if (optValue3List != null && optValue3 != null) {
                        optValue3List.add(optValue3);
                        itemPO.setAttrValue3(optValue3);
                    }
                    if (optValue4List != null && optValue4 != null) {
                        optValue4List.add(optValue4);
                        itemPO.setAttrValue4(optValue4);
                    }

                    if (optItemList != null) {
                        optItemList.add(itemPO);
                    }
                }
                prevGoodsNm = goodsNm;
                prevGoodsNo = goodsNo;
            }
            list.add(po);
        }

        // 이전 상품 정보가 등록이 안되었을 경우
        if (prevGoodsNo != null && optItemList != null && optList != null) {
            po.setSiteNo(siteNo);
            // 상품 정보 설정
            po.setGoodsNo(prevGoodsNo);
            po.setGoodsNm(prevGoodsNm);

            List<String> uniqueOptValue1List = null;
            List<String> uniqueOptValue2List = null;
            List<String> uniqueOptValue3List = null;
            List<String> uniqueOptValue4List = null;

            Map<String, Long> optNoMap = new HashMap<>();
            Map<String, Long> attrNoMap = new HashMap<>();

            long optSeq = 0L;
            for (String option : optList) {
                GoodsOptionPO optionPO = new GoodsOptionPO();
                optionPO.setSiteNo(siteNo);
                optionPO.setGoodsNo(prevGoodsNo); // (주의)현 상품이 아닌 이전 상품정보 처리
                optionPO.setOptNm(option);
                optionPO.setOptSeq(optSeq++);
                optionPO.setUseYn("Y");
                optionPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                	optionPO.setOptNo(bizService.getSequence("OPT_NO"));
                }
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertOption", optionPO);
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsOption", optionPO);

                optNoMap.put(option, optionPO.getOptNo());
            }

            if (optValue1List != null && optValue1List.size() > 0 && optList.size() > 0) {
                uniqueOptValue1List = new ArrayList<String>(new HashSet<String>(optValue1List));

                String optNm = optList.get(0);
                long optNo = optNoMap.get(optNm);

                for (String attrNm : uniqueOptValue1List) {
                    GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                    attrPO.setSiteNo(siteNo);
                    attrPO.setOptNo(optNo);
                    attrPO.setAttrNm(attrNm);
                    attrPO.setUseYn("Y");
                    attrPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                    attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                }
            }
            if (optValue2List != null && optValue2List.size() > 0 && optList.size() > 1) {
                uniqueOptValue2List = new ArrayList<String>(new HashSet<String>(optValue2List));

                String optNm = optList.get(1);
                long optNo = optNoMap.get(optNm);

                for (String attrNm : uniqueOptValue2List) {
                    GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                    attrPO.setSiteNo(siteNo);
                    attrPO.setOptNo(optNo);
                    attrPO.setAttrNm(attrNm);
                    attrPO.setUseYn("Y");
                    attrPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                    attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                }
            }
            if (optValue3List != null && optValue3List.size() > 0 && optList.size() > 2) {
                uniqueOptValue3List = new ArrayList<String>(new HashSet<String>(optValue3List));

                String optNm = optList.get(2);
                long optNo = optNoMap.get(optNm);

                for (String attrNm : uniqueOptValue3List) {
                    GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                    attrPO.setSiteNo(siteNo);
                    attrPO.setOptNo(optNo);
                    attrPO.setAttrNm(attrNm);
                    attrPO.setUseYn("Y");
                    attrPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                    attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                }
            }
            if (optValue4List != null && optValue4List.size() > 0 && optList.size() > 3) {
                uniqueOptValue4List = new ArrayList<String>(new HashSet<String>(optValue4List));

                String optNm = optList.get(3);
                long optNo = optNoMap.get(optNm);

                for (String attrNm : uniqueOptValue4List) {
                    GoodsOptionAttrPO attrPO = new GoodsOptionAttrPO();
                    attrPO.setSiteNo(siteNo);
                    attrPO.setOptNo(optNo);
                    attrPO.setAttrNm(attrNm);
                    attrPO.setUseYn("Y");
                    attrPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                    if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)){
                    	attrPO.setAttrNo(bizService.getSequence("ATTR_NO"));
                    }
                    proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertAttr", attrPO);
                    attrNoMap.put(optNo + "_" + attrNm, attrPO.getAttrNo());
                }
            }

            for (GoodsItemPO itemPO : optItemList) {
                // 단품 정보 등록
                updateItemInfo(itemPO, true);

                // 옵션1, 속성 정보 설정
                if (!StringUtil.isEmpty(itemPO.getOptValue1()) && !StringUtil.isEmpty(itemPO.getAttrValue1())) {
                    long optNo = optNoMap.get(itemPO.getOptValue1());
                    itemPO.setOptNo1(optNo);
                    itemPO.setAttrNo1(attrNoMap.get(optNo + "_" + itemPO.getAttrValue1()));
                }
                // 옵션2, 속성 정보 설정
                if (!StringUtil.isEmpty(itemPO.getOptValue2()) && !StringUtil.isEmpty(itemPO.getAttrValue2())) {
                    long optNo = optNoMap.get(itemPO.getOptValue2());
                    itemPO.setOptNo2(optNo);
                    itemPO.setAttrNo2(attrNoMap.get(optNo + "_" + itemPO.getAttrValue2()));
                }
                // 옵션3, 속성 정보 설정
                if (!StringUtil.isEmpty(itemPO.getOptValue3()) && !StringUtil.isEmpty(itemPO.getAttrValue3())) {
                    long optNo = optNoMap.get(itemPO.getOptValue3());
                    itemPO.setOptNo3(optNo);
                    itemPO.setAttrNo3(attrNoMap.get(optNo + "_" + itemPO.getAttrValue3()));
                }
                // 옵션4, 속성 정보 설정
                if (!StringUtil.isEmpty(itemPO.getOptValue4()) && !StringUtil.isEmpty(itemPO.getAttrValue4())) {
                    long optNo = optNoMap.get(itemPO.getOptValue4());
                    itemPO.setOptNo4(optNo);
                    itemPO.setAttrNo4(attrNoMap.get(optNo + "_" + itemPO.getAttrValue4()));
                }
                itemPO.setAttrVer(1L);
                // 옵션 속성 정보 등록
                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsAttr", itemPO);


            }
            // log.info("======================================> KWT po :" + po);

            list.add(po);
        }
        return list;

    }

    private static Object getExcelInputValue(Object value, String type) {
        Object obj = null;
        if (value instanceof Boolean && !(((Boolean) value).booleanValue())) {
            if ("string".equals(type)) {
                obj = "";
            } else if ("long".equals(type)) {
                obj = 0L;
            } else if ("double".equals(type)) {
                obj = 0D;
            }
        } else {
            if ("string".equals(type)) {
                if (value instanceof Double) {
                    obj = String.valueOf(value);
                } else {
                    obj = value;
                }
            } else if ("long".equals(type)) {
                if (value instanceof Double) {
                    obj = (long) ((double) value);
                } else if (value instanceof String) {
                    obj = Long.valueOf((String) value);
                } else {
                    obj = value;
                }
            } else if ("double".equals(type)) {
                obj = value;
            }
        }
        return obj;
    }

    private static void deleteGoodsImg(String goodsFilePath, String goodsFileName) throws Exception {
        StringBuffer sbPath = new StringBuffer().append(SiteUtil.getSiteUplaodRootPath())
                .append(FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS))
                .append(File.separator).append(goodsFilePath.substring(0, 4)).append(File.separator)
                .append(goodsFilePath.substring(4, 6)).append(File.separator).append(goodsFilePath.substring(6));
        // log.info("[########## FILE DELETE #########] deleteGoodsImg :" +
        // sbPath.toString());
        File file = new File(sbPath.toString() + File.separator + goodsFileName);
        if (file.exists()) { // 존재한다면 삭제
            FileUtil.delete(file);
        }

        // 이미지 디렉토리에 같은 이름을 가진 이미지 파일이 없을 경우, 썸네일 이미지도 삭제한다.
        File directory = new File(sbPath.toString());
        // 이미지 디렉토리의 파일리스트 취득
        File[] tempFile = directory.listFiles();
        String goodsFileNm = goodsFileName.substring(0, goodsFileName.indexOf("_"));
        boolean doDelete = true;
        if (goodsFileNm != null && tempFile != null && tempFile.length > 0) {
            for (int i = 0; i < tempFile.length; i++) {
                if (tempFile[i].isFile()) {
                    String tempFileNm = tempFile[i].getName();
                    // 썸네일 파일이 아닌 파일을 대상으로 같은 파일명의 이미지 파일이 있나 확인한다.
                    if (tempFileNm.indexOf(CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX) < 0
                            && goodsFileNm.equals(tempFileNm.substring(0, tempFileNm.indexOf("_")))) {
                        doDelete = false;
                        break;
                    }
                }
            }
            if (doDelete) {
                File prefixFile = new File(sbPath.toString() + File.separator + goodsFileNm+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);
                // log.info("[########## FILE DELETE #########] deleteGoodsImg -
                // PREFIX :" + sbPath.toString()
                // + File.separator + goodsFileNm +
                // CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);

                if (prefixFile.exists()) { // 존재한다면 삭제
                    FileUtil.delete(prefixFile);
                }
            }
        }
    }

    private static void deleteGoodsItemImg(String goodsFilePath, String goodsFileName) throws Exception {
        StringBuffer sbPath = new StringBuffer().append(SiteUtil.getSiteUplaodRootPath())
                .append(FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS_ITEM))
                .append(File.separator).append(goodsFilePath.substring(0, 4)).append(File.separator)
                .append(goodsFilePath.substring(4, 6)).append(File.separator).append(goodsFilePath.substring(6));
        log.info("[########## FILE DELETE #########] deleteGoodsItemImg :" + sbPath.toString());
        File file = new File(sbPath.toString() + File.separator + goodsFileName);
        if (file.exists()) { // 존재한다면 삭제
            FileUtil.delete(file);
        }

        // 이미지 디렉토리에 같은 이름을 가진 이미지 파일이 없을 경우, 썸네일 이미지도 삭제한다.
        File directory = new File(sbPath.toString());
        // 이미지 디렉토리의 파일리스트 취득
        File[] tempFile = directory.listFiles();
        String goodsFileNm = goodsFileName.substring(0, goodsFileName.indexOf("_"));
        boolean doDelete = true;
        if (goodsFileNm != null && tempFile != null && tempFile.length > 0) {
            for (int i = 0; i < tempFile.length; i++) {
                if (tempFile[i].isFile()) {
                    String tempFileNm = tempFile[i].getName();
                    // 썸네일 파일이 아닌 파일을 대상으로 같은 파일명의 이미지 파일이 있나 확인한다.
                    if (tempFileNm.indexOf(CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX) < 0
                            && goodsFileNm.equals(tempFileNm.substring(0, tempFileNm.indexOf("_")))) {
                        doDelete = false;
                        break;
                    }
                }
            }
            if (doDelete) {
                File prefixFile = new File(sbPath.toString() + File.separator + goodsFileNm+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);
                // log.info("[########## FILE DELETE #########] deleteGoodsImg -
                // PREFIX :" + sbPath.toString()
                // + File.separator + goodsFileNm +
                // CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);

                if (prefixFile.exists()) { // 존재한다면 삭제
                    FileUtil.delete(prefixFile);
                }
            }
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsVO> selectRelateGoodsListByIn(GoodsDetailVO vo) {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectRelateGoodsListByIn", vo);
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsVO> selectRelateGoodsList(GoodsDetailVO vo) {

        // log.info("################################ selectRelateGoodsList vo
        // {}" + vo);

        // 관련 상품 처리 ('3'(관련상품 없음)이 아닐 경우)
        List<GoodsVO> relateGoodsList = null;
        if (!StringUtil.isEmpty(vo.getRelateGoodsApplyTypeCd())) {
            // 관련 상품 직접 선정의 경우
            if ("2".equals(vo.getRelateGoodsApplyTypeCd())) {
                if (vo.getRelateGoodsList() != null && vo.getRelateGoodsList().size() > 0) {
                    relateGoodsList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectRelateGoodsListByIn",vo);
                }

            } else if ("1".equals(vo.getRelateGoodsApplyTypeCd())) {
                GoodsSO goodsSo = new GoodsSO();
                goodsSo.setSiteNo(vo.getSiteNo());

                // 관련 상품 카테고리 1
                if (!StringUtil.isEmpty(vo.getRelateGoodsApplyCtgNo1())) {
                    goodsSo.setSearchCtg1(vo.getRelateGoodsApplyCtgNo1());
                }
                // 관련 상품 카테고리 2
                if (!StringUtil.isEmpty(vo.getRelateGoodsApplyCtgNo2())) {
                    goodsSo.setSearchCtg1(vo.getRelateGoodsApplyCtgNo2());
                }
                // 관련 상품 카테고리 3
                if (!StringUtil.isEmpty(vo.getRelateGoodsApplyCtgNo3())) {
                    goodsSo.setSearchCtg1(vo.getRelateGoodsApplyCtgNo3());
                }
                // 관련 상품 카테고리 4
                if (!StringUtil.isEmpty(vo.getRelateGoodsApplyCtgNo4())) {
                    goodsSo.setSearchCtg1(vo.getRelateGoodsApplyCtgNo4());
                }
                // 관련 상품 판매가격 시작
                if (!StringUtil.isEmpty(vo.getRelateGoodsSalePriceStart())) {
                    goodsSo.setSearchPriceFrom(vo.getRelateGoodsSalePriceStart().replaceAll(",", ""));
                }
                // 관련 상품 판매가격 끝
                if (!StringUtil.isEmpty(vo.getRelateGoodsSalePriceEnd())) {
                    goodsSo.setSearchPriceTo(vo.getRelateGoodsSalePriceEnd().replaceAll(",", ""));
                }
                // 판매상태 (조건 설정 값이 없을 경우 디폴트 값으로 판매중('1')을 설정)
                if (!StringUtil.isEmpty(vo.getRelateGoodsSaleStatusCd())) {
                    String statusCd = vo.getRelateGoodsSaleStatusCd();
                    if (!"0".equals(statusCd)) {
                        goodsSo.setGoodsStatus(new String[] { statusCd });
                    }
                } else {
                    goodsSo.setGoodsStatus(new String[] { "1" });
                }
                // 전시상태 (조건 설정 값이 없을 경우 디폴트 값으로 전시('Y')를 설정)
                if (!StringUtil.isEmpty(vo.getRelateGoodsDispStatusCd())) {
                    String dispCd = vo.getRelateGoodsDispStatusCd();
                    if ("2".equals(dispCd)) {
                        goodsSo.setGoodsDisplay(new String[] { "Y" });
                    } else if ("3".equals(dispCd)) {
                        goodsSo.setGoodsDisplay(new String[] { "N" });
                    }
                } else {
                    goodsSo.setGoodsDisplay(new String[] { "Y" });
                }
                // 정렬 순서
                if (!StringUtil.isEmpty(vo.getRelateGoodsAutoExpsSortCd())) {
                    switch (vo.getRelateGoodsAutoExpsSortCd()) {
                    case "01":
                        goodsSo.setSidx("REG_DTTM");
                        break;
                    case "02":
                        goodsSo.setSidx("ACCM_SALE_AMT");
                        break;
                    case "03":
                        goodsSo.setSidx("ACCM_SALE_CNT");
                        break;
                    case "04":
                        goodsSo.setSidx("ACCM_GOODSLETT_CNT");
                        break;
                    case "05":
                        goodsSo.setSidx("BASKET_SET_CNT");
                        break;
                    case "06":
                        goodsSo.setSidx("FAVGOODS_SET_CNT");
                        break;
                    case "07":
                        goodsSo.setSidx("GOODS_INQ_CNT");
                        break;
                    }
                    goodsSo.setSord("DESC");
                }else{
                    goodsSo.setSidx("REG_DTTM");
                    goodsSo.setSord("DESC");
                }

                int viewGoodsCnt = 5;
                goodsSo.setLimit(0);
                goodsSo.setOffset(viewGoodsCnt + 1);
                relateGoodsList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsListPaging", goodsSo);

                if (relateGoodsList != null && relateGoodsList.size() > 0) {
                    int removeIdx = -1;
                    for (int i = 0; i < relateGoodsList.size(); i++) {
                        GoodsVO vo1 = relateGoodsList.get(i);
                        if (vo.getGoodsNo().equals(vo1.getGoodsNo())) {
                            removeIdx = i;
                        }
                    }
                    if (removeIdx < 0 && relateGoodsList.size() > viewGoodsCnt) {
                        removeIdx = viewGoodsCnt;
                    }
                    if (removeIdx > -1) {
                        relateGoodsList.remove(removeIdx);
                    }
                }
            }
        }
        return relateGoodsList;
    }

	@Override
	public String selectBestBrandNo(BrandVO vo) {
		return proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectBestBrandNo", vo);
	}

	@Override
	public int preGoodsRsvChk(Map<String, String> param) {
		return proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "preGoodsRsvChk", param);
	}

    @Override
    public List<ContactWearVO> selectContactWearList(ContactWearSO so) {
        return proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectContactWearList", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<ContactWearVO> selectWearImgsetNoList(ContactWearSO so) {
        return proxyDao.selectListPage(MapperConstants.GOODS_MANAGE + "selectWearImgsetNoListPaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public FilterVO selectGoodsFilterLvl2Info(GoodsVO so) {
        FilterVO goodsFilterLvl2 = new FilterVO();
        // 단품 정보 조회
        // 상품 필터 정보 설정
        List<GoodsFilterVO> goodsFilterList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsFilter", so);

        if (goodsFilterList != null && goodsFilterList.size() > 0) {
            FilterSO filterSO = new FilterSO();
            filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            filterSO.setFilterNo(goodsFilterList.get(0).getFilterNo());
            goodsFilterLvl2 = proxyDao.selectOne(MapperConstants.FILTER_MANAGE + "selectFilterLvl2", filterSO);
            log.info("$$$$$$$$$$$$$$$$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& goodsFilterLvl2 :" + goodsFilterLvl2);
        }

        // 리턴모델에 VO셋팅
        return goodsFilterLvl2;

    }

    public ProductMappingBundleResDTO ifBundleProductMapping(Map<String, Object> param) throws Exception {
        String ifId = Constants.IFID.PRODUCT_MAPPING_BUNDLE;

        ObjectMapper objectMapper = new ObjectMapper();
        ProductMappingBundleReqDTO productMappingBundleReqDTO = objectMapper.convertValue(param, ProductMappingBundleReqDTO.class);
        log.info("productMappingBundleReqDTO = "+productMappingBundleReqDTO);
        try {
            // 쇼핑몰 처리 부분
            // Response DTO 생성
            ProductMappingBundleResDTO resDto = new ProductMappingBundleResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 처리
            productService.bundleProductMapping(productMappingBundleReqDTO);

            // 처리로그 등록
            logService.writeInterfaceLog(ifId, productMappingBundleReqDTO, resDto);

            return resDto;
        } catch (CustomIfException ce) {
            ce.setReqParam(productMappingBundleReqDTO);
            ce.setIfId(ifId);
            throw ce;
        }/* catch (Exception e) {
            throw new CustomIfException(e, productMappingBundleReqDTO, ifId);
        }*/
    }

    /*
     * (non-Javadoc)
     *
     * @see GoodsManageService#
     * saveGoodsContents(GoodsContentsPO)
     */
    @Override
    public List<GoodsImageDtlPO> uploadGoodsImgList(List<Map<String, Object>> plist,
                                                     MultipartHttpServletRequest mRequest) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        List<GoodsImageDtlPO> list = new ArrayList<GoodsImageDtlPO>();
        //GoodsImageDtlPO po = null;

        Long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        String preGoodsNo = null;
        int imagesTotalCount = 0;
        int updatedImageTotalCount = 0;

        int preImgNoForDel = 0;
        String preGoodsNoForDel = null;

        //log.info("plist = "+plist);
        for (Map<String, Object> map : plist) {
            // 신규 GOODS_NO 취득
            String goodsNo = (String) getExcelInputValue(map.get("GOODS_NO"), "string");
            String imgNm = (String) getExcelInputValue(map.get("IMG_NM"), "string");
            String imgNo = (String) getExcelInputValue(map.get("IMG_NO"), "string");
            String imgPath = (String) getExcelInputValue(map.get("IMG_PATH"), "string");

            if(preGoodsNo == null) { // 시작
                preGoodsNo = goodsNo;
            }
            log.info("goodsNo = " + goodsNo + " imgNm = " + imgNm + " imgNo = " + imgNo);
            if (StringUtils.isNotEmpty(goodsNo) && StringUtils.isNotEmpty(imgNm) && StringUtils.isNotEmpty(imgNo)) {

                GoodsImageDtlPO po = new GoodsImageDtlPO();
                po.setSiteNo(siteNo);

                // 상품 이미지 정보 설정
                po.setGoodsNo(goodsNo);
                po.setImgNm(imgNm);
                po.setUpdrNo(memberNo);
                po.setImgNo(Integer.parseInt(imgNo));
                po.setImgPath(imgPath);
                log.info("::::::::::::::::::::: goodsNo " + goodsNo + " preGoodsNo = " + preGoodsNo);
                if(!preGoodsNo.equals(goodsNo)) {// 다음 image
                    log.info("::::::::::::::::::::: next goodsNo " + goodsNo + " imgNm = " + imgNm + " imgNo = " + imgNo + " imgPath = " + imgPath);
                    if(imagesTotalCount > preImgNoForDel) {// 업데이트 안하는 image는 삭제
                        log.info("::::::::::::::::::::: 업데이트 안하는 image는 삭제 갯수 " + (imagesTotalCount - preImgNoForDel));
                        for(int i = 1; i <= (imagesTotalCount - preImgNoForDel);i++) {
                            GoodsImageDtlPO delPo = new GoodsImageDtlPO();
                            delPo.setSiteNo(siteNo);
                            delPo.setGoodsNo(preGoodsNoForDel);
                            delPo.setImgNo(updatedImageTotalCount + 1);
                            delPo.setGoodsImgsetNo(Long.parseLong(proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsImagesSetNo", delPo)));
                            log.info("::::::::::::::::::::: delete " + delPo);
                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsImageDtlSet", delPo);
                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsImageSet", delPo);
                        }
                    }
                    imagesTotalCount = 0;
                    updatedImageTotalCount = 0;
                    preGoodsNo = goodsNo;
                }

                if(imagesTotalCount == 0) {// 이미지 총 갯수 취득
                    imagesTotalCount = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsImagesCount", po);
                }
                log.info("::::::::::::::::::::: update goodsNo " + goodsNo + " imagesTotalCount " + imagesTotalCount + " imgNm = " + imgNm + " imgNo = " + imgNo + " imgPath = " + imgPath);
                // 이미지 업데이트
                proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsImages", po);
                updatedImageTotalCount++;
                // 이전 이미지 정보 저장
                preImgNoForDel = po.getImgNo();
                preGoodsNoForDel = po.getGoodsNo();
                list.add(po);
            }
        }

        return list;
    }

    @Override
    public List<GoodsVO> selectGoodsInfoChangeHist(GoodsSO so) {
        List<GoodsVO> resultList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsInfoHistLog", so);

        log.info("resultList = "+resultList);
        if(resultList != null && resultList.size() > 0) {
            for (GoodsVO goodsVO : resultList) {
                String log = "[" + goodsVO.getChangeDttm() + "]" + goodsVO.getGoodsInfoChangeLog();
                log = log.replace("],", "] ");
                goodsVO.setGoodsInfoChangeLog(log);
            }
        }
        return resultList;
    }

    @Override
    public List<GoodsItemVO> uploadGoodsUpdateList(List<Map<String, Object>> plist,
                                                     MultipartHttpServletRequest mRequest) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        List<GoodsItemVO> list = new ArrayList<GoodsItemVO>();
        GoodsDetailPO po = new GoodsDetailPO();

        Long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        Long updrNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        Long regrNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        BrandSO brandSO = new BrandSO();
        brandSO.setSiteNo(siteNo);
        List<BrandVO> goodsBrandList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectBrandList", brandSO);
        // 브랜드 값 셋팅
//        goodsDisplayInfoVO.setBrandList(goodsBrandList);
        log.debug("::::::::::::::::::::: goodsBrandList :::::::::::::::::::::"+goodsBrandList);
        for (Map<String, Object> map : plist) {

            // GOODS_NO 취득
            String goodsNo = (String) getExcelInputValue(map.get("상품번호(필수)"), "string");
            log.debug(" ::: 상품업데이트 시작 ::: goodsNo {}", goodsNo);
            if (StringUtils.isEmpty(goodsNo)) {

            } else {
                po.setGoodsNo(goodsNo);
                po.setSiteNo(siteNo);
                po.setUpdrNo(updrNo);
                po.setRegrNo(regrNo);

                String multiOptYn = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectMultiOptYn", po);
                String dlgtItemNo = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsDlgtItemNo", po);
                String goodsDlgtCateory = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsDlgtCategory", po);
                String ordGoodsTypeCd = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsTypeCd", po);
                //int isExistGoods = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsDlgtCategory", po);
                String goodsTypeCd = "01";
                List<FilterVO> filterVOList = null;
                List<CtgVO> ctgVOList = null;
                String type = "";

                log.debug(" ::: 상품등록 처리 옵션 등록 ::: multiOptYn {}", multiOptYn);
                log.debug(" ::: 상품등록 처리 옵션 등록 ::: dlgtItemNo {}", dlgtItemNo);
                log.debug(" ::: 상품등록 처리 옵션 등록 ::: goodsDlgtCateory {}", goodsDlgtCateory);
                // 상품 유형 정보 셋팅
                if (StringUtil.isNotEmpty(goodsDlgtCateory) || StringUtil.isNotEmpty(ordGoodsTypeCd)) {
                    FilterSO filterSO = new FilterSO();
                    filterSO.setSiteNo(po.getSiteNo());

                    CtgVO ctgVO = new CtgVO();
                    ctgVO.setSiteNo(po.getSiteNo());
                    if(StringUtil.isNotEmpty(ordGoodsTypeCd)) {
                        goodsTypeCd = ordGoodsTypeCd;
                    } else {
                        if(goodsDlgtCateory.contains("안경테")) {
                            goodsTypeCd = "01";
                            type = MapperConstants.GLASS_BRAND_MAPPING;
                        } else if(goodsDlgtCateory.contains("선글라스")) {
                            goodsTypeCd = "02";
                            type = MapperConstants.GLASS_BRAND_MAPPING;
                        } else if(goodsDlgtCateory.contains("안경렌즈")) {
                            goodsTypeCd = "03";
                        } else if(goodsDlgtCateory.contains("콘택트렌즈")) {
                            goodsTypeCd = "04";
                            type = MapperConstants.CONTACT_BRAND_MAPPING;
                        } else if(goodsDlgtCateory.contains("소모품")) {
                            goodsTypeCd = "05";
                        }
                    }
                    log.info("상품 유형 :::::::::::::::::::::: "+goodsTypeCd);

                    filterSO.setFilterMenuLvl("2");
                    filterSO.setGoodsTypeCd(goodsTypeCd);
                    filterVOList = filterManageService.selectFiltersGoodsType(filterSO); // 상품 타입에 맞는 필터 리스트 가져 오기
                    //log.info("필터 list :::::::::::::::::::::: "+filterVOList);
                    ctgVO.setGoodsTypeCd(goodsTypeCd);
                    ctgVOList = selectCtgList(ctgVO);// 상품 타입에 맞는 카테고리 리스트 가져 오기
                    //log.info("카테고리 list :::::::::::::::::::::: "+ctgVOList);
                } else {
                    GoodsItemVO itemVO = new GoodsItemVO();
                    String result = "대표 카테고리가 없는 상품 :::::::::::::::::::::: 존제하지 않는 상품 "+po.getGoodsNo();
                    log.info(result);
                    itemVO.setGoodsDesc(result);
                    list.add(itemVO);
                    continue;
                    //throw new Exception("대표 카테고리가 없는 상품");
                }
                // 다중 옵션의 경우
                if ("Y".equals(multiOptYn)) {
                    log.debug("::: 상품등록 처리 다중 옵션 등록 ::: ");
                    // 상품 코드에 묶여 있는 각각의 item들을 가져옴
                    po.setItemNo("");
                } else {
                    log.debug("::: 상품등록 처리 단일 옵션 등록 ::: ");
                    // 상품 코드에 대표 item을 가져옴
                    po.setItemNo(dlgtItemNo);
                }

                List<GoodsItemVO> goodsItemList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsItemsInfo", po);
                log.debug("::: org 상품 정보 취득 ::: goodsItemList "+goodsItemList);
                if (goodsItemList != null && goodsItemList.size() > 0) {
                    log.debug("::: 상품 리스크 사이즈 ::: "+goodsItemList.size());
                    for(GoodsItemVO itemVO : goodsItemList) {

                        if(!StringUtil.isEmpty(itemVO.getErpItmCode()) && !"123456".equals(itemVO.getErpItmCode())) {
                            ProductSearchReqDTO param = new ProductSearchReqDTO();
                            param.setItmCode(itemVO.getErpItmCode());
                            // 다비젼 상품 정보 가져옴
                            List<ProductSearchResDTO.ProductInfoDTO> prdList = productService.getProductList(param);

                            ProductSearchResDTO.ProductInfoDTO productInfoDTO = new ProductSearchResDTO.ProductInfoDTO();

                            List<GoodsFilterPO> goodsFilterList = new ArrayList<>();
                            List<GoodsCtgPO> goodsCtgList = new ArrayList<>();

                            if(StringUtil.isNotEmpty(dlgtItemNo)) {
                                if (prdList.size() > 0) {
                                    if(prdList.size() > 1) {
                                        log.info("다비젼 상품 정보가 여러개 있는 상품 ::::::::: "+po.getGoodsNo()+" ::::::::::: "+itemVO.getErpItmCode());
                                    } else {
                                        log.info("다비젼 상품 정보가 1개인 상품 ::::::::: "+po.getGoodsNo()+" ::::::::::: "+itemVO.getErpItmCode());
                                    }
                                    productInfoDTO = prdList.get(0);
                                    log.info("다비젼 상품 정보 ::::::::: "+productInfoDTO);

                                    if(StringUtil.isEmpty(po.getGoodsNo())) {
                                        throw new Exception("상품 코드 정보가 없는 상품");
                                    }

                                    // ::::::::::::::::: 상품 가격 및 제고 정보 셋팅
                                    GoodsItemPO davisonProductItemPo = new GoodsItemPO();
                                    davisonProductItemPo.setItemNo(itemVO.getItemNo());
                                    if(productInfoDTO.getCprc() != null) {
                                        davisonProductItemPo.setCost(Long.parseLong(productInfoDTO.getCprc()));
                                    }
                                    if(productInfoDTO.getSalePrc() != null) {
                                        davisonProductItemPo.setCustomerPrice(Long.parseLong(productInfoDTO.getSalePrc()));
                                    }
                                    if(productInfoDTO.getSalePrc() != null) {
                                        davisonProductItemPo.setSalePrice(Long.parseLong(productInfoDTO.getSalePrc()));
                                    }
                                    if(productInfoDTO.getSupplyPrc() != null) {
                                        davisonProductItemPo.setSupplyPrice(Long.parseLong(productInfoDTO.getSupplyPrc()));
                                    }
                                    if(productInfoDTO.getJego() != null) {
                                        davisonProductItemPo.setStockQtt(Long.parseLong(productInfoDTO.getJego()));
                                    }
                                    /*if(productInfoDTO.getUseInd() != null) {
                                        davisonProductItemPo.setUseYn(productInfoDTO.getUseInd());
                                    }*/
                                    davisonProductItemPo.setRegrNo(po.getRegrNo());
                                    davisonProductItemPo.setUpdrNo(po.getUpdrNo());
                                    davisonProductItemPo.setDcPriceApplyAlwaysYn("Y");

                                    if (itemVO != null) {
                                        Long preSalePrice = itemVO.getSalePrice();
                                        Long newSalePrice = davisonProductItemPo.getSalePrice();
                                        Long preStockQtt = itemVO.getStockQtt();
                                        Long newStockQtt = davisonProductItemPo.getStockQtt();

                                        /** 필수값 이전값(itemVO)으로 세팅.. Start */

                                        // 원가
                                        if(davisonProductItemPo.getCost() == null)
                                            davisonProductItemPo.setCost(itemVO.getCost());

                                        //소비자가격
                                        if(davisonProductItemPo.getCustomerPrice()==null)
                                            davisonProductItemPo.setCustomerPrice(itemVO.getCustomerPrice());

                                        //공급가격
                                        if(davisonProductItemPo.getSupplyPrice()==null)
                                            davisonProductItemPo.setSupplyPrice(itemVO.getSupplyPrice());

                                        //별도 공급가 여부
                                        if(davisonProductItemPo.getSepSupplyPriceYn()==null)
                                            davisonProductItemPo.setSepSupplyPriceYn(itemVO.getSepSupplyPriceYn());

                                        //재고 다비전 연동 여부
                                        if(davisonProductItemPo.getApplyDavisionStockYn()==null)
                                            davisonProductItemPo.setApplyDavisionStockYn(itemVO.getApplyDavisionStockYn());

                                        //재고
                                        if(davisonProductItemPo.getStockQtt()==null)
                                            davisonProductItemPo.setStockQtt(itemVO.getStockQtt());

                                        //사용여부
                                        if(davisonProductItemPo.getUseYn()==null)
                                            davisonProductItemPo.setUseYn(itemVO.getUseYn());

                                        //판매수량
                                        if(davisonProductItemPo.getSaleQtt()==null)
                                            davisonProductItemPo.setSaleQtt(itemVO.getSaleQtt());

                                        /** 필수값 이전값(itemVO)으로 세팅.. End */


                                        /** 판매가격 변경 시 */
                                        if (newSalePrice != null && !newSalePrice.equals(preSalePrice)) {
                                            // 가격 변경 시 ITEM_VER 을 변경
                                            davisonProductItemPo.setItemVer(itemVO.getItemVer() + 1);
                                            // 증감 코드 설정('00':인하, '01':인상)
                                            if (preSalePrice > newSalePrice) {
                                                davisonProductItemPo.setPriceChgCd("00");
                                                davisonProductItemPo.setSaleChdPrice(preSalePrice - newSalePrice);
                                            } else {
                                                davisonProductItemPo.setPriceChgCd("01");
                                                davisonProductItemPo.setSaleChdPrice(newSalePrice - preSalePrice);
                                            }

                                            // 단품 가격 변경 이력 테이블에 등록
                                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemPriceChgHist", davisonProductItemPo);
                                        }

                                        /** 재고 수량 변경 시 */
                                        if (newStockQtt != null && !newStockQtt.equals(preStockQtt)) {
                                            // 증감 코드 설정('00':출고, '01':입고)
                                            if (preStockQtt > newStockQtt) {
                                                davisonProductItemPo.setStockChgCd("00");
                                                davisonProductItemPo.setStockChdQtt(preStockQtt - newStockQtt);
                                            } else {
                                                davisonProductItemPo.setStockChgCd("01");
                                                davisonProductItemPo.setStockChdQtt(newStockQtt - preStockQtt);
                                            }
                                            // 단품 수량 변경 이력 테이블에 등록
                                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertItemStockChgHist", davisonProductItemPo);
                                        }

                                        // 단품 정보 수정
                                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsItemOne", davisonProductItemPo);
                                    }
                                    // ::::::::::::::::: 상품 가격 및 제고 정보 셋팅 end
                                    log.info("다비젼 상품 정보가 정상적인 상품 ::::::::: "+po.getGoodsNo()+" ::::::::::: "+itemVO.getErpItmCode()+" ::::::::::::::: "+prdList.size());
                                    if(dlgtItemNo.equals(itemVO.getItemNo())) { // 대표 아이템 일때 만 상품 기본 정보들 셋팅
                                        po.setGoodsNm(productInfoDTO.getItmName());
                                        po.setMmft(productInfoDTO.getMakName());

                                        for(BrandVO brandVO : goodsBrandList) {
                                            if(brandVO.getBrandNm().equals(ConverterUtil.getMappingValue(MapperConstants.MAPPING_METHOD_VALUE, type, "", productInfoDTO.getBrand()))
                                                && brandVO.getGoodsTypeCd().contains(goodsTypeCd)){
                                                po.setBrandNo(brandVO.getBrandNo());
                                                po.setBrandNm(brandVO.getBrandNm());
                                                break;
                                            }
                                        }

                                        if(StringUtil.isNotEmpty(po.getBrandNm())) {
                                            log.debug("::::::::: selected brand ::::::::::::: " + po.getBrandNm());
                                        } else {
                                            log.debug("::::::::: no brand ::::::::::::: ");
                                        }
                                        // ::::::::::::::::: 상품 기본 정보 셋팅
                                        proxyDao.update(MapperConstants.GOODS_MANAGE + "updateGoodsEtcInfo", po);// 브랜드, 웹발주, 제조사
                                        // 선택된 face code 정보 등록
                                        GoodsFaceCdPO goodsFaceCdPO = new GoodsFaceCdPO();
                                        goodsFaceCdPO.setGoodsNo(po.getGoodsNo());
                                        goodsFaceCdPO.setFdShape(productInfoDTO.getMyfaceCodeShape());
                                        goodsFaceCdPO.setFdTone(productInfoDTO.getMyfaceCodeTone());
                                        goodsFaceCdPO.setFdStyle(productInfoDTO.getMyfaceCodeStyle());
                                        goodsFaceCdPO.setEdShape(productInfoDTO.getMyeyeCodeShape());
                                        goodsFaceCdPO.setEdSize(productInfoDTO.getMyeyeCodeSize());
                                        goodsFaceCdPO.setEdStyle(productInfoDTO.getMyeyeCodeStyle());
                                        goodsFaceCdPO.setEdColor(productInfoDTO.getMyeyeCodeColor());
                                        goodsFaceCdPO.setRegrNo(po.getRegrNo());
                                        goodsFaceCdPO.setUpdrNo(po.getUpdrNo());
                                        proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertFaceCd", goodsFaceCdPO);

                                        // 선택된 안경테, 선글라스 사이즈 정보 등록
                                        if(goodsTypeCd.equals("01") || goodsTypeCd.equals("02")) {
                                            GoodsSizeCdPO sizeCdPO = new GoodsSizeCdPO();
                                            sizeCdPO.setGoodsNo(po.getGoodsNo());
                                            sizeCdPO.setFullSize(productInfoDTO.getJaewonOverallSize());
                                            sizeCdPO.setBridgeSize(productInfoDTO.getJaewonBridgeSize());
                                            sizeCdPO.setHorizontalLensSize(productInfoDTO.getJaewonHorizontalSize());
                                            sizeCdPO.setVerticalLensSize(productInfoDTO.getJaewonVerticalSize());
                                            sizeCdPO.setTempleSize(productInfoDTO.getJaewonLegSize());
                                            sizeCdPO.setRegrNo(po.getRegrNo());
                                            sizeCdPO.setUpdrNo(po.getUpdrNo());
                                            proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertSizeCd", sizeCdPO);
                                        }
                                        // ::::::::::::::::: 상품 기본 정보 셋팅 end
                                        // ::::::::::::::::: 필터 및 카테고리 정보 셋팅
                                        if (goodsTypeCd.equals("01")) { // 안경테
                                            // 필터 셋팅
                                            for(FilterVO filterVO : filterVOList) {
                                                if("M".equals(filterVO.getFilterRequire())) { // 필수 필터만 처리
                                                    if (productInfoDTO.getFrameShape() != null && filterVO.getText().equals(productInfoDTO.getFrameShape())) {/*모양*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getFrameSize() != null && filterVO.getText().equals(productInfoDTO.getFrameSize())) {/*사이즈*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getFrameStruct() != null && filterVO.getText().equals(productInfoDTO.getFrameStruct())) {/*구조*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getFrameMaterial() != null && filterVO.getText().equals(productInfoDTO.getFrameMaterial())) {/*소재*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getFrameMainColor() != null && filterVO.getText().equals(productInfoDTO.getFrameMainColor())) {/*컬러*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (po.getBrandNm() != null && filterVO.getText().equals(po.getBrandNm())) {/*브렌드*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    }
                                                }
                                            }

                                            for(CtgVO ctgVO : ctgVOList) {
                                                if("M".equals(ctgVO.getCtgRequire())) { // 필수 카체고리만 처리
                                                    if (productInfoDTO.getFrameShape() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameShape())) {/*모양*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getFrameSize() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameSize())) {/*사이즈*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getFrameStruct() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameStruct())) {/*구조*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getFrameMaterial() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameMaterial())) {/*소재*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getFrameMainColor() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameMainColor())) {/*컬러*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (po.getBrandNm() != null && ctgVO.getCtgNm().equals(po.getBrandNm())) {/*브렌드*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    }
                                                }
                                            }
                                        } else if (goodsTypeCd.equals("02")) { // 선글라스 : 안경태와 동일
                                            for(FilterVO filterVO : filterVOList) {
                                                if("M".equals(filterVO.getFilterRequire())) { // 필수 필터만 처리
                                                    if (productInfoDTO.getFrameShape() != null && filterVO.getText().equals(productInfoDTO.getFrameShape())) {/*모양*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getFrameSize() != null && filterVO.getText().equals(productInfoDTO.getFrameSize())) {/*사이즈*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getFrameStruct() != null && filterVO.getText().equals(productInfoDTO.getFrameStruct())) {/*구조*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getFrameMaterial() != null && filterVO.getText().equals(productInfoDTO.getFrameMaterial())) {/*소재*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getFrameMainColor() != null && filterVO.getText().equals(productInfoDTO.getFrameMainColor())) {/*컬러*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (po.getBrandNm() != null && filterVO.getText().equals(po.getBrandNm())) {/*브렌드*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    }
                                                }
                                            }

                                            for(CtgVO ctgVO : ctgVOList) {
                                                if("M".equals(ctgVO.getCtgRequire())) { // 필수 카체고리만 처리
                                                    if (productInfoDTO.getFrameShape() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameShape())) {/*모양*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getFrameSize() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameSize())) {/*사이즈*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getFrameStruct() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameStruct())) {/*구조*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getFrameMaterial() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameMaterial())) {/*소재*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getFrameMainColor() != null && ctgVO.getCtgNm().equals(productInfoDTO.getFrameMainColor())) {/*컬러*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (po.getBrandNm() != null && ctgVO.getCtgNm().equals(po.getBrandNm())) {/*브렌드*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    }
                                                }
                                            }
                                        } else if (goodsTypeCd.equals("03")) {
                                            for(FilterVO filterVO : filterVOList) {
                                                if("M".equals(filterVO.getFilterRequire())) { // 필수 필터만 처리
                                                    if (productInfoDTO.getLensKinds() != null && filterVO.getText().equals(productInfoDTO.getLensKinds())) {/*종류*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getLensCorrection() != null && filterVO.getText().equals(productInfoDTO.getLensCorrection())) {/*시력교정*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getLensProtection() != null && filterVO.getText().equals(productInfoDTO.getLensProtection())) {/*시력보호*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getLensAge() != null && filterVO.getText().equals(productInfoDTO.getLensAge())) {/*연령대*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getLensManufacturer() != null && filterVO.getText().equals(productInfoDTO.getLensManufacturer())) {/*제조사*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    } else if (productInfoDTO.getBrand() != null && filterVO.getText().equals(productInfoDTO.getBrand())) {/*브랜드*/
                                                        GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                        goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                        goodsFilterPO.setFilterNo(filterVO.getId());
                                                        goodsFilterPO.setDelYn("N");
                                                        goodsFilterList.add(goodsFilterPO);
                                                    }
                                                }
                                            }

                                            for(CtgVO ctgVO : ctgVOList) {
                                                if("M".equals(ctgVO.getCtgRequire())) { // 필수 카체고리만 처리
                                                    if (productInfoDTO.getLensKinds() != null && ctgVO.getCtgNm().equals(productInfoDTO.getLensKinds())) {/*종류*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getLensCorrection() != null && ctgVO.getCtgNm().equals(productInfoDTO.getLensCorrection())) {/*시력교정*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getLensProtection() != null && ctgVO.getCtgNm().equals(productInfoDTO.getLensProtection())) {/*시력보호*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getLensAge() != null && ctgVO.getCtgNm().equals(productInfoDTO.getLensAge())) {/*연령대*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getLensManufacturer() != null && ctgVO.getCtgNm().equals(productInfoDTO.getLensManufacturer())) {/*제조사*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    } else if (productInfoDTO.getBrand() != null && ctgVO.getCtgNm().equals(productInfoDTO.getBrand())) {/*브랜드*/
                                                        GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                        goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                        goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                        goodsCtgPO.setDelYn("N");
                                                        goodsCtgList.add(goodsCtgPO);
                                                    }
                                                }
                                            }
                                        } else if (goodsTypeCd.equals("04")) { // 콘택트렌즈
                                            String contOptFilterNo = "";
                                            String cont3lvlMenuFilterNos = "";

                                            String contOptCtgNo = "";
                                            String cont3lvlMenuCtgNos = "";
                                            // 투명 / 컬러 필터 값을 먼저 찾음 2lvl
                                            for(FilterVO filterVO : filterVOList) {
                                                if ("M".equals(filterVO.getFilterRequire())) { // 필수 필터만 처리
                                                    if(StringUtil.isNotEmpty(productInfoDTO.getContOpt()) && productInfoDTO.getContOpt().equals("칼라")) {
                                                        productInfoDTO.setContOpt("컬러");
                                                    }
                                                    if (productInfoDTO.getContOpt() != null && "2".equals(filterVO.getFilterLvl()) && filterVO.getText().contains(productInfoDTO.getContOpt())) {/*투명/컬러*/
                                                        contOptFilterNo = filterVO.getId();
                                                        break;
                                                    }
                                                }
                                            }
                                            // 3lvl 필터 값을 찾음
                                            for(FilterVO filterVO : filterVOList) {
                                                if ("M".equals(filterVO.getFilterRequire())) { // 필수 필터만 처리
                                                    if (!Objects.equals(contOptFilterNo, "") && "3".equals(filterVO.getFilterLvl()) && filterVO.getParent().equals(contOptFilterNo) ) {/*투명/컬러*/
                                                        cont3lvlMenuFilterNos  += filterVO.getId()+",";
                                                    }
                                                }
                                            }

                                            // 투명 / 컬러 카테고리 값을 먼저 찾음 2lvl
                                            for(CtgVO ctgVO : ctgVOList) {
                                                if ("M".equals(ctgVO.getCtgRequire())) { // 필수 카테고리만 처리
                                                    if(StringUtil.isNotEmpty(productInfoDTO.getContOpt()) && productInfoDTO.getContOpt().equals("칼라")) {
                                                        productInfoDTO.setContOpt("컬러");
                                                    }
                                                    if (productInfoDTO.getContOpt() != null && "2".equals(ctgVO.getCtgLvl()) && ctgVO.getCtgNm().contains(productInfoDTO.getContOpt())) {/*투명/컬러*/
                                                        contOptCtgNo = ctgVO.getCtgNo();
                                                        break;
                                                    }
                                                }
                                            }
                                            // 3lvl 카테고리 값을 찾음
                                            for(CtgVO ctgVO : ctgVOList) {
                                                if ("M".equals(ctgVO.getCtgRequire())) { // 필수 카테고리만 처리
                                                    if (!Objects.equals(contOptCtgNo, "") && "3".equals(ctgVO.getCtgLvl()) && ctgVO.getUpCtgNo().equals(contOptCtgNo) ) {/*투명/컬러*/
                                                        cont3lvlMenuCtgNos  += ctgVO.getCtgNo()+",";
                                                    }
                                                }
                                            }

                                            log.info("3lvl filterNos ::::::::: "+cont3lvlMenuFilterNos+" ::::::::::: "+contOptFilterNo);
                                            log.info("3lvl ctgNos ::::::::: "+cont3lvlMenuCtgNos+" ::::::::::: "+contOptCtgNo);
                                            for(FilterVO filterVO : filterVOList) {
                                                if("M".equals(filterVO.getFilterRequire())) { // 필수 필터만 처리
                                                    // 3lvl 필터들의 하위 메뉴 필터 셋팅
                                                    if(StringUtil.isNotEmpty(cont3lvlMenuFilterNos) && "4".equals(filterVO.getFilterLvl()) && cont3lvlMenuFilterNos.contains(filterVO.getParent())) {
                                                        if (productInfoDTO.getContKinds() != null && filterVO.getText().equals(productInfoDTO.getContKinds())) {/*시력구분*/
                                                            GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                            goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                            goodsFilterPO.setFilterNo(filterVO.getId());
                                                            goodsFilterPO.setDelYn("N");
                                                            goodsFilterList.add(goodsFilterPO);
                                                        } else if (productInfoDTO.getContWear() != null && filterVO.getText().equals(productInfoDTO.getContWear())) {/*착용주기*/
                                                            GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                            goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                            goodsFilterPO.setFilterNo(filterVO.getId());
                                                            goodsFilterPO.setDelYn("N");
                                                            goodsFilterList.add(goodsFilterPO);
                                                        } else if (productInfoDTO.getContColor() != null && filterVO.getText().equals(productInfoDTO.getContColor())) {/*컬러*/
                                                            GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                            goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                            goodsFilterPO.setFilterNo(filterVO.getId());
                                                            goodsFilterPO.setDelYn("N");
                                                            goodsFilterList.add(goodsFilterPO);
                                                        } else if (productInfoDTO.getContDiameter() != null && filterVO.getText().equals(productInfoDTO.getContDiameter())) {/*그래픽 직경*/
                                                            GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                            goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                            goodsFilterPO.setFilterNo(filterVO.getId());
                                                            goodsFilterPO.setDelYn("N");
                                                            goodsFilterList.add(goodsFilterPO);
                                                        } else if (po.getBrandNm() != null && filterVO.getText().equals(po.getBrandNm())) {/*브랜드*/
                                                            GoodsFilterPO goodsFilterPO = new GoodsFilterPO();
                                                            goodsFilterPO.setGoodsNo(po.getGoodsNo());
                                                            goodsFilterPO.setFilterNo(filterVO.getId());
                                                            goodsFilterPO.setDelYn("N");
                                                            goodsFilterList.add(goodsFilterPO);
                                                        }
                                                    }
                                                }
                                            }

                                            for(CtgVO ctgVO : ctgVOList) {
                                                if("M".equals(ctgVO.getCtgRequire())) { // 필수 카체고리만 처리
                                                    // 3lvl 필터들의 하위 메뉴 필터 셋팅
                                                    if(StringUtil.isNotEmpty(cont3lvlMenuCtgNos) && "4".equals(ctgVO.getCtgLvl()) && cont3lvlMenuCtgNos.contains(ctgVO.getUpCtgNo())) {
                                                        if (productInfoDTO.getContKinds() != null && ctgVO.getCtgNm().equals(productInfoDTO.getContKinds())) {/*시력구분*/
                                                            GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                            goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                            goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                            goodsCtgPO.setDelYn("N");
                                                            goodsCtgList.add(goodsCtgPO);
                                                        } else if (productInfoDTO.getContWear() != null && ctgVO.getCtgNm().equals(productInfoDTO.getContWear())) {/*착용주기*/
                                                            GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                            goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                            goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                            goodsCtgPO.setDelYn("N");
                                                            goodsCtgList.add(goodsCtgPO);
                                                        } else if (productInfoDTO.getContColor() != null && ctgVO.getCtgNm().equals(productInfoDTO.getContColor())) {/*컬러*/
                                                            GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                            goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                            goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                            goodsCtgPO.setDelYn("N");
                                                            goodsCtgList.add(goodsCtgPO);
                                                        } else if (productInfoDTO.getContDiameter() != null && ctgVO.getCtgNm().equals(productInfoDTO.getContDiameter())) {/*그래픽 직경*/
                                                            GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                            goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                            goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                            goodsCtgPO.setDelYn("N");
                                                            goodsCtgList.add(goodsCtgPO);
                                                        } else if (po.getBrandNm() != null && ctgVO.getCtgNm().equals(po.getBrandNm())) {/*브랜드*/
                                                            GoodsCtgPO goodsCtgPO = new GoodsCtgPO();
                                                            goodsCtgPO.setGoodsNo(po.getGoodsNo());
                                                            goodsCtgPO.setCtgNo(ctgVO.getCtgNo());
                                                            goodsCtgPO.setDelYn("N");
                                                            goodsCtgList.add(goodsCtgPO);
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            log.info("소모품은 없겠지??? ::::::::: "+po.getGoodsNo());
                                        }

                                        // 선택된 카테고리 정보 등록
                                        if(goodsCtgList.size() > 0) {
                                            log.info("상품 category list ::::::::: "+goodsCtgList);
                                            // 기존 카테고리 삭제
                                            GoodsCtgPO goodsCtgDelPo = new GoodsCtgPO();
                                            goodsCtgDelPo.setSiteNo(po.getSiteNo());
                                            goodsCtgDelPo.setGoodsNo(po.getGoodsNo());
                                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsCtg", goodsCtgDelPo);
                                            // 다비전 카테고리 등록
                                            for (int i = 0; goodsCtgList.size() > i; i++) {
                                                goodsCtgList.get(i).setSiteNo(po.getSiteNo());
                                                if (i == 0) {
                                                    goodsCtgList.get(i).setDlgtCtgYn("Y");// 리스트에 담겨 있는 첫번째 카테고리가 대표 카테고리임
                                                } else {
                                                    goodsCtgList.get(i).setDlgtCtgYn("N");
                                                }
                                                goodsCtgList.get(i).setExpsPriorRank(String.valueOf(i));
                                                goodsCtgList.get(i).setExpsYn("Y");
                                                goodsCtgList.get(i).setRegrNo(po.getRegrNo());
                                                goodsCtgList.get(i).setUpdrNo(po.getUpdrNo());
                                                goodsCtgList.get(i).setDelYn("N");
                                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsCtg", goodsCtgList.get(i));
                                            }
                                        } else {
                                            String result = "상품 category list 못만듬 ::::::::: "+po.getGoodsNo();
                                            itemVO.setGoodsDesc(result);
                                            log.info(result);
                                        }


                                        // 선택된 필터 정보 등록
                                        if(goodsFilterList.size() > 0) {
                                            log.info("상품 filter list ::::::::: "+goodsFilterList);
                                            //po.setGoodsFilterList(goodsFilterList);
                                            proxyDao.delete(MapperConstants.GOODS_MANAGE + "deleteGoodsFilter", po);
                                            for (GoodsFilterPO filterPO : goodsFilterList) {
                                                filterPO.setSiteNo(po.getSiteNo());

                                                filterPO.setRegrNo(po.getRegrNo());
                                                filterPO.setUpdrNo(po.getUpdrNo());
                                                proxyDao.insert(MapperConstants.GOODS_MANAGE + "insertGoodsFilter", filterPO);
                                            }
                                        } else {
                                            String result = "상품 filter list 못만듬 ::::::::: "+po.getGoodsNo();
                                            itemVO.setGoodsDesc(result);
                                            log.info(result);
                                        }
                                        // ::::::::::::::::: 필터 및 카테고리 정보 셋팅 end
                                    }
                                    String result = "다비젼 상품 정보 업데이트 완료 ::::::::: "+po.getGoodsNo();
                                    itemVO.setGoodsDesc(result);
                                    log.info(result);
                                } else {
                                    String result = "다비젼 상품 정보가 없는 상품 ::::::::: "+po.getGoodsNo();
                                    log.info(result);
                                    //throw new Exception("다비젼 상품 정보가 없는 상품");
                                    itemVO.setGoodsDesc(result);
                                }

                            } else {
                                String result = "대표 아이템이 없는 상품 ::::::::: "+po.getGoodsNo();
                                log.info("대표 아이템이 없는 상품 ::::::::: "+po.getGoodsNo());
                                itemVO.setGoodsDesc(result);
                            }
                            list.add(itemVO);
                        }
                    }
                }
            }
        }

        return list;
    }
}
