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
    <t:putAttribute name="title">발송내역 > 푸시알림 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 목록
                $('#btn_list').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    Dmall.FormUtil.submit('/admin/operation/app/sendHist');
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> 푸시알림<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">발송내역</h2>
            </div>
            <form action="" id="form_app_hist">
                <div class="line_box">
                    <h3 class="tlth3">기본정보</h3>
                    <!-- search_tbl -->
                    <div class="search_tbl tblmany">
                        <table summary="이표는  PUSH 발송 내역 검색 표 입니다. 구성은 조회기간, 상태, 검색어 입니다.">
                            <caption>PUSH 발송 내역</caption>
                            <colgroup>
                                <col width="10%">
                                <col width="23%">
                                <col width="10%">
                                <col width="23%">
                                <col width="10%">
                                <col width="24%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>발송인</th>
                                <td>${resultPush.senderNm}</td>
                                <th>등록일</th>
                                <td colspan="3">${resultPush.regDate}</td>
                            </tr>
                            <tr>
                                <th>발송일시</th>
                                <td>${resultPush.sendDttm}</td>
                                <th>발송상태</th>
                                <td>${resultPush.pushStatusNm}</td>
                                <th>발송건수</th>
                                <td>${resultPush.sendCnt}</td>
                            </tr>
                            <tr>
                                <th>클릭수</th>
                                <td><em>${resultPush.confCnt}</em></td>
                                <th>클릭률</th>
                                <td colspan="3"><em>${resultPush.confRate} %</em></td>
                            </tr>
                            <tr>
                                <th>구매건수</th>
                                <td>${resultPush.ordCnt}</td>
                                <th>예약건수</th>
                                <td colspan="3">${resultPush.visitCnt}</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <h3 class="tlth3">내용정보</h3>
                    <div class="tblw">
                        <table summary="이표는 app 발송내역 표 입니다.">
                            <caption>app 발송내역</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th rowspan="2">받는사람</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${resultPush.recvCndtGb == 'all'}">
                                            전체 회원
                                        </c:when>
                                        <c:when test="${resultPush.recvCndtGb == 'search'}">
                                            검색된 회원
                                        </c:when>
                                        <c:otherwise>
                                            선택된 회원
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="disposal_log" >
                                        <ul id="totalMemberList">
                                            <c:forEach var="receiver" items="${receiverList}" varStatus="status">
                                                <li>${receiver.receiverId} | ${receiver.receiverNm}</li>
                                            </c:forEach>
<%--                                            <li>등급 | 이름 | test@naver.com | 010 1234 5678</li>--%>
<%--                                            <li>등급 | 이름 | test@naver.com | 010 1234 5678</li>--%>
<%--                                            <li>등급 | 이름 | test@naver.com | 010 1234 5678</li>--%>
<%--                                            <li>등급 | 이름 | test@naver.com | 010 1234 5678</li>--%>
<%--                                            <li>등급 | 이름 | test@naver.com | 010 1234 5678</li>--%>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <c:if test="${resultPush.sendType eq '2'}">
                                <tr>
                                    <th>예약 발송 일시</th>
                                    <td>${resultPush.sendTime}</td>
                                </tr>
                            </c:if>
                            <tr>
                                <th>이미지</th>
                                <td>
                                    <img src="${resultPush.imgUrl}" alt="">
                                </td>
                            </tr>
                            <tr>
                                <th>링크</th>
                                <td>${resultPush.link}</td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>${resultPush.sendMsg}</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_list">목록</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>