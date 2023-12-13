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
	<t:putAttribute name="title">반품신청정보</t:putAttribute>
	<t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
	<t:putAttribute name="script">
    <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
    <style>
/*     	#tx_trex_containerclaimDtlReason {display: none;} */
    </style>
	<script type="text/javascript">
    jQuery(document).ready(function() {
    	fn_loadEditor();
    	
//     	setTimeout(setHtmlToDiv, 500);	// 에디터에 세팅 되는게 setTimeout 50이 걸려있다. 이것보다 뒤로..
    });
    
    function fn_loadEditor() {
        
        Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
        Dmall.DaumEditor.create('claimDtlReason'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
        
        var content = "${claimGoodsVo.claimDtlReason}";
        if(content != null){
        	console.log(Dmall.DaumEditor.initializedCnt);
        	Dmall.DaumEditor.setContent('claimDtlReason', content); // 에디터에 데이터 세팅
        }
    }
    
    /*
    function setHtmlToDiv() {
    	var html =  Dmall.DaumEditor.getContent("claimDtlReason");
    	html = html.replaceAll("<script", "&lt;script");
    	$("#claimDtlReasonView").html(html);
    }
    */
    
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
			<h2 class="tlth2">반품신청정보</h2>
			<a href="javascript:closePop();" class="close ico_comm">닫기</a>
		</div>
		<div class="pop_wrap">
			<form id="refund_chk_form" >
			<input type="hidden" name="claimNo" value="${claimGoodsVo.claimNo }">
			<input type="hidden" name="ordNo" value="${claimGoodsVo.ordNo }">
			<input type="hidden" name="ordDtlSeq" value="${claimGoodsVo.ordDtlSeq }">
			
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
						<td>${claimGoodsVo.goodsNm }</td>
					</tr>
					<tr>
						<th>옵션</th>
						<td>${claimGoodsVo.itemNm }</td>
					</tr>
					<tr>
						<th>반품사유</th>
						<td>${claimGoodsVo.claimReasonNm }</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<textarea id="claimDtlReason" name="claimContentChk" class="blind"></textarea>
<!-- 							<div id="claimDtlReasonView" style=" width: 785px; height: 480px;"></div> -->
						</td>
					</tr>
				</tbody>
			</table>
			</form>
			<div class="popup_btn_area">
				<button type="button" class="btn_popup_cancel" onClick="javascript:closePop();">닫기</button>
			</div>
		</div>
	</div>
    </t:putAttribute>
</t:insertDefinition>