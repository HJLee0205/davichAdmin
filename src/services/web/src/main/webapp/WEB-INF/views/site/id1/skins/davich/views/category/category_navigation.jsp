<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="category_header">
    <div id="category_location">
        <ul class="category_menu">
            <li><a href="/front/main-view">홈</a></li>
            <c:forEach var="navigationList" items="${navigation}" varStatus="status">
            <li>
                <a href="javascript:;" class="btn_category_${navigationList.ctgLvl+1}depth">
                    ${navigationList.ctgNm}
                <i></i></a>
                <ul class="category_${navigationList.ctgLvl+1}depth" style="display: none;">
                    <li class="top"></li>
                <c:forEach var="ctgList1" items="${lnb_info.get(navigationList.upCtgNo)}" varStatus="status1">
                    <li><a href="javascript:move_category('${ctgList1.ctgNo}')">${ctgList1.ctgNm}</a></li>
                </c:forEach>
                </ul>
            </li>
            </c:forEach>
        </ul>
    </div>
    <div class="location_btn_area">
    	<c:set var="lensType" value="G"/>
    	<c:if test="${goodsInfo.data.goodsTypeCd eq '04' || so.filterTypeCd eq '04'}">
    		<c:set var="lensType" value="C"/>
    	</c:if>
        <button type="button" class="btn_recomm" data-lensType="${lensType }"><i></i>렌즈추천</button>
<c:if test="${site_info.contsUseYn eq 'Y'}">
        <button type="button" class="btn_share" style="display:none;">공유</button>
        <!-- 레이어 공유하기 선택 -->
        <div class="layer_share" style="display: none;">
            <div class="head">
                공유하기
                <button type="button" class="btn_close_share"></button>
            </div>
            <div class="btn">
                <button type="button" class="btn_sharea_fbook" onclick="javascript:jsShareFacebook();">페이스북</button>
                <button type="button" class="btn_sharea_kakao" onclick="javascript:jsShareKastory();">카카오스토리</button>
            </div>
        </div>
</c:if>
        <!--// 레이어 공유하기 선택 -->
    </div>
</div>
