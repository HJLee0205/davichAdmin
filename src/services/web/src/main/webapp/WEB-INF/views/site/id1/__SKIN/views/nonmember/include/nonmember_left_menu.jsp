<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--- 마이페이지 왼쪽 메뉴 --->
<script>
$(document).ready(function(){
    $(".selected").parents('li').parents('ul').parents('li').find('a').eq(0).addClass('selected');
});


function order_list(no, ordrMobile){
    Dmall.FormUtil.submit('/front/order/nomember-order-list', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile});
}
</script>
<!--- 비회원 주문/배송조회 왼쪽 메뉴 --->
<div id="mypage_snb">
	<div class="mypage_snb_top nomember">
		<p class="name"><em>비회원 고객</em>님</p>
	</div>
    <div class="mypage_snb_area nomember">
		<h2 class="mypage_snb_tit"><a href="/front/member/mypage">주문/배송조회</a></h2>
		<ul class="my_snb_menu">
			<li>
				<a href="#">나의 주문</a>
				<ul class="my_snb_smenu">
					<li><a href="javascript:order_list('${so.ordNo}', '${so.nonOrdrMobile}');" <c:if test="${leftMenu eq 'order'}" >class="selected"</c:if>>주문/배송조회</a></li>
				</ul>
			</li>
		</ul>
    </div>
</div>
<!---// 비회원 주문/배송조회 왼쪽 메뉴 --->