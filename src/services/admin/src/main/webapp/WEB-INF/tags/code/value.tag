<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="공통코드의 값" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag import="net.danvi.dmall.biz.system.util.ServiceUtil" %>
<%@ tag import="dmall.framework.common.util.StringUtil" %>
<%@ attribute name="grpCd" required="true" description="코드 그룹" type="java.lang.String" %>
<%@ attribute name="cd" required="true" description="코드" type="java.lang.String" %>
<%= StringUtil.nvl(ServiceUtil.getCodeName(grpCd, cd), "") %>