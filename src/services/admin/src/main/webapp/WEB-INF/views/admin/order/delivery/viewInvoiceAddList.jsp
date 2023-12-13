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
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 송장 일괄 등록</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            jQuery(document).ready(function() {
                jQuery("#tr_div_data_template").hide();
                jQuery('#tr_no_div_data').show();
             // 검색일자 기본값 선택
                jQuery('#btn_srch_cal_1').trigger('click');
                jQuery('#btn_excelDown').on('click', function(e) {
                    jQuery('#form_excel_search').attr('action', '/admin/order/delivery/invoice-temp-download');
                        jQuery('#form_excel_search').submit();
                });
                jQuery('#btn_excelUp').on('click', function(e) {
                    excelUpload();
                });
                // 목록
                jQuery('#btn_list').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    goToDeliveryList();
                });
                var url2 = '/admin/order/delivery/site-courier-list';
                var s = $('#div_rlsCourierCd');
                Dmall.AjaxUtil.getJSON(url2, null, function(result2) {
                    // 택배사 목록
                    $("<option />", {value: '', text: '선택'}).appendTo(s);
                    /*$("<option />", {value: '00', text: '직접배송'}).appendTo(s);*/
                    jQuery.each(result2.resultList, function(idx, obj) {
                         $("<option />", {value: obj.rlsCourierCd, text: obj.rlsCourierNm}).appendTo(s);
                    });
                });
                /**
                    송장일괄 등록하기
                */
                jQuery('#btn_reg').on('click', function(e) {
                    var url = '/admin/order/delivery/invoice-all-insert',
    //                param = jQuery('#form_excel_list').serialize(),
                    dfd = jQuery.Deferred();
                    var comma = ',';
                    var ordNoArr = '', ordDtlSeqArr = '', rlsCourierCdArr = '', rlsInvoiceNoArr='',
                    ordQttArr = '', ordDtlStatusCdArr = '', goodsNoArr = '', returnval=true;
                    $('input[name=ordNo]').map(function() {
                        ordNoArr += ($(this).val());
                        ordNoArr += comma;
                    });
                    if(ordNoArr==',') {
                        Dmall.LayerUtil.alert('등록할 파일을 먼저 업로드하세요');
                        return;
                    }
                    $('input[name=ordDtlSeq]').map(function() {
                        ordDtlSeqArr += ($(this).val());
                        ordDtlSeqArr += comma;
                    });

                    $('input[name=ordDtlStatusCd]').map(function() {
                        ordDtlStatusCdArr += ($(this).val());
                        ordDtlStatusCdArr += comma;
                    });

                    $('select[name=rlsCourierCd]').map(function(index) {
                        if(index>0 && $(this).val()=='') {
                            Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.noCourierCd"/>');
                            returnval = false;
                        }else{
                            rlsCourierCdArr += ($(this).val());
                            rlsCourierCdArr += comma;

                        }
                    });
                    if(!returnval){return false;}


                    $('input[name=rlsInvoiceNo]').map(function(index) {
                        if(index > 0 && $(this).val()=='') {
                            Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.noInvoice"/>');
                            returnval = false;
                        }
                        rlsInvoiceNoArr += ($(this).val());
                        rlsInvoiceNoArr += comma;
                    });
                    if(!returnval){return false;}

                    $('input[name=ordQtt]').map(function() {
                        ordQttArr += ($(this).val());
                        ordQttArr += comma;
                    });

                    $('input[name=goodsNo]').map(function() {
                        goodsNoArr += ($(this).val());
                        goodsNoArr += comma;
                    });

                    var param = {ordNoArr : ordNoArr, ordDtlSeqArr : ordDtlSeqArr, rlsCourierCdArr : rlsCourierCdArr,
                            rlsInvoiceNoArr : rlsInvoiceNoArr, dlvrQttArr : ordQttArr, ordDtlStatusCdArr : ordDtlStatusCdArr,
                            goodsNoArr : goodsNoArr};

    //                Dmall.FormUtil.submit(url, param);
                      Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            $("#tbody_div_data").find(".searchDivResult").each(function() {
                                $(this).remove();
                            });

                            jQuery("#tr_div_data_template").hide();
                            jQuery('#tr_no_div_data').show();
                        }
                    });
                });
                //파일 업로드
                $('#ex_file1_id').on('change', function(e) {
                    var files = e.originalEvent.target.files;
                    var totalFileSize=0;
                    for (var i = 0; i < files.length; i++){
                        totalFileSize = totalFileSize + files[i].size;
                    }
                    if(totalFileSize>5242880){
                        Dmall.LayerUtil.alert('파일은 최대 5Mbyte까지 등록 가능합니다.');
                        $("#ex_file1_id").replaceWith( $("#ex_file1_id").clone(true) );
                        $("#excel").val("");
                        return;
                    }

                    var ext = jQuery(this).val().split('.').pop().toLowerCase();
                    if($.inArray(ext, ['xls','xlsx']) == -1) {
                        Dmall.LayerUtil.alert('xls,xlsx 파일만 업로드 할수 있습니다.');
                        $("#ex_file1_id").replaceWith( $("#ex_file1_id").clone(true) );
                        $("#excel").val("");
                        return;
                    }
                    document.getElementById('file_route1').value=this.value;
                });

            });
            /**
            해당 열 삭제
            */
            function rowDelete(data, obj, bindName, target, area, row) {
                var rowId = data["ordNo"]+data["ordDtlSeq"];
                obj.off("click").on('click', function() {
                    $('#tr'+rowId).remove();
                });
            }
            function excelUpload() {
                $("#tbody_div_data").find(".searchDivResult").each(function() {
                    $(this).remove();
                });

                jQuery("#tr_div_data_template").hide();
                jQuery('#tr_no_div_data').show();

                if(jQuery('#file_route1').val()=='파일선택')
                    return;
                console.log("excelUpload");
                if(Dmall.validate.isValid('form_excel_insert')) {
                    //var url = '/admin/order/delivery/invoice-upload';
                    var url = '/admin/order/delivery/invoice-excel-download';

                    var param = $('#form_excel_insert').serialize();
                    if (Dmall.FileUpload.checkFileSize('form_excel_insert')) {
                        $('#form_excel_insert').ajaxSubmit({
                            url : url,
                            dataType : 'json',
                            success : function(result){
                                Dmall.validate.viewExceptionMessage(result, 'form_excel_insert');

                                if(result.totalRows !=0 && result.success){
                                    $("#tbody_div_data").find(".searchDivResult").each(function() {
                                        $(this).remove();
                                    });

                                    jQuery("#tr_div_data_template").hide();
                                    jQuery('#tr_no_div_data').show();

                                    // 취득결과 셋팅
                                    jQuery.each(result.resultList, function(idx, obj) {
                                        var trId = 'tr' + obj.ordNo + obj.ordDtlSeq;
                                        var $tmpSearchResultTr = "";

                                        var $tmpSearchResultTr = $("#tr_div_data_template").clone().show().removeAttr("id");
                                        $($tmpSearchResultTr).attr("id", trId).addClass("searchDivResult");

                                        $('[data-bind="divInfo"]', $tmpSearchResultTr).DataBinder(obj);
                                        $("#tbody_div_data").append($tmpSearchResultTr);
                                    });
                                    // 결과가 없을 경우 NO DATA 화면 처리
                                    if ( $("#tbody_div_data").find(".searchDivResult").length < 1 ) {
                                        jQuery('#tr_no_div_data').show();
                                    } else {
                                        jQuery('#tr_no_div_data').hide();
                                    }

                                } else if(!result.success){
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        });
                    }
                }
            }
            // 송장 일괄 등록
            function goToDeliveryList() {
                location.href = '/admin/order/delivery/delivery';
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box pb">
            <div class="tlt_box">
                <div class="tlt_head">
                    주문 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">송장 입력 관리</h2>
            </div>

            <div class="line_box pb">
                <h3 class="tlth3">송장 입력 대량 등록</h3>
                <!-- tblw -->
                <div class="tblw">
                    <table summary="이표는 송장 일괄 등록 표 입니다. 구성은 결제일, 파일업로드 입니다.">
                        <caption>송장 일괄 등록</caption>
                        <colgroup>
                            <col width="150px" />
                            <col width="" />
                        </colgroup>
                        <tbody>
                        <form:form id="form_excel_search">
                            <tr>
                                <th>결제일</th>
                                <td>
                                    <tags:calendar from="ordDayS" to="ordDayE"  hasTotal="false" idPrefix="srch" />
                                    <button class="btn_exl" id="btn_excelDown">
                                        <span>Excel download</span>
                                        <img src="/admin/img/icons/icon-excel_down.png"
                                             alt="excel icon"/>
                                    </button>
                                </td>
                            </tr>
                        </form:form>
    <%--                    <form:form id="form_excel_insert" action="javascript:excelUpload()" enctype="multipart/form-data">--%>
    <%--                        <tr>--%>
    <%--                            <th>파일업로드</th>--%>
    <%--                            <td>--%>
    <%--                                <span class="intxt"><input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled"></span>--%>
    <%--                                <label class="filebtn" for="ex_file1_id">파일찾기</label>--%>
    <%--                                <input class="filebox" type="file" name="excel" id="ex_file1_id" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">--%>
    <%--                            </td>--%>
    <%--                        </tr>--%>
    <%--                    </form:form>--%>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <!-- tblh -->

                <div class="top_lay mt10">
                    <div class="select_btn_right">
                        <form:form id="form_excel_insert" action="javascript:excelUpload()" enctype="multipart/form-data">
                        <span class="intxt"><input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled"></span>
                        <label class="filebtn" for="ex_file1_id">파일찾기</label>
                        <input class="filebox" type="file" name="excel" id="ex_file1_id" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
                        <button class="btn_exl" id="btn_excelUp">
                            <span>Excel upload</span>
                            <img src="/admin/img/icons/icon-excel_up.png"
                                    alt="excel icon"/>
                        </button>
                        </form:form>
                    </div>
                </div>
                <div class="tblh">
                    <div class="scroll">
                        <table id="DIV_TABLE" summary="이표는 송장 일괄 등록 리스트 표 입니다. 구성은 삭제, 상품명, 상품옵션, 주문번호, 상태, 주문자명, 주문수량, 배송처리 된 수량, 배송처리가능 수량, 배송업체(업체코드), 송장번호, 주소 입니다.">
                            <caption>송장 일괄 등록 리스트</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="*">
                                <col width="8%">
                                <col width="8%">
                                <col width="6%">
                                <col width="6%">
                                <col width="5%">
                                <col width="5%">
                                <col width="5%">
                                <col width="6%">
                                <col width="6%">
                                <col width="10%">
                                <col width="7%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>삭제</th>
                                    <th>상품명</th>
                                    <th>상품옵션</th>
                                    <th>주문번호</th>
                                    <th>상태</th>
                                    <th>주문자명</th>
                                    <th>주문수량</th>
                                    <th>배송처리<br>수량</th>
                                    <th>배송처리가능<br>수량</th>
                                    <th>배송업체<br>(업체코드)</th>
                                    <th>송장번호</th>
                                    <th colspan="2">주소</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_div_data">
                            <form:form id="form_excel_list">
                                <input type="hidden" name="siteNo" value="${siteNo}" />
                                <tr id="tr_div_data_template" >
                                    <td id="del_btn">
                                        <input type="hidden" name="ordQtt" id="div_ordQtt" data-bind="divInfo" data-bind-type="Text" data-bind-value="ordQtt">
                                        <input type="hidden" name="ordNo" id="div_ordNo" data-bind="divInfo" data-bind-type="Text" data-bind-value="ordNo">
                                        <input type="hidden" name="ordDtlSeq" id="div_ordDtlSeq" data-bind="divInfo" data-bind-type="Text" data-bind-value="ordDtlSeq">
                                        <input type="hidden" name="ordDtlStatusCd" id="div_ordDtlStatusCd" data-bind="divInfo" data-bind-type="Text" data-bind-value="ordDtlStatusCd">
                                        <input type="hidden" name="goodsNo" id="div_goodsNo" data-bind="divInfo" data-bind-type="Text" data-bind-value="goodsNo">

                                        <button class="btn_gray" data-bind="divInfo" data-bind-value="ordNo" data-bind-type="function" data-bind-function="rowDelete">삭제</button>
                                    </td>
                                    <td class="txtl" data-bind="divInfo" data-bind-value="goodsNm" data-bind-type="string"></td>
                                    <td data-bind="divInfo" data-bind-value="itemNm" data-bind-type="string" ></td>
                                    <td data-bind="divInfo" data-bind-value="ordNo" data-bind-type="string"></td>
                                    <td data-bind="divInfo" data-bind-value="ordDtlStatusNm" data-bind-type="string"></td>
                                    <td data-bind="divInfo" data-bind-value="ordrNm" data-bind-type="string"></td>
                                    <td data-bind="divInfo" data-bind-value="ordQtt" data-bind-type="number" ></td>
                                    <td data-bind="divInfo" data-bind-value="dlvrQtt" data-bind-type="number" ></td>
                                    <td data-bind="divInfo" data-bind-value="ordQtt" data-bind-type="number" ></td>
                                    <td>
                                        <span class="select" id="span_courierCd_template">
                                            <label for="div_rlsCourierCd"></label>
                                            <select name="rlsCourierCd" id="div_rlsCourierCd" data-bind="divInfo" data-bind-value="rlsCourierCd" data-bind-type="labelselect">
                                            </select>
                                        </span>
                                    </td>
                                    <td><span class="intxt wid100p"><input id="div_rlsInvoiceNo" name="rlsInvoiceNo" data-bind="divInfo" data-bind-value="rlsInvoiceNo" data-bind-type="text"></span></td>
                                    <td data-bind="divInfo" data-bind-value="roadnmAddr" data-bind-type="string">주소정보</td>
                                    <td data-bind="divInfo" data-bind-value="dtlAddr" data-bind-type="string">주소정보</td>
                                </tr>
                                <tr id="tr_no_div_data"><td colspan="12">데이터가 없습니다.</td></tr>
                             </form:form>
                            </tbody>
                        </table>
                    </div>
                </div>
                <ul class="desc_list mt60">
                    <li>주문결제일 선택 > 엑셀다운로드 > 정보입력(출고할 실물수량 입력, 배송업체코드, 송장번호) > 엑셀파일저장 > 엑셀업로드 > 등록</li>
                    <li>다운로드 받은 엑셀 양식을 유지한 후 출고할 실물수량 / 배송업체(업체코드) / 송장번호 입력 후 저장</li>
                    <li>빈 칸(입력란) 외에 미리 입력된 값을 임의로 변경하거나 오타 혹은 유효하지 않은 값을 입력시에 오류가 발생합니다.</li>
                    <li>행삭제는 화면상의 출고대상목록에서 제외되며 데이터 삭제와는 무관합니다.</li>
                    <li>배송업체는 반드시 업체코드로 입력해주세요. 현대택배(X), 01(O)
                    <c:set var="halfSize" value="${fn:length(courierCdList)/2}"/>
                        <div class="desc_box mt20">
                            <div class="tblh w50p">
                                <table summary="이표는 택배사 코드 리스트 표입니다.">
                                    <caption>
                                        택배사 코드
                                    </caption>
                                    <colgroup>
                                        <col width="25%" />
                                        <col width="25%" />
                                        <col width="25%" />
                                        <col width="25%" />
                                    </colgroup>
                                    <tbody>
                                        <c:set var="i" value="0" />
                                        <c:set var="j" value="2" />
                                        <c:forEach var="listCd" items="${courierCdList}" varStatus="status">
                                            <c:if test="${i%j == 0 }">
                                            <tr>
                                            </c:if>
                                                <th><span>${listCd.dtlNm}</span></th>
                                                <td>${listCd.dtlCd}</td>
                                            <c:if test="${status.count%j == 0}">
                                            </tr>
                                            </c:if>
                                            <c:set var="i" value="${i+1}" />
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>

            <div class="bottom_box">
                <div class="left">
                    <div class="pop_btn">
                        <button class="btn--big btn--big-white" id="btn_list">
                            목록
                        </button>
                    </div>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_reg">저장</button>
                </div>
            </div>
        </div>
        </t:putAttribute>
    </t:insertDefinition>