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
    <t:putAttribute name="title">기획전</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
        ajaxPromotionList('02');
    });
    function clickTab(idx){
        $('#page').val("1");
        ajaxPromotionList(idx)
    }
    function ajaxPromotionList(idx){
        $('#prmtStatusCd').val(idx);
        var param = $('#form_id_search').serialize();
        if(param == '') {
            param = 'prmtStatusCd=02';
        }
        var url = '${_MOBILE_PATH}/front/promotion/promotion-list-ajax?'+param;
        Dmall.AjaxUtil.load(url, function(result) {
            $('#id_PromotionList').html(result);
        })
    }

    function detailPromotion(idx){
        $('#prmtNo').val(idx);
        var data = $('#form_id_search').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
            param[obj.name] = obj.value;
        });
        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/promotion/promotion-detail?prmtNo='+$('#prmtNo').val(), param);
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
   	 <div id="middle_area">	
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			기획전
		</div>
		<ul class="promotion_list" id="id_PromotionList">
		</ul>
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