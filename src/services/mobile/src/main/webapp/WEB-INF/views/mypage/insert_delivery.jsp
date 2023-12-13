<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">배송지추가</t:putAttribute>
	
	<t:putAttribute name="header" value="" />
	<t:putAttribute name="footer" value="" />
	<t:putAttribute name="script">
    <script src="/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
    <script>
    jQuery(document).ready(function() {
        //배송지 등록
      $('.btn_popup_ok').on('click', function() {
          Dmall.validate.set('insertForm');
          if(deliveryInputCheck()){
              var url = '/front/member/delivery-insert';
              var param = $('#insertForm').serialize();
              Dmall.AjaxUtil.getJSON(url, param, function(result) {
                  if (result.success) {
                      opener.location.href = "/front/member/delivery-list";
                      window.close();
                  }
              })
          }
      });
      //창닫기
      jQuery('.btn_close_popup').on('click', function(e) {
          window.close();
      });
      //창닫기
      jQuery('.btn_popup_cancel').on('click', function(e) {
          window.close();
      });
      // 우편번호
      jQuery('.btn_post').on('click', function(e) {
          Dmall.LayerPopupUtil.zipcode(setZipcode);
      });
      function setZipcode(data) {
          var fullAddr = data.address; // 최종 주소 변수
          var extraAddr = ''; // 조합형 주소 변수
          // 기본 주소가 도로명 타입일때 조합한다.
          if (data.addressType === 'R') {
              //법정동명이 있을 경우 추가한다.
              if (data.bname !== '') {
                  extraAddr += data.bname;
              }
              // 건물명이 있을 경우 추가한다.
              if (data.buildingName !== '') {
                  extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
              }
              // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
              fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
          }
          // 우편번호와 주소 정보를 해당 필드에 넣는다.
          $('#oldPostNo').val(data.postcode);
          $('#newPostNo').val(data.zonecode);
          $('#strtnbAddr').val(data.jibunAddress);
          $('#roadAddr').val(data.roadAddress);
      }
    });
</script>
</t:putAttribute>
<t:putAttribute name="content">
    <!--- popup 배송지 추가/수정 --->
    <div id="popup_shipping_address_plus">
        <div class="popup_header">
            <h1 class="popup_tit">배송지 추가</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            * 배송을 원하는 주소를 입력해 주세요.
            <form action="/front/member/delivery-insert" id="insertForm" >
            <input type='hidden' name="tel" id="tel" value=""/>
            <input type='hidden' name="mobile" id="mobile" value=""/>
            <input type='hidden' name="defaultYn" id="defaultYn" value=""/>
            <input type='hidden' name="memberGbCd" id="memberGbCd" value=""/>
            <table class="tProduct_Insert" style="margin-top:5px">
                <caption>
                    <h1 class="blind">배송지 추가입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:24%">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th class="order_tit">배송지명</th>
                        <td><input type="text" style="width:232px;" id="gbNm" name="gbNm" ></td>
                    </tr>
                    <tr>
                        <th class="order_tit"><em>*</em>이름</th>
                        <td><input type="text" style="width:232px;" id="adrsNm" name="adrsNm"></td>
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
                        <th class="order_tit" ><em>*</em>배송지</th>
                        <td>
                            <ul class="address_insert">
                                <li>
                                    <input type="text" id="newPostNo" name="newPostNo" style="width:124px;margin-right:5px" readonly="readonly">
                                    <button type="button" class="btn_post">우편번호</button>
                                </li>
                                <li><span class="address_tit" style="width:65px">지번주소</span><input type="text" id="roadAddr" name="roadAddr" style="width:270px;" readonly="readonly"></li>
                                <li><span class="address_tit" style="width:65px;">도로명주소</span><input type="text" id="strtnbAddr" name="strtnbAddr" style="width:270px;" readonly="readonly"></li>
                                <li style="margin-bottom:2px"><span class="address_tit" style="width:65px">상세주소</span><input type="text" id="dtlAddr" name="dtlAddr" style="width:270px"></li>
                            </ul>
                        </td>
                    </tr>
                    <!--//국내 선택시 default-->

                    <!--해외 선택시-->
                    <tr class="radio_con_b" style="display:none;">
                        <th class="order_tit" ><em>*</em>배송지</th>
                        <td>
                            <ul class="address_insert">
                                <li><span class="address_tit" style="width:65px">Country</span>
                                    <div id="shipping_country" class="select_box28" style="width:270px;display:inline-block" >
                                        <label for="frgAddrCountry"></label>
                                        <select id="frgAddrCountry" class="select_option" title="select option">
                                            <code:optionUDV codeGrp="COUNTRY_CD" />
                                        </select>
                                    </div>
                                </li>
                                <li><span class="address_tit" style="width:65px">Zip</span><input type="text" id="frgAddrZipCode" name="frgAddrZipCode" style="width:270px;"></li>
                                <li><span class="address_tit" style="width:65px">State</span><input type="text" id="frgAddrState" name="frgAddrState" style="width:270px;"></li>
                                <li><span class="address_tit" style="width:65px">City</span><input type="text" id="frgAddrCity" name="frgAddrCity" style="width:270px;"></li>
                                <li><span class="address_tit" style="width:65px">address1</span><input type="text" id="frgAddrDtl1" name="frgAddrDtl1" style="width:270px;"></li>
                                <li><span class="address_tit" style="width:65px">address2</span><input type="text" id="frgAddrDtl2" name="frgAddrDtl2" style="width:270px;"></li>
                            </ul>
                        </td>
                    </tr>
                    <!--//해외 선택시-->
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
                            (내선: <input type="text" id="interphone" name="interphone" style="width:67px"  maxlength="4">)
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
                                <label>
                                    <input type="checkbox" name="defaultYn_check" id ="defaultYn_check">
                                    <span></span>
                                    기본 배송지로 설정
                                </label>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            </form>
            <div class="popup_btn_area">
                <button type="button" class="btn_popup_ok">저장</button>
                <button type="button" class="btn_popup_cancel">닫기</button>
            </div>
        </div>
    </div>
    <!---// popup 배송지 추가/수정 --->
    </t:putAttribute>
</t:insertDefinition>