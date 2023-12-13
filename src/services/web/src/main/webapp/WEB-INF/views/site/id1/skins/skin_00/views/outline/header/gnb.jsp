<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<ul class="gnb_list">
    <c:forEach var="ctgList" items="${gnb_info.get('0')}" varStatus="status">
        <li>
            <a href="#gnb0${ctgList.ctgNo}" onclick="move_category('${ctgList.ctgNo}');return false;">
            <c:if test="${ctgList.ctgExhbtionTypeCd eq 1}">
            ${ctgList.ctgNm}
            </c:if>
            <c:if test="${ctgList.ctgExhbtionTypeCd eq 2}">
                <img src="/image/image-view?type=CATEGORY&id1=${ctgList.ctgImgPath}_${ctgList.ctgImgNm}" <c:if test="${!empty ctgList.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${ctgList.mouseoverImgPath}_${ctgList.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${ctgList.ctgImgPath}_${ctgList.ctgImgNm}'"</c:if>/>
            </c:if>
            </a>
            <c:if test="${fn:length(gnb_info.get(ctgList.ctgNo)) > 0}">
                <div id="gnb0${ctgList.ctgNo}" class="gnb_2depth_layer">
                    <ul class="gnb_2depth_menu">
                    <c:forEach var="ctgList2" items="${gnb_info.get(ctgList.ctgNo)}" varStatus="status1">
                        <li>
                        <a href="javascript:move_category('${ctgList2.ctgNo}')">
                        <c:if test="${ctgList2.ctgExhbtionTypeCd eq 1}">
                        ${ctgList2.ctgNm}
                        </c:if>
                        <c:if test="${ctgList2.ctgExhbtionTypeCd eq 2}">
                            <img src="/image/image-view?type=CATEGORY&id1=${ctgList2.ctgImgPath}_${ctgList2.ctgImgNm}" <c:if test="${!empty ctgList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${ctgList2.mouseoverImgPath}_${ctgList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${ctgList2.ctgImgPath}_${ctgList2.ctgImgNm}'"</c:if>/>
                        </c:if>
                        </a>
                        </li>
                    </c:forEach>
                    </ul>
                </div>
            </c:if>
        </li>
    </c:forEach>
</ul>