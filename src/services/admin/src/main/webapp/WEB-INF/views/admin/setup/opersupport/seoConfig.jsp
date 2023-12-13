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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 운영지원 관리 &gt; SEO 설정</t:putAttribute>
    <t:putAttribute name="script">
     <script type="text/javascript">
         $(document).ready(function() {
             SeoRenderUtil.render();
    
             jQuery('#btnSave').off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 SeoSubmitUtil.submit();
             });
    
             Dmall.validate.set('form_seo_info');
         });
         
         var SeoInitUtil = {
             setCmnUseYn:function(data, obj, bindName, target, area, row) {
                 var bindValue = obj.data("bind-value")
                     , value = data[bindValue];
  
                 $("input:radio[name=cmnUseYn][value=" + value + "]").trigger('click');
             }
             , setGoodsUseYn:function(data, obj, bindName, target, area, row) {
                 var bindValue = obj.data("bind-value")
                 , value = data[bindValue];
    
                 $("input:radio[name=goodsUseYn][value=" + value + "]").trigger('click');
             }
         };
         
         var SeoRenderUtil = {
             render:function() {
                 var url = '/admin/setup/config/opersupport/seo-config',
                 dfd = jQuery.Deferred();
                 
                 Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                     if (result == null || result.success != true) {
                         return;
                     }
                     
                     SeoRenderUtil.bind(result.data);
                     dfd.resolve(result.data);
                     
                   //sealImgPath inputbox는 언제나 disabled상태여야 한다.
                     $('#file_srchFilePath').prop('disabled', true);
                 });
                 return dfd.promise();
             }
             , bind:function(data) {
                 $('[data-find="seo_config"]').DataBinder(data);
             }
         };
         
         var SeoSubmitUtil = {
             customAjax:function(url, callback) {
                 $('#form_seo_info').ajaxSubmit({
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
                 if(Dmall.validate.isValid('form_seo_info')) {
                       var url = '/admin/setup/config/opersupport/seo-config-update';
                       $('#file_srchFilePath').removeAttr('disabled');
                       //Ajax를 공통 템플릿에 있는것을 사용안하고 새로 만들어서 사용하는 이유는
                       //Multipart 폼을 Ajax로 넘기려면 공통 템플릿에서 제공하는 Ajax함수로는 IE에서 작동하지 않는다.
                       //따라서 jquery.form.js에 존재하는 ajaxSubmit방식을 사용하여 통신한다.
                       SeoSubmitUtil.customAjax(url, function(result) {
                           Dmall.validate.viewExceptionMessage(result, 'form_seo_info');
                           
                           if (result == null || result.success != true) {
                               return;
                           } else {
                               SeoRenderUtil.render();
                           }
                       });
                   }                
                   return false;
             }
         };
       </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">SEO</h2>
            </div>
            <!-- line_box -->
            <form id="form_seo_info" method="post" accept-charset="utf-8" enctype="multipart/form-data">
                <div class="line_box fri">
                    <div class="Explanation_box seo marginB40">
                        <h3 class="tlth5">검색엔진최적화(SEO) 소개 <br /><br />
                            <span class="desc1 ml0">구글, 네이버, 다음 등의 검색 엔진이 귀사 사이트에서
                              수집해가는 정보를 최적화 함으로써 검색사이트에서 귀사
                              사이트의 가시성이 향상됩니다.<br />결론적으로 검색 엔진
                              최적화(SEO) 작업은 귀사 사이트의 방문율을 높일 수 있는
                              효과적인 방법입니다.
                            </span>
                        </h3>
                    </div>
                    <h3 class="tlth3">사이트 공통 SEO 태그 설정 </h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="사이트 공통 SEO 태그 설정 표 입니다. 구성은 사용여부, 사이트제목, 사이트 제작자, 사이트 설명, 키워드입니다.">
                            <caption>사이트 공통 SEO 태그 설정</caption>
                            <colgroup>
                                <col width="190px" />
                                <col width="" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>사용여부</th>
                                <td id="td_cmnUseYn" data-find="seo_config" data-bind-value="cmnUseYn" data-bind-type="function" data-bind-function="SeoInitUtil.setCmnUseYn">
                                    <label for="rdo_cmnUseYn_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="cmnUseYn" id="rdo_cmnUseYn_Y" value="Y"></span> 사용함</label>
                                    <label for="rdo_cmnUseYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="cmnUseYn" id="rdo_cmnUseYn_N" value="N"></span> 사용안함</label>
                                </td>
                            </tr>
                            <tr>
                                <th>사이트 제목 (TITLE)</th>
                                <td>
                                    <span class="intxt wid480"><input type="text" id="cmnTitle" name="cmnTitle" data-find="seo_config" data-bind-value="cmnTitle" data-bind-type="text"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>사이트 제작자(AUTHOR)</th>
                                <td>
                                    <span class="intxt wid480"><input type="text" id="cmnManager" name="cmnManager" data-find="seo_config" data-bind-value="cmnManager" data-bind-type="text"></span>
                                    <span class="br2"></span>
                                    <span class="fc_pr1 fs_pr1">* 페이지 또는 웹 사이트의 제작자명이나 상점명을 명시할 수 있습니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <th>사이트 설명(DESCRIPTION)</th>
                                <td>
                                    <span class="intxt wid480"><input type="text" id="cmnDscrt" name="cmnDscrt" data-find="seo_config" data-bind-value="cmnDscrt" data-bind-type="text"></span>
                                    <span class="br2"></span>
                                    <span class="fc_pr1 fs_pr1">* 검색엔진의 검색결과에서 페이지의 요약내용을 보여주는 부분으로 1-2개의 문장이나 짧은 단락을 사용하는 것이 좋습니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <th>키워드(KEYWORDS)</th>
                                <td>
                                    <span class="intxt wid480"><input type="text" id="cmnKeyword" name="cmnKeyword" data-find="seo_config" data-bind-value="cmnKeyword" data-bind-type="text"></span>
                                    <span class="br2"></span>
                                    <span class="fc_pr1 fs_pr1">* 사용자가 많이 검색하는 검색어 및 사이트와 연관된 키워드 정보를 기입합니다.<br/>
                                    * , 를 이용하여 여러 단어를 등록할 수 있습니다.</span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->

                    <h3 class="tlth3">상품 상세 페이지 SEO 태그 설정 </h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="상품 상세 페이지 SEO 태그 설정 표 입니다. 구성은 사용여부, 사이트제목, 사이트 제작자, 사이트 설명, 키워드입니다.">
                            <caption>상품 상세 페이지 SEO 태그 설정</caption>
                            <colgroup>
                                <col width="190px" />
                                <col width="" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>사용여부</th>
                                <td id="td_goodsUseYn" data-find="seo_config" data-bind-value="goodsUseYn" data-bind-type="function" data-bind-function="SeoInitUtil.setGoodsUseYn">
                                    <label for="rdo_goodsUseYn_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="goodsUseYn" id="rdo_goodsUseYn_Y" value="Y"></span> 사용함</label>
                                    <label for="rdo_goodsUseYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="goodsUseYn" id="rdo_goodsUseYn_N" value="N"></span> 사용안함</label>
                                </td>
                            </tr>
                            <tr>
                                <th>상품 상세 제목 (TITLE)</th>
                                <td>
                                    <span class="intxt wid480"><input type="text" id="goodsTitle" name="goodsTitle" data-find="seo_config" data-bind-value="goodsTitle" data-bind-type="text"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>상품 상세 제작자(AUTHOR)</th>
                                <td>
                                    <span class="intxt wid480"><input type="text" id="goodsManager" name="goodsManager" data-find="seo_config" data-bind-value="goodsManager" data-bind-type="text"></span>
                                    <span class="br2"></span>
                                    <span class="fc_pr1 fs_pr1">* 페이지 또는 웹 사이트의 제작자명이나 상점명을 명시할 수 있습니다.</span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->

                    <h3 class="tlth3">검색로봇 접근 제어</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="검색로봇 접근 제어 표 입니다. 구성은 첨부파일 업로드입니다.">
                            <caption>PG연동 설정</caption>
                            <colgroup>
                                <col width="190px" />
                                <col width="" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>Robots.txt</th>
                                <td>
                                    <span class="intxt wid480"><input id="file_srchFilePath" class="upload-name" type="text" id="srchFilePath" name="srchFilePath" data-find="seo_config" data-bind-value="srchFilePath" data-bind-type="text" disabled="disabled"></span>
                                    <label class="filebtn" for="uploadSrchFilePathBtn">파일찾기</label>
                                    <input class="filebox" type="file" id="uploadSrchFilePathBtn"  name="uploadSrchFilePath" accept="text/plain">
                                    <span class="br2"></span>
                                    <span class="fc_pr1 fs_pr1">* robots.txt 파일은 사이트를 각종 검색엔진의 검색로봇에서 제외하는 표준규약 입니다.<br/>
                                    * 특정 검색엔진의 검색로봇을 막으시거나 사이트내 특정페이지의 접근을 막기 위해서는 표준 문법에 따라 robots.txt 파일을 작성하여 사이트에 배치하여 보안을 강화할 수 있습니다.<br/>
                                    * 특히 admin 디렉토리와 계정정보들이 포함되어 있는 디렉토리는 보호하는 것을 권장합니다.</span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
            <!-- //line_box -->
            </form>
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="btnSave">저장하기</button>
                </div>
            </div>
        </div>
    </t:putAttribute>
    <div id="footer">copyright © D-Mall. all right reserved.</div>
</t:insertDefinition>