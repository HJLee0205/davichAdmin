<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions"  %>

<script>

$(document).ready(function(){
	
	$("#div_visit_book_popup").show();
    
	// X버튼, 취소 버튼 클릭시 팝업 숨기기
	$("#div_visit_book_popup").find(".btn_close_popup, .btn_close_popup02").click(function() {
		$("#div_visit_book_popup").hide();
	});
	
	// 기존예약에 추가
    $("#add_visit_book").click(function () {

    	var rsvNo = $(':radio[name="rdRsvNo"]:checked').val();
    	
    	if (rsvNo == '' || rsvNo == undefined) {
            Dmall.LayerUtil.alert("방문예약을 선택하세요", "알림");
			return ;    		
    	}
    	
    	var visitPurposeNm = '	▶추천렌즈예약:${fn:substring(so.visionChk,3,fn:length(so.visionChk))}';
        var url = '/front/visit/add-visit-book';
        var param = {rsvNo: rsvNo, visitPurposeNm:visitPurposeNm};
        
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
        	
            if(result.success) {
                Dmall.LayerUtil.alert("방문예약정보가 추가되었습니다.", "알림");
                location.href="/front/visit/visit-list";
            }
        });
    	
	});
	
	// 신규예약
    $("#new_visit_book").click(function () {
		var visionChk = '${so.visionChk}';
        var param = {visionChk : visionChk};
        Dmall.FormUtil.submit('/front/visit/visit-book', param);
	});
        
});
</script>

<div class="popup">
	<div class="inner cancel" style="width:600px; height:450px;">
		<div class="popup_head">
			<h1 class="tit"><span class="pop_logo" id="id_storeNm">방문예약 목록</span></h1>
			<button type="button" class="btn_close_popup">창닫기</button>
		</div>
		<div class="popup_body" style="width:550px; height:250px; overflow:auto; ">
			<table class="tProduct_Board">
				<colgroup>
					<col style="width:10%">
					<col style="width:30%">
					<col style="width:30%">
					<col style="width:30%">
				</colgroup>
				<thead>
					<tr>
						<th>선택</th>
						<th>예약일자</th>
						<th>예약시간</th>
						<th>예약매장</th>
					</tr>
				</thead>
				<tbody>
	             <c:forEach var="visitList" items="${visit_list}" varStatus="status">
			      	<tr>
			      		<td>
		                    <input type="radio" id="rdRsvNo${status.count}" name="rdRsvNo" value="${visitList.rsvNo}">
		                    <label for="rdRsvNo${status.count}">
		                        <span></span>
		                    </label>
			        	</td>
			        	<td>${visitList.strRsvDate}</td>
			        	<td>${visitList.rsvTime}</td>
			        	<td>${visitList.storeNm}</td>
			      	</tr>
	             </c:forEach>
				</tbody>
			</table>
		</div>
	   	<div class="popup_btn_area">
			<button type="button" class="btn_go_recomm" id="add_visit_book">기존 방문예약에 추가</button>
			<button type="button" class="btn_go_recomm" id="new_visit_book">신규 방문예약</button>
		</div>
	</div>
	
</div>



