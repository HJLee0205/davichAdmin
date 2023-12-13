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
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; 전시 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            jQuery(document).ready(function() {
                
                // 검색
                jQuery('#btn_id_search').on('click', function() {
                    jQuery('#form_id_search').submit();
                });
                
                // 상세
                jQuery('.btn_id_detail').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var dispNo = jQuery(this).parents('tr').data('disp-no');
                    //alert(popupNo);
                    Dmall.FormUtil.submit('/admin/design/display-detail-info', {dispNo : dispNo});
                });
                
                // 등록 화면
                jQuery('#btn_id_save').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.FormUtil.submit('/admin/design/display-detail', {popupNo : ''});
                });
                
                // 미리 보기
                jQuery('.btn_preview').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.open(jQuery('#layer_id_banner_view'));
                    var $this = jQuery(this),
                        dispNo = $this.parents('tr').data('disp-no');
                    //alert(fileName);
                    jQuery('#img_preview').attr('src','/admin/design/image-preview?dispNo=' + dispNo);

                    //Dmall.FormUtil.submit('/admin/design/display-detail', {popupNo : ''});
                });

                // 전시 처리
                jQuery('#btn_id_view').on('click', function(e) {
                    selected = fn_selectedList();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 팝업의 전시 상태로 변경하시겠습니까?', function() {
                            var url = '/admin/design/pop-view-update',
                                    param = {},
                                    key,
                                    selected = fn_selectedList();
                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].popupNo';
                                    param[key] = o;
                                    key = 'list[' + i + '].dispYn';
                                    param[key] = "Y";
                                });            
                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    //getSearchGoodsData();
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    jQuery('#form_id_search').submit();
                                });
                        });
                    }
                });

                // 미전시 처리
                jQuery('#btn_id_notView').on('click', function(e) {
                    selected = fn_selectedList();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 팝업의 미전시 상태로 변경하시겠습니까?', function() {
                            var url = '/admin/design/pop-view-update',
                                    param = {},
                                    key,
                                    selected = fn_selectedList();
                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].popupNo';
                                    param[key] = o;
                                    key = 'list[' + i + '].dispYn';
                                    param[key] = "N";
                                });            
                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    //getSearchGoodsData();
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    jQuery('#form_id_search').submit();
                                });
                        });
                    }
                });

                jQuery('#grid_id_dispList').grid(jQuery('#form_id_search'));
                
            });
            
            // 선택된값 체크
            function fn_selectedList() {
                var selected = [];
                
                $("input[name='popupNoChk']:checked").each(function() {
                    selected.push($(this).val());     // 체크된 것만 값을 뽑아서 배열에 push
                });

                if (selected.length < 1) {
                    Dmall.LayerUtil.alert('선택된 항목이 없습니다.');
                }
                return selected;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!-- content -->
        <div id="content">
            <div class="sec01_box">
                <div class="tlt_box">
                    <h2 class="tlth2">전시 관리</h2>
                    <div class="btn_box left">
                        <button class="btn green" id="btn_id_search">검색</button>
                    </div>
                    <div class="btn_box right">
                        <a href="#none" class="btn blue" id="btn_id_save">전시 만들기</a>
                    </div>
                </div>
                <!-- search_box -->
                <form:form action="/admin/design/display" id="form_id_search" commandName="so">
                <form:hidden path="page" id="search_id_page" />
                <form:hidden path="rows" />
                <input type="hidden" name="sort" value="${so.sort}" />
                
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 전시 관리 검색 표 입니다. 구성은 배너 위치, 배너명 입니다.">
                            <caption>전시 관리 검색</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>배너 위치</th>
                                    <td>
                                        <span class="select">
                                            <label for="">배너 위치 선택</label>
                                            <select name="dispNo" id="dispNo">
                                                <option value="">선택하세요</option>
                                            <c:forEach var="dispTitleList" items="${resultListModel.extraData.titleList}" varStatus="status">
                                                <c:set var="selected" value=""/>
                                                <c:if test="${dispTitleList.dispNo eq so.dispNo}">
                                                    <c:set var="selected" value=" selected=\"selected\""/>
                                                </c:if>
                                                <option value="${dispTitleList.dispNo}" ${selected}>${dispTitleList.dispCdNm}</option>
                                            </c:forEach>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>전시 명</th>
                                    <td><span class="intxt wid100p"><input type="text" name="dispNm" id="dispNm" value="${so.dispNm}"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->

                </div>
                </form:form>
                <!-- //search_box -->
                <!-- line_box -->
                <grid:table id="grid_id_dispList" so="${so}" resultListModel="${resultListModel}" hasExcel = "false" sortOptionStr="REG_DTTM DESC:등록일▽;REG_DTTM ASC:등록일△">
                <div class="line_box">
                    <!-- tblh -->
                    <div class="tblh">
                            <table summary="이표는 전시 관리 리스트 표 입니다. 구성은 선택, 코드, 배너위치, 배너명, 순서, 관리 입니다.">
                                <caption>전시 관리 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="16%">
                                    <col width="22%">
                                    <col width="31%">
                                    <col width="10%">
                                    <col width="16%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <label for="chack05" class="chack">
                                                <span class="ico_comm"><input type="checkbox" name="table" id="chack05" class="blind" /></span>
                                            </label>
                                        </th>
                                        <th>코드</th>
                                        <th>배너위치</th>
                                        <th>배너명</th>
                                        <th>순서</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody id="tbody_id_dispList">
                                <c:forEach var="dispList" items="${resultListModel.resultList}" varStatus="status">
                                    <tr data-disp-no="${dispList.dispNo}">
                                        <td>
                                            <label for="chack05_${status.count}" class="chack">
                                                <span class="ico_comm"><input type="checkbox" name="dispNoChk" id="chack05_${status.count}" value="${dispList.dispNo}" /></span>
                                            </label>
                                        </td>
                                        <td>${dispList.dispCd}</td>
                                        <td>${dispList.dispCdNm}</td>
                                        <td class="txtl">${dispList.dispNm}</td>
                                        <td><span class="intxt shot4"><input type="text" name="sortSeq" id="sortSeq" value="${dispList.sortSeq}"></span></td>
                                        <td>
                                            <button class="btn_gray btn_id_detail">수정</button>
                                            <input type="hidden" value="${dispList.filePath}" id="filePath" name="filePath">
                                            <a href="#none" class="btn_gray btn_preview" title="새 창"> <span class="ico_comm readgl"></span> 미리보기</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${resultListModel.filterdRows == 0}">
                                    <tr>
                                        <td colspan="6">조회된 데이터가 없습니다.</td>
                                    </tr>
                                </c:if>
                                
                                </tbody>
                            </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div class="left">
                            <div class="pop_btn">
                                <a href="#none" class="btn_gray2">선택삭제</a>
                            </div>
                        </div>
                        <div class="right">
                            <div class="pop_btn">
                                <button class="btn_gray2">변경순서 저장</button>
                            </div>
                        </div>
                        <!-- pageing -->
                        <grid:paging resultListModel="${resultListModel}" />
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                </div>
                </grid:table>
                <!-- //line_box -->
            </div>
        </div>
        <!-- //content -->
    </t:putAttribute>
</t:insertDefinition>
<div id="layer_id_banner_view" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">배너 미리보기</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <img id="img_preview" src="">
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->