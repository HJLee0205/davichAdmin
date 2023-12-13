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
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 교환관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
        jQuery(document).ready(function() {

            ordExchangePopup.init();
            // 정렬순서 변경 변경시 이벤트
            jQuery('#sel_sord').on('change', function(e) {
                jQuery('#hd_srod').val($(this).val());
                $(getList);
            });
            // 표시갯수 변경 변경시 이벤트
            jQuery('#sel_rows').on('change', function(e) {
                jQuery('#hd_page').val('1');
                jQuery('#hd_rows').val($(this).val());
                $(getList);
            });

            jQuery('#ord_search_btn').on('click', function(e) {
                $(getList);
            });
            // 보기창 닫기
            jQuery('#btn_exchange_close').on('click', function(e) {
                Dmall.LayerPopupUtil.close('layout_exchange2');
                $("#tbody_exchange_data1").find(".searchExchangeResult").each(function() {
                    $(this).remove();
                });
                $("#tbody_exchange_data2").find(".searchExchangeResult").each(function() {
                    $(this).remove();
                });
                jQuery("#tr_exchange_data_template1").hide();
                jQuery("#tr_exchange_data_template2").hide();
            });

            jQuery('#excelDown').on('click', function(){
                jQuery('#form_ord_search').attr('action', '/admin/order/exchange/exchange-excel-download');
                jQuery('#form_ord_search').submit();
            });
         // 검색일자 기본값 선택
            <c:if test="${claimSO.refundDayS eq null}">
            jQuery('#btn_srch_cal_1').trigger('click');
            </c:if>
            $(getList);

            //에디터
            Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
            Dmall.DaumEditor.create('claimDtlReason'); // claimDtlReason 를 ID로 가지는 Textarea를 에디터로 설정
        });
        var getExchangeList = function(ordNo, ordDtlStatusCd) {
            ordExchangePopup.btnExchangeClick(ordNo, 2, ordDtlStatusCd);
        }
        function fn_loadEditor(value) {
            var siteinfocd = $("#hid_siteInfoCd").val();

            Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
            Dmall.DaumEditor.create('claimDtlReason_vw'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

            var content = value;
            if(content != null){
            	Dmall.DaumEditor.setContent('claimDtlReason_vw', content); // 에디터에 데이터 세팅
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
            var url =  "/admin/seller/order/order-detail";
            Dmall.FormUtil.submit(url, data, "_blank");

        };
        var getList = function() {

            var url = '/admin/seller/order/exchange-list',
            param = jQuery('#form_ord_search').serialize(),
            dfd = jQuery.Deferred();

            Dmall.AjaxUtil.getJSON(url, param, function(result) {

                var template1 = '<tr>'+
                '<td>{{rownum}}</td>' +
                '<td>{{claimAcceptDttm}}</td>' +
                '<td><a href="javascript:goOrdDtl(\'{{ordNo}}\')" class="tbl_link">{{ordNo}}</a></td>' ,

                template2 = '<td><a href="javascript:getExchangeList(\'{{ordNo}}\', \'{{ordDtlStatusCd}}\')"  class="tbl_link">{{claimNo}}</a></td>' +
                            '<td>{{sellerNm}}</td>' ,
                template3 = '<td>{{ordrNm}}<br>({{loginId}}/{{memberGradeNm}})</td>' +
                '<td>{{paymentWayNm}}</td>' +
                '<td>{{ordQtt}}</td>' +
                '<td>{{ordQtt}}</td>' +
                '<td>{{regrNm}}</td>' +
                '<td>{{returnNm}}</td>' +
                '<td>{{claimNm}}</td>' +
                '<td><a href="javascript:getClaimList(\'{{ordNo}}\',\'{{claimCd}}\',\'V\',\'{{ordDtlStatusCd}}\')" class="btn_gray2">정보</a></td>' +
                '</tr>' ;

                managerTemplate1 = new Dmall.Template(template1),
                managerTemplate2 = new Dmall.Template(template2),
                managerTemplate3 = new Dmall.Template(template3),
                tr = '';

                jQuery.each(result.resultList, function(idx, obj) {
                    tr += managerTemplate1.render(obj);
                    if(obj.saleChannelCd == 'shop9999')
                        tr += managerTemplate2.render(obj);
                    else
                        tr += '<td></td>';
                    tr += managerTemplate3.render(obj);
                });

                if(tr == '') {
                    tr = '<tr><td colspan="14"><spring:message code="biz.exception.common.nodata"/></td></tr>';
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

        var getClaimList = function(ordNo, claimCd, refundType,curOrdStatusCd) {

            if(claimCd=='21'||claimCd=='22'){
                ordExchangePopup.btnExchangeClick(ordNo, 2, curOrdStatusCd, refundType);
            }else {
                alert("신청전입니다.");
            }
        }

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <div class="tlt_head">
                주문 설정<span class="step_bar"></span>
            </div>
            <h2 class="tlth2">교환관리 </h2>
        </div>
        <div class="search_box_wrap">
            <div class="search_box">
                <form:form id="form_ord_search" commandName="claimSO">
                    <input type="hidden" name="page" id="search_id_page" value="${claimSO.page}"/>
                    <input type="hidden" name="sord" id="hd_srod"  value="${claimSO.sord}"/>
                    <input type="hidden" name="rows" id="hd_rows"  value="${claimSO.rows}"/>

                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 반품/환불관리 검색 표 입니다. 구성은 반품신청일, 상태, 검색어 입니다.">
                            <caption>반품/교환관리 검색</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>반품 신청일</th>
                                <td>
                                        <input type="hidden" name="dayTypeCd" value="01"/>
                                        <tags:calendar from="refundDayS" to="refundDayE" fromValue="${claimSO.refundDayS}" toValue="${claimSO.refundDayE}" idPrefix="srch"/>
                                </td>
                            </tr>
                            <tr>
                                <th>반품 상태</th>
                                <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>

                                        <label for="chack03_1" class="chack mr20 <c:if test="${fn:contains(strReturnCd, '11')}">on</c:if>">
                                        <span class="ico_comm">
                                        <input type="checkbox" name="returnCd" id="chack03_1" class="blind" value='11' <c:if test="${fn:contains(strReturnCd, '11')}">checked</c:if>/>
                                        </span>
                                            반품신청
                                        </label>
                                        <label for="chack03_2" class="chack mr20 <c:if test="${fn:contains(strReturnCd, '12')}">on</c:if>">
                                        <span class="ico_comm">
                                        <input type="checkbox" name="returnCd" id="chack03_2" class="blind" value='12' <c:if test="${fn:contains(strReturnCd, '12')}">checked</c:if>/>
                                        </span>
                                            반품완료
                                        </label>
                                        <label for="chack03_2" class="chack mr20 <c:if test="${fn:contains(strReturnCd, '13')}">on</c:if>">
                                        <span class="ico_comm">
                                        <input type="checkbox" name="returnCd" id="chack03_3" class="blind" value='13' <c:if test="${fn:contains(strReturnCd, '13')}">checked</c:if>/>
                                        </span>
                                            요청철회
                                        </label>
                                </td>
                            </tr>
                            <tr>
                                <th>교환 상태</th>
                                <td>
                                        <label for="chack04_1" class="radio mr20">
                                        <span class="ico_comm">
                                        <input type="radio" name="returnCd" id="chack04_1" class="blind" value=''/>
                                        </span>
                                            전체
                                        </label>
                                        <label for="chack04_2" class="radio mr20 <c:if test="${fn:contains(strClaimCd, '21')}">on</c:if>">
                                        <span class="ico_comm">
                                        <input type="radio" name="claimCd" id="chack04_2" class="blind" value='21' <c:if test="${fn:contains(strClaimCd, '11')}">checked</c:if>/>
                                        </span>
                                            교환신청
                                        </label>
                                        <label for="chack04_4" class="radio mr20 <c:if test="${fn:contains(strClaimCd, '22')}">on</c:if>">
                                        <span class="ico_comm">
                                        <input type="radio" name="claimCd" id="chack04_4" class="blind" value='22' <c:if test="${fn:contains(strClaimCd, '12')}">checked</c:if>/>
                                        </span>
                                            교환완료
                                        </label>
                                </td>
                            </tr>
                            <tr>
                                <th>검색어</th>
                                <td>
                                    <span class="select">
                                        <label for="searchCd"></label>
                                        <select id="searchCd" name="searchCd">
                                            <tags:option codeStr="01:반품코드;02:주문번호;03:아이디;04:회원명;05:주문자명;06:수령자명;07:상품명;08:상품코드;"  value="${claimSO.searchCd}"/>
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
                <!-- //search_tbl -->
                <div class="btn_box txtc">
                    <button class="btn green" id="ord_search_btn">검색</button>
                </div>
            </div>
            <div class="line_box">
                <div class="top_lay">
                    <div class="select_btn_left">
                        <span class="searh_txt">
                            총 <strong class="all" id="cnt_search"></strong>개의 교환 신청이 검색되었습니다.
                        </span>
                    </div>
                    <div class="select_btn_right">
                        <button class="btn_exl" id="excelDown">
                            <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                        </button>
                    </div>
                </div>
                <!-- tblh -->
                <div class="tblh ">
                        <%--<div class="scroll">--%>
                    <table summary="이표는 반품/교환관리 리스트 표 입니다. 구성은 삭제, 번호, 반품접수일시, 주문번호, 반품코드, 주문자, 결제, 주문수량, 반품교환 수량, 처리자, 수거완료시, 처리상태(반품,교환) 입니다.">
                        <caption>반품/교환관리 리스트</caption>
                        <colgroup>
                            <col width="5%">
                            <col width="10%">
                            <col width="11%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="5%">
                            <col width="5%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th rowspan="2">번호</th>
                            <th rowspan="2">반품접수일시</th>
                            <th rowspan="2">주문번호</th>
                            <th rowspan="2">반품번호</th>
                            <th rowspan="2">판매자</th>
                            <th rowspan="2">주문자</th>
                            <th rowspan="2">결제</th>
                            <th rowspan="2">주문수량</th>
                            <th rowspan="2">교환수량</th>
                            <th rowspan="2">처리자</th>
                            <th colspan="2" class="blno" style="border-bottom: 1px solid #e5e5e5;">처리상태</th>
                            <th rowspan="2">교환사유</th>
                        </tr>
                        <tr>
                            <th>반품</th>
                            <th style="border-right: 1px solid #e5e5e5;">교환</th>
                        </tr>
                        </thead>
                        <tbody id="ajaxOrdList">
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <div class="pageing mt10" id="div_paging"></div>
                </div>
                <!-- //bottom_lay -->
            </div>
        </div>
    </div>

<!-- //content -->
    </t:putAttribute>
</t:insertDefinition>
<c:set var="exchangeType" value="V"/>
<%@ include file="/WEB-INF/views/admin/seller/include/popup/ordExchangePopup.jsp" %>