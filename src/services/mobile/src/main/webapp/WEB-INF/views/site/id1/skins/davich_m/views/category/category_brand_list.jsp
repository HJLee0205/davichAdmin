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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="davichLayout">
<t:putAttribute name="title">브랜드관</t:putAttribute>
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
		$('.brand_list_select a').click(function(){
			var cd = $(this).attr('data-code');
			$('.brand_name_category').find('dt').each(function(){
				var dt_cd = $(this).attr('data-code');
				if(dt_cd == cd){
					var scrollPosition = $(this).offset().top-150;
					$("html, body").animate({
						scrollTop: scrollPosition
					}, 500);
					
				}
			});
		});

    });
	
	// 브랜드 목록 조회
	function ajaxBrandList(){
		
	    var url = '${_MOBILE_PATH}/front/brand-category-list-ajax';
	    var param = {};

	    Dmall.AjaxUtil.getJSON(url, param, function(data) {
	    	/*
	    	var brandNm = '';
	    	var brandNo = '';
	    	var type = '';
	    	var firstWord = '';
	    	*/

	    	var brandHanNm = '';	//브랜드 한글명
	    	var brandEnNm = '';		//브랜드 영문명
	    	var firstHanWord = '';	//브랜드 한글명 초성
	    	var firstEnWord = '';	//브랜드 영문명 첫알파벳
	    	
	    	for(var i=0;i<data.length;i++){
	    		/*
	    		brandNm = data[i].brandNm;
	    		brandNo = data[i].brandNo;
	    		type = 'id_HangulArea';
	    		firstWord = fn_first_hangul(brandNm);
	    		
	    		if(firstWord == ''){
	    			type = 'id_AlphabetArea';
	    			firstWord = brandNm.charAt(0).toUpperCase();
	    		}
	    		
	    		$('#'+type).find('dt').each(function(){
	    			var cd = $(this).attr('data-code');
	    			if(cd == firstWord){
	    				if($(this).next('dd').attr('list-type') == 'default'){
	    					$(this).next('dd').remove();
	    				}
	    				$(this).after('<dd><a href="${_MOBILE_PATH}/front/brand-category-dtl?searchBrands='+brandNo+'">'+brandNm+'</a></dd>');
	    			}
	    		})
	    		*/
	    		
	    		brandHanNm = data[i].brandNm;
		    	brandEnNm = data[i].brandEnnm;
	    		
	    		if(brandHanNm != '' && brandHanNm != null) {
	    			firstHanWord = fn_first_hangul(brandHanNm);
	    			
	    			$('#id_HangulArea').find('dt').each(function(){
		    			var cd = $(this).attr('data-code');
		    			if(cd == firstHanWord){
		    				if($(this).next('dd').attr('list-type') == 'default'){
		    					$(this).next('dd').remove();
		    				}
		    				$(this).after('<dd><a href="${_MOBILE_PATH}/front/brand-category-dtl?searchBrands='+data[i].brandNo+'">'+brandHanNm+'</a></dd>');
		    			}
		    		});
	    		}
	    		if(brandEnNm != '' && brandEnNm != null) {
	    			firstEnWord = brandEnNm.charAt(0).toUpperCase();
	    			$('#id_AlphabetArea').find('dt').each(function(){
		    			var cd = $(this).attr('data-code');
		    			if(cd == firstEnWord){
		    				if($(this).next('dd').attr('list-type') == 'default'){
		    					$(this).next('dd').remove();
		    				}
		    				$(this).after('<dd><a href="${_MOBILE_PATH}/front/brand-category-dtl?searchBrands='+data[i].brandNo+'">'+brandEnNm+'</a></dd>');
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
		
		var hangulHtml = '<li class="kr_list"><dl class="menu">';
		for(var i=0;i<hangul.length;i++){
			hangulHtml+= '<dt data-code="'+hangul[i]+'"><a name="kr1"></a>'+hangul[i]+'</dt>' + 
						'<dd list-type="default"><a href="javascript:;" style="cursor:default;">-</a></dd>';
		}
		hangulHtml+= '</dl></li>';
		$('#id_HangulArea').html(hangulHtml);
		
		var alphabetHtml = '<li class="kr_list"><dl class="menu">';
		for(var i=0;i<alphabet.length;i++){
			alphabetHtml+= '<dt data-code="'+alphabet[i]+'"><a name="kr1"></a>'+alphabet[i]+'</dt>' +
						  '<dd list-type="default"><a href="javascript:;" style="cursor:default;">-</a></dd>';
		}
		hangulHtml+= '</dl></li>';
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
		$('#tab_kor_eng').find('li').each(function(){
			if($(this).attr('data-type') == type){
				$(this).addClass('active');
			}else{
				$(this).removeClass('active');	
			}
		});
		
		if(type == 'a'){
			$('#id_AlphabetArea').show();
			$('#id_HangulArea').hide();
			$('#div_eng').show();
			$('#div_kor').hide();
			
		}else{
			$('#id_HangulArea').show();
			$('#id_AlphabetArea').hide();
			$('#div_kor').show();
			$('#div_eng').hide();
		}
	}
	
</script>
</t:putAttribute>
	<t:putAttribute name="content">

	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			브랜드관
		</div>
		<div id="div_brand_step01">
			<div class="brand_top02">
				<ul class="product_list_typeB floatC marginT0">
					<c:forEach items="${brand_rolling }" var="li">
						<li>
							<a href="${_MOBILE_PATH}/front/brand-category-dtl?searchBrands=${li.brandNo }">							
							<img src="${_IMAGE_DOMAIN}/image/image-view?type=BRAND&id1=${li.listImgPath}_${li.listImgNm}" alt="${li.listImgNm}" onerror="this.src='/m/front/img/product/product_180_180.gif'">
							<div class="text">
								<em>${li.brandNm}</em>
							</div>
							</a>
						</li>
					</c:forEach>
				</ul><!-- // 상품정보영역 -->				
				<div class="sub_visual_control brand_list">
					<button type="button" class="btn_sub_slider_prev">이전으로</button>
					<button type="button" class="btn_sub_slider_next">다음으로</button>
				</div>
			</div><!-- //brand_top -->
			<div class="category_brand_select">
				<ul class="tab" id="tab_kor_eng">
					<li class="active" data-type="h"><a onClick="javascript:fn_change_brand('h');">ㄱ~ㅎ 기준</a></li>
					<li data-type="a"><a onClick="javascript:fn_change_brand('a');">A~Z 기준</a></li>
				</ul>
			</div>
			<div class="brand_list_select" id="div_kor">
				<span><a data-code="ㄱ">ㄱ</a></span>
				<span><a data-code="ㄲ">ㄲ</a></span>
				<span><a data-code="ㄴ">ㄴ</a></span>
				<span><a data-code="ㄷ">ㄷ</a></span>
				<span><a data-code="ㄸ">ㄸ</a></span>
				<span><a data-code="ㄹ">ㄹ</a></span>
				<span><a data-code="ㅁ">ㅁ</a></span>
				<span><a data-code="ㅂ">ㅂ</a></span>
				<span><a data-code="ㅃ">ㅃ</a></span>
				<span><a data-code="ㅅ">ㅅ</a></span>
				<span><a data-code="ㅆ">ㅆ</a></span>
				<span><a data-code="ㅇ">ㅇ</a></span>
				<span><a data-code="ㅈ">ㅈ</a></span>
				<span><a data-code="ㅉ">ㅉ</a></span>
				<span><a data-code="ㅊ">ㅊ</a></span>
				<span><a data-code="ㅋ">ㅋ</a></span>
				<span><a data-code="ㅌ">ㅌ</a></span>
				<span><a data-code="ㅍ">ㅍ</a></span>			
				<span><a data-code="ㅎ">ㅎ</a></span>			
			</div>
			<div class="brand_list_select" id="div_eng" style="display:none;">
				<span><a data-code="A">A</a></span>
				<span><a data-code="B">B</a></span>
				<span><a data-code="C">C</a></span>
				<span><a data-code="D">D</a></span>
				<span><a data-code="E">E</a></span>
				<span><a data-code="F">F</a></span>
				<span><a data-code="G">G</a></span>
				<span><a data-code="H">H</a></span>
				<span><a data-code="I">I</a></span>
				<span><a data-code="J">J</a></span>
				<span><a data-code="K">K</a></span>
				<span><a data-code="L">L</a></span>
				<span><a data-code="M">M</a></span>			
				<span><a data-code="N">N</a></span>			
				<span><a data-code="O">O</a></span>
				<span><a data-code="P">P</a></span>
				<span><a data-code="Q">Q</a></span>
				<span><a data-code="R">R</a></span>
				<span><a data-code="S">S</a></span>
				<span><a data-code="T">T</a></span>
				<span><a data-code="U">U</a></span>
				<span><a data-code="V">V</a></span>
				<span><a data-code="W">W</a></span>
				<span><a data-code="X">X</a></span>
				<span><a data-code="Y">Y</a></span>
				<span><a data-code="Z">Z</a></span>
			</div>
			<ul class="brand_name_category" id="id_HangulArea"></ul>
			<ul class="brand_name_category" id="id_AlphabetArea"></ul>
		</div>
	</div><!-- //middle_area -->
	<!---// 03.LAYOUT:CONTENTS --->
    </t:putAttribute>
</t:insertDefinition>