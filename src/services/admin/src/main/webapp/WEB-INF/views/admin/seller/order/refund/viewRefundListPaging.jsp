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
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 환불관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">

        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                ordRefundPopup.init();

                // 검색일자 기본값 선택
                <c:if test="${claimSO.refundDayS eq null}">
                $('#btn_srch_cal_1').trigger('click');
                </c:if>
                $(getList);

                // 검색
                $('#ord_search_btn').on('click', function(e) {
                    $('#search_id_page').val('1');
                    $(getList);
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_ord_search', getList);
                //에디터
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('refundDtlReason'); // claimDtlReason 를 ID로 가지는 Textarea를 에디터로 설정

                // 엑셀다운로드
                $('#btn_download').on('click', function(){
                    $('#form_ord_search').attr('action', '/admin/seller/order/refund-excel-download');
                    $('#form_ord_search').submit();
                });
            });

            var getList = function() {
                var url = '/admin/seller/order/refund-list',
                param = $('#form_ord_search').serialize(),
                dfd = jQuery.Deferred();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var template =
                        '<tr>' +
                        '<td>{{rownum}}</td>' +
                        '<td>{{returnNm}} / {{claimNm}}</td>' +
                        '<td>{{claimAcceptDttm}}</td>' +
                        '<td>{{claimCmpltDttm}}</td>' +
                        '<td>{{ordNo}}</td>' +
                        '<td>{{claimNo}}</td>' +
                        '<td>{{paymentWayNm}}</td>' +
                        '<td>{{ordrNm}}</td>' +
                        '<td>{{saleAmt}}<br>{{supplyAmt}}</td>' +
                        '<td>{{ordQtt}}</td>' +
                        '<td></td>' +
                        '<td><button class="btn_gray" onClick="javascript:getClaimList(\'{{ordNo}}\',\'{{claimCd}}\',\'V\')">보기</button></td>' +
                        '</tr>',
                        managerTemplate = new Dmall.Template(template),
                        tr = '';

                    jQuery.each(result.resultList, function(idx, obj) {
                        tr += managerTemplate.render(obj);
                    });

                    if(tr == '') {
                        tr = '<tr><td colspan="12">데이터가 없습니다.</td></tr>'
                    }

                    $('#ajaxOrdList').html(tr);

                    dfd.resolve(result.resultList);

                    $("#cnt_total").text(result.filterdRows);

                    Dmall.GridUtil.appendPaging('form_ord_search', 'div_paging', result, 'paging_ord', getList);
                });
                return dfd.promise();
            };

            var getClaimList = function(ordNo, claimCd, refundType) {

                if(claimCd=='11'||claimCd=='12'){
                    //환불취소 (반품)
                    ordRefundPopup.btnRefundClick(ordNo, 1, refundType);
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
            <h2 class="tlth2">환불 관리</h2>
        </div>
        <div class="search_box_wrap">
            <div class="search_box">
                <form:form id="form_ord_search" commandName="claimSO">
                    <input type="hidden" name="page" id="search_id_page" value="${claimSO.page}"/>
                    <input type="hidden" name="sord" id="hd_srod"  value="${claimSO.sord}"/>
                    <input type="hidden" name="rows" id="hd_rows"  value="${claimSO.rows}"/>
                    <input type="hidden" name="cancelSearchType" id="cancelSearchType"  value="01"/>
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 반품/환불관리 검색 표 입니다. 구성은 반품신청일, 상태, 검색어 입니다.">
                            <caption>반품/환불관리 검색</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>반품 신청일</th>
                                <td>
                                    <input type="hidden" name="dayTypeCd" id="dayTypeCd" value="01">
                                    <tags:calendar from="refundDayS" to="refundDayE" fromValue="${refundSO.refundDayS}" toValue="${refundSO.refundDayE}" hasTotal="true" idPrefix="srch" />
                                </td>
                            </tr>
                            <tr>
                                <th>상태</th>
                                <td>
                                    <a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>

                                    <label for="chack03_3" class="chack mr20">
                                        <span class="ico_comm">
                                            <input type="checkbox" name="returnCd" id="chack03_3" class="blind"  value='11'/>
                                        </span>
                                        반품신청
                                    </label>
                                    <label for="chack03_1" class="chack mr20">
                                        <span class="ico_comm">
                                        <input type="checkbox" name="claimCd" id="chack03_1" class="blind"  value='11'/>
                                        </span>
                                        환불신청
                                    </label>
                                    <label for="chack03_2" class="chack mr20">
                                        <span class="ico_comm">
                                        <input type="checkbox" name="returnCd" id="chack03_2" class="blind"  value='12'/>
                                        </span>
                                        반품완료
                                    </label>
                                    <label for="chack03_4" class="chack mr20">
                                        <span class="ico_comm">
                                        <input type="checkbox" name="claimCd" id="chack03_4" class="blind"  value='12'/>
                                        </span>
                                        환불완료
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th>검색어</th>
                                <td>
                                    <span class="select">
                                        <label for="radio_id_searchCd"></label>
                                        <select id="radio_id_searchCd" name="searchCd">
                                            <tags:option codeStr=":전체;01:반품번호;02:주문번호;03:아이디;05:주문자;06:수령자;07:상품명;08:상품코드;"  value="${claimSO.searchCd}"/>
                                        </select>
                                        <span class="intxt long">
                                            <input type="text" id="searchWord" name="searchWord" value="${claimSO.searchWord}" />
                                        </span>
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
                    <span class="search_txt">
                        총 <strong class="be" id="cnt_total">0</strong>개의 반품 신청이 검색되었습니다.
                    </span>
                    </div>
                    <div class="select_btn_right">
                        <button class="btn_exl" id="btn_download">
                            <span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                        </button>
                    </div>
                </div>
                <!-- tblh -->
                <div class="tblh ">
                    <table summary="이표는 반품/교환관리 리스트 표 입니다. 구성은 삭제, 번호, 반품접수일시, 주문번호, 반품코드, 주문자, 결제, 주문수량, 반품수량, 처리자, 수거완료시, 처리상태(반품,교환) 입니다.">
                        <caption>반품/교환관리 리스트</caption>
                        <colgroup>
                            <col width="5%">
                            <col width="8%">
                            <col width="10%">
                            <col width="10%">
                            <col width="12%">
                            <col width="10%">
                            <col width="7%">
                            <col width="8%">
                            <col width="8%">
                            <col width="5%">
                            <col width="8%">
                            <col width="8%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>처리상태</th>
                            <th>반품접수일시</th>
                            <th>수거일시</th>
                            <th>주문번호</th>
                            <th>반품번호</th>
                            <th>결제</th>
                            <th>주문자</th>
                            <th>판매가<br>공급가</th>
                            <th>주문수량</th>
                            <th>처리자</th>
                            <th>반품사유</th>
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
    </t:putAttribute>
</t:insertDefinition>
<c:set var="refundType" value="V"/>
<%@ include file="/WEB-INF/include/popup/ordRefundPopup.jsp" %>

