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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 이벤트 &gt; 이벤트 관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function () {
                EventUtil.init();
                CmntPopUtil.init();
                WngPopUtil.init();
                ManagePopUtil.init();

                // 검색
                $('#btn_id_search_btn').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    EventUtil.search();
                });

                // 수정
                $(document).on('click', 'a.tbl_link', function () {
                    var eventNo = $(this).closest('tr').data('event-no');
                    Dmall.FormUtil.submit('/admin/promotion/event-update-form', {eventNo: eventNo});
                });

                // 댓글
                $(document).on('click', '#btn_cmnt', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var eventNo = $(this).closest('tr').data('event-no');
                    $('#eventNo').val(eventNo);
                    $('#form_eventCmnt_search').find('input[name=page]').val('1');

                    CmntPopUtil.getData();
                });

                // 당첨자
                $(document).on('click', '#btn_wng', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    WngPopUtil.eventNo = $(this).closest('tr').data('event-no');
                    $('#bind_target_id_eventNm').text(
                        $(this).closest('tr').find('a.tbl_link').html()
                    );
                    WngPopUtil.getData();
                });

                // 관리
                $(document).on('click', '#btn_manage', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var eventNo = $(this).closest('tr').data('event-no');
                    $('#manage_popup').find('input:hidden[name=eventNo]').val(eventNo);

                    Dmall.LayerPopupUtil.open($('#manage_popup'));
                    ManagePopUtil.clearPopup();
                });

                // 선택삭제
                $('#del_event_btn').on('click', function () {
                    EventUtil.deleteEvent();
                });

                // 등록
                $('#btn_regist').on('click', function () {
                    Dmall.FormUtil.submit('/admin/promotion/event-insert-form');
                });
            });

            var EventUtil = {
                init: function() {
                    // 그리드 적용
                    $('#grid_id_eventList').grid($('#form_id_search'));
                },
                search: function() {
                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm && toDttm && fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return false;
                    }

                    $("#search_id_page").val("1");
                    $("#form_id_search").submit();
                },
                deleteEvent: function () {
                    var selected = $('#eventList').find('input:checkbox[name=eventNo]:checked');
                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('삭제할 이벤트를 선택해주세요.');
                        return false;
                    }

                    var param = {};
                    $.each(selected, function (idx, obj) {
                        param['list['+idx+'].eventNo'] = $(obj).closest('tr').data('event-no');
                    });

                    var url = '/admin/promotion/event-delete';

                    Dmall.LayerUtil.confirm('삭제된 정보는 복구할 수 없습니다.<br>정말 삭제하시겠습니까?', function () {
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if(result.success) {
                                $('#btn_id_search_btn').trigger('click');
                            }
                        });
                    });
                },
            }

            var CmntPopUtil = {
                init: function () {
                    // 저장
                    $('#tbody_popup_cmnt_data').on('click', 'button.btn_gray', function (e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var lettNo = $(this).closest('tr').data('lett-no');
                        var blindPrcYn = $(this).closest('tr').find('select').val();
                        var memberNo = $(this).closest('tr').data('member-no');

                        var param = {lettNo: lettNo, eventNo: $('#eventNo').val(), blindPrcYn: blindPrcYn, memberNo: memberNo};

                        CmntPopUtil.save(param);
                    });
                },
                getData: function () {
                    var url = '/admin/promotion/event-letter-list',
                        param = $('#form_eventCmnt_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        // table 생성
                        var template =
                                '<tr data-lett-no="{{lettNo}}" data-member-no="{{memberNo}}">' +
                                '<td>{{sortNum}}</td>' +
                                '<td>{{memberNm}}</td>' +
                                '<td>{{memberNn}}</td>' +
                                '<td>{{loginId}}</td>' +
                                '<td>{{content}}</td>' +
                                '<td>{{regDt}}</td>' +
                                '<td>' +
                                '<span class="select mt0">' +
                                '<label for="">처리안함</label>' +
                                '<select class="blindPrcYn">' +
                                '{{blindPrcYn}}' +
                                '</select>' +
                                '</span>' +
                                '<button class="btn_gray pl10 pr10" style="min-width: 34px; height:34px; line-height: 32px;">저장</button>' +
                                '</td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            if(obj.blindPrcYn == 'Y') {
                                obj.blindPrcYn =
                                    '<option value="N">처리안함</option>' +
                                    '<option value="Y" selected="selected">처리</option>';
                            } else {
                                obj.blindPrcYn =
                                    '<option value="N" selected="selected">처리안함</option>' +
                                    '<option value="Y">처리</option>';
                            }

                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="7">데이터가 없습니다.</td></tr>'
                        }

                        $('#tbody_popup_cmnt_data').html(tr);
                        Dmall.GridUtil.appendPaging('form_eventCmnt_search', 'div_id_paging', result, 'paging_id_eventCmnt', CmntPopUtil.getData);

                        // 처리로그 생성
                        if(result.extraData.histList.length > 0) {
                            var template2 =
                                    '<li class="txtl">[{{histStartDttm}}] [{{memberNm}} ({{memberNn}})] [블라인드처리] {{blindPrcYn}} - {{prcrNm}}</li>',
                                templateMgr2 = new Dmall.Template(template2),
                                li = '';
                            $.each(result.extraData.histList, function (idx, obj) {
                                if(obj.blindPrcYn == 'Y') {
                                    obj.blindPrcYn = '처리'
                                } else {
                                    obj.blindPrcYn = '처리안함'
                                }

                                li += templateMgr2.render(obj);
                            });

                            $('#eventCmntHistList').html(li);
                        } else {
                            $('#eventCmntHistList').html('');
                        }

                        // popup open
                        Dmall.LayerPopupUtil.open($('#cmnt_popup'));
                    });
                },
                save: function (param) {
                    var url = '/admin/promotion/event-commentblind-update';

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if(result.success) {
                            Dmall.LayerPopupUtil.close('cmnt_popup');
                        }
                    });
                },
            }

            var WngPopUtil = {
                eventNo: '',
                init: function () {
                    // 다음에디터 초기화
                    Dmall.DaumEditor.init();
                    Dmall.DaumEditor.create('ta_id_content1');

                    // 저장
                    $('#btn_popup_wng_regist').on('click', function (e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        WngPopUtil.save();
                    });
                },
                getData: function () {
                    var url = '/admin/promotion/winning-content-select',
                        param = {eventNo: WngPopUtil.eventNo};

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        WngPopUtil.clearContent();

                        if(result.data != null) {
                            Dmall.FormUtil.jsonToForm(result.data, 'form_wng_info');
                            Dmall.DaumEditor.setContent('ta_id_content1', result.data.wngContentHtml);
                            Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages);
                        }

                        Dmall.LayerPopupUtil.open($('#wng_popup'));
                    });
                },
                save: function () {
                    var url = '';
                    if($('#form_wng_info input:hidden[name=wngContentNo]').val() == 0) {
                        url = '/admin/promotion/winning-content-insert';
                    } else {
                        url = '/admin/promotion/event-winconent-update';
                    }

                    Dmall.DaumEditor.setValueToTextarea('ta_id_content1');
                    var param = $('#form_wng_info').serialize() + '&eventNo=' + WngPopUtil.eventNo;

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        Dmall.LayerPopupUtil.close('wng_popup');
                    });
                },
                clearContent: function () {
                    Dmall.DaumEditor.clearContent();
                    $('#wngNm').val('');
                    $('#wngContentNo').val(0);
                },
            }

            var ManagePopUtil = {
                init: function () {
                    // 탭 클릭
                    $('#manage_popup li.tab-2').on('click', function () {
                        var href = $(this).children('a').attr('href');

                        switch(href) {
                            case '#tab1':
                                ManagePopUtil.getApplicantData();
                                break;
                            case '#tab2':
                                ManagePopUtil.getWngData();
                                break;
                            case '#tab3':
                                ManagePopUtil.getHistData();
                                break;
                        }
                    });

                    // 당첨자로 선정
                    $('#checkedApplicantToWng').on('click', function (e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var selected = $('#tbody_popup_manage_tab1').find('input:checkbox[name=chkMemberNo]:checked');
                        if(selected.length == 0) {
                            Dmall.LayerUtil.alert('선택된 지원자가 없습니다.');
                            return;
                        }
                        var isWngY = false;
                        $.each(selected, function () {
                            if($(this).closest('tr').data('wng-yn') == 'Y') {
                                isWngY = true;
                                return false;
                            }
                        });

                        if(isWngY) {
                            Dmall.LayerUtil.alert('당첨된 지원자는 선정할 수 없습니다.');
                            return;
                        }

                        Dmall.LayerUtil.confirm('선택한 지원자를 당첨처리 하시겠습니까?', function () {
                            $.each(selected, function () {
                                var lettNo = $(this).closest('tr').data('lett-no');
                                var eventNo = $('#form_tab1 input:hidden[name=eventNo]').val();
                                var memberNo = $(this).val();

                                var url = '/admin/promotion/event-winning-update',
                                    param = {lettNo: lettNo, eventNo: eventNo, memberNo: memberNo, wngYn: 'Y'};

                                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                                    if(result.success) {
                                        $('a.tab2').closest('li').trigger('click');
                                    }
                                });
                            });
                        });
                    });

                    // 지원자 엑셀 다운로드
                    $('#btn_manage_pop_download_01').on('click', function () {
                        $('#form_tab1').attr('action', '/admin/promotion/event-lett-excel-download');
                        $('#form_tab1').submit();
                        $('#form_tab1').attr('action', '/admin/promotion/event');
                    });

                    // 당첨자 엑셀 다운로드
                    $('#btn_manage_pop_download_02').on('click', function () {
                        $('#form_tab2').attr('action', '/admin/promotion/event-wng-excel-download');
                        $('#form_tab2').submit();
                        $('#form_tab2').attr('action', '/admin/promotion/event');
                    });

                    // 당첨자 저장
                    $('#tbody_popup_manage_tab2').on('click', 'button.btn_gray', function (e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var lettNo = $(this).closest('tr').data('lett-no');
                        var eventNo = $('#form_tab2 input:hidden[name=eventNo]').val();
                        var memberNo = $(this).closest('tr').find('input[type=checkbox]').val();
                        var wngYn = $(this).closest('tr').find('select.wngYn').val();

                        var url = '/admin/promotion/event-winning-update',
                            param = {lettNo: lettNo, eventNo: eventNo, memberNo: memberNo, wngYn: wngYn};

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if(result.success) {
                                $('a.tab2').closest('li').trigger('click');
                            }
                        });
                    });
                },
                getApplicantData: function () {
                    // 이전 목록 삭제
                    $('#tbody_popup_manage_tab1').html('');
                    // 전체선택 체크박스 해제
                    $('#applicantAllCheck').attr('checked', false);
                    $('#applicantAllCheck').closest('label').removeClass('on');

                    var url = '/admin/promotion/event-letter-list', dfd = $.Deferred(),
                        param = $('#form_tab1').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if(result == null || result.success != true) {
                            return;
                        }

                        $.each(result.resultList, function (idx, obj) {
                            ManagePopUtil.setApplicantList(obj);
                        });

                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_tab1', 'applicant_paging', result, 'paging_id_applicant', ManagePopUtil.getApplicantData);

                        if(result.filterdRows == 0) {
                            var template = '<tr><td colspan="8">지원자가 없습니다.</td></tr>';
                            $('#tbody_popup_manage_tab1').html(template);
                        }

                        $('#applicantTotal').text(result.filterdRows);
                        $('#applicantCurPage').text(result.page);
                        $('#applicantTotalPage').text(result.totalPages);
                    });
                    return dfd.promise();
                },
                setApplicantList: function (data) {
                    var template =
                        '<tr data-lett-no="'+data.lettNo+'" data-wng-yn="'+data.wngYn+'">' +
                        '<td>' +
                        '<label for="chk_memberNo_'+data.sortNum+'" class="chack"><span class="ico_comm">' +
                        '<input type="checkbox" name="chkMemberNo" value="'+data.memberNo+'" class="blind">' +
                        '</span></label>' +
                        '</td>' +
                        '<td>'+data.sortNum+'</td>' +
                        '<td>'+data.memberNm+'</td>' +
                        '<td>'+data.memberNn+'</td>' +
                        '<td>'+data.loginId+'</td>' +
                        '<td>'+data.content+'</td>' +
                        '<td>'+data.eventWngDt+'</td>';
                    if(data.wngYn == 'Y') {
                        template += '<td>당첨</td>';
                    } else {
                        template += '<td>당첨 아님</td>';
                    }
                    template += '</tr>';

                    $('#tbody_popup_manage_tab1').append(template);
                },
                getWngData: function () {
                    // 이전 목록 삭제
                    $('#tbody_popup_manage_tab2').html('');
                    // 전체선택 체크박스 해제
                    $('#wngAllCheck').attr('checked', false);
                    $('#wngAllCheck').closest('label').removeClass('on');

                    var url = '/admin/promotion/event-winning-list', dfd = $.Deferred(),
                        param = $('#form_tab2').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if(result == null || result.success != true) {
                            return;
                        }

                        $.each(result.resultList, function (idx, obj) {
                            ManagePopUtil.setWngList(obj);
                        });

                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_tab2', 'wng_paging', result, 'paging_id_wng', ManagePopUtil.getWngData);

                        if(result.filterdRows == 0) {
                            var template = '<tr><td colspan="8">당첨자가 없습니다.</td></tr>';
                            $('#tbody_popup_manage_tab2').html(template);
                        }

                        $('#wngTotal').text(result.filterdRows);
                        $('#wngCurPage').text(result.page);
                        $('#wngTotalPage').text(result.totalPages);
                    });
                    return dfd.promise();
                },
                setWngList: function (data) {
                    var template =
                        '<tr data-lett-no="'+data.lettNo+'">' +
                        '<td>' +
                        '<label for="chk_memberNo_'+data.sortNum+'" class="chack"><span class="ico_comm">' +
                        '<input type="checkbox" name="chkMemberNo" value="'+data.memberNo+'" class="blind">' +
                        '</span></label>' +
                        '</td>' +
                        '<td>'+data.sortNum+'</td>' +
                        '<td>'+data.memberNm+'</td>' +
                        '<td>'+data.memberNn+'</td>' +
                        '<td>'+data.loginId+'</td>' +
                        '<td>'+data.content+'</td>' +
                        '<td>'+data.eventWngDt+'</td>' +
                        '<td>' +
                        '<span class="select mr0">' +
                        '<label for=""></label>' +
                        '<select class="wngYn">';
                    if(data.wngYn == 'Y') {
                        template +=
                            '<option value="Y" selected="selected">당첨</option>' +
                            '<option value="N">당첨 아님</option>';
                    } else {
                        template +=
                            '<option value="Y">당첨</option>' +
                            '<option value="N" selected="selected">당첨 아님</option>';
                    }
                    template +=
                        '</select>' +
                        '</span>' +
                        '<button class="btn_gray pl10 pr10" style="min-width:34px; height:34px; line-height:32px;">저장</button>' +
                        '</td>' +
                        '</tr>';

                    $('#tbody_popup_manage_tab2').append(template);
                },
                getHistData: function () {
                    // 이전 목록 삭제
                    $('#manageHistList').html('');

                    var url = '/admin/promotion/event-winning-history',
                        param = {eventNo: $('#form_tab2 input:hidden[name=eventNo]').val(), searchType: 'wngYn'};

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if(result == null || result.success != true) {
                            return;
                        }

                        var template =
                                '<li class="txtl">[{{histStartDttm}}] [{{memberNm}} ({{memberNn}})] [당첨여부] {{wngYn}} - {{prcrNm}}</li>',
                            templateMgr = new Dmall.Template(template),
                            li = '';

                        $.each(result.resultList, function (idx, obj) {
                            if(obj.wngYn == 'Y') {
                                obj.wngYn = '당첨';
                            } else {
                                obj.wngYn = '당첨 아님';
                            }
                            li += templateMgr.render(obj);
                        });

                        $('#manageHistList').html(li);
                    });
                },
                clearPopup: function () {
                    $('a.tab1').closest('li').trigger('click');
                },
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    프로모션 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">이벤트 관리</h2>
            </div>
            <div class="search_box_wrap">
                <!-- search_box -->
                <div class="search_box">
                    <form:form id="form_id_search" commandName="so">
                        <form:hidden path="page" id="search_id_page" value=""/>
                        <form:hidden path="sord" id="hd_srod"/>
                        <form:hidden path="rows" id="rows" value=""/>
                        <form:hidden path="eventUseYns" id="event_use_yn_s" value=""/>
                        <input type="hidden" name="sort" value="${so.sort}"/>
                        <div class="search_tbl">
                            <table summary="이표는  이벤트 검색 표 입니다. 구성은 기간, 상태, 검색어 입니다.">
                                <caption>이벤트관리 검색</caption>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="searchStartDate" to="searchEndDate"
                                                       fromValue="${so.searchStartDate}" toValue="${so.searchEndDate}"
                                                       idPrefix="srch" hasTotal="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품군</th>
                                    <td>
                                        <c:set var="goodsTypeCd" value="${fn:join(so.goodsTypeCd, ' ')}"/>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                        <label for="goodsTypeCd1" class="chack mr20 <c:if test="${fn:contains(goodsTypeCd,'01')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="goodsTypeCd" id="goodsTypeCd1" value="01" label="" cssClass="blind"/>
                                            </span>
                                            안경테
                                        </label>
                                        <label for="goodsTypeCd2" class="chack mr20 <c:if test="${fn:contains(goodsTypeCd,'02')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="goodsTypeCd" id="goodsTypeCd2" value="02" label="" cssClass="blind"/>
                                            </span>
                                            선글라스
                                        </label>
                                        <label for="goodsTypeCd3" class="chack mr20 <c:if test="${fn:contains(goodsTypeCd,'04')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="goodsTypeCd" id="goodsTypeCd3" value="04" label="" cssClass="blind"/>
                                            </span>
                                            콘택트렌즈
                                        </label>
                                        <label for="goodsTypeCd4" class="chack mr20 <c:if test="${fn:contains(goodsTypeCd,'03')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="goodsTypeCd" id="goodsTypeCd4" value="03" label="" cssClass="blind"/>
                                            </span>
                                            안경렌즈
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <c:set var="eventStatusCds" value="${fn:join(so.eventStatusCds, ' ')}"/>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                        <label for="eventStatusCds1" class="chack mr20 <c:if test="${fn:contains(eventStatusCds,'01')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="eventStatusCds" id="eventStatusCds1" value="01" label="" cssClass="blind"/>
                                            </span>
                                            진행 전
                                        </label>
                                        <label for="eventStatusCds2" class="chack mr20 <c:if test="${fn:contains(eventStatusCds,'02')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="eventStatusCds" id="eventStatusCds2" value="02" label="" cssClass="blind"/>
                                            </span>
                                            진행 중
                                        </label>
                                        <label for="eventStatusCds3" class="chack mr20 <c:if test="${fn:contains(eventStatusCds,'03')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="eventStatusCds" id="eventStatusCds3" value="03" label="" cssClass="blind"/>
                                            </span>
                                            종료
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>노출</th>
                                    <td id="search_eventUseYn">
                                        <c:set var="eventUseYn" value="${fn:join(so.eventUseYn, ' ')}"/>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                        <label for="eventUseYn1" class="chack mr20 <c:if test="${fn:contains(eventUseYn,'Y')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="eventUseYn" id="eventUseYn1" value="Y" label="" cssClass="blind"/>
                                            </span>
                                            사용
                                        </label>
                                        <label for="eventUseYn2" class="chack mr20 <c:if test="${fn:contains(eventUseYn,'N')}">on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="eventUseYn" id="eventUseYn2" value="N" label="" cssClass="blind"/>
                                            </span>
                                            미사용
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error"
                                                        size="20" maxlength="30"/>
                                            <form:errors path="searchWords" cssClass="errors"/>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn green" id="btn_id_search_btn">검색</button>
                        </div>
                    </form:form>
                </div>
                <!-- //search_box -->
                <grid:tableSearchCnt id="grid_id_eventList" so="${so}" resultListModel="${resultListModel}" rowsOptionStr=""
                                     sortOptionStr="" type="이벤트">
                    <div class="tblh">
                        <table summary="이표는 이벤트 검색 표 입니다. 구성은 이벤트명, 사은품명, 이벤트 시작일, 이벤트 종료일, 이벤트 진행상태, 관리, 당첨자 입니다.">
                            <caption>이벤트 리스트</caption>
                            <colgroup>
                                <col width="50px" />
                                <col width="80px" />
                                <col width="" />
                                <col width="" />
                                <col width="" />
                                <col width="80px" />
                                <col width="90px" />
                                <col width="80px" />
                                <col width="200px" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack05" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05"/></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>생성일</th>
                                <th>이벤트명</th>
                                <th>이벤트 기간</th>
                                <th>상태</th>
                                <th>미리보기</th>
                                <th>노출</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="eventList">
                            <c:forEach var="eventList" items="${resultListModel.resultList}" varStatus="status">
                                <tr data-event-no="${eventList.eventNo}">
                                    <td>
                                        <label for="chack05_${status.count}" class="chack">
                                            <span class="ico_comm">
                                                <input type="checkbox" name="eventNo" id="chack05_${status.count}" value="${eventList.eventNo}"/>
                                            </span>
                                        </label>
                                    </td>
                                    <td>${eventList.sortNum}</td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${eventList.regDttm}"/></td>
                                    <td><a href="#none" class="tbl_link">${eventList.eventNm}</a></td>
                                    <td>${fn:substring(eventList.applyStartDttm, 0, 16)} ~ ${fn:substring(eventList.applyEndDttm, 0, 16)}</td>
                                    <td>${eventList.eventStatusNm}</td>
                                    <td><a href="#none" class="btn_gray">보기</a></td>
                                    <td>
                                        <c:if test='${eventList.eventUseYn eq "Y"}'>
                                            사용
                                        </c:if>
                                        <c:if test='${eventList.eventUseYn eq "N"}'>
                                            미사용
                                        </c:if>
                                    </td>
                                    <td style="display:none">
                                        <input type="hidden" name="eventWebBannerImgPath"
                                               value="${eventList.eventWebBannerImgPath}"/>
                                        <input type="hidden" name="eventWebBannerImg"
                                               value="${eventList.eventWebBannerImg}"/>
                                        <input type="hidden" name="eventMobileBannerImgPath"
                                               value="${eventList.eventMobileBannerImgPath}"/>
                                        <input type="hidden" name="eventMobileBannerImg"
                                               value="${eventList.eventMobileBannerImg}"/>
                                    </td>
                                    <td>
                                        <div class="btn_gray4_wrap">
                                            <c:if test='${eventList.eventCmntUseYn eq "Y"}'>
                                                <button class="btn_gray4" id="btn_cmnt">댓글</button>
                                            </c:if>
                                            <c:if test='${eventList.eventStatusNm eq "종료"}'>
                                                <button class="btn_gray4 btn_gray4_c" id="btn_wng">당첨자</button>
                                            </c:if>
                                            <button class="btn_gray4 btn_gray4_right" id="btn_manage">관리</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${resultListModel.filterdRows == 0}">
                                <tr>
                                    <td colspan="9">데이터가 없습니다.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <grid:paging resultListModel="${resultListModel}"/>
                    </div>
                </grid:tableSearchCnt>
            </div>
        </div>
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="del_event_btn">선택삭제</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_regist">등록</button>
            </div>
        </div>


        <!-- 댓글관리 POPUP -->
        <div id="cmnt_popup" class="layer_popup">
            <div class="pop_wrap size1">
                <div class="pop_tlt">
                    <h2 class="tlth2">댓글</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <!-- pop_con -->
                <div class="pop_con post">
                    <form id="form_eventCmnt_search">
                        <input type="hidden" name="eventNo" id="eventNo" value=""/> <!-- 인덱스번호로 뽑아낸 이벤트번호 임시저장  -->
                        <input type="hidden" name="page" value="1"/>
                        <input type="hidden" name="searchType" value="blindPrcYn">
                    </form>

                    <div class="tblh">
                        <table>
                            <colgroup>
                                <col width="5%" />
                                <col width="8%" />
                                <col width="12%" />
                                <col width="10%" />
                                <col width="25%" />
                                <col width="15%" />
                                <col width="20%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>이름</th>
                                <th>닉네임</th>
                                <th>아이디</th>
                                <th>내용</th>
                                <th>작성일</th>
                                <th>블라인드처리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_popup_cmnt_data">
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay mb40">
                        <div class="pageing" id="div_id_paging"></div>
                    </div>

                    <div class="tblh">
                        <table>
                            <colgroup>
                                <col width="20%" />
                                <col width="80%" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>처리로그</th>
                                <td>
                                    <div class="disposal_log">
                                        <ul id="eventCmntHistList">
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- //pop_con -->
            </div>
        </div>

        <!-- 당첨자관리 POPUP -->
        <div id="wng_popup" class="layer_popup">
            <div class="pop_wrap size1">
                <div class="pop_tlt">
                    <h2 class="tlth2">당첨자</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <!-- pop_con -->
                <div class="pop_con">
                    <form action="" id="form_wng_info">
                        <input type="hidden" name="wngContentNo" id="wngContentNo" value="0">
                        <div class="tblw">
                            <table>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>이벤트명</th>
                                    <td id="bind_target_id_eventNm" class="bind_target"></td>
                                </tr>
                                <tr>
                                    <th>제목</th>
                                    <td>
                                        <span class="intxt w100p">
                                            <input type="text" name="wngNm" id="wngNm" placeholder="제목을 입력해주세요.">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>내용</th>
                                    <td>
                                        <div class="edit">
                                            <textarea name="wngContentHtml" id="ta_id_content1" class="blind"></textarea>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_popup_wng_regist">저장</button>
                        </div>
                    </form>
                </div>
                <!-- //pop_con -->
            </div>
        </div>

        <!-- 관리 -->
        <div id="manage_popup" class="layer_popup">
            <div class="pop_wrap size1">
                <div class="pop_tlt">
                    <h2 class="tlth2">관리</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <div class="pop_con">
                    <div>
                        <div class="sub_tab tab_lay2">
                            <ul>
                                <li class="tab-2 on"><a href="#tab1" class="tab1"><span class="ico_comm"></span>지원자 보기</a></li>
                                <li class="tab-2"><a href="#tab2" class="tab2"><span class="ico_comm"></span>당첨자 보기</a></li>
                                <li class="tab-2"><a href="#tab3" class="tab3"><span class="ico_comm"></span>당첨자 처리 내역</a></li>
                            </ul>
                        </div>
                        <!-- tab1 -->
                        <div class="tab-2con" id="tab1">
                            <form action="" id="form_tab1">
                                <input type="hidden" name="eventNo" value="">
                                <input type="hidden" name="page" value="1">
                                <input type="hidden" name="searchType" value="wngYn">
                            </form>
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <span class="search_txt">총 <strong class="all" id="applicantTotal"></strong>개 (현재 <span id="applicantCurPage"></span>페이지 / 총 <span id="applicantTotalPage"></span>페이지)</span>
                                </div>
                                <div class="select_btn_right">
                                    <button class="btn_gray2" id="checkedApplicantToWng">당첨자로 선정</button>
                                    <button class="btn_exl ml5" id="btn_manage_pop_download_01">
                                        <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                    </button>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <div class="tblh th_l tblmany">
                                <table>
                                    <colgroup>
                                        <col width="5%">
                                        <col width="8%">
                                        <col width="10%">
                                        <col width="12%">
                                        <col width="10%">
                                        <col width="">
                                        <col width="15%">
                                        <col width="10%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>
                                            <label for="applicantAllCheck" class="chack">
                                                <span class="ico_comm"><input type="checkbox" name="table" id="applicantAllCheck" class="blind"></span>
                                            </label>
                                        </th>
                                        <th>번호</th>
                                        <th>이름</th>
                                        <th>닉네임</th>
                                        <th>아이디</th>
                                        <th>내용</th>
                                        <th>당첨자 발표일</th>
                                        <th>당첨여부</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody_popup_manage_tab1">
                                    </tbody>
                                </table>
                            </div>
                            <div class="bottom_lay">
                                <div class="pageing" id="applicant_paging"></div>
                            </div>
                        </div>
                        <!-- tab2 -->
                        <div class="tab-2con" id="tab2" style="display: none;">
                            <form action="" id="form_tab2">
                                <input type="hidden" name="eventNo" value="">
                                <input type="hidden" name="page" value="1">
                                <input type="hidden" name="searchType" value="wngYn">
                            </form>
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <span class="search_txt">총 <strong class="all" id="wngTotal"></strong>개 (현재 <span id="wngCurPage"></span>페이지 / 총 <span id="wngTotalPage"></span>페이지)</span>
                                </div>
                                <div class="select_btn_right">
                                    <button class="btn_exl" id="btn_manage_pop_download_02">
                                        <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                    </button>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <div class="tblh th_l tblmany">
                                <table>
                                    <colgroup>
                                        <col width="5%">
                                        <col width="8%">
                                        <col width="10%">
                                        <col width="12%">
                                        <col width="10%">
                                        <col width="">
                                        <col width="15%">
                                        <col width="200px">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>
                                            <label for="wngAllCheck" class="chack">
                                                <span class="ico_comm"><input type="checkbox" name="table" id="wngAllCheck" class="blind"></span>
                                            </label>
                                        </th>
                                        <th>번호</th>
                                        <th>이름</th>
                                        <th>닉네임</th>
                                        <th>아이디</th>
                                        <th>내용</th>
                                        <th>당첨자 발표일</th>
                                        <th>당첨여부</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody_popup_manage_tab2">
                                    </tbody>
                                </table>
                            </div>
                            <div class="bottom_lay">
                                <div class="pageing" id="wng_paging"></div>
                            </div>
                        </div>
                        <!-- tab3 -->
                        <div class="tab-2con" id="tab3" style="display: none;">
                            <div class="disposal_log">
                                <ul id="manageHistList">
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>