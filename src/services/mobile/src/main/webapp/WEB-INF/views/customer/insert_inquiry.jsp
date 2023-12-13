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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">1:1 문의</t:putAttribute>
	
	<t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
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
    
    <div id="middle_area">	
		<div class="event_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			고객센터
		</div>	
		<h2 class="customer_stit">
			<span>1:1문의/답변</span>
		</h2>
		
		<form action="" id="insertForm">
		<ul class="qna_write_list">
			<li class="form">
				<span class="title">문의유형</span>
				<p class="detail">
					<select class="select_option" title="select option" id="inquiryCd" name="inquiryCd">
                        <code:option codeGrp="INQUIRY_CD"  />
                    </select>
				</p>
			</li>
			<li class="form">
				<span class="title">제목</span>
				<p class="detail">
					<input type="text" name="title" id="title" style="width:calc(100% - 14px)" placeholder="제목을 입력해주세요">
				</p>
			</li>
			<li class="form">
				<span class="title">내용</span>
				<p class="detail">
					<textarea style="width:calc(100% - 14px);height:80px" name="content" id="content" placeholder="주문상품을 선택 후 문의 내용을 남겨주세요."></textarea>
				</p>
			</li>
			<li class="form">
				<span class="title">고객명</span>
				<p class="detail">
					<input type="text" style="width:calc(100% - 14px)" value="${resultModel.data.memberNm}" disabled="disabled">
				</p>
			</li>
			<li class="form">
				<span class="title">휴대폰</span>
				<p class="detail">
					<input type="text" style="width:calc(100% - 14px)" value="${resultModel.data.mobile}" disabled="disabled">
				</p>
			</li>
			<li class="form">
				<span class="title">이메일</span>
				<p class="detail">
					<input type="text" style="width:calc(100% - 14px)" value="${resultModel.data.email}" disabled="disabled">
				</p>
			</li>
			<!-- <li class="checkbox_area">
				<div class="checkbox" style="margin-top:10px">			
					<label>
						<input type="checkbox" name="select_order">
						<span></span>
					</label>
					휴대폰으로 답변 알림메시지 받기
				</div>
			</li> -->
		</ul>
		</form>
		
		<div class="qna_btn_area">
			<button type="button" class="btn_qna_ok" id="insertInquiry">문의등록</button>
		</div>
	</div>	
    
    </t:putAttribute>
</t:insertDefinition>