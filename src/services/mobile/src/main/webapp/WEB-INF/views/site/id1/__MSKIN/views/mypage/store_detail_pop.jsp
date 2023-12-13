<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script>

$(document).ready(function(){
	
	$("#div_store_detail_popup").show();
    var url = '${_MOBILE_PATH}/front/visit/store-info';
    var storeCode =  '<c:out value="${so.storeCode}"/>';
    
    var param = {storeCode : storeCode};
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
    	var address= [];
    	var addr = result.addr1||' '||result.addr2;
    	var strCode = result.strCode;
    	var strName = result.strName;
		var telNo = result.telNo
    	var affList = result.affiliateList;
    	var cont = result.cont;
    	if(affList && affList.length > 0){
    		var affHtml = '';
	    	for(var i=0;i<affList.length;i++){
	    		if(i%2==0){
	    			affHtml += '<tr>';
	    		}
	    		if(affList[i].venUrl != null && affList[i].venUrl != ''){
	    			affHtml += '<td onclick="javascript:window.open(\''+affList[i].venUrl+'\',\'_blank\')" style="cursor:pointer;">';
	    		}else{
	    			affHtml += '<td>';
	    		}
    			affHtml += '<div class="partner_img">';
   				affHtml += '	<img src="data:image/png;base64,'+affList[i].logoImage+'" alt="'+affList[i].logoImageName+'" onerror="this.src=\'/front/img/common/no_image.png\'">';
				affHtml += '</div>';
 				affHtml += '<p class="name">'+affList[i].venName+'</p>';
 				affHtml += '<p class="benefit">'+affList[i].dcRate+'%</p>';
 				affHtml += '<p class="text" style="line-height: 18px;">'+affList[i].cont+'</p>';
 				affHtml += '</td>';
 				if(i%2==1){
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
    	
        address.push({"address":addr,"storeNo":strCode,"storeNm":strName,"telNo":telNo});
        searchGeoByAddrByMap3(address);
        
        if(cont != null && cont != ''){
    		strName += ' ' + '<img src="${_SKIN_IMG_PATH}/common/crown16.png" alt="우수매장">' + cont;
    		$('#id_storeNm').css('font-size','0.7rem');
    	}else{
    		$('#id_storeNm').css('font-size','1rem');
    	}
        
        $('#id_storeNm').empty().append('다비치안경 ' + strName);
        $('#id_tel').html('<a href="tel:'+result.telNo+'">'+result.telNo+'</a>');
        $('#id_addr').text(addr);
        $("#telLink").attr('href', 'tel:' + result.telNo);
		$('#id_visit').attr('href', '/m/front/visit/visit-welcome?storeNm=' + strName + '&storeCode=' + strCode);
    });
    
	// X버튼, 취소 버튼 클릭시 팝업 숨기기
	$("#div_store_detail_popup").find(".btn_close_popup, .btn_close_popup02").click(function() {
		$("#div_store_detail_popup").hide();
	});	    
        
});
</script>

	<div class="inner cancel" style="width:100%; height:450px;overflow-y:auto">
		<div class="popup_head">
			<h1 class="tit"><span id="id_storeNm">다비치안경</span></h1>
			<button type="button" class="btn_close_popup">창닫기</button>
		</div>
		<div class="popup_body"> 
			<div class="shop_info_wrap">
					<div class="shop_map_view">
                         <div id="map3" style="width:100%;height:200px;"></div>
					</div>
					<div class="shop_info">
						<span class="shop_tit02">전화번호</span><em id="id_tel"></em>
						<span class="shop_tit02">주소</span><em id="id_addr"></em>
						<span class="shop_tit02" id="span_aff">제휴업체</span>
						<span class="shop_call">전화하기</span>

						<a id="id_visit"><img class="shop_visit" src="/m/skin/img/customer/btn_visit.png"></a>
						<a id="telLink"><span class="shop_call">전화하기</span></a>
						
						<!-- 제휴업체 정보 추가 -->
						<%--<ul class="partner_view_list" id="ul_affList">
						</ul>--%>
						<table class="partner_view_list" id="ul_affList_tab" style="display: block;">
							<caption>제휴업체 정보입니다.</caption>
							<colgroup>
								<col style="width:50%">
								<col style="width:50%">
							</colgroup>
							<tbody id="ul_affList" >
								<%--<tr>
									<td>
										<div class="partner_img"><img src="/front/img/common/no_image.png" alt=""></div>
										<p class="name">스테이트타워직원(명동)</p>
										<p class="benefit">10%</p>
										<p class="text">인근회사 및 주민</p>
									</td>
									<td>
										<div class="partner_img"><img src="/front/img/common/no_image.png" alt=""></div>
										<p class="name">스테이트타워직원(명동)</p>
										<p class="benefit">10%</p>
										<p class="text">인근회사 및 주민</p>
									</td>
								</tr>
								<tr>
									<td>
										<div class="partner_img"><img src="/front/img/common/no_image.png" alt=""></div>
										<p class="name">스테이트타워직원(명동)</p>
										<p class="benefit">10%</p>
										<p class="text">인근회사 및 주민 인근회사 및 주민 인근회사 및 주민 인근회사 및 주민 인근회사 및 주민</p>
									</td>
									<td>
										<div class="partner_img"><img src="/front/img/common/no_image.png" alt=""></div>
										<p class="name">스테이트타워직원(명동)</p>
										<p class="benefit">10%</p>
										<p class="text">인근회사 및 주민 인근회사 및 주민 인근회사 및 주민 인근회사 및 주민 인근회사 및 주민</p>
									</td>
								</tr>--%>
							</tbody>
						</table>
						<!--// 제휴업체 정보 추가 -->				
					</div>
				</div>
		</div>
	</div>



