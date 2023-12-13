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
    <script>
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
         
     	var v_type = 'H';
     	var v_type_nm = "보청기";	  
     	var v_active = $("#relateActivity").val();
     	var v_age = "";
		var v_lengsName = "";     
     	var cnt = 0; 
    	v_active = v_active.substring(0, v_active.length-1);
     	
       	$("input:checkbox[name='lens_check']").each(function(e){
       		if($(this).is(":checked") == true) {
       			cnt++;
       			var tmp = $(this).val().split("||");
       			v_lengsName = v_lengsName + tmp[1] + ",";	                			
       		}
       	});
	
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
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->
    
    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="mypage_middle">	
    
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div id="mypage_content">
            
	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
	            <form:form id="form_ha_check" name="form_ha_check" method="post">
					<input type="hidden" name="searchGoodsNos" id="searchGoodsNos" value="">					
				</form:form>
	            <div class="mypage_body">
					<h3 class="my_tit">보청기 추천</h3>
					<div class="order_cancel_info">					
						<span class="icon_purpose">‘보청기 추천’ 란 고객의 생활환경을 고려하여 최적의 보청기를 찾아드리는 추천 시스템입니다.</span>
					</div>
					<div class="tabs_vision_content">
						<c:choose>
							<c:when test="${empty hearingaidCheckList}">
								<div class="lens_recomm result">
									<p class="recomm_text">보청기 추천정보가 없습니다.</p>
									<p class="recomm_text">지금 추천받기 버튼을 눌러 고객님께 꼭 맞는 보청기를 추천 받아보세요.</p>
									<button type="button" class="btn_recom_again" onclick="document.location.href='/front/hearingaid/hearingaid-check';">지금 추천받기<i></i></button>
								</div>
							</c:when>
							<c:otherwise>					
								<div class="lens_recomm result">
									${topHearingaidCheckVO.resultAll}
									<button type="button" class="btn_recom_again" onclick="document.location.href='/front/hearingaid/hearingaid-check';">보청기추천 다시받기<i></i></button>								
									<input type="hidden" name="relateActivity" id="relateActivity" value="${topHearingaidCheckVO.relateActivity}">
								</div>
								<ul class="lens_result">
									<c:forEach var="li" items="${hearingaidCheckList}" varStatus="status">
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
								</ul>
								<p class="lens_result_date">저장일 ${fn:substring(topHearingaidCheckVO.regDttm,0,10)}</p>
			
								<div class="btn_lens_area">
									<button type="button" class="btn_list_view g">상품 목록보기</button>
									<button type="button" class="btn_go_recomm g">바로 예약하기</button>
								</div>	
							</c:otherwise>
						</c:choose>
					
					</div>
				</div>
			</div>
		</div>
	</t:putAttribute>
</t:insertDefinition>