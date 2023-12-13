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
    <t:putAttribute name="title">${resultModel.data.prmtNm}</t:putAttribute>
    
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    /* function otherPromotion(){
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
    } */
    /* 쿠폰 건별 발급 */
    function issueCoupon(couponNo) {

        var url = '${_MOBILE_PATH}/front/coupon/coupon-issue';
        var param = {couponNo:couponNo};

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                	Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
                        //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                        function() {
                			location.href= "${_MOBILE_PATH}/front/coupon/coupon-list";
            			},'','','','닫기','마이페이지'
                    );
            }
        });
    }
    $(document).ready(function(){
        //$('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
        
        $('.select_planning').on('change', function(){
        	var prmNo = $('#otherPromotion option:selected').val();
            if(prmNo != ''){
                $("#prmtNo").val($('#otherPromotion option:selected').val());
                var data = $('#form_id_search').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('${_MOBILE_PATH}/front/promotion/promotion-detail', param);
            }
        });
        
        $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
          	var prmtNo = $('#prmtNo').val();
          	var prmtStatusCd = $('#prmtStatusCd').val();
     		var url = '${_MOBILE_PATH}/front/promotion/ajax-promotion?prmtNo='+prmtNo+'&prmtStatusCd='+prmtStatusCd+'&'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if('${so.totalPageCount}'==pageIndex){
		        	$('#div_id_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('.product_list_typeB').append(result);
	        })
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
    <div class="middle_area">
    	<form name="visitForm" id="visitForm">
    	<input type="hidden" name="refererType" value="${refererType}"/>
		</form>
    	<form:form id="form_id_search" commandName="so" >
        <form:hidden path="page" id="page"/>
        <form:hidden path="prmtNo" id="prmtNo"/>
        <form:hidden path="prmtStatusCd" id="prmtStatusCd" />    	
   		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			기획전
		</div>
		<div class="cont_body">
			<div class="planning_top_area">
				<select class="select_planning" name="otherPromotion" id="otherPromotion" title="select option" style="width:100%;">
					<option selected="selected" value="">다른 기획전 보기</option>
					<c:forEach var="exhibitionList" items="${exhibition_list.resultList}" varStatus="status">
					<option value="${exhibitionList.prmtNo}">${exhibitionList.prmtNm}</option>
					</c:forEach>
				</select>
			</div>
			<%--<fmt:parseDate value='${resultModel.data.applyStartDttm}' var='applyStartDttm' pattern='yyyyMMddHHmmss'/>
			<fmt:parseDate value='${resultModel.data.applyEndDttm}' var='applyEndDttm' pattern='yyyyMMddHHmmss'/>--%>

			<div style="background-color: #f2f6f7;text-align: center;padding:9px 0;color: #000">
				기획전 기간 : ${fn:substring(resultModel.data.applyStartDttm, 0, 4)}.${fn:substring(resultModel.data.applyStartDttm, 4, 6)}.${fn:substring(resultModel.data.applyStartDttm, 6, 8)}
		                   ~ ${fn:substring(resultModel.data.applyEndDttm, 0, 4)}.${fn:substring(resultModel.data.applyEndDttm, 4, 6)}.${fn:substring(resultModel.data.applyEndDttm, 6, 8)}</div>
			<div class="promotion_detail_banner">
				<%-- <img src="http://www.davichmarket.com/image/image-view?type=PROMOTION&path=${resultModel.prmtMobileBannerImgPath}&id1=${resultModel.data.prmtMobileBannerImg}" title="${resultModel.data.prmtNm}" onerror="this.src='../img/promotion/promotion_ing01.jpg'"> --%>
				${resultModel.data.prmtContentHtml}
			</div>
		</div><!-- //cont_body -->
		<div class="promotion_list_wrap">
			<!-- <h2 class="promotion_stit">
				<span>기획전 상품</span>
			</h2> -->
			<!-- 상품정보영역 -->
			<%--<c:forEach var="display_list" items="${display_list}" varStatus="status">
			<c:if test="${display_list.prmtDispzoneNo eq 1}">		
			<h3 class="planning_mid_tit">주목할 상품</h3>
				<ul class="product_list_typeB floatC marginT0">
					<c:set var="exhibition_list" value="promotion_display_goods_${display_list.prmtDispzoneNo}" />
					<c:set var="list" value="${requestScope.get(exhibition_list)}" />
					<data:goodsList value="${list}" displayTypeCd="05" headYn="N" iconYn="Y"/>				
				</ul>
			</c:if>
			</c:forEach>	--%>
			<!-- // 상품정보영역 -->
			<c:choose>
			   <c:when test="${display_list ne null}">
				<c:forEach var="display_list" items="${display_list}" varStatus="status">
				<c:if test="${display_list.prmtDispzoneNo ne 1}">		
					<h3 class="planning_mid_tit">${display_list.dispzoneNm}</h3>
					<ul class="product_list_typeB floatC marginT0">
						<c:set var="exhibition_list" value="promotion_display_goods_${display_list.prmtDispzoneNo}" />
						<c:set var="list" value="${requestScope.get(exhibition_list)}" />
						<data:goodsList value="${list}" displayTypeCd="05" headYn="N" iconYn="N"/>				
					</ul>
				</c:if>
				</c:forEach>	
			   </c:when>
			   <c:otherwise>
					   <p style="text-align: center;">등록된 상품이 없습니다.</p>
			   </c:otherwise>
			</c:choose>
			</form:form>
		</div>
		<!-- 예약바로가기 20200706 -->
		<c:if test="${user.login}">
		<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-book" class="btn_go_reservation">
		</c:if>
		<c:if test="${!user.login}">
		<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-welcome" class="btn_go_reservation">
		</c:if>
		${storeTotCnt}개 매장예약
		</a>
		<!--// 예약바로가기 20200706 -->
    </t:putAttribute>
</t:insertDefinition>