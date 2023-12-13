<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="그리드 페이징" trimDirectiveWhitespaces="true" %>
<%--<%@ attribute name="currentPage" required="true" description="현재 페이지 번호" type="java.lang.Integer" %>--%>
<%--<%@ attribute name="totalPage" required="true" description="전체 페이지 수" type="java.lang.Integer" %>--%>
<%--<%@ attribute name="totalCount" required="true" description="전체 데이터 수" type="java.lang.Integer" %>--%>
<%@ attribute name="resultListModel" required="true" description="ResultListModel" type="dmall.framework.common.model.ResultListModel" %>
<%@ attribute name="id" required="false" description="전체 페이징 div의 ID" type="java.lang.String" %>
<%
    if(resultListModel == null) return;

    int currPageDiv = (resultListModel.getPage() - 1) / 10 + 1;
    int firstOfPage = (currPageDiv - 1) * 10 + 1;
    int lastPage = Math.min(currPageDiv * 10, resultListModel.getTotalPages());
    String idStr = id != null ? " id=\"" + id + "\"" : "";
    String on;
%>
<!-- pageing -->
<div class="pageing"<%= idStr %>>
    <% if (currPageDiv > 1) { %>
    <a href="#none" class="strpre ico_comm" data-page="1">맨앞으로</a>
    <a href="#none" class="pre ico_comm" data-page="<%= firstOfPage - 1 %>">이전</a>
    <%
        }
        for(int i = firstOfPage; i <= lastPage; i++) {
            on = resultListModel.getPage() == i ? " on" : "";
    %>
    <a href="#none" class="num<%= on %>" data-page="<%= i %>"><%= i %></a>
    <%
        }
        if (resultListModel.getTotalPages() > currPageDiv * 10) {
    %>
    <a href="#none" class="nex ico_comm" data-page="<%= lastPage + 1 %>">다음</a>
    <a href="#none" class="endnex ico_comm" data-page="<%= resultListModel.getTotalPages() %>">맨끝으로</a>
    <% } %>
</div>
<!-- //pageing -->
