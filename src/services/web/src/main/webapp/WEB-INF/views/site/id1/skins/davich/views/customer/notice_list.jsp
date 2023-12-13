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
	<t:putAttribute name="title">다비치마켓 :: 공지사항</t:putAttribute>


	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	// System.out.println('aaa');
    	   
    	
        var searchKind = '${so.searchKind}';
        if(searchKind !='') {
            $("#searchKind").val(searchKind);
            $("#searchKind").trigger("change");
        }

        //검색
        $('#btn_list_search').on('click', function() {
           /*   alert(searchKind); */ 
        	searchNotice();
        });

        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));
    });
    function searchNotice(){
        var data = $('#form_id_search').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
            param[obj.name] = obj.value;
        });
        Dmall.FormUtil.submit('/front/customer/notice-list', param);

    }
    //글 상세 보기
    function goBbsDtl(lettNo) {
    	location.href="/front/customer/notice-detail?lettNo="+lettNo;      
    }
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
	<!--- category header 카테고리 location과 동일 --->
    <div id="category_header">
        <div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>고객센터</li>
				<li>공지사항</li>
			</ul>
            <!-- <span class="location_bar"></span><a>홈</a><span>&gt;</span><a>고객센터</a><span>&gt;</span>공지사항 -->
        </div>
    </div>
    <!---// category header --->
    <!--- 18.07.09 공지사항  --->
    <!--- contents --->
    <div class="customer_middle">	
		<!-- snb -->
		<%@ include file="include/customer_left_menu.jsp" %> 	
		<!-- //snb -->
		
		<!-- content -->
		<div id="customer_content">
			<div class="customer_top_line"></div>
			<div class="customer_body">
				<h3 class="my_tit">
					공지사항
						
                   <form id="form_id_search" action="/front/customer/notice-list" method="post">
                    <!-- <label for="searchKind">전체</label>	 -->                   					
					<div class="search_notice_area" >						    
						<select id="searchKind" title="select option" name="searchKind">
	                            <option value="all">전체</option>
	                            <option value="searchBbsLettTitle">제목</option>
	                            <option value="searchBbsLettContent">내용</option>
						</select>							
						 <div class="my_list_search">
							<input type="text" class="form_search"  name="searchVal" id="searchVal" value="${so.searchVal}"> <button type="" class="btn_list_search" id="btn_list_search">검색</button> 
						</div>
					</div> 			                    		
               </h3>
				<table class="tProduct_Board notice">
					<caption>
						<h1 class="blind">공지사항 게시판 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="">
						<col style="width:128px">
					</colgroup>
					<thead>
						<tr>
							<th>제목</th>
							<th>등록일</th>
						</tr>
					</thead>
					<tbody>
					
						<c:choose>
                            <c:when test="${resultListModel.resultList ne null}">
                              <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                              <tr>
                                 <%--  <td class="textL">
                                  ${resultModel.rowNum}
                                  </td>
                                  <c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                                  <td>${resultModel.titleNm}</td>
                                  </c:if> --%>
                                  <td class="textL">
                                      <a href="javascript:goBbsDtl('${resultModel.lettNo}')">${resultModel.title}</a>
                                  </td>
                                  <%-- <td class="textC">${resultModel.memberNm}</td> --%>
                                  <td class="textL">
                                      <fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" />
                                     <%--  </br><fmt:formatDate pattern="aa hh:mm:ss" value="${resultModel.regDttm}" /> --%>
                                  </td>
                              </tr>
                              </c:forEach>
                            </c:when>
                           
                        </c:choose>
                       
                    </tbody>
					<%-- <tbody>
						<tr>
							<td class="textL">
								<i class="icon_notice"></i><a href="#">일부품목 가격인하 안내</a><span class="icon_new"></span><span class="icon_hot"></span>
							</td>
							<td>2017.05.31</td>
						</tr>
					
					</tbody> --%>
				</table>
				<!-- pageing -->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                
				<!--// pageing -->
			</div>
		</div>		
		<!--// content -->
	</div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>