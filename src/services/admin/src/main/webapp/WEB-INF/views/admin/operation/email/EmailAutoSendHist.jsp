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
    <t:putAttribute name="title">이메일 발송 내역 > 이메일 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            function viewEmailUseInfo(emailSendNo) {
                Dmall.LayerPopupUtil.open($("#emailUseInfo"));
                openEmailUseInfoLayer(emailSendNo);
            }

            $(document).ready(function() {
                emailAutoSendHistSet.getList();

                // 검색
                $('#btn_id_emailSendHist').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");

                    if(fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $('#hd_page4').val('1');
                    emailAutoSendHistSet.getList();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_email_hist_search', emailAutoSendHistSet.getList);
            });

            var emailAutoSendHistSet = {
                emailAutoSendHist : [],
                getList : function(){
                    var url = '/admin/operation/email-autosend-list',dfd = jQuery.Deferred();
                    var param = $('#form_email_hist_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                                '<tr>'+
                                '<td>{{rowNum}}</td>' +
                                '<td class="txtl">{{sendTitle}}</td>'+
                                '<td>{{receiverNm}} ({{receiverEmail}})</td>'+
                                '<td>{{sendDttm}}</td>' +
                                '<td>{{resultCd}}</td>' +
                                '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            obj.sendTitle = '<a href="#none" class="tbl_link" onclick="viewEmailUseInfo('+obj.mailSendNo+');">'+obj.sendTitle+'</a>';
                            if(obj.resultCd=='Y'){
                                obj.resultCd ='성공';
                            }else{
                                obj.resultCd ='실패';
                            }

                            tr += managerGroup.render(obj)
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="5">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_emailAutoSendHist').html(tr);
                        emailAutoSendHistSet.emailAutoSendHist = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_email_hist_search', 'div_autoSendhist_paging', result, 'paging_emailAutoSentHist', emailAutoSendHistSet.getList);

                        $("#cnt_total").text(result.filterdRows);
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
                    운영 설정<span class="step_bar"></span> 이메일<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">이메일 발송 내역</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_email_hist_search">
                    <input type="hidden" name="page" id="hd_page4" value="1" />
                    <input type="hidden" name="sord" id="hd_srod4" value="" />
                    <input type="hidden" name="autoSendYn" value="Y" />
                    <!-- search_box -->
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 이메일자동발송 내역 검색 표 입니다. 구성은 발송일, 검색어 입니다.">
                                <caption>이메일자동발송 내역 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>발송일</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" fromValue="" toValue="" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <tags:radio name="resultCd" codeStr=":전체;Y:성공;N:실패" idPrefix="srch_id_resultCd" value="" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <span>
                                                <label for="searchKind"></label>
                                                <select name="searchKind" id="searchKind" >
                                                    <option value="all">전체</option>
                                                    <option value="searchSendContent">내용</option>
                                                    <option value="searchMemberNm">수신자명</option>
                                                </select>
                                            </span>
                                            <input type="text" name="searchVal" id="searchVal" />
                                        </div>
                                    </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                        <div class="btn_box txtc">
                            <button type="button" class="btn green" id="btn_id_emailSendHist">검색</button>
                        </div>
                    </div>
                    <!-- //search_box -->
                    <!-- line_box -->
                    <div class="line_box">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <span class="search_txt">
                                    총 <strong class="all" id="cnt_total"></strong>개의 발송내역이 검색되었습니다.
                                </span>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh">
                            <table summary="이표는 SMS 자동발송 내역 표 입니다. 구성은 체크박스, 번호, 이메일 제목, 수신 대상자, 발송일시, 발송상태 입니다.">
                                <caption>SMS 자동발송 내역</caption>
                                <colgroup>
                                    <col width="10%">
                                    <col width="40%">
                                    <col width="25%">
                                    <col width="15%">
                                    <col width="10%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>이메일 제목</th>
                                    <th>수신 대상자</th>
                                    <th>발송일시</th>
                                    <th>발송상태</th>
                                </tr>
                                </thead>
                                <tbody id = "tbody_id_emailAutoSendHist">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <!-- bottom_lay -->
                        <div class="bottom_lay">
                            <!-- pageing -->
                            <div class="pageing" id="div_autoSendhist_paging"></div>
                            <!-- //pageing -->
                        </div>
                        <!-- //bottom_lay -->
                    </div>
                    <!-- //line_box -->
                </form>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/admin/operation/email/EmailUseInfo.jsp"/>
    </t:putAttribute>
</t:insertDefinition>