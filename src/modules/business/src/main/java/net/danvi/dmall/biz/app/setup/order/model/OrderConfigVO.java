package net.danvi.dmall.biz.app.setup.order.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 택배사 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderConfigVO extends BaseModel<OrderConfigVO> {
    // 상품 자동 삭제 사용 여부
    private String goodsAutoDelUseYn;
    // 상품 보관 일자
    private String goodsKeepDcnt;
    // 품절 상품 자동 삭제 여부
    private String soldoutGoodsAutoDelYn;
    // 상품 보관 객수 제한 여부
    private String goodsKeepQttLimitYn;
    // 상품 보관 개수
    private String goodsKeepQtt;
    // 장바구니 페이지 이동 여부
    private String basketPageMovYn;
    // 재고 설정 여부
    private String stockSetYn;
    // 가용 재고 판매 여부
    private String availStockSaleYn;
    // 가용 재고 수
    private String availStockQtt;
}
