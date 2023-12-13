package net.danvi.dmall.biz.app.setup.order.model;

import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderConfigPO extends BaseModel<OrderConfigPO> {
    // 상품 자동 삭제 사용 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String goodsAutoDelUseYn;
    // 상품 보관 일수
    private String goodsKeepDcnt;
    // 품절 상품 자동 삭제 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String soldoutGoodsAutoDelYn;
    // 상품 보관 객수 제한 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String goodsKeepQttLimitYn;
    // 상품 보관 개수
    private String goodsKeepQtt;
    // 장바구니 페이지 이동 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String basketPageMovYn;
    // 재고 설정 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String stockSetYn;
    // 가용 재고 판매 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String availStockSaleYn;
    // 가용 재고 수
    private String availStockQtt;

}
