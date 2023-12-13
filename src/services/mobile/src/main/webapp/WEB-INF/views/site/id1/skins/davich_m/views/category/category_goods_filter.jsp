<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
    $(document).ready(function(){

        Dmall.common.numeric();
        Dmall.common.comma();

        // filter layer setting...
        $(".filter_area .filter_list a,.color_check").on("click",function(){

            var _name= $(this).attr("name");
            var _value= $(this).attr("value");
            var _id= $(this).attr("id");
            var _text = $(this).text();
            var _colorTxt = $(this).next('label[for='+_id+']').text();
            if(!_text){
                _text=_colorTxt;
            }
            var delBtn = '<button type="button" class="btn_del">삭제</button>';

            var _filter = $(".filter_tag");
            var addhiddenInput="";
            if(_name!=undefined){

                var _filterGbCd = $(this).parents('ul').prev('[name=filterGbCd]').attr("value");

                var duplicated = $(".filter_tag").find('input[type=hidden][name=filterGbCd][value='+_filterGbCd+']').length;
                if(duplicated<1){
                    addhiddenInput += '<input type="hidden" name="filterGbCd" value="'+_filterGbCd+'">';
                }

                addhiddenInput += '<input type="hidden" name="'+_name+'" value="'+_value+'">';

                var duplicated = $(".filter_tag").find('input[type=hidden][name='+_name+'][value='+_value+']').length;

                if(duplicated<1){
                    _filter.append('<span class="filters" name="'+_name+'">'+addhiddenInput+'#'+_text+delBtn+'<span>');
                }

            }

            //제거버튼
            $('.filters button').on('click',function(){
                $(this).parent().remove();
            });
        });

        $('button[name=applyPrice]').on('click',function(){
            var _filter = $(".filter_tag");
            var stPrice01 = $("[name=stPrice01]").val();
            var endPrice01 = $("[name=endPrice01]").val();
            var _text =stPrice01 ;
            var _name = "priceInfo";
            if(endPrice01!=""){
                _text +="~"+endPrice01;
            }

            var delBtn = '<button type="button" class="btn_del">삭제</button>';

            $('span[name='+_name+']').remove();
            $('input[name=stPrice]').remove();
            $('input[name=endPrice]').remove();


            var addhiddenInput = '<input type="hidden" name="stPrice" value="' + $("[name=stPrice01]").val().replace(",","") + '">'+
                                 '<input type="hidden" name="endPrice" value="'+ $("[name=endPrice01]").val().replace(",","") + '">'+
                                 '<input type="hidden" name="filterGbCd" value="02">';
            _filter.append('<span class="filters" name="'+_name+'">'+addhiddenInput+'#'+_text+delBtn+'<span>');

            /*$("[name=stPrice]").val($("[name=stPrice01]").val().replace(",",""));
            $("[name=endPrice]").val($("[name=endPrice01]").val().replace(",",""));*/
            //제거버튼
            $('.filters button').on('click',function(){
                $(this).parent().remove();
            });
        });

        /*$("[name=stPrice01]").on('keypress',function(){
            var _val = $(this).val();
            var _filter = $(".filter_tag");
            var obj = $(".filter_tag").find('input[type=hidden][name=stPrice]');
            var duplicated = obj.length;

            if(duplicated<1) {
                var addhiddenInput = '<input type="hidden" name="stPrice" value="' + _val + '">';
                _filter.append('<span class="filters" name="stPrice">' + addhiddenInput + '#' + _val + '<em> *제거* </em><span>');
            }else{

            }
        });

        $("[name=endPrice02]").on('keypress',function(){
            var _val = $(this).val();
            var _filter = $(".filter_tag");

            var addhiddenInput = '<input type="hidden" name="endPrice" value="'+_val+'">';
            _filter.append('<span class="filters" name="endPrice">'+addhiddenInput+'#'+_val+'<em> *제거* </em><span>');
        });*/



        // 찾기 버튼 클릭
        $('.btn_good_search').on('click',function(){
            if($("[name=stPrice01]").val() != null && $("[name=stPrice01]").val()!=""){
                $("[name=stPrice]").val($("[name=stPrice01]").val().replace(",",""));
            }
            if($("[name=endPrice01]").val() != null && $("[name=endPrice01]").val()!=""){
                $("[name=endPrice]").val($("[name=endPrice01]").val().replace(",",""));
            }

            category_search();
        });

        //초기화
        $('.btn_refresh').on('click',function(){
            $("[name=stPrice01]").val('');
            $("[name=endPrice01]").val('');
            $(".filter_tag").empty();
        });

        //전체
        $('#btn_all_search').on('click',function(){
            $(".filter_tag").empty();
            category_search();

        });



        //검색후 처리
        var searchBrands = '${so.searchBrands}';
        <c:forEach var="searchBrand" items="${so.searchBrands}" varStatus="status">
            $('a[name=searchBrands][value=${searchBrand}]').trigger('click');
        </c:forEach>

        var searchframeColorCd ='${so.frameColorCd}';
        <c:forEach var="frameColorCd" items="${so.frameColorCd}" varStatus="status">
        $('.color_check[value=${frameColorCd}]').trigger('click');
        </c:forEach>


        var searchsunglassColorCd ='${so.sunglassColorCd}';
        <c:forEach var="sunglassColorCd" items="${so.sunglassColorCd}" varStatus="status">
        $('.color_check[value=${sunglassColorCd}]').trigger('click');
        </c:forEach>

        var searchglassColorCd ='${so.glassColorCd}';
        <c:forEach var="glassColorCd" items="${so.glassColorCd}" varStatus="status">
        $('.color_check[value=${glassColorCd}]').trigger('click');
        </c:forEach>


        var searchcontactColorCd ='${so.contactColorCd}';
        <c:forEach var="contactColorCd" items="${so.contactColorCd}" varStatus="status">
        $('.color_check[value=${contactColorCd}]').trigger('click');
        </c:forEach>

        var searchframeShapeCd ='${so.frameShapeCd}';
        <c:forEach var="frameShapeCd" items="${so.frameShapeCd}" varStatus="status">
        $('a[name=frameShapeCd][value=${frameShapeCd}]').trigger('click');
        </c:forEach>
        var searchsunglassShapeCd ='${so.sunglassShapeCd}';
        <c:forEach var="sunglassShapeCd" items="${so.sunglassShapeCd}" varStatus="status">
        $('a[name=sunglassShapeCd][value=${sunglassShapeCd}]').trigger('click');
        </c:forEach>
        var searchframeMaterialCd ='${so.frameMaterialCd}';
        <c:forEach var="frameMaterialCd" items="${so.frameMaterialCd}" varStatus="status">
        $('a[name=frameMaterialCd][value=${frameMaterialCd}]').trigger('click');
        </c:forEach>
        var searchsunglassMaterialCd ='${so.sunglassMaterialCd}';
        <c:forEach var="sunglassMaterialCd" items="${so.sunglassMaterialCd}" varStatus="status">
        $('a[name=sunglassMaterialCd][value=${sunglassMaterialCd}]').trigger('click');
        </c:forEach>
        var searchframeSizeCd ='${so.frameSizeCd}';
        <c:forEach var="frameSizeCd" items="${so.frameSizeCd}" varStatus="status">
        $('a[name=frameSizeCd][value=${frameSizeCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="sunglassSizeCd" items="${so.sunglassSizeCd}" varStatus="status">
        $('a[name=sunglassSizeCd][value=${sunglassSizeCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="sunglassLensColorCd" items="${so.sunglassLensColorCd}" varStatus="status">
        $('a[name=sunglassLensColorCd][value=${sunglassLensColorCd}]').trigger('click');
        </c:forEach>

        /* <c:forEach var="glassUsageCd" items="${so.glassUsageCd}" varStatus="status">
        $('a[name=glassUsageCd][value=${glassUsageCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="glassFocusCd" items="${so.glassFocusCd}" varStatus="status">
        $('a[name=glassFocusCd][value=${glassFocusCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="glassFunctionCd" items="${so.glassFunctionCd}" varStatus="status">
        $('a[name=glassFunctionCd][value=${glassFunctionCd}]').trigger('click');
        </c:forEach> */
        
        <c:forEach var="glassMmftCd" items="${so.glassMmftCd}" varStatus="status">
        $('a[name=glassMmftCd][value=${glassMmftCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="glassThickCd" items="${so.glassThickCd}" varStatus="status">
        $('a[name=glassThickCd][value=${glassThickCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="glassDesignCd" items="${so.glassDesignCd}" varStatus="status">
        $('a[name=glassDesignCd][value=${glassDesignCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="contactCycleCd" items="${so.contactCycleCd}" varStatus="status">
        $('a[name=contactCycleCd][value=${contactCycleCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="contactSizeCd" items="${so.contactSizeCd}" varStatus="status">
        $('a[name=contactSizeCd][value=${contactSizeCd}]').trigger('click');
        </c:forEach>
        
        <c:forEach var="contactPriceCd" items="${so.contactPriceCd}" varStatus="status">
        $('a[name=contactPriceCd][value=${contactPriceCd}]').trigger('click');
        </c:forEach>
        
        <c:forEach var="contactStatusCd" items="${so.contactStatusCd}" varStatus="status">
        $('a[name=contactStatusCd][value=${contactStatusCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="aidShapeCd" items="${so.aidShapeCd}" varStatus="status">
        $('a[name=aidShapeCd][value=${aidShapeCd}]').trigger('click');
        </c:forEach>

        <c:forEach var="aidShapeCd" items="${so.aidShapeCd}" varStatus="status">
        $('a[name=aidShapeCd][value=${aidShapeCd}]').trigger('click');
        </c:forEach>


        var searchstPrice ='${so.stPrice}';
        var searchendPrice ='${so.endPrice}';
        if(searchstPrice!="" || searchendPrice!="") {
            $('button[name=applyPrice]').trigger("click");
        }

        // 색상선택
       /* $('a[name=colorCd]').on('click',function(){
        console.log($(this).attr("value"))
            $(this).parents('.filter_list').find('input').val($(this).attr("value"));
        });*/


        var stPrice = $("[name=stPrice]").val()?$("[name=stPrice]").val().replace(",",""):0;
        var endPrice = $("[name=endPrice]").val()?$("[name=endPrice]").val().replace(",",""):50000;

        $( "#slider-range" ).slider({
            range: true,
            min: 5000,
            max: 50000,
            values: [ stPrice, endPrice ],
            slide: function( event, ui ) {

                var barstyle = $(this).find('div').attr('style');

                $(this).find('p').attr('style',barstyle);

                $("[name=stPrice]").val(ui.values[0]);
                $("[name=endPrice]").val(ui.values[1]);

                Dmall.common.numeric();
                Dmall.common.comma();
            }
        });

        // 가격 slider setting..
        var barstyle = $( "#slider-range" ).find('div').attr('style');
        $( "#slider-range" ).find('p').attr('style',barstyle);

        $(".btn_view_filter").click(function() {
            $(".filter_area").toggle();
           /* var obj = $("[name=filterGbCd]");
            obj.each(function(){
                if(!$(this).prop("checked")){
                    $(this).trigger('click');
                }
            });*/
        });


       /* $( ".filter_area ul.filter_list" ).hide();
        $("a[name=filterGbCd]").click(function(e) {
            e.preventDefault();
            var OpenList = $(this).next(".filter_row ul.filter_list");
            $(this).toggleClass("active");
            $(OpenList).stop().slideToggle(300);
            $(".filter_row > a").not(this).removeClass("active");
            $(".filter_row ul.filter_list").not(OpenList).stop().hide();
        });*/

    });
</script>
<div class="filter_area">
        <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="01">브랜드<span>닫기</span></a>
            <ul class="filter_list" style="display: none;">
            <c:forEach var="brandList" items="${brand_list}" varStatus="bstatus">
                <li><a href="javascript:;" name="searchBrands" value="${brandList.brandNo}">${brandList.brandNm}</a></li>
            </c:forEach>
            </ul>
            <c:if test="${category_info.filterTypeCd ne '04'}">
            <a href="javascript:;" name="filterGbCd" value="02">가격<span>더보기</span></a>
            <ul class="filter_list row_01" style="display: none;">
                <li>
                    <input type="text" class="form_price numeric comma" name="stPrice01" value="${so.stPrice}"><span class="label_won">원</span> ~
                    <input type="text" class="form_price numeric comma" name="endPrice01" value="${so.endPrice}"><span class="label_won">원</span>
                    <!-- <div class="bar_select" id="slider-range">
                        <p style="width:0%"></p>
                    </div> -->
                    <button type="button" name="applyPrice" class="btn_price_set">적용</button>
                </li>
            </ul>
            </c:if>
            <c:if test="${category_info.filterTypeCd eq '04'}">
            <a href="javascript:;" name="filterGbCd" value="21">가격<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '04' }">
                    <code:checkboxFLT name="contactPriceCd" codeGrp="CONTACT_PRICE_CD" idPrefix="contactPriceCd" value="${so.contactPriceCd}"/>
                </c:if>
            </ul>
            </c:if>
        </div>

        <%-- 안경테 , 선글라스 --%>
        <c:if test="${category_info.filterTypeCd ne '05' && category_info.filterTypeCd ne '03' && category_info.filterTypeCd ne '04'}">
    <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="03">색상<span>더보기</span></a>
            <ul class="filter_list row_01" style="display: none;">
                <li>
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
                <%-- <c:if test="${category_info.filterTypeCd eq '03'}">
                    <input type="hidden" name="glassColorCd" value="${so.glassColorCd}"/>
                    <code:color name="glassColorCd" codeGrp="GLASS_COLOR_CD" idPrefix="glassColorCd" value="${so.glassColorCd}"/>
                </c:if> --%>
                    <%-- 콘택트렌즈 --%>
                <c:if test="${category_info.filterTypeCd eq '04'}">
                    <%--<input type="hidden" name="contactColorCd" value="${so.contactColorCd}"/>--%>
                    <code:color name="contactColorCd" codeGrp="CONTACT_COLOR_CD" idPrefix="contactColorCd" value="${so.contactColorCd}"/>
                </c:if>
                    </div>
                </li>
            </ul>
        </c:if>
        <c:if test="${category_info.filterTypeCd eq '04'}">
        <div class="filter_row">
        	<a href="javascript:;" name="filterGbCd" value="15">색상<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '04' }">
                    <code:checkboxFLT name="contactColorCd" codeGrp="CONTACT_COLOR_CD" idPrefix="contactColorCd" value="${so.contactColorCd}"/>
                </c:if>
            </ul>
        </c:if>
        <%-- 안경테 , 선글라스--%>
        <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02' }">
            <a href="javascript:;" name="filterGbCd" value="04">모양<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '01' }">
                    <code:checkboxFLT name="frameShapeCd" codeGrp="FRAME_SHAPE_CD" idPrefix="frameShapeCd" value="${so.frameShapeCd}"/>
                </c:if>

                <c:if test="${category_info.filterTypeCd eq '02' }">
                    <code:checkboxFLT name="sunglassShapeCd" codeGrp="SUNGLASS_SHAPE_CD" idPrefix="sunglassShapeCd" value="${so.sunglassShapeCd}"/>
                </c:if>
            </ul>
            </div>
    <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="06">사이즈<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '01' }">
                    <code:checkboxFLT name="frameSizeCd" codeGrp="FRAME_SIZE_CD" idPrefix="frameSizeCd" value="${so.frameSizeCd}"/>
                </c:if>
                <c:if test="${category_info.filterTypeCd eq '02' }">
                    <code:checkboxFLT name="sunglassSizeCd" codeGrp="SUNGLASS_SIZE_CD" idPrefix="sunglassSizeCd" value="${so.sunglassSizeCd}"/>
                </c:if>
            </ul>
            <a href="javascript:;" name="filterGbCd" value="05">재질<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '01' }">
                    <code:checkboxFLT name="frameMaterialCd" codeGrp="FRAME_MATERIAL_CD" idPrefix="frameMaterialCd" value="${so.frameMaterialCd}"/>
                </c:if>

                <c:if test="${category_info.filterTypeCd eq '02' }">
                    <code:checkboxFLT name="sunglassMaterialCd" codeGrp="SUNGLASS_MATERIAL_CD" idPrefix="sunglassMaterialCd" value="${so.sunglassMaterialCd}"/>
                </c:if>

            </ul>
    </div>
            <%-- 선글라스 --%>
            <c:if test="${category_info.filterTypeCd eq '02'}">
    <div class="filter_row">
                <a href="javascript:;" name="filterGbCd" value="11">렌즈색상<span>더보기</span></a>
                <ul class="filter_list" style="display: none;">
                    <c:if test="${category_info.filterTypeCd eq '02' }">
                        <code:checkboxFLT name="sunglassLensColorCd" codeGrp="SUNGLASS_LENS_COLOR_CD" idPrefix="sunglassLensColorCd" value="${so.sunglassLensColorCd}"/>
                    </c:if>
                </ul>
    </div>
            </c:if>
        </c:if>

        <%-- 콘택트렌즈 --%>
        <c:if test="${category_info.filterTypeCd eq '04'}">

            <a href="javascript:;" name="filterGbCd" value="15">착용주기<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '04' }">
                    <code:checkboxFLT name="contactCycleCd" codeGrp="CONTACT_CYCLE_CD" idPrefix="contactCycleCd" value="${so.contactCycleCd}"/>
                </c:if>
            </ul>

        </div>
        <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="17">그래픽사이즈<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '04' }">
                    <code:checkboxFLT name="contactSizeCd" codeGrp="CONTACT_SIZE_CD" idPrefix="contactSizeCd" value="${so.contactSizeCd}"/>
                </c:if>
            </ul>
            
            <a href="javascript:;" name="filterGbCd" value="22">증상<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '04' }">
                    <code:checkboxFLT name="contactStatusCd" codeGrp="CONTACT_STATUS_CD" idPrefix="contactStatusCd" value="${so.contactStatusCd}"/>
                </c:if>
            </ul>
        </div>
        </c:if>

        <%-- 안경렌즈 --%>
        <c:if test="${category_info.filterTypeCd eq '03'}">
            <%-- <a href="javascript:;" name="filterGbCd" value="12">용도<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '03' }">
                    <code:checkboxFLT name="glassUsageCd" codeGrp="GLASS_USAGE_CD" idPrefix="glassUsageCd" value="${so.glassUsageCd}"/>
                </c:if>
            </ul>
            </div>
            <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="13">초점<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '03' }">
                    <code:checkboxFLT name="glassFocusCd" codeGrp="GLASS_FOCUS_CD" idPrefix="glassFocusCd" value="${so.glassFocusCd}"/>
                </c:if>
            </ul>

            <a href="javascript:;" name="filterGbCd" value="14">기능<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '03' }">
                    <code:checkboxFLT name="glassFunctionCd" codeGrp="GLASS_FUNCTION_CD" idPrefix="glassFunctionCd" value="${so.glassFunctionCd}"/>
                </c:if>
            </ul>
            </div> --%>
            
            <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="13">제조사<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '03' }">
                    <code:checkboxFLT name="glassMmftCd" codeGrp="GLASS_MMFT_CD" idPrefix="glassMmftCd" value="${so.glassMmftCd}"/>
                </c:if>
            </ul>

            <a href="javascript:;" name="filterGbCd" value="14">두께<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '03' }">
                    <code:checkboxFLT name="glassThickCd" codeGrp="GLASS_THICK_CD" idPrefix="glassThickCd" value="${so.glassThickCd}"/>
                </c:if>
            </ul>
            </div>
            
            <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="13">설계<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '03' }">
                    <code:checkboxFLT name="glassDesignCd" codeGrp="GLASS_DESIGN_CD" idPrefix="glassDesignCd" value="${so.glassDesignCd}"/>
                </c:if>
            </ul>
            </div>
        </c:if>

        <%-- 보청기 --%>
        <c:if test="${category_info.filterTypeCd eq '05'}">
    <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="18">형태/크기<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '05' }">
                    <code:checkboxFLT name="aidShapeCd" codeGrp="AID_SHAPE_CD" idPrefix="aidShapeCd" value="${so.aidShapeCd}"/>
                </c:if>
            </ul>

            <a href="javascript:;" name="filterGbCd" value="18">난청유형<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '05' }">
                    <code:checkboxFLT name="aidLosstypeCd" codeGrp="AID_LOSSTYPE_CD" idPrefix="aidLosstypeCd" value="${so.aidLosstypeCd}"/>
                </c:if>
            </ul>
    </div>
    <div class="filter_row">
            <a href="javascript:;" name="filterGbCd" value="18">난청정도<span>더보기</span></a>
            <ul class="filter_list" style="display: none;">
                <c:if test="${category_info.filterTypeCd eq '05' }">
                    <code:checkboxFLT name="aidLossdegreeCd" codeGrp="AID_LOSSDEGREE_CD" idPrefix="aidLossdegreeCd" value="${so.aidLossdegreeCd}"/>
                </c:if>
            </ul>
    </div>
        </c:if>		
		<div class="btn_filter_area">
			<button type="button" class="btn_refresh">초기화</button>
			<button type="button" class="btn_good_search">찾기<i></i></button>
		</div>		
		<div class="filter_tag">
			<%--#브랜드, #빨강, #아세테이트, #브랜드, #빨강--%>
		</div>
	</div>
</div>


    <!--div class="mid">
        <%--<button type="button" class="btn_view_filter">Filter<i></i></button>--%>
        <div class="check_area">
            <input type="checkbox" name="filterGbCd" id="check_01" class="filter_check" value="01" >
            <label for="check_01">브랜드<span></span></label>

            <input type="checkbox" name="filterGbCd" id="check_02" class="filter_check" value="02">
            <label for="check_02">가격<span></span></label>

            <%--  안경테 , 선글라스 , 안경렌즈 , 콘택트렌즈 --%>
            <c:if test="${category_info.filterTypeCd ne '05'}">
                <input type="checkbox" name="filterGbCd" id="check_03" class="filter_check" value="03">
                <label for="check_03">색상<span></span></label>
            </c:if>

            <%--  안경테 , 선글라스 --%>
            <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02'}">
                <input type="checkbox" name="filterGbCd" id="check_04" class="filter_check" value="04">
                <label for="check_04">모양<span></span></label>
            </c:if>

            <%--  안경테 , 선글라스 ,콘택트렌즈 --%>
            <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02' || category_info.filterTypeCd eq '04'}">
                <input type="checkbox" name="filterGbCd" id="check_05" class="filter_check" value="05">
                <label for="check_05">재질<span></span></label>
            </c:if>

            <%--  안경테 --%>
            <c:if test="${category_info.filterTypeCd eq '01'}">
                <input type="checkbox" name="filterGbCd" id="check_06" class="filter_check" value="06">
                <label for="check_06">사이즈<span></span></label>
            </c:if>

            <%-- 선글라스 --%>
            <c:if test="${category_info.filterTypeCd eq '02'}">
                <input type="checkbox" name="filterGbCd" id="check_07" class="filter_check" value="07">
                <label for="check_06">안구색상(상단)<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_08" class="filter_check" value="08">
                <label for="check_07">안구색상(메탈전체)<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_09" class="filter_check" value="09">
                <label for="check_08">다리색상(홈선에폭시)<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_10" class="filter_check" value="10">
                <label for="check_09">팁색상<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_11" class="filter_check" value="11">
                <label for="check_10">렌즈색상<span></span></label>
            </c:if>

            <%-- 안경렌즈 --%>
            <c:if test="${category_info.filterTypeCd eq '03'}">
                <input type="checkbox" name="filterGbCd" id="check_12" class="filter_check" value="12">
                <label for="check_11">용도<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_13" class="filter_check" value="13">
                <label for="check_12">초점<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_14" class="filter_check" value="14">
                <label for="check_13">기능<span></span></label>
            </c:if>

            <%-- 콘택트렌즈 --%>
            <c:if test="${category_info.filterTypeCd eq '04'}">
                <input type="checkbox" name="filterGbCd" id="check_15" class="filter_check" value="15">
                <label for="check_14">착용주기<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_16" class="filter_check" value="16">
                <label for="check_15">초점<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_17" class="filter_check" value="17">
                <label for="check_16">그래픽사이즈<span></span></label>
            </c:if>

            <%-- 보청기 --%>
            <c:if test="${category_info.filterTypeCd eq '05'}">
                <input type="checkbox" name="filterGbCd" id="check_18" class="filter_check" value="18">
                <label for="check_17">형태/크기<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_19" class="filter_check" value="19">
                <label for="check_18">난청유형<span></span></label>
                <input type="checkbox" name="filterGbCd" id="check_20" class="filter_check" value="20">
                <label for="check_19">난청정도<span></span></label>
            </c:if>

        </div>
    </div>
    <!-- 필터 상세 -->
    <!--div class="filter_detail_area">
        <ul class="list">
            <li style="display: none;" id="filterLayer_01">
                <div class="title_area"><h4 class="filter_tit">브랜드</h4></div>
                <ul class="right_check">
                    <c:forEach var="brandList" items="${brand_list}" varStatus="bstatus">
                        <li>
                            <input type="checkbox" id="check_brand0${bstatus.index+1}" name="searchBrands" class="brand_check" value="${brandList.brandNo}"
                            <c:forEach var="selectbrandList" items="${so.searchBrands}" varStatus="status">
                                   <c:if test="${brandList.brandNo eq selectbrandList }">checked="checked"</c:if>
                            </c:forEach>
                            >
                            <label for="check_brand0${bstatus.index+1}"><span></span>${brandList.brandNm}</label>
                        </li>
                    </c:forEach>
                </ul>
            </li>

            <li>
                <%-- 안경테 , 선글라스 , 안경렌즈 , 콘택트렌즈 --%>
                <c:if test="${category_info.filterTypeCd ne '05'}">
                    <div class="color_area"  style="display: none;" id="filterLayer_03">
                        <h4 class="filter_tit">색상</h4>
                        <div class="color_pick">

                            <%-- 안경테 --%>
                            <c:if test="${category_info.filterTypeCd eq '01'}">
                                <input type="hidden" name="frameColorCd" value="${so.frameColorCd}"/>
                                <code:color name="frameColorCd" codeGrp="FRAME_COLOR_CD" idPrefix="frameColorCd" value="${so.frameColorCd}"/>
                            </c:if>
                                <%-- 선글라스 --%>
                            <c:if test="${category_info.filterTypeCd eq '02'}">
                                <input type="hidden" name="sunglassColorCd" value="${so.sunglassColorCd}"/>
                                <code:color name="sunglassColorCd" codeGrp="SUNGLASS_COLOR_CD" idPrefix="sunglassColorCd" value="${so.sunglassColorCd}"/>
                            </c:if>
                                <%-- 안경렌즈 --%>
                            <c:if test="${category_info.filterTypeCd eq '03'}">
                                <input type="hidden" name="glassColorCd" value="${so.glassColorCd}"/>
                                <code:color name="glassColorCd" codeGrp="GLASS_COLOR_CD" idPrefix="glassColorCd" value="${so.glassColorCd}"/>
                            </c:if>
                                <%-- 콘택트렌즈 --%>
                            <c:if test="${category_info.filterTypeCd eq '04'}">
                                <input type="hidden" name="contactColorCd" value="${so.contactColorCd}"/>
                                <code:color name="contactColorCd" codeGrp="CONTACT_COLOR_CD" idPrefix="contactColorCd" value="${so.contactColorCd}"/>
                            </c:if>
                        </div>
                    </div>
                </c:if>
                <%-- 안경테 , 선글라스--%>
                <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02' }">
                    <div class="detail_area" style="display: none;" id="filterLayer_04">
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

                <%-- 안경테 , 선글라스 , 콘택트렌즈 --%>
                <c:if test="${category_info.filterTypeCd eq '01' || category_info.filterTypeCd eq '02' || category_info.filterTypeCd eq '04'}">
                    <div class="detail_area" style="display: none;" id="filterLayer_05">
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
                <%-- 안경테  --%>
                <c:if test="${category_info.filterTypeCd eq '01'}">
                    <div class="detail_area" style="display: none;" id="filterLayer_06">
                        <h4 class="filter_tit">사이즈</h4>
                        <ul class="detail_check_list">
                            <c:if test="${category_info.filterTypeCd eq '01' }">
                                <code:checkboxFLT name="frameSizeCd" codeGrp="FRAME_SIZE_CD" idPrefix="frameSizeCd" value="${so.frameSizeCd}"/>
                            </c:if>
                        </ul>
                    </div>
                </c:if>
            </li>
            <li style="display: none;" id="filterLayer_02">
                <div class="title_area"><h4 class="filter_tit">가격</h4></div>
                <input type="text" class="form_price numeric comma" name="stPrice" value="${so.stPrice}"><span class="label_won">원</span> ~
                <input type="text" class="form_price numeric comma" name="endPrice" value="${so.endPrice}"><span class="label_won">원</span>
                <div class="bar_select" id="slider-range">
                    <p style="width:0%"></p>
                </div>
            </li>
        </ul>
        <div class="btn_filter_area">
            <button type="button" class="btn_refresh">초기화</button>
            <button type="button" class="btn_good_search">찾기<i></i></button>
        </div>
    </div-->
    <!--// 필터 상세 -->



