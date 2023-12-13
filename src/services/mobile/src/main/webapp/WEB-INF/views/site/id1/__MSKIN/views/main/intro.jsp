<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<t:insertDefinition name="introLayout">
	<t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
	    
	<t:putAttribute name="script">
	<sec:authentication var="user" property='details'/>
	<script src="${_SKIN_JS_PATH}/jquery-barcode.js" charset="utf-8"></script>
	<script>


	function initNative() {
        var appVersionIos = "${siteInfo.data.appVersionIos eq null?site_info.appVersionIos:siteInfo.data.appVersionIos}"; //앱 최신버전 IOS
		var forceUpdateYnIos = "${siteInfo.data.forceUpdateYnIos eq null?site_info.forceUpdateYnIos:siteInfo.data.forceUpdateYnIos}";//강제 업데이트 여부 IOS
		var appVersionAndroid = "${siteInfo.data.appVersionAndroid eq null?site_info.appVersionAndroid:siteInfo.data.appVersionAndroid}";//앱 최신버전 ANDROID
		var forceUpdateYnAndroid = "${siteInfo.data.forceUpdateYnAndroid eq null?site_info.forceUpdateYnAndroid:siteInfo.data.forceUpdateYnAndroid}";//강제 업데이트 여부 ANDROID





		/*var param = {
			appVersionIos: appVersionIos
		  , forceUpdateYnIos:forceUpdateYnIos
		  , appVersionAndroid:appVersionAndroid
		  , forceUpdateYnAndroid:forceUpdateYnAndroid
		};*/

        if(forceUpdateYnIos==""){
            forceUpdateYnIos ="N";
        }

        if(forceUpdateYnAndroid==""){
            forceUpdateYnAndroid ="N";
        }

		if (isAndroidWebview()) {
		    var versionInfo = navigator.userAgent.substring(navigator.userAgent.indexOf("davich_android")-1,165);
		    var version = versionInfo.split("_")[2];
		    if(version == undefined){
		        version ="1.6";
		    }
		    if(navigator.userAgent.indexOf("davich_android_"+appVersionAndroid)<0) {

                if (Number(version) < Number(appVersionAndroid)) {
                    if (forceUpdateYnIos == "Y") {
                        alert("최신버전 업데이트가 필요합니다. 마켓으로 이동합니다.");
                        location.href="market://details?id=com.kyad.davich";
                     } else {
                        Dmall.LayerUtil.confirm('최신버전 업데이트가 필요합니다. <br/>마켓으로 이동하시겠습니까?',
                            function () {
                                location.href="market://details?id=com.kyad.davich";
                            });
                    }
                }
            }else {
                davichapp.bridge_app_version(appVersionAndroid, forceUpdateYnAndroid);
            }
		}

		if (isIOSWebview()) {
		    var versionInfo = navigator.userAgent.substring(navigator.userAgent.indexOf("davich_ios")-1,112);
		    var version = versionInfo.split("_")[2];
		    if(version == undefined){
		        version ="1.6";
		    }

		    if(navigator.userAgent.indexOf("davich_ios_"+appVersionIos)<0){
                if(Number(version) < Number(appVersionIos)) {
                    if (forceUpdateYnIos == "Y") {
                        alert("최신버전 업데이트가 필요합니다. 앱스토어로 이동합니다.");
                        location.href = "https://itunes.apple.com/kr/app/quik/id1434711470"
                    } else {
                        Dmall.LayerUtil.confirm('최신버전 업데이트가 필요합니다. <br/>앱스토어로 이동하시겠습니까?',
                            function () {
                                location.href = "https://itunes.apple.com/kr/app/quik/id1434711470"
                            });
                    }
                }
		    }else {
                window.webkit.messageHandlers.davichapp.postMessage({
                    func: 'bridge_app_version',
                    param1: appVersionIos,
                    param2: forceUpdateYnIos
                });
            }
		}
     }

	$(document).ready(function(){

		initNative();

		$("#bcTarget").barcode("${user.session.memberCardNo}", "code128");

		$('.intro_membership').on('click',function(){
		    <sec:authorize access="hasRole('ROLE_USER')">
		        location.href = "${_MOBILE_PATH}/front/main-view?intro=Y";
		    </sec:authorize>
		    <sec:authorize access="!hasRole('ROLE_USER')">
		        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
		                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
		                function() {
		                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl=${_MOBILE_PATH}/front/main-view?intro=Y"
		                },'');
		    </sec:authorize>
		});
		    
	});
	
	function move_page(idx){
		if(idx == 'main'){ //메인페이지
	        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/main-view");
	    }else if(idx == 'promotion'){ //기확전페이지
	        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/promotion/promotion-list");
	    }else if(idx == 'visit'){ //방문예약페이지
	        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/visit/visit-welcome");
	    }
	}
	
	</script>

	</t:putAttribute>
	<t:putAttribute name="content">
	
		<%@ include file="main_visual.jsp" %>



        <!--- main content area --->
		<div id="middle_area">
			<ul class="intro_menu">
				<li>
					<a href="javascript:move_page('main');">
						<img src="${_SKIN_IMG_PATH}/main/intro_menu01.png" alt="다비치마켓 쇼핑하기">
					</a>
				</li>
				<li>
					<a href="javascript:move_page('promotion');">
						<img src="${_SKIN_IMG_PATH}/main/intro_menu02.png" alt="다비치마켓 기획전">
					</a>
				</li>
				<li>
					<a href="javascript:move_page('visit');">
						<img src="${_SKIN_IMG_PATH}/main/intro_menu03.png" alt="다비치매장 방문예약">
					</a>
				</li>
			</ul>
			<sec:authorize access="!hasRole('ROLE_USER')">
			<div class="intro_membership">
				<a href="#" class="menu_intro01">
					<img src="${_SKIN_IMG_PATH}/main/intro_menu04.png" alt="다비치 멤버십 Point & D-money">
				</a>
			</div>
			</sec:authorize>
			<!-- 로그인시 -->
			<sec:authorize access="hasRole('ROLE_USER')">
			<div class="intro_membership login">
				<%--<div class="intro_money">
					마켓포인트<em><fmt:formatNumber value="${memberPrcAmt }" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
				</div>--%>
				<div class="intro_money">
					다비치포인트<em><c:choose><c:when test="${memberPrcPoint ne null}"><fmt:formatNumber value="${memberPrcPoint }" type="currency" maxFractionDigits="0" currencySymbol=""/></c:when><c:otherwise>0</c:otherwise></c:choose></em>P
				</div>
				<div class="member_barcode">
					<div id="bcTarget" style="margin: 0 auto"></div>
					<p class="member_no"><span>NO.</span><span>${fn:substring(user.session.memberCardNo,0,2)}</span><span>${fn:substring(user.session.memberCardNo,2,5)}</span><span>${fn:substring(user.session.memberCardNo,5,9)}</span></p>
				</div>
			</div>
			</sec:authorize>
			<!--// 로그인시 -->
		</div>
		<!---// main content area --->
	</t:putAttribute>
</t:insertDefinition>