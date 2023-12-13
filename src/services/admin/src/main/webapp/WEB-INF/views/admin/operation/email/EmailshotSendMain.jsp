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
    <t:putAttribute name="title">[대량메일발송] 설정</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                if("${emailSendSo.pageGb}"=="2"){
                    $("#EmailshotPaid").show();
                    $("#chargeBtnDiv").show();
                    $(".tab_link > ul li").parent().find("li").removeClass("on");
                    $(".tab_link > ul li").parent().find("li").eq(1).addClass("on");
                }else if("${emailSendSo.pageGb}"=="3"){
                    $("#EmailshotSendSet").show();
                    $("#sendEmailshotDiv").show();
                    $(".tab_link > ul li").parent().find("li").removeClass("on");
                    $(".tab_link > ul li").parent().find("li").eq(2).addClass("on");
                }else if("${emailSendSo.pageGb}"=="4"){
                    $("#EmailshotSendHist").show();
                    $(".tab_link > ul li").parent().find("li").removeClass("on");
                    $(".tab_link > ul li").parent().find("li").eq(3).addClass("on");
                }else {
                    $("#EmailshotGuide").show();
                    $(".tab_link > ul li").parent().find("li").removeClass("on");
                    $(".tab_link > ul li").parent().find("li").eq(0).addClass("on");
                }
                
                $(".tab_link > ul li").click(function(){
                    var now_tab = $(this).index();
                    $(this).parent().find("li").removeClass("on");
                    $(this).parent().find("li").eq(now_tab).addClass("on");

                    if(now_tab == "0"){
                        $("#EmailshotGuide").show();
                        $("#EmailshotPaid").hide();
                        $("#EmailshotSendSet").hide();
                        $("#EmailshotSendHist").hide();
                        $("#chargeBtnDiv").hide();
                        $("#sendEmailshotDiv").hide();
                    }else if(now_tab == "1"){
                        $("#EmailshotGuide").hide();
                        $("#EmailshotPaid").show();
                        $("#EmailshotSendSet").hide();
                        $("#EmailshotSendHist").hide();
                        $("#chargeBtnDiv").show();
                        $("#sendEmailshotDiv").hide();
                    }else if(now_tab == "2"){
                        $("#EmailshotGuide").hide();
                        $("#EmailshotPaid").hide();
                        $("#EmailshotSendSet").show();
                        $("#EmailshotSendHist").hide();
                        $("#chargeBtnDiv").hide();
                        $("#sendEmailshotDiv").show();
                    }else if(now_tab == "3"){
                        $("#EmailshotGuide").hide();
                        $("#EmailshotPaid").hide();
                        $("#EmailshotSendSet").hide();
                        $("#EmailshotSendHist").show();
                        $("#chargeBtnDiv").hide();
                        $("#sendEmailshotDiv").hide();
                    }
                });
                
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">[대량메일발송] 설정</h2>
                <div class="btn_box right" id="saveBtnDiv" style="display:none;">
                    <a href="#none" class="btn blue" id = "EmailAutoSendSetInsert" >저장하기</a>
                </div>
                <div class="btn_box right" id="chargeBtnDiv" style="display:none;">
                    <a href="#none" class="btn blue" id = "chargeInsert" >충전하기</a>
                    <a href="#none" class="btn blue" onclick="viewEmailChargeHst();">충전내역확인</a>
                </div>
                <div class="btn_box right" id="sendEmailshotDiv" style="display:none;">
                    <a href="#none" class="btn blue" id="previewBtn">미리보기</a>
                    <a href="#none" class="btn blue" id="sendEmailInsert" >발송하기</a>
                </div>
            </div>
            <div class="tab_link">
                <ul class="four">
                    <li class="on"><a href="#none">서비스 안내</a></li>
                    <li><a href="#none">대량메일 충전관리</a></li>
                    <li><a href="#none">대량메일 발송 설정</a></li>
                    <li><a href="#none">대량메일 발송내역</a></li>
                </ul>
            </div>
            <div id = "EmailshotGuide" style="display:none" >
                <%@ include file="EmailshotGuide.jsp" %>
            </div>
            <div id = "EmailshotPaid" style="display:none">
                <%@ include file="EmailPaid.jsp" %>
                <%@ include file="EmailChargeHis.jsp" %>
            </div>
            <div id = "EmailshotSendSet" style="display:none" >
                <%@ include file="EmailshotSend.jsp" %>
                <%@ include file="EmailPreviewLayerPop.jsp" %>
            </div>
            <div id = "EmailshotSendHist" style="display:none" >
                <%@ include file="EmailIndividualSendHist.jsp" %>
                
            </div>
            
            <%@ include file="EmailshotUseInfo.jsp" %>
        </div>
    </t:putAttribute>
</t:insertDefinition>
