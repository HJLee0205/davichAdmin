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
    <t:putAttribute name="title">회원 관리 > 회원</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));

                // 숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9\-]/gi,"") );});
                // 영문만 입력가능
                $(document).on('keyup', 'input:text[engOnly]', function() {$(this).val($(this).val().replace(/[^\w\@\.]/gi, ''));});

                // 검색
                $('#btn_id_search').on('click', function() {
                    var fromDttm = $("#join_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#join_sc02").val().replace(/-/gi, "");
                    if(fromDttm && toDttm && fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $("#search_id_page").val("1");
                    $('#form_id_search').attr('action', '/admin/member/manage/member');
                    $('#form_id_search').submit();
                });

                //검색 타입 변경시 텍스트 입력 설정 변경(한글/영문/숫자 입력 제한)
                $('#srch_id_searchType').change(function(e){
                    $("input[name='searchWords']").remove();

                    var inputText = '';
                    if($(this).val() == 'all' || $(this).val() == 'name' || $(this).val() == 'nickname'){
                        inputText = '<input type="text" name="searchWords"/>'
                    }else if($(this).val() == 'id' || $(this).val() == 'email'){
                        inputText = '<input type="text" name="searchWords" engOnly />'
                    }else if($(this).val() == 'memberNo'){
                        inputText = '<input type="text" name="searchWords" numberOnly />'
                    }else if($(this).val() == 'mobile') {
                        inputText = '<input type="text" name="searchWords" numberOnly />'
                    }

                    $('div.select_inp').append(inputText);
                });

                // 정렬 select 이벤트
                $('select[name=sidx]').on('change', function() {
                    $('input[name=sidx]').val($(this).val().split(/\s/)[0]);
                    $('input[name=sord]').val($(this).val().split(/\s/)[1]);

                    $("#search_id_page").val("1");
                    $('#form_id_search').attr('action', '/admin/member/manage/member');
                    $('#form_id_search').submit();
                });

                // 엑셀 다운로드 버튼 클릭
                $('#btn_download').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#form_id_search').attr('action', '/admin/member/manage/memberinfo-excel');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '/admin/member/manage/member');
                });

                Dmall.common.comma();
            });

            //회원 상세 정보
            function viewMemInfoDtl(memberNo){
                Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', {memberNo : memberNo});
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    회원 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">회원 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <!-- search_tbl -->
                    <form:form action="/admin/member/manage/member" id="form_id_search" commandName="memberManageSO">
                        <form:hidden path="page" id="search_id_page" />
                        <form:hidden path="rows" />
                        <form:hidden path="sidx" />
                        <form:hidden path="sord" />
                        <div class="search_tbl">
                            <table summary="이표는 회원리스트 검색 표 입니다. 구성은 가입일, 최종방문일, 생일, SMS수신, 이메이수신, 회원등급, 구매금액, 마켓포인트, 주문횟수, 댓글횟수, 방문횟수, 성별, 포인트, 가입방법, 검색어 입니다.">
                                <caption>회원 관리</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="510px">
                                    <col width="150px">
                                    <col width="510px">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>가입일</th>
                                    <td colspan="3">
                                        <tags:calendar from="joinStDttm" to="joinEndDttm" fromValue="${memberManageSO.joinStDttm}" toValue="${memberManageSO.joinEndDttm}" idPrefix="join" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>SMS 수신</th>
                                    <td>
                                        <tags:radio name="smsRecvYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_smsRecvYn" value="${memberManageSO.smsRecvYn}" />
                                    </td>
                                    <th>회원유형</th>
                                    <td>
                                        <span class="select">
                                            <label for="srch_id_memberTypeCd"></label>
                                            <select name="memberTypeCd" id="srch_id_memberTypeCd">
                                                <tags:option codeStr=":전체;01:일반회원;05:가맹점;06:임직원" value="${memberManageSO.memberTypeCd}"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>이메일 수신</th>
                                    <td>
                                        <tags:radio name="emailRecvYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_emailRecvYn" value="${memberManageSO.emailRecvYn}" />
                                    </td>
<%--                                    <th>회원등급</th>--%>
<%--                                    <td>--%>
<%--                                        <span class="select">--%>
<%--                                            <label for="srch_id_memberGradeNo"></label>--%>
<%--                                            <select name="memberGradeNo" id="srch_id_memberGradeNo">--%>
<%--                                                <tags:option codeStr=":전체;1:일반;3:실버;4:골드;2:플래티넘" value="${memberManageSO.memberGradeNo}"/>--%>
<%--                                            </select>--%>
<%--                                        </span>--%>
<%--                                    </td>--%>
                                    <th>생일</th>
                                    <td>
                                        <span class="select">
                                            <label for="srch_id_bornMonth"></label>
                                            <select name="bornMonth" id="srch_id_bornMonth">
                                                <tags:option codeStr=":전체;01:1월;02:2월;03:3월;04:4월;05:5월;06:6월;07:7월;08:8월;09:9월;10:10월;11:11월;12:12월" value="${memberManageSO.bornMonth}"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>PUSH 동의</th>
                                    <td>
                                        <c:set var="str1" value="${fn:join(memberManageSO.pushGbCd, ';')}"/>
                                        <tags:checkboxs codeStr="01:댓글;02:마케팅;03:야간 푸시;" name="pushGbCd" idPrefix="pushGbCd" valueList="${str1}"/>
                                    </td>
                                    <th>가입유형</th>
                                    <td>
                                        <c:set var="str2" value="${fn:join(memberManageSO.joinPathCd, ';')}"/>
                                        <tags:checkboxs codeStr="SHOP:일반가입;KT:카카오;NV:네이버;AP:애플;" name="joinPathCd" idPrefix="joinPathCd" valueList="${str2}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>포인트</th>
                                    <td colspan="3">
                                        <span class="intxt">
                                            <input type="text" name="stPrcPoint" value="${memberManageSO.stPrcPoint}" numberOnly>
                                        </span>
                                        ~
                                        <span class="intxt ml10">
                                            <input type="text" name="endPrcPoint" value="${memberManageSO.endPrcPoint}" numberOnly>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td colspan="3">
                                        <div class="select_inp">
                                            <span>
                                                <label for="srch_id_searchType"></label>
                                                <select name="searchType" id="srch_id_searchType">
                                                    <tags:option codeStr="all:전체;memberNo:회원번호;name:이름;id:아이디;nickname:닉네임;email:이메일;mobile:휴대폰;" value="${memberManageSO.searchType}"/>
                                                </select>
                                            </span>
                                            <input type="text" name="searchWords" value="${memberManageSO.searchWords}">
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
                <div class="line_box">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                              총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>명의 회원이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <span class="select">
                                <label for=""></label>
                                <select name="sidx">
                                    <tags:option codeStr="REG_DTTM DESC:가입일 최신순;REG_DTTM ASC:가입일 오래된순;SALE_AMT DESC:구매금액 많은순;SALE_AMT ASC:구매금액 적은순;ORD_CNT DESC:주문건수 많은순;ORD_CNT ASC:주문건수 적은순;" value="${memberManageSO.sidx} ${memberManageSO.sord}"/>
                                </select>
                            </span>
                            <button class="btn_exl" id="btn_download">
                                <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="회원 리스트"  id="table_id_memberList">
                            <caption>회원 리스트</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="8%">
<%--                                <col width="8%">--%>
                                <col width="8%">
                                <col width="8%">
                                <col width="6%">
                                <col width="8%">
                                <col width="12%">
                                <col width="10%">
                                <col width="8%">
                                <col width="7%">
<%--                                <col width="5%">--%>
                                <col width="7%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>회원유형</th>
<%--                                <th>등급</th>--%>
                                <th>상태</th>
                                <th>가입유형</th>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>이메일</th>
                                <th>휴대폰번호</th>
                                <th>가입일시</th>
                                <th>포인트</th>
<%--                                <th>스탬프</th>--%>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_memberList">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="13">데이터가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="memList" items="${resultListModel.resultList}" varStatus="status">
                                        <tr>
                                            <td>${memList.sortNum}</td>
                                            <td>${memList.memberTypeNm}</td>
<%--                                            <td>${memList.memberGradeNm}</td>--%>
                                            <td>${memList.memberStatusNm}</td>
                                            <td>${memList.joinPathNm}</td>
                                            <td>${memList.memberNm}</td>
                                            <td>${memList.loginId}</td>
                                            <td>${memList.email}</td>
                                            <td>${memList.mobile}</td>
                                            <td><fmt:formatDate value="${memList.regDttm}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                            <td class="comma">${memList.prcPoint}</td>
<%--                                            <td>${memList.prcStamp}</td>--%>
                                            <td>
                                                <div class="pop_btn">
                                                    <a href="javascript:;" class="btn_gray" onclick="viewMemInfoDtl('${memList.memberNo}')">수정</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <grid:paging resultListModel="${resultListModel}" />
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
