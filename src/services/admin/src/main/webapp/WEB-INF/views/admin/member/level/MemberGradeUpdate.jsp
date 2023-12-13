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
    <t:putAttribute name="title">홈 &gt; 회원 &gt; 회원등급 &gt; 회원등급관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

                // 목록
                $("#viewMemGradeListBtn").on('click', function(e) {
                    location.replace("/admin/member/level/membergrade");
                });

                // 저장
                $("#updateMemGradeBtn").on('click', function () {
                    if ($('input:text[name=svmnValue]').val() == '') {
                        Dmall.LayerUtil.alert("적립값을 입력해주세요.");
                        return;
                    }

                    Dmall.LayerUtil.confirm('저장하시겠습니까?', function () {
                        var url = '/admin/member/level/membergrade-config-update',
                            param = $('#form_id_memGradeUpdate').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            location.replace("/admin/member/level/membergrade");
                        });
                    });
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    회원 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">회원 등급 관리</h2>
            </div>
            <form action="" id="form_id_memGradeUpdate">
                <c:set var="memGradeUpdate" value="${resultModel.data}" />
                <input type="hidden" name="memberGradeNo" value="${memGradeUpdate.memberGradeNo}">
                <div class="line_box fri pb">
                    <h3 class="tlth3">회원 등급 정보</h3>
                    <div class="tblw">
                        <table>
                            <colgroup>
                                <col width="120px">
                                <col width="120px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th colspan="2">등급명</th>
                                <td>${memGradeUpdate.memberGradeNm}</td>
                            </tr>
                            <tr>
                                <th colspan="2">포인트 적립</th>
                                <td>
                                    <span class="intxt shot">
                                        <input type="text" name="svmnValue" value="${memGradeUpdate.svmnValue}" numberOnly>
                                    </span>
                                    % 적립
                                </td>
                            </tr>
                            <tr>
                                <th colspan="2">포인트 적립 가능 상품</th>
                                <td>
                                    <tags:checkbox id="pointPvdGoodsTypeCds_1" name="pointPvdGoodsTypeCdsArr" value="01" compareValue="${memGradeUpdate.pointPvdGoodsTypeCds}" text="안경테"/>
                                    <tags:checkbox id="pointPvdGoodsTypeCds_2" name="pointPvdGoodsTypeCdsArr" value="02" compareValue="${memGradeUpdate.pointPvdGoodsTypeCds}" text="선글라스"/>
                                    <tags:checkbox id="pointPvdGoodsTypeCds_3" name="pointPvdGoodsTypeCdsArr" value="04" compareValue="${memGradeUpdate.pointPvdGoodsTypeCds}" text="콘택트렌즈"/>
                                    <tags:checkbox id="pointPvdGoodsTypeCds_4" name="pointPvdGoodsTypeCdsArr" value="03" compareValue="${memGradeUpdate.pointPvdGoodsTypeCds}" text="안경렌즈"/>
                                    <tags:checkbox id="pointPvdGoodsTypeCds_5" name="pointPvdGoodsTypeCdsArr" value="05" compareValue="${memGradeUpdate.pointPvdGoodsTypeCds}" text="소모품"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <button class="btn--big btn--big-white" id="viewMemGradeListBtn">목록</button>
                </div>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="updateMemGradeBtn">저장</button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
