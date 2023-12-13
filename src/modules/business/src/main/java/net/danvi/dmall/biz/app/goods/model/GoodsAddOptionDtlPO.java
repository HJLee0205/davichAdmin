package net.danvi.dmall.biz.app.goods.model;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 12.
 * 작성자     : kwt
 * 설명       : 추가 옵션 상세 항목 설정 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsAddOptionDtlPO extends BaseModel<GoodsAddOptionDtlPO> {
    // 상품번호
    private String goodsNo;
    // 추가 옵션 번호
    private long addOptNo;
    // 추가 옵션 상세 순번
    private long addOptDtlSeq;
    // 추가 옵션 금액 증감 코드 (1:가액(+), 2:감액(-))
    private String addOptAmtChgCd;
    // 추가 옵션 값
    @NotEmpty
    private String addOptValue;
    // 추가 옵션 금액
    @NotNull
    private Long addOptAmt;
    // 추가 옵션 버젼
    private String optVer;
    // 추가옵션 등록, 수정 구분 (I:신규등록, U:수정항목)
    private String registFlag;
}
