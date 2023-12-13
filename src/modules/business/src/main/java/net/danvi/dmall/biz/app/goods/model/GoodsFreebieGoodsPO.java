package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.NotNull;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 관련 상품 정보 등록 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsFreebieGoodsPO extends BaseModel<GoodsFreebieGoodsPO> {
    // 상품 번호
    @NotNull
    private String goodsNo;
    // 관련 상품 번호
    @NotNull
    private String freebieNo;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
}
