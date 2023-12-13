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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">고객센터</t:putAttribute>
	
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        /* 
    	//FAQ 더보기
        $('#best_qna5').on('click', function(e) {
            location.href = "${_MOBILE_PATH}/front/customer/faq-list";
        });
         */
         
        //공지사항 더보기
        $('#notice_more').on('click', function(e) {
            location.href = "${_MOBILE_PATH}/front/customer/notice-list";
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
    
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        
    <!--- 01.LAYOUT:CONTAINER --->
	
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
		<div class="event_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			고객센터
		</div>
		<ul class="customer_smenu">
			<li>
				<a href="${_MOBILE_PATH}/front/customer/faq-list">
					<span class="icon_customer_smenu01"></span>
					자주찾는 질문 FAQ
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/customer/notice-list">
					<span class="icon_customer_smenu02"></span>
					공지사항
				</a>
			</li>
			<li>
				<a href="javascript:viewInquiryForm();">
					<span class="icon_customer_smenu03"></span>
					1:1문의/답변
				</a>
			</li>
		</ul>
		<div class="customer_content_area">
			<h2 class="customer_stit">
				<span>공지사항</span>
				<button type="button" class="btn_event_more" id="notice_more">MORE</button>
			</h2>
			<ul class="notice_list">
				<input type="hidden" id="today">
				<c:forEach var="resultModel" items="${noticeList.resultList}" varStatus="status" begin="0" end="4">
				<li>
					<ul class="notice_view">
						<li class="notice_view_title">
							${resultModel.title}
							<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
							<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
							<c:if test="${date eq today}"><span class="notice_view_new">NEW</span></c:if>
							<div class="notice_date">
								${date}
							</div>
						</li>
						<li class="notice_view_text">
							<c:set value="${resultModel.content}" var="data"/>
							<c:set value="${fn:replace(data, cn, br)}" var="content"/>
							${content}
							<%-- ${resultModel.content} --%>
						</li>
					</ul>
				</li>
				</c:forEach>
			</ul>
		</div>
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->
	
<!---// 01.LAYOUT:CONTAINER --->
        
    </t:putAttribute>
</t:insertDefinition>