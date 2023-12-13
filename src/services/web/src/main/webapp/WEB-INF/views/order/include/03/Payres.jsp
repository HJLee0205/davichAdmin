<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="defaultLayout">
 <t:putAttribute name="title">LGU+ PC용(XPay)- 7.최종결제 요청 결과 확인</t:putAttribute>
 <t:putAttribute name="content">
 <h1>### samplePayres.jsp 파라메터 ###</h1>
 <h1>### resultModel 파라메터 ###</h1>
<c:if test="${!empty resultModel}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(resultModel, 'ResultModel(', ''), ')', ''))}" delims="," var="rm" >
    <c:if test="${fn:split(rm, '=')[1] != 'null'}">
        ${rm} <br/>
    </c:if>
</c:forTokens>
 </c:if>
 <h1>### resultModelRollBack 파라메터 ###</h1>
<c:if test="${!empty resultModelRollBack}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(resultModelRollBack, 'ResultModel(', ''), ')', ''))}" delims="," var="rm" >
    <c:if test="${fn:split(rm, '=')[1] != 'null'}">
        ${rm} <br/>
    </c:if>
</c:forTokens>
 </c:if> 
<h1>### paymentModel 파라메터 ###</h1>
<c:if test="${!empty paymentModel}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(paymentModel, 'PaymentModel(', ''), ')', ''))}" delims="," var="pm" >
    <c:if test="${fn:split(pm, '=')[1] != 'null'}">
        ${pm} <br/>
    </c:if>
</c:forTokens>
</c:if>
<h1>### lguPO 파라메터 ###</h1>
<c:if test="${!empty lguPO}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(lguPO, 'LguPO(', ''), ')', ''))}" delims="," var="pm" >
    <c:if test="${fn:split(pm, '=')[1] != 'null'}">
        ${pm} <br/>
    </c:if>
</c:forTokens>
</c:if>
<h1>### paymentModelRollBack 파라메터 ###</h1>
<c:if test="${!empty paymentModelRollBack}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(paymentModelRollBack, 'PaymentModel(', ''), ')', ''))}" delims="," var="pm" >
    <c:if test="${fn:split(pm, '=')[1] != 'null'}">
        ${pm} <br/>
    </c:if>
</c:forTokens>
</c:if>
<h1>### lguPORollBack 파라메터 ###</h1>
<c:if test="${!empty lguPORollBack}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(lguPORollBack, 'LguPO(', ''), ')', ''))}" delims="," var="pm" >
    <c:if test="${fn:split(pm, '=')[1] != 'null'}">
        ${pm} <br/>
    </c:if>
</c:forTokens>
</c:if>
<h1>### sessionScope.paymentModel 파라메터 ###</h1>
<c:if test="${!empty sessionScope.paymentModel}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(sessionScope.paymentModel, 'PaymentModel(', ''), ')', ''))}" delims="," var="spm" >
    <c:if test="${fn:split(spm, '=')[1] != 'null'}">
        ${spm} <br/>
    </c:if>
</c:forTokens>
 </c:if>
<h1>### sessionScope.lguPO 파라메터 ###</h1>
<c:if test="${!empty sessionScope.lguPO}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(sessionScope.lguPO, 'LguPO(', ''), ')', ''))}" delims="," var="slp" >
    <c:if test="${fn:split(slp, '=')[1] != 'null'}">
        ${slp} <br/>
    </c:if>
</c:forTokens>
</c:if>
<h1>### requestScope 파라메터 ###</h1>
 ${requestScope}
 
 <h1>결제승인요청 처리결과</h1>
 <p>LGD_TXNAME (메소드): ${lguPO.LGD_TXNAME}</p>
 <p>### 파라메터 - 필수여부[PC, 스마트폰] ###</p>
    <p>LGD_RESPCODE[Y,Y] (응답코드) : ${lguPO.LGD_RESPCODE}</p>
    <p>LGD_RESPMSG[Y,Y] (응답메세지) : ${lguPO.LGD_RESPMSG}</p>
    <p>LGD_MID[,] (LG유플러스 발급 아이디) : ${lguPO.LGD_MID}</p>
    <p>LGD_OID[,] (이용업체 거래번호(주문번호)) : ${lguPO.LGD_OID}</p>
    <p>LGD_AMOUNT[,] (결제금액) : ${lguPO.LGD_AMOUNT}</p>
    <p>LGD_TID[,] (LG유플러스 거래번호) : ${lguPO.LGD_TID}</p>
    <p>LGD_PAYTYPE[,] (결제수단) : ${lguPO.LGD_PAYTYPE}</p>
    <p>LGD_PAYDATE[,] (결제일시) : ${lguPO.LGD_PAYDATE}</p>
    <p>LGD_HASHDATA[,] (해쉬데이타) : ${lguPO.LGD_HASHDATA}</p>
    <p>LGD_FINANCECODE[,] (결제기관코드) : ${lguPO.LGD_FINANCECODE}</p>
    <p>LGD_FINANCENAME[,] (결제기관명) : ${lguPO.LGD_FINANCENAME}</p>
    <p>LGD_ESCROWYN[,] (에스크로적용유무) : ${lguPO.LGD_ESCROWYN}</p>
    <p>LGD_TRANSAMOUNT[,] (환율적용금액) : ${lguPO.LGD_TRANSAMOUNT}</p>
    <p>LGD_EXCHANGERATE[,] (적용환율) : ${lguPO.LGD_EXCHANGERATE}</p>
    <p>LGD_BUYER[,] (구매자명) : ${lguPO.LGD_BUYER}</p>
    <p>LGD_BUYERID[,] (구매자아이디) : ${lguPO.LGD_BUYERID}</p>
    <p>LGD_BUYERPHONE[,] (구매자휴대폰번호) : ${lguPO.LGD_BUYERPHONE}</p>
    <p>LGD_BUYEREMAIL[,] (구매자메일) : ${lguPO.LGD_BUYEREMAIL}</p>
    <p>LGD_PRODUCTINFO[,] (구매내역) : ${lguPO.LGD_PRODUCTINFO}</p>
    <p>##### 파라메터 - 신용카드 #####</p>
    <p>LGD_CARDNUM[,] (신용카드번호) : ${lguPO.LGD_CARDNUM}</p>
    <p>LGD_CARDINSTALLMONTH[,] (신용카드할부개월) : ${lguPO.LGD_CARDINSTALLMONTH}</p>
    <p>LGD_CARDNOINTYN[,] (신용카드무이자여부) : ${lguPO.LGD_CARDNOINTYN}</p>
    <p>LGD_FINANCEAUTHNUM[,] (결제기관승인번호) : ${lguPO.LGD_FINANCEAUTHNUM}</p>
    <p>##### 파라메터 - 계좌이체무통장 #####</p>
    <p>LGD_CASHRECEIPTNUM[,] (현금영수증승인번호) : ${lguPO.LGD_CASHRECEIPTNUM}</p>
    <p>LGD_CASHRECEIPTSELFYN[,] (현금영수증자진발급제유무) : ${lguPO.LGD_CASHRECEIPTSELFYN}</p>
    <p>LGD_CASHRECEIPTKIND[,] (현금영수증종류) : ${lguPO.LGD_CASHRECEIPTKIND}</p>
    <p>##### 파라메터 - 무통장 #####</p>
    <p>LGD_CASHRECEIPTNUM[,] (현금영수증승인번호) : ${lguPO.LGD_CASHRECEIPTNUM}</p>
    <p>LGD_CASHRECEIPTSELFYN[,] (현금영수증자진발급제유무) : ${lguPO.LGD_CASHRECEIPTSELFYN}</p>
    <p>LGD_CASHRECEIPTKIND[,] (현금영수증종류) : ${lguPO.LGD_CASHRECEIPTKIND}</p>
    <p>LGD_ACCOUNTNUM[,] (가상계좌발급번호) : ${lguPO.LGD_ACCOUNTNUM}</p>
    <p>LGD_CASTAMOUNT[,] (입금누적금액) : ${lguPO.LGD_CASTAMOUNT}</p>
    <p>LGD_CASCAMOUNT[,] (현입금금액) : ${lguPO.LGD_CASCAMOUNT}</p>
    <p>LGD_CASFLAG[,] (거래종류(R:할당,I:입금,C:취소)) : ${lguPO.LGD_CASFLAG}</p>
    <p>LGD_CASSEQNO[,] (가상계좌일련번호) : ${lguPO.LGD_CASSEQNO}</p>
    <p>##### 파라메터 - OK캐쉬백 #####</p>
    <p>LGD_OCBSAVEPOINT[,] (OK캐쉬백 적립포인트) : ${lguPO.LGD_OCBSAVEPOINT}</p>
    <p>LGD_OCBAMOUNT[,] (OK캐쉬백 사용금액) : ${lguPO.LGD_OCBAMOUNT}</p>
    <p>LGD_OCBTOTALPOINT[,] (OK캐쉬백 총누적포인트) : ${lguPO.LGD_OCBTOTALPOINT}</p>
    <p>LGD_OCBUSABLEPOINT[,] (OK캐쉬백 사용가능포인트) : ${lguPO.LGD_OCBUSABLEPOINT}</p>
    <p>##### 파라메터 - 상품권 #####</p>
    <p>LGD_FINANCEAUTHNUM[,] (결제기관승인번호) : ${lguPO.LGD_FINANCEAUTHNUM}</p>
    <p>##### 파라메터 - 모바일T머니 #####</p>
    <p>LGD_TELNO[,] (결제휴대폰번호) : ${lguPO.LGD_TELNO}</p>
  
 <h1>승인완료 DB반영 실패시 롤백시도한 처리결과</h1>
 <p>LGD_TXNAME (메소드): ${lguPORollBack.LGD_TXNAME}</p>
 <p>### 파라메터 - 필수여부[PC, 스마트폰] ###</p>
    <p>LGD_RESPCODE[Y,Y] (응답코드) : ${lguPORollBack.LGD_RESPCODE}</p>
    <p>LGD_RESPMSG[Y,Y] (응답메세지) : ${lguPORollBack.LGD_RESPMSG}</p>
    <p>LGD_MID[,] (LG유플러스 발급 아이디) : ${lguPORollBack.LGD_MID}</p>
    <p>LGD_OID[,] (이용업체 거래번호(주문번호)) : ${lguPORollBack.LGD_OID}</p>
    <p>LGD_AMOUNT[,] (결제금액) : ${lguPORollBack.LGD_AMOUNT}</p>
    <p>LGD_TID[,] (LG유플러스 거래번호) : ${lguPORollBack.LGD_TID}</p>
    <p>LGD_PAYTYPE[,] (결제수단) : ${lguPORollBack.LGD_PAYTYPE}</p>
    <p>LGD_PAYDATE[,] (결제일시) : ${lguPORollBack.LGD_PAYDATE}</p>
    <p>LGD_HASHDATA[,] (해쉬데이타) : ${lguPORollBack.LGD_HASHDATA}</p>
    <p>LGD_FINANCECODE[,] (결제기관코드) : ${lguPORollBack.LGD_FINANCECODE}</p>
    <p>LGD_FINANCENAME[,] (결제기관명) : ${lguPORollBack.LGD_FINANCENAME}</p>
    <p>LGD_ESCROWYN[,] (에스크로적용유무) : ${lguPORollBack.LGD_ESCROWYN}</p>
    <p>LGD_TRANSAMOUNT[,] (환율적용금액) : ${lguPORollBack.LGD_TRANSAMOUNT}</p>
    <p>LGD_EXCHANGERATE[,] (적용환율) : ${lguPORollBack.LGD_EXCHANGERATE}</p>
    <p>LGD_BUYER[,] (구매자명) : ${lguPORollBack.LGD_BUYER}</p>
    <p>LGD_BUYERID[,] (구매자아이디) : ${lguPORollBack.LGD_BUYERID}</p>
    <p>LGD_BUYERPHONE[,] (구매자휴대폰번호) : ${lguPORollBack.LGD_BUYERPHONE}</p>
    <p>LGD_BUYEREMAIL[,] (구매자메일) : ${lguPORollBack.LGD_BUYEREMAIL}</p>
    <p>LGD_PRODUCTINFO[,] (구매내역) : ${lguPORollBack.LGD_PRODUCTINFO}</p>
    <p>##### 파라메터 - 신용카드 #####</p>
    <p>LGD_CARDNUM[,] (신용카드번호) : ${lguPORollBack.LGD_CARDNUM}</p>
    <p>LGD_CARDINSTALLMONTH[,] (신용카드할부개월) : ${lguPORollBack.LGD_CARDINSTALLMONTH}</p>
    <p>LGD_CARDNOINTYN[,] (신용카드무이자여부) : ${lguPORollBack.LGD_CARDNOINTYN}</p>
    <p>LGD_FINANCEAUTHNUM[,] (결제기관승인번호) : ${lguPORollBack.LGD_FINANCEAUTHNUM}</p>
    <p>##### 파라메터 - 계좌이체무통장 #####</p>
    <p>LGD_CASHRECEIPTNUM[,] (현금영수증승인번호) : ${lguPORollBack.LGD_CASHRECEIPTNUM}</p>
    <p>LGD_CASHRECEIPTSELFYN[,] (현금영수증자진발급제유무) : ${lguPORollBack.LGD_CASHRECEIPTSELFYN}</p>
    <p>LGD_CASHRECEIPTKIND[,] (현금영수증종류) : ${lguPORollBack.LGD_CASHRECEIPTKIND}</p>
    <p>##### 파라메터 - 무통장 #####</p>
    <p>LGD_CASHRECEIPTNUM[,] (현금영수증승인번호) : ${lguPORollBack.LGD_CASHRECEIPTNUM}</p>
    <p>LGD_CASHRECEIPTSELFYN[,] (현금영수증자진발급제유무) : ${lguPORollBack.LGD_CASHRECEIPTSELFYN}</p>
    <p>LGD_CASHRECEIPTKIND[,] (현금영수증종류) : ${lguPORollBack.LGD_CASHRECEIPTKIND}</p>
    <p>LGD_ACCOUNTNUM[,] (가상계좌발급번호) : ${lguPORollBack.LGD_ACCOUNTNUM}</p>
    <p>LGD_CASTAMOUNT[,] (입금누적금액) : ${lguPORollBack.LGD_CASTAMOUNT}</p>
    <p>LGD_CASCAMOUNT[,] (현입금금액) : ${lguPORollBack.LGD_CASCAMOUNT}</p>
    <p>LGD_CASFLAG[,] (거래종류(R:할당,I:입금,C:취소)) : ${lguPORollBack.LGD_CASFLAG}</p>
    <p>LGD_CASSEQNO[,] (가상계좌일련번호) : ${lguPORollBack.LGD_CASSEQNO}</p>
    <p>##### 파라메터 - OK캐쉬백 #####</p>
    <p>LGD_OCBSAVEPOINT[,] (OK캐쉬백 적립포인트) : ${lguPORollBack.LGD_OCBSAVEPOINT}</p>
    <p>LGD_OCBAMOUNT[,] (OK캐쉬백 사용금액) : ${lguPORollBack.LGD_OCBAMOUNT}</p>
    <p>LGD_OCBTOTALPOINT[,] (OK캐쉬백 총누적포인트) : ${lguPORollBack.LGD_OCBTOTALPOINT}</p>
    <p>LGD_OCBUSABLEPOINT[,] (OK캐쉬백 사용가능포인트) : ${lguPORollBack.LGD_OCBUSABLEPOINT}</p>
    <p>##### 파라메터 - 상품권 #####</p>
    <p>LGD_FINANCEAUTHNUM[,] (결제기관승인번호) : ${lguPORollBack.LGD_FINANCEAUTHNUM}</p>
    <p>##### 파라메터 - 모바일T머니 #####</p>
    <p>LGD_TELNO[,] (결제휴대폰번호) : ${lguPORollBack.LGD_TELNO}</p>
  
 </t:putAttribute>
</t:insertDefinition>