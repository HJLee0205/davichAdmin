<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="그리드 페이징" trimDirectiveWhitespaces="true" %>
<%--<%@ attribute name="currentPage" required="true" description="현재 페이지 번호" type="java.lang.Integer" %>--%>
<%--<%@ attribute name="totalPage" required="true" description="전체 페이지 수" type="java.lang.Integer" %>--%>
<%--<%@ attribute name="totalCount" required="true" description="전체 데이터 수" type="java.lang.Integer" %>--%>
<%@ attribute name="resultListModel" required="true" description="ResultListModel" type="dmall.framework.common.model.ResultListModel" %>
<%@ attribute name="id" required="false" description="전체 페이징 div의 ID" type="java.lang.String" %>
<%
    if(resultListModel == null) return;

    int currPageDiv = resultListModel.getPage() / 10 + 1;
    int firstOfPage = (currPageDiv - 1) * 10 + 1;
    int lastPage = Math.min(currPageDiv * 10, resultListModel.getTotalPages());
    String idStr = id != null ? " id=\"" + id + "\"" : "";
%>
<!-- pageing -->
<%-- <ul class="pages"<%= idStr %>>
    <% if (currPageDiv > 1) { %>
    <!-- <li><a href="#none" class="strpre ico_comm" data-page="1">맨앞으로</a></li> -->
    <li class="prev"><a href="#none" class="pre ico_comm" data-page="<%= firstOfPage - 1 %>"><span><img src="../img/common/btn_prev.gif" alt="이전페이지로 이동"></span></a></li>
    <%
        }
        for(int i = firstOfPage; i <= lastPage; i++) {
            if(resultListModel.getPage() == i) {
    %>
    <li class="active"><span><%= i %></span></li>
    <%
            } else{
    %>
    <li><a href="#none" class="num" data-page="<%= i %>"><%= i %></a></li>
    <%
            }
        }
        if (resultListModel.getTotalPages() > currPageDiv * 10) {
    %>
    <li class="next"><a href="#none" class="nex ico_comm" data-page="<%= lastPage + 1 %>"><img src="../img/common/btn_next.png" alt="다음페이지로 이동"></a></li>
    <a href="#none" class="endnex ico_comm" data-page="<%= resultListModel.getTotalPages() %>">맨끝으로</a>
    <% } %>
</ul> --%>
<!-- //pageing -->

<div class="my_list_bottom"<%= idStr %> style="margin-top:-1px">
	<% if (resultListModel.getTotalPages()  > 1) { %>
	<button type="button" class="btn_all_view more_view" data-page="<%= currPageDiv %>"><em>더</em>보기</button>
	<%--<a href="#none" class="more_view" data-page="<%= currPageDiv %>">
		 더보기<span class="icon_more_view"></span>
	</a>--%>
	 <%
            } 
    %>		
	<%--<div class="list_page_view" <%=resultListModel.getTotalPages()>1?"":"style='width:100%'" %>>
		<em><%= currPageDiv %></em> / <%=resultListModel.getTotalPages() %>
	</div>--%>
</div>
