package net.danvi.dmall.biz.system.remote.payment;

import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import net.danvi.dmall.core.model.payment.PaymentModel;
import net.danvi.dmall.core.service.PaymentCommnService;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 5. 3.
 * 작성자     : KNG
 * 설명       : 결제 공통 서비스 클래스
 * </pre>
 */
public interface PaymentAdapterService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 15.
     * 작성자 : KNG
     * 설명   : PG코드로 PG 결제처리 서비스 클래스 얻기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 15. KNG - 최초생성
     * </pre>
     *
     * @param paymentPgCd
     * @return
     */
    public PaymentCommnService getPaymentService(String paymentPgCd);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : KNG
     * 설명   : 결제 자식PO클래스 얻기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. KNG - 최초생성
     * </pre>
     *
     * @param paymentPgCd
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> Class<C> getChildPO(String paymentPgCd);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 결제인증요청
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> cert(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 결제인증요청결과
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> certReturn(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 승인요청
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> approve(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 승인요청Rollback
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> approveRollback(ResultModel<PaymentModel<?>> rsm,
            ModelAndView mav) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 입금통보 (무통장(가상계좌)일 경우만)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param payment
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> depositNotice(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 결제취소요청
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> cancel(PaymentModel<?> paymentModel) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 현금영수증 발급/취소요청
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> receipt(PaymentModel<?> paymentModel) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 에스크로 배송정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> escrowSend(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 에스크로 처리결과수신(LGU+ 예) C=수령확인결과, R=구매취소요청, D=구매취소결과, N=NC처리결과)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> escrowReceive(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KDY
     * 설명   : PG 승인요청 (모바일)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 15. KDY - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> approveMobile(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KDY
     * 설명   : PG 결제취소요청 (모바일)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 15. KDY - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @SuppressWarnings({ "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> cancelMobile(PaymentModel<?> paymentModel)
            throws Exception;

}