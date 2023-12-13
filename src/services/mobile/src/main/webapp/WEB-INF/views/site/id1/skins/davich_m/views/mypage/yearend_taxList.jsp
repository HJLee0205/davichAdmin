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
	<t:putAttribute name="title">연말정산</t:putAttribute>
	
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
	    $(document).ready(function(){
	    	
	    	selectYear();
	    	
	        /* 년도 변경 */
	        $('#selectYear').on('change',function (){
	            var optionSelected = $(this).find("option:selected").val();
	            var param = {yyyy : optionSelected};
	            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/member/yearend-taxList', param);
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
	        	
	        	var url = "${_MOBILE_PATH}/front/member/yearend-auto";
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
	        jQuery("#selectId").append("<span class='select' id='select1'><select id='selectYear' class='floatR'></select></span> ");
	        
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
	        var url = '${_MOBILE_PATH}/front/member/yearend-taxPrint?cdCust=' + cdCust + '&strCode=' + strCode + '&yyyy=' + dates;
	    		
	        $('#div_year_popup').empty();
    		Dmall.AjaxUtil.load(url, function(result) {
                $('#div_year_popup').html(result).promise().done(function(){
                    $('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
                }); ;
                Dmall.LayerPopupUtil.open($('#div_year_popup'));
    		});
	    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			연말정산
		</div>
		<p class="yearend_tit">아래 두 가지 방법 중 선택하여 진행해 주세요.<br>
		   <%--<span>※ 국세청 자동신고기간이 종료되어 현재 직접 제출의 방식만 가능합니다.</span>--%>
		</p>		
		<div class="cont_body">			
			<p class="yearend_stit">			
				1. 국세청 연말정산 간소화 서비스 사전 신청<span style="color:red">(운영기간 3월1일 ~ 12월31일):통합회원만</span> 신청이 가능한 서비스로 <span style="color:red">해당년도에 구매하신 정보</span>를 국세청 연말정산 간소화 서비스 자료 제출을 통해 연말정산 간소화 서비스를 이용할 수 있는 서비스 입니다.
			</p>
			<div class="filter_datepicker">
				<label for="" class="label_idno">주민등록번호</label>
				<input type="text" class="form_idno" id="idno1" autocomplete="false" maxlength="6" onkeypress="onlyNumber();" style="width:calc(50% - 23px)"> - <input type="password" class="form_idno" id="idno2" autocomplete="false" maxlength="7" onkeypress="onlyNumber();" style="width:calc(50% - 23px)">
				<button type="button" class="btn_form" style="width:100%;margin-top:10px;">개인정보 연동 동의 후 저장</button>
				<span style="display: inline-block;text-align: left; margin: 0 0 0 10px;vertical-align: -10px;">연말정산 간소화 서비스 : 매년 1월 15일 (국세청오픈)</span>
				<%--<p style="margin-top:6px;color:#e34000;">※ 자동신고 기간이 종료되었습니다.</p>--%>
			</div>

			<p class="yearend_stit02">			
				<b>2. 구매내역 출력하여 직접 제출</b><br>
				연도 선택 후 '출력하기' 버튼을 눌러 영수증 확인 후 인쇄하여 직접 제출
			</p>
			<div class="bill_select">
				<div class="my_search_area" id="selectId">							
				</div>
			</div>
			<table class="tProduct_Board offline bill">
				<caption>
					<h1 class="blind">연말정산 내역 목록입니다.</h1>
				</caption>
				<colgroup>
					<col style="width:20%">
					<col style="width:30%">
					<col style="width:20%">
					<col style="width:30%">
				</colgroup>
				<tbody>
                    <c:forEach var="yearList" items="${yearList}" varStatus="status">
						<tr>
							<th class="textL" colspan="4">
								<span class="offline_date">${status.count}</span>
								<span class="floatR">성명 : ${yearList.nmCust}</span>
							</th>
						</tr>
						<tr>	
							<td class="stit">구입매장</td>
							<td>${yearList.strName}</td>
							<td class="stit">구매년도</td>
							<td>${yearList.dates} 년</td>
						</tr>
						<tr class="bill">	
							<td colspan="4" class="textC">
								<button type="button" class="btn_bill_print" onclick="fn_print('${yearList.cdCust}','${yearList.strCode}','${yearList.dates}');">영수증보기</button>
							</td>
						</tr>						
					</c:forEach>
				</tbody>
			</table>
		</div>	

	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
	<div id="div_year_popup">
	</div>
    
    </t:putAttribute>
</t:insertDefinition>