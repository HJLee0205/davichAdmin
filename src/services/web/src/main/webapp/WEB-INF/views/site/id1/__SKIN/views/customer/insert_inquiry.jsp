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
	<t:putAttribute name="title">다비치마켓 :: 1:1문의</t:putAttribute>


	<t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
        //FAQ 검색
        $('#btn_qna_search').on('click', function() {
            var searchVal = $("#qna_search").val();
            var param = {searchVal : searchVal, faqGbCd:'', searchKind:'customerMain'};
            var url = "/front/customer/faq-list";
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
            var url = '/front/customer/inquiry-insert';
            var param = $('#insertForm').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if (result.success) {
                    location.href = "/front/customer/inquiry-list";
                }
            })
        });
    });
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- category header 카테고리 location과 동일 --->
    <div id="category_header">
        <div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>고객센터</li>
				<li>1:1문의</li>
			</ul>
            <!-- <span class="location_bar"></span><a>홈</a><span>&gt;</span><a>고객센터</a><span>&gt;</span>1:1문의 -->
        </div>
    </div>
    <!---// category header --->
    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="customer_middle">	
		<!-- snb -->
		<%@ include file="include/customer_left_menu.jsp" %>
		<!--// snb -->

		<!-- content -->
		<div id="customer_content">
			<div class="customer_top">		
				<div class="text_area">
					<em>자주묻는질문 검색</em>으로<br>
					더 빠르게 궁금증을 해결해 보세요.
				</div>
				<div class="search_area">
					<input type="text" id="qna_search"><button type="button" class="btn_q_search" id="btn_qna_search">검색</button>
				</div>
			</div>
			<div class="customer_body">
				<h3 class="my_tit">문의하기</h3>
				<h4 class="my_stit">
					질문등록
					<span class="icon_purpose">문의하신 내용에 대한 답변은 <b>마이페이지 > 나의 활동 > 문의/후기</b> 메뉴에서 확인하실 수 있습니다.</span>
				</h4>
				<form action="/front/customer/inquiry-insert" id="insertForm" >
				<table class="tQuestion_Insert">
					<caption>
						<h1 class="blind">상품문의 게시판 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:128px">
						<col style="">
					</colgroup>
					<tbody>
						<tr>
							<th>구분</th>
							<td>
								<select title="select option" id="inquiryCd" name="inquiryCd">
                                	<code:option codeGrp="INQUIRY_CD"  />
                                </select>
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input type="text" class="form_title" name="title" id="title"></td>
						</tr>
						<tr>
							<th>내용</th>
							<td><textarea class="form_text" name="content" id="content"></textarea></td>
						</tr>
					</tbody>
				</table>
				</form>
				<div class="btn_que_area">
					<button type="button" class="btn_go_okay" id="insertInquiry">등록</button>
				</div>
			</div>
		</div>		
		<!--// content -->
	</div>
    <!---// 02.LAYOUT: 마이페이지 --->	   
    </t:putAttribute>
</t:insertDefinition>