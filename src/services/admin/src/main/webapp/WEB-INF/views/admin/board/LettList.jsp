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
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                bbsLettSet.getBbsLettList();

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', bbsLettSet.getBbsLettList);

                jQuery('#btn_id_search').on('click', function(e){
                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm > toDttm){
                        Dmall.LayerUtil.alert('발생일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    jQuery("#hd_page").val("1");
                    bbsLettSet.getBbsLettList();
                });

                // 게시글 화면
                jQuery('#viewBbsLettDtl').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bbsId = $("#bbsId").val();
                    Dmall.FormUtil.submit('/admin/operation/letter-detail', {bbsId : bbsId});
                });

                // 등록 화면
                jQuery('#viewBbsLettInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    var param = {bbsId : $("#bbsId").val(), bbsNm : "${so.bbsNm}",
                                 noticeLettSetYn : "${so.noticeLettSetYn}", titleUseYn:"${so.titleUseYn}",
                                 bbsKindCd : "${so.bbsKindCd}"};

                    Dmall.FormUtil.submit('/admin/board/letter-insert-form', param);
                });

                // 수정 화면
                jQuery(document).on('click', '#tbody_id_bbsLettList a.btn_gray', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var lettNo = jQuery(this).parents('tr').data('lett-no');
                    var regrNo = jQuery(this).parents('tr').data('regr-no');
                    var titleNo = jQuery(this).parents('tr').data('title-no');
                    var lvl = jQuery(this).parents('tr').data('lvl');
                    var param = {bbsId : $("#bbsId").val(), bbsNm : "${so.bbsNm}", lettNo : lettNo,
                            noticeLettSetYn : "${so.noticeLettSetYn}", titleUseYn:"${so.titleUseYn}",
                            bbsKindCd : "${so.bbsKindCd}", regrNo: regrNo, titleNo: titleNo};

                    if(jQuery(this).text()=="수정"){
                        Dmall.FormUtil.submit('/admin/operation/letter-update-form', param);
                    }else{
                        /* var url = '/admin/operation/board-letter-delete';
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                Dmall.FormUtil.submit('/admin/operation/letter', param);
                            }
                        }); */
                        if(lvl<4){
                            var noticeYn = jQuery(this).parents('tr').data('notice-yn');
                            if(noticeYn=="Y"){ Dmall.LayerUtil.alert('공지글은 답변 불가능 합니다.'); return;}
                            Dmall.FormUtil.submit('/admin/operation/letter-reply-form', param);
                        }else{
                            Dmall.LayerUtil.alert('답변은 4단계 까지 가능합니다.');
                        }
                    }
                });

                 // 상세 화면
                jQuery(document).on('click', '#tbody_id_bbsLettList a.tbl_link', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    var lettNo = jQuery(this).parents('tr').data('lett-no');
                    var regrNo = jQuery(this).parents('tr').data('regr-no');
                    var titleNo = jQuery(this).parents('tr').data('title-no');
                    var param = {bbsId : $("#bbsId").val(), bbsNm : "${so.bbsNm}", lettNo : lettNo,
                            noticeLettSetYn : "${so.noticeLettSetYn}", titleUseYn:"${so.titleUseYn}",
                            bbsKindCd : "${so.bbsKindCd}", regrNo: regrNo, titleNo: titleNo};
                    Dmall.FormUtil.submit('/admin/operation/letter-detail', param);
                });

                // 선택 삭제
                jQuery(document).on('click', '#delSelectBbsLett', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk==false){
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해 주세요');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다. <br/> 정말 삭제하시겠습니까?', delSelectBbsLett);
                });

                jQuery("#searchKind" ).change(function() {
                    $("#searchVal").val("");
                });

                jQuery('#sel_rows').on('change', function(e) {
                    jQuery('#hd_page').val('1');
                    bbsLettSet.getBbsLettList();
                });
            });

            var bbsLettSet = {
                bbsLettList : [],
                getBbsLettList : function() {
                    var bbsId = '${so.bbsId}';
                    var url = '/admin/operation/board-letter-list',dfd = jQuery.Deferred();
                    var param = jQuery('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                            '<tr data-lett-no = "{{lettNo}}" data-bbs-nm="{{bbsNm}}" data-regr-no="{{regrNo}}" data-title-no="{{titleNo}}" data-lvl="{{lvl}}" data-notice-yn="{{noticeYn}}">'+
                            '<td>'+
                            '    <label for="delLettNo_{{lettNo}}" class="chack"> '+
                            '    <span class="ico_comm"><input type="checkbox" name="delLettNo" id="delLettNo_{{lettNo}}"  value="{{lettNo}}" /></span></label>'+
                            '</td>'+
                            '<td>{{rowNum}}</td>';
                        if(bbsId=="question") {
                            template +=    '<td><a href="/front/goods/goods-detail?goodsNo={{goodsNo}}" target="_blank">{{goodsNm}}</a></td>';
                        }
                            template += '{{titleNm}}{{title}}';
                        template +='<td>{{memberNm}}</td><td>{{regDttm}}</td>';
                        template +='<td><a href="#none" class="btn_gray">수정</a>';
                        template +='   <a href="#none" class="btn_gray">답변</a></td>';
                         var managerGroup = new Dmall.Template(template), tr = '';


                        jQuery.each(result.resultList, function(idx, obj) {
                            obj.title = obj.title + '('+obj.cmntCnt+')';
                            if(obj.iconCheckValueHot=="Y"){
                                obj.title = obj.title + ' <span class="ico_pin2">HOT</span>';
                            }
                            if(obj.iconCheckValueNew=="Y"){
                                obj.title = obj.title + ' <span class="ico_pin1">NEW</span>';
                            }
                            if(obj.rowNum=="notice"){
                                obj.rowNum = '<span class="point_c6">공지</span>';
                            }
                            var titleUseYn="${so.titleUseYn}";
                            if(titleUseYn=="Y"){
                                obj.titleNm = '<td>'+obj.titleNm+'</td>';
                            }else{
                                obj.titleNm = '';
                            }
                            if(obj.lvl==1){
                                obj.title ='<span class="ico_pin3">RE</span>'+obj.title;
                                obj.title = '<td class="txtl"><a href="#none" class="tbl_link" target="_blank">'+obj.title+'</a></td>';
                            }else if(obj.lvl==2){
                                obj.title ='&nbsp;&nbsp;&nbsp;&nbsp;<span class="ico_pin3">RE</span>'+obj.title;
                                obj.title = '<td class="txtl"><a href="#none" class="tbl_link" target="_blank">'+obj.title+'</a></td>';
                            }else if(obj.lvl==3){
                                obj.title ='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="ico_pin3">RE</span>'+obj.title;
                                obj.title = '<td class="txtl"><a href="#none" class="tbl_link" target="_blank">'+obj.title+'</a></td>';
                            }else if(obj.lvl==4){
                                obj.title ='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="ico_pin3">RE</span>'+obj.title;
                                obj.title = '<td class="txtl"><a href="#none" class="tbl_link" target="_blank">'+obj.title+'</a></td>';
                            }else{
                                obj.title = '<td class="txtl"><a href="#none" class="tbl_link" target="_blank">'+obj.title+'</a></td>';
                            }


                            if(obj.regrDispCd == "02"){
                                obj.memberNm = obj.loginId;
                            }
                            if(obj.goodsDispImgC !=null) {
                               // obj.goodsDispImgC = '<img src="' + obj.goodsDispImgC + '">'
                            }
                            tr += managerGroup.render(obj)
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="12">데이터가 없습니다.</td></tr>';
                        }
                        jQuery('#tbody_id_bbsLettList').html(tr);
                        bbsLettSet.bbsLettList = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsLett', bbsLettSet.getBbsLettList);

                        $("#a").text(result.filterdRows);
                        $("#b").text(result.totalRows);

                        var titleUseYn="${so.titleUseYn}";
                        if(titleUseYn!="Y"){
                            var colgroup ='<col width="5%">'+
                                            '<col width="7%">'+
                                            '<col width="58%">'+
                                            '<col width="10%">'+
                                            '<col width="10%">'+
                                            '<col width="10%">';
                            jQuery('#colgroupList').html(colgroup);
                            jQuery("#titleSelectBox").remove();
                        }


                        if(bbsId=="question"){
                            var colgroup =
                                '<col width="5%">'+
                                '<col width="7%">'+
                                '<col width="18%">'+
                                '<col width="40%">'+
                                '<col width="10%">'+
                                '<col width="10%">'+
                                '<col width="10%">';
                            jQuery('#colgroupList').html(colgroup);
                            if(titleUseYn!="Y") {
                                jQuery("#titleSelectBox").remove();
                            }
                        }

                    });

                    return dfd.promise();
                }
            }

            function delSelectBbsLett(){
                var param = jQuery('#form_id_search').serialize();
                var url = '/admin/operation/board-checkedletter-delete';

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var param = {bbsId : $("#bbsId").val(), bbsNm : "${so.bbsNm}"};
                    if(result.success){
                        jQuery("#hd_page").val("1");
                        bbsLettSet.getBbsLettList();
                        //Dmall.FormUtil.submit('/admin/operation/letter', param);
                    }
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
            <div class="sec01_box">
                <div class="tlt_box">
                    <div class="btn_box left">
                        <a href="/admin/operation/board" class="btn gray">게시판 리스트</a>
                    </div>
                    <h2 class="tlth2">[${so.bbsNm}] 게시글 리스트</h2>
                    <!-- <div class="btn_box left">
                        <a href="#none" class="btn green" id="btn_id_search">검색</a>
                    </div> -->
                    <div class="btn_box right">
                        <a href="#none" id="viewBbsLettInsert"  class="btn blue">게시글등록</a>
                    </div>
                </div>
                <!-- search_box -->
                <form id="form_id_search">
                <input type="hidden" name="page" id="hd_page" value="1" />
                <input type="hidden" name="sord" id="hd_srod" value="" />
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 게시판 리스트 검색 표 입니다. 구성은 검색어 입니다.">
                            <caption>게시글 검색</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                               <tr>
                                    <th>작성일</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt"  fromValue="" toValue="" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <span>
                                                <input type="hidden" id="bbsId" name="bbsId" value = "${so.bbsId}" />
                                                <label for="select1"></label>
                                                <select name="searchKind" id="searchKind">
                                                    <option value="all">전체</option>
                                                    <option value="searchBbsLettTitle">제목</option>
                                                    <option value="searchBbsLettContent">내용</option>
                                                    <option value="searchBbsLettRegr">작성자</option>
                                                </select>
                                            </span>
                                            <input type="text" value="" id="searchVal" name= "searchVal" />
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                    </div>

                </div>
				<div class="btn_box txtc">
					<a href="#none" class="btn green" id="btn_id_search">검색</a>
				</div>
                <!-- //line_box -->
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
                    <div class="tblh">
                        <table summary="게시글 리스트"  id="table_id_bbsLettList">
                            <caption>게시글 리스트</caption>
                            <colgroup id = "colgroupList">
                                <col width="5%">
                                <col width="7%">
                                <col id = "titleSelectBoxCol" width="10%">
                                <col width="48%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                                <tr>
                                   <th>
                                       <label for="chack05" class="chack" onclick="chack_btn(this);">
                                           <span class="ico_comm"><input type="checkbox" name="table" id="chack05"  /></span>
                                       </label>
                                   </th>
                                   <th>번호</th>
                                   <c:if test="${so.bbsId eq 'question'}">
                                    <th>상품정보</th>
                                   </c:if>
                                   <th id = "titleSelectBox">말머리</th>
                                   <th>제목</th>
                                   <th>작성자</th>
                                   <th>작성일</th>
                                   <th>관리</th>

                                </tr>
                            </thead>
                            <tbody id="tbody_id_bbsLettList">
                                <tr>
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

                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div class="left">
                            <div class="pop_btn">
                                <button id = "delSelectBbsLett" class="btn_gray2">선택삭제</button>
                            </div>
                        </div>

                        <!-- pageing -->
                        <%-- <grid:paging resultListModel="${resultListModel}" /> --%>
                         <div id="div_id_paging"></div>
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                <!-- //line_box -->
                </div>
                </form>
            </div>
    </t:putAttribute>
</t:insertDefinition>
