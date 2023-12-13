package net.danvi.dmall.biz.app.goods.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

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
public class GoodsRelateGoodsPO extends BaseModel<GoodsRelateGoodsPO> {
    // 상품 번호
    @NotNull
    private String goodsNo;
    // 관련상품 순번
    private String relateGoodsSeq;
    // 관련 상품 번호
    @NotNull
    private String relateGoodsNo;
    // 서로등록 설정 여부
    private String eachRegSetYn;
    // 우선순위
    private String priorRank;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
}
