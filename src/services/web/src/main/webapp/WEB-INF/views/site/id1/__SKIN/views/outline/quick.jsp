<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<div id="quick_menu">
    <div class="quick_area">
        <div class="quick_body">
            <h2 class="quick_tit">
                최근본상품 <span id="lately_count"></span></li>
            </h2>
            <div class="quick_view_area">
                <!-- 최근본상품 -->
                <!-- <ul class="quick_view"></ul> -->
                <!-- 최근본상품 -->
                <!-- 최근본 상품 상세 -->
               <%-- <div class="quick_text" id="qv01">
                    <p class="name">CNBLUE01 C2_씨엔블루01 C2</p>
                    <p class="price">190,800</p>
                </div>
                <div class="quick_text" id="qv02">
                    <p class="name">CNBLUE01 C2_씨엔블루01 C222</p>
                    <p class="price">190,800</p>
                </div>
                <div class="quick_text" id="qv03">
                    <p class="name">3333 C2_씨엔블루01 C2</p>
                    <p class="price">190,800</p>
                </div>
                <div class="quick_text" id="qv04">
                    <p class="name">444444 C2_씨엔블루01 C2</p>
                    <p class="price">190,800</p>
                </div>--%>
                <!--// 최근본 상품 상세 -->
            </div>
            <div class="btn_quick_area">
            <%--<button type="button" class="btn_quick_prev">이전</button>
                <span class="count"><em>1</em>/3</span>
                <button type="button" class="btn_quick_next">다음</button>--%>
            </div>
            <ul class="quick_smenu">
                <li><a href="javascript:move_basket();"><i class="icon_q_cart">장바구니</i><span id="basket_count"></span></a></li>
                <li><a href="javascript:move_interest();"><i class="icon_q_wish">관심상품</i><span id="interest_count"></span></a></li>
            </ul>
            <ul class="quick_smenu02">
            	<!-- <li><a href="javascript:window.open('/front/event/imoticon-event', '이모티콘 이벤트', 'titlebar=1, resizable=1, scrollbars=yes, width=1200, height=760');" style="text-align: center" >이모티콘 이벤트</a></li> -->
            	<!-- <li><a href="javascript:fn_imoticon_event();" style="text-align: center">이모티콘 이벤트</a></li> -->
                <li><a href="/front/customer/store-list"><i class="icon_q_shop"></i>매장찾기</a></li>
                <li><a href="/front/visit/visit-welcome"><i class="icon_q_visit"></i>방문예약</a></li>				
				<li><a href="/front/vision2/vision-check"><i class="icon_q_glass"></i>렌즈추천</a></li>								
				<!-- <li><a href="/front/vision2/vision-check"><i class="icon_q_glass"></i>렌즈추천</a></li> -->
				<%--<li><a href="/front/hearingaid/hearingaid-check"><i class="icon_q_ear"></i>보청기추천</a></li>--%>
				<li><a href="http://www.davichhearing.com/davich_custom/new_ex/daviexperience.html"><i class="icon_q_ear"></i>보청기추천</a></li>
				<!-- <li><a href="/front/appDownload" target="_blank"></i>얼굴에 써보기</a></li> -->
    			<li class="textC"><a href="javascript:fn_go_yearend_tax();">연말정산</a></li>
            </ul>

        </div>
        <a href="javascript:;" class="btn_quick_top">TOP<i></i></a>
    </div>
</div>