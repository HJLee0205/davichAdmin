<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 이용약관</t:putAttribute>


    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        var hSize = $('#term_content').prop('scrollHeight');
        $('#term_content').css('height',hSize);
    })
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
         <!--- contents --->
		<div class="category_middle">
			<!--- category header 카테고리 location과 동일 --->
			<!-- <div id="category_header">
				<div id="category_location">
					<a href="javascript:history.back(-1);">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>이용약관
				</div>
			</div> -->
			<!---// category header --->
            <div class="com_head">
				<h2 class="com_tit">이용약관</h2>
			</div>
			<ul class="com_tabs">
				<li><span class="active" rel="tab01">서비스이용약관</span></li>
				<li><span rel="tab02">위치정보이용약관</span></li>
			</ul>
            <div class="bottom_agree_area com_tab_content" id="tab01">
				${term_config.data.content}
			</div>
			 <div class="bottom_agree_area com_tab_content" id="tab02">
				${term_config_p.data.content}
			</div>
        </div>
    </t:putAttribute>
</t:insertDefinition>