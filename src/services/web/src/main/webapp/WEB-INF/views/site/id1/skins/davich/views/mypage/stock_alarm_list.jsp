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
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 재입고 알림</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){

        /* 페이징 */
        $('#div_id_paging').grid(jQuery('#form_id_search'));

        /* 전체선택 */
        $("#allCheck").click(function(){
            //만약 전체 선택 체크박스가 체크된상태일경우
            StockAlarmUtil.allCheckBox();
        })
        /* 개별 삭제 */
        $('.btn_refund').on('click', function(e) {
             e.preventDefault();
             e.stopPropagation();
             StockAlarmUtil.reinwareAlarmNo = $(this).parents('tr').attr('data-alarm-no');
             Dmall.LayerUtil.confirm('삭제하시겠습니까?', StockAlarmDeleteUtil.directDeleteProc);
        });
        /* 선택 삭제 */
        $('#btn_select_del').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            StockAlarmDeleteUtil.checkDelete();
        });
    });


    StockAlarmUtil = {
        reinwareAlarmNo : '',
        allCheck : function() {
            $('#allCheck').trigger('click');
        },
        allCheckBox : function() {
            if ($("#allCheck").prop("checked")) {
                //해당화면에 전체 checkbox들을 체크해준다a
                $("input[name=reinwareAlarmNo]").prop("checked", true);
                // 전체선택 체크박스가 해제된 경우
            } else {
                //해당화면에 모든 checkbox들의 체크를해제시킨다.
                $("input[name=reinwareAlarmNo]").prop("checked", false);
            }
        }
    }

    StockAlarmDeleteUtil = {
        deleteUrl : '/front/member/restock-notify-delete',
        completeDeleteMsg : function() { // 삭제 완료후 페이지 새로고침
            Dmall.LayerUtil.alert('재입고알림이 삭제 되었습니다.').done(function() {
                location.reload();
            });
        },
        checkDelete : function() { //선택상품 삭제
            var chkItem = $('input:checkbox[name=reinwareAlarmNo]:checked').length;
            if (chkItem == 0) {
                Dmall.LayerUtil.alert('삭제할 재입고알림을 선택해 주십시요');
                return;
            }
            Dmall.LayerUtil.confirm('삭제하시겠습니까?', StockAlarmDeleteUtil.deleteProc);
        },
        deleteProc : function() { //삭제 진행
            var param = {},key;
            var restockNotifyList = fn_selectedList();
            jQuery.each(restockNotifyList, function(i, o) {
                key = 'list[' + i + '].reinwareAlarmNo';
                param[key] = o;
            });
            Dmall.AjaxUtil.getJSON(StockAlarmDeleteUtil.deleteUrl, param, function(result) {
                if (result.success) {
                    StockAlarmDeleteUtil.completeDeleteMsg();
                }
            });
        },
        directDeleteProc : function() { //개별 삭제 진행
            var url = '/front/member/restock-notify-delete';
            var param = {
                'list[0].reinwareAlarmNo' : StockAlarmUtil.reinwareAlarmNo
            };
            Dmall.AjaxUtil.getJSON(StockAlarmDeleteUtil.deleteUrl, param, function(result) {
                if (result.success) {
                    StockAlarmDeleteUtil.completeDeleteMsg();
                }
            });
        }
    }

    // 그리드에서 선택된 재입고 알림번호 취득
    function fn_selectedList() {
        var selected = [];
        $('#id_alarm_List input:checked').each(function() {
            selected.push($(this).val());
        });
        return selected;
    }
    </script>
    
    </t:putAttribute>    
    <t:putAttribute name="content">
    
    <!--- 마이페이지 메인  --->
  <!--  <div class="contents fixwid">
        - category header 카테고리 location과 동일 -
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 관심상품 <span>&gt;</span>재입고 알림
            </div>
        </div> -->
         <!--- category header --->
	<div id="category_header">
		<div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>마이페이지</li>
				<li>재입고알림</li>
			</ul>
			<!-- <ul class="category_menu">
				<li><a href="#">홈</a></li>
				<li>
					<a href="#none" class="btn_category_2depth">안경테<i></i></a>
					<ul class="category_2depth" style="display: none;">
						<li class="top"></li>
						<li><a href="#">Sun</a></li>
						<li><a href="#">Optical</a></li>
						<li><a href="#">Kids</a></li>
						<li><a href="#">Personal</a></li>
						<li><a href="#">Celebrity</a></li>
						<li><a href="#">Lookbook</a></li>
					</ul>
				</li>
				<li>
					<a href="#none" class="btn_category_3depth">Daon<i></i></a>
					<ul class="category_3depth" style="display: none;">
						<li class="top"></li>
						<li><a href="#">Sun</a></li>
						<li><a href="#">Optical</a></li>
						<li><a href="#">Kids</a></li>
						<li><a href="#">Personal</a></li>
						<li><a href="#">Celebrity</a></li>
						<li><a href="#">Lookbook</a></li>
					</ul>
				</li>
			</ul> -->
		</div>
		<!-- <div class="location_btn_area">
			<button type="button" class="btn_recomm"><i></i>렌즈추천</button>
			<button type="button" class="btn_share">공유</button>
			<!-- 레이어 공유하기 선택 ->
			<div class="layer_share" style="display: none;">
				<div class="head">
					공유하기
					<button type="button" class="btn_close_share"></button>
				</div>
				<div class="btn">
					<button type="button" class="btn_sharea_fbook">페이스북</button>
					<button type="button" class="btn_sharea_kakao">카카오스토리</button>
				</div>
			</div>
			<!--// 레이어 공유하기 선택 ->
		</div> -->
    </div>
	    <div class="mypage_middle">	
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

		<!-- content -->
		 <div id="mypage_content">
		 
            <!--- 마이페이지 탑 --->
            <%@ include file="include/mypage_top_menu.jsp" %>
			
			<div class="mypage_body">
				<h3 class="my_tit">재입고알림</h3>
				<div class="order_cancel_info">					
					<span class="icon_purpose">품절상품 재입고시 신속하게 안내해 드리겠습니다.</span>
				</div>
				<table class="tCart_Board ">
					<caption>
						<h1 class="blind">품절상품 재입고 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:39px">
						<col style="width:102px">
						<col style="width:">
						<col style="width:120px">
						<col style="width:110px">
						<col style="width:110px">
					</colgroup>
					<thead>
						<tr>
							
							<th>
                                <div class="mypage_check">
                                    <label>
                                        <input type="checkbox" name="freeboard_checkbox" id="allCheck">
                                        <span></span>
                                    </label>
                                </div>
                            </th>
							<th></th>
							<th>상품정보</th>
							<th>알람신청일시</th>
							<th>알람통보일시</th>
							<th>처리</th>
						</tr>
					</thead>
					
					 <tbody id="id_alarm_List">
	                     <c:choose> 
	                       	 <c:when test="${resultListModel.resultList ne null}">
                           	    <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
								<tr data-alarm-no="${resultModel.reinwareAlarmNo}">
									<td class="noline">													
									    <input type="checkbox" class="order_check" name="reinwareAlarmNo" id="reinwareAlarmNo_${status.index}" value="${resultModel.reinwareAlarmNo}">										
										<label for="reinwareAlarmNo_${status.index}"><span></span></label>  										
									</td>
									
									
									<td class="noline">
										<div class="cart_img">
											  <img src="${resultModel.goodsImg}" >  
										</div>
									</td>
									<td class="textL">
										<a href="/front/goods/goods-detail?goodsNo=${resultModel.goodsNo}">${resultModel.goodsNm}</a>
									</td>
		                            <td>${resultModel.strRegDttm}</td>
		                            <td>${resultModel.strAlarmDttm}</td>
									<td>
										<button type="button" class="btn_refund">삭제</button><br>
									</td>							
								</tr>	
                                </c:forEach>
	                        </c:when>
	                        <c:otherwise>
	                            <tr>
	                                <td colspan="6">등록된 재입고 알림이 없습니다.</td>
	                            </tr>
	                        </c:otherwise>
	                    </c:choose>
                    </tbody> 
				</table>
				
				<div class="btn_left_area">
					<button type="button" id="btn_select_del" class="btn_select_del">선택상품삭제</button>
				</div> 
				<!-- pageing -->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
				<!--// pageing -->
			</div>
		</div>		
		<!--// content -->
	</div>
    </t:putAttribute>
</t:insertDefinition>