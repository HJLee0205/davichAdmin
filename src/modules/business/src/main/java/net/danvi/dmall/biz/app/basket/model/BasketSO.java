package net.danvi.dmall.biz.app.basket.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BasketSO extends BaseSearchVO<BasketSO> {
    private String basketNo; // 장바구니번호
    private Long memberNo; // 회원번호
    private Long goodsNo; // 상품번호
    private String itemNo; // 단품번호
    private long attrVer; // 속성 번호

    private String[] itemNoArr;
}
