<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="popupLayout">
    <t:putAttribute name="title">LGU+ PC용(XPay)- 4.결제인증 응답처리 내역</t:putAttribute>
    <t:putAttribute name="script">
    <script>
    
    /*
	 * 인증결과 처리
	 */
	function payment_return() {
	
	    if ('${lguPO.LGD_RESPCODE}' == "0000") {
	              
	            document.getElementById("LGD_PAYKEY").value = "${lguPO.LGD_PAYKEY}";
	            document.getElementById("LGD_RESPCODE").value ="${lguPO.LGD_RESPCODE}";
	            document.getElementById("LGD_RESPMSG").value ="${lguPO.LGD_RESPMSG}";
	            document.getElementById("LGD_RETURNINFO").target = "_self";
	            document.getElementById("LGD_RETURNINFO").action = "/m/front/order/order-insert";
	            document.getElementById("LGD_RETURNINFO").submit();
	    } else {
	        
	        alert("결제실패 코드= ${lguPO.LGD_RESPCODE}\n" + "결제실패 메시지=${lguPO.LGD_RESPMSG}");
	    }
	}
    
    function setLGDResult() {
        payment_return();
        try {
        } catch (e) {
            alert(e.message);
        }
    }
    $(document).ready(function(){
        setLGDResult();
    });

    $(document).ready(function(){
       // setLGDResult();
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
<div id="LGD_PAYREQRETURNURL" style="display:none;">    
    <h1>LGU+ (인증결과-RETURN_URL )</h1>
    <div>
    <p>LGD_TXNAME (메소드): ${lguPO.LGD_TXNAME}</p>
    <p>### 파라메터 - 필수여부[PC, 스마트폰] ###</p>
    <p>LGD_RESPCODE[Y,Y] (응답코드) : ${lguPO.LGD_RESPCODE}</p>
    <p>LGD_RESPMSG[,] (응답메세지) : ${lguPO.LGD_RESPMSG}</p>
    <p>LGD_MID[Y,Y] (LG유플러스 발급 아이디) : ${lguPO.LGD_MID}</p>
    <p>LGD_OID[Y,Y] (이용업체 거래번호(주문번호)) : ${lguPO.LGD_OID}</p>
    <p>LGD_AMOUNT[Y,Y] (결제금액) : ${lguPO.LGD_AMOUNT}</p>
    <p>LGD_PAYKEY[Y,Y] (LG유플러스인증키) : ${lguPO.LGD_PAYKEY}</p>

    <p>
      <div class="btn_box">
        <button type="button" class="btn green"  id="btnRes" onclick="setLGDResult();">최종승인요청</button>
      </div>    
    </p>
<h1>### sampleReturnurl.jsp 파라메터 ###</h1>
<h1>### resultModel 파라메터 ###</h1>
<c:if test="${!empty resultModel}">
<c:forTokens items="${fn:trim(fn:replace(fn:replace(resultModel, 'ResultModel(', ''), ')', ''))}" delims="," var="rm" >
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
<h1>### paymentModel.extraMap 파라메터 ###</h1>
<c:if test="${!empty paymentModel.extraMap}">
<c:forEach items="${paymentModel.extraMap}" var="pmMap" >
        ${pmMap} <br/>
</c:forEach>
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

    <br>
    <form method="post" name="LGD_RETURNINFO" id="LGD_RETURNINFO">
      <c:forEach var="j" items="${paymentModel.extraMap}">
          <c:forEach var="k" items="${j.value}" varStatus="status">
              <input type="hidden" name="${j.key}" id="${j.key}" value="${k}" />    
          </c:forEach>
      </c:forEach>
	          <input type="hidden" name="LGD_RESPCODE" id="LGD_RESPCODE" value="" />
	          <input type="hidden" name="LGD_RESPMSG" id="LGD_RESPMSG" value="" />
	          <input type="hidden" name="LGD_PAYKEY" id="LGD_PAYKEY" value="" />
    </form>
    </div>
</div>
    </t:putAttribute>
</t:insertDefinition>