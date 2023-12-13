package net.danvi.dmall.admin.web.view.order.manage.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.order.manage.model.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.basket.model.BasketOptPO;
import net.danvi.dmall.biz.app.basket.model.BasketOptSO;
import net.danvi.dmall.biz.app.basket.model.BasketOptVO;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketSO;
import net.danvi.dmall.biz.app.basket.model.BasketVO;
import net.danvi.dmall.biz.app.basket.service.FrontBasketService;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.operation.model.SmsSendPO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryVO;
import net.danvi.dmall.biz.app.order.delivery.service.DeliveryService;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.service.FreebieCndtService;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaSO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaVO;
import net.danvi.dmall.biz.app.setup.delivery.service.DeliveryManageService;
import net.danvi.dmall.biz.app.setup.payment.model.NopbPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.service.PaymentManageService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 02.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/order/manage")
public class OrderController {

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문 목록을 조회하는 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */

    @Resource(name = "orderService")
    private OrderService orderService;
    @Resource(name = "deliveryService")
    private DeliveryService deliveryService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "frontBasketService")
    private FrontBasketService frontBasketService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "paymentManageService")
    private PaymentManageService paymentManageService;

    @Resource(name = "deliveryManageService")
    private DeliveryManageService deliveryManageService;

    @Resource(name = "freebieCndtService")
    private FreebieCndtService freebieCndtService;

    @RequestMapping("/order-status")
    public ModelAndView viewOrdListPaging(OrderSO ordSO, HttpServletRequest request) {
        log.info("================================");
        log.info("Start : " + "주문 목록 화면");
        log.info("================================");

        /*List<CmnCdDtlVO> codeOn = ServiceUtil.listCode("ORD_STATUS_CD", "ON", null, null, null, null);
        List<CmnCdDtlVO> codeOff = ServiceUtil.listCode("ORD_STATUS_CD", "OFF", null, null, null, null);*/
        List<CmnCdDtlVO> codeOn = ServiceUtil.listCode("ORD_DTL_STATUS_CD", null, "ON", null, null, null);
        List<CmnCdDtlVO> codeOff = ServiceUtil.listCode("ORD_DTL_STATUS_CD", null, "OFF", null, null, null);

        // 주문 상태별 버튼 색상 조정
        ModelAndView mv = new ModelAndView("/admin/order/manage/viewOrdListPaging");
        mv.addObject("ordSO", ordSO);

        mv.addObject("codeOnList", codeOn);
        mv.addObject("codeOffList", codeOff);
        mv.addObject("paymentWayCdList", ServiceUtil.listCode("PAYMENT_WAY_CD", "SEARCH", null, null, null, null));
        mv.addObject("ordMediaCdList", ServiceUtil.listCode("ORD_MEDIA_CD", null, null, null, null, null));
        mv.addObject("saleChannelCdList", ServiceUtil.listCode("SALE_CHANNEL_CD", null, null, null, null, null));

        String referer = request.getHeader("referer");
        if (referer.contains("/memberinfo-detail") || referer.contains("/main-view")) {
            mv.addObject("ignoreCookie", true);
        } else {
            mv.addObject("ignoreCookie", false);
        }
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

        log.info("================================");
        log.info("Start : " + "viewOrdListPaging 에서 넘어온 검색조건에 맞는 주문 목록을 조회하여 리턴");
        log.info("================================");
        String searchCd = ordSO.getSearchCd();
        if (bindingResult.hasErrors()) {
            log.info("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if ("02".equals(ordSO.getSearchCd()) || "03".equals(ordSO.getSearchCd()) || "04".equals(ordSO.getSearchCd()) 
         || "05".equals(ordSO.getSearchCd()) || "06".equals(ordSO.getSearchCd()) || "07".equals(ordSO.getSearchCd())) {
            ordSO.setSearchWord(CryptoUtil.encryptAES(ordSO.getSearchWord()));
        }

        ResultListModel<OrderInfoVO> resultList = orderService.selectOrdListPaging(ordSO);
        return resultList;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문상세내용을 프린트 하기위한 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-print")
    public ModelAndView viewOrdPrint(@Validated OrderInfoVO infoVo) {
        log.info("================================");
        log.info("Start : " + "주문상세내용을 프린트 하기위한 화면");
        log.info("================================");
        OrderVO vo = orderService.selectOrdDtlPrint(infoVo);
        OrderInfoVO rsltInfoVo = vo.getOrderInfoVO();
        List<OrderGoodsVO> orderGoodsVO = vo.getOrderGoodsVO();

        ModelAndView mv = new ModelAndView("/admin/order/manage/viewOrdPrint");
        mv.addObject("rsltInfoVo", rsltInfoVo);
        mv.addObject("orderGoodsVO", orderGoodsVO);

        return mv;
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
    public String viewOrdSrchListExcel(OrderSO ordSO, BindingResult bindingResult, Model model) 
    		 throws Exception {
        log.info("================================");
        log.info("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.info("================================");
        
        if ("02".equals(ordSO.getSearchCd()) || "03".equals(ordSO.getSearchCd())
                || "06".equals(ordSO.getSearchCd()) || "07".equals(ordSO.getSearchCd())) {
                   ordSO.setSearchWord(CryptoUtil.encryptAES(ordSO.getSearchWord()));
        }

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

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 선택된 주문 목록을 Excel파일 형태로 다운로드 하기위한 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-excel-download")
    public String viewOrdListExcel(@RequestParam Map<String, Object> map, Model model) {
        log.info("================================");
        log.info("Start : " + "선택된 주문 목록을 Excel파일 형태로 다운로드 하기위한 화면");
        log.info("================================");

        // Map<String,String> ordNoList = new Map<String,String>();
        String[] ordNo = ((String) map.get("ordNos")).split(",");

        // 엑셀로 출력할 데이터 조회
        List<OrderExcelVO> resultList = orderService.selectOrdList(ordNo);
        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "주문번호", "상태", "주문자명", "주문자아이디", "주문자연락처", "주문자휴대폰", "주문자이메일", "상품명", "옵션명",
                "상품번호", "주문수량", "수령인", "수령인휴대폰", "수령인연락처", "우편번호", "주소(지번)", "상세주소(지번)", "주소(도로명)", "상세주소(도로명)", "주문일",
                "관리자메모", "주문환경", "판매가", "마켓포인트사용금액", "쿠폰사용금액", "결제금액", "배송비", "배송방법", "결제일", "결제방법" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "ordNo", "ordDtlStatusNm", "ordrNm", "loginId", "ordrTel", "ordrMobile",
                "ordrEmail", "goodsNm", "itemNm", "itemNo", "ordQtt", "adrsNm", "adrsMobile", "adrstel", "postNo",
                "numAddr", "dtlAddr", "roadnmAddr", "dtlAddr", "ordAcceptDttm", "memoContent", "ordMediaNm", "saleAmt",
                "paymentMileage", "cpUseAmt", "paymentAmt", "realDlvrAmt", "dlvrcPaymentNm", "paymentCmpltDttm",
                "paymentWayNm" };
        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("주문 목록", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "orderlist_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 선택된 주문건의 주문상태를 변경
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-checkstatus-update")
    public @ResponseBody ResultModel<OrderInfoVO> updateOrdListStatus(@RequestParam Map<String, Object> map) throws Exception {
        log.info("================================");
        log.info("Start : " + "선택된 주문건의 주문상태를 변경");
        log.info("================================");

        String ordNo = (String) map.get("ordNo");

        String curOrdStatusCd = (String) map.get("curOrdStatusCd");
        String curOrdDtlSeq = (String) map.get("curOrdDtlSeq");

        String ordStatusCd = (String) map.get("ordStatusCd");
        String mdConfirmYn = (String) map.get("mdConfirmYn");

        if(StringUtil.isEmpty(curOrdStatusCd)) {
            throw new Exception("curOrdStatusCd is null");
        }
        if(StringUtil.isEmpty(curOrdDtlSeq)) {
            throw new Exception("curOrdDtlSeq is null");
        }
        if(StringUtil.isEmpty(ordStatusCd)) {
            throw new Exception("ordStatusCd is null");
        }

        String [] ordNos = ordNo.split(",");

        String [] curOrdStatusCds = curOrdStatusCd.split(",");
        String [] curOrdDtlSeqs = curOrdDtlSeq.split(",");


        List<OrderGoodsVO> listVo = new ArrayList<OrderGoodsVO>();

        if(ordNos.length>0){
            for (int i=0;i<ordNos.length;i++){
                OrderGoodsVO vo = new OrderGoodsVO();
                vo.setOrdNo(ordNos[i]);
                vo.setOrdStatusCd(ordStatusCd);
                vo.setCurOrdStatusCd(curOrdStatusCds[i]);
                vo.setOrdDtlSeq(curOrdDtlSeqs[i]);
                vo.setMdConfirmYn(mdConfirmYn);
                listVo.add(vo);
            }
        }

        return orderService.updateOrdListStatus(listVo, curOrdStatusCd);
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
        log.info("================================");
        log.info("Start : " + "주문의 상세 정보를 조회한다");
        log.info("================================");
        OrderInfoVO orderInfoVo = new OrderInfoVO();
        orderInfoVo.setOrdNo(ordSO.getOrdNo());
        orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
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
        // 결제 정보
        List<OrderPayVO> payVo = vo.getOrderPayVO();
        // 결제 실패 정보
        List<OrderPayVO> payFailVo = vo.getOrderPayFailVO();

        // 배송 정보
        List<DeliveryVO> deliveryVo = vo.getDeliveryVOList();

        // 처리로그
        List<OrderGoodsVO> ordHistVOList = vo.getOrdHistVOList();

        // 클레임 목록
        List<ClaimGoodsVO> ordClaimList = vo.getOrdClaimList();
        
        //쿠폰사용 주문내역 조회
        List<CouponVO> cpList = orderService.selectCouponList(orderInfoVo);

        // 택배사 목록
        List<DeliveryVO> courierList = deliveryService.selectSiteCourierList();
        ModelAndView mv = new ModelAndView("/admin/order/manage/viewOrdDtl");
        mv.addObject("rsltInfoVo", rsltInfoVo);
        mv.addObject("orderGoodsVO", orderGoodsVO);
        mv.addObject("payVo", payVo);
        mv.addObject("payFailVo", payFailVo);
        mv.addObject("ordSO", ordSO);
        mv.addObject("deliveryVo", deliveryVo);
        mv.addObject("ordHistVOList", ordHistVOList);
        mv.addObject("ordAddedAmountList", vo.getOrdAddedAmountList());
        mv.addObject("ordClaimList", ordClaimList);
        mv.addObject("cpList", cpList);
        mv.addObject("courierVoList", courierList);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문의 상세 정보를 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-detail-select")
    public @ResponseBody ResultModel<OrderVO> selectOrdDtl(@Validated OrderSO ordSO) {
        log.info("================================");
        log.info("Start : " + "주문의 상세 정보를 조회한다");
        log.info("================================");
        OrderInfoVO orderInfoVo = new OrderInfoVO();
        orderInfoVo.setOrdNo(ordSO.getOrdNo());
        orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        OrderVO vo = orderService.selectOrdDtl(orderInfoVo);
        ResultModel<OrderVO> result = new ResultModel<OrderVO>();
        result.setData(vo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 주문의 메모를 입력한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-memo-insert")
    public @ResponseBody ResultModel<OrderInfoPO> insertOrdMemo(OrderInfoPO po, BindingResult bindingResult) {
        ResultModel<OrderInfoPO> result = new ResultModel<>();
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        if (orderService.insertOrdMemo(po))
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        else
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        return result;

    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문 상세 페이지에서 호출되는 상품의 옵션정보 변경화면 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-detail-option")
    public @ResponseBody ResultModel<GoodsDetailVO> viewOrdDtlOption(@Validated GoodsDetailSO so,
            BindingResult bindingResult) throws Exception {
        log.info("================================");
        log.info("Start : " + "주문 상세 페이지에서 호출되는 상품의 옵션정보 변경화면 ");
        log.info("================================");

        // 01.상품기본정보 조회
        ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(so);

        // 02.단품정보
        String jsonList = "";
        if (goodsInfo.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfo.getData().getGoodsItemList());
        }
        goodsInfo.setExtraString(jsonList);
        return goodsInfo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문 상세페이지에서 호출되어 상품의 옵션정보를 변경한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-option-update")
    public @ResponseBody ResultModel<OrderGoodsVO> updateOrdDtlOption(OrderGoodsVO vo) {
        log.info("================================");
        log.info("Start : " + "주문 상세 페이지에서 호출되는 상품의 옵션정보 변경화면 ");
        log.info("================================");
        ResultModel<OrderGoodsVO> result = new ResultModel<OrderGoodsVO>();
        boolean success = orderService.updateOrdDtlOption(vo);
        result.setSuccess(success);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 7.
     * 작성자 : dong
     * 설명   : 단 건의 주문상태를 변경
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 7. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-status-update")
    public @ResponseBody ResultModel<OrderInfoVO> updateOrdStatus(OrderGoodsVO vo,
                                                                  @RequestParam("curOrdStatusCd") String curOrdStatusCd) {
        log.info("================================");
        log.info("Start : " + "단 건의 주문상태를 변경");
        log.info("================================");
        return orderService.updateOrdStatus(vo, curOrdStatusCd);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 관리자의 수기주문을 등록하는 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-insert-form")
    public ModelAndView viewAdminOrder() throws Exception {
        log.info("================================");
        log.info("Start : " + "관리자의 수기주문을 등록하는 화면");
        log.info("================================");

        ModelAndView mv = new ModelAndView("/admin/order/manage/viewAdminOrder");
        SiteSO so = new SiteSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 02. 주문번호 생성
        long ordNo = orderService.createOrdNo(so.getSiteNo());

        mv.addObject("ordNo", ordNo);
        ResultModel<SiteVO> result = siteInfoService.selectSiteInfo(so);
        mv.addObject("site_info", result.getData());

        // 무통장 설정 조회
        ResultListModel<NopbPaymentConfigVO> nopbListModel = paymentManageService.selectNopbPaymentList(so.getSiteNo());
        mv.addObject("nopbListModel", nopbListModel);

        return mv;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 18.
     * 작성자 : dong
     * 설명   : 수기주문 상품 담기 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 18. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/basket-insert")
    public @ResponseBody ResultModel<BasketPO> insertBasket(@Validated(InsertGroup.class) BasketPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.info("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<BasketPO> result = new ResultModel<>();
        po.setBuyQtt(1);
        result = frontBasketService.insertBasketSession(po, request);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 관리자의 수기주문을 등록한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-insert")
    public String insertAdminOrder(@Validated OrderPO po, BindingResult bindingResult, HttpServletRequest request,
            RedirectAttributes redirectAttr, @RequestParam Map<String, Object> reqMap) throws Exception {

        ModelAndView mav = new ModelAndView();
        log.info("================================");
        log.info("Start : " + "관리자의 수기주문을 등록한다");
        log.info("================================");
        // 1. 필수 파라메터 검증
        if (bindingResult.hasErrors()) {
            log.info("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new Exception("파라메터 오류");
        }
        // 배송비 맵 수정
        String tempDlvrPriceMap = request.getParameter("dlvrPriceMap");
        // String value = StringUtils.substringBetween(tempDlvrPriceMap, "{", "}");
        // String keyValuePairs[] = value.split(",");

        Date today = new Date();
        po.setRegDttm(today); // 주문시 모든 등록일자를 동일하게 맞추기 위해 설정

        // 3. 주문 등록(주문정보, 상품정보, 배송비 정보, 배송정보, 부가비용)
        ResultModel<OrderPO> result = orderService.insertOrder(po, request);
        if (!result.isSuccess()) {
            log.error("=== insertOrder ERROR : {}", result.getMessage());
            throw new Exception(result.getMessage());
        }

        // 4. 주문 결제(PG결제, 마켓포인트결제, 쿠폰정보, 상품수량 업데이트)
        OrderPO orderPO = new OrderPO();
        orderPO = result.getData();
        OrderPayPO orderPayPO = new OrderPayPO();
        orderPayPO.setSiteNo(po.getSiteNo());
        orderPayPO.setPaymentWayCd(request.getParameter("paymentWayCd"));
        orderPayPO.setPaymentPgCd(request.getParameter("paymentPgCd"));
        orderPayPO.setOrdNo(po.getOrdNo());
        orderPayPO.setPaymentAmt(po.getPaymentAmt());
        orderPO.setOrderPayPO(orderPayPO);
        log.info("=== orderPO.orderPayPO : {}", orderPO.getOrderPayPO());
        ResultModel<OrderPO> payResult = orderService.orderPayment(orderPO, request, reqMap, mav);
        if (!payResult.isSuccess()) {
            log.error("=== insertOrder ERROR : {}", payResult.getMessage());
            // 주문상태 업데이트(결제실패)
            throw new Exception(payResult.getMessage());
        }
        // 5. SMS 보내기
        String recvTelnoSelect = request.getParameter("recvTelnoSelect");
        if (recvTelnoSelect != null && !"".equals(recvTelnoSelect)) {
            SmsSendPO smsPo = new SmsSendPO();
            smsPo.setSendWords(request.getParameter("sendWords"));
            smsPo.setSendTargetCd(request.getParameter("sendTargetCd"));
            smsPo.setAutoSendYn("N");
            if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                smsPo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                smsPo.setSenderNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                smsPo.setSenderId(SessionDetailHelper.getDetails().getSession().getLoginId());
                smsPo.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
            }
            // sms, 장문
            smsPo.setSendFrmCd(request.getParameter("sendFrmCd"));
            smsPo.setPossCnt(new Integer(request.getParameter("smsPossCnt")));
            smsPo.setRecvTelNo(request.getParameter("recvTelnoSelect"));
            smsPo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            smsPo.setReceiverNm(request.getParameter("ordrNm"));
            smsPo.setReceiverId("");
            SiteSO siteSo = new SiteSO();
            siteSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);
            smsPo.setSendTelno(siteInfo.getData().getCertifySendNo());

            List<SmsSendPO> smsList = new ArrayList<SmsSendPO>();
            smsList.add(smsPo);
            smsSendService.sendSms(smsList);
        }
        // 6. 상품 세션 삭제
        HttpSession session = request.getSession();
        List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
        for (int i = 0; i < po.getOrderGoodsPO().size(); i++) {
            OrderGoodsPO orderGoodsPO = (OrderGoodsPO) po.getOrderGoodsPO().get(i);
            if ("N".equals(orderGoodsPO.getAddOptYn())) {
                for (int k = 0; k < basketSession.size(); k++) {
                    BasketPO sessionPO = (BasketPO) basketSession.get(k);
                    if (orderGoodsPO.getItemNo().equals(sessionPO.getItemNo())) {
                        basketSession.remove(k);
                    }
                }
            }
        }
        List<BasketPO> refreshBasketSession = (List<BasketPO>) session.getAttribute("basketSession");
        if (refreshBasketSession != null && refreshBasketSession.size() == 0) {
            session.removeAttribute("basketSession");
        }
        // 7. 주문완료 페이지로 이동
        // redirectAttr.addFlashAttribute("orderPO", po);
        return View.redirect("/admin/order/manage/order-status");
    }
    //
    // /**
    // * <pre>
    // * 작성일 : 2016. 7. 20.
    // * 작성자 : dong
    // * 설명 : 수기주문의 장바구니 세션 수정 (front.BasketController에서 카피)
    // *
    // * 수정내역(수정일 수정자 - 수정내용)
    // * -------------------------------------------------------------------------
    // * 2016. 7. 20. dong - 최초생성
    // * </pre>
    // *
    // * @param so
    // * @return
    // * @throws Exception
    // */
    // @RequestMapping(value = "/goods-detail")
    // public ModelAndView updateAdminOrderBasket(@Validated GoodsDetailSO so, BindingResult bindingResult,
    // HttpServletRequest request, HttpServletResponse response) throws Exception {
    //
    // ModelAndView mav = new ModelAndView();
    // mav.setViewName("/admin/order/manage/basket_update");
    //
    // if ("".equals(so.getGoodsNo()) || so.getGoodsNo() == null) {
    // throw new Exception(MessageUtil.getMessage("front.web.common.wrongapproach"));
    // }
    // // 01.상품기본정보 조회
    // String itemNo = so.getItemNo();
    // so.setItemNo("");
    // ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(so);
    // mav.addObject("goodsInfo", goodsInfo);
    //
    // // 02.단품정보
    // String jsonList = "";
    // if (goodsInfo.getData().getGoodsItemList() != null) {
    // ObjectMapper mapper = new ObjectMapper();
    // jsonList = mapper.writeValueAsString(goodsInfo.getData().getGoodsItemList());
    // }
    // HttpSession session = request.getSession();
    // List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
    // BasketPO basketInfo = basketSession.get(so.getSessionIndex());
    //
    // List<GoodsItemVO> itemInfoList = goodsInfo.getData().getGoodsItemList();
    // GoodsItemVO itemInfo = new GoodsItemVO();
    // if (itemInfoList != null) {
    // for (int i = 0; i < itemInfoList.size(); i++) {
    // if (basketInfo.getItemNo().equals(itemInfoList.get(i).getItemNo())) {
    // itemInfo = itemInfoList.get(i);
    // }
    // }
    // }
    // if (basketInfo.getItemVer() == itemInfo.getItemVer()) {
    // basketInfo.setItemVerChk("Y");
    // } else {
    // basketInfo.setItemVerChk("N");
    // }
    //
    // if (basketInfo.getAttrVer() == itemInfo.getAttrVer()) {
    // basketInfo.setAttrVerChk("Y");
    // } else {
    // basketInfo.setAttrVerChk("N");
    // }
    //
    // List<BasketOptPO> basketOptPOList = basketInfo.getBasketOptList();
    //
    // List<BasketOptVO> basketOptVOList = new ArrayList<BasketOptVO>();
    // if (basketOptPOList != null) {
    //
    // for (int j = 0; j < basketOptPOList.size(); j++) {
    // BasketOptSO basketOptSO = new BasketOptSO();
    // basketOptSO.setGoodsNo(so.getGoodsNo());
    // basketOptSO.setAddOptNo(basketOptPOList.get(j).getAddOptNo());
    // basketOptSO.setAddOptDtlSeq(basketOptPOList.get(j).getAddOptDtlSeq());
    //
    // BasketOptVO addOptInfo = frontBasketService.addOptInfo(basketOptSO);
    // addOptInfo.setOptBuyQtt(basketOptPOList.get(j).getOptBuyQtt());
    // basketOptVOList.add(addOptInfo);
    // }
    // }
    // String jsonList2 = "";
    // ObjectMapper mapper = new ObjectMapper();
    // jsonList2 = mapper.writeValueAsString(basketOptVOList);
    //
    // mav.addObject("basketInfo", basketInfo);
    // mav.addObject("basketOptInfo", jsonList2);
    // mav.addObject("itemInfo", itemInfo);
    //
    // // 10.사은품대상조회
    // ResultListModel<FreebieTargetVO> freebieEventList = new ResultListModel<>();
    // FreebieCndtSO freebieCndtSO = new FreebieCndtSO();
    // freebieCndtSO.setGoodsNo(goodsInfo.getData().getGoodsNo());
    // freebieCndtSO.setSiteNo(so.getSiteNo());
    // freebieEventList = freebieCndtService.selectFreebieListByGoodsNo(freebieCndtSO);
    // List<FreebieGoodsVO> freebieList = (List<FreebieGoodsVO>) freebieEventList.getExtraData().get("goodsResult");
    // List<FreebieGoodsVO> freebieGoodsList = new ArrayList();
    // // 사은품 조회
    // if (freebieList != null && freebieList.size() > 0) {
    // for (int j = 0; j < freebieList.size(); j++) {
    // FreebieGoodsVO freebieEventVO = (FreebieGoodsVO) freebieList.get(j);
    // FreebieCndtSO freebieGoodsSO = new FreebieCndtSO();
    // freebieGoodsSO.setSiteNo(so.getSiteNo());
    // freebieGoodsSO.setFreebieEventNo(freebieEventVO.getFreebieEventNo());
    // ResultModel<FreebieCndtVO> freeGoodsList = new ResultModel<>();
    // freeGoodsList = freebieCndtService.selectFreebieCndtDtl(freebieGoodsSO);
    // log.info("== freeGoodsList : {}", freeGoodsList.getExtraData().get("goodsResult"));
    // List<FreebieGoodsVO> freebieList2 = new ArrayList();
    // freebieList2 = (List<FreebieGoodsVO>) freeGoodsList.getExtraData().get("goodsResult");
    // if (freebieList2 != null && freebieList2.size() > 0) {
    // for (int m = 0; m < freebieList2.size(); m++) {
    // FreebieGoodsVO freebieGoodsVO = (FreebieGoodsVO) freebieList2.get(m);
    // freebieGoodsList.add(freebieGoodsVO);
    // }
    // }
    // }
    // }
    // // 사은품 제공 조건에 따라 해당 사은품을 추출
    // long maxAmt = 0;
    // String freebie_No = "";
    // for (int i = 0; i < freebieGoodsList.size(); i++) {
    // FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(i);
    // if ("02".equals(freebieGoodsVO.getFreebiePresentCndtCd())) {
    // freebie_No = freebieGoodsVO.getFreebieNo();
    // break;
    // } else {
    // if (maxAmt < freebieGoodsVO.getFreebieEventAmt()) {
    // maxAmt = freebieGoodsVO.getFreebieEventAmt();
    // freebie_No = freebieGoodsVO.getFreebieNo();
    // }
    // }
    // }
    // // 사은품목록에서 해당 사은품을 제외한 나머지는 삭제
    // for (int i = 0; i < freebieGoodsList.size(); i++) {
    // FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(i);
    // if (freebie_No != freebieGoodsVO.getFreebieNo()) {
    // freebieGoodsList.remove(i);
    // }
    // }
    // mav.addObject("freebieGoodsList", freebieGoodsList);
    //
    // mav.addObject("goodsItemInfo", jsonList);
    // mav.addObject("so", so);
    // return mav;
    // }

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
     * 
     * <pre>
     * 작성일 : 2016. 9. 8.
     * 작성자 : dong
     * 설명   : 수기주문을 위해 등록된 상품 목록을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 8. dong - 최초생성
     * </pre>
     *
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/order-goods-list")
    public @ResponseBody ResultModel<AdminOrderVO> selectAdminOrderGoodsList(HttpServletRequest request)
            throws Exception {

        ResultModel<AdminOrderVO> result = new ResultModel<AdminOrderVO>();

        List<BasketVO> basket_list = new ArrayList<>();
        int totalsOrdPrice = 0;
        int totalsDcAmt = 0;
        int totalsPrice = 0;

        HttpSession session = request.getSession();
        List<BasketPO> basket_session = (List<BasketPO>) session.getAttribute("basketSession");
        BasketVO itemInfo = new BasketVO();
        String itemArr = "";
        if (basket_session != null) {

            for (int i = 0; i < basket_session.size(); i++) {
                String addOptArr = "";

                if (!"".equals(addOptArr)) {
                    addOptArr = addOptArr + "*";
                }

                String itemNo = (String) basket_session.get(i).getItemNo();
                long attrVer = basket_session.get(i).getAttrVer();
                BasketSO basketSO = new BasketSO();
                basketSO.setItemNo(itemNo);
                basketSO.setAttrVer(attrVer);
                basketSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                itemInfo = frontBasketService.selectItemInfo(basketSO);

                // 기획전 할인정보 조회
                itemInfo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                frontBasketService.promotionDcInfo(itemInfo);

                BasketVO basketVO = new BasketVO();
                basketVO.setBasketNo(basketVO.getBasketNo());
                basketVO.setItemNo(itemNo);
                basketVO.setUseYn(itemInfo.getUseYn());
                basketVO.setGoodsNo(itemInfo.getGoodsNo());
                basketVO.setGoodsNm(itemInfo.getGoodsNm());
                basketVO.setOptNo1Nm(itemInfo.getOptNo1Nm());
                basketVO.setAttrNo1Nm(itemInfo.getAttrNo1Nm());
                basketVO.setOptNo2Nm(itemInfo.getOptNo2Nm());
                basketVO.setAttrNo2Nm(itemInfo.getAttrNo2Nm());
                basketVO.setOptNo3Nm(itemInfo.getOptNo3Nm());
                basketVO.setAttrNo3Nm(itemInfo.getAttrNo3Nm());
                basketVO.setOptNo4Nm(itemInfo.getOptNo4Nm());
                basketVO.setAttrNo4Nm(itemInfo.getAttrNo4Nm());
                basketVO.setDlvrcPaymentCd(basket_session.get(i).getDlvrcPaymentCd());
                basketVO.setDlvrSetCd(itemInfo.getDlvrSetCd());

                if (basket_session.get(i).getItemVer() == itemInfo.getItemVer()) {
                    basketVO.setItemVerChk("Y");
                } else {
                    basketVO.setItemVerChk("N");
                }

                if (basket_session.get(i).getAttrVer() == itemInfo.getAttrVer()) {
                    basketVO.setAttrVerChk("Y");
                } else {
                    basketVO.setAttrVerChk("N");
                }

                int addTotalPrice = 0;
                int addBuyQtt = 0;
                int addPrice = 0;
                List<BasketOptVO> basketOptVOList = new ArrayList<>();
                List<BasketOptPO> basketOpt_session = basket_session.get(i).getBasketOptList();
                if (basketOpt_session != null) {
                    for (int j = 0; j < basketOpt_session.size(); j++) {
                        BasketOptVO basketOptVOInfo = new BasketOptVO();
                        BasketOptSO basketOptSO = new BasketOptSO();
                        basketOptSO.setGoodsNo(basket_session.get(i).getGoodsNo());
                        basketOptSO.setAddOptNo(basketOpt_session.get(j).getAddOptNo());
                        basketOptSO.setAddOptDtlSeq(basketOpt_session.get(j).getAddOptDtlSeq());
                        BasketOptVO addOptInfo = frontBasketService.addOptInfo(basketOptSO);
                        basketOptVOInfo.setAddOptNo(addOptInfo.getAddOptNo());
                        basketOptVOInfo.setAddOptDtlSeq(addOptInfo.getAddOptDtlSeq());
                        basketOptVOInfo.setAddOptNm(addOptInfo.getAddOptNm());
                        basketOptVOInfo.setAddOptValue(addOptInfo.getAddOptValue());
                        basketOptVOInfo.setAddOptAmtChgCd(addOptInfo.getAddOptAmtChgCd());
                        basketOptVOInfo.setAddOptAmt(addOptInfo.getAddOptAmt());
                        basketOptVOInfo.setOptBuyQtt(basketOpt_session.get(j).getOptBuyQtt());
                        basketOptVOList.add(basketOptVOInfo);

                        addBuyQtt = basketOptVOInfo.getOptBuyQtt();
                        String addOptAmtChgCd = basketOptVOInfo.getAddOptAmtChgCd();

                        addPrice = basketOptVOInfo.getAddOptAmt();
                        if ("2".equals(addOptAmtChgCd)) {
                            addPrice = -addPrice;
                        }
                        addTotalPrice = addTotalPrice + addBuyQtt * addPrice;

                        addOptArr = addOptArr + basketOpt_session.get(j).getAddOptNo() + "^"+ basketOpt_session.get(j).getAddOptDtlSeq() + "^"+ basketOpt_session.get(j).getOptBuyQtt();
                    }
                }
                int buyQtt = basket_session.get(i).getBuyQtt();
                int salePrice = (int) itemInfo.getSalePrice();
                int dcAmt = (int) itemInfo.getDcAmt();
                int totalPrice = salePrice * buyQtt - dcAmt + addTotalPrice;

                basketVO.setBuyQtt(buyQtt);
                basketVO.setSalePrice(salePrice);
                basketVO.setTotalPrice(totalPrice);

                basketVO.setBasketOptList(basketOptVOList);
                totalsDcAmt = totalsDcAmt + dcAmt;
                totalsOrdPrice = totalsOrdPrice + totalPrice;

                itemArr = itemInfo.getGoodsNo() + "▦" + itemInfo.getItemNo() + "^" + basket_session.get(i).getBuyQtt()+ "^" + basket_session.get(i).getDlvrcPaymentCd() + "▦" + addOptArr+ "▦" +basket_session.get(i).getCtgNo();
                basketVO.setItemArr(itemArr);
                basket_list.add(basketVO);

            }
        }

        // 배송비 계산(묶음 관련)
        String type = "basket";
        Map map = orderService.calcDlvrAmt(basket_list, type);
        List<BasketVO> list = (List<BasketVO>) map.get("list");
        Map dlvrPriceMap = (Map) map.get("dlvrPriceMap");
        Map dlvrCountMap = (Map) map.get("dlvrCountMap");
        String jsonList = "";
        if (list != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(list);
        }
        totalsPrice = totalsOrdPrice - totalsDcAmt;
        AdminOrderVO adminVO = new AdminOrderVO();
        String dlvrPriceMapStr = "";
        if (dlvrPriceMap != null) dlvrPriceMapStr = dlvrPriceMap.toString();
        adminVO.setDlvrPriceMapStr(dlvrPriceMapStr);
        adminVO.setDlvrPriceMap(dlvrPriceMap);
        adminVO.setDlvrCountMap(dlvrCountMap);
        adminVO.setBasketList(list);
        adminVO.setBasketListJson(jsonList);
        adminVO.setBasketSize(basket_list.size());
        adminVO.setTotalsOrdPrice(totalsOrdPrice);
        adminVO.setTotalsDcAmt(totalsDcAmt);
        adminVO.setTotalsPrice(totalsPrice);
        result.setData(adminVO);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 장바구니 상품정보 수량 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    @RequestMapping("/basket-count-update")
    public @ResponseBody ResultModel<BasketPO> updateBasketCnt(@Validated(UpdateGroup.class) BasketPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        /*
         * if (bindingResult.hasErrors()) {
         * log.info("ERROR : {}", bindingResult.getAllErrors().toString());
         * throw new JsonValidationException(bindingResult);
         * }
         */ ResultModel<BasketPO> result = new ResultModel<>();
        result = frontBasketService.updateBasketCntSession(po, request);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 장바구니 상품정보 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @param mav
     * @return
     * @throws Exception
     */
    @RequestMapping("/basket-delete")
    public @ResponseBody ResultModel<BasketPO> deleteBasket(@Validated(DeleteGroup.class) BasketPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.info("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<BasketPO> result = new ResultModel<>();
        result = frontBasketService.deleteBasketSession(po, request);
        return result;
    }

    // 관리자 취소
    @RequestMapping("/cancel-order")
    public @ResponseBody ResultModel<OrderPayPO> orderCancel(@Validated OrderPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<OrderPayPO> result = orderService.cancelOrder(po);
        return result;
    }

    // 전체주문취소 ( 주문취소, 환불취소 )
    @RequestMapping("/order-cancel-all")
    public @ResponseBody ResultModel<OrderPayPO> orderCancelAll(@Validated OrderPO po, BindingResult bindingResult)
            throws Exception {
        // 02.전체주문취소
        OrderPayPO opp = new OrderPayPO();
        opp.setOrdNo(po.getOrdNo());
        String[] ordNoArr = { Long.toString(po.getOrdNo()) };
        String[] ordDtlSeqArr = po.getOrdDtlSeqArr();
        po.setOrdNoArr(ordNoArr);
        po.setOrdDtlSeqArr(ordDtlSeqArr);
        po.setOrderPayPO(opp);
        po.setPartCancelYn("N");
        po.setCancelType("01");
        ResultModel<OrderPayPO> result = orderService.cancelOrder(po);
        return result;
    }


}
