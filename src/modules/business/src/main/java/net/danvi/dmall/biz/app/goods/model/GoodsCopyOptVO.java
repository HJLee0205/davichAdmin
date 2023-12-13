package net.danvi.dmall.biz.app.goods.model;

import java.io.Serializable;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 28.
 * 작성자     : dong
 * 설명       : 상품 복사 옵션 정보 Value Object
 * </pre>
 */
@Data
public class GoodsCopyOptVO implements Serializable {

    private static final long serialVersionUID = -3998700889088406951L;
    // 상품 번호
    private String goodsNo;
    // 옵션 번호
    private Long optNo;
    // 대상 옵션 번호
    private Long targetOptNo;
    // 사이트 번호
    private Long siteNo;
    // 옵션 명
    private String optNm;
    // 옵션 순번
    private Long optSeq;
    // 등록 순번
    private Long regSeq;
    // 대상 속성 번호
    private Long targetAttrNo;
    // 속성 번호
    private Long attrNo;
    // 속성 명
    private String attrNm;
    // 사용 여부
    private String useYn;
    // 등록자 번호
    private Long regrNo;
    // 사용자 번호
    private Long updrNo;
}
