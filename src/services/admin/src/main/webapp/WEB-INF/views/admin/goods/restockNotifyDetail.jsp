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
    <t:putAttribute name="title">재입고알림상품관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                Dmall.common.comma();
                RestockPopUtil.init();

                // 전체선택
                $('a.all_choice').off('click').on('click', function () {
                    $(this).siblings('div').children('label').toggleClass('on');
                });

                // 알림 발송 목록
                $('#btn_notifysend_popup').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    RestockPopUtil.resetForm();
                    Dmall.LayerPopupUtil.open($('#layer_notifysend_popup'));
                    $('#btn_id_search').trigger('click');
                });

                // 목록
                $('#btn_list').on('click', function () {
                    Dmall.FormUtil.submit('/admin/goods/restocknotify/restock-notifiy');
                });

                // 저장
                $('#btn_save').on('click', function () {
                    var url = '/admin/goods/restocknotify/restock-notify-memo-update',
                        param = $('#restocknotify').serialize();

                    Dmall.AjaxUtil.getJSON(url, param);
                });

                // 재입고 알림
                $('#btn_send').on('click', function () {
                    RestockUtil.sendNotify();
                });
            });

            var RestockUtil = {
                sendNotify: function() {
                    var selected = [];
                    $('div.setUserInfo label.on').each(function () {
                        var text = ($(this).text().replace(/ /g, '')+'|'+$(this).children('input[type=hidden]').val()).trim();
                        selected.push(text);
                    });

                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('재입고 알림을 발송할 회원을 선택해주세요.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('선택한 회원에게 재입고 알림을 발송하시겠습니까?', function () {
                        var url = '/admin/goods/restocknotify/restock-sms-send',
                            param = {};

                        $.each(selected, function (idx, obj) {
                            var str = selected[idx].split('|');

                            // 재입고 알림 번호
                            var key = 'list['+idx+'].reinwareAlarmNo';
                            param[key] = 0;
                            // 상품 번호
                            key = 'list['+idx+'].goodsNo';
                            param[key] = $('#goodsNo').val();
                            // 회원 번호
                            key = 'list['+idx+'].memberNo';
                            param[key] = str[3];
                            // 상태 코드
                            key = 'list['+idx+'].alarmStatusCd';
                            param[key] = '1';
                            // 상품명
                            key = 'list['+idx+'].goodsNm';
                            param[key] = $('#goodsNm').val();
                            // 수신자 전화번호
                            key = 'list['+idx+'].recvTelNo';
                            param[key] = str[1];
                            // 수신자 회원번호
                            key = 'list['+idx+'].receiverNo';
                            param[key] = str[3];
                            // 수신자 이름
                            key = 'list['+idx+'].receiverNm';
                            param[key] = str[0];
                            // 발송 문구
                            key = 'list['+idx+'].sendWords';
                            param[key] =
                                '상점명 : #[siteNm]\n' +
                                '회원명 : #[memberNm]\n' +
                                '상품명 : #[goodsNm]';
                        });

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            location.reload();
                        });
                    });
                }
            }

            var RestockPopUtil = {
                init: function() {
                    // 엔터키 입력시 검색
                    Dmall.FormUtil.setEnterSearch('form_id_search', function() { $('#btn_id_search').trigger('click'); });

                    // 검색
                    $('#btn_id_search').on('click', function (e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                        var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                        if(fromDttm && toDttm && fromDttm > toDttm){
                            Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                            return;
                        }

                        $('#hd_pop_page').val('1');
                        RestockPopUtil.getList();
                    });

                    // 일괄재발송
                    $('#btn_batch_resend').on('click', function (e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var selected = [];
                        $('#tbody_notifysend_data').find('input[type=checkbox]:checked').each(function () {
                            var text = $(this).val() +'|'+ $(this).data('mobile') +'|'+ $(this).data('member-nm');
                            selected.push(text);
                        });

                        if(selected.length < 1) {
                            Dmall.LayerUtil.alert('선택된 회원이 없습니다.');
                            return;
                        }

                        var url = '/admin/goods/restocknotify/restock-sms-send',
                            param = {};

                        $.each(selected, function (idx, obj) {
                            var str = selected[idx].split('|');

                            // 재입고 알림 번호
                            var key = 'list['+idx+'].reinwareAlarmNo';
                            param[key] = 0;
                            // 상품 번호
                            key = 'list['+idx+'].goodsNo';
                            param[key] = $('#goodsNo').val();
                            // 회원 번호
                            key = 'list['+idx+'].memberNo';
                            param[key] = str[0];
                            // 상태 코드
                            key = 'list['+idx+'].alarmStatusCd';
                            param[key] = '1';
                            // 상품명
                            key = 'list['+idx+'].goodsNm';
                            param[key] = $('#goodsNm').val();
                            // 수신자 전화번호
                            key = 'list['+idx+'].recvTelNo';
                            param[key] = str[1];
                            // 수신자 회원번호
                            key = 'list['+idx+'].receiverNo';
                            param[key] = str[0];
                            // 수신자 이름
                            key = 'list['+idx+'].receiverNm';
                            param[key] = str[2];
                            // 발송 문구
                            key = 'list['+idx+'].sendWords';
                            param[key] =
                                '상점명 : #[siteNm]\n' +
                                '회원명 : #[memberNm]\n' +
                                '상품명 : #[goodsNm]';
                        });

                        Dmall.AjaxUtil.getJSON(url, param);
                    });

                    // 재발송
                    $(document).on('click', '#tbody_notifysend_data button', function (e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var $this = $(this).closest('tr'),
                            url = '/admin/goods/restocknotify/restock-sms-send',
                            param = {
                                'list[0].reinwareAlarmNo': 0,
                                'list[0].goodsNo': $('#goodsNo').val(),
                                'list[0].memberNo': $this.find('input[name=memberNo]').val(),
                                'list[0].alarmStatusCd': '1',
                                'list[0].goodsNm': $('#goodsNm').val(),
                                'list[0].recvTelNo': $this.data('mobile'),
                                'list[0].receiverNo': $this.find('input[name=memberNo]').val(),
                                'list[0].receiverNm': $this.data('member-nm'),
                                'list[0].sendWords': '상점명 : #[siteNm]\n회원명 : #[memberNm]\n상품명 : #[goodsNm]'
                            };

                        Dmall.AjaxUtil.getJSON(url, param);
                    });
                },
                resetForm: function() {
                    $('#form_id_search').each(function () {
                        this.reset();
                    });

                    if($('label[for=allcheck]').hasClass('on')) {
                        $('label[for=allcheck]').removeClass('on');
                    }
                },
                getList: function() {
                    var url = '/admin/goods/restocknotify/restock-notify-send-list',
                        param = $('#form_id_search').serialize(),
                        dfd = $.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                                '<tr data-mobile="{{mobile}}" data-member-nm="{{memberNm}}">' +
                                '<td>' +
                                '<label for="chkMemberNo_{{rowNum}}" class="chack"><span class="ico_comm">' +
                                '<input type="checkbox" name="chkMemberNo" id="chkMemberNo_{{rowNum}}" value="{{memberNo}}" class="blind">' +
                                '</span></label>' +
                                '</td>' +
                                '<td>{{rowNum}}</td>' +
                                '<td>{{memberNm}}</td>' +
                                '<td>{{mobile}}</td>' +
                                '<td>{{memberGradeNm}}</td>' +
                                '<td>{{alarmDttm}}</td>' +
                                '<td><button class="btn--small">재발송</button></td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="7">데이터가 없습니다.</td></tr>'
                        }

                        $('#tbody_notifysend_data').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_restock', RestockPopUtil.getList);

                        $('#cnt_total').text(result.filterdRows);
                    });
                    return dfd.promise();
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <c:set var="data" value="${resultModel.data}"/>
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">재입고 알림 상품</h2>
            </div>
            <!-- line_box -->
            <form action="" id="restocknotify">
                <input type="hidden" name="goodsNo" id="goodsNo" value="${data.goodsNo}">
                <input type="hidden" id="goodsNm" value="${data.goodsNm}">
                <div class="line_box pb">
                    <div class="tblw tblmany">
                        <table>
                            <colgroup>
                                <col width="150px" />
                                <col width="" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>상품명</th>
                                <td><c:out value="${data.goodsNm}"/></td>
                            </tr>
                            <tr>
                                <th>상품 코드</th>
                                <td><c:out value="${data.goodsNo}"/></td>
                            </tr>
                            <tr>
                                <th>상품상태</th>
                                <td><c:out value="${data.goodsSaleStatusNm}"/></td>
                            </tr>
                            <tr>
                                <th>상품 대표 이미지</th>
                                <td>
                                    <div class="review_img_gr">
                                        <c:forEach var="imgSrc" items="${data.imgList}" varStatus="status">
                                            <span class="review_img mr20">
                                                <img src="${_IMAGE_DOMAIN}${imgSrc}" alt="">
                                            </span>
                                        </c:forEach>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>판매가</th>
                                <td class="comma"><c:out value="${data.salePrice}"/></td>
                            </tr>
                            <tr class="y_scroll">
                                <th>재입고알림 요청자</th>
                                <td>
                                    <div class="h200">
                                        <a href="#none" class="all_choice mr20">
                                            <span class="ico_comm"></span>전체
                                        </a>
                                        <button class="btn--small" id="btn_notifysend_popup">알림 발송 목록</button>
                                        <c:forEach var="memberInfo" items="${data.restockMemberList}" varStatus="status">
                                            <div class="setUserInfo">
                                                <label for="chack_${status.count}" class="chack mr20">
                                                    <input type="hidden" value="${memberInfo.memberNo}">
                                                    <span class="ico_comm"></span>
                                                    <c:out value="${memberInfo.memberNm}"/> | <c:out value="${memberInfo.mobile}"/> | <c:out value="${memberInfo.memberGradeNm}"/>
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="marginB40">
                        <h3 class="tlth3 btn1">관리자 메모</h3>
                        <div class="txt_area">
                            <textarea name="managerMemo" cols="30" rows="10"><c:out value="${data.managerMemo}"/></textarea>
                        </div>
                    </div>
                    <div>
                        <h3 class="tlth3 btn1">처리로그</h3>
                        <div class="disposal_log">
                            <ul>
                                <c:forEach var="notifySendLog" items="${data.notifySendLog}">
                                    <li>${notifySendLog.sendDttm} [재입고알림] ${notifySendLog.sendCnt}명 발송 완료</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </form>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="left">
                    <div class="pop_btn">
                        <button class="btn--big btn--big-white" id="btn_list">목록</button>
                    </div>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_save">저장</button>
                    <button class="btn--blue-round" id="btn_send">재입고알림</button>
                </div>
            </div>
        </div>

        <div id="layer_notifysend_popup" class="layer_popup">
            <div class="pop_wrap size1">
                <div class="pop_tlt">
                    <h2 class="tlth2">알림 발송 목록</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <div class="pop_con">
                    <form action="" id="form_id_search">
                        <input type="hidden" name="searchCode" value="${data.goodsNo}">
                        <input type="hidden" name="page" id="hd_pop_page" value="1" />
                        <input type="hidden" name="sord" id="hd_pop_srod" value="" />
                        <input type="hidden" name="rows" id="hd_pop_rows" value="" />
                        <div class="tblw mt0">
                            <table>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>발송 기간</th>
                                    <td>
                                        <tags:calendar from="searchDateFrom" to="searchDateTo" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt wid100p">
                                            <input type="text" name="searchWordEncrypt" id="searchWordEncrypt">
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--black_small mt20 mb20" id="btn_id_search">검색</button>
                        </div>
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <span class="search_txt">
                                    총 <strong class="all" id="cnt_total"></strong>개의 내역이 검색되었습니다.
                                </span>
                            </div>
                        </div>
                        <div class="tblh">
                            <table>
                                <colgroup>
                                    <col width="50px">
                                    <col width="80px">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="105px">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>
                                        <label for="allcheck" class="chack">
                                            <span class="ico_comm">
                                                <input type="checkbox" name="table" id="allcheck">
                                            </span>
                                        </label>
                                    </th>
                                    <th>번호</th>
                                    <th>이름</th>
                                    <th>연락처</th>
                                    <th>회원등급</th>
                                    <th>발송일</th>
                                    <th>재발송</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_notifysend_data">
                                </tbody>
                            </table>
                            <div class="btn_box txtc">
                                <button class="btn--blue_small" id="btn_batch_resend">일괄 재발송</button>
                            </div>
                        </div>
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_paging"></div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
