<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 문의/후기</t:putAttribute>


	<t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
    	
    	var customerCd = '${so.customerCd}';    	
    	//탭 활성화
    	activeTab(customerCd);
    	
        //1:1문의 검색
        $('#btn_qna_search').on('click', function() {
            var searchVal = $("#qna_search").val();
            var param = {searchVal : searchVal, faqGbCd:'', searchKind:'customerMain'};
            var url = "/front/customer/faq-list";
            Dmall.FormUtil.submit(url, param)
        });
        

        //1:1문의 검색
        $('#btn_id_insert').on('click', function(e) {
           location.href = "inquiry-insert-form";
       	});

            
        
        // 게시글 등록 함수
        jQuery('#insertInquiry').on('click', function(e) {
            if(jQuery('#inquiryCd').val() == 0){
                Dmall.LayerUtil.alert("문의유형을 선택해주세요.");
                return;
            }
            if(jQuery('#title').val() == ""){
                Dmall.LayerUtil.alert("제목을 입력해주세요.");
                return;
            }
            if(jQuery('#content').val() == ""){
                Dmall.LayerUtil.alert("문의글 내용을 입력해주세요.");
                return;
            }
            var url = '/front/customer/inquiry-insert';
            var param = $('#insertForm').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if (result.success) {
                    location.href = "/front/customer/inquiry-list";
                }
            })
        });
        
        /*상품문의 수정*/
        $('#btn_question_confirm').on('click', function() {
            var url = '/front/question/question-update',dfd = jQuery.Deferred();
            if($('#emailRecvYn').is(':checked')){
                $('#replyEmailRecvYn').val("Y");
            }else{
                $('#replyEmailRecvYn').val("N");
                $('#email').val("");
            }
            var param = jQuery('#form_question_update').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerPopupUtil.close('popup_question_write');   //수정후 레이어팝업 닫기
                    location.href= "/front/customer/inquiry-list?customerCd=question";//목록화면 갱신
                }
            });
        });
        /* 상품문의수정 팝업 닫기*/
        $('#btn_question_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_question_write');
        });
        
       //상품문의검색
        $('#btn_question_search').on('click', function() {
            var data = $('#form_question_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
              Dmall.FormUtil.submit('/front/customer/inquiry-list', param);  
        });
        //페이징

        $('#div_inquiry_search').grid(jQuery('#form_inquiry_search'));
        $('#div_question_search').grid(jQuery('#form_question_search'));
        $('#div_review_search').grid(jQuery('#form_review_search'));
        


        /*상품평 수정*/
        $('#btn_review_cofirm').on('click', function() {
            var url = '/front/review/review-update',dfd = jQuery.Deferred();
            if (Dmall.FileUpload.checkFileSize('form_review_update')) {
                $('#form_review_update').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        //Dmall.validate.viewExceptionMessage(result, 'form_review_update');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('popup_review_write');   //수정후 레이어팝업 닫기
                            Dmall.LayerUtil.alert(result.message).done(function(){
                                location.reload();
                            });
                        }
                    }
                });
            }
        });

        /* 상품평수정 팝업 닫기*/
        $('#btn_review_cancel').on('click', function() {
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
            }
            
        });
        
    });
    	/* 상품상세보기 */
		function goodsDetail(goodsNo){
   		  location.href = "/front/goods/goods-detail?goodsNo="+goodsNo;
 		}
    
        /*상품문의 상세조회*/
        function selectQuestion(idx){
            var url = '/front/question/question-detail' 
            var dfd = jQuery.Deferred();
            var param = {lettNo: idx};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    $('#title').val(result.data.title);
                    $('#content').val(result.data.content);
                    $('#lettNo').val(idx);
                    if(result.data.replyEmailRecvYn == 'Y'){
                        $("input[name='emailRecvYn']:checkBox").prop('checked',true);
                        $('#email').val(result.data.email);
                    }
                    Dmall.LayerPopupUtil.open($('#popup_question_write'));
                }else{
                    Dmall.LayerUtil.alert("데이터를 가져올수 없습니다.", "오류");
                }
            });
        }

        /*상품문의 삭제*/
        function deleteQuestion(idx){
            Dmall.LayerUtil.confirm('상품문의를 삭제하시겠습니까?', function() {
                var url = '/front/question/question-delete';
                var param = {'lettNo' : idx,'bbsId' : "question"};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         location.href= "/front/customer/inquiry-list?customerCd=question";
                     }
                });
            })
        }
        
        /*상품후기 상세조회*/
        function selectReview(idx){
            var url = '/front/review/review-detail'
            var dfd = jQuery.Deferred();
            var param = {lettNo: idx};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    $("#title1").val(result.data.title);
                    $("#content1").val(result.data.content);
                    $('#lettNo1').val(idx);
                    if(result.data.atchFileArr != null) {
                        var imgPath = "<img src='${_IMAGE_DOMAIN}/image/image-view?type=BBS&path="+result.data.atchFileArr[0].filePath+"&id1="+result.data.atchFileArr[0].fileNm+"' style='width:65px;height:65px;'>";
                        var button = "<img src='../img/product/btn_reply_del.gif' alt='삭제' style='cursor:hand' onclick='return delOldImgFileNm(\""+result.data.atchFileArr[0].fileNo+"\")'>";
                        $('#span_imgFile').html(imgPath+button);
                        $('#imgOldYn').val('Y');
                    }
                    $("input[name='score']:radio[value='"+result.data.score+"']").prop('checked',true);
                    Dmall.LayerPopupUtil.open($('#popup_review_write'));
                }else{
                    Dmall.LayerUtil.alert("데이터를 가져올수 없습니다.", "오류");
                }
            });
        }

        /*상품후기 삭제*/
        function deleteReview(idx){
            Dmall.LayerUtil.confirm('상품후기를 삭제하시겠습니까?', function() {
                var url = '/front/review/review-delete';
                var param = {'lettNo' : idx, 'bbsId':'review'};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         location.href= "/front/customer/inquiry-list?customerCd=review";
                     }
                });
            })
        }
        
   		/*탭 변경 */
        function activeTab(customerCd) {
        	if(customerCd === 'inquiry') {
                $("#tab01").addClass('active');
                $("#tab02").removeClass('active');
                $("#tab03").removeClass('active');
                $("#tab1").fadeIn();
                $("#tab2").hide();
                $("#tab3").hide();
            } else if(customerCd === 'question') {                
                $("#tab01").removeClass('active');
                $("#tab02").addClass('active');
                $("#tab03").removeClass('active');
                $("#tab1").hide();
                $("#tab2").fadeIn();
                $("#tab3").hide();
            } else if(customerCd === 'review') {
                $("#tab01").removeClass('active');
                $("#tab02").removeClass('active');
                $("#tab03").addClass('active');
                $("#tab1").hide();
                $("#tab2").hide();
                $("#tab3").fadeIn();
            }
        }

    /*1:1 문의 삭제*/
    function deleteInquiry(lettNo, memberNo){
        Dmall.LayerUtil.confirm('1:1문의를 삭제하시겠습니까?', function() {
            var url = '/front/customer/inquiry-delete';
            var param = {'lettNo' : lettNo,'bbsId' : "inquiry", 'delrNo' : memberNo};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    location.href = '${_MOBILE_PATH}/front/customer/inquiry-list';
                }
            });
        })
    }
        
  //게시판 이미지파일 삭제
    function delOldImgFileNm(fileNo){
        var url = '/front/review/attach-file-delete';
        var param = {fileNo:fileNo,bbsId:"review"};

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            $("#span_imgFile").html("");
            $("#imgOldYn").val("");
        });
        return;
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
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- category header 카테고리 location과 동일 --->
         <!--- category header --->
		    <!--- 마이페이지 category header 메뉴 --->
		    <%@ include file="include/mypage_category_menu.jsp" %>
		    <!---// 마이페이지 category header 메뉴 --->
    <!--- 02.LAYOUT: 마이페이지 --->
  
	<!--- 02.LAYOUT: 마이페이지 --->
     <div class="mypage_middle">	 
		<!-- snb -->
		<div id="mypage_snb">			
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->		
		</div>
		<!--// snb -->

		<!-- content -->
		<div id="mypage_content">
		
			  <!--- 마이페이지 탑 메뉴 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
	          <!---// 마이페이지 탑 메뉴 ---> 
			<div class="mypage_body">
				<h3 class="my_tit">문의/후기</h3>

				<ul class="my_tabs">
					<li rel="tab1" style="width:214px" id="tab01">1:1 문의</li>
					<li rel="tab2" style="width:214px" id="tab02">상품문의</li>
					<li rel="tab3" style="width:214px" id="tab03">상품후기</li>
				</ul>

				<!--- tab01: 1대1문의 --->
				<div class="my_tabs_content" id="tab1">
				<form:form id="form_inquiry_search" commandName="inquirySo">
				<form:hidden path="page" />
        		<input type="hidden" name="customerCd" value="inquiry"/>
					<div class="my_qna_info">					
						<span class="icon_purpose">다비치마켓에 이용에 대한 문의내용을 남겨주시면 관리자 확인 후 신속히 답변 드리겠습니다.</span>
						<button type="button" class="btn_qna" id = "btn_id_insert">문의하기<i></i></button>
					</div>
					<table class="tProduct_Board my_qna_table02">
						<caption>
							<h1 class="blind">상품문의 게시판 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:126px">
							<col style="">
							<col style="width:144px">
							<col style="width:144px">
						</colgroup>
						<thead>
							<tr>
								<th>문의유형</th>
								<th>제목/내용</th>
								<th>상태</th>
								<th>등록일</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
		                        <c:when test="${resultListModel.resultList ne null}">
		                        <c:forEach var="inquiryList" items="${resultListModel.resultList}" varStatus="status">
		                        <c:if test="${inquiryList.lvl eq '0' || inquiryList.lvl eq null}" >
		                        <tr class="title">
		                            <td>${inquiryList.inquiryNm}</td>
		                            <td class="textL">${inquiryList.title}</td>
		                            <td><c:if test="${inquiryList.replyStatusYn == 'Y'}" ><span class="label_anwser">답변완료</span></c:if><c:if test="${inquiryList.replyStatusYn != 'Y'}" ><span class="label_wait">답변대기</span></c:if></td>
		                            <td>
		                                <fmt:formatDate pattern="yyyy-MM-dd" value="${inquiryList.regDttm}" />
		                                </br><fmt:formatDate pattern="aa hh:mm:ss" value="${inquiryList.regDttm}" />
		                            </td>
		                        </tr>
		                        <tr class="hide">
		                            <td colspan="4" class="my_qna_view">${inquiryList.content}
                                        <c:if test="${inquiryList.replyStatusYn != 'Y'}" >
                                            <div class="btn_modify_area">
                                                <button type="button" class="btn_my_modify_del" onclick="deleteInquiry('${inquiryList.lettNo}', '${inquiryList.regrNo}');">삭제</button>
                                            </div>
                                        </c:if>
		                            </td>
		                        </tr>
		                        </c:if>
		                        <c:if test="${inquiryList.lvl eq '1'}" >
		                            <tr class="title">
		                                <td></td>
		                                <td class="textL">
		                                    <span class="icon_reply">답변</span>
		                                    ${inquiryList.title}
		                                </td>
		                                <td></td>
		                                <td>
		                                <fmt:formatDate pattern="yyyy-MM-dd" value="${inquiryList.regDttm}" />
		                                </br><fmt:formatDate pattern="aa hh:mm:ss" value="${inquiryList.regDttm}" />
		                                </td>
		                            </tr>
		                            <tr class="hide">
		                                <td colspan="4" class="my_qna_view">${inquiryList.content}</td>
		                            </tr>
		                        </c:if>
		                        </c:forEach>
		                        </c:when>
		                        <c:otherwise>
		                            <tr>
		                                <td colspan="7">조회된 데이터가 없습니다.</td>
		                            </tr>
		                        </c:otherwise>
		                    </c:choose>
                    	</tbody>
					</table>
					<!-- pageing -->
		                <div class="tPages" id="div_inquiry_search">
		                    <grid:paging resultListModel="${resultListModel}" />
		                </div>
					<!--// pageing -->
					</form:form>
				</div>
				<!---// tab01: 1대1문의 --->

				<!--- tab02: 상품문의 --->
				<div class="my_tabs_content" id="tab2">
				<form:form id="form_question_search" commandName="questionSo">
				<form:hidden path="page" />
        		<input type="hidden" name="customerCd" value="question"/>
					<div class="my_qna_info">					
						<span class="icon_purpose">다비치마켓 상품에 대해 문의하신 내역입니다.</span>	                       	                       
						<div class="my_search_area">							
							<select name="qstSearchKind" id="searchKind">
								<option value="all">전체</option>
								<option value="searchBbsLettTitle">제목</option>
		                        <option value="searchBbsLettContent">내용</option>
							</select>							
							<div class="my_list_search">
								<input type="text" class="form_search" name="qstSearchVal" id="searchVal" value="${questionSo.searchVal}"><button type="" class="btn_list_search" id="btn_question_search">검색</button>
							</div>
						</div>
					</div>
					<table class="tProduct_Board my_qna_table02">
						<caption>
							<h1 class="blind">상품문의 게시판 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:126px">
							<col style="">
							<col style="width:120px">
							<col style="width:130px">
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th>상품문의</th>
								<th>상태</th>
								<th>등록일</th>
							</tr>
						</thead>
						<tbody>
		                    <c:choose>
		                        <c:when test="${questionListModel.resultList ne null}">
		                            <c:forEach var="resultModel" items="${questionListModel.resultList}" varStatus="status">
		                                <c:choose>
		                                    <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
												<tr class="title">
													<td class="noline">
														<div class="qna_img">
															<img src="${_IMAGE_DOMAIN}${resultModel.goodsDispImgC}" alt="">
															<!--  goodsImg -- goodsDispImgC -->
														</div>
													</td>
													<td class="textL">
														<p class="option">${resultModel.goodsNm} </p>
														${resultModel.title}														
													</td>
													<td><c:if test="${resultModel.replyStatusYn eq 'Y'}" ><span class="label_anwser">답변완료</span></c:if>
	                                                    <c:if test="${resultModel.replyStatusYn ne 'Y'}" ><span class="label_wait">답변대기</span></c:if>
	                                                </td>
													<td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
												</tr>
												<tr class="hide">
		                                            <td colspan="5" class="qna_view02">
		                                            ${resultModel.content} 
		                                            
		                                                <div class="btn_modify_area">
		                                                	<c:if test="${resultModel.goodsNo ne null && resultModel.goodsNo != ''}" >
																<button type="text" class="btn_product_detailview" onclick="javascript:goodsDetail('${resultModel.goodsNo}'); return false;">상품상세정보</button>
															</c:if>
															<c:if test="${resultModel.replyStatusYn != 'Y'}" >
																<div class="right">
				                                                    <button type="button" class="btn_my_modify" onclick="selectQuestion('${resultModel.lettNo}');">수정</button>
				                                                    <button type="button" class="btn_my_modify_del" onclick="deleteQuestion('${resultModel.lettNo}');">삭제</button>
																</div>													
		                                            		</c:if>
		                                                </div>
		                                            </td>
		                                        </tr>
		                                    </c:when>
		                                     <c:otherwise>
		                                        <tr class="title">
													<td></td>
		                                            <td class="textL">
		                                                <span class="icon_reply">답변</span>
		                                                ${resultModel.title}
		                                            </td>
		                                            <td></td>
		                                            <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
		                                        </tr>
		                                        <tr class="hide">
		                                            <td colspan="5" class="my_qna_view">${resultModel.content}</td>
		                                        </tr>
		                                    </c:otherwise>
		                                </c:choose>
		                            </c:forEach>
		                        </c:when>
		                        <%-- <c:otherwise>
		                            <tr>
		                                <td colspan="5">상품문의 내역이 없습니다.</td>
		                            </tr>
		                        </c:otherwise> --%>
		                    </c:choose>
						</tbody>
					</table>
					<!-- pageing -->
		                <div class="tPages" id="div_question_search">
		                    <grid:paging resultListModel="${questionListModel}" />
		                </div>
					<!--// pageing -->
				</form:form>
				</div>
				<!---// tab02: 상품문의 --->

				<!--- tab03: 상품후기 --->
				<div class="my_tabs_content" id="tab3">
				<form:form id="form_review_search" commandName="reviewSo">
				<form:hidden path="page" />
        		<input type="hidden" name="customerCd" value="review"/>
					<div class="my_qna_info">					
						<span class="icon_purpose">다비치마켓에서 구매하신 상품에 대해 직접 남겨주신 후기 내역입니다.</span>
						<div class="my_search_area">							
							<select name="rvSearchKind" id="searchKind">
								<option value="all">전체</option>
								<option value="searchBbsLettTitle">제목</option>
		                        <option value="searchBbsLettContent">내용</option>
							</select>						
							<div class="my_list_search">
								<input type="text" class="form_search" name="rvSearchVal" value="${reviewSo.searchVal}"><button type="" class="btn_list_search">검색</button>
							</div>
						</div>
					</div>
					<table class="tProduct_Board my_qna_table02">
						<caption>
							<h1 class="blind">상품후기 게시판 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:126px">
							<col style="">
							<col style="width:130px">
							<col style="width:130px">
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th>상품문의</th>
								<th>평점</th>
								<th>등록일</th>
							</tr>
						</thead>
						<tbody>
								<c:choose>
		                        <c:when test="${reviewListModel.resultList ne null}">
		                            <c:forEach var="resultModel" items="${reviewListModel.resultList}" varStatus="status">
		                            <c:choose>
		                                <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
		                                    <tr class="title">
		                                        <%-- <td>${resultModel.rowNum}</td> --%>
		                                        <td class="pix_img">
		                                            <c:if test="${resultModel.imgFilePath ne null}">
									                	<a href="${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" target="_blank">
									                    	<div class="img_area"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" width="100px" height="100px;" onerror="this.onerror=null;this.src='${_SKIN_IMG_PATH}/product/icon_review.png';this.style.width=0;this.style.height=0;"></div>
									                    </a>
									                </c:if>
									                <c:if test="${resultModel.imgFilePath eq null}">
									                    <div class="img_area"></div>
									                </c:if>
		                                        </td>
		                                        <td class="textL">
													<p class="option">${resultModel.goodsNm}</p>
		                                         	${resultModel.title}
		                                        </td>
		                                        <td>
		                                            <div class="star_groups">
		                                                <c:forEach begin="1" end="${resultModel.score}" ><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"></c:forEach>
		                                            </div>
		                                        </td>
		                                        <%-- <td class="textL">
		                                            ${resultModel.title}
		                                        </td>
		                                        <td>${resultModel.memberNm}</td> --%>
		                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
		                                    </tr>
		                                    <tr class="hide">
			                                    <td colspan="5" class="qna_view02">
													<div>
														${resultModel.content}
														<div class="btn_modify_area">
															<button type="text" class="btn_product_detailview" onclick="javascript:goodsDetail('${resultModel.goodsNo}'); return false;">상품상세정보</button>
															<div class="right">
																<button type="text" class="btn_my_modify" onclick="javascript:selectReview('${resultModel.lettNo}'); return false;">수정</button>
																<button type="text" class="btn_my_modify_del" onclick="javascript:deleteReview('${resultModel.lettNo}'); return false;">삭제</button>
															</div>
														</div>
													</div>
												</td>
		                                    </tr>
		                                </c:when>
		                                <c:otherwise>
		                                    <tr class="title">
		                                        <td></td>
		                                        <td class="textL"><span class="icon_reply">답변</span>${resultModel.title}</td>
		                                        <td></td>
		                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
		                                    </tr>
		                                    <tr class="hide">
		                                        <td colspan="5" class="qna_view02">
		                                        	<div class="a_area">
		                                            ${resultModel.content}
		                                            </div>
		                                        </td>
		                                    </tr>
		                                </c:otherwise>
		                            </c:choose>
		                            </c:forEach>
		                        </c:when>
		                        <c:otherwise>
		                            <tr>
		                                <td colspan="7">조회된 데이터가 없습니다.</td>
		                            </tr>
		                        </c:otherwise>
		                    </c:choose>													
						</tbody>
					</table>
					<!-- pageing -->
		                <div class="tPages" id="div_review_search">
		                    <grid:paging resultListModel="${reviewListModel}" />
		                </div>
					<!--// pageing -->
					</form:form>
				</div>			
				<!---// tab03: 상품후기 --->
			</div>	
		</div>	
			
		<!--// content -->
	</div>
    <!---// 02.LAYOUT: 마이페이지 --->	
    <!---// 02.LAYOUT: 마이페이지 --->	   
    
    
    <!--- popup 글쓰기 --->
    <div id="popup_question_write" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">상품문의수정</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <form id="form_question_update" action="/front/question/question-update">
            <input type="hidden" name="bbsId" id="bbsId" value="question"/>
            <input type="hidden" name="lettNo" id="lettNo" value=""/>
            <input type="hidden" name="replyEmailRecvYn" id="replyEmailRecvYn" value=""/>

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
                    <%--
                    <tr>
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
                    </tr>
                     --%>
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
    <!---// popup 글쓰기 --->
    <!--- popup 상품평쓰기 --->
    <div id="popup_review_write" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">상품후기 쓰기</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <form:form id="form_review_update">
	        <input type="hidden" name="mode" id="mode" value="update"/>
	        <input type="hidden" name="bbsId" id="bbsId" value="review"/>
	        <input type="hidden" name="lettNo" id="lettNo1" value=""/>
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
                        <td colspan="4" class="textL"><input type="text" style="width:100%" name="title" id="title1"></td>
                    </tr>
                    <tr>
                        <th style="vertical-align:top">내용</th>
                        <td colspan="4" class="textL"><textarea style="height:105px;width:100%;box-sizing:border-box"  placeholder="내용 입력" name="content" id="content1"></textarea></td>
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
    
    </t:putAttribute>
</t:insertDefinition>