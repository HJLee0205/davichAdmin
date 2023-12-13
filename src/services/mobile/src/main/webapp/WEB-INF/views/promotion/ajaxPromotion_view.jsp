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
