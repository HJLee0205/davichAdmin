<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="디자인 체크박스" trimDirectiveWhitespaces="true" %>
<%@ attribute name="id" required="true" description="엘리먼트 ID" %>
<%@ attribute name="name" required="true" description="엘리먼트 name" %>
<%@ attribute name="value" required="true" description="값" %>
<%@ attribute name="compareValue" required="true" description="값" %>
<%@ attribute name="text" required="true" description="체크박스 텍스트" %>
<%@ attribute name="validate" required="false" description="체크박스 태그의 검증식" %>
<%
    String checked = "";
    String on = "";

    if(compareValue != null && !compareValue.equals("")) {
        String[] compareValueList = compareValue.split(",");
        if(compareValueList.length == 1) {
            if(value.equals(compareValue)) {
                checked = " checked=\"checked\"";
                on = " on";
            }
        } else {
            for (String s : compareValueList) {
                if (value.equals(s)) {
                    checked = " checked=\"checked\"";
                    on = " on";
                    break;
                }
            }
        }
    }

    if(validate != null && validate.length() > 1) {
        validate = " class=\"" + validate + "\"";
    } else {
        validate = "";
    }
%>
<label for="${id}" class="chack mr20<%= on %>">
    <span class="ico_comm">
        <input type="checkbox" name="${name}" id="${id}" value="${value}"<%= checked %><%= validate %> />
    </span>
    ${text}
</label>