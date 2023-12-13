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
	<t:putAttribute name="title">자주묻는 질문</t:putAttribute>


	<t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
        bbsLettSet.getBbsLettList();
        $('#btn_qna_search').on('click', function() {
            $('ul.faq_tabs li').each(function() {
                if($(this).hasClass('active')) {
                    $(this).removeClass('active');
                }
            });
            $("#faqGbCd").val('');
            bbsLettSet.getBbsLettList();
        });
        $('#qna_search').on('keydown',function(event){
            if (event.keyCode == 13) {
                $('#btn_qna_search').click();
            }
        })
        $(document).on('click','.accordion-section-title',function(){
           if($(this).hasClass('active')){
               $(this).removeClass('active');
           }else{
               $(this).addClass('active');}
               $(".accordion-section-content:visible").slideUp("middle");
               $(this).next('.accordion-section-content:hidden').slideDown("middle");
           return false;
        });
    });


    var bbsLettSet = {
        bbsLettList : [],
        getBbsLettList : function() {
            var url = '/front/customer/faq-list-ajax',dfd = jQuery.Deferred();
            var param = jQuery('#form_id_search').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                var template =
                '<div class="accordion-section">'+
                    '<a class="accordion-section-title" href="#faq_tabs01_{{lettNo}}">'+
                        '<span class="faq_no">{{num}}</span>'+
                        '<span class="faq_sort">{{faqGbNm}}</span>'+
                        '<span class="icon_q">Q.</span>'+
                        '<span class="faq_tit">{{title}}</span>'+
                        '<span class="btn_faq_arrow"></span>'+
                    '</a>'+
                    '<div id="faq_tabs01_{{lettNo}}" class="accordion-section-content">'+
                        '<div>'+
                            '<span class="icon_a">A.</span>'+
                            '<p>{{content}}</p>'+
                        '</div>'+
                    '</div>'+
                '</div>',
                    managerGroup = new Dmall.Template(template),
                        tr = '';
                jQuery.each(result.resultList, function(idx, obj) {
                    tr += managerGroup.render(obj)
                });

                if(tr == '') {
                    tr = '<div class="accordion-section"><a class="accordion-section-title">데이터가 없습니다.</a></div>';
                }
                jQuery('#id_faqList').html(tr);
                bbsLettSet.bbsLettList = result.resultList;
                dfd.resolve(result.resultList);
                Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsLett', selectFaq);
                $("#a").text(result.filterdRows);
                $("#b").text(result.totalRows);
            });
            return dfd.promise();
        }
    }

    //faq tab click
    function selectFaqTab(idx){
        $("#faqGbCd").val(idx);
        $("#qna_search").val('');
        bbsLettSet.getBbsLettList();
    }
    function selectFaq(){
        bbsLettSet.getBbsLettList();
    }



    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>고객센터<span>&gt;</span>자주묻는 질문
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
                <form id="form_id_search" action="/front/customer/faq-list-ajax">
                <input type="hidden" name="faqGbCd" id="faqGbCd" value="${so.faqGbCd}"/>
                <input type="hidden" name="page" id="page" value="1" />
                <div class="customer_search_area">
                    <label for="qna_search">자주묻는 질문</label><input type="text" id="qna_search" name="searchVal" value="${so.searchVal}" placeholder="문의사항을 입력하세요." ><button type="button" id="btn_qna_search">검색</button>
                </div>
                <ul class="faq_tabs">
                    <c:forEach var="codeModel" items="${codeListModel}" varStatus="status">
                        <li rel="faq_tabs_${codeModel.dtlCd}"
                        <c:if test="${status.count == so.faqGbCd}" >class="active"</c:if> onclick="selectFaqTab('${codeModel.dtlCd}');">${codeModel.dtlNm}
                        </li>
                    </c:forEach>
                </ul>
                <!--- 주문관련 질문 --->
                </form>
                <div>
                    <div class="faq_title">
                        <span class="faq_no">번호</span>
                        <span class="faq_sort">분류</span>
                        <span class="faq_tit">제목</span>
                    </div>
                    <div class="accordion" id="id_faqList"></div>
                    <!---- 페이징 ---->
                    <div class="tPages" id="div_id_paging"></div>
                    <!----// 페이징 ---->
                </div>
                <!---// 주문관련 질문 --->
            </div>
            <!---// 고객센터 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>