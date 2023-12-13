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
    <t:putAttribute name="title">브랜드관리</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/admin/css/dtree.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/js/dtree.js"></script>
        <script>
            $(document).ready(function() {
                // 브랜드 트리 초기화
                BrandUtil.init();

                // 브랜드 추가
                $('#brandInsBtn').on('click', function () {
                    Dmall.LayerPopupUtil.open($('#brand_pop'));
                });

                // 삭제
                $('#brandDelBtn').on('click', function () {
                    if(BrandUtil.selected == '') {
                        Dmall.LayerUtil.alert('선택된 브랜드가 없습니다.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('선택한 브랜드를 삭제하시겠습니까?', BrandUtil.deleteBrand);
                });

                // 저장
                $('#btn_regist').on('click', function() {
                    BrandUtil.updateBrand();
                });

                // 팝업 - 적용하기
                $('#btn_pop_insertbrand').on('click', function() {
                    BrandUtil.insertBrand();
                });
            });

            var d = new dTree('d');
            var BrandUtil = {
                selected: '',
                selectedObjId: '',
                init: function() {
                    d.add(0, -1, '브랜드');
                    <c:forEach var="brand" items="${resultListModel}" varStatus="status">
                        d.add('${status.count}', '0', '${brand.brandNm}', "BrandUtil.getBrandInfo(this, '${brand.brandNo}')");
                    </c:forEach>
                    $('#brandTree').html(''+d);
                },
                getBrandInfo: function(obj, brandNo) {
                    if(BrandUtil.selected == brandNo) {
                        return;
                    }
                    // 이전 체크값 reset
                    $('#td_goodsTypeCd').find('label').each(function() {
                        var $check = $(this);
                        if(($check.hasClass('on'))) {
                            $check.removeClass('on');
                            $check.find('input').prop('checked', false);
                        }
                    });

                    $('#'+ BrandUtil.selectedObjId).attr('class', 'node');
                    $(obj).attr('class', 'nodeSel');

                    BrandUtil.selected = brandNo;
                    BrandUtil.selectedObjId = $(obj).attr('id');

                    $('#hd_brandNo').val(brandNo);
                    $('#div_brand').show();

                    var url = '/admin/goods/brand',
                        param = {brandNo:brandNo};

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        // 사용여부 바인딩
                        $('input:radio[name=mainDispYn][value='+result.data.mainDispYn+']').trigger('click');
                        // 브랜드 명 바인딩
                        $('input:text[name=brandNm]').val(result.data.brandNm);
                        // 상품 수 바인딩
                        $('#td_regist_goods').text(result.data.brandGoodsCnt);
                        $('#td_sales_goods').text(result.data.brandSalesGoodsCnt);
                        // 상품유형 바인딩
                        if(result.data.goodsTypeCd != null) {
                            for(var goodsTypeCd of result.data.goodsTypeCd.split(',')) {
                                $('input:checkbox[name=goodsTypeCd][value='+goodsTypeCd+']').closest('label').trigger('click');
                            }
                        }

                        Dmall.common.comma();
                    });
                },
                insertBrand: function() {
                    var brandNm = $('#newBrandNm').val();
                    if(brandNm == '') {
                        Dmall.LayerUtil.alert('브랜드명을 입력하세요.');
                        return;
                    }

                    var url = '/admin/goods/brand-insert',
                        param = {newBrandNm: brandNm};

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if(result.success) {
                            location.reload();
                        }
                    });
                },
                deleteBrand: function() {
                    var url = '/admin/goods/brand-delete',
                        param = {brandNo: BrandUtil.selected};

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if(result.success) {
                            location.reload();
                        }
                    });
                },
                updateBrand: function() {
                    var goodsTypeCd = '';
                    $('input:checkbox[name=goodsTypeCd]:checked').each(function () {
                        goodsTypeCd += ($(this).val() + ',');
                    });
                    goodsTypeCd = goodsTypeCd.slice(0, -1);

                    var url = '/admin/goods/brand-update',
                        param = $('#form_brand').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            location.reload();
                        }
                    });
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">브랜드 관리</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri pb">
                <!-- brand_con -->
                <div class="cate_con">
                    <div class="cate_left">
                        <a href="#none" class="btn--white btn--icon" id="brandInsBtn">브랜드 추가</a>
                        <a href="#none" class="btn--white btn--small" id="brandDelBtn">삭제</a>
                        <span class="br2"></span>
                        <div class="left_con">
                            <div id="brandTree"></div>
                        </div>
                    </div>
                    <div class="cate_right">
                        <form action="" id="form_brand">
                            <input type="hidden" name="brandNo" id="hd_brandNo">
                            <div class="tblw tblmany" id="div_brand" style="display: none;">
                                <table>
                                    <colgroup>
                                        <col width="20%" />
                                        <col width="80%" />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>사용여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:사용;N:미사용" name="mainDispYn" idPrefix="mainDispYn" value="Y"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>브랜드 명</th>
                                        <td>
                                            <span class="intxt wid100p">
                                                <input type="text" name="brandNm" id="txt_brandNm">
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>브랜드 등록 상품 수</th>
                                        <td id="td_regist_goods" class="comma"></td>
                                    </tr>
                                    <tr>
                                        <th>브랜드 판매중 상품 수</th>
                                        <td id="td_sales_goods" class="comma"></td>
                                    </tr>
                                    <tr>
                                        <th>상품유형</th>
                                        <td id="td_goodsTypeCd">
                                            <tags:checkboxs codeStr="01:안경테;02:선글라스;04:콘택트렌즈;03:안경렌즈" name="goodsTypeCd" idPrefix="goodsTypeCd"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- //brand_con -->
            </div>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="btn_regist">저장</button>
                </div>
            </div>
        </div>

        <div id="brand_pop" class="slayer_popup" style="display: none">
            <div class="pop_wrap size1">
                <div class="pop_tlt">
                    <h2 class="tlth2">브랜드 추가</h2>
                    <button class="close ico_comm" id="btn_close_brandPop2">닫기</button>
                </div>
                <div class="pop_con">
                    <div class="brand">
                        <p class="message le">신규 브랜드 등록</p>
                        <div class="brand_name">
                            <label class="intxt">
                                <input type="text" name="newBrandNm" id="newBrandNm">
                            </label>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_pop_insertbrand">적용하기</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
