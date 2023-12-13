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
    <t:putAttribute name="title">서비스 안내 > 대량메일 > 운영</t:putAttribute>
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
                <h2 class="tlth2">서비스 안내</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">대량메일 서비스안내 </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 대량메일 서비스안내 표 입니다. 구성은 서비스 안내 입니다.">
                        <caption>대량메일 서비스안내</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>서비스 안내</th>
                            <td>
                                대량메일은 쇼핑몰 관리자가 쇼핑몰 회원들에게 효과적으로 메일을 발송할 수 있는 서비스입니다.<br>대량메일은 마케팅의 중요한 도구로서 광고, 캠페인, 뉴스레터 등 다양한 분야에 걸쳐 활용되고 있습니다.
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->

                <h3 class="tlth3">서비스 신청 절차 </h3>
                <div class="step_lay">
                    <ul class="step_img service">
                        <li class="step_arrow"><img src="/admin/img/operate/service_step01.png" alt="step 1 서비스 신청"></li>
                        <li class="step_arrow"><img src="/admin/img/operate/service_step02.png" alt="step 2 결제"></li>
                        <li class="step_arrow"><img src="/admin/img/operate/service_step03.png" alt="step 3 서비스 충전완료"></li>
                        <li><img src="/admin/img/operate/service_step04.png" alt="step 4 메일발송"></li>
                    </ul>
                </div>

                <h3 class="tlth3">서비스 신청 요금 </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 서비스 신청 요금 표 입니다. 구성은 서비스 신청 요금 입니다.">
                        <caption></caption>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>요금</th>
                            <td>
                                1원/1통
                                <br>
                                <span class="point_c5">* 충전 시, 최소 5000통 이상 신청이 가능합니다.</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->

                <h3 class="tlth3">서비스 특징 </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 서비스 특징 표 입니다. 구성은 서비스 특징 입니다.">
                        <caption></caption>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>서비스 특징</th>
                            <td>
                                <ol>
                                    <li>1. 대량메일 파워로봇을 통한 안정적인 대량메일 발송가능</li>
                                    <li>2. 1통당 1원의 저렴한 비용으로 원하는 만큼 이용 가능</li>
                                    <li>3. 쉬운 타겟 설정, 안정적인 예약 발송</li>
                                    <li>4. 발송메일의 통계분석을 통한 효과적인 마케팅 가능</li>
                                </ol>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->

                <h3 class="tlth3 btn1">
                    서비스 사용 시 필수 체크사항
                    <div class="right">
                        <a href="http://spam.kisa.or.kr/kor/notice/dataView.jsp?p_No=49&b_No=49&d_No=32&cgubun=&cPage=1&searchType=ALL&searchKeyword=" target="_blank" class="btn_gray2">KISA 관련정보 확인</a>
                    </div>
                </h3>
                <!-- tblw -->
                <div class="tblw">
                    <table summary="이표는 서비스 사용 시 필수 체크사항 표 입니다. 구성은  입니다.">
                        <caption>서비스 사용 시 필수 체크사항</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>필수 체크 사항</th>
                            <td>
                                <ol>
                                    <li>1. 스펨메일 발송에 대한 규정을 확인하신 후 메일을 발송해주세요.</li>
                                    <li>2. 영리목적으로 전송하는 경우 및 제목표기 방법 관련 안내 확인 후 메일을 발송해주세요.</li>
                                    <li>3. 대량메일 권장량은 최대 10만건입니다.</li>
                                    <li>4. 대량메일 서비스 이용 시, 이미지호스팅 서비스를 이용해야 사용이 가능합니다.</li>
                                </ol>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>