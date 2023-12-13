<!------------------------------------------------------------------------------

FILE NAME : alipay_web_req_sample.jsp.jsp
DATE : 2014/09
Author : MI1
Description :   Alipay Front Test Page
                http://www.inicis.com
                Copyright 2014 KG Inicis, Co. All rights reserved.
------------------------------------------------------------------------------>


<%@ page pageEncoding="utf-8"%>
<%@ page
	language = "java"
	contentType = "text/html; charset=utf-8"
%>
<%@ page import = "java.util.*,java.text.SimpleDateFormat"%>
<%@ page import = "java.security.MessageDigest"%>
<%
	request.setCharacterEncoding("utf-8");
	
	Enumeration elems 		= request.getParameterNames();
	Hashtable requestValue 	= new Hashtable();
	SimpleDateFormat sdf 	= new SimpleDateFormat("yyyyMMddHHmmss");
	String merchantKey 		= "SU5JTElURV9UUklQTEVERVNfS0VZU1RS";//가맹점 상점키 설정
	String actionurl        = "https://inilite.inicis.com/inipayStdAlipay";
	String temp 			= "";

	while (elems.hasMoreElements())
	{
		temp = (String) elems.nextElement();
		requestValue.put(temp, (request.getParameter(temp)));
		//System.out.println("["+ temp + "]:[" + requestValue.get(temp) + "]" );
	}

	String timestamp 		= (String)requestValue.get("timestamp");
	String mid 				= (String)requestValue.get("mid");
	String webordernumber 	= (String)requestValue.get("webordernumber");
	String goodname         = (String)requestValue.get("goodname"); 	
	String currency 		= (String)requestValue.get("currency");
	String price 			= (String)requestValue.get("price");
	String buyername 		= (String)requestValue.get("buyername");
	String buyertel 		= (String)requestValue.get("buyertel");
	String buyeremail 		= (String)requestValue.get("buyeremail");
    String returnurl        = (String)requestValue.get("returnurl");
	String reqtype 		    = (String)requestValue.get("reqtype");
    String notiurl          = (String)requestValue.get("notiurl");
		
	
	//HASH DATA 생성 ----------
	String plainText = timestamp + mid + reqtype + webordernumber + currency + price + merchantKey;
	String hashData	 = encryptSHA512(timestamp + mid + reqtype + webordernumber + currency + price + merchantKey);
	//System.out.println("plainText : " + plainText );
	//System.out.println("hashData : " + hashData );
	//------------------------

%>

<script>
	function submit() {        
		document.ini.submit();
	}
</script>

<body onload="javascript:submit();">
<form name="ini" method="post" action="<%=actionurl%>">
    <input type="hidden" name="mid"             value="<%=mid%>">
	<input type="hidden" name="timestamp" 		value="<%=timestamp%>">
    <input type="hidden" name="webordernumber"  value="<%=webordernumber%>">
    <input type="hidden" name="goodname"        value="<%=goodname%>">
    <input type="hidden" name="currency"        value="<%=currency%>">
    <input type="hidden" name="price"           value="<%=price%>">
    <input type="hidden" name="buyername"       value="<%=buyername%>">
	<input type="hidden" name="buyertel" 		value="<%=buyertel%>">
    <input type="hidden" name="buyeremail"      value="<%=buyeremail%>">
	<input type="hidden" name="reqtype" 		value="<%=reqtype%>">
	<input type="hidden" name="returnurl" 		value="<%=returnurl%>">
	<input type="hidden" name="hashdata" 		value="<%=hashData%>">
    <input type="hidden" name="notiurl"         value="<%=notiurl%>">
</form>

</body>


<%!
//SHA-512 함수    
public String encryptSHA512(String input) 
{
    String output = "";
   
    StringBuffer sb = new StringBuffer();
    MessageDigest md  = null;

    try{
        md = MessageDigest.getInstance("SHA-512");
        md.update(input.getBytes());
    }catch(Exception e){
    }
 
    return byteArrayToHex(md.digest());
}

public  String byteArrayToHex(byte[] ba) 
{
    if (ba == null || ba.length == 0) 
    {
        return null;
    }

    StringBuffer sb = new StringBuffer(ba.length * 2);
    String hexNumber;
    for (int x = 0; x < ba.length; x++) 
    {
        hexNumber = "0" + Integer.toHexString(0xff & ba[x]);
        sb.append(hexNumber.substring(hexNumber.length() - 2));
    }
    return sb.toString();
}
%>
