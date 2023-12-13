<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
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
    <t:putAttribute name="title">회원정보입력</t:putAttribute>
    <t:putAttribute name="script">
    <script src="/front/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
    <script>
        $(document).ready(function(){
            Dmall.validate.set('form_id_insert_member');
            // 우편번호
            jQuery('.btn_post').on('click', function(e) {
                Dmall.LayerPopupUtil.zipcode(setZipcode);
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

            $('.btn_id_check').on('click',function (){
                $("#id_check").val( $('#loginId').val());
                Dmall.LayerPopupUtil.open($('#popup_id_duplicate_check'));
                if(!Dmall.validation.isEmpty($("#id_check").val())) {
                    $('.btn_id_duplicate_check').click();
                }
            })

            var check_id;
            $('.btn_id_duplicate_check').on('click',function (){
                var url = '/front/member/duplication-id-check';
                var loginId = $('#id_check').val();
                if(Dmall.validation.isEmpty($("#id_check").val())) {
                    $('#id_success_div').attr('style','display:none;')
                    Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
                    return false;
                }else{
                    if(idCheck(loginId)){
                    var param = {loginId : loginId}
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                         if(result.success) {
                             check_id = loginId;
                             $('#id_success_div').attr('style','display:block;')
                             $('.id_duplicate_check_info').html('사용 가능한 아이디 입니다.')
                         }else{
                             $('.id_duplicate_check_info').html('사용불가능한 아이디 입니다.')
                             $('#id_success_div').attr('style','display:none;')
                             $('#loginId').val('');
                         }
                     });
                   }
                }
            })

            //아이디 사용하기
            $('.btn_popup_login').on('click',function (){
                Dmall.LayerPopupUtil.close('popup_id_duplicate_check');
                $('#loginId').val(check_id);
            })

            //회원가입
            $('.btn_join_ok').on('click',function (){
                if(!Dmall.validate.isValid('form_id_insert_member')) {
                    return false;
                }
                if(Dmall.validation.isEmpty($("#memberNm").val())) {
                    Dmall.LayerUtil.alert("이름을 입력해주세요.", "알림");
                    return false;
                }
                if(Dmall.validation.isEmpty($("#loginId").val())) {
                    Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
                    return false;
                }
                if(Dmall.validation.isEmpty($("#pw").val())) {
                    Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "알림");
                    return false;
                }
                if(Dmall.validation.isEmpty($("#pw_check").val())) {
                    Dmall.LayerUtil.alert("비밀번호 확인을 입력해주세요.", "알림");
                    return false;
                }
                if( $('#pw').val() !=  $('#pw_check').val()){
                    Dmall.LayerUtil.alert("비밀번호 입력/확인이 일치하지 않습니다.", "알림");
                    return false;
                }
                if (jQuery('#pw').val().length<8 || jQuery('#pw').val().length>16){
                    Dmall.LayerUtil.alert("비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.", "확인");
                    return false;
                }
                if(/(\w)\1\1/.test($('#pw').val())){
                    Dmall.LayerUtil.alert("비밀번호에 동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.", "확인");
                    return false;
                }
                if ($('#pw').val().indexOf($('#loginId').val()) > -1) {
                    Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "확인");
                    return false;
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
                if($('input:radio[name=gender]').length > 0) {
                    $('#genderGbCd').val($('input:radio[name=gender]:checked').val());
                }
                $('#memberGbCd').val($('input:radio[name=shipping]:checked').val()); //회원 국내/해외 여부
                if(customerInputCheck()){
                    if(passwordCheck(jQuery("#pw").val())){
                        var url = '/front/member/duplication-id-check';
                        var loginId = $('#id_check').val();
                        var param = {loginId : loginId}
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                    var data = $('#form_id_insert_member').serializeArray();
                                    var param = {};
                                    $(data).each(function(index,obj){
                                        param[obj.name] = obj.value;
                                    });
                                    Dmall.FormUtil.submit('/front/member/member-insert', param);
                                }
                        });
                    }
                }
            })

            //취소하기
            $('.btn_join_cancel').on('click',function (){
                location.href = "/front/main-view";
            })
        });

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
    <div class="contents fixwid">
        <div id="member_location">
            <a href="javascript:history.back(-1);">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>회원가입
        </div>
        <c:if test="${so.memberDi != '' && so.memberDi ne null}">
        <ul class="join_steps">
            <li>본인인증</li>
            <li>약관동의</li>
            <li class="thisstep">회원정보입력</li>
            <li>가입완료</li>
        </ul>
        </c:if>
        <c:if test="${so.memberDi == '' || so.memberDi eq null }">
        <ul class="join_steps_01">
            <li>약관동의</li>
            <li class="thisstep">회원정보입력</li>
            <li>가입완료</li>
        </ul>
        </c:if>
        <h3 class="join_stit">
            기본정보
            <span><em>*</em>필수 입력사항입니다.</span>
        </h3>
        <!--- 기본정보 --->
        <form:form id="form_id_insert_member">
        <c:set var="bornYear" value=""/>
        <c:set var="bornMonth" value=""/>
        <c:if test="${!empty so.birth}">
            <c:set var="bornYear" value="${fn:substring(so.birth,0,4)}"/>
            <c:set var="bornMonth" value="${fn:substring(so.birth,4,6)}"/>
        </c:if>
        <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/><!-- 국적구분코드 -->
        <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/><!-- 인증방법코드 -->
        <input type="hidden" name="emailRecvYn" id="emailRecvYn"/><!-- 이메일수신여부 -->
        <input type="hidden" name="smsRecvYn" id="smsRecvYn"/><!-- 모바일수신여부 -->
        <input type="hidden" name="birth" id="birth" value="${so.birth}" />
        <input type="hidden" name="bornYear" id="bornYear" value="${bornYear}" />
        <input type="hidden" name="bornMonth" id="bornMonth" value="${bornMonth}" />
        <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}" />
        <input type="hidden" name="tel" id="tel"/><!-- 전화번호 -->
        <input type="hidden" name="mobile" id="mobile"/><!-- 모바일 -->
        <input type="hidden" name="email" id="email"/><!-- email -->
        <input type="hidden" name="realnmCertifyYn" id="realnmCertifyYn"/><!-- 실명인증여부 -->
        <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/>
        <input type="hidden" name="frgMemberYn" id="frgMemberYn"/><!-- 해외회원여부 -->
        <input type="hidden" name="memberGbCd" id="memberGbCd"/><!-- 해외회원여부 -->
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
                    <th><em>*</em>이름</th>
                    <td>

                        <input type="text" id="memberNm" name="memberNm" style="width:232px;" value="${so.memberNm}" <c:if test="${!empty so.certifyMethodCd}">readonly="readonly"</c:if>>
                    </td>
                </tr>
                <tr>
                    <th><em>*</em>아이디</th>
                    <td>
                        <input type="text" id="loginId" name="loginId" style="width:232px;margin-right:5px" maxlength="20" >
                        <button type="button" class="btn_id_check">중복확인</button>
                        <span class="insert_guide">(영문, 숫자 사용가능하며, 6~20자 가능)</span>
                    </td>
                </tr>
                <tr>
                    <th><em>*</em>비밀번호</th>
                    <td>
                        <input type="password" id="pw" name="pw"style="width:232px;margin-right:0px" onkeyup="passwordInputCheck();" maxlength="16">&nbsp;<span id="passCheck"></span>
                        <br/><span class="insert_guide insert_guide_jjoin">(8~16자리 / 영문, 숫자, 특수문자 중 2가지 조합 필수 / 아이디와 동일하거나 3자리 이상 반복되는 문구와 숫자는 불가)</span>
                    </td>
                </tr>
                <tr>
                    <th><em>*</em>비밀번호 확인</th>
                    <td>
                        <input type="password" id="pw_check" name="pw_check" style="width:232px;" maxlength="16">
                    </td>
                </tr>
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
                                <input type="text" id="newPostNo" name="newPostNo" style="width:124px;margin-right:5px" readonly="readonly">
                                <button type="button" class="btn_post">우편번호</button>
                            </li>
                            <li><span class="address_tit" style="width:65px">지번주소</span><input type="text" id="strtnbAddr" name="strtnbAddr" style="width:571px;" readonly="readonly"></li>
                            <li><span class="address_tit" style="width:65px;">도로명주소</span><input type="text" id="roadAddr" name="roadAddr" style="width:571px;" readonly="readonly"></li>
                            <li style="margin-bottom:2px"><span class="address_tit" style="width:65px">상세주소</span><input type="text" id="dtlAddr" name="dtlAddr" style="width:571px"></li>
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
                                        <code:optionUDV codeGrp="COUNTRY_CD" includeTotal="true" mode="S"/>
                                    </select>
                                </div>
                            </li>
                            <li><span class="address_tit" style="width:65px">Zip</span><input type="text" id="frgAddrZipCode" name="frgAddrZipCode" style="width:571px;"></li>
                            <li><span class="address_tit" style="width:65px">State</span><input type="text" id="frgAddrState" name="frgAddrState" style="width:571px;"></li>
                            <li><span class="address_tit" style="width:65px">City</span><input type="text" id="frgAddrCity" name="frgAddrCity" style="width:571px;"></li>
                            <li><span class="address_tit" style="width:65px">address1</span><input type="text" id="frgAddrDtl1" name="frgAddrDtl1" style="width:571px;"></li>
                            <li><span class="address_tit" style="width:65px">address2</span><input type="text" id="frgAddrDtl2" name="frgAddrDtl2" style="width:571px;"></li>
                        </ul>
                    </td>
                </tr>
                <!--//해외 선택시-->
                <tr>
                    <th><em>*</em>이메일</th>
                    <td>
                        <input type="text" id="email01" style="width:124px;"> @ <input type="text" id="email02" style="width:124px;">
                        <select id="email03" class="select_option" title="select option">
                            <option value="etc" selected="selected">직접입력</option>
                            <option value="naver.com">naver.com</option>
                            <option value="daum.net">daum.net</option>
                            <option value="nate.com">nate.com</option>
                            <option value="hotmail.com">hotmail.com</option>
                            <option value="yahoo.com">yahoo.com</option>
                            <option value="empas.com">empas.com</option>
                            <option value="korea.com">korea.com</option>
                            <option value="dreamwiz.com">dreamwiz.com</option>
                            <option value="gmail.com">gmail.com</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th style="vertical-align:top;"><em>*</em>이메일 수신여부</th>
                    <td class="email_check">
                        <input type="radio" id="email_get" name="email_get" checked="checked">
                        <label for="email_get"  style="margin-right:44px">
                            <span></span>
                            수신함
                        </label>
                        <input type="radio" id="email_no" name="email_get">
                        <label for="email_no">
                            <span></span>
                            수신하지 않음
                        </label>
                        <span class="insert_guide02">- 동의하셔야 쇼핑몰에서 제공하는 이벤트 소식을 이메일로 받으실 수 있습니다.</span>
                    </td>
                </tr>
                <tr>
                    <th>일반전화</th>
                    <td>
                        <select id="tel01" style="width:69px">
                        <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" includeTotal="true" mode="S"/>
                        </select>
                        -
                        <input type="text" id="tel02" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                        -
                        <input type="text" id="tel03" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                    </td>
                </tr>
                <tr>
                    <th><em>*</em>휴대전화</th>
                    <td>
                        <select id="mobile01" style="width:69px">
                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                        </select>
                        -
                        <input type="text" id="mobile02" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                        -
                        <input type="text" id="mobile03" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                    </td>
                </tr>
                <tr>
                    <th style="vertical-align:top"><em>*</em>SMS 수신여부</th>
                    <td class="email_check">
                        <input type="radio" id="sms_get" name="sms_get" checked="checked">
                        <label for="sms_get"  style="margin-right:44px">
                            <span></span>
                            수신함
                        </label>
                        <input type="radio" id="sms_no" name="sms_get">
                        <label for="sms_no"  style="margin-right:44px">
                            <span></span>
                            수신하지 않음
                        </label>
                        <span class="insert_guide02">- 쇼핑몰에서 제공하는 유익한 이벤트 소식을 SMS로 받으실 수 있습니다.</span>
                    </td>
                </tr>
                <c:choose>
                <c:when test="${so.memberDi != '' && so.memberDi ne null}">
                <tr>
                    <th>생년월일</th>
                    <td>
                        ${so.birth.substring(0,4)}년 ${so.birth.substring(4,6)}월 ${so.birth.substring(6,8)}일
                    </td>
                </tr>
                <tr>
                    <th>성별</th>
                    <td>
                        <c:if test="${so.genderGbCd eq 'M'}">남</c:if>
                        <c:if test="${so.genderGbCd eq 'F'}">여</c:if>
                    </td>
                </tr>
                </c:when>
                <c:otherwise>
                <tr>
                    <th><em>*</em>생년월일</th>
                    <td>
                        <div id="birth_year" class="select_box28" style="width:67px;display:inline-block">
                            <label for="select_option">- 선택 -</label>
                            <select class="select_option" id="select_birth_year" title="select option">
                                <option value="" selected>- 선택 -</option>
                                <c:forEach var="birthYear" begin="1950" end="2016">
                                    <fmt:formatNumber var="timePattern" value="${birthYear}" pattern="0000"/>
                                    <option value="${timePattern}">${timePattern}</option>
                                </c:forEach>
                            </select>
                        </div>
                        년
                        <div id="birth_month" class="select_box28" style="width:67px;display:inline-block">
                            <label for="select_option">- 선택 -</label>
                            <select class="select_option" id="select_birth_month" title="select option">
                                <option value="" selected>- 선택 -</option>
                                <c:forEach var="birthMonth" begin="1" end="12">
                                    <fmt:formatNumber var="timePattern" value="${birthMonth}" pattern="00"/>
                                    <option value="${timePattern}">${timePattern}</option>
                                </c:forEach>
                            </select>
                        </div>
                        월
                        <div id="birth_day" class="select_box28" style="width:67px;display:inline-block">
                            <label for="select_option">- 선택 -</label>
                            <select class="select_option" id="select_birth_day" title="select option">
                                <option value="" selected>- 선택 -</option>
                                <c:forEach var="birthDay" begin="01" end="31">
                                    <fmt:formatNumber var="timePattern" value="${birthDay}" pattern="00"/>
                                    <option value="${timePattern}">${timePattern}</option>
                                </c:forEach>
                            </select>
                        </div>
                        일
                    </td>
                </tr>
                <tr>
                    <th>성별</th>
                    <td>
                        <input type="radio" id="male" name="gender" value="M" checked>
                        <label for="male"  style="margin-right:24px">
                            <span></span>
                            남
                        </label>
                        <input type="radio" id="female" name="gender" value="F">
                        <label for="female"  style="margin-right:44px">
                            <span></span>
                            여
                        </label>
                    </td>
                </tr>
                </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        </form:form>
        <div class="btn_area">
            <button type="button" class="btn_join_ok">회원가입</button>
            <button type="button" class="btn_join_cancel">취소하기</button>
        </div>
        <!---// 기본정보 --->
    </div>
    <!--- popup 아이디 중복확인 --->
    <div id="popup_id_duplicate_check" style="width:500px;display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">아이디 중복확인</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <div class="pw_search_info" style="width:100%">
                아이디는 영문, 숫자 가능하며 6~20자 이내로 입력해주세요.
            </div>
            <ul class="id_duplicate_check">
                <li>
                    <input type="text" id="id_check" maxlength="20">
                    <button type="button" class="btn_id_duplicate_check">중복확인</button>
                </li>
            </ul>
            <div>
                 <div class="id_duplicate_check_info" ></div>
                 <div class="textC" id="id_success_div" style="display: none;">
                     <button type="button" class="btn_popup_login" style="margin-top:22px">사용하기</button>
                 </div>
            </div>
        </div>
    </div>
    <!---// popup 아이디 중복확인 --->
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>