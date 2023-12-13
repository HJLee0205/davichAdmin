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
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 자주쓰는 배송지</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        /*선택한 배송지를 기본 배송지로 셋팅*/
        $('#set_default_btn').on('click', function() {
            var memberDeliveryNo = $("input:radio[name='address_select']:checked").val();
        	if(memberDeliveryNo!='' && memberDeliveryNo!=undefined){
                var url = '/front/member/default-delivery-setting';
                var setNo = $("input:radio[name='address_select']:checked").val();
                var param = {memberDeliveryNo : setNo,defaultYn:'Y'}
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         location.href= "/front/member/delivery-list";
                     }
                });
            }else{
				Dmall.LayerUtil.alert("선택된 배송지 정보가 없습니다.", "알림");
				return false;
            }
        });

        /*배송지 등록*/
        $('#delivery_add_btn').on('click', function() {
            /*if($('#totalCount').val()> 4){
                alert("자주쓰는 배송지는 최대 5개까지만 등록 가능합니다.");
                return;
            }*/
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
    
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->

    <!--- 02.LAYOUT: 마이페이지 --->
	<div class="mypage_middle">	
    
   		<!--- 마이페이지 왼쪽 메뉴 --->
        	<%@ include file="include/mypage_left_menu.jsp" %>
			<!---// 마이페이지 왼쪽 메뉴 --->

			<!--- 마이페이지 오른쪽 컨텐츠 --->
			<div id="mypage_content">
            	<form:form id="form_id_search" commandName="so">
               	<form:hidden path="page" id="page" />
               	<form:hidden path="rows" id="rows" />
            	</form:form>
            	
	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
            
            <div class="mypage_body">
				<h3 class="my_tit">배송지관리</h3>
				
				<div class="order_cancel_info">					
					<span class="icon_purpose">자주 쓰는 배송지를 등록하여 사용하세요. <%--최대 5개까지 저장가능합니다.--%></span>
				</div>

                <table class="tCart_Board">
                    <caption>
						<h1 class="blind">배송지관리 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:38px">
						<col style="width:120px">
						<col style="width:">
						<col style="width:156px">
						<col style="width:100px">
						<col style="width:120px">
					</colgroup>
                    <thead>
						<tr>
							<th colspan="2">배송지명/받는사람</th>
							<th>주소</th>
							<th>연락처</th>
							<th>상태</th>
							<th>관리</th>
						</tr>
					</thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                        <c:forEach var="deliveryList" items="${resultListModel.resultList}" varStatus="status">
                        <input type="hidden" name="totalCount" id="totalCount" value="${resultListModel.totalRows}"/>
                        <tr class="end_line">
                            <td class="noline">
                            	<input type="radio" class="order_radio" id="address_select0${status.count}" name="address_select" value="${deliveryList.memberDeliveryNo}" <c:if test="${deliveryList.defaultYn eq 'Y'}" >checked</c:if>>
								<label for="address_select0${status.count}"><span></span></label>
                            </td>
                            <td>
                            	<p class="ship_name">
                            		<span class="ship1">${deliveryList.gbNm}</span>
									<span class="ship2">${deliveryList.adrsNm}</span>
                            	</p>
                            </td>
                            <td class="textL shipping_address">
                            	<c:if test="${deliveryList.memberGbCd eq '20'}" >
	                            	<p>[${deliveryList.frgAddrZipCode}]</p>
									<p>${deliveryList.frgAddrCountry}</p>
									<p>${deliveryList.frgAddrState}&nbsp;${deliveryList.frgAddrCity}</p>
									<p>${deliveryList.frgAddrDtl1}&nbsp;${deliveryList.frgAddrDtl2}</p>
								</c:if>
								<c:if test="${deliveryList.memberGbCd eq '10'}" >
									<p>[${deliveryList.newPostNo}]</p>
									<p>${deliveryList.strtnbAddr}</p>
									<p>${deliveryList.roadAddr}</p>
									<p>${deliveryList.dtlAddr}</p>
								</c:if>
                            </td>
                            <td>
                            	<%-- 전화번호는 필수값이 아니고 최소9자리 이상이기 때문에 조건을 건다. --%>
                                <c:if test="${fn:length(deliveryList.tel) >= 9}">
                                    ${su.phoneNumber(deliveryList.tel)}
                                    </br>
                                </c:if>
                                <%-- 핸드폰번호는 필수이기때문에 따로 조건을 걸지않는다. --%>
                                ${su.phoneNumber(deliveryList.mobile)}
                            </td>
							<td>
								<c:if test="${deliveryList.defaultYn eq 'Y'}" ><span class="label_add01">기본배송지</span></c:if>
								
							</td>
                            <td>
                                <button type="button" class="btn_ship_modify" onclick="updateDelivery('${deliveryList.memberDeliveryNo}');">수정</button>
                                <button type="button" class="btn_ship_del marginT03" onclick="deleteDelivery('${deliveryList.memberDeliveryNo}');">삭제</button>
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
                <div class="btn_shipping_area">
                    <button type="button" class="btn_shipping_set01" id ="set_default_btn">선택지를 기본배송지로</button>
                    <button type="button" class="btn_shipping_add" id="delivery_add_btn">배송지 추가</button>
                </div>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>