package net.danvi.dmall.front.web.view.goods.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.design.model.BannerSO;
import net.danvi.dmall.biz.app.design.model.BannerVO;
import net.danvi.dmall.biz.app.design.service.BannerManageService;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.seller.model.SellerPO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigVO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.goods.service.RestockNotifyService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.operation.service.BbsManageService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtSO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieGoodsVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieTargetVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.service.FreebieCndtService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.app.setup.term.service.TermConfigService;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import dmall.framework.common.exception.AdultOnlyException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.goods.controller
 * - 파일명        : GoodsController.java
 * - 작성일        : 2016. 5. 2.
 * - 작성자        : dong
 * - 설명          : 상품 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/goods")
public class GoodsController {

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    @Resource(name = "termConfigService")
    private TermConfigService termConfigService;

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Resource(name = "freebieCndtService")
    private FreebieCndtService freebieCndtService;

    @Resource(name = "restockNotifyService")
    private RestockNotifyService restockNotifyService;

    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Resource(name = "snsOutsideLinkService")
    private SnsOutsideLinkService snsOutsideLinkService;

    @Resource(name = "bannerManageService")
    private BannerManageService bannerManageService;

    @Resource(name = "sellerService")
    private SellerService sellerService;

    @RequestMapping(value = "/goods-detail")
    public ModelAndView selectGoodsInfo(@Validated GoodsDetailSO so, BindingResult bindingResult,
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        ModelAndView mav = SiteUtil.getSkinView("/goods/goods_detail");

        // 외부 사이트 배너 등을 통한 유입시 유입체널을 쿠키에 저장한다.
        // 상품 조회시 유입체널이 없을경우 유입체널 쿠키를 삭제한다.
        String ch  = request.getParameter("ch");

        // todo : 메르시 스카치 사전예약 이벤트, 이벤트 완료 후 삭제 한다.
        if ((ch == null || "".equals(ch)) && "G2204121428_8923".equals(so.getGoodsNo())) ch="TSE10-00";

        ch = ch == null? "": ch;
        Cookie chCookie = new Cookie("from_channel", ch);
        chCookie.setPath("/");
        response.addCookie(chCookie);


        if ("".equals(so.getGoodsNo()) || so.getGoodsNo() == null) {
            throw new Exception(MessageUtil.getMessage("front.web.common.wrongapproach"));
        }
        long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        // 01.상품기본정보 조회
        so.setSaleYn("Y");
        so.setDelYn("N");
        String[] goodsStatus = { "1", "2" };
        so.setGoodsStatus(goodsStatus);
        ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(so);

        //D-매거진 view
        if(goodsInfo.getData().getGoodsContsGbCd().equals("02")) {
            mav = SiteUtil.getSkinView("/goods/magazine_detail");
        }

        if (goodsInfo.getData() == null) {
            ModelAndView mavErr = new ModelAndView("error/notice");
            mavErr.addObject("exMsg", MessageUtil.getMessage("front.web.goods.noSale"));
            return mavErr;
        }

        // 02.성인상품 검증
        if ("Y".equals(goodsInfo.getData().getAdultCertifyYn())) {
            if (!SessionDetailHelper.getDetails().isLogin()) {
                throw new AdultOnlyException("/front/goods/goods-detail?goodsNo=" + so.getGoodsNo());
            } else {
                if (!SessionDetailHelper.getDetails().getSession().getAdult()) {
                    ModelAndView adult_page = new ModelAndView("/login/adult_noti");
                    return adult_page;
                }
            }
        }

        String goodsNo = goodsInfo.getData().getGoodsNo();

        String couponCtgNoArr = "";
        List<CategoryVO> list = new ArrayList<>();
        CategorySO categorySO = new CategorySO();
        categorySO.setSiteNo(so.getSiteNo());
        for (int i = 0; i < goodsInfo.getData().getGoodsCtgList().size(); i++) {
            GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(i);
            categorySO.setCtgNo(gcvs.getCtgNo());
            list = categoryManageService.selectUpNavagation(categorySO);
            for (int k = 0; k < list.size(); k++) {
                CategoryVO vo = list.get(k);
                if (!"".equals(couponCtgNoArr)) {
                    couponCtgNoArr += ",";
                }
                couponCtgNoArr += vo.getCtgNo();
            }
        }
        goodsInfo.getData().setCouponCtgNoArr(couponCtgNoArr);
        if(goodsInfo.getData().getPrWords()!=null && !goodsInfo.getData().getPrWords().equals("")) {
            goodsInfo.getData().setPrWords(goodsInfo.getData().getPrWords().replace("\n", "<br>"));
        }

        if(goodsInfo.getData().getTxLimitCndt()!=null && !goodsInfo.getData().getTxLimitCndt().equals("")) {
            goodsInfo.getData().setTxLimitCndt(goodsInfo.getData().getTxLimitCndt().replace("\n", "<br>"));
        }

        mav.addObject("goodsInfo", goodsInfo);

        // 03.단품정보
        String jsonList = "";
        if (goodsInfo.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfo.getData().getGoodsItemList());
        }
        mav.addObject("goodsItemInfo", jsonList);

        // 04.상품문의.상품평.상품평평균치 조회
        BbsLettManageSO blmSo = new BbsLettManageSO();
        blmSo.setSiteNo(so.getSiteNo());
        blmSo.setGoodsNo(goodsNo);
        ResultModel<BbsLettManageVO> goodsBbsInfo = bbsManageService.goodsBbsInfo(blmSo);
        mav.addObject("goodsBbsInfo", goodsBbsInfo);
        mav.addObject("averageScore", goodsBbsInfo.getData().getAverageScore());

        // 05.상품 상세 설명 조회
        GoodsContentsVO goodsContentVO = new GoodsContentsVO();
        goodsContentVO.setGoodsNo(goodsNo);
        ResultModel<GoodsContentsVO> content = goodsManageService.selectGoodsContents(goodsContentVO);

        mav.addObject("goodsContentVO", content.getData());

        // 06.배송,반품,환불정책 조회
        TermConfigSO tso = new TermConfigSO();
        tso.setSiteNo(so.getSiteNo());
        tso.setSiteInfoCd("14"); // 배송정책
        mav.addObject("term_14", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("15"); // 반품정책tso
        mav.addObject("term_15", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("16"); // 환불정책
        mav.addObject("term_16", termConfigService.selectTermConfig(tso));

        // 07.사용 가능 쿠폰 조회
        CouponSO cp = new CouponSO();
        cp.setCouponCtgNoArr(couponCtgNoArr); // 쿠폰조회용 String배열
        cp.setGoodsNo(goodsNo);
        cp.setSiteNo(siteNo);
        mav.addObject("couponList", couponService.selectAvailableGoodsCouponList(cp));
        
        if (SessionDetailHelper.getDetails().isLogin()) {
            // 08.회원기본정보 조회
            long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
            MemberManageSO memberManageSO = new MemberManageSO();
            memberManageSO.setMemberNo(memberNo);
            memberManageSO.setSiteNo(siteNo);
            ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(memberManageSO);

            mav.addObject("member_info", member_info); // 회원정보
        }

        // 09.기획전 할인정보 조회

        // 특가 프로모션 체크
        // 신규회원(가입후 3일이내)  / 기존회원 (쿠폰 발급후 3일이내) 에 해당 할 경우에만 특가로 구매가능하도록...

        // 신규회원 구매 가능 여부


        // 기존회원 구매 가능 여부

        ExhibitionSO pso = new ExhibitionSO();
        pso.setSiteNo(siteNo);
        pso.setGoodsNo(goodsNo);
        String prmtBrandNo ="";
        if(goodsInfo.getData().getBrandNo()!=null && !goodsInfo.getData().getBrandNo().equals("")) {
            prmtBrandNo = goodsInfo.getData().getBrandNo();
            pso.setPrmtBrandNo(prmtBrandNo);
        }

        mav.addObject("promotionInfo", exhibitionService.selectExhibitionByGoods(pso));

        // 10.사은품대상조회
        ResultListModel<FreebieTargetVO> freebieEventList = new ResultListModel<>();
        FreebieCndtSO freebieCndtSO = new FreebieCndtSO();
        freebieCndtSO.setGoodsNo(goodsNo);
        freebieCndtSO.setSiteNo(siteNo);
        freebieEventList = freebieCndtService.selectFreebieListByGoodsNo(freebieCndtSO);
        List<FreebieGoodsVO> freebieList = (List<FreebieGoodsVO>) freebieEventList.getExtraData().get("goodsResult");
        List<FreebieGoodsVO> freebieGoodsList = new ArrayList();
        // 사은품 조회
        if (freebieList != null && freebieList.size() > 0) {
            for (int j = 0; j < freebieList.size(); j++) {
                FreebieGoodsVO freebieEventVO = freebieList.get(j);
                FreebieCndtSO freebieGoodsSO = new FreebieCndtSO();
                freebieGoodsSO.setSiteNo(so.getSiteNo());
                freebieGoodsSO.setFreebieEventNo(freebieEventVO.getFreebieEventNo());
                ResultModel<FreebieCndtVO> freeGoodsList = new ResultModel<>();
                freeGoodsList = freebieCndtService.selectFreebieCndtDtl(freebieGoodsSO);
                log.debug("== freeGoodsList : {}", freeGoodsList.getExtraData().get("goodsResult"));
                List<FreebieGoodsVO> freebieList2 = new ArrayList();
                freebieList2 = (List<FreebieGoodsVO>) freeGoodsList.getExtraData().get("goodsResult");
                if (freebieList2 != null && freebieList2.size() > 0) {
                    for (int m = 0; m < freebieList2.size(); m++) {
                        FreebieGoodsVO freebieGoodsVO = freebieList2.get(m);
                        freebieGoodsList.add(freebieGoodsVO);
                    }
                }
            }
        }
        // 사은품 제공 조건에 따라 해당 사은품을 추출
        long maxAmt = 0;
        int freebie_No = 0;
        for (int i = 0; i < freebieGoodsList.size(); i++) {
            FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(i);
            if ("02".equals(freebieGoodsVO.getFreebiePresentCndtCd())) {
                freebie_No = freebieGoodsVO.getFreebieEventNo();
                break;
            } else {
                if (maxAmt < freebieGoodsVO.getFreebieEventAmt()) {
                    maxAmt = freebieGoodsVO.getFreebieEventAmt();
                    freebie_No = freebieGoodsVO.getFreebieEventNo();
                }
            }
        }
        // 사은품목록에서 해당 사은품을 제외한 나머지는 삭제
        for (int i = 0; i < freebieGoodsList.size(); i++) {
            FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(i);
            if (freebie_No != freebieGoodsVO.getFreebieEventNo()) {
                freebieGoodsList.remove(i);
            }
        }
        mav.addObject("freebieGoodsList", freebieGoodsList);

        // 10.네비게이션 조회
        CategorySO cs = new CategorySO();
        cs.setSiteNo(so.getSiteNo());
        // 카테고리 번호가 넘어오지 않을경우 상품의 대표카테고리를 조회한다.
        if ("".equals(so.getCtgNo()) || so.getCtgNo() == null) {
            for (int i = 0; i < goodsInfo.getData().getGoodsCtgList().size(); i++) {
                GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(i);
                if(i == 0) {
                	cs.setCtgNo(gcvs.getCtgNo());
                	so.setCtgNo(gcvs.getCtgNo());
                }
                
                if ("Y".equals(gcvs.getDlgtCtgYn())) {
                    cs.setCtgNo(gcvs.getCtgNo());
                    so.setCtgNo(gcvs.getCtgNo());
                }
            }
        }
        List<CategoryVO> navigation = categoryManageService.selectUpNavagation(cs);
        mav.addObject("navigation", navigation);

        // 11.SNS공유 관련 설정 조회
        Map<String, String> snsMap = new HashMap<>();
        SiteSO ss = new SiteSO();
        ss.setSiteNo(so.getSiteNo());
        SiteVO site_info = cacheService.selectBasicInfo(ss);
        if ("Y".equals(site_info.getContsUseYn())) {
            ResultListModel<SnsConfigVO> resultListModel = new ResultListModel<>();
            resultListModel = snsOutsideLinkService.selectSnsConfigList(SessionDetailHelper.getDetails().getSiteNo());
            List<SnsConfigVO> snslist = resultListModel.getResultList();
            if (snslist != null && snslist.size() > 0) {
                for (SnsConfigVO vo : snslist) {
                    if ("Y".equals(vo.getLinkUseYn()) && "Y".equals(vo.getLinkOperYn())) {
                        switch (vo.getOutsideLinkCd()) {
                        case "01":// 페이스북
                            snsMap.put("fbAppId", vo.getAppId());
                            snsMap.put("fbAppSecret", vo.getAppSecret());
                            break;
                        case "02":// 네이버
                            snsMap.put("naverClientId", vo.getAppId());
                            snsMap.put("naverSecret", vo.getAppSecret());
                            break;
                        case "03":// 카카오톡
                            snsMap.put("javascriptKey", vo.getJavascriptKey());
                            break;
                        }
                    }
                }
            }
        }

        // 배너 조회
        BannerSO bs = new BannerSO();
        bs.setSiteNo(so.getSiteNo());// 사이트번호셋팅
        String skinNo = "";

        if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
            skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
        } else {
            skinNo = "2";
        }

        // 쇼핑몰의 리얼 스킨번호를 가져온다.
        bs.setSkinNo(skinNo);
        if(SiteUtil.isMobile()) {
            bs.setBannerMenuCd("MO");
            bs.setBannerAreaCd("MGT");
        }else{
            bs.setBannerMenuCd("CM");
            bs.setBannerAreaCd("GDT");
        }
        bs.setDispYn("Y");
        bs.setTodayYn("Y");
        bs.setSidx("SORT_SEQ");
        bs.setSord("ASC");
        ResultListModel<BannerVO> bannerVo = new ResultListModel<>();
        bannerVo = bannerManageService.selectBannerListPaging(bs);
        mav.addObject("goods_top_banner", bannerVo);

        if(SiteUtil.isMobile()) {
            bs.setBannerMenuCd("MO");
            bs.setBannerAreaCd("MGF");
        }else{
            bs.setBannerMenuCd("CM");
            bs.setBannerAreaCd("GDF");
        }
        bs.setDispYn("Y");
        bs.setTodayYn("Y");
        bs.setSidx("SORT_SEQ");
        bs.setSord("ASC");
        ResultListModel<BannerVO> bannerVo2 = new ResultListModel<>();
        bannerVo2 = bannerManageService.selectBannerListPaging(bs);
        mav.addObject("goods_footer_banner", bannerVo2);

        mav.addObject("snsMap", snsMap);
        mav.addObject("so", so);

        //판매자별 배송정책
        SellerPO po = new SellerPO();
        if(!goodsInfo.getData().getGoodsContsGbCd().equals("02")) {
            po.setSiteNo(siteNo);
            po.setSellerNo(String.valueOf(goodsInfo.getData().getSellerNo()));
            ResultModel<DeliveryConfigVO> result = sellerService.selectDeliveryConfig(po);
            /*DeliveryConfigVO svo = result.getData();*/
            mav.addObject("seller_info", result.getData());
        }

        return mav;
    }

    @RequestMapping(value = "/goods-preview")
    public ModelAndView selectGoodsPreview(GoodsVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = new ModelAndView("/goods/goods_dummy");
        mav.addObject("so", vo);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 상품 미리보기 프론트 호출
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param jsonStr
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/goods-detail-preview")
    public ModelAndView selectGoodsInfoPreview(String jsonStr) throws Exception {

        // log.debug("======================================> KWT jsonStr :" +
        // jsonStr);
        ObjectMapper mappr = new ObjectMapper();
        GoodsDetailVO vo = mappr.readValue(jsonStr, GoodsDetailVO.class);
        // log.debug("======================================> KWT vo :" + vo);

        ModelAndView mav = SiteUtil.getSkinView("/goods/goods_edit_preview");
        if ("".equals(vo.getGoodsNo()) || vo.getGoodsNo() == null) {
            throw new Exception(MessageUtil.getMessage("front.web.common.wrongapproach"));
        }
        long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        vo.setSiteNo(siteNo);

        // 01.상품기본정보 조회
        String goodsNo = vo.getGoodsNo();
        String couponCtgNoArr = "";
        List<CategoryVO> list = new ArrayList<>();

        CategorySO categorySO = new CategorySO();
        categorySO.setSiteNo(siteNo);

        if (vo.getGoodsCtgList() != null) {
            for (int i = 0; i < vo.getGoodsCtgList().size(); i++) {
                GoodsCtgVO gcvs = vo.getGoodsCtgList().get(i);
                categorySO.setCtgNo(gcvs.getCtgNo());

                list = categoryManageService.selectUpNavagation(categorySO);
                for (int k = 0; k < list.size(); k++) {
                    CategoryVO vo1 = list.get(k);
                    if (!"".equals(couponCtgNoArr)) {
                        couponCtgNoArr += ",";
                    }
                    couponCtgNoArr += vo1.getCtgNo();
                }
            }
        }
        vo.setCouponCtgNoArr(couponCtgNoArr);

        ResultModel<GoodsDetailVO> resultModel1 = new ResultModel<>();
        resultModel1.setData(vo);
        mav.addObject("goodsInfo", resultModel1);

        // 02.단품정보
        String jsonList = "";
        if (vo.getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(vo.getGoodsItemList());
        }
        mav.addObject("goodsItemInfo", jsonList);

        // 03.상품문의.상품평.상품평평균치 조회

        // 04.상품 상세 조회
        GoodsContentsVO goodsContentVO = new GoodsContentsVO();
        goodsContentVO.setGoodsNo(goodsNo);
        goodsContentVO.setContent(vo.getContent());
        // goodsContentVO.setAttachImages(po.getAttachImages());
        mav.addObject("goodsContentVO", goodsContentVO);

        // 05.배송,반품,환불정책 조회
        TermConfigSO tso = new TermConfigSO();
        tso.setSiteNo(siteNo);
        tso.setSiteInfoCd("14"); // 배송정책
        mav.addObject("term_14", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("15"); // 반품정책tso
        mav.addObject("term_15", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("16"); // 환불정책
        mav.addObject("term_16", termConfigService.selectTermConfig(tso));

        if (SessionDetailHelper.getDetails().isLogin()) {
            // 06.사용 가능 쿠폰 조회(회원만)
            CouponSO cs = new CouponSO();
            cs.setCouponCtgNoArr(couponCtgNoArr); // 쿠폰조회용 String배열
            cs.setGoodsNo(goodsNo);
            cs.setSiteNo(siteNo);
            mav.addObject("couponList", couponService.selectAvailableGoodsCouponList(cs));
            // 07.회원기본정보 조회
            long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
            MemberManageSO memberManageSO = new MemberManageSO();
            memberManageSO.setMemberNo(memberNo);
            memberManageSO.setSiteNo(siteNo);
            ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(memberManageSO);

            mav.addObject("member_info", member_info); // 회원정보
        }

        // 09.기획전 할인정보 조회
        ExhibitionSO pso = new ExhibitionSO();
        pso.setSiteNo(siteNo);
        pso.setGoodsNo(goodsNo);
        String prmtBrandNo ="";
        if(vo.getBrandNo()!=null && !vo.getBrandNo().equals("")) {
            prmtBrandNo = vo.getBrandNo();
            pso.setPrmtBrandNo(prmtBrandNo);
        }
        mav.addObject("promotionInfo", exhibitionService.selectExhibitionByGoods(pso));

        // 10.사은품대상조회
        ResultListModel<FreebieTargetVO> freebieEventList = new ResultListModel<>();
        FreebieCndtSO freebieCndtSO = new FreebieCndtSO();
        freebieCndtSO.setGoodsNo(goodsNo);
        freebieCndtSO.setSiteNo(siteNo);
        freebieEventList = freebieCndtService.selectFreebieListByGoodsNo(freebieCndtSO);

        List<FreebieGoodsVO> freebieList = (List<FreebieGoodsVO>) freebieEventList.getExtraData().get("goodsResult");
        List<FreebieGoodsVO> freebieGoodsList = new ArrayList();
        // 사은품 조회
        if (freebieList != null && freebieList.size() > 0) {
            for (int j = 0; j < freebieList.size(); j++) {
                FreebieGoodsVO freebieEventVO = freebieList.get(j);
                FreebieCndtSO freebieGoodsSO = new FreebieCndtSO();
                freebieGoodsSO.setSiteNo(siteNo);
                freebieGoodsSO.setFreebieEventNo(freebieEventVO.getFreebieEventNo());
                ResultModel<FreebieCndtVO> freeGoodsList = new ResultModel<>();
                freeGoodsList = freebieCndtService.selectFreebieCndtDtl(freebieGoodsSO);
                log.debug("== freeGoodsList : {}", freeGoodsList.getExtraData().get("goodsResult"));
                List<FreebieGoodsVO> freebieList2 = new ArrayList();
                freebieList2 = (List<FreebieGoodsVO>) freeGoodsList.getExtraData().get("goodsResult");
                if (freebieList2 != null && freebieList2.size() > 0) {
                    for (int m = 0; m < freebieList2.size(); m++) {
                        FreebieGoodsVO freebieGoodsVO = freebieList2.get(m);
                        freebieGoodsList.add(freebieGoodsVO);
                    }
                }
            }
        }
        // 사은품 제공 조건에 따라 해당 사은품을 추출
        long maxAmt = 0;
        String freebie_No = "";
        for (int i = 0; i < freebieGoodsList.size(); i++) {
            FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(i);
            if ("02".equals(freebieGoodsVO.getFreebiePresentCndtCd())) {
                freebie_No = freebieGoodsVO.getFreebieNo();
                break;
            } else {
                if (maxAmt < freebieGoodsVO.getFreebieEventAmt()) {
                    maxAmt = freebieGoodsVO.getFreebieEventAmt();
                    freebie_No = freebieGoodsVO.getFreebieNo();
                }
            }
        }
        // 사은품목록에서 해당 사은품을 제외한 나머지는 삭제
        for (int i = 0; i < freebieGoodsList.size(); i++) {
            FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(i);
            if (freebie_No != freebieGoodsVO.getFreebieNo()) {
                freebieGoodsList.remove(i);
            }
        }
        mav.addObject("freebieGoodsList", freebieGoodsList);

        // 09.네비게이션 조회
        CategorySO cs = new CategorySO();
        cs.setSiteNo(siteNo);
        if (vo.getGoodsCtgList() != null) { // 상품의 대표카테고리를 조회한다.
            for (int i = 0; i < vo.getGoodsCtgList().size(); i++) {
                GoodsCtgVO gcvs = vo.getGoodsCtgList().get(i);
                if(i == 0) {
                	cs.setCtgNo(gcvs.getCtgNo());
                }
                if ("Y".equals(gcvs.getDlgtCtgYn())) {
                    cs.setCtgNo(gcvs.getCtgNo());
                }
            }
        }
        List<CategoryVO> navigation = categoryManageService.selectUpNavagation(cs);
        mav.addObject("navigation", navigation);

        // 09.고시정보
        List<Map<String, String>> notifyList = vo.getGoodsNotifyList();
        mav.addObject("goodsNotifyList", notifyList);

        // 10.관련상품정보
        if (!StringUtils.isEmpty(vo.getRelateGoodsApplyTypeCd()) && !"3".equals(vo.getRelateGoodsApplyTypeCd())) {
            vo.setSaleYn("Y");
            List<GoodsVO> relateGoodsList = goodsManageService.selectRelateGoodsList(vo);
            vo.setRelateGoodsList(relateGoodsList);
        }

        mav.addObject("so", vo);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : KMS
     * 설명   : 상품 고시정보 조회(ajax)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. KMS - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/notify-list")
    public ModelAndView ajaxNotifyList(@Validated GoodsNotifySO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/goods/goods_info_01");
        List<GoodsNotifyVO> list = goodsManageService.selectGoodsNotifyItemList(so);
        log.debug("=== so : {}", so);
        mav.addObject("goodsNotifyList", list);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : KMS
     * 설명   : 상품 상세 배송/반품/환불 정보 조회(ajax)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. KMS - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/goods-extra-info")
    public ModelAndView ajaxGoodsExtraInfo(@Validated TermConfigSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/goods/goods_info_04");
        so.setSiteInfoCd("14"); // 배송정책
        mav.addObject("term_14", termConfigService.selectTermConfig(so));
        so.setSiteInfoCd("15"); // 반품정책
        mav.addObject("term_15", termConfigService.selectTermConfig(so));
        so.setSiteInfoCd("16"); // 환불정책
        mav.addObject("term_16", termConfigService.selectTermConfig(so));
        return mav;
    }

    @RequestMapping(value = "/goods-image-preview")
    public ModelAndView selectGoodsImageList(@Validated GoodsDetailSO so, BindingResult bindingResult)
            throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/goods/goods_preview");
        ResultModel<GoodsDetailVO> goodsImageSetList = goodsManageService.selectGoodsImageList(so);
        mav.addObject("goodsImageList", goodsImageSetList);
        return mav;
    }

    // 재입고 알림팝업
    @RequestMapping(value = "/restock-pop")
    public ModelAndView restockPop(GoodsVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = new ModelAndView("/goods/restock_pop");
        mav.addObject("vo", vo);
        return mav;
    }

    @RequestMapping("/restock-notify-insert")
    public @ResponseBody ResultModel<RestockNotifyPO> insertRestockNotify(RestockNotifyPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        ResultModel<RestockNotifyPO> result = new ResultModel<>();

        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        if (memberNo < 0) {
            result.setSuccess(true);
            result.setMessage("로그인후 이용해주시기 바랍니다.");
        }

        RestockNotifyVO vo = new RestockNotifyVO();
        vo.setMemberNo(memberNo);
        vo.setGoodsNo(po.getGoodsNo());
        vo = restockNotifyService.selectDuplicateAlarm(vo);
        if (vo!=null && vo.getDupleCnt() > 0) {
            po.setAlarmStatusCd("1");// 알림상태코드
            po.setReInsertYn("Y"); // 재등록 여부
            po.setReinwareAlarmNo(vo.getReinwareAlarmNo());
            result = restockNotifyService.updateRestockNotify(po);
        } else {
            po.setMemberNo(memberNo);
            po.setAlarmStatusCd("1");// 알림상태코드
            result = restockNotifyService.insertRestockNotify(po);
        }
        result.setMessage("재입고 알림이 등록되었습니다.");
        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 10.
     * 작성자 : hskim
     * 설명   : 증정상품 예약내역 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 10. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/pre-goods-rsv-chk")
    public @ResponseBody ResultModel<GoodsDetailVO> preGoodsRsvChk(String memberNo, String goodsNo) throws Exception {

        ResultModel<GoodsDetailVO> result = new ResultModel<>();
        
        Map<String, String> param = new HashMap<>();
        param.put("memberNo", memberNo);
        param.put("goodsNo", goodsNo);
        
        int rsvCnt = goodsManageService.preGoodsRsvChk(param);
        if(rsvCnt > 0) {
        	result.setSuccess(false);
        }else {
        	result.setSuccess(true);
        }

        return result;
    }

}