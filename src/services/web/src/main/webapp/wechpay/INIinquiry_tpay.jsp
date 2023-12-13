<!------------------------------------------------------------------------------
FILE NAME : INIinquiry_tpay.jsp
AUTHOR : mi@inicis.com
DATE : 2016/05
USE WITH : INIinquiry_tpay.html, config.jsp, INIpayJAVA.jar

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
  data.setData("type", "inquiry");                                   // 결제 type
  data.setData("inipayHome", inipayHome);                           // 이니페이가 설치된 절대경로
  data.setData("logMode", logMode);                                 // logMode
  data.setData("keyPW","1111");                                      // Sub PG IP (고정)
  data.setData("mid", request.getParameter("mid"));                 // 상점아이디
  data.setData("tid", request.getParameter("tid") );                // 조회할 TID
  data.setData("uip", request.getRemoteAddr());                     // IP Addr
  data.setData("crypto", "execure");

//###############################################################################
//# 3. 조회 요청 #
//################
  data = inipay.payRequest(data);

%>


<html>
    <head>

        <title>INIpay</title>
        <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

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
                    <b>거래 조회 결과</b>
                    <hr noshade size=1>
                </td>
            </tr>
        </table>
        <br>
        <table border=0 width=500>
            <tr>
                <td align=right nowrap>결과코드 : </td><td><%=data.getData("ResultCode")%></td>
            </tr>
            <tr>
                <td align=right nowrap>결과내용 : </td><td><font class=emp><%=data.getData("ResultMsg")%></font></td>
            </tr>
            <tr>
                <td align=right nowrap>위챗주문번호 : </td><td><%=data.getData("WECH_TransactionID")%></td>
            </tr>                      
            <tr>
                <td align=right nowrap>거래상태 : </td><td><%=data.getData("State")%></td>
            </tr>
            <tr>
                <td align=right nowrap></td><td>0:승인, 1:취소, 2:결제진행중, 9:거래없음</td>
            </tr>
            <tr>
                <td colspan=2><br><hr noshade size=1></td>
            </tr>
            <tr>
                <td align=right colspan=2>Copyright Inicis, Co.<br>www.inicis.com</td>
            </tr>
        </table>
    </body>
</html>
