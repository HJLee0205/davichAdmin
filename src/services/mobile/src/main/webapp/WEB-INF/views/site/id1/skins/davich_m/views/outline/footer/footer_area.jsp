<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>

<script>
function communicationPopup(){
    window.open("http://www.ftc.go.kr/info/bizinfo/communicationList.jsp", "통신판매사업자");
}
</script>
<ul class="address_info">
	<li class="tit">${site_info.companyNm}</li>
	<li>대표이사 : ${site_info.ceoNm} </li>
	<li>사업자등록번호 : ${site_info.bizNo} [<a href="javascript:communicationPopup();">확인</a>] </li>
	<li>통신판매업신고번호 : ${site_info.commSaleRegistNo}</li>
	<li>주소 : ${site_info.addrRoadnm}&nbsp;${site_info.addrCmnDtl} </li>
	<li>대표전화 : ${site_info.certifySendNo} </li>
	<li>이메일 : ${site_info.email}</li>
	<li>© ${site_info.siteNm} Corp. All Rights Reserved.</li>
</ul>
<ul class="footer_basic_menu">
	<li><a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=01">회사소개</a></li>
	<li><a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=04">개인정보처리방침</a></li>
	<li><a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=22">위치정보이용약관</a></li>
	<li><a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=21">청소년보호정책</a></li>
	<li><a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=09">멤버쉽회원약관</a></li>
	<li><a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=10">온라인몰이용약관</a></li>
	<li><a href="${_MOBILE_PATH}/front/seller/seller-detail">입점안내</a></li>
</ul>

<%--
<div class="footer_menu">
	<span class="first"><a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=03">이용안내</a></span>
	<span><a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=04">개인정보처리방침</a></span>
	<span><a href="/front/main-view?site_preference=normal">PC버전</a></span>
</div>--%>
<sec:authentication var="user" property='details'/>
<footer>
	<div id="footer-menu" <c:if test="${!user.login}">class="logout"</c:if>> <!-- 로그아웃 상태일 경우 class="logout" 추가 -->
		<a href="javascript:history.back();" class="btn_f_prev active"><i></i>이전</a>
		<!--a href="javascript:history.forward();" class="btn_f_next"><i></i>다음</a--><%--<i class="icon01"><em class="cart_won"></em></i>--%>
		<a href="${_MOBILE_PATH}/front/basket/basket-list" class="btn_f_cart"><i class="icon01"><em class="cart_won"></em></i>장바구니</a>
		<a href="${_MOBILE_PATH}/front" class="btn_f_home"><i></i>홈</a>
		<c:if test="${user.login}">
			<a href="${_MOBILE_PATH}/front/member/mypage" class="btn_f_my"><i></i>마이페이지</a>
		</c:if>
		<a href="javascript:;" class="btn_f_menu"><i></i>메뉴보기</a>
	</div>
	<div id="footer-content" style="display:none;">
		<div class="footer-tit">카테고리 <span class="close toggle-footer">닫기</span></div>
		<ul class="footer-navi">
			<c:forEach var="ctgList" items="${lnb_info.get('0')}" varStatus="status">
				<li>
					<a href="#gnb0${ctgList.ctgNo}" onclick="javascript:move_category('${ctgList.ctgNo}');return false;">${ctgList.ctgNm}</a>
				</li>
			</c:forEach>
		</ul>
	</div>
</footer>