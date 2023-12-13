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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">비전체크</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">		
		<script>
                $(".btn_list_view").click(function(){                	
                	var cnt = 0;
                	
                	// 비전체크 후 검색
                    var v_searchVisionCtg = "";
                 	// 비전체크 후 검색 명칭
                    var v_searchVisionCtgNm = "";
                	
                	$("input:checkbox[name='lens_check']").each(function(e){
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
                

                $(".btn_go_recomm").click(function(){
                	
                	var loginYn = ${user.login};
                    if(!loginYn) {
                        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                                var returnUrl = window.location.pathname+window.location.search;
                                location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                            }
                        );
                        return;
                    }
                    
                	var v_type = $("#lensGbCd").val();
                	var v_active = $("#relateActivity").val();
                	var v_age = $("#age").val();
					var v_lengsName = "";
                	var v_type_nm = "";	       
                	var cnt = 0;
                	
					if(v_type == 'G'){         	
	                	$("input:checkbox[name='lens_check']").each(function(e){
	                		if($(this).is(":checked") == true) {
	                			cnt++;
	                			var tmp = $(this).val().split("-");
	                			v_lengsName = v_lengsName + tmp[1] + ",";	                			
	                		}
	                	});
	                	
	                	v_type_nm = "안경렌즈";
					}else if(v_type == 'C'){
						$("input:checkbox[name='lens_check']").each(function(e){
	                		if($(this).is(":checked") == true) {
	                			cnt++;
	                			var tmp = $(this).val().split("-");
	                			v_lengsName = v_lengsName + tmp[1] + ",";
	                		}
	                	});
	                	
	                	v_type_nm = "콘택트렌즈";
					}
					
					v_lengsName = v_lengsName.substring(0, v_lengsName.length-1);
					
					// 현재 방문예약중인 내역을 조회
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
                
                $(".btn_result_save").click(function(){
                	
                	var loginYn = ${user.login};
                    if(!loginYn) {
                        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                                var returnUrl = window.location.pathname+window.location.search;
                                location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                            }
                        );
                        return;
                    }
                    
                	if(confirm("결과를 저장하시겠습니까?")){
                		
                		var cnt = 0;
                    	var v_lensGbCd = $("#lensGbCd").val();
                    	var v_relateActivity = $("#relateActivity").val();
                    	var v_age = $("#age").val();
                    	var v_checkNos = "";
                    	
                		$("input:checkbox[name='lens_check']").each(function(e){	  
                			var tmp = $(this).val().split("-");
                			v_checkNos = v_checkNos + tmp[0] + ",";
	                	});                		
                		
                		v_checkNos = v_checkNos.substring(0, v_checkNos.length-1);
                		
                		$.ajax({
                	 		type : "POST",
                	 		url : "${_MOBILE_PATH}/front/vision/vision-check-insert",
                	 		data : {
                	 			lensGbCd		: v_lensGbCd,
                	 			relateActivity	: v_relateActivity,
                	 			age 			: v_age,
                	 			checkNos		: v_checkNos	                	 			
                	 		},
                	 		dataType : "xml",
                	 		success : function(result) {	
                	 			
                	 		},
                	 		error : function(result, status, err) {
                	 			//alert(result.status + " / " + status + " / " + err);
                	 		},
                	 		beforeSend: function() {
                	 		    
                	 		},
                	 		complete: function(){				
                	 			document.location.href='${_MOBILE_PATH}/front/vision/my-vision-check?lensType='+v_lensGbCd;
                	 		}
                	 	});	
                		
                	}
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
                
		</script>		
	</t:putAttribute>
	<t:putAttribute name="content">
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<form:form id="form_id_search" method="post">
        	<input type="hidden" name="searchVisionCtg" id="searchVisionCtg" value=""/>
        	<input type="hidden" name="searchVisionCtgNm" id="searchVisionCtgNm" value=""/>
    	    
	        <input type="hidden" name="lensGbCd" id="lensGbCd" value="${visionVO.lensGbCd}"/>
	        <input type="hidden" name="age" id="age" value="${visionVO.age}"/>
	        <input type="hidden" name="ageCd" id="ageCd" value="${visionVO.ageCd}"/>
	        <input type="hidden" name="lifeStyleCd" id="lifeStyleCd" value="${visionVO.lifeStyleCd}">
			<input type="hidden" name="relateActivity" id="relateActivity" value="${visionVO.relateActivity}"/>
			<input type="hidden" name="checkNo" id="checkNo">
		</form:form>
        
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			렌즈추천
		</div>
		<div class="cont_body">
			<div class="lens_info_area">
				<p class="tit">
					<c:choose>
						<c:when test="${visionVO.lensGbCd == 'C'}">콘택트렌즈 추천결과</c:when>
						<c:otherwise>안경렌즈</c:otherwise>
					</c:choose>
				</p>			
			</div>
			<div class="lens_recomm result">
				<p class="recomm_text"><em>${visionVO.relateActivity}</em> 관련 활동을 많이 하시는</p>
				<p class="recomm_text"><em>${visionVO.age}</em>의 <b>${userName}</b> 고객님께 추천해 드리는 
					<c:choose>
						<c:when test="${visionVO.lensGbCd == 'C'}">콘택트렌즈입니다.</c:when>
						<c:otherwise>안경렌즈입니다.</c:otherwise>
					</c:choose>
				</p>
				<button type="button" class="btn_lens_show" onclick="document.location.href='${_MOBILE_PATH}/front/vision/vision-check2?lensType=${visionVO.lensType}'">렌즈추천 다시받기<i></i></button>
			</div>
			
			<ul class="lens_result">
				<c:forEach var="li" items="${visionDscrt}" varStatus="status">
					<li>
						<p class="tit">
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check${status.index}" value="${li.checkNo}-${li.checkNm}">
							<label for="lens_check${status.index}"><span></span>${li.checkNm}</label>
							<button type="button" class="btn_view_lens"></button>
						</p>				
						<p class="text">${li.simpleDscrt}</p>
						<input type="hidden" name="imgNm" value="${li.imgNm}">
					</li>
				</c:forEach>
			</ul>
			
			<div class="lens_visit_info">
				<c:choose>
					<c:when test="${visionVO.lensGbCd == 'C'}">
						관심있는 렌즈 종류를 선택하여 예약하신 다음 다비치안경매장을 방문하시면
						전문 안경사의 상담  후 할인된 가격으로 나에게 꼭 맞는 콘택트렌즈를 구매하실 수 있습니다.
					</c:when>
					<c:otherwise>
						관심있는 렌즈 종류를 선택하여 예약하신 다음 다비치안경매장을 방문하시면
						전문 안경사의 상담  후 할인된 가격으로 나에게 꼭 맞는 안경렌즈를 구매하실 수 있습니다.<br>
						상품 목록보기를 통해 직접 맘에 드는 렌즈를 고른 다음 예약하셔도 됩니다.
					</c:otherwise>
				</c:choose>
			</div>
			<div class="btn_lens_area">
				<button type="button" class="btn_list_view">상품 목록보기</button>
				<button type="button" class="btn_go_recomm">바로 예약하기</button>
				<button type="button" class="btn_result_save"><i></i>결과 저장</button>
			</div>		
		</div>
	</div>
	<!-- popup_detail -->
	<div class="popup layer_lens_datil" style="display: none;"></div>
	<!--// popup_detail -->
	
	<div id="div_visit_book_popup" style="display:none;">
	</div>		
	
	</t:putAttribute>
</t:insertDefinition>