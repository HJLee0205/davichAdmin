<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="공통코드를 이용한 셀렉트 박스 옵션" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag import="java.util.List" %>
<%@ tag import="net.danvi.dmall.biz.system.util.ServiceUtil" %>
<%@ tag import="net.danvi.dmall.biz.app.seller.model.SellerVO" %>
<%@ tag import="net.danvi.dmall.biz.app.seller.model.SellerSO" %>
<%@ tag import="java.util.ArrayList" %>
<%@ attribute name="includeNotiTotal" required="false" description="전체 추가 여부" type="java.lang.Boolean" %>
<%@ attribute name="includeTotal" required="false" description="전체 추가 여부" type="java.lang.Boolean" %>
<%@ attribute name="includeSelect" required="false" description="선택 추가 여부" type="java.lang.Boolean" %>
<%@ attribute name="value" required="false" description="셀렉트박스 태그의 값" %>
<%@ attribute name="siteno" required="false" description="셀렉트박스 태그의 값" %>
<%
    int index = 1;
	SellerSO so = new SellerSO();
	so.setSiteNo(Long.valueOf(siteno));
	
    List<SellerVO> codes = ServiceUtil.listSellerCode(so);
    List<SellerVO> codesCopy = new ArrayList<SellerVO>();
    codesCopy.addAll(codes);
    String selected = "";
    
    if(includeNotiTotal != null && includeNotiTotal) {
    	SellerVO temp = new SellerVO();
        temp.setSellerNo("0");
        temp.setSellerNm("전체");
        codesCopy.add(0, temp);
    }
    
    if(includeTotal != null && includeTotal) {
    	SellerVO temp = new SellerVO();
        temp.setSellerNo("");
        temp.setSellerNm("전체");
        codesCopy.add(0, temp);
    }
    
    if(includeSelect != null && includeSelect) {
    	SellerVO temp = new SellerVO();
        temp.setSellerNo("");
        temp.setSellerNm("선택");
        codesCopy.add(0, temp);
    }    

    for(SellerVO vo : codesCopy) {
        if(value == null && index == 1 || vo.getSellerNo().equals(value)) {
            selected = " selected=\"selected\"";
        } else {
            selected = "";
        }
%>
<option value="<%= vo.getSellerNo() %>"<%= selected %>><%= vo.getSellerNm() %></option>
<%
        index++;
    }
%>