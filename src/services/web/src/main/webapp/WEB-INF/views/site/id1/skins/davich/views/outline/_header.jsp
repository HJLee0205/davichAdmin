<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!--- 00.LAYOUT: HEADER AREA --->

<!-- head banner area -->
<c:if test="${fn:length(top_banner.resultList)>0}">
	<div class="head_banner_area" style="background:<c:out value="${!empty(top_banner.resultList[0].topBannerColorValue) && top_banner.resultList[0].topBannerColorValue ne '' ? top_banner.resultList[0].topBannerColorValue : '#1e318d'}"/>"> <!-- 백그라운드 칼라 배너별 설정가능 하도록 -->
		<div class="inner">
			<button type="button" class="btn_close_tbanner" style="z-index:1000">창닫기</button>
			<a href="javascript:click_banner('${top_banner.resultList[0].dispLinkCd}','${top_banner.resultList[0].linkUrl}');">
				<%-- <img src="${_SKIN_IMG_PATH}/header/head_banner01.gif" alt=""> --%>
				<img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${top_banner.resultList[0].imgFileInfo}" alt="${top_banner.resultList[0].bannerNm}" title="${top_banner.resultList[0].bannerNm}">
			</a>
		</div>
	</div>
</c:if>
<!--// head banner area -->

<div id="header">
    <%@ include file="header/utility_menu.jsp" %>
    <%--<div class="logo_area">
        <div class="logo_area_layout">--%>
            <%@ include file="header/logo.jsp"%>
            <%@ include file="header/search.jsp"%>

            <%@ include file="header/top_menu.jsp"%>
        <%--</div>
    </div>--%>

</div>
<!---// 00.LAYOUT: HEADER AREA --->
<!--- 01.LAYOUT: GNB AREA --->
    <%@ include file="header/gnb.jsp"%>
<!---// 01.LAYOUT: GNB AREA --->