<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">에러</t:putAttribute>



    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                jQuery('button.btn_error_go').on('click', function() {
                    window.history.back();
                });
                jQuery('button.btn_error_go_main').on('click', function() {
                    window.location.href = '/';
                });
            });


            var referrer =  document.referrer;
            var paymentPgCd = "${param.paymentPgCd}"; //allthegate = "04";
             // 올더게이트 "지불처리중"팝업창 닫는 부분
            if(referrer.indexOf('front/order/order-form') > 0 && paymentPgCd == "04"){
                var openwin = window.open("about:blank","popup","width=300,height=160");
                openwin.close();
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <%-- <!--- contents --->
        <div class="error">
            <div class="error_box">
                <h1 class="error_logo"><img src="/front/img/member/error_logo.png" alt=""></h1>
                <div class="error_title">
                    이용에 불편을 드려 죄송합니다.
                </div>
                <div class="error_text01">
                    ${exMsg}
                </div>
                <div class="error_text02">
                    감사합니다.
                </div>
                <div class="btn_area" style="height:100px">
                    <button type="button" class="btn_error_prev" style="margin-right:6px">이전페이지로 돌아가기</button>
                    <button type="button" class="btn_error_main">메인페이지로 돌아가기</button>
                </div>
            </div>
            <div class="error_footer">System by Davich</div>
        </div>
        <!---// contents ---> --%>
		<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="error_title">
			이용에 불편을 드려 죄송합니다.
		</div>
		<div class="error_text01">
<!-- 		페이지의 주소가 잘못 입력되었거나
변경 혹은 삭제되어 <br/>
요청하신 페이지를 찾을 수 없습니다.<br/>
입력하신 주소가 정확한지 <br/>
다시 한 번 확인해주시기 바랍니다.<br/> -->
${exMsg}
		</div>
		<div class="error_text02">
		감사합니다.
		</div>
		<div class="error_btn_area">
			<button type="button" class="btn_error_go">이전페이지로</button>
			<button type="button" class="btn_error_go_main">메인페이지로</button>
		</div>
		<!-- <div class="error_footer">
			System by Davich
		</div> -->
	</div>
	<!---// 03.LAYOUT:CONTENTS --->
    </t:putAttribute>
</t:insertDefinition>