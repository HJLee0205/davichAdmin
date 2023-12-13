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
    <t:putAttribute name="title">탈퇴 회원 관리 > 회원</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 목록
                $("#btn_list").on('click', function(e) {
                    history.back();
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    회원 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">탈퇴 회원 관리</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">개인정보</h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 개인정보 표 입니다. 구성은  입니다.">
                        <caption>개인정보</caption>
                        <colgroup>
                            <col width="150px">
                            <col width="">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>이름 / 아이디</th>
                            <c:set var="result" value="${fn:substring(resultModel.data.loginId, 0, 5)}"/>
                            <c:forEach begin="5" end="${fn:length(resultModel.data.loginId)}">
                                <c:set var="result" value="${result.concat('*')}"/>
                            </c:forEach>
                            <td>${resultModel.data.memberNm}  / ${result} </td>
                        </tr>
                        <tr>
                            <th>탈퇴일시</th>
                            <td>${resultModel.data.withdrawalDttm}</td>
                        </tr>
                        <tr>
                            <th>탈퇴사유</th>
                            <td>
                                <c:if test="${resultModel.data.withdrawalTypeCd ne '02'}">
                                    ${resultModel.data.withdrawalTypeNm}
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>탈퇴내용</th>
                            <td>${resultModel.data.etcWithdrawalReason} </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- double_lay -->
                <div class="double_lay disposal">
                    <div class="left">
                        <h3 class="tlth3">관리자 메모</h3>
                        <div class="txt_area" style="height: 150px;">
                            <textarea readonly>${resultModel.data.managerMemo}</textarea>
                        </div>
                    </div>
                    <div class="right">
                        <div>
                            <h3 class="tlth3">처리로그</h3>
                            <div class="disposal_log">
                                <ul>
                                    <c:forEach var = "prcLogList" items="${prcLog}">
                                        <li>[${prcLogList.chgDttm}] [${prcLogList.prcNm}] ${prcLogList.prcLogNm} 변경 </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- //double_lay -->
            </div>
            <!-- //line_box -->
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>
