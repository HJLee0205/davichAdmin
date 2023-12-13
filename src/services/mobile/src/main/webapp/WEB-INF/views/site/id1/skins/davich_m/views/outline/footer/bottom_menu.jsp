<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	function sns_move(type){
		if(navigator.userAgent.indexOf("davich_android")> 0){
			if(type == 'fb'){
				//window.open("https://www.facebook.com/%EB%8B%A4%EB%B9%84%EC%B9%98%EB%A7%88%EC%BC%93-2253282748223706/?modal=admin_todo_tour",'_blank');
				//window.open("intent://www.facebook.com/%EB%8B%A4%EB%B9%84%EC%B9%98%EB%A7%88%EC%BC%93-2253282748223706/?modal=admin_todo_tour#Intent;scheme=http;package=com.android.chrome;end");
				//location.href = "intent://www.facebook.com/%EB%8B%A4%EB%B9%84%EC%B9%98%EB%A7%88%EC%BC%93-2253282748223706/?modal=admin_todo_tour#Intent;scheme=http;package=com.android.chrome;end";
				location.href = "intent://www.facebook.com/davichoptical/?modal=admin_todo_tour#Intent;scheme=http;package=com.android.chrome;end";

			}else if(type == 'ig'){
				//window.open("https://www.instagram.com/davichmarket/",'_blank');
				//window.open("intent://www.instagram.com/davichmarket/#Intent;scheme=http;package=com.android.chrome;end");
				//location.href = "intent://www.instagram.com/davichmarket/#Intent;scheme=http;package=com.android.chrome;end";
				location.href = "intent://www.instagram.com/davich_insta/#Intent;scheme=http;package=com.android.chrome;end";


			}else if(type == 'bg'){
				//window.open("https://blog.naver.com/eyekeeper13579",'_blank');
				//window.open("intent://blog.naver.com/eyekeeper13579#Intent;scheme=http;package=com.android.chrome;end");
				location.href = "intent://blog.naver.com/eyekeeper13579#Intent;scheme=http;package=com.android.chrome;end";
			}else if(type == 'cp'){
				//window.open("https://pf.kakao.com/_exaxexoM",'_blank');
				//window.open("intent://pf.kakao.com/_exaxexoM#Intent;scheme=http;package=com.android.chrome;end");
				location.href = "intent://pf.kakao.com/_exaxexoM#Intent;scheme=http;package=com.android.chrome;end";
			}else if(type == 'yt'){
				//window.open("https://www.youtube.com/channel/UCJoAvzt6GNBZLuXYY50F3Yw",'_blank');
				//window.open("intent://www.youtube.com/channel/UCJoAvzt6GNBZLuXYY50F3Yw#Intent;scheme=http;package=com.android.chrome;end");
				//location.href = "intent://www.youtube.com/channel/UCJoAvzt6GNBZLuXYY50F3Yw#Intent;scheme=http;package=com.android.chrome;end";
				location.href = "intent://www.youtube.com/channel/UCJoAvzt6GNBZLuXYY50F3Yw#Intent;scheme=http;package=com.android.chrome;end";

			}
		}else{
			if(type == 'fb'){
				window.open("https://www.facebook.com/davichoptical",'_blank');
			}else if(type == 'ig'){
				window.open("https://www.instagram.com/davich_insta/?hl=ko",'_blank');
			}else if(type == 'bg'){
				window.open("https://blog.naver.com/eyekeeper13579",'_blank');
			}else if(type == 'cp'){
				window.open("https://pf.kakao.com/_exaxexoM",'_blank');
			}else if(type == 'yt'){
				window.open("https://www.youtube.com/channel/UCJoAvzt6GNBZLuXYY50F3Yw",'_blank');


			}
		}
	}
	
</script>

<%--<div class="footer_go_menu">
	<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/customer/store-list">
		<p>다비치<br>매장찾기</p>
	</a>
	<!-- <a href="javascript:alert('준비중입니다');"> -->
	<a href="${_MOBILE_PATH}/front/customer/board-list?bbsId=freeBbs">
		<p>도움말</p>
	</a>
	<a href="${_MOBILE_PATH}/front/visit/visit-welcome">
		<p>방문예약</p>
	</a>
	<a href="${_MOBILE_PATH}/front/customer/letter-detail?bbsId=freeBbs&lettNo=294">
		<p>통합멤버쉽<br>안내</p>
	</a>
	<a href="${_MOBILE_PATH}/front/appDownload">
		<p>
			<span class="eng" style="background:none;color: #09d0ee;width:53px;letter-spacing: -0.85px;font-size: 0.8em;">DavichMarket</span>
			<br>
			앱다운로드
		</p>
	</a>
</div>--%>

<div class="sns_list">
	<a href="javascript:sns_move('fb');"><button type="button" class="btn_fbook">페이스북</button></a>
	<a href="javascript:sns_move('ig');" ><button type="button" class="btn_instar">인스타그램</button></a>
<%--	<a href="javascript:sns_move('bg');" ><button type="button" class="btn_blog">블로그</button></a>
	<a href="javascript:sns_move('cp');" ><button type="button" class="btn_kakao">카카오플러스</button></a>--%>
	<a href="javascript:sns_move('yt');" ><button type="button" class="btn_youtube">유투브</button></a>
</div>


