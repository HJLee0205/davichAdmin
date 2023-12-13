<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="공통코드를 이용한 셀렉트 박스 옵션" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag import="java.util.StringTokenizer" %>
<%@ attribute name="codeStr" required="true" description="코드 데이터 문자열 예):전체;Y:동의;N:거부" %>
<%@ attribute name="value" required="false" description="셀렉트박스 태그의 값" %>
<%
    int index = 1;
    String selected;
    String on;


    StringTokenizer codeListToken = new StringTokenizer(codeStr, ";");
    String token;
    String code[];
    while(codeListToken.hasMoreTokens()) {
        token = codeListToken.nextToken();
        code = token.split(":");

        if(value == null && index == 1 || code[0].equals(value)) {
            selected = " selected=\"selected\"";
            on = " on";
        } else {
            selected = "";
            on = "";
        }
%>
<option value="<%= code[0] %>"<%= selected %>><%= code[1] %></option>
<%
        index++;
    }
%>