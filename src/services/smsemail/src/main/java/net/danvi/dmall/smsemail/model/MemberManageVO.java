package net.danvi.dmall.smsemail.model;

import org.hibernate.validator.constraints.NotEmpty;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;

/**
 * Created by dong on 2016-10-04.
 */
public class MemberManageVO {
	
    // 회원 이름
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
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

    private String rownum;
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
    private String recomMemberId;

	public String getMemberNm() {
		return memberNm;
	}

	public void setMemberNm(String memberNm) {
		this.memberNm = memberNm;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public String getBornYear() {
		return bornYear;
	}

	public void setBornYear(String bornYear) {
		this.bornYear = bornYear;
	}

	public String getBornMonth() {
		return bornMonth;
	}

	public void setBornMonth(String bornMonth) {
		this.bornMonth = bornMonth;
	}

	public String getGenderGbCd() {
		return genderGbCd;
	}

	public void setGenderGbCd(String genderGbCd) {
		this.genderGbCd = genderGbCd;
	}

	public String getNtnGbCd() {
		return ntnGbCd;
	}

	public void setNtnGbCd(String ntnGbCd) {
		this.ntnGbCd = ntnGbCd;
	}

	public String getCertifyMethodCd() {
		return certifyMethodCd;
	}

	public void setCertifyMethodCd(String certifyMethodCd) {
		this.certifyMethodCd = certifyMethodCd;
	}

	public String getJoinDttm() {
		return joinDttm;
	}

	public void setJoinDttm(String joinDttm) {
		this.joinDttm = joinDttm;
	}

	public String getEmailRecvYn() {
		return emailRecvYn;
	}

	public void setEmailRecvYn(String emailRecvYn) {
		this.emailRecvYn = emailRecvYn;
	}

	public String getSmsRecvYn() {
		return smsRecvYn;
	}

	public void setSmsRecvYn(String smsRecvYn) {
		this.smsRecvYn = smsRecvYn;
	}

	public String getRecvRjtYn() {
		return recvRjtYn;
	}

	public void setRecvRjtYn(String recvRjtYn) {
		this.recvRjtYn = recvRjtYn;
	}

	public String getMemberStatusCd() {
		return memberStatusCd;
	}

	public void setMemberStatusCd(String memberStatusCd) {
		this.memberStatusCd = memberStatusCd;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getJoinPathCd() {
		return joinPathCd;
	}

	public void setJoinPathCd(String joinPathCd) {
		this.joinPathCd = joinPathCd;
	}

	public String getJoinPathNm() {
		return joinPathNm;
	}

	public void setJoinPathNm(String joinPathNm) {
		this.joinPathNm = joinPathNm;
	}

	public String getPrcAmt() {
		return prcAmt;
	}

	public void setPrcAmt(String prcAmt) {
		this.prcAmt = prcAmt;
	}

	public String getPrcPoint() {
		return prcPoint;
	}

	public void setPrcPoint(String prcPoint) {
		this.prcPoint = prcPoint;
	}

	public String getSaleAmt() {
		return saleAmt;
	}

	public void setSaleAmt(String saleAmt) {
		this.saleAmt = saleAmt;
	}

	public String getOrdCnt() {
		return ordCnt;
	}

	public void setOrdCnt(String ordCnt) {
		this.ordCnt = ordCnt;
	}

	public String getMemberGradeNo() {
		return memberGradeNo;
	}

	public void setMemberGradeNo(String memberGradeNo) {
		this.memberGradeNo = memberGradeNo;
	}

	public String getMemberGradeNm() {
		return memberGradeNm;
	}

	public void setMemberGradeNm(String memberGradeNm) {
		this.memberGradeNm = memberGradeNm;
	}

	public String getLastLoginDttm() {
		return lastLoginDttm;
	}

	public void setLastLoginDttm(String lastLoginDttm) {
		this.lastLoginDttm = lastLoginDttm;
	}

	public String getLoginCnt() {
		return loginCnt;
	}

	public void setLoginCnt(String loginCnt) {
		this.loginCnt = loginCnt;
	}

	public String getRealnmCertifyYn() {
		return realnmCertifyYn;
	}

	public void setRealnmCertifyYn(String realnmCertifyYn) {
		this.realnmCertifyYn = realnmCertifyYn;
	}

	public String getNewPostNo() {
		return newPostNo;
	}

	public void setNewPostNo(String newPostNo) {
		this.newPostNo = newPostNo;
	}

	public String getStrtnbAddr() {
		return strtnbAddr;
	}

	public void setStrtnbAddr(String strtnbAddr) {
		this.strtnbAddr = strtnbAddr;
	}

	public String getRoadAddr() {
		return roadAddr;
	}

	public void setRoadAddr(String roadAddr) {
		this.roadAddr = roadAddr;
	}

	public String getDtlAddr() {
		return dtlAddr;
	}

	public void setDtlAddr(String dtlAddr) {
		this.dtlAddr = dtlAddr;
	}

	public String getFrgAddrCountry() {
		return frgAddrCountry;
	}

	public void setFrgAddrCountry(String frgAddrCountry) {
		this.frgAddrCountry = frgAddrCountry;
	}

	public String getFrgAddrCity() {
		return frgAddrCity;
	}

	public void setFrgAddrCity(String frgAddrCity) {
		this.frgAddrCity = frgAddrCity;
	}

	public String getFrgAddrState() {
		return frgAddrState;
	}

	public void setFrgAddrState(String frgAddrState) {
		this.frgAddrState = frgAddrState;
	}

	public String getFrgAddrZipCode() {
		return frgAddrZipCode;
	}

	public void setFrgAddrZipCode(String frgAddrZipCode) {
		this.frgAddrZipCode = frgAddrZipCode;
	}

	public String getFrgAddrDtl1() {
		return frgAddrDtl1;
	}

	public void setFrgAddrDtl1(String frgAddrDtl1) {
		this.frgAddrDtl1 = frgAddrDtl1;
	}

	public String getFrgAddrDtl2() {
		return frgAddrDtl2;
	}

	public void setFrgAddrDtl2(String frgAddrDtl2) {
		this.frgAddrDtl2 = frgAddrDtl2;
	}

	public String getManagerMemo() {
		return managerMemo;
	}

	public void setManagerMemo(String managerMemo) {
		this.managerMemo = managerMemo;
	}

	public String getLoginIp() {
		return loginIp;
	}

	public void setLoginIp(String loginIp) {
		this.loginIp = loginIp;
	}

	public String getChgDttm() {
		return chgDttm;
	}

	public void setChgDttm(String chgDttm) {
		this.chgDttm = chgDttm;
	}

	public String getMemberGbCd() {
		return memberGbCd;
	}

	public void setMemberGbCd(String memberGbCd) {
		this.memberGbCd = memberGbCd;
	}

	public String getPwChgDttm() {
		return pwChgDttm;
	}

	public void setPwChgDttm(String pwChgDttm) {
		this.pwChgDttm = pwChgDttm;
	}

	public String getNextPwChgScdDttm() {
		return nextPwChgScdDttm;
	}

	public void setNextPwChgScdDttm(String nextPwChgScdDttm) {
		this.nextPwChgScdDttm = nextPwChgScdDttm;
	}

	public String getAdultCertifyYn() {
		return adultCertifyYn;
	}

	public void setAdultCertifyYn(String adultCertifyYn) {
		this.adultCertifyYn = adultCertifyYn;
	}

	public String getLoginFailCnt() {
		return loginFailCnt;
	}

	public void setLoginFailCnt(String loginFailCnt) {
		this.loginFailCnt = loginFailCnt;
	}

	public String getGradeAutoRearrangeYn() {
		return gradeAutoRearrangeYn;
	}

	public void setGradeAutoRearrangeYn(String gradeAutoRearrangeYn) {
		this.gradeAutoRearrangeYn = gradeAutoRearrangeYn;
	}

	public String getQuestionCnt() {
		return questionCnt;
	}

	public void setQuestionCnt(String questionCnt) {
		this.questionCnt = questionCnt;
	}

	public String getReviewCnt() {
		return reviewCnt;
	}

	public void setReviewCnt(String reviewCnt) {
		this.reviewCnt = reviewCnt;
	}

	public String getInquiryCnt() {
		return inquiryCnt;
	}

	public void setInquiryCnt(String inquiryCnt) {
		this.inquiryCnt = inquiryCnt;
	}

	public String getCompletInquiryCnt() {
		return completInquiryCnt;
	}

	public void setCompletInquiryCnt(String completInquiryCnt) {
		this.completInquiryCnt = completInquiryCnt;
	}

	public String getBasketCnt() {
		return basketCnt;
	}

	public void setBasketCnt(String basketCnt) {
		this.basketCnt = basketCnt;
	}

	public String getInterestCnt() {
		return interestCnt;
	}

	public void setInterestCnt(String interestCnt) {
		this.interestCnt = interestCnt;
	}

	public String getCpCnt() {
		return cpCnt;
	}

	public void setCpCnt(String cpCnt) {
		this.cpCnt = cpCnt;
	}

	public String getCouponNo() {
		return couponNo;
	}

	public void setCouponNo(String couponNo) {
		this.couponNo = couponNo;
	}

	public String getMemberCpNo() {
		return memberCpNo;
	}

	public void setMemberCpNo(String memberCpNo) {
		this.memberCpNo = memberCpNo;
	}

	public String getCpIssueNo() {
		return cpIssueNo;
	}

	public void setCpIssueNo(String cpIssueNo) {
		this.cpIssueNo = cpIssueNo;
	}

	public String getCpApplyStartDttm() {
		return cpApplyStartDttm;
	}

	public void setCpApplyStartDttm(String cpApplyStartDttm) {
		this.cpApplyStartDttm = cpApplyStartDttm;
	}

	public String getCpApplyEndDttm() {
		return cpApplyEndDttm;
	}

	public void setCpApplyEndDttm(String cpApplyEndDttm) {
		this.cpApplyEndDttm = cpApplyEndDttm;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getUseDttm() {
		return useDttm;
	}

	public void setUseDttm(String useDttm) {
		this.useDttm = useDttm;
	}

	public String getIssueDttm() {
		return issueDttm;
	}

	public void setIssueDttm(String issueDttm) {
		this.issueDttm = issueDttm;
	}

	public String getCouponApplyPeriodDttm() {
		return couponApplyPeriodDttm;
	}

	public void setCouponApplyPeriodDttm(String couponApplyPeriodDttm) {
		this.couponApplyPeriodDttm = couponApplyPeriodDttm;
	}

	public String getCouponApplyPeriod() {
		return couponApplyPeriod;
	}

	public void setCouponApplyPeriod(String couponApplyPeriod) {
		this.couponApplyPeriod = couponApplyPeriod;
	}

	public String getCouponNm() {
		return couponNm;
	}

	public void setCouponNm(String couponNm) {
		this.couponNm = couponNm;
	}

	public String getCouponBnfCd() {
		return couponBnfCd;
	}

	public void setCouponBnfCd(String couponBnfCd) {
		this.couponBnfCd = couponBnfCd;
	}

	public String getBnfUnit() {
		return bnfUnit;
	}

	public void setBnfUnit(String bnfUnit) {
		this.bnfUnit = bnfUnit;
	}

	public long getCouponBnfValue() {
		return couponBnfValue;
	}

	public void setCouponBnfValue(long couponBnfValue) {
		this.couponBnfValue = couponBnfValue;
	}

	public long getCouponUseLimitAmt() {
		return couponUseLimitAmt;
	}

	public void setCouponUseLimitAmt(long couponUseLimitAmt) {
		this.couponUseLimitAmt = couponUseLimitAmt;
	}

	public long getCouponBnfDcAmt() {
		return couponBnfDcAmt;
	}

	public void setCouponBnfDcAmt(long couponBnfDcAmt) {
		this.couponBnfDcAmt = couponBnfDcAmt;
	}

	public String getCouponKindCd() {
		return couponKindCd;
	}

	public void setCouponKindCd(String couponKindCd) {
		this.couponKindCd = couponKindCd;
	}

	public String getCouponKindCdNm() {
		return couponKindCdNm;
	}

	public void setCouponKindCdNm(String couponKindCdNm) {
		this.couponKindCdNm = couponKindCdNm;
	}

	public String getCouponApplyLimitCd() {
		return couponApplyLimitCd;
	}

	public void setCouponApplyLimitCd(String couponApplyLimitCd) {
		this.couponApplyLimitCd = couponApplyLimitCd;
	}

	public String getCouponApplyTargetCd() {
		return couponApplyTargetCd;
	}

	public void setCouponApplyTargetCd(String couponApplyTargetCd) {
		this.couponApplyTargetCd = couponApplyTargetCd;
	}

	public String getCouponApplyPeriodCd() {
		return couponApplyPeriodCd;
	}

	public void setCouponApplyPeriodCd(String couponApplyPeriodCd) {
		this.couponApplyPeriodCd = couponApplyPeriodCd;
	}

	public int getCouponApplyIssueAfPeriod() {
		return couponApplyIssueAfPeriod;
	}

	public void setCouponApplyIssueAfPeriod(int couponApplyIssueAfPeriod) {
		this.couponApplyIssueAfPeriod = couponApplyIssueAfPeriod;
	}

	public String getCouponDscrt() {
		return couponDscrt;
	}

	public void setCouponDscrt(String couponDscrt) {
		this.couponDscrt = couponDscrt;
	}

	public String getGbNm() {
		return gbNm;
	}

	public void setGbNm(String gbNm) {
		this.gbNm = gbNm;
	}

	public String getAdrsNm() {
		return adrsNm;
	}

	public void setAdrsNm(String adrsNm) {
		this.adrsNm = adrsNm;
	}

	public String getFrgAddrYn() {
		return frgAddrYn;
	}

	public void setFrgAddrYn(String frgAddrYn) {
		this.frgAddrYn = frgAddrYn;
	}

	public String getFrgGb() {
		return frgGb;
	}

	public void setFrgGb(String frgGb) {
		this.frgGb = frgGb;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getRownum() {
		return rownum;
	}

	public void setRownum(String rownum) {
		this.rownum = rownum;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public Long getMemberNo() {
		return memberNo;
	}

	public void setMemberNo(Long memberNo) {
		this.memberNo = memberNo;
	}

	public String getWithdrawalDttm() {
		return withdrawalDttm;
	}

	public void setWithdrawalDttm(String withdrawalDttm) {
		this.withdrawalDttm = withdrawalDttm;
	}

	public String getDormantDttm() {
		return dormantDttm;
	}

	public void setDormantDttm(String dormantDttm) {
		this.dormantDttm = dormantDttm;
	}

	public String getWithdrawalReasonCd() {
		return withdrawalReasonCd;
	}

	public void setWithdrawalReasonCd(String withdrawalReasonCd) {
		this.withdrawalReasonCd = withdrawalReasonCd;
	}

	public String getWithdrawalReasonNm() {
		return withdrawalReasonNm;
	}

	public void setWithdrawalReasonNm(String withdrawalReasonNm) {
		this.withdrawalReasonNm = withdrawalReasonNm;
	}

	public String getEtcWithdrawalReason() {
		return etcWithdrawalReason;
	}

	public void setEtcWithdrawalReason(String etcWithdrawalReason) {
		this.etcWithdrawalReason = etcWithdrawalReason;
	}

	public String getWithdrawalTypeCd() {
		return withdrawalTypeCd;
	}

	public void setWithdrawalTypeCd(String withdrawalTypeCd) {
		this.withdrawalTypeCd = withdrawalTypeCd;
	}

	public String getAuthGbCd() {
		return authGbCd;
	}

	public void setAuthGbCd(String authGbCd) {
		this.authGbCd = authGbCd;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}

	public String getMemberCi() {
		return memberCi;
	}

	public void setMemberCi(String memberCi) {
		this.memberCi = memberCi;
	}

	public String getMemberDi() {
		return memberDi;
	}

	public void setMemberDi(String memberDi) {
		this.memberDi = memberDi;
	}

	public String getDcUnitCd() {
		return dcUnitCd;
	}

	public void setDcUnitCd(String dcUnitCd) {
		this.dcUnitCd = dcUnitCd;
	}

	public int getDcValue() {
		return dcValue;
	}

	public void setDcValue(int dcValue) {
		this.dcValue = dcValue;
	}

	public String getSvmnUnitCd() {
		return svmnUnitCd;
	}

	public void setSvmnUnitCd(String svmnUnitCd) {
		this.svmnUnitCd = svmnUnitCd;
	}

	public int getSvmnValue() {
		return svmnValue;
	}

	public void setSvmnValue(int svmnValue) {
		this.svmnValue = svmnValue;
	}

	public String getPrcNm() {
		return prcNm;
	}

	public void setPrcNm(String prcNm) {
		this.prcNm = prcNm;
	}

	public String getPrcLogNm() {
		return prcLogNm;
	}

	public void setPrcLogNm(String prcLogNm) {
		this.prcLogNm = prcLogNm;
	}

	public String getDeliveryReadyCnt() {
		return deliveryReadyCnt;
	}

	public void setDeliveryReadyCnt(String deliveryReadyCnt) {
		this.deliveryReadyCnt = deliveryReadyCnt;
	}

	public String getDeliveryCnt() {
		return deliveryCnt;
	}

	public void setDeliveryCnt(String deliveryCnt) {
		this.deliveryCnt = deliveryCnt;
	}

	public String getDeliveryCompleteCnt() {
		return deliveryCompleteCnt;
	}

	public void setDeliveryCompleteCnt(String deliveryCompleteCnt) {
		this.deliveryCompleteCnt = deliveryCompleteCnt;
	}

	public String getExchangeReceiptCnt() {
		return exchangeReceiptCnt;
	}

	public void setExchangeReceiptCnt(String exchangeReceiptCnt) {
		this.exchangeReceiptCnt = exchangeReceiptCnt;
	}

	public String getExchangeCompleteCnt() {
		return exchangeCompleteCnt;
	}

	public void setExchangeCompleteCnt(String exchangeCompleteCnt) {
		this.exchangeCompleteCnt = exchangeCompleteCnt;
	}

	public String getRefundReceiptCnt() {
		return refundReceiptCnt;
	}

	public void setRefundReceiptCnt(String refundReceiptCnt) {
		this.refundReceiptCnt = refundReceiptCnt;
	}

	public String getResultCd() {
		return resultCd;
	}

	public void setResultCd(String resultCd) {
		this.resultCd = resultCd;
	}

	public String getEmailCertifyValue() {
		return emailCertifyValue;
	}

	public void setEmailCertifyValue(String emailCertifyValue) {
		this.emailCertifyValue = emailCertifyValue;
	}

	public String getAuthDate() {
		return authDate;
	}

	public void setAuthDate(String authDate) {
		this.authDate = authDate;
	}

	public String getMemberTypeCd() {
		return memberTypeCd;
	}

	public void setMemberTypeCd(String memberTypeCd) {
		this.memberTypeCd = memberTypeCd;
	}

	public String getMemberTypeNm() {
		return memberTypeNm;
	}

	public void setMemberTypeNm(String memberTypeNm) {
		this.memberTypeNm = memberTypeNm;
	}

	public String getBizRegNo() {
		return bizRegNo;
	}

	public void setBizRegNo(String bizRegNo) {
		this.bizRegNo = bizRegNo;
	}

	public String getManagerNm() {
		return managerNm;
	}

	public void setManagerNm(String managerNm) {
		this.managerNm = managerNm;
	}

	public String getBizFilePath() {
		return bizFilePath;
	}

	public void setBizFilePath(String bizFilePath) {
		this.bizFilePath = bizFilePath;
	}

	public String getBizFileNm() {
		return bizFileNm;
	}

	public void setBizFileNm(String bizFileNm) {
		this.bizFileNm = bizFileNm;
	}

	public String getBizOrgFileNm() {
		return bizOrgFileNm;
	}

	public void setBizOrgFileNm(String bizOrgFileNm) {
		this.bizOrgFileNm = bizOrgFileNm;
	}

	public Long getBizFileSize() {
		return bizFileSize;
	}

	public void setBizFileSize(Long bizFileSize) {
		this.bizFileSize = bizFileSize;
	}

	public String getCustomStoreNo() {
		return customStoreNo;
	}

	public void setCustomStoreNo(String customStoreNo) {
		this.customStoreNo = customStoreNo;
	}

	public String getCustomStoreNm() {
		return customStoreNm;
	}

	public void setCustomStoreNm(String customStoreNm) {
		this.customStoreNm = customStoreNm;
	}

	public String getAppToken() {
		return appToken;
	}

	public void setAppToken(String appToken) {
		this.appToken = appToken;
	}

	public String getRecomMemberId() {
		return recomMemberId;
	}

	public void setRecomMemberId(String recomMemberId) {
		this.recomMemberId = recomMemberId;
	}

	public String getOsType() {
		return osType;
	}

	public void setOsType(String osType) {
		this.osType = osType;
	}
    
	
}
