<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
java.text.SimpleDateFormat dateformat = new java.text.SimpleDateFormat("yyyyMMdd HH:mm:ss");

String sellerKey            = "S0FSJE";         // 가맹점 코드 - 파트너센터에서 알려주는 값으로, 초기 연동 시 PAYCO에서 쇼핑몰에 값을 전달한다.
String cpId                 = "PARTNERTEST";    // 상점ID
String productId            = "PROD_EASY";      // 상품ID
String deliveryId           = "DELIVERY_PROD";  // 배송비상품ID
String deliveryReferenceKey = "DV0001";         // 가맹점에서 관리하는 배송비상품 연동 키
String serverType           = "DEV";            // 서버유형. DEV:개발, REAL:운영
String logYn                = "Y";              // 로그Y/N

//도메인명 or 서버IP  
String domainName = "http://www.davichmarket.com/front/order";

boolean isMobile = false;
%>