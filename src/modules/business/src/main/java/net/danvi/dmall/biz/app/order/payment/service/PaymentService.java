package net.danvi.dmall.biz.app.order.payment.service;

import java.util.Map;

import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigVO;
import org.springframework.web.servlet.ModelAndView;

import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.core.model.payment.PaymentModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 11.
 * 작성자     : dong
 * 설명       : 결제서비스
 * </pre>
 */
public interface PaymentService {

    /** PG사 결제처리 **/
    public ResultModel<PaymentModel<?>> pgPayment(OrderPayPO po, Map<String, Object> reqMap, ModelAndView mav)
            throws Exception;

    /** PG사 취소 **/
    public ResultModel<PaymentModel<?>> pgPaymentCancel(PaymentModel<?> paymentModel) throws Exception;

    /** PG사 결제처리 (모바일) **/
    public ResultModel<PaymentModel<?>> pgPaymentMobile(OrderPayPO po, Map<String, Object> reqMap, ModelAndView mav)
            throws Exception;

    /** PG사 취소(모바일) **/
    public ResultModel<PaymentModel<?>> pgPaymentCancelMobile(PaymentModel<?> paymentModel) throws Exception;

    public CommPaymentConfigVO getPGInfo(String pgCd) throws Exception;
    public SimplePaymentConfigVO getPaycoPGInfo() throws Exception;
    public CommPaymentConfigVO getPaypalPGInfo() throws Exception;
}
