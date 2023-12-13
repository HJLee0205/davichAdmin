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
	<t:putAttribute name="title">다비치마켓 :: 비전체크</t:putAttribute>
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
                        
                        Dmall.FormUtil.submit('/front/search/goods-list-search', param);
                	}else{
                		//alert("상품을 선택해 주세요.");
                		Dmall.LayerUtil.alert("상품을 선택해 주세요.","확인");
            			return false;
                	}                	
					
                });
                

                $(".btn_go_recomm").click(function(){
                	
                	var loginYn = ${user.login};
                    if(!loginYn) {
                        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                                var returnUrl = window.location.pathname+window.location.search;
                                location.href= "/front/login/member-login?returnUrl="+returnUrl;
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
					var url = "/front/visit/visit-exist-book";
	                var param = {};
	                Dmall.AjaxUtil.getJSON(url, param, function(data) {
	                	  // 이미 방문예약이 존재한다면
	                	  if (data.length > 0) {
		      	  				var visionChk = v_type + " | " + v_type_nm + " | " + v_active + " | " + v_age + " | " + v_lengsName;
		            	        var url = '/front/visit/visit-book-pop';
		            	        var param = {visionChk : visionChk};
		            	        Dmall.AjaxUtil.loadByPost(url, param, function(result) {
	                	            $('#div_visit_book_popup').html(result).promise().done(function(){
	                	            });
	                	        })
	                	  } else {
		      					if(cnt > 0){						
		    						var visionChk = v_type + " | " + v_type_nm + " | " + v_active + " | " + v_age + " | " + v_lengsName;
		    			            var param = {visionChk : visionChk};
		    			            Dmall.FormUtil.submit('/front/visit/visit-book', param);
		    						
		    					}else{
		    						//alert("상품을 선택해 주세요.");
		    						Dmall.LayerUtil.alert("상품을 선택해 주세요.","확인");
		                			return false;
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
                                //var returnUrl = window.location.pathname+window.location.search;
                                var returnUrl = "/front/vision/vision-check2";                                
                                location.href= "/front/login/member-login?returnUrl="+returnUrl;
                            }
                        );
                        return;
                    }
                    
                    Dmall.LayerUtil.confirm("결과를 저장하시겠습니까?", function(){                		
                		var cnt = 0;
                    	var v_lensGbCd = $("#lensGbCd").val();
                    	var v_relateActivity = $("#step3Nm").val();
                    	
                    	if($("#step2Nm").val() != "skip"){
                    		v_relateActivity = $("#step2Nm").val() + ", " + v_relateActivity
                    	}
                    	
                    	if(v_lensGbCd == 'C'){
                    		v_relateActivity += ", " + $("#step10Nm").val() + ", " + $("#step4Nm").val();
                    	}
                    	
                    	v_relateActivity += ", " + $("#relateActivity").val();
                    	
                    	var v_age = $("#age").val();
                    	var v_checkNos = "";
                    	
                		$("input:checkbox[name='lens_check']").each(function(e){	  
                			var tmp = $(this).val().split("-");
                			v_checkNos = v_checkNos + tmp[0] + ",";
	                	});                		
                		
                		v_checkNos = v_checkNos.substring(0, v_checkNos.length-1);
                		
                		var v_resultAll = $(".vision_result").html();
                		
                		$.ajax({
                	 		type : "POST",
                	 		url : "/front/vision/vision-check-insert",
                	 		data : {
                	 			lensGbCd		: v_lensGbCd,
                	 			relateActivity	: v_relateActivity,
                	 			age 			: v_age,
                	 			checkNos		: v_checkNos,
                	 			resultAll		: v_resultAll
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
                	 			document.location.href='/front/vision/my-vision-check?lensType='+v_lensGbCd;
                	 		}
                	 	});	
                		
                	});
                    
                    return;
                });

                // 렌즈 이미지 자세히보기 - 마우스오버
                /* $(".btn_view_lens").hover(function() {
					var imgNm= $(this).prev('[name=imgNm]').val();

					if(imgNm!=""){
						var imgPath = '<img src="${_SKIN_IMG_PATH}/vision/'+imgNm+'">';
						$('.layer_lens_datil').html(imgPath);
						$('.layer_lens_datil').show();
                    }
                });
                $(".btn_view_lens").mouseleave(function() {
                    $('.layer_lens_datil').hide();
                }); */
                
             	// 렌즈 이미지 자세히보기 - 마우스클릭
             	$('.btn_view_lens').click(function(){
             		var imgNm= $(this).prev('[name=imgNm]').val();
             		
             		if(imgNm!=""){
             			var imgPath = '<img src="${_SKIN_IMG_PATH}/vision/'+imgNm+'">';
             			$('#popup_content').html(imgPath);	
						$('.layer_lens_datil').show();											
						$('body').css('overflow-y', 'hidden');
             		}
             	});
                
                function fn_step2_img(step2_cd){
                	var imgPath = '<img src="${_SKIN_IMG_PATH}/vision/vision_step2_'+step2_cd+'.png">';
         			$('#popup_content').html(imgPath);
					$('.layer_lens_datil').show();											
						$('body').css('overflow-y', 'hidden');
                }
		</script>		
	</t:putAttribute>
	<t:putAttribute name="content">
		<!--- 02.LAYOUT: 카테고리 메인 --->
	    <div class="category_middle">
	    	<form:form id="form_id_search" method="post">
	        	<input type="hidden" name="searchVisionCtg" id="searchVisionCtg" value=""/>
	        	<input type="hidden" name="searchVisionCtgNm" id="searchVisionCtgNm" value=""/>	    	    
		        <input type="hidden" name="lensGbCd" id="lensGbCd" value="${visionStepVO.visionGb}"/>
		        <input type="hidden" name="age" id="age" value="${visionStepVO.ageNm}"/>
		        <input type="hidden" name="ageCd" id="ageCd" value="${visionStepVO.ageCd}"/>
		        <input type="hidden" name="lifeStyleCd" id="lifeStyleCd" value="${visionStepVO.step4Cd}">
				<input type="hidden" name="relateActivity" id="relateActivity" value="${fn:replace(visionStepVO.relateActivity,'check','')}"/>
				<input type="hidden" name="checkNo" id="checkNo">
				<input type="hidden" name="step2Nm" id="step2Nm" value="${step2Nm}">				
				<input type="hidden" name="step3Nm" id="step3Nm" value="${step3Nm}">			
				<input type="hidden" name="step4Nm" id="step4Nm" value="${step4Nm}">			
				<input type="hidden" name="step4Nm" id="step10Nm" value="${step10Nm}">		
				<input type="hidden" name="resultAll" id="resultAll">
			</form:form>
			<div class="lens_head">
				<h2 class="lens_tit">렌즈추천</h2>
			</div>
			<div class="lens_info_area">
				<p class="tit">
					<c:choose>
						<c:when test="${visionStepVO.visionGb == 'C'}">콘택트렌즈 추천결과</c:when>
						<c:otherwise>안경렌즈 추천결과</c:otherwise>
					</c:choose>
				</p>			
			</div>			

			<div class="lens_recomm result">
				<c:choose>
					<c:when test="${visionStepVO.visionGb == 'C'}">
						<p class="recomm_text"><em>[${step2Nm}]</em>콘텍트렌즈를 <em>[${step3Nm}, ${step10Nm}]</em> 사용하시는</p>
						<p class="recomm_text"><em>[${step4Nm}] [${fn:replace(visionStepVO.relateActivity,'check','')}]</em> 의 불편함을 겪으신  </p>
					</c:when>
					<c:otherwise>
						<p class="recomm_text"><em>[${fn:replace(visionStepVO.relateActivity,'check','')}]</em> 관련 활동을 많이 하시고</p>
						<p class="recomm_text"><em>[${step3Nm}]</em> 관련 활동을 많이 하시고</p>
					</c:otherwise>
				</c:choose>
				<p class="recomm_text"><em>[${visionStepVO.ageNm}]</em>의 <b>${userName}</b> 고객님께 추천해 드리는 
					<c:choose>
						<c:when test="${visionStepVO.visionGb == 'C'}">콘택트렌즈입니다.</c:when>
						<c:otherwise>안경렌즈입니다.</c:otherwise>
					</c:choose>
				</p>
				<c:if test="${visionStepVO.visionGb == 'G' && step2Nm != 'skip'}">
					<p>&nbsp;</p>
					<p class="recomm_text">
					안경착용 시 불편하셨던 <em>
					<c:forEach  var="result" items="${step2NmList}" varStatus="status">
						<c:choose>
							<c:when test="${result.cd == '03' || result.cd == '07'}">
								[${result.cdNm}]
							</c:when>
							<c:otherwise>
								[<span onmouseover="fn_step2_img('${result.cd}')" style="cursor:pointer">${result.cdNm}</span>]
							</c:otherwise>
						</c:choose>							
					</c:forEach>					
					</em>를 해결하기 위해 TR, 울템, 티타늄, 베타티타늄의 안경소재를 추천드립니다.
					</p>					
				</c:if>
				<c:if test="${visionStepVO.visionGb == 'C'}">
					<p>&nbsp;</p>
					<p class="recomm_text">
					<c:choose>
						<c:when test="${fn:indexOf(visionStepVO.step5Cd,'13') > -1}">건조안 개선에 도움이 되는  <em>[실리콘 투명 난시 교정 렌즈]</em>를 추천해드리겠습니다.</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${fn:indexOf(visionStepVO.step2Cd,'10') > -1}">
									<c:choose>
										<c:when test="${fn:indexOf(visionStepVO.step4Cd,'10') >-1}">건조안 개선에 도움이 되는 <em>[실리콘 투명 렌즈]</em>를 추천해드리겠습니다.</c:when>
										<c:otherwise>고객님의 불편함을 해결 할 수 있는 <em>[투명 렌즈]</em>를 추천해 드리겠습니다.</c:otherwise>
									</c:choose>
								</c:when>
								<c:when test="${fn:indexOf(visionStepVO.step2Cd,'11') > -1}">
									<c:choose>
										<c:when test="${fn:indexOf(visionStepVO.step4Cd,'10') > -1}">건조안 개선에 도움이 되는 <em>[실리콘 컬러 렌즈]</em>를 추천해드리겠습니다.</c:when>
										<c:otherwise>고객님의 불편함을 해결 할 수 있는 <em>[컬러 렌즈]</em>를 추천해 드리겠습니다.</c:otherwise>
									</c:choose>
								</c:when>
							</c:choose>							
						</c:otherwise>						
					</c:choose>
					</p>
				</c:if>
				<button type="button" class="btn_recom_again" onclick="document.location.href='/front/vision/vision-check2?visionGb=${visionStepVO.visionGb}'">안경렌즈 추천 다시받기</button>
			</div>
			
			<ul class="lens_result">
				<c:forEach var="li" items="${visionDscrt}" varStatus="status">
					<li>
						<p class="tit">	
							<input type="checkbox" class="lens_check" name="lens_check" id="lens_check${status.index}" value="${li.checkNo}-${li.checkNm}">
							<label for="lens_check${status.index}">${li.checkNm}<span></span></label>	
						</p>	
						<p class="text">${li.simpleDscrt}</p>		
						<input type="hidden" name="imgNm" value="${li.imgNm}">
						<button type="button" class="btn_view_lens">자세히보기</button>
					</li>
				</c:forEach>
			</ul>	
			
			<div class="lens_visit_info">
				<c:choose>
					<c:when test="${visionStepVO.visionGb == 'C'}">
						관심있는 렌즈 종류를 선택하여 예약하신 다음 다비치안경매장을 방문하시면<br>
						전문 안경사의 상담  후 할인된 가격으로 나에게 꼭 맞는 콘택트렌즈를 구매하실 수 있습니다.
					</c:when>
					<c:otherwise>
						관심있는 렌즈 종류를 선택하여 예약하신 다음 다비치안경매장을 방문하시면<br>
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
	    <!---// 02.LAYOUT: 카테고리 메인 --->
		<!-- popup_detail -->
		<div class="popup layer_lens_datil" style="display: none;height:500px;overflow-y:scroll;">
			<div id="popup_content"></div>
			<button type="button" class="btn_close_popup"><img src="../img/common/btn_close_popup.png" alt="팝업창닫기"></button>
		</div>
		<!--// popup_detail -->
		<div class="popup" id="div_visit_book_popup" style="display:none;">
		</div>
	
	</t:putAttribute>
</t:insertDefinition>