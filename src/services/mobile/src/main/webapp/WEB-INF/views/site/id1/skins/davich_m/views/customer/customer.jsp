<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<jsp:useBean id="now" class="java.util.Date"/>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">고객센터</t:putAttribute>
	
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        
    	//FAQ 더보기
        $('#best_qna5').on('click', function(e) {
            location.href = "${_MOBILE_PATH}/front/customer/faq-list";
        });
         
         //FAQ 검색
         $('#btn_qna_search').on('click', function() {
             var searchVal = $("#qna_search").val();
             var param = {searchVal : searchVal, faqGbCd:'', searchKind:'customerMain'};
             var url = "${_MOBILE_PATH}/front/customer/faq-list";
             Dmall.FormUtil.submit(url, param)
         });

        //공지사항 더보기
        $('#notice_more').on('click', function(e) {
            location.href = "${_MOBILE_PATH}/front/customer/notice-list";
        });
        
        //나의문의 더보기
        $('#inquiry_more').on('click', function(e) {
            //location.href = "${_MOBILE_PATH}/front/customer/inquiry-list";
            var memberNo =  '${so.memberNo}';
	        if(memberNo == '' || memberNo == 0) {
	            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
	                function() {
	                    var returnUrl = "${_MOBILE_PATH}/front/customer/inquiry-list";
	                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
	                }
	            );
	        } else {
	        	location.href="${_MOBILE_PATH}/front/customer/inquiry-list?memberNo="+memberNo;
	        }
        });

		 //Q&A 더보기
        $('#qna_more').on('click', function(e) {
            location.href = "${_MOBILE_PATH}/front/customer/board-list?bbsId=qna";
        });
        
        /* 
        //FAQ 검색
        $('#btn_qna_search').on('click', function() {
            var searchVal = $("#qna_search").val();
            var param = {searchVal : searchVal}
            var url = "${_MOBILE_PATH}/front/customer/faq-list";
            Dmall.FormUtil.submit(url, param)
        });
         */
        
        $(".notice_view_text img").error(function() {
            $(".notice_view_text img").attr("src", "../img/product/product_200_200.gif");
        });
        
    });
    function viewFaq(idx){
        location.href = "${_MOBILE_PATH}/front/customer/faq-list?faqGbCd="+idx;
    }
    function viewNotice(idx){
        location.href="${_MOBILE_PATH}/front/customer/notice-detail?lettNo="+idx
    }
    
    function viewInquiryForm(){
    	var memberNo =  "${so.memberNo}";
        if(memberNo == '' || memberNo == 0) {
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                }
            );
        } else {
        	location.href="${_MOBILE_PATH}/front/customer/inquiry-insert-form?memberNo="+memberNo;
        }
    }
    
    //게시판 더보기
    function board_more(bbsId){
    	//var param = {bbsId : bbsId}
        //Dmall.FormUtil.submit('${_MOBILE_PATH}/front/customer/board-list', param);
    	location.href= "${_MOBILE_PATH}/front/customer/board-list?bbsId="+bbsId;
    }
    
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        
<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			고객센터
		</div>

		<div id="customer_content">

			<div class="customer_top">		
				<div class="text_area">
					<em>자주묻는질문 검색</em>으로 더 빠르게 궁금증을 해결해 보세요.
				</div>
				<div class="search_area">
					<input type="text" id="qna_search"><button type="button" class="btn_q_search" id="btn_qna_search">검색</button>
				</div>
			</div>

			<ul class="top_menu_list">
				<li>
					<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=287">
						안경테 구매가이드
					</a>
				</li>
				<li>
					<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=288">
						콘택트렌즈 구매가이드
					</a>
				</li>
				<li>
					<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=289">
						안경렌즈 구매가이드
					</a>
				</li>
				<li>
					<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=290">
						나의 시력 체크
					</a>
				</li>
				<li>
					<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=291">
						방문예약 안내
					</a>
				</li>
				<li>
					<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=292">
						할인권 사용방법
					</a>
				</li>
				<li>
					<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=293">
						비회원 주문조회
					</a>
				</li>
				<li>
					<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=294">
						마켓회원등급 포인트안내
					</a>
				</li>
			</ul>
			<!-- //top_menu_list -->
			<div class="customer_content_area">
				<h2 class="customer_stit">
					<span>자주묻는 질문</span>
					<button type="button" class="btn_event_more" id="best_qna5">전체보기</button>
				</h2>
				<ul class="notice_list">
					<input type="hidden" id="today">
					<c:forEach var="faqList" items="${faqList.resultList}" varStatus="status" begin="0" end="9">
					<li>
						<ul class="notice_view">
							<li class="notice_view_title">
							<span class="bar_tit">[${faqList.faqGbNm}]</span>
								${faqList.title}
								<div class="notice_date">
									<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
									<fmt:formatDate pattern="yyyy-MM-dd" value="${faqList.regDttm}" var="date" />
									<%-- ${date} --%>
								</div>
							</li>
							<li class="notice_view_text" style="display: none;">
								<p class="que_text_area">								
								${faqList.content}
								</p>
							  </li>
						</ul>
					</li>					
					</c:forEach>
				</ul>
			</div>
			
			<div class="customer_content_area">
				<h2 class="customer_stit">
					<span>공지사항</span>
					<button type="button" class="btn_event_more" id="notice_more">전체보기</button>
				</h2>
				<ul class="notice_list">
					<input type="hidden" id="today">
					<c:forEach var="resultModel" items="${noticeList.resultList}" varStatus="status" begin="0" end="4">
					<li>
						<ul class="notice_view">
							<li class="notice_view_title">
								<span class="bbs_ellipsis">${resultModel.title}</span>
								<div class="notice_date">
									<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
									<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
									${date}
								</div>
							</li>
							<li class="notice_view_text" style="display: none;">
								<p>
								<c:set value="${resultModel.content}" var="data"/>
								<c:set value="${fn:replace(data, cn, br)}" var="content"/>
								${content}
								</p>
							</li>
						</ul>
					</li>
					</c:forEach>					
				</ul>
			</div>
			<div class="customer_content_area">
				<h2 class="customer_stit">
					<span>1:1문의</span>
					<button type="button" class="btn_event_more" id="inquiry_more">전체보기</button>
				</h2>
				<ul class="notice_list">
					<input type="hidden" id="today">
					<c:forEach var="inquiryList" items="${inquiryList.resultList}" varStatus="status" begin="0" end="2">
					<li>
						<ul class="qna_view">
							<li class="qna_view_title">
								<div class="qna_view_title_area">
									<span class="product_tit">[${inquiryList.inquiryNm}]</span> ${inquiryList.title}
								</div>
								<span class="qna_time"><fmt:formatDate pattern="yyyy-MM-dd" value="${inquiryList.regDttm}" /></span>
								<div class="qna_check">
									<c:if test="${inquiryList.replyStatusYn == 'Y'}" ><span class="answerLB">답변완료</span></c:if>
									<c:if test="${inquiryList.replyStatusYn != 'Y'}" ><span class="answerLR">답변대기</span></c:if>
								</div>
							</li>
							<li class="qna_view_text">
								<!-- 질문 -->
								<div class="qna_question_text">
									<c:set value="${inquiryList.content}" var="data"/>
									<c:set value="${fn:replace(data, cn, br)}" var="content"/>
									${content}<br>
									<%-- ${inquiryList.content} --%>
									<c:if test="${inquiryList.replyStatusYn != 'Y'}" >
		                                <div class="view_btn_area">
		                                    <button type="button" class="btn_delete" onclick="deleteQuestion('${inquiryList.lettNo}', '${inquiryList.regrNo}');">삭제</button>
		                                </div>
		                            </c:if>
								</div>
								<!--// 질문 -->
								<!-- 답변 -->
								<c:if test="${inquiryList.replyStatusYn == 'Y'}" >
									<c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
									<c:if test="${inquiryList.lettNo eq replyList.grpNo}">
										<div class="qna_answer_text">
											<span class="title">${replyList.title}</span>
											<c:set value="${replyList.content}" var="rdata"/>
											<c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
											${rcontent}
											<%-- ${replyList.content} --%>
										</div>
									</c:if>
								</c:forEach>
								</c:if>
								<!--// 답변 -->							
							</li>						
						</ul>
					</li>
					</c:forEach>		
				</ul>
			</div>
			<!-- <div class="customer_content_area">
				<h2 class="customer_stit">
					<span>Q&A</span>
					<button type="button" class="btn_event_more" id="qna_more">전체보기</button>
				</h2>
			</div> -->
			<!-- //customer_content_area -->
			
			
			<c:forEach var="menuList" items="${leftMenu.resultList}" varStatus="status">
				<c:if test="${menuList.bbsId ne 'faq' and menuList.bbsId ne 'inquiry' and menuList.bbsId ne 'notice'}">
					<div class="customer_content_area">
						<h2 class="customer_stit">
							<span>${menuList.bbsNm}</span>
							<a href="javascript:board_more('${menuList.bbsId}');"><button type="button" class="btn_event_more">전체보기</button></a>
						</h2>
						<ul class="notice_list">
							<input type="hidden" id="today">
							<c:set value="${menuList.bbsId}List" var="bbsList"/>
							<c:forEach var="resultModel" items="${requestScope[bbsList].resultList}" varStatus="status" begin="0" end="4">
							<li>
								<ul class="notice_view">
									<li class="notice_view_title">
										${resultModel.title}
										<div class="notice_date">
											<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
											<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
											${date}
										</div>
									</li>
									<li class="notice_view_text" style="display: none;">
										<p>
										<c:set value="${resultModel.content}" var="data"/>
										<c:set value="${fn:replace(data, cn, br)}" var="content"/>
										${content}
										</p>
									</li>
								</ul>
							</li>
							</c:forEach>					
						</ul>
					</div>
				</c:if>
			</c:forEach>
			
			
		</div><!-- //customer_content -->
        
    </t:putAttribute>
</t:insertDefinition>