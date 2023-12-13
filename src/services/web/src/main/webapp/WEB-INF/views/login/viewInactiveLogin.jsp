<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
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
    <t:putAttribute name="title">로그인</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                $('.btn_popup_login').on('click', function() {
                    if($('#rule_agree').is(':checked') == false) {
                        Dmall.LayerUtil.alert("휴면해제에 동의해야 합니다.", "알림");
                        return;
                    }

                    successIdentity();
                });
            });

            // success identinty
            function successIdentity(){
                var url = '/front/member/dormant-member-update';
                var param = $('#form_id_identity').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        Dmall.LayerUtil.alert("휴면상태에서 해제가 완료되었습니다.", "알림");
                        window.location.href = '/front/login/member-login';
                    }
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <form:form id="form_id_identity" >
            <input type="hidden" id="loginId" name="loginId" value="${loginId}"/>
        </form:form>
        <!--- contents --->
        <div class="contents fixwid">
            <div id="member_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span>
            </div>
            <div class="inactivity_login_box">
                <div class="inactivity_text01">
                    회원님의 계정은 <em>현재 휴면 상태</em> 입니다. <br>
                    개인정보 보호를 위해 1년 이상 또는 로그인 이력이 없으신 회원님의 개인정보는 별도 보관 처리 됩니다.
                </div>
                <div class="inactivity_text02">
                    회원가입 시 사용한 본인인증 방식을 통해 본인인증을 완료하면 서비스를 정상적으로 이용하실 수 있습니다.<br>
                    아래 방법 중 회원가입 시 사용한 인증방식을 선택하여 본인인증을 진행해 주세요.
                </div>

                <div class="join_check_all" style="width:80%; margin:30px auto 0 auto;">
                    <label>
                        <input type="checkbox" name="rule_agree" id="rule_agree">
                        <span></span>
                    </label>
                    <label for="rule02_agree">회원 계정 휴면 해제 동의</label>
                </div>
                <div class="pw_search_info02" style="margin:0 auto 24px auto">
                    <button type="button" class="btn_popup_login" style="margin-top:22px">휴면 해제 하기</button>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>