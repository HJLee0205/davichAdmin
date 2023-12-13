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
    <t:putAttribute name="title">주문 관리 > 주문</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                varOrd.getOrdList();

                // 검색
                $('#ord_search_btn').on('click', function() {
                    $('#hd_page').val('1');
                    varOrd.getOrdList();
                });

                // 엑셀다운로드
                $('#btn_download').on('click', function() {
                    $('#form_ord_search').attr('action', '/admin/order/manage/searchorder-excel-download');
                    $('#form_ord_search').submit();
                    $('#form_ord_search').attr('action', '');
                });
		
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_ord_search', varOrd.getOrdList);

                // 매장 픽업 관련 UI 처리
                $('#span_3').css('width', 125);
                $('#span_3').html('배송준비중/상품준비중');
                $('#span_5').css('width', 120);
                $('#span_5').html('배송완료/픽업가능');
                $('#span_6').css('width', 120);
                $('#span_6').html('구매확정/픽업완료');

                //주문상태변경 layer
                $("button[name=btn_chg_status]").on('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();

                    console.log($(this).text());
                    var layout = $('#layout_status'),
                        html = "",
                        chk = $('#ajaxOrdList').find('.chack.on'),
                        sel_status = '';
                    // console.log($('#ajaxOrdList').find('.chack.on'));
                    if (chk.length < 1) {
                        Dmall.LayerUtil.alert('선택된 주문이 없습니다.');
                        return;
                    }

                    // 입금대기중체크
                    //var depositChk = 0;
                    var payCompChk = 0;
                    var dlvrChk = 0;
                    var buyCompChk = 0;
                    var readyDlvrChk = 0;
                    chk.each(function () {
                        var curOrdStatusCd = $(this).siblings('[name=curOrdStatusCd]').val();
                        if (curOrdStatusCd == "20") {
                            payCompChk++;
                        }
                        if (curOrdStatusCd == "40") {
                            dlvrChk++;
                        }
                        if (curOrdStatusCd == "50") {
                            buyCompChk++;
                        }
                        if (curOrdStatusCd == "30") {
                            readyDlvrChk++;
                        }
                    });

                    if (chk.length == payCompChk && $(this).text() == '주문확정') {
                        // sel_status += '<option value="00">주문무효</option>';
                        sel_status = '<input type="hidden" id="tgtOrdStatusCd" value="30">주문확정';
                    } else if (chk.length == readyDlvrChk && $(this).text() == '결제완료') {
                        // sel_status += '<option value="">선택</option>';
                        sel_status = '<input type="hidden" id="tgtOrdStatusCd" value="20">결제완료';
                    } else if (chk.length == dlvrChk && $(this).text() == '배송완료 / 픽업가능') {
                        // sel_status += '<option value="">선택</option>';
                        sel_status = '<input type="hidden" id="tgtOrdStatusCd" value="50">배송완료';
                    } else if (chk.length == buyCompChk && $(this).text() == '구매확정 / 픽업완료') {
                        // sel_status += '<option value="">선택</option>';
                        sel_status = '<input type="hidden" id="tgtOrdStatusCd" value="90">구매확정';
                    } else {
                        Dmall.LayerUtil.alert("상태값이 동일한 주문건만 선택해 주세요. <br/>('결제완료' 또는 '배송준비중/상품준비중', '배송완료/픽업가능' 상태인 주문건만 일괄처리 가능)");
                        return;
                    }

                    /*sel_status += '</select>';
                    sel_status += '</span>';*/

                    html += '<tr>' +
                            '    <th>선택된주문수</th>' +
                            '    <td>' + chk.length + '건</td>' +
                            '</tr>' +
                            '<tr>' +
                            '    <th>주문상태</th>' +
                            '    <td>' + sel_status + '</td>' +
                            '</tr>';

                    layout.find('tbody').html(html);

                    Dmall.LayerPopupUtil.open(jQuery('#layout_status'));

                });

                //주문상태 변경
                $("#btn_status_change").on('click', function () {
                    var chk = $('#ajaxOrdList').find('.chack.on'),
                        tgtOrdStatusCd = $('#tgtOrdStatusCd').val();

                    var curOrdStatusCd = "";
                    var curOrdDtlSeq = "";

                    var msg = '';
                    console.log("btn_status_change tgtOrdStatusCd = ", $('#tgtOrdStatusCd').val());
                    /*if ($('#tgtOrdStatusCd').val() == '10')
                        msg = '선택된 주문을 입금확인중으로 변경 하시겠습니까?';
                    else */if (tgtOrdStatusCd == '90')
                        msg = '선택된 주문을 구매확정(픽업완료) 하시겠습니까?';
                    else if (tgtOrdStatusCd == '50')
                        msg = '선택된 주문을 배송완료(픽업가능)처리 하시겠습니까?';
                    else if (tgtOrdStatusCd == '30')
                        msg = '선택된 주문을 주문확정(배송준비중/상품준비중) 으로 변경 하시겠습니까?';
                    else if (tgtOrdStatusCd == '20')
                        msg = '선택된 주문을 결제완료로 변경 하시겠습니까?';
                    /*if (tgtOrdStatusCd == '') {
                        Dmall.LayerUtil.alert('변경할 주문상태를 선택하세요.');
                        return false;
                    }*/


                    chk.each(function (idx) {
                        if (idx == 0) {
                            curOrdStatusCd += $(this).siblings('[name=curOrdStatusCd]').val();
                            curOrdDtlSeq += $(this).siblings('[name=curOrdDtlSeq]').val();
                        } else {
                            curOrdStatusCd += ',' + $(this).siblings('[name=curOrdStatusCd]').val();
                            curOrdDtlSeq += ',' + $(this).siblings('[name=curOrdDtlSeq]').val();
                        }
                    });
                    console.log("curOrdStatusCd ", curOrdStatusCd);
                    console.log("curOrdDtlSeq ", curOrdDtlSeq);
                    Dmall.LayerUtil.confirm(msg, function () {
                        chgOrdStatus(tgtOrdStatusCd, curOrdStatusCd, curOrdDtlSeq, '')
                    });


                    Dmall.LayerPopupUtil.close('layout_status');

                });

                $('label.radio', $("#td_searchDlvrcPayment")).off('click').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var $this = $(this),
                        $input = jQuery("#" + $this.attr("for")),
                        $tr = $this.closest('tr').siblings('#tr_ordDtlStatus');

                    $("input:radio[name=" + $input.attr("name") + "]").each(function() {
                        $(this).removeProp('checked');
                        $("label[for=" + $(this).attr("id") + "]").removeClass('on');
                    });
                    $input.prop('checked', true).trigger('change');

                    if ($input.prop('checked')) {
                        $this.addClass('on');
                        // 라디오 선택 값에 따른 이벤트 설정
                        $tr.children('td').children('label').eq(2).children('.txt').css('width', 80);
                        $tr.children('td').children('label').eq(4).children('.txt').css('width', 80);
                        $tr.children('td').children('label').eq(5).children('.txt').css('width', 80);
                        if ('04' == $input.val()) {
                            $tr.children('td').children('label').eq(2).children('.txt').html('상품준비중')
                            $tr.children('td').children('label').eq(4).children('.txt').html('픽업가능')
                            $tr.children('td').children('label').eq(5).children('.txt').html('픽업완료')
                        } else if ('01' == $input.val()) {
                            $tr.children('td').children('label').eq(2).children('.txt').html('배송준비중')
                            $tr.children('td').children('label').eq(4).children('.txt').html('배송완료')
                            $tr.children('td').children('label').eq(5).children('.txt').html('구매확정')
                        } else {
                            $tr.children('td').children('label').eq(2).children('.txt').css('width', 125);
                            $tr.children('td').children('label').eq(2).children('.txt').html('배송준비중/상품준비중')
                            $tr.children('td').children('label').eq(4).children('.txt').css('width', 120);
                            $tr.children('td').children('label').eq(4).children('.txt').html('배송완료/픽업가능')
                            $tr.children('td').children('label').eq(5).children('.txt').css('width', 120);
                            $tr.children('td').children('label').eq(5).children('.txt').html('구매확정/픽업완료')
                        }
                    }
                });
            });

            // 주문 상세
            function goOrdDtl(ordNo) {
                //alert(jQuery('#form_delivery input[name=rlsCourierCd]').val());
                $('#ordNo').val(ordNo);
                var data = {};
                var i = 0, oldName ='', newName = [];

                $.map($("#form_ord_search").serializeArray(), function(x){
                    if(x.name =='ordDtlStatusCd' || x.name =='paymentWayCd' || x.name =='ordMediaCd' || x.name =='saleChannelCd') {
                        if(oldName =='')
                            newName = [];
                        if(oldName =='' || oldName == x.name) {
                            newName[i] = x.value;
                            i++;
                        } else {
                            if(newName.length > 0) {
                                data[oldName] = newName;
                                newName = [];
                                i=0;
                            }
                            newName[i] = x.value;
                            i++;
                        }
                        oldName = x.name;
                    } else {
                        data[x.name] = x.value;
                        if(newName.length > 0) {
                            data[oldName] = newName;
                            newName = [];
                        }
                    }
                });

                var url =  "/admin/seller/order/order-detail";
                Dmall.FormUtil.submit(url, data);
            }
            /**
             * <pre>
             * 함수명 : chgOrdStatus
             * 설  명 : 다수 주문건의 주문 상태 변경
             * 사용법 :
             * 작성일 : 2023. 7. 12.
             * 작성자 : slims
             * 수정내역(수정일 수정자 - 수정내용)
             * -------------------------------------
             * 2023. 7. 12. slims - 최초 생성
             * </pre>
             */
            function chgOrdStatus(tgtOrdStatusCd, curOrdStatusCd, curOrdDtlSeq, tgtOrdStatusNm) {
                var checkboxValues = '';
                var comma = ',';
                var mdConfirmYn = '';
                jQuery.map($('#ajaxOrdList input[name^=table_chk_]:checked'), function (x) {
                    checkboxValues = checkboxValues + x.value + comma;
                });

                if (checkboxValues == '') {
                    Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.noOrderNo"/>');
                    return;
                }
                var url = "/admin/order/manage/order-checkstatus-update";
                //슈퍼관리자일경우 MD확정(배송준비중)
                if (tgtOrdStatusCd == '30') {
                    mdConfirmYn = 'Y';
                }
                var param = {
                    ordNo: checkboxValues,
                    curOrdStatusCd: curOrdStatusCd,
                    curOrdDtlSeq: curOrdDtlSeq,
                    ordStatusCd: tgtOrdStatusCd,
                    mdConfirmYn: mdConfirmYn
                };

                console.log("parma = ", param);
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result.success) {
                        $('#hd_page').val(1);
                        $(varOrd.getOrdList);
                    }
                });
            }

            

            var varOrd = {
                getOrdList: function() {
                    var url = '/admin/seller/order/order-list',
                        param = $('#form_ord_search').serialize(),
                        dfd = jQuery.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                            '<tr>' +
                            '<td>' +
                            '   <input type="hidden" name="curOrdStatusCd" value="{{ordDtlStatusCd}}">' +
                            '   <input type="hidden" name="curOrdDtlSeq" value="{{ordDtlSeq}}">' +
                            '   <label for="table_chk_{{ordDtlStatusCd}}" class="chack" id="chk_{{ordDtlStatusCd}}">' +
                            '       <span class="ico_comm">' +

                            '           <input type="checkbox" name="table_chk_{{ordDtlStatusCd}}" id="table_chk_{{ordDtlStatusCd}}" value="{{ordNo}}" class="blind">' +
                            '       </span>' +
                            '   </label>' +
                            '</td>' +
                            '<td>{{sortNum}}</td>' +
                            '<td>{{ordDtlStatusNm}}</td>' +
                            '<td>{{ordAcceptDttm}}</td>' +
                            '<td><a href="javascript:goOrdDtl(\'{{ordNo}}\');" class="tbl_link">{{ordNo}}</a></td>' +
                            '<td>{{goodsNm}}<br>[{{goodsNo}}]</td>' +
                            '<td>{{itemNm}}</td>' +
                            '<td>{{ordrNm}}<br>{{adrsNm}}</td>' +
                            '<td><span class="comma">{{saleAmt}}</span><br><span class="comma">{{supplyAmt}}</span></td>' +
                            '<td>{{ordQtt}}</td>' +
                            '<td><span class="comma">{{paymentAmt}}</span><br><span class="comma">{{dcAmt}}</span></td>' +
                            '<td>{{rlsCourierNm}}<br>{{rlsInvoiceNo}}</td>' +
                            '</tr>';
                        var templateMgr = new Dmall.Template(template);
                        var tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            obj.paymentAmt = (Number(obj.saleAmt) - Number(obj.dcAmt)) * Number(obj.ordQtt) + Number(obj.realDlvrAmt);
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="12">데이터가 없습니다.</td></tr>';
                        }

                        $('#ajaxOrdList').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_ord_search', 'div_paging', result, 'paging_ord', varOrd.getOrdList);

                        $("#cnt_total").text(result.filterdRows);

                        Dmall.common.comma();
                    });

                    return dfd.promise();
                }
            }
        </script>

    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    주문 관리<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">주문 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form id="form_excel_dn">
                        <input type="hidden" name="ordNos" id="ordNos"/>
                    </form:form>
                    <form:form id="form_ord_search" commandName="ordSO">
                        <input type="hidden" name="page" id="hd_page" value="${ordSO.page}" />
                        <input type="hidden" name="sord" id="hd_srod" value="${ordSO.sord}" />
                        <input type="hidden" name="rows" id="hd_rows" value="${ordSO.rows}" />
                        <input type="hidden" name="ordNo" id="ordNo"  value="${ordSO.ordNo}"/>
                        <input type="hidden" name="siteNo" value="${ordSO.siteNo}" />
                        <div class="search_tbl">
                            <table summary="이표는 주문 관리 검색 표 입니다. 구성은 주문일, 주문상태, 결제수단, 판매환경, 판매채널, 회원구분, 검색어 입니다.">
                                <caption>주문 관리 검색</caption>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>주문일</th>
                                    <td>
                                        <input type="hidden" name="dayTypeCd" id="dayTypeCd" value="01">
                                        <tags:calendar from="ordDayS" to="ordDayE" fromValue="${ordSO.ordDayS}" toValue="${ordSO.ordDayE}" hasTotal="true" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr id="tr_ordDtlStatus">
                                    <th>주문상태</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                        <c:set var="checked" value=""/>
                                        <c:set var="on" value=""/>
                                        <c:forEach var="dtlStatusCd" items="${codeOnList}" varStatus="status">
                                            <c:forEach var="ordSoDtlStatusCd" items="${ordSO.ordDtlStatusCd}" varStatus="status2">
                                                <c:if test="${dtlStatusCd.dtlCd eq ordSoDtlStatusCd}">
                                                    <c:set var="on" value=" on"/>
                                                    <c:set var="checked" value="  checked=\"checked\""/>
                                                </c:if>
                                            </c:forEach>
                                            <label for="ordDtlStatusCd1_${status.count}" class="chack mr20${on}">
                                                <span class="ico_comm">&nbsp;</span>
                                                <input type="checkbox" name="ordDtlStatusCd"
                                                       id="ordDtlStatusCd1_${status.count}" class="blind"
                                                       value="<c:out value="${dtlStatusCd.dtlCd}"/>" ${checked}/>
                                                <span id="span_${status.count}" class="txt"><c:out value="${dtlStatusCd.dtlNm}"/></span>
                                            </label>
                                            <c:set var="checked" value=""/>
                                            <c:set var="on" value=""/>
                                        </c:forEach>
                                    </td>
                                </tr>
                                <tr>
                                    <th>클레임 상태</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                        <c:forEach var="dtlStatusCd" items="${codeOffList}" varStatus="status">
                                            <c:forEach var="ordSoDtlStatusCd" items="${ordSO.ordDtlStatusCd}" varStatus="status2">
                                                <c:if test="${dtlStatusCd.dtlCd eq ordSoDtlStatusCd}">
                                                    <c:set var="on" value=" on"/>
                                                    <c:set var="checked" value="  checked=\"checked\""/>
                                                </c:if>
                                            </c:forEach>
                                            <label for="ordDtlStatusCd2_${status.count}" class="chack mr20${on}">
                                                <span class="ico_comm">&nbsp;</span>
                                                <input type="checkbox" name="ordDtlStatusCd"
                                                       id="ordDtlStatusCd2_${status.count}" class="blind"
                                                       value="<c:out value="${dtlStatusCd.dtlCd}"/>" ${checked}/>
                                                <span class="txt"><c:out value="${dtlStatusCd.dtlNm}"/></span>
                                            </label>
                                            <c:set var="checked" value=""/>
                                            <c:set var="on" value=""/>
                                        </c:forEach>
                                    </td>
                                </tr>
                                <tr>
                                    <th>결제수단</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                        <c:forEach var="getCd" items="${paymentWayCdList}" varStatus="status">
                                            <c:forEach var="listCd" items="${ordSO.paymentWayCd}" varStatus="status2">
                                                <c:if test="${getCd.dtlCd eq listCd}">
                                                    <c:set var="on" value=" on"/>
                                                    <c:set var="checked" value="  checked=\"checked\""/>
                                                </c:if>
                                            </c:forEach>
                                            <label for="paymentWayCd_${status.count}" class="chack mr20${on}">
                                                <span class="ico_comm">
                                                    <input type="checkbox" name="paymentWayCd" id="paymentWayCd_${status.count}"
                                                           class="blind" value="<c:out value="${getCd.dtlCd}"/>" ${checked}/>
                                                </span>
                                                <c:out value="${getCd.dtlNm}"/>
                                            </label>
                                            <c:set var="checked" value=""/>
                                            <c:set var="on" value=""/>
                                        </c:forEach>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매환경</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                        <c:forEach var="getCd" items="${ordMediaCdList}" varStatus="status">
                                            <c:forEach var="listCd" items="${ordSO.ordMediaCd}" varStatus="status2">
                                                <c:if test="${getCd.dtlCd eq listCd}">
                                                    <c:set var="on" value=" on"/>
                                                    <c:set var="checked" value="  checked=\"checked\""/>
                                                </c:if>
                                            </c:forEach>
                                            <label for="ordMediaCd_${status.count }" class="chack mr20${on}">
                                                <span class="ico_comm">
                                                    <input type="checkbox" name="ordMediaCd" id="ordMediaCd_${status.count }"
                                                           class="blind" value="<c:out value="${getCd.dtlCd}"/>" ${checked}/>
                                                </span>
                                                <c:out value="${getCd.dtlNm}"/>
                                            </label>
                                            <c:set var="checked" value=""/>
                                            <c:set var="on" value=""/>
                                        </c:forEach>
                                    </td>
                                </tr>
                                <tr>
                                    <th>배송 구분</th>
                                    <td id="td_searchDlvrcPayment">
                                        <tags:radio name="searchDlvrcPaymentCd" codeStr=":전체;01:택배;04:매장픽업"
                                                    value="${ordSO.searchDlvrcPaymentCd}"
                                                    idPrefix="check_id_searchDlvrcPaymentCd"
                                                    validate="validate[required]"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="select">
                                            <label for="sel_id_searchCd"></label>
                                            <select id="sel_id_searchCd" name="searchCd">
                                                <tags:option codeStr=":전체;01:주문번호;02:주문자;03:수령자;06:이메일;07:휴대폰;08:상품명;09:상품코드" value="${ordSO.searchCd}"/>
                                            </select>
                                        </span>
                                        <span class="intxt long">
                                            <input type="text" id="searchWord" name="searchWord" value="${ordSO.searchWord}"/>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </form:form>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <a href="javascript:;" class="btn green" id="ord_search_btn">검색</a>
                    </div>
                </div>
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total"></strong>개의 주문이 검색되었습니다.
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
                        <table summary="이표는 주문 관리 리스트 표 입니다. 구성은 선택, 번호, 주문상태,주문일시, 환경, 주문번호, 상품번호, 주문상품, 출고, 수신자/주문자, 결제수단, 결제금액, 결제일시, 판매채널 입니다.">
                            <caption>주문 관리 리스트</caption>
                            <colgroup>
                                <col width="3%" />
                                <col width="5%" />
                                <col width="8%" />
                                <col width="8%" />
                                <col width="12%" />
                                <col width="15%" />
                                <col width="8%" />
                                <col width="8%" />
                                <col width="8%" />
                                <col width="5%" />
                                <col width="10%" />
                                <col width="10%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="allcheck" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="allcheck"></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>주문상태</th>
                                <th>주문일시</th>
                                <th>주문번호</th>
                                <th>상품명<br>[상품코드]</th>
                                <th>옵션</th>
                                <th>주문자<br>수령인</th>
                                <th>판매가<br>공급가</th>
                                <th>주문수량</th>
                                <th>결제금액<br>할인금액</th>
                                <th>송장번호</th>
                            </tr>
                            </thead>
                            <tbody id="ajaxOrdList">
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div class="pageing" id="div_paging"></div>
                    </div>
                    <!-- //bottom_lay -->
                </div>
            </div>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <button name="btn_chg_status" class="btn--big btn--big-white">결제완료</button>
                    <button name="btn_chg_status" class="btn--big btn--big-white">주문확정</button>
                    <%--<button name="btn_chg_status" class="btn--big btn--big-white">배송준비중</button>--%>
                    <%--<button name="btn_chg_status" class="btn--big btn--big-white">배송중</button>--%>
                    <button name="btn_chg_status" class="btn--big btn--big-white">배송완료 / 픽업가능</button>
                    <button name="btn_chg_status" class="btn--big btn--big-white">구매확정 / 픽업완료</button>
                </div>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>


<!-- layer_popup_option -->
<div id="layout_status" class="layer_popup">
    <div class="pop_wrap size3">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">주문상태 일괄 변경</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <!-- tblh -->
                <div class="tblh mt0">
                    <table summary="이표는 주문상태 일괄 변경 표 입니다. 구성은 현재 선택된 옵션, 변경 옵션 입니다.">
                        <caption>옵션변경</caption>
                        <colgroup>
                            <col width="50%">
                            <col width="50%">
                        </colgroup>
                        <thead>

                        </thead>
                        <tbody>
                        <tr>
                            <th>선택된주문수</th>
                            <td>12건</td>
                        </tr>
                        <tr>
                            <th>주문상태</th>
                            <td>결제완료</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <div class="btn_box txtc">
                    <button class="btn green" id="btn_status_change">저장</button>
                </div>
            </div>
        </div>
    </div>
    <!-- //pop_con -->
</div>
<!-- //layer_popup_option -->