<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">상품후기</t:putAttribute>
	
	
	
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 비회원 주문/배송조회 메인  --->
    <div class="contents">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 쇼핑<span>&gt;</span>주문/배송 조회
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">비회원 주문/배송조회<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 비회원 주문/배송조회 왼쪽 메뉴 --->
            <%@ include file="include/nonmember_left_menu.jsp" %>
            <!---// 비회원 주문/배송조회 왼쪽 메뉴 --->
            <!--- 비회원 주문/배송조회 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    주문/배송상세
                    <span class="row_info_text">(주문번호 2011000000000)</span>
                </h3>
                <div class="warning_box">
                    <h4 class="warning_title">매번 같은 제품의 구매를 선호하시나요? !</h4>
                    <span>기존의 주문내역을 이용하여 간편하게 재주문 하세요. </span>
                    <button type="button" class="btn_myqna1">현재 상품 재주문하기</button>
                </div>
                <h3 class="mypage_con_stit">주문자정보</h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">주문자정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:160px">
                        <col style="width:">
                        <col style="width:160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textL">주문자명</th>
                            <td class="text12L">홍길동</td>
                            <th class="textL">이메일</th>
                            <td class="text12L">moya1006@nate.com</td>
                        </tr>
                        <tr>
                            <th class="textL">핸드폰</th>
                            <td class="text12L">010-1234-1234</td>
                            <th class="textL">전화번호</th>
                            <td class="text12L">032-1234-1234</td>
                        </tr>
                    </tbody>
                </table>

                <h3 class="mypage_con_stit">결제정보</h3>
                <div class="payment_info_area">
                    <ul class="payment_info">
                        <li>
                            총 상품금액
                            <span>119,000원</span>
                        </li>
                        <li class="icon">
                            <img src="/front/img/mypage/icon_pay_minus.gif" alt="빼기">
                        </li>
                        <li>
                            총 할인금액
                            <span>0원</span>
                        </li>
                        <li class="icon">
                            <img src="/front/img/mypage/icon_pay_plus.gif" alt="더하기">
                        </li>
                        <li>
                            배송비 합계
                            <span>2,500원</span>
                        </li>
                        <li class="icon">
                            <img src="/front/img/mypage/icon_pay_total.gif" alt="합계">
                        </li>
                        <li class="total">
                            최종 결제 금액 / 결제수단
                            <span class="price"><em>125,500</em>원</span>
                            <span class="payment_method">(신용카드)</span>
                        </li>
                    </ul>
                </div>

                <h3 class="mypage_con_stit">입금은행정보</h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">입금은행정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textL">입금정보</th>
                            <td class="text12L">기업은행 1234-567-12489 (입금자:이동준)</td>
                        </tr>
                        <tr>
                            <th class="textL">입금할 금액</th>
                            <td class="text12L"><em>23,000원</em> (2016-05-02 까지)</td>
                        </tr>
                    </tbody>
                </table>

                <h3 class="mypage_con_stit">주문상품정보</h3>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">주문상품정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:37px">
                        <col style="width:68px">
                        <col style="width:">
                        <col style="width:58px">
                        <col style="width:120px">
                        <col style="width:82px">
                        <col style="width:124px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="3">상품명</th>
                            <th>수량</th>
                            <th>상품금액</th>
                            <th>배송비</th>
                            <th>주문/배송상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="padding3012">1</td>
                            <td class="padding3012">
                                <img src="/front/img/product/cart_img01.gif">
                            </td>
                            <td class="textL padding3012">
                                <ul class="mypage_s_list">
                                    <li>BL7827/시스루패턴 하이넥블라우스</li>
                                    <li>[기본옵션:화이트(white)</li>
                                    <li>[추가옵션:85size]</li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                <ul class="mypage_s_list">
                                    <li>2</li>
                                    <li><span class="fRed">(-2)</span></li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                <ul class="mypage_s_list">
                                    <li>120,000원</li>
                                    <li><span class="fRed">(-120,000원)</span></li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                무료
                            </td>
                            <td class="padding3012">
                                배송중
                            </td>
                        </tr>
                        <tr>
                            <td class="padding3012">2</td>
                            <td class="padding3012">
                                <img src="/front/img/product/cart_img01.gif">
                            </td>
                            <td class="padding3012 textL">
                                <ul class="mypage_s_list">
                                    <li>BL7827/시스루패턴 하이넥블라우스</li>
                                    <li>[기본옵션:화이트(white)</li>
                                    <li>[추가옵션:85size]</li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                <ul class="mypage_s_list">
                                    <li>1</li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                <ul class="mypage_s_list">
                                    <li>120,000원</li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                1,000원
                            </td>
                            <td class="padding3012">
                                주문취소
                            </td>
                        </tr>
                        <tr>
                            <td class="padding3012">3</td>
                            <td class="padding3012">
                                <img src="/front/img/product/cart_img01.gif">
                            </td>
                            <td class="padding3012 textL">
                                <ul class="mypage_s_list">
                                    <li>BL7827/시스루패턴 하이넥블라우스</li>
                                    <li>[기본옵션:화이트(white)</li>
                                    <li>[추가옵션:85size]</li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                <ul class="mypage_s_list">
                                    <li>2</li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                <ul class="mypage_s_list">
                                    <li>120,000원</li>
                                </ul>
                            </td>
                            <td class="padding3012">
                                무료
                            </td>
                            <td class="padding3012">
                                결제취소
                            </td>
                        </tr>
                    </tbody>
                </table>

                <h3 class="mypage_con_stit">배송지 정보</h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">배송지 정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textL">받는사람</th>
                            <td class="text12L">홍길동</td>
                        </tr>
                        <tr>
                            <th class="textL">핸드폰 번호/연락처</th>
                            <td class="text12L">010-1234-1234 / 032-1222-3333</td>
                        </tr>
                        <tr>
                            <th class="textL">배송메모</th>
                            <td class="text12L">빠른 배송 부탁드려요.</td>
                        </tr>
                        <tr>
                            <th class="textL">주소</th>
                            <td class="text12L">
                                <ul class="mypage_s_list">
                                    <li>지번주소: 서울특별시 영등포구 대림동</li>
                                    <li>도로명주소: 서울특별시 영등포구 도림천로19길</li>
                                    <li>상세주소: 202호</li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="btn_area">
                    <button type="button" class="btn_prev_page">이전 페이지로</button>
                </div>
            </div>
            <!---// 비회원 주문/배송조회 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 비회원 주문/배송조회 메인 --->
    </t:putAttribute>
</t:insertDefinition>