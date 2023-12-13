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
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 기획전 &gt; 기획전 등록</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>    
    <t:putAttribute name="script">
		<script type="text/javascript" src="/admin/js/lib/jquery/jquery.qrcode.min.js"></script>
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>    
        <script type="text/javascript">
            $(document).ready(function() {
				ExhibitionUtil.init();

				// 상품군 - select change
				// $('select[name="prmtTypeCd"]').change(function(){
				// 	var prmtTypeCd = $(this).val();
				//
				// 	if(prmtTypeCd == '06'){
				// 		$('#firstBuySpcPrice_layer').show();
				// 	}else{
				// 		$('#firstBuySpcPrice_layer').hide();
				// 	}
				// });

				// 기획전 상품가격 - radio change
				$('input[name="prmtDcGbCd"]').change(function(){
					var selVal = $(this).val();

					if(selVal == '01'){
						$('#dcValueSpan').text('%');
					}else{
						$('#dcValueSpan').text('원');
					}
				});

                // 저장
                $('#exhibition_reg').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

					ExhibitionUtil.save();
                });

				// 대표이미지
				$('#input_id_image').on('change', function (e) {
					Dmall.EventUtil.stopAnchorAction(e);

					if($(this)[0].files.length < 1) {
						$(this).siblings('.upload_file').html('');
					}

					if(this.files && this.files[0]) {
						var fileNm = this.files[0].name;
						var reader = new FileReader();
						reader.onload = function(e) {
							var template =
									'<img src="'+e.target.result+'" alt="미리보기 이미지">' +
									'<span class="txt">'+fileNm+'</span>' +
									'<button class="cancel">삭제</button>';

							$('div.upload_file').append(template);
						};
						reader.readAsDataURL(this.files[0]);

						$('input.upload-name').val(fileNm);
					}
				});

				// 이미지 삭제
				$(document).on('click', 'button.cancel', function (e) {
					Dmall.EventUtil.stopAnchorAction(e);

					var $obj = $(e.target).closest('div.upload_file');
					$obj.closest('td').find('input.upload-name').val('');
					$obj.siblings('input[type=file]').val('');
					$obj.html('');
				});

				// qrcode 다운로드
				$('#btn_download').on('click', function (e) {
					Dmall.EventUtil.stopAnchorAction(e);

					ExhibitionUtil.download();
				});

				// 팝업 - 상품 찾기
				$('a.btn_goods_popup').on('click', function () {
					PopupUtil.open();
				});

				// 팝업 - 상품 삭제
				$('#btn_check_delete').on('click', function(e){
					PopupUtil.delete();
				});
            });

			var ExhibitionUtil = {
				init: function () {
					Dmall.DaumEditor.init();
					Dmall.DaumEditor.create('exhibition_content');

					Dmall.validate.set('formExhibitionInsert');

					//qrcode
					$('#qrcodeCanvas').qrcode({
						width: 100,
						height: 100,
						text: 'http://www.davichmarket.com/front/qrcode?goodsNo=${prmtNo}'
					});
				},
				validation: function () {
					if( $("#goodsTypeCd").val() == ""){
						Dmall.LayerUtil.alert("상품군을 선택하세요");
						return false;
					}

					if( $("#prmtTypeCd").val() == ""){
						Dmall.LayerUtil.alert("프로모션 유형을 선택하세요");
						return false;
					}

					if( $("#prmtNm").val() == ""){
						Dmall.LayerUtil.alert("기획전 명을 입력하세요");
						return false;
					}

					if( $("#prmtDscrt").val() == ""){
						Dmall.LayerUtil.alert("기획전 설명을 입력하세요");
						return false;
					}

					// 기획전행사 시작일시 종료일시
					var $srch_sc01 = $("#srch_sc01");
					var $srch_from_hour = $("#srch_from_hour");
					var $srch_from_minute = $("#srch_from_minute");
					var $srch_sc02 = $("#srch_sc02");
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

					if($('div.upload_file').children().length == 0) {
						Dmall.LayerUtil.alert("기획전 대표이미지를 첨부하세요");
						return false;
					}
					if(!fn_selectedList()) {
						Dmall.LayerUtil.alert("기획전 상품을 추가 하세요");
						return false;
					}
					/*if( $("#prmtDcValue").val() == ""){
						Dmall.LayerUtil.alert("기획전 상품가격을 입력하세요");
						return false;
					}*/

					if( $("#prmtLoadrate").val()*1 > 100){
						Dmall.LayerUtil.alert("본사 부담율은 최대 100% 입니다")
						return false;
					}

					return true;
				},
				save: function () {
					if(!ExhibitionUtil.validation()) {
						return;
					}
					if($('#prmtDcValue').val() == "" || $('#prmtDcValue').val() == "0") {
						if(Dmall.validate.isValid('formExhibitionInsert')) {
							Dmall.LayerUtil.confirm('저장하시겠습니까?', function () {
								Dmall.DaumEditor.setValueToTextarea('exhibition_content');

								var url = '/admin/promotion/exhibition-insert';

								$('#formExhibitionInsert').ajaxSubmit({
									url: url,
									dataType: 'json',
									success: function(result) {
										Dmall.LayerUtil.alert(result.message).done(function () {
											Dmall.FormUtil.submit('/admin/promotion/exhibition');
										});
									}
								})
							});
						}
					} else {
						var url = '/admin/promotion/exhibition-goods-exist';
						var goodsNoArr = fn_selectedString();
						var param = {goodsNos: goodsNoArr};

						console.log("param = ", param);
						Dmall.AjaxUtil.getJSON(url, param, function (result) {
							if (result != null && result > 0) {
								Dmall.LayerUtil.alert("프로모션이 할인율이 적용 되고 있는 상품이 있습니다.");
								return;
							}
							if (Dmall.validate.isValid('formExhibitionInsert')) {
								Dmall.LayerUtil.confirm('저장하시겠습니까?', function () {
									Dmall.DaumEditor.setValueToTextarea('prmtContentHtml');

									var url = '/admin/promotion/exhibition-insert';

									$('#formExhibitionInsert').ajaxSubmit({
										url: url,
										dataType: 'json',
										success: function (result) {
											Dmall.LayerUtil.alert(result.message).done(function () {
												Dmall.FormUtil.submit('/admin/promotion/exhibition');
											});
										}
									})
								});
							}
						});
					}
				},
				download: function () {
					if ($('#qrcodeWidth').val() == '' || $('#qrcodeHeight').val() == '') {
						alert("사이즈를 지정해주세요.");
						return false;
					}

					var div = document.createElement("div");
					$(div).qrcode({
						width: $('#qrcodeWidth').val(),
						height: $('#qrcodeHeight').val(),
						text: 'http://www.davichmarket.com/front/qrcode?goodsNo=${prmtNo}'
					});
					var canvas = $(div).find("canvas");
					var img = canvas.get(0).toDataURL("image/png");
					var link = document.createElement("a");

					link.download = "_QRCODE.png";
					link.href = img;
					document.body.appendChild(link);
					link.click();
					document.body.removeChild(link);
					delete link;
				},
			}

			var PopupUtil = {
				open: function () {
					Dmall.LayerPopupUtil.open($('#layer_popup_goods_select'));
					GoodsSelectPopup._init(PopupUtil.applyCallback);
					$('#btn_popup_goods_search').trigger('click');
				},
				applyCallback: function (data) {
					var $tbody = $('#tbody_exhibition_data');

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
					console.log("prmtDcValue = ", $("#prmtDcValue").val());
					if( $("#prmtDcValue").val() != "" && $("#prmtDcValue").val() != "0") {
						// 기획전 상품 유무 검사
						var url = '/admin/promotion/exhibition-goods-exist';
						var param = {goodsNo: data['goodsNo']};

						Dmall.AjaxUtil.getJSON(url, param, function (result) {
							if (result != null && result === 1) {
								Dmall.LayerUtil.alert("프로모션이 진행 되고 있는 상품입니다.");
								return;
							}

							var index = $tbody.children('tr').length + 1;
							if (index == 1) {
								$('#goods_search_empty').hide();
								$('#goods_search_exist').show();
							}

							var template =
									'<tr>' +
									'<td>' +
									'<input type="hidden" name="goodsNoArr" value="' + data['goodsNo'] + '">' +
									'<label for="chk_goodsNo_' + index + '" class="chack"><span class="ico_comm">' +
									'<input type="checkbox" id="chk_goodsNo_' + index + '" class="blind">' +
									'</span></label>' +
									'</td>' +
									'<td>' + index + '</td>' +
									'<td><img src="' + data['goodsImg02'] + '" alt=""></td>' +
									'<td>' + data['goodsNm'] + '</td>' +
									'<td>' + data['goodsNo'] + '</td>' +
									'<td>' + data["brandNm"] + '</td>' +
									'<td>' + data['sellerNm'] + '</td>' +
									'<td>' + Dmall.common.numberWithCommas(data["salePrice"]) + '</td>' +
									'<td>' + Dmall.common.numberWithCommas(data["supplyPrice"]) + '</td>' +
									'<td>' + Dmall.common.numberWithCommas(data["stockQtt"]) + '</td>' +
									'<td>' + data["goodsSaleStatusNm"] + '</td>' +
									'</tr>';

							$tbody.append(template);

							$('#cnt_total').html(index);
						});
					} else {
						var index = $tbody.children('tr').length + 1;
						if (index == 1) {
							$('#goods_search_empty').hide();
							$('#goods_search_exist').show();
						}

						var template =
								'<tr>' +
								'<td>' +
								'<input type="hidden" name="goodsNoArr" value="' + data['goodsNo'] + '">' +
								'<label for="chk_goodsNo_' + index + '" class="chack"><span class="ico_comm">' +
								'<input type="checkbox" id="chk_goodsNo_' + index + '" class="blind">' +
								'</span></label>' +
								'</td>' +
								'<td>' + index + '</td>' +
								'<td><img src="' + data['goodsImg02'] + '" alt=""></td>' +
								'<td>' + data['goodsNm'] + '</td>' +
								'<td>' + data['goodsNo'] + '</td>' +
								'<td>' + data["brandNm"] + '</td>' +
								'<td>' + data['sellerNm'] + '</td>' +
								'<td>' + Dmall.common.numberWithCommas(data["salePrice"]) + '</td>' +
								'<td>' + Dmall.common.numberWithCommas(data["supplyPrice"]) + '</td>' +
								'<td>' + Dmall.common.numberWithCommas(data["stockQtt"]) + '</td>' +
								'<td>' + data["goodsSaleStatusNm"] + '</td>' +
								'</tr>';

						$tbody.append(template);

						$('#cnt_total').html(index);
					}
				},
				delete: function() {
					var $tbody = $('#tbody_exhibition_data');
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
				}
			}

			function fn_selectedList() {
				var selected = [];
				console.log("tbody_exhibition_data goodsNoArr = ", $('#tbody_exhibition_data').find('input:hidden[name=goodsNoArr]'));
				$('#tbody_exhibition_data').find('input:hidden[name=goodsNoArr]').each(function() {
					console.log("goodsNo = ", $(this).val());
					selected.push($(this).val());
				});
				if (selected.length < 1) {
					alert('선택된 상품이 없습니다.');
					return false;
				}
				return selected;
			}

			function fn_selectedString() {
				var selected = "";
				console.log("tbody_exhibition_data goodsNoArr = ", $('#tbody_exhibition_data').find('input:hidden[name=goodsNoArr]'));
				$('#tbody_exhibition_data').find('input:hidden[name=goodsNoArr]').each(function() {
					console.log("goodsNo = ", $(this).val());
					selected += $(this).val() + ",";
				});
				if (selected == "") {
					alert('선택된 상품이 없습니다.');
					return false;
				}
				return selected;
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
					<h2 class="tlth2">기획전 관리</h2>
				</div>
            </div>
			<form id="formExhibitionInsert" method="post">
				<input type="hidden" name="prmtNo" value="${prmtNo}">
	            <div class="line_box fri pb">
					<div class="tblw tblmany">
						<table summary="이표는 기획전  검색 표 입니다. 구성은 기획전명, 설명, 기간, 내용, 웹전용 기획전배너, 모바일배너, 기획전 상품설정 입니다.">
                    		<caption>기획전 등록</caption>
                           	<colgroup>
                               	<col width="160px" />
								<col width="" />
							</colgroup>
							<tbody>
							<tr>
								<th>상품군</th>
								<td>
									<span class="select">
										<label for="goodsTypeCd"></label>
										<select name="goodsTypeCd" id="goodsTypeCd">
											<tags:option codeStr=":선택;01:안경테;02:선글라스;04:콘택트렌즈;03:안경렌즈" />
										</select>
									</span>
								</td>
							</tr>
							<tr>
								<th>프로모션 유형</th>
								<td>
									<span class="select">
										<label for="prmtTypeCd"></label>
										<select name="prmtTypeCd" id="prmtTypeCd">
											<tags:option codeStr="01:혜택;02:쿠폰;03:사은품;04:세일;06:첫 구매 특가" />
										</select>
									</span>
								</td>
							</tr>
							<tr>
								<th>기획전 명</th>
								<td>
									<span class="intxt wid100p"><input type="text" value="" id="prmtNm" name="prmtNm" data-validation-engine="validate[required, maxSize[100]]"/></span>
								</td>
							</tr>
							<tr>
								<th>기획전 설명</th>
								<td>
									<span class="intxt wid100p"><input type="text" value="" id="prmtDscrt"  name="prmtDscrt" data-validation-engine="validate[required, maxSize[300]]"/></span>
								</td>
							</tr>
							<tr>
								<th>SEO 검색용 태그달기</th>
								<td>
							 		<div class="txt_area">
										<textarea name="seoSearchWord" id="txt_seo_search_word" data-validation-engine="validate[maxSize[2500]]"></textarea>
									</div>
									<span class="br2"></span>
									<span class="fc_pr1 fs_pr1">
										&#183; 쉼표(,)로 구분하여 등록해주세요 ex) 안경, 안경테, 안경렌즈
									</span>
								</td>
							</tr>
							<tr>
								<th>기획전 기간</th>
								<td>
									<tags:calendarTime from="from" to="to" idPrefix="srch"/>
								</td>
							</tr>
							<tr>
								<th>기획전 내용</th>
								<td>
									<div class="edit">
										<textarea id="exhibition_content" class="blind"  name="prmtContentHtml" maxlength="8000"></textarea>
									</div>
								</td>
							</tr>
							<tr>
								<th>기획전 대표 이미지</th>
								<td>
									<span class="intxt imgup2"><input type="text" id="file_route1" class="upload-name" readonly></span>
									<label for="input_id_image" class="filebtn on">파일첨부</label>
									<input type="file" class="filebox" id="input_id_image" name="file" accept="image/*">
									<div class="desc_txt br2">
										· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )<br>
										<em class="point_c6">· 845px X 475px  사이즈로 등록하여 주세요.</em>
									</div>
									<div class="upload_file"></div>
								</td>
							</tr>
							<tr>
								<th>기획전 상품 설정</th>
								<td id="goods_search_empty">
									<a href="#none" class="btn--black_small btn_goods_popup">상품 찾기</a>
								</td>
								<td id="goods_search_exist" style="display: none;">
									<div class="top_lay">
										<div class="select_btn_left">
											<a href="#none" class="btn_gray2" id="btn_check_delete">삭제</a>
										</div>
										<div class="select_btn_right">
											<span class="search_txt">
												총 <strong class="be" id="cnt_total">2</strong>개의 상품이 검색되었습니다.
											</span>
											<a href="#none" class="btn--black_small btn_goods_popup">상품 찾기</a>
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
													<label for="all_check" class="chack">
														<span class="ico_comm"><input type="checkbox" name="table" id="all_check" /></span>
													</label>
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
											<tbody id="tbody_exhibition_data">
											</tbody>
										</table>
									</div>
								</td>
							</tr>
							<tr>
								<th>기획전 상품가격</th>
								<td>
									<tags:radio name="prmtDcGbCd" codeStr="01:할인율;02:할인금액" idPrefix="prmtDcGbCd" value="01"/>
									<span class="intxt shot">
										<input type="text" name="prmtDcValue" id="prmtDcValue" data-validation-engine="validate[required, maxSize[20]]" style="width:80px;">
									</span>
									<span id="dcValueSpan">%</span>
								</td>
							</tr>
							<tr>
								<th>본사 부담율</th>
								<td>
									<input type="text" name="prmtLoadrate" id="prmtLoadrate" data-validation-engine="validate[required, maxSize[3]]" value="0" style="width:80px;">
									<span class="marginL05">%</span>
								</td>
							</tr>
							<tr>
								<th>게시물 노출 여부</th>
								<td>
									<tags:radio name="prmtMainExpsUseYn" codeStr="Y:사용;N:미사용" idPrefix="prmtMainExpsUseYn" value="N"/>
								</td>
							</tr>
							<tr id="firstBuySpcPrice_layer" style="display: none;">
								<th>첫구매 특가</th>
								<td>
									<input type="number" name="firstBuySpcPrice" id="firstBuySpcPrice" value="0" data-validation-engine="validate[required, maxSize[20]]" style="width:80px;">
								</td>
							</tr>
							<tr>
								<th>QR코드</th>
								<td class="txtl qrcode">
									<span id="qrcodeCanvas"></span>
									<span>
										이미지 사이즈
										<input type="text" id="qrcodeWidth" class="ml5 mr10">
										<img src="/admin/img/common/btn_close_popup02.png" alt="" class="icon_close ml5mr5">
										<input type="text" id="grcodeHeight" class="mr5">
										<button class="btn--black_small f-en" id="btn_download">download</button>
									</span>
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
				<button class="btn--big btn--big-white" onclick="location.href='/admin/promotion/exhibition'">목록</button>
			</div>
			<div class="right">
				<button class="btn--blue-round" id="exhibition_reg">저장</button>
			</div>
		</div>

		<jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
	</t:putAttribute>
</t:insertDefinition>