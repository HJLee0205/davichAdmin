<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import = "java.net.InetAddress" %>
<%@ page import = "java.net.UnknownHostException" %>


<HTML>

<HEAD>

    <TITLE>Session Clustering Test WAS1</TITLE>

</HEAD>

<BODY>

<h1>Session Clustering Test  <%= request.getServerName() %></h1>
<%=InetAddress.getLocalHost().getHostName()%>
<%=InetAddress.getLocalHost().getHostAddress()%>
<%

    Integer ival = (Integer)session.getAttribute("_session_counter");

 

    if(ival==null) {

        ival = new Integer(1);

    }

    else {

        ival = new Integer(ival.intValue() + 1);

    }

    session.setAttribute("_session_counter", ival);

    System.out.println("here~~~~"+ival);

%>

Session Counter = [<b> <%= ival %> </b>]<p>

<a href="./session.jsp">[Reload]</a>

<p>

Current Session ID : <%= request.getRequestedSessionId() %><br />

</BODY>



</HTML>
