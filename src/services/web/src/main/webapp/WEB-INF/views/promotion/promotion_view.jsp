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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${resultModel.data.prmtNm}</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    function otherPromotion(){
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
    }
    $(document).ready(function(){
        //$('#promotionDetailBanner').html($('#tempContentHtml').val());
        $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>기획전
            </div>
        </div>
        <!---// category header --->
        <form:form id="form_id_search" commandName="so" >
        <form:hidden path="page" id="page"/>
        <form:hidden path="prmtNo" id="prmtNo"/>
        <form:hidden path="prmtStatusCd" id="prmtStatusCd" />
        </form:form>
        <h2 class="sub_title">기획전<span>믿을 수 있는 쇼핑! 더 안전한 쇼핑!</span></h2>
        <div class="promotion">
            <div class="promotion_detail_top">
                <div class="select_box28" style="display:inline-block">
                    <label for="select_option">다른 기획전 보기</label>
                    <select class="select_option" name="otherPromotion" id="otherPromotion" title="select option" onchange="otherPromotion();">
                        <option selected="selected" value="">다른 기획전 보기</option>
                        <c:forEach var="exhibitionList" items="${exhibition_list.resultList}" varStatus="status">
                        <option value="${exhibitionList.prmtNo}">${exhibitionList.prmtNm}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <!--- 기획전 배너 --->
            <%-- <input type="hidden" id="tempContentHtml" value="${resultModel.data.prmtContentHtml}"/> --%>
            <div id="promotionDetailBanner" class="promotion_detail_banner">
                ${resultModel.data.prmtContentHtml}
            </div>
            <!--- 기획전 배너 --->
            <!--- 상품리스트 --->
            <c:if test="${resultListModel.resultList ne null}">
                <data:goodsList value="${resultListModel.resultList}" displayTypeCd="02" headYn="Y" iconYn="N"/>
            </c:if>
            <!---- 페이징 ---->
            <div class="tPages" id="div_id_paging">
                <grid:paging resultListModel="${resultListModel}" />
            </div>
            <!----// 페이징 ---->
        </div>
    </div>
    <!-- 상품이미지 미리보기 팝업 -->
    <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
        <div id ="goodsPreview"></div>
    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>