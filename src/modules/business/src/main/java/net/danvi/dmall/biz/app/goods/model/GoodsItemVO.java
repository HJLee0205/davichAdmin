package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 단품 정보 취득용 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsItemVO {
    // 단품 번호
    private String itemNo;
    // 상품 번호
    private String goodsNo;
    // 단품 명
    private String itemNm;
    // 사용 여부
    private String useYn;
    // 공급 가격
    private Long supplyPrice;
    // 별도 공급가 적용 여부
    private String sepSupplyPriceYn;
    // 재고 다비전 연동 여부
    private String applyDavisionStockYn;
    // 원가
    private Long cost;
    // 소비자 가격
    private Long customerPrice;
    // 판매 가격
    private Long salePrice;
    // 재고 수량
    private Long stockQtt;
    // 판매 수량
    private Long saleQtt;
    // 단품 버전
    private Long itemVer;

    // 속성 버젼
    private Long attrVer;
    // 속성1 번호
    private Long attrNo1;
    // 속성2 번호
    private Long attrNo2;
    // 속성3 번호
    private Long attrNo3;
    // 속성4 번호
    private Long attrNo4;

    // 속성1 값
    private String attrValue1;
    // 속성2 값
    private String attrValue2;
    // 속성3 값
    private String attrValue3;
    // 속성4 값
    private String attrValue4;

    // 옵션1 번호
    private Long optNo1;
    // 옵션2 번호
    private Long optNo2;
    // 옵션3 번호
    private Long optNo3;
    // 옵션4 번호
    private Long optNo4;

    // 옵션1 값
    private String optValue1;
    // 옵션2 값
    private String optValue2;
    // 옵션3 값
    private String optValue3;
    // 옵션4 값
    private String optValue4;

    // 기분 판매가 여부
    private String standardPriceYn;
    // 등록 FLAG
    private String registFlag;
    // 다비젼 상품코드
    private String erpItmCode;

    // 판매 시작 일자
    private String dcStartDttm;
    // 판매 종료 일자
    private String dcEndDttm;
    // 판매 종료 일자
    private String dcPriceApplyAlwaysYn;

    // 다중옵션 판매 시작 일자
    private String multiDcStartDttm;
    // 다중옵션 판매 종료 일자
    private String multiDcEndDttm;
    // 다중옵션 판매 종료 일자
    private String multiDcPriceApplyAlwaysYn;

    // 파일 경로
    private String filePath;
    // 원본 파일명
    private String orgFilePath;
    // 파일명
    private String fileNm;
    // 파일 사이즈
    private Long fileSize;
    // 임시 파일 명
    private String tempFileNm;
    // 단품 이미지 URL
    private String goodsItemImg;

    // 단품 이미지 URL
    private String goodsDesc;
}
