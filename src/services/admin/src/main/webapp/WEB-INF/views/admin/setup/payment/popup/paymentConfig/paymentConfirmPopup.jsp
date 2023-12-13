<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<div id="paymentConfirmLayer" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">입금확인 URL 세팅 방법</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con post">
            <div>
                <!-- tab_lay -->
                <div class="post_tab tab_lay">
                    <a href="#none" class="tab payment-01">KCP</a>
                    <div class="tab_con pt0">
                        <ul class="desc_txt bottom">
                            <li>* KCP관리자페이지 <span class="fwb point_c3">(http://admin.kcp.co.kr)</span> 에서 가상계좌 입금확인 URL을 입력합니다.</li>
                            <li>* 가상계좌 입금 시, 쇼핑몰 관리자화면의 주문상태(주문완료→ 결제완료)가 자동 변경 됩니다.</li>
                            <li>* 가상계좌 입금확인 URL: <span class="fwb">http://쇼핑몰도메인입력/payment/kcp_return</span></li>
                        </ul>
                        <p class="img_tab"><img src="/admin/img/set/img_set_tab01.png" alt="" /></p>
                        <div class="btn_box txtc">
                            <button class="close btn green">확인</button>
                        </div>
                    </div>
                    <a href="#none" class="tab payment-02">KG이니시스</a>
                    <div class="tab_con pt0">
                        <ul class="desc_txt bottom">
                            <li>* KG Inicis관리자페이지 <span class="fwb point_c3">(https://iniweb.inicis.com)</span> 에서 가상계좌 입금확인 URL을 입력합니다.</li>
                            <li>* 가상계좌 입금 시, 쇼핑몰 관리자화면의 주문상태(주문완료→ 결제완료)가 자동 변경 됩니다.</li>
                            <li>* 가상계좌 입금확인 URL: <span class="fwb">http://쇼핑몰도메인입력/payment/kcp_return</span></li>
                            <li>* 이니시스는 일반결제와 에스크로결제 관리자가 분리되어 있어, 일반결제 관리자계정과 에스크로결제 관리자계정에 각각 로그인하여 URL을 입력해주셔야 합니다.</li>
                        </ul>
                        <p class="img_tab"><img src="/admin/img/set/img_set_tab04.png" alt="" /></p>
                        <div class="btn_box txtc">
                            <button class="close btn green">확인</button>
                        </div>
                    </div>
                    <a href="#none" class="tab payment-03">LGU+</a>
                    <div class="tab_con pt0">
                        <ul class="desc_txt bottom">
                            <li>* LG U+ 가상계좌 입금확인은 별도의 설정없이 동작됩니다.</li>
                        </ul>
                        <div class="btn_box txtc">
                            <button class="close btn green">확인</button>
                        </div>
                    </div>
                    <a href="#none" class="tab payment-04">올더게이트</a>
                    <div class="tab_con pt0">
                        <ul class="desc_txt bottom">
                            <li>* 올더게이트 가상계좌 입금확인은 별도의 설정없이 동작됩니다.</li>
                        </ul>
                        <div class="btn_box txtc">
                            <button class="close btn green">확인</button>
                        </div>
                    </div>
                </div>
                <!-- tab_lay -->
                
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>