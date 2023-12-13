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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 타임딜 &gt; 타임딜 등록</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
			$(document).ready(function() {
				// 저장
				$('#prmt_reg').on('click', function() {
					TimedealUtil.save();
				});

				// 상품찾기
				$('a.btn_goods_popup').on('click', function () {
					PopupUtil.open();
				});

				// 상품 삭제
				$('#btn_check_delete').on('click', function (e) {
					Dmall.EventUtil.stopAnchorAction(e);

					PopupUtil.delete();
				});
			});

			var TimedealUtil = {
				init: function () {
					Dmall.validate.set('formTimedealInsert');
				},
				validation: function () {
					var $srch_sc01 = $("#srch_sc01");
					var $srch_sc02 = $("#srch_sc02");
					var $srch_from_hour = $("#srch_from_hour");
					var $srch_from_minute = $("#srch_from_minute");
					var $srch_to_hour = $("#srch_to_hour");
					var $srch_to_minute = $("#srch_to_minute");
					if($srch_sc01.val() == '' || $srch_sc01.val() == null || $srch_sc02.val() == '' || $srch_sc02.val() == null) {
						Dmall.LayerUtil.alert("기간을 선택해주세요");
						return false;
					} else if($srch_sc01.val() > $srch_sc02.val()){
						Dmall.LayerUtil.alert("시작날짜가 종료날짜보다 큽니다.")
						return false;
					} else if($srch_sc01.val() == $srch_sc02.val()){
						if($srch_from_hour.val() > $srch_to_hour.val()){
							Dmall.LayerUtil.alert("시작시간이 종료시간보다 큽니다.");
							return false;
						} else if($srch_from_hour.val() == $srch_to_hour.val()){
							if($srch_from_minute.val() >= $srch_to_minute.val()){
								Dmall.LayerUtil.alert("시작시간이 종료시간보다 크거나 같습니다.")
								return false;
							}
						}
					}

					if( $("#prmtDcValue").val() == "0"){
						Dmall.LayerUtil.alert("타임딜 할인율을 입력하세요");
						return false;
					}

					if( $("#prmtDcValue").val() * 1 > 100){
						Dmall.LayerUtil.alert("타임딜 할인율은 최대 100% 입니다");
						return false;
					}

					if($('#tbody_timedeal_data').children('tr').length == 0) {
						Dmall.LayerUtil.alert('타임딜 상품을 등록하세요');
						return false;
					}

					return true;
				},
				save: function () {
					if (!TimedealUtil.validation()) {
						return;
					}

					if(Dmall.validate.isValid('formTimedealInsert')) {
						Dmall.LayerUtil.confirm('저장하시겠습니까?', function () {
							var url = '/admin/promotion/timeDeal-insert';
							var param = $('#formTimedealInsert').serialize();

							Dmall.AjaxUtil.getJSON(url, param, function (result) {
								if(result.success) {
									Dmall.FormUtil.submit('/admin/promotion/timeDeal');
								}
							});
						});
					}
				},
			}

			var PopupUtil = {
				open: function () {
					Dmall.LayerPopupUtil.open($('#layer_popup_goods_select'));
					GoodsSelectPopup._init(PopupUtil.applyCallback);
					$('#btn_popup_goods_search').trigger('click');
				},
				applyCallback: function (data) {
					var $tbody = $('#tbody_timedeal_data');

					// 중복 등록 검사
					var isApply = false;
					$tbody.find('input:hidden[name=goodsNoArr]').each(function () {
						if($(this).val() == data['goodsNo']) {
							isApply = true;
						}
					});
					if(isApply) {
						Dmall.LayerUtil.alert("이미 등록되었습니다.");
						return false;
					}

					// 최대갯수 검사
					if($tbody.children('tr').length > 0) {
						Dmall.LayerUtil.alert('상품은 최대 1개까지 등록할 수 있습니다.');
						return false;
					}

					// 타임딜 상품 유무 검사
					var url = '/admin/promotion/timeDeal-goods-exist';
					var param = {goodsNo: data['goodsNo']};

					Dmall.AjaxUtil.getJSON(url, param, function(result) {
						if (result != null && result === 1) {
							Dmall.LayerUtil.alert("프로모션이 진행 되고 있는 상품입니다.");
							return;
						}

						var index = $tbody.children('tr').length + 1;
						if(index == 1) {
							$('#goods_search_empty').hide();
							$('#goods_search_exist').show();
						}

						var template =
								'<tr>' +
								'<td>' +
								'<input type="hidden" name="goodsNo" value="'+data['goodsNo']+'">' +
								'<label for="chk_goodsNo_'+index+'" class="chack"><span class="ico_comm">' +
								'<input type="checkbox" id="chk_goodsNo_'+index+'" class="blind">' +
								'</span></label>' +
								'</td>' +
								'<td>'+index+'</td>' +
								'<td><img src="' + data['goodsImg02'] + '" alt=""></td>' +
								'<td>' + data['goodsNm'] + '</td>' +
								'<td>' + data['goodsNo'] + '</td>' +
								'<td>' + data["brandNm"] + '</td>'+
								'<td>' + data['sellerNm'] + '</td>' +
								'<td>' + Dmall.common.numberWithCommas(data["salePrice"]) + '</td>'+
								'<td>' + Dmall.common.numberWithCommas(data["stockQtt"]) + '</td>'+
								'<td>' + data["goodsSaleStatusNm"] + '</td>' +
								'<td>' + data['erpItmCode'] + '</td>'+
								'</tr>';

						$tbody.append(template);

						$('#cnt_total').html(index);
					});
				},
				delete: function () {
					var $tbody = $('#tbody_timedeal_data');
					$tbody.children('tr').each(function () {
						var $tr = $(this);
						if($tr.find('input[type=checkbox]').is(':checked')) {
							$tr.remove();
						}
					});

					var count = $tbody.children('tr').length;

					$tbody.children('tr').each(function (idx) {
						$(this).children('td').eq(1).text(idx+1)
					});

					$('#cnt_total').html(count);

					if(count < 1) {
						$('#goods_search_empty').show();
						$('#goods_search_exist').hide();
					}
				},
			}
		</script>   
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
				<div class="tlt_box">
					<div class="tlt_head">
						프로모션 설정<span class="step_bar"></span>
					</div>
					<h2 class="tlth2">타임딜 관리 </h2>
				</div>
            </div>
			<form id="formTimedealInsert" method="post">
	            <div class="line_box fri pb">
					<div class="tblw tblmany">
						<table summary="이표는 타임딜  검색 표 입니다. 구성은 타임딜명, 설명, 기간, 내용, 웹전용 타임딜배너, 모바일배너, 타임딜 상품설정 입니다.">
                    		<caption>타임딜 등록</caption>
                           	<colgroup>
								<col width="150px">
								<col width="">
							</colgroup>
							<tbody>
							<tr>
								<th>타임딜 기간</th>
								<td>
									<tags:calendarTime from="from" to="to" idPrefix="srch"/>
									<%--<label for="applyAlwaysYn" class="chack mr20">
										<input type="checkbox" name="applyAlwaysYn" id="applyAlwaysYn" value="Y" class="blind" />
										<span class="ico_comm">&nbsp;</span>
										무제한
									</label>--%>
								</td>
							</tr>
							<tr>
								<th>타임딜 할인율</th>
								<td>
									<span class="intxt">
										<input type="text" name="prmtDcValue" id="prmtDcValue" data-validation-engine="validate[required, maxSize[3]]" value="0" style="width:80px;">
									</span>
									%
								</td>
							</tr>
							<tr>
								<th>상품 설정</th>
								<td id="goods_search_empty">
									<a href="#none" class="btn--black_small btn_goods_popup">상품찾기</a>
								</td>
								<td id="goods_search_exist" style="display: none;">
									<div class="top_lay mb20">
										<div class="select_btn_left">
											<button class="btn_gray2" id="btn_check_delete">삭제</button>
										</div>
										<div class="select_btn_right">
											<span class="search_txt">
												총 <strong class="be" id="cnt_total">2</strong>개의 상품이 검색되었습니다.
											</span>
											<a href="#none" class="btn--black_small btn_goods_popup">상품찾기</a>
										</div>
									</div>
									<div class="tblh h600">
										<table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
											<caption>판매상품관리 리스트</caption>
											<colgroup>
												<col width="66px">
												<col width="66px">
												<col width="100px">
												<col width="18%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
											</colgroup>
											<thead>
											<tr>
												<th>
													<label for="all_check" class="chack"><span class="ico_comm">
														<input type="checkbox" name="table" id="all_check" />
													</span></label>
												</th>
												<th>번호</th>
												<th>이미지</th>
												<th>상품명</th>
												<th>상품코드</th>
												<th>브랜드</th>
												<th>판매자</th>
												<th>판매가</th>
												<th>재고</th>
												<th>판매상태</th>
												<th>다비전<br>상품코드</th>
											</tr>
											</thead>
											<tbody id="tbody_timedeal_data">
											</tbody>
										</table>
									</div>
								</td>
							</tr>
							</tbody>
						</table>
					</div>
				</div>
			</form>
		</div>
		<div class="bottom_box">
			<div class="left">
				<button class="btn--big btn--big-white" onclick="location.href='/admin/promotion/timeDeal'">목록</button>
			</div>
			<div class="right">
				<button class="btn--blue-round" id="prmt_reg">등록</button>
			</div>
		</div>

		<jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
	</t:putAttribute>
</t:insertDefinition>