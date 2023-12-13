package net.danvi.dmall.biz.app.order.manage.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.EditorBaseVO;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 12.
 * 작성자     : dong
 * 설명       : 클레임 결제 현금 환불 정보(조회결과)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ClaimPayRefundVO extends EditorBaseVO<ClaimPayRefundVO> {

    /** 클레임 결제 현금 환불 정보 **/

    // 결제 번호
    private long cashRefundNo;
    // 결제 번호
    private long paymentNo;
    // 결제 번호
    private String refundTypeCd;
    // 결제 번호
    private String refundStatusCd;
    // 결제 번호
    private String bankCd;
    // 결제 번호
    private String holderNm;
    // 결제 번호
    private String cmsAmt;
    // 결제 번호
    private String scdDt;
    // 결제 번호
    private String smsSendYn;
    // 결제 번호
    private String prcRespCd;
    // 결제 번호
    private String prcRespContent;
    // 결제 번호
    private String aceeptNo;
    // 결제 번호
    private String acceptDttm;
    // 결제 번호
    private String stnbyNo;
    // 결제 번호
    private String stnbyDttm;
    // 결제 번호
    private String cmpltNo;
    // 결제 번호
    private String cmpltDttm;
    // 결제 번호
    private String errDttm;
    // 결제 번호
    private String refundMemo;

    private String ordNo;
    private String claimMemo;
    private String claimDtlReason;
    private String payUnpgCd;
    private String payUnpgWayCd;
    private long payUnpgAmt;
    private String payPgCd;
    private String payPgWayCd;
    private long payPgAmt;
    private String payReserveCd;
    private String payReserveWayCd;
    private long payReserveAmt;
    private long restAmt;
    private long totalDlvrAmt;

    private String ordStatusCd;
    private String actNo;
    // 판매 금액
    private long saleAmt;
    // 할인 금액
    private long dcAmt;
    private int claimQtt;
    private long eAmt;
    private long orgPayPgAmt;
    private long orgPayUnpgAmt;
    private long claimNo;
    // 결제된 배송비
    private long dlvrAmt;
    // 주문자 이름
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;
    // 주문자 폰번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrMobile;
    //결제시 상품별 분재 적립금
    private long pvdSvmn;
    //결제시 상품별 분배 사용 포인트
    private long goodsDmoneyUseAmt;
    //추가 배송비 실주문상품테이블에 들어갈거
    private long dlvrAddAmt;
    // 실제 결재된 배송비
    private long realDlvrAmt;
    // 예약번호
    private String rsvNo;
}
