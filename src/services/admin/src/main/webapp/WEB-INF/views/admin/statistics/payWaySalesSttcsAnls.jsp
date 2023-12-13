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
    <t:putAttribute name="title">매출 분석</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                PayWaySalesUtil.init();

                // 검색
                $('#btn_id_search').on('click', function(e){
                    PayWaySalesUtil.getPayWaySalesSttcsAnlsList();
                });
            });

            var PayWaySalesUtil = {
                init: function () {
                    PayWaySalesUtil.getPayWaySalesSttcsAnlsList();
                },
                getPayWaySalesSttcsAnlsList: function () {
                    var url = '/admin/statistics/payway-sales-statistics', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        console.log(result);

                        dfd.resolve(result.resultList);

                    });
                    return dfd.promise();
                },
            }
            

            var payWaySalesSttcsAnlsSet = {
                    payWaySalesSttcsAnlsList : [],
                    getPayWaySalesSttcsAnlsList : function() {
                        var hrData = new Array();
                        var nopbDpstCntData = new Array();
                        var nopbDpstAmtData = new Array();
                        var virtActDpstCntData = new Array();
                        var virtActDpstAmtData = new Array();
                        var credPaymentCntData = new Array();
                        var credPaymentAmtData = new Array();
                        var actTransCntData = new Array();
                        var actTransAmtData = new Array();
                        var mobilePaymentCntData = new Array();
                        var mobilePaymentAmtData = new Array();
                        var simpPaymentCntData = new Array();
                        var simpPaymentAmtData = new Array();
                        var paypalCntData = new Array();
                        var paypalAmtData = new Array();
                        var svmnPaymentCntData = new Array();
                        var svmnPaymentAmtData = new Array();
                        var sbnPaymentCntData = new Array();
                        var sbnPaymentAmtData = new Array();
                        var totalCntData = new Array();
                        var totalAmtData = new Array();
                        
                        var url = "/admin/statistics/payway-sales-statistics",dfd = jQuery.Deferred();
                        
                        // 파라미터 값 셋팅
                        setSubmitValue();
                        
                        var param = jQuery("#form_id_search").serialize();
                        
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            var tr = "";
                            
                            var nopbDpstCntSum = 0;   
                            var nopbDpstAmtSum = 0;   
                            var virtActDpstAmtSum = 0;   
                            var virtActDpstCntSum = 0;   
                            var virtActDpstAmtSum = 0;   
                            var credPaymentCntSum = 0;   
                            var credPaymentAmtSum = 0;   
                            var actTransCntSum = 0;      
                            var actTransAmtSum = 0;      
                            var mobilePaymentCntSum = 0; 
                            var mobilePaymentAmtSum = 0; 
                            var simpPaymentCntSum = 0;   
                            var simpPaymentAmtSum = 0;   
                            var paypalCntSum = 0;         
                            var paypalAmtSum = 0;        
                            var svmnPaymentCntSum = 0;         
                            var svmnPaymentAmtSum = 0;        
                            var sbnPaymentCntSum = 0;         
                            var sbnPaymentAmtSum = 0;
                            var totalCntSum = 0;         
                            var totalAmtSum = 0;
                            var cnt = 0;
                            
                            jQuery.each(result.resultList, function(idx, obj) {
                                hrData.push(result.resultList[cnt].dt);
                                nopbDpstCntData.push(result.resultList[cnt].nopbDpstCnt);
                                nopbDpstAmtData.push(result.resultList[cnt].nopbDpstAmt);
                                virtActDpstCntData.push(result.resultList[cnt].virtActDpstCnt);
                                virtActDpstAmtData.push(result.resultList[cnt].virtActDpstAmt);
                                credPaymentCntData.push(result.resultList[cnt].credPaymentCnt);
                                credPaymentAmtData.push(result.resultList[cnt].credPaymentAmt);
                                actTransCntData.push(result.resultList[cnt].actTransCnt);
                                actTransAmtData.push(result.resultList[cnt].actTransAmt);
                                mobilePaymentCntData.push(result.resultList[cnt].mobilePaymentCnt);
                                mobilePaymentAmtData.push(result.resultList[cnt].mobilePaymentAmt);
                                simpPaymentCntData.push(result.resultList[cnt].simpPaymentCnt);
                                simpPaymentAmtData.push(result.resultList[cnt].simpPaymentAmt);
                                paypalCntData.push(result.resultList[cnt].paypalCnt);
                                paypalAmtData.push(result.resultList[cnt].paypalAmt);
                                svmnPaymentCntData.push(result.resultList[cnt].svmnPaymentCnt);
                                svmnPaymentAmtData.push(result.resultList[cnt].svmnPaymentAmt);
                                sbnPaymentCntData.push(result.resultList[cnt].sbnPaymentCnt);
                                sbnPaymentAmtData.push(result.resultList[cnt].sbnPaymentAmt);
                                totalCntData.push(result.resultList[cnt].totalCnt);
                                totalAmtData.push(result.resultList[cnt].totalAmt);
                                
                                nopbDpstCntSum += Number(result.resultList[cnt].nopbDpstCnt.replace(/,/gi,""));
                                nopbDpstAmtSum += Number(result.resultList[cnt].nopbDpstAmt.replace(/,/gi,""));
                                virtActDpstCntSum += Number(result.resultList[cnt].virtActDpstCnt.replace(/,/gi,""));
                                virtActDpstAmtSum += Number(result.resultList[cnt].virtActDpstAmt.replace(/,/gi,""));
                                credPaymentCntSum += Number(result.resultList[cnt].credPaymentCnt.replace(/,/gi,""));
                                credPaymentAmtSum += Number(result.resultList[cnt].credPaymentAmt.replace(/,/gi,""));
                                actTransCntSum += Number(result.resultList[cnt].actTransCnt.replace(/,/gi,""));
                                actTransAmtSum += Number(result.resultList[cnt].actTransAmt.replace(/,/gi,""));
                                mobilePaymentCntSum += Number(result.resultList[cnt].mobilePaymentCnt.replace(/,/gi,""));
                                mobilePaymentAmtSum += Number(result.resultList[cnt].mobilePaymentAmt.replace(/,/gi,""));
                                simpPaymentCntSum += Number(result.resultList[cnt].simpPaymentCnt.replace(/,/gi,""));
                                simpPaymentAmtSum += Number(result.resultList[cnt].simpPaymentAmt.replace(/,/gi,""));
                                paypalCntSum += Number(result.resultList[cnt].paypalCnt.replace(/,/gi,""));
                                paypalAmtSum += Number(result.resultList[cnt].paypalAmt.replace(/,/gi,""));
                                svmnPaymentCntSum += Number(result.resultList[cnt].svmnPaymentCnt.replace(/,/gi,""));
                                svmnPaymentAmtSum += Number(result.resultList[cnt].svmnPaymentAmt.replace(/,/gi,""));
                                sbnPaymentCntSum += Number(result.resultList[cnt].sbnPaymentCnt.replace(/,/gi,""));
                                sbnPaymentAmtSum += Number(result.resultList[cnt].sbnPaymentAmt.replace(/,/gi,""));
                                totalCntSum += Number(result.resultList[cnt].totalCnt.replace(/,/gi,""));
                                totalAmtSum += Number(result.resultList[cnt].totalAmt.replace(/,/gi,""));
                                
                                cnt+=1;
                            });
                            
                            // 리스트 생성
                            var periodGb = "";
                            var dtStand = 0;
                            var dateValue = "";
                            var dtDataInit = 1;
                            
                            if(periodGbData == "T"){
                                periodGb = "시";
                                dtStand = 24;
                                dtDataInit = 0;
                            }else if(periodGbData == "D"){
                                periodGb = "일";
                                selectDay();
                                jQuery("#select3").remove();
                                dtStand = gDay+1;
                            }else if(periodGbData == "M"){
                                periodGb = "월";
                                dtStand = 13;
                            }
                            
                            cnt = 0;
                            //if(hrData.length > 0){
                                for(var dtData = dtDataInit; dtData < dtStand; dtData++){
                                    if(dtData < 10){
                                        dateValue = "0" + dtData;
                                    }else{
                                        dateValue = dtData;
                                    }
                                    
                                    if(hrData[cnt] == dateValue){
                                        tr += "<tr data-dt='" + hrData[cnt] + "'"
                                        + "data-nopb-dpst-cnt= '" + nopbDpstCntData[cnt] + "'"
                                        + "data-nopb-dpst-amt='" + nopbDpstAmtData[cnt] + "'"
                                        + "data-virt-act-dpst-cnt= '" + virtActDpstCntData[cnt] + "'"
                                        + "data-virt-act-dpst-amt='" + virtActDpstAmtData[cnt] + "'"
                                        + "data-cred-payment-cnt='" + credPaymentCntData[cnt] + "'"
                                        + "data-cred-payment-amt='" + credPaymentAmtData[cnt] + "'"
                                        + "data-act-trans-cnt='" + actTransCntData[cnt] + "'"
                                        + "data-act-trans-amt='" + actTransAmtData[cnt] + "'"
                                        + "data-mobile-payment-cnt='" + mobilePaymentCntData[cnt] + "'"
                                        + "data-mobile-payment-amt='" + mobilePaymentAmtData[cnt] + "'"
                                        + "data-simp-payment-cnt='" + simpPaymentCntData[cnt] + "'"
                                        + "data-simp-payment-amt='" + simpPaymentAmtData[cnt] + "'"
                                        + "data-paypal-cnt='" + paypalCntData[cnt] + "'"
                                        + "data-paypal-amt='" + paypalAmtData[cnt] + "'"
                                        + "data-svmn-payment-cnt='" + svmnPaymentCntData[cnt] + "'"
                                        + "data-svmn-payment-amt='" + svmnPaymentAmtData[cnt] + "'"
                                        + "data-sbn-payment-cnt='" + sbnPaymentCntData[cnt] + "'"
                                        + "data-sbn-payment-amt='" + sbnPaymentAmtData[cnt] + "'"+
                                        + "data-total-cnt='" + totalCntData[cnt] + "'"
                                        + "data-total-amt='" + totalAmtData[cnt] + "'>"
                                        + "<td class='bgray'>" + hrData[cnt] + periodGb + "</td>"
                                        + "<td>" + numberFormat(nopbDpstCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(nopbDpstAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(virtActDpstCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(virtActDpstAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(credPaymentCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(credPaymentAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(actTransCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(actTransAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(mobilePaymentCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(mobilePaymentAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(simpPaymentCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(simpPaymentAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(paypalCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(paypalAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(svmnPaymentCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(svmnPaymentAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(sbnPaymentCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(sbnPaymentAmtData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(totalCntData[cnt]) + "</td>"
                                        + "<td>" + numberFormat(totalAmtData[cnt]) + "</td></tr>";
                                        cnt+=1;
                                    }else{
                                        tr += "<tr data-dt='" + dateValue + "'"
                                        + "data-nopb-dpst-cnt= '" + dateValue + "'"
                                        + "data-nopb-dpst-amt='" + dateValue + "'"
                                        + "data-virt-act-dpst-cnt= '" + dateValue + "'"
                                        + "data-virt-act-dpst-amt='" + dateValue + "'"
                                        + "data-cred-payment-cnt='" + dateValue + "'"
                                        + "data-cred-payment-amt='" + dateValue + "'"
                                        + "data-act-trans-cnt='" + dateValue + "'"
                                        + "data-act-trans-amt='" + dateValue + "'"
                                        + "data-mobile-payment-cnt='" + dateValue + "'"
                                        + "data-mobile-payment-amt='" + dateValue + "'"
                                        + "data-simp-payment-cnt='" + dateValue + "'"
                                        + "data-simp-payment-amt='" + dateValue + "'"
                                        + "data-paypal-cnt='" + dateValue + "'"
                                        + "data-paypal-amt='" + dateValue + "'"
                                        + "data-svmn-payment-cnt='" + dateValue + "'"
                                        + "data-svmn-payment-amt='" + dateValue + "'"
                                        + "data-sbn-payment-cnt='" + dateValue + "'"
                                        + "data-sbn-payment-amt='" + dateValue + "'"+
                                        + "data-total-cnt='" + dateValue + "'"
                                        + "data-total-amt='" + dateValue + "'>"
                                        + "<td class='bgray'>" + dateValue + periodGb + "</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td>"
                                        + "<td>0</td></tr>";
                                    }
                                }
                            //}
                            
                            if(tr == "") {
                                tr = "<tr><td colspan='15'>데이터가 없습니다.</td></tr>";
                            }else{
                                tr += "<tr><td class='bbray'>합계</td>"
                                    + "<td class='bbray'>"+ numberFormat(nopbDpstCntSum) +"</td><td class='bbray'>"+ numberFormat(nopbDpstAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(virtActDpstCntSum) +"</td><td class='bbray'>"+ numberFormat(virtActDpstAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(credPaymentCntSum) +"</td><td class='bbray'>"+ numberFormat(credPaymentAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(actTransCntSum) +"</td><td class='bbray'>"+ numberFormat(actTransAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(mobilePaymentCntSum) +"</td><td class='bbray'>"+ numberFormat(mobilePaymentAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(simpPaymentCntSum) +"</td><td class='bbray'>"+ numberFormat(simpPaymentAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(paypalCntSum) +"</td><td class='bbray'>"+ numberFormat(paypalAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(svmnPaymentCntSum) +"</td><td class='bbray'>"+ numberFormat(svmnPaymentAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(sbnPaymentCntSum) +"</td><td class='bbray'>"+ numberFormat(sbnPaymentAmtSum) +"</td>"
                                   + "<td class='bbray'>"+ numberFormat(totalCntSum) +"</td><td class='bbray'>"+ numberFormat(totalAmtSum) +"</td></tr>"
                            }
                            
                            if(clickText == "전체"){
                                jQuery("#tbody_id_payWaySalesSttcsAnlsListAll").html(tr);
                            }else if(clickText == "PC"){
                                jQuery("#tbody_id_payWaySalesSttcsAnlsListPC").html(tr);
                            }else if(clickText == "모바일"){
                                jQuery("#tbody_id_payWaySalesSttcsAnlsListMobile").html(tr);
                            }
                            
                            payWaySalesSttcsAnlsSet.payWaySalesSttcsAnlsList = result.resultList;
                            dfd.resolve(result.resultList);
                            
                            Dmall.GridUtil.appendPaging("form_id_search", "div_id_paging", result, "paging_id_payWaySalesSttcsAnls", payWaySalesSttcsAnlsSet.getPayWaySalesSttcsAnlsList);
                            
                            jQuery.each(result.resultList, function(idx, obj) {
                                
                            });
                        });
                        
                        return dfd.promise();
                    }
            }
            
            // 서버에 보낼 파라미터 값 셋팅
            function setSubmitValue(){
                // 기간구분
                jQuery("#periodGb").val(periodGbData);
                        
                //년, 월, 일
                jQuery("#yr").val(jQuery("#selectYear option:selected").val());
                jQuery("#mm").val(jQuery("#selectMonth option:selected").val());
                jQuery("#dd").val(jQuery("#selectDay option:selected").val());
                
                // 기기구분에 따른 조회 조건 설정
                if(clickText == "전체"){
                    jQuery("#eqpmGbCd").val("00");
                }else if(clickText == "PC"){
                    jQuery("#eqpmGbCd").val("11");
                }else if(clickText == "모바일"){
                    jQuery("#eqpmGbCd").val("12");
                }
            }
            
            // 엑셀다운로드
            jQuery(".btn_exl").on("click", function(){
                // 파라미터 값 셋팅
                setSubmitValue();
             
                jQuery('#form_id_search').attr('action', '/admin/statistics/paywaysalesstatistics-excel-download');
                jQuery('#form_id_search').submit();
            });
            
          //콤마찍기
          function numberFormat(num) {
              var pattern = /(-?[0-9]+)([0-9]{3})/;
               while(pattern.test(num)) {
                   num = num.toString().replace(pattern,"$1,$2");
               }
               return num;
          }
           
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    통계<span class="step_bar"></span> 매출 분석<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">결제수단별 매출통계</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form action="/admin/statistics/payway-sales-statistics" id="form_id_search" commandName="payWaySalesSttcsSO">
                        <input type="hidden" name="periodGb" id="periodGb" value="M"/>
                        <input type="hidden" name="yr" id="yr" value="2019"/>
                        <input type="hidden" name="mm" id="mm"/>
                        <input type="hidden" name="dd" id="dd"/>
                        <input type="hidden" name="eqpmGbCd" id="eqpmGbCd" value="00"/>

                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 결제수단별 매출표 통계 입니다. 구성은 일별, 월별등의 기간검색 입니다.">
                                <caption>결제수단별 매출 통계 기간검색입니다.</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="searchFrom" to="searchTo" idPrefix="srch"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" type="button" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </form:form>
                </div>
                <div class="line_box">
                    <div class="sub_tab tab_lay2">
                        <ul>
                            <li class="tab-2 mr20 on"><a href="#tab1"><span class="ico_comm"></span>전체</a></li>
                            <li class="tab-2 mr20"><a href="#tab2"><span class="ico_comm"></span>WEB</a></li>
                            <li class="tab-2"><a href="#tab3"><span class="ico_comm"></span>APP</a></li>
                        </ul>
                    </div>

                    <div class="tab-2con" id="tab1">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3">순위별 결제수단 매출 현황</h3>
                            </div>
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <div style="clear: both;"></div>
                        <!-- tblh -->
                        <div class="tblh th_l tblmany">
                            <table summary="이표는 결제수단별 매출 통계 통계 입니다. 구성은 가상계좌, 신용카드, 실시간계좌이체, 휴대폰결제, 간편결제,페이팔에 따른 매출,건수에 대한 내역 입니다.">
                                <caption>결제수단별 매출 통계 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                </colgroup>
                                <thead class="thin">
                                <tr>
                                    <th rowspan="4" class="">순위별</th>
                                    <th colspan="2" class="line_b">1</th>
                                    <th colspan="2" class="line_b">2</th>
                                    <th colspan="2" class="line_b">3</th>
                                    <th colspan="2" class="line_b">4</th>
                                    <th colspan="2" class="line_b">5</th>
                                    <th colspan="2" class="line_b">6</th>
                                    <th colspan="2" class="line_b">7</th>
                                    <th colspan="2" class="line_b">8</th>
                                    <th colspan="2" class="line_b">9</th>
                                    <th colspan="2" class="line_b">10</th>
                                    <th colspan="2" class="line_b">11</th>
                                    <th rowspan="2" colspan="2" class="line_b">합계</th>
                                </tr>
                                <tr>
                                    <th colspan="2" class="line_b">신용카드</th>
                                    <th colspan="2" class="line_b">코드페이</th>
                                    <th colspan="2" class="line_b">삼성페이</th>
                                    <th colspan="2" class="line_b">L Pay</th>
                                    <th colspan="2" class="line_b">SSG Pay</th>
                                    <th colspan="2" class="line_b">Payco</th>
                                    <th colspan="2" class="line_b">Allpay</th>
                                    <th colspan="2" class="line_b">네이버페이</th>
                                    <th colspan="2" class="line_b">휴대폰결제</th>
                                    <th colspan="2" class="line_b">가상계좌</th>
                                    <th colspan="2" class="line_b">포인트</th>
                                </tr>
                                <tr>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_payWaySalesSttcsAnlsListAll">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                    </div>

                    <div class="tab-2con" id="tab2" style="display: none;">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3">순위별 결제수단 매출 현황</h3>
                            </div>
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <div style="clear: both;"></div>
                        <!-- tblh -->
                        <div class="tblh th_l tblmany">
                            <table summary="이표는 결제수단별 매출 통계 통계 입니다. 구성은 가상계좌, 신용카드, 실시간계좌이체, 휴대폰결제, 간편결제,페이팔에 따른 매출,건수에 대한 내역 입니다.">
                                <caption>결제수단별 매출 통계 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                </colgroup>
                                <thead class="thin">
                                <tr>
                                    <th rowspan="4" class="">순위별</th>
                                    <th colspan="2" class="line_b">1</th>
                                    <th colspan="2" class="line_b">2</th>
                                    <th colspan="2" class="line_b">3</th>
                                    <th colspan="2" class="line_b">4</th>
                                    <th colspan="2" class="line_b">5</th>
                                    <th colspan="2" class="line_b">6</th>
                                    <th colspan="2" class="line_b">7</th>
                                    <th colspan="2" class="line_b">8</th>
                                    <th colspan="2" class="line_b">9</th>
                                    <th colspan="2" class="line_b">10</th>
                                    <th colspan="2" class="line_b">11</th>
                                    <th rowspan="2" colspan="2" class="line_b">합계</th>
                                </tr>
                                <tr>
                                    <th colspan="2" class="line_b">신용카드</th>
                                    <th colspan="2" class="line_b">코드페이</th>
                                    <th colspan="2" class="line_b">삼성페이</th>
                                    <th colspan="2" class="line_b">L Pay</th>
                                    <th colspan="2" class="line_b">SSG Pay</th>
                                    <th colspan="2" class="line_b">Payco</th>
                                    <th colspan="2" class="line_b">Allpay</th>
                                    <th colspan="2" class="line_b">네이버페이</th>
                                    <th colspan="2" class="line_b">휴대폰결제</th>
                                    <th colspan="2" class="line_b">가상계좌</th>
                                    <th colspan="2" class="line_b">포인트</th>
                                </tr>
                                <tr>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_payWaySalesSttcsAnlsListPC">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                    </div>

                    <div class="tab-2con" id="tab3" style="display: none;">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3">순위별 결제수단 매출 현황</h3>
                            </div>
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <div style="clear: both;"></div>
                        <!-- tblh -->
                        <div class="tblh th_l tblmany">
                            <table summary="이표는 결제수단별 매출 통계 통계 입니다. 구성은 가상계좌, 신용카드, 실시간계좌이체, 휴대폰결제, 간편결제,페이팔에 따른 매출,건수에 대한 내역 입니다.">
                                <caption>결제수단별 매출 통계 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                    <col width="%">
                                </colgroup>
                                <thead class="thin">
                                <tr>
                                    <th rowspan="4" class="">순위별</th>
                                    <th colspan="2" class="line_b">1</th>
                                    <th colspan="2" class="line_b">2</th>
                                    <th colspan="2" class="line_b">3</th>
                                    <th colspan="2" class="line_b">4</th>
                                    <th colspan="2" class="line_b">5</th>
                                    <th colspan="2" class="line_b">6</th>
                                    <th colspan="2" class="line_b">7</th>
                                    <th colspan="2" class="line_b">8</th>
                                    <th colspan="2" class="line_b">9</th>
                                    <th colspan="2" class="line_b">10</th>
                                    <th colspan="2" class="line_b">11</th>
                                    <th rowspan="2" colspan="2" class="line_b">합계</th>
                                </tr>
                                <tr>
                                    <th colspan="2" class="line_b">신용카드</th>
                                    <th colspan="2" class="line_b">코드페이</th>
                                    <th colspan="2" class="line_b">삼성페이</th>
                                    <th colspan="2" class="line_b">L Pay</th>
                                    <th colspan="2" class="line_b">SSG Pay</th>
                                    <th colspan="2" class="line_b">Payco</th>
                                    <th colspan="2" class="line_b">Allpay</th>
                                    <th colspan="2" class="line_b">네이버페이</th>
                                    <th colspan="2" class="line_b">휴대폰결제</th>
                                    <th colspan="2" class="line_b">가상계좌</th>
                                    <th colspan="2" class="line_b">포인트</th>
                                </tr>
                                <tr>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                    <th>건수</th>
                                    <th>매출</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_payWaySalesSttcsAnlsListMobile">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>