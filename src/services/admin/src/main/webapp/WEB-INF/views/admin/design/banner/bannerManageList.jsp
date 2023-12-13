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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; 배너 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            jQuery(document).ready(function() {
                var typeCd = "${so.typeCd}";
                var selected;

                if (typeCd === "top" || typeCd === "goodsTop" || typeCd === "goodsBottom") {
                    $("#goodsTypeCd").val("")
                }
                // 리스트 조회
                var bannerSet = {
                    bannerList : [],
                    getBannerList : function() {
                        var url = '/admin/design/banner-list',dfd = jQuery.Deferred();
                        var param = jQuery('#form_id_search').serialize();

                        console.log("param = ", param);
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            var template1;
                            var template2;
                            var template3;
                            console.log("result = ", result);
                            if (typeCd === "goodsTop" || typeCd === "goodsBottom") {
                                template1 =
                                            '<tr data-banner-no = "{{bannerNo}}" >' +
                                                '<td>' +
                                                '    <label for="chkBannerNo_{{bannerNo}}" class="chack"> ' +
                                                '    <span class="ico_comm"><input type="checkbox" name="chkBannerNo" id="chkBannerNo_{{bannerNo}}"  value="{{bannerNo}}"/></span></label>' +
                                                '</td>' +
                                                '<td>{{rownum}}</td>';
                                template2 =     '<td></td>';
                                template3 =     '<td><a href="#none" class="btn_id_detail">{{bannerNm}}</a></td>' +
                                                '<td>{{regDttm}}<input type="hidden" name="filePath" id="filePath_{{bannerNo}}" value="{{filePath}}" /></td>' +
                                                '<td><button class="btn_gray" onClick="javascript:fn_goods_list_Popup(\'{{bannerNo}}\')">상품 목록</button></td>' +
                                            '</tr>';
                            } else if (typeCd === "main") {
                                template1 =
                                            '<tr data-banner-no = "{{bannerNo}}" >' +
                                                '<input type="hidden" name="sortSeq" value="{{sortSeq}}">' +
                                            '   <td>' +
                                            '       <label for="chkBannerNo_{{bannerNo}}" class="chack"> ' +
                                            '       <span class="ico_comm"><input type="checkbox" name="chkBannerNo" id="chkBannerNo_{{bannerNo}}"  value="{{bannerNo}}"/></span></label>' +
                                            '   </td>' +
                                            '   <td><a href="#none" class="btn_id_detail">{{rownum}}</a></td>' +
                                            '   <td>{{bannerNm}}</td>' +
                                            '   <td>{{dispYnNm}}</td>';
                                template2 = '   <td></td>';
                                template3 = '   <td>{{regDttm}}<input type="hidden" name="filePath" id="filePath_{{bannerNo}}" value="{{filePath}}" /></td>' +
                                            '   <td>' +
                                                    '<button class="order_up_btn">상단1칸이동</button><span class="">|</span><button class="order_down_btn">하단1칸이동</button>' +
                                            '   </td>' +
                                            '</tr>';
                            } else if (typeCd === 'sub') {
                                template1 =
                                    '<tr data-banner-no = "{{bannerNo}}" >' +
                                    '<input type="hidden" name="sortSeq" value="{{sortSeq}}">' +
                                    '   <td>' +
                                    '       <label for="chkBannerNo_{{bannerNo}}" class="chack"> ' +
                                    '       <span class="ico_comm"><input type="checkbox" name="chkBannerNo" id="chkBannerNo_{{bannerNo}}"  value="{{bannerNo}}"/></span></label>' +
                                    '   </td>' +
                                    '   <td>{{rownum}}</td>' +
                                    '   <td><a href="#none" class="btn_id_detail">{{bannerNm}}</a></td>' +
                                    '   <td>{{dispYnNm}}</td>';
                                template2 = '   <td></td>';
                                template3 = '   <td>{{regDttm}}<input type="hidden" name="filePath" id="filePath_{{bannerNo}}" value="{{filePath}}" /></td>' +
                                    '   <td>' +
                                    '<button class="order_up_btn">상단1칸이동</button><span class="">|</span><button class="order_down_btn">하단1칸이동</button>' +
                                    '   </td>' +
                                    '</tr>';
                            } else {
                                template1 =
                                    '<tr data-banner-no = "{{bannerNo}}" >' +
                                    '<td>' +
                                    '    <label for="chkBannerNo_{{bannerNo}}" class="chack"> ' +
                                    '    <span class="ico_comm"><input type="checkbox" name="chkBannerNo" id="chkBannerNo_{{bannerNo}}"  value="{{bannerNo}}"/></span></label>' +
                                    '</td>' +
                                    '<td>{{rownum}}</td>' +
                                    '<td><a href="#none" class="btn_id_detail">{{bannerNm}}</a></td>' +
                                    '<td>{{dispYnNm}}</td>';
                                template2 = '<td></td>';
                                template3 = '<td>{{regDttm}}<input type="hidden" name="filePath" id="filePath_{{bannerNo}}" value="{{filePath}}" /></td>' +
                                    '</tr>';
                            }

                            managerTemplate1 = new Dmall.Template(template1),
                            managerTemplate3 = new Dmall.Template(template3),
                            tr = '';

                            jQuery.each(result.resultList, function(idx, obj) {
                                tr += managerTemplate1.render(obj);
                                //console.log("obj.applyAlwaysYn = ", obj.applyAlwaysYn);
                                if (typeCd === "goodsTop" || typeCd === "goodsBottom") {
                                    if (obj.goodsTypeCd != null && obj.goodsTypeCd == "01") {
                                        template2 = '<td>안경테</td>';
                                    } else if (obj.goodsTypeCd != null && obj.goodsTypeCd == "02") {
                                        template2 = '<td>선글라스</td>';
                                    } else if (obj.goodsTypeCd != null && obj.goodsTypeCd == "03") {
                                        template2 = '<td>안경렌즈</td>';
                                    } else if (obj.goodsTypeCd != null && obj.goodsTypeCd == "04") {
                                        template2 = '<td>콘택트렌즈</td>';
                                    } else {
                                        template2 = '<td>소모품</td>';
                                    }
                                } else {
                                    if (obj.applyAlwaysYn != null && obj.applyAlwaysYn == "Y") {
                                        template2 = '<td>무제한</td>';
                                    } else {
                                        template2 = '<td>{{dispStartDttmView}} ~ {{dispEndDttmView}}</td>';
                                    }
                                }
                                managerTemplate2 = new Dmall.Template(template2),
                                tr += managerTemplate2.render(obj);
                                tr += managerTemplate3.render(obj);
                            });

                            if(tr == '') {
                                tr = '<tr><td colspan="11">데이터가 없습니다.</td></tr>';
                            }
                            if(typeCd === "top" || typeCd === "goodsTop" || typeCd === "goodsBottom") {
                                jQuery("#tbody_id_bannerTopGoodsList").html(tr);
                            } else {
                                if (clickText == "안경테") {
                                    jQuery("#tbody_id_bannerGlassFrameList").html(tr);
                                } else if (clickText == "선글라스") {
                                    jQuery("#tbody_id_bannerSunGlassList").html(tr);
                                } else if (clickText == "콘택트렌즈") {
                                    jQuery("#tbody_id_bannerContactList").html(tr);
                                } else {
                                    jQuery("#tbody_id_bannerLensList").html(tr);
                                }
                            }
                            //jQuery('#tbody_id_bannerList').html(tr);
                            bannerSet.bannerList = result.resultList;
                            dfd.resolve(result.resultList);
                            if(typeCd === 'top' || typeCd === "goodsTop" || typeCd === "goodsBottom") {
                                Dmall.GridUtil.appendPaging('form_id_search', 'div_id_topGoods_paging', result, 'paging_id_topGoods_banner', bannerSet.getBannerList);
                                $("#a_topGoods").text(result.filterdRows);
                            } else {
                                if (clickText == "안경테") {
                                    Dmall.GridUtil.appendPaging('form_id_search', 'div_id_glassFrame_paging', result, 'paging_id_glassFrame_banner', bannerSet.getBannerList);
                                    $("#a_glassFrame").text(result.filterdRows);
                                } else if (clickText == "선글라스") {
                                    Dmall.GridUtil.appendPaging("form_id_search", "div_id_sunGlass_paging", result, "paging_id_sunGlass_banner", bannerSet.getBannerList);
                                    $("#a_sunGlass").text(result.filterdRows);
                                } else if (clickText == "콘택트렌즈") {
                                    Dmall.GridUtil.appendPaging("form_id_search", "div_id_contact_paging", result, "paging_id_contact_banner", bannerSet.getBannerList);
                                    $("#a_contact").text(result.filterdRows);
                                } else {
                                    Dmall.GridUtil.appendPaging("form_id_search", "div_id_lens_paging", result, "paging_id_lens_banner", bannerSet.getBannerList);
                                    $("#a_lens").text(result.filterdRows);
                                }
                            }

                            
                            //$("#a").text(result.filterdRows);
                        });

                        return dfd.promise();
                    }
                }
                
                // 검색
                jQuery('#btn_id_search').on('click', bannerSet.getBannerList);
                
                // 로딩시 자동검색 기능
                bannerSet.getBannerList();

                // 상세
                jQuery(document).on('click', '#tbody_id_bannerTopGoodsList a.btn_id_detail', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bannerNo = jQuery(this).parents('tr').data('banner-no');
                    Dmall.FormUtil.submit('/admin/design/banner-detail', {bannerNo : bannerNo, typeCd : '${so.typeCd}', bannerMenuCd : '${so.bannerMenuCd}', bannerAreaCd : '${so.bannerAreaCd}'}, "_blank");
                    //window.open("/admin/design/banner-detail?bannerNo=" + bannerNo + "&typeCd = '${so.typeCd}'&bannerMenuCd = '${so.bannerMenuCd}'&bannerAreaCd = '${so.bannerAreaCd}'", "_blank");
                });
                jQuery(document).on('click', '#tbody_id_bannerGlassFrameList a.btn_id_detail', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bannerNo = jQuery(this).parents('tr').data('banner-no');
                    Dmall.FormUtil.submit('/admin/design/banner-detail', {bannerNo : bannerNo, typeCd : '${so.typeCd}', bannerMenuCd : '${so.bannerMenuCd}', bannerAreaCd : '${so.bannerAreaCd}'}, "_blank");
                    //window.open("/admin/design/banner-detail?bannerNo=" + bannerNo + "&typeCd = '${so.typeCd}'&bannerMenuCd = '${so.bannerMenuCd}'&bannerAreaCd = '${so.bannerAreaCd}'", "_blank");
                });
                jQuery(document).on('click', '#tbody_id_bannerSunGlassList a.btn_id_detail', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bannerNo = jQuery(this).parents('tr').data('banner-no');
                    Dmall.FormUtil.submit('/admin/design/banner-detail', {bannerNo : bannerNo, typeCd : '${so.typeCd}', bannerMenuCd : '${so.bannerMenuCd}', bannerAreaCd : '${so.bannerAreaCd}'}, "_blank");
                    //window.open("/admin/design/banner-detail?bannerNo=" + bannerNo, "_blank");
                });
                jQuery(document).on('click', '#tbody_id_bannerContactList a.btn_id_detail', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bannerNo = jQuery(this).parents('tr').data('banner-no');
                    Dmall.FormUtil.submit('/admin/design/banner-detail', {bannerNo : bannerNo, typeCd : '${so.typeCd}', bannerMenuCd : '${so.bannerMenuCd}', bannerAreaCd : '${so.bannerAreaCd}'}, "_blank");
                    //window.open("/admin/design/banner-detail?bannerNo=" + bannerNo, "_blank");
                });
                jQuery(document).on('click', '#tbody_id_bannerLensList a.btn_id_detail', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var bannerNo = jQuery(this).parents('tr').data('banner-no');
                    Dmall.FormUtil.submit('/admin/design/banner-detail', {bannerNo : bannerNo, typeCd : '${so.typeCd}', bannerMenuCd : '${so.bannerMenuCd}', bannerAreaCd : '${so.bannerAreaCd}'}, "_blank");
                    //window.open("/admin/design/banner-detail?bannerNo=" + bannerNo, "_blank");
                });
                
                // 등록 화면
                jQuery('#btn_id_save').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var goodsTypeCd;
                    $('div.sub_tab').find('li.on').each(function (idx, obj) {
                        goodsTypeCd = $(obj).attr('id');
                    });
                    //console.log("goodsTypeCd = ", goodsTypeCd);
                    Dmall.FormUtil.submit('/admin/design/banner-detail-new', {typeCd : '${so.typeCd}', bannerMenuCd : '${so.bannerMenuCd}', bannerAreaCd : '${so.bannerAreaCd}', goodsTypeCd : goodsTypeCd});
                });
                
                // 전시 처리
                jQuery('#btn_id_view').on('click', function(e) {
                    selected = fn_selectedList();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 배너의 전시 상태로 변경하시겠습니까?', function() {
                            var url = '/admin/design/banner-view-update',
                                    param = {},
                                    key,
                                    selected = fn_selectedList();

                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].bannerNo';
                                    param[key] = o;
                                    key = 'list[' + i + '].dispYn';
                                    param[key] = "Y";
                                });            

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    //getSearchGoodsData();
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    //jQuery('#form_id_search').submit();
                                    bannerSet.getBannerList();
                                });
                        });
                    }
                });
                
                // 미전시 처리
                jQuery('#btn_id_notView').on('click', function(e) {
                    selected = fn_selectedList();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 배너의 미전시 상태로 변경하시겠습니까?', function() {
                            var url = '/admin/design/banner-view-update',
                                    param = {},
                                    key,
                                    selected = fn_selectedList();

                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].bannerNo';
                                    param[key] = o;
                                    key = 'list[' + i + '].dispYn';
                                    param[key] = "N";
                                });            

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    //getSearchGoodsData();
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    //jQuery('#form_id_search').submit();
                                    bannerSet.getBannerList();
                                });
                        });
                    }
                });

                // 상단 이동
                $(document).on('click', 'button.order_up_btn', function() {
                    if(!$(this).closest('tr').prev().is('tr')) {
                        return;
                    }

                    var orgSortSeq = $(this).closest('tr').find('input:hidden[name=sortSeq]').val();
                    var sortSeq = $(this).closest('tr').prev().find('input:hidden[name=sortSeq]').val();
                    var orgBannerNo = $(this).closest('tr').find('input[type=checkbox]').val();
                    var bannerNo = $(this).closest('tr').prev().find('input[type=checkbox]').val();

                    var url = '/admin/design/banner-sort-update',
                        param = {orgSortSeq: orgSortSeq,
                            sortSeq: sortSeq,
                            orgBannerNo: orgBannerNo,
                            bannerNo: bannerNo};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        bannerSet.getBannerList();
                    });
                });

                // 하단 이동
                $(document).on('click', 'button.order_down_btn', function() {
                    if(!$(this).closest('tr').next().is('tr')) {
                        return;
                    }

                    var orgSortSeq = $(this).closest('tr').find('input:hidden[name=sortSeq]').val();
                    var sortSeq = $(this).closest('tr').next().find('input:hidden[name=sortSeq]').val();
                    var orgBannerNo = $(this).closest('tr').find('input[type=checkbox]').val();
                    var bannerNo = $(this).closest('tr').next().find('input[type=checkbox]').val();

                    var url = '/admin/design/banner-sort-update',
                        param = {orgSortSeq: orgSortSeq,
                            sortSeq: sortSeq,
                            orgBannerNo: orgBannerNo,
                            bannerNo: bannerNo};

                    console.log("param = ", param);
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        bannerSet.getBannerList();
                    });
                });

                /*// 순서변경 처리
                jQuery('#btn_id_sortSeq').on('click', function(e) {
                    selected = fn_selectedList();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 배너 순번을 변경하시겠습니까?', function() {
                            var url = '/admin/design/banner-sort-update',
                                    param = {},
                                    key,
                                    selected = fn_selectedList();

                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].bannerNo';
                                    param[key] = o;
                                    key = 'list[' + i + '].sortSeq';
                                    param[key] = jQuery('#sortSeq_'+o).val();
                                });            

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    //getSearchGoodsData();
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    //jQuery('#form_id_search').submit();
                                    bannerSet.getBannerList();
                                });
                        });
                    }
                });*/
                
                // 삭제 처리
                jQuery('#btn_id_delete').on('click', function(e) {
                    selected = fn_selectedList();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 배너를 삭제하시겠습니까?', function() {
                            var url = '/admin/design/banner-delete',
                                    param = {},
                                    key,
                                    selected = fn_selectedList();

                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].bannerNo';
                                    param[key] = o;
                                    key = 'list[' + i + '].fileNm';
                                    param[key] = jQuery('#fileNm_'+o).val();
                                    key = 'list[' + i + '].filePath';
                                    param[key] = jQuery('#filePath_'+o).val();
                                });            

                                console.log("param = ", param);
                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    //getSearchGoodsData();
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    //jQuery('#form_id_search').submit();
                                    bannerSet.getBannerList();
                                });
                        });
                    }
                });

                // 전체, PC, 모바일 선택 확인
                var clickText = "안경테";
                jQuery(".tab-2").click(function(){
                    clickText = jQuery(this).find("a").text();
                    if (clickText === "안경테") {
                        $("#goodsTypeCd").val("01")
                    } else if (clickText === "선글라스") {
                        $("#goodsTypeCd").val("02")
                    } else if (clickText === "안경렌즈") {
                        $("#goodsTypeCd").val("03")
                    } else {
                        $("#goodsTypeCd").val("04")
                    }
                    jQuery('#btn_id_search').trigger('click');
                    //jQuery('#btn_id_search').on('click', bannerSet.getBannerList);
                });
                //jQuery('#grid_id_popupList').grid(jQuery('#form_id_search'));
            });
            
            // 선택된값 체크
            function fn_selectedList() {
                var selected = [];
                
                $("input[name='chkBannerNo']:checked").each(function() {
                    selected.push($(this).val());     // 체크된 것만 값을 뽑아서 배열에 push
                });
                
                if (selected.length < 1) {
                    Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
                }
                return selected;
            }

            function fn_goods_list_Popup (bannerNo) {
                var url = '/admin/design/banner-goods-list?bannerNo=' + bannerNo;
                Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_list'));

                GoodsListPopup._init( url );
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- content -->
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    디자인 설정<span class="step_bar">
                    <c:if test="${so.typeCd eq 'main'}">
                    </span>  메인 배너 관리 <span class="step_bar">
                    </c:if>
                    <c:if test="${so.typeCd eq 'sub'}">
                    </span>  서브 배너 관리 <span class="step_bar">
                    </c:if>
                    <c:if test="${so.typeCd eq 'top'}">
                    </span>  탑 배너 관리 <span class="step_bar">
                    </c:if>
                    <c:if test="${so.typeCd eq 'goodsTop'}">
                    </span>  상품 상단 배너 이미지 <span class="step_bar">
                    </c:if>
                    <c:if test="${so.typeCd eq 'goodsBottom'}">
                    </span>  상품 하단 배너 이미지 <span class="step_bar">
                    </c:if>
                </div>
                <c:if test="${so.typeCd eq 'main'}">
                    <h2 class="tlth2">메인 배너 관리</h2>
                </c:if>
                <c:if test="${so.typeCd eq 'sub'}">
                    <h2 class="tlth2">서브 배너 관리</h2>
                </c:if>
                <c:if test="${so.typeCd eq 'top'}">
                    <h2 class="tlth2">탑 배너 관리</h2>
                </c:if>
                <c:if test="${so.typeCd eq 'goodsTop'}">
                    <h2 class="tlth2">상품 상단 배너 이미지</h2>
                </c:if>
                <c:if test="${so.typeCd eq 'goodsBottom'}">
                    <h2 class="tlth2">상품 하단 배너 이미지</h2>
                </c:if>
            </div>
            <div class="search_box_wrap">
                <!-- search_box -->
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="search_id_page" />
                <form:hidden path="rows" />
                <input type="hidden" name="sort" value="" />
                <input type="hidden" name="pcGbCd" id="pcGbCd" value="C" />
                <input type="hidden" name="skinNo" id="skinNo" value="2" />
                <input type="hidden" name="bannerMenuCd" id="bannerMenuCd" value="${so.bannerMenuCd}" />
                <input type="hidden" name="bannerAreaCd" id="bannerAreaCd" value="${so.bannerAreaCd}" />
                <input type="hidden" name="goodsTypeCd" id="goodsTypeCd" value="01" />
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 배너 관리 검색 표 입니다. 구성은 스킨 검색, 메뉴 및 위치, 전시기간, 전시유형, 검색어 입니다.">
                            <caption>배너 관리 검색</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2">기간</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" fromValue="${so.fromRegDt}" toValue="${so.toRegDt}" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label for="applyAlwaysYn" class="chack mr20">
                                            <input type="checkbox" name="applyAlwaysYn" id="applyAlwaysYn" value="Y" class="blind" />
                                            <span class="ico_comm">&nbsp;</span>
                                            무제한
                                        </label>
                                    <td>
                                </tr>
                                <c:if test="${so.typeCd eq 'goodsTop' || so.typeCd eq 'goodsBottom'}">
                                <tr>
                                    <th>상품군</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>
                                        <c:if test="${so.typeCd eq 'goodsTop' || so.typeCd eq 'goodsBottom'}">
                                        <tags:checkboxs codeStr="01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;05:소모품" name="goodsTypeCds" idPrefix="goodsTypeCd"/>
                                        </c:if>
                                        <c:if test="${so.typeCd ne 'goodsTop' && so.typeCd ne 'goodsBottom'}">
                                        <tags:checkboxs codeStr="01:안경테;02:선글라스;03:안경렌즈;04:콘택트렌즈;" name="goodsTypeCds" idPrefix="goodsTypeCd"/>
                                        </c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품명</th>
                                    <td>
                                        <span class="intxt wid100p"><input type="text" value="" id="goodsNm" name="goodsNm"></span>
                                    </td>
                                </tr>
                                </c:if>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt wid100p"><input type="text" value="" id="bannerNm" name="bannerNm"></span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <a href="#none" class="btn green" id="btn_id_search">검색</a>
                    </div>
                </div>


                </form:form>
                <!-- //search_box -->
                <!-- line_box -->

                <div class="line_box pb">
                    <c:if test="${so.typeCd ne 'top' && so.typeCd ne 'goodsTop' && so.typeCd ne 'goodsBottom'}">
                        <div class="sub_tab tab_lay2">
                            <ul>
                                <li id="01" class="tab-2 mr20 on">
                                    <a href="#tab1"><span class="ico_comm"></span>안경테</a>
                                </li>
                                <li id="02" class="tab-2 mr20">
                                    <a href="#tab2"><span class="ico_comm"></span>선글라스</a>
                                </li>
                                <li id="03" class="tab-2 mr20">
                                    <a href="#tab3"><span class="ico_comm"></span>안경렌즈</a>
                                </li>
                                <li id="04" class="tab-2">
                                    <a href="#tab4"><span class="ico_comm"></span>콘택트렌즈</a>
                                </li>
                            </ul>
                        </div>
                        <div class="tab-2con" id="tab1" style="display: block;">
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <span class="search_txt">
                                      총 <strong class="be" id="a_glassFrame">0</strong>개의 게시물이 검색되었습니다.
                                    </span>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <!-- tblh -->
                            <div class="tblh">
                                <div class="scroll">
                                    <table summary="이표는 배너 관리 리스트 표 입니다. 구성은 체크박스, 순번, 적용스킨, 전시상태, 메뉴 및 위치, 프로모션ID, 프로모션 명, 시작 일시, *종료 일시, 등록자명(ID), 등록 일시, 수정일시 입니다." style="min-width: 0px">
                                        <caption>배너 관리 리스트</caption>
                                        <colgroup>
                                            <col width="5%">
                                            <col width="10%">
                                            <col width="25%">
                                            <col width="20%">
                                            <col width="10%">
                                            <col width="20%">
                                            <col width="10%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <label for="chack05" class="chack">
                                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05" class="blind" /></span>
                                                    </label>
                                                </th>
                                                <th>번호</th>
                                                <th>배너 제목</th>
                                                <th>사용여부</th>
                                                <th>기간</th>
                                                <th>작성일</th>
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tbody_id_bannerGlassFrameList">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <!-- //tblh -->

                            <!-- bottom_lay -->
                            <div class="bottom_lay">
                                <!-- pageing -->
                                <%-- <grid:paging resultListModel="${resultListModel}" /> --%>
                                 <div id="div_id_glassFrame_paging"></div>
                                <!-- //pageing -->
                            </div>
                            <!-- //bottom_lay -->
                        </div>
                        <div class="tab-2con" id="tab2" style="display: none;">
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <span class="search_txt">
                                      총 <strong class="be" id="a_sunGlass">0</strong>개의 게시물이 검색되었습니다.
                                    </span>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <!-- tblh -->
                            <div class="tblh">
                                <div class="scroll">
                                    <table summary="이표는 배너 관리 리스트 표 입니다. 구성은 체크박스, 순번, 적용스킨, 전시상태, 메뉴 및 위치, 프로모션ID, 프로모션 명, 시작 일시, *종료 일시, 등록자명(ID), 등록 일시, 수정일시 입니다." style="min-width: 0px">
                                        <caption>배너 관리 리스트</caption>
                                        <colgroup>
                                            <col width="5%">
                                            <col width="8%">
                                            <col width="25%">
                                            <col width="20%">
                                            <col width="10%">
                                            <col width="20%">
                                            <col width="15%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th><!--
                                                   <label for="chack05" class="chack" onclick="chack_btn(this);">
                                                       <span class="ico_comm"><input type="checkbox" name="table" id="chack05"  /></span>
                                                   </label>
                                                    -->
                                                    <label for="chack05" class="chack">
                                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05" class="blind" /></span>
                                                    </label>
                                                </th>
                                                <th>번호</th>
                                                <th>배너 제목</th>
                                                <th>사용여부</th>
                                                <th>기간</th>
                                                <th>작성일</th>
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tbody_id_bannerSunGlassList">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <!-- //tblh -->

                            <!-- bottom_lay -->
                            <div class="bottom_lay">
                                <div id="div_id_sunGlass_paging"></div>
                            </div>
                            <!-- //bottom_lay -->
                        </div>
                        <div class="tab-2con" id="tab3" style="display: none;">
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <span class="search_txt">
                                      총 <strong class="be" id="a_lens">0</strong>개의 게시물이 검색되었습니다.
                                    </span>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <!-- tblh -->
                            <div class="tblh">
                                <div class="scroll">
                                    <table summary="이표는 배너 관리 리스트 표 입니다. 구성은 체크박스, 순번, 적용스킨, 전시상태, 메뉴 및 위치, 프로모션ID, 프로모션 명, 시작 일시, *종료 일시, 등록자명(ID), 등록 일시, 수정일시 입니다." style="min-width: 0px">
                                        <caption>배너 관리 리스트</caption>
                                        <colgroup>
                                            <col width="5%">
                                            <col width="8%">
                                            <col width="25%">
                                            <col width="20%">
                                            <col width="10%">
                                            <col width="20%">
                                            <col width="15%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th><!--
                                                   <label for="chack05" class="chack" onclick="chack_btn(this);">
                                                       <span class="ico_comm"><input type="checkbox" name="table" id="chack05"  /></span>
                                                   </label>
                                                    -->
                                                    <label for="chack05" class="chack">
                                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05" class="blind" /></span>
                                                    </label>
                                                </th>
                                                <th>번호</th>
                                                <th>배너 제목</th>
                                                <th>사용여부</th>
                                                <th>기간</th>
                                                <th>작성일</th>
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tbody_id_bannerLensList">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <!-- //tblh -->

                            <!-- bottom_lay -->
                            <div class="bottom_lay">
                                <div id="div_id_lens_paging"></div>
                            </div>
                            <!-- //bottom_lay -->
                        </div>
                        <div class="tab-2con" id="tab4" style="display: none;">
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <span class="search_txt">
                                      총 <strong class="be" id="a_contact">0</strong>개의 게시물이 검색되었습니다.
                                    </span>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <!-- tblh -->
                            <div class="tblh">
                                <div class="scroll">
                                    <table summary="이표는 배너 관리 리스트 표 입니다. 구성은 체크박스, 순번, 적용스킨, 전시상태, 메뉴 및 위치, 프로모션ID, 프로모션 명, 시작 일시, *종료 일시, 등록자명(ID), 등록 일시, 수정일시 입니다." style="min-width: 0px">
                                        <caption>배너 관리 리스트</caption>
                                        <colgroup>
                                            <col width="5%">
                                            <col width="8%">
                                            <col width="25%">
                                            <col width="20%">
                                            <col width="10%">
                                            <col width="20%">
                                            <col width="15%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th><!--
                                                   <label for="chack05" class="chack" onclick="chack_btn(this);">
                                                       <span class="ico_comm"><input type="checkbox" name="table" id="chack05"  /></span>
                                                   </label>
                                                    -->
                                                    <label for="chack05" class="chack">
                                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05" class="blind" /></span>
                                                    </label>
                                                </th>
                                                <th>번호</th>
                                                <th>배너 제목</th>
                                                <th>사용여부</th>
                                                <th>기간</th>
                                                <th>작성일</th>
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tbody_id_bannerContactList">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <!-- //tblh -->

                            <!-- bottom_lay -->
                            <div class="bottom_lay">
                                <div id="div_id_contact_paging"></div>
                            </div>
                            <!-- //bottom_lay -->
                        </div>
                    </c:if>
                    <c:if test="${so.typeCd eq 'top' || so.typeCd eq 'goodsTop' || so.typeCd eq 'goodsBottom'}">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <span class="search_txt">
                                  총 <strong class="be" id="a_topGoods">0</strong>개의 게시물이 검색되었습니다.
                                </span>
                            </div>
                        </div>
                        <div style="clear: both;"></div>
                        <!-- tblh -->
                        <div class="tblh">
                            <div class="scroll">
                                <table summary="이표는 배너 관리 리스트 표 입니다. 구성은 체크박스, 순번, 적용스킨, 전시상태, 메뉴 및 위치, 프로모션ID, 프로모션 명, 시작 일시, *종료 일시, 등록자명(ID), 등록 일시, 수정일시 입니다." style="min-width: 0px">
                                    <caption>배너 관리 리스트</caption>
                                    <colgroup>
                                        <c:if test="${so.typeCd eq 'top'}">
                                            <col width="5%">
                                            <col width="8%">
                                            <col width="30%">
                                            <col width="20%">
                                            <col width="10%">
                                            <col width="20%">
                                        </c:if>
                                        <c:if test="${so.typeCd eq 'goodsTop' || so.typeCd eq 'goodsBottom'}">
                                            <col width="5%">
                                            <col width="8%">
                                            <col width="15%">
                                            <col width="35%">
                                            <col width="20%">
                                            <col width="15%">
                                        </c:if>
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>
                                                <label for="chack05" class="chack">
                                                    <span class="ico_comm"><input type="checkbox" name="table" id="chack05" class="blind" /></span>
                                                </label>
                                            </th>
                                            <c:if test="${so.typeCd eq 'top'}">
                                                <th>번호</th>
                                                <th>배너 제목</th>
                                                <th>사용여부</th>
                                                <th>기간</th>
                                                <th>작성일</th>
                                            </c:if>
                                            <c:if test="${so.typeCd eq 'goodsTop' || so.typeCd eq 'goodsBottom'}">
                                                <th>번호</th>
                                                <th>상품군</th>
                                                <th>배너 제목</th>
                                                <tH>작성일</tH>
                                                <th>관리</th>
                                            </c:if>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody_id_bannerTopGoodsList">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- //tblh -->

                        <!-- bottom_lay -->
                        <div class="bottom_lay">
                            <!-- pageing -->
                                <%-- <grid:paging resultListModel="${resultListModel}" /> --%>
                            <div id="div_id_topGoods_paging"></div>
                            <!-- //pageing -->
                        </div>
                    </c:if>
                </div>
                <!-- //line_box -->
                <!-- bottom_box -->
                <div class="bottom_box">
                    <div class="left">
                        <button class="btn--big btn--big-white" id="btn_id_delete">선택 삭제</button>
                        <!-- <button class="btn--big btn--big-white" id="btn_list">목록</button> -->
                    </div>
                    <div class="right">
                        <button class="btn--blue-round" id="btn_id_save">등록</button>
                        <!-- <button class="btn--blue-round" id="btn_save">저장</button> -->
                        <!-- <button class="btn--blue-round" id="btn_change">수정</button> -->
                    </div>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>
        <jsp:include page="/WEB-INF/include/popup/goodsListPopup.jsp" />
    <!-- //content -->
    </t:putAttribute>
</t:insertDefinition>