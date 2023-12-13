<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2023/01/20
  Time: 11:47 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <t:putAttribute name="title">상품 후기 관리 > 상품</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 노출여부 변경 이벤트
                $('#expsYn').off('change').on('change', function(e) {
                    var url = '/admin/board/board-letterexpose-update';
                    var param = {
                        delLettNo: $('#lettNo').val(),
                        bbsId: $('#bbsId').val(),
                        expsYn: $('#expsYn').val()
                    };

                    Dmall.AjaxUtil.getJSON(url, param);
                });

                // 목록
                $('#btn_list').on('click', function() {
                    Dmall.FormUtil.submit('/admin/seller/goods/goods-reviews');
                });

                // 삭제
                $('#btn_delete').on('click', function() {
                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br />정말 삭제하시겠습니까?', function() {
                        var url = '/admin/board/board-letter-delete';
                        var param = $('#form_review_info').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                Dmall.FormUtil.submit('/admin/seller/goods/goods-reviews');
                            }
                        });
                    });
                });

                // 상세조회
                var param = {lettNo: '${so.lettNo}', bbsId: '${so.bbsId}'};
                var url = '/admin/seller/setup/board-letter-detail';

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_review_info');
                    // 상품 이미지 바인딩
                    var goodsImgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=' + result.data.goodsImg;
                    $('#goodsImg').attr('src', goodsImgSrc);
                    // 후기 이미지 바인딩
                    jQuery.each(result.data.atchFileArr, function(i, obj) {
                        var reviewImgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=' + obj.filePath + '&id1=' + obj.fileNm;
                        var template = '<span class="review_img mr20">' +
                            '<img src="' + reviewImgSrc + '"/>' +
                            '</span>';
                        $('#reviewImg').append(template);
                    });
                    // 선택 답안 바인딩
                    if(result.data.inqTag) {
                        $('#inqTag').text(result.data.inqTag.replace(/,/g,' | '));
                    }
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">상품 후기 관리</h2>
            </div>
            <form id="form_review_info">
                <input type="hidden" name="bbsId" id="bbsId" value="review">
                <input type="hidden" name="lettNo" id="lettNo" value="${so.lettNo}">
                <!-- line_box -->
                <div class="line_box fri pb">
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 상품후기 정보 표 입니다. 구성은  입니다.">
                            <caption>
                                상품후기 정보
                            </caption>
                            <colgroup>
                                <col width="150px" />
                                <col width="" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>노출 여부</th>
                                <td>
                                    <span class="select">
                                        <label for="expsYn">노출</label>
                                        <select name="expsYn" id="expsYn">
                                            <option value="Y">노출</option>
                                            <option value="N">비노출</option>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>상품명</th>
                                <td id="bind_target_id_goodsNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>상품 대표 이미지</th>
                                <td>
                                    <span class="review_goods_img">
                                        <img id="goodsImg" src=""/>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>닉네임</th>
                                <td id="bind_target_id_memberNn" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>후기 대표 이미지</th>
                                <td>
                                    <div class="review_img_gr" id="reviewImg">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>선택 답안</th>
                                <td id="inqTag"></td>
                            </tr>
                            <tr>
                                <th>후기 내용</th>
                                <td id="bind_target_id_content" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>점수</th>
                                <td id="bind_target_id_score" class="bind_target"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_delete">삭제</button>
            </div>
        </div>
        <!--// bottom_box -->
    </t:putAttribute>
</t:insertDefinition>