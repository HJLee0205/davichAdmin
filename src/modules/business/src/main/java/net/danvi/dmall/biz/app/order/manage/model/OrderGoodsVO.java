package net.danvi.dmall.biz.app.order.manage.model;

import java.util.Date;
import java.util.List;
import java.util.Map;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.app.goods.model.GoodsAddOptionDtlVO;
import dmall.framework.common.model.BaseModel;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieGoodsVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 주문상품정보(조회결과)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderGoodsVO extends BaseModel<OrderGoodsVO> {
    private String ordNo;
    private String ordDtlSeq;
    // 상품 번호
    private String goodsNo;
    private String goodsNm;
    // 브랜드 번호
    private String brandNo;
    // 브랜드명
    private String brandNm;
    // 단품 번호
    private String itemNo;
    // 옵션변경전 이전 단품 번호
    private String oldItemNo;
    // 단품명
    private String itemNm;
    // 추가옵션 여부
    private String addOptYn;
    // 추가옵션 번호
    private long addOptNo;
    // 추가옵션 상세번호
    private long addOptDtlSeq;
    // 추가옵션 명
    private String addOptNm;
    private long ordQtt;
    // 공급 금액
    private long supplyAmt;
    // 소비자 금액
    private long customerAmt;
    // 판매가
    private long saleAmt;
    // 추가옵션 판매가
    private long optSaleAmt;
    // 할인 금액
    private long dcAmt;
    // 결제 금액
    private long payAmt;
    private String ordStatusCd;
    private String curOrdStatusCd;
    private String ordStatusNm;
    private String saleRate;
    private String adultCertifyYn;

    private String ordDtlStatusCd;
    private String ordDtlStatusNm;
    // 부가 비용 종류 코드
    private String addedAmountGbCd;
    // 부가 비용 종류 명
    private String addedAmountGbNm;
    // 부가비용 할인된 금액
    private long addedAmountAmt;
    // 배송비
    private String realDlvrAmt;
    // 지역 추가 배송비
    private String areaDlvrSetNo;// 지역 추가 배송비
    private String areaAddDlvrc;
    // 배송비 결제 코드
    private String dlvrcPaymentCd;
    // 배송비 결제 방법 명
    private String dlvrcPaymentNm;
    // 상품 적용 쿠폰 사용 금액
    private String cpUseAmt;
    // 주문서 적용 쿠폰 사용 금액
    private String cpBasketUseAmt;
    // 상품별 배송비
    private long goodseachDlvrc;
    // 배송 설정 코드
    private String dlvrSetCd;
    // 포장 최대 단위
    private Integer packMaxUnit;
    // 포당 단위 배송비
    private long packUnitDlvrc;
    // 배송 결제 방식 코드
    private String dlvrPaymentKindCd;
    // 원본 배송비
    private long dlvrPrice;
    // 최대 배송비 여부
    private String maxDlvrPriceYn;
    
    // 상품 마켓포인트 정책 사용 여부(Y:사이트설정,N:상품설정)
    private String goodsSvmnPolicyUseYn;
    // 상품 마켓포인트 정책 코드(01,02,03,04)
    private String goodsSvmnPolicyCd;
    // 상품 마켓포인트 적립 구분 코드 (1:율, 2:금액)
    private String goodsSvmnGbCd;
    // 상품 마켓포인트 금액
    private long goodsSvmnAmt;
    
    // 마켓포인트 지급 여부
    private String svmnPvdYn;
    
    // 추천인 적립율
    private String recomPvdRate;
    // 추천인 적립율 정책
    private String recomPvdPolicyCd;
    
    // 상품 마켓포인트 사용제한 정책 코드
    private String goodsSvmnMaxUsePolicyCd;
    // 상품 마켓포인트 사용제한 율
    private long goodsSvmnMaxUseRate;
    
    // 카테고리 마켓포인트 구분 코드
    private String ctgSvmnGbCd;
    // 카테고리 마켓포인트 금액 (1:율, 2:금액)
    private long ctgSvmnAmt;
    // 카테고리 마켓포인트 제한 (율)
    private long ctgSvmnMaxUseRate;
    
    // 판매자 마켓포인트 구분 코드
    private String sellerSvmnGbCd;
    // 판매자 마켓포인트 금액 (1:율, 2:금액)
    private long sellerSvmnAmt;
    // 판매자 마켓포인트 제한 (율)
    private long sellerSvmnMaxUseRate;

    // 기본 마켓포인트 제한 구분 코드
    private String svmnMaxUseGbCd;
    // 기본 마켓포인트 제한 (율/금액)
    private long svmnMaxUseAmt;
    
    // 기본 마켓포인트 지급 율
    private long svmnPvdRate;
    
    // 상품 최소 구매 제한 여부
    private String minOrdLimitYn;
    // 상품 최소 구매 수량
    private long minOrdQtt;
    // 상품 최대 구매 제한 여부
    private String maxOrdLimitYn;
    // 상품 최대 구매 수량
    private long maxOrdQtt;

    // 사은품 번호
    private String freebieNo;
    // 사은품 명
    private String freebieNm;
    private long freebieEventAmt; // 사은품지급 충족금액
    // 사은품 리스트
    private List<FreebieGoodsVO> freebieGoodsList;


    // 단품 버전
    private long itemVer;
    // 속성 버젼
    private long attrVer;
    // 추가 옵션 리스트
    private List<GoodsAddOptionDtlVO> goodsAddOptList;
    // 이미지 경로
    private String imgPath;
    // 단품명1
    private String goodsImg02;// 대표이미지 이미지
    private String itemNm1;
    // 단품명2
    private String itemNm2;
    // 단품명3
    private String itemNm3;
    // 단품명4
    private String itemNm4;
    // 상품 전시용 item_no row 수
    private String cnt;
    // 묶음 상품 배송비 item_no row 수
    private String dlvrcCnt;
    // 묶음 상품 배송비 item_no row 수(추가옵션 없는)
    private String noaddDlvrCnt;
    // 묵음 배송 seq
    private String dlvrSeq;
    // 주문일자
    private String ordAcceptDttm;
    // 결제금액
    private String paymentAmt;
    // 결제방법
    private String paymentWayNm;
    // 옵션 정보
    private List<Map<String, Object>> goodsOptionList;
    private String jsonList;

    private String ctgNoArr;
    private long ctgNo;
    private String ctgName;
    private int dcRate;

    private long prmtNo;    // 프로모션 번호
    private long prmtDcValue;    // 프로모션 할인율
    private String prmtDcGbCd;    // 프로모션 할인 구분 코드
    // 프로모션 유형 코드
    private String prmtTypeCd;
    private String prmtSDate;
    private String prmtEDate;
    private String prmtNm;
    private Date salePriceDttm;  // 상품 판매가 할인 가격 변경일

    // 배송비 계산용 사이트 설정정보
    private String defaultDlvrcTypeCd;
    private long defaultDlvrc;
    private long defaultDlvrMinAmt;
    private long defaultDlvrMinDlvrc;

    // 구매후기 작성 관련
    private int ordCnt; // 주문 카운트
    private int reviewCnt; // 구매 후기 카운트 (일반)
    private int reviewPmCnt; // 구매 후기 카운트 (프리미엄)

    private boolean dlvrChangeYn;

    private int memberCpNo;
    private String cpApplyEndDttm;

    private String bankNm; // 은행명
    private String actNo; // 계좌번호
    private String dpstScdDt; // 입금예정날짜

    // 배송 수량
    private int dlvrQtt;
    // 배송 메세지
    private String dlvrMsg;
    // 배송 처리 유형 코드
    private String dlvrPrcTypeCd;
    // 원본 배송 금액
    private long orgDlvrAmt;
    // 상품 이미지
    private String goodsDispImgC;
    // 배송업체코드
    private String rlsCourierCd;
    // 송장번호
    private String rlsInvoiceNo;

    // 회원번호 (배치에서 sms, email 호출시 사용하기 위해 추가)
    private long memberNo;

    /* 모바일 추가 20161007 */
    // 배송업체명
    private String rlsCourierNm;

    private String refundAmt;
    private String paymentTurn;
    private String turnCnt;

    // 상품별 조건부 배송비
    private long goodseachcndtaddDlvrc;
    // 무료배송 최소 금액
    private long freeDlvrMinAmt;
    //판매자번호
    private String sellerNo;
    //판매자명
    private String sellerNm;
    //판매자 반품주소지
    private String retadrssPostNo;
    private String retadrssAddr;
    private String retadrssDtlAddr;
    
    //상품유형코드
    private String goodsTypeCd;
    //클레임 수량
    private int claimQtt;
    //개별 클레임수량
    private String pclaimQtt;
    //예약전용상품
    private String rsvOnlyYn;

    private String claimNo;
    private String claimCd;
    private String claimNm;
    private String returnCd;
    private String returnNm;

    private String mdConfirmYn;
    private String taxGbCd;
    private String claimReasonCd;
    private String claimReasonNm;

    private String remainQtt;
    
    private int dlvrExpectDays;

    //상품별 마켓포인트 적립
    private long goodsPvdSvmnAmt;
    
    //상품별 마켓포인트 사용
    private long prcAmt;
    
    //다비전코드
    private String erpItmCode;

    private int firstBuySpcPrice; // 첫구매가격
    private String firstCouponAvailableYn; //첫구매쿠폰발행가능여부
    private String firstCouponIssueYn;//첫구매쿠폰발행여부
    private String firstSpcOrdYn; // 첫구매특가프로모션참여여부
    private String smsSendYn;

    //쿠폰적용가격
    private String couponApplyAmt;
    //쿠폰할인가격
    private String couponDcAmt;
    //쿠폰할인율
    private String couponDcRate;
    //쿠폰적용값
    private String couponDcValue;
    //쿠폰적용구분 코드 (01:율/02:원)
    private String couponBnfCd;
    private String couponBnfTxt;

    private String couponAvlNo;
    private String couponBnfValue;
    private String couponUseLimitAmt;
    private String couponBnfDcAmt;
    private String couponKindCd;
    private String couponApplyStartDttm;
    private String couponApplyEndDttm;
    private String couponMemberCpNo;
    private String couponSoloUseYn;
    private String couponAvlInfo;

    private long pointAmt;
    private String stampYn;
    /** 반품 상품 코드  */
    private String[] claimGoodsNo;
    // 결제 당시 원본 배송비
    private long dlvrOrgAmt;
    // 결제 당시 배송비
    private long dlvrAmt;
    //2023-06-04 210 깔끔한 환불,취소 처리를위해추가된 컬럼
    //이전 사용자들은 이게 없기 때문에 기존 취소 처리 방식을따라야함...주의..
    //결제시 상품별 분재 적립금
    private long pvdSvmn;
    //결제시 상품별 분배 사용 포인트
    private long goodsDmoneyUseAmt;
    private long dlvrAddAmt;       //추가 배송비 실주문상품테이블에 들어갈거
    private String dlvrMethodCd;//배송 방법
}
