<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-05-17
  Time: 오후 4:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
		//이미지 슬라이더
   		$('.product_slider').bxSlider({
   			auto: false,
   		});
		$('#product_list_slider').bxSlider({
		  slideMargin: 5,
		  autoReload: true,
		  breaks: [{screen:0, slides:2, pager:true},{screen:640, slides:2},{screen:768, slides:3}]
		});

		$('div[name=image_view]').each(function(idx, item){
			var $el = $(this);
			$('div[name=goodsRow]', $el).hide();
			$('div[name=goodsRow]', $el).first().show();
			$('li[name=totalPage]', $el.next()).text($('div[name=goodsRow]', $el).size());
		});
		
		//이전 버튼을 클릭하면 이전 슬라이드로 전환
		$( 'li.prev' ).on( 'click', function () {
			var $curPage = $(this).parent().find('span[name=curPage]');
			var curPage = Number($curPage.text());
			if(curPage > 1){
				var $image_view = $(this).parent().parent().prev();
				var $prevImageView = $image_view.find('div[name=goodsRow]:visible').prev();
				$('div[name=goodsRow]', $image_view).hide();
				$prevImageView.show();
				$curPage.text(curPage-1);
			}
			return false;              //<a>에 링크 차단
		});
	
		//다음 버튼을 클릭하면 다음 슬라이드로 전환
		$( 'li.next' ).on( 'click', function () {
			var $curPage = $(this).parent().find('span[name=curPage]');
			var curPage = Number($curPage.text());
			var totalPage = Number($(this).parent().find('li[name=totalPage]').text());
			if(curPage < totalPage){
				var $image_view = $(this).parent().parent().prev();
				var $nextImageView = $image_view.find('div[name=goodsRow]:visible').next();
				$('div[name=goodsRow]', $image_view).hide();
				$nextImageView.show();	
				$curPage.text(curPage+1);
			}
	    	return false;
		});
		
	});
    </script>
	</t:putAttribute>
	
    <t:putAttribute name="content">
    
        <%@ include file="main_visual.jsp" %>
        
        <!--- main content area --->
		<div id="middle_area">
			<!-- 추천상품 -->
			<!-- 인기상품 -->
			<!-- 판매베스트 -->
			
			<!-- 
				퍼블에는 추천상품(이미지보기),인기상품(이미지보기),판매베스트(리스트형)으로 되어있으나 웹버전에서 전시타입 설정을
				최대 5개까지 주어서 관리자가 개별의 타입마다 큰이미지형,이미지형,갤러리형,슬라이드형,리스트형으로 보여질 수 있게끔 되어있음
				관리자는 이 5개의 상품진열타입의 사용유무를 설정할 수 있어서 사용으로 설정된 데이터만 화면에 뿌려지게 되어있어 그대로 작업함.
			-->
			<data:goodsList value="${displayGoods1}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			<data:goodsList value="${displayGoods2}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			<data:goodsList value="${displayGoods3}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			<data:goodsList value="${displayGoods4}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			<data:goodsList value="${displayGoods5}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			
		</div>
		<!---// main content area --->
		<!---// 04.LAYOUT: MAIN CONTENTS --->

        <input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "MM" />
        
    </t:putAttribute>
    
</t:insertDefinition>