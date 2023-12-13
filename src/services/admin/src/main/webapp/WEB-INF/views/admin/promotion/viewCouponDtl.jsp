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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 할인쿠폰 &gt; 할인쿠폰 등록</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        
        jQuery(document).ready(function() {
            //수정 : 쿠폰번호,검색시작일,검색종료일,쿠폰종류,검색어,정렬기준,정렬순서,노출개수,페이지번호
            jQuery('#update_btn').on('click', function(e) {
                var couponNo = $("#couponNo").val();
                var searchStartDate = $("#searchStartDate").val();
                var searchEndDate = $("#searchEndDate").val();
                var couponKindCds = $("#couponKindCds").val();
                var searchWordsNoChiper = $("#searchWordsNoChiper").val();
                var sidx = $("#sidx").val();
                var sord = $("#sord").val();
                var rows = $("#rows").val();
                var pageNoOri = $("#pageNoOri").val();
                Dmall.FormUtil.submit('/admin/promotion/coupon-update-form',
                        {couponNo : couponNo, searchStartDate : searchStartDate, searchEndDate : searchEndDate, couponKindCds : couponKindCds, 
                         searchWordsNoChiper : searchWordsNoChiper, sidx:sidx, sord:sord, rows: rows, pageNoOri : pageNoOri});
             });
            
            //목록 : 쿠폰번호,검색시작일,검색종료일,쿠폰종류,검색어,정렬기준,정렬순서,노출개수,페이지번호
            jQuery('#coupon_list').on('click', function(e) {
                var couponNo = $("#couponNo").val();
                var searchStartDate = $("#searchStartDate").val();
                var searchEndDate = $("#searchEndDate").val();
                var couponKindCds = $("#couponKindCds").val();
                var searchWordsNoChiper = $("#searchWordsNoChiper").val();
                var sidx = $("#sidx").val();
                var sord = $("#sord").val();
                var rows = $("#rows").val();
                var pageNoOri = $("#pageNoOri").val();
                Dmall.FormUtil.submit('/admin/promotion/coupon',
                        {couponNo : couponNo, searchStartDate : searchStartDate, searchEndDate : searchEndDate, couponKindCds : couponKindCds, 
                         searchWordsNoChiper : searchWordsNoChiper, sidx:sidx, sord:sord, rows: rows, pageNoOri : pageNoOri});
             });
        });
        </script>       
    </t:putAttribute>
    <t:putAttribute name="content">     
    <div class="sec01_box">
        <div class="tlt_box">
            <div class="btn_box left">
                <button class="btn gray" id="coupon_list">할인쿠폰 리스트</button>
            </div>
            <h2 class="tlth2">할인 쿠폰</h2>
            <div class="btn_box right">
                <a href="#none" class="btn blue shot" id="update_btn">수정하기</a>
            </div>
        </div>
        <!-- line_box -->
        <form id="form_coupon_couponDtl">
        <c:set var="couponDtl" value="${resultModel.data}" />
        <input type="hidden" name="searchStartDate" id="searchStartDate" value="${so.searchStartDate}" />
        <input type="hidden" name="searchEndDate"   id="searchEndDate" value="${so.searchEndDate}" />
        <input type="hidden" name="couponKindCds"   id="couponKindCds" value="${fn:join(so.couponKindCds, ',')}" />
        <input type="hidden" name="searchWordsNoChiper"     id="searchWordsNoChiper" value="${so.searchWordsNoChiper}" />
        <input type="hidden" name="sidx"            id="sidx" value="${so.sidx}" />    
        <input type="hidden" name="sord"            id="sord" value="${so.sord}" />    
        <input type="hidden" name="rows"            id="rows" value="${so.rows}" />    
        <input type="hidden" name="pageNoOri"       id="pageNoOri" value="${so.pageNoOri}" />    
        <input type="hidden" name="couponNo" id="couponNo" value = "${couponDtl.couponNo}" />      
        <div class="line_box fri">
            <h3 class="tlth3">쿠폰 종류 선택</h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table summary="이표는 쿠폰 종류 선택 표 입니다. 구성은 쿠폰종류, 쿠폰수량 입니다.">
                    <caption>쿠폰 종류 선택</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>쿠폰종류</th>
                            <td>
                                    ${couponDtl.couponKindCdNm}
                            </td>
                        </tr>
                        <tr id="option_content_total">
                            <th>상세정보</th>
                            <td>
                                    <c:if test="${couponDtl.couponKindCd eq '01'}"> 발급된 상품 쿠폰을 회원이 상품 상세페이지에서 다운로드합니다.</c:if>
                                    <c:if test="${couponDtl.couponKindCd eq '02'}"> 발급된 상품 쿠폰을 회원이 상품 상세페이지에서 다운로드합니다.(단, 모바일만 사용가능)</c:if>
                                    <c:if test="${couponDtl.couponKindCd eq '03'}"> 생일 맞이 회원이 마이페이지에서 다운로드합니다.</c:if>
                                    <c:if test="${couponDtl.couponKindCd eq '04'}"> 신규회원에게 자동으로 발급됩니다.</c:if>
                                    <c:if test="${couponDtl.couponKindCd eq '05'}"> 특정한 회원에게 관리자 직접 발급합니다.</c:if>
                                    <c:if test="${couponDtl.couponKindCd eq '06'}"> 장바구니에 상품이 등록된 회원에게 발급합니다.</c:if>
                                    <c:if test="${couponDtl.couponKindCd eq '07'}"> 특정 상품 구매 후 발급 됩니다. 발급 시점은 구매 완료, 사용 가능 시점은 구매 확정</c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>쿠폰수량</th>
                            <td>
                                    <c:if test="${couponDtl.couponQttLimitCd eq '01'}"> 전체 수량 제한 없음 </c:if>
                                    <c:if test="${couponDtl.couponQttLimitCd eq '02'}"> 수량 제한 : ${couponDtl.couponQttLimitCnt} 개 </c:if>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
            
            <h3 class="tlth3">쿠폰 상세정보</h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table summary="이표는 쿠폰 상세정보 표 입니다. 구성은 쿠폰명, 쿠폰설명, 단독사용설정, 쿠폰혜택, 유효기간, 사용제한, 쿠폰이미지, 쿠폰사용유무 입니다.">
                    <caption>쿠폰 상세정보</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>쿠폰번호</th>
                            <td> ${couponDtl.couponNo} </td>
                        </tr>
                        <tr>
                            <th>쿠폰명</th>
                            <td> ${couponDtl.couponNm} </td>
                        </tr>
                        <tr>
                            <th>쿠폰설명</th>
                            <td>${couponDtl.couponDscrt}</td>
                        </tr>
                        <tr <c:if test="${couponDtl.couponKindCd eq '97'}">style="display:none;"</c:if>>
                            <th>단독 사용설정</th>
                            <td>
                                <c:if test='${couponDtl.couponSoloUseYn eq "Y"}'> 이 쿠폰은 동일한 주문 건에 다른 쿠폰과 <span class="point_c5">함께 사용할 수 없습니다. </span></c:if>
                                <c:if test='${couponDtl.couponSoloUseYn eq "N"}'> 이 쿠폰은 동일한 주문 건에 다른 쿠폰과 <span class="point_c5">함께 사용할 수 있습니다. </span></c:if>
                            </td>
                        </tr>

                        <tr <c:if test="${couponDtl.couponKindCd eq '97'}">style="display:none;"</c:if>>
                            <th>쿠폰 혜택</th>
                            <td>
                                    <c:if test="${couponDtl.couponBnfCd eq '01'}"> ${couponDtl.couponBnfValue} % 할인, 최대 <fmt:formatNumber value="${couponDtl.couponBnfDcAmt}" pattern="#,###" /> 원</c:if>
                                    <c:if test="${couponDtl.couponBnfCd eq '02'}"> <fmt:formatNumber value="${couponDtl.couponBnfDcAmt}" pattern="#,###" />원 할인</c:if>
                                    <span class="br"></span>
                                    <c:if test='${couponDtl.couponDupltDwldPsbYn eq "Y"}'> 중복 다운로드 가능</c:if>
                                    <c:if test='${couponDtl.couponDupltDwldPsbYn eq "N"}'> 중복 다운로드 불가능</c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>유효기간</th>
                            <td>
                                    <c:if test="${couponDtl.couponApplyPeriodCd eq '01'}">  
                                        ${fn:substring(couponDtl.applyStartDttm, 0, 4)}년 ${fn:substring(couponDtl.applyStartDttm, 4, 6)}월 ${fn:substring(couponDtl.applyStartDttm, 6, 8)}일 
                                        ${fn:substring(couponDtl.applyStartDttm, 8, 10)}시 ${fn:substring(couponDtl.applyStartDttm, 10, 12)}분
                                        ~
                                        ${fn:substring(couponDtl.applyEndDttm, 0, 4)}년 ${fn:substring(couponDtl.applyEndDttm, 4, 6)}월 ${fn:substring(couponDtl.applyEndDttm, 6, 8)}일 
                                        ${fn:substring(couponDtl.applyEndDttm, 8, 10)}시 ${fn:substring(couponDtl.applyEndDttm, 10, 12)}분
                                    </c:if>     
                                    <c:if test="${couponDtl.couponApplyPeriodCd eq '02'}"> 발급일로부터 <fmt:formatNumber value="${couponDtl.couponApplyIssueAfPeriod}" pattern="#,###" /> 일동안 사용가능</c:if>

                                    <c:if test="${couponDtl.couponApplyPeriodCd eq '03'}"> 구매확정일로부터 <fmt:formatNumber value="${couponDtl.couponApplyConfirmAfPeriod}" pattern="#,###" /> 일동안 사용가능</c:if>
                            </td>
                        </tr>  
                        <tr <c:if test="${couponDtl.couponKindCd eq '97'}">style="display:none;"</c:if>>
                            <th>사용제한 금액</th>
                            <td>
                                최소결제 금액이 <fmt:formatNumber value="${couponDtl.couponUseLimitAmt}" pattern="#,###" /> 원 이상이면 사용가능
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <c:choose>
                                    <c:when test="${couponDtl.couponApplyLimitCd eq '01'}">사용제한<br>상품/카테고리</c:when>
                                    <c:when test="${couponDtl.couponApplyLimitCd eq '02'}"> 
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '01'}">사용제한<br>상품
                                         </c:if>
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '02'}">사용제한<br>카테고리
                                         </c:if>
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '03'}">사용제한<br>상품/카테고리
                                         </c:if>
                                    </c:when>
                                    <c:when test="${couponDtl.couponApplyLimitCd eq '03'}">
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '01'}">사용제한<br>상품
                                         </c:if>
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '02'}">사용제한<br>카테고리 
                                         </c:if>
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '03'}">사용제한<br>상품/카테고리
                                         </c:if>
                                    </c:when>
                                </c:choose>
                            </th>        
                            <td>
                                <c:choose>
                                    <c:when test="${couponDtl.couponApplyLimitCd eq '01'}">◆ 전체상품 쿠폰 사용 가능</c:when>
                                    <c:when test="${couponDtl.couponApplyLimitCd eq '02'}"> 
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '01'}">◆ 상품만 쿠폰 사용가능
                                         </c:if>
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '02'}">◆ 카테고리만 쿠폰 사용가능
                                         </c:if>
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '03'}">◆ 상품/카테고리만 쿠폰 사용가능
                                         </c:if>
                                    </c:when>
                                    <c:when test="${couponDtl.couponApplyLimitCd eq '03'}">
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '01'}">◆ 상품만 쿠폰 사용불가
                                         </c:if>
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '02'}">◆ 카테고리만 쿠폰 사용불가
                                         </c:if>
                                         <c:if test="${couponDtl.couponApplyTargetCd eq '03'}">◆ 상품/카테고리만 쿠폰 사용불가
                                         </c:if>
                                    </c:when>
                                </c:choose>    
                                <span class="br2"></span>
                                <!-- tblw -->
                                <div class="tblw tblmany2 mt0">
                                    <table summary="이표는 상품/ 카테고리 표 입니다.">
                                        <caption>상품/ 카테고리</caption>
                                        <colgroup>
                                            <col width="20%">
                                            <col width="80%">
                                        </colgroup>
                                        <tbody>
                                          <tr>
                                          <td>
                                                <c:choose>
                                                    <c:when test="${couponDtl.couponApplyLimitCd eq '01'}">   
                                                       * 전체상품
                                                    </c:when>
                                                    <c:when test="${couponDtl.couponApplyLimitCd eq '02'}"> 
                                                        <c:if test="${couponDtl.couponApplyTargetCd eq '01'}">
                                                             * 적용 상품 
                                                             <ul class="tbl_ul pr_ul1 display_block">
                                                                <c:forEach var="item" items="${couponDtl.couponTargetGoodsList}">
                                                                    <li class='pr_thum'>
                                                                    <img src="${_IMAGE_DOMAIN}${item.imgPath}" width='82' height='82' alt='상품이미지'>
                                                                    <br/><input type="text" value="${item.goodsNm}" readonly/>
                                                                    <input type='hidden' value="${item.goodsNo}">
                                                                    </li>
                                                                </c:forEach>
                                                             </ul>
                                                        </c:if>
                                                        <c:if test="${couponDtl.couponApplyTargetCd eq '02'}">
                                                            * 적용 카테고리
                                                            <ul class="pr_cate_s display_block">
                                                                <c:forEach var="item" items="${couponDtl.couponTargetCtgList}">
                                                                    <li class='pr_thum'>
                                                                          <c:if test ="${item.ctgNm ne null && item.ctgNm != ''}">
                                                                             - ${item.ctgNm}  
                                                                          </c:if>
                                                                    </li>
                                                                </c:forEach>
                                                             </ul>       
                                                        </c:if>
                                                        <c:if test="${couponDtl.couponApplyTargetCd eq '03'}">
                                                             * 적용 상품
                                                             <ul class="tbl_ul pr_ul1 display_block">
                                                                <c:forEach var="item" items="${couponDtl.couponTargetGoodsList}">
                                                                    <li class='pr_thum'>
                                                                    <img src="${item.imgPath}" width='82' height='82' alt='상품이미지'> 
                                                                    <br/><input type="text" value="${item.goodsNm}" readonly/>
                                                                    <input type='hidden' value="${item.goodsNo}">
                                                                    </li>
                                                                </c:forEach>
                                                             </ul>
                                                             <span class="br2"></span>
                                                             * 적용 카테고리
                                                             <ul class="pr_cate_s display_block">
                                                                <c:forEach var="item" items="${couponDtl.couponTargetCtgList}">
                                                                    <li class='pr_thum'>
                                                                          <c:if test ="${item.ctgNm ne null && item.ctgNm != ''}">
                                                                             - ${item.ctgNm}  
                                                                          </c:if>
                                                                    </li>
                                                                </c:forEach>
                                                             </ul>
                                                        </c:if>  
                                                    </c:when>
                                                    <c:when test="${couponDtl.couponApplyLimitCd eq '03'}"> 
                                                        <c:if test="${couponDtl.couponApplyTargetCd eq '01'}">
                                                             * 적용 상품
                                                             <ul class="tbl_ul pr_ul1 display_block">
                                                                <c:forEach var="item" items="${couponDtl.couponTargetGoodsList}">
                                                                    <li class='pr_thum'>
                                                                    <img src="${item.imgPath}" width='82' height='82' alt='상품이미지'> 
                                                                    <br/> <input type="text" value="${item.goodsNm}" readonly/>
                                                                    <input type='hidden' value="${item.goodsNo}">
                                                                    </li>
                                                                </c:forEach>
                                                             </ul>
                                                        </c:if>
                                                        <c:if test="${couponDtl.couponApplyTargetCd eq '02'}">
                                                             * 적용 카테고리
                                                             <ul class="pr_cate_s display_block">
                                                                <c:forEach var="item" items="${couponDtl.couponTargetCtgList}">
                                                                    <li class='pr_thum'>
                                                                          <c:if test ="${item.ctgNm ne null && item.ctgNm != ''}">
                                                                             - ${item.ctgNm}  
                                                                          </c:if>
                                                                    </li>
                                                                </c:forEach>
                                                             </ul>
                                                        </c:if>
                                                        <c:if test="${couponDtl.couponApplyTargetCd eq '03'}">
                                                             * 적용 상품
                                                             <ul class="tbl_ul pr_ul1 display_block">
                                                                <c:forEach var="item" items="${couponDtl.couponTargetGoodsList}">
                                                                    <li class='pr_thum'>
                                                                    <img src="${item.imgPath}" width='82' height='82' alt='상품이미지'> 
                                                                    <br/><input type="text" value="${item.goodsNm}" readonly/>
                                                                    <input type='hidden' value="${item.goodsNo}">
                                                                    </li>
                                                                </c:forEach>
                                                             </ul>
                                                             <span class="br2"></span>
                                                             * 적용 카테고리
                                                             <ul class="pr_cate_s display_block">
                                                                <c:forEach var="item" items="${couponDtl.couponTargetCtgList}">
                                                                    <li class='pr_thum'>
                                                                          <c:if test ="${item.ctgNm ne null && item.ctgNm != ''}">
                                                                             - ${item.ctgNm}  
                                                                          </c:if>
                                                                    </li>
                                                                </c:forEach>
                                                             </ul>
                                                        </c:if>  
                                                    </c:when>
                                                </c:choose>
                                          </td>       
                                          </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!-- //tblw -->
                            </td>
                        </tr>
                        <%-- <tr>
                            <th rowspan="2">쿠폰 이미지</th>
                            <th class="txtc line_t">PC용 이미지</th>
                            <th class="txtc line_t line_n">모바일용 이미지</th>
                        </tr>
                        <tr>
                            <td>
                                <c:if test="${couponDtl.couponWebImgCd eq '01'}"><img src="/admin/img/main/img_remainder01.png"/></c:if>
                                <c:if test="${couponDtl.couponWebImgCd eq '02'}"><img src="/admin/img/main/img_remainder02.png"/></c:if>
                                <c:if test="${couponDtl.couponWebImgCd eq '03'}"><img src="/admin/img/main/img_remainder03.png"/></c:if>
                                <c:if test="${couponDtl.couponWebImgCd eq '04'}"><img src ="${_IMAGE_DOMAIN}/image/image-view?type=COUPON&path=${couponDtl.couponWebImgPath}&id1=${couponDtl.couponWebImg}" width="164" height="82"/></c:if>
                            </td>
                            <td>
                                <c:if test="${couponDtl.couponMobileImgCd eq '01'}"><img src="/admin/img/main/img_remainder01.png"/></c:if>
                                <c:if test="${couponDtl.couponMobileImgCd eq '02'}"><img src="/admin/img/main/img_remainder02.png"/></c:if>
                                <c:if test="${couponDtl.couponMobileImgCd eq '03'}"><img src="/admin/img/main/img_remainder03.png"/></c:if>
                                <c:if test="${couponDtl.couponMobileImgCd eq '04'}"><img src ="${_IMAGE_DOMAIN}/image/image-view?type=COUPON&path=${couponDtl.couponMobileImgPath}&id1=${couponDtl.couponMobileImg}" width="164" height="82"/></c:if>
                            </td>
                        </tr> --%>
                        <tr>
                        	<th>쿠폰 제품유형</th>
                        	<td>${couponDtl.goodsTypeCdNm }</td>
                        </tr>
                        <tr>
                        	<th>쿠폰 연령대</th>
                        	<td>
                        		<c:if test="${couponDtl.ageCd ne null && couponDtl.ageCd ne ''}">
	                        		<c:forEach var="ageCd" items="${fn:split(couponDtl.ageCd,',')}" varStatus="status">
	                        			<c:if test="${status.index > 0 }">, </c:if>
	                        			${ageCd}대
	                        		</c:forEach>
                        		</c:if>
                        	</td>
                        </tr>
                        <tr>
                            <th>쿠폰사용유무</th>
                            <td>
                                    <c:if test='${couponDtl.couponUseYn eq "Y"}'> 사용 </c:if>   
                                    <c:if test='${couponDtl.couponUseYn eq "N"}'> 미사용 </c:if>    
                            </td>
                        </tr>
                        <%--<tr <c:if test="${couponDtl.couponKindCd eq '97'}">style="display:none;"</c:if>>--%>
                        <tr style="display:none;">
							<th>본사 부담율</th>
							<td>${couponDtl.cpLoadrate} %</td>
						</tr>
						<c:if test="${couponDtl.couponKindCd eq '99' || couponDtl.couponKindCd eq '97'}">
						<tr>
                            <th>예약전용쿠폰 여부</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${couponDtl.rsvOnlyYn eq 'Y'}"> 사용 </c:when>
                            		<c:otherwise> 미사용 </c:otherwise>
                            	</c:choose>
                            </td>
                        </tr>
                        </c:if>
                        <tr>
                            <th>쿠폰종류</th>
                            <td>
                            	<c:choose>
                            		<c:when test="${couponDtl.offlineOnlyYn eq 'Y'}"> 오프라인 전용 </c:when>
                            		<c:when test="${couponDtl.offlineOnlyYn eq 'N'}"> 온라인 전용</c:when>
                            		<c:otherwise> 온/오프라인 </c:otherwise>
                            	</c:choose>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
        </div>
        </form>
        <!-- //line_box -->
    </div>
    </t:putAttribute>
</t:insertDefinition>
