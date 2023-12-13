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
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 가상계좌 입금관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        jQuery(document).ready(function() {
            // 정렬순서 변경 변경시 이벤트
            jQuery('#sel_sord').on('change', function(e) {
                jQuery('#hd_srod').val($(this).val());
                $(getList);
            });
            // 표시갯수 변경 변경시 이벤트
            jQuery('#sel_rows').on('change', function(e) {
                $('#search_id_page').val(1);
                jQuery('#hd_rows').val($(this).val());
                $(getList);
            });
            
            jQuery('#ord_search_btn').on('click', function(e) {
                $('#search_id_page').val(1);
                $(getList);
            });
            
            jQuery('#excelDown').on('click', function(){
                jQuery('#form_ord_search').attr('action', '/admin/order/deposit/deposit-excel-download');
                jQuery('#form_ord_search').submit();
            });  

         // 검색일자 기본값 선택
            <c:if test="${depositSO.searchDayS eq null}">
            jQuery('#btn_srch_cal_1').trigger('click');
            </c:if>
            $(getList);
            
          //엔터키 입력시 검색 기능
            Dmall.FormUtil.setEnterSearch('form_ord_search', getList);
        });
        
        var getList = function() {
            
            var url = '/admin/order/deposit/vaccount-list',
            param = jQuery('#form_ord_search').serialize(),
            dfd = jQuery.Deferred();

            Dmall.AjaxUtil.getJSON(url, param, function(result) {

                var template1 = '<tr>'+
                '<td><a href="javascript:goOrdDtl(\'{{ordNo}}\')" class="tbl_link">{{ordNo}}</a></td>' +
                '<td>{{bankNm}}</td>' +
                '<td>{{actNo}}</td>' +
                '<td>{{ordrNm}}</td>' +
                '<td>{{dpsterNm}}</td>' ;
                
                var template2 = '<td>{{paymentAmt}}</td>' ;
                var template3 = 
                '<td>{{ordStatusNm}}</td>' +
                '<td>{{paymentCmpltDttm}}</td>' +
                '</tr>' ;
    
                managerTemplate1 = new Dmall.Template(template1),
                managerTemplate2 = new Dmall.TemplateNoFormat(template2),
                managerTemplate3 = new Dmall.Template(template3),
                tr = '';
                
                jQuery.each(result.resultList, function(idx, obj) {
                    tr += managerTemplate1.render(obj);
                    tr += managerTemplate2.render(obj);
                    tr += managerTemplate3.render(obj);
                });
    
                if(tr == '') {
                    tr = '<tr><td colspan="8"><spring:message code="biz.exception.common.nodata"/></td></tr>';
                }
                jQuery('#ajaxOrdList').html(tr);
                dfd.resolve(result.resultList);
                // 검색결과 갯수 처리
                var cnt_search = result["filterdRows"],
                    cnt_search = null == cnt_search ? 0 : cnt_search;
                $("#cnt_search").html(cnt_search);
                // 총 갯수 처리
                var cnt_total = result["totalRows"],
    
                cnt_total = null == cnt_total ? 0 : cnt_total;
                $("#cnt_total").html(cnt_total);
                Dmall.GridUtil.appendPaging('form_ord_search', 'div_paging', result, 'paging_ord', getList);
                return dfd.promise();
            });
        };
        /**
         * <pre>
         * 함수명 : goOrdDtl
         * 설  명 : 주문의 상세 페이지
         * 사용법 : 
         * 작성일 : 2016. 5. 24.
         * 작성자 : dong
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 5. 24. dong - 최초 생성
         * </pre>
         */
        function goOrdDtl(ordNo) {
            $('#ordNo').val(ordNo);
            var data = {ordNo:ordNo};
            var url =  "/admin/order/manage/order-detail";
            Dmall.FormUtil.submit(url, data, "_blank");
            
        };
        </script>
        </t:putAttribute>
        <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <h2 class="tlth2">가상계좌 입금관리 </h2>
        </div>
        <!-- search_box -->
        <div class="search_box">
                <form:form id="form_ord_search" commandName="depositSO">
                    <input type="hidden" name="page" id="search_id_page" value="${depositSO.page}"/>
                    <input type="hidden" name="sord" id="hd_srod"  value="${depositSO.sord}"/>
                    <input type="hidden" name="rows" id="hd_rows"  value="${depositSO.rows}"/>
                    <input type="hidden" name="paymentWayCd" id="paymentWayCd"  value="22"/>
            <!-- search_tbl -->
            <div class="search_tbl">
                <table summary="이표는 가상계좌 입금 관리 검색 표 입니다. 구성은 주문일, 주문상태, 판매채널, 검색어 입니다.">
                    <caption>출고(배송)관리 검색</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>주문일</th>
                            <td>
                                <tags:calendar from="searchDayS" to="searchDayE" fromValue="${depositSO.searchDayS}" toValue="${depositSO.searchDayE}" hasTotal="true" idPrefix="srch" />
                            </td>
                        </tr>
                        <tr>
                            <th>검색어</th>
                            <td>
                                <div class="select_inp">
                                    <span>
                                        <label for="searchCd"></label>
                                        <select id="radio_id_searchCd" name="searchCd">
                                            <tags:option codeStr="01:주문번호;02:주문자명;03:입금자명;"  value="${depositSO.searchCd}"/>
                                        </select>
                                    </span>
                                    <input type="text" id="searchWord" name="searchWord" value="${depositSO.searchWord}" />
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            </form:form>
            <!-- //search_tbl -->
            <div class="btn_box txtc">
                <button class="btn green" id="ord_search_btn">검색</button>
            </div>
        </div>
        <!-- //search_box -->
        <!-- line_box -->
        <div class="line_box">
            <div class="top_lay">
                <div class="search_txt">
                    검색 <strong class="be" id="cnt_search">0</strong>개 /
                    총 <strong class="all" id="cnt_total">0</strong>개
                </div>
                <div class="select_btn">
                    <span class="select">
                        <label for="sel_sord"></label>
                        <select name="sord" id="sel_sord">
                            <tags:option codeStr="A.REG_DTTM DESC:최근 등록일 순;A.REG_DTTM ASC:나중 등록일 순;A.UPD_DTTM DESC:최근 수정일 순;A.UPD_DTTM ASC:나중 수정일 순" />
                        </select>
                    </span>
                    <span class="select">
                        <label for="sel_rows"></label>
                        <select name="rows" id="sel_rows">
                            <tags:option codeStr="10:10개 출력;30:30개 출력;50:50개 출력"  value="${depositSO.rows}"/>
                        </select>
                    </span>
                    <button class="btn_exl" id="excelDown">Excel download <span class="ico_comm">&nbsp;</span></button>
                </div>
            </div>
            <!-- tblh -->
            <div class="tblh ">
                <table summary="이표는 주문 관리 리스트 표 입니다. 구성은 선택, 번호, 주문일시, 환경, 주문번호, 주문상품, 판매채녈, 수신자/주문자, 결제수단, 결제금액, 결제일시, 주문상태 입니다.">
                    <caption>주문 관리 리스트</caption>
                    <colgroup>
                        <col width="12%">
                        <col width="12%">
                        <col width="14%">
                        <col width="12%">
                        <col width="12%">
                        <col width="12%">
                        <col width="12%">
                        <col width="14%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>은행명</th>
                            <th>가상계좌번호</th>
                            <th>주문자</th>
                            <th>입금자</th>
                            <th>입금액</th>
                            <th>주문상태</th>
                            <th>입금완료일</th>
                        </tr>
                    </thead>
                    <tbody id = "ajaxOrdList">
                    </tbody>
                </table>
            </div>
            <!-- //tblh -->
            <!-- bottom_lay -->
            <div class="bottom_lay">
                <div class="bottom_lay" id="div_paging"></div>
            </div>
            <!-- //bottom_lay -->
        </div>
        <!-- //line_box -->
    </div>
<!-- //content -->
    </t:putAttribute>
</t:insertDefinition>