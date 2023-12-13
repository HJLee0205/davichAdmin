package net.danvi.dmall.biz.app.order.manage.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 12.
 * 작성자     : dong
 * 설명       : 클레임정보(조회결과)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ClaimInfoVO extends BaseModel<ClaimInfoVO> {

    // 클레임 번호
    long claimNo;
    // 접수 일시
    String acceptDttm;
    // 완료 일시
    String cmpltDttm;
    // 취소 일시
    String cancelDttm;
    // 접수자 번호
    String aceeptNo;
    // 취소자 번호
    String cancelNo;
    // 완료자 번호
    String cmpltNo;

    /** 클레임 결제 현금 환불 정보 **/

    // 결제 번호
    long cashRefundNo;
    // 결제 번호
    long paymentNo;
    // 결제 번호
    String refundTypeCd;
    // 결제 번호
    String refundStatusCd;
    // 결제 번호
    String bankCd;
    // 결제 번호
    String holderNm;
    // 결제 번호
    String cmsAmt;
    // 결제 번호
    String scdDt;
    // 결제 번호
    String smsSendYn;
    // 결제 번호
    String prcRespCd;
    // 결제 번호
    String prcRespContent;
    // 결제 번호
    String stnbyNo;
    // 결제 번호
    String stnbyDttm;
    // 결제 번호
    String errDttm;
    // 결제 번호
    String refundMemo;

}
