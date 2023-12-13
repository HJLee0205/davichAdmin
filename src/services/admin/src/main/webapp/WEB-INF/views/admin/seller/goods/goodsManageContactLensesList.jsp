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
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">상품관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {
                
                // 화면 초기화
                jQuery("#tr_goods_data_template").hide();
                jQuery('#tr_no_goods_data').show();
                getCategoryOptionValue('1', jQuery('#sel_ctg_1'));
                getBrandOptionValue(jQuery('#sel_brand'));

                
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

                // 전시 버튼
                jQuery('#btn_display').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_display();
                });

                // 미전시 버튼
                jQuery('#btn_no_display').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_noDisplay();
                });


                // 판매중지 버튼
                jQuery('#btn_salestop').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_salestop();
                });
                // 판매승인 버튼
                jQuery('#btn_salestart').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_salestart();
                });
                // 선택항목 저장 버튼
                jQuery('#btn_save').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_save();
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
                
                // 체크박스 이벤트 -- custom.js 에서 공통 처리..
                /*$(".chack").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = jQuery(this),
                        $input = $("#" + $this.attr("for")),
                        checked = !($input.prop('checked'));
                    $input.prop('checked', checked);
                    $this.toggleClass('on');
                })*/
                
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
                
                // 검색일자 기본값 선택
                jQuery('#btn_cal_3').trigger('click');
                
                // 팝업 테스틍용 - 삭제대상 
                jQuery('#btn_upload').off("click").on('click', function(e) {
                    Dmall.LayerPopupUtil.open($("#layer_upload_pop"));
                });



                loadDefaultCondition();
                
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_search').trigger('click') });
                
                // Validation 정의
                Dmall.validate.set('form_id_cmnCdGrp');
                
                Dmall.common.comma();
                Dmall.common.date();
            });

            // 기본 상태값 세팅...
            function loadDefaultCondition() {
                var cookie =  getCookie('SEARCH_GOODS_LIST');

                if (!cookie) {
                    return;
                } else {
                    // var cookieObj =  JSON.parse(getCookie('SEARCH_GOODS_LIST'));
                    var cookieObj =  jQuery.parseJSON(getCookie('SEARCH_GOODS_LIST'));
                    if (cookieObj['page']) {
                        $('#hd_page').val(cookieObj['page']);
                    }
                    if (cookieObj['calindex']) {
                        $('.btn_day', '#td_cal').eq(cookieObj['calindex']).trigger('click');
                    }
                    if (cookieObj['searchDateType']) {
                        $('#sel_search_date_type').find('option').each(function(){
                            if ($(this).val() == cookieObj['searchDateType']) {
                                $(this).attr("selected", "true");
                                $('label[for=sel_search_date_type]').html($(this).text());
                            } 
                        });
                    }
                    if (cookieObj['searchType']) {
                        $('#sel_search_type').find('option').each(function(){
                            if ($(this).val() == cookieObj['searchType']) {
                                $(this).attr("selected", "true");
                                $('label[for=sel_search_type]').html($(this).text());
                            } 
                        });
                    }
                    if (cookieObj['searchWord']) {
                        $('#txt_search_word').val(cookieObj['searchWord']);
                    }
                    
                    if (cookieObj['searchPriceFrom']) {
                        $('#txt_search_price_from').val(cookieObj['searchPriceFrom']);
                    }
                    if (cookieObj['searchPriceTo']) {
                        $('#txt_search_price_to').val(cookieObj['searchPriceTo']);
                    }
                                      
                    if (cookieObj['goodsStatus']) {
                        if (cookieObj['goodsStatus'] instanceof Array) { 
                            $.each(cookieObj['goodsStatus'], function(idx, obj) {
                                var id = $('input:checkbox[value='+ obj +']', '#td_goodsStatus').attr('id');
                                $('label[for='+ id +']', '#td_goodsStatus').trigger('click');
                            });
                        } else {
                            var id = $('input:checkbox[value='+ cookieObj['goodsStatus'] +']', '#td_goodsStatus').attr('id');
                            $('label[for='+ id +']', '#td_goodsStatus').trigger('click');
                        }
                    }
                    if (cookieObj['goodsDisplay']) {
                        if (cookieObj['goodsDisplay'] instanceof Array) {                        
                            $.each(cookieObj['goodsDisplay'], function(idx, obj) {
                                var id = $('input:checkbox[value='+ obj +']', '#td_goodsDisplay').attr('id');
                                $('label[for='+ id +']', '#td_goodsDisplay').trigger('click');
                            });
                        } else {
                            var id = $('input:checkbox[value='+ cookieObj['goodsDisplay'] +']', '#td_goodsDisplay').attr('id');
                            $('label[for='+ id +']', '#td_goodsDisplay').trigger('click');
                        }
                    }
                    if (cookieObj['searchBrand']) {
                        $('#sel_brand').data('searchBrand', cookieObj['searchBrand']);
                    }
                    if (cookieObj['searchCtg4']) {
                        $('#sel_ctg_4').data('searchCtgNo', cookieObj['searchCtg4']);
                    }
                    if (cookieObj['searchCtg3']) {
                        $('#sel_ctg_3').data('searchCtgNo', cookieObj['searchCtg3']);
                    }
                    if (cookieObj['searchCtg2']) {
                        $('#sel_ctg_2').data('searchCtgNo', cookieObj['searchCtg2']);
                    }
                    if (cookieObj['searchCtg1']) {
                        $('#sel_ctg_1').data('searchCtgNo', cookieObj['searchCtg1']);
                    }
                    loadCategoryOptionValue('1', jQuery('#sel_ctg_1'), '', $('#sel_ctg_1').data('searchCtgNo'));
                }
            }
            
            // 상품 팝업 리턴 콜백함수 - 테스트용
            function fn_callback_pop_goods(data) {
                alert('상품 선택 팝업 리턴 결과 :' + data["goodsNo"] + ', data :' + JSON.stringify(data));
            }

            // 상품 등록 팝업 호출
            function fn_registGoods() {
                // alert('미구현 기능 - 상품등록 (상품상세화면)');
                location.href= "/admin/seller/goods/goods-detail";
            }

            // 엑셀 다운로드
            function fn_downloadExcel() {
                // alert('미구현 기능 - 엑셀 다운로드');
                // 초기화
                jQuery('#form_id_search').attr('action', '/admin/seller/goods/download-excel');
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

            // 전시처리
            function fn_display() {
                var selected = fn_selectedList();
                if (selected) {
                    Dmall.LayerUtil.confirm('상품의 전시 상태를 전시로 변경하시겠습니까?', function() {
                        var url = '/admin/goods/display-update',
                            param = {},
                            key;

                        if (selected) {
                            jQuery.each(selected, function(i, o) {
                                key = 'list[' + i + '].goodsNo';
                                param[key] = o;

                                key = 'list[' + i + '].dispYn';
                                param[key] = "Y";
                            });

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                getSearchGoodsData();
                            });
                        }
                    });
                }
            }

            // 미전시처리
            function fn_noDisplay() {
                var selected = fn_selectedList();
                if (selected) {
                    Dmall.LayerUtil.confirm('상품의 전시 상태를 미전시로 변경하시겠습니까?', function() {
                        var url = '/admin/goods/display-update',
                            param = {},
                            key;

                        if (selected) {
                            jQuery.each(selected, function(i, o) {
                                key = 'list[' + i + '].goodsNo';
                                param[key] = o;

                                key = 'list[' + i + '].dispYn';
                                param[key] = "N";
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

            // 판매승인
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

            // 수정항목 저장 실행
            function fn_save() {
                var selected = fn_selectedList();
                if (selected) {
                    Dmall.LayerUtil.confirm('수정한 상품 정보를 저장하시겠습니까?', function() {
                        var url = '/admin/goods/goods-status-update',
                            param = {},
                            key,
                            rowid
                            ;
                        
                        jQuery.each(selected, function(i, o) {
                            key = 'list[' + i + '].goodsNo';
                            param[key] = o;
                            key = 'list[' + i + '].goodsSaleStatusCd';
                            //param[key] = $('#sel_st_' + o).val();
                            var curSt = $('#input_status_' + o).val();
							if (curSt == "1") {                            
                            	param[key] = "3"; //판매대기로 변경
                        	}
                            key = 'list[' + i + '].dispYn';
                            param[key] = $('#sel_disp_' + o).val();
                            key = 'list[' + i + '].itemNo';
                            param[key] = $('#input_itemNo_' + o).val();

                            key = 'list[' + i + '].salePrice';
                            param[key] = $('#input_salePrice_' + o).val().replaceAll(",","");

                            key = 'list[' + i + '].supplyPrice';
                            param[key] = $('#input_supplyPrice_' + o).val().replaceAll(",","");

                            key = 'list[' + i + '].stockQtt';
                            param[key] = $('#input_stockQtt_' + o).val().replaceAll(",","");


                        });         

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                            getSearchGoodsData();
                        });
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
                    alert('선택된 상품이 없습니다.');
                    return false;   
                }
                return selected;
            }

            // 검색결과 취득
            function getSearchGoodsData() {
                // 초기화
                setDefaultValue();
            
                if ($('#td_cal').data('index') != null ) {
                    $('#hd_calindex').val($('#td_cal').data('index'))
                }
                var url = '/admin/seller/goods/goods-list',
                    param = $('#form_id_search').serialize();

                var expdate = new Date();
                expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
                setCookie('SEARCH_GOODS_LIST', JSON.stringify($('#form_id_search').serializeObject()), expdate);
  
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
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
                    var cnt_search = result["filterdRows"],
                        cnt_search = null == cnt_search ? 0 : cnt_search;
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
                    var $this = jQuery(this),
                        checked = !($input.prop('checked'));
                    $input.prop('checked', checked);
                    $this.toggleClass('on');
                });
            }          

            // 결과 행의 카테고리 표시 설정
            function setGoodsCtg(data, obj, bindName, target, area, row) {
                var ctgArr = (data["ctgArr"]) ? data["ctgArr"].split(",") : null;
                var ctgCmsRateArr = (data["ctgCmsRateArr"]) ? data["ctgCmsRateArr"].split(",") : null;
                var dlgtCtgArr = (data["dlgtCtgArr"]) ? data["dlgtCtgArr"].split(",") : null;
                var html = "";
                $.each( ctgArr, function( index, value ){
                    //html +=  value +(dlgtCtgArr[index]=="Y"?"("+ctgCmsRateArr[index]+"%)":"") +"<BR>" ;
                	html +=  value  +"<BR>" ;
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
                     itemId = 'input_itemNo_' + data["goodsNo"],
                     salePrice = data["salePrice"],//판매가격
                     supplyPrice = data["supplyPrice"],//공급가격
                     sepSupplyPriceYn = data["sepSupplyPriceYn"],//별도공급가격 적용여부
                     sellerCmsRate = data["sellerCmsRate"];//판매자 수수료율
                     
                var ctgCmsRateArr = (data["ctgCmsRateArr"]) ? data["ctgCmsRateArr"].split(",") : null;
                var dlgtCtgArr = (data["dlgtCtgArr"]) ? data["dlgtCtgArr"].split(",") : null;

                var ctgCmsRate = 0;// 카테고리 수수료

                $.each( ctgCmsRateArr, function( index, value ){
                    ctgCmsRate = (dlgtCtgArr[index]=="Y"?ctgCmsRateArr[index]:0);
                });

                $input.removeAttr("id").attr("id", inputId);
                $input.next().removeAttr("id").attr("id", itemId);

                obj.val(salePrice);
                Dmall.common.comma();

                obj.on('keyup', function(e) {
                    //var _tdCommisionRate = $(this).parents('td').siblings('td[data-bind-value=commisionRate]');
                    var _inputSupplyPrice = $(this).parents('td').next().next().find("[name=supplyPrice]");
                    var salePrice = $(this).val().replaceAll(',', '');
                    var commisionRate=0;
                    var _recount = $(this).parents('td').next().next().find('div');//공급가,수수료율 영역
                    // 공급가 변경... (별도 공급가 적용 상품이 아닐경우만 변경 가능)
                    var supply_price =supplyPrice;

                    if(sepSupplyPriceYn!=null && sepSupplyPriceYn!="Y"){
                    	// 판매자 수수료율이 있을경우  판매자 수수료율을 우선 적용
                    	if (sellerCmsRate > 0) {
                            //카테고리 수수료율 적용
                            var supply_price = salePrice*(1-(sellerCmsRate/100))
                            $(_inputSupplyPrice).val(numberWithCommas(supply_price));
                            // 카테고리 수수료율 적용
                            commisionRate = Math.round((salePrice-supply_price)/salePrice*100);
                    	} else {
                            //카테고리 수수료율 적용
                            var supply_price = salePrice*(1-(ctgCmsRate/100))
                            $(_inputSupplyPrice).val(numberWithCommas(supply_price));
                            // 카테고리 수수료율 적용
                            commisionRate = Math.round((salePrice-supply_price)/salePrice*100);
                    	}
                    }else{
                        // 수수료율 다시계산
                        commisionRate = Math.round((salePrice-supply_price)/salePrice*100);
                    }
                    // 수수료율
                    //_tdCommisionRate.html(commisionRate+'%');


                    _recount.html(numberWithCommas(supply_price)+"<br>"+commisionRate+'%');

                });
            }

            // 결과 행의 공급가 표시 설정
            function setSupplyPrice(data, obj, bindName, target, area, row) {

                var $input = obj,
                    inputId = 'input_supplyPrice_' + data["goodsNo"],
                    supplyPrice = data["supplyPrice"],//공급가격
                    commisionRate  = data["commisionRate"], //수수료율
                    goodseachDlvrc = data["goodseachDlvrc"]//배송비
                    ;

                $input.removeAttr("id").attr("id", inputId);

                obj.val(supplyPrice);
                obj.after("<div>"+numberWithCommas(supplyPrice)+"<br>"+commisionRate+"</div>"+numberWithCommas(goodseachDlvrc));
            }

            // 결과 행의 재고 표시 설정
            function setStockQtt(data, obj, bindName, target, area, row) {

                var $input = obj,
                    inputId = 'input_stockQtt_' + data["goodsNo"],
                    stockQtt = data["stockQtt"];//공급가격

                $input.removeAttr("id").attr("id", inputId);

                obj.val(stockQtt);
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
                    goodsSaleStatusNm = '<font color="#64c6eb">'+goodsSaleStatusNm+'</font>';
                }else if(goodsSaleStatusCd==2){//품절
                    goodsSaleStatusNm = '<font color="#cd0a0a">'+goodsSaleStatusNm+'</font>';
                }else if(goodsSaleStatusCd==3){//판매대기
                    goodsSaleStatusNm = '<font color="#33be40">'+goodsSaleStatusNm+'</font>';
                }else if(goodsSaleStatusCd==4){//판매중지
                    goodsSaleStatusNm = '<font color="#363636">'+goodsSaleStatusNm+'</font>';
                }
                //obj.html(goodsSaleStatusNm);
                obj.append(goodsSaleStatusNm);
            }
            
            //  상품 판매상태 설정
            function setGoodsStatusInput(data, obj, bindName, target, area, row) {

                var $input = obj,
                    inputId = 'input_status_' + data["goodsNo"],
                    stCd = data["goodsSaleStatusCd"];//상태
                    
                $input.removeAttr("id").attr("id", inputId);
                obj.val(stCd);
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
                
//                 if(dispYn=="Y"){//전시
//                     dispNm = '<a href="javascript:;" class="btn_gray2" style="background-color:#33be40;" onclick="javascript:setDisplay(\''+data['goodsNo']+'\')">전시</a>'
//                 }else if(dispYn=="N"){//미전시
//                     dispNm = '<a href="javascript:;" class="btn_gray2" style="background-color:#cd0a0a;" onclick="javascript:setNoDisplay(\''+data['goodsNo']+'\')">미전시</a>';
//                 }
                
                if(dispYn=="Y"){//전시
                    dispNm = '전시'
                }else if(dispYn=="N"){//미전시
                    dispNm = '미전시';
                }

                obj.html(dispNm);

            }

            // 결과 행의 수정 버튼 설정
            function setGoodsEdit(data, obj, bindName, target, area, row) {
                obj.data("goodsNo", data["goodsNo"]);
                   
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
                location.href= "/admin/seller/goods/goods-detail-edit?goodsNo=" + obj.data('goodsNo');
            }

            // 수정 화면으로의 이동 처리
            function executeGoodsEdit(obj) {
                var trID = "tr_goods_" + obj.data("goodsNo");             
                $targetTr = $("#" + trID);
                location.href= "/admin/seller/goods/goods-detail-edit?goodsNo=" + obj.data('goodsNo');
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
                        prev_data =$tr.data('prev_data')
                        ;                    

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        //
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

            // 브랜드 정보 취득
            function getBrandOptionValue($sel) {
                var url = '/admin/goods/brand-list',
                    param = '';
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        var selectedValue = $('#sel_brand').data('searchBrand');
                        if (selectedValue && selectedValue === obj.brandNo) {
                            $sel.append('<option value="'+ obj.brandNo + '" selected>'+ obj.brandNm + '</option>');  
                            $('label[for='+ $sel.attr('id') +']', $sel.parent()).html(obj.brandNm);                            
                        } else {
                            $sel.append('<option value="'+ obj.brandNo + '">' + obj.brandNm + '</option>');   
                        }
                    });
                });   
            }

            // 상품 엑셀 업로드 테스트용
            function excelUpload() {
                
                if(jQuery('#file_route1').val()=='파일선택')
                    return;
                if(Dmall.validate.isValid('form_excel_insert')) {
                    var url = '/admin/seller/goods/goods-excel-upload';
                    
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
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <sec:authentication property="details.session.sellerNo" var="sellerNo"></sec:authentication>
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">판매상품관리 </h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue"  id="btn_regist">상품등록</a>
                </div>

            </div>
        <!-- search_box -->
        <form:form id="form_id_search" >
        <input type="hidden" name="page" id="hd_page" value="1" />
        <input type="hidden" name="sord" id="hd_srod" value="" />
        <input type="hidden" name="rows" id="hd_rows" value="" />
        <input type="hidden" name="calindex" id="hd_calindex" value="3" />
        <div class="search_box">
            <!-- search_tbl -->
            <div class="search_tbl">
                <table summary="이표는 판매상품관리 검색 표 입니다. 구성은 카테고리, 브랜드, 기간, 상품가격, 판매상태, 전시상태, 판매자, 검색어 입니다.">
                    <caption>판매상품관리 검색</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>카테고리</th>
                            <td id="td_goods_select_ctg">
                                <span class="select">
                                    <label for="sel_ctg_1"></label>
                                    <select name="searchCtg1" id="sel_ctg_1">
                                        <option id="opt_ctg_1_def" value="">1차 카테고리</option>
                                    </select>
                                </span>
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
                                <span class="select">
                                    <label for="sel_ctg_4"></label>
                                    <select name="searchCtg4" id="sel_ctg_4">
                                        <option id="opt_ctg_4_def" value="">4차 카테고리</option>
                                    </select>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>브랜드</th>
                            <td>
                                <span class="select" style="width: 246px;">
                                    <label for="sel_brand"></label>
                                    <select name="searchBrand" id="sel_brand">
                                        <option value="">브랜드</option>
                                    </select>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>기간</th>
                            <td id="td_cal">
                                <span class="select">
                                    <label for="sel_search_date_type"></label>
                                    <select name="searchDateType" id="sel_search_date_type">>
                                        <tags:option codeStr="1:등록일;2:수정일" />
                                    </select>
                                </span>
                                <span class="intxt"><input type="text" name="searchDateFrom" id="txt_search_date_from" class="bell_date_sc date" data-validation-engine="validate[dateFormat, maxSize[10]]"></span>
                                <a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date01">달력이미지</a>
                                ~
                                <span class="intxt"><input type="text" name="searchDateTo" id="txt_search_date_to" class="bell_date_sc date" data-validation-engine="validate[dateFormat, maxSize[10]]"></span>
                                <a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date02">달력이미지</a>
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
                                <span class="intxt"><input type="text" name="searchPriceFrom" id="txt_search_price_from" class="txtr comma" maxlength="10"/></span> 원
                                ~
                                <span class="intxt"><input type="text" name="searchPriceTo" id="txt_search_price_to" class="txtr comma" maxlength="10" /></span> 원
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
                                <label for="chack00_2" class="chack mr20">
    			                        <input type="checkbox" name="goodsStatus" id="chack00_2" value="2" class="blind" />
                                        <span class="ico_comm">&nbsp;</span>
                                    품절
                                </label>
                                <label for="chack00_3" class="chack mr20">
	                                <input type="checkbox" name="goodsStatus" id="chack00_3" value="3" class="blind" />
                                    <span class="ico_comm">&nbsp;</span>
                                    판매대기
                                </label>
                                <label for="chack00_4" class="chack mr20">
	                                <input type="checkbox" name="goodsStatus" id="chack00_4" value="4" class="blind" />
                                    <span class="ico_comm">&nbsp;</span>
                                    판매중지
                                </label>
                                <a href="#none" id="goodsStatus" class="all_choice"><span class="ico_comm"></span> 전체</a>
                            </td>
                        </tr>
                        <tr>
                            <th>전시상태</th>
                            <td id="td_goodsDisplay">
                                <label for="chack01_1" class="chack mr20">
	                                <input type="checkbox" name="goodsDisplay" id="chack01_1" value="Y" class="blind" />
                                    <span class="ico_comm">&nbsp;</span>
                                    전시
                                </label>
                                <label for="chack01_2" class="chack mr20">
	                                <input type="checkbox" name="goodsDisplay" id="chack01_2" value="N" class="blind" />
                                    <span class="ico_comm">&nbsp;</span>
                                    미전시
                                </label>
                                <a href="#none" id="goodsDisplay"  class="all_choice"><span class="ico_comm"></span> 전체</a>
                            </td>
                        </tr>
                        <tr>
                            <th>검색어</th>
                            <td>
                                <div class="select_inp">
                                    <span>
                                        <label for="sel_search_type"></label>
                                        <select name="searchType" id="sel_search_type" >
                                            <tags:option codeStr="1:상품명;2:상품번호;3:모델명;4:제조사" />
                                        </select>
                                    </span>
                                    <input type="text" name="searchWord" id="txt_search_word" />
                                </div>
                            </td>
                        </tr>
                        <c:if test="${sellerNo eq '1'}">
                            <tr>
                                <th>다비젼상품코드</th>
                                <td>
                                    <span class="intxt"><input type="text" name="searchErpItmCd" id="txt_search_erp_itmcd" /></span>
                                </td>
                            </tr>
                            <tr>
                                <th>다비젼상품코드 여부</th>
                                <td>
                                    <label for="chack01_1" class="chack mr20">
                                        <input type="checkbox" name="erpMapYn" id="erpMapYn_1" value="Y" class="blind" />
                                        <span class="ico_comm">&nbsp;</span>
                                        매칭
                                    </label>
                                    <label for="chack01_2" class="chack mr20">
                                        <input type="checkbox" name="erpMapYn" id="erpMapYn_2" value="N" class="blind" />
                                        <span class="ico_comm">&nbsp;</span>
                                        비매칭
                                    </label>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <!-- //search_tbl -->
            <div class="btn_box txtc">
                <button class="btn green" id="btn_search">검색</button>
            </div>
        </div>
        </form:form>
        <!-- //search_box -->

        <!-- line_box -->
        <div class="line_box">
            <div class="top_lay">
                <div class="search_txt">
                    검색 <strong class="be" id="cnt_search">0</strong>개 /
                    총 <strong class="all" id="cnt_total">0</strong>개
                </div>
                <div class="select_btn">
                    <span class="select">
                        <label for="sel_sord"></label>
                        <select name="sord" id="sel_sord">
                            <tags:option codeStr="REG_DTTM DESC:최근 등록일 순;REG_DTTM ASC:나중 등록일 순;UPD_DTTM DESC:최근 수정일 순;UPD_DTTM ASC:나중 수정일 순" />
                        </select>
                    </span>
                    <span class="select">
                        <label for="sel_rows"></label>
                        <select name="rows" id="sel_rows">
                            <tags:option codeStr="10:10개 출력;50:50개 출력;100:100개 출력;200:200개 출력" />
                        </select>
                    </span>
                    <button class="btn_exl"  id="btn_download">Excel download <span class="ico_comm">&nbsp;</span></button>
                    <button class="btn_exl"  id="btn_upload">Excel upload <span class="ico_comm">&nbsp;</span></button>
                </div>
            </div>
            <!-- tblh -->
            <div class="tblh">
                    <table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                        <caption>판매상품관리 리스트</caption>
                        <colgroup>
                            <col width="3%">
                            <col width="3%">
							<col width="120px">
							<col width="15%">
							<col width="18%">
							<col width="8%">
							<col width="7%">
							<col width="5%">
							<col width="8%">
							<col width="6%">
							<col width="6%">
							<col width="">
							<c:if test="${sellerNo eq '1'}">
                            <col width="">
                            </c:if>
						</colgroup>
						<!-- <colgroup>
                            <col width="3%">
                            <col width="3%"><%--번호--%>
                            <col width="6%"><%-- 이미지 --%>

                            <col width="10%"><%--카테고리--%>
                            <%--<col width="7%">--%>
                            <col width="19%"><%--상품명 [상품코드] --%>
                            <col width="6%"><%--판매자--%>
                            <col width="6%"><%--판매가--%>
                            <col width="6%"><%--재고--%>
                            <col width="10%"><%--공급가 수수료율(%) 배송비--%>
                            <%--<col width="4%">--%><%--수수료율(%)--%>
                            <%--<col width="6%">--%><%--배송비--%>
                            <col width="10%"><%--판매상태--%>
                            <col width="10%"><%--전시상태--%>
                            <col width="10%"><%--관리--%>
                        </colgroup> -->
                        <thead>
                            <tr>
                                <th>
                                    <label for="allcheck" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="allcheck" /></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>이미지</th>
                                <th>카테고리</th>
                                <%--<th>상품코드</th>--%>
                                <th>상품명<br>[상품코드]</th>
                                <th>판매자</th>
                                <th>판매가</th>
                                <th>재고</th>
                                <th>공급가<br>수수료율(%)<br>배송비</th>
                                <%--<th>수수료율(%)</th>
                                <th>배송비</th>--%>
                                <th>판매상태</th>
                                <th>전시상태</th>
                                <th>관리</th>
                                <c:if test="${sellerNo eq '1'}">
                                <th>다비젼<br>상품코드</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody id="tbody_goods_data">
                            <tr id="tr_goods_data_template" >
                                <td data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsChkBox">
                                    <label for="chk_select_goods_template" class="chack"><span class="ico_comm"><input type="checkbox" id="chk_select_goods_template" class="blind">&nbsp;</span></label>
                                </td>
                                <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="rownum" >1</td>
                                <td><img src="" data-bind="goodsInfo" data-bind-type="img" data-bind-value="goodsImg01"></td>

                                <td class="txtl" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setGoodsCtg" data-bind-value="goodsNo">대분류>중분류>소분류>세분류</td>
                                <%--<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNo">상품코드</td>--%>
                                <td class="txtl" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setGoodsDetail" data-bind-value="goodsNm"></td>
                                <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sellerNm" >판매자명</td>
                                <td>
                                    <span class="intxt">
                                        <input type="text" class="comma" name="salePrice" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSalePrice"  data-bind-value="salePrice" data-validation-engine="validate[required, maxSize[10]]" maxlength="10"><%--판매가--%>
                                        <input type="hidden" name="itemNo" data-bind="goodsInfo" data-bind-type="text" data-bind-value="itemNo">
                                        <input type="hidden" name="sepSupplyPriceYn" data-bind="goodsInfo" data-bind-type="text" data-bind-value="sepSupplyPriceYn">
                                        <input type="hidden" name="sellerCmsRate" data-bind="goodsInfo" data-bind-type="text" data-bind-value="sellerCmsRate">
                                    </span>
                                </td>
                                <%--<td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setGoodsQtt" data-bind-value="goodsNo">0/0</td>--%>
                                <td>
                                    <span class="intxt shot">
                                        <input type="text" class="comma" name="stockQtt" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setStockQtt" data-bind-value="stockQtt" data-validation-engine="validate[required, maxSize[5]]" maxlength="4"><%--재고--%>
                                    </span>
                                </td>
                                <td>
                                    <span class="intxt shot">
                                        <input type="hidden" class="comma" name="supplyPrice" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSupplyPrice"  data-bind-value="supplyPrice" data-validation-engine="validate[maxSize[10]]" maxlength="10" readonly><%--공급가--%>
                                    </span>
                                </td>
                                <%--<td data-bind="goodsInfo" data-bind-type="string" data-bind-value="commisionRate">수수료율</td>
                                <td data-bind="goodsInfo" data-bind-type="commanumber" data-bind-value="goodseachDlvrc" >0</td>--%>
                                <td data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusText">
									<input type="hidden" data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusInput">                                
                                
                                    <%--<span class="select shot2" id="span_goods_status_template">
                                        <label for="sel_test"></label>
                                        <select id="sel_test" name="goodsSaleStatusCd">
                                            <tags:option codeStr="1:판매중;2:품절;3:판매대기;4:판매중지" />
                                        </select>
                                    </span>--%>
                                </td>
                                <td data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsDisplayText">
                                    <%--<span class="select shot2" id="span_goods_disaplay_template">
                                        <label for="sel_display"></label>
                                        <select id="sel_display" name="dispYn">
                                            <tags:option codeStr="Y:전시;N:미전시" />
                                        </select>
                                    </span>--%>
                                </td>
                                <td>
                                    <button class="btn_gray" data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsEdit">수정</button>
                                    <button class="btn_gray" data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsCopy">복사</button>
                                </td>
                                <c:if test="${sellerNo eq '1'}">
                                <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
                                </c:if>
                            </tr>
                            <tr id="tr_no_goods_data">
                                <c:if test="${sellerNo eq '1'}">
                                    <td colspan="13">데이터가 없습니다.</td>
                                </c:if>
                                <c:if test="${sellerNo ne '1'}">
                                    <td colspan="12">데이터가 없습니다.</td>
                                </c:if>
                            </tr>
                        </tbody>
                    </table>
            </div>
            <!-- //tblh -->
            <!-- bottom_lay -->
             <div class="bottom_lay">
                <div class="left">
                    <div class="pop_btn">
<!--                         <a href="javascript:;" class="btn_gray2" id="btn_delete">삭제</a> -->
                        <a href="javascript:;" class="btn_gray2" id="btn_salestop">판매중지</a>
                        <a href="javascript:;" class="btn_gray2" id="btn_save">선택항목저장</a>
                        <a href="javascript:;" class="btn_gray2" style="background-color:#9f9f9f" id="btn_soldout">품절</a>
<!--                         <a href="javascript:;" class="btn_blue2" id="btn_salestart">판매중</a> -->
<!--                         <a href="javascript:;" class="btn_gray2" style="background-color:#33be40" id="btn_display">전시</a> -->
<!--                         <a href="javascript:;" class="btn_gray2" style="background-color:#cd0a0a" id="btn_no_display">미전시</a> -->
                    </div>
                </div>
                <%--<div class="right">
                    <div class="pop_btn">
                        <button class="btn_gray2"  id="btn_save">선택항목저장</button>
                        <!-- <button class="btn_gray2"  id="btn_pop_goods">- 상품검색 팝업 - 삭제대상</button> -->
                    </div>
                </div>--%>
                <div class="pageing"  id="div_id_paging"></div>
             </div>
            <!-- //bottom_lay -->
        </div>
        <!-- //line_box -->
    </div>
<!-- //content -->
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

    </t:putAttribute>
</t:insertDefinition>
