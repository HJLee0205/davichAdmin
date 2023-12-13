package net.danvi.dmall.biz.app.basket.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieGoodsVO;

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
public class BasketVO extends BaseModel<BasketVO> {
    private Integer basketNo; // 장바구니번호
    private int basketItemVer;// 단품번호
    private int basketAttrVer; // 속성버전
    private String itemVerChk;
    private String attrVerChk;
    private int buyQtt; // 구매수량
    private String dlvrcPaymentCd;// 배송비 결제 코드
    private String goodsNo;// 상품번호
    private String goodsNm;// 상품명


    private String dlvrSetCd; // 배송 설정 코드
    private String goodseachDlvrc;
    private String packMaxUnit;
    private String packUnitDlvrc;
    private String dlvrPaymentKindCd;
    private String goodsSvmnPolicyUseYn;
    private String goodsSvmnAmt;
    private String itemNo;// 단품번호
    private String itemNm;// 단품명
    private String goodsSaleStatusCd;
    private long customerPrice; // 소비자 가격
    private long salePrice;// 판매금액
    private long totalPrice;
    private int stockQtt; // 재고수량
    private int attrVer; // 속성버전
    private int optNo1;
    private int attrNo1;
    private int optNo2;
    private int attrNo2;
    private int optNo3;
    private int attrNo3;
    private int optNo4;
    private int attrNo4;
    private String defaultDlvrcTypeCd;
    private String defaultDlvrc;
    private String defaultDlvrMinAmt;
    private String defaultDlvrMinDlvrc;
    private String optNo1Nm;
    private String attrNo1Nm;
    private String optNo2Nm;
    private String attrNo2Nm;
    private String optNo3Nm;
    private String attrNo3Nm;
    private String optNo4Nm;
    private String attrNo4Nm;
    private String imgPath;// 이미지경로
    private int itemVer;// 단품번호
    private String dispYn; // 전시여부
    private String saleYn;// 판매여부
    private long dcAmt;// 할인금액
    private String attr1; // 속성1
    private String attr2; // 속성2
    private String attr3; // 속성3
    private String attr4; // 속성4
    private String sessionId; // 세션 아이디
    List<BasketOptVO> basketOptList; // 장바구니추가옵션
    private String useYn;
    private long dlvrPrice;// 원본 배송비
    private String maxDlvrPriceYn;// 최대 배송비 여부
    private int dcRate;
    private String tgDelYn;
    private String tiDelYn;
    private String stockSetYn;
    private String availStockSaleYn;
    private int availStockQtt;
    private String minOrdLimitYn; // 최소구매수량 제한여부
    private String minOrdQtt; // 최소구매수량
    private String maxOrdLimitYn; // 최대구매수량 제한여부
    private String maxOrdQtt; // 최대 구매수량
    private String itemArr; // 관리자 수기주문 용 아이템 목록
    private long ctgNo; // 카테고리번호
    private String multiOptYn;
    private String goodsImg01;
    private String goodsImg02;
    private String goodsImg03;
    private String goodsImg04;
    private String goodsImg05;
    private String goodsImg06;

    private String goodsDispImgA;
    private String goodsDispImgB;
    private String goodsDispImgC;
    private String goodsDispImgD;
    private String goodsDispImgE;
    
    private String favYn;  //관심상품 등록여부
    private String rsvOnlyYn;  //예약전용상품여부
    
    private String prmtDcGbCd;  //기획전 할인구분 (율,액)
    
    private String sellerNm;
    private String sellerNo;

    private List<BasketVO> basketList;
    private List<FreebieGoodsVO> freebieGoodsList;

    private String brandNo;// 브랜드번호
    private String prmtTypeCd;	//프로모션 유형
    private int firstBuySpcPrice; // 첫구매가격
    private String firstSpcOrdYn; // 첫구매특가프로모션참여여부
}
