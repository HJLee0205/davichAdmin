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
    <t:putAttribute name="title">홈 &gt; 회원 &gt; 판매상품관리 &gt; 상품등록</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            jQuery(document).ready(function() {
                
                fn_setDefault();
                
                // 상품 등록 화면 표시를 위한 화면 설정
                getDefaultDisplayInfo('${resultModel.data.editModeYn}');
                
                fn_loadEditor();
                
                // fn_setTestData();
                
                // 화면 이벤트 설정
                // 상품등록 버튼 이벤트 설정
                jQuery('#btn_regist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_registGoods();
                });
                // 카테고리 등록 버튼 이벤트 설정
                jQuery('#btn_regist_ctg').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_registCtg();
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
                        alert("등록할 상품 이미지를 선택해 주십시요.");
                        return;
                    } 
                    jQuery('#form_id_imageUploadForm').attr('action', '/admin/goods/goods-image-upload');
                    jQuery.when(Dmall.FileUpload.upload('form_id_imageUploadForm')).then(
                    // jQuery.when(submitImage('form_id_imageUploadForm')).then(
                    function (result) {

                        
/*                        
                        var files = result.files
                          , $img_param = $("#hd_img_param_1")
                          , type = $img_param.data("type")
                          , row = $img_param.data("setIdx");
                        // 리턴되는 이미지 파일 데이터가 있을 경우
                        if (files) {
                            var types = [["02", "500", "500", true]
                                       , ["03", $('#txt_goodsDefaultImgWidth').val(), $('#txt_goodsDefaultImgHeight').val(), true]
                                       , ["01", "110", "110", false]
                                       , ["04", "130", "130", true]
                                       , ["05", $('#txt_goodsListImgWidth').val(), $('#txt_goodsListImgHeight').val(), true]
                                       , ["06", "50", "50", true]];
                        
                            // 개별 등록의 경우, 등록 이미지와 Thumbnail 이지 2개가 생성
                            if (files.length == 2) {
                                var imageWidth, imageHeight, GoodsImageYn;
                                $.each(types, function(idx, typ){
                                   if (type === typ[0]) {
                                       imageWidth = types[idx][1];
                                       imageHeight = types[idx][2];
                                       GoodsImageYn = types[idx][3];
                                       return false;
                                   } 
                                });
                                var data = {
                                        idx : 0,
                                        src : files[0].thumbUrl,
                                        type : type,
                                        tempFileName : files[0].tempFileName,
                                        imageUrl : files[0].imageUrl,
                                        imageWidth :  imageWidth,
                                        imageHeight :  imageHeight,
                                        goodsImageYn :  GoodsImageYn,
                                        isTempYn : "Y"
                                    };
                                $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);

                            // 일괄 등록의 경우
                            } else {
                                $.each(files, function(idx, file){
                                    var data = {
                                            idx : idx,
                                            src : file.thumbUrl,
                                            type : types[idx][0],
                                            tempFileName : file.tempFileName,
                                            imageUrl : file.imageUrl,
                                            imageWidth :  types[idx][1],
                                            imageHeight :  types[idx][2],
                                            goodsImageYn :  types[idx][3],
                                            isTempYn : "Y"
                                        };
                                    $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                    $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                });
                            }
                        }
*/                        
                        
                        var files = result.files
                        , $img_param = $("#hd_img_param_1")
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
                                      imageUrl : files[0].imageUrl,
                                      imageWidth :  files[0].imageWidth,
                                      imageHeight :  files[0].imageHeight,
                                      isTempYn : "Y"
                                  };
                              $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                              $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                        
                          // 일괄 등록의 경우
                          } else {
                              $.each(files, function(idx, file){
                                  var data = {
                                          idx : idx,
                                          src : file.thumbUrl,
                                          type : file.imgType,
                                          tempFileName : file.tempFileName,
                                          imageUrl : file.imageUrl,
                                          imageWidth :  file.imageWidth,
                                          imageHeight :  file.imageHeight,
                                          isTempYn : "Y"
                                      };
                                  $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                  $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + row + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                              });
                          }
                        }                        
                        

                        $("#form_id_imageUploadForm")[0].reset();
                        $("#btn_close_layer_upload_image").trigger('click');
                    });
                });
                
                jQuery('#btn_cancel').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#btn_close_layer_upload_image").trigger('click');
                });
                
                // 아이콘 추가 버튼 클릭 이벤트
                jQuery('#btn_add_icon').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_add_icon();
                });
                
                // 아이콘 등록 버튼 클릭 이벤트
                jQuery('#btn_regist_icon').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if(Dmall.FileUpload.checkFileSize('fileUploadForm')) {
                        var $input = $('#icon_file')
                          , ext = $input.val().split('.').pop().toLowerCase()
                          , fileSize = $input[0].files[0].size;
                          
                        if(fileSize > 500 * 1000) {
                            alert('500KB 이하의 파일을 업로드 해주세요.');
                            return;
                        } else if($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {
                            alert('이미지 파일이 아닙니다. (gif, png, jpg, jpeg 만 업로드 가능)');
                            return;
                        } else {
                            /*
                            var reader = new FileReader();
                            reader.onload = function(e) {
                                $('#tempImg').attr('src', e.target.result); 
                            }
                            reader.readAsDataURL($input[0].files[0]);
                            
                            //이미지 사이즈를 검증한다.
                            reader.onloadend = function() {
                                uploadIconImg();
                            }
                            */
                            jQuery.when(Dmall.FileUpload.upload('fileUploadForm')).then(function (result) {
                                var file = result.files[0] || null;
                                if (file) {
                                    addGoodsIcon(file, $("#td_icon_info"));
                                    // alert('아이콘 이미지가 업로드 되었습니다.');
                                    $("#btn_close_add_icon").trigger('click');
                                }
                            });                            
                        }
                    }
                });
                
                // 아이콘 취소 버튼 클릭 이벤트
                jQuery('#btn_cancel_icon').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#btn_close_add_icon").trigger('click');
                });
                // 이미지 관련 - 끝
                
                // 상품 이미지 사이즈 설정 버튼 클릭 이벤트
                jQuery('#btn_set_goods_image_size').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_set_goods_image_size();
                });
                
                // 상품 이미지 설정 등록 버튼 클릭 이벤트
                jQuery('#btn_regist_goods_image_size').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    
                    if(Dmall.validate.isValid('form_set_goods_image_size')) {
                        var url = '/admin/goods/goods-size-update'
                          , param = {
                            'goodsDefaultImgWidth' : $('#txt_goodsDefaultImgWidth').val(),
                            'goodsDefaultImgHeight' : $('#txt_goodsDefaultImgHeight').val(),
                            'goodsListImgWidth' : $('#txt_goodsListImgWidth').val(),
                            'goodsListImgHeight' : $('#txt_goodsListImgHeight').val(),
                        };

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_set_goods_image_size');
                            if (result == null || result.success != true) {
                                return;
                            } else {
                                createGoodImgInfo(result.data);
                                $("#btn_close_set_goods_image_size").trigger('click');
                            }
                        });
                    }
                    return false; 
                });
                // 상품 이미지 설정 취소 버튼 클릭 이벤트
                jQuery('#btn_cancel_goods_image_size').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#btn_close_set_goods_image_size").trigger('click');
                });
             
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
                        alert('등록할 옵션 정보를 생성해 주십시요');
                        return;
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
                    GoodsLayerPopupUtil.create_option(fn_execute_create_option, $("#hd_goods_no").val());
                });
                
                // 옵션만들기 팝업화면에서 적용하기 버튼 클릭 이벤트 
                jQuery('#btn_apply_main_goods').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_applyMainGoods();
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
                
                // 관련 상품 조건 설정 (관련상품 조건설정 팝업 호출) 
                jQuery('#btn_relate_goods_condition').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if ('1' == $('input:radio[name=relateGoodsApplyTypeCd]:checked', '#tbody_relate_goods').val()) {
                        getCategoryOptionValue('1', jQuery('#sel_relate_ctg_1'));
                        Dmall.LayerPopupUtil.open(jQuery('#layer_relate_goods_condition'));
                    } else {
                        $('#tbody_relate_goods').data('sel', '1');
                        Dmall.LayerUtil.confirm('관련 상품을 자동 선정으로 변경 하시겠습니까?', fn_changeRelateGoodsApplyType);
                    }
                });
                // 관련 상품 검색 (상품검색 팝업 호출) 
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
                jQuery('#btn_confirm').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.init.ajax();
                
                    
                   
                     if(checkValidation() && Dmall.validate.isValid('form_goods_info')) {
                         GoodsValidateUtil.setValueToTextarea('ta_goods_content');  // 에디터에서 폼으로 데이터 세팅
                        // $('#hd_goodsNo2').val($('#hd_goods_no').val());
                        
                        var url = '/admin/goods/goods-info-insert'
                            , param = fn_getGoodsRegistData()
                            , paramContents = $('#form_goods_detail_info').serializeObject()
                            , paramContents1 = $('#form_goods_detail_info').serialize()
                            , attachImages = {'attachImages' : $('#ta_goods_content').data('attachImages')}
                            , deletedImages = {'deletedImages' : $('#ta_goods_content').data('deletedImages')}
                            , result1
                            , result2
                        ;
                        
                          var paramMerge = $.extend(paramContents, param, attachImages, deletedImages);

                            $.ajax({
                                url : url
                                , method : "post"
                                , dataType : 'json'
                                , data : JSON.stringify(paramMerge)
                                , processData : true
                                , contentType : "application/json; charset=UTF-8"                                
                                // 성공 시 (임시_로직 재정의 필요)
                                , success : function(data, stat, xhr) {
                                    result1 = data;
                                    
                                    GoodsValidateUtil.viewGoodsExceptionMessage(result1, 'form_goods_info');
                                    if (result1 == null || result1.success != true) {
                                        return;
                                    } else {
                                        /*
                                        Dmall.AjaxUtil.getJSON('/admin/goods/goods-contents-insert', paramContents, function(result) {
                                            Dmall.validate.viewExceptionMessage(result, 'form_goods_info');
                                            if (result == null || result.success != true) {
                                                return;
                                            }
                                            getEditorDataInfo();
                                        })
                                        */
                                        getDefaultDisplayInfo('Y');
                                        getEditorDataInfo();
                                    }
                                                                    }
                                // 실패 시 (임시_로직 재정의 필요)
                                , error : function(xhr, stat, err) {
                                    alert('test');
                                    Dmall.validate.viewExceptionMessage(xhr, 'form_goods_info');
                                }
                            })
                    }                  
                       

/*
                       Dmall.DaumEditor.setValueToTextarea('ta_goods_content');  // 에디터에서 폼으로 데이터 세팅
                        
                        var url = '/admin/goods/goods-info-insert'
                            , param = fn_getGoodsRegistData()
                            , paramContents = $('#form_goods_detail_info').serialize()
                            , result1
                            , result2;
                        paramContents.content = jQuery('#ta_goods_content').html();
                        
                        Dmall.AjaxUtil.getJSON('/admin/goods/goods-contents-insert', paramContents, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_goods_detail_info');
                            if (result == null || result.success != true) {
                                return;
                            } 
                             $.ajax({
                                url : url
                                , method : "post"
                                , dataType : 'json'
                                , data : JSON.stringify(param)
                                , processData : true
                                , contentType : "application/json; charset=UTF-8"                                
                                // 성공 시 (임시_로직 재정의 필요)
                                , success : function(data, stat, xhr) {
                                    result1 = data;
                                    getDefaultDisplayInfo(true);
                                }
                                // 실패 시 (임시_로직 재정의 필요)
                                , error : function(xhr, stat, err) {
                                }
                            });
                            
                            getEditorDataInfo();
                        })
*/
                    
/*                     if(checkValidation() && Dmall.validate.isValid('form_goods_info')) {
                        
                        Dmall.DaumEditor.setValueToTextarea('ta_goods_content');  // 에디터에서 폼으로 데이터 세팅
                        
                        var url = '/admin/goods/goods-info-insert'
                            , param = fn_getGoodsRegistData()
                            , paramContents = $('#form_goods_info').serialize()
                            , result1
                            , result2;
                        
                        paramContents.content = jQuery('#ta_goods_content').html();
                        
                          Dmall.AjaxUtil.getJSON('/admin/goods/goods-contents-insert', paramContents, function(result) {
                              Dmall.validate.viewExceptionMessage(result, 'form_goods_info');
                              if (result == null || result.success != true) {
                                  return;
                              } 
                               $.ajax({
                                  url : url
                                  , method : "post"
                                  , dataType : 'json'
                                  , data : JSON.stringify(param)
                                  , processData : true
                                  , contentType : "application/json; charset=UTF-8"                                
                                  // 성공 시 (임시_로직 재정의 필요)
                                  , success : function(data, stat, xhr) {
                                      result1 = data;
                                      getDefaultDisplayInfo(true);
                                  }
                                  // 실패 시 (임시_로직 재정의 필요)
                                  , error : function(xhr, stat, err) {
                                  }
                              });
                              
                              getEditorDataInfo();
                          })
                    } */
                });
                
                // 다중옵션판매 버튼 클릭 이벤트 - 메인
                jQuery('#btn_multi_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#hd_multiOptYn").val("Y");
                    $("#div_simple_option").hide();
                    $("#div_multi_option").show();
                });
                
                // 단일옵션판매 버튼 클릭 이벤트 - 메인
                jQuery('#btn_simple_option').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#hd_multiOptYn").val("N");
                    $("#div_simple_option").show();
                    $("#div_multi_option").hide();
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
                
                Dmall.common.numeric();
                Dmall.common.comma();
                Dmall.common.date();
                
                // 개발을 위해 미적용 (개발완료 후 적용)
                // Dmall.validate.set('form_goods_info');
            });
            // 관련 상품 설정 방법 변경
            function fn_changeRelateGoodsApplyType() {
                var type =  $('#tbody_relate_goods').data('sel');
                $('label[for=rdo_relateGoodsApplyTypeCd_'+ type +']', '#tbody_relate_goods').trigger('click');
                switch (type) {
                    case '1' :
                        getCategoryOptionValue('1', jQuery('#sel_relate_ctg_1'));
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
                
            // 아이콘 업로드
            function uploadIconImg() {
                $('#tempImg').load(function() {
                    if(this.naturalWidth >  80 || this.naturalHeight > 40 ) {
                        alert('아이콘 이미지의 적당 사이즈는 45 * 20 입니다. 이미지 사이즈를 확인해 주세요');
                        return;
                    } else {
                        jQuery.when(Dmall.FileUpload.upload('fileUploadForm')).then(function (result) {
                            var file = result.files[0] || null;
                            if (file) {
                                // jQuery('#div_id_download').html('<a class="btn_red" href="/admin/common/common-download?' + jQuery.param(file) + '">파비콘 이미지가 업로드 되었습니다.</a>');
                                // jQuery('#div_id_download').html('<img src="${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName + '"/>');
                                addGoodsIcon(file, $("#td_icon_info"));
                                // alert('아이콘 이미지가 업로드 되었습니다.');
                                $("#btn_close_add_icon").trigger('click');
                            }
                        });
                    }
                });
            }
            
            // 아이콘 추가 레이어 팝업 오픈
            function fn_add_icon() {
                // checkIconSetCnt();
                Dmall.LayerPopupUtil.open(jQuery('#layer_add_icon'));
            }
            
            function fn_set_goods_image_size() {
                Dmall.LayerPopupUtil.open(jQuery('#layer_set_goods_image_size'));
                Dmall.validate.set('form_set_goods_image_size');
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
                    'relateGoodsApplyCtg' : (selectCtg_4) ? selectCtg_4 :  (selectCtg_3) ? selectCtg_3 : (selectCtg_2) ? selectCtg_2 : (selectCtg_1) ? selectCtg_1 : null,
                    'relateGoodsSalePriceStart' : $('#txt_relate_goods_price_start').val(),
                    'relateGoodsSalePriceEnd' : $('#txt_relate_goods_price_end').val(),
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
                    if ('relateGoodsApplyCtg' in data && data['relateGoodsApplyCtg'] ) {
                        html += '[카테고리정보] '
                    }
                    if ( ('relateGoodsSalePriceStart' in data && data['relateGoodsSalePriceStart'] != '') 
                            || ('relateGoodsSalePriceEnd' in data && data['relateGoodsSalePriceEnd'] != '')) {
                        html += '[가격대정보] '
                    }
                    if ('relateGoodsSaleStatusCd' in data && data['relateGoodsSaleStatusCd'] != '')  {
                        html += '[판매상태] '
                    }
                    if ('relateGoodsDispStatusCd' in data && data['relateGoodsDispStatusCd'] != '')  {
                        html += '[전시상태] '
                    }
                    if ('relateGoodsAutoExpsSortCd' in data && data['relateGoodsAutoExpsSortCd'] != '')  {
                        html += '[상품정렬] '
                    }
                }
                $('#div_display_relate_goods_condition').data('relate_condition', data).html(html);
                
            }
                
            function fn_set_radio_element() {
                var $div = $('#div_delivery_info') 
                  , value = $('input:radio[data-bind=dlvrSetCd]:checked', $div).val()
                  , $txt_3 = $("#txt_goods_each_dlvrc").prop("disabled",true).val('')
                  , $txt_4 = $("#txt_qtt_each_dlvrc").prop("disabled",true).val('')
                  , $txt_5_1 = $("#txt_pack_max_unit").prop("disabled",true).val('')
                  , $txt_5_2 = $("#txt_pack_unit_dlvrc").prop("disabled",true).val('')
                  , $txt_5_3 = $("#txt_pack_unit_add_dlvrc").prop("disabled",true).val('')
                ;
                

                switch (value) {
                    case "3":
                        $txt_3.prop("disabled",false).val($txt_3.data("commavalue"));
                        break;
                    case "4":
                        $txt_4.prop("disabled",false).val($txt_4.data("commavalue"));
                        break;
                    case "5":
                        $txt_5_1.prop("disabled",false).val($txt_5_1.data("commavalue"));
                        $txt_5_2.prop("disabled",false).val($txt_5_2.data("commavalue"));
                        $txt_5_3.prop("disabled",false).val($txt_5_3.data("commavalue"));
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
                if( $("#txt_sale_start_dt").val().length > 0 && !Dmall.validation.date($("#txt_sale_start_dt").val())){
                    Dmall.LayerUtil.alert("상품 판매기간 시작일을 정확하게 입력해주세요.", "알림");
                    return false;
                }
                if( $("#txt_sale_end_dt").val().length > 0 && !Dmall.validation.date($("#txt_sale_end_dt").val())){
                    Dmall.LayerUtil.alert("상품 판매기간 종료일을 정확하게 입력해주세요.", "알림");
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
                $('#hd_goods_no').val(goodsNo);
                var url = '/admin/goods/goods-info',
                param = {'goodsNo' : goodsNo};
            

                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    if (result == null || result.success != true) {
                        return;
                    }
                    
                    var data = result.data;
                    // 취득결과 셋팅

                    
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
                    loadGoodsNotifyList(data);
                    
                    /*** 7. 상품 이미지 설정 로딩 데이터 바인딩 ***/
                    loadGoodsImageSet(data);
                });
            }
            
            /*** 0. 상품 기본 설정 로딩 데이터 바인딩 ***/
            function loadBasicInfo(data) {
                $('[data-bind="basic_info"]').DataBinder(data);
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
                   .html('<span class="ico_comm">&nbsp;</span>' + obj.iconPathNm );

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

            
            /*** 2. 카테고리 관련 - 시작 ***/
            
            // 로딩된 상품에 설정된 카테고리 정보 설정 - [상품로딩.2]
            function loadGoodsCtgInfo(data) {
                var ctgList = data.goodsCtgList;

                // 기존 선택된 카테고리 삭제
                $('tr.selectedCtg', $('#tbody_selected_ctg ')).remove();                
                $.each(ctgList, function(idx, data){
                    if (data ) { 
                        addGoodsCtgRow(data);
                    }
                })
                if ( $("#tbody_selected_ctg").find("tr:visible").length < 1 ) {
                    $("#tr_no_selected_ctg_template").show();
                }
            }
            // 상품 저장시 카테고리 정보 취득 - [상품저장.1]
            function getGoodsCategoryValue($target) {
                var returnData = new Array();
                $target.each(function(idx) {
                    returnData.push($(this).data('value'));
                });
                return returnData;
            }            
            
            // 카테고리 등록 버튼 클릭 이벤트  
            function fn_registCtg() {
                var ctgNo = $("li.on:last", $("#div_ctg_box")).data("ctgNo")
                    , ctgNm1 = $("li.on:first", $("#ul_ctg_1")).data("ctgNm")
                    , ctgNm2 = $("li.on:first", $("#ul_ctg_2")).data("ctgNm")
                    , ctgNm3 = $("li.on:first", $("#ul_ctg_3")).data("ctgNm")
                    , ctgNm4 = $("li.on:first", $("#ul_ctg_4")).data("ctgNm");
                
                var data = {
                    'goodsNo': $('#hd_goods_no').val(),
                    'dlgtCtgYn': 'N',
                    'expsYn': 'Y',
                    'expsPriorRank': $('tr.selectedCtg:visible', $('#tbody_selected_ctg')).length,
                    'ctgDisplayNm' : '',
                    'ctgNo' : ctgNo,
                    'ctgNm1' : ctgNm1,
                    'ctgNm2' : ctgNm2,
                    'ctgNm3' : ctgNm3,
                    'ctgNm4' : ctgNm4,
                    'registFlag' : 'I', 
                };                
                addGoodsCtgRow(data)
            }
            
            // 선택된 카테고리 ROW 추가
            function addGoodsCtgRow(data) {
                var $tmpCtgTr = $("#tr_selected_ctg_template").clone().show().removeAttr("id")
                , $td1 = $("td:eq(0)", $tmpCtgTr)
                , $td2 = $("td:eq(1)", $tmpCtgTr)
                , isRegisted = false;
                var trId = "tr_ctg_" + data.ctgNo;
                
                // 기존 등록 여부 체크
                $('tr.selectedCtg:visible', $('#tbody_selected_ctg')).each(function() {
                    if ( trId === $(this).attr('id')) {
                        isRegisted = true;
                        alert("이미 등록된 카테고리 입니다.");
                        return false;
                    }
                });
                
                // 새로운 카테고리 등록일 경우 ROW 생성
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
                    
                    // 삭제 버튼 생성
                    var btn = document.createElement('button');
                    // 삭제 버튼 이벤트 설정 
                    $(btn).data("ctgNo", data['ctgNo']).addClass("btn_gray").html("삭제").off("click").on('click', function(e) {
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
                    return;
                }
            }
            
            
            // 성인 인증 설정 정보 확인
            function fn_checkAdultCertifyConfig() {
                var url = '/admin/setup/personcertify/adultcertify-config-check',
                    param = {};
                //
                
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
            function getCategoryInfo(ctgLvl, $ul, upCtgNo) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl};
                
                //
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        var li = document.createElement('li');
                        $(li).data("ctgNo", obj.ctgNo).data("ctgNm", obj.ctgNm).html(obj.ctgNm);
                        $(li).off("click").on('click', function() {
                            var $this = $(this);
                            if ( !$this.hasClass("on") ) {
                                $this.siblings('li').removeClass("on");
                                changeCategoryInfo(parseInt(ctgLvl)+1, $ul, $this.addClass("on").data("ctgNo"));                                
                            } 
                        });
                        $ul.append(li);
                    });
                });
            }
            /** 2. 카테고리 관련 - 끝 **/


            
            
            function makeOptionData(optValue, optNo, attrValue, attrNo, optData) {
                if (null != optValue) {
                    var optValueArray = null == optData ? [] : optData['optionValueList']
                      , isExist = false;                    
                    $.each(optValueArray, function(idx, obj) {
                        
                        if (attrValue === obj) {
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
                            }
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
                var url = '/admin/goods/recent-option',
                param = '';
                
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
                    
                    $('#tb_goods_option').data('new_option_flag', true);
                });
                
                // 디폴트 표시
                if ($("input:radio[name=standardPriceYn]:visible:checked", $("#tbody_item")).length < 1) {
                    $("label.radio:visible", $("#tbody_item")).eq(0).trigger('click');
                } 
            }
            
            // 상품 판매 정보 취득 - [상품저장.3]
            // 단일 옵션의 경우
            function getGoodsSimpleSaleValue($target, data) {
                getInputDataValue(data, $("[data-bind-value=customerPrice]", $target), $("[data-bind-value=customerPrice]", $target).val());
                getInputDataValue(data, $("[data-bind-value=supplyPrice]", $target), $("[data-bind-value=supplyPrice]", $target).val());
                getInputDataValue(data, $("[data-bind-value=salePrice]", $target), $("[data-bind-value=salePrice]", $target).val());
                getInputDataValue(data, $("[data-bind-value=stockQtt]", $target), $("[data-bind-value=stockQtt]", $target).val());
                getInputDataValue(data, $("[data-bind-value=saleStartDt]", $target), $("[data-bind-value=saleStartDt]", $target).val());
                getInputDataValue(data, $("[data-bind-value=saleEndDt]", $target), $("[data-bind-value=saleEndDt]", $target).val());
            }
            
            // 다중 옵션의 경우 - [상품저장.3]
            // 옵션만들기 레이어 팝업에서 설정된 정보를 반환(메인화면에서의 수정은 불가)
            function getGoodsMultiSaleValue($target, data) {
                // 단품 옵션 정보
                var goodsItemList = [];
                // 기준판매가 설정이 변경되었는지를 확인
                $("tr.goods_item", "#tbody_goods_item").each(function() {
                    var $this = $(this)
                      , $radio = $('input:radio[name=standardPriceYn]', $this)
                      , standardPriceYn = $radio.is(':checked') ? 'Y' : 'N'
                      , data = $this.data("goods_item");
                    
                    if(standardPriceYn !== data['standardPriceYn']) {
                        data['standardPriceYn'] = standardPriceYn;
                        if ('L' === data['registFlag']) {
                            data['registFlag'] = 'U';
                        }
                    }
                    $this.data("goods_item", data);
                    if ('L' !== data['registFlag']) {
                        goodsItemList.push(data);
                    }
                });
                // data['goodsItemList'] = $target.data("goods_item_info");
                
                data['goodsItemList'] = goodsItemList;
                // 옵션 정보 설정 
                data['optionList'] = $target.data("opt_data");
                // 옵션 생성 변경 FLAG
                data['changeFlagYn'] = true === $('#tb_goods_option').data('new_option_flag') ? 'Y' : 'N'; 
            }
            
            // 메인화면 적용 이벤트 (옵션만들기 팝업화면에서 적용하기 버튼 클릭시 이벤트)
            function fn_applyMainGoods() {
                var optDatas = loadOptData()
                  , goodsItemInfos = loadItemData();
                ;
                createMainOptionTable(optDatas, goodsItemInfos);
            }
            // 옵션 정보 생성
            function createGoodsOptionTable() {
               //기존 등록된 옵션 정보가 있는지 확인
                var $trData = $("tr.goods_item","#tbody_goods_item");
                if(null == $trData || $trData.length < 1) {                 
                    // 기존 임시 등록 정보 삭제
                    $("table", "#div_tb_goods_option").data("option_sel_info", null);
                    // 디폴트 팝업 화면 표시
                    $("#tr_item_template").hide();
                    $("#tr_no_item_data").show();
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
                var goodsItemData = [];
                
                // 단품 정보(ROW별) 처리
                $("tr.itemoption", $("#tbody_item")).each(function(idx, obj) {
                    var $text1 = $('input:text[name=attrValue1]', $(this))
                      , $text2 = $('input:text[name=attrValue2]', $(this))
                      , $text3 = $('input:text[name=attrValue3]', $(this))
                      , $text4 = $('input:text[name=attrValue4]', $(this));
                    
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
                            'standardPriceYn' : $("input:radio", $(this)).is(':checked') ? "Y":"N",
                            'useYn' :  'D' === $(this).data('data')['registFlag'] ? 'N' : 'Y',
                            'registFlag' : null != $(this).data('data')['registFlag'] ? $(this).data('data')['registFlag'] : 'I',
                        };
                    
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
                    goodsItemData.push(data);
                });

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
                        $optionTd.data('registFlag', registFlag);

                        if (false === flag) {
                            // 속성 데이터
                            var data = {
                                'attrNm' : textVal,
                                'preAttrNm' : prevValue,
                                'attrNo' : attrNo,
                                'optNo' : $th.data("optNo"),
                                'registFlag' : registFlag,
                            }
                            
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
                    }
                    
                    optDatas.push(optData);
                }); 

                return optDatas;
            }
            
            // 메인화면 옵션정보 작성
            function createMainOptionTable(optDatas, goodsItemInfos){
                $("#div_multi_option").data("opt_data", optDatas).data("goods_item_info", goodsItemInfos);
                // 화면을 디폴트화면으로 되돌림
                $("col.temItem, th.temItem, td.temItem","#tb_goods_item").remove();
                $("#col_dynamic_col").css('width', '30%');
                $("tr.goods_item", "tbody_goods_item").remove();
                
                var rowCnt = optDatas.length, width = 30 / rowCnt;
                $("#col_dynamic_col").css('width', width + '%');
                // 상품 단품정보 화면 생성 
                $.each(optDatas, function(idx, optData) {
                    if (0 === idx) {
                        var $th = $("#tr_goods_item_head_2").find('th').eq(0).addClass("optInfo").data("optNm", optData["optNm"]).html(optData["optNm"])
                          , $td = $("#td_dynamic_cols").attr("name", "td_attr1").addClass("optInfo");
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
                
                if ($('tr.goods_item:visible', '#tbody_goods_item').length > 0) {
                    $('#tr_no_goods_item').hide();
                } else {
                    $('#tr_no_goods_item').show();
                }
                
            }
            
            function createOptionInfoTable(data){
                // 화면을 디폴트화면으로 되돌림
                $("col.tempOpt, th.tempOpt, td.tempOpt","#tb_goods_option").remove();
                $("#col_pop_dynamic_col").css('width', '30%');
                
                var rowCnt = 0;
                $.each(data, function(idx, obj) {
                    if ('D' !== obj['registFlag']) {
                        rowCnt++;
                    }
                });
                var $table = $("#tb_goods_option").data("option_sel_info", data)
                  , width = 30 / rowCnt;
              
              $("#col_pop_dynamic_col").css('width', width + '%');
              $.each(data, function(idx, obj){
                  
                  // 옵션이 단수 일 경우
                  if (0 === idx) {
                      $("#th_pop_dynamic_cols").attr("colspan", 1);
                      var $th = $("#tr_pop_goods_item_head_2").find('th').eq(0).data('registFlag', obj['registFlag']).data("optNm", obj.optNm).data("optNo", obj.optNo).html( obj.optNm )
                      return true;
                  }
                  // 옵션이 복수 일 경우
                  var $col = $("#col_pop_dynamic_col").clone().show().removeAttr("id").css('width', width + '%').addClass("tempOpt")
                  , $th = $("#th_pop_dynamic_cols").attr("colspan", rowCnt)
                  , $th2 = $("#tr_pop_goods_item_head_2").find('th').eq(0).clone().show().removeAttr("id").addClass("tempOpt").data('registFlag', obj['registFlag']).data("optNm", obj.optNm).data("optNo", obj.optNo).html( obj.optNm )
                  , $td = $("#td_pop_dynamic_cols").clone().show().removeAttr("id").addClass("optionTd").addClass("tempOpt")
                          .html('<span class="intxt shot2"><input type="text" name="attrValue'+ (idx+1) +'" id="txt_attr'+ (idx+1) 
                          +'" data-bind="item_info" data-bind-type="text" data-bind-value="attrValue'+ (idx+1) 
                          +'" maxlength="50" data-validation-engine="validate[maxSize[50]]" ></span>');
                  
                  if ('D' == obj['registFlag']) {
                      $th2.hide();
                  } 
                  // COL TH TD 등 생성된 태그를 화면에 반영
                  $("#col_pop_dynamic_col").after($col);
                  $("#tr_pop_goods_item_head_2").append($th2);
                  $("#tr_item_template").find("td.optionTd").last().after($td);
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
                                    optValue3 = optValue3.split(",");
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
                
                // 옵션변경 팝업에서 받은 데이터를 화면에 바인딩
                $('[data-bind="item_info"]', $tmpItemTr).DataBinder(data);
                
                $("#tbody_item").append($tmpItemTr);
                
                // 추가된 ROW에 COMMA처리
                $('input.comma', "#tbody_item").mask("#,##0", {
                    reverse : true,
                    maxlength : false
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
                        $tr.data('data')['registFlag'] = 'D';
                        $tr.hide();
                    }
                    if ($("tr.itemoption", "#tb_goods_option").length < 1) {
                        $("#tr_no_item_data").show();
                    }
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
                if ('addOptUseYn' in data && 'Y' === data['addOptUseYn']) {                     
                    $.each(data.goodsAddOptionList, function(idx, addOpt) {
                        addOpt['registFlag'] = 'L';
                        fn_addAddOptionRow(addOpt);
                    });
                }
                // 읽어들인 추가옵션 정보가 없을 경우
                if ($('tr.add_option', '#tbody_add_option').length < 1) {
                    // 새로운 ROW 표시
                    fn_addAddOptionRow();
                }
            }
            
            // 추가옵션 정보 취득 - [상품저장.4]
            function getGoodsAddOptionValue($target) {
                var returnData = [];
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
                            goodsNo : $('#hd_goods_no').val(),
                            addOptNo : (prev_opt && 'addOptNo' in prev_opt) ? prev_opt['addOptNo'] : "",
                            addOptDtlSeq : (prev_data && 'addOptDtlSeq' in prev_data) ? prev_data['addOptDtlSeq'] : "",
                            addOptValue : $input1.val(), 
                            addOptAmt : $input2.val().trim().replaceAll(',', ''),
                            addOptAmtChgCd : $select0.val(),
                            optVer : (prev_data && 'optVer' in prev_data)  ? prev_data['optVer'] : "1",
                            registFlag : $input1.data('registFlag') ? $input1.data('registFlag') : "I",
                        };

                        if ( prev_data != null && 'L' === prev_data['registFlag']
                             && ( prev_data['addOptValue'] != data['addOptValue']
                                  || $input2.data('prev_value') != data['addOptAmt']
                                  || prev_data['addOptAmtChgCd'] != data['addOptAmtChgCd'])
                        ) {
                            data['registFlag'] = 'U';
                        }
                        addOptionValueList.push(data);
                    });
                    var optData = {
                        goodsNo : $('#hd_goods_no').val(),
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
                
                $td1.data("add_opt_no", null != data ? data.addOptNo : "").data("registFlag", null != data ? data.registFlag : "I").html(' <span class="intxt add_info" id="sp_opt_'+ nextIdx +'"><input type="text" name="addOptionNm'+ nextIdx +'" id="txt_add_option_nm'+ nextIdx +'"/></span> ');
                var addOptNm = (null != data && 'addOptNm' in data) ? data.addOptNm : "";
                $('input:last', $td1).val(addOptNm);                
                var btn = document.createElement('button');
                if (0 === nextIdx) {
                    $(btn).data("optIdx",  nextIdx).attr("id", "btn_del_opt_"+ nextIdx).addClass("btn_gray").html("추가").off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var addData =     {
                                "goodsNo": null != data ? data.goodsNo : '',
                                "registFlag": 'I',
                        }
                        fn_addAddOptionRow(addData);
                    });
                } else {
                    $(btn).data("optIdx",  nextIdx).attr("id", "btn_del_opt_"+ nextIdx).addClass("btn_gray").addClass("add_info").html("삭제").off("click").on('click', function(e) {
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
                
                if ( data && null != data.addOptionValueList && data.addOptionValueList.length > 0) {
                    $.each(data.addOptionValueList, function(idx, optDtl){
                        if (0 === idx) {
                            $td2.html(' <span class="intxt add_info" id="sp_opt_item'+ nextIdx +'_'+ idx + '"><input type="text" name="addOptionItemNm'+ nextIdx +'_'+ idx +'" id="txt_add_option_item_nm'+ nextIdx +'_' + idx + '"/></span> ');
                            $('input' , $td2)
                                .data('data', optDtl)
                                .data('prev_data', optDtl)
                                .data('registFlag', optDtl.registFlag)
                                .val(null != optDtl ? optDtl.addOptValue : '');
                            
                            var btn2 = document.createElement('button');
                            $(btn2).data("optIdx",  nextIdx).data("itemIdx", 0).attr("id", "btn_del_opt_item_"+ nextIdx + "_0").addClass("btn_gray").html("추가").off("click").on('click', function(e) {
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
                } else {
                    $td2.html(' <span class="intxt add_info" id="sp_opt_item'+ nextIdx +'_0"><input type="text" name="addOptionItemNm'+ nextIdx +'_0" id="txt_add_option_item_nm'+ nextIdx +'_0" /></span> ');
                    $('input' , $td2).data('data', null).data('prev_data', null).data('registFlag', 'I')
                    var btn2 = document.createElement('button');
                    $(btn2).data("optIdx",  nextIdx).data("itemIdx", 0).attr("id", "btn_del_opt_item_"+ nextIdx + "_0").addClass("btn_gray").html("추가").off("click").on('click', function(e) {
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
                          + '<input type="text" name="addOptionItemNm'+ itemKey + '" id="txt_add_option_item_nm'+ itemKey +'" />' 
                          + '</span> '
                  , html2 = "";
                var btn = document.createElement('button');
                $(btn).data("optIdx",  addOptionIdx).data("itemIdx", addOptionItemIdx)
                      .attr("id", "btn_del_opt_item_"+ itemKey).addClass("btn_gray").addClass("add_option")
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
                ;
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

                if ('relateGoodsApplyTypeCd' in data) {
                    var type = data['relateGoodsApplyTypeCd'];
                    switch(type) {
                        case '1' :
                            $('label[for=rdo_relateGoodsApplyTypeCd_'+ type +']', '#tbody_relate_goods').trigger('click');
                            setRelateGoodsCondition(data);
                            break;
                            
                        case '2' :
                            $('label[for=rdo_relateGoodsApplyTypeCd_'+ type +']', '#tbody_relate_goods').trigger('click');
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
            function getGoodsNotifyValue($target) {
                var returnData = []
                  , goodsNo = $('#hd_goods_no').val();
                $target.each(function(idx) {
                    var value = ($(this).val() && $(this).val().trim().length > 0) ? $(this).val().trim() : ''
                      , prevValue = null != $(this).data('prev_value') ? $(this).data('prev_value') : ''; 
                    var data = {
                        goodsNo : goodsNo,
                        notifyNo : $(this).data("notify-no"),
                        itemNo : $(this).attr("name"),
                        itemValue : value,
                        registFlag : prevValue !== value ? (prevValue !== '' && value === '') ? 'D':'U' : (prevValue !== '') ? 'L':'U',
                    } 
                    if ('L' !== data['registFlag'] && value.length > 0) {
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
                            var data = {
                                    idx : idx2,
                                    src : imgDtlData['thumbUrl'],
                                    type : imgDtlData['goodsImgType'],
                                    goodsImgsetNo : imgSetData['goodsImgsetNo'],
                                    imgPath : imgDtlData['imgPath'],
                                    imgNm : imgDtlData['imgNm'],
                                    imageUrl : imgDtlData['imgUrl'],
                                    imageWidth :  imgDtlData['imgWidth'],
                                    imageHeight :  imgDtlData['imgHeight'],
                                    registFlag : imgDtlData['registFlag'],
                                };
                            
                            $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + idx + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                            $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + idx + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                            
                        });
                    })
                }                
            }
            
            // 상품 이미지 세트 정보 취득
            function getGoodsImgSetValue($target) {
                var returnData = [];
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
                                goodsNo : $('#hd_goods_no').val(),
                                goodsImgsetNo : (prevData && 'goodsImgsetNo' in prevData) ? prevData['goodsImgsetNo'] : null,
                                tempFileNm : (imgData.tempFileName) ? imgData.tempFileName : '',
                                imgPath : (imgData.tempFileName) ? imgData.tempFileName.split("_")[0] : '',
                                imgNm : (imgData.tempFileName) ? imgData.tempFileName.split("_")[1] + '_' +imgData.tempFileName.split("_")[2] : '',
                                goodsImgType : imgData.type,
                                imgWidth : imgData.imageWidth,
                                imgHeight : imgData.imageHeight,
                                registFlag : 'I',
                            };
                            
                            goodsImageDtlList.push(data);
                        }
                    });

                    var data = {
                        goodsNo : $('#hd_goods_no').val(),
                        goodsImgsetNo : (prevData && 'goodsImgsetNo' in prevData) ? prevData['goodsImgsetNo'] : null,
                        dlgtImgYn : $radio.is(':checked') ? "Y":"N",
                        registFlag :(prevData && 'registFlag' in prevData) ? prevData['registFlag'] : 'I',
                        goodsImageDtlList : goodsImageDtlList
                    }
                    if (prevData && 'L' === data['registFlag']) {
                        if (prevData['dlgtImgYn'] !== data['dlgtImgYn']){
                            data['registFlag'] = 'U'
                        }
                    }
                    if ('L' !== data['registFlag'] || goodsImageDtlList.length > 0) {
                        returnData.push(data);
                    }
                });
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
                var type = $(obj).data("bind-param");
                if ( type === data.type) {
                    $(obj).data("img_data", data);
                }
                $(obj).off("click").on('click', function(e) {                    
                    Dmall.EventUtil.stopAnchorAction(e);
                    // 업로드 팝업에 현재 선택된 버튼의 정보를 설정
                    $("#hd_img_param_1").data("type", type).data("setIdx", $(this).closest("tr").data("setIdx")).val(type);
                    Dmall.LayerPopupUtil.open(jQuery('#layer_upload_image'));
                });
            }
            // 이미지 미리보기 버튼 클릭시 이벤트
            function previewRegistImage(data, obj, bindName, target, area, row) {
                var type = $(obj).data("bind-param");
                if (data && type === data.type) {
                    $(obj).data("img_data", data);
                    $(obj).off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        $("#img_preview_goods_image").attr("src", $(this).data("img_data").imageUrl).attr("width", $(this).data("img_data").imageWidth).attr("height",  $(this).data("img_data").imageHeight);
                        Dmall.LayerPopupUtil.open(jQuery('#layer_preview_upload_image'));
                    });
                }
            }
            // 업로드된 이미지 소스로 변경
            function setImageSrc(data, obj, bindName, target, area, row) {
                if ( obj.data("bind-param") == data.type ) {
                    obj.data("img_data", data).attr("src", data.src);
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
                getCategoryInfo('1', jQuery('#ul_ctg_1'));
                
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
                
                // 라디오버튼 디폴트 값 선택 
                // ( ** 실행순서 확인 필요 있음 - 상품데이터 조회 후 반영 결과 확인 필요 **)
                /*
                setDefaultRadioValue('goodsSaleStatusCd');
                setDefaultRadioValue('dispYn');
                setDefaultRadioValue('taxGbCd');
                setDefaultRadioValue('returnPsbYn');
                setDefaultRadioValue('minOrdLimitYn');
                setDefaultRadioValue('maxOrdLimitYn');
                setDefaultRadioValue('goodsSvmnPolicyUseYn');
                setDefaultRadioValue('addOptUseYn');
                // setDefaultRadioValue('dlgtImgYn');
                setDefaultRadioValue('dlvrSetCd');
                setDefaultRadioValue('relateGoodsApplyTypeCd');
                */
            }
            
            // 라디오 버튼 선택값이 없을 경우 디폴트 선택 설정
            function setDefaultRadioValue(name) {
                var $radios = $('input:radio[name='+ name +']')
                  , $radio = $radios.filter(':visible:first');
                // if($radios.is(':checked') === false) {                    
                    $('label[for='+ $radio.attr('id') +']').trigger('click') ;
                // }
            };
            
            // 화면생성에 필요한 기본 정보 취득
            function getDefaultDisplayInfo(editMode) {
                // alert('editMode :' + editMode);
                var url = '/admin/goods/default-display-info'
                  , param = {}
                  , flag = 'Y' === editMode ? true : false;
                //
                
                // 화면에 남아 있는 이전 정보 데이터 삭제
                $("#div_multi_option").data("opt_data", null).data("goods_item_info", null);
                $("#tb_goods_option").data("new_option_flag", false);
                $('input:text, textarea').val('');
                $('input:radio').each(function(){
                    setDefaultRadioValue($(this).attr('name'));
                });
                $('input:checkbox').each(function(){
                    var $obj = $(this);
                    $obj.removeAttr('checked');
                    $('label[for=' + $obj.attr('id') + ']', $obj.parent()).removeClass('on'); 
                });
                
                // $('tr.selectedCtg', $('#tbody_selected_ctg')).remove();
                // $("#tr_no_selected_ctg_template").show();
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 상품 이미지 정보(상품 상세 및 리스트 이미지 사이즈) 설정
                    createGoodImgInfo(result.data);
                    
                    createAdultCertifyInfo(result.data);
                    
                    // 브랜드정보 취득결과 설정
                    createGoodsBrand(result.data.brandList, $("#sel_goods_brand"));
                 
                    // 아이콘정보 취득결과 설정
                    createGoodsIcon(result.data.goodsIconList, $("#td_icon_info"));
                    
                    // 고시정보 셀렉트 설정
                    createGoodsNotifyOption(result.data.notifyOptionList);
                    
                    // 고시정보 취득결과 설정
                    createGoodsNotify(result.data.goodsNotifyItemList);
                    
                    if (true === flag) {
                        fn_getGoodsInfo($('#hd_goods_no').val());
                    }
                    
                });
            }
            // 상품 이미지 정보 설정
            function createGoodImgInfo(data) {
                var goodsDefaultImgWidth = 'goodsDefaultImgWidth' in data && data['goodsDefaultImgWidth'] ? data['goodsDefaultImgWidth'] : 240
                  , goodsDefaultImgHeight = 'goodsDefaultImgHeight' in data && data['goodsDefaultImgHeight'] ? data['goodsDefaultImgHeight'] : 240
                  , goodsListImgWidth = 'goodsListImgWidth' in data && data['goodsListImgWidth'] ? data['goodsListImgWidth'] : 90
                  , goodsListImgHeight = 'goodsListImgHeight' in data && data['goodsListImgHeight'] ? data['goodsListImgHeight'] : 90;
                  
                $('#hd_img_detail_width, #txt_goodsDefaultImgWidth').val(goodsDefaultImgWidth);
                $('#hd_img_detail_height, #txt_goodsDefaultImgHeight').val(goodsDefaultImgHeight);
                $('#hd_img_thumb_width, #txt_goodsListImgWidth').val(goodsListImgWidth);
                $('#hd_img_thumb_height, #txt_goodsListImgHeight').val(goodsListImgHeight);
                $('#th_image_size_detail').html(goodsDefaultImgWidth + '*' + goodsDefaultImgHeight);
                $('#th_image_size_list').html(goodsListImgWidth + '*' + goodsListImgHeight);
            }
            // 사이트 성인 인증 설정 여부 설정
            function createAdultCertifyInfo(data) {
                var isAdultCertifyConfig = 'isAdultCertifyConfig' in data && data['isAdultCertifyConfig'] ? data['isAdultCertifyConfig'] : 'N';
                  
                $('#chk_goods_adult_yn').data('isAdultCertifyConfig', isAdultCertifyConfig);
            }            
            
            // 브랜드정보 셀렉트 설정
            function createGoodsBrand(list, $sel) {
                $sel.find('option').not(':first').remove();
                $('label', $sel.parent()).text( $sel.find("option:first").text() );
                
                jQuery.each(list, function(idx, obj) {
                    $sel.append('<option value="'+ obj.brandNo + '">' + obj.brandNm + '</option>');
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
                     +'" data-notify-no="' + obj.notifyNo +'" name="' + obj.itemNo +'" data-bind="goods_notify_item" /></span></td>';
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
                
            /***** 상품 등록 정보 취득 - 시작 *****/
            function fn_getGoodsRegistData() {
                var goodsBasicData = getGoodsBasicValue($("tr[data-bind=basic_info]", "#tb_goods_basic_info"));
                
                goodsBasicData['goodsNo'] = $('#hd_goods_no').val();                

                // 단일옵션, 다중 옵션에 따른 분기 
                if("N" === $("#hd_multiOptYn").val()) {                    
                    // 단일 옵션 정보 취득
                    getGoodsSimpleSaleValue($("tr[data-bind=sale_info]", "#div_simple_option"), goodsBasicData);
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
                goodsBasicData['goodsAddOptionList']  = getGoodsAddOptionValue($("tr.add_option", "#tbody_add_option"));

                // 이미지 정보 취득
                goodsBasicData['goodsImageSetList'] = getGoodsImgSetValue($("tr.goods_image_set", "#tbody_goods_image_set"));

                // 상품 고시 정보 취득
                goodsBasicData['goodsNotifyList'] = getGoodsNotifyValue($("input[data-bind=goods_notify_item]", "#tbody_goods_notify"));

                return goodsBasicData;
            }
            
            // -2- 상품 기본 정보 취득
            function getGoodsBasicValue($target) {
                var returnData = {};
                getInputDataValue(returnData, $("[data-bind-value=goodsNo]", $target), $("[data-bind-value=goodsNo]", $target).val());
                getInputDataValue(returnData, $("[data-bind-value=goodsNm]", $target), $("[data-bind-value=goodsNm]", $target).val());
                getInputDataValue(returnData, $("[data-bind-value=prWords]", $target), $("[data-bind-value=prWords]", $target).val());
                
                getInputDataValue(returnData, $("[data-bind=goodsSaleStatusCd]", $target), $("input:radio[data-bind=goodsSaleStatusCd]:checked", $target).val());
                getInputDataValue(returnData, $("[data-bind-value=reinwareApplyYn]", $target), $("[data-bind-value=reinwareApplyYn]", $target).prop('checked') ? "Y" : "N");
                
                getInputDataValue(returnData, $("[data-bind=dispYn]", $target), $("input:radio[data-bind=dispYn]:checked", $target).val());
                getInputDataValue(returnData, $("[data-bind=taxGbCd]", $target), $("input:radio[data-bind=taxGbCd]:checked", $target).val());
                
                getInputDataValue(returnData, $("[data-bind-value=adultCertifyYn]", $target), $("[data-bind-value=adultCertifyYn]", $target).prop('checked') ? "Y" : "N");
                getInputDataValue(returnData, $("[data-bind-value=brandNo]", $target), $("select[data-bind-value=brandNo] option:selected", $target).val());
                
                getInputDataValue(returnData, $("input:checkbox.goodsIcon", $target), $("input:checkbox.goodsIcon", $target).val());
                getInputDataValue(returnData, $("[data-bind=returnPsbYn]", $target), $("input:radio[data-bind=returnPsbYn]:checked", $target).val());
                getInputDataValue(returnData, $("[data-bind=minOrdLimitYn]", $target), $("input:radio[data-bind=minOrdLimitYn]:checked", $target).val());
                getInputDataValue(returnData, $("[data-bind=maxOrdLimitYn]", $target), $("input:radio[data-bind=maxOrdLimitYn]:checked", $target).val());
                getInputDataValue(returnData, $("[data-bind=goodsSvmnPolicyUseYn]", $target), $("input:radio[data-bind=goodsSvmnPolicyUseYn]:checked", $target).val());
                getInputDataValue(returnData, $("[data-bind-value=hscode]", $target), $("[data-bind-value=hscode]", $target).val());
                getInputDataValue(returnData, $("#hd_multiOptYn"), $("#hd_multiOptYn").val());
                getInputDataValue(returnData, $("[data-bind=addOptUseYn]"), $("input:radio[data-bind=addOptUseYn]:checked").val());
                // 고시 정보 타입 설정
                getInputDataValue(returnData, $("[data-bind-value=notifyNo]", $('#tbody_goods_notify')), $("select[data-bind-value=notifyNo] option:selected", $('#tbody_goods_notify')).val());
                getInputDataValue(returnData, $("#hd_prev_goods_notify"), $("#sel_goods_notify").data('prev_value'));
                
                // 상품 동영상 정보 
                getInputDataValue(returnData, $("[data-bind-value=videoSourcePath]", '#tb_goods_video'), $("[data-bind-value=videoSourcePath]", '#tb_goods_video').val());
                
                return returnData;
            }
            
            function getInputDataValue(data, $target, value) {
                var _name = $target.attr("name")
                  , $target_parent = $("tr[data-bind=basic_info]", "#tb_goods_basic_info");
                
                if ("goodsIcon" === _name) {
                    var goodsIconData = new Array();
                    // 아이콘 체크 박스의 값이 이전과 다를 경우에만 저장 데이터에 설정
                    $target.each(function(idx) {
                        if ($(this).data('prev_value') != ($(this).prop('checked') ? "Y" : "N")) {
                            var iconData = {
                               "goodsNo" : $('#hd_goods_no').val(),
                               "iconNo" : $(this).data("icon_no"),
                               "useYn" : $(this).prop('checked') ? "Y" : "N"
                            };
                            goodsIconData.push(iconData);
                        }
                    });
                    data['goodsIconList'] = goodsIconData;
                } else if ("minOrdLimitYn" === _name && "Y" === value) {
                    data[_name] = value;
                    getInputDataValue(data, $("[data-bind-value=minOrdQtt]", $target_parent), $("[data-bind-value=minOrdQtt]", $target_parent).val());
                } else if ("maxOrdLimitYn" === _name && "Y" === value) {
                    data[_name] = value;
                    getInputDataValue(data, $("[data-bind-value=maxOrdQtt]", $target_parent), $("[data-bind-value=maxOrdQtt]", $target_parent).val());
                } else if ("goodsSvmnPolicyUseYn" === _name && "N" === value) {
                    data[_name] = value;
                    getInputDataValue(data, $("[data-bind-value=goodsSvmnAmt]", $target_parent), $("[data-bind-value=goodsSvmnAmt]", $target_parent).val());
                } else {
                    if ($target.hasClass('comma')) {
                        data[_name] = null == value? 0 : value.trim().replaceAll(',', '');
                    } else {
                        data[_name] = value;
                    } 
                }
            }
            
            // -6- 상품 배송정보 취득
            function getGoodDeliveryValue($target, returnData) {
                getInputDataValue(returnData, $("[data-bind-value=dlvrExpectDays]", $target), $("[data-bind-value=dlvrExpectDays]", $target).val());
                getInputDataValue(returnData, $("[data-bind=dlvrSetCd]", $target), $("input:radio[data-bind=dlvrSetCd]:checked", $target).val());
                if ("3" == returnData.dlvrSetCd) {
                    getInputDataValue(returnData, $("[data-bind-value=goodseachDlvrc]", $target), $("[data-bind-value=goodseachDlvrc]", $target).val());
                } else if("4" == returnData.dlvrSetCd) {
                    getInputDataValue(returnData, $("[data-bind-value=qtteachDlvrc]", $target), $("[data-bind-value=qtteachDlvrc]", $target).val());
                } else if("5" == returnData.dlvrSetCd) {
                    getInputDataValue(returnData, $("[data-bind-value=packMaxUnit]", $target), $("[data-bind-value=packMaxUnit]", $target).val());
                    getInputDataValue(returnData, $("[data-bind-value=packUnitDlvrc]", $target), $("[data-bind-value=packUnitDlvrc]", $target).val());
                    getInputDataValue(returnData, $("[data-bind-value=packUnitAddDlvrc]", $target), $("[data-bind-value=packUnitAddDlvrc]", $target).val());
                }
                getInputDataValue(returnData, $("[data-bind-value=couriDlvrApplyYn]", $target), $("[data-bind-value=couriDlvrApplyYn]", $target).prop('checked') ? "Y" : "N");
                getInputDataValue(returnData, $("[data-bind-value=postDlvrApplyYn]", $target), $("[data-bind-value=postDlvrApplyYn]", $target).prop('checked') ? "Y" : "N");
                getInputDataValue(returnData, $("[data-bind-value=quicksvcDlvrApplyYn]", $target), $("[data-bind-value=quicksvcDlvrApplyYn]", $target).prop('checked') ? "Y" : "N");
                getInputDataValue(returnData, $("[data-bind-value=directRecptApplyYn]", $target), $("[data-bind-value=directRecptApplyYn]", $target).prop('checked') ? "Y" : "N");
                getInputDataValue(returnData, $("[data-bind-value=txLimitCndt]", $target), $("[data-bind-value=txLimitCndt]", $target).val());
            }

            // -7- 관련상품 정보 취득
            function getGoodsRelateSetValue($target, returnData) {
                returnData['relateGoodsApplyTypeCd'] = $('input:radio[name=relateGoodsApplyTypeCd]:checked', '#tbody_relate_goods').val();
                
                switch(returnData.relateGoodsApplyTypeCd) {
                    case '1' :
                        var data = $('#div_display_relate_goods_condition').data('relate_condition');
                        if (data) {
                            returnData['relectsSelCtg1'] = data['selectCtg1'];
                            returnData['relectsSelCtg2'] = data['selectCtg2'];
                            returnData['relectsSelCtg3'] = data['selectCtg3'];
                            returnData['relectsSelCtg4'] = data['selectCtg4'];
                            returnData['relateGoodsApplyCtg'] = data['ctgNo'];
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
                            
                            if ('L' !== registFlag) {
                                var data = {
                                    'goodsNo' : $('#hd_goods_no').val(),
                                    'relateGoodsNo' : goodData['goodsNo'],
                                    'registFlag' : registFlag,
                                    'priorRank' : idx+1,
                                }
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
                    //
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
                    return;
                }
            }
                
            // 관련 상품 설정
            function fn_callback_pop_apply_goods(data) {
                // alert('상품 선택 팝업 리턴 결과 :' + data["goodsNo"] + ', data :' + JSON.stringify(data));
                
                // 상품 정보 li 생성
                var goodsNo = data.goodsNo
                  , isExist = false;
                $('li.relate_goods', '#ul_relate_goods').each(function() {
                    var $this = $(this);
                    // 이전에 선택되었던 관련상품은 삭제한다.(로직상 기존 정보 삭제후 재등록)
                    if ('L' ===  $this.data("registFlag")) {
                        $this.remove()
                    } else {
                        if (goodsNo ===  $this.data("goods_no")) {
                            isExist = true;
                            return false;
                        }
                    }
                });
                if (true === isExist) {
                    alert("이미 선택된 상품 입니다.");
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
                // 상품 선택에서 넘어오는 이미지가 임시 이미지 이므로 img160 로 설정함(실제 리스트용 이미지로 수정 필요)
                $("img", obj).attr("src", data.relateGoodsImg);
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
                    alert("상호등록 이벤트 클릭 - 상호등록 처리 타이밍은 저장시인지? 버튼 클릭시인지 확인 필요");
                });
            }
            
            /***** 관련 상품 설정 - 끝 *****/
            
            
            
            function fn_loadEditor() {
                Dmall.DaumEditor.init(); // 에디터 초기화 함수,
                Dmall.DaumEditor.create('ta_goods_content'); // Textarea를 에디터로 설정
                
                if ('Y' === '${resultModel.data.editModeYn}') {
                    getEditorDataInfo();
                }
            }
            
            function getEditorDataInfo() {
                Dmall.AjaxUtil.getJSON('/admin/goods/goods-contents', {'goodsNo':$('#hd_goods_no').val(), 'svcGbCd':'01'}, function(result) {

                    if (result.data) {
                        Dmall.DaumEditor.setContent('ta_goods_content', result.data.content); // 에디터에 데이터 세팅
                        Dmall.DaumEditor.setAttachedImage('ta_goods_content', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                    }
                })
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
                        alert("상품 옵션은 최대 4개까지 생성할 수 있습니다.");
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
                        } else {
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
                                  , field = messageArr.length > 1 ? messageArr[1] : ''
                                  , messageHead = index > -1 ? (index+1) + '번째 입력된 ' : '';
                                
                                switch (jsonobj) {
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
                                            default :
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
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
    <div class="sec01_box">
    
        <div class="tlt_box">
            <div class="btn_box left">
                <a href="#none" class="btn gray">상품리스트</a>
            </div>
            <h2 class="tlth2">판매상품관리</h2>
            <div class="btn_box right">
                <a href="#none" class="btn blue shot">미리보기</a>
                <a href="#none" id="btn_confirm" class="btn blue shot">저장하기</a>
            </div>
        </div>
        <!-- line_box -->
        <form name="form_goods_info" id="form_goods_info">
        <div class="line_box fri">
            <h3 class="tlth3">상품카테고리</h3>
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
                <a href="#none" class="btn green" id="btn_regist_ctg">카테고리 등록</a>
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
                                            <col width="85%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th class="txtc">대표분류</th>
                                                <th>분류명</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tbody_selected_ctg">
                                            <tr id="tr_selected_ctg_template">
                                                <td class="txtc">
                                                    <label for="radio01" class="radio"><span class="ico_comm">
                                                        <input type="radio" name="mainCategory" id="radio01" value="Y" />
                                                    </span></label>
                                                </td>
                                                <td>
                                                    <button class="btn_gray">삭제</button>
                                                </td>
                                            </tr>
                                            <tr id="tr_no_selected_ctg_template">
                                                <td class="txtc" colspan="2">선택된 카테고리가 없습니다.</td>
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
                상품 기본정보
                <div class="right">
                    <a href="#none" class="btn_gray2" id="btn_add_icon">아이콘 추가</a>
                </div>
            </h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table id="tb_goods_basic_info" summary="이표는 상품 기본정보 표 입니다. 구성은 상품번호, 상품코드, 상품명, 간단설명, 판매상태, 전시상태, 과세/비과세, 성인상품, 브랜드, 아이콘, 반품 가능 여부, 최소구매수량, 최대구매수량, 마켓포인트 설정, 수출입상품코드(HS코드) 입니다.">
                    <caption>상품 기본정보</caption>
                    <colgroup>
                        <col width="22%">
                        <col width="28%">
                        <col width="20%">
                        <col width="30%">
                    </colgroup>
                    <tbody>
                        <tr data-bind="basic_info" >
                            <th>상품번호</th>
                            <td colspan="3" id="td_goods_no">${resultModel.data.goodsNo}
                                <input type="hidden" id="hd_goods_no" name="goodsNo" value="${resultModel.data.goodsNo}" data-bind="goodsNo" />
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>상품명 <span class="important">*</span></th>
                            <td colspan="3"><span class="intxt wid100p"><input type="text" name="goodsNm" id="txt_goods_nm" data-bind="basic_info"  data-bind-type="text" data-bind-value="goodsNm" data-validation-engine="validate[required, maxSize[100]]"  /></span></td>
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
                            <th>판매상태</th>
                            <td colspan="3" data-bind="basic_info" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setLabelRadio">
                                <label for="rdo_goods_status_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="goodsSaleStatusCd" id="rdo_goods_status_1" value="1" data-bind="goodsSaleStatusCd" /></span> 판매중</label>
                                <label for="rdo_goods_status_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="goodsSaleStatusCd" id="rdo_goods_status_2" value="2" data-bind="goodsSaleStatusCd" /></span> 품절</label>
                                <label for="rdo_goods_status_3" class="radio mr20"><span class="ico_comm"><input type="radio" name="goodsSaleStatusCd" id="rdo_goods_status_3" value="3" data-bind="goodsSaleStatusCd" /></span> 판매대기</label>
                                <label for="rdo_goods_status_4" class="radio mr20"><span class="ico_comm"><input type="radio" name="goodsSaleStatusCd" id="rdo_goods_status_4" value="4" data-bind="goodsSaleStatusCd" /></span> 판매중지</label>
                                
                                <span>
                                    <input type="checkbox" name="reinwareApplyYn" id="chk_goods_notify_yn" class="blind" value="Y" data-bind="basic_info" data-bind-value="reinwareApplyYn" data-bind-type="function" data-bind-function="setLabelCheckbox" />
                                    <label for="chk_goods_notify_yn" class="chack mr20" >
                                        <span class="ico_comm">&nbsp;</span>
                                        재입고 알림 사용
                                    </label>
                                </span>
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>전시상태</th>
                            <td colspan="3" data-bind="basic_info" data-bind-value="dispYn" data-bind-type="function" data-bind-function="setLabelRadio" >
                                <label for="rdo_goods_display_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispYn" id="rdo_goods_display_Y" value="Y" data-bind="dispYn" /></span> 전시</label>
                                <label for="rdo_goods_display_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispYn" id="rdo_goods_display_N" value="N" data-bind="dispYn" /></span> 미전시</label>
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>과세/비과세</th>
                            <td data-bind="basic_info" data-bind-value="taxGbCd" data-bind-type="function" data-bind-function="setLabelRadio">
                                <label for="rdo_goods_tax_cd_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="taxGbCd" id="rdo_goods_tax_cd_1" value="1" data-bind="taxGbCd" /></span> 과세</label>
                                <label for="rdo_goods_tax_cd_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="taxGbCd" id="rdo_goods_tax_cd_2" value="2" data-bind="taxGbCd" /></span> 비과세</label>
                            </td>
                            <th class="line">성인상품</th>
                            <td>
                                <input type="checkbox" name="adultCertifyYn" id="chk_goods_adult_yn" class="blind" value="Y" data-bind="basic_info" data-bind-type="function" data-bind-function="setLabelCheckbox"  data-bind-value="adultCertifyYn"  disabled/>
                                <label id="lb_goods_adult_yn" for="chk_goods_adult_yn" class="chack mr20" >
                                    <span class="ico_comm">&nbsp;</span>
                                    성인만 구매 가능
                                </label>
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>브랜드</th>
                            <td>
                                <span class="select">
                                    <label for="">브랜드 선택</label>
                                    <select name="brandNo" id="sel_goods_brand" data-bind="basic_info" data-bind-value="brandNo" data-bind-type="labelselect">
                                        <option value="">브랜드 선택</option>
                                    </select>
                                </span>
                            </td>
                            <th class="line">아이콘</th>
                            <td id="td_icon_info" data-bind="basic_info" data-bind-type="function" data-bind-function="setIconList"  data-bind-value="goodsIconList">
                                <span id="span_icon_template" style="display:none">
                                    <input type="checkbox" name="goodsIconTemp" id="chack03_1" class="blind" />
                                    <label for="chack03_1" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        <img src="/admin/img/product/ico_col1.png" alt="신상품">
                                    </label>
                                </span>
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>반품 가능 여부</th>
                            <td colspan="3" data-bind="basic_info" data-bind-value="returnPsbYn" data-bind-type="function" data-bind-function="setLabelRadio">
                                <label for="rdo_goods_return_yn_y" class="radio mr20"><span class="ico_comm"><input type="radio" name="returnPsbYn" id="rdo_goods_return_yn_y" value="Y" data-bind="returnPsbYn" /></span> 반품가능</label>
                                <label for="rdo_goods_return_yn_n" class="radio mr20"><span class="ico_comm"><input type="radio" name="returnPsbYn" id="rdo_goods_return_yn_n" value="N" data-bind="returnPsbYn" /></span> 반품 불가능</label>
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>최소구매수량</th>
                            <td colspan="3" data-bind="basic_info" data-bind-value="minOrdLimitYn" data-bind-type="function" data-bind-function="setLabelRadio">
                                <label for="rdo_min_ord_limit_yn_y" class="radio mr20"><span class="ico_comm"><input type="radio" name="minOrdLimitYn" id="rdo_min_ord_limit_yn_y" value="N" data-bind="minOrdLimitYn"/></span> 제한없음</label>
                                <label for="rdo_min_ord_limit_yn_n" class="radio mr20"><span class="ico_comm"><input type="radio" name="minOrdLimitYn" id="rdo_min_ord_limit_yn_n" value="Y" data-bind="minOrdLimitYn"/></span> 제한함</label>
                                <span class="intxt"><input type="text" class="comma" name="minOrdQtt" id="txt_min_ord_qtt" data-bind="basic_info"  data-bind-type="textcomma" data-bind-value="minOrdQtt" data-validation-engine="validate[maxSize[12]]"  /></span>
                                개 이상 구매 가능
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>최대구매수량</th>
                            <td colspan="3" data-bind="basic_info" data-bind-value="maxOrdLimitYn" data-bind-type="function" data-bind-function="setLabelRadio">
                                <label for="rdo_max_ord_limit_yn_y" class="radio mr20"><span class="ico_comm"><input type="radio" name="maxOrdLimitYn" id="rdo_max_ord_limit_yn_y" value="N" data-bind="maxOrdLimitYn"/></span> 제한없음</label>
                                <label for="rdo_max_ord_limit_yn_n" class="radio mr20"><span class="ico_comm"><input type="radio" name="maxOrdLimitYn" id="rdo_max_ord_limit_yn_n" value="Y" data-bind="maxOrdLimitYn"/></span> 제한함</label>
                                최대
                                <span class="intxt"><input type="text" class="comma" name="maxOrdQtt" id="txt_max_ord_qtt" data-bind="basic_info"  data-bind-type="textcomma" data-bind-value="maxOrdQtt" data-validation-engine="validate[maxSize[12]]" /></span>
                                개 까지 구매 가능
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>마켓포인트 설정</th>
                            <td colspan="3" data-bind="basic_info" data-bind-value="goodsSvmnPolicyUseYn" data-bind-type="function" data-bind-function="setLabelRadio">
                                <label for="rdo_goods_policy_use_yn_y" class="radio"><span class="ico_comm"><input type="radio" name="goodsSvmnPolicyUseYn" id="rdo_goods_policy_use_yn_y" value="Y" data-bind="goodsSvmnPolicyUseYn" /></span> 기본 마켓포인트 정책 사용</label>
                                <span class="point_c3">[설정 > 기본관리 > 마켓포인트 설정]</span>에 설정된 마켓포인트 지급 정책 사용
                                <span class="br"></span>
                                <label for="rdo_goods_policy_use_yn_n" class="radio"><span class="ico_comm"><input type="radio" name="goodsSvmnPolicyUseYn" id="rdo_goods_policy_use_yn_n" value="N" data-bind="goodsSvmnPolicyUseYn" /></span> 개별 마켓포인트 사용</label>
                                <span class="intxt"><input type="text" class="comma" name="goodsSvmnAmt" id="txt_goods_svmn_amt" data-bind="basic_info"  data-bind-type="textcomma" data-bind-value="goodsSvmnAmt" data-validation-engine="validate[maxSize[12]]" /></span> 원
                            </td>
                        </tr>
                        <tr data-bind="basic_info">
                            <th>수출입상품코드(HS코드)</th>
                            <td colspan="3">
                                <span class="intxt"><input type="text" name="hscode" id="txt_hscode" data-bind="basic_info" data-bind-type="text" data-bind-value="hscode" data-validation-engine="validate[maxSize[12]]" /></span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
            <!-- change_tbl -->
            <div id="div_simple_option" class="change_tbl" style="display:block;">
                <h3 class="tlth3  btn1">
                    상품 판매정보
                    <div class="left">
                        <a href="#none" id="btn_stck_history" class="btn_gray2">재고 변경 이력</a>
                        <a href="#none" id="btn_multi_option" class="btn_gray2">다중 옵션 판매</a>
                        <input type="hidden" id="hd_multiOptYn" name="multiOptYn" value="N" data-bind="multiOptYn" />
                    </div>
                </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 상품 판매정보 표 입니다. 구성은 소비자가격, 공급가격, 판매가격, 재고, 상품 판매기간 입니다.">
                        <caption>상품 판매정보</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="35%">
                            <col width="15%">
                            <col width="35%">
                        </colgroup>
                        <tbody>
                            <tr data-bind="sale_info">
                                <th>소비자가격</th>
                                <td><span class="intxt"><input type="text" class="comma" name="customerPrice" id="txt_customer_price" data-bind="basic_info" data-bind-type="textcomma" data-bind-value="customerPrice" data-validation-engine="validate[maxSize[10]]" maxlength="10" /></span> 원</td>
                                <th class="line">공급가격</th>
                                <td><span class="intxt"><input type="text" class="comma" name="supplyPrice" id="txt_supply_price" data-bind="basic_info" data-bind-type="textcomma" data-bind-value="supplyPrice" data-validation-engine="validate[maxSize[10]]" maxlength="10" /></span> 원</td>
                            </tr>
                            <tr data-bind="sale_info">
                                <th>판매가격 <span class="important">*</span></th>
                                <td><span class="intxt"><input type="text" class="comma" name="salePrice" id="txt_sale_price" data-bind="basic_info" data-bind-type="textcomma" data-bind-value="salePrice" data-validation-engine="validate[required, maxSize[10]]" maxlength="10" /></span> 원</td>
                                <th class="line">재고</th>
                                <td><span class="intxt"><input type="text" class="comma" name="stockQtt" id="txt_stock_qtt" data-bind="basic_info" data-bind-type="textcomma" data-bind-value="stockQtt" data-validation-engine="validate[required, maxSize[4]]" maxlength="4"  /></span></td>
                            </tr>
                            <tr data-bind="sale_info">
                                <th>상품 판매기간</th>
                                <td colspan="3">
                                    <span class="intxt"><input type="text" class="date" name="saleStartDt" id="txt_sale_start_dt" data-bind="basic_info" data-bind-type="text" data-bind-value="saleStartDt" data-validation-engine="validate[dateFormat, maxSize[10]]"/></span>
                                    <a href="#calendar" class="date_sc ico_comm">달력이미지</a>
                                    ~
                                    <span class="intxt"><input type="text" class="date" name="saleEndDt" id="txt_sale_end_dt" data-bind="basic_info" data-bind-type="text" data-bind-value="saleEndDt" data-validation-engine="validate[dateFormat, maxSize[10]]"/></span>
                                    <a href="#calendar" class="date_sc ico_comm">달력이미지</a>
                                    <span class="br"></span>
                                    ※ 판매기간 설정 시 설정된 기간 동안만 판매되며, 종료일 이후 해당 상품은 판매 종료 처리됩니다
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- // change_tbl -->
            <!-- change_tbl -->
            <div id="div_multi_option" class="change_tbl" style="display:none;">
                <h3 class="tlth3 btn1">
                    상품 판매정보
                    <a href="#none" class="btn_gray2" id="btn_create_goods_option">옵션 만들기</a>
                    <a href="#none" class="btn_gray2" id="btn_preview_option">옵션 미리보기</a>
                    <div class="right">
                        <a href="#none" id="btn_simple_option" class="btn_gray2">단일 옵션 판매</a>
                    </div>
                </h3>
                <!-- tblh -->
                <div class="tblh th_l tblmany">
                    <table id="tb_goods_item" summary="이표는 상품 판매정보 표 입니다. 구성은 기준판매가, 옵션(옵션1,옵션2), 소비자가, 공급가, 판매가, 재고(가용) 입니다.">
                        <caption>상품 판매정보</caption>
                        <colgroup>
                            <col width="14%">
                            <col width="30%" id="col_dynamic_col">
                            <col width="14%">
                            <col width="14%">
                            <col width="14%">
                            <col width="14%">
                        </colgroup>
                        <thead>
                            <tr id="tr_goods_item_head_1">
                                <th rowspan="2">기준판매가</th>
                                <th colspan="1" class="line_b" id="th_dynamic_cols">옵션</th>
                                <th rowspan="2">소비자가</th>
                                <th rowspan="2">공급가</th>
                                <th rowspan="2">판매가</th>
                                <th rowspan="2">재고(가용)</th>
                            </tr>
                            <tr id="tr_goods_item_head_2">
                                <th class="line_l">옵션1</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_goods_item">
                            <tr id="tr_no_goods_item"><td colspan="6">데이터가 없습니다.</td></tr>
                            <tr data-bind="sale_info" id="tr_goods_item_template" style="display:none">
                                <%-- <td data-bind="goods_item_info" data-bind-type="string" data-bind-value="standardPriceYn" ></td> --%>
                                <td data-bind="goods_item_info" data-bind-type="function" data-bind-value="standardPriceYn" data-bind-function="setStandardPriceYnMain">
                                    <label for="rdo_standardPriceYn" class="radio mr20"><span class="ico_comm">
                                        <input type="radio" name="standardPriceYn" id="rdo_standardPriceYn" />
                                    </span> </label>
                                </td> 
                                <td id="td_dynamic_cols" name="td_dynamic_cols" data-bind="goods_item_info" data-bind-type="string" data-bind-value="attrValue1"></td>
                                <td name="td_customerPrice" data-bind="goods_item_info" data-bind-type="commanumber" data-bind-value="customerPrice"></td>
                                <td name="td_supplyPrice" data-bind="goods_item_info" data-bind-type="commanumber" data-bind-value="supplyPrice"></td>
                                <td name="td_salePrice" data-bind="goods_item_info" data-bind-type="commanumber" data-bind-value="salePrice"></td>
                                <td name="td_stockQtt" data-bind="goods_item_info" data-bind-type="commanumber" data-bind-value="stockQtt"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
            </div>
            <!-- // change_tbl -->
            <h3 class="tlth3">추가 옵션 설정</h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table summary="이표는 추가 옵션 설정 표 입니다. 구성은 추가옵션, 옵션명, 옵션값, 옵션금액, 필수 입니다.">
                    <caption>추가 옵션 설정</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tbody id="tbody_add_option_set">
                        <tr>
                            <th>추가옵션</th>
                            <td data-bind="add_opt_info" data-bind-value="addOptUseYn" data-bind-type="function" data-bind-function="setLabelRadio">
                                <label for="rdo_add_opt_use_yn_n" class="radio mr20"><span class="ico_comm"><input type="radio" name="addOptUseYn" id="rdo_add_opt_use_yn_n" value="N" data-bind="addOptUseYn"  /></span> 사용안함</label>
                                <label for="rdo_add_opt_use_yn_y" class="radio mr20"><span class="ico_comm"><input type="radio" name="addOptUseYn" id="rdo_add_opt_use_yn_y" value="Y" data-bind="addOptUseYn"  /></span> 사용함</label>
                                <span class="br"></span>
                                재고와 연동되지 않는 추가 상품을 등록하실 수 있습니다
                                <span class="br"></span>
                                <!-- tblw_b -->
                                <div class="tblw_b">
                                    <table summary="">
                                        <caption></caption>
                                        <colgroup>
                                            <col width="30%">
                                            <col width="30%">
                                            <col width="30%">
                                            <col width="10%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>옵션명</th>
                                                <th>옵션값</th>
                                                <th>옵션금액</th>
                                                <th>필수</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tbody_add_option">
                                            <tr id="tr_add_option_template">
                                                <td>
                                                </td>
                                                <td>
                                                    <span class="intxt"><input type="text" value="" id="" /></span>
                                                    <button class="btn_gray">추가</button>
                                                </td>
                                                <td>
                                                    <span class="select one" id="sp_sel_add_option_price_cd_template">
                                                        <label for="">+</label>
                                                        <select name="" id="">
                                                            <tags:option codeStr="1:+;2:-" />
                                                        </select>
                                                    </span>
                                                    <span class="intxt" id="sp_add_option_price_template"><input type="text" class="comma" value="" data-validation-engine="validate[maxSize[10]]" maxlength="10" /></span>
                                                </td>
                                                <td>
                                                    <input type="checkbox" name="requiredYn" id="chk_add_option_requiredYn" class="blind" />
                                                    <label for="chk_add_option_requiredYn" class="chack" id="">
                                                        <span class="ico_comm">&nbsp;</span>
                                                    </label>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!-- //tblw_b -->
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->

            </form>
            
            <form name="form_goods_detail_info" id="form_goods_detail_info">
                <h3 class="tlth3">상품 상세 설명</h3>
                <div class="edit tblmany">
                    <textarea id="ta_goods_content" name="content" class="blind"></textarea>
                    <input type="hidden" id="hd_svcGbCd" name="svcGbCd" value="01" />
                    <input type="hidden" id="hd_goods_no2" name="goodsNo" value="${resultModel.data.goodsNo}" data-bind="goodsNo" />
                </div> 
            </form>
            
            <form name="form_goods_info2" id="form_goods_info2">
            <h3 class="tlth3">
                상품 이미지
                <div class="right">
                    <a href="#none" class="btn_gray2 change_btn" id="btn_set_goods_image_size">사이즈 설정</a>
                </div>
            </h3>
            <!-- tblh th_l -->
            <div class="tblh th_l tblmany">
                <table id="tb_goods_image_set" summary="이표는 상품 이미지 표 입니다. 구성은 상품컷, 사진등록, 확대이미지(500*500), 상품상세(기본)(240*240), 상품상세(중소)(130*130), 리스트 썸내일(90*90), 추천목록(50*50) 입니다.">
                    <caption>상품 이미지</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="15%">
                        <col width="14%">
                        <col width="14%">
                        <col width="14%">
                        <col width="14%">
                        <col width="14%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2">상품컷</th>
                            <th rowspan="2">사진등록</th>
                            <th class="line_b">확대 이미지</th>
                            <th class="line_b">상품상세 (기본)</th>
                            <th class="line_b">상품상세 (중소)</th>
                            <th class="line_b">리스트 썸네일</th>
                            <th class="line_b">추천목록</th>
                        </tr>
                        <tr>
                            <th class="line_l fwn">500*500</th>
                            <th class="fwn" id="th_image_size_detail">240*240</th>
                            <th class="fwn">130*130</th>
                            <th class="fwn" id="th_image_size_list">90*90</th>
                            <th class="fwn">50*50</th>
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
                                    data-bind-param="01" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param="02" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param="03" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param="04" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param="05" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                            <td><img src="/admin/img/product/tmp_img01.png" width="110" height="110" alt="" 
                                    data-bind-param="06" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setImageSrc"/></td>
                        </tr>
                        <tr id="tr_goods_image_template_2">
                            <td class="line_l"><a href="#none" class="btn_blue" data-bind-param="01" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage" >일괄등록</a></td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param="02" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <span class="br2"></span>
                                <a href="#none" class="btn_gray" data-bind-param="02" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="previewRegistImage">미리보기 <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param="03" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <span class="br2"></span>
                                <a href="#none" class="btn_gray" data-bind-param="03" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="previewRegistImage">미리보기 <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param="04" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <span class="br2"></span>
                                <a href="#none" class="btn_gray" data-bind-param="04" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="previewRegistImage">미리보기 <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param="05" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <span class="br2"></span>
                                <a href="#none" class="btn_gray" data-bind-param="05" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="previewRegistImage">미리보기 <span class="ico_comm readgl"></span></a>
                            </td>
                            <td>
                                <a href="#none" class="btn_gray" data-bind-param="06" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="setRegistImage">개별등록</a>
                                <span class="br2"></span>
                                <a href="#none" class="btn_gray" data-bind-param="06" data-bind-type="function" data-bind="image_info" data-bind-value="idx" data-bind-function="previewRegistImage">미리보기 <span class="ico_comm readgl"></span></a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblh th_l -->
            <!-- tblw -->
            <div class="tblw tblmany">
                <table id="tb_goods_video" summary="이표는 동영상 등록 표 입니다. 구성은 동영상, youtube 동영상 소스 등록 입니다.">
                    <caption>동영상 등록</caption>
                    <colgroup>
                        <col width="25%">
                        <col width="75%">
                    </colgroup>
                    <tbody>
<%--                         
                        <tr>
                            <th>동영상</th>
                            <td>
                                <span class="intxt"><input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled"></span>
                                <label class="filebtn" for="ex_file1">파일찾기</label>
                                <input class="filebox" type="file" id="ex_file1" onChange="javascript:document.getElementById('file_route1').value=this.value">
                            </td>
                        </tr> 
--%>
                        <tr>
                            <th>youtube 동영상 소스 등록</th>
                            <td><span class="intxt wid100p"><input type="text" name="videoSourcePath" id="txt_videoSourcePath" data-bind="basic_info" data-bind-type="text" data-bind-value="videoSourcePath" data-validation-engine="validate[url, maxSize[200]]" maxlength="200" /></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
            <h3 class="tlth3">상품 배송정보</h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table id="tb_goods_delivery" summary="이표는 상품 배송정보 표 입니다. 구성은 예상 배송 소요일, 배송비설정, 요청상품 배송방법, 요청상품 거래제한조건 입니다.">
                    <caption>상품 배송정보</caption>
                    <colgroup>
                        <col width="25%">
                        <col width="75%">
                    </colgroup>
                    <tbody id="tbody_goods_delivery">
                        <tr data-bind="delivery_info">
                            <th>예상배송소요일</th>
                            <td><span class="intxt shot"><input type="text" class="numeric" name="dlvrExpectDays" id="txt_dlvr_expect_days" data-bind="delivery_info" data-bind-type="text" data-bind-value="dlvrExpectDays" data-validation-engine="validate[maxSize[3]]" maxlength="3" /></span> 일</td>
                        </tr>
                        <tr data-bind="delivery_info" >
                            <th>배송비 설정</th>
                            <td>
                                <div id="div_delivery_info" class="txtind_box parcel" data-bind="delivery_info" data-bind-value="dlvrSetCd" data-bind-type="function" data-bind-function="setLabelRadio">
                                    <label for="rdo_dlvr_set_cd_1" class="radio left"><span class="ico_comm">
                                        <input type="radio" name="dlvrSetCd" value="1" id="rdo_dlvr_set_cd_1" data-bind="dlvrSetCd" >
                                    </span> 기본 배송비</label>
                                    <div class="right">기본 배송비 정책</div>
                                    <span class="br"></span>
                                    <label for="rdo_dlvr_set_cd_2" class="radio left "><span class="ico_comm">
                                        <input type="radio" name="dlvrSetCd" value="2" id="rdo_dlvr_set_cd_2" data-bind="dlvrSetCd" >
                                    </span> 상품별 배송비(무료)</label>
                                    <div class="right">배송비를 판매자가 부담하게 됩니다.</div>
                                    <span class="br"></span>
                                    <label for="rdo_dlvr_set_cd_3" class="radio left "><span class="ico_comm">
                                        <input type="radio" name="dlvrSetCd" value="3" id="rdo_dlvr_set_cd_3" data-bind="dlvrSetCd" >
                                    </span> 상품별 배송비(유료)</label>
                                    <div class="right">
                                        개수와 상관없이 배송비 <span class="intxt shot">
                                        <input type="text" class="comma" name="goodseachDlvrc" id="txt_goods_each_dlvrc" data-bind="delivery_info" data-bind-type="textcomma" data-bind-value="goodseachDlvrc" data-validation-engine="validate[maxSize[10]]" maxlength="10"  >
                                    </span> 원
                                    </div>
                                    <span class="br"></span>
                                    <label for="rdo_dlvr_set_cd_4" class="radio left "><span class="ico_comm">
                                        <input type="radio" name="dlvrSetCd" value="4" id="rdo_dlvr_set_cd_4" data-bind="dlvrSetCd" >
                                    </span> 상품별 배송비(유료)</label>
                                    <div class="right">
                                        <span class="intxt shot">
                                            <input type="text shot" class="comma"  name="qtteachDlvrc" id="txt_qtt_each_dlvrc" data-bind="delivery_info" data-bind-type="textcomma" data-bind-value="qtteachDlvrc" data-validation-engine="validate[maxSize[10]]" maxlength="10" >
                                        </span> 원 상품 수량에 따라 x N으로 배송비가 부과됩니다.
                                    </div>
                                    <span class="br"></span>
                                    <label for="rdo_dlvr_set_cd_5" class="radio left "><span class="ico_comm">
                                        <input type="radio" name="dlvrSetCd" value="5" id="rdo_dlvr_set_cd_5" data-bind="dlvrSetCd" >
                                    </span> 포장단위별 배송비</label>
                                    <div class="right">
                                        포장 최대단위는 상품 <span class="intxt shot">
                                            <input type="text" name="packMaxUnit" class="comma" id="txt_pack_max_unit" data-bind="delivery_info" data-bind-type="textcomma" data-bind-value="packMaxUnit" data-validation-engine="validate[maxSize[6]]" maxlength="6" >
                                        </span> 개 이며, 배송비 <span class="intxt shot">
                                            <input type="text" name="packUnitDlvrc" class="comma" id="txt_pack_unit_dlvrc" data-bind="delivery_info" data-bind-type="textcomma" data-bind-value="packUnitDlvrc" data-validation-engine="validate[maxSize[10]]" maxlength="10" >
                                        </span> 원
                                        <span class="br2"></span>
                                        또한 포장 단위별 추가 배송비 <span class="intxt shot">
                                            <input type="text" name="packUnitAddDlvrc" class="comma" id="txt_pack_unit_add_dlvrc" data-bind="delivery_info" data-bind-type="textcomma" data-bind-value="packUnitAddDlvrc" data-validation-engine="validate[maxSize[10]]" maxlength="10" >
                                        </span> 원
                                        <span class="br2"></span>
                                        ex) 택배 포장단위 별 최대 3개까지 2,500원 추가 3개당 2,500원
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr data-bind="delivery_info">
                            <th>요청상품 배송방법</th>
                            <td>
                                <input type="checkbox" name="couriDlvrApplyYn" id="chk_couri_dlvr_apply_yn" class="blind" value="Y" data-bind="delivery_info" data-bind-type="function" data-bind-function="setLabelCheckbox" data-bind-value="couriDlvrApplyYn" />
                                <label for="chk_couri_dlvr_apply_yn" class="chack mr20" >
                                    <span class="ico_comm">&nbsp;</span>
                                    택배배송
                                </label>
                                <input type="checkbox" name="postDlvrApplyYn" id="chk_post_dlvr_apply_yn" class="blind" value="Y" data-bind="delivery_info" data-bind-type="function" data-bind-function="setLabelCheckbox" data-bind-value="postDlvrApplyYn" />
                                <label for="chk_post_dlvr_apply_yn" class="chack mr20" >
                                    <span class="ico_comm">&nbsp;</span>
                                    우편배송
                                </label>
                                <input type="checkbox" name="quicksvcDlvrApplyYn" id="chk_quicksvc_dlvr_apply_yn" class="blind" value="Y" data-bind="delivery_info" data-bind-type="function" data-bind-function="setLabelCheckbox" data-bind-value="quicksvcDlvrApplyYn" />
                                <label for="chk_quicksvc_dlvr_apply_yn" class="chack mr20" >
                                    <span class="ico_comm">&nbsp;</span>
                                    퀵서비스
                                </label>
                                <span class="br"></span>
                                <input type="checkbox" name="directRecptApplyYn" id="chk_direct_recpt_apply_yn" class="blind" value="Y" data-bind="delivery_info" data-bind-type="function" data-bind-function="setLabelCheckbox" data-bind-value="directRecptApplyYn"  />
                                <label for="chk_direct_recpt_apply_yn" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                    직접수령
                                </label>
                                (직접수령 가능 상품에 한하여 선택해주세요)
                            </td>
                        </tr>
                        <tr data-bind="delivery_info">
                            <th>요청상품 거래 제한 조건</th>
                            <td>
                                <div class="txt_area">
                                    <textarea name="txLimitCndt" id="ta_txLimitCndt" data-bind="delivery_info" data-bind-type="text" data-bind-value="txLimitCndt" data-validation-engine="validate[maxSize[200]]" maxlength="200"></textarea>
                                </div>
                                <span class="br"></span>
                                ※ 기타 거래제한조건과 함께 상품배송이 불가능한 지역이 있으시면 필히 명시해 주십시오
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
            <h3 class="tlth3">관련상품</h3>
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
            <h3 class="tlth3">전자상거래 등에서의 상품정보제공 고시</h3>
            <!-- tblh -->
            <div class="tblh">
                <table summary="이표는 전자상거래 등에서의 상품정보제공 고시 리스트 표 입니다. 구성은 품목, 항목, 정보 입니다.">
                    <caption>전자상거래 등에서의 상품정보제공 고시 리스트</caption>
                    <colgroup>
                        <col width="34%">
                        <col width="33%">
                        <col width="33%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>품목</th>
                            <th>항목</th>
                            <th>정보</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_goods_notify">
                        <tr id="tr_goods_notify_0">
                            <td rowspan="40">
                                <span class="select wid_p100p">
                                    <label id="lb_goods_notify" for="sel_goods_notify"></label>
                                    <select name="notifyNo" id="sel_goods_notify" data-bind="basic_info" data-bind-value="notifyNo" >
                                    </select>
                                    <input type="hidden" value="" id="hd_prev_goods_notify" name="prevGoodsNotifyNo" />
                                </span>
                            </td>
                            <td class="goods_notify"></td>
                            <td class="goods_notify"><span class="intxt wid100p">
                                <input type="text" value="" id="" />
                            </span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblh -->
            <div class="bottom_lay">
                <div class="right">
                    <a href="none" class="btn_gray2">저장하기</a>
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
                                    <option value="01">최근 등록 된 옵션</option>
                                </select>
                            </span>
                            <a href="#none" class="btn_gray2" id="btn_load_option">불러오기</a>
                            또는
                            <a href="#none" class="btn_gray2" id="btn_create_option">생성 및 변경</a>
                        </div>
                        <!-- select_top -->
                        <!-- tblh -->
                        <div id="div_tb_goods_option" class="tblh th_l mt0 pm_btn">
                            <table id="tb_goods_option" summary="이표는 상품 판매정보 표 입니다. 구성은 기준판매가, 옵션(옵션1,옵션2), 소비자가, 공급가, 판매가, 재고(가용) 입니다.">
                                <caption>상품 판매정보</caption>
                                <colgroup>
                                    <col width="4%">
                                    <col width="12%">
                                    <col width="30%" id="col_pop_dynamic_col">
                                    <col width="15%">
                                    <col width="15%">
                                    <col width="15%">
                                    <col width="11%">
                                </colgroup>
                                <thead>
                                    <tr id="tr_pop_goods_item_head_1">
                                        <th rowspan="2"><button class="plus_ btn_comm" id="btn_add_item">더하기 버튼</button></th>
                                        <th rowspan="2">기준할인가</th>
                                        <th colspan="1" class="line_b" id="th_pop_dynamic_cols">옵션</th>
                                        <th rowspan="2">소비자가</th>
                                        <th rowspan="2">공급가</th>
                                        <th rowspan="2">판매가</th>
                                        <th rowspan="2">재고(가용)</th>
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
                                            <label for="rdo_standardPriceYn" class="radio"><span class="ico_comm">
                                                <input type="radio" name="standardPriceYn" id="rdo_standardPriceYn"
                                                data-input-type="radio" data-input-name="standardPriceYn">
                                            </span></label>
                                        </td>
                                        <td id="td_pop_dynamic_cols" class="optionTd"><span class="intxt shot2">
                                            <input type="text" name="attrValue1" id="txt_attr1" data-bind="item_info" data-bind-type="text" data-bind-value="attrValue1" maxlength="50" data-validation-engine="validate[maxSize[50]]" >
                                        </span></td>
                                        <td><span class="intxt shot2">
                                            <input type="text" class="comma" name="customerPrice" id="txt_customerPrice" data-bind="item_info" data-bind-type="textcomma" data-bind-value="customerPrice" maxlength="10" data-validation-engine="validate[maxSize[10]]" >
                                        </span>원</td>
                                        <td><span class="intxt shot2">
                                            <input type="text" class="comma" name="supplyPrice" id="txt_supplyPrice" data-bind="item_info" data-bind-type="textcomma" data-bind-value="supplyPrice" maxlength="10" data-validation-engine="validate[maxSize[10]]" >
                                        </span>원</td>                                        
                                        <td><span class="intxt shot2">
                                            <input type="text" class="comma" name="salePrice" id="txt_salePrice" data-bind="item_info" data-bind-type="textcomma" data-bind-value="salePrice" maxlength="10" data-validation-engine="validate[maxSize[10]]" >
                                        </span>원</td>
                                        <td><span class="intxt shot2">
                                                <input type="text" class="comma" name="stockQtt" id="txt_stockQtt" data-bind="item_info" data-bind-type="textcomma" data-bind-value="stockQtt" maxlength="4" data-validation-engine="validate[maxSize[4]]">
                                         </span></td>
                                    </tr>
                                    <tr id="tr_no_item_data"><td colspan="10">데이터가 없습니다.</td></tr>
                                </tbody>
                            </table>                                                                                 
                        </div>
                        <!-- //tblh -->
                        <div class="btn_box txtc">
                            <button class="btn green" id="btn_apply_main_goods">적용하기</button>
                        </div>
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
                                        <td><span class="intxt wid100p"><input type="text" value="" id=""></span></td>
                                        <td><span class="intxt wid100p"><input type="text" value="" id=""></span></td>
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
    
<%--     <!-- layout1s -->
    <div id="layer_upload_image" class="slayer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">상품 이미지 일괄등록</h2>
                <button id="btn_close_layer_upload_image" class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <form action="/admin/common/file-upload" name="imageUploadForm" id="form_id_imageUploadForm" method="post" >
            <div class="pop_con">
                <p class="message txtl">일괄등록 사이즈 설정 값을 기준으로 노출 위치별 필요한 사이즈로 자동 등록됩니다</p>
                <span class="br"></span>
                <span class="intxt imgup1"><input id="file_route1" class="upload-name" type="text" value="이미지선택" disabled="disabled"></span>
                <label class="filebtn" for="input_id_image">이미지찾기</label>
                <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                <span class="br2"></span>
                <span class="intxt imgup2">
                    <input type="text" value="" id="" />
                    <input type="hidden" id="hd_img_param_1" name="img_param_1" /></span>
                    <input type="hidden" id="hd_img_param_2" name="img_param_2" /></span>
                    <input type="hidden" id="hd_img_detail_width" name="img_detail_width" /></span>
                    <input type="hidden" id="hd_img_detail_height" name="img_detail_height" /></span>
                    <input type="hidden" id="hd_img_thumb_width" name="img_thumb_width" /></span>
                    <input type="hidden" id="hd_img_thumb_height" name="img_thumb_height" /></span>
                    <input type="hidden" value="222" id="test" /></span>
                </span>
                <div class="btn_box txtc">
                    <button class="btn_green" id="btn_regist_image">등록</button>
                    <button class="btn_red" id="btn_cancel">취소</button>
                </div>
            </div>
            </form>
            <!-- //pop_con -->
        </div>
    </div>
<!-- //layout1s -->
 --%>
 
 <!-- content -->
<!-- //content -->
<!-- layer_popup은 container 다음에 넣어야함 -->
<!-- layout1s -->
<div id="layer_upload_image" class="slayer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">상품 이미지 일괄등록</h2>
            <button id="btn_close_layer_upload_image" class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <form action="/admin/common/file-upload" name="imageUploadForm" id="form_id_imageUploadForm" method="post" >
                    <p class="message txtl">일괄등록 사이즈 설정 값을 기준으로 노출 위치별 필요한 사이즈로 자동 등록됩니다</p>
                    <span class="br"></span>
                    <span class="intxt imgup1"><input id="file_route1" class="upload-name" type="text" value="이미지선택" disabled="disabled"></span>
                    <label class="filebtn" for="input_id_image">파일찾기</label>
                    <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                    <span class="br2"></span>
                    <span class="intxt imgup2">
                        <input type="text" value="" id="" />
                        <input type="hidden" id="hd_img_param_1" name="img_param_1" /></span>
                        <input type="hidden" id="hd_img_param_2" name="img_param_2" /></span>
                        <input type="hidden" id="hd_img_detail_width" name="img_detail_width" /></span>
                        <input type="hidden" id="hd_img_detail_height" name="img_detail_height" /></span>
                        <input type="hidden" id="hd_img_thumb_width" name="img_thumb_width" /></span>
                        <input type="hidden" id="hd_img_thumb_height" name="img_thumb_height" /></span>
                        <input type="hidden" value="222" id="test" /></span>
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
                    <img id="img_preview_goods_image" src="/admin/img/product/tmp_img03.png" width="338" height="338" alt="" />
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    
    <!-- layout1s 아이콘 추가-->
    <div class="slayer_popup" id="layer_add_icon">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">아이콘 추가</h2>
                <button class="close ico_comm" id="btn_close_add_icon">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <form action="/admin/common/file-upload" name="fileUploadForm" id="fileUploadForm" method="post">
                        <span class="intxt imgup1">
                            <input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled">
                        </span>
                        <label class="filebtn" for="icon_file">파일찾기</label>
                        <input class="filebox" name="files" type="file" id="icon_file">
                        <span class="br2"><img id="tempImg" style="display:none"/></span>
                        <div class="btn_box txtc">
                            <button class="btn_green" id="btn_regist_icon">등록</button>
                            <button class="btn_red" id="btn_cancel_icon">취소</button>
                        </div>
                    </form>
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layout1s 아이콘 추가 -->
    
    <!-- layer_popup1 -->
    <div id="layer_set_goods_image_size" class="layer_popup">
        <div class="pop_wrap size2">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">상품 이미지 사이즈 설정</h2>
                <button class="close ico_comm" id="btn_close_set_goods_image_size">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <span class="mb20" style="display:inline-block;">
                        ※ [상품상세(기본)], [리스트썸네일]  항목에 등록되는 이미지는 아래의 사이즈별로 자동 리사이징 됩니다. 
                    </span>
                    <form name="form_set_goods_image_size" id="form_set_goods_image_size">
                    <div class="tblh mt0">
                        <table summary="이표는 옵션 미리보기 표 입니다. 구성은 컬러, 사이즈 입니다.">
                            <caption>옵션 미리보기</caption>
                            <colgroup>
                                <col width="50%">
                                <col width="50%">
                            </colgroup>
                            <thead>
                                <th>상품상세(기본)</th>
                                <th>리스트 썸네일</th>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="intxt wid25"><input type="text" class="numeric" maxlength="3" name="goodsDefaultImgWidth" id="txt_goodsDefaultImgWidth" data-validation-engine="validate[required]"></span> X <span class="intxt wid25"><input type="text" class="numeric" maxlength="3" name="goodsDefaultImgHeight" id="txt_goodsDefaultImgHeight" data-validation-engine="validate[required]"></span></td>
                                    <td><span class="intxt wid25"><input type="text" class="numeric" maxlength="3" name="goodsListImgWidth" id="txt_goodsListImgWidth" data-validation-engine="validate[required]"></span> X <span class="intxt wid25"><input type="text" class="numeric" maxlength="3" name="goodsDefaultImgWidth" id="txt_goodsListImgHeight" data-validation-engine="validate[required]"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </form>
                    <!-- //tblw -->
                    
                    <div class="btn_box txtc mt20">
                        <button class="btn_green" id="btn_regist_goods_image_size">등록</button>
                        <button class="btn_red" id="btn_cancel_goods_image_size">취소</button>
                    </div>
                    
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
    
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
                <div>
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
                                <tbody>
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
                                            <span class="intxt"><input type="text" name="relateGoodsSalePriceStart" id="txt_relate_goods_price_start" class="txtr" /></span> 원 부터
                                            ~
                                            <span class="intxt"><input type="text" name="relateGoodsSalePriceEnd" id="txt_relate_goods_price_end" class="txtr" /></span> 원 까지
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>판매상태</th>
                                        <td>
                                            <label for="rd_relateGoodsSaleStatusCd" class="radio mr20"><span class="ico_comm"><input type="radio" value="" name="relateGoodsSaleStatusCd" id="rd_relateGoodsSaleStatusCd" /></span> 전체</label>
                                            <label for="rd_relateGoodsSaleStatusCd_1" class="radio mr20"><span class="ico_comm"><input type="radio" value="1" name="relateGoodsSaleStatusCd" id="rd_relateGoodsSaleStatusCd_1" /></span> 판매중</label>
                                            <label for="rd_relateGoodsSaleStatusCd_2" class="radio mr20"><span class="ico_comm"><input type="radio" value="2" name="relateGoodsSaleStatusCd" id="rd_relateGoodsSaleStatusCd_2" /></span> 품절</label>
                                            <label for="rd_relateGoodsSaleStatusCd_4" class="radio mr20"><span class="ico_comm"><input type="radio" value="4" name="relateGoodsSaleStatusCd" id="rd_relateGoodsSaleStatusCd_4" /></span> 판매중지</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>전시상태</th>
                                        <td>
                                            <label for="rd_relateGoodsDispStatusCd" class="radio mr20"><span class="ico_comm"><input type="radio" name="relateGoodsDispStatusCd" value="" id="rd_relateGoodsDispStatusCd"/></span> 전체</label>
                                            <label for="rd_relateGoodsDispStatusCd_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="relateGoodsDispStatusCd" value="Y" id="rd_relateGoodsDispStatusCd_Y" /></span> 노출</label>
                                            <label for="rd_relateGoodsDispStatusCd_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="relateGoodsDispStatusCd" value="N" id="rd_relateGoodsDispStatusCd_N" /></span> 미노출</label>
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
                                    <td>
                                        <label for="rd_relateGoodsAutoExpsSortCd_01" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="01" id="rd_relateGoodsAutoExpsSortCd_01"></span> 최근 등록순(신상품순서)</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_02" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="02" id="rd_relateGoodsAutoExpsSortCd_02"></span> 판매인기순(구매금액)</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_03" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="03" id="rd_relateGoodsAutoExpsSortCd_03"></span> 판매인기순(구매갯수)</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_04" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="04" id="rd_relateGoodsAutoExpsSortCd_04"></span> 상품평 많은순</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_05" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="05" id="rd_relateGoodsAutoExpsSortCd_05"></span> 장바구니 담기 많은 순</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_06" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="06" id="rd_relateGoodsAutoExpsSortCd_06"></span> 위시리스트담기 많은순</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_07" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="07" id="rd_relateGoodsAutoExpsSortCd_07"></span> 할인율 높은순</label><br>
                                        <label for="rd_relateGoodsAutoExpsSortCd_08" class="radio left"><span class="ico_comm"><input type="radio" name="relateGoodsAutoExpsSortCd" value="08" id="rd_relateGoodsAutoExpsSortCd_08"></span> 상품조회 많은순</label>
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
    
    <!-- //layer_popup1 -->
    <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />

    </t:putAttribute>
    
</t:insertDefinition>
