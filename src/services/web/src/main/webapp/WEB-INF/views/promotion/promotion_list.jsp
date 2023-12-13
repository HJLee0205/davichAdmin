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
<t:insertDefinition name="defaultLayout">
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
        var url = '/front/promotion/promotion-list-ajax?'+param;
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
        Dmall.FormUtil.submit('/front/promotion/promotion-detail', param);
    }
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
        <h2 class="sub_title">기획전<span>믿을 수 있는 쇼핑! 더 안전한 쇼핑!</span></h2>
        <ul class="tabs">
            <li class="active" onclick="clickTab('02');">진행중인 기획전</li>
            <li onclick="clickTab('03');">지난 기획전</li>
        </ul>
        <div id="id_PromotionList"></div>
    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>