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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
        var totalFileLength=0;
        var titleSelectBoxValidation="N";
           jQuery(document).ready(function() {
                Dmall.validate.set('formBbsLettListInsert');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                var noticeLettSetYn = "${so.noticeLettSetYn}";
                var bbsKindCd = "${so.bbsKindCd}";
                
                // 게시글 리스트 화면
                jQuery('#viewBbsLettList').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", noticeLettSetYn : "${so.noticeLettSetYn}",
                            bbsKindCd : "${so.bbsKindCd}", titleUseYn:"${so.titleUseYn}"};
                    Dmall.FormUtil.submit('/admin/operation/letter', param);
                });

                var num = 1;
                jQuery(document).on('change',"input[type=file]", function(e) {
                    var bbsId = "${so.bbsId}";
                    if(jQuery(this).attr('id') == "input_id_image"){
                        return;
                    }
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
                    
                    totalFileLength = totalFileLength+1;
                    var fileNm = e.target.value.substring(e.target.value.lastIndexOf('\\') + 1);
                    
                    if(totalFileLength>5){
                        Dmall.LayerUtil.alert('첨부파일는 최대 5개까지 등록 가능합니다.');
                        totalFileLength = totalFileLength-1;
                        $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                        $("#files"+num).val("");
                        return;
                    }
                    
                    document.getElementById("fileSpan"+num).style.display = "none";
                    var text = '<li class="txt_del" id="'+num+'">'+fileNm+
                    '    <button class="btn_del btn_comm" onclick= "return delNewFileNm('+num+')" ></button></li>';
                    $( "#viewFileInsert" ).append( text );
                    
                    num = num+1;
                    $( "#fileSetList" ).append( 
                            "<span id=\"fileSpan"+num+"\"   style=\"visibility: visible\">"+
                            "<label class=\"filebtn\" for=\"input_id_files"+num+"\">파일선택</label>"+
                            "<input class=\"filebox\" name=\"files"+num+"\" type=\"file\" id=\"input_id_files"+num+"\" >"+
                            " </span>"
                    );
                });
                
                jQuery('#input_id_image').on('change', function(e) {
                    var ext = jQuery(this).val().split('.').pop().toLowerCase();
                    if($.inArray(ext, ['gif','png','jpg']) == -1) {
                        Dmall.LayerUtil.alert('gif,png,jpg 파일만 업로드 할수 있습니다.');
                        $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                        $("#imageFile").val("");
                        $("#fileBoxNm").val("파일선택");
                        return;
                    }

                    $("#imgYn").val("Y");
                });
                
                // 저장
                jQuery('#bbsLettListInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    if(titleSelectBoxValidation=="Y"){
                        if(jQuery('select[name="titleNo"]').val()=="0"){
                            Dmall.LayerUtil.alert("말머리를 선택하여주세요.");
                            return;
                        }
                    }
                    if(Dmall.validate.isValid('formBbsLettListInsert')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/board/board-letter-insert',
                            param = jQuery('#formBbsLettListInsert').serialize();

                        if (Dmall.FileUpload.checkFileSize('formBbsLettListInsert')) {
                           $('#formBbsLettListInsert').ajaxSubmit({
                                url : url,
                                dataType : 'json',
                                success : function(result){
                                    Dmall.validate.viewExceptionMessage(result, 'formBbsLettListInsert');
                                    if(result.success){
                                        var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", noticeLettSetYn : "${so.noticeLettSetYn}",
                                                bbsKindCd : "${so.bbsKindCd}", titleUseYn:"${so.titleUseYn}"};
                                        
                                        Dmall.LayerUtil.alert(result.message).done(function(){
                                            Dmall.FormUtil.submit('/admin/board/letter', param);
                                        })
                                    }else{
                                        Dmall.LayerUtil.alert(result.message);
                                    }
                                }
                           });
                        } 
                    }
                });
                
                var param = {memberNo:"${memberNo}", siteNo:"${siteNo}"};
                var url = '/admin/goods/member-info';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var data = result.data.memberNm+'(<span class="point_c3">'+result.data.loginId+"/"+result.data.memberGradeNm+'</span>)';
                    jQuery("#memeberInfo").html(data);
                });
                
                var param = {bbsId:"${so.bbsId}"};
                var titleUseYn="${so.titleUseYn}";
                var url = '/admin/operation/board-title-list';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var select = '<label for="select1"></label><select name="titleNo" id="titleNo" >';
                    select += '<option value="0">==선택==</option>';
                    
                    if(titleUseYn!="Y"){
                        jQuery("#titleSelectBox").hide();
                        return;
                    }else{
                        titleSelectBoxValidation = "Y";
                    }    
                    
                    jQuery.each(result.resultList, function(i, obj) {
                        select += '<option value="' + obj.titleNo + '"';
                        select += '>' + obj.titleNm + '</option>';
                    });
                    
                    select += '</select>';
                    jQuery("#titleInfoSelectBox").html(select);
                    jQuery('select[name="titleNo"]').trigger("change");
                });

                if(noticeLettSetYn!="Y"){
                    jQuery("#noticeSet").hide();
                }

                if(bbsKindCd=="1"){
                    jQuery("#fileUploadSet1").hide();
                }
            });
            function delNewFileNm(fileNo){
                totalFileLength = totalFileLength-1;
                $("#"+fileNo).remove();
                $("#input_id_files"+fileNo).remove();
                return false;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="btn_box left">
                    <a href="#none" id="viewBbsLettList" class="btn gray">게시글 리스트</a>
                </div>
                <h2 class="tlth2">[${so.bbsNm}] 게시글 등록 </h2>
                <!-- <div class="btn_box right">
                    <a href="#none" id ="bbsLettListInsert"  class="btn blue shot">저장하기</a>
                </div> -->
            </div>
            <form action="" id="formBbsLettListInsert" method="post">
            <!-- line_box -->
            <div class="line_box fri">
                <!-- tblw -->
                <div class="tblw mt0">
                    <table summary="이표는 게시글 등록 표 입니다. 구성은 작성자, 말머리, 제목, 내용 입니다.">
                        <caption>게시글 등록</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>작성자</th>
                                <td id ="memeberInfo">
                                    
                                </td>
                            </tr>
                            <tr id = "titleSelectBox">
                                <th>말머리</th>
                                <td>
                                    <span class="select" id = "titleInfoSelectBox">

                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td>
                                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" />
                                    <span class="intxt long">
                                        <input type="text" id="title" name ="title" placeholder="제목을 입력해주세요." data-validation-engine="validate[required], maxSize[200]]" maxlength="200">
                                    </span>
                                    <span id="noticeSet">
                                        <tags:checkbox name="noticeYn" id="srch_id_noticeYn" value="Y" compareValue="" text="공지글등록" />
                                    </span>
                                </td>
                            </tr>
                            <tr>
                            	<th>URL</th>
                            	<td>
	                            	<span class="intxt long">
	                                    <input type="text" id="linkUrl" name ="linkUrl" data-validation-engine="validate[maxSize[200]]" maxlength="200">
	                                </span>
								</td>
                            </tr>
                            <tr>
                            	<th>연관검색어</th>
                            	<td>
	                            	<%--<span class="intxt long">
	                                    <input type="text" id="relSearchWord" name ="relSearchWord" data-validation-engine="validate[maxSize[200]]" maxlength="200">
	                                </span>--%>
	                                <div class="txt_area">
											<textarea name="relSearchWord" id="relSearchWord" data-validation-engine="validate[maxSize[200]]"></textarea>
                                    </div>
								</td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>
                                    <div class="edit">
                                          <textarea id="ta_id_content1" name="content" class="blind"></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr id ="fileUploadSet1">
                                <th>리스트 이미지</th>
                                <td>
                                    <span class="intxt"><input class="upload-name" id="fileBoxNm" type="text" value="파일 찾기" disabled="disabled"></span>
                                    <label class="filebtn" id = "filebtn" for="input_id_image">이미지찾기</label>
                                    <input class="filebox" name="imageFile" type="file" id="input_id_image" accept="image/*">
                                    <input type="hidden" id="imgYn" name= "imgYn" >
                                    <span class="select_desc tbl_desc">
                                           * 이미지 파일은 최대 2Mbyte입니다.
                                    </span>
                                </td>
                            </tr>
                            <tr id ="fileUploadSet2">
                                <th>첨부 파일</th>
                                <td >
                                    <span class="intxt"><input class="upload-name" id="fileBoxsNm" type="text" value="파일 찾기" disabled="disabled"></span>
                                    <span id = "fileSetList">
                                        <span id="fileSpan1" style="visibility: visible">
                                            <label class="filebtn" for="input_id_files1">파일선택</label>
                                            <input class="filebox" name="files1" type="file" id="input_id_files1" name= "input_id_files" >
                                        </span>
                                    </span>
                                    <span class="select_desc tbl_desc">
                                           * 첨부 파일은 최대 2Mbyte, 최대 5개 입니다.
                                    </span>
                                    <span class="br2"></span>
                                    <div class="disposal_log">
                                        <ul id = "viewFileInsert">
                                        
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
            </form>

			<div class="btn_box txtc">
				<a href="#none" id ="bbsLettListInsert"  class="btn blue shot">저장하기</a>
			</div>
       </div>  
    </t:putAttribute>
</t:insertDefinition>