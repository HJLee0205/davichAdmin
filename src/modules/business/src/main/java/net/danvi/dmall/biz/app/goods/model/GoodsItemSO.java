package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 단품 정보 Search Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsItemSO extends BaseSearchVO<GoodsItemSO> {
    // 단품 번호
    private String itemNo;
    // 상품 번호
    private String goodsNo;
    // 속성 버젼
    private long attrVer;
}
