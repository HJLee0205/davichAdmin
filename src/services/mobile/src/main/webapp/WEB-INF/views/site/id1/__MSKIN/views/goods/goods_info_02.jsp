<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<jsp:useBean id="now" class="java.util.Date"/>
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<sec:authentication var="user" property='details'/>
<script>
var totalFileLength=0;
    $(document).ready(function(){
        enableSelectBoxes_score();

        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_review_search'));

        $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
     		var url = '${_MOBILE_PATH}/front/review/review-paging-ajax?goodsNo=${so.goodsNo}&'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if('${so.totalPageCount}'==pageIndex){
		        	$('#div_id_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('.review_list').append(result);

		        $('.qna_list li .tit').click(function() {
					$(this).parent().next('.question').slideToggle();
				});
	        })
         });

        var ordYn = ${ordYn};
        var reviewYn = ${reviewYn};
        var reviewPmYn = ${reviewPmYn};
        var reviewTotYn = ${reviewTotYn};
        
        //쓰기
        $('#btn_write_review').on('click', function() {

            var memberNo =  '${user.session.memberNo}';
            if(memberNo == '') {
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                        var returnUrl = window.location.pathname+window.location.search;
                        location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                    }
                );
            } else {
                /* 상품후기 적립금 관련 체크로직 (실사용시 주석해제 필요) 
                1) 주문후 배송중 이후부터 작성가능 
                2) 한주문당 일반, 프리미엄 후기 각각 한번씩 작성가능
                3) 저장로직에서 다시 체크해야함 (아래 등록버튼 주석 해제필요)
                
	             if(!ordYn) {
	                 Dmall.LayerUtil.alert('상품 구매 후(배송중 이후) 작성 가능합니다.') ;
	             } else {
	                	if (reviewTotYn) {
	                     Dmall.LayerUtil.alert('구매 후기(일반/프리미엄)는 한 주문당 각각 한번만 작성 가능합니다.');
	             	} else {
	                     setDefaultReviewForm();
	                     Dmall.LayerPopupUtil.open($('#popup_review_write'));
	             	}
	             } 
            	*/
                
                //C 임시사용
                setDefaultReviewForm();
                Dmall.LayerPopupUtil.open($('#popup_review_write'));
            }
        });
        
     	// 마이페이지 문의하기 클릭시 문의팝업 바로 띄우는 처리
     	var opt = "${so.opt}";
        if(opt == "review"){
        	$('#btn_write_review').click();
        	$('html, body').animate({ scrollTop: "300"}, 'slow');
        }

        // 등록/수정
        $('#btn_review_cofirm').on('click', function() {
        	if($('#form_id_review #title').val() == ''){
        		Dmall.LayerUtil.alert('제목을 입력해주세요.') ;
        		return false;
        	}
			if($('#form_id_review #content').val() == ''){
				Dmall.LayerUtil.alert('내용을 입력해주세요.') ;
        		return false;
        	}
            var url = '';
            if($('#form_id_review #mode').val() == 'insert'){
                url = '${_MOBILE_PATH}/front/review/review-insert';
            }else{
                url = '${_MOBILE_PATH}/front/review/review-update';
            }

            /* var score = $('div.list_selectBox span').first().data('value'); */
            var score = $('.selected').children('span').attr('value');

            if(score != null && score != ''){
            	$('input[name=score]', '#form_id_review').val(score);
            }

            if (Dmall.FileUpload.checkFileSize('form_id_review')) {
            	
            	/* 상품후기 적립금 관련 체크로직 
         	   1) 등록시 파일첨부가 있는지 체크해서 각각 일반, 프리미엄인지 판단한다.
         	   
	         	var fileChk = jQuery('#form_id_review input[type="file"]').val().length;
	
	         	// 파일첨부 있을경우 - 프리미엄
	         	if (fileChk > 0) {
	                 if(reviewPmYn) {
	                     Dmall.LayerUtil.alert('구매 후기(프리미엄)는 한 주문당 한번만 작성 가능합니다.') ;
	                     return ;
	                 }
	         	} else {
	                 if(reviewYn) {
	                     Dmall.LayerUtil.alert('구매 후기(일반)는 한 주문당 한번만 작성 가능합니다.') ;
	                     return ;
	                 }
	         	}
	         	*/
            	
            	Dmall.waiting.start();
                $('#form_id_review').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                    	Dmall.waiting.stop();
                        Dmall.validate.viewExceptionMessage(result, 'form_id_review');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('popup_review_write');   //수정후 레이어팝업 닫기
                            Dmall.LayerUtil.alert(result.message).done(function(){
                                //location.href = '${_MOBILE_PATH}/front/review/review-list-ajax?goodsNo=${so.goodsNo}'; //목록화면 갱신
                                ajaxReviewList();

                            });
                        } else {
                            Dmall.LayerUtil.alert(result.message);
                        }
                    }
                });
            }
        });

        // 상품평수정 팝업 닫기
        $('#btn_review_cancel').on('click', function() {
            setDefaultReviewForm();
            Dmall.LayerPopupUtil.close('popup_review_write');
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

        /* 배송/반품/환불 안내 */
        $('[id^=btn_extra]').off('click').on('click',function (){
            $('.shopping_info_list').html($('.shopping_info_list').html().replace(/(\r\n|\n\r|\r|\n)/g, ""));
            $("#tabs_content").html($('#extraInfo').html());

            //Dmall.LayerPopupUtil.open($('#extraInfo'));
        });

        $('.qna_list li .tit').click(function() {
            $(this).parent().next('.question').slideToggle();
        });
    });

    //상품후기 상세조회
    function selectReview(idx){
        var url = '${_MOBILE_PATH}/front/review/review-detail',dfd = jQuery.Deferred();
        var param = {lettNo: idx};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $("#form_id_review #mode").val("update");
                $("#form_id_review #title").val(result.data.title);
                $("#form_id_review #content").val(result.data.content);
                $("#form_id_review #lettNo").val(idx);
                if(result.data.atchFileArr != null) {
                    var button = "<img src='../img/product/btn_reply_del.gif' alt='삭제' style='cursor:hand' onclick='return delOldImgFileNm(\""+result.data.atchFileArr[0].fileNo+"\")'>";
                    $('#form_id_review #span_imgFile').html(result.data.atchFileArr[0].orgFileNm+button);
                    $('#form_id_review #imgOldYn').val('Y');
                    $('#form_id_review #span_imgFile').show()
                }
                //$("#form_id_review  input[name='score']:radio[value='"+result.data.score+"']").prop('checked',true);
                Dmall.LayerPopupUtil.open($('#popup_review_write'));
            }else{
                Dmall.LayerUtil.alert("데이터를 가져올수 없습니다.", "오류");
            }
        });
    }
    /*상품후기 삭제*/
    function deleteReview(idx){
        Dmall.LayerUtil.confirm('상품후기를 삭제하시겠습니까?', function() {
            var url = '${_MOBILE_PATH}/front/review/review-delete';
            var param = {'lettNo' : idx, bbsId : "review"};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href = '${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${so.goodsNo}'; //목록화면 갱신
                 }
            });
        })
    }

    function setDefaultReviewForm(){
        $('#form_id_review #mode').val('insert');
        $('#form_id_review #title').val('');
        $('#form_id_review #content').val('');
        $('#form_id_review #filename').val('');
        $('#form_id_review #input_id_image').val('');
        $('#form_id_review #content').val('');
        $('#form_id_review #imgOldYn').val('');
        $('#form_id_review #span_imgFile').html('');
        $('#form_id_review #span_imgFile').hide()
        /* $("#form_id_review input[name='score']:radio[value='5']").prop('checked',true); */
    }

    //게시판 이미지파일 삭제
    function delOldImgFileNm(fileNo){
        var url = '${_MOBILE_PATH}/front/review/attach-file-delete';
        var param = {fileNo:fileNo,bbsId:"review"};

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            $("#span_imgFile").html("");
            $("#imgOldYn").val("");
        });

    }
    
  	//파일 변경
    jQuery(document).off('change',"input[type=file]");
    var num = 1;
    jQuery(document).on('change',"input[type=file]", function(e) {
        var fileSize=0;
        if(jQuery(this).attr('id') == "input_id_image"){
            return;
        }
        
        var fileSize = $(this)[0].files[0].size;
        var maxSize = <spring:eval expression="@front['system.review.file.size']"/>;
        
        if(fileSize > maxSize){
        	var maxSize_MB = maxSize / (1024*1024);
        	Dmall.LayerUtil.alert('파일 용량 '+maxSize_MB.toFixed(2)+' Mb 이내로 등록해 주세요.','','');
        	return;
        }
        
        var ext = jQuery(this).val().split('.').pop().toLowerCase();
		if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
			Dmall.LayerUtil.alert('gif,png,jpg,jpeg 파일만 업로드 할수 있습니다.','','');
			$("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
			$("#input_id_files"+num).val("");
			return;
		}

        var fileNm = e.target.value.substring(e.target.value.lastIndexOf('\\') + 1);
        totalFileLength = totalFileLength+1;

        if(totalFileLength>1){
            Dmall.LayerUtil.alert('첨부파일는 최대 1개까지 등록 가능합니다.');
            totalFileLength = totalFileLength-1;
            $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
            $("#input_id_files"+num).val("");
            return;
        }

        document.getElementById("fileSpan"+num).style.display = "none";

        var text = "<span class='file_add'  name='_fileNm"+num+"' id='_fileNm"+num+"'>" +
                        "<span id='tes"+num+"'>"+fileNm+"</span>" +
                        "<button type='button' onclick= 'return delNewFileNm("+num+","+fileSize+")' class='btn_del'>" +
                        "</button>" +
                    "</span>";

        $( "#viewFileInsert" ).append( text );
        num = num+1;
        $( "#fileSetList" ).append(
            "<span id=\"fileSpan"+num+"\" style=\"visibility: visible\">"+
            "<label for=\"input_id_files"+num+"\">파일찾기</label>"+
            "<input class=\"upload-hidden\" name=\"files"+num+"\" id=\"input_id_files"+num+"\" type=\"file\">"+
            " </span>"
        );
    });

	</script>
    <%-- 컨텐츠 --%>
		<form:form id="form_review_search" commandName="so" >
		<form:hidden path="page" id="page" value="1"/>
        <div class="tabs_content" style="margin-top:0;">
            <div class="top_qna">
                <p class="text">총 <em>${reviewList.filterdRows}</em>개의 상품후기</p>
                <button type="button" class="btn_go_review" id="btn_write_review">상품후기쓰기</button>
            </div>
			<div class="graphview" style="display:none;">
				<span class="per_no">${averageScore}</span>
				<div class="review_graph_area">
					<p class="review_graph_bar" style="width:${averageScore*20}%"></p>
				</div>
				<div class="graph_star_groups">
					<c:forEach begin="1" end="${fn:substring(averageScore, 0, 1)}" >
						<img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별">
					</c:forEach>
					<c:if test="${fn:substring(averageScore, 0, 1) lt 5}">
						<c:forEach begin="${fn:substring(averageScore, 0, 1)+1}" end="5" >
							<img src="${_MOBILE_PATH}/front/img/product/icon_star_gray.png" alt="상품평가 별">
						</c:forEach>
					</c:if>
				</div>
				<span class="graphview_total"><em>${reviewList.filterdRows}</em>개의 상품평 기준</span>
			</div>
            <ul class="qna_list product review review_list">
				<c:choose>
					<c:when test="${fn:length(reviewList.resultList) > 0}">
					<c:forEach var="resultModel" items="${reviewList.resultList}" varStatus="status">
						<c:choose>
							<c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
								<li>
									<p class="tit">
										<%--<em>[]</em>--%>
											${resultModel.title}
										<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
										<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
										<c:if test="${date eq today}"><span class="review_view_new"> N</span></c:if>
									</p>
									<span class="reply_star_area">
									<c:forEach begin="1" end="${resultModel.score}" ><img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별"></c:forEach>
									</span>
									<span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></span>									
									<span class="user_name">${StringUtil.maskingName(resultModel.memberNm)}</span>
								</li>
								<li class="question" style="display:none;">
									<c:set value="${resultModel.content}" var="data"/>
									<c:set value="${fn:replace(data, cn, br)}" var="content"/>
									<div class="text_area">
								<c:if test="${resultModel.imgFilePath ne null}">
										<div class="img_view">
											<a href="${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" target="_blank">
												<img src="${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" onerror="this.src='../img/product/product_300_300.gif'">
											</a>
										</div>
								</c:if>
										<div class="text_view">${content}
										<%-- 답변 --%>
										<c:if test="${resultModel.replyStatusYn == 'Y'}" >
											<c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
												<c:if test="${resultModel.lettNo eq replyList.grpNo}">
													<br><br><div class="anwser_area">
														<em>[답변]</em> ${replyList.title}<br>
														<c:set value="${replyList.content}" var="rdata"/>
														<c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
															${rcontent}
													</div>
												</c:if>
											</c:forEach>
										</c:if>
										<%--// 답변 --%>
										</div>
									</div>
									<div class="btn_area">
								<c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
										<button type="button" class="btn_modify" onclick="selectReview('${resultModel.lettNo}');">수정</button>
										<button type="button" onclick="deleteReview('${resultModel.lettNo}');">삭제</button>
								</c:if>
									</div>
								</li>
							</c:when>
							<c:otherwise>
								<li>
									<p class="tit">
										<img src="${_MOBILE_PATH}/front/img/product/icon_reply.png" alt="댓글 아이콘"> ${resultModel.title}
										<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
										<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
										<c:if test="${date eq today}"><span class="review_view_new"> [NEW]</span></c:if>
									</p>
									<span class="user_name">${StringUtil.maskingName(resultModel.memberNm)}</span> <span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></span>
									<span class="reply_star_area">
									<c:forEach begin="1" end="${resultModel.score}" ><img src="${_SKIN_IMG_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별"></c:forEach>

									</span>
								</li>
								<li class="question" style="display: none;">
									<c:set value="${resultModel.content}" var="data"/>
									<c:set value="${fn:replace(data, cn, br)}" var="content"/>
									<div class="text_area">
										<c:if test="${resultModel.imgFilePath ne null}">
											<div class="img_view">
												<a href="${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" target="_blank">
													<img src="${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" onerror="this.src='../img/product/product_300_300.gif'">
												</a>
											</div>
										</c:if>
										<div class="text_view">
										${content}

										</div>
									</div>
									<div class="btn_area">
										<c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
											<button type="button" onclick="deleteReview('${resultModel.lettNo}');">삭제</button>
											<button type="button" class="btn_modify" onclick="selectReview('${resultModel.lettNo}');">수정</button>
										</c:if>
									</div>
								</li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					</c:when>
					<c:otherwise>
						<li style="text-align:center">상품후기 내역이 없습니다.</li>
					</c:otherwise>
			</c:choose>
            </ul>
			<%--- 페이징 ---%>
			<div class="tPages" id=div_id_paging>
				<grid:paging resultListModel="${reviewList}" />
			</div>
			<%---// 페이징 ---%>
        </div>
		</form:form>
    <%--</div>--%>

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
        <input type="hidden" name="goodsNo" id="goodsNo" value="${so.goodsNo}"/>

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
                                  <input type="hidden" id="imgYn" name= "imgYn" >
                        		<input type="hidden" id="imgOldYn" name= "imgOldYn">
                            </span>
                        </span>
                        <span id="viewFileInsert"></span>

                        <!-- <button type="button" class="btn_del"></button> --><!--삭제버튼:불러온 이미지 이름 바로 옆에 붙게 해주세요 -->
                    </div>
                    <span id="span_imgFile"></span>
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

	<%--// 배송/반품/환불 안내 --%>
	<%--<div id="extraInfo" class="popup">
		<div class="popup_head">
			<button type="button" class="btn_close_popup closepopup"><span class="icon_popup_close"></span></button>
			배송/반품/교환 안내
		</div>
		<div class="popup_gift_scroll">
			<ul class="shopping_info_list">
				<li class="title">배송안내</li>
				<li>${term_14.data.content}</li>
				<li class="title">반품/교환안내</li>
				<li>${term_15.data.content}</li>
				<li class="title">반품/환불안내</li>
				<li>${term_16.data.content}</li>
			</ul>
		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_popup_cancel closepopup">닫기</button>
		</div>
	</div>--%>
	<%--// 배송/반품/환불 안내 --%>

<%--
</t:putAttribute>
</t:insertDefinition>--%>