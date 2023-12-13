package net.danvi.dmall.smsemail.model.request;

import java.io.Serializable;

/**
 * Created by dong on 2016-10-04.
 */
public class MemberManageSO implements Serializable {

	private String siteNo;
    // 가입일 시작일자
    private String joinStDttm;
    // 가입일 종료일자
    private String joinEndDttm;
    // 최종방문일 시작일자
    private String loginStDttm;
    // 최종방문일 종료일자
    private String loginEndDttm;
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
    private String genderGbCd;
    // 포인트 시작금액
    private String stPrcPoint;
    // 포인트 종료금액
    private String endPrcPoint;
    // 가입경로 코드
    private String[] joinPathCd;
    // 검색타입
    private String searchType;
    // 검색어
    private String searchWords;
    // 검색어 (핸드폰 검색)
    private String searchMobile;
    // 검색어 (전화번호 검색)
    private String searchTel;
    // 검색어 (이름 검색)
    private String searchName;
	// 검색어 (닉네임 검색)
	private String searchNn;

    //업체명
    private String searchBizName;
    //사업자 등록 번호
    private String searchBizNo;

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

    // 이용약관
    private String rule01Agree;
    private String rule02Agree;
    private String rule03Agree;

    /*-----------휴먼,탈퇴 회원 -----------------------*/
    private String withdrawalStDttm;
    private String withdrawalEndDttm;
    private String withdrawalDttm;
    private String dormantDttm;
    private String withdrawalReasonCd;
    private String etcWithdrawalReason;
    private String withdrawalTypeCd;
    private Long[] updMemberNo;

    // 모드(페이지 동적구분자)
    private String mode;
    // 회원이름
    private String memberNm;
    // 생일
    private String birth;
    // e-mail
    private String email;
    // 휴대폰
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
    private String recomId;

    // 나이 시작일자
    private String stAge;
    // 나이 종료일자
    private String endAge;

    // 앱 토큰값
    private String appToken;

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

	public String getSiteNo() {
		return siteNo;
	}

	public void setSiteNo(String siteNo) {
		this.siteNo = siteNo;
	}

	public String getJoinStDttm() {
		return joinStDttm;
	}

	public void setJoinStDttm(String joinStDttm) {
		this.joinStDttm = joinStDttm;
	}

	public String getJoinEndDttm() {
		return joinEndDttm;
	}

	public void setJoinEndDttm(String joinEndDttm) {
		this.joinEndDttm = joinEndDttm;
	}

	public String getLoginStDttm() {
		return loginStDttm;
	}

	public void setLoginStDttm(String loginStDttm) {
		this.loginStDttm = loginStDttm;
	}

	public String getLoginEndDttm() {
		return loginEndDttm;
	}

	public void setLoginEndDttm(String loginEndDttm) {
		this.loginEndDttm = loginEndDttm;
	}

	public String getStBirth() {
		return stBirth;
	}

	public void setStBirth(String stBirth) {
		this.stBirth = stBirth;
	}

	public String getEndBirth() {
		return endBirth;
	}

	public void setEndBirth(String endBirth) {
		this.endBirth = endBirth;
	}

	public String getSmsRecvYn() {
		return smsRecvYn;
	}

	public void setSmsRecvYn(String smsRecvYn) {
		this.smsRecvYn = smsRecvYn;
	}

	public String getEmailRecvYn() {
		return emailRecvYn;
	}

	public void setEmailRecvYn(String emailRecvYn) {
		this.emailRecvYn = emailRecvYn;
	}

	public String getMemberGradeNo() {
		return memberGradeNo;
	}

	public void setMemberGradeNo(String memberGradeNo) {
		this.memberGradeNo = memberGradeNo;
	}

	public String getStSaleAmt() {
		return stSaleAmt;
	}

	public void setStSaleAmt(String stSaleAmt) {
		this.stSaleAmt = stSaleAmt;
	}

	public String getEndSaleAmt() {
		return endSaleAmt;
	}

	public void setEndSaleAmt(String endSaleAmt) {
		this.endSaleAmt = endSaleAmt;
	}

	public String getStPrcAmt() {
		return stPrcAmt;
	}

	public void setStPrcAmt(String stPrcAmt) {
		this.stPrcAmt = stPrcAmt;
	}

	public String getEndPrcAmt() {
		return endPrcAmt;
	}

	public void setEndPrcAmt(String endPrcAmt) {
		this.endPrcAmt = endPrcAmt;
	}

	public String getStOrdCnt() {
		return stOrdCnt;
	}

	public void setStOrdCnt(String stOrdCnt) {
		this.stOrdCnt = stOrdCnt;
	}

	public String getEndOrdCnt() {
		return endOrdCnt;
	}

	public void setEndOrdCnt(String endOrdCnt) {
		this.endOrdCnt = endOrdCnt;
	}

	public String getStCommentCnt() {
		return stCommentCnt;
	}

	public void setStCommentCnt(String stCommentCnt) {
		this.stCommentCnt = stCommentCnt;
	}

	public String getEndCommentCnt() {
		return endCommentCnt;
	}

	public void setEndCommentCnt(String endCommentCnt) {
		this.endCommentCnt = endCommentCnt;
	}

	public String getStLoginCnt() {
		return stLoginCnt;
	}

	public void setStLoginCnt(String stLoginCnt) {
		this.stLoginCnt = stLoginCnt;
	}

	public String getEndLoginCnt() {
		return endLoginCnt;
	}

	public void setEndLoginCnt(String endLoginCnt) {
		this.endLoginCnt = endLoginCnt;
	}

	public String getGenderGbCd() {
		return genderGbCd;
	}

	public void setGenderGbCd(String genderGbCd) {
		this.genderGbCd = genderGbCd;
	}

	public String getStPrcPoint() {
		return stPrcPoint;
	}

	public void setStPrcPoint(String stPrcPoint) {
		this.stPrcPoint = stPrcPoint;
	}

	public String getEndPrcPoint() {
		return endPrcPoint;
	}

	public void setEndPrcPoint(String endPrcPoint) {
		this.endPrcPoint = endPrcPoint;
	}

	public String[] getJoinPathCd() {
		return joinPathCd;
	}

	public void setJoinPathCd(String[] joinPathCd) {
		this.joinPathCd = joinPathCd;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchWords() {
		return searchWords;
	}

	public void setSearchWords(String searchWords) {
		this.searchWords = searchWords;
	}

	public String getSearchMobile() {
		return searchMobile;
	}

	public void setSearchMobile(String searchMobile) {
		this.searchMobile = searchMobile;
	}

	public String getSearchTel() {
		return searchTel;
	}

	public void setSearchTel(String searchTel) {
		this.searchTel = searchTel;
	}

	public String getSearchName() {
		return searchName;
	}

	public void setSearchName(String searchName) {
		this.searchName = searchName;
	}

	public String getSearchBizName() {
		return searchBizName;
	}

	public void setSearchBizName(String searchBizName) {
		this.searchBizName = searchBizName;
	}

	public String getSearchBizNo() {
		return searchBizNo;
	}

	public void setSearchBizNo(String searchBizNo) {
		this.searchBizNo = searchBizNo;
	}

	public String getSearchLoginId() {
		return searchLoginId;
	}

	public void setSearchLoginId(String searchLoginId) {
		this.searchLoginId = searchLoginId;
	}

	public String getSearchEmail() {
		return searchEmail;
	}

	public void setSearchEmail(String searchEmail) {
		this.searchEmail = searchEmail;
	}

	public String getSearchMemberNo() {
		return searchMemberNo;
	}

	public void setSearchMemberNo(String searchMemberNo) {
		this.searchMemberNo = searchMemberNo;
	}

	public String getPrcId() {
		return prcId;
	}

	public void setPrcId(String prcId) {
		this.prcId = prcId;
	}

	public String getPrcNm() {
		return prcNm;
	}

	public void setPrcNm(String prcNm) {
		this.prcNm = prcNm;
	}

	public Long getMemberNo() {
		return memberNo;
	}

	public void setMemberNo(Long memberNo) {
		this.memberNo = memberNo;
	}

	public String getMemberStatusCd() {
		return memberStatusCd;
	}

	public void setMemberStatusCd(String memberStatusCd) {
		this.memberStatusCd = memberStatusCd;
	}

	public String getMemberTypeCd() {
		return memberTypeCd;
	}

	public void setMemberTypeCd(String memberTypeCd) {
		this.memberTypeCd = memberTypeCd;
	}

	public String getIntegrationMemberGbCd() {
		return integrationMemberGbCd;
	}

	public void setIntegrationMemberGbCd(String integrationMemberGbCd) {
		this.integrationMemberGbCd = integrationMemberGbCd;
	}

	public String getBbsId() {
		return bbsId;
	}

	public void setBbsId(String bbsId) {
		this.bbsId = bbsId;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
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

	public String getFromRegDt() {
		return fromRegDt;
	}

	public void setFromRegDt(String fromRegDt) {
		this.fromRegDt = fromRegDt;
	}

	public String getToRegDt() {
		return toRegDt;
	}

	public void setToRegDt(String toRegDt) {
		this.toRegDt = toRegDt;
	}

	public String getRule01Agree() {
		return rule01Agree;
	}

	public void setRule01Agree(String rule01Agree) {
		this.rule01Agree = rule01Agree;
	}

	public String getRule02Agree() {
		return rule02Agree;
	}

	public void setRule02Agree(String rule02Agree) {
		this.rule02Agree = rule02Agree;
	}

	public String getRule03Agree() {
		return rule03Agree;
	}

	public void setRule03Agree(String rule03Agree) {
		this.rule03Agree = rule03Agree;
	}

	public String getWithdrawalStDttm() {
		return withdrawalStDttm;
	}

	public void setWithdrawalStDttm(String withdrawalStDttm) {
		this.withdrawalStDttm = withdrawalStDttm;
	}

	public String getWithdrawalEndDttm() {
		return withdrawalEndDttm;
	}

	public void setWithdrawalEndDttm(String withdrawalEndDttm) {
		this.withdrawalEndDttm = withdrawalEndDttm;
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

	public Long[] getUpdMemberNo() {
		return updMemberNo;
	}

	public void setUpdMemberNo(Long[] updMemberNo) {
		this.updMemberNo = updMemberNo;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}

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

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getMemberGbCd() {
		return memberGbCd;
	}

	public void setMemberGbCd(String memberGbCd) {
		this.memberGbCd = memberGbCd;
	}

	public String getNtnGbCd() {
		return ntnGbCd;
	}

	public void setNtnGbCd(String ntnGbCd) {
		this.ntnGbCd = ntnGbCd;
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

	public String getCertifyMethodCd() {
		return certifyMethodCd;
	}

	public void setCertifyMethodCd(String certifyMethodCd) {
		this.certifyMethodCd = certifyMethodCd;
	}

	public String getGradeAutoRearrangeYn() {
		return gradeAutoRearrangeYn;
	}

	public void setGradeAutoRearrangeYn(String gradeAutoRearrangeYn) {
		this.gradeAutoRearrangeYn = gradeAutoRearrangeYn;
	}

	public String[] getAdminNoArr() {
		return adminNoArr;
	}

	public void setAdminNoArr(String[] adminNoArr) {
		this.adminNoArr = adminNoArr;
	}

	public String getEmailCertifyValue() {
		return emailCertifyValue;
	}

	public void setEmailCertifyValue(String emailCertifyValue) {
		this.emailCertifyValue = emailCertifyValue;
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

	public String getRecomId() {
		return recomId;
	}

	public void setRecomId(String recomId) {
		this.recomId = recomId;
	}

	public String getStAge() {
		return stAge;
	}

	public void setStAge(String stAge) {
		this.stAge = stAge;
	}

	public String getEndAge() {
		return endAge;
	}

	public void setEndAge(String endAge) {
		this.endAge = endAge;
	}

	public String getAppToken() {
		return appToken;
	}

	public void setAppToken(String appToken) {
		this.appToken = appToken;
	}

	public String getSearchAlarmGb() {
		return searchAlarmGb;
	}

	public void setSearchAlarmGb(String searchAlarmGb) {
		this.searchAlarmGb = searchAlarmGb;
	}

	public String getSearchMethod() {
		return searchMethod;
	}

	public void setSearchMethod(String searchMethod) {
		this.searchMethod = searchMethod;
	}

	public String getGoodsTypeCd() {
		return goodsTypeCd;
	}

	public void setGoodsTypeCd(String goodsTypeCd) {
		this.goodsTypeCd = goodsTypeCd;
	}

	public String getAgeCd() {
		return ageCd;
	}

	public void setAgeCd(String ageCd) {
		this.ageCd = ageCd;
	}

	public String getMemberCardNo() {
		return memberCardNo;
	}

	public void setMemberCardNo(String memberCardNo) {
		this.memberCardNo = memberCardNo;
	}

	public String getStAppDate() {
		return stAppDate;
	}

	public void setStAppDate(String stAppDate) {
		this.stAppDate = stAppDate;
	}

	public String getEndAppDate() {
		return endAppDate;
	}

	public void setEndAppDate(String endAppDate) {
		this.endAppDate = endAppDate;
	}

	public String getSearchNn() {
		return searchNn;
	}

	public void setSearchNn(String searchNn) {
		this.searchNn = searchNn;
	}
}
