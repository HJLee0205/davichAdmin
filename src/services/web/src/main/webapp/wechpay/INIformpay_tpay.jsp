<!------------------------------------------------------------------------------
FILE NAME : INIformpay_tpay.jsp
AUTHOR : mi@inicis.com
DATE : 2016/05
USE WITH : INIformpay_tpay.html, config.jsp, INIpayJAVA.jar

Copyright 2016 Inicis, Co. All rights reserved.
------------------------------------------------------------------------------->

<%@ page language = "java" contentType = "text/html; charset=euc-kr" %>
<%@ page import = "com.inicis.inipay4.INIpay" %>
<%@ page import = "com.inicis.inipay4.util.INIdata" %>


<%@ include file="config.jsp"%>
<%
//#############################################################################
//# 1. 인스턴스 생성 #
//####################
  INIpay inipay = new INIpay();
  INIdata data = new INIdata();



//#############################################################################
//# 2. 정보 설정 #
//################
  data.setData("type", "formpay");                                  // 결제 type
  data.setData("inipayHome", inipayHome);                           // 이니페이가 설치된 절대경로
  data.setData("logMode", logMode);                                 // logMode
  data.setData("keyPW",keyPW);                                      // 키패스워드
  data.setData("subPgip","203.238.37.3");                           // Sub PG IP (고정)
  
  data.setData("paymethod", "TPAY");                                // 지불수단 (고정)
  data.setData("svccode", "W");                                     // 지불수단 TPAY인 경우, 위챗페이 (W) 고정
  data.setData("wech_authcode", request.getParameter("wech_authcode"));               // 인증코드 
  data.setData("wech_companynumber", request.getParameter("wech_companynumber"));       // 서브가맹점사업자번호
  
  data.setData("mid", request.getParameter("mid"));                 // 상점아이디
  data.setData("uid", request.getParameter("mid") );                // INIpay User ID
  data.setData("goodname", request.getParameter("goodname"));       // 상품명 (최대 40자)
  data.setData("currency", request.getParameter("currency"));       // 화폐단위
  data.setData("price", request.getParameter("price"));             // 가격
  data.setData("buyername", request.getParameter("buyername"));     // 구매자 (최대 15자)
  data.setData("buyertel", request.getParameter("buyertel"));       // 구매자이동전화
  data.setData("buyeremail", request.getParameter("buyeremail"));   // 구매자이메일
  data.setData("url", "http://www.your_domain.co.kr");              // 홈페이지 주소(URL)
  data.setData("uip", request.getRemoteAddr());                     // IP Addr
  data.setData("crypto", "execure");

//###############################################################################
//# 3. 지불 요청 #
//################  
  data = inipay.payRequest(data);

  
//###############################################################################
//# 4. ACK 요청 및 DB처리 #
//################ 
  if ("00".equals(data.getData("ResultCode"))) {
    if (inipay.payAck()) {
        // DB 처리
    }
  }




%>

<html>
    <head>

        <title>INIpay</title>
        <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

        <script>
            var openwin = window.open("childwin.html", "childwin", "width=300,height=160");
            openwin.close();

            function show_receipt(tid)
            {
                if ("<%=data.getData("resultCode")%>" == "00")
                {
                    var receiptUrl = "https://iniweb.inicis.com/mall/cr/cm/mCmReceipt_head.jsp?" +
                            "noTid=" + tid + "&noMethod=1";
                    window.open(receiptUrl, "receipt", "width=428,height=741");
                } else
                {
                    alert("해당하는 지불 거래가 없습니다");
                }
            }
        </script>

        <style type="text/css">
            BODY{font-size:9pt; line-height:160%}
            TD{font-size:9pt; line-height:160%}
            INPUT{font-size:9pt;}
            .emp{background-color:#E0EFFE;}
        </style>

    </head>

    <body>
        <table border=0 width=500>
            <tr>
                <td>
                    <hr noshade size=1>
                    <b>지불 결과</b>
                    <hr noshade size=1>
                </td>
            </tr>
        </table>
        <br>
        <%
        String resultCode = "";
        String resultMessage = "";

        %>
        <table border=0 width=500>
            <tr>
                <td align=right nowrap>지불방법 : </td><td><%=data.getData("paymethod")%></td>
            </tr>
            <tr>
                <td align=right nowrap>결과코드 : </td><td><%=data.getData("ResultCode")%></td>
            </tr>
            <tr>
                <td align=right nowrap>결과내용 : </td><td><font class=emp><%=data.getData("ResultMsg")%></font></td>
            </tr>
            <tr>
                <td align=right nowrap>거래번호 : </td><td><%=data.getData("tid")%></td>
            </tr>
            <tr>
                <td align=right nowrap>결제요청금액 : </td><td><%=data.getData("price")%></td>
            </tr>
            <tr>
                <td align=right nowrap>PG승인날짜 : </td><td><%=data.getData("PGauthdate")%></td>
            </tr>
            <tr>
                <td align=right nowrap>PG승인시간 : </td><td><%=data.getData("PGauthtime")%></td>
            </tr>
            <tr>
                <td align=right nowrap>위챗주문번호 : </td><td><%=data.getData("WECH_TransactionID")%></td>
            </tr>              
            <tr>
                <td align=right nowrap>환율 : </td><td><%=data.getData("RateExchange")%></td>
            </tr>            
            <tr>
                <td align=right nowrap>환율계산금액 : </td><td><%=data.getData("ReqPrice")%></td>
            </tr>      
            <tr>
                <td colspan=2 align=center>
                    <br><input type=button value="영수증보기" onclick=javascript:show_receipt('<%=data.getData("tid")%>')><br><br>
                </td>
            </tr>
            <tr>
                <td colspan=2><hr noshade size=1></td>
            </tr>
            <tr>
                <td align=right colspan=2>Copyright Inicis, Co.<br>www.inicis.com</td>
            </tr>
        </table>
    </body>
</html>

