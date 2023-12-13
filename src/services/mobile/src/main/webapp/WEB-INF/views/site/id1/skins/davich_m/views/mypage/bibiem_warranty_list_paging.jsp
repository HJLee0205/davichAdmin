<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach var="warrantyList" items="${resultListModel.resultList}" varStatus="status">
	<tr>
		<td>${warrantyList.pagingNum}</td>
		<td>${warrantyList.dates}</td>
		<td>${warrantyList.memberNm}</td>
		<td>${warrantyList.itmName}</td>
		<td>${warrantyList.strName}</td>
	</tr>
</c:forEach>