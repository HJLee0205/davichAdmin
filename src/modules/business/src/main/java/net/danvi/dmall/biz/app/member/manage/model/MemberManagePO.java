package net.danvi.dmall.biz.app.member.manage.model;

import java.util.Date;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constraint.NullOrLength;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class MemberManagePO extends BaseModel<MemberManagePO> {
    private Long memberNo;

    // 회원이름
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    //관심 상품 코드
    private String goodsTypeCd;

    private String chgMemberNm;
    // 대표자명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ceoNm;

    @NullOrLength()
    // 생일
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String birth;
    // 생년
    private String bornYear;
    // 생월
    private String bornMonth;
    // 이메일
    private String email;
    // 이메일 수신동의
    private String emailRecvYn;
    // 휴대폰
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;
    // SMS 수신동의
    private String smsRecvYn;
    // 전화번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String tel;
    // 신 우편번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String newPostNo;
    // 번지 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String strtnbAddr;
    // 도로명 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadAddr;
    // 공통 상세 주소
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    // 회원 등급 번호
    private String memberGradeNo;
    // 관리자 메모
    private String managerMemo;
    // 회원 상태 코드(일반, 휴면, 탈퇴)
    private String memberStatusCd;
    // 탈퇴 유형 코드(일반, 강제, 탈퇴신청)
    private String withdrawalTypeCd;
    // 탈퇴 사유 코드
    private String withdrawalReasonCd;
    // 기타 탈퇴 사유
    private String etcWithdrawalReason;
    // 회원구분코드(10:국내거주,20:해외거주)
    private String memberGbCd;
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
    // 현재비밀번호
    @Encrypt(type = CryptoUtil.MD, algorithm = CryptoUtil.MD_SHA512)
    private String pw;
    // 비밀번호확인
    private String nowPw;
    // 신규비밀번호
    private String newPw;
    // 국적구분(01:대한민국,02:미국,03:중국)
    private String ntnGbCd;
    // 인증방법코드(01:모바일,02:IPIN)
    private String certifyMethodCd;
    // 가입경로
    private String joinPathCd;
    // 로그인아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    // 실명인증여부
    private String realnmCertifyYn;
    // CI
    private String memberCi;
    // DI
    private String memberDi;
    // 성인인증여부
    private String adultCertifyYn;
    // 성별(M:남자,F:여자)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String genderGbCd;
    // 모드(페이지 동적구분자)
    private String mode;

    private Date nextPwChgScdDttm;

    // 등급 자동 산정 여부
    private String gradeAutoRearrangeYn;

    // 가입 장치 유형(PC : P, 모바일 : M)
    private String joinDeviceType;

    //이메일 인증키
    private String emailCertifyValue;

    //회원 유형 코드
    private String memberTypeCd;

    //사업자 등록 번호
    private String bizRegNo;

    //담당자 명
    private String managerNm;

    private String bizFilePath;          //사업자 등록증 파일 경로
    private String bizFileNm;            //사업자 등록증 파일명
    private String bizOrgFileNm;         //사업자 등록증 원본 파일명
    private Long bizFileSize;         //사업자 등록증 파일크기
    
    private String integrationMemberGbCd; //통합 회원 구분 코드
    
    private String custName;
    private String hp;
    private String strCode;
    //온라인 카드번호
    private String memberCardNo;

    private String storeNo;
    private String storeNm;


    /**
     * 휴대폰 뒤 4자리
     */
    private String mobileSmr;
    
    // 오프라인 회원 조회 데이터 (회원통합시 사용)
    private String cdCust;
    private String lvl;
    private String onlineCardNo;
    
    // 추천인 회원번호
    private String recomMemberNo;
    
    // 토큰정보
    private String appToken;
    // 자동로그인
    private String autoLoginGb;
    // 위치정보동의
    private String locaGb;

    // 푸쉬 강제 동의 여부
    private String forcePushAgreeYn;
    
    //공지사항여부
    private String notiGb;
    //이벤트 여부
    private String eventGb;
    //뉴스 여부
    private String newsGb;  
    
    private String osType;
    //아이디변경 여부
    private String idChgYn;
    //변경할 아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String chgId;
    
    private String intro;
    
    private String searchMethod; //비밀번호찾기 인증수단 구분
    
    private String certifyPoint; //휴대폰인증 적립포인트
    
    // 푸쉬메세지 확인
    private String pushType;
    private String pushNo;

    private String rule04Agree;
    private String rule22Agree;
    private String rule21Agree;
    private String rule09Agree;
    private String rule10Agree;
    private String keyData;
    private String deviceType;
    //회원 닉네임
    private String memberNn;
    //프로필 이미지 경로
    private String imgPath;
    //프로필 이미지 명
    private String imgNm;
    //프로필 원본 이미지 명
    private String imgOrgNm;
    //인플루언서 소개
    private String infDesc;
    //사업자 승인 여부
    private String bizAprvYn;
    //가맹점 코드
    private String customStoreNo;
	private String erpMemberNo;

}
