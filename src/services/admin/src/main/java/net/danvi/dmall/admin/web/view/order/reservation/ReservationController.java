package net.danvi.dmall.admin.web.view.order.reservation;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.order.manage.model.OrderExcelVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.reservation.model.ReservationExcelVO;
import net.danvi.dmall.biz.app.order.reservation.model.ReservationSO;
import net.danvi.dmall.biz.app.order.reservation.model.ReservationVO;
import net.danvi.dmall.biz.app.order.reservation.service.RsvService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.WebUtils;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.reservation.controller
 * - 파일명        : ReservationController.java
 * - 작성일        : 2018. 7.
 * - 작성자        : khy
 * - 설명          : 방문예약
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/order/reservation")
public class ReservationController {

    @Resource(name = "rsvService")
    private RsvService rsvService;

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
    @RequestMapping("/reservation-info")
    public ModelAndView reservationList(ReservationSO so) {
        ModelAndView mv = new ModelAndView("/admin/order/reservation/viewRsvListPaging");
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        List<CmnCdDtlVO> codeOn = ServiceUtil.listCode("ORD_DTL_STATUS_CD", null, "ON", null, null, null);
        List<CmnCdDtlVO> codeOff = ServiceUtil.listCode("ORD_DTL_STATUS_CD", null, "OFF", null, null, null);

        mv.addObject("codeOnList", codeOn);
        mv.addObject("codeOffList", codeOff);
        mv.addObject("paymentWayCdList", ServiceUtil.listCode("PAYMENT_WAY_CD", "SEARCH", null, null, null, null));
        mv.addObject("ordMediaCdList", ServiceUtil.listCode("ORD_MEDIA_CD", null, null, null, null, null));
        mv.addObject("saleChannelCdList", ServiceUtil.listCode("SALE_CHANNEL_CD", null, null, null, null, null));
        mv.addObject("siteNo", sessionInfo.getSiteNo());
        mv.addObject("so", so);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2022. 11. 08.
     * 작성자 : slims
     * 설명   : 사은품 관리 리스트 화면에서 선택한 조건에 해당하는 사은품 관련 정보를 취득하여 JSON 형태로 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 11. 08. slims - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/reservation-list")
    public @ResponseBody ResultListModel<ReservationVO> selectReservationListPaging(ReservationSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        log.info("param SiteNo = " + sessionInfo.getSiteNo());
        so.setSiteNo(sessionInfo.getSiteNo());
        log.info("param so = " + so);
        ResultListModel<ReservationVO> reservation_list = rsvService.selectReservationList(so);
        return reservation_list;
    }

    /**
     * <pre>
     * 작성일 : 2023. 7. 3.
     * 작성자 : slims
     * 설명   : 선택된 예약 목록을 Excel파일 형태로 다운로드 하기위한 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 7. 3. slims - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/reservation-excel-download")
    public String viewRsvListExcel(ReservationSO so, Model model) {
        log.info("===================================================================");
        log.info("Start : " + "선택된 예약 검색 조건을 Excel파일 형태로 다운로드 하기위한 화면");
        log.info("===================================================================");

        // 엑셀로 출력할 데이터 조회
        List<ReservationExcelVO> resultList = rsvService.selectReservationExcelList(so);
        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "예약번호", "상태", "예약취소여부", "예약자명", "예약자아이디", "예약자연락처",
                "상품명", "상품코드", "옵션", "예약수량", "판매자", "방문자", "판매가"};
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rsvNo", "visitStatusNm", "cancelYn", "memberNm", "loginId", "mobile",
                "goodsNm", "goodsNo", "itemNm", "ordQtt", "sellerNm", "noMemberNm", "saleAmt" };
        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("예약 목록", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "Reservationlist_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
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
    @RequestMapping("/reservation-detail")
    public ModelAndView reservationDetail(ReservationSO so) {
        ModelAndView mv = new ModelAndView("/admin/order/reservation/viewRsvDetail");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        so.setSiteNo(sessionInfo.getSiteNo());
        log.info("so = "+so);
        // 방문예약 정보
        ReservationVO reservationVO = rsvService.selectReservationDtl(so);
        log.info("reservationVO = "+reservationVO);

        // 방문예약 상세 (상품 목록)
        List<ReservationVO> reservationDtlList = rsvService.selectReservationDtlList(so);

        // 방문에약 상세 (옵션 목록)
//        List<ReservationVO> optionList = rsvService.selectReservationAddOptionList(so);
//        log.info("optionList = "+optionList);

        // 처리로그
        List<ReservationVO> rvsHistVOList = rsvService.selectRsvHistList(so);
        // 주문에서 방문예약 여부
//        Integer cnt = 0;
//        //cnt = rsvService.selectExistOrd(so);
//        log.info("cnt = "+cnt);
//        OrderInfoVO vo = new OrderInfoVO();
//        OrderVO orderVO = new OrderVO();
//
//        // 주문에서 방문예약 했을경우 주문상세정보를 조회
//        if (cnt.intValue() > 0) {
//            if (reservationDtlList != null) {
//                vo.setOrdNo(reservationDtlList.get(0).getOrdNo());
//                //vo.setSiteGbn("front");
//                orderVO = orderService.selectOrdDtl(vo);
//            }
//        }
//        log.info("orderVO = "+orderVO);
//        //텐션 사전예약 여부
//        if(StringUtil.trim(reservationVO.getVisitPurposeNm()).indexOf("텐션 사전 예약")>-1){
//            mv.addObject("teanseonMiniYn", "Y");
//        }else{
//            mv.addObject("teanseonMiniYn", "N");
//        }
//        if(reservationDtlList!=null) {
//            for (int j = 0; j < reservationDtlList.size(); j++) {
//                if (reservationDtlList.get(j).getGoodsTypeCd() == null && reservationDtlList.get(j).getCtgName() != null) {
//                    ReservationVO reservation = reservationDtlList.get(j);
//
//                    if (reservationDtlList.get(j).getCtgName().contains("안경테")) {
//                        reservation.setGoodsTypeCd("01");
//                    } else if (reservationDtlList.get(j).getCtgName().contains("선글라스")) {
//                        reservation.setGoodsTypeCd("02");
//                    } else if (reservationDtlList.get(j).getCtgName().contains("안경렌즈")) {
//                        reservation.setGoodsTypeCd("03");
//                    } else if (reservationDtlList.get(j).getCtgName().contains("콘택트렌즈")) {
//                        reservation.setGoodsTypeCd("04");
//                    }
//                }
//            }
//        }
//        log.info("reservationDtlList = "+reservationDtlList);
        // response정보
//        reservationVO.setOrdCnt(cnt);
        log.info("rvsHistList = "+rvsHistVOList);
        mv.addObject("reservationVO", reservationVO);
        mv.addObject("reservationDtlList", reservationDtlList);
//        mv.addObject("optionList", optionList);
//        mv.addObject("order_info", orderVO);
        mv.addObject("rvsHistList", rvsHistVOList);
        //mv.addObject("so", so);
        //mv.addObject("leftMenu", "reservation_list");

        return mv;
    }

    @RequestMapping("/cancel-selected-rsv")
    public @ResponseBody ResultModel<ReservationVO> cancelSelectedRsv(ReservationSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        ResultModel<ReservationVO> result = new ResultModel<>();
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
    @RequestMapping("/reservation-welcome")
    public ModelAndView viewReservationWelcome(HttpServletRequest request) {
        ModelAndView mv = SiteUtil.getSkinView("/mypage/reservation_welcome");
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

    @RequestMapping("/reservation-book")
    public ModelAndView reservationBook(
            @Validated OrderVO vo,
            BindingResult bindingResult, HttpServletRequest request
    ) throws Exception {

        ModelAndView mv = SiteUtil.getSkinView("/mypage/reservation_book");

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
        	ResultModel<OrderVO> orderInfo = rsvService.selectReservationGoods(vo, request);

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
        mv.addObject("leftMenu", "reservation_list");
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
    @RequestMapping("/reservation-complete")
    public ModelAndView viewReservationComplet(String rsvNo, HttpServletRequest request) throws Exception{
        ModelAndView mv = SiteUtil.getSkinView("/mypage/reservation_complete");
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

        ReservationSO so = new ReservationSO();
        so.setRsvNo(rsvNo);

        ReservationVO vo = rsvService.selectReservationDtl(so);
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

        mv.addObject("reservationVO", vo);
        mv.addObject("leftMenu", "reservation_list");
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
    @RequestMapping("/rsv-info-update")
    public @ResponseBody ResultModel<ReservationVO> rsvInfoUpdate(ReservationVO so) throws Exception {

        ResultModel<ReservationVO> result = new ResultModel<>();

        try {
            rsvService.updateRsvInfo(so);
            result.setSuccess(true);
        } catch (Exception e) {
            result.setSuccess(false);
        }

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
    public @ResponseBody List<CmnCdDtlVO> sidoChange(@Validated ReservationSO so, BindingResult bindingResult) {

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
     *//*
    @RequestMapping("/reservation-rsv-regist")
    public String rsvRegist(@Validated OrderPO po, BindingResult bindingResult,
    		RedirectAttributes redirectAttr, HttpServletRequest request)  throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<OrderPO> result = rsvService.insertReservation(po);

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

        return View.redirect("/front/reservation/reservation-complete?rsvNo=" + po.getRsvNo() + "&cpIssueNoArr=" + cpIssueNoString + "&memberYn=" + po.getMemberYn() + "&nomemberNm=" + noMemberNm);
    }*/



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
    public @ResponseBody Map<String, Object> interfaceTimeTable(@Validated ReservationSO so, BindingResult bindingResult)
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
    public @ResponseBody Map<String, Object> interfaceStoreList(@Validated ReservationSO so, BindingResult bindingResult)
            throws Exception {
    	Map<String, Object> result = new HashMap<>();

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	String sidoCode = so.getSidoCode();

    	if (so.getSidoName() != null && !"".equals(so.getSidoName())) {
    		sidoCode = rsvService.selectSidoCode(so);
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
    public @ResponseBody Map<String, Object> interfaceStoreInfo(@Validated ReservationSO so, BindingResult bindingResult)
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
	        	List<ReservationVO> affiliateList = rsvService.selectAffiliateList(so);
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
    public ModelAndView storeMapPop(ReservationSO so) throws Exception {
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
    public ModelAndView storeDetailpPop(ReservationSO so) throws Exception {
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
    public @ResponseBody ResultModel<ReservationVO> customStoreUpdate(@Validated ReservationVO vo, BindingResult bindingResult) throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ReservationVO> result = new ResultModel<>();

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
    public @ResponseBody ResultModel<MemberManageVO> customStoreInfo(@Validated ReservationVO vo, BindingResult bindingResult) throws Exception {

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
    public @ResponseBody Map<String, String> existsRsvTime(@Validated ReservationVO vo, BindingResult bindingResult)
            throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	vo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	int cnt = rsvService.existsRsvTime(vo);
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
    @RequestMapping("/my-reservation-welcome")
    public ModelAndView viewMyReservationWelcome(HttpServletRequest request) {
        ModelAndView mv = SiteUtil.getSkinView("/mypage/my_reservation_welcome");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }

        mv.addObject("leftMenu", "reservation_list");
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
    public @ResponseBody Map<String, Object> interfaceStoreHolidayList(@Validated ReservationSO so, BindingResult bindingResult)
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
    @RequestMapping("/reservation-exist-book")
    public @ResponseBody List<ReservationVO> selectExistReservationList(@Validated ReservationSO so, BindingResult bindingResult) throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

    	so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	List<ReservationVO> result = rsvService.selectExistReservationList(so);

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
    @RequestMapping(value = "/reservation-book-pop")
    public ModelAndView reservationBookPop(ReservationSO so) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/reservation_book_pop");

    	so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	List<ReservationVO> result = rsvService.selectExistReservationList(so);

        mav.addObject("reservation_list", result);
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
    @RequestMapping("/add-reservation-book")
    public @ResponseBody ResultModel<ReservationVO> addReservationBook(@Validated ReservationSO so, BindingResult bindingResult) throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ReservationVO> result = new ResultModel<>();

    	so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        rsvService.addReservationBook(so);
        result.setSuccess(true);

        return result;
    }


     // 비회원 방문예약 여부 조회
    @RequestMapping("/nomember-rsv-check")
    public @ResponseBody ResultModel<OrderVO> selectNonMemberOrder(ReservationSO so) {
        ResultModel<OrderVO> result = new ResultModel<>();
        result.setSuccess(rsvService.selectNonMemberRsv(so));
        return result;
    }

    // 비회원 방문예약 조회
    @RequestMapping(value = "/nomember-rsv-list")
    public ModelAndView nonmemberOrderList(ReservationSO so) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/nonmember/nonmember_rsv_list");

        if (so.getRsvMobile() == null || "".equals(so.getRsvMobile())) {
            ModelAndView mavErr = new ModelAndView("error/notice");
            mavErr.addObject("exMsg", MessageUtil.getMessage("front.web.common.wrongapproach"));
            return mavErr;
        }


        //방문예약 목록 조회
        ResultListModel<ReservationVO> reservation_list = rsvService.selectReservationList(so);

        mv.addObject("so", so);
        mv.addObject("reservation_list", reservation_list);
        mv.addObject("leftMenu", "reservation_list");
        return mv;
    }

    // 비회원 방문예약 조회
    @RequestMapping(value = "/nomember-rsv-detail")
    public ModelAndView nonmerberOrderDetail(ReservationSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/nonmember/nonmember_rsv_detail");
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        // 방문예약 정보
        ReservationVO reservationVO = rsvService.selectReservationDtl(so);
        // 방문예약 상세 (상품 목록)
        List<ReservationVO> reservationDtlList = rsvService.selectReservationDtlList(so);
        // 방문에약 상세 (옵션 목록)
        List<ReservationVO> optionList = rsvService.selectReservationAddOptionList(so);
        // 주문에서 방문예약 여부
        Integer cnt = rsvService.selectExistOrd(so);

        OrderInfoVO vo = new OrderInfoVO();
        OrderVO orderVO = new OrderVO();

        // 주문에서 방문예약 했을경우 주문상세정보를 조회
        if (cnt.intValue() > 0) {
            if (reservationDtlList != null) {
                vo.setOrdNo(reservationDtlList.get(0).getOrdNo());
                vo.setSiteGbn("front");
                orderVO = orderService.selectOrdDtl(vo);
            }
        }

        //텐션 사전예약 여부
        if(StringUtil.trim(reservationVO.getVisitPurposeNm()).indexOf("텐션 사전 예약")>-1){
            mv.addObject("teanseonMiniYn", "Y");
        }else{
            mv.addObject("teanseonMiniYn", "N");
        }


        // response정보
        reservationVO.setOrdCnt(cnt);

        mv.addObject("reservationVO", reservationVO);
        mv.addObject("reservationDtlList", reservationDtlList);
        mv.addObject("optionList", optionList);
        mv.addObject("order_info", orderVO);
        mv.addObject("so", so);
        mv.addObject("leftMenu", "reservation_list");
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
    public @ResponseBody ResultModel<ReservationVO> winnerChk(String memberNm, String mobile) throws Exception {

        ResultModel<ReservationVO> result = new ResultModel<>();

        Map<String, String> param = new HashMap<>();
        param.put("memberNm", memberNm);
        param.put("mobile", mobile);

        int rsvCnt = rsvService.winnerChk(param);
        if(rsvCnt < 1) {
        	result.setSuccess(false);
        }else {
        	result.setSuccess(true);
        }

        return result;
    }

}