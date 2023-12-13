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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 기본관리 &gt; 세금계산서 설정</t:putAttribute>
    <t:putAttribute name="script">
      <script type="text/javascript">
          $(document).ready(function() {
              TaxBillUtil.init();
              TaxBillUtil.render();
              
              $('#btn_save').off('click').on('click', function(e) {
                  Dmall.EventUtil.stopAnchorAction(e);
                  TaxBillUtil.save();
              });
              
              $('#deleteFileBtn').off('click').on('click', function(e) {
                  Dmall.EventUtil.stopAnchorAction(e);
                  TaxBillUtil.deleteImg();
              });
              
              Dmall.validate.set('form_taxbill_config');
          });
          
          var TaxBillUtil = {
              sealImgPath:''
              , init:function() {
                  $('label.chack').off('click').on('click', function(e) {
                      Dmall.EventUtil.stopAnchorAction(e);
                      var $this = jQuery(this),
                          $input = jQuery("#" + $this.attr("for")),
                          checked = !($input.prop('checked'));
                      $input.prop('checked', checked);
                      $this.toggleClass('on');
                  });  
              }
              , render:function() {
                  var url = '/admin/setup/config/taxbill/taxbill-config-info',
                  param = '',
                  dfd = jQuery.Deferred();
                  
                  Dmall.AjaxUtil.getJSON(url, param, function(result) {
                      if (result == null || result.success != true) {
                          return;
                      }

                      TaxBillUtil.bind(result.data);
                      dfd.resolve(result.resultList);
                      
                      //sealImgPath inputbox는 언제나 disabled상태여야 한다.
                      $('#seal_sealImgPath').prop('disabled', true);
                  });
                  return dfd.promise();
              }
              , bind:function(data) {
                  $('[data-find="taxbill_config"]').DataBinder(data);
                  
                  TaxBillUtil.sealImgPath = data.sealImgPath;
                  var fileName = data.sealImgPath.split('\\')[1];
                  //섬네일 img태그에 경로 설정
                  if(data.sealImgPath === '') {
                      $('#taxbillImg').attr('src', '/admin/img/product/tmp_img01.png');
                  } else {
                      //url 파라미터중 id3에 의미없는 new Date().getTime()파라미터를 추가한 이유는 
                      //파이어폭스에서 갱신하려는 이미지경로가 같을경우 갱신을 하지 않기때문에 해당 이미지경로가 다르게끔 속이기 위한것이다.
                      //참고주소: http://dyoona.tistory.com/7
                      $('#taxbillImg').removeAttr('src').attr('src', '${_IMAGE_DOMAIN}/image/image-view?type=TAXBILL&id1=' + fileName + '&id3=' + new Date().getTime());
                  }
                  
                  $('#thumbFileName').text(data.sealImgPath.split('\\')[1]);
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
                      $input.data('value','Y').prop('checked', true); 
                  } else {
                      $label.removeClass('on');
                      $input.data('value','N').prop('checked', false);
                  }             
              }
              , setDlvrcInclusionYn:function(data, obj, bindName, target, area, row) {
                  var bindValue = obj.data("bind-value")
                  , value = data[bindValue];

                  $("input:radio[name=dlvrcInclusionYn][value=" + value + "]").trigger('click');
              }
              , setSvmnInclusionYn:function(data, obj, bindName, target, area, row) {
                  var bindValue = obj.data("bind-value")
                  , value = data[bindValue];

                  $("input:radio[name=svmnInclusionYn][value=" + value + "]").trigger('click');
              }
              , setOrdAmtYn:function(data, obj, bindName, target, area, row) {
                  var bindValue = obj.data("bind-value")
                  , value = data[bindValue];

                  $("input:radio[name=ordAmtYn][value=" + value + "]").trigger('click');
              }
              , setTaxBillTypeCd:function(data, obj, bindName, target, area, row) {
                  var bindValue = obj.data("bind-value")
                      , value = data[bindValue];

                  $("input:radio[name=taxbillTypeCd][value=" + value + "]").trigger('click');
              }
              , customAjax:function(url, callback) {
                  $('#form_taxbill_config').ajaxSubmit({
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
              , save:function() {
                  if(Dmall.validate.isValid('form_taxbill_config')) {
                    //폼전송시 sealImgPath 파라미터 전송을 위해 잠시 disabled 상태를 제거한다.
                      $('#seal_sealImgPath').removeAttr('disabled');
                      
                      var url = '/admin/setup/config/taxbill/taxbill-config-update';
                      //Ajax를 공통 템플릿에 있는것을 사용안하고 새로 만들어서 사용하는 이유는
                      //Multipart 폼을 Ajax로 넘기려면 공통 템플릿에서 제공하는 Ajax함수로는 IE에서 작동하지 않는다.
                      //따라서 jquery.form.js에 존재하는 ajaxSubmit방식을 사용하여 통신한다.
                      TaxBillUtil.customAjax(url, function(result) {
                          Dmall.validate.viewExceptionMessage(result, 'form_taxbill_config');
                          
                          if (result == null || result.success != true) {
                              return;
                          } else {
                              TaxBillUtil.render();
                          }
                      });
                  }
                  return false;
              }
              , deleteImg:function() {
                  if($('#chk_sealImgPath').next().hasClass('on')) {
                      if(TaxBillUtil.sealImgPath === '') {
                          alert('삭제할 이미지가 존재하지 않습니다.');
                          return;
                      } else if(confirm('정말 인감이미지를 삭제하시겠습니까?')) {
                          var url = '/admin/setup/config/taxbill/taxbill-image-delete',
                          param = {'sealImgPath':TaxBillUtil.sealImgPath};
                      
                          Dmall.AjaxUtil.getJSON(url, param, function(result) {
                              Dmall.validate.viewExceptionMessage(result, 'form_taxbill_config');
                              
                              if (result == null || result.success != true) {
                                  return;
                              } else {
                                  TaxBillUtil.render();
                              }
                          });
                      }
                  } else {
                      alert('삭제할 인감이미지를 선택해주세요.');
                      return;
                  }
              }
              , readThumbnail:function (input) {
                  var ext = $(input).val().split('.').pop().toLowerCase();
                  if($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {
                      alert('이미지 파일이 아닙니다. (gif, png, jpg, jpeg 만 업로드 가능)');
                      return;
                  } else {
                      if (input.files && input.files[0]) {
                          var reader = new FileReader();
                          reader.onload = function (e) {
                              $('#taxbillImg').attr('src', e.target.result);
                          }
                          reader.readAsDataURL(input.files[0]);
                          $('#thumbFileName').text(input.files[0].name);
                      }
                  }
              }
          };
      </script>
   </t:putAttribute>
    
    <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <h2 class="tlth2">전자 세금계산서 설정</h2>
            <div class="btn_box right">
                <a href="#none" class="btn blue shot" id="btn_save">저장하기</a>
            </div>
        </div>
        
        <form id="form_taxbill_config" method="post" accept-charset="utf-8">
        <!-- line_box -->
        <div class="line_box fri">
            <h3 class="tlth3 btn1">설정정보 <span class="desc">회원에게 발행되는 세금계산서에 대한 정책입니다.</span></h3>
            <!-- tblw -->
            <div class="tblw">
                <table summary="이표는 설정정보 표 입니다. 구성은 발행기능 사용여부, 발행 결제조건, 발행일자, 배송비 설정, 마켓포인트 설정, 금액 설정, 이용안내문구, 인감이미지 입니다.">
                    <caption>설정정보</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody id="tbodyTaxBill">
                        <tr>
                            <th>발행기능 사용여부</th>
                            <td id="td_taxbillTypeCd" data-find="taxbill_config" data-bind-value="taxbillTypeCd" data-bind-type="function" data-bind-function="TaxBillUtil.setTaxBillTypeCd">
                                <label for="rdo_taxbillTypeCd1" class="radio mr20"><span class="ico_comm"><input type="radio" name="taxbillTypeCd" id="rdo_taxbillTypeCd1" value="1"></span> LG Biz 전자세금계산서 사용</label>
                                <label for="rdo_taxbillTypeCd2" class="radio mr20"><span class="ico_comm"><input type="radio" name="taxbillTypeCd" id="rdo_taxbillTypeCd2" value="2"></span> 타사 솔루션 사용</label>
                                <label for="rdo_taxbillTypeCd3" class="radio mr20"><span class="ico_comm"><input type="radio" name="taxbillTypeCd" id="rdo_taxbillTypeCd3" value="0"></span> 사용안함</label>
                            </td>
                        </tr>
                        <tr>
                            <th>발행 결제조건</th>
                            <td>
                                <input type="checkbox" name="taxbillNopbUseYn" id="chk_taxbillNopbUseYn" value="Y" class="blind" >
                                <label for="chk_taxbillNopbUseYn" class="chack mr20" data-find="taxbill_config" data-bind-value="taxbillNopbUseYn" data-bind-type="function" data-bind-function="TaxBillUtil.setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    무통장
                                </label>
                                <input type="checkbox" name="taxbillActtransUseYn" id="chk_taxbillActtransUseYn" value="Y" class="blind">
                                <label for="chk_taxbillActtransUseYn" class="chack mr20" data-find="taxbill_config" data-bind-value="taxbillActtransUseYn" data-bind-type="function" data-bind-function="TaxBillUtil.setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    계좌이체
                                </label>
                                <input type="checkbox" name="taxbillVirtactUseYn" id="chk_taxbillVirtactUseYn" value="Y" class="blind">
                                <label for="chk_taxbillVirtactUseYn" class="chack mr20" data-find="taxbill_config" data-bind-value="taxbillVirtactUseYn" data-bind-type="function" data-bind-function="TaxBillUtil.setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    가상계좌
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <th>발행일자</th>
                            <td>결제완료일(고정)</td>
                        </tr>
                        <tr>
                            <th>배송비 설정</th>
                            <td id="td_dlvrcInclusionYn" data-find="taxbill_config" data-bind-value="dlvrcInclusionYn" data-bind-type="function" data-bind-function="TaxBillUtil.setDlvrcInclusionYn">
                                <label for="rdo_dlvrcInclusionYn_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="dlvrcInclusionYn" id="rdo_dlvrcInclusionYn_Y" value="Y"></span> 배송비 포함</label>
                                <label for="rdo_dlvrcInclusionYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="dlvrcInclusionYn" id="rdo_dlvrcInclusionYn_N" value="N"></span> 배송비 제외</label>
                            </td>
                        </tr>
                        <tr>
                            <th>마켓포인트 설정</th>
                            <td id="td_svmnInclusionYn" data-find="taxbill_config" data-bind-value="svmnInclusionYn" data-bind-type="function" data-bind-function="TaxBillUtil.setSvmnInclusionYn">
                                <label for="rdo_svmnInclusionYn_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="svmnInclusionYn" id="rdo_svmnInclusionYn_Y" value="Y"></span> 마켓포인트 포함</label>
                                <label for="rdo_svmnInclusionYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="svmnInclusionYn" id="rdo_svmnInclusionYn_N" value="N"></span> 마켓포인트 제외</label>
                            </td>
                        </tr>
                        <tr>
                            <th>금액 설정</th>
                            <td id="td_ordAmtYn" data-find="taxbill_config" data-bind-value="ordAmtYn" data-bind-type="function" data-bind-function="TaxBillUtil.setOrdAmtYn">
                                <label for="rdo_ordAmtYn_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="ordAmtYn" id="rdo_ordAmtYn_Y" value="Y"></span> 주문금액</label>
                                <label for="rdo_ordAmtYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="ordAmtYn" id="rdo_ordAmtYn_N" value="N"></span> 실결제금액(각종할인금액 제외)</label>
                            </td>
                        </tr>
                        <tr>
                            <th>이용안내문구</th>
                            <td>
                                <div class="txt_area">
                                    <textarea name="useGuideWords" id="txt_useGuideWords" data-find="taxbill_config" data-bind-value="useGuideWords" data-bind-type="text" maxlength="1000" data-validation-engine="validate[maxSize[1000]]"></textarea>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>인감이미지</th>
                            <td>
                                 <span class="intxt"><input type="text" id="seal_sealImgPath" class="upload-name" name="sealImgPath" value="파일선택" data-find="taxbill_config" data-bind-value="sealImgPath" data-bind-type="text" disabled="disabled"></span>
                                 <label class="filebtn" for="fileUploadBtn">파일찾기</label>
                                 <input class="filebox" type="file" name="uploadFile" id="fileUploadBtn"  onchange="TaxBillUtil.readThumbnail(this);">
                                 <a href="#none" id="deleteFileBtn" class="btn_gray">삭제</a>
                                 <span class="br2"></span>
                                 <div class="gallery_lay">
                                     <input type="checkbox" id="chk_sealImgPath" class="blind">
                                     <label for="chk_sealImgPath" class="chack mr20" onclick="chack_btn(this);">
                                         <span class="ico_comm">&nbsp;</span>
                                         <img id="taxbillImg" class="img" alt="">
                                         <span id="thumbFileName">File name</span>
                                     </label>
                                 </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
            <p class="desc_list mb0">참고 !</p>
            <ul class="desc_list mt0">
                <li>세금계산서는 결제완료 이후 발행신청이 가능합니다.</li>
                <li>세금계산서 발행은 결제완료 이후 신청이 가능합니다.</li>
                <li>세금계산서 발행일자는 결제완료일로 고정되어 있습니다.</li>
            </ul>
        </div>
        <!-- //line_box -->

        </form>
    </div>
    </t:putAttribute>
</t:insertDefinition>