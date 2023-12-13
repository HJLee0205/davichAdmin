<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!--- 00.LAYOUT: BOTTOM AREA --->
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

    $('#a_id_logout_left_btm').on('click', function(e) {
        Dmall.EventUtil.stopAnchorAction(e);
        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/login/logout', {});
    });
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
function viewNotice(idx){
    location.href="${_MOBILE_PATH}/front/customer/notice-detail?lettNo="+idx
}
</script>
 
<!-- <div class="footer_gotop_area">
	<a href="#" class="f_go_top">맨위로</a>
</div> -->

<!--- Notice Area --->
<c:if test="${fn:length(noticeList.resultList) >0}">
<div class="bottom_notice">
	<span class="tit"><i></i>공지</span>
    <c:forEach var="noticeList" items="${noticeList.resultList}" varStatus="status" end="0" >
        <a href="javascript:viewNotice('${noticeList.lettNo}');">${noticeList.title}</a>
        <span class="date"><a href="javascript:viewNotice('${noticeList.lettNo}');" style="width:100%;"><fmt:formatDate pattern="yyyy-MM-dd" value="${noticeList.regDttm}" /></a></span>
    </c:forEach>
</div>
</c:if>

<!---// Notice Area --->
<div class="bottom_menu">
	<sec:authorize access="!hasRole('ROLE_USER')">
	<a href="${_DMALL_HTTPS_SERVER_URL}/front/login/member-login">로그인</a>
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_USER')">
	<a href="#none" id="a_id_logout">로그아웃</a>
	</sec:authorize>
    <a href="${_MOBILE_PATH}/front/customer/customer-main">고객센터</a>
    <a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-welcome" style="background:none;">무료시력검사 안내</a>

    <a href="${_MOBILE_PATH}/front/appDownload" class="btn_appdown" style="display:none;">앱 다운로드</a>
</div>
<!---// 00.LAYOUT: BOTTOM AREA --->
<script>
	if(isAndroidWebview() || isIOSWebview()){
            $('.btn_appdown').hide();
        }else{
            $('.btn_appdown').show();
        }

</script>