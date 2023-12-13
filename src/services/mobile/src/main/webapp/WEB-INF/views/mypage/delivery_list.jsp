<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
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
    <t:putAttribute name="title">변경해주세요</t:putAttribute>



    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        /*선택한 배송지를 기본 배송지로 셋팅*/
        $('#set_default_btn').on('click', function() {
            var url = '/front/member/default-delivery-setting';
            var setNo = $("input:radio[name='address_select']:checked").val();
            var param = {memberDeliveryNo : setNo,defaultYn:'Y'}
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href= "/front/member/delivery-list";
                 }
            })
        });

        /*배송지 등록*/
        $('#delivery_add_btn').on('click', function() {
            if($('#totalCount').val()> 4){
                alert("자주쓰는 배송지는 최대 5개까지만 등록 가능합니다.");
                return;
            }
            window.open("/front/member/delivery-insert-form", "배송지정보등록","width=640,height=750",false);
        });

        /* 선택삭제 */
        $('#select_delivery_del').on('click', function() {
            var memberDeliveryNo = $("input:radio[name='address_select']:checked").val();
            deleteDelivery(memberDeliveryNo);
        });

        /* 선택수정 */
        $('#select_delivery_update').on('click', function() {
            var memberDeliveryNo = $("input:radio[name='address_select']:checked").val();
            updateDelivery(memberDeliveryNo);
        });
    });

    /*배송지 수정*/
    function updateDelivery(idx){
        window.open("/front/member/delivery-update-form?deNo="+idx, "배송지정보수정","width=640,height=750", false);
    }

    /*배송지 삭제*/
    function deleteDelivery(idx){
        Dmall.LayerUtil.confirm('배송지 정보를 삭제하시겠습니까?', function() {
            var url = '/front/member/delivery-delete';
            var param = {'memberDeliveryNo' : idx};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href= "/front/member/delivery-list";
                 }
            });
        })
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 정보 <span>&gt;</span>자주쓰는 배송지
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
                    자주쓰는 배송지
                    <span class="row_info_text">자주쓰는 배송지 목록입니다. 자주쓰는 배송비는 최대 5개까지 주소등록이 가능합니다.</span>
                </h3>

                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">자주쓰는 배송지 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:50px">
                        <col style="width:110px">
                        <col style="width:">
                        <col style="width:150px">
                        <col style="width:150px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>선택</th>
                            <th>배송지/수령인</th>
                            <th>주소</th>
                            <th>연락처/휴대폰</th>
                            <th>수정/삭제</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_id">
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                        <c:forEach var="deliveryList" items="${resultListModel.resultList}" varStatus="status" end="4">
                        <input type="hidden" name="totalCount" id="totalCount" value="${resultListModel.totalRows}"/>
                        <tr>
                            <td>
                                <input type="radio" id="address_select0${status.count}" value="${deliveryList.memberDeliveryNo}"
                                name="address_select" <c:if test="${deliveryList.defaultYn eq 'Y'}" >checked</c:if>/>
                                <label for="address_select0${status.count}">
                                    <span></span>
                                </label>
                            </td>
                            <td>${deliveryList.gbNm}/${deliveryList.adrsNm}</td>
                            <td class="textL">
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
                            <td>${su.phoneNumber(deliveryList.tel)}</br>${su.phoneNumber(deliveryList.mobile)}</td>
                            <td>
                                <button type="button" class="btn_mypage_s03" onclick="updateDelivery('${deliveryList.memberDeliveryNo}');">수정</button>
                                <button type="button" class="btn_mypage_s03" onclick="deleteDelivery('${deliveryList.memberDeliveryNo}');">삭제</button>
                            </td>
                        </tr>
                        </c:forEach>
                        </c:when>
                        <c:otherwise>
                        <tr>
                            <td colspan="5">등록된 주소지가 없습니다.</td>
                        </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <div class="floatC" style="margin:8px 0">
                    <button type="button" class="btn_mypage_ok" id="select_delivery_del">선택삭제</button>
                    <button type="button" class="btn_mypage_ok" id="select_delivery_update">선택수정</button>
                    <button type="button" class="btn_mypage_line" id ="set_default_btn">선택지를 기본배송지로</button>
                    <button type="button" class="btn_mypage_ok floatR" id="delivery_add_btn">배송지 추가</button>
                </div>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>