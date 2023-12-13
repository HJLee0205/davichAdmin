package net.danvi.dmall.front.web.view.main.controller;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.PopManageSO;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.goods.service.BrandManageService;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.goods.service.MainDisplayService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.operation.service.BbsManageService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigVO;
import net.danvi.dmall.biz.app.setup.term.service.TermConfigService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.main.controller
 * - 파일명        : MainController.java
 * - 작성일        : 2016. 5. 2.
 * - 작성자        : dong
 * - 설명          : Main Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front")
public class MainController {

    @Resource(name = "termConfigService")
    private TermConfigService termConfigService;

    @Resource(name = "mainDisplayService")
    private MainDisplayService mainDisplayService;

    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    @Resource(name = "snsOutsideLinkService")
    private SnsOutsideLinkService snsOutsideLinkService;
    
    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;
    
    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;
    
    @Resource(name = "brandManageService")
    private BrandManageService brandManageService;
    
    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;
    
    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : main.jsp 프레임영역
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/main-view")
    public ModelAndView main(MemberManagePO po, HttpServletRequest request) throws Exception {
        log.debug("main");
        ModelAndView mav = SiteUtil.getSkinView();
        // 03. forword page Setting
        mav.setViewName("/main/main");
        
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        // 01. MAIN VIsual Banner AND DisplayZone 상품목록조회
        DisplayGoodsSO so = new DisplayGoodsSO();
        so.setSiteNo(sessionInfo.getSiteNo());
        so.setUseYn("Y");
        so.setSidx("SORT_SEQ");
        so.setSord("ASC");
        mav.addAllObjects(mainDisplayService.seleceAllMainDisplayGoodsFront(so));

        // 02. SNS 부가 정보 입력(최초 가입1회만)
        String sns_add_info_Yn = request.getParameter("sns_add_info_Yn");
        mav.addObject("sns_add_info_Yn", sns_add_info_Yn);

         //SNS
        /*Map<String, String> snsMap = new HashMap<>();
        ResultListModel<SnsConfigVO> resultListModel = new ResultListModel<>();
        resultListModel = snsOutsideLinkService.selectSnsConfigList(SessionDetailHelper.getDetails().getSiteNo());
        List<SnsConfigVO> list = resultListModel.getResultList();
        if (list != null && list.size() > 0) {
            for (SnsConfigVO vo : list) {
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
        mav.addObject("snsOutsideLink", resultListModel);
        mav.addObject("snsMap", snsMap);*/

        if(SiteUtil.isMobile()) {
            if (sessionInfo.isLogin()) {
                //모바일 app 정보 조회
                MemberManageSO mso = new MemberManageSO();
                mso.setSiteNo(sessionInfo.getSiteNo());
                mso.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                mav.addObject("appInfo", frontMemberService.selectAppInfo(mso));
                mav.addObject("memberNoYn", "Y");
            }

            //05. 진행중인 기획전 조회(모바일)
            ExhibitionSO eo = new ExhibitionSO();
            eo.setSiteNo(so.getSiteNo());
            eo.setPrmtStatusCd("02");
            eo.setPrmtMainExpsUseYn("Y");
            mav.addObject("exhibitionListModel", exhibitionService.selectExhibitionListPaging(eo));


            //06. 리뷰 조회(모바일)
       /*   BbsLettManageSO ro = new BbsLettManageSO();

            ro.setBbsId("review");
            ro.setExpsYn("Y"); // 노출여부
            ro.setMainYn("Y"); //메인여부

            // default 기간검색(최근3개월)
            if (StringUtil.isEmpty(ro.getFromRegDt()) || StringUtil.isEmpty(ro.getToRegDt())) {
                Calendar cal = new GregorianCalendar(Locale.KOREA);
                cal.add(Calendar.MONTH, -3);
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                String fromRegDt = df.format(cal.getTime());
                String toRegDt = df.format(new Date());
                ro.setFromRegDt(fromRegDt);
                ro.setToRegDt(toRegDt);
            }
            //ro.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            if(SiteUtil.isMobile()) {
                mav.addObject("reviewListModel", bbsManageService.selectBbsLettPaging(ro));
            }*/

            // 인트로화면의 멤버쉽 바로보기
            mav.addObject("introYn", po.getIntro());

            // 방문예약 매장 총 개수 조회
            Map<String, Object> param = new HashMap<>();
            Map<String, Object> result = new HashMap<>();
            result = InterfaceUtil.send("IF_RSV_006", param);
            if ("1".equals(result.get("result"))) {
            mav.addObject("storeTotCnt", result.get("totalCnt"));

            }else{
                throw new Exception(String.valueOf(result.get("message")));
            }

        }

        if(!SiteUtil.isMobile()) {
            //04. 브랜드리스트 조회
            BrandSO bo = new BrandSO();
            bo.setSiteNo(so.getSiteNo());
            bo.setDispYn("Y");
            bo.setMainDispYn("Y");
            mav.addObject("resultListModel", brandManageService.selectBrandList(bo));
        }


        return mav;
    }
    
    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : main.jsp 프레임영역
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/main-intro")
    public ModelAndView main_intro(HttpServletRequest request) throws Exception {
        log.debug("intro");
        ModelAndView mav = SiteUtil.getSkinView();
        
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        // 01. MAIN VIsual Banner AND DisplayZone 상품목록조회
        DisplayGoodsSO so = new DisplayGoodsSO();
        so.setSiteNo(sessionInfo.getSiteNo());
        so.setUseYn("Y");
        so.setSidx("SORT_SEQ");
        so.setSord("ASC");
        mav.addAllObjects(mainDisplayService.selectIntroFront(so));

        if(SiteUtil.isMobile()) {
        	mav.setViewName("/main/intro");
        }else {
        	throw new Exception("잘못된 경로로 접속하셨습니다.");
        }
        
        // 사이트정보 조회
        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(sessionInfo.getSession().getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);
        
        mav.addObject("siteInfo", siteInfo);
        
        return mav;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 2. 27.
     * 작성자 : hskim
     * 설명   : 앱 푸쉬 동의 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 2. 27. hskim - 최초생성
     * </pre>
     */
    @RequestMapping("/appPush-agree")
    public @ResponseBody ResultModel<MemberManagePO> updateAppPushAgree(MemberManagePO po) throws Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();
        frontMemberService.updateAppPushAgree(po);
        return result;
    }

    @RequestMapping(value = "/brand-category")
    public ModelAndView viewBrandCategory(@Validated BrandSO so, BindingResult bindingResult) throws Exception {
    	
    	ModelAndView mav = SiteUtil.getSkinView("/category/category_brand_list");
    		
		BrandVO bv = new BrandVO();
        bv.setSiteNo(so.getSiteNo());
        
        String best_brand = goodsManageService.selectBestBrandNo(bv);
        bv.setBrandNo(best_brand);
        
        List<BrandVO> brand_rolling = goodsManageService.selectBrandList(bv);
        mav.addObject("brand_rolling", brand_rolling);
        
        mav.addObject("so", so);
    	
        return mav;
    }
    
    
    @RequestMapping("/brand-category-list-ajax")
    public @ResponseBody List<BrandVO> ajaxBrandList(@Validated BrandSO so, BindingResult bindingResult) throws Exception {

        BrandVO bv = new BrandVO();
        bv.setSiteNo(so.getSiteNo());
        
        List<BrandVO> brand_list = goodsManageService.selectBrandCategoryList(bv);
        
        return brand_list;
    }
    
    @RequestMapping("/brand-category-dtl")
    public ModelAndView viewBrandCategoryDtl(@Validated CategorySO so, BindingResult bindingResult) throws Exception {
    	
        ModelAndView mav = SiteUtil.getSkinView("/category/category_brand_dtl");

        GoodsSO gs = new GoodsSO();
        BeanUtils.copyProperties(so, gs);
        String goodsDisplay[] = { "Y" }; // 전시여부
        gs.setGoodsDisplay(goodsDisplay);
        gs.setSaleYn("Y");

        if ("".equals(so.getSortType()) || so.getSortType() == null) so.setSortType("02");
        if ("01".equals(so.getSortType())) {// 판매순
            gs.setSidx("ACCM_SALE_AMT");
            gs.setSord("DESC");
        } else if ("02".equals(so.getSortType())) {// 신상품순
            gs.setSidx("REG_DTTM");
            gs.setSord("DESC");
        } else if ("03".equals(so.getSortType())) {// 낮은가격순
            gs.setSidx("SALE_PRICE");
            gs.setSord("ASC");
        } else if ("04".equals(so.getSortType())) {// 높은가격순
            gs.setSidx("SALE_PRICE");
            gs.setSord("DESC");
        } else if ("05".equals(so.getSortType())) {// 상품평 많은순
            gs.setSidx("ACCM_GOODSLETT_CNT");
            gs.setSord("DESC");
        }

        if (so.getRows() < 20) so.setRows(20); // 최소 20개씨 노출
        gs.setRows(so.getRows());
        
        // 필터 조건
        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(gs);
        mav.addObject("resultListModel", result);
        
        BrandVO bv = new BrandVO();
        bv.setSiteNo(so.getSiteNo());
        bv.setBrandNo(so.getSearchBrands()[0]);
        List<BrandVO> brand_list = goodsManageService.selectBrandList(bv);
        mav.addObject("brand", brand_list.get(0));
        
        if (so.getDisplayTypeCd() == null || "".equals(so.getDisplayTypeCd())) {
            so.setDisplayTypeCd("01");
        }
        
        mav.addObject("so", so);
        
        return mav;
    }
    
    @RequestMapping("/brand-category-paging")
    public ModelAndView viewBrandCategoryPaging(@Validated CategorySO so, BindingResult bindingResult) {
        
    	ModelAndView mav = SiteUtil.getSkinView("/category/category_brand_paging");
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        GoodsSO gs = new GoodsSO();
        BeanUtils.copyProperties(so, gs);
        String goodsDisplay[] = { "Y" }; // 전시여부
        gs.setGoodsDisplay(goodsDisplay);
        gs.setSaleYn("Y");

        if ("".equals(so.getSortType()) || so.getSortType() == null) so.setSortType("02");
        if ("01".equals(so.getSortType())) {// 판매순
            gs.setSidx("ACCM_SALE_AMT");
            gs.setSord("DESC");
        } else if ("02".equals(so.getSortType())) {// 신상품순
            gs.setSidx("REG_DTTM");
            gs.setSord("DESC");
        } else if ("03".equals(so.getSortType())) {// 낮은가격순
            gs.setSidx("SALE_PRICE");
            gs.setSord("ASC");
        } else if ("04".equals(so.getSortType())) {// 높은가격순
            gs.setSidx("SALE_PRICE");
            gs.setSord("DESC");
        } else if ("05".equals(so.getSortType())) {// 상품평 많은순
            gs.setSidx("ACCM_GOODSLETT_CNT");
            gs.setSord("DESC");
        }

        if (so.getRows() < 20) so.setRows(20); // 최소 20개씨 노출
        gs.setRows(so.getRows());
        
        // 필터 조건
        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(gs);
        mav.addObject("resultListModel", result);
        
        mav.addObject("so", so);
        
        return mav;
    }

    @RequestMapping(value = "/category-view")
    public ModelAndView viewCategory(@RequestParam(name = "category", required = false) String category)
            throws Exception {
        log.debug("main");
        ModelAndView mav = null;

        switch (category) {
            case "2":
                mav = SiteUtil.getSkinView("/category/category_list02");
                break;
            case "3":
                mav = SiteUtil.getSkinView("/category/category_list03");
                break;
            case "4":
                mav = SiteUtil.getSkinView("/category/category_list04");
                break;
            default:
                mav = SiteUtil.getSkinView("/category/category_list01");
        }

        return mav;
    }

    @RequestMapping("/company-info")
    public ModelAndView company(@Validated TermConfigSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();
        ResultModel<TermConfigVO> vo = termConfigService.selectTermConfig(so);

        if (vo.getData() == null) {
            mav.setViewName("/company/no_data");
        } else {
            if ("01".equals(so.getSiteInfoCd())) mav.setViewName("/company/company");// 회사소개
            if ("02".equals(so.getSiteInfoCd())) mav.setViewName("/company/map");// 약도
            if ("03".equals(so.getSiteInfoCd())){
            	mav.setViewName("/company/terms");// 이용약관
            	TermConfigSO pso = new TermConfigSO();
            	pso.setSiteNo(so.getSiteNo());
            	pso.setSiteInfoCd("22"); //위치정보이용약관
            	ResultModel<TermConfigVO> pvo = termConfigService.selectTermConfig(pso);
            	mav.addObject("term_config_p", pvo);
            }
            if ("04".equals(so.getSiteInfoCd())) mav.setViewName("/company/policy");// 개인정보처리방침
            if ("21".equals(so.getSiteInfoCd())) mav.setViewName("/company/teenager");// 청소년보호방침
            if ("22".equals(so.getSiteInfoCd())) mav.setViewName("/company/locate");// 위치동의
            if ("09".equals(so.getSiteInfoCd())) mav.setViewName("/company/membership");// 멤버쉽 회원 이용약관
            if ("10".equals(so.getSiteInfoCd())) mav.setViewName("/company/onlinemall");// 온라인 몰 이용약관

        }
        mav.addObject("term_config", vo);
        return mav;
    }

    @RequestMapping("/open-pop")
    public ModelAndView openPopup(PopManageSO so) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("so", so);
        mav.setViewName("/include/openPopup");
        return mav;
    }

    @Autowired
    private RequestMappingHandlerMapping handlerMapping;
    @RequestMapping( value = "/endPoints", method = RequestMethod.GET )
    public ModelAndView getEndPointsInView( Model model ){
        ModelAndView mav = new ModelAndView("/admin/main/endPoints");
        Map<RequestMappingInfo, HandlerMethod> map = handlerMapping.getHandlerMethods();

        model.addAttribute( "map", map );
        mav.addAllObjects((Map<String, ?>) model);

        return mav;
    }
    
    @RequestMapping("/appDownload")
    public ModelAndView appDownload() throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/main/app_download");
        return mav;
    }
    
    @RequestMapping("/qrcode")
    public ModelAndView qrcode(PopManageSO so) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/main/qrcode");
        mav.addObject("so", so);
        return mav;
    }

    @RequestMapping("/terms-apply-pop")
    public ModelAndView termsApplyPop(TermConfigSO so) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();
        mav.setViewName("/company/terms_apply");
        //동의 여부 체크
        mav.addObject("applyCnt", termConfigService.selectTermApplyInfo(so));

        TermConfigSO tso = new TermConfigSO();
        tso.setSiteNo(so.getSiteNo()); // 쇼핑몰 이용약관
        tso.setSiteInfoCd("03"); // 쇼핑몰 이용약관
        mav.addObject("term_03", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("05"); // 개인정보수집이용동의_회원
        mav.addObject("term_05", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("06"); // 개인정보수집이용동의_비회원
        mav.addObject("term_06", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("07"); // 개인정보제3자제공동의
        mav.addObject("term_07", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("08"); // 개인정보취급위탁동의
        mav.addObject("term_08", termConfigService.selectTermConfig(tso));


        tso.setSiteInfoCd("04"); // 개인정보처리방침 *
        mav.addObject("term_04", termConfigService.selectTermConfig(tso));

        tso.setSiteInfoCd("22"); // 위치정보 이용약관
        mav.addObject("term_22", termConfigService.selectTermConfig(tso));

        tso.setSiteInfoCd("21"); // 청소년 보호정책
        mav.addObject("term_21", termConfigService.selectTermConfig(tso));

        tso.setSiteInfoCd("09"); // 멤버쉽 회원 이용약관
        mav.addObject("term_09", termConfigService.selectTermConfig(tso));

        tso.setSiteInfoCd("10"); // 온라인 몰 이용약관
        mav.addObject("term_10", termConfigService.selectTermConfig(tso));
        



        return mav;
    }

    @RequestMapping("/member-terms-apply")
    public @ResponseBody ResultModel<MemberManagePO> updateTermsApply(MemberManagePO po) throws Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();

        if(SiteUtil.isMobile()) {
            po.setDeviceType("MOBILE");
        }else{
            po.setDeviceType("PC");
        }

        frontMemberService.updateTermsApply(po);
        result.setSuccess(true);
        result.setMessage("정상적으로 처리되었습니다.");
        return result;
    }


     /**
     * <pre>
     * 작성일 : 2018. 7. 10.
     * 작성자 : khy
     * 설명   : 약관동의 사인 정보 조회
     * param :
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/terms-apply-signinfo")
    public @ResponseBody Map<String, Object> termsApplySignInfo(TermConfigSO so) throws Exception {
    	Map<String, Object> result = new HashMap<>();
        result.put("signImg", termConfigService.selectTermApplySingInfo(so).getSign());
        return result;
    }
}