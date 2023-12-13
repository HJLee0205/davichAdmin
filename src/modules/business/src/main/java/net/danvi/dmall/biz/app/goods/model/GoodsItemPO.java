package net.danvi.dmall.biz.app.goods.model;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Null;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 단품 정보 등록용 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsItemPO extends BaseModel<GoodsItemPO> {
    // 단품 번호
    private String itemNo;
    // 상품 번호
    // @NotNull
    private String goodsNo;
    // 단품 명
    private String itemNm;
    // 단품 버젼
    private Long itemVer;
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

    // 연관 아이템 가격업데이트
    @Null
    private Boolean relationPriceUpdate;

    // 판매 가격
    @NotNull
    private Long salePrice;
    // 가격 증감 코드
    private String priceChgCd;
    // 증감 가격
    private Long saleChdPrice;
    // 재고 수량
    @NotNull
    private Long stockQtt;
    // 증감 수량
    private Long stockChdQtt;
    // 재고 증감 코드
    private String stockChgCd;
    // 판매 수량
    private Long saleQtt;

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

    // 기분 판매가 여부
    private String standardPriceYn;
    // 등록 FLAG
    private String registFlag;
    // 옵션 값 1
    private String optValue1;
    // 옵션 값 2
    private String optValue2;
    // 옵션 값 3
    private String optValue3;
    // 옵션 값 4
    private String optValue4;

    // 다비젼 상품코드
    private String erpItmCode;

    // 사방넷 옵션명
    private String sbnOptNm;

    // 판매가 적용 시작일
    private String dcStartDttm;

    // 판매가 적용 종료일
    private String dcEndDttm;

    // 판매가 무재한 적용 여부
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
    private String orgFileNm;
    // 파일명
    private String fileNm;
    // 파일 사이즈
    private Long fileSize;
    // 임시 파일 명
    private String tempFileNm;

    // 판매가 변경 여부
    private Boolean isDcPriceChanged;

    // 엑셀용 변수
    private String applyDavisionYn;
    private String tagId;

    public Boolean getRelationPriceUpdate() {
        if (this.relationPriceUpdate == null) return false;
        return relationPriceUpdate;
    }
}
