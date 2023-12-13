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
<%@ taglib prefix="popup" tagdir="/WEB-INF/tags/popup" %>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">배너 관리</t:putAttribute>
	<t:putAttribute name="script">
		<script>

			jQuery(document).ready(function() {
				initGoodsInfo();
				var typeCd = "${so.typeCd}";
				var editYn = "${editYn}";

				if (editYn === 'Y') {
					bindAtchFile(typeCd);

					if (typeCd === 'sub' || typeCd === 'goodsTop' || typeCd === 'goodsBottom') {
						bindBannerGoodsInfo('${resultModel.data.bannerNo}');
					}
				}
				// 이미지 첨부 시 미리보기 이미지 표시
				$('input[type=file]').change(function() {
					console.log("this.files = ", this.files);
					if(this.files && this.files[0]) {
						var fileNm = this.files[0].name;
						var name = $(this).attr('name');
						var reader = new FileReader();
						reader.onload = function(e) {
							var template =
									'<img src="' + e.target.result + '" alt="미리보기 이미지"><br>' +
									'<span class="txt">' + fileNm + '</span>' +
									'<button class="cancel">삭제</button>';
							$('.preview_' + name).html(template);
						};
						reader.readAsDataURL(this.files[0]);
					}
				});

				// 이미지 삭제 버튼 클릭
				$('.upload_file').on('click', '.cancel', function(e) {
					Dmall.EventUtil.stopAnchorAction(e);

					var obj = $(e.target).parents('.upload_file');
					var strIdx = obj.attr('class').lastIndexOf('file');
					var name = obj.attr('class').substring(strIdx, strIdx + 5);
					$('input[name=' + name + ']').val('');
					obj.html('');
				});

				// 상품 검색
				jQuery('#apply_goods_srch_btn').on('click', function(e) {
					Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
					GoodsSelectPopup._init( fn_callback_pop_apply_goods );
					$("#btn_popup_goods_search").trigger("click");
				});

				$("#form_id_detail").validationEngine('attach', {promptPosition : "bottomRight", scroll: false, binded: false});

				/*// 메뉴 정보 변경시 처리
				jQuery('#bannerMenuCd').on('change', function() {
					var bannerMenuCd = jQuery('#bannerMenuCd option:selected').val();
					var changeYN = jQuery('#changeYN').val();
					// 빈값일 경우
					if(bannerMenuCd == ""){
						jQuery('#bannerAreaCd').html("<option value=\"\">위치정보</option>");
						jQuery('#bannerAreaCd').trigger('change');
					}else{
						if(changeYN == "Y"){
							Dmall.CodeUtil.getCodeListUDV1("BANNER_AREA_CD", bannerMenuCd, setCodeToSelectMenu);
						}
					}
				});

				// 위치 정보 변경시 처리
				jQuery('#bannerAreaCd').on('change', function() {
					var bannerMenuCd = jQuery('#bannerMenuCd option:selected').val();
					var bannerAreaCd = jQuery('#bannerAreaCd option:selected').val();
					if(bannerMenuCd == 'CM' && bannerAreaCd == 'TB'){
						$('#tr_topBannerColorValue').show();
					}else{
						$('#tr_topBannerColorValue').hide();
					}
				});*/

				/*function setCodeToSelectMenu(result) {
					//
					Dmall.CodeUtil.setCodeToOptionNew(result.resultList, jQuery('#bannerAreaCd'), "위치정보");
					jQuery('#bannerAreaCd').trigger('change');
				}*/

				// 등록
				jQuery('#a_id_save').on('click', function(e) {
					e.preventDefault();
					e.stopPropagation();
					var bannerNo = "${resultModel.data.bannerNo}";
					var $srch_sc01 = $("#date_val_sc01");
					var $srch_sc02 = $("#date_val_sc02");
					var $applyAlwaysYn = $("#lb_applyAlwaysYn");


					var ex_file1 = $("#ex_file1").val();
					if(bannerNo == "" && ex_file1 == ""){
						Dmall.LayerUtil.alert("이미지파일을 첨부하셔야 합니다.");
						return;
					}
					var typeCd = "${so.typeCd}";

					if(typeCd !== "goodsTop" && typeCd !== "goodsBottom") {
						if (!$applyAlwaysYn.hasClass('on')) {
							if ($srch_sc01.val() == '' || $srch_sc01.val() == null || $srch_sc02.val() == '' || $srch_sc02.val() == null) {
								Dmall.LayerUtil.alert("기간을 선택해주세요");
								return false;
							} else if ($srch_sc01.val() > $srch_sc02.val()) {
								Dmall.LayerUtil.alert("시작날짜가 종료날짜보다 큽니다.")
								return false;
							}
						}

						dateSum();
					}

					// 다비치웹 최상단배너가 아닐시 해당 항목 초기화
					/*var bannerMenuCd = jQuery('#bannerMenuCd option:selected').val();
					var bannerAreaCd = jQuery('#bannerAreaCd option:selected').val();
					if(bannerMenuCd == 'CM' && bannerAreaCd == 'TB'){
						$('#topBannerColorValue').val($('#topBannerColorValue').val().trim());
					}else{
						$('#topBannerColorValue').val('');
					}*/

					if(Dmall.validate.isValid('form_id_detail')) {
						if(bannerNo == ""){
							Dmall.LayerUtil.confirm('등록 하시겠습니까?', InsertBanner);
						}else{
							Dmall.LayerUtil.confirm('수정 하시겠습니까?', UpdateBanner);
						}
					}
				});

				// 리스트 화면
				jQuery('#a_id_list').on('click', function(e) {
					location.replace("/admin/design/banner?typeCd=" + "${so.typeCd}");
				});

				// 등록 아이템 삭제
				$('#btn_check_delete').on('click', function(e){
					checkedGoodsDelete();
				});

			});

			// 상품검색
			function fn_goods_srch(obj) {

				Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));

				GoodsSelectPopup._init( fn_callback_pop_apply_goods );

				/*getBrandOptionValue(jQuery('#searchBrand'));*/
				$("#btn_popup_goods_search").trigger("click");

			}

			// 상품 팝업 리턴 콜백함수
			function fn_callback_pop_apply_goods(data) {
				var $sel_apply_goods_list = $("#tbody_goods_data");
				// 선택 중복 체크
				for(var i = 0; i <= $sel_apply_goods_list.children('tr').length; i++){
					if( $sel_apply_goods_list.children('tr').children('td').children('label').children('span').children('input').eq(i).prop('value') == data['goodsNo']){
						Dmall.LayerUtil.alert("이미 선택하셨습니다");
						return false;
					}
				}
				var index = $sel_apply_goods_list.children('tr').length;
				console.log("fn_callback_pop_apply_goods index = ", index);
				if(index === 1){
					$("#goods_search_empty").hide();
					$("#goods_search_exist").show();
				}

				var template  = '<tr id="tr_goods_' + data["goodsNo"] + '" class="searchGoodsResult">'+
						'<td><label for="chk_goods_' + index + '" class="chack"><span class="ico_comm"><input type="checkbox" id="chk_goods_' + index + '" name="goodsNo" value="' + data["goodsNo"] +'" class="blind"></span></label></td>'+
						'<td>' + index + '</td>'+
						'<td><img src=' + data["goodsImg02"] + '></td>'+
						'<td>' + data["goodsNm"] + '</td>'+
						'<td>' + data["goodsNo"] + '</td>'+
						'<td>' + data["brandNm"] + '</td>'+
						'<td>' + data["sellerNm"] + '</td>'+
						'<td>' + data["salePrice"] + '</td>'+
						'<td>' + data["supplyPrice"] + '</td>'+
						'<td>' + data["stockQtt"] + '</td>'+
						'<td>' + data["goodsSaleStatusNm"] + '</td>'+
						'<td>' + data["erpItmCode"] + '</td>'+
						'</tr>';

				$sel_apply_goods_list.append(template);

				// 총 갯수 처리
				var cnt_total = index;
				$("#cnt_total").html(cnt_total);
			}

			// 수정
			function UpdateBanner(){
				var url = '/admin/design/banner-update',
				param = jQuery('#form_id_detail').serialize();

				var typeCd = "${so.typeCd}";

				if(typeCd === "sub" || typeCd === "goodsTop" || typeCd === "goodsBottom") {
					const goodsList = getRegisterGoodsInfo();

					if (goodsList) {
						$("#goodsList").val(goodsList);
						//param+='&goodsNoList=' + goodsList;
					}/* else {
						return;
					}*/
				}
				$('#form_id_detail').ajaxSubmit({
					url : url,
					dataType : 'json',
					success : function(result){
						if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
							Dmall.LayerUtil.alert(result.message);
						} else {
							Dmall.LayerUtil.alert(result.message);
						}
					}
				});
			}
			// 등록
			function InsertBanner(){
				var url = '/admin/design/banner-insert';
				var typeCd = "${so.typeCd}";

				if(typeCd === "sub" || typeCd === "goodsTop" || typeCd === "goodsBottom") {
					const goodsList = getRegisterGoodsInfo();

					if (goodsList) {
						$("#goodsList").val(goodsList);
						//param+='&goodsNoList=' + goodsList;
					}/* else {
						return;
					}*/
				}
				var param = jQuery('#form_id_detail').serialize();
				console.log("param = ", param);
				$('#form_id_detail').ajaxSubmit({
					url : url,
					dataType : 'json',
					success : function(result){
						if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
							Dmall.LayerUtil.alert(result.message);
						} else {
							Dmall.LayerUtil.alert(result.message);
							location.replace("/admin/design/banner?typeCd=" + "${so.typeCd}");
						}
					}
				});
			}

			//선택된 상품 정보 조회
			function getRegisterGoodsInfo(){
				var selected = [];
				$("#tbody_goods_data").find(".searchGoodsResult").each(function() {
					//console.log("goodsNo = ", $(this).children('td').eq(4).text());
					selected.push($(this).children('td').eq(4).text());
				});
				/*if (selected.length < 1) {
					Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
					return false;
				}*/
				return selected;
			}

			// 날짜함수 합치기
			function dateSum(){
				var startDate = $("#date_val_sc01").val().replace(/-/g,'');
				var startSi = $("#dispStartDttmSi").val();
				var startMi = $("#dispStartDttmMi").val();
				$("#dispStartDttm").val(startDate+startSi+startMi+"00");
				var endDate = $("#date_val_sc02").val().replace(/-/g,'');
				var endSi = $("#dispEndDttmSi").val();
				var endMi = $("#dispEndDttmMi").val();
				$("#dispEndDttm").val(endDate+endSi+endMi+"00");
			}

			// 첨부 이미지 정보 바인딩
			function bindAtchFile(typeCd) {

				var fileInfo = "${resultModel.data.imgFileInfo}";
				var orgFileNm = "${resultModel.data.orgFileNm}";

				//$('.preview_filePc').attr('id', fileNo);

				var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=' + fileInfo;
				var template =
						'<img src="' + imgSrc + '" alt="미리보기 이미지"><br>' +
						'<span class="txt">' + orgFileNm + '</span>' +
						'<button class="cancel">삭제</button>';
				$('.preview_filePc').html(template);
				console.log("typeCd = ", typeCd);
				<c:if test="${so.typeCd eq 'main' || so.typeCd eq 'sub'}">
					console.log("typeCd = ", typeCd);
					var fileInfoM = "${resultModel.data.imgFileInfoM}";
					var orgFileNmM = "${resultModel.data.orgFileNmM}";

					//$('.preview_fileMobile').attr('id', mFileNo);

					var imgSrcM = '${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=' + fileInfoM;
					var templateM =
							'<img src="' + imgSrcM + '" alt="미리보기 이미지"><br>' +
							'<span class="txt">' + orgFileNmM + '</span>' +
							'<button class="cancel">삭제</button>';
					$('.preview_fileMobile').html(templateM);
				</c:if>
			}

			function bindBannerGoodsInfo(bannerNo) {
				var url = '/admin/design/banner-goods-list';
				var param = {bannerNo : bannerNo};

				console.log("fn_apply_exhibition_goods param = ", param);
				Dmall.AjaxUtil.getJSON(url, param, function(result) {
					$("#tbody_goods_data").find(".searchGoodsResult").each(function() {
						$(this).remove();
					});

					console.log("result = ", result);
					//console.log("result length = ", result.resultList.length);
					if (result == null || result.filterdRows < 1) {
						return;
					}
					$("#goods_search_empty").hide();
					$("#goods_search_exist").show();
					// 취득결과 셋팅
					jQuery.each(result.resultList, function(idx, obj) {
						setGoodsData(obj);
					});
				});
			}

			function checkedGoodsDelete() {

				$("#tbody_goods_data").children("tr").each(function() {
					if($(this).find('label[for^=chk_goods_]').hasClass('on')) {
						$(this).remove();
					}
				});
				var $sel_expt_goods_list = $("#tbody_goods_data");
				var cnt_total = $sel_expt_goods_list.children('tr').length - 1;

				// rownum 제설정
				for(var i = 0; i <= cnt_total; i++){
					$sel_expt_goods_list.children('tr').eq(i).children('td').eq(1).text(i);
				}

				$("#cnt_total").html(cnt_total);

				if(cnt_total === 0){
					$("#goods_search_empty").show();
					$("#goods_search_exist").hide();
				}
			}

			// 검색결과 바인딩
			function setGoodsData(goodsData, $tr) {
				console.log("goodsData = ", goodsData);
				var $tmpSearchResultTr = $("#tr_goods_data_template").clone().show().removeAttr("id").data('prev_data', goodsData);
				var trId = "tr_goods_" + goodsData.goodsNo;
				$($tmpSearchResultTr).attr("id", trId).addClass("searchGoodsResult");
				$('[data-bind="goodsInfo"]', $tmpSearchResultTr).DataBinder(goodsData);
				if ($tr) {
					$tr.before($tmpSearchResultTr);
				} else {
					$("#tbody_goods_data").append($tmpSearchResultTr);
				}
				var $sel_expt_goods_list = $("#tbody_goods_data");
				var cnt_total = $sel_expt_goods_list.children('tr').length - 1;
				$("#cnt_total").html(cnt_total);
			}

			// 결과 행의 판매가 표시 설정
			function setSalePrice(data, obj, bindName, target, area, row) {
				var salePrice = data["salePrice"];
				obj.html(numberWithCommas(salePrice));
			}

			// 결과 행의 재고 표시 설정
			function setStockQtt(data, obj, bindName, target, area, row) {
				var stockQtt = data["stockQtt"];
				obj.html(numberWithCommas(stockQtt));
			}

			// 상품 판매상태 텍스트 설정
			function setGoodsStatusText(data, obj, bindName, target, area, row) {
				var goodsSaleStatusCd = data["goodsSaleStatusCd"];
				var goodsSaleStatusNm = data["goodsSaleStatusNm"];
				if(goodsSaleStatusCd==1){//판매중
					goodsSaleStatusNm = '<span class="sale_info1">'+goodsSaleStatusNm+'</span>';
				}else if(goodsSaleStatusCd==2){//품절
					goodsSaleStatusNm = '<span class="sale_info2">'+goodsSaleStatusNm+'</span>';
				}else if(goodsSaleStatusCd==3){//판매대기
					goodsSaleStatusNm = '<span class="sale_info3">'+goodsSaleStatusNm+'</span>';
				}else if(goodsSaleStatusCd==4){//판매중지
					goodsSaleStatusNm = '<span class="sale_info4">'+goodsSaleStatusNm+'</span>';
				}
				obj.html(goodsSaleStatusNm);
			}

			// 결과 행의 상품 선택 체크박스 설정
			function setGoodsChkBox(data, obj, bindName, target, area, row) {
				var chkId = "chk_goods_" + data["goodsNo"]
						, $input = obj.find('input')
						, $label = obj.find('label');

				$input.removeAttr("id").attr("id", chkId).data("goodsNo", data["goodsNo"]);
				$input.removeAttr("value").attr("value", data["goodsNo"]).data("goodsNo", data["goodsNo"]);
				$label.removeAttr("id").attr("id", "chk_goods_" + data["goodsNo"]).removeAttr("for").attr("for", chkId);

				// 체크박스 클릭시 이벤트 설정
				jQuery($label).off("click").on('click', function(e) {
					Dmall.EventUtil.stopAnchorAction(e);
					var $this = jQuery(this),
							checked = !($input.prop('checked'));
					$input.prop('checked', checked);
					$this.toggleClass('on');
				});
			}

			function numberWithCommas(x) {
				return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			}

			//선택된 Keyword 정보 조회
			function initGoodsInfo() {
				//hidden 데이터 초기화

				$("#tbody_goods_data").find(".searchGoodsResult").each(function() {
					$(this).remove();
				});

				$("#cnt_total").html(0);
				$("#goods_search_empty").show();
				$("#goods_search_exist").hide();
			}
		</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<!-- content -->

		<div class="sec01_box">
			<%--<div class="tlt_box">
				<div class="btn_box left">
					<a href="#none" class="btn gray" id="a_id_list">배너 관리 리스트</a>
				</div>
				<h2 class="tlth2">배너관리</h2>
				<div class="btn_box right">
					<a href="#none" class="btn blue shot" id="a_id_save">저장하기</a>
				</div>
			</div>--%>
			<div class="tlt_box">
				<div class="tlt_head">
					디자인 설정<span class="step_bar">
					<c:if test="${so.typeCd eq 'main'}">
					</span>  메인 배너 관리 <span class="step_bar">
                    </c:if>
                    <c:if test="${so.typeCd eq 'sub'}">
                    </span>  서브 배너 관리 <span class="step_bar">
                    </c:if>
                    <c:if test="${so.typeCd eq 'top'}">
                    </span>  탑 배너 관리 <span class="step_bar">
                    </c:if>
                    <c:if test="${so.typeCd eq 'goodsTop'}">
                    </span>  상품 상단 배너 이미지 <span class="step_bar">
                    </c:if>
                    <c:if test="${so.typeCd eq 'goodsBottom'}">
                    </span>  상품 하단 배너 이미지 <span class="step_bar">
					</c:if>
				</div>
				<c:if test="${so.typeCd eq 'main'}">
					<h2 class="tlth2">메인 배너 관리</h2>
				</c:if>
				<c:if test="${so.typeCd eq 'sub'}">
					<h2 class="tlth2">서브 배너 관리</h2>
				</c:if>
				<c:if test="${so.typeCd eq 'top'}">
					<h2 class="tlth2">탑 배너 관리</h2>
				</c:if>
				<c:if test="${so.typeCd eq 'goodsTop'}">
					<h2 class="tlth2">상품 상단 배너 이미지</h2>
				</c:if>
				<c:if test="${so.typeCd eq 'goodsBottom'}">
					<h2 class="tlth2">상품 하단 배너 이미지</h2>
				</c:if>
			</div>
			<!-- line_box -->
			<div class="line_box fri pb">
				<!-- tblw -->
				<form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
				<input type="hidden" name="bannerNo" id="bannerNo" value="${resultModel.data.bannerNo}" />
				<input type="hidden" name="pcGbCd" id="pcGbCd" value="${resultModel.data.pcGbCd}" />
				<input type="hidden" name="changeYN" id="changeYN" value="N" />
				<input type="hidden" name="skinNo" id="skinNo" value="2" />
				<input type="hidden" name="bannerMenuCd" id="bannerMenuCd" value="${so.bannerMenuCd}" />
				<input type="hidden" name="bannerAreaCd" id="bannerAreaCd" value="${so.bannerAreaCd}" />
				<input type="hidden" name="goodsList" id="goodsList" value="" />
				<div class="tblw tblmany">
					<table summary="이표는 배너 관리 설정 정보 표 입니다. 구성은 적용스킨, 메뉴 및 위치, 등록일시, 등록자, 수정일시, 수정자 입니다.">
						<caption>배너 관리 설정 정보</caption>
						<colgroup>
							<col width="15%">
							<col width="85%">
						</colgroup>
						<tbody>
							<c:if test="${so.typeCd ne 'top'}">
							<tr>
								<th>상품군</th>
								<td>
									<span class="select">
										<label for="goodsTypeCd"></label>
										<select name="goodsTypeCd" id="goodsTypeCd">
											<c:if test="${so.typeCd eq 'goodsTop' || so.typeCd eq 'goodsBottom'}">
												<c:if test="${editYn eq 'Y'}">
													<tags:option codeStr="01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;05:소모품" value="${resultModel.data.goodsTypeCd}"/>
												</c:if>
												<c:if test="${editYn eq 'N'}">
													<tags:option codeStr="01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;05:소모품" value="${so.goodsTypeCd}"/>
												</c:if>
											</c:if>
											<c:if test="${so.typeCd ne 'goodsTop' && so.typeCd ne 'goodsBottom'}">
												<c:if test="${editYn eq 'Y'}">
													<tags:option codeStr="01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;" value="${resultModel.data.goodsTypeCd}"/>
												</c:if>
												<c:if test="${editYn eq 'N'}">
													<tags:option codeStr="01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;" value="${so.goodsTypeCd}"/>
												</c:if>
											</c:if>
										</select>
									</span>
								</td>
							</tr>
							</c:if>
							<c:if test="${so.typeCd ne 'goodsTop' && so.typeCd ne 'goodsBottom'}">
							<tr>
								<th>배너 노출 기간 <span class="important">*</span></th>
								<td colspan="3">
									<span class="intxt">
										<input type="text" name="dispStartDttmDate" value="${fn:substring(resultModel.data.dispStartDttm, 0, 8)}" id="date_val_sc01" class="bell_date_sc" >
									</span>
									<a href="javascript:void(0)" class="date_sc ico_comm" id="date_val_date01">달력이미지</a>
									<span class="select shot">
										<label for="">시간 선택</label>
										<select name="dispStartDttmSi" id="dispStartDttmSi" >
											<option value="">선택</option>
											<c:forEach var="i" begin="0" end="23">
												<c:set var="selected" value=""/>
												<fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
												<c:if test="${fn:substring(resultModel.data.dispStartDttm, 8, 10) eq timePattern}">
													<c:set var="selected" value="selected"/>
												</c:if>
												<option value="${timePattern}" ${selected}>${timePattern}시</option>
											</c:forEach>
										</select>
									</span>
									<span class="select shot">
										<label for="">시간 선택</label>
										<select name="dispStartDttmMi" id="dispStartDttmMi" >
											<option value="">선택</option>
											<c:forEach var="i" begin="0" end="59">
												<c:set var="selected" value=""/>
												<fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
												<c:if test="${fn:substring(resultModel.data.dispStartDttm, 10, 12) eq timePattern}">
													<c:set var="selected" value="selected"/>
												</c:if>
												<option value="${timePattern}" ${selected}>${timePattern}분</option>
											</c:forEach>
										</select>
									</span>
									<input type="hidden" name="dispStartDttm" id="dispStartDttm" class="blind" value="" />
									~
									<span class="intxt ml10"><input type="text" name="dispEndDttmDate" value="${fn:substring(resultModel.data.dispEndDttm, 0, 8)}" id="date_val_sc02" class="bell_date_sc" ></span>
									<a href="javascript:void(0)" class="date_sc ico_comm" id="date_val_date02">달력이미지</a>
									<span class="select shot">
										<label for="">시간 선택</label>
										<select name="dispEndDttmSi" id="dispEndDttmSi" >
											<option value="">선택</option>
											<c:forEach var="i" begin="0" end="23">
												<c:set var="selected" value=""/>
												<fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
												<c:if test="${fn:substring(resultModel.data.dispEndDttm, 8, 10) eq timePattern}">
													<c:set var="selected" value="selected"/>
												</c:if>
												<option value="${timePattern}" ${selected}>${timePattern}시</option>
											</c:forEach>
										</select>
									</span>
									<span class="select shot">
										<label for="">시간 선택</label>
										<select name="dispEndDttmMi" id="dispEndDttmMi" >
											<option value="">선택</option>
											<c:forEach var="i" begin="0" end="59">
												<c:set var="selected" value=""/>
												<fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
												<c:if test="${fn:substring(resultModel.data.dispEndDttm, 10, 12) eq timePattern}">
													<c:set var="selected" value="selected"/>
												</c:if>
												<option value="${timePattern}" ${selected}>${timePattern}분</option>
											</c:forEach>
										</select>
									</span>
									<input type="hidden" name="dispEndDttm" id="dispEndDttm" class="blind" value="" />
									<c:set var="on" value=" on"/>
									<c:set var="checked" value="  checked=\"checked\""/>
									<label for="applyAlwaysYn" id="lb_applyAlwaysYn" class="chack mr20<c:if test="${resultModel.data.applyAlwaysYn eq 'Y'}" >${on}</c:if>">
										<input type="checkbox" name="applyAlwaysYn" id="applyAlwaysYn" value="Y" <c:if test="${resultModel.data.applyAlwaysYn eq 'Y'}" >${checked}</c:if> class="blind" />
										<span class="ico_comm">&nbsp;</span>
										무제한
									</label>
								</td>
							</tr>
							</c:if>
							<tr>
								<th>배너 제목</th>
								<td>
									<div class="txt_area">
                                            <textarea name="bannerNm" id="bannerNm" data-validation-engine="validate[maxSize[120]]">${resultModel.data.bannerNm}</textarea>
									</div>
								</td>
								<%--<th class="line">위치순번 <span class="important">*</span></th>
								<td><span class="intxt shot3"><input type="text" value="${resultModel.data.sortSeq}" id="sortSeq" name="sortSeq" data-validation-engine="validate[required, custom[onlyNum], maxSize[3]]"></span></td>--%>

							</tr>
							<c:if test="${so.typeCd ne 'top' && so.typeCd ne 'goodsTop' && so.typeCd ne 'goodsBottom'}">
							<tr>
								<th>부제</th>
								<td colspan="3"><span class="intxt wid100p"><input type="text" value="${resultModel.data.bannerDscrt}" id="bannerDscrt" name="bannerDscrt" data-validation-engine="validate[maxSize[120]]"></span></td>
							</tr>
							</c:if>
							<c:if test="${so.typeCd ne 'goodsTop' && so.typeCd ne 'goodsBottom'}">
							<tr>
								<th>URL</th>
								<td colspan="3">
									<span class="intxt long"><input type="text" value="${resultModel.data.linkUrl}" id="linkUrl" name="linkUrl" data-validation-engine="validate[maxSize[100],custom[url]]"></span>
									<%--<span class="select">
										<label for="">현재창</label>
										<select name="dispLinkCd" id="dispLinkCd">
											<option value="">선택하세요</option>
											<code:option codeGrp="DISP_LINK_CD" value="${resultModel.data.dispLinkCd}" />
										</select>
									</span>--%>
								</td>
							</tr>
							</c:if>
							<tr>
								<th>이미지<div>(PC)</div><span class="important">*</span></th>
								<td colspan="3">
									<span class="intxt"><input class="upload-name" type="text" value="" disabled="disabled"></span>
									<label class="filebtn">파일첨부
										<input class="filebox" type="file" name="filePc" accept="image/*">
									</label>
									<div class="desc_txt br2 ">
										· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / gif / bmp ) <br>
										<c:if test="${so.typeCd eq 'main'}">
										<em class="point_c6">· 1440px X 952px 사이즈로 등록하여 주세요.</em>
										</c:if>
										<c:if test="${so.typeCd eq 'sub'}">
										<em class="point_c6">· 400px X 400px 사이즈로 등록하여 주세요.</em>
										</c:if>
										<c:if test="${so.typeCd eq 'top'}">
											<em class="point_c6">· 1920px X 70px 사이즈로 등록하여 주세요.</em>
										</c:if>
										<c:if test="${so.typeCd eq 'goodsTop' || so.typeCd eq 'goodsBottom'}">
											<em class="point_c6">· 가로 850px 사이즈로 등록하여 주세요.</em>
										</c:if>
									</div>

									<div class="upload_file preview_filePc"></div>
								</td>
							</tr>
							<c:if test="${so.typeCd ne 'top' && so.typeCd ne 'goodsTop' && so.typeCd ne 'goodsBottom'}">
							<tr>
								<th>이미지<div>(MOBILE)</div><span class="important">*</span></th>
								<td colspan="3">
									<span class="intxt"><input class="upload-name" type="text" value="" disabled="disabled"></span>
									<label class="filebtn">파일첨부
										<input class="filebox" type="file" name="fileMobile" accept="image/*">
									</label>
									<div class="desc_txt br2 ">
										· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / gif / bmp ) <br>
										<c:if test="${so.typeCd eq 'main'}">
										<em class="point_c6">· 860px X 1100px 사이즈로 등록하여 주세요.</em>
										</c:if>
										<c:if test="${so.typeCd eq 'sub'}">
											<em class="point_c6">· 400px X 400px 사이즈로 등록하여 주세요.</em>
										</c:if>
									</div>

									<div class="upload_file preview_fileMobile"></div>
								</td>
							</tr>
							</c:if>
							<c:if test="${so.typeCd eq 'sub' || so.typeCd eq 'goodsTop' || so.typeCd eq 'goodsBottom'}">
							<tr>
								<th>상품 설정</th>
								<td id="goods_search_empty">
									<span class="btn_box">
										<button type="button" id="apply_goods_srch_btn" class="btn--black_small goods" >상품 검색</button>
									</span>
								</td>
								<td id="goods_search_exist" style="display: none;">
									<div class="top_lay">
										<div class="select_btn_left">
											<a href="#none" class="btn_gray2 mr5" id="a_id_alllselect">전체 선택</a>
											<a href="#none" class="btn_gray2" id="btn_check_delete">삭제</a>
										</div>
										<div class="select_btn_right">
											<span class="search_txt">
												총 <strong class="be" id="cnt_total">2</strong>개의 상품이 검색되었습니다.
											</span>
											<span class="btn_box">
												<button type="button" class="btn--black_small goods" onClick="javascript:fn_goods_srch(this)">상품 검색</button>
											</span>
										</div>
									</div>
									<div class="tblh">
										<table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
											<caption>판매상품관리 리스트</caption>
											<colgroup>
												<col width="66px">
												<col width="66px">
												<col width="100px">
												<col width="25%">
												<col width="20%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
												<col width="10%">
												<col width="12%">
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
											<tbody id="tbody_goods_data">
												<tr id="tr_goods_data_template" style="display: none;">
													<td data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsChkBox">
														<label for="check_goods_template" class="chack"><span class="ico_comm"><input type="checkbox" id="check_goods_template" class="blind">&nbsp;</span></label>
													</td>
													<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="rownum" >1</td>
													<td><img src="" data-bind="goodsInfo" data-bind-type="img" data-bind-value="goodsImg02"></td>

													<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNm">상품명</td>
													<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNo">상품코드</td>
													<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="brandNm" >브렌드명</td>
													<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sellerNm" >판매자명</td>
													<td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSalePrice"  data-bind-value="salePrice" maxlength="10"></td>
													<td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setStockQtt" data-bind-value="stockQtt" maxlength="4">재고</td>
													<td data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusText">
														<input type="hidden" data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusInput">
													</td>
													<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
												</tr>
											</tbody>
										</table>
									</div>
								</td>
							</tr>
							</c:if>
							<c:if test="${so.typeCd ne 'goodsTop' && so.typeCd ne 'goodsBottom'}">
							<tr>
								<th>사용여부 <span class="important">*</span></th>
								<td colspan="3">
									<tags:radio name="dispYn"  idPrefix="srch_id_dispYn" codeStr="Y:사용;N:미사용" value="${resultModel.data.dispYn}" validate="validate[required]" />
								</td>
							</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				</form>
				<!-- //tblw -->
			</div>
			<!-- //line_box -->
			<!-- bottom_box -->
			<div class="bottom_box">
				<div class="left">
					<!-- <button class="btn--big btn--big-white" id="btn_sel_delete">선택 삭제</button> -->
					<button class="btn--big btn--big-white" id="a_id_list">목록</button>
				</div>
				<div class="right">
					<!-- <button class="btn--blue-round" id="btn_regist">등록</button> -->
					<button class="btn--blue-round" id="a_id_save">저장</button>
					<!-- <button class="btn--blue-round" id="btn_change">수정</button> -->
				</div>
			</div>
			<!-- //bottom_box -->
		</div>
	<!-- //content -->
	<jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
	</t:putAttribute>
</t:insertDefinition>
