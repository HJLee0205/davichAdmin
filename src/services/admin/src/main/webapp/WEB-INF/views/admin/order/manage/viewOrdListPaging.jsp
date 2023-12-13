<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 주문관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            jQuery(document).ready(function () {
                checkbox();
                // 상품 상세에서 링크되었을 경우
                <c:if test="${ordSO.ordNo ne null and ordSO.ordNo ne ''}">
                $(varOrd.getOrdList);
                </c:if>
                jQuery('#ord_search_btn').on('click', function () {
                    $('#hd_page').val(1);
                    $(varOrd.getOrdList);
                });

                jQuery('#excelDown').on('click', function () {
                    jQuery('#form_ord_search').attr('action', '/admin/order/manage/searchorder-excel-download');
                    jQuery('#form_ord_search').submit();
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
                    var readyPayChk = 0;
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
                        if (curOrdStatusCd == "10") {
                            readyPayChk++;
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
                    } else if (chk.length == readyPayChk && $(this).text() == '결제완료') {
                        // sel_status += '<option value="">선택</option>';
                        sel_status = '<input type="hidden" id="tgtOrdStatusCd" value="20">결제완료';
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

                    console.log("curOrdStatusCd = ", curOrdStatusCd);
                    console.log("curOrdDtlSeq = ", curOrdDtlSeq);
                    Dmall.LayerUtil.confirm(msg, function () {
                        chgOrdStatus(tgtOrdStatusCd, curOrdStatusCd, curOrdDtlSeq, '')
                    });


                    Dmall.LayerPopupUtil.close('layout_status');

                });

                jQuery('label.radio', $("#td_searchDlvrcPayment")).off('click').on('click', function (e) {
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
                loadDefaultCondition();
            });

            // 기본 상태값 세팅...
            var ignoreCookie = ${ignoreCookie};
            function loadDefaultCondition() {
                if(ignoreCookie) {
                    ignoreCookie = false;
                    $(varOrd.getOrdList);
                } else {
                    var cookie = getCookie('SEARCH_ORD_LIST');

                    if (!cookie) {
                        return;
                    } else {
                        var cookieObj = jQuery.parseJSON(getCookie('SEARCH_ORD_LIST'));
                        if (cookieObj['page']) {
                            $('#hd_page').val(cookieObj['page']);
                        }
                        if (cookieObj['dayTypeCd']) {
                            $('#dayTypeCd').find('option').each(function () {
                                if ($(this).val() == cookieObj['dayTypeCd']) {
                                    $(this).attr("selected", "true");
                                    $('label[for=dayTypeCd]').html($(this).text());
                                }
                            });
                        }
                        if (cookieObj['ordDayS']) {
                            $('input[name=ordDayS]').val(cookieObj['ordDayS']);
                        }
                        if (cookieObj['ordDayE']) {
                            $('input[name=ordDayE]').val(cookieObj['ordDayE']);
                        }
                        if (cookieObj['ordDtlStatusCd']) {
                            if (cookieObj['ordDtlStatusCd'] instanceof Array) {
                                $.each(cookieObj['ordDtlStatusCd'], function (idx, obj) {
                                    var id = $('input:checkbox[value=' + obj + '][name=ordDtlStatusCd]').attr('id');
                                    $('label[for=' + id + ']').addClass('on');
                                    $('#' + id).prop('checked', 'checked');
                                });
                            } else {
                                var id = $('input:checkbox[value=' + cookieObj['ordDtlStatusCd'] + '][name=ordDtlStatusCd]').attr('id');
                                $('label[for=' + id + ']').addClass('on');
                                $('#' + id).prop('checked', 'checked');
                            }
                        }
                        if (cookieObj['paymentWayCd']) {
                            if (cookieObj['paymentWayCd'] instanceof Array) {
                                $.each(cookieObj['paymentWayCd'], function (idx, obj) {
                                    var id = $('input:checkbox[value=' + obj + '][name=paymentWayCd]').attr('id');
                                    $('label[for=' + id + ']').addClass('on');
                                    $('#' + id).prop('checked', 'checked');
                                });
                            } else {
                                var id = $('input:checkbox[value=' + cookieObj['paymentWayCd'] + '][name=paymentWayCd]').attr('id');
                                $('label[for=' + id + ']').addClass('on');
                                $('#' + id).prop('checked', 'checked');
                            }
                        }
                        if (cookieObj['ordMediaCd']) {
                            if (cookieObj['ordMediaCd'] instanceof Array) {
                                $.each(cookieObj['ordMediaCd'], function (idx, obj) {
                                    var id = $('input:checkbox[value=' + obj + '][name=ordMediaCd]').attr('id');
                                    $('label[for=' + id + ']').addClass('on');
                                    $('#' + id).prop('checked', 'checked');
                                });
                            } else {
                                var id = $('input:checkbox[value=' + cookieObj['ordMediaCd'] + '][name=ordMediaCd]').attr('id');
                                $('label[for=' + id + ']').addClass('on');
                                $('#' + id).prop('checked', 'checked');
                            }
                        }
                        if (cookieObj['saleChannelCd']) {
                            if (cookieObj['saleChannelCd'] instanceof Array) {
                                $.each(cookieObj['saleChannelCd'], function (idx, obj) {
                                    var id = $('input:checkbox[value=' + obj + '][name=saleChannelCd]').attr('id');
                                    $('label[for=' + id + ']').addClass('on');
                                    $('#' + id).prop('checked', 'checked');
                                });
                            } else {
                                var id = $('input:checkbox[value=' + cookieObj['saleChannelCd'] + '][name=saleChannelCd]').attr('id');
                                $('label[for=' + id + ']').addClass('on');
                                $('#' + id).prop('checked', 'checked');
                            }
                        }
                        if (cookieObj['memberOrdYn']) {
                            $('label[for^=check_id_memberYn]').each(function () {
                                $(this).removeClass('on');
                                $(this).find('input:radio').prop('checked', '');
                            });
                            var id = $('input:radio[value=' + cookieObj['memberOrdYn'] + ']').attr('id');
                            $('label[for=' + id + ']').addClass('on');
                            $('#' + id).prop('checked', 'checked');
                        }
                        if (cookieObj['searchSeller']) {
                            $('#sel_seller').find('option').each(function () {
                                if ($(this).val() == cookieObj['searchSeller']) {
                                    $(this).attr("selected", "true");
                                    $('label[for=sel_seller]').html($(this).text());
                                }
                            });
                        }
                        if (cookieObj['searchCd']) {
                            $('#sel_id_searchCd').find('option').each(function () {
                                if ($(this).val() == cookieObj['searchCd']) {
                                    $(this).attr("selected", "true");
                                    $('label[for=sel_id_searchCd]').html($(this).text());
                                }
                            });
                        }
                        if (cookieObj['searchWord']) {
                            $('#searchWord').val(cookieObj['searchWord']);
                        }
                        if (cookieObj['rows']) {
                            $('#sel_rows').find('option').each(function () {
                                if ($(this).val() == cookieObj['rows']) {
                                    $(this).attr("selected", "true");
                                    $('label[for=sel_rows]').html($(this).text());
                                }
                            });
                        }

                        $(varOrd.getOrdList);
                    }
                }
            }

            /**
             * <pre>
             * 함수명 : checkbox
             * 설  명 : 그리드 헤더의 전체 체크박스에 대한 이벤트 처리
             * 사용법 :
             * 작성일 : 2016. 4. 28.
             * 작성자 : dong
             * 수정내역(수정일 수정자 - 수정내용)
             * -------------------------------------
             * 2016. 4. 28. dong - 최초 생성
             * 2016. 5. 18. dong - 주문에 맞게 수정
             * </pre>
             */
            function checkbox() {
                $(document).on('click', '.check', function (e) {
                    var $this = jQuery(this),
                        checked = !($(this).hasClass('on'));
                    var orgId = this.id;
                    if ($this.parent()[0].tagName === 'TH') {
                        $this.closest('table').find('tbody tr td label.check').each(function (i, o) {
                            if (orgId == o.id)
                                CheckboxUtil.check(o, checked);
                        });
                    } else {
                        $checkbox = $this.siblings();
                        $checkbox.prop('checked', checked);
                    }
                    $this.toggleClass('on');
                });

                $("#btn_chk_all").on('click', function () {
                    var _chk = $('#ajaxOrdList').find('.check');
                    _chk.each(function (i, o) {
                        checked = !($(this).hasClass('on'));
                        $checkbox = $(this).siblings();
                        $checkbox.prop('checked', checked);
                        $(this).toggleClass('on');
                    });
                });
            }

            /**
             * 디자인 체크박스 클래스
             */
            var CheckboxUtil = {
                /**
                 * <pre>
                 * 함수명 : check
                 * 설  명 : 디자인 체크박스 내부의 체크박스에 값을 설정
                 * 사용법 :
                 * 작성일 : 2016. 4. 28.
                 * 작성자 : dong
                 * 수정내역(수정일 수정자 - 수정내용)
                 * -------------------------------------
                 * 2016. 4. 28. dong - 최초 생성
                 * 2016. 5. 18. dong - 주문에 맞게 수정
                 * </pre>
                 * @param obj 이벤트가 발생한 엘리먼트
                 * @param checked 체크여부
                 */
                check: function (obj, checked) {
                    var $this = $(obj),
                        $checkbox = $this.prev();
                    if (checked) {
                        $this.addClass('on');
                        $checkbox.prop('checked', true);
                    } else {
                        $this.removeClass('on');
                        $checkbox.prop('checked', false);
                    }
                }
            };

            function OpenWindow(url, intWidth, intHeight) {
                window.open(url, "_blank", "width=" + intWidth + ",height=" + intHeight + ",resizable=1,scrollbars=1");
            }

            function ordPrint(cd) {
                var url = "/admin/order/manage/order-print";
                var checkboxValues = [];
                var checkboxName = 'table_chk_' + cd;
                jQuery.map($('input[name=' + checkboxName + ']:checked'), function (x) {
                    checkboxValues.push(x.value);
                });
                var ordNo = "";
                if (checkboxValues.length == 1) {
                    ordNo = checkboxValues[0];
                    window.open(url, "ordPrint", "width=" + 1024 + ",height=" + 860 + ",resizable=1,scrollbars=1");
                    Dmall.FormUtil.submit(url, {ordNo: ordNo}, "ordPrint");
                } else {
                    Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.chooseOneOrder"/>');
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
                //alert(jQuery('#form_delivery input[name=rlsCourierCd]').val());
                $('#ordNo').val(ordNo);
                var data = {};
                var i = 0, oldName = '', newName = [];

                jQuery.map($("#form_ord_search").serializeArray(), function (x) {
                    if (x.name == 'ordDtlStatusCd' || x.name == 'paymentWayCd' || x.name == 'ordMediaCd' || x.name == 'saleChannelCd') {
                        if (oldName == '')
                            newName = [];
                        if (oldName == '' || oldName == x.name) {
                            newName[i] = x.value;
                            i++;
                        } else {
                            if (newName.length > 0) {
                                data[oldName] = newName;
                                newName = [];
                                i = 0;
                            }
                            newName[i] = x.value;
                            i++;
                        }
                        oldName = x.name;
//                    data[x.name] = x.value;
                    } else {
                        data[x.name] = x.value;
                        if (newName.length > 0) {
                            data[oldName] = newName;
                            newName = [];
                        }
                    }

                });
                var url = "/admin/order/manage/order-detail";
                Dmall.FormUtil.submit(url, data);
            }

            /**
             * <pre>
             * 함수명 : chgOrdStatus
             * 설  명 : 다수 주문건의 주문 상태 변경
             * 사용법 :
             * 작성일 : 2016. 6. 09.
             * 작성자 : dong
             * 수정내역(수정일 수정자 - 수정내용)
             * -------------------------------------
             * 2016. 5. 24. dong - 최초 생성
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

            /**
             * <pre>
             * 함수명 : selectedExcel
             * 설  명 : 선택된 주문 목록의 엑셀 출력
             * 사용법 :
             * 작성일 : 2016. 6. 09.
             * 작성자 : dong
             * 수정내역(수정일 수정자 - 수정내용)
             * -------------------------------------
             * 2016. 5. 24. dong - 최초 생성
             * </pre>
             */
            function ordExcelDnByStatus(cd) {
                var checkboxValues = '';
                var comma = ',';
                var checkboxName = 'table_chk_' + cd;
                jQuery.map($('input[name=' + checkboxName + ']:checked'), function (x) {
                    (checkboxValues == '') ? comma = '' : comma = ',';
                    checkboxValues = checkboxValues + comma + x.value;
                });

                if (checkboxValues == '') {
                    Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.noOrderNo"/>');
                    return;
                }
                $('#ordNos').val(checkboxValues);
                jQuery('#form_excel_dn').attr('action', '/admin/order/manage/order-excel-download');
                jQuery('#form_excel_dn').submit();

            }

            var varOrd = {
                getOrdList: function () {
                    var url = '/admin/order/manage/order-list',
                        param = jQuery('#form_ord_search').serialize(),
                        dfd = jQuery.Deferred();

                    var expdate = new Date();
                    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
                    setCookie('SEARCH_ORD_LIST', JSON.stringify($('#form_ord_search').serializeObject()), expdate);

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var midRowCnt = result.resultList.length;
                        var midRowCntArr = new Array(result.resultList.length);
                        var tmpCnt = 1;

                        var template1 =
                                '<tr>' +
                                '   <td>' +
                                '       <input type="hidden" name="curOrdStatusCd" value="{{ordDtlStatusCd}}">' +
                                '       <input type="hidden" name="curOrdDtlSeq" value="{{ordDtlSeq}}">' +
                                '       <label for="table_chk_{{ordDtlStatusCd}}" class="chack" id="chk_{{ordDtlStatusCd}}">' +
                                '          <span class="ico_comm"><input type="checkbox" name="table_chk_{{ordDtlStatusCd}}" id="table_chk_{{ordDtlStatusCd}}" class="blind" value="{{ordNo}}"/></span>' +
                                '       </label>' +
                                '   </td>' +
                                '   <td>{{sortNum}}</td>',
//                         statusNm =  '   <td>{{ordStatusNm}}</td>',
                            statusNm = '   <td>{{ordDtlStatusNm}}</td>',
                            statusNm_20 = '   <td style="color:#cd0a0a;">{{ordDtlStatusNm}}</td>',
                            statusNm_30 = '   <td style="color:#33be40;">{{ordDtlStatusNm}}</td>',
                            statusNm_40 = '   <td style="color:#9f7641;">{{ordDtlStatusNm}}</td>',

                            template1_5 = '   <td>{{ordAcceptDttm}}</td>' +
                                '   <td>' +
                                '       <a href="javascript:goOrdDtl(\'{{ordNo}}\')" class="tbl_link">{{ordNo}}<br></a>',
                            template_reord = '     <br><a href="#none" class="btn_blue">재주문</a>',
                            template1_1 = '   </td>' +
                                '   <td>{{goodsNm}}<br>[{{goodsNo}}]</td>' +
                                '   <td>{{itemNm}}<br>{{addOptNm}}</td>' +
                                '   <td>{{sellerNm}}</td>' +
                                '   <td>{{ordrNm}}<br>{{adrsNm}}</td>' +
                                '   <td>{{saleAmt}}<br>{{supplyAmt}}<br></td>',
                            template1_1_a = '  <td><span style="color:#cd0a0a;font-weight:bold;">{{ordQtt}}</span></td>',
                            template1_1_b = '  <td><span>{{ordQtt}}</span></td>',
                            template1_1_1 = '  <td>',
                            template1_1_1_1 = ' </td>',
                            /*template1_1_1 = '	<td>{{sumSaleAmt}}<br>{{dcAmt}}</td>',
                            template1_1_1 ='	<td>{{sumSaleAmt}}<br>{{sumSupplyAmt}}</td>' ,*/
                            template1_1_2 = '  <td>{{rlsCourierNm}}<br>{{rlsInvoiceNo}}</td>' +
                                /*template1_2 ='   <td><span class="ico_pc"><img src="/admin/img/common/img_pc.png" alt="PC" /></span></td>',
                                template1_3 ='   <td><span class="ico_phone"><img src="/admin/img/common/img_phone.png" alt="폰" /></span></td>',*/

                                /*template1_4 = '   <td>{{saleChannelNm}}</td>'+*/
                                '</tr>',
                            template2 = '<tr>' +
                                '   <th class="colw">' +
                                '       <input type="checkbox" class="blind" />' +
                                '       <label for="" class="check" id="chk_{{ordDtlStatusCd}}">' +
                                '           <span class="ico_comm" id="ord_check_all">&nbsp;</span>' +
                                '       </label>' +
                                '   </th>' +
                                '   <th colspan="13" class="colw">' +
                                '       <div class="tbl_tlt">' +
                                '           <div class="left">',
                            template2_1 = '               <a href="#" onclick="javascript:ordPrint(\'{{ordDtlStatusCd}}\')"><button class="btn_print" type="button"><span class="ico_comm"></span> 프린트</button></a>' +
                                '           </div>' +
                                '           <span class="tlt">{{ordDtlStatusNm}}</span>' +
                                '           <div class="right">' +
                                '               <a href="#" onClick="javascript:ordExcelDnByStatus(\'{{ordDtlStatusCd}}\')"><button class="btn_exlw"><span class="ico_comm"></span> 일괄 다운로드</button></a>' +
                                '           </div>' +
                                '      </div>' +
                                '   </th>' +
                                '</tr>',

                            managerTemplate1 = new Dmall.Template(template1),
                            managerTemplate1_1 = new Dmall.Template(template1_1),
                            managerTemplate1_1_a = new Dmall.TemplateNoFormat(template1_1_a),
                            managerTemplate1_1_b = new Dmall.TemplateNoFormat(template1_1_b),
                            managerTemplate1_1_1 = new Dmall.TemplateNoFormat(template1_1_1),
                            managerTemplate1_1_1_1 = new Dmall.TemplateNoFormat(template1_1_1_1),
                            managerTemplate1_1_2 = new Dmall.Template(template1_1_2),
                            // managerTemplate1_2 = new Dmall.Template(template1_2),
                            // managerTemplate1_3 = new Dmall.Template(template1_3),
                            // managerTemplate1_4 = new Dmall.Template(template1_4),
                            managerTemplate1_5 = new Dmall.Template(template1_5),
                            managerTemplate2 = new Dmall.Template(template2),
                            managerTemplate2_1 = new Dmall.Template(template2_1),
                            managerTemplate_reord = new Dmall.Template(template_reord),
                            statusNm = new Dmall.Template(statusNm),
                            statusNm_20 = new Dmall.Template(statusNm_20),
                            statusNm_30 = new Dmall.Template(statusNm_30),
                            statusNm_40 = new Dmall.Template(statusNm_40),
                            tr = '';

                        var oldCd = '';
                        var totSaleAmt = 0;

                        jQuery.each(result.resultList, function (idx, obj) {

                            totSaleAmt = obj.totSaleAmt;



                            oldCd = obj.ordDtlStatusCd;

                            tr += managerTemplate1.render(obj);

                            //결제완료
                            if (obj.ordDtlStatusCd == '20')
                                tr += statusNm_20.render(obj);

                            //배송준비중
                            else if (obj.ordDtlStatusCd == '30')
                                tr += statusNm_30.render(obj);

                            //배송중
                            else if (obj.ordDtlStatusCd == '40')
                                tr += statusNm_40.render(obj);
                            else
                                tr += statusNm.render(obj);


                            tr += managerTemplate1_5.render(obj);

                            /*if (obj.orgOrdNo != null)
                                tr += managerTemplate_reord.render(obj);*/

                            obj.saleAmt = Dmall.common.numberWithCommas(obj.saleAmt);
                            obj.supplyAmt = Dmall.common.numberWithCommas(obj.supplyAmt);

                            tr += managerTemplate1_1.render(obj);

                            var saleAmt = obj.saleAmt.replace(",", "");
                            var supplyAmt = obj.supplyAmt.replace(",", "");

                            tr += "<br>" + (((saleAmt - supplyAmt) / saleAmt) * 100).round(1) + "%";

                            if (obj.ordQtt >= 2) {
                                tr += managerTemplate1_1_a.render(obj);
                            } else {
                                tr += managerTemplate1_1_b.render(obj);
                            }
                            var sumSaleAmt = obj.sumSaleAmt.replace(",", "");
                            var dcAmt = obj.dcAmt;
                            var realDlvrAmt = obj.realDlvrAmt;
                            if (dcAmt > 0) {
                                dcAmt = obj.dcAmt;
                            }


                            tr += managerTemplate1_1_1.render(obj);
                            tr += commaNumber((sumSaleAmt - dcAmt + Number(realDlvrAmt))) + "<br>" + commaNumber(dcAmt);
                            tr += managerTemplate1_1_1_1.render(obj);
                            tr += managerTemplate1_1_2.render(obj);

                        });

                        if (tr == '') {
                            tr = '<tr><td colspan="14"><spring:message code="biz.exception.common.nodata"/></td></tr>';
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

                        // 총 판매금액 처리
                        $("#totSaleAmt").html(commaNumber(totSaleAmt));

                        Dmall.GridUtil.appendPaging('form_ord_search', 'div_paging', result, 'paging_ord', varOrd.getOrdList);
                    });

                    return dfd.promise();

                }
            }

            Number.prototype.round = function (places) {
                return +(Math.round(this + "e+" + places) + "e-" + places);
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
                        <input type="hidden" name="page" id="hd_page" value="${ordSO.page}"/>
                        <input type="hidden" name="sord" id="hd_srod" value="${ordSO.sord}"/>
                        <input type="hidden" name="rows" id="hd_rows" value="${ordSO.rows}"/>
                        <input type="hidden" name="ordNo" id="ordNo" value="${ordSO.ordNo}"/>
                        <input type="hidden" name="siteNo" value="${ordSO.siteNo}"/>
                        <input type="hidden" name="dayTypeCd" value="01"/>
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
                                        <tags:calendar from="ordDayS" to="ordDayE" fromValue="${ordSO.ordDayS}" toValue="${ordSO.ordDayE}" hasTotal="true" idPrefix="srch"/>
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
                                    <th>판매자</th>
                                    <td>
                                        <span class="select">
                                            <label for="sel_seller"></label>
                                            <select name="searchSeller" id="sel_seller">
                                                <code:sellerOption siteno="${ordSO.siteNo}" includeTotal="true"/>
                                            </select>
                                        </span>
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
                    <div class="btn_box txtc">
                        <a href="javascript:void(0);" class="btn green" id="ord_search_btn">검색</a>
                    </div>
                </div>
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_search">0</strong>개의 주문이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="excelDown">
                                <span>Excel download</span>
                                <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
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
                                <col width="8%" />
                                <col width="5%" />
                                <col width="8%" />
                                <col width="8%" />
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
                                <th>옵션명</th>
                                <th>판매자</th>
                                <th>주문자<br>수령자</th>
                                <th>판매가<br>공급가</th>
                                <th>주문수량</th>
                                <th>결제금액<br>할인금액</th>
                                <th>택배사<br>송장번호</th>
                            </tr>
                            </thead>
                            <tbody id="ajaxOrdList">
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <div class="pageing mt10" id="div_paging"></div>
                    </div>
                </div>
            </div>
        </div>
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