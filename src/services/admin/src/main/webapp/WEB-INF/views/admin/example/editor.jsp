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
    <t:putAttribute name="title">테스트</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">

            jQuery(document).ready(function() {

                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content1 를 ID로 가지는 Textarea를 에디터로 설정
                Dmall.DaumEditor.create('ta_id_content2'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                Dmall.DaumEditor.setContent('ta_id_content2', '1111')

                // 조회 버튼 이벤트 처리
                jQuery('#a_id_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    Dmall.AjaxUtil.getJSON('/admin/example/load-editor', jQuery('#form_id_content2').serialize(), function(result) {

                        jQuery('input[name="name"]').val(result.data.name);
                        
                        Dmall.DaumEditor.setContent('ta_id_content2', result.data.content); // 에디터에 데이터 세팅
                        Dmall.DaumEditor.setAttachedImage('ta_id_content2', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                    })
                });

                // 저장 버튼 이벤트 처리
                jQuery('#a_id_save').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.DaumEditor.setValueToTextarea('ta_id_content2');  // 에디터에서 폼으로 데이터 세팅

                    Dmall.AjaxUtil.getJSON('/admin/example/save-editor', jQuery('#form_id_content2').serialize(), function(result) {

                    });
                });
                // 초기화 버튼 이벤트 처리
                jQuery('#a_id_clear').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.DaumEditor.clearContent('ta_id_content2');  // 에디터 데이터 클리어
                });
            });

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">

        <%--<iframe name="editordata" id="editordata" src="/admin/common/editor" width="100%" height="600" style="border:0" onload="onLoadEditorData();"></iframe>--%>
        <div class="edit">
            <textarea id="ta_id_content1" name="content" class="blind"><p>abc<b>def</b>g</p>
<p><br></p>
<p style="text-align: center;">ㄴ이럼<span style="color: rgb(18, 52, 86);">﻿니아﻿</span>ㅓㄹ</p></textarea>
        </div>
        <br/>

        <%--<iframe name="editordata" id="editordata" src="/admin/common/editor" width="100%" height="600" style="border:0" onload="onLoadEditorData();"></iframe>--%>
        <form id="form_id_content2">
            이름 <span class="intxt"><input type="text" name="name" value="" /></span><br/>
            <div class="edit">
                <textarea id="ta_id_content2" name="content" class="blind"></textarea>
            </div>
        </form>
        <a href="#none" class="btn_blue" id="a_id_search">조회</a>
        <a href="#none" class="btn_blue" id="a_id_save">저장</a>
        <a href="#none" class="btn_blue" id="a_id_clear">초기화</a>
    </t:putAttribute>
</t:insertDefinition>