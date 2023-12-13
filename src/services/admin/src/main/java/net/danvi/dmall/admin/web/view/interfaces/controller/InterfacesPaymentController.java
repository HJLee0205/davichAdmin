package net.danvi.dmall.admin.web.view.interfaces.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderPO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigSO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.service.PaymentManageService;
import net.danvi.dmall.biz.system.remote.payment.PaymentAdapterService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.core.constants.CoreConstants;
import net.danvi.dmall.core.model.payment.PaymentModel;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 9.
 * 작성자     : KNG
 * 설명       : 인터페이스 결제모듈 수신용 컨트롤러
 *              입금통보, 에스크로 처리 수신용
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/interfaces/payment")
public class InterfacesPaymentController {

    @Resource(name = "paymentAdapterService")
    private PaymentAdapterService paymentAdapterService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "paymentManageService")
    private PaymentManageService paymentManageService;

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : KNG
     * 설명   : 무통장 할당,입금 통보 결과수신처리
     *          접근URL형태: /admin/interfaces/{paymentPgCd}/deposit-notice
     *                      형태로 중간의 {paymentPgCd} 은 본 솔루션의 PG코드로 대체해 PG계약관리에 등록해 놓는다.
     *          실제접근URL: /admin/interfaces/03/deposit-notice
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. KNG - 최초생성
     * </pre>
     *
     * @param paymentPgCd
     * @param reqMap
     * @param reqPaymentModel
     * @param bindingResult
     * @return
     */
    @RequestMapping("/{paymentPgCd}/deposit-notice")
    public ModelAndView DepositNotice(@PathVariable String paymentPgCd, PaymentModel reqPaymentModel,
            BindingResult bindingResult, @RequestParam Map<String, Object> reqMap) {
        log.info("================================");
        log.info("Start : " + "무통장 할당,입금 통보 결과수신처리");
        log.info("================================");
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date today = new Date();
        log.error("==================today=================="+df.format(today));
        log.error("==================paymentPgCd=================="+paymentPgCd);

        log.error("=====================reqMap===================="+reqMap);
        ModelAndView mav = new ModelAndView();
        reqPaymentModel.setPaymentPgCd(paymentPgCd);
        reqPaymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<PaymentModel<?>> rsm = null;
        PaymentModel pmResult = null;

        CommPaymentConfigVO paymentConfigVO = this.getPGInfo(paymentPgCd);
        reqPaymentModel.setPgId(paymentConfigVO.getPgId());
        reqPaymentModel.setPgKey(paymentConfigVO.getPgKey());
        reqPaymentModel.setKeyPasswd(paymentConfigVO.getKeyPasswd());
        log.error("===============reqPaymentModel================="+reqPaymentModel);
        try {
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP:
                // 성공적인 처리시 KCP_VirAcctResult 에 "0000" 히든값을 표시해야 함
                mav.setViewName("/admin/interfaces/payment/" + CoreConstants.PG_CD_KCP + "/KCP_VirAcctResult");
                // PaymentLguServiceImpl.depositNotice를 호출해 처리한다.
                rsm = paymentAdapterService.depositNotice(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
//                 pmResult.setDepositFlag("I"); // 입금
                break;
            case CoreConstants.PG_CD_INICIS:
                // 성공적인 처리시 KCP_VirAcctResult 에 "0000" 히든값을 표시해야 함
                mav.setViewName("/admin/interfaces/payment/" + CoreConstants.PG_CD_INICIS + "/INICIS_VirAcctResult");
                // PaymentLguServiceImpl.depositNotice를 호출해 처리한다.
                rsm = paymentAdapterService.depositNotice(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                mav.addObject("confirmResultMsgFail", rsm.getMessage());
                 //pmResult.setDepositFlag("I"); // 입금
                break;
            case CoreConstants.PG_CD_LGU:
                // 성공적인 처리시 cas_noteurl 에 "OK" 값을 표시해야 함
                mav.setViewName("/" + CoreConstants.PG_CD_LGU + "/cas_noteurl");
                // LGU는 PaymentLguServiceImpl.depositNotice를 호출해 처리한다.
                rsm = paymentAdapterService.depositNotice(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                mav.addObject("confirmResultMsgFail", rsm.getMessage());
                 //pmResult.setDepositFlag("I"); // 입금
                break;
            case CoreConstants.PG_CD_ALLTHEGATE:
                // 성공적인 처리시 AGS_VirAcctResult 에 정상처리 경우 거래코드|상점아이디|주문일시|가상계좌번호|처리결과| 값을 표시해야 함
                mav.setViewName("/" + CoreConstants.PG_CD_ALLTHEGATE + "/AGS_VirAcctResult");
                // AlltheGate는 PaymentAlltheGateServiceImpl.depositNotice를 호출해 처리한다.
                rsm = paymentAdapterService.depositNotice(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                mav.addObject("confirmResultMsgFail", rsm.getMessage());
                // pmResult.setDepositFlag("I"); // 입금
                break;
            case CoreConstants.PG_CD_PAYCO:
                break;
            case CoreConstants.PG_CD_NPAY:
                break;
            case CoreConstants.PG_CD_PAYPAL:
                break;
            }
            log.error("===============rsm================="+rsm);
            log.error("===============pmResult================="+pmResult);
            // 무통장입금 수신에 따른 DB 처리
            if (rsm != null && rsm.isSuccess() && pmResult != null) {
                OrderGoodsVO vo = new OrderGoodsVO();
                // 무통장 입금
                if ("I".equals(StringUtil.trim(pmResult.getDepositFlag()))) {
                    // 주문-주문상세 정보 셋팅
                    vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_ORDER);
                    vo.setOrdNo(pmResult.getOrdNo().toString());
                    vo.setOrdStatusCd("20");// 결제완료로 상태 변경
                    // TO_PAYMENT - 결제상태코드(20.완료-고정값), 결제완료일시, 입금예정금액, 입금자명 update 처리
                    pmResult.setUpdrNo(CommonConstants.MEMBER_INTERFACE_ORDER);
                    ResultModel<OrderPayVO> opResult = orderService.updatePaymentStatusByDepositNotice(vo, pmResult);
                    mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                }
                // 무통장 취소
                else if ("C".equals(StringUtil.trim(pmResult.getDepositFlag()))) {
                    OrderPO po = new OrderPO();
                    po.setOrdNo(pmResult.getOrdNo()); // 주문번호
                    orderService.orderCancelAllIf(po); // 취소처리
                    mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                }
                // 처리할 수 없는 서비스
                else {
                    // 무통장 할당 등을 포함한 처리 할 수 없는 서비스
                    mav.addObject("confirmResultCd", "9000"); // 처리 할 수 없는 서비스입니다.
                    mav.addObject("confirmResultMsgFail", MessageUtil.getMessage(ExceptionConstants.NOT_SUPPORT_SERVICE));
                }

            } else {
                mav.addObject("confirmResultCd", pmResult.getConfirmResultCd()); // 결과코드 실패시 9999.헤쉬값 오류, 나머지는 실제오류
                if(rsm != null) {
                    log.info("### 무통장 입금 수신 에러 발생 ## ==> " + rsm.getMessage());
                    mav.addObject("confirmResultMsgFail", rsm.getMessage());
                }
            }
        } catch (Exception e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        }
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : KNG
     * 설명   : 에스크로 처리결과수신
     *          (LGU+ 수신정보 예) (C=수령확인결과, R=구매취소요청, D=구매취소결과, N=NC처리결과))
     *          접근URL형태: /admin/interfaces/{paymentPgCd}/escrow-receive
     *                      형태로 중간의 {paymentPgCd} 은 본 솔루션의 PG코드로 대체해 PG계약관리에 등록해 놓는다.
     *          실제접근URL: /admin/interfaces/03/escrow-receive
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. KNG - 최초생성
     * </pre>
     *
     * @param paymentPgCd
     * @param reqMap
     * @param reqPaymentModel
     * @param bindingResult
     * @return
     */
    @RequestMapping("/{paymentPgCd}/escrow-receive")
    public ModelAndView EscrowReceive(@PathVariable String paymentPgCd, PaymentModel reqPaymentModel,
            BindingResult bindingResult, @RequestParam Map<String, Object> reqMap) {
        log.info("================================");
        log.info("Start : " + "에스크로 배송처리결과수신");
        log.info("================================");

        String mode = "";
        ModelAndView mav = new ModelAndView();
        reqPaymentModel.setPaymentPgCd(paymentPgCd);
        reqPaymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<PaymentModel<?>> rsm = null;
        PaymentModel pmResult = null;

        CommPaymentConfigVO paymentConfigVO = this.getPGInfo(paymentPgCd);
        reqPaymentModel.setPgId(paymentConfigVO.getPgId());
        reqPaymentModel.setPgKey(paymentConfigVO.getPgKey());
        reqPaymentModel.setKeyPasswd(paymentConfigVO.getKeyPasswd());
        try {
            switch (paymentPgCd) {
            case CoreConstants.PG_CD_KCP:
                break;
            case CoreConstants.PG_CD_INICIS:
                // 성공적인 처리시 escrowReceive 에 "OK" 값을 표시해야 함
                mav.setViewName("/" + CoreConstants.PG_CD_INICIS + "/escrowReceive");
                // LGU는 PaymentLguServiceImpl.escrowReceive를 호출해 처리한다.
                rsm = paymentAdapterService.escrowReceive(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                mav.addObject("confirmResultMsgFail", rsm.getMessage());
                break;
            case CoreConstants.PG_CD_LGU:
                // 성공적인 처리시 escrowReceive 에 "OK" 값을 표시해야 함
                mav.setViewName("/" + CoreConstants.PG_CD_LGU + "/escrowReceive");
                // LGU는 PaymentLguServiceImpl.escrowReceive를 호출해 처리한다.
                rsm = paymentAdapterService.escrowReceive(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                mav.addObject("confirmResultMsgFail", rsm.getMessage());
                break;
            case CoreConstants.PG_CD_ALLTHEGATE:
                // 올더게이트는 에스크로 수신은 없음
                break;
            case CoreConstants.PG_CD_PAYCO:
                break;
            case CoreConstants.PG_CD_NPAY:
                break;
            case CoreConstants.PG_CD_PAYPAL:
                break;
            }

            // 구매확정, 거절에 따른 DB 처리
            if (rsm != null && rsm.isSuccess() && pmResult != null) {
                OrderGoodsVO vo = new OrderGoodsVO();
                // 에스크로 처리모드(div:배송등록,receive:수령확인, confirm:구매확정,dcnf:거절확인, cancel:거래취소)
                // 에스크로 수신처리모드에서는 구매확정 처리만 하고 거절확인과 나머지는 처리 할 수 없음
                // 구매확정 처리
                if ("confirm".equals(StringUtil.trim(pmResult.getEscrowTxCd()))) {
                    vo.setOrdNo(pmResult.getOrdNo().toString()); // 주문번호
                    vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_ORDER);// 등록자번호
                    // 구매확정 처리는 MALL에서만 하기로 확정됨(2016.09.28)
                    // vo.setOrdStatusCd("90"); //구매확정
                    // OrderGoodsVO curVo = orderService.selectCurOrdStatus(vo);
                    // orderService.updateOrdStatus(vo, curVo.getOrdStatusCd()); // 구매확정 업데이트
                    mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                } else if ("dlv".equals(StringUtil.trim(pmResult.getEscrowTxCd()))) { // 배송등록
                    mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                } else if ("cancel".equals(StringUtil.trim(pmResult.getEscrowTxCd()))) { // 배송 후 구매 취소
                    vo.setOrdNo(pmResult.getOrdNo().toString()); // 주문번호
                    vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_ORDER);// 등록자번호
                    vo.setOrdStatusCd("70"); // 환불신청
                    OrderGoodsVO curVo = orderService.selectCurOrdStatus(vo);
                    orderService.updateOrdStatus(vo, curVo.getOrdStatusCd()); // 환불신청 업데이트
                    mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                } else {
                    // 거절확인 및 나머지는 처리할 수 없음
                    // jsp에는 처리 할 수 없음 결과코드
                    mav.addObject("confirmResultCd", "9000"); // 처리 할 수 없는 서비스입니다.
                    mav.addObject("confirmResultMsgFail", MessageUtil.getMessage(ExceptionConstants.NOT_SUPPORT_SERVICE));
                }
            } else {
                mav.addObject("confirmResultCd", pmResult.getConfirmResultCd()); // 결과코드 실패시 9999.헤쉬값 오류, 나머지는 실제오류
                if(rsm != null) {
                    log.info("### 에스크로 수신 에러 발생 ## ==> " + rsm.getMessage());  
                    mav.addObject("confirmResultMsgFail", rsm.getMessage());
                }
            }
        } catch (Exception e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        }
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 6.
     * 작성자 : KNG
     * 설명   : KCP 전용 수신처리 ( 입금통보, 에스크로 수신)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 6. KNG - 최초생성
     * </pre>
     *
     * @param reqPaymentModel
     * @param bindingResult
     * @param reqMap
     * @return
     */
    @RequestMapping("/{paymentPgCd}/kcp-common-return")
    public ModelAndView KcpCommonReturn(@PathVariable String paymentPgCd,PaymentModel reqPaymentModel, BindingResult bindingResult,
            @RequestParam Map<String, Object> reqMap) {
        log.info("================================");
        log.info("Start : " + "KCP 공통 통보 결과수신처리");
        log.info("================================");

        String mode = "";
        ModelAndView mav = new ModelAndView();
        reqPaymentModel.setPaymentPgCd("01");
        reqPaymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<PaymentModel<?>> rsm = null;
        PaymentModel pmResult = null;
        String tx_cd = (String) reqMap.get("tx_cd");
        try {
            switch (tx_cd) {
            case "TX00": // 가상계좌 입금 통보 데이터 받기
                // 성공적인 처리시 KCP_VirAcctResult 에 "0000" 히든값을 표시해야 함
                mav.setViewName("/admin/interfaces/payment/" + CoreConstants.PG_CD_KCP + "/KCP_CommonResult");
                // PaymentLguServiceImpl.depositNotice를 호출해 처리한다.
                rsm = paymentAdapterService.depositNotice(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                pmResult.setDepositFlag("I"); // 입금
                break;
            case "TX01": // 가상계좌 환불 통보 데이터 받기
                mav.setViewName("/admin/interfaces/payment/" + CoreConstants.PG_CD_KCP + "/KCP_CommonResult");
                // PaymentLguServiceImpl.depositNotice를 호출해 처리한다.
                rsm = paymentAdapterService.depositNotice(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                pmResult.setDepositFlag("C"); // 취소
                break;
            case "TX02": // 에스크로 구매확인/구매취소 통보 데이터 받기
                mav.setViewName("/admin/interfaces/payment/" + CoreConstants.PG_CD_KCP + "/KCP_CommonResult");
                // PaymentLguServiceImpl.depositNotice를 호출해 처리한다.
                rsm = paymentAdapterService.escrowReceive(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                if ("Y".equals((String) reqMap.get("st_cd"))) { // 구매확정
                    pmResult.setEscrowTxCd("confirm");
                } else if ("N".equals((String) reqMap.get("st_cd"))) { // 구매취소
                    pmResult.setEscrowTxCd("cancel");
                }
                break;
            case "TX03": // 에스크로 배송시작 통보 데이터 받기
                mav.setViewName("/admin/interfaces/payment/" + CoreConstants.PG_CD_KCP + "/KCP_CommonResult");
                // PaymentLguServiceImpl.depositNotice를 호출해 처리한다.
                rsm = paymentAdapterService.escrowReceive(reqPaymentModel, reqMap, mav);
                pmResult = (PaymentModel) mav.getModelMap().get("paymentModel");
                pmResult.setEscrowTxCd("dlv");
                break;
            }
            // 수신결과 따른 DB 처리
            if (rsm != null && rsm.isSuccess() && pmResult != null) {
                OrderGoodsVO vo = new OrderGoodsVO();
                if ("TX00".equals(tx_cd) || "TX01".equals(tx_cd)) { // 입금/환불 통보 처리
                    // 무통장 입금
                    if ("I".equals(StringUtil.trim(pmResult.getDepositFlag()))) {
                        // 주문-주문상세 정보 셋팅
                        vo.setOrdNo(pmResult.getOrdNo().toString());
                        vo.setOrdStatusCd("20");// 결제완료로 상태 변경
                        // TO_PAYMENT - 결제상태코드(20.완료-고정값), 결제완료일시, 입금예정금액, 입금자명 update 처리
                        pmResult.setUpdrNo(CommonConstants.MEMBER_INTERFACE_ORDER);
                        ResultModel<OrderPayVO> opResult = orderService.updatePaymentStatusByDepositNotice(vo,
                                pmResult);
                        mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                    }
                    // 무통장 취소
                    else if ("C".equals(StringUtil.trim(pmResult.getDepositFlag()))) {
                        vo.setOrdNo(pmResult.getOrdNo().toString());
                        vo.setOrdStatusCd("21");// 결제취소
                        orderService.updateOrdStatus(vo, "20");// 결제완료 => 결제취소
                        mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                    }
                    // 처리할 수 없는 서비스
                    else {
                        // 무통장 할당 등을 포함한 처리 할 수 없는 서비스
                        mav.addObject("confirmResultCd", "9000"); // 처리 할 수 없는 서비스입니다.
                        mav.addObject("confirmResultMsgFail",
                                MessageUtil.getMessage(ExceptionConstants.NOT_SUPPORT_SERVICE));
                    }
                } else if ("TX02".equals(tx_cd) || "TX03".equals(tx_cd)) { // 에스크로 통보 처리
                    // 에스크로 처리모드(div:배송등록,receive:수령확인, confirm:구매확정,dcnf:거절확인, cancel:거래취소)
                    // 에스크로 수신처리모드에서는 구매확정 처리만 하고 거절확인과 나머지는 처리 할 수 없음
                    if ("confirm".equals(StringUtil.trim(pmResult.getEscrowTxCd()))) { // 구매확정
                        vo.setOrdNo(pmResult.getOrdNo().toString()); // 주문번호
                        vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_ORDER);// 등록자번호
                        // 구매확정 처리는 MALL에서만 하기로 확정됨(2016.09.28)
                        // vo.setOrdStatusCd("90"); //구매확정
                        // OrderGoodsVO curVo = orderService.selectCurOrdStatus(vo);
                        // orderService.updateOrdStatus(vo, curVo.getOrdStatusCd()); // 구매확정 업데이트
                        mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                    } else if ("dlv".equals(StringUtil.trim(pmResult.getEscrowTxCd()))) { // 배송등록
                        mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                    } else if ("cancel".equals(StringUtil.trim(pmResult.getEscrowTxCd()))) { // 배송 후 구매 취소
                        vo.setOrdNo(pmResult.getOrdNo().toString()); // 주문번호
                        vo.setRegrNo(CommonConstants.MEMBER_INTERFACE_ORDER);// 등록자번호
                        vo.setOrdStatusCd("70"); // 환불신청
                        OrderGoodsVO curVo = orderService.selectCurOrdStatus(vo);
                        orderService.updateOrdStatus(vo, curVo.getOrdStatusCd()); // 환불신청 업데이트
                        mav.addObject("confirmResultCd", "0000"); // 결과코드 성공 0000
                    } else {
                        // 거절확인 및 나머지는 처리할 수 없음
                        // jsp에는 처리 할 수 없음 결과코드
                        mav.addObject("confirmResultCd", "9000"); // 처리 할 수 없는 서비스입니다.
                        mav.addObject("confirmResultMsgFail",
                                MessageUtil.getMessage(ExceptionConstants.NOT_SUPPORT_SERVICE));
                    }
                }

            } else {
                mav.addObject("confirmResultCd", pmResult.getConfirmResultCd()); // 결과코드 실패시 9999.헤쉬값 오류, 나머지는 실제오류
                if(rsm != null) {
                    log.info("### KCP 통보데이터 수신 에러 발생 ## ==> " + rsm.getMessage());
                    mav.addObject("confirmResultMsgFail", rsm.getMessage());
                }
            }
        } catch (Exception e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        }
        return mav;
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
    private CommPaymentConfigVO getPGInfo(String pgCd) {
        CommPaymentConfigSO so = new CommPaymentConfigSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setPgCd(pgCd);

        CommPaymentConfigVO vo = paymentManageService.selectCommPaymentConfig(so).getData();
        return vo;
    }
}
