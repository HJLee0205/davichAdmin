<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="체크박스" trimDirectiveWhitespaces="true" %>
<%@ tag import="java.util.StringTokenizer" %>
<%@ attribute name="codeStr" required="true" description="코드 데이터 문자열 예)':전체;Y:동의;N:거부'" %>
<%@ attribute name="name" required="true" description="체크박스 태그 이름" %>
<%@ attribute name="idPrefix" required="true" description="체크박스 태그 ID 접두어" %>
<%@ attribute name="value" required="false" description="체크박스 태그의 값" %>
<%@ attribute name="validate" required="false" description="체크박스 태그의 검증식" %>
<%
    int index = 1;
    String input;
    String id;
    String on;


    StringTokenizer codeListToken = new StringTokenizer(codeStr, ";");
    String token;
    String code[];

    while(codeListToken.hasMoreTokens()) {
        token = codeListToken.nextToken();
        code = token.split(":");
        id = idPrefix + "_" + index++;
        input = "<input type=\"checkbox\"";
        input += " name=\"" + name + "\"";
        input += " id=\"" + id + "\"";

        if(value != null && code[0].equals(value)) {
            input += " checked=\"checked\"";
            on = " on";
        } else {
            input += "";
            on = "";
        }

        input += " value=\"" + code[0] + "\"";

        if(validate != null) {
            input += " class=\"" + validate + "\"";
        }

        input += " />";
%>
<label for="<%= id %>" class="chack mr20<%= on %>">
    <span class="ico_comm">
        <%= input %>
    </span>
    <%= code[1] %>
</label>
<%
    }
%>