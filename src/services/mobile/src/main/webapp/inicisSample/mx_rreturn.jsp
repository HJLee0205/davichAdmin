<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.sql.SQLException" %>
<%
	/////////////////////////////////////////////////////////////////////////////
	///// 1. GET값 받기                                                      ////
	/////////////////////////////////////////////////////////////////////////////
	request.setCharacterEncoding("euc-kr");
	String oid = request.getParameter("P_OID");			// 결제요청 페이지에서 세팅한 주문번호

%>


<HTML>
 <HEAD>
  <TITLE>INIpay Mobile WEB example</TITLE>
  <META http-equiv="Expires" content="0"/> 
  <META NAME="Author" CONTENT="yw0399">
  <META http-equiv="Content-Type" content="text/html; charset=euc-kr"> 
  <META NAME="Keywords" CONTENT="INICIS MOBILE">
  <META NAME="Description" CONTENT="이니페이 모바일 WEB방식 P_RETURN_URL 페이지">
  <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
	<style>
	<!--
	body  {font-family:malgun gothic, 맑은 고딕, 굴림; color:white; font-size:10pt;}
	table {font-family:malgun gothic, 맑은 고딕, 굴림;}
	-->
	</style>
 </HEAD>

 <BODY bgcolor="#573296">
<%
out.print("[P_RETURN_URL]<br><br>");
out.print("GET으로 전달한 값 = " + oid + "<br>");

	//oid를 가지고 P_NOTI_URL에서 처리한(DB에 입력된) 데이터를 가져와서 보여준다.
	//P_NOTI_URL이 먼저 호출되고,  P_RETURN_URL이 호출되는 것이라서 일반적인 경우는 문제가 없지만,
	//P_NOTI_URL쪽 처리가 지연되는 경우가 발생하면, 이 페이지가 호출되는 시점에 상점DB상에 데이터가 
	//존재하지 않을 수 있음. 따라서 select 결과가 없다고 무조건 승인 데이터가 없는 것은 아님

	//String SQL_QUERY = "select * from 상점테이블 where oid = 'oid' ";
	//쿼리 실행
	//if(쿼리결과가 있으면) {
	//	내용 출력
	//}
	//else if(쿼리결과가 없으면) {
	//  처리지연 가능성 출력 / 개인 페이지에서 결제내역을 다시 확인하시기 바랍니다.
	//}


		Connection con = null;
		String url = "jdbc:mysql://localhost:3306/";
		String db = "mobile";
		String driver = "com.mysql.jdbc.Driver";
		try{
		  Class.forName(driver);
		  con = DriverManager.getConnection(url+db,"test","0000");
		  try{
			Statement st = con.createStatement();


			String sql = "select * from mx where P_OID='" + oid + "'";
			ResultSet rs = st.executeQuery(sql);
			while(rs.next()) {
				int uid = rs.getInt("no_id");
				String P_TID = rs.getString("P_TID");
				String P_MID = rs.getString("P_MID");
				String P_AUTH_DT = rs.getString("P_AUTH_DT");
				String P_STATUS = rs.getString("P_STATUS");
				String P_TYPE = rs.getString("P_TYPE");
				String P_OID = rs.getString("P_OID");
				String P_FN_CD1 = rs.getString("P_FN_CD1");
				String P_FN_CD2 = rs.getString("P_FN_CD2");
				String P_FN_NM = rs.getString("P_FN_NM");
				String P_UNAME = rs.getString("P_UNAME");
				String P_AMT = rs.getString("P_AMT");
				String P_RMESG1 = rs.getString("P_RMESG1");
				String P_RMESG2 = rs.getString("P_RMESG2");
				String P_NOTI = rs.getString("P_NOTI");
				String P_AUTH_NO = rs.getString("P_AUTH_NO");
				String P_CARD_ISSUER_CODE = rs.getString("P_CARD_ISSUER_CODE");
				String P_CARD_NUM = rs.getString("P_CARD_NUM");
				out.print("P_TID = " + P_TID + "<br>");
				out.print("P_MID = " + P_MID + "<br>");
				out.print("P_AUTH_DT = " + P_AUTH_DT + "<br>");
				out.print("P_STATUS = " + P_STATUS + "<br>");
				out.print("P_TYPE = " + P_TYPE + "<br>");
				out.print("P_OID = " + P_OID + "<br>");
				out.print("P_FN_CD1 = " + P_FN_CD1 + "<br>");
				out.print("P_FN_CD2 = " + P_FN_CD2 + "<br>");
				out.print("P_FN_NM = " + P_FN_NM + "<br>");
				out.print("P_UNAME = " + P_UNAME + "<br>");
				out.print("P_AMT = " + P_AMT + "<br>");
				out.print("P_RMESG1 = " + P_RMESG1 + "<br>");
				out.print("P_RMESG2 = " + P_RMESG2 + "<br>");
				out.print("P_NOTI = " + P_NOTI + "<br>");
				out.print("P_AUTH_NO = " + P_AUTH_NO + "<br>");
				out.print("P_CARD_ISSUER_CODE = " + P_CARD_ISSUER_CODE + "<br>");
				out.print("P_CARD_NUM = " + P_CARD_NUM + "<br>");

			}


		  }
		  catch (SQLException s){
			//System.out.println("SQL statement is not executed!");
			// SQL 입력시 에러가 발생하면...
			out.print(""+s.toString());
			//out.print("SQL statement is not executed!");
		  }
		}
		catch (Exception e){
		  e.printStackTrace();
		}


%>


<hr>
<p>Have fun!</p>

 </BODY>
</HTML>
