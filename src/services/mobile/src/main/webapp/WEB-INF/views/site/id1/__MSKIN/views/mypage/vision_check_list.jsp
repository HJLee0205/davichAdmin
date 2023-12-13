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
	<t:putAttribute name="title">비전체크</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">	
	<script>
    
    $("ul.tabs_vision li").click(function () {
		$("ul.tabs_vision li").removeClass("active");
		$(this).addClass("active");
		$(".tabs_vision_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});
    
    $(".btn_list_view.g").click(function(){                	
    	var cnt = 0;
    	
    	// 비전체크 후 검색
        var v_searchVisionCtg = "";
     	// 비전체크 후 검색 명칭
        var v_searchVisionCtgNm = "";
    	
    	$("input:checkbox[name='lens_check_g']").each(function(e){
    		if($(this).is(":checked") == true) {
    			cnt++;
    			var tmp = $(this).val().split("-");
    			v_searchVisionCtg = v_searchVisionCtg + tmp[0] + ",";
    			v_searchVisionCtgNm = v_searchVisionCtgNm + tmp[1] + ",";
    			
    		}
    	});
    	
    	if(cnt > 0){
    		$('#searchVisionCtg').val(v_searchVisionCtg.substring(0, v_searchVisionCtg.length-1));
    		$('#searchVisionCtgNm').val(v_searchVisionCtgNm.substring(0, v_searchVisionCtgNm.length-1));
    		
    		var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            
            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/search/goods-list-search', param);
    	}else{
    		alert("상품을 선택해 주세요.");
    	}                	
		
    });
    

    $(".btn_go_recomm.g").click(function(){                	
    	var v_type = 'G';
    	var v_active = $("#lensActiveG").val();
    	var v_age = $("#lensAgeG").val();
		var v_lengsName = "";
    	var v_type_nm = "안경렌즈";	       
    	var cnt = 0;
		
    	      	
       	$("input:checkbox[name='lens_check_g']").each(function(e){
       		if($(this).is(":checked") == true) {
       			cnt++;
       			var tmp = $(this).val().split("-");
       			v_lengsName = v_lengsName + tmp[1] + ",";	                			
       		}
       	});
       	
		v_lengsName = v_lengsName.substring(0, v_lengsName.length-1);
		
		
		var url = "${_MOBILE_PATH}/front/visit/visit-exist-book";
        var param = {};
        Dmall.AjaxUtil.getJSON(url, param, function(data) {
        	  // 이미 방문예약이 존재한다면
        	  if (data.length > 0) {
	  				var visionChk = v_type + " | " + v_type_nm + " | " + v_active + " | " + v_age + " | " + v_lengsName;
        	        var url = '${_MOBILE_PATH}/front/visit/visit-book-pop';
        	        var param = {visionChk : visionChk};
        	        Dmall.AjaxUtil.loadByPost(url, param, function(result) {
        	            $('#div_visit_book_popup').html(result).promise().done(function(){
        	            });
        	        })
        	  } else {
        			if(cnt > 0){
        				var visionChk = v_type + " | " + v_type_nm + " | " + v_active + " | " + v_age + " | " + v_lengsName;
        	            var param = {visionChk : visionChk};
        	            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-book', param);
        			}else{
        				alert("상품을 선택해 주세요.");
        			}
        	  }
    	});		
    });
    

    $(".btn_go_recomm.c").click(function(){                	
    	var v_type = 'C';
    	var v_active = $("#lensActiveC").val();
    	var v_age = $("#lensAgeC").val();
		var v_lengsName = "";
    	var v_type_nm = "콘택트렌즈";	       
    	var cnt = 0;
		
    	      	
       	$("input:checkbox[name='lens_check_c']").each(function(e){
       		if($(this).is(":checked") == true) {
       			cnt++;
       			var tmp = $(this).val().split("-");
       			v_lengsName = v_lengsName + tmp[1] + ",";	                			
       		}
       	});
       	
		v_lengsName = v_lengsName.substring(0, v_lengsName.length-1);
		
		
		var url = "${_MOBILE_PATH}/front/visit/visit-exist-book";
        var param = {};
        Dmall.AjaxUtil.getJSON(url, param, function(data) {
        	  // 이미 방문예약이 존재한다면
        	  if (data.length > 0) {
	  				var visionChk = v_type + " | " + v_type_nm + " | " + v_active + " | " + v_age + " | " + v_lengsName;
        	        var url = '${_MOBILE_PATH}/front/visit/visit-book-pop';
        	        var param = {visionChk : visionChk};
        	        Dmall.AjaxUtil.loadByPost(url, param, function(result) {
        	            $('#div_visit_book_popup').html(result).promise().done(function(){
        	            });
        	        })
        	  } else {
        			if(cnt > 0){
        				var visionChk = v_type + " | " + v_type_nm + " | " + v_active + " | " + v_age + " | " + v_lengsName;
        	            var param = {visionChk : visionChk};
        	            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-book', param);
        			}else{
        				alert("상품을 선택해 주세요.");
        			}
        	  }
    	});		
		
		
    });

    $(".btn_view_lens").hover(function() {
		var imgNm= $(this).prev('[name=imgNm]').val();

		if(imgNm!=""){
			var imgPath = '<img src="${_SKIN_IMG_PATH}/vision/'+imgNm+'">';
			$('.layer_lens_datil').html(imgPath);
			$('.layer_lens_datil').show();
        }
    });
    $(".btn_view_lens").mouseleave(function() {
        $('.layer_lens_datil').hide();
    });
    
    function fn_step2_img(step2_cd){
    	var imgPath = '<img src="${_SKIN_IMG_PATH}/vision/vision_step2_'+step2_cd+'.png">';
    	$('.layer_lens_datil').html(imgPath);
		$('.layer_lens_datil').show();
    }
    </script>	
	</t:putAttribute>
	<t:putAttribute name="content">
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			비젼체크
		</div>
		<div class="cont_body">
			<div class="order_cancel_info">					
				<span class="icon_purpose">‘ 비젼체크’ 란 고객의 나이와 생활환경을 고려하여 최적의 렌즈를 찾아드리는 다비치안경의 렌즈추천 시스템입니다.</span>
			</div>
			
			<ul class="tabs_vision lens">
				<li rel="tab01" <c:if test="${lensType eq 'G' }">class="active"</c:if> >추천 안경렌즈</li>
				<li rel="tab02" <c:if test="${lensType eq 'C' }">class="active"</c:if> >추천 콘택트렌즈</li>
			</ul>
			
			<!-- tab01:추천 안경렌즈 -->
			<div class="tabs_vision_content" id="tab01" <c:if test="${lensType eq 'C' }">style="display:none;"</c:if> >
				<c:choose>
					<c:when test="${empty glassVision}">
						<div class="lens_recomm result">
							<p class="recomm_text">렌즈추천정보가 없습니다.</p>
							<p class="recomm_text">지금 추천받기 버튼을 눌러 고객님께 꼭 맞는 렌즈를 추천 받아보세요.</p>
							<button type="button" class="btn_lens_show" onclick="document.location.href='${_MOBILE_PATH}/front/vision2/vision-check';">지금 추천받기<i></i></button>
						</div>
					</c:when>
					<c:otherwise>					
				        <input type="hidden" name="lensActiveG" id="lensActiveG" value="${topGlassVO.relateActivity}"/>
				        <input type="hidden" name="lensAgeG" id="lensAgeG" value="${topGlassVO.age}"/>	
						<div class="lens_recomm result">
							<c:choose> 
								<c:when test="${empty topGlassVO.resultAll}">
									<p class="recomm_text"><em>${topGlassVO.relateActivity}</em> 관련 활동을 많이 하시는</p>
									<p class="recomm_text"><em>${topGlassVO.age}</em>의 <b>${userName}</b> 고객님께 추천해 드리는 안경렌즈입니다.</p>
								</c:when>
								<c:otherwise>${topGlassVO.resultAll}</c:otherwise>									
							</c:choose> 
							<button type="button" class="btn_lens_show" onclick="document.location.href='${_MOBILE_PATH}/front/vision2/vision-check?visionGb=G';">렌즈추천 다시받기<i></i></button>
						</div>
	
						<ul class="lens_result">
							<c:forEach var="result" items="${glassVision}" varStatus="status">
							<li>
								<p class="tit">
									<input type="checkbox" class="lens_check" name="lens_check_g" id="lens_check_g${status.count}" value="${result.checkNo}-${result.checkNm}">
									<label for="lens_check_g${status.count}"><span></span>${result.checkNm}</label>									
									<input type="hidden" name="imgNm" value="${result.imgNm}">
									<button type="button" class="btn_view_lens">자세히보기</button>
								</p>				
								<p class="text">${result.simpleDscrt}</p>
							</li>
							</c:forEach>
						</ul>
						<p class="lens_result_date">저장일 <fmt:formatDate pattern="yyyy-MM-dd" value="${topGlassVO.regDttm}"/></p>
	
						<div class="btn_lens_area">
							<button type="button" class="btn_list_view g">상품 목록보기</button>
							<button type="button" class="btn_go_recomm g">바로 예약하기</button>
						</div>	
					</c:otherwise>
				</c:choose>
			</div>
			<!--// tab01:추천 안경렌즈 -->

			<!-- tab02:추천 콘택트렌즈 -->
			<div class="tabs_vision_content" id="tab02" <c:if test="${lensType eq 'G' }">style="display:none;"</c:if> >
				<c:choose>
					<c:when test="${empty contactVision}">
						<div class="lens_recomm result">
							<p class="recomm_text">렌즈추천정보가 없습니다.</p>
							<p class="recomm_text">지금 추천받기 버튼을 눌러 고객님께 꼭 맞는 렌즈를 추천 받아보세요.</p>
							<button type="button" class="btn_lens_show" onclick="document.location.href='${_MOBILE_PATH}/front/vision2/vision-check';">지금 추천받기<i></i></button>
						</div>
					</c:when>
					<c:otherwise>
				        <input type="hidden" name="lensActiveC" id="lensActiveC" value="${topContactVO.relateActivity}"/>
				        <input type="hidden" name="lensAgeC" id="lensAgeC" value="${topContactVO.age}"/>
						<div class="lens_recomm result">
							<p class="recomm_text"><em>${topContactVO.relateActivity}</em> 관련 활동을 많이 하시는</p>
							<p class="recomm_text"><em>${topContactVO.age}</em>의 <b>${userName}</b> 고객님께 추천해 드리는 안경렌즈입니다.</p>
							<button type="button" class="btn_lens_show" onclick="document.location.href='${_MOBILE_PATH}/front/vision2/vision-check?visionGb=C';">렌즈추천 다시받기<i></i></button>
						</div>
	
						<ul class="lens_result">
							<c:forEach var="result" items="${contactVision}" varStatus="status">
							<li>
								<p class="tit">
									<input type="checkbox" class="lens_check" name="lens_check_c" id="lens_check_c${status.count}" value="${result.checkNo}-${result.checkNm}">
									<label for="lens_check_c${status.count}"><span></span>${result.checkNm}</label>
									<input type="hidden" name="imgNm" value="${result.imgNm}">
									<button type="button" class="btn_view_lens">자세히보기</button>
								</p>				
								<p class="text">${result.simpleDscrt}</p>									
							</li>
							</c:forEach>
						</ul>
						<p class="lens_result_date">저장일 <fmt:formatDate pattern="yyyy-MM-dd" value="${topContactVO.regDttm}"/></p>
	
						<div class="btn_lens_area">
							<button type="button" class="btn_go_recomm c">바로 예약하기</button>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
			<!-- tab02:추천 콘택트렌즈 -->
		</div>
	</div>
	<!-- popup_detail -->
	<div class="popup layer_lens_datil" style="display: none;"></div>
	
	<div id="div_visit_book_popup" style="display:none;">
	</div>		
	
	
	<!--// popup_detail -->
	</t:putAttribute>
</t:insertDefinition>