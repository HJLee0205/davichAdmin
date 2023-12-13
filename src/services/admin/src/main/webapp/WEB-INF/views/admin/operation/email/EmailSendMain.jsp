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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">이메일 자동 발송 설정 > 이메일 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                if("${emailSendSo.pageGb}"=="1"){
                    jQuery("#EmailAutoSendHist").show();
                    $(".tab_link > ul li").parent().find("li").removeClass("on");
                    $(".tab_link > ul li").parent().find("li").eq(1).addClass("on");
                }else {
                    jQuery("#EmailAutoSendSet").show();
                    jQuery("#EmailAutoSendSetInsert").show();
                    $(".tab_link > ul li").parent().find("li").removeClass("on");
                    $(".tab_link > ul li").parent().find("li").eq(0).addClass("on");
                }
                
                $(".tab_link > ul li").click(function(){
                    var now_tab = $(this).index();
                    $(this).parent().find("li").removeClass("on");
                    $(this).parent().find("li").eq(now_tab).addClass("on");
                    
                    if(now_tab == "0"){
                        jQuery("#EmailAutoSendSet").show();
                        jQuery("#EmailAutoSendSetInsert").show();
                        jQuery("#EmailAutoSendHist").hide();
                    }else if(now_tab == "1"){
                        jQuery("#EmailAutoSendSet").hide();
                        jQuery("#EmailAutoSendSetInsert").hide();
                        jQuery("#EmailAutoSendHist").show();
                    }
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">[이메일발송] 설정 </h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue" id = "EmailAutoSendSetInsert" style="display:none">저장하기</a>
                </div>
            </div>
            <div class="tab_link">
                <ul class="two">
                    <li class="on"><a href="#none">이메일 자동발송 설정</a></li>
                    <li><a href="#none">이메일 발송 내역</a></li>
                </ul>
            </div>
            <div id = "EmailAutoSendSet" style="display:none" >
            <%@ include file="EmailAutoSendSet.jsp" %>
            <%@ include file="replaceCd.jsp" %>
            </div>
            <div id = "EmailAutoSendHist" style="display:none" >
            <%@ include file="EmailAutoSendHist.jsp" %>
            </div>
            <%@ include file="EmailUseInfo.jsp" %>
        </div>
    </t:putAttribute>
</t:insertDefinition>
