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
 <t:putAttribute name="title">홈 &gt; 설정 &gt; 기본관리 &gt; 통합전자결제 서비스 안내</t:putAttribute>
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
                <h2 class="tlth2">통합전자결제 서비스 안내</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">통합전자결제 서비스</h3>
                <ul class="tlt_list ">
                    <li>- 통합전자결제서비스(PG): 신용카드, 무통장, 가상계좌, 휴대폰결제, 에스크로 결제 연동</li>
                    <li>- "쇼핑몰 운영의 기본 중 기본! 매출과 바로 연결되는 가장 중요한 서비스" 통합 전자결제(PG) 서비스는 결제 수단을(신용카드,무통장,가상계좌,휴대폰결제,에스크로) 쇼핑몰에 연동하여 고객이 원활하게 상품 구매를 할 수 있도록 결제기능을 제공 하며, 결제 내역의 정산 관리도 가능한 필수 부가 서비스 입니다.</li>
                </ul>
    
                <h3 class="tlth3 mt20">서비스 절차</h3>
                <!-- step_lay -->
                <div class="step_lay">
                    <ul class="step_img pgsa">
                        <li class="step_arrow"><img src="/admin/img/set/pgsa_step01.png" alt="step 1 서비스 신청"></li>
                        <li class="step_arrow"><img src="/admin/img/set/pgsa_step02.png" alt="step 2 계약서 작성 후 팩스 발송"></li>
                        <li class="step_arrow"><img src="/admin/img/set/pgsa_step03.png" alt="step 3 심사(2주 소요)"></li>
                        <li class="step_arrow"><img src="/admin/img/set/pgsa_step04.png" alt="step 4 승인완료"></li>
                        <li><img src="/admin/img/set/pgsa_step05.png" alt="step 5 쇼핑몰 결제 이용"></li>
                    </ul>
                    <ul class="pgsa_box">
                        <!-- pgsa -->
                        <li class="pgsa">
                            <div>
                                <span class="logo"><img src="/admin/img/set/kcp_logo.png" alt="KCP"></span>
                                <ul class="info">
                                    <li>· 대표전화 : 1544-8662</li>
                                    <li>· FAX : 050-4984-9901</li>
                                </ul>
                                <div class="btn">
                                    <a href="#none" class="btn_blue">서비스 신청하기</a>
                                    <a href="#none" class="btn_gray layerBtn" data-type="kcp">서비스 상세안내</a>
                                </div>
                            </div>
                        </li>
                        <!-- //pgsa -->
                        <!-- pgsa -->
                        <li class="pgsa">
                            <div>
                                <span class="logo"><img src="/admin/img/set/kg_logo.png" alt="KG 이니시스"></span>
                                <ul class="info">
                                    <li>· 대표전화 : 02-3430-5858</li>
                                    <li>· FAX : 02-3430-5999</li>
                                </ul>
                                <div class="btn">
                                    <a href="#none" class="btn_blue">서비스 신청하기</a>
                                    <a href="#none" class="btn_gray layerBtn" data-type="inicis">서비스 상세안내</a>
                                </div>
                            </div>
                        </li>
                        <!-- //pgsa -->
                        <!-- pgsa -->
                        <li class="pgsa">
                            <div>
                                <span class="logo"><img src="/admin/img/set/lguplus_logo.png" alt="LG U+"></span>
                                <ul class="info">
                                    <li>· 대표전화 : 1544-7772</li>
                                    <li>· FAX : 02-6919-2354</li>
                                </ul>
                                <div class="btn">
                                    <a href="#none" class="btn_blue">서비스 신청하기</a>
                                    <a href="#none" class="btn_gray layerBtn" data-type="lgu">서비스 상세안내</a>
                                </div>
                            </div>
                        </li>
                        <!-- //pgsa -->
                        <!-- pgsa -->
                        <li class="pgsa">
                            <div>
                                <span class="logo"><img src="/admin/img/set/allthegate_logo.PNG" style="width:130px" alt="ALLTHEGATE"></span>
                                <ul class="info">
                                    <li>· 대표전화 : 1544-7772</li>
                                    <li>· FAX : 02-6919-2354</li>
                                </ul>
                                <div class="btn">
                                    <a href="#none" class="btn_blue">서비스 신청하기</a>
                                    <a href="#none" class="btn_gray layerBtn" data-type="allthegate">서비스 상세안내</a>
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
        <%@ include file="popup/paymentApply/kcpServiceInfoPopup.jsp" %>
        <%@ include file="popup/paymentApply/inicisServiceInfoPopup.jsp" %>
        <%@ include file="popup/paymentApply/lguServiceInfoPopup.jsp" %>
        <%@ include file="popup/paymentApply/allthegateServiceInfoPopup.jsp" %>
    </t:putAttribute>
</t:insertDefinition>