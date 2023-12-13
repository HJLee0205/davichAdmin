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
	<t:putAttribute name="title">변경해주세요</t:putAttribute>
	
	
	
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents">
        <div id="mypage_location">
            <a href="">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 쇼핑<span>&gt;</span>주문/배송 조회
        </div>
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    주문/배송조회
                    <span class="row_info_text">주문내역 및 배송현황을 확인할 수 있습니다.</span>
                </h3>
                <div class="date_select_area">
                    <p class="date_select_title">- 기간검색</p>
                    <button type="button" class="btn_date_select" style="border-left:1px solid #e5e5e5;">15일</button><button type="button" class="btn_date_select">1개월</button><button type="button" class="btn_date_select">3개월</button><button type="button" class="btn_date_select">6개월</button><button type="button" class="btn_date_select">1년</button>
                    <input type="text" id="event_start" class="datepicker date" style="margin-left:8px"> ~ <input type="text" id="event_end" class="datepicker date">
                    <button type="button" class="btn_date" style="margin-left:8px">조회하기</button>
                </div>

                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">최근 주문/배송현황 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:112px">
                        <col style="width:45px">
                        <col style="width:">
                        <col style="width:80px">
                        <col style="width:82px">
                        <col style="width:74px">
                        <col style="width:70px">
                        <col style="width:70px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>주문일자<br>[주문번호]</th>
                            <th colspan="2">주문상품정보</th>
                            <th>주문금액<br>/수량</th>
                            <th>결제금액</th>
                            <th>주문상태</th>
                            <th>구매확정<br>/상품평</th>
                            <th>취소반품<br>/문의</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td rowspan="2">
                                <ul class="mypage_s_list f11">
                                    <li>2016-03-21<br>[AB20160321001]</li>
                                    <li><button type="button" class="btn_mypage_s02">상세보기</button></li>
                                    <li><button type="button" class="btn_mypage_s02">영수증</button></li>
                                </ul>
                            </td>
                            <td>
                                <img src="/front/img/mypage/my_cart_img01.gif">
                            </td>
                            <td class="textL f12">
                                <ul>
                                    <li>BL7827/시스루패턴 하이넥블라우스</li>
                                    <li>[기본옵션:화이트(white)</li>
                                    <li>[추가옵션:85size]</li>
                                </ul>
                            </td>
                            <td class="f12">
                                <ul>
                                    <li>120,000원</li>
                                    <li>/ 2개</li>
                                </ul>
                            </td>
                            <td rowspan="2" class="f12">480,000원</td>
                            <td rowspan="2" class="f12">
                                <ul class="mypage_s_list">
                                    <li>배송중</li>
                                    <li><button type="button" class="btn_mypage_s02">배송조회</button></li>
                                </ul>
                            </td>
                            <td>
                                <ul class="mypage_s_list">
                                    <li><button type="button" class="btn_mypage_s03">구매확정</button></li>
                                    <li><button type="button" class="btn_mypage_s03">상품평쓰기</button></li>
                                </ul>
                            </td>
                            <td>
                                <ul class="mypage_s_list">
                                    <li><button type="button" class="btn_mypage_s03">주문취소</button></li>
                                    <li><button type="button" class="btn_mypage_s03">문의하기</button></li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <img src="/front/img/mypage/my_cart_img01.gif">
                            </td>
                            <td class="textL f12">
                                <ul>
                                    <li>BL7827/시스루패턴 하이넥블라우스</li>
                                    <li>[기본옵션:화이트(white)</li>
                                    <li>[추가옵션:85size]</li>
                                </ul>
                            </td>
                            <td class="f12">
                                <ul>
                                    <li>120,000원</li>
                                    <li>/ 2개</li>
                                </ul>
                            </td>
                            <td>
                                <ul class="mypage_s_list">
                                    <li><button type="button" class="btn_mypage_s03">구매확정</button></li>
                                    <li><button type="button" class="btn_mypage_s03">상품평쓰기</button></li>
                                </ul>
                            </td>
                            <td>
                                <ul class="mypage_s_list">
                                    <li><button type="button" class="btn_mypage_s03">주문취소</button></li>
                                    <li><button type="button" class="btn_mypage_s03">문의하기</button></li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="mypage_s_list f11">
                                    <li>2016-03-21<br>[AB20160321001]</li>
                                    <li><button type="button" class="btn_mypage_s02">상세보기</button></li>
                                    <li><button type="button" class="btn_mypage_s02">영수증</button></li>
                                </ul>
                            </td>
                            <td>
                                <img src="/front/img/mypage/my_cart_img01.gif">
                            </td>
                            <td class="textL f12">
                                <ul>
                                    <li>BL7827/시스루패턴 하이넥블라우스</li>
                                    <li>[기본옵션:화이트(white)</li>
                                    <li>[추가옵션:85size]</li>
                                </ul>
                            </td>
                            <td class="f12">
                                <ul>
                                    <li>120,000원</li>
                                    <li>/ 2개</li>
                                </ul>
                            </td>
                            <td class="f12">480,000원</td>
                            <td>
                                <ul class="mypage_s_list f12">
                                    <li>배송중</li>
                                    <li><button type="button" class="btn_mypage_s02">배송조회</button></li>
                                </ul>
                            </td>
                            <td>
                                <ul class="mypage_s_list">
                                    <li><button type="button" class="btn_mypage_s03">구매확정</button></li>
                                    <li><button type="button" class="btn_mypage_s03">상품평쓰기</button></li>
                                </ul>
                            </td>
                            <td>
                                <ul class="mypage_s_list">
                                    <li><button type="button" class="btn_mypage_s03">주문취소</button></li>
                                    <li><button type="button" class="btn_mypage_s03">문의하기</button></li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!---- 페이징 ---->
                <div class="tPages">
                    <ul class="pages">
                        <li class="prev">
                            <span><img src="/front/img/common/btn_prev.gif" alt="이전페이지로 이동"></span>
                        </li>
                        <li class="active"><span>1</span></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">6</a></li>
                        <li><a href="#">7</a></li>
                        <li><a href="#">8</a></li>
                        <li><a href="#">9</a></li>
                        <li><a href="#">10</a></li>
                        <li class="next">
                            <a href="#"><img src="/front/img/common/btn_next.gif" alt="이전페이지로 이동"></a>
                        </li>
                    </ul>
                </div>
                <!----// 페이징 ---->

            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>