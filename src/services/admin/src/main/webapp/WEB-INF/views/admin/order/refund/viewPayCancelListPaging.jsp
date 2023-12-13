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
<c:set var="strClaimCd" value="${fn:join(claimSO.claimCd, ',')}"/>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 결제취소관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        jQuery(document).ready(function() {
            ordPayCancelPopup.init();
            ordExchangePopup.init();
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
                jQuery('#form_ord_search').attr('action', '/admin/order/refund/refund-excel-download');
                jQuery('#form_ord_search').submit();
            });  

         // 검색일자 기본값 선택
            <c:if test="${claimSO.refundDayS eq null}">
            jQuery('#btn_srch_cal_1').trigger('click');
            </c:if>
            $(getList);
          //엔터키 입력시 검색 기능
            Dmall.FormUtil.setEnterSearch('form_ord_search', getList);
        });
        
        var getList = function() {
            var url = '/admin/order/refund/refund-list',
            param = jQuery('#form_ord_search').serialize(),
            dfd = jQuery.Deferred();

            Dmall.AjaxUtil.getJSON(url, param, function(result) {


                var template1 = '<tr>'+
                '<td>{{rownum}}</td>' +
                '<td>{{claimNm}}</td>' +
                '<td>{{claimAcceptDttm}}</td>' +
                '<td>{{ordNo}}</td>' +
                /*'<td><a href="javascript:getClaimList(\'{{ordNo}}\',\'{{claimCd}}\',\'M\')"  class="tbl_link">{{claimNo}}</a></td>' +*/
                '<td>{{claimNo}}</td>' +
                '<td>{{paymentWayNm}}</td>' +

                '<td>{{ordrNm}}<br>({{loginId}}/{{memberGradeNm}})</td>' +
                '<td>{{saleAmt}}<br>{{supplyAmt}}</td>' +
                '<td>{{ordQtt}}</td>' +
                '<td>{{regrNm}}</td>' +

                '<td><button class="btn_gray" onClick="javascript:getClaimList(\'{{ordNo}}\',\'{{claimCd}}\',\'V\')">보기</button></td>' +
                '</tr>' ;
    
                managerTemplate1 = new Dmall.Template(template1),
                tr = '';
                
                jQuery.each(result.resultList, function(idx, obj) {
                    tr += managerTemplate1.render(obj);
                });
    
                if(tr == '') {
                    tr = '<tr><td colspan="12"><spring:message code="biz.exception.common.nodata"/></td></tr>';
                }else{
                	tr = tr.replace("<br>(/)","<br>(비회원)");
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
        
        var getClaimList = function(ordNo, claimCd, viewType) {
            /*Dmall.LayerPopupUtil.open($('#layout_payCancel'));
            return;*/

            if(claimCd=='31'||claimCd=='32'){
                if(viewType=='M'){
                    //결제취소 수정 모드
                    ordExchangePopup.btnExchangeClick(ordNo, 3);
                }else {
                    //결제취소 view 모드 
                    ordPayCancelPopup.btnPayCancelClick(ordNo, 4);
                }
            }else {
                alert("신청전입니다.");
            }
        }
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
                <div class="tlt_head">
                    주문 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">결제 취소 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form id="form_ord_search" commandName="claimSO">
                        <input type="hidden" name="page" id="search_id_page" value="${claimSO.page}"/>
                        <input type="hidden" name="sord" id="hd_srod"  value="${claimSO.sord}"/>
                        <input type="hidden" name="rows" id="hd_rows"  value="${claimSO.rows}"/>
                        <input type="hidden" name="cancelSearchType" id="cancelSearchType"  value="02"/>
                        <input type="hidden" name="dayTypeCd" value="01"/>
                        <div class="search_tbl">
                            <table summary="이표는 반품/환불관리 검색 표 입니다. 구성은 반품신청일, 상태, 검색어 입니다.">
                                <caption>반품/환불관리 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>취소신청일</th>
                                    <td>
                                        <tags:calendar from="refundDayS" to="refundDayE" fromValue="${refundSO.refundDayS}" toValue="${refundSO.refundDayE}" hasTotal="true" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                        <label for="chack03_5" class="chack mr20 <c:if test="${fn:contains(strClaimCd, '31')}">on</c:if>" onclick="chack_btn(this);">
                                        <span class="ico_comm">
                                        <input type="checkbox" name="claimCd" id="chack03_5" class="blind"  value='31' <c:if test="${fn:contains(strClaimCd, '31')}">checked</c:if>/>
                                        </span>
                                            결제취소신청
                                        </label>
                                        <label for="chack03_6" class="chack mr20 <c:if test="${fn:contains(strClaimCd, '32')}">on</c:if>" onclick="chack_btn(this);">
                                        <span class="ico_comm">
                                        <input type="checkbox" name="claimCd" id="chack03_6" class="blind"  value='32' <c:if test="${fn:contains(strClaimCd, '32')}">checked</c:if>/>
                                        </span>
                                            결제취소완료
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매자</th>
                                    <td>
                                        <span class="select">
                                            <label for="sel_seller"></label>
                                            <select name="searchSeller" id="sel_seller">
                                                <code:sellerOption siteno="${siteNo}" includeTotal="true"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="select">
                                            <label for="searchCd"></label>
                                            <select id="radio_id_searchCd" name="searchCd">
                                                <tags:option codeStr="01:결제취소번호;02:주문번호;03:아이디;04:회원명;05:주문자명;06:수령자명;07:상품명;08:상품코드;"  value="${claimSO.searchCd}"/>
                                            </select>
                                        </span>
                                        <span class="intxt long">
                                            <input type="text" id="searchWord" name="searchWord" value="${claimSO.searchWord}" />
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </form:form>
                    <div class="btn_box txtc">
                        <button class="btn green" id="ord_search_btn">검색</button>
                    </div>
                </div>

                <div class="line_box">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <div class="search_txt">
                                총 <strong class="be" id="cnt_search">0</strong>개의 상품이 검색되었습니다.
                            </div>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="excelDown">
                                <span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <div class="tblh ">
                        <table summary="이표는 반품/교환관리 리스트 표 입니다. 구성은 삭제, 번호, 반품접수일시, 주문번호, 반품코드, 주문자, 결제, 주문수량, 반품교환 수량, 처리자, 수거완료시, 처리상태(반품,교환) 입니다.">
                            <caption>반품/교환관리 리스트</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="10%">
                                <col width="12%">
                                <col width="12%">
                                <col width="9%">
                                <col width="9%">
                                <col width="10%">
                                <col width="10%">
                                <col width="5%">
                                <col width="10%">
                                <col width="8%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>처리상태</th>
                                <th>취소접수일시</th>
                                <th>주문번호</th>
                                <th>결제취소번호</th>
                                <th>결제</th>
                                <th>주문자</th>
                                <th>판매가<br>공급가</th>
                                <th>주문수량</th>
                                <th>처리자</th>
                                <th>취소사유</th>
                            </tr>
                            </thead>
                            <tbody id = "ajaxOrdList">
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <div class="pageing mt10" id="div_paging"></div>
                    </div>
                </div>
            </div>
        </div>

        <%--<%@ include file="/WEB-INF/include/popup/ordPayCancelPopup.jsp" %>--%>
    </t:putAttribute>
</t:insertDefinition>
<%--<c:set var="refundType" value="M"/>--%>
<%--<%@ include file="/WEB-INF/include/popup/ordPayCancelPopup.jsp" %>--%>
<c:set var="refundType" value="V"/>
<%@ include file="/WEB-INF/include/popup/ordPayCancelViewPopup.jsp" %>