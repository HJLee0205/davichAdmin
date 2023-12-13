package net.danvi.dmall.biz.system.remote.homepage.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constraint.NullOrLength;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

import java.util.Date;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 19.
 * 작성자     : dong
 * 설명       : 관리자 회원 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class AdminMemberPO extends BaseModel<AdminMemberPO> {
    private Long memberNo;

    // 회원이름
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;

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
}
