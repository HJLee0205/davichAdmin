<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">알림</t:putAttribute>
    
    
    
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                jQuery('#btn_error_prev').on('click', function() {
                    window.history.back();
                });
                jQuery('#btn_error_main').on('click', function() {
                    window.location.href = '/';
                });
                jQuery('#btn_error_login').on('click', function() {
                    //window.location.href = "/front/login/member-login";
                     var returnUrl = $("form[name=submitForm] [name=returnUrl]").val();
                     if(returnUrl == ""){
                     	returnUrl = window.location.pathname+window.location.search;
                     }
                    $("form[name=submitForm] [name=returnUrl]").val(returnUrl+window.location.search);
                    $("form[name=submitForm]").attr("method","POST");
                    $("form[name=submitForm]").attr("action","${_MOBILE_PATH}/front/login/member-login");
                    $("form[name=submitForm]").submit();
                });

                jQuery('#nomember_rsv').on('click', function() {

                    $("form[name=submitForm]").attr("method","POST");
                    $("form[name=submitForm]").attr("action","${_MOBILE_PATH}/front/login/member-login?type=nomemRsv");
                    $("form[name=submitForm]").submit();
                });

                jQuery('#nomember_search').on('click', function() {

                    $("form[name=submitForm]").attr("method","POST");
                    $("form[name=submitForm]").attr("action","${_MOBILE_PATH}/front/login/member-login?type=nomemOrd");
                    $("form[name=submitForm]").submit();
                });
            })
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
	<!--- 03.LAYOUT:CONTENTS --->

	<div id="middle_area">
		<form name="submitForm">
        <input type="hidden" name="returnUrl" value="${refererUrl}"/>
    </form>
		<div class="error_title">
			${exMsg}
		</div>
		<div class="error_text01">
            <c:if test="${user.login}">이용에 불편을 드려 죄송합니다.</c:if>
		</div>
		<div class="error_text02">
			감사합니다.
		</div>
		<div class="error_btn_area">
			<c:choose>
				<c:when test="${user.login}">
					<button type="button" class="btn_error_go" id="btn_error_prev">이전페이지로 돌아가기</button>
					<button type="button" class="btn_error_go_main" id="btn_error_main">메인페이지로 돌아가기</button>
				</c:when>
				<c:otherwise>
					<button type="button" class="btn_error_go_main" id="btn_error_main" style="background:#fff;color:#4d4f52;">메인페이지로 돌아가기</button>
					<button type="button" class="btn_error_go" id="btn_error_login" style="background:#1f59ff;color:#fff;">로그인하기</button>
				</c:otherwise>
			</c:choose>
                    
		</div>
		<ul class="login_form" id="loginLayer">
		    <p style="font-size: 17px;text-align: center;">회원가입 없이 비회원으로 주문/예약 하셨다면!&nbsp; </p><br>
			<li><button type="button" id="nomember_search" class="btn_login_nomember">비회원 주문조회</button></li>

			<li><button type="button" id="nomember_rsv" class="btn_login_nomember">비회원 방문예약 조회</button></li>
		</ul>
		<div class="error_footer">
			System by Davich
		</div>
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->

    </t:putAttribute>
</t:insertDefinition>