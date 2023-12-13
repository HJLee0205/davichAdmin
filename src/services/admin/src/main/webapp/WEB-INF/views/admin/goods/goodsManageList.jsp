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
<c:set var="menuType" value="${typeCd}"/>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">상품관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            var CATEGORY_MENU_NB = ${menuType};
            if(CATEGORY_MENU_NB == '5') {
                CATEGORY_MENU_NB = '1014';
            }
            jQuery(document).ready(function() {
                //location.reload();
                console.log("CATEGORY_MENU_NB = ", CATEGORY_MENU_NB);
                // 화면 초기화
                jQuery("#tr_goods_data_template").hide();
                jQuery('#tr_no_goods_data').show();
                getTopCategoryOptionValue('2', jQuery('#sel_ctg_2'));

                // 화면 이벤트 설정
                // 검색버튼
                jQuery('#btn_search').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    jQuery('#hd_page').val('1');
                    getSearchGoodsData();
                });
                // 상품등록 버튼
                jQuery('#btn_regist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_registGoods();
                });
                // 엑셀 다운로드 버튼
                jQuery('#btn_download').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_downloadExcel();
                });
                // 삭제 버튼
                jQuery('#btn_delete').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_delete();
                });
                // 품절 버튼
                jQuery('#btn_soldout').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_soldout();
                });
                // 판매중지 버튼
                jQuery('#btn_salestop').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    console.log("btn_salestop ======== ");
                    fn_salestop();
                });
                // 판매중 버튼
                jQuery('#btn_salestart').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_salestart();
                });
                // 카테고리1 변경시 이벤트
                jQuery('#sel_ctg_1').on('change', function(e) {
                    changeCategoryOptionValue('2', $(this));
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_ctg_2_def').focus();
                });
                // 카테고리2 변경시 이벤트
                jQuery('#sel_ctg_2').on('change', function(e) {
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_ctg_3_def').focus();
                });
                // 카테고리3 변경시 이벤트
                jQuery('#sel_ctg_3').on('change', function(e) {
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_ctg_4_def').focus();
                });
                // 정렬순서 변경 변경시 이벤트
                jQuery('#sel_sord').on('change', function(e) {
                    jQuery('#hd_srod').val($(this).val());
                    getSearchGoodsData();
                });
                // 표시갯수 변경 변경시 이벤트
                jQuery('#sel_rows').on('change', function(e) {
                    jQuery('#hd_page').val('1');
                    jQuery('#hd_rows').val($(this).val());
                    getSearchGoodsData();
                });

                jQuery(".all_choice").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var $chk = jQuery(this);
                    var id = $chk.attr('id');
                    //만약 전체 선택 체크박스가 체크된상태일경우
                    if( $chk.data("chacked") != 'on' ) {
                        $chk.addClass("on").data("chacked", "on");
                        $chk.siblings().addClass("on");
                        $chk.siblings('input').prop('checked', true);
                    // 전체선택 체크박스가 해제된 경우
                    } else {
                        $chk.removeClass("on").data("chacked", "off");
                        $chk.siblings().removeClass("on");
                        $chk.siblings('input').prop('checked', false);
                    }
                })

                // 엑셀 업로드
                jQuery('#btn_excelUp').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    excelUpload();
                });

                jQuery('#btn_excelSample').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    excelSample();
                });

                // 팝업 테스틍용 - 삭제대상
                jQuery('#btn_upload').off("click").on('click', function(e) {
                    Dmall.LayerPopupUtil.open($("#layer_upload_pop"));
                });

                // 상품등록(대량) 버튼 이벤트 설정
                jQuery('#btn_goods_regist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    location.href= "/admin/goods/goods-bulk-regist";
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_search').trigger('click') });

                // Validation 정의
                //Dmall.validate.set('form_id_cmnCdGrp');

                Dmall.common.comma();
                Dmall.common.date();

                jQuery('#sel_filter_type').on('change', function (e) {
                    changeFilterOptionValue($(this).val());
                });

                // 팝업 - 예상 배송 소요일 적용
                jQuery('#btn_regist_dlvr_date').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var selected = fn_selectedList();

                    if (selected) {
                        var dlvrExpectDays = $("#input_id_dlvrExpectDays").val();
                        if (!dlvrExpectDays) {
                            Dmall.LayerUtil.alert("예상 배송 소요일을 입력해주세요.");
                            return;
                        }
                        Dmall.LayerUtil.confirm('예상 배송 소요일을 변경하시겠습니까?', function() {
                            var url = '/admin/goods/dlvrExpectDays-update',
                                param = {},
                                key;

                            if (selected) {
                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].goodsNo';
                                    param[key] = o;

                                    key = 'list[' + i + '].dlvrExpectDays';
                                    param[key] = dlvrExpectDays;
                                });

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    Dmall.LayerPopupUtil.close('div_dlvr_date_confirm');
                                    getSearchGoodsData();
                                });
                            }
                        });
                    }
                });

                // 팝업 - 배송비 변경 적용
                jQuery('#btn_regist_dlvr_cost').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var selected = fn_selectedList();

                    if (selected) {
                        //console.log("selected = ", selected);
                        var dlvrSetCd = $("input:radio[name='dlvrSetCd']:checked").val();
                        var goodseachDlvrc = $("#goodseachDlvrc").val().replace(',','');
                        var goodseachcndtaddDlvrc = $("#goodseachcndtaddDlvrc").val().replace(',','');
                        var freeDlvrMinAmt = $("#freeDlvrMinAmt").val().replace(',','');
                        var packMaxUnit = $("#packMaxUnit").val().replace(',','');
                        var packUnitDlvrc = $("#packUnitDlvrc").val().replace(',','');
                        var couriDlvrApplyYn  = $('input:checkbox[name=couriDlvrApplyYn]').is(':checked');
                        var directRecptApplyYn  = $('input:checkbox[name=directRecptApplyYn]').is(':checked');

                        if (!dlvrSetCd) {
                            Dmall.LayerUtil.alert("배송비 정책을 선택해주세요.");
                            return false;
                        } else {
                            if (!couriDlvrApplyYn && !directRecptApplyYn) {
                                Dmall.LayerUtil.alert('요청상품 배송방법(택배배송 또는 직접수령)을 선택해 주세요.');
                                return false;
                            }
                        }

                        if ('3' === dlvrSetCd) {
                            if (goodseachDlvrc == '' || goodseachDlvrc == '0') {
                                Dmall.LayerUtil.alert('상품별 배송비 조건을 입력하세요.');
                                return false;
                            }
                        }

                        if ('6' === dlvrSetCd) {
                            if (goodseachcndtaddDlvrc == '' || goodseachcndtaddDlvrc == '0' || freeDlvrMinAmt == '' || freeDlvrMinAmt == '0') {
                                Dmall.LayerUtil.alert('상품별 배송비 조건을 입력하세요.');
                                return false;
                            }
                        }

                        if ('4' === dlvrSetCd) {
                            if (packMaxUnit == '' || packMaxUnit == '0' || packUnitDlvrc == '' || packUnitDlvrc == '0') {
                                Dmall.LayerUtil.alert('상품별 배송비 조건을 입력하세요.');
                                return false;
                            }
                        }

                        Dmall.LayerUtil.confirm('배송비 설정을 변경하시겠습니까?', function() {
                            var url = '/admin/goods/dlvrCost-update',
                                param = {},
                                key;

                            if (selected) {
                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].goodsNo';
                                    param[key] = o;

                                    key = 'list[' + i + '].dlvrSetCd';
                                    param[key] = dlvrSetCd;

                                    key = 'list[' + i + '].goodseachDlvrc';
                                    param[key] = goodseachDlvrc;

                                    key = 'list[' + i + '].goodseachcndtaddDlvrc';
                                    param[key] = goodseachcndtaddDlvrc;

                                    key = 'list[' + i + '].freeDlvrMinAmt';
                                    param[key] = freeDlvrMinAmt;

                                    key = 'list[' + i + '].packMaxUnit';
                                    param[key] = packMaxUnit;

                                    key = 'list[' + i + '].packUnitDlvrc';
                                    param[key] = packUnitDlvrc;

                                    key = 'list[' + i + '].couriDlvrApplyYn';
                                    param[key] = couriDlvrApplyYn ? "Y" : "N";

                                    key = 'list[' + i + '].directRecptApplyYn';
                                    param[key] = directRecptApplyYn ? "Y" : "N";
                                });
                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    Dmall.LayerPopupUtil.close('div_dlvr_cost_confirm');
                                    getSearchGoodsData();
                                });
                            }
                        });
                    }
                });

                // 팝업 - 이벤트 안내문 적용
                jQuery('#btn_regist_event_words').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var selected = fn_selectedList();
                    //console.log("selected = ", selected);

                    if (selected) {
                        var eventWords = $("#eventWords").val();
                        if (!eventWords) {
                            Dmall.LayerUtil.alert("이벤트 안내문을 입력해주세요.");
                            return;
                        }

                        Dmall.LayerUtil.confirm('이벤트 안내문을 변경하시겠습니까?', function() {
                            var url = '/admin/goods/eventWords-update',
                                param = {},
                                key;

                            //console.log("param = ", param);
                            if (selected) {
                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].goodsNo';
                                    param[key] = o;

                                    key = 'list[' + i + '].eventWords';
                                    param[key] = eventWords;

                                });

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    Dmall.LayerPopupUtil.close('event_words_change_popup');
                                    getSearchGoodsData();
                                });
                            }
                        });
                    }
                });

                // 팝업 - 판매가 변경 적용
                jQuery('#btn_regist_sale_price').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var selected = fn_selectedList();

                    //console.log("selected = ", selected);
                    if (selected) {
                        var dcPriceApplyAlwaysYn  = $('input:checkbox[name=saleForeverYn]').is(':checked');
                        var salePrice  = $("#salePrice").val();
                        var dcStartDttm  = $("#saleStartDt").val();
                        var dcEndDttm  = $("#saleEndDt").val();
                        if (!salePrice) {
                            Dmall.LayerUtil.alert("상품 판매가를 입력해주세요.");
                            return;
                        }
                        if (!dcPriceApplyAlwaysYn) {
                            if (dcStartDttm == '' || (dcStartDttm.length > 0 && !Dmall.validation.date(dcStartDttm))) {
                                Dmall.LayerUtil.alert('판매가 적용 시작일을 정확하게 입력해주세요.');
                                return false;
                            }
                            if (dcEndDttm == '' || (dcEndDttm.length > 0 && !Dmall.validation.date(dcEndDttm))) {
                                Dmall.LayerUtil.alert('판매가 적용 종료일을 정확하게 입력해주세요.');
                                return false;
                            }
                        }

                        Dmall.LayerUtil.confirm('상품 판매가를 변경하시겠습니까?', function() {
                            var url = '/admin/goods/salesPrice-update',
                                param = {},
                                key;

                            //console.log("param = ", param);
                            if (selected) {
                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].goodsNo';
                                    param[key] = o;

                                    key = 'list[' + i + '].salePrice';
                                    param[key] = salePrice;

                                    key = 'list[' + i + '].dcStartDttm';
                                    param[key] = dcStartDttm;

                                    key = 'list[' + i + '].dcEndDttm';
                                    param[key] = dcEndDttm;

                                    key = 'list[' + i + '].dcPriceApplyAlwaysYn';
                                    param[key] = dcPriceApplyAlwaysYn ? "Y" : "N";
                                });

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    if(result.success) {
                                        Dmall.LayerUtil.alert(result.message).done(function () {
                                            Dmall.LayerPopupUtil.close('sale_price_confirm_popup');
                                            getSearchGoodsData();
                                        });
                                    } else {
                                        Dmall.LayerUtil.alert(result.message);
                                    }
                                });
                            }
                        });
                    }
                });

                $('.btn_day', '#td_cal').on('click', function (e) {
                    var index = $(this).attr('id').split('_')[2];
                    $(this).closest('td').data('index', index);
                    $('#hd_calindex').val(index);
                });

                loadDefaultCondition();
            });

            // 하위 필터 정보 취득
            function changeFilterOptionValue(selectedFilterNo) {
                var url = '/admin/goods/goods-contact-filter-list',
                    param = {
                        'filterMenuLvl': "3",
                        'filterItemLvl': "4",
                        'filterNo': "4",
                        'goodsTypeCd': "04",
                        'selectedFilterNo': selectedFilterNo
                    },
                    dfd = jQuery.Deferred();

                console.log("param = ", param);
                Dmall.AjaxUtil.getJSON(url, param, function (result) {

                    $("#tbody_goods_search").find(".searchFilterResult").each(function() {
                        $(this).remove();
                    });
                    var template1 = '<td class="searchFilterResult">';
                    var template2 =     '<span class="select">' +
                                            '<label for="{{filterMenuType}}_{{id}}">{{text}}</label>' +
                                            '<select name="filters" id="{{filterMenuType}}_{{id}}">' +
                                                '<option value="" selected="selected">{{text}}</option>';
                    var template3 =             '<option id="opt_filter_{{id}}" value="{{id}}">{{text}}</option>';
                    var template4 =         '</select>' +
                                        '</span>';
                    var template5 = '</td>';
                        managerTemplate1 = new Dmall.Template(template1),
                            managerTemplate2 = new Dmall.Template(template2),
                            managerTemplate3 = new Dmall.Template(template3),
                            managerTemplate4 = new Dmall.Template(template4),
                            managerTemplate5 = new Dmall.Template(template5),
                        td = '';

                    td += managerTemplate1.render();
                    jQuery.each(result.resultList, function (idx, obj) {
                        if(obj.filterLvl === '3' && obj.goodsTypeCd === '${typeCd}') {
                            td += managerTemplate2.render(obj);
                        }
                        jQuery.each(result.resultList, function (idx2, obj2) {
                            if(obj2.parent === obj.id && obj2.filterLvl === '4') {
                                td += managerTemplate3.render(obj2);
                            }
                        });
                        td += managerTemplate4.render(obj);
                    });
                    td += managerTemplate5.render();
                    jQuery("#tr_filter_search").append(td);
                    dfd.resolve(result.resultList);

                });
                return dfd.promise();
            }

            // 기본 상태값 세팅...
            function loadDefaultCondition() {
                var cookie =  getCookie('SEARCH_GOODS_LIST');

                if (!cookie) {
                    // 검색일자 기본값 선택
                    jQuery('#btn_cal_3').trigger('click');
                    return;
                } else {
                    // var cookieObj =  JSON.parse(getCookie('SEARCH_GOODS_LIST'));
                    var cookieObj =  jQuery.parseJSON(cookie);
                    if (cookieObj['page']) {
                        $('#hd_page').val(cookieObj['page']);
                    }
                    // 상품 등록일
                    if (cookieObj['calindex']) {
                        $('#td_cal').data('index', cookieObj['calindex']);
                        $('#hd_calindex').val(cookieObj['calindex']);
                        $('#btn_cal_'+ cookieObj['calindex']).trigger('click');
                    }
                    if (cookieObj['searchDateFrom']) {
                        $('#txt_search_date_from').val(cookieObj['searchDateFrom']);
                    }
                    if (cookieObj['searchDateTo']) {
                        $('#txt_search_date_to').val(cookieObj['searchDateTo']);
                    }
                    // 카테고리
                    if (cookieObj['searchCtg2']) {
                        $('#sel_ctg_2').val(cookieObj['searchCtg2']);
                    }
                    if (cookieObj['searchCtg3']) {
                        $('#sel_ctg_3').val(cookieObj['searchCtg3']);
                    }
                    if (cookieObj['searchCtg4']) {
                        $('#sel_ctg_4').val(cookieObj['searchCtg4']);
                    }
                    // 필터
                    if (cookieObj['contfilter_sel']) {
                        $('#sel_filter_type').val(cookieObj['contfilter_sel']);
                    }
                    if (cookieObj['filters']) {
                        var $filterSelect = $('select[name=filters]');

                        $.each(cookieObj['filters'], function (idx, obj) {
                            $filterSelect.eq(idx).val(obj).prop('selected', true);
                        });
                    }
                    // 상품가격
                    if (cookieObj['searchPriceFrom']) {
                        $('#txt_search_price_from').val(cookieObj['searchPriceFrom']);
                    }
                    if (cookieObj['searchPriceTo']) {
                        $('#txt_search_price_to').val(cookieObj['searchPriceTo']);
                    }
                    // 상품유형
                    if (cookieObj['normalYn']) {
                        $('label[for=chack01_1]').trigger('click');
                    }
                    if (cookieObj['newGoodsYn']) {
                        $('label[for=chack01_2]').trigger('click');
                    }
                    if (cookieObj['stampYn']) {
                        $('label[for=chack01_3]').trigger('click');
                    }
                    if (cookieObj['mallOrderYn']) {
                        $('label[for=chack01_4]').trigger('click');
                    }
                    // 판매상태
                    if (cookieObj['goodsStatus']) {
                        if (cookieObj['goodsStatus'] instanceof Array) {
                            $.each(cookieObj['goodsStatus'], function(idx, obj) {
                                var id = $('input:checkbox[value='+ obj +']', '#td_goodsStatus').attr('id');
                                $('label[for='+ id +']', '#td_goodsStatus').toggleClass('on');
                                $('input:checkbox[value='+ obj +']', '#td_goodsStatus').prop("checked",true);
                            });
                        } else {
                            var id = $('input:checkbox[value='+ cookieObj['goodsStatus'] +']', '#td_goodsStatus').attr('id');
                            $('label[for='+ id +']', '#td_goodsStatus').toggleClass('on');
                            $('input:checkbox[value='+ cookieObj['goodsStatus'] +']', '#td_goodsStatus').prop("checked",true);
                        }
                    }
                    // 전시상태
                    if (cookieObj['goodsDisplay']) {
                        if (cookieObj['goodsDisplay'] instanceof Array) {
                            $.each(cookieObj['goodsDisplay'], function(idx, obj) {
                                var id = $('input:checkbox[value='+ obj +']', '#td_goodsDisplay').attr('id');
                                $('label[for='+ id +']', '#td_goodsDisplay').toggleClass('on');
                                $('input:checkbox[value='+ obj +']', '#td_goodsDisplay').prop("checked",true);
                            });
                        } else {
                            var id = $('input:checkbox[value='+ cookieObj['goodsDisplay'] +']', '#td_goodsDisplay').attr('id');
                            $('label[for='+ id +']', '#td_goodsDisplay').toggleClass('on');
                            $('input:checkbox[value='+ cookieObj['goodsDisplay'] +']', '#td_goodsDisplay').prop("checked",true);
                        }
                    }
                    // 판매자
                    if (cookieObj['searchSeller']) {
                        $('#sel_seller').val(cookieObj['searchSeller']);
                    }
                    // 다비젼상품코드
                    if (cookieObj['searchErpItmCd']) {
                        $('#txt_search_erp_itmcd').val(cookieObj['searchErpItmCd']);
                    }
                    // 검색어
                    if (cookieObj['searchWord']) {
                        $('#txt_search_word').val(cookieObj['searchWord']);
                    }

                    //loadCategoryOptionValue('1', jQuery('#sel_ctg_1'), '', $('#sel_ctg_1').data('searchCtgNo'));

                    if('${viewList}') {
                        getSearchGoodsData();
                    }
                }
            }

            // 상품 팝업 리턴 콜백함수 - 테스트용
            function fn_callback_pop_goods(data) {
                alert('상품 선택 팝업 리턴 결과 :' + data["goodsNo"] + ', data :' + JSON.stringify(data));
            }

            // 상품 등록
            function fn_registGoods() {
                // alert('미구현 기능 - 상품등록 (상품상세화면)');
                location.href= "/admin/goods/goods-detail?typeCd=" + $('#menu_type').val();
            }

            // 엑셀 다운로드
            function fn_downloadExcel() {
                // alert('미구현 기능 - 엑셀 다운로드');
                // 초기화
                jQuery('#form_id_search').attr('action', '/admin/goods/download-excel');
                // Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    // Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                    jQuery('#form_id_search').submit();
                // });
            }

            // 상품삭제
            function fn_delete() {
                var selected = fn_selectedList();
                if (selected) {
                    Dmall.LayerUtil.confirm('선택된 상품을 삭제 하시겠습니까?', function() {
                        var url = '/admin/goods/goods-delete',
                            param = {},
                            key;

                        if (selected) {
                            jQuery.each(selected, function(i, o) {
                                key = 'list[' + i + '].goodsNo';
                                param[key] = o;
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                getSearchGoodsData();
                            });
                        }
                    });
                }
            }

            // 품절처리
            function fn_soldout() {
                var selected = fn_selectedList();
                if (selected) {
                    Dmall.LayerUtil.confirm('상품의 판매 상태를 품절로 변경하시겠습니까?', function() {
                        var url = '/admin/goods/soldout-update',
                            param = {},
                            key;

                        if (selected) {
                            jQuery.each(selected, function(i, o) {
                                key = 'list[' + i + '].goodsNo';
                                param[key] = o;
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                getSearchGoodsData();
                            });
                        }
                    });
                }
            }

            // 판매중지
            function fn_salestop() {
                var selected = fn_selectedList();
                console.log("btn_salestop === selected = ", selected);
                if (selected) {
                    Dmall.LayerUtil.confirm('상품의 판매 상태를 판매중지로 변경하시겠습니까?', function() {
                        var url = '/admin/goods/salestop-update',
                            param = {},
                            key;

                        if (selected) {
                            jQuery.each(selected, function(i, o) {
                                key = 'list[' + i + '].goodsNo';
                                param[key] = o;
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                getSearchGoodsData();
                            });
                        }
                    });
                }
            }

            // 판매중
            function fn_salestart() {
                var selected = fn_selectedList();
                if (selected) {
                    Dmall.LayerUtil.confirm('상품의 판매 상태를 판매중으로 변경하시겠습니까?', function() {
                        var url = '/admin/goods/salestart-update',
                            param = {},
                            key;

                        if (selected) {
                            jQuery.each(selected, function(i, o) {
                                key = 'list[' + i + '].goodsNo';
                                param[key] = o;
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                getSearchGoodsData();
                            });
                        }
                    });
                }
            }

            // 화면에서 선택된 상품번호의 값 취득
            function fn_selectedList() {
                var selected = [];
                $('#tbody_goods_data input:checked').each(function() {
                    selected.push($(this).data('goodsNo'));
                });
                if (selected.length < 1) {
                    Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
                    return false;
                }
                return selected;
            }

            // 검색결과 취득
            function getSearchGoodsData() {
                // 초기화
                deleteCookie('SEARCH_GOODS_LIST');
                setDefaultValue();

                if ($('#td_cal').data('index') != null ) {
                    console.log($('#td_cal').data('index'));
                    $('#hd_calindex').val($('#td_cal').data('index'));
                }
                var url = '/admin/goods/goods-list',
                    param = $('#form_id_search').serialize();

                console.log("getSearchGoodsData param = ", param);
                var expdate = new Date();
                expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
                setCookie('SEARCH_GOODS_LIST', JSON.stringify($('#form_id_search').serializeObject()), expdate);

                Dmall.AjaxUtil.getJSON(url, param, function(result) {

                    if (result == null || result.success != true) {
                        return;
                    }

                    $("#cnt_search").html('0');
                    $("#tbody_goods_data").find(".searchGoodsResult").each(function() {
                        $(this).remove();
                    });

                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        setGoodsData(obj);
                    });

                    // 결과가 없을 경우 NO DATA 화면 처리
                    if ( $("#tbody_goods_data").find(".searchGoodsResult").length < 1 ) {
                        jQuery('#tr_no_goods_data').show();
                    } else {
                        jQuery('#tr_no_goods_data').hide();
                    }
                    // 검색결과 갯수 처리
                    var cnt_search = result["filterdRows"];
                    cnt_search = (null == cnt_search) ? 0 : cnt_search;
                    $("#cnt_search").html(cnt_search);
                    // 총 갯수 처리
                    var cnt_total = result["totalRows"],
                        cnt_total = null == cnt_total ? 0 : cnt_total;
                    $("#cnt_total").html(cnt_total);
                    // 페이징 처리
                    Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_goods_list', getSearchGoodsData);

                });

            }

            // 쿠키 카테고리 정보 설정
            function loadCategoryOptionValue(ctgLvl, $sel, upCtgNo, selectedValue) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list'
                  , param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl};

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        jQuery('#btn_search').trigger('click');
                        return;
                    }
                    // 취득결과 셋팅
                    $sel.find('option').not(':first').remove();
                    jQuery.each(result.resultList, function(idx, obj) {
                        if (selectedValue && selectedValue === obj.ctgNo) {
                            $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '" selected>' + obj.ctgNm + '</option>');
                            $('label[for='+ $sel.attr('id') +']', $sel.parent()).html(obj.ctgNm);
                        } else {
                            $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');
                        }
                    });

                    if (ctgLvl === '1' && null != $('#sel_ctg_1').data('searchCtgNo')) {
                        loadCategoryOptionValue('2', jQuery('#sel_ctg_2'), $('#sel_ctg_1').data('searchCtgNo'), $('#sel_ctg_2').data('searchCtgNo'));
                    } else if (ctgLvl === '2' && null != $('#sel_ctg_2').data('searchCtgNo')) {
                        loadCategoryOptionValue('3', jQuery('#sel_ctg_3'), $('#sel_ctg_2').data('searchCtgNo'), $('#sel_ctg_3').data('searchCtgNo'));
                    } else if (ctgLvl === '3' && null != $('#sel_ctg_3').data('searchCtgNo')) {
                        loadCategoryOptionValue('4', jQuery('#sel_ctg_4'), $('#sel_ctg_3').data('searchCtgNo'), $('#sel_ctg_4').data('searchCtgNo'));
                    } else {
                        // 페이징을 쿠키값으로 처리하기 위해 수정
                        //jQuery('#btn_search').trigger('click');
                        /*$('#btn_search').trigger('click');*/
                        getSearchGoodsData();
                    }
                });
            }

            // 페이징 관련 초기화
            function setDefaultValue() {
                jQuery('#hd_srod').val(jQuery('#sel_sord').val());
                jQuery('#hd_rows').val(jQuery('#sel_rows').val());
            }

            // 검색결과 바인딩
            function setGoodsData(goodsData, $tr) {
                console.log("goodsData = ", goodsData);
                var $tmpSearchResultTr = $("#tr_goods_data_template").clone().show().removeAttr("id").data('prev_data', goodsData);
                var trId = "tr_goods_" + goodsData.goodsNo;
                $($tmpSearchResultTr).attr("id", trId).addClass("searchGoodsResult");
                $('[data-bind="goodsInfo"]', $tmpSearchResultTr).DataBinder(goodsData);
                if ($tr) {
                    $tr.before($tmpSearchResultTr);
                } else {
                    $("#tbody_goods_data").append($tmpSearchResultTr);
                }
            }

            // 결과 행의 상품 선택 체크박스 설정
            function setGoodsChkBox(data, obj, bindName, target, area, row) {
                var chkId = "chk_select_goods_" + data["goodsNo"]
                    , $input = obj.find('input')
                    , $label = obj.find('label');

                $input.removeAttr("id").attr("id", chkId).data("goodsNo", data["goodsNo"]);
                $label.removeAttr("id").attr("id", "lb_select_goods_" + data["goodsNo"]).removeAttr("for").attr("for", chkId);

                // 체크박스 클릭시 이벤트 설정
                jQuery($label).off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    console.log("setGoodsChkBox");
                    var $this = jQuery(this),
                        checked = !($input.prop('checked'));
                    $input.prop('checked', checked);
                    $this.toggleClass('on');
                });

                obj.append('<input type="hidden" name="multiOptYn" value="'+ data['multiOptYn'] +'">');
            }

            // 결과 행의 카테고리 표시 설정
            function setGoodsCtg(data, obj, bindName, target, area, row) {
                var ctgArr = (data["ctgArr"]) ? data["ctgArr"].split(",") : null;
                var ctgCmsRateArr = (data["ctgCmsRateArr"]) ? data["ctgCmsRateArr"].split(",") : null;
                var dlgtCtgArr = (data["dlgtCtgArr"]) ? data["dlgtCtgArr"].split(",") : null;
                var html = "";
                $.each( ctgArr, function( index, value ){
                	if(dlgtCtgArr != null && ctgCmsRateArr != null){
                		if(dlgtCtgArr.length >= index && ctgCmsRateArr.length >= index){
                            html +=  value +(dlgtCtgArr[index]=="Y"?"("+ctgCmsRateArr[index]+"%)":"") +"<BR>" ;
                		}
                	}
                });
                obj.html(html);
            }

            // 결과 행의 수량 표시 설정
            function setGoodsQtt(data, obj, bindName, target, area, row) {
                //obj.html(data["stockQtt"] + "/" + data["availStockQtt"]); // 재고/가용
                obj.html(data["stockQtt"]); //재고
            }

            function numberWithCommas(x) {
                return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }

            // 결과 행의 판매가 표시 설정
            function setSalePrice(data, obj, bindName, target, area, row) {

                var $input = obj,
                    inputId = 'input_salePrice_' + data["goodsNo"],
                    salePrice = data["salePrice"],//공급가격
                    /*commisionRate  = data["commisionRate"], //수수료율*/
                    goodseachDlvrc = data["goodseachDlvrc"]//배송비
                ;

                $input.removeAttr("id").attr("id", inputId);

                obj.val(salePrice);
                <c:if test="${typeCd ne '03' and typeCd eq '04'}">
                obj.after("<div>"+numberWithCommas(salePrice)+"<br></div>("+numberWithCommas(goodseachDlvrc)+")");
                </c:if>
                <c:if test="${typeCd eq '03' or typeCd eq '04'}">
                obj.after("<div>"+numberWithCommas(salePrice));
                </c:if>

            }

            // 결과 행의 공급가 표시 설정
            function setSupplyPrice(data, obj, bindName, target, area, row) {

                var $input = obj,
                    inputId = 'input_supplyPrice_' + data["goodsNo"],
                    supplyPrice = data["supplyPrice"]//공급가격
                    /*commisionRate  = data["commisionRate"], //수수료율
                    goodseachDlvrc = data["goodseachDlvrc"]//배송비*/
                    ;

                $input.removeAttr("id").attr("id", inputId);

                obj.val(supplyPrice);
                obj.after("<div>"+numberWithCommas(supplyPrice)/*+"<br></div>("+numberWithCommas(goodseachDlvrc)+")"*/);
            }

            // 결과 행의 재고 표시 설정
            function setStockQtt(data, obj, bindName, target, area, row) {

                /*var $input = obj,
                    inputId = 'input_stockQtt_' + data["goodsNo"],
                    stockQtt = data["stockQtt"];//공급가격

                $input.removeAttr("id").attr("id", inputId);

                obj.val(stockQtt);*/

                 var stockQtt = data["stockQtt"];
                obj.html(numberWithCommas(stockQtt));

            }

            // 상품 판매상태 셀렉트 박스 설정
            function setGoodsStatus(data, obj, bindName, target, area, row) {
                var $span = $("#span_goods_status_template").clone().removeAttr("id");
                    $lable = $span.find("label"),
                    $input = $span.find("select")
                    selid = 'sel_st_' + data["goodsNo"];
                    $input.removeAttr("id").attr("id", selid).find("option[value='"+ data["goodsSaleStatusCd"] +"']").attr("selected", "true");
                    $lable.removeAttr("for").attr("for", selid).text($input.find("option:selected").text());

                    $input.on('change', function(e) {
                        var lb_chk = $("#lb_select_goods_" + data["goodsNo"]);
                        if (lb_chk && !lb_chk.hasClass("on") ) {
                            lb_chk.trigger("click");
                        }
                    });
                    obj.html("").append($span);
            }

            // 상품 판매상태 텍스트 설정
            function setGoodsStatusText(data, obj, bindName, target, area, row) {
                var goodsSaleStatusCd = data["goodsSaleStatusCd"];
                var goodsSaleStatusNm = data["goodsSaleStatusNm"];
                if(goodsSaleStatusCd==1){//판매중
                    goodsSaleStatusNm = '<span class="sale_info1">'+goodsSaleStatusNm+'</span>';
                }else if(goodsSaleStatusCd==2){//품절
                    goodsSaleStatusNm = '<span class="sale_info2">'+goodsSaleStatusNm+'</span>';
                }else if(goodsSaleStatusCd==3){//판매대기
                    goodsSaleStatusNm = '<span class="sale_info3">'+goodsSaleStatusNm+'</span>';
                }else if(goodsSaleStatusCd==4){//판매중지
                    goodsSaleStatusNm = '<span class="sale_info4">'+goodsSaleStatusNm+'</span>';
                }
                obj.html(goodsSaleStatusNm);
            }

            // 전시 상태 셀렉트 박스 설정
            function setGoodsDisplay(data, obj, bindName, target, area, row) {
                var $span = $("#span_goods_disaplay_template").clone().removeAttr("id");
                    $lable = $span.find("label"),
                    $input = $span.find("select")
                    selid = 'sel_disp_' + data["goodsNo"];
                    $input.removeAttr("id").attr("id", selid).find("option[value='"+ data["dispYn"] +"']").attr("selected", "true");
                    $lable.removeAttr("for").attr("for", selid).text($input.find("option:selected").text());
                    $input.on('change', function(e) {
                        var lb_chk = $("#lb_select_goods_" + data["goodsNo"]);
                        if (lb_chk && !lb_chk.hasClass("on") ) {
                            lb_chk.trigger("click");
                        }
                    })
                    obj.html("").append($span);

            }

            // list 미전시버튼 클릭 ->  전시처리
            function setDisplay(goodsNo) {
                    if(!$("#lb_select_goods_"+goodsNo).hasClass("on")){
                        $("#lb_select_goods_"+goodsNo).trigger("click");
                    }
                    fn_noDisplay();
            }
            // list 전시버튼 클릭 -> 미전시처리
            function setNoDisplay(goodsNo) {

                if(!$("#lb_select_goods_"+goodsNo).hasClass("on")){
                    $("#lb_select_goods_"+goodsNo).trigger("click");
                }
                fn_display();
            }


            // 전시 상태 텍스트 설정
            function setGoodsDisplayText(data, obj, bindName, target, area, row) {
                var dispYn = data["dispYn"];
                var dispNm = "";
                if(dispYn=="Y"){//전시
                    dispNm = '<a href="javascript:;" class="btn_gray2" style="background-color:#33be40;" onclick="javascript:setDisplay(\''+data['goodsNo']+'\')">전시</a>'
                }else if(dispYn=="N"){//미전시
                    dispNm = '<a href="javascript:;" class="btn_gray2" style="background-color:#cd0a0a;" onclick="javascript:setNoDisplay(\''+data['goodsNo']+'\')">미전시</a>';
                }

                obj.html(dispNm);

            }

            // 결과 행의 수정 버튼 설정
            function setGoodsEdit(data, obj, bindName, target, area, row) {
                obj.data("goodsNo", data["goodsNo"]);
                obj.data("goodsTypeCd", data["goodsTypeCd"]);

                obj.off("click").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    executeGoodsEdit($(this));
                });
            }

            // 결과 행의 복사 버튼 설정
            function setGoodsCopy(data, obj, bindName, target, area, row) {
                obj.data("goodsNo", data["goodsNo"]);
                obj.off("click").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    executeGoodsCopy($(this));
                });
            }

            // 상품 명의 링크 설정
            function setGoodsDetail(data, obj, bindName, target, area, row) {
                var $aTag = document.createElement('a');
                $($aTag).data("goodsNo", data["goodsNo"]).attr("href", "#none").addClass("tbl_link").html(data["goodsNm"]+"<br>["+data["goodsNo"]+"]");
                $($aTag).off("click").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    executeGoodsDetail($(this));
                });
                obj.append($aTag);
            }

            // 상품 상세 링크 처리
            function executeGoodsDetail(obj) {
                var trID = "tr_goods_" + obj.data("goodsNo");
                $targetTr = $("#" + trID);
                location.href= "/admin/goods/goods-detail-edit?goodsNo=" + obj.data('goodsNo') + "&goodsTypeCd=" + obj.data('goodsTypeCd');
            }

            // 수정 화면으로의 이동 처리
            function executeGoodsEdit(obj) {
                var trID = "tr_goods_" + obj.data("goodsNo");
                console.log("executeGoodsEdit goodsTypeCd = ", obj.data('goodsTypeCd'));
                $targetTr = $("#" + trID);
                location.href= "/admin/goods/goods-detail-edit?goodsNo=" + obj.data('goodsNo') + "&typeCd=" + '${typeCd}';
            }

            // 복사 이벤트 처리
            function executeGoodsCopy(obj) {
                var trID = "tr_goods_" + obj.data("goodsNo");
                // alert("복사클릭 (복사본 상품 등록 필요 - 해당 기능 미구현, 상품등록 구현 이후 처리필요):" + trID);
                // $targetTr = $("#" + trID);

                Dmall.LayerUtil.confirm('상품 정보를 복사하시겠습니까?', function() {
                    var url = '/admin/goods/goods-copy',
                        param = {'goodsNo' : obj.data("goodsNo")},
                        $tr = obj.parent().parent(),
                        prev_data =$tr.data('prev_data');

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'popupForm');

                        if (result == null || result.success != true) {
                            return;
                        } else {
                            prev_data['goodsNo'] = result.data['goodsNo'];
                            prev_data['goodsNm'] = result.data['goodsNm'];
                            prev_data['rownum'] = '복사';
                            setGoodsData(prev_data, $tr);
                        }
                    });
                });
            }

            // 상위 카테고리 설정에 따른 하위 카테고리 옵션값 변경
            function changeCategoryOptionValue(level, $target) {
                var $sel = $('#sel_ctg_' + level),
                    $label = $('label[for=sel_ctg_' + level + ']', '#td_goods_select_ctg');

                $sel.find('option').not(':first').remove();
                $label.text( $sel.find("option:first").text() );

                if ( level && level == '2' && $target.attr('id') == 'sel_ctg_1') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '3' && $target.attr('id') == 'sel_ctg_2') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '4' && $target.attr('id') == 'sel_ctg_3') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else {
                    return;
                }
            }

            // 하위 카테고리 정보 취득
            function getCategoryOptionValue(ctgLvl, $sel, upCtgNo) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl};

                console.log("ctgLvl = ", ctgLvl);
                console.log("upCtgNo = ", upCtgNo);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    if (result == null || result.success != true) {
                        return;
                    }
                    // location.reload();
                    $sel.find('option').not(':first').remove();
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');
                    });
                });
            }

            // 하위 카테고리 정보 취득
            function getTopCategoryOptionValue(ctgLvl, $sel) {
                /*if (ctgLvl != '1') {
                    return;
                }*/
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : CATEGORY_MENU_NB, 'ctgLvl' : ctgLvl};
                console.log("getTopCategoryOptionValue param = ", param);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    if (result == null || result.success != true) {
                        return;
                    }
                    $sel.find('option').not(':first').remove();
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');
                    });
                });
            }

            // 상품 엑셀 업로드 테스트용
            function excelUpload() {

                if(jQuery('#file_route1').val()=='파일선택')
                    return;
                if(Dmall.validate.isValid('form_excel_insert')) {
                    var url = '/admin/goods/goods-img-excel-upload';

                    var param = $('#form_excel_insert').serialize();
                    if (Dmall.FileUpload.checkFileSize('form_excel_insert')) {
                        $('#form_excel_insert').ajaxSubmit({
                            url : url,
                            dataType : 'json',
                            success : function(result){
                                Dmall.validate.viewExceptionMessage(result, 'form_excel_insert');
                                //
                                if(result.success && result.totalRows !=0){
                                    Dmall.LayerUtil.alert(result.message);
                                    Dmall.LayerPopupUtil.close('layer_upload_pop');
                                    getSearchGoodsData();
                                } else if(!result.success){
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        });
                    }
                }
            }

            function excelSample() {
                var url = '/admin/goods/goods-download',
                param = {};
                Dmall.FormUtil.submit(url, param, '_blank');
                return false;
            }

            function openDlvrDatePop() {
                var selected = fn_selectedList();
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#div_dlvr_date_confirm'));
                }
            }

            function openDlvrCostPop() {
                var selected = fn_selectedList();
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#div_dlvr_cost_confirm'));
                }
            }

            function openSalePricePop() {
                // try {
                //     $('#tbody_goods_data input:checked').each(function () {
                //         if($(this).closest('label').siblings('input:hidden[name=multiOptYn]').val() == 'Y') {
                //             throw new Error();
                //         }
                //     });
                //
                //     var selected = fn_selectedList();
                //     if(selected) {
                //         Dmall.LayerPopupUtil.open(jQuery('#sale_price_confirm_popup'));
                //     }
                // } catch(err) {
                //     Dmall.LayerUtil.alert('다중옵션 상품이 선택되어 있습니다.<br>다중옵션 상품은 별도 수정 화면으로 진입하여 수정해주세요.');
                // }

                var selected = fn_selectedList();
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#sale_price_confirm_popup'));
                }
            }

            function openEventWordsPop() {
                var selected = fn_selectedList();
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#event_words_change_popup'));
                }
            }

            function openIconPop() {
                var selected = fn_selectedList();
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#div_icon_confirm'));
                    IconSelectPopup._init(selected);
                }
            }

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품설정<span class="step_bar"></span> 상품 관리<span class="step_bar"></span>
                </div>
                <c:if test="${typeCd eq '01'}">
                    <h2 class="tlth2">안경테</h2>
                </c:if>
                <c:if test="${typeCd eq '02'}">
                    <h2 class="tlth2">선글라스</h2>
                </c:if>
                <c:if test="${typeCd eq '03'}">
                    <h2 class="tlth2">안경렌즈</h2>
                </c:if>
                <c:if test="${typeCd eq '04'}">
                    <h2 class="tlth2">콘택트렌즈</h2>
                </c:if>
                <c:if test="${typeCd eq '05'}">
                    <h2 class="tlth2">소모품</h2>
                </c:if>
            </div>
            <div class="line_box">
            <!-- search_box -->
                <form id="form_id_search" >
                    <input type="hidden" name="page" id="hd_page" value="1" />
                    <input type="hidden" name="sord" id="hd_srod" value="" />
                    <input type="hidden" name="rows" id="hd_rows" value="" />
                    <input type="hidden" name="calindex" id="hd_calindex" value="3" />
                    <input type="hidden" name="menuType" id="menu_type" value="${typeCd}" />
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 판매상품관리 검색 표 입니다. 구성은 카테고리, 브랜드, 기간, 상품가격, 판매상태, 전시상태, 판매자, 검색어 입니다.">
                                <caption>판매상품관리 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody id="tbody_goods_search">
                                <c:if test="${typeCd ne '05'}">
                                    <tr>
                                        <th>카테고리</th>
                                        <td id="td_goods_select_ctg">
                                            <c:if test="${typeCd eq '01'}">
                                            <input type="hidden" name="searchCtg1" id="sel_ctg_1" value="1" />
                                            </c:if>
                                            <c:if test="${typeCd eq '02'}">
                                                <input type="hidden" name="searchCtg1" id="sel_ctg_1" value="2" />
                                            </c:if>
                                            <c:if test="${typeCd eq '03'}">
                                                <input type="hidden" name="searchCtg1" id="sel_ctg_1" value="3" />
                                            </c:if>
                                            <c:if test="${typeCd eq '04'}">
                                                <input type="hidden" name="searchCtg1" id="sel_ctg_1" value="4" />
                                            </c:if>

                                            <span class="select">
                                                <label for="sel_ctg_2"></label>
                                                <select name="searchCtg2" id="sel_ctg_2">
                                                    <option id="opt_ctg_2_def" value="">2차 카테고리</option>
                                                </select>
                                            </span>
                                            <span class="select">
                                                <label for="sel_ctg_3"></label>
                                                <select name="searchCtg3" id="sel_ctg_3">
                                                    <option id="opt_ctg_3_def" value="">3차 카테고리</option>
                                                </select>
                                            </span>
                                            <c:if test="${typeCd eq '04'}">
                                            <span class="select">
                                                <label for="sel_ctg_4"></label>
                                                <select name="searchCtg4" id="sel_ctg_4">
                                                    <option id="opt_ctg_4_def" value="">4차 카테고리</option>
                                                </select>
                                            </span>
                                            </c:if>
                                        </td>
                                    </tr>
                                    <c:if test="${typeCd eq '04'}">
                                    <tr>
                                        <th rowspan="2">필터</th>
                                        <td>
                                            <span class="select">
                                              <label for="sel_filter_type">선택</label>
                                              <select name="contfilter_sel" id="sel_filter_type">
                                                <c:forEach var="filter" items="${resultFilterList}" varStatus="status">
                                                    <c:if test="${filter.filterLvl eq '2' && filter.goodsTypeCd eq typeCd}">
                                                            <option id="opt_filter_def_${filter.id}" value="${filter.id}">${filter.text}</option>
                                                    </c:if>
                                                </c:forEach>
                                              </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr id="tr_filter_search">
                                        <td class="searchFilterResult">
                                            <c:if test="${!empty resultFilterList}">
                                                <c:forEach var="filter" items="${resultFilterList}" varStatus="status">
                                                    <c:set var="filter_menu_type" value="${filter.filterMenuType}"/>
                                                    <c:if test="${filter.filterLvl eq '3'}">
                                                        <c:set var="filter_no" value="${filter.id}"/>
                                                        <c:set var="up_filter_no" value="${filter.parent}"/>
                                                        <c:set var="filter_nm" value="${filter.text}"/>
                                                        <span class="select">
                                                            <label for="${filter_menu_type}_${filter_no}">${filter_nm}</label>
                                                            <select name="filters" id="${filter_menu_type}_${status.index}">
                                                                <option value="" selected="selected">${filter_nm}</option>
                                                        <c:forEach var="filterSub" items="${resultFilterList}" varStatus="status2">
                                                            <c:set var="filter_sub_no" value="${filterSub.id}"/>
                                                            <c:set var="filter_child_nm" value="${filterSub.text}"/>
                                                            <c:if test="${filter_no eq filterSub.parent && filterSub.filterLvl eq '4'}">
                                                                <option id="opt_filter_${filter_sub_no}" value="${filter_sub_no}">${filter_child_nm}</option>
                                                            </c:if>
                                                            <c:if test="${status2.last}">
                                                            </select>
                                                        </span>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>
                                        </td>
                                    </tr>
                                    </c:if>
                                    <c:if test="${typeCd ne '04'}">
                                    <tr>
                                        <th>필터</th>
                                        <td id="td_filter_select_ctg">
                                            <c:if test="${!empty resultFilterList}">
                                                <c:forEach var="filter" items="${resultFilterList}" varStatus="status">
                                                    <c:set var="filter_menu_type" value="${filter.filterMenuType}"/>
                                                    <c:if test="${filter.filterLvl eq '2'}">
                                                        <c:set var="filter_no" value="${filter.id}"/>
                                                        <c:set var="up_filter_no" value="${filter.parent}"/>
                                                        <c:set var="filter_nm" value="${filter.text}"/>
                                                    <span class="select">
                                                        <label for="${filter_menu_type}_${filter_no}">${filter_nm}</label>
                                                        <select name="filters" id="${filter_menu_type}_${status.index}">
                                                            <option value="" selected="selected">${filter_nm}</option>
                                                        <c:forEach var="filterSub" items="${resultFilterList}" varStatus="status2">
                                                            <c:set var="filter_sub_no" value="${filterSub.id}"/>
                                                            <c:set var="filter_child_nm" value="${filterSub.text}"/>
                                                            <c:if test="${filter_no eq filterSub.parent && filterSub.filterLvl eq '3'}">
                                                            <option id="opt_filter_${filter_sub_no}" value="${filter_sub_no}">${filter_child_nm}</option>
                                                            </c:if>
                                                            <c:if test="${status2.last}">
                                                        </select>
                                                    </span>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>
                                        </td>
                                    </tr>
                                    </c:if>
                                    <c:if test="${typeCd ne '03'}">
                                    <%--<tr>
                                        <th>내 코드 정보</th>
                                        <td>
                                            <c:if test="${typeCd ne '04'}">
                                            <span class="select">
                                                <label for="faceSizeCd"></label>
                                                <select name="faceSizeCd" id="faceSizeCd">
                                                    <cd:optionT codeGrp="FACE_SIZE_CD" includeChoice="true" codeGrpTitle="안경추천사이즈"/>
                                                </select>
                                            </span>
                                                <span class="select">
                                                <label for="faceShapeCd"></label>
                                                <select name="faceShapeCd" id="faceShapeCd">
                                                    <cd:optionT codeGrp="FACE_SHAPE_CD" includeChoice="true" codeGrpTitle="얼굴형"/>
                                                </select>
                                            </span>
                                                <span class="select">
                                                <label for="faceSkinToneCd"></label>
                                                <select name="faceSkinToneCd" id="faceSkinToneCd">
                                                    <cd:optionT codeGrp="FACE_SKIN_TONE_CD" includeChoice="true" codeGrpTitle="피부톤"/>
                                                </select>
                                            </span>
                                                <span class="select">
                                                <label for="faceStyleCd"></label>
                                                <select name="faceStyleCd" id="faceStyleCd">
                                                    <cd:optionT codeGrp="FACE_STYLE_CD" includeChoice="true" codeGrpTitle="스타일"/>
                                                </select>
                                            </span>
                                            </c:if>
                                            <c:if test="${typeCd eq '04'}">
                                            <span class="select">
                                                <label for="eyeShapeCd"></label>
                                                <select name="eyeShapeCd" id="eyeShapeCd">
                                                    <cd:optionT codeGrp="EYE_SHAPE_CD" includeChoice="true" codeGrpTitle="눈 모양"/>
                                                </select>
                                            </span>
                                            <span class="select">
                                                <label for="eyeSizeCd"></label>
                                                <select name="eyeSizeCd" id="eyeSizeCd">
                                                    <cd:optionT codeGrp="EYE_SIZE_CD" includeChoice="true" codeGrpTitle="눈 사이즈"/>
                                                </select>
                                            </span>
                                            <span class="select">
                                                <label for="eyeStyleCd"></label>
                                                <select name="eyeStyleCd" id="eyeStyleCd">
                                                    <cd:optionT codeGrp="EYE_STYLE_CD" includeChoice="true" codeGrpTitle="스타일"/>
                                                </select>
                                            </span>
                                            <span class="select">
                                                <label for="eyeColorCd"></label>
                                                <select name="eyeColorCd" id="eyeColorCd">
                                                    <cd:optionT codeGrp="EYE_COLOR_CD" includeChoice="true" codeGrpTitle="동공색"/>
                                                </select>
                                            </span>
                                            </c:if>
                                        </td>
                                    </tr>--%>
                                    </c:if>
                                </c:if>
                                    <tr>
                                        <th>상품 등록일</th>
                                        <td id="td_cal" data-index="3">
                                            <c:if test="${typeCd eq '05'}">
                                                <input type="hidden" name="searchCtg1" id="sel_ctg_1" value="1014" />
                                            </c:if>
                                            <input type="hidden" name="searchDateType" id="sel_search_date_type" value="1" />
                                            <span class="intxt"><input type="text" name="searchDateFrom" id="txt_search_date_from" class="bell_date_sc date registration-date" data-validation-engine="validate[dateFormat, maxSize[10]]" maxlength="10" placeholder="YYYY-MM-DD" autocomplete="off"></span>
                                            <%--<a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date01">달력이미지</a>--%>
                                            ~  &nbsp&nbsp
                                            <span class="intxt"><input type="text" name="searchDateTo" id="txt_search_date_to" class="bell_date_sc date" data-validation-engine="validate[dateFormat, maxSize[10]]" maxlength="10" placeholder="YYYY-MM-DD" autocomplete="off"></span>
                                            <%--<a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date02">달력이미지</a>--%>
                                            <div class="tbl_btn ml0">
                                                <button class="btn_day" id="btn_cal_1" ><span></span>오늘</button>
                                                <button class="btn_day" id="btn_cal_2" ><span></span>3일간</button>
                                                <button class="btn_day" id="btn_cal_3" ><span></span>일주일</button>
                                                <button class="btn_day" id="btn_cal_4" ><span></span>1개월</button>
                                                <button class="btn_day" id="btn_cal_5" ><span></span>3개월</button>
                                                <button class="btn_day" id="btn_cal_6" ><span></span>전체</button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>상품가격</th>
                                        <td>
                                            <span class="intxt"><input type="text" name="searchPriceFrom" id="txt_search_price_from" class="txtr comma price" maxlength="10"/></span>
                                            <img class="tilde-icon" src="/admin/img/icons/icon_tilde.png" alt="tilde icon">
                                            <span class="intxt"><input type="text" name="searchPriceTo" id="txt_search_price_to" class="txtr comma price" maxlength="10" style="width:173px;"/></span>&nbsp&nbsp 원 까지
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>상품유형</th>
                                        <td id="td_goodsType">
                                            <label for="chack01_1" class="chack mr20">
                                                <input type="checkbox" name="normalYn" id="chack01_1" value="Y" class="blind">
                                                <span class="ico_comm" ></span>
                                                일반
                                            </label>
                                            <label for="chack01_2" class="chack mr20">
                                                <input type="checkbox" name="newGoodsYn" id="chack01_2" value="Y" class="blind">
                                                <span class="ico_comm"></span>
                                                신상품
                                            </label>
                                            <c:if test="${typeCd eq '04'}">
                                            <label for="chack01_3" class="chack mr20">
                                                <input type="checkbox" name="stampYn" id="chack01_3" value="Y" class="blind">
                                                <span class="ico_comm"></span>
                                                스탬프 적립 상품
                                            </label>
                                            </c:if>
                                            <label for="chack01_4" class="chack mr20">
                                                <input type="checkbox" name="mallOrderYn" id="chack01_4" value="Y" class="blind">
                                                <span class="ico_comm"></span>
                                                웹발주용
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>판매상태</th>
                                        <td id="td_goodsStatus">
                                            <label for="chack00_1" class="chack mr20">
                                                <input type="checkbox" name="goodsStatus" id="chack00_1" value="1" class="blind" />
                                                <span class="ico_comm">&nbsp;</span>
                                                판매중
                                            </label>
                                            <label for="chack00_4" class="chack mr20">
                                                <input type="checkbox" name="goodsStatus" id="chack00_4" value="4" class="blind" />
                                                <span class="ico_comm">&nbsp;</span>
                                                판매중지
                                            </label>
                                            <label for="chack00_2" class="chack mr20">
                                                <input type="checkbox" name="goodsStatus" id="chack00_2" value="2" class="blind" />
                                                <span class="ico_comm">&nbsp;</span>
                                                품절
                                            </label>


                                            <%--<a href="#none" id="goodsStatus" class="all_choice"><span class="ico_comm"></span> 전체</a>--%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>전시상태</th>
                                        <td id="td_goodsDisplay">
                                            <label for="chack02_1" class="chack mr20">
                                                <input type="checkbox" name="goodsDisplay" id="chack02_1" value="Y" class="blind" />
                                                <span class="ico_comm">&nbsp;</span>
                                                전시
                                            </label>
                                            <label for="chack02_2" class="chack mr20">
                                                <input type="checkbox" name="goodsDisplay" id="chack02_2" value="N" class="blind" />
                                                <span class="ico_comm">&nbsp;</span>
                                                미전시
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>판매자</th>
                                        <td>
                                           <span class="select">
                                                <label for="sel_seller"></label>
                                                <select name="searchSeller" id="sel_seller">
                                                   <cd:sellerOption siteno="${siteNo}" includeTotal="true"/>
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>다비젼상품코드</th>
                                        <td>
                                            <span class="intxt"><input type="text" name="searchErpItmCd" id="txt_search_erp_itmcd" class="search_code_input"/></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>검색어</th>
                                        <td>
                                            <input type="hidden" name="searchType" id="sel_search_type" value="1" />
                                            <div class="select_inp">
                                                <input type="text" name="searchWord" id="txt_search_word" class="search_code_input"/>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                        <div class="btn_box txtc">
                            <button class="btn--black product-management" id="btn_search">검색</button>
                        </div>
                    </div>
                </form>
        <!-- //search_box -->

        <!-- line_box -->
                <div class="line_box_wrap">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="be" id="cnt_search">0</strong>개의 상품이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl excel_download_btn" id="btn_download">
                                <span>Excel download</span>
                                <img src="/admin/img/icons/icon-excel_down.png" alt="excel download">
                            </button>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                            <table style="table-layout:fixed;" summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                                <caption>판매상품관리 리스트</caption>
                                <colgroup>
                                    <col width="49px">
                                    <col width="50px">
                                    <col width="100px">
                                    <col width="15%">
                                    <col width="8%">
                                    <col width="15%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="8%">
                                    <col width="8%">
                                    <col width="8%">
                                    <col width="110px">
                                    <col width="12%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <label for="allcheck" class="chack">
                                                <span class="ico_comm"><input type="checkbox" name="table" id="allcheck" /></span>
                                            </label>
                                        </th>
                                        <th>NO</th>
                                        <th>이미지</th>
                                        <th>상품명</th>
                                        <th>브랜드</th>
                                        <th>상품코드</th>
                                        <th>판매자</th>
                                        <c:if test="${typeCd ne '03' and typeCd ne '04'}">
                                            <th>판매가/<br>택배가</th>
                                        </c:if>
                                        <c:if test="${typeCd eq '03' or typeCd eq '04'}">
                                            <th>판매가</th>
                                        </c:if>
                                        <th>공급가</th>
                                        <th>재고</th>
                                        <th>판매상태</th>
                                        <th>관리</th>
                                        <th>다비젼<br>상품코드</th>
                                    </tr>
                                </thead>
                                <tbody id="tbody_goods_data">
                                    <tr id="tr_goods_data_template" style="display: none;">
                                        <td data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsChkBox">
                                            <label for="chk_select_goods_template" class="chack"><span class="ico_comm"><input type="checkbox" id="chk_select_goods_template" class="blind">&nbsp;</span></label>
                                        </td>
                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sortNum" >1</td>
                                        <td><img src="" data-bind="goodsInfo" data-bind-type="img" data-bind-value="goodsImg02"></td>

                                        <td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNm"></td>
                                        <td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="brandNm"></td>
                                        <td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNo"></td>
                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sellerNm" >판매자명</td>
                                        <td>
                                            <span class="intxt shot">
                                                <input type="hidden" class="comma" name="salePrice" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSalePrice"  data-bind-value="salePrice" data-validation-engine="validate[required, maxSize[10]]" maxlength="10"><%--판매가--%>
                                                <input type="hidden" name="itemNo" data-bind="goodsInfo" data-bind-type="text" data-bind-value="itemNo">
                                                <input type="hidden" name="sepSupplyPriceYn" data-bind="goodsInfo" data-bind-type="text" data-bind-value="sepSupplyPriceYn">
                                                <input type="hidden" name="sellerCmsRate" data-bind="goodsInfo" data-bind-type="text" data-bind-value="sellerCmsRate">
                                                <input type="hidden" name="goodsTypeCd" data-bind="goodsInfo" data-bind-type="text" data-bind-value="goodsTypeCd"/>
                                            </span>
                                        </td>
                                        <%--<td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setGoodsQtt" data-bind-value="goodsNo">0/0</td>--%>
                                        <%--<td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="supplyPrice"></td>--%>
                                        <td>
                                            <span class="intxt shot">
                                                <input type="hidden" class="comma" name="supplyPrice" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSupplyPrice"  data-bind-value="supplyPrice" data-validation-engine="validate[maxSize[10]]" maxlength="10" readonly><%--공급가--%>
                                            </span>
                                        </td>
                                        <td data-bind="goodsInfo" data-bind-value="stockQtt" data-bind-type="function" data-bind-function="setStockQtt" >
                                            <%--<span class="intxt shot">
                                                <input type="text" class="comma" name="stockQtt" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setStockQtt" data-bind-value="stockQtt" data-validation-engine="validate[required, maxSize[5]]" maxlength="4">&lt;%&ndash;재고&ndash;%&gt;
                                            </span>--%>
                                        </td>

                                        <%--<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="commisionRate">수수료율</td>
                                        <td data-bind="goodsInfo" data-bind-type="commanumber" data-bind-value="goodseachDlvrc" >0</td>--%>
                                        <td data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusText">
                                            <%--<span class="select shot2" id="span_goods_status_template">
                                                <label for="sel_test"></label>
                                                <select id="sel_test" name="goodsSaleStatusCd">
                                                    <tags:option codeStr="1:판매중;2:품절;3:판매대기;4:판매중지" />
                                                </select>
                                            </span>--%>
                                        </td>
                                        <%--<td data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsDisplayText">
                                            &lt;%&ndash;<span class="select shot2" id="span_goods_disaplay_template">
                                                <label for="sel_display"></label>
                                                <select id="sel_display" name="dispYn">
                                                    <tags:option codeStr="Y:전시;N:미전시" />
                                                </select>
                                            </span>&ndash;%&gt;
                                        </td>--%>
                                        <td>
                                            <div class="btn_gray4_wrap">
                                                <button class="btn_gray4" data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsEdit">수정</button>
                                                <button class="btn_gray4 btn_gray4_right" data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsCopy">복사</button>
                                            </div>
                                        </td>
                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
                                    </tr>
                                    <tr id="tr_no_goods_data"><td colspan="13">데이터가 없습니다.</td></tr>
                                </tbody>
                            </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div class="pageing"  id="div_id_paging"></div>
                    </div>
                </div>
            <!-- //bottom_lay -->
            </div>
        <!-- //line_box -->

        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <span class="Batch_change_nav">
                    <button class="btn--big btn--big-white change" id="btn_Batch_change">일괄변경<span class="change_down_btn"></span></button>
                        <ul class="change_items">
                            <c:if test="${typeCd ne '03' and typeCd ne '04'}">
                                <li><a class="changeitem" onclick="javascript:openDlvrDatePop();">예상 배송 소요일</a></li>
                                <li><a class="changeitem" onclick="javascript:openDlvrCostPop();">배송비 변경</a></li>
                            </c:if>
                            <li><a class="changeitem" onclick="javascript:openSalePricePop();">판매가 변경</a></li>
                            <li><a class="changeitem" onclick="javascript:openEventWordsPop();">이벤트 안내문 변경</a></li>
                            <li><a class="changeitem" onclick="javascript:openIconPop();">아이콘 변경</a></li>
                        </ul>
                    </span>
                    <button class="btn--big btn--big-white" id="btn_delete">선택삭제</button>
                    <button class="btn--big btn--big-white" id="btn_soldout">품절</button>
                    <button class="btn--big btn--big-white" id="btn_salestop">판매중지</button>
                    <button class="btn--big btn--big-white" id="btn_salestart">판매중</button>
                </div>
            </div>
            <div class="right">
                <%--<button class="btn--blue-round" id="btn_upload">이미지 일괄변경</button>
                <button class="btn--blue-round" id="btn_goods_regist">대량등록</button>--%>
                <button class="btn--blue-round" id="btn_regist">상품등록</button>
            </div>

        </div>
        <!-- //bottom_box -->

        <!-- =================================popup================================ -->

        <!-- popup  예상 배송 소요일 -->
        <div id="div_dlvr_date_confirm" class="slayer_popup" style="display:none;" >
            <div class="pop_wrap size4">
                <div class="pop_tlt">
                    <h2 class="tlth2">예상 배송 소요일 변경 <span class="desc"></span></h2>
                    <a href="javascript:;" class="close ico_comm">닫기</a>
                </div>
                <div class="pop_con">
                    <div>
                        <div class="tblh" >
                            <table>
                                <caption>예상 배송 소요일 변경</caption>
                                <colgroup>
                                    <col width="30%">
                                    <col width="70%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th> 예상 배송 소요일</th>
                                        <td class="txtl"> 평균 &nbsp; &nbsp;
                                            <span class="intxt shot2"><input type="text" id="input_id_dlvrExpectDays" name="dlvrExpectDays"></span>일
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_regist_dlvr_date">적용하기</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- popup  배송비 변경-->
        <div id="div_dlvr_cost_confirm" class="slayer_popup" style="display:none;" >
            <div class="pop_wrap size3">
                <div class="pop_tlt">
                    <h2 class="tlth2">배송비 변경 <span class="desc"></span></h2>
                    <a href="javascript:;" class="close ico_comm">닫기</a>
                </div>
                <div class="pop_con">
                    <div>
                        <form:form id="form_id_dlvr_cost" >
                        <div class="tblw tblmany" >
                            <table>
                                <caption>배송비 변경</caption>
                                <colgroup>
                                    <col width="15%">
                                    <col width="85%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>배송비<br>설정</th>
                                        <td id="set_deliveryfee">
                                            <div class="radio_select">
                                                <%--<label for="deli_set01" class="radio mr0">
                                                    <input type="radio" name="dlvrSetCd" id="deli_set01" value="1" class="blind">
                                                    <span class="ico_comm"></span>
                                                    배송비 &nbsp;&nbsp;&nbsp;
                                                    <span class="intxt shot2">
                                                        <input type="text" class="comma w60" data-validation-engine="validate[maxSize[10]]" maxlength="10">
                                                    </span>원
                                                </label>--%>
                                                <label for="deli_set01" class="radio left">
                                                <span class="ico_comm">
                                                    <input type="radio" name="dlvrSetCd" value="1" id="deli_set01" class="blind">
                                                </span> 기본 배송비 (기본 배송비 선택 시 배송비, 배송방법, 배송비 결제 방식은 * 설정 > 기본관리 > 배송설정에 등록된 설정 값을 따릅니다.)
                                                </label>
                                                <span  class="br"></span>
                                                <label for="deli_set02" class="radio mr0">
                                                    <input type="radio" name="dlvrSetCd" id="deli_set02" value="2" class="blind">
                                                    <span class="ico_comm"></span>
                                                    상품별 배송비 (무료) (배송비를 판매자가 부담하게 됩니다.)
                                                </label>
                                                <span  class="br"></span>
                                                <label for="deli_set03" class="radio mr0">
                                                    <input type="radio" name="dlvrSetCd" id="deli_set03" value="3" class="blind">
                                                    <span class="ico_comm"></span>
                                                    상품별 배송비 (유료) (개수와 상관 없이 배송비 &nbsp;&nbsp;&nbsp;
                                                    <span class="intxt  shot2">
                                                        <input type="text" id="goodseachDlvrc" class="comma" class="w60" name="goodseachDlvrc" data-validation-engine="validate[maxSize[10]]" maxlength="10">
                                                    </span>원)
                                                </label>
                                                <span  class="br"></span>
                                                <label for="deli_set04" class="radio mr0">
                                                    <input type="radio" name="dlvrSetCd" id="deli_set04" value="6" class="blind">
                                                    <span class="ico_comm"></span>
                                                    상품별 배송비 (조건부 무료) (배송비 &nbsp;&nbsp;&nbsp;
                                                    <span class="intxt shot2">
                                                        <input type="text" id="goodseachcndtaddDlvrc" class="comma" class="w60" name="goodseachcndtaddDlvrc" data-validation-engine="validate[maxSize[10]]" maxlength="10">
                                                    </span>원, &nbsp;&nbsp;&nbsp;
                                                    <span class="intxt  shot2">
                                                        <input type="text" id="freeDlvrMinAmt" class="comma" class="w60" name="freeDlvrMinAmt" data-validation-engine="validate[maxSize[10]]" maxlength="10">
                                                    </span>원 이상 구매시 무료)
                                                </label>
                                                <span  class="br"></span>
                                                <label for="deli_set05" class="radio mr0" style="display:flex; flex-direction: column; align-items: flex-start;">
                                                    <div class="packaging-unit" style="display:flex; align-items: center;">
                                                        <input type="radio" name="dlvrSetCd" id="deli_set05" value="4" class="blind">
                                                        <span class="ico_comm"></span>
                                                        포장단위별 배송비 (포장 최대 단위는 상품  &nbsp;&nbsp;&nbsp;
                                                        <span class="intxt shot2">
                                                            <input type="text" id="packMaxUnit" name="packMaxUnit" class="comma w60" data-validation-engine="validate[maxSize[6]]" maxlength="6">
                                                        </span>개이며, 배송비&nbsp;&nbsp;&nbsp;
                                                        <span class="intxt shot2">
                                                            <input type="text" id="packUnitDlvrc" name="packUnitDlvrc" class="comma w60" data-validation-engine="validate[maxSize[10]]" maxlength="10">
                                                        </span>원)<br>
                                                    </div>
                                                    <span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ex&#41;택배 포장단위 별 최대 3개까지 2,500원 추가 3개당 2,500원</span>
                                                </label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            요청상품 배송방법 <span class="important">*</span>
                                        </th>
                                        <td>
                                            <%--<input type="checkbox" name="couriDlvrApplyYn" id="chk_couri_dlvr_apply_yn"
                                                   class="blind" value="Y" />
                                            <label for="chk_couri_dlvr_apply_yn" class="chack mr20">
                                                <span class="ico_comm">&nbsp;</span>
                                                택배배송
                                            </label>--%>
                                            <tags:checkbox name="couriDlvrApplyYn" id="chk_couri_dlvr_apply_yn" value="Y" compareValue="" text="택배배송" />
                                            <span class="br"></span>
                                            <tags:checkbox name="directRecptApplyYn" id="chk_direct_recpt_apply_yn" value="Y" compareValue="" text="직접수령(직접수령 가능 상품에 한하여 선택해주세요)" />
                                            <%--<input type="checkbox" name="directRecptApplyYn" id="chk_direct_recpt_apply_yn"
                                                   class="blind" value="Y"/>
                                            <label for="chk_direct_recpt_apply_yn" class="chack">
                                                <span class="ico_comm">&nbsp;</span>
                                                직접수령
                                            </label>--%>
                                            (직접수령 가능 상품에 한하여 선택해주세요)
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        </form:form>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_regist_dlvr_cost">적용하기</button>
                        </div>
                    </div>
                    <div>
                    </div>
                </div>
            </div>
        </div>

        <!-- popup 판매가 변경-->
        <div id="sale_price_confirm_popup" class="slayer_popup" style="display:none;">
            <div class="pop_wrap size2">
                <div class="pop_tlt">
                    <h2 class="tlth2">판매가 변경 <span class="desc"></span></h2>
                    <a href="javascript:;" class="close ico_comm">닫기</a>
                </div>
                <div class="pop_con">
                    <div>
                        <div class="tblh" >
                            <table>
                                <caption>판매가 변경</caption>
                                <colgroup>
                                    <col width="20%">
                                    <col width="80%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>판매가</th>
                                        <td class="txtl">
                                            <span class="intxt"><input type="text" name="salePrice" id="salePrice"></span>원
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>기간</th>
                                        <td class="txtl">
                                            <span class="intxt">
                                                <input type="text" name="saleStartDt" id="saleStartDt" class="bell_date_sc date" data-validation-engine="validate[dateFormat, maxSize[10]]" maxlength="10" placeholder="YYYY-MM-DD" autocomplete="off">
                                            </span>
                                            ~
                                            <span class="intxt ml10">
                                                <input type="text" name="saleEndDt" id="saleEndDt" class="bell_date_sc date" data-validation-engine="validate[dateFormat, maxSize[10]]" maxlength="10" placeholder="YYYY-MM-DD" autocomplete="off">
                                            </span>
                                            <label for="saleForeverYn" class="chack">
                                                <input type="checkbox" name="saleForeverYn" id="saleForeverYn" class="blind">
                                                <span class="ico_comm" ></span>
                                                무제한
                                            </label>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="desc_txt mt10"> &#8251;판매가 기간이 만료시 사용자에서 '정상가'로 노출됩니다.</div>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_regist_sale_price">적용하기</button>
                        </div>
                    </div>
                    <div>
                    </div>
                </div>
            </div>
        </div>

        <!-- popup  이벤트 안내문 변경-->
        <div id="event_words_change_popup" class="slayer_popup" style="display:none;">
            <div class="pop_wrap size2">
                <div class="pop_tlt">
                    <h2 class="tlth2">이벤트 안내문 변경</h2> <span class="desc"></span></h2>
                    <a href="javascript:;" class="close ico_comm">닫기</a>
                </div>
                <div class="pop_con" style="max-height: unset;">
                    <div>
                        <form:form id="form_id_event_words" >
                        <div class="tblh" >
                            <table>
                                <caption>이벤트 안내문 변경</caption>
                                <colgroup>
                                    <col width="30%">
                                    <col width="70%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>이벤트 안내문</th>
                                        <td class="txtl">
                                            <div class="txt_area">
                                                <textarea
                                                        name="eventWords"
                                                        id="eventWords"
                                                        data-validation-engine="validate[maxSize[300]]"></textarea>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        </form:form>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_regist_event_words">적용하기</button>
                        </div>
                    </div>
                    <div>
                    </div>
                </div>
            </div>
        </div>

        <!-- popup  아이콘 변경-->
        <div id="div_icon_confirm" class="slayer_popup"  style="display:none;" >
            <div class="pop_wrap size3">
                <div class="pop_tlt">
                    <h2 class="tlth2">아이콘 변경</h2> <span class="desc"></span></h2>
                    <a href="javascript:;" class="close ico_comm">닫기</a>
                </div>
                <form:form id="form_id_goods_icon" >
                <input type="hidden" name="goodsTypeCd" id="iconGoodsTypeCd" value="${menuType}">
                <div class="pop_con">
                    <div>
                        <div class="tblw" >
                            <table>
                                <caption>아이콘 변경</caption>
                                <colgroup>
                                    <col width="25%">
                                    <col width="85%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>아이콘</th>
                                        <td id="td_popup_icon_data" style="display: flex;"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_regist_goods_icon">적용하기</button>
                        </div>
                    </div>
                    <div>
                    </div>
                </div>
                </form:form>
            </div>
        </div>

        <div id="layer_upload_pop" class="layer_popup" style="display: none;">
            <div class="pop_wrap size3">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">상품업로드</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                    <!-- pop_con -->
                    <div class="pop_con">
                        <div>
                            <!-- tblw -->
                            <div class="tblw mt0">
                                <form:form id="form_excel_insert" action="javascript:excelUpload()" enctype="multipart/form-data">
                                <table summary="이표는 파일 업로드 표 입니다. 구성은 첨부파일 입니다.">
                                    <caption>파일 업로드</caption>
                                    <colgroup>
                                        <col width="10%">
                                        <col width="90%">
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>파일업로드</th>
                                            <td>
                                                <span class="intxt"><input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled"></span>
                                                <label class="filebtn" for="ex_file1_id">파일찾기</label>
                                                <input class="filebox" type="file" name="excel" id="ex_file1_id" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">

                                                <button class="btn_exlup" id="btn_excelUp">Excel upload <span class="ico_comm">&nbsp;</span></button>
                                                <button class="btn_exlup" id="btn_excelSample">템플릿 <span class="ico_comm">&nbsp;</span></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                </form:form>
                            </div>
                            <!-- //tblw -->
                            <div class="btn_box txtc">
                                <button class="btn green" id="btn_confirm_bottom_logo_upload">확인</button>
                            </div>
                        </div>
                    </div>
                    <!-- //pop_con -->
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
