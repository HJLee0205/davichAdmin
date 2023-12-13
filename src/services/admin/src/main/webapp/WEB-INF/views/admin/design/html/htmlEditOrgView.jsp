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

    <!-- 구분 정보 -->
    <link rel=stylesheet href="/admin/css/codemirror/docs.css">
    <link rel="stylesheet" href="/admin/css/codemirror/codemirror.css">
    <link rel="stylesheet" href="/admin/css/codemirror/foldgutter.css" />
    <script src="/admin/js/codemirror/codemirror.js"></script>
    <script src="/admin/js/codemirror/foldcode.js"></script>
    <script src="/admin/js/codemirror/foldgutter.js"></script>
    <script src="/admin/js/codemirror/brace-fold.js"></script>
    <script src="/admin/js/codemirror/xml-fold.js"></script>
    <script src="/admin/js/codemirror/markdown-fold.js"></script>
    <script src="/admin/js/codemirror/comment-fold.js"></script>
    <script src="/admin/js/codemirror/javascript.js"></script>
    <script src="/admin/js/codemirror/xml.js"></script>
    <script src="/admin/js/codemirror/markdown.js"></script>
    <style type="text/css">
      .CodeMirror {border-top: 1px solid black; border-bottom: 1px solid black;}
      html {overflow:hidden;}
    </style>
<t:insertDefinition name="popupLayout">
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; HTML 편집</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {
                var fileNm = "${so.fileNm}";
                var filePath = "${so.filePath}";
                var baseFilePath = "${so.baseFilePath}";
                var te_html = document.getElementById("txt_content");
                te_html.value = "";

                var editor_html = CodeMirror.fromTextArea(te_html, {
                  mode: "text/html",
                  lineNumbers: true,
                  lineWrapping: true,
                  extraKeys: {"Ctrl-Q": function(cm){ cm.foldCode(cm.getCursor()); }},
                  foldGutter: true,
                  gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
                });

                viewDtlHtml(fileNm,filePath,baseFilePath);

                // 화면생성에 필요한 기본 정보 취득
                function viewDtlHtml(fileNm,filePath,baseFilePath) {
                    var url = '/admin/design/origin-file-detailinfo',
                        param = {fileNm : fileNm, filePath : filePath, baseFilePath : baseFilePath};
    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }
                        
                        // 값 셋팅
                        editor_html.setValue(result.data.content);
                    });
                }



            });

            
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!-- content -->
        <div style="display:none">
            <div id="viewDtlInfo">미리보기</div>
        </div>
        <!-- //content -->
    </t:putAttribute>
</t:insertDefinition>
        <body style="min-width:700px;overflow-x:hidden"><!--윈도우 팝업 띄울시 넓이값 700px으로 불러오면 됩니다.-->
            <h1 class="page_add_w">원본소스보기</h1>
            <div class="page_add_wc">
                 <div style="max-width: 110em; margin-bottom: 1em;">HTML:<br>
                     <textarea id="txt_content" name="content"></textarea>
                 </div>
            </div>
        </body>