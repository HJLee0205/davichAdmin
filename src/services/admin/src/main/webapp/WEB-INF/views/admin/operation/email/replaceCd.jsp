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
            <h2 class="tlth2">사용 가능한 치환 코드 </h2>
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
                                <td class="txtl replaceCd">#[memberNm]</td>
                                <td class="txtl">회원명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[mobile]</td>
                                <td class="txtl">회원연락처</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[email]</td>
                                <td class="txtl">회원 이메일</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[birth]</td>
                                <td class="txtl">회원 생일</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[userId]</td>
                                <td class="txtl">로그인 아이디</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[dormantDttm]</td>
                                <td class="txtl">휴면 회원 일시</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[siteDomain]</td>
                                <td class="txtl">사이트 도메인</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[dlgtDomain]</td>
                                <td class="txtl">대표도메인</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[siteNm]</td>
                                <td class="txtl">사이트명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[remainEmail]</td>
                                <td class="txtl">남은 이메일 건수</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[remainSms]</td>
                                <td class="txtl">남은 SMS 건수</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orderNm]</td>
                                <td class="txtl">주문자명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orderNo]</td>
                                <td class="txtl">주분번호</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orderItem]</td>
                                <td class="txtl">주문 상품</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orderItemList]</td>
                                <td class="txtl">주문 상품 리스트</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[bankAccount]</td>
                                <td class="txtl">입금은행 계좌번호 예금주</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[settleprice]</td>
                                <td class="txtl">입금 금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[settleKind]</td>
                                <td class="txtl">결제 수단</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[dormancyDuDate]</td>
                                <td class="txtl">휴면예정일</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[goItem]</td>
                                <td class="txtl">출고 완료</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[deliveryCompany]</td>
                                <td class="txtl">택배사명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[deliveryNumber]</td>
                                <td class="txtl">운송장 번호</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[mailTypeCd]</td>
                                <td class="txtl">메일 타입 코드</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[shopName]</td>
                                <td class="txtl">쇼필몽 명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[shopDoamin]</td>
                                <td class="txtl">쇼핑몰 도메인</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[inqueryTitle]</td>
                                <td class="txtl">문의 제목</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[inqueryRegrDtm]</td>
                                <td class="txtl">문의 등록일</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[inqueryContent]</td>
                                <td class="txtl">문의 내용</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[inqueryReplyTitle]</td>
                                <td class="txtl">답변 제목</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[inqueryReplyRegrDtm]</td>
                                <td class="txtl">답변 등록일</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[inqueryReplyContent]</td>
                                <td class="txtl">답변 내용</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordEmail]</td>
                                <td class="txtl">이메일</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordTel]</td>
                                <td class="txtl">주문자 번호</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordMobile]</td>
                                <td class="txtl">주문자 휴대폰</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordAdrsNm]</td>
                                <td class="txtl">수취인 명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordAdrsMobile]</td>
                                <td class="txtl">수취인 전화번호</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordRoadAddr]</td>
                                <td class="txtl">주문 도로명 주소</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordNumAddr]</td>
                                <td class="txtl">주문 지번 주소</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordDtlAddr]</td>
                                <td class="txtl">주문 상세주소</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordDlvrMsg]</td>
                                <td class="txtl">배송 메시지</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordSaleAmt]</td>
                                <td class="txtl">판매 금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordDcAmt]</td>
                                <td class="txtl">할인 금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordSvmnAmt]</td>
                                <td class="txtl">마켓포인트액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordDlvrAmt]</td>
                                <td class="txtl">배송금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordPayAmt]</td>
                                <td class="txtl">결제 금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordBankNm]</td>
                                <td class="txtl">입금은행명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordBankAccntNo]</td>
                                <td class="txtl">입금계좌</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordBankAccntNm]</td>
                                <td class="txtl">입금자 명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimBankNm]</td>
                                <td class="txtl">클레임 은행명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimAccntNo]</td>
                                <td class="txtl">클레임 계좌번호</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimAccntNm]</td>
                                <td class="txtl">클레임 계좌주 명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimReason]</td>
                                <td class="txtl">클레임 사유</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimDtlReason]</td>
                                <td class="txtl">클레임 상세 사유</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimAmt]</td>
                                <td class="txtl">클레임 금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimCmpltDttm]</td>
                                <td class="txtl">클레임 완료 일시</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimSvmnAmt]</td>
                                <td class="txtl">클레임 적립 금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordClaimRefundWay]</td>
                                <td class="txtl">클레임 환불 방법</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordPaymentWayNm]</td>
                                <td class="txtl">결제수단명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordGoodsInfo]</td>
                                <td class="txtl">주문 상품정보</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[ordGoodsList]</td>
                                <td class="txtl">주문 상품 리스트</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlGoodsNm]</td>
                                <td class="txtl">상품명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlItemNm]</td>
                                <td class="txtl">단품명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlAddOptYn]</td>
                                <td class="txtl">추가옵션여부</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlAddOptNm]</td>
                                <td class="txtl">추가 옵션명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlOrdQtt]</td>
                                <td class="txtl">주문 수량</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlSaleAmt]</td>
                                <td class="txtl">상품 금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlDcAmt]</td>
                                <td class="txtl">할인금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlTotalAmt]</td>
                                <td class="txtl">합계금액</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[orddtlDlvrAmd]</td>
                                <td class="txtl">배송비</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[reqDate]</td>
                                <td class="txtl">요청일</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[goodsNm]</td>
                                <td class="txtl">상품명</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[authDate]</td>
                                <td class="txtl">이메일 인증유효일시</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[memberTypeCd]</td>
                                <td class="txtl">회원유형코드</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[emailCertifyValue]</td>
                                <td class="txtl">이메일 인증코드</td>
                                <td><button type="button" class="btn_blue copyReplaceCd" >복사</button></td>
                            </tr>
                            <tr>
                                <td class="txtl replaceCd">#[bizRegNo]</td>
                                <td class="txtl">사업자 등록 번호</td>
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