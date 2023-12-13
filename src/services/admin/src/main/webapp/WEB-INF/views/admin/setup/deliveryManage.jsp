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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">택배사관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 화면 초기화
                $("#tr_search_data_template").hide();
                $('#tr_no_search_data').show();
                
                // 검색
                $('#btn_id_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#hd_page').val('1');
                    fn_getSearchData();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });

                // 택배사등록
                $('#btn_regist').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    courierManagePopup.resetCourierPop();
                    Dmall.LayerPopupUtil.open($('#layer_id_delivery_manage'));
                });

                fn_getSearchData();
                
                Dmall.common.date();

                courierManagePopup.init();
            });
            
            // 검색 함수
            function fn_getSearchData() {
                var url = '/admin/setup/delivery/courier-list-paging',
                    param = $('#form_id_search').serialize(),
                    dfd = jQuery.Deferred();            

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }

                    $("#tbody_search_data").find(".searchResult").each(function() {
                        $(this).remove();
                    });
                    
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        fn_bindRowData(obj);
                    });
                    dfd.resolve(result.resultList);
                    
                    // 결과가 없을 경우 NO DATA 화면 처리
                    if ( $("#tbody_search_data").find(".searchResult").length < 1 ) {
                        $('#tr_no_search_data').show();
                    } else {
                        $('#tr_no_search_data').hide();
                    }
                    
                    Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_search_list', fn_getSearchData);
                });
                return dfd.promise();
            }

            // 결과 바인딩
            function fn_bindRowData(rowData) {
                var $tmpSearchRow = $("#tr_search_data_template").clone().show().removeAttr("id");
                var trId = "tr_" + rowData.courierCd;
                $($tmpSearchRow).attr("id", trId).addClass("searchResult");
                $('[data-bind="resultRow"]', $tmpSearchRow).DataBinder(rowData);
                $("#tbody_search_data").append($tmpSearchRow);
            }

            // 등록일 바인딩 함수
            function fn_setRegDate(data, obj, bindName, target, area, row) {
                obj.html(data["regDttm"]);
            }

            // 수정 바인딩 함수
            function fn_setRowEditBtn(data, obj, bindName, target, area, row) {
                obj.off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var url = '/admin/setup/delivery/courier',
                        param = {courierCd: data["courierCd"]};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            courierManagePopup.editCourierPop(result.data);
                        }
                    });
                });
            }
            // 삭제 바인딩 함수
            function fn_setRowDeleteBtn(data, obj, bindName, target, area, row) {
                obj.off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    Dmall.LayerUtil.confirm('정말로 삭제하시겠습니까?', function() {
                        var url = '/admin/setup/delivery/courier-delete',
                            param = {courierCd : data["courierCd"]};

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                            // 검색결과 재실행
                            fn_getSearchData();
                        });
                    });
                });
            }

            // 팝업관리 객체
            var courierManagePopup = {
                isCheked: false,
                init: function() {
                    // 택배사명 입력 이벤트
                    $('#input_id_courierNm').on('change', function() {
                        courierManagePopup.isCheked = false;
                    });

                    // 중복확인
                    $('#btn_id_checkDuplication').on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        if($.trim($('#input_id_courierNm').val()).length === 0) {
                            Dmall.LayerUtil.alert('택배사명을 입력해주세요.');
                            return;
                        }

                        var url = '/admin/setup/delivery/courier',
                            param = {courierNm: $('#input_id_courierNm').val()};

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.data) {
                                Dmall.LayerUtil.alert('중복된 택배사입니다.<br>다른 택배사를 입력해주세요.');
                                $('#input_id_courierNm').val('').focus();
                            } else {
                                Dmall.LayerUtil.alert('등록가능한 택배사입니다.');
                                courierManagePopup.isCheked = true;
                            }
                        });
                    });

                    // 저장
                    $('#btn_id_saveCourier').on('click', function() {
                        if(courierManagePopup.isCheked !== true) {
                            Dmall.LayerUtil.alert('중복확인을 먼저 해주세요.');
                            return;
                        }

                        var url = '/admin/setup/delivery/courier-insert',
                            param = $('#form_id_courier_add').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                fn_getSearchData();
                                Dmall.LayerPopupUtil.close();
                            }
                        });
                    });
                },
                resetCourierPop: function() {
                    var $layer = $('#layer_id_delivery_manage');
                    $layer.find('#courier_pop_title').text('택배사 등록');
                    $layer.find('form')[0].reset();
                    $layer.find('#input_id_courierCd').val('999');
                    courierManagePopup.isCheked = false;
                },
                editCourierPop: function(data) {
                    courierManagePopup.resetCourierPop();

                    var $layer = $('#layer_id_delivery_manage');
                    // 타이틀 수정
                    $layer.find('#courier_pop_title').text('택배사 수정');
                    // hidden input 설정
                    $layer.find('#input_id_courierCd').val(data.courierCd);
                    // input 설정
                    $layer.find('#input_id_courierNm').val(data.courierNm);
                    $layer.find('input:radio[value='+data.useYn+']')
                        .prop('checked', true)
                        .parents('label').addClass('on').siblings().removeClass('on');

                    courierManagePopup.isCheked = true;
                    Dmall.LayerPopupUtil.open($layer);
                }
            }






            // // 가격 화면 표시 설정
            // function fn_setDlvrcPrice(data, obj, bindName, target, area, row) {
            //     var dlvrc = data["dlvrc"];
            //    if ( null == dlvrc || $.isEmptyObject(dlvrc)) {
            //        dlvrc = 0;
            //    }
            //     obj.html(parseInt(dlvrc).getCommaNumber() + " " + "원");
            // }
            // // 수정 버튼 클릭시 이벤트 설정
            // function fn_executeRowEdit(obj) {
            //     Dmall.FormUtil.submit('/admin/setup/delivery/courier-info', {courierCd : obj.data("courierCd")});
            // }
            // // 택배사 추가 버튼 클릭시 이벤트 설정
            // function fn_regist() {
            //     Dmall.FormUtil.submit('/admin/setup/delivery/courier-info', {courierCd : ''});
            // }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span> 기본 관리<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">택배사 관리</h2>
            </div>
            <div class="line_box">
                <div class="top_lay">
                    <div class="select_btn_left">
                        <form id="form_id_search">
                            <input type="hidden" name="page" id="hd_page" value="1">
                            <input type="hidden" name="searchType" value="1">
                            <span class="intxt search_bar">
                                <input name="searchWord" id="input_search_word" placeholder="택배사명으로 검색해주세요" type="text" maxlength="16">
                            </span>
                            <button class="search_bar_btn" id="btn_id_search">검색</button>
                        </form>
                    </div>
                    <div class="select_btn_right">
                        <a href="#none" class="btn_gray2" id="btn_regist">택배사 등록</a>
                    </div>
                </div>
                <div class="tblh th_l">
                    <table>
                        <colgroup>
                            <col width="6%">
                            <col width="45%">
                            <col width="12%">
                            <col width="20%">
                            <col width="17%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>NO</th>
                            <th>택배사명</th>
                            <th>사용여부</th>
                            <th>등록일시</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_search_data">
                        <tr id="tr_search_data_template" >
                            <td data-bind="resultRow" data-bind-type="number" data-bind-value="rownum"></td>
                            <td data-bind="resultRow" data-bind-type="string" data-bind-value="courierNm"></td>
                            <td data-bind="resultRow" data-bind-type="string" data-bind-value="viewUseYn"></td>
                            <td data-bind="resultRow" data-bind-value="courierCd" data-bind-type="function" data-bind-function="fn_setRegDate"></td>
                            <td>
                                <button class="btn_gray" data-bind="resultRow" data-bind-value="courierCd" data-bind-type="function" data-bind-function="fn_setRowEditBtn">수정</button>
                                <button class="btn_gray" data-bind="resultRow" data-bind-value="courierCd" data-bind-type="function" data-bind-function="fn_setRowDeleteBtn">삭제</button>
                            </td>
                        </tr>
                        <tr id="tr_no_search_data"><td colspan="5">데이터가 없습니다.</td></tr>
                        </tbody>
                    </table>
                </div>
                <div class="bottom_lay">
                    <div class="pageing"  id="div_id_paging"></div>
                </div>
            </div>
        </div>
        <!-- 팝업 -->
        <div id="layer_id_delivery_manage" class="layer_popup">
            <div class="pop_wrap size3">
                <div class="pop_tlt">
                    <h2 class="tlth2" id="courier_pop_title">택배사 등록</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <div class="pop_con">
                    <div>
                        <form action="" id="form_id_courier_add">
                            <input type="hidden" name="courierCd" id="input_id_courierCd" value="999">
                            <div class="tblw mt0">
                                <table>
                                    <colgroup>
                                        <col width="20%">
                                        <col width="80%">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>택배사명</th>
                                        <td>
                                            <span class="intxt long3"><input type="text" name="courierNm" id="input_id_courierNm"></span>
                                            <button class="btn--white btn--small" id="btn_id_checkDuplication">중복확인</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>사용여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:사용;N:사용안함" name="useYn" idPrefix="useYn" value="Y"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </form>
                        <div class="btn_box txtc">
                            <button class=" btn--blue_small" id="btn_id_saveCourier">저장</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- //팝업 -->




<%--        <div class="sec01_box">--%>
<%--            <div class="tlt_box">--%>
<%--                <h2 class="tlth2">택배사 관리 </h2>--%>
<%--                <!-- <div class="btn_box left">--%>
<%--                    <button class="btn green" id="btn_search">검색</button>--%>
<%--                </div> -->--%>
<%--                <div class="btn_box right">--%>
<%--                    <a href="#none" class="btn blue"  id="btn_regist">택배사 추가</a>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            --%>
<%--        <!-- search_box -->--%>
<%--        <form:form id="form_id_search" >--%>
<%--        <input type="hidden" name="page" id="hd_page" value="1" />--%>
<%--        <input type="hidden" name="sord" id="hd_srod" value="" />--%>
<%--        <input type="hidden" name="rows" id="hd_rows" value="" />--%>
<%--        --%>
<%--        <!-- search_tbl -->--%>
<%--        <div class="search_box">--%>
<%--            <!-- search_tbl -->--%>
<%--            <div class="search_tbl">--%>
<%--                <table summary="이표는 택배사 관리 검색 표 입니다. 구성은 등록일, 검색어 입니다.">--%>
<%--                    <caption>택배사 관리 검색</caption>--%>
<%--                    <colgroup>--%>
<%--                        <col width="15%">--%>
<%--                        <col width="85%">--%>
<%--                    </colgroup>--%>
<%--                    <tbody>--%>
<%--                        <tr>--%>
<%--                            <th>등록일</th>--%>
<%--                            <td>--%>
<%--                                <span class="select">--%>
<%--                                    <label for="sel_search_date_type"></label>--%>
<%--                                    <select name="searchDateType" id="sel_search_date_type">>--%>
<%--                                        <tags:option codeStr="1:등록일;2:수정일" />--%>
<%--                                    </select>--%>
<%--                                </span>--%>
<%--                                <span class="intxt"><input type="text" name="searchDateFrom" id="txt_search_date_from" class="bell_date_sc date"></span>--%>
<%--                                <a href="#calendar"class="date_sc ico_comm" id="bell_date01">달력이미지</a>--%>
<%--                                ~--%>
<%--                                <span class="intxt"><input type="text" name="searchDateTo" id="txt_search_date_to" class="bell_date_sc date"></span>--%>
<%--                                <a href="#calendar" class="date_sc ico_comm" id="bell_date02">달력이미지</a>--%>
<%--                                <div class="tbl_btn ml0">--%>
<%--                                    <button class="btn_day on" id="btn_cal_1" ><span></span>오늘</button>--%>
<%--                                    <button class="btn_day" id="btn_cal_2" ><span></span>3일간</button>--%>
<%--                                    <button class="btn_day" id="btn_cal_3" ><span></span>일주일</button>--%>
<%--                                    <button class="btn_day" id="btn_cal_4" ><span></span>1개월</button>--%>
<%--                                    <button class="btn_day" id="btn_cal_5" ><span></span>3개월</button>--%>
<%--                                    <button class="btn_day" id="btn_cal_6" ><span></span>전체</button>--%>
<%--                                </div>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>검색어</th>--%>
<%--                            <td>--%>
<%--                                <div class="select_inp">--%>
<%--                                    <span>--%>
<%--                                        <label for="sel_search_type"></label>--%>
<%--                                        <select name="searchType" id="sel_search_type" >--%>
<%--                                            <tags:option codeStr="1:택배사명;2:택배사코드" />--%>
<%--                                        </select>--%>
<%--                                    </span>--%>
<%--                                    <input type="text" name="searchWord" id="txt_search_word" />--%>
<%--                                </div>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                    </tbody>--%>
<%--                </table>--%>
<%--            </div>--%>
<%--            <!-- //search_tbl -->--%>
<%--			<div class="btn_box txtc">--%>
<%--                <button class="btn green" id="btn_search">검색</button>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--        </form:form>--%>
<%--        <!-- //search_box -->--%>
<%--        --%>
<%--        --%>
<%--        <!-- line_box -->--%>
<%--        <div class="line_box">--%>
<%--            <!-- tblh -->--%>
<%--            <div class="tblh th_l">--%>
<%--                <table summary="이표는 택배사 관리 리스트 표 입니다. 구성은  입니다.">--%>
<%--                    <caption>택배사 관리 리스트</caption>--%>
<%--                    <colgroup>--%>
<%--                        <col width="6%">--%>
<%--                        <col width="60%">--%>
<%--                        <col width="10%">--%>
<%--                        &lt;%&ndash; <col width="10%"> &ndash;%&gt;--%>
<%--                        <col width="10%">--%>
<%--                        <col width="14%">--%>
<%--                    </colgroup>--%>
<%--                    <thead>--%>
<%--                        <tr>--%>
<%--                            <th>순번</th>--%>
<%--                            <th>택배사명</th>--%>
<%--                            <th>사용여부</th>--%>
<%--                            &lt;%&ndash; <th>배송비</th> &ndash;%&gt;--%>
<%--                            <th>등록일</th>--%>
<%--                            <th>관리</th>--%>
<%--                        </tr>--%>
<%--                    </thead>--%>
<%--                    <tbody id="tbody_search_data">--%>
<%--                        <tr id="tr_search_data_template" >--%>
<%--                            <td data-bind="resultRow" data-bind-type="number" data-bind-value="rownum"></td>--%>
<%--                            <td data-bind="resultRow" data-bind-type="string" data-bind-value="courierNm"></td>--%>
<%--                            <td data-bind="resultRow" data-bind-type="string" data-bind-value="viewUseYn"></td>--%>
<%--                            &lt;%&ndash; <td data-bind="resultRow" data-bind-value="courierCd" data-bind-type="function" data-bind-function="fn_setDlvrcPrice"></td> &ndash;%&gt;--%>
<%--                            <td data-bind="resultRow" data-bind-value="courierCd" data-bind-type="function" data-bind-function="fn_setRegDate"></td>--%>
<%--                            <td>--%>
<%--                                <button class="btn_gray" data-bind="resultRow" data-bind-value="courierCd" data-bind-type="function" data-bind-function="fn_setRowEditBtn">수정</button>--%>
<%--                                <button class="btn_gray" data-bind="resultRow" data-bind-value="courierCd" data-bind-type="function" data-bind-function="fn_setRowDeleteBtn">삭제</button>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                         <tr id="tr_no_search_data"><td colspan="5">데이터가 없습니다.</td></tr>--%>
<%--                    </tbody>--%>
<%--                </table>--%>
<%--            </div>--%>
<%--            <!-- //tblh -->--%>

<%--            <!-- bottom_lay -->--%>
<%--             <div class="bottom_lay">--%>
<%--                <div class="pageing"  id="div_id_paging"></div>--%>
<%--             </div>--%>
<%--            <!-- //bottom_lay -->--%>
<%--            --%>
<%--        </div>--%>
<%--        <!-- //line_box -->--%>
<%--    </div>--%>
<!-- //content -->


    </t:putAttribute>
</t:insertDefinition>
