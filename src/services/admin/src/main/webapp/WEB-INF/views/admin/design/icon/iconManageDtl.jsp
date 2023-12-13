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
	<t:putAttribute name="title">아이콘 관리</t:putAttribute>
	<t:putAttribute name="script">
		<script>

			jQuery(document).ready(function() {
				var editYn = "${editYn}";

				if (editYn === 'Y') {
					bindAtchFile();
				}
				// 이미지 첨부 시 미리보기 이미지 표시
				$('input[type=file]').change(function() {
					console.log("this.files = ", this.files);
					if(this.files && this.files[0]) {
						var imgNm = this.files[0].name;
						var name = $(this).attr('name');
						var reader = new FileReader();
						reader.onload = function(e) {
							var template =
									'<img src="' + e.target.result + '" alt="미리보기 이미지"><br>' +
									'<span class="txt">' + imgNm + '</span>' +
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

				$("#form_id_detail").validationEngine('attach', {promptPosition : "bottomRight", scroll: false, binded: false});
				
				// 등록
				jQuery('#a_id_save').on('click', function(e) {
					e.preventDefault();
					e.stopPropagation();
					var iconNo = "${resultModel.data.iconNo}";
					
					var ex_file1 = $("#ex_file1").val();
					if(iconNo == "" && ex_file1 == ""){
						Dmall.LayerUtil.alert("이미지파일을 첨부하셔야 합니다.");
						return;
					}

					//dateSum();
						
					if(Dmall.validate.isValid('form_id_detail')) {
						var param = jQuery('#form_id_detail').serialize();
						console.log("param = ", param);
						if(iconNo == ""){
							Dmall.LayerUtil.confirm('등록 하시겠습니까?', InsertIcon);
						}else{
							Dmall.LayerUtil.confirm('수정 하시겠습니까?', UpdateIcon);
						}
					}
				});
				
				// 리스트 화면
				jQuery('#a_id_list').on('click', function(e) {
					location.replace("/admin/design/icon");
				});
				
			});

			// 수정
			function UpdateIcon(){
				var url = '/admin/design/icon-update',
				param = jQuery('#form_id_detail').serialize();

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
			function InsertIcon(){
				var url = '/admin/design/icon-insert';

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
							location.replace("/admin/design/icon");
						}
					}
				});
			}

			// 첨부 이미지 정보 바인딩
			function bindAtchFile() {

				var imgInfo = "${resultModel.data.icnImgInfo}";
				var imgNm = "${resultModel.data.imgNm}";
				var orgImgNm = "${resultModel.data.orgImgNm}";

				//$('.preview_filePc').attr('id', fileNo);

				var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=ICON&id1=' + imgInfo;
				var template =
						'<img src="' + imgSrc + '" alt="미리보기 이미지"><br>' +
						'<span class="txt">' + orgImgNm + '</span>' +
						'<button class="cancel">삭제</button>';
				$('.preview_filePc').html(template);

			}


		</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<!-- content -->
		<div class="sec01_box">
			<div class="tlt_box">
				<div class="tlt_head">
					디자인 설정<span class="step_bar"></span>  상품 아이콘 이미지<span class="step_bar"></span>
				</div>
				<h2 class="tlth2">상품 아이콘 이미지</h2>
			</div>
			<!-- line_box -->
			<div class="line_box fri pb">
				<!-- tblw -->
				<form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
				<input type="hidden" name="iconNo" id="iconNo" value="${resultModel.data.iconNo}" />
				<input type="hidden" name="iconTypeCd" id="iconTypeCd" value="1" />
				<div class="tblw tblmany">
					<table summary="이표는 아이콘 관리 설정 정보 표 입니다. 구성은 적용스킨, 메뉴 및 위치, 등록일시, 등록자, 수정일시, 수정자 입니다.">
						<caption>아이콘 관리 설정 정보</caption>
						<colgroup>
							<col width="150px">
							<col width="">
						</colgroup>
						<tbody>
							<tr>
								<th>상품군</th>
								<td>
									<a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>
									<code:checkbox name="goodsTypeCd" codeGrp="GOODS_TYPE_CD" idPrefix="goodsTypeCd" value="${resultModel.data.goodsTypeCd}"/>
								</td>
							</tr>
							<tr>
								<th>아이콘 제목 <span class="important">*</span></th>
								<td><span class="intxt wid100p"><input type="text" value="${resultModel.data.iconDispnm}" id="iconDispnm" name="iconDispnm" data-validation-engine="validate[required, maxSize[120]]"></span></td>
								<%--<th class="line">위치순번 <span class="important">*</span></th>
								<td><span class="intxt shot3"><input type="text" value="${resultModel.data.sortSeq}" id="sortSeq" name="sortSeq" data-validation-engine="validate[required, custom[onlyNum], maxSize[3]]"></span></td>--%>

							</tr>
							<tr>
								<th>이미지<span class="important">*</span></th>
								<td colspan="3">
									<span class="intxt"><input class="upload-name" type="text" value="" disabled="disabled"></span>
									<label class="filebtn">파일첨부
										<input class="filebox" type="file" name="filePc" accept="image/*">
									</label>
									<div class="desc_txt br2 ">
										· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / gif / bmp )<br>
										<em class="point_c6">· 140px X 140px 사이즈로 등록하여 주세요.</em>
									</div>

									<div class="upload_file preview_filePc"></div>
								</td>
							</tr>
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
	</t:putAttribute>
</t:insertDefinition>
