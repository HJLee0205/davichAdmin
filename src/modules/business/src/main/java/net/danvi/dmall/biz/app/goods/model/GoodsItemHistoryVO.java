package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 단품 이력 정보 취득용 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsItemHistoryVO extends BaseModel<GoodsItemHistoryVO> {
    // 상품 번호
    private String goodsNo;
    // 상품 명
    private String goodsNm;
    // 단품 번호
    private String itemNo;
    // 단품 명
    private String itemNm;
    // 누적 인하가격
    private Long totalMinus;
    // 누적 인상가격
    private Long totalPlus;
    // 변경 일자
    private String chgDt;
    // 가격 변경 사유
    private String chgPriceCd;
    // 변경 가격
    private Long chgPrice;
    // 현재 가격
    private Long salePrice;
    // 수량 변경 사유
    private String chgQttCd;
    // 변경 수량
    private Long chgQtt;
    // 현재 수량
    private Long stockQtt;
    // 순번
    private Long seq;
}
