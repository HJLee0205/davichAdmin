package net.danvi.dmall.front.web.view.order.controller;

import java.io.File;
import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtSO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieGoodsVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieTargetVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.service.FreebieCndtService;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import net.danvi.dmall.core.model.payment.*;
import org.json.JSONObject;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SessionUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import eu.bitwalker.useragentutils.UserAgent;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.GoodsAddOptionDtlVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliveryPO;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliverySO;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliveryVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.model.RefundAccountSO;
import net.danvi.dmall.biz.app.member.manage.model.RefundAccountVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.order.exchange.service.ExchangeService;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimPayRefundPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.app.order.refund.service.RefundService;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofPO;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofVO;
import net.danvi.dmall.biz.app.order.salesproof.service.SalesProofService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaSO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaVO;
import net.danvi.dmall.biz.app.setup.delivery.service.DeliveryManageService;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigSO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.NopbPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigSO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.service.PaymentManageService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import net.danvi.dmall.biz.app.setup.term.service.TermConfigService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.remote.payment.PaymentAdapterService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import net.danvi.dmall.core.constants.CoreConstants;
import net.danvi.dmall.core.constants.PaymentInicisConstants;
import net.danvi.dmall.core.service.payment.PaycoUtil;
import net.danvi.dmall.front.web.config.view.View;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 주문 등록, 조회 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/order")
public class OrderController {
    @Value("#{system['system.solution.payment.realserviceyn']}")
    private String realServiceYn;

    @Value("#{system['system.solution.log.rootpath']}")
    private String SYSTEM_LOG_ROOT_PATH;

    @Value(value = "#{system['system.solution.conf.rootpath']}")
    private String rootPath;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;
    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;
    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;
    @Resource(name = "paymentManageService")
    private PaymentManageService paymentManageService;
    @Resource(name = "termConfigService")
    private TermConfigService termConfigService;
    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;
    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;
    @Resource(name = "deliveryManageService")
    private DeliveryManageService deliveryManageService;
    @Resource(name = "exchangeService")
    private ExchangeService exchangeService;
    @Resource(name = "refundService")
    private RefundService refundService;

    @Resource(name = "salesProofService")
    private SalesProofService salesProofService;

    @Resource(name = "paymentAdapterService")
    private PaymentAdapterService paymentAdapterService;

    @Resource(name = "freebieCndtService")
    private FreebieCndtService freebieCndtService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "couponService")
    private CouponService couponService;

    private String paymentSamplePath = "/front/order/include/";

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문 정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/order-insert")
    public String insertOrder(@Validated OrderPO po, BindingResult bindingResult, HttpServletRequest request,
                              RedirectAttributes redirectAttr, @RequestParam Map<String, Object> reqMap) throws Exception {
        ModelAndView mav = new ModelAndView();

        String orderFormType = StringUtil.nvl(po.getOrderFormType());
        /**  1. 필수 파라메터 검증 */
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new Exception("파라메터 오류");
        }
        Date today = new Date();
        po.setRegDttm(today); // 주문시 모든 등록일자를 동일하게 맞추기 위해 설정

        /**  2. 주문 등록(주문정보, 상품정보, 배송비 정보, 배송정보, 부가비용) */
        ResultModel<OrderPO> result = orderService.insertOrder(po, request);

        if (!result.isSuccess()) {
            log.debug("=== result.getMessage() : {}", result.getMessage());
            redirectAttr.addFlashAttribute("exMsg", result.getMessage());
            return View.redirect("/front/common/error");
        }
        //일반주문서일 경우
        /*if(orderFormType.equals("01")) {*/
            // 기본배송지 or 자주쓰는배송지 추가
            MemberDeliveryPO dpo = new MemberDeliveryPO();
            MemberDeliveryPO dpo2 = dpo.clone();
            dpo2.setSiteNo(po.getSiteNo());
            dpo2.setGbNm(request.getParameter("adrsNm"));
            dpo2.setAdrsNm(request.getParameter("adrsNm"));
            dpo2.setTel(request.getParameter("adrsTel"));
            dpo2.setMobile(request.getParameter("adrsMobile"));
            dpo2.setMemberGbCd(request.getParameter("memberGbCd"));

            dpo2.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());


            dpo2.setNewPostNo(request.getParameter("postNo"));

            dpo2.setStrtnbAddr(request.getParameter("numAddr"));
            dpo2.setRoadAddr(request.getParameter("roadnmAddr"));
            dpo2.setDtlAddr(request.getParameter("dtlAddr"));
            dpo2.setFrgAddrCountry(request.getParameter("frgAddrCountry"));
            dpo2.setFrgAddrZipCode(request.getParameter("frgAddrCity"));
            dpo2.setFrgAddrState(request.getParameter("firgAddrState"));
            dpo2.setFrgAddrCity(request.getParameter("frgAddrCity"));
            dpo2.setFrgAddrDtl1(request.getParameter("frgAddrDtl1"));
            dpo2.setFrgAddrDtl2(request.getParameter("frgAddrDtl2"));
            dpo2.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            if ("Y".equals(po.getDefaultYn()) || "Y".equals(po.getAddDeliveryYn())) {
                // 초기화
                dpo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                dpo.setDefaultYn("N");
                frontMemberService.updateDelivery(dpo);

                if ("Y".equals(po.getDefaultYn())) {
                    dpo2.setDefaultYn("Y");
                } else {
                    dpo2.setDefaultYn("N");
                }
                ResultModel<MemberDeliveryPO> result2 = frontMemberService.insertDelivery(dpo2);
            }
        /*}*/
        /**  4. 주문 결제(PG결제, 마켓포인트결제, 가맹점포인트결제, 쿠폰정보, 상품수량 업데이트) */
        OrderPO orderPO = new OrderPO();
        orderPO = result.getData();
        OrderPayPO orderPayPO = new OrderPayPO();
        orderPayPO.setSiteNo(po.getSiteNo());
        orderPayPO.setPaymentWayCd(request.getParameter("paymentWayCd"));
        orderPayPO.setPaymentPgCd(request.getParameter("paymentPgCd"));
        orderPayPO.setOrdNo(po.getOrdNo());
        orderPayPO.setPaymentAmt(po.getPaymentAmt());

        orderPayPO.setConfirmResultCd(request.getParameter("confirmResultCd"));
        orderPayPO.setConfirmResultMsg(request.getParameter("confirmResultMsg"));
        orderPayPO.setConfirmDttm(request.getParameter("confirmDttm"));

        orderPO.setOrderPayPO(orderPayPO);
        log.debug("=== orderPO.orderPayPO : {}", orderPO.getOrderPayPO());


        ResultModel<OrderPO> payResult = new ResultModel<OrderPO>();
        //모바일과 PC 결제모듈 방식이 다름
        if(SiteUtil.isMobile()){
            payResult = orderService.orderPaymentMobile(orderPO, request, reqMap, mav);
        }else{
            payResult = orderService.orderPayment(orderPO, request, reqMap, mav);
        }

        if (!payResult.isSuccess()) {
            redirectAttr.addFlashAttribute("exMsg", result.getMessage());
            return View.redirect("/front/common/error");
        }

//        log.debug("/** STEP. 6 SMS, EMAIL 처리 **********************/");
//        String payWayCd = orderPO.getOrderPayPO().getPaymentWayCd();
//        /**
//         * SMS (sendTypeCdSms)
//         * 주문완료: 03
//         * 결제완료 : 04
//         * 결제실패 : 14
//         * EMAIL (sendTypeCdEmail)
//         * 주문완료: 05
//         * 결제완료 : 06
//         * 결제실패 : 17
//         */
//        String sendTypeCdEmail = "";
//        String sendTypeCdSms = "";
//        String templateCode = "";
//
//        if ("11".equals(payWayCd)) {
//            // 주문완료
//            templateCode ="";
//            sendTypeCdSms = "03";
//            sendTypeCdEmail = "05";
//
//        } else {
//            //결제완료
//            templateCode="mk001";
//            sendTypeCdSms = "04";
//            sendTypeCdEmail = "06";
//        }
//
//        OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
//        orderGoodsVO.setSiteNo(po.getSiteNo());
//        orderGoodsVO.setOrdNo(String.valueOf(po.getOrdNo()));
//
//        try {
//            if (!"".equals(sendTypeCdSms)) orderService.sendOrdAutoSms(templateCode,sendTypeCdSms, orderGoodsVO);
//            if (!"".equals(sendTypeCdEmail)) orderService.sendOrdAutoEmail(sendTypeCdEmail, orderGoodsVO);
//        } catch (Exception eAuto) {
//            log.debug("{}", eAuto.getMessage());
//        }
//        log.debug("SMS EMAIL 완료");

        /**  5. 주문완료 페이지로 이동 */
        return View.redirect("/front/order/order-payment-complete?ordNo="+po.getOrdNo());

    }

    // 주문,배송조회
    @RequestMapping(value = "/order-list")
    public ModelAndView orderList(@Validated OrderSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/order_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        so.setMemberNo(memberNo);

        /*
         * [주문상태코드]
         * 00 : 주문무효 , 01 : 주문접수 , 10 : 주문완료(상태코드:입금확인중) , 11 : 주문취소 , 20 : 결제완료 , 21 : 결제취소
         * , 22 : 결제실패 , 30 : 배송준비중 , 40 : 배송중 ,
         * 50 : 배송완료 , 60 : 반품(교환)신청 , 61 : 교환취소 , 66 : 교환완료 , 70 : 반품(환불)신청 ,
         * 71 : 환불취소 , 74 : 환불완료 , 90 : 구매확정
         */
        // 03.주문내역조회 - 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getOrdDayS()) || StringUtil.isEmpty(so.getOrdDayE())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            if(SiteUtil.isMobile()){
                //모바일 : 최근 2개월간의 내역조회
                /*cal.add(Calendar.DAY_OF_YEAR, -60);*/
            }else{
                cal.add(Calendar.DAY_OF_YEAR, -15);
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                String stRegDttm = df.format(cal.getTime());
                String endRegDttm = df.format(new Date());
                so.setDayTypeCd("01");
                so.setOrdDayS(stRegDttm);
                so.setOrdDayE(endRegDttm);
            }


        }

        /*if(SiteUtil.isMobile()){
	        String[] ordDtlStatusCd = { "10", "20", "30", "40", "50","62","63","67","72","73","75"};
	        so.setOrdDtlStatusCd(ordDtlStatusCd);

	        //취소/교환/ 반품 신청 리스트 전용(가능한 상품만 불러오기위함)
	        so.setClaimStatusYn("C");
        }*/

        ResultListModel<OrderVO> order_list = orderService.selectOrdListFrontPaging(so);

        mav.addObject("so", so);
        mav.addObject("order_list", order_list);

        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(so.getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);
        mav.addObject("buyEplgWritePoint", siteInfo.getData().getBuyEplgWritePoint());
        mav.addObject("pointPvdYn", siteInfo.getData().getPointPvdYn());

        mav.addObject("leftMenu", "order_list");
        return mav;
    }

    // 주문,배송조회 모바일용 추가
    @RequestMapping(value = "/order-list-ajax")
    public ModelAndView ajaxOrderList(@Validated OrderSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/ajaxorder_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        so.setMemberNo(memberNo);

        /*
         * [주문상태코드]
         * 00 : 주문무효 , 01 : 주문접수 , 10 : 주문완료(상태코드:입금확인중) , 11 : 주문취소 , 20 : 결제완료 , 21 : 결제취소 , 22 : 결제실패 , 30 : 배송준비중 , 40 : 배송중 ,
         * 50 : 배송완료 , 60 : 교환신청 , 61 : 교환취소 , 66 : 교환완료 , 70 : 반품신청 , 71 : 반품취소 , 74 : 반품완료 , 90 : 구매확정
         */
        // 03.주문내역조회 - 기간검색(최근7일)
        if (StringUtil.isEmpty(so.getOrdDayS()) || StringUtil.isEmpty(so.getOrdDayE())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            if(SiteUtil.isMobile()){
                //모바일 : 최근 2개월간의 내역조회
                cal.add(Calendar.DAY_OF_YEAR, -60);
            }else{
                cal.add(Calendar.DAY_OF_YEAR, -15);
            }
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setDayTypeCd("01");
            so.setOrdDayS(stRegDttm);
            so.setOrdDayE(endRegDttm);
        }
        /*String[] ordDtlStatusCd = { "10", "11", "20", "21", "30", "40", "50", "60", "66", "70", "74", "90" };
        so.setOrdDtlStatusCd(ordDtlStatusCd);*/
        ResultListModel<OrderVO> order_list = orderService.selectOrdListFrontPaging(so);
        mav.addObject("so", so);
        mav.addObject("order_list", order_list);
        /*mav.addObject("leftMenu", "order_list");*/
        return mav;
    }

    // 주문한 상품의 상세 내역 조회
    @RequestMapping(value = "/order-detail")
    public ModelAndView orderDetail(@Validated OrderInfoVO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/order_detail");
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        so.setSiteGbn("front");
        OrderVO result = orderService.selectOrdDtl(so);
        /*
         * String s_loginId =
         * SessionDetailHelper.getDetails().getSession().getLoginId();
         * String o_loginId = result.getOrderInfoVO().getLoginId();
         * if (!s_loginId.equals(o_loginId)) {
         * throw new CustomException("인증오류 본인주문 아님");
         * }
         */

        String ordStatus = result.getOrderInfoVO().getOrdStatusCd();
        String billYn = "N";
        // 매출증빙 조회 /발급 가능상태
        if ("20".equals(ordStatus) || "30".equals(ordStatus) || "39".equals(ordStatus) || "40".equals(ordStatus)
                || "49".equals(ordStatus) || "50".equals(ordStatus) || "90".equals(ordStatus)) {
            billYn = "Y";
        }
        mav.addObject("billYn", billYn);


        SalesProofVO vo = new SalesProofVO();
        vo.setOrdNo(so.getOrdNo());
        vo.setSiteNo(so.getSiteNo());
        vo.setProofType("02");// 현금영수증
        ResultModel<SalesProofVO> cash_bill_info = salesProofService.selectSalesProofOrdNo(vo);
        vo.setProofType("03");// 세금계산서
        ResultModel<SalesProofVO> tax_bill_info = salesProofService.selectSalesProofOrdNo(vo);


// 배송비 계산(묶음 관련)
        String type = "order";
        Map map = orderService.calcDlvrAmt(result.getOrderGoodsVO(), type);
        List<OrderGoodsVO> list = (List<OrderGoodsVO>) map.get("list");
        Map dlvrPriceMap = (Map) map.get("dlvrPriceMap");
        Map dlvrCountMap = (Map) map.get("dlvrCountMap");

        result.setOrderGoodsVO(list);

         mav.addObject("dlvrPriceMap", dlvrPriceMap);
        mav.addObject("dlvrCountMap", dlvrCountMap);

        mav.addObject("so", so);
        mav.addObject("leftMenu", "order_list");
        mav.addObject("order_info", result);
        mav.addObject("cash_bill_info", cash_bill_info);
        mav.addObject("tax_bill_info", tax_bill_info);
        mav.addObject("realServiceYn", realServiceYn);

        return mav;
    }

    // 전체주문취소
    @RequestMapping("/order-cancel-all")
    public @ResponseBody ResultModel<OrderPayPO> orderCancelAll(@Validated OrderPO po, BindingResult bindingResult)
            throws Exception {
        // 01. 신청자와 주문자 검증(회원주문일 경우)
        OrderInfoVO so = new OrderInfoVO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        so.setOrdNo(Long.toString(po.getOrdNo()));
        OrderVO order_dtl = orderService.selectOrdDtl(so);
        String s_loginId = SessionDetailHelper.getDetails().getSession().getLoginId();
        String o_loginId = order_dtl.getOrderInfoVO().getLoginId();

        log.debug("order_dtl.getOrderInfoVO().getMemberOrdYn() : " + order_dtl.getOrderInfoVO().getMemberOrdYn());
        log.debug("s_loginId : " + s_loginId);
        log.debug("s_loginId : " + s_loginId);
        if ("Y".equals(order_dtl.getOrderInfoVO().getMemberOrdYn())) {// 회원주문일경우
            if (!s_loginId.equals(o_loginId)) {
                throw new CustomException("인증오류 본인주문 아님");
            }
        }
        // 02.전체주문취소
        if ("10".equals(order_dtl.getOrderInfoVO().getOrdStatusCd())) {
            po.setCancelStatusCd("11"); // 주문취소
        } else {

			int payBook = 0;
            for (int i = 0; i < order_dtl.getOrderPayVO().size(); i++) {// 결제수단목록
                OrderPayVO payVo = order_dtl.getOrderPayVO().get(i);
                if ("11".equals(payVo.getPaymentWayCd())) { // 무통장
                	payBook ++;
                }
            }
            // 무통장일 경우 결제취소신청 처리
            if (payBook > 0) {
            	po.setCancelStatusCd("23"); // 결제취소신청
            } else {
            	po.setCancelStatusCd("21"); // 결제취소
            }
        }
        OrderPayPO opp = new OrderPayPO();
        opp.setOrdNo(po.getOrdNo());
        String[] ordNoArr = { Long.toString(po.getOrdNo()) };
        po.setOrdNoArr(ordNoArr);
        po.setOrderPayPO(opp);
        po.setPartCancelYn("N");
        po.setCancelType("01");
        ResultModel<OrderPayPO> result = orderService.cancelOrder(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문 취소(선택취소)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/order-cancel")
    public @ResponseBody ResultModel<OrderPayPO> cancelOrder(@Validated OrderPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<OrderPayPO> cancelResult = new ResultModel<>();
        // 1. 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            cancelResult.setSuccess(false);
            return cancelResult;
        }
        // 01. 신청자와 주문자 검증(회원주문일 경우)
        OrderInfoVO so = new OrderInfoVO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        so.setOrdNo(Long.toString(po.getOrdNo()));
        OrderVO order_dtl = orderService.selectOrdDtl(so);
        String s_loginId = SessionDetailHelper.getDetails().getSession().getLoginId();
        String o_loginId = order_dtl.getOrderInfoVO().getLoginId();

        if ("Y".equals(order_dtl.getOrderInfoVO().getMemberOrdYn())) {// 회원주문일경우
            if (s_loginId != null && o_loginId != null) {
                if (!s_loginId.equals(o_loginId)) {
                    throw new CustomException("인증오류 본인주문 아님");
                }
            }
        }

        boolean dlvrChangeYn;
        dlvrChangeYn = orderService.changeDlvrPriceYn(po);
        log.debug("size >>>> : " + po.getOrdDtlSeqArr().length);

        if (dlvrChangeYn) { // 취소신청
            // 취소신청(processs)
            ResultModel<OrderPO> result = new ResultModel<>();
            po.setCancelStatusCd("23"); // 취소신청
            result = refundService.frontOrderCancelRequest(po);
            if (!result.isSuccess()) {
                log.debug("=== CANCEL ERROR : {} ", result.getMessage());
                log.debug("[[[[[[[[[[[[ 취소 신청 실패 ]]]]]]]]]]]]");
                // throw new CustomException("주문 취소 실패");
                cancelResult.setSuccess(false);
                return cancelResult;
            }
        } else { // 취소처리
            OrderPO opo = new OrderPO();
            opo.setPartCancelYn("Y");
            BeanUtils.copyProperties(po, opo);

            //opo.setCancelStatusCd("21"); // 결제취소
            if ("10".equals(order_dtl.getOrderInfoVO().getOrdStatusCd())) {
                opo.setCancelStatusCd("11"); // 결제취소
            } else {
				int payBook = 0;
                for (int i = 0; i < order_dtl.getOrderPayVO().size(); i++) {// 결제수단목록
                    OrderPayVO payVo = order_dtl.getOrderPayVO().get(i);
                    if ("11".equals(payVo.getPaymentWayCd())) { // 무통장
                    	payBook ++;
                    }
                }
                // 무통장일 경우 결제취소신청 처리
                if (payBook > 0) {
                    opo.setCancelStatusCd("23"); // 결제취소신청
                } else {
                    opo.setCancelStatusCd("21"); // 결제취소
                }
            }

            if(opo.getCancelStatusCd().equals("23")){
                ResultModel<OrderPO> result2 = new ResultModel<>();
                po.setCancelStatusCd("23"); // 취소신청
                result2 = refundService.frontOrderCancelRequest(po);
                if (!result2.isSuccess()) {
                    log.debug("=== CANCEL ERROR : {} ", result2.getMessage());
                    log.debug("[[[[[[[[[[[[ 취소 신청 실패 ]]]]]]]]]]]]");
                    // throw new CustomException("주문 취소 실패");
                    cancelResult.setSuccess(false);
                    return cancelResult;
                } else {

                }

            }else{
                ResultModel<OrderPayPO> result = orderService.cancelOrder(opo);

                if (!result.isSuccess()) {
                    log.debug("=== CANCEL ERROR : {} ", result.getMessage());
                    log.debug("[[[[[[[[[[[[ 취소 처리 실패 ]]]]]]]]]]]]");
                    // throw new CustomException("주문 취소 실패");
                    cancelResult.setSuccess(false);
                    return cancelResult;
                } else {
                    // 취소성공시 무통장입금인 경우 환불계좌정보를 등록한다.
                    // 4.무통장입금의 경우 환불계좌정보를 입력받아서 환불계좌정보 테이블에 등록한다.
                    for (int i = 0; i < order_dtl.getOrderPayVO().size(); i++) {
                        // 결제수단목록
                        OrderPayVO payVo = order_dtl.getOrderPayVO().get(i);
                        if ("11".equals(payVo.getPaymentWayCd()) || "22".equals(payVo.getPaymentWayCd())) { // 무통장,가상계좌
                            ClaimPayRefundPO cp_po = new ClaimPayRefundPO();
                            BeanUtils.copyProperties(po, cp_po);
                            cp_po.setPaymentNo(payVo.getPaymentNo());// 결제번호
                            cp_po.setRefundTypeCd("1");// 환불유형코드(1:결제취소환불,2:반품완료환불)
                            cp_po.setRefundStatusCd("3");// 환불상태코드(1:접수,2:대기,3:완료,4:실패)
                            cp_po.setBankCd(po.getBankCd()); // 은행코드
                            cp_po.setHolderNm(po.getHolderNm()); // 예금주명
                            cp_po.setActNo(po.getActNo()); // 계좌번호
                            refundService.insertPaymerCashRefund(cp_po);
                        }
                    }
                }
            }


        }
        cancelResult.setSuccess(true);
        return cancelResult;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 주문취소/교환/환불접수 신청가능내역조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/order-cancelrequest-list")
    public ModelAndView selectOrderCancelRequest(@Validated OrderSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/order_cancel_request");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        so.setMemberNo(memberNo);

        /*
         * [주문상태코드]
         * 00 : 주문무효 , 01 : 주문접수 , 10 : 주문완료(상태코드:입금확인중) , 11 : 주문취소 , 20 : 결제완료 , 21 : 결제취소
         * , 22 : 결제실패 , 30 : 배송준비중 , 40 : 배송중 ,
         * 50 : 배송완료 , 60 : 반품(교환)신청 , 61 : 교환취소 , 66 : 교환완료 , 70 : 반품(환불)신청 ,
         * 71 : 환불취소 , 74 : 환불완료 , 90 : 구매확정
         */
        // 03.주문내역조회 - 기간검색(최근7일)
        /*if (StringUtil.isEmpty(so.getOrdDayS()) || StringUtil.isEmpty(so.getOrdDayE())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -7);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setDayTypeCd("01");
            so.setOrdDayS(stRegDttm);
            so.setOrdDayE(endRegDttm);
        }*/

        String[] ordDtlStatusCd = { "10", "20", "30", "40", "50","62","63","67","72","73","75"};
        so.setOrdDtlStatusCd(ordDtlStatusCd);

        //취소/교환/ 반품 신청 리스트 전용(가능한 상품만 불러오기위함)
        so.setClaimStatusYn("C");
       ResultListModel<OrderVO> order_list = orderService.selectOrdListFrontPaging(so);

        mav.addObject("so", so);
        mav.addObject("order_list", order_list);
        mav.addObject("leftMenu", "order_cancel_request");
        return mav;
    }

    // 취소팝업
    @RequestMapping(value = "/order-cancel-pop")
    public ModelAndView orderCancelPop(@Validated OrderInfoVO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/order_cancel_pop");
        OrderVO orderVO = orderService.selectOrdDtl(so);
        List<OrderGoodsVO> goodsList = orderVO.getOrderGoodsVO(); // 상품 정보

        String btn_all_delte = "Y";
        for (int j = 0; j < goodsList.size(); j++) {
            OrderGoodsVO goodsVo = goodsList.get(j);
            String status_cd = goodsVo.getOrdDtlStatusCd();
            log.debug("status_cd : " + status_cd);
            if ("N".equals(goodsVo.getAddOptYn())) {
                if (!("10".equals(status_cd) || "20".equals(status_cd))) {
                    btn_all_delte = "N";
                    break;
                }
            }
        }

        // 환불계좌 조회
        ResultModel<RefundAccountVO> refundModel = new ResultModel<>();
        if (SessionDetailHelper.getDetails().isLogin()) {
            RefundAccountSO refundAccountSO = new RefundAccountSO();
            refundAccountSO.setSiteNo(so.getSiteNo());
            refundAccountSO.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            refundModel = frontMemberService.selectRefundAccount(refundAccountSO);
        }

        mav.addObject("refundModel", refundModel);
        mav.addObject("btn_all_delte", btn_all_delte);
        mav.addObject("orderVO", orderVO);
        mav.addObject("so", so);
        return mav;
    }

    // 반품/환불팝업
    @RequestMapping(value = "/order-refund-pop")
    public ModelAndView orderRefundPop(@Validated OrderInfoVO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/order_refund_pop");
        // 주문정보 조회
        OrderVO orderVO = orderService.selectOrdDtl(so);
        mav.addObject("orderVO", orderVO);
        // 환불계좌정보조회
        ResultModel<RefundAccountVO> refund_account = new ResultModel<>();
        if (SessionDetailHelper.getDetails().isLogin()) {
            RefundAccountSO rf_so = new RefundAccountSO();
            rf_so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            refund_account = frontMemberService.selectRefundAccount(rf_so);
        }
        mav.addObject("refund_account", refund_account);
        // 조회조건셋팅
        mav.addObject("so", so);
        return mav;
    }

    // 반품/환불신청
    @RequestMapping("/refund-claim-apply")
    public @ResponseBody ResultModel<ClaimGoodsVO> claimRefund(@Validated ClaimGoodsPO po, BindingResult bindingResult)
            throws Exception {
        // 01. 신청자와 주문자 검증(회원주문일 경우)
        OrderInfoVO so = new OrderInfoVO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        so.setOrdNo(po.getOrdNo());
        OrderVO order_dtl = orderService.selectOrdDtl(so);
        String s_loginId = SessionDetailHelper.getDetails().getSession().getLoginId();
        String o_loginId = order_dtl.getOrderInfoVO().getLoginId();

        if ("Y".equals(order_dtl.getOrderInfoVO().getMemberOrdYn())) {// 회원주문일경우
            if (!s_loginId.equals(o_loginId)) {
                throw new CustomException("인증오류 본인주문 아님");
            }
        }


        // 02.환불신청
        ResultModel<ClaimGoodsVO> result = new ResultModel<>();
        // 클레임 사유 코드(10:제품파손-파손되었어요,20:제품불일치-다른 상품이 왔어요,30:사이즈가 맞지 않아요,90:기타)
        log.debug("ordNo : " + po.getOrdNo());
        log.debug("po.getClaimReasonCd() : " + po.getClaimReasonCd());//
        // 반품코드
        //po.setReturnCd("11");// 반품코드(11:반품신청,12:반품완료)
        // 클레임 코드
        //po.setClaimCd("11");// 클레임코드(11:환불신청,12:환불완료,21:교환신청,22:교환완료,31:결제취소신청,32:결제취소완료)

        String[] claimReturnCdArr = new String[po.getOrdDtlSeqArr().length];
        String[] claimCdArr = new String[po.getOrdDtlSeqArr().length];
        for (int i = 0; i < po.getOrdDtlSeqArr().length; i++) {
            claimReturnCdArr[i] = "11";// 반품코드(11:반품신청,12:반품완료)
            claimCdArr[i] = "11";// 클레임코드(11:환불신청,12:환불완료,21:교환신청,22:교환완료,31:결제취소신청,32:결제취소완료)
        }

        po.setClaimReturnCdArr(claimReturnCdArr);
        po.setClaimExchangeCdArr(claimCdArr);

        // 03. 교환신청 processs
        //result = exchangeService.processClaimExchange(po);

        // 클레임 상세 이유
        log.debug("po.getClaimDtlReason() : " + po.getClaimDtlReason()); // 상세사유
        po.setOrdDtlStatusCd("70"); // 환불신청

        result = refundService.updateClaimAllRefund(po); // 환불신청(FRONT환불신청은 전체만 가능) --> 부분으로 변경

        // 무통장, 가상계좌의 경우 환불계좌정보를 입력받아서 환불계좌정보 테이블에 등록한다.
        for (int i = 0; i < order_dtl.getOrderPayVO().size(); i++) {// 결제수단목록
            OrderPayVO payVo = order_dtl.getOrderPayVO().get(i);
            if ("11".equals(payVo.getPaymentWayCd()) || "22".equals(payVo.getPaymentWayCd())) { // 무통장, 가상계좌
                ClaimPayRefundPO cp_po = new ClaimPayRefundPO();
                BeanUtils.copyProperties(po, cp_po);
                cp_po.setPaymentNo(payVo.getPaymentNo());// 결제번호
                cp_po.setRefundTypeCd("2");// 환불유형코드(1:결제취소환불,2:반품완료환불)
                cp_po.setRefundStatusCd("1");// 환불상태코드(1:접수,2:대기,3:완료,4:실패)
                /*
                 * 환불계좌정보 등록
                 * CASH_REFUND_NO, -- 현금환불번호
                 * PAYMENT_NO, -- 결제번호
                 * REFUND_TYPE_CD, -- 환불유형코드(1:결제취소환불,2:반품완료환불)
                 * REFUND_STATUS_CD, -- 환불상태코드(1:접수,2:대기,3:완료,4:실패)
                 * BANK_CD, -- 은행코드
                 * ACT_NO, -- 계좌번호
                 * HOLDER_NM, -- 예금주
                 * SMS_SEND_YN, -- sms발송여부
                 * log.debug("cp_po.getRefundTypeCd() >>>>>>>>>>>>> : " +
                 * cp_po.getRefundTypeCd());
                 * log.debug("cp_po.getRefundStatusCd() >>>>>>>>>>>>> : " +
                 * cp_po.getRefundStatusCd());
                 * log.debug("cp_po.getBankCd() >>>>>>>>>>>>> : " +
                 * cp_po.getBankCd());
                 * log.debug("cp_po.getHolderNm() >>>>>>>>>>>>> : " +
                 * cp_po.getHolderNm());
                 * log.debug("cp_po.getActNo() >>>>>>>>>>>>> : " +
                 * cp_po.getActNo());
                 */
                refundService.insertPaymerCashRefund(cp_po);
            }
        }
        return result;
    }

    // 반품/교환팝업
    @RequestMapping(value = "/order-exchange-pop")
    public ModelAndView orderExchangePop(@Validated OrderInfoVO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/order_exchange_pop");
        OrderVO orderVO = orderService.selectOrdDtl(so);
        mav.addObject("orderVO", orderVO);
        mav.addObject("so", so);
        return mav;
    }

    // 반품/교환신청
    @RequestMapping("/exchange-claim-apply")
    public @ResponseBody ResultModel<ClaimGoodsVO> claimExchange(@Validated ClaimGoodsPO po,
            BindingResult bindingResult) throws Exception {
        // 01. 신청자와 주문자 검증(회원주문일 경우)
        OrderInfoVO so = new OrderInfoVO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        so.setOrdNo(po.getOrdNo());
        OrderVO order_dtl = orderService.selectOrdDtl(so);
        String s_loginId = SessionDetailHelper.getDetails().getSession().getLoginId();// 로그인한 고객아이디
        String o_loginId = order_dtl.getOrderInfoVO().getLoginId();// 주문한 고객아이디

        if ("Y".equals(order_dtl.getOrderInfoVO().getMemberOrdYn())) {// 회원주문일경우
            if (!s_loginId.equals(o_loginId)) {
                throw new CustomException("인증오류 본인주문 아님");
            }
        }
        // 02. 교환신청(코드셋팅)
        ResultModel<ClaimGoodsVO> result = new ResultModel<>();
        log.debug("size >>>> : " + po.getOrdDtlSeqArr().length);
        String[] claimReturnCdArr = new String[po.getOrdDtlSeqArr().length];
        String[] claimCdArr = new String[po.getOrdDtlSeqArr().length];
        for (int i = 0; i < po.getOrdDtlSeqArr().length; i++) {
            claimReturnCdArr[i] = "11";// 반품코드(11:반품신청,12:반품완료)
            claimCdArr[i] = "21";// 클레임코드(11:환불신청,12:환불완료,21:교환신청,22:교환완료,31:결제취소신청,32:결제취소완료)
        }
        po.setClaimExchangeCdArr(claimCdArr);
        po.setClaimReturnCdArr(claimReturnCdArr);

        // 03. 교환신청 processs
        result = exchangeService.processClaimExchange(po);
        return result;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 주문취소/교환/환불접수 내역조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/order-cancel-list")
    public ModelAndView orderCancelList(@Validated OrderSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/order_cancel_list");

        // 로그인여부 체크
        /*if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }*/

        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        so.setMemberNo(memberNo);

        /*
         * [주문상태코드]
         * 00 : 주문무효 , 01 : 주문접수 , 10 : 주문완료(상태코드:입금확인중) , 11 : 주문취소 , 20 : 결제완료 , 21 : 결제취소
         * , 22 : 결제실패 , 30 : 배송준비중 , 40 : 배송중 ,
         * 50 : 배송완료 , 60 : 반품(교환)신청 , 61 : 교환취소 , 66 : 교환완료 , 70 : 반품(환불)신청 ,
         * 71 : 환불취소 , 74 : 환불완료 , 90 : 구매확정
         */
        // 03.주문내역조회 - 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getOrdDayS()) || StringUtil.isEmpty(so.getOrdDayE())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setDayTypeCd("01");
            so.setOrdDayS(stRegDttm);
            so.setOrdDayE(endRegDttm);
        }
        String[] ordDtlStatusCd = { "11", "21", "60", "66", "70", "74" };
        String claimStatusYn = "Y";
        so.setOrdDtlStatusCd(ordDtlStatusCd);
        so.setClaimStatusYn(claimStatusYn);
        ResultListModel<OrderVO> order_list = orderService.selectOrdListFrontPaging(so);
        mav.addObject("so", so);
        mav.addObject("order_list", order_list);
        mav.addObject("leftMenu", "order_cancel_list");
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문서 작성 페이지
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/order-form")
    public ModelAndView orderForm(@Validated OrderVO vo, BindingResult bindingResult, HttpServletRequest request)
            throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/order/order_form");
        // 필수 파라메터 확인
        // 각종 검증
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // 01. 주문데이터 확인
        String[] itemArr = vo.getItemArr();

        if(request.getParameter("param_opt_1")!=null){
            JSONObject json = new JSONObject(request.getParameter("param_opt_1"));
            log.debug(" === json : {}", json.toString());
            itemArr = json.getString("itemArr").split(",");
        }

        OrderVO orderVO = new OrderVO();
        GoodsDetailSO goodsDetailSO = new GoodsDetailSO();
        ResultModel<GoodsDetailVO> goodsInfo = new ResultModel<>();
        // 주문 상품 정보
        log.debug(" ==== itemArr : {}", itemArr);
        List<OrderGoodsVO> orderGoodsList = new ArrayList();
        if (itemArr != null && itemArr.length > 0) {
            for (int i = 0; i < itemArr.length; i++) {
                /*
                 * 전송 데이터 예제
                 * itemArr[0] : G1607121100_0815▦I1607121106_0960^1^01▦▦82
                 * itemArr[1] : G1607121100_0815▦I1607121106_0961^1^02▦▦82
                 * itemArr[2] : G1607121100_0815▦I1607121106_0962^1^03▦▦82
                 * itemArr[3] : G1607121100_0815▦I1607121106_0963^1^04▦69^118^1*70^120^1*69^119^1▦82
                 */

                String itemArrSplit = itemArr[i].replace("&acirc;&brvbar;", "▦");
                // 상품번호
                String goodsNo = itemArrSplit.split("\\▦")[0];
                // 단품정보(단품번호:수량:배송비결제코드)
                String item = itemArrSplit.split("\\▦")[1];
                String itemNo = item.split("\\^")[0]; // 단품번호
                int buyQtt = Integer.parseInt(item.split("\\^")[1]); // 단품 구매수량
                String dlvrcPaymentCd = item.split("\\^")[2]; // 배송비 결제 코드
                // 선불/착불 이면서 매장픽업 04  (ex: 01|04)
                /*if(dlvrcPaymentCd.split("\\|").length >1){
                    dlvrcPaymentCd=dlvrcPaymentCd.split("\\|")[0];
                }*/

                // 추가옵션정보(옵션번호:상세번호:수량)
                String addOpt = "";
                if (itemArrSplit.split("\\▦").length == 4) {
                    addOpt = itemArrSplit.split("\\▦")[2];
                }
                // 카테고리 정보
                long ctgNo = 0;
                if (!"".equals(itemArrSplit.split("\\▦")[3])) {
                    ctgNo = Long.parseLong(itemArrSplit.split("\\▦")[3]);
                }

                goodsDetailSO.setGoodsNo(goodsNo);
                goodsDetailSO.setItemNo(itemNo);
                goodsDetailSO.setSiteNo(vo.getSiteNo());
                goodsDetailSO.setSaleYn("Y");
                if (SessionDetailHelper.getDetails().isLogin()) {
                    goodsDetailSO.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                }
                OrderGoodsVO orderGoodsVO = orderService.selectOrderGoodsInfo(goodsDetailSO);

                if (orderGoodsVO == null) {
                    ModelAndView mavErr = new ModelAndView("error/notice");
                    mavErr.addObject("exMsg", MessageUtil.getMessage("front.web.goods.noSale"));
                    return mavErr;
                } else {
                    if ("Y".equals(orderGoodsVO.getAdultCertifyYn())) {
                        if (!SessionDetailHelper.getDetails().isLogin()) {
                            ModelAndView mavErr = new ModelAndView("error/notice");
                            mavErr.addObject("exMsg", "성인용품은 성인인증을 하셔야만 구매가 가능합니다.");
                            return mavErr;
                        } else {
                            if (SessionDetailHelper.getSession().getAdult() == null || !SessionDetailHelper.getSession().getAdult()) {
                                ModelAndView mavErr = new ModelAndView("error/notice");
                                mavErr.addObject("exMsg", "성인용품은 성인인증을 하셔야만 구매가 가능합니다.");
                                return mavErr;
                            }
                        }
                    }
                }

                // 기획전 할인정보 조회
                ExhibitionSO pso = new ExhibitionSO();
                pso.setSiteNo(vo.getSiteNo());
                pso.setGoodsNo(goodsNo);
                String prmtBrandNo ="";
                if(orderGoodsVO.getBrandNo()!=null && !orderGoodsVO.getBrandNo().equals("")) {
                    prmtBrandNo = orderGoodsVO.getBrandNo();
                    pso.setPrmtBrandNo(prmtBrandNo);
                }

                ResultModel<ExhibitionVO> exhibitionVO = exhibitionService.selectExhibitionByGoods(pso);

                if (exhibitionVO.getData() != null) {
                    orderGoodsVO.setPrmtNo(exhibitionVO.getData().getPrmtNo()); // 기획전 번호
                    orderGoodsVO.setPrmtDcGbCd(exhibitionVO.getData().getPrmtDcGbCd());//기획전 할인 구분 코드
                    orderGoodsVO.setDcRate(exhibitionVO.getData().getPrmtDcValue()); // 기획전 할인율/할인금액
                    orderGoodsVO.setFirstBuySpcPrice(exhibitionVO.getData().getFirstBuySpcPrice()); // 첫구매가격
                    orderGoodsVO.setPrmtTypeCd(exhibitionVO.getData().getPrmtTypeCd()); // 기획전 유형 코드
                }

                // 10.사은품대상조회
                ResultListModel<FreebieTargetVO> freebieEventList = new ResultListModel<>();
                FreebieCndtSO freebieCndtSO = new FreebieCndtSO();
                freebieCndtSO.setGoodsNo(goodsNo);
                freebieCndtSO.setSiteNo(vo.getSiteNo());
                freebieEventList = freebieCndtService.selectFreebieListByGoodsNo(freebieCndtSO);

                List<FreebieGoodsVO> freebieList = (List<FreebieGoodsVO>) freebieEventList.getExtraData().get("goodsResult");
                List<FreebieGoodsVO> freebieGoodsList = new ArrayList();
                // 사은품 조회
                if (freebieList != null && freebieList.size() > 0) {
                    for (int j = 0; j < freebieList.size(); j++) {
                        FreebieGoodsVO freebieEventVO = freebieList.get(j);
                        FreebieCndtSO freebieGoodsSO = new FreebieCndtSO();
                        freebieGoodsSO.setSiteNo(vo.getSiteNo());
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
                for (int k = 0; k < freebieGoodsList.size(); k++) {
                    FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(k);
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
                for (int k = 0; k < freebieGoodsList.size(); k++) {
                    FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(k);
                    if (freebie_No != freebieGoodsVO.getFreebieEventNo()) {
                        freebieGoodsList.remove(k);
                    }
                }
                orderGoodsVO.setFreebieGoodsList(freebieGoodsList);
                //mav.addObject("freebieGoodsList", freebieGoodsList);

                orderGoodsVO.setOrdQtt(buyQtt); // 구매수량
                orderGoodsVO.setDlvrcPaymentCd(dlvrcPaymentCd); // 배송비 결제 코드
                orderGoodsVO.setCtgNo(ctgNo); // 카테고리 정보
                List<GoodsAddOptionDtlVO> goodsAddOptList = new ArrayList();
                if (!"".equals(addOpt)) {
                    String[] addOptArr = addOpt.split("\\*");
                    for (int k = 0; k < addOptArr.length; k++) {
                        long addOptNo = Long.parseLong(addOptArr[k].split("\\^")[0]);
                        long addOptDtlSeq = Long.parseLong(addOptArr[k].split("\\^")[1]);
                        int optBuyQtt = Integer.parseInt(addOptArr[k].split("\\^")[2]);
                        goodsDetailSO.setAddOptNo(addOptNo);
                        goodsDetailSO.setAddOptDtlSeq(addOptDtlSeq);
                        // 추가옵션 정보 조회
                        GoodsAddOptionDtlVO goodsAddOptionDtlVO = orderService.selectOrderAddOptionInfo(goodsDetailSO);
                        goodsAddOptionDtlVO.setAddOptBuyQtt(optBuyQtt);
                        goodsAddOptList.add(goodsAddOptionDtlVO);
                    }
                    orderGoodsVO.setGoodsAddOptList(goodsAddOptList);
                }
                orderGoodsList.add(orderGoodsVO);
            }
        } else {
            throw new Exception(MessageUtil.getMessage("front.web.common.wrongapproach"));
        }
        // orderVO.setOrderGoodsVO(orderGoodsList);

        // 배송비 계산(묶음 관련)
        String type = "order";
        Map map = orderService.calcDlvrAmt(orderGoodsList, type);
        List<OrderGoodsVO> list = (List<OrderGoodsVO>) map.get("list");
        Map dlvrPriceMap = (Map) map.get("dlvrPriceMap");
        Map dlvrCountMap = (Map) map.get("dlvrCountMap");

        orderVO.setOrderGoodsVO(list);
        mav.addObject("dlvrPriceMap", dlvrPriceMap);
        mav.addObject("dlvrCountMap", dlvrCountMap);

        // 02. 주문번호 생성
        long siteNo = vo.getSiteNo();
        long ordNo = orderService.createOrdNo(siteNo);

        mav.addObject("TITLE", "주문하기");
        mav.addObject("ordNo", ordNo);

        // 회원기본정보 조회(비회원)
        if (SessionDetailHelper.getDetails().isLogin()) {
            long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
            MemberManageSO so = new MemberManageSO();
            so.setMemberNo(memberNo);
            so.setSiteNo(siteNo);
            ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(so);

            // 기본배송지
            MemberDeliverySO memberDeliverySO = new MemberDeliverySO();
            memberDeliverySO.setMemberNo(memberNo);
            memberDeliverySO.setSiteNo(siteNo);
            ResultListModel<MemberDeliveryVO> deliveryList = frontMemberService.selectDeliveryListPaging(memberDeliverySO);

            // 최근배송지
            memberDeliverySO.setMemberNo(memberNo);
            ResultModel<MemberDeliveryVO> recentlyDeliveryInfo = frontMemberService.selectRecentlyDeliveryInfo(memberDeliverySO);

            // 보유쿠폰search > 회원기본정보 set
            Integer couponCount = memberManageService.selectCouponGetPagingCount(so);// 할인쿠폰
            member_info.getData().setCpCnt(Integer.toString(couponCount));

            // 보유 마켓포인트 조회
            ResultModel<MemberManageVO> prcAmt = memberManageService.selectMemSaveMn(so);
            member_info.getData().setPrcAmt(prcAmt.getData().getPrcAmt());

            // 보유 가맹점 포인트 조회
            // 인터페이스로 보유 포인트 조회
            Map<String, Object> param = new HashMap<>();
            param.put("memNo", memberNo);

            String integrationMemberGbCd = SessionDetailHelper.getDetails().getSession().getIntegrationMemberGbCd();
            if("03".equals(integrationMemberGbCd)){
                Map<String, Object> point_res = InterfaceUtil.send("IF_MEM_008", param);

                if ("1".equals(point_res.get("result"))) {
                }else{
                    point_res.put("mtPoint",0);
                }
                member_info.getData().setPrcPoint(String.valueOf(point_res.get("mtPoint")));
            }


            mav.addObject("member_info", member_info); // 회원정보
            mav.addObject("deliveryList", deliveryList); // 회원배송지 정보
            mav.addObject("recentlyDeliveryInfo", recentlyDeliveryInfo); // 최근배송지
                                                                         // 정보
        }

        // 통합 PG 설정 조회
        CommPaymentConfigSO commPaymentConfigSO = new CommPaymentConfigSO();
        commPaymentConfigSO.setSiteNo(siteNo);
        commPaymentConfigSO.setUseYn("Y");
        ResultModel<CommPaymentConfigVO> pgPaymentConfig = paymentManageService.selectCommPaymentConfig(commPaymentConfigSO);
        mav.addObject("pgPaymentConfig", pgPaymentConfig);
        // 간편결제 설정 조회
        SimplePaymentConfigSO simplePaymentConfigSO = new SimplePaymentConfigSO();
        simplePaymentConfigSO.setSiteNo(siteNo);
        simplePaymentConfigSO.setSimpPgCd("41");
        ResultModel<SimplePaymentConfigVO> simplePaymentConfig = paymentManageService.selectSimplePaymentConfig(simplePaymentConfigSO);
        mav.addObject("simplePaymentConfig", simplePaymentConfig);
        // 해외결제 설정 조회
        ResultModel<CommPaymentConfigVO> foreignPaymentConfig = paymentManageService.selectForeignPaymentConfig(siteNo);
        mav.addObject("foreignPaymentConfig", foreignPaymentConfig);

        // 알리페이 설정 조회
        ResultModel<CommPaymentConfigVO> alipayPaymentConfig = paymentManageService.selectAlipayPaymentConfig(siteNo);
        mav.addObject("alipayPaymentConfig", alipayPaymentConfig);

        // 텐페이 설정 조회
        ResultModel<CommPaymentConfigVO> tenpayPaymentConfig = paymentManageService.selectTenpayPaymentConfig(siteNo);
        mav.addObject("tenpayPaymentConfig", tenpayPaymentConfig);

        // 무통장 설정 조회
        ResultListModel<NopbPaymentConfigVO> nopbListModel = paymentManageService.selectNopbPaymentList(siteNo);
        mav.addObject("nopbListModel", nopbListModel);

        // 비회원 약관 조회
        TermConfigSO tso = new TermConfigSO();
        tso.setSiteNo(vo.getSiteNo());
        tso.setSiteInfoCd("03"); // 쇼핑몰이용약관
        mav.addObject("term_03", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("20"); // 비회원구매 및 결제 개인정보 취급방침
        mav.addObject("term_20", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("07"); // 개인정보 제3자 제공 동의
        mav.addObject("term_07", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("08"); // 개인정보 취급 위탁 동의
        mav.addObject("term_08", termConfigService.selectTermConfig(tso));

        String domain = HttpUtil.getHttpServletRequest().getServerName();
        String mobileContext = "";
        if(SiteUtil.isMobile()){
            mobileContext = "/m";
        }
        String siteDomain = "https://" + domain + mobileContext+"/front/order"; // 가맹점 도메인 입력
        mav.addObject("siteDomain", siteDomain);

        // allthegate 주문결제화면처리
        /*
         * PaymentModel reqPaymentModel = new PaymentModel();
         * reqPaymentModel.setSiteNo(siteNo);
         * // pgMainCd:결제PG주체코드 -(서버코드) 01.고객(Front일경우), 02.고객(Front-Mo일경우),
         * 03.DMALL(BO일경우)
         * reqPaymentModel.setMainCd("01");
         * reqPaymentModel.setPaymentWayCd("23");
         * reqPaymentModel.setPgId("aegis");
         * reqPaymentModel.setOrdNo("20160720153203667");
         * reqPaymentModel.setPaymentAmt("1000");
         *
         * reqPaymentModel.setPaymentPgCd(CoreConstants.PG_CD_ALLTHEGATE);
         * ResultModel<PaymentModel<?>> rsm =
         * paymentAdapterService.cert(reqPaymentModel, new HashMap(), mav);
         */

        // 시/도 목록 가져오기
        List<CmnCdDtlVO> codeListModel = ServiceUtil.listCode("STORE_AREA_CD");
        mav.addObject("codeListModel", codeListModel);


        //모바일 전용
        if(SiteUtil.isMobile()){
            String URL = "";
            String strParam = "";
            // request URL
            if (request.getParameter("Ret_URL") != null && !request.getParameter("Ret_URL").equals("")) {
                URL = request.getParameter("Ret_URL");
            } else {
                Enumeration param = request.getParameterNames();
                while (param.hasMoreElements()) {
                    String name = (String) param.nextElement();
                    String value = request.getParameter(name);
                    strParam += name + "=" + value + "&";
                }
                URL = request.getRequestURL() + "?" + strParam;
            }

            //브라우저 정보
            UserAgent ua = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
            mav.addObject("ua", ua);
            mav.addObject("Ret_URL", URL);
        }

        ResultModel<OrderVO> orderInfo = new ResultModel<>();
        orderVO.setOrdNo(ordNo);
        orderInfo.setData(orderVO);
        mav.addObject("orderInfo", orderInfo); // 주문정보

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 9.
     * 작성자 : dong
     * 설명   : 지역 추가 배송비 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 9. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/area-additional-cost")
    public @ResponseBody ResultListModel<DeliveryAreaVO> selectAreaAddDlvrList(DeliveryAreaSO so,
            BindingResult bindingResult) throws Exception {
        // 지역 추가 배송비 조회
        ResultListModel<DeliveryAreaVO> areaAddDlvrList = deliveryManageService.selectDeliveryList(so);
        return areaAddDlvrList;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 4.
     * 작성자 : dong
     * 설명   : 이니시스 인증관련 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 4. dong - 최초생성
     * </pre>
     *
     * @param inicisPO
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/inicis-signature-info")
    public @ResponseBody ResultModel<InicisPO> setSignature(InicisPO inicisPO, BindingResult bindingResult)
            throws Exception {
        CommPaymentConfigSO so = new CommPaymentConfigSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setPgCd(CoreConstants.PG_CD_INICIS);
        CommPaymentConfigVO vo = paymentManageService.selectCommPaymentConfig(so).getData();

        ResultModel<InicisPO> resultModel = new ResultModel<>();
        // 이니시스 통신 데이터 셋팅
        //카카오페이 별도 세팅
        if(inicisPO.getOnlykakaopay().equals("Y")){
            inicisPO.setPgId("KAdavich01");
            inicisPO.setSignKey("ZkpWcFh2Q2tGV2l3dHZDUW04ZEpVZz09");
        }else{
            inicisPO.setPgId(vo.getPgId());
            inicisPO.setSignKey(vo.getSignKey());
        }


        resultModel.setData(PaymentInicisConstants.getDefaultInicis(inicisPO));
        return resultModel;
    }

    // 이니시스 리턴(인증및결제요청-웹표준 방식:인증후 받은 암호화된 데이터로 바로 결제승인처리)
    @RequestMapping(value = "/inicis-stdpay-return")
    public ModelAndView ini_stdpay_return(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/order/include/inicis/inicis_return");

        request.setCharacterEncoding("UTF-8");
        Map<String, String> paramMap = new Hashtable<String, String>();
        Enumeration elems = request.getParameterNames();
        String temp = "";
        while (elems.hasMoreElements()) {
            temp = (String) elems.nextElement();
            paramMap.put(temp, request.getParameter(temp));
        }
        if(SiteUtil.isMobile()){
            if(paramMap.get("P_OID")!=null && !paramMap.get("P_OID").equals("") ) {
                //NOTI 정보 조회
                Thread.sleep(5000);

                Map<String, Object> resultMap = new Hashtable<String, Object>();
                resultMap = orderService.selectIniCisNotiInfo(paramMap);

                if(resultMap!=null) {
                    mv.addObject("P_STATUS", resultMap.get("P_STATUS"));
                    mv.addObject("P_REQ_URL", resultMap.get("P_REQ_URL"));
                    mv.addObject("P_TID", resultMap.get("P_TID"));
                }
            }else{
                    mv.addObject("P_STATUS", paramMap.get("P_STATUS"));
                    mv.addObject("P_REQ_URL", paramMap.get("P_REQ_URL"));
                    mv.addObject("P_TID", paramMap.get("P_TID"));
            }
        }else{
            InicisPO inicisPO = new InicisPO();
            inicisPO.setAuthToken(paramMap.get("authToken"));// 취소 요청 tid에 따라서 유동적(가맹점 수정후 고정)
            inicisPO.setAuthUrl(paramMap.get("authUrl"));// 승인요청 API url(수신 받은 값으로 설정, 임의 세팅 금지)
            inicisPO.setNetCancel(paramMap.get("netCancel"));// 망취소 API url(수신 받은 값으로 설정, 임의 세팅 금지)
            mv.addObject("io", inicisPO);
        }

        return mv;
    }

    // 이니시스 리턴(인증및결제요청-웹표준 방식:인증후 받은 암호화된 데이터로 바로 결제승인처리)
    @RequestMapping(value = "/inicis-stdpay-notice")
    public ModelAndView ini_stdpay_noti(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/order/include/inicis/inicis_noti");
        String addr = request.getRemoteAddr().toString();
        //**********************************************************************************
        //이부분에 로그파일 경로를 수정해주세요.
        String file_path = rootPath + "/payment/02/1/INIpay50/log"; //로그를 기록할 디렉터리
        //**********************************************************************************

        /**
        //이니시스 NOTI 서버에서 받은 Value
        String  P_TID;			// 거래번호
        String  P_MID;			// 상점아이디
        String  P_AUTH_DT;		// 승인일자
        String  P_STATUS;		// 거래상태 (00:성공, 01:실패)
        String  P_TYPE;			// 지불수단
        String  P_OID;			// 상점주문번호
        String  P_FN_CD1;		// 금융사코드1
        String  P_FN_CD2;		// 금융사코드2
        String  P_FN_NM;		// 금융사명 (은행명, 카드사명, 이통사명)
        String  P_AMT;			// 거래금액
        String  P_UNAME;		// 결제고객성명
        String  P_RMESG1;		// 결과코드
        String  P_RMESG2;		// 결과메시지
        String  P_NOTI;			// 노티메시지(상점에서 올린 메시지)
        String  P_AUTH_NO;		// 승인번호

        String  P_CARD_ISSUER_CODE;	// 발급사코드
        String  P_CARD_NUM;			// 카드번호

        알리페이 / 텐페이 NOTI 추가정보
        P_RESULTCD                  // 결과코드
        P_RESULTMSG                 // 결과메시지
        P_EXRATE                    // 환율
        P_HASH                      // 해쉬검증 P_OID+P_AMT+P_AUTH_NO+해쉬키 SHA512 원하는 가맹점에 한해 사용

        알리페이 / 텐페이  모바일 NOTI 추가정모
        P_KOR_AMT                   //원화거래금액
        P_EXCHANGE_RATE             //환율정보

        **/

        request.setCharacterEncoding("UTF-8");
        Map<String, String> paramMap = new Hashtable<String, String>();
        Enumeration elems = request.getParameterNames();
        String temp = "";
        while (elems.hasMoreElements()) {
            temp = (String) elems.nextElement();
            paramMap.put(temp, request.getParameter(temp));
        }

        /***********************************************************************************
         결제처리에 관한 로그 기록
         위에서 상점 데이터베이스에 등록 성공유무에 따라서 성공시에는 "OK"를 이니시스로 실패시는 "FAIL" 을
         리턴하셔야합니다. 아래 조건에 데이터베이스 성공시 받는 FLAG 변수를 넣으세요
         (주의) OK를 리턴하지 않으시면 이니시스 지불 서버는 "OK"를 수신할때까지 계속 재전송을 시도합니다
         기타 다른 형태의 out.println(response.write)는 하지 않으시기 바랍니다
        ***********************************************************************************/

        Calendar calendar = Calendar.getInstance();
        StringBuffer times = new StringBuffer();
        times.append(Integer.toString(calendar.get(Calendar.YEAR)));
        if((calendar.get(Calendar.MONTH)+1)<10)
        {
            times.append("0");
        }
        times.append(Integer.toString(calendar.get(Calendar.MONTH)+1));
        if((calendar.get(Calendar.DATE))<10)
        {
            times.append("0");
        }
        times.append(Integer.toString(calendar.get(Calendar.DATE)));

        File file = new File(file_path);
        file.createNewFile();

        FileWriter file2 = new FileWriter(file_path+"/noti_input_"+times.toString()+".log", true);

        file2.write("\n************************************************\n");
        file2.write("\n P_TID : " 	            + paramMap.get("P_TID"));
        file2.write("\n P_MID : " 	            + paramMap.get("P_MID"));
        file2.write("\n P_AUTH_DT : " 	        + paramMap.get("P_AUTH_DT"));
        file2.write("\n P_STATUS : " 	        + paramMap.get("P_STATUS"));
        file2.write("\n P_TYPE : " 	            + paramMap.get("P_TYPE"));
        file2.write("\n P_OID : " 	            + paramMap.get("P_OID"));
        file2.write("\n P_FN_CD1 : " 	        + paramMap.get("P_FN_CD1"));
        file2.write("\n P_FN_CD2 : " 	        + paramMap.get("P_FN_CD2"));
        file2.write("\n P_FN_NM : " 	        + paramMap.get("P_FN_NM"));
        file2.write("\n P_AMT : " 	            + paramMap.get("P_AMT"));
        file2.write("\n P_UNAME : " 	        + paramMap.get("P_UNAME"));
        file2.write("\n P_RMESG1 : " 	        + paramMap.get("P_RMESG1"));
        file2.write("\n P_RMESG2 : " 	        + paramMap.get("P_RMESG2"));
        file2.write("\n P_NOTI : " 	            + paramMap.get("P_NOTI"));
        file2.write("\n P_AUTH_NO : "           + paramMap.get("P_AUTH_NO"));
        file2.write("\n P_CARD_ISSUER_CODE : "  + paramMap.get("P_CARD_ISSUER_CODE"));
        file2.write("\n P_CARD_NUM : "          + paramMap.get("P_CARD_NUM"));

        file2.write("\n************************알리페이 /텐페이 추가 정보 ***********************");
        file2.write("\n P_RESULTCD : "          + paramMap.get("P_RESULTCD"));
        file2.write("\n P_RESULTMSG : "         + paramMap.get("P_RESULTMSG"));
        file2.write("\n P_EXRATE : "            + paramMap.get("P_EXRATE"));
        file2.write("\n P_HASH : "              + paramMap.get("P_HASH"));
        file2.write("\n************************알리페이 추가 정보 ***********************");
        file2.write("\n************************알리페이 모바일 추가 정보 ***********************");
        file2.write("\n P_KOR_AMT : "           + paramMap.get("P_KOR_AMT"));//원화거래금액
        file2.write("\n P_EXCHANGE_RATE : "     + paramMap.get("P_EXCHANGE_RATE")); //환율정보
        file2.write("\n************************알리페이 모바일 추가 정보 ***********************");

        file2.write("\n************************************************");
        file2.write("\r\n\r\n");
        file2.close();
        try {
            //TODO... 디비에 저장
            if(paramMap.get("P_TID")!=null && !paramMap.get("P_TID").equals("")) {
                int resultCnt = orderService.insertIniCisNotiInfo(paramMap);
            }
            mv.addObject("result", "OK");
        }catch(Exception e){
            mv.addObject("result", "");
            return mv;
        }
        return mv;
    }


    // 이니시스팝업닫기
    @RequestMapping(value = "/inicis-close")
    public ModelAndView inicis_close(@Validated InicisPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/order/include/inicis/inicis_close");
        log.debug("inicis_close");
        return mv;
    }

    // 이니시스 팝업열기
    @RequestMapping(value = "/inicis-popup")
    public ModelAndView inicis_popup(@Validated InicisPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/order/include/inicis/inicis_popup");
        log.debug("inicis_popup");
        return mv;
    }

    // 올더게이트 approve 페이지 (모바일)
    @RequestMapping(value = "/ags-mobile-approve")
    public String AGSMobile_approve(@Validated OrderPO po, HttpServletRequest request, RedirectAttributes redirectAttr)
            throws Exception {
        po = (OrderPO) SessionUtil.getSessionAttribute(request, "OrderPO");
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        //
        // 올더게이트 모바일 승인 페이지 (euc-kr)
        //
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        String tracking_id = request.getParameter("tracking_id");
        String transaction = request.getParameter("transaction");
        String store_id = request.getParameter("StoreId");

        // 4. 주문 결제(PG결제, 마켓포인트결제, 쿠폰정보, 상품수량 업데이트)
        OrderPO orderPO = new OrderPO();
        ResultModel<OrderPO> result = (ResultModel<OrderPO>) SessionUtil.getSessionAttribute(request, "result");
        orderPO = result.getData();
        OrderPayPO orderPayPO = new OrderPayPO();
        orderPayPO.setSiteNo(po.getSiteNo());
        orderPayPO.setPaymentWayCd((String) SessionUtil.getSessionAttribute(request, "paymentWayCd"));
        orderPayPO.setPaymentPgCd((String) SessionUtil.getSessionAttribute(request, "paymentPgCd"));
        orderPayPO.setOrdNo(po.getOrdNo());
        orderPayPO.setPaymentAmt(po.getPaymentAmt());
        orderPO.setOrderPayPO(orderPayPO);

        log.debug("=== orderPO.orderPayPO : {}", orderPO.getOrderPayPO());
        ModelAndView mav = new ModelAndView();
        Map<String, Object> reqMap = (Map<String, Object>) SessionUtil.getSessionAttribute(request, "reqMap");
        reqMap.put("tracking_id", tracking_id);
        reqMap.put("transaction", transaction);
        reqMap.put("store_id", store_id);
        ResultModel<OrderPO> payResult = orderService.orderPaymentMobile(orderPO, request, reqMap, mav);
        if (!payResult.isSuccess()) {
            redirectAttr.addFlashAttribute("exMsg", result.getMessage());
            return View.redirect("/front/common/error");
        }

        // 5. 주문완료 페이지로 이동
        redirectAttr.addFlashAttribute("orderPO", po);
        return View.redirect("/front/order/order-payment-complete");
    }

    // 올더게이트 cancel (모바일)
    @RequestMapping(value = "/ags-mobile-cancel")
    public ModelAndView AGSMobile_user_cancel(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/order/include/04/AGSMobile_user_cancel");
        return mv;
    }

    // 올더게이트 입금통보
    @RequestMapping(value = "/ags-mobile-virtual")
    public ModelAndView AGSMobile_virtual_result(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/order/include/04/AGSMobile_virtual_result");
        return mv;
    }

    // 팝업열기 크로스도메인 우회
    @RequestMapping(value = "/inicis-stdpay-relay")
    public ModelAndView ini_stdpay_relay(@Validated InicisPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/order/include/inicis/inicis_relay");
        log.debug("ini_stdpay_relay");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 결제 완료
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/order-payment-complete")
    public ModelAndView orderPaymentDone(@Validated OrderPO po, BindingResult bindingResult, HttpServletRequest request)
            throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/order/order_payment_done");
        // 필수 파라메터 확인
        // 각종 검증
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        long ordNo = po.getOrdNo();

        OrderInfoVO orderInfoVo = new OrderInfoVO();
        orderInfoVo.setOrdNo(Long.toString(ordNo));
        orderInfoVo.setSiteNo(po.getSiteNo());
        OrderVO vo = orderService.selectOrdDtl(orderInfoVo);

        // 배송비 계산
        String type = "order";
        Map map = orderService.calcDlvrAmt(vo.getOrderGoodsVO(), type);
        List<OrderGoodsVO> list = (List<OrderGoodsVO>) map.get("list");
        Map dlvrPriceMap = (Map) map.get("dlvrPriceMap");
        Map dlvrCountMap = (Map) map.get("dlvrCountMap");

        vo.setOrderGoodsVO(list);

        List<OrderGoodsVO> listVo = new ArrayList<OrderGoodsVO>();


        // 다비치 상품일 경우 결제완료후 바로 배송준비중(MD확정처리)
        for (OrderGoodsVO gvo : vo.getOrderGoodsVO()) {
              if(gvo.getOrdDtlStatusCd().equals("20") && gvo.getSellerNo().equals("1")){
                  OrderGoodsVO vo2 = new OrderGoodsVO();
                    vo2.setOrdNo(gvo.getOrdNo());
                    vo2.setOrdStatusCd("30");
                    vo2.setCurOrdStatusCd("20");
                    vo2.setOrdDtlSeq(gvo.getOrdDtlSeq());
                    vo2.setMdConfirmYn("Y");
                    if (!SessionDetailHelper.getDetails().isLogin()) {
                        vo2.setRegrNo((long) 0.00);
                    }
                    listVo.add(vo2);
              }
        }
        if(listVo.size()>0) {
            orderService.updateOrdListStatus(listVo, "20");
        }


        //첫구매상품 쿠폰 발행

        CouponPO cpIssueResult = new CouponPO();
        //회원구매일 경우만
        if (SessionDetailHelper.getDetails().isLogin()) {
            for (OrderGoodsVO gvo : vo.getOrderGoodsVO()) {
                if (gvo.getFirstCouponAvailableYn().equals("Y") && gvo.getFirstCouponIssueYn().equals("N")) {
                    CouponPO cpo = new CouponPO();
                    cpo.setOrdNo(ordNo);
                    cpo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    cpo.setGoodsNo(gvo.getGoodsNo());
                    cpIssueResult = couponService.firstOrdCoupon(cpo).getData();

                    //한번만 발행
                    break;
                }
            }
        }

        mav.addObject("cpIssueResult", cpIssueResult);
        mav.addObject("dlvrPriceMap", dlvrPriceMap);
        mav.addObject("dlvrCountMap", dlvrCountMap);

        mav.addObject("orderVO", vo);

        return mav;
    }

    // 비회원 주문 여부 조회
    @RequestMapping("/nomember-order-check")
    public @ResponseBody ResultModel<OrderVO> selectNonMemberOrder(OrderSO so) {
        ResultModel<OrderVO> result = new ResultModel<>();
        result.setSuccess(orderService.selectNonMemberOrder(so));
        return result;
    }

    // 비회원 주문내역 조회
    @RequestMapping(value = "/nomember-order-list")
    public ModelAndView nonmemberOrderList(OrderSO so) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/nonmember/nonmember_order_list");

        if (so.getOrdrMobile() == null || "".equals(so.getOrdrMobile())) {
            ModelAndView mavErr = new ModelAndView("error/notice");
            mavErr.addObject("exMsg", MessageUtil.getMessage("front.web.common.wrongapproach"));
            return mavErr;
        }

        String ordrMobile = so.getOrdrMobile();
        so.setNonOrdrMobile(StringUtil.formatPhone(ordrMobile));
        // 주문/배송조회
        so.setOrdrMobile(StringUtil.formatPhone(ordrMobile));
        String[] ordDtlStatusCd = { "10", "20", "30", "40", "50", "90" };
        so.setOrdDtlStatusCd(ordDtlStatusCd);
        ResultListModel<OrderVO> order_list = orderService.selectOrdListFrontPaging(so);

        // 주문 취소/교환/환불
        so.setOrdrMobile(StringUtil.formatPhone(ordrMobile));
        String[] ordDtlStatusCdCancel = { "11", "21", "60", "66", "70", "74" };
        so.setOrdDtlStatusCd(ordDtlStatusCdCancel);
        ResultListModel<OrderVO> order_cancel_list = orderService.selectOrdListFrontPaging(so);

        mv.addObject("order_list", order_list);
        mv.addObject("order_cancel_list", order_cancel_list);
        mv.addObject("so", so);
        return mv;
    }

    // 비회원 주문상세정보 조회
    @RequestMapping(value = "/nomember-order-detail")
    public ModelAndView nonmerberOrderDetail(OrderInfoVO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/nonmember/nonmember_order_detail");
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        OrderVO result = orderService.selectOrdDtl(so);
        String ordStatus = result.getOrderInfoVO().getOrdStatusCd();
        String billYn = "N";
        // 매출증빙 조회 /발급 가능상태
        if ("20".equals(ordStatus) || "30".equals(ordStatus) || "39".equals(ordStatus) || "40".equals(ordStatus)
                || "49".equals(ordStatus) || "50".equals(ordStatus) || "90".equals(ordStatus)) {
            billYn = "Y";
        }
        mav.addObject("billYn", billYn);
        SalesProofVO vo = new SalesProofVO();
        vo.setOrdNo(so.getOrdNo());
        vo.setSiteNo(so.getSiteNo());
        vo.setProofType("02");// 현금영수증
        ResultModel<SalesProofVO> cash_bill_info = salesProofService.selectSalesProofOrdNo(vo);
        vo.setProofType("03");// 현금영수증
        ResultModel<SalesProofVO> tax_bill_info = salesProofService.selectSalesProofOrdNo(vo);
        mav.addObject("so", so);
        mav.addObject("leftMenu", "order_list");
        mav.addObject("order_info", result);
        mav.addObject("cash_bill_info", cash_bill_info);
        mav.addObject("tax_bill_info", tax_bill_info);

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : dong
     * 설명   : 페이팔 결제 결과 수신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/paypal-result")
    public ModelAndView paypalResult(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView("/order/include/paypal_return");
        Hashtable<String, String> result = new Hashtable<String, String>();
        Enumeration<String> elems = request.getParameterNames();
        String temp = "";

        while (elems.hasMoreElements()) {
            temp = elems.nextElement();
            result.put(temp, request.getParameter(temp).toString().trim());
            // log.debug("PAYPAL RESPONSE DATA : {}", temp + " :::: " +
            // request.getParameter(temp).toString().trim());
            // request.getParameter(temp).toString().trim());
        }

        // 테스트용 데이터
        // result.put("resultcode", "00");
        // result.put("resultmessage", "페이팔 결제 성공");
        // result.put("mid", "INIpayTest");
        // result.put("tid", "INIStdPPAYINIpayTest20160708104312302986");
        // result.put("webordernumber", "1607081043050430");
        // result.put("goodname", "테스트상품");
        // result.put("orgprice", "orgprice");
        // result.put("authdate", "20160708");
        // result.put("authtime", "120214");

        // 수신받은 데이터는 Hash형식이기때문에 key=value형식으로 표시되어 jquery에서 제어하기가 불편하다.
        // 따라서 map to json을 하여 key:value 형식으로 변경한다.
        ObjectMapper mapper = new ObjectMapper();
        mav.addObject("result", mapper.writeValueAsString(result));
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : dong
     * 설명   : 알리페이 결제 결과 수신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/alipay-result")
    public ModelAndView alipayResult(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView("/order/include/alipay_return");
        Hashtable<String, String> result = new Hashtable<String, String>();
        Enumeration<String> elems = request.getParameterNames();
        String temp = "";

        while (elems.hasMoreElements()) {
            temp = elems.nextElement();
            result.put(temp, request.getParameter(temp).toString().trim());
        }

        // 수신받은 데이터는 Hash형식이기때문에 key=value형식으로 표시되어 jquery에서 제어하기가 불편하다.
        // 따라서 map to json을 하여 key:value 형식으로 변경한다.
        ObjectMapper mapper = new ObjectMapper();
        mav.addObject("result", mapper.writeValueAsString(result));
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : dong
     * 설명   : 알리페이 결제 결과 수신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/tenpay-result")
    public ModelAndView tenpayResult(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView("/order/include/tenpay_return");
        Hashtable<String, String> result = new Hashtable<String, String>();
        Enumeration<String> elems = request.getParameterNames();
        String temp = "";

        while (elems.hasMoreElements()) {
            temp = elems.nextElement();
            result.put(temp, request.getParameter(temp).toString().trim());
        }

        // 수신받은 데이터는 Hash형식이기때문에 key=value형식으로 표시되어 jquery에서 제어하기가 불편하다.
        // 따라서 map to json을 하여 key:value 형식으로 변경한다.
        ObjectMapper mapper = new ObjectMapper();
        mav.addObject("result", mapper.writeValueAsString(result));
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 페이팔 HASH 데이터 생성
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/paypal-hashdata-info")
    public @ResponseBody ResultModel<PaypalPO> getPaypalHashData(PaypalPO po) {
        ResultModel<CommPaymentConfigVO> paypalConfig = paymentManageService.selectForeignPaymentConfig(po.getSiteNo());
        po.setMid(paypalConfig.getData().getFrgPaymentStoreId());
        po.setMerchantKey(paypalConfig.getData().getFrgPaymentPw());
        ResultModel<PaypalPO> result = orderService.getPaypalHashData(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 알리페이 HASH 데이터 생성
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/alipay-hashdata-info")
    public @ResponseBody ResultModel<AlipayPO> getAlipayHashData(AlipayPO po) {
        ResultModel<CommPaymentConfigVO> alipayConfig = paymentManageService.selectAlipayPaymentConfig(po.getSiteNo());
        po.setMid(alipayConfig.getData().getAlipayPaymentStoreId());
        po.setMerchantKey(alipayConfig.getData().getAlipayPaymentPw());
        ResultModel<AlipayPO> result = orderService.getAlipayHashData(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 텐페이 HASH 데이터 생성
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/tenpay-hashdata-info")
    public @ResponseBody ResultModel<TenpayPO> getAlipayHashData(TenpayPO po) {
        ResultModel<CommPaymentConfigVO> alipayConfig = paymentManageService.selectTenpayPaymentConfig(po.getSiteNo());
        po.setMid(alipayConfig.getData().getTenpayPaymentStoreId());
        po.setMerchantKey(alipayConfig.getData().getTenpayPaymentPw());
        ResultModel<TenpayPO> result = orderService.getTenpayHashData(po);
        return result;
    }

    /**
     * -----------------------------------------------------------------------
     * PAYCO 구매예약처리
     * ------------------------------------------------------------------------
     *
     * @author PAYCO기술지원<dl_payco_ts@nhnent.com>
     * @since
     * @version
     * @Description
     *              가맹점에서 전달한 파라미터를 받아 JSON 형태로 페이코API 와 통신한다.
     */
    @RequestMapping("/payco-reserve")
    public @ResponseBody String paycoReserve(PaycoPO paycoPO) throws Exception {
        ObjectMapper mapper = new ObjectMapper(); // jackson json object

        // 간편결제 설정 조회
        SimplePaymentConfigSO simplePaymentConfigSO = new SimplePaymentConfigSO();
        simplePaymentConfigSO.setSiteNo(paycoPO.getSiteNo());
        simplePaymentConfigSO.setSimpPgCd("41");
        ResultModel<SimplePaymentConfigVO> simplePaymentConfig = paymentManageService
                .selectSimplePaymentConfig(simplePaymentConfigSO);
        paycoPO.setSellerKey(simplePaymentConfig.getData().getFrcCd());
        paycoPO.setCpId(simplePaymentConfig.getData().getStoreId());
        paycoPO.setProductId(simplePaymentConfig.getData().getStorePw());

        String serverType = "";
        if ("Y".equals(realServiceYn)) {
            serverType = "REAL";
        } else {
            serverType = "DEV";
        }
        PaycoUtil util = new PaycoUtil(serverType); // CommonUtil

        // 상품값으로 읽은 변수들로 Json String 을 작성합니다.
        List<Map<String, Object>> orderProducts = new ArrayList<Map<String, Object>>();

        Map<String, Object> productInfo = new HashMap<String, Object>();
        productInfo.put("cpId", paycoPO.getCpId()); // [필수]상점ID
        productInfo.put("productId", paycoPO.getProductId()); // [필수]상품ID
        productInfo.put("productAmt", paycoPO.getProductAmt()); // [필수]상품금액(상품단가
                                                                // * 수량)
        productInfo.put("productPaymentAmt", paycoPO.getTotalPaymentAmt()); // [필수]상품결제금액(상품결제단가
                                                                            // *
                                                                            // 수량)
        productInfo.put("orderQuantity", paycoPO.getOrderQuantity()); // [필수]주문수량(배송비
                                                                      // 상품인 경우
                                                                      // 1로 셋팅)
        productInfo.put("sortOrdering", paycoPO.getSortOrdering()); // [필수]상품
                                                                    // 노출순서
        productInfo.put("productName", paycoPO.getProductName()); // [필수]상품명
        productInfo.put("sellerOrderProductReferenceKey", paycoPO.getSellerOrderProductReferenceKey()); // [필수]외부가맹점에서
                                                                                                        // 관리하는
                                                                                                        // 주문상품
                                                                                                        // 연동
                                                                                                        // 키
        orderProducts.add(productInfo);

        // 설정한 주문정보로 Json String 을 작성합니다.
        Map<String, Object> orderInfo = new HashMap<String, Object>();
        orderInfo.put("sellerKey", paycoPO.getSellerKey()); // [필수]가맹점 코드
        orderInfo.put("sellerOrderReferenceKey", paycoPO.getCustomerOrderNumber()); // [필수]외부가맹점
                                                                                    // 주문번호
        orderInfo.put("sellerOrderReferenceKeyType", paycoPO.getSellerOrderReferenceKeyType()); // [선택]외부가맹점의
                                                                                                // 주문번호
                                                                                                // 타입
        orderInfo.put("totalPaymentAmt", paycoPO.getTotalPaymentAmt()); // [필수]총
                                                                        // 결제금액(면세금액,과세금액,부가세의
                                                                        // 합)
        orderInfo.put("returnUrl", paycoPO.getReturnUrl()); // [선택]주문완료 후
                                                            // Redirect 되는 URL

        Hashtable<String, String> resultMap = new Hashtable<String, String>();
        resultMap.put("authTotalPaymentAmt", String.valueOf(paycoPO.getTotalPaymentAmt()));
        resultMap.put("logYn", paycoPO.getLogYn());
        resultMap.put("serverType", serverType);
        ObjectMapper resultMapper = new ObjectMapper();
        orderInfo.put("returnUrlParam", resultMapper.writeValueAsString(resultMap)); // [선택]주문완료
                                                                                     // 후
                                                                                     // Redirect
                                                                                     // 되는
                                                                                     // URL
        orderInfo.put("orderMethod", "EASYPAY"); // [필수]주문유형
        orderInfo.put("orderChannel", "PC"); // [선택]주문채널
        orderInfo.put("orderSheetUiType", "GRAY"); // [선택]주문서 UI타입 선택
        orderInfo.put("payMode", "PAY2"); // [선택]결제모드(PAY1 : 결제인증,승인통합 / PAY2 :
                                          // 결제인증,승인분리)
        orderInfo.put("orderProducts", orderProducts); // [필수]주문상품 리스트

        /* 부가정보(extraData) - Json 형태의 String */
        Map<String, Object> extraData = new HashMap<String, Object>();
        // extraData.put("payExpiryYmdt", "20160710180000"); // [선택]해당 주문예약건 만료
        // 처리 일시 (해당 일시 이후에는 결제 불가)(14자리로 맞춰주세요)
        orderInfo.put("extraData", mapper.writeValueAsString(extraData).toString().replaceAll("\"", "\\\"")); // [선택]부가정보
                                                                                                              // Json
                                                                                                              // 형태의
                                                                                                              // String
        orderInfo.put("siteNo", paycoPO.getSiteNo());
        orderInfo.put("path", SYSTEM_LOG_ROOT_PATH);

        // 주문예약 API 호출 함수
        String result = util.payco_reserve(orderInfo, paycoPO.getLogYn());
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 페이코 결제 결과 수신
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/payco-result")
    public ModelAndView paycoResult(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView("/order/include/payco/payco_return");
        /* 인증 데이타 변수선언 */
        Hashtable<String, String> resultMap = new Hashtable<String, String>();
        String reserveOrderNo = request.getParameter("reserveOrderNo"); // 주문예약번호
        String sellerOrderReferenceKey = request.getParameter("sellerOrderReferenceKey"); // 가맹점주문연동키
        String paymentCertifyToken = request.getParameter("paymentCertifyToken"); // 결제인증토큰(결제승인시필요)
        String code = request.getParameter("code");
        String authTotalPaymentAmt = request.getParameter("authTotalPaymentAmt");
        String logYn = request.getParameter("logYn");
        String serverType = request.getParameter("serverType");
        String totalPaymentAmt = "0";

        if (request.getParameter("totalPaymentAmt") == null) { // 총 결제금액
            totalPaymentAmt = "0";

        } else {
            totalPaymentAmt = request.getParameter("totalPaymentAmt").toString();
        }
        resultMap.put("reserveOrderNo", reserveOrderNo);
        resultMap.put("sellerOrderReferenceKey", sellerOrderReferenceKey);
        resultMap.put("paymentCertifyToken", paymentCertifyToken);
        resultMap.put("totalPaymentAmt", totalPaymentAmt);
        resultMap.put("code", code);
        resultMap.put("authTotalPaymentAmt", authTotalPaymentAmt);
        resultMap.put("logYn", logYn);
        resultMap.put("serverType", serverType);

        ObjectMapper resultMapper = new ObjectMapper();
        mav.addObject("result", resultMapper.writeValueAsString(resultMap));
        return mav;
    }

    @RequestMapping(value = "/payco-cancel")
    public ModelAndView paycoCancel(PaymentModel reqPaymentModel, BindingResult bindingResult,
                                    @RequestParam Map<String, Object> reqMap, HttpSession session, SessionStatus sessionStatus)
            throws Exception {
        log.debug("================================");
        log.debug("Start : " + "인증요청 결과페이지 (RETURNURL)(PAYCO+전용)");
        log.debug("================================");

        ModelAndView mav = new ModelAndView("/order/include/payco_cancel");
        return mav;
    }

    @RequestMapping(value = "/sample-payco-cancel")
    public ModelAndView sampleReturnurlNew(PaymentModel reqPaymentModel, BindingResult bindingResult,
                                           @RequestParam Map<String, Object> reqMap, HttpSession session, SessionStatus sessionStatus)
            throws Exception {
        log.debug("================================");
        log.debug("Start : " + "인증요청 결과페이지 (RETURNURL)(PAYCO+전용)");
        log.debug("================================");

        ModelAndView mav = new ModelAndView("/order/include/payco/payco_cancel");
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : KNG
     * 설명   : 결제인증요청 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. KNG - 최초생성
     * </pre>
     *
     * @param paymentPgCd
     * @param reqPaymentModel
     * @param bindingResult
     * @param reqMap
     * @return
     * @throws Exception
     */
    @RequestMapping("/{paymentPgCd}/cert")
    public @ResponseBody ResultModel<PaymentModel<?>> Cert(@PathVariable String paymentPgCd,
            PaymentModel reqPaymentModel, BindingResult bindingResult, @RequestParam Map<String, Object> reqMap)
            throws Exception {
        log.debug("================================");
        log.debug("Start : " + "결제인증요청 페이지");
        log.debug("================================");
        ModelAndView mav = new ModelAndView();
        ResultModel<PaymentModel<?>> rsm = new ResultModel();
        boolean servicYn = false;
        switch (paymentPgCd) {
        case CoreConstants.PG_CD_LGU:
            // mav.setViewName(paymentSamplePath + CoreConstants.PG_CD_LGU + "/PayreqCrossplatform");
            servicYn = true;
            break;
        case CoreConstants.PG_CD_ALLTHEGATE:
            // mav.setViewName(paymentSamplePath + CoreConstants.PG_CD_ALLTHEGATE + "/AGS_pay");
            servicYn = true;
            break;
        }

        if (!servicYn) {
            rsm.setSuccess(false); // 접근에러 처리
        } else {
            CommPaymentConfigSO so = new CommPaymentConfigSO();
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            so.setPgCd(paymentPgCd);
            CommPaymentConfigVO vo = paymentManageService.selectCommPaymentConfig(so).getData();
            reqPaymentModel.setPgId(vo.getPgId());
            reqPaymentModel.setPgKey(vo.getPgKey());
            reqPaymentModel.setPgKey2(vo.getPgKey2());
            reqPaymentModel.setPgKey3(vo.getPgKey3());
            reqPaymentModel.setPgKey4(vo.getPgKey4());
            reqPaymentModel.setKeyPasswd(vo.getKeyPasswd());
            reqPaymentModel.setPaymentPgCd(paymentPgCd);
            reqPaymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            rsm = paymentAdapterService.cert(reqPaymentModel, reqMap, mav);
            if (!rsm.isSuccess()) {
                log.debug("### 처리에러 발생 ## ==> " + rsm.getMessage());
            }
        }
        return rsm;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : KNG
     * 설명   : 결제인증요청 결과 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. KNG - 최초생성
     * </pre>
     *
     * @param paymentPgCd
     * @param reqPaymentModel
     * @param bindingResult
     * @param reqMap
     * @return
     * @throws Exception
     */
    @RequestMapping("/{paymentPgCd}/cert-return")
    public ModelAndView certReturn(@PathVariable String paymentPgCd, PaymentModel reqPaymentModel,
            BindingResult bindingResult, @RequestParam Map<String, Object> reqMap, HttpSession session,
            SessionStatus sessionStatus) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "인증요청 결과페이지 (RETURNURL)(LGU+전용)");
        log.debug("================================");
        ModelAndView mav = new ModelAndView();
        ResultModel<PaymentModel<?>> rsm = new ResultModel();
        boolean servicYn = false;
        switch (paymentPgCd) {
        case CoreConstants.PG_CD_LGU:
            mav.setViewName("/order/include/03/Returnurl");
            servicYn = true;
            break;
        }

        if (!servicYn) {
            // <entry key="biz.exception.common.not.support.service">지원하지 않는 서비스입니다.</entry>
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.common.not.support.service"));
            mav.setViewName("/error/error");
            return mav;
        } else {
            CommPaymentConfigSO so = new CommPaymentConfigSO();
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            so.setPgCd(paymentPgCd);
            CommPaymentConfigVO vo = paymentManageService.selectCommPaymentConfig(so).getData();
            reqPaymentModel.setPgId(vo.getPgId());
            reqPaymentModel.setPgKey(vo.getPgKey());
            reqPaymentModel.setPgKey2(vo.getPgKey2());
            reqPaymentModel.setPgKey3(vo.getPgKey3());
            reqPaymentModel.setPgKey4(vo.getPgKey4());
            reqPaymentModel.setKeyPasswd(vo.getKeyPasswd());
            reqPaymentModel.setPaymentPgCd(paymentPgCd);
            reqPaymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            rsm = paymentAdapterService.certReturn(reqPaymentModel, reqMap, mav);
            if (!rsm.isSuccess()) {
                log.debug("### 처리에러 발생 ## ==> " + rsm.getMessage());
            }
        }
        return mav;
    }

    // 묶음배송비 계산(AJax)
    @RequestMapping("/bundle-delivery-amt")
    public @ResponseBody ResultModel<OrderGoodsVO> calcDlvrAmt(@Validated OrderPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<OrderGoodsVO> result = new ResultModel<>();
        boolean dlvrChangeYn = false;
        dlvrChangeYn = orderService.changeDlvrPriceYn(po);
        log.debug("기존 배송비 변경 여부 : " + dlvrChangeYn);
        OrderGoodsVO orderGoodsVo = new OrderGoodsVO();
        orderGoodsVo.setDlvrChangeYn(dlvrChangeYn);
        result.setData(orderGoodsVo);
        return result;
    }

    /*********************************************** 매출증빙 *********************************************************/

    // 현금영수증 발급신청(AJax)
    @RequestMapping("/cash-receipt-apply")
    public @ResponseBody ResultModel<SalesProofVO> applyCashReceipt(@Validated SalesProofPO salesProofPO,
            @RequestParam Map<String, Object> reqMap) throws Exception {

        OrderInfoVO vo = new OrderInfoVO();
        vo.setSiteNo(salesProofPO.getSiteNo());
        vo.setOrdNo(Long.toString(salesProofPO.getOrdNo()));
        List<OrderPayVO> orderPaylist = orderService.selectOrderPayInfoList(vo);
        String paymentPgCd = "";
        for (int i = 0; i < orderPaylist.size(); i++) {
            OrderPayVO orderPayVO = orderPaylist.get(i);
            if ("11".equals(orderPayVO.getPaymentWayCd()) || "21".equals(orderPayVO.getPaymentWayCd())
                    || "22".equals(orderPayVO.getPaymentWayCd())) {
                paymentPgCd = orderPayVO.getPaymentPgCd();
            }
        }
        ResultModel<SalesProofVO> result = new ResultModel<SalesProofVO>();
        if ("".equals(paymentPgCd)) {
            result.setMessage("현금영수증 발급 가능한 결제수단이 아닙니다.");
            result.setSuccess(false);
        } else {
            salesProofPO.setApplicantGbCd("01");
            salesProofPO.setPaymentPgCd(paymentPgCd);// pg사 코드
            if ("00".equals(paymentPgCd)) {
                salesProofPO.setCashRctStatusCd("01"); // 접수
                result = salesProofService.insertCashRct(salesProofPO);
                if (!result.isSuccess()) {
                    result.setMessage("현금영수증 신청에 실패하였습니다.<br>관리자에게 문의 바랍니다.");
                }
            } else {
                salesProofPO.setReqMode("pay");
                result = salesProofService.insertCashRctIssue(salesProofPO, reqMap);
                if (!result.isSuccess()) {
                    result.setMessage("현금영수증 발행에 실패하였습니다.<br>관리자에게 문의 바랍니다.");
                }
            }
        }
        return result;
    }

    // 세금계산서 발급신청(AJax)
    @RequestMapping("/tax-bill-apply")
    public @ResponseBody ResultModel<SalesProofVO> applyTaxBill(@Validated SalesProofPO po, BindingResult bindingResult)
            throws Exception {
        long totAmt = po.getTotAmt();// 총금액
        po.setSupplyAmt(Math.round((totAmt / 1.1)));// 공급가액
        po.setVatAmt((totAmt - (Math.round((totAmt / 1.1)))));/* 부가세금액 */
        po.setTaxBillStatusCd("1");/* 세금 계산서상태(1:접수,2:승인,3:보류) */
        po.setApplicantGbCd("01");/* 신청자구분코드(01:구매자,02:관리자) */
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        po.setMemberNo(memberNo);/* 회원번호 */
        ResultModel<SalesProofVO> result = salesProofService.insertTaxBill(po);
        return result;
    }

    /*********************************************** 매출증빙 *********************************************************/


    @Value("#{core['core.payment.kcp.gConfServer']}")
    private boolean g_conf_server;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : KDY
     * 설명   : KCP APPROVAL 모바일전용
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. KMS - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/order-approval")
    public ModelAndView orderApproval(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("/order/include/01/kcp_approval");
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 12.
     * 작성자 : dong
     * 설명   : 구매 확정 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 12. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/buy-confirm-update")
    public @ResponseBody ResultModel<OrderInfoVO> updateBuyConfirm(@Validated OrderPO po, BindingResult bindingResult) throws Exception {
        ResultModel<OrderInfoVO> result = new ResultModel<>();

        OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
        orderGoodsVO.setSiteNo(po.getSiteNo());
        orderGoodsVO.setOrdNo(Long.toString(po.getOrdNo()));
        orderGoodsVO.setOrdDtlSeq(Long.toString(po.getOrdDtlSeq()));
        orderGoodsVO.setOrdStatusCd("90"); // 구매확정
        OrderGoodsVO curVo = orderService.selectCurOrdStatus(orderGoodsVO);
        String curOrdStatusCd = curVo.getOrdStatusCd(); // 현재 상태
        if (SessionDetailHelper.getDetails().isLogin()) {
            orderGoodsVO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }else {
        	orderGoodsVO.setUpdrNo((long)0.00);
        	orderGoodsVO.setRegrNo((long)0.00);
        }
        result = orderService.updateOrdStatus(orderGoodsVO, curOrdStatusCd);

        return result;
    }

    // 주문 데이터 선 저장
    @RequestMapping("/mobile-pg-start")
    public @ResponseBody ResultModel<OrderPO> mobilePGStart(@Validated OrderPO po, BindingResult bindingResult,
                                                            HttpServletRequest request, @RequestParam Map<String, Object> reqMap) throws Exception {

        ModelAndView mav = new ModelAndView();

        // 1. 필수 파라메터 검증
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new Exception("파라메터 오류");
        }
        Date today = new Date();
        po.setRegDttm(today); // 주문시 모든 등록일자를 동일하게 맞추기 위해 설정
        // 2.상품정보 검증

        // 3. 주문 등록(주문정보, 상품정보, 배송비 정보, 배송정보, 부가비용)

        ResultModel<OrderPO> result = orderService.insertOrder(po, request);

        SessionUtil.setSessionAttribute(request, "result", result);
        SessionUtil.setSessionAttribute(request, "OrderPO", po);
        SessionUtil.setSessionAttribute(request, "paymentWayCd", request.getParameter("paymentWayCd"));
        SessionUtil.setSessionAttribute(request, "paymentPgCd", request.getParameter("paymentPgCd"));

        // SessionUtil.setSessionAttribute(request,"mav",mav);
        SessionUtil.setSessionAttribute(request, "reqMap", reqMap);

        return result;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 주문취소/교환/환불접수 상세내역조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/order-cancel-detail")
    public ModelAndView orderCancelDtlLayer(@Validated OrderSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/order_cancel_layer");
        ResultListModel<OrderVO> orderVO = orderService.orderCancelDtlInfo(so);
        mav.addObject("orderVO", orderVO);
        mav.addObject("so", so);
        return mav;
    }


    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 자주쓰는 배송지 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/myDelivery-list")
    public ModelAndView selectDeliveryList(@Validated MemberDeliverySO so, BindingResult bindingResult) {
        ModelAndView mav = SiteUtil.getSkinView("/order/myDelivery_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        mav.addObject("so", so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        mav.addObject("resultListModel", frontMemberService.selectDeliveryListPaging(so));
        return mav;
    }
}
