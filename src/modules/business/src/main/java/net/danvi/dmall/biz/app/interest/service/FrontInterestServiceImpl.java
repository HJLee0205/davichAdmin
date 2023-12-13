package net.danvi.dmall.biz.app.interest.service;

import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.goods.model.CategorySO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basket.model.BasketOptPO;
import net.danvi.dmall.biz.app.basket.model.BasketOptVO;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketVO;
import net.danvi.dmall.biz.app.basket.service.FrontBasketService;
import net.danvi.dmall.biz.app.goods.model.GoodsAddOptionVO;
import net.danvi.dmall.biz.app.goods.model.GoodsCtgVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.model.GoodsItemSO;
import net.danvi.dmall.biz.app.goods.model.GoodsItemVO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.interest.model.InterestPO;
import net.danvi.dmall.biz.app.interest.model.InterestSO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("frontInterestService")
@Transactional(rollbackFor = Exception.class)
public class FrontInterestServiceImpl extends BaseService implements FrontInterestService {
    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "frontBasketService")
    private FrontBasketService frontBasketService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Override
    public ResultModel<GoodsVO> selectInterest(InterestSO so) {
        GoodsVO resultVO = proxyDao.selectOne(MapperConstants.MEMBER_INTEREST + "selectInterest", so);

        ResultModel<GoodsVO> result = new ResultModel<>(resultVO);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsVO> selectInterestList(InterestSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("TMFG.REG_DTTM");
            so.setSord("DESC");
        }

        log.debug("########$$$ " + so.getLimit());
        return proxyDao.selectList(MapperConstants.MEMBER_INTEREST + "selectInterestListPaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<GoodsVO> selectInterestListPaging(InterestSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("TMFG.REG_DTTM");
            so.setSord("DESC");
        }

        log.debug("########$$$ " + so.getLimit());
        return proxyDao.selectListPage(MapperConstants.MEMBER_INTEREST + "selectInterestListPaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public Integer selectInterestTotalCount(InterestSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        return proxyDao.selectOne(MapperConstants.MEMBER_INTEREST + "selectInterestListPagingTotalCount", so);
    }

    /**
     * 관심상품등록시 중복 체크
     */
    @Override
    @Transactional(readOnly = true)
    public Integer duplicationCheck(InterestPO po) {
        return proxyDao.selectOne(MapperConstants.MEMBER_INTEREST + "duplicationCheck", po);
    }

    /**
     * 관심상품 등록
     */
    @Override
    public ResultModel<InterestPO> insertInterest(InterestPO po) throws Exception {
        ResultModel<InterestPO> result = new ResultModel<>();
        GoodsDetailSO gdso = new GoodsDetailSO();
        // 01.상품기본정보 조회
        gdso.setSiteNo(po.getSiteNo());
        gdso.setGoodsNo(po.getGoodsNo());
        gdso.setSaleYn("Y");
        gdso.setDelYn("N");
        String[] goodsStatus = { "1", "2" };
        gdso.setGoodsStatus(goodsStatus);
        ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(gdso);

        // 10.네비게이션 조회
        CategorySO cs = new CategorySO();
        cs.setSiteNo(po.getSiteNo());
        for (int j = 0; j < goodsInfo.getData().getGoodsCtgList().size(); j++) {
            GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(j);
            if(j == 0) {
            	po.setCtgNo(gcvs.getCtgNo());
            }
            if ("Y".equals(gcvs.getDlgtCtgYn())) {
                po.setCtgNo(gcvs.getCtgNo());
            }
        }

        po.setItemNo(goodsInfo.getData().getItemNo());
        int cnt = proxyDao.insert(MapperConstants.MEMBER_INTEREST + "insertInterest", po);
        if (cnt > 0) {
            result.setSuccess(true);
            result.setMessage("관심상품 담기에 성공하였습니다.");
        } else {
            result.setSuccess(false);
        }
        return result;
    }

    /**
     * 관심상품 삭제
     */
    @Override
    public ResultModel<InterestPO> deleteInterest(InterestPO po) throws Exception {
        ResultModel<InterestPO> result = new ResultModel<>();
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        if (po.getGoodsNoArr() != null && po.getGoodsNoArr().length > 0) {
            for (int i = 0; i < po.getGoodsNoArr().length; i++) {
                String goodsNo = po.getGoodsNoArr()[i];
                po.setGoodsNo(goodsNo);
                proxyDao.delete(MapperConstants.MEMBER_INTEREST + "deleteInterest", po);
            }
        }
        return result;
    }

    /**
     * 장바구니 등록
     */
    @Override
    public ResultModel<BasketPO> insertBasket(BasketPO po) throws Exception {
        ResultModel<BasketPO> result = new ResultModel<>();
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        BasketPO bpo = new BasketPO();
        if (SiteUtil.isMobile()) {
            bpo.setOrdMediaCd("02");
        } else {
            bpo.setOrdMediaCd("01");
        }

        if (po.getItemNoArr() == null) {
            GoodsDetailSO tempSo = new GoodsDetailSO();
            tempSo.setSiteNo(po.getSiteNo());
            tempSo.setGoodsNo(po.getGoodsNoArr()[0]);
            GoodsDetailVO goodsDetailVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsBasicInfo",
                    tempSo);
            String[] itemNoArr = new String[1];
            itemNoArr[0] = goodsDetailVO.getItemNo();
            po.setItemNoArr(itemNoArr);
        }

        for (int i = 0; i < po.getGoodsNoArr().length; i++) {
            String goodsNo = po.getGoodsNoArr()[i];
            String itemNo = po.getItemNoArr()[i];

            // 단품 버전 조회
            GoodsItemSO gso = new GoodsItemSO();
            gso.setGoodsNo(goodsNo);
            gso.setItemNo(itemNo);
            gso.setSiteNo(po.getSiteNo());
            GoodsItemVO goodsItemVO = new GoodsItemVO();
            goodsItemVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectItemInfo", gso);

            // 장바구니 등록 정보 매핑
            bpo.setSiteNo(po.getSiteNo());
            bpo.setGoodsNo(goodsNo);
            bpo.setItemNo(itemNo);

            if (goodsItemVO != null) {
                bpo.setItemVer(goodsItemVO.getItemVer());
                bpo.setAttrVer(goodsItemVO.getAttrVer());
            }

            bpo.setMemberNo(memberNo);
            bpo.setRegrNo(memberNo);

            // 배송비 설정 조회
            deliverySetting(goodsNo, bpo, po.getSiteNo());

            GoodsDetailSO gdso = new GoodsDetailSO();
            // 01.상품기본정보 조회
            gdso.setSiteNo(gso.getSiteNo());
            gdso.setGoodsNo(gso.getGoodsNo());
            gdso.setSaleYn("Y");
            gdso.setDelYn("N");
            String[] goodsStatus = { "1", "2" };
            gdso.setGoodsStatus(goodsStatus);
            ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(gdso);

            // 10.네비게이션 조회
            CategorySO cs = new CategorySO();
            cs.setSiteNo(gso.getSiteNo());
            for (int j = 0; j < goodsInfo.getData().getGoodsCtgList().size(); j++) {
                GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(j);
                if(j == 0) {
                	bpo.setCtgNo(gcvs.getCtgNo());
                }
                if ("Y".equals(gcvs.getDlgtCtgYn())) {
                    bpo.setCtgNo(gcvs.getCtgNo());
                }
            }

            // 중복확인
            BasketVO vo = proxyDao.selectOne(MapperConstants.BASKET + "duplicationBasketCheck", bpo);

            // 장바구니 등록
            if (vo == null) { // 등록
                bpo.setBasketNo((int) (long) bizService.getSequence("BASKET_NO", po.getSiteNo()));
                bpo.setBuyQtt(1);
                bpo.setRegrNo(memberNo);
                proxyDao.insert(MapperConstants.BASKET + "insertBasket", bpo);

                // 장바구니 분석 데이터 등록
                frontBasketService.insertBasketAnls(bpo);
            } else { // 수정
                bpo.setBasketNo(vo.getBasketNo());
                bpo.setBuyQtt(vo.getBuyQtt() + 1);
                bpo.setUpdrNo(memberNo);
                proxyDao.update(MapperConstants.BASKET + "updateBasket", bpo);
            }

            // 추가옵션 등록 시작
            GoodsDetailSO so = new GoodsDetailSO();
            so.setGoodsNo(goodsNo);
            List<GoodsAddOptionVO> goodsAddOptionList = proxyDao.selectList(MapperConstants.GOODS_MANAGE + "selectGoodsAddOptInfo", so);

            // 추가 옵션이 모두 필수인지 파악
            int requiredCnt = 0;
            for (int j = 0; j < goodsAddOptionList.size(); j++) {
                GoodsAddOptionVO tempVo = goodsAddOptionList.get(j);

                if ("Y".equals(tempVo.getRequiredYn())) {
                    requiredCnt++;
                }
            }

            // 장바구니 추가옵션 등록
            BasketOptPO optPO = new BasketOptPO();
            optPO.setSiteNo(bpo.getSiteNo());
            optPO.setRegrNo(bpo.getRegrNo());
            optPO.setUpdrNo(bpo.getUpdrNo());

            for (int k = 0; k < goodsAddOptionList.size(); k++) {
                GoodsAddOptionVO tempVo = goodsAddOptionList.get(k);
                
                // 추가옵션 사용여부
                if("Y".equals(tempVo.getAddOptUseYn())) {
                	optPO.setBasketNo(bpo.getBasketNo());
                    optPO.setOptNo(tempVo.getAddOptNo());

                    String[] addOptDtlSeqArr = tempVo.getAddOptDtlSeqArr().split("#");
                    String[] optVerArr = tempVo.getOptVerArr().split("#");

                    // 01. requiredCnt와 goodsAddOptionList.size()가 같다면 추가옵션이 모두 필수 이기때문에 모두 등록
                    if (requiredCnt == goodsAddOptionList.size()) {
                        basketProcess(optPO, addOptDtlSeqArr, optVerArr);
                    } else if (requiredCnt > 0 && requiredCnt < goodsAddOptionList.size()) {
                        // 02. requiredCnt가 0보다 크고 goodsAddOptionList.size()보다 작다면 필수값은 존재하나 추가옵션이 모두 필수값은 아니므로 필수값인것만 등록
                        if ("Y".equals(tempVo.getRequiredYn())) {
                            basketProcess(optPO, addOptDtlSeqArr, optVerArr);
                        }
                    }
                    // 03. requiredCnt가 0이면 필수인 추가옵션이 하나도없기 때문에 등록하지 않는다.
                }
            }
        }

        result.setSuccess(true);
        //result.setMessage("장바구니에 추가되었습니다.");
        return result;
    }

    private void basketProcess(BasketOptPO optPO, String[] addOptDtlSeqArr, String[] optVerArr) {
        optPO.setOptDtlSeq(Long.parseLong(addOptDtlSeqArr[0]));
        optPO.setOptVer(Integer.parseInt(optVerArr[0]));

        // 중복확인
        BasketOptVO bo = proxyDao.selectOne(MapperConstants.BASKET + "duplicationBasketAddOptCheck", optPO);
        if (bo == null) {// 등록
            optPO.setOptBuyQtt(1);
            proxyDao.insert(MapperConstants.BASKET + "insertBasketAddOpt", optPO);
        } else {// 수정
            optPO.setBasketNo(bo.getBasketNo());
            optPO.setBasketAddOptNo(bo.getBasketAddOptNo());
            int buyQtt = +bo.getOptBuyQtt();
            optPO.setOptBuyQtt(buyQtt);
            proxyDao.insert(MapperConstants.BASKET + "updateBasketAddOpt", optPO);
        }
    }

    private void deliverySetting(String goodsNo, BasketPO bpo, Long siteNo) {
        GoodsDetailSO dso = new GoodsDetailSO();
        dso.setGoodsNo(goodsNo);
        GoodsDetailVO goodsDetailVO = proxyDao.selectOne(MapperConstants.GOODS_MANAGE + "selectGoodsBasicInfo", dso);
        // 상품의 배송비 설정이 기본배송비라면 [설정]의 [배송설정메뉴] 정책을 가져와서 적용한다.
        // DLVR_SET_CD: 1:기본배송비, 2:상품별 배송비(무료), 3:상품별 배송비(유료), 4:포장단위별 배송비
        // DLVR_PAYMENT_KIND_CD: 1:선불, 2:착불, 3:선불+착불
        if ("1".equals(goodsDetailVO.getDlvrSetCd())) {
            DeliveryConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_DELIVERY + "selectDeliveryConfig",
                    siteNo);
            if ("1".equals(resultVO.getDefaultDlvrcTypeCd())) { // 무료
                bpo.setDlvrcPaymentCd("01");
            } else { // 유료
                if ("1".equals(resultVO.getDlvrPaymentKindCd()) || "3".equals(resultVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("02");
                } else if ("2".equals(resultVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("03");
                } else if ("4".equals(resultVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("04");
                }
            }
        } else { // 상품의 배송비 설정이 기본배송비가 아니라면 상품의 배송비 결제방식을 적용한다.
            if ("2".equals(goodsDetailVO.getDlvrSetCd())) { // 무료
                bpo.setDlvrcPaymentCd("01");
            } else { // 유료
                if ("1".equals(goodsDetailVO.getDlvrPaymentKindCd())
                        || "3".equals(goodsDetailVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("02");
                } else if ("2".equals(goodsDetailVO.getDlvrPaymentKindCd())) {
                    bpo.setDlvrcPaymentCd("03");
                }
            }
        }
    }
}
