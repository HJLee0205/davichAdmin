<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${resultModel.data.prmtNm}</t:putAttribute>
    
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    /* function otherPromotion(){
        var prmNo = $('#otherPromotion option:selected').val();
        if(prmNo != ''){
            $("#prmtNo").val($('#otherPromotion option:selected').val());
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('/front/promotion/promotion-detail', param);
        }
    } */
    $(document).ready(function(){
        //$('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
        
        $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
          	var prmtNo = $('#prmtNo').val();
          	var prmtStatusCd = $('#prmtStatusCd').val();
     		var url = '${_MOBILE_PATH}/front/promotion/ajax-promotion?prmtNo='+prmtNo+'&prmtStatusCd='+prmtStatusCd+'&'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if('${so.totalPageCount}'==pageIndex){
		        	$('#div_id_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('.product_list_typeB').append(result);
	        })
         });
        
    });
    </script>
    </t:putAttribute>
    
    <t:putAttribute name="content">
    <!--- contents --->
    <div class="contents">
    	
    	<form:form id="form_id_search" commandName="so" >
        <form:hidden path="page" id="page"/>
        <form:hidden path="prmtNo" id="prmtNo"/>
        <form:hidden path="prmtStatusCd" id="prmtStatusCd" />
    	
   		<div class="promotion_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			기획전
		</div>
		<div class="promotion_content">
			<div class="promotion_detail_banner">
				<%-- <img src="http://www.davichmarket.com/image/image-view?type=PROMOTION&path=${resultModel.prmtMobileBannerImgPath}&id1=${resultModel.data.prmtMobileBannerImg}" title="${resultModel.data.prmtNm}" onerror="this.src='../img/promotion/promotion_ing01.jpg'"> --%>
				${resultModel.data.prmtContentHtml}
			</div>
		</div>		
		<h2 class="promotion_stit">
			<span>기획전 상품</span>
		</h2>
		<ul class="product_list_typeB">
		
			<c:choose>
            <c:when test="${resultListModel.resultList ne null}">
                <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                <li>
					<div class="product_list_typeB_image_area">
						<a href="javascript:goods_detail('${resultModel.goodsNo}');">
							<img src="${resultModel.goodsDispImgE}" alt="${resultModel.goodsNm}" onerror="this.src='../img/product/product_300_300.gif'">
						</a>	
					</div>
					<div class="product_list_typeB_title_area">
						<div class="goods_title">
							<a href="javascript:goods_detail('${resultModel.goodsNo}');">
								${resultModel.goodsNm}
							</a>
						</div>
						<div class="product_info">
							${resultModel.prWords}
						</div>
						<div class="product_list_typeB_price_info">
							<span class="real_price">\ <fmt:formatNumber value="${resultModel.salePrice}"/></span>
						</div>					
						<div class="label_area">
							${resultModel.iconImgs}
						</div>
					</div>			
				</li>
				</c:forEach>
            </c:when>
            <c:otherwise>
                    <p style="text-align: center;">등록된 상품이 없습니다.</p>
            </c:otherwise>
            </c:choose>
            
		</ul>

		<!--- 페이징 --->
		<div class="tPages" id="div_id_paging">
            <grid:paging resultListModel="${resultListModel}" />
        </div>
		<!---// 페이징 --->		
    	</form:form>
    </div>
    </t:putAttribute>
</t:insertDefinition>