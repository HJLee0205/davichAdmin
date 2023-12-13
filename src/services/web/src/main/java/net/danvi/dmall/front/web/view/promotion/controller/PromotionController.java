package net.danvi.dmall.front.web.view.promotion.controller;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.view.View;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.BannerSO;
import net.danvi.dmall.biz.app.design.model.BannerVO;
import net.danvi.dmall.biz.app.design.service.BannerManageService;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 기획전 조회 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/promotion")
public class PromotionController {

    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Resource(name = "bannerManageService")
    private BannerManageService bannerManageService;

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    /**
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명   : 기획전 목록 조회 페이지
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * </pre>
     */
    @RequestMapping(value = "/promotion-list")
    public ModelAndView promotionList(@Validated ExhibitionSO so, BindingResult bindingResult) throws Exception {
    	ModelAndView mv = SiteUtil.getSkinView("/promotion/promotion_list");


    	// 방문예약 매장 총 개수 조회
        Map<String, Object> param = new HashMap<>();
    	Map<String, Object> result = new HashMap<>();
    	result = InterfaceUtil.send("IF_RSV_006", param);
        if ("1".equals(result.get("result"))) {
        mv.addObject("storeTotCnt", result.get("totalCnt"));

        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명   : 기획전 목록 조회 페이지(ajax)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * </pre>
     */
    @RequestMapping("/promotion-list-ajax")
    public ModelAndView ajaxPromotionList(@Validated ExhibitionSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/promotion/promotion_list_tab");
        mv.addObject("so", so);
        mv.addObject("resultListModel", exhibitionService.selectExhibitionListPaging(so));
        return mv;
    }

    // 2016.08.31 - 모바일
    // 기획전 리스트 페이징 ajax
    @RequestMapping("/ajax-promotion-paging")
    public ModelAndView ajaxPromotionPage(@Validated ExhibitionSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/promotion/promotion_list_page");
        mv.addObject("so", so);
        mv.addObject("resultListModel", exhibitionService.selectExhibitionListPaging(so));
        return mv;
    }


    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 단건 기획전 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    /*@RequestMapping(value = "/promotion-detail")
    public ModelAndView detailPromotion(@Validated ExhibitionSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/promotion/promotion_view");
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        mv.addObject("so", so);
        // 기획전 설정정보조회
        ResultModel<ExhibitionVO> resultModel = exhibitionService.selectExhibitionInfo(so);
        ExhibitionVO resultVo = resultModel.getData();
        resultModel.setData(restoreClearXSS(resultVo));
        mv.addObject("resultModel", resultModel);

        // 기획전 상품 조회
        // so.setPrmtCndtCd(resultModel.getData().getPrmtCndtCd());
        so.setRows(40);
        mv.addObject("resultListModel", exhibitionService.selectExhibitionGoodsList(so));

        // 진행중인 기획전
        so.setPrmtStatusCd("02");
        ResultListModel<ExhibitionVO> exhibition_list = exhibitionService.selectOtherExhibitionList(so);
        mv.addObject("exhibition_list", exhibition_list);

        return mv;
    }*/
    /**
     * <pre>
     * 작성일 : 2018. 7. 3.
     * 작성자 : 이현진
     * 설명   : 기획전 전시존 및 상품정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 3. 이현진- 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/promotion-detail")
    public ModelAndView detailPromotion(@Validated ExhibitionSO so, BindingResult bindingResult) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
    	ModelAndView mv = SiteUtil.getSkinView("/promotion/promotion_view");

    	if(!SiteUtil.isMobile()) {
            String uri = request.getRequestURI();
            if (uri.contains("/m/")) {
                if (so.getPrmtNo() == 153) {
                    mv.setViewName("redirect:http://www.davichmarket.com/front/promotion/promotion-detail?prmtNo=153");
                    return mv;
                }
            }
        }
    	// 필수 파라메터 확인
    	if (bindingResult.hasErrors()) {
    		log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
    		return mv;
    	}
    	mv.addObject("so", so);

        //임시처리 65번 기획전 종료후 삭제필요...
    	if(so.getPrmtNo()>0 && so.getPrmtNo()==60){
    	    so.setPrmtNo(65);
    	}
    	// 기획전 설정정보조회
        ResultModel<ExhibitionVO> resultModel = exhibitionService.selectExhibitionInfo(so);
        ExhibitionVO resultVo = resultModel.getData();
        resultModel.setData(restoreClearXSS(resultVo));
        mv.addObject("resultModel", resultModel);

    	// 진행중인 기획전
    	so.setPrmtStatusCd("02");
    	ResultListModel<ExhibitionVO> exhibition_list = exhibitionService.selectOtherExhibitionList(so);
    	mv.addObject("exhibition_list", exhibition_list);
    	
    	//전시존영역에 따른 상품리스트
    	 // 01-1.전시카테고리 리스트 조회
    	ExhibitionSO edm = new ExhibitionSO();
    	edm.setSiteNo(so.getSiteNo());
    	edm.setPrmtNo(so.getPrmtNo());
    	edm.setUseYn("Y");
    	edm.setSaleYn("Y");
    	
        List<ExhibitionVO> resultListModel = exhibitionService.selectEhbDispMngList(edm);
        mv.addObject("display_list", resultListModel);

        if (so.getDisplayTypeCd() == null || "".equals(so.getDisplayTypeCd())) {
            so.setDisplayTypeCd("01");
        }

        // 01-2.전시카테고리 상품리스트 조회
        for (int i = 0; i < resultListModel.size(); i++) {
        	edm.setPrmtDispzoneNo(resultListModel.get(i).getPrmtDispzoneNo());
            List<GoodsVO> prmtDisplayGoodsList = exhibitionService.selectEhbDispGoodsList(edm);
            if (prmtDisplayGoodsList != null && prmtDisplayGoodsList.size() > 0) {
            for(int j = 0; j < prmtDisplayGoodsList.size(); j++) {
                if(prmtDisplayGoodsList.get(j).getPrmtDispzoneNo().equals(resultListModel.get(i).getPrmtDispzoneNo())){
                	prmtDisplayGoodsList.get(j).setPrmtDispDispTypeCd(resultListModel.get(i).getPrmtDispDispTypeCd());
                    mv.addObject("promotion_display_goods_" + edm.getPrmtDispzoneNo(), prmtDisplayGoodsList);
                }

            }
            }
        }

        if (SessionDetailHelper.getDetails().isLogin()) {
            // 08.회원기본정보 조회
            long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
            MemberManageSO memberManageSO = new MemberManageSO();
            memberManageSO.setMemberNo(memberNo);
            memberManageSO.setSiteNo(so.getSiteNo());
            ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(memberManageSO);

            mv.addObject("member_info", member_info); // 회원정보
        }

        // 방문예약 매장 총 개수 조회
        Map<String, Object> param = new HashMap<>();
    	Map<String, Object> result = new HashMap<>();
    	result = InterfaceUtil.send("IF_RSV_006", param);
        if ("1".equals(result.get("result"))) {
            mv.addObject("storeTotCnt", result.get("totalCnt"));

        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }
    	
    	
    	return mv;
    }

    //2016.09.07 - 모바일
    //기획전 상품 리스트 페이징 ajax
    @RequestMapping(value = "/ajax-promotion")
    public ModelAndView ajaxPromotion(@Validated ExhibitionSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/promotion/ajaxPromotion_view");
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        mv.addObject("so", so);
        // 기획전 설정정보조회
        ResultModel<ExhibitionVO> resultModel = exhibitionService.selectExhibitionInfo(so);
        mv.addObject("resultModel", resultModel);

        // 기획전 상품 조회
        // so.setPrmtCndtCd(resultModel.getData().getPrmtCndtCd());
        //so.setRows(10);
        mv.addObject("resultListModel", exhibitionService.selectExhibitionGoodsList(so));

        // 진행중인 기획전
        so.setPrmtStatusCd("02");
        ResultListModel<ExhibitionVO> exhibition_list = exhibitionService.selectOtherExhibitionList(so);
        mv.addObject("exhibition_list", exhibition_list);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 왼쪽 날개 영역 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/leftwing-info")
    public ModelAndView selectLeftWing(@Validated BannerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/outline/banner");
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        String skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();

        log.debug(">>>>>>>>> skinNo" + skinNo);
        so.setSkinNo(skinNo);
        so.setBannerMenuCd("CM");// 공통
        so.setBannerAreaCd("LWF");// 왼쪽날개배너
        so.setDispYn("Y");
        so.setTodayYn("Y");
        List<BannerVO> list = bannerManageService.selectBannerList(so);
        mav.addObject("left_wing_banner", list);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 오른쪽 날개 영역 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/rightwing-info")
    public ModelAndView selectRightDispList() throws Exception {
        ModelAndView mv = new ModelAndView("jsp경로");
        // 필수 파라메터 확인

        mv.addObject("resultListModel", "");
        return mv;
    }

    public ExhibitionVO restoreClearXSS(ExhibitionVO vo) {
        if (vo.getPrmtContentHtml() != null && !"".equals(vo.getPrmtContentHtml())) {
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().trim());
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().replaceAll("&#35;", "#"));
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().replaceAll("&lt;", "<"));
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().replaceAll("&gt;", ">"));
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().replaceAll("&#34;", "\\\""));
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().replaceAll("&#39;", "'"));
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().replaceAll("&#40;", "\\("));
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().replaceAll("&#41;", "\\)"));
            vo.setPrmtContentHtml(vo.getPrmtContentHtml().replaceAll("&quot;", "\""));
        }
        return vo;
    }
}
