<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 방문예약</t:putAttribute>


 <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    //숫자만 입력가능

    $(document).ready(function(){
		$(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

    	$('#visit_book').on('click',function(){
    			var data = $('#visitForm').serializeArray();
				var param = {};
				$(data).each(function(index,obj){
					param[obj.name] = obj.value;
				});

            if(loginYn == 'true') {
                var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';

   	         	if (integrationMemberGbCd == '02' ) {
   	         		Dmall.LayerUtil.confirm("간편회원은 사용하실 수 없습니다.<br>정회원 전환 후 이용해 주세요."
  	             		, function() {
  	             			var returnUrl = window.location.pathname+window.location.search;
  	             			location.href= "/front/member/information-update-form";
                    	},'','', '', '닫기', '정회원 전환');

   	             	return false;
   	         	}


				Dmall.FormUtil.submit('/front/visit/visit-book',param);

            }else{
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
						Dmall.FormUtil.submit('/front/login/member-login',param);
                    },'');
            }
        });

        $('#visit_book_non').on('click',function(){
   			$(".visit_non_member").show();
        });

        $('#visit_check').on('click',function(){
   			if($(this).prop("checked")){
   			$(".btn_non_visit").show();
   			}else{
   			$(".btn_non_visit").hide();
   			}
        });

        $('.btn_non_visit').on('click',function(){
			if($("#nomemberNm").val()==''){
				Dmall.LayerUtil.alert("이름을 입력하세요.", "확인").done(function (){
                $("#nomemberNm").focus();
                });
				return false;
			}

			if($("#mobile02").val()==''){
				Dmall.LayerUtil.alert("휴대폰 번호를 입력하세요.", "확인").done(function (){
                $("#mobile02").focus();
                });
				return false;
			}

			if($("#mobile03").val()==''){
				Dmall.LayerUtil.alert("휴대폰 번호를 입력하세요.", "확인").done(function (){
                $("#mobile03").focus();
                });
				return false;
			}
			$("#memberYn").val("N");
			$('#nomobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
			var data = $('#visitForm').serializeArray();
			var param = {};
			$(data).each(function(index,obj){
				param[obj.name] = obj.value;
			});
			Dmall.FormUtil.submit('/front/visit/visit-book',param);
        });

        $("#csnDtl").on('click',function(){
    		$('.popup_eye_test').show();
		});

    });

    </script>
    </t:putAttribute>


    <t:putAttribute name="content">
    <form name="visitForm" id="visitForm">
    	<input type="hidden" name="refererType" value="${refererType}"/>
    	<input type="hidden" name="returnUrl" value="/front/visit/visit-book"/>
    	<input type="hidden" id="nomobile" name="nomobile" value=""/>
    	<input type="hidden" id="memberYn" name="memberYn" value="Y"/>
    	<input type="hidden" id="ch" name="ch" value="${param.ch}"/>

    <div class="mypage_middle">
            <div id="mypage_content" class="visit_full">
				<div class="mypage_body intro">
					<h3 class="my_tit">매장방문예약</h3>
					<div class="visit_main_box">
						<p class="text">
							<button type="button" class="btn_view_eyetest" id="csnDtl">상세보기</button>
							<img src="${_SKIN_IMG_PATH}/mypage/visit_img02.jpg" alt="다비치안경만의 차별화된 매장 서비스를 경험해 보세요. 1.눈검사-제품 컨설팅 서비스, 2.시착 서비스, 3.피팅 서비스, 4.매장픽업 서비스">
						</p>
					</div>
					<div class="cart_bottom_btn_area">
					    <c:if test="${user.login}">
					    <button type="button" class="btn_all_checkout" id="visit_book">예약신청</button>
                        </c:if>
						<c:if test="${!user.login}">
						<button type="button" class="btn_all_checkout" id="visit_book">회원 예약신청</button>
						<button type="button" class="btn_all_checkout" id="visit_book_non">비회원 예약신청</button>
						</c:if>
					</div>
					<!-- 비회원 방문예약신청시 -->
					<div class="visit_non_member" style="display:none;">
						<ul class="info_form_area">
							<li>
								<span>이름</span>
								<input type="text" id="nomemberNm" name="nomemberNm" maxlength="10">
							</li>
							<li class="tell">
								<span>연락처</span>
								<select id="mobile01" class="phone check_ok">
									<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
								</select>
								<span class="bar">-</span>
								<input type="text" id="mobile02" name="mobile02" maxlength="4" numberOnly="true">
								<span class="bar">-</span>
								<input type="text" id="mobile03" name="mobile03" maxlength="4" numberOnly="true">
							</li>
						</ul>
						<div class="privacy_agree_tit">
							개인정보의 수집 및 이용동의
						</div>
						<div class="privacy_agree">
							1. 수집&middot;이용 목적 : 비회원 고객 매장방문예약 확인 취소에 대한 이용 기록 보관<br>
							2. 수집하는 항목 : 이름, 휴대전화번호<br>
							3. 개인정보의 보유 및 이용기간 : 1년
						</div>
						<input type="checkbox" class="agree_check" id="visit_check">
						<label for="visit_check"><span></span>개인정보 수집&middot;이용에 동의 합니다.</label>
                        <button type="button" class="btn_non_visit" style="display:none;">비회원 방문예약</button>
					</div>
					<!--// 비회원 방문예약신청시 -->
				</div>
            </div>
	</div>
	</form>
	<!-- 20200417 popup_시력검사 -->
	<div class="popup popup_eye_test" style="display:none;">
		<div id="popup_content">
			<div class="scroll">
				<img src="${_SKIN_IMG_PATH}/mypage/visit_eye_test.jpg" alt="눈검사 제품 컨설팅 서비스 안내">
			</div>
		</div>
		<button type="button" class="btn_close_popup"></button>
	</div>
	<!--// 20200417 popup_시력검사 -->
    </t:putAttribute>
</t:insertDefinition>