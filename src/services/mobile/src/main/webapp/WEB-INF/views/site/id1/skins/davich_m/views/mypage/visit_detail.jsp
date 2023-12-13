<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">방문예약</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
	<link rel="stylesheet" type="text/css" href="${_MOBILE_PATH}/front/css/fullcalendar.css" />
	<script src="${_MOBILE_PATH}/front/js/moment.min.js" charset="utf-8"></script>
    <script src="${_MOBILE_PATH}/front/js/fullcalendar.js" charset="utf-8"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${snsMap.get('javascriptKey')}&libraries=services"></script>
    <script>
	
	var map3 = new daum.maps.Map(document.getElementById('map3'), {
		center: new daum.maps.LatLng(37.537123, 127.005523),
		level: 3
	});

	var eventData = [];
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
        //페이징
        //jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        //달력
        //$( ".datepicker" ).datepicker();
        
        //검색
//         $('.btn_form').on('click', function() {
//             if($("#ordDayS").val() == '' || $("#ordDayE").val() == '') {
//                 Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
//                 return;
//             }
//             var data = $('#form_id_search').serializeArray();
//             var param = {};
//             $(data).each(function(index,obj){
//                 param[obj.name] = obj.value;
//             });
//             Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-list', param);
//         });

        $('.btn_info_cancel').on('click', function() {
        	var visitPurposeCd = "${visitVO.visitPurposeCd }";
        	if(visitPurposeCd == '07') {
        		Dmall.LayerUtil.alert('시험착용 목적일 경우에는 취소가 불가능합니다.','','');
        		return false;
        	}
            var url = '${_MOBILE_PATH}/front/visit/rsv-cancel-update';
            var rsvNo = $('#rsvNo').val();
            var param = {rsvNo : rsvNo};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerUtil.alert("예약취소가 처리 되었습니다.", "알림");
                    location.href="${_MOBILE_PATH}/front/visit/visit-list";
                }
            });
        });
        
        $('.btn_move_prev').on('click', function() {
		    history.back();
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

		//예약 날짜 변경 클릭
		$("#btnChgDate").click(function() {
			$("#layer_change").show();
		});

		 $(".popup_visit01").click(function() {
				$('.popup_date').show();

				var storeNo = $('#storeNo').val();
            	getHoliday(storeNo, today().substring(0, 6));

				$('.popup_date #calendar').fullCalendar({
						header: {
							left: 'none',
							center: 'title'
						},
						titleFormat: {
							month:'YYYY. MM'
						},
						buttonText: {
							today:'오늘'
						},
						dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
						events: eventData,
						dayClick: function(date, allDay, jsEvent, view) {
							var clalityYn ="N";
							var teanseanYn ="N";
							var teanMiniYn ="${teanseonMiniYn}";
							var trevuesYn="N";
                        		var teanseanSampleYn="N";
							 $('[name=goodsNo]').each(function(){
								if($(this).val() =='G1907101559_5479'){
									clalityYn = "Y";
								}
								if($(this).val() =='G2002141031_7301'){
									teanseanYn = "Y";
								}
								if($(this).val() =='G2104082005_8744'){
										trevuesYn = "Y";
									}

									if($(this).val() =='G2103261158_8727'){
										teanseanSampleYn = "Y";
									}
							 });

							 if(teanseanYn=='Y'){
								var year = '2020';
								var month = '04';
								var day = '17';
								var startDate = new Date();
								startDate.setFullYear(year, month - 1, day);
								if(date.format("YYYYMMDD") < startDate.format("yyyyMMdd")) {
									  Dmall.LayerUtil.alert("예약 불가능한 일자입니다. <br>" +
									   "4/17~5/31 사이의 날짜만 선택 하실 수 있습니다.", "확인");
									return false;
								}
								var year = '2020';
								var month = '05';
								var day = '31';
								var endDate = new Date();
								endDate.setFullYear(year, month - 1, day);

								if(date.format("YYYYMMDD") > endDate.format("yyyyMMdd")) {
									 Dmall.LayerUtil.alert("예약 불가능한 일자입니다. <br>" +
									   "4/17~5/31 사이의 날짜만 선택 하실 수 있습니다.", "확인");
									return false;
								}
							 }

							 if(teanMiniYn=='Y'){
								var year = '2020';
								var month = '08';
								var day = '08';
								var startDate = new Date();
								startDate.setFullYear(year, month - 1, day);
								if(date.format("YYYYMMDD") < startDate.format("yyyyMMdd")) {
									  Dmall.LayerUtil.alert("예약 불가능한 일자입니다. <br>" +
									   "8/8~8/16 사이의 날짜만 선택 하실 수 있습니다.", "확인");
									return false;
								}
								var year = '2020';
								var month = '08';
								var day = '16';
								var endDate = new Date();
								endDate.setFullYear(year, month - 1, day);

								if(date.format("YYYYMMDD") > endDate.format("yyyyMMdd")) {
									 Dmall.LayerUtil.alert("예약 불가능한 일자입니다. <br>" +
									   "8/8~8/16 사이의 날짜만 선택 하실 수 있습니다.", "확인");
									return false;
								}
							 }

							 if(trevuesYn=='Y'){
								var year = '2021';
								var month = '05';
								var day = '10';
								var startDate = new Date();
								startDate.setFullYear(year, month - 1, day);
								if(date.format("YYYYMMDD") < startDate.format("yyyyMMdd")) {
									  Dmall.LayerUtil.alert("예약 불가능한 일자입니다. <br>" +
									   "05/10~05/21 사이의 날짜만 선택 하실 수 있습니다.", "확인");
									return false;
								}
								var year = '2021';
								var month = '05';
								var day = '21';
								var endDate = new Date();
								endDate.setFullYear(year, month - 1, day);

								if(date.format("YYYYMMDD") > endDate.format("yyyyMMdd")) {
									 Dmall.LayerUtil.alert("예약 불가능한 일자입니다. <br>" +
									   "05/10~05/21 사이의 날짜만 선택 하실 수 있습니다.", "확인");
									return false;
								}
							 }

							 if(teanseanSampleYn=='Y'){
								var year = '2021';
								var month = '05';
								var day = '31';
								var startDate = new Date();
								startDate.setFullYear(year, month - 1, day);
								if(date.format("YYYYMMDD") < startDate.format("yyyyMMdd")) {
									  Dmall.LayerUtil.alert("예약 불가능한 일자입니다. <br>" +
									   "05/31~06/11 사이의 날짜만 선택 하실 수 있습니다.", "확인");
									return false;
								}
								var year = '2021';
								var month = '06';
								var day = '11';
								var endDate = new Date();
								endDate.setFullYear(year, month - 1, day);

								if(date.format("YYYYMMDD") > endDate.format("yyyyMMdd")) {
									 Dmall.LayerUtil.alert("예약 불가능한 일자입니다. <br>" +
									   "05/31~06/11 사이의 날짜만 선택 하실 수 있습니다.", "확인");
									return false;
								}
							 }

							 $("#calendar").fullCalendar('refetchEvents');

							 var events = $('#calendar').fullCalendar('clientEvents');
							 for (var i = 0; i < events.length; i++) {
								 if (events[i].className == 'visit_disabled' && convertDate(events[i].start) == date.format("YYYY-MM-DD")) {
									  //Dmall.LayerUtil.alert("해당 선택일은 방문예약을 할수 없습니다.", "확인");
										Dmall.LayerUtil.alert("<알림> <br>"+
										"고객님게서 선택하신 안경원("+$('#storeNm').val()+")은<br>"+
										"해당 일정에 정기 휴무 입니다.<br>"+
										"다른 일자 또는 해당 일정의 다른 매장의 예약을 부탁드립니다.<br>"+
										"[전 매장 정기 휴무 : 설, 추석 명절 당일]<br>", "확인");
									  return false;
								 }
								 if (events[i].className == 'visit_delivery_disabled' && convertDate(events[i].start) == date.format("YYYY-MM-DD")) {
                                  Dmall.LayerUtil.alert("[알림]<br>고객님께서 선택하신 일정은 예약이 불가합니다.<br>다른 일자 또는 다른 매장의 예약을 부탁드립니다.<br>고맙습니다. ", "확인");
                                  return false;
                             	}
							 }

							 $("#calendar").fullCalendar('renderEvent',{
								 start: date.format("YYYY-MM-DD"),
								 end: date.format("YYYY-MM-DD"),
								 className:'visit_abled'
							 });

							 var clalityYn ="N"; //G1907101559_5479
							var teanseanYn ="N"; //G2002141031_7301
							var trevuesYn="N";
                        		var teanseanSampleYn="N";

							$('[name=goodsNo]').each(function(){
								if($(this).val() =='G1907101559_5479'){
									clalityYn = "Y";
								}
								if($(this).val() =='G2002141031_7301'){
									teanseanYn = "Y";
								}
								if($(this).val() =='G2104082005_8744'){
										trevuesYn = "Y";
									}

									if($(this).val() =='G2103261158_8727'){
										teanseanSampleYn = "Y";
									}
							 });

							 if(teanseanYn=='Y'){
								$("#calendar").fullCalendar('renderEvent', {
									start    : date.format("YYYY-MM-DD"),
									end      : date.format("YYYY-MM-DD"),
									className: 'visit_disabled'
								});

								var startDate = new Date("4/17/2020");
								var endDate = new Date("5/31/2020");


								 $("#calendar").fullCalendar('renderEvent', {
									start    : startDate.format("YYYY-MM-DD"),
									end      : endDate.format("YYYY-MM-DD"),
									className: 'visit_abled'
								});
							 }

							 var storeNo = $('#storeNo').val();
							 var sucess = true ;
							 if (storeNo == '' || storeNo == undefined) {
								  $("#calendar").fullCalendar('refetchEvents');
								  Dmall.LayerUtil.alert("방문하실 매장을 먼저 선택해 주세요.","확인");
								  return false;
							 }

							 if (today() > date.format("YYYYMMDD")) {
								  $("#calendar").fullCalendar('refetchEvents');
								  Dmall.LayerUtil.alert("오늘 날짜 이후로 선택해 주세요.","확인");
								  return false;
							 }

							 var preChk = "${orderInfo.data.exhibitionYn}";
							 if (preChk == "Y") {
								 if (date.format("YYYYMMDD") < "20190510" || date.format("YYYYMMDD") > "20190531") {
									  $("#calendar").fullCalendar('refetchEvents');
									  Dmall.LayerUtil.alert("사전예약상품 구매를 위한 방문희망일은 '2019년 5월10일 ~ 5월31일' 사이의 기간만 선택 가능합니다.","확인");
									  return false;
								 }
							 }

							 $('.popup_date').hide();

							 $('#storeTitle').text($('#storeNm').val() + "  :  " + date.format("YYYY년 MM월 DD일"));  //매장

							 //방문정보 setting
							 $('input[name=rsvDate]').val(date.format("YYYY-MM-DD"));
							 $('input[name=rsvTime]').val("");
							 $('input[name=rsvTimeText]').val("");
						}
					});

					 // 왼쪽 버튼을 클릭하였을 경우
					 $("button.fc-prev-button").click(function() {
						   var date = jQuery("#calendar").fullCalendar("getDate");
						   var storeCode = $("#storeNo").val();
						   var targetYM = convertYm(date);

						   // 매장별 휴일가져오기
						   getHoliday(storeCode, targetYM);
					 });

					   // 오른쪽 버튼을 클릭하였을 경우
					 $("button.fc-next-button").click(function() {
						   var date = jQuery("#calendar").fullCalendar("getDate");
						   var storeCode = $("#storeNo").val();
						   var targetYM = convertYm(date);

						   // 매장별 휴일가져오기
						   getHoliday(storeCode, targetYM);
					 });

					  var date = jQuery("#calendar").fullCalendar("getDate");
						   var storeCode = $("#storeNo").val();
						   var targetYM = convertYm(date);

						   // 매장별 휴일가져오기
						   getHoliday('storeCode', targetYM);


				  /*  var CAL = $('#calendar').fullCalendar('getCalendar');
					CAL.addEventSource(eventData);*/
			});

        // 방문예약시간
		$(".popup_visit02").click(function() {

			var rsvDate = $('input[name=rsvDate]').val();

			//날짜
			if(rsvDate == '' || rsvDate.length < 8) {
				$('.popup_time').hide();
				Dmall.LayerUtil.alert("예약 날짜를 선택해 주세요.","확인");
				return false;
			}

			$('.popup_time').show();
			getTimeTableListB(rsvDate);
		});
		$(".btn_close_popup").click(function() {
			$('.popup_date').hide();
		});

		$(".btn_close_popup").click(function() {
			$('.popup_time').hide();
		});

		// 예약변경일자 변경
		$(".btn_go_receipt").click(function () {

			var rsvNo = $("#rsvNo").val();
			var rsvDate = $('input[name=rsvDate]').val();
        	var rsvTime = $('input[name=rsvTime]').val();

			if (rsvNo == '' || rsvNo == undefined) {
				Dmall.LayerUtil.alert("방문예약을 선택하세요", "알림");
				return ;
			}
			//날짜
			if(rsvDate == ''  || rsvDate == undefined) {
				Dmall.LayerUtil.alert("예약 날짜를 선택해 주세요.","확인");
				return false;
			}
			//시간
			if(rsvTime == ''  || rsvTime == undefined) {
				Dmall.LayerUtil.alert("예약 시간을 선택해 주세요.","확인");
				return false;
			}

			var visitPurposeNm = ' ';
			var url = '${_MOBILE_PATH}/front/visit/add-visit-book';
			var param = {rsvNo: rsvNo, visitPurposeNm:visitPurposeNm,rsvDate : rsvDate, rsvTime : rsvTime};

			Dmall.AjaxUtil.getJSON(url, param, function(result) {

				if(result.success) {
					Dmall.LayerUtil.alert("방문예약정보가 변경되었습니다.", "알림");
				}
			});

		});
    });
	// 년월 변경
		    function convertYm(date) {
		        var date = new Date(date);
		        var year  = date.getFullYear();
		        var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
		        var day   = date.getDate();

		        if (("" + month).length == 1) { month = "0" + month; }
		        if (("" + day).length   == 1) { day   = "0" + day;   }

				return year + month;
		    }

			// 날짜 변경
		    function convertDate(date) {
		        var date = new Date(date);
		        var year  = date.getFullYear();
		        var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
		        var day   = date.getDate();

		        if (("" + month).length == 1) { month = "0" + month; }
		        if (("" + day).length   == 1) { day   = "0" + day;   }

				return year + "-" + month + "-" +  day;
		    }


		  // 기간 날짜 가져오기
		  function getDates(startDate, endDate) {
		    	  var dates = [],
		    	      currentDate = startDate,
		    	      addDays = function(days) {
		    	        var date = new Date(this.valueOf());
		    	        date.setDate(date.getDate() + days);
		    	        return date.format('yyyy-MM-dd');
		    	      };
		    	  while (currentDate <= endDate) {
		    	    dates.push(currentDate);
		    	    currentDate = addDays.call(currentDate, 1);
		    	  }
		    	  return dates;
		  };

		  // 요일 구하기
		  function dayOfWeek(strDate) {
		  	var week = ['(일)', '(월)', '(화)', '(수)', '(목)', '(금)', '(토)'];
		  	var dayOfWeek = week[new Date(strDate).getDay()];
		  	return dayOfWeek;
		  }

		  // 오늘날짜 가져오기
		  function today(){
		      var date = new Date();

		      var year  = date.getFullYear();
		      var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
		      var day   = date.getDate();

		      if (("" + month).length == 1) { month = "0" + month; }
		      if (("" + day).length   == 1) { day   = "0" + day;   }

				return year + "" + month + "" + day;
		  }

		  function setVisitDate() {

		      var date = new Date();

		      date.setDate(date.getDate() + 1);
		      var strDate = date.format('yyyy-MM-dd');

		      date.setDate(date.getDate() + 14);
		      var endDate = date.format('yyyy-MM-dd');

		      //기간별 날짜 조회
		      var dateArr = getDates(strDate, endDate);

		   	  $('#sel_visit_date').append('<option value="">방문예약일 선택</option>');
		      $.each(dateArr, function(index, item){
			        var date = new Date(dateArr[index]);
			        var display = date.format('yyyy년MM월dd일') + ' ' + dayOfWeek(dateArr[index]);
		      	//방문시간
		       	$('#sel_visit_date').append('<option value="'+ dateArr[index] + '">' + display + '</option>');
		      });
		  }

		  //혼잡시간표 가져오기
		  function getTimeTableListB(strDate) {
			  //혼잡시간표 가져오기
			  var week = new Date(strDate).getDay();

		      var url = '${_MOBILE_PATH}/front/visit/time-table';
		      var param = {storeCode : $('#storeNo').val(), week : week+1, strDate : strDate };
		      Dmall.AjaxUtil.getJSON(url, param, function(result) {

	        	 if (result.holidayList != null && result.holidayList.length > 0) {
	    			 Dmall.LayerUtil.alert('선택하신 방문예정일은 선택할수 없습니다. (매장 휴일)','확인');
	                 $("#sel_visit_date").val("").prop("selected", true);
	            	 return false ;
	        	 }

		    	 var str = "";
		         jQuery.each(result.storeChaoticList, function(idx, obj) {

		        	 var chaotic = "";
		        	 if (obj.chaotic == "01") {
		        		 chaotic = '</span><p class="state green" onclick="setVisitTime(\''+obj.hour+'\',\''+strDate+'\');">' + obj.chaoticName +'</p></li>';
		        	 } else if (obj.chaotic == "02") {
		        		 chaotic = '</span><p class="state orange" onclick="setVisitTime(\''+obj.hour+'\',\''+strDate+'\');">' + obj.chaoticName +'</p></li>';
		        	 } else {
		        		 chaotic = '</span><p class="state red" onclick="setVisitTime(\''+obj.hour+'\',\''+strDate+'\');">' + obj.chaoticName +'</p></li>';
		        	 }

		        	 var hour = obj.hour;
		        	 if (hour.length > 0 && hour.length == 4) hour = hour.substring(0,2)+':'+ hour.substring(2,4);

		        	 if (Number(idx)%10 == 0) {
		        		 str += '<li><ul class="time_table">';
		        		 str += '<li><span class="time" onclick="setVisitTime(\''+obj.hour+'\',\''+strDate+'\');">' + hour + chaotic;
		        	 } else {
		        		 str += '<li><span class="time" onclick="setVisitTime(\''+obj.hour+'\',\''+strDate+'\');">' + hour + chaotic;
		        	 }

		        	 if (Number(idx)%10 == 9) {
		        		 str += '</ul></li>';
		        	 }
		         });

		         $('.time_table_list').empty();
		         $('.time_table_list').append(str);
		     });

		 }


	    function setVisitTime(hour, strDate) {
	     	 if (hour.length > 0 && hour.length == 4) {
	     		 var time = hour.substring(0,2)+':'+ hour.substring(2,4);
	     	 }

	     	 // 오늘날짜
	    	 var date = new Date();
	    	 var year = date.getFullYear();
	    	 var month = new String(date.getMonth()+1);
	    	 var day = new String(date.getDate());

	    	 // 한자리수일 경우 0을 채워준다.
	    	 if(month.length == 1){
	    	   month = "0" + month;
	    	 }
	    	 if(day.length == 1){
	    	   day = "0" + day;
	    	 }

	    	 var today = year + "-" + month + "-" + day;

	    	 if (strDate == today) {
	    		 var getHours = date.getHours().toString();
	    		 if(getHours.length == 1){
	    			 getHours = "0" + getHours;
	  	    	 }
	    		 var getMinutes = date.getMinutes().toString();
	    		 if(getMinutes.length == 1){
	    			 getMinutes = "0" + getMinutes;
	  	    	 }
	    		 var timeChk = year + month + day + getHours + getMinutes;
	    	 }

			 var _hour = year + month + day + hour;

	    	 if (_hour < timeChk) {
				Dmall.LayerUtil.alert('현재 시간 이후로 예약시간을 선택할 수 있습니다.','확인');
				$('input[name=rsvTime]').val("");
		    	$('input[name=rsvTimeText]').val("");
				$('.popup_time').hide();
	    		return false;
	    	 }

	    	$('input[name=rsvTime]').val(hour);
	    	$('input[name=rsvTimeText]').val(time);
	    	$('.popup_time').hide();
	    }

    /** 매장별 휴일 가져오기  **/
	function getHoliday(storeCode, targetYM) {

		//매장
		if(storeCode == '') {
			Dmall.LayerUtil.alert("매장을 선택해 주세요.","확인");
			return false;
		}
		//날짜
		if(targetYM == '') {
			Dmall.LayerUtil.alert("예약 년월이 없습니다.","확인");
			return false;
		}

		var url = '${_MOBILE_PATH}/front/visit/store-holiday';
		var param = {storeCode : storeCode, targetYM : targetYM};
		Dmall.AjaxUtil.getJSON(url, param, function(result) {
			var holiday = "";
			eventData.length = 0;
			jQuery.each(result.holidayList, function(idx, obj) {

				holiday = targetYM.substring(0,4) + "-" + targetYM.substring(4,6) + "-" + pad(obj);
				eventData.push({
					className: 'visit_disabled',  /* 예약불가 */
					start: holiday,
					end: holiday
				  });
			});

			if ( $('#calendar').children().length > 0 ) {
				var CAL = $('#calendar').fullCalendar('getCalendar');
				$('#calendar').fullCalendar('removeEvents', function(event) {
					return event.className = "visit_abled";
				});
				CAL.addEventSource(eventData);
				//상품 최소배송일 구하기
				var date = new Date();
				getDlvrExpectDays(date.getDate());

				var clalityYn ="N"; //G1907101559_5479
				var teanseanYn ="N"; //G2002141031_7301
				var teanMiniYn ="${teanseonMiniYn}"; //G2008041558_7972,G2008041551_7970
				var trevuesYn="N";
                    var teanseanSampleYn="N";

				$('[name=goodsNo]').each(function(){
					if($(this).val() =='G1907101559_5479'){
						clalityYn = "Y";
					}
					if($(this).val() =='G2002141031_7301'){
						teanseanYn = "Y";
					}
					if($(this).val() =='G2104082005_8744'){
							trevuesYn = "Y";
					}

					if($(this).val() =='G2103261158_8727'){
						teanseanSampleYn = "Y";
					}
				 });

				 if(teanseanYn=='Y'){
					 var CAL = $('#calendar').fullCalendar('getCalendar');
					var teanseaonDate = [];

					 teanseaonDate.push({
						color : "#99CCFF",
						start    : "2020-04-17",
						end      : "2020-05-31",
						rendering : "background"
					});

					CAL.addEventSource(teanseaonDate);

					$("#teanseonInfo").show();

				 }else{
				 $("#teanseonInfo").hide();
				 }

				 if(teanMiniYn=='Y'){
					var CAL = $('#calendar').fullCalendar('getCalendar');
					var teanseaonDate = [];

					 teanseaonDate.push({
						color : "#99CCFF",
						start    : "2020-08-08",
						end      : "2020-08-17",
						rendering : "background"
					});

					CAL.addEventSource(teanseaonDate);

					$("#teanseonInfo").show();

				 }else{
					$("#teanseonInfo").hide();
				 }

				 if(trevuesYn=='Y'){
					 var CAL = $('#calendar').fullCalendar('getCalendar');
					var teanseaonDate = [];

					 teanseaonDate.push({
						color : "#99CCFF",
						start    : "2021-05-10",
						end      : "2021-05-22",
						rendering : "background"
					});

					CAL.addEventSource(teanseaonDate);

					$("#teanseonInfo").show();

				 }else{
					$("#teanseonInfo").hide();
				 }


				 if(teanseanSampleYn=='Y'){
					var CAL = $('#calendar').fullCalendar('getCalendar');
					var teanseaonDate = [];

					 teanseaonDate.push({
						color : "#99CCFF",
						start    : "2021-05-31",
						end      : "2021-06-12",
						rendering : "background"
					});

					CAL.addEventSource(teanseaonDate);

					$("#teanseonInfo").show();

				 }else{
					$("#teanseonInfo").hide();
				 }
			}
		});
	}

	// 최소 배송일 구하기
	function getDlvrExpectDays(strDate) {

		var rtnDays = 0;
		var preGoodsYn ='${orderInfo.data.preGoodsYn}';
		if($('[name=dlvrExpectDays]').length > 0) {
			//최소 배송일 구하기
			var tmpDays = 100;
			$('[name=dlvrExpectDays]').each(function () {
				var days = Number($(this).val());
				if (days <= tmpDays) {
					tmpDays = days;
				}
			});
			rtnDays = tmpDays;

			for (var i = 0; i < rtnDays; i++) {
				var date = new Date();
				var holiday = "";
				date.setDate(date.getDate() + i);
				var holiday = date.format('yyyy-MM-dd');
				eventData.push({
					className: 'visit_delivery_disabled',  /* 예약불가 */
					start    : holiday,
					end      : holiday
				});
			}
			var CAL = $('#calendar').fullCalendar('getCalendar');
			CAL.addEventSource(eventData);
		}
		return rtnDays;
	}

	function pad(n) {
		n = n + '';
		return n.length >= 2 ? n : new Array(2 - n.length + 1).join('0') + n;
	}
    // 인포윈도우를 표시하는 클로저를 만드는 함수입니다
    function makeClickListener(map, marker, infowindow,address,storeNo,storeNm) {
        return function() {
            infowindow.open(map, marker);
        };
    }
    
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <jsp:useBean id="now" class="java.util.Date"/>
	<fmt:formatDate pattern="yyyyMMddkkmm" value="${now}" var="today" /> <%--오늘 날짜--%>

	<fmt:formatDate pattern="yyyyMMdd" value="${visitVO.rsvDate}" var="rsvDate" /> <%-- 예약일자 --%>

	<fmt:parseDate pattern="kkmm" value="${visitVO.rsvTime}" var="time"/>  <%-- 예약시간 --%>
	<fmt:formatDate pattern="kkmm" value="${time}" var="time2" />

	<fmt:parseDate pattern="yyyyMMddkkmm" value="${rsvDate}${time2}" var="rsvDate"/>  <%-- 최종 예약일자 --%>
	<fmt:formatDate pattern="yyyyMMddkkmm" value="${rsvDate}" var="rsvDate" />

	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			방문예약 상세내용
		</div>
		<div class="">
			<h4 class="my_stit">예약정보 </h4>
			<ul class="visit_detail_list"><!-- 2018-09-06마크업수정-->
				<li class="form">
					<span class="title">예약일시</span>
					<p class="detail">
						<fmt:formatDate pattern="yyyy-MM-dd" value="${visitVO.rsvDate}" />
						<fmt:parseDate pattern="kkmm" value="${visitVO.rsvTime}" var="time"/>
						<fmt:formatDate pattern=" kk:mm" value="${time}" />
					</p>
					<c:if test="${rsvDate >= today}">
						<c:if test="${visitVO.cancelYn ne 'Y'}">
						<button type="button" class="btn_visit_busy" id="btnChgDate">변경</button>
						</c:if>
					</c:if>
				</li>
				<li class="form">
					<span class="title">예약자명</span>
					<p class="detail">${visitVO.memberNm}</p>
				</li>
				<li class="form">
					<span class="title">예약매장</span>
					<p class="detail">
						다비치안경 ${visitVO.storeNm}
						<input type="hidden" id="storeNo"  value="${visitVO.storeNo}" >
						<input type="hidden" id="storeNm"  value="${visitVO.storeNm}" >
						<button type="button" class="btn_map_shop">지도보기</button>
					</p>
				</li>
				<li class="form">
					<span class="title">방문목적</span>
					<p class="detail">
						<c:set var="visitPurposeNm" value="${fn:split(visitVO.visitPurposeNm,'_')}" />
						<c:if test="${fn:length(visitPurposeNm) > 1}">
						${visitPurposeNm[1]}
						</c:if>
						<c:if test="${fn:length(visitPurposeNm) <= 1}">
						${fn:replace(visitVO.visitPurposeNm, ' ', '&nbsp;')}
						</c:if>
					</p>
				</li>
				<li class="form">
					<span class="title">요청사항</span>
					<p class="detail request">
						${visitVO.reqMatr}
					</p>
					<input type="hidden" value="${visitVO.rsvNo}" name="rsvNo" id="rsvNo" />
				</li>
			</ul>

			<c:choose>
				<c:when test="${visitVO.ordCnt gt 0}">

				<h4 class="my_stit">주문상품정보</h4>					
				<div class="my_order_info my_visit_order_wrap">
					<c:forEach items="${visitDtlList}" var="list" end="0">
						<p class="text">
							<span>주문번호 : <em>${list.ordNo}</em></span>
							<span>[ ${list.ordAcceptDttm} ]</span>
						</p>
						<button type="button" class="btn_order_info" onclick="move_order_detail('${list.ordNo}');">상세보기</button>
					</c:forEach>
				</div>		
				<ul class="order_list topline">
	                <c:forEach var="orderGoodsVo" items="${order_info.orderGoodsVO}" varStatus="status">
						<li>
	                        <c:set var="sumAddAptAmt" value="0"/>
							<div class="order_product_info wd-100p">
								<ul class="order_info_top wd-100p">
									<li class="order_product_pic"><img src="${orderGoodsVo.imgPath}"></li>
									<li class="order_product_title">
										<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${orderGoodsVo.goodsNo}">${orderGoodsVo.goodsNm}
		                                     <c:if test="${empty orderGoodsVo.itemNm}">
												&nbsp;&nbsp; ${orderGoodsVo.ordQtt} 개
		                                     </c:if>
										</a>
										<ul class="order_info_text">
											<li>
												<c:if test="${!empty orderGoodsVo.itemNm}">
													<span class="option_title"><c:out value="${orderGoodsVo.itemNm}"/> ${orderGoodsVo.ordQtt} 개</span>
												</c:if>
												<span class="option_price">
													<em><fmt:formatNumber value='${orderGoodsVo.saleAmt}' type='number'/></em>원
												</span>
												<c:forEach var="optionList" items="${orderGoodsVo.goodsAddOptList}" varStatus="status">
													<span class="option_title"> 
														${optionList.addOptNm} / ${optionList.addOptBuyQtt} 개
													</span>
													<span class="option_price">
														<em>
															<c:choose>
																<c:when test="${optionList.addOptAmtChgCd eq '1'}">
																+
																</c:when>
																<c:otherwise>
																-
																</c:otherwise>
															</c:choose>
															<fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
														 </em> 원
													</span>
													<c:set var="sumAddAptAmt" value="${sumAddAptAmt+(optionList.addOptAmt * optionList.addOptBuyQtt)}"/>
												</c:forEach>
											</li>
										</ul><!-- //order_info_text -->
								    </li>
								</ul>
							</div>
							
							<ul class="order_price floatC">
								<li>
									<span class="tit">배송</span>
	                                <c:choose>
	                                    <c:when test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
											<span class="label_reservation">예약전용</span>
	                                    </c:when>
	                                    <c:otherwise>
											<span class="label_shop">${orderGoodsVo.dlvrcPaymentNm}</span>
	                                    </c:otherwise>
									</c:choose>
								</li>
								<li>
									<span class="tit">상품금액</span>
									<em><fmt:formatNumber value="${orderGoodsVo.payAmt + sumAddAptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
								</li>
							</ul>
						</li>
	                </c:forEach>
				</ul>
			</c:when>
			<c:otherwise>
			
				<c:if test="${visitDtlList != null && fn:length(visitDtlList) > 0}" >
					<h4 class="my_stit">예약상품정보</h4>								
					<ul class="order_list bdrT">
		                <c:forEach var="visitDtlList" items="${visitDtlList}" varStatus="status">
		                	<input type="hidden" name="goodsNo" value="${visitDtlList.goodsNo}">
							<li>
								<div class="order_product_info">
									<ul class="order_info_top">
										<li class="order_product_pic"><div class="product_pic"><img src="${visitDtlList.imgPath}"></div></li>
										<li class="order_product_title">
											<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${visitDtlList.goodsNo}">${visitDtlList.goodsNm}
			                                     <c:if test="${empty visitDtlList.itemNm}">
													&nbsp;&nbsp; ${visitDtlList.ordQtt} 개
			                                     </c:if>
											</a>
									    </li>
									</ul>
								</div>
								<ul class="order_info_text">
									<li>
		                                <c:if test="${!empty visitDtlList.itemNm}">
		                                	<span class="option_title"><c:out value="${visitDtlList.itemNm}"/> ${visitDtlList.ordQtt} 개</span>
		                                </c:if>
										<span class="option_price">
											<em><fmt:formatNumber value='${visitDtlList.saleAmt}' type='number'/></em>원
										</span>
									</li>
									<c:forEach var="optionList" items="${optionList}" varStatus="status">
									<li>
				                        
				                            <span class="option_title"> 
				                                ${optionList.addOptNm} / ${optionList.addOptBuyQtt} 개
				                            </span>
				                            <span class="option_price">
				                            	<em>
					                                <c:choose>
					                                    <c:when test="${optionList.addOptAmtChgCd eq '1'}">
					                                    +
					                                    </c:when>
					                                    <c:otherwise>
					                                    -
					                                    </c:otherwise>
					                                </c:choose>
				                            		<fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
				                            	 </em> 원
				                            </span>
				                        
									</li>
									</c:forEach>
								</ul>
							</li>
		                </c:forEach>
					</ul>				
				</c:if>
				</c:otherwise>
			</c:choose>
			
			<div class="btn_davichi_area">
				<c:if test="${rsvDate >= today}">
					<c:if test="${visitVO.cancelYn ne 'Y'}">
					<button type="button" class="btn_info_cancel" style="margin-right:auto;">예약취소</button>
					</c:if>
				</c:if>
				<button type="button" class="btn_move_prev">이전화면으로</button>
			</div>
		</div><!-- //cont_body -->

		<div class="" id="layer_change" style="display:none;">
			<h4 class="my_stit">변경정보</h4>
			<ul class="visit_detail_list"><!-- 2018-09-06마크업수정-->
				<li class="form">
					<span class="title">예약날짜</span>
					<p class="detail">
						<input type="text" name="rsvDate" style="width: auto;" readonly> <button type="button" class="btn_visit_busy popup_visit01">날짜선택</button><!-- 방문희망일시 캘린더 팝업 노출 -->
					</p>
				</li>
				<li class="form">
					<span class="title">예약시간</span>
					<p class="detail">
						<input type="text" name="rsvTimeText" style="width: auto;" readonly> <button type="button" class="btn_visit_busy popup_visit02">시간선택</button><!-- 희망타임 팝업 노출 -->
						<input type="hidden" name="rsvTime" readonly>
					</p>
				</li>
			</ul>

			<div class="btn_area">
				<button type="button" class="btn_go_receipt btn_alert_ok">변경하기</button>
			</div>

		</div><!-- //cont_body -->
	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->

	<!-- popup1 매장찾기-->
	<div class="popup_date" style="display:none" >
		<div class="popup_head">
			<h1 class="tit">날짜선택</h1>
			<button type="button" class="btn_close_popup">창닫기</button>
		</div>
		<div class="popup_body">

			<div class="select_calendar_area">
				<!-- full calendar -->
				<div id="calendar"></div>
				<!--// full calendar -->
			</div>
		</div>
	</div>

	<!--// popup1 매장찾기-->
	<!-- popup2 시간선택-->
	<div class="popup_time" style="display:none" >
		<div class="popup_head">
			<h1 class="tit">시간선택</h1>
			<button type="button" class="btn_close_popup">창닫기</button>
		</div>
		<div class="popup_body">
			<div class="time_table_area">
				<div class="tit" id="storeTitle"></div>
				<ul class="time_table_list">
					<li>
						<ul class="time_table">
						</ul>
					</li>
					<li>
						<ul class="time_table">
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!--// popup1 시간선택-->

	<!--  popup -->
	<div class="popup" id="div_store_detail_popup" style="display:none;">
          <div id="map3"></div>
	</div>		
    
    </t:putAttribute>
</t:insertDefinition>