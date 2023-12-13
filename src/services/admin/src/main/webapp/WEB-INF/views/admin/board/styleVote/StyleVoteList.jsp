<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2022/11/22
  Time: 2:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <t:putAttribute name="title">스타일 추천 투표 > 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 데이터 조회 & 남은시간 및 상태 표시
                bbsLettSet.getDataAndSetTimer();

                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function() {
                    var fromDttm = $('#srch_sc01').val().replace(/-/gi, "");
                    var toDttm = $('#srch_sc02').val().replace(/-/gi, "");
                    if(fromDttm > toDttm) {
                        Dmall.LayerUtil.alert('작성일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $('#hd_page').val('1');
                    bbsLettSet.getDataAndSetTimer();
                });

                // 게시글 내용 클릭
                $(document).on('click', '#tbody_id_bbsLettList a.tbl_link', function() {
                    var param = {
                        bbsId: $(this).parents('tr').data('bbs-id'),
                        lettNo: $(this).parents('tr').data('lett-no'),
                    };
                    Dmall.FormUtil.submit('/admin/board/letter-detail', param);
                });

                // 보기/삭제 버튼 클릭
                $(document).on('click', '#tbody_id_bbsLettList a.btn_gray', function() {
                    var param = {
                        bbsId: $(this).parents('tr').data('bbs-id'),
                        lettNo: $(this).parents('tr').data('lett-no'),
                    };

                    if($(this).text() == "보기") {
                        Dmall.FormUtil.submit('/admin/board/letter-detail', param);
                    } else {
                        var url = '/admin/board/board-letter-delete';
                        Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                    $('#hd_page').val('1');
                                    bbsLettSet.getDataAndSetTimer();
                                }
                            });
                        });
                    }
                });

                // 선택 삭제 버튼 클릭
                $(document).on('click', '#delSelectBbsLett', function() {
                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk == false) {
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해주세요.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', bbsLettSet.delSelectBbsLett);
                });
            });

            var bbsLettSet = {
                bbsLettList : [],
                getBbsLettList : function() {
                    var url = '/admin/board/board-letter-list', dfd = jQuery.Deferred();
                    var param = jQuery('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                            '<tr data-lett-no="{{lettNo}}" data-bbs-id="{{bbsId}}" data-end-dttm="{{endDttm}}">' +
                            '<td>' +
                            '   <label for="delLettNo_{{lettNo}}" class="chack">' +
                            '   <span class="ico_comm"><input type="checkbox" name="delLettNo" id="delLettNo_{{lettNo}}" value="{{lettNo}}" class="blind"></span></label>' +
                            '</td>' +
                            '<td>{{rowNum}}</td>' +
                            '<td>{{goodsTypeCdNm}}</td>' +
                            '<td style="text-align:left"><a href="#none" class="tbl_link">{{content}} ({{cmntCnt}})</a></td>' +
                            '<td>{{memberNm}}</td>' +
                            '<td>{{regDttm}}</td>' +
                            '<td id="remainTime"></td>' +
                            '<td id="voteStatus"></td>' +
                            '<td>' +
                            '   <a class="btn_gray">보기</a>' +
                            '   <a class="btn_gray">삭제</a>' +
                            '</td>' +
                            '</tr>';
                        var templateMgr = new Dmall.Template(template);
                        var tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += templateMgr.render(obj);
                        })

                        if(tr == '') {
                            tr = '<tr><td colspan="9">데이터가 없습니다.</td></tr>';
                        }

                        jQuery('#tbody_id_bbsLettList').html(tr);
                        bbsLettSet.bbsLettList = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsLett', bbsLettSet.getDataAndSetTimer);

                        $("#a").text(result.filterdRows);
                    });
                    return dfd.promise();
                },
                delSelectBbsLett : function() {
                    var url = '/admin/board/board-checkedletter-delete';
                    var param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            $('#hd_page').val('1');
                            bbsLettSet.getDataAndSetTimer();
                        }
                    });
                },
                getDataAndSetTimer : function() {
                    bbsLettSet.getBbsLettList().then(() => {
                        $('#tbody_id_bbsLettList').children('tr').each((idx, obj) => {
                            let timer = 0;
                            calcRemainTime(obj, $(obj).data('end-dttm'), timer);
                        });
                    })
                }
            }

            function calcRemainTime(el, endDttm, timer) {
                const endDate = new Date(endDttm);
                const cur = new Date();
                const utc = cur.getTime() + (cur.getTimezoneOffset() * 60 * 1000);
                const kr_cur = new Date(utc + (9 * 60 * 60 * 1000));
                let diff = endDate - kr_cur;

                if (diff < 1000) {
                    clearTimeout(timer);
                    $(el).children('#remainTime').html('00일 00:00:00');
                    $(el).children('#voteStatus').html('투표종료');
                } else {
                    const diffDay = Math.floor(diff / (1000 * 60 * 60 * 24));
                    const diffHour = Math.floor((diff / (1000 * 60 * 60)) % 24);
                    const diffMinute = Math.floor((diff / (1000 * 60)) % 60);
                    const diffSec = Math.floor(diff / 1000 % 60);

                    $(el).children('#remainTime').html(
                        diffDay.toString().padStart(2, '0') + '일 ' +
                        diffHour.toString().padStart(2, '0') + ':' +
                        diffMinute.toString().padStart(2, '0') + ':' +
                        diffSec.toString().padStart(2, '0')
                    );
                    $(el).children('#voteStatus').html('투표중');

                    timer = setTimeout(calcRemainTime, 1000, el, endDttm, timer);
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">스타일 추천 투표</h2>
            </div>
            <form id="form_id_search">
                <input type="hidden" name="page" id="hd_page" value="1">
                <input type="hidden" name="sord" id="hd_sord" value="">
                <!-- search_box -->
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이 표는 스타일 추천 투표 리스트 검색 표 입니다. 구성은 등록일, 구분, 상태, 검색어 입니다.">
                            <caption>스타일 추천 투표 검색</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>등록일</th>
                                <td>
                                    <tags:calendar from="fromRegDt" to="toRegDt" idPrefix="srch"/>
                                </td>
                            </tr>
                            <tr>
                                <th>구분</th>
                                <td>
                                    <tags:checkboxs codeStr="01:안경테;02:선글라스;" name="goodsTypeCds" idPrefix="goodsTypeCd"/>
                                </td>
                            </tr>
                            <tr>
                                <th>상태</th>
                                <td>
                                    <tags:checkboxs codeStr="01:투표중;02:투표종료;" name="voteStatusCds" idPrefix="voteStatusCd"/>
                                </td>
                            </tr>
                            <tr>
                                <th>검색어</th>
                                <td>
                                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}"/>
                                    <span class="intxt w100p">
                                        <input type="text" value="" id="searchVal" name="searchVal">
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <a href="#none" class="btn green" id="btn_id_search">검색</a>
                    </div>
                </div>
                <!-- //search_box -->
                <!-- line_box -->
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                        <span class="search_txt">
                        총 <strong class="be" id="a"></strong>개의 게시물이 검색되었습니다.
                        </span>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="스타일 추천 투표 리스트 표 입니다. 구성은 선택, 번호, 구분, 내용, 작성자, 등록일시, 남은시간, 상태, 관리 입니다.">
                            <caption>스타일 추천 투표 리스트 표</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="5%">
                                <col width="10%">
                                <col width="25%">
                                <col width="8%">
                                <col width="12%">
                                <col width="12%">
                                <col width="8%">
                                <col width="15%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack03" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack03"></span>
                                    </label>
                                </th>
                                <th>No</th>
                                <th>구분</th>
                                <th>내용 (댓글)</th>
                                <th>작성자</th>
                                <th>등록일시</th>
                                <th>남은시간</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_bbsLettList">
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div id="div_id_paging"></div>
                    </div>
                    <!-- //bottom_lay -->
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="delSelectBbsLett">선택 삭제</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>
