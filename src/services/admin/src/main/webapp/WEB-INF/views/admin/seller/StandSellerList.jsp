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
    <t:putAttribute name="title">입점/제휴 문의 > 업체</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $('#srch_sc01').val().replace(/-/gi, "");
                    var toDttm = $('#srch_sc02').val().replace(/-/gi, "");
                    if(fromDttm && toDttm && fromDttm > toDttm) {
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $("#hd_page").val('1');
                    $('#form_id_search').submit();
                });

                // 엔터키 입력 시 검색
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));

                // 선택 삭제 버튼 클릭
                $('#btn_delete').on('click', function() {
                    if(validateSelList()) {
                        Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
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
                                $("#hd_page").val('1');
                                $('#form_id_search').submit();
                            });
                        });
                    }
                });

                // 입점 등록 버튼 클릭
                $('#btn_regist').on('click', function() {
                    if(validateSelList()) {
                        Dmall.LayerUtil.confirm('선택된 판매자를 입점 등록하시겠습니까?', function() {
                            var url = '/admin/seller/seller-approve';
                            var param = {};
                            var key;
                            var selected = getSelectedList();

                            jQuery.each(selected, function(idx, obj) {
                                key = 'list[' + idx + '].sellerNo';
                                param[key] = obj;
                                key = 'list[' + idx + '].statusCd';
                                param[key] = '03';
                                key = 'list['+ idx +'].managerMemo';
                                param[key] = 'approve';             // 입점/제휴일 때 reg_dttm 을 갱신하기 위해 사용
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                $("#hd_page").val('1');
                                $('#form_id_search').submit();
                            });
                        });
                    }
                });

                // 게시글 답변/삭제 버튼 클릭
                $(document).on('click', '#tbody_id_sellerList a.btn_gray4', function() {
                    var sellerNo = $(this).parents('tr').data('seller-no');

                    if($(this).text() == '답변') {
                        Dmall.FormUtil.submit('/admin/seller/seller-reply-form', {sellerNo: sellerNo});
                    } else {
                        Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
                            var url = '/admin/seller/seller-delete';
                            var key = 'list[0].sellerNo';
                            var param = {};
                            param[key] = sellerNo;

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                $('hd_page').val('1');
                                $('#form_id_search').submit();
                            });
                        });
                    }
                })

                // 게시글 보기 페이지 이동
                $(document).on('click', '#tbody_id_sellerList a.tbl_link', function() {
                    var sellerNo = $(this).parents('tr').data('seller-no');
                    Dmall.FormUtil.submit('/admin/seller/seller-ref-view', {sellerNo: sellerNo});
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
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    업체 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">입점/제휴 문의</h2>
            </div>
            <div class="search_box_wrap">
                <form:form action="/admin/seller/stand-seller-list" id="form_id_search" commandName="sellerSO">
                    <form:hidden path="page" id="hd_page"/>
                    <!-- search_box -->
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 입접/제휴문의 게시판 리스트 검색 표 입니다. 구성은 문의구분,검색어 입니다.">
                                <caption>게시글 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>등록일</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" fromValue="${sellerSO.fromRegDt}" toValue="${sellerSO.toRegDt}" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>문의 구분</th>
                                    <td>
                                        <tags:radio codeStr=":전체;01:입점;02:제휴" name="storeInquiryGbCd" idPrefix="storeInquiryGbCd" value="${sellerSO.storeInquiryGbCd}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt long">
                                            <form:input path="searchWords"/>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                        <div class="btn_box txtc">
                            <button class="btn green" id="btn_id_search">검색</button>
                        </div>
                    </div>
                    <!-- //search_box -->
                </form:form>
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="be" id="a">${resultListModel.filterdRows}</strong>개의 게시물이 검색되었습니다.
                            </span>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table style="table-layout: fixed;" summary="입점 / 제휴 문의 리스트 표 입니다. 구성은 선택, 번호, 문의 구분, 문의 내용, 업체명, 담당자명, 등록일시, 답변상태, 관리 입니다.">
                            <caption>입점 / 제휴 문의 리스트 표</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="5%">
                                <col width="10%">
                                <col width="200px">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
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
                                <th>No</th>
                                <th>문의 구분</th>
                                <th>문의 내용</th>
                                <th>업체명</th>
                                <th>담당자명</th>
                                <th>등록일시</th>
                                <th>답변상태</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_sellerList">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="9">데이터가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="sellerList" items="${resultListModel.resultList}" varStatus="status">
                                        <tr data-seller-no="${sellerList.sellerNo}">
                                            <td>
                                                <label for="chkSellerNo_${sellerList.rowNum}" class="chack">
                                                    <span class="ico_comm"><input type="checkbox" name="chkSellerNo" id="chkSellerNo_${sellerList.rowNum}" value="${sellerList.sellerNo}" class="blind"></span>
                                                </label>
                                            </td>
                                            <td>${sellerList.rowNum}</td>
                                            <td>${sellerList.storeInquiryGbCdNm}</td>
                                            <td class="txtl"><a href="#none" class="tbl_link ellipsis">${sellerList.storeInquiryContent}</a></td>
                                            <td>${sellerList.sellerNm}</td>
                                            <td>${sellerList.managerNm}</td>
                                            <td>${sellerList.regDt}</td>
                                            <td>${sellerList.replyStatusYnNm}</td>
                                            <td>
                                                <div class="btn_gray4_wrap">
                                                    <a href="#none" class="btn_gray4">답변</a>
                                                    <a href="#none" class="btn_gray4 btn_gray4_right">삭제</a>
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
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_delete">선택삭제</button>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_regist">입점 등록</button>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
