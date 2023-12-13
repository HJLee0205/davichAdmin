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
    <t:putAttribute name="title">컨텐츠 무단 복사 보호</t:putAttribute>
    <t:putAttribute name="script">
	    <script>
            jQuery(document).ready(function() {
                jQuery('#a_id_save').on('click', function() {
                    var url = '/admin/setup/securitymanage/SecurityManage/contents-protection-update',
                        param = {
                            mouseRclickUseYn : jQuery('input[name="mouseRclickUseYn"]:checked').val(),
                            dragCopyUseYn : jQuery('input[name="dragCopyUseYn"]:checked').val()
                        };
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {});
                });
            });
        </script>
	</t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">컨텐츠 무단 복사 보호</h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue shot" id="a_id_save">저장하기</a>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">
                    컨텐츠 무단 복사 보호 설정
                </h3>
                <!-- tblw -->
                <div class="tblw">
                    <table summary="이표는 컨텐츠 무단 복사 보호 설정 표 입니다. 구성은 마우스 우클릭 사용여부, 드래그&amp;복사 사용여부 입니다.">
                        <caption>컨텐츠 무단 복사 보호 설정</caption>
                        <colgroup>
                            <col width="22%">
                            <col width="78%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>마우스 우클릭 사용여부</th>
                            <td>
                                <tags:radio codeStr="Y: 사용;N: 사용안함(상품이미지를 포함하여 마우스 오른쪽 클릭을 통한 도구창 사용 안함)" name="mouseRclickUseYn" idPrefix="radio1_" value="${po.mouseRclickUseYn}" />
                            </td>
                        </tr>
                        <tr>
                            <th>드래그&복사 사용여부</th>
                            <td>
                                <tags:radio codeStr="Y: 사용;N: 사용안함(컨텐츠의 드래그와 Ctrl키 사용 안함)" name="dragCopyUseYn" idPrefix="radio2_" value="${po.dragCopyUseYn}" />
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