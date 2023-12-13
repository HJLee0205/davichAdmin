<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<script>
    $(document).ready(function(){
        /* 배송지 선택 */
        $('.mybtn').click(function(){
            resetAddr();
            var d = $(this).parents().parents('tr').data();

            var tel = (d.tel).split('-');
            var mobile = (d.mobile).split('-');
            if(tel.length == 3) {
                $('#adrsTel01').val(tel[0]);
                $('#adrsTel01').trigger('change');
                $('#adrsTel02').val(tel[1]);
                $('#adrsTel03').val(tel[2]);
            }
            if(mobile.length == 3) {
                $('#adrsMobile01').val(mobile[0]);
                $('#adrsMobile01').trigger('change');
                $('#adrsMobile02').val(mobile[1]);
                $('#adrsMobile03').val(mobile[2]);
            }
            $('#adrsNm').val(d.adrsnm);
            if(d.membergbcd == 10) {
                            $('#shipping_internal').prop("checked",true);
                $('.radio_chack_a').trigger('click');
                $('#postNo').val(d.newpostno);
                $('#numAddr').val(d.strtnbaddr);
                $('#roadnmAddr').val(d.roadaddr);
                $('#dtlAddr').val(d.dtladdr);
            } else if(d.membergbcd == 20){
                $('#shipping_oversea').prop("checked",true);
                $('.radio_chack_b').trigger('click');
                $('#frgAddrCountry').val(d.frgaddrcountry);
                $('#frgAddrCountry').trigger('change');
                $('#frgAddrCity').val(d.frgaddrcity);
                $('#frgAddrState').val(d.frgAddrState);
                $('#frgAddrZipCode').val(d.frgaddrzipcode);
                $('#frgAddrDtl1').val(d.frgaddrdtl1);
                $('#frgAddrDtl2').val(d.frgaddrdtl2);
            }
            Dmall.LayerPopupUtil.close("div_myDelivery");
            jsSetAreaAddDlvr();
        });
    });
</script>

    <!--- popup 나의 배송 주소록 --->
    <div class="popup_my_shipping_address">
        <div class="popup_header">
            <h1 class="popup_tit">나의 배송 주소록</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <div class="popup_address_scroll">
                <table class="tProduct_Board">
                    <caption>
                        <h1 class="blind">나의 배송 주소록 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <!--col style="width:7%"-->
                        <col style="width:15%">
                        <col style="width:15%">
                        <col style="width:20%">
                        <col style="width:">
                        <col style="width:13%">
                    </colgroup>
                    <thead>
                    <tr>
                        <!--th>번호</th-->
                        <th>수령인</th>
                        <th>배송지명</th>
                        <th>연락처/휴대폰</th>
                        <th>주소</th>
                        <th>선택</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                            <c:forEach var="deliveryList" items="${resultListModel.resultList}" varStatus="status">
                                <input type="hidden" name="totalCount" id="totalCount" value="${resultListModel.totalRows}"/>
                                <tr data-mobile="${su.phoneNumber(deliveryList.mobile)}" data-tel="${su.phoneNumber(deliveryList.tel)}" data-membergbcd="${deliveryList.memberGbCd}" data-adrsNm="${deliveryList.adrsNm}"
                                    data-newpostno="${deliveryList.newPostNo}"
                                    data-strtnbaddr="${deliveryList.strtnbAddr}"
                                    data-roadaddr="${deliveryList.roadAddr}"
                                    data-dtladdr="${deliveryList.dtlAddr}"
                                    data-frgaddrcountry="${deliveryList.frgAddrCountry}"
                                    data-frgaddrcity="${deliveryList.frgAddrCity}"
                                    data-frgaddrstate="${deliveryList.frgAddrState}"
                                    data-frgaddrzipcode="${deliveryList.frgAddrZipCode}"
                                    data-frgaddrdtl1="${deliveryList.frgAddrDtl1}"
                                    data-frgaddrdtl2="${deliveryList.frgAddrDtl2}"
                                >
                                    
                                    <td>${deliveryList.adrsNm}</td> <%--수령인--%>
                                    <td>${deliveryList.gbNm}</td><%--배송지명--%>
                                    <td>
                                        <%-- 전화번호는 필수값이 아니고 최소9자리 이상이기 때문에 조건을 건다. --%>
                                        <c:if test="${fn:length(deliveryList.tel) >= 9}">
                                            ${su.phoneNumber(deliveryList.tel)}
                                            </br>
                                        </c:if>
                                            <%-- 핸드폰번호는 필수이기때문에 따로 조건을 걸지않는다. --%>
                                            ${su.phoneNumber(deliveryList.mobile)}
                                    </td><%-- 연락처/휴대폰 --%>
                                    <td>
                                        <ul class="mypage_s_list">

                                            <c:if test="${deliveryList.memberGbCd eq '20'}" >
                                                <li>
                                                        ${deliveryList.frgAddrZipCode}
                                                    <c:if test="${deliveryList.defaultYn eq 'Y'}" >
                                                        <img src="/front/img/mypage/icon_address.gif" alt="기본배송지" style="vertical-align:middle">
                                                    </c:if>
                                                </li>
                                                <li>${deliveryList.frgAddrCountry}</li>
                                                <li>${deliveryList.frgAddrState}&nbsp;${deliveryList.frgAddrCity} </li>
                                                <li>${deliveryList.frgAddrDtl1}&nbsp;${deliveryList.frgAddrDtl2}</li>
                                            </c:if>
                                            <c:if test="${deliveryList.memberGbCd eq '10'}" >
                                                <li>${deliveryList.newPostNo}
                                                    <c:if test="${deliveryList.defaultYn eq 'Y'}" >
                                                        <img src="/front/img/mypage/icon_address.gif" alt="기본배송지" style="vertical-align:middle">
                                                    </c:if>
                                                </li>
                                                <li>${deliveryList.strtnbAddr}</li>
                                                <li>${deliveryList.roadAddr}</li>
                                                <li>${deliveryList.dtlAddr}</li>
                                            </c:if>
                                        </ul>
                                    </td>
                                    <td>
                                        <button type="button" class="mybtn">선택</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6">등록된 주소지가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>

                    </tbody>
                </table>
            </div>
            <p class="popup_bottom">
                - 원하시는 배송지의 선택버튼을 클릭하시면, 주문서에 적용됩니다.<br>
                - 나의 배송 주소록에는 최대 5개의 주소록이 등록됩니다.
            </p>
        </div>
    </div>
    <!---// popup 나의 배송 주소록 --->
</div>