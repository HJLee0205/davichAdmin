package net.danvi.dmall.admin.web.view.order.refund.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.order.manage.model.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.biz.app.order.refund.service.RefundService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

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
@RequestMapping("/admin/order/refund")
public class RefundController {

    @Resource(name = "refundService")
    private RefundService refundService;

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

        ModelAndView mv = new ModelAndView("/admin/order/refund/viewRefundListPaging");
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

        if ("04".equals(so.getSearchCd()) || "05".equals(so.getSearchCd()) || "06".equals(so.getSearchCd())) {
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }

        ResultListModel<ClaimGoodsVO> resultList = refundService.selectRefundListPaging(so);
        return resultList;
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

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문 상세 페이지에서 호출되는 배송정보 입력 및 수정 팝업.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/refund-popup")
    public @ResponseBody ResultListModel<ClaimGoodsVO> selectRefundDtlInfo(ClaimGoodsVO vo,BindingResult bindingResult) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "주문 상세 페이지에서 호출되는 환불정보 입력 및 수정 팝업");
        log.debug("================================");

        ResultListModel<ClaimGoodsVO> listModel = new ResultListModel<ClaimGoodsVO>();
        List<ClaimGoodsVO> list = refundService.selectOrdDtlRefund(vo);
        listModel.setResultList(list);
        listModel.setTotalRows(list.size());

        return listModel;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 29.
     * 작성자 : dong
     * 설명   : 주문 상세 페이지에서 호출되는 주문상품 결제취소, 환불등록 및 수정을 Layer위의 목록 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 29. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/paycancel-info-layer")
    public @ResponseBody ResultModel<ClaimVO> selectOrdDtlPayCancelInfo(ClaimSO so, BindingResult bindingResult) throws Exception{
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ClaimVO> result = refundService.selectOrdDtlPayPartCancelInfo(so);

        return result;
    }

    // 환불 상태변경
    @RequestMapping("/refund-update")
    public @ResponseBody ResultModel<OrderPayPO> updateRefund(@Validated OrderPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<OrderPayPO> result = refundService.updateRefund(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 검색조건에 맞는 결제 취소 목록을 조회하여 리턴한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/pay-cancel")
    public ModelAndView viewPayCancelListPaging(ClaimSO claimSO) {

        log.debug("================================");
        log.debug("Start : " + "검색조건에 맞는 결제 취소 목록을 조회하여 리턴한다.");
        log.debug("================================");

        ModelAndView mv = new ModelAndView("/admin/order/refund/viewPayCancelListPaging");
        mv.addObject("claimSO", claimSO);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 16.
     * 작성자 : hskim
     * 설명   : 물품반류체크 팝업.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 16. hskim - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/refund-check-popup")
    public ModelAndView selectRefundChkPopup(@Validated ClaimPO po, BindingResult bindingResult) throws Exception {
    	ModelAndView mav = new ModelAndView();
    	
    	mav.setViewName("/admin/order/refund/refundChkPopup");
    	
        ClaimVO vo = refundService.selectRefundChk(po);
        
        mav.addObject("claimVO", vo);
        
        String erpYn = po.getErpYn();
        if(StringUtils.isEmpty(erpYn)){
        	erpYn = "N";
        }
        mav.addObject("erpYn", erpYn);

        return mav;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 16.
     * 작성자 : hskim
     * 설명   : 물품반류체크 수정.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 16. hskim - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/refund-check-update")
    public @ResponseBody ResultModel<ClaimVO> updateRefundChk(@Validated ClaimPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<ClaimVO> result = refundService.updateRefundChk(po);
        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 9. 4.
     * 작성자 : CBK
     * 설명   : 다비젼(물류센터)에서 확인 하기 위한 반품 신청 정보 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 4. CBK - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    @RequestMapping("claim-reason")
    public ModelAndView viewClaimReason(ClaimPO po) throws Exception {
    	ModelAndView mav = new ModelAndView();
    	mav.setViewName("/admin/order/refund/claimReason");
    	
    	ClaimGoodsVO vo = refundService.selectClaimReason(po);
        
        mav.addObject("claimGoodsVo", vo);
        
        String erpYn = po.getErpYn();
        if(StringUtils.isEmpty(erpYn)){
        	erpYn = "N";
        }
        mav.addObject("erpYn", erpYn);
    	
        return mav;
    }

    // 주문 번호를 기준으로 반품(환불) 가능한 목록 조회
    @RequestMapping("/refund-request-list")
    public @ResponseBody ResultModel<OrderVO> selectOrdDtlForExchange(OrderInfoVO orderInfoVo,
                                                                      BindingResult bindingResult,
                                                                      HttpServletRequest request) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        String referer = request.getHeader("referer");
        if(referer.indexOf("seller")>-1){
            orderInfoVo.setSellerNo(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        }else{
            orderInfoVo.setSellerNo(null);
        }

        ResultModel<OrderVO> result = refundService.selectRefundRequestList(orderInfoVo);
        return result;
    }
}
