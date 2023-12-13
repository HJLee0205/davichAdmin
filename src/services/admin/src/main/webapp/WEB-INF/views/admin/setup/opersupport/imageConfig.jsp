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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 운영지원 관리 &gt; 이미지 호스팅</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function() {
                ImageHostingRenderUtil.render();
            });
            
            var ImageHostingRenderUtil = {
                render:function() {
                    var url = '/admin/setup/config/opersupport/image-config',
                    dfd = jQuery.Deferred();
                    
                    Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }
                        
                        if(result.data === null || result.data.applyInfo === null) {
                            $('#applyInfo').text('이미지호스팅 서비스 미이용중');
                        } else {
                            ImageHostingRenderUtil.bind(result.data);
                        }
                        
                        dfd.resolve(result.data);
                    });
                    return dfd.promise();
                }
                , bind:function(data) {
                    $('#url').text(data.imgServUrl);
                    $('#applyInfo').text(data.applyInfo);
                    $('#usePeriod').text(data.svcUseStartPeriod.substring(0, 10) + ' ~ ' +data.svcUseEndPeriod.substring(0, 10));
                    $('#useDisk').text(data.disk +'Gbyte');
                }
            };
        </script>
    </t:putAttribute>
    
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">이미지 호스팅</h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue shot">신청하기</a>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">이미지호스팅 상세 설정 </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이미지호스팅 상세 설정 표 입니다. 구성은 URL, 신청정보, 서비스 이용기간, 서비스 신청용량 입니다.">
                        <caption>이미지호스팅 상세 설정</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>URL</th>
                                <td id="url"></td>
                            </tr>
                            <tr>
                                <th>신청정보</th>
                                <td id="applyInfo"></td>
                            </tr>
                            <tr>
                                <th>서비스 이용기간</th>
                                <td id="usePeriod"></td>
                            </tr>
                            <tr>
                                <th>서비스 신청용량</th>
                                <td id="useDisk"></td>
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