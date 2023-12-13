<%------------------------------------------------------------------------------
 FILE NAME : INIcancel_sid.jsp
 AUTHOR : mi@inicis.com
 DATE : 2017/01
 USE WITH : INIcancel_sid.jsp, config.jsp, INIpayJAVA.jar
 
 지불 취소 요청을 처리한다.
 
 Copyright 2007 Inicis, Co. All rights reserved.
------------------------------------------------------------------------------%>

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
  data.setData("type", "sidcancel");                                // 결제 type
  data.setData("inipayHome", inipayHome);                           // 이니페이가 설치된 절대경로
  data.setData("logMode", logMode);                                 // logMode
  data.setData("keyPW","1111");                                     // Sub PG IP (고정)
  data.setData("mid", request.getParameter("mid"));                 // 상점아이디
  data.setData("sid", request.getParameter("sid") );                // 취소할 SID
  data.setData("paymethod", request.getParameter("paymethod") );    // 취소할 SID 지불수단 (위챗페이 : TPAY)
  data.setData("svccode", request.getParameter("svccode") );        // 취소할 SID svc_code : paymethod = TPAY 인 경우, W
  data.setData("cancelMsg", request.getParameter("cancelMsg") );    // INIpay User ID
  data.setData("uip", request.getRemoteAddr());                     // IP Addr
  data.setData("crypto", "execure");

//###############################################################################
//# 3. 취소 요청 #
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
                    <b>지불 취소 결과</b>
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
                <td align=right nowrap>취소날짜 : </td><td><%=data.getData("PGcanceldate")%></td>
            </tr>
            <tr>
                <td align=right nowrap>취소시각 : </td><td><%=data.getData("PGcanceltime")%></td>
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
