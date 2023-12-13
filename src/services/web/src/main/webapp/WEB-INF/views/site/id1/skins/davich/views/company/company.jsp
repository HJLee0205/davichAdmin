<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 회사소개</t:putAttribute>


    <t:putAttribute name="content">
	 <!--- 02.LAYOUT: 카테고리 메인 --->
		<!--- contents --->
		<div class="category_middle">
			<!--- category header 카테고리 location과 동일 --->
			<!-- <div id="category_header">
				<div id="category_location">
					<a href="javascript:history.back(-1);">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>회사소개
				</div>
			</div>
			<!---// category header --->

			<div class="com_head">
				<h2 class="com_tit">회사 소개</h2>
			</div>
			<div class="bottom_agree_area">
				${term_config.data.content}
			</div>
			<div class="btn_com_area">
				<button type="button" class="btn_go_site" onClick="window.open('https://www.davich.com/')">다비치안경 홈페이지</button>
			</div>
        </div>
    </t:putAttribute>
</t:insertDefinition>