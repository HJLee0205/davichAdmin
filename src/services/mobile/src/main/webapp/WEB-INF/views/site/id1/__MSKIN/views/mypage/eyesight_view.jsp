<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
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
    <t:putAttribute name="title">내시력정보</t:putAttribute>



    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	$("#btn_go_eyesight_reg").on("click", function() {
    		// 등록/수정 화면으로 이동
    		document.location.href = "${_MOBILE_PATH}/front/mypage/eyesight_reg_form";
    	});
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			내 시력정보
		</div>
		<div class="cont_body">			
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
			<table class="tProduct_Board my_davich">
				<caption>
					<h1 class="blind">내 시력정보 목록입니다.</h1>
				</caption>
				<colgroup>
					<col style="width:30%">
					<col style="width:35%">
					<col style="width:35%">
				</colgroup>
				<thead>
					<tr>
						<th></th>
						<th>R</th>
						<th>L</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>SPH</th>
						<td>${eyesightInfo.sphR}</td>
						<td>${eyesightInfo.sphL}</td>
					</tr>
					<tr>
						<th>CYL</th>
						<td>${eyesightInfo.cylR}</td>
						<td>${eyesightInfo.cylL}</td>
					</tr>
					<tr>
						<th>AXIS</th>
						<td>${eyesightInfo.axisR}</td>
						<td>${eyesightInfo.axisL}</td>
					</tr>
					<tr>
						<th>PRISM</th>
						<td>${eyesightInfo.prismR}</td>
						<td>${eyesightInfo.prismL}</td>
					</tr>
					<tr>
						<th>BASE</th>
						<td>${eyesightInfo.baseR}</td>
						<td>${eyesightInfo.baseL}</td>
					</tr>
					<tr>
						<th>ADD</th>
						<td>${eyesightInfo.addR}</td>
						<td>${eyesightInfo.addL}</td>
					</tr>
					<tr>
						<th>PD</th>
						<td>**</td>
						<td>**</td>
					</tr>
				</tbody>
			</table>
			<c:if test="${eyesightInfo.lastUpdDttm != null}">
				<p class="bottom_my_davich">최종수정 <span class="date">${eyesightInfo.lastUpdDttm}</span></p>
			</c:if>

			<div class="btn_davichi_area">
				<button type="button" class="btn_info_modify" id="btn_go_eyesight_reg">등록/수정</button>
<!-- 				<button type="button" class="btn_info_import">가져오기</button> -->
			</div>
		</div><!-- //cont_body -->

	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
    </t:putAttribute>
</t:insertDefinition>