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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 기획전 &gt; 기획전 상세</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>    
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>    
        <script type="text/javascript">
        
            jQuery(document).ready(function() {

                
                // 기획전 내용
//                 $("#prmtContentHtml").text($('#prmtContentJstl').data("jstl"));
//                 $("#prmtContentHtml").html($('#prmtContentJstl').data("jstl"));
                $("#prmtContentHtml").html($('#prmtContentJstl').val());
                
                //수정 : 기획전번호,기간검색옵션,검색시작일,검색종료일,기획전진행상태,검색어,페이지번호
                jQuery('#update_btn').on('click', function(e) {
                    var prmtNo = $("#prmtNo").val();
                    var periodSelOption = $("#periodSelOption").val();
                    var searchStartDate = $("#searchStartDate").val();
                    var searchEndDate = $("#searchEndDate").val();
                    var prmtStatusCds = $("#prmtStatusCds").val();
                    var searchWords = $("#searchWords").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#pageNoOri").val();
                    Dmall.FormUtil.submit('/admin/promotion/exhibition-update-form',
                            {prmtNo : prmtNo, periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, prmtStatusCds : prmtStatusCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});
                 });
                
                //목록 : 기간검색옵션,검색시작일,검색종료일,기획전진행상태,검색어,페이지번호
                jQuery('#exhibition_list').on('click', function(e) {
                    var periodSelOption = $("#periodSelOption").val();
                    var searchStartDate = $("#searchStartDate").val();
                    var searchEndDate = $("#searchEndDate").val();
                    var prmtStatusCds = $("#prmtStatusCds").val();
                    var searchWords = $("#searchWords").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#pageNoOri").val();
                    Dmall.FormUtil.submit('/admin/promotion/exhibition',
                            {periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, prmtStatusCds : prmtStatusCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});
                 });                
             });
       </script>   
    </t:putAttribute>
    
    <t:putAttribute name="content">
        <div class="sec01_box" >
            <div class="tlt_box">
                     <div class="btn_box left">
                         <button class="btn gray" id="exhibition_list">기획전 리스트</button>
                     </div>
                     <h2 class="tlth2">기획전 상세</h2>
                     <div class="btn_box right">
                         <button type="button" class="btn blue shot" id="update_btn">수정하기</button>
                     </div> 
            </div>  
             <!-- search_box -->
                <form id="formExhibitionDtl" >
                <c:set var="prmtDtl" value="${resultModel.data}" />
                <input type="hidden" name="periodSelOption" id="periodSelOption" value="${so.periodSelOption}" />
                <input type="hidden" name="searchStartDate" id="searchStartDate" value="${so.searchStartDate}" />
                <input type="hidden" name="searchEndDate"   id="searchEndDate" value="${so.searchEndDate}" />
                <input type="hidden" name="prmtStatusCds" id="prmtStatusCds" value="${fn:join(so.prmtStatusCds, ',')}" />
                <input type="hidden" name="searchWords"     id="searchWords" value="${so.searchWords}" />
                <input type="hidden" name="rows"            id="rows" value="${so.rows}" />
                <input type="hidden" name="pageNoOri"       id="pageNoOri" value="${so.pageNoOri}" />
                <input type="hidden" name="prmtNo" id="prmtNo" value="${prmtDtl.prmtNo}" />
				<div class="line_box fri">
                <h3 class="tlth3">기획전 정보</h3>
                  
                <!-- tblw -->
				<div class="tblw tblmany" id="tableWidth">

					<table summary="이표는 기획전상세표 입니다. 구성은 기획전명, 설명, 기간, 내용, 웹전용 기획전배너, 모바일배너, 기획전 상품설정 입니다.">
						<caption>기획전 상세</caption>
						<colgroup>
							<col width="20%">
							<col width="">
						</colgroup>
							<tbody>
								<tr>
									<th>프로모션 유형</th>
									<td>
										<c:choose>
											<c:when test="${prmtDtl.prmtTypeCd eq '01'}">
												혜택
											</c:when>
											<c:when test="${prmtDtl.prmtTypeCd eq '02'}">
												쿠폰
											</c:when>
											<c:when test="${prmtDtl.prmtTypeCd eq '03'}">
												사은품
											</c:when>
											<c:when test="${prmtDtl.prmtTypeCd eq '04'}">
												세일
											</c:when>
											<c:when test="${prmtDtl.prmtTypeCd eq '05'}">
												사전예약
											</c:when>
											<c:when test="${prmtDtl.prmtTypeCd eq '06'}">
												첫 구매 특가
											</c:when>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th>기획전 명</th>
									<td>
										${prmtDtl.prmtNm}
									</td>
								</tr>
								<tr>
									<th>기획전 설명</th>
									<td>
										${prmtDtl.prmtDscrt}
									</td>
								</tr>
								<tr>
									<th>SEO 검색 단어</th>
									<td>
										${prmtDtl.seoSearchWord}
									</td>
								</tr>
								<tr>
									<th>연령대</th>
									<td>
										<c:if test="${prmtDtl.ageCd ne null && prmtDtl.ageCd ne ''}">
											<c:forEach var="ageCd" items="${fn:split(prmtDtl.ageCd,',')}" varStatus="status">
												<c:if test="${status.index > 0 }">, </c:if>
												${ageCd}대
											</c:forEach>
										</c:if>
									</td>
								</tr>
								<tr>
									<th>기획전 기간</th>
									<td>
										${fn:substring(prmtDtl.applyStartDttm, 0, 4)}년 ${fn:substring(prmtDtl.applyStartDttm, 4, 6)}월 ${fn:substring(prmtDtl.applyStartDttm, 6, 8)}일 
										${fn:substring(prmtDtl.applyStartDttm, 8, 10)}시 ${fn:substring(prmtDtl.applyStartDttm, 10, 12)}분
										~
										${fn:substring(prmtDtl.applyEndDttm, 0, 4)}년 ${fn:substring(prmtDtl.applyEndDttm, 4, 6)}월 ${fn:substring(prmtDtl.applyEndDttm, 6, 8)}일 
										${fn:substring(prmtDtl.applyEndDttm, 8, 10)}시 ${fn:substring(prmtDtl.applyEndDttm, 10, 12)}분
									</td>
								</tr>
								<tr>
									<th colspan="2" class="txtc">기획전 내용</th>
								</tr>
								<tr>
									<td colspan="2">
										<div class="tblh" >
											<div class="disposal_log2" id="prmtContentHtml"></div>
											<input type="hidden" id="prmtContentJstl" value="${prmtDtl.prmtContentHtml}"/>
<%--                                                <span style="display:none" id="prmtContentJstl" data-jstl="${prmtDtl.prmtContentHtml}"> </span> --%>
										</div> 
									</td>
								</tr>
								<tr>
									<th>웹전용 기획전배너</th>
									<td>
										<img src ="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${prmtDtl.prmtWebBannerImgPath}&id1=${prmtDtl.prmtWebBannerImg}" width="164" height="82" alt="웹전용 기획전배너 이미지"/>
									</td>
								</tr>
								<tr>
									<th>모바일전용 기획전배너</th>
									<td>
										<img src ="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${prmtDtl.prmtMobileBannerImgPath}&id1=${prmtDtl.prmtMobileBannerImg}" width="164" height="82" alt="모바일전용 기획전배너 이미지"/>
									</td>
								</tr>
								<tr>
									<th>기획전 상품 설정</th>
									<td>
										<div class="tblw tblmany2 mt0">
											<table summary="이표는 상품표 입니다.">
												<caption>상품</caption>
												<colgroup>
													<col width="10%">
													<col width="90%">
													</colgroup>
												<tbody>
													<tr>
														<c:choose>
															<c:when test="${prmtDtl.prmtGoodsGbCd eq '01' || prmtDtl.prmtGoodsGbCd eq null }">
																<th>상품</th>
																<td>
																	<ul class="tbl_ul pr_ul1 display_block">
																	     <c:forEach var="item" items="${prmtDtl.goodsList}">
																	     	<c:if test="${item.prmtDispzoneNo eq '1'}">
																	          <li class='pr_thum'>
																	          <img src="${_IMAGE_DOMAIN}${item.imgPath}" width='82' height='82' alt='상품이미지' >
																	          <br/> <input type="text" value="${item.goodsNm}" readonly/> 
																	          <input type='hidden' value="${item.goodsNo}">
																	          </li>
																	      </c:if>
																	     </c:forEach>
																	</ul>
																</td>
															</c:when>
															<c:otherwise>
																<th>브랜드</th>
																<td>${prmtDtl.brandNm }</td>
															</c:otherwise>
														</c:choose>
													</tr>
												</tbody>
											</table>
										</div>
									<!-- //tblw -->
									</td>
								</tr>
								<c:forEach var="item" items="${prmtDtl.dispzoneList}" varStatus="status">
									<tr>
										<c:set value="${item.prmtDispzoneNo}" var="idx"/>
										<c:if test="${status.index == 0}"><th rowspan="${fn:length(prmtDtl.dispzoneList)}">전시존</th></c:if>
										<td>
											<div class="tblw tblmany2 mt0">
												<table summary="이표는 상품표 입니다.">
													<caption>상품</caption>
													<colgroup>
														<col width="10%">
														<col width="90%">
													</colgroup>
													<tbody>
														<tr>
															<th>사용여부</th>
															<td>
																<c:if test="${item.useYn eq 'Y' }"> 사용</c:if>
																<c:if test="${item.useYn eq 'N' }"> 미사용</c:if>
															</td>
														</tr>
														<tr>
															<th>전시존명</th>
															<td>
																${item.dispzoneNm }
															</td>
														</tr>
														<tr>
															<th>상품</th>
															<td>
																<ul class="tbl_ul pr_ul1 display_block">
																	<c:forEach var="goods" items="${prmtDtl.goodsList}">
																		<c:if test="${goods.prmtDispzoneNo eq idx}">
																			<li class='pr_thum' >
																			   	<img src="${_IMAGE_DOMAIN}${goods.imgPath}" width='82' height='82' alt='상품이미지' />
																			   	<br/> <input type="text" value="${goods.goodsNm}" readonly>
																			   	<input type='hidden' value="${goods.goodsNo}"> 
																			</li>
																		</c:if>
																	</c:forEach>
																</ul>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
										</td>
									</tr>
								</c:forEach>
								<tr>
									<th>기획전 상품가격<br> 적용조건</th>
									<td>기획전  상품의 ${prmtDtl.prmtDcValue} % 추가 할인</td>
								</tr>
								<tr>
									<th>본사 부담율</th>
									<td>${prmtDtl.prmtLoadrate} %</td>
								</tr>
								<tr>
									<th>메인 노출</th>
									<td>
										<c:choose>
											<c:when test="${prmtDtl.prmtMainExpsUseYn eq 'Y' }">
												<c:if test="${prmtDtl.prmtMainExpsPst eq '01' }">상단 </c:if>
												<c:if test="${prmtDtl.prmtMainExpsPst eq '02' }">하단 </c:if>
												${prmtDtl.prmtMainExpsSeq }번째
											</c:when>
											<c:otherwise>미사용</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>                           
			</form>
		</div>
		<!---// contents--->
		<jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
	</t:putAttribute>
</t:insertDefinition>