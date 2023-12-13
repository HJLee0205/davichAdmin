<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<script>

$(document).ready(function(){
	
	$("#div_store_detail_popup").show();
    var url = '/front/visit/store-info';
    var storeCode =  '<c:out value="${so.storeCode}"/>';
    var param = {storeCode : storeCode};
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
    	var address= [];
    	var addr = result.addr1||' '||result.addr2;
    	var strCode = result.strCode;
    	var strName = result.strName;
    	var telNo = result.telNo;
    	var affList = result.affiliateList;
    	var cont = result.cont;
    	if(affList && affList.length > 0){
    		var affHtml = '';
	    	for(var i=0;i<affList.length;i++){
	    		if(i%3==0){
	    			affHtml += '<tr>';
	    		}
	    		if(affList[i].venUrl != null && affList[i].venUrl != ''){
	    			affHtml += '<td onclick="javascript:window.open(\''+affList[i].venUrl+'\',\'_blank\')" style="cursor:pointer;">';
	    		}else{
	    			affHtml += '<td>';
	    		}
    			affHtml += '<div class="partner_img">';
   				affHtml += '<img src="data:image/png;base64,'+affList[i].logoImage+'" alt="'+affList[i].logoImageName+'" onerror="this.src=\'/front/img/common/no_image.png\'">';
				affHtml += '</div>';
 				affHtml += '<p class="name">'+affList[i].venName+'</p>';
 				affHtml += '<p class="benefit">'+affList[i].dcRate+'%</p>';
 				affHtml += '<p class="text">'+affList[i].cont+'</p>';
 				affHtml += '</td>';
 				if(i%3==2){
	    			affHtml += '</tr>';
	    		}
	    	}
	    	
	    	$('#ul_affList').html(affHtml)
	    	$('#ul_affList_tab').css('display','block');
	    	$('#span_aff').css('display','block');
    	}else{
    		$('#ul_affList_tab').css('display','none');
    		$('#span_aff').css('display','none');
    	}
    	
        address.push({"address":addr,"storeNo":strCode,"storeNm":strName, "telNo":telNo});
        searchGeoByAddrByMap3(address);
        
        if(cont != null && cont != ''){
    		strName += ' ' + '<img src="${_SKIN_IMG_PATH}/common/crown25.png" alt="우수매장">' + cont;
    		$('#id_storeNm').css('font-size','20px');
    	}else{
    		$('#id_storeNm').css('font-size','25px');
    	}
        $('#id_storeNm').empty().append('다비치안경 ' + strName);
        $('#id_tel').text(result.telNo);
        $('#id_addr').text(addr);
    });
    
	// X버튼, 취소 버튼 클릭시 팝업 숨기기
	$("#div_store_detail_popup").find(".btn_close_popup, .btn_close_popup02").click(function() {
		$("#div_store_detail_popup").hide();
	});
        
});
</script>

<div class="popup">
	<div class="inner cancel" style="width:783px; height:650px;overflow-y:auto">
		<div class="popup_head">
			<h1 class="tit"><span class="pop_logo" id="id_storeNm">다비치안경</span></h1>
			<button type="button" class="btn_close_popup">창닫기</button>
		</div>
		<div class="popup_body"> 
			<div class="shop_info_wrap">
					<div class="shop_map_view">
                         <div id="map3" style="width:100%;height:400px;"></div>
					</div>
					<div class="shop_info">
						<span class="shop_tit02">전화번호</span><em id="id_tel"></em><br>
						<span class="shop_tit02">주소</span><em id="id_addr"></em><br>
						<!-- 제휴업체 정보 추가 -->
						<span class="shop_tit03" id="span_aff">제휴업체</span>
						<%--<ul class="partner_view_list" id="ul_affList">
						</ul>--%>
						<table class="partner_view_list" id="ul_affList_tab" style="display: block;">
							<caption>제휴업체 정보입니다.</caption>
							<colgroup>
								<col style="width:33.3333%">
								<col style="width:33.3333%">
								<col>
							</colgroup>
							<tbody id="ul_affList" >
							</tbody>
						</table>
						<!--// 제휴업체 정보 추가 -->
					</div>
				</div>
		</div>
	</div>
</div>



