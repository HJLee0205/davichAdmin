package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 카테고리 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsRecommendVO implements Serializable {

    private static final long serialVersionUID = -2490289458678223445L;

    // 상품 번호
    private String goodsNo;
    // 상품 유셩 코드
    private String goodsTypeCd;
    // 상품 명
    private String goodsNm;
    // 다비젼 상품 코드
    private String erpItmCode;
    // 판매자 번호
    private String sellerNo;
    // 판매자 명
    private String sellerNm;
    // 판매 상태
    private String goodsSaleStatusNm;
    // 카테고리 명
    private String ctgName;
    // 브랜드 명
    private String brandNm;
    // 공급가
    private String supplyPrice;
    // 판매가
    private String salePrice;
    // 재고
    private String stockQtt;
    // 대표 이미지
    private String latelyImg;
    // 섭네일 이미지
    private String snsImg;
    // 사용 가능 제고 수량
    private String availStockQtt;
    // 추천 시작 시간
    private String recStartDttm;
    // 추천 종료 시간
    private String recEndDttm;
    // 추천 타입
    private String recType;
    // 사용 여부
    private String useYn;
    // 등록 일자
    private String regDate;
    // 수정 일자
    private String updDate;
    // 등록자 번호
    private Long regrNo;
    // 사용자 번호
    private Long updrNo;
    // row 번호
    private int rowNum;
    // 정렬순서
    private String sortSeq;
}
