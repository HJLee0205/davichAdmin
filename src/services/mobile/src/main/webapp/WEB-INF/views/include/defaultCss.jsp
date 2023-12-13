<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<sec:authentication var="user" property='details'/>
<jsp:useBean id="today" class="java.util.Date" />
<fmt:formatDate value="${today}" pattern="yyyyMMddmmss" var="nowDate"/>
<link rel="stylesheet" type="text/css" href="/m/front/css/include.css?dt=${nowDate}" /> <!--- Default css ---->
