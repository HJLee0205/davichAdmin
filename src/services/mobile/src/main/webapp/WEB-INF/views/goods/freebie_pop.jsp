<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup_present_event" id="freebie_pop" style="display: none;">
    <div class="popup_header">
        <h1 class="popup_tit">사은품 이벤트</h1>
        <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
    </div>
    <div class="popup_content">
        <span>* 상품을 <b>${freebieGoodsList[0].freebieEventAmt}</b>원 이상 주문하시면 아래의 사은품 중 1개를 증정합니다.</span>
        <div class="popup_present_event_scroll">
            <ul class="popup_present_event_list">
                <li>
                    <img src="${freebieGoodsList[0].imgPath}" alt="">
                    <div class="event_check">
                        <label for="event_check01">
                            <span></span>
                            ${freebieGoodsList[0].freebieNm}
                        </label>
                    </div>
                </li>
            </ul>
        </div>
        <div class="popup_btn_area">
            <button type="button" class="btn_popup_cancel">닫기</button>
        </div>
    </div>
</div>