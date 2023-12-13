<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
$(document).ready(function(){
    //검색버튼 클릭
    $('.btn_category_search').on('click',function(){
        category_search();
    });
    //검색초기화버튼 클릭
    $('.btn_category_search_reset').on('click',function(){
        var checkObj = $("input[type='checkbox'");
        checkObj.prop("checked",false);
    });

    $('#brand_check_all').bind('click',function (){
        if($('#brand_check_all').is(':checked')) {
            $('input[name=searchBrands]:checkbox').each(function(){
               $(this).prop('checked', true);
            });
        }else{
            $('input[name=searchBrands]:checkbox').each(function(){
                $(this).prop('checked', false);
             });
        }
    });
    
});
</script>

<c:if test="${so.ctgLvl =='1'}">
<!-- 2depth category -->
<div class="category_head">
	<select id="selCategoryHead">
		<option value="${so.upCtgNo}">전체</option>
    	<c:forEach var="ctgList" items="${lnb_info.get('0')}" varStatus="status">
                <c:if test="${ctgList.ctgNo eq so.ctgNo}">
                    <c:forEach var="ctgList_1" items="${lnb_info.get(ctgList.ctgNo)}" varStatus="status">
						<option value="${ctgList_1.ctgNo}">${ctgList_1.ctgNm}</option>
					</c:forEach>
				</c:if>
    	</c:forEach>
	</select>
</div>
<!--// 2depth category -->
</c:if>
<c:if test="${so.ctgLvl =='2'}">
<!-- 3depth category -->
<div class="category_head">
	<select id="selCategoryHead">
		<option value="${so.upCtgNo}">전체</option>
    	<c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status" end="7">
			<option value="${ctgList.ctgNo}">${ctgList.ctgNm}</option>
    	</c:forEach>
	</select>
</div>
<!--// 3depth category -->
</c:if>
<c:if test="${so.ctgLvl =='3'}">
    <div class="category_middle">
        <!-- 4depth category -->
        <ul class="gategory_menu">
	    	<c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status">
				<c:if test="${status.index == 0}">
					<li><a href="javascript:move_category('${so.upCtgNo}');">전체</a></li>
				</c:if>
				<li><a href="javascript:move_category('${ctgList.ctgNo}');">${ctgList.ctgNm}</a></li>
	    	</c:forEach>
		</ul>
        <!--// 4depth category -->
    </div>
</c:if>