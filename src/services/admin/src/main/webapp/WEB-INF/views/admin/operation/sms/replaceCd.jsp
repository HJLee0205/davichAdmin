<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>

<script type="text/javascript" charset="utf-8">
$(document).ready(function() {
    //관리자 수신번호 입력박스 추가 이벤트
    $(document).on('click', 'button.copyReplaceCd', function(e){
        var ie = (document.all)?true:false;
        
        var ie11 = navigator.userAgent.search("Trident");
        
        if(ie || ie11 != -1){
            window.clipboardData.setData("Text",$(this).parent().parent().find("td.replaceCd").text());
        }else{
            temp = prompt("복사해서 사용하세요.", $(this).parent().parent().find("td.replaceCd").text());
        }
        
//         $(this).parent().parent().find("td.replaceCd").text();
    });
    
});

</script>
<!-- layer_popup1 -->
<div id="replaceLayer" class="layer_popup">
    <div class="pop_wrap size3">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">사용 가능한 치환 코드</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <!-- tblh -->
                <!-- <div class="btn_box txtr mb20"><a href="#none" class="btn_blue">코드추가</a></div> -->
                <div class="tblh mt0">
                    <table summary="이표는 사용 가능한 치환 코드 리스트 표 입니다. 구성은 치환코드, 설명 입니다.">
                        <caption>사용 가능한 치환 코드 리스트</caption>
                        <colgroup>
                            <col width="40%">
                            <col width="40%">
                            <col width="20%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>치환코드</th>
                                <th>설명</th>
                                <th>복사</th>
                            </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="txtl replaceCd">#[deliveryNumber]</td>
                            <td class="txtl">운송장번호</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[dormantDttm]</td>
                            <td class="txtl">휴면회원일시</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[goodsNm]</td>
                            <td class="txtl">상품명</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[memberNm]</td>
                            <td class="txtl">회원 이름</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[mypageUrl]</td>
                            <td class="txtl">마이페이지 링크</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[ordBankAccntNm]</td>
                            <td class="txtl">입금자명</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[ordBankAccntNo]</td>
                            <td class="txtl">입금은행 계좌</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[ordBankNm]</td>
                            <td class="txtl">입금은행</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[ordLimitDttm]</td>
                            <td class="txtl">입금기한</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[ordPayAmt]</td>
                            <td class="txtl">입금(결제)금액/환불금액</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[orderItem]</td>
                            <td class="txtl">주문상품<br/>(여러 개의 상품인 경우 외 몇 건으로 표시)</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[orderNo]</td>
                            <td class="txtl">주문번호</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[rsvDate]</td>
                            <td class="txtl">방문일시</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[rsvGubun]</td>
                            <td class="txtl">예약 구분<br>(예시 - 상품예약, 방문예약)</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[rsvName]</td>
                            <td class="txtl">방문자 이름</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[rsvNo]</td>
                            <td class="txtl">예약번호</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[sellerNm]</td>
                            <td class="txtl">판매자 이름</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[storeKakaoAddr]</td>
                            <td class="txtl">가맹점 카카오톡 채널 주소</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[storeNm]</td>
                            <td class="txtl">방문매장명</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[userId]</td>
                            <td class="txtl">회원 아이디</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        <tr>
                            <td class="txtl replaceCd">#[visionCheckUrl]</td>
                            <td class="txtl">온라인 문진 링크</td>
                            <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->