package net.danvi.dmall.admin.web.view.order.salesproof;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofPO;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofSO;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofVO;
import net.danvi.dmall.biz.app.order.salesproof.service.SalesProofService;
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
@RequestMapping("/admin/order/salesproof")
public class SalesProofController {

    @Resource(name = "salesProofService")
    private SalesProofService salesProofService;

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
    @RequestMapping("/sales-proof")
    public ModelAndView viewSalesProofListPaging(SalesProofSO so) {
        log.debug("================================");
        log.debug("Start : " + "매출증빙 목록을 조회하는 화면");
        log.debug("================================");
        ModelAndView mv = new ModelAndView("/admin/order/salesproof/viewSalesProofListPaging");

        mv.addObject("salesProofSO", so);
        return mv;
    }

    @RequestMapping("/salesproof-list")
    public @ResponseBody ResultListModel<SalesProofVO> selectSalesProofListPaging(SalesProofSO so,
            BindingResult bindingResult) {

        log.debug("================================");
        log.debug("Start : " + "viewSalesProofListPaging 에서 넘어온 검색조건에 맞는 목록을 조회하여 리턴");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultListModel<SalesProofVO> resultList = salesProofService.selectSalesProofListPaging(so);
        return resultList;
    }

    @RequestMapping("/salesproof-excel-download")
    public String selectSalesProofListExcel(SalesProofSO so, BindingResult bindingResult, Model model) {
        log.debug("================================");
        log.debug("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.debug("================================");
        so.setOffset(10000000);
        List<SalesProofVO> resultList = salesProofService.selectSalesProofListExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "주문번호", "주문일", "주문자", "결제금액", "결제방법", "상태", "신청자", "신청일", "공급가", "부가세",
                "합계", "처리확정일", "처리방법", "처리상태" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "ordNo", "ordDay", "ordrNm", "paymentAmt", "paymentWayNm", "ordStatusNm",
                "applicantNm", "regDay", "mainAmt", "vatAmt", "paymentAmt", "regDay", "linkYn", "proofStatusNm" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "salesProofList_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
    }

    @RequestMapping("/salesproof-memo")
    public @ResponseBody ResultModel<SalesProofVO> selectSalesProofMemo(SalesProofVO vo, BindingResult bindingResult) {

        log.debug("================================");
        log.debug("Start : " + "매출증빙 메모 내용 리턴");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<SalesProofVO> result = new ResultModel<SalesProofVO>();
        result.setData(salesProofService.selectSalesProofMemo(vo));
        return result;
    }

    @RequestMapping("/salesproof-memo-update")
    public @ResponseBody ResultModel<SalesProofVO> updateSalesProofMemo(SalesProofVO vo, BindingResult bindingResult) {
        log.debug("================================");
        log.debug("Start : " + "메모를 수정한다");
        log.debug("================================");
        ResultModel<SalesProofVO> result = new ResultModel<SalesProofVO>();

        boolean isSuccess = salesProofService.updateSalesProofMemo(vo);
        result.setSuccess(isSuccess);
        result.setData(vo);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        if (isSuccess)
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        else
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        return result;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 24.
     * 작성자 : kdy
     * 설명   : 주문번호로 현금영수증 발행을 위한 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 24. kdy - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     */
    @RequestMapping("/salesproof-order-number")
    public @ResponseBody ResultModel<SalesProofVO> selectSalesProofOrdNo(SalesProofVO vo, BindingResult bindingResult) {

        log.debug("================================");
        log.debug("Start : " + "등록된 매출증빙 내용 조회");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        return salesProofService.selectSalesProofOrdNo(vo);

    }

    @RequestMapping("/cash-receipt-insert")
    public @ResponseBody ResultModel<SalesProofVO> insertCashRct(SalesProofPO salesProofPO, BindingResult bindingResult,
            @RequestParam Map<String, Object> reqMap) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "영수증 등록한다");
        log.debug("================================");
        Date today = salesProofPO.getRegDttm();
        salesProofPO.setRegDttm(today);
        salesProofPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<SalesProofVO> result = salesProofService.insertCashRctIssue(salesProofPO, reqMap);
        return result;
    }

    @RequestMapping("/taxbill-insert")
    public @ResponseBody ResultModel<SalesProofVO> insertTaxBill(SalesProofPO po, BindingResult bindingResult)
            throws Exception {
        log.debug("================================");
        log.debug("Start : " + "세금계산서 등록한다");
        log.debug("================================");
        Date today = po.getRegDttm();
        po.setRegDttm(today);
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<SalesProofVO> result = salesProofService.insertTaxBill(po);
        return result;
    }

    @RequestMapping("/cash-receipt")
    public @ResponseBody ResultModel<SalesProofVO> selectCashRct(SalesProofVO vo, BindingResult bindingResult)
            throws Exception {

        log.debug("================================");
        log.debug("Start : " + "현금영수증 신청정보 조회");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        return salesProofService.selectCashRct(vo);

    }

    @RequestMapping("/taxbill")
    public @ResponseBody ResultModel<SalesProofVO> selectTaxBill(SalesProofVO vo, BindingResult bindingResult)
            throws Exception {

        log.debug("================================");
        log.debug("Start : " + "세금계산서 신청정보 조회");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        return salesProofService.selectTaxBill(vo);

    }
}
