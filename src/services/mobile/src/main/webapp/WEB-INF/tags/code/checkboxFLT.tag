<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="공통코드를 이용한 체크박스" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag import="java.util.List" %>
<%@ tag import="net.danvi.dmall.biz.system.util.ServiceUtil" %>
<%@ tag import="net.danvi.dmall.biz.system.model.CmnCdDtlVO" %>
<%@ tag import="java.util.ArrayList" %>
<%@ tag import="java.util.Arrays" %>
<%@ attribute name="codeGrp" required="true" description="코드 그룹" %>
<%@ attribute name="includeTotal" required="false" description="전체 추가 여부" type="java.lang.Boolean" %>
<%@ attribute name="name" required="true" description="체크박스 태그 이름" %>
<%@ attribute name="idPrefix" required="true" description="체크박스 태그 ID 접두어" %>
<%@ attribute name="value" required="false" description="체크박스 태그의 값" type="java.lang.String[]"%>
<%@ attribute name="validate" required="false" description="체크박스 태그의 검증식" %>
<%
    int index = 1;
    List<CmnCdDtlVO> codes = ServiceUtil.listCode(codeGrp);
    List<CmnCdDtlVO> codesCopy = new ArrayList<CmnCdDtlVO>();
    codesCopy.addAll(codes);
    String checked="";
    String on="";

    if(includeTotal != null && includeTotal) {
        CmnCdDtlVO temp = new CmnCdDtlVO();
        temp.setDtlCd("");
        temp.setDtlNm("전체");
        codesCopy.add(0, temp);
    }

    if(validate != null && validate.length() > 1) {
        validate = " class=\"" + validate + "\"";
    } else {
        validate = "";
    }

    for(CmnCdDtlVO codeDetail : codesCopy) {
            if(value!= null && Arrays.asList(value).indexOf(codeDetail.getDtlCd())>-1) {
                checked = " checked=\"checked\"";
                on = " on";
            } else {
                checked = "";
                on = "";
            }
%>
<li>
	<a href="javascript:;" name="${name}" id="${idPrefix}_<%= index %>" value="<%= codeDetail.getDtlCd() %>"><%= codeDetail.getDtlNm() %></a>
	<%
        if(name.indexOf("ShapeCd")>-1){
            if(codeDetail.getUserDefien1()!=null){
    %>

    <i class="<%=codeDetail.getUserDefien1()%>"></i>
    <%
            }
        }
    %>
</li>
<%--<li>
    <input type="checkbox" name="${name}" id="${idPrefix}_<%= index %>" class="brand_check" value="<%= codeDetail.getDtlCd() %>" <%= checked %>>
    <label for="${idPrefix}_<%= index %>"><span></span><%= codeDetail.getDtlNm() %></label>
</li>--%>
<%
index++;
    }
%>