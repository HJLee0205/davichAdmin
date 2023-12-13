<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script>
    $(document).ready(function(){
        //공지사항 더보기
        $('#notice_more').on('click', function(e) {
            location.href = "/front/customer/notice-list";
        });
    });

    function viewNotice(idx){
        location.href="/front/customer/notice-detail?lettNo="+idx
    }


</script>
<div class="bottom_layout">
<div class="bottom_notice">
    <h3 class="bottom_tit">
        공지사항
        <button type="button" class="btn_more" id="notice_more">더보기</button>
    </h3>
    <ul class="list">
        <c:forEach var="noticeList" items="${noticeList.resultList}" varStatus="status" end="4" >
            <li><a href="javascript:viewNotice('${noticeList.lettNo}');">${noticeList.title}</a></li>
        </c:forEach>

    </ul>
</div>
<div class="bottom_customer">
    <h3 class="bottom_tit">고객센터</h3>
    <p class="tel">${site_info.custCtTelNo}</p>
    <ul class="time">
        <li><span>평일</span>${site_info.custCtOperTime}</li>
        <li><span>점심</span>${site_info.custCtLunchTime}</li>
        <li><span>휴무</span>${site_info.custCtClosedInfo}</li>
    </ul>
    <button type="button" class="btn_bottom" onclick="javascript:location.href='/front/customer/faq-list'">자주찾는 질문</button>
    <%--<button type="button" class="btn_bottom" onclick="javascript:location.href='/front/customer/inquiry-list'">1:1문의하기</button>--%>
</div>
<div class="bottom_free">
    <c:choose>
        <c:when test="${fn:length(footer_banner.resultList)>0}">
            <a href="javascript:click_banner('${footer_banner.resultList[0].dispLinkCd}','${footer_banner.resultList[0].linkUrl}');">

                <img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${footer_banner.resultList[0].imgFileInfo}" alt="${footer_banner.resultList[0].bannerNm}" title="${footer_banner.resultList[0].bannerNm}">
            </a>
        </c:when>
        <c:otherwise>
            <img src="${_SKIN_IMG_PATH}/footer/free_test.gif" alt="무료시력검사 안내 바로가기">
        </c:otherwise>
        
    </c:choose>
</div>
<div class="bottom_guide">
    <ul class="list">
        <li><a href="/front/customer/store-list"><i class="icon01"></i>다비치 매장찾기</a></li>
        <!-- <li><a href="javascript:alert('준비중입니다');"><i class="icon02"></i>구매가이드</a></li> -->
        <li><a href="/front/customer/board-list?bbsId=freeBbs"><i class="icon02"></i>도움말</a></li>
        <li><a href="/front/visit/visit-welcome"><i class="icon03"></i>방문예약</a></li>
        <li><a href="javascript:alert('준비중입니다');"><i class="icon04"></i>통합멤버쉽 안내</a></li>
        <li><a href="/front/customer/board-list?bbsId=beststore"><img src="${_SKIN_IMG_PATH}/common/crown16.png" alt="우수매장" style="margin:0px 16px 0px 6px;">다비치 서비스 우수매장</a></li>
    </ul>
</div>
</div>