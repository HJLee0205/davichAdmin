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
    <t:putAttribute name="title">휴면 회원 관리 > 회원</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));

                // 숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
                // 영문만 입력가능
                $(document).on('keyup', 'input:text[engOnly]', function() {$(this).val($(this).val().replace(/[^\w\@\.]/gi, ''));});

                // 검색
                $('#btn_id_search').on('click', function() {
                    var fromDttm = $("#dormant_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#dormant_sc02").val().replace(/-/gi, "");
                    if (fromDttm && toDttm && fromDttm > toDttm) {
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    // 검색어 mobile 형식 검증
                    var exp = /^\d{11}$/;
                    var value = $('input[name=searchWords]').val();
                    if(exp.test(value)) {
                        $('input[name=searchWords]').val(value.replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, '$1-$2-$3'));
                    }

                    $("#search_id_page").val("1");
                    $('#form_id_search').submit();
                });

                //검색 타입 변경시 텍스트 입력 설정 변경(한글/영문/숫자 입력 제한)
                $('#srch_id_searchType').change(function(e){
                    $("input[name='searchWords']").remove();

                    var inputText = '';
                    if($(this).val() == 'all' || $(this).val() == 'name'){
                        inputText = '<input type="text" name="searchWords">'
                    }else if($(this).val() == 'id' || $(this).val() == 'email'){
                        inputText = '<input type="text" name="searchWords" engOnly>'
                    }else if($(this).val() == 'mobile'){
                        inputText = '<input type="text" maxlength="11" numberOnly>'
                    }

                    $('div.select_inp').append(inputText);
                });

                // 선택 휴면 해제
                $('#updateDormantMemBtn').on('click', function(e) {
                    var memChk = $('input:checkbox[name=updMemberNo]').is(':checked');
                    if(memChk == false){
                        Dmall.LayerUtil.alert('선택된 데이터가 없습니다.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('선택한 회원을 휴면 해제 하시겠습니까?', function() {
                        var url = '/admin/member/manage/dormant-member-update';
                        var param = $('#form_id_param').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                $('#form_id_search').submit();
                            }
                        });
                    });
                });

                Dmall.common.comma();
            });

            //회원 상세 정보
            function viewMemInfoDtl(memberNo){
                Dmall.FormUtil.submit('/admin/member/manage/dormant-memberinfo-detail', {memberNo : memberNo});
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    회원 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">휴면 회원 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <!-- search_tbl -->
                    <form:form action="/admin/member/manage/dormant-member" id="form_id_search" commandName="memberManageSO">
                        <form:hidden path="page" id="search_id_page" />
                        <form:hidden path="rows" />
                        <div class="search_tbl">
                            <table summary="이표는 휴면회원관리 검색 표 입니다. 구성은 검색어 입니다.">
                                <caption>휴면회원관리</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>휴면 처리일</th>
                                    <td>
                                        <tags:calendar from="dormantStDttm" to="dormantEndDttm" fromValue="${memberManageSO.dormantStDttm}" toValue="${memberManageSO.dormantEndDttm}" idPrefix="dormant" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <span>
                                                <label for="srch_id_searchType"></label>
                                                <select name="searchType" id="srch_id_searchType">
                                                    <tags:option codeStr="all:전체;id:아이디;name:이름;email:이메일;mobile:휴대폰;" value="${memberManageSO.searchType}" />
                                                </select>
                                            </span>
                                            <input type="text" name="searchWords">
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </form:form>
                </div>
                <form id="form_id_param">
                    <div class="line_box">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <span class="search_txt">
                                    총 <strong class="all comma" id="cnt_total">${resultListModel.filterdRows}</strong>명의 회원이 검색되었습니다.
                                </span>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh">
                            <table summary="회원 리스트"  id="table_id_memberList">
                                <caption>회원 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="6%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="13%">
                                    <col width="15%">
                                    <col width="15%">
                                    <col width="6%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>
                                        <label for="chack05" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="table" id="chack05"/></span>
                                        </label>
                                    </th>
                                    <th>No</th>
                                    <th>아이디</th>
                                    <th>이름</th>
                                    <th>이메일</th>
                                    <th>휴대폰</th>
                                    <th>휴면 처리일시</th>
                                    <th>관리</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_memberList">
                                <c:choose>
                                    <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                        <tr>
                                            <td colspan="8">데이터가 없습니다.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="memList" items="${resultListModel.resultList}" varStatus="status">
                                            <tr>
                                                <td>
                                                    <label for="updMemberNo_${memList.sortNum}" class="chack" >
                                                        <span class="ico_comm"><input type="checkbox" name="updMemberNo" id="updMemberNo_${memList.sortNum}" value="${memList.memberNo}" class="blind" /></span>
                                                    </label>
                                                </td>
                                                <td class="comma">${memList.sortNum}</td>
                                                <td>${memList.loginId}</td>
                                                <td>${memList.memberNm}</td>
                                                <td>${memList.email}</td>
                                                <td>${memList.mobile}</td>
                                                <td>${memList.dormantDttm}</td>
                                                <td>
                                                    <div class="pop_btn">
                                                        <a href="#none" class="btn_gray" onclick="viewMemInfoDtl('${memList.memberNo}');">상세</a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <!-- bottom_lay -->
                        <div class="bottom_lay">
                            <!-- pageing -->
                            <grid:paging resultListModel="${resultListModel}" />
                            <!-- //pageing -->
                        </div>
                        <!-- //bottom_lay -->
                        <!-- consult_box -->
                        <div class="consult_box">
                            <h4 class="cs_h4">[!] 참고사항</h4>
                            <p class="desc">개인정보유효기간제 시행에 따라 쇼핑몰에 로그인한지 1년 이상 경과된 고객들은 자동으로 휴면회원 처리되며, 개인정보가 분리 보관 됩니다.</p>
                            <h4 class="point_txt">개인정보 유효기간제란?</h4>
                            <ul class="desc">
                                <li>1. 1년 이상 서비스 이용 기록이 없는 고객의 개인정보를 별도로 분리하여 저장해야하는 제도입니다.</li>
                                <li>2. 관련 법률 : 정보통신망 이용촉진 및 정보보호등에 관한 법률 제29조 2항 시행령 제16조 휴면회원에게 메일과 SMS를 발송할 경우 법적인 불이익을 받으실 수 있습니다.</li>
                            </ul>
                        </div>
                        <!-- //consult_box -->
                    </div>
                </form>
            </div>
            <!-- bottom_box -->
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="updateDormantMemBtn">선택 휴면 해제</button>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>