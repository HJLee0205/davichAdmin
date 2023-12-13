<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="du" class="dmall.framework.common.util.DateUtil"></jsp:useBean>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
   
   <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
		<li>
			<a href="javascript:detailPromotion('${resultModel.prmtNo}');">			
				<img src="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${resultModel.prmtMobileBannerImgPath}&id1=${resultModel.prmtMobileBannerImg}" onerror="this.src='../img/promotion/promotion_ing01.jpg'">
				<div class="text">
					<em>${resultModel.prmtNm}</em>
					<p>${resultModel.applyStartDttm.substring(0,10)} ~ ${resultModel.applyEndDttm.substring(0,10)}</p>
				</div>
			</a>
		</li>
   </c:forEach>

