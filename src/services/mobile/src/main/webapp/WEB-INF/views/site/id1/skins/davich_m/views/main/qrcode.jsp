<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<t:insertDefinition name="popupLayout">
	<t:putAttribute name="title">QR CODE</t:putAttribute>
	    
	<t:putAttribute name="script">
	<script>
	
	$(document).ready(function(){
	
		var url = "",
			param = "",
			goodsNo = "${so.goodsNo}",
			eventNo = "${so.eventNo}",
			prmtNo = "${so.prmtNo}";
		
		if(goodsNo != "") {
			param = "?goodsNo="+goodsNo;
			url = "davichapp://davichapp/m/front/goods/goods-detail"+param;
		}
		else if(eventNo != "") {
			param = "?eventNo="+eventNo;
			url = "davichapp://davichapp/m/front/event/event-ing-list"+param;
		}
		else if(prmtNo != "") {
			param = "?prmtNo="+prmtNo;
			url = "davichapp://davichapp/m/front/promotion/promotion-detail"+param;
		}
		else {
			param = "";
			url = "davichapp://davichapp";
		}

		var userAgent = navigator.userAgent.toLocaleLowerCase();
		var visitedAt = (new Date()).getTime(); // 방문 시간
		// IOS
		if (userAgent.indexOf("iphone") != -1 || userAgent.indexOf("ipad") != -1 || userAgent.indexOf("ipod") != -1) {
		   setTimeout(
		      function() {
		          if ((new Date()).getTime() - visitedAt < 2000) {
		               location.href = "https://itunes.apple.com/kr/app/%EB%8B%A4%EB%B9%84%EC%B9%98%EB%A7%88%EC%BC%93/id1434711470?mt=8";
		          }
		       }, 500);
		   setTimeout(function() { 
		        location.href = url;
		    }, 0);
		}
		
		// ANDROID
		if (userAgent.indexOf("android") != -1) {
			
			var intentURI = [
				'intent://davichapp'+param+'#Intent',
			    'scheme=davichapp',
			    'package=com.kyad.davich',
                'S.browser_fallback_url=www.davichmarket.com',
			    'end'
			].join(';');

			window.location.href = intentURI;
			/* 
			setTimeout(
				function() {
					if ((new Date()).getTime() - visitedAt < 2000) {
						confirm((new Date()).getTime() - visitedAt){
							location.href = "https://play.google.com/store/apps/details?id=com.kyad.davich";
						}
					}
				}, 500);
			var iframe = document.createElement('iframe');
			iframe.style.visibility = 'hidden';
			iframe.src = url;
			document.body.appendChild(iframe);
			document.body.removeChild(iframe); // back 호출시 캐싱될 수 있으므로 제거 */
		}
	
	});
	
	</script>

	</t:putAttribute>
	<t:putAttribute name="content">
		<!-- <a href="http://www.davichmarket.com">다비치마켓 바로가기</a> -->
	</t:putAttribute>
</t:insertDefinition>