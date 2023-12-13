<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="공통코드를 이용한 체크박스" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag import="java.util.List" %>
<%@ tag import="net.danvi.dmall.biz.system.util.ServiceUtil" %>
<%@ tag import="net.danvi.dmall.biz.system.model.CmnCdDtlVO" %>
<%@ tag import="java.util.ArrayList" %>
<%@ attribute name="codeGrp" required="true" description="코드 그룹" %>
<%@ attribute name="usrDfn1Val" required="false" description="사용자 정의 값1" %>
<%@ attribute name="usrDfn2Val" required="false" description="사용자 정의 값2" %>
<%@ attribute name="usrDfn3Val" required="false" description="사용자 정의 값3" %>
<%@ attribute name="usrDfn4Val" required="false" description="사용자 정의 값4" %>
<%@ attribute name="usrDfn5Val" required="false" description="사용자 정의 값5" %>
<%@ attribute name="includeTotal" required="false" description="전체 추가 여부" type="java.lang.Boolean" %>
<%@ attribute name="name" required="true" description="체크박스 태그 이름" %>
<%@ attribute name="idPrefix" required="true" description="체크박스 태그 ID 접두어" %>
<%@ attribute name="value" required="false" description="체크박스 태그의 값" %>
<%@ attribute name="validate" required="false" description="체크박스 태그의 검증식" %>
<%
    int index = 1;
    List<CmnCdDtlVO> codes = ServiceUtil.listCode(codeGrp, usrDfn1Val, usrDfn2Val, usrDfn3Val, usrDfn4Val, usrDfn5Val);
    List<CmnCdDtlVO> codesCopy = new ArrayList<CmnCdDtlVO>();
    codesCopy.addAll(codes);
    String checked;
    String on;

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
        if(value != null && codeDetail.getDtlCd().equals(value)) {
            checked = " checked=\"checked\"";
            on = " on";
        } else {
            checked = "";
            on = "";
        }
%>
<label for="${idPrefix}_<%= index %>" class="chack mr20<%= on %>">
    <span class="ico_comm">
        <input type="checkbox" name="${name}" id="${idPrefix}_<%= index %>" value="<%= codeDetail.getDtlCd() %>"<%= checked %><%= validate %> />
    </span>
    <%= codeDetail.getDtlNm() %>
</label>
<%
index++;
    }
%>