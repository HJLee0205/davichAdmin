<!------------------------------------------------------------------------------
FILE NAME : tenpay_web_req_sample.jsp
DATE : 2015/08
Author : MI1  
Description :   Tenpay Response Sample Page
                http://www.inicis.com
                Copyright 2015 KG Inicis, Co. All rights reserved.
------------------------------------------------------------------------------>

<%@ page pageEncoding="utf-8"%>
<%@ page
    language = "java"
    contentType = "text/html; charset=utf-8"
%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Enumeration"%>
<%

    request.setCharacterEncoding("utf-8");
    
    Hashtable<String,String> result = new Hashtable<String,String>();
    Enumeration<String> elems = request.getParameterNames();
    String temp = "";

    while(elems.hasMoreElements())
    {
        temp = (String) elems.nextElement();
        result.put(temp, request.getParameter(temp).toString().trim());
    }    

    String resultCheck = "";
    if("00".equals(result.get("resultcode")))
        resultCheck = "텐페이로 부터 결제 결과 확인중입니다";
    else
        resultCheck = "결제가 정상처리되지 못했습니다. 다시 한번 결제 시도해 주시기 바랍니다.";

%>


<html>
<head>

    <title>TENPAY PAYMENT</title>
    <meta http-equiv="Content-Type" content="application/x-www-form-urlencoded; text/html; charset=utf-8">
    <link rel="stylesheet" href="" type="text/css">

    <style>
    body, tr, td {font-size:10pt; font-family:verdana; color:#433F37; line-height:19px;}
    table, img {border:none}
    
    /* Padding ******/
    .pl_01 {padding:1 10 0 10; line-height:19px;}
    .pl_03 {font-size:20pt; font-family:verdana; color:#FFFFFF; line-height:29px;}
    
    /* Link ******/
    .a:link  {font-size:9pt; color:#333333; text-decoration:none}
    .a:visited { font-size:9pt; color:#333333; text-decoration:none}
    .a:hover  {font-size:9pt; color:#0174CD; text-decoration:underline}
    
    .txt_03a:link  {font-size: 8pt;line-height:18px;color:#333333; text-decoration:none}
    .txt_03a:visited {font-size: 8pt;line-height:18px;color:#333333; text-decoration:none}
    .txt_03a:hover  {font-size: 8pt;line-height:18px;color:#EC5900; text-decoration:underline}
    </style>

</head>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0><center>

<form name=ini>

<br>

<table width="632" border="0" cellspacing="0" cellpadding="0">

    <tr>
        <td height="85" background="img/card.gif" style="padding:0 0 0 64">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="3%" valign="top"><img src="img/title_01.gif" width="8" height="27" vspace="5"></td>
                    <td width="97%" height="40" class="pl_03"><font color="#FFFFFF"><b>TENPAY PAYMENT</b></font></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td align="center" bgcolor="6095BC"><table width="620" border="0" cellspacing="0" cellpadding="0">
                <tr>
                
                    <td bgcolor="#FFFFFF" style="padding:8 0 0 56">
                        <br/>
                        <table width="510" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="343">
                                  <B>Merchant verification : <%=resultCheck%></B>
                                </td>
                            </tr>
                        </table>
                        <br/>
                        <table width="510" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="510" colspan="2"  style="padding:0 0 0 23">

                                    <table width="470" border="0" cellspacing="0" cellpadding="0">
                                        
                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">RESULTCODE</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("resultcode")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>
 
                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">RESULTMESSAGE</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("resultmessage")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">TID </td>
                                            <td width="343" style="font-size:12px">
                                                &nbsp; : &nbsp;<%=result.get("tid")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">GOODNAME</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("goodname")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">WEBORDERNUMBER</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("webordernumber")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">PRICE(CENT)</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("price")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">PRICE(WON)</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("pricewon")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">PAYMETHOD</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("paymethod")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>
                                        
                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">CURRENCY</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("currency")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>
                                        
                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">TPAYAUTHDATE</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("tpayauthdate")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>
                                        
                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">MID</td>
                                            <td width="343">
                                                &nbsp; : &nbsp;<%=result.get("mid")%>
                                            </td>
                                        </tr>
 
                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

                                    </table>
                                </td>
                            </tr>

                        </table>
                        <br>
                    </td>
                </tr>

            </table>
        </td>
    </tr>

    <tr>
        <td><img src="img/bottom01.gif" width="632" height="13"></td>
    </tr>
    
</table>

</center>
</body>
</html>
