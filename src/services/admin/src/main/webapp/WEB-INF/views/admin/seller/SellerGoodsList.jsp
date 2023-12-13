<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2023/01/13
  Time: 3:36 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <t:putAttribute name="title">판매자 상품 관리 > 업체</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function(e) {
                    var fromDttm = $('#srch_sc01').val().replace(/-/gi, '');
                    var toDttm = $('#srch_sc02').val().replace(/-/gi, '');
                    if(fromDttm && toDttm && fromDttm > toDttm) {
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $('#hd_page').val('1');
                    $('#form_id_search').attr('action', '/admin/seller/seller-goods-list');
                    $('#form_id_search').submit();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));

                // 엑셀 다운로드 버튼 클릭
                $('#btn_download').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#form_id_search').attr('action', '/admin/goods/download-excel');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '/admin/seller/seller-goods-list');
                })

                // 선택승인 버튼 클릭
                $('#btn_approve').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var chk = $('input[name=chkSellerGoods]').is(':checked');
                    if(chk == false) {
                        Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('선택한 상품을 판매승인 하시겠습니까?', function() {
                        var url = '/admin/goods/salestart-update';
                        var param = {};

                        $('input[name=chkSellerGoods]:checked').each(function(idx, obj) {
                            param['list['+ idx +'].goodsNo'] = $(obj).val();
                            param['list['+ idx +'].aprvYn'] = 'Y';
                        });

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            location.reload();
                        });
                    });
                });
            });

            // 상품 보기
            function viewGoodsDtl(goodsNo, goodsTypeCd) {
                Dmall.FormUtil.submit('/admin/seller/seller-goods-detail', { goodsNo: goodsNo, typeCd: goodsTypeCd });
            }

            // 승인 버튼
            function aprvGoods(goodsNo) {
                Dmall.LayerUtil.confirm('해당 상품을 판매승인 하시겠습니까?', function() {
                    var url = '/admin/goods/salestart-update';
                    var param = {};

                    param['list[0].goodsNo'] = goodsNo;
                    param['list[0].aprvYn'] = 'Y';

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        location.reload();
                    });
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    업체 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매자 상품 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <!-- search_tbl -->
                    <form:form action="/admin/seller/seller-goods-list" id="form_id_search" commandName="goodsSO">
                        <form:hidden path="page" id="hd_page"/>
                        <input type="hidden" name="searchDateType" id="searchDataType" value="1">
                        <input type="hidden" name="searchType" id="searchType" value="1">
                        <input type="hidden" name="goodsStatus" id="goodsStatus" value="3">
                        <div class="search_tbl">
                            <table summary="">
                                <caption>판매자 상품 관리</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="searchDateFrom" to="searchDateTo" fromValue="${goodsSO.searchDateFrom}" toValue="${goodsSO.searchDateTo}" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매자</th>
                                    <td>
                                        <span class="select">
                                            <label for="sel_seller">전체</label>
                                            <select name="searchSeller" id="sel_seller">
                                                <cd:sellerOption siteno="${siteNo}" includeTotal="true" value="${goodsSO.searchSeller}"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품명</th>
                                    <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="searchWord" id="txt_search_word" value="${goodsSO.searchWord}">
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
                                총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>개의 상품이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="btn_download">
                                <span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table style="table-layout:fixed;" summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                            <caption>판매상품관리 리스트</caption>
                            <colgroup>
                                <col width="66px">
                                <col width="66px">
                                <col width="100px">
                                <col width="15%">
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="allcheck" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="allcheck"></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>이미지</th>
                                <th>상품명</th>
                                <th>상품코드</th>
                                <th>브랜드</th>
                                <th>판매자</th>
                                <th>판매가<br/>(배송비)</th>
                                <th>공급가</th>
                                <th>재고</th>
                                <th>판매 상태</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_goods_data">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="12">데이터가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="sellerGoods" items="${resultListModel.resultList}" varStatus="status">
                                        <tr>
                                            <td>
                                                <label for="chkSellerGoods_${sellerGoods.sortNum}" class="chack">
                                                    <span class="ico_comm"><input type="checkbox" name="chkSellerGoods" id="chkSellerGoods_${sellerGoods.sortNum}" value="${sellerGoods.goodsNo}" class="blind"></span>
                                                </label>
                                            </td>
                                            <td>${sellerGoods.sortNum}</td>
                                            <td><img src="${_IMAGE_DOMAIN}${sellerGoods.goodsImg02}" alt=""></td>
                                            <td><a href="#none" class="tbl_link" onclick="viewGoodsDtl('${sellerGoods.goodsNo}', '${sellerGoods.goodsTypeCd}');">${sellerGoods.goodsNm}</a></td>
                                            <td>${sellerGoods.goodsNo}</td>
                                            <td>${sellerGoods.brandNm}</td>
                                            <td>${sellerGoods.sellerNm}</td>
                                            <td><fmt:formatNumber value="${sellerGoods.salePrice}" pattern="#,###" /><br/><fmt:formatNumber value="${sellerGoods.goodseachDlvrc}" pattern="#,###" /></td>
                                            <td><fmt:formatNumber value="${sellerGoods.supplyPrice}" pattern="#,###" /></td>
                                            <td><fmt:formatNumber value="${sellerGoods.stockQtt}" pattern="#,###" /></td>
                                            <td><span class="sale_info1">${sellerGoods.goodsSaleStatusNm}</span></td>
                                            <td>
                                                <a href="#none" class="btn_gray" onclick="aprvGoods('${sellerGoods.goodsNo}')">승인</a>
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
                        <button class="btn--big btn--big-white" id="btn_approve">선택 승인</button>
                    </div>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>