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
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">본인인증</t:putAttribute>
	
	
	
	<t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            //ipin auth popup
            $('.btn_auth_Ipin').click(function(){
                if($("#testYn").val() == 'Y'){
                    alert("본인인증없이 진행합니다. 테스트 데이터 입력란에 데이터를 넣어주셔야합니다.\ 인증테스트데이터를 모두 입력해주셔야진행됩니다.")
                    successIdentity();
                }else{
                   window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
                   document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
                   document.reqIPINForm.target = "popupIPIN2";
                   document.reqIPINForm.submit();
                }
            });
            var KMCIS_window;
            //mobile auth popup
            $('.btn_auth_mobile').click(function(){
                if($("#testYn").val() == 'Y'){
                    alert("본인인증없이 진행합니다. 테스트 데이터 입력란에 데이터를 넣어주셔야합니다.")
                    successIdentity();
                }else{
                    DRMOK_window = window.open('', 'DRMOKWindow', 'width=460, height=680, resizable=0, scrollbars=no, status=no, titlebar=no, toolbar=no, left=435, top=250' );
                    if(DRMOK_window == null){
                        alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
                    }
                    $('#certifyMethodCd').val("mobile");
                    document.reqDRMOKForm.action = 'http://dev.mobile-ok.com/popup/enhscert.jsp';
                    document.reqDRMOKForm.target = 'DRMOKWindow';
                    document.reqDRMOKForm.submit();
                }
            });
            // #ID SERACH_FORM
            $("#btn_id_search").click(function(){
                location.href="${_MOBILE_PATH}/front/login/account-search?mode=i";
            });
            // #PASSWORD SEARCH
            $("#btn_password_search").click(function(){
                location.href="${_MOBILE_PATH}/front/login/account-search?mode=p";
            });
        });

        // 본인인증후 가입여부 체크
        function successIdentity(){
            var url = '${_MOBILE_PATH}/front/login/account-detail'
            var data = $('#form_id_join').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.AjaxUtil.getJSON(url, param, function(result) {

                if(result.success) {
                    if(result.data != null && result.data.loginId != null){
                        $('#check_div').hide();
                        $('#duplicate_div').show();
                    }else{
                        var data = $('#form_id_join').serializeArray();
                        var param = {};
                        $(data).each(function(index,obj){
                            param[obj.name] = obj.value;
                        });
                        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/member/terms-apply-detail', param);
                    }
                }else{
                    Dmall.LayerUtil.alert("본인인증에 실패하였습니다.", "인증");
                }
            });
        }
    </script>
	</t:putAttribute>
	<t:putAttribute name="content">
   <%--
    <!--- contents --->
    <div class="contents">
        <form:form id="form_id_join">
        <br>테스트 데이터 입력--------------------------------------------------------------------------------
        <br>mode  <input type="text" name="mode" id="mode" value="j"/>
        <br>certifyMethodCd  <input type="text" name="certifyMethodCd" id="certifyMethodCd" value="IPIN"/>EX)IPIN,MOBILE
        <br>memberDi  <input type="text" name="memberDi" id="memberDi" value=""/>(임의의 아무데이터나 입력)
        <br>이름  <input type="text" name="memberNm" id="memberNm" />
        <br>생년월일  <input type="text" name="birth" id="birth"/>(19810612)
        <br>성별  <input type="text" name="genderGbCd" id="genderGbCd"/>(M:남,F:여)
        <br>국적코드  <input type="text" name="ntnGbCd" id="ntnGbCd" value="${so.memberGbCd}"/>(01:대한민국,02:미국,03:중국)
        <br>내/외국인  <input type="text" name="memberGbCd" id="memberGbCd"/>(10:내국인,20:외국인)
        <br>----------------------------------------------------------------------------------------------
        <br><b>인증없이 다음페이지를 진행하실분은  테스트 데이터의 빈칸을 채워주신후 옆 입력란에 Y를 넣고 인증하기를 눌러주세요.</b><input type="text" name="testYn" id="testYn"/><br><br><br><br><br>
        </form:form>
        <div id="member_location">
            <a href="">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>로그인
        </div>
        <ul class="join_steps">
            <li class="thisstep">본인인증</li>
            <li>약관동의</li>
            <li>회원정보입력</li>
            <li>가입완료</li>
        </ul>
        <ul class="auth_info">
            <li>- 본인인증을 통해 가입시에는 인증을 통해 회원가입이 진행되며, 주민등록번호를 기제 및 수집하지 않습니다.</li>
            <li>- 아이핀 인증을 통해 가입을 원하시면 하단의 아이핀 버튼을 클릭 후 가입하세요.</li>
        </ul>
        <ul class="auth_select">
            <li>
                아이핀인증<br>
                <button type="button" class="btn_auth_Ipin" id="">인증하기</button>
            </li>
            <li>
                휴대폰 인증<br>
                <button type="button" class="btn_auth_mobile" id="">인증하기</button>
            </li>
        </ul>
        <ul class="auth_info02">
            <li>※ 인증이 되지 않는다면 고객님께서 이용하신 인증기관의 고객센터로 문의해주세요. </li>
            <li>휴대전화 인증 오류 문의처 : KMC한국모바일인증 02-2033-8500</li>
            <li>아이핀 인증 오류 문의처 : 나이스평가정보 1600-1522</li>
            <li>기타 문의 : 고객센터 1234-5678</li>
        </ul>
        <!--- 중복확인 --->
        <div class="join_duplicate" id="duplicate_div" style="display: none;">
            회원님은 이미 회원으로 가입되어 있습니다.<br>
            로그인 해주세요.
            <div class="btn_area">
                <button type="button" class="btn_join_ok" >로그인</button>
                <button type="button" class="btn_go_mall" id="btn_id_search">아이디 찾기</button>
                <button type="button" class="btn_go_mall" id="btn_password_search">비밀번호 찾기</button>
            </div>
        </div>
        <!---// 중복확인 --->
    </div>
    <form name="reqDRMOKForm" method="post">
        <input type="hidden" name="req_info" value ="${mo.reqInfo}" />
        <input type="hidden" name="rtn_url" value ="${mo.rtnUrl}" />
        <input type="hidden" name="cpid" value = "${mo.cpid}" />
        <input type="hidden" name="design" value="pc"/>
    </form>
    <form name="reqIPINForm" method="post">
        <input type="hidden" name="m" value="pubmain">                      <!-- 필수 데이타로, 누락하시면 안됩니다. -->
        <input type="hidden" name="enc_data" value="${io.encData}">       <!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
        <!-- 업체에서 응답받기 원하는 데이타를 설정하기 위해 사용할 수 있으며, 인증결과 응답시
        해당 값을 그대로 송신합니다. 해당 파라미터는 추가하실 수 없습니다. -->
        <input type="hidden" name="param_r1" value="s">
    </form>
    <!---// contents --->
    --%>
    
    <form:form id="form_id_join">
    <%-- <br>테스트 데이터 입력--------------------------------------------------------------------------------
    <br>mode  <input type="text" name="mode" id="mode" value="j"/>
    <br>certifyMethodCd  <input type="text" name="certifyMethodCd" id="certifyMethodCd" value="IPIN"/>EX)IPIN,MOBILE
    <br>memberDi  <input type="text" name="memberDi" id="memberDi" value=""/>(임의의 아무데이터나 입력)
    <br>이름  <input type="text" name="memberNm" id="memberNm" />
    <br>생년월일  <input type="text" name="birth" id="birth"/>(19810612)
    <br>성별  <input type="text" name="genderGbCd" id="genderGbCd"/>(M:남,F:여)
    <br>국적코드  <input type="text" name="ntnGbCd" id="ntnGbCd" value="${so.memberGbCd}"/>(01:대한민국,02:미국,03:중국)
    <br>내/외국인  <input type="text" name="memberGbCd" id="memberGbCd"/>(10:내국인,20:외국인)
    <br>----------------------------------------------------------------------------------------------
    <br><b>인증없이 다음페이지를 진행하실분은  테스트 데이터의 빈칸을 채워주신후 옆 입력란에 Y를 넣고 인증하기를 눌러주세요.</b><input type="text" name="testYn" id="testYn"/><br><br><br><br><br> --%>
    <input type="hidden" name="mode" id="mode" value="j"/>
    <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="IPIN"/>
    <input type="hidden" name="memberDi" id="memberDi" value=""/>
    <input type="hidden" name="memberNm" id="memberNm" />
    <input type="hidden" name="birth" id="birth"/>
    <input type="hidden" name="genderGbCd" id="genderGbCd"/>
    <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.memberGbCd}"/>
    <input type="hidden" name="memberGbCd" id="memberGbCd"/>
    </form:form>
	<!--- 03.LAYOUT: MIDDLE AREA --->
	<div id="middle_area">
		<div class="cart_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			회원가입
		</div>	
		<ul class="join_steps">
			<li class="selected">
				<span class="icon_steps01"></span>
				<span class="title">본인인증</span>
			</li>
			<li>
				<span class="icon_steps02"></span>
				<span class="title">약관동의</span>
			</li>
			<li>
				<span class="icon_steps03"></span>
				<span class="title">회원정보입력</span>
			</li>
			<li>
				<span class="icon_steps04"></span>
				<span class="title">가입완료</span>
			</li>
		</ul>
		<div class="join_detail_area" id="check_div">
			<ul class="auth_id">
			<c:if test="${ioFlag && moFlag}">
				<li>
					<span class="icon_mobile"></span>
					<input type="radio" id="auth_select01" name="auth_select" class="btn_auth_mobile" checked >
					<label for="auth_select01"  style="margin-right:15px">
						<span></span>
						휴대폰 인증
					</label>
				</li>	
				<li>
					<span class="icon_gpin"></span>
					<input type="radio" id="auth_select02" name="auth_select" class="btn_auth_Ipin">
					<label for="auth_select02"  style="margin-right:15px">
						<span></span>
						I-PIN인증
					</label>
				</li>
			</c:if>
			<c:if test="${ioFlag && !moFlag}">
    			<li style="width:100%">
                    <span class="icon_gpin"></span>
                    <input type="radio" id="auth_select02" name="auth_select" class="btn_auth_Ipin">
                    <label for="auth_select02"  style="margin-right:15px">
                        <span></span>
                        I-PIN인증
                    </label>
                </li>
			</c:if>
			<c:if test="${!ioFlag && moFlag}">
			     <li style="width:100%">
                    <span class="icon_mobile"></span>
                    <input type="radio" id="auth_select01" name="auth_select" class="btn_auth_mobile" checked >
                    <label for="auth_select01"  style="margin-right:15px">
                        <span></span>
                        휴대폰 인증
                    </label>
                </li>
			</c:if>
			</ul>
			<div class="join_bottom_info">
				회원가입을 하시면 할인 및 마켓포인트 등 다양한 혜택을 받으실 수 있습니다.
			</div>
		</div>	
		<!--- 중복확인 --->
        <div class="join_duplicate" id="duplicate_div" style="display: none;">
           <!--  회원님은 이미 회원으로 가입되어 있습니다.<br>
            로그인 해주세요.
            <div class="btn_area">
                <button type="button" class="btn_join_ok" >로그인</button>
                <button type="button" class="btn_go_mall" id="btn_id_search">아이디 찾기</button>
                <button type="button" class="btn_go_mall" id="btn_password_search">비밀번호 찾기</button>
            </div> -->
            <div class="join_detail_area">
			<div class="join_member_auth">
				회원님은 이미 회원으로 가입되어있습니다.
				<span>로그인 해주세요.</span>
			</div>
			<ul class="member_login_smenu">
				<li class="login_smenu">
					<a href="#none" onclick="move_page('login');">로그인</a>
					<a href="#none" onclick="move_page('id_search');">아이디 찾기</a>
					<a href="#none" onclick="move_page('pass_search');">비밀번호 찾기</a>
				</li>
			</ul>
		</div>
        </div>
        <!---// 중복확인 --->	
	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
    <form name="reqDRMOKForm" method="post">
        <input type="hidden" name="req_info" value ="${mo.reqInfo}" />
        <input type="hidden" name="rtn_url" value ="${mo.rtnUrl}" />
        <input type="hidden" name="cpid" value = "${mo.cpid}" />
        <input type="hidden" name="design" value="pc"/>
    </form>
    <form name="reqIPINForm" method="post">
        <input type="hidden" name="m" value="pubmain">                      <!-- 필수 데이타로, 누락하시면 안됩니다. -->
        <input type="hidden" name="enc_data" value="${io.encData}">       <!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
        <!-- 업체에서 응답받기 원하는 데이타를 설정하기 위해 사용할 수 있으며, 인증결과 응답시
        해당 값을 그대로 송신합니다. 해당 파라미터는 추가하실 수 없습니다. -->
        <input type="hidden" name="param_r1" value="s">
    </form>
	</t:putAttribute>
</t:insertDefinition>