package net.danvi.dmall.biz.app.goods.model;

import java.io.Serializable;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 28.
 * 작성자     : dong
 * 설명       : 상품 복사 단품 정보 Value Object
 * </pre>
 */
@Data
public class GoodsCopyItemVO implements Serializable {

    private static final long serialVersionUID = 2021275742742016269L;
    // 사이트 번호
    private Long siteNo;
    // 상품 번호
    private String goodsNo;
    // 상품 명
    private String itemNm;
    // 사용 여부
    private String useYn;
    // 단품 버젼
    private Long itemVer;
    // 공급 가격
    private Long supplyPrice;
    // 별도 공급가 적용 여부
    private String sepSupplyPriceYn;
    // 소비자 가격
    private Long customerPrice;
    // 판매 가격
    private Long salePrice;
    // 재고 수량
    private Long stockQtt;
    // 판매 수량
    private Long saleQtt;
    // 단품 번호
    private String itemNo;
    // 속성 버젼
    private Long attrVer;
    // 옵션 번호 1
    private Long optNo1;
    // 속성 번호 1
    private Long attrNo1;
    // 옵션 번호 2
    private Long optNo2;
    // 속성 번호 2
    private Long attrNo2;
    // 옵션 번호 3
    private Long optNo3;
    // 속성 번호 3
    private Long attrNo3;
    // 옵션 번호 4
    private Long optNo4;
    // 속성 번호 4
    private Long attrNo4;
    // 가격 변경 코드
    private String priceChgCd;
    // 재고 수량 변경 코드
    private String stockChgCd;
    // 증감 가격
    private Long saleChdPrice;
    // 증감 수량
    private Long stockChdQtt;
    // 등록자 번호
    private Long regrNo;
    // 수정자 번호
    private Long updrNo;
}
