<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.*,java.net.*,java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.security.MessageDigest" %>
<%
    /*
     * 상점 처리결과 리턴메세지
     *
     * OK  : 상점 처리결과 성공
     * 그외 : 상점 처리결과 실패
     *
     * ※ 주의사항 : 성공시 'OK' 문자이외의 다른문자열이 포함되면 실패처리 되오니 주의하시기 바랍니다.
     */    
    String confirmResultCd = (String)request.getAttribute("confirmResultCd");
    String resultMSG = (String)request.getAttribute("confirmResultMsgFail"); //실패시 처리메시지
    if("0000".equals(confirmResultCd)){
        resultMSG = "OK";
    }
    out.println(resultMSG.toString());    
%>