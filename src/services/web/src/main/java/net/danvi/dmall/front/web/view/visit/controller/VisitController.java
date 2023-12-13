package net.danvi.dmall.front.web.view.visit.controller;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.app.visit.model.VisitSO;
import net.danvi.dmall.biz.app.visit.model.VisitVO;
import net.danvi.dmall.biz.app.visit.service.VisitRsvService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import net.danvi.dmall.front.web.config.view.View;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;
import java.util.*;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.visit.controller
 * - 파일명        : VisitController.java
 * - 작성일        : 2018. 7.
 * - 작성자        : khy
 * - 설명          : 방문예약
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/visit")
public class VisitController {

    @Resource(name = "visitRsvService")
    private VisitRsvService visitRsvService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Resource(name = "couponService")
    private CouponService couponService;

    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : mypage - 방문예약목록 page
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/visit-list")
    public ModelAndView visitList(@Validated VisitSO so, BindingResult bindingResult) {
        ModelAndView mv = SiteUtil.getSkinView("/mypage/visit_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }

        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        //방문예약 목록 조회
        ResultListModel<VisitVO> visit_list = visitRsvService.selectVisitList(so);

        mv.addObject("so", so);
        mv.addObject("visit_list", visit_list);
        mv.addObject("leftMenu", "visit_list");

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : mypage - 방문예약상세 page
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/visit-detail")
    public ModelAndView visitDetail(@Validated VisitSO so, BindingResult bindingResult) {
        ModelAndView mv = SiteUtil.getSkinView("/mypage/visit_detail");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }
        // 방문예약 정보
        VisitVO visitVO = visitRsvService.selectVisitDtl(so);
        // 방문예약 상세 (상품 목록)
        List<VisitVO> visitDtlList = visitRsvService.selectVisitDtlList(so);
        // 방문에약 상세 (옵션 목록)
        List<VisitVO> optionList = visitRsvService.selectVisitAddOptionList(so);
        // 주문에서 방문예약 여부
        Integer cnt = visitRsvService.selectExistOrd(so);

        OrderInfoVO vo = new OrderInfoVO();
        OrderVO orderVO = new OrderVO();

        // 주문에서 방문예약 했을경우 주문상세정보를 조회
        if (cnt.intValue() > 0) {
            if (visitDtlList != null) {
                vo.setOrdNo(visitDtlList.get(0).getOrdNo());
                vo.setSiteGbn("front");
                orderVO = orderService.selectOrdDtl(vo);
            }
        }

        //텐션 사전예약 여부
        if(StringUtil.trim(visitVO.getVisitPurposeNm()).indexOf("텐션 사전 예약")>-1){
            mv.addObject("teanseonMiniYn", "Y");
        }else{
            mv.addObject("teanseonMiniYn", "N");
        }

        // response정보
        visitVO.setOrdCnt(cnt);

        mv.addObject("visitVO", visitVO);
        mv.addObject("visitDtlList", visitDtlList);
        mv.addObject("optionList", optionList);
        mv.addObject("order_info", orderVO);
        mv.addObject("so", so);
        mv.addObject("leftMenu", "visit_list");



        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : mypage - 방문예약 신청 page
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/visit-welcome")
    public ModelAndView viewVisitWelcome(HttpServletRequest request) {
        ModelAndView mv = SiteUtil.getSkinView("/mypage/visit_welcome");
        return mv;
    }


    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : mypage - 방문예약 신청 상세 page
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */

    @RequestMapping("/visit-book")
    public ModelAndView visitBook(
            @Validated OrderVO vo,
            BindingResult bindingResult, HttpServletRequest request
    ) throws Exception {

        ModelAndView mv = SiteUtil.getSkinView("/mypage/visit_book");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 로그인여부 체크
        if ((vo.getMemberYn()!=null && vo.getMemberYn().equals("Y")) && !SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }

        // 주문데이터 확인
        if (vo.getItemArr() != null && vo.getItemArr().length > 0) {
        	ResultModel<OrderVO> orderInfo = visitRsvService.selectVisitGoods(vo, request);

        	if (!orderInfo.isSuccess()) {
                ModelAndView mavErr = new ModelAndView("error/notice");
                mavErr.addObject("exMsg", orderInfo.getMessage());
                return mavErr;
        	}

            mv.addObject("orderInfo", orderInfo); // 주문정보
        }

        MemberManageSO so = new MemberManageSO();

        if((vo.getMemberYn()!=null && vo.getMemberYn().equals("Y")) || SessionDetailHelper.getDetails().isLogin()) {
            so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
            so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            // 01.회원기본정보 search
            ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(so);
            mv.addObject("member_info", member_info);
        }else{
            so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
            so.setMemberNo(999L);
        }

        List<CmnCdDtlVO> codeListModel = ServiceUtil.listCode("STORE_AREA_CD");


        mv.addObject("memberYn", vo.getMemberYn());
        mv.addObject("nomobile", vo.getNomobile());
        mv.addObject("nomemberNm", vo.getNomemberNm());
        mv.addObject("codeListModel", codeListModel);
        mv.addObject("visionChk", vo.getVisionChk());
        mv.addObject("rsvOnlyYn", vo.getRsvOnlyYn());
        mv.addObject("leftMenu", "visit_list");
        mv.addObject("isHa",vo.getIsHa());

        mv.addObject("teanseonMiniYn", vo.getTeanseonMiniYn());
        mv.addObject("vegemilYn", vo.getVegemilYn());
        mv.addObject("eyeluvYn", vo.getEyeluvYn());
        mv.addObject("trevuesYn", vo.getTrevuesYn());
        mv.addObject("teanseanSampleYn", vo.getTeanseanSampleYn());
        mv.addObject("teanseonNewYn", vo.getTeanseonNewYn());
        mv.addObject("storeNm", vo.getStoreNm());
        mv.addObject("storeCode", vo.getStoreCode());

        Cookie cookieCh = WebUtils.getCookie(request, "from_channel");       // 유입경로
        String ch = cookieCh != null? cookieCh.getValue(): "";
        mv.addObject("ch", ch.trim());
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : mypage - 방문예약 완료 page
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/visit-complete")
    public ModelAndView viewVisitComplet(String rsvNo, HttpServletRequest request) throws Exception{
        ModelAndView mv = SiteUtil.getSkinView("/mypage/visit_complete");
        String memberYn="";
        String nomemberNm ="";
        if(request.getParameter("memberYn")!=null && !request.getParameter("memberYn").equals("")){
            memberYn = request.getParameter("memberYn");
        }else{
            if (SessionDetailHelper.getDetails().isLogin()) {
                memberYn = "Y";
            }
        }

        if(request.getParameter("nomemberNm")!=null && !request.getParameter("nomemberNm").equals("")){
            nomemberNm = request.getParameter("nomemberNm");
        }

        // 로그인여부 체크
        if (memberYn.equals("Y") && !SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }

        VisitSO so = new VisitSO();
        so.setRsvNo(rsvNo);

        VisitVO vo = visitRsvService.selectVisitDtl(so);
        String cpIssueNoArr = "";
        List<CouponVO> cpVoList = new ArrayList<>();
        //발급 쿠폰정보 세팅...
        if(request.getParameter("cpIssueNoArr")!=null && !request.getParameter("cpIssueNoArr").equals(""))
        {
            cpIssueNoArr = request.getParameter("cpIssueNoArr");
            String [] cpIssueNo = cpIssueNoArr.split("\\|");
            if(cpIssueNo!=null && cpIssueNo.length>0) {
                cpVoList = couponService.selectRsvCouponIssue(cpIssueNo);
            }
        }

        mv.addObject("visitVO", vo);
        mv.addObject("leftMenu", "visit_list");
        mv.addObject("cpVoList", cpVoList);

        mv.addObject("memberYn", memberYn);
        mv.addObject("nomemberNm", nomemberNm);

        return mv;
    }


    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : 방문예약 취소 - interface
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/rsv-cancel-update")
    public @ResponseBody ResultModel<VisitVO> rsvCancelUpdate(@Validated VisitSO so, BindingResult bindingResult) throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<VisitVO> result = new ResultModel<>();

        visitRsvService.updateRsvCancel(so);
        result.setSuccess(true);

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : 공통코드 - 시/도 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/change-sido")
    public @ResponseBody List<CmnCdDtlVO> sidoChange(@Validated VisitSO so, BindingResult bindingResult) {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	return ServiceUtil.listCode("STORE_AREA_DTL_CD", so.getDef1(), null, null, null, null);
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. 13.
     * 작성자 : khy
     * 설명   : 방문예약 접수 등록
     * -------------------------------------------------------------------------
     * 일반예약
     * 	- 예약등록 - interface 호출
     * 사전예약
     *  - 사전예약등록 -  interface 호출
     * </pre>
     */
    @RequestMapping("/visit-rsv-regist")
    public String visitRsvRegist(@Validated OrderPO po, BindingResult bindingResult,
    		RedirectAttributes redirectAttr, HttpServletRequest request)  throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<OrderPO> result = visitRsvService.insertVisit(po);

        if (!result.isSuccess()) {
            log.debug("=== result.getMessage() : {}", result.getMessage());
            redirectAttr.addFlashAttribute("exMsg", result.getMessage());
            return View.redirect("/front/common/error");
        }

        String[] cpIssueNoArr = null;
        String cpIssueNoString = "";
        if( po.getCpIssueResult()!=null && po.getCpIssueResult().getCpIssueNoArr()!=null) {
            cpIssueNoArr = po.getCpIssueResult().getCpIssueNoArr();
            for (int i = 0; i < cpIssueNoArr.length; i++) {
                if (i > 0) {
                    cpIssueNoString += "|";
                }
                cpIssueNoString += cpIssueNoArr[i];
            }
        }

        String noMemberNm ="";
        if(po.getNomemberNm()!=null && !po.getNomemberNm().equals("")) {
            noMemberNm = URLEncoder.encode(po.getNomemberNm(), "UTF-8");
        }

        return View.redirect("/front/visit/visit-complete?rsvNo=" + po.getRsvNo() + "&cpIssueNoArr=" + cpIssueNoString + "&memberYn=" + po.getMemberYn() + "&nomemberNm=" + noMemberNm);
    }



    /**
     * <pre>
     * 작성일 : 2018. 7. 10.
     * 작성자 : khy
     * 설명   : 혼잡도 시간표 조회 - interface 호출
     * param : 매장코드, 요일
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/time-table")
    public @ResponseBody Map<String, Object> interfaceTimeTable(@Validated VisitSO so, BindingResult bindingResult)
            throws Exception {
    	Map<String, Object> result = new HashMap<>();

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	//혼잡도 시간표 조회
    	Map<String, Object> param = new HashMap<>();
    	param.put("strCode", so.getStoreCode());
    	param.put("dow", so.getWeek());

    	result = InterfaceUtil.send("IF_RSV_001", param);
        if ("1".equals(result.get("result"))) {
        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }

    	// 선택일자의 매장 휴일 여부조회
    	if (so.getStrDate() != null &&  !"".equals(so.getStrDate())) {
    		String strDate = so.getStrDate().replaceAll("-", "");

	    	Map<String, Object> param2 = new HashMap<>();
	    	param2.put("strCode", so.getStoreCode());
	    	param2.put("targetYM", strDate.substring(0,6));
	    	param2.put("targetD", String.valueOf(Integer.parseInt(strDate.substring(6))));

	    	Map<String, Object> holi = InterfaceUtil.send("IF_RSV_013", param2);

            if ("1".equals(holi.get("result"))) {
                result.put("holidayList", holi.get("holidayList"));
            }else{
                throw new Exception(String.valueOf(holi.get("message")));
            }
    	}

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. 10.
     * 작성자 : khy
     * 설명   : 매장 목록조회 - interface 호출
     * param : 시/도코드, 구/군코드
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/store-list")
    public @ResponseBody Map<String, Object> interfaceStoreList(@Validated VisitSO so, BindingResult bindingResult)
            throws Exception {
    	Map<String, Object> result = new HashMap<>();

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	String sidoCode = so.getSidoCode();

    	if (so.getSidoName() != null && !"".equals(so.getSidoName())) {
    		sidoCode = visitRsvService.selectSidoCode(so);
    	}

    	Map<String, Object> param = new HashMap<>();
    	param.put("sidoCode", sidoCode);
    	param.put("gugunCode", so.getGugunCode());
    	param.put("hearingAidYn", so.getHearingAidYn());
    	param.put("erpItmCode", so.getErpItmCode());
    	param.put("strName", so.getStrName());
    	param.put("cntPerPage", 100);

    	result = InterfaceUtil.send("IF_RSV_006", param);
        if ("1".equals(result.get("result"))) {
        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }

        return result;
    }



    /**
     * <pre>
     * 작성일 : 2018. 7. 10.
     * 작성자 : khy
     * 설명   : 매장 상세정보 - interface 호출
     * param : 시/도코드, 구/군코드
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/store-info")
    public @ResponseBody Map<String, Object> interfaceStoreInfo(@Validated VisitSO so, BindingResult bindingResult)
            throws Exception {
    	Map<String, Object> result = new HashMap<>();

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        String storeNo = so.getStoreCode();
        if (storeNo == null || "".equals(storeNo)) {

            MemberManageSO mso = new MemberManageSO();
            mso.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            mso.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());

            // 01.회원기본정보 search
            ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(mso);

            if (member_info.getData() != null ) {
            	storeNo = member_info.getData().getCustomStoreNo();
            }
        }

        String erpItmCode = "";
    	String newErpItmCode = "";
    	if(so.getErpItmCode() != null && so.getErpItmCode() != "") {
    		erpItmCode = so.getErpItmCode();

    		String [] arrErpItmCode = erpItmCode.split(",");
    		for(int i=0;i<arrErpItmCode.length;i++) {
    			if(newErpItmCode != "") newErpItmCode += ",";
    			newErpItmCode += "'" + arrErpItmCode[i] + "'"; 
    		}
    		so.setErpItmCode(newErpItmCode);
    	}
    	
        if (storeNo != null && !"".equals(storeNo)) {
	    	Map<String, Object> param = new HashMap<>();
	    	param.put("strCode", storeNo);
	    	param.put("erpItmCode", so.getErpItmCode());

	    	result = InterfaceUtil.send("IF_RSV_007", param);

	        if ("1".equals(result.get("result"))) {
	        	List<VisitVO> affiliateList = visitRsvService.selectAffiliateList(so);
	        	result.put("affiliateList", affiliateList);
	        }else{
	            throw new Exception(String.valueOf(result.get("message")));
	        }
        }

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. 10.
     * 작성자 : khy
     * 설명   : 매장찾기팝업
     * param : 시/도코드, 구/군코드
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/store-map-pop")
    public ModelAndView storeMapPop(VisitSO so) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/include/store_map_pop");

        List<CmnCdDtlVO> codeListModel = ServiceUtil.listCode("STORE_AREA_CD");
        mav.addObject("codeListModel", codeListModel);
        mav.addObject("so", so);


        return mav;
    }



    /**
     * <pre>
     * 작성일 : 2018. 7. 10.
     * 작성자 : khy
     * 설명   : 매장상세정보
     * param : 매장코드
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/store-detail-pop")
    public ModelAndView storeDetailpPop(VisitSO so) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/store_detail_pop");

        mav.addObject("so", so);
        return mav;
    }


    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : 단골매장 저장
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/custom-store-update")
    public @ResponseBody ResultModel<VisitVO> customStoreUpdate(@Validated VisitVO vo, BindingResult bindingResult) throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<VisitVO> result = new ResultModel<>();

        MemberManagePO po = new MemberManagePO();
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        po.setStoreNo(vo.getStoreNo());
        po.setStoreNm(vo.getStoreNm());

        frontMemberService.updateCustomStore(po);
        result.setSuccess(true);

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : 단골매장 저장
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/custom-store-info")
    public @ResponseBody ResultModel<MemberManageVO> customStoreInfo(@Validated VisitVO vo, BindingResult bindingResult) throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        MemberManageSO so = new MemberManageSO();
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());

        // 01.회원기본정보 search
        ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(so);

        return member_info;
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. 31.
     * 작성자 : khy
     * 설명   : 동일 예약시간 체크
     * param :
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/exists-rsv-time")
    public @ResponseBody Map<String, String> existsRsvTime(@Validated VisitVO vo, BindingResult bindingResult)
            throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	vo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	int cnt = visitRsvService.existsRsvTime(vo);
    	Map<String, String> result = new HashMap<>();
    	result.put("cnt", String.valueOf(cnt));

        return result;
    }



    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : mypage - 방문예약 신청 page
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/my-visit-welcome")
    public ModelAndView viewMyVisitWelcome(HttpServletRequest request) {
        ModelAndView mv = SiteUtil.getSkinView("/mypage/my_visit_welcome");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }

        mv.addObject("leftMenu", "visit_list");
        return mv;
    }



    /**
     * <pre>
     * 작성일 : 2018. 8. 1.
     * 작성자 : khy
     * 설명   : 매장별,월별 휴일 조회 - interface 호출
     * param : 매장코드, 년월
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/store-holiday")
    public @ResponseBody Map<String, Object> interfaceStoreHolidayList(@Validated VisitSO so, BindingResult bindingResult)
            throws Exception {
    	Map<String, Object> result = new HashMap<>();

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	Map<String, Object> param = new HashMap<>();
    	param.put("strCode", so.getStoreCode());
    	param.put("targetYM", so.getTargetYM());

    	result = InterfaceUtil.send("IF_RSV_013", param);
        if ("1".equals(result.get("result"))) {
        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2018. 9. 17
     * 작성자 : khy
     * 설명   : 방문예약 체크 (기존 방문예약이 있는지 체크)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/visit-exist-book")
    public @ResponseBody List<VisitVO> selectExistVisitList(@Validated VisitSO so, BindingResult bindingResult) throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	List<VisitVO> result = visitRsvService.selectExistVisitList(so);

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2018. 9. 17.
     * 작성자 : khy
     * 설명   : 방문예약 리스트
     * param :
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/visit-book-pop")
    public ModelAndView visitBookPop(VisitSO so) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/visit_book_pop");

    	so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	List<VisitVO> result = visitRsvService.selectExistVisitList(so);

        mav.addObject("visit_list", result);
        mav.addObject("so", so);
        return mav;
    }




    /**
     * <pre>
     * 작성일 : 2017. 7.
     * 작성자 : khy
     * 설명   : 기존 방문예약에 예약추가
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 7. khy - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/add-visit-book")
    public @ResponseBody ResultModel<VisitVO> addVisitBook(@Validated VisitSO so, BindingResult bindingResult) throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<VisitVO> result = new ResultModel<>();

    	so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        visitRsvService.addVisitBook(so);
        result.setSuccess(true);

        return result;
    }


     // 비회원 방문예약 여부 조회
    @RequestMapping("/nomember-rsv-check")
    public @ResponseBody ResultModel<OrderVO> selectNonMemberOrder(VisitSO so) {
        ResultModel<OrderVO> result = new ResultModel<>();
        result.setSuccess(visitRsvService.selectNonMemberRsv(so));
        return result;
    }

    // 비회원 방문예약 조회
    @RequestMapping(value = "/nomember-rsv-list")
    public ModelAndView nonmemberOrderList(VisitSO so) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/nonmember/nonmember_rsv_list");

        if (so.getRsvMobile() == null || "".equals(so.getRsvMobile())) {
            ModelAndView mavErr = new ModelAndView("error/notice");
            mavErr.addObject("exMsg", MessageUtil.getMessage("front.web.common.wrongapproach"));
            return mavErr;
        }


        //방문예약 목록 조회
        ResultListModel<VisitVO> visit_list = visitRsvService.selectVisitList(so);

        mv.addObject("so", so);
        mv.addObject("visit_list", visit_list);
        mv.addObject("leftMenu", "visit_list");
        return mv;
    }

    // 비회원 방문예약 조회
    @RequestMapping(value = "/nomember-rsv-detail")
    public ModelAndView nonmerberOrderDetail(VisitSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/nonmember/nonmember_rsv_detail");
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        // 방문예약 정보
        VisitVO visitVO = visitRsvService.selectVisitDtl(so);
        // 방문예약 상세 (상품 목록)
        List<VisitVO> visitDtlList = visitRsvService.selectVisitDtlList(so);
        // 방문에약 상세 (옵션 목록)
        List<VisitVO> optionList = visitRsvService.selectVisitAddOptionList(so);
        // 주문에서 방문예약 여부
        Integer cnt = visitRsvService.selectExistOrd(so);

        OrderInfoVO vo = new OrderInfoVO();
        OrderVO orderVO = new OrderVO();

        // 주문에서 방문예약 했을경우 주문상세정보를 조회
        if (cnt.intValue() > 0) {
            if (visitDtlList != null) {
                vo.setOrdNo(visitDtlList.get(0).getOrdNo());
                vo.setSiteGbn("front");
                orderVO = orderService.selectOrdDtl(vo);
            }
        }

        //텐션 사전예약 여부
        if(StringUtil.trim(visitVO.getVisitPurposeNm()).indexOf("텐션 사전 예약")>-1){
            mv.addObject("teanseonMiniYn", "Y");
        }else{
            mv.addObject("teanseonMiniYn", "N");
        }


        // response정보
        visitVO.setOrdCnt(cnt);

        mv.addObject("visitVO", visitVO);
        mv.addObject("visitDtlList", visitDtlList);
        mv.addObject("optionList", optionList);
        mv.addObject("order_info", orderVO);
        mv.addObject("so", so);
        mv.addObject("leftMenu", "visit_list");
        return mv;
    }


    /**
     * <pre>
     * 작성일 : 2019. 6. 10.
     * 작성자 : dong
     * 설명   : 당첨자확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 10. hskim - 최초생성
     * </pre>
     *
     * @param memberNm
     * @param mobile
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/winner-chk")
    public @ResponseBody ResultModel<VisitVO> winnerChk(String memberNm, String mobile) throws Exception {

        ResultModel<VisitVO> result = new ResultModel<>();

        Map<String, String> param = new HashMap<>();
        param.put("memberNm", memberNm);
        param.put("mobile", mobile);

        int rsvCnt = visitRsvService.winnerChk(param);
        if(rsvCnt < 1) {
        	result.setSuccess(false);
        }else {
        	result.setSuccess(true);
        }

        return result;
    }

}