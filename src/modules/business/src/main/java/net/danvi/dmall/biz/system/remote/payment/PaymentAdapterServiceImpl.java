package net.danvi.dmall.biz.system.remote.payment;

import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.batch.common.service.IfService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.batch.common.model.IfLogVO;
import net.danvi.dmall.core.constants.CoreConstants;
import net.danvi.dmall.core.model.payment.AlltheGatePO;
import net.danvi.dmall.core.model.payment.InicisPO;
import net.danvi.dmall.core.model.payment.KcpPO;
import net.danvi.dmall.core.model.payment.LguPO;
import net.danvi.dmall.core.model.payment.PaycoPO;
import net.danvi.dmall.core.model.payment.PaymentModel;
import net.danvi.dmall.core.model.payment.PaypalPO;
import net.danvi.dmall.core.service.PaymentCommnService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.BeansUtil;
import dmall.framework.common.util.ConverterUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 5. 3.
 * 작성자     : KNG
 * 설명       : 결제 공통 서비스 클래스
 * </pre>
 */
@Slf4j
@Service("paymentAdapterService")
@Transactional(rollbackFor = Exception.class)
public class PaymentAdapterServiceImpl implements PaymentAdapterService {
    private PaymentCommnService paymentCommnService;

    @Resource(name = "paymentKcpService")
    private PaymentCommnService paymentKcpService;
    @Resource(name = "paymentInicisService")
    private PaymentCommnService paymentInicisService;
    @Resource(name = "paymentLguService")
    private PaymentCommnService paymentLguService;
    @Resource(name = "paymentAlltheGateService")
    private PaymentCommnService paymentAlltheGateService;
    @Resource(name = "paymentPaycoService")
    private PaymentCommnService paymentPaycoService;
    @Resource(name = "paymentPaypalService")
    private PaymentCommnService paymentPaypalService;

    @Resource(name = "ifService")
    private IfService ifService;

    @Value("#{system['system.solution.conf.rootpath']}")
    private String rootPath;

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
    @Override
    public PaymentCommnService getPaymentService(String paymentPgCd) {
        // 사이트의 결제수단 기준으로 구현클래스 가져오기 생성
        // paymentCommnService = (PaymentCommnService) BeansUtil.getBean(CoreConstants.getPgCd(pgCd));
        switch (paymentPgCd) {
        case CoreConstants.PG_CD_KCP:
            paymentCommnService = paymentKcpService;
            break;
        case CoreConstants.PG_CD_INICIS:
            paymentCommnService = paymentInicisService;
            break;
        case CoreConstants.PG_CD_LGU:
            paymentCommnService = paymentLguService;
            break;
        case CoreConstants.PG_CD_ALLTHEGATE:
            paymentCommnService = paymentAlltheGateService;
            break;
        case CoreConstants.PG_CD_PAYCO:
            paymentCommnService = paymentPaycoService;
            break;
        case CoreConstants.PG_CD_PAYPAL:
            paymentCommnService = paymentPaypalService;
            break;
        case CoreConstants.PG_CD_ALIPAY:
            paymentCommnService = paymentInicisService;
            break;
        case CoreConstants.PG_CD_TENPAY:
            paymentCommnService = paymentInicisService;
            break;
        case CoreConstants.PG_CD_WECH:
            paymentCommnService = paymentInicisService;
            break;
        default:
            paymentCommnService = null;
            break;
        }
        log.debug("Debug : {}", "PG 결제처리용 서비스 클래스는 [" + paymentCommnService + "] 입니다.");
        return paymentCommnService;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : KNG
     * 설명   : 결제 자식PO클래스 & 자식POConvert클래스 얻기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. KNG - 최초생성
     * </pre>
     *
     * @param paymentPgCd
     * @return
     */
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public <C extends PaymentModel> Class<C> getChildPO(String paymentPgCd) {
        Class<C> childClass = null;
        switch (paymentPgCd) {
        case CoreConstants.PG_CD_KCP:
            childClass = (Class<C>) KcpPO.class;
            break;
        case CoreConstants.PG_CD_INICIS:
            childClass = (Class<C>) InicisPO.class;
            break;
        case CoreConstants.PG_CD_LGU:
            childClass = (Class<C>) LguPO.class;
            break;
        case CoreConstants.PG_CD_ALLTHEGATE:
            childClass = (Class<C>) AlltheGatePO.class;
            break;
        case CoreConstants.PG_CD_PAYCO:
            childClass = (Class<C>) PaycoPO.class;
            break;
        case CoreConstants.PG_CD_PAYPAL:
            childClass = (Class<C>) PaypalPO.class;
            break;
        }
        return childClass;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> cert(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        log.debug("================================");
        log.debug(" 인증요청 기준 페이지 - 파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug(
                "######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(
                    MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        ConverterUtil.mapToMap(reqMap, childModel.getExtraMap(), false);// Request Map을 Bean값을 추가 저장
        // 05. 서비스호출
        resultModel = paymentCommnService.cert(childModel);
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        PaymentModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, PaymentModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(PaymentModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);

        String MethodName = "결제인증요청 기준페이지";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());

        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_CERT, CoreConstants.TRANSFER_MODE_SEND, childModel, rschildModel);

        return resultModel;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> certReturn(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        log.debug("================================");
        log.debug(" 인증요청 결과페이지 -  파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        // 수신처리내용이므로 각 PG별 수신처리 Controller에서 고정값으로 셋팅, 또는 세션을 사용해야 할듯
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug(
                "######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(
                    MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        resultModel = paymentCommnService.certReturn(childModel);
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        PaymentModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, PaymentModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(PaymentModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);

        String MethodName = "결제인증결과";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());

        return resultModel;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> approve(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        log.debug("================================");
        log.debug(" 승인요청/결과페이지 -  파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug("######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            log.debug("log >>> 1");
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        log.debug("log >>> 2");
        log.debug("reqMap >>> " + reqMap);
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        log.debug("log >>> 3");
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        log.debug("log >>> 4");
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        log.debug("log >>> 5");
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        log.debug("log >>> 6");
        childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        // 05.01. childModel.paymentApproveRollBackYn = N (기본값); // 승인요청 처리를 한다.
        // 05.02. childModel.paymentApproveRollBackYn = N; // 승인내역을 롤백취소처리한다.
        resultModel = paymentCommnService.approve(childModel);
        log.debug("log >>> 7");
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        PaymentModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, PaymentModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(PaymentModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);
        log.debug("log >>> 8");
        String MethodName = "결제승인요청/결과";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());
        log.debug("log >>> 1");

        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_APPROVE, CoreConstants.TRANSFER_MODE_SEND, childModel, rschildModel);
        return resultModel;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> approveRollback(ResultModel<PaymentModel<?>> rsm,
            ModelAndView mav) throws Exception {
        log.debug("================================");
        log.debug(" 승인결과 RollBack페이지 - 이전결과 =" + rsm);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        PaymentModel<?> paymentModel = (PaymentModel<?>) rsm.getData(); // 승인결과
        paymentModel.setPaymentApproveRollBackYn("Y"); // 롤백처리
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug(
                "######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(
                    MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        // ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        // ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        childModel.setExtraMap(paymentModel.getExtraMap()); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        // 05.01. childModel.paymentApproveRollBackYn = "N" (기본값); // 승인요청 처리를 한다.
        // 05.02. childModel.paymentApproveRollBackYn = "Y"; // 승인내역을 롤백취소처리한다.
        resultModel = paymentCommnService.approve(childModel);
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        PaymentModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, PaymentModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(PaymentModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);

        String MethodName = "결제승인요청/결과RollBack";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());

        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_APPROVE, CoreConstants.TRANSFER_MODE_SEND, childModel, rschildModel);
        return resultModel;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> depositNotice(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        log.debug("================================");
        log.debug(" 입금통보 페이지 -  파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.error("######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        // childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        // 05.01. childModel.paymentApproveRollBackYn = "Y" (기본값); // 승인요청 처리를 한다.
        // 05.02. childModel.paymentApproveRollBackYn = "N"; // 승인내역을 롤백취소처리한다.
        resultModel = paymentCommnService.depositNotice(childModel);
        // 06. 모델뷰 처리
        // 06.01. LGU+의 경우 responseBody로 "OK", "FAIL"만 리턴해야한다. => resultModel.getMessage() 이용
        // 06.02. 타 PG는 리턴형태 다를 수 있음
        C rschildModel = (C) resultModel.getData();
        PaymentModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, PaymentModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(PaymentModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);

        String MethodName = "결제무통장 입금/취소결과";
        log.error("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());
        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_DEPOSITNOTICE, CoreConstants.TRANSFER_MODE_RECV, childModel, rschildModel);
        return resultModel;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> cancel(PaymentModel<?> paymentModel) throws Exception {
        log.debug("================================");
        log.debug(" 결제취소 페이지 -  파라미터 = "+paymentModel);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug("######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        // ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        log.debug("childModel================================"+childModel);
        // ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        // childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        // 05.01. childModel.partCancelYn = "N" (기본값); // 전체취소처리
        // 05.02. childModel.partCancelYn = "Y"; // 부분취소처리
        String inipayHome = "";
        inipayHome = this.rootPath + "/payment/02/" + paymentModel.getSiteNo() + "/INIpay50";
        log.debug("inipayHome================================"+inipayHome);
        resultModel = paymentCommnService.cancel(childModel);
        C rschildModel = (C) resultModel.getData();
        String MethodName = "결제취소요청/결과";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());
        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_CANCEL, CoreConstants.TRANSFER_MODE_SEND, childModel, rschildModel);
        return resultModel;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> receipt(PaymentModel<?> reqPaymentModel)
            throws Exception {
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = reqPaymentModel.getPaymentPgCd();
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스

        log.debug(" po  : " + reqPaymentModel.getOrdNo());
        PaymentModel paymentModel = new PaymentModel<>();
        BeanUtils.copyProperties(reqPaymentModel, paymentModel);
        log.debug("$$$$$$$$$$$$$$$$ paymentModel $$$$$$$$$$$$$$$$");
        log.debug("ordNo : " + paymentModel.getOrdNo()); // 주문번호
        log.debug("ReqMode : " + paymentModel.getReqMode()); // 요청구분(pay:결제, mod:취소or수정)
        log.debug("goodname : " + paymentModel.getGoodsNm()); // 상품명
        log.debug("price : " + paymentModel.getTotAmt()); // 총 현금결제 금액
        log.debug("sup_price : " + paymentModel.getSupplyAmt()); // 공급가액
        log.debug("tax : " + paymentModel.getVatAmt()); // 부가세
        log.debug("srvc_price : " + paymentModel.getSvcchrgAmt()); // 봉사료
        log.debug("reg_num : " + paymentModel.getIssueWayNo()); // 현금결제자 주민등록번호(인증번호)
        log.debug("useopt : " + paymentModel.getUseGbCd()); // 현금영수증 발행용도 ("0" - 소비자 소득공제용, "1" - 사업자 지출증빙용)
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장

        log.debug("$$$$$$$$$$$$$$$$ childModel $$$$$$$$$$$$$$$$");
        log.debug("ordNo : " + childModel.getOrdNo()); // 주문번호
        log.debug("goodname : " + childModel.getReqMode()); // 요청구분(pay:결제, mod:취소or수정)
        log.debug("price : " + childModel.getTotAmt()); // 총 현금결제 금액
        log.debug("sup_price : " + childModel.getSupplyAmt()); // 공급가액
        log.debug("tax : " + childModel.getVatAmt()); // 부가세
        log.debug("srvc_price : " + childModel.getSvcchrgAmt()); // 봉사료
        log.debug("reg_num : " + childModel.getIssueWayNo()); // 현금결제자 주민등록번호(인증번호)
        log.debug("useopt : " + childModel.getUseGbCd()); // 현금영수증 발행용도 ("0" - 소비자 소득공제용, "1" - 사업자 지출증빙용)

        // 05. 서비스호출
        resultModel = paymentCommnService.receipt(childModel);
        C rschildModel = (C) resultModel.getData();
        log.debug("$$$$$$$$$$$$$$$$ 현금영수증 PG 발급 성공 $$$$$$$$$$$$$$$$");
        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_RECEIPT, CoreConstants.TRANSFER_MODE_SEND, childModel, rschildModel);
        return resultModel;
    }

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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> escrowSend(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        log.debug("================================");
        log.debug(" 에스크로 배송정보 페이지 -  파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug("######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        // childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        resultModel = paymentCommnService.escrowSend(childModel);
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        PaymentModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, PaymentModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(PaymentModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);

        String MethodName = "에스크로 처리요청(발송/수령)";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());
        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_ESCROW_SEND, CoreConstants.TRANSFER_MODE_SEND, childModel,rschildModel);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : KNG
     * 설명   : PG 에스크로 처리결과수신(C=수령확인결과, R=구매취소요청, D=구매취소결과, N=NC처리결과)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. KNG - 최초생성
     * </pre>
     *
     * @param settlement
     * @return
     */
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> escrowReceive(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        log.debug("================================");
        log.debug(" 에스크로 처리결과수신 페이지 -  파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug(
                "######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(
                    MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        resultModel = paymentCommnService.escrowReceive(childModel);
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        PaymentModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, PaymentModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(PaymentModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);

        String MethodName = "에스크로 처리결과수신";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());
        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_ESCROW_RECEIVE, CoreConstants.TRANSFER_MODE_RECV, childModel,
                rschildModel);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : KNG
     * 설명   : 모델 타입 체크
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. KNG - 최초생성
     * </pre>
     *
     * @param parentModel
     * @param tclass
     * @return
     * @throws Exception
     */
    private <T> T checkInstantType(PaymentModel<?> parentModel, Class<T> tclass) throws Exception {
        T childPO;
        if (tclass.isInstance(parentModel)) {
            childPO = (T) parentModel;
        } else {
            // <entry key="core.exception.common.casterror">입력 인스턴스 타입이 잘못 되었습니다.- {0} 타입이여야 합니다.</entry>
            throw new CustomException("core.exception.common.casterror", new Object[] { tclass.getSimpleName() });
        }
        return childPO;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 12.
     * 작성자 : KNG
     * 설명   : PG 연계 로그 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 12. KNG - 최초생성
     * </pre>
     *
     * @param method
     * @param transferMode
     * @param sendPaymentModel
     * @param receivePaymentModel
     */
    private <C extends PaymentModel<C>> void registIfLog(String method, boolean transferMode,
            PaymentModel<C> sendPaymentModel, PaymentModel<C> receivePaymentModel) {
        try {
            IfLogVO ifLogVo = new IfLogVO();
            ObjectMapper mapper = new ObjectMapper();
            // 1.송신인터페이스
            if (transferMode) {
                // 01. 계약된 PgCd 별로 사용객체 셋팅
                String paymentPgCd = sendPaymentModel.getPaymentPgCd();
                String paymentWayCd = ((StringUtil.isEmpty(sendPaymentModel.getPaymentWayCd())) ? "": sendPaymentModel.getPaymentWayCd());
                Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
                C sendChildPO = checkInstantType(sendPaymentModel, childClass);
                C recvChildPO = checkInstantType(receivePaymentModel, childClass);

                // 02.연계로그 VO 셋팅
                Long regrNo = 0L;
                if(sendChildPO.getRegrNo() != null && sendChildPO.getRegrNo().longValue() > 0L ) {
                    regrNo = sendChildPO.getRegrNo();
                } else {
                    regrNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
                }
                
                this.setIfIdPgmIdNm(method, paymentPgCd, ifLogVo, paymentWayCd); // 연계ID, 연계프로그램ID, 연계프로그램명
                ifLogVo.setSiteNo(sendChildPO.getSiteNo()); // 사이트번호
                ifLogVo.setIfGbCd("1"); // 연계구분 1.연계, 2.배치 9.기타
                ifLogVo.setSucsYn(("0000".equals(recvChildPO.getConfirmResultCd())) ? "Y" : "N"); // 성공여부
                ifLogVo.setErrCd(("0000".equals(recvChildPO.getConfirmResultCd())) ? "" : recvChildPO.getConfirmResultCd()); // 에러코드
                ifLogVo.setResultContent(recvChildPO.getConfirmResultMsg()); // 결과내용
                ifLogVo.setDataCnt(Long.parseLong("1")); // 데이터건수
                ifLogVo.setDataTotCnt(Long.parseLong("1")); // 데이터총건수
                ifLogVo.setRegrNo(regrNo); // 등록자번호 - DMALL 시스템 회원번호
                ifLogVo.setSendConts((sendPaymentModel == null) ? "" : mapper.writeValueAsString(sendPaymentModel)); // 보낸정보
                ifLogVo.setRecvConts((receivePaymentModel == null) ? "" : mapper.writeValueAsString(receivePaymentModel)); // 받은정보
                ifLogVo.setStartKey((sendChildPO.getOrdNo() ==null)? "":sendChildPO.getOrdNo().toString()); // 주문번호 저장 : 송신모델에서 발취

                log.debug("● {} ::: 연계 로그 VO 셋팅 IfLogVO:{}", ifLogVo.getIfId(), ifLogVo);
                ifService.insertIfLog(ifLogVo);
            }
            // 2.수신인터페이스
            else {
                // 01. 계약된 PgCd 별로 사용객체 셋팅
                String paymentPgCd = receivePaymentModel.getPaymentPgCd();
                String paymentWayCd = ((StringUtil.isEmpty(sendPaymentModel.getPaymentWayCd())) ? "": sendPaymentModel.getPaymentWayCd());
                Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
                C recvChildPO = checkInstantType(receivePaymentModel, childClass);
                C sendChildPO = checkInstantType(sendPaymentModel, childClass);

                // 02.연계로그 VO 셋팅
                this.setIfIdPgmIdNm(method, paymentPgCd, ifLogVo, paymentWayCd); // 연계ID, 연계프로그램ID, 연계프로그램명
                ifLogVo.setSiteNo(recvChildPO.getSiteNo()); // 사이트번호
                ifLogVo.setIfGbCd("1"); // 연계구분 1.연계, 2.배치 9.기타
                ifLogVo.setSucsYn(("0000".equals(sendChildPO.getConfirmResultCd())) ? "Y" : "N"); // 성공여부
                ifLogVo.setErrCd(("0000".equals(sendChildPO.getConfirmResultCd())) ? "" : sendChildPO.getConfirmResultCd()); // 에러코드
                ifLogVo.setResultContent(sendChildPO.getConfirmResultMsg()); // 결과내용
                ifLogVo.setDataCnt(Long.parseLong("1")); // 데이터건수
                ifLogVo.setDataTotCnt(Long.parseLong("1")); // 데이터총건수
                ifLogVo.setRegrNo(CommonConstants.MEMBER_INTERFACE_ORDER); // 등록자번호 - 주문 연계PG 번호
                ifLogVo.setSendConts((sendPaymentModel == null) ? "" : mapper.writeValueAsString(sendPaymentModel)); // 보낸정보
                ifLogVo.setRecvConts((receivePaymentModel == null) ? "" : mapper.writeValueAsString(receivePaymentModel)); // 받은정보
                ifLogVo.setStartKey((sendChildPO.getOrdNo() ==null)? "":sendChildPO.getOrdNo().toString()); // 주문번호 저장 : 송신모델에서 발취
                log.debug("● {} ::: 연계 로그 VO 셋팅 IfLogVO:{}", ifLogVo.getIfId(), ifLogVo);
                ifService.insertIfLog(ifLogVo);
            }
        } catch (Exception e) {
            log.debug("● {} ::: 연계 로그 처리를 하다가 에러가 발생하였습니다.{}", e);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 12.
     * 작성자 : KNG
     * 설명   : 인터페이스 로그ID 셋팅
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 12. KNG - 최초생성
     * </pre>
     *
     * @param method
     * @param paymentPgCd
     * @return
     */
    private void setIfIdPgmIdNm(String method, String paymentPgCd, IfLogVO ifLogVo, String paymentWayCd) {
        if (ifLogVo == null) return;
        ifLogVo.setIfPgmId("PaymentAdapterService." + method + "(" + paymentPgCd + ")");
        // 결제수단명
        String paymentWayNm = "";
        switch (paymentWayCd) {
        case CoreConstants.PAYMENT_WAY_CD_SVMN             :  paymentWayNm = "마켓포인트"  ; break;
        case CoreConstants.PAYMENT_WAY_CD_NOPB             :  paymentWayNm = "무통장"  ; break;
        case CoreConstants.PAYMENT_WAY_CD_ACT_TRANS        :  paymentWayNm = "계좌이체"; break;
        case CoreConstants.PAYMENT_WAY_CD_VIRT_ACT_TRANS   :  paymentWayNm = "가상계좌"; break;
        case CoreConstants.PAYMENT_WAY_CD_CRED             :  paymentWayNm = "신용카드"; break;
        case CoreConstants.PAYMENT_WAY_CD_MOBILE           :  paymentWayNm = "휴대폰"  ; break;
        case CoreConstants.PAYMENT_WAY_CD_SIMPLEPAY        :  paymentWayNm = "간편결제"; break;
        case CoreConstants.PAYMENT_WAY_CD_FRGPAY           :  paymentWayNm = "해외결제"; break;
        default                                            :  paymentWayNm = "없음"    ; break;
        }
        switch (method) {
        case CoreConstants.PAYMENT_METHOD_CERT:
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-009"); ifLogVo.setIfPgmNm("KCP"       +"-인증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-017"); ifLogVo.setIfPgmNm("INICIS"    +"-인증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-025"); ifLogVo.setIfPgmNm("LGU"       +"-인증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-049"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-인증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-033"); ifLogVo.setIfPgmNm("PAYCO"     +"-인증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-041"); ifLogVo.setIfPgmNm("PAYPAL"    +"-인증-" + paymentWayNm); break;
            default                             :  ifLogVo.setIfId("IF-O-001"); ifLogVo.setIfPgmNm("없음"      +"-인증-" + paymentWayNm); break;
            }
            break;
        case CoreConstants.PAYMENT_METHOD_APPROVE:
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-010"); ifLogVo.setIfPgmNm("KCP"       +"-승인-" + paymentWayNm); break;
            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-018"); ifLogVo.setIfPgmNm("INICIS"    +"-승인-" + paymentWayNm); break;
            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-026"); ifLogVo.setIfPgmNm("LGU"       +"-승인-" + paymentWayNm); break;
            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-050"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-승인-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-034"); ifLogVo.setIfPgmNm("PAYCO"     +"-승인-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-042"); ifLogVo.setIfPgmNm("PAYPAL"    +"-승인-" + paymentWayNm); break;
            default                             :  ifLogVo.setIfId("IF-O-002"); ifLogVo.setIfPgmNm("없음"      +"-승인-" + paymentWayNm); break;
            }
            break;
        case CoreConstants.PAYMENT_METHOD_CANCEL:
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-011"); ifLogVo.setIfPgmNm("KCP"       +"-취소-" + paymentWayNm); break;
            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-019"); ifLogVo.setIfPgmNm("INICIS"    +"-취소-" + paymentWayNm); break;
            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-027"); ifLogVo.setIfPgmNm("LGU"       +"-취소-" + paymentWayNm); break;
            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-051"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-취소-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-035"); ifLogVo.setIfPgmNm("PAYCO"     +"-취소-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-043"); ifLogVo.setIfPgmNm("PAYPAL"    +"-취소-" + paymentWayNm); break;
            default                             :  ifLogVo.setIfId("IF-O-003"); ifLogVo.setIfPgmNm("없음"      +"-취소-" + paymentWayNm); break;
            }
            break;
        case CoreConstants.PAYMENT_METHOD_DEPOSITNOTICE:
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-012"); ifLogVo.setIfPgmNm("KCP"       +"-입금통보-" + paymentWayNm); break;
            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-020"); ifLogVo.setIfPgmNm("INICIS"    +"-입금통보-" + paymentWayNm); break;
            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-028"); ifLogVo.setIfPgmNm("LGU"       +"-입금통보-" + paymentWayNm); break;
            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-052"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-입금통보-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-036"); ifLogVo.setIfPgmNm("PAYCO"     +"-입금통보-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-044"); ifLogVo.setIfPgmNm("PAYPAL"    +"-입금통보-" + paymentWayNm); break;
            default                             :  ifLogVo.setIfId("IF-O-004"); ifLogVo.setIfPgmNm("없음"      +"-입금통보-" + paymentWayNm); break;
            }
            break;
        case CoreConstants.PAYMENT_METHOD_RECEIPT:
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-013"); ifLogVo.setIfPgmNm("KCP"       +"-현금영수증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-021"); ifLogVo.setIfPgmNm("INICIS"    +"-현금영수증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-029"); ifLogVo.setIfPgmNm("LGU"       +"-현금영수증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-053"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-현금영수증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-037"); ifLogVo.setIfPgmNm("PAYCO"     +"-현금영수증-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-045"); ifLogVo.setIfPgmNm("PAYPAL"    +"-현금영수증-" + paymentWayNm); break;
            default                             :  ifLogVo.setIfId("IF-O-005"); ifLogVo.setIfPgmNm("없음"      +"-현금영수증-" + paymentWayNm); break;
            }
            break;            
        case CoreConstants.PAYMENT_METHOD_ESCROW_SEND:
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-014"); ifLogVo.setIfPgmNm("KCP"       +"-에스크로보내기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-022"); ifLogVo.setIfPgmNm("INICIS"    +"-에스크로보내기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-030"); ifLogVo.setIfPgmNm("LGU"       +"-에스크로보내기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-054"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-에스크로보내기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-038"); ifLogVo.setIfPgmNm("PAYCO"     +"-에스크로보내기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-046"); ifLogVo.setIfPgmNm("PAYPAL"    +"-에스크로보내기-" + paymentWayNm); break;
            default                             :  ifLogVo.setIfId("IF-O-006"); ifLogVo.setIfPgmNm("없음"      +"-에스크로보내기-" + paymentWayNm); break;
            }
            break;
        case CoreConstants.PAYMENT_METHOD_ESCROW_RECEIVE:
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-015"); ifLogVo.setIfPgmNm("KCP"       +"-에스크로받기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-023"); ifLogVo.setIfPgmNm("INICIS"    +"-에스크로받기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-031"); ifLogVo.setIfPgmNm("LGU"       +"-에스크로받기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-055"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-에스크로받기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-039"); ifLogVo.setIfPgmNm("PAYCO"     +"-에스크로받기-" + paymentWayNm); break;
            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-047"); ifLogVo.setIfPgmNm("PAYPAL"    +"-에스크로받기-" + paymentWayNm); break;
            default                             :  ifLogVo.setIfId("IF-O-007"); ifLogVo.setIfPgmNm("없음"      +"-에스크로받기-" + paymentWayNm); break;
            }
            break;
//        case CoreConstants.PAYMENT_METHOD_TX_SEARCH:
//            switch (paymentPgCd) {
//            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-009"); ifLogVo.setIfPgmNm("KCP"       +"-거래조회-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-017"); ifLogVo.setIfPgmNm("INICIS"    +"-거래조회-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-025"); ifLogVo.setIfPgmNm("LGU"       +"-거래조회-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-049"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-거래조회-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-033"); ifLogVo.setIfPgmNm("PAYCO"     +"-거래조회-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-041"); ifLogVo.setIfPgmNm("PAYPAL"    +"-거래조회-" + paymentWayNm); break;
//            default                             :  ifLogVo.setIfId("IF-O-001"); ifLogVo.setIfPgmNm("없음"      +"-거래조회-" + paymentWayNm); break;
//            }
//            break;
//        case CoreConstants.PAYMENT_METHOD_SETTLE:
//            switch (paymentPgCd) {
//            case CoreConstants.PG_CD_KCP        :  ifLogVo.setIfId("IF-O-009"); ifLogVo.setIfPgmNm("KCP"       +"-정산-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_INICIS     :  ifLogVo.setIfId("IF-O-017"); ifLogVo.setIfPgmNm("INICIS"    +"-정산-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_LGU        :  ifLogVo.setIfId("IF-O-025"); ifLogVo.setIfPgmNm("LGU"       +"-정산-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_ALLTHEGATE :  ifLogVo.setIfId("IF-O-049"); ifLogVo.setIfPgmNm("ALLTHEGATE"+"-정산-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_PAYCO      :  ifLogVo.setIfId("IF-O-033"); ifLogVo.setIfPgmNm("PAYCO"     +"-정산-" + paymentWayNm); break;
//            case CoreConstants.PG_CD_PAYPAL     :  ifLogVo.setIfId("IF-O-041"); ifLogVo.setIfPgmNm("PAYPAL"    +"-정산-" + paymentWayNm); break;
//            default                             :  ifLogVo.setIfId("IF-O-001"); ifLogVo.setIfPgmNm("없음"      +"-정산-" + paymentWayNm); break;
//            }
//            break;
        default:
            break;
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 15.
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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> approveMobile(PaymentModel<?> paymentModel,
            Map<String, Object> reqMap, ModelAndView mav) throws Exception {
        log.debug("================================");
        log.debug(" 승인요청/결과페이지 -  파라미터 =" + reqMap);
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug("######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            log.debug("log >>> 1");
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        log.debug("log >>> 2");
        log.debug("reqMap >>> " + reqMap);
        // 03.결제부모모델 셋팅
        ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        log.debug("log >>> 3");
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        log.debug("log >>> 4");
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        log.debug("log >>> 5");
        ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        log.debug("log >>> 6");
        childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        // 05.01. childModel.paymentApproveRollBackYn = N (기본값); // 승인요청 처리를 한다.
        // 05.02. childModel.paymentApproveRollBackYn = N; // 승인내역을 롤백취소처리한다.
        resultModel = paymentCommnService.approveMobile(childModel);
        log.debug("log >>> 7");
        // 06. 모델뷰 처리
        C rschildModel = (C) resultModel.getData();
        PaymentModel rsparentModel = BeansUtil.copyProperties(rschildModel, null, PaymentModel.class);
        mav.addObject(StringUtil.firstCharLowerCase(ResultModel.class.getSimpleName()), resultModel);
        mav.addObject(StringUtil.firstCharLowerCase(PaymentModel.class.getSimpleName()), rsparentModel);
        mav.addObject(StringUtil.firstCharLowerCase(childClass.getSimpleName()), rschildModel);
        log.debug("log >>> 8");
        String MethodName = "결제승인요청/결과";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());
        log.debug("log >>> 1");

        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_APPROVE, CoreConstants.TRANSFER_MODE_SEND, childModel, rschildModel);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 15.
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
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
    public <C extends PaymentModel> ResultModel<PaymentModel<?>> cancelMobile(PaymentModel<?> paymentModel)
            throws Exception {
        log.debug("================================");
        log.debug(" 결제취소 페이지 -  파라미터 =");
        log.debug("================================");
        ResultModel<PaymentModel<?>> resultModel = new ResultModel<>();
        String paymentPgCd = paymentModel.getPaymentPgCd();
        // 01. 계약된 PgCd 별로 사용객체 셋팅
        Class<C> childClass = getChildPO(paymentPgCd); // 자식PO
        PaymentCommnService paymentCommnService = getPaymentService(paymentPgCd); // 처리서비스
        log.debug(
                "######## 처리확인 ########" + "childClass=" + childClass + ",paymentCommnService=" + paymentCommnService);
        if (childClass == null) {
            // <entry key="core.payment.pgcd.illegal">처리하려는 PG코드가 잘못 되었습니다. - 입력코드{0}-대상코드{1}</entry>
            resultModel.setMessage(
                    MessageUtil.getMessage("core.payment.pgcd.illegal", new Object[] { paymentPgCd, "null" }));
            resultModel.setSuccess(false);
            return resultModel;
        }
        // 02.기본정보 셋팅
        // 03.결제부모모델 셋팅
        // ConverterUtil.mapToBean(reqMap, paymentModel, false);// Request Map을 Bean값을 추가 저장
        // 04. 결제자식모델
        C childModel = childClass.newInstance();
        BeansUtil.copyProperties(paymentModel, childModel, childClass); // Request Bean값을 추가 저장
        // ConverterUtil.mapToBean(reqMap, childModel, false);// Request Map을 Bean값을 추가 저장
        // childModel.setExtraMap(reqMap); // 각결제모듈 서밋 파라메터
        // 05. 서비스호출
        // 05.01. childModel.partCancelYn = "N" (기본값); // 전체취소처리
        // 05.02. childModel.partCancelYn = "Y"; // 부분취소처리
        resultModel = paymentCommnService.cancelMobile(childModel);
        C rschildModel = (C) resultModel.getData();
        String MethodName = "결제취소요청/결과";
        log.debug("Debug : {}", MethodName + " 파라미터 설정 [" + childClass.getSimpleName() + "]\n" + resultModel.getData());
        // 인터페이스 로그
        registIfLog(CoreConstants.PAYMENT_METHOD_CANCEL, CoreConstants.TRANSFER_MODE_SEND, childModel, rschildModel);
        return resultModel;
    }

}