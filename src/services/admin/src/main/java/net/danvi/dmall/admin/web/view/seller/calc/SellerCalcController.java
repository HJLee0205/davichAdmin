package net.danvi.dmall.admin.web.view.seller.calc;

import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.seller.model.CalcDeductVO;
import net.danvi.dmall.biz.app.seller.model.CalcDeductVOListWrapper;
import net.danvi.dmall.biz.app.seller.model.CalcVO;
import net.danvi.dmall.biz.app.seller.model.CalcVOListWrapper;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.service.CalcSellerService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;

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
@RequestMapping("/admin/seller/calc")
public class SellerCalcController {
    
    @Resource(name = "calcSellerService")
    private CalcSellerService calcSellerService;

    /**
     * <pre>
     * 작성일 : 2017. 12. 21.
     * 작성자 : kimhy
     * 설명   : 판매자 정산 집계
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/calc-manager-list")
    public ModelAndView calcManagerList(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/calc/CalcManagerList");
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }        
        
        try {
        	//판매자 세팅
        	so.setSellerNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getSellerNo()));
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        	
            mv.addObject("so", so);

            // 정산집계 목록
            mv.addObject("resultListModel", calcSellerService.selectCalcSellerList(so));
        } catch (Exception e) {
            throw new Exception("정산집계 목록 조회 오류");
        }

        // 사이트 번호
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        
        return mv;
    }    
    
    

    /**
     * <pre>
     * 작성일 : 2018. 10. 12.
     * 작성자 : kimhy
     * 설명   : 정산 상세내역
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/calc-manager-dtl-list")
    public ModelAndView calcManagerDtlList(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/calc/CalcManagerDtlList");
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }        
        
        try {
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            
            mv.addObject("so", so);
        	//판매자 세팅
        	so.setSellerNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getSellerNo()));

            mv.addObject("resultListModel", calcSellerService.selectLedgerDtlList(so));
        } catch (Exception e) {
            throw new Exception("정산집계 목록 조회 오류");
        }

        // 사이트 번호
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        
        return mv;
    }    
    
    
    /**
     * <pre>
     * 작성일 : 2017. 12. 21.
     * 작성자 : kimhy
     * 설명   : 판매자 정산 집계
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * </pre>
     *
     * @return
     */

    @RequestMapping("/calc-dtl-list")
    public ModelAndView calcDtlList(SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/calc/CalcTotalDtlList");
        mv.addObject(so);
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }        
        
        try {
            // 정산집계 목록
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            mv.addObject("resultListModel", calcSellerService.selectLedgerDtlList(so));
            
        } catch (Exception e) {
            throw new Exception("정산집계 상세 목록 조회 오류");
        }

        // 사이트 번호
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        
        return mv;        
    }
    
    
    /**
     * <pre>
     * 작성일 : 2017. 12. 29.
     * 작성자 : kimhy
     * 설명   : 검색조건에 따른 판매자 목록을 조회 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 29. kimhy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */

    @RequestMapping("/calc-deduct-list")
    public @ResponseBody List<CalcDeductVO> selectCalcDeductList(SellerSO so, BindingResult bindingResult) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
        List<CalcDeductVO> resultListModel;
		resultListModel = calcSellerService.selectDeductList(so);

        return resultListModel;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2017. 12. 26.
     * 작성자 : kimhy
     * 설명   : 판매자 정산
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 26. 김현열 - 최초생성
     * </pre>
     *
     * @param eventPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/calc-deduct-save")
    public @ResponseBody ResultModel<CalcDeductVO> saveCalcDeduct(CalcDeductVOListWrapper wrapper, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
        ResultModel<CalcDeductVO> result = null;
        try {
            result = calcSellerService.saveCalcDeduct(wrapper);
        } catch (Exception e) {
            // TODO Auto-generated catch block
        }
        return result;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 26.
     * 작성자 : khy
     * 설명   : 검색 조건에 따른 회원리스트 Excel 다운로드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 26. khy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/calc-total-download")
    public String selectCalcTotalExcel(SellerSO so, BindingResult bindingResult, Model model) {
        so.setOffset(10000000);
    	so.setSellerNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getSellerNo()));
        List<SellerVO> resultList = calcSellerService.selectCalcTotalExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "정산일자", "정산기준 시작일", "정산기준 종료일", "결제금액", "수수료", "정산금액"};
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rowNum", "calculateDttm", "calculateStartdt", "calculateEnddt", "paymentAmt", "cmsTotal", "calculateAmt"};
        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("정산집계 목록", headerName, fieldName, resultList));
        // 파일명
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "calculateTotal_" + DateUtil.getNowDate()); // 엑셀

        return View.excelDownload();
    }       

    
    /**
     * <pre>
     * 작성일 : 2017. 11. 26.
     * 작성자 : khy
     * 설명   : 검색 조건에 따른 회원리스트 Excel 다운로드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 26. khy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/calc-dtl-download")
    public String selectCalcDtlExcel(SellerSO so, BindingResult bindingResult, Model model) {
        so.setOffset(10000000);
    	so.setSellerNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getSellerNo()));
        List<SellerVO> resultList = calcSellerService.selectCalcDtlExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "주문번호", "주문상세번호", "상품명", "판매수량", "구매자명", "정산기준일", "정산일자", "배송비", "결제금액", "입점수수료(%)", "쿠폰할인금액","프로모션할인금액","마켓포인트 사용금액","마켓포인트 적립금액","마켓포인트(추천인)적립금액","최종지급금액","택배사","송장번호","정산구분"};
        String[] fieldName = new String[] { "rwn", "ordNo", "ordDtlSeq", "goodsNm", "ordQtt", "ordrNm", "calculateStndrdDt", "calculateDttm", "dlvrAmt", "paymentAmt", "sellerCmsRate", "cpDcAmt","prmtDcAmt","moneyUseAmt","moneyAccuAmt","moneyRecomAccuAmt","ltPvdAmt","courierNm","invoiceNo","calculateGb" };
        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("정산집계 상세 목록", headerName, fieldName, resultList));
        // 파일명
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "calculateDtl_" + DateUtil.getNowDate()); // 엑셀

        return View.excelDownload();
    }
    
    
    @RequestMapping("/calculate-status-change")
    public @ResponseBody ResultModel<CalcVO> updateCalculateChange(CalcVO vo, BindingResult bindingResult) throws Exception {

        ResultModel<CalcVO> result = calcSellerService.updateCalcChange(vo);
        result.setMessage(MessageUtil.getMessage("admin.web.seller.approvalCalc"));

        return result;
    }

    @RequestMapping("/calculate-delete")
    public @ResponseBody ResultModel<CalcVO> deleteCalculate(CalcVOListWrapper wrapper, BindingResult bindingResult) throws Exception {

        // 리스트 화면에서 전시 미전시 처리
        ResultModel<CalcVO> result = calcSellerService.deleteCalculate(wrapper);

        return result;
    }
}
