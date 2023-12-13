package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 11. 08.
 * 작성자     : slims
 * 설명       : 추천 상품 정보 Search Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsRecommendSO extends BaseSearchVO<GoodsRecommendSO> {
    // 상품 번호
    private String goodsNo;
    // 추천 타입
    private String recType;
    // 시작 일자
    private String recStartDttm;
    // 종료 일자
    private String recEndDttm;
    // 판매자 번호
    private String searchSellerNo;
    // 상품 번호
    private String searchCode;
    // 상품명
    private String searchWord;
    // 상품군
    private String[] goodsTypeCds;
}
