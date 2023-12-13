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
	<t:putAttribute name="title">다비치마켓 :: 주문/배송조회</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script type="text/javascript">
var totalFileLength=0;
    $(document).ready(function(){
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        //달력
        $(function() {
            $( ".datepicker" ).datepicker();
        });
        //검색
        $('.btn_form').on('click', function() {
            if($("#ordDayS").val() == '' || $("#ordDayE").val() == '') {
                Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                return;
            }
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('/front/order/order-list', param);
        });
        
        /* 상품문의수정 팝업 닫기*/
        $('#btn_question_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_question_write');
        });
        
     	// 상품평수정 팝업 닫기
        $('#btn_review_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_review_write');
        });
        
        /*상품문의 등록*/
        $('#btn_question_confirm').on('click', function() {
        	var url = '/front/question/question-insert';
            var param = jQuery('#form_id_question').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerPopupUtil.close('popup_question_write');   //수정후 레이어팝업 닫기
                    Dmall.LayerUtil.confirm("상품문의가 등록되었습니다.<br>답변내용은 마이페이지 > 상품문의 메뉴에서 확인해 주세요.",
                       		function() {
        		            	location.href="/front/customer/inquiry-list?customerCd=question"
                       		}
        	               	, function() {
        	        			return false;
        	        		},'','','닫기','작성내용 보기'
                       	);
                }
            });
        });
        
     	// 상품평 등록
        $('#btn_review_cofirm').on('click', function() {
            var url = '/front/review/review-insert';
            var param = jQuery('#form_id_review').serialize();
            /* var score = $('div.list_selectBox span').first().data('value'); */
            var score = $('.selected').children('span').attr('value');

            if(score != null && score != ''){
            	$('input[name=score]', '#form_id_review').val(score);
            }

            if (Dmall.FileUpload.checkFileSize('form_id_review')) {
                $('#form_id_review').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        //Dmall.validate.viewExceptionMessage(result, 'form_id_review');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('popup_review_write');   //수정후 레이어팝업 닫기
                            var confirmMsg = "상품후기가 등록되었습니다.";
                            var pointPvdYn = "${pointPvdYn}";
                            if(pointPvdYn == 'Y') confirmMsg += "<br>(마켓포인트 ${buyEplgWritePoint }점 적립완료)";
                            Dmall.LayerUtil.confirm(confirmMsg,
                               		function() {
                		            	location.href="/front/customer/inquiry-list?customerCd=review"
                               		}
                	               	, function() {
                	        			return false;
                	        		},'','','닫기','작성내용 보기'
                               	);
                        }
                    }
                });
            }
        });
     	
      	//이미지파일 변경
        $('#input_id_image').on('change', function(e) {
            if($("#imgOldYn").val()=="Y"){
                Dmall.LayerUtil.alert("등록된 이미지 파일을 먼저 삭제하여 주세요.");
                $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                $("#input_id_image").val("");
    			$('#filename').val("");
    			return false;
            }else{

            	var fileSize = $(this)[0].files[0].size;
                var maxSize = <spring:eval expression="@front['system.review.file.size']"/>;
                
                if(fileSize > maxSize){
                	var maxSize_MB = maxSize / (1024*1024);
                	Dmall.LayerUtil.alert('파일 용량 '+maxSize_MB.toFixed(2)+' Mb 이내로 등록해 주세요.','','');
                	$("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
        			$("#input_id_image").val("");
        			$('#filename').val("");
        			return false;
                }
                
                var ext = jQuery(this).val().split('.').pop().toLowerCase();
        		if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
        			Dmall.LayerUtil.alert('gif,png,jpg,jpeg 파일만 업로드 할수 있습니다.','','');
        			$("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
        			$("#input_id_image").val("");
        			$('#filename').val("");
        			return false;
        		}
        		$("#imgYn").val("Y");

                var fileNm = e.target.value.substring(e.target.value.lastIndexOf('\\') + 1);
                totalFileLength = totalFileLength+1;

                if(totalFileLength>1){
                    Dmall.LayerUtil.alert('첨부파일는 최대 1개까지 등록 가능합니다.');
                    totalFileLength = totalFileLength-1;
                    $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                    $("#input_id_image").val("");
                    $('#filename').val("");
                    return false;
                }
            }
        });

      	var refrequest = '${param.refrequest}';
		if(refrequest=='Y'){
			$("ul.my_shopping_menu li[rel=view02]").trigger('click');
		}

	});
    
    function open_question_pop(goodsNo){
		$('#form_id_question #mode').val("insert");
        $('#form_id_question #goodsNo').val(goodsNo);
        $('#form_id_question #title').val("");
		$('#form_id_question #content').val("");
		
        Dmall.LayerPopupUtil.open($('#popup_question_write'));
	}
	
	function open_review_pop(goodsNo){
		$('#form_id_review #mode').val('insert');
		$('#form_id_review #goodsNo').val(goodsNo);
        $('#form_id_review #title').val('');
        $('#form_id_review #content').val('');
        $('#form_id_review #filename').val('');
        $('#form_id_review #input_id_image').val('');
        $('#form_id_review #content').val('');
        $('#form_id_review #imgOldYn').val('');
        $('#form_id_review #span_imgFile').html('');
        $('#form_id_review #span_imgFile').hide();
        $("#form_id_review input[name='score']:radio[value='5']").prop('checked',true);
		
        Dmall.LayerPopupUtil.open($('#popup_review_write'));
	}
	
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->

    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="mypage_middle">	

            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div id="mypage_content">
	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
            
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <form:hidden path="period" id="period" />
	            
				<div class="mypage_body">
					<h3 class="my_tit">주문배송조회</h3>
					<div class="filter_datepicker date_select_area">
						<input type="text" class="date datepicker" id="ordDayS" name="ordDayS" value="${so.ordDayS}">
						~
						<input type="text" class="date datepicker" id="ordDayE" name="ordDayE" value="${so.ordDayE}">
						<span class="btn_date_area">
							<button type="button" style="display:none"></button>
							<button type="button" <c:if test="${so.period eq '1' }">class="active"</c:if> >15일</button>
							<button type="button" <c:if test="${so.period eq '2' }">class="active"</c:if> >1개월</button>
							<button type="button" <c:if test="${so.period eq '3' }">class="active"</c:if> >3개월</button>
							<button type="button" <c:if test="${so.period eq '4' }">class="active"</c:if> >6개월</button>
							<button type="button" <c:if test="${so.period eq '5' }">class="active"</c:if> >1년</button>
						</span>
						<button type="button" class="btn_form">조회하기</button>
					</div>
					<table class="tCart_Board Mypage">
						<caption>
							<h1 class="blind">주문배송조회 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:140px">
							<col style="width:102px">
							<col style="width:">
							<col style="width:120px">
							<col style="width:110px">
							<col style="width:110px">
						</colgroup>
						<thead>
							<tr>
								<th>주문일자/주문번호</th>
								<th colspan="2">상품/옵션/수량</th>
								<th>주문금액</th>
								<th>상태</th>
								<th>처리</th>
							</tr>
						</thead>
						<tbody>
		                    <c:choose>
		                        <c:when test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 0}">
		                        <c:set var="grpId" value=""/>
		                        <c:set var="preGrpId" value=""/>
		                        <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
		                            <c:set var="grpId" value="${resultList.orderInfoVO.ordNo}"/>
		                            <c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
									<tr class="end_line">
		                                <c:if test="${grpId ne preGrpId }">
		                                <td rowspan="${fn:length(resultList.orderGoodsVO)}" class="textL">
											<span class="order_date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/></span>
											<a href="javascript:;" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');" class="order_no">[${resultList.orderInfoVO.ordNo}]</a>
											<c:if test="${resultList.orderInfoVO.orgOrdNo eq null}">
												<button type="button" class="btn_order_detail" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">주문상세내역</button>
											</c:if>
											<c:if test="${resultList.orderInfoVO.orgOrdNo ne null}">
												<button type="button" class="btn_order_detail" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">교환</button>
                                            </c:if>
										</td>
										</c:if>
										<td class="noline">
											<div class="cart_img">
												<img src="${_IMAGE_DOMAIN}${goodsList.imgPath}">
											</div>
										</td>
										<td class="textL vaT">
										
											<a href="/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}
		                                        <c:if test="${empty goodsList.itemNm}">
														&nbsp;&nbsp; ${goodsList.ordQtt} 개
		                                        </c:if>
											</a>
	                                        <c:if test="${!empty goodsList.itemNm}">
	                                        	<p class="option"><c:out value="${goodsList.itemNm}"/> ${goodsList.ordQtt} 개</p>
	                                        </c:if>
					                        <c:forEach var="optionList" items="${goodsList.goodsAddOptList}" varStatus="status">
					                            <p class="option_s">
					                                ${optionList.addOptNm} (
					                                <c:choose>
					                                    <c:when test="${optionList.addOptAmtChgCd eq '1'}">
					                                    +
					                                    </c:when>
					                                    <c:otherwise>

					                                    </c:otherwise>
					                                </c:choose>
					                                <fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
					                                           ${optionList.addOptBuyQtt} 개
					                            </p>
					                        </c:forEach>

											<!-- 사은품추가 2018-09-27  사은품이 없을때 전체가 안나오게 해주세요. 사은품상세이름에는 대괄호없애주세요-->
											<c:if test="${goodsList.freebieNm ne null}">
												<p class="option_s">사은품 : <c:out value="${goodsList.freebieNm}"/></p>
											</c:if>

											<!-- //사은품추가 2018-09-27 -->
										</td>
										
		                                <c:if test="${grpId ne preGrpId }">
											<td rowspan="${fn:length(resultList.orderGoodsVO)}">
												<span class="price"><fmt:formatNumber value="${resultList.orderInfoVO.orgPaymentAmt}" type="number"/></span>원
											</td>
		                                </c:if>
										<td>
											<c:if test="${goodsList.rsvOnlyYn eq 'Y'}">
                                                <span class="label_reservation">예약전용</span>
                                            </c:if>
                                            <c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
    											${goodsList.ordDtlStatusNm}
                                                <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
                                                    <button type="button" class="btn_shipping" onclick="trackingDelivery('${goodsList.rlsCourierCd}','${goodsList.rlsInvoiceNo}')">배송조회</button>
                                                </c:if>
                                            </c:if>
										</td>
										<td>
                                            <c:if test="${goodsList.rsvOnlyYn eq 'Y'}">
                                                <span class="label_reservation">예약전용</span>
                                            </c:if>
                                            <c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
		                                    <%--<c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
		                                     	<button type="button" class="btn_go_cancel" onclick="order_cancel_pop('${resultList.orderInfoVO.ordNo}');">주문취소</button>
		                                    </c:if>--%>
	                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
												<c:if test="${goodsList.ordQtt > goodsList.claimQtt}">
												<button type="button" class="btn_ordered" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}')"onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}','mypage')">구매확정</button><br>
												</c:if>
	                                        </c:if>
	                                        <%--<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
												<button type="button" class="btn_refund" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">교환신청</button><br>
												<button type="button" class="btn_refund" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품신청</button>
	                                        </c:if>--%>
	                                        <c:if test="${goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
	                                            <button type="button" class="btn_refund" onclick="open_review_pop('${goodsList.goodsNo}');">상품평쓰기</button>
	                                        </c:if>
	                                        <button type="button" class="btn_refund" onclick="open_question_pop('${goodsList.goodsNo}');">문의하기</button>
                                            </c:if>
										</td>
									</tr>
		                            <c:set var="preGrpId" value="${grpId}"/>
									</c:forEach>
		                        </c:forEach>
		                        </c:when>
		                        <c:otherwise>
		                            <tr>
		                                <td colspan="8">조회된 데이터가 없습니다.</td>
		                            </tr>
		                        </c:otherwise>
		                    </c:choose>							
						</tbody>
					</table>
					<!-- pageing -->
					<div class="tPages" id="div_id_paging"> 
	                    <grid:paging resultListModel="${order_list}" />
					</div>
					<!--// pageing -->
					
	                </form:form>
				</div>
			</div>		
			<!--// content -->	            
    </div>
    <!-- 취소팝업 -->
    <div id="div_order_cancel" style="display: none;">
        <div class="popup_my_order_cancel" id ="popup_my_order_cancel"></div>
    </div>
    <!-- 교환팝업 -->
    <div id="div_order_exchange" style="display: none;">
        <div class="popup_my_order_replace" id ="popup_my_order_replace"></div>
    </div>
    <!-- 환불팝업 -->
    <div id="div_order_refund" style="display: none;">
        <div class="popup_my_order_refund" id ="popup_my_order_refund"></div>
    </div>
    <%--- 문의팝업 ---%>
	<div id="popup_question_write" style="display: none;">
    <div class="popup_header">
        <h1 class="popup_tit">상품문의</h1>
        <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
    </div>
    <div class="popup_content">
        <form id="form_id_question" action="/front/question/question-update">
            <input type="hidden" name="mode" id="mode" value="insert"/>
            <input type="hidden" name="bbsId" id="bbsId" value="question"/>
            <input type="hidden" name="lettNo" id="lettNo" value=""/>
            <input type="hidden" name="goodsNo" id="goodsNo" value=""/>
            <input type="hidden" name="replyEmailRecvYn" id="replyEmailRecvYn" value=""/>
            <span class="">* 고객님의 질문에 성심성의껏 답변드릴 것을 약속드립니다.</span>
            <table class="tProduct_Insert" style="margin:5px 0 2px">
                <caption>
                    <h1 class="blind">글쓰기 입력 테이블입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:20%">
                    <col style="width:">
                </colgroup>
                <tbody>
                <tr>
                    <th>제목</th>
                    <td><input type="text" style="width:100%" id="title" name="title"></td>
                </tr>
                <tr>
                    <th style="vertical-align:top">내용</th>
                    <td><textarea style="height:105px;width:100%" placeholder="내용 입력" id="content" name="content"></textarea></td>
                </tr>
                <!-- <tr>
                    <th rowspan="2" style="vertical-align:top">이메일</th>
                    <td>
                        <div class="qna_check">
                            <label>
                                <input type="checkbox" name="emailRecvYn" id ="emailRecvYn">
                                <span></span>
                            </label>
                            <label for="emailRecvYn">답변글을 이메일로 받기</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="text" id="email" name="email" style="width:100%" placeholder="새로 입력">
                    </td>
                </tr> -->
                </tbody>
            </table>
        </form>
        <span class="product_faq_table_bottom">* 답변은 상품상세 또는 마이페이지 > 상품문의에서 확인 하실 수 있습니다.</span>
        <div class="popup_btn_area">
            <button type="button" class="btn_review_ok" id="btn_question_confirm">등록</button>
            <button type="button" class="btn_review_cancel" id="btn_question_cancel">취소</button>
        </div>
    </div>
</div>
	<%---// 문의팝업 ---%>
	<!--- popup 상품평쓰기 --->
<div id="popup_review_write" style="display: none;">
    <div class="popup_header">
        <h1 class="popup_tit">상품평쓰기</h1>
        <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
    </div>
    <div class="popup_content">
        <form:form id="form_id_review">
        <input type="hidden" name="mode" id="mode" value="insert"/>
        <input type="hidden" name="bbsId" id="bbsId" value="review"/>
        <input type="hidden" name="lettNo" id="lettNo" value=""/>
        <input type="hidden" name="goodsNo" id="goodsNo" value=""/>
        <table class="tProduct_Insert">
            <caption>
                <h1 class="blind">상품평가 입력 테이블입니다.</h1>
            </caption>
            <colgroup>
                <col style="width:20%">
                <col style="width:20%">
                <col style="width:20%">
                <col style="width:20%">
                <col style="width:20%">
            </colgroup>
            <tbody>
                <tr>
                    <td class="star_check">
                        <input type="radio" class="order_radio" id="star05" name="score" value="5">
                        <label for="star05">
                            <span></span>
                            <div class="star_groups" title="별점평가 별5개" style="margin-top:6px">
                                <img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
                            </div>
                        </label>
                    </td>

                    <td class="star_check">
                        <input type="radio" class="order_radio" id="star04" name="score" value="4">
                        <label for="star04">
                            <span></span>
                            <div class="star_groups" title="별점평가 별4개" style="margin-top:6px">
                                <img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
                            </div>
                        </label>
                    </td>
                    <td class="star_check">
                        <input type="radio" class="order_radio" id="star03" name="score" value="3">
                        <label for="star03">
                            <span></span>
                            <div class="star_groups" title="별점평가 별3개" style="margin-top:6px">
                                <img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
                            </div>
                        </label>
                    </td>
                    <td class="star_check">
                        <input type="radio" class="order_radio" id="star02" name="score" value="2">
                        <label for="star02">
                            <span></span>
                            <div class="star_groups" title="별점평가 별2개" style="margin-top:6px">
                                <img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
                            </div>
                        </label>
                    </td>
                    <td class="star_check">
                        <input type="radio" class="order_radio" id="star01" name="score" value="1">
                        <label for="star01">
                            <span></span>
                            <div class="star_groups" title="별점평가 별1개" style="margin-top:6px">
                                <img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
								<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
                            </div>
                        </label>
                    </td>
                </tr>
                <tr>
                    <th style="vertical-align:top">제목</th>
                    <td colspan="4" class="textL"><input type="text" style="width:100%" name="title" id="title"></td>
                </tr>
                <tr>
                    <th style="vertical-align:top">내용</th>
                    <td colspan="4" class="textL"><textarea style="height:105px;width:100%;box-sizing:border-box" placeholder="내용 입력" name="content" id="content"></textarea></td>
                </tr>
                <tr>
                    <th rowspan="5" style="vertical-align:top">파일첨부</th>
                    <td colspan="4" class="textL" style="border-bottom:none">
						<div class="filebox" style="width:100%;">
							<span id = "fileSetList">
								<span id="fileSpan1" style="visibility: visible">
								    <input type="text" id="filename" class="floatL" readonly="readonly" style="width:60%;float:left;">
									<label for="input_id_image" style="float:left">파일찾기</label>
									<%--<input class="upload-hidden" name="files1" id="input_id_files1" type="file">--%>
									<input type="file" name="imageFile" id="input_id_image" accept="image/*" class="upload-hidden" onchange="document.getElementById('filename').value=this.value">
                                    <input type="hidden" id="imgYn" name= "imgYn" >
                                    <input type="hidden" id="imgOldYn" name= "imgOldYn">
								</span>
							</span>
							<br/>
							<span id="viewFileInsert"></span>
						</div>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <span id="span_imgFile"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="file_up_info">
                    	<spring:eval expression="@front['system.review.file.size']" var="maxSize" />
						<fmt:parseNumber value="${maxSize / (1024*1024) }" var="maxSize_MB" integerOnly="true" />
                        ※ 첨부 이미지는 ${maxSize_MB }Mb 미만의 gif, png, jpg, jpeg 파일만 등록 가능합니다.
                    </td>
                </tr>
            </tbody>
        </table>
        </form:form>
        <div class="popup_btn_area">
            <button type="button" class="btn_review_cancel" id="btn_review_cancel">취소</button>
			<button type="button" class="btn_review_ok" id="btn_review_cofirm">등록</button>
        </div>
    </div>
 </div>
<!---// popup 상품평쓰기 --->
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>	            
