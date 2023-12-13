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
	<t:putAttribute name="title">회원탈퇴</t:putAttribute>
	
	
	
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){

        $("#pw").keydown(function(event) {
            if(event.keyCode == 13) {
                $('#btn_member_leave_pw').click();
                return false;
            }
        });

        /* 회원탈퇴검증 */
        $("#member_leave_step02").hide();
        $("#member_leave_step01").show();

        $("#btn_member_leave_pw").click(function () {
            if(jQuery('#pw').val() === '') {
                Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "확인");
                return false;
            }else{
                var url = '/front/member/auth-password-check';
                var param = $('#form_id_leave').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         $("#member_leave_step01").hide();
                         $("#member_leave_step02").show();
                     }
                });
            }
        });

        //회원탈퇴
        $("#btn_member_leave").click(function () {
            var withdrawalReasonCd = $("input:radio[name='withdrawalReasonCds']:checked").val();
            if($('#leave_check').is(':checked') == false) {
                Dmall.LayerUtil.alert("회원탈퇴에 동의하셔야 탈퇴가 가능합니다.", "알림");
                return;
            }
            /*
            Dmall.LayerUtil.confirm("정말 탈퇴하시겠습니까?",
                function() {
                    $('#withdrawalReasonCd').val(withdrawalReasonCd);
                    var url = '/front/member/member-delete';
                    var param = $('#form_id_leave').serializeArray();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        Dmall.FormUtil.submit('/front/login/logout', {});
                    }
                });
            })
            */
        });

        //탈퇴취소
        $("#btn_cancel_leave").click(function () {
            $("#member_leave_step02").hide();
            $("#member_leave_step01").show();
        });

    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 정보 <span>&gt;</span>회원탈퇴
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->

            <!--- 비밀번호 확인 ---->
            <form:form id="form_id_leave" commandName="so">
            <input type="hidden" name="withdrawalReasonCd" id="withdrawalReasonCd"/>
            <div class="mypage_content" id="member_leave_step01">
                <h3 class="mypage_con_tit">
                    회원탈퇴
                </h3>
                <p style="margin:30px 0 5px">* 홍길동 고객님의 개인정보를 안전하게 보호하기 위해 비밀번호를 다시 한번 확인드립니다.</p>
                <table class="tMember_Insert">
                    <caption>
                        <h1 class="blind">회원탈퇴페이지</h1>
                    </caption>
                    <colgroup>
                        <col style="width:160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>비밀번호 입력</th>
                            <td class="textL">
                                <input type="password" id="pw" name="pw" style="width:232px">
                                <button type="button" class="btn_mypage_ok" id="btn_member_leave_pw" >확인</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!---// 비밀번호 확인 ---->

            <!--- 비밀번호 확인 후 내용입력 ---->
            <div class="mypage_content" id="member_leave_step02">
                <h3 class="mypage_con_tit">
                    회원탈퇴
                    <span class="row_info_text">탈퇴신청에 앞서 아래의 사항을 반드시 확인하시기 바랍니다.</span>
                </h3>
                <div class="warning_box">
                    <h4 class="warning_title" style="margin-top:0">알아두세요!</h4>
                    <ul>
                        <li>1. 탈퇴 후 고객님의 정보는 전자상거래 소비자보호법에 의거한 개인정보보호정책에 따라 관리됩니다. </li>
                        <li>2. 탈퇴 시 고객님께서 보유하셨던 마켓포인트과 쿠폰, 다비치포인트는 모두 삭제됩니다. </li>
                        <li>3. 다음의 경우는 회원탈퇴가 불가합니다. 해당 사항이 있으신 경우는 내역을 종료하신 후 탈퇴 신청하세요. </li>
                    </ul>
                    <div class="warning_box_gray">
                        *현재 고객님의 반품처리 요청사항이나 고객서비스가 완료되지 않은 경우 <img src="/front/img/mypage/icon_gray_arrow.png" alt="" style="vertical-align:middle"> 서비스 처리 완료 후 탈퇴 가능합니다.<br>
                        *배송요청/배송중/반품요청/송금예정 등의 거래가 진행중인 경우 <img src="/front/img/mypage/icon_gray_arrow.png" alt="" style="vertical-align:middle"> 진행 중인 거래를 우선 마무리 해주시기 바랍니다.
                    </div>
                    <ul>
                        <li>4. 회원탈퇴 후 재가입 시에는 신규가입으로 처리되며, 탈퇴하신 ID는 다시 사용하실 수 없습니다.</li>
                        <li>5. 회원 탈퇴 시 해당 아이디와 주문내역은 ‘전자상거래에서의 소비자 보호에 관한 법률’에 의거 5년간 보관됩니다.</li>
                        <li style="margin-left:13px">보관 기간(5년) 경과 시 주문내역은 즉시 삭제 됩니다.</li>
                        <li style="margin-left:13px">단, 아이디는 재가입 방지를 위하여 보관됩니다.</li>
                    </ul>
                </div>
                <h3 class="mypage_con_stit">
                    회원탈퇴 사유
                </h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">회원탈퇴 사유 선택 폼입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:25%">
                        <col style="width:25%">
                        <col style="width:25%">
                        <col style="width:25%">
                    </colgroup>
                    <tbody>
                        <tr>
                        <c:forEach var="codeModel" items="${codeListModel}" varStatus="status">
                            <td class="textL" style="border-bottom:none">
                                <input type="radio" id="leave_member_reason_${status.count}" name="withdrawalReasonCds" value="${codeModel.dtlCd}">
                                <label for="leave_member_reason_${status.count}" style="font-weight:100"><span></span>${codeModel.dtlNm}</label>
                            </td>
                            <c:if test="${status.count%4 == 0}"></tr><tr></c:if>
                        </c:forEach>
                        </tr>
                    </tbody>
                </table>
                <h3 class="mypage_con_stit">
                    쇼핑에 더 해주시고 싶은 말씀 <span>(선택입력)</span>
                </h3>
                <textarea class="leave_reason" style="width:898px;height:114px" name="etcWithdrawalReason" id="etcWithdrawalReason"></textarea>
                <div class="leave_member_agree">
                    <label>
                        <input type="checkbox" name="leave_check" id="leave_check">
                        <span></span>
                    </label>
                    <label for="sms_get">회원탈퇴 안내를 모두 확인하였으며, 탈퇴에 동의합니다.</label>
                </div>
                <div class="btn_area">
                    <button type="button" class="btn_mypage_ok" id="btn_member_leave">탈퇴</button>
                    <button type="button" class="btn_mypage_cancel" id="btn_cancel_leave">취소</button>
                </div>
            </div>
            </form:form>
            <!---// 비밀번호 확인 후 내용입력 ---->

            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>