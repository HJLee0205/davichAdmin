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
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; 팝업 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            jQuery(document).ready(function() {
                
                // 검색
                jQuery('#btn_id_search').on('click', function() {
                    jQuery('#form_id_search').submit();
                });
                
                // 수정
                jQuery('.btn_id_detail').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var popupNo = jQuery(this).parents('tr').data('popup-no');
                    //alert(popupNo);
                    Dmall.FormUtil.submit('/admin/design/pop', {popupNo : popupNo});
                });
                
                // 등록 화면
                jQuery('#btn_id_save').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.FormUtil.submit('/admin/design/pop-detail', {popupNo : ''});
                });

                // 삭제 처리
                jQuery('#btn_id_delete').on('click', function(e) {
                    var selected = fn_selectedList();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 팝업을 삭제 하시겠습니까?', function() {
                            var url = '/admin/design/pop-delete',
                                    param = {},
                                    key;

                            jQuery.each(selected, function(i, o) {
                                key = 'list[' + i + '].popupNo';
                                param[key] = o;
                                key = 'list[' + i + '].fileNm';
                                param[key] = jQuery('#fileNm_'+o).val();
                                key = 'list[' + i + '].filePath';
                                param[key] = jQuery('#filePath_'+o).val();
                                key = 'list[' + i + '].orgFileNm';
                                param[key] = jQuery('#orgFileNm_'+o).val();
                                key = 'list[' + i + '].fileSize';
                                param[key] = jQuery('#fileSize_'+o).val();
                            });

                            console.log("param = ", param);
                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_detail');
                                if(result.success){

                                    /*var data = $('#form_id_search').serializeArray();
                                    var param = {};
                                    $(data).each(function(index,obj){
                                        param[obj.name] = obj.value;
                                    });*/
                                    jQuery('#form_id_search').submit();
                                    //Dmall.FormUtil.submit('/admin/design/pop-manage', param);
                                }
                            });
                        });
                    }
                });
                
                jQuery('#grid_id_popupList').grid(jQuery('#form_id_search'));
                
            });

            // 선택된값 체크
            function fn_selectedList() {
                var selected = [];
                
                $("input[name='chkPopupNo']:checked").each(function() {
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
        <div class="sec01_box">
            <%--<div class="tlt_box">
                <h2 class="tlth2">팝업 관리</h2>
                <!-- <div class="btn_box left">
                    <button class="btn green" id="btn_id_search">검색</button>
                </div> -->
                <div class="btn_box right">
                    <a href="#none" class="btn blue" id="btn_id_save2">팝업 만들기</a>
                </div>
            </div>--%>
            <div class="tlt_box">
                <div class="tlt_head">
                    디자인 설정<span class="step_bar"></span>  팝업 관리 <span class="step_bar"></span>
                </div>
                <h2 class="tlth2">팝업 관리</h2>
            </div>
            <div class="search_box_wrap">
            <!-- search_box -->
                <form:form action="/admin/design/pop-manage" id="form_id_search" commandName="so">
                <form:hidden path="page" id="search_id_page" />
                <form:hidden path="rows" />
                <input type="hidden" name="sort" value="${so.sort}" />
                <input type="hidden" name="pcGbCd" value="C" />
                <input type="hidden" name="popupGrpCd" value="MM" />
                <input type="hidden" name="popupGbCd" value="P" />
                <%--<input type="hidden" name="dispYn" value="Y" />--%>
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 팝업 관리 검색 표 입니다. 구성은 노출메뉴, 전시기간, 팝업구분, 전시유형, 검색어 입니다.">
                            <caption>팝업 관리 검색</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2">기간</th>
                                    <td>
                                        <%--<span class="select">
                                            <label for="">전시기간 선택</label>
                                            <select name="dateGubn" id="dateGubn">
                                                <option value="">선택하세요</option>
                                                <tags:option  codeStr="I:등록일;S:전시시작일;E:전시종료일"  value="${so.dateGubn}" />
                                            </select>
                                        </span>--%>
                                        <tags:calendar from="fromRegDt" to="toRegDt" fromValue="${so.fromRegDt}" toValue="${so.toRegDt}" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%--<label for="applyAlwaysYn" class="chack mr20">
                                            <input type="checkbox" name="applyAlwaysYn" id="applyAlwaysYn" value="N" class="blind">
                                            <span class="ico_comm"></span>
                                            무제한
                                        </label>--%>
                                        <c:set var="on" value=" on"/>
                                        <c:set var="checked" value="  checked=\"checked\""/>
                                        <label for="applyAlwaysYn" id="lb_applyAlwaysYn" class="chack mr20<c:if test="${so.applyAlwaysYn eq 'Y'}" >${on}</c:if>">
                                            <input type="checkbox" name="applyAlwaysYn" id="applyAlwaysYn" value="Y" <c:if test="${so.applyAlwaysYn eq 'Y'}" >${checked}</c:if> class="blind" />
                                            <span class="ico_comm">&nbsp;</span>
                                            무제한
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt wid100p"><input type="text" value="${so.popupNm}" id="popupNm" name="popupNm"></span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                </div>
                </form:form>
                <div class="btn_box txtc">
                    <button class="btn--black" id="btn_id_search">검색</button>
                </div>
                <!-- //search_box -->
                <!-- line_box -->
                <grid:tableSearchCnt id="grid_id_popupList" so="${so}" resultListModel="${resultListModel}" rowsOptionStr="" sortOptionStr="" type="게시물">
                    <!-- tblh -->
                    <div class="tblh">
                        <table id="table_id_popupList" summary="이표는 팝업관리 리스트 표 입니다. 구성은 체크박스, 메뉴및위치, 팝업구분, 팝업창명, 전시여부, 전시시작일시, 전시종료일시, 등록자ID, 등록자명, 등록 일시 입니다.">
                            <caption>팝업관리 리스트</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="8%">
                                <col width="30%">
                                <col width="25%">
                                <col width="15%">
                                <col width="20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>
                                        <label for="chack05" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="table" id="chack05" class="blind" /></span>
                                        </label>
                                    </th>
                                    <th>번호</th>
                                    <th>팝업제목</th>
                                    <th>기간</th>
                                    <th>사용여부</th>
                                    <th>작성일</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_id_popupList">
                            <c:forEach var="popupList" items="${resultListModel.resultList}" varStatus="status">
                                <tr data-popup-no="${popupList.popupNo}">
                                    <td>
                                        <input type="hidden" id="filePath_${popupList.popupNo}" value="${popupList.filePath}" />
                                        <input type="hidden" id="orgFileNm_${popupList.popupNo}" value="${popupList.orgFileNm}" />
                                        <input type="hidden" id="fileNm_${popupList.popupNo}" value="${popupList.fileNm}" />
                                        <input type="hidden" id="fileSize_${popupList.popupNo}" value="${popupList.fileSize}" />
                                        <input type="hidden" name="dispYn" value="${popupList.dispYn}" />
                                        <label for="chack05_${status.count}" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="chkPopupNo" id="chack05_${status.count}" value="${popupList.popupNo}" /></span>
                                        </label>
                                    </td>
                                    <td>${popupList.rownum}</td>
                                    <td>
                                        <a href="#none" class="btn_id_detail">${popupList.popupNm}</a>
                                    </td>
                                    <c:if test="${popupList.applyAlwaysYn eq 'Y'}">
                                    <td>무제한</td>
                                    </c:if>
                                    <c:if test="${popupList.applyAlwaysYn eq 'N' or popupList.applyAlwaysYn eq '' or popupList.applyAlwaysYn eq null}">
                                    <td>${popupList.dispStartDttm} ~ ${popupList.dispEndDttm}</td>
                                    </c:if>
                                    <td><tags:value codeStr="Y:사용;N:미사용" value="${popupList.dispYn}" /></td>
                                    <td><fmt:formatDate value="${popupList.regDttm}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <!-- pageing -->
                        <grid:paging resultListModel="${resultListModel}" />
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                </grid:tableSearchCnt>
            </div>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_id_delete">선택 삭제</button>
                </div>
                <div class="right">
                    <div class="pop_btn">
                        <button class="btn--blue-round" id="btn_id_save">등록</button>
                    </div>
                </div>
            </div>

        </div>
        <!-- //content -->
    </t:putAttribute>
</t:insertDefinition>
