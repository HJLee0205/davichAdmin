<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--- 마이페이지 왼쪽 메뉴 --->
<script>
$(document).ready(function(){
    $(".selected").parents('li').parents('ul').parents('li').find('a').eq(0).addClass('selected');
});


function rsv_list(no, rsvMobile){
    Dmall.FormUtil.submit('/front/visit/nomember-rsv-list', {'rsvNo':no, 'rsvMobile':rsvMobile, 'nonRsvMobile':rsvMobile});
}
</script>
<!--- 비회원 주문/배송조회 왼쪽 메뉴 --->
<div id="mypage_snb">
	<div class="mypage_snb_top nomember">
		<p class="name"><em>비회원 고객</em>님</p>
	</div>
    <div class="mypage_snb_area nomember">
		<h2 class="mypage_snb_tit"><a href="/front/member/mypage">방문예약조회</a></h2>
		<ul class="my_snb_menu">
			<li>
				<a href="#">나의 방문예약</a>
				<ul class="my_snb_smenu">
					<li><a href="javascript:rsv_list('${so.rsvNo}', '${so.rsvMobile}');" <c:if test="${leftMenu eq 'visit_list'}" >class="selected"</c:if>>방문예약조회</a></li>
				</ul>
			</li>
		</ul>
    </div>
</div>
<!---// 비회원 주문/배송조회 왼쪽 메뉴 --->