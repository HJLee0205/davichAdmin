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
    <t:putAttribute name="title">포인트 추가 설정 > 포인트 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

                // 포인트 설정 정보 로드
                fn_get_Info();

                // 저장버튼 이벤트 설정
                $('#btn_save').off('click').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_save();
                });

                Dmall.common.comma();
                Dmall.common.date();

                // validator설정
                Dmall.validate.set('form_point_config');
            });

            // 사이트 포인트 적립 설정 정보 조회
            function fn_get_Info() {
                var url = '/admin/operation/point-config-info',
                    param = '';

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    Dmall.FormUtil.jsonToForm(result.data, 'form_point_config');
                });
            }

            // 저장 버튼 클릭 시
            function fn_save() {
                if (Dmall.validate.isValid('form_point_config')) {
                    // 저장 실행
                    var url = '/admin/operation/point-config-update',
                        param = $('#form_point_config').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_point_config');

                        if (result == null || result.success != true) {
                            return;
                        } else {
                            // 화면 재표시
                            fn_get_Info();
                        }
                    });
                }
                return false;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> 포인트<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">포인트 추가 설정</h2>
            </div>
            <form id="form_point_config">
                <!-- line_box -->
                <div class="line_box fri">
                    <h3 class="tlth3">지급&amp;적립설정</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 지급&amp;적립 설정 표 입니다. 구성은 포인트 지급 여부, 포인트 적립 방법, 포인트 절사 기준 설정, 기타 적립 설정 입니다.">
                            <caption>지급&amp;적립 설정</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>지급 여부</th>
                                <td>
                                    <tags:radio codeStr="Y:사용;N:미사용;" name="pointPvdYn" idPrefix="pointPvdYn"/>
                                </td>
                            </tr>
                            <tr>
                                <th rowspan="2">적립 방법</th>
                                <td>
                                    <span class="flex">
                                        [일반] 상품 후기 작성 후 포인트 적립 &nbsp;( &nbsp;
                                        <span class="intxt shot5">
                                            <input type="text" name="buyEplgWritePoint" numberOnly>
                                        </span> 원)
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="flex">
                                        [프리미엄] 상품 후기 작성 후 포인트 적립 &nbsp;( &nbsp;
                                        <span class="intxt shot5">
                                            <input type="text" name="buyEplgWritePmPoint" numberOnly>
                                        </span> 원)
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <h3 class="tlth3">사용설정</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 사용 설정 표 입니다. 구성은 마켓포인트 사용기한 입니다.">
                            <caption>사용 설정</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>포인트 사용기한</th>
                                <td>
                                    <input type="hidden" name="pointAccuValidPeroid" value="36">
                                    적립일로부터 36 개월 유효 (사용기한 초과 포인트 자동 소멸)
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
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_save">저장</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>