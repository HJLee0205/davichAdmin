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
<c:set var="strRsvType" value="${fn:join(so.rsvType, ',')}"/>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 주문관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            jQuery(document).ready(function () {

                checkbox();

                jQuery('#rsv_search_btn').on('click', function () {
                    $('#hd_page').val('1');
                    varRsv.getRsvList();
                });

                jQuery('#excelDown').on('click', function () {
                    /*jQuery('#form_rvs_search').attr('action', '/admin/order/manage/searchorder-excel-download');
                    jQuery('#form_rvs_search').submit();*/
                    jQuery('#form_rvs_search').attr('action', '/admin/order/reservation/reservation-excel-download');
                    jQuery('#form_rvs_search').submit();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_rvs_search', varRsv.getRsvList);

                /*getSellerOptionValue(jQuery('#sel_seller'));*/

                //주문상태변경 layer
                $("a[name=btn_chg_status]").on('click', function () {
                    var layout = $('#layout_status'),
                        html = "",
                        chk = $('#ajaxRsvList').find('.check.on'),
                        sel_status = '<span class="select">'
                    ;

                    if (chk.length < 1) {
                        Dmall.LayerUtil.alert('선택된 주문이 없습니다.');
                        return;
                    }

                    // 입금대기중체크
                    var depositChk = 0;
                    chk.each(function () {
                        var curOrdStatusCd = $(this).siblings('[name=curOrdStatusCd]').val();
                        if (curOrdStatusCd == "10") {
                            depositChk++;
                        }
                    });

                    // 결제완료체크
                    var payCompChk = 0;
                    chk.each(function () {
                        var curOrdStatusCd = $(this).siblings('[name=curOrdStatusCd]').val();
                        if (curOrdStatusCd == "20") {
                            payCompChk++;
                        }
                    });

                    sel_status += '<label for="tgtOrdStatusCd">선택</label>';
                    sel_status += '<select name="tgtOrdStatusCd">';

                    if (chk.length == depositChk) {
                        sel_status += '<option value="00">주문무효</option>';
                        sel_status += '<option value="20">결제완료</option>';
                    } else if (chk.length == payCompChk) {
                        sel_status += '<option value="">선택</option>';
                        sel_status += '<option value="30">MD확정</option>';
                    } else {
                        Dmall.LayerUtil.alert("상태값이 동일한 주문건만 선택해 주세요. <br/>('입금대기중' 또는 '결제완료' 상태인 주문건만 일괄처리 가능)");
                        return;
                    }

//                 <c:forEach var="statusCd" items="${codeOnList}" varStatus="status">
//                     <c:if test="${statusCd.dtlCd == '10' or statusCd.dtlCd == '20' or statusCd.dtlCd == '30'}">
//                         sel_status+='<option value="${statusCd.dtlCd}">';
//                     <c:if test="${statusCd.dtlCd eq '30'}">
//                             sel_status+='MD확정';
//                     </c:if>
//                     <c:if test="${statusCd.dtlCd ne '30'}">
//                             sel_status+='${statusCd.dtlNm}';
//                     </c:if>
//                         sel_status+='</option>';
//                     </c:if>
//                 </c:forEach>
//                 <c:forEach var="statusCd" items="${codeOffList}" varStatus="status">
//                     <c:if test="${statusCd.dtlCd == '00'}">
//                         sel_status+='<option value="${statusCd.dtlCd}">${statusCd.dtlNm}</option>';
//                     </c:if>
//                 </c:forEach>

                    sel_status += '</select>';
                    sel_status += '</span>';

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
                    var chk = $('#ajaxRsvList').find('.check.on'),
                        tgtOrdStatusCd = $("select[name=tgtOrdStatusCd] option:selected").val();

                    var curOrdStatusCd = "";
                    var curOrdDtlSeq = "";

                    var msg = '';
                    if (tgtOrdStatusCd == '10')
                        msg = '선택된 주문을 입금확인중으로 변경 하시겠습니까?';
                    else if (tgtOrdStatusCd == '20')
                        msg = '선택된 주문을 결제완료 하시겠습니까?';
                    else if (tgtOrdStatusCd == '00')
                        msg = '선택된 주문을 주문무효처리 하시겠습니까?';
                    else if (tgtOrdStatusCd == '30')
                        msg = '선택된 주문을 MD확정(배송준비중) 으로 변경 하시겠습니까?';

                    if (tgtOrdStatusCd == '') {
                        Dmall.LayerUtil.alert('변경할 주문상태를 선택하세요.');
                        return false;
                    }

                    chk.each(function (idx) {
                        if (idx == 0) {
                            curOrdStatusCd += $(this).siblings('[name=curOrdStatusCd]').val();
                            curOrdDtlSeq += $(this).siblings('[name=curOrdDtlSeq]').val();
                        } else {
                            curOrdStatusCd += ',' + $(this).siblings('[name=curOrdStatusCd]').val();
                            curOrdDtlSeq += ',' + $(this).siblings('[name=curOrdDtlSeq]').val();
                        }
                    });

                    Dmall.LayerUtil.confirm(msg, function () {
                        chgOrdStatus(tgtOrdStatusCd, curOrdStatusCd, curOrdDtlSeq, '')
                    });


                    Dmall.LayerPopupUtil.close('layout_status');

                });

                // 예약취소
                $('#btn_cancel').on('click', function () {
                    if($('#ajaxRsvList').find('input[name=rsvNo]:checked').closest('td').is('[data-cancel-yn=Y]')) {
                        Dmall.LayerUtil.alert('취소되지 않은 예약만 선택해주세요.');
                        return;
                    }

                    var checkedList = [];
                    $('#ajaxRsvList').find('input[name=rsvNo]:checked').each(function () {
                        checkedList.push($(this).val());
                    });

                    if(checkedList.length > 0) {
                        Dmall.LayerUtil.confirm('선택한 예약을 취소하시겠습니까?', function () {
                            var url = '/admin/order/reservation/rsv-info-update',
                                param = {};

                            param['prcType'] = 'C';
                            $.each(checkedList, function (idx, obj) {
                                param['rsvNoArr['+ idx +']'] = obj;
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function (result) {
                                if(result.success) {
                                    Dmall.LayerUtil.alert('취소되었습니다.').done(function () {
                                        varRsv.getRsvList();
                                    });
                                } else {
                                    Dmall.LayerUtil.alert('오류가 발생하였습니다.');
                                }
                            });
                        });
                    } else {
                        Dmall.LayerUtil.alert('선택된 데이터가 없습니다.');
                    }
                });

                // 선택삭제
                $('#btn_delete').on('click', function () {
                    var checkedList = [];
                    $('#ajaxRsvList').find('input[name=rsvNo]:checked').each(function () {
                        checkedList.push($(this).val());
                    });

                    if(checkedList.length > 0) {
                        Dmall.LayerUtil.confirm('정말 삭제하시겠습니까?', function () {
                            var url = '/admin/order/reservation/rsv-info-update',
                                param = {};

                            param['prcType'] = 'D';
                            $.each(checkedList, function (idx, obj) {
                                param['rsvNoArr['+ idx +']'] = obj;
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function (result) {
                                if(result.success) {
                                    Dmall.LayerUtil.alert('삭제되었습니다.').done(function () {
                                        varRsv.getRsvList();
                                    });
                                } else {
                                    Dmall.LayerUtil.alert('오류가 발생하였습니다.');
                                }
                            });
                        });
                    } else {
                        Dmall.LayerUtil.alert('선택된 데이터가 없습니다.');
                    }
                });

                if(${fn:length(so.rsvType) == 0}) {
                    $('#btn__cal_1').trigger('click');
                }

                varRsv.getRsvList();
            });

            // 기본 상태값 세팅...
            function loadDefaultCondition() {

                var cookie = getCookie('SEARCH_RVS_LIST');

                if (!cookie) {
                    return;
                } else {
                    var cookieObj = jQuery.parseJSON(getCookie('SEARCH_RVS_LIST'));
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


                    //$(varRsv.getRsvList);
                }

            }

            // 판매자 정보 취득
            /*function getSellerOptionValue($sel) {
                var url = '/admin/seller/seller-list-paging',
                    param = '';

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        var selectedValue = $('#sel_seller').data('searchSeller');
                        if (selectedValue && selectedValue === obj.sellerNo) {
                            $sel.append('<option value="'+ obj.sellerNo + '" selected>'+ obj.sellerNm+ '</option>');
                            $('label[for='+ $sel.attr('id') +']', $sel.parent()).html(obj.sellerNm);
                        } else {
                            $sel.append('<option value="'+ obj.sellerNo + '">' + obj.sellerNm + '</option>');
                        }
                    });
                });
            }*/

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
                    var _chk = $('#ajaxRsvList').find('.check');
                    _chk.each(function (i, o) {
                        checked = !($(this).hasClass('on'));
                        $checkbox = $(this).siblings();
                        $checkbox.prop('checked', checked);
                        $(this).toggleClass('on');
                    });
                });


            };

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
                var rsvNo = "";
                if (checkboxValues.length == 1) {
                    rsvNo = checkboxValues[0];
                    window.open(url, "ordPrint", "width=" + 1024 + ",height=" + 860 + ",resizable=1,scrollbars=1");
                    Dmall.FormUtil.submit(url, {rsvNo: rsvNo}, "ordPrint");
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
            function goRsvDtl(rsvNo) {
                //alert(jQuery('#form_delivery input[name=rlsCourierCd]').val());
                var url = "/admin/order/reservation/reservation-detail";
                console.log("rsvNo = ", rsvNo);
                location.href= url + "?" + "rsvNo=" + rsvNo;
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
                jQuery.map($('#ajaxRsvList input[name^=table_chk_]:checked'), function (x) {
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
                    rsvNo: checkboxValues,
                    curOrdStatusCd: curOrdStatusCd,
                    curOrdDtlSeq: curOrdDtlSeq,
                    ordStatusCd: tgtOrdStatusCd,
                    mdConfirmYn: mdConfirmYn
                };

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result.success) {
                        $('#hd_page').val(1);
                        $(varRsv.getRsvList);
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
                $('#rsvNos').val(checkboxValues);
                jQuery('#form_rvs_search').attr('action', '/admin/order/reservation/reservation-excel-download');
                jQuery('#form_rvs_search').submit();

            }

            var varRsv = {
                getRsvList: function () {
                    var url = '/admin/order/reservation/reservation-list',
                        param = jQuery('#form_rvs_search').serialize(),
                        dfd = jQuery.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                                        '<tr>' +
                                            '<td data-cancel-yn="{{cancelYn}}">' +
                                                '<label for="rsvNo{{rsvNo}}" class="chack"><span class="ico_comm">' +
                                                    '<input type="checkbox" name="rsvNo" id="rsvNo{{rsvNo}}" class="blind" value="{{rsvNo}}">' +
                                                '</span></label>' +
                                            '</td>' +
                                            '<td>{{sortNum}}</td>';
                        var template2 =     '';
                                // '<td></td>' +
                        var template3 =     '<td><a href="javascript:goRsvDtl(\'{{rsvNo}}\')" class="tbl_link">{{storeNm}}</a></td>' +
                                            // '<td></td>' +
                                            '<td>{{rsvDttm}}</td>' +
                                            '<td>{{goodsNm}}<br>{{goodsNo}}</td>' +
                                            '<td>{{itemNm}}</td>' +
                                            '<td>{{sellerNm}}</td>' +
                                            '<td>{{vstrNm}}</td>' +
                                            '<td>{{salePrice}}<br>{{supplyPrice}}</td>' +
                                            '<td>{{ordQtt}}</td>' +
                                // '<td>{{saleAmt}}<br>{{dcAmt}}</td>' +
                                        '</tr>',
                            templateMgr = new Dmall.Template(template),
                            templateMgr3 = new Dmall.Template(template3),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            if(obj.goodsNo) {
                                obj.goodsNo = '['+ obj.goodsNo +']';
                            }

                            if(obj.memberNm) {
                                obj.vstrNm = obj.memberNm;
                            } else {
                                obj.vstrNm = obj.noMemberNm;
                            }

                            obj.salePrice = obj.salePrice ? Dmall.common.numberWithCommas(obj.salePrice) : obj.salePrice;
                            obj.supplyPrice = obj.supplyPrice ? Dmall.common.numberWithCommas(obj.supplyPrice) : obj.supplyPrice;
                            obj.saleAmt = obj.saleAmt ? Dmall.common.numberWithCommas(obj.saleAmt) : obj.saleAmt;
                            obj.dcAmt = obj.dcAmt ? Dmall.common.numberWithCommas(obj.dcAmt) : obj.dcAmt;

                            tr += templateMgr.render(obj);
                            if(obj.cancelYn == 'Y') {
                                template2 =     '<td>' + obj.visitStatusNm + '<br>(예약취소)</td>';
                            } else {
                                template2 = '<td>' + obj.visitStatusNm + '</td>';
                            }
                            templateMgr2 = new Dmall.Template(template2);
                            tr += templateMgr2.render(obj);
                            tr += templateMgr3.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="11">데이터가 없습니다.</td></tr>';
                        }

                        $('#ajaxRsvList').html(tr);

                        dfd.resolve(result.resultList);

                        $('#cnt_search').text(result.filterdRows);
                        Dmall.GridUtil.appendPaging('form_rvs_search', 'div_paging', result, 'paging_ord', varRsv.getRsvList);
                    });
                    return dfd.promise();
                }
            }

            Number.prototype.round = function (places) {
                return +(Math.round(this + "e+" + places) + "e-" + places);
            }

            //선택된 주문상테 정보 조회
            function getSelectedOrdStatus(){
                var selected = [];
                $('#ord_status input:checkbox').each(function() {
                    if($(this).prop('checked')) {
                        selected.push($(this).val());
                    }
                });
                /*$("#ord_status").find('input[name*="ordDtlStatusCd"]').each(function() {
                    console.log("goodsNo = ", $(this).text());
                    console.log("goodsNo = ", $(this).val());
                    selected.push($(this).children('td').eq(4).text());
                });*/
                if (selected.length < 1) {
                    //alert('선택된 상품이 없습니다.');
                    return false;
                }
                return selected;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    주문 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">예약 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form id="form_excel_dn">
                        <input type="hidden" name="rsvNos" id="rsvNos"/>
                    </form:form>
                    <form:form id="form_rvs_search">
                        <input type="hidden" name="page" id="hd_page" value="1"/>
                        <div class="search_tbl">
                            <table summary="이표는 주문 관리 검색 표 입니다. 구성은 주문일, 주문상태, 결제수단, 판매환경, 판매채널, 회원구분, 검색어 입니다.">
                                <caption>주문 관리 검색</caption>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>방문일</th>
                                    <td>
                                        <tags:calendar from="rsvDayS" to="rsvDayE" fromValue="${so.rsvDayS}" toValue="${so.rsvDayE}" hasTotal="false" idPrefix=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>예약 상태</th>
                                    <td>
                                        <a href="#none" class="all_choice  mr20"><span class="ico_comm"></span> 전체</a>
                                        <label for="chack05_1" class="chack mr20 <c:if test="${fn:contains(strRsvType, 'V')}">on</c:if>">
                                            <span class="ico_comm">
                                                <input type="checkbox" name="rsvType" id="chack05_1" class="blind" value="V" <c:if test="${fn:contains(strRsvType, 'V')}">checked</c:if>>
                                            </span>
                                            방문예약
                                        </label>
                                        <label for="chack05_1" class="chack mr20 <c:if test="${fn:contains(strRsvType, 'G')}">on</c:if>">
                                            <span class="ico_comm">
                                                <input type="checkbox" name="rsvType" id="chack05_2" class="blind" value="G" <c:if test="${fn:contains(strRsvType, 'G')}">checked</c:if>>
                                            </span>
                                            상품예약
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품군</th>
                                    <td>
                                        <a href="#none" class="all_choice  mr20"><span class="ico_comm"></span> 전체</a>
                                        <tags:checkboxs codeStr="04:콘택트렌즈;03:안경렌즈" name="goodsTypeCd" idPrefix="goodsTypeCd"/>
                                    </td>
                                </tr>
<%--                                <tr id="ord_status">--%>
<%--                                    <th>주문상태</th>--%>
<%--                                    <td>--%>
<%--                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>--%>

<%--                                        <c:set var="checked" value=""/>--%>
<%--                                        <c:set var="on" value=""/>--%>
<%--                                        <c:forEach var="dtlStatusCd" items="${codeOnList}" varStatus="status">--%>
<%--                                            <label for="ordDtlStatusCd1_${status.count}" class="chack mr20${on}">--%>
<%--                                                <span class="ico_comm">&nbsp;</span>--%>
<%--                                                <input type="checkbox" name="ordDtlStatusCd"--%>
<%--                                                       id="ordDtlStatusCd1_${status.count}" class="blind"--%>
<%--                                                       value="<c:out value="${dtlStatusCd.dtlCd}"/>" ${checked}/>--%>
<%--                                                <span class="txt <c:out value="${dtlStatusCd.userDefien5}"/>">--%>
<%--                                                <c:choose>--%>
<%--                                                    <c:when test="${dtlStatusCd.dtlCd eq '30'}">--%>
<%--                                                        MD확정--%>
<%--                                                    </c:when>--%>
<%--                                                    <c:otherwise>--%>
<%--                                                        <c:out value="${dtlStatusCd.dtlNm}"/>--%>
<%--                                                    </c:otherwise>--%>
<%--                                                </c:choose>--%>
<%--                                                </span>--%>
<%--                                            </label>--%>
<%--                                            <c:set var="checked" value=""/>--%>
<%--                                            <c:set var="on" value=""/>--%>
<%--                                        </c:forEach>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
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
                                            <label for="sel_id_searchCd"></label>
                                            <select id="sel_id_searchCd" name="searchCd">
                                                <tags:option codeStr="02:매장명;03:방문자;04:아이디;05:이메일;06:휴대폰;07:상품명;08:상품코드" value="${so.searchCd}"/>
                                            </select>
                                        </span>
                                        <span class="intxt long">
                                            <input type="text" id="searchWord" name="searchWord"/>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </form:form>
                    <div class="btn_box txtc">
                        <button class="btn green" id="rsv_search_btn">검색</button>
                    </div>
                </div>

                <div class="line_box">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="be" id="cnt_search">0</strong>개의 주문이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="excelDown">
                                <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <div class="tblh ">
                        <table summary="이표는 주문 관리 리스트 표 입니다. 구성은 선택, 번호, 주문상태,주문일시, 환경, 주문번호, 상품번호, 주문상품, 출고, 수신자/주문자, 결제수단, 결제금액, 결제일시, 판매채널 입니다.">
                            <caption>
                                주문 관리 리스트
                            </caption>
                            <colgroup>
                                <col width="2%" />
                                <col width="4%" />
                                <col width="6%" />
<%--                                <col width="8%" />--%>
                                <col width="7%" />
<%--                                <col width="11%" />--%>
                                <col width="7%" />
                                <col width="15%" />
                                <col width="7%" />
                                <col width="8%" />
                                <col width="6%" />
                                <col width="7%" />
                                <col width="5%" />
<%--                                <col width="7%" />--%>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="allcheck" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="allcheck"></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>예약<br>상태</th>
<%--                                <th>주문<br>일시</th>--%>
                                <th>매장</th>
<%--                                <th>주문<br>번호</th>--%>
                                <th>방문<br>일시</th>
                                <th>상품명<br>상품코드</th>
                                <th>옵션</th>
                                <th>판매자</th>
                                <th>방문자</th>
                                <th>판매가<br>공급가</th>
                                <th>수량</th>
<%--                                <th>결제금액<br>할인금액</th>--%>
                            </tr>
                            </thead>
                            <tbody id="ajaxRsvList">
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <div class="pageing" id="div_paging"></div>
                    </div>
                </div>
            </div>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_delete">선택 삭제</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_cancel">예약 취소</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>