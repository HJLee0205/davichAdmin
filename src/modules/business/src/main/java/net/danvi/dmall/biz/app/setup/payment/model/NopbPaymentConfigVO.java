package net.danvi.dmall.biz.app.setup.payment.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

import java.io.Serializable;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 2.
 * 작성자     : dong
 * 설명       : 무통장 계좌 설정 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class NopbPaymentConfigVO extends BaseModel<NopbPaymentConfigVO> implements Serializable {
    private static final long serialVersionUID = 8200555288681510676L;

    // 행번호
    private String rowNum;
    // 무통장 결제 사용 여부
    private String nopbpaymentUseYn;
    // 무통장 결제 순번
    private String nopbPaymentSeq;
    // 은행 명
    private String bankNm;
    // 은행 코드
    private String bankCd;
    // 계좌번호
    private String actno;
    // 예금주
    private String holder;
    // 대표 계좌 여부
    private String dlgtActYn;
}
