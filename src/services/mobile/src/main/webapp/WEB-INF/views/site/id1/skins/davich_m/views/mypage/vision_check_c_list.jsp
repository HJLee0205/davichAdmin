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
	function fn_go_vision_check(){
    	document.location.href="${_MOBILE_PATH}/front/vision2/my-vision-check-g";
    }
    
    $(".btn_recom_again_new").click(function(){		
		document.location.href="${_MOBILE_PATH}/front/vision2/vision-check?lensType=C";
	});
    
    function fn_gun_img(v_gun_no){
		$.ajax({
 			type : "POST",
 			url : "${_MOBILE_PATH}/front/vision2/vision-check-gun-img",    	
 			data : {
 				lettNo : v_gun_no
 			},
 			dataType : "xml",
 			success : function(result) {
                
 				var imgFile = '';
 				$("att_img",result).each(function(){
 					if($("img_yn",this).text() == 'N'){
 						imgFile += '<li><img src="${_IMAGE_DOMAIN}/image/image-view?type=VISION&path=' + $("file_path",this).text() + '&id1=' + $("file_name",this).text() + '"></li>';
 					}
 				});
				
 				var v_targrt = $(".lens_slider").find("ul"); 				
 				v_targrt.html('');
 				v_targrt.html(imgFile); 		

 				$("#trainings-slide").show();
 				LensSlider.reloadSlider(); 
 			},
 			error : function(result, status, err) {
 				alert(result.status + " / " + status + " / " + err);
 			},
 			beforeSend: function() {
 			    
 			},
 			complete: function(){
 			}
 		});
	}
	
	function fn_goods_list(v_gun_no, v_id){
		/*군에 해당하는 제품 가져오기 v_gun_no*/
		
		
		/*가져온 제품 보여주기*/
		var v_targrt = $("#result_product_list_"+v_id).find("ul");		
		//v_targrt.html('<p>준비중.</p>');
		
	}
	
	var LensSlider = $('.lens_slider ul').bxSlider({
		auto: true,
		controls: false,
		speed:400,
		infiniteLoop:true,
		pager:true,
	});
	$('.btn_lens_list_prev').click(function () {
		var current = LensSlider.getCurrentSlide();
		LensSlider.goToPrevSlide(current) - 1;
	});
	$('.btn_lens_list_next').click(function () {
		var current = LensSlider.getCurrentSlide();
		LensSlider.goToNextSlide(current) + 1;
	});
	
	$(".btn_view_recomm_new").click(function(){
     	
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
         
     	var v_type = $("#lensType").val();
     	var v_active = $("#incon2CdNm").val() + " " + $("#incon1CdNm").val();
     	var v_age = $("#ageCdCNm").val();
		var v_lengsName = "";
     	var v_type_nm = "콘택트렌즈";	       
     	var cnt = 0;     	
		        	
       	$("input:checkbox[name='lens_check']").each(function(e){
       		if($(this).is(":checked") == true) {
       			cnt++;
       			var tmp = $(this).val().split("-");
       			v_lengsName = v_lengsName + tmp[1] + ",";	                			
       		}
       	});         	
			
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
 						//alert("상품을 선택해 주세요.");
 						Dmall.LayerUtil.alert("상품을 선택해 주세요.","확인");
             			return false;
 					}
         	  }
     	});
     
 	});
	
	function fn_wear_info(){
		Dmall.LayerUtil.alert("착용법/제거법/세척법 안내 추가","확인");
	}
	
	function fn_contact_type_info(){
		Dmall.LayerUtil.alert("사람마다의 홍채색상, 홍채크기가 다른점 안내 추가","확인");
	}
	
	function fn_oph_visit(){
		Dmall.LayerUtil.alert("안과 방문 유도 추가","확인");
	}
	
	function fn_oneside_lens(){
		Dmall.LayerUtil.alert("한쪽만 구매가능 및 홍채렌즈 안내 추가","확인");
	}
	
	function fn_hula_info(){
		Dmall.LayerUtil.alert("각막곡률과 착용법/제거법/세척법 안내, 사람마다의 홍채색상, 홍채크기가 다른점 안내 추가","확인");
	}
	
	function fn_composure_info(){
		Dmall.LayerUtil.alert("착용주기 짧은 렌즈 추천 안내 추가","확인");
	}
	
	function fn_loss_info(){
		Dmall.LayerUtil.alert("착용주기 짧은 렌즈 추천 안내 추가","확인");
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
			<form:form id="form_vision_check" name="form_vision_check" method="post">				
				<input type="hidden" name="lensType" id="lensType" value="${classesPO.lensType}">
				<input type="hidden" name="ageCdCNm" id="ageCdCNm" value="${classesPO.ageCdCNm}">							
				<input type="hidden" name="incon1CdNm" id="incon1CdNm" value="${classesPO.incon1CdNm}">	
				<input type="hidden" name="incon2CdNm" id="incon2CdNm" value="${classesPO.incon2CdNm}">
	        </form:form>
			<ul class="tabs_vision lens">
				<li rel="tab01" onclick="fn_go_vision_check();">추천 안경렌즈</li>
				<li rel="tab02" class="active">추천 콘택트렌즈</li>
			</ul>
			<c:if test="${!empty purpList}">
			<ul class="lens_recomm_checked_new">
				<li>
					<span class="tit">라이프스타일</span>
					<ul class="text">
						<c:forEach var="result" items="${purpList}" varStatus="status">
						<li>
							<img src="${_SKIN_IMG_PATH}/vision2/contact/contact_purp_${result.cd}.gif" alt="${result.cdNm}">
							<span>${result.cdNm}</span>	
						</li>
						</c:forEach>						
					</ul>
				</li>
				<li>
					<span class="tit">증상</span>
					<ul class="text">
						<c:forEach var="result" items="${incon1List}" varStatus="status">
						<li>
							<img src="${_SKIN_IMG_PATH}/vision2/contact/incon1_c_${classesPO.wearCd}_${result.cd}.gif" alt="${result.cdNm}">
							<!-- 
							물체가 부분만 보임 : 04, 10
							한쪽 눈만 사용, 한쪽 눈 시력안나옴 : 05, 11
							 -->
							<c:choose>
								<c:when test="${result.cd == '04' || result.cd == '10'}"><span><a href="#none" onclick="fn_oph_visit()">${result.cdNm}[+]</a></span></c:when>
								<c:when test="${result.cd == '05' || result.cd == '11'}"><span><a href="#none" onclick="fn_oneside_lens()">${result.cdNm}[+]</a></span></c:when>
								<c:otherwise><span>${result.cdNm}</span></c:otherwise>
							</c:choose>
						</li>
						</c:forEach>						
					</ul>
				</li>
				<li>
					<span class="tit">연령대</span>
					<ul class="text">
						<li>
							<img src="${_SKIN_IMG_PATH}/vision2/start/age_c_${classesPO.ageCdC}.gif" alt="${classesPO.ageCdCNm}">
							<span>${classesPO.ageCdCNm}</span>	
						</li>
						<li>
							<img src="${_SKIN_IMG_PATH}/vision2/contact/wear_c_${classesPO.wearCd}.gif" alt="${classesPO.wearCdNm}">
							<!-- 처음착용 01 -->
							<c:choose>
								<c:when test="${classesPO.wearCd == '01'}"><span><a href="#none" onclick="fn_wear_info()">${classesPO.wearCdNm}[+]</a></span></c:when>
								<c:otherwise><span>${classesPO.wearCdNm}</span></c:otherwise>
							</c:choose>		
						</li>	
						<li>
							<img src="${_SKIN_IMG_PATH}/vision2/contact/contact_type_${classesPO.contactTypeCd}.gif" alt="${classesPO.contactTypeCdNm}">
							<!-- 컬러 02 -->
							<c:choose>
								<c:when test="${classesPO.contactTypeCd == '02'}"><span><a href="#none" onclick="fn_contact_type_info()">${classesPO.contactTypeCdNm}[+]</a></span></c:when>
								<c:otherwise><span>${classesPO.contactTypeCdNm}</span></c:otherwise>
							</c:choose>		
						</li>	
						<li>
							<img src="${_SKIN_IMG_PATH}/vision2/contact/wear_time_${classesPO.wearTimeCd}.gif" alt="${classesPO.wearTimeCdNm}">
							<span>${classesPO.wearTimeCdNm}</span>	
						</li>	
						<li>
							<img src="${_SKIN_IMG_PATH}/vision2/contact/wear_day_${classesPO.wearDayCd}.gif" alt="${classesPO.wearDayCdNm}">
							<span>${classesPO.wearDayCdNm}</span>	
						</li>						
					</ul>
				</li>
				<c:if test="${classesPO.wearCd == '02'}">
				<li>
					<span class="tit">착용시 불편함</span>
					<ul class="text">
						<c:forEach var="result" items="${incon2List}" varStatus="status">
						<li>
							<img src="${_SKIN_IMG_PATH}/vision2/contact/incon2_c_${classesPO.contactTypeCd}_${result.cd}.gif" alt="${result.cdNm}">
							<!-- 
							훌라현상 : 09 
							이물질침착 : 03
							찢어짐, 분실 : 05, 11
							-->
							<c:choose>
								<c:when test="${result.cd == '09'}"><span><a href="#none" onclick="fn_hula_info()">${result.cdNm}[+]</a></span></c:when>
								<c:when test="${result.cd == '03'}"><span><a href="#none" onclick="fn_composure_info()">${result.cdNm}[+]</a></span></c:when>
								<c:when test="${result.cd == '05' || result.cd == '11'}"><span><a href="#none" onclick="fn_loss_info()">${result.cdNm}[+]</a></span></c:when>
								<c:otherwise><span>${result.cdNm}</span></c:otherwise>
							</c:choose>		
						</li>
						</c:forEach>						
					</ul>
				</li>
				</c:if>
			</ul>
			</c:if>
			
			<div class="lens_recomm_new result">
			'${userName}' 고객님 라이프스타일과 눈에 적합한 <!-- <em>'청광차단 안전렌즈(UV)'</em> --> 콘택트렌즈를 추천드립니다.
			</div>			
				
			<c:if test="${empty purpList}">
				<div class="lens_recomm_new result">
					<p class="recomm_text">렌즈추천정보가 없습니다.</p>
					<p class="recomm_text">지금 추천받기 버튼을 눌러 고객님께 꼭 맞는 렌즈를 추천 받아보세요.</p>
				</div>
			</c:if>	
			
			<button type="button" class="btn_recom_again_new">콘택트렌즈 추천 다시받기</button>
			
			<c:if test="${!empty visionGunList}">
			<!-- 결과 추천 상품 리스트 -->
			<ul class="lens_result_new">
			<c:forEach var="result" items="${visionGunList}" varStatus="status">
				<li>
					<p class="img">
						<c:if test="${!empty result.fileNm}">
						<img src="${_IMAGE_DOMAIN}/image/image-view?type=VISION&path=${result.filePath}&id1=${result.fileNm}" alt="${result.gunNm}">
						</c:if>
					</p>
					<div class="info">
						<p class="tit">	
							<input type="checkbox" class="lens_check_new" name="lens_check" id="lens_check${status.count}" value="${result.gunNo}-${result.gunNm}">
							<label for="lens_check${status.count}">${result.gunNm}<span></span></label>
							<c:if test="${result.imgCnt > 0}">
							<button type="button" class="btn_view_lens_new" onclick="fn_gun_img(${result.gunNo})">자세히보기</button>
							</c:if>
						</p>	
						<span class="price">렌즈 가격대 ${result.priceRange}</span>
						<p class="text">${result.simpleDscrt}</p>
					</div>
					<button type="button" class="btn_view_result" onclick="fn_goods_list(${result.gunNo}, ${status.count})">상품보기</button>					
				</li>
				<li class="result_product_list" style="display: none;" id="result_product_list_${status.count}">
					<!-- 해당 상품 리스트 -->
					<c:set value="gunGoodsList_${result.gunNo}" var="goodsList"/>
					<c:choose>
		                <c:when test="${fn:length(requestScope[goodsList]) > 0 }">
		                    <data:goodsList value="${requestScope[goodsList]}" displayTypeCd="01" headYn="Y" iconYn="Y"/>
		                </c:when>
		                <c:otherwise>
		                    <p class="no_blank" style="padding:50px 0 50px 0;text-align:center;">등록된 상품이 없습니다.</p>
		                </c:otherwise>
		            </c:choose>
					<!--// 해당 상품 리스트 -->
				</li>
			</c:forEach>				
			</ul>
			<!--// 결과 추천 상품 리스트 -->
	
			<div class="btn_lens_area_new">
				<button type="button" class="btn_view_recomm_new">바로 예약하기</button>
			</div>
			<!--// 렌즈추천 -->	
			</c:if>
		</div>
	</div>
	<!-- popup_슬라이드 자세히보기 이미지 사이즈 600 * 600 -->
	<div class="popup layer_lens_slide">
		<div id="popup_content">
			<div class="lens_slider">
				<ul></ul>
			</div>
			<button type="button" class="btn_lens_list_prev">이전</button>
			<button type="button" class="btn_lens_list_next">다음</button>
		</div>
		<button type="button" class="btn_close_popup">
	</div>
	<!--// popup_슬라이드 자세히보기 이미지 사이즈 600 * 600 -->
	
	<!-- popup_detail -->
	<div class="popup layer_lens_datil" style="display: none;"></div>
	<!--// popup_detail -->
	
	<!--  방문예약이 존재한다면  -->
	<div id="div_visit_book_popup" style="display:none;"></div>
	</t:putAttribute>
</t:insertDefinition>