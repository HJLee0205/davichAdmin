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
    <t:putAttribute name="title">판매자 정산집계 상세 목록</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            var siteNo = "${siteNo}";
            $(document).ready(function() {
                // 검색
                $('#btn_id_search').on('click', function() {
                    $("#search_id_page").val("1");
                    
                    var call = "${sellerSO.call}";
                    if (call == "manager") {
                        $('#form_id_search').attr('action', '/admin/seller/calc/calc-manager-list');
                    } else {
                        $('#form_id_search').attr('action', '/admin/seller/calc/calc-total-list');
                    }
                    
                    $('#form_id_search').submit();
                });

                $('a.btn_exl').on('click', function(){
                    $('#form_id_search').attr('action', '/admin/seller/calc/calc-dtl-download');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '/admin/seller/calc/calc-dtl-list');
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">판매자 정산 상세 내역</h2>
                <div class="btn_box left">
                
				   <c:choose>
				       <c:when test="${sellerSO.call == 'manager'}">
	                    	<a href="#none" class="btn green" id="btn_id_search">정산관리목록</a>
				       </c:when>
				       <c:otherwise>
	                    	<a href="#none" class="btn green" id="btn_id_search">정산집계목록</a>
				       </c:otherwise>
				   </c:choose>
                </div>
            </div>
            <!-- search_box -->
            <div class="search_box">
                <!-- search_tbl -->
                <form:form action="/admin/seller/calc-total-list" id="form_id_search" commandName="sellerSO">
                    <input type="hidden" name="_action_type" value="INSERT" />                    
                    <form:hidden path="page" id="search_id_page" />
                    <form:hidden path="rows" />
                    <input type="hidden" name="sellerNo" value="${sellerSO.sellerNo}" />
                    <input type="hidden" name="calcStart" value="${sellerSO.calcStart}" />
                    <input type="hidden" name="calcEnd" value="${sellerSO.calcEnd}" />
                    <input type="hidden" name="calculateNo" value="${sellerSO.calculateNo}" />
                    <input type="hidden" name="yr" value="${sellerSO.yr}" />
                    <input type="hidden" name="mm" value="${sellerSO.mm}" />
                </form:form>
            </div>            
            
            <!-- //line_box -->
            <!-- line_box -->
            <grid:table id="grid_id_sellerList" so="${sellerSO}" resultListModel="${resultListModel}" hasExcel = "true" >
                <!-- tblh -->
                <div class="tblh">
                        <table summary="정산 상세 목록입니다.. ">
                            <caption>정산 상세 리스트</caption>
                            <colgroup>
                                <col width="6%">
                                <col width="10%">
                                <col width="14%">
                                <col width="10%">
                                <col width="20%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>구매확정일자</th>
                                    <th>주문번호</th>
                                    <th>주문상세번호</th>
                                    <th>상품명</th>
                                    <th>공급가액</th>
                                    <th>수량</th>
                                    <th>과세구분</th>
                                    <th>배송비</th>
                                </tr>
                            </thead>
                            <tbody id="ledgerListTbody">
		                        <c:forEach var="calcList" items="${resultListModel.resultList}" varStatus="status">
		                            <tr >
		                                <td>${calcList.rownum}</td>
		                                <td>${calcList.buyDecideDttm}</td>
		                                <td>${calcList.ordNo}</td>
		                                <td>${calcList.ordDtlSeq}</td>
		                                <td>${calcList.goodsNm}</td>
		                                <td><fmt:formatNumber value="${calcList.purchaseAmt}" pattern="#,###" /></td>
		                                <td>${calcList.ordQtt}</td>
		                                <td>${calcList.taxGbNm}</td>
		                                <td><fmt:formatNumber value="${calcList.dlvrAmt}" pattern="#,###" /></td>
		                            </tr>
		                        </c:forEach>
		                        <c:if test="${fn:length(resultListModel.resultList)==0}">
		                            <tr>
		                                <td colspan="9">검색된 데이터가 존재하지 않습니다.</td>
		                            </tr>
		                        </c:if>                            
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
            </grid:table>
            <!-- //line_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>
