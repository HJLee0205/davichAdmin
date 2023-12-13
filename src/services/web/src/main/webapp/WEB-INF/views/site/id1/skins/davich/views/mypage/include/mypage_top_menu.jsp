<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${snsMap.get('javascriptKey')}&libraries=services"></script>

<script>
$(document).ready(function(){
	
	
    $(".btn_setting_shop").on('click', function() {
    	
        var url = '/front/visit/store-map-pop';
        Dmall.AjaxUtil.load(url, function(result) {
        	
            $('#div_store_popup').html(result).promise().done(function(){
                $('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
            }); ;
            
            Dmall.LayerPopupUtil.open($("#div_store_popup"));
            
        	map = new daum.maps.Map(document.getElementById('map2'), {
    			center: new daum.maps.LatLng(37.537123, 127.005523),
    			level: 3
    		});	
        	
            // HTML5의 geolocation으로 사용할 수 있는지 확인합니다
            if (navigator.geolocation) {
                // GeoLocation을 이용해서 접속 위치를 얻어옵니다
                navigator.geolocation.getCurrentPosition(function(position) {
                    var lat = position.coords.latitude, // 위도
                        lon = position.coords.longitude; // 경도
                    var locPosition = new daum.maps.LatLng(lat, lon);
                    
                    console.log(lat+" , "+lon)
                    map.setCenter(locPosition);
                });
                
            } else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
            	var lat = 33.450701,
            	    lon = 126.570667;   
                var locPosition = new daum.maps.LatLng(lat, lon);
                map.setCenter(locPosition);
            }
            
            if (lat == undefined || lon == undefined) {
            	lat = 37.560811;
        	    lon = 126.982159;   
            }        	
        })	
   }); 
    
   var url = '/front/visit/custom-store-info';
   Dmall.AjaxUtil.load(url, function(result) {
    	var rs = JSON.parse(result);

    	if (rs.data.customStoreNm != null) {
        	$('#customStoreNm').text(rs.data.customStoreNm);
        	$('#customStoreNo').val(rs.data.customStoreNo);
    	} else {
    		$('#customStoreNm').text('설정안함');
    	}
    });
   
   $('.btn_member_type').click(function(){
	   location.href = '/front/member/information-update-form';
   });

});
</script>
		<!-- top -->
			<div class="mypage_basic">
				<c:choose>
					<c:when test="${user.session.integrationMemberGbCd eq '02'}">
						<!-- <div class="mypage_basic"> -->
							<div>
							<div class="change_member_type">
								<b>${user.session.memberNm}</b> 님은 다비치마켓 <em>간편로그인 회원</em>이십니다.
								<p>회원양식에 추가 정보를 모두 입력해 주시면쿠폰 마켓포인트 등 다양한 혜택이 제공되는 <b>정회원으로 바로 전환</b>됩니다.</p>
							</div>
							<button type="button" class="btn_member_type">정회원 전환하기</button>
						</div>
					</c:when>
					<c:otherwise>
						<div class="mypage_basic_box left">
							<div class="tit_head">
								<%--다비치안경 통합멤버쉽--%>
								회원등급
							</div>
							<div class="text_body">
								<c:choose>
									<c:when test="${user.session.memberGradeNo eq '2'}">
										<i class="icon_vip"></i>	
									</c:when>
									<c:otherwise>
										<i class="icon_normal"></i>
									</c:otherwise>
								</c:choose>
								<em class="level">${user.session.memberGradeNm}</em>
								<!--i class="icon_normal"></i><em class="level">일반</em-->
							</div>
						</div>
						<div class="mypage_basic_box right">
							<div class="tit_head">
								<p class="left"><em>${user.session.memberNm}</em> 님 혜택요약</p>
								<p class="right">	
									단골설정 : <span id="customStoreNm">${member_info.data.customStoreNm}</span>
									<input type="hidden" id="customStoreNo" value="${member_info.data.customStoreNo}" >
									<button type="button" class="btn_setting_shop">설정하기</button>
								</p>
							</div>
							<div class="text_body normal">
								<div class="box">
									<span class="tit"><i class="icon_basic01"></i>D-쿠폰</span>
									<span class="text">
										<a href="/front/coupon/coupon-list">
											<em><fmt:formatNumber value="${memberCouponCnt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>장
										</a>
									</span>
								</div>
								<%--<div class="box">
									<span class="tit"><i class="icon_basic02"></i>마켓포인트</span>
									<span class="text">
										<a href="/front/member/savedmoney-list">
											<em><fmt:formatNumber value="${memberPrcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
										</a>
									</span>
								</div>--%>
								<div class="box">
									<span class="tit"><i class="icon_basic03"></i>다비치포인트</span>
									<span class="text">
										<c:choose>
											<c:when test="${memberPrcPoint ne null}">
												<a href="/front/member/point">
													<em><fmt:formatNumber value="${memberPrcPoint}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>P
												</a>
											</c:when>
											<c:otherwise>
												<em>-</em>
											</c:otherwise>
										</c:choose>
									</span>
								</div>
								<%--<div class="box">
									<span class="tit"><i class="icon_basic04"></i>할인권</span>
									<span class="text"><em>0</em>장</span>
								</div>--%>
							</div>
						</div>
					</c:otherwise>
				</c:choose>				
			</div>		
		<!--// top -->

    
<div class="popup" id="div_store_popup" style="display: none;">
   <div class="popup_my_custom_store" id ="popup_my_custom_store">
       <div id="map2" style="width:100%px;height:400px;"></div>
   </div>
</div>


    