package net.danvi.dmall.biz.app.order.payment.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 11.
 * 작성자     : dong
 * 설명       : 결제정보(등록)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderPayPO extends BaseModel<OrderPayPO> {

    // 결제 번호
    private long paymentNo;
    // 원본 결제 번호
    private long orgPaymentNo;
    // 주문 클레임 구분 코드
    private String ordClaimGbCd;
    // 주문 번호
    private long ordNo;
    // 클레임 번호
    private long claimNo;
    // 결제 PG 코드
    private String paymentPgCd;
    // 결제 수단 코드
    private String paymentWayCd;
    // 결제 방법 코드
    private String paymentMethodCd;
    // 결제 상태 코드
    private String paymentStatusCd;
    // 결제 완료 일시
    private String paymentCmpltDttm;
    // 결제 금액
    private long paymentAmt;
    // 회원 번호
    private long memberNo;
    // 거래 번호
    private String txNo;
    // 승인 번호
    private String confirmNo;
    // 승인 일시
    private String confirmDttm;
    // 승인 결과 코드
    private String confirmResultCd;
    // 승인 결과 메세지
    private String confirmResultMsg;
    // 카드사 코드
    private String cardCd;
    // 은행 코드
    private String bankCd;
    // 계좌 번호
    private String actNo;
    // 예금주 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String holderNm;
    // 입금자 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dpsterNm;
    // 입금 예정 일자
    private String dpstScdDt;
    // 입금 예정 금액
    private long dpstScdAmt;
    // 입금 확인 메세지
    private String dpstCheckMsg;
    // 부분취소여부(Y:부분취소, N:전체취소)
    private String partCancelYn;
}
