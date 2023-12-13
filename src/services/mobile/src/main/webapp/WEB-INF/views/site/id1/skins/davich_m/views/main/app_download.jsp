<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page trimDirectiveWhitespaces="true" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" CONTENT="0">
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <script type="text/javascript" src="/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
    <link href="${_MOBILE_PATH}/front/appDownload/css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
	<sec:authentication var="user" property='details'/>
	<script type="text/javascript">
		var isMobile = {
	    	    Android: function() {
	    	        return navigator.userAgent.match(/Android/i);
	    	    },
	    	    BlackBerry: function() {
	    	        return navigator.userAgent.match(/BlackBerry/i);
	    	    },
	    	    iOS: function() {
	    	        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
	    	    },
	    	    Opera: function() {
	    	        return navigator.userAgent.match(/Opera Mini/i);
	    	    },
	    	    Windows: function() {
	    	        return navigator.userAgent.match(/IEMobile/i);
	    	    },
	    	    any: function() {
	    	        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
	    	    }
	    	};


		$(document).ready(function(){
			if(navigator.userAgent.indexOf("davich_android")> 0){
				$('ul.app_wrap li.li_ios').css('display','none');
				$('p.li_ios').css('display','none');
			}else if(navigator.userAgent.indexOf("davich_ios") > 0){
				$('ul.app_wrap li.li_android').css('display','none');
				$('p.li_android').css('display','none');
			}else{
				//$('ul.app_wrap li.li_android').css('display','none');
			}


			if (isMobile.Android()) {
            	if(confirm('플레이스토어로 이동하시겠습니까?')){
					//window.open("https://play.google.com/store/apps/details?id=com.kyad.davich",'_blank');
					location.href="market://details?id=com.kyad.davich";
				}
            }

			if (isMobile.iOS()) {
				if(confirm('앱스토어로 이동하시겠습니까?')){
					//window.open("https://itunes.apple.com/kr/app/%EB%8B%A4%EB%B9%84%EC%B9%98%EB%A7%88%EC%BC%93/id1434711470?mt=8",'_blank');
					location.href = "https://itunes.apple.com/kr/app/quik/id1434711470"
				}
			}
		});
		function fn_appDownload(type){
			if(type == 'market_android'){	//다비치마켓 안드로이드
				if(confirm('플레이스토어로 이동하시겠습니까?')){
					//window.open("https://play.google.com/store/apps/details?id=com.kyad.davich",'_blank');
					location.href="market://details?id=com.kyad.davich";
				}
			}else if(type == 'market_ios'){ //다비치마켓 IOS
				if(confirm('앱스토어로 이동하시겠습니까?')){
					//window.open("https://itunes.apple.com/kr/app/%EB%8B%A4%EB%B9%84%EC%B9%98%EB%A7%88%EC%BC%93/id1434711470?mt=8",'_blank');
					location.href = "https://itunes.apple.com/kr/app/quik/id1434711470"
				}
			}else if(type == 'wear_android'){	//가상착장 안드로이드
				if(confirm('플레이스토어로 이동하시겠습니까?')){
					//window.open("https://play.google.com/store/apps/details?id=com.davich.davichwear&hl=ko",'_blank');
					location.href="market://details?id=com.davich.davichwear";
				}
			}else if(type == 'wear_ios'){ //가상착장 IOS
				if(confirm('앱스토어로 이동하시겠습니까?')){
					//window.open("https://itunes.apple.com/kr/app/%EB%8B%A4%EB%B9%84%EC%B9%98%EC%9B%A8%EC%96%B4/id1435001295?mt=8",'_blank');
					location.href = "https://itunes.apple.com/kr/app/quik/id1435001295"
				}
			}
		}
		
		/* footer menu */
		$.fn.scrollEnd = function(callback, timeout) {          
		  $(this).scroll(function(){
		    var $this = $(this);
		    if ($this.data('scrollTimeout')) {
		      clearTimeout($this.data('scrollTimeout'));
		    }
		    $this.data('scrollTimeout', setTimeout(callback,timeout));
		  });
		};

		$(window).scroll(function(){
		    $('#footer-menu').fadeOut();
			$('#footer-content').fadeOut();
		});

		$(window).scrollEnd(function(){
		    $('#footer-menu').fadeIn();
		}, 350);

		$(function() {
			$('#footer-content').hide();
			$('.btn_f_menu').click(function(e) {
				e.preventDefault();
				$('#footer-content').fadeIn();
				 $("html, body").css({'overflow':'visible'}).unbind('touchmove');//브라우져에 터치를 다시 활성화
			});
			$('.toggle-footer.close').click(function() {
				$('#footer-content').hide();
			});
		});
	</script>
<header>
	<h1>다비치안경</h1>
	<h2>모바일앱 <b>다운로드</b></h2>
</header>
<article class="app1">
	<h3>다비치마켓 (쇼핑몰)</h3>
	<ul class="app_wrap">
		<%--<li><a href="${_MOBILE_PATH}/front/appDownload/file/davich_mall.apk" download><img src="${_MOBILE_PATH}/front/appDownload/img/icon_market1.png"><p>Android</p></a></li>--%>
		<%--<li><a href="http://bit.ly/2oyzbWp"><img src="${_MOBILE_PATH}/front/appDownload/img/icon_market2.png"><p>IOS</p></a></li>--%>
		<li class="li_android"><a href="#" onClick="javascript:fn_appDownload('market_android');"><img src="${_MOBILE_PATH}/front/appDownload/img/icon_market1.png"><p>Android</p></a></li>
		<li class="li_ios"><a href="#" onClick="javascript:fn_appDownload('market_ios');"><img src="${_MOBILE_PATH}/front/appDownload/img/icon_market2.png"><p>IOS</p></a></li>
	</ul>
</article>
<article class="app2">
	<h3>다비치웨어 (가상착장)</h3>
	<ul class="app_wrap">
		<li class="li_android"><a href="#" onClick="javascript:fn_appDownload('wear_android');"><img src="${_MOBILE_PATH}/front/appDownload/img/icon_wear1.png"><p>Android</p></a></li>
		<li class="li_ios"><a href="#" onClick="javascript:fn_appDownload('wear_ios');"><img src="${_MOBILE_PATH}/front/appDownload/img/icon_wear2.png"><p>IOS</p></a></li>
	</ul>
</article>
	<div class="app_footer">
		<ul class="footer_list">
			<li>※ 다비치웨어 디바이스 기준은 
				<p class="li_android" style="display:inline-block">갤럭시S6 </p>
				<p class="li_ios" style="display:inline-block">아이폰6S </p> 
				이상입니다.
			</li>
			<li>※ 메모리 부족시 앱 실행 또는 앱 동작이 멈출 수 있습니다.</li>
		</ul>
		<strong>아이폰  앱 설치 방법</strong>
		<ol>
			<li>링크 주소를 사파리에서 실행 > 인스톨 > 설치</li>
			<li>설정 > 일반 > 프로파일 또는 프로파일 및 기기 관리 > 
				다비치마켓, 다비치웨어 > 신뢰</li>
			<li>문의 <a href="mailto:davichmarket@davich.com">davichmarket@davich.com</a></li>
		</ol>
	</div>
<footer style="z-index: 999;width: 100%;position: fixed;bottom: 0;padding-bottom: 50px;">	
	<div id="footer-menu" <c:if test="${!user.login}">class="logout"</c:if>> <!-- 로그아웃 상태일 경우 class="logout" 추가 -->
		<a href="javascript:history.back();" class="btn_f_prev active"><i>이전</i></a>
		<a href="javascript:history.forward();" class="btn_f_next"><i>다음</i></a>
		<a href="${_MOBILE_PATH}/front" class="btn_f_home"><i>홈</i></a>
		<c:if test="${user.login}">
			<a href="${_MOBILE_PATH}/front/member/mypage" class="btn_f_my"><i>마이페이지</i></a>
		</c:if>
		<a href="javascript:;" class="btn_f_menu"><i>메뉴보기</i></a>
	</div>
	<div id="footer-content">
		<div class="footer-tit">카테고리 <span class="close toggle-footer">닫기</span></div>
		<ul class="footer-navi" style="list-style: none;">
			<c:forEach var="ctgList" items="${lnb_info.get('0')}" varStatus="status">
				<li>
					<a href="#gnb0${ctgList.ctgNo}" onclick="javascript:move_category('${ctgList.ctgNo}');return false;">${ctgList.ctgNm}</a>
				</li>
			</c:forEach>
		</ul>
	</div>
</footer>
</body>
</html>