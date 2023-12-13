<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">개인정보처리방침</t:putAttribute>
    
    
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        var hSize = $('#term_content').prop('scrollHeight');
        $('#term_content').css('height',hSize);
    })
    </script>
    </t:putAttribute>
    
    <t:putAttribute name="content">
    	<!--- 03.LAYOUT:CONTENTS --->
    	<div id="sub_container">	
		<div class="top_title">
			<!-- <div class="location">
				<a href="#" class="btn_go_prev">이전으로</a>2018-06-28
			</div> -->
			<h2 class="sub_tit">개인정보처리방침</h2><!--2018-06-28-->
		</div>
        <div class="bottom_rule_box">
			${term_config.data.content}
		</div>
		<!---// 03.LAYOUT:CONTENTS --->
    </t:putAttribute>
    
</t:insertDefinition>