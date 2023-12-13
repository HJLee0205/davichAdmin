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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">마이페이지 :: 회원탈퇴</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
		<script>
			$(document).ready(function(){
				var orderCount = "${orderCount}";
				var joinShopCd = "${resultModel.data.joinPathCd}";

				$("#pw").keydown(function(event) {
					if(event.keyCode == 13) {
						$('#btn_member_leave_pw').click();
						return false;
					}
				});

				/* 회원탈퇴검증 */
				if(joinShopCd == 'NV' || joinShopCd == 'KT' || joinShopCd == 'FB'){	// 간편로그인 회원은 비밀번호 검증X
					$("#member_leave_step01").hide();
					$("#member_leave_step02").show();
				}else{
					$("#member_leave_step02").hide();
					$("#member_leave_step01").show();
				}

				$("#btn_member_leave_pw").click(function () {
					if(jQuery('#pw').val() === '') {
						Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "확인");
						return false;
					}  else {
						var url = '/m/front/member/auth-password-check';
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
					if (Number(orderCount) > 0) {
						Dmall.LayerUtil.alert("현재 진행중인 거래가 있어 탈퇴처리가 불가능합니다. 해당 내역을 확인하신 후 탈퇴신청하여 주세요.", "확인");
						return false;
					}

					var withdrawalReasonCd = $("input:radio[name='withdrawalReasonCds']:checked").val();
					if($('#leave_check').is(':checked') == false) {
						Dmall.LayerUtil.alert("회원탈퇴에 동의하셔야 탈퇴가 가능합니다.", "알림");
						return;
					}
					Dmall.LayerUtil.confirm("정말 탈퇴하시겠습니까?",function() {
						var url = '/m/front/member/leave-possibility-check';
						var param = $('#form_id_leave').serializeArray();
						Dmall.AjaxUtil.getJSON(url, param, function(result) {
							if(result.success) {
								$('#withdrawalReasonCd').val(withdrawalReasonCd);
								var url = '/m/front/member/member-delete';
								var param = $('#form_id_leave').serializeArray();
								Dmall.AjaxUtil.getJSON(url, param, function(result) {
									if(result.success) {
										$("#member_leave_step02").hide();
										$("#member_leave_step03").show();
									}else{
										Dmall.LayerUtil.alert("탈퇴처리중 오류가 발생하였습니다.관리자에게 문의 바랍니다.", "알림");
									}
								});
							}else{
								Dmall.LayerUtil.alert("진행중인 상품정보가 있습니다. 확인후 탈퇴 바랍니다.", "알림");
								return;
							}
						});
					})
				});

				//홈화면으로
				$('#btn_go_mypage').click(function () {
					Dmall.FormUtil.submit('/front/login/logout', {});
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

		<div id="middle_area">
			<div class="product_head">
				<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
				회원탈퇴
			</div>

			<div class="my_shopping_top">
				<ul class="my_shopping_info">
					<li>회원 탈퇴를 진행합니다.</li>
				</ul>
			</div>

			<form:form id="form_id_leave" commandName="so">
				<input type="hidden" name="withdrawalReasonCd" id="withdrawalReasonCd"/>
				<!--- 비밀번호 확인 ---->
				<div class="mypage_body" id="member_leave_step01">
					<div class="password_check_area">
						<p class="tit">"본인확인을 위해 다비치마켓 계정 비밀번호를 한번 더 입력해 주세요"</p>
						<input type="password" class="form_password" id="pw" name="pw" placeholder="영문, 숫자, 특수문자 8~16자">
						<div class="btn_password_area">
							<button type="button" class="btn_check_pw" id="btn_member_leave_pw">확인</button>
						</div>
					</div>
				</div>
				<!---// 비밀번호 확인 ---->

				<!--- 비밀번호 확인 후 내용입력 ---->
				<div class="mypage_body" id="member_leave_step02">
					<div class="member_leave">
						<p class="text">회원탈퇴 안내</p>
					</div>
					<h4 class="my_stit marginT46">회원탈퇴 사유</h4>

					<ul class="leave_reason">
						<c:forEach var="codeModel" items="${codeListModel}" varStatus="status">
						<li>
							<input type="checkbox" class="member_check" id="leave_member_reason_${status.count}" name="withdrawalReasonCds" value="${codeModel.dtlCd}">
							<label for="leave_member_reason_${status.count}"><span></span>${codeModel.dtlNm}</label>
						</li>
						<c:if test="${status.count%4 == 0}"></tr><tr></c:if>
						</c:forEach>
					</ul>

					<h4 class="my_stit marginT46">추가로 하시고픈 말씀이 있다면 이곳에 적어주세요.</h4>
					<div class="leave_reason_text">
						<textarea class="leave_reason"  name="etcWithdrawalReason" id="etcWithdrawalReason"></textarea>
					</div>
					<p class="leave_check_area">
						<input type="checkbox" class="member_check" name="leave_check" id="leave_check">
						<label for="leave_check"><span></span>회원탈퇴 안내를 모두 확인하였으며, 탈퇴에 동의합니다.</label>
					</p>
					<div class="btn_leave_area">
						<button type="button" class="btn_leave_cancel" id="btn_cancel_leave">취소</button>
						<button type="button" class="btn_go_leave" id="btn_member_leave">탈퇴</button>
					</div>

				</div>
				<!---// 비밀번호 확인 후 내용입력 ---->
			</form:form>

			<!--- 회원탈퇴 완료 ---->
			<div class="mypage_body" id="member_leave_step03" style="display:none;">
				<div class="member_leave_completed">
					<i class="icon_leave"></i>
					<p class="tit">회원탈퇴가 완료되었습니다.</p>
					<p>그동안 다비치마켓 상품을 이용해 주셔서 감사합니다.<br> 보다 나은 상품으로 찾아 뵙겠습니다.</p>
					<p class="eng_leave">Thank you.</p>
					<button type="button" class="btn_go_mypage" id="btn_go_mypage">홈화면으로</button>
				</div>
			</div>
			<!---// 회원탈퇴 완료 ---->

		</div>
		<!---// 마이페이지 메인 --->
	</t:putAttribute>
</t:insertDefinition>