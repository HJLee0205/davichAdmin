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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; HTML 편집</t:putAttribute>
    <t:putAttribute name="script">
    <script src="/admin/js/dtree.js"></script>
    <script src="/admin/js/pager.js"></script>
    <link rel="stylesheet" href="/admin/css/dtree.css">

  <style>
    #paging {
        list-style-type:none;
        /* text-align:center; */
        overflow:hidden;
        position:relative;
        width:70%;
        min-height:24px;
        margin-top:20px;
        float:right;
    }
    
    #paging li {    
        margin:10px;
        cursor:pointer;
        float:left;
        color: #666;
        font-size: 1.1em;
    }
    #paging li.selected {   
        color: #0080ff;
        font-weight:bold;
    }
    #paging li:hover {      
        color: #0080ff;
    }

  </style>
        <script>

            jQuery(document).ready(function() {
                var index;
                //var text = "";
                d = new dTree('d');
                d.add(0,-1,'Image Tree');
                <c:forEach var="folderInfo" items="${folderList}" varStatus="status">
                        d.add("${folderInfo.idxData}","${folderInfo.beforeIdx}","${folderInfo.fileNm}","viewDtl('${folderInfo.filePath}','')");
                </c:forEach>

                $("#treeInfo").html(''+d);
                
                jQuery('#btn_id_search').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var filePath = $("#filePath").val();
                    var searchNm = $("#searchNm").val();
                    if(filePath == ""){
                        Dmall.LayerUtil.alert("선택한 폴더가 없습니다. \n확인 후 검색하세요.");
                        return;
                    }
                    viewDtl(filePath,searchNm);
                    
                });

                // 선택 삭제
                jQuery('#btn_id_del').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    selected = fn_selectedList();
                    var filePath = $("#filePath").val();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 이미지를 삭제 하시겠습니까? <br/> 삭제된 이미지는 복구 안됩니다.', function() {
                            var url = '/admin/design/image-delete',
                                    param = {},
                                    key,
                                    selected = fn_selectedList();

                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].fileNm';
                                    param[key] = o;
                                    key = 'list[' + i + '].filePath';
                                    param[key] = '';
                                });            

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    var filePath = $("#filePath").val();
                                    var searchNm = $("#searchNm").val();
                                    viewDtl(filePath,searchNm);
                                });
                        });
                    }
                });
                
                // 이미지파일 업로드 - 레이어 열기
                jQuery('#btn_id_imgUpload').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    
                    var filePath = $("#filePath").val();
                    if(filePath == ""){
                        Dmall.LayerUtil.alert("선택한 폴더가 없습니다. <br/>확인 후 이미지파일 업로드하세요.");
                        return;
                    }
                    $("#ex_file1").val("");
                    $("#file_route1").val("");
                    $("#orgFileNm").val("");
                    
                    Dmall.LayerPopupUtil.open(jQuery('#layout1s'));
                });

                // 이미지파일 업로드 - 레이어 닫기
                jQuery('#btn_close_imgUpload2').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('layout1s');
                });

                // 이미지파일 업로드 - 레이어 닫기
                jQuery('#btn_close_imgUpload').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('layout1s');
                });
                
                // 폴더 정보 - 레이어 닫기
                jQuery('#closeLayerPopup').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('saveLayerPopup');
                });
                
                // 이미지 파일 업로드 - 이미지 등록
                jQuery('#btn_save_imgUpload').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var url = '/admin/design/image-upload',
                    param = jQuery('#form_id_detail').serialize();
                    
                    var ex_file1 = $("#ex_file1").val();
                    if(ex_file1 == ""){
                        Dmall.LayerPopupUtil.close('layout1s');
                        Dmall.LayerUtil.alert("이미지파일을 선택하세요.");
                        return;
                    }

                    $('#form_id_detail').ajaxSubmit({
                        url : url,
                        dataType : 'json',
                        success : function(result){
                            if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                                Dmall.LayerUtil.alert(result.message);
                            } else {
                                Dmall.LayerPopupUtil.close('layout1s');
                                Dmall.LayerUtil.alert(result.message);
                                //location.replace("/admin/design/banner");
                                var filePath = $("#filePath").val();
                                var searchNm = $("#searchNm").val();
                                viewDtl(filePath,searchNm);
                            }
                        }
                    });
                    
                });
                
                // 저장 레이어 창 띄우기
                jQuery('#saveLayer').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.open(jQuery('#saveLayerPopup'));
                });
                
                // 폴더 저장 처리
                jQuery('#btn_id_save_folder').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if(Dmall.validate.isValid('form_id_file')) {
                        var folderNm, folderNm1, folderNm2, folderNm1Chk, folderNm2Chk;
                        folderNm = "/";
                        folderNm1 = $("#folderOne option:selected").text();
                        folderNm2 = $("#folderTwo option:selected").text();
                        folderNm1Chk = $("#folderOne option:selected").val();
                        folderNm2Chk = $("#folderTwo option:selected").val();
                        // 1차 2차 폴더 정의
                        if(folderNm1Chk !=""){
                            folderNm = folderNm + folderNm1;
                        }
                        if(folderNm2Chk !=""){
                            folderNm = folderNm + "/" + folderNm2;
                        }
    
                        $("#filePath2").val(folderNm);
                       
                        if($("#newFolderNm").val() == ""){
                            Dmall.LayerPopupUtil.close('saveLayerPopup');
                            Dmall.LayerUtil.alert("저장할 폴더명을 입력하세요.");
                            return;
                        }
                        Dmall.LayerUtil.confirm('신규 폴더를 생성 하시겠습니까?', InsertFolder,'','이미지 관리 폴더 추가','저장');
                    }
                });
                
                // 폴더 삭제 처리
                jQuery('#btn_id_delete_folder').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    
                    var filePath = $("#filePath").val();
                    if(filePath == ""){
                        Dmall.LayerUtil.alert("선택한 폴더가 없습니다. <br/>확인 후 폴더를 삭제하세요.");
                        return;
                    }
                   
                    Dmall.LayerUtil.confirm('['+filePath+'] 폴더를 삭제 하시겠습니까?', DeleteFolder,'','이미지 관리 폴더 삭제','삭제');
                    
                });

                // 체크
                Dmall.validate.set('form_id_file');
            });
            
            //pager객체 생성
            var page = new pager();
            var setFileInfoArr;
            var setFileCnt;
            page.buttonClickCallback = listContent;
            
            function pageInit(startnum, lastnum){
                var fileList = "";
                page.renderpager(setFileCnt);
                
                jQuery.each(setFileInfoArr, function(idx, obj) {
                    if(idx > startnum -2 && idx < lastnum){
                    fileList += "<tr data-file-info = '"+obj.filePath+"/"+obj.fileNm+"' >";
                    fileList += "<td>";
                    fileList += "    <label for='chkFileInfo_"+obj.filePath+"/"+obj.fileNm+"' class='chack'>";
                    fileList += "    <span class='ico_comm'><input type='checkbox' name='chkFileInfo' id='chkBannerNo_"+obj.filePath+"/"+obj.fileNm+"'  value='"+obj.filePath+"/"+obj.fileNm+"' /></span></label>";
                    fileList += "</td>";
                    fileList += "<td class='txt_an_l'>"+obj.fileNm+"</td>";
                    fileList += "<td>"+obj.fileSize+"</td>";
                    fileList += "<td>"+obj.fileDate+"</td>";
                    fileList += "<td>";
                    fileList += "    <button class='btn_gray' onclick=\"fn_imageChange('"+obj.fileNm+"');return false;\">변경</button>";
                    fileList += "    <button class='btn_gray' onclick=\"fn_urlCopy('"+obj.fileNm+"');return false;\">경로복사</button>";
                    fileList += "    <button class='btn_gray' onclick=\"fn_oneDelete('"+obj.fileNm+"');return false;\">삭제</button>";
                    fileList += "</td>";
                    fileList += "</tr>";
                    }
                });
                // 값 셋팅
                $("#tbody_id_imageList").html(fileList);
                
                //Ajax 작업 (E)
            }
            // 페이지용
            function listContent () {
                this.opts.currentPage =1;
            }
            
            // 화면생성에 필요한 기본 정보 취득
            function viewDtl(filePath,searchNm) {
                var url = '/admin/design/image-file-info',
                    param = {filePath : filePath, searchNm : searchNm};
                $("#filePath").val(filePath);
                $("#fileUrlInfo").html(filePath.substring(1,filePath.length));
                $("#fileUrlInfo2").html(filePath);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    
                    // 값 셋팅
                    var fileList = "";
                    if (result.data == null || result.data.fileInfoArr == null ){
                        return;
                    }
                    
                    page.renderpager(result.data.fileCnt);
                    setFileInfoArr = result.data.fileInfoArr;
                    setFileCnt = result.data.fileCnt;
                    
                    jQuery.each(result.data.fileInfoArr, function(idx, obj) {
                        if(idx < 10){
                        fileList += "<tr data-file-info = '"+obj.filePath+"/"+obj.fileNm+"' >";
                        fileList += "<td>";
                        fileList += "    <label for='chkFileInfo_"+obj.filePath+"/"+obj.fileNm+"' class='chack'>";
                        fileList += "    <span class='ico_comm'><input type='checkbox' name='chkFileInfo' id='chkBannerNo_"+obj.filePath+"/"+obj.fileNm+"'  value='"+obj.filePath+"/"+obj.fileNm+"' /></span></label>";
                        fileList += "</td>";
                        fileList += "<td class='txt_an_l'>"+obj.fileNm+"</td>";
                        fileList += "<td>"+obj.fileSize+"</td>";
                        fileList += "<td>"+obj.fileDate+"</td>";
                        fileList += "<td>";
                        fileList += "    <button class='btn_gray' onclick=\"fn_imageChange('"+obj.fileNm+"');return false;\">변경</button>";
                        fileList += "    <button class='btn_gray' onclick=\"fn_urlCopy('"+obj.fileNm+"');return false;\">경로복사</button>";
                        fileList += "    <button class='btn_gray' onclick=\"fn_oneDelete('"+obj.fileNm+"');return false;\">삭제</button>";
                        fileList += "</td>";
                        fileList += "</tr>";
                        }
                    });
                    // 값 셋팅
                    $("#tbody_id_imageList").html(fileList);
                });
            }

            // 선택된값 체크
            function fn_selectedList() {
                var selected = [];
                
                $("input[name='chkFileInfo']:checked").each(function() {
                    selected.push($(this).val());     // 체크된 것만 값을 뽑아서 배열에 push
                });

                if (selected.length < 1) {
                    Dmall.LayerUtil.alert('선택된 항목이 없습니다.');
                }
                return selected;
            }

            // 선택된값 체크
            function fn_imageChange(orgFileNm) {
                var filePath = $("#filePath").val();
                if(filePath == ""){
                    Dmall.LayerUtil.alert("선택한 폴더가 없습니다. <br/>확인 후 이미지파일 업로드하세요.");
                    return;
                }
                $("#ex_file1").val("");
                $("#file_route1").val("");
                $("#orgFileNm").val(orgFileNm);
                
                Dmall.LayerPopupUtil.open(jQuery('#layout1s'));
            }
            
            // 주소 복사
            function fn_urlCopy(orgFileNm) {
                // 임시 주석 사용할지 확인이 필요
                var filePath = $("#filePath").val();
                var source = filePath + "/" + orgFileNm;

                if(window.clipboardData){           // ie
                    window.clipboardData.setData('Text',source);
                    Dmall.LayerUtil.alert(source+"<br/>copied!!!");
                }else{                              // etc
                    var $tmpDiv=$('<div style="position:absolute;top:-1000px;left:-1000px;">'+source.replace(/</g,"&lt;").replace(/>/g,"&gt;")+'</div>').appendTo("body")
                    ,range=document.createRange()
                    ,selection=null;

                    range.selectNodeContents($tmpDiv.get(0));
                    selection=window.getSelection();
                    selection.removeAllRanges();
                    selection.addRange(range);
                    if(document.execCommand("copy", false, null)){
                        Dmall.LayerUtil.alert(source+"<br/>copied!!!");
                    }else window.prompt("Copy to clipboard: Ctrl+C, Enter", source);
                    $tmpDiv.remove();
                }
            }
            
            // 한건 삭제 confirm 처리
            function fn_oneDelete(orgFileNm) {
                $("#orgFileNm").val(orgFileNm);
                Dmall.LayerUtil.confirm('[ '+ orgFileNm +' ]<br/>파일을 삭제 하시겠습니까?', fn_oneDeleteConfirm,'','이미지관리 파일 삭제','삭제');
                
            }
            // 한건 파일 삭제 실제처리
            function fn_oneDeleteConfirm() {
                var filePath = $("#filePath").val();
                var searchNm = $("#searchNm").val();
                var orgFileNm = $("#orgFileNm").val();
                var url = '/admin/design/one-image-delete',
                    param = {filePath : filePath, fileNm : orgFileNm};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    //Dmall.LayerUtil.alert("[ "+searchNm+" ] 파일을 삭제 하였습니다.");
                    viewDtl(filePath,searchNm);
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
            
            // 신규 폴더 생성
            function InsertFolder() {
                var filePath = $("#filePath").val();
                var searchNm = $("#searchNm").val();
                
                var inFilePath = $("#filePath2").val();
                var inFileNm =$("#newFolderNm").val();
                
                var url = '/admin/design/image-folder-create',
                    param = {filePath : inFilePath, fileNm : inFileNm};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    location.replace("/admin/design/image-manage");
                });
            }
            
            // 생성된 폴더 삭제
            function DeleteFolder() {
                var filePath = $("#filePath").val();
                
                var url = '/admin/design/image-folder-delete',
                    param = {filePath : filePath, fileNm : filePath};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    location.replace("/admin/design/image-manage");
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
        <!-- content -->
        <div id="content">
            <div class="sec01_box">
                <div class="tlt_box">
                    <h2 class="tlth2">이미지 관리</h2>
                </div>      
                <!-- line_box -->
                <input type="hidden" name="filePath" id="filePath" class="blind" value="" /> 
                <input type="hidden" name="orgFileNm" id="orgFileNm" class="blind" value="" /> 
                <div class="line_box fri">
                    <!-- cate_con -->
                    <div class="cate_con">
                        <!-- cate_left -->
                        <div class="cate_left">
                            <a href="#none" class="btn_gray2" id="saveLayer">+ 폴더 추가</a>
                            <a href="#none" class="btn_gray" id="btn_id_delete_folder">삭제</a>
                            <span class="br2"></span>
                            <div class="left_con">
                                <div id="treeInfo">
                                    <!-- 트리정보 들어가는 곳 -->
                                </div>
                            </div>
                        </div>
                        <!-- //cate_left -->
                        <!-- cate_right -->
                        <div class="cate_right">
                            <div class="top_lay mb0">
                                <h3 class="tlth3" id="fileUrlInfo">폴더명</h3>
                                <div class="select_btn">
                                    <span class="intxt">
                                        <input type="text" id="searchNm" name="searchNm">
                                    </span>
                                    <button class="btn_gray"id="btn_id_search">검색</button>
                                </div>
                            </div>
                            <!-- tblw -->
                            <div class="tblh">
                                <table summary="이표는 이미지 관리 표 입니다. 구성은 파일명 용량 등록일 관리(변경,경로복사,삭제) 입니다.">
                                    <caption>이미지 관리</caption>
                                    <colgroup>
                                        <col width="10%">
                                        <col width="40%">
                                        <col width="15%">
                                        <col width="15%">
                                        <col width="20%">
                                    </colgroup>
                                    <thead>
                                        <th>
                                            <label for="chack05" class="chack" onclick="chack_btn(this);">
                                                <span class="ico_comm"><input type="checkbox" name="table" id="chack05"  /></span>
                                            </label>
                                        </th>
                                        <th>파일명</th>
                                        <th>용량</th>
                                        <th>등록일</th>
                                        <th>관리</th>
                                    </thead>
                                    <tbody id="tbody_id_imageList">
                                    </tbody>
                                </table>
                            </div>
                            <!-- //tblw -->
                            <!-- bottom_lay -->
                            <div class="bottom_lay">
                                <div class="left">
                                    <div class="pop_btn">
                                        <button class="btn_gray2" id="btn_id_del">선택삭제</button>
                                    </div>
                                </div>
                                <div class="right">
                                    <div class="pop_btn">
                                        <button class="btn_gray2" id="btn_id_imgUpload">이미지파일 업로드</button>
                                    </div>
                                </div>
                                <!-- pageing -->
                                <div class="pageing">
                                    <div id="log"></div>
                                    <!--현재는 페이징 영역 ID "paging" 고정 -->
                                    <ul id="paging">
                                    </ul>
                                </div>

                                <!-- //pageing -->
                            </div>
                            <!-- //bottom_lay -->
                            
                        </div>
                        <!-- //cate_right -->
                    </div>
                    <!-- //cate_con -->
                </div>
                <!-- //line_box -->
            </div>
        </div>
        <!-- //content -->
<!-- layout1s -->
<div id="layout1s" class="slayer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">이미지 등록</h2>
            <button class="close ico_comm" id="btn_close_imgUpload2">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <p class="message txtl">이미지 관리에 사용된 이미지 등록</p>
                <span class="br"></span>
                <p class="message txtl">이미지 업로드 경로 : <span id="fileUrlInfo2"></span></p>
                <span class="br"></span>
                <span class="intxt imgup1"><input id="file_route1" class="upload-name" type="text" value="" disabled="disabled"></span>
                <label class="filebtn" for="ex_file1">파일찾기</label>
                <input class="filebox" type="file" name="ex_file1" id="ex_file1" >
                <span class="br2"></span>
                <div class="btn_box txtc">
                    <button class="btn_green" id="btn_save_imgUpload">등록</button>
                    <button class="btn_red" id="btn_close_imgUpload">취소</button>
                </div>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layout1s -->
        <!-- //content -->
        </form>
        
        <!-- layer_popup1 -->
        <div id="saveLayerPopup" class="layer_popup">
            <div class="pop_wrap size1">
                <form name="form_id_file" id="form_id_file" method="post" accept-charset="utf-8">
                <input type="hidden" name="fileNm" id="fileNm2" class="blind" value="" /> 
                <input type="hidden" name="filePath" id="filePath2" class="blind" value="" /> 
                <input type="hidden" name="baseFilePath" id="baseFilePath2" class="blind" value="${so.baseFilePath}" /> 
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">새로운 폴더 추가</h2>
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
                                        <th>폴더위치</th>
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
                                        <th>폴더명</th>
                                        <td>
                                            <span class="intxt wid480"><input type="text" value="" name="newFolderNm" id="newFolderNm" data-validation-engine="validate[required, custom[onlyEngNumTag], minSize[3], maxSize[20]]"></span>
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
