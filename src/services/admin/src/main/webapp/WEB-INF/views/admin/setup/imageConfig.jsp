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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 이미지&amp;아이콘 설정</t:putAttribute>
    <t:putAttribute name="script">
      <script type="text/javascript">
         jQuery(document).ready(function() {
             fn_setDefault();
             
             // 아이콘 추가 버튼 클릭 이벤트
             jQuery('#btn_add_icon').off("click").on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 fn_add_icon();
             });
             
             jQuery('#btn_cancel_icon, #btn_close_add_icon').off("click").on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 Dmall.LayerPopupUtil.close('layer_add_icon');
             });
             
             // 아이콘 등록 버튼 클릭 이벤트
             jQuery('#btn_regist_icon').off("click").on('click', function (e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 if(checkAbleAddIcon() && Dmall.FileUpload.checkFileSize('fileUploadForm')) {
                     var $input = $('#icon_file')
                       , ext = $input.val().split('.').pop().toLowerCase()
                       , fileSize = $input[0].files[0].size;
                       
                     if(fileSize > 500 * 1000) {
                         Dmall.LayerUtil.alert('500KB 이하의 파일을 업로드 해주세요.');
                         return;
                     } else if($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {
                         Dmall.LayerUtil.alert('이미지 파일이 아닙니다. (gif, png, jpg, jpeg 만 업로드 가능)');
                         return;
                     } else {
                         jQuery.when(Dmall.FileUpload.upload('fileUploadForm')).then(function (result) {
                             var file = result.files ? result.files[0] ? result.files[0] : null : null;
                             
                             if (file) {
                                 if (result.message) {
                                     Dmall.LayerUtil.alert(result.message, "알림");
                                 }
                                 addGoodsIcon(file);
                                 $("#btn_close_add_icon").trigger('click');
                                 
                             } else {
                                 if (result.message) {
                                     Dmall.LayerUtil.alert(result.message, "알림");
                                 }
                             }
                         });
                     }
                 }
             });
             
             jQuery('#btn_save').off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 fn_save();
             });
             
             Dmall.validate.set('form_image_config');
             Dmall.common.numeric();
         });
         
         function addGoodsIcon(obj) {
            var $td1= $('td.empty1', '#tbody_icon_info').first()
              , $td2= $('td.empty2', '#tbody_icon_info').first();
            
            if ( $td1.length < 1 ) {
                $('#tbody_icon_info').append('<tr class="searchResult"><td class="empty1"></td><td class="empty2"></td><td class="empty1"></td><td class="empty2"></td><td class="empty1"></td><td class="empty2"></td><td class="empty1"></td><td class="empty2"></td><td class="empty1"></td><td class="empty2"></td></tr>');
                $td1 = $('td.empty1', '#tbody_icon_info').first();
                $td2 = $('td.empty2', '#tbody_icon_info').first();
            }            
            
            // 신규등록(저장처리 전) 아이콘의 경우
            if ('registFlag' in obj && obj.registFlag === 'I') {
                $td1.removeClass('empty1').html('<i class="new">N</i>' + obj.iconPathNm);
                $td2.addClass('newicon');
            } else {
                $td1.removeClass('empty1').html(obj.iconPathNm);
            }
            $td2.removeClass('empty2').data('icon', obj).html('<a href="#" class="btn_del btn_comm">X</a>');

            // 아이콘 설정 체크박스 클릭시 이벤트 설정
            $td2.off('click').on('click', function(e) {
               Dmall.EventUtil.stopAnchorAction(e);
               var $this = jQuery(this);
               // alert(JSON.stringify($this.data('icon')));
               if ($this.data('icon').iconTypeCd === '1') {
                   Dmall.LayerUtil.alert("기본 제공 아이콘은 삭제 하실수 없습니다.", "알림");
                   return;
               } else{
                   
                   if (!$('a', $this).hasClass('del')) {
                       $('a', $this).addClass('del');
                       $this.prev('td').find('img').addClass('del');
                       
                       if ($this.hasClass('newicon')) {
                           $this.removeClass('newicon');
                       } else {
                           $this.addClass('deleteicon');
                       }
                   // 삭제 표시 된 아이콘은 원복
                   } else {
                       $('a', $this).removeClass('del');
                       $this.prev('td').find('img').removeClass('del');
                       $this.removeClass('deleteicon');
                   }
               }
            });
        }
         
         // 아이콘 추가 레이어 팝업 오픈
         function fn_add_icon() {
             if (checkAbleAddIcon()) {
                 Dmall.LayerPopupUtil.open(jQuery('#layer_add_icon'));
             }
             return false;
         }
         
         function checkAbleAddIcon() {
             // alert($('#hd_isAbleAddIcon').val() + ',   '+('true' === $('#hd_isAbleAddIcon').val()));
             if ('true' === $('#hd_isAbleAddIcon').val()) {
                 return true;
             } else {
                 Dmall.LayerUtil.alert("아이콘 추가 구매가 필요합니다.", "알림");
                 return false;
             }
         }

         function fn_setDefault() {
             fn_get_Info();
         }
         
         function fn_get_Info() {
             var url = '/admin/setup/siteinfo/icon-list',
             param = '';             
             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if (result == null || result.success != true) {
                     return;
                 }
                 if (result.resultList.length > 0) {
                     jQuery.each(result.resultList, function(idx, obj) {
                         addGoodsIcon(obj);
                     });
                 } else {
                     $('#tbody_icon_info').append('<tr id="tr_no_icon_info" class="searchResult"><td colspan="10">데이터가 없습니다.</td></tr>');
                 }
             });
         }
        
         function fn_set_result(data) {
             $('[data-find=icon_info]').DataBinder(data);
         }
         
         function fn_save() {
             if(Dmall.validate.isValid('form_image_config')) {
                 var iconParam = [];
                 $('td.deleteicon, td.newicon', '#tbody_icon_info').each(function() {
                     var $this = $(this)
                     , data = $this.data('icon')
                     , obj = {};    
                     
                   if ($this.hasClass('newicon')) {
                       obj['registFlag'] = 'I';
                       obj['imgNm'] = data.fileOrgName;
                       obj['imgPath'] = data.filePath;
                       obj['fileExtension'] = data.fileExtension;
                       
                   } else {
                       obj['registFlag'] = 'D';
                       obj['iconNo'] = data.iconNo;
                       obj['imgNm'] = data.imgNm;
                   }
                   
                   iconParam.push(obj);
                 });
                 
                 var url = '/admin/setup/siteinfo/image-config-update'
                   , param = jQuery('#form_image_config').serializeObject();
                     // , param = jQuery('#form_image_config').serialize();

                 param.iconList = iconParam;
                 
                 /*
                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     Dmall.validate.viewExceptionMessage(result, 'form_image_config');
                     
                     if (result == null || result.success != true) {
                         return;
                     } else {
                         location.replace("/admin/setup/siteinfo/image-config");
                     }
                 });
                 */
                 
                 Dmall.waiting.start();
                 $.ajax({
                       url : url
                     , method : "post"
                     , dataType : 'json'
                     , data : JSON.stringify(param)
                     // , processData : true
                     , contentType : "application/json; charset=UTF-8"
                 }).done(function(result) {
                     if (result) {
                         Dmall.validate.viewExceptionMessage(result, 'form_image_config');
                         if (result == null || result.success != true) {
                             return;
                         } else {
                             location.replace("/admin/setup/siteinfo/image-config");
                         }
                         
                     } else {
                         Dmall.validate.viewExceptionMessage(result, 'form_image_config');
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
             return false;
         }
      </script>
   </t:putAttribute>
    
    <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <h2 class="tlth2">이미지 & 아이콘 설정</h2>
            <!-- <div class="btn_box right">
                <a href="#none" class="btn blue shot" id="btn_save">적용하기</a>
            </div> -->
        </div>
        <form:form id="form_image_config">
        <!-- line_box -->
        <div class="line_box fri">
            
            <h3 class="tlth3">상품 이미지 사이즈 설정 <br/>
                <span class="desc  ml0">
                ※ 상품 등록 시 등록되는 상품 이미지의 사이즈를 조정할 수 있습니다.<br/>
                ※ 상품 이미지 등록 시 본 설정화면에 등록된 사이즈르로 해당 상품이미지의 사이즈를 자동으로 리사이징 합니다.<br/>
                ※ 사이즈는 PIXEL 단위로 입력해주세요.
                </span>     
                <input type="hidden" id="hd_isAbleAddIcon" name="isAbleAddIcon" value="${isAbleAddIcon}" />
            </h3>
            <!-- tblh th_l -->
            <h4>① 메인 전시용 상품 이미지 사이즈 설정</h4>
            <div class="tblh th_l tblmany">
                <table summary="이표는 메인 전시용 상품 이미지 사이즈설정표 입니다. 구성은 typeA, typeB, typeC, typeD 입니다.">
                    <caption>상품 이미지</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>TypeA</th>
                            <th>TypeB</th>
                            <th>TypeC</th>
                            <th>TypeD</th>
                        </tr>
                        <tr>
                            <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeAWidth}" id="goodsDispImgTypeAWidth" name="goodsDispImgTypeAWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeAHeight}" id="goodsDispImgTypeAHeight" name="goodsDispImgTypeAHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                            <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeBWidth}" id="goodsDispImgTypeBWidth" name="goodsDispImgTypeBWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeBHeight}" id="goodsDispImgTypeBHeight" name="goodsDispImgTypeBHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                            <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeCWidth}" id="goodsDispImgTypeCWidth" name="goodsDispImgTypeCWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeCHeight}" id="goodsDispImgTypeCHeight" name="goodsDispImgTypeCHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                            <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeDWidth}" id="goodsDispImgTypeDWidth" name="goodsDispImgTypeDWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeDHeight}" id="goodsDispImgTypeDHeight" name="goodsDispImgTypeDHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>

                        </tr>
                    </tbody>
                </table>
                <table summary="이표는 메인 전시용 상품 이미지 사이즈설정표 입니다. 구성은 typeE,typeF,typeG,typeS  입니다.">
                    <caption>상품 이미지</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>TypeE</th>
                        <th>TypeF</th>
                        <th>TypeG</th>
                        <th>TypeS</th>
                    </tr>
                    <tr>
                        <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeEWidth}" id="goodsDispImgTypeEWidth" name="goodsDispImgTypeEWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeEHeight}" id="goodsDispImgTypeEHeight" name="goodsDispImgTypeEHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                        <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeFWidth}" id="goodsDispImgTypeFWidth" name="goodsDispImgTypeFWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeFHeight}" id="goodsDispImgTypeFHeight" name="goodsDispImgTypeFHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                        <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeGWidth}" id="goodsDispImgTypeGWidth" name="goodsDispImgTypeGWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeGHeight}" id="goodsDispImgTypeGHeight" name="goodsDispImgTypeGHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                        <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeSWidth}" id="goodsDispImgTypeSWidth" name="goodsDispImgTypeSWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDispImgTypeSHeight}" id="goodsDispImgTypeEHeight" name="goodsDispImgTypeSHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblh th_l -->
            <!-- tblh th_l -->
            <h4>② 기본 상품 이미지 사이즈 설정</h4>
            <div class="tblh th_l tblmany">
                <table summary="이표는 기본 상품 이미지 사이즈 설정표 입니다. 구성은 기본이미지, 리스트 썸네일  입니다.">
                    <caption>상품 이미지</caption>
                    <colgroup>
                        <col width="50%">
                        <col width="50%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>기본이미지</th>
                            <th>리스트 썸네일</th>
                        </tr>
                        <tr>
                            <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDefaultImgWidth}" id="goodsDefaultImgWidth" name="goodsDefaultImgWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsDefaultImgHeight}" id="goodsDefaultImgHeight" name="goodsDefaultImgHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                            <td><span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsListImgWidth}" id="goodsListImgWidth" name="goodsListImgWidth" data-validation-engine="validate[required, maxSize[4]]" /></span> X <span class="intxt"><input type="text" class="numeric" value="${resultModel.data.goodsListImgHeight}" id="goodsListImgHeight" name="goodsListImgHeight" data-validation-engine="validate[required, maxSize[4]]" /></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblh th_l -->
            
            <h3 class="tlth3">상품 아이콘 관리
                    <div class="right">
                        <a href="#none" class="btn_gray2 change_btn" id="btn_add_icon">아이콘 추가</a>
                    </div>
            </h3>
            <!-- tblh th_l -->
            <div class="tblh th_l tblmany t_icon">
                <table summary="이표는 상품 아이콘 관리 표 입니다. 구성은 아이콘, 삭제버튼 입니다.">
                    <caption>상품 이미지</caption>
                    <colgroup>
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>아이콘</th>
                            <th>관리</th>
                            <th>아이콘</th>
                            <th>관리</th>
                            <th>아이콘</th>
                            <th>관리</th>
                            <th>아이콘</th>
                            <th>관리</th>
                            <th>아이콘</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_icon_info">
                        <!--
                        <tr>
                            <td><img src="../inc/img/product/ico_col1.png" alt="신상품아이콘"></td>
                            <td class="bdl_0"><a href="#" class="btn_gray">X</a></td>
                            <td><img src="../inc/img/product/ico_col2.png" alt="신상품아이콘"></td>
                            <td class="bdl_0"><a href="#" class="btn_gray">X</a></td>
                            <td><img src="../inc/img/product/ico_col3.png" alt="신상품아이콘"></td>
                            <td class="bdl_0"><a href="#" class="btn_gray">X</a></td>
                            <td><img src="../inc/img/product/ico_col4.png" alt="신상품아이콘"></td>
                            <td class="bdl_0"><a href="#" class="btn_gray">X</a></td>
                            <td><img src="../inc/img/product/ico_col5.png" alt="신상품아이콘"></td>
                            <td class="bdl_0"><a href="#" class="btn_gray">X</a></td>
                        </tr>
                        -->
                    </tbody>
                </table>
            </div>
            <!-- //tblh th_l -->
            
        </div>
        <!-- //line_box -->

        </form:form>

		<div class="btn_box txtc">
                <a href="#none" class="btn blue shot" id="btn_save">적용하기</a>
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
                    <form action="/admin/setup/siteinfo/icon-image-upload" name="fileUploadForm" id="fileUploadForm" method="post">
                        <span class="intxt imgup1">
                            <input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled">
                        </span>
                        <label class="filebtn" for="icon_file">파일찾기</label>
                        <input class="filebox" name="files" type="file" id="icon_file" accept="image/*">
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
    
    </t:putAttribute>
</t:insertDefinition>