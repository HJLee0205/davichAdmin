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
    <t:putAttribute name="title">판매자 관리 > 업체</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function() {
                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm && toDttm && fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $("#hd_page").val("1");
                    $('#form_id_search').submit();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));

                // 승인완료 버튼 클릭
                $('#btn_id_approve').on('click', function() {
                    if(validateSelList()) {
                        var chkValid = $('input:checkbox[name=chkSellerNo]:checked').parents().is('tr[data-status-cd!=01]');
                        if (chkValid) {
                            Dmall.LayerUtil.alert('승인요청 상태의 판매자만 선택해주세요');
                            return;
                        }

                        Dmall.LayerUtil.confirm('선택된 판매자의 거래를 승인하시겠습니까?', function() {
                            var url = '/admin/seller/seller-status-change';
                            var param = {};
                            var key;
                            var selected = getSelectedList();

                            jQuery.each(selected, function(idx, obj) {
                                key = 'list[' + idx + '].sellerNo';
                                param[key] = obj;
                                key = 'list[' + idx + '].statusCd';
                                param[key] = '02';
                                key = 'list[' + idx + '].aprvYn';
                                param[key] = 'N';
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                $('#form_id_search').submit();
                            });
                        });
                    }
                });

                // 거래중 버튼 클릭
                $('#btn_id_resume').on('click', function() {
                    if(validateSelList()) {
                        var chkValid = $('input:checkbox[name=chkSellerNo]:checked').parents().is('tr[data-status-cd!=03]');
                        if (chkValid) {
                            Dmall.LayerUtil.alert('거래정지 상태의 판매자만 선택해주세요.');
                            return;
                        }

                        Dmall.LayerUtil.confirm('선택된 판매자의 거래를 재개하시겠습니까?', function() {
                            var url = '/admin/seller/seller-status-change';
                            var param = {};
                            var key;
                            var selected = getSelectedList();

                            jQuery.each(selected, function(idx, obj) {
                                key = 'list[' + idx + '].sellerNo';
                                param[key] = obj;
                                key = 'list[' + idx + '].statusCd';
                                param[key] = '02';
                                key = 'list[' + idx + '].aprvYn';
                                param[key] = 'Y';
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                $('#form_id_search').submit();
                            });
                        });
                    }
                });

                // 거래정지 버튼 클릭
                $('#btn_id_suspend').on('click', function() {
                    if(validateSelList()) {
                        var chkValid = $('input:checkbox[name=chkSellerNo]:checked').parents().is('tr[data-status-cd!=02]');
                        if (chkValid) {
                            Dmall.LayerUtil.alert('거래중 상태의 판매자만 선택해주세요.');
                            return;
                        }

                        Dmall.LayerUtil.confirm('선택된 판매자의 거래를 정지하시겠습니까?', function() {
                            var url = '/admin/seller/seller-status-change';
                            var param = {};
                            var key;
                            var selected = getSelectedList();

                            jQuery.each(selected, function(idx, obj) {
                                key = 'list[' + idx + '].sellerNo';
                                param[key] = obj;
                                key = 'list[' + idx + '].statusCd';
                                param[key] = '03';
                                key = 'list[' + idx + '].aprvYn';
                                param[key] = 'Y';
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                $('#form_id_search').submit();
                            });
                        });
                    }
                });

                // 삭제 버튼 클릭
                $('#btn_delete').on('click', function() {
                    if(validateSelList()) {
                        Dmall.LayerUtil.confirm('삭제된 판매자는 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
                            var url = '/admin/seller/seller-delete';
                            var param = {};
                            var key;
                            var selected = getSelectedList();

                            jQuery.each(selected, function(idx, obj) {
                                key = 'list[' + idx + '].sellerNo';
                                param[key] = obj;
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                $('#form_id_search').submit();
                            });
                        });
                    }
                });

                // 판매자등록 버튼 클릭
                $('#btn_regist').on('click', function() {
                    Dmall.FormUtil.submit('/admin/seller/seller-detail', { sellerNo: '-1', inputGbn: 'INSERT' });
                });

                // 엑셀 다운로드 버튼 클릭
                $('#btn_download').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#form_id_search').attr('action', '/admin/seller/seller-excel-download');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '/admin/seller/seller-list');
                });
            });

            // 선택된 게시글 리스트 반환
            function getSelectedList() {
                var selected = [];
                $('input:checkbox[name=chkSellerNo]:checked').each(function() {
                    selected.push($(this).val());
                });
                return selected;
            }

            // 선택된 게시글 유무 검증
            function validateSelList() {
                var chk = $('input:checkbox[name=chkSellerNo]').is(':checked');
                if(chk == false) {
                    Dmall.LayerUtil.alert('선택된 데이터가 없습니다.');
                    return false;
                }
                return true;
            }

            // 수정 버튼 클릭 함수
            function update(obj, no) {
                Dmall.FormUtil.submit('/admin/seller/seller-detail', { sellerNo: no, inputGbn: 'UPDATE' });
            }

            // 접속 버튼 클릭 함수
            function join(no, id, nm){
                var param = {
                    sellerNo: no,
                    sellerId: id,
                    sellerNm: nm
                };
                Dmall.FormUtil.submit('/admin/seller/main/main-view', param, '_blank');
            }

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    업체 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매자 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <!-- search_tbl -->
                    <form:form action="/admin/seller/seller-list" id="form_id_search" commandName="sellerSO">
                        <form:hidden path="page" id="hd_page"/>
                        <div class="search_tbl">
                            <table summary="">
                                <caption>판매자 관리</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" fromValue="${sellerSO.fromRegDt}" toValue="${sellerSO.toRegDt}" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <tags:radio name="statusCd" codeStr=":전체;01:승인요청;02:거래중;03:거래정지;" value="${sellerSO.statusCd}" idPrefix="check_id_status"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt w100p">
                                            <form:input path="searchWords"/>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" class="btn--black" id="btn_id_search">검색</a>
                        </div>
                    </form:form>
                    <!-- //search_tbl -->
                </div>
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                              총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>명의 판매자가 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="btn_download">
                                <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="판매자 리스트">
                            <caption>판매자 리스트</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="5%">
                                <col width="8%">
                                <col width="12%">
                                <col width="14%">
                                <col width="10%">
                                <col width="12%">
                                <col width="12%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack05" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05"></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>판매자번호</th>
                                <th>아이디</th>
                                <th>업체명</th>
                                <th>담당자</th>
                                <th>담당자 전화번호</th>
                                <th>담당자 휴대폰</th>
                                <th>거래상태</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_sellerList">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="10">데이터가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="sellerList" items="${resultListModel.resultList}" varStatus="status">
                                        <tr data-status-cd="${sellerList.statusCd}" data-aprv-yn="${sellerList.aprvYn}">
                                            <td>
                                                <label for="chkSellerNo_${sellerList.rowNum}" class="chack">
                                                    <span class="ico_comm"><input type="checkbox" name="chkSellerNo" id="chkSellerNo_${sellerList.rowNum}" value="${sellerList.sellerNo}" class="blind"></span>
                                                </label>
                                            </td>
                                            <td>${sellerList.rowNum}</td>
                                            <td>${sellerList.sellerNo}</td>
                                            <td>${sellerList.sellerId}</td>
                                            <td>${sellerList.sellerNm}</td>
                                            <td>${sellerList.managerNm}</td>
                                            <td>${sellerList.managerTelno}</td>
                                            <td>${sellerList.managerMobileNo}</td>
                                            <td>${sellerList.statusNm}</td>
                                            <td>
                                                <div class="btn_gray4_wrap">
                                                    <c:set var="rightClass" value=""/>
                                                    <c:if test="${sellerList.sellerId != null}">
                                                        <a href="#none" class="btn_gray4" onclick="join('${sellerList.sellerNo}', '${sellerList.sellerId}', '${sellerList.sellerNm}')">접속</a>
                                                        <c:set var="rightClass" value="btn_gray4_right"/>
                                                    </c:if>
                                                    <a href="#none" class="btn_gray4 ${rightClass}" onclick="update(this, '${sellerList.sellerNo}')">수정</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <grid:paging resultListModel="${resultListModel}" />
                    </div>
                    <!-- //bottom_lay -->
                </div>
            </div>
            <!-- bottom_box -->
            <div class="bottom_box">
                <div class="left">
                    <div class="pop_btn">
                        <button class="btn--big btn--big-white" id="btn_id_approve">승인완료</button>
                        <button class="btn--big btn--big-white" id="btn_id_resume">거래중</button>
                        <button class="btn--big btn--big-white" id="btn_id_suspend">거래정지</button>
                        <button class="btn--big btn--big-white" id="btn_delete">삭제</button>
                    </div>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_regist">판매자 등록</button>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>
