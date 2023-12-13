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
    <t:putAttribute name="title">판매자관리</t:putAttribute>
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
                    $('#form_id_search').attr('action', '/admin/seller/seller-list');
                    $('#form_id_search').submit();
                });

                $('#grid_id_sellerList').grid($('#form_id_search'));

                $('a.btn_exl').on('click', function(){
                    $('#form_id_search').attr('action', '/admin/seller/seller-excel-download');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '/admin/seller/seller-list');
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });
                
                
                // 판매자등록 버튼
                jQuery('#btn_regist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    //fn_registGoods();
                    Dmall.FormUtil.submit('/admin/seller/seller-detail', {popupNo : ''});
                });
            });

            //판매자 상세 정보
            function viewSellerInfoDtl(id){
                var sellerNo = id;
                Dmall.FormUtil.submit('/admin/seller/seller-view', {sellerNo : sellerNo, inputGbn:"VIEW"});
            }
            
            
            // 거래중지, 거래재개
            jQuery('#btn_id_approve, #btn_id_suspend').on('click', function(e) {
                selected = fn_selectedList();
                if (selected.length > 0) {

                	var msg = "";
                	var status = "";
                    if (e.target.id == "btn_id_approve") {
                    	status = "02";
                    	msg = '선택된 판매자의 거래를 재개 하시겠습니까?'
                    } else {
                    	status = "03";
                    	msg = '선택된 판매자의 거래를 중지 하시겠습니까?'
                    }
                	
                    Dmall.LayerUtil.confirm(msg, function() {
                        var url = '/admin/seller/seller-status-change',
                                param = {},
                                key,
                                selected = fn_selectedList();

                            jQuery.each(selected, function(i, o) {
                                key = 'list[' + i + '].sellerNo';
                                param[key] = o;
                                key = 'list[' + i + '].statusCd';
                                param[key] = status;
                            });            

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                jQuery('#form_id_search').submit();
                            });
                    });
                }
            });

            // 선택된값 체크
            function fn_selectedList() {
                var selected = [];
                
                $("input[name='table']:checked").each(function() {
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
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">판매자 리스트</h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue"  id="btn_regist">판매자 등록</a>
                </div>
            </div>
            <!-- search_box -->
            <div class="search_box">
                <!-- search_tbl -->
                <form:form action="/admin/seller/seller-list" id="form_id_search" commandName="sellerSO">
                    <input type="hidden" name="_action_type" value="INSERT" />                    
                    <form:hidden path="page" id="search_id_page" />
                    <form:hidden path="rows" />
                    <input type="hidden" name="sort" value="${sellerSO.sort}" />
                    <div class="search_tbl">
                        <table summary="">
                            <caption>판매자 관리</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="35%">
                                <col width="15%">
                                <col width="35%">
                            </colgroup>
                            <tbody>
                            <tr>
                               <tr>
                                    <th>작성일</th>
                                    <td colspan="3">
                                        <tags:calendar from="fromApvDt" to="toApvDt"  fromValue="${sellerSO.fromApvDt}" toValue="${sellerSO.toApvDt}" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                      <th>상태</th>
                                      <td colspan="3">
		                                <tags:radio name="statusCd" codeStr=": 전체;02: 거래중;03: 거래정지" value="${sellerSO.statusCd}" idPrefix="check_id_status"/>
                                      </td>
                                </tr>                                
                                <th>검색어</th>
                                <td colspan="3">
                                    <div class="select_inp" id="searchDiv">
                                        <span>
                                            <label for="srch_id_searchType">전체</label>
                                            <select name="searchType" id="srch_id_searchType">
                                                <tags:option codeStr="all:전체;name:업체명;id:아이디;email:이메일;tel:전화번호" value="${sellerSO.searchType}" />
                                            </select>
                                        </span>
                                        <c:choose>
                                            <c:when test="${sellerSO.searchType eq 'name' || sellerSO.searchType eq 'all'}">
                                                <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="40" maxlength="50" />
                                            </c:when>
                                            <c:when test="${sellerSO.searchType eq 'id' || sellerSO.searchType eq 'email'}">
                                                <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="40" maxlength="50" engOnly="true" cssStyle="ime-mode:disabled;" />
                                            </c:when>
                                            <c:when test="${sellerSO.searchType eq 'tel'}">
                                                <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="40" maxlength="50" onblur="chk_tel(this.value,this);" numberOnly="true" cssStyle="ime-mode:disabled;" />
                                            </c:when>
                                            <c:otherwise>
                                                <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="40" maxlength="50" />
                                            </c:otherwise>
                                        </c:choose>
<%--                                         <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="40" maxlength="50" /> --%>
                                        <form:errors path="searchWords" cssClass="errors"  />
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
	                <div class="btn_box txtc">
	                    <a href="#none" class="btn green" id="btn_id_search">검색</a>
	                </div>

                </form:form>
            </div>
            <!-- //line_box -->
            <!-- line_box -->
            <grid:table id="grid_id_sellerList" so="${sellerSO}" resultListModel="${resultListModel}" hasExcel = "true" >
                <!-- tblh -->
                <div class="tblh">
                    <table summary="판매자 리스트"  id="table_id_sellerList">
                        <caption>판매자 리스트</caption>
                        <colgroup>
                            <col width="6%">
                            <col width="6%">
                            <col width="10%">
                            <col width="14%">
                            <col width="14%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>
                                <label for="chack05" class="chack" onclick="chack_btn(this);">
                                    <span class="ico_comm"><input type="checkbox" name="table" id="chack05" /></span>
                                </label>
                            </th>
                            <th>번호</th>
                            <th>아이디</th>
                            <th>업체명</th>
                            <th>담당자</th>
                            <th>전화번호</th>
                            <th>휴대폰</th>
                            <th>거래상태</th>
                            <th>관리자접속</th>
                            <th>상세정보</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_id_memberList">
                        <c:forEach var="sellerList" items="${resultListModel.resultList}" varStatus="status">
                            <tr data-grp-cd="${sellerList.sellerId}">
		                     	<td>
		                     		<label for="chack0" + "${sellerList.rownum}" class="chack" >
		                     			<span class="ico_comm">
		                     				<input type="checkbox" name="table" id="chack0" + "${sellerList.rownum}" class="blind" value="${sellerList.sellerNo}">
		                     			</span>
		                        	</label> 
		                        </td>
                                <td>${sellerList.rownum}</a></td>
                                <td>${sellerList.sellerId}</td>
                                <td>${sellerList.sellerNm}</td>
                                <td>${sellerList.managerNm}</td>
                                <td>${sellerList.managerTelno}</td>
                                <td>${sellerList.managerMobileNo}</td>
                                <td>${sellerList.statusNm}</td>
                                <td>
                                    <div class="pop_btn">
                                        <a href="#none" class="btn_gray" onclick="">JOIN</a>
                                    </div>
                                </td>
                                <td>
                                    <div class="pop_btn">
                                        <a href="#none" class="btn_blue" onclick="viewSellerInfoDtl('${sellerList.sellerNo}');">상세정보</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${fn:length(resultListModel.resultList)==0}">
                            <tr>
                                <td colspan="11">검색된 데이터가 존재하지 않습니다.</td>
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
                            <a href="#none" class="btn_blue3" id="btn_id_approve">거래중</a>
                            <a href="#none" class="btn_gray2" id="btn_id_suspend">거래정지</a>
                        </div>
                    </div>
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
