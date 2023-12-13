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
    <t:putAttribute name="title">대량메일 충전 관리 > 대량메일 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {

            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> 대량메일<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">대량메일 충전 관리</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <!-- tblw -->
                <div class="tblw tblmany2">
                    <table summary="이표는 SMS 포인트 충전 표 입니다. 구성은 잔여 이메일 발송 입니다.">
                        <caption>SMS 포인트 충전</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>잔여 이메일 발송</th>
                            <td class="txtc"><strong id="paidPossCnt"></strong></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <!-- tblw -->
                <div class="tblw tblmany2">
                    <table summary="이표는 참고사항 표 입니다.">
                        <caption>참고사항</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>참고사항</th>
                            <td>
                                <ul class="desc_list mt0 mb0">
                                    <li>발송완료된 건수만 포인트 차감됩니다.</li>
                                    <li>충전 이후 SMS포인트는 환불이 불가합니다.</li>
                                    <li>하단 사용요금 단가는 부가세 별도 가격입니다.</li>
                                </ul>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <!-- tblh -->
                <div class="tblh tblmany">
                    <table summary="이표는 SMS 포인트 충전 리스트 표 입니다. 구성은 결제선택, 발송건, 사용요금, 이메일(건/금액) 입니다.">
                        <caption>SMS 포인트 충전 리스트</caption>
                        <colgroup>
                            <col width="10%">
                            <col width="30%">
                            <col width="30%">
                            <col width="30%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>결제선택</th>
                            <th>발송건</th>
                            <th>사용요금</th>
                            <th>이메일(건/금액)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                <label for="radio0_1" class="radio on"><span class="ico_comm"><input name="aa1" id="radio0_1" type="radio" checked="checked"></span></label>
                            </td>
                            <td><strong class="point_c3">100</strong> 건</td>
                            <td><strong class="point_c3">2,000</strong>원</td>
                            <td>20원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_2" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_2" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">500</strong> 건</td>
                            <td><strong class="point_c3">10,000</strong>원</td>
                            <td>20원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_3" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_3" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">1,000</strong> 건</td>
                            <td><strong class="point_c3">20,000</strong>원</td>
                            <td>20원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_4" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_4" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">5,200</strong> 건</td>
                            <td><strong class="point_c3">100,000</strong>원</td>
                            <td>19.2원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_5" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_5" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">10,500</strong> 건</td>
                            <td><strong class="point_c3">200,000</strong>원</td>
                            <td>19원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_6" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_6" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">21,500</strong> 건</td>
                            <td><strong class="point_c3">400,000</strong></td>
                            <td>18.6원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_7" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_7" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">55,000</strong> 건</td>
                            <td><strong class="point_c3">900,000</strong>원</td>
                            <td>16.4원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_8" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_8" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">110,000</strong> 건</td>
                            <td><strong class="point_c3">1,650,000</strong>원</td>
                            <td>15원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_9" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_9" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">210,000</strong> 건</td>
                            <td><strong class="point_c3">3,000,000</strong>원</td>
                            <td>14.3원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_10" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_10" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">320,000</strong> 건</td>
                            <td><strong class="point_c3">4,480,000</strong>원</td>
                            <td>14원/1건</td>
                        </tr>
                        <tr>
                            <td>
                                <label for="radio0_11" class="radio"><span class="ico_comm"><input name="aa1" id="radio0_11" type="radio"></span></label>
                            </td>
                            <td><strong class="point_c3">320,000</strong> 건 이상</td>
                            <td>-</td>
                            <td><strong class="point_c3">별도협의</strong></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
            </div>
            <!-- //line_box -->
        </div>
        <jsp:include page="/WEB-INF/views/admin/operation/email/EmailChargeHis.jsp"/>
    </t:putAttribute>
</t:insertDefinition>






<script type="text/javascript" charset="utf-8">
function viewEmailChargeHst() {
    Dmall.LayerPopupUtil.open($("#emailCharge"));
    
//     openSmsChargeHisLayer();
}
</script>

