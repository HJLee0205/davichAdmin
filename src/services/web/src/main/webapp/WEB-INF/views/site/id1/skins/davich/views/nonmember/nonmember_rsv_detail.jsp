<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">비회원 방문예약 상세</t:putAttribute>

	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
		<script src="/front/js/moment.min.js" charset="utf-8"></script>
        <script src="/front/js/fullcalendar.js" charset="utf-8"></script>
	<%--615a2979c4cf4a0cd3c3cfd1eaf25461--%>
		<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${snsMap.get('javascriptKey')}&libraries=services"></script>
        <script type="text/javascript">

		var	lat = 37.560811;
		var lon = 126.982159;

		var map3 = new daum.maps.Map(document.getElementById('map3'), {
			center: new daum.maps.LatLng(lat, lon),
			level: 3
		});

    var eventData = [];
    $(document).ready(function(){
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        //달력
        $( ".datepicker" ).datepicker();

        //검색
        $('.btn_form').on('click', function() {
            if($("#ordDayS").val() == '' || $("#ordDayE").val() == '') {
                Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                return;
            }
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('/front/visit/visit-list', param);
        });

        $('.btn_info_cancel').on('click', function() {
        	var visitPurposeCd = "${visitVO.visitPurposeCd }";
        	if(visitPurposeCd == '07') {
        		Dmall.LayerUtil.alert('시험착용 목적일 경우에는 취소가 불가능합니다.','','');
        		return false;
        	}

            var url = '/front/visit/rsv-cancel-update';
            var rsvNo = $('#rsvNo').val();
            var param = {rsvNo : rsvNo};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerUtil.alert("예약취소가 처리 되었습니다.").done(function(){
					Dmall.FormUtil.submit('/front/visit/nomember-rsv-list', {'rsvNo':rsvNo, 'rsvMobile':'${so.rsvMobile}', 'nonRsvMobile':'${so.rsvMobile}'});
                    })
                }
            });
        });

		var eventData = [];


        //예약 날짜 변경 클릭
		$("#btnChgDate").click(function() {
			$("#layer_change").show();

            var storeNo = $('#storeNo').val();
            getHoliday(storeNo, today().substring(0, 6));

			 $('#calendar').fullCalendar({
				header       : {
					left  : 'none',
					center: 'title'
				},
				titleFormat  : {
					month: 'YYYY. MM'
				},
				buttonText   : {
					today: '오늘'
				},
				dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
				events       : eventData,
				dayClick     : function (date, allDay, jsEvent, view) {
					var clalityYn ="N";
					var teanseanYn ="N";
					var teanMiniYn ="${teanseonMiniYn}";
					 $('[name=goodsNo]').each(function(){
						if($(this).val() =='G1907101559_5479'){
							clalityYn = "Y";
						}
						if($(this).val() =='G2002141031_7301'){
							teanseanYn = "Y";
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

					$("#calendar").fullCalendar('renderEvent', {
						start    : date.format("YYYY-MM-DD"),
						end      : date.format("YYYY-MM-DD"),
						className: 'visit_abled'
					});

					var storeNo = $('#storeNo').val();
					var sucess = true;
					if (storeNo == '' || storeNo == undefined) {
						$("#calendar").fullCalendar('refetchEvents');
						Dmall.LayerUtil.alert("방문하실 매장을 먼저 선택해 주세요.", "확인");
						return false;
					}

					if (today() > date.format("YYYYMMDD")) {

						$("#calendar").fullCalendar('refetchEvents');
						Dmall.LayerUtil.alert("오늘 날짜 이후로 선택해 주세요.", "확인");
						return false;
					}

					var preChk = "${orderInfo.data.exhibitionYn}";
					if (preChk == "Y") {
						if (date.format("YYYYMMDD") < "20190510" || date.format("YYYYMMDD") > "20190531") {
							$("#calendar").fullCalendar('refetchEvents');
							Dmall.LayerUtil.alert("사전예약상품 구매를 위한 방문희망일은 '2019년 5월10일 ~ 5월31일' 사이의 기간만 선택 가능합니다.", "확인");
							return false;
						}
					}

					//방문정보 setting
					$('#storeTitle').text($('#storeNm').val() + "  :  " + date.format("YYYY년 MM월 DD일"));  //매장
					$('#visitDate').text(date.format("YYYY-MM-DD") + "  " + dayOfWeek(date.format("YYYY-MM-DD")));   //예약일자
					$('#visitStore').text($('#storeNm').val());  //매장


					$('input[name=rsvDate]').val(date.format("YYYY-MM-DD"));

					//혼잡시간표 가져오기
					getTimeTableList(date.format("YYYY-MM-DD"));

				}
			});
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
			var url = '/front/visit/add-visit-book';
			var param = {rsvNo: rsvNo, visitPurposeNm:visitPurposeNm,rsvDate : rsvDate, rsvTime : rsvTime};

			Dmall.AjaxUtil.getJSON(url, param, function(result) {

				if(result.success) {
					Dmall.LayerUtil.alert("방문예약정보가 변경되었습니다.", "알림");
				}
			});

		});


    });

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

		 // 년월 변경
            function convertYm(date) {
                var date = new Date(date);
                var year = date.getFullYear();
                var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
                var day = date.getDate();

                if (("" + month).length == 1) {
                    month = "0" + month;
                }
                if (("" + day).length == 1) {
                    day = "0" + day;
                }

                return year + month;
            }

            // 날짜 변경
            function convertDate(date) {
                var date = new Date(date);
                var year = date.getFullYear();
                var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
                var day = date.getDate();

                if (("" + month).length == 1) {
                    month = "0" + month;
                }
                if (("" + day).length == 1) {
                    day = "0" + day;
                }

                return year + "-" + month + "-" + day;
            }


            function getTimeTable() {
                var url = '/front/visit/time-table';
                var param = $('#form_id_update').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result.success) {
                        Dmall.LayerUtil.alert("회원정보가 성공적으로 변경되었습니다.", "알림");
                        location.href = "/front/member/information-update-form";
                    }
                });
            }

            // 매장목록 가져오기
            function getDefaultStoreList(sidoCode) {
                var url = '/front/visit/store-list';
                var hearingAidYn = hearingAidChk();
                if (hearingAidYn != "Y") {
                    hearingAidYn = "";
                }

                if ('${isHa}' == 'Y') hearingAidYn = 'Y';

                var erpItmCode = "";
                $('input[name="erpItmCode"]').each(function () {
                    if (erpItmCode != "") erpItmCode += ",";
                    if ($(this).val() != "") erpItmCode += $(this).val();
                });

                var param = {sidoCode: sidoCode, hearingAidYn: hearingAidYn, erpItmCode: erpItmCode};
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    Dmall.LayerUtil.alert(result.strList.length, "확인");
                    var addr = [];
                    searchGeoByAddr()
                });
            }


            function today() {

                var date = new Date();

                var year = date.getFullYear();
                var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
                var day = date.getDate();

                if (("" + month).length == 1) {
                    month = "0" + month;
                }
                if (("" + day).length == 1) {
                    day = "0" + day;
                }

                return year + "" + month + "" + day;

            }

            function dayOfWeek(strDate) {
                var week = ['(일)', '(월)', '(화)', '(수)', '(목)', '(금)', '(토)'];
                var dayOfWeek = week[new Date(strDate).getDay()];
                return dayOfWeek;
            }

            /** 매장별 휴일 가져오기  **/
            function getHoliday(storeCode, targetYM) {

                //매장
                if (storeCode == '') {
                    Dmall.LayerUtil.alert("매장을 선택해 주세요.", "확인");
                    return false;
                }
                //날짜
                if (targetYM == '') {
                    Dmall.LayerUtil.alert("예약 년월이 없습니다.", "확인");
                    return false;
                }

                var url = '/front/visit/store-holiday';
                var param = {storeCode: storeCode, targetYM: targetYM};
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    var holiday = "";
                    eventData.length = 0;
                    jQuery.each(result.holidayList, function (idx, obj) {

                        holiday = targetYM.substring(0, 4) + "-" + targetYM.substring(4, 6) + "-" + pad(obj);

                        eventData.push({
                            className: 'visit_disabled',  /* 예약불가 */
                            start    : holiday,
                            end      : holiday
                        });
                    });

                    var CAL = $('#calendar').fullCalendar('getCalendar');
                    $('#calendar').fullCalendar('removeEvents', function(event) {
                        return event.className = "visit_abled";
                    });
                    CAL.addEventSource(eventData);

                    var date = new Date();
                    getDlvrExpectDays(date.getDate());

                    var clalityYn ="N"; //G1907101559_5479
                    var teanseanYn ="N"; //G2002141031_7301
                    var teanMiniYn ="${teanseonMiniYn}"; //G2008041558_7972,G2008041551_7970

                    $('[name=goodsNo]').each(function(){
                        if($(this).val() =='G1907101559_5479'){
                            clalityYn = "Y";
                        }
                        if($(this).val() =='G2002141031_7301'){
                            teanseanYn = "Y";
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

    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="mypage_middle">

            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/nonmember_rsv_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div id="mypage_content">
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />

	            <div class="mypage_body">
					<h3 class="my_tit">방문예약내역</h3>
					<h4 class="my_stit">예약정보</h4>
					<table class="tVisit_View">
						<caption>
							<h1 class="blind">방문예약 상세내용입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:125px">
							<col style="width:">
						</colgroup>
						<tbody>
							<tr>
								<th>예약자명</th>
								<td>${visitVO.noMemberNm}</td>
							</tr>
							<tr>
								<th>예약매장</th>
								<td>
									${visitVO.storeNm}
									<input type="hidden" id="storeNo"  value="${visitVO.storeNo}" >
									<input type="hidden" id="storeNm"  value="${visitVO.storeNm}" >
									<button type="button" class="btn_map_shop03" onclick="storeDtlPopup('${visitVO.storeNo}')">지도보기</button>
								</td>
							</tr>
							<tr>
								<th>예약일시</th>
								<td>
									<fmt:formatDate pattern="yyyy-MM-dd" value="${visitVO.rsvDate}" />
									<fmt:parseDate pattern="kkmm" value="${visitVO.rsvTime}" var="time"/>
									<fmt:formatDate pattern=" kk:mm" value="${time}" />
									<c:if test="${rsvDate >= today}">
										<c:if test="${visitVO.cancelYn ne 'Y'}">
										&nbsp;&nbsp;<button type="button" class="btn_refund" id="btnChgDate">변경</button>
										</c:if>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>방문목적</th>
								<td>
									<c:set var="visitPurposeNm" value="${fn:split(visitVO.visitPurposeNm,'_')}" />
									<c:if test="${fn:length(visitPurposeNm) > 1}">
									${visitPurposeNm[1]}
									</c:if>
									<c:if test="${fn:length(visitPurposeNm) <= 1}">
									${fn:replace(visitVO.visitPurposeNm, ' ', '&nbsp;')}
									</c:if>
								</td>
							</tr>
							<tr>
								<th>요청사항</th>
								<td>
									${visitVO.reqMatr}
								</td>
							</tr>
						</tbody>
						<input type="hidden" value="${visitVO.rsvNo}" id="rsvNo" />
					</table>

					<div class="" id="layer_change" style="display:none;">
					<h4 class="my_stit top_margin">방문희망 일시를 선택해 주세요.</h4>
					<p class="visit_warning">
						※ 최상의 예약 상품 준비/검수를 위하여 평균 3일(주말, 공휴일 제외)의 기간이 소요됩니다.<br>
						※ 시간대별 예상혼잡도를 참조하여 방문시간을 선택해 주세요.
					</p>
					<div class="visit_day_area02" id="layer_change">
                            <div class="left">
                                <div class="select_calendar_area">
                                    <!-- full calendar -->
                                    <div id="calendar"></div>
                                    <!--// full calendar -->
                                </div>
                                <p class="calendar_bottom">
                                    <span class="won_disabled"></span>예약불가
                                    <span id="teanseonInfo" style="display:none;"><span class="won_disabled" style="background:#99CCFF;"></span>예약가능</span>
                                </p>

                            </div>
                            <div class="right">
                                <div class="time_table_area">
                                    <div class="tit" id="storeTitle"></div>
                                    <ul class="time_table_list">
                                    </ul>
                                </div>
                            </div>
                            <div class="bottom">
                                <div class="tit">
                                    방문예약 변경 신청
                                </div>
                                <table class="tCart_Insert">
                                    <caption>방문예약신청 정보 입력폼입니다.</caption>
                                    <colgroup>
                                        <col style="width:15%">
                                        <col style="width:35%">
                                        <col style="width:15%">
                                        <col style="width:35%">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th><span class="dot">날짜</span></th>
                                        <td><span id="visitDate"></span>
                                            <input type="hidden" name="rsvDate"/>
                                        </td>
                                        <th><span class="dot">시간</span></th>
                                        <td>
                                            <input type="hidden" name="rsvTime"/>
                                            <select id="sel_visitTime">
                                            </select>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div>
                                    <div class="btn_area">
                                        <button type="button" class="btn_go_receipt">변경하기</button>
                                    </div>
                                </div>
                            </div>
                        </div>
					</div>
					<c:choose>
						<c:when test="${visitVO.ordCnt gt 0}">
							<h4 class="my_stit top_margin">주문상품정보</h4>
							<div class="my_order_info">
								<c:forEach items="${visitDtlList}" var="list" end="0">
									<p class="text">
											<span>주문번호 : <em>${list.ordNo}</em></span>
											<span>주문일시 : ${list.ordAcceptDttm}</span>
									</p>
									<button type="button" class="btn_order_info" onclick="move_order_detail('${list.ordNo}');">주문정보 상세보기</button>
								</c:forEach>
							</div>
							<table class="tCart_Board Mypage">
								<caption>
									<h1 class="blind">주문상품 목록입니다.</h1>
								</caption>
								<colgroup>
									<col style="width:102px">
									<col style="width:">
									<col style="width:120px">
									<col style="width:110px">
									<col style="width:110px">
								</colgroup>
								<thead>
									<tr>
										<th colspan="2">상품/옵션/수량</th>
										<th>상품금액</th>
										<th>배송</th>
										<th>상태</th>
									</tr>
								</thead>
								<tbody>
			                    <c:forEach var="orderGoodsVo" items="${order_info.orderGoodsVO}" varStatus="status">
			                        <c:set var="sumAddAptAmt" value="0"/>
									<tr>
										<td class="noline">
											<div class="cart_img">
												<img src="${orderGoodsVo.imgPath}">
											</div>
										</td>
										<td class="textL vaT">
											<a href="/front/goods/goods-detail?goodsNo=${orderGoodsVo.goodsNo}">${orderGoodsVo.goodsNm}
			                                     <c:if test="${empty orderGoodsVo.itemNm}">
													&nbsp;&nbsp; ${orderGoodsVo.ordQtt} 개
			                                     </c:if>
											</a>
			                                <c:if test="${!empty orderGoodsVo.itemNm}">
			                                	<p class="option"><c:out value="${orderGoodsVo.itemNm}"/> ${orderGoodsVo.ordQtt} 개</p>
			                                </c:if>
					                        <c:forEach var="optionList" items="${orderGoodsVo.goodsAddOptList}" varStatus="status">
					                            <p class="option_s">
					                                ${optionList.addOptNm} (
					                                <c:choose>
					                                    <c:when test="${optionList.addOptAmtChgCd eq '1'}">
					                                    +
					                                    </c:when>
					                                    <c:otherwise>

					                                    </c:otherwise>
					                                </c:choose>
					                                <fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
					                                           ${optionList.addOptBuyQtt} 개
					                            </p>
						                        <c:set var="sumAddAptAmt" value="${sumAddAptAmt + (optionList.addOptAmt*optionList.addOptBuyQtt)}"/>
					                        </c:forEach>
										</td>
										<td class="right_line">
											<span class="price"><fmt:formatNumber value='${orderGoodsVo.saleAmt + sumAddAptAmt}' type='number'/></span>원
										</td>
										<td>
			                                <c:choose>
			                                    <c:when test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
													<span class="label_reservation">예약전용</span>
			                                    </c:when>
			                                    <c:otherwise>
						                            ${orderGoodsVo.dlvrcPaymentNm}<br>
						                            <c:if test="${orderGoodsVo.addOptYn eq 'N'}">
						                                <c:if test="${orderGoodsVo.dlvrcPaymentCd ne '01' and orderGoodsVo.dlvrcPaymentCd ne '04'}">
						                                <span></span><fmt:formatNumber value='${orderGoodsVo.realDlvrAmt+orderGoodsVo.areaAddDlvrc}' type='number'/></span>원
						                                </c:if>
						                            </c:if>
			                                    </c:otherwise>
											</c:choose>
										</td>
										<td>
			                                <c:choose>
			                                    <c:when test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
													<span class="label_reservation">예약전용</span>
			                                    </c:when>
			                                    <c:otherwise>
													<p>${orderGoodsVo.ordDtlStatusNm}</p>
			                                    </c:otherwise>
											</c:choose>
										</td>
									</tr>
		                        </c:forEach>
								</tbody>
							</table>

						</c:when>
						<c:otherwise>
							<c:if test="${visitDtlList != null && fn:length(visitDtlList) > 0}" >
								<h4 class="my_stit top_margin">예약상품정보</h4>
								<table class="tCart_Board Mypage">
									<caption>
										<h1 class="blind">예약상품 목록입니다.</h1>
									</caption>
									<colgroup>
										<col style="width:142px">
										<col style="width:">
										<col style="width:150px">
										<col style="width:150px">
									</colgroup>
									<thead>
										<tr>
											<th colspan="2">상품/옵션/수량</th>
											<th>상품금액</th>
											<th>배송</th>
										</tr>
									</thead>
									<tbody>
				                    <c:forEach var="visitDtlList" items="${visitDtlList}" varStatus="status">

										<tr class="end_line">
											<td class="noline">
												<div class="cart_img">
													<img src="${visitDtlList.imgPath}">
												</div>
											</td>
											<td class="textL vaT">
												<a href="/front/goods/goods-detail?goodsNo=${visitDtlList.goodsNo}">${visitDtlList.goodsNm}
				                                    <c:if test="${empty visitDtlList.itemNm}">
														&nbsp;&nbsp; ${visitDtlList.ordQtt} 개
				                                    </c:if>
				                                </a>
				                                <c:if test="${!empty visitDtlList.itemNm}">
				                                	<p class="option"><c:out value="${visitDtlList.itemNm}"/> ${visitDtlList.ordQtt} 개</p>
				                                </c:if>
						                        <c:forEach var="optionList" items="${optionList}" varStatus="status">
						                            <p class="option_s">
						                                ${optionList.addOptNm} (
						                                <c:choose>
						                                    <c:when test="${optionList.addOptAmtChgCd eq '1'}">
						                                    +
						                                    </c:when>
						                                    <c:otherwise>

						                                    </c:otherwise>
						                                </c:choose>
						                                <fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
						                                           ${optionList.addOptBuyQtt} 개
						                            </p>
						                        </c:forEach>
											</td>
											<td>
												<span class="price"><fmt:formatNumber value='${visitDtlList.saleAmt}' type='number'/></span>원
											</td>
											<td rowspan="2">
												<p>매장픽업 </p>
				                                <c:choose>
				                                    <c:when test="${visitDtlList.rsvGb eq '02'}">
														<span class="label_reservation">예약전용</span>
				                                    </c:when>
				                                    <c:otherwise>
														<span class="label_reservation">사전예약</span>
				                                    </c:otherwise>
												</c:choose>

											</td>
										</tr>
			                        </c:forEach>
									</tbody>
								</table>
							</c:if>

						</c:otherwise>
					</c:choose>

					<div class="btn_davichi_area">
						<c:if test="${rsvDate >= today}">
							<c:if test="${visitVO.cancelYn ne 'Y'}">
							<button type="button" class="btn_info_cancel">예약취소</button>
							</c:if>
						</c:if>
					</div>
		          </div>
	              </form:form>
			</div>
    </div>
		<div class="popup" id="div_store_detail_popup" style="display:none;">
			<div class="popup_my_store_detail" id ="popup_my_store_detail">
				<div id="map3" style="width:100%;height:400px;"></div>
				<%@ include file="../order/map/mapApi.jsp" %>
			</div>
		</div>
		<!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>