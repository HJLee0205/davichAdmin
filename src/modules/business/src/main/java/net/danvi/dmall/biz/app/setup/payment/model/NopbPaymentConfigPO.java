package net.danvi.dmall.biz.app.setup.payment.model;

import org.hibernate.validator.constraints.Length;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

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
public class NopbPaymentConfigPO extends BaseModel<NopbPaymentConfigPO> {
    // 무통장 결제 사용 여부
    private String nopbpaymentUseYn;
    // 무통장 결제 순번
    private String nopbPaymentSeq;
    // 은행 명
    @Length(min = 0, max = 16)
    private String bankNm;
    // 은행 코드
    @Length(min = 0, max = 2)
    private String bankCd;
    // 계좌번호
    @Length(min = 0, max = 50)
    private String actno;
    // 예금주
    @Length(min = 0, max = 16)
    private String holder;
    // 대표 계좌 여부
    private String dlgtActYn;
    // 초기 무통장 대표 순번
    private String initNopbDlgtSeq;
}
