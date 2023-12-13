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

<%@ page import="java.util.List" %>
<%@ page import="net.danvi.dmall.biz.system.util.ServiceUtil" %>
<%@ page import="net.danvi.dmall.biz.system.model.CmnCdDtlVO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.File" %>
    <script src="/admin/js/dtree.js"></script>
    <link rel="stylesheet" href="/admin/css/dtree.css">
    <!-- 구분 정보 -->
    <!-- 
    <link rel="stylesheet" href="/admin/css/codemirror/docs.css">
     -->
    <link rel="stylesheet" href="/admin/css/codemirror/codemirror.css">
    <link rel="stylesheet" href="/admin/css/codemirror/foldgutter.css" />
    <script src="/admin/js/codemirror/codemirror.js"></script>
    <script src="/admin/js/codemirror/foldcode.js"></script>
    <script src="/admin/js/codemirror/foldgutter.js"></script>
    <script src="/admin/js/codemirror/brace-fold.js"></script>
    <script src="/admin/js/codemirror/xml-fold.js"></script>
    <script src="/admin/js/codemirror/markdown-fold.js"></script>
    <script src="/admin/js/codemirror/comment-fold.js"></script>
    <script src="/admin/js/codemirror/javascript.js"></script>
    <script src="/admin/js/codemirror/xml.js"></script>
    <script src="/admin/js/codemirror/markdown.js"></script>
    <style type="text/css">
      .CodeMirror {border-top: 1px solid black; border-bottom: 1px solid black;}
    </style>

<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; HTML 편집</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {
                var dataChk = "${dataChk}";
                
                if(dataChk == "Y"){
                    Dmall.LayerUtil.alert("스킨관리의 작업중인 스킨을 선택하지 않았습니다.<br/>스킨관리에서 작업스킨을 선택하세요.");
                    //location.replace("/admin/design/pc-skin");
                }
                var index;
                //var text = "";
                d = new dTree('d');
                d.add(0,-1,'Data Tree');
                <c:forEach var="folderInfo" items="${folderList}" varStatus="status">
                        d.add("${folderInfo.idxData}","${folderInfo.beforeIdx}","${folderInfo.fileNm}","viewDtl('${folderInfo.baseFilePath}','${folderInfo.filePath}')");
                </c:forEach>
                /*
                for (index = 0; index < codeCd.length; index++) {
                     //text += codeCd[index];
                     d.add(index+1,0,codeNm[index],"viewDtl('"+codeCd[index]+"')");
                 }
                */

                $("#treeInfo").html(''+d);
                
                // 등록 화면
                jQuery('#btn_id_save').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    if($("#filePath").val() == ""){
                        Dmall.LayerUtil.alert("저장할 Html 정보가 존재하지 않습니다. 확인 후 저장하세요.");
                        return;
                    }
                    Dmall.LayerUtil.confirm('수정 하시겠습니까?', UpdateEdit,'','Html 편집','수정');
                    
                    //Dmall.FormUtil.submit('/admin/design/pop-detail', {popupNo : ''});
                });
                // 새창 띄우기 원본소스 보기
                jQuery('#btn_id_new').on('click', function(e) {
                    if($("#filePath").val() == "" || $("#fileNm").val() == ""){
                        Dmall.LayerUtil.alert("선택한 Html 정보가 존재하지 않습니다. html 선택후 그에 맞는 원본 소스를 볼수 있습니다.");
                        return;
                    }
                    var url = "/admin/design/file-detailnew?baseFilePath="+$("#baseFilePath").val()+"&filePath="+$("#filePath").val()+"&fileNm="+$("#fileNm").val();
                    window.open(url, "orgFile","width=750,height=680,scrollbars=no");  

                });
                // 화면보기 프론트 창 띄우기
                jQuery('#frontView').on('click', function(e) {
                    //Dmall.LayerUtil.alert("front 화면 어디로 띄울지는 확인후 작업");
                    e.preventDefault();
                    e.stopPropagation();
                    if($("#filePath").val() == "" || $("#fileNm").val() == ""){
                        Dmall.LayerUtil.alert("선택한 Html 정보가 존재하지 않습니다.<br/>html 선택후 화면보기를 할수 있습니다.");
                        return;
                    }
                    
                    var fileNm = $("#fileNm").val();
                    var filePath = $("#filePath").val();
                    var baseFilePath = $("#baseFilePath").val();
                    var skinId = "${skinId}";
                    var pcGbCd = "${pcGbCd}";
                    var url = '/admin/design/skin-preview',
                        param = {fileNm : fileNm, filePath : filePath, baseFilePath : baseFilePath, pcGbCd : pcGbCd};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result.data == null) {
                            Dmall.LayerUtil.alert("해당정보 URL이 존재하지 않습니다.");
                            return;
                        }
                        Dmall.LayerUtil.alert("["+ result.data.tmplNm +"] 관련 전체화면 호출입니다.");
                        // 호출 화면처리 
                        var url =  result.data.linkUrl + "?_SKIN_ID=" + skinId;
                        window.open(url);
                    });
                    
                });
                // 저장 레이어 창 띄우기
                jQuery('#saveLayer').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.open(jQuery('#saveLayerPopup'));
                });
                
                
                // 주소 복사
                jQuery('#ctrlC').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    

                    if($("#filePath").val() == "" || $("#fileNm").val() == ""){
                        Dmall.LayerUtil.alert("선택한 Html 정보가 존재하지 않습니다. html 선택후 그에 맞는 주소복사를 할수 있습니다.");
                        return;
                    }
                    
                    var fileNm = $("#fileNm").val();
                    var filePath = $("#filePath").val();
                    var baseFilePath = $("#baseFilePath").val();
                    var skinId = "${skinId}";
                    var pcGbCd = "${pcGbCd}";
                    var url = '/admin/design/skin-preview',
                        param = {fileNm : fileNm, filePath : filePath, baseFilePath : baseFilePath, pcGbCd : pcGbCd};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result.data == null) {
                            Dmall.LayerUtil.alert("해당정보 URL이 존재하지 않습니다.");
                            return;
                        }
                        // Dmall.LayerUtil.alert("["+ result.data.tmplNm +"] 관련 전체화면 호출입니다.");
                        // 호출 화면처리 
                        var source =  result.data.linkUrl + "?_SKIN_ID=" + skinId;
                        if(window.clipboardData){           // ie
                            window.clipboardData.setData('Text',source);
                            if(endFunc) endFunc.call(this, e);
                            else Dmall.LayerUtil.alert("copied!!!");
                        }else{                              // etc
                            var $tmpDiv=$('<div style="position:absolute;top:-1000px;left:-1000px;">'+source.replace(/</g,"&lt;").replace(/>/g,"&gt;")+'</div>').appendTo("body")
                            ,range=document.createRange()
                            ,selection=null;

                            range.selectNodeContents($tmpDiv.get(0));
                            selection=window.getSelection();
                            selection.removeAllRanges();
                            selection.addRange(range);
                            if(document.execCommand("copy", false, null)){
                                if(endFunc) endFunc.call(this, e);
                                else Dmall.LayerUtil.alert("copied!!!");
                            }else window.prompt("Copy to clipboard: Ctrl+C, Enter", source);
                            $tmpDiv.remove();
                        }
                        
                    });
                    
                    /* 기존 경로만 복사보다 주소 url 방식으로 변경하려고 주석처리함
                    var source =  $("#filePath").val()+"/"+$("#fileNm").val();

                    if(window.clipboardData){           // ie
                        window.clipboardData.setData('Text',source);
                        if(endFunc) endFunc.call(this, e);
                        else Dmall.LayerUtil.alert("copied!!!");
                    }else{                              // etc
                        var $tmpDiv=$('<div style="position:absolute;top:-1000px;left:-1000px;">'+source.replace(/</g,"&lt;").replace(/>/g,"&gt;")+'</div>').appendTo("body")
                        ,range=document.createRange()
                        ,selection=null;

                        range.selectNodeContents($tmpDiv.get(0));
                        selection=window.getSelection();
                        selection.removeAllRanges();
                        selection.addRange(range);
                        if(document.execCommand("copy", false, null)){
                            if(endFunc) endFunc.call(this, e);
                            else Dmall.LayerUtil.alert("copied!!!");
                        }else window.prompt("Copy to clipboard: Ctrl+C, Enter", source);
                        $tmpDiv.remove();
                    }
                    */
                });
                
                jQuery('#btn_id_save_folder').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    if(Dmall.validate.isValid('form_id_file')) {
                        var folderNm, folderNm1, folderNm2;
                        folderNm1 = $("#folderOne option:selected").text();
                        folderNm2 = $("#folderTwo option:selected").text();
                        folderNm2Chk = $("#folderTwo option:selected").val();
                        folderNm = "/"+folderNm1;
                        if(folderNm2Chk !=""){
                            folderNm = folderNm+"/"+folderNm2;
                        }
    
                        $("#filePath2").val(folderNm);
                        $("#fileNm2").val($("#fileLeftNm").val()+"."+$("#fileRightNm option:selected").val());
                        //alert($("#filePath2").val());
                        //alert($("#fileNm2").val());
                        if($("#folderOne").val() == "" || $("#fileLeftNm").val() == ""){
                            Dmall.LayerUtil.alert("저장할 Html 정보가 존재하지 않습니다. \n 1차폴더명과 파일명을 확인 후 저장하세요.");
                            return;
                        }
                        Dmall.LayerUtil.confirm('저장 하시겠습니까?', InsertEdit,'','Html 편집','저장');
                    }
                    //Dmall.FormUtil.submit('/admin/design/pop-detail', {popupNo : ''});
                });
                
                // 폴더 정보 - 레이어 닫기
                jQuery('#closeLayerPopup').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('saveLayerPopup');
                });

                // 체크
                Dmall.validate.set('form_id_file');
            });

            var te_html = document.getElementById("txt_content");
            //te_html.value = document.documentElement.innerHTML;
            te_html.value = "";

            var editor_html = CodeMirror.fromTextArea(te_html, {
              mode: "text/html",
              lineNumbers: true,
              lineWrapping: true,
              extraKeys: {"Ctrl-Q": function(cm){ cm.foldCode(cm.getCursor()); }},
              foldGutter: true,
              gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
            });
            //editor_html.foldCode(CodeMirror.Pos(0, 0));
            //editor_html.foldCode(CodeMirror.Pos(21, 0));


            // 화면생성에 필요한 기본 정보 취득
            function viewDtl(baseFilePath, filePath) {
                var url = '/admin/design/file-info',
                    param = {baseFilePath : baseFilePath, filePath : filePath};
                $("#filePath").val(filePath);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    
                    // 값 셋팅
                    var fileList = "";
                    if (result.data == null || result.data.fileInfoArr == null ){
                        return;
                    }
                    jQuery.each(result.data.fileInfoArr, function(idx, obj) {
                        fileList += "<p><a href='#' onclick=\"viewDtlHtml('"+obj.fileNm+"','"+obj.filePath+"','"+obj.baseFilePath+"')\">"+ obj.fileNm +"</a></p>";
                    });
                    // 값 셋팅
                    editor_html.setValue("");
                    //$("#txt_content").html("");
                    $("#urlInfo").html("");
                    $("#fileInfo").html(fileList);
                    $("#fileNm").val("");
                    $("#filePath").val("");
                    //$("#skinNo").val("");
                    //$("#tmplNo").val("");
                });
            }
            
            // 화면생성에 필요한 기본 정보 취득
            function viewDtlHtml(fileNm,filePath,baseFilePath) {
                var url = '/admin/design/file-detailinfo',
                    param = {fileNm : fileNm, filePath : filePath, baseFilePath : baseFilePath};

                $("#fileNm").val(fileNm);
                $("#filePath").val(filePath);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    
                    // 값 셋팅
                    editor_html.setValue(result.data.content);
                    //editor.setValue(content)
                    //$("#txt_content").html(result.data.content);
                    $("#urlInfo").html(fileNm);
                });
            }
            
            // 수정
            function UpdateEdit(){
                var url = '/admin/design/html-update';
                
                $("#txt_content").val(editor_html.getValue());
                
                param = jQuery('#form_id_detail').serialize();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail');
                });
            }
            
            // 저장
            function InsertEdit(){
                var url = '/admin/design/html-insert';
                
                param = jQuery('#form_id_file').serialize();
                //
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_file');
                    if(result.success){
                        location.replace("/admin/design/html-edit-pc");
                    } 
                });
            }
            
            // 2차 폴더정보 가져오기
            function folderSel(str){
                //$("#folderTwo").remove();
                $("#folderTwo").find("option").remove();
                $("#folderTwo").append("<option value=\"\">2차폴더</option>");
                if(str !=""){
                    $("#folder > option").each( function() {
                        var checkVal = $(this).val();
                        var checkSplit = checkVal.split("@!@");
                        if(checkVal != "" && checkSplit[0] == str){
                            $("#folderTwo").append("<option value=\""+checkSplit[2]+"\">"+checkSplit[2]+"</option>");
                        }
                    }); 
                }
                jQuery('#folderTwo').trigger('change');
                
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!-- content -->
        <div id="content">
            <div class="sec01_box">
                <div class="tlt_box">
                    <h2 class="tlth2">HTML 편집</h2>
                    <div class="btn_box right">
                        <a href="#none" class="btn blue" id="btn_id_new">원본소스보기</a>
                    </div>
                </div>
                <!-- line_box -->
                <form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
                <input type="hidden" name="skinNo" id="skinNo" class="blind" value="" /> 
                <input type="hidden" name="tmplNo" id="tmplNo" class="blind" value="" /> 
                <input type="hidden" name="fileNm" id="fileNm" class="blind" value="" /> 
                <input type="hidden" name="filePath" id="filePath" class="blind" value="" /> 
                <input type="hidden" name="baseFilePath" id="baseFilePath" class="blind" value="${so.baseFilePath}" /> 
                <div class="line_box fri">
                    <!-- cate_con -->
                    <div class="cate_con">
                        <!-- cate_left -->
                        <div class="cate_left">
                            <div class="left_con">
                                <div id="treeInfo">
                                    <!-- 트리정보 들어가는 곳 -->
                                </div>
                            </div>
                            <div class="left_con">
                                <div id="fileInfo">
                                    <!-- 파일 리스트 들어가는 곳 -->
                                    
                                </div>
                            </div>
                            <a href="#" class="btn_gray2 page_add" id="saveLayer">새로운 페이지추가 + </a>
                        </div>
                        <!-- //cate_left -->
                        
                        <!-- cate_right -->
                        <div class="cate_right">
                            <div class="link_box">
                                <span class="url" id="urlInfo"></span>
                                <div class="btn">
                                    <a href="#none" class="btn_gray" id="frontView">화면보기</a>
                                    <button class="btn_blue" id="ctrlC">주소복사</button>
                                </div>
                            </div>
                            <div class="publishing">
                                <div style="max-width: 110em; margin-bottom: 1em;">HTML:<br>
                                    <textarea id="txt_content" name="content"></textarea>
                                </div>
                            </div>
                        </div>
                        <!-- //cate_right -->
                    </div>
                    <!-- //cate_con -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="btn_id_save">저장</button>
                    </div>
                </div>
                </form>
                <!-- //line_box -->
            </div>
        </div>
        <!-- //content -->
        <!-- layer_popup1 -->
        <div id="saveLayerPopup" class="layer_popup">
            <div class="pop_wrap size1">
                <form name="form_id_file" id="form_id_file" method="post" accept-charset="utf-8">
                <input type="hidden" name="fileNm" id="fileNm2" class="blind" value="" /> 
                <input type="hidden" name="filePath" id="filePath2" class="blind" value="" /> 
                <input type="hidden" name="baseFilePath" id="baseFilePath2" class="blind" value="${so.baseFilePath}" /> 
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">새로운 페이지 추가</h2>
                    <button class="close ico_comm" id="closeLayerPopup">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                <div class="pop_con">
                    <div>
                        
                        <!-- tblw -->
                        <div class="tblw tblmany mt0">
                            <table summary="이표는 새로운 페이지를 추가하는 표 입니다. 구성은 폴더명,파일명, 설명 입니다.">
                                <caption>사업자 정보확인</caption>
                                <colgroup>
                                    <col width="20%">
                                    <col width="80%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>폴더명</th>
                                        <td>
                                            <span class="select">
                                                <label for="">1차 폴더</label>
                                                <select name="folderOne" id="folderOne" onchange="folderSel(this.value)">
                                                    <option value="">1차폴더</option>
                                                    <c:forEach var="folderInfo" items="${folderList}" varStatus="status">
                                                    <c:if test="${folderInfo.beforeIdx eq '0'}">
                                                        <option value="${folderInfo.idxData}">${folderInfo.fileNm}</option>
                                                    </c:if>
                                                    </c:forEach>
                                                </select>
                                            </span>
                                            <div style="display:none">
                                            <select name="folder" id="folder">
                                                <c:forEach var="folderInfo" items="${folderList}" varStatus="status">
                                                <c:if test="${folderInfo.beforeIdx ne '0'}">
                                                    <option value="${folderInfo.beforeIdx}@!@${folderInfo.filePath}@!@${folderInfo.fileNm}@!@${folderInfo.baseFilePath}@!@${folderInfo.idxData}">${folderInfo.fileNm}</option>
                                                </c:if>
                                                </c:forEach>
                                            </select>
                                            </div>
                                            
                                            <span class="select">
                                                <label for="">2차폴더</label>
                                                <select name="folderTwo" id="folderTwo">
                                                    <option value="">2차폴더</option>
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>파일명</th>
                                        <td>
                                            <span class="intxt wid480"><input type="text" value="" name="fileLeftNm" id="fileLeftNm" data-validation-engine="validate[required, custom[onlyEngNumTag], minSize[3], maxSize[25]]"></span>
                                            <span class="select">
                                                <label for="">html</label>
                                                <select name="fileRightNm" id="fileRightNm">
                                                    <option value="jsp">jsp</option>
                                                    <option value="html">html</option>
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblw -->
        
                        <div class="btn_box txtc">
                            <button class="btn green" id="btn_id_save_folder">등록</button>
                        </div>
                    </div>
                </div>
                <!-- //pop_con -->
                </form>
            </div>
        </div>
        <!-- //layer_popup1 -->
    </t:putAttribute>
</t:insertDefinition>
