<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="공통코드를 이용한 셀렉트 박스 옵션" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag import="java.util.List" %>
<%@ tag import="net.danvi.dmall.biz.system.util.ServiceUtil" %>
<%@ tag import="net.danvi.dmall.biz.system.model.CmnCdDtlVO" %>
<%@ tag import="java.util.ArrayList" %>
<%@ attribute name="codeGrp" required="true" description="코드 그룹" %>
<%@ attribute name="codeGrpTitle" required="false" description="코드 그룹 타이틀" %>
<%@ attribute name="includeTotal" required="false" description="전체 추가 여부" type="java.lang.Boolean" %>
<%@ attribute name="includeChoice" required="false" description="선택 추가 여부" type="java.lang.Boolean" %>
<%@ attribute name="value" required="false" description="셀렉트박스 태그의 값" %>
<%
    int index = 1;
    List<CmnCdDtlVO> codes = ServiceUtil.listCode(codeGrp);
    List<CmnCdDtlVO> codesCopy = new ArrayList<CmnCdDtlVO>();
    codesCopy.addAll(codes);
    String selected = "";

    if(includeTotal != null && includeTotal) {
        CmnCdDtlVO temp = new CmnCdDtlVO();
        temp.setDtlCd("");
        temp.setDtlNm("전체");
        codesCopy.add(0, temp);
    }

    if(includeChoice != null && includeChoice) {
        CmnCdDtlVO temp = new CmnCdDtlVO();
        temp.setDtlCd("");
        temp.setDtlNm(codeGrpTitle);
        codesCopy.add(0, temp);
    }



    for(CmnCdDtlVO codeDetail : codesCopy) {
        if(value == null && index == 1 || codeDetail.getDtlCd().equals(value)) {
            selected = " selected=\"selected\"";
        } else {
            selected = "";
        }
%>
<option value="<%= codeDetail.getDtlCd() %>"<%= selected %>><%= codeDetail.getDtlNm() %></option>
<%
        index++;
    }
%>