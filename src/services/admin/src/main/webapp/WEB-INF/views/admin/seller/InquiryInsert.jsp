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
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            jQuery(document).ready(function() {
                Dmall.validate.set('formBbsLettListInsert');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                // 게시글 목록 화면 이동
                jQuery('#viewBbsLettList').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", regrNo : "${so.regrNo}"}
                    Dmall.FormUtil.submit('/admin/seller/inquiry-list', param);
                });
                
                // 저장
                jQuery('#bbsLettListInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    if(Dmall.validate.isValid('formBbsLettListInsert')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/board/board-letter-insert';
                        var param = jQuery('#formBbsLettListInsert').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsLettListInsert');
                            if(result.success){
                                var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}"}
                                Dmall.FormUtil.submit('/admin/seller/inquiry-list', param);
                            }
                        });
                    }
                });
                
                var param = {memberNo:"${memberNo}", siteNo:"${siteNo}"};
                var url = '/admin/goods/member-info';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var data = result.data.memberNm+'(<span class="point_c3">'+result.data.loginId+"/"+result.data.memberGradeNm+'</span>)';
                    jQuery("#memeberInfo").html(data);
                });

            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
        <div class="tlt_box">
            <div class="btn_box left">
                <a href="#none" id="viewBbsLettList" class="btn gray">게시글 리스트</a>
            </div>
            <h2 class="tlth2">[${so.bbsNm}] 게시글 등록</h2>
            <div class="btn_box right">
                <a href="#none" id ="bbsLettListInsert" class="btn blue shot">저장하기</a>
            </div>
        </div>
        <form action="" id="formBbsLettListInsert">
        <!-- line_box -->
        <div class="line_box fri">
            <!-- tblw -->
            <div class="tblw mt0">
                <table summary="이표는 게시글 답변 등록 표 입니다. 구성은 작성자, 질분유형, 게시글 제목, 게시글 내용, 답변 제목, 답변 내용, SMS발송, 이메일발송 입니다.">
                    <caption>게시글 보기</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>작성자</th>
                            <td id ="memeberInfo">
                                    
                            </td>
                        </tr>
                        <tr>
                             <th>판매자</th>
                             <td>
                                 <div class="select wid240">
                                  <span>
                                      <label for="sel_sellerNo"></label>
                                      <select name="sellerNo" id="sellerNo" data-validation-engine="validate[required]]">
                                          <cd:sellerOption siteno="${so.siteNo}" includeSelect="true" />
                                      </select>
                                  </span>
                                 </div>
                             </td>
                         </tr>
                        <tr>
                            <th>질문유형</th>
                            <td>
                                <span class="select">
                                    <label for="select1"></label>
                                    <select id ="inquiryCd" name = "inquiryCd" >
                                        <cd:option codeGrp="INQUIRY_CD" />
                                    </select>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>게시글 제목</th>
                            <td class="in_del">
                                <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" />
                                <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}" />
                                <span class="intxt wid100p"><input type="text" name="title" id="title" data-validation-engine="validate[required], maxSize[500]]" ></span>
                            </td>
                        </tr>
                        <tr>
                            <th>게시글 내용</th>
                            <td>
                                <div class="edit">
                                      <textarea id="ta_id_content1" name="content" class="blind"></textarea>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
        </div>
        <!-- //line_box -->
        </form>
    </div>
    </t:putAttribute>
</t:insertDefinition>
