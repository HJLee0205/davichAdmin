<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<sec:authentication var="user" property='details'/>
<script>
	var totalFileLength=0;
    $(document).ready(function(){
        //페이징
        jQuery('#div_review_paging').grid(jQuery('#form_review_search'),ajaxReviewList);

        //쓰기
        var ordYn = ${ordYn};
        var reviewYn = ${reviewYn};
        var reviewPmYn = ${reviewPmYn};
        var reviewTotYn = ${reviewTotYn};
        
        $('#btn_write_review').on('click', function() {

            var memberNo =  '${user.session.memberNo}';
            if(memberNo == '') {
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                        var returnUrl = window.location.pathname+window.location.search;
                        location.href= "/front/login/member-login?returnUrl="+returnUrl;
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
             	// 임시사용
             	setDefaultReviewForm();
				Dmall.LayerPopupUtil.open($('#popup_review_write'));
            }
        });
        
     	// 마이페이지 문의하기 클릭시 문의팝업 바로 띄우는 처리
        if("${so.opt}" == "review"){
        	$('#btn_write_review').click();
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
                url = '/front/review/review-insert';
            }else{
                url = '/front/review/review-update';
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
            	
                $('#form_id_review').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        Dmall.validate.viewExceptionMessage(result, 'form_id_review');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('popup_review_write');   //수정후 레이어팝업 닫기
                            Dmall.LayerUtil.alert(result.message).done(function(){
                                location.href = '/front/goods/goods-detail?goodsNo=${so.goodsNo}'; //목록화면 갱신
                            });
                        } else {
                            Dmall.LayerUtil.alert("오류가 발생하였습니다.<br>관리자에게 문의 하시기 바랍니다.");
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
        			Dmall.LayerUtil.alert('gif,png,jpg,jpeg 파일만 업로드 할수 있습니다.11','','');
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


        $(document).on('click','.review_detail .title',function(){
            var article = $(this).next().find('.anwser_area');
            if(article.css("display") != "none"){
                article.hide();
            }else{
                article.show();
            }
        });
    });

    //상품후기 상세조회
    function selectReview(idx){
        var url = '/front/review/review-detail',dfd = jQuery.Deferred();
        var param = {lettNo: idx};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $("#form_id_review #mode").val("update");
                $("#form_id_review #title").val(result.data.title);
                $("#form_id_review #content").val(result.data.content);
                $("#form_id_review #lettNo").val(idx);
                if(result.data.atchFileArr != null) {
                    var imgPath = "<img src='${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path="+result.data.atchFileArr[0].filePath+"&id1="+result.data.atchFileArr[0].fileNm+"' style='width:65px;height:65px;'>";
                    var button = "<img src='../img/product/btn_reply_del.gif' alt='삭제' style='cursor:hand' onclick='return delOldImgFileNm(\""+result.data.atchFileArr[0].fileNo+"\")'>";
                    $('#form_id_review #span_imgFile').html(imgPath+button);
                    $('#form_id_review #imgOldYn').val('Y');
                    $('#form_id_review #span_imgFile').show()
                }
                //$("#form_id_review  input[name='score']:radio[value='"+result.data.score+"']").prop('checked',true);
                Dmall.LayerPopupUtil.open($('#popup_review_write'));
            }else{
                Dmall.LayerUtil.alert("데이터를 가져올수 없습니다.", "오류");
            }
        });
    };

    /*상품후기 삭제*/
    function deleteReview(idx){
        Dmall.LayerUtil.confirm('상품후기를 삭제하시겠습니까?', function() {
            var url = '/front/review/review-delete';
            var param = {'lettNo' : idx, bbsId : "review"};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href = '/front/goods/goods-detail?goodsNo=${so.goodsNo}'; //목록화면 갱신
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
        $('#form_id_review #span_imgFile').html('')
        $('#form_id_review #span_imgFile').hide()
        $("#form_id_review input[name='score']:radio[value='5']").prop('checked',true);
    }

    //게시판 이미지파일 삭제
    function delOldImgFileNm(fileNo){
        var url = '/front/review/attach-file-delete';
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
		$("#imgYn").val("Y");

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

<div class="shopping_review_box">
    <div class="review_graph_area">
        <p class="review_graph_bar" style="width:${averageScore*20}%"></p>
    </div>
    <div class="review_right">
        <div class="graph_star_groups">
<%--
            <img src="${_SKIN_IMG_PATH}/product/icon_star_blue.png" alt="상품평가 별">
            <img src="${_SKIN_IMG_PATH}/product/icon_star_blue.png" alt="상품평가 별">
            <img src="${_SKIN_IMG_PATH}/product/icon_star_blue.png" alt="상품평가 별">
            <img src="${_SKIN_IMG_PATH}/product/icon_star_half.png" alt="상품평가 별">
            <img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
--%>
            <c:forEach begin="1" end="${fn:substring(averageScore, 0, 1)}" >
                <img src="${_SKIN_IMG_PATH}/product/icon_star_blue.png" alt="상품평가 별">
            </c:forEach>
            <c:if test="${fn:substring(averageScore, 0, 1) lt 5}">
                <c:forEach begin="${fn:substring(averageScore, 0, 1)+1}" end="5" >
                    <img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">
                </c:forEach>
            </c:if>
            <span class="per_no"><em>${averageScore}</em>/5</span>
        </div>
        <div class="review_text">
            <span><em>${reviewList.filterdRows}</em>분이 평가에 참여하셨습니다.</span>
        </div>
    </div>
</div>

<form:form id="form_review_search" commandName="so" >
    <form:hidden path="page" id="page" />
<div class="review_top">

    <button type="button" id="btn_write_review" class="btn_review">구매후기 쓰기<i></i></button>
</div>
<ul class="review_list">
    <c:choose>
    <c:when test="${reviewList.resultList ne null}">
    <c:forEach var="resultModel" items="${reviewList.resultList}" varStatus="status">
    <c:choose>
    <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >

        <li>
            <div class="review_detail">
                <c:if test="${resultModel.imgFilePath ne null}">
                	<a href="${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" target="_blank">
                    	<div class="img_area"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" width="100px" height="100px;" onerror="this.onerror=null;this.src='${_SKIN_IMG_PATH}/product/icon_review.png';this.style.width=0;this.style.height=0;"></div>
                    </a>
                </c:if>
                <c:if test="${resultModel.imgFilePath eq null}">
                    <div class="img_area"></div>
                </c:if>
                <div class="text_area">
					<div class="graph_sstar_groups">
						<c:forEach begin="1" end="${resultModel.score}" ><img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별"></c:forEach>
						<%--<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
						<img src="${_SKIN_IMG_PATH}/product/icon_star_sblue.png" alt="상품평가 별">
						<img src="${_SKIN_IMG_PATH}/product/icon_star_shalf.png" alt="상품평가 별">
						<img src="${_SKIN_IMG_PATH}/product/icon_star_sgray.png" alt="상품평가 별">--%>
					</div>
                    <p class="tit title" style="cursor: pointer;">${resultModel.title}</p>
                    <div class="text">
                            ${resultModel.content}

                         <%-- 답변 --%>
                            <c:if test="${resultModel.replyStatusYn == 'Y'}" >
                                    <c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
                                        <c:if test="${resultModel.lettNo eq replyList.grpNo}">
                                            <div class="anwser_area" style="display:none;">
                                                <br><br><em>[답변]</em> ${replyList.title}<br>
                                                <c:set value="${replyList.content}" var="rdata"/>
                                                <c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
                                                    ${rcontent}
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            <%--// 답변 --%>
                    </div>
                    <p class="writer">${StringUtil.maskingName(resultModel.memberNm)} <span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${resultModel.regDttm}" /></span></p>
                </div>
                <div class="view_btn_area" style="text-align:right;position:initial;">
                    <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
                        <button type="button" class="btn_modify" onclick="selectReview('${resultModel.lettNo}');">수정</button>
                        <button type="button" class="btn_del" onclick="deleteReview('${resultModel.lettNo}');">삭제</button>
                    </c:if>
                </div>
            </div>

        </li>
    </c:when>
    <c:otherwise>
        <li>
            <div class="graph_sstar_groups">
                <img src="/front/img/product/icon_reply.png" alt="댓글 아이콘">
            </div>
            <div class="review_detail">
                <div class="img_area"></div>
                <div class="text_area">
                    <p class="tit">${resultModel.title}</p>
                    <div class="text">
                            ${resultModel.content}
                    </div>
                    <p class="writer">${StringUtil.maskingName(resultModel.memberNm)} <span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${resultModel.regDttm}" /></span></p>
                </div>
            </div>
        </li>
    </c:otherwise>
    </c:choose>
    </c:forEach>
    </c:when>
        <c:otherwise>
                <p class="no_review">등록된 상품후기가 없습니다.</p>
        </c:otherwise>
    </c:choose>
</ul>
    <!---- 페이징 ---->
    <div class="tPages" id=div_review_paging>
        <grid:paging resultListModel="${reviewList}" />
    </div>
    <!----// 페이징 ---->
</form:form>

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
        <input type="hidden" name="goodsNo" id="goodsNo" value="${so.goodsNo}"/>
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
