<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		    $('.btn_go_login').on('click',function(){
		        location.href = '${_MOBILE_PATH}/front/login/member-login';
		    });
		    //move main
	        $('.btn_go_home').on('click', function(){
	            location.href = '${_MOBILE_PATH}/front/main-view';
	        });
		});
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
     
   	<!--- 03.LAYOUT: MIDDLE AREA --->
	<div id="middle_area">
		<div class="cart_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			회원가입
		</div>	
		<ul class="join_steps">
			<li>
				<span class="icon_steps01"></span>
				<span class="title">본인인증</span>
			</li>
			<li>
				<span class="icon_steps02"></span>
				<span class="title">약관동의</span>
			</li>
			<li>
				<span class="icon_steps03"></span>
				<span class="title">회원정보입력</span>
			</li>
			<li class="selected">
				<span class="icon_steps04"></span>
				<span class="title">가입완료</span>
			</li>
		</ul>
		<div class="join_detail_area">			
			<div class="join_member_ok">
				회원가입이 완료되었습니다. 로그인해 주세요.
				<div class="join_btn_area">
					<button type="button" class="btn_go_login">로그인</button>
					<button type="button" class="btn_go_home">메인으로 이동</button>
				</div>
			</div>
		</div>		
	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
	</t:putAttribute>
</t:insertDefinition>