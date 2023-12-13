package net.danvi.dmall.biz.app.member.manage.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constraint.NullOrLength;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 관리 검색 조건의 Search Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class MemberManageSO extends BaseSearchVO<MemberManageSO> {
    @NullOrLength()
    // 가입일 시작일자
    private String joinStDttm;
    // 가입일 종료일자
    private String joinEndDttm;
    // 최종방문일 시작일자
    private String loginStDttm;
    // 최종방문일 종료일자
    private String loginEndDttm;
    // 구매일 시작일자
    private String ordStDttm;
    // 구매일 종료일자
    private String ordEndDttm;
    // 생일 시작일자
    private String stBirth;
    // 생일 종료일자
    private String endBirth;
    // SMS 수신 여부
    private String smsRecvYn;
    // 이메일 수신 여부
    private String emailRecvYn;
    // 회원 등급 번호
    private String memberGradeNo;
    // 구매제품 구분
    private String ordTypeCd;
    // 구매금액 시작금액
    private String stSaleAmt;
    // 구매금액 종료금액
    private String endSaleAmt;
    // 마켓포인트 시작금액
    private String stPrcAmt;
    // 마켓포인트 종료금액
    private String endPrcAmt;
    // 주문횟수 시작
    private String stOrdCnt;
    // 주문횟수 종료
    private String endOrdCnt;
    // 댓글횟수 시작
    private String stCommentCnt;
    // 댓글횟수 종료
    private String endCommentCnt;
    // 방문횟수 시작
    private String stLoginCnt;
    // 방문횟수 종료
    private String endLoginCnt;
    // 성별 구분 코드
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String genderGbCd;
    // 포인트 시작금액
    private String stPrcPoint;
    // 포인트 종료금액
    private String endPrcPoint;
    // 스탬프 시작금액
    private String stPrcStamp;
    // 스탬프 종료금액
    private String endPrcStamp;
    // 가입경로 코드
    private String[] joinPathCd;
    // 검색타입
    private String searchType;
    // 검색어
    private String searchWords;
    // 검색어 (핸드폰 검색)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchMobile;
    // 검색어 (전화번호 검색)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchTel;
    // 검색어 (이름 검색)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchName;

    // 검색어 (닉네임 검색)
    private String searchNn;

    //업체명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchBizName;
    //사업자 등록 번호
    private String searchBizNo;

    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchLoginId;
    
    private String searchEmail;
    private String searchMemberNo;

    // 처리자 아이디
    private String prcId;
    // 처리자 이름
    private String prcNm;
    // 회원 번호
    private Long memberNo;
    // 회원 상태 코드(일반,휴면,탈퇴)
    private String memberStatusCd;

    // 회원 유형코드
    private String memberTypeCd;
    
    // 통합 회원 구분 코드
    private String integrationMemberGbCd;


    // 게시판 아이디
    private String bbsId;
    // 회원 쿠폰 사용 여부
    private String useYn;
    // 로그인 아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    // 비밀번호
    private String pw;

    // 생년
    private String bornYear;
    // 생월
    private String bornMonth;

    // 쿠폰 기간 검색
    private String fromRegDt;
    private String toRegDt;

    // 스탬프 검색 조건
    private String fromDt;  // 지급/차감 시작일
    private String toDt;    // 지급/차감 종료일
    private String statusCd;// 지급/차감 radio

    // 이용약관
    private String rule01Agree;
    private String rule02Agree;
    private String rule03Agree;


    private String rule04Agree;
    private String rule22Agree;
    private String rule21Agree;
    private String rule09Agree;
    private String rule10Agree;

    /*-----------휴먼,탈퇴 회원 -----------------------*/
    private String withdrawalStDttm;
    private String withdrawalEndDttm;
    private String withdrawalDttm;
    private String dormantDttm;
    private String dormantStDttm;
    private String dormantEndDttm;
    private String withdrawalReasonCd;
    private String etcWithdrawalReason;
    private String withdrawalTypeCd;
    private Long[] updMemberNo;

    // 모드(페이지 동적구분자)
    private String mode;
    // 회원이름
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    // 생일
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String birth;
    // e-mail
    private String email;
    // 휴대폰
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;

    // 회원구분코드(10:국내거주,20:해외거주)
    private String memberGbCd;
    // 국적구분(01:대한민국,02:미국,03:중국)
    private String ntnGbCd;
    // CI
    private String memberCi;
    // DI
    private String memberDi;
    // 인증모듈구분자
    private String certifyMethodCd;

    // 등급 자동 산정 여부
    private String gradeAutoRearrangeYn;

    // 관리자 번호 목록
    private String[] adminNoArr;

    //이메일 인증키
    private String emailCertifyValue;
    
    //쿠폰번호
    private String couponNo;
    //회원쿠폰번호
    private String memberCpNo;
    // 오프라인 쿠폰 번호
    private String cpIssueNo;
    
    // 추천인 아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String recomId;

    // 나이 시작일자
    private String stAge;
    // 나이 종료일자
    private String endAge;
    
    // 앱 토큰값
    private String appToken;
    
    // 구분
    private String searchAlarmGb;
    
    //비밀번호찾기 인증수단 구분
    private String searchMethod;
    
    //마이페이지 쿠폰조회용
    private String goodsTypeCd;
    private String ageCd;

    //온라인 회원카드번호
    private String memberCardNo;
    private String stAppDate;
    private String endAppDate;

    private String smsSearchYn;

    // PUSH 구분
    private String[] pushGbCd;

}
