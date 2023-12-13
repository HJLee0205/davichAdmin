package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 관련 상품 정보 취득 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsRelateGoodsVO {
    // 상품 번호
    private String goodsNo;
    // 관련 상품 번호
    private String relateGoodsNo;
    // 관련 상품 이미지
    private String relateGoodsImg;
    // 서로등록 설정 여부
    private String eachRegSetYn;
    // 상품 명
    private String goodsNm;
    // 판매 가격
    private long salePrice;
    // 우선순위
    private String priorRank;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
}
