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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">1:1문의</t:putAttribute>
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	var totalpage = ${resultListModel.getTotalPages()};
    	
        jQuery('#btn_id_insert').on('click', function(e) {
            location.href = "${_MOBILE_PATH}/front/customer/inquiry-insert-form?memberNo="+${so.memberNo};
        });

        //페이징
        //$('#div_id_paging').grid(jQuery('#form_id_search'));
        
        $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
     		var url = '${_MOBILE_PATH}/front/customer/inquiry-list-ajax?'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if(pageIndex == totalpage){
		        	$('#div_id_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('.qna_list').append(result);
	        })
         }); 
        
    });
    
    /*1:1 문의 삭제*/
    function deleteQuestion(lettNo, memberNo){
        Dmall.LayerUtil.confirm('1:1문의를 삭제하시겠습니까?', function() {
            var url = '${_MOBILE_PATH}/front/customer/inquiry-delete';
            var param = {'lettNo' : lettNo,'bbsId' : "inquiry", 'delrNo' : memberNo};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href = '${_MOBILE_PATH}/front/customer/inquiry-list';
                 }
            });
        })
    }
    
    </script>
    </t:putAttribute>
    
    <t:putAttribute name="content">
    
    <div id="middle_area">	
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			1:1 문의&답변
		</div>
		<div class="my_qna_top floatC">
			<ul class="my_shopping_info">
				<li>한번 등록한 상담내용은 수정이 불가능합니다.</li>
				<li>수정을 원하시는 경우, 삭제 후 재등록 하셔야 합니다.</li>
				<li>24시간 신청가능하며 접수된 내용은 빠른 시간 내에 답변을 드리도록 하겠습니다.</li>
			</ul>
			<button type="button" class="btn_qna floatR" id="btn_id_insert">1:1문의 신청하기</button>
		</div>
		<form:form id="form_id_search" commandName="so">
        <form:hidden path="page" id="page" />
		<ul class="qna_list">
			<c:choose>
            <c:when test="${resultListModel.resultList ne null}">
            <c:forEach var="inquiryList" items="${resultListModel.resultList}" varStatus="status">
            <c:if test="${inquiryList.lvl eq '0' || inquiryList.lvl eq null}" >
			<li>
				<ul class="qna_view">
					<li class="qna_view_title">
						<div class="qna_view_title_area">
							[${inquiryList.inquiryNm}] ${inquiryList.title}
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
							<%-- <c:if test="${inquiryList.replyStatusYn != 'Y'}" >
                                <div class="view_btn_area">
                                    <button type="button" class="" onclick="deleteQuestion('${inquiryList.lettNo}', '${inquiryList.regrNo}');"><span class="answerLR">삭제</span></button>
                                </div>
                            </c:if> --%>	
						</div>
						<!--// 질문 -->
						<!-- 답변 -->
						<c:if test="${inquiryList.replyStatusYn == 'Y'}" >
							<c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
							<c:if test="${inquiryList.lettNo eq replyList.grpNo}">
								<div class="qna_answer_text">
									${replyList.title}<br>
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
			</c:if>
            </c:forEach>
            </c:when>
            <c:otherwise>
            	<li><ul class="qna_view"><li style="text-align:center">데이터가 없습니다.</li></ul></li>
            </c:otherwise>
        </c:choose>
		</ul>
		<!---- 페이징 ---->
        <div class="tPages" id="div_id_paging">
            <grid:paging resultListModel="${resultListModel}" />
        </div>
        <!----// 페이징 ---->
        </form:form>
	</div>	
    
    </t:putAttribute>
</t:insertDefinition>