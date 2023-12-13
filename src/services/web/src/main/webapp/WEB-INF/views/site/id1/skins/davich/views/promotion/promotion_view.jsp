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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: ${resultModel.data.prmtNm}</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>

    /* 쿠폰 건별 발급 */
    function issueCoupon(couponNo) {

		var url = '/front/coupon/coupon-issue';
		var param = {couponNo: couponNo};

		Dmall.AjaxUtil.getJSON(url, param, function (result) {
			 if(result.success) {
                	Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
                        //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                        function() {
                			location.href= "/front/coupon/coupon-list";
            			},'','','','닫기','마이페이지'
                    );
            }
		});
	}


    $(document).ready(function(){
        //$('#promotionDetailBanner').html($('#tempContentHtml').val());
        $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
        
        $('.select_planning').on('change', function(){
        	var prmNo = $('#otherPromotion option:selected').val();
            if(prmNo != ''){
                $("#prmtNo").val($('#otherPromotion option:selected').val());
                var data = $('#form_id_search').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('/front/promotion/promotion-detail', param);
            }
        });

		<c:if test="${resultModel.data.prmtTypeCd eq '06'}">
        <c:choose>
			<c:when test="${member_info.data.firstSpcOrdYn eq 'N' and (member_info.data.newMemberYn eq 'Y' or  member_info.data.oldMemberYn eq 'Y')}">

			</c:when>
			<c:otherwise>
				Dmall.LayerUtil.alert('특가상품 프로모션에 참여하실 수 없습니다.<br><br> 참여하신 이력이 없고 <br> 신규회원은 가입 후 3일,<br> 기존회원은 쿠폰 발급 후 3일 <br><br> 이내에 참여하실 수 있습니다. <br><br> ※ 상품의 정상 판매 가격으로 구매 할 수 있습니다.');
			</c:otherwise>
		</c:choose>
		</c:if>

    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
<!--         <div id="category_header">
            <div id="category_location">
                <span class="location_bar"></span><a href="/">홈</a><span>&gt;</span>기획전
            </div>
        </div> -->
        <!---// category header --->
        <form name="visitForm" id="visitForm">
    	<input type="hidden" name="refererType" value="${refererType}"/>
		</form>
        <form:form id="form_id_search" commandName="so" >
        <form:hidden path="page" id="page"/>
        <form:hidden path="prmtNo" id="prmtNo"/>
        <form:hidden path="prmtStatusCd" id="prmtStatusCd" />
        <form:hidden path="displayTypeCd" id="displayTypeCd" />
        </form:form>
            <!--- 02.LAYOUT: 카테고리 메인 --->
    	<div class="category_middle">	
    	<div class="event_head">
			<h2 class="event_tit">기획전</h2>
		
		<!-- <div class="planning_top_area"> -->
			<select class="select_planning" name="otherPromotion" id="otherPromotion" title="select option">
	            <option selected="selected" value="">다른 기획전 보기</option>
	            <c:forEach var="exhibitionList" items="${exhibition_list.resultList}" varStatus="status">
	            <option value="${exhibitionList.prmtNo}">${exhibitionList.prmtNm}</option>
	            </c:forEach>
			</select>
		<!-- </div> -->
		</div>
		<div class="planning_view_area">
			<table class="tEvent_view">
				<caption>
					<h1 class="blind">기획전 상세 내용입니다.</h1>
				</caption>
				<colgroup>
					<col style="">
					<col style="width:215px">
				</colgroup>
				<thead>
					<tr>
						<th class="textL">${resultModel.data.prmtNm}</th>
						<th class="textR"> 
						<fmt:parseDate var="startDate" value="${fn:substring(resultModel.data.applyStartDttm, 0, 8)}" pattern="yyyyMMdd" />
						<fmt:formatDate value="${startDate}" pattern="yyyy-MM-dd"/>
						~
						<fmt:parseDate var="endDate" value="${fn:substring(resultModel.data.applyEndDttm, 0, 8)}" pattern="yyyyMMdd" />
						<fmt:formatDate value="${endDate}" pattern="yyyy-MM-dd"/>
						</th>
					</tr>
				</thead><!-- 
				<tbody>
					<tr>
						<td colspan="2">
							<div class="event_view_area">
								${resultModel.data.prmtContentHtml}
							</div>
						</td>
					</tr>
				</tbody> -->
			</table>
			<div class="event_view_area">
				${resultModel.data.prmtContentHtml}
				<!-- <img src="../../../skin/img/product/planning_detail01.jpg" alt=""> -->
			</div>
		</div>	
		<!-- 주목할 상품 -->
		<c:set var="count" value="${fn:length(display_list)}"/>
		<c:set var="prmtCnt" value="0"/>
		<%--<div class="point_product">
		    <c:forEach var="display_list" items="${display_list}" varStatus="status">
	    	<c:if test="${display_list.prmtDispzoneNo eq 1}">	
	    		<c:set var="prmtCnt" value="${prmtCnt+1}"/>	
		    	<h3 class="planning_mid_tit">주목할 상품</h3>
				<ul class="category_bb">
	            <c:set var="exhibition_list" value="promotion_display_goods_${display_list.prmtDispzoneNo}" />
	            <c:set var="list" value="${requestScope.get(exhibition_list)}" />
	            <data:goodsList value="${list}" displayTypeCd="06" headYn="N" iconYn="N"/>
				</ul>
            </c:if>
		    </c:forEach>
		</div>--%>
		<!-- 주목할 상품 -->	
		<!-- 기획전 상품목록 -->
		<c:if test="${(count-prmtCnt) ne 0}">
		<div class="planning_product_area">

		<!-- 기획전 전시 영역 -->
 		<div class="product_list_area">
		    <c:forEach var="display_list" items="${display_list}" varStatus="status">
		    	<c:if test="${display_list.prmtDispzoneNo ne 1}">		
		    	<%--<h3 class="planning_mid_tit">${display_list.dispzoneNm}</h3>--%>
		    	<div class="planning_product_title">
					${display_list.dispzoneNm}
				</div>
	            <c:set var="exhibition_list" value="promotion_display_goods_${display_list.prmtDispzoneNo}" />
	            <c:set var="list" value="${requestScope.get(exhibition_list)}" />
	            <data:goodsList value="${list}" displayTypeCd="01" headYn="Y" iconYn="Y"/>
	            </c:if>
		    </c:forEach>
		</div>
		<!--// 기획전 전시 영역 -->		
		</div>
		</c:if>
		<!--// 기획전 상품목록 -->
	</div>   
    </div>
    <!-- 상품이미지 미리보기 팝업 -->
    <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
        <div id ="goodsPreview"></div>
    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>