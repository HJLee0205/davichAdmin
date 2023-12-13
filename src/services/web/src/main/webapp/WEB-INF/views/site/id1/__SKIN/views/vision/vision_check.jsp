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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 비전체크</t:putAttribute>
	<t:putAttribute name="script">	
	<script type="text/javascript">
	
		$(document).ready(function(){
			// default setting
			var age = "${memberAge}";
			var lensType = "${lensType}";
			var idx = 0;
			if(lensType == 'C'){
				if(age < 20) idx = 0;
				else if(age >= 20 && age < 30) idx = 1;
				else if(age >= 30 && age < 40) idx = 2;
				else if(age >= 40) idx = 3;
			}else{
				if(age < 20) idx = 0;
				else if(age >= 20 && age < 38) idx = 1;
				else if(age >= 38) idx = 2;	
			}
			fn_lens_type(lensType, idx);
			
			// 추천결과보기
			$(".btn_view_recomm").click(function(){                	
            	
				//data setting
           		var lensGbCd = $('#lensGbCd').val();
           		var target = 'glass_life';
           		var lifeStyleCd = '';
           		var relateActivity = '';
           		var checkNo = '';
           		if(lensGbCd == 'C'){
           			target = 'contact_life';
           		}
           		
           		$('.'+target).find('li').each(function(){
       				if($(this).hasClass('active')){
       					if(lifeStyleCd != '') lifeStyleCd += ',';
       					lifeStyleCd += $(this).attr('data-lifeStyleCd');
       					
       					if(relateActivity != '') relateActivity += ',';
       					relateActivity += $(this).children('p').text();
       					
      					if(checkNo != '') checkNo += ",";
      					checkNo += $(this).attr('data-checkNo');
       				}
       			});
           		
           		if(lifeStyleCd == ''){
           			Dmall.LayerUtil.alert("라이프스타일을 선택해 주세요.","확인");
           			return false;
           		}
           		$('#lifeStyleCd').val(lifeStyleCd);
           		$('#relateActivity').val(relateActivity);
           		$('#checkNo').val(checkNo);
				
				var data = $('#form_vision_check').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
					param[obj.name] = obj.value;
				});
 
				Dmall.FormUtil.submit('/front/vision/recommend-lens', param);
					
            });
			
		});
	
		// 렌즈타입 선택
		function fn_lens_type(type, idx) {
			// form hidden data
			$('#lensGbCd').val(type);
			
			$('ul.lens_type').find('li').each(function(){
				$(this).removeClass('active');
			});
			
			if(type == 'C'){
				$('ul.lens_type').find('li:eq(1)').addClass('active');
				$('#c_type_area').css('display','block');
				$('#g_type_area').css('display','none');
				fn_select_age('C', idx);
			}else{
				$('ul.lens_type').find('li:eq(0)').addClass('active');
				$('#c_type_area').css('display','none');
				$('#g_type_area').css('display','block');
				fn_select_age('G', idx);
			}
		}
		
		// 연령대 선택
		function fn_select_age(type, idx) {
			
			var ageCd = idx;
			var age_target = 'glass_age';
			if(type == 'C') age_target = 'contact_age';
			
			$('.'+age_target).find('li').each(function(){
				$(this).children('span').removeClass('active');
			});
			$('.'+age_target).find('li:eq('+idx+')').children('span').addClass('active');
			var ageTxt = $('.'+age_target).find('li:eq('+idx+')').children('span').text();
			
			if(type == 'C'){
				var ageCd = '1'+idx+'';
				var url = "/front/vision/select-contact-ajax";
                var param = {ageCd:ageCd};
                Dmall.AjaxUtil.getJSON(url, param, function(data) {
                	$('.contact_life').empty();
                	var html = '';
                	for(var i=0;i<data.length;i++){
                		var lifeStyleCd = data[i].lifeStyleCd;
                		var imgNo = '';
                		
                		if(lifeStyleCd == '10') imgNo = '13';
                		else if(lifeStyleCd == '11') imgNo = '14';
                		else if(lifeStyleCd == '12') imgNo = '15';
                		else if(lifeStyleCd == '13') imgNo = '04';
                		else if(lifeStyleCd == '14') imgNo = '03';
                		else if(lifeStyleCd == '15') imgNo = '16';
                		else if(lifeStyleCd == '16') imgNo = '17';
                		else if(lifeStyleCd == '17') imgNo = '06';
                		else imgNo = '13';
                		
                    	html += '<li onClick="javascript:fn_select_lifeStyle(this);" data-lifeStyleCd="'+lifeStyleCd+'" data-checkNo="'+data[i].checkNos+'">';
                    	html += '<i class="icon_lens'+imgNo+'"></i>';
                    	html += '<p class="tit">'+data[i].lifeStyleNm+'</p>';
                    	html += '</li>';
                    }
                    $('.contact_life').html(html);
                    $('.contact_life').show();
                    var myAge = '10대';
                    if(idx == 0) myAge = '10대';
                    else if(idx == 1) myAge = '20대';
                    else if(idx == 2) myAge = '30대';
                    else if(idx == 3) myAge = '40대';
                    $('.my_age').text(myAge);
				});
			}else{
				idx++;
				var ageCd = '0'+idx+'';
				var url = "/front/vision/select-poMatr-ajax";
                var param = {ageCd:ageCd};
                Dmall.AjaxUtil.getJSON(url, param, function(data) {
                	$('.lens_check_area').empty();
                	var html = '';
                    for(var i=0;i<data.length;i++){
                    	html += '<input type="checkbox" class="order_check" id="poMatr'+i+'" value="'+data[i].poMatrCd+'" onClick="javascript:fn_select_poMatr();">';
                    	html += '<label for="poMatr'+i+'"><span></span>'+data[i].poMatrNm+'</label>';
                    }
                    $('.lens_check_area').html(html);
                    $('.lens_check_area').show();
                    $('.glass_life').hide();
                    $('.my_age_area').hide();
                    var myAge = '20세 미만';
                    if(idx == 1) myAge = '20세 미만';
                    else if(idx == 2) myAge = '20 ~ 38세';
                    else if(idx == 3) myAge = '38세 이상';
                    $('.my_age').text(myAge);
				});
			}
			
			// form hidden data
			ageCd++;
			$('#ageCd').val(ageCd);
			$('#ageTxt').val(ageTxt);
		}
		
		// 불편사항 선택
		function fn_select_poMatr(){
			
			var poMatrCd = "";
			$('input[id^=poMatr]').each(function(){
				if($(this).is(":checked")){
					if(poMatrCd != '') poMatrCd += ",";
					poMatrCd += "'"+$(this).val()+"'";
				}
			});
			if(poMatrCd == ''){
				Dmall.LayerUtil.alert("불편사항을 선택해 주세요.","확인");
				$('.glass_life').hide();
				return false;
			}
			
			var url = "/front/vision/select-lifeStyle-ajax";
            var param = {poMatrCd:poMatrCd};
            Dmall.AjaxUtil.getJSON(url, param, function(data) {
            	$('.glass_life').empty();
            	var html = '';
                for(var i=0;i<data.length;i++){
                	var lifeStyleCd = data[i].lifeStyleCd;
            		var imgNo = lifeStyleCd;
            		
                	html += '<li onClick="javascript:fn_select_lifeStyle(this);" data-lifeStyleCd="'+lifeStyleCd+'" data-checkNo="'+data[i].checkNos+'">';
                	html += '<i class="icon_lens'+imgNo+'"></i>';
                	html += '<p class="tit">'+data[i].lifeStyleNm+'</p>';
                	html += '</li>';
                }
			
                $('.glass_life').html(html);
                $('.glass_life').show();
                $('.my_age_area').show();
			});
		}
		
		// 라이프스타일 선택
		function fn_select_lifeStyle(obj){
			if($(obj).hasClass('active')){
				$(obj).removeClass('active');		
			}else{
				$(obj).addClass('active');
			}
		}
	 
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
		<!--- 02.LAYOUT: 카테고리 메인 --->
	    <div class="category_middle">
			<form:form id="form_vision_check" name="form_vision_check" method="post">
				<input type="hidden" name="lensGbCd" id="lensGbCd">
				<input type="hidden" name="age" id="ageTxt">
				<input type="hidden" name="ageCd" id="ageCd">
				<input type="hidden" name="lifeStyleCd" id="lifeStyleCd">
				<input type="hidden" name="relateActivity" id="relateActivity">
				<input type="hidden" name="checkNo" id="checkNo">
	        </form:form>
			<div class="lens_head">
				<h2 class="lens_tit">렌즈추천</h2>
			</div>
			<div class="lens_info_area">
				<p class="tit">나에게 맞는 렌즈는 어떤 것일까?</p>
				고객님의 나이와 생활환경을 고려하여 편안하게 착용하실 수 있는 최적의 렌즈를 추천해 드립니다.<br>
				연령대별로 주로 활동하시는 환경에 모두 체크하신 후 '추천결과보기'버튼을 눌러주세요.
			</div>
			<ul class="lens_type">
				<li onclick="fn_lens_type('G', 0)">안경렌즈</li>
				<li onclick="fn_lens_type('C', 0)">콘택트 렌즈</li>
			</ul>
			<div class="lens_type_area">
				<!-- 안경렌즈 영역 -->
				<div id="g_type_area" style="display:<c:if test="${lensType eq 'C' }">none</c:if>;">
					<!-- 안경렌즈 연령대 -->
					<ul class="lens_age glass_age">
						<li onclick="fn_select_age('G', 0);"><span>20세 미만</span></li>
						<li onclick="fn_select_age('G', 1);"><span>20~38세</span></li>
						<li onclick="fn_select_age('G', 2);"><span>38세 이상</span></li>
					</ul>
					<!--// 안경렌즈 연령대 -->				

					<!-- 안경렌즈 불편사항 -->
					<p class="lens_choice_text">생활에서 어떤 점이 불편하신가요?</p>
					<div class="lens_check_area" style="display:none;"></div>
					<!--// 안경렌즈 불편사항 -->
					
					<!-- 안경렌즈 라이프스타일 -->
					<p class="lens_choice_text my_age_area" style="display:none;">
						<em class="my_age">
							<c:choose>
								<c:when test="${memberAge < 20}">10대</c:when>
								<c:when test="${memberAge >= 20 and memberAge < 30}">20대</c:when>
								<c:when test="${memberAge >= 30 and memberAge < 40}">30대</c:when>
								<c:when test="${memberAge >= 40}">40대</c:when>
							</c:choose>
						</em> 
						선택 고객님, 어떤 환경에서 주로 활동하시나요?
					</p>
					<ul class="lens_choice contact glass_life" style="display:none;">
						<!-- <li class="lens_a" onclick="fn_glass_active('A')">					
							<i class="icon_lens01"></i>
							<p class="tit">실내</p>
						</li>
						<li class="lens_b" onclick="fn_glass_active('B')">					
							<i class="icon_lens02"></i>
							<p class="tit">야외</p>
						</li>
						<li class="lens_c" onclick="fn_glass_active('C')">					
							<i class="icon_lens03"></i>
							<p class="tit">컴퓨터, 휴대폰</p>
						</li>
						<li class="lens_d" onclick="fn_glass_active('D')">					
							<i class="icon_lens04"></i>
							<p class="tit">독서, 공부</p>
						</li>
						<li class="lens_e" onclick="fn_glass_active('E')">					
							<i class="icon_lens05"></i>
							<p class="tit">수영</p>
						</li>
						<li class="lens_f" onclick="fn_glass_active('F')">					
							<i class="icon_lens06"></i>
							<p class="tit">운동</p>
						</li>
						<li class="lens_g" onclick="fn_glass_active('G')">					
							<i class="icon_lens07"></i>
							<p class="tit">안질환</p>
						</li>
						<li class="lens_h" onclick="fn_glass_active('H')">					
							<i class="icon_lens08"></i>
							<p class="tit">운전</p>
						</li>
						<li class="lens_i" onclick="fn_glass_active('I')">					
							<i class="icon_lens09"></i>
							<p class="tit">레져</p>
						</li>
						<li class="lens_j" onclick="fn_glass_active('J')">					
							<i class="icon_lens10"></i>
							<p class="tit">독서, 사무업무</p>
						</li>
						<li class="lens_k" onclick="fn_glass_active('K')">					
							<i class="icon_lens11"></i>
							<p class="tit">등산, 골프</p>
						</li>
						<li class="lens_l" onclick="fn_glass_active('L')">					
							<i class="icon_lens12"></i>
							<p class="tit">낚시</p>
						</li> -->
					</ul>
					<!--// 안경렌즈 라이프스타일 -->
				</div>
				<!--// 안경렌즈 영역 -->
				
				<!-- 콘텐츠렌즈 영역 -->
				<div id="c_type_area" style="display:<c:if test="${lensType ne 'C' }">none</c:if>;">
					<ul class="lens_age contact_age contact">
						<li onclick="fn_select_age('C', 0);"><span>10대</span></li>
						<li onclick="fn_select_age('C', 1);"><span>20대</span></li>
						<li onclick="fn_select_age('C', 2);"><span>30대</span></li>
						<li onclick="fn_select_age('C', 3);"><span>40대</span></li>
					</ul>
					
					<p class="lens_choice_text my_age_area">
						<em class="my_age">
							<c:choose>
								<c:when test="${memberAge < 20}">10대</c:when>
								<c:when test="${memberAge >= 20 and memberAge < 30}">20대</c:when>
								<c:when test="${memberAge >= 30 and memberAge < 40}">30대</c:when>
								<c:when test="${memberAge >= 40}">40대</c:when>
							</c:choose>
						</em> 
						선택 고객님, 어떤 환경에서 주로 활동하시나요?
					</p>
					
					<ul class="lens_choice contact contact_life" style="display:none;">
						<!-- <li onclick="fn_contact_active('A')">					
							<i class="icon_lens13"></i>
							<p class="tit">근시</p>
						</li>
						<li onclick="fn_contact_active('B')">					
							<i class="icon_lens14"></i>
							<p class="tit">난시</p>
						</li>
						<li class="no_right" onclick="fn_contact_active('C')">					
							<i class="icon_lens15"></i>
							<p class="tit">근거리 불편</p>
						</li>
						<li class="row_contact" onclick="fn_contact_active('D')">					
							<i class="icon_lens16"></i>
							<p class="tit">건조안</p>
						</li>
						<li onclick="fn_contact_active('E')">					
							<i class="icon_lens17"></i>
							<p class="tit">컬러렌즈</p>
						</li> -->
					</ul>
				</div>
				<!--// 콘텐츠렌즈 영역 -->
				
				<div class="btn_lens_area">
					<button type="button" class="btn_view_recomm">추천결과보기</button>
				</div>
			</div>
			
		</div>
    	<!---// 02.LAYOUT: 카테고리 메인 --->
	</t:putAttribute>
</t:insertDefinition>