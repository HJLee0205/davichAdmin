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
	<t:putAttribute name="title">다비치마켓 :: 약관동의</t:putAttribute>
	<t:putAttribute name="script">

    <script>
		$(document).ready(function(){
		    $('#all_rule_agree').bind('click',function (){
		       var checkObj = $("input[type='checkbox']");
		       if($('#all_rule_agree').is(':checked')) {
		           checkObj.prop("checked",true);
		       }else{
		           checkObj.prop("checked",false);
		       }
		    });

		    $('.btn_go_next').on('click',function(){

		        /*if($('#rule01_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("쇼핑몰 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }
		        if($('#rule02_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("개인정보 수집 및 이용 약관에 동의해야 합니다.", "알림");
		            return;
                }*/
		        /* if($('#rule03_agree').is(':checked') == false) {
                    Dmall.LayerUtil.alert("개인정보처리방침에 동의해야 합니다.", "알림");
                    return;
                } */

                if($('#rule04_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("개인 정보 처리방침에 동의해야 합니다.", "알림");
		            return;
		        }

                if($('#rule22_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("위치 정보 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }

                if($('#rule21_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("청소년 보호정책에 동의해야 합니다.", "알림");
		            return;
		        }

                if($('#rule09_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("멤버쉽 회원 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }

                if($('#rule10_agree').is(':checked') == false) {
		            Dmall.LayerUtil.alert("온라인 몰 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }

		        //위 validation을 지나왔다면 필수약관은 모두 동의한것이기 때문에 Y값을 적용한다.
		        /*$('#paramRule01Agree').val("Y");
		        $('#paramRule02Agree').val("Y");*/

                $('#paramRule04Agree').val("Y");
                $('#paramRule22Agree').val("Y");
                $('#paramRule21Agree').val("Y");
                $('#paramRule09Agree').val("Y");
                $('#paramRule10Agree').val("Y");

		        //$('#paramRule03Agree').val("Y");

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
	 <%-- logCorpAScript --%>
     <%--시나리오(cart:카트,cartend:주소기입,payend:결제완료,REGC:회원가입 또는 약관동의,REGF:입력폼,REGO:회원완료)--%>
     <c:set var="http_SO" value="REGC" scope="request"/>
     <%--// logCorpAScript --%>
    <!--- contents --->
    <div id="member_container">
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

            <input type="hidden" name="rule04Agree" id="paramRule04Agree" value=""/>
            <input type="hidden" name="rule22Agree" id="paramRule22Agree" value=""/>
            <input type="hidden" name="rule21Agree" id="paramRule21Agree" value=""/>
            <input type="hidden" name="rule09Agree" id="paramRule09Agree" value=""/>
            <input type="hidden" name="rule10Agree" id="paramRule10Agree" value=""/>

            <input type="hidden" name="memberTypeCd" id="memberTypeCd" value="${so.memberTypeCd}"/>
            <input type="hidden" name="email" id="email" value="${so.email}"/>
            <input type="hidden" name="emailCertifyValue" id="emailCertifyValue" value="${so.emailCertifyValue}"/>
            <input type="hidden" name="searchBizNo" id="searchBizNo" value="${so.searchBizNo}"/>
        </form:form>

        <h3 class="member_sub_tit">
            <%--<em>이메일 인증이 완료 되었습니다.</em>--%>
            다비치마켓 이용약관 동의 후 다음 절차를 진행해 주세요.
        </h3>
        <div class="check_all">
            <input type="checkbox" class="agree_check" name="all_rule_agree" id="all_rule_agree">
            <label for="all_rule_agree"><span></span>모두 동의합니다.</label>
        </div>
        <%-- 개인 정보 처리방침 (04)--%>
        <div class="agree_area">
            <div class="top">
                <p class="tit_agree">개인 정보 처리방침 <em>(필수)</em></p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">

                ${term_04.data.content}

            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule04_agree">
                <label for="rule04_agree"><span></span>동의합니다.</label>
            </div>
        </div>
        <%-- //개인 정보 처리방침 (04) --%>

        <%-- 위치 정보 이용약관 (22) --%>
        <div class="agree_area">
            <div class="top">
                <p class="tit_agree">위치 정보 이용약관 <em>(필수)</em></p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">

                ${term_22.data.content}

            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule22_agree">
                <label for="rule22_agree"><span></span>동의합니다.</label>
            </div>
        </div>
        <%-- //위치 정보 이용약관 (22) --%>

        <%-- 청소년 보호정책 (21)--%>
        <div class="agree_area">
            <div class="top">
                <p class="tit_agree">청소년 보호정책 <em>(필수)</em></p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">

                ${term_21.data.content}

            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule21_agree">
                <label for="rule21_agree"><span></span>동의합니다.</label>
            </div>
        </div>
        <%-- //청소년 보호정책 (21)--%>

        <%-- 멤버쉽 회원약관 (09)--%>
        <div class="agree_area">
            <div class="top">
                <p class="tit_agree">멤버쉽 회원약관 <em>(필수)</em></p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">

                ${term_09.data.content}

            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule09_agree">
                <label for="rule09_agree"><span></span>동의합니다.</label>
            </div>
        </div>
        <%-- //멤버쉽 회원약관 (09) --%>

        <%-- 온라인몰 이용약관 (10) --%>
        <div class="agree_area">
            <div class="top">
                <p class="tit_agree">온라인몰 이용약관 <em>(필수)</em></p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">

                ${term_10.data.content}

            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule10_agree">
                <label for="rule10_agree"><span></span>동의합니다.</label>
            </div>
        </div>
        <%-- //온라인몰 이용약관 (10) --%>

        <!--- 쇼핑몰 이용약관 --->
        <%--<div class="agree_area">
            <div class="top">
                <p class="tit_agree">서비스 이용약관 <em>(필수)</em></p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">
        
                ${term_03.data.content}
        
            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule01_agree">
                <label for="rule01_agree"><span></span>동의합니다.</label>
            </div>
        </div>--%>
        <!---// 쇼핑몰 이용약관 --->
        <!--- 개인정보 수집 및 이용에 대한 동의 --->
        <%--<div class="agree_area">
            <div class="top">
                <p class="tit_agree">개인정보수집 및 이용 <em>(필수)</em></p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">
                ${term_05.data.content}
            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule02_agree">
                <label for="rule02_agree"><span></span>동의합니다.</label>
            </div>
        </div>--%>
        <!---// 개인정보 수집 및 이용에 대한 동의 --->
        <!--- 개인정보 처리방침 동의 항목  --->
        <%-- <div class="agree_area">
            <div class="top">
                <p class="tit_agree">개인정보 처리방침 동의</p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">
            ${term_04.data.content}
            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule03_agree">
                <label for="rule03_agree"><span></span>동의합니다.</label>
            </div>
        </div> --%>
        <!---// 개인정보 수집 및 이용에 대한 동의 --->
        <!--- 개인정보 제3자 위탁 동의 --->
        <c:if test="${ term_07.data.useYn eq 'Y'}">
        <div class="agree_area">
            <div class="top">
                <p class="tit_agree">개인정보 제3자 제공동의(선택)</p>
                <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
            </div>
            <div class="agree_scroll">
                ${term_07.data.content}
            </div>
            <div class="check_agree">
                <input type="checkbox" class="agree_check" id="rule07_agree">
                <label for="rule07_agree"><span></span>동의합니다.</label>
            </div>
        </div>
        </c:if>
        <!---// 개인정보 제3자 위탁 동의 --->
        <!--- 개인정보처리위탁동의 --->
        <c:if test="${ term_08.data.useYn eq 'Y'}">
            <div class="agree_area">
                <div class="top">
                    <p class="tit_agree">개인정보처리위탁동의(선택)</p>
                    <!-- <a href="#" class="btn_agree_all">전체보기</a> -->
                </div>
                <div class="agree_scroll">
                    ${term_08.data.content}
                </div>
                <div class="check_agree">
                    <input type="checkbox" class="agree_check" id="rule08_agree">
                    <label for="rule08_agree"><span></span>동의합니다.</label>
                </div>
            </div>
        </c:if>

        <div class="btn_member_area">
            <button type="button" class="btn_go_next">다음</button>
        </div>
    </div>
    <!---// contents --->

	</t:putAttribute>
</t:insertDefinition>