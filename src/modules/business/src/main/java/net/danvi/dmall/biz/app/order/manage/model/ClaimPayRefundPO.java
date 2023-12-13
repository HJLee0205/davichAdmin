package net.danvi.dmall.biz.app.order.manage.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 12.
 * 작성자     : dong
 * 설명       : 클레임 결제 현금 환불 정보(등록,수정)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ClaimPayRefundPO extends BaseModel<ClaimPayRefundPO> {

    /** 클레임 결제 현금 환불 정보 **/

    private String cashRefundNo; // 현금환불번호
    private String paymentNo;// 결제번호
    private String claimNo;// 클레임번호

    private String refundTypeCd;// 환불유형코드
    private String refundStatusCd;// 환불상태코드
    private String refundAmt;// 환불금액
    private String refundMemo;// 환불메모

    private String bankCd;// 은행코드
    private String actNo;// 계좌번호
    private String holderNm;// 예금주

    private String scdAmt;// 예정금액
    private String scdDt;// 예정일자

    private String cmsAmt;// 환불수수료금액
    private String smsSendYn;// sms발송여뷰
    private String prcRespCd;// 처리응답코드
    private String prcRespContent;// 처리응답내용
    private String acceptNo;// 접수자번호
    private String acceptDttm;// 접수일시
    private String stnbyNo;// 대기자번호
    private String stnbyDttm;// 대기일시
    private String cmpltNo;// 완료자번호
    private String cmpltDttm;// 완료일시
    private String errDttm;// 에러일시

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
}
