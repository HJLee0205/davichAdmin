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
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 출고(배송)관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        jQuery(document).ready(function() {
            // 정렬순서 변경 변경시 이벤트
            jQuery('#sel_sord').on('change', function(e) {
                jQuery('#hd_srod').val($(this).val());
                $(getDeliveryList);
            });
            // 표시갯수 변경 변경시 이벤트
            jQuery('#sel_rows').on('change', function(e) {
                $('#search_id_page').val(1);
                jQuery('#hd_rows').val($(this).val());
                $(getDeliveryList);
            });
            
            jQuery('#ord_search_btn').on('click', function(e) {
                $('#search_id_page').val(1);
                $(getDeliveryList);
            });
            
            jQuery('#excelDown').on('click', function(){
                jQuery('#form_ord_search').attr('action', '/admin/seller/order/delivery-excel-download');
                jQuery('#form_ord_search').submit();
            });  

           
         // 검색일자 기본값 선택
            <c:if test="${deliverySO.ordDayS eq null}">
            jQuery('#btn_srch_cal_1').trigger('click');
            </c:if>
            $(getDeliveryList);
            Dmall.FormUtil.setEnterSearch('form_ord_search', getDeliveryList);


        });

        /** 배송 정보 데이터 input 이름으로 갖고 오기 */
        function getColVal(rownum, name, action){
            str = '';
            var i = 0;
            $(action + "[id='" + name + "']").each(function() {
                if (i==rownum) {
                    str = $(this).val();
                }
                i++;
            });
            return str;
        }

        var getDeliveryList = function() {
            // 택배사 미리 세팅
            var url2 = '/admin/order/delivery/site-courier-list';
            var s = "";
            Dmall.AjaxUtil.getJSON(url2, jQuery('#form_ord_dtl').serialize(), function(result2) {
                // 택배사 목록
                s+='<option>선택</option>'
                jQuery.each(result2.resultList, function(idx, obj) {
                    s+='<option value="'+obj.rlsCourierCd+'">'+obj.rlsCourierNm+'</option>'
                });

                var url = '/admin/seller/order/delivery-list',
                param = jQuery('#form_ord_search').serialize(),
                dfd = jQuery.Deferred();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {

                    var template1 = '<tr>'+
                                        '<td>{{rownum}}</td>' +
                                        '<td>{{ordAcceptDttm}}</td>' +
                                        '<td>{{sellerNm}}</td>' +
                                        '<td>{{rlsCmpltDttm}}</td>' +
                                        '<td><a href="javascript:goOrdDtl(\'{{ordNo}}\')" class="tbl_link">{{ordNo}}</a></td>' +
                                        '<td>{{goodsNm}}</td>' +

                                        '<td>{{ordrNm}}<br>({{loginid}}/{{memberGradeNm}})</td>' +
                                        '<td>{{saleChannelNm}}</td>'+
                                        '<td>{{ordDtlStatusNm}}</td>' +
                                        '<td>' ;
                    var template2 =     '';
                    var template3 =     '</td>' +
                                    '</tr>' ;

                    managerTemplate1 = new Dmall.Template(template1),
                    managerTemplate3 = new Dmall.Template(template3),
                    tr = '';

                    jQuery.each(result.resultList, function(idx, obj) {
                        tr += managerTemplate1.render(obj);
                        if(obj.rlsCourierCd!=null && obj.rlsCourierCd!="" && obj.rlsInvoiceNo!=null && obj.rlsInvoiceNo!="") {
                            template2 = '{{rlsCourierNm}}<br>' +
                                        '{{rlsInvoiceNo}}<br>' +
                                        '<a href="javascript:trackingDelivery(\'' + obj.rlsCourierCd + '\',\'' + obj.rlsInvoiceNo+ '\',\'1200\',\'640\')"; class="btn_blue">배송추적</a>';
                        } else if(obj.dlvrcPaymentCd =='04') {
                            template2 =     '매장픽업';
                        } else {
                            template2 =     '<span class="select" id="span_courierCd_template">'+
                                            '   <label for="div_rlsCourierCd">선택</label>'+
                                            '   <select name="div_rlsCourierCd" id="div_rlsCourierCd">'+
                                                s+
                                            '   </select>'+
                                            '</span>'+
                                            '<input type="hidden" id="div_ordNo" name="div_ordNo" value="'+obj.ordNo+'">'+
                                            '<input type="hidden" id="div_dlvrcPaymentCd" name="div_dlvrcPaymentCd" value="'+obj.dlvrcPaymentCd+'">'+
                                            '<input type="hidden" id="div_dlvrNo" name="div_dlvrNo" value="'+obj.dlvrNo+'">'+
                                            '<input type="hidden" id="div_ordDtlSeq" name="div_ordDtlSeq" value="'+obj.ordDtlSeq+'">'+
                                            '<input type="hidden" id="div_goodsNo" name="div_goodsNo" value="'+obj.goodsNo+'">'+
                                            '<input type="hidden" id="div_ordQtt" name="div_ordQtt" value="'+obj.ordQtt+'">'+
                                            '<input type="hidden" id="div_ordDtlStatusCd" name="div_ordDtlStatusCd" value="'+obj.ordDtlStatusCd+'">'+

                                            '<span class="intxt shot2" id="span_div_rlsInvoiceNo" >' +
                                            '   <input id="div_rlsInvoiceNo" name="div_rlsInvoiceNo">' +
                                            '</span>'+
                                            '<span class="br" id="span_div_rlsInvoiceNo2" ></span>'+
                                            '<button class="btn_gray" name="btn_update_delivery">배송처리</button>';
                        }
                        managerTemplate2 = new Dmall.Template(template2),
                        tr += managerTemplate2.render(obj);
                        tr += managerTemplate3.render(obj);

                    });

                    if(tr == '') {
                        tr = '<tr><td colspan="10"><spring:message code="biz.exception.common.nodata"/></td></tr>';
                    }
                    jQuery('#ajaxOrdList').html(tr);


                    // 개별 배송처리
                    $("[name=btn_update_delivery]").off("click").on('click', function() {
                        var rownum = $(this).index()-2;
                        var div_ordNo = $(this).siblings('#div_ordNo').val(),
                            div_dlvrcPaymentCd = $(this).siblings('#div_dlvrcPaymentCd').val(),
                            div_dlvrNo = $(this).siblings('#div_dlvrNo').val(),
                            div_ordDtlSeq = $(this).siblings('#div_ordDtlSeq').val(),
                            div_goodsNo = $(this).siblings('#div_goodsNo').val(),
                            div_ordQtt = $(this).siblings('#div_ordQtt').val(),
                            div_ordDtlStatusCd= $(this).siblings('#div_ordDtlStatusCd').val(),

                            div_rlsCourierCd = $(this).siblings('#span_courierCd_template').find('#div_rlsCourierCd').val(),
                            div_rlsInvoiceNo = $(this).siblings('#span_div_rlsInvoiceNo').find('#div_rlsInvoiceNo').val()
                            ;

                        if(('04'!=div_dlvrcPaymentCd) &&((''==div_rlsCourierCd)||('98'!=div_rlsCourierCd&& ''==div_rlsInvoiceNo))) {
                            Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.deliveryInfo"/>');
                            return;
                        }

                        Dmall.LayerUtil.confirm('<spring:message code="biz.confirm.ord.deliveryInfo"/>', function() {

                            jQuery('#form_delivery input[name=ordNo]').val(div_ordNo);
                            jQuery('#form_delivery input[name=dlvrcPaymentCd]').val(div_dlvrcPaymentCd);
                            jQuery('#form_delivery input[name=rlsCourierCd]').val(div_rlsCourierCd);
                            jQuery('#form_delivery input[name=rlsInvoiceNo]').val(div_rlsInvoiceNo);
                            jQuery('#form_delivery input[name=dlvrNo]').val(div_dlvrNo);
                            jQuery('#form_delivery input[name=ordDtlSeq]').val(div_ordDtlSeq);
                            jQuery('#form_delivery input[name=goodsNo]').val(div_goodsNo);
                            jQuery('#form_delivery input[name=dlvrQtt]').val(div_ordQtt);
                            jQuery('#form_delivery input[name=ordStatusCd]').val(div_ordDtlStatusCd);

                            var url = '/admin/order/delivery/order-newinvoice-update',
                                param = $('#form_delivery').serialize(),
                                dfd = jQuery.Deferred();

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                    $(getDeliveryList);
                                }
                            });
                        });
                    });


                    dfd.resolve(result.resultList);
                    // 검색결과 갯수 처리
                    var cnt_search = result["filterdRows"],
                        cnt_search = null == cnt_search ? 0 : cnt_search;
                    $("#cnt_search").html(cnt_search);

                    // 총 갯수 처리
                    var cnt_total = result["totalRows"],

                    cnt_total = null == cnt_total ? 0 : cnt_total;
                    $("#cnt_total").html(cnt_total);
                    Dmall.GridUtil.appendPaging('form_ord_search', 'div_paging', result, 'paging_ord', getDeliveryList);
                    return dfd.promise();
                });

            });
        };
        
        function OpenWindow(url,intWidth,intHeight) { 
            window.open(url, "_blank", "width="+intWidth+",height="+intHeight+",resizable=1,scrollbars=1") ; 
        }

        /**
         * <pre>
         * 함수명 : goOrdDtl
         * 설  명 : 주문의 상세 페이지
         * 사용법 : 
         * 작성일 : 2016. 5. 24.
         * 작성자 : dong
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 5. 24. dong - 최초 생성
         * </pre>
         */
        function goOrdDtl(ordNo) {
            var data = {ordNo:ordNo};
            var url =  "/admin/seller/order/order-detail";
            Dmall.FormUtil.submit(url, data, "_blank");
        };
        
        /**********************************************************************************************************************
        CJ대한통운   https://www.doortodoor.co.kr/parcel/doortodoor.do?fsp_action=PARC_ACT_002&fsp_cmd=retrieveInvNoACT&invc_no=
        우체국택배   https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=
        한진택배    http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num=
        현대택배    http://www.hlc.co.kr/hydex/jsp/tracking/trackingViewCus.jsp?InvNo=
        로젠택배    http://d2d.ilogen.com/d2d/delivery/invoice_tracesearch_quick.jsp?slipno=
        KG로지스   http://www.kglogis.co.kr/delivery/delivery_result.jsp?item_no=
        CVsnet 편의점택배    http://www.cvsnet.co.kr/postbox/m_delivery/local/local.jsp?invoice_no=
        KGB택배   http://www.kgbls.co.kr//sub5/trace.asp?f_slipno=
        경동택배   http://t.kdexp.com/rerere.asp?stype=11&yy=&mm=&p_item=
        대신택배    http://home.daesinlogistics.co.kr/daesin/jsp/d_freight_chase/d_general_process2.jsp?billno1=
        일양로지스   http://www.ilyanglogis.com/functionality/tracking_result.asp?hawb_no=
        합동택배    http://www.hdexp.co.kr/parcel/order_result_t.asp?stype=1&p_item=
        GTX로지스  http://www.gtxlogis.co.kr/tracking/default.asp?awblno=
        건영택배    http://www.kunyoung.com/goods/goods_01.php?mulno=
        천일택배    http://www.chunil.co.kr/HTrace/HTrace.jsp?transNo=
        한의사랑택배  http://www.hanips.com/html/sub03_03_1.html?logicnum=
        한덱스 http://www.hanjin.co.kr/Logistics_html
        EMS http://service.epost.go.kr/trace.RetrieveEmsTrace.postal?ems_gubun=E&POST_CODE=
        DHL http://www.dhl.co.kr/content/kr/ko/express/tracking.shtml?brand=DHL&AWB=
        TNTExpress  http://www.tnt.com/webtracker/tracking.do?respCountry=kr&respLang=ko&searchType=CON&cons=
        UPS http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=
        Fedex   http://www.fedex.com/Tracking?ascend_header=1&clienttype=dotcomreg&cntry_code=kr&language=korean&tracknumbers=
        USPS    http://www.tnt.com/webtracker/tracking.do?respCountry=kr&respLang=ko&searchType=CON&cons=
        i-Parcel    https://tracking.i-parcel.com/Home/Index?trackingnumber=
        DHL Global Mail http://webtrack.dhlglobalmail.com/?trackingnumber=
        범한판토스   http://totprd.pantos.com/jsp/gsi/vm/popup/notLoginTrackingListExpressPoPup.jsp?quickType=HBL_NO&quickNo=
        에어보이 익스프레스  http://www.airboyexpress.com/Tracking/Tracking.aspx?__EVENTTARGET=ctl00$ContentPlaceHolder1$lbtnSearch&__EVENTARGUMENT=__VIEWSTATE:/wEPDwUKLTU3NTA3MDQxMg9kFgJmD2QWAgIDD2QWAgIED2QWBGYPDxYCHgdWaXNpYmxlaGRkAgYPDxYCHwBnZGQYAQUeX19Db250cm9sc1JlcXVpcmVQb3N0QmFja
        GSMNtoN http://www.gsmnton.com/gsm/handler/Tracking-OrderList?searchType=TrackNo&trackNo=
        APEX(ECMS Express)  http://www.apexglobe.com
        KGL 네트웍스    http://www.hydex.net/ehydex/jsp/home/distribution/tracking/tracingView.jsp?InvNo=
        굿투럭 http://www.goodstoluck.co.kr/#modal
        호남택배    http://honamlogis.co.kr
        **********************************************************************************************************************/

        // 배송추적 팝업
        function trackingDelivery(company,tranNo){
            var trans_url ="";
            if(company == '01'){//현대택배
                trans_url = "http://www.hlc.co.kr/hydex/jsp/tracking/trackingViewCus.jsp?InvNo="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '02'){//한진택배
                trans_url = "http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '03'){//하나로택배
                trans_url = "http://www.hanarologis.com/branch/chase/listbody.html?a_gb=center&a_cd=4&a_item=0&fr_slipno="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '04'){//KT로지스
                trans_url = "http://www.kglogis.co.kr/delivery/delivery_result.jsp?item_no="+tranNo;
            }else if(company == '05'){//CJ택배
                trans_url = "http://www.cjgls.co.kr/kor/service/service02_01.asp?slipno="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '06'){//CJ HTH택배
                trans_url = "http://www.doortodoor.co.kr/servlets/cmnChnnel?tc=dtd.cmn.command.c03condiCrg01Cmd&amp;amp;invc_no="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '07'){//천일택배
                trans_url = "http://www.cyber1001.co.kr/kor/taekbae/HTrace.jsp?transNo="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '08'){//아주택배
                Dmall.LayerUtil.alert("아주택배 > 존재하지 않는 택배사입니다.","안내");
            }else if(company == '09'){//동부익스프레스
                trans_url = "http://www.dongbuexpress.co.kr/Html/Delivery/DeliveryCheck.jsp?mode=SEARCH&search_type=1&search_item_no="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '10'){//옐로우캡 택배
                trans_url = "http://www.yellowcap.co.kr/custom/inquiry_result.asp?INVOICE_NO="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '11'){//우리택배
                Dmall.LayerUtil.alert("우리택배 > 존재하지 않는 택배사입니다.","안내");
            }else if(company == '12'){//KGB택배
                trans_url = "http://www.kgbls.co.kr/sub5/trace.asp?f_slipno="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '13'){//로젠택배
                //trans_url = "http://d2d.ilogen.com/d2d/delivery/invoice_tracesearch_quick.jsp?slipno="+tranNo;
            	trans_url = "http://www.ilogen.com/m/personal/trace.pop/"+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '14'){//중앙택배
                Dmall.LayerUtil.alert("중앙택배 > 존재하지 않는 택배사입니다.","안내");
            }else if(company == '15'){//경동택배
                trans_url = "http://t.kdexp.com/rerere.asp?stype=11&yy=&mm=&p_item="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '16'){//우체국택배
                trans_url = "http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '17'){//용마택배
                trans_url = "http://eis.yongmalogis.co.kr/dm/DmTrc060?ordno="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '18'){//드림택배
                trans_url = "http://www.idreamlogis.com/delivery/popup_tracking.jsp?item_no="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '19'){//롯데택배
                trans_url = " https://www.lotteglogis.com/open/tracking?invno="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '98'){//직접배송
                Dmall.LayerUtil.alert("수령방식이 택배가 아닙니다.","안내");
            }
        }


        // 송장 일괄 등록
        function goToInvoiceAdd() {
            location.href = '/admin/seller/order/invoice-list';
        }
        </script>
        </t:putAttribute>
        <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <h2 class="tlth2">송장입력(건별) </h2>
            <div class="btn_box right">
                <a href="#" onclick="javascript:goToInvoiceAdd();" class="btn blue">송장 입력(대량)</a>
            </div>
        </div>
        <!-- search_box -->
        <div class="search_box">
                <form:form id="form_ord_search" commandName="deliverySO">
                    <input type="hidden" name="page" id="search_id_page" value="${deliverySO.page}"/>
                    <input type="hidden" name="sord" id="hd_srod"  value="${deliverySO.sord}"/>
                    <input type="hidden" name="rows" id="hd_rows"  value="${deliverySO.rows}"/>
            <!-- search_tbl -->
            <div class="search_tbl">
                <table summary="이표는 출고(배송)관리 검색 표 입니다. 구성은 주문일, 주문상태, 판매채널, 검색어 입니다.">
                    <caption>출고(배송)관리 검색</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>주문일</th>
                            <td>
                                <span class="select">
                                    <label for="dayTypeCd"></label>
                                    <select name="dayTypeCd" id="dayTypeCd">
                                        <option value="01">주문일</option>
                                        <option value="02">배송시작일시</option>
                                    </select>
                                </span>
                                <tags:calendar from="ordDayS" to="ordDayE" fromValue="${deliverySO.ordDayS}" toValue="${deliverySO.ordDayE}" hasTotal="true" idPrefix="srch" />
                            </td>
                        </tr>
                        <tr>
                            <th>주문상태</th>
                            <td>
                                <c:set var="checked" value=""/>
                                <c:set var="on" value=""/>
                                <c:forEach var="statusCd" items="${ordStatusCdList}" varStatus="status">
                                    <c:forEach var="ordSoStatusCd" items="${deliverySO.ordStatusCd}" varStatus="status2">
                                        <c:if test="${statusCd.dtlCd eq ordSoStatusCd}" >
                                            <c:set var="on" value=" on"/>
                                            <c:set var="checked" value="  checked=\"checked\""/>
                                        </c:if>
                                    </c:forEach>
                                    <label for="ordStatusCd" class="chack mr20${on}">
                                    <span class="ico_comm">&nbsp;</span>
                                    <input type="checkbox" name="ordStatusCd" id="ordStatusCd" class="blind" value="<c:out value="${statusCd.dtlCd}"/>" ${checked}/>
                                    <span class="txt <c:out value="${statusCd.userDefien5}"/>"><c:out value="${statusCd.dtlNm}"/></span>
                                    </label>
                                <c:set var="checked" value=""/>
                                <c:set var="on" value=""/>
                                </c:forEach>
                            </td>
                        </tr>
                        <tr>
                            <th>판매채널</th>
                            <td>
                                <c:forEach var="listCd" items="${deliverySO.saleChannelCd}" varStatus="status2">
                                    <c:if test="${'shop9999' eq listCd}" >
                                        <c:set var="on" value=" on"/>
                                        <c:set var="checked" value="  checked=\"checked\""/>
                                    </c:if>
                                </c:forEach>
                                <label for="saleChannelCd_shop9999" class="chack mr20${on}">
                                <span class="ico_comm">
                                <input type="checkbox" name="saleChannelCd" id="saleChannelCd_shop9999" class="blind" value="shop9999" ${checked}/>
                                </span>
                                자체쇼핑몰
                                </label>
                                <c:set var="checked" value=""/>
                                <c:set var="on" value=""/>
                                
                               <c:forEach var="getCd" items="${saleChannelCdList}" varStatus="status">
                                    <c:forEach var="listCd" items="${deliverySO.saleChannelCd}" varStatus="status2">
                                        <c:if test="${getCd.dtlCd eq listCd}" >
                                            <c:set var="on" value=" on"/>
                                            <c:set var="checked" value="  checked=\"checked\""/>
                                        </c:if>
                                    </c:forEach>
                                    <label for="saleChannelCd" class="chack mr20${on}">
                                    <span class="ico_comm">
                                    <input type="checkbox" name="saleChannelCd" id="saleChannelCd" class="blind" value="<c:out value="${getCd.dtlCd}"/>" ${checked}/>
                                    </span>
                                    <c:out value="${getCd.dtlNm}"/>
                                    </label>
                                <c:set var="checked" value=""/>
                                <c:set var="on" value=""/>
                                </c:forEach>
                                <a href="#none" class="all_choice"><span class="ico_comm"></span> 전체</a>
                            </td>
                        </tr>
                        <tr>
                            <th>검색어</th>
                            <td>
                                <div class="select_inp">
                                    <span>
                                        <label for="searchCd"></label>
                                        <select id="radio_id_searchCd" id="searchCd" name="searchCd">
                                            <tags:option codeStr="01:주문번호;02:주문자;08:상품명;"  value="${deliverySO.searchCd}"/>
                                        </select>
                                    </span>
                                    <input type="text" id="searchWord" name="searchWord" value="${deliverySO.searchWord}" />
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            </form:form>
            <!-- //search_tbl -->
            <div class="btn_box txtc">
                <button class="btn green" id="ord_search_btn">검색</button>
            </div>
        </div>
        <!-- //search_box -->
        <!-- line_box -->
        <div class="line_box">
            <div class="top_lay">
                <div class="search_txt">
                    검색 <strong class="be" id="cnt_search">0</strong>개 /
                    총 <strong class="all" id="cnt_total">0</strong>개
                </div>
                <div class="select_btn">
                    <span class="select">
                        <label for="sel_sord"></label>
                        <select name="sord" id="sel_sord">
                            <tags:option codeStr="A.REG_DTTM DESC:최근 등록일 순;A.REG_DTTM ASC:나중 등록일 순;A.UPD_DTTM DESC:최근 수정일 순;A.UPD_DTTM ASC:나중 수정일 순" />
                        </select>
                    </span>
                    <span class="select">
                        <label for="sel_rows"></label>
                        <select name="rows" id="sel_rows">
                            <tags:option codeStr="10:10개 출력;30:30개 출력;50:50개 출력"  value="${deliverySO.rows}"/>
                        </select>
                    </span>
                    <button class="btn_exl" id="excelDown">Excel download <span class="ico_comm">&nbsp;</span></button>
                </div>
            </div>
            <!-- tblh -->
            <div class="tblh ">
                <table summary="이표는 주문 관리 리스트 표 입니다. 구성은 선택, 번호, 주문일시, 환경, 주문번호, 주문상품, 판매채녈, 수신자/주문자, 결제수단, 결제금액, 결제일시, 주문상태 입니다.">
                    <caption>주문 관리 리스트</caption>
                    <colgroup>
                        <col width="7%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="21%">
                        <col width="8%">
                        <col width="8%">
                        <col width="8%">
                        <col width="8%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>주문일시</th>
                            <th>판매자</th>
                            <th>배송시작일시</th>
                            <th>주문번호</th>
                            <th>주문상품</th>
                            <th>주문자</th>
                            <th>판매채널</th>
                            <th>배송상태</th>
                            <th>배송추적</th>
                        </tr>
                    </thead>
                    <tbody id = "ajaxOrdList">
                    </tbody>
                </table>
            </div>
            <!-- //tblh -->
            <!-- bottom_lay -->
            <div class="bottom_lay">
                <div class="bottom_lay" id="div_paging"></div>
            </div>
            <!-- //bottom_lay -->
        </div>
        <!-- //line_box -->
    </div>
<!-- //content -->

    <form:form id="form_delivery">
        <input type="hidden" name="dlvrNo" value=''/>
        <input type="hidden" name="siteNo" value='<c:out value="${siteNo}"/>'/>
        <input type="hidden" name="ordNo"/>
        <input type="hidden" name="ordDtlSeq" value=''/>
        <input type="hidden" name="goodsNo" />
        <input type="hidden" name="ordStatusCd"/>
        <input type="hidden" name="rlsCourierCd"/>
        <input type="hidden" name="rlsInvoiceNo"/>
        <input type="hidden" name="dlvrcPaymentCd"/>
        <input type="hidden" name="dlvrQtt" />
        <input type="hidden" name="dlvrMsg"/>
    </form:form>

    </t:putAttribute>
</t:insertDefinition>