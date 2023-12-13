<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>

<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">방문예약</t:putAttribute>
	<t:putAttribute name="script">
    <script>

    $(document).ready(function(){
        //페이징
        //jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        //달력
        //$( ".datepicker" ).datepicker();


        $('.btn_info_cancel').on('click', function() {
        	var visitPurposeCd = "${reservationVO.visitPurposeCd }";
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

		// 목록
		jQuery('#btn_list').off("click").on('click', function(e) {
			Dmall.EventUtil.stopAnchorAction(e);
			goToList();
		});

		// 저장
		jQuery('#btn_change').click(function () {
			Dmall.LayerUtil.confirm('저장하시겠습니까?', function () {
				var url = '/admin/order/reservation/rsv-info-update';
				var param = {
					'rsvNoArr[0]': $('#rsvNo').val(),
					'managerMemo': $("#manager_memo").val(),
					'prcType': 'U'
				};

				Dmall.AjaxUtil.getJSON(url, param, function(result) {
					if(result.success) {
						Dmall.LayerUtil.alert("수정되었습니다.").done(function () {
							goToList();
						});
					}
				});
			});
		});

		// 예약취소
		$('#btn_cancel').on('click', function () {
			Dmall.LayerUtil.confirm('예약 취소하시겠습니까?', function () {
				var url = '/admin/order/reservation/rsv-info-update';
				var param = {
					'rsvNoArr[0]': $('#rsvNo').val(),
					'prcType': 'D'
				};

				Dmall.AjaxUtil.getJSON(url, param, function (result) {
					if(result.success) {
						Dmall.LayerUtil.alert('취소되었습니다.').done(function () {
							goToList();
						});
					}
				});
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

	function goToList() {
		location.href = '/admin/order/reservation/reservation-info';
	}
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">

	<%--<fmt:formatDate pattern="yyyyMMddkkmm" value="${now}" var="today" /> &lt;%&ndash;오늘 날짜&ndash;%&gt;

	<fmt:formatDate pattern="yyyyMMdd" value="${reservationVO.rsvDate}" var="rsvDate" /> &lt;%&ndash; 예약일자 &ndash;%&gt;

	<fmt:formatDate pattern="kkmm" value="${reservationVO.rsvTime}" var="time" />
	<fmt:formatDate pattern="kkmm" value="${time}" var="time2" />

	<fmt:parseDate pattern="yyyyMMddkkmm" value="${rsvDate}${time2}" var="rsvDate"/>  &lt;%&ndash; 최종 예약일자 &ndash;%&gt;
	<fmt:formatDate pattern="yyyyMMddkkmm" value="${rsvDate}" var="rsvDate" />--%>

		<div class="sec01_box">
			<div class="tlt_box">
				<div class="tlt_head">
					주문 설정<span class="step_bar"></span>
				</div>
				<h2 class="tlth2">예약 관리</h2>
			</div>
			<input type="hidden" id="rsvNo" name="rsvNo" value="${reservationVO.rsvNo}"/>
			<c:if test="${reservationVO.visitStatusCd eq 'V'}">
			<div class="line_box pb">
				<h3 class="tlth3">예약 상태 관리</h3>
				<div class="tblw tblmany">
					<table summary="이표는 예약 상태 관리표입니다. 구성은 예약상태 입니다.">
						<caption>예약 상태 관리</caption>
						<colgroup>
							<col width="150px">
							<col width="">
						</colgroup>
						<tbody>
						<tr>
							<th>예약상태</th>
							<td>방문예약</td>
						</tr>
						<tr>
							<th>방문목적</th>
							<td>${reservationVO.visitPurposeNm}</td>
						</tr>
						</tbody>
					</table>
				</div>

				<h3 class="tlth3">방문자 정보</h3>
				<div class="tblw tblmany ">
					<table summary="이표는 방문자 정보표 입니다. 구성은 아이디,이름,휴대폰,이메일 , 매장명, 방문일시, 방문사유 입니다.">
						<caption>주문자 정보</caption>
						<colgroup>
							<col width="150px">
							<col width="">
						</colgroup>
						<tbody>
						<c:if test="${reservationVO.loginId ne null and not empty reservationVO.loginId}">
							<tr>
								<th>아이디</th>
								<td>${reservationVO.loginId}</td>
							</tr>
						</c:if>
						<c:choose>
							<c:when test="${reservationVO.memberNm eq null or empty reservationVO.memberNm}">
								<tr>
									<th>이름</th>
									<td>${reservationVO.noMemberNm}</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<th>이름</th>
									<td>${reservationVO.memberNm}</td>
								</tr>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${reservationVO.mobile eq null or empty reservationVO.mobile}">
								<tr>
									<th>휴대폰</th>
									<td>${reservationVO.noMemberMobile}</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<th>휴대폰</th>
									<td>${reservationVO.mobile}</td>
								</tr>
							</c:otherwise>
						</c:choose>
						<c:if test="${reservationVO.email ne null and not empty reservationVO.email}">
							<tr>
								<th>이메일</th>
								<td>${reservationVO.email}</td>
							</tr>
						</c:if>
						<tr>
							<th>매장명</th>
							<td>${reservationVO.storeNm}</td>
						</tr>
						<tr>
							<th>방문일시</th>
							<td>${reservationVO.strVisitDate}</td>
						</tr>
						<tr>
							<th>요청사항</th>
							<td>${reservationVO.reqMatr}</td>
						</tr>
						</tbody>
					</table>
				</div>

				<h3 class="tlth3">상담 메모</h3>
				<div class="txt_area tblmany">
					<textarea name="managerMemo" id="manager_memo">${reservationVO.managerMemo}</textarea>
				</div>

				<h3 class="tlth3">처리 로그</h3>
				<div class="disposal_log tblmany">
					<ul>
						<c:forEach var="list" items="${rvsHistList}" varStatus="status">
							<li><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${list.regDttm}" /> <c:if test="${!empty list.itemNm}">[예약 상세번호:<c:out value="${list.rsvNo}"/>]</c:if> <c:if test="${!empty list.cancelYn}">[예약 상태:<c:out value="${list.cancelYn}"/>]</c:if> <c:if test="${!empty list.rsvDate}">[예약 일시:<c:out value="${list.rsvDate}"/>]</c:if> <c:if test="${!empty list.rsvTime}">[예약 시간:<c:out value="${list.rsvTime}"/>]</c:if><c:if test="${!empty list.storeNm}">[예약 매장:<c:out value="${list.storeNm}"/>]</c:if><c:if test="${!empty list.visitYn}">[예약 매장방문:<c:out value="${list.visitYn}"/>]</c:if></li>
						</c:forEach>
					</ul>
				</div>
			</div>
			</c:if>

			<c:if test="${reservationVO.visitStatusCd eq 'G'}">
			<div class="line_box pb">
				<h3 class="tlth3">예약 상태 관리</h3>
				<div class="tblw tblmany ">
					<table summary="이표는 예약 상태 관리표입니다. 구성은 예약상태 입니다.">
						<caption>상품 예약 상태 리스트</caption>
						<colgroup>
							<col width="150px">
							<col width="">
						</colgroup>
						<tbody>
						<tr>
							<th>예약상태</th>
							<td>상품예약</td>
						</tr>
						<tr>
							<th>상품군</th>
							<td>${reservationVO.goodsTypeCdNm}</td>
						</tr>
						<tr>
							<th>주문상태</th>
							<td>
								<c:choose>
									<c:when test="${reservationVO.buyYn eq null or empty reservationVO.buyYn}">
										구매대기
									</c:when>
									<c:when test="${reservationVO.buyYn eq 'Y'}">
										구매완료
									</c:when>
									<c:when test="${reservationVO.buyYn eq 'N'}">
										구매취소
									</c:when>
								</c:choose>
							</td>
						</tr>
						</tbody>
					</table>
				</div>

				<h3 class="tlth3">예약 상품</h3>
				<div class="tblh">
					<table summary="이표는 예약 상품 리스트 표 입니다. 구성은 이미지 ,상품,상품코드, 옵션,수량,판매가,할인금액,배송비 결제금액, 주문상태 입니다.">
						<caption>주문 상품</caption>
						<colgroup>
							<col width="11%">
							<col width="20%">
							<col width="14%">
							<col width="7%">
							<col width="11%">
							<col width="11%">
							<col width="11%">
							<col width="15%">
						</colgroup>
						<thead>
						<tr>
							<th>이미지</th>
							<th>상품명<br>[상품코드]</th>
							<th>옵션</th>
							<th>수량</th>
							<th>판매가</th>
							<th>할인금액</th>
							<th>결제금액</th>
							<th>주문상태</th>
						</tr>
						</thead>
						<tbody>
						<c:set var="totOrdQtt" value="0"/>
						<c:set var="totSaleAmt" value="0"/>
						<c:set var="totDcAmt" value="0"/>
						<c:set var="totPayAmt" value="0"/>
						<c:if test="${reservationDtlList != null && fn:length(reservationDtlList) > 0}" >
							<c:forEach var="reservationDtlItem" items="${reservationDtlList}" varStatus="status">
								<input type="hidden" name="goodsNo" value="${reservationDtlItem.goodsNo}">
								<tr>
									<td><img src="${_IMAGE_DOMAIN}${reservationDtlItem.imgPath}"></td>
									<td><span class="tlt">${reservationDtlItem.goodsNm}<br>[${reservationDtlItem.goodsNo}]</span></td>
									<td>${reservationDtlItem.itemNm}</td>
									<td>${reservationDtlItem.ordQtt}</td>
									<td>${reservationDtlItem.saleAmt}</td>
									<td>${reservationDtlItem.dcAmt}</td>
									<td>${reservationDtlItem.payAmt}</td>
									<td>
										<c:choose>
											<c:when test="${reservationVO.buyYn eq null or empty reservationVO.buyYn}">
												구매대기
											</c:when>
											<c:when test="${reservationVO.buyYn eq 'Y'}">
												구매완료
											</c:when>
											<c:when test="${reservationVO.buyYn eq 'N'}">
												구매취소
											</c:when>
										</c:choose>
									</td>
								</tr>
								<c:set var="totOrdQtt" value="${totOrdQtt + reservationDtlItem.ordQtt}"/>
								<c:set var="totSaleAmt" value="${totSaleAmt + reservationDtlItem.saleAmt}"/>
								<c:set var="totDcAmt" value="${totDcAmt + reservationDtlItem.dcAmt}"/>
								<c:set var="totPayAmt" value="${totPayAmt + reservationDtlItem.payAmt}"/>
							</c:forEach>
						</c:if>
						</tbody>
						<tfoot>
						<tr style="background-color: #F8F8F9;">
							<td colspan="3" class="fwb">소계</td>
							<td>${totOrdQtt}</td>
							<td>${totSaleAmt}</td>
							<td>${totDcAmt}</td>
							<td colspan="2">${totPayAmt}</td>
						</tr>
						</tfoot>
					</table>
				</div>
				<div class="all_sum tblmany">
					<ul>
						<li class="gray_box">
							<strong>판매가</strong>
							<br>
							<span>${totSaleAmt}</span>원
						</li>
						<li class="wid5"><img src="/admin/img/order/icon_pay_minus.png" alt="마이너스"></li>
						<li class="gray_box">
							<strong>할인</strong>
							<br>
							<span>${totDcAmt}</span>원
						</li>
						<li class="wid5"><img src="/admin/img/order/icon_pay_total.png" alt="합"></li>
						<li class="wid20">
							<strong>총 결제금액</strong>
							<br>
							<span>${totPayAmt}</span>원
						</li>
					</ul>
				</div>

				<h3 class="tlth3">주문자 정보</h3>
				<div class="tblw tblmany">
					<table>
						<colgroup>
							<col width="150px">
							<col width="">
						</colgroup>
						<tbody>
						<c:if test="${reservationVO.loginId ne null and not empty reservationVO.loginId}">
							<tr>
								<th>아이디</th>
								<td>${reservationVO.loginId}</td>
							</tr>
						</c:if>
						<c:choose>
							<c:when test="${reservationVO.memberNm eq null or empty reservationVO.memberNm}">
								<tr>
									<th>이름</th>
									<td>${reservationVO.noMemberNm}</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<th>이름</th>
									<td>${reservationVO.memberNm}</td>
								</tr>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${reservationVO.mobile eq null or empty reservationVO.mobile}">
								<tr>
									<th>휴대폰</th>
									<td>${reservationVO.noMemberMobile}</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<th>휴대폰</th>
									<td>${reservationVO.mobile}</td>
								</tr>
							</c:otherwise>
						</c:choose>
						<c:if test="${reservationVO.email ne null and not empty reservationVO.email}">
							<tr>
								<th>이메일</th>
								<td>${reservationVO.email}</td>
							</tr>
						</c:if>
						<tr>
							<th>매장명</th>
							<td>${reservationVO.storeNm}</td>
						</tr>
						<tr>
							<th>방문일시</th>
							<td>${reservationVO.strVisitDate}</td>
						</tr>
						</tbody>
					</table>
				</div>

				<h3 class="tlth3">상담 메모</h3>
				<div class="txt_area tblmany">
					<textarea name="managerMemo" id="manager_memo">${reservationVO.managerMemo}</textarea>
				</div>

				<h3 class="tlth3">처리 로그</h3>
				<div class="disposal_log tblmany">
					<ul>
						<c:forEach var="list" items="${rvsHistList}" varStatus="status">
							<li><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${list.regDttm}" /> <c:if test="${!empty list.itemNm}">[예약 상세번호:<c:out value="${list.rsvNo}"/>]</c:if> <c:if test="${!empty list.cancelYn}">[예약 상태:<c:out value="${list.cancelYn}"/>]</c:if> <c:if test="${!empty list.rsvDate}">[예약 일시:<c:out value="${list.rsvDate}"/>]</c:if> <c:if test="${!empty list.rsvTime}">[예약 시간:<c:out value="${list.rsvTime}"/>]</c:if><c:if test="${!empty list.storeNm}">[예약 매장:<c:out value="${list.storeNm}"/>]</c:if><c:if test="${!empty list.visitYn}">[예약 매장방문:<c:out value="${list.visitYn}"/>]</c:if><c:if test="${!empty list.managerMemo}">[상담 매모:<c:out value="${list.managerMemo}"/>]</c:if></li>
						</c:forEach>
					</ul>
				</div>
			</div>
			</c:if>

			<div class="bottom_box">
				<div class="left">
					<div class="pop_btn">
						<button class="btn--big btn--big-white" id="btn_list">목록</button>
					</div>
				</div>
				<div class="right">
					<c:if test="${reservationVO.cancelPossible eq 'Y' and reservationVO.cancelYn ne 'Y'}">
						<button class="btn--blue-round" id="btn_cancel">예약취소</button>
					</c:if>
					<button class="btn--blue-round" id="btn_change">저장</button>
				</div>
			</div>
		</div>

    </t:putAttribute>
</t:insertDefinition>