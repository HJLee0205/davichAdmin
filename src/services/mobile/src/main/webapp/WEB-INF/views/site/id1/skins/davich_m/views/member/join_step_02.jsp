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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">약관동의</t:putAttribute>
	<t:putAttribute name="script">

    <script>
		$(document).ready(function(){
			$('.btn_view_agree').on('click',function(){
				var idx = $('.btn_view_agree').index(this);
				var target = $('.member_agree_rule').eq(idx);
				
				if($(target).hasClass('active')){
					$(target).css('display','none');
					$(target).removeClass('active');
				}else{
					$(target).css('display','block');
					$(target).addClass('active');	
				}
			});
			
		    $('#all_rule_agree').bind('click',function (){
		       var checkObj = $("input[type='checkbox']");
		       if($('#all_rule_agree').is(':checked')) {
		           checkObj.prop("checked",true);
		       }else{
		           checkObj.prop("checked",false);
		       }
		    });

		    $('.btn_go_next').on('click',function(){

		        if($('#agree_check01').is(':checked') == false) {
		            Dmall.LayerUtil.alert("쇼핑몰 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }
		        if($('#agree_check02').is(':checked') == false) {
		            Dmall.LayerUtil.alert("개인정보 수집 및 이용 약관에 동의해야 합니다.", "알림");
		            return;
                }
		        /* if($('#agree_check03').is(':checked') == false) {
                    Dmall.LayerUtil.alert("개인정보처리방침에 동의해야 합니다.", "알림");
                    return;
                } */

		        //위 validation을 지나왔다면 필수약관은 모두 동의한것이기 때문에 Y값을 적용한다.
		        $('#paramRule01Agree').val("Y");
		        $('#paramRule02Agree').val("Y");
		        //$('#paramRule03Agree').val("Y");

		        var data = $('#form_id_join').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
		        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/member/member-insert-form', param);
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
    <div id="middle_area">
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
            <input type="hidden" name="memberTypeCd" id="memberTypeCd" value="${so.memberTypeCd}"/>
            <input type="hidden" name="email" id="email" value="${so.email}"/>
            <input type="hidden" name="emailCertifyValue" id="emailCertifyValue" value="${so.emailCertifyValue}"/>
            <input type="hidden" name="searchBizNo" id="searchBizNo" value="${so.searchBizNo}"/>
        </form:form>

		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			약관동의
		</div>
		
        <div class="cont_body">
			<h3 class="member_sub_tit marginT15">
				<%--<em>이메일 인증이 완료 되었습니다.</em>--%>
				다비치마켓 이용약관 동의 후<br>다음 절차를 진행해 주세요.
			</h3>
			<div class="check_all">
				<input type="checkbox" class="agree_check" name="all_rule_agree" id="all_rule_agree">
				<label for="all_rule_agree"><span></span>모두 동의합니다.</label>
			</div>

			<div class="member_check_agree tit01">
				<input type="checkbox" class="agree_check" id="agree_check01">
				<label for="agree_check01"><span></span>서비스 이용약관 <em>(필수)</em></label>
				<a href="#" class="btn_view_agree">전체보기</a>
			</div>
			<div class="member_agree_rule" style="display:none;">
	        	${term_03.data.content}
			</div>
			<div class="member_check_agree tit02">
				<input type="checkbox" class="agree_check" id="agree_check02">
				<label for="agree_check02"><span></span>개인정보수집 및 이용 <em>(필수)</em></label>
				<a href="#" class="btn_view_agree">전체보기</a>
			</div>
			<div class="member_agree_rule" style="display:none;">
	        	${term_05.data.content}
			</div>
			<%-- <div class="member_check_agree tit03">
				<input type="checkbox" class="agree_check" id="agree_check03">
				<label for="agree_check03"><span></span>추가 동의 필요사항 있는 경우 <em>(필수)</em></label>
				<a href="#" class="btn_view_agree">전체보기</a>
			</div>
			<div class="member_agree_rule" style="display:none;">
	        	${term_04.data.content}
			</div> --%>
			<c:if test="${ term_07.data.useYn eq 'Y'}">
			<div class="member_check_agree tit04">
				<input type="checkbox" class="agree_check" id="agree_check04">
				<label for="agree_check04"><span></span>개인정보 제3자 제공동의 <em>(선택)</em></label>
				<a href="#" class="btn_view_agree">전체보기</a>
			</div>
			<div class="member_agree_rule" style="display:none;">
	        	${term_07.data.content}
			</div>
			</c:if>
			<c:if test="${ term_08.data.useYn eq 'Y'}">
			<div class="member_check_agree tit04">
				<input type="checkbox" class="agree_check" id="agree_check05">
				<label for="agree_check05"><span></span>개인정보처리위탁동의 <em>(선택)</em></label>
				<a href="#" class="btn_view_agree">전체보기</a>
			</div>
			<div class="member_agree_rule" style="display:none;">
	        	${term_08.data.content}
			</div>
			</c:if>
		
			<div class="btn_member_area">
				<button type="button" class="btn_go_next">다음</button>
			</div><br><br>
		</div>
    </div>
    <!---// contents --->

	</t:putAttribute>
</t:insertDefinition>