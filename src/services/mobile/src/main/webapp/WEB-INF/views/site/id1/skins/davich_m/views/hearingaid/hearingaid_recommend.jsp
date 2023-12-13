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
	<t:putAttribute name="title">다비치마켓 :: 보청기 추천</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">	
	<script type="text/javascript">
	$(".btn_list_view").click(function(){                	
     	var cnt = 0;
     	
     	// 보청기 추천 후 검색
         var v_searchGoodsNos = "";
     	
     	$("input:checkbox[name='lens_check']").each(function(e){
     		if($(this).is(":checked") == true) {
     			cnt++;
     			var tmp = $(this).val().split("||");
     			v_searchGoodsNos = v_searchGoodsNos + tmp[0] + ",";     			
     		}
     	});
     	
     	if(cnt > 0){
     		$('#searchGoodsNos').val(v_searchGoodsNos.substring(0, v_searchGoodsNos.length-1));
             var param = {searchGoodsNos : $('#searchGoodsNos').val()};             
             Dmall.FormUtil.submit('${_MOBILE_PATH}/front/search/goods-list-search', param);
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
                     location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                 }
             );
             return;
         }
         
     	var v_type = 'H';
     	var v_type_nm = "보청기";	  
     	var v_active = "";
     	var v_age = $("#age").val();
		var v_lengsName = "";     
     	var cnt = 0; 
     	
    	$("input:hidden[name='hearingaidStep1']").each(function(e){      		
       			v_active = v_active + $(this).val() + ",";	         
       	});
    	v_active = v_active.substring(0, v_active.length-1);
     	
       	$("input:checkbox[name='lens_check']").each(function(e){
       		if($(this).is(":checked") == true) {
       			cnt++;
       			var tmp = $(this).val().split("||");
       			v_lengsName = v_lengsName + tmp[1] + ",";	                			
       		}
       	});
	
		v_lengsName = v_lengsName.substring(0, v_lengsName.length-1);

		if(cnt > 0){						
			var visionChk = v_type + " | " + v_type_nm + " | " + v_active + " | " + v_age + " | " + v_lengsName;
            var param = {visionChk : visionChk, isHa : 'Y'};
            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-book', param);
			
		}else{
			//alert("상품을 선택해 주세요.");
			Dmall.LayerUtil.alert("상품을 선택해 주세요.","확인");
   			return false;
		}
     
 	});
	 
	$(".btn_result_save").click(function(){
    	
		var loginYn = ${user.login};
        if(!loginYn) {
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    //var returnUrl = window.location.pathname+window.location.search;
                    var returnUrl = "${_MOBILE_PATH}/front/hearingaid/hearingaid-check";                                
                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                }
            );
            return;
        }                	
    	
    	Dmall.LayerUtil.confirm("결과를 저장하시겠습니까?", function(){                		
    		
    		var v_stepCd = $("#step1CdFlg").val() + "," + $("#step2CdFlg").val();
    		if($("#step3CdFlg").val() != "") v_stepCd += "," + $("#step3CdFlg").val();
    		
    		var v_resultAll = $(".vision_result").html();    		
    		var v_goods_no = "";
    		var v_goods_nm = "";
    		var v_relateActivity = $("#relateActivity").val();
    		$("input:checkbox[name='lens_check']").each(function(e){	  
    			var tmp = $(this).val().split("||");
    			v_goods_no = v_goods_no + tmp[0] + ",";
    			v_goods_nm = v_goods_nm + tmp[1] + ",";
        	}); 
    		
    		//alert(v_stepCd + " || " + v_goods_no+ " || " + v_goods_nm);
    		
    		$.ajax({
    	 		type : "POST",
    	 		url : "${_MOBILE_PATH}/front/hearingaid/hearingaid-check-insert",
    	 		data : {
    	 			goodsNos	: v_goods_no,
    	 			goodsNms	: v_goods_nm,
    	 			ctgNos 		: v_stepCd,
    	 			resultAll	: v_resultAll,
    	 			relateActivity : v_relateActivity
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
    	 			document.location.href='${_MOBILE_PATH}/front/hearingaid/my-hearingaid-check';
    	 		}
    	 	});	
    		
    	});
    	
    	return;
    });
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<div class="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			보청기 추천
		</div>
		<form:form id="form_ha_check" name="form_ha_check" method="post">
			<input type="hidden" name="haUse" id="haUse" value="${hearingaidVO.haUse}">
			<input type="hidden" name="step1Cd" id="step1Cd" value="${hearingaidVO.step1Cd}">
			<input type="hidden" name="step1CdFlg" id="step1CdFlg" value="${hearingaidVO.step1CdFlg}">
			<input type="hidden" name="ringing" id="ringing" value="${hearingaidVO.ringing}">
			<input type="hidden" name="step2CdFlg" id="step2CdFlg" value="${hearingaidVO.step2CdFlg}">
			<input type="hidden" name="haType" id="haType" value="${hearingaidVO.haType}">
			<input type="hidden" name="step3CdFlg" id="step3CdFlg" value="${hearingaidVO.step3CdFlg}">
			<input type="hidden" name="relateActivity" id="relateActivity" value="${hearingaidVO.relateActivity}">
		</form:form>		
		<div class="lens_info_area">
			<p class="tit">추천 보청기</p>			
		</div>
		<div class="cont_body">
			<div class="lens_recomm result">
				<div class="vision_result">
					<p class="recomm_text">보청기 착용 경험 					
						<c:choose>
							<c:when test="${hearingaidVO.haUse == 'N'}"><em>[없음]</em></c:when>
							<c:when test="${hearingaidVO.haUse == 'Y'}"><em>[있음]</em></c:when>
							<c:otherwise><em>[없음]</em></c:otherwise>
						</c:choose>					
					</p>
					<p class="recomm_text">불편사항  <em>
						<c:choose>
							<c:when test="${empty hearingaidStep1}">[없음]</c:when>
							<c:otherwise>
								<c:forEach var="result" items="${hearingaidStep1}" varStatus="status">[${result.cdNm}] 
									<input type="hidden" name="hearingaidStep1" value="${result.cdNm}">
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</em></p>
					<p class="recomm_text">이명 유무
						<c:choose>
							<c:when test="${hearingaidVO.ringing == 'N'}"><em>[없음]</em></c:when>
							<c:when test="${hearingaidVO.ringing == 'Y'}"><em>[있음]</em></c:when>
							<c:otherwise><em>[없음]</em></c:otherwise>
						</c:choose>	
					 </p>
					<p class="recomm_text">선호타입  
						<c:choose>
							<c:when test="${hearingaidVO.haType == 'I'}"><em>[귓속 타입]</em></c:when>
							<c:when test="${hearingaidVO.haType == 'O'}"><em>[귀걸이 타입]</em></c:when>
							<c:otherwise><em>[상관없음]</em></c:otherwise>
						</c:choose>	을 선택하신 <b>${userName}</b> 고객님에게</p>
					<p class="recomm_text">추천 드리는 보청기 입니다.</p>
				</div>
				<button type="button" class="btn_lens_show" onclick="document.location.href='${_MOBILE_PATH}/front/hearingaid/hearingaid-check?haUse=${hearingaidVO.haUse}'">보청기 추천 다시받기<i></i></button>
			</div>
			<ul class="lens_result">
				<c:choose>
					<c:when test="${empty hearingaidRecommend}">
						<li>
							<p style="float:left; padding: 17px 28px 18px; box-sizing:border-box;">
								죄송합니다.<br>
								조건에 맞는 보청기를 찾지 못하였습니다.<br>
								가까운 다비치 보청기를 방문해주시면 청각전문가가 고객님에게 적합한 보청기를 찾아드립니다.
							</p>
						</li>
					</c:when>
					<c:otherwise>
						<c:forEach var="li" items="${hearingaidRecommend}" varStatus="status">
							<li>
								<p style="float:left; padding: 17px 28px 18px; box-sizing:border-box;">
									<input type="checkbox" class="lens_check" name="lens_check" id="lens_check${status.index}" value="${li.goodsNo}||${li.goodsNm}">
									<label for="lens_check${status.index}">${li.goodsNm}<span style="margin-left:20px;"></span></label>
								</p>				
								<!-- <p class="text">12345</p>
								<input type="hidden" name="imgNm" value="">
								<button type="button" class="btn_view_lens">자세히보기</button> -->
							</li>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</ul>
			<div class="btn_lens_area">
				<button type="button" class="btn_list_view">상품 목록보기</button>
				<button type="button" class="btn_go_recomm">바로 예약하기</button>
				<button type="button" class="btn_result_save"><i></i>결과 저장</button>
			</div>
		</div>
	</div>
	</t:putAttribute>
</t:insertDefinition>