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
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%
pageContext.setAttribute("cn", "\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="davichLayout">
<t:putAttribute name="title">다비치마켓 :: ${so.ctgNm}</t:putAttribute>
<t:putAttribute name="script">
<script>
$(document).ready(function(){
    $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징

    //베스트 브랜드

        var BsetSlider = $( '.best_brand .product_bb' ).bxSlider({
            pager: false,
            slideWidth: 285,
            infiniteLoop: true,
            moveSlides: 1,
            minSlides: 4,      // 최소 노출 개수
            maxSlides: 4,      // 최대 노출 개수
            auto: false,
        });
        $('.best_brand .btn_product_bb_prev').click(function () {
            var current = BsetSlider.getCurrentSlide();

            BsetSlider.goToPrevSlide(current) - 1;
            if(current<=0){
                current=${fn:length(brand_list)};
            }else{
                current = (current+1)-1;
            }
            $(this).parents("div").find("em").html(current);
        });
        $('.best_brand .btn_product_bb_next').click(function () {
            var current = BsetSlider.getCurrentSlide();

            BsetSlider.goToNextSlide(current) + 1;

            if(current+1==${fn:length(brand_list)}){
                current = 1;
            }else{
                current=(current+1)+1;;
            }
            $(this).parents("div").find("em").html(current);
        });

		/*var $container = $(".magazine_list_area");

		$container.imagesLoaded(function () {
			$container.masonry({
				itemSelector: '.maga_box',
			});
    	});*/

        //1번째 카테고리
    	var ctgNo1 = $('.maga_category').find('a:eq(1)').attr("id");
    	magazineList(ctgNo1);
});
var magazineList = function(ctgNo){

			var url = '/front/search/category-ajax',dfd = jQuery.Deferred();
			var allflag = "";
			if(arguments[1]){
			    allflag =arguments[1];
			}
            var param = {ctgNo : ctgNo,searchAll : allflag};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                var template =
								'<div class="maga_box" style="position: absolute; left: 0px; top: 20px;">'+
								'	<a href="javascript:goods_detail(\'{{goodsNo}}\');">'+
								'		<img src="${_IMAGE_DOMAIN}{{goodsDispImgM}}" alt="{{goodsNm}}" title="{{goodsNm}}">'+
								'	</a>'+
								'	<div class="text_area">'+
								'		<p class="tit"><a href="javascript:goods_detail(\'{{goodsNo}}\');">{{goodsNm}}</a></p>'+
								'		<p class="text"><a href="javascript:goods_detail(\'{{goodsNo}}\');">{{prWords}}</a></p>'+
								'       <p class="tag">';
				var template_1 ='		</p>'+
                                    '	</div>'+
                                    '</div>',
                magazineList = new Dmall.Template(template),
                magazineList_1 = new Dmall.Template(template_1),

                tr = '';

                jQuery.each(result.resultList, function(idx, obj) {
                	if(obj.prWords!=null && obj.prWords!=''){
					obj.prWords =  obj.prWords.replaceAll('\n', '<br>');
					}else{
					obj.prWords="";
					}
                    tr += magazineList.render(obj);
                    var seoSearchWord = "";
                    if(obj.seoSearchWord!=null && obj.seoSearchWord!=''){
				 		seoSearchWord = obj.seoSearchWord.split(',');
					 }
				 	for(var i=0;i<seoSearchWord.length;i++){
						tr +='<a href="javascript:;">#'+seoSearchWord[i]+'</a>';
				 	}
				 	tr += magazineList_1.render(obj);


                });

                jQuery('.magazine_list_area').html(tr).each(function(){
                    $('.magazine_list_area').masonry('reloadItems');
                });
				dfd.resolve(result.resultList);

				$(".maga_category a").removeClass("active");
                $("#"+ctgNo).addClass("active");


                var $container = $(".magazine_list_area");
                $container.imagesLoaded(function () {
                    $container.masonry({
                        itemSelector: '.maga_box'
                    });
                });


            });
            return dfd.promise();
    }
</script>
<script type="text/javascript" src="/front/js/imagesloaded.pkgd.min.js"></script>
</t:putAttribute>
<t:putAttribute name="content">


	<input type="hidden" name="searchAll" value="all">
	<input type="hidden" name="magazineCtgNo" value="${param.ctgNo}">


    <div class="magazine_outline_list"> <!-- 매거진 목록 div 추가 -->
		<div class="category_middle">
			<h2 class="mega_tit"><img src="${_SKIN_IMG_PATH}/magazine/dma_title.png" alt="D 매거진"></h2>

			<div class="maga_category">
				<a href="javascript:;" onclick="javascript:magazineList('${param.ctgNo}','all'); return false;" id="${param.ctgNo}">전체</a>
				<c:forEach var="ctgList" items="${lnb_info.get('0')}" varStatus="status"> <!-- 1Depth -->
                <c:if test="${ctgList.ctgNo eq so.ctgNo || ctgList.upCtgNo eq so.ctgNo}">
                    <c:forEach var="ctgList_1" items="${lnb_info.get(ctgList.ctgNo)}" varStatus="status"> <!-- 2Depth -->
                    	<a href="javascript:;" onclick="javascript:magazineList('${ctgList_1.ctgNo}'); return false;" id="${ctgList_1.ctgNo}">${ctgList_1.ctgNm}</a>
                     </c:forEach>
                </c:if>
            </c:forEach>
			</div>

			<!-- 목록 영역 -->
			<div class="magazine_list_area" data-masonry="{ &quot;columnWidth&quot;: 375, &quot;itemSelector&quot;: &quot;.maga_box&quot;, &quot;gutter&quot;: 28 }" style="position: relative; height: 545px;">

				<%--<c:forEach var="goodsList" items="${resultListModel.resultList}" varStatus="status">
				<div class="maga_box" style="position: absolute; left: 0px; top: 20px;">
					<a href="javascript:goods_detail('${goodsList.goodsNo}');">
						<img src="${goodsList.goodsDispImgM}" alt="${goodsList.goodsNm}" title="${goodsList.goodsNm}">
					</a>
					<div class="text_area">
						<p class="tit"><a href="javascript:goods_detail('${goodsList.goodsNo}');">${goodsList.goodsNm}</a></p>
						<p class="text"><a href="javascript:goods_detail('${goodsList.goodsNo}');">
						<c:set value="${goodsList.prWords}" var="data"/>
						<c:set value="${fn:replace(data, cn, br)}" var="prWords"/>
						${prWords}
						</a></p>
						<p class="tag">
							<c:set var="seoSearchWord" value="${fn:split(goodsList.seoSearchWord,',')}"/>
							<c:if test="${fn:length(seoSearchWord) gt 1}">
							<c:forEach var="hashTag" items="${seoSearchWord}" varStatus="g">
								<a href="javascript:;">#${hashTag}</a>
							</c:forEach>
							</c:if>

						</p>
					</div>
				</div>
				</c:forEach>--%>
 			</div>
			<!--// 목록 영역 -->
		</div>
	</div>
    </t:putAttribute>
</t:insertDefinition>