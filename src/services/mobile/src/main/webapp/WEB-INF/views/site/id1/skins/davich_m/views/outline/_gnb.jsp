<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<script type="text/javascript">
	$(document).ready(function(){

		$().UItoTop({ easingType: 'easeOutQuart' });
	
		// 모바일웹에서 설정 아이콘 숨김
		if(!isAndroidWebview() && !isIOSWebview()){
            $('.menu_setting').hide();
        }
        
       $('#move_interest').off('click').on('click',function(){
    	   	var menu = new Menu();
    	   	menu.close();
			move_interest();
       });
       
       $('#move_coupon').off('click').on('click',function(){
    	   move_coupon();
       });
       
       $('#move_delivery').off('click').on('click',function(){
    	   move_delivery();
       });
       
       $('#move_dmoney').off('click').on('click',function(){
    	   move_dmoney();
       });

	   $('#a_id_logout_left').on('click', function(e) {
	        Dmall.EventUtil.stopAnchorAction(e);
	        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/login/logout', {});
	   });
		
		/* === menu all_gnb === */

        $( ".site_nav_list_s" ).hide();
		$("div.site_nav_list .icon_arrow").click(function () {
			var arrow = $(this).parent();
			if(arrow.hasClass('active')){
				arrow.removeClass('active');
			}else{
				arrow.addClass('active');
			}
			$(this).parent().next( ".site_nav_list_s" ).slideToggle();
		});

		$( ".site_nav_list_s02" ).hide();
		$( ".site_nav_list_s02 > ul" ).hide();
		$("div.site_nav_list02 .icon_arrow").click(function () {
			var arrow = $(this).parent();
			if(arrow.hasClass('active')){ 
				arrow.removeClass('active');
			}else{
				arrow.addClass('active');
			}
			$(".site_nav_list_s02" ).slideToggle();
		});
		$(".btn_view_glass .icon_arrow").click(function () {
			var arrow = $(this).parent();
			if(arrow.hasClass('active')){ 
				arrow.removeClass('active');
			}else{
				arrow.addClass('active');
			}
			$(this).parent().next( "ul" ).slideToggle();
		})

		/*$( ".site_nav_list_s" ).hide();
		$("div.site_nav_list .icon_arrow").click(function () {
			var arrow = $(this);
			if(arrow.hasClass('active')){ 
				arrow.removeClass('active');
			}else{
				arrow.addClass('active');
			}
			$(this).parents('.site_nav_list').next( ".site_nav_list_s" ).slideToggle( "slow");
		});*/

        //장바구니 카운트 조회
        var url = '${_MOBILE_PATH}/front/member/quick-info';
        Dmall.AjaxUtil.getJSON(url, '', function (result) {
            if (result.success) {
                $("#move_cart .cart_won").html(result.data.basketCnt);//장바구니갯수
                $("#footer-menu .cart_won").html(result.data.basketCnt);//장바구니갯수
                $("#move_interest .cart_won").html(result.data.interestCnt);//관심상품갯수
                if(result.data.cpCnt != null && result.data.cpCnt > 0){
                	$('#coupon_count').html(result.data.cpCnt);	//쿠폰갯수
                }
            }
        });
        
	});	

	function appSettings(){
	    if(loginYn != 'true') {
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    location.href= "${_MOBILE_PATH}/front/login/member-login"
                },'');
        }
		
	    if(loginYn == 'true') {
			if (isAndroidWebview()) {
			   davichapp.bridge_go_setting();
			}
			
			if (isIOSWebview()) {
			   window.webkit.messageHandlers.davichapp.postMessage({
			       func: 'bridge_go_setting',
			   });
			}		
        }
	}
	
	function isAndroidWebview() {
	   return (navigator.userAgent.indexOf("davich_android")) > 0;
	}

	function isIOSWebview() {
	   return (navigator.userAgent.indexOf("davich_ios")) > 0;
	}
	
	var integration_gnb = "${user.session.integrationMemberGbCd}";
	function fn_go_point_gnb(){
	    if(loginYn == 'true') {
		   	if(integration_gnb == '03'){
		   		location.href = "${_MOBILE_PATH}/front/member/point";
		   	}
		   	else if(integration_gnb == '01'){
		   		Dmall.LayerUtil.confirm('통합멤버쉽 회원만 이용하실 수 있습니다.<br>지금 멤버쉽 통합절차를 진행할까요?', function() {
		               location.href="${_MOBILE_PATH}/front/member/member-integration-form";
		           });
		           
		   	}
		   	else if(integration_gnb == '02'){
		   		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
		               location.href="${_MOBILE_PATH}/front/member/information-update-form";
		           });
		   	}
	    }else{
	        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
	        function() {
	            location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
	        },'');
	    }
	}
	
</script>

<div id="c-menu--slide-left" class="c-menu c-menu--slide-left" style="display: none;">	
	<button class="c-menu__close">전체메뉴 닫기</button>
	<div class="inner">
		<div class="all_menu">
			<div class="login_area">
				<sec:authorize access="!hasRole('ROLE_USER')">
				<span class="text">로그인해주세요!</span>
				<a href="${_MOBILE_PATH}/front/member/terms-apply" class="menu01">회원가입</a>
				<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/login/member-login" class="menu02">로그인</a>
				</sec:authorize>
				<sec:authorize access="hasRole('ROLE_USER')">
					<p style="color:#fff;display:inline-block;margin-left:10px;">
					<span style="text-overflow: ellipsis;max-width: 82px;display: inline-block;white-space: nowrap;overflow: hidden;vertical-align: -7px;">
					${user.session.memberNm} 님
					</span>
					</p>
					<a href="javascript:;" id="a_id_logout_left" class="menu03">로그아웃</a>
				</sec:authorize>
				<div class="login_area_right">
					<a href="${_MOBILE_PATH}/front/member/push-message-market" class="menu_message">메세지함</a>
					<a href="javascript:appSettings();" class="menu_setting">설정</a>
				</div>
			</div>
			<ul class="menu_head">
				<li id="move_cart"><a href="#" class="menu02"><i class="icon01"><em class="cart_won"></em></i>장바구니</a></li>
				<li id="move_delivery"><a href="#"><i class="icon02"></i>주문배송조회</a></li>
				<li id="move_interest"><a href="#" class="menu03"><i class="icon03"><em class="cart_won"></em></i>관심상품</a></li>
				<li id="move_mypage"><a href="#" class="menu01"><i class="icon04"></i>마이페이지</a></li>
			</ul>
			<div class="menu_second">
				<a href="#" id="move_coupon"><i class="icon01"></i>D-쿠폰</a>
				<%--<a href="#" id="move_dmoney"><i class="icon02"></i>마켓포인트</a>	--%>
				<a href="javascript:fn_go_point_gnb();"><i class="icon03"></i>다비치포인트</a>				
			</div>
			
			<!-- <div class="site_nav_list">
				<a href="javascript:;">EASY PICK!</a><i class="icon_arrow">화살표</i>
			</div> -->
			<ul class="site_nav_list_s">
				<li><a href="javascript:;" onclick="move_category('1');return false;" class="nav_list_tit">안경테</a></li>
				<li><a href="javascript:;" onclick="move_category('439');return false;">디자인별 추천</a></li>
				<li><a href="javascript:;" onclick="move_category('374');return false;">착용목적별 추천</a></li>
				<li><a href="javascript:;" onclick="move_category('342');return false;">얼굴형별 추천</a></li>
	
				<li><a href="javascript:;" onclick="move_category('3');return false;" class="nav_list_tit">안경렌즈</a></li>
				<li><a href="javascript:;" onclick="move_category('400');return false;">시력증상별 추천</a></li>
				<li><a href="javascript:;" onclick="move_category('390');return false;">생활패턴별 추천</a></li>
	
				<li><a href="javascript:;" onclick="move_category('4');return false;" class="nav_list_tit">콘택트렌즈</a></li>
				<li><a href="javascript:;" onclick="move_category('12');return false;">컬러별 추천</a></li>
				<li><a href="javascript:;" onclick="move_category('13');return false;">착용주기별 추천</a></li>
				<li><a href="javascript:;" onclick="move_category('16');return false;">가격대 추천</a></li>
	
				<li><a href="javascript:;" onclick="move_category('2');return false;" class="nav_list_tit">선글라스</a></li>
				<li><a href="javascript:;" onclick="move_category('26');return false;">디자인별 추천</a></li>
				<li><a href="javascript:;" onclick="move_category('28');return false;">컬러별 추천</a></li>
				<li><a href="javascript:;" onclick="move_category('27');return false;">소재별 추천</a></li>
			</ul>
			<div class="site_nav_list">
				<a href="javascript:;" onclick="move_category('434');return false;">BEST</a>
			</div>
			<div class="site_nav_list">
				<a href="/m/front/vision2/vision-check">렌즈추천</a>
			</div>
			<div class="site_nav_list">
				<a href="javascript:;" onclick="move_category('426');return false;">매장픽업</a>
			</div>
			
			<c:forEach var="gnbList" items="${gnb_info.get('0')}" varStatus="status">
				<c:choose>
					<c:when test="${gnbList.ctgNo eq '762' }">
						<div class="site_nav_list02">
							<a href="#gnb0${gnbList.ctgNo}" onclick="javascript:move_category('${gnbList.ctgNo}');return false;">${gnbList.ctgNm}</a>
							<c:if test="${fn:length(lnb_info.get(gnbList.ctgNo)) > 0}">
								<i class="icon_arrow">화살표</i>
							</c:if>
						</div>
						<c:if test="${fn:length(lnb_info.get(gnbList.ctgNo)) > 0}">
							<c:forEach var="gnbList2" items="${lnb_info.get(gnbList.ctgNo)}">
								<div class="site_nav_list_s02">	
									<div class="btn_view_glass">
										<a href="javascript:move_category('${gnbList2.ctgNo}')">${gnbList2.ctgNm}</a><i class="icon_arrow">화살표</i>
									</div>
									<ul>
										<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}">
											<li><a href="javascript:move_category('${gnbList3.ctgNo}')">${gnbList3.ctgNm}</a></li>
										</c:forEach>	
									</ul>
								</div>
							</c:forEach>
						</c:if>
					</c:when>
					<c:otherwise>
						<div class="site_nav_list">
							<a href="#gnb0${gnbList.ctgNo}" onclick="javascript:move_category('${gnbList.ctgNo}');return false;">${gnbList.ctgNm}</a>
							<c:if test="${fn:length(lnb_info.get(gnbList.ctgNo)) > 0}">
								<i class="icon_arrow">화살표</i>
							</c:if>
						</div>
						<c:if test="${fn:length(lnb_info.get(gnbList.ctgNo)) > 0}">
						<ul id="gnb0${gnbList.ctgNo}" class="site_nav_list_s">
							<c:forEach var="gnbList2" items="${lnb_info.get(gnbList.ctgNo)}" varStatus="status1">
								<li>
									<a href="javascript:move_category('${gnbList2.ctgNo}')">${gnbList2.ctgNm}</a>
								</li>
								<c:if test="${gnbList.ctgNo eq '709' }">
								<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
			                        <li>
										<a href="javascript:move_category('${gnbList3.ctgNo}')">${gnbList3.ctgNm}</a>
									</li>
		                        </c:forEach>
		                        </c:if>
							</c:forEach>
						</ul>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<%--<div class="site_nav_list">
				<a href="#">선글라스</a><i class="icon_arrow">화살표</i>
			</div>
			<ul class="site_nav_list_s">
				<li><a href="#">Sun</a></li>
				<li><a href="#">Optical</a></li>
				<li><a href="#">Kids</a></li>
				<li><a href="#">Personal</a></li>
				<li><a href="#">Celebrity</a></li>
				<li><a href="#">Lookboo</a></li>
			</ul>--%>

			<ul class="event_nav_list">
				<%--<li><a href="${_MOBILE_PATH}/front/brand-category"><i class="icon01"></i>브랜드관</a></li>--%>
				<li><a href="${_MOBILE_PATH}/front/promotion/promotion-list"><i class="icon01"></i>기획전</a></li>
				<%--<li><a href="javascript:;" onclick="move_category('808');return false;" ><i class="icon02"></i>Shop in Shop</a></li>--%>
				<li><a href="${_MOBILE_PATH}/front/event/event-list"><i class="icon03"></i>이벤트</a></li>
				<li><a href="https://www.davichhearing.com" target="_blank"><i class="icon02"></i>보청기</a></li>
			</ul>
			<div class="site_bottom_menu">
				<a href="${_MOBILE_PATH}/front/customer/customer-main"><i class="icon01"></i>고객센터</a>
				<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/customer/store-list"><i class="icon02"></i>매장찾기</a>
				<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-welcome"><i class="icon03"></i>방문예약</a>
				<c:if test="${site_info.bbsCnt gt 0}">
					<a href="${_MOBILE_PATH}/front/customer/board-list?bbsId=freeBbs"><i class="icon04"></i>도움말</a>
					<!-- <a href="#"><i class="icon04"></i>구매가이드</a> -->
				</c:if>
			</div>
			<div class="nav_footer">
				<a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=01">회사소개</a>
				<a href="${_MOBILE_PATH}/front/company-info?siteInfoCd=03">이용약관</a>
				<a href="${_MOBILE_PATH}/front/seller/seller-detail">입점/제휴문의</a>
				<a href="${_MOBILE_PATH}/front/customer/notice-list">공지사항</a>
				<a href="${_MOBILE_PATH}/front/customer/board-list?bbsId=news">뉴스</a>
				<p class="copyright">${site_info.siteNm} © Davich Corp. All Rights Reserved.</p>
			</div>
		</div>
	</div>
</div>
<div id="c-mask" class="c-mask"></div><!-- slide menu c-mask -->

<%--

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


--%>
