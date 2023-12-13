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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">1:1 문의</t:putAttribute>
	
	<t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
    	//FAQ 검색
	    $('#btn_qna_search').on('click', function() {
	        var searchVal = $("#qna_search").val();
	        var param = {searchVal : searchVal, faqGbCd:'', searchKind:'customerMain'};
	        var url = "${_MOBILE_PATH}/front/customer/faq-list";
	        Dmall.FormUtil.submit(url, param)
	    });
        // 게시글 등록 함수
        jQuery('#insertInquiry').on('click', function(e) {
            if(jQuery('#inquiryCd').val() == 0){
                Dmall.LayerUtil.alert("문의유형을 선택해주세요.");
                return;
            }
            if(jQuery('#title').val() == ""){
                Dmall.LayerUtil.alert("제목을 입력해주세요.");
                return;
            }
            if(jQuery('#content').val() == ""){
                Dmall.LayerUtil.alert("문의글 내용을 입력해주세요.");
                return;
            }
            var url = '${_MOBILE_PATH}/front/customer/inquiry-insert';
            var param = $('#insertForm').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if (result.success) {
                    location.href = "${_MOBILE_PATH}/front/customer/inquiry-list";
                }
            })
        });
    });
    </script>
	</t:putAttribute>
	
    <t:putAttribute name="content">
    <!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<form action="" id="insertForm">
		<input type="hidden" style="width:calc(100% - 14px)" value="${resultModel.data.memberNm}" disabled="disabled">
		<input type="hidden" style="width:calc(100% - 14px)" value="${resultModel.data.mobile}" disabled="disabled">
		<input type="hidden" style="width:calc(100% - 14px)" value="${resultModel.data.email}" disabled="disabled">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			1:1문의
		</div>

		<div class="customer_top">		
			<div class="text_area">
				<em>자주묻는질문 검색</em>으로 더 빠르게 궁금증을 해결해 보세요.
			</div>
			<div class="search_area">
				<input type="text" id="qna_search"><button type="button" class="btn_q_search" id="btn_qna_search">검색</button>
			</div>
		</div>

		<h2 class="customer_stit02"><span>질문 등록</span></h2>
		<span class="icon_purpose">문의하신 내용에 대한 답변은 <b>마이페이지 &gt; 나의 활동 &gt; 문의/후기</b> 메뉴에서 확인하실 수 있습니다.</span>

		<ul class="qna_write_list">
			<li class="form">
				<span class="title">구분</span>
				<p class="detail">
					<select title="select option" id="inquiryCd" name="inquiryCd">
						  <code:option codeGrp="INQUIRY_CD"  />
					</select>
				</p>
			</li>
			<li class="form">
				<span class="title">제목</span>
				<p class="detail"><input type="text" name="title" id="title" placeholder="제목을 입력해주세요"></p>
			</li>
			<li class="form">
				<span class="title">내용</span>
				<p class="detail"><textarea style="width:calc(100% - 14px);height:80px" name="content" id="content" placeholder="문의 내용을 남겨주세요."></textarea></p>
			</li>
		</ul>

		</form>
		<div class="qna_btn_area">
			<button class="btn_qna_ok" id="insertInquiry">등록</button>
		</div>
	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
    
    </t:putAttribute>
</t:insertDefinition>