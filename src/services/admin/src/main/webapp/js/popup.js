/**
 * Created by dong on 2016-05-17.
 */

/**
 * 팝업별로 스크립트를 만들어 주세요
 *
 */


var admAuthConfigPopup = {
    init : function() {
        // 그룹명 입력란 이벤트 처리
        $('#input_id_authNm').on('change', function() {
            admAuthConfig.isChecked = false;
        });

        // 중복 확인 버튼 이벤트 처리
        $('#btn_id_checkDuplication').on('click', function (e) {
            Dmall.EventUtil.stopAnchorAction(e);

            var url = '/admin/setup/base/baseInfoConfig/adminAuthConfig/manager-group-detail',
                param = {},
                authNm = $('#input_id_authNm').val();

            if (jQuery.trim(authNm).length === 0) {
                Dmall.LayerUtil.alert("그룹명을 입력해주세요");
                return;
            }

            param.authNm = authNm;

            Dmall.AjaxUtil.getJSON(url, param, function (result) {
                if (result.data) {
                    Dmall.LayerUtil.alert("중복된 그룹명입니다.<br>다른 그룹명을 입력하여 주세요.");
                    $('#input_id_authNm').focus();
                } else {
                    Dmall.LayerUtil.alert("저장할 수 있는 그룹명입니다.");
                    admAuthConfig.isChecked = true;
                }
            });
        });

        // 수퍼 관리자 체크박스 체크 이벤트 처리
        $('#label_id_super').on('click', function (e) {
            var $this = $(this),
                checked = $this.hasClass('on');

            if (!checked) {
                $('#form_id_managerGrp input[name="menuId"]')
                    .not($('#input_id_super'))
                    .prop('checked', false)
                    .parents('label').removeClass('on');
            }
        });

        // 관리자 권한 그룹 저장 버튼 처리
        $('#btn_id_saveManagerAuthGrp').on('click', function () {
            if (admAuthConfig.isChecked !== true) {
                Dmall.LayerUtil.alert("중복확인을 먼저 해주세요.");
                return;
            }

            var url = '/admin/setup/base/baseInfoConfig/adminAuthConfig/manager-group-insert',
                param = {},
                authGrpNo = $('#input_id_authGrpNo').val(),
                authNm = $('#input_id_authNm').val(),
                menuId = [];

            $('#form_id_managerGrp input[name="menuId"]:checked').each(function (i, obj) {
                menuId.push(obj.value);
            });

            if (menuId.length == 0) {
                Dmall.LayerUtil.alert("관리권한을 선택해주세요.");
                return;
            }

            if ($('#input_id_authGrpNo').val() !== '') {
                url = '/admin/setup/base/baseInfoConfig/adminAuthConfig/manager-group-update';
            }

            param.authGrpNo = authGrpNo;
            param.authNm = authNm;
            param.menuId = menuId.join(',');

            Dmall.AjaxUtil.getJSON(url, param, function (result) {
                if (result.success) {
                    admAuthConfig.getAdmGrp();
                    Dmall.LayerPopupUtil.close();
                }
            });
        });
    }
};

/**
 * 상품 검색 팝업
 *
 */
var GoodsSelectPopup = {
    // 초기화
    // - 상품검색 초기화의 매개변수로 상품 선택시 호출할 callback 함수를 정의
    // - callback함수는 상품 검색 팝업을 호출한 jsp에 정의
    _init: function (callback) {

        // callback 설정
        var $layer = jQuery('#layer_popup_goods_select').data("bind-function", callback);
        // 화면 리셋
        $layer.find('form')[0].reset();
        jQuery('#txt_pop_search_word').val('');
        // jQuery('#txt_pop_search_price_from').val('0');
        // jQuery('#txt_pop_search_price_to').val('100000');
        // jQuery('label:first-child', $('#tb_goods_status')).trigger('click');
        // jQuery('label:first-child', $('#tb_goods_display')).trigger('click');
        jQuery("#tr_popup_goods_data_template").hide();
        jQuery('#tr_popup_no_goods_data').show();
        jQuery('#div_id_pop_paging').html("");

        $("#tbody_popup_goods_data").find(".searchGoodsResult").each(function () {
            $(this).remove();
        });

        jQuery('label', $('#td_pop_goods_select_ctg')).each(function (idx, obj) {
            var $sel = $("#" + $(this).attr("for"));
            $(this).text($sel.find("option:selected").text());
        });
        // 카테고리 1 정보 셋팅
        GoodsSelectPopup.getCategoryOptionValue('1', jQuery('#sel_pop_ctg_1'));

        // 상품 검색 버튼 클릭시
        jQuery('#btn_popup_goods_search').off().on('click', function (e) {
            Dmall.EventUtil.stopAnchorAction(e);

            jQuery('#hd_pop_page').val('1');
            GoodsSelectPopup.getSearchGoodsData();
        });

        // 카테고리1 셀렉트 변경시
        jQuery('#sel_pop_ctg_1').off().on('change', function (e) {
            GoodsSelectPopup.changeCategoryOptionValue('2', $(this));
            GoodsSelectPopup.changeCategoryOptionValue('3', $(this));
            GoodsSelectPopup.changeCategoryOptionValue('4', $(this));
            jQuery('#opt_ctg_2_def').focus();
        });

        // 카테고리2 셀렉트 변경시
        jQuery('#sel_pop_ctg_2').off().on('change', function (e) {
            GoodsSelectPopup.changeCategoryOptionValue('3', $(this));
            GoodsSelectPopup.changeCategoryOptionValue('4', $(this));
            jQuery('#opt_ctg_3_def').focus();
        });

        // 카테고리3 셀렉트 변경시
        jQuery('#sel_pop_ctg_3').off().on('change', function (e) {
            GoodsSelectPopup.changeCategoryOptionValue('4', $(this));
            jQuery('#opt_ctg_4_def').focus();
        });

        //엔터키 입력시 검색 기능
        Dmall.FormUtil.setEnterSearch('form_id_pop_search', function () {
            $('#btn_popup_goods_search').trigger('click')
        });

        Dmall.common.comma();
    },
    // 카테고리 변경시 하위 카테고리의 값을 변경 한다.
    changeCategoryOptionValue: function (level, $target) {
        var $sel = $('#sel_pop_ctg_' + level),
            $label = $('label[for=sel_pop_ctg_' + level + ']', '#td_pop_goods_select_ctg');

        $sel.find('option').not(':first').remove();
        $label.text($sel.find("option:first").text());

        if (level && level == '2' && $target.attr('id') == 'sel_pop_ctg_1') {
            GoodsSelectPopup.getCategoryOptionValue(level, $sel, $target.val());
        } else if (level && level == '3' && $target.attr('id') == 'sel_pop_ctg_2') {
            GoodsSelectPopup.getCategoryOptionValue(level, $sel, $target.val());
        } else if (level && level == '4' && $target.attr('id') == 'sel_pop_ctg_3') {
            GoodsSelectPopup.getCategoryOptionValue(level, $sel, $target.val());
        } else {
            return;
        }
    },
    // 하위 카테고리의 정보를 취득하여 셋팅
    getCategoryOptionValue: function (ctgLvl, $sel, upCtgNo) {

        if (ctgLvl != '1' && upCtgNo == '') {
            return;
        }
        var url = '/admin/goods/goods-category-list',
            param = {'upCtgNo': upCtgNo, 'ctgLvl': ctgLvl},
            dfd = jQuery.Deferred();

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result == null || result.success != true) {
                return;
            }
            $sel.find('option').not(':first').remove();
            jQuery.each(result.resultList, function (idx, obj) {
                $sel.append('<option id="opt_ctg_' + ctgLvl + '_' + idx + '" value="' + obj["ctgNo"] + '">' + obj["ctgNm"] + '</option>');
            });
            dfd.resolve(result.resultList);
        });
        return dfd.promise();
    },
    // 상품 검색 정보를 취득하여 셋팅
    getSearchGoodsData: function () {
        var url = '/admin/goods/goods-list',
            param = $('#form_id_pop_search').serialize(),
            dfd = jQuery.Deferred();

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result == null || result.success != true) {
                return;
            }

            // 기존 결과 삭제
            $("#tbody_popup_goods_data").find(".searchGoodsResult").each(function () {
                $(this).remove();
            });

            // 취득결과 셋팅
            jQuery.each(result.resultList, function (idx, obj) {
                GoodsSelectPopup.setGoodsData(obj);
            });
            dfd.resolve(result.resultList);

            // 결과가 없을 경우 NO DATA 화면 처리
            if ($("#tbody_popup_goods_data").find(".searchGoodsResult").length < 1) {
                jQuery('#tr_popup_no_goods_data').show();
            } else {
                jQuery('#tr_popup_no_goods_data').hide();
            }

            // 페이징 처리
            Dmall.GridUtil.appendPaging('form_id_pop_search', 'div_id_pop_paging', result, 'paging_id_pop_goods_list', GoodsSelectPopup.getSearchGoodsData);
        });
        return dfd.promise();
    },
    // 취득한 데이터를 검색결과에 바인딩
    setGoodsData: function (goodsData) {
        var $tmpSearchResultTr = $("#tr_popup_goods_data_template").clone().show().removeAttr("id");
        var trId = "tr_pop_goods_" + goodsData.goodsNo;
        $($tmpSearchResultTr).attr("id", trId).addClass("searchGoodsResult");
        $('[data-bind="popGoodsInfo"]', $tmpSearchResultTr).DataBinder(goodsData);
        $("#tbody_popup_goods_data").append($tmpSearchResultTr);
    },
    // row별 상품이미지와 상품명 표시처리
    setGoodsDetail: function (data, obj, bindName, target, area, row) {
        obj.html("");
        var imgPath = 'goodsImg02' in data && data['goodsImg02'] && data['goodsImg02'].length > 0 ? data['goodsImg02'] : '/admin/img/product/tmp_img02.png';
        var $tmpDetailImg = $("#td_popup_goods_detail_template").clone().show().removeAttr("id")
            .attr("id", "img_" + data["goodsNo"]).attr('src', _IMAGE_DOMAIN + imgPath);

        obj.append($tmpDetailImg);
    },
    // row별 등록 버튼 표시처리
    setGoodsSelect: function (data, obj, bindName, target, area, row) {
        obj.data("goodsNo", data["goodsNo"]).html('<a href="#none" class="btn_blue">등록</a>').off("click").on('click', function (e) {
            Dmall.EventUtil.stopAnchorAction(e);
            var t_data = data;
            GoodsSelectPopup.executeGoodsSelect($(this), t_data);
        });
    },
    // 등록 버튼 클릭 시 실행
    executeGoodsSelect: function (obj, data) {
        var func = jQuery('#layer_popup_goods_select').data("bind-function");
        // 초기화 시 설정된 callback 함수를 실행 한다.
        func = null != func && "function" == typeof func ? func.apply(null, [data]) : alert("callback함수의 설정이 올바르지 않습니다.");
        // Dmall.LayerPopupUtil.close();
    }
};

/**
 주문 반품/교환 팝업
 **/
var ordExchangePopup = {
    init: function () {

        // 교환 레이어 팝업 실행
        jQuery('#btn_exchange_go').on('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            var refundType = $(this).attr("refundType");

            $("#tbody_exchange_data_edit1").find(".searchExchangeResult").each(function () {
                $(this).remove();
            });
            $("#tbody_exchange_data_edit2").find(".searchExchangeResult").each(function () {
                $(this).remove();
            });

            jQuery("#tr_exchange_data_template_edit1").hide();
            jQuery("#tr_exchange_data_template_edit2").hide();

            var comma = ',';
            var ordNoArr = '', ordDtlSeqArr = '', claimQttArr = '';
            var estimateAmtArr = 0;

            if ($("[name=exchange_ordNo]:checked").length == 0) {
                alert("선택된 항목이 없습니다.");
                return false
            }

            $('input[name=exchange_ordNo]:checked').map(function () {
                if ($(this).val() != '') {
                    var strArr = $(this).val().split(':');
                    ordNoArr += strArr[0];
                    ordNoArr += comma;
                    ordDtlSeqArr += strArr[1];
                    ordDtlSeqArr += comma;
                    var _el = $(this).parents('tr').find('[name=claimQtt]');
                    if (_el.is('select')) {
                        claimQttArr += _el.find('option:selected').val();
                        claimQttArr += comma;
                    } else {
                        claimQttArr += _el.val();
                        claimQttArr += comma;
                    }
                }
            });

            var url = '/admin/order/exchange/exchange-list-layer',
                dfd = jQuery.Deferred();
            var param = {
                ordNoArr: ordNoArr,
                ordDtlSeqArr: ordDtlSeqArr,
                claimQttArr: claimQttArr,
                exchangeType: "V",
                refundType: refundType
            };
            Dmall.AjaxUtil.getJSON(url, param, function (result) {
                if (result == null || result.success != true) {
                    alert("데이터가 존재하지 않습니다.");
                    return;
                }

                // 취득결과 셋팅
                jQuery.each(result.resultList, function (idx, obj) {
                    console.log("obj = ", obj);
                    var trId1 = obj.ordNo + ":" + obj.ordDtlSeq + ":" + obj.ordDtlStatusCd + '_1';
                    var trId2 = obj.ordNo + ":" + obj.ordDtlSeq + ":" + obj.ordDtlStatusCd + '_2';
                    var goodsItemList = obj.goodsItemList;
                    var $tmpSearchResultTr = "";
//                           alert(obj.rownum);
                    var $tmpSearchResultTr1 = $("#tr_exchange_data_template_edit1").clone().show().removeAttr("id");
                    $($tmpSearchResultTr1).attr("id", trId1).addClass("searchExchangeResult");

                    /* 옵션세팅 */
                    var $sel = $($tmpSearchResultTr1).find("#select_exchangeOrdDtlItemNo");
                    if (goodsItemList != null && goodsItemList.length > 0) {
                        $sel.find('option').not(':first').remove();
                        $('label', $sel.parent()).text($sel.find("option:first").text());
                        jQuery.each(goodsItemList, function (idx, obj) {
                            $sel.append('<option value="' + obj.itemNo + '">' + obj.attrValue1 + '</option>');
                        });
                        $tmpSearchResultTr1.find('#exchangeOrdDtlItemNo').remove();

                    } else {
                        $sel.parent().parent().html('없음');
                    }

                    $('[data-bind="exchangeInfo"]', $tmpSearchResultTr1).DataBinder(obj);
                    $("#tbody_exchange_data_edit1").append($tmpSearchResultTr1);

                    //var $claimReason = $($tmpSearchResultTr1).find("#span_claimReasonCd_template");

                    console.log("obj.claimReasonCd = ", obj.claimReasonCd);

                    /*if(obj.claimReasonCd != ''){
                        var $claimreasonSel = $claimReason.children('select').eq(0);
                        $claimReason.children('label').eq(0).text(obj.claimReasonNm);
                        $claimreasonSel.find('option').not(':first').remove();
                        $claimreasonSel.siblings('label').text($claimreasonSel.find("option:first").text());
                        $claimreasonSel.append('<option value="' + obj.claimReasonCd + '">' + obj.claimReasonNm + '</option>');
                        $claimreasonSel.val(obj.claimReasonCd).prop("selected", true);

                    }*/
                    if (obj.returnCd != '') {
                        //$("#refundReturnCd").val(obj.returnCd);

                        $("#claimReturnCd").val(obj.returnCd).prop("selected", true);
                        $("#claimReturnCd2").text($("#claimReturnCd option:selected").text());
                        $("#orgRefundReturnCd").val(obj.returnCd);
                    }
                    if (obj.claimCd != '') {
                        //$("#refundClaimCd").val(obj.claimCd);
                        $("#claimExchangeCd").val(obj.claimCd).prop("selected", true);
                        $("#claimExchangeCd2").text($("#claimExchangeCd option:selected").text());

                    }
                    // 반품상태, 교환상태가 완료인 경우 수정 불가
                    if (obj.returnCd == '12' && obj.claimCd == '22') {
                        $("select[name=claimReturnCd]").attr("disabled", "disabled");
                        $("select[name=claimExchangeCd]").attr("disabled", "disabled");
                        $("select[name=claimReasonCd]").attr("disabled", "disabled");
                        jQuery('#btn_exchange_reg').hide();
                        jQuery('#btn_exchange_close').show();
                    } else {
                        $("select[name=claimReturnCd]").removeAttr("disabled");
                        $("select[name=claimExchangeCd]").removeAttr("disabled");
                        $("select[name=claimReasonCd]").removeAttr("disabled");

                        /*$("#claimReasonCd").val(obj.claimReasonCd).prop("selected", true);
                        $("#claimReasonCd2").text($("#claimReasonCd option:selected").text());*/
                        $("#claimReturnCd").val(obj.returnCd).prop("selected", true);
                        $("#claimReturnCd2").text($("#claimReturnCd option:selected").text());
                        $("#claimExchangeCd").val(obj.claimCd).prop("selected", true);
                        $("#claimExchangeCd2").text($("#claimExchangeCd option:selected").text());
                        jQuery('#btn_exchange_reg').show();
                        jQuery('#btn_exchange_close').hide();
                    }


                    // 교환상태가 완료인 경우
                    if (obj.claimCd == '22') {
                        obj.ordDtlSeq = '0';
//                           } else if(obj.claimExchangeCd=='60') { // 신청인 경우 취소 추가
//                               $('select[name=claimExchageCd]').map(function(index) {
//                                   if(index == idx+1) {
//                                       var o = new Option('교환취소', '03');
//                                       $(this).append(o);
//                                   }
//                               });
                    }
                    $("#claimMemo").val(obj.claimMemo);
                    /*$("#claimDtlReason").val(obj.claimDtlReason);*/
                    Dmall.DaumEditor.setContent('claimDtlReason', obj.claimDtlReason); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('claimDtlReason', obj.attachImages); // 에디터에 첨부 이미지 데이터 세팅


                    // 반품상태가 완료인 경우 수정 불가
                    if (obj.returnCd == '12') {
                        //$("select[name=claimReturnCd]").attr("disabled","disabled");
                        //$("select[name=claimReasonCd]").attr("disabled","disabled");
                    }
                    // 교환상태가 완료인 경우 수정 불가
                    if (obj.claimCd == '22') {
                        /* $("select[name=claimReturnCd]").attr("disabled","disabled");
                         $("select[name=claimReasonCd]").attr("disabled","disabled");
                         $("select[name=claimExchangeCd]").attr("disabled","disabled");*/
                    }

                });
            });
        });

        jQuery('#btn_exchange_close').on('click', function (e) {
            Dmall.LayerPopupUtil.close();
        });

        // 교환 레이어 완료 실행 :교환 확인
        jQuery('#btn_exchange_reg').on('click', function (e) {
            var url = '/admin/order/exchange/exchange-order-insert',
                dfd = jQuery.Deferred();
            var comma = ',';
            var claimNoArr = '', ordNoArr = '', ordDtlSeqArr = '', ordDtlGoodsNoArr = '', ordDtlItemNoArr = '',
                claimReasonCdArr = '',
                claimReturnCdArr = '', claimExchangeCdArr = '';
            var claimQttArr = '';

            var claimMemo = $('#claimMemo').val(), claimDtlReason = $('#claimDtlReason').val();
            var varCdArr = new Array();
            var errMsg = '';
            var curOrdStatusCd = $('#exchangeOrdStatusCd').val();

            $('input[name=exchangeOrdNo]:not([value=""])').map(function (i) {
                if (i != 0) ordNoArr += comma;
                ordNoArr += ($(this).val());

            });

            $('input[name=exchangeOrdDtlSeq]:not([value=""])').map(function (i) {
                if (i != 0) ordDtlSeqArr += comma;
                ordDtlSeqArr += ($(this).val());

            });
            $('input[name=exchangeClaimQtt]:not([value=""])').map(function (i) {
                if (i != 0) claimQttArr += comma;
                claimQttArr += ($(this).val());
            });

            $('input[name=exchangeClaimNo]:not([value=""])').map(function (i) {
                if (i != 0) claimNoArr += comma;
                claimNoArr += ($(this).val());
            });
            $('input[name=exchangeOrdDtlGoodsNo]:not([value=""])').map(function (i) {
                if (i != 0) ordDtlGoodsNoArr += comma;
                ordDtlGoodsNoArr += ($(this).val());

            });

            /*
            $('input[name=exchangeOrdDtlItemNo]:not([value=""])').map(function(i) {
                if(i != 0 )ordDtlItemNoArr += comma;
                ordDtlItemNoArr += ($(this).val());

            });
            */

            $('input[name=exchangeOrdDtlItemNo]:not([value=""]),select[name=exchangeOrdDtlItemNo] option:selected').map(function (i) {

                if ($(this).is("select")) {
                    if (i > 1) ordDtlItemNoArr += comma;
                    ordDtlItemNoArr += $(this).find('option:selected').val();

                } else {
                    if ($(this).val() != '') {
                        if (i > 1) ordDtlItemNoArr += comma;
                        ordDtlItemNoArr += ($(this).val());
                    }

                }


            });


            /* $('select[name=itemNo] option:selected').map(function(i) {
                    if(i>1 && $(this).val()=='') {
                      errMsg = '옵션을 선택하세요';
                      return;
                    }
                   if(i > 1 )ordDtlItemNoArr += comma;
                    ordDtlItemNoArr += ($(this).val());
              });*/

            $('select[name=claimReasonCd] option:selected').map(function (i) {
                if (i > 1 && $(this).val() == '') {
                    errMsg = '반품사유를 선택하세요.';
                    return;
                }
                if (i > 1) claimReasonCdArr += comma;
                claimReasonCdArr += ($(this).val());
            });

            $('select[name=claimReturnCd] option:selected').map(function (i) {
                if (i > 0 && $(this).val() == '') {
                    errMsg = '반품상태를 선택하세요';
                    return;
                }
                if (i != 0) claimReturnCdArr += comma;
                varCdArr.push($(this).val());
                claimReturnCdArr += ($(this).val());

            });
            $('select[name=claimExchangeCd] option:selected').map(function (index) {
                var isExCancel = false; //요청 철회
                $('select[name=claimReturnCd] option:selected').map(function (index2) {
                    if (index > 0 && index == index2) {
                        if ($(this).val() == '-')
                            isExCancel = true;
                    }
                });
                if (index > 0 && !isExCancel && $(this).val() == '') {
                    errMsg = '교환상태를 선택하세요';
                    return;
                }
                if ($(this).val() == '22' && index > 0 && varCdArr[index] != '12') { //교환 완료는 반품완료인 경우만 가능
                    errMsg = '교환완료는 반품완료인 경우만 변경 가능합니다.';
                }
                if (index != 0) claimExchangeCdArr += comma;
                claimExchangeCdArr += ($(this).val());

            });

            if (errMsg != '')
                Dmall.LayerUtil.alert(errMsg);
            else {
                /*var param = {ordNoArr : ordNoArr, ordDtlSeqArr : ordDtlSeqArr, ordDtlGoodsNoArr :ordDtlGoodsNoArr, ordDtlItemNoArr: ordDtlItemNoArr,
                        claimReasonCdArr : claimReasonCdArr, claimReturnCdArr : claimReturnCdArr, claimExchangeCdArr : claimExchangeCdArr,
                        claimDtlReason : claimDtlReason, claimMemo:claimMemo, curOrdStatusCd: curOrdStatusCd,claimQttArr:claimQttArr,claimNoArr:claimNoArr
                        };*/
                //              Dmall.FormUtil.submit(url, param);
                console.log("claimReasonCdArr = ", claimReasonCdArr);
                Dmall.DaumEditor.setValueToTextarea('claimDtlReason');  // 에디터에서 폼으로 데이터 세팅
                $('form[id=form_exchange_list] #ordNoArr').val(ordNoArr);
                $('form[id=form_exchange_list] #ordDtlGoodsNoArr').val(ordDtlGoodsNoArr);
                $('form[id=form_exchange_list] #ordDtlItemNoArr').val(ordDtlItemNoArr);
                $('form[id=form_exchange_list] #claimReasonCdArr').val(claimReasonCdArr);
                $('form[id=form_exchange_list] #claimReturnCdArr').val(claimReturnCdArr);
                $('form[id=form_exchange_list] #claimExchangeCdArr').val(claimExchangeCdArr);
                //$('claimDtlReason').val(claimDtlReason);
                //$('claimMemo').val(claimMemo);
                $('form[id=form_exchange_list] #curOrdStatusCd').val(curOrdStatusCd);
                $('form[id=form_exchange_list] #ordDtlSeqArr').val(ordDtlSeqArr);/*hidden*/
                $('form[id=form_exchange_list] #claimQttArr').val(claimQttArr);/*hidden*/
                $('form[id=form_exchange_list] #claimNoArr').val(claimNoArr);/*hidden*/

                $('form[id=form_exchange_list] #returnCd').val($('#claimReturnCd').val());/*hidden*/
                $('form[id=form_exchange_list] #claimCd').val($('#claimExchangeCd').val());/*hidden*/
                $('form[id=form_exchange_list] #ordNo').val($("#label_exchangeOrdNo").text());/*hidden*/
                var param = jQuery('#form_exchange_list').serialize();
                //param = param.replace(/&?[^=]+=&|&[^=]+=$/g,'');
                param = param.replace(/[^&]+=\.?(?:&|$)/g, '');


                console.log("param = ", param);
                if (ordNoArr.length > 1) { // 선택된 주문번호가 있을때만
                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if (result.success) {
                            $("#tbody_exchange_data_edit1").find(".searchExchangeResult").each(function () {
                                $(this).remove();
                            });
                            $("#tbody_exchange_data_edit2").find(".searchExchangeResult").each(function () {
                                $(this).remove();
                            });

                            jQuery("#tr_exchange_data_template_edit1").hide();
                            jQuery("#tr_exchange_data_template_edit2").hide();
                            $('#claimDtlReason').val("");
                            $('#claimMemo').val("");

                            //부모창이 반품 목록인 경우
                            if ($('#ord_search_btn').length) {
                                Dmall.LayerPopupUtil.close();
                                document.location.reload();
                                jQuery('#ord_search_btn').trigger('click');
                            } else {
                                Dmall.LayerPopupUtil.close();
                                document.location.reload();
                            }

                        }
                    });
                }

            }
        });


        // 환불, 취소 선택버튼
        jQuery('#btn_payCancel_go').on('click', function (e) {

            e.preventDefault();
            e.stopPropagation();
            $("#tbody_exchange_data").find(".searchExchangeResult").each(function () {
                $(this).remove();
            });

            jQuery("#tr_exchange_data_template").hide();
            jQuery('#tr_no_exchange_data').show();
            var comma = ',';
            var ordNoArr = ''
                , ordDtlSeqArr = ''
                , claimQttArr = ''
                , claimGoodsNoArr = ''
            ;
            var estimateAmtArr = 0;

            if ($("#exchange_ordNo:checked").length == 0) {
                alert("선택된 항목이 없습니다.");
                return false
            }
            ordNo = $("#label_exchangeOrdNo").text();
            $('input[name=exchange_ordNo]:checked').map(function () {
                if ($(this).val() != '') {
                    var strArr = $(this).val().split(':');
                    ordNoArr += strArr[0];
                    ordNoArr += comma;
                    ordDtlSeqArr += strArr[1];
                    ordDtlSeqArr += comma;
                    claimGoodsNoArr += strArr[2];
                    claimGoodsNoArr += comma;
                    var _el = $(this).parents('tr').find('[name=claimQtt]');
                    if (_el.is('select')) {
                        claimQttArr += _el.find('option:selected').val();
                        claimQttArr += comma;
                    } else {
                        claimQttArr += _el.val();
                        claimQttArr += comma;
                    }
                }
            });

            var url = '/admin/order/refund/paycancel-info-layer',
                dfd = jQuery.Deferred();
            var param = {
                ordNoArr: ordNoArr,
                ordDtlSeqArr: ordDtlSeqArr,
                claimQttArr: claimQttArr,
                claimGoodsNoArr : claimGoodsNoArr,
                ordNo: ordNo,
                refundType: "M"
            };
            Dmall.AjaxUtil.getJSON(url, param, function (result) {
                if (result == null || result.success != true) {
                    alert("데이터가 존재하지 않습니다.");
                    return;
                }

                // 취득결과 셋팅
                var chkCnt = 0;
                jQuery.each(result.data.claimGoodsVO, function (idx, obj) {
                    var trId = obj.ordNo + ":" + obj.ordDtlSeq;
                    var $tmpSearchResultTr = "";

                    var $tmpSearchResultTr = $("#tr_exchange_data_template").clone().show().removeAttr("id");
                    $($tmpSearchResultTr).attr("id", trId).addClass("searchExchangeResult");


                    $('[data-bind="exchangeInfo"]', $tmpSearchResultTr).DataBinder(obj);

                    $("#tbody_exchange_data").append($tmpSearchResultTr);
                    // 교환상태가 완료인 경우
                    if (obj.claimCd == '22') {
                        obj.ordDtlSeq = '0';
//                           } else if(obj.claimExchangeCd=='60') { // 신청인 경우 취소 추가
//                               $('select[name=claimExchageCd]').map(function(index) {
//                                   if(index == idx+1) {
//                                       var o = new Option('교환취소', '03');
//                                       $(this).append(o);
//                                   }
//                               });
                    }

                    /*                       if(obj.claimReasonCd!=''){
                                               $("#claimReasonCd").val(obj.claimReasonCd).prop("selected", true);
                                               $("#claimReasonCd2").text($("#claimReasonCd option:selected").text());
                                           }*/
                    chkCnt++
                });

                // 결제취소정보
                var objP = result.data.claimPayRefundVO;
                if (objP != null) {
                    // 부분취소 확인
                    if (chkCnt == $("#orgCnt").val()) {
                        $("#partCancelYn").val("N");
                    } else {
                        $("#partCancelYn").val("Y");

                        if (objP.escrowYn == 'Y') {
                            Dmall.LayerUtil.alert("에스크로는 부분취소 불가능합니다 ");
                            return false;
                        }

                        if (objP.payPgWayCd == '31') {
                            Dmall.LayerUtil.alert("페이코는 부분취소 불가능합니다 ");
                            return false;
                        }

                        if (objP.payPgWayCd == '41') {
                            Dmall.LayerUtil.alert("페이팔는 부분취소 불가능합니다 ");
                            return false;
                        }
                    }

                    $("#claimMemo").val(objP.claimMemo);
                    Dmall.DaumEditor.setContent('claimDtlReason', objP.claimDtlReason); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('claimDtlReason', objP.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                    /*$("#claimDtlReason").val(objP.claimDtlReason);*/
                    $("#payPgCd").val(objP.payPgCd);
                    $("#payPgWayCd").val(objP.payPgWayCd);
                    $("#payPgAmt").val(objP.payPgAmt);
                    $("#payUnpgCd").val(objP.payUnpgCd);
                    $("#payUnpgWayCd").val(objP.payUnpgWayCd);
                    $("#payUnpgAmt").val(objP.payUnpgAmt);
                    //$("#payReserveCd").val(objP.payReserveCd);
                    $("#payReserveWayCd").val(objP.payReserveWayCd);
                    $("#orgReserveAmt").val(objP.payReserveAmt);
                    $("#tempReserveAmt").html(objP.payReserveAmt);
                    $("#bankCd").val(objP.bankCd).prop("selected", true);
                    $("#bankCd2").text($("#bankCd option:selected").text());

                    $("#actNo").val(objP.actNo);
                    $("#holderNm").val(objP.holderNm);
                    $("#totalDlvrAmt").val(objP.totalDlvrAmt);
                    $("#restAmt").val(objP.restAmt);
                    $("#claimReasonCd").val(objP.claimReasonCd);
                    $("#realDlvrAmt").val(objP.realDlvrAmt);

                    /*  // 환불 금액
                      var eAmt = (objP.payPgAmt + objP.payUnpgAmt + objP.payReserveAmt) - objP.restAmt;
                      // pg전체 결제 금액
                      var tAmt = objP.payPgAmt + objP.payUnpgAmt + objP.payReserveAmt;
                      // pg전체 결제 금액
                      var pAmt = objP.payPgAmt + objP.payUnpgAmt;

                      $("#estimateAmt").html(eAmt);
                      $("#modifyAmt").val(eAmt);
                      $("#refundAmt").val(eAmt);*/

                    // 환불 금액
                    //var eAmt = (objP.payPgAmt + objP.payUnpgAmt + objP.payReserveAmt ) - objP.restAmt;
                    /*var eAmt = (objP.saleAmt * objP.claimQtt )-objP.dcAmt*/
                    var dlvrAmt = 0;
                    if(objP.dlvrAmt == null || objP.dlvrAmt == '' || objP.dlvrAmt == '0') {
                        if(objP.realDlvrAmt == null || objP.realDlvrAmt == '' || objP.realDlvrAmt == '0') {
                            dlvrAmt = objP.dlvrAddAmt;
                        } else {
                            dlvrAmt = objP.realDlvrAmt + objP.dlvrAddAmt;
                        }
                    } else {
                        dlvrAmt = objP.dlvrAmt + objP.dlvrAddAmt;
                    }
                    var eAmt = objP.eamt + dlvrAmt - objP.goodsDmoneyUseAmt;
                    // 전체 결제 금액
                    var tAmt = objP.orgPayPgAmt + objP.orgPayUnpgAmt;
                    // pg전체 결제 금액
                    var pAmt = objP.payPgAmt + objP.payUnpgAmt;

                    console.log(objP);
                    $("#restAmt").val(pAmt - eAmt);
                    $("#estimateAmt").html(commaNumber(eAmt));
                    $("#modifyAmt").val(commaNumber(eAmt));
                    $("#refundAmt").val(commaNumber(eAmt));

                    // 환불 금액 계산
                    if (objP.payUnpgAmt > 0) {
                        // 실제 환불금액
                        //if (eAmt < objP.payUnpgAmt) {
                            $("#pgAmt").val(commaNumber(eAmt));
                        /*} else {
                            $("#pgAmt").val(commaNumber(objP.payUnpgAmt));
                        }*/
                        $("#pgtype1").html("무통장 환불");
                        $("#pgType option:eq(1)").replaceWith("<option value='01' selected>무통장 환불</option>");
                        // $("#tempPgAmt").text(commaNumber(objP.orgPayUnpgAmt));
                        $("#tempPgAmt").text(commaNumber(eAmt));
                        jQuery('#bankInfo').show();

                    } else if (objP.payPgAmt > 0) {
                        // 실제 환불금액
                        //if (eAmt < objP.payPgAmt) {
                            $("#pgAmt").val(commaNumber(eAmt));
                        /*} else {
                            $("#pgAmt").val(commaNumber(objP.payPgAmt));
                        }*/

                        $("#pgType").val("02");

                        // 최초결제금액
                        $("#tempPgAmt").text(objP.payPgAmt);
                        //$("#tempPgAmt").text(eAmt);
                        $("#pgtype1").html("PG 환불");
                        $("#pgType option:eq(2)").replaceWith("<option value='02' selected>PG 환불</option>");
                        jQuery("#bankInfo").hide();

                    } else {
                        $("#pgType").val(0);
                        $("#tempPgAmt").text(0);
                        $("#pgAmt").val(0);

                        $("#pgtype1").html("");
                        $("#pgType option:eq(1)").replaceWith("<option value='01'>무통장 환불</option>");
                        $("#pgType option:eq(2)").replaceWith("<option value='02'>PG 환불</option>");
                        jQuery("#bankInfo").hide();
                    }

                    // 마켓포인트 환불 계산 최대금액측정
                    /*if (pAmt > eAmt) {
                        //alert("환불금액보다 pg 금액이크다");
                        $("#payReserveAmt").val(0);
                    } else if (pAmt < eAmt) {
                        //alert("환불금액보다 pg 금액이 작다");
                        $("#payReserveAmt").val(commaNumber(objP.goodsDmoneyUseAmt));
                    }*/
                    $("#payReserveAmt").val(commaNumber(objP.goodsDmoneyUseAmt));
                    // 부분취소 확인
                    if (eAmt != tAmt) {
                        $("#partCancelYn").val("Y");
                    } else {
                        $("#partCancelYn").val("N");
                    }

                    // 결과가 없을 경우 NO DATA 화면 처리
                    if ($("#tbody_exchange_data").find(".searchexchangeResult").length < 1) {
                        jQuery('#tr_no_exchange_data').show();
                    } else {
                        jQuery('#tr_no_exchange_data').hide();
                    }

                    /*$("input[name=refundAmt]").attr("disabled", "disabled");*/
                    /*$("select[name=pgType]").attr("disabled", "disabled");*/
                }
                preCheckGoods($("#exchange_ordNo:checked").length);
                curCheckGoods($("#exchange_ordNo:checked").length);
            });
        });

        // 결제 취소
        jQuery('#btn_payCancel_reg').on('click', function (e) {
            var claimCd = $(this).attr("claimCd");
            curCheckGoods($("#exchange_ordNo:checked").length);

            var curOrdStatusCd;
            $("#tbody_exchange_data").find(".searchExchangeResult").each(function () {
                curOrdStatusCd = $(this).children('input').eq(0).val();
            });
            if(curOrdStatusCd == '21') {
                Dmall.LayerUtil.alert("이미 결재취소 완료된 주문입니다. ");
                return false;
            }
            if ($('#curCheckGoods').val() != $('#preCheckGoods').val()) {
                Dmall.LayerUtil.alert("선택 적용을 다시 한번 눌려주세요. ");
                return false;
            }
            if ($('#estimateAmt').html() < $('#refundAmt').val()) {
                Dmall.LayerUtil.alert("환불 금액이 맞지않습니다.");
                $('#refundAmt').val($('#estimateAmt').html())
                return false;
            }

            /*console.log(" $('#refundAmt').val() = ", $('#refundAmt').val());
            console.log(" $('#payReserveAmt').val() = ", $('#payReserveAmt').val());*/
            if($('#payReserveAmt').val() != null && $('#payReserveAmt').val() != '') {
                var payReserveAmt = $('#payReserveAmt').val().replace(",", "");
                var pgAmt = ($('#pgAmt').val() != null && $('#pgAmt').val() != '') ? $('#pgAmt').val().replace(",", ""):0;
                var refundAmt = ($('#refundAmt').val() != null && $('#refundAmt').val()) != '' ? $('#refundAmt').val().replace(",", ""):0
                /*console.log(" payReserveAmt = ", payReserveAmt);
                console.log(" pgAmt = ", pgAmt);
                console.log(" refundAmt = ", refundAmt);*/
                if ((Number(payReserveAmt) + Number(pgAmt)) < Number(refundAmt)) {
                    Dmall.LayerUtil.alert("마켓포인트 금액이 맞지않습니다.");
                    //$('#payReserveAmt').val(0);
                    return false;
                }
            }

            if ($('#refundAmt').val() == 0 && Number($('#payReserveAmt').val()) == 0) {
                Dmall.LayerUtil.alert("환불 금액이 없습니다.");
                return false;
            }
            if (jQuery('#bankInfo').is(":visible")) {
                if ($('#bankCd').val() == '') {
                    Dmall.LayerUtil.alert("환불 받을 은행을 선택하세요 ");
                    return false;
                }

                if ($('#actNo').val() == '') {
                    Dmall.LayerUtil.alert("환불 받을 계좌번호를 입력하세요 ");
                    return false;
                }

                if ($('#holderNm').val() == '') {
                    Dmall.LayerUtil.alert("환불 받을 예금주명을 선택하세요 ");
                    return false;
                }

            }

            var url = "";
            //결제취소신청
            /*if (claimCd == '23') {
                url = '/admin/order/refund/refund-update';
            } else if (claimCd == '21') {
                //결제취소
                url = '/admin/order/manage/cancel-order';
            } else {
            }*/


            var dfd = jQuery.Deferred();
            var comma = ',';
            var claimNoArr = '', ordNoArr = '', ordDtlSeqArr = '', claimReasonCdArr = '',
                claimReturnCdArr = '', claimExchangeCdArr = '';
            var claimQttArr = '';
            var claimMemo = $('#claimMemo').val(), claimDtlReason = $('#claimDtlReason').val();
            var pgType = $('#pgType').val();
            var pgAmt = ($('#pgAmt').val() != null && $('#pgAmt').val() != '') ? $('#pgAmt').val().replace(",", "") : 0;
            var refundAmt = ($('#refundAmt').val() != null && $('#refundAmt').val() != '') ? $('#refundAmt').val().replace(",", "") : 0;
            var payReserveAmt = ($('#payReserveAmt').val() != null && $('#payReserveAmt').val() != '') ? $('#payReserveAmt').val().replace(",", "") : 0;
            var orgPgAmt = 0;
            var orgReserveAmt = $('#orgReserveAmt').val();
            var bankCd = $('#bankCd').val();
            var actNo = $('#actNo').val();
            var holderNm = $('#holderNm').val();
            var restAmt = $('#restAmt').val();
            var partCancelYn = $('#partCancelYn').val();
            var cancelType = $('#cancelType').val();
            var claimReasonCd = $('#claimReasonCd').val();
            var ordNo = "";

            var cancelStatusCd = "";

            var test = true;
            if (claimCd == '23') {

            } else if (claimCd == '21') {

            }
            if (claimCd == '23') {
                //결제취소신청
                url = '/admin/order/refund/refund-update';
                cancelStatusCd = "23";
                orgPgAmt = $('#tempPgAmt').html();
                //test = true;
            } else if (claimCd == '21') {
                //결제취소
                url = '/admin/order/manage/cancel-order';
                cancelStatusCd = "21";
                orgPgAmt = $('#orgPgAmt').val();
                //test = false;
            } else {
            }


            var varCdArr = new Array();
            var errMsg = '';
            var curOrdStatusCd = $('#exchangeOrdStatusCd').val();
            $('input[name=exchangeOrdNo]:not([value=""])').map(function (i) {
                // if (i != 0)
                ordNoArr += ($(this).val());
                ordNoArr += comma;

            });

            ordNo = $("#label_exchangeOrdNo").text();

            $('input[name=exchangeOrdDtlSeq]:not([value=""])').map(function (i) {
                //if (i != 0)
                ordDtlSeqArr += ($(this).val());
                ordDtlSeqArr += comma;

            });

            $('input[name=exchangeClaimQtt]:not([value=""])').map(function (i) {
                //if (i != 0)
                claimQttArr += ($(this).val());
                claimQttArr += comma;
            });

            $('input[name=exchangeClaimNo]:not([value=""])').map(function (i) {
                if (i != 0) claimNoArr += comma;
                claimNoArr += ($(this).val());
            });

            $('select[name=claimReasonCd]').map(function (index) {
                if (index > 0 && $(this).val() == '') {
                    errMsg = '반품사유를 선택하세요.';
                    return;
                }
                if (index != 0) claimReasonCdArr += comma;
                claimReasonCdArr += ($(this).val());

            });

            $('select[name=claimReturnCd]').map(function (index) {
                varCdArr.push($(this).val());
                if (index != 0) claimReturnCdArr += comma;
                claimReturnCdArr += ($(this).val());

            });
            $('select[name=claimExchangeCd]').map(function (index) {
                //alert($(this).val() +';'+ index +';'+varCdArr[index]);

                if ($(this).val() == '22' && index > 0 && varCdArr[index] != '12') { //교환 완료는 반품완료인 경우만 가능
                    errMsg = '교환완료는 반품완료인 경우만 변경 가능합니다.';
                }
                if (index != 0) claimExchangeCdArr += comma;
                claimExchangeCdArr += ($(this).val());

            });
            if (errMsg != '')
                Dmall.LayerUtil.alert(errMsg);
            else {
                var param = {
                    ordNoArr: ordNoArr,
                    ordDtlSeqArr: ordDtlSeqArr,
                    claimReasonCdArr: claimReasonCdArr,
                    claimReturnCdArr: claimReturnCdArr,
                    claimExchangeCdArr: claimExchangeCdArr,
                    claimDtlReason: claimDtlReason,
                    claimMemo: claimMemo,
                    curOrdStatusCd: curOrdStatusCd,
                    pgType: pgType,
                    pgAmt: pgAmt,
                    refundAmt: refundAmt,
                    payReserveAmt: payReserveAmt,
                    bankCd: bankCd,
                    actNo: actNo,
                    holderNm: holderNm,
                    partCancelYn: partCancelYn,
                    restAmt: restAmt,
                    orgReserveAmt: orgReserveAmt,
                    orgPgAmt: orgPgAmt,
                    cancelType: cancelType,
                    claimReasonCd: claimReasonCd,
                    ordNo: ordNo,
                    cancelStatusCd: cancelStatusCd,
                    claimQttArr: claimQttArr,
                    claimNoArr: claimNoArr,
                    claimCd: cancelStatusCd
                };
                //              Dmall.FormUtil.submit(url, param);

                console.log("param =", param);
                if (ordNoArr.length > 1) { // 선택된 주문번호가 있을때만
                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if (result.success) {
                            $("#tbody_exchange_data").find(".searchExchangeResult").each(function () {
                                $(this).remove();
                            });

                            jQuery("#tr_exchange_data_template").hide();
                            jQuery('#tr_no_exchange_data').show();
                            $('#claimDtlReason').val("");
                            $('#claimMemo').val("");
                            //부모창이 반품 목록인 경우
//                                 if( $('#ord_search_btn').length ) {
//                                     jQuery('#ord_search_btn').trigger('click');
//                                 } else {
                            Dmall.LayerPopupUtil.close();
                            document.location.reload();
//                                 }

                        }
                    });
                }
                Dmall.LayerPopupUtil.close();
            }
        });
    },

    // 교환 버튼 클릭 시 실행
    btnExchangeClick: function (ordNo, type, curOrdStatusCd, exchangeType) {

        if (type == 2) {// 교환
            $("#label_exchangeOrdNo").text(ordNo);
            $("#tbody_exchange_data_edit1").find(".searchExchangeResult").each(function () {
                $(this).remove();
            });
            $("#tbody_exchange_data_edit2").find(".searchExchangeResult").each(function () {
                $(this).remove();
            });
            jQuery("#tr_exchange_data_template_edit1").hide();
            jQuery("#tr_exchange_data_template_edit2").hide();
            $('#claimDtlReason').val("");
            $('#claimMemo').val("");
        } else if (type == 3 || type == 1) {
            // 환불, 결제취소
            $("#label_exchangeOrdNo").text(ordNo);
            $("#tbody_exchange_data").find(".searchExchangeResult").each(function () {
                $(this).remove();
            });
            jQuery("#tr_exchange_data_template").hide();
            jQuery('#tr_no_exchange_data').show();
            $('#claimDtlReason').val("");
            $('#claimMemo').val("");
            $("#estimateAmt").html(0);
            $("#modifyAmt").val(0);
            $("#refundAmt").val(0);
            $("#pgAmt").val(0);
            $("#orgPgAmt").html(0);
            $("#payReserveAmt").val(0);
            $("#orgReserveAmt").html(0);
            $("#pgtype1").html("");
            $("#pgType option:eq(0)").replaceWith("<option value='01'>무통장 환불</option>");
            $("#pgType option:eq(1)").replaceWith("<option value='02'>PG 환불</option>");

            $('#payReserveAmt, #modifyAmt, #pgAmt').on('keydown', function () {
                onlyNumberInput($(this));
                calcAmt();
            });

            $('#payReserveAmt, #modifyAmt, #pgAmt').on('keyup', function () {
                onlyNumberInput($(this));
                calcAmt();
            });
        }
        var url;
        var claimType;
        if (type == 2) {// 교환
            claimType = "E";
            Dmall.LayerPopupUtil.open(jQuery('#layout_exchange'));
        } else if (type == 1) {// 환불
            claimType = "R";
            Dmall.LayerPopupUtil.open(jQuery('#layout_refund'));
        } else if (type == 3) {// 취소
            claimType = "C";
            Dmall.LayerPopupUtil.open(jQuery('#layout_payCancel'));
        }
        url = "/admin/order/exchange/order-detail-exchange";

        $('#exchangeOrdStatusCd').val(curOrdStatusCd);

        var param = {ordNo: ordNo, claimType: claimType};
        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            console.log(result);
            var dfd = jQuery.Deferred();
            var template1_1 =
                '<input type="text" name="exchange_OrdStatusCd" id="exchange_OrdStatusCd" value="{{ordDtlSeq}}" />' +
                '<tr>' +
                '<td class="txtl">' +
                '<div class="item_box">';
            var template1_2 =
                '<tr>' +
                '<td>' +
                '<label for="exchange_ordNo" class="chack mr10">' +
                '<span class="ico_comm"><input type="checkbox" name="exchange_ordNo" id="exchange_ordNo" class="blind" value="{{ordNo}}:{{ordDtlSeq}}:{{goodsNo}}" /></span>' +
                '</label>' +
                '</td>' +
                '<td class="txtl">' +
                '<div class="item_box">';
            var template1_2_1 =
                '<tr>' +
                '<td>' +
                '</td>' +
                '<td class="txtl">' +
                '<div class="item_box">' ;
            var template2_2 =
                '<tr>' +
                '<td>' +
                '&nbsp;' +
                '</td>' +
                '<td class="txtl">' +
                '<div class="item_box">';
            var template1_3 =
                '<tr>' +
                '<td>' +
                '</td>' +
                '<td class="txtl">' +
                '<div class="item_box">';
            var template1_add =
                '<span class="addition" >' +
                '<img src="/admin/img/order/icon_addition.png" alt="추가상품" />' +
                '</span>';
            var template1_goods =
                '<a href="#none" class="goods_img"><img src="{{imgPath}}" alt="" /></a>' +
                '<a href="#none" class="goods_txt">' +
                '<span class="tlt">{{goodsNm}}</span>';
            var template2 =
                //'<c:if test="${orderGoodsVo.itemNm ne ''}">' +
                '<span class="option">' +
                /*'<span class="ico01">옵션</span> ' +*/
                '{{itemNm}}' +
                '</span>';
            var template3 =
                '<span class="code">[상품코드 : {{goodsNo}}]</span>';
            var template4 =
                //'<c:if test="${orderGoodsVo.addOptNm ne null}">' +
                '<span class="option">' +
                '<span class="ico01">추가옵션</span>{{addOptNm}}' +
                '</span>';
            var template5 =
                '</a>' +
                '</div>' +
                '</td>' +
                '<td>{{ordQtt}}</td>' +
                '<td class="txtc">';
            var template5_1 =
                '</td>' +
                '<td class="txtc">{{saleAmt}}</td>' +
                '<td class="txtc">{{dcAmt}}</td>';
            var template7 =
                '<td class="txtc">{{payAmt}}</td>';
            var templateEndTr = '</tr>';
            managerTemplate1_1 = new Dmall.Template(template1_1),
                managerTemplate1_2 = new Dmall.Template(template1_2),
                managerTemplate1_2_1 = new Dmall.Template(template1_2_1),
                managerTemplate2_2 = new Dmall.Template(template2_2),
                managerTemplate1_3 = new Dmall.Template(template1_3),
                managerTemplate1_add = new Dmall.Template(template1_add),
                managerTemplate1_goods = new Dmall.Template(template1_goods),
                managerTemplate2 = new Dmall.Template(template2),
                managerTemplate3 = new Dmall.Template(template3),
//                managerTemplate4 = new Dmall.Template(template4),
                managerTemplate5 = new Dmall.TemplateNoFormat(template5),
                managerTemplate5_1 = new Dmall.TemplateNoFormat(template5_1),
                //managerTemplate7 = new Dmall.TemplateNoFormat(template7),
//                managerTemplate7 = new Dmall.Template(template7),

                tr = '';
            var orgCnt = 0;
            jQuery.each(result.data.orderGoodsVO, function (idx, obj) {
                if (exchangeType == "M") {
                    var _claimQtt = obj.ordQtt - obj.claimQtt;
                    if (type == 1) {// 환불
                        if (obj.addOptYn == 'N') {
                            if (_claimQtt == 0) {
                                tr += managerTemplate2_2.render(obj);
                            } else {
                                console.log("obj.ordDtlStatusCd = ", obj.ordDtlStatusCd);
                                if(obj.ordDtlStatusCd == '40'
                                    || obj.ordDtlStatusCd == '75') {
                                    tr += managerTemplate1_2_1.render(obj);
                                } else {
                                    tr += managerTemplate1_2.render(obj);
                                }
                            }
                        } else {
                            tr += managerTemplate1_3.render(obj);
                        }

                    } else if (type == 2) {// 교환
                        if (obj.addOptYn == 'N')
                            if (_claimQtt == 0) {
                                tr += managerTemplate2_2.render(obj);
                            } else {
                                if(obj.ordDtlStatusCd == '40'
                                    || obj.ordDtlStatusCd == '75') {
                                    tr += managerTemplate1_2_1.render(obj);
                                } else {
                                    tr += managerTemplate1_2.render(obj);
                                }
                            }
                        else {
                            tr += managerTemplate1_3.render(obj);
                        }

                    } else if (type == 3) {// 결제취소
                        if (obj.addOptYn == 'N') {
                            if (obj.ordDtlStatusCd == '21') {
                                tr += template2_2;
                            } else {
                                if (_claimQtt == 0) {
                                    tr += managerTemplate2_2.render(obj);
                                } else {
                                    if(obj.ordDtlStatusCd == '40'
                                        || obj.ordDtlStatusCd == '75') {
                                        tr += managerTemplate1_2_1.render(obj);
                                    } else {
                                        tr += managerTemplate1_2.render(obj);
                                    }
                                }
                            }
                        } else {
                            tr += managerTemplate1_3.render(obj);
                        }
                    }
                    if (obj.addOptYn == 'Y')
                        tr += managerTemplate1_add.render(obj);

                    tr += managerTemplate1_goods.render(obj);

                    if (obj.addOptYn == 'N' && obj.itemNm != '')
                        tr += managerTemplate2.render(obj);

                    if (obj.addOptYn == 'N') {
                        orgCnt++;
                        tr += managerTemplate3.render(obj);
                    }

//                    if(obj.addOptYn=='N') //'<c:if test="${orderGoodsVo.addOptNm ne null}">' +
//                        tr += managerTemplate4.render(obj);

                    tr += managerTemplate5.render(obj);

                    if (type == 3) {
                        tr += '<input type="hidden" name="claimQtt" id="claimQtt' + idx + '" value="' + obj.ordQtt + '">';
                        tr += obj.ordQtt;
                    } else {
                        /*if (_claimQtt > 0) {
                            if (obj.ordQtt > obj.claimQtt) {
                                tr += '   <span class="select" style="width:100%">';
                                tr += '       <label for="claimQtt' + idx + '">수량</label>';
                                tr += '        <select name="claimQtt" id="claimQtt' + idx + '">';
                                tr += '         <option value="">수량</option>';
                                for (var i = 1; i <= _claimQtt; i++) {
                                    tr += '<option value="' + i + '">' + i + '</option>';
                                }
                                tr += '           </select>';
                                tr += '       </label>';
                                tr += '   </span>';
                            } else {
                                tr += '0';
                            }
                        } else*/ {
                            tr += '<input type="hidden" name="claimQtt" value="' + _claimQtt + '"/>' + _claimQtt;
                        }
                    }
                    tr += managerTemplate5_1.render(obj);

                    var template6 = '';
                    if (obj.addOptYn == 'N' && obj.dlvrcCnt != '0') {
                        template6 = '<td  class="txtr" rowspan="{{dlvrcCnt}}">';
                        if (obj.areaAddDlvrc != '0.00' && obj.areaAddDlvrc != '0')
                            template6 += '선불<br>';
                        else
                            template6 += '{{dlvrcPaymentNm}}<br>';
                        if ((obj.realDlvrAmt + obj.areaAddDlvrc) > 0)
                            template6 += commaNumber(Number(obj.realDlvrAmt) + Number(obj.areaAddDlvrc)) + '원';
                        template6 += '</td>';
                        managerTemplate6 = new Dmall.Template(template6);
                        tr += managerTemplate6.render(obj);
                    }
                    var template7 = '';
                    template7 = '<td>';
                    template7 += commaNumber(Number(obj.paymentAmt) + Number(obj.realDlvrAmt) + Number(obj.areaAddDlvrc) - Number(obj.goodsDmoneyUseAmt));
                    template7 += '</td>';
                    managerTemplate7 = new Dmall.Template(template7);
                    tr += managerTemplate7.render(obj);

                    //tr += managerTemplate7.render(obj);

                    if (obj.addOptYn == 'N') {
                        tr += new Dmall.Template('<td class="txtr">{{ordDtlStatusNm}}</td>').render(obj);
                    }
                    //$("#exchange_ordDtlStatusCd").attr('checked', true) ;
                    tr += templateEndTr;
                } else if (exchangeType == "V") {
                    /*if(obj.ordDtlStatusCd>'70'){*/
                    if (obj.addOptYn == 'N') {
                        //if(obj.ordDtlStatusCd =='74'){
                        //  tr += template2_2;
                        //} else {
                        if(obj.ordDtlStatusCd == '40'
                            || obj.ordDtlStatusCd == '75'
                            || (obj.claimQtt < 1)) {
                            tr += managerTemplate1_2_1.render(obj);
                        } else {
                            tr += managerTemplate1_2.render(obj);
                        }
                        //}
                    } else {
                        tr += managerTemplate1_3.render(obj);
                    }

                    if (obj.addOptYn == 'Y')
                        tr += managerTemplate1_add.render(obj);

                    tr += managerTemplate1_goods.render(obj);

                    if (obj.addOptYn == 'N' && obj.itemNm != '')
                        tr += managerTemplate2.render(obj);

                    if (obj.addOptYn == 'N')
                        tr += managerTemplate3.render(obj);

                    tr += managerTemplate5.render(obj);
                    tr += obj.claimQtt;
                    tr += '<input type="hidden" name="claimQtt" value="' + obj.claimQtt + '">';
                    tr += managerTemplate5_1.render(obj);

                    var template6 = '';
                    if (obj.addOptYn == 'N' && obj.dlvrcCnt != '0') {
                        template6 = '<td  class="txtc" rowspan="{{dlvrcCnt}}">';

                        if (obj.areaAddDlvrc != '0' && obj.areaAddDlvrc != '0')
                            template6 += '선불<br>';
                        else
                            template6 += '{{dlvrcPaymentNm}}<br>';

                        if ((obj.realDlvrAmt + obj.areaAddDlvrc) > 0)
                            template6 += commaNumber(Number(obj.realDlvrAmt) + Number(obj.areaAddDlvrc)) + '원';

                        template6 += '</td>';

                        managerTemplate6 = new Dmall.Template(template6);

                        tr += managerTemplate6.render(obj);
                    }
                    var template7 = '';
                    template7 = '<td>';
                    template7 += commaNumber(Number(obj.paymentAmt) + Number(obj.realDlvrAmt) + Number(obj.areaAddDlvrc) - Number(obj.goodsDmoneyUseAmt));
                    template7 += '</td>';
                    managerTemplate7 = new Dmall.Template(template7);

                    tr += managerTemplate7.render(obj);

                    if (obj.addOptYn == 'N') {
                        tr += new Dmall.Template('<td class="txtc" rowspan="{{cnt}}">{{ordDtlStatusNm}}</td>').render(obj);
                    }
                    tr += templateEndTr;
                }
            });
            // 전체 갯수확인
            $('#orgCnt').val(orgCnt);

            if (type == 2) {// 교환
                jQuery('#ajaxExchangeGoodsList').html(tr);
            } else if (type == 3 || type == 1) {// 결제 취소, 환불
                jQuery('#ajaxPayCancelGoodsList').html(tr);
            }
            dfd.resolve(result.data.orderGoodsVO);
            /**
             * 처리 로그 출력
             */
            var templateLog1 = '<li >{{regDttm}} [주문 상세번호:{{ordDtlSeq}}] [{{ordStatusCd}}] {{ordStatusNm}}</li>';
            tr = '';
            managerLogTemplate = new Dmall.Template(templateLog1),
                jQuery.each(result.data.ordHistVOList, function (idx, obj) {
                    tr += managerLogTemplate.render(obj);
                });
            if (type == 2) {
                jQuery('#ajaxExchangeLogList').html(tr);
            } else if (type == 3 || type == 1) {
                jQuery('#ajaxPayCancelLogList').html(tr);

            }

        });

    },

    getExchangeDetail: function(ordNo) {
        var url = "/admin/order/exchange/exchange-list-layer";
        var param = {ordNo: ordNo, exchangeType: 'exchange'};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            Dmall.FormUtil.jsonToForm(result.data, 'form_exchange_list');

        });
    }
};
/**
 * 반품 /환불
 */
var ordRefundPopup = {
    addDlvrAmt : 0,
    orgPgAmt : 0,
    orgModAmt : 0,
    orgRefAmt : 0,
    addDlvrAmtType : 0,
    totalDlvrAmt : 0,
    init: function () {
        // 반품/환불 선택 버튼
        jQuery('#btn_refund_go').on('click', function (e) {
            //console.log("$('#claimQtt0').val() = ", $('#claimQtt0').val());
            /*if($('#claimQtt0').val() == '') {
                Dmall.LayerUtil.alert("수량을 선택해 주세요 ");
                return false;
            }*/
            /*$('#ajaxRefundGoodsList').children('tr').each(function() {
                var selected = $(this).find('label[for^=refund_ordNo]').hasClass('on');
                console.log("selected = ", selected);
                if(selected) {
                    var claimQtt = $(this).find('[name=claimQtt]').val();
                    console.log("claimQtt = ", claimQtt);
                    if (claimQtt == '') {
                        Dmall.LayerUtil.alert("수량을 선택해 주세요 ");
                        return false;
                    }
                }
            });*/
            var refundType = $(this).attr("refundType");
            refundGo(refundType);
        });

        jQuery('#btn_refund_close').on('click', function (e) {
            Dmall.LayerPopupUtil.close();
        });

        // 환불 처리
        jQuery('#btn_refund_reg').on('click', function (e) {

            curCheckGoods($("input[id^=refund_ordNo]:checked").length);

            //console.log("$('#claimQtt0').val() = ", $('#claimQtt0').val());
            /*if($('#claimQtt0').val() == '') {
                Dmall.LayerUtil.alert("수량을 선택해 주세요 ");
                return false;
            }*/

            if ($('#curCheckGoods').val() != $('#preCheckGoods').val()) {
                Dmall.LayerUtil.alert("선택 적용을 다시 한번 눌려주세요 ");
                return false;
            }
            if (Number($('#estimateAmt').html()) < Number($('#refundAmt').val())) {
                Dmall.LayerUtil.alert("환불 금액이 맞지않습니다.");
                $('#refundAmt').val($('#estimateAmt').html())
                return false;
            }

            if (Number($('#payReserveAmt').val()) + Number($('#payAmt').val()) > Number($('#refundAmt').val())) {
                Dmall.LayerUtil.alert("마켓포인트 금액이 맞지않습니다.");
                $('#payReserveAmt').val(0);
                return false;
            }

            if (Number($('#refundAmt').val()) == 0 && Number($('#payReserveAmt').val()) == 0) {
                Dmall.LayerUtil.alert("환불 금액이 없습니다.");
                return false;
            }

            if ($('#refundClaimCd').val() == "12" && $('#refundReturnCd').val() != "12") {
                Dmall.LayerUtil.alert("반품상태를 확인 해주세요. \n 반품상태는 반품완료가 되어야 환불완료신청이 가능합니다.");
                return false;
            }
            if ($('#refundClaimCd').val() == "12" && $('#orgRefundReturnCd').val() != "12") {
                Dmall.LayerUtil.alert("반품상태를 확인 해주세요. \n 반품상태는 반품완료가 되어야 환불완료신청이 가능합니다.");
                return false;
            }
            var url = "";
            var cancelStatusCd = "";
            if ($('#refundClaimCd').val() == "12") {
                //취소 처리
                url = '/admin/order/manage/cancel-order';
                cancelStatusCd = "74";
            } else {
                //상태 저장
                url = '/admin/order/refund/refund-update';

            }

            dfd = jQuery.Deferred();
            var comma = ',';
            var ordDtlSeqArr = '';
            var claimQttArr = '';
            var claimNoArr = '';
            /* var claimMemo = $('#refundMemo').val()
             var claimDtlReason = $('#refundDtlReason').val();
             var pgType = $('#pgType').val();*/
            var pgAmt = $('#pgAmt').val().replaceAll(",", "");
            var orgPgAmt = $('#tempPgAmt').html().replaceAll(",", "");
            /*var refundAmt = $('#refundAmt').val().replaceAll(",","");
            var payReserveAmt = $('#payReserveAmt').val().replaceAll(",","");
            var orgReserveAmt = $('#orgReserveAmt').val().replaceAll(",","");
            var bankCd = $('#bankCd').val();
            var actNo = $('#actNo').val();
            var holderNm = $('#holderNm').val();
            var restAmt = $('#restAmt').val().replaceAll(",","");*/
            var partCancelYn = $('#partCancelYn').val();
            /*var cancelType =  $('#cancelType').val();
            var claimReasonCd = $('#refundReasonCd').val();
            var returnCd = $('#refundReturnCd').val();
            var claimCd = $('#refundClaimCd').val();*/
            var ordNo = $("#label_refundOrdNo").text();

            $('input[name=refundOrdDtlSeq]:not([value=""])').map(function (i) {
                // if (i != 0)
                ordDtlSeqArr += ($(this).val());
                ordDtlSeqArr += comma;
            });

            $('input[name=refundClaimQtt]:not([value=""])').map(function (i) {
                // if (i != 0)
                claimQttArr += ($(this).val());
                claimQttArr += comma;
            });

            $('input[name=refundClaimNo]:not([value=""])').map(function (i) {
                if (i != 0) claimNoArr += comma;
                claimNoArr += ($(this).val());
            });

            var errMsg = '';
            if ($("#refundReasonCd option:selected").val() == '' || $("#refundReasonCd option:selected").val() == null) {
                errMsg = '반품사유를 선택하세요.';
            }
            if ($("#refundReturnCd option:selected").val() == '') {
                errMsg = '반품상태 선택하세요.';
            }
            //부분반품여부
            if($('#refundReasonCd').val() == '50') { // 단순 변심일때 기본 배송비 빼고 환불
                orgPgAmt -= 2500;
            }
            if (pgAmt == orgPgAmt) {
                partCancelYn = 'N';
            } else {
                partCancelYn = 'Y';
            }

            if (errMsg != '') {
                Dmall.LayerUtil.alert(errMsg);
            } else {
                /* var param = {
                          ordDtlSeqArr      : ordDtlSeqArr,claimQttArr       : claimQttArr,claimReasonCd     : claimReasonCd,returnCd          : returnCd
                         ,claimCd           : claimCd,claimDtlReason    : claimDtlReason,claimMemo         : claimMemo,pgType            : pgType
                         ,pgAmt             : pgAmt,refundAmt         : refundAmt,payReserveAmt     : payReserveAmt,bankCd            : bankCd
                         ,actNo             : actNo,holderNm          : holderNm,partCancelYn      : partCancelYn,restAmt           : restAmt
                         ,orgReserveAmt     : orgReserveAmt,orgPgAmt          : orgPgAmt,cancelType        : cancelType,claimReasonCd     : claimReasonCd
                         ,ordNo             : ordNo,cancelStatusCd    : cancelStatusCd,claimNoArr        : claimNoArr
                         };*/

                Dmall.DaumEditor.setValueToTextarea('refundDtlReason');  // 에디터에서 폼으로 데이터 세팅

                $('#ordDtlSeqArr').val(ordDtlSeqArr);/*hidden*/
                $('#claimQttArr').val(claimQttArr);/*hidden*/
                $('#claimNoArr').val(claimNoArr);/*hidden*/
                $('#claimMemo').val($('#refundMemo').val());/*hidden*/
                $('#claimDtlReason').val($('#refundDtlReason').val());/*hidden*/
                $('#pgAmt').val($('#pgAmt').val().replaceAll(",", ""));
                $('#orgPgAmt').val($('#tempPgAmt').html().replaceAll(",", ""));/*hidden*/
                $('#refundAmt').val($('#refundAmt').val().replaceAll(",", ""));

                $('#payReserveAmt').val($('#payReserveAmt').val().replaceAll(",", ""));
                $('#orgReserveAmt').val($('#orgReserveAmt').val().replaceAll(",", ""));
                $('#partCancelYn').val(partCancelYn);
                $('#restAmt').val($('#restAmt').val().replaceAll(",", ""));

                $('#claimReasonCd').val($('#refundReasonCd').val());/*hidden*/
                $('#returnCd').val($('#refundReturnCd').val());/*hidden*/
                $('#claimCd').val($('#refundClaimCd').val());/*hidden*/
                $('#ordNo').val($("#label_refundOrdNo").text());/*hidden*/
                $('#cancelStatusCd').val(cancelStatusCd);/*hidden*/

                var param = jQuery('#form_refund_list').serialize();

                if (ordNo != "") { // 선택된 주문번호가 있을때만
                    console.log("param = ", param);
                    //return false;
                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if (result.success) {
                            $("#tbody_refund_data").find(".searchRefundResult").each(function () {
                                $(this).remove();
                            });

                            jQuery("#tr_refund_data_template").hide();
                            jQuery('#tr_no_refund_data').show();
                            $('#refundDtlReason').val("");
                            $('#refundMemo').val("");
                            //부모창이 반품 목록인 경우
                            if ($('#ord_search_btn').length) {
                                Dmall.LayerPopupUtil.close();
                                jQuery('#ord_search_btn').trigger('click');

                            } else {
                                Dmall.LayerPopupUtil.close();
                                document.location.reload();


                            }
                        }
                    });
                }

            }
        });

        $('#refundReasonCd').on('change', function(e) {
            var refundReasion = $(this).val();
            var pgAmt = ordRefundPopup.orgPgAmt;
            var modifyAmt = ordRefundPopup.orgModAmt;
            var refundAmt = ordRefundPopup.orgRefAmt;

            var refundType = $(this).attr("refundType");
            console.log("refundReasion = ", refundReasion);
            if(refundType=="M") {
                if (refundReasion == '50') {
                    addDlvrAmt = 3000;//유료 배송비
                    if (!$('#refundDtlReason').hasClass('blind')) {
                        $('#refundDtlReason').val('').text('');
                        $('#refundDtlReason').addClass('blind');
                    }
                } else if (refundReasion == '70') {
                    if ($('#refundDtlReason').val() == null || $('#refundDtlReason').val() == '') {
                        $('#refundDtlReason').val('관리자 반품/환불').text('관리자 반품/환불');
                        $('#refundDtlReason').removeClass('blind');
                    }
                    addDlvrAmt = 0;
                } else {
                    addDlvrAmt = 0;
                    if (!$('#refundDtlReason').hasClass('blind')) {
                        $('#refundDtlReason').val('').text('');
                        $('#refundDtlReason').addClass('blind');
                    }
                }
            } else {
                if (refundReasion == '50') {
                    addDlvrAmt = 3000; // 유료 배송비
                } else {
                    addDlvrAmt = 0;
                }
            }
            console.log("ordRefundPopup.addDlvrAmtType ", ordRefundPopup.addDlvrAmtType);
            /*if(objP.totalDlvrAmt == 0) { // 착불일때 고려 필요
                addDlvrAmt = 6000;
            } else */{
                addDlvrAmt = addDlvrAmt * ordRefundPopup.addDlvrAmtType;
            }
            pgAmt -= addDlvrAmt;
            modifyAmt -= addDlvrAmt;
            refundAmt -= addDlvrAmt;

            $("#pgAmt").val(commaNumber(pgAmt));
            $("#modifyAmt").val(commaNumber(modifyAmt));
            $("#refundAmt").val(commaNumber(refundAmt));
            $("#estimateAmt").html(commaNumber(modifyAmt));
        });
    },

    // 환불 버튼 클릭 시 실행
    btnRefundClick : function (ordNo, type, refundType) {

        if (type == 1) {
            // 환불, 결제취소
            $("#label_refundOrdNo").text(ordNo);
            $("#tbody_refund_data").find(".searchRefundResult").each(function () {
                $(this).remove();
            });
                jQuery("#tr_refund_data_template").hide();
                jQuery('#tr_no_refund_data').show();
            $('#refundDtlReason').val("");
            $('#refundMemo').val("");
            $("#estimateAmt").html(0);
            $("#modifyAmt").val(0);
            $("#refundAmt").val(0);
            $("#pgAmt").val(0);
            $("#tempPgAmt").html(0);
            $("#payReserveAmt").val(0);
            $("#orgReserveAmt").val(0);
            $("#pgtype1").html("");
            $("#pgType option:eq(0)").replaceWith("<option value='01'>무통장 환불</option>");
            $("#pgType option:eq(1)").replaceWith("<option value='02'>PG 환불</option>");

            $('#payReserveAmt, #modifyAmt, #pgAmt').on('keydown', function () {
                onlyNumberInput($(this));
                calcAmt();
            });

            $('#payReserveAmt, #modifyAmt, #pgAmt').on('keyup', function () {
                onlyNumberInput($(this));
                calcAmt();
            });
        }
        var url;


        Dmall.LayerPopupUtil.open(jQuery('#layout_refund'));
        url =  "/admin/order/exchange/order-detail-exchange";
        //$('#refundOrdStatusCd').val(curOrdStatusCd);

        var param = {ordNo:ordNo,claimType:'R'};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            var dfd = jQuery.Deferred();
            var template1_1 =
                '<input type="text" name="refund_OrdStatusCd" id="refund_OrdStatusCd" value="{{ordDtlSeq}}" />' +
                '<tr>' +
                    '<td class="txtl">' +
                        '<div class="item_box">' ;
            var template1_2 =
                '<tr>' +
                    '<td>' +
                    /*'<div width="0" height=0 style="visibility:hidden">' +*/
                    '<label for="refund_ordNo{{ordDtlSeq}}" class="chack mr10">' +
                    '<span class="ico_comm"><input type="checkbox" name="refund_ordNo" id="refund_ordNo{{ordDtlSeq}}" class="blind" value="{{ordNo}}:{{ordDtlSeq}}:{{goodsNo}}" /></span>' +
                    '</label>' +
                    /*'</div>' +*/
                    '</td>' +
                    '<td class="txtl">' +
                        '<div class="item_box">' ;
            var template1_2_1 =
                '<tr>' +
                '<td>' +
                '</td>' +
                '<td class="txtl">' +
                '<div class="item_box">' ;
            var template2_2 =
                '<tr>' +
                    '<td>&nbsp;</td>' +
                    '<td class="txtl">' +
                        '<div class="item_box">' ;
            var template1_3 =
                '<tr>' +
                    '<td>' +
                    '</td>' +
                    '<td class="txtl">' +
                        '<div class="item_box">' ;
            var template1_add =
                            '<span class="addition" >' +
                                '<img src="/admin/img/order/icon_addition.png" alt="추가상품" />' +
                            '</span>';
            var template1_goods =
                            '<a href="#none" class="goods_img"><img src="'+_IMAGE_DOMAIN+'{{imgPath}}" alt="" /></a>' +
                            '<a href="#none" class="goods_txt">' +
                                '<span class="tlt">{{goodsNm}}</span>' ;
            var template2 =
                                '<span class="option">' +
                                    /*'<span class="ico01">옵션</span> ' +*/
                                    '{{itemNm}}' +
                                '</span>' ;
            var template3 =
                                '<span class="code">[상품코드 : {{goodsNo}}]</span>' ;
            var template4 =
                                '<span class="option">' +
                                    '<span class="ico01">추가옵션</span>{{addOptNm}}' +
                                '</span>' ;
            var template5 =
                            '</a>' +
                        '</div>' +
                    '</td>'+
                    '<td>{{ordQtt}}</td>' +
                    '<td class="txtc">' ;
            var template5_1=
                    '</td>' +
                    '<td class="txtc">{{saleAmt}}</td>' +
                    '<td class="txtc">{{dcAmt}}</td>';
            var template7 =
                    '<td class="txtc">{{payAmt}}</td>' ;
            var templateEndTr ='</tr>' ;

            managerTemplate1_1 = new Dmall.Template(template1_1),
            managerTemplate1_2 = new Dmall.Template(template1_2),
            managerTemplate1_2_1 = new Dmall.Template(template1_2_1),
            managerTemplate2_2 = new Dmall.Template(template2_2),

            managerTemplate1_3 = new Dmall.Template(template1_3),
            managerTemplate1_add = new Dmall.Template(template1_add),
            managerTemplate1_goods = new Dmall.Template(template1_goods),
            managerTemplate2 = new Dmall.Template(template2),
            managerTemplate3 = new Dmall.Template(template3),
            managerTemplate5 = new Dmall.TemplateNoFormat(template5),
            managerTemplate5_1 = new Dmall.TemplateNoFormat(template5_1),

            managerTemplate7 = new Dmall.TemplateNoFormat(template7),
            tr =  '';

            jQuery.each(result.data.orderGoodsVO, function(idx, obj) {
                if(refundType=="M"){
                    /*if(obj.ordDtlStatusCd<'70'){*/
                        var _claimQtt=obj.ordQtt-obj.claimQtt;

                        if(obj.addOptYn=='N') {
                            if(_claimQtt==0){
                              tr += managerTemplate2_2.render(obj);;
                            } else {
                                if(obj.ordDtlStatusCd != '50') {
                                    tr += managerTemplate1_2_1.render(obj);
                                } else {
                                    tr += managerTemplate1_2.render(obj);
                                }
                            }
                        } else {
                            tr += managerTemplate1_3.render(obj);
                        }

                        if(obj.addOptYn=='Y')
                            tr += managerTemplate1_add.render(obj);

                        tr += managerTemplate1_goods.render(obj);

                        if(obj.addOptYn=='N' && obj.itemNm !='')
                            tr += managerTemplate2.render(obj);

                        if(obj.addOptYn=='N')
                            tr += managerTemplate3.render(obj);

                        tr += managerTemplate5.render(obj);


                        /*if(_claimQtt>0) {
                            if (obj.ordQtt > obj.claimQtt) {
                            tr += '   <span class="select" style="width:100%">';
                            tr += '       <label for="claimQtt' + idx + '">수량</label>';
                            tr += '        <select name="claimQtt" id="claimQtt' + idx + '">';
                            tr += '         <option value="">수량</option>';
                            for (var i = 1; i <= _claimQtt; i++) {
                                tr += '<option value="' + i + '">' + i + '</option>';
                            }
                            tr += '           </select>';
                            tr += '       </label>';
                            tr += '   </span>';
                            }else{
                                tr += '0';
                            }
                        }else*/{
                            tr += '<input type="hidden" name="claimQtt" value="' + _claimQtt + '"/>' + _claimQtt;
                        }
                        tr += managerTemplate5_1.render(obj);

                        var template6 = '';
                        if(obj.addOptYn == 'N' && obj.dlvrcCnt != '0') {
                            template6 ='<td  class="txtc" rowspan="{{dlvrcCnt}}">';

                            if(obj.areaAddDlvrc != '0.00' && obj.areaAddDlvrc != '0')
                                template6 += '선불<br>';
                            else
                                template6 += '{{dlvrcPaymentNm}}<br>';

                            if((obj.realDlvrAmt + obj.areaAddDlvrc) > 0)
                                template6 += commaNumber(Number(obj.realDlvrAmt) + Number(obj.areaAddDlvrc)) + '원';

                            template6 += '</td>';

                            managerTemplate6 = new Dmall.Template(template6);

                            tr += managerTemplate6.render(obj);
                        }
                        tr += managerTemplate7.render(obj);

                        if(obj.addOptYn == 'N') {
                            tr += new Dmall.Template('<td class="txtc" rowspan="{{cnt}}">{{ordDtlStatusNm}}</td>').render(obj);
                        }
                        tr += templateEndTr;
                    /*}*/
                }else if(refundType=="V"){
                    /*if(obj.ordDtlStatusCd>'70'){*/
                        if(obj.addOptYn=='N') {
                            //if(obj.ordDtlStatusCd =='74'){
                            //  tr += template2_2;
                            //} else {
                            // 교환 환불 신청이 완료된 단계에서 
                            // 기능 활성화
                            if((obj.ordDtlStatusCd != '62'
                                && obj.ordDtlStatusCd != '70'
                                && obj.ordDtlStatusCd != '72')
                                || (obj.claimQtt < 1)) {
                                tr += managerTemplate1_2_1.render(obj);
                            } else {
                                tr += managerTemplate1_2.render(obj);
                            }
                            //}
                        } else {
                            tr += managerTemplate1_3.render(obj);
                        }

                        if(obj.addOptYn=='Y')
                            tr += managerTemplate1_add.render(obj);

                            tr += managerTemplate1_goods.render(obj);

                        if(obj.addOptYn=='N' && obj.itemNm !='')
                            tr += managerTemplate2.render(obj);

                        if(obj.addOptYn=='N')
                            tr += managerTemplate3.render(obj);

                            tr += managerTemplate5.render(obj);
                            tr+=obj.claimQtt;
                            tr+='<input type="hidden" name="claimQtt" value="'+obj.claimQtt+'">';
                            tr += managerTemplate5_1.render(obj);

                        var template6 = '';
                        if(obj.addOptYn == 'N' && obj.dlvrcCnt != '0') {
                            template6 ='<td  class="txtc" rowspan="{{dlvrcCnt}}">';

                            if(obj.areaAddDlvrc != '0.00' && obj.areaAddDlvrc != '0')
                                template6 += '선불<br>';
                            else
                                template6 += '{{dlvrcPaymentNm}}<br>';

                            if((obj.realDlvrAmt + obj.areaAddDlvrc) > 0)
                                template6 += commaNumber(Number(obj.realDlvrAmt) + Number(obj.areaAddDlvrc)) + '원';

                            template6 += '</td>';

                            managerTemplate6 = new Dmall.Template(template6);

                            tr += managerTemplate6.render(obj);
                        }
                        tr += managerTemplate7.render(obj);

                        if(obj.addOptYn == 'N') {
                            tr += new Dmall.Template('<td class="txtc" rowspan="{{cnt}}">{{ordDtlStatusNm}}</td>').render(obj);
                        }
                        tr += templateEndTr;
                    }
                /*}*/
            });

            jQuery('#ajaxRefundGoodsList').html(tr);
            dfd.resolve(result.data.orderGoodsVO);
            /**
             * 처리 로그 출력
             */
            var templateLog1 = '<li >{{regDttm}} [주문 상세번호:{{ordDtlSeq}}] [{{ordStatusCd}}] {{ordStatusNm}}</li>';
            tr =  '';
            managerLogTemplate = new Dmall.Template(templateLog1),
            jQuery.each(result.data.ordHistVOList, function(idx, obj) {
                tr += managerLogTemplate.render(obj);
            });
            jQuery('#ajaxRefundLogList').html(tr);

            if(refundType=="V"){
                $('input:checkbox[name="refund_ordNo"]').each(function() {
                    $(this).parents('label').addClass('on');
                    this.checked = true; //checked 처리
                    this.disabled = true;
                    //if(this.checked){//checked 처리된 항목의 값
                          //alert(this.value);
                    //}
                });
                $("#btn_refund_go").hide();
                refundGo(refundType);
            }
        });
    }


};

/**
 * 사은품 검색 팝업
 *
 */
var FreebieSelectPopup = {
    // 초기화
    // - 사은품검색 초기화의 매개변수로 사은품 선택시 호출할 callback 함수를 정의
    // - callback함수는 사은품 검색 팝업을 호출한 jsp에 정의
    _init: function (callback) {

        // callback 설정
        var $layer = jQuery('#layer_popup_freebie_select').data("bind-function", callback);
        // 화면 리셋
        $layer.find('form')[0].reset();
        jQuery('#freebie_txt_pop_search_word').val('');
        jQuery('label:first-child', $('#tb_freebie_status')).trigger('click');
        jQuery('label:first-child', $('#tb_freebie_display')).trigger('click');
        jQuery("#tr_popup_freebie_data_template").hide();
        jQuery('#tr_popup_no_freebie_data').show();
        jQuery('#div_id_pop_paging_freebie').html("");

        $("#tbody_popup_freebie_data").find(".searchFreebieResult").each(function () {
            $(this).remove();
        });

        jQuery('label', $('#td_pop_freebie_select_ctg')).each(function (idx, obj) {
            var $sel = $("#" + $(this).attr("for"));
            $(this).text($sel.find("option:selected").text());
        });

        // 사은품 검색 버튼 클릭시
        jQuery('#btn_popup_freebie_search').on('click', function (e) {
            Dmall.EventUtil.stopAnchorAction(e);

            jQuery('#freebie_hd_pop_page').val('1');
            FreebieSelectPopup.getSearchFreebieData();
        });
    },
    // 사은품 검색 정보를 취득하여 셋팅ajaxPayCancelGoodsList
    getSearchFreebieData: function () {
        var url = '/admin/goods/freebie-list',
            param = $('#form_id_pop_search_freebie').serialize(),
            dfd = jQuery.Deferred();

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result == null || result.success != true) {
                return;
            }

            // 기존 결과 삭제
            $("#tbody_popup_freebie_data").find(".searchFreebieResult").each(function () {
                $(this).remove();
            });

            // 취득결과 셋팅
            jQuery.each(result.resultList, function (idx, obj) {
                FreebieSelectPopup.setFreebieData(obj);
            });
            dfd.resolve(result.resultList);

            // 결과가 없을 경우 NO DATA 화면 처리
            if ($("#tbody_popup_freebie_data").find(".searchFreebieResult").length < 1) {
                jQuery('#tr_popup_no_freebie_data').show();
            } else {
                jQuery('#tr_popup_no_freebie_data').hide();
            }

            // 페이징 처리
            Dmall.GridUtil.appendPaging('form_id_pop_search_freebie', 'div_id_pop_paging_freebie', result, 'paging_id_pop_freebie_list', FreebieSelectPopup.getSearchFreebieData);
        });
        return dfd.promise();
    },
    // 취득한 데이터를 검색결과에 바인딩
    setFreebieData: function (freebieData) {
        var $tmpSearchResultTr = $("#tr_popup_freebie_data_template").clone().show().removeAttr("id");
        var trId = "tr_pop_freebie_" + freebieData.freebieNo;
        $($tmpSearchResultTr).attr("id", trId).addClass("searchFreebieResult");
        ;
        $('[data-bind="popFreebieInfo"]', $tmpSearchResultTr).DataBinder(freebieData);
        $("#tbody_popup_freebie_data").append($tmpSearchResultTr);
    },
    // row별 사은품이미지와 사은품명 표시처리
    setFreebieDetail: function (data, obj, bindName, target, area, row) {
        obj.html("");
        var imgPath = data['imgPath']
            , imgNm = data['imgNm']
            ,
            $tmpDetailIm = $("#td_popup_freebie_img_template").clone().show().removeAttr("id").attr("id", "img_" + data["freebieNo"]).attr('src', _IMAGE_DOMAIN + '/image/image-view?type=FREEBIEDTL&id1=' + imgPath + '_' + imgNm);
        obj.append($tmpDetailIm);
    },
    setFreebieDetailNm: function (data, obj, bindName, target, area, row) {
        obj.html(data['freebieNm']);
        /*var imgPath = data['imgPath']
            , imgNm = data['imgNm']
            ,
            $tmpDetailImg = $("#td_popup_freebie_img_template").clone().show().removeAttr("id").attr("id", "img_" + data["freebieNo"]).attr('src', _IMAGE_DOMAIN + '/image/image-view?type=FREEBIEDTL&id1=' + imgPath + '_' + imgNm);
        obj.append($tmpDetailImg);*/
    },
    // row별 등록 버튼 표시처리
    setFreebieSelect: function (data, obj, bindName, target, area, row) {
        obj.data("freebieNo", data["freebieNo"]).html('<a href="#none" class="btn_blue">등록</a>').off("click").on('click', function (e) {
            Dmall.EventUtil.stopAnchorAction(e);
            var t_data = data;

            FreebieSelectPopup.executeFreebieSelect($(this), t_data);
        });
    },
    // 등록 버튼 클릭 시 실행
    executeFreebieSelect: function (obj, data) {
        var func = jQuery('#layer_popup_freebie_select').data("bind-function");
        // 초기화 시 설정된 callback 함수를 실행 한다.
        func = null != func && "function" == typeof func ? func.apply(null, [data]) : alert("callback함수의 설정이 올바르지 않습니다.");
        // Dmall.LayerPopupUtil.close();
    }
};

/**
 * 인플루언서 검색 팝업
 *
 */
var InfluencerSelectPopup = {
    // 초기화
    _init: function (callback) {
        // 검색 버튼 클릭
        $('#btn_popup_influencer_search').on('click', function (e) {
            Dmall.EventUtil.stopAnchorAction(e);

            $('#layer_popup_influencer_select #hd_pop_page').val('1');
            InfluencerSelectPopup.getSearchInfluencerData();
        });

        // 등록 버튼 클릭
        $('.btn_popup_influencer_reg').on('click', function (e) {
            Dmall.EventUtil.stopAnchorAction(e);

            if (!$('input:radio[name=influencerSelectYn]').is(':checked')) {
                Dmall.LayerUtil.alert('등록할 데이터를 선택해주세요.');
            } else {
                Dmall.LayerPopupUtil.close('layer_popup_influencer_select');

                var data = $('input:radio[name=influencerSelectYn]:checked').parents('tr').data();
                (callback != null && typeof callback == "function") ? callback.call(data) : Dmall.LayerUtil.alert('callback 함수의 설정이 올바르지 않습니다.');
            }
        });
    },
    reset: function () {
        // 템플릿 초기화
        $('#form_id_pop_influencer_search')[0].reset();
        $('#tbody_popup_influencer_data').html('');
        $('#div_id_pop_paging_influencer').html('');
    },
    getSearchInfluencerData: function () {
        var url = '/admin/member/manage/member-list-pop',
            param = $('#form_id_pop_influencer_search').serialize(),
            dfd = jQuery.Deferred();

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            var template =
                '<tr data-member-no="{{memberNo}}" data-member-nn="{{memberNn}}">' +
                '   <td>' +
                '      <label for="influencerSelectYn" class="radio">' +
                '       <span class="ico_comm">' +
                '           <input type="radio" id="influencerSelectYn" name="influencerSelectYn">' +
                '       </span>' +
                '       </label>' +
                '   </td>' +
                '   <td><img src="" alt="프로필 이미지"></td>' +
                '   <td>{{loginId}}</td>' +
                '   <td>{{memberNn}}</td>' +
                '   <td>{{memberNm}}</td>' +
                '</tr>';
            var templateMgr = new Dmall.Template(template);
            var tr = '';

            jQuery.each(result.resultList, function (idx, obj) {
                tr += templateMgr.render(obj);
            });

            if (tr == '') {
                tr = '<tr><td colspan="5">데이터가 없습니다.</td></tr>';
            }

            jQuery('#tbody_popup_influencer_data').html(tr);
            dfd.resolve(result.resultList);

            Dmall.GridUtil.appendPaging('form_id_pop_influencer_search', 'div_id_pop_paging_influencer', result, 'paging_id_influencer_list', InfluencerSelectPopup.getSearchInfluencerData);

            $('#influencer_cnt_total').text(result.filterdRows);
        });
        return dfd.promise();
    }
};

/**
 * 상품 검색 팝업
 *
 */
var IconSelectPopup = {
    goodsIconList: [],
    // 초기화
    _init: function (selected) {
        IconSelectPopup.getGoodsIconData();
        goodsIconList = selected;
        // 등록 버튼 클릭
        $('#btn_regist_goods_icon').on('click', function (e) {
            Dmall.EventUtil.stopAnchorAction(e);

            if (!$('input:radio[name=goodsIcon]').is(':checked')) {
                Dmall.LayerUtil.alert('등록할 데이터를 선택해주세요.');
            } else {

                var goodsIcon = $('input:radio[name=goodsIcon]:checked').val();
                if (!goodsIcon) {
                    Dmall.LayerUtil.alert("상품 아이콘을 선택해주세요.");
                    return;
                }
                Dmall.LayerUtil.confirm('상품 아이콘을 변경하시겠습니까?', function() {
                    var url = '/admin/goods/icon-update',
                        param = {},
                        key;

                    if (goodsIconList) {
                        jQuery.each(goodsIconList, function(i, o) {
                            key = 'list[' + i + '].goodsNo';
                            param[key] = o;

                            key = 'list[' + i + '].iconNo';
                            param[key] = goodsIcon;
                        });
                        //console.log("param = ", param);
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_id_goods_icon');
                            Dmall.LayerPopupUtil.close('div_icon_confirm');
                            getSearchGoodsData();
                        });
                    }
                });
            }
        });
    },
    reset: function () {
        // 템플릿 초기화
        goodsIconList = [];
        /*$('#form_id_pop_influencer_search')[0].reset();
        $('#tbody_popup_influencer_data').html('');
        $('#div_id_pop_paging_influencer').html('');*/
    },
    getGoodsIconData: function () {
        var url = '/admin/goods/icon-list',
            param = $('#form_id_goods_icon').serialize(),
            dfd = jQuery.Deferred();

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            var templateN =
                '<label id="lb_icon_use_yn" for="goods_icon_N" class="radio mr20 on">' +
                '<input type="radio" name="goodsIcon" id="goods_icon_N" value="N" class="blind">' +
                '<span class="ico_comm"></span>' +
                '적용 안함' +
                '</label>';
            var template =
                '<label for="goods_icon_{{iconNo}}" class="radio mr20">' +
                '   <input type="radio" name="goodsIcon" id="goods_icon_{{iconNo}}" value="{{iconNo}}" class="blind"/>' +
                '   <span class="ico_comm">&nbsp;</span>' +
                '   <img id="img_goods_icon_{{iconNo}}" src="'+_IMAGE_DOMAIN + '/image/image-view?type=ICON&id1={{icnImgInfo}}" width = "50" height = "40" alt="">' +
                '</label>';
            var templateMgrN = new Dmall.Template(templateN);
            var templateMgr = new Dmall.Template(template);
            var tr = '';

            jQuery.each(result, function (idx, obj) {
                //console.log("idx = ", idx);
                if(idx == 0) {
                    tr += templateMgrN.render(obj);
                }
                tr += templateMgr.render(obj);
            });

            if (tr == '') {
                tr = '<span>데이터가 없습니다.</span>';
            }

            jQuery('#td_popup_icon_data').html(tr);
            dfd.resolve(result.resultList);

        });
        return dfd.promise();
    }
};

/**
 * 상품 검색 팝업
 *
 */
var GoodsListPopup = {
    // 초기화
    _init: function (url) {
        // console.log("url = ", url);

        jQuery("#tr_popup_goods_list_template").hide();
        jQuery('#tr_popup_no_goods_list').show();
        jQuery('#div_id_pop_list_paging').html("");

        $("#tbody_popup_goods_list").find(".searchGoodsResult").each(function () {
            $(this).remove();
        });
        jQuery('#url').val(url);
        jQuery('#hd_pop_page').val('1');
        GoodsListPopup.getSearchGoodsData(url);

        /*Dmall.common.comma();*/
    },
    // 상품 검색 정보를 취득하여 셋팅
    getSearchGoodsData: function () {
        var url = jQuery('#url').val(),
            param = $('#form_id_pop_search').serialize(),
            dfd = jQuery.Deferred();
        // console.log("url = ", url);
        // console.log("param = ", param);
        Dmall.AjaxUtil.getJSON(url, param, function (result) {

            if (result == null) {
                return;
            }

            // 기존 결과 삭제
            $("#tbody_popup_goods_list").find(".searchGoodsResult").each(function () {
                $(this).remove();
            });
            // console.log("result = ", result.resultList);
            // 취득결과 셋팅
            jQuery.each(result.resultList, function (idx, obj) {
                // console.log("obj = ", obj);
                GoodsListPopup.setGoodsData(obj);
            });
            dfd.resolve(result.resultList);

            // 결과가 없을 경우 NO DATA 화면 처리
            if ($("#tbody_popup_goods_list").find(".searchGoodsResult").length < 1) {
                jQuery('#tr_popup_no_goods_list').show();
            } else {
                jQuery('#tr_popup_no_goods_list').hide();
            }

            // 페이징 처리
            Dmall.GridUtil.appendPaging('form_id_pop_search', 'div_id_pop_list_paging', result, 'paging_id_pop_goods_list', GoodsListPopup.getSearchGoodsData);
        });
        return dfd.promise();
    },
    // 취득한 데이터를 검색결과에 바인딩
    setGoodsData: function (goodsData, $tr) {
        // console.log("goodsData = ", goodsData);
        var $tmpSearchResultTr = $("#tr_popup_goods_list_template").clone().show().removeAttr("id").data('prev_data', goodsData);
        var trId = "tr_popup_goods_" + goodsData.goodsNo;
        $($tmpSearchResultTr).attr("id", trId).addClass("searchGoodsResult");
        $('[data-bind="popGoodsInfo"]', $tmpSearchResultTr).DataBinder(goodsData);
        if ($tr) {
            $tr.before($tmpSearchResultTr);
        } else {
            $("#tbody_popup_goods_list").append($tmpSearchResultTr);
        }
    },
    // row별 상품이미지와 상품명 표시처리
    setGoodsDetail: function (data, obj, bindName, target, area, row) {
        obj.html("");
        var imgPath = 'goodsImg02' in data && data['goodsImg02'] && data['goodsImg02'].length > 0 ? data['goodsImg02'] : '/admin/img/product/tmp_img02.png'
            , $tmpDetailImg = $("#td_popup_goods_detail_template").clone().show().removeAttr("id")
            .attr("id", "img_" + data["goodsNo"]).attr('src', _IMAGE_DOMAIN + imgPath);


        obj.append($tmpDetailImg).append(data["goodsNm"]);
    },
    setSalePrice(data, obj, bindName, target, area, row) {
        var salePrice = data["salePrice"];
        obj.html(numberWithCommas(salePrice));
    },
    // 결과 행의 재고 표시 설정
    setStockQtt(data, obj, bindName, target, area, row) {
        var stockQtt = data["stockQtt"];
        obj.html(numberWithCommas(stockQtt));
    },
    // 상품 판매상태 텍스트 설정
    setGoodsStatusText(data, obj, bindName, target, area, row) {
        var goodsSaleStatusCd = data["goodsSaleStatusCd"];
        var goodsSaleStatusNm = data["goodsSaleStatusNm"];
        if (goodsSaleStatusCd == 1) {//판매중
            goodsSaleStatusNm = '<span class="sale_info1">' + goodsSaleStatusNm + '</span>';
        } else if (goodsSaleStatusCd == 2) {//품절
            goodsSaleStatusNm = '<span class="sale_info2">' + goodsSaleStatusNm + '</span>';
        } else if (goodsSaleStatusCd == 3) {//판매대기
            goodsSaleStatusNm = '<span class="sale_info3">' + goodsSaleStatusNm + '</span>';
        } else if (goodsSaleStatusCd == 4) {//판매중지
            goodsSaleStatusNm = '<span class="sale_info4">' + goodsSaleStatusNm + '</span>';
        }
        obj.html(goodsSaleStatusNm);
    }
};

// 가능하게 하기
function onlyNumberInput(obj) {
    obj.on('keydown', function (event) {
        event = event || window.event;
        var keyID = (event.which) ? event.which : event.keyCode;
        // 48 ~ 57 일반숫자키 0~9,  96~105 키보드 우측 숫자키패드,  백스페이스 8, 탭 9, end 35, home 36, 왼쪽 방향키 37, 오른쪽 방향키 39, 인서트 45, 딜리트 46, 넘버락 144
        if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 9 || keyID == 35 || keyID == 36 || keyID == 37 || keyID == 39 || keyID == 45 || keyID == 46 || keyID == 144) {
            return;
        } else {
            return false;
        }
    });
    obj.on('keyup', function (event) {
        event = event || window.event;
        var keyID = (event.which) ? event.which : event.keyCode;
        if (keyID == 8 || keyID == 9 || keyID == 35 || keyID == 36 || keyID == 37 || keyID == 39 || keyID == 45 || keyID == 46 || keyID == 144) {
            return;
        } else {
            event.target.value = event.target.value.replace(/[^0-9]/g, "");
        }
    });
}


/*function calcAmt(){
    if ($('#modifyAmt').val()==""){
        $('#modifyAmt').val(0)
    }
    if ($('#payReserveAmt').val()==""){
        $('#payReserveAmt').val(0)
    }
    $('#modifyAmt').val(parseInt($('#modifyAmt').val()));
    $('#payReserveAmt').val(parseInt($('#payReserveAmt').val()));
    $('#refundAmt').val($('#modifyAmt').val());

    // 환불조정금액이 환불예상금액보다 클때 금액 리셋
    if(Number($("#estimateAmt").html())<Number($('#modifyAmt').val())){
        $('#modifyAmt').val($("#estimateAmt").html());
    }
    // 마켓포인트, pg 무통장 금액 이 총 환불 금액보다 크면 데이터 리셋
    if(Number($("#refundAmt").val())< (Number($('#pgAmt').val())+Number($('#payReserveAmt').val()))){
        // 환불금액이 기존 환불예상금액보다 작을때
        if(Number($("#refundAmt").val())<Number($("#estimateAmt").html())){

            //마켓포인트가 있을때
            if(Number($("#orgReserveAmt").val())>0){
                //1순위 pg , 2순위 마켓포인트
                $('#pgAmt').val(Number($("#refundAmt").val())-Number($("#orgReserveAmt").val()));
                $('#payReserveAmt').val(Number($("#refundAmt").val())-Number($("#pgAmt").val()));
            }else{
                $('#pgAmt').val($("#refundAmt").val());
                $('#payReserveAmt').val(0);
            }
        }
    }else {
        // pg 혹은 무통장으로 결제하고 마켓포인트가 없을시
        if(Number($('#tempPgAmt').html())>0 && Number($('#payReserveAmt').val())==0){
            $('#pgAmt').val(Number($("#refundAmt").val()));
            $('#payReserveAmt').val(0);
        }else {
            // 환불금액에서  pg 혹은 무통장금액을 제외했을때 0보다 크면 ( 마켓포인트 복합결제 있는지 확인 )
            if(Number($("#refundAmt").val())-Number($('#pgAmt').val())>0){
                $('#pgAmt').val(0);
                $('#payReserveAmt').val(Number($("#refundAmt").val())-Number($('#pgAmt').val()));
            }else{
                $('#pgAmt').val(0);
                $('#payReserveAmt').val(0);
            }
        }
    }
}*/


function calcAmt() {
    if ($('#modifyAmt').val() == "") {
        $('#modifyAmt').val(0)
    }
    if ($('#payReserveAmt').val() == "") {
        $('#payReserveAmt').val(0)
    }
    var modifyAmt = parseInt($('#modifyAmt').val().replaceAll(',', ''));
    var orgReserveAmt = parseInt($('#orgReserveAmt').val());
    var payReserveAmt = parseInt($('#payReserveAmt').val().replaceAll(',', ''));
    var refundAmt = parseInt($('#modifyAmt').val().replaceAll(',', ''));
    var estimateAmt = parseInt($("#estimateAmt").html().replaceAll(',', ''));
    var pgAmt = parseInt($('#pgAmt').val().replaceAll(',', ''));
    var tempReserveAmt = parseInt($("#tempReserveAmt").html().replaceAll(',', ''));
    var tempPgAmt = parseInt($("#tempPgAmt").html().replaceAll(',', ''));

    // 환불 마켓포인트은 최초 지불액보다 클 수 없음
    if (payReserveAmt > orgReserveAmt)
        payReserveAmt = orgReserveAmt;
    // 환불조정금액이 환불예상금액보다 클때 금액 리셋
    if (estimateAmt <= modifyAmt) {
        //console.log(estimateAmt + ',' + modifyAmt + ',' + tempPgAmt);
        modifyAmt = estimateAmt;
        if (tempPgAmt > 0) {
            if (modifyAmt <= tempPgAmt) {
                pgAmt = modifyAmt
            } else {
                pgAmt = estimateAmt - tempReserveAmt;
            }
        } else {
            pgAmt = 0;
        }
        /*if (tempReserveAmt > 0) {
            payReserveAmt = estimateAmt - pgAmt;
        } else {
            payReserveAmt = 0;
        }
*/
    } else {
        //console.log(estimateAmt + ',' + modifyAmt + ',' + tempPgAmt);
        if (tempPgAmt > 0) {
            if (modifyAmt <= tempPgAmt) {
                pgAmt = modifyAmt
            } else {
                pgAmt = modifyAmt - tempReserveAmt;
            }
        } else {
            pgAmt = 0;
        }
        /*if (tempReserveAmt > 0) {
            payReserveAmt = modifyAmt - pgAmt;
        } else {
            payReserveAmt = 0;
        }*/

        /*if (modifyAmt < payReserveAmt)
            payReserveAmt = modifyAmt;*/

        if (modifyAmt - payReserveAmt > 0)
            pgAmt = modifyAmt - payReserveAmt;
        else
            pgAmt = 0;
    }

    $("#restAmt").val(tempPgAmt - modifyAmt);
    $('#modifyAmt').val(commaNumber(modifyAmt));
    $('#refundAmt').val(commaNumber($('#modifyAmt').val()));
    $('#pgAmt').val(commaNumber(pgAmt));
    $('#payReserveAmt').val(commaNumber(payReserveAmt));
}

function preCheckGoods(e) {
    $('#preCheckGoods').val(e);
}

function curCheckGoods(e) {
    $('#curCheckGoods').val(e);
}



function refundGo(refundType){
    //e.preventDefault();
    //e.stopPropagation();

    // console.log("refundType = ", refundType);
    $("#tbody_refund_data").find(".searchRefundResult").each(function() {
        $(this).remove();
    });

    jQuery("#tr_refund_data_template").hide();
    jQuery('#tr_no_refund_data').show();
    var comma = ',';
    var ordNoArr = ''
        , ordDtlSeqArr = ''
        , claimQttArr = ''
        , claimGoodsNoArr = '';
    var estimateAmtArr = 0;

    console.log("$(\"[name=refund_ordNo]:checked\") ", $("[name=refund_ordNo]:checked").length);
    if($("[name=refund_ordNo]:checked").length==0){
        alert("선택된 항목이 없습니다.");
        return false
    }
    ordNo = $("#label_refundOrdNo").text();
    $('input[name=refund_ordNo]:checked').map(function() {
        if($(this).val()!='') {
            var strArr = $(this).val().split(':');
            ordNoArr += strArr[0];
            ordNoArr += comma;
            ordDtlSeqArr += strArr[1];
            ordDtlSeqArr += comma;
            claimGoodsNoArr += strArr[2];
            claimGoodsNoArr += comma;

            var _el = $(this).parents('tr').find('[name=claimQtt]');
            /*if(_el.is('select')){
                claimQttArr+=_el.find('option:selected').val();
                claimQttArr += comma;
            }else*/{
                claimQttArr+=_el.val();
                claimQttArr += comma;
            }

        }
    });

    var url = '/admin/order/refund/paycancel-info-layer',
    dfd = jQuery.Deferred();
    var param =
        {
            ordNoArr: ordNoArr,
            ordDtlSeqArr: ordDtlSeqArr,
            ordNo: ordNo,
            claimQttArr: claimQttArr,
            claimGoodsNoArr : claimGoodsNoArr,
            refundType : refundType
        };
    console.log("param = ", param);
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        if (result == null || result.success != true) {
            alert("데이터가 존재하지 않습니다.");
            return;
        }

        console.log("result = ", result);
        // 취득결과 셋팅
        var refundAmt =0;
        // 반품처리 가능여부
        var confirmYn=0;
        ordRefundPopup.addDlvrAmtType = 0;
        ordRefundPopup.totalDlvrAmt = 0;
        jQuery.each(result.data.claimGoodsVO, function(idx, obj) {

            var trId = obj.ordNo + ":" + obj.ordDtlSeq;
            var $tmpSearchResultTr = "";
            var $tmpSearchResultTr = $("#tr_refund_data_template").clone().show().removeAttr("id");
            $($tmpSearchResultTr).attr("id", trId).addClass("searchRefundResult");
            $('[data-bind="refundInfo"]', $tmpSearchResultTr).DataBinder(obj);
            $("#tbody_refund_data").append($tmpSearchResultTr);

            // 선텍된 상품중 무료 배송이 하나라도 있으면 타입 2
            if((obj.dlvrAddAmt + obj.dlvrAmt + obj.realDlvrAmt) == 0) {
                ordRefundPopup.addDlvrAmtType = 2;
            } else if((obj.dlvrAddAmt + obj.dlvrAmt + obj.realDlvrAmt) > 0) {
                if(ordRefundPopup.addDlvrAmtType != 2) {
                    ordRefundPopup.addDlvrAmtType = 1;
                }
            }
            console.log("obj.claimReasonCd = ", obj.claimReasonCd);
            if(obj.claimReasonCd != null && obj.claimReasonCd != ''){
                //$("#refundReasonCd").val(obj.claimReasonCd);
                $("#refundReasonCd").val(obj.claimReasonCd).prop("selected", true);
                $("#refundReasonCd2").text($("#refundReasonCd option:selected").text());
            } else {
                console.log("default selected");
                $("#refundReasonCd option:eq(0)").prop("selected", true);
                $("#refundReasonCd2").text($("#refundReasonCd option:selected").text());
                /*$('#refundReasonCd').change();*/
            }
            if(obj.returnCd!=''){
                //$("#refundReturnCd").val(obj.returnCd);

                $("#refundReturnCd").val(obj.returnCd).prop("selected", true);
                $("#refundReturnCd2").text($("#refundReturnCd option:selected").text());
                $("#orgRefundReturnCd").val(obj.returnCd);
            }
            if(obj.claimCd!=''){
                //$("#refundClaimCd").val(obj.claimCd);
                $("#refundClaimCd").val(obj.claimCd).prop("selected", true);
                $("#refundClaimCd2").text($("#refundClaimCd option:selected").text());

            }

            // 반품상태, 환불상태가 완료인 경우 수정 불가
            if(!obj.returnCd=='12'&& !obj.claimCd=='12') {
                confirmYn++;
            }

            if(confirmYn > 0){
                $("select[name=refundReturnCd]").attr("disabled","disabled");
                $("select[name=refundClaimCd]").attr("disabled","disabled");
                $("select[name=refundReasonCd]").attr("disabled","disabled");
                jQuery('#btn_refund_reg').hide();
                jQuery('#btn_refund_close').show();
            }else{
                $("select[name=refundReturnCd]").removeAttr("disabled");
                $("select[name=refundClaimCd]").removeAttr("disabled");
                $("select[name=refundReasonCd]").removeAttr("disabled");

                $("#refundReasonCd").val(obj.claimReasonCd).prop("selected", true);
                $("#refundReasonCd2").text($("#refundReasonCd option:selected").text());
                $("#refundReturnCd").val(obj.returnCd).prop("selected", true);
                $("#refundReturnCd2").text($("#refundReturnCd option:selected").text());
                $("#refundClaimCd").val(obj.claimCd).prop("selected", true);
                $("#refundClaimCd2").text($("#refundClaimCd option:selected").text());
                jQuery('#btn_refund_reg').show();
                jQuery('#btn_refund_close').hide();
            }
        });

         // 결제취소정보
        var objP = result.data.claimPayRefundVO;
        if(objP!=null){
        $("#refundMemo").val(objP.claimMemo);
        Dmall.DaumEditor.setContent('refundDtlReason', objP.claimDtlReason); // 에디터에 데이터 세팅
        Dmall.DaumEditor.setAttachedImage('refundDtlReason', objP.attachImages); // 에디터에 첨부 이미지 데이터 세팅
        /*$("#refundDtlReason").val(objP.claimDtlReason);*/
        $("#payPgCd").val(objP.payPgCd);
        $("#payPgWayCd").val(objP.payPgWayCd);
        $("#payPgAmt").val(objP.payPgAmt);
        $("#payUnpgCd").val(objP.payUnpgCd);
        $("#payUnpgWayCd").val(objP.payUnpgWayCd);
        $("#payUnpgAmt").val(objP.payUnpgAmt);
        $("#payReserveCd").val(objP.payReserveCd);
        $("#payReserveWayCd").val(objP.payReserveWayCd);
        $("#orgReserveAmt").val(objP.payReserveAmt);
        $("#bankCd").val(objP.bankCd).prop("selected", true);
        $("#bankCd2").text($("#bankCd option:selected").text());
        $("#tempReserveAmt").html(commaNumber(objP.payReserveAmt));

        //$('#bankCd option[value=objP.bankCd]').attr('selected', 'selected');

        $("#actNo").val(objP.actNo);
        $("#holderNm").val(objP.holderNm);
        $("#totalDlvrAmt").val(objP.totalDlvrAmt);
        $("#realDlvrAmt").val(objP.realDlvrAmt);
        ordRefundPopup.totalDlvrAmt = objP.totalDlvrAmt;
        /*$("#restAmt").val(objP.restAmt);*/
        // 환불 금액
            /*var eAmt = (objP.payPgAmt + objP.payUnpgAmt + objP.payReserveAmt ) - objP.restAmt;*/
            /*var eAmt = (objP.saleAmt * objP.claimQtt )-objP.dcAmt*/
        var dlvrAmt = 0;
        if(objP.dlvrAmt == null || objP.dlvrAmt == '' || objP.dlvrAmt == '0') {
            if(objP.realDlvrAmt == null || objP.realDlvrAmt == '' || objP.realDlvrAmt == '0') {
                dlvrAmt = objP.dlvrAddAmt;
            } else {
                dlvrAmt = objP.realDlvrAmt + objP.dlvrAddAmt;
            }
        } else {
            dlvrAmt = objP.dlvrAmt + objP.dlvrAddAmt;
        }

            /*var dlvrAmt = 0;
            if(objP.dlvrAmt == null || objP.dlvrAmt == '' || objP.dlvrAmt == '0') {
                if(objP.realDlvrAmt == null || objP.realDlvrAmt == '' || objP.realDlvrAmt == '0') {
                    dlvrAmt = 0;
                } else {
                    dlvrAmt = objP.realDlvrAmt;
                }
            } else {
                dlvrAmt = objP.dlvrAmt;
            }*/
        var eAmt = objP.eamt + dlvrAmt - objP.goodsDmoneyUseAmt;
        // 전체 결제 금액
        var tAmt = objP.orgPayPgAmt + objP.orgPayUnpgAmt;
        // pg전체 결제 금액
        var pAmt = objP.payPgAmt + objP.payUnpgAmt;

        $("#restAmt").val(pAmt-eAmt);
        $("#estimateAmt").html(commaNumber(eAmt));
        $("#modifyAmt").val(commaNumber(eAmt));
        $("#refundAmt").val(commaNumber(eAmt));

        ordRefundPopup.orgPgAmt = eAmt;
        ordRefundPopup.orgModAmt = eAmt;
        ordRefundPopup.orgRefAmt = eAmt;

        // 환불 금액 계산
        if(objP.payUnpgAmt > 0 ) { // 가상계좌 결제
            // 실제 환불금액
            // if (eAmt<objP.payUnpgAmt){
                $("#pgAmt").val(commaNumber(eAmt));
            // }else {
            //     $("#pgAmt").val(commaNumber(objP.payUnpgAmt));
            // }
            $("#pgtype1").html("가상계좌 환불");
            $("#pgType option:eq(1)").replaceWith("<option value='01' selected>가상계좌 환불</option>");
            $("#tempPgAmt").text(commaNumber(eAmt));
            jQuery('#bankInfo').show();

        } else if(objP.payPgAmt > 0 ) {// pg 결제
            // 실제 환불금액
            // if (eAmt<objP.payPgAmt){
                $("#pgAmt").val(numberWithCommas(eAmt));
            // }else {
            //     $("#pgAmt").val(numberWithCommas(objP.payPgAmt));
            // }
            // console.log("pgType set = ", "02");
            $("#pgType").val("02");

            // 최초결제금액
            $("#tempPgAmt").text(numberWithCommas(eAmt));
            $("#pgtype1").html("PG 환불");
            $("#pgType option:eq(2)").replaceWith("<option value='02' selected>PG 환불</option>");
            jQuery("#bankInfo").hide();
        }else{
            $("#pgType").val(0);
            $("#tempPgAmt").text(0);
            $("#pgAmt").val(0);

            $("#pgtype1").html("");
            /*$("#pgType option:eq(1)").replaceWith("<option value='01'>무통장 환불</option>");
            $("#pgType option:eq(2)").replaceWith("<option value='02'>PG 환불</option>");*/
            jQuery("#bankInfo").hide();
        }

        // 마켓포인트 환불 계산 최대금액측정
        // 이제 마켓포인트는 결제 상품 별로 나눠서 이미 책정 되기 때문에 따로 계산이 필요 없음
        /*if(pAmt > eAmt){
            //alert("환불금액보다 pg 금액이크다");
            $("#payReserveAmt").val(0);
        }else if(pAmt < eAmt){
            //alert("환불금액보다 pg 금액이 작다");
            if (eAmt-pAmt>objP.payReserveAmt){
                //alert("마켓포인트보다 남은 금액이 크다");
                $("#payReserveAmt").val(numberWithCommas(objP.payReserveAmt));
            }else {
                //alert("마켓포인트보다 남은 금액이 작다");
                $("#payReserveAmt").val(numberWithCommas(tAmt-pAmt));
            }
        }*/
        $("#payReserveAmt").val(commaNumber(objP.goodsDmoneyUseAmt));

        // 부분취소 확인
        if(eAmt != tAmt){
            $("#partCancelYn").val("Y");
        }else {
            $("#partCancelYn").val("N");
        }

        // 결과가 없을 경우 NO DATA 화면 처리
        if ( $("#tbody_refund_data").find(".searchRefundResult").length < 1 ) {
            jQuery('#tr_no_refund_data').show();
        } else {
            jQuery('#tr_no_refund_data').hide();
        }

        $("input[name=refundAmt]").attr("disabled","disabled");
        $("select[name=pgType]").attr("disabled","disabled");


            if(refundType=='M'){
                // 반품/환불 신청화면
                $("input[name=modifyAmt]").attr("disabled","disabled");
                $("input[name=pgAmt]").attr("disabled","disabled");
                $("input[name=payReserveAmt]").attr("disabled","disabled");
                $("#refundReasonCd").val('10').prop("selected", true);
                $("#refundReasonCd2").text($("#refundReasonCd option:selected").text());
                $("#refundReturnCd").val('11').prop("selected", true);
                $("#refundReturnCd2").text($("#refundReturnCd option:selected").text());
                $("#refundClaimCd").val('11').prop("selected", true);
                $("#refundClaimCd2").text($("#refundClaimCd option:selected").text());
                /*$("select[name=refundReturnCd]").attr("disabled","disabled");
                $("select[name=refundClaimCd]").attr("disabled","disabled");
                $("select[name=bankCd]").attr("disabled","disabled");
                $("input[name=actNo]").attr("disabled","disabled");
                $("input[name=holderNm]").attr("disabled","disabled");
                $("select[name=refundReasonCd]").attr("disabled","disabled");
                $("textarea[name=refundMemo]").attr("disabled","disabled");
                $("textarea[name=refundDtlReason]").attr("disabled","disabled");*/
                if($("#refundClaimCd").val()=='12'){
                    jQuery('#btn_refund_reg').hide();
                    jQuery('#btn_refund_close').show();

                }else{
                    jQuery('#btn_refund_reg').show();
                    jQuery('#btn_refund_close').hide();
                }
            }else {

                if($("#refundClaimCd").val()=='12'){
                    $("input[name=modifyAmt]").attr("disabled","disabled");
                    $("input[name=pgAmt]").attr("disabled","disabled");
                    $("input[name=payReserveAmt]").attr("disabled","disabled");

                    $("#bankCd").attr("disabled","disabled");
                    $("#actNo").attr("disabled","disabled");
                    $("#holderNm").attr("disabled","disabled");

                    jQuery('#btn_refund_reg').hide();
                    jQuery('#btn_refund_close').show();

                }else{
                    $("input[name=modifyAmt]").removeAttr("disabled");
                    $("input[name=pgAmt]").removeAttr("disabled");
                    $("input[name=payReserveAmt]").removeAttr("disabled");
                    $("select[name=refundReturnCd]").removeAttr("disabled");
                    $("select[name=refundClaimCd]").removeAttr("disabled");
                    $("select[name=bankCd]").removeAttr("disabled");
                    $("input[name=actNo]").removeAttr("disabled");
                    $("input[name=holderNm]").removeAttr("disabled");
                    $("select[name=refundReasonCd]").removeAttr("disabled");
                    $("textarea[name=refundMemo]").removeAttr("disabled");
                    $("textarea[name=refundDtlReason]").removeAttr("disabled");

                    jQuery('#btn_refund_reg').show();
                    jQuery('#btn_refund_close').hide();

                    console.log("refundReasonCd ", $("#refundReasonCd").val());
                    if($("#refundReasonCd").val() == '50') {
                        $("#pgAmt").val(commaNumber(Number($("#pgAmt").val().replace(",", "")) - 2500));
                        $("#modifyAmt").val(commaNumber(Number($("#modifyAmt").val().replace(",", "")) - 2500));
                        $("#refundAmt").val(commaNumber(Number($("#refundAmt").val().replace(",", "")) - 2500));
                        $("#estimateAmt").html(commaNumber(Number($("#estimateAmt").html().replace(",", "")) - 2500));
                    }
                }
            }
        }
        /*preCheckGoods($("#refund_ordNo:checked").length);
        curCheckGoods($("#refund_ordNo:checked").length);*/

        preCheckGoods($("input[id^=refund_ordNo]:checked").length);
        curCheckGoods($("input[id^=refund_ordNo]:checked").length);


    });

}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function commaNumber(p) {
    if (p == 0) return 0;
    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (p + '');
    while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
    return n;
};
