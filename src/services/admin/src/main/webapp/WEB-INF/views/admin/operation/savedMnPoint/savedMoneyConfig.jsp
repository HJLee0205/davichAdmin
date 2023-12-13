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
    <t:putAttribute name="title">포인트 설정 > 포인트 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

                // 마켓포인트 정보 로드
                fn_get_Info();

                // 저장버튼 이벤트 설정
                $('#btn_save').on('click', function (e) {
                    fn_save();
                });

                Dmall.common.comma();

                // validator설정
                Dmall.validate.set('form_saved_money_config');

                // 할인구분 라디오 체인지 이벤트
                $('input[name="svmnMaxUseGbCd"]').change(function () {
                    var selVal = $(this).val();

                    if (selVal == '1') {
                        $('#dcValueSpan').text('%');
                    } else {
                        $('#dcValueSpan').text('원');
                    }
                });
            });

            // 사이트 마켓포인트 설정 정보 조회
            function fn_get_Info() {
                var url = '/admin/operation/savedmoney-config',
                    param = '';

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result == null || result.success != true) {
                        return;
                    }

                    // 결과 바인딩 호출
                    fn_set_result(result.data);
                });
            }

            // 검색결과 바인딩
            function fn_set_result(data) {
                // 마켓포인트 사용 기한 설정 값이 없을 경우 기본값으로 '6'을 설정
                if (!'svmnUseLimitday' in data || !data['svmnUseLimitday']) {
                    data['svmnUseLimitday'] = '6';
                }
                // 마켓포인트 사용 단위 코드 값이 없을 경우 기본값으로 '1'을 설정
                if (!'svmnUseUnitCd' in data || !data['svmnUseUnitCd']) {
                    data['svmnUseUnitCd'] = '1';
                }

                // 기존 선택 값 리셋
                var $radio = $('input:radio[name=svmnMaxUseGbCd]').prop('checked', false);

                $radio.each(function () {
                    $('label[for=' + $(this).attr('id') + ']', $radio.parent()).removeClass('on');
                });
                // 값 설정
                $('input:radio[name=svmnMaxUseGbCd][value=' + data['svmnMaxUseGbCd'] + ']').trigger('click');


                var $radio2 = $('input:radio[name=svmnPvdYn]').prop('checked', false);

                $radio2.each(function () {
                    $('label[for=' + $(this).attr('id') + ']', $radio2.parent()).removeClass('on');
                });
                // 값 설정
                $('input:radio[name=svmnPvdYn][value=' + data['svmnPvdYn'] + ']').trigger('click');

                // $('[data-find="saved_money_config"]').DataBinder(data);

                Dmall.FormUtil.jsonToForm(data, 'form_saved_money_config');
            }

            // 저장 버튼 클릭 시
            function fn_save() {
                if (Dmall.validate.isValid('form_saved_money_config')) {
                    // 저장 실행
                    var url = '/admin/operation/savedmoney-config-update',
                        param = $('#form_saved_money_config').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_saved_money_config');

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
                    운영 설정<span class="step_bar"></span>포인트<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">포인트 설정</h2>
            </div>
            <form id="form_saved_money_config">
                <!-- line_box -->
                <div class="line_box fri pb">
                    <h3 class="tlth3">지급설정</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 지급 설정 표 입니다. 구성은 마켓포인트 지급 여부, 마켓포인트 지급 기준, 마켓포인트 지급 방법, 마켓포인트 절사 기준 설정 입니다.">
                            <caption>지급 설정</caption>
                            <colgroup>
                                <col width="170px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>지급 여부</th>
                                <td id="td_svmnPvdYn">
                                    <tags:radio codeStr="Y:사용;N:미사용" name="svmnPvdYn" idPrefix="svmnPvdYn"/>
                                </td>
                            </tr>
                            <tr>
                                <th>지급 기준</th>
                                <td>상품 구매 금액의 할인 판매가를 기준으로 설정합니다. </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <h3 class="tlth3">사용설정</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 사용 설정 표 입니다. 구성은 상품 합계액 기준, 사용가능 보유 마켓포인트 기준, 마켓포인트 최소 사용금액, 마켓포인트 최대 사용금액, 마켓포인트 사용단위, 마켓포인트/쿠폰 중복사용 설정, 마켓포인트 사용기한 입니다.">
                            <caption>사용 설정</caption>
                            <colgroup>
                                <col width="170px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>보유 포인트 기준</th>
                                <td>
                                    <div class="flex">
                                        보유 포인트 &nbsp;
                                        <span class="intxt shot5">
                                            <input type="text" name="svmnUsePsbPossAmt" numberOnly>
                                        </span>
                                        원 이상 일 때 사용가능
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>최소 사용 금액</th>
                                <td>
                                    <div class="flex">
                                        최소 &nbsp;
                                        <span class="intxt shot5">
                                            <input type="text" name="svmnMinUseAmt" numberOnly>
                                        </span>
                                        원 이상 일 때 사용가능
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>최대 사용 설정 (율/금액)</th>
                                <td>
                                    <div class="flex">
                                        최대
                                        <span class="intxt flex_i">
                                            &nbsp;&nbsp;(&nbsp;<tags:radio codeStr="1:율;2:금액" name="svmnMaxUseGbCd" idPrefix="svmnMaxUseGbCd"/>
                                            <span class="intxt shot"><input type="text" name="svmnMaxUseAmt" numberOnly></span>
                                            <span id="dcValueSpan">원</span> ) 까지 사용가능
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>사용단위</th>
                                <td>
                                    <span class="select one">
                                        <label for="svmnUseUnitCd"></label>
                                        <select name="svmnUseUnitCd" id="svmnUseUnitCd">
                                            <tags:option codeStr=":선택;1:10;2:100;3:1000;"/>
                                        </select>
                                    </span>
                                    <span>원</span>
                                </td>
                            </tr>
                            <tr>
                                <th>포인트/쿠폰 중복사용</th>
                                <td>
                                    <tags:radio codeStr="Y:쿠폰 적용 시 포인트 중복 사용 가능;N:쿠폰 적용 시 포인트 중복 사용 불가" name="svmnCpDupltApplyYn" idPrefix="svmnCpDupltApplyYn"/>
                                </td>
                            </tr>
                            <tr>
                                <th>사용기한</th>
                                <td>
                                    <div class="flex">
                                        <input type="hidden" name="svmnUseLimitday" value="36">
                                        <%--<span class="intxt shot5"><input type="text" name="svmnUseLimitday" numberOnly></span>--%>
                                        적립일로부터 36 개월 유효 (사용기한 초과 포인트 자동 소멸)
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
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_save">저장</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>