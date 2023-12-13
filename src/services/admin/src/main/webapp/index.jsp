<%@ page contentType="text/html; charset=euc-kr" %>

<HTML>
<HEAD>
    <TITLE>Session Clustering Test</TITLE>
</HEAD>
<BODY>
<h1>Session Clustering Test</h1>
<%
    Integer ival = (Integer)session.getAttribute("_session_counter");

    if(ival==null) {
        ival = new Integer(1);
    }
    else {
        ival = new Integer(ival.intValue() + 1);
    }
    session.setAttribute("_session_counter", ival);
%>
Session Counter = [<b> <%= ival %> </b>]<p>
<a href="./index.jsp">[Reload]</a>
<p>
Current Session ID : <%= request.getRequestedSessionId() %><br />
</BODY>
</HTML>