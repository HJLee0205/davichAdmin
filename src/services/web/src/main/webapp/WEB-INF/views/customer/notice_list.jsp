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
        var searchKind = '${so.searchKind}';
        if(searchKind !='') {
            $("#searchKind").val(searchKind);
            $("#searchKind").trigger("change");
        }

        //검색
        $('#btn_id_search').on('click', function() {
            searchNotice();
        });

        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));
    });
    function searchNotice(){
        var data = $('#form_id_search').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
            param[obj.name] = obj.value;
        });
        Dmall.FormUtil.submit('/front/customer/notice-list', param);
    }
    //글 상세 보기
    function goBbsDtl(lettNo) {
        location.href="/front/customer/notice-detail?lettNo="+lettNo;
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
                <form id="form_id_search" action="/front/customer/notice-list" method="post">
                <div class="table_top">
                    <div class="select_box28" style="width:100px;display:inline-block">
                        <label for="searchKind">전체</label>
                        <select class="select_option" id="searchKind" title="select option" name="searchKind" >
                            <option value="all">전체</option>
                            <option value="searchBbsLettTitle">제목</option>
                            <option value="searchBbsLettContent">내용</option>
                        </select>
                    </div>
                    <input type="text" name="searchVal" id="searchVal" value="${so.searchVal}">
                    <button type="button" id="btn_id_search"></button>
                </div>
                <input type="hidden" name="page" id="page" value="1" />
                <table class="tNotice_Board">
                    <caption>
                        <h1 class="blind">공지사항 게시판 목록 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:76px">
                        <c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                        <col style="width:100px">
                        </c:if>
                        <col style="width:*">
                        <col style="width:78px">
                        <col style="width:125px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                            <th>말머리</th>
                            </c:if>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>게시일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${resultListModel.resultList ne null}">
                              <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                              <tr>
                                  <td class="textC">
                                  ${resultModel.rowNum}
                                  </td>
                                  <c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                                  <td>${resultModel.titleNm}</td>
                                  </c:if>
                                  <td>
                                      <a href="javascript:goBbsDtl('${resultModel.lettNo}')">${resultModel.title}</a>
                                  </td>
                                  <td class="textC">${resultModel.memberNm}</td>
                                  <td class="textC">
                                      <fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" />
                                      </br><fmt:formatDate pattern="aa hh:mm:ss" value="${resultModel.regDttm}" />
                                  </td>
                              </tr>
                              </c:forEach>
                            </c:when>
                            <c:otherwise>
                            <tr>
                                <c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                                    <td colspan="5" class="textC">등록된 글이 없습니다.</td>
                                </c:if>
                                <c:if test="${bbsInfo.data.titleUseYn ne 'Y'}">
                                    <td colspan="4" class="textC">등록된 글이 없습니다.</td>
                                </c:if>
                            </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                <!----// 페이징 ---->
                </form>
            </div>
            <!---// 고객센터 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>