<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="popupLayout">
	<t:putAttribute name="title">물류 반품 체크</t:putAttribute>
	<t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
	<t:putAttribute name="script">
    <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
    jQuery(document).ready(function() {
    	// 에디터 셋팅
    	fn_loadEditor();
    	
    	$('#btn_confirm').click(function(e){
            Dmall.EventUtil.stopAnchorAction(e);
            
           	Dmall.DaumEditor.setValueToTextarea('ta_content');  // 에디터에서 폼으로 데이터 세팅

			var url = '/admin/order/refund/refund-check-update',
				param = jQuery('#refund_chk_form').serialize();
                
			Dmall.AjaxUtil.getJSON(url, param, function(result) {
				Dmall.validate.viewExceptionMessage(result, 'form_term_info');
                
                if (result == null || result.success != true) {
                    return;
                } else {
                    alert("처리되었습니다.");
                }
            });
            return false;                
        });
    });
    
    function fn_loadEditor() {
        var siteinfocd = $("#hid_siteInfoCd").val();
        
        Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
        Dmall.DaumEditor.create('ta_content'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
        
        var content = "${claimVO.claimContentChk}";
        if(content != null){
        	Dmall.DaumEditor.setContent('ta_content', content); // 에디터에 데이터 세팅
        }
    }
    
    function closePop() {
    	var erpYn = "${erpYn}";	
    	console.log(erpYn)
    	if(erpYn == "Y"){
    		location.href="/admin/order/refund/closePop";	
    	}else{
    		window.close();
    	}
    }
    
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<div id="layout1" class="layer_popup" style="display:block;">
		<div class="pop_tlt">
			<h2 class="tlth2">물류 반품 체크</h2>
			<a href="javascript:closePop();" class="close ico_comm">닫기</a>
		</div>
		<div class="pop_wrap">
			<form id="refund_chk_form" >
			<input type="hidden" name="claimNo" value="${claimVO.claimNo }">
			<input type="hidden" name="ordNo" value="${claimVO.ordNo }">
			<input type="hidden" name="ordDtlSeq" value="${claimVO.ordDtlSeq }">
			
			<table class="tProduct_Insert" style="margin-top:5px">
				<caption>
				</caption>
				<colgroup>
					<col style="width:20%">
					<col style="width:">
				</colgroup>
				<tbody>
					<tr>
						<th>상품명</th>
						<td>${claimVO.goodsNm }</td>
					</tr>
					<tr>
						<th>옵션</th>
						<td>${claimVO.itemNm }</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<textarea id="ta_content" name="claimContentChk" class="blind"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
			</form>
			<div class="popup_btn_area">
				<button type="button" class="btn_popup_ok" id="btn_confirm">저장</button>
				<button type="button" class="btn_popup_cancel" onClick="javascript:closePop();">닫기</button>
			</div>
		</div>
	</div>
    </t:putAttribute>
</t:insertDefinition>