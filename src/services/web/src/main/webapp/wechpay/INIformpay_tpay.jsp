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
//# 1. �ν��Ͻ� ���� #
//####################
  INIpay inipay = new INIpay();
  INIdata data = new INIdata();



//#############################################################################
//# 2. ���� ���� #
//################
  data.setData("type", "formpay");                                  // ���� type
  data.setData("inipayHome", inipayHome);                           // �̴����̰� ��ġ�� ������
  data.setData("logMode", logMode);                                 // logMode
  data.setData("keyPW",keyPW);                                      // Ű�н�����
  data.setData("subPgip","203.238.37.3");                           // Sub PG IP (����)
  
  data.setData("paymethod", "TPAY");                                // ���Ҽ��� (����)
  data.setData("svccode", "W");                                     // ���Ҽ��� TPAY�� ���, ��ê���� (W) ����
  data.setData("wech_authcode", request.getParameter("wech_authcode"));               // �����ڵ� 
  data.setData("wech_companynumber", request.getParameter("wech_companynumber"));       // ���갡��������ڹ�ȣ
  
  data.setData("mid", request.getParameter("mid"));                 // �������̵�
  data.setData("uid", request.getParameter("mid") );                // INIpay User ID
  data.setData("goodname", request.getParameter("goodname"));       // ��ǰ�� (�ִ� 40��)
  data.setData("currency", request.getParameter("currency"));       // ȭ�����
  data.setData("price", request.getParameter("price"));             // ����
  data.setData("buyername", request.getParameter("buyername"));     // ������ (�ִ� 15��)
  data.setData("buyertel", request.getParameter("buyertel"));       // �������̵���ȭ
  data.setData("buyeremail", request.getParameter("buyeremail"));   // �������̸���
  data.setData("url", "http://www.your_domain.co.kr");              // Ȩ������ �ּ�(URL)
  data.setData("uip", request.getRemoteAddr());                     // IP Addr
  data.setData("crypto", "execure");

//###############################################################################
//# 3. ���� ��û #
//################  
  data = inipay.payRequest(data);

  
//###############################################################################
//# 4. ACK ��û �� DBó�� #
//################ 
  if ("00".equals(data.getData("ResultCode"))) {
    if (inipay.payAck()) {
        // DB ó��
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
                    alert("�ش��ϴ� ���� �ŷ��� �����ϴ�");
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
                    <b>���� ���</b>
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
                <td align=right nowrap>���ҹ�� : </td><td><%=data.getData("paymethod")%></td>
            </tr>
            <tr>
                <td align=right nowrap>����ڵ� : </td><td><%=data.getData("ResultCode")%></td>
            </tr>
            <tr>
                <td align=right nowrap>������� : </td><td><font class=emp><%=data.getData("ResultMsg")%></font></td>
            </tr>
            <tr>
                <td align=right nowrap>�ŷ���ȣ : </td><td><%=data.getData("tid")%></td>
            </tr>
            <tr>
                <td align=right nowrap>������û�ݾ� : </td><td><%=data.getData("price")%></td>
            </tr>
            <tr>
                <td align=right nowrap>PG���γ�¥ : </td><td><%=data.getData("PGauthdate")%></td>
            </tr>
            <tr>
                <td align=right nowrap>PG���νð� : </td><td><%=data.getData("PGauthtime")%></td>
            </tr>
            <tr>
                <td align=right nowrap>��ê�ֹ���ȣ : </td><td><%=data.getData("WECH_TransactionID")%></td>
            </tr>              
            <tr>
                <td align=right nowrap>ȯ�� : </td><td><%=data.getData("RateExchange")%></td>
            </tr>            
            <tr>
                <td align=right nowrap>ȯ�����ݾ� : </td><td><%=data.getData("ReqPrice")%></td>
            </tr>      
            <tr>
                <td colspan=2 align=center>
                    <br><input type=button value="����������" onclick=javascript:show_receipt('<%=data.getData("tid")%>')><br><br>
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

