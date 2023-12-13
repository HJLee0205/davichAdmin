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
                    $("form[name=submitForm]").attr("action","/front/login/member-login");
                    $("form[name=submitForm]").submit();
                });

                jQuery('.btn_rsv_nomember').on('click', function() {

                    $("form[name=submitForm]").attr("method","POST");
                    $("form[name=submitForm]").attr("action","/front/login/member-login?type=nomemRsv");
                    $("form[name=submitForm]").submit();
                });

                jQuery('.btn_go_nomember').on('click', function() {

                    $("form[name=submitForm]").attr("method","POST");
                    $("form[name=submitForm]").attr("action","/front/login/member-login?type=nomemOrd");
                    $("form[name=submitForm]").submit();
                });
            })
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <form name="submitForm">
        <input type="hidden" name="returnUrl" value="${refererUrl}"/>
    </form>
        <!--- contents --->
        <div class="error">
            <div class="error_box">
                <h1 class="error_logo">
                    <c:if test="${empty site_info.logoPath}">
                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=LOGO&id1=logo.png" alt="LOGO">
                    </c:if>
                    <c:if test="${!empty site_info.logoPath}">
                    <img src="${_IMAGE_DOMAIN}${site_info.logoPath}" alt="LOGO" onerror="this.src='/front/img/common/logo/logo.png'">
                    </c:if>
                </h1>
                <div class="error_title">
                	${exMsg}

                </div>
	            <div class="error_text01">
					<c:if test="${user.login}">이용에 불편을 드려 죄송합니다.</c:if>
	            </div>
                <div class="error_text02">
                    감사합니다.
                </div>
                <div class="btn_area" style="height:100px">
                	<c:choose>
                		<c:when test="${user.login}">
		                    <button type="button" class="btn_error_prev" id="btn_error_prev" style="margin-right:6px">이전페이지로 돌아가기</button>
		                    <button type="button" class="btn_error_main" id="btn_error_main">메인페이지로 돌아가기</button>
                    	</c:when>
                    	<c:otherwise>
		                    <button type="button" class="btn_error_main" id="btn_error_main" style="margin-right:6px;background:#fff;color:#4d4f52;">메인페이지로 돌아가기</button>
		                    <button type="button" class="btn_error_prev" id="btn_error_login" style="background:#1f59ff;color:#fff;">로그인하기</button>
                    	</c:otherwise>
                    </c:choose>
                </div>

                <p class="guide_membership">
						회원가입 없이 비회원으로 주문/예약 하셨다면! 

						<button type="button" class="btn_go_nomember">비회원주문조회</button>

						<button type="button" class="btn_rsv_nomember">비회원방문예약조회</button>
					</p>
            </div>
            <div class="error_footer">System by Davich</div>
        </div>
        <!---// contents --->

    </t:putAttribute>
</t:insertDefinition>