<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">가입완료</t:putAttribute>


	<t:putAttribute name="script">
    <script>
		$(document).ready(function(){
		    //move login
		    $('.btn_join_ok').on('click',function(){
		        location.href = '/front/login/member-login';
		    });
		    //move main
	        $('.btn_go_mall').on('click', function(){
	            location.href = '/front/main-view';
	        });
		});
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
    <!--- contents --->
    <div class="contents fixwid">
        <div id="member_location">
            <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>회원가입
        </div>
        <c:if test="${so.memberDi != '' && so.memberDi ne null}">
        <ul class="join_steps">
            <li>본인인증</li>
            <li>약관동의</li>
            <li>회원정보입력</li>
            <li class="thisstep">가입완료</li>
        </ul>
        </c:if>
        <c:if test="${so.memberDi == '' || so.memberDi eq null }">
        <ul class="join_steps_01">
            <li>약관동의</li>
            <li>회원정보입력</li>
            <li class="thisstep">가입완료</li>
        </ul>
        </c:if>
        <!--- 가입완료 --->
        <div class="join_end_text">
            회원가입완료 되었습니다.<br>
            로그인후 사용해주세요.
            <div class="btn_area">
                <button type="button" class="btn_join_ok">로그인</button>
                <button type="button" class="btn_go_mall">쇼핑몰메인</button>
            </div>
        </div>
        <!---// 가입완료 --->
    </div>
    <!---// contents --->
	</t:putAttribute>
</t:insertDefinition>