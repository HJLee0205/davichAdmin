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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 방문예약</t:putAttribute>


 <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	
    	$('#visit_book').on('click', function(){
    		location.href="/front/visit/visit-book";
    	});
    });

    </script>
    </t:putAttribute>
    
    
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->
    
    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="mypage_middle">	
    
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div id="mypage_content">
            
	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
	            
				<div class="mypage_body">	
					<h3 class="my_tit">방문예약</h3>	
					<div class="visit_main_box">
						<p class="text">
							<img src="${_SKIN_IMG_PATH}/mypage/visit_img.jpg">
						</p>
					</div>
					<div class="cart_bottom_btn_area">
						<button type="button" class="btn_all_checkout" id="visit_book">예약신청</button>
					</div>
				</div>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
	</div>

    </t:putAttribute>
</t:insertDefinition>