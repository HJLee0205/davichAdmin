<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 처방전관리</t:putAttribute>


 <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	// 기존 이벤트 제거
    	$(".btn_presc_registration").off("click");
   		// 등록 화면 팝업
    	$("#btn_pop_prescription_reg").on("click", function() {
    		var url = "/front/mypage/prescription_reg_form";
    		
    		Dmall.AjaxUtil.load(url, function(result) {
				$("#prescriptionPop").html(result);
    		});
    	});
   		// 삭제
    	$(".btn_del_presc").on("click", function() {
    		var prescriptionNo = $(this).siblings("[name=prescriptionNo]").val();
    		var yesFunc = function() {
        		var url = "/front/mypage/prescription_del";
        		var param = "prescriptionNo=" + prescriptionNo;
        		Dmall.AjaxUtil.getJSON(url, param, function(result) {
        			if(result.success) {
        				document.location.href = "/front/mypage/prescription";
        			}
        		});
    		};
    		Dmall.LayerUtil.confirm("삭제하시겠습니까?", yesFunc, null, "삭제확인", "");
    	});
   		// 처방전 이미지 팝업
    	$(".a_prescription_img").on("click", function() {
    		var fileId = $(this).siblings("[name=prescriptionFileId]").val();
    		var url = "${_IMAGE_DOMAIN}/image/image-view?type=PRESCRIPTION&id1=" + fileId;
    		var win = window.open(url, "prescriptionImgWin", "width=100,height=100,resizable=yes");
    		var img = new Image();
    		img.onload = function() {
    			var width = this.width;
    			var height = this.height;
    			var titleHeight = win.outerHeight - win.innerHeight;
    			height += titleHeight;
    			
    			// 이미지 크기에 맞게 사이즈 재조정
    			win.resizeTo(width, height);
    		}
    		img.src = url;
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
	            
				<div class="mypage_body">
					<h3 class="my_tit">처방전 관리</h3>
					<div class="order_cancel_info">					
						<span class="icon_purpose">처방전은 상품 추천시 참조자료로 활용되며, 최대 10개까지 등록가능합니다.</span>
					</div>
					
					<table class="tProduct_Board">
						<caption>
							<h1 class="blind">내 시력정보 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:138px">
							<col style="width:">
							<col style="width:144px">
							<col style="width:134px">
							<col style="width:130px">
						</colgroup>
						<thead>
							<tr>
								<th>처방일</th>
								<th>파일</th>
								<th>발급기관</th>
								<th>등록일</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="prescription" items="${prescriptionList}">
								<tr>
									<td>${prescription.checkupDt}</td>							
									<td class="textL">
										<input type="hidden" name="prescriptionFileId" value="${prescription.prescriptionFileId}" />
										<a class="a_prescription_img">${prescription.prescriptionOrgFileNm}<span class="icon_img">첨부파일</span></a>
									</td>
									<td>${prescription.checkupInstituteNm}</td>
									<td><fmt:formatDate value="${prescription.regDttm}" pattern="yyyy-MM-dd" /></td>
									<td>
										<input type="hidden" name="prescriptionNo" value="${prescription.prescriptionNo}" />
										<button type="button" class="btn_del_presc">삭제</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="btn_davichi_area">
						<button type="button" class="btn_presc_registration" id="btn_pop_prescription_reg">처방전 등록</button>
					</div>
				</div>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
	</div>

	<div class="popup" id="prescriptionPop">
	</div>
    </t:putAttribute>
</t:insertDefinition>