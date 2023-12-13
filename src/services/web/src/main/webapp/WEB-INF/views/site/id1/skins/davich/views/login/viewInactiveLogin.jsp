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
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 로그인</t:putAttribute>
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
                        /*Dmall.LayerUtil.alert("휴면상태에서 해제가 완료되었습니다.", "알림");*/
                        //window.location.href = '/front/login/member-login';
                        window.location.href = '/front/main-view';
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
            <div class="inactivity_login_box">
                <%--<div class="inactivity_text01">
                    회원님의 계정은 <em>현재 휴면 상태</em> 입니다. <br>
                    개인정보 보호를 위해 1년 이상 또는 로그인 이력이 없으신 회원님의 개인정보는 별도 보관 처리 됩니다.
                </div>
                <div class="inactivity_text02">
                    &lt;%&ndash;회원가입 시 사용한 본인인증 방식을 통해 본인인증을 완료하면 서비스를 정상적으로 이용하실 수 있습니다.<br>
                    아래 방법 중 회원가입 시 사용한 인증방식을 선택하여 본인인증을 진행해 주세요.&ndash;%&gt;
                </div>

                <div class="join_check_all">
                    <input type="checkbox" name="rule_agree" id="rule_agree" class="order_check">
                    <label for="rule_agree">
                        <span></span>
                        회원 계정 휴면 해제 동의
                    </label>
                </div>
                <div class="pw_search_info02">
                    &lt;%&ndash;<button type="button" class="btn_go_prev">이전페이지</button>&ndash;%&gt;
                    <button type="button" class="btn_popup_login">휴면 해제 하기</button>
                </div>--%>

                <div class="inactivity_text01">
                    회원님의 계정은 휴면상태입니다.
                </div>
                <div class="inactivity_text02">
                    회원님은 장기간 미이용 고객으로 휴면계정으로 전환되었습니다.
                    <em>아래 &lt;휴면 해지하기&gt; 버튼을 클릭하시면 고객님의 휴면 상태가 해제되어 분리보관되었던 개인 정보가 다시 통합 관리됩니다.</em>
                </div>
                <input type="checkbox" name="rule_agree" id="rule_agree" class="order_check" checked style="display:none;">
                <button type="button" class="btn_popup_login btn_go_inactivity02"><i></i>휴면 해지하기</button>

                <div class="inactivity_text02">
                    다비치마켓은 회원님의 개인정보보호를 위하여 장기간 로그인 하지 않은 계정을<br>
                    휴면 계정으로 전환 하여 개인정보를 안전 하게 분리 보관하고 있습니다.<br>
                    위 수단으로 본인 확인이 되지 않으면 휴면 계정 해제에 도움을 드리기 어렵습니다.
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>