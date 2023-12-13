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
<t:insertDefinition name="popupLayout">
    <t:putAttribute name="title">소셜부가정보 입력</t:putAttribute>
    <t:putAttribute name="header" value="" />
    <t:putAttribute name="footer" value="" />
    <t:putAttribute name="script">
    <script src="/front/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
    <script>
    $(document).ready(function(){
        Dmall.validate.set('form_id_inser_member');
        // 우편번호
        jQuery('.btn_post').on('click', function(e) {
            Dmall.LayerPopupUtil.zipcode(setZipcode);
        });
        // sns부가정보 입력
        $('.btn_popup_ok').on('click',function (){
            if(Dmall.validation.isEmpty($("#mobile02").val())) {
                Dmall.LayerUtil.alert("휴대전화번호를 입력해주세요.", "알림");
                return false;
            }
            if(Dmall.validation.isEmpty($("#mobile03").val())) {
                Dmall.LayerUtil.alert("휴대전화번호를 입력해주세요.", "알림");
                return false;
            }
            if(Dmall.validation.isEmpty($("#newPostNo").val())) {
                Dmall.LayerUtil.alert("우편번호를 입력해주세요.", "알림");
                return false;
            }
            if(Dmall.validation.isEmpty($("#dtlAddr").val())) {
                Dmall.LayerUtil.alert("상세주소를 입력해주세요.", "알림");
                return false;
            }
            /* if(!Dmall.validate.isValid('form_id_sns_add_info')) {
                return false;
            } */
            if(snsInputCheck()){
                var url = '/front/member/sns-memberinfo-update';
                var param = $('#form_id_sns_add_info').serialize();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result.success) {
                        Dmall.LayerUtil.alert("소셜회원 부가정보가 입력되었습니다.", "알림").done(function (){
                            window.close();
                        });
                    }
                })
            }
        })
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <form:form id="form_id_sns_add_info">
    <input type='hidden' name="mobile" id="mobile" value=""/>
    <input type='hidden' name="memberGbCd" id="memberGbCd" value=""/>
    <!--- popup 소셜로그인 부가정보 입력 --->
    <div class="popup_shipping_address_plus" style="height:auto;">
        <div class="popup_header">
            <h1 class="popup_tit">소셜로그인 부가정보 입력</h1>
            <button type="button" class="btn_close_popup" onclick="window.close();"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">


            <table class="tProduct_Insert" style="margin-top:5px">
                <caption>
                    <h1 class="blind">소셜로그인 부가정보 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:24%">
                    <col style="width:">
                </colgroup>
                <tbody>

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
                            <li><span class="address_tit" style="width:65px">도로명주소</span><input type="text" id="roadAddr" name="roadAddr" style="width:270px;" readonly="readonly"></li>
                            <li><span class="address_tit" style="width:65px;">지번주소</span><input type="text" id="strtnbAddr" name="strtnbAddr" style="width:270px;" readonly="readonly"></li>
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
                                <div style="display:inline-block" >
                                    <label for="frgAddrCountry"></label>
                                    <select id="frgAddrCountry" name="frgAddrCountry" style="width:280px">
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
                </tbody>
            </table>
            <span class="product_faq_table_bottom">※ 상단 정보는 배송을 위한 기본정보 입니다.</span>
            <div class="popup_btn_area">
                <button type="button" class="btn_popup_ok">확인</button>
                <button type="button" class="btn_popup_cancel" onclick="window.close();">취소</button>
            </div>
        </div>
    </div>
    </form:form>
    <!---// popup 소셜로그인 부가정보 입력 --->
    </t:putAttribute>
</t:insertDefinition>