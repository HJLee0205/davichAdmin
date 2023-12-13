package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2017. 7. 21.
 * 작성자     : dong
 * 설명       : FreebieImageInfoVO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieImageInfoVO extends BaseSearchVO<FreebieImageInfoVO> {
    // 사은품 번호
    private String freebieNo;
    // 상품 번호
    private String goodsNo;
    // 처리 성공여부
    private Boolean success;
    // 사이트 설정 상품상세 이미지 넓이
    private int goodsDefaultImgWidth;
    // 사이트 설정 상품상세 이미지 높이
    private int goodsDefaultImgHeight;
    // 사이트 설정 상품리스트 이미지 넓이
    private int goodsListImgWidth;
    // 사이트 설정 상품리스트 이미지 높이
    private int goodsListImgHeight;
}
