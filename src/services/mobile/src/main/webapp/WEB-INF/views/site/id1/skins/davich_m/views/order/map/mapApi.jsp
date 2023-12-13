<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
 <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${snsMap.get('javascriptKey')}&libraries=services"></script>
<!-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7908f301e3f1e3be1d8afbeee039b908&libraries=services"></script> -->
<script>
	var markers = [];
	var infowindows = [];
	var lat = 37.560811;
    var lon = 126.982159;   
	
    var mapContainer = document.getElementById('map'); // 지도를 표시할 div
    var     mapOption= {
        center: new daum.maps.LatLng(37.560811, 126.982159), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };
    var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
    
    // HTML5의 geolocation으로 사용할 수 있는지 확인합니다
    if (navigator.geolocation) {
    	
        // GeoLocation을 이용해서 접속 위치를 얻어옵니다
        navigator.geolocation.getCurrentPosition(function(position) {
            lat = position.coords.latitude; // 위도
            lon = position.coords.longitude; // 경도
           
            var locPosition = new daum.maps.LatLng(lat, lon);
            
            map.setCenter(locPosition);
        }, error);

    } else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
    	lat = 33.450701;
    	lon = 126.570667;   
        var locPosition = new daum.maps.LatLng(lat, lon);
        map.setCenter(locPosition);
    }
    
    if (lat == undefined || lon == undefined) {
    	lat = 37.560811;
	    lon = 126.982159;   
    }
    
    function error(err) {
  	  console.log('ERROR(' + err.code + '): ' + err.message);
	};        
    
    
//  	// 주소-좌표 변환 객체를 생성합니다
//     var geocoder = new daum.maps.services.Geocoder();    
 	
//     var callback = function(result, status){
//         if(status === daum.maps.services.Status.OK){
//             alert("지역명 : " + result[0].address.address_name);
//         }
//     };

//     geocoder.coord2Address(lon, lat, callback);


   	if (isAndroidWebview()) {
       davichapp.bridge_get_location();
    } 	    	
 		    	
    if (isIOSWebview()) {
 	    window.webkit.messageHandlers.davichapp.postMessage({
	   	       func: 'bridge_get_location',
   	   });    	
    }	            	

	// 현재 위치 세팅
    function getCurrentLocation(lon2, lat2) {
    	lon = lon2;
    	lat = lat2;
    }


    function setMarkers(map) {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(map);
        }            
        setInfowindows();
    }
    
    function setInfowindows() {
	    for (var i = 0; i < infowindows.length; i++) {
	        infowindows[i].close();
	    }
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
                        map.setCenter(coords);
	                    //map.setLevel(8);
	                    
// 	                    if (item.address.indexOf("경산시") != -1) {
// 		                    map.setLevel(10);
// 	            		} else if(item.address.indexOf("울산") != -1){
// 	            			map.setLevel(9);
// 	            		} else {
// 		                    map.setLevel(8);
// 	            		} 

	                    map.setLevel(10);
	                    
	                }
	            });
	
	        });
	        
            //map.setCenter(new daum.maps.LatLng(lat, lon));
        }
    };    

    // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
    function searchAllGeoByAddr(address){
		setMarkers(null);

        // 주소로 좌표를 검색합니다
        if (address != null) {
			fn_addressSearch(address);
			setTimeout(function() {
				map.setCenter(new daum.maps.LatLng(lat, lon));
                map.setLevel(3);
			}, 1000);			
        }
    };
    
    
    // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
    function searchSidoGeoByAddr(address){
		setMarkers(null);
        // 주소로 좌표를 검색합니다
        if (address != null) {
			fn_addressSearch(address);
			setTimeout(function() {
                map.setLevel(10);
			}, 1000);			
        }
    };    

    $(document).ready(function(){
    	
        // to 김부장님 : 시군구 select 조회로 변경해야합니다.
        //searchGeoByAddr();
        var geocoder = new daum.maps.services.Geocoder()
        , bounds = new daum.maps.LatLngBounds()
        , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
        ;
        
        var level = map.getLevel(); 
        map.setLevel(2);
     	
        var callback = function(result, status){
            if(status === daum.maps.services.Status.OK){
                var sidoName = result[0].address.address_name.substring(0,2);
                
                var hearingAidYn = hearingAidChk();
                if (hearingAidYn != "Y") {
                	hearingAidYn = "";
                }
                
                if('${isHa}' == 'Y') hearingAidYn = 'Y';
                
                var erpItmCode = "";
	            $('input[name="erpItmCode"]').each(function() {
	            	if(erpItmCode != "") erpItmCode += ",";
	            	if($(this).val() != "") erpItmCode += $(this).val();
	            });

                var url = '${_MOBILE_PATH}/front/visit/store-list';
                var param = {sidoName : sidoName, hearingAidYn : hearingAidYn, erpItmCode : erpItmCode};
				var str = "";
				
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                	var address= [];
                	
                    // 취득결과 셋팅
                    jQuery.each(result.strList, function(idx, obj) {
                    	var addr = obj.addr1||' '||obj.addr2;
                    	var strCode = obj.strCode;
                    	var strName = obj.strName;
                    	var telNo = obj.telNo;
                        address.push({"address":addr,"storeNo":strCode,"storeNm":strName, "telNo":telNo});
                  		 str += '<li><a href="javascript:void(0);" onClick="focusMap(\''+ addr + '\')" class="pop_view_shop">' + obj.strName + '</a></li>';
                    });
                    searchAllGeoByAddr(address);	
                });
            }
        };

        geocoder.coord2Address(lon, lat, callback);        

    });
    


    // 인포윈도우를 표시하는 클로저를 만드는 함수입니다
    function makeClickListener(map, marker, infowindow,address,storeNo,storeNm) {
        return function() {
        	setInfowindows();
        	
            infowindow.open(map, marker);
            infowindows.push(infowindow);
            
            $("#numAddr_02").val(address);
            $("#storeNo").val(storeNo);
            $("#storeNm").val(storeNm);
            $("#visitStore").text(storeNm);
            
        	$('input[name=rsvDate]').val("");
        	$('input[name=rsvTime]').val("");
        	$('input[name=rsvTimeText]').val("");
            
            try{
                //방문예약페이지에서만 작동...
                // 매장별 휴일 가져오기
                getHoliday(storeNo, today().substring(0,6));
            }catch(e){

            }
        };
    }
    // 인포윈도우를 닫는 클로저를 만드는 함수입니다
    function makeOutListener(infowindow) {
        return function () {
            infowindow.close();
        };
    }
    
    function getTimeTableList(strDate) {

		 //혼잡시간표 가져오기
		 var week = new Date(strDate).getDay();
         var url = '${_MOBILE_PATH}/front/visit/time-table';
         var param = {storeCode : $('#storeNo').val(), week : week+1 };
         Dmall.AjaxUtil.getJSON(url, param, function(result) {

       	 var str = "";	
            jQuery.each(result.storeChaoticList, function(idx, obj) {
           	 
           	 var chaotic = "";
           	 if (obj.chaotic == "01") {
           		 chaotic = '</span><p class="state green">' + obj.chaoticName +'</p></li>';
           	 } else if (obj.chaotic == "02") {
           		 chaotic = '</span><p class="state orange">' + obj.chaoticName +'</p></li>';
           	 } else {
           		 chaotic = '</span><p class="state red">' + obj.chaoticName +'</p></li>';
           	 }
           	 
           	 var hour = obj.hour;
           	 if (hour.length > 0 && hour.length == 4) hour = hour.substring(0,2)+':'+ hour.substring(2,4);
           	 
           	 if (Number(idx)%6 == 0) {
           		 str += '<li><ul class="time_table">';
           		 str += '<li><span class="time"><a href="javascript:void(0);" onclick="setVisitTime(\''+obj.hour+'\');" >' + hour + '</a>' + chaotic;
           	 } else {    
           		 str += '<li><span class="time"><a href="javascript:void(0);" onclick="setVisitTime(\''+obj.hour+'\');" >' + hour + '</a>' + chaotic;
           	 }
           	 
           	 if (Number(idx)%6 == 5) {
           		 str += '</ul></li>';
           	 }
           	
           	//방문시간 
            	//$('#sel_visitTime').append('<option value="'+ obj.hour + '">' + hour + '</option>');
           	
            });
            
            $('.time_table_list').empty();
            $('.time_table_list').append(str);
        });    	
    	
    }
    
    function setVisitTime(hour) {
     	 if (hour.length > 0 && hour.length == 4) {
     		 var time = hour.substring(0,2)+':'+ hour.substring(2,4);
     	 }
    	
    	$('#sel_visitTime').filter('select').val(hour);
    	$('#sel_visitTime').filter('input').val(time);
    }
    
    
    // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
    function fn_addressSearch(address){
    	
        var geocoder = new daum.maps.services.Geocoder()
	        , bounds = new daum.maps.LatLngBounds()
	        , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
	    ;
        
        address.forEach(function(item,index,array){
	    	geocoder.addressSearch(item.address, function (result, status) {
	            // 정상적으로 검색이 완료됐으면
	            if (status === daum.maps.services.Status.OK) {
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
	                    content: '<div style="width:200px;text-align:center;padding:6px 0;">'+item.storeNm+'</div>',
	                    removable : true
	
	                });
	                daum.maps.event.addListener(marker, 'click', makeClickListener(map, marker, infowindow,item.address,item.storeNo,item.storeNm));
	                map.setCenter(coords);
	                map.setLevel(9);
	            }
	        });    	
        });    	
    };
    

</script>