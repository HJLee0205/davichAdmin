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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 운영지원 관리 &gt; 구글애널리틱스</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function() {
                GaRenderUtil.render();
       
                $('#btnSave').off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    GaSubmitUtil.submit();
                });
       
                $('#gaInfoBtn').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.open($('#gaInfoLayer'));
                });
                
                $('#gaDashboardBtn').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.open($('#gaDashboardLayer'));
                });
                
                Dmall.validate.set('form_ga_info');
            });
            
            var GaInitUtil = {
                setUseYn:function(data, obj, bindName, target, area, row) {
                    var bindValue = obj.data("bind-value")
                        , value = data[bindValue];
     
                    $("input:radio[name=useYn][value=" + value + "]").trigger('click');
                }
            };
            
            var GaRenderUtil = {
                render:function() {
                    var url = '/admin/setup/config/opersupport/ga-config',
                    dfd = jQuery.Deferred();
                    
                    Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }
                        
                        GaRenderUtil.bind(result.data);
                        dfd.resolve(result.data);
                    });
                    return dfd.promise();
                }
                , bind:function(data) {
                    $('[data-find="ga_config"]').DataBinder(data);
                }
            };
            
            var GaSubmitUtil = {
                customAjax:function(url, callback) {
                    $('#form_ga_info').ajaxSubmit({
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
                    if(Dmall.validate.isValid('form_ga_info')) {
                        var url = '/admin/setup/config/opersupport/ga-config-update';
                        param = {'useYn':$('input[name=useYn]:checked').val(), 'anlsId':$('#anlsId').val()};
                        
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_ga_info');
                            
                            if (result == null || result.success != true) {
                                return;
                            } else {
                                GaRenderUtil.render();
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
                <h2 class="tlth2">구글애널리틱스</h2>
            </div>
            <!-- line_box -->
            <form id="form_ga_info" method="post">
                <div class="line_box fri">
                    <h3 class="tlth3 btn1">GA(Google Analytics)세팅 방법</h3>
                    <div class="Explanation_box marginB40">
                        <ul class="gglPp">
                            <li>① Google 애널리틱스 가입하세요. <a href="http://google.co.kr/analytics" target="_blank">(http://google.co.kr/analytics)</a> </li>
                            <li>② 새 계정 생성을 위한 필수 항목 입력하세요.</li>
                            <li>③ 추적 ID가져오기 버튼을 클릭합니다.</li>
                            <li>④ 이동된 페이지에서 추적ID를 확인합니다.</li>
                            <li>⑤ 다시 쇼핑몰 관리자 화면의 구글 애널리틱스 단계별 사용 설정 화면으로 이동합니다.<br>
                                <span>1단계 방문통계 데이터 분석 사용 선택 후 추적 ID 입력란 에 해당 추적 ID 입력 후 저장합니다.</span></li>
                            <li>⑥ 이로써 1단계 방문통계 데이터 분석을 위한 설정을 완료하였습니다.<br>
                                <span>일정시간(최대 하루) 뒤 구글 애널리틱스 화면에서 쇼핑몰 방문통계 데이터를 확인할 수 있습니다.</span></li>
                        </ul>
                    </div>
                    <h3 class="tlth3">구글애널리틱스 서비스 사용설정 </h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="구글애널리틱스 서비스 사용설정 표 입니다. 구성은 구글애널리틱스 서비스 사용여부, 추적 ID입니다.">
                            <caption>구글애널리틱스 설정</caption>
                            <colgroup>
                                <col width="160px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>구글 애널리틱스 활성</th>
                                <td id="ul_useYn" data-find="ga_config" data-bind-value="useYn" data-bind-type="function" data-bind-function="GaInitUtil.setUseYn">
                                    <label for="rdo_useYn_Y" class="radio on mr20"><span class="ico_comm"><input type="radio" name="useYn" id="rdo_useYn_Y" value="Y"></span> 사용함</label>
                                    <label for="rdo_useYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn" id="rdo_useYn_N" value="N"></span> 사용안함</label>
                                </td>
                            </tr>
                            <tr>
                                <th>추적 ID</th>
                                <td>
                                    <span class="intxt long">
                                        <input type="text" id="anlsId" name="anlsId" data-find="ga_config" data-bind-value="anlsId" data-bind-type="text"/>
                                    </span>
                                    <span class="desc_txt">
                                        구글에서 추적ID를 먼저 발급받아 입력한 경우에만 방문통계 데이터를 구글측으로 전송합니다.
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="btnSave">저장하기</button>
                </div>
            </div>
        </div>
        
        <%@ include file="popup/gaInfoPopup.jsp" %>
        <%@ include file="popup/gaDashboardManagePopup.jsp" %>
    </t:putAttribute>
</t:insertDefinition>