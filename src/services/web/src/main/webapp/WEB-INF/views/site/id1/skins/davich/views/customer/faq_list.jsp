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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 자주묻는 질문</t:putAttribute>


	<t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
    	activeTab('${so.faqGbCd}');
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
        
        $(document).on('click','.my_qna_table02 .title',function(){
        	$(this).toggleClass('active');
			$(".my_qna_table02 .title").not(this).removeClass('active');

			var article02 = (".my_qna_table02 .show");
			var myArticle02 =$(this).next("tr");	
			if($(myArticle02).hasClass('hide')) {
				$(article02).removeClass('show').addClass('hide');
				$(myArticle02).removeClass('hide').addClass('show');
			}
			else {
				$(myArticle02).addClass('hide').removeClass('show');
			}	
         });

    });


    var bbsLettSet = {
        bbsLettList : [],
        getBbsLettList : function() {
            var url = '/front/customer/faq-list-ajax',dfd = jQuery.Deferred();
            var param = jQuery('#form_id_search').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                var template =
                '<tr class="title" id="{{lettNo}}">'+
                    '<td><span class="bar_tit">{{faqGbNm}}</span></td>'+
                    '<td class="textL">{{title}}</td>'+
                '</tr>'+
                '<tr class="hide" id="activeTab_{{lettNo}}">'+
                    '<td colspan="2" class="que_text_area">'+
                        '{{content}}'+
                    '</td>'+
                '</tr>',
                    managerGroup = new Dmall.Template(template),
                        tr = '';
                jQuery.each(result.resultList, function(idx, obj) {
                    tr += managerGroup.render(obj)
                });

                if(tr == '') {      
                	tr = '<tr class="title"><td colspan="2">데이터가 없습니다.</td></tr>';
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
    	activeTab(idx);
        $("#faqGbCd").val(idx);
        $("#qna_search").val('');
        bbsLettSet.getBbsLettList();
    }
    function selectFaq(){
        bbsLettSet.getBbsLettList();
    }

	function activeTab(faqGbCd){
			    
     	if($(".active").hasClass("active") === true) {
    	 $(".active").removeClass();
    	}	    
		var id="faq_tabs_"+faqGbCd;
		$('#'+id).addClass('active');
		
		var id2="faq_"+faqGbCd;
		$('#'+id2).addClass('active');
	}
    
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- category header 카테고리 location과 동일 --->
    <div id="category_header">
        <div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>고객센터</li>
				<li>자주묻는 질문</li>
			</ul>
            <!-- <span class="location_bar"></span><a>홈</a><span>&gt;</span><a>고객센터</a><span>&gt;</span>자주묻는 질문 -->
        </div>
    </div>
    <!---// category header --->
    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="customer_middle">	
		<!-- snb -->
		 <%@ include file="include/customer_left_menu.jsp" %>
		<!--// snb -->
		<!-- content -->
		<div id="customer_content">
			<form id="form_id_search" action="/front/customer/faq-list-ajax">
	        <input type="hidden" name="faqGbCd" id="faqGbCd" value="${so.faqGbCd}"/>
	        <input type="hidden" name="searchVal" id="searchVal" value="${so.searchVal}"/>
	        <input type="hidden" name="page" id="page" value="1" />
			<div class="customer_top">		
				<div class="text_area">
					<em>자주묻는질문 검색</em>으로<br>
					더 빠르게 궁금증을 해결해 보세요.
				</div>
				<div class="search_area">
					<input type="text" id="qna_search" value="${so.searchVal}"><button type="button" class="btn_q_search" id="btn_qna_search">검색</button>
				</div>
			</div>
			<div class="customer_body">
				<h3 class="my_tit">자주묻는 질문</h3>
				<div class="usual_question" id="usual_question">
				 	<a href="javascript:selectFaqTab('');" id="faq_tabs_" class="">
                                        전체</a>
				    <c:forEach var="codeModel" items="${codeListModel}" varStatus="status">
                    <a href="javascript:selectFaqTab('${codeModel.dtlCd}');" id="faq_tabs_${codeModel.dtlCd}" class="">
                    ${codeModel.dtlNm}</a>
                    </c:forEach>					
				</div>


				<table class="tProduct_Board my_qna_table02">
					<caption>
						<h1 class="blind">상품문의 게시판 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:128px">
						<col style="">
					</colgroup>
					<tbody id="id_faqList">					
					</tbody>
				</table>
                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging"></div>
                <!----// 페이징 ---->				
			</div>
			</form>
		</div>		
		<!--// content -->
	</div>
    <!---// 02.LAYOUT: 마이페이지 --->	
    </t:putAttribute>
</t:insertDefinition>