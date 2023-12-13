<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
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
<t:insertDefinition name="goodsDavichLayout">
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="title">${goodsInfo.data.goodsNm} :: 다비치마켓</t:putAttribute>
	<t:putAttribute name="content">
    <div class="middle_area"> <!-- 매거진 상세보기 div 추가 -->
		<div class="category_middle">
			<div class="product_head">
				<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
				<img src="${_SKIN_IMG_PATH}/magazine/dma_title.png" alt="D 매거진" class="zine_h2">
			</div>

			<h3 class="mega_stit">
				<c:forEach var="navigationList" items="${navigation}" varStatus="status">
					<c:if test="${status.last}">
						${navigationList.ctgNm}
					</c:if>
			</c:forEach>
			</h3>

			<div class="maga_sub_tit">
				<p class="tit">${goodsInfo.data.goodsNm}</p>
				<span class="date">${goodsInfo.data.regDttm}</span>
				<%--<p class="text">${goodsInfo.data.prWords }</p>--%>
			</div>

			<div class="maga_view_area">
				<c:if test="${!empty goodsContentVO.mobileContent}">
				${goodsContentVO.mobileContent}
				</c:if>
				<c:if test="${empty goodsContentVO.mobileContent}">
				${goodsContentVO.content}
				</c:if>
			</div>
			 <c:if test="${goodsInfo.data.relateGoodsApplyTypeCd ne '3' &&  goodsInfo.data.relateGoodsApplyTypeCd ne null}">
                <c:if test="${!empty goodsInfo.data.relateGoodsList}">
			<div class="maga_product_tit">
				관련제품
			</div>

			<!-- 상품리스트 영역 -->
			<div class="product_list_area">
				<ul class="product_list_typeB">
					<data:goodsList value="${goodsInfo.data.relateGoodsList}" displayTypeCd="01" headYn="N" iconYn="Y" topYn="N"/>

				</ul>
			</div>
			<!--// 상품리스트 영역 -->
 				</c:if>
			</c:if>
			<div class="btn_mage_area">
				<button type="button" class="btn_maga_list" onclick="javascript:move_category('747');">목록</button>
			</div>
		</div>

	</div>

	</t:putAttribute>
	<t:putAttribute name="script">
    <script>

		/* 쿠폰 건별 발급 */
		function issueCoupon(couponNo) {

			var url = '${_MOBILE_PATH}/front/coupon/coupon-issue';
			var param = {couponNo: couponNo};

			Dmall.AjaxUtil.getJSON(url, param, function (result) {
				 if(result.success) {
						Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
							//확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
							function() {
								location.href= "${_MOBILE_PATH}/front/coupon/coupon-list";
							},'','','','닫기','마이페이지'
						);
				}
			});
		}
        $(document).ready(function(){

        });
    </script>
	</t:putAttribute>
</t:insertDefinition>