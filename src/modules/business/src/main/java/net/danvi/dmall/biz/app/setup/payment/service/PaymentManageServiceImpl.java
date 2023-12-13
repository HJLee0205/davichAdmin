package net.danvi.dmall.biz.app.setup.payment.service;

import com.ckd.common.reqInterface.PGActiveResult;
import com.ckd.common.reqInterface.PayActiveInfo;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basicinfo.model.BasicInfoVO;
import net.danvi.dmall.biz.app.basicinfo.service.BasicInfoService;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.setup.payment.model.*;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.remote.homepage.service.HomepageRemoteDelegateService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.*;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("paymentManageService")
@Transactional(rollbackFor = Exception.class)
public class PaymentManageServiceImpl extends BaseService implements PaymentManageService {
    @Value("#{system['system.solution.conf.rootpath']}")
    private String confFilePath;

    @Value("#{system['system.solution.log.rootpath']}")
    private String logFilePath;

    @Resource(name = "homepageRemoteDelegateService")
    private HomepageRemoteDelegateService homepageRemoteService;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Value(value = "#{system['system.server']}")
    private String server;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Resource(name = "basicInfoService")
    private BasicInfoService basicInfoService;

    /** 개발서버 도메인 */
    @Value(value = "#{business['system.domain.dev']}")
    private String devDomain;

    ArrayList<String> curFileNameList = new ArrayList<String>();

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<CommPaymentConfigVO> selectPaymentPaging(CommPaymentConfigSO so) {
        // 기본 정렬 처리 값 없을시
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }

        // 팝업 리스트 페이징 처리
        return proxyDao.selectListPage(MapperConstants.SETUP_PAYMENT_MANAGE + "selectPaymentPaging", so);
    }
    /** 무통장 계좌 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<NopbPaymentConfigVO> selectNopbPaymentConfig(Long siteNo) {
        NopbPaymentConfigVO resultVO = proxyDao
                .selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectNopbPaymentConfig", siteNo);

        ResultModel<NopbPaymentConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 무통장 은행계좌 리스트 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<NopbPaymentConfigVO> selectNopbPaymentList(Long siteNo) {
        List<NopbPaymentConfigVO> list = proxyDao
                .selectList(MapperConstants.SETUP_PAYMENT_MANAGE + "selectNopbPaymentList", siteNo);
        ResultListModel<NopbPaymentConfigVO> result = new ResultListModel<>();
        log.debug("=========== list : {}", list.toString());
        if (list == null || list.size() < 1) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodata"));
        } else {
            result.setResultList(list);
        }
        return result;
    }

    /** 무통장 은행계좌 리스트 정보 조회 서비스(set Cache Service) **/
    @Override
    @Transactional(readOnly = true)
    public List<NopbPaymentConfigVO> selectNopbInfo(Long siteNo) {
        return proxyDao.selectList(MapperConstants.SETUP_PAYMENT_MANAGE + "selectNopbPaymentList", siteNo);
    }

    /** 통합전자결제 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<CommPaymentConfigVO> selectCommPaymentConfig(CommPaymentConfigSO so) {
        CommPaymentConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectCommPaymentConfig", so);

        // 사이트 번호, 사이트 키 Test 설정
        /*if ("local".equals(server)) {
            resultVO.setPgId("T0000");
            resultVO.setPgKey("3grptw1.zW0GSo4PQdaGvsF__");
        }*/

        ResultModel<CommPaymentConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 간편결제 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<SimplePaymentConfigVO> selectSimplePaymentConfig(SimplePaymentConfigSO so) {
        SimplePaymentConfigVO resultVO = proxyDao
                .selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectSimplePaymentConfig", so);

        ResultModel<SimplePaymentConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** NPAY 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<NPayConfigVO> selectNPayConfig(Long siteNo) {
        NPayConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectNPayConfig", siteNo);

        ResultModel<NPayConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** NPAY 상품정보요청 **/
    @Override
    public void _writeItemInfo(String itemId, Writer writer,HttpServletRequest request) throws Exception{
        //itemId로 DB에서 정보 조회
        String protocol = request.getScheme();
        String domain =devDomain;

        String url = protocol+"://"+domain+"/front/goods/goods-detail?goodsNo=" + itemId;
        /** 상품기본정보 조회 */
        GoodsDetailSO so = new GoodsDetailSO();
        so.setSaleYn("Y");
        so.setDelYn("N");
        String[] goodsStatus = { "1", "2" };
        so.setGoodsStatus(goodsStatus);
        so.setGoodsNo(itemId);
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(so);


        String itemName = goodsInfo.getData().getGoodsNm();
        String itemImage = protocol+"://"+domain+"/image/image-view?type=GOODSDTL&id1=";
        String thumbImage = protocol+"://"+domain+"/image/image-view?type=GOODSDTL&id1=";

        for (int i=0;i<goodsInfo.getData().getGoodsImageSetList().size();i++){
            Map<String, Object> imgList = goodsInfo.getData().getGoodsImageSetList().get(i);
            List<Map<String, Object>> imgDtlList = (List<Map<String, Object>>) imgList.get("goodsImageDtlList");
            for (int j=0;j<imgDtlList.size();j++){
                if(imgDtlList.get(j).get("goodsImgType").equals("02")){
                    itemImage += imgDtlList.get(j).get("imgPath")+"_"+imgDtlList.get(j).get("imgNm");
                }
                if(imgDtlList.get(j).get("goodsImgType").equals("03")){
                    thumbImage += imgDtlList.get(j).get("imgPath")+"_"+imgDtlList.get(j).get("imgNm");
                }
            }
        }

        /**  옵션정보 */
        String[] options =null;
        String[][] optionList = null;
        int optionCnt =0;
        if (goodsInfo.getData().getGoodsOptionList() != null) {
            List<Map<String, Object>> option = goodsInfo.getData().getGoodsOptionList();
            optionCnt = option.size();
            options = new String[optionCnt];
            for (int i=0;i<options.length;i++){
                options[i] = (String) option.get(i).get("optNm");
            }
        }

        /** 단품정보 */
        int itemCnt = 0;
        if (goodsInfo.getData().getGoodsItemList() != null) {
            List<GoodsItemVO> itemList = goodsInfo.getData().getGoodsItemList();
            itemCnt = itemList.size();
            optionList = new String[optionCnt][];
            for (int i=1;i<=optionList.length;i++){
                optionList[i-1] = new String[itemCnt];
                for (int j=1;j<=itemCnt;j++){
                    if(i==1)
                        optionList[i-1][j-1] = itemList.get(j-1).getAttrValue1();
                    if(i==2)
                        optionList[i-1][j-1] = itemList.get(j-1).getAttrValue2();
                    if(i==3)
                        optionList[i-1][j-1] = itemList.get(j-1).getAttrValue3();
                    if(i==4)
                        optionList[i-1][j-1] = itemList.get(j-1).getAttrValue4();
                }

            }
        }

        /** 기본 판매가격 **/
        int price = (int) goodsInfo.getData().getSalePrice();

        /** 재고수량 **/
        int quantity = (int) goodsInfo.getData().getStockQtt();

        /** 카테고리 **/
        List<CategoryVO> list = new ArrayList<>();
        String couponCtgNoArr = "";
        CategorySO categorySO = new CategorySO();
        categorySO.setSiteNo(goodsInfo.getData().getSiteNo());

        String majorCategoryId = "";
        String majorCategoryName = "";
        String middleCategoryId = "";
        String middleCategoryName = "";
        String minorCategoryId = "";
        String minorCategoryName = "";

        for (int i = 0; i < goodsInfo.getData().getGoodsCtgList().size(); i++) {
            GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(i);
            categorySO.setCtgNo(gcvs.getCtgNo());
            list = categoryManageService.selectUpNavagation(categorySO);
            for (int k = 0; k < list.size(); k++) {
                CategoryVO vo = list.get(k);
                if (!"".equals(couponCtgNoArr)) {
                    couponCtgNoArr += ",";
                }
                if(vo.getCtgLvl().equals("1")){
                    majorCategoryId = vo.getCtgNo();
                    majorCategoryName = vo.getCtgNm();
                }

                if(vo.getCtgLvl().equals("2")){
                    middleCategoryId = vo.getCtgNo();
                    middleCategoryName = vo.getCtgNm();
                }

                if(vo.getCtgLvl().equals("3")){
                    minorCategoryId = vo.getCtgNo();
                    minorCategoryName = vo.getCtgNm();
                }
            }
        }




        /** 상품별 반품주소 (기본정책: 단비스토리반품주소로 설정)**/
        long siteNo = SessionDetailHelper.getSession().getSiteNo();
        ResultListModel<BasicInfoVO> result = basicInfoService.selectBasicInfo(siteNo);
        SiteVO svo = (SiteVO) result.get("site_info");

        String zipCode =svo.getRetadrssPost();
        String address1 =svo.getRetadrssAddrNum();
        String address2 =svo.getRetadrssAddrDtl();
        String sellername =svo.getCompanyNm();
        String contact1 =svo.getTelNo();
        String contact2 = svo.getTelNo();

        // 상품or판매자별 반품주소 사용 할 경우 판매자가 등록한 반품지 주소사용...
       /*String zipCode =goodsInfo.getData().getRetadrssPostNo();
       String address1 =goodsInfo.getData().getRetadrssAddr();
       String address2 =goodsInfo.getData().getRetadrssDtlAddr();
       String sellername =goodsInfo.getData().getSellerNm();
       String contact1 =goodsInfo.getData().getManagerMobileNo();
       String contact2 = goodsInfo.getData().getManagerTelno();*/


        /** 상품별 상세설명 **/
        GoodsContentsVO goodsContentVO = new GoodsContentsVO();
        goodsContentVO.setGoodsNo(goodsInfo.getData().getGoodsNo());
        ResultModel<GoodsContentsVO> content = goodsManageService.selectGoodsContents(goodsContentVO);
        String description = content.getData().getContent();

        // 여기까지 DB에서 조회한 정보.
        // !  각 String에 xml의 attribute나 body 혹은 CDATA block안에 들어갈 수 없는 문자가 있다면 적절하게 escaping 해야 한다.
        // Write구조 대신 javax.xml.transform.TransformerFactory 과 org.w3c.dom.Document 를 이용해 DOM구조를 XML로 출력하는 방법을 사용할 수도 있다.

        writer.write(String.format("<item id=\"%s\">\r\n", itemId));
        writer.write(String.format("<name><![CDATA[%s]]></name>\r\n", itemName));
        writer.write(String.format("<url><![CDATA[%s]]></url>\r\n", url));
        writer.write(String.format("<description><![CDATA[%s]]></description>\r\n", description));
        writer.write(String.format("<image><![CDATA[%s]]></image>\r\n", itemImage));
        writer.write(String.format("<thumb><![CDATA[%s]]></thumb>\r\n", thumbImage));
        if (options != null) {
            writer.write("<options>\r\n");
            for (int i = 0; i < options.length; ++i) {
                writer.write(String.format("<option name=\"%s\">\r\n", options[i]));
                for (int j = 0; j < optionList[i].length; ++j) {
                    writer.write(String.format("<select><![CDATA[%s]]></select>\r\n", optionList[i][j]));
                }
                writer.write("</option>\r\n");
            }
            writer.write("</options>\r\n");
        }
        writer.write(String.format("<price>%d</price>\r\n", price));
        writer.write(String.format("<quantity>%d</quantity>\r\n", quantity));

        writer.write("<category>\r\n");
        writer.write(String.format("<first id=\"%s\"><![CDATA[%s]]></first>\r\n", majorCategoryId, majorCategoryName));
        writer.write(String.format("<second id=\"%s\"><![CDATA[%s]]></second>\r\n", middleCategoryId, middleCategoryName));
        writer.write(String.format("<third id=\"%s\"><![CDATA[%s]]></third>\r\n", minorCategoryId, minorCategoryName));
        writer.write("</category>\r\n");

        writer.write("<returnInfo>\r\n");
        writer.write(String.format("<zipcode><![CDATA[%s]]></zipcode>\r\n",zipCode));
        writer.write(String.format("<address1><![CDATA[%s]]></address1>\r\n",address1));
        writer.write(String.format("<address2><![CDATA[%s]]></address2>\r\n",address2));
        writer.write(String.format("<sellername><![CDATA[%s]]></sellername>\r\n",sellername));
        writer.write(String.format("<contact1><![CDATA[%s]]></contact1>\r\n",contact1));
        writer.write(String.format("<contact2><![CDATA[%s]]></contact2>\r\n",contact2));
        writer.write("</returnInfo>\r\n");

        writer.write("</item>\r\n");

    }

    /** 해외결제 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<CommPaymentConfigVO> selectForeignPaymentConfig(Long siteNo) {
        CommPaymentConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectForeignPaymentConfig", siteNo);
        ResultModel<CommPaymentConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

     /** 알리페이 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<CommPaymentConfigVO> selectAlipayPaymentConfig(Long siteNo) {
        CommPaymentConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectAlipayPaymentConfig", siteNo);
        ResultModel<CommPaymentConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

     /** 텐페이 정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<CommPaymentConfigVO> selectTenpayPaymentConfig(Long siteNo) {
        CommPaymentConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectTenpayPaymentConfig", siteNo);
        ResultModel<CommPaymentConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

     /** 위챗페이 정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<CommPaymentConfigVO> selectWechpayPaymentConfig(Long siteNo) {
        CommPaymentConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectWechpayPaymentConfig", siteNo);
        ResultModel<CommPaymentConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 무통장 계좌 설정 정보 수정 서비스 **/
    @Override
    public ResultModel<NopbPaymentConfigPO> updateNopbPaymentConfig(NopbPaymentConfigPO po) throws Exception {
        ResultModel<NopbPaymentConfigPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateNopbPaymentConfig", po);

        // 대표계좌 수정
        // 1. Checked된 라디오버튼을 대표계좌로 설정한다.
        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateNopbPaymentDlgtActConfig", po);

        // 2. 대표계좌는 무조건 하나만 존재해야 하기때문에 기존 대표계좌로 설정되어 있던것을 해제한다.
        po.setNopbPaymentSeq(po.getInitNopbDlgtSeq());
        po.setDlgtActYn("N");
        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateNopbPaymentDlgtActConfig", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** 무통장 은행계좌 등록 */
    @Override
    public ResultModel<NopbPaymentConfigPO> insertNopbAccount(NopbPaymentConfigPO po) throws Exception {
        ResultModel<NopbPaymentConfigPO> resultModel = new ResultModel<>();

        // 무통장 등록 여부 체크 true면 등록
        if (siteQuotaService.isAccountAddible(SessionDetailHelper.getDetails().getSiteNo())) {
            String bankNm = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectBankNm", po.getBankCd());
            po.setBankNm(bankNm);
            // 최초 등록시에는 대표계좌 설정여부를 N으로 등록한다.
            po.setDlgtActYn("N");
            proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "insertNopbAccount", po);

            // 프론트 사이트 정보 갱신
            HttpServletRequest request = HttpUtil.getHttpServletRequest();
            adminRemotingService.refreshNopbInfo(po.getSiteNo(), request.getServerName());

            resultModel.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } else {
            resultModel.setMessage("계좌를 추가로 등록하시려면 계좌등록 상품을 구매하여 주세요.");
        }

        return resultModel;
    }

    /** 무통장 은행계좌 수정 */
    @Override
    public ResultModel<NopbPaymentConfigPO> updateNopbAccount(NopbPaymentConfigPO po) throws Exception {
        ResultModel<NopbPaymentConfigPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        String bankNm = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectBankNm", po.getBankCd());
        po.setBankNm(bankNm);
        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateNopbAccount", po);

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));

        // 프론트 사이트 정보 갱신
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshNopbInfo(po.getSiteNo(), request.getServerName());
        return resultModel;
    }

    /** 무통장 대표계좌 수정 */
    @Override
    public ResultModel<NopbPaymentConfigPO> updateNopbPaymentDlgtActConfig(NopbPaymentConfigPO po) throws Exception {
        ResultModel<NopbPaymentConfigPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateNopbPaymentDlgtActConfig", po);

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    @Override
    public ResultModel<NopbPaymentConfigPO> deleteNopbAccount(NopbPaymentConfigPO po) throws Exception {
        ResultModel<NopbPaymentConfigPO> result = new ResultModel<>();
        proxyDao.delete(MapperConstants.SETUP_PAYMENT_MANAGE + "deleteNopbAccount", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        // 프론트 사이트 정보 갱신
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshNopbInfo(po.getSiteNo(), request.getServerName());
        return result;
    }

    /** 통합전자결제 등록 */
    @Override
    public ResultModel<CommPaymentConfigPO> insertCommPaymentConfig(CommPaymentConfigPO po, HttpServletRequest request) throws Exception {
        ResultModel<CommPaymentConfigPO> resultModel = new ResultModel<>();

        try {
            if ("02".equals(po.getPgCd())) { // 이니시스, 이니시스 일경우에는 파일업로드가 존재하기 때문에 이니시스일경우 파일업로드를 진행한다.
                CommPaymentConfigSO so = new CommPaymentConfigSO();
                so.setSiteNo(po.getSiteNo());
                so.setPgCd(po.getPgCd());
                log.info("po ============= "+po);
//                uploadInicisConfigFile(so, po, request);
            } else if ("03".equals(po.getPgCd())) { // Lgu+, LG U+는 PG 설정파일인 mall.conf파일을 0번쨰 폴더에 있는 원본 설정파일을 복사하여 현재 수정하는
                // 가맹점의 정보로 설정 정보들을
                // 갱신한다.
                lguPlusConfFileCopy(po);
            }
            // 무통장 등록 여부 체크 true면 등록
            if (siteQuotaService.isAccountAddible(SessionDetailHelper.getDetails().getSiteNo())) {
                log.info("po 11111111============= "+po);
                proxyDao.insert(MapperConstants.SETUP_PAYMENT_MANAGE + "insertCommPaymentConfig", po);
    
                // 프론트 사이트 정보 갱신
                //HttpServletRequest request = HttpUtil.getHttpServletRequest();
                //adminRemotingService.refreshNopbInfo(po.getSiteNo(), request.getServerName());
    
                resultModel.setMessage(MessageUtil.getMessage("biz.common.insert"));
            } else {
                resultModel.setMessage("계좌를 추가로 등록하시려면 계좌등록 상품을 구매하여 주세요.");
            }
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "통합전자결제 관리" }, e);
        }
        return resultModel;
    }

    /** 통합전자결제 설정정보 등록/수정 */
    public ResultModel<CommPaymentConfigPO> updateCommPaymentConfig(CommPaymentConfigPO po, HttpServletRequest request)
            throws Exception {
        ResultModel<CommPaymentConfigPO> resultModel = new ResultModel<>();

        if ("02".equals(po.getPgCd())) { // 이니시스, 이니시스 일경우에는 파일업로드가 존재하기 때문에 이니시스일경우 파일업로드를 진행한다.
            CommPaymentConfigSO so = new CommPaymentConfigSO();
            so.setSiteNo(po.getSiteNo());
            so.setPgCd(po.getPgCd());
            so.setShopCd(po.getShopCd());
            so.setShopNm(po.getShopNm());
//            uploadInicisConfigFile(so, po, request);
        } else if ("03".equals(po.getPgCd())) { // Lgu+, LG U+는 PG 설정파일인 mall.conf파일을 0번쨰 폴더에 있는 원본 설정파일을 복사하여 현재 수정하는
            // 가맹점의 정보로 설정 정보들을
            // 갱신한다.
            lguPlusConfFileCopy(po);
        }

        // 2. 업데이트 하기전 USE_YN 여부를 모두 N으로 설정한다.
        //proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateCommPaymentUseYn", po.getSiteNo());
        try {
            // 3. 업데이트
//            po.setUseYn("Y");
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateCommPaymentConfig", po);
            resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));

            // 3. 홈페이지 측으로 계약된 PG정보 전송
            // PG CD를 보내지 않지만 홈페이지와의 협의후에 추가될수도있다.
            // payActiveSts는 pgCd가 없다면 사실상 Y만 보내지게된다.
            PGActiveResult ifVo = new PGActiveResult();
            ifVo.setSiteId(SiteUtil.getSiteId());
            ifVo.setSiteNo(po.getSiteNo());
            ifVo.setPayActiveCd("21");
            // homepageRemoteService.reqPGActiveInfo(ifVo); // 현재 구현이되어있지 않아 오류가 발생해서 임시 주석처리

            CommPaymentConfigPO paramPo = new CommPaymentConfigPO();
            paramPo.setPgCd(po.getPgCd());
            resultModel.setData(paramPo);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "통합전자결제 관리" }, e);
        }
        return resultModel;
    }

    @Override
    public ResultModel<CommPaymentConfigPO> deleteCommPaymentConfig(CommPaymentConfigPO po) throws Exception {
        ResultModel<CommPaymentConfigPO> result = new ResultModel<>();
        proxyDao.delete(MapperConstants.SETUP_PAYMENT_MANAGE + "deleteCommPaymentConfig", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        CommPaymentConfigVO vo = null;
        List<String> getBeforePathList = new ArrayList<>();
        CommPaymentConfigSO so = new CommPaymentConfigSO();
        so.setSiteNo(po.getSiteNo());
        so.setPgCd(po.getPgCd());
        so.setShopCd(po.getShopCd());
        vo = selectCommPaymentConfig(so).getData();

        // 등록되어있는 파일 정보 리스트
        getBeforePathList = getBeforePathList(vo);
        for (int i = 0; i < getBeforePathList.size(); i++) {
            deleteFile(po.getSiteNo(), getBeforePathList.get(i), po.getShopCd());
        }
        // 프론트 사이트 정보 갱신
        //HttpServletRequest request = HttpUtil.getHttpServletRequest();
        //adminRemotingService.refreshNopbInfo(po.getSiteNo(), request.getServerName());
        return result;
    }

    /** 간편결제 사용설정정보 수정 */
    public ResultModel<SimplePaymentConfigPO> updateSimplePaymentUseYnConfig(SimplePaymentConfigPO po)
            throws Exception {
        ResultModel<SimplePaymentConfigPO> resultModel = new ResultModel<>();

        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateSimplePaymentUseYnConfig", po);
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** 간편결제 설정정보 등록/수정 */
    public ResultModel<SimplePaymentConfigPO> updateSimplePaymentConfig(SimplePaymentConfigPO po) throws Exception {
        ResultModel<SimplePaymentConfigPO> resultModel = new ResultModel<>();

        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 1. TS_SITE 테이블에 간편결제 서비스 사용여부 업데이트
        updateSimplePaymentUseYnConfig(po);

        // 2. TS_SIMP_PG_SET 테이블에 그외 정보 업데이트
        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateSimplePaymentConfig", po);
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));

        // 홈페이지 측으로 계약된 PG정보 전송
        // PG CD를 보내지 않지만 홈페이지와의 협의후에 추가될수도있다.
        // payActiveSts는 pgCd가 없다면 사실상 Y만 보내지게된다.
        PayActiveInfo ifVo = new PayActiveInfo();
        ifVo.setSiteId(SiteUtil.getSiteId());
        ifVo.setSiteNo(po.getSiteNo());
        ifVo.setPayActiveCd("22");
        ifVo.setPayActiveSts("Y");
        // homepageRemoteService.setPayActiveInfo(ifVo); //현재 구현이되어있지 않아 오류가 발생해서 임시 주석처리
        return resultModel;
    }

    /** NPay 설정정보 등록/수정 */
    public ResultModel<NPayConfigPO> updateNPayConfig(NPayConfigPO po) throws Exception {
        ResultModel<NPayConfigPO> resultModel = new ResultModel<>();

        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateNPayConfig", po);
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** 해외결제 설정정보 등록/수정 */
    public ResultModel<CommPaymentConfigPO> updateForeignPaymentConfig(CommPaymentConfigPO po) throws Exception {
        ResultModel<CommPaymentConfigPO> resultModel = new ResultModel<>();

        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_PAYMENT_MANAGE + "updateForeignPaymentConfig", po);
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    private void uploadInicisConfigFile(CommPaymentConfigSO so, CommPaymentConfigPO po, HttpServletRequest request)
            throws Exception {
        CommPaymentConfigVO vo = null;
        List<String> getBeforePathList = new ArrayList<>();
        List<String> getAfterPathList = new ArrayList<>();
        if(Objects.equals(po.getEditYn(), "Y")) {
            vo = selectCommPaymentConfig(so).getData();

            // 등록되어있는 파일 정보 리스트
            getBeforePathList = getBeforePathList(vo);
            // 등록해야하는 파일 정보 리스트
            getAfterPathList = getAfterPathList(po);
        }
        // 파일 리스트
        List<MultipartFile> getUploadFileList = getUploadFileList(request);
        // 파일명 리스트
        List<String> fileNameList = getFileNameList(curFileNameList);

        // ShopCd변경시 디렉토리 이름 변경
        String beforeShopCd = "";
        if (vo != null) {
            beforeShopCd = vo.getShopCd();
        }

        modifyShopCdProcess(po, beforeShopCd);

        for (int i = 0; i < getUploadFileList.size(); i++) {
            if (getBeforePathList.size() > 0 && getAfterPathList.size() > 0) {
                if (!getBeforePathList.get(i).equals(getAfterPathList.get(i))) {
                    deleteFile(po.getSiteNo(), getBeforePathList.get(i), po.getShopCd());
                }
            }

            // 이미지 업로드, 현재 개발포멧에 맞게 getFileListFromRequest메서드를 커스터마이징하여 사용
            // String uploadPath = SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_CONFIG, "payment", "02", "INIpay50", "key", po.getPgId());
            // 이니시스 파일은 정해진 경로가 있어서 그쪽에 업로드 한다.
            String uploadPath = FileUtil.getCombinedPath(confFilePath, "payment", "02", String.valueOf(po.getSiteNo()), "INIpay50", "key", po.getShopCd());

            // key 파일 업로드 경로
            String uploadPathForPgcert = FileUtil.getCombinedPath(confFilePath, "payment", "02", String.valueOf(po.getSiteNo()), "INIpay50", "key", po.getShopCd());

            // key 파일 업로드
            List<FileVO> list = getFileListFromRequest(getUploadFileList.get(i), uploadPath, uploadPathForPgcert, fileNameList.get(i), po.getShopCd());

            if (list != null && list.size() == 1) {
                setUploadPath(po, fileNameList.get(i),list.get(0).getFilePath() + File.separator + list.get(0).getFileName());
            }

            curFileNameList.clear();
        }

        // log 파일 업로드 경로
        String uploadPathForLog = FileUtil.getCombinedPath(confFilePath, "payment", "02",String.valueOf(po.getSiteNo()), "INIpay50", "log", po.getShopCd());

        String mainPath = FileUtil.getCombinedPath(confFilePath, "payment", "02", String.valueOf(po.getSiteNo()),"INIpay50", po.getShopCd());
        // log 폴더 생성
        File mainPathFolder = new File(mainPath);
        if (mainPathFolder.exists()) {
            File logFolder = new File(uploadPathForLog);
            if (!logFolder.exists()) {
                logFolder.mkdirs();
            }

            // log 폴더 권한적용
//            ExecuteExtCmdUtil.executeExtCmd("chmod -R 777 " + uploadPathForLog);
        }
    }

    private List<String> getBeforePathList(CommPaymentConfigVO vo) {
        List<String> list = new ArrayList<String>();
        if (vo != null) {
            list.add(getPathValue(vo.getPgKey()));
            list.add(getPathValue(vo.getPgKey2()));
            list.add(getPathValue(vo.getPgKey3()));
            list.add(getPathValue(vo.getPgKey4()));
            list.add(getPathValue(vo.getEscrowId()));
            list.add(getPathValue(vo.getEscrowCertKeyFilePath1()));
            list.add(getPathValue(vo.getEscrowCertKeyFilePath2()));
            list.add(getPathValue(vo.getEscrowCertKeyFilePath3()));
        }

        return list;
    }

    private List<String> getAfterPathList(CommPaymentConfigPO po) {
        List<String> list = new ArrayList<String>();
        list.add(po.getPgKey());
        list.add(po.getPgKey2());
        list.add(po.getPgKey3());
        list.add(po.getPgKey4());
        list.add(po.getEscrowId());
        list.add(po.getEscrowCertKeyFilePath1());
        list.add(po.getEscrowCertKeyFilePath2());
        list.add(po.getEscrowCertKeyFilePath3());
        return list;
    }

    private List<MultipartFile> getUploadFileList(HttpServletRequest request) {
        List<MultipartFile> list = new ArrayList<MultipartFile>();
        MultipartHttpServletRequest mRequest;
        if (request instanceof MultipartHttpServletRequest) {
            mRequest = (MultipartHttpServletRequest) request;
        } else {
            return null;
        }

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        Iterator<String> fileIter = mRequest.getFileNames();
        List<MultipartFile> files;

        while (fileIter.hasNext()) {
            files = mRequest.getMultiFileMap().get(fileIter.next());
            for (MultipartFile mFile : files) {
                list.add(mFile);
                curFileNameList.add(mFile.getName());
            }
        }
        return list;
    }

    private List<String> getFileNameList(ArrayList<String> curFileNameList) {
        List<String> fileNameList = new ArrayList<String>();
        for (String str : curFileNameList) {
            if ("uploadPgKeyFile1".equals(str)) {
                fileNameList.add("keypass");
            } else if ("uploadPgKeyFile2".equals(str)) {
                fileNameList.add("mcert");
            } else if ("uploadPgKeyFile3".equals(str)) {
                fileNameList.add("mpriv");
            } else if ("uploadPgKeyFile4".equals(str)) {
                fileNameList.add("pgcert");
            } else if ("uploadEscrowIdFile".equals(str)) {
                fileNameList.add("escrowId");
            } else if ("uploadEscrowKeyFile1".equals(str)) {
                fileNameList.add("escrowKey1");
            } else if ("uploadEscrowKeyFile2".equals(str)) {
                fileNameList.add("escrowKey2");
            } else if ("uploadEscrowKeyFile3".equals(str)) {
                fileNameList.add("escrowKey3");
            }
        }
        return fileNameList;
    }

    private void setUploadPath(CommPaymentConfigPO po, String pathCode, String uploadPath) {
        if ("keypass".equals(pathCode)) {
            po.setPgKey(uploadPath);
        } else if ("mcert".equals(pathCode)) {
            po.setPgKey2(uploadPath);
        } else if ("mpriv".equals(pathCode)) {
            po.setPgKey3(uploadPath);
        } else if ("readme".equals(pathCode)) {
            po.setPgKey4(uploadPath);
        } else if ("escrowId".equals(pathCode)) {
            po.setEscrowId(uploadPath);
        } else if ("escrowKey1".equals(pathCode)) {
            po.setEscrowCertKeyFilePath1(uploadPath);
        } else if ("escrowKey2".equals(pathCode)) {
            po.setEscrowCertKeyFilePath2(uploadPath);
        } else if ("escrowKey3".equals(pathCode)) {
            po.setEscrowCertKeyFilePath3(uploadPath);
        }
    }

    private String getPathValue(String pathValue) {
        // 공백으로 초기화하지않으면 만약 데이터가 없어서 null일경우 밑의 if문 조건에서 에러를 뱉기때문에 무조건
        // 초기화해야한다.
        if (pathValue == null) {
            pathValue = "";
        }
        return pathValue;
    }

    private void deleteFile(Long siteNo, String pathValue, String shopCd) throws Exception {
        // 이미지 삭제
        String deletePath = FileUtil.getCombinedPath(confFilePath, "payment", "02", String.valueOf(siteNo), "INIpay50",
                "key", shopCd);
        // confFilePath + File.separator + "payment" + File.separator + "02" + File.separator + siteNo
        // + File.separator + "INIpay50" + File.separator + "key";
        File file = new File(deletePath + pathValue);
        if (file.exists()) { // 존재한다면 삭제
            FileUtil.delete(file);
        }
    }

    private List<FileVO> getFileListFromRequest(MultipartFile uploadFile, String targetPath, String targetForPgcert,
                                                String paramFileName, String shopCd) {
        List<FileVO> fileVOList = new ArrayList<>();
        String fileOrgName;
        String extension;
        String fileName;
        File file;
        String path = "";
        FileVO fileVO;
        String[] fileFilter = { "pem", "enc" };
        Boolean checkExe;

        try {
            fileOrgName = uploadFile.getOriginalFilename();
            extension = FilenameUtils.getExtension(fileOrgName);
            checkExe = true;

            for (String ex : fileFilter) {
                if (ex.equalsIgnoreCase(extension)) {
                    checkExe = false;
                }
            }

            if (checkExe) {
                throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
            }

            fileName = paramFileName + "." + extension;
            if ("pgcert".equals(paramFileName)) {
                file = new File(targetForPgcert + File.separator + fileName);
            } else {
                file = new File(targetPath + File.separator + fileName);
            }

            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }

            log.debug("원본파일 : {}", uploadFile);
            log.debug("대상파일 : {}", file);
            uploadFile.transferTo(file);
            fileVO = new FileVO();
            fileVO.setFileExtension(extension);
            fileVO.setFileOrgName(fileOrgName);
            fileVO.setFileSize(uploadFile.getSize());
            fileVO.setFileType(uploadFile.getContentType());
            fileVO.setFilePath(path);
            fileVO.setFileName(shopCd + File.separator + fileName);
            fileVOList.add(fileVO);
        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        return fileVOList;
    }

    private void lguPlusConfFileCopy(CommPaymentConfigPO po) throws Exception {
        String addText = po.getPgId() + " = " + po.getPgKey();
        String lgdacomConf = "lgdacom.conf", mallConf = "mall.conf";
        // String orgPath = confFilePath
        // + FileUtil.getCombinedPath(UploadConstants.PATH_CONFIG, "payment", "03", "0", "conf") + File.separator;
        String orgPath = confFilePath + File.separator + "payment" + File.separator + "03" + File.separator + "0"
                + File.separator + "conf" + File.separator;
        // String targetPath = SiteUtil.getSiteUplaodRootPath()
        // + FileUtil.getCombinedPath(UploadConstants.PATH_CONFIG, "payment", "03", "conf") + File.separator;
        String targetPath = confFilePath + File.separator + "payment" + File.separator + "03" + File.separator
                + po.getSiteNo() + File.separator + "conf" + File.separator;

        File orgDacomFilePath = new File(orgPath + lgdacomConf);
        File orgMallFilePath = new File(orgPath + mallConf);
        File targetDacomFilePath = new File(targetPath + lgdacomConf);
        File targetMallFilePath = new File(targetPath + mallConf);

        FileUtil.copy(orgDacomFilePath, targetDacomFilePath); // lgdacom.conf 파일 복사
        FileUtil.copy(orgMallFilePath, targetMallFilePath); // mall.conf 파일 복사

        // mall.conf파일 제일끝에 ShopCd, pgkey 추가(0번째에 존재하는 mall.conf 설정파일은 pgid와 pgKey가 존재하지 않을것이다.)
        BufferedWriter buffWrite = null;
        BufferedReader buffReader = null;
        FileWriter writer = null;

        try {
            // ShopCd, pgKey 추가
            buffWrite = new BufferedWriter(new FileWriter(targetMallFilePath, true));
            buffWrite.newLine();
            buffWrite.write(addText, 0, addText.length());
            buffWrite.flush();

            // log 경로 치환
            buffReader = new BufferedReader(new FileReader(targetMallFilePath));
            String line = "";
            String textContent = "";
            while ((line = buffReader.readLine()) != null) {
                textContent += line.replace("C:\\DMALL\\eclipse_workspace\\02.core\\ext_log", logFilePath);
                textContent += "\r\n";
            }

            writer = new FileWriter(targetMallFilePath);
            writer.write(textContent);
            writer.flush();
        } catch (Exception e) {
            throw e;
        } finally {
            if (buffWrite != null) {
                buffWrite.close();
                buffWrite = null;
            }

            if (buffReader != null) {
                buffReader.close();
            }

            if (writer != null) {
                writer.close();
            }
        }
    }

    private void directoryCopy(File sourcelocation, File targetdirectory) throws IOException {
        // 디렉토리가 존재하지 않으면 생성한다
        if (!sourcelocation.exists()) {
            sourcelocation.mkdir();
        }

        if (sourcelocation.isDirectory()) {
            // 복사될 Directory가 없으면 만듭니다.
            if (!targetdirectory.exists()) {
                targetdirectory.mkdir();
            }

            String[] children = sourcelocation.list();
            for (int i = 0; i < children.length; i++) {
                directoryCopy(new File(sourcelocation, children[i]), new File(targetdirectory, children[i]));
            }
        } else {
            InputStream in = null;
            OutputStream out = null;
            try {
                // 파일인 경우
                in = new FileInputStream(sourcelocation);
                out = new FileOutputStream(targetdirectory);

                // Copy the bits from instream to outstream
                byte[] buf = new byte[1024];
                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
            } catch (Exception e) {
                log.error(e.getMessage());
            } finally {
                if (in != null) {
                    try {
                        in.close();
                    } catch (Exception e) {
                        log.error(e.getMessage());
                    }
                }

                if (out != null) {
                    try {
                        out.close();
                    } catch (Exception e) {
                        log.error(e.getMessage());
                    }
                }
            }
        }
    }

    private void deleteAllFiles(String path) {
        File file = new File(path);
        // 폴더내 파일을 배열로 가져온다.
        File[] tempFile = file.listFiles();

        if (tempFile.length > 0) {

            for (int i = 0; i < tempFile.length; i++) {

                if (tempFile[i].isFile()) {
                    tempFile[i].delete();
                } else {
                    // 재귀함수
                    deleteAllFiles(tempFile[i].getPath());
                }
                tempFile[i].delete();
            }
            file.delete();
        }
    }

    private void modifyShopCdProcess(CommPaymentConfigPO po, String beforeShlpCd) throws IOException {
        // 등록된 PGID와 현재 업데이트하는 PGID가 다르다면 기존 폴더 내용을 신규 PGID 폴더로 복사
        // beforePgId가 ""이라면 최초 등록이다. 따라서 현재 ShopCd를 적용한다.
        if ("".equals(beforeShlpCd)) {
            beforeShlpCd = po.getShopCd();
        }

        if (!beforeShlpCd.equals(po.getShopCd())) {
            String path = FileUtil.getCombinedPath(confFilePath, "payment", "02", String.valueOf(po.getSiteNo()),
                    "INIpay50", "key", po.getShopCd());

            // confFilePath + File.separator + "payment" + File.separator + "02" + File.separator
            // + po.getSiteNo() + File.separator + "INIpay50" + File.separator + "key";
            String orgPath = path + File.separator + beforeShlpCd;
            String targetPath = path + File.separator + po.getShopCd();
            File orgFilePath = new File(orgPath);
            File targetFilePath = new File(targetPath);

            if (!orgFilePath.exists()) {
                orgFilePath.mkdir();
            }

            if (orgFilePath.exists()) {
                // 디렉토리 복사
                directoryCopy(orgFilePath, targetFilePath);

                // 업로드 경로를 신규 ShopCd로 replace
                po.setPgKey(po.getPgKey().replace(beforeShlpCd, po.getShopCd()));
                po.setPgKey2(po.getPgKey2().replace(beforeShlpCd, po.getShopCd()));
                po.setPgKey3(po.getPgKey3().replace(beforeShlpCd, po.getShopCd()));
                po.setPgKey4(po.getPgKey4().replace(beforeShlpCd, po.getShopCd()));

                // 기존 디렉토리 삭제
                deleteAllFiles(orgPath);
            }
        }
    }
}
