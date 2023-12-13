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
    <t:putAttribute name="title">테스트</t:putAttribute>
    <t:putAttribute name="style">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            jQuery(document).ready(function() {
                jQuery('#frmTest').on('submit', function() {
                    var url = '/admin/example/test-validate-json',
                            param = $('#frmTest').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.LayerUtil.alert('개발자도구의 console을 확인하세요');
                    });
                    return false;
                });
                jQuery('#select_id_source').on('change', function(e) {
                    Dmall.CodeUtil.getCodeList(this.value, setCodeToSelect);

                });
                
                function setCodeToSelect(result) {
                    Dmall.CodeUtil.setCodeToOption(result.resultList, jQuery('#select_id_target'));
                }
                
                jQuery('#btn_id_reset').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    jQuery('#select_id_target').html('');
                });

                // alert 레이어
                jQuery('#a_id_alert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerUtil.alert('경고 메시지', '제목(필수X)', '설명(필수X)');
                });
                
             // alert 레이어
                jQuery('#a_id_alertCallback').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var callback = function() {
                        alert('callback');
                    };
//                    LayerUtil.alertCallback('경고 메시지', callback, '제목(필수X)', '설명(필수X)');
                    Dmall.LayerUtil.alert('경고 메시지').done(function(){alert('callback');});
                });

                // Confirm 레이어
                jQuery('#a_id_confirm').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerUtil.confirm('확인 메시지',
                            function() {
                                alert('YES');
                            },
                            function() {
                                alert('NO');
                            },
                            '제목(필수X)',
                            '설명(필수X)');
                });

                // 우편번호
                jQuery('#a_id_post').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.zipcode(setZipcode);
                });

                jQuery('#form_id_multi a').on('click', function(e) {
                    e.stopPropagation();
                    e.preventDefault();
                    var $this = jQuery('#form_id_multi'),
                            url = $this.attr('action'),
                            param = $this.serialize();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {

                        Dmall.validate.viewExceptionMessage(result, "form_id_multi");
                    });

                    return false;
                });

                //validate.set('form_id_radio');

                jQuery('#a_id_radio').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                })

                jQuery('#cal').dmallCalandar();

                jQuery('#ct21_from_hour').on('change', function(e) {
                    if(this.value === '01') {
                        Dmall.LayerUtil.alert('01시는 선택하면 안됨')
                        Dmall.SelectUtil.reset(this);
                        return false;
                    }
                });
            });

            function setZipcode(data) {
                /*
                {data: {
                        address:"서울 서대문구 충정로 13",
                        addressEnglish: "13, Chungjeong-ro, Seodaemun-gu, Seoul, Korea"
                        addressType:"R"
                        apartment:"N"
                        autoJibunAddress:""
                        autoJibunAddressEnglish:""
                        autoRoadAddress:""
                        autoRoadAddressEnglish:""
                        bcode:"1141010200"
                        bname:"충정로3가"
                        buildingCode:"1141010200100630001030846"
                        buildingName:"삼창빌딩"
                        hname:""
                        jibunAddress:"서울 서대문구 충정로3가 63-1"
                        jibunAddressEnglish:"63-1, Chungjeongno 3(sam)-ga, Seodaemun-gu, Seoul, Korea"
                        postcode:"120-837"
                        postcode1:"120"
                        postcode2:"837"
                        postcodeSeq:"001"
                        query:"삼창빌딩"
                        roadAddress:"서울 서대문구 충정로 13"
                        roadAddressEnglish:"13, Chungjeong-ro, Seodaemun-gu, Seoul, Korea"
                        roadnameCode:"3112011"
                        sido:"서울"
                        sigungu:"서대문구"
                        sigunguCode:"11410"
                        userLanguageType:"K"
                        userSelectedType:"R"
                        zonecode:"03737"
                    }
                }
                 */
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample2_postcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('sample2_address').value = fullAddr;
                document.getElementById('sample2_addressEnglish').value = data.addressEnglish;
            }

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <p>달력<br/>
            <span class="intxt"><input type="text" value="" id="example_sc01" class="bell_date_sc" ></span>
            <a href="#calendar" class="date_sc ico_comm" id="example_date01">달력이미지</a>
            ~
            <span class="intxt"><input type="text" value="" id="example_sc02" class="bell_date_sc" ></span>
            <a href="#calendar" class="date_sc ico_comm" id="example_date02">달력이미지</a>
            <br/>
            <tags:calendar from="f" fromValue="" to="t" toValue="" idPrefix="ct11" /><br/>
            <tags:calendar from="f" fromValue="2016-06-10" to="t" toValue="2016-07-10" idPrefix="ct12" /><br/>
            <tags:calendarTime from="f" to="t" idPrefix="ct21" /><br/>
            <tags:calendarTime from="f" fromValue="201606101234" to="t" toValue="201607100123" idPrefix="ct22" /><br/>

        </p>
        <br/>
        <p>
            스프링 form validation 예제
            <form action="/admin/example/test-validate" id="frmTest">
                <span class="intxt"><input type="TEXT" name="id" value="" placeholder="ID" /></span>
                <span class="intxt"><input type="text" name="name" value="" placeholder="이름" /></span>
                <span class="intxt"><input type="text" name="age" value="19" placeholder="나이" /></span>
                <span class="intxt"><input type="text" name="pwd" value="pwd" /></span>
                <input type="submit" />
            </form>
        </p>
        <br/>
        <p>
            스프링 메시지 처리 <br/>
            <code>
                &lt;spring:message code="NotNull.exampleVo.id" /&gt;<Br/>
            </code>
            <spring:message code="NotNull.exampleVo.id" />
        </p>
        <br/>
        <p>
            페이징 커스텀 태그 예제 <br/>
<%--             <grid:paging currentPage="1" totalPage="113" totalCount="1133" /> --%>
<%--             <grid:paging currentPage="54" totalPage="113" totalCount="1133" /> --%>
<%--             <grid:paging currentPage="113" totalPage="113" totalCount="1133" /> --%>
        </p>
        <br/>
        <p>
            <p>
                공통코드로 라디오 생성 예제 <br/>
                <code:radio name="authGbCd1" codeGrp="FAQ_GB_CD" idPrefix="auth1" />
            </p>
            <br/>
            <p>
                공통코드로 라디오 생성 예제 - 전체 추가 <br/>
                <code:radio name="authGbCd2" codeGrp="AUTH_GB_CD" idPrefix="auth2" includeTotal="true" />
            </p>
            <br/>
            <p>
                공통코드로 라디오 생성 예제 - 전체 추가, 값 선택<br/>
                <code:radio name="authGbCd2" codeGrp="AUTH_GB_CD" idPrefix="auth2" includeTotal="true" value="MANAGER" />
            </p>
            <br/>
            <p>
                코드 문자열로 라디오 생성 예제 - 전체 추가, 값 선택<br/>
                <tags:radio name="authGbCd3" codeStr="1:one;2:two;3:tree" idPrefix="auth2" value="2" /><br/>
            </p>
        <br/>
        <p>
            코드 문자열로 라디오 생성 예제 - 전체 추가, 값 선택<br/>
            <label for="id_radio01" class="radio mr20"><span class="ico_comm"><input type="radio" name="a" id="id_radio01" value="1"></span> 동의</label>
            <label for="id_radio02" class="radio mr20"><span class="ico_comm"><input type="radio" name="a" id="id_radio02" value="2"></span> 미동의</label>
            <label for="id_radio03" class="radio mr20 disa"><span class="ico_comm"><input type="radio" name="a" id="id_radio03" value="3" disabled="disabled"></span> 무효</label>
        </p>
        </p>
        <br/>
        <p>
            <p>
                공통코드로 체크박스 생성 예제 <br/>
                <code:checkbox name="authGbCd1" codeGrp="AUTH_GB_CD" idPrefix="cAuth1" /><br/>
                <code:checkboxUDV name="authGbCd1_1" codeGrp="ORD_STATUS_CD" usrDfn1Val="ON" idPrefix="cAuth1_1" /><br/>
            </p>
            <br/>
            <p>
                공통코드로 체크박스 생성 예제 - 전체 추가 <br/>
                <code:checkbox name="authGbCd2" codeGrp="AUTH_GB_CD" idPrefix="cAuth2" includeTotal="true" /><br/>
            </p>
            <br/>
            <p>
                공통코드로 체크박스 생성 예제 - 전체 추가, 값 선택<br/>
                <code:checkbox name="authGbCd2" codeGrp="AUTH_GB_CD" idPrefix="cAuth3" includeTotal="true" value="MANAGER" /><br/>
            </p>
            <br/>
            <p>
                코드문자열로 체크박스 생성 예제 - 값 선택 전체 선택<br/>
                <tags:checkboxs name="authGbCd3" codeStr="1:one;2:two;3:tree" idPrefix="cAuth3" value="2" />
                <a href="#none" class="all_choice"><span class="ico_comm"></span> 전체</a><br/>
            </p>
        </p>
        <br/>
        <p>
            <p>
                공통코드로 셀렉트 박스 생성 예제 <br/>
                <span class="select">
                    <label for="select1"></label>
                    <select id="select1">
                        <code:option codeGrp="CERTIFY_METHOD_CD" />
                    </select>
                </span>
            </p>
            <br/>
            <p>
                공통코드로 셀렉트 박스 생성 예제 - 전체 추가 <br/>
                <span class="select">
                    <label for="select2"></label>
                    <select id="select2">
                        <code:option codeGrp="CERTIFY_METHOD_CD" includeTotal="true" />
                    </select>
                </span>
            </p>
            <br/>
            <p>
                공통코드로 셀렉트 박스 생성 예제 - 전체 추가, 값 선택<br/>
                <span class="select">
                    <label></label>
                    <select>
                        <code:option codeGrp="CERTIFY_METHOD_CD" includeTotal="true" value="IPIN" />
                    </select>
                </span>
            </p>
            <br/>
            <p>
                공통코드로 셀렉트 박스 생성 예제 - 사용자 정의값에 의한 필터링 <br/>
                <span class="select">
                    <label for="select3"></label>
                    <select id="select3">
                        <code:optionUDV codeGrp="ORD_STATUS_CD" usrDfn1Val="OFF" />
                    </select>
                </span>
            </p>
        </p>
        <code:checkboxUDV name="ordr" codeGrp="ORDR_STATUS_CD" idPrefix="ordr" usrDfn1Val="ON" />
        <br/>
        <p>
            셀렉트 박스 생성예제 - 코드 문자열로 option 생성, ajax로 코드 조회<br/>
            <span class="select">
                <label>선택하세요</label>
                <select id="select_id_source">
                    <option>선택하세요</option>
                    <tags:option codeStr="AUTH_GB_CD:관리자 그룹;CERTIFY_METHOD_CD:인증 방법 코드" value="" />
                </select>
            </span>
            <span class="select">
                <label></label>
                <select id="select_id_target">
                </select>
            </span>
            <span class="button">
            <a href="#" class="btn_blue" id="btn_id_reset">reset</a>
            </span>
        </p>
        <br/>
        <p>
            alert 레이어<br/>
            <a href="#alert" class="btn_blue popup_open" id="a_id_alert">alert</a><br/>
        </p>
        <br/>
        <p>
            alertCallback 레이어<br/>
            <a href="#alertCallback" class="btn_blue popup_open" id="a_id_alertCallback">alert</a><br/>
        </p>
        <br/>
        <p>
            confirm 레이어<br/>
            <a href="#confirm" class="btn_blue popup_open" id="a_id_confirm">confirm</a>
        </p>
        <br/>
        <p>
            우편번호<br/>
            <span class="intxt"><input type="text" id="sample2_postcode" placeholder="우편번호"></span>
            <a href="#post" class="btn_blue popup_open" id="a_id_post">우편번호</a><br/>
            <span class="intxt"><input type="text" id="sample2_address" placeholder="한글주소"></span>
            <span class="intxt"><input type="text" id="sample2_addressEnglish" placeholder="영문주소"></span>
        </p>
        <p>
            <form:form action="/admin/example/test-array-vo" id="form_id_multi">
                <span class="intxt"><input type="text" id="input_id_test_01" name="list[0].id" value="1" /></span>
                <span class="intxt"><input type="text" id="input_id_test_02" name="list[0].name" value="namename1" /></span>
                <span class="intxt"><input type="text" id="input_id_test_03" name="list[0].age" value="11" /></span><br/>
                <span class="intxt"><input type="text" id="input_id_test_04" name="list[1].id" value="ididid2" /></span>
                <span class="intxt"><input type="text" id="input_id_test_05" name="list[1].name" value="namename2" /></span>
                <span class="intxt"><input type="text" id="input_id_test_06" name="list[1].age" value="12" /></span><br/>
                <span class="intxt"><input type="text" id="input_id_test_07" name="list[2].id" value="ididid3" /></span>
                <span class="intxt"><input type="text" id="input_id_test_08" name="list[2].name" value="" /></span>
                <span class="intxt"><input type="text" id="input_id_test_09" name="list[2].age" value="13" /></span><br/>
                <span class="intxt"><input type="text" id="input_id_test_10" name="list[3].id" value="ididid4" /></span>
                <span class="intxt"><input type="text" id="input_id_test_11" name="list[3].name" value="namename4" /></span>
                <span class="intxt"><input type="text" id="input_id_test_12" name="list[3].age" value="14" /></span><br/>
                <a href="#" class="btn_blue">submit</a>
            </form:form>
        </p>
        <br/>
        <p>
            <form:form action="/admin/example/test-array-vo" id="form_id_radio">
                <label for="radio_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="authGbCd2" id="radio_1" value="1" class="validate[required]"></span>1</label>
                <label for="radio_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="authGbCd2" id="radio_2" value="2" class="validate[required]"></span>2</label>
                <label for="radio_3" class="radio mr20"><span class="ico_comm"><input type="radio" name="authGbCd2" id="radio_3" value="3" class="validate[required]"></span>3</label>
            </form:form>
            <a href="#" class="btn_blue" id="a_id_radio">submit</a>
        </p>
        <br/>
        <p>
            <tags:calendarTime from="from" to="to" idPrefix="c" /><br/>
            <tags:calendarTime from="from" to="to" idPrefix="c1" fromValue="201604041234" toValue="201605052359" />
        </p>
    </t:putAttribute>
</t:insertDefinition>