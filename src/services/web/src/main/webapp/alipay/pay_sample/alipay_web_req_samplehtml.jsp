<!------------------------------------------------------------------------------

FILE NAME : alipay_web_req_sample.html
DATE : 2014/09
Author : MI1
Description : 	Alipay Front Test Page
				http://www.inicis.com
				Copyright 2014 KG Inicis, Co. All rights reserved.
------------------------------------------------------------------------------>
<%@ page pageEncoding="utf-8"%>
<%@ page
	language = "java"
	contentType = "text/html; charset=utf-8"
%>
<html>
<head>

	<title>ALIPAY PAYMENT</title>
	<meta http-equiv="Content-Type" content="application/x-www-form-urlencoded; text/html; charset=utf-8">
	<link rel="stylesheet" href="css/group.css" type="text/css">

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

	<script language=javascript>
	
		var date = new Date();
		var timeStamp = getTimeStamp();
		var date_str = "test_oid_"+timeStamp;

		if( date_str.length != 16 )
		{
			for( i = date_str.length ; i < 16 ; i++ )
			{
				date_str = date_str+"0";
			}
		}
				
		function getTimeStamp() 
		{
		  var d = new Date();

		  var s =
		    leadingZeros(d.getFullYear(), 4) + '' +
		    leadingZeros(d.getMonth() + 1, 2) + '' +
		    leadingZeros(d.getDate(), 2) + '' +

		    leadingZeros(d.getHours(), 2) + '' +
		    leadingZeros(d.getMinutes(), 2) + '' +
		    leadingZeros(d.getSeconds(), 2);

		  return s;
		}

		function leadingZeros(n, digits) 
		{
		  var zero = '';
		  n = n.toString();

		  if (n.length < digits) {
		    for (i = 0; i < digits - n.length; i++)
		      zero += '0';
		  }
		  return zero + n;
		}
		
		function conf(frm)
		{
			return true;
		}
		
		function setOidNTimestamp()
		{
			document.ini.webordernumber.value = ""+date_str;
			document.ini.timestamp.value = ""+timeStamp;
		}
	
	
	
	</script>

</head>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0 onload="setOidNTimestamp()"><center>

<form name=ini method=post action="./alipay_web_req_sample.jsp" onSubmit="return conf(this)">

<br>

<table width="632" border="0" cellspacing="0" cellpadding="0">

	<tr>
		<td height="85" background="img/card.gif" style="padding:0 0 0 64">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="3%" valign="top"><img src="img/title_01.gif" width="8" height="27" vspace="5"></td>
					<td width="97%" height="40" class="pl_03"><font color="#FFFFFF"><b>ALIPAY PAYMENT</b></font></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td align="center" bgcolor="6095BC"><table width="620" border="0" cellspacing="0" cellpadding="0">
				<tr>
				
					<td bgcolor="#FFFFFF" style="padding:8 0 0 56">
						<br>
						
						<table width="510" border="0" cellspacing="0" cellpadding="0">
							<tr>
							</tr>
						</table>
						
						<br>
						
						<table width="510" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="510" colspan="2"  style="padding:0 0 0 23">

									<table width="470" border="0" cellspacing="0" cellpadding="0">

										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>

					                    <tr> 
					                      <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
					                      <td width="109" height="25">PAYMENT TYPE </td>
					                      <td width="343">
					                           <select name=reqtype >
					                               <option value="authreq" selected>AUTH REQ
					                          </select>&nbsp;Fixed
					                      </td>
					                    </tr>

                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

                                        <tr>
                                            <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                                        </tr>

										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">MID</td>
											<td width="343">
												<input type=text name=mid size=30 maxlength=10 value="INIpayTest">&nbsp;
											</td>
										</tr>

										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">Timestamp </td>
											<td width="343">
												<input type=text name=timestamp size=30 maxlength=14 value="">
											</td>
										</tr>

										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>
										
										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">WebOrderNumber</td>
											<td width="343">
												<input type=text name=webordernumber size=30 maxlength=64 value="384d91ld94">
											</td>
										</tr>
																														
										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>
										
										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">Goodname</td>
											<td width="343">
												<input type=text name=goodname size=30 maxlength=80 value="tsingtaosoju"> only English
											</td>
										</tr>

										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>
										
										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">Currency</td>
											<td width="343">
												<input type=text name=currency size=30 maxlength=16 value="WON"> USD
											</td>
										</tr>
										
										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>

										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">Price</td>
											<td width="343">
												<input type=text name=price size=26 maxlength=80 value="1500"> Only number
											</td>
										</tr>

										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>

										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">Buyername</td>
											<td width="343">
												<input type=text name=buyername size=30 maxlength=30 value="Tang Wei"> only English
											</td>
										</tr>
										
										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>
										
										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">Buyertel</td>
											<td width="343">
												<input type=text name=buyertel size=30 maxlength=20 value="010-8818-9251">
											</td>
										</tr>
										
										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>
										
										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">Buyeremail</td>
											<td width="343">
												<input type=text name=buyeremail  size=30 maxlength=30 value="test@test.net">
											</td>
										</tr>
										
										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>
										
										<tr>
											<td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
											<td width="109" height="25">ReturnURL</td>
											<td width="343">
												<input type=text name=returnurl size=30 maxlength=160 value="http://172.20.22.224:8080/INIpay/alipay_web_rtn_sample.jsp">
											</td>
										</tr>

                                        <tr>
                                            <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                                            <td width="109" height="25">NotiURL</td>
                                            <td width="343">
                                                <input type=text name=notiurl size=30 maxlength=160 value="http://172.20.22.224:8080/INIpay/aliapyinput.jsp">
                                            </td>
                                        </tr>
	
										<tr>
											<td height="1" colspan="3" align="center"  background="img/line.gif"></td>
										</tr>
	
										<tr valign="bottom">
											<td height="40" colspan="3" align="center">
												<input type=image src="img/button_03.gif" width="63" height="25">
											</td>
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

<input type=hidden name=actionurl value="">

</form>

</body>

</html>

