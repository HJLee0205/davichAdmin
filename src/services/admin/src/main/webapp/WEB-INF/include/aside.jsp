<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="_sub_menu" value="${requestScope.get('_DMALL_SUB_MENU_AUTH')}"/>
<c:set var="params" value="${requestScope['javax.servlet.forward.query_string']}"/>
<c:if test="${params ne null}">
    <c:set var="params" value="?${requestScope['javax.servlet.forward.query_string']}"/>
</c:if>
<c:set var="uri" value="${requestScope['javax.servlet.forward.servlet_path']}${params}"/>

<!--- snb 메뉴 area ---->
<div id="snb" class="snb_menu">
    <c:if test="${_sub_menu.size() gt 0}">
        <div class="snb_tit tit02">
            ${_sub_menu.get(0).menuNm} 설정
        </div>

        <c:set var="isTwoOpen" value="false"/>
        <c:set var="isThreeOpen" value="false"/>
        <c:forEach var="subMenu" items="${_sub_menu}" varStatus="subMenuStatus">
            <c:set var="Current" value="" />
            <c:if test="${uri eq subMenu.url}">
                <c:set var="Current" value=" class=\"active\"" />
            </c:if>

            <c:if test="${subMenuStatus.first}">
                <ul>
            </c:if>

            <c:set var="menuLength" value="${fn:length(subMenu.menuId)}"/>
            <c:choose>
                <c:when test="${menuLength eq '4'}">
                    <c:choose>
                        <c:when test="${subMenu.screenYn eq 'N'}">
                            <c:if test="${isThreeOpen}">
                                    </li>
                                </ul>
                                <c:set var="isThreeOpen" value="false"/>
                            </c:if>
                            <c:if test="${isTwoOpen}">
                                </li>
                                <c:set var="isTwoOpen" value="false"/>
                            </c:if>
                            <li>
                                <a href="#none">${subMenu.menuNm}</a>
                                    <ul class="snb_2depth">
                            <c:set var="isTwoOpen" value="true"/>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${isThreeOpen}">
                                    </li>
                                </ul>
                                <c:set var="isThreeOpen" value="false"/>
                            </c:if>
                            <c:if test="${isTwoOpen}">
                                </li>
                                <c:set var="isTwoOpen" value="false"/>
                            </c:if>
                            <li>
                                <a href="${subMenu.url}" ${Current}>${subMenu.menuNm}</a>
                            <c:set var="isTwoOpen" value="true"/>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${menuLength eq '6'}">
                    <c:if test="${isThreeOpen}">
                        </li>
                        <c:set var="isThreeOpen" value="false"/>
                    </c:if>
                    <li>
                        <a href="${subMenu.url}" ${Current}>${subMenu.menuNm}</a>
                    <c:set var="isThreeOpen" value="true"/>
                </c:when>
            </c:choose>

            <c:if test="${subMenuStatus.last}">
                </ul>
            </c:if>
        </c:forEach>
    </c:if>
    <div class="copyright">COPYRIGHT (C) 2022. DAVICH OPTICAL. All RIGHTS RESERVED.</div>
</div>
<!--- //lnb 메뉴 area ---->
