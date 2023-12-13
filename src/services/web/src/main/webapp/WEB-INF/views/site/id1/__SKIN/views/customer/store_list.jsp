<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 매장찾기</t:putAttribute>
	<t:putAttribute name="script">
		<%--615a2979c4cf4a0cd3c3cfd1eaf25461--%>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${snsMap.get('javascriptKey')}&libraries=services"></script>
<!-- <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7908f301e3f1e3be1d8afbeee039b908&libraries=services"></script>	 -->
    <script>
    
	var markers = [];
    var overlay = new daum.maps.CustomOverlay({zIndex:1});
    var	lat = 37.560811;
	var lon = 126.982159;
    var mapOption= {
        center: new daum.maps.LatLng(lat, lon), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
	};

    var mapContainer = document.getElementById('map'); // 지도를 표시할 div
    var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	
   	var map3 = new daum.maps.Map(document.getElementById('map3'), {
   		center: new daum.maps.LatLng(lat, lon),
   		level: 3
   	});
    
    // HTML5의 geolocation으로 사용할 수 있는지 확인합니다
    if (navigator.geolocation) {
        // GeoLocation을 이용해서 접속 위치를 얻어옵니다
        navigator.geolocation.getCurrentPosition(function(position) {
            lat = position.coords.latitude; // 위도
            lon = position.coords.longitude; // 경도
            
            var locPosition = new daum.maps.LatLng(lat, lon);
            map.setCenter(locPosition);
        });
    }    
        
   	
   	var contentNode = document.createElement('div');
 	// 커스텀 오버레이의 컨텐츠 노드에 css class를 추가합니다 
   	contentNode.className = 'placeinfo_wrap';

   	// 커스텀 오버레이의 컨텐츠 노드에 mousedown, touchstart 이벤트가 발생했을때
   	// 지도 객체에 이벤트가 전달되지 않도록 이벤트 핸들러로 daum.maps.event.preventMap 메소드를 등록합니다 
   	addEventHandle(contentNode, 'mousedown', daum.maps.event.preventMap);
   	addEventHandle(contentNode, 'touchstart', daum.maps.event.preventMap);
   	
 	// 커스텀 오버레이 컨텐츠를 설정합니다
   	overlay.setContent(contentNode);  
 	
 	// 엘리먼트에 이벤트 핸들러를 등록하는 함수입니다
   	function addEventHandle(target, type, callback) {
   	    if (target.addEventListener) {
   	        target.addEventListener(type, callback);
   	    } else {
   	        target.attachEvent('on' + type, callback);
   	    }
   	} 	
    
    // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
    var searchGeoByAddrByMap3 = function(address){
    	
        // 주소-좌표 변환 객체를 생성합니다
        var geocoder = new daum.maps.services.Geocoder()
            , bounds = new daum.maps.LatLngBounds()
            , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
        ;

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
	                    daum.maps.event.addListener(marker, 'click', makeClickListener(map3, marker, infowindow, item));
	                    //daum.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
	
	                    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	                    map3.setBounds(bounds);
	                }
	            });
	
	        });
        }
        
    };

    // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
    var searchGeoByAddr = function(address){
        // 주소-좌표 변환 객체를 생성합니다
        var geocoder = new daum.maps.services.Geocoder()
            , bounds = new daum.maps.LatLngBounds()
            , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
        ;
        
        // 주소로 좌표를 검색합니다
        if (address != null) {
	        address.forEach(function(item,index,array){
	            console.log(item.address+" "+item.storeNm+" "+index)
	            geocoder.addressSearch(item.address, function (result, status) {
	                // 정상적으로 검색이 완료됐으면
	                if (status === daum.maps.services.Status.OK) {
	                	var cont = '<div style="text-align:center;padding:6px 2px;">' + item.storeNm + '</div>';
	                    var coords = new daum.maps.LatLng(result[0].y, result[0].x);
	                    
	                    positions.length = 0;
	                    positions.push({latlng: coords, content : cont});
	                    
			            // 마커에 표시할 인포윈도우를 생성합니다
			            var infowindow2 = new daum.maps.InfoWindow({
			                content: positions[0].content // 인포윈도우에 표시할 내용
			            });

	                    // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
	                    // LatLngBounds 객체에 좌표를 추가합니다
	                    bounds.extend(coords);
	
	                    // 결과값으로 받은 위치를 마커로 표시합니다
	                    var marker = new daum.maps.Marker({
	                        map: map,
	                        position: coords
	                    });
	         			   
	                    // 인포윈도우로 장소에 대한 설명을 표시합니다
	                    var infowindow = new daum.maps.InfoWindow({
	                    	content: '<div style="width:150px;text-align:center;padding:6px 0;">'+item.storeNm+'</div>',
	                        removable : true
	                    });
	                    
	                    // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
	                    // 이벤트 리스너로는 클로저를 만들어 등록합니다
	                    // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
	                    daum.maps.event.addListener(marker, 'click', makeClickListener(map, marker, infowindow, item));
			            daum.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow2));
			            daum.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow2));
	
	                    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	                    // map.setBounds(bounds);
	                    map.setLevel(6);
	                }
	            });
	
	        });
        }
        
    };
    
    function makeOverListener(map, marker, infowindow) {
        return function() {
            infowindow.open(map, marker);
        };
    }	    

    // 인포윈도우를 표시하는 클로저를 만드는 함수입니다
    function makeClickListener(map, marker, infowindow, item) {
        return function() {
            
             var info = '<div class="popup_map_info">' +
      		   '<div class="popup_head">' +
      		   ' <h1 class="popup_tit">다비치안경 ' + item.storeNm +'</h1>' + 
      		   ' <div class="btn_close_popup" onclick="closeOverlay()">창닫기</div> '+
      		   ' </div> '+
      		   ' <div class="popup_body"> '+
     		   ' <p class="text_tel">' + item.telNo + '</p>' +
     		   ' <p class="text_add">' + item.address + '</p>' + 
               ' </div>' +
  			   '</div>' ;
  			   
  			 contentNode.innerHTML = info;  	
  			 overlay.setPosition(marker.getPosition());
  		     overlay.setMap(map);  
             
            $("#storeNo").val(item.storeNo);
            $("#storeNm").val(item.storeNm);
        };
    }

    // 인포윈도우를 닫는 클로저를 만드는 함수입니다
    function makeOutListener(infowindow) {
        return function () {
            infowindow.close();
        };
    }
    
 	// 커스텀 오버레이를 닫기 위해 호출되는 함수입니다 
    function closeOverlay() {
        overlay.setMap(null);     
    }
    
    $(document).ready(function(){
    	
    	searchGugun('00', '서울');
    	
        $("li[rel='tab02']").on('click',function (){
	            
            var geocoder = new daum.maps.services.Geocoder()
            , bounds = new daum.maps.LatLngBounds()
            , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
	        ;
            
            var level = map.getLevel(); 
            map.setLevel(2);
	     	
	        var callback = function(result, status){
	            if(status === daum.maps.services.Status.OK){
	                var sidoName = result[0].address.address_name.substring(0,2);
	                var url = '/front/visit/store-list';
	                var param = {sidoName : sidoName};
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
	                  		 str += '<li><a href="javascript:void(0);" onClick="focusMap(\''+ addr + '\')" class="pop_view_shop">';
	                  		 if(obj.cont != null && obj.cont != ''){
	                  			str += '<img src="${_SKIN_IMG_PATH}/common/crown16.png" alt="우수매장">';
	                 		 }
	                   		 str += obj.strName + '</a></li>';
	                    });
	                    
	                    $('.map_name_select ul').empty();
	                    $('.map_name_select ul').append(str);
	                    
	                    sortList();
	                    searchAllGeoByAddr(address);	                	
	                });
	            }
	        };
	
	        geocoder.coord2Address(lon, lat, callback);
        });    	
    });
    
    // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
    function searchAllGeoByAddr(address){
		setMarkers(null);

        // 주소로 좌표를 검색합니다
        if (address != null) {
			fn_addressSearch(address);
			setTimeout(function() {
				map.setCenter(new daum.maps.LatLng(lat, lon));
                //map.setLevel(3);
			}, 1000);			
        }
    };
    
    function setMarkers(map) {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(map);
        }            
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
	                    content: '<div style="width:150px;text-align:center;padding:6px 0;">'+item.storeNm+'</div>',
	                    removable : true
	
	                });
	                daum.maps.event.addListener(marker, 'click', makeClickListener(map, marker, infowindow,item));
	                map.setCenter(coords);
	                map.setLevel(6);
	            }
	        });    	
        });    	
    };    
    
    
    function sortList() {
    	var list = $(".map_name_select ul").find('li');
    	
        	list.sort(function (left, right) {
    			return $(left).text().toUpperCase().localeCompare($(right).text().toUpperCase());
        	}).each(function () {
        		$(".map_name_select ul").append(this);
        	});
    }    
    
    // 구/군 조회
    function searchGugun(sVal, sValNm) {
    	
        var url = '/front/visit/store-list';
        var param = {sidoCode : sVal};
        
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
        	
        	var str = "";
            // 취득결과 셋팅
            var sortData = result.strList;
            sortData.sort(function(a,b){
            	return (a.strName < b.strName) ? -1 : (a.strName > b.strName) ? 1 : 0;
            });
            
            jQuery.each(sortData, function(idx, obj) {
             	 if (Number(idx)%4 == 0) {
               		 str += '<ul class="sub_name"> <li>';
               		 str += '<a href="javascript:void(0);" class="pop_view_shop" onClick="storeDtlPopup(\''+ obj.strCode + '\')" >';
					 if(obj.cont != null && obj.cont != ''){
              			str += '<img src="${_SKIN_IMG_PATH}/common/crown16.png" alt="우수매장">';
             		 }
               		 str += obj.strName + '</a>';
               	 } else {    
               		 str += '<a href="javascript:void(0);" class="pop_view_shop" onClick="storeDtlPopup(\''+ obj.strCode + '\')" >';
					 if(obj.cont != null && obj.cont != ''){
              			str += '<img src="${_SKIN_IMG_PATH}/common/crown16.png" alt="우수매장">';
             		 }
               		 str += obj.strName + '</a>';
               	 }
             	 
               	 if (Number(idx)%4 == 3) {
               		 str += '</li> </ul>';
               	 }  
            });
            
            $('.body_area').empty();
            $('.body_area').append(str);
            
            $('.map_name li').find('a').removeClass("active");
            $('#' + sVal).addClass("active");
            $('#id_sidoCode').val(sVal);
        });
        
        $('#areaTtile').text(sValNm);
        
        //구/군 select 
        selectBoxGugun(sVal);
        
        
        $('#sel_guGunCode').on('change',function (){
        	
            var optionSelected = $(this).find("option:selected").val();
            var url = '/front/visit/store-list';
            var sidoCode = $('#id_sidoCode').val();
            var param = {sidoCode : sidoCode, gugunCode : optionSelected};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
            	
            	var str = "";
            	
            	if (result.strList.length == 0) {
                    Dmall.LayerUtil.alert('선택한 지역은 매장이 존재하지 않습니다.');
            	} else {
            		
	                // 취득결과 셋팅
	                jQuery.each(result.strList, function(idx, obj) {
	                 	 if (Number(idx)%4 == 0) {
	                   		 str += '<ul class="sub_name"> <li>';
	                   		 str += '<a href="javascript:void(0);" class="pop_view_shop" onClick="storeDtlPopup(\''+ obj.strCode + '\')" >';
							 if(obj.cont != null && obj.cont != ''){
	                   			str += '<img src="${_SKIN_IMG_PATH}/common/crown16.png" alt="우수매장">';
	                  		 }
	                   		 str += obj.strName + '</a>';
	                   	 } else {    
	                   		 str += '<a href="javascript:void(0);" class="pop_view_shop" onClick="storeDtlPopup(\''+ obj.strCode + '\')" >';
	                   		 if(obj.cont != null && obj.cont != ''){
	                   			str += '<img src="${_SKIN_IMG_PATH}/common/crown16.png" alt="우수매장">';
	                  		 }
	                   		 str += obj.strName + '</a>';
	                   	 }
	                 	 
	                   	 if (Number(idx)%4 == 3) {
	                   		 str += '</li> </ul>';
	                   	 }  
	                });
            	}
                
                $('.body_area').empty();
                $('.body_area').append(str);            	

            });
            
        });
    }
    
    function selectBoxGugun(sVal) {
        
        if (sVal.length == 0) {
            $('#sel_guGunCode').empty();
        	$('#sel_guGunCode').append('<option value="">구/군</option>');
        	return ;
        }
        
        var url = '/front/visit/change-sido';
        var param = {def1 : sVal};
        
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            $('#sel_guGunCode').empty();
        	$('#sel_guGunCode').append('<option value="">구/군</option>');
        	
            var sortData = result;
            sortData.sort(function(a,b){
            	return (a.dtlNm < b.dtlNm) ? -1 : (a.dtlNm > b.dtlNm) ? 1 : 0;
            });
            
            // 취득결과 셋팅
            jQuery.each(sortData, function(idx, obj) {
            	$('#sel_guGunCode').append('<option value="'+ obj.dtlCd + '">' + obj.dtlNm + '</option>');
            });
        });
    }
    
    //시도별 매장찾기
    function selectBoxStoreList(sVal) {
        
        if (sVal.length == 0) {
            $('#sel_guGunCode').empty();
        	$('#sel_guGunCode').append('<option value="">구/군</option>');
        	return ;
        }
        
        var url = '/front/visit/change-sido';
        var param = {def1 : sVal};
        
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            $('#sel_guGunCode').empty();
        	$('#sel_guGunCode').append('<option value="">구/군</option>');
        	
            // 취득결과 셋팅
            jQuery.each(result, function(idx, obj) {
            	$('#sel_guGunCode').append('<option value="'+ obj.dtlCd + '">' + obj.dtlNm + '</option>');
            });
        });
    }    
    
    function focusMap(strAddr) {
        var geocoder = new daum.maps.services.Geocoder()
        , bounds = new daum.maps.LatLngBounds();    	
        
        map3.setLevel(3);
    	
        geocoder.addressSearch(strAddr, function (result, status) {
            // 정상적으로 검색이 완료됐으면
            if (status === daum.maps.services.Status.OK) {
                var coords = new daum.maps.LatLng(result[0].y, result[0].x);
                bounds.extend(coords);
                map.setBounds(bounds);
            }
        });    	
    }
    
    
	//매장상세정보
    function storeDtlPopup(storeNo) {
		
		if (storeNo == "" || storeNo == null || storeNo == undefined) {
			return false;
		}
		
        var url = '/front/visit/store-detail-pop?storeCode=' + storeNo;
        Dmall.AjaxUtil.load(url, function(result) {
        	
            $('#div_store_detail_popup').html(result).promise().done(function(){
                //$('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
            });
            
            //Dmall.LayerPopupUtil.open($("#div_store_detail_popup"));
        	map3 = new daum.maps.Map(document.getElementById('map3'), {
    			center: new daum.maps.LatLng(37.537123, 127.005523),
    			level: 3
    		});	
        })	
    }; 
    

    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
	<!--- category header 카테고리 location과 동일 --->
    <div id="category_header">
        <div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>고객센터</li>
				<li>매장찾기</li>
			</ul>
            <!-- <span class="location_bar"></span><a>홈</a><span>&gt;</span><a>고객센터</a><span>&gt;</span>매장찾기 -->
        </div>
    </div>
    <!---// category header --->
    <!--- contents --->
    <div class="customer_middle">	
    
		<!-- snb -->
		<%@ include file="include/customer_left_menu.jsp" %> 	
		<!-- //snb -->

		<!-- content -->
		<div id="customer_content">
			<div class="customer_top_line"></div>
			<div class="customer_body">
				<h3 class="my_tit">
					매장찾기
				</h3>				
				
				<ul class="my_tabs">
					<li class="active" rel="tab01" style="width:268px">지역별로 찾기</li>
					<li rel="tab02" style="width:268px">가까운 매장찾기</li>
				</ul>
				
				<!-- tab01: 지역별로 찾기 -->
				<div class="my_tabs_content" id="tab01">
					<ul class="map_name">
						<c:forEach var="areaList" items="${areaListModel}" varStatus="g">
							<li><a href="javascript:void(0);" onClick="searchGugun('${areaList.dtlCd}', '${areaList.dtlNm}')" id="${areaList.dtlCd}">${areaList.dtlNm}</a></li>
						</c:forEach> 
					</ul>
					<input type="hidden" id="id_sidoCode" />
					<div class="map_location_detail">
						<div class="top_area">
							<p class="tit" id="areaTtile"></p>
							<select id="sel_guGunCode">
								<option value="">구/군</option>
							</select>
						</div>
						<div class="body_area">
						</div>
					</div>
				</div>
				<!--// tab01: 지역별로 찾기 -->

				<!-- tab01:  tab02: 가까운 매장찾기 -->
				<div class="my_tabs_content" id="tab02">
					<div class="near_shop">
						<div class="top_area">
						</div>
						<div class="shop_map_area">
							<div class="map_view">
    	                        <div id="map" style="width:100%px;height:460px;"></div>
							</div>
							<div class="map_name_select">
								<ul class="list">
								</ul>
							</div>
						</div>
					</div>
				</div>
				<!--// tab02: 가까운 매장찾기 -->				
			</div>
		</div>		
		<!--// content -->
		<!--// content -->
		<div class="popup" id="div_store_detail_popup" style="display:none;">
		   <div class="popup_my_store_detail" id ="popup_my_store_detail">
		       <div id="map3" style="width:100%px;height:400px;"></div>
		   </div>
		</div>		

	</div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>