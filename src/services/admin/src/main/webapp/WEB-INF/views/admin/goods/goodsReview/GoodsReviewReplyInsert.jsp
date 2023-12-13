<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function (e) {
                Dmall.validate.set('formBbsLettReply');
                getDetail();


                // 게시글 리스트 화면
                jQuery('#viewBbsLettList').on('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();

                    var param = {bbsId: "${so.bbsId}", bbsNm: "${so.bbsNm}", regrNo: "${so.regrNo}"}
                    Dmall.FormUtil.submit('/admin/goods/goods-reviews', param);
                });

                // 저장
                jQuery('#bbsLettListInsert').on('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();


                    if (Dmall.validate.isValid('formBbsLettReply')) {

                        var url = '/admin/board/board-reply-insert';
                        var param = jQuery('#formBbsLettReply').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsLettReply');
                            if (result.success) {
                                var param = {bbsId: "${so.bbsId}", bbsNm: "${so.bbsNm}"}
                                Dmall.FormUtil.submit('/admin/goods/goods-reviews', param);
                            }
                        });
                    }
                });

                // 답변삭제
                jQuery('#bbsReplyDelete').on('click', function (e) {

                    if (Dmall.validate.isValid('formBbsLettReply')) {

                        var url = '/admin/board/board-reply-delete';
                        var param = jQuery('#formBbsLettReply').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsLettReply');
                            if (result.success) {
                                var param = {bbsId: "${so.bbsId}", bbsNm: "${so.bbsNm}"}
                                Dmall.FormUtil.submit('/admin/goods/goods-reviews', param);
                            }
                        });
                    }
                });

                //후기 삭제
                jQuery('#delBbsLett').on('click', function (e) {
                    Dmall.LayerUtil.confirm('삭제하시겠습니까?', delBbsLett);
                });

                //노출상태 변경
                jQuery('#expsYn').on('change', function (e) {
                    var param = 'expsYn='+ $('#expsYn').val() + '&bbsId=${so.bbsId}&delLettNo=${so.lettNo}';
                    var url = '/admin/board/board-letterexpose-update';

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        <%--var param = { lettNo: '${so.lettNo}', bbsId: '${so.bbsId}' };--%>
                        <%--if (result.success) {--%>
                        <%--    Dmall.FormUtil.submit('/admin/goods/board-goodsreview-detail', param);--%>
                        <%--}--%>
                    });
                });
            });

            function delBbsLett() {
                var param = 'bbsId=${so.bbsId}&delLettNo=${so.lettNo}';
                var url = '/admin/board/board-checkedletter-delete';

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result.success) {
                        Dmall.FormUtil.submit('/admin/goods/goods-reviews');
                    }
                })
            }

            function fileDownload(fileNo) {
                Dmall.FileDownload.download("BBS", fileNo)
                return false;
            }

            function getDetail() {
                var param = 'lettNo=${so.lettNo}&bbsId=${so.bbsId}';
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result.success) {
                        var atchFileArr = "";
                        Dmall.FormUtil.jsonToForm(result.data, 'formBbsLettReply');
                        jQuery.each(result.data.atchFileArr, function (i, obj) {
                            atchFileArr += '<a href="#none" class="tbl_link" onclick= "return fileDownload(' + obj.fileNo +
                                ');">' + obj.orgFileNm + '</a><span class="br2"></span>';
                        });
                        jQuery("#viewFileInsert").html(atchFileArr);

                        if (result.data.replyLettNo == null || result.data.replyLettNo == '') {
                            $('#bbsReplyDelete').hide();
                        }

                        $('#expsYn').val(result.data.expsYnNm);

                        var memberNo = "${so.regrNo}";
                        var siteNo = "${siteNo}";
                        var param = {memberNo: memberNo, siteNo: siteNo};
                        var url = '/admin/goods/member-info';
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if (result.success) {
                                var data = result.data.memberNm + '(<span class="point_c3">' + result.data.loginId + "/" + result.data.memberGradeNm + '</span>)';
                                jQuery("#memeberInfo").html(data);
                                $("#memberNo").val(memberNo);
                            } else {

                            }
                        });
                    } else {

                    }


                });
            }

            function getMemberInfo() {

            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품설정<span class="step_bar"></span> 상품후기관리<span
                        class="step_bar"
                ></span>
                </div>
                <h2 class="tlth2">상품 후기 관리</h2>
            </div>
            <form action="" id="formBbsLettReply">
                <!-- line_box -->
                <div class="line_box fri">
                    <div class="tblw tblmany">
                        <table summary="이표는 상품후기 정보 표 입니다. 구성은  입니다.">
                            <caption>상품후기 정보</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>노출여부</th>
                                <td>
                                    <label for="select1"></label>
                                    <span class="select">
                              <label for="">노출</label>
                              <select name="expsYn" id="expsYn">
                                <option value="Y">노출</option>
                                <option value="N">비노출</option>
                              </select>
                            </span>
                                </td>
                            </tr>
                            <tr>
                                <th>상품명</th>
                                <td
                                        id="bind_target_id_goodsNm"
                                        class="bind_target"
                                >
                                </td>
                            </tr>
                            <tr>
                                <th>상품 대표 이미지</th>
                                <td>
                            <span class="review_goods_img">
                              <img src="" alt=""/>
                            </span>
                                </td>
                            </tr>
                            <tr>
                                <th>닉네임</th>
                                <td id="bind_target_id_memberNm">
                                </td>
                            </tr>
                            <tr>
                                <th>후기 대표 이미지</th>
                                <td>
                                    <div class="review_img_gr">
                                        <span class="review_img mr20">
                                            <img src="" alt=""/>
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>후기 내용</th>
                                <td id="bind_target_id_content">
                                </td>
                            </tr>
                            <tr>
                                <th>점수</th>
                                <td id="bind_target_id_score"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <button class="btn--big btn--big-white" id="viewBbsLettList">목록</button>
                </div>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="delBbsLett">삭제</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>
