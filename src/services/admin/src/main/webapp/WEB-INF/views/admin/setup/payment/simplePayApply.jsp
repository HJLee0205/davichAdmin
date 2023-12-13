<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="defaultLayout">
 <t:putAttribute name="title">홈 &gt; 설정 &gt; 기본관리 &gt; 간편결제 서비스 안내</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function() {
             // 저장하기 버튼 클릭시
                $('.layerBtn').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    Dmall.LayerPopupUtil.open($('#' + $(this).attr('data-type') + 'InfoLayer'));
                });
            });
        </script>
    </t:putAttribute>

    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">간편결제 서비스 안내</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">간편 결제 서비스</h3>
                <ul class="tlt_list">
                    <li>- 간편 결제 서비스: PC, 모바일 어디서나 결제 가능한 ActiveX없는 간편한 결제시스템 간단한 결제 절차로 결제이탈율을 감소시킬 수 있으며 해당 서비스는 체크아웃 형태의 간편구매와 PG형태의 간편결제 서비스가 있습니다.</li>
                </ul>
    
                <h3 class="tlth3 mt20">서비스 신청절차</h3>
                <!-- step_lay -->
                <div class="step_lay">
                    <ul class="step_img pay">
                        <li class="step_arrow"><img src="/admin/img/set/pay_step01.png" alt="step 1 서비스 신청"></li>
                        <li class="step_arrow"><img src="/admin/img/set/pay_step02.png" alt="step 2 신청완료 및 서류접수"></li>
                        <li class="step_arrow"><img src="/admin/img/set/pay_step03.png" alt="step 3 심사, 승인"></li>
                        <li class="step_arrow"><img src="/admin/img/set/pay_step04.png" alt="step 4 심사완료 및 쇼핑몰 관리자 설정"></li>
                        <li><img src="/admin/img/set/pay_step05.png" alt="step 5 서비스 이용"></li>
                    </ul>
                    <ul class="pgsa_box">
                        <!-- pgsa -->
                        <li class="pgsa">
                            <div>
                                <span class="logo"><img src="/admin/img/set/payco_logo.png" alt="payco"></span>
                                <ul class="info">
                                    <li>· 대표전화 : 1544-8665</li>
                                </ul>
                                <div class="btn">
                                    <a href="#none" class="btn_blue">서비스 신청하기</a>
                                    <a href="#none" class="btn_gray layerBtn" data-type="payco">서비스 상세안내</a>
                                </div>
                            </div>
                        </li>
                        <!-- //pgsa -->
                    </ul>
                </div>
                <!-- //step_lay -->
            </div>
            <!-- //line_box -->
        </div>
        <%@ include file="popup/simpleApply/paycoServiceInfoPopup.jsp" %>
    </t:putAttribute>
</t:insertDefinition>