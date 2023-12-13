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
public class GoodsFreebieGoodsVO {
    // 상품 번호
    private String goodsNo;
    // 관련 상품 번호
    private String freebieNo;
    // 관련 상품 이미지
    private String imgPath;
    // 관련 상품 이미지
    private String imgNm;
    // 상품 명
    private String freebieNm;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
}
