<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="filter_area">
    <div class="mid">
        <button type="button" class="btn_view_filter">Filter<i></i></button>
        <div class="check_area">
            <input type="checkbox" name="filterGbCd" id="check_01" class="filter_check_top" value="01" >
            <label for="check_01">브랜드<span></span></label>

            <input type="checkbox" name="filterGbCd" id="check_02" class="filter_check_top" value="02">
            <label for="check_02">가격<span></span></label>

            <%--  안경테 , 선글라스 --%>
            <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02'}">
                <input type="checkbox" name="filterGbCd" id="check_03" class="filter_check_top" value="03">
                <label for="check_03">색상<span></span></label>
            </c:if>

            <%--  안경테 , 선글라스 --%>
            <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02'}">
                <input type="checkbox" name="filterGbCd" id="check_04" class="filter_check_top" value="04">
                <label for="check_04">모양<span></span></label>
            </c:if>

            <%--  안경테 , 선글라스 --%>
            <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02'}">
                <input type="checkbox" name="filterGbCd" id="check_05" class="filter_check_top" value="05">
                <label for="check_05">재질<span></span></label>
            </c:if>

            <%--  안경테 , 선글라스 --%>
            <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02'}">
                <input type="checkbox" name="filterGbCd" id="check_06" class="filter_check_top" value="06">
                <label for="check_06">사이즈<span></span></label>
            </c:if>

            <%-- 선글라스 --%>
            <c:if test="${category_info.filterTypeCd eq '02'}">
                <%--<input type="checkbox" name="filterGbCd" id="check_07" class="filter_check_top" value="07">
                <label for="check_06">안구색상(상단)<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_08" class="filter_check_top" value="08">
                <label for="check_07">안구색상(메탈전체)<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_09" class="filter_check_top" value="09">
                <label for="check_08">다리색상(홈선에폭시)<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_10" class="filter_check_top" value="10">
                <label for="check_09">팁색상<span></span></label>--%>
                <input type="checkbox" name="filterGbCd" id="check_11" class="filter_check_top" value="11">
                <label for="check_11">렌즈색상<span></span></label>
            </c:if>

            <%-- 안경렌즈 --%>
            <c:if test="${category_info.filterTypeCd eq '03'}">
                <!-- <input type="checkbox" name="filterGbCd" id="check_12" class="filter_check_top" value="12">
                <label for="check_12">용도<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_13" class="filter_check_top" value="13">
                <label for="check_13">초점<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_14" class="filter_check_top" value="14">
                <label for="check_14">기능<span></span></label> -->
                <input type="checkbox" name="filterGbCd" id="check_12" class="filter_check_top" value="12">
                <label for="check_12">제조사<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_13" class="filter_check_top" value="13">
                <label for="check_13">두께<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_14" class="filter_check_top" value="14">
                <label for="check_14">설계<span></span></label>
            </c:if>

            <%-- 콘택트렌즈 --%>
            <c:if test="${category_info.filterTypeCd eq '04'}">
            	<input type="checkbox" name="filterGbCd" id="check_23" class="filter_check_top" value="23">
                <label for="check_23">컬러별<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_15" class="filter_check_top" value="15">
                <label for="check_15">착용주기<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_17" class="filter_check_top" value="17">
                <label for="check_17">그래픽사이즈<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_21" class="filter_check_top" value="21">
                <label for="check_21">가격별<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_22" class="filter_check_top" value="22">
                <label for="check_22">증상별<span></span></label>
            </c:if>

            <%-- 보청기 --%>
            <c:if test="${category_info.filterTypeCd eq '05'}">
                <input type="checkbox" name="filterGbCd" id="check_18" class="filter_check_top" value="18">
                <label for="check_18">형태/크기<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_19" class="filter_check_top" value="19">
                <label for="check_19">난청유형<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_20" class="filter_check_top" value="20">
                <label for="check_20">난청정도<span></span></label>
            </c:if>

        </div>
    </div>
    <!-- 필터 상세 -->
    <div class="filter_detail_area">
        <ul class="list">
            <li id="filterLayer_01">
                <div class="title_area"><h4 class="filter_tit">브랜드</h4></div>
                <ul class="right_check">
                    <c:forEach var="brandList" items="${brand_list}" varStatus="bstatus">
                        <li>
                            <input type="checkbox" id="chk_brand0${bstatus.index+1}" name="searchBrands" class="brand_check" value="${brandList.brandNo}"
                            <c:forEach var="selectbrandList" items="${so.searchBrands}" varStatus="status">
                                   <c:if test="${brandList.brandNo eq selectbrandList }">checked="checked"</c:if>
                            </c:forEach>
                            >
                            <label for="chk_brand0${bstatus.index+1}"><span></span>${brandList.brandNm}</label>
                        </li>
                    </c:forEach>
                </ul>
            </li>

            <li>
                <%-- 안경테 , 선글라스 --%>
                <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02' }">
                    <div class="color_area" id="filterLayer_03">
                        <h4 class="filter_tit">색상</h4>
                        <div class="color_pick">

                                <%-- 안경테 --%>
                            <c:if test="${category_info.filterTypeCd eq '01'}">

                                <%--<input type="hidden" name="frameColorCd" value="${so.frameColorCd}"/>--%>
                                <code:color name="frameColorCd" codeGrp="FRAME_COLOR_CD" idPrefix="frameColorCd" value="${so.frameColorCd}"/>
                            </c:if>
                                <%-- 선글라스 --%>
                            <c:if test="${category_info.filterTypeCd eq '02'}">
                                <%--<input type="hidden" name="sunglassColorCd" value="${so.sunglassColorCd}"/>--%>
                                <code:color name="sunglassColorCd" codeGrp="SUNGLASS_COLOR_CD" idPrefix="sunglassColorCd" value="${so.sunglassColorCd}"/>
                            </c:if>
                                <%-- 안경렌즈 --%>
                            <c:if test="${category_info.filterTypeCd eq '03'}">
                                <%--<input type="hidden" name="glassColorCd" value="${so.glassColorCd}"/>--%>
                                <code:color name="glassColorCd" codeGrp="GLASS_COLOR_CD" idPrefix="glassColorCd" value="${so.glassColorCd}"/>
                            </c:if>
                        </div>
                    </div>
                </c:if>
                <%-- 안경테 , 선글라스--%>
                <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02' }">
                    <div class="detail_area" id="filterLayer_04">
                        <h4 class="filter_tit">모양</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '01' }">
                                <code:checkboxFLT name="frameShapeCd" codeGrp="FRAME_SHAPE_CD" idPrefix="frameShapeCd" value="${so.frameShapeCd}"/>
                            </c:if>

                            <c:if test="${category_info.filterTypeCd eq '02' }">
                                <code:checkboxFLT name="sunglassShapeCd" codeGrp="SUNGLASS_SHAPE_CD" idPrefix="sunglassShapeCd" value="${so.sunglassShapeCd}"/>
                            </c:if>
                        </ul>
                    </div>
                </c:if>

                <%-- 안경테 , 선글라스 --%>
                <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02'}">
                    <div class="detail_area" id="filterLayer_05">
                        <h4 class="filter_tit">재질</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '01' }">
                                <code:checkboxFLT name="frameMaterialCd" codeGrp="FRAME_MATERIAL_CD" idPrefix="frameMaterialCd" value="${so.frameMaterialCd}"/>
                            </c:if>

                            <c:if test="${category_info.filterTypeCd eq '02' }">
                                <code:checkboxFLT name="sunglassMaterialCd" codeGrp="SUNGLASS_MATERIAL_CD" idPrefix="sunglassMaterialCd" value="${so.sunglassMaterialCd}"/>
                            </c:if>
                        </ul>
                    </div>
                </c:if>
                <%-- 안경테 , 선글라스 --%>
                <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02'}">
                    <div class="detail_area" id="filterLayer_06">
                        <h4 class="filter_tit">사이즈</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '01' }">
                                <code:checkboxFLT name="frameSizeCd" codeGrp="FRAME_SIZE_CD" idPrefix="frameSizeCd" value="${so.frameSizeCd}"/>
                            </c:if>
                            <c:if test="${category_info.filterTypeCd eq '02' }">
                                <code:checkboxFLT name="sunglassSizeCd" codeGrp="SUNGLASS_SIZE_CD" idPrefix="sunglassSizeCd" value="${so.sunglassSizeCd}"/>
                            </c:if>
                        </ul>
                    </div>
                </c:if>
                <%-- 선글라스 --%>
                <c:if test="${category_info.filterTypeCd eq '02'}">
                    <div class="detail_area" id="filterLayer_11">
                        <h4 class="filter_tit">렌즈색상</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '02' }">
                                <code:checkboxFLT name="sunglassLensColorCd" codeGrp="SUNGLASS_LENS_COLOR_CD" idPrefix="sunglassLensColorCd" value="${so.sunglassLensColorCd}"/>
                            </c:if>
                        </ul>
                    </div>
                </c:if>
                <%-- 안경렌즈 --%>
                <c:if test="${category_info.filterTypeCd eq '03'}">
                    <%-- <div class="detail_area" id="filterLayer_12">
                        <h4 class="filter_tit">용도</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '03' }">
                                <code:checkboxFLT name="glassUsageCd" codeGrp="GLASS_USAGE_CD" idPrefix="glassUsageCd" value="${so.glassUsageCd}"/>
                            </c:if>
                        </ul>
                    </div>
                    <div class="detail_area" id="filterLayer_13">
                        <h4 class="filter_tit">초점</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '03' }">
                                <code:checkboxFLT name="glassFocusCd" codeGrp="GLASS_FOCUS_CD" idPrefix="glassFocusCd" value="${so.glassFocusCd}"/>
                            </c:if>
                        </ul>
                    </div>
                    <div class="detail_area" id="filterLayer_14">
                        <h4 class="filter_tit">기능</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '03' }">
                                <code:checkboxFLT name="glassFunctionCd" codeGrp="GLASS_FUNCTION_CD" idPrefix="glassFunctionCd" value="${so.glassFunctionCd}"/>
                            </c:if>
                        </ul>
                    </div> --%>
                    <div class="detail_area" id="filterLayer_12">
                        <h4 class="filter_tit">제조사</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '03' }">
                                <code:checkboxFLT name="glassMmftCd" codeGrp="GLASS_MMFT_CD" idPrefix="glassMmftCd" value="${so.glassMmftCd}"/>
                            </c:if>
                        </ul>
                    </div>
                    <div class="detail_area" id="filterLayer_13">
                        <h4 class="filter_tit">두께</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '03' }">
                                <code:checkboxFLT name="glassThickCd" codeGrp="GLASS_THICK_CD" idPrefix="glassThickCd" value="${so.glassThickCd}"/>
                            </c:if>
                        </ul>
                    </div>
                    <div class="detail_area" id="filterLayer_14">
                        <h4 class="filter_tit">설계</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '03' }">
                                <code:checkboxFLT name="glassDesignCd" codeGrp="GLASS_DESIGN_CD" idPrefix="glassDesignCd" value="${so.glassDesignCd}"/>
                            </c:if>
                        </ul>
                    </div>
                </c:if>
            <%-- 콘택트 렌즈 --%>
            <c:if test="${category_info.filterTypeCd eq '04'}">
            	<div class="detail_area" id="filterLayer_23">
                    <h4 class="filter_tit">컬러별</h4>
                    <ul class="detail_check_list">
                        <c:if test="${category_info.filterTypeCd eq '04' }">
                            <code:checkboxFLT name="contactColorCd" codeGrp="CONTACT_COLOR_CD" idPrefix="contactColorCd" value="${so.contactColorCd}"/>
                        </c:if>
                    </ul>
                </div>
                
                <div class="detail_area" id="filterLayer_15">
                    <h4 class="filter_tit">착용주기</h4>
                    <ul class="detail_check_list">
                        <c:if test="${category_info.filterTypeCd eq '04' }">
                            <code:checkboxFLT name="contactCycleCd" codeGrp="CONTACT_CYCLE_CD" idPrefix="contactCycleCd" value="${so.contactCycleCd}"/>
                        </c:if>
                    </ul>
                </div>
                
                <div class="detail_area" id="filterLayer_17">
                    <h4 class="filter_tit">그래픽사이즈</h4>
                    <ul class="detail_check_list">
                        <c:if test="${category_info.filterTypeCd eq '04' }">
                            <code:checkboxFLT name="contactSizeCd" codeGrp="CONTACT_SIZE_CD" idPrefix="contactSizeCd" value="${so.contactSizeCd}"/>
                        </c:if>
                    </ul>
                </div>
                
                <div class="detail_area" id="filterLayer_21">
                    <h4 class="filter_tit">가격별</h4>
                    <ul class="detail_check_list">
                        <c:if test="${category_info.filterTypeCd eq '04' }">
                            <code:checkboxFLT name="contactPriceCd" codeGrp="CONTACT_PRICE_CD" idPrefix="contactPriceCd" value="${so.contactPriceCd}"/>
                        </c:if>
                    </ul>
                </div>
                
                <div class="detail_area" id="filterLayer_22">
                    <h4 class="filter_tit">증상별</h4>
                    <ul class="detail_check_list">
                        <c:if test="${category_info.filterTypeCd eq '04' }">
                            <code:checkboxFLT name="contactStatusCd" codeGrp="CONTACT_STATUS_CD" idPrefix="contactStatusCd" value="${so.contactStatusCd}"/>
                        </c:if>
                    </ul>
                </div>
                
            </c:if>
            <%-- 보청기 --%>
            <c:if test="${category_info.filterTypeCd eq '05'}">
                <div class="detail_area" id="filterLayer_18">
                    <h4 class="filter_tit">형태/크기</h4>
                    <ul class="detail_check_list">
                        <c:if test="${category_info.filterTypeCd eq '05' }">
                            <code:checkboxFLT name="aidShapeCd" codeGrp="AID_SHAPE_CD" idPrefix="aidShapeCd" value="${so.aidShapeCd}"/>
                        </c:if>
                    </ul>
                </div>
                <div class="detail_area" id="filterLayer_19">
                    <h4 class="filter_tit">난청유형</h4>
                    <ul class="detail_check_list">
                        <c:if test="${category_info.filterTypeCd eq '05' }">
                            <code:checkboxFLT name="aidLosstypeCd" codeGrp="AID_LOSSTYPE_CD" idPrefix="aidLosstypeCd" value="${so.aidLosstypeCd}"/>
                        </c:if>
                    </ul>
                </div>
                <div class="detail_area" id="filterLayer_20">
                    <h4 class="filter_tit">난청정도</h4>
                    <ul class="detail_check_list">
                        <c:if test="${category_info.filterTypeCd eq '05' }">
                            <code:checkboxFLT name="aidLossdegreeCd" codeGrp="AID_LOSSDEGREE_CD" idPrefix="aidLossdegreeCd" value="${so.aidLossdegreeCd}"/>
                        </c:if>
                    </ul>
                </div>
            </c:if>
            </li>
            <li id="filterLayer_02">
                <div class="title_area"><h4 class="filter_tit">가격</h4></div>
                <input type="text" class="form_price numeric comma" name="stPrice" value="${so.stPrice}"><span class="label_won">원</span> ~
                <input type="text" class="form_price numeric comma" name="endPrice" value="${so.endPrice}"><span class="label_won">원</span>
               <%-- <div class="bar_select" id="slider-range">
                    <p style="width:0%"></p>
                </div>--%>
            </li>
        </ul>
        <div class="btn_filter_area">
            <button type="button" class="btn_refresh">초기화</button>
            <button type="button" class="btn_good_search">찾기<i></i></button>
        </div>
    </div>
    <!--// 필터 상세 -->
</div>

