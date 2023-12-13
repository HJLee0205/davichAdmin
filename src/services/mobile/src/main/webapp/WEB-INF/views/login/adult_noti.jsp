<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">19금 상품안내</t:putAttribute>
    
    
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            $('#btn_adult_certification').on('click',function(){
               location.href="${_MOBILE_PATH}/front/member/information-update-form";//회원정보 수정페이지이동
            });
            $('#btn_move_main').on('click',function(){
                location.href="${_MOBILE_PATH}/front/main-view";//메인페이지이동
             });
            $('.error_title').css('background', 'url(/front/img/common/img_adult.png) no-repeat center');
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    	<!--- 03.LAYOUT:CONTENTS --->
		<div id="middle_area">	 
			<div class="error_title">
				<p style="margin-top: 20px;">해당 상품은<br/><em>성인인증</em>이 필요한 상품입니다.</p>
			</div>
			<div class="error_text01">
                    성인 인증 후 조회/구매가 가능합니다.
			</div>
			<div class="error_btn_area">
				<button type="button" class="btn_error_go" id="btn_move_main">뒤로가기</button>
<!--                 <button type="button" class="btn_error_go_main" id="btn_adult_certification">본인인증 페이지 이동</button> -->
			</div>
		</div>	
		<!---// 03.LAYOUT:CONTENTS --->
		
    </t:putAttribute>
</t:insertDefinition>