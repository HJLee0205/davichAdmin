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
<%-- <%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %> --%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                //숫자, 하이폰(-) 만 입력가능
                $(document).on("keyup", "input:text[datetimeOnly]", function() {$(this).val( $(this).val().replace(/[^0-9\-]/gi,"") );});
                //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
                //영문만 입력가능
                $(document).on("keyup", "input:text[engOnly]", function() {$(this).val( $(this).val().replace(/[^\!-z]/g,"") );});
                
                bbsSet.getBbsList();
                
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', bbsSet.getBbsList);
              
                // 검색
                jQuery('#btn_id_search').on('click', function(e){
                    jQuery("#hd_page").val("1");
                    bbsSet.getBbsList();
                });
                // 게시글 리스트 화면
                jQuery(document).on('click', '#tbody_id_bbsList a.btn_blue', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bbsId = jQuery(this).parents('tr').data('bbs-id');
                    var bbsNm = jQuery(this).parents('tr').data('bbs-nm');
                    var noticeLettSetYn = jQuery(this).parents('tr').data('bbs-notice-yn');
                    var titleUseYn = jQuery(this).parents('tr').data('title-use-yn');
                    var bbsKindCd = jQuery(this).parents('tr').data('bbs-kind-cd');

                    var param = {bbsId : bbsId, bbsNm : bbsNm, noticeLettSetYn:noticeLettSetYn, bbsKindCd:bbsKindCd,
                            titleUseYn:titleUseYn};
                    Dmall.FormUtil.submit('/admin/operation/letter', param);
                });
                
                // 등록 화면
                jQuery('#viewBbsInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bbsId = jQuery(this).parents('tr').data('bbs-id');
                    
                    if("${isBbsAddible}"){
                        Dmall.FormUtil.submit('/admin/operation/board-insert-form', {bbsId : bbsId, });
                    }else{
                        Dmall.LayerUtil.confirm('게시판 만들기 포인트가 부족합니다. 충전 화면으로 이동 하시겠습니까?', function() {
                            //location.href="/front/interest/interest-item-list";
                        })
                    }
                });
                
                // 수정 화면
                jQuery(document).on('click', '#tbody_id_bbsList a.btn_gray', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bbsId = jQuery(this).parents('tr').data('bbs-id');
                    Dmall.FormUtil.submit('/admin/operation/board-update-form', {bbsId : bbsId});
                });
                
                // 새창 열림 사용자 화면 이동
                jQuery(document).on('click', '#tbody_id_bbsList a.tbl_link', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bbsAddr = jQuery(this).parents('tr').data('bbs-addr');
                    var bbsId = jQuery(this).parents('tr').data('bbs-id');

                    var url = "http://"+window.location.hostname+"/front/"+bbsAddr;
                    window.open(url,"popupFront","fullscreen=yes, toolbar=no, menubar=no, scrollbars=yes, resizable=yes");
                    //window.open("","popupFront","옵션","fullscreen=yes");
                    /*form_id_search.action = url;
                    form_id_search.method = "post";
                    form_id_search.target = "popupFront";*/
                    /*form_id_search.bbsId.value=bbsId;*/
                    /*form_id_search.submit();*/
                });
                
                jQuery("#searchKind" ).change(function() {
                    $('#searchVal').remove();
                    var inputText = '';
                    if($(this).val() == 'searchBbsId'){
                        inputText = 
                        '<input type="text"  name="searchVal" id="searchVal" engOnly="true" style="ime-mode:disabled;" maxlength="50" />';
                    }else{
                        inputText = 
                        '<input type="text"  name="searchVal" id="searchVal"  maxlength="50" />';
                    }
                    $('#searchDiv').append(inputText);
                });
                
                jQuery('#sel_rows').on('change', function(e) {
                    jQuery('#hd_page').val('1');
                    
                    jQuery('#hd_rows').val($(this).val());
                    bbsSet.getBbsList();
                });
            });
            
            var bbsSet = {
                bbsList : [],
                getBbsList : function() {
                    var url = '/admin/operation/board-list',dfd = jQuery.Deferred();
                    var param = jQuery('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template = 
                            '<tr data-bbs-id = "{{bbsId}}" data-bbs-nm="{{bbsNm}}" data-bbs-notice-yn= "{{noticeLettSetYn}}" data-bbs-kind-cd="{{bbsKindCd}}" data-title-use-yn = "{{titleUseYn}}" data-bbs-addr = "{{bbsAddr}}" >'+
                            '<td>{{rownum}}</td><td>{{bbsId}}</td><td><a href="#none" class="tbl_link" target="_blank">{{bbsNm}}</a></td>' +
                            '<td>{{readListUseYn}}</td><td>{{readLettContentUseYn}}</td><td>{{writeLettUseYn}}</td><td>{{writeCommentUseYn}}</td>'+
                            '<td>{{writeReplyUseYn}}</td><td>{{bbsLettCnt}}</td><td>{{bbsKindCdNm}}</td>' +
                            '<td><div class="pop_btn"><a href="#none" class="btn_blue">게시글 보기</a></div></td>'+
                            '<td><div class="pop_btn"><a href="#none" class="btn_gray">수정</a></div></td>',
                            managerGroup = new Dmall.Template(template),
                                tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            if(obj.readListUseYn=="Y"){ obj.readListUseYn="O";}
                            else{obj.readListUseYn='<span class="point_c6">X</span>';}
                            if(obj.readLettContentUseYn=="Y"){ obj.readLettContentUseYn="O";}
                            else{obj.readLettContentUseYn='<span class="point_c6">X</span>';}
                            if(obj.writeLettUseYn=="Y"){ obj.writeLettUseYn="O";}
                            else{obj.writeLettUseYn='<span class="point_c6">X</span>';}
                            if(obj.writeCommentUseYn=="Y"){ obj.writeCommentUseYn="O";}
                            else{obj.writeCommentUseYn='<span class="point_c6">X</span>';}
                            if(obj.writeReplyUseYn=="Y"){ obj.writeReplyUseYn="O";}
                            else{obj.writeReplyUseYn='<span class="point_c6">X</span>';}
                                
                            tr += managerGroup.render(obj)
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="12">데이터가 없습니다.</td></tr>';
                        }
                        jQuery('#tbody_id_bbsList').html(tr);
                        bbsSet.bbsList = result.resultList;
                        dfd.resolve(result.resultList);
                        
                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbs', bbsSet.getBbsList);
                        
                        $("#a").text(result.filterdRows);
                        $("#b").text(result.totalRows);
                    });

                    return dfd.promise();
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">게시판 리스트 </h2>
                <div class="btn_box right">
                     <a href="#none" id="viewBbsInsert" class="btn blue shot">게시판만들기</a>
                </div>
            </div>
            <!-- search_box -->
            <form id="form_id_search" >
            <input type="hidden" name="page" id="hd_page" value="1" />
            <input type="hidden" name="sord" id="hd_srod" value="" />
            <input type="hidden" name="bbsId" id="bbsId" value="" />
                 <div class="search_box">
                     <!-- search_tbl -->
                     <div class="search_tbl">
                         <table summary="이표는 게시판 리스트 검색 표 입니다. 구성은 검색어 입니다.">
                             <caption>게시판 리스트 검색</caption>
                             <colgroup>
                                 <col width="15%">
                                 <col width="85%">
                             </colgroup>
                             <tbody>
                                <tr>
                                     <th>검색어</th>
                                     <td>
                                         <div class="select_inp" id="searchDiv">
                                             <span>
                                                 <!-- <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" /> -->
                                                 <label for="select1"></label>
                                                 <select name="searchKind" id="searchKind" >
                                                     <option value="searchBbsId">게시판 아이디 </option>
                                                     <option value="searchBbsNm">게시판 명 </option>
                                                 </select>
                                             </span>
                                             <input type="text"  name="searchVal" id="searchVal" engOnly="true" style="ime-mode:disabled;" maxlength="50" />
                                         </div>
                                     </td>
                                 </tr>
                             </tbody>
                         </table>
                        
                     </div>
                     <div class="btn_box txtc">
                         <a href="#none" class="btn green" id="btn_id_search">검색</a>
                     </div>
                 </div>
     
                 <!-- line_box -->
                 <div class="line_box">
                     <div class="top_lay">
                        <div class="search_txt">
                            검색 <strong class="be" id = "a"></strong>개 /
                            총 <strong class="all" id = "b"></strong>개
                        </div>
                        <div class="select_btn">
                            <span class="select">
                                <label for="select1"></label>
                                <select name="rows" id="sel_rows">
                                    <tags:option codeStr="10:10개 출력;20:20개 출력;50:50개 출력" />
                                </select>
                            </span>
                        </div>
                     </div>
     
                     <!-- tblh -->
                     <div class="tblh th_l">
                         <table summary="게시판 리스트"  id="table_id_bbsList">
                             <caption>게시판 리스트</caption>
                             <colgroup>
                                 <col width="6%">
                                 <col width="10%">
                                 <col width="8%">
                                 <col width="8%">
                                 <col width="8%">
                                 <col width="8%">
                                 <col width="8%">
                                 <col width="8%">
                                 <col width="8%">
                                 <col width="8%">
                                 <col width="10%">
                                 <col width="10%">
                             </colgroup>
                             <thead>
                                 <tr>
                                     <th rowspan="3">번호</th>
                                     <th rowspan="3">게시판아이디</th>
                                     <th rowspan="3">게시판 명</th>
                                     <th colspan="5" class="line_b">사용자권한</th>
                                     <th rowspan="3">새글/<br>총게시글</th>
                                     <th rowspan="3">종류</th>
                                     <th rowspan="3">게시글관리</th>
                                     <th rowspan="3">관리</th>
                                 </tr>
                                 <tr>
                                     <th colspan="2" class="line_b line_l">읽기</th>
                                     <th colspan="3" class="line_b">쓰기</th>
                                 </tr>
                                 <tr>
                                     <th class="line_l">목록</th>
                                     <th>글내용</th>
                                     <th>글쓰기</th>
                                     <th>댓글</th>
                                     <th>답변</th>
                                 </tr>
                             </thead>
                             <tbody id="tbody_id_bbsList">
                                 <tr>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                     <td></td>
                                 </tr>
                             </tbody>
                         </table>
                     </div>
                     <!-- //tblh -->
                     <!-- pageing -->
                     <%-- <grid:paging resultListModel="${resultListModel}" /> --%>
                     <div class="bottom_lay" id="div_id_paging"></div>
                     <!-- //pageing -->
                     <!-- //bottom_lay -->
                     <!-- //line_box -->
                </div>
           </form>
        </div>
    </t:putAttribute>
</t:insertDefinition>
