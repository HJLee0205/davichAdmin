<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; SNS/외부연동 &gt; 소셜로그인 연동관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 소셜로그인 설정
                $('a.layerBtn').on('click', function() {
                    var $this = $(this);
                    var url = '/admin/setup/config/snsoutside/sns-config-info',
                        param = { siteNo: 1, outsideLinkCd: $this.data('link-cd') };

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.data) {
                            SnsConfig.setPopData(result.data);
                        } else {
                            Dmall.LayerPopupUtil.open($('#' + $this.data('link-type')));
                        }
                    });
                });

                SnsConfig.init();
            });

            var SnsConfig = {
                init: function() {
                    SnsConfig.naverInit();
                    SnsConfig.kakaoInit();
                    SnsConfig.appleInit();
                },
                naverInit: function() {
                    // 첨부파일 추가 시 미리보기
                    $('input[type=file]').change(function() {
                        // 파일사이즈 및 확장자 검증
                        var ext = $(this).val().split('.').pop().toLowerCase();
                        var fileSize = this.files[0].size;
                        if(fileSize > 500 * 1000) {
                            Dmall.LayerUtil.alert('500KB 이하의 파일을 업로드 해주세요.');
                            return;
                        } else if($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {
                            Dmall.LayerUtil.alert('이미지 파일이 아닙니다. (gif, png, jpg, jpeg 만 업로드 가능)');
                            return;
                        } else {
                            if(this.files && this.files[0]) {
                                var fileNm = this.files[0].name;
                                var reader = new FileReader();
                                reader.onload = function(e) {
                                    var template =
                                        '<span class="txt">'+fileNm+'</span>' +
                                        '<button class="cancel">삭제</button>' +
                                        '<div class="naverImgWrap">' +
                                        '<span id="fileImg" width="110" height="110">' +
                                        '<img src="'+e.target.result+'" alt="미리보기 이미지">' +
                                        '</span>' +
                                        '</div>';
                                    $('div.upload_file').html(template);
                                }
                                reader.readAsDataURL(this.files[0]);
                                $('#spmallLogoImg').val(fileNm);
                            }
                        }
                    });

                    // 이미지 삭제 버튼
                    $('div.upload_file').on('click', 'button.cancel', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var $obj = $(e.target).parents('div.upload_file');
                        $('#spmallLogoImg').val('');
                        $obj.html('');
                    });

                    // 수정신청
                    $('button[data-link-type="naver"]').on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var url = '/admin/setup/config/snsoutside/sns-config-update';

                        $('#naverConfigForm').ajaxSubmit({
                            url: url,
                            dataType: 'json',
                            contentType: false,
                            processData: false,
                            success: function(result) {
                                if(result.success) {
                                    Dmall.LayerUtil.alert(result.message).done(function() {
                                        Dmall.LayerPopupUtil.close('naverLinkConfigLayer');
                                        location.reload();
                                    });
                                } else {
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        });
                    });
                },
                kakaoInit: function() {
                    // 적용하기
                    $('button[data-link-type="kakao"]').on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        var url = '/admin/setup/config/snsoutside/sns-config-update',
                            param = $('#kakaoConfigForm').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                Dmall.LayerPopupUtil.close('kakaoLinkConfigLayer');
                                location.reload();
                            }
                        });
                    })
                },
                appleInit: function() {

                },
                setPopData: function(data) {
                    var formId = '',
                        layerId = '';
                    if(data.outsideLinkCd == '02') {
                        formId = 'naverConfigForm';
                        layerId = 'naverLinkConfigLayer';
                    } else if(data.outsideLinkCd == '03') {
                        formId = 'kakaoConfigForm';
                        layerId = 'kakaoLinkConfigLayer';
                    } else {

                    }
                    // 데이터 바인딩
                    Dmall.FormUtil.jsonToForm(data, formId);
                    // 네이버일 때 이미지 바인딩
                    if(formId == 'naverConfigForm') {
                        var fileNm = data.spmallLogoImg.replace('/','');
                        $('input[name=spmallLogoImg]').val(fileNm);

                        var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=NAVERLOGO&id1='+data.spmallLogoImg;
                        var template =
                            '<span class="txt">'+fileNm+'</span>' +
                            '<button class="cancel">삭제</button>' +
                            '<div class="naverImgWrap">' +
                            '<span id="fileImg" width="110" height="110">' +
                            '<img src="'+imgSrc+'" alt="서버 이미지">' +
                            '</span>' +
                            '</div>';
                        $('div.upload_file').html(template);
                    }
                    Dmall.LayerPopupUtil.open($('#' + layerId));
                }
            }
        </script>
        <script>
            $(document).ready(function() {
                return;

                //sns 외부연동 설정 호출
                SnsUtil.renderList();
                
                // 저장하기 버튼 클릭시
                $('.submitBtn').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    SnsUtil.submit(SnsUtil.mappingVo($(this).attr('data-link-type'), $(this).attr('data-link-cd')));
                });
                
                // 네이버 저장하기 버튼 클릭시
                $('.naverSubmitBtn').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    SnsNaverConfigUtil.submit();
                });
                
                Dmall.validate.set('naverConfigForm');
                Dmall.validate.set('kakaoConfigForm');
                Dmall.validate.set('facebookConfigForm');
            });

            var SnsUtil = {
                siteTypeCd:''
                , linkOperYn:''
                , init:function() { //check handler
                    $('label.chack').off('click').on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var $this = $(this),
                            $input = $("#" + $this.attr("for")),
                            checked = !($input.prop('checked'));

                        $input.prop('checked', checked);
                        $input.attr('checked', checked);
                        $this.toggleClass('on');
                    });  
                }
                , layerBtnHandlerAdd:function() {
                    // 설정 버튼 클릭시
                    $('.layerBtn').on('click', function() {
                        SnsUtil.snsAddibleValidation(this, SnsUtil.layerOpen);
                    });
                }
                , popupDataMapped:function(vo, linkCode) {
                    var idText = (linkCode === 'naver') ? '#naverConfigForm' : '#'+linkCode+'ConfigForm, #'+linkCode+'DomainForm';
                    for(var key in vo) {
                        $(idText).find('input[data-name='+key+']').val(vo[key]);
                        
                        if(linkCode === 'naver') {
                            if(key === 'spmallLogoImg') {
                                var spanTag = '';
                                var initImgPath = '';
                                
                                //섬네일 img태그에 경로 설정
                                if(vo.spmallLogoImg === '' || vo.spmallLogoImg === null) {
                                    initImgPath = '/admin/img/product/tmp_img01.png';
                                    spanTag = '<span id="fileImg" width="110" height="110" style="position:relative; float:left; cursor:pointer; background-image:url(/admin/img/product/tmp_img01.png); background-repeat:no-repeat">';
                                } else {
                                    var fileName = vo.spmallLogoImg.split('\\')[0];
                                    initImgPath = '${_IMAGE_DOMAIN}/image/image-view?type=NAVERLOGO&id1='+fileName;
                                    spanTag = '<span id="fileImg" width="110" height="110" style="position:relative; float:left; cursor:pointer; background-image:url(/image/image-view?type=NAVERLOGO&id1='+fileName+'); background-repeat:no-repeat">';
                                }
                                
                                //이미지 사이즈 검증에 필요함
                                SnsNaverConfigUtil.initImgPath = initImgPath;
                                
                                var html = spanTag+
                                           '<input type="file" id="updateBtn" name="uploadFile" style="position：absolute; margin-left:-10px; width:110px; height:110px; filter:alpha(opacity=0); opacity:0; -moz-opacity:0; cursor:pointer;">'+
                                           '</span>';
                                $('#naverImgWrap').html(html);
                                
                                
                                SnsNaverConfigUtil.thumbNailHandler();
                            }
                        }
                    }
                    
                    if(vo.linkUseYn === 'Y') {
                        $('#chk_linkUseYn_'+linkCode).attr('checked', true).next().addClass('on');
                    } else {
                        $('#chk_linkUseYn_'+linkCode).attr('checked', false).next().removeClass('on');
                    }
                }
                , formReset:function() {
                    $('#facebookConfigForm, #naverConfigForm, #kakaoConfigForm, #facebookDomainForm, #kakaoDomainForm')[0].reset();
                }
                , snsAddibleValidation:function(obj, callback) {
                    //sns 외부연동 정보 조회
                    var url = '/admin/setup/config/snsoutside/sns-addible-validation'
                      , param = {'outsideLinkCd':$(obj).data('link-cd')};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result.success) {
                            callback(obj);
                        } else {
                            return false;
                        }
                    });
                }
                , layerInit:function(obj) { //레이어 오픈시 초기값 세팅
                    //팝업폼 리셋
                    SnsUtil.formReset();
                    
                    //팝업폼 데이터 랜더링
                    SnsUtil.render(obj, {'outsideLinkCd':$(obj).attr('data-link-cd')});
                }
                , layerOpen:function(obj) { //레이어 오픈
                    //메인 설정 팝업을 오픈할때에만 호출한다.
                    if(/LinkConfigLayer/i.test($(obj).attr('data-link-type'))) {
                        SnsUtil.layerInit(obj);
                    }
                    
                    Dmall.LayerPopupUtil.open($('#'+$(obj).data('link-type')));
                }
                , bind:function(data) { // 기본 회원가입 checkbox data bind
                    $('[data-find="sns_info"]').DataBinder(data);
                    //위에서 DataBinder를 하지만 다시 라디오버튼을 checked를 해주는 이유는
                    //설정정보 변경시 사용여부를 한번도 클릭하지 않고 그대로 저장하기 버튼을 클릭하면 현재 체크된 값을 가지고 오질 못해서
                    $("input:checkbox[id='rdo_linkUseYn_"+data.linkUseYn+"']").prop('checked', 'checked');
                    //운영여부값을 매핑한다.
                    SnsUtil.linkOperYn = data.linkOperYn;
                }
                , render:function(obj, param) { //render 메서드는 팝업창 오픈시 데이터를 불러올때만 사용한다.
                    //sns 외부연동 정보 조회
                    var url = '/admin/setup/config/snsoutside/sns-config-info'
                      , dfd = jQuery.Deferred();
                    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }
    
                        dfd.resolve(result.data);

                        if(result.data !== null) {
                            SnsUtil.bind(result.data);
                            
                            //불러온 데이터를 팝업창에 매핑시킨다.
                            SnsUtil.popupDataMapped(result.data, $(obj).attr('data-link-code'));
                        }
                    });
                    return dfd.promise();
                }
                , renderList:function() {
                    //리스트 정보
                    var url = '/admin/setup/config/snsoutside/sns-config-list',
                    dfd = $.Deferred();
                    Dmall.AjaxUtil.getJSONwoMsg(url, null, function(result) {
                        var naverTemplate =
                                '<li class="link-oper-yn-02">' +
                                '<a href="#none" class="layerBtn" data-link-cd="02" data-link-type="naverLinkConfigLayer" data-link-code="naver"><img src="/admin/img/set/img_mrthod_naver.png" alt="네이버"></a>' +
                                '</li>',
                            kakaoTemplate =
                                '<li class="link-oper-yn-03">' +
                                '<a href="#none" class="layerBtn" data-link-cd="03" data-link-type="kakaoLinkConfigLayer" data-link-code="kakao"><img src="/admin/img/set/img_mrthod_kakao.png" alt="카카오"></a>' +
                                '</li>',
                            appleTemplate =
                                '<li class="link-oper-yn-05">' +
                                '<a href="#none" class="layerBtn" data-link-cd="05" data-link-type="appleLinkConfigLayer" data-link-code="apple"><<img src="/admin/img/set/img_mrthod_apple.png" alt="애플"></a>' +
                                '</li>',
                            template = naverTemplate + kakaoTemplate + appleTemplate;

                        $('#ulSnsList').html(template);

                        dfd.resolve(result.resultList);

                        //DOM이 모두 그려지고 난뒤에 이벤트 처리가 불러와줘야한다.
                        SnsUtil.layerBtnHandlerAdd();
                        SnsUtil.init();
                        //기본 회원가입 checked
                        SnsUtil.renderDefaultSignUpChecked(result.resultList);

                        //외부연동 설정 텍스트 랜더링
                        SnsUtil.renderLinkUseYnText(result.resultList);


                        // var defaultTemplate = '<li>'+
                        //                             '<span class="img"><img src="/admin/img/set/img_mrthod01.png" alt="아이디/비밀번호 가입"></span>'+
                        //                             '<input type="checkbox" id="chk_linkUseYn_default" name="linkUseYn" value="Y" disabled="disabled"> 사용'+
                        //                         '</li>'+
                        //                         '<li class="link-oper-yn-01">'+
                        //                             '<span class="img"><img src="/admin/img/set/img_mrthod02.png" alt="facebook"></span>'+
                        //                             '<span class="link-use-yn-01 txt"></span>'+
                        //                             '<a href="#none" class="layerBtn btn_gray" data-link-cd="01" data-link-type="facebookLinkConfigLayer" data-link-code="facebook">설정</a>'+
                        //                         '</li>'
                        //     , naverTemplate =
                        //                     '<li class="link-oper-yn-02">'+
                        //                         '<span class="img"><img src="/admin/img/set/img_mrthod03.png" alt="네이버"></span>'+
                        //                         '<span class="link-use-yn-02 txt"></span>'+
                        //                         '<a href="#none" class="layerBtn btn_gray" data-link-cd="02" data-link-type="naverLinkConfigLayer" data-link-code="naver">설정</a>'+
                        //                     '</li>'
                        //     , kakaoTemplate =
                        //                     '<li class="link-oper-yn-03">'+
                        //                         '<span class="img"><img src="/admin/img/set/img_mrthod04.png" alt="카카오"></span>'+
                        //                         '<span class="link-use-yn-03 txt"></span>'+
                        //                         '<a href="#none" class="layerBtn btn_gray" data-link-cd="03" data-link-type="kakaoLinkConfigLayer" data-link-code="kakao">설정</a>'+
                        //                     '</li>'
                        //     , template = ''
                        //     , tr = '';
                        //
                        // //외부연동 운영 여부에 따른 랜더링(쇼핑몰이 임대형 무료 일때 상점에서 네이버, 카카오 로그인연동을 구매했다면 오픈)
                        // template = SnsUtil.renderOperYn(result.resultList, defaultTemplate, naverTemplate, kakaoTemplate);
                        //
                        // var managerGroup = new Dmall.Template(template);
                        // $.each(result.resultList, function(idx, obj) {
                        //     if(idx === 0) {
                        //         tr += managerGroup.render(obj);
                        //     }
                        // });
                        //
                        // $('#ulSnsList').html(tr);
                        // dfd.resolve(result.resultList);
                    });
        
                    return dfd.promise();
                }
                , renderOperYn:function(list, template, naverTemplate, kakaoTemplate) {
                    return template += naverTemplate + kakaoTemplate;
                }
                , renderLinkUseYnText:function(list) {
                    for(var i=0; i<list.length; i++) {
                        var useYnText = '';
                        if(list[i].outsideLinkCd === '01') {
                            useYnText = list[i].linkUseYn === 'Y' ? '사용함(전용앱)' : '사용하지 않음';
                        } else {
                            useYnText = list[i].linkUseYn === 'Y' ? '사용함' : '사용하지 않음';
                        }
                        $('.link-use-yn-'+list[i].outsideLinkCd).text(useYnText);
                    }

                    //설정안된 외부연동은 사용하지 않음으로 표시
                    $('#ulSnsList li .txt').each(function() {
                        if($(this).text() === '') {
                            $(this).text('사용하지 않음');
                        }
                    });
                }
                , renderDefaultSignUpChecked:function(list) {
                    $.each(list, function(idx, obj) {
                        for(var key in obj) {
                            //리스트 항목중 회원가입 설정 여부인데
                            if(key === 'outsideLinkCd') {
                                //값이 04라면(기본)
                                if(obj[key] === '04') {
                                    //기본키값이 똑같은 것을 체크해준다.
                                    if(obj['linkUseYn'] === 'Y') {
                                        $('#chk_linkUseYn_default').attr('checked', true).next().addClass('on');
                                    }
                                }
                            }
                        }
                    });
                }
                , mappingVo:function(linkType, linkCd) { //submit 할때 파라미터 셋팅
                    var url = '/admin/setup/config/snsoutside/sns-config-update';
                    var param = {};
                    param.outsideLinkCd = linkCd;
                    param.linkUseYn = $("input:checkbox[id='chk_linkUseYn_"+linkType+"']:checked").val() === 'Y' ? 'Y' : 'N';
                    param.layerId = linkType+'LinkConfigLayer';
                    param.linkOperYn = SnsUtil.linkOperYn;

                    if(linkType === 'facebook' || linkType === 'kakao') {
                        param.koreanDomain = $('#'+linkType+'KoreanDomain').val();
                        param.chgResult = $('#'+linkType+'ChgResult').val();
                    }
                    
                    if(linkType === 'facebook') {
                        param.appId = $('#fbAppId').val();
                        param.appSecret = $('#fbAppSecret').val();
                        param.appNamespace = $('#fbAppNamespace').val();
                    } else if(linkType === 'naver') {
                        param.spmallNm = $('#spmallNm').val();
                        param.domainReg = $('#domainReg').val();
                    } else if(linkType === 'kakao') {
                        param.javascriptKey = $('#javascriptKey').val();
                    }

                    return {
                        url:url
                        , param:param
                    }
                }
                , submit:function(vo) { //데이터 등록/수정
                    var formId = '';
                    if(vo.param.outsideLinkCd === '01') {
                        formId = 'facebookConfigForm';
                    } else if(vo.param.outsideLinkCd === '03') {
                        formId = 'kakaoConfigForm';
                    }

                    if(Dmall.validate.isValid(formId)) {
                        Dmall.AjaxUtil.getJSON(vo.url, vo.param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, formId);
    
                            if (result == null || result.success != true) {
                                return;
                            } else {
                              //sns 외부연동 정보 조회
                                SnsUtil.renderList();
    
                              //팝업 제거
                                Dmall.LayerPopupUtil.close(vo.layerId);
                            }
                        });
                    }
                    return false;
                }
                , setUseYn:function(data, obj, bindName, target, area, row) {
                    var value = obj.data("bind-value")
                        , useYn = data[value]
                        , $label = jQuery(obj)
                        , $input = jQuery("#" + $label.attr("for"));
                    
                    useYn = (useYn && ('Y' == useYn || '1' == useYn ));

                    // 체크박스 값 설정
                    if (useYn) {
                        $label.addClass('on');
                        $input.data("value", "Y").prop('checked', true); 
                    } else {
                        $label.removeClass('on');
                        $input.data("value", "N").prop('checked', false); 
                    }             
                }
            };
            
            //네이버 설정정보는 쇼핑몰 로고이미지가 존재하기떄문에 멀티파트로 설정정보를 데이터를 등록해야한다.
            //따라서 비동기전송으로 등록/수정을 함에 따라 Ajax방식을 별도로 만들어서 등록/수정한다.
            var SnsNaverConfigUtil = {
                initImgPath:''
                , customAjax:function(url, callback) {
                    $('#naverConfigForm').ajaxSubmit({
                        url : url,
                        dataType: 'json',
                        contentType: false,
                        processData: false,
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
                , submit:function() {
                    $('#naverLinkOperYn').val(SnsUtil.linkOperYn);
                    if(Dmall.validate.isValid('naverConfigForm')) {
                          var url = '/admin/setup/config/snsoutside/sns-config-update';
                          //Ajax를 공통 템플릿에 있는것을 사용안하고 새로 만들어서 사용하는 이유는
                          //Multipart 폼을 Ajax로 넘기려면 공통 템플릿에서 제공하는 Ajax함수로는 IE에서 작동하지 않는다.
                          //따라서 jquery.form.js에 존재하는 ajaxSubmit방식을 사용하여 통신한다.
                          SnsNaverConfigUtil.customAjax(url, function(result) {
                              Dmall.validate.viewExceptionMessage(result, 'naverConfigForm');
                              
                              if (result == null || result.success != true) {
                                  return;
                              } else {
                                //sns 외부연동 정보 조회
                                  SnsUtil.renderList();

                                //팝업 제거
                                  Dmall.LayerPopupUtil.close('naverLinkConfigLayer');
                              }
                          });
                      }                
                      return false;
                }
                , thumbNailHandler:function() {
                    //네이버 쇼핑몰 로고 이미지 클릭시
                    $('#updateBtn').on('change', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        SnsNaverConfigUtil.readThumbnail(this);
                    });
                }
                , readThumbnail:function (input) {
                    var ext = $(input).val().split('.').pop().toLowerCase();
                    var fileSize = input.files[0].size;
                    if(fileSize > 500 * 1000) {
                        Dmall.LayerUtil.alert('500KB 이하의 파일을 업로드 해주세요.');
                        return;
                    } else if($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {
                        Dmall.LayerUtil.alert('이미지 파일이 아닙니다. (gif, png, jpg, jpeg 만 업로드 가능)');
                        return;
                    } else {
                        if (input.files && input.files[0]) {
                            var reader = new FileReader();

                            reader.onload = function(e) {
                                $('#fileImg').css({'background-image':'url('+e.target.result+')', 'background-repeat':'no-repeat'});
                                $('#tempImg').attr('src', e.target.result); 
                            }
                            
                            //이미지 사이즈를 검증한다.
                            reader.onloadend = function() {
                                SnsNaverConfigUtil.getTempImgSize();
                            }

                            reader.readAsDataURL(input.files[0]);
                            $('#spmallLogoImg').val(input.files[0].name);
                        }
                    }
                }
                , getTempImgSize:function() {
                    $('#tempImg').load(function() {
                        if(this.naturalWidth > 110 || this.naturalHeight > 110) {
                            Dmall.LayerUtil.alert('이미지 권장 사이즈는 110 * 110 입니다. 이미지 사이즈를 확인해 주세요');
                            $('#fileImg').css({'background-image':'url('+SnsNaverConfigUtil.initImgPath+')', 'background-repeat':'no-repeat'});
                            $('#tempImg').attr('src', '');
                            $('#spmallLogoImg').val('');
                            return;
                        }
                    });
                }
            };
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">SNS 로그인</h2>
            </div>
            <div class="line_box fri">
                <h3 class="tlth3">소셜로그인 연동 관리</h3>
                <p class="desc_txt2">&#8251; 클릭시 로그인 설정을 변경하실 수 있습니다.</p>
                <form id="form_sns_info">
                    <div class="login_method">
                        <ul id="ulSnsList">
                            <li class="link-oper-yn-02">
                                <a href="#none" class="layerBtn" data-link-cd="02" data-link-type="naverLinkConfigLayer" data-link-code="naver"><img src="/admin/img/set/img_mrthod_naver.png" alt="네이버"></a>
                            </li>
                            <li class="link-oper-yn-03">
                                <a href="#none" class="layerBtn" data-link-cd="03" data-link-type="kakaoLinkConfigLayer" data-link-code="kakao"><img src="/admin/img/set/img_mrthod_kakao.png" alt="카카오"></a>
                            </li>
                            <li class="link-oper-yn-05">
                                <a href="#none" class="layerBtn" data-link-cd="05" data-link-type="appleLinkConfigLayer" data-link-code="apple"><img src="/admin/img/set/img_mrthod_apple.png" alt="애플"></a>
                            </li>
                        </ul>
                    </div>
                </form>
                <h3 class="tlth3">소셜 계정으로 회원가입 시 입력 항목</h3>
                <p class="desc_txt2">&#8251; 자동으로 아래의 정보를 가져옵니다.</p>
                <div class="tblw_pb mt10">
                    <table>
                        <colgroup>
                            <col width="20%">
                            <col width="16%">
                            <col width="16%">
                            <col width="16%">
                            <col width="16%">
                            <col width="16%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>구분</th>
                            <th>닉네임</th>
                            <th>이름</th>
                            <th>생년월일</th>
                            <th>전화번호</th>
                            <th>이메일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <th>네이버</th>
                            <td>O</td>
                            <td>O</td>
                            <td>O</td>
                            <td>O</td>
                            <td>O</td>
                        </tr>
                        <tr>
                            <th>카카오</th>
                            <td>O</td>
                            <td>O</td>
                            <td>O</td>
                            <td>O</td>
                            <td>O</td>
                        </tr>
                        <tr>
                            <th>애플</th>
                            <td>X</td>
                            <td>O</td>
                            <td>X</td>
                            <td>X</td>
                            <td>O</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%@ include file="popup/naver/naverLinkConfigPopup.jsp" %>
<%--        <%@ include file="popup/facebook/facebookLinkConfigPopup.jsp" %>--%>
<%--        <%@ include file="popup/facebook/facebookLinkDomainChg.jsp" %>--%>
<%--        <%@ include file="popup/facebook/facebookLinkIssueInfo.jsp" %>--%>
        <%@ include file="popup/kakao/kakaoLinkConfigPopup.jsp" %>
<%--        <%@ include file="popup/kakao/kakaoLinkDomainChg.jsp" %>--%>
<%--        <%@ include file="popup/kakao/kakaoLinkIssueInfo.jsp" %>--%>
    </t:putAttribute>
</t:insertDefinition>