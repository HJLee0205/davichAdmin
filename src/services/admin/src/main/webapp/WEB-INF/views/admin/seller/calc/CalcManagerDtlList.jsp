<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="sellerDefaultLayout">
	<t:putAttribute name="title">정산 상세 내역 > 정산</t:putAttribute>
	<t:putAttribute name="script">
		<script>
			$(document).ready(function() {
				// 검색 버튼 클릭
				$('#btn_id_search').on('click', function(e) {
					Dmall.EventUtil.stopAnchorAction(e);

					$("#search_id_page").val("1");
					$('#form_id_search').attr('action','/admin/seller/calc/calc-manager-dtl-list');
					$('#form_id_search').submit();
				});

				// 엑섹 다운로드 버튼 클릭
				$('#btn_download').on('click', function(e) {
					Dmall.EventUtil.stopAnchorAction(e);

					$('#form_id_search').attr('action','/admin/seller/calc/calc-dtl-download');
					$('#form_id_search').submit();
					$('#form_id_search').attr('action','/admin/seller/calc/calc-manager-dtl-list');
				});

				// 페이징 기능 활성
				$('div.bottom_lay').grid($('#form_id_search'));
			});
		</script>
	</t:putAttribute>
	<t:putAttribute name="content">
		<div class="sec01_box">
			<div class="tlt_box">
				<div class="tlt_head">
					정산 설정<span class="step_bar"></span>
				</div>
				<h2 class="tlth2">정산 상세 내역</h2>
			</div>
			<div class="search_box_wrap">
				<div class="search_box">
					<!-- search_tbl -->
					<form:form id="form_id_search" action="/admin/seller/calc/calc-manager-dtl-list" commandName="sellerSO">
						<form:hidden path="page" id="search_id_page" />
						<form:hidden path="rows" />
						<div class="search_tbl">
							<table summary="">
								<caption>판매자 관리</caption>
								<colgroup>
									<col width="150px">
									<col width="">
								</colgroup>
								<tbody>
								<tr>
									<th>기간</th>
									<td>
										<span class="select">
											<label for="searchDate"></label>
											<select name="searchDate" id="searchDate">
												<tags:option codeStr="01:정산일자;02:정산기준일자;" value="01"/>
											</select>
										</span>
										<tags:calendar from="calcStart" to="calcEnd" idPrefix="srch"/>
									</td>
								</tr>
								<tr>
									<th>주문번호</th>
									<td>
										<span class="intxt w100p">
											<input type="text" name="searchOrdNo" value="">
										</span>
									</td>
								</tr>
								<tr>
									<th>상품명</th>
									<td>
										<span class="intxt w100p">
											<input type="text" name="searchGoodsNm" value="">
										</span>
									</td>
								</tr>
								<tr>
									<th>정산구분</th>
									<td>
										<div class="select wid240">
											<label for="searchGb">전체</label>
											<select name="searchGb" id="searchGb">
												<option value="" selected="">전체</option>
												<option value="01">정산</option>
												<option value="02">정산취소</option>
											</select>
										</div>
									</td>
								</tr>
								</tbody>
							</table>
						</div>
						<div class="btn_box txtc">
							<a href="#none" class="btn--black" id="btn_id_search">검색</a>
						</div>
					</form:form>
				</div>
				<div class="line_box" id="grid_id_sellerList">
					<div class="top_lay">
						<div class="select_btn_left">
							<span class="search_txt">
						  		총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>개의 정산상세내역건이 검색되었습니다.
							</span>
						</div>
						<div class="select_btn_right">
							<button class="btn_exl" id="btn_download">
								<span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
							</button>
						</div>
					</div>
					<!-- tblh -->
					<div class="tblh">
						<div class="scroll">
							<table summary="판매자 리스트" id="table_id_sellerList" style="width:2500px;">
								<caption>판매자 리스트</caption>
								<colgroup>
									<col width="40px">
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
									<col>
								</colgroup>
								<thead>
								<tr>
									<th>번호</th>
									<th>주문상세번호</th>
									<th>주문번호</th>
									<th>상품명</th>
									<th>구매자명</th>
									<th>정산기준일</th>
									<th>정산일자</th>
									<th>결제일자</th>
									<th>결제방법</th>
									<th>PG명</th>
									<th>배송비</th>
									<th>판매가</th>
									<th>쿠폰적용가</th>
									<th>공급가</th>
									<th>입점수수료(%)</th>
									<th>쿠폰할인금액</th>
									<th>수량</th>
									<th>프로모션할인금액</th>
									<th>결제금액</th>
									<th>수수료 수익</th>
									<th>최종지급금액</th>
									<th>택배사</th>
									<th>송장번호</th>
									<th>매장코드</th>
									<th>매장명</th>
									<th>정산구분</th>
								</tr>
								</thead>
								<tbody id="tbody_id_memberList">
								<c:choose>
									<c:when test="${fn:length(resultListModel.resultList) == 0}">
										<tr><td colspan="27">데이터가 존재하지 않습니다.</td></tr>
									</c:when>
									<c:otherwise>
										<c:forEach var="sellerList" items="${resultListModel.resultList}" varStatus="status">
											<tr>
												<td>${sellerList.rowNum}</td>
												<td>${sellerList.ordDtlSeq}</td>
												<td>${sellerList.ordNo}</td>
												<td>${sellerList.goodsNm}</td>
												<td>${sellerList.ordrNm}</td>
												<td>${sellerList.calculateStndrdDt}</td>
												<td>${sellerList.calculateDttm}</td>
												<td>${sellerList.paymentCmpltDttm}</td>
												<td>${sellerList.paymentWayNm}</td>
												<td>${sellerList.paymentPgNm}</td>
												<td><fmt:formatNumber value="${sellerList.dlvrAmt}" pattern="#,###"/></td>
												<td><fmt:formatNumber value="${sellerList.saleAmt}" pattern="#,###"/></td>
												<td><fmt:formatNumber value="${sellerList.cpApplyAmt}" pattern="#,###"/></td>
												<td><fmt:formatNumber value="${sellerList.supplyAmt}" pattern="#,###"/></td>
												<td>${sellerList.sellerCmsRate}</td>
												<td><fmt:formatNumber value="${sellerList.cpDcAmt}" pattern="#,###"/></td>
												<td><fmt:formatNumber value="${sellerList.ordQtt}" pattern="#,###"/></td>
												<td><fmt:formatNumber value="${sellerList.prmtDcAmt}" pattern="#,###"/></td>
												<td><fmt:formatNumber value="${sellerList.paymentAmt}" pattern="#,###"/></td>
												<td><fmt:formatNumber value="${sellerList.commIncomeAmt}" pattern="#,###"/></td>
												<td><fmt:formatNumber value="${sellerList.ltPvdAmt}" pattern="#,###"/></td>
												<td>${sellerList.courierNm}</td>
												<td>${sellerList.invoiceNo}</td>
												<td>${sellerList.storeNo}</td>
												<td>${sellerList.storeNm}</td>
												<td>${sellerList.calculateGb}</td>
											</tr>
										</c:forEach>
									</c:otherwise>
								</c:choose>
								</tbody>
							</table>
						</div>
					</div>
					<!-- //tblh -->
					<!-- bottom_lay -->
					<div class="bottom_lay">
						<grid:paging resultListModel="${resultListModel}" />
					</div>
					<!-- //bottom_lay -->
				</div>
			</div>
		</div>
	</t:putAttribute>
</t:insertDefinition>
