<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!--- 00.LAYOUT: BOTTOM AREA --->
<%--
<div id="bottom_area">
    <div class="bottom_layout">
        <dl id="information">
            <dt>
            <h2 class="information_title">CUSTOMER CENTER</h2>
            <span class="tel">${su.phoneNumber(site_info.custCtTelNo)}</span><br>
            (무료상담)
            </dt>
            <dd>
                <ul class="information_list">
                    <li><b>상담시간</b> : ${site_info.custCtOperTime}</li>
                    <li><b>점심시간</b> : ${site_info.custCtLunchTime}</li>
                    <li>* 토, 일요일 및 공휴일 휴무</li>
                </ul>
            </dd>
        </dl>
        <dl id="bank_info">
            <dt>
            <h2 class="bank_info_title">무통장 계좌 안내</h2>
            </dt>
            <dd>
                <ul class="bank_info_no">
                    <c:forEach var="nopb_info" items="${nopb_info}" varStatus="status">
                    <li><b>${nopb_info.bankNm}</b> : ${nopb_info.actno} (${nopb_info.holder})</li>
                    </c:forEach>
                </ul>
            </dd>
        </dl>
    </div>
</div>
--%>

<script>

$(document).ready(function(){
$('#move_mypage_foot').on('click',function(){
    <sec:authorize access="hasRole('ROLE_USER')">
        location.href = "${_MOBILE_PATH}/front/member/mypage";
    </sec:authorize>
    <sec:authorize access="!hasRole('ROLE_USER')">
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl=${_MOBILE_PATH}/front/member/mypage"
                },'');
    </sec:authorize>
    })
});
//즐겨찾기 추가
function add_favorite(){
    var url = location.href;
    var title = '${site_info.siteNm}';
    if (window.sidebar && window.sidebar.addPanel){ // Mozilla Firefox
        window.sidebar.addPanel(title, url, "");
    }else if(window.opera && window.print) { // Opera
        var elem = document.createElement('a');
        elem.setAttribute('href',url);
        elem.setAttribute('title',title);
        elem.setAttribute('rel','sidebar');
        elem.click();
    }else if(window.external && document.all){ // ie
        window.external.AddFavorite(url,title);
    }else if((navigator.appName == 'Microsoft Internet Explorer') || ((navigator.appName == 'Netscape') && (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null))){ // ie11
        window.external.AddFavorite(url, title);
    }else{ // crome safari
        //alert("Ctrl+D키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
        alert('죄송합니다. 현재 브라우저는 북마크 등록이 지원되지 않습니다. 직접 등록해주세요.');
	   // 북마크 등록이 되지 않는 경우 메세지 출력
	     return false;
    }
}

</script>
 
<!-- <div class="footer_gotop_area">
	<a href="#" class="f_go_top">맨위로</a>
</div> -->

<ul class="bottom_menu">
	<li>
		<a href="javascript:add_favorite();">
			<span class="icon_favorite"></span><br>
			즐겨찾기
		</a>
	</li>
	<li>
		<a href="${_MOBILE_PATH}/front/customer/customer-main">
			<span class="icon_callcenter"></span><br>
			고객센터
		</a>
	</li>
	<li id="move_mypage_foot">
		<a href="#none">
			<span class="icon_mypage"></span><br>
			마이페이지
		</a>
	</li>
</ul>
<!---// 00.LAYOUT: BOTTOM AREA --->
