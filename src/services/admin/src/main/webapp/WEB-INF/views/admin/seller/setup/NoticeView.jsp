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
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">판매자 공지 > 기본</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 게시글 리스트 화면
                $('#btn_list').on('click', function(e) {
                    Dmall.FormUtil.submit('/admin/seller/setup/notice-list', {bbsId: "${so.bbsId}"});
                });

                // 게시글 정보 가져오기
                var param = {bbsId: "${so.bbsId}", lettNo: "${so.lettNo}"};
                var url = '/admin/seller/setup/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_notice_info');
                    $("#contentArea").html(result.data.content);
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매자 공지</h2>
            </div>
            <form id="form_notice_info">
                <!-- line_box -->
                <div class="line_box fri pb">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 공지 보기 표 입니다. 구성은 작성자, 작성일,제목,내용 입니다.">
                            <caption>게시글 보기</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>작성자</th>
                                <td id="bind_target_id_memberNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>작성일</th>
                                <td id="bind_target_id_regDttm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td colspan="3" id="bind_target_id_title" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td id="contentArea"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
                <!-- //line_box -->
            </form>
            <!-- bottom_box -->
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
            </div>
            <!--//bottom_box  -->
        </div>
    </t:putAttribute>
</t:insertDefinition>
