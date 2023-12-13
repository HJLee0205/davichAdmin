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
	<t:putAttribute name="title">다비치마켓 :: 주문상세페이지</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${snsMap.get('javascriptKey')}&libraries=services"></script>
    <script type="text/javascript">

        var	lat = 37.560811;
        var lon = 126.982159;

        var map3 = new daum.maps.Map(document.getElementById('map3'), {
            center: new daum.maps.LatLng(lat, lon),
            level: 3
        });
    $(document).ready(function(){

        Dmall.validate.set('form_id_order_info');

        //cash_email selectBox
        var cash_emailSelect = $('#cash_email03');
        var cash_emailTarget = $('#cash_email02');
        cash_emailSelect.bind('change', null, function() {
            var host = this.value;
            if (host != 'etc' && host != '') {
                cash_emailTarget.attr('readonly', true);
                cash_emailTarget.val(host).change();
            } else if (host == 'etc') {
                cash_emailTarget.attr('readonly'
                        , false);
                cash_emailTarget.val('').change();
                cash_emailTarget.focus();
            } else {
                cash_emailTarget.attr('readonly', true);
                cash_emailTarget.val('').change();
            }
        });
        //tax_emailTarget selectBox
        var tax_emailSelect = $('#tax_email03');
        var tax_emailTarget = $('#tax_email02');
        tax_emailSelect.bind('change', null, function() {
            var host = this.value;
            if (host != 'etc' && host != '') {
                tax_emailTarget.attr('readonly', true);
                tax_emailTarget.val(host).change();
            } else if (host == 'etc') {
                tax_emailTarget.attr('readonly'
                        , false);
                tax_emailTarget.val('').change();
                tax_emailTarget.focus();
            } else {
                tax_emailTarget.attr('readonly', true);
                tax_emailTarget.val('').change();
            }
        });

        // 우편번호
        jQuery('#btn_post').on('click', function(e) {
            $('#postNo').val("");
            $('#numAddr').val("");
            $('#roadnmAddr').val("");
            Dmall.LayerPopupUtil.zipcode(setZipcode);
        });
        function setZipcode(data) {
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
            $('#postNo').val(data.zonecode);
            $('#numAddr').val(data.jibunAddress);
            $('#roadnmAddr').val(data.roadAddress);
        }
    });

        //매장상세정보
        function storeDtlPopup(storeNo) {

            if (storeNo == "" || storeNo == null || storeNo == undefined) {
                return false;
            }

            var url = '/front/visit/store-detail-pop?storeCode=' + storeNo;
            Dmall.AjaxUtil.load(url, function(result) {

                $('#div_store_detail_popup').html(result).promise().done(function(){
                    //$('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
                });

                //Dmall.LayerPopupUtil.open($("#div_store_detail_popup"));
                map3 = new daum.maps.Map(document.getElementById('map3'), {
                    center: new daum.maps.LatLng(37.537123, 127.005523),
                    level: 3
                });
            })
        };

        // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
        var searchGeoByAddrByMap3 = function(address){

            // 주소-좌표 변환 객체를 생성합니다
            var geocoder = new daum.maps.services.Geocoder()
                , bounds = new daum.maps.LatLngBounds()
                , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
            ;

            // 주소로 좌표를 검색합니다
            if (address != null) {
                address.forEach(function(item,index,array){
                    //console.log(item.address+" "+item.storeNm+" "+index)
                    geocoder.addressSearch(item.address, function (result, status) {
                        // 정상적으로 검색이 완료됐으면
                        if (status === daum.maps.services.Status.OK) {
                            // positions.push( {"latlng": new daum.maps.LatLng(result[0].y, result[0].x)})

                            var coords = new daum.maps.LatLng(result[0].y, result[0].x);
                            // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
                            // LatLngBounds 객체에 좌표를 추가합니다
                            bounds.extend(coords);

                            // 결과값으로 받은 위치를 마커로 표시합니다
                            var marker = new daum.maps.Marker({
                                map: map3,
                                position: coords
                            });

                            // 인포윈도우로 장소에 대한 설명을 표시합니다
                            var infowindow = new daum.maps.InfoWindow({
                                content: '<div style="width:150px;text-align:center;padding:6px 0;">'+item.storeNm+'</div>',
                                removable : true

                            });
                            // infowindow.open(map, marker);

                            // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
                            // 이벤트 리스너로는 클로저를 만들어 등록합니다
                            // for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
                            daum.maps.event.addListener(marker, 'click', makeClickListener(map3, marker, infowindow, item));
                            //daum.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));

                            // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
                            map3.setBounds(bounds);
                        }
                    });

                });
            }

        };

        // 인포윈도우를 표시하는 클로저를 만드는 함수입니다
        function makeClickListener(map, marker, infowindow, item) {
            return function() {

                var info = '<div class="popup_map_info">' +
                    '<div class="popup_head">' +
                    ' <h1 class="popup_tit">다비치안경 ' + item.storeNm +'</h1>' +
                    ' <div class="btn_close_popup" onclick="closeOverlay()">창닫기</div> '+
                    ' </div> '+
                    ' <div class="popup_body"> '+
                    ' <p class="text_tel">' + item.telNo + '</p>' +
                    ' <p class="text_add">' + item.address + '</p>' +
                    ' </div>' +
                    '</div>' ;

                contentNode.innerHTML = info;
                overlay.setPosition(marker.getPosition());
                overlay.setMap(map);

                $("#storeNo").val(item.storeNo);
                $("#storeNm").val(item.storeNm);
            };
        }

        // 인포윈도우를 닫는 클로저를 만드는 함수입니다
        function makeOutListener(infowindow) {
            return function () {
                infowindow.close();
            };
        }

        // 커스텀 오버레이를 닫기 위해 호출되는 함수입니다
        function closeOverlay() {
            overlay.setMap(null);
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
        
        <form:form id="form_id_order_info" commandName="so">
        <input type="hidden" name="useGbCd" id="useGbCd"/>
        <input type="hidden" name="email" id="email"/>
        <input type="hidden" name="telNo" id="telNo"/>
        <input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>

        <!--- 마이페이지 오른쪽 컨텐츠 --->
		<div id="mypage_content">
            <!--- 마이페이지 탑 --->
            <%@ include file="include/mypage_top_menu.jsp" %>
		
			<div class="mypage_body">
				<h3 class="my_tit">주문 상세정보</h3>
				<h4 class="my_stit">주문상품정보</h4>
				<div class="my_order_info">
					<p class="text">
						<span>주문번호 : <em>${so.ordNo}</em></span>
						<span>주문일시 : <fmt:formatDate value="${order_info.orderInfoVO.ordAcceptDttm}" pattern="yyyy-MM-dd" /></span>
					</p>
					<button type="button" class="btn_order_again" id="btn_rebuy"><i></i>현재 상품 재주문</button>
				</div>
				
				
				<table class="tCart_Board Mypage">
					<caption>
						<h1 class="blind">주문상품 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:102px">
						<col style="width:">
						<col style="width:120px">
						<col style="width:110px">
						<col style="width:110px">
						<col style="width:120px">
                        <col style="width:120px">
					</colgroup>
					<thead>
						<tr>
							<th colspan="2">상품/옵션/수량</th>
							<th>상품금액</th>
							<th>할인금액</th>
                            <th>주문금액</th>
							<th>배송비</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody>
                        <c:set var="sumQty" value="0"/>
                        <c:set var="sumSaleAmt" value="0"/>
                        <c:set var="sumTotalSaleAmt" value="0"/>
                        <c:set var="sumDcAmt" value="0"/>
                        <c:set var="sumMileage" value="0"/>
                        <c:set var="sumDlvrAmt" value="0"/>
                        <c:set var="sumPayAmt" value="0"/>
                        <c:set var="preGrpCd" value=""/>
                        <c:set var="totalRow" value="${order_info.orderGoodsVO.size()}"/>
                        <c:set var="sumAddAptAmt" value="0"/>
                        <c:set var="sumAreaAddDlvrc" value="0"/>

                        <c:forEach var="orderGoodsVo" items="${order_info.orderGoodsVO}" varStatus="status">
                            <%--<c:set var="grpId" value=""/>
                            <c:set var="preGrpId" value=""/>
                            <c:set var="grpId" value="${resultList.orderInfoVO.ordNo}"/>--%>
						<tr>
							<td class="noline">
								<div class="cart_img">
									<img src="${orderGoodsVo.imgPath}">
								</div>
							</td>
							<td class="textL vaT">
								<a href="javascript:goods_detail('${orderGoodsVo.goodsNo}');">
								    ${orderGoodsVo.goodsNm}
                                     <c:if test="${empty orderGoodsVo.itemNm}">
									&nbsp;&nbsp; ${orderGoodsVo.ordQtt} 개
                                     </c:if>
								</a>
                                <c:if test="${orderGoodsVo.freebieNm ne null and orderGoodsVo.freebieNm ne ''}">
                                      <!-- 사은품추가 2018-09-27  사은품이 없을때 전체가 안나오게 해주세요. 사은품상세이름에는 대괄호없애주세요.-->
											<p class="option_s">사은품 : <c:out value="${orderGoodsVo.freebieNm}"/></p>
										<!-- //사은품추가 2018-09-27 -->
                                </c:if>
                                <c:if test="${!empty orderGoodsVo.itemNm}">
                                	<p class="option"><c:out value="${orderGoodsVo.itemNm}"/> ${orderGoodsVo.ordQtt} 개</p>
                                </c:if>
		                        <c:forEach var="optionList" items="${orderGoodsVo.goodsAddOptList}" varStatus="status">
		                            <p class="option_s">
		                                ${optionList.addOptNm} (
		                                <c:choose>
		                                    <c:when test="${optionList.addOptAmtChgCd eq '1'}">
		                                    +
		                                    </c:when>
		                                    <c:otherwise>
		                                    </c:otherwise>
		                                </c:choose>
		                                <fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>) ${optionList.addOptBuyQtt} 개
		                            </p>
			                        <c:set var="sumAddAptAmt" value="${sumAddAptAmt + (optionList.addOptAmt*optionList.addOptBuyQtt)}"/>
		                        </c:forEach>
							</td>
                            <td>
                                <span class="price"><fmt:formatNumber value='${orderGoodsVo.saleAmt*orderGoodsVo.ordQtt+sumAddAptAmt}' type='number'/></span>원
                            </td>
                            <td>
                                <span class="discount">
                                    <c:if test="${orderGoodsVo.dcAmt ne 0}">
                                    -
                                    </c:if>
                                    <fmt:formatNumber value='${orderGoodsVo.dcAmt}' type='number'/>
                                </span>
                            </td>
							<td>
                                <c:if test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
                                    <span class="label_reservation">예약전용</span>
                                </c:if>
                                <c:if test="${orderGoodsVo.rsvOnlyYn ne 'Y'}">
								<span class="price"><fmt:formatNumber value='${(orderGoodsVo.saleAmt*orderGoodsVo.ordQtt+sumAddAptAmt)-orderGoodsVo.dcAmt}' type='number'/></span>원
                                </c:if>
							</td>

                             <%-- **** 배송비 계산 **** --%>
                             <c:choose>
                                <c:when test="${orderGoodsVo.dlvrSetCd eq '1' && orderGoodsVo.dlvrcPaymentCd eq '01'}">
                                    <c:set var="grpId" value="${orderGoodsVo.sellerNo}**${orderGoodsVo.dlvrSetCd}**${orderGoodsVo.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${orderGoodsVo.dlvrSetCd eq '1' && (orderGoodsVo.dlvrcPaymentCd eq '02')}"><%--or orderGoodsVo.dlvrcPaymentCd eq '04'--%>
                                    <c:set var="grpId" value="${orderGoodsVo.sellerNo}**${orderGoodsVo.dlvrSetCd}**${orderGoodsVo.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${orderGoodsVo.dlvrSetCd eq '4' && (orderGoodsVo.dlvrcPaymentCd eq '02')}"><%-- or orderGoodsVo.dlvrcPaymentCd eq '04'--%>
                                    <c:set var="grpId" value="${orderGoodsVo.goodsNo}**${orderGoodsVo.dlvrSetCd}**${orderGoodsVo.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${orderGoodsVo.dlvrSetCd eq '6' && (orderGoodsVo.dlvrcPaymentCd eq '02')}"><%-- or orderGoodsVo.dlvrcPaymentCd eq '04'--%>
                                    <c:set var="grpId" value="${orderGoodsVo.goodsNo}**${orderGoodsVo.dlvrSetCd}**${orderGoodsVo.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="dlvrcPaymentCd" value="${orderGoodsVo.dlvrcPaymentCd}"/>
                                    <c:if test="${orderGoodsVo.dlvrcPaymentCd eq null}">
                                        <c:set var="dlvrcPaymentCd" value="null"/>
                                    </c:if>
                                    <c:set var="grpId" value="${orderGoodsVo.itemNo}**${orderGoodsVo.dlvrSetCd}**${dlvrcPaymentCd}"/>
                                </c:otherwise>
                            </c:choose>
                               <c:if test="${preGrpId ne grpId }">
                                <c:choose>
                                    <c:when test="${dlvrPriceMap.get(grpId) eq '0' || empty dlvrPriceMap.get(grpId)}">
                                        <c:choose>
                                            <c:when test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
                                                <td rowspan="${dlvrCountMap.get(grpId)}"><span class="label_reservation">예약전용</span>
                                                    <p class="option_s">${orderGoodsVo.sellerNm}</p>
                                                </td>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '03'}">
                                                        <td rowspan="${dlvrCountMap.get(grpId)}">
                                                            <p>무료</p>
                                                            <p>착불</p>
                                                            <p class="option_s">${orderGoodsVo.sellerNm}</p>
                                                        </td>
                                                    </c:when>
                                                    <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '04'}">
                                                        <td rowspan="${dlvrCountMap.get(grpId)}">
                                                            <p>무료</p>
                                                            <span class="label_shop">매장픽업</span>
                                                            <p class="option_s">${orderGoodsVo.sellerNm}</p>
                                                        </td>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td rowspan="${dlvrCountMap.get(grpId)}">
                                                            무료
                                                            <p class="option_s">${orderGoodsVo.sellerNm}</p>
                                                        </td>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
                                                <td rowspan="${dlvrCountMap.get(grpId)}"><span class="label_reservation">예약전용</span>
                                                    <p class="option_s">${orderGoodsVo.sellerNm}</p>
                                                </td>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '03'}">

                                                        <td rowspan="${dlvrCountMap.get(grpId)}">
                                                            <p>(<fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)</p>
                                                            <p>착불</p>
                                                            <p class="option_s">${orderGoodsVo.sellerNm}</p>
                                                        </td>
                                                    </c:when>
                                                    <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '04'}">
                                                        <td rowspan="${dlvrCountMap.get(grpId)}">
                                                            <p><fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</p>
                                                            <span class="label_shop">매장픽업</span>
                                                            <p class="option_s">${orderGoodsVo.sellerNm}</p>
                                                        </td>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td rowspan="${dlvrCountMap.get(grpId)}">
                                                            <fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                                            <p class="option_s">${orderGoodsVo.sellerNm}</p>
                                                        </td>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>

                                   <c:if test="${orderGoodsVo.dlvrcPaymentCd ne '03'}" >
                                       <c:set var="sumDlvrAmt" value="${sumDlvrAmt+ dlvrPriceMap.get(grpId)}"/>
                                   </c:if>

                            </c:if>
                            <c:set var="preGrpId" value="${grpId}"/>
                            <td>
								<p>
                                    <c:if test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
                                        <span class="label_reservation">예약전용</span>
                                    </c:if>
                                    <c:if test="${orderGoodsVo.rsvOnlyYn ne 'Y'}">
                                        ${orderGoodsVo.ordDtlStatusNm}
                                    </c:if>
								</p>
                                <c:if test="${orderGoodsVo.rsvOnlyYn ne 'Y'}">
                                <c:if test="${orderGoodsVo.ordDtlStatusCd eq '40' || orderGoodsVo.ordDtlStatusCd eq '50' || orderGoodsVo.ordDtlStatusCd eq '90'}">
			                        <c:forEach var="dlvrList" items="${order_info.deliveryVOList}" varStatus="status">
		                                <c:if test="${orderGoodsVo.ordDtlSeq eq dlvrList.ordDtlSeq}">
											<button type="button" class="btn_shipping" onclick="trackingDelivery('${dlvrList.rlsCourierCd}','${dlvrList.rlsInvoiceNo}')">배송조회</button>
										</c:if>	                        	
			                        </c:forEach>
                                </c:if>
                                </c:if>
							</td>
						</tr>
                            <c:if test="${orderGoodsVo.rsvOnlyYn ne 'Y'}">
                            <c:set var="sumQty" value="${sumQty + orderGoodsVo.ordQtt}"/>
                            <c:set var="sumSaleAmt" value="${sumSaleAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt)}"/>
                            <c:set var="sumTotalSaleAmt" value="${sumTotalSaleAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt)}"/>
                            <c:set var="sumDcAmt" value="${sumDcAmt +orderGoodsVo.dcAmt}"/>
                            <%--<c:set var="sumDlvrAmt" value="${sumDlvrAmt + orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc}"/>--%>
                            <c:set var="sumPayAmt" value="${sumPayAmt + orderGoodsVo.payAmt}"/>
                            <c:set var="sumAreaAddDlvrc" value="${sumAreaAddDlvrc + orderGoodsVo.areaAddDlvrc}"/>
                            </c:if>
                        <%-- 재주문 관련 --%>
                        <c:set var="itemArr" value=""/>
                        <c:set var="optArr" value=""/>
                        <c:if test="${orderGoodsVo.itemNo ne preGrpCd && orderGoodsVo.addOptYn eq 'N'}">
                            <c:set var="itemArr" value="${orderGoodsVo.goodsNo}▦${orderGoodsVo.itemNo}^${orderGoodsVo.ordQtt}^${orderGoodsVo.dlvrcPaymentCd}▦"/>
                            <c:forEach var="optList" items="${order_info.orderGoodsVO }" varStatus="status2">
                                <c:if test="${optList.addOptYn eq 'Y' && optList.itemNo eq orderGoodsVo.itemNo}">
                                    <c:if test="${!empty optArr}">
                                        <c:set var="optArr" value="${optArr}*"/>
                                    </c:if>
                                    <c:set var="optArr" value="${optArr}${optList.addOptNo}^${optList.addOptDtlSeq}^${optList.ordQtt}"/>
                                </c:if>
                            </c:forEach>
                        <input type="hidden" name="itemArr" value="${itemArr}${optArr}▦${orderGoodsVo.ctgNo}">
                        </c:if>
                        <c:set var="preGrpCd" value="${orderGoodsVo.itemNo}"/>
                        </c:forEach>
					</tbody>
				</table>

				<h4 class="my_stit top_margin">
					결제정보
                    <c:if test="${billYn eq 'Y'}">
	                    <c:forEach var="orderPayVO" items="${order_info.orderPayVO}" varStatus="status">
	                        <c:if test="${orderPayVO.paymentWayCd eq '23'}">
	                            <input type="hidden" id="realServiceYn" value="${realServiceYn}" readonly="readonly"/>
	                            <input type="hidden" name="pgCd" id="pgCd" value="${orderPayVO.paymentPgCd}" readonly="readonly"/>
	                            <input type="hidden" id="confirmNo" value="${orderPayVO.confirmNo}" readonly="readonly"/>
	                            <input type="hidden" name="totAmt" id="totAmt" value="<fmt:parseNumber value='${orderPayVO.paymentAmt}' integerOnly='true'/>" readonly="readonly"/>
	                            <input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}" readonly="readonly"/>
								<button type="button" class="btn_go_print" onclick="show_card_bill();"><i></i>신용카드 영수증조회</button>
					        </c:if>
	                        <c:if test="${orderPayVO.paymentWayCd eq '11' || orderPayVO.paymentWayCd eq '21' || orderPayVO.paymentWayCd eq '22'}">
	                            <input type="hidden" name="pgCd" id="pgCd" value="${orderPayVO.paymentPgCd}" readonly="readonly"/>
	                            <input type="hidden" name="totAmt" id="totAmt" value="<fmt:parseNumber value='${orderPayVO.paymentAmt}' integerOnly='true'/>"readonly="readonly"/>
	                            <input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}" readonly="readonly"/>
	                            <c:if test="${!empty cash_bill_info.data.linkTxNo}">
		                            <input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}"/>
									<button type="button" class="btn_go_print" onclick="show_cash_receipt();"><i></i>현금영수증조회</button>
	                            </c:if>
					        </c:if>
    	                </c:forEach>
                    </c:if>
				</h4>
				<div class="pay_info_box">
					<div class="count">
						<span>상품금액</span>
						<em><fmt:formatNumber value='${sumSaleAmt + sumAddAptAmt}' type='number'/></em>원
					</div>
					<i class="minus"></i>
					<div class="count">
						<span>할인금액</span>
						<em><fmt:formatNumber value='${sumDcAmt}' type='number'/></em>원</div>
					<i class="plus"></i>
					<div class="count">
						<span>배송비</span>
						<em><fmt:formatNumber value='${sumDlvrAmt}' type='number'/></em>원
					</div>
					<i class="plus"></i>
					<div class="count">
						<span>추가배송비</span>
						<em><fmt:formatNumber value='${sumAreaAddDlvrc}' type='number'/></em>원
					</div>
					<i class="minus"></i>
					<div class="count">
						<span>마켓포인트사용</span>
						<em>
                            <c:forEach var="pVO" items="${order_info.orderPayVO}" varStatus="status">
                                <c:if test="${pVO.paymentWayCd eq '01'}" >
                                    <c:set var="sumMileage" value="${sumMileage + pVO.paymentAmt}"/>
                                </c:if>
                            </c:forEach>
						    <fmt:formatNumber value='${sumMileage}' type='number'/>
						</em>원
					</div>
					<i class="equal"></i>
					<div class="count total">
						<span>결제금액</span>
						<em><fmt:formatNumber value='${sumPayAmt + sumAddAptAmt-sumMileage}' type='number'/></em>원
					</div>
				</div>
				
                <!-- 입금대기 주문건에 한해서 입금은행정보 노출 -->
                <c:forEach var="orderPayVO_Bank" items="${order_info.orderPayVO}" varStatus="status">
                <c:if test="${orderPayVO_Bank.paymentWayCd eq '11' || orderPayVO_Bank.paymentWayCd eq '22'}">
					<div class="pay_info_bottom">
						<span class="dot">결제정보 : ${orderPayVO_Bank.paymentWayNm}</span>
						<span class="dot">입금계좌 : ${orderPayVO_Bank.bankNm}&nbsp; (${orderPayVO_Bank.actNo})</span>
						<span class="dot">예금주 : ${orderPayVO_Bank.holderNm}</span>
						<c:choose>
							<c:when test="${orderPayVO_Bank.ordStatusCd eq '10'}">
								<fmt:parseDate var="dpstScdDt" value="${orderPayVO_Bank.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
								<span class="dot">입금마감 : <fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd" /></span>
							</c:when>
							<c:when test="${orderPayVO_Bank.ordStatusCd eq '20'}">
								<span class="dot">입금확인일시 : ${orderPayVO_Bank.paymentCmpltDttm}</span>
							</c:when>
						</c:choose>
					</div>
                </c:if>
                </c:forEach>
                <!-- 입금대기 주문건에 한해서 입금은행정보 노출 -->

                <%--<c:if test="${fn:length(ordClaimList)>0}">--%>
                <h4 class="my_stit top_margin">
                    결제취소 / 교환 / 환불 내역
                </h4>
                    <table class="tCart_Board Mypage">
                        <caption>
                            <h1 class="blind">결제취소 / 교환 / 환불 내역 목록입니다.</h1>
                        </caption>
                        <colgroup>
                            <col width="35%">
                            <col width="15%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>상품</th>
                            <th>결제취소 / 교환 / 환불</th>
                            <th>수량</th>
                            <th>금액</th>
                            <th>반품상태</th>
                            <th>환불상태</th>
                            <th>신청일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ordClaimList" items="${order_info.ordClaimList}" varStatus="status">
                            <tr>
                                <td class="txtl"><c:out value="${ordClaimList.goodsNm}"/></td>
                                <td><c:out value="${ordClaimList.claimTypeNm}"/></td>
                                <td><fmt:formatNumber value='${ordClaimList.claimQtt}' type='number'/></td>
                                <td><fmt:formatNumber value='${ordClaimList.saleAmt}' type='number'/></td>
                                <td><c:out value="${ordClaimList.returnNm}"/></td>
                                <td><c:out value="${ordClaimList.claimNm}"/></td>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${ordClaimList.claimAcceptDttm}" /></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${fn:length(order_info.ordClaimList)==0}">
                            <tr>
                                <td colspan="7">취소 / 교환 / 환불 내역이 없습니다.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                <%--</c:if>--%>
				<div class="payment_area mypage">
					<div class="left">
						<h4 class="my_stit">배송지 정보</h4>
						<div class="tCart_outline">
							<table class="tCart_Insert">
								<caption>배송지 정보입니다.</caption>
								<colgroup>
									<col style="width:112px">
									<col style="width:">
								</colgroup>
								<tbody>
									<tr>
										<th>받는사람</th>
										<td>${order_info.orderInfoVO.adrsNm}</td>
									</tr>
									<tr>
										<th>연락처</th>
										<td>${order_info.orderInfoVO.adrsMobile}</td>
									</tr>
									<tr>
										<th>주소</th>
										<td>
										    <c:if test="${order_info.orderInfoVO.postNo ne null}">
										    [${order_info.orderInfoVO.postNo}]
                                            </c:if>
                                            <c:if test="${order_info.orderInfoVO.roadnmAddr ne null}">
                                                ${order_info.orderInfoVO.roadnmAddr}<br>
                                            </c:if>
                                            <c:if test="${order_info.orderInfoVO.storeNo eq null}">
                                                ${order_info.orderInfoVO.dtlAddr}
                                            </c:if>
										    <c:if test="${order_info.orderInfoVO.storeNo ne null}">
                                                <c:if test="${order_info.orderInfoVO.numAddr ne null}">
                                                    ${order_info.orderInfoVO.numAddr}
                                                </c:if>
                                            (${order_info.orderInfoVO.storeNm}) <button type="button" class="btn_map_shop03" onclick="storeDtlPopup('${order_info.orderInfoVO.storeNo}')">지도보기</button>
                                            </c:if>
										</td>
									</tr>
									<tr>
										<th>배송메모</th>
										<td>${order_info.orderInfoVO.dlvrMsg}</td>
									</tr>
								</tbody>
							</table>	
						</div>
					</div>
					<div class="right">
						<h4 class="my_stit">주문고객 정보</h4>
						<div class="tCart_outline">
							<table class="tCart_Insert">
								<caption>주문고객 정보입니다.</caption>
								<colgroup>
									<col style="width:100px">
									<col style="width:">
								</colgroup>
								<tbody>
									<tr>
										<th>주문자명</th>
										<td>${order_info.orderInfoVO.ordrNm}</td>
									</tr>
									<tr>
										<th>이메일</th>
										<td>${order_info.orderInfoVO.ordrEmail}</td>
									</tr>
									<tr>
										<th>휴대전화</th>
										<td>${order_info.orderInfoVO.ordrMobile}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="mypage_btn_area">
                    <c:if test="${billYn eq 'Y'}">
	                    <c:forEach var="orderPayVO" items="${order_info.orderPayVO}" varStatus="status">
	                        <c:if test="${orderPayVO.paymentWayCd eq '11' || orderPayVO.paymentWayCd eq '21' || orderPayVO.paymentWayCd eq '22'}">
	                            <c:if test="${cash_bill_info.data.ordNo ne 'N' && tax_bill_info.data.ordNo ne 'N'}">
		                            <!-- 현금영수증발급신청 -->
		                            <button type="button" class="btn_cash_bill" onclick="cash_receipt_pop();">현금영수증 발급신청</button>
		                            <!-- 세금계산서발급신청 -->
		                            <button type="button" class="btn_cash_bill" onclick="tax_bill_pop();">세금계산서 발급신청</button>
	                            </c:if>	                        
	                    	</c:if>
	                    </c:forEach>
                    </c:if>
					<button type="button" class="btn_go_home02" id="goto_back">이전 화면으로</button>
				</div>
			</div>
			
            <!--- popup 현금영수증 발급신청 --->
            <div class="popup_my_cash" id="popup_my_cash" style="display: none;">
                <div class="popup_header">
                    <h1 class="popup_tit">현금영수증 발급신청</h1>
                    <button type="button" class="btn_close_popup" onclick="cash_receipt_pop();"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
                </div>
                <div class="popup_content">
                    <table class="tMypage_Board" style="margin-top:15px">
                        <caption>
                            <h1 class="blind">현금영수증 발급신청 폼 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:110px">
                            <col style="width:">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="textL">발행용도</th>
                                <td class="textL">
                                    <input type="radio" id="cash_personal" name="my_cash" checked="checked">
                                    <label for="cash_personal" style="margin-right:44px">
                                        <span></span>
                                        개인 소득공제용
                                    </label>
                                    <input type="radio" id="cash_business" name="my_cash">
                                    <label for="cash_business">
                                        <span></span>
                                        사업자지출 증빙용
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">인증번호</th>
                                <td class="form">
                                    <input type="text" id="issueWayNo" name="issueWayNo"><span class="popup_text_info">휴대폰번호 or 사업자번호('-'없이 입력 해주세요)</span>
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">주문자명</th>
                                <td class="form">
                                    <input type="text" id="applicantNm" name="applicantNm" value="${order_info.orderInfoVO.ordrNm}" readonly="readonly">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">이메일</th>
                                <td class="form">
                                    <input type="text" id="cash_email01" style="width:124px;"> @ <input type="text" id="cash_email02" style="width:124px;">
                                    <div class="select_box28" style="display:inline-block">
                                        <label for="cash_email03"></label>
                                        <select class="select_option" id="cash_email03" title="select option">
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
                                <th class="textL">전화번호</th>
                                <td class="form">
                                    <input type="text" id="cashTelNo" name="cashTelNo"><span class="popup_text_info">('-'없이 입력 해주세요)</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="btn_area">
                        <button type="button" class="btn_mypage_ok" onclick="apply_cash_receipt();">발급신청</button>
                        <button type="button" class="btn_mypage_cancel" onclick="close_cash_receipt_pop();">닫기</button>
                    </div>
                </div>
            </div>
            <!---// popup 현금영수증 발급신청 --->
            <!--- popup 세금계산서 발급신청 --->
            <div class="popup_my_cash" id="popup_my_tax" style="display: none;height:inherit">
                <div class="popup_header">
                    <h1 class="popup_tit">세금계산서 발급신청</h1>
                    <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
                </div>
                <div class="popup_content">
                    <table class="tMypage_Board" style="margin-top:15px">
                        <caption>
                            <h1 class="blind">세금계산서 발급신청 폼 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:110px">
                            <col style="width:">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="textL">발행용도</th>
                                <td class="textL">
                                    <input type="radio" id="tax_Yes" name="my_tax" checked="checked">
                                    <label for="tax_yes" style="margin-right:44px">
                                        <span></span>
                                        과세 세금계산서
                                    </label>
                                    <input type="radio" id="tax_no" name="my_tax">
                                    <label for="tax_no">
                                        <span></span>
                                        비과세 세금계산서
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">상호명</th>
                                <td class="form">
                                    <input type="text" id="companyNm" name="companyNm">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">사업자번호</th>
                                <td class="form">
                                    <input type="text" id="bizNo" name="bizNo">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">대표자명</th>
                                <td class="form">
                                    <input type="text" id="ceoNm" name="ceoNm">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">업태/업종</th>
                                <td class="form">
                                    <input type="text" id="bsnsCdts" name="bsnsCdts"> / <input type="text" id="item" name="item">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL" rowspan="4">주소</th>
                                <td class="form">
                                    <input type="text" id="postNo" name="postNo" readonly="readonly"> <button type="button" class="btn_mypage_s03" id="btn_post">우편번호</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="form">
                                    <span class="popup_text_info t_blank">(도로명)</span> <input type="text" id="roadnmAddr" name="roadnmAddr" class="t_input" readonly="readonly">
                                </td>
                            </tr>
                            <tr>
                                <td class="form">
                                    <span class="popup_text_info t_blank">(지번)</span> <input type="text" id="numAddr" name="numAddr" class="t_input" readonly="readonly">
                                </td>
                            </tr>
                            <tr>
                                <td class="form">
                                    <span class="popup_text_info t_blank">(상세주소)</span> <input type="text" id="dtlAddr" name="dtlAddr" class="t_input">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">담당자명</th>
                                <td class="form">
                                    <input type="text" id="managerNm" name="managerNm">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">담당자이메일</th>
                                <td class="form">
                                    <input type="text" id="tax_email01" style="width:124px;"> @ <input type="text" id="tax_email02" style="width:124px;">
                                    <div class="select_box28" style="display:inline-block">
                                        <label for="tax_email03"></label>
                                        <select class="select_option" id="tax_email03" title="select option">
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
                                <th class="textL">전화번호</th>
                                <td class="form">
                                    <input type="text" id="taxTelNo" name="taxTelNo">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="btn_area">
                        <button type="button" class="btn_mypage_ok" onclick="apply_tax_bill();">발급신청</button>
                        <button type="button" class="btn_mypage_cancel" onclick="close_tax_bill_pop();">닫기</button>
                    </div>
                </div>
            </div>
            <!---// popup 세금계산서 발급신청 --->			
			
            </form:form>
		</div>		
		<!--// content -->
	</div>
    <div class="popup" id="div_store_detail_popup" style="display:none;">
        <div class="popup_my_store_detail" id ="popup_my_store_detail">
            <div id="map3" style="width:100%px;height:400px;"></div>
        </div>
    </div>
    <!---// 02.LAYOUT: 마이페이지 --->	
            
    </t:putAttribute>
</t:insertDefinition>