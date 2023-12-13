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
<%-- <%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %> --%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">푸시 알림 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
        jQuery(document).ready(function() {
            if("${pushSendSo.pageGb}"=="1"){
                jQuery("#AppIndividualSendHist").show();
                $(".tab_link > ul li").parent().find("li").removeClass("on");
                $(".tab_link > ul li").parent().find("li").eq(1).addClass("on");
            } else if("${pushSendSo.pageGb}"=="2"){
                jQuery("#AppIndividualSendDetailHist").show();
                $(".tab_link > ul li").parent().find("li").removeClass("on");
                $(".tab_link > ul li").parent().find("li").eq(1).addClass("on");
            } else {
                jQuery("#AppIndividualSend").show();
                $(".tab_link > ul li").parent().find("li").removeClass("on");
                $(".tab_link > ul li").parent().find("li").eq(0).addClass("on");
            }

            $(".tab_link > ul li").click(function(){
                var now_tab = $(this).index();
                $(this).parent().find("li").removeClass("on");
                $(this).parent().find("li").eq(now_tab).addClass("on");

                if(now_tab == "0"){
                    jQuery("#AppIndividualSend").show();
                    jQuery("#AppIndividualSendHist").hide();
                    jQuery("#AppIndividualSendDetailHist").hide();
                }else if(now_tab == "1"){
                	jQuery("#AppIndividualSend").hide();
                    if("${pushSendSo.pageGb}"=="1"){
                        jQuery("#AppIndividualSendHist").show();
                        jQuery("#AppIndividualSendDetailHist").hide();
                    } else if("${pushSendSo.pageGb}"=="2"){
                        jQuery("#AppIndividualSendHist").hide();
                        jQuery("#AppIndividualSendDetailHist").show();
                    } else {
                        jQuery("#AppIndividualSendHist").show();
                        jQuery("#AppIndividualSendDetailHist").hide();
                    }
                }
            });
        });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">푸시 알림 관리</h2>
            </div>
            <div class="tab_link">
                <ul class="five">
                    <li class="on"><a href="#none">개별발송</a></li>
                    <li><a href="#none">발송내역</a></li>
                </ul>
            </div>
            
            <div id = "AppIndividualSend" style="display:none">
            <%@ include file="AppIndividualSend.jsp" %>
            <%@ include file="/WEB-INF/views/admin/member/manage/SaveMnLayerPop.jsp" %>
            </div>
            
            <div id = "AppIndividualSendHist" style="display:none">
            <%@ include file="AppIndividualSendHist.jsp" %>            
            </div>
            <div id = "AppIndividualSendDetailHist" style="display:none">
            <%@ include file="AppIndividualSendDetailHist.jsp" %>            
            </div>
            
        </div>
    </t:putAttribute>
</t:insertDefinition>
