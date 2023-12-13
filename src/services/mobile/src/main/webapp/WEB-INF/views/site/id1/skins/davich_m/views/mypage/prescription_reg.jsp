<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script>
// $(function () {
$(document).ready(function() {
	
	
	console.log("${exMsg}");
	<c:choose>
		<c:when test="${exMsg != null && exMsg ne '' }">
			Dmall.LayerUtil.alert("${exMsg}");
		</c:when>
		<c:otherwise>
			$("#prescription_popup").show();
		</c:otherwise>
	</c:choose>
	

	/* datepicker */
    Dmall.validate.set("prescriptionForm");
    
	// Date Picker 설정
	$(".datepicker").datepicker({
		dateFormat: "yy-mm-dd"
	});

	// X버튼, 취소 버튼 클릭시 팝업 숨기기
	$(".btn_close_popup, .btn_close_popup02").click(function() {
		$(".popup").hide();
	});
	
	// 확인 버튼 클릭
	$("#btn_reg_prescription").on("click", function() {
		// validation check
		if(!Dmall.validate.isValid("prescriptionForm")) {
			return false;
		}
		if(Dmall.validation.isEmpty($("#prescriptionForm [name=checkupDt]").val())) {
			Dmall.LayerUtil.alert("검사일을 입력하세요.", "알림");
			return false;
		}
		if(Dmall.validation.isEmpty($("#prescriptionForm [name=checkupInstituteNm]").val())) {
			Dmall.LayerUtil.alert("검사기관을 입력하세요.", "알림");
			return false;
		}
		if(totalFileLength < 1) {
			Dmall.LayerUtil.alert("처방전 파일을 등록해 주세요.", "알림");
			return false;
		}
			
        $('#prescriptionForm').ajaxSubmit({
            url : "${_MOBILE_PATH}/front/mypage/prescription_reg",
            dataType : 'json',
            success : function(result){
                Dmall.validate.viewExceptionMessage(result, 'prescriptionForm');
               	Dmall.AjaxUtil.viewMessage(result, function(result) {
        			if(result.success) {
        				document.location.href = "${_MOBILE_PATH}/front/mypage/prescription";
        			}
               	});
            }
        });
	});


    //파일 변경
    jQuery(document).off('change',"input[type=file]");
    var num = 1;
    jQuery(document).on('change',"input[type=file]", function(e) {
        var fileSize=0;
        if(jQuery(this).attr('id') == "input_id_image"){
            return;
        }
        
        var fileSize = $(this)[0].files[0].size;
        var maxSize = <spring:eval expression="@front['system.upload.file.size']"/>;
        
        if(fileSize > maxSize){
        	var maxSize_MB = maxSize / (1024*1024);
        	Dmall.LayerUtil.alert('파일 용량 '+maxSize_MB.toFixed(2)+' Mb 이내로 등록해 주세요.','','');
        	return;
        }
        
        var ext = jQuery(this).val().split('.').pop().toLowerCase();
		if($.inArray(ext, ['gif','png','jpg']) == -1) {
			Dmall.LayerUtil.alert('gif,png,jpg 파일만 업로드 할수 있습니다.','','');
			$("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
			$("#input_id_files"+num).val("");
			return;
		}

        var fileNm = e.target.value.substring(e.target.value.lastIndexOf('\\') + 1);
        totalFileLength = totalFileLength+1;

        if(totalFileLength>1){
            Dmall.LayerUtil.alert('첨부파일는 최대 1개까지 등록 가능합니다.');
            totalFileLength = totalFileLength-1;
            $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
            $("#input_id_files"+num).val("");
            return;
        }

        document.getElementById("fileSpan"+num).style.display = "none";

        var text = "<span class='file_add'  name='_fileNm"+num+"' id='_fileNm"+num+"'>" +
                        "<span id='tes"+num+"'>"+fileNm+"</span>" +
                        "<button type='button' onclick= 'return delNewFileNm("+num+","+fileSize+")' class='btn_del'>" +
                        "</button>" +
                    "</span>";

        $( "#viewFileInsert" ).append( text );
        num = num+1;
        $( "#fileSetList" ).append(
            "<span id=\"fileSpan"+num+"\" style=\"visibility: visible\">"+
            "<label for=\"input_id_files"+num+"\">파일찾기</label>"+
            "<input class=\"upload-hidden\" name=\"files"+num+"\" id=\"input_id_files"+num+"\" type=\"file\">"+
            " </span>"
        );
    });
});

var totalFileLength=0;
//파일 삭제
function delNewFileNm(fileNo, fileSize){
    totalFileLength = totalFileLength-1;
    $("#_fileNm"+fileNo).remove();
    $("#input_id_files"+fileNo).remove();
    return false;
}
</script>
<div class="dimmed2"></div>
<form id="prescriptionForm" method="post">
	
	<div class="inner prescription pop_wrap">
		<div class="popup_header">
			<h1 class="popup_tit">처방전 등록</h1>
			<button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
		</div>


		<!-- <div class="popup_head">
			<h1 class="tit">처방전 등록</h1>
			<button type="button" class="btn_close_popup">창닫기</button>
		</div> -->
		<div class="popup_body"> 
			<spring:eval expression="@front['system.upload.file.size']" var="maxSize" />
			<fmt:parseNumber value="${maxSize / (1024*1024) }" var="maxSize_MB" integerOnly="true" />
			<p class="discount_warning">※  처방전은 이미지 파일로만 등록 가능합니다. (PNG, JPG. GIF. ${maxSize_MB }Mb 이내)</p>
			<div class="popup_tCart_outline">
				<table class="tCart_Insert">
					<caption>처방전 등록 입력폼입니다.</caption>
					<colgroup>
						<col style="width:112px">
						<col style="width:">
					</colgroup>
					<tbody>
						<tr>
							<th>검사일</th>
							<td>
								<input type="text" class="date datepicker" name="checkupDt">
							</td>
						</tr>
						<tr>
							<th>검사기관</th>
							<td>
								<input type="text" name="checkupInstituteNm">
							</td>
						</tr>
						<tr>
							<th class="vaT">파일</th>
							<td class="upload_area">
							
		                        <div class="filebox">
		                            <span id = "fileSetList">
		                                <span id="fileSpan1" style="visibility: visible">
		                                    <label for="input_id_files1">파일찾기</label>
		                                    <input class="upload-hidden" name="files1" id="input_id_files1" type="file">
		                                </span>
		                            </span>
		                            <br />
		                            <span id="viewFileInsert"></span>
		                        </div>
							<%--
								<div class="filebox">
									<label for="ex_filename01">파일찾기</label>
									<input disabled="disabled" class="upload-name" value="">
									<input class="upload-hidden" id="ex_filename01" type="file"> 							
									<button type="button" class="btn_del"></button><!--삭제버튼:불러온 파일명 바로 옆에 붙게 해주세요 -->
								</div>
							--%>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="popup_btn_area">
				<button type="button" class="btn_close_popup02">취소</button>
				<button type="button" class="btn_go_bill" id="btn_reg_prescription">확인</button>
			</div>
		</div>
	</div>

</form>