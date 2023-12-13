<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="알럿 레이어 팝업" %>
<%@ attribute name="id" required="true" description="레이어 팝업의 아이디" %>
<%@ attribute name="title" required="true" description="레이어 팝업의 타이틀" %>
<%@ attribute name="message" required="true" description="출력할 메시지" %>
<%@ attribute name="btnId" required="true" description="확인 버튼의 ID" %>
<!-- layer_popup1 -->
<div id="<%= id %>" class="slayer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2"><%= title %></h2>
            <a href="#none" class="close ico_comm">닫기</a>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <p class="message"><%= message %></p>
                <div class="btn_box txtc">
                    <a href="#none" id="<%= btnId %>" class="btn_green">확인</a>
                </div>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->