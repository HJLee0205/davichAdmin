<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 청소년보호방침</t:putAttribute>


    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){

    })
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
		<div class="category_middle">
			<!--- category header 카테고리 location과 동일 --->
			<!--<div id="category_header">
				 <div id="category_location">
					<a href="javascript:history.back(-1);">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>청소년보호방침
				</div> 
			</div>-->
			<!---// category header --->
            <div class="com_head">
				<h2 class="com_tit">청소년보호방침</h2>
			</div>
            <div class="bottom_agree_area">
				${term_config.data.content}
			</div>
        </div>
    </t:putAttribute>
</t:insertDefinition>