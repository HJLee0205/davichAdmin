<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">1:1문의</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        jQuery('#btn_id_insert').on('click', function(e) {
            location.href = "inquiry-insert-form";
        });

        //페이징
        $('#div_id_paging').grid(jQuery('#form_id_search'));
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 활동 <span>&gt;</span>1:1문의
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    1:1문의
                    <span class="row_info_text">고객님께서 문의하신 내용을 확인하실 수 있습니다.</span>
                </h3>
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <div class="warning_box">
                    <h4 class="warning_title">알아두세요!</h4>
                    <span>1:1상담은 고객센터의 1:1문의를 통해 접수하실 수 있습니다.</span>
                    <button type="button" class="btn_myqna" id = "btn_id_insert">1:1문의</button>
                </div>
                <table class="tMypage_Board my_qna_table">
                    <caption>
                        <h1 class="blind">1:1문의 게시판 목록 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:107px">
                        <col style="width:107px">
                        <col style="width:">
                        <col style="width:110px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>답변상태</th>
                            <th>문의유형</th>
                            <th>제목</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                        <c:forEach var="inquiryList" items="${resultListModel.resultList}" varStatus="status">
                        <c:if test="${inquiryList.lvl eq '0' || inquiryList.lvl eq null}" >
                        <tr class="title">
                            <td><c:if test="${inquiryList.replyStatusYn == 'Y'}" >답변완료</c:if><c:if test="${inquiryList.replyStatusYn != 'Y'}" ><span class="qna_fGray">답변대기</span></c:if></td>
                            <td>${inquiryList.inquiryNm}</td>
                            <td class="textL">Q. ${inquiryList.title}</td>
                            <td>
                                <fmt:formatDate pattern="yyyy-MM-dd" value="${inquiryList.regDttm}" />
                                </br><fmt:formatDate pattern="aa hh:mm:ss" value="${inquiryList.regDttm}" />
                            </td>
                        </tr>
                        <tr class="hide">
                            <td colspan="4" class="my_qna_view">${inquiryList.content}</td>
                        </tr>
                        </c:if>
                        <c:if test="${inquiryList.lvl eq '1'}" >
                            <tr class="title">
                                <td></td>
                                <td></td>
                                <td class="textL">
                                    <img src="/front/img/mypage/icon_answer.png" style="vertical-align:middle">
                                    ${inquiryList.title}
                                </td>
                                <td>
                                <fmt:formatDate pattern="yyyy-MM-dd" value="${inquiryList.regDttm}" />
                                </br><fmt:formatDate pattern="aa hh:mm:ss" value="${inquiryList.regDttm}" />
                                </td>
                            </tr>
                            <tr class="hide">
                                <td colspan="4" class="my_qna_view">${inquiryList.content}</td>
                            </tr>
                        </c:if>
                        </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">조회된 데이터가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                <!----// 페이징 ---->
                </form:form>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>