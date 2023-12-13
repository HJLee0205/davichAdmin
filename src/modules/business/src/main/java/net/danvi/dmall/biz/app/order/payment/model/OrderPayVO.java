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
 * 설명       : 결제정보(조회결과)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderPayVO extends BaseModel<OrderPayVO> {
    /** 주문 번호 */
    private long ordNo;
    /** 결제번호 */
    private String paymentNo;
    /** 결제수단 코드 */
    private String paymentWayCd;
    /** 결제수단 명 */
    private String paymentWayNm;
    /** 결제 PG 코드 */
    private String paymentPgCd;
    /** 결제 상태 코드 */
    private String paymentStatusCd;
    /** PG 결제번호 */
    private String txNo;
    /** 결제금액 */
    private String paymentAmt;
    /** 결제카드 명 */
    private String cardNm;
    /** 결제은행 명 */
    private String bankNm;
    /** 결제카드 코드 */
    private String cardCd;
    /** 결제은행 코드 */
    private String bankCd;
    /** 결제통신사코드 */
    private String telecomCd;    
    /** 계좌 번호 */
    private String actNo;
    /** 예금주명 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String holderNm;
    /** 승인번호 */
    private String confirmNo;
    /** 승인일시 */
    private String confirmDttm;
    /** 할부개월 */
    private String instmntMonth;
    /** 입금자명 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dpsterNm;
    /** 입금예정일자 */
    private String dpstScdDt;

    private String pgType;
    private String paymentTurn;
    private String escrowYn;
    private String escrowConfirmno;
    
    private String ordStatusCd;
    private String paymentCmpltDttm;

    private String errCd;
    private String resultContent;
    private String appLinkGbCd; // 간편 결제 정보

}
