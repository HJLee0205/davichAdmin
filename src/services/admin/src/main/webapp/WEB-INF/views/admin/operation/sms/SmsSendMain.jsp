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
    <t:putAttribute name="title">SMS 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
        jQuery(document).ready(function() {
            if("${smsSendSo.pageGb}"=="2"){
                jQuery("#SmsIndividualSendHist").show();
                $(".tab_link > ul li").parent().find("li").removeClass("on");
                $(".tab_link > ul li").parent().find("li").eq(1).addClass("on");
            }else if("${smsSendSo.pageGb}"=="3"){
                jQuery("#SmsAutoSendSet").show();
                $(".tab_link > ul li").parent().find("li").removeClass("on");
                $(".tab_link > ul li").parent().find("li").eq(2).addClass("on");
            }else if("${smsSendSo.pageGb}"=="4"){
                jQuery("#SmsAutoSendHist").show();
                $(".tab_link > ul li").parent().find("li").removeClass("on");
                $(".tab_link > ul li").parent().find("li").eq(3).addClass("on");
            }else if("${smsSendSo.pageGb}"=="5"){
                jQuery("#SmsPaid").show();
                $(".tab_link > ul li").parent().find("li").removeClass("on");
                $(".tab_link > ul li").parent().find("li").eq(4).addClass("on");
            }else {
                jQuery("#SmsIndividualSend").show();
                $(".tab_link > ul li").parent().find("li").removeClass("on");
                $(".tab_link > ul li").parent().find("li").eq(0).addClass("on");
            }

            $(".tab_link > ul li").click(function(){
                var now_tab = $(this).index();
                $(this).parent().find("li").removeClass("on");
                $(this).parent().find("li").eq(now_tab).addClass("on");

                if(now_tab == "0"){
                    jQuery("#SmsIndividualSend").show();
                    jQuery("#SmsIndividualSendHist").hide();
                    jQuery("#SmsAutoSendSet").hide();
                    jQuery("#SmsAutoSendHist").hide();
                    jQuery("#SmsPaid").hide();
                    $("#chargeBtn").hide();
                    $("#updateDiv").hide();
                }else if(now_tab == "1"){
                    jQuery("#SmsIndividualSend").hide();
                    jQuery("#SmsIndividualSendHist").show();
                    jQuery("#SmsAutoSendSet").hide();
                    jQuery("#SmsAutoSendHist").hide();
                    jQuery("#SmsPaid").hide();
                    $("#chargeBtn").hide();
                    $("#updateDiv").hide();
                }else if(now_tab == "2"){
                    jQuery("#SmsIndividualSend").hide();
                    jQuery("#SmsIndividualSendHist").hide();
                    jQuery("#SmsAutoSendSet").show();
                    jQuery("#SmsAutoSendHist").hide();
                    jQuery("#SmsPaid").hide();
                    $("#chargeBtn").hide();
                    $("#updateDiv").show();
                }else if(now_tab == "3"){
                    jQuery("#SmsIndividualSend").hide();
                    jQuery("#SmsIndividualSendHist").hide();
                    jQuery("#SmsAutoSendSet").hide();
                    jQuery("#SmsAutoSendHist").show();
                    jQuery("#SmsPaid").hide();
                    $("#chargeBtn").hide();
                    $("#updateDiv").hide();
                }else{
                    jQuery("#SmsIndividualSend").hide();
                    jQuery("#SmsIndividualSendHist").hide();
                    jQuery("#SmsAutoSendSet").hide();
                    jQuery("#SmsAutoSendHist").hide();
                    jQuery("#SmsPaid").show();
                    $("#chargeBtn").show();
                    $("#updateDiv").hide();
                }
            });
        });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">[SMS발송] 설정 </h2>
                <div class="btn_box right" id="chargeBtn" style="display:none;">
                    <a href="#none" class="btn blue shot">충전하기</a>
                    <a href="#none" class="btn blue shot" onclick="viewSmsChargeHst();">충전내역확인</a>
                </div>
                <div class="btn_box right" id="updateDiv" style="display:none;">
                    <a href="#none" class="btn blue" id = "updateBtn" >저장하기</a>
                </div>
            </div>
            <div class="tab_link">
                <ul class="five">
                    <li class="on"><a href="#none">SMS 개별 발송</a></li>
                    <li><a href="javascript:;">SMS 발송내역</a></li>
                    <li><a href="javascript:;">SMS 자동발송 설정</a></li>
                    <li><a href="javascript:;">SMS 자동발송 내역</a></li>
                    <%--<li><a href="javascript:;">SMS 충전관리</a></li>--%>
                </ul>
            </div>
            <div id = "SmsIndividualSend" style="display:none">
            <%@ include file="SmsIndividualSend.jsp" %>
            <%@ include file="/WEB-INF/views/admin/member/manage/SaveMnLayerPop.jsp" %>
            </div>
            <div id = "SmsIndividualSendHist" style="display:none">
            <%@ include file="SmsIndividualSendHist.jsp" %>
            </div>
            <div id = "SmsAutoSendSet" style="display:none">
            <%@ include file="SmsAutoSendSet.jsp" %>
            <%@ include file="replaceCd.jsp" %>
            </div>
            <div id = "SmsAutoSendHist" style="display:none">
            <%@ include file="SmsAutoSendHist.jsp" %>
            </div>
            <div id = "SmsPaid" style="display:none">
            <%--<%@ include file="SmsPaid.jsp" %>
            <%@ include file="SmsChargeHis.jsp" %>--%>
            </div>
            <%@ include file="SmsUseInfo.jsp" %>
        </div>
    </t:putAttribute>
</t:insertDefinition>
