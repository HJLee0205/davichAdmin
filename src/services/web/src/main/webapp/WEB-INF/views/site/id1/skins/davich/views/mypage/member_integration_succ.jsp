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
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 멤버쉽 통합</t:putAttribute>

    
	<t:putAttribute name="script">
	<script src="${_SKIN_JS_PATH}/jquery-barcode.js" charset="utf-8"></script>
    <script>
    $(document).ready(function(){
    	
    	$("#bcTarget").barcode("${user.session.memberCardNo}", "code128", {barWidth: 2,barHeight: 50});
    	
    });
    
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
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
           	
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_body">
				<h3 class="my_tit">멤버쉽 통합</h3>

				<!-- <div class="membership_combine">
					<p class="text">통합멤버쉽 안내</p>
				</div> -->

				<div class="membership_completed">
					멤버쉽 통합완료
				</div>
				<div class="card_area">
					<div class="member_card_name">DAVICH Membership</div>
					<div class="member_barcode">
						<div class="member_name"><em>${user.session.memberNm}</em>님</div>
						<div id="bcTarget" style="margin: 0 auto"></div>
						<p class="member_no"><span>NO.</span><span>${fn:substring(user.session.memberCardNo,0,2)}</span><span>${fn:substring(user.session.memberCardNo,2,5)}</span><span>${fn:substring(user.session.memberCardNo,5,9)}</span></p>
					</div>
				</div>
				<p class="membership_plus_date">멤버쉽통합일시  :  <span class="date" id="integration_date">${integrationDttm }</span></p>
			</div>

            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>