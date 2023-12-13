<%------------------------------------------------------------------------------
 FILE NAME : INIcancel.jsp
 AUTHOR : rywkim@inicis.com
 DATE : 2007/01
 USE WITH : INIcancel.html, config.jsp, INIpayJAVA.jar
 
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
  data.setData("type", "cancel");                                   // 결제 type
  data.setData("inipayHome", inipayHome);                           // 이니페이가 설치된 절대경로
  data.setData("logMode", logMode);                                 // logMode
  data.setData("keyPW",keyPW);                                      // 키패스워드
  data.setData("subPgip","203.238.37.3");                           // Sub PG IP (고정)
  data.setData("mid", request.getParameter("mid"));                 // 상점아이디
  data.setData("tid", request.getParameter("tid") );                // 취소할 TID
  data.setData("cancelMsg", request.getParameter("cancelMsg") );    // INIpay User ID
  data.setData("uip", request.getRemoteAddr());                     // IP Addr
  data.setData("crypto", "execure");                                // Extrus 암호화 모듈 적용(고정)

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
