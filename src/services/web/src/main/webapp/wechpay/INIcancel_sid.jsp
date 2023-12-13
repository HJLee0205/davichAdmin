<%------------------------------------------------------------------------------
 FILE NAME : INIcancel_sid.jsp
 AUTHOR : mi@inicis.com
 DATE : 2017/01
 USE WITH : INIcancel_sid.jsp, config.jsp, INIpayJAVA.jar
 
 ���� ��� ��û�� ó���Ѵ�.
 
 Copyright 2007 Inicis, Co. All rights reserved.
------------------------------------------------------------------------------%>

<%@ page language = "java" contentType = "text/html; charset=euc-kr" %>
<%@ page import = "com.inicis.inipay4.INIpay" %>
<%@ page import = "com.inicis.inipay4.util.INIdata" %>

<%@ include file="config.jsp"%>
<%

//#############################################################################
//# 1. �ν��Ͻ� ���� #
//####################
  INIpay inipay = new INIpay();
  INIdata data = new INIdata();

//#############################################################################
//# 2. ���� ���� #
//################
  data.setData("type", "sidcancel");                                // ���� type
  data.setData("inipayHome", inipayHome);                           // �̴����̰� ��ġ�� ������
  data.setData("logMode", logMode);                                 // logMode
  data.setData("keyPW","1111");                                     // Sub PG IP (����)
  data.setData("mid", request.getParameter("mid"));                 // �������̵�
  data.setData("sid", request.getParameter("sid") );                // ����� SID
  data.setData("paymethod", request.getParameter("paymethod") );    // ����� SID ���Ҽ��� (��ê���� : TPAY)
  data.setData("svccode", request.getParameter("svccode") );        // ����� SID svc_code : paymethod = TPAY �� ���, W
  data.setData("cancelMsg", request.getParameter("cancelMsg") );    // INIpay User ID
  data.setData("uip", request.getRemoteAddr());                     // IP Addr
  data.setData("crypto", "execure");

//###############################################################################
//# 3. ��� ��û #
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
                    <b>���� ��� ���</b>
                    <hr noshade size=1>
                </td>
            </tr>
        </table>
        <br>
        <table border=0 width=500>
            <tr>
                <td align=right nowrap>����ڵ� : </td><td><%=data.getData("ResultCode")%></td>
            </tr>
            <tr>
                <td align=right nowrap>������� : </td><td><font class=emp><%=data.getData("ResultMsg")%></font></td>
            </tr>
            <tr>
                <td align=right nowrap>��ҳ�¥ : </td><td><%=data.getData("PGcanceldate")%></td>
            </tr>
            <tr>
                <td align=right nowrap>��ҽð� : </td><td><%=data.getData("PGcanceltime")%></td>
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
