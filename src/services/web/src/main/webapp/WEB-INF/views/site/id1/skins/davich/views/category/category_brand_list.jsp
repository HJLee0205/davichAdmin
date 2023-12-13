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
<t:putAttribute name="title">다비치마켓 :: 브랜드관</t:putAttribute>
<t:putAttribute name="script">
<script>

	var hangul = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"];
	var alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
	
	$(document).ready(function(){
		
		// 초성 목록 세팅
		fn_setBrandArea();
		// 브랜드 목록 조회
		ajaxBrandList();
		
		// 초성 클릭 이벤트
		$('.brand_name li').click(function(){
			var cd = $(this).attr('data-code');
			$('.brand_name_category').find('ul').each(function(){
				var ul_cd = $(this).attr('data-code');
				if(ul_cd == cd){
					var scrollPosition = $(this).offset().top;
					$("html, body").animate({
						scrollTop: scrollPosition
					}, 500);
					
				}
			});
		});
		
	});
	
		// 브랜드 목록 조회
		function ajaxBrandList(){
			
		    var url = '/front/brand-category-list-ajax';
		    var param = {};
	
		    Dmall.AjaxUtil.getJSON(url, param, function(data) {
		    	var brandHanNm = '';	//브랜드 한글명
		    	var brandEnNm = '';		//브랜드 영문명
		    	var firstHanWord = '';	//브랜드 한글명 초성
		    	var firstEnWord = '';	//브랜드 영문명 첫알파벳
		    	
		    	for(var i=0;i<data.length;i++){
		    		brandHanNm = data[i].brandNm;
		    		brandEnNm = data[i].brandEnnm;

		    		if(brandHanNm != '' && brandHanNm != null) {
		    			firstHanWord = fn_first_hangul(brandHanNm);
		    			
		    			$('#id_HangulArea').find('ul').each(function(){
			    			var cd = $(this).attr('data-code');
			    			if(cd == firstHanWord){
			    				if($(this).children('li').attr('list-type') == 'default'){
			    					$(this).html('');
			    				}
			    				$(this).append('<li><a href="/front/brand-category-dtl?searchBrands='+data[i].brandNo+'">'+brandHanNm+'</a></li>');
			    			}
			    		});
		    		}
		    		if(brandEnNm != '' && brandEnNm != null) {
		    			firstEnWord = brandEnNm.charAt(0).toUpperCase();
		    			$('#id_AlphabetArea').find('ul').each(function(){
			    			var cd = $(this).attr('data-code');
			    			if(cd == firstEnWord){
			    				if($(this).children('li').attr('list-type') == 'default'){
			    					$(this).html('');
			    				}
			    				$(this).append('<li><a href="/front/brand-category-dtl?searchBrands='+data[i].brandNo+'">'+brandEnNm+'</a></li>');
			    			}
			    		});
		    		}
		    	}
		    });
		}
		
		// 초성 목록 세팅
		function fn_setBrandArea(){
			$('#id_HangulArea').html('');
			$('#id_AlphabetArea').html('');
			
			var hangulHtml = '';
			for(var i=0;i<hangul.length;i++){
				hangulHtml+= '<li>';
				hangulHtml+= '<p class="name">'+hangul[i]+'</p>';
				hangulHtml+= '<ul class="menu" data-code="'+hangul[i]+'"><li list-type="default"><a href="javascript:;" style="cursor:default;">-</a></li></ul>';
				hangulHtml+= '</li>';
			}
			$('#id_HangulArea').html(hangulHtml);
			
			var alphabetHtml = '';
			for(var i=0;i<alphabet.length;i++){
				alphabetHtml+= '<li>';
				alphabetHtml+= '<p class="name">'+alphabet[i]+'</p>';
				alphabetHtml+= '<ul class="menu" data-code="'+alphabet[i]+'"><li list-type="default"><a href="javascript:;" style="cursor:default;">-</a></li></ul>';
				alphabetHtml+= '</li>';
			}
			$('#id_AlphabetArea').html(alphabetHtml);
			$('#id_AlphabetArea').hide();
		}
		
		// 한글의 첫글자 초성을 가져오는 함수
		function fn_first_hangul(str) {
			
			result = "";
		    code = str.charCodeAt(0)-44032;
			if(code>-1 && code<11172) result += hangul[Math.floor(code/588)];
			return result;
		}
		
		// 한/영 목록 전환
		function fn_change_brand(type){
			if(type == 'a'){
				$('#id_AlphabetArea').show();
				$('#id_HangulArea').hide();
			}else{
				$('#id_HangulArea').show();
				$('#id_AlphabetArea').hide();
			}
		}	
		
</script>
</t:putAttribute>
    <t:putAttribute name="content">
		<!--- category header --->
	
		<!--- 02.LAYOUT: 상품 메인 --->
		<div class="category_middle">
			<div id="brand_div">
				<div class="event_head">
					<h2 class="event_tit">브랜드관</h2>
				</div>
				<!-- 베스트 브랜드 -->
				<div class="brand_area">
					<!--h3 class="category_mid_tit">브랜드관</h3-->
					<ul class="product_bb">
						<c:forEach items="${brand_rolling }" var="li">
							<li>
								<a href="/front/brand-category-dtl?searchBrands=${li.brandNo }">
									<div class="img_area">
										<img src="${_IMAGE_DOMAIN}/image/image-view?type=BRAND&id1=${li.listImgPath}_${li.listImgNm}" alt="${li.listImgNm}" >
									</div>
									<%--<div class="text_area">
										<p class="name">${li.brandNm}</p>
									</div>--%>
								</a>
							</li>
						</c:forEach>
					</ul>
					<div class="best_brand_control">
						<button type="button" class="btn_product_bb_prev">이전으로</button>
						<button type="button" class="btn_product_bb_next">다음으로</button>
					</div>
				</div>
				<!--// 베스트 브랜드 -->
	
				<!-- 브랜드찾기 -->
				<div class="category_brand_select">
					<div class="tit">브랜드전체</div>
					<div class="name">
						<ul class="brand_name kor">
							<li data-code="ㄱ"><span>ㄱ</span></li>
							<li data-code="ㄲ"><span>ㄲ</span></li>
							<li data-code="ㄴ"><span>ㄴ</span></li>
							<li data-code="ㄷ"><span>ㄷ</span></li>
							<li data-code="ㄸ"><span>ㄸ</span></li>
							<li data-code="ㄹ"><span>ㄹ</span></li>
							<li data-code="ㅁ"><span>ㅁ</span></li>
							<li data-code="ㅂ"><span>ㅂ</span></li>
							<li data-code="ㅃ"><span>ㅃ</span></li>
							<li data-code="ㅅ"><span>ㅅ</span></li>
							<li data-code="ㅆ"><span>ㅆ</span></li>
							<li data-code="ㅇ"><span>ㅇ</span></li>
							<li data-code="ㅈ"><span>ㅈ</span></li>
							<li data-code="ㅉ"><span>ㅉ</span></li>
							<li data-code="ㅊ"><span>ㅊ</span></li>
							<li data-code="ㅋ"><span>ㅋ</span></li>
							<li data-code="ㅌ"><span>ㅌ</span></li>
							<li data-code="ㅍ"><span>ㅍ</span></li>
							<li data-code="ㅎ"><span>ㅎ</span></li>
						</ul>
						<ul class="brand_name eng">
							<li data-code="A"><span>A</span></li>
							<li data-code="B"><span>B</span></li>
							<li data-code="C"><span>C</span></li>
							<li data-code="D"><span>D</span></li>
							<li data-code="E"><span>E</span></li>
							<li data-code="F"><span>F</span></li>
							<li data-code="G"><span>G</span></li>
							<li data-code="H"><span>H</span></li>
							<li data-code="I"><span>I</span></li>
							<li data-code="J"><span>J</span></li>
							<li data-code="K"><span>K</span></li>
							<li data-code="L"><span>L</span></li>
							<li data-code="M"><span>M</span></li>
							<li data-code="N"><span>N</span></li>
							<li data-code="O"><span>O</span></li>
							<li data-code="P"><span>P</span></li>
							<li data-code="Q"><span>Q</span></li>
							<li data-code="R"><span>R</span></li>
							<li data-code="S"><span>S</span></li>
							<li data-code="T"><span>T</span></li>
							<li data-code="U"><span>U</span></li>
							<li data-code="V"><span>V</span></li>
							<li data-code="W"><span>W</span></li>
							<li data-code="X"><span>X</span></li>
							<li data-code="Y"><span>Y</span></li>
							<li data-code="Z"><span>Z</span></li>
						</ul>
					</div>
					<button type="button" class="btn_eng" onClick="javascript:fn_change_brand('a');">A~Z 기준</button>
					<button type="button" class="btn_kor" onClick="javascript:fn_change_brand('h');">ㄱ~ㅎ 기준</button>
				</div>
				<!--// 브랜드찾기 -->
				<ul class="brand_name_category" id="id_HangulArea">
				</ul>
				<ul class="brand_name_category" id="id_AlphabetArea">
				</ul>
			</div>
        
		</div>
		<!---// 02.LAYOUT: 상품 메인 --->
	</t:putAttribute>
</t:insertDefinition>