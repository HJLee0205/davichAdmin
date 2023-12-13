<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--- search --->
<div id="search">
    <label for="searchText" class="blind">검색하기</label>
    <input type="text" id="searchText" onkeydown="if(event.keyCode == 13){$('#btn_search').click();}" value="">
    <button type="button" id="btn_search" class="btn_search" title="검색하기"></button>
</div>
<!---// search --->
