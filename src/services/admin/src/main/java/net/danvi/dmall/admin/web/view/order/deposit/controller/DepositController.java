package net.danvi.dmall.admin.web.view.order.deposit.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.order.deposit.model.DepositSO;
import net.danvi.dmall.biz.app.order.deposit.model.DepositVO;
import net.danvi.dmall.biz.app.order.deposit.service.DepositService;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;

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
@RequestMapping("/admin/order/deposit")
public class DepositController {

    @Resource(name = "depositService")
    private DepositService depositService;

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 무통장 입금 목록을 조회하는 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/banking")
    public ModelAndView viewBankingListPaging(DepositSO so) {
        log.debug("================================");
        log.debug("Start : " + "무통장 입금 목록을 조회하는 화면");
        log.debug("================================");
        ModelAndView mv = new ModelAndView("/admin/order/deposit/viewBankingListPaging");
        mv.addObject("deliverySO", so);
        return mv;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 무통장 입금 목록 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/banking-list")
    public @ResponseBody ResultListModel<DepositVO> selectBankingListPaging(DepositSO so, BindingResult bindingResult)
            throws Exception {

        log.debug("================================");
        log.debug("Start : " + "무통장 입금 목록을 조회하여 리턴");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        so.setPaymentWayCd("11"); // 무통장 입금
        if ("02".equals(so.getSearchCd()) || "03".equals(so.getSearchCd())) { // 주문자명
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }

        ResultListModel<DepositVO> resultList = depositService.selectDepositListPaging(so);
        return resultList;
    }

    @RequestMapping("/deposit-excel-download")
    public String selectDepositListExcel(DepositSO so, BindingResult bindingResult, Model model) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.debug("================================");
        so.setOffset(10000000);
        if ("02".equals(so.getSearchCd()) || "03".equals(so.getSearchCd())) { // 주문자명
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }
        List<DepositVO> resultList = depositService.selectDepositListExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "주문번호", "은행명", "계좌번호", "입금자", "입금액", "주문상태", "입금완료일" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "ordNo", "bankNm", "actNo", "dpsterNm", "paymentAmt", "ordStatusNm",
                "paymentCmpltDttm" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME,
                "deposit" + so.getPaymentWayCd() + "List_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 가상계좌 입금 목록을 조회하는 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/vaccount")
    public ModelAndView viewVAccountListPaging(DepositSO so) {
        log.debug("================================");
        log.debug("Start : " + "가상 계좌 입금 목록을 조회하는 화면");
        log.debug("================================");
        ModelAndView mv = new ModelAndView("/admin/order/deposit/viewVAccountListPaging");
        mv.addObject("deliverySO", so);
        return mv;
    }

    @RequestMapping("/vaccount-list")
    public @ResponseBody ResultListModel<DepositVO> selectVAccountListPaging(DepositSO so, BindingResult bindingResult)
            throws Exception {

        log.debug("================================");
        log.debug("Start : " + "가상 계좌 입금 목록을 조회하여 리턴");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        so.setPaymentWayCd("22"); // 가상 계좌
        if ("02".equals(so.getSearchCd()) || "03".equals(so.getSearchCd())) { // 주문자명
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }
        ResultListModel<DepositVO> resultList = depositService.selectDepositListPaging(so);
        return resultList;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : dong
     * 설명   : 무통장 입금의 결제 처리 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param request
     * @return
     */
    @RequestMapping("/paydone-update")
    public @ResponseBody ResultModel<OrderInfoVO> updateOrdStatusPayDone(@Validated OrderGoodsVO vo,
            HttpServletRequest request) throws CustomException {
        log.debug("================================");
        log.debug("curOrdStatusCd : " + request.getParameter("curOrdStatusCd"));
        log.debug("curOrdStatusCd : " + vo.getOrdStatusCd());
        log.debug("================================");

        ResultModel<OrderInfoVO> result = new ResultModel<OrderInfoVO>();
        result.setSuccess(depositService.updateOrdStatusPayDone(vo, request.getParameter("curOrdStatusCd")));
        return result;
    }

}
