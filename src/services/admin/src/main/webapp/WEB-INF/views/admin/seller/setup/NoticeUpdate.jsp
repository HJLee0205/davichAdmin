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
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
        var titleSelectBoxValidation="N";
            jQuery(document).ready(function() {
                Dmall.validate.set('formBbsLettListUpdate');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                jQuery('#viewBbsLettList').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", noticeLettSetYn : "${so.noticeLettSetYn}",
                            bbsKindCd : "${so.bbsKindCd}", titleUseYn:"${so.titleUseYn}"};
                    Dmall.FormUtil.submit('/admin/seller/notice-list', param);
                });
                // 저장
                jQuery('#bbsLettListUpdate').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    if(titleSelectBoxValidation=="Y"){
                        if(jQuery('select[name="titleNo"]').val()=="0"){
                            Dmall.LayerUtil.alert("말머리를 선택하여주세요.");
                            return;
                        }
                    }
                    
                    if(Dmall.validate.isValid('formBbsLettListUpdate')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/board/board-letter-update';
                        var param = jQuery('#formBbsLettListUpdate').serialize();
                        
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", noticeLettSetYn : "${so.noticeLettSetYn}",
                                        bbsKindCd : "${so.bbsKindCd}", titleUseYn:"${so.titleUseYn}"};
                                Dmall.FormUtil.submit('/admin/seller/notice-list', param);
                            }
                        });
                    } 
                });
                // 수정 화면
                jQuery("#delTitle").on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    jQuery("#delTitle").val("");
                });
             
                var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'formBbsLettListUpdate');
                    
                    Dmall.DaumEditor.setContent('ta_id_content1', result.data.content); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                });
                
                var param = {memberNo:"${so.regrNo}", siteNo:"${siteNo}"};
                var url = '/admin/goods/member-info';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var data = result.data.memberNm+'(<span class="point_c3">'+result.data.loginId+"/"+result.data.memberGradeNm+'</span>)';
                    jQuery("#memeberInfo").html(data);
                });
                
                var param = {bbsId:"${so.bbsId}"};
                var titleUseYn="${so.titleUseYn}";
                var url = '/admin/board/board-title-list';
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(titleUseYn!="Y"){
                        jQuery("#titleSelectBox").hide();
                        return;
                    }else{
                        titleSelectBoxValidation = "Y";
                    }
                    var select = '<label for="select1"></label><select name="titleNo" >';
                    select += '<option value="0">==선택==</option>';
                    
                    jQuery.each(result.resultList, function(i, obj) {
                        select += '<option value="' + obj.titleNo + '"';
                        if(obj.titleNo==="${so.titleNo}") {
                            select += ' selected="selected"';
                        }
                        select += '>' + obj.titleNm + '</option>';
                    });
                        
                    select += '</select>';
                    jQuery("#titleInfoSelectBox").html(select);
                    jQuery('select[name="titleNo"]').trigger("change");
                });
                
                var noticeLettSetYn = "${so.noticeLettSetYn}";

                if(noticeLettSetYn!="Y"){
                    jQuery("#noticeSet").hide();
                }
                
//                 var selectTarget = $('#sellerNo');
//                 var select_name = selectTarget.children('option:selected').text();
//                 $('label[id="sel_id"]').text(select_name);
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div id="content">
            <div class="sec01_box">
                <div class="tlt_box">
                    <div class="btn_box left">
                        <a href="#none" id="viewBbsLettList" class="btn gray">게시글 리스트</a>
                    </div>
                    <h2 class="tlth2">[${so.bbsNm}] 게시글 수정</h2>
                    <div class="btn_box right">
                        <a href="#none" id ="bbsLettListUpdate" class="btn blue shot">저장하기</a>
                    </div>
                </div>
                <form action="" id="formBbsLettListUpdate">
                <!-- line_box -->
                <div class="line_box fri">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 수정 표 입니다. 구성은 작성자, 말머리, 제목, 내용 입니다.">
                            <caption>게시글 수정</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody id = "tbody_id_bbsLettInfo">
                                <tr>
                                    <th>작성자</th>
                                    <td id ="memeberInfo">

                                    </td>
                                </tr>
	                            <tr>
	                                 <th>판매자</th>
	                                 <td>
	                                      <span id="selectbox" class="select wid240">
	                                          <label for="sellerNo" id="sel_id"></label>
	                                          <select name="sellerNo" id="sellerNo" data-validation-engine="validate[required]">
	                                              <cd:sellerOption siteno="${so.siteNo}" includeSelect="true" />
	                                          </select>
	                                      </span>
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
                                    <td class="in_del">
                                        <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" />
                                        <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}" />
                                        <span class="intxt long">
                                            <input type="text" name="title" id="title" data-validation-engine="validate[required], maxSize[500]]" >
                                        </span>
                                        <span id="noticeSet">
                                            <tags:checkbox name="noticeYn" id="srch_id_noticeYn" value="Y" compareValue="" text="공지글등록" />
                                        </span>
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
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
                </form>
                <!-- //line_box -->
           </div>  
        </div>
    </t:putAttribute>
</t:insertDefinition>
