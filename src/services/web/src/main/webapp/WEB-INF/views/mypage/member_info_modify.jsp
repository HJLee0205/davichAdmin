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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">개인정보수정</t:putAttribute>


 <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script src="/front/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
    <script>
    $(document).ready(function(){
        setCalendar();
        <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
        VarMobile.server = '${server}';

        // 우편번호
        jQuery('.btn_post').on('click', function(e) {
            Dmall.LayerPopupUtil.zipcode(setZipcode);
        });
        $('#select_id_month').on('change', function() {
            var d = new Date(),
                    lastDate,
                    html = '<option value="" selected="selected">일</option>';
            d.setFullYear($('#select_id_year').val(), this.value, 1);
            d.setDate(0);
            lastDate = d;
            for(var i = 1; i <= lastDate.getDate(); i++) {
                if(i<10){
                    html += '<option value="0' + i + '">0' + i + '</option>';
                }else{
                    html += '<option value="' + i + '">' + i + '</option>';
                }

            }
            $('#select_id_date').html(html).trigger('change');
        });
        //e-mail selectBox
        var emailSelect = $('#email03');
        var emailTarget = $('#email02');
        emailSelect.bind('change', null, function() {
            var host = this.value;
            if (host != 'etc' && host != '') {
                emailTarget.attr('readonly', true);
                emailTarget.val(host).change();
            } else if (host == 'etc') {
                emailTarget.attr('readonly'
                        , false);
                emailTarget.val('').change();
                emailTarget.focus();
            } else {
                emailTarget.attr('readonly', true);
                emailTarget.val('').change();
            }
        });

        //이메일
        var _email = '${resultModel.data.email}';
        var temp_email = _email.split('@');
        $('#email01').val(temp_email[0]);
        if(emailSelect.find('option[value="'+temp_email[1]+'"]').length > 0) {
           emailSelect.val(temp_email[1]);
        } else {
           emailSelect.val('etc');
        }
        emailSelect.trigger('change');
        emailTarget.val(temp_email[1]);

        //일반전화
        var _tel = '${resultModel.data.tel}';
        var temp_tel = Dmall.formatter.tel(_tel).split('-');
        $('#tel01').val(temp_tel[0]);
        $('#tel02').val(temp_tel[1]);
        $('#tel03').val(temp_tel[2]);
        $('#tel01').trigger('change');

        //모바일
        var _mobile = '${resultModel.data.mobile}';
        var temp_mobile = Dmall.formatter.mobile(_mobile).split('-');
        $('#mobile01').val(temp_mobile[0]);
        $('#mobile02').val(temp_mobile[1]);
        $('#mobile03').val(temp_mobile[2]);
        $('#mobile01').trigger('change');

        //성별
        var _gender = '${resultModel.data.genderGbCd}';
        $('input:radio[name="genderGbCd"]:input[value="'+_gender+'"]').prop("checked",true);

        //지역 구분
        var memberGbCd = '${resultModel.data.memberGbCd}';
        if(memberGbCd == '10')$('.radio_chack_a').click();
        if(memberGbCd == '20')$('.radio_chack_b').click();

        //회원정보 수정실행
        $('.btn_join_ok').on('click',function (){
            var joinShopCd = "${resultModel.data.joinPathCd}";
            if(joinShopCd === 'SHOP') {
                if(Dmall.validation.isEmpty($("#pw").val())) {
                    Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "알림");
                    return false;
                }
            }

            if($('#select_birth_year').length > 0) {
                var year = jQuery('#select_birth_year option:selected').val();
                var month = jQuery('#select_birth_month option:selected').val();
                var date = jQuery('#select_birth_day option:selected').val();

                if(year == '' || month == '' || date == '') {
                    Dmall.LayerUtil.alert("생일을  입력해주세요.", "확인");
                    return false;
                } else {
                    $('#birth').val(year+month+date);
                    $('#bornYear').val(year);
                    $('#bornMonth').val(month);
                }
            }
            Dmall.validate.set('form_id_update');
            if(customerInputCheck()){
                var url = '/front/member/member-update';
                var param = $('#form_id_update').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        Dmall.LayerUtil.alert("회원정보가 성공적으로 변경되었습니다.", "알림");
                        location.href="/front/member/information-update-form";
                    }
                });
            }
        });

        $('#btn_change_pw').on('click',function (){
            resetPwPopup();
            Dmall.LayerPopupUtil.open($('#popup_new_pw'));
        });
        $('#btn_change_cofirm').on('click',function (){
            if ($('#newPw').val().indexOf($('#loginId').val()) > -1) {
                Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "확인");
                return false;
            }
            if( $('#newPw').val() !=  $('#newPw_check').val()){
                Dmall.LayerUtil.alert("비밀번호 입력/확인이 일치하지 않습니다.", "알림");
                return;
            }
            if(passwordCheck($('#newPw').val())){
                var url = '/front/member/update-password';
                var param = $('#form_id_pw_pop').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         Dmall.LayerUtil.alert("비밀번호가 성공적으로 변경되었습니다.", "알림");
                         Dmall.LayerPopupUtil.close("popup_new_pw");
                     }
                });
            }
        });

        $("#mobile_auth").click(function(){
            openDRMOKWindow();
        });
        $("#ipin_auth").click(function(){
            openIPINWindow();
        });
    });

    var VarMobile = {
        server:''
    };

    // mobile auth popup
    var KMCIS_window;
    function openDRMOKWindow(){
        DRMOK_window = window.open('', 'DRMOKWindow', 'width=460, height=680, resizable=0, scrollbars=no, status=no, titlebar=no, toolbar=no, left=435, top=250' );
        if(DRMOK_window == null){
            alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
        }

        var certUrl = '';
        if(VarMobile.server === 'local') {
            certUrl = 'https://dev.mobile-ok.com/popup/common/hscert.jsp';
        } else {
            certUrl = 'https://www.mobile-ok.com/popup/common/hscert.jsp';
        }

        document.reqDRMOKForm.action = certUrl;
        document.reqDRMOKForm.target = 'DRMOKWindow';
        document.reqDRMOKForm.submit();
    }
    // ipin auth popup
    function openIPINWindow(){
        window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
        document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
        document.reqIPINForm.target = "popupIPIN2";
        document.reqIPINForm.submit();
    }

    function successIdentity(){
        var url = '/front/member/identity-success';
        var param = $('#form_id_update').serializeArray();
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                Dmall.LayerUtil.alert("본인인증 완료되었습니다.", "알림");
                location.href = "/front/member/information-update-form"
            }
        });
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 정보 <span>&gt;</span>개인정보 수정
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    개인정보 수정
                </h3>
                <!--- 기본정보 --->
                <form:form id="form_id_update" commandName="vo">
                <form:hidden path="memberDi" id="memberDi" value=""/>
                <form:hidden path="certifyMethodCd" id="certifyMethodCd" value=""/>
                <form:hidden path="emailRecvYn" id="emailRecvYn" />
                <form:hidden path="smsRecvYn" id="smsRecvYn" />
                <form:hidden path="tel" id="tel" />
                <form:hidden path="mobile" id="mobile" />
                <form:hidden path="email" id="email" />
                <form:hidden path="birth" id="birth" />
                <form:hidden path="bornYear" id="bornYear"/>
                <form:hidden path="bornMonth" id="bornMonth"/>
                <form:hidden path="memberGbCd" id="memberGbCd" />
                <table class="tMember_Insert">
                    <caption>
                        <h1 class="blind">회원가입 필수입력폼 테이블입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:150px">
                        <col style="">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><em>*</em>회원구분</th>
                            <td>${resultModel.data.memberGradeNm}</td>
                        </tr>
                        <tr>
                            <th><em>*</em>이름</th>
                            <td>
                                <input type="text" id="memberNm" name="memberNm" style="width:232px;" value="${resultModel.data.memberNm}" readonly="readonly">
                            </td>
                        </tr>
                        <tr>
                            <th><em>*</em>아이디</th>
                            <td>
                                <input type="text" id="loginId" name="loginId" style="width:232px;" value="${resultModel.data.loginId}" readonly="readonly">
                            </td>
                        </tr>
                        <!-- 비밀번호 입력란은 일반 회원가입일때만 보여준다(SNS 로그인은 안보여줌) -->
                        <c:if test="${resultModel.data.joinPathCd eq 'SHOP'}">
                            <tr>
                                <th><em>*</em>비밀번호</th>
                                <td>
                                    <input type="password" id="pw" name="pw" style="width:124px;margin-right:10px" placeholder="비밀번호 입력" maxlength="16">
                                    <button type="button" class="btn_password" id="btn_change_pw">비밀번호변경</button>
                                </td>
                            </tr>
                        </c:if>
                        <tr><!--160608추가-->
                            <th><em>*</em>본인인증</th>
                            <td>
                                <c:if test="${resultModel.data.realnmCertifyYn eq 'Y'}">
                                <span class="mp_confirm fRed">본인인증 완료</span>
                                </c:if>
                                <c:if test="${resultModel.data.realnmCertifyYn ne 'Y'}">
                                 <span class="mp_confirm fRed">본인인증 미완료</span>
                                     <c:if test="${io ne null}">
                                        <button type="button" class="btn_password" style="margin-left:8px" id="ipin_auth">아이핀인증</button>
                                     </c:if>
                                     <c:if test="${mo ne null}">
                                        <button type="button" class="btn_password" style="margin-left:8px" id="mobile_auth">휴대전화인증</button>
                                     </c:if>
                                 </c:if>
                            </td>
                        </tr><!--//160608추가-->
                        <tr>
                            <th class="order_tit">거주지</th>
                            <td>
                                <input type="radio" id="shipping_internal" name="shipping" checked="checked">
                                <label for="shipping_internal" class="radio_chack_a" style="margin-right:15px">
                                    <span></span>
                                    국내
                                </label>
                                <input type="radio" id="shipping_oversea" name="shipping">
                                <label for="shipping_oversea" class="radio_chack_b" style="margin-right:15px">
                                    <span></span>
                                    해외
                                </label>
                            </td>
                        </tr>

                        <!--국내 선택시 default-->
                        <tr class="radio_con_a">
                            <th class="order_tit" ><em>*</em>주소</th>
                            <td>
                                <ul class="address_insert">
                                    <li>
                                        <input type="text" id="newPostNo" name="newPostNo" value="${resultModel.data.newPostNo}" style="width:124px;margin-right:5px" readonly="readonly">
                                        <button type="button" class="btn_post">우편번호</button>
                                    </li>
                                    <li>
                                    <span class="address_tit" style="width:65px">지번주소</span>
                                    <input type="text" id="strtnbAddr" name="strtnbAddr" value="${resultModel.data.strtnbAddr}" style="width:371PX;" readonly="readonly">
                                    </li>
                                    <li>
                                    <span class="address_tit" style="width:65px;">도로명주소</span>
                                    <input type="text" id="roadAddr" name="roadAddr" value="${resultModel.data.roadAddr}" style="width:371PX;" readonly="readonly">
                                    </li>
                                    <li style="margin-bottom:2px">
                                    <span class="address_tit" style="width:65px">상세주소</span>
                                    <input type="text" id="dtlAddr" name="dtlAddr" value="${resultModel.data.dtlAddr}" style="width:371PX">
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <!--//국내 선택시 default-->

                        <!--해외 선택시-->
                        <tr class="radio_con_b" style="display:none;">
                            <th class="order_tit" ><em>*</em>주소</th>
                            <td>
                                <ul class="address_insert">
                                    <li><span class="address_tit" style="width:65px">Country</span>
                                        <div id="shipping_country" class="select_box28" style="width:578px;display:inline-block" >
                                            <label for="frgAddrCountry"></label>
                                            <select id="frgAddrCountry" name="frgAddrCountry" class="select_option" title="select option">
                                                <code:optionUDV codeGrp="COUNTRY_CD" includeTotal="true" mode="S" value="${resultModel.data.frgAddrCountry}"/>
                                            </select>
                                        </div>
                                    </li>
                                    <li>
                                    <span class="address_tit" style="width:65px">Zip</span>
                                    <input type="text" id="frgAddrZipCode" name="frgAddrZipCode" value="${resultModel.data.frgAddrZipCode}"style="width:371PX;">
                                    </li>
                                    <li>
                                    <span class="address_tit" style="width:65px">State</span>
                                    <input type="text" id="frgAddrState" name="frgAddrState" value="${resultModel.data.frgAddrState}" style="width:371PX;">
                                    </li>
                                    <li>
                                    <span class="address_tit" style="width:65px">City</span>
                                    <input type="text" id="frgAddrCity" name="frgAddrCity" value="${resultModel.data.frgAddrCity}" style="width:371PX;">
                                    </li>
                                    <li>
                                    <span class="address_tit" style="width:65px">address1</span>
                                    <input type="text" id="frgAddrDtl1" name="frgAddrDtl1" value="${resultModel.data.frgAddrDtl1}" style="width:371PX;">
                                    </li>
                                    <li>
                                    <span class="address_tit" style="width:65px">address2</span>
                                    <input type="text" id="frgAddrDtl2" name="frgAddrDtl2" value="${resultModel.data.frgAddrDtl2}" style="width:371PX;">
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <!--//해외 선택시-->
                        <tr>
                            <th><em>*</em>이메일</th>
                            <td>
                                <input type="text" id="email01" style="width:124px;"> @ <input type="text" id="email02" style="width:124px;">
                                <div class="select_box28" style="display:inline-block">
                                    <label for="email03"></label>
                                    <select class="select_option" id="email03" title="select option">
                                        <option value="" selected="selected">- 이메일 선택 -</option>
                                        <option value="naver.com">naver.com</option>
                                        <option value="daum.net">daum.net</option>
                                        <option value="nate.com">nate.com</option>
                                        <option value="hotmail.com">hotmail.com</option>
                                        <option value="yahoo.com">yahoo.com</option>
                                        <option value="empas.com">empas.com</option>
                                        <option value="korea.com">korea.com</option>
                                        <option value="dreamwiz.com">dreamwiz.com</option>
                                        <option value="gmail.com">gmail.com</option>
                                        <option value="etc">직접입력</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>일반전화</th>
                            <td>
                                <div class="select_box28" style="width:69px;display:inline-block">
                                    <label for="tel01"></label>
                                    <select id="tel01"  class="select_option" title="select option">
                                        <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" includeTotal="true" mode="S"/>
                                    </select>
                                </div>
                                -
                                <input type="text" id="tel02" style="width:67px" maxlength="4">
                                -
                                <input type="text" id="tel03" style="width:67px" maxlength="4">
                            </td>
                        </tr>
                        <tr>
                            <th><em>*</em>휴대전화</th>
                            <td>
                                <div class="select_box28" style="width:69px;display:inline-block">
                                    <label for="mobile01"></label>
                                    <select id="mobile01" class="select_option" title="select option">
                                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                    </select>
                                </div>
                                -
                                <input type="text" id="mobile02" style="width:67px" maxlength="4">
                                -
                                <input type="text" id="mobile03" style="width:67px" maxlength="4">
                            </td>
                        </tr>
                        <tr>
                            <th><em>*</em>정보 수신여부</th>
                            <td class="email_checkbox">
                                <label>
                                    <input type="checkbox" name="sms_get" id="sms_get" <c:if test="${resultModel.data.smsRecvYn eq 'Y'}">checked</c:if> />
                                    <span></span>
                                </label>
                                <label for="sms_get" style="margin-right:44px">SMS</label>
                                <label>
                                    <input type="checkbox" name="email_get" id="email_get" <c:if test="${resultModel.data.emailRecvYn eq 'Y'}">checked</c:if>>
                                    <span></span>
                                </label>
                                <label for="email_get">E-MAIL</label>
                            </td>
                        </tr>
                        <tr>
                            <c:set var="year" value=""/>
                            <c:set var="month" value=""/>
                            <c:set var="day" value=""/>
                            <c:if test="${!empty resultModel.data.birth}">
                                <c:if test="${fn:length(resultModel.data.birth) == 8}">
                                    <c:set var="year" value="${fn:substring(resultModel.data.birth,0,4)}"/>
                                    <c:set var="month" value="${fn:substring(resultModel.data.birth,4,6)}"/>
                                    <c:set var="day" value="${fn:substring(resultModel.data.birth,6,8)}"/>
                                </c:if>
                            </c:if>
                            <th><em>*</em>생년월일</th>
                            <td>
                                <div id="birth_year" class="select_box28" style="width:67px;display:inline-block">
                                    <label for="select_option">선택</label>
                                    <select class="select_option" id="select_birth_year" title="select option">
                                        <option value="" selected>선택</option>
                                        <c:forEach var="birthYear" begin="1950" end="2016">
                                            <c:set var="selected" value=""/>
                                            <fmt:formatNumber var="timePattern" value="${birthYear}" pattern="0000"/>
                                            <c:if test="${year eq timePattern}">
                                                <c:set var="selected" value="selected"/>
                                            </c:if>
                                            <option value="${timePattern}" ${selected}>${timePattern}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                년
                                <div id="birth_month" class="select_box28" style="width:67px;display:inline-block">
                                    <label for="select_option">00</label>
                                    <select class="select_option" id="select_birth_month" title="select option">
                                        <option value="" selected>선택</option>
                                        <c:forEach var="birthMonth" begin="1" end="12">
                                            <c:set var="selected" value=""/>
                                            <fmt:formatNumber var="timePattern" value="${birthMonth}" pattern="00"/>
                                            <c:if test="${month eq timePattern}">
                                                <c:set var="selected" value="selected"/>
                                            </c:if>
                                            <option value="${timePattern}" ${selected}>${timePattern}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                월
                                <div id="birth_day" class="select_box28" style="width:67px;display:inline-block">
                                    <label for="select_option">선택</label>
                                    <select class="select_option" id="select_birth_day" title="select option">
                                        <option value="" selected>선택</option>
                                        <c:forEach var="birthDay" begin="01" end="31">
                                            <c:set var="selected" value=""/>
                                            <fmt:formatNumber var="timePattern" value="${birthDay}" pattern="00"/>
                                            <c:if test="${day eq timePattern}">
                                                <c:set var="selected" value="selected"/>
                                            </c:if>
                                            <option value="${timePattern}" ${selected}>${timePattern}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                일
                            </td>
                        </tr>
                        <tr>
                            <th>성별</th>
                            <td>
                            <input type="radio" id="male" name="genderGbCd"  value="M" >
                            <label for="male"  style="margin-right:24px">
                                <span></span>
                                남
                            </label>
                            <input type="radio" id="female" name="genderGbCd" value="F">
                            <label for="female"  style="margin-right:44px">
                                <span></span>
                                여
                            </label>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form:form>
                <div class="btn_area">
                    <button type="button" class="btn_join_ok">회원정보수정</button>
                </div>
                <!---// 기본정보 --->
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    <!--- popup 새 비밀번호 입력 --->
    <div class="popup_new_pw" id="popup_new_pw" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">새 비밀번호 입력</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <span class="f13">새로운 비밀번호를 입력해 주세요.</span>
            <form id="form_id_pw_pop">
            <table class="tMember_Insert" style="margin-top:10px">
                <caption>
                    <h1 class="blind">새 비밀번호 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:140px">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th style="padding:5px 7px">현재 비밀번호</th>
                        <td style="padding:5px 7px"><input type="password" name="nowPw" id="nowPw" style="width:165px;" maxlength="16"></td>
                    </tr>
                    <tr>
                        <th style="padding:5px 7px">새 비밀번호</th>
                        <td style="padding:5px 7px"><input type="password" name="newPw" id="newPw" style="width:165px;" maxlength="16"></td>
                    </tr>
                    <tr>
                        <th style="padding:5px 7px">새 비밀번호 확인</th>
                        <td style="padding:5px 7px"><input type="password" name="newPw_check" id="newPw_check" style="width:165px;" maxlength="16"></td>
                    </tr>
                    <!--
                    <tr>
                        <td colspan="2" class="popup_imp txtc">비밀번호가 일치하지 않습니다.</td>
                    </tr>
                     <tr>
                        <td colspan="2" class="popup_imp txtc">영문(대소문자구분)/숫자/특수문자 조합 8~12자로 입력하세요.</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="popup_imp txtc">비밀번호가 일치하지 않습니다.</td>
                    </tr>
                     -->
                </tbody>
            </table>
            </form>
            <ul class="popup_slist">
                <li>비밀번호는 영문, 숫자, 특수문자 포함하여, 2가지 이상 조합하여 최소 8자~최대 16자로 만들어주세요.</li>
                <li>아이디와 동일하거나, 3자리 이상 반복되는 문구와 숫자는 불가합니다.</li>
            </ul>
            <div class="popup_btn_area">
                <button type="button" class="btn_popup_ok" id="btn_change_cofirm">변경하기</button>
            </div>
        </div>
    </div>
    <!---// popup 새 비밀번호 입력 --->
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