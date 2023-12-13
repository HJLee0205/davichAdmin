<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 시력정보</t:putAttribute>


 <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	$("#btn_go_eyesight_reg").on("click", function() {
    		// 등록/수정 화면으로 이동
    		document.location.href = "/front/mypage/eyesight_reg_form";
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
					<h3 class="my_tit">내 시력정보</h3>
	
					<ul class="my_eye_date">
						<li>
							<p class="tit"><span class="dot">검사일</span></p>
							<p class="text">${eyesightInfo.checkupDt}</p>
						</li>
						<li>
							<p class="tit"><span class="dot">검사기관</span></p>
							<p class="text">${eyesightInfo.checkupInstituteNm}</p>
						</li>
					</ul>		
					
					<table class="tProduct_Board my_davichi">
						<caption>
							<h1 class="blind">내 시력정보 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th>SPH</th>
								<th>CYL</th>
								<th>AXIS</th>
								<th>PRISM</th>
								<th>BASE</th>
								<th>ADD</th>
								<th>PD</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>R</td>							
								<td><c:out value="${eyesightInfo.sphR}" default="-" /></td>
								<td><c:out value="${eyesightInfo.cylR}" default="-" /></td>
								<td><c:out value="${eyesightInfo.axisR}" default="-" /></td>
								<td><c:out value="${eyesightInfo.prismR}" default="-" /></td>
								<td><c:out value="${eyesightInfo.baseR}" default="-" /></td>
								<td><c:out value="${eyesightInfo.addR}" default="-" /></td>
								<td>**</td>
							</tr>
							<tr>
								<td>L</td>					
								<td><c:out value="${eyesightInfo.sphL}" default="-" /></td>
								<td><c:out value="${eyesightInfo.cylL}" default="-" /></td>
								<td><c:out value="${eyesightInfo.axisL}" default="-" /></td>
								<td><c:out value="${eyesightInfo.prismL}" default="-" /></td>
								<td><c:out value="${eyesightInfo.baseL}" default="-" /></td>
								<td><c:out value="${eyesightInfo.addL}" default="-" /></td>
								<td>**</td>						
							</tr>
						</tbody>
					</table>
					
					<c:if test="${eyesightInfo.lastUpdDttm != null}">
						<p class="bottom_my_davich">최종수정 <span class="date">${eyesightInfo.lastUpdDttm}</span></p>
					</c:if>
					<div class="btn_davichi_area">
						<button type="button" class="btn_info_modify" id="btn_go_eyesight_reg">등록/수정</button>
<!-- 						<button type="button" class="btn_info_import">가져오기</button> -->
					</div>
				</div>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
	</div>

    </t:putAttribute>
</t:insertDefinition>