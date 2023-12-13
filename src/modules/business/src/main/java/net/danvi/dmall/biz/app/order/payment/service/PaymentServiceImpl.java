package net.danvi.dmall.biz.app.order.payment.service;

import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigSO;
import net.danvi.dmall.biz.system.remote.payment.PaymentAdapterService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigSO;
import net.danvi.dmall.biz.app.setup.payment.model.SimplePaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.service.PaymentManageService;
import net.danvi.dmall.core.constants.CoreConstants;
import net.danvi.dmall.core.model.payment.PaymentModel;
import dmall.framework.common.BaseService;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.BeansUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 11.
 * 작성자     : dong
 * 설명       : 결제서비스
 * </pre>
 */
@Slf4j
@Service("paymentService")
@Transactional(rollbackFor = Exception.class)
public class PaymentServiceImpl extends BaseService implements PaymentService {
    @Resource(name = "paymentAdapterService")
    private PaymentAdapterService paymentAdapterService;

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

    @Resource(name = "paymentManageService")
    private PaymentManageService paymentManageService;

    /**
     * 외부결제모듈처리
     */
    @Override
    public ResultModel<PaymentModel<?>> pgPayment(OrderPayPO po, Map<String, Object> reqMap, ModelAndView mav)
            throws Exception {
        ResultModel<PaymentModel<?>> result = new ResultModel<>();

        log.debug("=== po : {}", po);
        PaymentModel reqPaymentModel = BeansUtil.copyProperties(po, null, PaymentModel.class); // Request Bean값을 추가저장
        // PaymentCommnService psc = paymentAdapterService.getPaymentService(po.getPaymentPgCd());

        // 외부결제 실행
        try {
            // PG정보 조회
            if ("01".equals(po.getPaymentPgCd()) || "02".equals(po.getPaymentPgCd()) || "03".equals(po.getPaymentPgCd())
                    || "04".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getPGInfo(po.getPaymentPgCd());
                reqPaymentModel.setPgId(vo.getPgId());
                reqPaymentModel.setPgKey(vo.getPgKey());
                reqPaymentModel.setPgKey2(vo.getPgKey2());
                reqPaymentModel.setPgKey3(vo.getPgKey3());
                reqPaymentModel.setPgKey4(vo.getPgKey4());
                reqPaymentModel.setKeyPasswd(vo.getKeyPasswd());
            } else if ("41".equals(po.getPaymentPgCd())) {
                SimplePaymentConfigVO vo = this.getPaycoPGInfo();
                reqPaymentModel.setFrcCd(vo.getFrcCd());
            } else if ("81".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getPaypalPGInfo();
                reqPaymentModel.setFrgPaymentStoreId(vo.getFrgPaymentStoreId());
                reqPaymentModel.setFrgPaymentPw(vo.getFrgPaymentPw());
            } else if ("82".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getAliPayPGInfo();
                reqPaymentModel.setAlipayPaymentStoreId(vo.getAlipayPaymentStoreId());
                reqPaymentModel.setAlipayPaymentPw(vo.getAlipayPaymentPw());
            } else if ("83".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getTenPayPGInfo();
                reqPaymentModel.setTenpayPaymentStoreId(vo.getTenpayPaymentStoreId());
                reqPaymentModel.setTenpayPaymentPw(vo.getTenpayPaymentPw());
            } else if ("84".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getWechPayPGInfo();
                reqPaymentModel.setWechpayPaymentStoreId(vo.getWechpayPaymentStoreId());
                reqPaymentModel.setWechpayPaymentPw(vo.getWechpayPaymentPw());
            }

            reqPaymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            result = paymentAdapterService.approve(reqPaymentModel, reqMap, mav);
            // paymentModel = result.getData();//psc.approve(paymentModel).getData();
            // 01. 성공/실패시 로직 처리
            if (result.isSuccess()) {
                result.setData(result.getData());
            } else {
                result.setSuccess(false);
                log.debug("### 처리에러 발생 ## ==> " + result.getMessage());
            }

        } catch (Exception e) {
            result.setSuccess(false);
        }
        return result;
    }

    /**
     * 외부결제모듈처리 취소
     */
    public ResultModel<PaymentModel<?>> pgPaymentCancel(PaymentModel<?> paymentModel) throws Exception {
        ResultModel<PaymentModel<?>> result = new ResultModel<>();

        // 외부결제 실행
        try {

            // PG정보 조회
            if ("01".equals(paymentModel.getPaymentPgCd()) || "02".equals(paymentModel.getPaymentPgCd())
                || "03".equals(paymentModel.getPaymentPgCd()) || "04".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getPGInfo(paymentModel.getPaymentPgCd());
                paymentModel.setPgId(vo.getPgId());
                paymentModel.setPgKey(vo.getPgKey());
                paymentModel.setPgKey2(vo.getPgKey2());
                paymentModel.setPgKey3(vo.getPgKey3());
                paymentModel.setPgKey4(vo.getPgKey4());
                paymentModel.setKeyPasswd(vo.getKeyPasswd());
            } else if ("41".equals(paymentModel.getPaymentPgCd())) {
                SimplePaymentConfigVO vo = this.getPaycoPGInfo();
                paymentModel.setFrcCd(vo.getFrcCd());
            } else if ("81".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getPaypalPGInfo();
                paymentModel.setFrgPaymentStoreId(vo.getFrgPaymentStoreId());
                paymentModel.setFrgPaymentPw(vo.getFrgPaymentPw());
            } else if ("82".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getAliPayPGInfo();
                paymentModel.setAlipayPaymentStoreId(vo.getAlipayPaymentStoreId());
                paymentModel.setAlipayPaymentPw(vo.getAlipayPaymentPw());
            } else if ("83".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getTenPayPGInfo();
                paymentModel.setTenpayPaymentStoreId(vo.getTenpayPaymentStoreId());
                paymentModel.setTenpayPaymentPw(vo.getTenpayPaymentPw());
            } else if ("84".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getWechPayPGInfo();
                paymentModel.setWechpayPaymentStoreId(vo.getWechpayPaymentStoreId());
                paymentModel.setWechpayPaymentPw(vo.getWechpayPaymentPw());
            }
            paymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

            log.debug("==== 외부 결제 CANCEL START ===");
            result = paymentAdapterService.cancel(paymentModel);
            result.setSuccess(true);

        } catch (Exception e) {
            result.setSuccess(false);
        }
        return result;
    }

    /**
     * 외부결제모듈처리 (모바일)
     */
    @Override
    public ResultModel<PaymentModel<?>> pgPaymentMobile(OrderPayPO po, Map<String, Object> reqMap, ModelAndView mav)
            throws Exception {
        ResultModel<PaymentModel<?>> result = new ResultModel<>();

        log.debug("=== po : {}", po);
        PaymentModel reqPaymentModel = BeansUtil.copyProperties(po, null, PaymentModel.class); // Request Bean값을 추가저장
        // PaymentCommnService psc = paymentAdapterService.getPaymentService(po.getPaymentPgCd());

        // 외부결제 실행
        try {

            // PG정보 조회
            if ("01".equals(po.getPaymentPgCd()) || "02".equals(po.getPaymentPgCd()) || "03".equals(po.getPaymentPgCd())
                    || "04".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getPGInfo(po.getPaymentPgCd());
                reqPaymentModel.setPgId(vo.getPgId());
                reqPaymentModel.setPgKey(vo.getPgKey());
                reqPaymentModel.setPgKey2(vo.getPgKey2());
                reqPaymentModel.setPgKey3(vo.getPgKey3());
                reqPaymentModel.setPgKey4(vo.getPgKey4());
                reqPaymentModel.setKeyPasswd(vo.getKeyPasswd());
            } else if ("41".equals(po.getPaymentPgCd())) {
                SimplePaymentConfigVO vo = this.getPaycoPGInfo();
                reqPaymentModel.setFrcCd(vo.getFrcCd());
            } else if ("81".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getPaypalPGInfo();
                reqPaymentModel.setFrgPaymentStoreId(vo.getFrgPaymentStoreId());
                reqPaymentModel.setFrgPaymentPw(vo.getFrgPaymentPw());
            } else if ("82".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getAliPayPGInfo();
                reqPaymentModel.setAlipayPaymentStoreId(vo.getAlipayPaymentStoreId());
                reqPaymentModel.setAlipayPaymentPw(vo.getAlipayPaymentPw());
            } else if ("83".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getTenPayPGInfo();
                reqPaymentModel.setTenpayPaymentStoreId(vo.getTenpayPaymentStoreId());
                reqPaymentModel.setTenpayPaymentPw(vo.getTenpayPaymentPw());
            } else if ("84".equals(po.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getWechPayPGInfo();
                reqPaymentModel.setWechpayPaymentStoreId(vo.getWechpayPaymentStoreId());
                reqPaymentModel.setWechpayPaymentPw(vo.getWechpayPaymentPw());
            }

            // log.debug("psc : {}", psc);
            // paymentModel.setPaymentAmt(Long.toString(po.getPaymentAmt()));
            reqPaymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            result = paymentAdapterService.approveMobile(reqPaymentModel, reqMap, mav);
            // paymentModel = result.getData();//psc.approve(paymentModel).getData();
            // 01. 성공/실패시 로직 처리
            if (result.isSuccess()) {
                result.setData(result.getData());
            } else {
                result.setSuccess(false);
                log.debug("### 처리에러 발생 ## ==> " + result.getMessage());
            }

        } catch (Exception e) {
            result.setSuccess(false);
        }
        return result;
    }

    /**
     * 외부결제모듈처리 취소(모바일)
     */
    public ResultModel<PaymentModel<?>> pgPaymentCancelMobile(PaymentModel<?> paymentModel) throws Exception {
        ResultModel<PaymentModel<?>> result = new ResultModel<>();

        // 외부결제 실행
        try {

            // PG정보 조회
            if ("01".equals(paymentModel.getPaymentPgCd()) || "02".equals(paymentModel.getPaymentPgCd())
                    || "03".equals(paymentModel.getPaymentPgCd()) || "04".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getPGInfo(paymentModel.getPaymentPgCd());
                paymentModel.setPgId(vo.getPgId());
                paymentModel.setPgKey(vo.getPgKey());
                paymentModel.setPgKey2(vo.getPgKey2());
                paymentModel.setPgKey3(vo.getPgKey3());
                paymentModel.setPgKey4(vo.getPgKey4());
                paymentModel.setKeyPasswd(vo.getKeyPasswd());
            } else if ("41".equals(paymentModel.getPaymentPgCd())) {
                SimplePaymentConfigVO vo = this.getPaycoPGInfo();
                paymentModel.setFrcCd(vo.getFrcCd());
            } else if ("81".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getPaypalPGInfo();
                paymentModel.setFrgPaymentStoreId(vo.getFrgPaymentStoreId());
                paymentModel.setFrgPaymentPw(vo.getFrgPaymentPw());
            } else if ("82".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getAliPayPGInfo();
                paymentModel.setAlipayPaymentStoreId(vo.getAlipayPaymentStoreId());
                paymentModel.setAlipayPaymentPw(vo.getAlipayPaymentPw());
            } else if ("83".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getTenPayPGInfo();
                paymentModel.setTenpayPaymentStoreId(vo.getTenpayPaymentStoreId());
                paymentModel.setTenpayPaymentPw(vo.getTenpayPaymentPw());
            } else if ("84".equals(paymentModel.getPaymentPgCd())) {
                CommPaymentConfigVO vo = this.getWechPayPGInfo();
                paymentModel.setWechpayPaymentStoreId(vo.getWechpayPaymentStoreId());
                paymentModel.setWechpayPaymentPw(vo.getWechpayPaymentPw());
            }

            log.debug("==== 외부 결제 CANCEL START ===");
            result = paymentAdapterService.cancelMobile(paymentModel);
            result.setSuccess(true);

        } catch (Exception e) {
            result.setSuccess(false);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : KMS
     * 설명   : 통합결제 PG 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. KMS - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public CommPaymentConfigVO getPGInfo(String pgCd) throws Exception {
        CommPaymentConfigSO so = new CommPaymentConfigSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setPgCd(pgCd);
        so.setShopCd(pgCd);

        CommPaymentConfigVO vo = paymentManageService.selectCommPaymentConfig(so).getData();
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : KMS
     * 설명   : 간편결제 PG 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. KMS - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public SimplePaymentConfigVO getPaycoPGInfo() throws Exception {
        SimplePaymentConfigSO so = new SimplePaymentConfigSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setSimpPgCd(CoreConstants.PG_CD_PAYCO);
        SimplePaymentConfigVO vo = paymentManageService.selectSimplePaymentConfig(so).getData();
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : KMS
     * 설명   : PAYPAL PG 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. KMS - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public CommPaymentConfigVO getPaypalPGInfo() throws Exception {
        CommPaymentConfigVO vo = paymentManageService.selectForeignPaymentConfig(SessionDetailHelper.getDetails().getSiteNo()).getData();
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : KMS
     * 설명   : Alipay PG 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. KMS - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public CommPaymentConfigVO getAliPayPGInfo() throws Exception {
        CommPaymentConfigVO vo = paymentManageService.selectAlipayPaymentConfig(SessionDetailHelper.getDetails().getSiteNo()).getData();
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : KMS
     * 설명   : 텐페이 PG 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. KMS - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public CommPaymentConfigVO getTenPayPGInfo() throws Exception {
        CommPaymentConfigVO vo = paymentManageService.selectTenpayPaymentConfig(SessionDetailHelper.getDetails().getSiteNo()).getData();
        return vo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 11.
     * 작성자 : KMS
     * 설명   : 위챗 PG 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 11. KMS - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public CommPaymentConfigVO getWechPayPGInfo() throws Exception {
        CommPaymentConfigVO vo = paymentManageService.selectWechpayPaymentConfig(SessionDetailHelper.getDetails().getSiteNo()).getData();
        return vo;
    }
}
