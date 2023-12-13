<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2023/01/13
  Time: 4:41 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
  <t:putAttribute name="title">판매자 상품 관리 > 업체</t:putAttribute>
  <t:putAttribute name="script">
    <script>
      $(document).ready(function() {
        // 목록 버튼 클릭
        $('#btn_list').on('click', function() {
          history.back();
        });

        // 승인 버튼 클릭
        $('#btn_approve').on('click', function() {
          Dmall.LayerUtil.confirm('판매승인 하시겠습니까?', function () {
            var url = '/admin/goods/salestart-update';
            var param = {
              'list[0].goodsNo': $('#goodsNo').val(),
              'list[0].aprvYn': 'Y'
            };

            Dmall.AjaxUtil.getJSON(url, param, function (result) {
              Dmall.FormUtil.submit('/admin/seller/seller-goods-list');
            });
          });
        });
      });
    </script>
  </t:putAttribute>
  <t:putAttribute name="content">
    <c:set var="goodsDtl" value="${resultModel.data}"/>
    <div class="sec01_box">
      <input type="hidden" name="goodsNo" id="goodsNo" value="${goodsDtl.goodsNo}">
      <div class="tlt_box">
        <div class="tlt_head">
          업체 설정<span class="step_bar"></span>
        </div>
        <h2 class="tlth2">판매자 상품 관리</h2>
      </div>
      <!-- line_box -->
      <form name="form_seller_goods_info">
        <!-- 기본 정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">기본 정보</h3>
          <!-- tblw -->
          <div class="tblw">
            <table summary="이표는 판매자 상품관리 기본정보 표 입니다. 구성은  상품코드, 상품명, 이벤트안내문, 제조사 ,유형, 판매상태, 아이콘 ,SEO검색용 태그,상품 판매기간 입니다.">
              <caption>
                기본정보
              </caption>
              <colgroup>
                <col width="190px"/>
                <col width="" />
              </colgroup>
              <tbody>
              <tr>
                <th>상품코드</th>
                <td id="td_goods_no">${goodsDtl.goodsNo}</td>
              </tr>
              <tr>
                <th>상품명</th>
                <td>${goodsDtl.goodsNm}</td>
              </tr>
              <tr>
                <th>상품설명</th>
                <td>${goodsDtl.prWords}</td>
              </tr>
              <tr>
                <th>이벤트 안내문</th>
                <td>${goodsDtl.eventWords}</td>
              </tr>
              <tr>
                <th>제조사</th>
                <td>${goodsDtl.mmft}</td>
              </tr>
              <tr>
                <th>유형</th>
                <td>
                  <span class="br"></span>
                  <c:if test="${goodsDtl.normalYn eq 'Y'}">
                    <p>일반</p>
                    <span class="br"></span>
                  </c:if>
                  <c:if test="${goodsDtl.newGoodsYn eq 'Y'}">
                    <p>신상품</p>
                    <span class="br"></span>
                  </c:if>
                  <c:if test="${goodsDtl.mallOrderYn eq 'Y'}">
                    <p>웹발주용</p>
                    <span class="br"></span>
                  </c:if>
                </td>
              </tr>
              <tr>
                <th>판매상태</th>
                <td>
                  <c:choose>
                    <c:when test="${goodsDtl.goodsSaleStatusCd eq '1'}">
                      판매중
                    </c:when>
                    <c:when test="${goodsDtl.goodsSaleStatusCd eq '2'}">
                      품절
                    </c:when>
                    <c:when test="${goodsDtl.goodsSaleStatusCd eq '3'}">
                      판매대기
                    </c:when>
                    <c:when test="${goodsDtl.goodsSaleStatusCd eq '4'}">
                      판매중지
                    </c:when>
                  </c:choose>
                </td>
              </tr>
              <tr>
                <th>아이콘</th>
                <td><img src="${_IMAGE_DOMAIN}${goodsDtl.iconImgs}" alt=""></td>
              </tr>
              <tr>
                <th>SEO 검색용 태그</th>
                <td>${goodsDtl.seoSearchWord}</td>
              </tr>
              <tr>
                <th>상품 판매 기간</th>
                <td>
                  <c:choose>
                    <c:when test="${goodsDtl.saleForeverYn eq 'Y'}">
                      무제한
                    </c:when>
                    <c:otherwise>
                      ${fn:substring(goodsDtl.saleStartDt, 0, 10)} ~ ${fn:substring(goodsDtl.saleEndDt, 0, 10)}
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
              </tbody>
            </table>
          </div>
          <!-- //tblw -->
        </div>
        <!-- 카테고리정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">카테고리 정보</h3>
          <div class="tblw">
            <table summary="이표는 선택된 카테고리 리스트 표 입니다. 구성은 선택된 카테값을 노출합니다.">
              <caption>선택된 카테고리 리스트</caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <tr>
                <th>선택된 카테고리</th>
                <td>
                  <span class="br"></span>
                  <c:forEach var="ctg" items="${goodsDtl.goodsCtgList}">
                    <p>${ctg.ctgDisplayNm}</p>
                    <span class="br"></span>
                  </c:forEach>
                </td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>
        <!-- 필터정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">필터 정보</h3>
          <!-- tblw -->
          <div class="tblw ">
            <table summary="이표는 상품관리 필터 정보 표입니다, 구성은  브랜드, 사이즈 ,모양,  구조, 소재 ,컬러 항목입니다.">
              <caption>
                필터 정보
              </caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <c:if test="${!empty resultFilter}">
                <c:forEach var="filter1" items="${resultFilter}" varStatus="status">
                  <c:if test="${filter1.filterLvl eq '2' && filter1.goodsTypeCd eq typeCd}">
                    <c:set var="filter_no" value="${filter1.id}"/>
                    <c:set var="up_filter_no" value="${filter1.parent}"/>
                    <c:set var="filter_nm" value="${filter1.text}"/>
                    <tr>
                      <th>${filter_nm}</th>
                      <td>
                        <c:forEach var="filter2" items="${resultFilter}" varStatus="status2">
                          <c:set var="filter_child_id" value="${filter2.id}"/>
                          <c:set var="filter_child_nm" value="${filter2.text}"/>

                          <c:if test="${filter_no eq filter2.parent && filter2.filterLvl eq '3'}">
                            <c:forEach var="goodsFilter" items="${goodsDtl.goodsFilterList}" varStatus="status3">
                              <c:if test="${filter_child_id eq goodsFilter.filterNo}">
                                <span class="mr20">${filter_child_nm}</span>
                              </c:if>
                            </c:forEach>
                          </c:if>
                          <c:if test="${status2.last}">
                      </td>
                    </tr>
                          </c:if>
                        </c:forEach>
                  </c:if>
                </c:forEach>
              </c:if>
              </tbody>
            </table>
          </div>
          <!-- //tblw -->
        </div>
        <!-- 브랜드정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">브랜드 정보</h3>
          <div class="tblw ">
            <table summary="이표는 상품관리 브랜드 정보 표 입니다. 구성은 브랜드입니다.">
              <caption>내 얼굴 정보 </caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <tr>
                <th>브랜드</th>
                <td>
                  ${goodsDtl.brandNm}
                </td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>
        <!-- 내 코드 정보 -->
<%--        <div class="line_box fri marginB40">--%>
<%--          <h3 class="tlth3 btn1">내 코드 정보</h3>--%>
<%--          <!-- tblw -->--%>
<%--          <div class="tblw ">--%>
<%--            <table summary="이표는 상품관리 내얼굴 정보 표 입니다. 구성은 모양 컬러 사이즈 입니다.">--%>
<%--              <caption>내 코드 정보</caption>--%>
<%--              <colgroup>--%>
<%--                <col width="190px">--%>
<%--                <col width="">--%>
<%--              </colgroup>--%>
<%--              <tbody>--%>
<%--              <tr>--%>
<%--                <th>안경 추천 사이즈</th>--%>
<%--                <td></td>--%>
<%--              </tr>--%>
<%--              <tr>--%>
<%--                <th>얼굴형</th>--%>
<%--                <td></td>--%>
<%--              </tr>--%>
<%--              <tr>--%>
<%--                <th>피부톤</th>--%>
<%--                <td></td>--%>
<%--              </tr>--%>
<%--              <tr>--%>
<%--                <th>스타일</th>--%>
<%--                <td></td>--%>
<%--              </tr>--%>
<%--              </tbody>--%>
<%--            </table>--%>
<%--          </div>--%>
<%--          <!-- //tblw -->--%>
<%--        </div>--%>
        <!-- 상품 상세정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">상품 상세 정보</h3>
          <!-- tblw -->
          <div class="tblw">
            <table summary="이표는 상품관리 상품 상세정보 표 입니다. 구성은 대표이미지 상세내용 입니다.">
              <caption>상품 상세 정보</caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <tr>
                <th>대표이미지</th>
                <td>
                  <c:forEach var="imgSet" items="${goodsDtl.goodsImageSetList}" varStatus="status">
                    <span class="seller_imgbox mr20">
                      <img src="${_IMAGE_DOMAIN}${imgSet.goodsImageDtlList[0].imgUrl}" alt="상품이미지" width="200" height="250">
                    </span>
                  </c:forEach>
                </td>
              </tr>
              <tr>
                <th>상세내용</th>
                <td id="goods-contents">
                  ${goodsContentsModel.data.content}
                </td>
              </tr>
              </tbody>
            </table>
          </div>
          <!-- //tblw -->
        </div>
        <!-- 상품 사이즈 정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">상품 사이즈 정보 <span class="ui-icon-help"></span></h3>
          <!-- tblw -->
          <div class="tblw">
            <table summary="이표는 상품관리 상품 상세정보 표 입니다.">
              <caption>상품 사이즈 정보</caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <tr>
                <th>프레임 전면부</th>
                <td>${goodsDtl.fullSize}</td>
              </tr>
              <tr>
                <th>브릿지 길이</th>
                <td>${goodsDtl.bridgeSize}</td>
              </tr>
              <tr>
                <th>가로 길이</th>
                <td>${goodsDtl.horizontalLensSize}</td>
              </tr>
              <tr>
                <th>세로 길이</th>
                <td>${goodsDtl.verticalLensSize}</td>
              </tr>
              <tr>
                <th>다리 길이</th>
                <td>${goodsDtl.templeSize}</td>
              </tr>
              </tbody>
            </table>
          </div>
          <!-- //tblw -->
        </div>
        <!-- 컬러 그룹 정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">컬러 그룹 정보 </h3>
          <!-- tblh -->
          <div class="tblh">
            <table style="table-layout:fixed;" summary="이표는 컬러 그룹 정보표 입니다.구성은 ,번호,이미지, 상품명, 상품 코드, 브랜드 입니다">
              <caption>컬러 그룹 상품 목록표</caption>
              <colgroup>
                <col width="8%">
                <col width="110PX">
                <col width="40%">
                <col width="30%">
                <col width="20%">
              </colgroup>
              <thead>
              <tr>
                <th>번호</th>
                <th>이미지</th>
                <th>상품명</th>
                <th>상품코드</th>
                <th>브랜드</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="relationGoods" items="${goodsDtl.relateGoodsList}" varStatus="status">
                <tr>
                  <td>${status.count}</td>
                  <td>
                    <img src="${_IMAGE_DOMAIN}${relationGoods.goodsImg02}" alt="">
                  </td>
                  <td class="txtl">${relationGoods.goodsNm}</td>
                  <td>${relationGoods.goodsNo}</td>
                  <td>${relationGoods.brandNm}</td>
                </tr>
              </c:forEach>
              <c:if test="${goodsDtl.relateGoodsList.size() == 0}">
                <tr><td colspan="5">데이터가 없습니다.</td></tr>
              </c:if>
              </tbody>
            </table>
          </div>
          <!-- //tblh -->
        </div>
        <!--옵션 정보  -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">옵션 정보</h3>
          <div class="tblw tblmany">
            <table summary="이표는 상품관리 옵션정보표 입니다.">
              <caption>옵션 정보</caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <tr>
                <th>옵션 설정</th>
                <td id="optionset">
                  <c:if test="${goodsDtl.multiOptYn eq 'N'}">
                    단일
                  </c:if>
                  <c:if test="${goodsDtl.multiOptYn eq 'Y'}">
                    다중
                  </c:if>
                </td>
              </tr>
              <tbody>
            </table>
          </div>
          <div class="tblw">
            <table summary="이표는 상품관리 옵션정보표 입니다.구성은 원가 정상가 판매가 공급가 재고 입니다.">
              <caption>옵션 정보</caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <c:if test="${goodsDtl.multiOptYn eq 'N'}">
              <tr>
                <th>정상가</th>
                <td>${goodsDtl.customerPrice}원</td>
              </tr>
              <tr>
                <th>판매가</th>
                <td>
                  ${goodsDtl.salePrice}원&nbsp;|&nbsp;
                  <c:if test="${goodsDtl.dcPriceApplyAlwaysYn eq 'Y'}">
                    무제한
                  </c:if>
                  <c:if test="${goodsDtl.dcPriceApplyAlwaysYn eq 'N'}">
                    ${fn:substring(goodsDtl.dcStartDttm, 0, 10)} ~ ${fn:substring(goodsDtl.dcEndDttm, 0, 10)}
                  </c:if>
                </td>
              </tr>
              <tr>
                <th>공급가</th>
                <td>${goodsDtl.supplyPrice}원</td>
              </tr>
              <tr>
                <th>재고</th>
                <td>${goodsDtl.stockQtt}개</td>
              </tr>
              </c:if>
              <c:if test="${goodsDtl.multiOptYn eq 'Y'}">
              <tr>
                <th>판매가 기간</th>
                <td>
                  <c:if test="${goodsDtl.multiDcPriceApplyAlwaysYn eq 'Y'}">
                    무제한
                  </c:if>
                  <c:if test="${goodsDtl.multiDcPriceApplyAlwaysYn eq 'N'}">
                    ${fn:substring(goodsDtl.multiDcStartDttm, 0, 10)} ~ ${fn:substring(goodsDtl.multiDcEndDttm, 0, 10)}
                  </c:if>
                </td>
              </tr>
              </c:if>
              <tbody>
            </table>
          </div>
          <c:if test="${goodsDtl.multiOptYn eq 'Y'}">
            <div id="div_tb_goods_option" class="tblh tblmany">
              <table id="tb_goods_option" summary="이표는 상품 판매정보 표 입니다. 구성은 기준판매가, 옵션(컬러), 소비자가, 공급가, 판매가, 재고,다비전 상품코드 입니다.">
                <caption>
                  상품 판매정보
                </caption>
                <colgroup>
                  <col width="18%">
                  <col width="15%" id="col_pop_dynamic_col">
                  <col width="15%">
                  <col width="15%">
                  <col width="15%">
                  <col width="15%">
                </colgroup>
                <thead class="thin">
                <tr>
                  <th rowspan="2">기준 판매가 선택</th>
                  <th class="line_b" id="th_pop_dynamic_cols">옵션</th>
                  <th rowspan="2">정상가</th>
                  <th rowspan="2">판매가</th>
                  <th rowspan="2">공급가</th>
                  <th rowspan="2">재고</th>
                </tr>
                <tr id="tr_pop_goods_item_head_2">
                  <c:forEach var="option" items="${goodsDtl.goodsOptionList}" varStatus="status">
                    <th class="line_l borr">${option.optNm}</th>
                  </c:forEach>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${goodsDtl.goodsItemList}" varStatus="status">
                  <tr>
                    <td><c:if test="${item.standardPriceYn eq 'Y'}">선택</c:if></td>
                    <c:if test="${item.attrValue1 ne null and item.attrValue1 ne ''}">
                      <td>${item.attrValue1}</td>
                    </c:if>
                    <c:if test="${item.attrValue2 ne null and item.attrValue2 ne ''}">
                      <td>${item.attrValue2}</td>
                    </c:if>
                    <c:if test="${item.attrValue3 ne null and item.attrValue3 ne ''}">
                      <td>${item.attrValue3}</td>
                    </c:if>
                    <c:if test="${item.attrValue4 ne null and item.attrValue4 ne ''}">
                      <td>${item.attrValue4}</td>
                    </c:if>
                    <td><fmt:formatNumber value="${item.customerPrice}" type="number"/></td>
                    <td><fmt:formatNumber value="${item.salePrice}" type="number"/></td>
                    <td><fmt:formatNumber value="${item.supplyPrice}" type="number"/></td>
                    <td><fmt:formatNumber value="${item.stockQtt}" type="number"/></td>
                  </tr>
                </c:forEach>
                </tbody>
              </table>
            </div>
          </c:if>
        </div>
        <!-- 사은품 정보 -->
        <%--<div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">사은품 정보</h3>
          <!-- tblw -->
          <div class="tblw tblmany">
            <table summary="이표는 상품관리 사은품 정보표 입니다.">
              <caption>사은품 정보</caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <tr>
                <th>사은품 선택</th>
                <td>
                  <ul class="tbl_ul" id="sel_freebie_list" style="display:block ;">
                    <li>
                      <img src="https://image.davichmarket.com/image/image-view?type=FREEBIEDTL&amp;id1=20180911_0b42e7c14b065d4f8d1d456d9f117af8f0d53568114bc5bb3213a8260906f65f_100x88x05"
                           width="200" height="150" alt="사은품이미지">
                      <br><span class="txt">디지털 상품권 1만원</span>
                    </li>
                  </ul>
                </td>
              </tr>
              <tbody>
            </table>
          </div>
          <!-- //tblw -->
        </div>
        <!-- 스마트피팅 정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">스마트피팅 정보 </h3>
          <!-- tblw -->
          <div class="tblw tblmany">
            <table summary="이표는 상품관리 스마트피팅 정보표 입니다.">
              <caption>사스마트피팅 정보</caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody>
              <tr>
                <th>스마트피팅 사용 여부</th>
                <td></td>
              </tr>
              <tbody>
            </table>
          </div>
          <!-- //tblw -->
        </div>--%>
        <!-- 배송 정보 -->
        <div class="line_box fri marginB40">
          <h3 class="tlth3 btn1">배송 정보 <span class="ui-icon-help"></span></h3>
          <!-- tblw -->
          <div class="tblw tblmany">
            <table id="tb_goods_delivery"
                   summary="이표는 상품 배송정보 표 입니다. 구성은 예상 배송 소요일, 배송비설정, 요청상품 배송방법, 요청상품 거래제한조건 입니다.">
              <caption>상품 배송정보</caption>
              <colgroup>
                <col width="190px">
                <col width="">
              </colgroup>
              <tbody id="tbody_goods_delivery">
              <tr data-bind="delivery_info">
                <th>예상 배송 소요일</th>
                <td>평균 ${goodsDtl.dlvrExpectDays}일</td>
              </tr>
              <tr data-bind="delivery_info">
                <th>배송비 설정</th>
                <td>
                  <c:choose>
                    <c:when test="${goodsDtl.dlvrSetCd eq '1'}">
                      기본 배송비
                    </c:when>
                    <c:when test="${goodsDtl.dlvrSetCd eq '2'}">
                      상품별 배송비 (무료)
                    </c:when>
                    <c:when test="${goodsDtl.dlvrSetCd eq '3'}">
                      상품별 배송비 (유료)
                      <span class="br"></span>
                      개수와 상관없이 배송비 <fmt:formatNumber value="${goodsDtl.goodseachDlvrc}" type="number"/>원
                    </c:when>
                    <c:when test="${goodsDtl.dlvrSetCd eq '6'}">
                      상품별 배송비 (조건부 무료)
                      <span class="br"></span>
                      배송비 <fmt:formatNumber value="${goodsDtl.goodseachcndtaddDlvrc}" type="number"/>원 (<fmt:formatNumber value="${goodsDtl.freeDlvrMinAmt}" type="number"/>원 이상 구매시 무료)
                    </c:when>
                    <c:when test="${goodsDtl.dlvrSetCd eq '4'}">
                      포장단위별 배송비
                      <span class="br"></span>
                      포장 최대단위는 상품 <fmt:formatNumber value="${goodsDtl.packMaxUnit}" type="number"/>개 이며, 배송비 <fmt:formatNumber value="${goodsDtl.packUnitDlvrc}" type="number"/>원
                      <br>
                      ex) 택배 포장단위 별 최대 3개까지 2,500원 추가 3개당 2,500원
                    </c:when>
                  </c:choose>
                </td>
              </tr>
              <tr data-bind="delivery_info">
                <th>요청 상품 배송 방법</th>
                <td>택배배송</td>
              </tr>
              <tr data-bind="delivery_info">
                <th>배송비 결제 방식</th>
                <td>
                  <c:choose>
                    <c:when test="${goodsDtl.dlvrPaymentKindCd eq '1'}">
                      선불
                    </c:when>
                    <c:when test="${goodsDtl.dlvrPaymentKindCd eq '2'}">
                      착불
                    </c:when>
                    <c:when test="${goodsDtl.dlvrPaymentKindCd eq '3'}">
                      선불 + 착불
                    </c:when>
                  </c:choose>
                </td>
              </tr>
              </tbody>
            </table>
          </div>
          <!-- //tblw -->
        </div>
        <!-- 전자상거래 등에서의 상품 정보 제공 고시 -->
        <div class="line_box fri pb">
          <h3 class="tlth3 btn1">전자상거래 등에서의 상품 정보 제공 고시 </h3>
          <!-- tblw -->
          <div class="tblw">
            <table summary="이표는 전자상거래 등에서의 상품정보제공 고시 리스트 표 입니다. 구성은 품목, 항목, 정보 입니다.">
              <caption>전자상거래 등에서의 상품정보제공 고시 리스트</caption>
              <colgroup>
                <col width="200px">
                <col width="">
              </colgroup>
              <tbody id="tbody_goods_notify">
              <c:forEach var="notify" items="${goodsNotifyModel}" varStatus="status">
                <tr>
                  <th class="line goods_notify_txtl">${notify.itemNm}</th>
                  <td>
                    <c:forEach var="goodsNotify" items="${goodsDtl.goodsNotifyList}">
                      <c:if test="${goodsNotify.itemNo eq notify.itemNo}">
                        ${goodsNotify.itemValue}
                      </c:if>
                    </c:forEach>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
          <!-- //tblw -->
        </div>
      </form>
      <!--// line_box -->
    </div>
    <!-- bottom_box -->
    <div class="bottom_box">
      <div class="left">
        <button class="btn--big btn--big-white" id="btn_list">목록</button>
      </div>

      <div class="right">
        <button class="btn--blue-round" id="btn_approve">승인</button>
      </div>
    </div>
    <!-- // bottom_box -->
  </t:putAttribute>
</t:insertDefinition>