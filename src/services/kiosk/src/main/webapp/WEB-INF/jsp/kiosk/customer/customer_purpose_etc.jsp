<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_confirm(){	
	document.kioskForm.action="/kiosk/customerFirstInfo.do";
	document.kioskForm.submit();
}

function fn_back(){	
	document.kioskForm.action="/kiosk/customerPurpose.do";
	document.kioskForm.submit();
}

function fn_set_purpose_etc(v_purpose_etc){
	$('#purpose_etc').val(v_purpose_etc);
	fn_confirm();
}
</script>
<input type="hidden" name="mobile" id="mobile" value="${customerVO.mobile}">
<input type="hidden" name="member_nm" id="member_nm" value="${customerVO.member_nm}">
<input type="hidden" name="cd_cust" id="cd_cust" value="${customerVO.cd_cust}">
<input type="hidden" name="purpose" id="purpose" value="${customerVO.purpose}">
<input type="hidden" name="purpose_no" id="purpose_no" value="${customerVO.purpose_no}">
<input type="hidden" name="purpose_etc" id="purpose_etc" value="">
<div id="wrap">
	<div id="content_wrap">
		<div class="content">
			<div class="comment_check">
				<i></i> ${customerVO.purpose}
			</div>
			<c:if test="${customerVO.purpose_no == 1 ||
						customerVO.purpose_no == 2 ||
						customerVO.purpose_no == 3 ||
						customerVO.purpose_no == 4 }">
			<div class="comment_box">
				<br>다음 중 선택해 주세요.<br><br>
			</div>
			</c:if>
			<c:if test="${customerVO.purpose_no == 1}">
			<div class="select_btn_wrap">
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('시력검사 필요')">시력검사 필요 <span style="color: red; font-weight: bold;">(추천)</span> </button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('기존 안경과 같은 도수')">기존 안경과 같은 도수</button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('도수 필요 없음')">도수 필요 없음</button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('안과 처방')">안과 처방</button>
			</div>
			</c:if>
			<c:if test="${customerVO.purpose_no == 2}">
			<div class="select_btn_wrap">
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('시력검사 필요')">시력검사 필요 <span style="color: red; font-weight: bold;">(추천)</span> </button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('구매할 도수 알고 있음')">구매할 도수 알고 있음</button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('도수 필요 없음')">도수 필요 없음</button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('안과 처방')">안과 처방</button>
			</div>
			</c:if>
			<c:if test="${customerVO.purpose_no == 3}">
			<div class="select_btn_wrap">
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('도수 필요 없음')">도수 필요 없음</button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('시력교정 선글라스 (사용중인 안경 있음)')">시력교정 선글라스 (사용중인 안경 있음)</button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('시력교정 선글라스 (시력검사 필요)')">시력교정 선글라스 (시력검사 필요)</button>
			</div>
			</c:if>
			<c:if test="${customerVO.purpose_no == 4}">
			<div class="select_btn_wrap">
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('코받침 등 부속 교체')">코받침 등 부속 교체</button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('단순 피팅')">단순 피팅</button>
				<button type="button" class="select_btn03" onclick="fn_set_purpose_etc('안경테 부러짐')">안경테 부러짐</button>
			</div>
			</c:if>
		</div><!-- //content -->
		<div class="comment_btn_area">
			<button type="button" class="btn_cancel floatL" onclick="fn_back()"><i></i>이전</button>
			<button type="button" class="btn_confirm floatR" onclick="fn_confirm()">다음<i></i></button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->