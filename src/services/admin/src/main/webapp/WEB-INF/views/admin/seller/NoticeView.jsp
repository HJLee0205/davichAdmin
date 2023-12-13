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
            var fileObj;
            jQuery(document).ready(function() {
                Dmall.validate.set('form_id_bbsLett');
                // 게시글 리스트 화면
                jQuery('#viewBbsLettList').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", noticeLettSetYn : "${so.noticeLettSetYn}",
                            bbsKindCd : "${so.bbsKindCd}"}
                    Dmall.FormUtil.submit('/admin/seller/notice-list', param);
                });

                // 게시글 수정 화면 이동
                jQuery('#viewBbsLettUpdate').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var regrNo = jQuery("#regrNo").val();
                    var titleNo = jQuery("#titleNo").val();
                    var param = {lettNo: "${so.lettNo}", bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", regrNo:regrNo, titleNo:titleNo,noticeLettSetYn : "${so.noticeLettSetYn}"}
                    Dmall.FormUtil.submit('/admin/seller/letter-update-form', param);
                });

                // 댓글 등록
                jQuery('#insertBbsComment').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var content = $("#contentText").val();
                    var regrNm = jQuery("#memberNm").val();
                    var param = {lettNo:"${so.lettNo}", bbsId : "${so.bbsId}", content:content, regrNm:regrNm};
                    if(content==""){
                        Dmall.LayerUtil.alert('댓글을 입력 하세요.');
                        return;
                    }
                    if(Dmall.validate.isValid('form_id_bbsLett')) {
                        var url = '/admin/board/board-comment-insert';
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_id_bbsLett');
                            if(result.success){
                                var regrNo = jQuery("#regrNo").val();
                                var titleNo = jQuery("#titleNo").val();
                                var param = {lettNo: "${so.lettNo}", bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", regrNo:regrNo, titleNo:titleNo}
                                Dmall.FormUtil.submit('/admin/seller/seller-bbs-detail', param );
                            }
                        });
                    }
                });

                // 댓글 삭제
                jQuery(document).on('click', '#delBbsCmnt', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    var cmntSeq = jQuery(this).data('cmnt-seq');
                    var param = {lettNo:"${so.lettNo}", bbsId : "${so.bbsId}", cmntSeq:cmntSeq};
                    var url = '/admin/board/board-comment-delete';
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            $("#"+cmntSeq).remove();
                        }
                    });
                });
                // 게시글 정보 가져오기
                var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                
                var url = '/admin/board/board-letter-detail';
                var atchFileArr = "";
                var imgFile = "";
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                	
                    Dmall.FormUtil.jsonToForm(result.data, 'form_id_bbsLett');
                    jQuery("#bind_target_id_memberNm").html(result.data.memberNm+'(<span class="point_c3">'+result.data.loginId+'/'+result.data.memberGradeNm+'</span>)');
                    jQuery("#contentArea").html(result.data.content);
                    fileObj = result.data.atchFileArr;
                    jQuery.each(result.data.atchFileArr, function(i, obj) {
                        if(obj.imgYn=='Y'){
                            imgFile = '<a href="#none" class="tbl_link" onclick= "return fileDownload('+obj.fileNo+
                            ');">'+obj.orgFileNm+'</a>';
                        }else{
                            atchFileArr += '<a href="#none" class="tbl_link" onclick= "return fileDownload('+obj.fileNo+
                            ');">'+obj.orgFileNm+'</a><span class="br2"></span>';
                        }
                    });
                });

                // 게시글 댓글 리스트
                var param = {lettNo:"${so.lettNo}"};
                var url = '/admin/board/board-comment-list';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var text = '';

                    jQuery.each(result.resultList, function(i, obj) {
                        text += '<dl class="txt_con txt_del" id = "'+obj.cmntSeq+'">'+
                                '<dt><strong>'+obj.memberNm+'</strong><span class="point_c3">('+obj.loginId+'/'+obj.memberGradeNm+')</span></dt>'+
                                '<dd>'+obj.content+'<span class="year">'+obj.regDttm+'</span>'+
                                '<button class="btn_del btn_comm" id ="delBbsCmnt" data-cmnt-seq = \"'+obj.cmntSeq+'\" >삭제</button> </dd>'+
                                '</dl>'
                    });
                    text += ""
                    if(!result.resultList){
                        text = '<dl class="txt_con txt_del">'+
                        '<dd class="txtc">등록된 댓글이 없습니다. </dd>'+
                        '</dl>';
                     }
                    jQuery("#bbsCmntList").html(text);
                });

                var param = {memberNo:"${memberNo}", siteNo:"${siteNo}"};
                var titleUseYn="${so.titleUseYn}";
                var url = '/admin/goods/member-info';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(titleUseYn!="Y"){jQuery("#titleSelectBox").hide();}
                    var data = '<strong>'+result.data.memberNm+'</strong><span class="point_c3">('+result.data.loginId+"/"+result.data.memberGradeNm+')</span>';
                    jQuery("#memeberInfo").html(data);
                });
            });
            function fileDownload(fileNo){
                Dmall.FileDownload.download("BBS", fileNo)
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
                <h2 class="tlth2">[${so.bbsNm}] 게시글 보기 </h2>
                <div class="btn_box right">
                    <a href="#none" id="viewBbsLettUpdate" class="btn blue shot">수정하기</a>
                </div>
            </div>

            <form action="" id="form_id_bbsLett">
            <div class="line_box fri">
                <!-- tblw -->
                <div class="tblw mt0">
                    <table summary="이표는 게시글 보기 표 입니다. 구성은 작성자, 작성일, 말머리, 공지글 설정, 제목, 내용 입니다.">
                        <caption>게시글 보기</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="35%">
                            <col width="15%">
                            <col width="35%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>작성자</th>
                                <td id="bind_target_id_memberNm" class="bind_target"></td>
                                <th class="line">작성일</th>
                                <td id="bind_target_id_regDttm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>판매자</th>
                                <td id="bind_target_id_sellerNm" class="bind_target"></td>
                            </tr>
                            <tr id = "titleSelectBox">
                                <th>말머리</th>
                                <td id="bind_target_id_titleNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td colspan="3" id="bind_target_id_title" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td colspan="3" id="contentArea" class="bind_target"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <!-- admin_comment -->
                <div class="admin_comment">
                    <div class="from">
                        <div class="tlt">
                            <span id ="memeberInfo"></span>
                            <span class="byte">(0/300 byte)</span>
                        </div>
                        <div class="area">
                            <div class="txt_area">
                                <input type="hidden" id="lettNo" name = "lettNo" >
                                <input type="hidden" name="memberNm" id="memberNm">
                                <input type="hidden" name="titleNo" id="titleNo">
                                <input type="hidden" name="regrNo" id="regrNo">
                                <textarea name="contentText" id="contentText" data-validation-engine="validate[maxSize[500]]" maxlength="500" ></textarea>
                            </div>
                            <button class="btn_regist" id = "insertBbsComment"><span>등록</span></button>
                        </div>
                    </div>
                    <div id = "bbsCmntList">

                    </div>
                </div>
                <!-- //admin_comment -->
            </div>
            <!-- //line_box -->
            </form>
        </div>
    </t:putAttribute>
</t:insertDefinition>
