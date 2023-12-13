package net.danvi.dmall.admin.web.view.seller.order;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.order.exchange.service.ExchangeService;
import net.danvi.dmall.biz.app.order.manage.model.*;
import net.danvi.dmall.biz.app.order.refund.service.RefundService;
import net.danvi.dmall.biz.common.service.CodeCacheService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.main.service.MainService;
import net.danvi.dmall.biz.app.order.delivery.model.DeliverySO;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryVO;
import net.danvi.dmall.biz.app.order.delivery.service.DeliveryService;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.MenuService;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2017. 11. 16.
 * 작성자     : 
 * 설명       : 판매자 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/seller/order")
public class SellerOrderController {

    @Resource(name = "adminMainService")
    private MainService mainService;    
    
    @Resource(name = "sellerService")
    private SellerService sellerService;
    
    @Resource(name = "menuService")
    private MenuService menuService;
    
    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    @Resource(name = "orderService")
    private OrderService orderService;
    
    @Resource(name = "deliveryService")
    private DeliveryService deliveryService;

    @Resource(name = "refundService")
    private RefundService refundService;

    @Resource(name = "exchangeService")
    private ExchangeService exchangeService;

    @Resource(name = "codeCacheService")
    private CodeCacheService codeCacheService;

    @RequestMapping("/order-status")
    public ModelAndView viewOrdListPaging(OrderSO ordSO) {
        log.debug("================================");
        log.debug("Start : " + "주문 목록 화면");
        log.debug("================================");

        List<CmnCdDtlVO> codeOn = ServiceUtil.listCode("ORD_DTL_STATUS_CD", null, "ON", null, null, null);
        List<CmnCdDtlVO> codeOff = ServiceUtil.listCode("ORD_DTL_STATUS_CD", null, "OFF", null, null, null);

        // 주문 상태별 버튼 색상 조정
        ModelAndView mv = new ModelAndView("/admin/seller/order/viewOrdListPaging");
        mv.addObject("ordSO", ordSO);
        mv.addObject("codeOffList", codeOff);
        mv.addObject("codeOnList", codeOn);
        mv.addObject("paymentWayCdList", ServiceUtil.listCode("PAYMENT_WAY_CD", "SEARCH", null, null, null, null));
        mv.addObject("ordMediaCdList", ServiceUtil.listCode("ORD_MEDIA_CD", null, null, null, null, null));
        mv.addObject("saleChannelCdList", ServiceUtil.listCode("SALE_CHANNEL_CD", null, null, null, null, null));

        return mv;
    }    
    
    

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 출고(배송)목록을 조회하는 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/delivery")
    public ModelAndView viewDeliveryListPaging(DeliverySO so) {
        log.debug("================================");
        log.debug("Start : " + "출고(배송)목록을 조회하는 화면");
        log.debug("================================");
        ModelAndView mv = new ModelAndView("/admin/seller/order/viewDeliveryListPaging");
        if ((so.getPage() == 0) || "".equals(so.getPage())) so.setPage(1);

        List<CmnCdDtlVO> ordStatusCdList = ServiceUtil.listCode("ORD_STATUS_CD", "ON", null, null, null, null);
        String deliveryCds = "30,40,50";
        List<CmnCdDtlVO> ordStatusCdListCopy = new ArrayList<CmnCdDtlVO>();

        for (CmnCdDtlVO vo : ordStatusCdList) {
            if (deliveryCds.indexOf(vo.getDtlCd()) > -1) ordStatusCdListCopy.add(vo);
        }
        mv.addObject("deliverySO", so);
        mv.addObject("ordStatusCdList", ordStatusCdListCopy);
        mv.addObject("saleChannelCdList", ServiceUtil.listCode("SALE_CHANNEL_CD", null, null, null, null, null));
        return mv;
    }
    
    

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 송장번호 일괄등록을 위한 목록을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/invoice-list")
    public ModelAndView viewInvoiceAddList() {
        log.debug("================================");
        log.debug("Start : " + "송장번호 일괄등록을 위한 목록을 조회한다.");
        log.debug("================================");

        ModelAndView mv = new ModelAndView("/admin/seller/order/viewInvoiceAddList");
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("courierCdList", ServiceUtil.listCode("COURIER_CD", null, null, null, null, null));
        return mv;
    }
    

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문 목록 페이징 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/order-list")
    public @ResponseBody ResultListModel<OrderInfoVO> selectOrdListPaging(OrderSO ordSO, BindingResult bindingResult)
            throws Exception {

        log.debug("================================");
        log.debug("Start : " + "viewOrdListPaging 에서 넘어온 검색조건에 맞는 주문 목록을 조회하여 리턴");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if ("02".equals(ordSO.getSearchCd()) || "03".equals(ordSO.getSearchCd())
                || "06".equals(ordSO.getSearchCd()) || "07".equals(ordSO.getSearchCd())) {
            ordSO.setSearchWord(CryptoUtil.encryptAES(ordSO.getSearchWord()));
        }
        
        ordSO.setSearchSeller(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        ordSO.setSearchSellerLogin("Y");
        ordSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        ResultListModel<OrderInfoVO> resultList = orderService.selectOrdListPaging(ordSO);
        return resultList;
    }
    
    

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문의 상세 정보를 조회하는 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-detail")
    public ModelAndView viewOrdDtl(@Validated OrderSO ordSO) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "주문의 상세 정보를 조회한다");
        log.debug("================================");

        OrderInfoVO orderInfoVo = new OrderInfoVO();
        orderInfoVo.setOrdNo(ordSO.getOrdNo());
        orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        orderInfoVo.setSellerNo(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));

        OrderVO vo = orderService.selectOrdDtl(orderInfoVo);

        OrderInfoVO rsltInfoVo = vo.getOrderInfoVO();
        List<OrderGoodsVO> orderGoodsVO = vo.getOrderGoodsVO();

        if (orderGoodsVO != null && orderGoodsVO.size() > 0) {
            boolean isFirst = true;
            String fordDtlStatusCds = "";
            String ordDtlStatusCds = "";
            String claimOrdDtlStatusCds = "";
            for (OrderGoodsVO orderVO : orderGoodsVO) {
                if(StringUtil.isNotEmpty(orderVO.getDlvrMethodCd())) {
                    if( "02".equals(orderVO.getDlvrMethodCd())) {
                        if ("배송준비중".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("상품준비중");
                        } else if ("배송완료".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("픽업가능");
                        } else if ("구매확정".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("픽업완료");
                        }
                    }
                } else {
                    if ("04".equals(orderVO.getDlvrcPaymentCd())) {
                        if ("배송준비중".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("상품준비중");
                        } else if ("배송완료".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("픽업가능");
                        } else if ("구매확정".equals(orderVO.getOrdDtlStatusNm())) {
                            orderVO.setOrdDtlStatusNm("픽업완료");
                        }
                    }
                }
                if("10".equals(orderVO.getOrdDtlStatusCd())) { // 입급대기중
                    if (isFirst) {
                        if(!fordDtlStatusCds.contains("20")) {
                            fordDtlStatusCds += "20";
                            isFirst = false;
                        }

                        /*if(!claimOrdDtlStatusCds.contains("20")) {
                            claimOrdDtlStatusCds += "20";
                            isFirst = false;
                        }*/
                    } else {
                        if(!fordDtlStatusCds.contains("20")) {
                            fordDtlStatusCds += ",";
                            fordDtlStatusCds += "20";
                        }

                        /*if(!claimOrdDtlStatusCds.contains("20")) {
                            claimOrdDtlStatusCds += ",";
                            claimOrdDtlStatusCds += "20";
                        }*/
                    }
                } else if("20".equals(orderVO.getOrdDtlStatusCd())) { // 결제 완료
                    if (isFirst) {
                        if(!fordDtlStatusCds.contains("30")) {
                            fordDtlStatusCds += "30";
                            isFirst = false;
                        }

                        if(!claimOrdDtlStatusCds.contains("20")) {
                            claimOrdDtlStatusCds += "20";
                            isFirst = false;
                        }
                    } else {
                        if(!fordDtlStatusCds.contains("30")) {
                            fordDtlStatusCds += ",";
                            fordDtlStatusCds += "30";
                        }

                        if(!claimOrdDtlStatusCds.contains("20")) {
                            claimOrdDtlStatusCds += ",";
                            claimOrdDtlStatusCds += "20";
                        }
                    }
                } else if("30".equals(orderVO.getOrdDtlStatusCd())) { // 배송 준비중
                    if(!fordDtlStatusCds.contains("40")) {
                        if (isFirst) {
                            fordDtlStatusCds += "40";
                            isFirst = false;
                        } else {
                            fordDtlStatusCds += ",";
                            fordDtlStatusCds += "40";
                        }
                    }
                } else if("40".equals(orderVO.getOrdDtlStatusCd())) { // 배송중
                    if(!fordDtlStatusCds.contains("40")) {
                        if (isFirst) {
                            fordDtlStatusCds += "40";
                            isFirst = false;
                        } else {
                            fordDtlStatusCds += ",";
                            fordDtlStatusCds += "40";
                        }
                    }
                } else if("50".equals(orderVO.getOrdDtlStatusCd())) { // 배송 완료
                    if(!claimOrdDtlStatusCds.contains("50")) {
                        if (isFirst) {
                            claimOrdDtlStatusCds += "50";
                            isFirst = false;
                        } else {
                            claimOrdDtlStatusCds += ",";
                            claimOrdDtlStatusCds += "50";
                        }
                    }
                }
            }
            rsltInfoVo.setFordStatusCd(fordDtlStatusCds);

            rsltInfoVo.setfClaimOrdStatusCd(claimOrdDtlStatusCds);
        }

        log.debug("rsltInfoVo ::::::::::::::::::::::::::::::::::::::::::::: "+rsltInfoVo);
        List<OrderPayVO> payVo = vo.getOrderPayVO();
        // 배송 정보
        List<DeliveryVO> deliveryVo = vo.getDeliveryVOList();

        // 처리로그
        List<OrderGoodsVO> ordHistVOList = vo.getOrdHistVOList();

        // 클레임 목록
        List<ClaimGoodsVO> ordClaimList = vo.getOrdClaimList();

        // 택배사 목록
        List<DeliveryVO> courierList = deliveryService.selectSiteCourierList();
        ModelAndView mv = new ModelAndView("/admin/seller/order/viewOrdDtl");
        mv.addObject("rsltInfoVo", rsltInfoVo);
        mv.addObject("orderGoodsVO", orderGoodsVO);
        mv.addObject("payVo", payVo);
        mv.addObject("ordSO", ordSO);
        mv.addObject("deliveryVo", deliveryVo);
        mv.addObject("ordHistVOList", ordHistVOList);
        mv.addObject("ordAddedAmountList", vo.getOrdAddedAmountList());
        mv.addObject("ordClaimList", ordClaimList);
        mv.addObject("courierVoList", courierList);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }

    
    @RequestMapping("/delivery-list")
    public @ResponseBody ResultListModel<DeliveryVO> selectDeliveryListPaging(DeliverySO so,
            BindingResult bindingResult) throws Exception {

        log.debug("================================");
        log.debug("Start : " + "viewOrdListPaging 에서 넘어온 검색조건에 맞는 주문 목록을 조회하여 리턴");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if ("02".equals(so.getSearchCd())) { // 주문자명
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }
        
        so.setSearchSeller(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));

        ResultListModel<DeliveryVO> resultList = deliveryService.selectDeliveryListPaging(so);
        return resultList;
    }


    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 송장번호 일괄등록을 위한 엑셀파일을 다운로드한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/invoice-temp-download")
    public String downInvoiceAddList(DeliverySO so, Model model) {
        log.debug("================================");
        log.debug("Start : " + "송장번호 일괄등록을 위한 엑셀파일을 다운로드한다.");
        log.debug("================================");
        
        so.setSearchSeller(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        // 엑셀로 출력할 데이터 조회
        ResultListModel<DeliveryVO> resultListModel = deliveryService.downInvoiceAddList(so);
        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "상품명", "옵션명", "주문번호", "주문상세번호", "상태", "주문자명", "주문수량", "배송처리된수량",
                "배송처리가능수량", "배송업체(업체코드)", "송장번호", "주소", "", "", "" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "goodsNm", "itemNm", "ordNo", "ordDtlSeq", "ordDtlStatusNm", "ordrNm",
                "ordQtt", "dlvrQtt", "ordQtt", "rlsCourierCd", "rlsInvoiceNo", "postNo", "roadnmAddr", "numAddr",
                "dtlAddr" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("송장 일괄 등록", headerName, fieldName, resultListModel.getResultList()));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "invoice_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
    }
    
    

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/searchorder-excel-download")
    public String viewOrdSrchListExcel(OrderSO ordSO, BindingResult bindingResult, Model model) {
        log.debug("================================");
        log.debug("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.debug("================================");
        
        ordSO.setSearchSeller(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        ordSO.setSearchSellerLogin("Y");

        List<OrderInfoVO> resultList = orderService.selectOrdSrchListExcel(ordSO);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "주문번호", "상태", "주문자명", "주문자아이디", "주문자연락처", "주문자휴대폰", "주문자이메일", "상품명", "옵션명",
                "상품번호", "단품번호", "주문수량", "수령인", "수령인휴대폰", "수령인연락처", "우편번호", "주소(지번)", "상세주소(지번)", "주소(도로명)", "상세주소(도로명)", "주문일",
                "관리자메모", "주문환경", "판매가", "마켓포인트 사용금액", "쿠폰사용금액", "결제금액", "배송비", "배송방법", "결제일", "결제방법" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "ordNo", "ordDtlStatusNm", "ordrNm", "loginId", "ordrTel", "ordrMobile",
                "ordrEmail", "goodsNm", "itemNm", "goodsNo", "itemNo", "ordQtt", "adrsNm", "adrsMobile", "adrstel", "postNo",
                "numAddr", "dtlAddr", "roadnmAddr", "dtlAddr", "ordAcceptDttm", "memoContent", "ordMediaNm", "saleAmt",
                "paymentMileage", "cpUseAmt", "paymentAmt", "realDlvrAmt", "dlvrcPaymentNm", "paymentCmpltDttm",
                "paymentWayNm" };
        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "orderSrchlist_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
    }
    

    @RequestMapping("/delivery-excel-download")
    public String selectDeliveryListExcel(DeliverySO so, BindingResult bindingResult, Model model) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.debug("================================");
        so.setOffset(10000000);
        if ("02".equals(so.getSearchCd())) { // 주문자명
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }
        
        so.setSearchSeller(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        List<DeliveryVO> resultList = deliveryService.selectDeliveryListExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "주문일시", "배송시작일시", "주문번호", "주문상품", "주문자명", "주문자아이디", "주문자등급", "배송상태",
                "택배사명", "송장번호" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "ordAcceptDttm", "rlsCmpltDttm", "ordNo", "goodsNm", "ordrNm", "loginId",
                "memberGradeNm", "ordDtlStatusNm", "rlsCourierNm", "rlsInvoiceNo" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "deliveryList_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 검색조건에 맞는 반품/환불 목록을 조회하여 리턴한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/refund")
    public ModelAndView viewRefundListPaging(ClaimSO claimSO) {

        log.debug("================================");
        log.debug("Start : " + "검색조건에 맞는 반품/환불 목록을 조회하여 리턴한다.");
        log.debug("================================");

        ModelAndView mv = new ModelAndView("/admin/seller/order/refund/viewRefundListPaging");
        mv.addObject("claimSO", claimSO);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }



    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 검색조건에 맞는 반품목록을 조회하여 리턴한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/refund-list")
    public @ResponseBody ResultListModel<ClaimGoodsVO> selectRefundListPaging(ClaimSO so, BindingResult bindingResult)
            throws Exception {

        log.debug("================================");
        log.debug("Start : " + "검색조건에 맞는 반품목록을 조회하여 리턴한다.");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if ("05".equals(so.getSearchCd()) || "06".equals(so.getSearchCd())) {
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }

        so.setSellerNo(SessionDetailHelper.getSession().getSellerNo());
        ResultListModel<ClaimGoodsVO> resultList = refundService.selectRefundListPaging(so);
        return resultList;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 검색조건에 맞는 반품/환불 목록을 조회하여 리턴한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/exchange")
    public ModelAndView viewExchangeListPaging(ClaimSO claimSO) {

        log.debug("================================");
        log.debug("Start : " + "검색조건에 맞는 반품/교환 목록을 조회하여 리턴한다.");
        log.debug("================================");

        ModelAndView mv = new ModelAndView("/admin/seller/order/exchange/viewExchangeListPaging");
        mv.addObject("claimSO", claimSO);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 검색조건에 맞는 반품목록을 조회하여 리턴한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/exchange-list")
    public @ResponseBody ResultListModel<ClaimGoodsVO> selectExchangeListPaging(ClaimSO so, BindingResult bindingResult)
            throws Exception {

        log.debug("================================");
        log.debug("Start : " + "검색조건에 맞는 반품목록을 조회하여 리턴한다.");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if ("04".equals(so.getSearchCd()) || "05".equals(so.getSearchCd()) || "06".equals(so.getSearchCd())) {
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }
        so.setSellerNo(SessionDetailHelper.getSession().getSellerNo());
        ResultListModel<ClaimGoodsVO> resultList = exchangeService.selectExchangeListPaging(so);
        return resultList;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 주문 상세 페이지에서 호출되는 주문상품 교환등록 및 수정을 Layer위의 목록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/exchange-list-layer")
    public @ResponseBody ResultListModel<ClaimGoodsVO> selectOrdDtlExchange(ClaimSO so, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        so.setSellerNo(SessionDetailHelper.getSession().getSellerNo());
        ResultListModel<ClaimGoodsVO> resultList = exchangeService.selectOrdDtlExchange(so);
        return resultList;
    }

    @RequestMapping("/exchange-excel-download")
    public String selectExchangeListExcel(ClaimSO so, BindingResult bindingResult, Model model) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.debug("================================");
        so.setOffset(10000000);
        if ("04".equals(so.getSearchCd()) || "05".equals(so.getSearchCd()) || "06".equals(so.getSearchCd())) {
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }
        so.setSellerNo(SessionDetailHelper.getSession().getSellerNo());

        List<ClaimGoodsVO> resultList = exchangeService.selectExchangeListExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "반품접수일시", "주문번호", "반품코드", "주문자", "결제", "주문수량", "반품교환수량", "처리자", "교환완료일시",
                "반품처리상태", "교환처리상태" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "claimAcceptDttm", "ordNo", "claimNo", "ordrNm", "paymentWayNm", "ordQtt",
                "ordQtt", "regrNm", "claimCmpltDttm", "returnNm", "claimNm" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "ExchangeList_" + DateUtil.getNowDate()); // 엑셀

        return View.excelDownload();
    }


    /**
     *
     * <pre>
     * 작성일 : 2016. 10. 17.
     * 작성자 : dong
     * 설명   : 엑셀 파일 다운로드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 17. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/refund-excel-download")
    public String selectRefundListExcel(ClaimSO so, BindingResult bindingResult, Model model) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.debug("================================");
        so.setOffset(10000000);

        if ("04".equals(so.getSearchCd()) || "05".equals(so.getSearchCd()) || "06".equals(so.getSearchCd())) {
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }
        so.setSellerNo(SessionDetailHelper.getSession().getSellerNo());
        List<ClaimGoodsVO> resultList = refundService.selectRefundListExcel(so);

        if ("01".equals(so.getCancelSearchType())) {// 환불
            // 엑셀의 헤더 정보 세팅
            String[] headerName = new String[] { "접수일시", "주문번호", "반품코드", "주문자", "결제", "주문수량", "반품환불수량", "처리자", "수거완료일시",
                    "반품처리상태", "환불처리상태" };
            // 엑셀에 출력할 데이터 세팅
            String[] fieldName = new String[] { "claimAcceptDttm", "ordNo", "claimNo", "ordrNm", "paymentWayNm",
                    "ordQtt", "ordQtt", "regrNm", "claimCmpltDttm", "returnNm", "claimNm" };

            model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                    new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
            model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "RefundList_" + DateUtil.getNowDate()); // 엑셀
            // 파일명
        } else {
            // 엑셀의 헤더 정보 세팅
            String[] headerName = new String[] { "취소접수일시", "주문번호", "결제취소코드", "주문자", "결제", "주문수량", "결제취소수량", "처리자",
                    "처리상태" };
            // 엑셀에 출력할 데이터 세팅
            String[] fieldName = new String[] { "claimAcceptDttm", "ordNo", "claimNo", "ordrNm", "paymentWayNm",
                    "ordQtt", "ordQtt", "regrNm", "claimNm" };

            model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                    new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
            model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "RefundList_" + DateUtil.getNowDate()); // 엑셀
            // 파일명
        }
        return View.excelDownload();
    }
    

}
