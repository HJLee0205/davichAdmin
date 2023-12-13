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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; SNS/외부연동 &gt; 콘텐츠 공유 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function() {
                //콘텐츠 공유관리 설정 호출
                ContentUtil.render();
                
                // 저장하기 버튼 클릭시
                $('#btnSave').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    ContentUtil.submit();
                });
            });
            
            var ContentUtil = {
                render:function() {
                    //콘텐츠 공유관리 사용여부 정보 조회
                    var url = '/admin/setup/config/snsoutside/contents-config',
                    dfd = jQuery.Deferred();
                    
                    Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }

                        dfd.resolve(result.data);
                        ContentUtil.bind(result.data);
                    });
                    return dfd.promise();
                }
                , bind:function(data) {
                    $('[data-find="contents_info"]').DataBinder(data);
                    //위에서 DataBinder를 하지만 다시 라디오버튼을 checked를 해주는 이유는
                    //설정정보 변경시 사용여부를 한번도 클릭하지 않고 그대로 저장하기 버튼을 클릭하면 현재 체크된 값을 가지고 오질 못해서
                    $("input:radio[id='rdo_contsUseYn_"+data.contsUseYn+"']").prop('checked', 'checked');
                }
                , submit:function() {
                    var url = '/admin/setup/config/snsoutside/contents-config-update'
                        , param = {'contsUseYn':$("input:radio[name='contsUseYn']:checked").val()};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        } else {
                          //콘텐츠 공유관리 사용여부 정보 조회
                            ContentUtil.render();
                        }
                    });
                    return false;
                }
            };
        </script>
    </t:putAttribute>

    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">콘텐츠 공유관리</h2>
                <div class="btn_box right">
                    <a href="#none" id="btnSave" class="btn blue shot">저장하기</a>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">콘텐츠 공유 관리 설정 </h3>
                <!-- tblw -->
                <div class="tblw">
                    <table summary="이표는 콘텐츠 공유 관리 설정 표 입니다. 구성은 사용설정 입니다.">
                        <caption>콘텐츠 공유 관리 설정</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>사용설정</th>
                                <td data-find="contents_info" data-bind-value="contsUseYn" data-bind-type="labelcheckbox">
                                    <label for="rdo_contsUseYn_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="contsUseYn" id="rdo_contsUseYn_Y" value="Y"></span> 사용</label>
                                    <label for="rdo_contsUseYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="contsUseYn" id="rdo_contsUseYn_N" value="N"></span> 사용안함</label>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>