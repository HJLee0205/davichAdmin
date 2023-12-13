<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page trimDirectiveWhitespaces="true" %>

<c:set var="_menu" value="${requestScope.get('_DMALL_MENU')}"/>
<c:set var="params" value="${requestScope['javax.servlet.forward.query_string']}"/>

<c:if test="${params ne null}">
    <c:set var="params" value="?${requestScope['javax.servlet.forward.query_string']}"/>
</c:if>
<c:set var="uri" value="${requestScope['javax.servlet.forward.servlet_path']}${params}"/>

<c:set var="glMenuId" value="g_menu1"/>
<c:set var="glCurrent0" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent1" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent2" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent3" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent4" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent5" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent6" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent7" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent8" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent9" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent10" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent11" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent12" value=" class=\"gnb_menu_ttl\""/>
<c:set var="glCurrent13" value=" class=\"gnb_menu_ttl\""/>

<c:set var="uri" value="${requestScope['javax.servlet.forward.servlet_path']}"/>

<c:if test="${uri.startsWith('/admin/seller')}">
    <c:set var="glCurrent8" value=" class=\"gnb_menu_ttl active\""/>
</c:if>
<c:if test="${uri.startsWith('/admin/seller/setup')}">
    <c:set var="glCurrent10" value=" class=\"gnb_menu_ttl active\""/>
</c:if>
<c:if test="${uri.startsWith('/admin/seller/goods')}">
    <c:set var="glCurrent11" value=" class=\"gnb_menu_ttl active\""/>
</c:if>
<c:if test="${uri.startsWith('/admin/seller/order')}">
    <c:set var="glCurrent12" value=" class=\"gnb_menu_ttl active\""/>
</c:if>
<c:if test="${uri.startsWith('/admin/seller/calc')}">
    <c:set var="glCurrent13" value=" class=\"gnb_menu_ttl active\""/>
</c:if>
<sec:authentication property="details.session.authGbCd" var="authGbCd"></sec:authentication>
<c:set var="siteTypeCd" value="${_DMALL_SITE_INFO.siteTypeCd}"/>

<t:putAttribute name="script">

    <link rel="stylesheet" href="/admin/css/ui-jennifer.min.css"/>
    <script type="text/javascript" src="/admin/js/core.js"></script>
    <script type="text/javascript" src="/admin/js/chart.js"></script>
    <script type="text/javascript">

        jQuery(document).ready(function () {
            var $selectedMenu = undefined;

            $('a.gnb_menu_ttl').each(function (idx, obj) {
                if($(obj).hasClass('active')) {
                    $selectedMenu = $(obj);
                }
            });

            jQuery('#site_map_show').off('click').on('click', function (e) {
                Dmall.EventUtil.stopAnchorAction(e);
                if ($('#site_map_contents').css('display') == 'none') {
                    $('#site_map_contents').show();
                    $('#wrapper').css('overflow', 'hidden');

                    if($selectedMenu) $selectedMenu.removeClass('active');

                    $(this).addClass('active');
                    $(this).children('span').text('닫기');
                    $(this).children('img').attr('src', '/admin/img/header/Button-top.png');
                } else {
                    $('#site_map_contents').hide();
                    $('#wrapper').css('overflow', 'inherit');

                    if($selectedMenu) $selectedMenu.addClass('active');

                    $(this).removeClass('active');
                    $(this).children('span').text('전체');
                    $(this).children('img').attr('src', '/admin/img/header/icon_menu_01.png');
                }
            });
        });
    </script>
</t:putAttribute>

<!--- header area ---->
<header id="header">
    <%--<div class="head_top">
        <ul class="top_nav">
            <li><span class="icon_login"></span><a href="javascript:;"><sec:authentication property="details.session.memberNm"></sec:authentication>님</a></li>
            <!-- <li><a href="#">내정보관리</a></li> -->
            <li><a href="https://www.davichmarket.com" target="_blank">내 쇼핑몰 가기</a></li>
            <li><a href="javascript:;" id="a_id_logout">로그아웃</a></li>
        </ul>
        &lt;%&ndash;<div class="top_search">
            <input type="text" placeholder="검색어를 입력하세요"><button type="button" class="btn_search">검색</button>
        </div>&ndash;%&gt;
    </div>--%>
    <div class="head">
        <h1 id="logo">
            <a href="/admin/seller/main/main-view"><img src="/admin/img/header/logo.png" alt="홈으로 이동"></a>
        </h1>
        <nav>
            <c:set var="curMenu" value="0"/>
            <c:set var="isTwoOpen" value="false"/>
            <c:set var="isThreeOpen" value="false"/>
            <c:forEach var="menu" items="${_menu}" varStatus="menuStatus">
            <c:if test="${menuStatus.first}">
                <c:set var="curMenu" value="${menu.menuId}"/>
            <ul class="gnb">
                </c:if>

                <c:set var="menuLength" value="${fn:length(menu.menuId)}"/>
                <c:choose>
                <c:when test="${menuLength eq '2' && menu.menuId eq curMenu}">
                <li class="gnb_menu">
                    <c:set var="url" value="/admin/seller/main/common/menu-redirect?menuId=${menu.menuId}"/>
                    <c:if test="${menu.menuId eq '01'}">
                        <a href="${url}" ${glCurrent0}><span>${menu.menuNm}</span></a>
                    </c:if>
                    <c:if test="${menu.menuId eq '21'}">
                        <a href="${url}" ${glCurrent10}><span>${menu.menuNm}</span></a>
                    </c:if>
                    </c:when>
                    <c:when test="${menuLength eq '2' && menu.menuId ne curMenu}">
                    <c:set var="curMenu" value="${menu.menuId}"/>
                    <c:if test="${isTwoOpen}">
                    <c:set var="isTwoOpen" value="false"/>
                </li>
                </c:if>
                <c:if test="${isThreeOpen}">
                <c:set var="isThreeOpen" value="false"/>
                </li>
            </ul>
            </li>
            </c:if>
            </ul>
            </li>
            <li class="gnb_menu">
                <c:set var="url" value="/admin/seller/main/common/menu-redirect?menuId=${menu.menuId}"/>

                <c:if test="${menu.menuId eq '02'}">
                    <a href="${url}" ${glCurrent1}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '03'}">
                    <a href="${url}" ${glCurrent2}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '05'}">
                    <a href="${url}" ${glCurrent3}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '12'}">
                    <a href="${url}" ${glCurrent4}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '06'}">
                    <a href="${url}" ${glCurrent5}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '07'}">
                    <a href="${url}" ${glCurrent6}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '04'}">
                    <a href="${url}" ${glCurrent7}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '09'}">
                    <a href="${url}" ${glCurrent8}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '08'}">
                    <a href="${url}" ${glCurrent9}><span>${menu.menuNm}</span></a>
                </c:if>

                <c:if test="${menu.menuId eq '22'}">
                    <a href="${url}" ${glCurrent11}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '23'}">
                    <a href="${url}" ${glCurrent12}><span>${menu.menuNm}</span></a>
                </c:if>
                <c:if test="${menu.menuId eq '24'}">
                    <a href="${url}" ${glCurrent13}><span>${menu.menuNm}</span></a>
                </c:if>
                </c:when>
                <c:otherwise>
                <c:choose>
                <c:when test="${menuLength eq '4'}">
                <c:choose>
                <c:when test="${!isTwoOpen}">
                <c:set var="isTwoOpen" value="true"/>
                <ul class="gnb_sub_menu">
                    <li class="gnb_sub_menu_item">
                        <a href="${menu.screenYn eq 'N' ? "#" : menu.url}" class="sub-menu__ttl">${menu.menuNm}</a>
                        </c:when>
                        <c:otherwise>
                        <c:if test="${isThreeOpen}">
                        <c:set var="isThreeOpen" value="false"/>
                    </li>
                </ul>
                </c:if>
            </li>
            <li class="gnb_sub_menu_item">
                <a href="${menu.screenYn eq 'N' ? "#" : menu.url}" class="sub-menu__ttl">${menu.menuNm}</a>
                </c:otherwise>
                </c:choose>
                </c:when>
                <c:when test="${menuLength eq '6'}">
                <c:choose>
                <c:when test="${!isThreeOpen}">
                <c:set var="isThreeOpen" value="true"/>
                <ul class="gnb_sub_menu_list">
                    <li class="sub_menu_link_wrap">
                        <a href="${menu.url}" class="sub-menu__link">${menu.menuNm}</a>
                        </c:when>
                        <c:otherwise>
                    </li>
                    <li class="sub_menu_link_wrap">
                        <a href="${menu.url}" class="sub-menu__link">${menu.menuNm}</a>
                        </c:otherwise>
                        </c:choose>
                        </c:when>
                        </c:choose>
                        </c:otherwise>
                        </c:choose>
                        <c:if test="${menuStatus.last}">
                        <c:if test="${isTwoOpen}">
                        <c:set var="isTwoOpen" value="false"/>
                    </li>
                </ul>
                </c:if>
                <c:if test="${isThreeOpen}">
                <c:set var="isThreeOpen" value="false"/>
            </li>
            </ul>
            </c:if>
            </li>
            <li class="gnb_menu all">
                <a href="#" class="gnb_menu_ttl all" id="site_map_show"><span>전체</span><img class="gnb__all-btn" src="/admin/img/header/icon_menu_01.png" alt="all button"></a>
                <div class="gnb__all-menu all" id="site_map_contents">
                        <c:set var="isTwoOpen" value="false"/>
                        <c:set var="isThreeOpen" value="false"/>
                    <c:forEach var="menu" items="${_menu}" varStatus="menuStatus">
                    <c:if test="${menuStatus.first}">
                        <c:set var="curMenu" value="${menu.menuId}"/>
                    <ul class="all__inner">
                        </c:if>

                        <c:set var="menuLength" value="${fn:length(menu.menuId)}"/>
                        <c:choose>
                        <c:when test="${menuLength eq '2' && menu.menuId eq curMenu}">
                        <li class="all__menu">
                            <a href="#" class="all__main-link all__main-link--first">${menu.menuNm}</a>
                            <ul class="all__sub-menu all__sub-menu--first all-sub-menu">
                                </c:when>
                                <c:when test="${menuLength eq '2' && menu.menuId ne curMenu}">
                                <c:set var="curMenu" value="${menu.menuId}"/>
                                <c:if test="${isThreeOpen}">
                                <c:set var="isThreeOpen" value="false"/>
                                </li>
                            </ul>
                        </li>
                        </c:if>
                        <c:if test="${isTwoOpen}">
                            <c:set var="isTwoOpen" value="false"/>
                            </li>
                        </c:if>
                    </ul>
            </li>
            <li class="all__menu">
                <a href="#" class="all__main-link all__main-link--first">${menu.menuNm}</a>
                <ul class="all__sub-menu all__sub-menu--first all-sub-menu">
                    </c:when>
                    <c:otherwise>
                    <c:choose>
                    <c:when test="${menuLength eq '4'}">
                    <c:choose>
                    <c:when test="${!isTwoOpen}">
                    <c:set var="isTwoOpen" value="true"/>
                    <li class="all-sub-menu__item">
                        <a href="${menu.screenYn eq 'N' ? "#" : menu.url}" class="all-sub-menu__ttl">${menu.menuNm}</a>
                        </c:when>
                        <c:otherwise>
                        <c:if test="${isThreeOpen}">
                        <c:set var="isThreeOpen" value="false"/>
                    </li>
                </ul>
                </c:if>
            </li>
            <li class="all-sub-menu__item">
                <a href="${menu.screenYn eq 'N' ? "#" : menu.url}" class="all-sub-menu__ttl">${menu.menuNm}</a>
                </c:otherwise>
                </c:choose>
                </c:when>
                <c:when test="${menuLength eq '6'}">
                <c:choose>
                <c:when test="${!isThreeOpen}">
                <c:set var="isThreeOpen" value="true"/>
                <ul class="all-sub-menu__list">
                    <li class="all-sub-menu__link-wrap">
                        <a href="${menu.url}" class="all-sub-menu__link">${menu.menuNm}</a>
                        </c:when>
                        <c:otherwise>
                    </li>
                    <li class="all-sub-menu__link-wrap">
                        <a href="${menu.url}" class="all-sub-menu__link">${menu.menuNm}</a>
                        </c:otherwise>
                        </c:choose>
                        </c:when>
                        </c:choose>
                        </c:otherwise>
                        </c:choose>

                        <c:if test="${menuStatus.last}">
                        <c:if test="${isThreeOpen}">
                        <c:set var="isThreeOpen" value="false"/>
                    </li>
                </ul>
                </c:if>
                <c:if test="${isTwoOpen}">
                <c:set var="isTwoOpen" value="false"/>
            </li>
            </ul>
            </c:if>
            </li>
            </c:if>
            </c:forEach>
    </div>
    </li>
    </ul>
    </c:if>
    </c:forEach>

    <div class="user">
        <c:set var="url" value="https://www.davichmarket.com"/>
        <a href="${url}" class="user_page" target="_blank">쇼핑몰 바로가기</a>
        <div class="user_nav">
            <button class="user_btn" ><img src="/admin/img/header/user_basic.png" alt=""/></button>
            <ul class="user_items_wrap">
                <li class="user_items">
                    <img class="user_icon" src="/admin/img/header/user_icon.png" alt="" >
                    <span class="ml10 mr20"><sec:authentication property="details.session.sellerNm"></sec:authentication>님</span>
                </li>
                <li class="user_items">
                    <img src="/admin/img/header/user_logout.png" alt="" >
                    <button class="user_btn" ><span class="ml10 logout_span" id="a_id_logout">로그아웃</span></button>
                </li>
            </ul>
        </div>
    </div>
    </nav>
    </div>

</header>
<!---// header area ---->