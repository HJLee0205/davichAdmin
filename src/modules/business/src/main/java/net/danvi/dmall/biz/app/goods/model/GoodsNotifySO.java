package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 상품 고시 정보 Search Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsNotifySO extends BaseSearchVO<GoodsNotifySO> {
    // 상품 번호
    private String goodsNo;
    // 고시 번호
    private String notifyNo;
}
