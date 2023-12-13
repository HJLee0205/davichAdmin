package net.danvi.dmall.biz.app.operation.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 24.
 * 작성자     : kjw
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ReplaceCdVO extends BaseModel<ReplaceCdVO> {
    private String replaceNo;
    private String replaceNm;
    private String replaceDscrt;
    private String replaceGbCd;
    private String mappingTable;
    private String mappingColumn;
    private String dispMappingColumn;
    private String delYn;

    /* 치환 데이터 Start */
    // SITE 정보
    private String dlgtDomain;
    private String logoPath;
    private String custCtEmail;
    private String custCtTelNo;

    private String memberNm; // 회원명
    private String mobile; // 회원 핸드폰
    private String tel; // 회원 전화번호
    private String email; // 회원이메일
    private String birth; // 회원 생일
    private String userId; // 로그인 아이디
    private String dormantDttm; // 휴면 회원 일시
    private String withdrawalDttm; // 탈퇴 회원 일시
    private String siteDomain; // 사이트 도메인
    private String siteNm; // 사이트명
    private String remainEmail; // 남은 이메일 건수
    private String remainSms; // 남은 SMS 건수
    private String orderNm; // 주문자명
    private String orderNo; // 주문번호
    private String orderItem; // 주문상품(sms 인 경우 여러개인 경우 상품 외 몇 건으로 표시)
    private String orderItemList; // 주문상품
    private String bankAccount; // 입금은행 계좌번호 예금주
    private String settleprice; // 입금(결제) 금액
    private String settleKind; // 결제수단 수단별확인 메세지(신용카드-카드결제 완료, 계좌이체-계좌이체 완료, 가상계좌-가상계좌 완료 등)
    private String dormancyDuDate; // 휴면예정일
    private String goItem; // 출고완료/배송완료 상품(sms 인 경우 여러개인 경우 상품 외 몇 건으로 표시)
    private String deliveryCompany; // 택배사명
    private String deliveryNumber; // 운송장 번호
    private String repayItem; // 취소,반품->환불완료 상품(sms 인 경우 여러개인 경우 상품 외 몇 건으로 표시)

    // 이메일 자동 발송 셋팅 정보
    private String mailTypeCd; // 메일 유형 코드
    private String shopName; // 쇼핑몰 명
    private String shopDomain; // 쇼핑몰 도메인

    // 1:1 문의 치환코드
    private String inqueryTitle; // 문의 제목
    private String inqueryRegrDtm; // 문의 등록일
    private String inqueryContent; // 문의 내용
    private String inqueryReplyTitle; // 답변 제목
    private String inqueryReplyRegrDtm; // 답변 등록일
    private String inqueryReplyContent; // 답변 내용

    // 주문관련 치환코드
    private String ordEmail; // 이메일
    private String ordTel; // 주문자 전화
    private String ordMobile; // 주문자 휴대폰
    private String ordAdrsNm; // 수취인 명
    private String ordAdrsTel; // 수취인 전화
    private String ordAdrsMobile; // 수취인 휴대폰
    private String ordRoadAddr; // 주문 도로명 주소
    private String ordNumAddr; // 주문 지번 주소
    private String ordDtlAddr; // 주문 상세주소
    private String ordDlvrMsg; // 배송 메세지
    private String ordSaleAmt; // 판매금액
    private String ordDcAmt; // 할인금액
    private String ordSvmnAmt; // 마켓포인트액
    private String ordDlvrAmt; // 배송금액
    private String ordPayAmt; // 결제금액
    private String ordBankNm; // 입금은행명
    private String ordBankAccntNo; // 입금은행 계좌
    private String ordBankAccntNm; // 입금자명
    private String ordClaimBankNm; // 클레임 은행 명
    private String ordClaimAccntNo;// 클레임 계좌 번호
    private String ordClaimAccntNm;// 클레임 계좌주 명
    private String ordClaimReason; // 클레임 사유
    private String ordClaimDtlReason; // 클레임 상세 사유
    private String ordClaimAmt; // 클레임 금액
    private String ordClaimCmpltDttm; // 클레임 완료 일시
    private String ordClaimSvmnAmt; // 글레임 적립 금액
    private String ordClaimRefundWay; // 클레임 환불 방법

    private String ordPaymentWayNm; // 결제수단명
    private String ordGoodsInfo; // 주문상품명 (예시 - 블라우스외 2건)

    // ## 주문상세

    private String ordGoodsList; // 주문상품정보 table list 구문
    // 주문상품정보
    private String orddtlGoodsNm; // 상품명
    private String orddtlItemNm; // 단품명
    private String orddtlAddOptYn; // 추가옵션여부
    private String orddtlAddOptNm; // 추가 옵션명
    private String orddtlOrdQtt; // 주문수량
    private String orddtlSaleAmt; // 상품금액
    private String orddtlDcAmt; // 할인금액
    private String orddtlTotalAmt; // 합계금액 (주문수량*상품금액 - 할인금액)
    private String orddtlDlvrAmd; // 배송비

    private String reqDate; // 요청일
    /* 치환 데이터 End */

    // ## 재입고알림
    // 상품명
    private String goodsNm;

    //이메일인증키
    private String key;
    //회원유형코드
    private String memberTypeCd;
    //인증유효일시
    private String authDate;
    //이메일 인증키
    private String emailCertifyValue;

    //사업자등록번호
    private String bizRegNo;


    /*방문예약*/
    private String rsvNo;
    private String storeNo;
    private String storeNm;
    private String rsvDate;
    private String rsvTime;
    private String reqMatr;

    private String rsvName;
    private String rsvGubun;


    /* 쿠폰발행 */
    private int couponNo;
    private String couponNm;
    private String applyEndDttm;

    /* 기타 */
    private String etc;

    private String sellerNm;
    private String storeKakaoAddr;

    private String mypageUrl;
    private String visionCheckUrl;
    private String ordLimitDttm;
}
