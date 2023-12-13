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
	<t:putAttribute name="title">자주쓰는 배송지 수정</t:putAttribute>
	
	<t:putAttribute name="script">
    <script src="${_MOBILE_PATH}/front/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script>
    jQuery(document).ready(function() {
        //일반전화
        var _tel = '${resultModel.data.tel}';
        var temp_tel = Dmall.formatter.tel(_tel).split('-');
        $('#tel01').val(temp_tel[0]);
        $('#tel02').val(temp_tel[1]);
        $('#tel03').val(temp_tel[2]);
        //모바일
        var _mobile = '${resultModel.data.mobile}';
        var temp_mobile = Dmall.formatter.mobile(_mobile).split('-');
        $('#mobile01').val(temp_mobile[0]);
        $('#mobile02').val(temp_mobile[1]);
        $('#mobile03').val(temp_mobile[2]);

        var memberGbCd = '${resultModel.data.memberGbCd}';
        if(memberGbCd == '10')$('.radio_chack_a').click();
        if(memberGbCd == '20')$('.radio_chack_b').click();

        $('.btn_popup_ok').on('click', function() {
            Dmall.validate.set('updateForm');
            if(deliveryInputCheck()){
                var url = '${_MOBILE_PATH}/front/member/delivery-update';
                var param = $('#updateForm').serialize();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         window.close();
                         opener.location.href= "${_MOBILE_PATH}/front/member/delivery-list";
                     }
                })
            }
        });
     // 우편번호
        jQuery('.btn_post').on('click', function(e) {
            Dmall.LayerPopupUtil.zipcode(setZipcode);
        });
    });
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
	<!-- 2018-09-07 배송지 입력폼 새로 추가 -->
<div id="middle_area">
	<div class="product_head">
		<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
		배송지수정
	</div>
	<div class="">
		<div class="order_cancel_info">					
			<span class="icon_purpose mypage">배송을 원하는 주소를 입력해 주세요..</span>
		</div>
		<form action="/front/member/delivery-update" id="updateForm" >
            <input type='hidden' name="memberDeliveryNo" value="${deliveryData.memberDeliveryNo}"/>
            <input type='hidden' name="memberNo" value="${deliveryData.memberNo}"/>
            <input type='hidden' name="tel" id="tel"/>
            <input type='hidden' name="mobile" id="mobile"/>
            <input type='hidden' name="memberGbCd" id="memberGbCd"/>
            <input type='hidden' name="defaultYn" id="defaultYn" />
            <table class="tInsert join">
                <caption>
                    <h1 class="blind">배송지 수정 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:24%">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th>배송지명</th>
                        <td><input type="text" id="gbNm" name="gbNm" value="${deliveryData.gbNm}"></td>
                    </tr>
                    <tr>
                        <th>이름</th>
                        <td><input type="text" id="adrsNm" name="adrsNm" value="${deliveryData.adrsNm}"></td>
                    </tr>
                    <%-- <tr>
                        <th class="order_tit">거주지</th>
                        <td>
                            <input type="radio" id="shipping_internal" name="shipping" value="N">
                            <label for="shipping_internal" class="radio_chack_a" style="margin-right:15px">
                                <span></span>
                                국내
                            </label>
                            <input type="radio" id="shipping_oversea" name="shipping" value="Y">
                            <label for="shipping_oversea" class="radio_chack_b" style="margin-right:15px">
                                <span></span>
                                해외
                            </label>
                        </td>
                    </tr> --%>
                    <tr class="radio_con_a">
                        <th>배송지</th>
                        <td><input type="text" id="newPostNo" name="newPostNo" style="width:70px;" value="${deliveryData.newPostNo}" readonly="readonly"><button type="button" class="btn_post">우편번호</button></td>
                    </tr>
					 <tr>
                        <th>지번주소</th>
                        <td><input type="text" id="strtnbAddr" name="strtnbAddr" value="${deliveryData.strtnbAddr}" readonly="readonly"></td>
					</tr>
					<tr>
                        <th>도로명주소</th>
                        <td><input type="text" id="roadAddr" name="roadAddr" value="${deliveryData.roadAddr}" readonly="readonly"></td>
					</tr>
					<tr>
                        <th>상세주소</th>
                        <td><input type="text" id="dtlAddr" name="dtlAddr" value="${deliveryData.dtlAddr}"></td>
					</tr>
                    <tr>
                        <th>일반전화</th>
                        <td>
                            <select id="tel01" style="width:69px">
                            <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                            </select>
                            -
                            <input type="text" id="tel02" style="width:67px" maxlength="4">
                            -
                            <input type="text" id="tel03" style="width:67px" maxlength="4">
                            <span style="display:inline-block; margin-top:5px">(내선: <input type="text" id="interphone" name="interphone" style="width:67px" maxlength="4" value="${deliveryData.interphone}">  )</span>
                        </td>
                    </tr>
                    <tr>
                        <th>휴대전화</th>
                        <td>
                            <select id="mobile01" style="width:69px">
                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                            </select>
                            -
                            <input type="text" id="mobile02" style="width:67px" maxlength="4">
                            -
                            <input type="text" id="mobile03" style="width:67px" maxlength="4">
                        </td>
                    </tr>
                    <tr>
                        <th>기본배송지</th>
                        <td>
                            <div class="mypage_check">
	                            <input type="checkbox" class="member_check" name="defaultYn_check" id ="defaultYn_check" <c:if test="${deliveryData.defaultYn eq 'Y'}" >checked</c:if>/>
	                            <label for="defaultYn_check"><span></span>기본 배송지로 설정</label>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            </form>
            <div class="btn_area">
                <button type="button" class="btn_popup_ok">저장</button>
            </div>
	</div>
</div><!-- //middle_area -->
<!--// 2018-09-07 배송지 입력폼 새로 추가 -->

    <!--- popup 배송지 추가/수정 ->
    <c:set var="deliveryData" value="${resultModel.data}" />
    <div id="popup_shipping_address_plus">
        <div class="popup_header">
            <h1 class="popup_tit">배송지 수정</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            * 배송을 원하는 주소를 입력해 주세요.
            <form action="/front/member/delivery-update" id="updateForm" >
            <input type='hidden' name="memberDeliveryNo" value="${deliveryData.memberDeliveryNo}"/>
            <input type='hidden' name="memberNo" value="${deliveryData.memberNo}"/>
            <input type='hidden' name="tel" id="tel"/>
            <input type='hidden' name="mobile" id="mobile"/>
            <input type='hidden' name="memberGbCd" id="memberGbCd"/>
            <input type='hidden' name="defaultYn" id="defaultYn" />
            <table class="tProduct_Insert" style="margin-top:5px">
                <caption>
                    <h1 class="blind">배송지 수정 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:24%">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th class="order_tit"><em>*</em>배송지명</th>
                        <td><input type="text" style="width:232px;" id="gbNm" name="gbNm" value="${deliveryData.gbNm}"></td>
                    </tr>
                    <tr>
                        <th class="order_tit"><em>*</em>이름</th>
                        <td><input type="text" style="width:232px;" id="adrsNm" name="adrsNm" value="${deliveryData.adrsNm}"></td>
                    </tr>
                    <%-- <tr>
                        <th class="order_tit">거주지</th>
                        <td>
                            <input type="radio" id="shipping_internal" name="shipping" value="N">
                            <label for="shipping_internal" class="radio_chack_a" style="margin-right:15px">
                                <span></span>
                                국내
                            </label>
                            <input type="radio" id="shipping_oversea" name="shipping" value="Y">
                            <label for="shipping_oversea" class="radio_chack_b" style="margin-right:15px">
                                <span></span>
                                해외
                            </label>
                        </td>
                    </tr> --%>
                    <tr class="radio_con_a">
                        <th class="order_tit" ><em>*</em>배송지</th>
                        <td>
                            <ul class="address_insert">
                                <li>
                                    <input type="text" id="newPostNo" name="newPostNo" style="width:124px;margin-right:5px" value="${deliveryData.newPostNo}" readonly="readonly">
                                    <button type="button" class="btn_post">우편번호</button>
                                </li>
                                <li>
                                    <span class="address_tit" style="width:65px">지번주소</span>
                                    <input type="text" id="strtnbAddr" name="strtnbAddr" style="width:180px;margin-right:5px" value="${deliveryData.strtnbAddr}" readonly="readonly">
                                </li>
                                <li style="margin-bottom:2px">
                                    <span class="address_tit" style="width:65px">도로명주소</span>
                                    <input type="text" id="roadAddr" name="roadAddr" style="width:180px;margin-right:5px" value="${deliveryData.roadAddr}" readonly="readonly">
                                </li>
                                <li style="margin-bottom:2px">
                                    <span class="address_tit" style="width:65px">상세주소</span>
                                    <input type="text" id="dtlAddr" name="dtlAddr" style="width:180px;margin-right:5px" value="${deliveryData.dtlAddr}">
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th class="order_tit">일반전화</th>
                        <td>
                            <select id="tel01" style="width:69px">
                            <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                            </select>
                            -
                            <input type="text" id="tel02" style="width:67px" maxlength="4">
                            -
                            <input type="text" id="tel03" style="width:67px" maxlength="4">
                            (내선: <input type="text" id="interphone" name="interphone" style="width:67px" maxlength="4" value="${deliveryData.interphone}">  )
                        </td>
                    </tr>
                    <tr>
                        <th class="order_tit">휴대전화</th>
                        <td>
                            <select id="mobile01" style="width:69px">
                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                            </select>
                            -
                            <input type="text" id="mobile02" style="width:67px" maxlength="4">
                            -
                            <input type="text" id="mobile03" style="width:67px" maxlength="4">
                        </td>
                    </tr>
                    <tr>
                        <th class="order_tit">기본배송지</th>
                        <td>
                            <div class="mypage_check">
	                            <input type="checkbox" class="member_check" name="defaultYn_check" id ="defaultYn_check" <c:if test="${deliveryData.defaultYn eq 'Y'}" >checked</c:if>/>
	                            <label for="defaultYn_check"><span></span>기본 배송지로 설정</label>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            </form>
            <div class="popup_btn_area">
                <button type="button" class="btn_popup_ok">저장</button>
            </div>
        </div>
    </div>
    <!---// popup 배송지 추가/수정 --->

    </t:putAttribute>
</t:insertDefinition>