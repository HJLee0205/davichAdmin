<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-05-17
  Time: 오후 4:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">
	$(document).ready(function(){
		$('.main_visual_slider').bxSlider({
			auto: true
		});
		$().UItoTop({ easingType: 'easeOutQuart' });
	
       $('#move_interest').off('click').on('click',function(){
    	   	var menu = new Menu();
    	   	menu.close();
			move_interest();
       });
	
	   $('#a_id_logout_left').on('click', function(e) {
	        Dmall.EventUtil.stopAnchorAction(e);
	        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/login/logout', {});
	   });
		
		/* === menu all_gnb === */
		$( ".site_nav_list_s" ).hide();
		$("div.site_nav_list .icon_arrow").click(function () {
			var arrow = $(this);
			if(arrow.hasClass('active')){ 
				arrow.removeClass('active');
			}else{
				arrow.addClass('active');
			}
			$(this).parents('.site_nav_list').next( ".site_nav_list_s" ).slideToggle( "slow");
		});
	});	

	
	
</script>

<nav id="c-menu--slide-left" class="c-menu c-menu--slide-left">
	<button class="c-menu__close"></button>
	<div class="site-nav-scrollable-container">
		<ul class="site_nav_top">
			<sec:authorize access="!hasRole('ROLE_USER')">
			<li><a href="${_MOBILE_PATH}/front/member/terms-apply" class="menu01"><span class="icon_menu_01"></span>회원가입</a></li>
			<li><a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/login/member-login" class="menu01"><span class="icon_menu_02"></span>로그인</a></li>
			</sec:authorize>
			<sec:authorize access="hasRole('ROLE_USER')">
			<li></li>
			<li style="width:100%" id="a_id_logout_left"><a href="#" class="menu01"><span class="icon_menu_02_02"></span>로그아웃</a></li>
			</sec:authorize>
			<li id="move_mypage">
				<a href="#1" class="menu02">
					<span class="icon_menu_03"></span>
					마이페이지
				</a>
			</li>
			<li id="move_interest">
				<a href="#" class="menu02">
					<span class="icon_menu_04"></span>
					관심상품
				</a> 
			
			</li>
		</ul>
		<c:forEach var="ctgList" items="${gnb_info.get('0')}" varStatus="status">
		<div class="site_nav_list" style="padding-bottom: 8px;<c:if test="${status.last }">border-bottom: 1px solid #bebfc1; </c:if>">
			
			<a href="#gnb0${ctgList.ctgNo}" onclick="javascript:move_category('${ctgList.ctgNo}');return false;" style="display: initial">${ctgList.ctgNm}</a>
			<div style="float: right;padding: 10px 15px 0 0;">
			<span class="icon_arrow" style="cursor: pointer;"></span>
			</div>
			<!-- <a href="#1"><span class="icon_arrow"></span></a> -->
			
		</div> 
		<ul id="gnb0${ctgList.ctgNo}" class="site_nav_list_s">
			<c:forEach var="ctgList2" items="${gnb_info.get(ctgList.ctgNo)}" varStatus="status1">
				<li <c:if test="${status1.last }">style='border-bottom: 1px solid #bebfc1;' </c:if>>
					<a href="javascript:move_category('${ctgList2.ctgNo}')">${ctgList2.ctgNm}</a>
				</li>
			</c:forEach>
		   <!-- <li><a href="#">- 쌀/잡곡</a></li>
				<li><a href="#">- 과일/견과</a></li>
				<li><a href="#">- 채소/산나물</a></li> -->
		</ul>
		</c:forEach>
		<div class="site_gnb_list">
            <a href="#">
                고객센터
                <div style="float: right;padding: 10px 10px 0 0;">
                <span class="icon_arrow" style="cursor: pointer;"></span>
                </div>
            </a>
            
        </div>
        <ul class="site_gnb_list_s" style="display: none;">
            <li><a href="javascript:move_page('notice');">- 공지사항</a></li>
            <li><a href="javascript:move_page('faq');">- 자주찾는 질문</a></li>
            <li>
                <a href="javascript:move_page('inquiry');">- 1:1문의</a>
            </li>
        </ul>
        
        <div class="site_gnb_menu">
            <a href="/m/front/event/event-list">
                이벤트
                <span class="icon_go_detail"></span>
            </a>
        </div>
        <div class="site_gnb_menu" style="border-bottom:1px solid #bebfc1">
            <a href="/m/front/promotion/promotion-list">
                기획전
                <span class="icon_go_detail"></span>
            </a>
        </div>
    </div>
</nav>


<div id="c-mask" class="c-mask"></div><!-- slide menu c-mask -->

