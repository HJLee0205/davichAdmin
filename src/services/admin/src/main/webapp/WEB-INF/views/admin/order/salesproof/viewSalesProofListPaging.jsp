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
    <t:putAttribute name="title">매출 증빙 > 주문</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_ord_search', getList);

                // 매출증빙 목록 조회
                <c:if test="${salesProofSO.ordDayS eq null}">
                $('#btn_srch_cal_1').trigger('click');
                </c:if>
                getList();

                // 검색
                $('#ord_search_btn').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#hd_page').val(1);
                    getList();
                });

                // 엑셀 다운로드
                $('#excelDown').on('click', function () {
                    $('#form_ord_search').attr('action', '/admin/order/salesproof/salesproof-excel-download');
                    $('#form_ord_search').submit();
                });

                // 보기
                $(document).on('click', '#btn_viewReq', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var proofNo = $(this).parents('tr').data('list-no');
                    var proofType = $(this).parents('tr').data('list-type');

                    if (proofType == '02') {//현금영수증
                        Dmall.LayerPopupUtil.open($('#layout_cash'));
                        return;
                        var url = '/admin/order/salesproof/cash-receipt';
                        var param = {proofNo: proofNo};
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if (result.success) {
                                jQuery('#form_cash input[name=ordNo]').val(result.data.ordNo);
                                jQuery('#form_cash input[name=proofNo]').val(proofNo);
                                jQuery('#form_cash input[name=issueWayNo]').val(result.data.issueWayNo);
                                jQuery('#form_cash input[name=telNo]').val(result.data.telNo);
                                jQuery('#form_cash input[name=email]').val(result.data.email);
                                jQuery('#form_cash input[name=applicantNm]').val(result.data.applicantNm);
                                jQuery('#form_cash input[name=goodsNm]').val(result.data.goodsNm);
                                jQuery('#form_cash input[name=totAmt]').val(Number(result.data.totAmt));
                                jQuery('#form_cash input[name=supplyAmt]').val(Number(result.data.supplyAmt));
                                jQuery('#form_cash input[name=vatAmt]').val(Number(result.data.vatAmt));
                                document.getElementById('btn_reset_cash').style.display = 'none';
                                jQuery('#rct_text').text("현금영수증");
                                jQuery('#rct_text_span').text("");
                                document.getElementById('btn_ordNo').style.display = 'none';
                                Dmall.LayerPopupUtil.open($('#layout_cash'));
                            }
                        });
                    } else if (proofType == '03') {// 세금계산서
                        Dmall.LayerPopupUtil.open($('#layout_tax'));
                        return;
                        var url = '/admin/order/salesproof/taxbill';
                        var param = {proofNo: proofNo};
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if (result.success) {
                                jQuery('#form_tax input[name=ordNo]').val(result.data.ordNo);
                                jQuery('#form_tax input[name=proofNo]').val(proofNo);

                                jQuery('#form_tax input[name=companyNm]').val(result.data.companyNm);
                                jQuery('#form_tax input[name=bizNo]').val(result.data.bizNo);
                                jQuery('#form_tax input[name=ceoNm]').val(result.data.ceoNm);
                                jQuery('#form_tax input[name=bsnsCdts]').val(result.data.bsnsCdts);
                                jQuery('#form_tax input[name=item]').val(result.data.item);
                                jQuery('#form_tax input[name=postNo]').val(result.data.postNo);
                                jQuery('#form_tax input[name=roadnmAddr]').val(result.data.roadnmAddr);
                                jQuery('#form_tax input[name=numAddr]').val(result.data.numAddr);
                                jQuery('#form_tax input[name=dtlAddr]').val(result.data.dtlAddr);
                                jQuery('#form_tax input[name=managerNm]').val(result.data.managerNm);

                                jQuery('#form_tax input[name=telNo]').val(result.data.telNo);
                                jQuery('#form_tax input[name=email]').val(result.data.email);

                                jQuery('#form_tax input[name=totAmt]').val(Number(result.data.totAmt));
                                jQuery('#form_tax input[name=supplyAmt]').val(Number(result.data.supplyAmt));
                                jQuery('#form_tax input[name=vatAmt]').val(Number(result.data.vatAmt));
                                document.getElementById('btn_reset_tax').style.display = 'none';
                                jQuery('#tax_text').text("세금계산서");
                                jQuery('#tax_text_span').text("");
                                document.getElementById('btn_ordNoTax').style.display = 'none';
                                Dmall.LayerPopupUtil.open($('#layout_tax'));
                            }
                        });
                    }
                });
            });

            function getList() {
                var url = '/admin/order/salesproof/salesproof-list',
                    param = $('#form_ord_search').serialize(),
                    dfd = jQuery.Deferred();

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    var template =
                        '<tr data-list-no="{{proofNo}}" data-list-type="{{proofType}}">' +
                        '<td>{{rowNum}}</td>' +
                        '<td>{{ordStatusNm}}</td>' +
                        '<td>{{ordDay}}</td>' +
                        '<td>{{ordNo}}</td>' +
                        '<td>{{paymentWayNm}}</td>' +
                        '<td>{{ordrNm}}</td>' +
                        '<td>{{regDttm}}</td>';
                    var templateProofViewY = '<td><button class=btn_gray id="btn_viewReq">보기</button></td>';
                    var templateProofViewN = '<td></td>';
                    var templateProofType = '';
                    var templateAnother = '<td>공급가 : {{mainAmt}} 원<br>부가세 : {{vatAmt}} 원<br>합 계 : {{paymentAmt}}원</td>' +
                        '<td>{{linkYn}}</td>' +
                        '<td>{{proofStatusNm}}</td>' +
                        '</tr>';

                    mgrTemplate = new Dmall.Template(template);
                    mgrTemplateAnother = new Dmall.Template(templateAnother);
                    tr = '';

                    jQuery.each(result.resultList, function (idx, obj) {
                        tr += mgrTemplate.render(obj);
                        //신청정보 버튼 템플릿 추가
                        if (obj.proofType == '01') {
                            tr += templateProofViewN;
                        } else {
                            tr += templateProofViewY;
                        }
                        //증빙자료 버튼 템플릿 추가
                        if (obj.proofType == '01') {
                            templateProofType = '<td><a href="#none" class="btn_gray" onclick="show_card_bill(\'{{paymentPgCd}}\',\'{{linkTxNo}}\', \'{{ordNo}}\', \'{{paymentAmt}}\');">{{proofNm}}</a></td>';
                        } else if (obj.proofType == '02') {
                            templateProofType = '<td><a href="#none" class="btn_gray" onclick="show_cash_receipt(\'{{paymentPgCd}}\', \'{{linkTxNo}}\', \'{{ordNo}}\', \'{{paymentAmt}}\');">{{proofNm}}</a></td>';
                        } else {
                            templateProofType = '<td><a href="#none" class="btn_gray" onclick="show_tax_bill();">{{proofNm}}</a></td>';
                        }
                        mgrTemplateProofType = new Dmall.Template(templateProofType);

                        tr += mgrTemplateProofType.render(obj);
                        tr += mgrTemplateAnother.render(obj);
                    });

                    if (tr == '') {
                        tr = '<tr><td colspan="12">데이터가 없습니다.</td></tr>';
                    }

                    $('#ajaxOrdList').html(tr);
                    dfd.resolve(result.resultList);

                    Dmall.GridUtil.appendPaging('form_ord_search', 'div_paging', result, 'paging_ord', getList);

                    $("#cnt_total").text(result.filterdRows);

                    return dfd.promise();
                });
            }

            /*  신용카드결제정보 조회 popup
             * pg_cd : pg사코드
             * tid : 연계승인코드
             */
            function show_card_bill(pgCd, tid, ordNo, totAmt) {
                // 추가할 변수
                var mid = $("#mid").val(); //상점ID
                var confirmHashData = $("#confirmHashData").val(); // 검증용 Hash값
                var confirmNo = $("#confirmNo").val(); // 승인번호
                var confirmDttm = $("#confirmDttm").val(); // 승인일시(8자리)
                var mode = "test";  //서비스 구분 ( test:테스트서버,  service:실서버 )

                if (pgCd == '01') {// KCP
                    window.open("https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&tno=" + tid + "&order_no=" + ordNo + "&trade_mony=" + totAmt, "kcpReceipt", "width=470,height=815");
                } else if (pgCd == '02') {//이니시스
                    window.open("https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=" + tid + "&noMethod=1", "iniReceipt" + tid, "width=405,height=525");
                } else if (pgCd == '03') {//LGU
                    var showreceiptUrl = "http://pgweb.dacom.net" + (mode == "test" ? ":7080" : "") + "/pg/wmp/etc/jsp/Receipt_Link.jsp?mertid=" + mid + "&tid=" + tid + "&authdata=" + confirmHashData;
                    window.open(showreceiptUrl, "showreceipt", "width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
                } else if (pgCd == '04') { //ALLTHEGATE
                    var showreceiptUrl = "http://allthegate.com/customer/receiptLast3.jsp?sRetailer_id=" + mid + "&approve=" + confirmNo + "&send_no=" + tid + "&send_dt=" + confirmDttm;
                    window.open(showreceiptUrl, "showreceipt", "width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
                } else {
                    Dmall.LayerUtil.alert("해당하는 PG사 코드가 없습니다.", "알림");
                }
            }

            /*
             * 현금영수증조회 popup
             * pg_cd : pg사코드
             * tid : 연계승인코드
             */
            function show_cash_receipt(pgCd, tid, ordNo, totAmt) {
                // 추가할 변수
                var paymentWayCd = $("#paymentWayCd").val(); // 결제수단코드
                var mid = $("#mid").val(); //상점ID
                var confirmNo = $("#confirmNo").val(); // 승인번호
                var confirmDttm = $("#confirmDttm").val(); // 승인일시(8자리)
                var mode = "test";  //서비스 구분 ( test:테스트서버,  service:실서버 )

                if (pgCd == '01') {// KCP
                    var showreceiptUrl = "https://admin8.kcp.co.kr/assist/bill.BillActionNew.do?cmd=cash_bill&cash_no=" + tid + "&order_no=" + ordNo + "&trade_mony=" + totAmt;
                    window.open(showreceiptUrl, "showreceipt", "width=420,height=670, scrollbars=no,resizable=no");
                } else if (pgCd == '02') { //이니시스
                    var showreceiptUrl = "https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/Cash_mCmReceipt.jsp?noTid=" + tid + "&clpaymethod=22";
                    window.open(showreceiptUrl, "showreceipt", "width=380,height=540, scrollbars=no,resizable=no");
                } else if (pgCd == '03') { //LGU
                    var paramStr = "";
                    var stype = "";

                    if (mid == "" || ordNo == "") {
                        return;
                    } else {
                        if (paymentWayCd == "23") stype = "SC0010"; //신용카드
                        else if (paymentWayCd == "21") stype = "SC0030"; //계좌이체
                        else if (paymentWayCd == "22") stype = "SC0040"; //무통장

                        if (stype == "CAS" || stype == "cas" || stype == "SC0040") {
                            stype = "SC0040";
                            if (seqno == "") seqno = "001";
                            paramStr = "orderid=" + ordNo + "&mid=" + mid + "&seqno=" + seqno + "&servicetype=" + stype;
                        } else if (stype == "BANK" || stype == "bank" || stype == "SC0030") {
                            stype = "SC0030";
                            paramStr = "orderid=" + ordNo + "&mid=" + mid + "&servicetype=" + stype;
                        } else if (stype == "CR" || stype == "cr" || stype == "SC0100") {
                            stype = "SC0100";
                            paramStr = "orderid=" + ordNo + "&mid=" + mid + "&servicetype=" + stype;
                        }

                        var showreceiptUrl = "http://pg.dacom.net" + (mode == "service" ? "" : ":7080") + "/transfer/cashreceipt_mp.jsp?" + paramStr;
                        window.open(showreceiptUrl, "showreceipt", "width=380,height=600,menubar=0,toolbar=0,scrollbars=no,resizable=no, resize=1,left=252,top=116");
                    }
                } else if (pgCd == '04') { //ALLTHEGATE
                    var showreceiptUrl = "http://allthegate.com/customer/receiptLast3.jsp?sRetailer_id=" + mid + "&approve=" + confirmNo + "&send_no=" + tid + "&send_dt=" + confirmDttm;
                    window.open(showreceiptUrl, "showreceipt", "width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
                } else { //국세청조회사이트
                    var showreceiptUrl = "http://www.taxsave.go.kr/servlets/AAServlet?tc=tss.web.aa.ntc.cmd.RetrieveMainPageCmd";
                    window.open(showreceiptUrl, "showreceipt", "width=380,height=540, scrollbars=no,resizable=no");
                }
            }

            /*  세금계산서발급정보 조회 popup
             * pg_cd : pg사코드
             * tid : 연계승인코드
             */
            function show_tax_bill() {
                var showreceiptUrl = "http://www.taxsave.go.kr/servlets/AAServlet?tc=tss.web.aa.ntc.cmd.RetrieveMainPageCmd";
                window.open(showreceiptUrl, "showreceipt", "width=380,height=540, scrollbars=no,resizable=no");
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    주문 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">매출 증빙</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form id="form_ord_search" commandName="salesProofSO">
                        <input type="hidden" name="sord" id="hd_srod" value="${salesProofSO.sord}"/>
                        <input type="hidden" name="rows" id="hd_rows" value="${salesProofSO.rows}"/>
                        <input type="hidden" name="page" id="hd_page" value="${salesProofSO.page}"/>
                        <input type="hidden" id="mid" value="">
                        <input type="hidden" id="mid" value="">
                        <input type="hidden" id="mid" value="">
                        <input type="hidden" id="mid" value="">
                        <input type="hidden" id="mid" value="">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 매출증빙관리 검색 표 입니다. 구성은 마을구분, 반품신청일, 증빙서류, 상태, 신청구분, 환불유무, 검색어 입니다.">
                                <caption>매출증빙관리 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>주문일</th>
                                    <td>
                                        <input type="hidden" name="dayTypeCd" value="01"/>
                                        <tags:calendar from="ordDayS" to="ordDayE" fromValue="${salesProofSO.ordDayS}" toValue="${salesProofSO.ordDayE}" hasTotal="true" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>증빙서류</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>
                                        <tags:checkboxs codeStr="01:매출전표;02:현금영수증;03:세금계산서" name="proofType" idPrefix="proofType"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>신청구분</th>
                                    <td>
                                        <tags:radio codeStr=":전체;01:구매자;02:점주" name="applicantGbCd" idPrefix="applicantGbCd"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="select">
                                            <label for="searchCd"></label>
                                            <select id="searchCd" name="searchCd">
                                                <tags:option codeStr="all:전체;02:주문번호;01:주문자;" value="${salesProofSO.searchCd}"/>
                                            </select>
                                        </span>
                                        <span class="intxt long">
                                            <input type="text" id="searchWord" name="searchWord" value="${salesProofSO.searchWord}"/>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                        <div class="btn_box txtc">
                            <button type="button" class="btn green" id="ord_search_btn">검색</button>
                        </div>
                    </form:form>
                </div>

                <div class="line_box">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total"></strong>개의 신청이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="btn_download">
                                <span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh th_l">
                        <div class="scroll">
                            <table summary="이표는 매출증빙관리 리스트 표 입니다.">
                                <caption>매출증빙관리 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="8%">
                                    <col width="9%">
                                    <col width="13%">
                                    <col width="9%">
                                    <col width="7%">
                                    <col width="9%">
                                    <col width="8%">
                                    <col width="8%">
                                    <col width="11%">
                                    <col width="7%">
                                    <col width="6%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>주문상태</th>
                                    <th>주문일시</th>
                                    <th>주문번호</th>
                                    <th>결제</th>
                                    <th>주문자</th>
                                    <th>신청일</th>
                                    <th>신청정보</th>
                                    <th>증빙자료</th>
                                    <th>증빙금액</th>
                                    <th>처리방법</th>
                                    <th>승인</th>
                                </tr>
                                </thead>
                                <tbody id="ajaxOrdList">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div class="pageing mt10" id="div_paging"></div>
                    </div>
                    <!-- //bottom_lay -->
                </div>
            </div>
        </div>
        <!-- 현금영수증 신청정보 팝업 -->
        <div id="layout_cash" class="layer_popup">
            <div class="pop_wrap size3">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">현금영수증</h2>
                    <button class="close ico_comm" type="button">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                <div class="pop_con">
                    <form:form id="form_cash">
                        <!-- tblw -->
                        <div class="tblw">
                            <table>
                                <colgroup>
                                    <col width="25%">
                                    <col width="75%">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>주문번호</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>발행용도</th>
                                    <td>
                                        <label for="useGbCd_01" class="radio mr20"><span class="ico_comm"><input type="radio" name="useGbCd" id="useGbCd_01"></span> 개인 소득공제용</label>
                                        <label for="useGbCd_02" class="radio"><span class="ico_comm"><input type="radio" name="useGbCd" id="useGbCd_02"></span> 사업자지출 증빙용</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>인증번호</th>
                                    <td>
                                        <span class="select">
                                            <label for="Certification_Number">휴대폰번호</label>
                                            <select name="Certification_Number" id="Certification_Number">&gt;
                                                <option value="1" selected="selected">휴대폰번호</option>
                                                <option value="2">주민등록번호</option>
                                                <option value="3">사업번호</option>
                                            </select>
                                        </span>
                                        <span class="intxt long3">
                                            <input type="text" name="_search_Certification_Number" id="_search_Certification_Number">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>주문자명</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>이메일</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>전화번호</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>상품명</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>발행액</th>
                                    <td>
                                        발행액 : <span class="intxt"></span> 원
                                        <span class="br2"></span>
                                        공급액 : <span class="intxt"></span> 원
                                        <span class="br2"></span>
                                        부가세 : <span class="intxt"></span> 원
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblw -->
                        <div class="btn_box txtc">
                            <button type="button" class="btn green" id="btn_reg_cash">확인</button>
                        </div>
                    </form:form>
                </div>
                <!-- //pop_con -->
            </div>
        </div>
        <!-- 세금계산서 신청정보 팝업 -->
        <div id="layout_tax" class="layer_popup">
            <div class="pop_wrap size3">
                <div class="pop_tlt">
                    <h2 class="tlth2">세금계산서</h2>
                    <button class="close ico_comm" type="button">닫기</button>
                </div>
                <!-- pop_con -->
                <div class="pop_con">
                    <form:form id="form_tax">
                        <input type="hidden" name="proofNo" id="proofNo"  value=""/>
                        <input type="hidden" name="tax_ordno_chk" id="tax_ordno_chk" />
                        <input type="hidden" name="applicantGbCd" id="applicantGbCd"  value="02"/> <!-- 신청자구분코드(01:구매자,02:관리자) -->
                        <!-- tblw -->
                        <div class="tblw">
                            <table summary="이표는 세금계산서 신청하기 표 입니다. 구성은 발급종류, 종류, 주문번호, 상호명, 사업자번호, 대표자명, 업태/업종, 주소, 담당자이름, 담당자 이메일, 전화번호, 금액 입니다.">
                                <caption>세금계산서 신청하기</caption>
                                <colgroup>
                                    <col width="30%">
                                    <col width="70%">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>주문번호</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>종류</th>
                                    <td>
                                        <label for="useGbCd_03" class="radio mr20"><span class="ico_comm"><input type="radio" name="useGbCd" id="useGbCd_03"></span> 과세 세금계산서</label>
                                        <label for="useGbCd_04" class="radio"><span class="ico_comm"><input type="radio" name="useGbCd" id="useGbCd_04"></span> 비과세 세금계산서</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상호명</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>사업자번호</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>대표자명</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>업태/업종</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>주소</th>
                                    <td>
                                        <div class="addr_field nor">
                                            <strong>(도로명)</strong>
                                            <span class="br"></span>
                                            <strong>(지번)</strong>
                                            <span class="br"></span>
                                            <strong>(상세)</strong>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>담당자 이름</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>담당자 이메일</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>전화번호</th>
                                    <td></td>
                                </tr>
                                <tr>
                                    <th>금액</th>
                                    <td>
                                        발행액 : <span class="intxt"></span> 원
                                        <span class="br2"></span>
                                        공급액 : <span class="intxt"></span> 원
                                        <span class="br2"></span>
                                        부가세 : <span class="intxt"></span> 원
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblw -->
                        <div class="btn_box txtc">
                            <button type="button" class="btn green" id="btn_reg_tax">확인</button>
                        </div>
                    </form:form>
                </div>
                <!-- //pop_con -->
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>