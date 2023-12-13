<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 상품 &gt; 사은품관리 &gt; 등록/수정</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                FreebieUtil.init();

                // 목록
                $('#btn_list').on('click', function() {
                    Dmall.FormUtil.submit('/admin/goods/freebie');
                });

                // 저장
                $('#btn_save').on('click', function () {
                    FreebieUtil.saveInfo();
                });

                // 이미지 첨부 미리보기
                $('#input_id_image').on('change', function() {
                    if($(this)[0].files.length < 1) {
                        $('div.upload_file').html('');
                        $('#upload_name').val('');
                    }

                    if(this.files && this.files[0]) {
                        var fileNm = this.files[0].name;
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            var template =
                                '<span class="txt">'+fileNm+'</span>' +
                                '<button class="cancel">삭제</button><br>' +
                                '<img src="'+e.target.result+'" alt="미리보기 이미지">';
                            $('div.upload_file').html(template);
                        };
                        reader.readAsDataURL(this.files[0]);

                        $('#upload_name').val(fileNm);
                    }
                });

                // 이미지 삭제 버튼
                $('div.upload_file').on('click', 'button.cancel', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('div.upload_file').html('');
                    $('#input_id_image').val('');
                    $('#upload_name').val('');
                });
            });

            var state = '${state}';
            var FreebieUtil = {
                init: function() {
                    Dmall.DaumEditor.init(); // 에디터 초기화 함수,
                    Dmall.DaumEditor.create('ta_freebieDscrt'); // Textarea를 에디터로 설정
                    Dmall.validate.set('form_freebie_info');
                    this.getData();
                },
                saveInfo: function() {
                    Dmall.DaumEditor.setValueToTextarea('ta_freebieDscrt');  // 에디터에서 폼으로 데이터 세팅
                    if(Dmall.validate.isValid('form_freebie_info')) {
                        var url = '';

                        if(state === 'I' || state === 'C') {
                            url = '/admin/goods/freebie-contents-insert';
                        } else {
                            url = '/admin/goods/freebie-contents-update';
                        }

                        $('#form_freebie_info').ajaxSubmit({
                            url: url,
                            dataType: 'json',
                            success: function(result) {
                                if(result.success) {
                                    Dmall.LayerUtil.alert(result.message).done(function () {
                                        Dmall.FormUtil.submit('/admin/goods/freebie');
                                    });
                                } else {
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        });
                    }
                },
                getData: function() {
                    if(state === 'I') {
                        $('#tdFreebieNo').html($('#freebieNo').val());
                    } else {
                        var url = '/admin/goods/freebie-contents',
                            param = {freebieNo: $('#freebieNo').val()};

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            $('#tdFreebieNo').html($('#freebieNo').val());
                            // form - input 값 바인딩
                            Dmall.FormUtil.jsonToForm(result.data, 'form_freebie_info');
                            Dmall.DaumEditor.setContent('ta_freebieDscrt', result.data.freebieDscrt);
                            Dmall.DaumEditor.setAttachedImage('ta_freebieDscrt', result.data.attachImages);

                            if(state === 'C') {
                                $('#freebieNo').val('${so.newFreebieNo}');
                                $('#tdFreebieNo').html($('#freebieNo').val());
                            }

                            if(!result.data.dlgtImg) {
                                return;
                            }
                            // 대표이미지 바인딩
                            var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=FREEBIEDTL&id1='+result.data.dlgtImg.imgPath+'_'+result.data.dlgtImg.imgNm;
                            var template =
                                '<span class="txt">'+result.data.dlgtImg.orgImgNm+'</span>' +
                                '<button class="cancel">삭제</button><br>' +
                                '<img src="'+imgSrc+'" alt="미리보기 이미지">';
                            $('div.upload_file').html(template);
                            $('#upload_name').val(result.data.dlgtImg.orgImgNm);
                        });
                    }
                }
            }
        </script>

        <script type="text/javascript">
            $(document).ready(function() {
                return;
                var freebieNo = "${so.freebieNo}";
                
                //이미지 업로드할때 필요한 사운품번호
                FreebieSubmitUtil.freebieNo = freebieNo;

                //에디터 로드
                FreebieInitUtil.loadEditor();
                
                 // 데이터 랜더링
                if(freebieNo === '') {
                    $('#tdFreebieNo').text('자동생성');
                } else { //사은품 수정이라면 데이터 렌더링
                    $('#freebieNo').val(freebieNo);
                    FreebieRenderUtil.render(freebieNo);
                }
                
                //상품 이미지 랜더링
                $("#tr_goods_image_template_1, #tr_goods_image_template_2").hide();
                FreebieImageUtil.addIamgeSetRow(null);
                
                //상품 이미지 사이즈 셋팅(TS_SITE_DTL)
                FreebieImageUtil.getDefaultFreebieInfo();

                //저장하기 버튼 클릭
                $('#saveBtn').on('click', function(e) {
                    var type = '';
                    freebieNo === '' ? type = 'insert' : type = 'update';
                    FreebieSubmitUtil.submit('/admin/goods/freebie-contents-'+type, e, type);
                });
                
                //이미지 업로드 레이어 등록 버튼 클릭
                $('#btn_regist_image').off("click").on('click', function(e) {
                    FreebieImageUtil.freebieImageTempSave(e);
                });
                Dmall.validate.set('form_freebie_info');
                Dmall.common.numeric();
            });
            
            var FreebieInitUtil = {
                loadEditor:function() {
                    Dmall.DaumEditor.init(); // 에디터 초기화 함수,
                    Dmall.DaumEditor.create('ta_freebieDscrt'); // Textarea를 에디터로 설정
                }
                , setLabelRadio:function(data, obj, bindName, target, area, row) {
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
            };

            var FreebieImageUtil = {
                setImageSrc:function(data, obj, bindName, target, area, row) { // 업로드된 이미지 소스로 변경, ok
                    if ( obj.data("bind-param") == data.type ) {
                        obj.data("img_data", data).attr("src", data.src);
                    }
                }
                , setRegistImage:function(data, obj, bindName, target, area, row) {  // 이미지 등록 버튼 클릭시 이벤트, ok
                    var type = $(obj).data("bind-param");
                
                    if ( type === data.type) {
                        $(obj).data("img_data", data);
                    }

                    $(obj).off("click").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        //이미지 업로드 레이어 문구적용
                        var titleText = '';
                        type === "01" ? titleText = '일괄등록' : titleText = '개별등록';
                        $('.image-upload-title-text').text(titleText);

                        // 업로드 팝업에 현재 선택된 버튼의 정보를 설정
                        $("#hd_img_param_1").data("type", type).data("setIdx", $(this).closest("tr").data("setIdx")).val(type);
                        Dmall.LayerPopupUtil.open($('#layer_upload_image'));
                    });
                }
                , previewRegistImage:function(data, obj, bindName, target, area, row) { // 이미지 미리보기 버튼 클릭시 이벤트
                    var type = $(obj).data("bind-param");
                    if (data && type === data.type) {
                        $(obj).data("img_data", data);
                        $(obj).off("click").on('click', function(e) {
                            Dmall.EventUtil.stopAnchorAction(e);
                            $("#img_preview_goods_image").attr("src", $(this).data("img_data").imageUrl).attr("width", $(this).data("img_data").imageWidth).attr("height",  $(this).data("img_data").imageHeight);
                            Dmall.LayerPopupUtil.open($('#layer_preview_upload_image'));
                        });
                    }
                }
                , addIamgeSetRow:function(data) {
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
                }
                , getDefaultFreebieInfo:function() {
                    var url = '/admin/goods/default-image-info';
                    Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                        //
                        if (result == null || result.success != true) {
                            return;
                        }

                        // 상품 이미지 정보(상품 상세 및 리스트 이미지 사이즈) 설정
                        FreebieImageUtil.createFreebieImgInfo(result.data);
                    });
                }
                , createFreebieImgInfo:function(data) { //ok
                    //TS_SITE_DTL에 현재 goodsDefaultImgWidth: 800, goodsDefaultImgHeightㅣ 400으로 세팅되어 있어 고정으로 240을 박아놓는다.
                    //var goodsDefaultImgWidth = 'goodsDefaultImgWidth' in data && data['goodsDefaultImgWidth'] ? data['goodsDefaultImgWidth'] : 240
                    //  , goodsDefaultImgHeight = 'goodsDefaultImgHeight' in data && data['goodsDefaultImgHeight'] ? data['goodsDefaultImgHeight'] : 240
                    var goodsDefaultImgWidth = 240
                      , goodsDefaultImgHeight = 240
                      , goodsListImgWidth = 'goodsListImgWidth' in data && data['goodsListImgWidth'] ? data['goodsListImgWidth'] : 90
                      , goodsListImgHeight = 'goodsListImgHeight' in data && data['goodsListImgHeight'] ? data['goodsListImgHeight'] : 90;
                      
                    $('#hd_img_detail_width').val(goodsDefaultImgWidth);
                    $('#hd_img_detail_height').val(goodsDefaultImgHeight);
                    $('#hd_img_thumb_width').val(goodsListImgWidth);
                    $('#hd_img_thumb_height').val(goodsListImgHeight);
                    $('#th_image_size_detail').html(goodsDefaultImgWidth + '*' + goodsDefaultImgHeight);
                    $('#th_image_size_list').html(goodsListImgWidth + '*' + goodsListImgHeight);
                }
                , getFreebieImgSetValue:function($target, data) { // 사은품 이미지 세트 정보 취득
                    var returnData = {};
                    $target.each(function(idx) {
                        var $tr = $(this)
                          , $radio = $("input:radio", $(this))
                          , prevData = $tr.data('prev_data');
                        $("img", $tr.find('td')).each(function(idx) {
                            var imgData = $(this).data("img_data");
                            if (!imgData) {
                                return true;
                            } 
                            
                            if ('tempFileName' in imgData && imgData.tempFileName) {
                                returnData['freebieImageDtlList[' + idx + '].freebieNo'] = data.freebieNo;
                                returnData['freebieImageDtlList[' + idx + '].tempFileNm'] = (imgData.tempFileName) ? imgData.tempFileName : '';
                                returnData['freebieImageDtlList[' + idx + '].imgPath'] = (imgData.tempFileName) ? imgData.tempFileName.split("_")[0] : '';
                                returnData['freebieImageDtlList[' + idx + '].imgNm'] = (imgData.tempFileName) ? imgData.tempFileName.split("_")[1] + '_' +imgData.tempFileName.split("_")[2] : '';
                                returnData['freebieImageDtlList[' + idx + '].freebieImgType'] = imgData.type;
                                returnData['freebieImageDtlList[' + idx + '].imgWidth'] = imgData.imageWidth;
                                returnData['freebieImageDtlList[' + idx + '].imgHeight'] = imgData.imageHeight;
                            }
                        });
                        
                        if(Object.keys(returnData).length > 0) {
                            returnData.availFlag = true;
                            returnData.freebieNo = data.freebieNo;
                        }
                    });
                    return returnData;
                }
                , freebieImageTempSave:function(e) { //ok
                    Dmall.EventUtil.stopAnchorAction(e);
                    if ( null == $("#input_id_image").val() || $("#input_id_image").val().length < 1) {
                        alert("등록할 상품 이미지를 선택해 주십시요.");
                        return;
                    } 

                    $.when(Dmall.FileUpload.upload('form_id_imageUploadForm')).then(
                    function (result) {
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
                }
            };
            
            var FreebieRenderUtil = {
                renderEdit:function(data) {
                    Dmall.FormUtil.jsonToForm(data, 'form_freebie_info');
                    Dmall.DaumEditor.setContent('ta_freebieDscrt', data.freebieDscrt); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('ta_freebieDscrt', data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                }
                , render:function(freebieNo) {
                    var url = '/admin/goods/freebie-contents',
                        param = {'freebieNo':freebieNo},
                        dfd = jQuery.Deferred();
                    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }

                        FreebieRenderUtil.renderEdit(result.data);
                        FreebieRenderUtil.bind(result.data);
                        FreebieRenderUtil.renderFreebieImage(result.data);
                        // 상품 이미지 정보(상품 상세 및 리스트 이미지 사이즈) 설정
                        FreebieImageUtil.createFreebieImgInfo(result.data);
                        dfd.resolve(result.data);
                    });
                    return dfd.promise();
                }
                , bind : function(data) {
                    $('[data-bind="freebie_info"]').DataBinder(data);
                    
                    //상품코드 노출
                    $('#tdFreebieNo').text(data.freebieNo);
                }
                , renderFreebieImage:function(data) {
                    if ('freebieImageSetList' in data && data['freebieImageSetList'].length > 0) {
                        var imageSetList = data['freebieImageSetList'];
                        // 기존 이미지 정보 삭제
                        $("tr.goods_image_set, tr.goods_image_set_btn", $("#tbody_goods_image_set")).remove();
                        $.each(imageSetList, function(idx, imgSetData){
                            imgSetData['idx'] = idx;
                            FreebieImageUtil.addIamgeSetRow(imgSetData);
                            
                            var imgDtlList = imgSetData['freebieImageDtlList'];
                            
                            $.each(imgDtlList, function(idx2, imgDtlData){
                                var data = {
                                        idx : idx2,
                                        src : imgDtlData['thumbUrl'],
                                        type : imgDtlData['freebieImgType'],
                                        freebieNo : imgSetData['freebieNo'],
                                        imgPath : imgDtlData['imgPath'],
                                        imgNm : imgDtlData['imgNm'],
                                        imageUrl : imgDtlData['imgUrl'],
                                        imageWidth :  imgDtlData['imgWidth'],
                                        imageHeight :  imgDtlData['imgHeight']
                                    };
                                
                                $('[data-bind="image_info"]', $('tr[name="tr_goods_image1_' + idx + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                $('[data-bind="image_info"]', $('tr[name="tr_goods_image2_' + idx + '"]', $("#tbody_goods_image_set"))).DataBinder(data);
                                
                            });
                        })
                    }
                }
            };
            
            var FreebieSubmitUtil = {
                freebieNo:0
                , customAjax:function(url, callback) {
                    $('#form_freebie_info').ajaxSubmit({
                        url : url,
                        dataType: 'json',
                        success:function(result) {
                            if (result) {
                                Dmall.AjaxUtil.viewMessage(result, callback);
                            } else {
                                callback();
                            }
                        }
                        , error:function(result) {
                            Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
                        }
                    });
                }
                , submit:function(url, e, type) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.DaumEditor.setValueToTextarea('ta_freebieDscrt');  // 에디터에서 폼으로 데이터 세팅
                    
                    if(Dmall.validate.isValid('form_freebie_info')) {
                        
                        FreebieSubmitUtil.customAjax(url, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_freebie_info');
                            if (result == null || result.success != true) {
                                return;
                            } else {
                                //사은품 이미지 등록
                                FreebieSubmitUtil.freebieImageSubmit(result, type);
                            }
                        });
                    }
                }
                , freebieImageSubmit:function(result, type) {
                    var returnData = FreebieImageUtil.getFreebieImgSetValue($("tr.goods_image_set", "#tbody_goods_image_set"), result.data);

                    //사은품 이미지가 존재할경우에만 업로드 실행
                    if(returnData.availFlag) {
                        var url = '/admin/goods/freebie-image-insert';

                        Dmall.AjaxUtil.getJSON(url, returnData, function(result) {
                            if(result.success){
                                location.href='/admin/goods/freebie';
                            } else {
                                var text = (type === 'insert') ? '등록' : '수정';
                                Dmall.LayerUtil.alert('이미지 '+text+'에 실패하였습니다.');
                            }
                        });
                    } else {
                        location.href='/admin/goods/freebie';
                    }
                }
            };
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">사은품 관리</h2>
            </div>
            <form id="form_freebie_info" method="post">
                <input type="hidden" id="freebieNo" name="freebieNo" value="${so.freebieNo}"/>
                <!-- line_box -->
                <div class="line_box fri pb">
                    <h3 class="tlth3">사은품 기본정보 </h3>
                    <div class="tblw tblmany">
                        <table summary="이표는 사은품 기본정보 표 입니다. 구성은 상품번호, 자동생성, 상품코드, 자동생성 입니다.">
                            <caption>사은품 기본정보</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>사은품 코드</th>
                                <td id="tdFreebieNo"></td>
                            </tr>
                            <tr>
                                <th>사은품명</th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="freebieNm" id="txt_freebieNm" data-validation-engine="validate[required, maxSize[30]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>상태</th>
                                <td>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn" value="Y"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <h3 class="tlth3">이미지 정보</h3>
                    <div class="tblw tblmany">
                        <table>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>대표 이미지</th>
                                <td>
                                    <div class="upload_file_wrap">
                                        <span class="intxt imgup2">
                                            <input type="text" id="upload_name" name="uploadFileNm" readonly>
                                        </span>
                                        <label for="input_id_image" class="filebtn on">파일첨부</label>
                                        <input type="file" name="file" id="input_id_image" class="filebox" accept="image/*">
                                        <span class="desc">· 파일 첨부 시 10MB 이하 업로드 (jpg/png/gif/bmp)</span>
                                        <div class="upload_file"></div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>상세 내용</th>
                                <td>
                                    <textarea id="ta_freebieDscrt" name="freebieDscrt" class="blind"></textarea>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_list">목록</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_save">저장</button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>