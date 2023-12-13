<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<script>

	$(document).ready(function(){
	
        $('#sel_sidoCode').on('change',function (){
            var optionSelected = $(this).find("option:selected").val();
            
            if (optionSelected.length == 0) {
                $('#sel_guGunCode').empty();
            	$('#sel_guGunCode').append('<option value="">구/군</option>');
            	return ;
            }
            
            var url = '/front/visit/change-sido';
            var param = {def1 : optionSelected};
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                $('#sel_guGunCode').empty();
            	$('#sel_guGunCode').append('<option value="">구/군</option>');
            	
            	var sortData = result;
	            sortData.sort(function(a,b){
	            	return (a.dtlNm < b.dtlNm) ? -1 : (a.dtlNm > b.dtlNm) ? 1 : 0;
	            });
	            
                // 취득결과 셋팅
                jQuery.each(result, function(idx, obj) {
                	$('#sel_guGunCode').append('<option value="'+ obj.dtlCd + '">' + obj.dtlNm + '</option>');
                });
                
                getSidoStoreList(optionSelected);
            });
        });
        
        
        $('#sel_guGunCode').on('change',function (){
        	
            var optionSelected = $(this).find("option:selected").val();
            var url = '/front/visit/store-list';
            var sidoCode = $('#sel_sidoCode').find("option:selected").val();
            
          	//var hearingAidYn = hearingAidChk();
            var hearingAidYn = "";
            
            var param = {sidoCode : sidoCode, gugunCode : optionSelected};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
            	var address= [];
            	
            	if (result.strList.length == 0) {
                    alert('선택한 지역은 매장이 존재하지 않습니다.');
                    return false;
            	}
            	
                // 취득결과 셋팅
                jQuery.each(result.strList, function(idx, obj) {
                	var addr = obj.addr1||' '||obj.addr2;
                	var strCode = obj.strCode;
                	var strName = obj.strName;
                    address.push({"address":addr,"storeNo":strCode,"storeNm":strName});
                });
            	
                searchGeoByAddr(address);
            });
        });
        
        
        $('#custom_store_save').on('click',function (){

        	var storeNo = $('#storeNo').val(); 	
        	var storeNm = $('#storeNm').val();
        	
        	//매장
            if(storeNm == '') {
                Dmall.LayerUtil.alert("매장을 선택해 주세요.", "확인");
                return false;
            }        	
        	
            var url = '/front/visit/custom-store-update';
            var param = {storeNo : storeNo, storeNm : storeNm};
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
            	$('#customStoreNm').text(storeNm);
                
                if( !result.success){
                    Dmall.LayerPopupUtil.close("div_order_exchange");
                    Dmall.LayerUtil.alert("매장 단골설정이 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                        location.reload();
                    });
                }else{
                    Dmall.LayerPopupUtil.close("div_order_exchange");
                    Dmall.LayerUtil.alert("매장 단골설정이 완료 되었습니다.", "알림").done(function(){
                        location.reload();
                    });
                }
            });        	
        });
	});
	
	//시도별 매장목록 조회
	function getSidoStoreList(sidoCode) {
	    var url = '/front/visit/store-list';
	    
	    var param = {sidoCode : sidoCode};
	    
	    Dmall.AjaxUtil.getJSON(url, param, function(result) {
	        var address= [];
	        // 취득결과 셋팅
	        jQuery.each(result.strList, function(idx, obj) {
	            var addr = obj.addr1||' '||obj.addr2;
	            var strCode = obj.strCode;
	            var strName = obj.strName;
	            address.push({"address":addr,"storeNo":strCode,"storeNm":strName});
	        });
	
	        searchSidoGeoByAddr(address);
	    });	            
	}
	
	// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
    var searchGeoByAddr = function(address){
        // 주소-좌표 변환 객체를 생성합니다
        var geocoder = new daum.maps.services.Geocoder()
            , bounds = new daum.maps.LatLngBounds()
            , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
        ;

        // 입력받은 시/도 , 구/군 으로 매장 데이터 조회
        // 매장픽업여부 'Y' 인경우만 조회
        // 후 주소를 address 배열에 세팅한다.

//         var address= [];
//         address.push({"address":"서울특별시 중구 소공로 62 ","storeNo":"0001","storeNm":"명동점"});
//         address.push({"address":"서울특별시 강남구 대치동 670번지","storeNo":"0002","storeNm":"대치점"});
//         address.push({"address":"서울특별시 은평구 통일로 736","storeNo":"0003","storeNm":"은평점"});
//         address.push({"address":"서울특별시 양천구 오목로 227","storeNo":"0004","storeNm":"오목로점"});
//         address.push({"address":"서울특별시 강남구 신사동","storeNo":"0005","storeNm":"신사점"});
		
		setMarkers(null);
		
        // 주소로 좌표를 검색합니다
        if (address != null) {
	        address.forEach(function(item,index,array){
	            //console.log(item.address+" "+item.storeNm+" "+index)
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
	                        map: map,
	                        position: coords
	                    });
	
	                    markers.push(marker);
	                    
	                    // 인포윈도우로 장소에 대한 설명을 표시합니다
	                    var infowindow = new daum.maps.InfoWindow({
	                        content: '<div style="width:150px;text-align:center;padding:6px 0;">'+item.storeNm+'</div>',
	                        removable : true
	                    });
	                    // infowindow.open(map, marker);
	                    
	                    // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
	                    // 이벤트 리스너로는 클로저를 만들어 등록합니다
	                    // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
	                    daum.maps.event.addListener(marker, 'click', makeClickListener(map, marker, infowindow,item.address,item.storeNo,item.storeNm));
	                    //daum.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
	
	                    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	                    //map.setBounds(bounds);
	                    map.setLevel(7);
	                    map.setCenter(coords);
	                }
	            });
	
	        });
        }
        
    };
</script>


<div class="popup">
	<div class="inner cancel" style="width:780px; height: 750px;">
		<div class="popup_head">
			<h1 class="tit">매장선택</h1>
			<button type="button" class="btn_close_popup">창닫기</button>
		</div>
		<div class="popup_body"> 
			<div class="popup_tCart_outline">
					<table class="tCart_Insert">
						<caption>다비치 매장 찾기</caption>
						<colgroup>
							<col style="width:">
						</colgroup>
						<thead>
							<tr>
								<th colspan="2" class="textC">
									<p class="txt_shop01">원하는 지역을 선택해 주세요.</p>
									<select id="sel_sidoCode">
										<option>시/도</option>
										 <c:forEach items="${codeListModel}" var="list">
	                                      	  <option value="${list.dtlCd}">${list.dtlNm}</option>
	                                     </c:forEach>
										
									</select>
									<select id="sel_guGunCode">
										<option>구/군</option>
									</select>
								</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
                                  <div id="map2" style="width:100%px;height:400px;"></div>
								</td>
							</tr>
							<tr>
								<td>
									<span class="shop_tit">선택매장</span>
	                                <input type="hidden" name="storeNo" id="storeNo"><%--개발후 hidden 값으로 변경--%>
	                                <input type="text" name="storeNm" id="storeNm">
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="popup_btn_area">
					<button type="button" class="btn_review_cancel">취소</button>
					<button type="button" class="btn_review_ok" id="custom_store_save">확인</button>
				</div>


			<!-- <div class="popup_btn_area">
				<button type="button" class="btn_popup_cancel">취소</button>
				<button type="button" class="btn_popup_ok" id="custom_store_save">확인</button>
			</div> -->
		</div>
	</div>
	<%@ include file="mapApi.jsp" %>
</div>

