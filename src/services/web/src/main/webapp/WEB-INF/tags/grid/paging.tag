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
%>

<ul <%= idStr %>>
    <% if (currPageDiv > 1) { %>
    <li class="prev"><a href="javascript:;" class="strpre" data-page="1"><img src="${_SKIN_IMG_PATH}/common/go_prev22.png" alt="맨앞으로"></a></li>
    <li class="prev"><a href="javascript:;" class="pre" data-page="<%= firstOfPage - 1 %>"><img src="${_SKIN_IMG_PATH}/common/go_prev.png" alt="이전으로"></a></li>
    <%
        }
        for(int i = firstOfPage; i <= lastPage; i++) {
            if(resultListModel.getPage() == i) {
    %>
    <li class="active"><%= i %></li>
    <%
            } else{
    %>
    <li><a href="javascript:;" class="num" data-page="<%= i %>"><%= i %></a></li>
    <%
            }
        }
        if (resultListModel.getTotalPages() > currPageDiv * 10) {
    %>
    <li class="next"><a href="javascript:;" class="nex" data-page="<%= lastPage + 1 %>"><img src="${_SKIN_IMG_PATH}/common/go_next.png" alt="다음페이지로 이동"></a></li>
    <li class="next"><a href="javascript:;" class="endnex" data-page="<%= resultListModel.getTotalPages() %>"><img src="${_SKIN_IMG_PATH}/common/go_next22.png" alt="맨끝으로"></a></li>
    <% } %>
</ul>

