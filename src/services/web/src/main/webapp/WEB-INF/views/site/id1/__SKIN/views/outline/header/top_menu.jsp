<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--- theme shop --->
<ul class="theme_list">

    <c:if test="${site_info.bbsCnt gt 0}">
    <%--<li><a href="/front/community/board-list">커뮤니티</a></li>--%>
    </c:if>
    <!-- <li><a href="/front/brand-category">브랜드관</a></li> -->
    <li><a href="/front/coupon/coupon-zone"><i class="icon_zone" id="coupon_count">%</i>D-쿠폰</a></li>
	<li><a href="/front/promotion/promotion-list"><i class="icon_promo"></i>기획전</a></li>
    <li><a href="/front/event/event-list"><i class="icon_event"></i>이벤트</a></li>
    <%--<li><a href="javascript:;" onclick="move_category('5');return false;" class="btn_hearing_aid">보청기</a></li>--%>
    <li><a href="https://www.davichhearing.com/" target="_blank" class="btn_hearing_aid">보청기</a></li>
    
</ul>
<!---// theme menu --->