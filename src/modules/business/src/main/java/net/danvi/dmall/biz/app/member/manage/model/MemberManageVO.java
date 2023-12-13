package net.danvi.dmall.biz.app.member.manage.model;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 관리 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class MemberManageVO extends BaseModel<MemberManageVO> {
    // 회원 이름
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    // 대표자명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ceoNm;
    // 회원 생일
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String birth;
    // 회원 생년
    private String bornYear;
    // 회원 생월
    private String bornMonth;
    // 회원 성별
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String genderGbCd;
    // 회원 국적 코드
    private String ntnGbCd;
    // 인증방법코드(01:모바일,02:IPIN)
    private String certifyMethodCd;
    // 가입일시
    private String joinDttm;
    // 이메일 수신여부
    private String emailRecvYn;
    // SMS 수신여부
    private String smsRecvYn;
    // 080 수신여부
    private String recvRjtYn;
    // 회원 상태(일반회원,휴면회원,탈퇴회원)
    private String memberStatusCd;
    // 회원 상태 명
    private String memberStatusNm;
    // 로그인 아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    // 회원 전화번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String tel;
    // 회원 휴대폰 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;
    // 회원 이메일
    private String email;
    // 가입 경로 코드
    private String joinPathCd;
    // 가입 경로 명
    private String joinPathNm;
    // 마켓포인트
    private String prcAmt;
    // 포인트
    private String prcPoint;
    // 스탬프
    private String prcStamp;
    // 구매금액
    private String saleAmt;
    // 주문횟수
    private String ordCnt;
    // 회원등급 번호
    private String memberGradeNo;
    // 회원등급 명
    private String memberGradeNm;
    // 최종 방문일
    private String lastLoginDttm;
    // 방문횟수
    private String loginCnt;
    // 실명확인
    private String realnmCertifyYn;
    // 신우편번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String newPostNo;
    // 번지주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String strtnbAddr;
    // 도로주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadAddr;
    // 공통 상세 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    // 해외 주소 Country
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrCountry;
    // 해외 주소 City
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrCity;
    // 해외 주소 State
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrState;
    // 해외 주소 우편번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrZipCode;
    // 해외 주소 상세1
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrDtl1;
    // 해외 주소 상세2
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String frgAddrDtl2;
    // 관리자 메모
    private String managerMemo;
    // 로그인 IP
    private String loginIp;
    // 회원정보 수정일시
    private String chgDttm;
    // 회원구분코드(10:국내거주,20:해외거주)
    private String memberGbCd;
    // 비밀번호 변경 일시
    private String pwChgDttm;
    // 다음 비밀번호 변경 예정 일시
    private String nextPwChgScdDttm;

    // 성공 인증 버로
    private String adultCertifyYn;
    // 로그인 실패 수
    private String loginFailCnt;

    // 등급 자동 산정 여부
    private String gradeAutoRearrangeYn;

    /*------------게시글 관련 Obj------------*/
    // 상품문의 글 갯수
    private String questionCnt;
    // 상품후기 글 갯수
    private String reviewCnt;
    // 1:1문의게시판 등록 글 갯수
    private String inquiryCnt;
    // 1:1문의게시판 답변 완료 글 갯수
    private String completInquiryCnt;
    /*------------게시글 관련 Obj END------------*/

    /*------------장바구니.관심상품 보유갯수 START------------*/
    private String basketCnt;
    private String interestCnt;
    /*------------장바구니.관심상품 보유갯수 END------------*/

    /*------------쿠폰 관련 Obj------------*/
    // 쿠폰 보유 갯수
    private String cpCnt;
    // 쿠폰 번호
    private String couponNo;
    // 회원 쿠폰 번호
    private String memberCpNo;
    // 오프라인 쿠폰 번호
    private String cpIssueNo;
    // 쿠폰 유효기간 시작
    private String cpApplyStartDttm;
    // 쿠폰 유효기간 종료
    private String cpApplyEndDttm;
    // 쿠폰 사용 여부
    private String useYn;
    // 쿠폰 사용 일자
    private String useDttm;
    // 쿠폰 발급 일자
    private String issueDttm;
    // 쿠폰 사용 기한 일자
    private String couponApplyPeriodDttm;
    // 쿠폰 사용 기한 남은 일자
    private String couponApplyPeriod;
    // 쿠폰 명
    private String couponNm;
    // 쿠폰 혜택 코드
    private String couponBnfCd;
    // 쿠폰 혜택 단위(원,%)
    private String bnfUnit;
    // 쿠폰 혜택 값
    private long couponBnfValue;
    // 쿠폰 혜택 내용
    private String couponBnfTxt;
    // 쿠폰 사용 제한 값
    private long couponUseLimitAmt;
    // 쿠폰 혜택 최대 할인 금액
    private long couponBnfDcAmt;
    // 쿠폰 종류 코드
    private String couponKindCd;
    // 쿠폰 종류 코드 명
    private String couponKindCdNm;
    // 쿠폰 적용 대상/예외 코드
    private String couponApplyLimitCd;
    // 쿠폰 적용 대상 코드(상품/카테고리)
    private String couponApplyTargetCd;
    // 쿠폰 적용 기간 코드(01:기간 , 02:발급일로부터 몇일)
    private String couponApplyPeriodCd;
    // 쿠폰 적용 발급 후 기간
    private int couponApplyIssueAfPeriod;
    // 쿠폰 설명
    private String couponDscrt;
    private String offlineOnlyYn; //오프라인전용여부
    /*------------쿠폰 관련 Obj END------------*/

    /*------------자주쓰는 배송지 관련 Obj------------*/
    // 배송지 구분 명
    private String gbNm;
    // 수취인 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsNm;
    // 해외주소 여부
    private String frgAddrYn;
    // 국내,해외 구분
    private String frgGb;
    // 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String addr;
    /*------------자주쓰는 배송지 관련 Obj END------------*/

//    private String rownum;
    private String pagingNum;
    private String sortNum;
    private String rowNum;
    // 비밀번호
    private String pw;

    @NotEmpty
    // 회원번호
    private Long memberNo;

    /*-----------휴먼,탈퇴 회원 -----------------------*/
    private String withdrawalDttm;
    private String dormantDttm;
    private String withdrawalReasonCd;
    private String withdrawalReasonNm;
    private String etcWithdrawalReason;
    private String withdrawalTypeCd;
    private String withdrawalTypeNm;
    private String authGbCd;
    // 모드(페이지 동적구분자)
    private String mode;
    // CI
    private String memberCi;
    // DI
    private String memberDi;

    /*-----------등급할인 관련 ---------*/
    private String dcUnitCd;
    private int dcValue;
    private String svmnUnitCd;
    private int svmnValue;

    private String prcNm;
    private String prcLogNm;

    // 배송준비 건수
    private String deliveryReadyCnt;

    // 배송중 건수
    private String deliveryCnt;

    // 배송완료 건수
    private String deliveryCompleteCnt;

    // 맞교환 접수 건수
    private String exchangeReceiptCnt;

    // 맞교환 완료 건수
    private String exchangeCompleteCnt;

    // 환불 접수 건수
    private String refundReceiptCnt;

    // 이메일 결과 코드
    private String resultCd;

    //이메일 인증키
    private String emailCertifyValue;

    //이메일 인증일시
    private String authDate;

    //회원유형코드
    private String memberTypeCd;

    //회원유형명
    private String memberTypeNm;

    //사업자 등록 번호
    private String bizRegNo;

    //담당자 명
    private String managerNm;

    //사업자 등록증 파일 경로
    private String bizFilePath;

    //사업자 등록증 파일명
    private String bizFileNm;

    //사업자 등록증 원본 파일명
    private String bizOrgFileNm;

    //사업자 등록증 파일크기
    private Long bizFileSize;

    private String customStoreNo;
    private String customStoreNm;
    
    private String appToken;
    private String osType;

    //추천인 아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String recomMemberId;
    
    //통합회원
    private String integrationMemberGbCd;
    private String integrationMemberGbNm;
    //멤버쉽통합일시
    private String memberIntegrationDttm;
    //아이디변경 여부
    private String idChgYn;
    //앱최초로그인일시
    private String appFirstLoginDttm;
    //쿠폰 제품유형
    private String goodsTypeCd;
    //쿠폰 연령대
    private String ageCd;
    
    private String memberCardNo;
    private String mobileSmr;
    private String recomMemberNo;
    private String appLastLoginDttm;
    private String autoLoginGb;
    private String locaGb;
    private String notiGb;
    private String eventGb;
    private String newsGb;
    private String storeJoinYn;
    private String idChgDttm;


    private String appDate;
    private String memo;/* 내용 */
    private String appTime; /* 수신시간 */
    private String strCode;/* 발송매장 */
    private String strName;
    private String appYmd;/* 수신일자 */
    private String imgUrl;

    private String receiverNo;
    private String receiverId;
    private String pushNo;
    private String sendMsg;
    private String link;
    private String sendDttm;
    //푸쉬 확인유무
    private String readYn;

    private String newMemberYn; //신규회원여부
    private String oldMemberYn; //기존회원(재구매 유도 쿠폰을 받은 기존회원)
    private int couponApplyConfirmAfPeriod; // 구매확정일로부터 XX일까지 사용 가능
    private String confirmYn; //첫구매쿠폰 주문 구매확정여부
    private String firstSpcOrdYn; // 첫구매특가프로모션참여여부

        // PUSH 구분
    private String[] pushGbCd;


   private String cdCust;
   private String mallNoCard;
   private String dates;
   private String posNo;
   private String trxnNo;
   private String seqNo;
   private String enDate;
   private String itmCode;
   private String itmName;
   private String gubun;

   private String memberNn; // 회원 닉네임
   private String imgPath;  // 프로필 이미지 경로
   private String imgNm;    // 프로필 이미지 명
   private String imgOrgNm; // 프로필 원본 이미지 명
   private String infDesc;  // 인플루언서 소개
   private String bizAprvYn;// 사업자 승인 여부

    private String inDate;  // 일시
    private String inType;  // 지급(+)/차감(-)
    private String inStore; // 온라인(on)/오프라인(off)
    private String slaStamp; // 수량
    private String authNm;

    private String erpMemberNo;
}

