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
            $(document).ready(function () {
                //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

                // 저장
                $('#gradeAutoCfgBtn').on('click', function () {
                    Dmall.LayerUtil.confirm('설정을 저장하시겠습니까?', function () {
                        var url = '/admin/member/level/membergrade-autoconfig-update',
                            param = $('#form_id_autoGradeConfig').serialize();

                        Dmall.AjaxUtil.getJSON(url, param);
                    });
                });

                // 수정
                $('table').on('click', 'a.btn_gray', function () {
                    var memberGradeNo = $(this).closest('tr').data('grade-no');
                    Dmall.FormUtil.submit('/admin/member/level/membergrade-update-form', {memberGradeNo: memberGradeNo});
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box" >
            <div class="tlt_box">
                <div class="tlt_head">
                    회원 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">회원 등급 관리</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">등급별 혜택</h3>
                <div class="tblh tblmany">
                    <table>
                        <colgroup>
                            <col width="12%">
                            <col width="12%">
                            <col width="13%">
                            <col width="18%">
                            <col width="18%">
                            <col width="12%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th rowspan="2">자동/수동</th>
                            <th rowspan="2">등급</th>
                            <th>등급혜택</th>
                            <th rowspan="2">현재통계</th>
                            <th rowspan="2">수정 일시 </th>
                            <th rowspan="2">관리</th>
                        </tr>
                        <tr>
                            <th class="member_th">포인트 적립</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="gradeList" items="${resultModel.resultList}" varStatus="status">
                            <tr data-grade-no="${gradeList.memberGradeNo}">
                                <td>${gradeList.autoYnNm}</td>
                                <td>${gradeList.memberGradeNm}</td>
                                <td>${gradeList.svmnValue}%</td>
                                <td>${gradeList.memCnt}명 (${gradeList.memStatistic})</td>
                                <td>${gradeList.makeDttm}</td>
                                <td>
                                    <a href="#none" class="btn_gray">수정</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <h3 class="tlth3">회원가입 혜택</h3>
                <form id="form_id_autoGradeConfig">
                    <!-- tblw -->
                    <div class="tblw tblmany mb0">
                        <table summary="이표는 회원등급 산정기준 표 입니다. 구성은 구매금액,주문횟수 / 포인트 선택 입니다.">
                            <caption>회원등급 산정기준</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th rowspan="2">회원가입 혜택 설정</th>
                                <td>
                                    회원가입 시 포인트
                                    <span class="intxt ml10 mr20"><input type="text" name="firstSignupPoint" id="firstSignupPoint" value="${signupBnfModel.data.firstSignupPoint}" numberOnly></span>
                                    원 증정
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="firstSignupCouponYn" class="chack mr20 <c:if test="${signupBnfModel.data.firstSignupCouponYn eq 'Y'}">on</c:if>">
                                        <span class="ico_comm mr20">
                                            <input type="checkbox" name="firstSignupCouponYn" id="firstSignupCouponYn" value="Y" class="blind" <c:if test="${signupBnfModel.data.firstSignupCouponYn eq 'Y'}">checked</c:if>>
                                        </span>
                                        회원가입 시 쿠폰 증정 (쿠폰관리 '신규회원가입쿠폰' 으로 설정된 쿠폰 발급)
                                    </label>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btn_box txtc mt10">
                        <a href="javascript:;" class="btn green" id="gradeAutoCfgBtn">회원가입 혜택 설정 저장</a>
                    </div>
                </form>
            </div>
    </t:putAttribute>
</t:insertDefinition>
