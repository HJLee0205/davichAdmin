package net.danvi.dmall.biz.app.setup.taxbill.model;

import org.hibernate.validator.constraints.Length;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 31.
 * 작성자     : dong
 * 설명       : 세금계산서 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class TaxBillConfigPO extends BaseModel<TaxBillConfigPO> {
    // 세금 계산서 유형 코드
    private String taxbillTypeCd;
    // 세금 계산서 무통장 사용 여부
    private String taxbillNopbUseYn;
    // 세금 계산서 계좌 이체 사용 여부
    private String taxbillActtransUseYn;
    // 세금 계산서 가상 계좌 사용 여부
    private String taxbillVirtactUseYn;
    // 배송비 포함 여부
    private String dlvrcInclusionYn;
    // 마켓포인트 포함 여부
    private String svmnInclusionYn;
    // 금액 설정 여부
    private String ordAmtYn;
    // 이용 안내 문구
    @Length(min = 0, max = 1000)
    private String useGuideWords;
    // 인감 이미지 경로
    private String sealImgPath;
}
