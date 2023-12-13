package net.danvi.dmall.admin.web.view.order.exchange.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.order.exchange.service.ExchangeService;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import dmall.framework.common.constants.CommonConstants;
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
@RequestMapping("/admin/order/exchange")
public class ExchangeController {
    @Resource(name = "exchangeService")
    private ExchangeService exchangeService;

    @Resource(name = "orderService")
    private OrderService orderService;

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

        ModelAndView mv = new ModelAndView("/admin/order/exchange/viewExchangeListPaging");
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

        if ("04".equals(so.getSearchCd()) || "05".equals(so.getSearchCd())) {
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }

        if ("all".equals(so.getSearchCd())) {
            so.setSearchWordEncrypt(CryptoUtil.encryptAES(so.getSearchWord()));
        }

        ResultListModel<ClaimGoodsVO> resultList = exchangeService.selectExchangeListPaging(so);
        return resultList;
    }

    @RequestMapping("/exchange-excel-download")
    public String selectExchangeListExcel(ClaimSO so, BindingResult bindingResult, Model model) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.debug("================================");
        so.setOffset(10000000);

        if ("04".equals(so.getSearchCd()) || "05".equals(so.getSearchCd())) {
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }

        if ("all".equals(so.getSearchCd())) {
            so.setSearchWordEncrypt(CryptoUtil.encryptAES(so.getSearchWord()));
        }

        List<ClaimGoodsVO> resultList = exchangeService.selectExchangeListExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "반품접수일시", "주문번호", "반품번호", "주문자", "결제방법", "주문수량", "반품교환수량", "처리자", "교환완료일시",
                "반품처리상태", "교환처리상태" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "claimAcceptDttm", "ordNo", "claimNo", "ordrNm", "paymentWayNm", "ordQtt", "claimQtt", "regrNm", "claimCmpltDttm",
                "returnNm", "claimNm" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "ExchangeList_" + DateUtil.getNowDate()); // 엑셀

        return View.excelDownload();
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

        ResultListModel<ClaimGoodsVO> resultList = exchangeService.selectOrdDtlExchange(so);
        return resultList;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 7. 4.
     * 작성자 : dong
     * 설명   : 교환 목록에서 교환 팝업창의 주문 상품 목록 출력  
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 4. dong - 최초생성
     * </pre>
     *
     * @param orderInfoVo
     * @param bindingResult
     * @return
     */
    @RequestMapping("/order-detail-exchange")
    public @ResponseBody ResultModel<OrderVO> selectOrdDtlForExchange(OrderInfoVO orderInfoVo,
            BindingResult bindingResult,HttpServletRequest request) {
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
        ResultModel<OrderVO> result = exchangeService.selectOrdDtlForExchange(orderInfoVo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문상품 교환내용을 등록한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/exchange-order-insert")
    public @ResponseBody ResultModel<ClaimGoodsVO> registOrdDtlExchange(ClaimGoodsPO po) throws Exception{
        log.debug("================================");
        log.debug("Start : " + "주문상품 교환내용을 등록 또는 수정 한다");
        log.debug("po : " + po);
        log.debug("================================");
        ResultModel<ClaimGoodsVO> result = exchangeService.processClaimExchange(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문상품 교환내용을 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/exchange-order-update")
    public ModelAndView updateOrdDtlExchange() {
        log.debug("================================");
        log.debug("Start : " + "주문상품 교환내용을 수정한다");
        log.debug("================================");
        return new ModelAndView("/admin/order/updateOrdDtlExchange");
    }

}
