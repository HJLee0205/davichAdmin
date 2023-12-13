<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>

<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">방문예약</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
	<script>
  		gtag('event', 'conversion', {'send_to': 'AW-760445332/YzznCK-hzpYBEJTzzeoC','value': 1.0,'currency': 'KRW'});
	</script>
	<%-- 텐션DA SCRIPT --%>
    <script>
        ex2cts.push('track', 'visit');
    </script>
    <%--// 텐션DA SCRIPT --%>
	<%--Cauly CPA 광고--%>
	<%--<script type="text/javascript" src="//image.cauly.co.kr/cpa/util_sha1.js" ></script>
	<script type="text/javascript">
	  var strUser = '${visitVO.memberNo}';
	  window._paq = window._paq || [];
	  _paq.push(['track_code',"a9a01f1f-8e03-4d4d-af16-1b95e46fe041"]);
	  _paq.push(['user_id',SHA1(strUser)]);
	  _paq.push(['event_name','CA_VISIT']);
	  _paq.push(['send_event']);
	  (function() { var u="//image.cauly.co.kr/script/"; var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'caulytracker_async.js'; s.parentNode.insertBefore(g,s); }
	  )();

	</script>--%>
	<%-- // Cauly CPA 광고--%>

	<!-- Enliple Tracker v3.5 [결제전환] start -->
	<script type="text/javascript">
	<!--
		function mobConv(){
			var cn = new EN();
			cn.setData("uid", "davich2");
			cn.setData("ordcode", "");
			cn.setData("qty", "1");
			cn.setData("price", "1");
			cn.setData("pnm", encodeURIComponent(encodeURIComponent("counsel")));
			cn.setSSL(true);
			cn.sendConv();
		}
	//-->
	</script>
	<script src="https://cdn.megadata.co.kr/js/en_script/3.5/enliple_min3.5.js" defer="defer" onload="mobConv()"></script>
	<!-- Enliple Tracker v3.5 [결제전환] end -->


	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${snsMap.get('javascriptKey')}&libraries=services"></script>
    <script>
    
	
	var map3 = new daum.maps.Map(document.getElementById('map3'), {
		center: new daum.maps.LatLng(37.537123, 127.005523),
		level: 3
	});

    // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
    function searchGeoByAddrByMap3(address){
    	
        // 주소-좌표 변환 객체를 생성합니다
        var geocoder = new daum.maps.services.Geocoder()
            , bounds = new daum.maps.LatLngBounds()
            , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
        ;

        // 주소로 좌표를 검색합니다
        if (address != null) {
	        address.forEach(function(item,index,array){
	            geocoder.addressSearch(item.address, function (result, status) {
	                // 정상적으로 검색이 완료됐으면
	                if (status === daum.maps.services.Status.OK) {
	                    // positions.push( {"latlng": new daum.maps.LatLng(result[0].y, result[0].x)})
	
	                    var coords = new daum.maps.LatLng(result[0].y, result[0].x);
	                    // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
	                    // LatLngBounds 객체에 좌표를 추가합니다
	                    bounds.extend(coords);
	
	                    // 결과값으로 받은 위치를 마커로 표시합니다
	                    var marker = new daum.maps.Marker({
	                        map: map3,
	                        position: coords
	                    });
	
	                    // 인포윈도우로 장소에 대한 설명을 표시합니다
	                    var infowindow = new daum.maps.InfoWindow({
	                        content: '<div style="width:150px;text-align:center;padding:6px 0;">'+item.storeNm+'</div>',
	                        removable : true
	
	                    });
	                    // infowindow.open(map, marker);
	                    
	                    // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
	                    // 이벤트 리스너로는 클로저를 만들어 등록합니다
	                    // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
	                    daum.maps.event.addListener(marker, 'click', makeClickListener(map3, marker, infowindow,item.storeNo,item.storeNm));
	                    //daum.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
	
	                    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	                    map3.setBounds(bounds);
	                }
	            });
	
	        });
        }
        
    };
    
    $(document).ready(function(){
        /* 홈 */
        $(".btn_go_home02").click(function(){
            location.href="${_MOBILE_PATH}/front/main-view";
        });
        
        /* 예약목록 */
        $(".btn_check_visit").click(function(){
            location.href="${_MOBILE_PATH}/front/visit/visit-list";
        });
        
        
    	$(".btn_map_shop").click(function() {
    		var storeNo = $('#storeNo').val();
    		
		    var url = '${_MOBILE_PATH}/front/visit/store-detail-pop?storeCode=' + storeNo;
		    Dmall.AjaxUtil.load(url, function(result) {
	            $('#div_store_detail_popup').html(result).promise().done(function(){
	                //$('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
	            });
	            
	            map3 = new daum.maps.Map(document.getElementById('map3'), {
	                center: new daum.maps.LatLng(37.537123, 127.005523),
	                level: 3
	            });	            
	            
		    })	
		 });		         
    });
    
    // 인포윈도우를 표시하는 클로저를 만드는 함수입니다
    function makeClickListener(map, marker, infowindow,address,storeNo,storeNm) {
        return function() {
            infowindow.open(map, marker);
        };
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			방문예약
		</div>
		
		<div class="visit_completed_area">
			<i class="icon_visit_completed"></i>
			<p class="tit">방문예약 완료</p>
			<c:if test="${fn:length(cpVoList) > 0}">
			<div class="visit_coupon">
				<c:forEach var="cpVoList" items="${cpVoList}" varStatus="status">
				<em>“${cpVoList.couponNm}”</em>
				</c:forEach>
				<br>쿠폰이 발급 되었습니다.
				<a href="${_MOBILE_PATH}/front/coupon/coupon-list">내 쿠폰함<span>></span></a>
			</div>
			</c:if>
			<div class="visit_completed_detail">
				<c:if test="${(memberYn ne null and memberYn=='Y') or user.login}">
				<p class="stit">"${visitVO.memberNm}님, 예약하신 날짜, 시간에 잊지말고 방문해 주세요."</p>
				</c:if>
				<c:if test="${memberYn ne null and memberYn=='N' and !user.login}">
				<p class="stit">"${nomemberNm}님, 예약하신 날짜, 시간에 잊지말고 방문해 주세요."</p>
				</c:if>
				<div class="left">
					<span>예약일시</span>
					<em>${visitVO.strVisitDate}</em>
				</div>
				<div class="right">
					<span>방문하실 다비치안경매장</span>
					<em>${visitVO.storeNm} <button type="button" class="btn_map_shop">지도보기</button></em>
					<input type="hidden" id="storeNo" value="${visitVO.storeNo}">
				</div>
			</div>
			<p class="info_text">
			<c:if test="${(memberYn ne null and memberYn=='Y') or user.login}">자세한 예약내역은 <a href="#">마이페이지 > 방문예약 메뉴</a>에서 확인하실 수 있습니다.</c:if>
			</p>

			<!-- 렌즈예약고객 추가 -->
<!-- 			<p class="info_text">렌즈예약고객에게만 제공되는 <br>매장구매 할인쿠폰도 발급되었습니다.<br> -->
<!-- 			쿠폰함에서 확인하시고 매장방문시 꼭 챙기세요~.</p> -->
			<!--// 렌즈예약고객 추가 -->

			<div class="visit_btn_area">
				<button type="button" class="btn_go_home02">홈 화면으로</button>
				<c:if test="${(memberYn ne null and memberYn=='Y') or user.login}">
				<button type="button" class="btn_check_visit">예약내역확인</button>
				</c:if>
			</div>
		</div><!-- //visit_completed_area -->
	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
    
	<!--  popup -->
	<div class="popup" id="div_store_detail_popup" style="display:none;">
          <div id="map3"></div>
	</div>		
    
    </t:putAttribute>
</t:insertDefinition>