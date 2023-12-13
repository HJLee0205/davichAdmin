package net.danvi.dmall.admin.web.view.setup.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.PopManageSO;
import net.danvi.dmall.biz.app.setup.payment.model.*;
import net.danvi.dmall.biz.app.setup.payment.service.PaymentManageService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.Writer;

/**
 * Created by dong on 2016-06-02.
 */

@Slf4j
@Controller
@RequestMapping("/admin/setup/config/payment")
public class PaymentManageController {
    @Resource(name = "paymentManageService")
    private PaymentManageService paymentManageService;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    @RequestMapping("/payment-list")
    public ModelAndView viewPaymentManageList(@Validated CommPaymentConfigSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/setup/payment/paymentManageList");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);
        // 팝업 리스트 조회
        mv.addObject("resultListModel", paymentManageService.selectPaymentPaging(so));

        return mv;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 결제 설정정보 관리 페이지 이동
     */
    @RequestMapping("/payment-config")
    public ModelAndView viewPaymentConfig(HttpServletRequest request, Model model) {
        String shopCd = request.getParameter("shopCd");
        ModelAndView mav = new ModelAndView("/admin/setup/payment/paymentManage");
        mav.addObject("editYn", "Y");
        mav.addObject("shopCd", shopCd);

        // 무통장 결제일때 무통장 등록 가능 여부 플래그를 view로 넘겨준다.
        /*if ("nopbPay".equals(typeCd)) {
            mav.addObject("regLitmitFlag",siteQuotaService.isAccountAddible(SessionDetailHelper.getDetails().getSiteNo()));
        }*/
        return mav;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 결제 설정정보 관리 페이지 이동
     */
    @RequestMapping("/payment-config-new")
    public ModelAndView viewPaymentConfigNew() {
        ModelAndView mav = new ModelAndView("/admin/setup/payment/paymentManage");
        mav.addObject("editYn", "N");

        // 무통장 결제일때 무통장 등록 가능 여부 플래그를 view로 넘겨준다.
        /*if ("nopbPay".equals(typeCd)) {
            mav.addObject("regLitmitFlag",siteQuotaService.isAccountAddible(SessionDetailHelper.getDetails().getSiteNo()));
        }*/
        return mav;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 결제관리 신청안내 페이지 이동
     */
    @RequestMapping("/payment-apply")
    public ModelAndView viewPaymentApply(HttpServletRequest request, Model model) {
        String typeCd = request.getParameter("typeCd");
        ModelAndView mav = new ModelAndView("/admin/setup/payment/" + typeCd + "Apply");
        mav.addObject("typeCd", typeCd);
        return mav;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장계좌 정보 단건 조회
     */
    @RequestMapping("/nopbpayment-info")
    public @ResponseBody ResultModel<NopbPaymentConfigVO> selectNopbPaymentConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<NopbPaymentConfigVO> result = paymentManageService.selectNopbPaymentConfig(siteNo);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장계좌 정보 리스트 조회
     */
    @RequestMapping("/nopbpayment-list")
    public @ResponseBody ResultListModel<NopbPaymentConfigVO> selectNopbPaymentList() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        // 솔직히 페이징은 필요가없다.
        return paymentManageService.selectNopbPaymentList(sessionInfo.getSiteNo());
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장계좌 은행 정보 리스트 조회
     */
    @RequestMapping("/nopbbank-list")
    public @ResponseBody ResultListModel<CmnCdDtlVO> selectNopbBankList() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        ResultListModel<CmnCdDtlVO> resultList = new ResultListModel<CmnCdDtlVO>();
        resultList.setResultList(ServiceUtil.listCode("BANK_CD"));
        return resultList;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 통합전자결제 설정 정보 단건 조회
     */
    @RequestMapping("/payment-config-info")
    public @ResponseBody ResultModel<CommPaymentConfigVO> selectCommPaymentConfig(CommPaymentConfigSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        ResultModel<CommPaymentConfigVO> result = paymentManageService.selectCommPaymentConfig(so);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 간편결제 설정 정보 단건 조회
     */
    @RequestMapping("/simplepayment-config")
    public @ResponseBody ResultModel<SimplePaymentConfigVO> selectSimplePaymentConfig(SimplePaymentConfigSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        ResultModel<SimplePaymentConfigVO> result = paymentManageService.selectSimplePaymentConfig(so);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : NPAY 설정 정보 단건 조회
     */
    @RequestMapping("/npay-config-info")
    public @ResponseBody ResultModel<NPayConfigVO> selectNPayConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        ResultModel<NPayConfigVO> result = paymentManageService.selectNPayConfig(siteNo);
        return result;
    }


    /**
     * <pre>
     * 작성자 : dong
     * 설명 : NPAY 상품정보요청
     */
    @RequestMapping("/npay-item-info")
    public void selectNPayItemInfo(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String[] itemIds = req.getParameterValues("ITEM_ID");
        resp.setContentType("application/xml;charset=UTF-8");
        Writer writer = resp.getWriter();
        writer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
        writer.write("<response>\r\n");
        for (String itemId : itemIds) {
            paymentManageService._writeItemInfo(itemId, writer, req);
        }
        writer.write("</response>");
        writer.flush();
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 해외 결제 설정 정보 단건 조회
     */
    @RequestMapping("/foreignpayment-config-info")
    public @ResponseBody ResultModel<CommPaymentConfigVO> selectForeignPaymentConfig() {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        ResultModel<CommPaymentConfigVO> result = paymentManageService
                .selectForeignPaymentConfig(sessionInfo.getSiteNo());
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장계좌 사용여부 수정
     */
    @RequestMapping("/nopbpayment-config-update")
    public @ResponseBody ResultModel<NopbPaymentConfigPO> updateNopbPaymentConfig(
            @Validated(UpdateGroup.class) NopbPaymentConfigPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<NopbPaymentConfigPO> result = paymentManageService.updateNopbPaymentConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장 계좌 정보 추가
     */
    @RequestMapping("/nopbaccount-insert")
    public @ResponseBody ResultModel<NopbPaymentConfigPO> insertNopbAccount(
            @Validated(InsertGroup.class) NopbPaymentConfigPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<NopbPaymentConfigPO> result = paymentManageService.insertNopbAccount(po);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장 계좌 정보 수정
     */
    @RequestMapping("/nopbaccount-update")
    public @ResponseBody ResultModel<NopbPaymentConfigPO> updateNopbAccount(
            @Validated(UpdateGroup.class) NopbPaymentConfigPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<NopbPaymentConfigPO> result = paymentManageService.updateNopbAccount(po);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장 계좌 정보 삭제
     */
    @RequestMapping("/nopbaccount-delete")
    public @ResponseBody ResultModel<NopbPaymentConfigPO> deleteNopbAccount(
            @Validated(UpdateGroup.class) NopbPaymentConfigPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<NopbPaymentConfigPO> result = paymentManageService.deleteNopbAccount(po);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장 계좌 정보 추가
     */
    @RequestMapping("/payment-config-insert")
    public @ResponseBody ResultModel<CommPaymentConfigPO> insertCommPaymentConfig(
            @Validated(InsertGroup.class) CommPaymentConfigPO po, BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.info("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setEditYn("N");
        ResultModel<CommPaymentConfigPO> result = paymentManageService.insertCommPaymentConfig(po, request);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 통합전자결제 설정 정보 수정
     */
    @RequestMapping("/payment-config-update")
    public @ResponseBody ResultModel<CommPaymentConfigPO> updateCommPaymentConfig(
            @Validated(UpdateGroup.class) CommPaymentConfigPO po, BindingResult bindingResult,
            HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.info("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        po.setEditYn("Y");
        ResultModel<CommPaymentConfigPO> result = paymentManageService.updateCommPaymentConfig(po, request);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 무통장 계좌 정보 삭제
     */
    @RequestMapping("/payment-config-delete")
    public @ResponseBody ResultModel<CommPaymentConfigPO> deleteNopbAccount(
            @Validated(UpdateGroup.class) CommPaymentConfigPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CommPaymentConfigPO> result = paymentManageService.deleteCommPaymentConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 간편결제 설정 정보 수정
     */
    @RequestMapping("/simplepayment-config-update")
    public @ResponseBody ResultModel<SimplePaymentConfigPO> updateSimplePaymentConfig(
            @Validated(UpdateGroup.class) SimplePaymentConfigPO po, BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<SimplePaymentConfigPO> result = paymentManageService.updateSimplePaymentConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : NPAY 설정 정보 수정
     */
    @RequestMapping("/npay-config-update")
    public @ResponseBody ResultModel<NPayConfigPO> updateNPayConfig(@Validated(UpdateGroup.class) NPayConfigPO po,
                                                                    BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<NPayConfigPO> result = paymentManageService.updateNPayConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성자 : dong
     * 설명 : 해외결제 설정 정보 수정
     */
    @RequestMapping("/foreignpayment-config-update")
    public @ResponseBody ResultModel<CommPaymentConfigPO> updateForeignPaymentConfig(
            @Validated(UpdateGroup.class) CommPaymentConfigPO po, BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.getSession().getMemberNo() != null) {
            po.setUpdrNo(sessionInfo.getSession().getMemberNo());
        }

        ResultModel<CommPaymentConfigPO> result = paymentManageService.updateForeignPaymentConfig(po);
        return result;
    }
}