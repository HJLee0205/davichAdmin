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
	<t:putAttribute name="title">약관동의</t:putAttribute>


	<t:putAttribute name="script">
    <script>
		$(document).ready(function(){
		    $('#all_rule_agree').bind('click',function (){
		       var checkObj = $("input[type='checkbox'");
		       if($('#all_rule_agree').is(':checked')) {
		           checkObj.prop("checked",true);
		       }else{
		           checkObj.prop("checked",false);
		       }
		    });

		    $('.btn_join_ok').on('click',function(){

		        if($('#rule01_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("쇼핑몰 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }
		        if($('#rule02_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("개인정보 수집 및 이용 약관에 동의해야 합니다.", "알림");
		            return;
                }
		        if($('#rule03_agree').is(':checked') == false) {
                    Dmall.LayerUtil.alert("개인정보처리방침에 동의해야 합니다.", "알림");
                    return;
                }

		        //위 validation을 지나왔다면 필수약관은 모두 동의한것이기 때문에 Y값을 적용한다.
		        $('#paramRule01Agree').val("Y");
		        $('#paramRule02Agree').val("Y");
		        $('#paramRule03Agree').val("Y");

		        var data = $('#form_id_join').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
		        Dmall.FormUtil.submit('/front/member/member-insert-form', param);
		    });


		});
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
    <!--- contents --->
    <div class="contents fixwid">
        <form:form id="form_id_join">
        <input type="hidden" name="mode" id="mode" value="j"/>
        <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/>
        <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/>
        <input type="hidden" name="memberNm" id="memberNm" value="${so.memberNm}"/>
        <input type="hidden" name="birth" id="birth" value="${so.birth}"/>
        <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}"/>
        <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/>
        <input type="hidden" name="memberGbCd" id="memberGbCd" value="${so.memberGbCd}"/>
        <input type="hidden" name="rule01Agree" id="paramRule01Agree" value=""/>
        <input type="hidden" name="rule02Agree" id="paramRule02Agree" value=""/>
        <input type="hidden" name="rule03Agree" id="paramRule03Agree" value=""/>
        </form:form>
        <div id="member_location">
            <a href="javascript:history.back(-1);">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>회원가입
        </div>
        <c:if test="${so.memberDi != '' && so.memberDi ne null}">
        <ul class="join_steps">
            <li>본인인증</li>
            <li  class="thisstep">약관동의</li>
            <li>회원정보입력</li>
            <li>가입완료</li>
        </ul>
        </c:if>
        <c:if test="${so.memberDi == '' || so.memberDi eq null }">
        <ul class="join_steps_01">
            <li class="thisstep">약관동의</li>
            <li>회원정보입력</li>
            <li>가입완료</li>
        </ul>
        </c:if>
        <div class="join_check_all">
            <label>
                <input type="checkbox" name="all_rule_agree" id="all_rule_agree">
                <span></span>
            </label>
            <label for="rule02_agree">하단 약관 내용에 대해 전체 동의합니다.</label>
        </div>
        <h3 class="join_stit">쇼핑몰 이용약관</h3>
        <!--- 쇼핑몰 이용약관 --->
        <div class="join_rule_box01">
            <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_03.data.content}</textarea>
        </div>
        <div class="join_check">
            <label>
                <input type="checkbox" id="rule01_agree">
                <span></span>
            </label>
            <label for="rule01_agree">약관에 동의합니다.</label>
        </div>
        <!---// 쇼핑몰 이용약관 --->

        <!--- 개인정보 수집 및 이용에 대한 동의 --->
        <h3 class="join_stit">개인정보 수집 및 이용에 대한 동의</h3>
        <div class="join_rule_box01">
            <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_05.data.content}</textarea>
        </div>
        <div class="join_check">
            <label>
                <input type="checkbox" id="rule02_agree">
                <span></span>
            </label>
            <label for="rule02_agree">약관에 동의합니다.</label>
        </div>
        <!---// 개인정보 수집 및 이용에 대한 동의 --->
        <!--- 개인정보 처리방침 동의 항목  --->
        <h3 class="join_stit">개인정보 처리방침 동의</h3>
        <div class="join_rule_box01">
            <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_04.data.content}</textarea>
        </div>
        <div class="join_check">
            <label>
                <input type="checkbox" id="rule03_agree">
                <span></span>
            </label>
            <label for="rule03_agree">약관에 동의합니다.</label>
        </div>
        <!---// 개인정보 수집 및 이용에 대한 동의 --->
        <!--- 개인정보 제3자 위탁 동의 --->
        <c:if test="${ term_07.data.useYn eq 'Y'}">
        <h3 class="join_stit">개인정보 제3자 제공동의(선택)</h3>
        <div class="join_rule_box01">
            <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_07.data.content}</textarea>
        </div>
        <!---// 개인정보 제3자 위탁 동의 --->
        <div class="join_check">
            <label>
                <input type="checkbox" name="rule04_disagree" id="rule04_agree">
                <span></span>
            </label>
            <label for="rule04_agree">약관에 동의합니다.</label>
        </div>
        </c:if>
        <!--- 개인정보처리위탁동의 --->
        <c:if test="${ term_08.data.useYn eq 'Y'}">
        <h3 class="join_stit">개인정보처리위탁동의(선택)</h3>
            <div class="join_rule_box01">
                <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_08.data.content}</textarea>
            </div>
            <!---// 개인정보취급위탁동의 --->
            <div class="join_check">
                <label>
                    <input type="checkbox" name="rule05_disagree" id="rule05_agree">
                    <span></span>
                </label>
                <label for="rule05_agree">약관에 동의합니다.</label>
            </div>
        </c:if>
        <div class="btn_area">
            <button type="button" class="btn_join_ok">회원가입</button>
        </div>
    </div>
    <!---// contents --->
	</t:putAttribute>
</t:insertDefinition>