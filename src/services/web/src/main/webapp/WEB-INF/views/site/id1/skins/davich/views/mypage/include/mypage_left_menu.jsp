<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<!--- 마이페이지 왼쪽 메뉴 --->
<script src="${_SKIN_JS_PATH}/jquery-barcode.js" charset="utf-8"></script>
<script>

var integration = "${user.session.integrationMemberGbCd}";

$(document).ready(function(){
    $(".selected").parents('li').parents('ul').parents('li').find('a').eq(0).addClass('selected');
    
    $('#btn_go_modify').click(function(){
    	location.href = '/front/member/information-update-form';
    });
    $('#btn_go_integration').click(function(){
    	location.href = '/front/member/member-integration-form';
    });
    $("#btn_barcode_pop").click(function() {
        $('#member_card_popup').show();
    });
    
    $("#bcTarget_pop").barcode("${user.session.memberCardNo}", "code128", {barWidth: 2,barHeight: 50});
});

function fn_go_point(){
	if(integration == '03'){
		location.href = "/front/member/point";
	}
	else if(integration == '01'){
		Dmall.LayerUtil.confirm('통합멤버쉽 회원만 이용하실 수 있습니다.<br>지금 멤버쉽 통합절차를 진행할까요?', function() {
            location.href="/front/member/member-integration-form";
        });
        
	}
	else if(integration == '02'){
		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
            location.href="/front/member/information-update-form";
        });
	}
}

function fn_go_yearend_tax(){
	if(integration == '03'){
		location.href = "/front/member/yearend-taxList";
	}
	else if(integration == '01'){
		Dmall.LayerUtil.confirm('통합멤버쉽 회원만 이용하실 수 있습니다.<br>지금 멤버쉽 통합절차를 진행할까요?', function() {
            location.href="/front/member/member-integration-form";
        });
        
	}
	else if(integration == '02'){
		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
            location.href="/front/member/information-update-form";
        });
	}
}

function fn_go_offlineSal(){
	if(integration == '03'){
		location.href = "/front/member/offline_sal";
	}
	else if(integration == '01'){
		Dmall.LayerUtil.confirm('멤버쉽통합 회원이 아닙니다.<br>멤버쉽통합을 진행하시겠습니까?', function() {
            location.href="/front/member/member-integration-form";
        });
        
	}
	else if(integration == '02'){
		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
            location.href="/front/member/information-update-form";
        });
	}
}

function fn_go_integration(){
	if(integration == '01'){
		location.href = "/front/member/member-integration-form";
	}
	else if(integration == '02'){
		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
            location.href="/front/member/information-update-form";
        });
	}
	else if(integration == '03'){
		//Dmall.LayerUtil.alert('이미 멤버쉽 통합이 완료되었습니다.','','');
		location.href = "/front/member/integration-success-form";
	}
}


</script>
		<!-- snb -->
		<div id="mypage_snb">
			<div class="mypage_snb_top">
				<p class="name"><em>${user.session.memberNm}</em>님</p>
				<c:choose>
					<c:when test="${user.session.integrationMemberGbCd eq '01'}">
						<p class="info barcode" id="btn_barcode_pop">
							<img src="/front/img/mypage/mypage_top_barcode.png" alt="">
						</p>
						<span class="member_type">정회원</span>
						<button type="button" id="btn_go_integration">멤버쉽통합<i></i></button>
					</c:when>
					<c:when test="${user.session.integrationMemberGbCd eq '02'}">
						<p class="info">다비치포인트, 마켓포인트 등의 혜택은<br>정회원께만 제공됩니다.</p>
						<span class="member_type">간편회원</span>
						<button type="button" id="btn_go_modify">정회원전환<i></i></button>
					</c:when>
					<c:when test="${user.session.integrationMemberGbCd eq '03'}">
						<p class="info barcode" id="btn_barcode_pop">
							<img src="/front/img/mypage/mypage_top_barcode.png" alt="">
						</p>
						<span class="member_type">통합멤버쉽</span>
						<button type="button" style="cursor:default;">${user.session.memberGradeNm}
							<c:choose>
								<c:when test="${user.session.memberGradeNo eq '2'}">
									<i class="icon_vip"></i>	
								</c:when>
								<c:otherwise>
									<i class="icon_normal"></i>
								</c:otherwise>
							</c:choose>
						</button>
					</c:when>
				</c:choose>
			</div>
			<div class="mypage_snb_area">
				<h2 class="mypage_snb_tit"><a href="/front/member/mypage">마이페이지</a></h2>
				<ul class="my_snb_menu">
					<li>
						<a href="#">나의 주문</a>
						<ul class="my_snb_smenu">
			                <li><a href="/front/order/order-list" <c:if test="${leftMenu eq 'order_list'}" >class="active"</c:if>>주문배송조회</a></li>
			                <li><a href="/front/order/order-cancelrequest-list" <c:if test="${leftMenu eq 'order_cancel_request'}" >class="active"</c:if>>취소/교환/반품 신청</a></li>
			                <li><a href="/front/order/order-cancel-list" <c:if test="${leftMenu eq 'order_cancel_list'}" >class="active"</c:if>>취소/교환/반품 현황</a></li>
						</ul>
					</li>
					<c:if test="${user.session.integrationMemberGbCd ne '02'}">
					<li>
						<a href="#">나의 혜택</a>
						<ul class="my_snb_smenu">
							<li><a href="/front/coupon/coupon-list" <c:if test="${leftMenu eq 'my_coupon'}" >class="active"</c:if>>D-쿠폰</a></li>
							<%--<li><a href="/front/member/savedmoney-list" <c:if test="${leftMenu eq 'my_mileage'}" >class="active"</c:if>>마켓포인트</a></li>--%>
							<li><a href="javascript:fn_go_point();" <c:if test="${leftMenu eq 'my_point'}" >class="active"</c:if>>다비치포인트</a></li>														
							<%--<li><a href="#">할인권전환</a></li>--%>
						</ul>
					</li>
					</c:if>
					<li>
						<a href="#">나의 활동</a>
						<ul class="my_snb_smenu">
							<li><a href="/front/interest/interest-item-list" <c:if test="${leftMenu eq 'interest'}" >class="active"</c:if>>관심상품</a></li>
							<li><a href="/front/member/stock-alarm" <c:if test="${leftMenu eq 'goods_sms'}" >class="active"</c:if>>재입고알림</a></li>																
							<li><a href="/front/customer/inquiry-list" <c:if test="${leftMenu2 eq 'inquiry'}" >class="active"</c:if>>문의/후기</a></li>
						</ul>
					</li>
					<c:if test="${user.session.integrationMemberGbCd ne '02'}">
					<li>
						<a href="#" class="active">나의 다비치</a>
						<ul class="my_snb_smenu">
							<%--<li><a href="/front/mypage/eyesight" <c:if test="${leftMenu eq 'eyesight'}" >class="active"</c:if>>시력정보</a></li>--%>
							<%--<li><a href="/front/mypage/prescription" <c:if test="${leftMenu eq 'prescription'}" >class="active"</c:if>>처방전</a></li>--%>
							<li><a href="/front/vision2/my-vision-check-g" <c:if test="${leftMenu eq 'my-vision-check'}" >class="active"</c:if>>추천렌즈</a></li>
							<%-- <li><a href="/front/vision2/my-vision-check-g" <c:if test="${leftMenu eq 'my-vision-check-g' || leftMenu eq 'my-vision-check-c'}" >class="active"</c:if>>비젼체크</a></li> --%>
							<%--<li><a href="/front/hearingaid/my-hearingaid-check" <c:if test="${leftMenu eq 'my-hearingaid-check'}" >class="active"</c:if>>보청기 추천</a></li>--%>
                            <li><a href="/front/visit/visit-list" <c:if test="${leftMenu eq 'visit_list'}" >class="active"</c:if>>방문예약 내역</a></li>
							<%--<li><a href="javascript:fn_go_offlineSal();" <c:if test="${leftMenu eq 'offlineSal'}" >class="active"</c:if>>가맹점 구매내역</a></li>--%>
							<li><a href="javascript:fn_go_integration();" <c:if test="${leftMenu eq 'integration_member'}">class="active"</c:if>>멤버쉽통합</a></li>
							<li><a href="javascript:fn_go_yearend_tax();" <c:if test="${leftMenu eq 'yearend_taxList'}">class="active"</c:if>>연말정산</a></li>
							<c:if test="${user.session.integrationMemberGbCd eq '03'}">
							<li><a href="/front/member/bibiem-warranty-list" <c:if test="${leftMenu eq 'bibiem_warranty'}">class="active"</c:if>>비비엠 워런티 카드</a></li>
							</c:if>
						</ul>
					</li>
					</c:if>
					<li>
						<a href="#">나의 정보관리</a>
						<ul class="my_snb_smenu">
							<li><a href="/front/member/information-update-form" <c:if test="${leftMenu eq 'modify_member'}" >class="active"</c:if>>회원정보수정</a></li>
							<c:if test="${user.session.integrationMemberGbCd ne '02'}">
								<li><a href="/front/member/member-certify-form" <c:if test="${leftMenu eq 'member_certify'}" >class="active"</c:if>>휴대폰 인증</a></li>
							</c:if>
							<li><a href="/front/member/delivery-list" <c:if test="${leftMenu eq 'delivery'}" >class="active"</c:if>>배송지관리</a></li>
							<li><a href="/front/member/refund-account" <c:if test="${leftMenu eq 'refund_account'}" >class="active"</c:if>>환불/입금계좌관리</a></li>							
							<li><a href="/front/member/member-leave-form" <c:if test="${leftMenu eq 'leave_member'}" >class="active"</c:if>>회원탈퇴</a></li>
							<li><a href="/front/member/push-message-market" <c:if test="${leftMenu eq 'push_msg_market'}" >class="active"</c:if>>메세지함(마켓)</a></li>
							<li><a href="/front/member/push-message" <c:if test="${leftMenu eq 'push_msg'}" >class="active"</c:if>>메세지함(매장)</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
		<!--// snb -->
		
<div class="popup" id="member_card_popup" style="display: none;">
    <div class="inner card">
        <div class="popup_head">
            <button type="button" class="btn_close_popup">창닫기</button>
        </div>
        <div class="popup_body">
            <div class="card_area <c:if test="${user.session.memberGradeNo eq '2'}">vip</c:if>">
				<div class="member_card_name">DAVICH Membership</div>
                <div class="member_barcode">
					<div class="member_name"><em>${user.session.memberNm}</em>님</div>
                    <div id="bcTarget_pop" style="margin: 0 auto"></div>
                    <p class="member_no"><span>NO.</span>${fn:substring(user.session.memberCardNo,0,2)} - ${fn:substring(user.session.memberCardNo,2,5)} - ${fn:substring(user.session.memberCardNo,5,9)}</p>
                </div>
            </div>			
			<div class="card_area_bottom">
				<span class="dot"><em>마켓포인트:</em> <b><fmt:formatNumber value="${memberPrcAmt }" type="currency" maxFractionDigits="0" currencySymbol=""/></b> 원</span>
				<span class="dot"><em>다비치포인트:</em><b><c:choose><c:when test="${memberPrcPoint ne null}"><fmt:formatNumber value="${memberPrcPoint }" type="currency" maxFractionDigits="0" currencySymbol=""/></c:when><c:otherwise>0</c:otherwise></c:choose></b> P</span> 
			</div>
        </div>
    </div>
</div>

<!---// 마이페이지 왼쪽 메뉴 --->
