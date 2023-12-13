<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.text.*,java.net.*" %>
<%@ page import="java.security.MessageDigest" %>
<%
/**********************************************************************************************
*
* 파일명 : AGS_pay_result.jsp
* 작성일자 : 2009/1/16
*
* 소켓결제결과를 처리합니다.
*
* Copyright AEGIS ENTERPRISE.Co.,Ltd. All rights reserved.
*
**********************************************************************************************/

request.setCharacterEncoding("UTF-8");

//공통사용
String AuthTy 		= request.getParameter("AuthTy");												//결제형태
String SubTy 		= request.getParameter("SubTy");												//서브결제형태
String rStoreId 	= request.getParameter("rStoreId");												//업체ID
String rOrdNo 		= request.getParameter("rOrdNo");												//주문번호
String rAmt 		= request.getParameter("rAmt");													//거래금액
String rProdNm 		= request.getParameter("rProdNm");	//상품명
String rOrdNm 		= request.getParameter("rOrdNm");	//주문자명

String AGS_HASHDATA = request.getParameter("AGS_HASHDATA");	// 주문 해쉬값

//소켓통신결제(신용카드,핸드폰,일반가상계좌)시 사용
String rSuccYn 		= request.getParameter("rSuccYn");												//성공여부
String rApprTm 		= request.getParameter("rApprTm");												//승인시각
String rResMsg      = request.getParameter("rResMsg");   //실패사유

//신용카드공통
String rBusiCd 		= request.getParameter("rBusiCd");				//전문코드
String rApprNo 		= request.getParameter("rApprNo");				//승인번호
String rCardCd 		= request.getParameter("rCardCd");				//카드사코드

//신용카드(안심,일반)
String rMembNo 		= request.getParameter("rMembNo");												//가맹점번호
String rAquiCd 		= request.getParameter("rAquiCd");												//매입사코드
String rBillNo 		= request.getParameter("rBillNo");												//전표번호
String rCardNm 		= request.getParameter("rCardNm");	//카드사명
String rAquiNm 		= request.getParameter("rAquiNm");	//매입사명

//신용카드(ISP)
String rDealNo 		= request.getParameter("rDealNo");				//거래고유번호

//계좌이체
String ICHE_AMOUNT 	= request.getParameter("ICHE_AMOUNT");															//이체금액
String ICHE_OUTBANKNAME = request.getParameter("ICHE_OUTBANKNAME");		//이체계좌은행명
String ICHE_OUTBANKMASTER = request.getParameter("ICHE_OUTBANKMASTER");	//이체계좌소유주

//핸드폰
String rHP_TID 		= request.getParameter("rHP_TID");				//핸드폰결제TID
String rHP_DATE 		= request.getParameter("rHP_DATE");			//핸드폰결제날짜
String rHP_HANDPHONE 	= request.getParameter("rHP_HANDPHONE");	//핸드폰결제핸드폰번호
String rHP_COMPANY 	= request.getParameter("rHP_COMPANY");			//핸드폰결제통신사명(SKT,KTF,LGT)

//ARS
String rARS_PHONE = request.getParameter("rARS_PHONE");		//ARS결제전화번호

//가상계좌
String rVirNo 		= request.getParameter("rVirNo");				//가상계좌번호
String VIRTUAL_CENTERCD = request.getParameter("VIRTUAL_CENTERCD" );//입금가상계좌은행코드

String mTId 		= request.getParameter("mTId" );

//이지스에스크로
String ES_SENDNO	= request.getParameter("ES_SENDNO" );			//이지스에스크로(전문번호)

//*******************************************************************************
//* MD5 결제 데이터 정상여부 확인
//* 결제전 AGS_HASHDATA 값과 결제 후 rAGS_HASHDATA의 일치 여부 확인
//* 형태 : 상점아이디(StoreId) + 주문번호(Ordno) + 결제금액(Amt)
//*******************************************************************************

int rAmt_hash = Integer.parseInt(rAmt);

StringBuffer sb = new StringBuffer();
sb.append(rStoreId);
sb.append(rOrdNo);
sb.append(rAmt_hash);

byte[] bNoti = sb.toString().getBytes();
MessageDigest md = MessageDigest.getInstance("MD5");
byte[] digest = md.digest(bNoti);

StringBuffer strBuf = new StringBuffer();
for (int i=0 ; i < digest.length ; i++) {
    int c = digest[i] & 0xff;
    if (c <= 15){
        strBuf.append("0");
    }
    strBuf.append(Integer.toHexString(c));
}

String rAGS_HASHDATA = strBuf.toString();
String errResMsg ="";
if (!(rAGS_HASHDATA.equals(AGS_HASHDATA))) errResMsg = "결재금액 변조 발생. 확인 바람.";

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>올더게이트</title>
<style type="text/css">
<!--
body { font-family:"돋움"; font-size:9pt; color:#000000; font-weight:normal; letter-spacing:0pt; line-height:180%; }
td { font-family:"돋움"; font-size:9pt; color:#000000; font-weight:normal; letter-spacing:0pt; line-height:180%; }
.clsright { padding-right:10px; text-align:right}
.clsleft { padding-left:10px; text-align:left }
-->
</style>
<script language=javascript>//"지불처리중"팝업창 닫는 부분 (AGS_pay.html에서 submit 전에 띄운 팝업 창을 닫는 스크립트)
<!--
var openwin = window.open("AGS_progress.html","popup","width=300,height=160");
openwin.close();
-->
</script>
<script language=javascript>
<!--
/*************************************************************************
* ◈ 영수증 출력을 위한 자바스크립트
*
*	영수증 출력은 [카드결제]시에만 사용하실 수 있습니다.
*
*   ※당일 결제건에 한해서 영수증 출력이 가능합니다.
*     당일 이후에는 아래의 주소를 팝업으로 띄워 내역 조회 후 출력하시기 바랍니다.
*	  ▷ 팝업용 결제내역조회 패이지 주소 :
*	     	 http://www.allthegate.com/support/card_search.html
*
*************************************************************************/
function show_receipt()
{
	if("<%=rSuccYn%>"== "y" && "<%=AuthTy%>" =="card")
	{
		var send_dt = appr_tm.value;

		url="http://allthegate.com/customer/receiptLast3.jsp"
		url=url+"?sRetailer_id="+sRetailer_id.value;
		url=url+"&approve="+approve.value;
		url=url+"&send_no="+send_no.value;
		url=url+"&send_dt="+send_dt.substring(0,8);

		window.open(url, "window","toolbar=no,location=no,directories=no,status=,menubar=no,scrollbars=no,resizable=no,width=420,height=700,top=0,left=150");
	}
	else
	{
		alert("해당하는 결제내역이 없습니다");
	}
}
-->
</script>
</head>
<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0>
<table border=0 width=100% height=100% cellpadding=0 cellspacing=0>
	<tr>
		<td align=center>
		<table width=400 border=0 cellpadding=0 cellspacing=0>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td class=clsleft>지불 결과</td>
			</tr>
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td>
				<table width=400 border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td class=clsright width=150>결제형태 : </td>
						<td class=clsleft width=250>
							<%

							if(AuthTy.equals("card"))
							{
								if(SubTy.equals("isp"))
								{
									out.println( "신용카드결제-안전결제(ISP)");
								}
								else if(SubTy.equals("visa3d"))
								{
									out.println( "신용카드결제-안심클릭");
								}
								else if(SubTy.equals("normal"))
								{
									out.println( "신용카드결제-일반결제");
								}

							}
							else if(AuthTy.equals("iche"))
							{
								out.println( "계좌이체");
							}
							else if(AuthTy.equals("hp"))
							{
								out.println( "핸드폰결제");
							}
							else if(AuthTy.equals("ars"))
							{
								out.println( "ARS결제");
							}
							else if(AuthTy.equals("virtual"))
							{
								out.println( "가상계좌결제");
							}
							%>
						</td>
					</tr>
					<tr>
						<td class=clsright>상점아이디 : </td>
						<td class=clsleft><%=rStoreId%></td>
					</tr>
					<tr>
						<td class=clsright>주문번호 : </td>
						<td class=clsleft><%=rOrdNo%></td>
					</tr>
					<tr>
						<td class=clsright>주문자명 : </td>
						<td class=clsleft><%=rOrdNm%></td>
					</tr>
					<tr>
						<td class=clsright>상품명 : </td>
						<td class=clsleft><%=rProdNm%></td>
					</tr>
					<tr>
						<td class=clsright>결제금액 : </td>
						<td class=clsleft><%=rAmt%></td>
					</tr>
					<tr>
						<td class=clsright>성공여부 : </td>
						<td class=clsleft><%=rSuccYn%></td>
					</tr>
					<tr>
						<td class=clsright>처리메세지 : </td>
						<td class=clsleft><%=rResMsg%></td>
					</tr>
<%				if(AuthTy.equals("card") || AuthTy.equals("virtual") ) { %>
					<tr>
						<td class=clsright>승인시각 : </td>
						<td class=clsleft><%=rApprTm%></td>
					</tr>
<%				}
				if(AuthTy.equals("card") && rSuccYn.equals("y") ) {%>
					<tr>
						<td class=clsright>전문코드 : </td>
						<td class=clsleft><%=rBusiCd%></td>
					</tr>
					<tr>
						<td class=clsright>승인번호 : </td>
						<td class=clsleft><%=rApprNo%></td>
					</tr>
					<tr>
						<td class=clsright>카드사코드 : </td>
						<td class=clsleft><%=rCardCd%></td>
					</tr>
					<tr>
						<td class=clsright>거래번호 : </td>
						<td class=clsleft><%=rDealNo%></td>
					</tr>
<%				}
				if(AuthTy.equals("card") && ( SubTy.equals("visa3d") || SubTy.equals("normal") ) && rSuccYn.equals("y") ) {%>
					<tr>
						<td class=clsright>카드사명 : </td>
						<td class=clsleft><%=rCardNm%></td>
					</tr>
					<tr>
						<td class=clsright>매입사코드 : </td>
						<td class=clsleft><%=rAquiCd%></td>
					</tr>
					<tr>
						<td class=clsright>매입사명 : </td>
						<td class=clsleft><%=rAquiNm%></td>
					</tr>
					<tr>
						<td class=clsright>가맹점번호 : </td>
						<td class=clsleft><%=rMembNo%></td>
					</tr>
<%				}
				if(AuthTy.equals("iche") ) {%>
					<tr>
						<td class=clsright>이체계좌은행명 : </td>
						<td class=clsleft><%=ICHE_OUTBANKNAME%><%=getCenter_cd(ICHE_OUTBANKNAME)%></td>
					</tr>
					<tr>
						<td class=clsright>이체금액 : </td>
						<td class=clsleft><%=ICHE_AMOUNT%></td>
					</tr>
					<tr>
						<td class=clsright>이체계좌소유주 : </td>
						<td class=clsleft><%=ICHE_OUTBANKMASTER%></td>
					</tr>
					<tr>
						<td class=clsright>이지스에스크로(SEND_NO) : </td>
						<td class=clsleft><%=ES_SENDNO%></td>
					</tr>
<%				}
				if(AuthTy.equals("hp") ) {%>
					<tr>
						<td class=clsright>핸드폰결제TID : </td>
						<td class=clsleft><%=rHP_TID%></td>
					</tr>
					<tr>
						<td class=clsright>핸드폰결제날짜 : </td>
						<td class=clsleft><%=rHP_DATE%></td>
					</tr>
					<tr>
						<td class=clsright>핸드폰결제핸드폰번호 : </td>
						<td class=clsleft><%=rHP_HANDPHONE%></td>
					</tr>
					<tr>
						<td class=clsright>핸드폰결제통신사명 : </td>
						<td class=clsleft><%=rHP_COMPANY%></td>
					</tr>
<%				}
				if(AuthTy.equals("ars") ) {%>
					<tr>
						<td class=clsright>ARS결제TID : </td>
						<td class=clsleft><%=rHP_TID%></td>
					</tr>
					<tr>
						<td class=clsright>ARS결제날짜 : </td>
						<td class=clsleft><%=rHP_DATE%></td>
					</tr>
					<tr>
						<td class=clsright>ARS결제전화번호 : </td>
						<td class=clsleft><%=rARS_PHONE%></td>
					</tr>
					<tr>
						<td class=clsright>ARS결제통신사명 : </td>
						<td class=clsleft><%=rHP_COMPANY%></td>
					</tr>
<%				}
				if(AuthTy.equals("virtual") ) {%>
					<tr>
						<td class=clsright>입금계좌번호 : </td>
						<td class=clsleft><%=rVirNo%></td>
					</tr>
                    <tr><!-- 은행코드(20) : 우리은행 -->
						<td class=clsright>입금은행 : </td>
						<td class=clsleft><%=getCenter_cd(VIRTUAL_CENTERCD)%></td>
					</tr>
                    <tr>
					<!--올더게이트에 등록된 상점명으로 표기-------->
						<td class=clsright>예금주명 : </td>
						<td class=clsleft>(주)이지스효성</td>
					</tr>
					<tr>
						<td class=clsright>이지스에스크로(SEND_NO) : </td>
						<td class=clsleft><%=ES_SENDNO%></td>
					</tr>
<%				}
				if(AuthTy.equals("card") ) {%>
					<tr>
						<td class=clsright>영수증 :</td>
						<!--영수증출력을위해서보내주는값-------------------->
						<input type=hidden name=sRetailer_id value="<%=rStoreId%>" /><!--상점아이디-->
						<input type=hidden name=approve value="<%=rApprNo%>" /><!---승인번호-->
						<input type=hidden name=send_no value="<%=rDealNo%>" /><!--거래고유번호-->
						<input type=hidden name=appr_tm value="<%=rApprTm%>" /><!--승인시각-->
						<!--영수증출력을위해서보내주는값-------------------->
						<td class=clsleft><input type="button" value="영수증" onclick="javascript:show_receipt();"/></td>
					</tr>
					<tr>
						<td colspan=2>&nbsp;</td>
					</tr>
					<tr>
						<td align=center colspan=2>카드 이용명세서에 구입처가 <font color=red>이지스엔터프라이즈(주)</font>로 표기됩니다.</td>
					</tr>
<%				}	%>
					<tr>
						<td colspan="2"><%=errResMsg %></td>
					</tr>
					<tr>
						<td colspan="2">원본 해쉬 : <%= AGS_HASHDATA%></td>
					</tr>
					<tr>
						<td colspan="2">결과 해쉬 : <%= rAGS_HASHDATA%></td>
					</tr>

				</table>
				</td>
			</tr>
			<tr>
				<td><hr></hr></td>
			</tr>
			<tr>
				<td class=clsleft>Copyright AEGIS ENTERPISE.Co.,Ltd. All rights reserved.</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</body>
</html>
<%!
	public String getCenter_cd(String cd){
		String center_cd = "가상은행";

		if(cd.equals("39")) center_cd = "경남은행";
		if(cd.equals("34")) center_cd = "광주은행";
		if(cd.equals("04")) center_cd = "국민은행";
		if(cd.equals("11")) center_cd = "농협중앙회";
		if(cd.equals("31")) center_cd = "대구은행";
		if(cd.equals("32")) center_cd = "부산은행";
		if(cd.equals("02")) center_cd = "산업은행";
		if(cd.equals("45")) center_cd = "새마을금고";
		if(cd.equals("07")) center_cd = "수협중앙회";
		if(cd.equals("48")) center_cd = "신용협동조합";
		if(cd.equals("26")) center_cd = "(구)신한은행";
		if(cd.equals("05")) center_cd = "외환은행";
		if(cd.equals("20")) center_cd = "우리은행";
		if(cd.equals("71")) center_cd = "우체국";
		if(cd.equals("37")) center_cd = "전북은행";
		if(cd.equals("23")) center_cd = "제일은행";
		if(cd.equals("35")) center_cd = "제주은행";
		if(cd.equals("21")) center_cd = "(구)조흥은행";
		if(cd.equals("03")) center_cd = "중소기업은행";
		if(cd.equals("81")) center_cd = "하나은행";
		if(cd.equals("88")) center_cd = "신한은행";
		if(cd.equals("27")) center_cd = "한미은행";
		if(cd.equals("99")) center_cd = "가상은행";

		return center_cd;
	}
%>