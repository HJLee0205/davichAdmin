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
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<jsp:useBean id="now" class="java.util.Date"/>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">공지사항</t:putAttribute>
	
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        var searchKind = '${so.searchKind}';
        if(searchKind !='') {
            $("#searchKind").val(searchKind);
            $("#searchKind").trigger("change");
        }

        //검색
        $('#btn_id_search').on('click', function() {
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/customer/notice-list', param);
        });

         $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
     		var url = '${_MOBILE_PATH}/front/customer/notice-list-ajax?'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if('${so.totalPageCount}'==pageIndex){
		        	$('#div_id_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('#view01 .notice_view_list').append(result);
	        })
         }); 
        
         $(".notice_view_text img").error(function() {
             $(".notice_view_text img").attr("src", "../img/product/product_200_200.gif");
         });
         
         resizeImg();
    });
    
    //글 상세 보기
    function goBbsDtl(lettNo) {
        location.href="${_MOBILE_PATH}/front/customer/notice-detail?lettNo="+lettNo;
    }
    
  ///이미지 리사이즈
    function resizeImg(){
        var innerBody;
        innerBody =  $('.notice_view_text');
        $(innerBody).find('img').each(function(i){
            var imgWidth = $(this).width();
            var imgHeight = $(this).height();
            var resizeWidth = $(innerBody).width();
            var resizeHeight = resizeWidth / imgWidth * imgHeight;

            $(this).css("max-width", "90%");

            $(this).css("width", resizeWidth);
            $(this).css("height", resizeHeight);

        });
    }
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    
    <!--- contents --->
    <div class="contents">
        <!--- category header 카테고리 location과 동일 --->        
         <div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			공지사항
		</div>	
		<!-- <h2 class="customer_stit">
			<span>공지사항</span>
		</h2> -->
        
        <div class="customer">
            <!--- 고객센터 컨텐츠 --->
            <div class="customer_content" id="view01">
                <form id="form_id_search" action="${_MOBILE_PATH}/front/customer/notice-list">
                <input type="hidden" name="page" id="page" value="1" />
                <%-- <form:form id="form_id_search" commandName="so">
       			<form:hidden path="page" id="page" /> --%>
                
                <ul class="notice_view_list">
                	<c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
					<li>
						<ul class="notice_view">
							<li class="notice_view_title">
								<span class="bbs_ellipsis"><c:if test="${resultModel.noticeYn == 'Y'}">[공지]</c:if>
								${resultModel.title}
								<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
								<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
								<c:if test="${date eq today}"><span class="notice_view_new">NEW</span></c:if>
								</span>
								<div class="notice_date">
									<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" />
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

                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                <!----// 페이징 ---->
                </form>
            </div>
            <!---// 고객센터 컨텐츠 --->
        </div>
    </div>
    <!---// contents --->
    
	</t:putAttribute>
</t:insertDefinition>