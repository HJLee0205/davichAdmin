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
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<c:set var="menuType" value="${typeCd}"/>
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">상품관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 초기 데이터 조회
                var upCtgNo = '';
                if('${typeCd}' == '01') {
                    upCtgNo = '1';
                } else if('${typeCd}' == '02') {
                    upCtgNo = '2';
                }

                initDataLoad('2', upCtgNo);

                // 카테고리 이벤트
                $('#sel_ctg_2').on('change', function() {
                    changeCategoryOptionValue('3', $(this));
                    $('#opt_ctg_3_def').focus();
                });

                // 검색
                $('#btn_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#hd_page').val('1');
                    getSearchGoodsData();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_search').trigger('click') });

                // 엑셀 다운로드
                $('#btn_download').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    fn_downloadExcel();
                });

                // 선택삭제
                $('#btn_delete').on('click', function() {
                    fn_delete();
                });

                // 품절
                $('#btn_soldout').on('click', function() {
                    fn_soldout();
                });

                // 판매중지
                $('#btn_salestop').on('click', function() {
                    fn_salestop();
                });

                // 판매중
                $('#btn_salestart').on('click', function() {
                    fn_salestart();
                });

                // 상품등록
                $('#btn_regist').on('click', function() {
                    fn_registGoods();
                });

                // 팝업 - 예상 배송 소요일 적용
                jQuery('#btn_regist_dlvr_date').off("click").on('click', function (e) {
                    console.log("btn_seller_regist_dlvr_date clicked");
                    Dmall.EventUtil.stopAnchorAction(e);
                    var selected = fn_selectedList(false);

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
                    var selected = fn_selectedList(false);

                    if (selected) {
                        var dlvrSetCd = $("input:radio[name='dlvrSetCd']:checked").val();
                        var goodseachDlvrc = $("#goodseachDlvrc").val();
                        var goodseachcndtaddDlvrc = $("#goodseachcndtaddDlvrc").val();
                        var freeDlvrMinAmt = $("#freeDlvrMinAmt").val();
                        var packMaxUnit = $("#packMaxUnit").val();
                        var packUnitDlvrc = $("#packUnitDlvrc").val();

                        if (!dlvrSetCd) {
                            Dmall.LayerUtil.alert("배송비 정책을 선택해주세요.");
                            return false;
                        }

                        if ('3' === dlvrSetCd) {
                            if (goodseachDlvrc == '' || goodseachDlvrc == '0') {
                                Dmall.LayerUtil.alert('상품별 배송비 조건을 입력하세요.');
                                return false;
                            }
                        }

                        if ('6' === dlvrSetCd) {
                            if (goodseachcndtaddDlvrc == '' || goodseachcndtaddDlvrc == '0' || freeDlvrMinAmt == '') {
                                Dmall.LayerUtil.alert('상품별 배송비 조건을 입력하세요.');
                                return false;
                            }
                        }

                        if ('4' === dlvrSetCd) {
                            if (packMaxUnit == '' || packUnitDlvrc == '' || packUnitDlvrc == '0') {
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

                    var selected = fn_selectedList(false);
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
                    var selected = fn_selectedList(false);

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
                        if (!saleForeverYn) {
                            if (dcStartDttm == '' || (dcStartDttm.length > 0 && !Dmall.validation.date(dcStartDttm))) {
                                Dmall.LayerUtil.alert('상품 판매기간 시작일을 정확하게 입력해주세요.');
                                return false;
                            }
                            if (dcEndDttm == '' || (dcEndDttm.length > 0 && !Dmall.validation.date(dcEndDttm))) {
                                Dmall.LayerUtil.alert('상품 판매기간 종료일을 정확하게 입력해주세요.');
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
                                    Dmall.LayerPopupUtil.close('sale_price_confirm_popup');
                                    getSearchGoodsData();
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
            });

            // 초기 목록 조회
            function initDataLoad(ctgLvl, upCtgNo) {
                var $sel = $('#sel_ctg_2'),
                    url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl};

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    $sel.find('option').not(':first').remove();
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');
                    });

                    loadDefaultCondition();

                    getSearchGoodsData();
                });
            }

            function loadDefaultCondition() {
                var cookie = getCookie('SEARCH_SELLER_GOODS_LIST');

                if(!cookie) {
                    $('#btn_srch_cal_all').trigger('click');
                    return;
                } else {
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
                        $('#srch_sc01').val(cookieObj['searchDateFrom']);
                    }
                    if (cookieObj['searchDateTo']) {
                        $('#srch_sc02').val(cookieObj['searchDateTo']);
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
                        $('label[for=normalYn]').trigger('click');
                    }
                    if (cookieObj['newGoodsYn']) {
                        $('label[for=newGoodsYn]').trigger('click');
                    }
                    if (cookieObj['stampYn']) {
                        $('label[for=stampYn]').trigger('click');
                    }
                    if (cookieObj['mallOrderYn']) {
                        $('label[for=mallOrderYn]').trigger('click');
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
                    // 상품코드
                    if (cookieObj['goodsNo']) {
                        $('#txt_goods_no').val(cookieObj['goodsNo']);
                    }
                    // 검색어
                    if (cookieObj['searchWord']) {
                        $('#txt_search_word').val(cookieObj['searchWord']);
                    }
                }
            }

            // 하위 카테고리 정보 취득
            function getCategoryOptionValue(ctgLvl, $sel, upCtgNo) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl};

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
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

            // 상위 카테고리 설정에 따른 하위 카테고리 옵션값 변경
            function changeCategoryOptionValue(level, $target) {
                var $sel = $('#sel_ctg_' + level),
                    $label = $('label[for=sel_ctg_' + level + ']');

                $sel.find('option').not(':first').remove();
                $label.text( $sel.find("option:first").text() );

                getCategoryOptionValue(level, $sel, $target.val());
            }

            // 검색결과 취득
            function getSearchGoodsData() {
                deleteCookie('SEARCH_SELLER_GOODS_LIST');


                var url = '/admin/seller/goods/goods-list',
                    param = $('#form_id_search').serialize();

                var expdate = new Date();
                expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
                setCookie('SEARCH_SELLER_GOODS_LIST', JSON.stringify($('#form_id_search').serializeObject()), expdate);

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
                        $('#tr_no_goods_data').show();
                    } else {
                        $('#tr_no_goods_data').hide();
                    }

                    // 검색 갯수 처리
                    var cnt_total = result["filterdRows"];
                    cnt_total = (null == cnt_total) ? 0 : cnt_total;
                    $("#cnt_total").html(cnt_total);

                    // 페이징 처리
                    Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_goods_list', getSearchGoodsData);
                });
            }

            // 검색결과 바인딩
            function setGoodsData(goodsData, $tr) {
                var $tmpSearchResultTr = $("#tr_goods_data_template").clone().show().removeAttr("id").data('prev_data', goodsData);
                var trId = "tr_goods_" + goodsData.goodsNo;
                $($tmpSearchResultTr).attr("id", trId).addClass("searchGoodsResult");
                $('[data-bind="goodsInfo"]', $tmpSearchResultTr).DataBinder(goodsData);
                if ($tr) {
                    $tr.after($tmpSearchResultTr);
                } else {
                    $("#tbody_goods_data").append($tmpSearchResultTr);
                }
            }

            // 엑셀 다운로드
            function fn_downloadExcel() {
                // alert('미구현 기능 - 엑셀 다운로드');
                // 초기화
                $('#form_id_search').attr('action', '/admin/seller/goods/download-excel');
                // Dmall.AjaxUtil.getJSON(url, param, function(result) {
                // Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                $('#form_id_search').submit();
                // });
            }

            // 결과 행 - 상품 선택 체크박스 설정
            function setGoodsChkBox(data, obj, bindName, target, area, row) {
                var chkId = "chk_select_goods_" + data["goodsNo"]
                    , $input = obj.find('input')
                    , $label = obj.find('label');

                $input.removeAttr("id").attr("id", chkId).data("goodsNo", data["goodsNo"]);
                $label.removeAttr("id").attr("id", "lb_select_goods_" + data["goodsNo"]).removeAttr("for").attr("for", chkId);

                // 체크박스 클릭시 이벤트 설정
                $($label).off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = jQuery(this),
                        checked = !($input.prop('checked'));
                    $input.prop('checked', checked);
                    $this.toggleClass('on');
                });

                obj.append('<input type="hidden" name="goodsSaleStatusCd" value="'+ data['goodsSaleStatusCd'] +'">');
                obj.append('<input type="hidden" name="multiOptYn" value="'+ data['multiOptYn'] +'">');
            }

            // 결과 행 - 판매가 표시 설정
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

            // 결과 행 - 공급가 표시 설정
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

            // 결과 행 - 재고 표시 설정
            function setStockQtt(data, obj, bindName, target, area, row) {
                obj.html(data["stockQtt"]); //재고
            }

            // 결과 행 - 상품 판매상태 텍스트 설정
            function setGoodsStatusText(data, obj, bindName, target, area, row) {
                var goodsSaleStatusCd = data["goodsSaleStatusCd"];
                var goodsSaleStatusNm = data["goodsSaleStatusNm"];
                if(goodsSaleStatusCd==1){//판매중
                    goodsSaleStatusNm = '<font color="#64c6eb">'+goodsSaleStatusNm+'</font>';
                }else if(goodsSaleStatusCd==2){//품절
                    goodsSaleStatusNm = '<font color="#cd0a0a">'+goodsSaleStatusNm+'</font>';
                }else if(goodsSaleStatusCd==3){//판매대기
                    goodsSaleStatusNm = '<font color="#33be40">'+goodsSaleStatusNm+'</font>';
                }else if(goodsSaleStatusCd==4){//판매중지
                    goodsSaleStatusNm = '<font color="#363636">'+goodsSaleStatusNm+'</font>';
                }
                obj.append(goodsSaleStatusNm);
            }

            // 결과 행 - 수정 버튼 설정
            function setGoodsEdit(data, obj, bindName, target, area, row) {
                obj.data("goodsNo", data["goodsNo"]);

                obj.off("click").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    executeGoodsEdit($(this));
                });
            }

            // 결과 행 - 복사 버튼 설정
            function setGoodsCopy(data, obj, bindName, target, area, row) {
                obj.data("goodsNo", data["goodsNo"]);
                obj.off("click").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    executeGoodsCopy($(this));
                });
            }

            // 수정 화면으로의 이동 처리
            function executeGoodsEdit(obj) {
                var trID = "tr_goods_" + obj.data("goodsNo");
                console.log("executeGoodsEdit goodsTypeCd = ", obj.data('goodsTypeCd'));
                $targetTr = $("#" + trID);
                location.href= "/admin/seller/goods/goods-detail-edit?goodsNo=" + obj.data('goodsNo') + "&typeCd=" + '${typeCd}';
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

            function openDlvrDatePop() {
                var selected = fn_selectedList(false);
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#div_dlvr_date_confirm'));
                }
            }

            function openDlvrCostPop() {
                var selected = fn_selectedList(false);
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#div_dlvr_cost_confirm'));
                }
            }

            function openSalePricePop() {
                try {
                    $('#tbody_goods_data input:checked').each(function () {
                        if($(this).closest('label').siblings('input:hidden[name=multiOptYn]').val() == 'Y') {
                            throw new Error();
                        }
                    });

                    var selected = fn_selectedList(false);
                    if(selected) {
                        Dmall.LayerPopupUtil.open(jQuery('#sale_price_confirm_popup'));
                    }
                } catch(err) {
                    Dmall.LayerUtil.alert('다중옵션 상품이 선택되어 있습니다.<br>다중옵션 상품은 별도 수정 화면으로 진입하여 수정해주세요.');
                }
            }

            function openEventWordsPop() {
                var selected = fn_selectedList(false);
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#event_words_change_popup'));
                }
            }

            function openIconPop() {
                var selected = fn_selectedList(false);
                if(selected) {
                    Dmall.LayerPopupUtil.open(jQuery('#div_icon_confirm'));
                    IconSelectPopup._init(selected);
                }
            }

            // 선택삭제
            function fn_delete() {
                var selected = fn_selectedList(false);
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

            // 품절
            function fn_soldout() {
                var selected = fn_selectedList(true);
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
                var selected = fn_selectedList(true);
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
                var selected = fn_selectedList(true);

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
            function fn_selectedList(isStatus) {
                var selected = [];
                $('#tbody_goods_data input:checked').each(function() {
                    if(isStatus && $(this).closest('label').siblings('input:hidden[name=goodsSaleStatusCd]').val() == '3') {
                        Dmall.LayerUtil.alert('판매대기 중인 상품은 상태를 변경할 수 없습니다.');
                        return false;
                    }

                    selected.push($(this).data('goodsNo'));
                });
                if (selected.length < 1) {
                    Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
                    return false;
                }
                return selected;
            }

            // 상품등록
            function fn_registGoods() {
                // alert('미구현 기능 - 상품등록 (상품상세화면)');
                Dmall.FormUtil.submit('/admin/seller/goods/goods-detail', { typeCd: '${typeCd}' });
            }

            // 숫자 3자리 콤마 설정
            function numberWithCommas(x) {
                return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <sec:authentication property="details.session.sellerNo" var="sellerNo"></sec:authentication>
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품설정<span class="step_bar"></span> 상품관리<span class="step_bar"></span>
                </div>
                <c:if test="${typeCd eq '01'}">
                    <h2 class="tlth2">상품관리 -안경테</h2>
                </c:if>
                <c:if test="${typeCd eq '02'}">
                    <h2 class="tlth2">상품관리 -선글라스</h2>
                </c:if>
            </div>
            <div class="line_box">
                <form id="form_id_search">
                    <input type="hidden" name="page" id="hd_page" value="1" />
                    <input type="hidden" name="rows" id="hd_rows" value="" />
                    <input type="hidden" name="calindex" id="hd_calindex" value="3" />
                    <input type="hidden" name="menuType" id="menu_type" value="${typeCd}">
                    <div class="search_box">
                        <div class="search_tbl">
                            <table>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>카테고리</th>
                                        <td>
                                            <c:if test="${typeCd eq '01'}">
                                                <input type="hidden" name="searchCtg1" id="sel_ctg_1" value="1" />
                                            </c:if>
                                            <c:if test="${typeCd eq '02'}">
                                                <input type="hidden" name="searchCtg1" id="sel_ctg_1" value="2" />
                                            </c:if>
                                            <span class="select">
                                                <label for="sel_ctg_2">2차 카테고리</label>
                                                <select name="searchCtg2" id="sel_ctg_2">
                                                    <option value="" id="opt_ctg_2_def">2차 카테고리</option>
                                                </select>
                                            </span>
                                            <span class="select">
                                                <label for="sel_ctg_3">3차 카테고리</label>
                                                <select name="searchCtg3" id="sel_ctg_3">
                                                    <option value="" id="opt_ctg_3_def">3차 카테고리</option>
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>필터</th>
                                        <td>
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
                                    <%--<tr>
                                        <th>내 코드 정보</th>
                                        <td>
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
                                        </td>
                                    </tr>--%>
                                    <tr>
                                        <th>상품 등록일</th>
                                        <td id="td_cal" data-index="6">
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
                                        <th>가격</th>
                                        <td>
                                            <span class="intxt"><input type="text" name="searchPriceFrom" id="txt_search_price_from" class="txtr comma" maxlength="10"></span>
                                            &nbsp;&nbsp; ~ &nbsp;&nbsp;
                                            <span class="intxt"><input type="text" name="searchPriceTo" id="txt_search_price_to" class="txtr comma" maxlength="10" style="width:173px;"></span>&nbsp;&nbsp; 원 까지
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>상품 유형</th>
                                        <td>
                                            <tags:checkbox id="normalYn" name="normalYn" compareValue="" text="일반" value="Y"/>
                                            <tags:checkbox id="newGoodsYn" name="newGoodsYn" compareValue="" text="신상품" value="Y"/>
                                            <tags:checkbox id="mallOrderYn" name="mallOrderYn" compareValue="" text="웹발주용" value="Y"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>판매 상태</th>
                                        <td id="td_goodsStatus">
                                            <cd:checkboxUDV codeGrp="GOODS_SALE_STATUS_CD" name="goodsStatus" idPrefix="goodsStatus" usrDfn1Val="DISP"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>전시 상태</th>
                                        <td id="td_goodsDisplay">
                                            <tags:checkboxs codeStr="Y:전시;N:미전시" name="goodsDisplay" idPrefix="goodsDisplay"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>상품코드</th>
                                        <td>
                                            <span class="intxt long"><input type="text" name="goodsNo" id="txt_goods_no"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>검색어</th>
                                        <td>
                                            <input type="hidden" name="searchType" id="sel_search_type" value="6" />
                                            <div class="select_inp">
                                                <span class="intxt"><input type="text" name="searchWord" id="txt_search_word"></span>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--black product-management" id="btn_search">검색</button>
                        </div>
                    </div>
                </form>
                <div class="line_box_wrap">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total"></strong>개의 상품이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl excel_download_btn" id="btn_download">
                                <span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <div class="tblh">
                        <table style="table-layout: fixed;">
                            <colgroup>
                                <col width="66px">
                                <col width="66px">
                                <col width="100px">
                                <col width="20%">
                                <col width="12%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>
                                        <label for="allcheck" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="table" id="allcheck"></span>
                                        </label>
                                    </th>
                                    <th>번호</th>
                                    <th>이미지</th>
                                    <th>상품명</th>
                                    <th>상품코드</th>
                                    <th>브랜드</th>
                                    <c:if test="${typeCd ne '03' and typeCd eq '04'}">
                                        <th>판매가/<br>택배가</th>
                                    </c:if>
                                    <c:if test="${typeCd eq '03' or typeCd eq '04'}">
                                        <th>판매가</th>
                                    </c:if>
                                    <th>공급가</th>
                                    <th>재고</th>
                                    <th>판매상태</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_goods_data">
                                <tr id="tr_no_goods_data"><td colspan="11">데이터가 없습니다.</td></tr>
                                <tr id="tr_goods_data_template" style="display: none;">
                                    <td data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsChkBox">
                                        <label for="chk_select_goods_template" class="chack">
                                            <span class="ico_comm"><input type="checkbox" id="chk_select_goods_template" class="blind"></span>
                                        </label>
                                    </td>
                                    <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sortNum"></td>
                                    <td><img src="" data-bind="goodsInfo" data-bind-type="img" data-bind-value="goodsImg02"></td>
                                    <td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNm"></td>
                                    <td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNo"></td>
                                    <td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="brandNm"></td>
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
                                    <td data-bind="goodsInfo" data-bind-value="stockQtt" data-bind-type="function" data-bind-function="setStockQtt" ></td>
                                    <td data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusText"></td>
                                    <td>
                                        <div class="btn_gray4_wrap">
                                            <button class="btn_gray4" data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsEdit">수정</button>
                                            <button class="btn_gray4 btn_gray4_right" data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsCopy">복사</button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <div class="pageing" id="div_id_paging"></div>
                    </div>
                </div>
            </div>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <span class="Batch_change_nav">
                        <button class="btn--big btn--big-white change" id="btn_Batch_change">일괄변경 <span class="change_down_btn"></span></button>
                        <ul class="change_items">
                            <li><a class="changeitem" onclick="javascript:openDlvrDatePop();">예상 배송 소요일</a></li>
                            <li><a class="changeitem" onclick="javascript:openDlvrCostPop();">배송비 변경</a></li>
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
        <div id="div_dlvr_cost_confirm" class="slayer_popup"style="display:none;" >
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
                                </tbody>
                            </table>
                        </div>
                        </form:form>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_regist_dlvr_cost">적용하기</button>
                        </div>
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
                                        <td id="td_popup_icon_data"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--blue_small" id="btn_regist_goods_icon">적용하기</button>
                        </div>
                    </div>
                </div>
                </form:form>
            </div>
        </div>

        <!-- layer_popup -->
        <div id="layer_upload_pop" class="layer_popup">
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
        <!-- //layer_popup -->
    </t:putAttribute>
</t:insertDefinition>
