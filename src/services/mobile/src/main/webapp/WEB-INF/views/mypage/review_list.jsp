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
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<jsp:useBean id="now" class="java.util.Date"/>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">상품평</t:putAttribute>

    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        $( ".datepicker" ).datepicker();
        //검색
        $('.btn_date').on('click', function() {
            if($("#event_start").val() == '' || $("#event_end").val() == '') {
                Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                return;
            }
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/review/review-list', param);
        });
        //페이징
        //jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
     		var url = '${_MOBILE_PATH}/front/review/revew-paging?'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if('${so.totalPageCount}'==pageIndex){
		        	$('#div_id_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('.review_list').append(result);
	        })
         });


        /*상품평 수정*/
        $('.btn_review_ok').on('click', function() {

        	/* var score = $('div.list_selectBox span').first().data('value'); */
            var score = $('.selected').children('span').attr('value');

            if(score != null && score != ''){
            	$('input[name=score]', '#form_id_update').val(score);
            }

            var url = '${_MOBILE_PATH}/front/review/review-update';
            /* var param = jQuery('#form_id_update').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerPopupUtil.close('popup_review_write');   //수정후 레이어팝업 닫기
                    location.href= "${_MOBILE_PATH}/front/review/review-list";//목록화면 갱신
                }
            }); */

            if (Dmall.FileUpload.checkFileSize('form_id_update')) {
            	Dmall.waiting.start();
                $('#form_id_update').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                    	Dmall.waiting.stop();
                        Dmall.validate.viewExceptionMessage(result, 'form_id_update');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('form_id_update');   //수정후 레이어팝업 닫기
                            Dmall.LayerUtil.alert(result.message).done(function(){
                                location.href = '${_MOBILE_PATH}/front/review/review-list'; //목록화면 갱신
                            });
                        } else {
                            Dmall.LayerUtil.alert(result.message);
                        }
                    }
                });
            }

        });

        /* 상품평수정 팝업 닫기*/
        $('.btn_review_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_review_write');
        });

      //이미지파일 변경
        $('#input_id_image').on('change', function(e) {
            if($("#imgOldYn").val()=="Y"){
                $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                $("#filename").val("");
                Dmall.LayerUtil.alert("등록된 이미지 파일을 먼저 삭제하여 주세요.");
            }else{

                var files = e.originalEvent.target.files;
                var totalFileSize=0;
                for (var i = 0; i < files.length; i++){
                    totalFileSize = totalFileSize + files[i].size;
                }
                if(totalFileSize>1048576){
                    Dmall.LayerUtil.alert('이미지 파일은 최대 1Mbyte까지 등록 가능합니다.');
                    $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                    $("#imageFile").val("");
                    return;
                }

                var ext = jQuery(this).val().split('.').pop().toLowerCase();
                if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
                    Dmall.LayerUtil.alert('gif,png,jpg,jpeg 파일만 업로드 할수 있습니다.');
                    $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                    $("#filename").val("");
                    return;
                }
                $("#imgYn").val("Y");
                document.getElementById('filename').value=this.value;
            }
        });
    });

    /*상품후기 상세조회*/
    function selectReview(idx){
        var url = '${_MOBILE_PATH}/front/review/review-detail',dfd = jQuery.Deferred();
        var param = {lettNo: idx};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
            	$("#form_id_update #mode").val("update");
                $("#form_id_update #title").val(result.data.title);
                $("#form_id_update #content").val(result.data.content);
                $("#form_id_update #lettNo").val(idx);
                if(result.data.atchFileArr != null) {
                    var button = "<img src='../img/product/btn_reply_del.gif' alt='삭제' style='cursor:hand' onclick='return delOldImgFileNm(\""+result.data.atchFileArr[0].fileNo+"\")'>";
                    $('#form_id_update #span_imgFile').html(result.data.atchFileArr[0].orgFileNm+button);
                    $('#form_id_update #imgOldYn').val('Y');
                    $('#form_id_update #span_imgFile').show()
                }
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
            var param = {'lettNo' : idx, 'bbsId':'review'};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href= "${_MOBILE_PATH}/front/review/review-list";
                 }
            });
        })
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

    </script>
    </t:putAttribute>

    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents">
    	<div id="middle_area">
			<div class="product_head">
				<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
				상품평
			</div>
			<div class="product_review_top">
				<div class="review_warning">
					고객님께서 등록하신 상품평을 확인하실 수 있습니다.
				</div>
			</div>
			<form:form id="form_id_search" commandName="so">
            <form:hidden path="page" id="page" />
			<div class="product_review_area">
				<!-- <div class="product_review_btn_area">
					<button type="button" class="btn_review_write">상품평 쓰기</button>
				</div> -->
				<ul class="review_list">
					<c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                            <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                            <c:choose>
                                <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
								<li>
									<ul class="review_view">
										<li class="review_view_title">
											[${resultModel.goodsNm}]<br>
											${resultModel.title}
											<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
											<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
											<c:if test="${date eq today}"><span class="review_view_new">NEW</span></c:if>
											<div class="review_date floatC">
												<span class="star_area">
													<c:forEach begin="1" end="${resultModel.score}" ><img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별"></c:forEach>
												</span>
												<span class="review_time"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></span>
												<span class="review_id">${resultModel.memberNm}</span>
											</div>
										</li>
										<li class="review_view_text">
											<c:set value="${resultModel.content}" var="data"/>
											<c:set value="${fn:replace(data, cn, br)}" var="content"/>
											${content}<br>
											<%-- ${resultModel.content} --%>
											<c:if test="${resultModel.imgFilePath ne null}">
						                    	<img src="/image/image-view?type=BBS&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" width="100px" height="100px;" onerror="this.src='../img/product/product_300_300.gif'">
						                    </c:if>
											<div class="view_btn_area">
		                                        <button type="button" class="" onclick="selectReview('${resultModel.lettNo}');"><span class="answerLB">수정</span></button>
		                                        <button type="button" class="" onclick="deleteReview('${resultModel.lettNo}');"><span class="answerLR">삭제</span></button>
		                                    </div>
										</li>
									</ul>
								</li>
							</c:when>
                            <c:otherwise>
                                <li>
                                    <ul class="review_view">
                                        <li class="review_view_title">

                                            [${resultModel.goodsNm}]<br>
                                            <img src="${_MOBILE_PATH}/front/img/product/icon_reply.png" alt="댓글 아이콘"> ${resultModel.title}
                                            <fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
                                            <fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
                                            <c:if test="${date eq today}"><span class="review_view_new">NEW</span></c:if>
                                            <div class="review_date floatC">
                                                <span class="review_time"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></span>
                                                <span class="review_id">${resultModel.memberNm}</span>
                                            </div>
                                        </li>
                                        <li class="review_view_text">
                                            <c:set value="${resultModel.content}" var="data"/>
                                            <c:set value="${fn:replace(data, cn, br)}" var="content"/>
                                            ${content}<br>
                                            <%-- ${resultModel.content} --%>
                                            <c:if test="${resultModel.imgFilePath ne null}">
                                                <img src="/image/image-view?type=BBS&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" width="100px" height="100px;" onerror="this.src='../img/product/product_300_300.gif'">
                                            </c:if>
                                        </li>
                                    </ul>
                                </li>
                            </c:otherwise>
                            </c:choose>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <li><ul class="qna_view"><li style="text-align:center">등록된 상품평 내역이 없습니다.</li></ul></li>
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
		</div>

    </div>
    <!---// 마이페이지 메인 --->


<!--- popup 상품평쓰기 --->
<div id="popup_review_write" style="display: none;">

    <div class="product_head">
		<!-- <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button> -->
		상품평쓰기
	</div>
	<div class="product_review_top">
		<div class="review_warning">
			허위, 과대광고, 비방, 표절, 도용 등의 내용은 통보 없이 삭제 될 수 있습니다.
		</div>
	</div>
    <div class="product_review_area" style="border-top:1px solid #000;margin-top:-1px">
        <form:form id="form_id_update">
        <input type="hidden" name="mode" id="mode" value="insert"/>
        <input type="hidden" name="bbsId" id="bbsId" value="review"/>
        <input type="hidden" name="lettNo" id="lettNo" value=""/>
        <input type="hidden" name="goodsNo" id="goodsNo" value="${so.goodsNo}"/>

        <ul class="product_review_list" style="margin-top:0">
            <li class="form" style="border-top:none;">
				<span class="title">상품평가</span>
				<p class="star_detail">
					<!-- <input type="radio" id="star05" name="score" value="5">
                    <label for="star05">
                        <span></span>
                        <div class="star_groups" title="별점평가 별5개" style="margin-top:6px">
                            <img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별">
                        </div>
                    </label> -->

                    <div class="list_selectBox">
						<span class="selected" style="width:170px"></span>
						<span class="selectArrow"></span>
						<div class="selectOptions" style="width:188px">
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
					<textarea style="width:calc(100% - 14px);height:20px" name="title" id="title"></textarea>
				</p>
			</li>
			<li class="form">
				<span class="title">첨부이미지</span>
				<p class="detail">
					<input type="text" id="filename" class="floatL" readonly="readonly" style="width:calc(100% - 14px);">
                    <div class="file_up">
                        <button type="button" class="btn_fileup" value="Search files">찾아보기</button>
                        <input type="file" name="imageFile" id="input_id_image" accept="image/*" style="width:100%" onchange="document.getElementById('filename').value=this.value">
                        <input type="hidden" id="imgYn" name= "imgYn" >
                        <input type="hidden" id="imgOldYn" name= "imgOldYn">
                    </div>
                    <span id="span_imgFile"></span>
                    <span class="desc_txt"> ※ 첨부 이미지는 1Mb 미만의 gif, jpge, png 파일만 등록 가능합니다.</span>
				</p>
			</li>
			<li class="form">
				<span class="title">상품평</span>
				<p class="detail">
					<textarea style="width:calc(100% - 14px);height:80px" name="content" id="content"></textarea>
				</p>
			</li>
        </ul>
        </form:form>
	<div class="btn_review_area">
		<button type="button" class="btn_review_ok" id="btn_review_cofirm">등록</button>
		<button type="button" class="btn_review_cancel" id="btn_review_cancel">취소</button>
	</div>
</div>
</div>
<!---// popup 상품평쓰기 --->
    </t:putAttribute>
</t:insertDefinition>