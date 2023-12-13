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
    <t:putAttribute name="title">홈 &gt; 상품관리 &gt; 매거진관리 &gt; 매거진등록</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
        <style>
        	.forceHide {
        		display:none !important;
        	}
        </style>
    </t:putAttribute>
    <t:putAttribute name="script">
    	<script type="text/javascript" src="/admin/js/lib/jquery/jquery.qrcode.min.js"></script>
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
        
            jQuery(document).ready(function() {
        		//qrcode
                $('#qrcodeCanvas').qrcode({
        	        width: 100,
        	        height: 100,
        	        text: "http://www.davichmarket.com/m/front/qrcode?goodsNo=${resultModel.data.goodsNo}"
        		});
                
                fn_setDefault();
                
                // 매거진 등록 화면 표시를 위한 화면 설정
                getDefaultDisplayInfo('${resultModel.data.editModeYn}');
                
                fn_loadEditor();
                
                // fn_setTestData();
                
                // 화면 이벤트 설정
                // 매거진등록 버튼 이벤트 설정
                jQuery('#btn_regist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_registGoods();
                });
                // 매거진리스트 버튼 이벤트 설정
                jQuery('#btn_goods_list').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    location.href= "/admin/goods/sales-item";
                });

                // 매거진등록(대량) 버튼 이벤트 설정
                jQuery('#btn_goods_regist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    location.href= "/admin/goods/goods-bulk-regist";
                });


                // 카테고리 선택 버튼 이벤트 설정
                jQuery('#btn_choice_ctg').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_registCtg();
                });

                // 카테고리 등록 버튼 이벤트 설정
                jQuery('#btn_regist_ctg').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    location.href="/admin/goods/category-info";
                });

                // 고시정보 변경 시 이벤트 설정
                jQuery('#sel_goods_notify').off("change").on('change', function(e) {
                    // Dmall.EventUtil.stopAnchorAction(e);
                    getGoodsNotifyList($(this).val());
                });
                // 이미지 관련 - 끝
                // 이미지세트 추가 버튼 클릭 이벤트 설정                
                jQuery('#btn_regist_image').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if ( null == $("#input_id_image").val() || $("#input_id_image").val().length < 1) {
                        Dmall.LayerUtil.alert("등록할 상품 이미지를 선택해 주세요.");
                        return;
                    } 
                    jQuery('#form_id_imageUploadForm').attr('action', '/admin/goods/goods-image-upload');
                    jQuery.when(Dmall.FileUpload.upload('form_id_imageUploadForm')).then(
                    // jQuery.when(submitImage('form_id_imageUploadForm')).then(
                    function (result) {
                        //
                        var files = result.files
                        , $img_param = $("#hd_img_param_2")
                        , kind = $img_param.data("kind")
                        , type = $img_param.data("type")
                        , row = $img_param.data("setIdx");
                        
                        // 리턴되는 이미지 파일 데이터가 있을 경우
                        if (files) {                        
                          // 개별 등록의 경우, 등록 이미지와 Thumbnail 이지 2개가 생성
                          if (files.length == 2) {
                              var data = {
                                      idx : 0,
                                      src : files[0].thumbUrl,
                                      type : files[0].imgType,
                                      tempFileName : files[0].tempFileName,
                                      imgUrl : files[0].imageUrl,
                                      imageWidth :  files[0].imageWidth,
                                      imageHeight :  files[0].imageHeight,
                                      fileSize :  files[0].fileSize,
                                      isTempYn : "Y"
                                  };
                              if ('GOODS' === kind) {
                                  $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                  $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                              } else {
                                  $('[data-bind="disp_img_info"]', '#tr_disp_img_1').DataBinder(data);
                                  $('[data-bind="disp_img_info"]', '#tr_disp_img_2').DataBinder(data);
                              }
                        
                          // 일괄 등록의 경우
                          } else {
                              $.each(files, function(idx, file){
                                  var data = {
                                          idx : idx,
                                          src : file.thumbUrl,
                                          type : file.imgType,
                                          tempFileName : file.tempFileName,
                                          imgUrl : file.imageUrl,
                                          imageWidth :  file.imageWidth,
                                          imageHeight :  file.imageHeight,
                                          fileSize :  file.fileSize,
                                          isTempYn : "Y"
                                      };
                                  if ('GOODS' === kind) {
                                      $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                      $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                  } else {
                                      $('[data-bind="disp_img_info"]', '#tr_disp_img_1').DataBinder(data);
                                      $('[data-bind="disp_img_info"]', '#tr_disp_img_2').DataBinder(data);
                                  }
                              });
                          }
                        }
                        $("#form_id_imageUploadForm")[0].reset();
                        
                        // $("#btn_close_layer_upload_image").trigger('click');
                        GoodsLayerPopupUtil.close('layer_upload_image');
                    });
                });
                
                jQuery('#btn_cancel').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#btn_close_layer_upload_image").trigger('click');
                });
                
                // 미리보기 버튼 클릭 이벤트 - 메인
                jQuery('#btn_preview').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.init.ajax();
                    
                     if(checkValidation() && Dmall.validate.isValid('form_goods_info')) {
                         GoodsValidateUtil.setValueToTextarea('ta_goods_content');  // 에디터에서 폼으로 데이터 세팅
                         GoodsValidateUtil.setValueToTextarea('ta_mobile_content');  // 에디터에서 폼으로 데이터 세팅

                        
                        var url = '/front/goods/goods-preview'
                            , param = fn_getGoodsPreviewData()
                            , paramContents = $('#form_goods_detail_info').serializeObject()
                            , attachImages = {'attachImages' : $('#ta_goods_content').data('attachImages'),'mobileAttachImages' : $('#ta_mobile_content').data('attachImages')}
                        ;                          
                        var paramMerge = $.extend(paramContents, param, attachImages);
                        
                        var paramMergeToStr =  JSON.stringify(paramMerge);

                        openWindow(url, function(parameter){
                            this.loadPreviewInfo(parameter);
                        }, paramMergeToStr);
                    }
                });
                
                var newWindow = null;
                function openWindow(path, callback, param){
                    if ((newWindow != null) && !(newWindow.closed)) {
                        newWindow.close();
                    }
                    var args = Array.prototype.slice.call(arguments, 2);
                        newWindow = window.open(path,'','width='+1200+',height='+800+',toolbars=no,menubars=no,scrollbars=yes');
                    if (newWindow.addEventListener){
                      newWindow.addEventListener('load', afterLoadWindow.bind(newWindow, args), false);
                    } else if (newWindow.attachEvent){
                      newWindow.attachEvent('onload', afterLoadWindow.bind(newWindow, args));
                    }
                    
                    function afterLoadWindow(){
                        callback.apply(this, arguments[0]);
                    }
                }
                
                // 아이콘 취소 버튼 클릭 이벤트
                jQuery('#btn_cancel_icon').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#btn_close_add_icon").trigger('click');
                });
                // 이미지 관련 - 끝
             
                // 추가옵션 관련 - 시작
                // 추가 옵션 옵션 추가 버튼 클릭 이벤트 설정 
                jQuery('#btn_add_add_option0').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_addAddOptionRow();
                });
                
                // 추가 옵션 아이템(옵션 하위레벨) 추가 버튼 클릭 이벤트 설정 
                jQuery('#btn_add_add_option_item0').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    addOptionItem($(this));
                });
             
                // 옵션만들기 팝업 ROW 추가 버튼 클릭 이벤트 설정
                jQuery("#btn_add_item").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if ( null == $('th:visible', '#tr_pop_goods_item_head_2').eq(0).data("optNm")){
                        Dmall.LayerUtil.alert('등록할 옵션 정보를 생성해 주세요');

                    } else {
                        addPopItemOption(null);
                    }
                });
                // 추가옵션 관련 - 끝
                
                
                // 옵션 관련 - 시작
                // 옵션 만들기 버튼 클릭 이벤트 설정 [메인 화면]
                jQuery('#btn_create_goods_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    // 메인화면의 정보로 옵션만들기 화면을 생성한다.
                    createGoodsOptionTable();
                    Dmall.LayerPopupUtil.open(jQuery('#layer_create_goods_option'));

                });
                // 옵션 미리보기 버튼 클릭 이벤트 설정 [메인 화면]
                jQuery('#btn_preview_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    // 메인화면의 정보로 옵션만들기 화면을 생성한다.
                    createPreviewOption();
                    
                    Dmall.LayerPopupUtil.open(jQuery('#layer_preview_option'));
                });                
                
                // 옵션 불러오기 클릭 시 이벤트 설정
                jQuery('#btn_load_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    loadRecentOption();
                });
                
                // 옵션 만들기 팝업에서 생성 및 변경 버튼 클릭 이벤트 설정
                jQuery('#btn_create_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    
                    $("#tr_option_template").hide();
                    $("tr.regist_option", $("#tbody_option")).remove();
                    
                    var optData = loadOptData();
                    if (optData.length < 1) {
                        jQuery('#btn_add_option').trigger('click');
                    } else {
                        jQuery.each(optData, function(idx, obj) {
                            GoodsLayerPopupUtil.add_option(obj);
                        });
                    }
                    GoodsLayerPopupUtil.open(jQuery('#layer_create_option'));
                });
                // 옵션 생성 및 변경 팝업의 더하기 버튼 클릭 이벤트 설정
                jQuery('#btn_add_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    GoodsLayerPopupUtil.add_option();
                });
                // 옵션 생성하기 버튼 클릭 이벤트 설정
                jQuery('#btn_execute_create_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    GoodsLayerPopupUtil.create_option(fn_execute_create_option, $("#hd_goodsNo").val());
                });
                
                // 옵션만들기 팝업화면에서 적용하기 버튼 클릭 이벤트 
                jQuery('#btn_apply_main_goods').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if(!fn_applyMainGoods()) return;
                    $("#btn_close_layer_goods_option").trigger('click');
                });
                
                jQuery('#btn_close_layer_goods_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('layer_create_goods_option');
                });
                
                jQuery('#btn_close_layer_create_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    GoodsLayerPopupUtil.close('layer_create_option');
                });
                // 옵션 관련 - 끝
                
                // 관련상품 선택 방법 설정 라디오 버튼 이벤트 설정
                jQuery('label.radio', $("#tbody_relate_goods")).off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    
                    var $this = $(this),
                        $input = jQuery("#" + $this.attr("for"));
                    
                    $("input:radio[name=" + $input.attr("name") + "]", $("#tbody_relate_goods")).each(function() {
                        $(this).removeProp('checked');
                        $("label[for=" + $(this).attr("id") + "]", $("#tbody_relate_goods")).removeClass('on');
                    });
                    $input.prop('checked', true).trigger('change');
                    
                    if ($input.prop('checked')) {
                        $this.addClass('on');
                        // 라디오 선택 값에 따른 이벤트 설정
                        if ('1' == $input.val()) {
                        } else {
                        }
                    }
                });
                
                // 추가옵션 사용 여부 설정 라디오 버튼 이벤트 설정
                jQuery('label.radio', $("#tbody_add_option_set")).off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = $(this),
                        $input = jQuery("#" + $this.attr("for"));
                    
                    $("input:radio[name=" + $input.attr("name") + "]", "#tbody_add_option_set").each(function() {
                        $(this).removeProp('checked');
                        $("label[for=" + $(this).attr("id") + "]", "#tbody_add_option_set").removeClass('on');
                    });
                    $input.prop('checked', true).trigger('change');
                    
                    if ($input.prop('checked')) {
                        $this.addClass('on');
                        // 라디오 선택 값에 따른 이벤트 설정
                        if ('Y' == $input.val()) {
                            $('div.tblw_b', '#tbody_add_option_set').show();
                            $('button, select, input', '#tbody_add_option').prop("disabled", false);
                        } else {
                            $('button, select, input', '#tbody_add_option').prop("disabled", true);
                            $('div.tblw_b', '#tbody_add_option_set').hide();
                        }
                    }
                });                
                
                // 관련 상품 조건 설정 (관련상품 조건설정 팝업 호출)
                jQuery('#btn_relate_goods_condition').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if ('1' == $('input:radio[name=relateGoodsApplyTypeCd]:checked', '#tbody_relate_goods').val()) {
                        getRelateCategoryOptionValue('1', jQuery('#sel_relate_ctg_1'), '', $('#sel_relate_ctg_1').data('relateGoodsApplyCtgNo'));
                        
                        
                        if(null != $('#div_display_relate_goods_condition').data('conditionData')) {
                            $('[data-bind=relate_info]', '#div_relate_goods').DataBinder($('#div_display_relate_goods_condition').data('conditionData'));
                        }
                        Dmall.LayerPopupUtil.open(jQuery('#layer_relate_goods_condition'));
                    } else {
                        $('#tbody_relate_goods').data('sel', '1');
                        Dmall.LayerUtil.confirm('관련 상품을 자동 선정으로 변경 하시겠습니까?', fn_changeRelateGoodsApplyType);
                    }
                });
                // 관련 매거진 검색 (상품검색 팝업 호출)
                jQuery('#btn_relate_goods_srch').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if ('2' == $('input:radio[name=relateGoodsApplyTypeCd]:checked', '#tbody_relate_goods').val()) {
                        Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
                        // 상품 검색 콜백함수 설정
                        GoodsSelectPopup._init( fn_callback_pop_apply_goods );
                    } else {
                        $('#tbody_relate_goods').data('sel', '2');
                        Dmall.LayerUtil.confirm('관련 상품을 직접 선정으로 변경 하시겠습니까?', fn_changeRelateGoodsApplyType);
                    }
                });
                // 카테고리1 변경시 이벤트 - 관련상품 조건 설정 팝업
                jQuery('#sel_relate_ctg_1').off("change").on('change', function(e) {
                    changeCategoryOptionValue('2', $(this));
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_relate_ctg_2_def').focus();
                });
                // 카테고리2 변경시 이벤트 - 관련상품 조건 설정 팝업
                jQuery('#sel_relate_ctg_2').off("change").on('change', function(e) {
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_relate_ctg_3_def').focus();
                });
                // 카테고리3 변경시 이벤트 - 관련상품 조건 설정 팝업
                jQuery('#sel_relate_ctg_3').off("change").on('change', function(e) {
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_relate_ctg_4_def').focus();
                });
                
                // 저장하기 버튼 클릭 이벤트 - 메인
                jQuery('#btn_confirm, #btn_confirm2').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.init.ajax();
                   
                     if(checkValidation() && Dmall.validate.isValid('form_goods_info')) {
                         GoodsValidateUtil.setValueToTextarea('ta_goods_content');  // 에디터에서 폼으로 데이터 세팅
                         GoodsValidateUtil.setValueToTextarea('ta_mobile_content');  // 에디터에서 폼으로 데이터 세팅
                         //Dmall.DaumEditor.setValueToTextarea(['ta_goods_content', 'ta_mobile_content']);  // 에디터에서 폼으로 데이터 세팅
                        
                        var url = '/admin/goods/goods-info-insert'
                            , param = fn_getGoodsRegistData()
                            , paramContents = $('#form_goods_detail_info').serializeObject()
                            , paramContents1 = $('#form_goods_detail_info').serialize()
                            , attachImages = {'attachImages' : $('#ta_goods_content').data('attachImages'),'mobileAttachImages' : $('#ta_mobile_content').data('attachImages')}
                            , deletedImages = {'deletedImages' : $('#ta_goods_content').data('deletedImages'),'mobileDeletedImages' : $('#ta_mobile_content').data('deletedImages')}
                            , result1
                            , result2
                        ;                          
                        var paramMerge = $.extend(paramContents, param,attachImages,deletedImages);
                        Dmall.waiting.start();
                        $.ajax({
                              url : url
                            , method : "post"
                            , dataType : 'json'
                            , data : JSON.stringify(paramMerge)
                            , processData : true
                            , contentType : "application/json; charset=UTF-8"
                        }).done(function(result) {
                            if (result) {
                                GoodsValidateUtil.viewGoodsExceptionMessage(result, 'form_goods_info');
                                if (result == null || result.success != true) {
                                    Dmall.waiting.stop();
                                    return;
                                } else {
                                    getDefaultDisplayInfo('Y');
                                    getEditorDataInfo();
                                }
                                
                            } else {
                                Dmall.validate.viewExceptionMessage(xhr, 'form_goods_info');
                            } 
                            Dmall.waiting.stop();
                        }).fail(function(result) {
                            if(result.status == 403) {
                                Dmall.LayerUtil.confirm('로그인 정보가 없거나 유효시간이 지났습니다.<br/>로그인페이지로 이동하시겠습니까?',
                                    function() {
                                        document.location.href = '/admin/login/member-login';
                                    });
                            }
                            Dmall.waiting.stop();
                            Dmall.AjaxUtil.viewMessage(result.responseJSON);
                        });
                    }
                });
                
                // 다중옵션판매 버튼 클릭 이벤트 - 메인
                jQuery('#btn_multi_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#hd_multiOptYn").val("Y");
                    $("#div_simple_option").hide();
                    $("#div_multi_option").show();
                    $("#div_simp_hist").hide();
                    $("#tr_erp_itm_code").hide();
                });
                
                // 단일옵션판매 버튼 클릭 이벤트 - 메인
                jQuery('#btn_simple_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#hd_multiOptYn").val("N");
                    $("#div_simple_option").show();
                    $("#div_multi_option").hide();
                    $("#div_simp_hist").show();
                    $("#tr_erp_itm_code").show();
                });
                
                jQuery("label.chack").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = jQuery(this),
                        id =  $this.attr("for"),
                        $input = jQuery("#" + id),
                        checked = !($input.prop('checked'));

                    // 성인 상품 여부 클릭 시 이벤트(화면 로드시 정보와 비교 실시간 체크시는 변경 필요)
                    if(!$input.prop('disabled') && !$input.prop('readonly')) {
                        if ('chk_goods_adult_yn' === id && checked) {
                            // 사이트에 성인 인증 설정이 되어 있는지 확인

                            if ($input.data('isAdultCertifyConfig') && $input.data('isAdultCertifyConfig') !== 'Y') {
                                Dmall.LayerUtil.confirm('성인 인증 설정을 하시겠습니까?', fn_goAdultCertifyPage);
                            }
                        }
                        $input.prop('checked', checked);
                        $this.toggleClass('on');   
                    }
                });
                
                jQuery('#lb_required_0').off("click").on('click', function(e) {                        
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = jQuery(this),
                        $input = $this.parent().find('input'),
                        checked = !($input.prop('checked'));

                    if(!$input.prop('disabled') && !$input.prop('readonly')) {
                        $input.prop('checked', checked);
                        $this.toggleClass('on');
                    }
                });
                
                jQuery('#btn_stck_history').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_checkAdultCertifyConfig();
                });
                
                jQuery('#btn_set_auto_relate_goods').off("click").on('click', function(e) {                        
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_set_relate_goods_condition();
                    // Dmall.LayerPopupUtil.close(jQuery('#layer_relate_goods_condition'));
                    $("#btn_close_relate_goods_condition").trigger('click');
                });
                
                // 단품 수량 변동 이력 [메인 화면 - 재고 이력 버튼]
                jQuery('#btn_qtt_hist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    // 단품 수량 변동 이력 데이터를 취득한다.
                    createItemQttHist($('#hd_goodsNo').val(), $('#hd_itemNo').val());
                    Dmall.LayerPopupUtil.open(jQuery('#layer_qtt_hist'));
                }); 
                
                // 단품 판매 가격 변동 이력 [메인 화면 - 재고 이력 버튼]
                jQuery('#btn_price_hist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    // 단품 수량 변동 이력 데이터를 취득한다.
                    createItemPriceHist($('#hd_goodsNo').val(), $('#hd_itemNo').val());
                    Dmall.LayerPopupUtil.open(jQuery('#layer_price_hist'));
                });    
                
                jQuery('#confirm_qtt_hist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('layer_qtt_hist');
                });
                
                jQuery('#confirm_price_hist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('layer_price_hist');
                });

                jQuery('#txt_sale_price').off("change").on('change', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var sale_price = $(this).val().replaceAll(",",""); // 판매가격
                    var ctgCmsRate = $("input[type=radio][name=mainCategory]:checked").parents("tr").children("td:eq(2)").text().replaceAll("%","");
                    //별도 공급가 적용 여부
                    var sepSupplyPriceYn ="N"

                    if($("#lb_sepSupplyPriceYn").hasClass("on")){
                        sepSupplyPriceYn="Y";
                    }

                    var _input_supply_price = $("#txt_supply_price");
                    var supply_price = 0;
                    
                    var sellerCmsRate = parseInt($("#hd_sellerCmsRate").val());
                    
                    // 판매자별 수수료가 있을경우 우선처리
                    if (sellerCmsRate > 0) {
                        supply_price = sale_price*(1-(sellerCmsRate/100))
                    } else {
                        if(ctgCmsRate>0){
                            _input_supply_price.prop("readonly",true);
                            supply_price = sale_price*(1-(ctgCmsRate/100))
                        }else{
                            supply_price = sale_price;
                        }
                    }
                    
                    supply_price = Math.round(supply_price);
                    if(sepSupplyPriceYn=="N")
                    _input_supply_price.val(numberWithCommas(supply_price));

                });
                // 별도 공급가 적용 체크
                jQuery('#lb_sepSupplyPriceYn').off("click").on('click', function(e) {

                    Dmall.EventUtil.stopAnchorAction(e);

                    var $this = jQuery(this),
                        $input = $this.find('input'),
                        checked = !($input.prop('checked'));


                    $input.prop('checked', checked);

                    if($input.prop("checked")){
                        $("#txt_supply_price").prop("readonly",false);
                        //$input.removeAttr("readonly")
                        $this.addClass('on');

                    }else{
                        $("#txt_supply_price").prop("readonly",true);
                        $this.removeClass('on');
                        jQuery('#txt_sale_price').trigger("change");
                    }


                });

                // 상품상세설명 참조 일괄적용
                jQuery("#desc_all_apply").off("click").on('click', function(e) {
                    var chk = jQuery(this);

                    //만약 전체 선택 체크박스가 체크된상태일경우
                    if(chk.prop("checked")) {
                                $("#tbody_goods_notify").find("input").val('상품 상세설명 참조');
                    } else {
                        $("#tbody_goods_notify").find("input").val('');
                    }
                })



                Dmall.common.numeric();
                Dmall.common.comma();
                Dmall.common.date();
                
                // 개발을 위해 미적용 (개발완료 후 적용)
                Dmall.validate.set('form_goods_info');
                Dmall.validate.set('form_goods_info2');



                jQuery('#goodsTypeCd').off("change").on('change', function(e) {
                    var _val = $(this).val();
                    $('tr[class^=goods_type_]').hide();
                    getGunList(_val);
                    $('tr.goods_type_'+_val).show();
                });

                // 판매자 변경시 이벤트
                $("#sel_seller").off("change").on("change", function() {

                	var selVal = $("#sel_seller option:selected").val();

      				// 판매자 선택시  판매자 수수료율을 가져온다.
                	if (selVal != null && selVal != '') {
                        var sellerNo = $(this).val();
                        var url = '/admin/seller/goods/seller-info',
                        param = {'sellerNo' : sellerNo};

                    	Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    		if (result.success) {
                    			$('#hd_sellerCmsRate').val(result.data.sellerCmsRate);
                    		}
                    	});
                	}
      				
                	if(sellerNo == "1") {
                		// 판매자가 다비치 인 경우
                		// 다비젼 상품 코드 설정 부분 보이기
                		$("#tr_erp_itm_code").removeClass("forceHide");
                		$("#th_multiOptErpItmCode").removeClass("forceHide");	// 다중옵션 제목줄
                		$("#tbody_goods_item td[name=td_erpItmCode]").removeClass("forceHide");	// 다중옵션 값
                		$("#th_multiOptPopErpItmCode").removeClass("forceHide");	// 다중옵션 팝업 제목줄
                		$("#tbody_item input[type=text][name=itemErpItmCode]").closest("td").removeClass("forceHide");	// 다중옵션 팝업 값
                		// 데이터 없는 경우 colspan변경
                		$("#tr_no_goods_item td").attr("colspan", "9");
                	} else {
                		// 판매자가 다비치가 아닌 경우
                		// 다비젼 상품 코드 설정 부분 숨기기
                		$("#tr_erp_itm_code").addClass("forceHide");	// 단일옵션
                		$("#th_multiOptErpItmCode").addClass("forceHide");	// 다중옵션 제목줄
                		$("#tbody_goods_item td[name=td_erpItmCode]").addClass("forceHide");	// 다중옵션 값
                		$("#th_multiOptPopErpItmCode").addClass("forceHide");	// 다중옵션 팝업 제목줄
                		$("#tbody_item input[type=text][name=itemErpItmCode]").closest("td").addClass("forceHide");	// 다중옵션 팝업 값
                		// 데이터 없는 경우 colspan변경
                		$("#tr_no_goods_item td").attr("colspan", "8");
                	}
                });
                // 다비젼 상품 검색 팝업(단일옵션)
                jQuery("#btn_erpItm").on("click", function() {
                	erpItemSearchPop(jQuery("#txt_erp_itm_code"));
                });
                // 라디오 버튼 변경시 다른 애들은 disabled시키자
                jQuery("input[name=erp_itm_srch_type]").off("change").on("change", function() {
                	// 일단 전부다 disabled 시키고
                	$(this).closest("tbody").find("select,input[type=text]").prop("disabled", true);
                	$(this).closest("tbody").find("span.select").addClass("disa");
                	// 자기쪽 것만 disabled 해제
                	$(this).closest("tr").find("select,input[type=text]").prop("disabled", false);
                	$(this).closest("tr").find("span.select").removeClass("disa");
                });
                // 다비젼 상품 검색
                jQuery("#btn_search_erp_itm").off("click").on("click", function() {
                	searchErpItems();
                });
                // 다비젼 상품 검색 취소
                jQuery("#cancel_erp_itm_search").off("click").on("click", function() {
                	Dmall.LayerPopupUtil.close('layer_erp_itm_code');
                });
                // 다비젼 상품 검색 결과 적용
                jQuery("#apply_erp_itm_code").off("click").on("click", function() {
                	if(jQuery("#layer_erp_itm_code [name=erpItmCode]:checked") == null) {
                		Dmall.LayerUtil.alert("선택된 상품이 없습니다.");
                		return;
                	}
                	var erpItmCode = $("#layer_erp_itm_code [name=erpItmCode]:checked").val();
                	jQuery(erpItmCodeTarget).val(erpItmCode);
                	Dmall.LayerPopupUtil.close('layer_erp_itm_code');
                });
                // 브랜드 검색 팝업
                jQuery("#brandNameInput").off("click").on("click", function() {
                	erpItemBrandSearchPop();
                });
                // 브랜드 검색
                jQuery("#btn_search_erp_itm_brand").off("click").on("click", function() {
                	if(jQuery("#erpGoodsBrandSearchForm [name=brandName]").val() == null || jQuery("#erpGoodsBrandSearchForm [name=brandName]").val() == "") {
                		Dmall.LayerUtil.alert("검색할 브랜드명을 입력해 주세요.");
                		return;
                	}
	                var url = "/admin/goods/erp-brand-list";
	                var param = jQuery("#erpGoodsBrandSearchForm").serialize();
                	Dmall.AjaxUtil.getJSON(url, param, setErpItmBrandSearchResult);
                });
                // 브랜드 검색 팝업 취소
                jQuery("#cancel_erp_itm_brand_search").off("click").on("click", function() {
                	Dmall.LayerPopupUtil.close('layer_erp_itm_brand');
                });
                // 브랜드 검색 결과 설정
                jQuery("#apply_erp_itm_brand").off("click").on("click", function() {
                	if(jQuery("#layer_erp_itm_brand [name=brandCode]:checked").length == 0) {
                		Dmall.LayerUtil.alert("선택된 브랜드가 없습니다.");
                		return;
                	}
                	var brandCode = jQuery("#layer_erp_itm_brand [name=brandCode]:checked").val();
                	var brandName = jQuery("#layer_erp_itm_brand [name=brandCode]:checked").siblings("[name=brandName]").val();
                	jQuery("#layer_erp_itm_code").find("#brandCodeInput").val(brandCode);
                	jQuery("#layer_erp_itm_code").find("#brandNameInput").val(brandName);
                	Dmall.LayerPopupUtil.close('layer_erp_itm_brand');
                });
                
				// 할인구분 라디오 체인지 이벤트
				jQuery('input[name="goodsSvmnGbCd"]').change(function(){
					var selVal = $(this).val();
					
					if(selVal == '1'){
						$('#dcValueSpan').text('%');	
					}else{
						$('#dcValueSpan').text('원');
					}
				});
                

            });
            
            // 결과 설정할 input
			var erpItmCodeTarget = null;
            // 상품 검색 데이터 팝업
            function erpItemSearchPop(target) {
            	erpItmCodeTarget = target;
            	if(jQuery("#layer_erp_itm_code").find("#select_itm_kind").children().length == 0) {
            		// 상품 분류가 없는 경우 - 처음 팝업이 뜨는 경우
            		// 상품 분류 가져오기
	                var url = "/admin/goods/erp-item-kind";
	                Dmall.AjaxUtil.getJSON(url, null, function(result) {
	                	var itmKindList = result.data.itmKindList;
	                	var itmKindHtml = "";
	                	for(var i=0; i<itmKindList.length; i++) {
	                		var itmKind = itmKindList[i];
	                		itmKindHtml += "<option value='" + itmKind.code + "'>" + itmKind.name + "</option>";
	                		if(i == 0) {
	                			// 첫번째거 이름 표시
	                			jQuery("#layer_erp_itm_code").find("label[for=select_itm_kind]").text(itmKind.name);
	                		}
	                	}
	                	jQuery("#layer_erp_itm_code").find("#select_itm_kind").html(itmKindHtml);
	                });
	            	// 기본은 상품코드 검색
	            	jQuery('#layer_erp_itm_code input #radio_erp_itm_srch_itmCode').prop("checked", true);
	            	// 결과 화면 숨기기
	             	jQuery('#layer_erp_itm_code #div_erp_itm_search_result').hide();
	            	// 적용 버튼 숨기기
	             	jQuery("#apply_erp_itm_code").hide();
	            	
	            	// 검색 구분 첫번째거 세팅
					Dmall.CheckboxUtil.check($("input[name=erp_itm_srch_type]").closest("label"), false);
					Dmall.CheckboxUtil.check($("input[name=erp_itm_srch_type]").first().closest("label"), true);
	            	$("input[name=erp_itm_srch_type]").first().change();	// 변경 이벤트 강제 발생
            	} else {
	           		// 상품분류 첫번째거 기본 세팅
	           		var firstVal = jQuery("#layer_erp_itm_code").find("#select_itm_kind").children().first().val();
	           		var firstText = jQuery("#layer_erp_itm_code").find("#select_itm_kind").children().first().text();
	           		jQuery("#layer_erp_itm_code").find("#select_itm_kind").val(firstVal);
	           		jQuery("#layer_erp_itm_code").find("label[for=select_itm_kind]").text(firstText);
            	}
            	
            	GoodsLayerPopupUtil.open(jQuery('#layer_erp_itm_code'));
            }
            // ERP 상품 검색
            function searchErpItems() {
            	// 검색조건 입력 확인
            	var searchType = jQuery("input[name=erp_itm_srch_type]:checked").data("bind-value");
            	if(searchType == "itmCode") {
            		if(jQuery("#erpGoodsSearchForm input[name=itmCode]").val() == "") {
            			Dmall.LayerUtil.alert("상품코드를 입력해 주세요.");
            			return;
            		}
            	} else if(searchType == "keyword") {
            		if(jQuery("#erpGoodsSearchForm select[name=itmKind]").val() == "") {
            			Dmall.LayerUtil.alert("상품구분을 입력해 주세요.");
            			return;
            		}
            		if(jQuery("#erpGoodsSearchForm input[name=brandCode]").val() == "") {
            			Dmall.LayerUtil.alert("브랜드를 입력해 주세요.");
            			return;
            		}
            		if(jQuery("#erpGoodsSearchForm input[name=itmName]").val() == "") {
            			Dmall.LayerUtil.alert("상품명을 입력해 주세요.");
            			return;
            		}
            	} else {
            		// 원래는 여기에 걸리지 않아야 하지만 혹시 몰라...
            		Dmall.LayerUtil.alert("검색구분을 선택해 주세요.");
            		return;
            	}
            	
            	if($("#erpGoodsSearchForm [name=page]").val() == "") {
            		$("#erpGoodsSearchForm [name=page]").val("1");
            	}
            	
           		$("#erpGoodsSearchForm [name=pageNo]").val($("#erpGoodsSearchForm [name=page]").val() - 1);
            	
            	
                var url = "/admin/goods/erp-goods-list";
                var param = jQuery("#erpGoodsSearchForm").serialize();
                Dmall.AjaxUtil.getJSON(url, param, setErpItmSearchResult);
            }
            // 상품 검색 결과 화면 표시
            function setErpItmSearchResult(result) {
                var prdList = result.data.prdList;
                var prdListHtml = "";
                if(prdList == null || prdList.length == 0) {
					prdListHtml += "<tr>";
					prdListHtml += "<td colspan='5'>데이터가 없습니다.</td>";
					prdListHtml += "</tr>";
					jQuery("#apply_erp_itm_code").hide();
					jQuery("#div_id_paging").hide();
				} else {
                	for(var i=0; i<prdList.length; i++) {
                		var prd = prdList[i];
                		prdListHtml += "<tr>";
                		prdListHtml += "	<td>";
                		prdListHtml += "		<label for='radio_erp_itm_srch_itmCode_" + prd.itmCode + "' class='radio'>";
                		prdListHtml += "			<span class='ico_comm'>";
                		prdListHtml += "				<input type='radio' name='erpItmCode' id='radio_erp_itm_code_" + prd.itmCode + "' value='" + prd.itmCode + "' />";
                		prdListHtml += "			</span>";
                		prdListHtml += "		</label>";
                		prdListHtml += "	</td>";
                		prdListHtml += "	<td>" + prd.itmCode + "</td>";
                		prdListHtml += "	<td>" + prd.itmName;
                		if(prd.sph != '0' || prd.cyl != '0') {
	                		prdListHtml += "		<br>[SPH: " + prd.sph + " / CYL: " + prd.cyl + "]";
                		}
                		prdListHtml += "	</td>";
                		prdListHtml += "	<td>" + prd.makName + "</td>";
                		prdListHtml += "	<td>" + prd.brandName + "</td>";
                		prdListHtml += "</tr>";

                        // 페이징 처리
                        var resultListModel = new Object();
                        resultListModel.page = $("#erpGoodsSearchForm [name=page]").val();
                        if(resultListModel.page == "") resultListModel.page = "1";
                        resultListModel.totalPages = Math.ceil(result.data.totalCnt / 10);
                        Dmall.GridUtil.appendPaging('erpGoodsSearchForm', 'div_id_paging', resultListModel, 'paging_id_erp_goods_list', searchErpItems);
                	}
                	jQuery("#apply_erp_itm_code").show();
					jQuery("#div_id_paging").show();
            	}
                jQuery("#tbody_itm_search_result").html(prdListHtml);
                jQuery("#div_erp_itm_search_result").show();
            }
            
            // 브랜드 검색 팝업
            function erpItemBrandSearchPop() {
            	// 입력 값 초기화
            	jQuery("#layer_erp_itm_brand input").val("");
            	// 결과 표시 영역 숨기기
            	jQuery("#layer_erp_itm_brand #div_erp_itm_brand_search_result").hide();
            	// 입력 버튼 숨기기
            	jQuery("#apply_erp_itm_brand").hide();
            	GoodsLayerPopupUtil.open(jQuery('#layer_erp_itm_brand'));
            }

            // 상품 브랜드 검색 결과 화면 표시
            function setErpItmBrandSearchResult(result) {
            	var brandList = result.data.brandList;
            	var brandListHtml = "";
            	if(brandList == null || brandList.length == 0) {
            		brandListHtml += "<tr>";
            		brandListHtml += "<td colspan='2'>데이터가 없습니다.</td>";
            		brandListHtml += "</tr>";
            		jQuery("#apply_erp_itm_brand").hide();
            	} else {
            		for(var i=0; i<brandList.length; i++) {
                		var brand = brandList[i];
                		brandListHtml += "<tr>";
                		brandListHtml += "	<td>";
                		brandListHtml += "		<label for='radio_erp_itm_brand_srch_brandCode_" + brand.brandCode + "' class='radio'>";
                		brandListHtml += "			<span class='ico_comm'>";
                		brandListHtml += "				<input type='radio' name='brandCode' id='radio_erp_itm_brand_srch_brandCode_" + brand.brandCode + "' value='" + brand.brandCode + "' />";
                		brandListHtml += "				<input type='hidden' name='brandName' value='" + brand.brandName + "' />";
                		brandListHtml += "			</span>";
                		brandListHtml += "		</label>";
                		brandListHtml += " 	</td>";
                		brandListHtml += " 	<td>" + brand.brandName + "</td>";
                		brandListHtml += "</tr>";
            		}
            		jQuery("#apply_erp_itm_brand").show();
            	}
            	jQuery("#tbody_itm_brand_search_result").html(brandListHtml);
            	jQuery("#div_erp_itm_brand_search_result").show();
            }
            // 다비젼 상품 검색 팝업 (다중옵션)
            function searchErpItmCode(obj, e) {
             	Dmall.EventUtil.stopAnchorAction(e);
            	var target = $(obj).siblings("input[name=itemErpItmCode]");
            	erpItemSearchPop(target);
            }

            function numberWithCommas(x) {
                return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }

            // 단품 수량 변경 이력 조회
            function createItemQttHist(goodsNo, itemNo) {
                if ( !goodsNo || !itemNo) {
                    return;
                }
                $('tr.qtt_hist', '#tbody_qtt_hist_row').remove();
                
                var url = '/admin/goods/item-quantity-history',
                    param = {'goodsNo' : goodsNo, 'itemNo' : itemNo};
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    // //
                    if (result == null || result.success != true) {                        
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        $('#tr_no_qtt_hist').remove();
                        if (idx == 0) {
                            $('[data-bind=qtt_hist]', '#tbody_qtt_hist_head').DataBinder(obj);
                        }
                        var $tmpTr = $("#tr_qtt_hist_template").hide().clone().show().removeAttr("id").addClass("qtt_hist").data("data", obj);                    
                        $('[data-bind=qtt_hist]', $tmpTr).DataBinder(obj);
                        $("#tbody_qtt_hist_row").append($tmpTr);
                    });
                    if ($('tr.qtt_hist', '#tbody_qtt_hist_row').length < 1) {
                        $('#tbody_qtt_hist_row').append('<tr id="tr_no_qtt_hist"><td colspan="3">데이터가 없습니다.</td></tr>');
                    }
                });
            }
            
            // 단품 판매 가격 변경 이력 조회
            function createItemPriceHist(goodsNo, itemNo) {
                if ( !goodsNo || !itemNo) {
                    return;
                }
                $('tr.price_hist', '#tbody_price_hist_row').remove();
                
                var url = '/admin/goods/item-price-history',
                    param = {'goodsNo' : goodsNo, 'itemNo' : itemNo};
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    // //
                    if (result == null || result.success != true) {                        
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        $('#tr_no_price_hist').remove();
                        if (idx == 0) {
                            $('[data-bind=price_hist]', '#tbody_price_hist_head').DataBinder(obj);
                        }
                        var $tmpTr = $("#tr_price_hist_template").hide().clone().show().removeAttr("id").addClass("price_hist").data("data", obj);                    
                        $('[data-bind=price_hist]', $tmpTr).DataBinder(obj);
                        $("#tbody_price_hist_row").append($tmpTr);
                    });
                    if ($('tr.price_hist', '#tbody_price_hist_row').length < 1) {
                        $('#tbody_price_hist_row').append('<tr id="tr_no_price_hist"><td colspan="3">데이터가 없습니다.</td></tr>');
                    }
                });
            }
                            
                
            function getRelateCategoryOptionValue(ctgLvl, $sel, upCtgNo, selectedValue) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list'
                  , param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl};
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        if (selectedValue && selectedValue === obj.ctgNo) {
                            $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '" selected>' + obj.ctgNm + '</option>');
                            $('label[for='+ $sel.attr('id') +']', $sel.parent()).html(obj.ctgNm);                            
                        } else {
                            $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');   
                        }
                    });
                    
                    if (ctgLvl === '1' && null != $('#sel_relate_ctg_2').data('relateGoodsApplyCtgNo')) {
                        getRelateCategoryOptionValue('2', jQuery('#sel_relate_ctg_2'), $('#sel_relate_ctg_1').data('relateGoodsApplyCtgNo'), $('#sel_relate_ctg_2').data('relateGoodsApplyCtgNo'));
                    } 
                    if (ctgLvl === '2' && null != $('#sel_relate_ctg_3').data('relateGoodsApplyCtgNo')) {
                        getRelateCategoryOptionValue('3', jQuery('#sel_relate_ctg_3'), $('#sel_relate_ctg_2').data('relateGoodsApplyCtgNo'), $('#sel_relate_ctg_3').data('relateGoodsApplyCtgNo'));
                    } 
                    if (ctgLvl === '3' && null != $('#sel_relate_ctg_4').data('relateGoodsApplyCtgNo')) {
                        getRelateCategoryOptionValue('4', jQuery('#sel_relate_ctg_4'), $('#sel_relate_ctg_3').data('relateGoodsApplyCtgNo'), $('#sel_relate_ctg_4').data('relateGoodsApplyCtgNo'));
                    } 
                });
            }
            
            // 관련 상품 설정 방법 변경
            function fn_changeRelateGoodsApplyType() {
                var type =  $('#tbody_relate_goods').data('sel');
                $('label[for=rdo_relateGoodsApplyTypeCd_'+ type +']', '#tbody_relate_goods').trigger('click');
                switch (type) {
                    case '1' :
                        getRelateCategoryOptionValue('1', jQuery('#sel_relate_ctg_1'), '', $('#sel_relate_ctg_1').data('relateGoodsApplyCtgNo'));
                        Dmall.LayerPopupUtil.open(jQuery('#layer_relate_goods_condition'));
                        break;
                    case '2' :
                        Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
                        // 상품 검색 콜백함수 설정
                        GoodsSelectPopup._init( fn_callback_pop_apply_goods );
                        break;
                    default:
                        break;
                } 
            }
            
            function fn_set_relate_goods_condition() {
                var   selectCtg_1 = $("#sel_relate_ctg_1").val()
                    , selectCtg_2 = $("#sel_relate_ctg_2").val()
                    , selectCtg_3 = $("#sel_relate_ctg_3").val()
                    , selectCtg_4 = $("#sel_relate_ctg_4").val()
                    ;
                var data = {
                    'relectsSelCtg1' : selectCtg_1,
                    'relectsSelCtg2' : selectCtg_2,
                    'relectsSelCtg3' : selectCtg_3,
                    'relectsSelCtg4' : selectCtg_4,
                    'relectsSelCtgText1' : $("#sel_relate_ctg_1 option:selected").text(),
                    'relectsSelCtgText2' : $("#sel_relate_ctg_2 option:selected").text(),
                    'relectsSelCtgText3' : $("#sel_relate_ctg_3 option:selected").text(),
                    'relectsSelCtgText4' : $("#sel_relate_ctg_4 option:selected").text(),
                    'relateGoodsApplyCtg' : (selectCtg_4) ? selectCtg_4 :  (selectCtg_3) ? selectCtg_3 : (selectCtg_2) ? selectCtg_2 : (selectCtg_1) ? selectCtg_1 : null,
                    'relateGoodsSalePriceStart' : $('#txt_relate_goods_price_start').val().trim().replaceAll(',', ''),
                    'relateGoodsSalePriceEnd' : $('#txt_relate_goods_price_end').val().trim().replaceAll(',', ''),
                    'relateGoodsSaleStatusCd' : $('input:radio[name=relateGoodsSaleStatusCd]:checked',  "#div_relate_goods_condition").val(),
                    'relateGoodsDispStatusCd' : $('input:radio[name=relateGoodsDispStatusCd]:checked',  "#div_relate_goods_condition").val(),
                    'relateGoodsAutoExpsSortCd' : $('input:radio[name=relateGoodsAutoExpsSortCd]:checked',  "#div_relate_goods_sort").val(),
                    'registFlag' : 'I', 
                }; 

                setRelateGoodsCondition(data);
            }
            
            
            function setRelateGoodsCondition(data) {
                
                var html = '[선택된 조건] ';
                if (data) {
                    

                    if ('relateGoodsApplyCtg' in data && data['relateGoodsApplyCtg']) {
                       var relateGoodsApplyCtgNoText1 = ('relectsSelCtg1' in data && data['relectsSelCtg1'] && data['relectsSelCtgText1']) ? data['relectsSelCtgText1'] : ('relateGoodsApplyCtgNm1' in data && data['relateGoodsApplyCtgNm1']) ? data['relateGoodsApplyCtgNm1'] : ''
                         , relateGoodsApplyCtgNoText2 = ('relectsSelCtg2' in data && data['relectsSelCtg2'] && data['relectsSelCtgText2']) ? data['relectsSelCtgText2'] : ('relateGoodsApplyCtgNm2' in data && data['relateGoodsApplyCtgNm2']) ? data['relateGoodsApplyCtgNm2'] : ''
                         , relateGoodsApplyCtgNoText3 = ('relectsSelCtg3' in data && data['relectsSelCtg3'] && data['relectsSelCtgText3']) ? data['relectsSelCtgText3'] : ('relateGoodsApplyCtgNm3' in data && data['relateGoodsApplyCtgNm3']) ? data['relateGoodsApplyCtgNm3'] : ''
                         , relateGoodsApplyCtgNoText4 = ('relectsSelCtg4' in data && data['relectsSelCtg4'] && data['relectsSelCtgText4']) ? data['relectsSelCtgText4'] : ('relateGoodsApplyCtgNm4' in data && data['relateGoodsApplyCtgNm4']) ? data['relateGoodsApplyCtgNm4'] : ''
                        ;
                         
                        /*
                        var relateGoodsApplyCtgNoText1 = ('relectsSelCtg1' in data && data['relectsSelCtg1']) ? data['relectsSelCtg1'] : (data['relectsSelCtgText1']) ? data['relectsSelCtgText1'] : ('relateGoodsApplyCtgNm1' in data && data['relateGoodsApplyCtgNm1']) ? data['relateGoodsApplyCtgNm1'] : ''
                          , relateGoodsApplyCtgNoText2 = ('relectsSelCtg2' in data && data['relectsSelCtg2']) ? data['relectsSelCtg2'] : (data['relectsSelCtgText2']) ? data['relectsSelCtgText2'] : ('relateGoodsApplyCtgNm2' in data && data['relateGoodsApplyCtgNm2']) ? data['relateGoodsApplyCtgNm2'] : ''
                          , relateGoodsApplyCtgNoText3 = ('relectsSelCtg3' in data && data['relectsSelCtg3']) ? data['relectsSelCtg3'] : (data['relectsSelCtgText3']) ? data['relectsSelCtgText3'] : ('relateGoodsApplyCtgNm3' in data && data['relateGoodsApplyCtgNm3']) ? data['relateGoodsApplyCtgNm3'] : ''
                          , relateGoodsApplyCtgNoText4 = ('relectsSelCtg4' in data && data['relectsSelCtg4']) ? data['relectsSelCtg4'] : (data['relectsSelCtgText4']) ? data['relectsSelCtgText4'] : ('relateGoodsApplyCtgNm4' in data && data['relateGoodsApplyCtgNm4']) ? data['relateGoodsApplyCtgNm4'] : ''
                          ;
                        */
                        
                     // html += '[카테고리정보] '
                        html += '[';
                        if (relateGoodsApplyCtgNoText1) {                            
                            html += relateGoodsApplyCtgNoText1;
                        }
                        if (relateGoodsApplyCtgNoText2) {                            
                            html += ' > ' + relateGoodsApplyCtgNoText2;
                        }
                        if (relateGoodsApplyCtgNoText3) {                            
                            html += ' > ' + relateGoodsApplyCtgNoText3;
                        }
                        if (relateGoodsApplyCtgNoText4) {                            
                            html += ' > ' + relateGoodsApplyCtgNoText4;
                        }
                        html += ']';
                    }
                    if ( ('relateGoodsSalePriceStart' in data && data['relateGoodsSalePriceStart']) 
                            || ('relateGoodsSalePriceEnd' in data && data['relateGoodsSalePriceEnd'])) {
                        // html += '[가격대정보] '
                        html += '[';
                        if ('relateGoodsSalePriceStart' in data && data['relateGoodsSalePriceStart']) {
                            html += data['relateGoodsSalePriceStart'].getCommaNumber();
                        }
                        if ('relateGoodsSalePriceEnd' in data && data['relateGoodsSalePriceEnd'] && data['relateGoodsSalePriceEnd']) {
                            html += ' ~ ' + data['relateGoodsSalePriceEnd'].getCommaNumber();
                        }
                        html += ']';
                    }
                    if ('relateGoodsSaleStatusCd' in data && data['relateGoodsSaleStatusCd'])  {
                        // html += '[판매상태] '
                        html += '[';
                        switch (data['relateGoodsSaleStatusCd']) {
                            case '0':
                                html += ' 전체 ';
                                break;
                            case '1':
                                html += ' 판매중 ';
                                break;
                            case '2':
                                html += ' 품절 ';
                                break;
                            case '4':
                                html += ' 판매중지 ';
                                break;
                            default :
                                break;
                        }
                        html += ']';
                    }
                    if ('relateGoodsDispStatusCd' in data && data['relateGoodsDispStatusCd'])  {
                        // html += '[전시상태] '
                        html += '[';
                        switch (data['relateGoodsDispStatusCd']) {
                            case '1':
                                html += ' 전체 ';
                                break;
                            case '2':
                                html += ' 노출 ';
                                break;
                            case '3':
                                html += ' 미노출 ';
                                break;
                            default :
                                break;
                        }
                        html += ']';
                    }
                    if ('relateGoodsAutoExpsSortCd' in data && data['relateGoodsAutoExpsSortCd'])  {
                        // html += '[상품정렬] '
                        html += '[';
                        switch (data['relateGoodsAutoExpsSortCd']) {
                            case '01':
                                html += ' 최근 등록순(신상품순서) ';
                                break;
                            case '02':
                                html += ' 판매인기순(구매금액) ';
                                break;
                            case '03':
                                html += ' 판매인기순(구매갯수) ';
                                break;
                            case '04':
                                html += ' 상품평 많은순 ';
                                break;
                            case '05':
                                html += ' 장바구니 담기 많은 순 ';
                                break;
                            case '06':
                                html += ' 위시리스트담기 많은순 ';
                                break;
                            case '07':
                                html += ' 상품조회 많은순 ';
                                break;
                            default :
                                break;
                        }
                        html += ']';
                    }
                }

                $('#div_display_relate_goods_condition').data('conditionData', data).html(html);
                
            }
                
            function fn_set_radio_element() {
                var $div = $('#div_delivery_info') 
                  , value = $('input:radio[data-bind=dlvrSetCd]:checked', $div).val()
                  , $txt_3 = $("#txt_goods_each_dlvrc").prop("disabled",true).val('')
                  , $txt_4_1 = $("#txt_pack_max_unit").prop("disabled",true).val('')
                  , $txt_4_2 = $("#txt_pack_unit_dlvrc").prop("disabled",true).val('')
                  , $txt_6 = $("#txt_free_dlvr_min_amt").prop("disabled",true).val('')
                  , $txt_6_1 = $("#txt_goods_each_cndtadd_dlvrc").prop("disabled",true).val('')
                ;
                switch (value) {
                    case "3":
                        $txt_3.prop("disabled",false).val($txt_3.data("commavalue"));
                        break;
                    case "4":
                        $txt_4_1.prop("disabled",false).val($txt_4_1.data("commavalue"));
                        $txt_4_2.prop("disabled",false).val($txt_4_2.data("commavalue"));
                        break;
                    case "6":
                        $txt_6.prop("disabled",false).val($txt_6.data("commavalue"));
                        $txt_6_1.prop("disabled",false).val($txt_6_1.data("commavalue"));
                        break;
                    default:
                        break;
                }
            }
            
            function fn_set_radio_add_option_element() {
                var $body = $('#tbody_add_option') 
                  , value = $('input:radio[data-bind=addOptUseYn]:checked', '#tbody_add_option_set').val()
                ;
                switch (value) {
                    case "Y":
                        $('button, select, input', $body).prop("disabled", false);
                        break;                     
                    default:
                        $('button, select, input', $body).prop("disabled", true);
                        break;
                }
            }              

            function checkValidation(){
                var imgDataExist=true;
                var dlgtImgChkLen=0;
                //상품 이미지 체크
                $("tr.goods_image_set:visible", "#tbody_goods_image_set").each(function() {
                    var goodsImageDtlList = []
                        , $tr = $(this)
                        , $radio = $("input:radio", $(this))
                        , prevData = $tr.data('prev_data');

                    if($radio.is(':checked')){
                        $("img", $tr.find('td')).each(function(idx) {
                            var imgData = $(this).data("img_data");
                            if (!imgData) {
                                imgDataExist=false;
                            }else{
                                imgDataExist=true;
                                return false;
                            }
                        });
                        dlgtImgChkLen++;
                    }
                });
                if(!imgDataExist || dlgtImgChkLen==0){
                    Dmall.LayerUtil.alert('대표 상품 이미지를 설정하세요.');
                    return false;
                }
                /*
                if (!$('sel_goods_notify').val()) {
                    Dmall.LayerUtil.alert('고시 종목을 입력해주세요.');
                    return false;
                }
                */
                
                // 배송비 설정에서 기본 배송비를 설정한 경우에는 배송방법(택배배송 또는 직접수령)을 하나 이상 반드시 선택
                var dlvrSetCd = $('input:radio[data-bind=dlvrSetCd]:checked', '#div_delivery_info').val();
                /*if('1' === dlvrSetCd) {
                    if ( !$('#chk_couri_dlvr_apply_yn').prop('checked') && !$('#chk_direct_recpt_apply_yn').prop('checked')) {
                        Dmall.LayerUtil.alert('배송비 설정에서 기본 배송비를 설정한 경우에는 배송방법(택배배송 또는 직접수령)을 선택해 주세요.');
                        return false
                    }
                } else*/
                if ('1' === dlvrSetCd || '2' === dlvrSetCd || '3' === dlvrSetCd || '4' === dlvrSetCd || '6' === dlvrSetCd) {
                    if ( !$('#chk_couri_dlvr_apply_yn').prop('checked') && !$('#chk_direct_recpt_apply_yn').prop('checked')) {
                        Dmall.LayerUtil.alert('요청상품 배송방법(택배배송 또는 직접수령)을 선택해 주세요.');
                        return false
                    } 
                }

                if('3' === dlvrSetCd) {
                    if ( $('#txt_goods_each_dlvrc').val()=='' || $('#txt_goods_each_dlvrc').val()=='0') {
                    	Dmall.LayerUtil.alert('상품별 배송비 조건을 입력하세요.');
                        return false
                    }
                }
                
                if('6' === dlvrSetCd) {
                    if ( $('#txt_goods_each_cndtadd_dlvrc').val()=='' || $('#txt_goods_each_cndtadd_dlvrc').val()=='0' ||  $('#txt_free_dlvr_min_amt').val()=='') {
                        Dmall.LayerUtil.alert('상품별 배송비 조건을 입력하세요.');
                        return false
                    }
                }
                
                if('4' === dlvrSetCd) {
                    if ( $('#txt_pack_max_unit').val()=='' ||  $('#txt_pack_unit_dlvrc').val()=='' || $('#txt_pack_unit_dlvrc').val()=='0') {
                        Dmall.LayerUtil.alert('상품별 배송비 조건을 입력하세요.');
                        return false
                    }
                }

                // 상품 카테고리 설정 확인 (2016.09.26)
                if ( $("#tbody_selected_ctg").find("tr.selectedCtg:visible").length < 1 ) {
                    Dmall.LayerUtil.alert('카테고리 선택은 필수입니다.');
                    return false
                }
                /*if( $("#txt_sale_start_dt").val().length > 0 && !Dmall.validation.date($("#txt_sale_start_dt").val())){
                    Dmall.LayerUtil.alert('상품 판매기간 시작일을 정확하게 입력해주세요.');
                    return false;
                }*/
                /*if( $("#txt_sale_end_dt").val().length > 0 && !Dmall.validation.date($("#txt_sale_end_dt").val())){
                    Dmall.LayerUtil.alert('상품 판매기간 종료일을 정확하게 입력해주세요.');
                    return false;
                }*/
                // 다비젼 상품 코드 필수 확인
                // 임시로 필수확인 제거

                if($("#hd_multiOptYn").val() == "N") {
                	// 단일 옵션인 경우
                	// 다비젼 상품코드가 보여지는 경우
                	if($("#tr_erp_itm_code").css("display") != "none"
                	&& ( $("#txt_erp_itm_code").data("value")==undefined || $("#txt_erp_itm_code").data("value") == "" )
                	&& $("#txt_erp_itm_code").val() == "") {
                		Dmall.LayerUtil.alert('다비젼 상품코드를 입력해 주세요.');
                        return false;
                	}
                } else {
                	// 다중 옵션인 경우
                	// 다비젼 상품코드가 보여지는 경우
                	if($("#th_multiOptErpItmCode").css("display") != "none") {
	                	var isErr = false;
						$("tr.goods_item", "#tbody_goods_item").each(function() {
							var data = $(this).data("goods_item");
							if(data["registFlag"]!='D'){
                                if(data["erpItmCode"] == null || data["erpItmCode"] == "") {
                                    Dmall.LayerUtil.alert('다비젼 상품코드를 입력해 주세요.');
                                    isErr = true;
                                    return false;
                                }
							}else{
							    return true;
							}
						});
	                	if(isErr) return false;
                	}
                }

                
                var $tr = $("tr.add_option", "#tbody_add_option")
                    , isValid = true;
                $("span.intxt", $tr.find('td').eq(1)).each(function(idx) {
                    var $input0 = $("input:text", $tr.find('td').eq(0)).eq(idx)
                    , $input1 = $("input:text", $tr.find('td').eq(1)).eq(idx)
                    , $input2 = $("input:text", $tr.find('td').eq(2)).eq(idx);
              
                    if ( $('rdo_add_opt_use_yn_y').is(":checked") &&
                          (!$input0.val() || !$input1.val() || !$input2.val())) {
                        Dmall.LayerUtil.alert('추가 옵션 정보를 확인해 주세요.');
                        isValid = false;
                        return false;
                    }
                });
                if (isValid === false) {
                    return false;
                }
                return true;
            }
                
            // 상품 상세 정보 취득
            function fn_getGoodsInfo(goodsNo) {                
                getGoodsInfo(goodsNo);
            }
            
            // 상품 상세 정보 취득
            function getGoodsInfo(goodsNo) {
                if (null == goodsNo || goodsNo.length < 1) {
                    return;
                }
                $('#hd_goodsNo').val(goodsNo);
                var url = '/admin/goods/goods-info',
                param = {'goodsNo' : goodsNo};
            
                // //
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    // //
                    if (result == null || result.success != true) {
                        return;
                    }
                    
                    var data = result.data;
                    // 취득결과 셋팅
                    //
                    
                    /*** 0. 상품 기본 설정 로딩 데이터 바인딩 ***/
                    loadBasicInfo(data);
                    
                    /*** 1. 상품 카테고리 설정 로딩 데이터 바인딩 ***/
                    loadGoodsCtgInfo(data);
                    
                    /*** 2. 상품 배송 설정 로딩 데이터 바인딩 ***/
                    loadDeliveryInfo(data);
                    
                    /*** 3. 옵션, 단품 설정 로딩 데이터 바인딩 ***/
                    loadGoodsItemInfo(data);
                    
                    /*** 4. 추가 옵션 설정 로딩 데이터 바인딩 ***/
                    loadGoodsAddOption(data);
                    
                    /*** 5. 관련 상품 설정 로딩 데이터 바인딩 ***/
                    loadRelateGoods(data);
                    
                    /*** 6. 고시 정보 로딩 데이터 바인딩 ***/
                    //loadGoodsNotifyList(data);
                    
                    /*** 7. 상품 이미지 설정 로딩 데이터 바인딩 ***/
                    loadGoodsImageSet(data);
                    
                    
                    // 카테고리 정보 로드
                    getCategoryInfo('1', jQuery('#ul_ctg_1'), '', $('#ul_ctg_1').data('ctgNo'));
                    
                    // 판매자에 따른 화면 표시 변경

                });
            }
            
            function bindDispImgDataByType(type, data) {
                var key1 = 'dispImgPathType' + type
                  , key2 = 'dispImgNmType' + type
                  , key3 = 'dispImgFileSizeType' + type;
                
                if(key1 in data && data[key1] && key2 in data && data[key2]) {
                    var imgPath = data[key1]
                      , imgNm = data[key2]
                      , fileSize = data[key3]!=null?data[key3]:0
                      , imgData = {
                            type : type,
                            imgPath : imgPath,
                            imgNm : imgNm,
                            fileSize : fileSize,
                            imgUrl : '${_IMAGE_DOMAIN}/image/preview?id=' +  imgPath + '_' + imgNm,
                            src : '/image/image-view?type=GOODSDTL&id1=' + imgPath + '_' + imgNm.split("_")[0] + '_110x110x01'  ,
                        };
                    

                    // 상품 전시 이미지ROW 이벤트 바인딩 (이미지)
                    $('[data-bind=disp_img_info]', '#tr_disp_img_1').DataBinder(imgData);
                    // 상품 전시 이미지ROW 이벤트 바인딩 (이미지등록, 미리보기)
                    $('[data-bind=disp_img_info]', '#tr_disp_img_2').DataBinder(imgData);
                }
            }
            
            /*** 0. 상품 기본 설정 로딩 데이터 바인딩 ***/
            function loadBasicInfo(data) {
                $('[data-bind="basic_info"]').DataBinder(data);
                /*
                if ('goodsCtgNo1' in data && data['goodsCtgNo1']) {
                    $('#ul_ctg_1').data('ctgNo', data['goodsCtgNo1']);
                }
                */
                var goodsTypeCd= data['goodsTypeCd'];

                $('tr[class^=goods_type_]').hide();
                $('tr.goods_type_'+goodsTypeCd).show();


               
                $('#ul_ctg_1').data('ctgNo', data['goodsCtgNo1']);
                $('#ul_ctg_2').data('ctgNo', data['goodsCtgNo2']);
                $('#ul_ctg_3').data('ctgNo', data['goodsCtgNo3']);
                $('#ul_ctg_4').data('ctgNo', data['goodsCtgNo4']);
                
                bindDispImgDataByType('A', data);
                bindDispImgDataByType('B', data);
                bindDispImgDataByType('C', data);
                bindDispImgDataByType('D', data);
                bindDispImgDataByType('E', data);
                bindDispImgDataByType('F', data);
                bindDispImgDataByType('G', data);
                bindDispImgDataByType('S', data);
                bindDispImgDataByType('M', data);
                bindDispImgDataByType('O', data);
                bindDispImgDataByType('P', data);
                
                $('input:radio[name=goodsSvmnGbCd][value=' + data.goodsSvmnGbCd + ']').trigger('click');
                
                //등록일시,수정일시
                $('#strRegDttm').text(data.strRegDttm);
                $('#strUpdDttm').text(data.strUpdDttm);
                $('#goodsInqCnt').text("조회수 : "+data.goodsInqCnt);
            }
            
            /*** 1. 상품 카테고리 설정 로딩 데이터 바인딩 ***/
            function loadDeliveryInfo(data) {
                $('[data-bind="delivery_info"]').DataBinder(data);
            }
            
            
            // radio 값의 바인딩
            // data-bind-value 에 radio의 name을 설정, data 오브젝트의 해당 name 속성에 설정된 값을 설정함
            function setLabelRadio(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
                // 기존 선택 값 리셋
                var $radio = $('input:radio[name='+ bindValue +']').prop('checked', false);
                $radio.each(function (){
                   $('label[for=' + $(this).attr('id') + ']', $radio.parent()).removeClass('on');
                });                
                // 값 설정
                $('input:radio[name='+ bindValue +'][value=' + value + ']').trigger('click');
                
            }
            
            // checkbox 값의 바인딩 
            // data-bind-value 에 checkbox의 name을 설정, data 오브젝트의 해당 name 속성에 설정된 값을 설정함
            function setLabelCheckbox(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
                
                obj.removeAttr('checked');
                $('label[for=' + obj.attr('id') + ']', obj.parent()).removeClass('on'); 
                
                // 값 설정 ('Y'일 경우 체크)
                if ('Y' === value) {
                    $('label[for=' + obj.attr('id') + ']').trigger('click');
                }
            }
            
            function setIconList(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
                // 값 설정
                $.each(value, function(idx, icon){
                    $('label[for=chk_goods_icon_' + icon["iconNo"] + ']', obj).trigger('click');
                    $('#chk_goods_icon_' + icon["iconNo"]).data("prev_value", "Y");
                    
                });
            }

            function setGunList(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
                // 값 설정
                $.each(value, function(idx, gun){
                    $('label[for=chk_gun_no_' + gun["gunNo"] + ']', obj).trigger('click');
                    $('#chk_gun_no_' + gun["gunNo"]).data("prev_value", "Y");

                });
            }

            function setColorInfo(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue]
                    ,_selIdx;

                $('[id^='+bindName+']').removeAttr('checked');
                $('label[for^=' + bindName+ ']').removeClass('on');

                // 값 설정
                if(value!=undefined && value!=null){
                var _value = value.split(',');
                    $.each(_value, function(idx, value){
                        _selIdx = Number(value);
                        $('label[for='+bindName+'_' + _selIdx + ']', obj).trigger('click');
                        $('#'+bindName+'_' + _selIdx).data("prev_value", "Y");

                    });
                }
            }

            function setRadioInfo(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue]
                    ,_selIdx = Number(value);
                $('label[for='+bindName+'_' + _selIdx + ']', obj).trigger('click');
                $('#'+bindName+'_' + _selIdx).data("prev_value", "Y");
            }


            /*** 0. 로딩 데이터 바인딩 - 끝 ***/
            
            /*** 1.아이콘 - 시작 ***/
            // 아이콘정보 설정
            function createGoodsIcon(list, $td) {
                $('span:visible', $td).remove();
                jQuery.each(list, function(idx, obj) {
                    addGoodsIcon(obj, $td);
                });            
            }
            
            function addGoodsIcon(obj, $td) {
                var $tmpIcon = $("#span_icon_template").clone().show().removeAttr("id").attr("id", "goods_icon_" + obj.iconNo ).data("icon_no", obj.iconNo)
                , $input = $('input', $tmpIcon)
                , $label = $('label', $tmpIcon);
              $input.removeAttr("id").attr("id", "chk_goods_icon_"+ obj.iconNo).attr("name", "goodsIcon").data("icon_no", obj.iconNo).data("prev_value", "N").addClass("goodsIcon");
              $label.removeAttr("id").attr("id", "lb_goods_icon_" + obj.iconNo).removeAttr("for").attr("for", "chk_goods_icon_"+ obj.iconNo)
                   .html('<span class="ico_comm">&nbsp;</span>&nbsp;' + obj.iconPathNm );

              // 아이콘 설정 체크박스 클릭시 이벤트 설정
              $label.off('click').on('click', function(e) {
                  Dmall.EventUtil.stopAnchorAction(e);

                  var $this = jQuery(this),
                      checked = !($input.prop('checked'));
                  $input.prop('checked', checked);
                  $this.toggleClass('on');
              });
           
              $td.append($tmpIcon);
            }
            /*** 1.아이콘 - 끝 ***/

            /*** 1.비전체크 군 - 시작 ***/
            // 비전체크 군 설정
            function createGoodsGun(list, type) {
            	var $td = $("#gun_list_"+type);
            	$td.empty().append('<span id="span_gun_template_'+type+'" style="display:none"><input type="checkbox" name="goodsGunTemp" id="gunCheck'+type+'_1" class="blind" /><label for="gunCheck'+type+'_1" class="chack mr20"><span class="ico_comm">&nbsp;</span></label></span>');
                jQuery.each(list, function(idx, obj) {
                    addGoodsGun(obj, $td);
                });
            }

            function addGoodsGun(obj, $td) {
                var $tmpIcon = $("#span_gun_template_"+obj.goodsTypeCd).clone().show().removeAttr("id").attr("id", "chk_gunNo_" + obj.gunNo ).data("gunNo", obj.gunNo)
                , $input = $('input', $tmpIcon)
                , $label = $('label', $tmpIcon);

              $input.removeAttr("id").attr("id", "chk_gun_no_"+ obj.gunNo).attr("name", "gunNo").attr("value", obj.gunNo).data("prev_value", "N").addClass("gunNo");
              $label.removeAttr("id").attr("id", "lb_gunNo_" + obj.gunNo).removeAttr("for").attr("for", "chk_gun_no_"+ obj.gunNo).html('<span class="ico_comm">&nbsp;</span>&nbsp;' + obj.gunNm );

              // 비전체크 군 설정 체크박스 클릭시 이벤트 설정
              $label.off('click').on('click', function(e) {
                  Dmall.EventUtil.stopAnchorAction(e);

                  var $this = jQuery(this),
                      checked = !($input.prop('checked'));
                  $input.prop('checked', checked);
                  $this.toggleClass('on');
              });

              $td.append($tmpIcon);
            }
            /*** 1.비전체크 군 - 끝 ***/


            /*** 2. 카테고리 관련 - 시작 ***/
            
            // 로딩된 상품에 설정된 카테고리 정보 설정 - [상품로딩.2]
            function loadGoodsCtgInfo(data) {
                var ctgList = data.goodsCtgList;

                // 기존 선택된 카테고리 삭제
                $('tr.selectedCtg', $('#tbody_selected_ctg ')).remove();                
                $.each(ctgList, function(idx, data){
                    if (data) {
                        addGoodsCtgRow(data);
                    }
                });
                if ( $("#tbody_selected_ctg").find("tr:visible").length < 1 ) {
                    $("#tr_no_selected_ctg_template").show();
                }
            }
            // 상품 저장시 카테고리 정보 취득 - [상품저장.1]
            function getGoodsCategoryValue($target) {
                var returnData = [];
                $target.each(function(idx) {
                    returnData.push($(this).data('value'));
                });
                return returnData;
            }            
            
            // 카테고리 선택 버튼 클릭 이벤트
            function fn_registCtg() {
                var ctgNo = $("li.on:last", $("#div_ctg_box")).data("ctgNo")
                    , ctgNm1 = $("li.on:first", $("#ul_ctg_1")).data("ctgNm")
                    , ctgNm2 = $("li.on:first", $("#ul_ctg_2")).data("ctgNm")
                    , ctgNm3 = $("li.on:first", $("#ul_ctg_3")).data("ctgNm")
                    , ctgNm4 = $("li.on:first", $("#ul_ctg_4")).data("ctgNm")
                    , ctgCmsRate1 = $("li.on:first", $("#ul_ctg_1")).data("ctgCmsRate")
                    , ctgCmsRate2 = $("li.on:first", $("#ul_ctg_2")).data("ctgCmsRate")
                    , ctgCmsRate3 = $("li.on:first", $("#ul_ctg_3")).data("ctgCmsRate")
                    , ctgCmsRate4 = $("li.on:first", $("#ul_ctg_4")).data("ctgCmsRate");
                
                if (!ctgNo || !ctgNm1) {
                    return false;
                }
                
                var data = {
                    'goodsNo': $('#hd_goodsNo').val(),
                    'dlgtCtgYn': 'N',
                    'expsYn': 'Y',
                    'expsPriorRank': $('tr.selectedCtg:visible', $('#tbody_selected_ctg')).length,
                    'ctgDisplayNm' : '',
                    'ctgNo' : ctgNo,
                    'ctgNm1' : ctgNm1,
                    'ctgNm2' : ctgNm2,
                    'ctgNm3' : ctgNm3,
                    'ctgNm4' : ctgNm4,
                    'ctgCmsRate1' : ctgCmsRate1,
                    'ctgCmsRate2' : ctgCmsRate2,
                    'ctgCmsRate3' : ctgCmsRate3,
                    'ctgCmsRate4' : ctgCmsRate4,
                    'registFlag' : 'I', 
                };                
                addGoodsCtgRow(data)
            }
            
            // 선택된 카테고리 ROW 추가
            function addGoodsCtgRow(data) {
                var $tmpCtgTr = $("#tr_selected_ctg_template").clone().show().removeAttr("id")
                , $td1 = $("td:eq(0)", $tmpCtgTr)
                , $td2 = $("td:eq(1)", $tmpCtgTr)
                /*, $td3 = $("td:eq(2)", $tmpCtgTr)*/
                , isRegisted = false;
                var trId = "tr_ctg_" + data.ctgNo;
                
                // 기존 등록 여부 체크
                $('tr.selectedCtg:visible', $('#tbody_selected_ctg')).each(function() {
                    if ( trId === $(this).attr('id')) {
                        isRegisted = true;
                        Dmall.LayerUtil.alert('이미 등록된 카테고리 입니다.');
                        return false;
                    }
                });
                
                // 새로운 카테고리 선택일 경우 ROW 생성(class : selectedCtg)
                if (!isRegisted) {
                    $tmpCtgTr.attr("id", trId).addClass("selectedCtg").data("ctgNo", data['ctgNo']).data("value", data);
                    var $input = $("input", $td1).removeAttr("id").attr("id", "rdo_" + data.ctgNo).data("ctgNo", data['ctgNo'])
                       ,$label = $("label", $td1).removeAttr("for").attr("for", "rdo_" + data.ctgNo).data("ctgNo", data['ctgNo']);
                    
                    // 라벨클릭 이벤트
                    $label.off('click').on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var $this = $(this), ctgNo = $this.data("ctgNo");
                        $input.parents('label').siblings().find('input').removeProp('checked');
                        $input.prop('checked', true).trigger('change');                        
                        if ($input.prop('checked')) {
                            $this.addClass('on').parents('tr').siblings().find('label').removeClass('on');
                            
                            $('tr.selectedCtg', $('#tbody_selected_ctg ')).each(function() {
                                var data = $(this).data("value");
                                if (data) {
                                    if (ctgNo === $(this).data("ctgNo")) {
                                        data['dlgtCtgYn'] = "Y";
                                    } else {
                                        data['dlgtCtgYn'] = "N";
                                    }
                                }
                            });
                        }
                    });                    
                    
                    // 화면에서 등록된 값이 아닌 DB에서 읽어온 정보의 경우, 카테고리명 정보를 취득
                    if ( ! data['ctgNm1']  && data['ctgDisplayNm'] ) {
                        var ctgArr = data['ctgDisplayNm'].split('>');
                        switch (ctgArr.length) {
                            case 4:
                                data['ctgNm4'] =  ctgArr[3].trim();
                            case 3:
                                data['ctgNm3'] =  ctgArr[2].trim();
                            case 2:
                                data['ctgNm2'] =  ctgArr[1].trim();
                            default:
                                data['ctgNm1'] =  ctgArr[0].trim();
                                break;
                        }
                    }                    
                    var html = data['ctgNm1'] + "  ";
                        html = null == data['ctgNm2'] ? html : html + '<span class="ico_comm arro">▶</span>  ' + data['ctgNm2'] + "  ";
                        html = null == data['ctgNm3'] ? html : html + '<span class="ico_comm arro">▶</span>  ' + data['ctgNm3'] + "  ";
                        html = null == data['ctgNm4'] ? html : html + '<span class="ico_comm arro">▶</span>  ' + data['ctgNm4'] + "  ";
                    
                    $td2.html(html);

                    // 화면에서 등록된 값이 아닌 DB에서 읽어온 정보의 경우, 카테고리 수수료율 정보를 취득
                    if ( ! data['ctgCmsRate1']  && data['ctgCmsRate'] ) {
                        data['ctgCmsRate1'] =  data['ctgCmsRate'].trim();
                    }
                    /*var html= data['ctgCmsRate1'];
                    html = null == data['ctgCmsRate2'] ? html : data['ctgCmsRate2'];
                    html = null == data['ctgCmsRate3'] ? html : data['ctgCmsRate3'];
                    html = null == data['ctgCmsRate4'] ? html : data['ctgCmsRate4'];*/
                    /*$td3.html(html+"%");*/

                    // 삭제 버튼 생성
                    var btn = document.createElement('button');

                    // 삭제 버튼 이벤트 설정 
                    $(btn).data("ctgNo", data['ctgNo']).addClass("icon_del").html("삭제").off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        
                        var $input = $('#rdo_' + data.ctgNo)
                          , $tr =  $("#tr_ctg_" + $(this).data("ctgNo"));                        
                          
                        // 신규 등록된 카테고리의 경우 삭제
                        if ('I' === $tr.data('value')['registFlag']) {
                            $tr.remove();
                        // 기존 등록된 카테고리의 경우 화면에서 숨기고 상품 저장시 삭제 처리
                        } else {
                            $tr.hide().data('value')['registFlag'] = 'D';
                        }
                        
                        // 삭제후 선택된 카테고리가 없을 경우 메세지 출력
                        if ( $("#tbody_selected_ctg").find("tr:visible").length < 1 ) {
                            $("#tr_no_selected_ctg_template").show();
                        } else {
                            if ($input.prop('checked')) {
                                $('label:visible', $("#tbody_selected_ctg")).first().trigger('click');
                            }
                        }
                    });
                    $td2.append(btn);
                    
                    $("#tr_no_selected_ctg_template").hide();
                    $("#tbody_selected_ctg").append($tmpCtgTr);
                    
                    if('Y' === data['dlgtCtgYn']) {
                        $label.trigger('click');
                    }                     
                    // 대표 카테고리로 선택된 카테고리가 없을 경우 현재 등록된 카테고리를 선택
                    if( $('input:visible', '#tbody_selected_ctg').length == 1) {
                        $label.trigger('click');
                        //카테고리 수수료 율 적용 공급가 setting...
                        if ( data['ctgCmsRate1']  && !data['ctgCmsRate'] ) {
                            jQuery('#txt_sale_price').trigger('change');
                        }
                    }
                }
            }
            // 상위 카테고리 설정에 따른 하위 카테고리 옵션값 변경
            function changeCategoryInfo(level, $target, ctgNo) {
                var $ul = $('#ul_ctg_' + level);
                $ul.find('li').remove();                
                if ( level && level == '2' && $target.attr('id') == 'ul_ctg_1') {
                    getCategoryInfo(level, $ul, ctgNo);
                    $ul = $('#ul_ctg_3 > li, #ul_ctg_4 > li').remove();
                } else if ( level && level == '3' && $target.attr('id') == 'ul_ctg_2') {
                    getCategoryInfo(level, $ul, ctgNo);
                    $ul = $('#ul_ctg_4').find('li').remove();
                } else if ( level && level == '4' && $target.attr('id') == 'ul_ctg_3') {
                    getCategoryInfo(level, $ul, ctgNo);
                } else {

                }
            }
            
            
            // 성인 인증 설정 정보 확인
            function fn_checkAdultCertifyConfig() {
                var url = '/admin/setup/personcertify/adultcertify-config-check',
                    param = {};
                // //
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {

                    if (result == null || result.success != true) {
                        return;
                    }
                    if (!result.data.checkExistAdultCertifyYn || result.data.checkExistAdultCertifyYn !== 'N') {
                        Dmall.LayerUtil.confirm('성인 인증 설정을 하시겠습니까?', fn_goAdultCertifyPage);
                    }
                    // 취득결과 셋팅
                });
            }
            
            function fn_goAdultCertifyPage() {
                Dmall.FormUtil.submit('/admin/setup/personcertify/certify-config', {});
            }
            
            // 하위 카테고리 정보 취득
            function getCategoryInfo(ctgLvl, $ul, upCtgNo, selectedValue) {
                

                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl,'goodsContsGbCd':'02'};
                
                // //
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    // //
                    if (result == null || result.success != true) {
                        return;
                    }
                    
                    $ul.html('');
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        var li = document.createElement('li');
                        $(li).data("ctgNo", obj.ctgNo).data("ctgNm", obj.ctgNm).data("ctgCmsRate",obj.ctgCmsRate).html(obj.ctgNm+" ("+obj.ctgCmsRate+"%)");
                        if (selectedValue && selectedValue === obj.ctgNo) {
                            $(li).addClass('on');
                        }

                        $(li).off("click").on('click', function() {
                            var $this = $(this);
                            /*if ( !$this.hasClass("on") ) {*/
                                $this.siblings('li').removeClass("on");
                                changeCategoryInfo(parseInt(ctgLvl)+1, $ul, $this.addClass("on").data("ctgNo"));
                            /*}*/
                        });

                        $ul.append(li);


                    });
                    if (ctgLvl === '1' && null != $('#ul_ctg_2').data('ctgNo')) {
                        getCategoryInfo('2', jQuery('#ul_ctg_2'), $ul.data('ctgNo'), $('#ul_ctg_2').data('ctgNo'));
                    } 
                    if (ctgLvl === '2' && null != $('#ul_ctg_3').data('ctgNo')) {
                        getCategoryInfo('3', jQuery('#ul_ctg_3'), $ul.data('ctgNo'), $('#ul_ctg_3').data('ctgNo'));
                    } 
                    if (ctgLvl === '3' && null != $('#ul_ctg_4').data('ctgNo')) {
                        getCategoryInfo('4', jQuery('#ul_ctg_4'), $ul.data('ctgNo'), $('#ul_ctg_4').data('ctgNo'));
                    }
                });
            }
            /** 2. 카테고리 관련 - 끝 **/


            
            
            function makeOptionData(optValue, optNo, attrValue, attrNo, optData) {

                if (null != optValue) {
                    var optValueArray = null == optData ? [] : optData['optionValueList']
                      , isExist = false;                    
                    $.each(optValueArray, function(idx, obj) {
                        if (attrValue === obj.attrNm) {
                            isExist = true;
                            return false;   
                        }
                    });

                    if (false === isExist) {
                        var data = {
                                'attrNm' : attrValue,
                                'attrNo' : attrNo,
                                'optNo' : optNo,
                                'registFlag' : 'L',
                            };
                        optValueArray.push(data);
                    }
                    
                    if (optData == null) {
                        optData = {
                                'optNm' : optValue,
                                'optNo' : optNo,
                                'optionValueList' : optValueArray,
                                'registFlag' : 'L',
                            };
                    } else {
                        optData['optionValueList'] = optValueArray;
                    }
                }
                return optData;
            }
            
            /*** 다중옵션 관련 - 시작 ***/            
            /*** 3. 옵션, 단품 설정 로딩 데이터 바인딩 ***/
            function loadGoodsItemInfo(data) {
                if ('multiOptYn' in data && 'Y' === data['multiOptYn']) {
                    $('#btn_multi_option').trigger('click');
                    
                    createMainOptionTable(data.goodsOptionList, data.goodsItemList);
                    
                    createOptionInfoTable(data.goodsOptionList);
                    
                    // 기존 .단품정보 삭제
                    $("tr.goods_item", "#tbody_goods_item").remove();
                    $('tr.itemoption', '#tb_goods_option').remove();
                    
                    // 상품 단품정보 바인딩
                    var goodsItemList = data.goodsItemList
                      , optArray = []
                      , optData1 = null
                      , optData2 = null
                      , optData3 = null
                      , optData4 = null;
                    

                    $.each(goodsItemList, function(idx, data) {
                        data['registFlag'] = 'L';
                        

                        optData1 = makeOptionData(data['optValue1'], data['optNo1'], data['attrValue1'], data['attrNo1'], optData1);
                        optData2 = makeOptionData(data['optValue2'], data['optNo2'], data['attrValue2'], data['attrNo2'], optData2);
                        optData3 = makeOptionData(data['optValue3'], data['optNo3'], data['attrValue3'], data['attrNo3'], optData3);
                        optData4 = makeOptionData(data['optValue4'], data['optNo4'], data['attrValue4'], data['attrNo4'], optData4);
                        

                        var $tmpTr = $("#tr_goods_item_template").hide().clone().show().removeAttr("id").addClass("goods_item").data("goods_item", data);                    
                        $('[data-bind="goods_item_info"]', $tmpTr).DataBinder(data);
                        $("#tbody_goods_item").append($tmpTr);
                    });
                    
                    if ($('tr.goods_item:visible', '#tbody_goods_item').length > 0) {
                        $('#tr_no_goods_item').hide();
                    } else {
                        $('#tr_no_goods_item').show();
                    }
                    
                    optArray.push(optData1);
                    
                    if (null != optData2) {
                        optArray.push(optData2);
                    }
                    if (null != optData3) {
                        optArray.push(optData3);
                    }
                    if (null != optData4) {
                        optArray.push(optData4);
                    }
                    
                    $('#div_multi_option').data('opt_data', optArray).data('prev_value', optArray).data("goods_item_info", goodsItemList);
                }
            }
            
            // 최근 등록한 옵션 불러오기
            function loadRecentOption() {
                
                var regSeq = $("#sel_load_option").val()
                  , url = '/admin/goods/recent-option'
                  , param = {'regSeq' : regSeq};
                  
                if (!regSeq) {
                    Dmall.LayerUtil.alert('불러올 옵션 정보를 선택해 주세요.');
                    return;
                }                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 결과 바인딩 호출
                    setRecentOption(result.resultList);
                });
            }
            // 최근 등록한 옵션 정보 설정
            function setRecentOption(data) {
                $('tr.itemoption', '#tb_goods_option').remove();
                
                createOptionInfoTable(data);
                
                var attrValueList1, attrValueList2, attrValueList3, attrValueList4;                
                if (data && data.length > 0) {
                    switch (data.length) {
                        case 4 :
                            attrValueList4 = 'attrValueList' in data[3] ? data[3].attrValueList : null;
                        case 3 :
                            attrValueList3 = 'attrValueList' in data[2] ? data[2].attrValueList : null;
                        case 2 :
                            attrValueList2 = 'attrValueList' in data[1] ? data[1].attrValueList : null;
                        default :
                            attrValueList1 = 'attrValueList' in data[0] ? data[0].attrValueList : null;
                           break;
                    }
                }
                
                var optData = {};
                jQuery.each(attrValueList1, function(idx1, obj1) {
                    optData['optNo1'] = data[0]['optNo'];
                    optData['attrValue1'] = obj1['attrNm'];
                    optData['attrNo1'] = obj1['attrNo'];
                    
                    if (attrValueList2) {
                        jQuery.each(attrValueList2, function(idx2, obj2) {
                            optData['optNo2'] = data[1]['optNo'];
                            optData['attrValue2'] = obj2['attrNm'];
                            optData['attrNo2'] = obj2['attrNo'];
                        
                            if (attrValueList3) {
                                jQuery.each(attrValueList3, function(idx3, obj3) {
                                    optData['optNo3'] = data[2]['optNo'];
                                    optData['attrValue3'] = obj3['attrNm'];
                                    optData['attrNo3'] = obj3['attrNo'];
                                    
                                    if (attrValueList4) {
                                        jQuery.each(attrValueList4, function(idx4, obj4) {
                                            optData['optNo4'] = data[3]['optNo'];
                                            optData['attrValue4'] = obj4['attrNm'];
                                            optData['attrNo4'] = obj4['attrNo'];                                            
                                            optData['registFlag'] = 'L';
                                            addPopItemOption(optData, false);
                                        });
                                    } else {
                                        optData['registFlag'] = 'I';
                                        addPopItemOption(optData, false);
                                    }
                                });
                            } else {
                                optData['registFlag'] = 'I';
                                addPopItemOption(optData, false);
                            }
                        });
                    } else {
                        optData['registFlag'] = 'I';
                        addPopItemOption(optData, false);
                    }
                    
                    $('#tb_goods_option').data('load_option_flag', true);
                });
                
                // 디폴트 표시
                if ($("input:radio[name=standardPriceYn]:visible:checked", $("#tbody_item")).length < 1) {
                    $("label.radio:visible", $("#tbody_item")).eq(0).trigger('click');
                } 
            }
            
            // 상품 판매 정보 취득 - [상품저장.3]
            // 단일 옵션의 경우
            function getGoodsSimpleSaleValue($target, data, allDataFlag) {
                getInputDataValue(data, $("[data-bind-value=customerPrice]", $target), $("[data-bind-value=customerPrice]", $target).val(), allDataFlag);
                getInputDataValue(data, $("[data-bind-value=supplyPrice]", $target), $("[data-bind-value=supplyPrice]", $target).val(), allDataFlag);
                getInputDataValue(data, $("[data-bind-value=salePrice]", $target), $("[data-bind-value=salePrice]", $target).val(), allDataFlag);
                getInputDataValue(data, $("[data-bind-value=sepSupplyPriceYn]", $target), $("[data-bind-value=sepSupplyPriceYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);
                getInputDataValue(data, $("[data-bind-value=stockQtt]", $target), $("[data-bind-value=stockQtt]", $target).val(), allDataFlag);
                getInputDataValue(data, $("[data-bind-value=saleStartDt]", $target), $("[data-bind-value=saleStartDt]", $target).val(), allDataFlag);
                getInputDataValue(data, $("[data-bind-value=saleEndDt]", $target), $("[data-bind-value=saleEndDt]", $target).val(), allDataFlag);
                getInputDataValue(data, $("[data-bind-value=erpItmCode]", $target), $("[data-bind-value=erpItmCode]", $target).val(), allDataFlag);
            }
            
            // 다중 옵션의 경우 - [상품저장.3]
            // 옵션만들기 레이어 팝업에서 설정된 정보를 반환(메인화면에서의 수정은 불가)
            function getGoodsMultiSaleValue($target, goodsData, allDataFlag) {
                // 단품 옵션 정보
                var goodsItemList = [];
                // 단품 옵션변경 없을때 다비젼 상품코드
                var goodsItemErpItmCodeList = [];
                // 기준판매가 설정이 변경되었는지를 확인
                $("tr.goods_item", "#tbody_goods_item").each(function() {
                    var $this = $(this)
                      , $radio = $('input:radio[name=standardPriceYn]', $this)
                      , standardPriceYn = $radio.is(':checked') ? 'Y' : 'N'
                      , data = $this.data("goods_item");
                    
                    if (allDataFlag && 'Y' === standardPriceYn) {
                        goodsData['customerPrice'] = data['customerPrice'];
                        goodsData['supplyPrice'] = data['supplyPrice'];
                        goodsData['sepSupplyPriceYn'] = data['sepSupplyPriceYn'];
                        goodsData['salePrice'] = data['salePrice'];
                        goodsData['stockQtt'] = data['stockQtt'];
                    }
                    
                    if(allDataFlag || standardPriceYn !== data['standardPriceYn']) {
                        data['standardPriceYn'] = standardPriceYn;
                        if ('L' === data['registFlag']) {
                            data['registFlag'] = 'U';
                        }
                    }
                    
                    if($(this).css("display") == "none") {
                    	// 다비젼 상품 코드가 숨겨진 상태면. 다비젼 상품 코드 값 제거
                    	data['erpItmCode'] = null;
                    }
                    
                    $this.data("goods_item", data);
                    if (allDataFlag || 'L' !== data['registFlag']) {
                        goodsItemList.push(data);
                        if(data['itemNo']!='' && data['itemNo']){
                            var erpItmCodeData = {};
                    	erpItmCodeData['itemNo'] = data['itemNo'];	// 신규인 경우는 위의 if에서 처리 되므로 이 경우 itemNo는 반드시 있다.
                    	erpItmCodeData['erpItmCode'] = data['erpItmCode'];
                    	goodsItemErpItmCodeList.push(erpItmCodeData);
                        }
                    } else {
                    	// 다른 정보 변경이 없는 경우. 다비젼 상품 코드만  설정
                    	var erpItmCodeData = {};
                    	erpItmCodeData['itemNo'] = data['itemNo'];	// 신규인 경우는 위의 if에서 처리 되므로 이 경우 itemNo는 반드시 있다.
                    	erpItmCodeData['erpItmCode'] = data['erpItmCode'];
                    	goodsItemErpItmCodeList.push(erpItmCodeData);
                    }
                });
                goodsData['goodsItemList'] = goodsItemList;
                goodsData['goodsItemErpItmCodeList'] = goodsItemErpItmCodeList;
                // 옵션 정보 설정                 
                if (allDataFlag) {
                    goodsData['goodsOptionList'] = $target.data("opt_data");
                } else {
                    goodsData['optionList'] = $target.data("opt_data");
                }
                // 옵션 생성 변경 FLAG
                // 새로 생성 일 경우 
                goodsData['changeFlag'] = true === $('#tb_goods_option').data('new_option_flag') ? 'C' : true === $('#tb_goods_option').data('load_option_flag') ? 'U' : ''; 
            }
            
            // 메인화면 적용 이벤트 (옵션만들기 팝업화면에서 적용하기 버튼 클릭시 이벤트)
            function fn_applyMainGoods() {
                var optDatas = loadOptData()
                  , goodsItemInfos = loadItemData();
                if(goodsItemInfos == null) {
                	return false;
                }
                createMainOptionTable(optDatas, goodsItemInfos);
                return true;
            }
            // 옵션 정보 생성
            function createGoodsOptionTable() {
               //기존 등록된 옵션 정보가 있는지 확인
                var $trData = $("tr.goods_item","#tbody_goods_item");
                if(null == $trData || $trData.length < 1) {                 
                    // 기존 임시 등록 정보 삭제
                    $("table", "#div_tb_goods_option").data("option_sel_info", null);
                    // 입력 전 화면 정보 수정
                    $("tr.itemoption", "#tbody_item").remove();
                    
                    // 디폴트 팝업 화면 표시
                    $("#tr_item_template").hide();
                    $("#tr_no_item_data").show();
                    $('#tb_goods_option').data('new_option_flag', true);
                // 화면에 표시된 데이터가 있을 경우 화면 데이터로 새로 작성 
                } else {
                  // 기존화면에 표시된 옵션 row 삭제
                  $('tr.itemoption', '#tb_goods_option').remove();
                  
                  createOptionInfoTable($('#div_multi_option').data('opt_data'));
                  // createOptionInfoTable($('#div_multi_option').data('prev_value'));
                  
                  $trData.each(function (){
                      var data = null != $(this).data('prev_value') ? $(this).data('prev_value') : $(this).data('goods_item');
                      addPopItemOption(data, true);
                  });
                }
            }
            // 옵션 미리보기 정보 생성 
            function createPreviewOption() {
                var optData =  $('#div_multi_option').data('opt_data');

                $('tr.preview_option', '#tbody_preview_option').remove();
                $.each(optData, function(idx, data) {
                    var $tmpTr = $("#tr_preview_option_template").hide().clone().show().removeAttr("id").addClass("preview_option").data("data", data);                    
                    $('[data-bind=preview_option_info]', $tmpTr).DataBinder(data);
                    $("#tbody_preview_option").append($tmpTr);
                });
            }
            // 옵션 미리보기 셀렉트박스 바인딩
            function setOptionSelect(data, obj, bindName, target, area, row) {
                var optionValueList = 'optionValueList' in data && data['optionValueList'] ? data['optionValueList'] : []
                  , $sel = $('select', obj)
                  , $label = $('label', $sel.parent());
                
                $sel.find('option').not(':first').remove();
                $label.text($sel.find("option:first").text());
                
                $.each(optionValueList, function(idx, data) {
                    if (data.attrNm) {
                        $sel.append('<option value="'+ data.attrNo + '">' + data.attrNm + '</option>');
                    }
                });
            }
            
            // 옵션만들기 팝업화면의 사용자 입력 값을 데이터 오브젝트 형태로 작성하여 반환 
            function loadItemData() {
                var goodsItemData = []
                  , isStandardPriceYn = false;
                var isErr = false;
                // 단품 정보(ROW별) 처리
                $("tr.itemoption", $("#tbody_item")).each(function(idx, obj) {
                    var $text1 = $('input:text[name=attrValue1]', $(this))
                      , $text2 = $('input:text[name=attrValue2]', $(this))
                      , $text3 = $('input:text[name=attrValue3]', $(this))
                      , $text4 = $('input:text[name=attrValue4]', $(this))
                      ;
                    
                    var _visible = $(this).css("display");
                	if(_visible=='none'){
		                $(this).data('data')['registFlag']='D';
		            }
                    
                    var data = {
                            'optNo1' : null != $(this).data('data')['optNo1']  ? $(this).data('data')['optNo1']  : '',
                            'attrNo1' :null != $(this).data('data')['attrNo1'] ? $(this).data('data')['attrNo1'] : '',
                            'optNo2' : null != $(this).data('data')['optNo2']  ? $(this).data('data')['optNo2']  : '',
                            'attrNo2' :null != $(this).data('data')['attrNo2'] ? $(this).data('data')['attrNo2'] : '',
                            'optNo3' : null != $(this).data('data')['optNo3']  ? $(this).data('data')['optNo3']  : '',
                            'attrNo3' :null != $(this).data('data')['attrNo3'] ? $(this).data('data')['attrNo3'] : '',
                            'optNo4' : null != $(this).data('data')['optNo4']  ? $(this).data('data')['optNo4']  : '',
                            'attrNo4' :null != $(this).data('data')['attrNo4'] ? $(this).data('data')['attrNo4'] : '',
                                    
                            'attrValue1' : $("input:text[name=attrValue1]", $(this)).val(),
                            'attrValue2' : $("input:text[name=attrValue2]", $(this)).val(),
                            'attrValue3' : $("input:text[name=attrValue3]", $(this)).val(),
                            'attrValue4' : $("input:text[name=attrValue4]", $(this)).val(),
                            'customerPrice' : $("input:text[name=customerPrice]", $(this)).val().trim().replaceAll(',', ''),
                            'supplyPrice' : $("input:text[name=supplyPrice]", $(this)).val().trim().replaceAll(',', ''),
                            'salePrice' : $("input:text[name=salePrice]", $(this)).val().trim().replaceAll(',', ''),
                            'stockQtt' : $("input:text[name=stockQtt]", $(this)).val().trim().replaceAll(',', ''),
                            // 'standardPriceYn' : $("input:radio", $(this)).is(':checked') ? "Y":"N",
                            'sepSupplyPriceYn' : $("#chk_sepSupplyPriceYn", $(this)).eq(0).hasClass('on') ? "Y":"N",
                            'standardPriceYn' : $("label", $(this)).eq(0).hasClass('on') ? "Y":"N",
                            'useYn' :  'D' === $(this).data('data')['registFlag'] ? 'N' : 'Y',
                            'registFlag' : null != $(this).data('data')['registFlag'] ? $(this).data('data')['registFlag'] : 'I',
                            'erpItmCode' : $("input:text[name=itemErpItmCode]", $(this)).val().trim(),
                        };
                    if (!data['salePrice']) {
                        Dmall.LayerUtil.alert('상품 판매가는 필수 입력 항목입니다.');
                        isErr = true;
                        return false;
                    }
                    
                    if (!data['stockQtt']) {
                        Dmall.LayerUtil.alert('상품 재고 수량은 필수 입력 항목입니다.');
                        isErr = true;
                        return false;
                    }
                    
                    if (!data['attrValue1']) {
                        Dmall.LayerUtil.alert('상품 옵션은 필수 입력 항목입니다.');
                        isErr = true;
                        return false;
                    }
                    if ($("#th_multiOptPopErpItmCode").css("display") != "none" && !data['erpItmCode'] && data['registFlag'] !='D') {
                        Dmall.LayerUtil.alert('다비젼 상품코드는 필수 입력 항목입니다.');
                        isErr = true;
                        return false;
                    }

                    var attrValue1 = (data['attrValue1']) ? data['attrValue1'].trim() : ''
                      , attrValue2 = (data['attrValue2']) ? data['attrValue2'].trim() : ''
                      , attrValue3 = (data['attrValue3']) ? data['attrValue3'].trim() : ''
                      , attrValue4 = (data['attrValue4']) ? data['attrValue4'].trim() : ''
                      , attrKey = attrValue1 + '^' + attrValue2 + '^' + attrValue3 + '^' + attrValue4
                      , checkAttrValue = false;

                    $.each(goodsItemData, function(i, obj) {
                        var attrVal1 = (obj['attrValue1']) ? obj['attrValue1'].trim() : ''
                          , attrVal2 = (obj['attrValue2']) ? obj['attrValue2'].trim() : ''
                          , attrVal3 = (obj['attrValue3']) ? obj['attrValue3'].trim() : ''
                          , attrVal4 = (obj['attrValue4']) ? obj['attrValue4'].trim() : ''
                          , obAttrKey = attrVal1 + '^' + attrVal2 + '^' + attrVal3 + '^' + attrVal4;
                        if (attrKey == obAttrKey) {
                            checkAttrValue = true;
                            return false;
                        } 
                    });
                    
                    if (checkAttrValue) {
                        Dmall.LayerUtil.alert('속성이 중복된 단품은 만들 수 없습니다.');
                        return false;
                    }
                    
                    // 로딩 데이터의 경우, 현재값과 이전 로딩시의 값을 비교해서 
                    // 값이 수정되었을 경우, registFlag를 'U'로 변경  
                    var prev_value = $(this).data('prev_value');
                    if ( null != prev_value && 'I' !== prev_value['registFlag']) {
                        data['itemNo'] = prev_value['itemNo'];
                        
                        // 속성 삭제의 경우(속성 생성및 변경 버튼을 클릭했을 경우)
                        if ('D' !== prev_value['registFlag']) {

                            // 속성 정보 수정의 경우
                            if (    checkChangeValue(prev_value['attrValue1'], data['attrValue1']) 
                                 || checkChangeValue(prev_value['attrValue2'], data['attrValue2']) 
                                 || checkChangeValue(prev_value['attrValue3'], data['attrValue3']) 
                                 || checkChangeValue(prev_value['attrValue4'], data['attrValue4']) 
                            ) {
                                data['registFlag'] = 'N';
                            } else {
                                // 속성 정보 이외 수정의 경우
                                if (       checkChangeValue(prev_value['customerPrice'], data['customerPrice']) 
                                        || checkChangeValue(prev_value['supplyPrice'], data['supplyPrice'])
                                        || checkChangeValue(prev_value['sepSupplyPriceYn'], data['sepSupplyPriceYn'])
                                        || checkChangeValue(prev_value['salePrice'], data['salePrice']) 
                                        || checkChangeValue(prev_value['stockQtt'], data['stockQtt']) 
                                        || checkChangeValue(prev_value['standardPriceYn'], data['standardPriceYn']) 
                                   ) {
                                       data['registFlag'] = 'U';
                               } else {
                                   data['registFlag'] = 'L';
                               }
                            }
                        }
                    }
                    if (data['standardPriceYn'] === "Y") {
                        isStandardPriceYn = true;
                    }
                    goodsItemData.push(data);
                });
                
                // 중간에 오류가 있는 경우 null 반환
                if(isErr) {
                	return null;
                }
                
                // 기분판매가 설정이 없을 경우 처음 ROW를 선택
                if (false === isStandardPriceYn && goodsItemData.length > 0) {
                    goodsItemData[0]['standardPriceYn'] = 'Y';
                }
                

                return goodsItemData;
            }
            
            function checkChangeValue(value1, value2) {
                var val1 =  value1 ? (value1 + '').trim().replaceAll(',', '') : ""
                  , val2 =  value2 ? (value2 + '').trim().replaceAll(',', '') : ""
                  , changeFlag = false;
                
                if (val1 !== val2) {
                    changeFlag = true;
                }

                return changeFlag;
            }
            
            // 옵션만들기 팝업화면의 사용자 입력 값을 데이터 오브젝트 형태로 작성하여 반환 
            function loadOptData() {
                var optDatas = [];
                
                // 옵션 정보 취득
                $("th", $("#tr_pop_goods_item_head_2")).each(function(idx) {
                    var $th = $(this)
                      , optValueArray = [];
                    
                    // 단품 정보(ROW별) 처리
                    $($("tr.itemoption"), $("#tbody_item")).each(function(ix) {
                        // 속성 중복치 제거
                        var $tr = $(this)
                            , $optionTd = $("input:text[name=attrValue" + (idx+1) + "]", $(this).find("td.optionTd"))
                            , textVal =  $optionTd.val()
                            , prevValue = $optionTd.data('value') 
                            , flag = false
                            , attrNo = idx === 0 ? $tr.data('data')['attrNo1'] : idx === 1 ? $tr.data('data')['attrNo2'] : idx === 2 ? $tr.data('data')['attrNo3'] : idx === 3 ? $tr.data('data')['attrNo4'] : '';
                        
                        $.each(optValueArray, function(i, obj) {
                            if (obj['attrNm'] === textVal || !textVal ) {
                                flag = true;
                                return false;
                            } 
                        });
                        
                        var registFlag = 'I' === $tr.data('data')['registFlag'] ? 'I' : (prevValue === textVal ? 'L' : 'U');
                        // 옵션 새로 생성의 경우, 새로 입력한 속성 정보만 처리
                        if ($('#tb_goods_option').data('new_option_flag') && registFlag !== 'I') {
                            $th.data('registFlag', 'I').data('optNo', '');
                            flag = true;
                        }
                        $optionTd.data('registFlag', registFlag);

                        if (false === flag) {
                            // 속성 데이터
                            var data = {
                                'attrNm' : textVal,
                                'preAttrNm' : prevValue,
                                'attrNo' : attrNo,
                                // 'optNo' : $th.data("optNo"),
                                'optNo' : 'I' === $th.data('registFlag') ? null : $th.data("optNo"),
                                'registFlag' : registFlag,
                            };

                            if (data.attrNm) {
                                optValueArray.push(data);
                            }
                        }
                    });
                    
                    // 해당 옵션 정보(TH에 정보를 담아둠)
                    var optData = {
                        'optNm' : $th.data("optNm"),
                        'optNo' : $th.data("optNo"),
                        'optionValueList' : optValueArray,
                        'registFlag' : null != $th.data('registFlag') ? $th.data('registFlag') : 'I',
                    };
                    
                    optDatas.push(optData);
                }); 

                return optDatas;
            }
            
            // 메인화면 옵션정보 작성
            function createMainOptionTable(optDatas, goodsItemInfos){

                $("#div_multi_option").data("opt_data", optDatas).data("goods_item_info", goodsItemInfos);
                // 화면을 디폴트화면으로 되돌림
                $("col.temItem, th.temItem, td.temItem","#tb_goods_item").remove();
                $("#col_dynamic_col").css('width', '25%');
                $("tr.goods_item", "tbody_goods_item").remove();
                
                var rowCnt = optDatas.length, width = 25 / rowCnt;
                $("#col_dynamic_col").css('width', width + '%');
                // 상품 단품정보 화면 생성
                $('col.temItem', '#tb_goods_item').remove();
                
                $.each(optDatas, function(idx, optData) {
                    if (0 === idx) {
                        var $th = $("#tr_goods_item_head_2").find('th').eq(0).addClass("optInfo").data("optNm", optData["optNm"]).html(optData["optNm"])
                          , $td = $("#td_dynamic_cols").attr("name", "td_attr1").addClass("optInfo")
                          , $th2 = $("#tr_goods_item_head_1").find('th').eq(1).attr("colspan", rowCnt);
                        return true;
                    }
                    var $col = $("#col_dynamic_col").clone().show().removeAttr("id").css('width', width + '%').addClass("temItem")
                    , $th = $("#th_dynamic_cols").attr("colspan", rowCnt)
                    , $th2 = $("#tr_goods_item_head_2").find('th').eq(0).clone().show().removeAttr("id").addClass("temItem").html(optData["optNm"])
                    , $td = '<td id="td_attrValue'+ (idx+1) +'" class="optInfo temItem" data-bind="goods_item_info" data-bind-type="string" data-bind-value="attrValue'+ (idx+1) +'"></td>';
                    
                    $("#col_dynamic_col").after($col);
                    $("#tr_goods_item_head_2").append($th2);
                    $("#tr_goods_item_template").find("td.optInfo").last().after($td);
                });
                
                $("tr.goods_item", "#tbody_goods_item").remove();
                // 상품 단품정보 바인딩
                $.each(goodsItemInfos, function(idx, data) {
                    var $tmpTr = $("#tr_goods_item_template").hide().clone().show().removeAttr("id").addClass("goods_item").data("goods_item", data);
                    $('[data-bind="goods_item_info"]', $tmpTr).DataBinder(data);
                    
                    if ('D' === data['registFlag']) {
                        $tmpTr.hide();
                    }
                    $("#tbody_goods_item").append($tmpTr);
                });
                
                // 디폴트 표시
                if ($('tr.goods_item:visible', '#tbody_goods_item').length > 0) {
                    $('#tr_no_goods_item').hide();
                } else {
                    $('#tr_no_goods_item').show();
                }
                
            }
            
            function createOptionInfoTable(data){

                // 화면을 디폴트화면으로 되돌림
                $("col.tempOpt, th.tempOpt, td.tempOpt","#tb_goods_option").remove();
                $("#col_pop_dynamic_col").css('width', '25%');
                
                var rowCnt = 0;


                $.each(data, function(idx, obj) {

                    if (obj!=null && 'D' !== obj['registFlag']) {
                        rowCnt++;
                    }
                });

                var $table = $("#tb_goods_option").data("option_sel_info", data)
                  , width = 30 / rowCnt;
              
              $("#col_pop_dynamic_col").css('width', width + '%');
              $.each(data, function(idx, obj){
                  if(obj!=null){
	                  // 옵션이 단수 일 경우 
	                  if (0 === idx) {
	                      $("#th_pop_dynamic_cols").attr("colspan", 1);
	                      var $th = $("#tr_pop_goods_item_head_2").find('th').eq(0).data('registFlag', obj['registFlag']).data("optNm", obj.optNm).data("optNo", obj.optNo).html( obj.optNm );
	                      return true;
	                  }
	                  // 옵션이 복수 일 경우
	                 var $col = $("#col_pop_dynamic_col").clone().show().removeAttr("id").css('width', width + '%').addClass("tempOpt")
	                    , $th = $("#th_pop_dynamic_cols").attr("colspan", rowCnt)
	                    , $th2 = $("#tr_pop_goods_item_head_2").find('th').eq(0).clone().show().removeAttr("id").addClass("tempOpt").data('registFlag', obj['registFlag']).data("optNm", obj.optNm).data("optNo", obj.optNo).html( obj.optNm )
	                    , $td = $("#td_pop_dynamic_cols").clone().show().removeAttr("id").addClass("optionTd").addClass("tempOpt").html('<span class="intxt shot2"><input type="text" name="attrValue'+ (idx+1) +'" id="txt_attr'+ (idx+1)
	                          +'" data-bind="item_info" data-bind-type="text" data-bind-value="attrValue'+ (idx+1)
	                          +'" maxlength="50" data-validation-engine="validate[maxSize[50]]" ></span>');
	                  
	
	                  if ('D' == obj['registFlag']) {
	                      $th2.hide();
	                  } 
	                  // COL TH TD 등 생성된 태그를 화면에 반영
	                  $("#col_pop_dynamic_col").after($col);
	                  $("#tr_pop_goods_item_head_2").append($th2);
	                  $("#tr_item_template").find("td.optionTd").last().after($td);
                  }
              }); 
            }
            
            // 옵션 생성하기 버튼 클릭시 콜백함수 [옵션 생성 및 변경 팝업] 
            function fn_execute_create_option(data) {
                
                if (null != data && data.length > 0) {
                    
                    // 기존 옵션 정보 삭제 FLAG 
                    $("#tb_goods_option").data("new_option_flag", true);
                    
                    createOptionInfoTable(data);
                    
                    // 기존 화면에 표시되어 있는 단품 설정정보는 화면에서 삭제
                    $("tr:visible", '#tbody_item').each(function () {
                        // 기존 화면에 표시된 단품 정보 ROW별 처리 
                        if($(this).hasClass('itemoption')) {
                            

                            // 기존 정보가 이미 등록되어 있는 단품 정보일 경우
                            if ('L' === $(this).data("data")['registFlag'] ) {
                                $(this).data("data")['registFlag'] = 'D';
                                $(this).hide();
                                
                            // 화면에서 입력된 정보일 경우
                            } else {
                                $(this).remove();
                            }
                        } else {
                            $(this).hide();
                        }
                        
                    });
                    
                    // 입력된 옵션정보로 단품 정보 생성
                    makeItemOption(data[0], data[1], data[2], data[3]);
                    
                    // 옵션만들기 팝업(이중팝업) 닫기
                    $("#btn_close_layer_create_option").trigger('click');
                }
            }
            
            // 설정한 옵션 정보를 반영하여 단품등록 화면을 만듬 [옵션 만들기 팝업]
            function makeItemOption(opt1Data, opt2Data, opt3Data, opt4Data) {
                var $table = $("#tb_goods_option")
                  , optValue1, optValue2, optValue3, optValue4 = ""
                  , attrArray1, attrArray2, attrArray3, attrArray4 = []
                  , data = {};    

                // 신규 작성 데이터
                data['registFlag'] = 'I';
                
                optValue1 = opt1Data ? opt1Data.optionValue : null;
                // 옵션1 정보가 유효할 경우
                if(optValue1 && optValue1.trim().length > 1) {
                    attrArray1 = optValue1.split(",");
                    jQuery.each(attrArray1, function(idx1, obj1) {
                        data['attrValue1'] = obj1.trim(); 
                        optValue2 = opt2Data ? opt2Data.optionValue : null;
                    
                        // 옵션2 정보가 유효할 경우
                        if(optValue2 && optValue2.trim().length > 1) {
                            attrArray2 = optValue2.split(",");
                            jQuery.each(attrArray2, function(idx2, obj2) {
                                data['attrValue2']  = obj2.trim(); 
                                optValue3 = opt3Data ? opt3Data.optionValue : null;
                                
                                // 옵션3 정보가 유효할 경우
                                if(optValue3 && optValue3.trim().length > 1) {
                                    optValue3 = optValue3.split("$@#");
                                    jQuery.each(optValue3, function(idx3, obj3) {
                                        data['attrValue3']  = obj3.trim(); 
                                        optValue4 = opt4Data ? opt4Data.optionValue : null;
                                        
                                        // 옵션4 정보가 유효할 경우
                                        if(optValue4 && optValue4.trim().length > 1) {
                                            attrArray4 = optValue4.split(",");
                                            jQuery.each(attrArray4, function(idx4, obj4) {
                                                data['attrValue4']  = obj4.trim();
                                                // 옵션4까지 설정된 Option 생성
                                                addPopItemOption(data);
                                            });
                                        } else {
                                            // 옵션3까지 설정된 Option 생성
                                            addPopItemOption(data);
                                        }
                                        
                                    });
                                } else {
                                    // 옵션2까지 설정된 Option 생성
                                    addPopItemOption(data);
                                }
                            });
                        } else {
                            // 옵션1까지 설정된 Option 생성
                            addPopItemOption(data);
                        }
                    });
                    // 디폴트 표시
                    if ($("input:radio[name=standardPriceYn]:visible:checked", $("#tbody_item")).length < 1) {
                        $("label.radio:visible", $("#tbody_item")).eq(0).trigger('click');
                    } 
                }
            }
            
            // 단품 아이템 정보 추가 [옵션 만들기 팝업]
            function addPopItemOption(data, setPrevFlag) {

                $("#tr_no_item_data").hide();
                var $table = $("#tb_goods_option")
                  , $tmpItemTr = $("#tr_item_template").clone().show().removeAttr("id")
                  , nextIdx = 0;
                
                $("tr.itemoption", $table).each(function() {
                    var optionIdx = null != $(this).data("optionIdx") ? parseInt($(this).data("optionIdx")) : 0;
                    nextIdx = optionIdx >= nextIdx ? optionIdx + 1 : nextIdx;
                });
                
                // 아이템 추가 버튼을 클릭했을 경우,
                // 추가된 ROW에 registFlag 값을 'I'로 설정
                if (null == data) {
                    data = {
                        'idx' : nextIdx,
                        'registFlag' : 'I',
                    };
                } else {
                    data['idx'] = nextIdx;
                }
                $tmpItemTr.attr("id", "tr_item_"+nextIdx).removeClass("template").addClass("itemoption").data("data", data).data("optionIdx", nextIdx);

                // DB로딩의 경우에만 이전 값을 설정
                if (true === setPrevFlag) {
                    $tmpItemTr.data("prev_value", data);
                }
                
                // 삭제된 ROW는 화면에 표시안함
                if ('D' === data['registFlag']) {
                    $tmpItemTr.hide();
                }

                var optSepSupplyPriceYn =$tmpItemTr.find('#optSepSupplyPriceYn');
                optSepSupplyPriceYn.each(function(){

                    $(this).removeAttr('id').attr('id', 'optSepSupplyPriceYn_'+nextIdx);
                    $(this).siblings('label').attr('for', 'optSepSupplyPriceYn_'+nextIdx)

                    /*if(data['sepSupplyPriceYn']=='Y'){
                        $(this).trigger('click');
                    }*/

                });

                if(data['sepSupplyPriceYn']=='Y'){
                    $tmpItemTr.find('#txt_supplyPrice').removeAttr('readonly')
                }

                $("#tbody_item").append($tmpItemTr);

                // 옵션변경 팝업에서 받은 데이터를 화면에 바인딩
                $('[data-bind="item_info"]', $tmpItemTr).DataBinder(data);


                // 추가된 ROW에 COMMA처리
                $('input.comma', "#tbody_item").mask("#,##0", {
                    reverse : true,
                    maxlength : false
                });



                // 다중옵션 레이어팝업 수수료율적용 공급가 설정
                jQuery('#tbody_item [name=salePrice]').off("change").on('change', function(e) {
                    var sale_price = $(this).val().replaceAll(',', '');
                    var _input_supplyPrice = $(this).parents('tr').find("[name=supplyPrice]");
                    var ctgCmsRate = $("input[type=radio][name=mainCategory]:checked").parents("tr").children("td:eq(2)").text().replaceAll("%","");

                    var supply_price = 0;
                    var sellerCmsRate = parseInt($("#hd_sellerCmsRate").val());
                    
                    // 판매자별 수수료가 있을경우 우선처리
                    if (sellerCmsRate > 0) {
                        supply_price = sale_price*(1-(sellerCmsRate/100))
                    } else {
                        if(ctgCmsRate>0){
                            _input_supply_price.prop("readonly",true);
                            supply_price = sale_price*(1-(ctgCmsRate/100))
                        }else{
                            supply_price = sale_price;
                        }
                    }

                    supply_price = Math.round(supply_price);
                    
                    _input_supplyPrice.val(numberWithCommas(supply_price));

                });

                jQuery('#tbody_item label[id=chk_sepSupplyPriceYn]').off("click").on('click', function(e) {

                    Dmall.EventUtil.stopAnchorAction(e);

                    var $this = jQuery(this),
                        $input = $this.siblings('input'),
                        checked = !($input.prop('checked'));


                    $input.prop('checked', checked);
                    var txt_supply_price =$this.parents("tr").find("#txt_supplyPrice");

                    if($input.prop("checked")){
                        txt_supply_price.prop("readonly",false);
                        //$input.removeAttr("readonly")
                        $this.addClass('on');

                    }else{
                        txt_supply_price.prop("readonly",true);
                        $this.removeClass('on');
                        $this.parents("tr").find('#txt_salePrice').trigger("change");
                    }

                });



            }
            
            // 단품 아이템 정보 삭제 [옵션 만들기 팝업]
            function setDeleteItem(data, obj, bindName, target, area, row) {
                $("button", obj).off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $tr = $($(this).parent().parent());
                    
                    if ('I' === $tr.data('data')['registFlag']) {
                        $tr.remove();
                    } else {
                        //$tr.data('data')['registFlag'] = 'D';
                        $tr.hide();
                    }
                    if ($("tr.itemoption", "#tb_goods_option").length < 1) {
                        $("#tr_no_item_data").show();
                    }
                });
            }      
            
            function setItemPrice(data, obj, bindName, target, area, row) {
                obj.data("itemNo", data["itemNo"]);
                obj.off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    createItemPriceHist($('#hd_goodsNo').val(), data["itemNo"]);
                    Dmall.LayerPopupUtil.open(jQuery('#layer_price_hist'));
                });
            }
            
            function setItemQtt(data, obj, bindName, target, area, row) {
                obj.data("itemNo", data["itemNo"]);
                obj.off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    createItemQttHist($('#hd_goodsNo').val(), data["itemNo"]);
                    Dmall.LayerPopupUtil.open(jQuery('#layer_qtt_hist'));
                });
            }

            // 기준할인가 라디오 버튼 바인딩
            function setStandardPriceYn(data, obj, bindName, target, area, row) {
                
                // 화면상에 표시된 요소로 라디오버튼의 ID를 생성
                var nextIdx = 0;
                $("tr.itemoption", $("#tbody_item")).each(function() {
                    var optionIdx = null != $(this).data("optionIdx") ? parseInt($(this).data("optionIdx")) : 0;
                    nextIdx = optionIdx >= nextIdx ? optionIdx + 1 : nextIdx;
                });
                // 라벨 및 라디오 버튼에 생성된 ID적용
                var $label = $("label", obj).removeAttr("for").attr("for", "rdo_standardPriceYn_" +nextIdx)
                  , $input = $("input:radio", obj).removeAttr("id").attr("id", "rdo_standardPriceYn_" +nextIdx);
                
                // 라디오 버튼 클릭 이벤트 설정
                jQuery('label.radio', obj).off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    
                    var $this = $(this),
                        $input = jQuery("#" + $this.attr("for"));
                    
                    $("input:radio[name=" + $input.attr("name") + "]").each(function() {
                        $(this).removeProp('checked');
                        $("label[for=" + $(this).attr("id") + "]").removeClass('on');
                    });
                    $input.prop('checked', true).trigger('change');
                    if ($input.prop('checked')) {
                        $this.addClass('on');
                    }
                });
                
                if ('Y' === data['standardPriceYn']) {
                    $input.prop('checked', true).trigger('change');
                    $label.addClass('on');
                }
            }
            
            // 기준할인가 라디오 버튼 바인딩
            function setStandardPriceYnMain(data, obj, bindName, target, area, row) {
                // 화면상에 표시된 요소로 라디오버튼의 ID를 생성
                var nextIdx = $('tr', '#tbody_goods_item').last().index();
                // 라벨 및 라디오 버튼에 생성된 ID적용
                var $label = $("label", obj).removeAttr("for").attr("for", "rdo_standardPriceYn_" +nextIdx)
                  , $input = $("input:radio", obj).removeAttr("id").attr("id", "rdo_standardPriceYn_" +nextIdx);
                
                // 라디오 버튼 클릭 이벤트 설정
                jQuery('label.radio', obj).off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    
                    var $this = $(this),
                        $input = jQuery("#" + $this.attr("for"));
                    
                    $("input:radio[name=" + $input.attr("name") + "]").each(function() {
                        $(this).removeProp('checked');
                        $("label[for=" + $(this).attr("id") + "]").removeClass('on');
                    });
                    $input.prop('checked', true).trigger('change');
                    if ($input.prop('checked')) {
                        $this.addClass('on');
                    }
                });
                
                if ('Y' === data['standardPriceYn']) {
                    $input.prop('checked', true).trigger('change');
                    $label.addClass('on');
                }
            }
            /*** 다중옵션 관련 - 끝 ***/
            
            
            /*** 추가옵션 관련 - 시작 ***/
            /*** 4. 추가 옵션 설정 로딩 데이터 바인딩 ***/
            function loadGoodsAddOption(data) {
                // 추가 옵션 정보 취득 및 화면 설정
                $('[data-bind=add_opt_info]', '#tbody_add_option_set').DataBinder(data);
                // 추가 옵션 정보 삭제
                $('tr.add_option', '#tbody_add_option').remove();
                $('span.add_option, button.add_option', '#tbody_add_option').remove();
                
                // 추가 옵션 로딩 정보 설정
                // if ('addOptUseYn' in data && 'Y' === data['addOptUseYn']) {                     
                    $.each(data.goodsAddOptionList, function(idx, addOpt) {
                        addOpt['registFlag'] = 'L';
                        fn_addAddOptionRow(addOpt);
                    });
                // }
                // 읽어들인 추가옵션 정보가 없을 경우
                if ($('tr.add_option', '#tbody_add_option').length < 1) {
                    // 새로운 ROW 표시
                    fn_addAddOptionRow();
                }
            }
            
            // 추가옵션 정보 취득 - [상품저장.4]
            function getGoodsAddOptionValue($target, allDataFlag) {
                var returnData = []
                  , opt_dtl_seq = 0;
                
                $target.each(function() {
                    var addOptionValueList = []
                      , $tr = $(this)
                      , prev_opt = $tr.data('prev_data');
                    
                    $("span.intxt", $(this).find('td').eq(1)).each(function(idx) {
                        var $input0 = $("input:text", $tr.find('td').eq(0)).eq(idx)
                          , $input1 = $("input:text", $tr.find('td').eq(1)).eq(idx)
                          , $input2 = $("input:text", $tr.find('td').eq(2)).eq(idx)
                          , $select0 = $("select option:selected", $tr.find('td').eq(2)).eq(idx)
                          , prev_data = $input1.data('prev_data');
                        
                        var data = {
                            goodsNo : $('#hd_goodsNo').val(),
                            addOptNo : (prev_opt && 'addOptNo' in prev_opt) ? prev_opt['addOptNo'] : "",
                            addOptDtlSeq : (allDataFlag) ? opt_dtl_seq++ : (prev_data && 'addOptDtlSeq' in prev_data) ? prev_data['addOptDtlSeq'] : "",
                            addOptValue : $input1.val(), 
                            addOptAmt : $input2.val().trim().replaceAll(',', ''),
                            addOptAmtChgCd : $select0.val(),
                            optVer : (prev_data && 'optVer' in prev_data)  ? prev_data['optVer'] : "1",
                            registFlag : $input1.data('registFlag') ? $input1.data('registFlag') : "I",
                        };

                        if (prev_data != null && 'L' === prev_data['registFlag']
                             && ( prev_data['addOptValue'] != data['addOptValue']
                                  || $input2.data('prev_value') != data['addOptAmt']
                                  || prev_data['addOptAmtChgCd'] != data['addOptAmtChgCd'])
                        ) {
                            data['registFlag'] = 'U';
                        }
                        
                        addOptionValueList.push(data);
                    });
                    var optData = {
                        goodsNo : $('#hd_goodsNo').val(),
                        addOptNo : prev_opt['addOptNo'],
                        addOptNm : $("input:text", $tr.find('td').eq(0)).val(),
                        requiredYn : $("input:checkbox", $tr.find('td').eq(3)).prop('checked') ? "Y" : "N",
                        registFlag : $tr.data("registFlag"),
                        addOptionValueList : addOptionValueList,
                    };
                    
                    if ( prev_opt != null && 'L' === prev_opt['registFlag']
                        && ( prev_opt['addOptNm'] !== optData['addOptNm']
                          || prev_opt['requiredYn'] !== optData['requiredYn'])
                    ) {
                        optData['registFlag'] = 'U';
                    }
                    returnData.push(optData);
                });
                return returnData;
            }
            // 추가 옵션에 옵션 입력 Row 추가
            function fn_addAddOptionRow(data){
                if ( data == null) {
                    data =     {
                        "registFlag": 'I',
                    }
                }
                
                var $tmpTr = $("#tr_add_option_template").clone().show().removeAttr("id")
                  , $td1 = $("td:eq(0)", $tmpTr)
                  , $td2 = $("td:eq(1)", $tmpTr)
                  , $td3 = $("td:eq(2)", $tmpTr)
                  , $td4 = $("td:eq(3)", $tmpTr);
                
                var nextIdx = 0;
                $("tr.add_option", $("#tbody_add_option")).each(function() {
                    var setIdx = null != $(this).data("setIdx") ? parseInt($(this).data("setIdx")) : -1;
                    nextIdx = setIdx >= nextIdx ? setIdx + 1 : nextIdx;
                });
                
                // TR에 DB에서 읽어온 추가옵션 정보를 등록한다.
                $tmpTr.attr("id", "tr_add_option_" + nextIdx).addClass("add_option")
                    .data("setIdx", nextIdx)
                    .data("prev_data", data)    // 로딩된 정보(이전 추가옵션 정보)
                    .data('registFlag', null != data && data.registFlag ? data.registFlag : "I");
                
                $td1.data("add_opt_no", null != data ? data.addOptNo : "").data("registFlag", null != data ? data.registFlag : "I").html(' <span class="intxt add_info" id="sp_opt_'+ nextIdx +'"><input type="text" name="addOptionNm'+ nextIdx +'" id="txt_add_option_nm'+ nextIdx +'" maxlength="20"/></span> ');
                var addOptNm = (null != data && 'addOptNm' in data) ? data.addOptNm : "";
                $('input:last', $td1).val(addOptNm);                
                var btn = document.createElement('button');
                if (0 === nextIdx) {
                    $(btn).data("optIdx",  nextIdx).attr("id", "btn_del_opt_"+ nextIdx).addClass("btn_gray3").html("추가").off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var addData =     {
                                "goodsNo": null != data ? data.goodsNo : '',
                                "registFlag": 'I',
                        };
                        fn_addAddOptionRow(addData);
                    });
                } else {
                    $(btn).data("optIdx",  nextIdx).attr("id", "btn_del_opt_"+ nextIdx).addClass("btn_gray3").addClass("add_info").html("삭제").off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var $tr = $("#tr_add_option_" + $(this).data("optIdx"))
                          , registFlag = $tr.data('registFlag');                        
                        if ('I' !== registFlag) {
                            $tr.hide().data('registFlag', 'D');
                        } else {
                            $tr.remove();
                        }
                    });
                }
                $td1.append(btn);
                // 추가 옵션 정보 있을 경우 
                if ( data && null != data.addOptionValueList && data.addOptionValueList.length > 0) {
                    $.each(data.addOptionValueList, function(idx, optDtl){
                        if (0 === idx) {
                            $td2.html(' <span class="intxt add_info" id="sp_opt_item'+ nextIdx +'_'+ idx + '"><input type="text" name="addOptionItemNm'+ nextIdx +'_'+ idx +'" id="txt_add_option_item_nm'+ nextIdx +'_' + idx + '" maxlength="50" /></span> ');
                            $('input' , $td2)
                                .data('data', optDtl)
                                .data('prev_data', optDtl)
                                .data('registFlag', optDtl.registFlag)
                                .val(null != optDtl ? optDtl.addOptValue : '');
                            
                            var btn2 = document.createElement('button');
                            $(btn2).data("optIdx",  nextIdx).data("itemIdx", 0).attr("id", "btn_del_opt_item_"+ nextIdx + "_0").addClass("btn_gray3").html("추가").off("click").on('click', function(e) {
                                Dmall.EventUtil.stopAnchorAction(e);
                                var addData = {
                                        "goodsNo": null != optDtl ? optDtl.goodsNo : '',
                                        "addOptNo": null != optDtl ? optDtl.addOptNo : '',
                                        "registFlag":"I"
                                    };
                                addOptionItem($(this), addData);
                            });
                            $td2.append(btn2);
                        
                            var $lable3 = $('label', $td3)
                              , $input3 = $('select', $td3)
                              , $inputtext = $('input:text', $td3)
                              , selid = 'sel_sp_price_opt_item' + nextIdx;
                            
                            $input3.removeAttr('id').attr('id', selid).data('prev_value', null != optDtl ? optDtl.addOptAmtChgCd : '');
                            var $option = $("option[value='"+ optDtl.addOptAmtChgCd +"']", $input3).attr('selected', 'true');                            
                            $lable3.removeAttr("id").attr("id", 'lb_sp_price_opt_item' + nextIdx).removeAttr("for").attr("for", selid).text($option.text());
                            
                            $input3.on('change', function(e) {
                                var lb_chk = $("#lb_sp_price_opt_item" + nextIdx);
                                if (lb_chk && !lb_chk.hasClass("on") ) {
                                    lb_chk.trigger("click");
                                }
                            });                            
                            
                            var addOptAmt = (null != optDtl && 'addOptAmt' in optDtl) ? parseInt(optDtl.addOptAmt) : '';
                            $inputtext.removeAttr('id').attr('id', 'txt_add_option_amt_' + nextIdx)
                                .data('prev_value', addOptAmt).val(addOptAmt.getCommaNumber());
    
                            var $input = $('input', $td4)
                              , $label = $('label', $td4);
                            
                            $input.removeAttr("id").attr("id", "chk_required_"+ nextIdx).data("prev_value", null != data ? data.requiredYn : "");
                            $label.removeAttr("id").attr("id", "lb_required_"+ nextIdx).removeAttr("for").attr("for", "chk_required_"+ nextIdx);
                            
                            if ('Y' === data.requiredYn) {
                                $input.prop('checked', true);
                                $label.addClass('on');
                            } else {
                                $input.prop('checked', false);
                                $label.removeClass('on');
                            }
                          
                            // 체크박스 클릭시 이벤트 설정
                            $label.off('click').on('click', function(e) {
                                Dmall.EventUtil.stopAnchorAction(e);
                                var $this = jQuery(this),
                                    checked = !($input.prop('checked'));
                                
                                if(!$input.prop('disabled') && !$input.prop('readonly')) {
                                    $input.prop('checked', checked);
                                    $this.toggleClass('on');
                                }
                            });
                            
                        } else {
                            addOptionItem($('button:first', $td2).eq(0), optDtl);
                        }                            
                        
                    });
                // 추가 옵션 정보가 없을 경우
                } else {
                    $td2.html(' <span class="intxt add_info" id="sp_opt_item'+ nextIdx +'_0"><input type="text" name="addOptionItemNm'+ nextIdx +'_0" id="txt_add_option_item_nm'+ nextIdx +'_0" maxlength="50" /></span> ');
                    $('input' , $td2).data('data', null).data('prev_data', null).data('registFlag', 'I');
                    var btn2 = document.createElement('button');
                    $(btn2).data("optIdx",  nextIdx).data("itemIdx", 0).attr("id", "btn_del_opt_item_"+ nextIdx + "_0").addClass("btn_gray3").html("추가").off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var addData = {
                                "registFlag":"I"
                            };
                        addOptionItem($(this), addData);
                    });
                    $td2.append(btn2);
                    
                    var $lable3 = $("label", $td3)
                      , $input3 = $("select", $td3)
                      , $inputtext = $('input:text', $td3)
                      , selid = 'sel_sp_price_opt_item' + nextIdx;
                    $input3.removeAttr("id").attr("id", selid);
                        // .find("option[value='"+ data["addOptAmtChgCd"] +"']").attr("selected", "true");
                    $lable3.removeAttr("id").attr("id", 'lb_sp_price_opt_item' + nextIdx).removeAttr("for").attr("for", selid);                
                    $input3.on('change', function(e) {
                        var lb_chk = $("#lb_sp_price_opt_item" + nextIdx);
                        if (lb_chk && !lb_chk.hasClass("on") ) {
                            lb_chk.trigger("click");
                        }
                    });
                    $inputtext.removeAttr('id').attr('id', 'txt_add_option_amt_' + nextIdx).data('prev_value', '').val('');
                    
                    var $input4 = $('input', $td4)
                      , $label4 = $('label', $td4);
                    
                    $input4.removeAttr("id").attr("id", "chk_required_"+ nextIdx).data("value", null != data ? data.requiredYn : "");
                    $label4.removeAttr("id").attr("id", "lb_required_"+ nextIdx).removeAttr("for").attr("for", "chk_required_"+ nextIdx);
                  
                    // 체크박스 클릭시 이벤트 설정
                    $label4.off("click").on('click', function(e) {                        
                        Dmall.EventUtil.stopAnchorAction(e);
                        var $this = jQuery(this),
                            checked = !($input4.prop('checked'));
                        
                        if(!$input4.prop('disabled') && !$input4.prop('readonly')) {
                            $input4.prop('checked', checked);
                            $this.toggleClass('on');
                        }
                    });
                }
                $("#tbody_add_option").append($tmpTr);
                Dmall.common.comma();
            }
            // 추가 옵션에 아이템(옵션 하위레벨) 입력 Row 추가
            function addOptionItem($btn, optDtl) {
                var $td = $btn.parent("td")
                  , $tr = $td.parent("tr")
                  , $td3 = $("td:eq(2)", $tr)
                  , addOptionIdx = $btn.data("optIdx")
                  , addOptionItemIdx = $("input:text", $td).length
                  , itemKey = addOptionIdx +"_"+ addOptionItemIdx
                  , html = ' <span class="br2 add_option" id="sp_br_opt_item'+ itemKey +'"></span>' 
                          + '<span class="intxt add_option" id="sp_opt_item'+ itemKey +'">'
                          + '<input type="text" name="addOptionItemNm'+ itemKey + '" id="txt_add_option_item_nm'+ itemKey +'" maxlength="50" />' 
                          + '</span> '
                  , html2 = "";
                var btn = document.createElement('button');
                $(btn).data("optIdx",  addOptionIdx).data("itemIdx", addOptionItemIdx)
                      .attr("id", "btn_del_opt_item_"+ itemKey).addClass("btn_gray3").addClass("add_option")
                      .html("삭제").off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    deleteOptionItem($(this));
                });
                
                $td.append(html).append(btn);
                $('input:last' , $td)
                    .data('prev_data', optDtl)
                    .data('registFlag', optDtl.registFlag)
                    .data('prev_value', optDtl.addOptValue)
                    .val(null != optDtl ? optDtl.addOptValue : '');

                var $tmpSpan = $("#sp_sel_add_option_price_cd_template").clone().removeAttr("id").addClass('add_option').attr("id", 'sp_price_opt_item'+ itemKey)                  
                  , $select = $("select", $tmpSpan).data("optIdx",  addOptionIdx).data("itemIdx", addOptionItemIdx).removeAttr("id").attr("id", 'sel_price_opt_item'+ itemKey)
                  , $label = $("label", $tmpSpan).removeAttr("id").attr("id", 'lb_price_opt_item'+ itemKey).data("optIdx",  addOptionIdx).data("itemIdx", addOptionItemIdx).attr("for", 'sel_sp_price_opt_item'+ itemKey)
                  , addOptAmtChgCd = (null != optDtl && 'addOptAmtChgCd' in optDtl) ? optDtl.addOptAmtChgCd : '1'   // 넘어온 데이터에 설정값이 없을 경우 디폴트값 설정
                  ;
                
                $select.data('prev_value', null != optDtl ? optDtl.addOptAmtChgCd : '');
                var $option = $("option[value='"+ addOptAmtChgCd +"']", $select).attr('selected', 'true');
                $label.text($option.text());
                
                $select.on('change', function(e) {
                    var lb_chk = $("#lb_price_opt_item" + itemKey);
                    if (lb_chk && !lb_chk.hasClass("on") ) {
                        lb_chk.trigger("click");
                    }
                });
                $td3.append(' <span class="br2 add_option" id="sp_price_br_opt_item'+ itemKey +'"></span>')
                    .append($tmpSpan)
                    .append(' <span class="intxt add_option" id="sp_price_txt_opt_item'+ itemKey +'"><input type="text" class="comma" name="addOptionPrice'+ itemKey + '" id="sel_add_option_price'+ itemKey +'" maxlength="10" /></span>');
                var addOptAmt = (null != optDtl && 'addOptAmt' in optDtl) ? parseInt(optDtl.addOptAmt) : '';
                $('input:last', $td3).data('prev_value', addOptAmt).val(addOptAmt.getCommaNumber());
                
                Dmall.common.comma();
            }
            // 추가 옵션에 아이템(옵션 하위레벨) 입력 Row 삭제
            function deleteOptionItem($btn) {
                var $td = $btn.parent("td")
                  , $tr = $td.parent("tr")
                  , addOptionIdx = $btn.data("optIdx")
                  , addOptionItemIdx = $btn.data("itemIdx")
                  , itemKey = addOptionIdx +"_"+ addOptionItemIdx
                  , $inputtext = $('#txt_add_option_item_nm' + itemKey);
                
                if ( 'I' === $inputtext.data('registFlag') ) {
                    $("#sp_br_opt_item" + itemKey , $tr).remove();
                    $("#sp_opt_item" + itemKey, $tr).remove();
                    $("#btn_del_opt_item_" + itemKey, $tr).remove();
                    
                    $("#sp_price_br_opt_item" + itemKey, $tr).remove();
                    $("#sp_price_opt_item" + itemKey, $tr).remove();
                    $("#sp_price_txt_opt_item" + itemKey, $tr).remove();
                } else {
                    $inputtext.data('registFlag', 'D');
                    $("#sp_br_opt_item" + itemKey , $tr).hide();
                    $("#sp_opt_item" + itemKey, $tr).hide();
                    $("#btn_del_opt_item_" + itemKey, $tr).hide();
                    
                    $("#sp_price_br_opt_item" + itemKey, $tr).hide();
                    $("#sp_price_opt_item" + itemKey, $tr).hide();
                    $("#sp_price_txt_opt_item" + itemKey, $tr).hide();
                }
            }            
            /*** 추가옵션 관련 - 끝 ***/
            
            
            /*** 관련 상품 관련 - 시작 ***/
            function loadRelateGoods(data) {
                
                // 기존 관련 상품 정보 삭제
                $("#div_display_relate_goods_condition").html('[선택된 조건]');
                $('li.relate_goods', '#tb_relate_goods').remove();
                
                $('#sel_relate_ctg_1').data('relateGoodsApplyCtgNo', data['relateGoodsApplyCtgNo1']);
                $('#sel_relate_ctg_2').data('relateGoodsApplyCtgNo', data['relateGoodsApplyCtgNo2']);
                $('#sel_relate_ctg_3').data('relateGoodsApplyCtgNo', data['relateGoodsApplyCtgNo3']);
                $('#sel_relate_ctg_4').data('relateGoodsApplyCtgNo', data['relateGoodsApplyCtgNo4']);

                if ('relateGoodsApplyTypeCd' in data) {
                    var type = data['relateGoodsApplyTypeCd'];
                    $('label[for=rdo_relateGoodsApplyTypeCd_'+ type +']', '#tbody_relate_goods').trigger('click');
                    switch(type) {
                        case '1' :
                            setRelateGoodsCondition(data);
                            break;
                            
                        case '2' :
                            if ('relateGoodsList' in data) {
                                var relateGoodsList = data['relateGoodsList'];
                                $.each(relateGoodsList, function(idx, relateGoodsData){
                                    var $tmpli = $("#li_relate_goods_template").clone().show().removeAttr("id").addClass("relate_goods")
                                        .attr('id', 'li_relate_goods_' + relateGoodsData['relateGoodsNo'])
                                        .data("registFlag", 'L')
                                        .data("goods_info", relateGoodsData);
                                    // 검색결과 바인딩
                                    $('[data-bind="relate_goods"]', $tmpli).DataBinder(relateGoodsData);
                                    // 생성된 li 추가
                                    $('#ul_relate_goods').append($tmpli);
                                    
                                });
                            }
                            break;
                            
                        default :
                            break;
                        
                    }
                }
            }
            /*** 관련 상품 관련 - 끝 ***/
            
            
            
            /*** 상품 고시정보 관련 - 시작 ***/
            /*** 5. 고시 정보 로딩 데이터 바인딩 ***/
            function loadGoodsNotifyList(data) {
                if ('notifyNo' in data && data['notifyNo'].length > 0) {
                    var goodsNotifyNo = data['notifyNo']
                      , goodsNotifyList= data['goodsNotifyList']
                      , $sel = $('#sel_goods_notify').data('prev_value', goodsNotifyNo)
                      , $label = $('#lb_goods_notify')
                      , $option = $("option[value='"+ goodsNotifyNo +"']", $sel).attr('selected', 'true');
                    
                    $label.text($option.text());                
                    // 기존 상품 고시 정보 삭제
                    var $inputGoodsNotify = $('input[data-bind=goods_notify_item]', '#tbody_goods_notify').val('');
                    // 고시 정보 설정
                    getGoodsNotifyList(goodsNotifyNo, goodsNotifyList);
                }
            }
            // 상품 고시 정보 값 설정
            function setGoodsNotifyInfo(data) {
                var itemNo = data['itemNo']
                  , itemValue = data['itemValue'];
                $('input[data-bind=goods_notify_item]', '#tbody_goods_notify').each(function (idx, obj) {
                    if (itemNo == $(this).attr('name')) {
                        $(this).data('prev_value', itemValue).val(itemValue);
                        return false;
                    }
                });
            }
            // 상품 고시 정보 취득
            function getGoodsNotifyValue($target, allDataFlag) {
                var returnData = []
                  , goodsNo = $('#hd_goodsNo').val();
                $target.each(function(idx) {
                    var value = ($(this).val() && $(this).val().trim().length > 0) ? $(this).val().trim() : ''
                      , prevValue = null != $(this).data('prev_value') ? $(this).data('prev_value') : ''; 
                    var data = {
                        goodsNo : goodsNo,
                        notifyNo : $(this).data("notify-no"),
                        itemNo : $(this).attr("name"),
                        itemNm : $(this).data("notify-nm"),
                        itemValue : value,
                        registFlag : prevValue !== value ? (prevValue !== '' && value === '') ? 'D':'U' : (prevValue !== '') ? 'L':'U',
                    };
                    if (allDataFlag || ('L' !== data['registFlag'] && value.length > 0)) {
                        returnData.push(data);
                    }
                });
                return returnData;
            }
            /*** 상품 고시정보 관련 - 끝 ***/ 

            
            /*** 이미지 정보 관련 - 시작 ***/
            /*** 6. 상품 이미지 설정 로딩 데이터 바인딩 ***/
            function loadGoodsImageSet(data) {
                if ('goodsImageSetList' in data && data['goodsImageSetList'].length > 0) {
                    var imageSetList = data['goodsImageSetList'];
                    // 기존 이미지 정보 삭제
                    $("tr.goods_image_set, tr.goods_image_set_btn", $("#tbody_goods_image_set")).remove();
                    $.each(imageSetList, function(idx, imgSetData){
                        imgSetData['idx'] = idx;
                        fn_addIamgeSetRow(imgSetData);
                        
                        var imgDtlList = imgSetData['goodsImageDtlList'];
                        
                        $.each(imgDtlList, function(idx2, imgDtlData){
                            // 기본 썸네일 이미지는 바인딩 안함
                            if ('01' === imgDtlData['goodsImgType']) {
                                return true;
                            }
                            
                            var data = {
                                    idx : idx2,
                                    src : imgDtlData['thumbUrl'],
                                    type : imgDtlData['goodsImgType'],
                                    goodsImgsetNo : imgSetData['goodsImgsetNo'],
                                    imgPath : imgDtlData['imgPath'],
                                    imgNm : imgDtlData['imgNm'],
                                    imgUrl : imgDtlData['imgUrl'],
                                    imageWidth :  imgDtlData['imgWidth'],
                                    imageHeight :  imgDtlData['imgHeight'],
                                    fileSize :  imgDtlData['imgSize'],
                                    registFlag : imgDtlData['registFlag'],
                                };
                            
                            $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + idx + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                            $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + idx + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                            
                        });
                    })
                }                
            }
            
            // 상품 이미지 세트 정보 취득
            function getGoodsImgSetValue($target, allDataFlag) {
                var returnData = [];
                var dlgtImgYnChk ="N";
                $target.each(function() {
                    var goodsImageDtlList = []
                      , $tr = $(this)
                      , $radio = $("input:radio", $(this))
                      , prevData = $tr.data('prev_data');
                    
                    $("img", $tr.find('td')).each(function(idx) {
                        var imgData = $(this).data("img_data");
                        if (!imgData) {
                            return true;
                        } 
                        
                        if ('tempFileName' in imgData && imgData.tempFileName) { 
                            var  data = {
                                goodsNo : $('#hd_goodsNo').val(),
                                goodsImgsetNo : (prevData && 'goodsImgsetNo' in prevData) ? prevData['goodsImgsetNo'] : null,
                                tempFileNm : (imgData.tempFileName) ? imgData.tempFileName : '',
                                imgPath : (imgData.tempFileName) ? imgData.tempFileName.split("_")[0] : '',
                                imgNm : (imgData.tempFileName) ? imgData.tempFileName.split("_")[1] + '_' +imgData.tempFileName.split("_")[2] : '',
                                goodsImgType : imgData.type,
                                imgWidth : imgData.imageWidth,
                                imgHeight : imgData.imageHeight,
                                imgSize : imgData.fileSize,
                                imgUrl : '${_IMAGE_DOMAIN}/image/preview?id=' + imgData.tempFileName,
                                registFlag : 'I',
                            };
                            
                            goodsImageDtlList.push(data);
                        }
                    });
                    var data = {};
                    if (allDataFlag && (prevData && goodsImageDtlList.length < 1)) {
                        data = prevData;

                    } else {
                        var data = {
                            goodsNo : $('#hd_goodsNo').val(),
                            goodsImgsetNo : (prevData && 'goodsImgsetNo' in prevData) ? prevData['goodsImgsetNo'] : null,
                            dlgtImgYn : $radio.is(':checked') ? "Y":"N",
                            registFlag :(prevData && 'registFlag' in prevData) ? prevData['registFlag'] : 'I',
                            goodsImageDtlList : goodsImageDtlList
                        }


                    }




                    if (prevData && 'L' === data['registFlag']) {
                        if (prevData['dlgtImgYn'] !== data['dlgtImgYn']){
                            data['registFlag'] = 'U'
                        }
                    }
                    if (allDataFlag || ('L' !== data['registFlag'] || goodsImageDtlList.length > 0)) {
                        returnData.push(data);
                    }
                });

                /*if(dlgtImgYnChk=="Y"){

                }else{
                    Dmall.LayerUtil.alert('대표 상품 이미지를 설정하세요.');
                    return false;
                }*/
                return returnData;
            }
            
            /***** 상품 이미지 등록관련 - 시작 *****/
            
            // 메인화면 이미지세트 추가 이벤트
            function fn_addIamgeSetRow(data) {

                var nextIdx = 0;
                $("tr.goods_image_set", $("#tbody_goods_image_set")).each(function() {
                    var setIdx = null != $(this).data("setIdx") ? parseInt($(this).data("setIdx")) : 0;
                    nextIdx = setIdx >= nextIdx ? setIdx + 1 : nextIdx;
                });
                
                var registFlag = (data && 'registFlag' in data) ? data['data.registFlag'] : 'I' 
                  , $tmpTr1 = $("#tr_goods_image_template_1").clone().show().removeAttr("id").addClass("goods_image_set").data("setIdx", nextIdx).attr("name", "tr_goods_image1_" + nextIdx)
                        .attr("id", "tr_goods_image1_" + nextIdx)
                        .data('prev_data', data)
                        .data('registFlag', registFlag) 
                  , $tmpTr2 = $("#tr_goods_image_template_2").clone().show().removeAttr("id").addClass("goods_image_set_btn").data("setIdx", nextIdx).attr("name", "tr_goods_image2_" + nextIdx)
                  , $btnDelRow = $('button[name="btn_add_goods_image_set"]', $tmpTr1).removeAttr("id").data("setIdx", nextIdx);
                

                  // 화면에 디폴트 이미지세트 ROW가 없을 경우
                  if ($("tr.goods_image_set", $("#tbody_goods_image_set")).length < 1) {
                      $btnDelRow.html("추가").off("click").on('click', function(e) {
                          Dmall.EventUtil.stopAnchorAction(e);
                          fn_addIamgeSetRow(null);
                          // 대표이미지 여부 디폴트 설정
                          if ($("tr.goods_image_set:visible", $("#tbody_goods_image_set")).find('input:radio:checked').length < 1) {
                              // $("tr.goods_image_set:visible", $("#tbody_goods_image_set")).find('label').eq(0).trigger('click');
                          }
                      });
                  // 추가 이미지세트 ROW 일 경우
                  } else {
                      $btnDelRow.html("삭제").off("click").on('click', function(e) {
                          Dmall.EventUtil.stopAnchorAction(e);
                          var setIdx = $(this).data("setIdx")
                            , $tr = $('tr[name="tr_goods_image1_' + setIdx + '"]', $("#tbody_goods_image_set"))
                            , prevData = $tr.data('prev_data');
                          
                          // 신규등록된 이미지의 경우

                          if (prevData && 'registFlag' in prevData) {
                              prevData['registFlag'] = 'D';
                              $tr.data('prev_data', prevData).hide();
                              $('tr[name="tr_goods_image1_' + setIdx + '"], tr[name="tr_goods_image2_' + setIdx + '"]', $("#tbody_goods_image_set")).hide();
                          } else {
                              $('tr[name="tr_goods_image1_' + setIdx + '"], tr[name="tr_goods_image2_' + setIdx + '"]', $("#tbody_goods_image_set")).remove();
                          }
                          
                          // 대표이미지 여부 디폴트 설정
                          if ($("tr.goods_image_set:visible", $("#tbody_goods_image_set")).find('input:radio:checked').length < 1) {
                              // $("tr.goods_image_set:visible", $("#tbody_goods_image_set")).find('label').eq(0).trigger('click');
                          }
                      });
                  }
                  if (null == data) {
                      data = {
                          registFlag : 'I',
                      };
                  } 
                  // 이미지세트 ROW 이벤트 바인딩 (이미지)
                  $('[data-bind="image_info"]', $tmpTr1).DataBinder(data);
                  // 이미지세트 ROW 이벤트 바인딩 (이미지등록, 미리보기)
                  $('[data-bind="image_info"]', $tmpTr2).DataBinder(data);
                  
                  $("#tbody_goods_image_set").append($tmpTr1).append($tmpTr2);
                  
                  if('Y' == data.dlgtImgYn) {
                      $('label', $tmpTr1).trigger('click');
                  } 
            }
            // 이미지 등록 버튼 클릭시 이벤트
            function setRegistImage(data, obj, bindName, target, area, row) {
                var kind = $(obj).data("bind-param-1");
                    type = $(obj).data("bind-param-2");                
                if ( type === data.type) {
                    $(obj).data("img_data", data);
                }
                
                $(obj).off("click").on('click', function(e) {                    
                    Dmall.EventUtil.stopAnchorAction(e);
                    var kind = $(this).data("bind-param-1") 
                      , type = $(this).data("bind-param-2");

                    // 업로드 팝업에 현재 선택된 버튼의 정보를 설정
                    $("#hd_img_param_1").val(kind);
                    $("#hd_img_param_2").data("kind", kind).data("type", type).data("setIdx", $(this).closest("tr").data("setIdx")).val(type);
                    Dmall.LayerPopupUtil.open(jQuery('#layer_upload_image'));
                });
            }
            // 이미지 미리보기 버튼 클릭시 이벤트
            function previewRegistImage(data, obj, bindName, target, area, row) {
                var type = $(obj).data("bind-param-2");
                if (data && type === data.type) {
                    $(obj).data("img_data", data);
                    $(obj).off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var imgData = $(this).data("img_data") 
                         , imgUrl = data['imgPath'] && data['imgPath'].length > 0 ? '${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=' + data['imgPath'] + '_' + data['imgNm'] : data['imgUrl'];
                         
                        $("#img_preview_goods_image").attr("src", imgUrl);                        
                        Dmall.LayerPopupUtil.open(jQuery('#layer_preview_upload_image'));
                    });
                }
            }
            // 업로드된 이미지 소스로 변경
            function setImageSrc(data, obj, bindName, target, area, row) {
                if ( !data.type || !data.src ) {
                    obj.data("img_data", null).attr("src", '/admin/img/product/tmp_img01.png');
                } else {
                    if ( obj.data("bind-param-2") == data.type ) {
                        obj.data("img_data", data).attr("src", _IMAGE_DOMAIN+data.src);
                    }
                }
            }
            // 상품 대표 이미지 라디오 버튼 바인딩
            function setDlgtImgYn(data, obj, bindName, target, area, row) {
                // 화면상에 표시된 요소로 라디오버튼의 ID를 생성
                var nextIdx = obj.parent('TR').data('setIdx');

                // 라벨 및 라디오 버튼에 생성된 ID적용
                var $label = $("label", obj).removeAttr("for").attr("for", "rdo_dlgtImgYn_" +nextIdx).data("img_set_idx", nextIdx)
                  , $input = $("input:radio", obj).removeAttr("id").attr("id", "rdo_dlgtImgYn_" +nextIdx).data("img_set_idx", nextIdx);
                
                // 라디오 버튼 클릭 이벤트 설정
                jQuery('label.radio', obj).off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    
                    var $this = $(this),
                        $input = jQuery("#" + $this.attr("for"));

                    $("input:radio[name=" + $input.attr("name") + "]").each(function() {
                        $(this).removeProp('checked');
                        $("label[for=" + $(this).attr("id") + "]").removeClass('on');
                    });
                    $input.prop('checked', true).trigger('change');
                    if ($input.prop('checked')) {
                        $this.addClass('on');
                    }
                });
            }
            /***** 상품 이미지 등록관련 - 끝 *****/
            /*** 이미지 정보 관련 - 끝 ***/ 
            
                
            // 상품등록 디폴트 화면 설정
            function fn_setDefault() {
                $("#tr_selected_ctg_template").hide();
                $("#tr_add_option_template").hide();
                
                // INPUT애서 Enter 키 입력 시 무효화(2016.10.25, 이동준 과장) 
                jQuery(document).on('keydown', 'input', function(e) {
                    if(e.keyCode == 13) {
                        Dmall.EventUtil.stopAnchorAction(e);
                    }
                });
                // 배송비 설정 라디오 클릭
                jQuery('label.radio', '#div_delivery_info').off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = $(this),
                        $input = jQuery("#" + $this.attr("for"));
                    $("input:radio[name=" + $input.attr("name") + "]").each(function() {
                        $(this).removeProp('checked');
                        $("label[for=" + $(this).attr("id") + "]").removeClass('on');
                    });
                    $input.prop('checked', true).trigger('change');
                    if ($input.prop('checked')) {
                        $this.addClass('on');
                    }
                    fn_set_radio_element();
                });
                
                jQuery('label.radio', '#tbody_add_option_set').off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = $(this),
                        $input = jQuery("#" + $this.attr("for"));
                    $("input:radio[name=" + $input.attr("name") + "]").each(function() {
                        $(this).removeProp('checked');
                        $("label[for=" + $(this).attr("id") + "]").removeClass('on');
                    });
                    $input.prop('checked', true).trigger('change');
                    if ($input.prop('checked')) {
                        $this.addClass('on');
                    }
                    fn_set_radio_add_option_element();
                });
                
                if ( $("#tbody_selected_ctg").find(".selectedCtg").length < 1 ) {
                    $("#tr_no_selected_ctg_template").show();
                } 
                
                // 디폴트 팝업 화면 표시
                $("#tr_item_template").hide();
                $("#tr_no_item_data").show();
                
                // 이미지 관련 디폴트 처리
                $("#tr_goods_image_template_1, #tr_goods_image_template_2, #li_relate_goods_template").hide();
                fn_addIamgeSetRow(null);
                // 대표이미지 여부 디폴트 설정
                if ($("tr.goods_image_set:visible", $("#tbody_goods_image_set")).find('input:radio:checked').length < 1) {
                    // $("tr.goods_image_set:visible", $("#tbody_goods_image_set")).find('label').eq(0).trigger('click');
                }
                // 추가옵션 디폴트 1row
                fn_addAddOptionRow();
            }
            
            // 라디오 버튼 선택값이 없을 경우 디폴트 선택 설정
            function setDefaultRadioValue(name) {
                var $radios = $('input:radio[name='+ name +']')
                  , $radio = $radios.filter(':visible:first');
                // if($radios.is(':checked') === false) {                    
                    $('label[for='+ $radio.attr('id') +']').trigger('click') ;
                // }
            }
            // 화면생성에 필요한 기본 정보 취득
            function getDefaultDisplayInfo(editMode) {
                // alert('editMode :' + editMode);
                var url = '/admin/goods/default-display-info'
                  , param = {'goodsNo' : $('#hd_goodsNo').val()}
                  , flag = 'Y' === editMode ? true : false;
                // //
                
                // 화면에 남아 있는 이전 정보 데이터 삭제
                $("#div_multi_option").data("opt_data", null).data("goods_item_info", null);
                // 옵션 새로 생성 여부
                $("#tb_goods_option").data("new_option_flag", false);
                // 옵션 불러오기 여부
                $("#tb_goods_option").data("load_option_flag", false);
                // 옵션 만들기 팝업 내용 삭제
                $("tr.goods_item","#tbody_goods_item").remove();
                $('#tr_no_goods_item').show();
                
                $('input:text, textarea').val('');
                $('input:radio').each(function(){
                    setDefaultRadioValue($(this).attr('name'));
                });
                $('input:checkbox').each(function(){
                    var $obj = $(this);
                    $obj.removeAttr('checked');
                    $('label[for=' + $obj.attr('id') + ']', $obj.parent()).removeClass('on'); 
                });
                $("li", $("div.list")).remove();
                
                $('[data-bind=disp_img_info]', '#tr_disp_img_1').DataBinder({});
                $('[data-bind=disp_img_info]', '#tr_disp_img_2').DataBinder({});
                
                // $('tr.selectedCtg', $('#tbody_selected_ctg')).remove();
                // $("#tr_no_selected_ctg_template").show();
                
                // 마켓포인트 사용제한 default 설정
                $('label[for=rdo_goods_svmn_max_use_policy_cd_03]').trigger('click') ;
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    // //
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 상품 이미지 정보(상품 상세 및 리스트 이미지 사이즈) 설정
                    // createGoodImgInfo(result.data);
                    
                    createAdultCertifyInfo(result.data);
                    
                    // 브랜드정보 취득결과 설정
                    createGoodsBrand(result.data.brandList, $("#sel_goods_brand"));
                    
                    // HS코드정보 취득결과 설정
                    createGoodsHscd(result.data.hscdList, $("#sel_goods_hscd"));
                 
                    // 아이콘정보 취득결과 설정
                    createGoodsIcon(result.data.goodsIconList, $("#td_icon_info"));

                    // 비전체크 군 취득결과 설정
                    var goodsTypeCd = "03";
                    if((result.data.gunList).length > 0){
                    	goodsTypeCd = result.data.gunList[0].goodsTypeCd;
                    }
                    createGoodsGun(result.data.gunList, goodsTypeCd);

                    // 최근등록 옵션 정보 취득결과 설정
                    createGoodsRecentOption(result.data.goodsOptionList, $("#sel_load_option"));
                    
                    // 고시정보 셀렉트 설정
                    createGoodsNotifyOption(result.data.notifyOptionList);
                    
                    // 고시정보 취득결과 설정
                    createGoodsNotify(result.data.goodsNotifyItemList);



                    if (true === flag) {
                        fn_getGoodsInfo($('#hd_goodsNo').val());
                    } else {
                        // 카테고리 정보 로드
                        getCategoryInfo('1', jQuery('#ul_ctg_1'), '', $('#ul_ctg_1').data('ctgNo'));

                        // 이미지세트 ROW 이벤트 바인딩 (이미지)
                        // $('[data-bind=disp_img_info]', $('#tbody_disp_img')).DataBinder({});
                    }

					// QR CODE 다운로드 이미지 사이즈 default setting
					$('#qrcodeWidth').val("100");
					$('#qrcodeHeight').val("100");
                    
                });
            }
            // 상품 이미지 정보 설정
            /*
            function createGoodImgInfo(data) {
                var goodsDefaultImgWidth = 'goodsDefaultImgWidth' in data && data['goodsDefaultImgWidth'] ? data['goodsDefaultImgWidth'] : 240
                  , goodsDefaultImgHeight = 'goodsDefaultImgHeight' in data && data['goodsDefaultImgHeight'] ? data['goodsDefaultImgHeight'] : 240
                  , goodsListImgWidth = 'goodsListImgWidth' in data && data['goodsListImgWidth'] ? data['goodsListImgWidth'] : 90
                  , goodsListImgHeight = 'goodsListImgHeight' in data && data['goodsListImgHeight'] ? data['goodsListImgHeight'] : 90;
                  
                $('#hd_img_detail_width, #txt_goodsDefaultImgWidth').val(goodsDefaultImgWidth);
                $('#hd_img_detail_height, #txt_goodsDefaultImgHeight').val(goodsDefaultImgHeight);
                $('#hd_img_thumb_width, #txt_goodsListImgWidth').val(goodsListImgWidth);
                $('#hd_img_thumb_height, #txt_goodsListImgHeight').val(goodsListImgHeight);
                
                $('#hd_img_width_disp_type_a').val(goodsListImgWidth);
                $('#hd_img_height_disp_type_a').val(goodsListImgHeight);
                $('#hd_img_width_disp_type_b').val(goodsListImgWidth);
                $('#hd_img_height_disp_type_b').val(goodsListImgHeight);
                $('#hd_img_width_disp_type_c').val(goodsListImgWidth);
                $('#hd_img_height_disp_type_c').val(goodsListImgHeight);
                $('#hd_img_width_disp_type_d').val(goodsListImgWidth);
                $('#hd_img_height_disp_type_d').val(goodsListImgHeight);
                $('#hd_img_width_disp_type_e').val(goodsListImgWidth);
                $('#hd_img_height_disp_type_e').val(goodsListImgHeight);
                
                // [삭제 08.24]
                // $('#th_image_size_detail').html(goodsDefaultImgWidth + '*' + goodsDefaultImgHeight);
                // $('#th_image_size_list').html(goodsListImgWidth + '*' + goodsListImgHeight);
            }
            */
            
            // 사이트 성인 인증 설정 여부 설정
            function createAdultCertifyInfo(data) {
                var isAdultCertifyConfig = 'isAdultCertifyConfig' in data && data['isAdultCertifyConfig'] ? data['isAdultCertifyConfig'] : 'N';
                  
                $('#chk_goods_adult_yn').data('isAdultCertifyConfig', isAdultCertifyConfig);
            }            
            
            // 브랜드정보 셀렉트 설정
            function createGoodsBrand(list, $sel) {
                $sel.find('option').not(':first').remove();
                $('label', $sel.parent()).text( $sel.find("option:first").text() );
                
                var sortData = list;
                sortData.sort(function(a,b){
                	return (a.brandNm < b.brandNm) ? -1 : (a.brandNm > b.brandNm) ? 1 : 0;
                });
                
                jQuery.each(sortData, function(idx, obj) {
                    $sel.append('<option value="'+ obj.brandNo + '">' + obj.brandNm + '</option>');
                });               
            }
            
            // HS코드정보 셀렉트 설정
            function createGoodsHscd(list, $sel) {
                $sel.find('option').not(':first').remove();
                $('label', $sel.parent()).text( $sel.find("option:first").text() );
                
                jQuery.each(list, function(idx, obj) {
                    $sel.append('<option value="'+ obj.hscd + '">' + obj.item + '</option>');
                });               
            }
            
            // 최근 옵션정보 셀렉트 설정
            function createGoodsRecentOption(list, $sel) {
                $sel.find('option').not(':first').remove();
                $('label', $sel.parent()).text( $sel.find("option:first").text() );
                
                jQuery.each(list, function(idx, obj) {
                    if(obj.regSeq && obj.regSeq > 0) {
                        $sel.append('<option value="'+ obj.regSeq + '">' + obj.optGrpNm + '</option>');
                    }
                });               
            }
            
            // 고시정보 셀렉트 설정
            function createGoodsNotifyOption(optList) {
                var $sel = $("#sel_goods_notify");
                $sel.find('option').remove();
                
                jQuery.each(optList, function(idx, obj) {
                    $sel.append('<option id="notify_' + idx +'" value="'+ obj.notifyNo + '">' + obj.notifyNm + '</option>');
                });
                $("#lb_goods_notify").html($("option:first", $sel).attr("selected", "true").text());                
            }

            // 상품 목록에 따른 고시정보 항목 목록 취득
            function getGoodsNotifyList(notifyNo, goodsNotifyList) {
                var url = '/admin/goods/goods-notify-item',
                    param = {'notifyNo' : notifyNo};
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    createGoodsNotify(result.resultList);
                    
                    $.each(goodsNotifyList, function(idx, data) {
                        setGoodsNotifyInfo(data);
                    });
                    
                });               
            }
            // 고시정보 항목의 목록으로 고시정보 표시부 생성
            function createGoodsNotify(list) {
                // 이전 표시내용 삭제
                $("tr.goods_notify", $("#tbody_goods_notify")).remove();
                jQuery.each(list, function(idx, obj) {
                    var html = '<td class="line goods_notify">' + obj.itemNm; 
                    html = (null == obj.dscrt ) ? html: html + "(" + obj.dscrt + ")";
                    html = html + '</td><td class="goods_notify"><span class="intxt wid100p">'
                     + '<input type="text" id="txt_goodsNotifyItem'+ obj.itemNo 
                     +'" data-notify-no="' + obj.notifyNo +'" data-notify-nm="' + obj.itemNm +'" name="' + obj.itemNo +'" data-bind="goods_notify_item" data-bind-value="saleStartDt" data-validation-engine="validate[required, maxSize[200]]" /></span></td>';
                     // 첫번째 tr의 내용은 별도 처리
                    if ( idx < 1) {
                        var $trNotify0 = $("#tr_goods_notify_0");
                        $("td.goods_notify", $trNotify0).remove();
                        $trNotify0.append(html);
                     // 이하 고시정보 tr 생성 
                    } else {
                        $("#tbody_goods_notify").append('<tr class="goods_notify">' + html + '</tr>');
                    }
                });
            }   
            
            /***** 미리 정보 취득 - 시작 *****/
            function fn_getGoodsPreviewData() {
                var goodsBasicData = getGoodsBasicValue($("tr[data-bind=basic_info]", "#tb_goods_basic_info"), true);
                goodsBasicData['goodsNo'] = $('#hd_goodsNo').val();
                
                // 단일옵션, 다중 옵션에 따른 분기 
                if("N" === $("#hd_multiOptYn").val()) {                    
                    // 단일 옵션 정보 취득
                    getGoodsSimpleSaleValue($("tr[data-bind=sale_info]", "#div_simple_option"), goodsBasicData, true);
                } else {
                    // 다중 옵션 정보 취득
                    getGoodsMultiSaleValue($("#div_multi_option"), goodsBasicData, true);
                }
                // 상품 배송 설정 정보 취득
                getGoodDeliveryValue($("tr[data-bind=delivery_info]", "#tbody_goods_delivery"), goodsBasicData, true);
                
                // 관련 상품 정보 취득
                getGoodsRelateSetValue($("tr", "#tbody_relate_goods"), goodsBasicData, true);

                // 카테고리 정보 취득
                goodsBasicData['goodsCtgList'] = getGoodsCategoryValue($("tr.selectedCtg", "#tbody_selected_ctg"), true);

                // 추가 옵션 정보 취득
                if ( $("input:radio[data-bind=addOptUseYn]:checked").val() === 'Y') { 
                    goodsBasicData['goodsAddOptionList']  = getGoodsAddOptionValue($("tr.add_option", "#tbody_add_option"), true);
                }
                
                // 이미지 정보 취득
                goodsBasicData['goodsImageSetList'] = getGoodsImgSetValue($("tr.goods_image_set", "#tbody_goods_image_set"), true);

                // 상품 고시 정보 취득
                goodsBasicData['goodsNotifyList'] = getGoodsNotifyValue($("input[data-bind=goods_notify_item]", "#tbody_goods_notify"), true);

                return goodsBasicData;
            }
                
            /***** 상품 등록 정보 취득 - 시작 *****/
            function fn_getGoodsRegistData() {
                var goodsBasicData = getGoodsBasicValue($("tr[data-bind=basic_info]", "#tb_goods_basic_info"));
                
                goodsBasicData['goodsNo'] = $('#hd_goodsNo').val();                

                // 단일옵션, 다중 옵션에 따른 분기 
                if("N" === $("#hd_multiOptYn").val()) {                    
                    // 단일 옵션 정보 취득
                    getGoodsSimpleSaleValue($("tr[data-bind=sale_info]", "#div_simple_option"), goodsBasicData);
                    // 다비젼 상품코드가 보이는 경우만 값 설정
                    if($("#txt_erp_itm_code").closest("tr").css("display") != "none") {
	                    goodsBasicData['erpItmCode'] = $("#txt_erp_itm_code").val();
                    }
                } else {
                    // 다중 옵션 정보 취득
                    getGoodsMultiSaleValue($("#div_multi_option"), goodsBasicData);
                }
                // 상품 배송 설정 정보 취득
                getGoodDeliveryValue($("tr[data-bind=delivery_info]", "#tbody_goods_delivery"), goodsBasicData);
                
                // 관련 상품 정보 취득
                getGoodsRelateSetValue($("tr", "#tbody_relate_goods"), goodsBasicData);

                // 카테고리 정보 취득
                goodsBasicData['goodsCtgList'] = getGoodsCategoryValue($("tr.selectedCtg", "#tbody_selected_ctg"));

                // 추가 옵션 정보 취득
                if ( $("input:radio[data-bind=addOptUseYn]:checked").val() === 'Y') { 
                    goodsBasicData['goodsAddOptionList']  = getGoodsAddOptionValue($("tr.add_option", "#tbody_add_option"));
                }
                
                // 이미지 정보 취득
                goodsBasicData['goodsImageSetList'] = getGoodsImgSetValue($("tr.goods_image_set", "#tbody_goods_image_set"));

                // 상품 고시 정보 취득
                goodsBasicData['goodsNotifyList'] = getGoodsNotifyValue($("input[data-bind=goods_notify_item]", "#tbody_goods_notify"));

                return goodsBasicData;
            }
            
            // -2- 상품 기본 정보 취득
            function getGoodsBasicValue($target, allDataFlag) {
                var returnData = {};

                getInputDataValue(returnData, $("[name=goodsContsGbCd]"),$("[name=goodsContsGbCd]").val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=goodsNo]", $target), $("[data-bind-value=goodsNo]", $target).val(), allDataFlag);

                //상품유형 별 속성 정보
                getInputDataValue(returnData, $("[name=goodsTypeCd]"),$("[name=goodsTypeCd]").val(), allDataFlag);

                //안경테
                getInputDataValue(returnData, $("[name=frameShapeCd]"),$("[name=frameShapeCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=frameMaterialCd]"),$("[name=frameMaterialCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=frameSizeCd]"),$("[name=frameSizeCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=frameColorCd]"),$("[name=frameColorCd]:checked").val(), allDataFlag);

                //선글라스
                getInputDataValue(returnData, $("[name=sunglassShapeCd]"),$("[name=sunglassShapeCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=sunglassMaterialCd]"),$("[name=sunglassMaterialCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=sunglassSizeCd]"),$("[name=sunglassSizeCd]:checked").val(), allDataFlag);

                getInputDataValue(returnData, $("[name=sunglassColorCd]"),$("[name=sunglassColorCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=sunglassEyeTopColorCd]"),$("[name=sunglassEyeTopColorCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=sunglassEyeMetalColorCd]"),$("[name=sunglassEyeMetalColorCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=sunglassTempleMetalColorCd]"),$("[name=sunglassTempleMetalColorCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=sunglassTempleEpoxyColorCd]"),$("[name=sunglassTempleEpoxyColorCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=sunglassTipColorCd]"),$("[name=sunglassTipColorCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=sunglassLensColorCd]"),$("[name=sunglassLensColorCd]:checked").val(), allDataFlag);
                //안경렌즈
                /* getInputDataValue(returnData, $("[name=glassUsageCd]"),$("[name=glassUsageCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=glassColorCd]"),$("[name=glassColorCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=glassFocusCd]"),$("[name=glassFocusCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=glassFunctionCd]"),$("[name=glassFunctionCd]:checked").val(), allDataFlag); */
                getInputDataValue(returnData, $("[name=glassMmftCd]"),$("[name=glassMmftCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=glassThickCd]"),$("[name=glassThickCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=glassDesignCd]"),$("[name=glassDesignCd]:checked").val(), allDataFlag);

                //콘택트랜즈
                getInputDataValue(returnData, $("[name=contactColorCd]"),$("[name=contactColorCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=contactCycleCd]"),$("[name=contactCycleCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=contactMaterialCd]"),$("[name=contactMaterialCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=contactFocusCd]"),$("[name=contactFocusCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=contactSizeCd]"),$("[name=contactSizeCd]:checked").val(), allDataFlag);

                getInputDataValue(returnData, $("input:checkbox.gunNo", $target), $("input:checkbox.gunNo", $target).val(), allDataFlag);

                //보청기
                getInputDataValue(returnData, $("[name=aidShapeCd]"),$("[name=aidShapeCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=aidLosstypeCd]"),$("[name=aidLosstypeCd]:checked").val(), allDataFlag);
                getInputDataValue(returnData, $("[name=aidLossdegreeCd]"),$("[name=aidLossdegreeCd]:checked").val(), allDataFlag);


                getInputDataValue(returnData, $("[data-bind-value=sellerNo]", $target), $("select[data-bind-value=sellerNo] option:selected", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=sellerNm]", $target), $("select[data-bind-value=sellerNo] option:selected", $target).text(), allDataFlag);

                getInputDataValue(returnData, $("[data-bind-value=itemNo]", $target), $("[data-bind-value=itemNo]", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=goodsNm]", $target), $("[data-bind-value=goodsNm]", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=virtOutingYn]", $target), $("[data-bind-value=virtOutingYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);

                getInputDataValue(returnData, $("[data-bind-value=smrGoodsNm]", $target), $("[data-bind-value=smrGoodsNm]", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=prWords]", $target), $("[data-bind-value=prWords]", $target).val(), allDataFlag);
                
                //getInputDataValue(returnData, $("[data-bind=goodsSaleStatusCd]", $target), $("input:radio[data-bind=goodsSaleStatusCd]:checked", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[name=goodsSaleStatusCd]"),$("[name=goodsSaleStatusCd]").val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=rsvOnlyYn]", $target), $("[data-bind-value=rsvOnlyYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=reinwareApplyYn]", $target), $("[data-bind-value=reinwareApplyYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);
                
                getInputDataValue(returnData, $("[data-bind=dispYn]", $target), $("input:radio[data-bind=dispYn]:checked", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=taxGbCd]", $target), $("input:radio[data-bind=taxGbCd]:checked", $target).val(), allDataFlag);

                getInputDataValue(returnData, $("[data-bind-value=adultCertifyYn]", $target), $("[data-bind-value=adultCertifyYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=brandNo]", $target), $("select[data-bind-value=brandNo] option:selected", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=brandNm]", $target), $("select[data-bind-value=brandNo] option:selected", $target).text(), allDataFlag);
                
                getInputDataValue(returnData, $("input:checkbox.goodsIcon", $target), $("input:checkbox.goodsIcon", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=returnPsbYn]", $target), $("input:radio[data-bind=returnPsbYn]:checked", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=minOrdLimitYn]", $target), $("input:radio[data-bind=minOrdLimitYn]:checked", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=maxOrdLimitYn]", $target), $("input:radio[data-bind=maxOrdLimitYn]:checked", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=goodsSvmnPolicyUseYn]", $target), $("input:radio[data-bind=goodsSvmnPolicyUseYn]:checked", $target).val(), allDataFlag);
                
                getInputDataValue(returnData, $("[data-bind=goodsSvmnPolicyCd]", $target), $("input:radio[data-bind=goodsSvmnPolicyCd]:checked", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=goodsSvmnGbCd]", $target), $("input:radio[data-bind=goodsSvmnGbCd]:checked", $target).val(), allDataFlag);
                
                //getInputDataValue(returnData, $("[data-bind-value=goodsSvmnAmt]", $target), $("[data-bind-value=goodsSvmnAmt]", $target).val(), allDataFlag);
                
                getInputDataValue(returnData, $("[data-bind=goodsSvmnMaxUsePolicyCd]", $target), $("input:radio[data-bind=goodsSvmnMaxUsePolicyCd]:checked", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=goodsSvmnMaxUseRate]", $target), $("[data-bind-value=goodsSvmnMaxUseRate]", $target).val(), allDataFlag);
                
                getInputDataValue(returnData, $("[data-bind-value=recomPvdRate]", $target), $("[data-bind-value=recomPvdRate]", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=recomPvdPolicyCd]", $target), $("input:radio[data-bind=recomPvdPolicyCd]:checked", $target).val(), allDataFlag);
                
                // getInputDataValue(returnData, $("[data-bind-value=hscode]", $target), $("[data-bind-value=hscode]", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=hscode]", $target), $("select[data-bind-value=hscode] option:selected", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=seoSearchWord]", $target), $("[data-bind-value=seoSearchWord]", $target).val(), allDataFlag);
                
                getInputDataValue(returnData, $("#hd_multiOptYn"), $("#hd_multiOptYn").val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=mmft]", $target), $("[data-bind-value=mmft]", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=habitat]", $target), $("[data-bind-value=habitat]", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=addOptUseYn]"), $("input:radio[data-bind=addOptUseYn]:checked").val(), allDataFlag);
                // 고시 정보 타입 설정
                getInputDataValue(returnData, $("[data-bind-value=notifyNo]", $('#tbody_goods_notify')), $("select[data-bind-value=notifyNo] option:selected", $('#tbody_goods_notify')).val(), allDataFlag);
                getInputDataValue(returnData, $("#hd_prev_goods_notify"), $("#sel_goods_notify").data('prev_value'), allDataFlag);
                
                
                // 상품 동영상 정보 
                // getInputDataValue(returnData, $("[data-bind-value=videoSourcePath]", '#tb_goods_video'), $("[data-bind-value=videoSourcePath]", '#tb_goods_video').val(), allDataFlag);
                
                
                // 상품 이미지 세트 정보 취득
                $("img", '#tr_disp_img_1').each(function(idx) {
                    var imgData = $(this).data("img_data");
                    if (!imgData || '01' === imgData.type) {
                        return true;
                    }
                    var  data = {};
                    if ('tempFileName' in imgData && imgData.tempFileName) { 
                        data = {
                            imgPath : (imgData.tempFileName) ? imgData.tempFileName.split("_")[0] : '',
                            imgNm : (imgData.tempFileName) ? imgData.tempFileName.split("_")[1] + '_' +imgData.tempFileName.split("_")[2] : '',
                            type : imgData.type,
                            imgWidth : imgData.imageWidth,
                            imgHeight : imgData.imageHeight,
                            fileSize :  imgData.fileSize,
                            tempFileName : (imgData.tempFileName) ? imgData.tempFileName : '',
                        };
                    } else {
                        data = imgData;
                        data.tempFileName = ''; 
                    }
                    
                    var key1 =  'dispImgPathType' + data.type
                      , key2 =  'dispImgNmType' + data.type
                      , key3 =  'dispTempFileNameType' + data.type
                      , key4 =  'dispImgFileSizeType' + data.type;

                    returnData[key1] = data.imgPath;
                    returnData[key2] = data.imgNm;
                    returnData[key3] = data.tempFileName;
                    returnData[key4] = data.fileSize;
                });

                return returnData;
            }
            
            function getInputDataValue(data, $target, value, allDataFlag) {
                var _name = $target.attr("name")
                  , $target_parent = $("tr[data-bind=basic_info]", "#tb_goods_basic_info");

                
                if ("goodsIcon" === _name) {
                    var goodsIconData = [];
                    // 아이콘 체크 박스의 값이 이전과 다를 경우에만 저장 데이터에 설정
                    $target.each(function (idx) {
                        if (allDataFlag || $(this).data('prev_value') != ($(this).prop('checked') ? "Y" : "N")) {
                            var iconData = {
                                "goodsNo": $('#hd_goodsNo').val(),
                                "iconNo": $(this).data("icon_no"),
                                "useYn": $(this).prop('checked') ? "Y" : "N"
                            };
                            goodsIconData.push(iconData);
                        }
                    });
                    data['goodsIconList'] = goodsIconData;
                } else if ("frameColorCd" === _name || "sunglassColorCd" === _name || "glassColorCd" === _name || "contactColorCd" === _name) {
                    var goodsColorData = "";
                    //  체크 박스의 값이 이전과 다를 경우에만 저장 데이터에 설정
                    var _chkLen = $("[name="+_name+"]:checked").length;
                    var i = 1;
                    $target.each(function (idx) {
                        if ($(this).prop('checked')) {
                            var colorData = $(this).val();
                            goodsColorData +=colorData;
                            if(_chkLen > i){
                                goodsColorData +=",";
                            }
                            i++;
                        }
                    });
                    data[_name] = goodsColorData;
                } else if ("minOrdLimitYn" === _name && "Y" === value) {
                    data[_name] = value;
                    getInputDataValue(data, $("[data-bind-value=minOrdQtt]", $target_parent), $("[data-bind-value=minOrdQtt]", $target_parent).val(), allDataFlag);
                } else if ("maxOrdLimitYn" === _name && "Y" === value) {
                    data[_name] = value;
                    getInputDataValue(data, $("[data-bind-value=maxOrdQtt]", $target_parent), $("[data-bind-value=maxOrdQtt]", $target_parent).val(), allDataFlag);
                } else if ("goodsSvmnPolicyCd" === _name && "04" === value) {
                     data[_name] = value;
                     getInputDataValue(data, $("[data-bind-value=goodsSvmnAmt]", $target_parent), $("[data-bind-value=goodsSvmnAmt]", $target_parent).val(), allDataFlag);
                } else if ("gunNo" === _name) {
                     var gunNoData = [];
                     var goodsTypeCd = $('#goodsTypeCd').val();

                     $('#gun_list_'+goodsTypeCd).find('input[type=checkbox]').each(function(){
                        if($(this).siblings('label').hasClass('on')) {
                            var gunData = {
                                "goodsNo": $('#hd_goodsNo').val(),
                                "gunNo": $(this).val()
                            };
                            gunNoData.push(gunData);
                        }
                    });
                    data['gunList'] = gunNoData;
                } else {
                    if ($target.hasClass('comma')) {
                        data[_name] = null == value? 0 : value.trim().replaceAll(',', '');
                    } else {

                        data[_name] = value;
                    } 
                }
            }
            
            // -6- 상품 배송정보 취득
            function getGoodDeliveryValue($target, returnData, allDataFlag) {
                getInputDataValue(returnData, $("[data-bind-value=dlvrExpectDays]", $target), $("[data-bind-value=dlvrExpectDays]", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind=dlvrSetCd]", $target), $("input:radio[data-bind=dlvrSetCd]:checked", $target).val(), allDataFlag);
                if ("3" == returnData.dlvrSetCd) {
                    getInputDataValue(returnData, $("[data-bind-value=goodseachDlvrc]", $target), $("[data-bind-value=goodseachDlvrc]", $target).val(), allDataFlag);
                } else if("4" == returnData.dlvrSetCd) {
                    getInputDataValue(returnData, $("[data-bind-value=packMaxUnit]", $target), $("[data-bind-value=packMaxUnit]", $target).val(), allDataFlag);
                    getInputDataValue(returnData, $("[data-bind-value=packUnitDlvrc]", $target), $("[data-bind-value=packUnitDlvrc]", $target).val(), allDataFlag);
                } else if("6" == returnData.dlvrSetCd) {
                    getInputDataValue(returnData, $("[data-bind-value=goodseachcndtaddDlvrc]", $target), $("[data-bind-value=goodseachcndtaddDlvrc]", $target).val(), allDataFlag);
                    getInputDataValue(returnData, $("[data-bind-value=freeDlvrMinAmt]", $target), $("[data-bind-value=freeDlvrMinAmt]", $target).val(), allDataFlag);
                }
                getInputDataValue(returnData, $("[data-bind-value=couriDlvrApplyYn]", $target), $("[data-bind-value=couriDlvrApplyYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=postDlvrApplyYn]", $target), $("[data-bind-value=postDlvrApplyYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=quicksvcDlvrApplyYn]", $target), $("[data-bind-value=quicksvcDlvrApplyYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=directRecptApplyYn]", $target), $("[data-bind-value=directRecptApplyYn]", $target).prop('checked') ? "Y" : "N", allDataFlag);
                getInputDataValue(returnData, $("[data-bind=dlvrPaymentKindCd]", $target), $("input:radio[data-bind=dlvrPaymentKindCd]:checked", $target).val(), allDataFlag);
                getInputDataValue(returnData, $("[data-bind-value=txLimitCndt]", $target), $("[data-bind-value=txLimitCndt]", $target).val());
            }

            // -7- 관련상품 정보 취득
            function getGoodsRelateSetValue($target, returnData, allDataFlag) {
                returnData['relateGoodsApplyTypeCd'] = $('input:radio[name=relateGoodsApplyTypeCd]:checked', '#tbody_relate_goods').val();
                
                switch(returnData.relateGoodsApplyTypeCd) {
                    case '1' :
                        var data = $('#div_display_relate_goods_condition').data('conditionData');
                        if (data) {
                            returnData['relectsSelCtg1'] = data['relectsSelCtg1'];
                            returnData['relectsSelCtg2'] = data['relectsSelCtg2'];
                            returnData['relectsSelCtg3'] = data['relectsSelCtg3'];
                            returnData['relectsSelCtg4'] = data['relectsSelCtg4'];
                            returnData['relateGoodsApplyCtg'] = data['relateGoodsApplyCtg'];
                            returnData['relateGoodsSalePriceStart'] = data['relateGoodsSalePriceStart'];
                            returnData['relateGoodsSalePriceEnd'] = data['relateGoodsSalePriceEnd'];
                            returnData['relateGoodsSaleStatusCd'] = data['relateGoodsSaleStatusCd'];
                            returnData['relateGoodsDispStatusCd'] = data['relateGoodsDispStatusCd'];
                            returnData['relateGoodsAutoExpsSortCd'] = data['relateGoodsAutoExpsSortCd'];
                            returnData['registFlag'] = data['registFlag'];
                        }
                        break;
                        
                    case '2' :
                        var relateGoodsList = [];
                        $('li.relate_goods', '#ul_relate_goods').each(function(idx, obj) {
                            var goodData = $(obj).data('goods_info')
                              , registFlag = $(obj).data('registFlag');
                            

                            // 상품 미리보기의 경우 삭제된 상품은 정보 취득시 제외.
                            if ((allDataFlag && 'D' !== registFlag) || !allDataFlag) {
                                var data = {
                                    'goodsNo' : $('#hd_goodsNo').val(),
                                    'relateGoodsNo' : goodData['goodsNo'],
                                    'eachRegSetYn' : ('eachRegSetYn' in goodData && goodData['eachRegSetYn']) ? goodData['eachRegSetYn'] : 'N',
                                    'registFlag' : registFlag,
                                    'priorRank' : idx+1,
                                };
                                relateGoodsList.push(data);
                            }
                        });
                        returnData['relateGoodsList'] = relateGoodsList;
                        break;
                    default :
                        break;
                    
                }
                return returnData;
            }
            /***** 관련 등록 정보 취득 - 끝   *****/
            
            /***** 관련 상품 설정 - 시작 *****/
            
            // 하위 카테고리 정보 취득 - 관련상품 조건 설정 팝업
            function getCategoryOptionValue(ctgLvl, $sel, upCtgNo, selectedValue) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl};
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    // //
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        if (selectedValue && selectedValue === obj.ctgNo) {
                            $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '" selected>' + obj.ctgNm + '</option>');
                        } else {
                            $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');   
                        }
                    });
                });
            }
            // 상위 카테고리 설정에 따른 하위 카테고리 옵션값 변경 - 관련상품 조건 설정 팝업
            function changeCategoryOptionValue(level, $target) {
                var $sel = $('#sel_relate_ctg_' + level), 
                    $label = $('label[for=sel_relate_ctg_' + level + ']', '#td_relate_goods_select_ctg');
                
                $sel.find('option').not(':first').remove();
                $label.text( $sel.find("option:first").text() );

                if ( level && level == '2' && $target.attr('id') == 'sel_relate_ctg_1') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '3' && $target.attr('id') == 'sel_relate_ctg_2') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '4' && $target.attr('id') == 'sel_relate_ctg_3') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else {

                }
            }
                
            // 관련 상품 설정
            function fn_callback_pop_apply_goods(data) {
                // alert('상품 선택 팝업 리턴 결과 :' + data["goodsNo"] + ', data :' + JSON.stringify(data));
                
                // 상품 정보 li 생성
                var goodsNo = data.goodsNo
                  , isExist = false;
                if (goodsNo === $('#hd_goodsNo').val()) {
                    Dmall.LayerUtil.alert('상품 자신은 관련상품으로 등록할 수 없습니다.');
                    return;
                }
                $('li.relate_goods', '#ul_relate_goods').each(function() {
                    var $this = $(this);
                    // 이전에 선택되었던 관련상품은 삭제한다.(로직상 기존 정보 삭제후 재등록)
                    if (goodsNo ===  $this.data("goods_info").goodsNo) {
                        isExist = true;
                        return false;
                    }
                });
                if (true === isExist) {
                    Dmall.LayerUtil.alert('이미 선택된 상품 입니다.');
                    return;
                }
                var $tmpli = $("#li_relate_goods_template").clone().show().removeAttr("id").addClass("relate_goods").data("registFlag", 'I').data("goods_info", data);
                // 검색결과 바인딩
                data['relateGoodsImg'] = data.goodsImg01;
                
                $('[data-bind="relate_goods"]', $tmpli).DataBinder(data);
                // 생성된 li 추가
                $('#ul_relate_goods').append($tmpli);
            }
            // 상품선택 팝업에서 넘어온 상품 이미지 바인딩
            function setRelateImage(data, obj, bindName, target, area, row) {
                // 상품 선택에서 넘어오는 이미지
                var imgUrl = ('relateGoodsImg' in data && data.relateGoodsImg) ? data.relateGoodsImg : ('goodsImg01' in data && data.goodsImg01) ? data.goodsImg01 : '/admin/img/product/tmp_img01.png';
                $("img", obj).attr("src", imgUrl);
            }
            // 상품선택 팝업에서 넘어온 상품 정보 바인딩
            function setRelateInfo(data, obj, bindName, target, area, row) {
                obj.html(data.goodsNm + " <br> " + parseInt(data.salePrice).getCommaNumber());
            }
            // 상호등록 버튼 클릭 이벤트 바인딩
            function setRelateBtn(data, obj, bindName, target, area, row) {
                // 상호등록 이벤트 설정
                $("button", obj).data("goods_info", data).off("click").on('click', function(e) {                    
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = $(this)
                      , $li = obj.closest('li'); 
                    
                    if ($this.hasClass('on')) {
                        $li.data('goods_info')['eachRegSetYn'] = 'N';
                        $li.data('registFlag', $li.data('registFlagOld'));
                        $(this).removeClass('on');
                    } else {
                        $li.data('goods_info')['eachRegSetYn'] = 'Y';
                        $li.data('registFlagOld', $li.data('registFlag')).data('registFlag', 'U');
                        $(this).addClass('on');
                    }
                    
                });
            }            
            // 관련상품 삭제 버튼 클릭 이벤트 바인딩
            function setRelateCancelBtn(data, obj, bindName, target, area, row) {
                obj.data("goods_info", data).off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $li = obj.closest('li');
                    if ( 'I' === $li.data('registFlag') ) {
                        $li.remove();
                    } else {
                        $li.data('registFlag', 'D');
                        $li.find('.btn_gray3').hide();
                        $li.css('opacity','0.5');
                    }
                });
            }
            
            /***** 관련 상품 설정 - 끝 *****/
            
            function fn_loadEditor() {
                Dmall.DaumEditor.init(); // 에디터 초기화 함수,
                Dmall.DaumEditor.create('ta_goods_content'); // Textarea를 에디터로 설정
                Dmall.DaumEditor.create('ta_mobile_content'); // Textarea를 에디터로 설정
                
                if ('Y' === '${resultModel.data.editModeYn}') {
                    getEditorDataInfo();
                }
            }
            
            function getEditorDataInfo() {
                Dmall.AjaxUtil.getJSON('/admin/goods/goods-contents', {'goodsNo':$('#hd_goodsNo').val(), 'svcGbCd':'01'}, function(result) {

                    if (result.data) {
                        Dmall.DaumEditor.setContent('ta_goods_content', result.data.content); // 에디터에 데이터 세팅
                        Dmall.DaumEditor.setAttachedImage('ta_goods_content', result.data.attachImages[0]); // 에디터에 첨부 이미지 데이터 세팅

                        Dmall.DaumEditor.setContent('ta_mobile_content', result.data.mobileContent); // 에디터에 데이터 세팅
                        Dmall.DaumEditor.setAttachedImage('ta_mobile_content', result.data.attachImages[1]); // 에디터에 첨부 이미지 데이터 세팅
                    }
                })
            }
            
            function qrcode_download() {
            	if($('#qrcodeWidth').val() == '' || $('#qrcodeHeight').val() == ''){
            		alert("사이즈를 지정해주세요.");
            		return false;
            	}
            	var div = document.createElement("div");
            	$(div).qrcode({
        	        width: $('#qrcodeWidth').val(),
        	        height: $('#qrcodeHeight').val(),
        	        text: "http://davichmarket.com/m/front/qrcode?goodsNo=${resultModel.data.goodsNo}"
        		});
            	var canvas = $(div).find("canvas");
            	var img = canvas.get(0).toDataURL("image/png");
    			var link = document.createElement("a");

				link.download = "${resultModel.data.goodsNo}_QRCODE.png";
				link.href = img;
				document.body.appendChild(link);
				link.click();
				document.body.removeChild(link);
				delete link;
            }
            
            // 옵션 만들기 팝업위에 옵션 생성 및 변경 팝업(2중 팝업) 설정을 위해 별도 구현
            GoodsLayerPopupUtil = {
                open : function($popup) {
                    var left = ( $(window).scrollLeft() + ($(window).width() - $popup.width()) / 2 ),
                        top = ( $(window).scrollTop() + ($(window).height() - $popup.height()) / 2 );
                    $popup.fadeIn();
                    $popup.css({top: top, left: left});
                    $popup.prepend('<div class="dimmed2"></div>');
                    $('body').css('overflow-y','hidden').bind('touchmove', function(e){e.preventDefault()});
                    $popup.find('.close').on('click', function(){
                        if($popup.prop('id')) {
                            Dmall.LayerPopupUtil.close($popup.prop('id'));
                        } else {
                            Dmall.LayerPopupUtil.close();
                        }
                    });
                },
                close : function(id) {
                    var $body = $('body');
                    if(id) {
                        var $popup = $('#' + id);
                        $popup.fadeOut();
                        $popup.find('.dimmed2').remove();
                    } else {
                        $body.find('.layer_popup').fadeOut();
                        $body.find('.dimmed2').remove();
                    }
                    $body.css('overflow-y','scroll').unbind('touchmove');
                },
                add_option : function (data) {
                    var nextIdx = "1";
                    $("tr.regist_option", $("#tbody_option")).each(function() {
                        var optionIdx = null != $(this).data("optionIdx") ? parseInt($(this).data("optionIdx")) : 0;
                        nextIdx = optionIdx >= nextIdx ? optionIdx + 1 : nextIdx;
                    });
                    var $tmpTr = $("#tr_option_template").clone().show().removeAttr("id").addClass("regist_option").attr("id", "tr_option_" + nextIdx).data("optionIdx", nextIdx)
                    , $td1 = $("td:eq(0)", $tmpTr)
                    , $td2 = $("td:eq(1)", $tmpTr)
                    , $td3 = $("td:eq(2)", $tmpTr);
                    
                    $("button.minus_", $td1).data("optionIdx", nextIdx).off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var optionCnt = $("tr.regist_option", $("#tbody_option")).length;
                        if (optionCnt > 1) { 
                            $("#tr_option_" + $(this).data("optionIdx")).remove();
                        }
                    });
                    
                    if (null != data) {
                        $("input", $td2).data("value", data['optNm']).val(data['optNm']);
                        var optionValueList = data['optionValueList']
                          , optionValue = '';
                        $.each(optionValueList, function(idx, obj) {
                            if (0 === idx) {
                                optionValue = obj['attrNm'];
                                return true;
                            }
                            optionValue = optionValue + ',' + obj['attrNm'];
                        });
                        $("input", $td3).data("value", data['optionValue']).val(optionValue);
                    }
                    
                    if ($("tr.regist_option", $("#tbody_option")).length > 3) {
                        Dmall.LayerUtil.alert("상품 옵션은 최대 4개까지 생성할 수 있습니다.");
                        return false;
                    }
                    $("#tbody_option").append($tmpTr);
                }, 
                create_option : function (callback, goodsNo) {
                    var option_data = {};
                    var param = [];
                    $("tr.regist_option", $("#tbody_option")).each(function(i) {
                        
                        var $this = $(this);
                        var data = {
                            'optNm' : $("input:eq(0)", $this).val(),
                            'optionValue' : $("input", $("td:eq(2)", $this)).val(),
                        };
                        if ( !data['optNm'] ) {
                            Dmall.LayerUtil.alert('입력하신 옵션명이 유효하지 않습니다.');
                            return false;
                        }
                        if ( !data['optionValue']) {
                            Dmall.LayerUtil.alert('입력하신 옵션값이 유효하지 않습니다.');
                            return false;
                        }  
                        param.push(data);
                    });
                    callback = null != callback && "function" == typeof callback ? callback.apply(null, [param]) : alert("callback함수의 설정이 올바르지 않습니다.") ;
                }
            };
            
            GoodsValidateUtil = {
                    viewGoodsExceptionMessage : function(result, formId) {
                        var error_template = '<div class="formError" style="opacity: 0.87; position: absolute; top: 1px; left: 11px; margin-top: 0;"><div class="formErrorContent">* {{msg}}<br></div></div>', template, errors, $form, error, $target;

                        if (result.exError && result.exError.length > 0) {
                            errors = result.exError;
                        } else if(result.message){
                            Dmall.LayerUtil.alert(result.message);
                            return;
                        } else{
                            return;
                        }

                        $form = jQuery('#' + formId);
                        $form.validationEngine();

                        jQuery.each(errors, function(idx, error) {
                            template = new Dmall.Template(error_template, {
                                msg : error.message
                            });
                            $target = $form.find('input[name="' + error.name + '"], select[name="' + error.name + '"], textarea[name="'
                                    + error.name + '"]');

                            if ($target.length === 0) {
                                var messageArr = error.name.split('.')
                                  , index = messageArr[0].indexOf('[') > -1 ? parseInt(messageArr[0].substring(messageArr[0].indexOf('[')+1, messageArr[0].indexOf(']'))) : -1
                                  , jsonobj = messageArr[0] && messageArr[0].indexOf('[') > -1 ? messageArr[0].substring(0, messageArr[0].indexOf('[')) : ''
                                  , field = messageArr.length > 1 ? messageArr[messageArr.length-1] : ''
                                  , messageHead = index > -1 ? (index+1) + '번째 입력된 ' : '';
                                

                                switch (jsonobj) {
                                    
                                    case 'saleStartDt' : 
                                        Dmall.LayerUtil.alert(messageHead + '상품 판매기간의 설정이 유효하지 않습니다.');
                                        return false;
                                        break;
                                    case 'goodsItemList' :                                
                                        switch (field) {
                                            case 'stockQtt' :
                                                Dmall.LayerUtil.alert(messageHead + '단품의 재고 수량이 유효하지 않습니다.');
                                                return false;
                                                break;
                                            case 'salePrice' :
                                                Dmall.LayerUtil.alert(messageHead + '단품의 상품 가격이 유효하지 않습니다.');
                                                return false;
                                                break;
                                            case 'supplyPrice' :
                                                Dmall.LayerUtil.alert(messageHead + '단품의 공급 가격이 유효하지 않습니다.');
                                                return false;
                                                break;
                                            case 'attrValue1' :
                                                Dmall.LayerUtil.alert(messageHead + '중복된 단품 속성이 있습니다. 단품의 속성을 확인해 주세요.');
                                                return false;
                                                break;                                                
                                            default :
                                                Dmall.LayerUtil.alert(messageHead + '단품의 설정값이 유효하지 않습니다.');
                                                return false;
                                                break;
                                        }
                                        break;
                                    case 'goodsAddOptionList' :                                
                                        switch (field) {
                                            case 'addOptNm' :
                                                Dmall.LayerUtil.alert(messageHead + '추가옵션의 옵션명이 유효하지 않습니다.');
                                                return false;
                                                break;
                                            case 'addOptValue' :
                                                Dmall.LayerUtil.alert(messageHead + '추가옵션의 옵션값이 유효하지 않습니다.');
                                                return false;
                                                break; 
                                            case 'addOptAmt' :
                                                Dmall.LayerUtil.alert(messageHead + '추가옵션의 옵션금액이 유효하지 않습니다.');
                                                return false;
                                                break;
                                                
                                            default :
                                                Dmall.LayerUtil.alert(messageHead + '추가옵션의 설정값이 유효하지 않습니다.');
                                                return false;
                                                break;
                                        }
                                        break;                                        
                                        
                                    default :
                                        Dmall.LayerUtil.alert('모델의 ' + error.name + '의 검증식이 잘못되었거나 해당 데이터가 전송시 누락되었습니다.');
                                        return false;
                                        break;
                                }
                            }

                            if( $target[0] && $target[0].tagName ) {                                
                                switch ($target[0].tagName) {
                                    case 'INPUT' :
                                        switch ($target.attr('type')) {
                                            case 'radio' :
                                            case 'checkbox' :
                                                $target = $target.parents('label:first');
                                                break;
                                            default :
                                                switch (error.name) {
                                                    case 'saleStartDt' : 
                                                        Dmall.LayerUtil.alert('상품 판매기간의 설정이 유효하지 않습니다.');
                                                        return false;
                                                        break;
                                                    default :
                                                }
                                        }
                                        break;
                                    default :
                                }
                            }
                            $target.validationEngine('showPrompt', error.message, 'error');
                        });
                    },

                    setValueToTextarea : function(id) {
                        var idArray = [],
                            index,
                            idStr,
                            $textarea,
                            images, 
                            allAttachedImages, 
                            allAttachedImages, 
                            inputs;

                        $textarea = jQuery('#' + id);
                        Editor.switchEditor(id);
                        images = Editor.getAttachments('image');
                        allAttachedImages = Editor.getAttachBox().datalist;
                        index = 0;
                        inputs = '';

                        // 에디터 내용을 Textarea에 세팅
                        $textarea.val(Dmall.DaumEditor.getContent(id));

                        if (i === 0) {
                            $textarea.data('attachImages', null).data('deletedImages', null);
                        }

                        // 에디터에 쓰이는 첨부 이미지 처리
                        var attachImages = [];
                        for (var i = 0; i < images.length; i++) {
                            // existStage는 현재 본문에 존재하는지 여부
                            if (images[i].existStage) {
                                // data는 팝업에서 execAttach 등을 통해 넘긴 데이터
                                /*
                                inputs += '<input type="hidden" name="attachImages[' + index + '].orgFileNm" value="' + images[i].data.filename + '" />';
                                inputs += '<input type="hidden" name="attachImages[' + index + '].tempFileNm" value="' + images[i].data.tempfilename + '" />';
                                inputs += '<input type="hidden" name="attachImages[' + index + '].fileSize" value="' + images[i].data.filesize + '" />';
                                inputs += '<input type="hidden" name="attachImages[' + index + '].temp" value="' + images[i].data.temp + '" />';
                                index++;                                
                                */
                                var data = {
                                    'orgFileNm' : images[i].data.filename,
                                    'tempFileNm' : images[i].data.tempfilename,
                                    'fileSize' : images[i].data.filesize,
                                    'temp' : images[i].data.temp,
                                };
                                attachImages.push(data);
                            }
                        }

                        index = 0;
                        // 모든 첨부 이미지 처리
                        var deletedImages = [];
                        for (var i = 0; i < allAttachedImages.length; i++) {
                            // deletedMark 는 삭제된 파일
                            if (allAttachedImages[i].deletedMark) {
                                /*
                                inputs += '<input type="hidden" name="deletedImages[' + index + '].tempFileNm" value="' + allAttachedImages[i].data.tempfilename + '" />';
                                inputs += '<input type="hidden" name="deletedImages[' + index + '].temp" value="' + allAttachedImages[i].data.temp + '" />';
                                index++;
                                */
                                var data = {
                                    'tempFileNm' : allAttachedImages[i].data.tempfilename,
                                    'temp' : allAttachedImages[i].data.temp,
                                };
                                deletedImages.push(data);
                            }
                        }
                        // $textarea.after(inputs);
                        $textarea.data('attachImages', attachImages).data('deletedImages', deletedImages);
                    }
                };

            var getGunList = function(val){
        	var v_goodsTypeCd = $("#goodsTypeCd").val();
     		var append_str = "";
     		$.ajax({
     			type : "POST",
     			url : "/admin/vision/vision-check-gun-list",
     			data : {
     				goodsTypeCd 		: v_goodsTypeCd
     			},
     			dataType : "xml",
     			success : function(result) {
     				$('[id^=gun_list]').empty();
     				$("row",result).each(function(i){
     				   append_str = '<span style="display: inline;">';
                       append_str +='<input type="checkbox" name="gunNo" class="blind gunNo" id="chk_gunNo_'+$("gun_no",this).text()+'" value="'+$("gun_no",this).text()+'">';
                       append_str +='<label class="chack mr20" id="lb_gunNo_'+$("gun_no",this).text()+'" for="chk_gun_no_'+$("gun_no",this).text()+'">';
                       append_str +='<span class="ico_comm">&nbsp;</span>';
                       append_str += $("gun_nm",this).text();
                       append_str +='</label>';
                       append_str +='</span>';
                       $('tr.goods_type_'+val+' #gun_list_'+val).append(append_str);
     				});
     			},
     			error : function(result, status, err) {
     				alert(result.status + " / " + status + " / " + err);
     			},
     			beforeSend: function() {

     			},
     			complete: function(){
     			}
     		});
     	}
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">

    <div class="sec01_box">
    
        <div class="tlt_box">
            <%--<div class="btn_box left">
                    <a href="#none" class="btn gray" id="btn_goods_regist">상품등록(대량)</a>
            </div>--%>
            <h2 class="tlth2">D.매거진관리</h2>
            <div class="btn_box right">
                <%--<a href="#none" id="btn_preview" class="btn blue shot">미리보기</a>--%>
                <a href="#none" id="btn_confirm" class="btn blue shot">저장하기</a>
            </div>
        </div>
        <!-- line_box -->
        <form name="form_goods_info" id="form_goods_info">
        <div class="line_box fri">
            <h3 class="tlth3">D.매거진 카테고리 </h3>
            <!-- category_box -->
            <div id="div_ctg_box" class="category_box">
                <div class="step">
                    <p class="tlt">1차 카테고리</p>
                    <div class="list">
                        <ul id="ul_ctg_1">
                        </ul>
                    </div>
                </div>
                <div class="step">
                    <p class="tlt">2차 카테고리</p>
                    <div class="list">
                        <ul id="ul_ctg_2">
                        </ul>
                    </div>
                </div>
                <div class="step">
                    <p class="tlt">3차 카테고리</p>
                    <div class="list">
                        <ul id="ul_ctg_3">
                        </ul>
                    </div>
                </div>
                <div class="step">
                    <p class="tlt">4차 카테고리</p>
                    <div class="list">
                        <ul id="ul_ctg_4">
                        </ul>
                    </div>
                </div>
            </div>
            <!-- category_box -->
            <div class="btn_box txtc">
                <a href="#none" class="btn green" id="btn_choice_ctg">카테고리 선택</a>
                <a href="#none" class="btn gray" id="btn_regist_ctg">카테고리 등록</a>
            </div>
            <!-- cate_tbl -->
            <div class="cate_tbl tblmany">
                <table summary="이표는 선택된 카테고리 리스트 표 입니다. 구성은 선택된 카테고리, 대표분류, 분류명 입니다.">
                    <caption>선택된 카테고리 리스트</caption>
                    <colgroup>
                        <col width="25%">
                        <col width="75%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>선택된 카테고리</th>
                            <td>
                                <div class="in">
                                    <table summary="">
                                        <caption></caption>
                                        <colgroup>
                                            <col width="15%">
                                            <col width="35%">
                                            <col width="*">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th class="txtc">대표분류</th>
                                                <th>분류명</th>
                                                <%--<th>카테고리 수수료율</th>--%>
                                            </tr>
                                        </thead>
                                        <tbody id="tbody_selected_ctg">
                                            <tr id="tr_selected_ctg_template">
                                                <td class="txtc">
                                                    <label for="radio01" class="radio">
                                                        <span class="ico_comm">
                                                            <input type="radio" name="mainCategory" id="radio01" value="Y" />
                                                        </span>
                                                    </label>
                                                </td>
                                                <td>
                                                    <button class="icon_del">삭제</button>
                                                </td>
                                                <%--<td>
                                                    수수료율
                                                </td>--%>
                                            </tr>
                                            <tr id="tr_no_selected_ctg_template">
                                                <td class="txtc" colspan="3">선택된 카테고리가 없습니다.</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //cate_tbl -->
            <h3 class="tlth3  btn1">
                매거진 기본정보
				<div class="floatR">
				    <span id="goodsInqCnt" class="goods_add_time"></span>
					<span id="strRegDttm" class="goods_add_time"></span>
					<span id="strUpdDttm" class="goods_add_time"></span>
				</div>
            </h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table id="tb_goods_basic_info" summary="이표는 상품 기본정보 표 입니다. 구성은 상품번호, 상품코드, 상품명, 간단설명, 판매상태, 전시상태, 과세/비과세, 성인상품, 브랜드, 아이콘, 반품 가능 여부, 최소구매수량, 최대구매수량, 마켓포인트 설정, 수출입상품코드(HS코드) 입니다.">
                    <caption>상품 기본정보</caption>
                    <colgroup>
                        <col width="22%">
                        <col width="78%">
                        <col>
                        <col>
                    </colgroup>
                    <tbody>
                        <tr data-bind="basic_info" style="display:none;">
                            <th>상품번호</th>
                            <td id="td_goods_no">${resultModel.data.goodsNo}
                                <input type="hidden" id="goodsContsGbCd" name="goodsContsGbCd" value="02"/>
                                <input type="hidden" id="goodsSaleStatusCd" name="goodsSaleStatusCd" data-bind="basic_info" data-bind-type="text" value="1" /> <%-- 컨텐츠 상품은 default 1:판매중--%>
                                <input type="hidden" id="hd_goodsNo" name="goodsNo" data-bind="basic_info" value="${resultModel.data.goodsNo}" />
                                <input type="hidden" id="hd_itemNo" name="itemNo" data-bind="basic_info"  data-bind-type="text" data-bind-value="itemNo" />
                                <input type="hidden" id="hd_brandNm" name="brandNm" data-bind="basic_info"  data-bind-type="text" data-bind-value="brandNm" />
                                <input type="hidden" id="hd_sellerNm" name="sellerNm" data-bind="basic_info"  data-bind-type="text" data-bind-value="sellerNm" />
                                <input type="hidden" id="hd_isAbleAddIcon" name="isAbleAddIcon" value="${isAbleAddIcon}" />
                            </td>
                            <th>QR코드</th>
                            <td>
                            	<div id="qrcodeCanvas"></div>
                            	<br>
                            	<div>
                            		이미지 사이즈 :
                            		<input type="text" id="qrcodeWidth" value="" style="width:80px;"> X
                            		<input type="text" id="qrcodeHeight" value="" style="width:80px;">
                            		<button type="button" class="btn_gray" onClick="javascript:qrcode_download();">다운로드</button>
                            	</div>
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>제목 <span class="important">*</span></th>
                            <td colspan="3"><span class="intxt wid100p"><input type="text" name="goodsNm" id="txt_goods_nm" data-bind="basic_info"  data-bind-type="text" data-bind-value="goodsNm" data-validation-engine="validate[required, maxSize[100]]"  /></span></td>
                        </tr>
                        <tr data-bind="basic_info">
							<th>요약제목</th>
							<td colsapn="3"><span class="intxt wid100p"><input type="text" name="smrGoodsNm" id="txt_smr_goods_nm" data-bind="basic_info"  data-bind-type="text" data-bind-value="smrGoodsNm" data-validation-engine="validate[maxSize[100]]"  /></span></td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>간단설명</th>
                            <td colspan="3">
                                <div class="txt_area">
                                    <textarea name="prWords" id="ta_goods_desc" data-bind="basic_info" data-bind-type="text" data-bind-value="prWords" data-validation-engine="validate[maxSize[300]]" ></textarea>
                                </div>
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>전시상태</th>
                            <td colspan="3"  data-bind="basic_info" data-bind-value="dispYn" data-bind-type="function" data-bind-function="setLabelRadio" >
                                <label for="rdo_goods_display_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispYn" id="rdo_goods_display_Y" value="Y" data-bind="dispYn" /></span> 전시</label>
                                <label for="rdo_goods_display_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispYn" id="rdo_goods_display_N" value="N" data-bind="dispYn" /></span> 미전시</label>
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>SEO 검색용 태그달기</th>
                            <td colspan="3">
                                <%--<span class="intxt long">
                                    <input type="text" name="seoSearchWord" id="txt_seo_search_word" data-bind="basic_info" data-bind-type="text" data-bind-value="seoSearchWord" data-validation-engine="validate[maxSize[100]]" />
                                </span>--%>
                                 <div class="txt_area">
                                    <textarea name="seoSearchWord" id="txt_seo_search_word" data-bind="basic_info" data-bind-type="text" data-bind-value="seoSearchWord" data-validation-engine="validate[maxSize[2500]]"></textarea>
                                </div>
                                <span class="br2"></span>
                                <span class="fc_pr1 fs_pr1">
                                ※ 쉼표(,)로 구분하여 등록해주세요<br/>
                                ※ ex) 바지,반바지,여름용
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
        </div>
        </form>
            
            <form name="form_goods_detail_info" id="form_goods_detail_info">
                <h3 class="tlth3">상세 설명 <span style="font-weight:400; font-size:13px;">※ 이미지를 드래그하여 강제로 사이즈를 변경하지 마세요. 화면에 왜곡되어 보여질 수 있습니다. (글자 크기도 에디터에서 변경시 모바일 화면 확인 필수)</span></h3>

                <p style="margin:10px 0">
				   ※ iframe으로 동영상 삽입시 다음과 같은 형식으로 입력해 주세요. iframe안에 너비와 높이값은 실사이즈 그대로 입력해주세요.<br>
					<span style="color:red">&lt;div class="movie_outline"&gt;</span>&lt;iframe width="xxx" height="xxx"...&gt;&lt;/iframe&gt;<span style="color:red">&lt;/div&gt;</span>
				</p>
				<h3 class="tlth3">PC</h3>
				<div class="edit tblmany">
                    <textarea id="ta_goods_content" name="content" class="blind"></textarea>
                    <input type="hidden" id="hd_svcGbCd" name="svcGbCd" value="01" />
                    <input type="hidden" id="hd_goodsNo2" name="goodsNo" value="${resultModel.data.goodsNo}" data-bind="goodsNo" />
                </div>
                <h3 class="tlth3">MOBILE</h3>
                <div class="edit tblmany">
                    <textarea id="ta_mobile_content" name="mobileContent" class="blind"></textarea>
                </div>
            </form>

            <h3 class="tlth3"> 전시용 매거진 이미지
                <span class="desc">해당 매거진이 노출 설정되었을 때 노출되는 이미지 입니다.</span>
            </h3>
            <!-- tblh th_l -->
            <div class="tblh th_l tblmany">
                <table summary="이표는 메인상품 이미지 표 입니다. 구성은 typeA, typeB, typeC, typeD, typeE, typeF, typeG, typeS 입니다.">
                    <caption>매거진 이미지</caption>
                    <colgroup>
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <%--<col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">--%>
                        <col width="10%">
                        <col width="10%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>사진등록</th>
                            <th>매거진<br>375px x * px</th>
                            <th>카테고리전시용<br>187px x 177px</th>
                            <%--<th>TypeB<br>285px x 270px</th>
                            <th>TypeC<br>385px x 435px</th>
                            <th>TypeD<br>510px x 510px</th>
                            <th>TypeE<br>285px x 244px</th>
                            <th>TypeF<br>385px x 246px</th>
                            <th>TypeG<br>582px x 270px</th>
                            <th>TypeS<br>227px x 215px</th>--%>
                            <th>카테고리 전시<br>135px * 170px</th>
                            <th>통합 검색용<br>110px * 110px</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_disp_img">
                        <tr id="tr_disp_img_1">
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                    data-bind-param-1="DISP" data-bind-param-2="01" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                    data-bind-param-1="DISP" data-bind-param-2="M" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                    data-bind-param-1="DISP" data-bind-param-2="A" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <%--<td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                    data-bind-param-1="DISP" data-bind-param-2="B" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param-1="DISP" data-bind-param-2="C" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param-1="DISP" data-bind-param-2="D" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param-1="DISP" data-bind-param-2="E" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                     data-bind-param-1="DISP" data-bind-param-2="F" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                     data-bind-param-1="DISP" data-bind-param-2="G" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                     data-bind-param-1="DISP" data-bind-param-2="S" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>--%>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                     data-bind-param-1="DISP" data-bind-param-2="O" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
							<td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt=""
                                     data-bind-param-1="DISP" data-bind-param-2="P" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>

                        </tr>
                        <tr id="tr_disp_img_2">
                            <td><a href="#none" class="btn_blue" data-bind-param-1="DISP" data-bind-param-2="01" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage" >일괄등록</a></td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="M" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="M" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="A" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="A" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <%--<td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="B" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="B" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="C" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="C" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="D" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="D" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="E" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="E" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="F" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="F" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="G" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="G" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="S" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="S" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>--%>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="O" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="O" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="DISP" data-bind-param-2="P" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="DISP" data-bind-param-2="P" data-bind-type="function" data-bind="disp_img_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblh th_l -->
            <form name="form_goods_info2" id="form_goods_info2">
            <h3 class="tlth3">매거진 이미지</h3>
            <!-- tblh th_l -->
            <div class="tblh th_l tblmany">
                <table id="tb_goods_image_set" summary="이표는 상품 이미지 표 입니다. 구성은 상품컷, 사진등록, 확대이미지(500*500), 상품상세(기본)(240*240), 상품상세(중소)(130*130), 리스트 썸내일(90*90), 추천목록(50*50) 입니다.">
                    <caption>상품 이미지</caption>
                    <colgroup>
                        <col width="25%">
                        <col width="25%">
                        <col width="24%">
                        <col width="24%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>매거진 컷</th>
                            <th>사진등록</th>
                            <th>기본 이미지</th>
                            <th>리스트 썸네일</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_goods_image_set">
                        <tr id="tr_goods_image_template_1">
                            <td rowspan="2" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setDlgtImgYn">
                                <button class="btn_blue" id="btn_add_goods_image_set" name="btn_add_goods_image_set">추가</button>
                                <span class="br"></span>
                                <label for="rdo_dlgtImgYn" class="radio"><span class="ico_comm"><input type="radio" name="dlgtImgYn" id="rdo_dlgtImgYn" /></span> 대표</label>
                            </td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param-1="GOODS" data-bind-param-2="01" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param-1="GOODS" data-bind-param-2="02" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param-1="GOODS" data-bind-param-2="03" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                        </tr>
                        <tr id="tr_goods_image_template_2">
                            <td class="line_l"><a href="#none" class="btn_blue" data-bind-param-1="GOODS" data-bind-param-2="01" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage" >일괄등록</a></td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="GOODS" data-bind-param-2="02" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="GOODS" data-bind-param-2="02" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param-1="GOODS" data-bind-param-2="03" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <a href="#none" class="btn_preview" data-bind-param-1="GOODS" data-bind-param-2="03" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="previewRegistImage"><!-- 미리보기 --> <span class="ico_comm readgl"></span></a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblh th_l -->
            <!-- //tblw -->
            <h3 class="tlth3">관련상품 </h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table id="tb_relate_goods" summary="이표는 관련상품 표 입니다. 구성은 자동선정, 상품검색, 관련상품 없음 입니다.">
                    <caption>관련상품</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody id="tbody_relate_goods">
                        <tr id="tr_relate_goods_1">
                            <th><label for="rdo_relateGoodsApplyTypeCd_1" class="radio left "><span class="ico_comm">
                                <input type="radio" name="relateGoodsApplyTypeCd" value="1" id="rdo_relateGoodsApplyTypeCd_1" data-bind="relateGoodsApplyTypeCd"  >
                            </span> 자동선정</label></th>
                            <td>
                                <a href="#none" id="btn_relate_goods_condition" class="btn_blue">조건선택</a>
                                <span class="br"></span>
                                <div id="div_display_relate_goods_condition">
                                    [선택된 조건]
                                </div>
                            </td>
                        </tr>
                        <tr id="tr_relate_goods_2">
                            <th><label for="rdo_relateGoodsApplyTypeCd_2" class="radio left "><span class="ico_comm">
                                <input type="radio" name="relateGoodsApplyTypeCd" value="2" id="rdo_relateGoodsApplyTypeCd_2" data-bind="relateGoodsApplyTypeCd" >
                            </span> 직접선정</label></th>
                            <td>
                                <a href="#none" id="btn_relate_goods_srch" class="btn_blue">상품검색</a>
                                <span class="br"></span>
                                <ul id="ul_relate_goods" class="tbl_ul">
                                    <li id="li_relate_goods_template" >
                                        <button class="btn_comm cancel" data-bind-type="function" data-bind="relate_goods" data-bind-value="goodsNo" data-bind-function="setRelateCancelBtn">삭제</button>
                                        <span class="img" data-bind-type="function" data-bind="relate_goods" data-bind-value="goodsNo" data-bind-function="setRelateImage">
                                            <img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" />
                                        </span>
                                        <span class="txt" data-bind-type="function" data-bind="relate_goods" data-bind-value="goodsNo" data-bind-function="setRelateInfo">
                                        </span>
                                        <span class="link" data-bind-type="function" data-bind="relate_goods" data-bind-value="goodsNo" data-bind-function="setRelateBtn">
                                            <button class="btn_gray" id="btn_each_regist">서로등록</button>
                                        </span>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr id="tr_relate_goods_3">
                            <th><label for="rdo_relateGoodsApplyTypeCd_3" class="radio left "><span class="ico_comm">
                                <input type="radio" name="relateGoodsApplyTypeCd" value="3" id="rdo_relateGoodsApplyTypeCd_3" data-bind="relateGoodsApplyTypeCd">
                            </span> 관련상품 없음</label></th>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
            <div class="bottom_lay">
				<div class="btn_box txtc">
					<a href="#none" class="btn blue shot" id="btn_confirm2">저장하기</a>
				</div>
            </div>
        </div>
        <!-- //line_box -->
        </form>

        <div id="layer_create_goods_option" class="layer_popup">
        
            <div class="pop_wrap size4">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">옵션 만들기</h2>
                    <button class="close ico_comm" id="btn_close_layer_goods_option">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                <div class="pop_con" style="height:500px;">
                    <div>
                        <!-- select_top -->
                        <div class="select_top">
                            <span class="select">
                                <label for="sel_load_option">최근 등록 된 옵션</label>
                                <select name="loadOption" id="sel_load_option">
                                    <option value="">최근 등록 된 옵션</option>
                                </select>
                            </span>
                            <a href="#none" class="btn_gray2" id="btn_load_option">불러오기</a>
                            또는
                            <a href="#none" class="btn_gray2" id="btn_create_option">생성 및 변경</a>
                        </div>
                        <!-- select_top -->
                        <!-- tblh -->
                        <form name="goodsOption" id="form_id_goods_option" >
                        <div id="div_tb_goods_option" class="tblh th_l mt0 pm_btn">
                                <table id="tb_goods_option" summary="이표는 상품 판매정보 표 입니다. 구성은 기준판매가, 옵션(옵션1,옵션2), 소비자가, 공급가, 판매가, 재고(가용) 입니다.">
                                    <caption>상품 판매정보</caption>
                                    <colgroup>
                                        <col width="4%">
                                        <col width="12%">
                                        <col width="25%" id="col_pop_dynamic_col">
                                        <col width="10%">
                                        <col width="10%">
                                        <col width="10%">
                                        <col width="11%">
                                        <col width="6%">
                                        <col width="11%">
                                    </colgroup>
                                    <thead>
                                        <tr id="tr_pop_goods_item_head_1">
                                            <th rowspan="2"><button class="plus_ btn_comm" id="btn_add_item">더하기 버튼</button></th>
                                            <th rowspan="2">기준판매가</th>
                                            <th colspan="1" class="line_b" id="th_pop_dynamic_cols">옵션</th>
                                            <th rowspan="2">소비자가</th>
                                            <th rowspan="2">판매가<span class="important">*</span></th>
                                            <th rowspan="2">공급가</th>
                                            <th rowspan="2">별도공급가적용</th>
                                            <th rowspan="2">재고<span class="important">*</span></th>
                                            <th rowspan="2" id="th_multiOptPopErpItmCode">다비젼상품코드<span class="important">*</span></th>
                                        </tr>
                                        <tr id="tr_pop_goods_item_head_2">
                                            <th class="line_l"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbody_item">
                                        <tr id="tr_item_template" class="template">
                                            <td data-bind-type="function" data-bind="item_info" data-bind-value="idx" data-bind-function="setDeleteItem">
                                                <button class="minus_ btn_comm" name="btn_delete_item">빼기 버튼</button>
                                            </td>
                                            <td data-bind-type="function" data-bind="item_info" data-bind-value="standardPriceYn" data-bind-function="setStandardPriceYn">
                                                <label for="rdo_standardPriceYn" class="radio">
                                                    <span class="ico_comm">
                                                        <input type="radio" name="standardPriceYn" id="rdo_standardPriceYn" data-input-type="radio" data-input-name="standardPriceYn">
                                                    </span>
                                                </label>
                                            </td>
                                            <td id="td_pop_dynamic_cols" class="optionTd">
                                                <span class="intxt shot2">
                                                    <input type="text" name="attrValue1" id="txt_attr1" data-bind="item_info" data-bind-type="text" data-bind-value="attrValue1" maxlength="50" data-validation-engine="validate[maxSize[50]]" >
                                                </span>
                                            </td>
                                            <td>
                                                <span class="intxt shot2">
                                                    <input type="text" class="comma" name="customerPrice" id="txt_customerPrice" data-bind="item_info" data-bind-type="textcomma" data-bind-value="customerPrice" maxlength="10" data-validation-engine="validate[maxSize[10]]" >
                                                </span>원
                                            </td>
                                            <td>
                                                <span class="intxt shot2">
                                                    <input type="text" class="comma" name="salePrice" id="txt_salePrice" data-bind="item_info" data-bind-type="textcomma" data-bind-value="salePrice" maxlength="10" data-validation-engine="validate[required, maxSize[10]]" >
                                                </span>원
                                            </td>
                                            <td>
                                                <span class="intxt shot2">
                                                    <input type="text" class="comma" name="supplyPrice" id="txt_supplyPrice" data-bind="item_info" data-bind-type="textcomma" data-bind-value="supplyPrice" maxlength="10" data-validation-engine="validate[maxSize[10]]" readonly>
                                                </span>원
                                            </td>
                                            <td>
                                                <input type="checkbox" id="optSepSupplyPriceYn" name="sepSupplyPriceYn" class="blind" data-bind="item_info" data-bind-type="function" data-bind-function="setLabelCheckbox" data-bind-value="sepSupplyPriceYn" >
                                                <label for="optSepSupplyPriceYn" id="chk_sepSupplyPriceYn" class="chack">
                                                    <span class="ico_comm">
                                                    </span>
                                                </label>
                                            </td>
                                            <td>
                                                <span class="intxt shot2">
                                                    <input type="text" class="comma" name="stockQtt" id="txt_stockQtt" data-bind="item_info" data-bind-type="textcomma" data-bind-value="stockQtt" maxlength="4" data-validation-engine="validate[required, maxSize[5]]">
                                                </span>
                                             </td>
                                             <td>
			                                	<input type="text" name="itemErpItmCode"  style="width: 80px;" data-bind="item_info" data-bind-type="text" data-bind-value="erpItmCode" />
			                                    <button class="btn_gray" onclick="searchErpItmCode(this, event)">검색</button>
                                             </td>
                                        </tr>
                                        <tr id="tr_no_item_data"><td colspan="11">데이터가 없습니다.</td></tr>
                                    </tbody>
                                </table>
                        </div>
                        <!-- //tblh -->
                        <div class="btn_box txtc">
                            <button class="btn green" id="btn_apply_main_goods">적용하기</button>
                        </div>
                        </form>
                    </div>
                </div>
                <!-- //pop_con -->
            </div>

        </div>
        <!-- //layer_popup1 -->
        
        
        <!-- layer_popup1 -->
        <div id="layer_create_option" class="layer_popup">
            <div class="pop_wrap size1">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">옵션 생성 및 변경</h2>
                    <button id="btn_close_layer_create_option" class="close ico_comm">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                <div class="pop_con" style="height:500px;">
                    <div>
                        <!-- tblh -->
                        <div class="tblh th_l mt0 pm_btn2">
                            <table summary="이표는 옵션 생성 및 변경 표 입니다. 구성은 옵션명, 옵션 값 입니다.">
                                <caption>옵션 생성 및 변경</caption>
                                <colgroup>
                                    <col width="10%">
                                    <col width="40%">
                                    <col width="50%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th><button class="plus_ btn_comm" id="btn_add_option">더하기 버튼</button></th>
                                        <th>옵션명</th>
                                        <th>옵션 값</th>
                                    </tr>
                                </thead>
                                <tbody id="tbody_option">
                                    <tr id="tr_option_template">
                                        <td><button class="minus_ btn_comm">빼기 버튼</button></td>
                                        <td><span class="intxt wid100p"><input type="text" maxlength="20" value="" id=""></span></td>
                                        <td><span class="intxt wid100p"><input type="text" maxlength="100" value="" id=""></span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <ul class="desc_txt bottom">
                            <li>- 옵션 명 : 등록할 옵션의 타이틀 입니다.</li>
                            <li>- 옵션 값 : 해당 옵션에 포함될 옵션 값 입니다. ,(쉽표)를 이용해 복수의 옵션 값을 입력할 수 있습니다.</li>
                        </ul>
                        <div class="btn_box txtc">
                            <button class="btn green" id="btn_execute_create_option">옵션 생성하기</button>
                        </div>
                    </div>
                </div>
                <!-- //pop_con -->
            </div>
        </div>
        <!-- //layer_popup1 -->
    </div>
 <!-- content -->
<!-- //content -->
<!-- layer_popup은 container 다음에 넣어야함 -->
<!-- layout1s -->
<div id="layer_upload_image" class="slayer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">상품 이미지 등록</h2>
            <button id="btn_close_layer_upload_image" class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <form action="/admin/common/file-upload" name="imageUploadForm" id="form_id_imageUploadForm" method="post" >
                    <p class="message txtl">이미지 사이즈 설정 값을 기준으로 노출 위치별 필요한 사이즈로 자동 등록됩니다</p>
                    <span class="br"></span>
                    <span class="intxt imgup1"><input id="file_route1" class="upload-name" type="text" value="이미지선택" disabled="disabled"></span>
                    <label class="filebtn" for="input_id_image">파일찾기</label>
                    <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                    <span class="br2"></span>
                    <span class="imgup2">
                        <input type="hidden" id="hd_img_param_1" name="img_param_1" />
                        <input type="hidden" id="hd_img_param_2" name="img_param_2" />
                        <input type="hidden" id="hd_img_detail_width" name="img_detail_width" />
                        <input type="hidden" id="hd_img_detail_height" name="img_detail_height" />
                        <input type="hidden" id="hd_img_thumb_width" name="img_thumb_width" />
                        <input type="hidden" id="hd_img_thumb_height" name="img_thumb_height" />
                        <input type="hidden" id="hd_img_width_disp_type_a" name="img_width_disp_a" />
                        <input type="hidden" id="hd_img_height_disp_type_a" name="img_height_disp_a" />
                       <%-- <input type="hidden" id="hd_img_width_disp_type_b" name="img_width_disp_b" />
                        <input type="hidden" id="hd_img_height_disp_type_b" name="img_height_disp_b" />
                        <input type="hidden" id="hd_img_width_disp_type_c" name="img_width_disp_c" />
                        <input type="hidden" id="hd_img_height_disp_type_c" name="img_height_disp_c" />                                                
                        <input type="hidden" id="hd_img_width_disp_type_d" name="img_width_disp_d" />
                        <input type="hidden" id="hd_img_height_disp_type_d" name="img_height_disp_d" />
                        <input type="hidden" id="hd_img_width_disp_type_e" name="img_width_disp_e" />
                        <input type="hidden" id="hd_img_height_disp_type_e" name="img_height_disp_e" />
                        <input type="hidden" id="hd_img_width_disp_type_f" name="img_width_disp_f" />
                        <input type="hidden" id="hd_img_height_disp_type_f" name="img_height_disp_f" />
                        <input type="hidden" id="hd_img_width_disp_type_g" name="img_width_disp_g" />
                        <input type="hidden" id="hd_img_height_disp_type_g" name="img_height_disp_g" />
                        <input type="hidden" id="hd_img_width_disp_type_s" name="img_width_disp_s" />
                        <input type="hidden" id="hd_img_height_disp_type_s" name="img_height_disp_s" />
                        <input type="hidden" id="hd_img_width_disp_type_m" name="img_width_disp_m" />
                        <input type="hidden" id="hd_img_height_disp_type_m" name="img_height_disp_m" />--%>
                        <input type="hidden" id="hd_img_width_disp_type_o" name="img_width_disp_o" />
                        <input type="hidden" id="hd_img_height_disp_type_o" name="img_height_disp_o" />
                        <input type="hidden" id="hd_img_width_disp_type_p" name="img_width_disp_p" />
                        <input type="hidden" id="hd_img_height_disp_type_p" name="img_height_disp_p" />
                    </span>
                    <div class="btn_box txtc">
                        <button class="btn_green" id="btn_regist_image">등록</button>
                        <button class="btn_red" id="btn_cancel">취소</button>
                    </div>
                </form>
                
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
 
 
<!-- layer_popup1 -->
    <div id="layer_preview_upload_image" class="layer_popup">
        <div class="pop_wrap size2">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">이미지 미리보기</h2>
                <button id="btn_close_layer_preview_upload_image" class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <img id="img_preview_goods_image" src="/admin/img/product/tmp_img03.png" alt="" />
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>    
    
    <!-- layer_popup1 -->
    <div id="layer_relate_goods_condition" class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">조건 선택</h2>
                <button class="close ico_comm" id="btn_close_relate_goods_condition">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div id="div_relate_goods">
                    <!-- search_box -->
                    <div class="search_box tblmany">
                        <!-- search_tbl -->
                        <div class="search_tbl" id="div_relate_goods_condition">
                            <table summary="이표는 조건 선택 검색 표 입니다. 구성은 카테고리, 판매가격, 판매상태, 전시상태 입니다.">
                                <caption>조건 선택 검색</caption>
                                <colgroup>
                                    <col width="15%">
                                    <col width="85%">
                                </colgroup>
                                <tbody id="tbody_relate_goods_condition">
                                    <tr>
                                        <th>카테고리</th>
                                        <td id="td_relate_goods_select_ctg">
                                            <span class="select">
                                                <label for="sel_relate_ctg_1">1차 카테고리</label>
                                                <select name="relateCtg1" id="sel_relate_ctg_1">
                                                    <option id="opt_relate_ctg_1_def" value="">1차 카테고리</option>
                                                </select>
                                            </span>
                                            <span class="select">
                                                <label for="sel_relate_ctg_2">2차 카테고리</label>
                                                <select name="relateCtg2" id="sel_relate_ctg_2">
                                                    <option id="opt_relate_ctg_2_def" value="">2차 카테고리</option>
                                                </select>
                                            </span>
                                            <span class="select">
                                                <label for="sel_relate_ctg_3">3차 카테고리</label>
                                                <select name="relateCtg3" id="sel_relate_ctg_3">
                                                    <option id="opt_relate_ctg_3_def" value="">3차 카테고리</option>
                                                </select>
                                            </span>
                                            <span class="select">
                                                <label for="sel_relate_ctg_4">4차 카테고리</label>
                                                <select name="relateCtg4" id="sel_relate_ctg_4">
                                                    <option id="opt_relate_ctg_4_def" value="">4차 카테고리</option>
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>판매가격</th>
                                        <td>
                                            <span class="intxt"><input type="text" class="comma" maxlength="10" name="relateGoodsSalePriceStart" id="txt_relate_goods_price_start" data-bind="relate_info" data-bind-type="textcomma" data-bind-value="relateGoodsSalePriceStart" class="txtr" /></span> 원 부터
                                            ~
                                            <span class="intxt"><input type="text" class="comma" maxlength="10" name="relateGoodsSalePriceEnd" id="txt_relate_goods_price_end" data-bind="relate_info" data-bind-type="textcomma" data-bind-value="relateGoodsSalePriceEnd" class="txtr" /></span> 원 까지
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>판매상태</th>
                                        <td data-bind="relate_info" data-bind-value="relateGoodsSaleStatusCd" data-bind-type="function" data-bind-function="setLabelRadio">
                                            <label for="rd_relateGoodsSaleStatusCd_0" class="radio mr20"><span class="ico_comm"><input type="radio" value="0" name="relateGoodsSaleStatusCd" id="rd_relateGoodsSaleStatusCd_0" /></span> 전체</label>
                                            <label for="rd_relateGoodsSaleStatusCd_1" class="radio mr20"><span class="ico_comm"><input type="radio" value="1" name="relateGoodsSaleStatusCd" id="rd_relateGoodsSaleStatusCd_1" /></span> 판매중</label>
                                            <label for="rd_relateGoodsSaleStatusCd_2" class="radio mr20"><span class="ico_comm"><input type="radio" value="2" name="relateGoodsSaleStatusCd" id="rd_relateGoodsSaleStatusCd_2" /></span> 품절</label>
                                            <label for="rd_relateGoodsSaleStatusCd_4" class="radio mr20"><span class="ico_comm"><input type="radio" value="4" name="relateGoodsSaleStatusCd" id="rd_relateGoodsSaleStatusCd_4" /></span> 판매중지</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>전시상태</th>
                                        <td data-bind="relate_info" data-bind-value="relateGoodsDispStatusCd" data-bind-type="function" data-bind-function="setLabelRadio">
                                            <label for="rd_relateGoodsDispStatusCd_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="relateGoodsDispStatusCd" value="1" id="rd_relateGoodsDispStatusCd_1"/></span> 전체</label>
                                            <label for="rd_relateGoodsDispStatusCd_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="relateGoodsDispStatusCd" value="2" id="rd_relateGoodsDispStatusCd_2" /></span> 노출</label>
                                            <label for="rd_relateGoodsDispStatusCd_3" class="radio mr20"><span class="ico_comm"><input type="radio" name="relateGoodsDispStatusCd" value="3" id="rd_relateGoodsDispStatusCd_3" /></span> 미노출</label>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                    </div>
                    <!-- //search_box -->
                    <!-- tblw -->
                    <div class="tblw mt0" id="div_relate_goods_sort">
                        <table summary="이표는 자동 노출 정렬 리스트 표 입니다.">
                            <caption>자동 노출 정렬 리스트</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>자동 노출 정렬</th>
                                    <td data-bind="relate_info" data-bind-value="relateGoodsAutoExpsSortCd" data-bind-type="function" data-bind-function="setLabelRadio">
                                        <label for="rd_relateGoodsAutoExpsSortCd_01" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="01" id="rd_relateGoodsAutoExpsSortCd_01"></span> 최근 등록순(신상품순서)</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_02" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="02" id="rd_relateGoodsAutoExpsSortCd_02"></span> 판매인기순(구매금액)</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_03" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="03" id="rd_relateGoodsAutoExpsSortCd_03"></span> 판매인기순(구매갯수)</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_04" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="04" id="rd_relateGoodsAutoExpsSortCd_04"></span> 상품평 많은순</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_05" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="05" id="rd_relateGoodsAutoExpsSortCd_05"></span> 장바구니 담기 많은 순</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_06" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="06" id="rd_relateGoodsAutoExpsSortCd_06"></span> 위시리스트담기 많은순</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_07" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="07" id="rd_relateGoodsAutoExpsSortCd_07"></span> 상품조회 많은순</label>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <div class="btn_box txtc" id="btn_set_auto_relate_goods" >
                        <button class="btn green">위 자동 조건으로 상품 노출하기</button>
                    </div>
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
    
    <!-- layer_popup1 -->
    <div id="layer_preview_option"  class="layer_popup">
        <div class="pop_wrap size2">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">옵션 미리보기</h2>
                <button class="close ico_comm" id="close_preview_option">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table id="tb_preview_option" summary="이표는 옵션 미리보기 표 입니다. 구성은 컬러, 사이즈 입니다.">
                            <caption>옵션 미리보기</caption>
                            <colgroup>
                                <col width="50%">
                                <col width="50%">
                            </colgroup>
                            <tbody id="tbody_preview_option">
                                <tr id="tr_preview_option_template" style="display:none;">
                                    <th id="th_preview_option" data-bind="preview_option_info" data-bind-type="string" data-bind-value="optNm"></th>
                                    <td id="td_preview_option">
                                        <span class="select" data-bind-type="function" data-bind="preview_option_info" data-bind-value="optionValueList" data-bind-function="setOptionSelect">
                                            <label for="sel_preview_option">선택</label>
                                            <select name="" id="sel_preview_option">
                                                <option value="">선택</option>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
    
    <!-- 재고변경 이력 Layer START -->
    <div id="layer_qtt_hist"  class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">재고 변경 이력</h2>
                <button class="close ico_comm" id="close_qtt_hist">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <!-- tblw -->
                    <div class="tblw tblmany2 mt0">
                        <table summary="이표는 재고 변경 이력 표 입니다. 구성은 상품번호, 상품명, 누적입고량, 누적출고량, 현재 재고량 입니다.">
                            <caption>재고 변경 이력</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody id="tbody_qtt_hist_head">
                                <tr>
                                    <th>상품번호</th>
                                    <td data-bind="qtt_hist" data-bind-type="string" data-bind-value="goodsNo"></td>
                                </tr>
                                <tr>
                                    <th>상품명</th>
                                    <td data-bind="qtt_hist" data-bind-type="string" data-bind-value="goodsNm"></td>
                                </tr>
                                <tr>
                                    <th>누적입고량</th>
                                    <td data-bind="qtt_hist" data-bind-type="commanumber" data-bind-value="totalPlus">0</td>
                                </tr>
                                <tr>
                                    <th>누적출고량</th>
                                    <td data-bind="qtt_hist" data-bind-type="commanumber" data-bind-value="totalMinus">0</td>
                                </tr>
                                <tr>
                                    <th>현재 재고량</th>
                                    <td data-bind="qtt_hist" data-bind-type="commanumber" data-bind-value="stockQtt">0</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <!-- tblh -->
                    <div class="tblh mt0">
                        <table summary="이표는 재고 변경 이력 리스트 표 입니다. 구성은 일자, 재고증감, 수량 입니다.">
                            <caption>재고 변경 이력 리스트</caption>
                            <colgroup>
                                <col width="33%">
                                <col width="33%">
                                <col width="34%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>일자</th>
                                    <th>재고증감</th>
                                    <th>수량</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_qtt_hist_row">
                                <tr id="tr_qtt_hist_template" style="display:none;">
                                    <td data-bind="qtt_hist" data-bind-type="string" data-bind-value="chgDt"></td>
                                    <td data-bind="qtt_hist" data-bind-type="string" data-bind-value="chgQttCd"></td>
                                    <td data-bind="qtt_hist" data-bind-type="string" data-bind-value="chgQtt"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="confirm_qtt_hist">확인</button>
                    </div>
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- 재고변경 이력 Layer END   -->
    
    <!-- 판매 가격 변경 이력 Layer START -->
    <div id="layer_price_hist"  class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">판매 가격 변경 이력</h2>
                <button class="close ico_comm" id="close_price_hist">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <!-- tblw -->
                    <div class="tblw tblmany2 mt0">
                        <table summary="이표는 판매 가격 변경 이력 표 입니다. 구성은 상품번호, 상품명, 현재 판매 가격 입니다.">
                            <caption>재고 변경 이력</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody id="tbody_price_hist_head">
                                <tr>
                                    <th>상품번호</th>
                                    <td data-bind="price_hist" data-bind-type="string" data-bind-value="goodsNo"></td>
                                </tr>
                                <tr>
                                    <th>상품명</th>
                                    <td data-bind="price_hist" data-bind-type="string" data-bind-value="goodsNm"></td>
                                </tr>
                                <tr>
                                    <th>현재 판매 가격</th>
                                    <td data-bind="price_hist" data-bind-type="commanumber" data-bind-value="salePrice">0</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <!-- tblh -->
                    <div class="tblh mt0">
                        <table summary="이표는 판매 가격 변경 이력 리스트 표 입니다. 구성은 일자, 증감, 가격 입니다.">
                            <caption>판매 가격 변경 이력 리스트</caption>
                            <colgroup>
                                <col width="33%">
                                <col width="33%">
                                <col width="34%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>일자</th>
                                    <th>가격증감</th>
                                    <th>가격</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_price_hist_row">
                                <tr id="tr_price_hist_template" style="display:none;">
                                    <td data-bind="price_hist" data-bind-type="string" data-bind-value="chgDt"></td>
                                    <td data-bind="price_hist" data-bind-type="string" data-bind-value="chgPriceCd"></td>
                                    <td data-bind="price_hist" data-bind-type="string" data-bind-value="chgPrice"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="confirm_price_hist">확인</button>
                    </div>
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- 판매 가격 변경 이력 Layer END   -->    
    
    <!-- 다비젼 상품코드 검색 Layer START -->
    <div id="layer_erp_itm_code"  class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">다비젼 상품 검색</h2>
                <button class="close ico_comm" id="close_price_hist">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
            
				<div class="tblw tblmany2 mt0">
	            	상품코드 또는 브랜드 & 키워드로 상품을 검색하신 후 '적용'버튼을 눌러주세요.
					<form id="erpGoodsSearchForm">
				        <input type="hidden" name="page" value="1" />
				        <input type="hidden" name="pageNo" value="0" />
						<table summary="" class="w100p">
							<caption></caption>
							<colgroup>
								<col width="150px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr id="" class="tblw">
									<td class="paddingT06 paddingB10">
										<label for="radio_erp_itm_srch_itmCode" class="radio">
											<span class="ico_comm">
												<input type="radio" name="erp_itm_srch_type" id="radio_erp_itm_srch_itmCode" data-bind-value="itmCode" />
											</span>
											상품코드
										</label>
									</td>
									<td class="paddingT06 paddingB10">
										<input type="text" name="itmCode" />
									</td>
								</tr>
								<tr id="" class="tblw">
									<td class="paddingT06 paddingB10">
										<label for="radio_erp_itm_srch_keyword" class="radio">
											<span class="ico_comm">
												<input type="radio" name="erp_itm_srch_type" id="radio_erp_itm_srch_keyword" data-bind-value="keyword" />
											</span>
											브랜드&키워드
										</label>
									</td>
									<td class="paddingT06 paddingB10">
										<span class="select">
											<label for="select_itm_kind" id="select_itm_kind_label"></label>
											<select id="select_itm_kind" name="itmKind">
											</select>
										</span>
										<input type="text" readonly="readonly" id="brandNameInput" placeholder="브랜드명"/>
										<input type="hidden" name="brandCode" id="brandCodeInput" />
										<input type="text" name="itmName" placeholder="상품명 또는 모델명 입력" />
									</td>
								</tr>
								<tr>
									<td colspan="3" class="alignC">
										<span class="btn_box">
											<a href="#none" id="btn_search_erp_itm" class="btn blue shot">상품찾기</a>
										</span>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
                <div id="">
                    <!-- tblh -->
                    <div class="tblh mt0" style="display: none;" id="div_erp_itm_search_result">
                        <table summary="이표는 다비젼 상품 조회 목록입니다.">
                            <caption>다비젼 상품 목록</caption>
                            <colgroup>
                                <col width="10%">
                                <col width="15%">
                                <col width="35%">
                                <col width="20%">
                                <col width="20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>선택</th>
                                    <th>상품코드</th>
                                    <th>상품명</th>
                                    <th>제조사</th>
                                    <th>브랜드</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_itm_search_result">
                            	<tr>
	                            	<td>
										<label for="radio_erp_itm_srch_itmCode" class="radio">
											<span class="ico_comm">
												<input type="radio" name="erpItmCode" id="radio_erp_itm_code_1" value="123123123" />
											</span>
										</label>
	                            	</td>
	                            	<td>상품코드</td>
	                            	<td>상품명</td>
	                            	<td>제조사</td>
	                            	<td>브랜드</td>
                            	</tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="pageing"  id="div_id_paging"></div>
                    <!-- //tblh -->
                    <div class="btn_box txtc">
                        <button class="btn gray" id="cancel_erp_itm_search">취소</button>
                        <button class="btn green" id="apply_erp_itm_code">적용</button>
                    </div>
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- 다비젼 상품코드 검색 Layer END -->
    
    <!-- 다비젼 상품코드 검색 > 브랜드검색 Layer START-->
    <div id="layer_erp_itm_brand"  class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">브랜드 검색</h2>
                <button class="close ico_comm" id="close_price_hist">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
            
				<div class="tblw tblmany2 mt0">
					<form id="erpGoodsBrandSearchForm">
						<input type="text" name="brandName" placeholder="브랜드명" />
						<span class="btn_box">
							<a href="#none" id="btn_search_erp_itm_brand" class="btn gray shot">찾기</a>
						</span>
					</form>
				</div>
                <div>
                    <!-- tblh -->
                    <div class="tblh mt0" style="display: none;" id="div_erp_itm_brand_search_result">
                        <table summary="이표는 다비젼 상품 브랜드 목록입니다.">
                            <caption>다비젼 상품 브랜드 목록</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="*">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>선택</th>
                                    <th>브랜드명</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_itm_brand_search_result">
                            	<tr>
	                            	<td>
										<label for="radio_erp_itm_brand_srch_brandCode" class="radio">
											<span class="ico_comm">
												<input type="radio" name="brandCode" id="radio_erp_itm_brand_srch_brandCode" value="123123123" />
											</span>
										</label>
	                            	</td>
	                            	<td>브랜드명</td>
                            	</tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <div class="btn_box txtc">
                        <button class="btn gray" id="cancel_erp_itm_brand_search">취소</button>
                        <button class="btn green" id="apply_erp_itm_brand">입력</button>
                    </div>
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- 다비젼 상품코드 검색 > 브랜드검색 Layer END-->
        
    
    
    <!-- //layer_popup1 -->
    <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />

    </t:putAttribute>
    
</t:insertDefinition>
