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
	<t:putAttribute name="title">멤버쉽 통합</t:putAttribute>

    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	<c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
        VarMobile.server = '${server}';
        
      //모바일
        var _mobile = '${so.mobile}';
        var temp_mobile = Dmall.formatter.mobile(_mobile).split('-');
        $('#hp01').val(temp_mobile[0]);
        $('#hp02').val(temp_mobile[1]);
        $('#hp03').val(temp_mobile[2]);
        
        // 시/도 변경시 구/군 조회
    	$('#sel_sidoCode').on('change',function (){
            var optionSelected = $(this).find("option:selected").val();
            
            if (optionSelected.length == 0) {
                $('#sel_guGunCode').empty();
            	$('#sel_guGunCode').append('<option value="">구/군</option>');
            	return ;
            }
            
            var url = '${_MOBILE_PATH}/front/visit/change-sido';
            var param = {def1 : optionSelected};
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                $('#sel_guGunCode').empty();
            	$('#sel_guGunCode').append('<option value="">구/군</option>');
            	
                // 취득결과 셋팅
                jQuery.each(result, function(idx, obj) {
                	$('#sel_guGunCode').append('<option value="'+ obj.dtlCd + '">' + obj.dtlNm + '</option>');
                });
            });
        });
    	
    	//  구/군 변경시 매장 조회
		$('#sel_guGunCode').on('change',function (){
            var optionSelected = $(this).find("option:selected").val();
            
            if (optionSelected.length == 0) {
                $('#sel_strCode').empty();
            	$('#sel_strCode').append('<option value="">매장명</option>');
            	return ;
            }
            
            var url = '${_MOBILE_PATH}/front/visit/store-list';
            var sidoCode = $('#sel_sidoCode').find("option:selected").val();
            var param = {sidoCode : sidoCode, gugunCode : optionSelected};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
            	$('#sel_strCode').empty();
            	$('#sel_strCode').append('<option value="">매장명</option>');
            	
                // 취득결과 셋팅
                jQuery.each(result.strList, function(idx, obj) {
                	$('#sel_strCode').append('<option value="'+ obj.strCode + '">' + obj.strName + '</option>');
                });
            	
            });
        });
		
		// 다비전 회원 데이터 조회
		$('#btn_check_davision').on('click',function (){
			//이름
            if($('#custName').val() == '') {
                Dmall.LayerUtil.alert("이름을 입력해 주세요.", "확인");
                return false;
            }   
          	//휴대전화번호
            if($('#hp01').val() == '' || $('#hp02') == '' || $('#hp03') == '') {
                Dmall.LayerUtil.alert("휴대전화번호를 입력해 주세요.", "확인");
                return false;
            }else{
            	$('#hp').val($('#hp01').val()+$('#hp02').val()+$('#hp03').val())
            }   
          	//매장
            /* if($('#sel_strCode').val() == '') {
                Dmall.LayerUtil.alert("매장을 선택해 주세요.", "확인");
                return false;
            }  */
          
            var url = '${_MOBILE_PATH}/front/member/integration-possibility-check';
            var param = $('#form_id_integration').serializeArray();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
				if(result.success) {
					if(result.extraString == '1'){
						$('#member_match01').css('display','block');
						$('#member_match02').css('display','none');
						$('#member_match03').css('display','none');
						$('html, body').animate({ scrollTop: $('#member_match01').offset().top }, 'slow');
						$('#cdCust').val(result.data.cdCust);
						$('#lvl').val(result.data.lvl);
					}else if(result.extraString == '3'){
						$('#member_match03').css('display','block');
						$('#member_match01').css('display','none');
						$('#member_match02').css('display','none');
						$('html, body').animate({ scrollTop: $('#member_match03').offset().top }, 'slow');
					}else if(result.extraString == '2'){
						$('#member_match02').css('display','block');
						$('#member_match01').css('display','none');
						$('#member_match03').css('display','none');
						$('html, body').animate({ scrollTop: $('#member_match02').offset().top }, 'slow');
					}
				}else{
					
				}
			});
		});
		
		// 휴대폰 본인인증 "아니오" 버튼
		$('#btn_chk_mobile_no').on('click',function (){
			$('#member_match01').css('display','none');
		});
		
		// 휴대폰 본인인증
		$('#btn_chk_mobile').on('click',function (){
			/* DRMOK_window = window.open('', 'DRMOKWindow', 'width=460, height=680, resizable=0, scrollbars=no, status=no, titlebar=no, toolbar=no, left=435, top=250' );
            if(DRMOK_window == null){
                alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
            }
            $('#certifyMethodCd').val("mobile");

            var certUrl = '';
            console.log(VarMobile.server)
            if(VarMobile.server === 'local') {
                certUrl = 'https://dev.mobile-ok.com/popup/common/hscert.jsp';
            } else {
                certUrl = 'https://www.mobile-ok.com/popup/common/hscert.jsp';
            }

            document.reqDRMOKForm.action = certUrl;
            document.reqDRMOKForm.target = 'DRMOKWindow';
            document.reqDRMOKForm.submit(); */
            
			successIdentity();
		});
		
        $('#btn_go_store_list').click(function(){
			location.href = "${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/customer/store-list";
   		});
		
    });
    
	var VarMobile = {
		server:''
	};
    
	// 본인인증 성공 후 회원계정을 통합회원으로 전환
	function successIdentity(){
		
		Dmall.LayerUtil.confirm('\'확인\' 버튼을 누르시면 멤버쉽통합이 완료됩니다.', function() {
			var url = '${_MOBILE_PATH}/front/member/integration-update';
	        var param = $('#form_id_integration').serializeArray();
	        Dmall.AjaxUtil.getJSON(url, param, function(result) {
	            if(result.success) {
	                location.href="${_MOBILE_PATH}/front/member/integration-success-form";
	            }
	        });
		});
	}
	
  	//숫자만 입력 가능 메소드
    function onlyNumDecimalInput(event){
        var code = window.event.keyCode;

        if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
            window.event.returnValue = true;
            return;
        }else{
            window.event.returnValue = false;
            return false;
        }
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <div id="middle_area">
        <div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			멤버쉽 통합
		</div>
           	
       	<form name="reqDRMOKForm" method="post">
	        <input type="hidden" name="req_info" value ="${mo.reqInfo}" />
	        <input type="hidden" name="rtn_url" value ="${mo.rtnUrl}" />
	        <input type="hidden" name="cpid" value = "${mo.cpid}" />
	        <input type="hidden" name="design" value="pc"/>
	    </form>
    
    	<div class="cont_body">
			<div class="membership_combine">
				<p class="text">통합멤버쉽 안내</p>
			</div>
			
			<div class="check_my_information">
				<p class="tit">"본인의 정보와 일치하는 <em>다비치안경 회원정보</em>가 있는지 먼저 확인해 주세요."</p>
				<form:form id="form_id_integration" commandName="so">
					<input type="hidden" name="integrationMemberGbCd" id="integrationMemberGbCd"/>
					<input type="hidden" name="memberNo" id="memberNo" value="${so.memberNo }"/>
					<input type="hidden" name="hp" id="hp"/>
					<input type="hidden" name="cdCust" id="cdCust"/>
						<input type="hidden" name="lvl" id="lvl"/>
						<input type="hidden" name="onlineCardNo" id="onlineCardNo" value="${user.session.memberCardNo}"/>
					<table class="tInsert">
						<caption>개인회원 정보입력 폼입니다.</caption>
						<colgroup>
							<col style="width:30%">
							<col style="">
						</colgroup>
						<tbody>
							<tr>
								<th>이름</th>
								<td><input type="text" name="custName" id="custName" value="${so.memberNm }"></td>
							</tr>
							<tr>
								<th>휴대전화번호</th>
								<td>
									<%-- <select class="phone" id="hp01">
										<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
									</select> --%>
									<input type="text" class="phone" id="hp01" maxlength="3" onKeydown="return onlyNumDecimalInput(event);">
									<span class="bar">-</span>
									<input type="text" class="phone" id="hp02" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
									<span class="bar">-</span>
									<input type="text" class="phone" id="hp03" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
								</td>
							</tr>
							<tr>
								<th>최근방문매장</th>
								<td>
									<select class="shop_location" id="sel_sidoCode">
										<option>시/도</option>
										<c:forEach items="${codeListModel}" var="list">
	                                    	<option value="${list.dtlCd}">${list.dtlNm}</option>
	                                    </c:forEach>
									</select>
									<select class="shop_location" id="sel_guGunCode">
										<option>구/군</option>
									</select>
									<select class="shop_name" id="sel_strCode" name="strCode">
										<option value="">매장명</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</form:form>
				<div class="btn_membership_area">
					<button type="button" class="btn_check_okay2" id="btn_check_davision">확인</button>
				</div>
			
				<!--  회원정보 있는 경우 -->
				<div class="member_match" id="member_match01" style="display:none;">
					<i class="icon_match"></i>
					<div class="text_area">
						<p class="text">
							<em>일치하는 회원정보가 있습니다.</em>
							멤버쉽 통합절차를 진행하겠습니까?
						</p>
						
						<div class="btn_area">
							<button type="button" class="btn_check_no" id="btn_chk_mobile_no">아니오</button>
							<button type="button" class="btn_check_okay" id="btn_chk_mobile">예</button>
						</div>
					</div>
				</div>				
				<!--  회원정보 있는 경우 -->

				<!--  회원정보 없는 경우 -->
				<div class="member_no_match" id="member_match02" style="display:none;">
					<i class="icon_no_match"></i>
					<div class="text_area">
						<p class="text">
							<em>일치하는 회원정보가 없습니다.</em>
							다시 한 번 정확한 정보를 입력해 주세요
						</p>
					</div>
				</div>
				<!--  회원정보 없는 경우 -->

				<!--  회원정보 여러개 경우 -->
				<div class="member_no_match" id="member_match03" style="display:none;">
					<i class="icon_double_match"></i>
					<div class="text_area">
						<p class="text">
							<em>일치하는 회원정보가 여러 개 존재하여 지금은 멤버쉽통합을 진행할 수 없습니다.</em>
							가까운 다비치안경매장을 방문하셔서 회원정보를 확인해 주세요.<br>
							멤버쉽통합은 온라인, 오프라인에서 모두 처리 가능합니다.
						</p>
					</div>					
					<div class="btn_match_area double">
						<button type="button" class="btn_check_okay" id="btn_go_store_list">매장찾기</button>
					</div>
				</div>
				<!--  회원정보 여러개 경우 -->

			</div>
		</div><!-- //cont_body -->
    </div>
    </t:putAttribute>
</t:insertDefinition>