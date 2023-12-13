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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">게시글 수정</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/front/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>



	<t:putAttribute name="script">
        <script src="/front/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
	    <script type="text/javascript">
	    var totalFileLength=0;

	    $(document).ready(function(){

	        //에디터
            Dmall.validate.set('form_id_insert');
            Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
            Dmall.DaumEditor.create('free_insert_area'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

	        //수정
	        $('.btn_free_insert').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                //필수값 확인
                if($('#titleNo') !== 'undefined') {
                    if($('#titleNo').val() == '0') {
                        Dmall.LayerUtil.alert('말머리를 선택해 주십시요.');
                        return false;
                    }
                }

                if($('#free_board_title').val() == '') {
                    Dmall.LayerUtil.alert('제목을 입력해 주십시요.');
                    return false;
                }

                var content = Dmall.DaumEditor.getContent('free_insert_area').stripTags(); //태그제거
                content = content.replace(/&nbsp;/gi,'').trim(); //&nbsp; 및 공백 제거
                if(content == '') {
                    Dmall.LayerUtil.alert('내용을 입력해 주십시요.');
                    return false;
                }

                if($('#sectYn').val() == 'Y') {
                    if($('#pw').val() == 'undefined' || $('#pw').val() == '') {
                        Dmall.LayerUtil.alert('비밀번호를 입력해 주십시요.','','');
                        $('#pw').focus();
                        return;
                    }
                }

                Dmall.LayerUtil.confirm("수정 하시겠습니까?",
                    function() {

                        if(Dmall.validate.isValid('form_id_update')) {

                            Dmall.DaumEditor.setValueToTextarea('free_insert_area');  // 에디터에서 폼으로 데이터 세팅

                            var url = '/front/community/letter-update';
                            var param = $('#form_id_update').serialize();

                            if (Dmall.FileUpload.checkFileSize('form_id_update')) {
                                $('#form_id_update').ajaxSubmit({
                                    url : url,
                                    dataType : 'json',
                                    success : function(result){
                                        Dmall.validate.viewExceptionMessage(result, 'form_id_update');
                                        if(result.success){
                                            var param = {bbsId : "${so.bbsId}",lettNo : "${so.lettNo}",pw : $('#pw').val()};
                                            Dmall.LayerUtil.alert(result.message).done(function(){
                                                Dmall.FormUtil.submit('/front/community/letter-detail', param);
                                            });
                                        } else {
                                            Dmall.LayerUtil.alert(result.message);
                                        }
                                    }
                               });
                            }
                        }
                    }
                );
            });

            //파일 변경
            var num = 1;
            jQuery(document).on('change',"input[type=file]", function(e) {
                var bbsId = "${so.bbsId}";
                var fileSize=0;

                var ext = jQuery(this).val().split('.').pop().toLowerCase();
                if(bbsId=="data"){
                    if($.inArray(ext, ['pptx','ppt','xls','xlsx','doc','docx','hwp','pdf','gif','png','jpg']) == -1) {
                        Dmall.LayerUtil.alert('pptx,ppt,xls,xlsx,doc,docx,hwp,pdf,gif,png,jpg 파일만 업로드 할수 있습니다.','','');
                        $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                        $("#input_id_files"+num).val("");
                        return;
                    }
                } else {
                    if($.inArray(ext, ['gif','png','jpg']) == -1) {
                        Dmall.LayerUtil.alert('gif,png,jpg 파일만 업로드 할수 있습니다.','','');
                        $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                        $("#input_id_files"+num).val("");
                        return;
                    }
                }

                var files = e.originalEvent.target.files;
                var totalFileSize=0;
                for (var i = 0; i < files.length; i++){
                    fileSize = files[i].size;
                    totalFileLength = totalFileLength+1;
                }

                if(fileSize>5242880){
                    Dmall.LayerUtil.alert('첨부파일는 최대 5Mbyte까지 등록 가능합니다.');
                    totalFileLength = totalFileLength-1;
                    $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                    $("#files"+num).val("");
                    return;
                }

                var fileLength = $( ".file_add" ).length; //기존파일 갯수
                if((fileLength+files.length)>5){
                    Dmall.LayerUtil.alert('첨부파일는 최대 5개까지 등록 가능합니다.');
                    totalFileLength = totalFileLength-1;
                    $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                    $("#files"+num).val("");
                    return;
                }

                document.getElementById("fileSpan"+num).style.display = "none";
                for (var i = 0; i < files.length; i++){
                    var text = "<p class='file_add'  name='_fileNm"+num+"' id='_fileNm"+num+"'><span id='tes"+num+"'>"+files[i].name+
                    "</span><button type='button' onclick= 'return delNewFileNm("+num+","+fileSize+
                            ")'><img src='../img/product/btn_reply_del.gif' alt='파일삭제' style='vertical-align:middle'></button></p>";
                    $( "#viewFileInsert" ).append( text );
                }
                num = num+1;
                $( "#fileSetList" ).append(
                        "<span id=\"fileSpan"+num+"\"   style=\"visibility: visible\">"+
                        "<button type=\"button\" class=\"btn_fileup\" value=\"Search files\">file</button>"+
                        "<input type=\"file\" name=\"files"+num+"\" id=\"input_id_files"+num+"\" style=\"width:100%\">"+
                        " </span>"
                );
            });

            //이미지 변경
            jQuery('#input_id_image').on('change', function(e) {
                if($("#imgOldYn").val()=="Y"){
                   $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                   $("#imageFile").val("");
                   Dmall.LayerUtil.alert("등록된 이미지 파일을 먼저 삭제하여 주세요.");
                }else{
                    var files = e.originalEvent.target.files;
                    var totalFileSize=0;
                    for (var i = 0; i < files.length; i++){
                        totalFileSize = totalFileSize + files[i].size;
                    }
                    if(totalFileSize>1048576){
                        Dmall.LayerUtil.alert('이미지 파일은 최대 1Mbyte까지 등록 가능합니다.');
                        $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                        $("#imageFile").val("");
                        return;
                    }

                    var ext = jQuery(this).val().split('.').pop().toLowerCase();
                    if($.inArray(ext, ['gif','png','jpg']) == -1) {
                        Dmall.LayerUtil.alert('gif,png,jpg 파일만 업로드 할수 있습니다.');
                        $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                        $("#imageFile").val("");
                        return;
                    }

                    $('#previewImg').remove();
                    document.getElementById('filename').value=this.value;
                    $("#imgYn").val("Y");
                    loadImage(this);
                }
            });

	        //취소
	        $('.btn_free_insert_cancel').on('click', function() {
	            var param = {bbsId : "${so.bbsId}",lettNo : "${so.lettNo}", pw:"${resultModel.data.pw}"};
	            Dmall.FormUtil.submit('/front/community/letter-detail', param);
            });

	        //목록
	        $('.btn_free_list').on('click', function() {
	            var param = {bbsId : "${so.bbsId}"};
	            Dmall.FormUtil.submit('/front/community/board-list', param);
            });

	        //비밀글 설정 초기화
	        var sectYn = '${resultModel.data.sectYn}';
            if(sectYn == 'Y') {
                $('input:radio[name="freeboard_password_check"]:input[value="'+sectYn+'"]').prop("checked",true);
                $('#freeboard_password_check').prop('checked',true);
                setSectYn();
                //$('#pw').val('${resultModel.data.pw}');
            } else {
                setSectYn();
            }

	        //말머리 초기화
	        if($('#titleNo option').size() > 0) {
	            $('#titleNo').val('${resultModel.data.titleNo}').attr('selected','selected');
	            $('#titleNo').trigger('change');
	        }

	    });

	    //비밀글 설정 체크박스
        function setSectYn() {
            if($('input:radio[name="freeboard_password_check"]:input[value="Y"]').is(':checked')) {
                $('#sectYn').val('Y');
                $('#pw').val('');
                $('#tr_pw').show();
            } else {
                $('#sectYn').val('N');
                $('#pw').val('');
                $('#tr_pw').hide();
            }
        }

	    //신규 추가 파일 삭제
        function delNewFileNm(fileNo, fileSize){
            totalFileLength = totalFileLength-1;
            $("#_fileNm"+fileNo).remove();
            $("#input_id_files"+fileNo).remove();
            return false;
        }

        //게시판 기존 파일 삭제
        function delOldFileNm(fileNo){
            var url = '/front/community/attach-file-delete';
            var param = {fileNo:fileNo,bbsId:"${so.bbsId}"};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                $("#files_"+fileNo).remove();
            });

            return false;
        }

        //게시판 이미지파일 삭제
        function delOldImgFileNm(fileNo){
            var url = '/front/community/attach-file-delete';
            var param = {fileNo:fileNo,bbsId:"${so.bbsId}"};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                $("#imgFile_"+fileNo).remove();
                $("#imgOldYn").val("");
            });
            return false;
        }

        //이미지 미리보기
        function loadImage(img) {
            var isIE = (navigator.appName == 'Microsoft Internet Explorer');
            var path = img.value;
            var imgDiv = '';

            if(isIE) {
                imgDiv = '<div class="bbs_g_thum" id="previewImg"><img src="'+path+'" width="65px" height="65px"></div>';
                $(img).parents('td').append(imgDiv);
            } else {
                if(img.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        imgDiv = '<div class="bbs_g_thum" id="previewImg"><img src="'+e.target.result+'" width="65px" height="65px"></div>';
                        $(img).parents('td').append(imgDiv);
                    };
                    reader.readAsDataURL(img.files[0]);
                }
            }
        }
	    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
        <div class="contents">
            <!--- category header 카테고리 location과 동일 --->
            <div id="category_header">
                <div id="category_location">
                    <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>커뮤니티
                </div>
            </div>
            <!---// category header --->
            <h2 class="sub_title">커뮤니티<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
            <div class="community">
                <!--- 커뮤니티 왼쪽 메뉴 --->
                <%@ include file="include/community_left_menu.jsp" %>
                <!---// 커뮤니티 왼쪽 메뉴 --->
                <!--- 커뮤니티 오른쪽 컨텐츠 --->
                <form:form id="form_id_update" commandName="so">
                    <form:hidden path="bbsId" id="bbsId" />
                    <form:hidden path="lettNo" id="lettNo" />
                    <c:if test="${resultModel.data.grpNo ne resultModel.data.lettNo}">
                    <input type="hidden" name="grpNo" id="grpNo" value="${resultModel.data.grpNo}">
                    </c:if>
                    <input type="hidden" name="lvl" id="lvl" value="${resultModel.data.lvl}">
                    <input type="hidden" name="lettLvl" id="lettLvl" value="${resultModel.data.lettLvl}">
                    <input type="hidden" name="sectYn" id="sectYn" value="">
                    <div class="community_content">
                        <c:if test="${bbsInfo.data.topHtmlYn eq 'Y'}">
                        <div class="bbs_banner_top">${bbsInfo.data.topHtmlSet}</div><!-- 배너영역 -->
                        </c:if>
                        <h3 class="community_con_tit">
                            ${bbsInfo.data.bbsNm}
                            <c:choose>
                                <c:when test="${fn:contains(bbsInfo.data.bbsId,'freeBbs')}" >
                                    <span>자유롭게 게시글 작성 및 활용할 수 있는 게시판입니다.</span>
                                </c:when>
                                <c:when test="${fn:contains(bbsInfo.data.bbsId,'gallery')}" >
                                    <span>이미지를 활용하여 게시글을 작성할 수 있는 게시판입니다.</span>
                                </c:when>
                                <c:when test="${fn:contains(bbsInfo.data.bbsId,'data')}" >
                                    <span>많은 자료 및 이미지를 등록할 수 있는 게시판입니다.</span>
                                </c:when>
                            </c:choose>
                        </h3>

                        <table class="tFree_Insert" style="margin-top:30px">
                            <caption>
                                <h1 class="blind">갤러리형게시판 입력 폼 테이블 입니다.</h1>
                            </caption>
                            <colgroup>
                                <col style="width:130px">
                                <col style="width:">
                            </colgroup>
                            <tbody>
                            <c:if test="${bbsInfo.data.bbsKindCd eq 1}">
                                <c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                                <tr>
                                    <th>말머리</th>
                                    <td colspan="3" class="bbs_select_td">
                                        <div class="select_box28" style="width:100px;">
                                            <label for="select_option">==선택==</label>
                                            <select class="select_option" name="titleNo" id="titleNo" title="select option">
                                                <option value="0">==선택==</option>
                                                <c:forEach var="titleList" items="${bbsInfo.data.titleNmArr}" varStatus="status">
                                                <option value="${titleList.titleNo}">${titleList.titleNm}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                </c:if>
                            </c:if>
                                <tr>
                                    <th>제목</th>
                                    <td>
                                        <input type="text" name="title" id="free_board_title" style="width:446px" value="${resultModel.data.title}">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="insert" colspan="2">
                                        <div id="edit">
                                            <textarea name="content" id="free_insert_area" class="blind">${resultModel.data.content}</textarea>
                                        </div>
                                    </td>
                                </tr>
                            <c:if test="${resultModel.data.grpNo eq resultModel.data.lettNo}">
                                <c:if test="${bbsInfo.data.bbsKindCd eq 2 || bbsInfo.data.bbsKindCd eq 3}">
                                <tr id ="fileUploadSet1">
                                    <th>리스트 이미지</th>
                                    <td>
                                        <input type="text" id="filename" class="floatL" readonly="readonly" style="width:280px;">
                                        <div class="file_up">
                                            <button type="button" class="btn_fileup" value="Search files">image</button>
                                            <input type="file" name="imageFile" id="input_id_image" style="width:100%" accept="image/*">
                                        </div>
                                        <input type="hidden" id="imgYn" name= "imgYn" >
                                        <c:forEach var="fileList" items="${resultModel.data.atchFileArr}" varStatus="status">
                                            <c:if test="${fileList.imgYn eq 'Y'}">
                                            <input type="hidden" id="imgOldYn" name= "imgOldYn" value="Y">
                                            <div class="bbs_g_thum"><img src="/image/image-view?type=BBS&path=${fileList.filePath}&id1=${fileList.fileNm}" alt="리스트이미지" width="65px" height="65px"><button class="reply_del" onclick="delOldImgFileNm('${fileList.fileNo}')" ><img src='../img/product/btn_reply_del.gif' alt=파일삭제'></button></div>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                </tr>
                                </c:if>
                                <tr id ="fileUploadSet2">
                                    <th>첨부 파일</th>
                                    <td>
                                        <input type="text" id="filename02" class="floatL" readonly="readonly" style="width:280px;">
                                        <div class="file_up">
                                            <span id = "fileSetList">
                                            <span id="fileSpan1" style="visibility: visible">
                                            <button type="button" class="btn_fileup" value="Search files">file</button>
                                            <input type="file" name="files1" id="input_id_files1" style="width:100%" >
                                            </span>
                                            </span>
                                        </div>
                                        <div id = "viewFileInsert">
                                            <c:forEach var="fileList" items="${resultModel.data.atchFileArr}" varStatus="status">
                                            <c:if test="${fileList.imgYn ne 'Y'}">
                                                <p class="file_add" id="files_${fileList.fileNo}"><span id="">${fileList.orgFileNm}</span><button type="button" onclick="delOldFileNm('${fileList.fileNo}')" ><img src='../img/product/btn_reply_del.gif' alt='파일삭제' style='vertical-align:middle'></button></p>
                                            </c:if>
                                            </c:forEach>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                                <c:if test="${bbsInfo.data.sectLettSetYn eq 'Y'}">
                                <tr>
                                    <th>비밀글설정</th>
                                    <td>
                                        <div class="free_pw_check">
                                            <label>
                                                <input type="radio" id="freeboard_password_check1" name="freeboard_password_check"  value="N" checked onclick="setSectYn();">
                                                <span></span>
                                                    일반글
                                            </label>
                                            <label>
                                                <input type="radio" id="freeboard_password_check2" name="freeboard_password_check" value="Y" onclick="setSectYn();">
                                                <span></span>
                                                    비밀글
                                            </label>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="tr_pw">
                                    <th>비밀번호</th>
                                    <td>
                                        <input type="password" name="pw" id="pw" style="width:280px" maxlength="4">
                                    </td>
                                </tr>
                                </c:if>
                            </tbody>
                        </table>

                        <div class="btn_free_insert_area floatC">
                            <div class="floatL">
                                <button type="button" class="btn_free_list">목록</button>
                            </div>
                            <div class="floatR">
                                <button type="button" class="btn_free_insert">등록</button>
                                <button type="button" class="btn_free_insert_cancel">취소</button>
                            </div>
                        </div>
                        <c:if test="${bbsInfo.data.bottomHtmlYn eq 'Y'}">
                        <div class="bbs_banner_bottom">${bbsInfo.data.bottomHtmlSet}</div><!-- 배너영역 -->
                        </c:if>
                    </div>
                </form:form>
                <!---// 커뮤니티 오른쪽 컨텐츠 --->
            </div>
        </div>
        <!---// contents--->
    </t:putAttribute>
</t:insertDefinition>