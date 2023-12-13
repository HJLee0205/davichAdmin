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
                // 목록
                $("#btn_list").on('click', function(e) {
                    history.back();
                });
                
                // 휴면 해제
                $("#updateDormantMemBtn").on('click', function(e) {
                    Dmall.LayerUtil.confirm('휴면 해제 하시겠습니까?', function() {
                        var url = '/admin/member/manage/dormant-member-update';
                        var param = {updMemberNo : $('#updMemberNo').val()};

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                Dmall.FormUtil.submit('/admin/member/manage/dormant-member');
                            }
                        });
                    });
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <c:set var="memDtl" value="${resultModel.data}" />
            <form id="form_id_memDtl" >
                <input type="hidden" name="updMemberNo" id="updMemberNo" value = "${memDtl.memberNo}" />
                <div class="tlt_box">
                    <div class="tlt_head">
                        회원 설정<span class="step_bar"></span>
                    </div>
                    <h2 class="tlth2">휴면 회원 관리</h2>
                </div>
                <!-- line_box -->
                <div class="line_box fri">
                    <h3 class="tlth3">기본 정보</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 가입일 표 입니다.">
                            <caption>가입일</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="510px">
                                <col width="150px">
                                <col width="510px">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>가입일시</th>
                                <td colspan="3">${memDtl.joinDttm}</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <h3 class="tlth3 btn1">개인 정보</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 기본정보 표 입니다. 구성은 이름/아이디, 실명확인, 성별, 생년월일, 이메일/수신여부, 핸드폰/수신여부, 전화번호, 주소 입니다.">
                            <caption>기본정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="510px">
                                <col width="150px">
                                <col width="510px">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>이름 / 아이디</th>
                                    <td>${memDtl.memberNm} / ${memDtl.loginId}</td>
                                    <th>닉네임</th>
                                    <td>${memDtl.memberNn}</td>
                                </tr>
                                <tr>
                                    <th class="line">본인인증</th>
                                    <td>
                                        <c:if test="${memDtl.realnmCertifyYn eq 'Y'}" >인증완료</c:if>
                                        <c:if test="${memDtl.realnmCertifyYn eq 'N'}" >인증미완료</c:if>
                                    </td>
                                    <th class="line">생년월일</th>
                                    <td>${memDtl.birth.replaceAll("^(\\d{4})(\\d{2})(\\d{2})$", "$1-$2-$3")}</td>
                                </tr>
                                <tr>
                                    <th>이메일</th>
                                    <td>${memDtl.email}</td>
                                    <th>이메일 수신여부</th>
                                    <td>
                                        <c:if test="${memDtl.emailRecvYn eq 'Y'}" >동의</c:if>
                                        <c:if test="${memDtl.emailRecvYn eq 'N'}" >거부</c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <th>휴대폰</th>
                                    <td>${memDtl.mobile}</td>
                                    <th>SMS 수신 여부</th>
                                    <td>
                                        <c:if test="${memDtl.smsRecvYn eq 'Y'}" >동의</c:if>
                                        <c:if test="${memDtl.smsRecvYn eq 'N'}" >거부</c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <th>주소</th>
                                    <td colspan="3">(${memDtl.newPostNo}) ${memDtl.roadAddr} (${memDtl.strtnbAddr})</td>
                                </tr>
                                <tr>
                                    <th>상세주소</th>
                                    <td colspan="3">${memDtl.dtlAddr}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <h3 class="tlth3">활동정보 <span class="desc">해당 회원이 쇼핑몰에서 활동한 정보입니다.</span></h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 활동정보 표 입니다. 구성은 최근로그인, 최근수정일, 회원등급, 포인트, 마켓포인트, 보유쿠폰, 구매금액, 주문횟수, 방문횟수, 상품후기, 상품문의, 1:1문의 입니다.">
                            <caption>활동정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="510px">
                                <col width="150px">
                                <col width="510px">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>휴면전환일시</th>
                                <td>${memDtl.dormantDttm}</td>
                                <th>방문횟수</th>
                                <td><fmt:formatNumber value='${memDtl.loginCnt}' type='number'/>회</td>
                            </tr>
                            <tr>
                                <th class="line">포인트</th>
                                <td><fmt:formatNumber value='${memDtl.prcAmt}' type='number'/>p / <fmt:formatNumber value="${memDtl.prcPoint}" type="number"/>p</td>
                                <th>회원등급</th>
                                <td>${memDtl.memberGradeNm}</td>
                            </tr>
                            <tr>
                                <th>구매금액</th>
                                <td><fmt:formatNumber value='${memDtl.saleAmt}' type='number'/>원</td>
                                <th class="line">보유쿠폰</th>
                                <td><fmt:formatNumber value='${memDtl.cpCnt}' type='number'/>장</td>
                            </tr>
                            <tr>
                                <th class="line">주문건수</th>
                                <td><fmt:formatNumber value='${memDtl.ordCnt}' type='number'/>건 <span class="nudge">(평균 0원)</span></td>
                                <th>상품문의</th>
                                <td><fmt:formatNumber value='${memDtl.questionCnt}' type='number'/>개 </td>
                            </tr>
                            <tr>
                                <th class="line">1:1문의</th>
                                <td><fmt:formatNumber value='${memDtl.inquiryCnt}' type='number'/>개 </td>
                                <th class="line">상품후기</th>
                                <td><fmt:formatNumber value='${memDtl.reviewCnt}' type='number'/>개 </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <!-- double_lay -->
                    <div class="double_lay disposal">
                        <div class="left">
                            <h3 class="tlth3">관리자 메모</h3>
                            <div class="txt_area" style="height: 150px;">
                                <textarea name="managerMemo" id="managerMemo" readonly>${memDtl.managerMemo}</textarea>
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
                    <!-- double_lay -->
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="updateDormantMemBtn">휴면 해제</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>
