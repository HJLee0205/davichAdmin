<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">정산내역 > 업체</t:putAttribute>
	<t:putAttribute name="script">
		<script>
			$(document).ready(function() {
				// 검색 버튼 클릭
				$('#btn_id_search').on('click', function(e) {
					Dmall.EventUtil.stopAnchorAction(e);

					$("#search_id_page").val("1");
					$('#form_id_search').attr('action','/admin/seller/calc-manager-list');
					$('#form_id_search').submit();
				});

				// 엑섹 다운로드 버튼 클릭
				$('#btn_download').on('click', function(e) {
					Dmall.EventUtil.stopAnchorAction(e);

					$('#form_id_search').attr('action','/admin/seller/calc-total-download');
					$('#form_id_search').submit();
					$('#form_id_search').attr('action','/admin/seller/calc-manager-list');
				});

				// 선택삭제 버튼 클릭
				$('#delSelect').on('click', function() {
					var selected = fn_selectedList();
					if(selected.length > 0) {
						Dmall.LayerUtil.confirm('선택된 정산내역을 삭제 하시겠습니까?', function() {
							var url = '/admin/seller/calculate-delete',
									param = {},
									key;

							var chk = 0;
							jQuery.each(selected, function(i, o) {
								key = 'list[' + i + '].calculateNo';
								param[key] = o;

								var stsCd = $('#statusCd_'+o).val();
								if (stsCd == "20") {
									chk++;
								}
							});

							if (chk > 0) {
								Dmall.LayerUtil.alert('승인완료된 정산자료는 삭제할 수 없습니다.');
								return false ;
							}

							Dmall.AjaxUtil.getJSON(url, param, function(result) {
								Dmall.validate.viewExceptionMessage(result, 'form_id_search');
								$('#form_id_search').submit();
							});
						});
					}
				});

				// 페이징 기능 활성
				$('div.bottom_lay').grid($('#form_id_search'));
			});

			// 선택된값 체크
			function fn_selectedList() {
				var selected = [];
				$('input[name=chkCalcNo]:checked').each(function() {
					selected.push($(this).val());     // 체크된 것만 값을 뽑아서 배열에 push
				});

				if (selected.length < 1) {
					Dmall.LayerUtil.alert('선택된 항목이 없습니다.');
				}
				return selected;
			}
		</script>

<%--		<script>--%>
<%--			var siteNo = "${siteNo}";--%>
<%--			$(document).ready(function() {--%>
<%--				//selectYear();--%>
<%--				//selectMonth();--%>

<%--				// 검색--%>
<%--				$('#btn_id_search').on('click', function() {--%>
<%--					selectManagerList();--%>
<%--				});--%>
<%--				--%>
<%--				$('#grid_id_sellerList').grid($('#form_id_search'));--%>

<%--				$('a.btn_exl').on('click',function() {--%>
<%--					//set_param();--%>
<%--					$('#form_id_search').attr('action','/admin/seller/calc-total-download');--%>
<%--					$('#form_id_search').submit();--%>
<%--					$('#form_id_search').attr('action','/admin/seller/calc-manager-list');--%>
<%--				});--%>

<%--				if ($('input[name=calcStart]').val() == '') {--%>
<%--	                $('input[name=calcStart]').val(currToday);--%>
<%--	                $('input[name=calcEnd]').val(currToday);--%>
<%--				}--%>
<%--			});--%>
<%--			--%>
<%--  		  	// 오늘날짜 가져오기	--%>
<%--  		  	function currToday(){--%>
<%--  		      var date = new Date();--%>
<%--  		 --%>
<%--  		      var year  = date.getFullYear();--%>
<%--  		      var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함--%>
<%--  		      var day   = date.getDate();--%>
<%--  		  --%>
<%--  		      if (("" + month).length == 1) { month = "0" + month; }--%>
<%--  		      if (("" + day).length   == 1) { day   = "0" + day;   }--%>
<%--  		     --%>
<%--  				return year + "-" + month + "-" + day;  --%>
<%--  		  	}  			--%>

<%--// 			function set_param() {--%>
<%--// 				var yr = $("#selectYear option:selected").val();--%>
<%--// 				var mm = $("#selectMonth option:selected").val();--%>

<%--// 				$("input[name=yr]").val(yr);--%>
<%--// 				$("input[name=mm]").val(mm);--%>

<%--// 				var lastDay = (new Date(yr, mm, 0)).getDate();--%>
<%--				--%>
<%--				--%>
<%--// 				$("input[name=calcStart]").val(yr + "-" + mm + "-" + "01");--%>
<%--// 				$("input[name=calcEnd]").val(yr + "-" + mm + "-" + lastDay);--%>

<%--// 				if (mm == null || mm == "") {--%>
<%--// 					$("input[name=calcStart]").val(yr + "-" + "01" + "-" + "01");--%>
<%--// 					$("input[name=calcEnd]").val(yr + "-" + "12" + "-" + "31");--%>
<%--// 				}--%>
<%--// 			}--%>

<%--			// 정산상세 목록조회--%>
<%--			function viewLedgerDtl(calcNo, startdt, enddt, sellerNo) {--%>
<%--				var param = {};--%>
<%--				param.sellerNo = sellerNo;--%>
<%--				param.calcStart = startdt;--%>
<%--				param.calcEnd = enddt;--%>
<%--				param.searchDate = '02';--%>
<%--				param.calculateNo = calcNo;--%>
<%--				param.call = "manager";--%>

<%--				Dmall.FormUtil.submit('/admin/seller/calc-manager-dtl-list', param);--%>
<%--			}--%>

<%--			function viewDeductInfo(calcNo) {--%>
<%--				Dmall.LayerPopupUtil.open($("#deductLayout"));--%>
<%--				openDeductLayer(calcNo);--%>
<%--			}--%>

<%--// 			var toDay = new Date();--%>

<%--// 			// 기간검색_년--%>
<%--// 			function selectYear() {--%>
<%--// 				var year = toDay.getFullYear();--%>

<%--// 				//var yearVal = jQuery("#selectYear option:selected").val();--%>
<%--// 				var yearVal = $("input[name=yr]").val();--%>
<%--// 				var yearData = 0;--%>

<%--// 				jQuery("#select1").remove();--%>

<%--// 				jQuery("#selectId")--%>
<%--// 						.append(--%>
<%--// 								"<span class='select' id='select1'><select id='selectYear' onchange='javascript:selectChange()'></select></span> ");--%>

<%--// 				if (yearVal == null || yearVal == "") {--%>
<%--// 					yearData = year;--%>
<%--// 				} else {--%>
<%--// 					yearData = Number(yearVal);--%>
<%--// 				}--%>

<%--// 				jQuery("#select1").prepend(--%>
<%--// 						"<label for=''>" + yearData + "년</label>");--%>
<%--// 				for (var i = yearData + 4; i > yearData - 5; i--) {--%>
<%--// 					jQuery("#selectYear").append(--%>
<%--// 							"<option value='"+ i + "'>" + i + "년</option>");--%>
<%--// 				}--%>
<%--// 				$("#selectYear > option[value='" + yearData + "']").attr(--%>
<%--// 						"selected", true);--%>
<%--// 			}--%>

<%--// 			// 기간검색_월--%>
<%--// 			function selectMonth() {--%>
<%--// 				var month = (toDay.getMonth() + 1);--%>

<%--// 				//var monthVal = jQuery("#selectMonth option:selected").val();--%>
<%--// 				var monthVal = $("input[name=mm]").val();--%>

<%--// 				jQuery("#select2").remove();--%>

<%--// 				jQuery("#selectId")--%>
<%--// 						.append(--%>
<%--// 								"<span class='select' id='select2'><select id='selectMonth'></select></span> ");--%>
<%--// 				jQuery("#selectMonth").append("<option value=''>전체</option>");--%>

<%--// 				for (var i = 1; i < 13; i++) {--%>
<%--// 					if (i < 10) {--%>
<%--// 						jQuery("#selectMonth").append(--%>
<%--// 								"<option value='0"+ i + "'>0" + i--%>
<%--// 										+ "월</option>");--%>
<%--// 					} else {--%>
<%--// 						jQuery("#selectMonth").append(--%>
<%--// 								"<option value='"+ i + "'>" + i + "월</option>");--%>
<%--// 					}--%>
<%--// 				}--%>

<%--// 				if (monthVal == null || monthVal == "") {--%>
<%--// 					//                     if(month < 10){--%>
<%--// 					//                         jQuery("#select2").prepend("<label for=''>0"+ month +"월</label>");--%>
<%--// 					//                         jQuery("#selectMonth option[value='0"+ month +"']").attr("selected", true);--%>
<%--// 					//                     }else{--%>
<%--// 					//                         jQuery("#select2").prepend("<label for=''>"+ month +"월</label>");--%>
<%--// 					//                         jQuery("#selectMonth option[value='"+ month +"']").attr("selected", true);--%>
<%--// 					//                     }--%>

<%--// 					jQuery("#select2").prepend("<label for=''>전체</label>");--%>
<%--// 					jQuery("#selectMonth option[value='']").attr("selected",--%>
<%--// 							true);--%>

<%--// 				} else {--%>
<%--// 					jQuery("#select2").prepend(--%>
<%--// 							"<label for=''>" + monthVal + "월</label>");--%>
<%--// 					jQuery("#selectMonth option[value='" + monthVal + "']")--%>
<%--// 							.attr("selected", true);--%>
<%--// 				}--%>
<%--// 			}--%>

<%--			// 기간검색_년,월,일 변경에 따른 처리함수--%>
<%--// 			function selectChange() {--%>
<%--// 				selectMonth();--%>
<%--// 			}--%>

<%--			function selectManagerList() {--%>
<%--				//set_param();--%>
<%--				$("#search_id_page").val("1");--%>
<%--				$('#form_id_search').attr('action','/admin/seller/calc-manager-list');--%>
<%--				$('#form_id_search').submit();--%>
<%--			}--%>
<%--			--%>
<%--            // 삭제--%>
<%--            jQuery('#btn_id_delete').on('click', function(e) {--%>
<%--                selected = fn_selectedList();--%>
<%--                if (selected.length > 0) {--%>
<%--                    Dmall.LayerUtil.confirm('선택된 정산내역을 삭제 하시겠습니까?', function() {--%>
<%--                        var url = '/admin/seller/calculate-delete',--%>
<%--                                param = {},--%>
<%--                                key,--%>
<%--                                selected = fn_selectedList();--%>
<%--                            var chk = 0;--%>
<%--                            jQuery.each(selected, function(i, o) {--%>
<%--                                key = 'list[' + i + '].calculateNo';--%>
<%--                                param[key] = o;--%>
<%--                                --%>
<%--                                var stsCd = $('#statusCd_'+o).val();--%>
<%--                                if (stsCd == "20") {--%>
<%--                                	chk++;--%>
<%--                                }--%>
<%--                            });        --%>
<%--                            --%>
<%--							if (chk > 0) {--%>
<%--                                Dmall.LayerUtil.alert('승인완료된 정산자료는 삭제할 수 없습니다.');--%>
<%--                            	return false ;--%>
<%--							}                            --%>
<%--                            --%>
<%--                            Dmall.AjaxUtil.getJSON(url, param, function(result) {--%>
<%--                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');--%>
<%--                                jQuery('#form_id_search').submit();--%>
<%--                            });--%>
<%--                    });--%>
<%--                }--%>
<%--            });            --%>

<%--            // 선택된값 체크--%>
<%--            function fn_selectedList() {--%>
<%--                var selected = [];--%>
<%--                $("input[name=chkCalcNo]:checked").each(function() {--%>
<%--                    selected.push($(this).val());     // 체크된 것만 값을 뽑아서 배열에 push--%>
<%--                });--%>
<%--                --%>
<%--                if (selected.length < 1) {--%>
<%--                    Dmall.LayerUtil.alert('선택된 항목이 없습니다.');--%>
<%--                }--%>
<%--                return selected;--%>
<%--            }--%>
<%--            			--%>
<%--			--%>
<%--		</script>--%>
	</t:putAttribute>
	<t:putAttribute name="content">
		<div class="sec01_box">
			<div class="tlt_box">
				<div class="tlt_head">
					업체 설정<span class="step_bar"></span>
				</div>
				<h2 class="tlth2">정산내역</h2>
			</div>
			<div class="search_box_wrap">
				<div class="search_box">
					<!-- search_tbl -->
					<form:form action="/admin/seller/calc-manager-list" id="form_id_search" commandName="sellerSO">
						<input type="hidden" name="_action_type" value="INSERT">
						<input id="search_id_page" name="page" type="hidden" value="1">
						<input id="rows" name="rows" type="hidden" value="10">
						<input type="hidden" name="sort" value="">
						<div class="search_tbl">
							<table summary="">
								<caption>판매자 관리</caption>
								<colgroup>
									<col width="150px">
									<col width="">
								</colgroup>
								<tbody>
								<tr>
									<th>기간</th>
									<td>
										<tags:calendar from="calcStart" to="calcEnd" idPrefix="srch"/>
									</td>
								</tr>
								<tr>
									<th>판매자</th>
									<td>
										<span class="select">
											<label for="sel_seller">전체</label>
											<select name="sellerNo" id="sel_seller">
												<cd:sellerOption siteno="${so.siteNo}" includeTotal="true"/>
											</select>
										</span>
									</td>
								</tr>
								</tbody>
							</table>
						</div>
						<div class="btn_box txtc">
							<a href="#none" class="btn--black" id="btn_id_search">검색</a>
						</div>
					</form:form>
				</div>
				<div class="line_box pb" id="grid_id_sellerList">
					<div class="top_lay">
						<div class="select_btn_left">
							<span class="search_txt">
								총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>개의 정산내역건이 검색되었습니다.
							</span>
						</div>
						<div class="select_btn_right">
							<button class="btn_exl" id="btn_download">
								<span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
							</button>
						</div>
					</div>
					<!-- tblh -->
					<div class="tblh">
						<table summary="판매자 리스트" id="table_id_sellerList">
							<caption>판매자 리스트</caption>
							<colgroup>
								<col width="4%">
								<col width="12%">
								<col width="12%">
								<col width="12%">
								<col width="12%">
								<col width="12%">
								<col width="12%">
								<col width="12%">
								<col width="12%">
							</colgroup>
							<thead>
							<tr>
								<th>
									<label for="chack05" class="chack">
										<span class="ico_comm"><input type="checkbox" name="table" id="chack05"></span>
									</label>
								</th>
								<th>번호</th>
								<th>정산일자</th>
								<th>업체명</th>
								<th>정산기준 시작일</th>
								<th>정산기준 종료일</th>
								<th>결제금액</th>
								<th>수수료</th>
								<th>정산금액</th>
							</tr>
							</thead>
							<tbody id="tbody_id_memberList">
							<c:choose>
								<c:when test="${fn:length(resultListModel.resultList) == 0}">
									<tr>
										<td colspan="9">정산내역 데이터가 존재하지 않습니다.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach var="sellerList" items="${resultListModel.resultList}" varStatus="status">
										<tr data-grp-cd="${sellerList.calculateNo}">
											<td>
												<label for="chkCalcNo_${sellerList.rowNum}" class="chack">
													<span class="ico_comm"><input type="checkbox" name="chkCalcNo" id="chkCalcNo_${sellerList.rowNum}" value="${sellerList.calculateNo}" class="blind"></span>
												</label>
											</td>
											<td>${sellerList.rowNum}</td>
											<td>${sellerList.calculateDttm}</td>
											<td>${sellerList.sellerNm}</td>
											<td>${sellerList.calculateStartdt}</td>
											<td>${sellerList.calculateEnddt}</td>
											<td><fmt:formatNumber value="${sellerList.paymentAmt}" pattern="#,###" /></td>
											<td><fmt:formatNumber value="${sellerList.cmsTotal}" pattern="#,###" /></td>
											<td><fmt:formatNumber value="${sellerList.calculateAmt}" pattern="#,###" /></td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
					</div>
					<!-- //tblh -->
					<!-- bottom_lay -->
					<div class="bottom_lay">
						<grid:paging resultListModel="${resultListModel}" />
					</div>
					<!--// bottom_lay -->
				</div>
			</div>
			<!-- bottom_box -->
			<div class="bottom_box">
				<div class="left">
					<button class="btn--big btn--big-white" id="delSelect">선택삭제</button>
				</div>
			</div>
			<!-- //bottom_box -->
		</div>
	</t:putAttribute>
</t:insertDefinition>
