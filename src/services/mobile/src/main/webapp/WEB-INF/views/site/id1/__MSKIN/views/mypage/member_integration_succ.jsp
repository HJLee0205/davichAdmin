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
	<t:putAttribute name="title">멤버쉽 통합</t:putAttribute>

    
	<t:putAttribute name="script">
	<script src="${_SKIN_JS_PATH}/jquery-barcode.js" charset="utf-8"></script>
    <script>
    $(document).ready(function(){
    	var curr_dt = new Date().format("yyyy-MM-dd hh:mm:ss");
    	$('#integration_date').text(curr_dt);
    	
    	$("[id^=bcTarget]").barcode("${user.session.memberCardNo}", "code128");
    	
    });
    
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <div id="middle_area">
        <div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			멤버쉽 통합
		</div>
		<div class="cont_body">
			<!-- <div class="membership_combine">
				<p class="text">통합멤버쉽 안내</p>
			</div> -->
			<div class="membership_completed">
				멤버쉽 통합완료
			</div>
			<div class="card_area <c:if test="${user.session.memberGradeNo eq '2'}">vip</c:if>">
				<div class="member_card_name">DAVICH Membership</div>
				<div class="member_barcode">
					<div class="member_name"><em>${user.session.memberNm}</em>님</div>
					<div id="bcTarget" style="margin: 0 auto"></div>
					<p class="member_no"><span>NO.</span><span>${fn:substring(user.session.memberCardNo,0,2)}</span><span>${fn:substring(user.session.memberCardNo,2,5)}</span><span>${fn:substring(user.session.memberCardNo,5,9)}</span></p>
				</div>
			</div>
			<p class="membership_plus_date">멤버쉽통합일시  :  <span class="date" id="integration_date"></span></p>
		</div><!-- //cont_body -->
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>