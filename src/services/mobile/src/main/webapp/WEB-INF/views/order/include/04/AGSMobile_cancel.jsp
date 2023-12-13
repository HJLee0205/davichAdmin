<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="kr.co.allthegate.mobile.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Insert title here</title>
</head>
<%

	///////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// 올더게이트 모바일 카드 결제취소 페이지
	//
	///////////////////////////////////////////////////////////////////////////////////////////////////

	String tracking_id = request.getParameter("tracking_id");
	String transaction = request.getParameter("transaction");
	String SendNo = request.getParameter("SendNo");
	String AdmNo = request.getParameter("AdmNo");
	String AdmDt = request.getParameter("AdmDt");
	String store_id = request.getParameter("StoreId");
	String Store_OrdNo = request.getParameter("Store_OrdNo");
	String log_path = "e:/logs";			// 이 곳에서 로그 Path를 설정하면 됩니다.

	if( Cancel_Check(Store_OrdNo) == true ){
	
		AGSMobile mobile = new AGSMobile(store_id, tracking_id, transaction, log_path);
		HashMap<String, Object> ret = new HashMap<String, Object>();
		mobile.setLogging(true);	//true : 로그기록, false : 로그기록안함.
		
		ret = mobile.cancel(AdmNo, AdmDt, SendNo, "");
		JSONObject data = ((JSONObject)ret.get("data"));
	%>
	<body>
		
	<%
		if(ret.get("status").equals("ok")){	// 승인성공
	%> 	
		
		<!-- 상점은 아래에서 처리하세요 -->
		업체ID : <%= data.get("StoreId") %><br/>
		승인번호 : <%= data.get("AdmNo") %><br/>
		승인시각 : <%= data.get("AdmTime") %>원<br/>
		코드 : <%= data.get("Code") %><br/>


	<%
		}else{	// 승인실패
	%>

		승인실패 : <%=ret.get("message") %>	<!-- 에러 메세지 -->
		
	<%
		}
	}else{
	%>
		승인실패 : 취소 원거래건을 찾지 못했습니다. 	<!-- 취소요청건이 상점 결제건이 아닌 경우 처리 -->
	<%
	}
%>
 
 </body>	
</html>

<%!
	public String Cancel_Check(String Store_OrdNo)
	{
		boolean flag = false;

		/***********************************************************************************
		*여기서 상점측 원거래 정보를 가져옵니다.
		*취소요청 건의 원거래가 상점측 원거래 정보와 동일하고
		*취소가 가능한 상태이면 True, 아니면 False 
		*원거래 체크로직은 상점에 알맞게 추가/변경하세요     
		************************************************************************************/

	/*	Dim Order			//ex. 상점 원거래정보
		
		if( Store_OrdNo == Order ) {
		   flag = true;
		}else{
		   flag = false;
		}
	*/

		return flag;
	}
%>