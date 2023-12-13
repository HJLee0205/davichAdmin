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
	<t:putAttribute name="title">고객센터</t:putAttribute>


    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //FAQ 더보기
        $('#best_qna5').on('click', function(e) {
            location.href = "/front/customer/faq-list";
        });

        //공지사항 더보기
        $('#notice_more').on('click', function(e) {
            location.href = "/front/customer/notice-list";
        });

        //FAQ 검색
        $('#btn_qna_search').on('click', function() {
            var searchVal = $("#qna_search").val();
            var param = {searchVal : searchVal, faqGbCd:'', searchKind:'customerMain'};
            var url = "/front/customer/faq-list";
            Dmall.FormUtil.submit(url, param)
        });

        $('#qna_search').on('keydown',function(event){
            if (event.keyCode == 13) {
                $('#btn_qna_search').click();
            }
        })

        //아이디/비번 찾기
        $('.customer_bottom_menu01').on('click', function(e) {
            location.href = "/front/login/account-search?mode=id";
        });

        //주문 / 배송조회
        $('.customer_bottom_menu02').on('click', function(e) {
            if(loginYn) {
                location.href = "/front/order/order-list";
            }else{
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    location.href= "/front/login/member-login"
                },'');
            }
        });

        //회원정보 수정
        $('.customer_bottom_menu03').on('click', function(e) {
            if(loginYn) {
                location.href = "/front/member/information-update-form";
            }else{
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    location.href= "/front/login/member-login"
                },'');
            }
        });

        // 미확인 입금내역
        $('.customer_bottom_menu04').on('click', function(e) {
            if(loginYn) {
                location.href = "/front/member/refund-account";
            }else{
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    location.href= "/front/login/member-login"
                },'');
            }
        });
    });
    function viewFaq(idx){
        location.href = "/front/customer/faq-list?faqGbCd="+idx;
    }
    function viewNotice(idx){
        location.href="/front/customer/notice-detail?lettNo="+idx
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>고객센터
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">고객센터<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="customer">
            <!--- 고객센터 왼쪽 메뉴 --->
            <%@ include file="include/customer_left_menu.jsp" %>
            <!---// 고객센터 왼쪽 메뉴 --->
            <!--- 고객센터 오른쪽 컨텐츠 --->
            <div class="customer_content">
                <div class="customer_search_area">
                    <label for="qna_search">자주묻는 질문</label><input type="text" id="qna_search" placeholder="문의사항을 입력하세요."><button type="button" id="btn_qna_search">검색</button>
                </div>
                <ul class="customer_main_list">
                    <li>
                        <h3 class="customer_main_list_tit">
                            자주묻는 질문 TOP 5
                            <button type="button" id="best_qna5"><img src="/front/img/customer/icon_more.png" alt="자주묻는 질문 TOP 5 바로가기"></button>
                        </h3>
                        <ul class="customer_main_slist">
                        <c:forEach var="faqList" items="${faqList.resultList}" varStatus="status" end="4">
                            <li><span class="no">${status.count}</span><a href="javascript:viewFaq('${faqList.faqGbCd}')">Q.${faqList.title}</a></li>
                        </c:forEach>
                        </ul>
                    </li>
                    <li>
                        <h3 class="customer_main_list_tit">
                            공지사항
                            <button type="button" id="notice_more"><img src="/front/img/customer/icon_more.png" alt="공지사항 바로가기"></button>
                        </h3>
                        <ul class="customer_notice_slist">
                            <c:forEach var="noticeList" items="${noticeList.resultList}" varStatus="status" end="4" >
                                <li><a href="javascript:viewNotice('${noticeList.lettNo}');">${noticeList.title}</a><span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${noticeList.regDttm}" /></span></li>
                            </c:forEach>
                        </ul>
                    </li>
                </ul>
                <ul class="customer_bottom_menu">
                    <li>
                        <a href="#none" class="customer_bottom_menu01">
                            아이디<br>
                            비밀번호찾기
                            <button type="button"><img src="/front/img/customer/icon_more.png" alt="아이디 비밀번호 찾기 바로가기"></button>
                        </a>
                    </li>
                    <li>
                        <a href="#none" class="customer_bottom_menu02">
                            주문/<br>
                            배송조회
                            <button type="button"><img src="/front/img/customer/icon_more.png" alt="주문/배송조회 바로가기"></button>
                        </a>
                    </li>
                    <li>
                        <a href="#none" class="customer_bottom_menu03">
                            회원정보<br>
                            수정
                            <button type="button"><img src="/front/img/customer/icon_more.png" alt="회원정보 수정 바로가기"></button>
                        </a>
                    </li>
                    <li>
                        <a href="#none" class="customer_bottom_menu04">
                            환불/입금계좌<br>
                            조회
                            <button type="button"><img src="/front/img/customer/icon_more.png" alt="미확인 입금내역 바로가기"></button>
                        </a>
                    </li>
                </ul>
            </div>
            <!---// 고객센터 오른쪽 컨텐츠 --->
        </div>
    </div>
    <div class="hidden">#@22_55$%@#</div>
    <!---// 고객센터 메인 --->
    </t:putAttribute>
</t:insertDefinition>