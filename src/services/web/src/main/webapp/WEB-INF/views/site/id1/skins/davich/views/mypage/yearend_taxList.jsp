<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 연말정산내역</t:putAttribute>
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script type="text/javascript">
    $(document).ready(function(){
    	
    	selectYear();
    	
        /* 년도 변경 */
        $('#selectYear').on('change',function (){
            var optionSelected = $(this).find("option:selected").val();
            var param = {yyyy : optionSelected};
            Dmall.FormUtil.submit('/front/member/yearend-taxList', param);
        });
        
        $('.btn_form').on('click',function (){
            var curr_date = new Date();
            var year = curr_date.getFullYear();
            var month = curr_date.getMonth()+1;
            var day = curr_date.getDate();

        	if(year > 2021) {
                Dmall.LayerUtil.alert('국세청 신고때문에 전송이 불가능합니다 가맹점에 문의바랍니다');
                return;
			}

        	
    		if(integration == '01'){
    			Dmall.LayerUtil.confirm('통합멤버쉽 회원만 이용하실 수 있습니다.<br>지금 멤버쉽 통합절차를 진행할까요?', function() {
    	            location.href="/front/member/member-integration-form";
    	        });
    	     	return false;   
    		}
    		else if(integration == '02'){
    			Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
    	            location.href="/front/member/information-update-form";
    	        });
    			return false;
    		}
        	
        	var idno1 = $('#idno1').val();
        	var idno2 = $('#idno2').val();
        	var resNo = $('#idno1').val() + $('#idno2').val() + ''; 
        	
        	if (idno1 == null || idno1 == "" || idno1 == undefined ||
        			idno2 == null || idno2 == "" || idno2 == undefined ) {
                 Dmall.LayerUtil.alert('주민등록 번호를 입력해 주십시요');
                 return;
        	}
        	
        	if (!rrnCheck(resNo)) {
                Dmall.LayerUtil.alert('주민등록 번호 형식이 올바르지 않습니다');
                return;
        	}
        	
        	var url = "/front/member/yearend-auto";
            var param = {resNo : resNo};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
            	if (result.result == "1") {
                    Dmall.LayerUtil.alert('정상적으로 등록되었습니다');
            	} else {
                    Dmall.LayerUtil.alert(result.message);
            	}
            });
        });
        
    });
    
    function onlyNumber(){
        if((event.keyCode<48)||(event.keyCode>57))
           event.returnValue=false;
	}
    
    // 기간검색_년
    function selectYear(){
        var toDay = new Date();
        var year  = toDay.getFullYear();
        
        jQuery("#select1").remove();
        jQuery("#selectId").append("<span class='select' id='select1'><select id='selectYear'></select></span> ");
        
        var yearData = Number(year);
        for(var i = yearData; i > yearData-4; i--){
            jQuery("#selectYear").append("<option value='"+ i + "'>"+ i +"년</option>");
        }
        
        var yyyy = "${so.yyyy}";
        
        if (yyyy == null || yyyy == "" || yyyy == undefined) {
            $("#selectYear > option[value='"+ yearData +"']").attr("selected", true);
        } else {
            $("#selectYear > option[value='"+ yyyy +"']").attr("selected", true);
        }
    }    	
    
    
    function rrnCheck(rrn)
    {
        var sum = 0;
        if (rrn.length != 13) {
            return false;
        } else if (rrn.substr(6, 1) != 1 && rrn.substr(6, 1) != 2 && rrn.substr(6, 1) != 3 && rrn.substr(6, 1) != 4) {
            return false;
        }

        for (var i = 0; i < 12; i++) {
            sum += Number(rrn.substr(i, 1)) * ((i % 8) + 2);
        }
        if (((11 - (sum % 11)) % 10) == Number(rrn.substr(12, 1))) {
            return true;
        }
        return false;
    }
    
    
    function viewVisitInfoDtl(rsvNo){
        Dmall.FormUtil.submit('/front/visit/visit-detail', {rsvNo : rsvNo});
    }    
    
    function fn_print(cdCust, strCode, dates) {
    	
    	
    	var nWidth = "800";
    	var nHeight = "750";
    	  
    	// 듀얼 모니터 고려한 윈도우 띄우기
    	var curX = window.screenLeft;
    	var curY = window.screenTop;
    	var curWidth = document.body.clientWidth;
    	var curHeight = document.body.clientHeight;
    	  
    	var nLeft = curX + (curWidth / 2) - (nWidth / 2);
    	var nTop = curY + (curHeight / 2) - (nHeight / 2);

    	var strOption = "";
    	strOption += "left=" + nLeft + "px,";
    	strOption += "top=" + nTop + "px,";
    	strOption += "width=" + nWidth + "px,";
    	strOption += "height=" + nHeight + "px,";
    	strOption += "toolbar=no,menubar=no,location=no,scrollbars=1";
    	strOption += "resizable=no,status=yes";
    	  
        var url = '/front/member/yearend-taxPrint?cdCust=' + cdCust + '&strCode=' + strCode + '&yyyy=' + dates;
    	var winObj = window.open(url, "연말정산", strOption);
    	if (winObj == null) {
    	    alert("팝업 차단을 해제해주세요.");
    	    return false;
    	}    	
    }
    
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->

    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="mypage_middle">	

            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div id="mypage_content">
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
	            
	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
	            
				<div class="mypage_body">
					<h3 class="my_tit">연말정산</h3>
						<br>
						<p class="yearend_tit">아래 두 가지 방법 중 선택하여 진행해 주세요.<br>
						 <%--  <span>※ 국세청 자동신고기간이 종료되어 현재 직접 제출의 방식만 가능합니다.</span>--%>
						</p>
						<p class="yearend_stit">			
                            1. 국세청 연말정산 간소화 서비스 사전 신청<span style="color:red">(운영기간 3월1일 ~ 12월31일):통합회원만</span> 신청이 가능한 서비스로 <span style="color:red">해당년도에 구매하신 정보</span>를 국세청 연말정산 간소화 서비스 자료 제출을 통해 연말정산 간소화 서비스를 이용할 수 있는 서비스 입니다.
						</p>
					
					<div class="filter_datepicker">
						<label for="" class="label_idno">주민등록번호</label>
						<input style="display:none">
						<input type="password" style="display:none">
						<input type="text" class="form_idno" id="idno1" autocomplete="new-password" maxlength="6" onkeypress="onlyNumber();"> - <input type="password" class="form_idno" id="idno2" autocomplete="new-password" maxlength="7" onkeypress="onlyNumber();">
						<button type="button" class="btn_form" style="width:178px;">개인정보 연동 동의 후 저장</button>
						<span style="display: inline-block;text-align: left; margin: 0 0 0 10px;vertical-align: -10px;">연말정산 간소화 서비스 <br> 매년 1월 15일 (국세청오픈)</span>
						<%--<span class="stateRed">※ 자동신고 기간이 종료되었습니다.</span>--%>
					</div>
						
					<div class="my_qna_info">	
						<p class="yearend_stit02">			
							<b>2. 구매내역 출력하여 직접 제출</b> : 연도 선택 후 '출력하기' 버튼을 눌러 영수증 확인 후 인쇄하여 직접 제출
						</p>
						<div class="my_search_area" id="selectId">							
						</div>
					</div>
					<table class="tProduct_Board">
						<caption>
							<h1 class="blind">연말정산 내역 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:10%">
							<col style="width:25%">
							<col style="width:30%">
							<col style="width:20%">
							<col style="width:15%">
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>성명</th>
								<th>구입매장</th>
								<th>구매년도</th>
								<th>연말정산출력</th>
							</tr>
						</thead>
						<tbody>
                            <c:forEach var="yearList" items="${yearList}" varStatus="status">
								<tr>
									<td>${status.count}</td>		
									<td>${yearList.nmCust}</td>					
									<td>${yearList.strName}</td>
									<td>${yearList.dates} 년</td>
									<td>
										<button type="button" class="btn_ordered" onclick="fn_print('${yearList.cdCust}','${yearList.strCode}','${yearList.dates}');">출력하기</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				</form:form>
			</div>		
			<!--// content -->	            
    </div>
    <!---// 마이페이지 메인 --->
	<div id="divTaxPop">
	</div>
    
    </t:putAttribute>
</t:insertDefinition>	            
