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
	<t:putAttribute name="title">공지사항</t:putAttribute>


	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //목록
        $('.btn_notice_list').on('click', function() {
            location.href="/front/customer/notice-list";
        });

        //이미지 리사이징
        resizeImg();
    });

    //글 상세 보기
    function goBbsDtl(lettNo) {
        location.href="/front/customer/notice-detail?lettNo="+lettNo;
    }

    ///이미지 리사이즈
    function resizeImg(){
        var innerBody;
        innerBody =  $('.view');
        $(innerBody).find('img').each(function(i){
            var imgWidth = $(this).width();
            var imgHeight = $(this).height();
            var resizeWidth = $(innerBody).width();
            var resizeHeight = resizeWidth / imgWidth * imgHeight;

            $(this).css("max-width", "720px");

            $(this).css("width", resizeWidth);
            $(this).css("height", resizeHeight);

        });
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
                <h3 class="customer_con_tit">
                    공지사항
                    <span>새로운 이벤트 및 안내 가이드 게시글을 확인하실 수 있습니다.</span>
                </h3>
                <table class="tNotice_View" style="margin-top:30px">
                    <caption>
                        <h1 class="blind">${resultModel}</h1>
                    </caption>
                    <colgroup>
                        <col style="width:130px">
                        <col style="width:">
                        <col style="width:130px">
                        <col style="width:130px">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>제목</th>
                            <td class="textC" colspan="3">${resultModel.data.title}</td>
                        </tr>
                        <tr>
                            <th>작성자</th>
                            <td>${resultModel.data.memberNm}</td>
                            <th>게시일</th>
                            <td>
                                <fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.data.regDttm}" />
                                </br><fmt:formatDate pattern="aa hh:mm:ss" value="${resultModel.data.regDttm}" />
                            </td>
                        </tr>
                        <tr>
                            <td class="view" colspan="4">
                                ${resultModel.data.content}
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <c:if test="${preBbs.data ne null}">
                            <tr>
                                <th>이전글</th>
                                <td colspan="3">
                                    <a href="javascript:goBbsDtl('${preBbs.data.lettNo}')">${preBbs.data.title}</a>
                                </td>
                            </tr>
                            </c:if>
                            <c:if test="${nextBbs.data ne null}">
                            <tr>
                                <th>다음글</th>
                                <td colspan="3">
                                    <a href="javascript:goBbsDtl('${nextBbs.data.lettNo}')">${nextBbs.data.title}</a>
                                </td>
                            </tr>
                            </c:if>
                    </tfoot>
                </table>

                <div class="btn_customer_area">
                    <button type="button" class="btn_notice_list">목록</button>
                </div>
            </div>
            <!---// 고객센터 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>