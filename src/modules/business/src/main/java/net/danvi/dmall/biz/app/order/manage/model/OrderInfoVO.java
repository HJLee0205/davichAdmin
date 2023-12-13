package net.danvi.dmall.biz.app.order.manage.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 주문정보(조회결과)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderInfoVO extends BaseModel<OrderInfoVO> {

    /** 업체 번호 */
    private Long companyNo;
    /** 사아트 번호 */
    private Long siteNo;

    /** 전체 번호 */
    private String rownum;
    private String sortNum;
    /** 주문상태별 번호 */
    private String subRownum;
    /** 주문 번호 */
    private String ordNo;
    /** 재주문 건의 원 주문 번호 */
    private String orgOrdNo;

    /** 사망넷 주문 번호 */
    private String sbnOrdNo;

    /** 주문일시 */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date ordAcceptDttm;
    /** 판매 환경 코드 */
    private String ordMediaCd;
    /** 판매 환경 명 */
    private String ordMediaNm;
    /** 주문상태 코드 */
    private String ordStatusCd;
    /** 주문상태 명 */
    private String ordStatusNm;
    /** 판매자번호 */
    private String sellerNo;
    /** 판매자명 */
    private String sellerNm;
    /** 상품번호 */
    private String goodsNo;
    /** 상품명 */
    private String goodsNm;
    /** 브랜드명 */
    private String brandNm;
    /** 주문상품 개수 */
    private int ordGoodsCnt;

    /** 옵션번호 */
    private String itemNo;
    /** 옵션명 */
    private String itemNm;

    /** 회원 주문 여부 */
    private String memberOrdYn;
    /** 주문자 ID */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    /** 주문자 번호 */
    private String memberNo;
    /** 주문자 명 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;
    /** 주문자 등급 */
    private String memberGradeNm;
    /** 주문자 이메일 */
    private String ordrEmail;
    /** 주문자 전화 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrTel;
    /** 주문자 휴대폰 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrMobile;
    /** 주문자 모바일(암호화 제거) */
    private String nonOrdrMobile;
    /** 수신자 명 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsNm;
    /** 수신자 전화 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsTel;
    /** 수신자 휴대폰 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsMobile;
    /** 수신자 우편번호 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String postNo;
    /** 수신자 도로명 주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadnmAddr;
    /** 수신자 지번 주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String numAddr;
    /** 수신자 상세주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    /** 수신자 배송 메세지 */
    private String dlvrMsg;
    /** 결제PG 코드 */
    private String paymentPgCd;
    /** 결제수단 코드 */
    private String paymentWayCd;
    /** 결제수단 명 */
    private String paymentWayNm;
    /** 에스크로 승인번호 */
    private String escrowConfirmno;
    /** 결제일시 */
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date paymentCmpltDttm;
    /** 판매채널 */
    private String saleChannelNm;
    /** 결제 금액 */
    private String paymentAmt;

    /** 원 결제 금액 */
    private String orgPaymentAmt;

    /** 출고 송장 번호 **/
    private String rlsYn;
    /** 구매 횟수 **/
    private String memBuyCnt;
    /** 적립 예정 금액 **/
    private long pvdSvmn;
    /** 판매 금액 **/
    private String saleAmt;
    /** 총 판매 금액 **/
    private String sumSaleAmt;
    /** 공급 금액 **/
    private String supplyAmt;
    /** 총 공급 금액 **/
    private String sumSupplyAmt;

    /** 할인 금액 **/
    private long dcAmt;

    /** 주문상태 cSS 컬러 클래스 명 */
    private String cssClass;

    /** 순방향 주문상태 코드 */
    private String fordStatusCd;
    /** 순방향 주문상태 명 */
    private String fordStatusNm;

    /** 순방향 claim 주문상태 코드 */
    private String fClaimOrdStatusCd;
    /** 순방향 claim 주문상태 명 */
    private String fClaimOrdStatusNm;

    /** 역방향 주문상태 코드 */
    private String bordStatusCd;
    /** 역방향 주문상태 명 */
    private String bordStatusNm;

    /** 주문 메모 */
    private String memoContent;
    /** 주문서 적용 쿠폰 사용 금액 */
    private String cpUseAmt;

    /** 해외 주소 관련 */
    private String memberGbCd;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrCountry;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrCity;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrState;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrZipCode;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrDtl1;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrDtl2;

    private String pgType; // PG 마켓포인트 구분

    /** TO_ORD_DTM */
    private String ordQtt;
    private String ordGoodsQtt;
    private String chgQtt;
    private String statusNo;
    private String statusNm;
    private String titleInfo;
    private String claimDtlReason;
    private String ordDtlStatusCd;
    private String ordDtlStatusNm;
    private String ordDtlSeq;
    // 클레임 접수 일시
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private String claimAcceptDttm;
    // 클레임 완료 일시
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private String claimCmpltDttm;
    // 클레임 취소 일시
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private String claimCancelDttm;

    /* 모바일 추가 2016-09-27 */
    private String addOptNm;
    /* 판매 채널 */
    private String saleChannelCd;
    /* 모바일 추가 2016-10-07 */
    private String prcAmt;
    private String addedAmountAmt;

    /** 실제 배송비 **/
    private String realDlvrAmt;
    /** 운송장번호 **/
    private String rlsInvoiceNo;
    /** 택배사코드 **/
    private String rlsCourierCd;
    /** 택배사명 **/
    private String rlsCourierNm;

    /** site(front/back) **/
    private String siteGbn;

    private String claimNo;
    private int claimQtt;
    private long refundAmt;

    private String storeNo;
    private String storeNm;
    private String strVisitDate;

    private long totSaleAmt;

    private String refundType;
    private String claimType;
    /** 반품 상품 코드  */
    private String[] claimGoodsNoArr;
    /**상세 내역용추가 2023-05-16 210**/
    // 정가금액
    private long customerAmt;
    // 지급금액
    private long pvdsvmnAmt;
    // 마켓포인트
    private long mileageAmt;
    // 포인트
    private long pointAmt;
    // 스탬프적립개수
    private long stampsaveAmt;
    // 사용스탬프개수
    private long stampuseAmt;
    // 추가배송비
    private long dlvrAddAmt;
    // 배송비
    private long dlvrAmt;
    //방문예약
    private String rsvNo;

    //배송지명
    private String deliveryNm;

    //상품결제시픽업 상품 정보
    private String rsvDate;
    private String rsvTime;
    private String visitPurposeNm;

    private String dlvrcPaymentCd;
    private String dlvrMethodCd;//배송 방법
    private String visitPurposeCd;//방문 목적
    private String buyGlassLensYn; //안경렌즈 구매요청 여부
    private String appLinkGbCd; // 간편 결제 정보

    private String ordUpdateDate; //주문 상테 업데이트 시간
    private long totalPvdSvmn; // 구매확정시 적립 포인트
    private long totalSaleAmt; // 구매확정시 판매 가격
    private long totalDcAmt; // 구매확정시 할인 가격
    private long totalDlvrAmt; // 구매확정시 배송비
    private long totalDlvrAddAmt; // 구매확정시 추가 배송비
    private long totalGoodsDmoneyUseAmt; // 구매확정시 사용포인트
    private String isErpMappingDone;

    public String getfClaimOrdStatusCd() {
        return fClaimOrdStatusCd;
    }

    public void setfClaimOrdStatusCd(String fClaimOrdStatusCd) {
        this.fClaimOrdStatusCd = fClaimOrdStatusCd;
    }
}
