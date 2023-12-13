<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-05-17
  Time: 오후 4:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">
$(document).ready(function(){
	$('#move_cart_top').on('click',function(){
         location.href = "${_MOBILE_PATH}/front/basket/basket-list"
    });
	
});	
</script>

	<div id="header">
		<div id="head">			
			<div class="logo_area">
				<div class="head_left_btn">					
					<button id="c-button--slide-left" class="c-button btn_allmenu"><span class="icon_menu"></span></button>
					<button type="button" class="btn_search_view"><span class="icon_search"></span></button>
				</div>
				<!-- <div id="logo">
					<h1><a href=""><img src="../inc/skin/basic/img/main/logo.png" alt="Danvi"></a></h1>
				</div> -->
				<!--- logo --->
	            <%@ include file="header/logo.jsp"%>
	            <!---// logo --->
				<div class="head_right_btn">
					<button type="button" class="btn_cart"  id="move_cart_top">
						<!-- <span class="cart_no">153</span> -->
						<span class="icon_cart" ></span>
					</button>
				<sec:authorize access="!hasRole('ROLE_USER')">
				<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/login/member-login" class="menu01"><button type="button" class="btn_login"><span class="icon_login"></span></button></a></li>
				</sec:authorize>
				<sec:authorize access="hasRole('ROLE_USER')">
				<button type="button" class="btn_login" id="a_id_logout"><span class="icon_logout"></span></button></a>
				</sec:authorize>
				</div>
			</div>
		</div>
		<div id="search_area">
			<input type="text" id="searchText" onkeydown="if(event.keyCode == 13){$('#btn_search').click();}" style="width:calc(98% - 50px);">
			<button type="button" class="btn_search"  id="btn_search"><span class="icon_search02"></span></button>
		</div>
	</div>
	
<!-- slide menu script -->
<script> 
  var slideLeft = new Menu({
    wrapper: '#o-wrapper',
    type: 'slide-left',
    menuOpenerClass: '.c-button',
    maskId: '#c-mask'
  });
  var slideLeftBtn = document.querySelector('#c-button--slide-left');  
  slideLeftBtn.addEventListener('click', function(e) {
    e.preventDefault;
    slideLeft.open();
  });
</script>
<!--// slide menu script -->
