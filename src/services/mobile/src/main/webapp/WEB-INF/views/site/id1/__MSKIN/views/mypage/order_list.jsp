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
	<t:putAttribute name="title">주문/배송조회</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
	<script type="text/javascript">
var totalFileLength=0;
	$(document).ready(function(){


		//페이징
		jQuery('#div_id_paging').grid(jQuery('#form_id_search'));
		
		$('.more_view').on('click', function() {
			var viewId = $(this).parents().parents().parents().attr("id");
			
			var pageIndex = Number($('#page').val())+1;

				if(viewId=="view01"){            
						var url = '${_MOBILE_PATH}/front/order/order-list-ajax?page='+pageIndex;
					   Dmall.AjaxUtil.load(url, function(result) {
						   if('${so.totalPageCount}'==pageIndex){
							   $('#div_id_paging').hide();
						   }
						   $("#page").val(pageIndex);
						   $('.list_page_view em').text(pageIndex);
						   $('#view01 .my_shopping_view_body').append(result);
					   })
				}else{
					 var url = '${_MOBILE_PATH}/front/order/order-cancel-list?page='+pageIndex;
					 Dmall.AjaxUtil.load(url, function(result) {
						 if('${so.totalPageCount}'==pageIndex){
							 $('#div_id_paging').hide();
						 }
						 $("#page").val(pageIndex);
						 $('.list_page_view em').text(pageIndex);
							 $("#" + activeTab).html(result);
					 })
				}
			});
		
		
		$( "div.my_shopping_view" ).hide();
		$( "div.my_shopping_view:first" ).show();
		
		$("ul.my_shopping_menu li").click(function () {
			var rel = $(this).attr("rel");
			$("ul.my_shopping_menu li").removeClass("active");
			$(this).addClass("active");
			$("div.my_shopping_view").hide()
			var activeTab = $(this).attr("rel");
			$("#" + activeTab).fadeIn()
			
			if(rel=="view02"){
			var pageIndex = 1;
			  var param = param = "page="+pageIndex;
			var url = '${_MOBILE_PATH}/front/order/order-cancel-list?'+param;
			   Dmall.AjaxUtil.load(url, function(result) {
				   if('${so.totalPageCount}'==pageIndex){
					   $('#div_id_paging').hide();
				   }
				   $("#page").val(pageIndex);
				   $('.list_page_view em').text(pageIndex);
					   $("#" + activeTab).html(result);
			   })
			}
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
        	var url = '${_MOBILE_PATH}/front/question/question-insert';
            var param = jQuery('#form_id_question').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerPopupUtil.close('popup_question_write');   //수정후 레이어팝업 닫기
                    Dmall.LayerUtil.confirm("상품문의가 등록되었습니다.<br>답변내용은 마이페이지 > 상품문의 메뉴에서 확인해 주세요.",
                       		function() {
        		            	location.href="${_MOBILE_PATH}/front/question/question-list"
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
            var url = '${_MOBILE_PATH}/front/review/review-insert';
            var param = jQuery('#form_id_review').serialize();
            /* var score = $('div.list_selectBox span').first().data('value'); */
            var score = $('.selected').children('span').attr('value');

            if(score != null && score != ''){
            	$('input[name=score]', '#form_id_review').val(score);
            }

            if (Dmall.FileUpload.checkFileSize('form_id_review')) {
            	Dmall.waiting.start();
                $('#form_id_review').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                    	Dmall.waiting.stop();
                        //Dmall.validate.viewExceptionMessage(result, 'form_id_review');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('popup_review_write');   //수정후 레이어팝업 닫기
                            var confirmMsg = "상품후기가 등록되었습니다.";
                            var pointPvdYn = "${pointPvdYn}";
                            if(pointPvdYn == 'Y') confirmMsg += "<br>(마켓포인트 ${buyEplgWritePoint }점 적립완료)";
                            Dmall.LayerUtil.confirm(confirmMsg,
                               		function() {
                		            	location.href="${_MOBILE_PATH}/front/review/review-list"
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
        $('#form_id_review #span_imgFile').hide()
		
        Dmall.LayerPopupUtil.open($('#popup_review_write'));
	}

	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			나의 주문
		</div>
		<div class="my_shopping_top">
			<ul class="my_shopping_info">
				<li>주문번호를 클릭하시면 상세조회를 하실 수 있습니다.</li>
			</ul>
		</div>
		<ul class="my_shopping_menu">
			<li class="active" rel="view01">전체주문내역</li>
			<li rel="view02">반품/교환 내역</li>
		</ul>
		<form:form id="form_id_search" commandName="so">
		<form:hidden path="page" id="page" />
		<div class="my_shopping_view" id="view01">
			<c:set var="ordNo" value="0"/>
			<c:choose>
			<c:when test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 0}">
				<div class="my_shopping_view_body">
				<c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
					<c:set var="sumAddAptAmt" value="0"/>
					<c:set var="claimNo" value="${resultList.orderInfoVO.claimNo}"/>
					<c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
						<!-- 구매내역 1set -->
						<div class="my_order">
							<a href="javascript:;" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">
							  <c:if test="${ordNo!= resultList.orderInfoVO.ordNo}">
								<div class="my_order_no">
								<c:if test="${resultList.orderInfoVO.orgOrdNo ne null}">
								<button type="button" class="btn_review_go" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">교환</button>
								</c:if>
									주문번호 : ${resultList.orderInfoVO.ordNo}
								</div>
							   </c:if>
								<ul class="my_order_info_top">
									<li class="my_order_product_pic"><img src="${_IMAGE_DOMAIN}${goodsList.imgPath}" alt=""></li>
									<li class="my_order_product_title">
										<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}</a>
										<ul class="my_order_info_text">
										   <c:forEach var="optionList" items="${goodsList.goodsAddOptList}" varStatus="status">
										 		 <li>[${optionList.addOptNm}]</li>
											   <c:set var="sumAddAptAmt" value="${sumAddAptAmt + (optionList.addOptAmt*optionList.addOptBuyQtt)}"/>
										   </c:forEach>
										     <%--<c:if test="${goodsList.itemNm ne null}">
											<li>
												<span class="option_title">[옵션] <br>${goodsList.itemNm}]/${goodsList.ordQtt}개</span>
												<span class="option_price"><em><fmt:formatNumber value="${goodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
											</li>
											</c:if>
											<c:if test="${fn:length(goodsList.goodsAddOptList)>0}">
												<li>
													<span class="option_title">[추가옵션] </span>
												</li>
											</c:if>
											 <c:forEach var="addOptionList" items="${goodsList.goodsAddOptList}" varStatus="status">
													<li>
														<span class="option_title">${addOptionList.addOptNm}]/${addOptionList.addOptBuyQtt}개</span>
														<span class="option_price"><em><fmt:formatNumber value="${addOptionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
													</li>
													<c:set var="sumAddAptAmt" value="${sumAddAptAmt + (optionList.addOptAmt*optionList.addOptBuyQtt)}"/>
											</c:forEach>--%>
										</ul><!--// my_order_info_text -->
										<c:if test="${goodsList.freebieNm ne null}">
										<p class="option_title">사은품 : <c:out value="${goodsList.freebieNm}"/></p>
										</c:if>
										<button type="button" class="btn_review_go" onclick="open_question_pop('${goodsList.goodsNo}');">문의하기</button>
									</li>
								</ul>
								
								<ul class="my_order_detail">
									<li>
										<span class="title">주문상태</span>
										<p class="detail">
                                            <c:if test="${goodsList.rsvOnlyYn eq 'Y'}">
                                                <span class="label_reservation">예약전용</span>
                                            </c:if>
                                            <c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
                                                ${goodsList.ordDtlStatusNm}
                                            </c:if>
										</p>
									</li>
									<li>
										<span class="title">주문금액</span>
										<p class="detail">
											<fmt:formatNumber value='${goodsList.saleAmt*goodsList.ordQtt+sumAddAptAmt}' type='number'/>원
										</p>
									</li>
								</ul>
							</a>
                            <c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
								<c:set var="claimCd" value="${fn:split(goodsList.claimCd,',')}"/>
								<c:set var="claimNm" value="${fn:split(goodsList.claimNm,',')}"/>
								<c:set var="returnCd" value="${fn:split(goodsList.returnCd,',')}"/>
								<c:set var="returnNm" value="${fn:split(goodsList.returnNm,',')}"/>

								<c:set var="pClaimQtt" value="${fn:split(goodsList.pclaimQtt,',')}"/>
							<div class="my_order_area">
								<c:if test="${claimNo eq null}">
									<!-- 주문취소(주문완료,결제확인)-->
									<c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
									<button type="button" class="btn_order_cancel" onclick="order_cancel_pop('${resultList.orderInfoVO.ordNo}');">주문취소</button>
									</c:if>
									<!-- 반품/교환(배송준비,배송중,배송완료) -->
									<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '67' || goodsList.ordDtlStatusCd eq '75'}">
										<c:if test="${goodsList.ordQtt > goodsList.claimQtt}">
										<button type="button" class="btn_order_cancel" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">교환신청</button>
										<button type="button" class="btn_order_cancel" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품신청</button>
										</c:if>
									</c:if>
									<%--<c:if test="${goodsList.ordQtt eq goodsList.claimQtt}">
										<c:forEach var="claimNm" items="${claimNm}" varStatus="g">
											&lt;%&ndash;${returnNm[g.index]}/&ndash;%&gt;${claimNm} (${pClaimQtt[g.index]})<br>
										</c:forEach>
									</c:if>--%>
								</c:if>
								<%--<c:if test="${claimNo ne null}">
									<c:if test="${goodsList.claimNm ne null}">
									<c:forEach var="claimNm" items="${claimNm}" varStatus="g">
										${returnNm[g.index]}/${claimNm} (${pClaimQtt[g.index]})<br>
									</c:forEach>
									</c:if>
								</c:if>--%>
								<!-- 구매확정(배송중,배송완료)-->
								<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
									 <button type="button" class="btn_order_ok" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}','orderlist')">구매확정</button>
								</c:if>
								<!--상품평(배송중,배송완료,구매확정)-->
								<c:if test="${goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
									<%-- <button type="button" class="btn_review_go" onclick="goods_detail('${goodsList.goodsNo}', 'review');">상품평쓰기</button> --%>
									<button type="button" class="btn_review_go" onclick="open_review_pop('${goodsList.goodsNo}');">상품평쓰기</button>
								</c:if>
							</div>
                            </c:if>
						</div>
						<!--// 구매내역 1set -->
					<c:set var="ordNo" value="${resultList.orderInfoVO.ordNo}"/>
					</c:forEach>  
			   </c:forEach>
				</div>
			   </c:when>
			  <c:otherwise>
				 <!-- 주문상품이 없을 경우 -->
			<div class="no_order_history">
				조회 기간 동안 주문하신 상품이 없습니다.
			</div>
			<!--// 주문상품이 없을 경우 -->
			  </c:otherwise>
		  </c:choose>
			<!---- 페이징 ---->
			<div class="my_list_bottom" id="div_id_paging">
				<grid:paging resultListModel="${order_list}" />
			</div>
			<!----// 페이징 ---->
		</div>
		<div class="my_shopping_view" id="view02"></div>
		  </form:form>    
	</div>    
	<!---// 03.LAYOUT:CONTENTS --->
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
		<!-- <div id="middle_area"> -->
			<form id="form_id_question" action="${_MOBILE_PATH}/front/question/question-update">
	        <input type="hidden" name="mode" id="mode" value="insert"/>
	        <input type="hidden" name="bbsId" id="bbsId" value="question"/>
	        <input type="hidden" name="lettNo" id="lettNo" value=""/>
	        <input type="hidden" name="goodsNo" id="goodsNo" value=""/>
	        <input type="hidden" name="replyEmailRecvYn" id="replyEmailRecvYn" value=""/>
			
			<div class="popup_header">
				<h1 class="popup_tit">상품문의 쓰기</h1>
				<button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
			</div>
			<!-- <div class="product_head">
				상품문의 쓰기
			</div>	 -->
			<div class="product_review_top">
				<div class="review_warning">
					상품과 관련 없는 내용, 비방, 광고, 불건전한 내용의 글은 사전동의 없이 삭제될 수 있습니다.
				</div>
			</div>

			<!-- <div class="product_qna_top">
				<div class="qna_warning">
					* 상품과 관련 없는 내용, 비방, 광고, 불건전한 내용의 글은 사전동의 없이 삭제될 수 있습니다.
				</div>
			</div> -->
			<div class="product_qna_area" style="border-top:1px solid #000;margin-top:-1px">			
				<ul class="product_review_list" style="margin-top:0">
					<li class="form" style="border-top:none">
						<span class="title">제목</span>
						<p class="detail">
							<input type="text" id="title" name="title">
						</p>
					</li>
					<li class="form" style="border-top:none">
						<span class="title">이름</span>
						<p class="detail">
							<input type="text" value="${user.session.memberNm}">
						</p>
					</li>
					<li class="form">
						<span class="title">내용</span>
						<p class="detail">
							<textarea id="content" name="content" rows="5"></textarea>
						</p>
					</li>
					<%-- <li class="form checkbox_area">
						<span class="title">이메일</span>
						<div class="checkbox" style="margin-top:10px;color:#000">			
							<label>
								<input type="checkbox" name="select_order" name="emailRecvYn" id ="emailRecvYn">
								<span></span>
							</label>
							답변글을 이메일로 받기
						</div>
					</li> --%>
				</ul>
			</div>
			</form>	
			<div class="alert_btn_area">
				<button type="button" class="btn_alert_ok" id="btn_question_confirm">등록</button>
				<button type="button" class="btn_alert_cancel" id="btn_question_cancel">취소</button>
			</div>
		<!-- </div>	 -->
	
	</div>
	<%---// 문의팝업 ---%>
	<%-- popup 상품평쓰기 --%>
	<div id="popup_review_write" style="display: none;">
		<div class="popup_header">
			<h1 class="popup_tit">상품후기 쓰기</h1>
			<button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
		</div>
	    <!-- <div class="product_head">
			상품평쓰기
		</div> -->
		<div class="product_review_top">
			<div class="review_warning">
				허위, 과대광고, 비방, 표절, 도용 등의 내용은 통보 없이 삭제 될 수 있습니다.
			</div>
		</div>
	    <div class="product_review_area" style="border-top:1px solid #000;margin-top:-1px">
	        <form:form id="form_id_review">
	        <input type="hidden" name="mode" id="mode" value="insert"/>
	        <input type="hidden" name="bbsId" id="bbsId" value="review"/>
	        <input type="hidden" name="lettNo" id="lettNo" value=""/>
	        <input type="hidden" name="goodsNo" id="goodsNo" value=""/>
	
	        <ul class="product_review_list" style="margin-top:0">
	            <li class="form" style="border-top:none;">
					<span class="title">상품평가</span>
					<p class="star_detail">
						<div class="list_selectBox">
							<span class="selected" style="width:113px"></span>
							<span class="selectArrow"></span>
							<div class="selectOptions">
								<input type="hidden" name="score" value="5"/>
								<span class="selectOption" value="5"><span class="icon_star_5" value="5"></span></span>
								<span class="selectOption" value="4"><span class="icon_star_4" value="4"></span></span>
								<span class="selectOption" value="3"><span class="icon_star_3" value="3"></span></span>
								<span class="selectOption" value="2"><span class="icon_star_2" value="2"></span></span>
								<span class="selectOption" value="1"><span class="icon_star_1" value="1"></span></span>
							</div>
						</div>
					</p>
				</li>
				<li class="form">
					<span class="title">제목</span>
					<p class="detail">
						<input type="text" name="title" id="title">
					</p>
				</li>
				<li class="form">
					<span class="title">첨부이미지</span>
					<p class="detail">
						<%--<input type="text" id="filename" class="floatL" readonly="readonly" style="width:50%;float:left;">
	                    <div class="file_up" style="float:left;">
	                        <button type="button" class="btn_fileup" value="Search files">찾아보기</button>
	                        <input type="file" name="imageFile" id="input_id_image" accept="image/*" style="width:100%" onchange="document.getElementById('filename').value=this.value">
	                        <input type="hidden" id="imgYn" name= "imgYn" >
	                        <input type="hidden" id="imgOldYn" name= "imgOldYn">
	                    </div>
	                    <span id="span_imgFile"></span>--%>
	
	
	
	                    <spring:eval expression="@front['system.review.file.size']" var="maxSize" />
						<fmt:parseNumber value="${maxSize / (1024*1024) }" var="maxSize_MB" integerOnly="true" />
	                    <span class="desc_txt"> ※ ${maxSize_MB  }Mb 미만 gif, png, jpg, jpeg</span>
	                    <div class="filebox">
	                        <span id = "fileSetList">
	                            <span id="fileSpan1" style="visibility: visible">
	                                <input type="text" id="filename" class="file_add" readonly="readonly">
	                                <label for="input_id_image" style="float:left;">파일등록</label>
	                                <input  type="file" name="imageFile" id="input_id_image" accept="image/*" style="width:100%" onchange="document.getElementById('filename').value=this.value">
	                        		<input type="hidden" id="imgOldYn" name= "imgOldYn">
	                        		<input type="hidden" id="imgYn" name= "imgYn">
	                            </span>
	                        </span>
	                        <span id="viewFileInsert"></span>
	
	                        <!-- <button type="button" class="btn_del"></button> --><!--삭제버튼:불러온 이미지 이름 바로 옆에 붙게 해주세요 -->
	                    </div>
					</p>
				</li>
				<li class="form">
					<span class="title">상품평</span>
					<p class="detail2">
						<textarea name="content" id="content" rows="5"></textarea>
					</p>
				</li>
	        </ul>
	        </form:form>
		<div class="alert_btn_area">		
			<button type="button" class="btn_alert_cancel" id="btn_review_cancel">취소</button>
			<button type="button" class="btn_alert_ok" id="btn_review_cofirm">등록</button>
		</div>
	</div>
	</div>
	<%--// popup 상품평쓰기 ---%>
	</t:putAttribute>
</t:insertDefinition>