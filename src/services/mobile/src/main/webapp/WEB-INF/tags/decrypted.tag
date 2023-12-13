<%@ tag import="dmall.framework.common.util.CryptoUtil" %>
<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="암호화 데이터의 복호화" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="value" required="true" description="암호화 문자열" %>
<%=CryptoUtil.decryptAES(value)%>