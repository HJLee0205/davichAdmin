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
    <sec:authentication var="user" property='details'/>
	<script>
	
    $(document).ready(function(){
    	var totalpage = ${questionList.getTotalPages()};
        //페이징
        //$('#div_question_paging').grid(jQuery('#form_question_search'));
        
        $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
     		var url = '${_MOBILE_PATH}/front/question/ajax-question-paging?goodsNo=${so.goodsNo}&'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if(totalpage==pageIndex){
		        	$('#div_question_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('.qna_list').append(result);

		        $('.qna_list li .tit').click(function() {
					$(this).parent().next('.question').slideToggle();
				})
	        })
         });
        
        /*상품평 쓰기*/
        $('#btn_write_question').on('click', function() {
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
                setDefaultQuestionForm();
                Dmall.LayerPopupUtil.open($('#popup_question_write'));
            }
        });
        
     	// 마이페이지 문의하기 클릭시 문의팝업 바로 띄우는 처리
     	var opt = "${so.opt}";
        if(opt == "inquiry"){
        	$('#btn_write_question').click();
        	$('html, body').animate({ scrollTop: "300"}, 'slow');
        }

        /*상품문의 등록/수정*/
        $('#btn_question_confirm').on('click', function() {
        	if($('#form_id_question #title').val() == ''){
        		Dmall.LayerUtil.alert('제목을 입력해주세요.') ;
        		return false;
        	}
			if($('#form_id_question #content').val() == ''){
				Dmall.LayerUtil.alert('내용을 입력해주세요.') ;
        		return false;
        	}
            if($('#form_id_question #mode').val() == 'insert'){
                var url = '${_MOBILE_PATH}/front/question/question-insert';
            }else{
                var url = '${_MOBILE_PATH}/front/question/question-update?';
                /* if($('#form_id_question #emailRecvYn').is(':checked')){
                    $('#form_id_question #replyEmailRecvYn').val("Y");
                }else{
                    $('#form_id_question #replyEmailRecvYn').val("N");
                    $('#form_id_question #email').val("");
                } */
            }
            var param = jQuery('#form_id_question').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerPopupUtil.close('popup_question_write');   //수정후 레이어팝업 닫기
                    //location.href = '${_MOBILE_PATH}/front/question/question-list-ajax?goodsNo=${so.goodsNo}'; //목록화면 갱신
                    ajaxQuestionList();
                }
            });
        });

        /* 상품문의수정 팝업 닫기*/
        $('#btn_question_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_question_write');
        });

        /* 배송/반품/환불 안내 */
        $('[id^=btn_extra]').off('click').on('click',function (){
            $('.shopping_info_list').html($('.shopping_info_list').html().replace(/(\r\n|\n\r|\r|\n)/g, ""));
            $("#tabs_content").html($('#extraInfo').html());

            //Dmall.LayerPopupUtil.open($('#extraInfo'));
        });


        $('.qna_list li .tit').click(function() {
            $(this).parent().next('.question').slideToggle();
        })

    });

    /*상품문의 상세조회*/
    function selectQuestion(idx){
        var url = '${_MOBILE_PATH}/front/question/question-detail',dfd = jQuery.Deferred();
        var param = {lettNo: idx};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $('#form_id_question #mode').val("update");
                $('#form_id_question #title').val(result.data.title);
                $('#form_id_question #content').val(result.data.content);
                $('#form_id_question #lettNo').val(idx);
                /* if(result.data.replyEmailRecvYn == 'Y'){
                    $("input[name='emailRecvYn']:checkBox").prop('checked',true);
                    $('#email').val(result.data.email);
                } */
                Dmall.LayerPopupUtil.open($('#popup_question_write'));
            }else{
                Dmall.LayerUtil.alert("데이터를 가져올수 없습니다.", "오류");
            }
        });
    };

    /*상품문의 삭제*/
    function deleteQuestion(idx){
        Dmall.LayerUtil.confirm('상품후기를 삭제하시겠습니까?', function() {
            var url = '${_MOBILE_PATH}/front/question/question-delete';
            var param = {'lettNo' : idx,'bbsId' : "question"};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href = '${_MOBILE_PATH}/front/question/question-list-ajax?goodsNo=${so.goodsNo}'; //목록화면 갱신
                 }
            });
        })
    }
    function setDefaultQuestionForm(){
        $('#form_id_question #mode').val("insert");
        $('#form_id_question #title').val("");
        //$('#form_id_question #email').val();
        //$("#form_id_question input[name='emailRecvYn']:checkBox").prop('checked',false);
        $('#form_id_question #content').val("");
    }
    </script>
		<div class="tabs_content">
			<div class="top_qna">
				<p class="text">총 <em>${questionList.filterdRows}</em>개의 상품문의</p>
				<button type="button" class="btn_go_review" id="btn_write_question" name="btn_write_question">상품문의하기</button>
			</div>
			<form action="" id="formBbsLettReply">
				<input type="hidden" id="grpNo" name="grpNo"/>
				<input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}"/>
				<input type="hidden" id="titleNo" name="titleNo"/>
				<input type="hidden" id="lvl" name="lvl"/>
				<input type="hidden" id="lettLvl" name="lettLvl"/>
				<input type="hidden" name="replyLettNo" id="replyLettNo">
				<input type="hidden" name="memberNo" id = "memberNo" value = "${so.regrNo}">

				<input type="hidden" name="emailSendYn" id="emailSendYn">
				<input type="hidden" name="smsSendYn" id="smsSendYn">
				<input type="hidden" name="replyContent" id="replyContent">
				<input type="hidden" name="replyTitle" id="replyTitle">
			</form>

			<form:form id="form_question_search" commandName="so" action="${_MOBILE_PATH}/front/question/question-list-ajax">
			<form:hidden path="page" id="page" />
			<ul class="qna_list product">
				<c:choose>
				<c:when test="${fn:length(questionList.resultList) > 0}">
				<c:forEach var="resultModel" items="${questionList.resultList}" varStatus="status">
				<c:if test="${resultModel.lvl eq '0' || resultModel.lvl eq null}">
				<li data-bbs-nm="${so.bbsNm}" data-regr-no="${so.regrNo}" data-title-no="${so.titleNo}">
					<p class="tit">
						<%-- 비밀글 --%>
						<c:choose>
							<c:when test="${resultModel.sectYn eq 'Y'}">
								<c:if test="${resultModel.loginId eq user.session.loginId }">
									<c:set var="title" value="<img src='${_SKIN_IMG_PATH}/community/icon_free_lock.png' alt='비밀글'>  ${resultModel.title}."/>
								</c:if>
								<c:if test="${resultModel.loginId ne user.session.loginId }">
									<c:set var="title" value="<img src='${_SKIN_IMG_PATH}/community/icon_free_lock.png' alt='비밀글'>  비밀글입니다."/>
								</c:if>
							</c:when>
							<c:otherwise>
								<c:set var="title" value="${resultModel.title}"/>
							</c:otherwise>
						</c:choose>
						${title}
					</p>
					<span class="user_name">${StringUtil.maskingName(resultModel.memberNm)}</span>
					<span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></span>
					<c:if test="${resultModel.replyStatusYn == 'Y'}" ><span class="qna_labelR">답변완료</span></c:if>
					<c:if test="${resultModel.replyStatusYn != 'Y'}" ><span class="qna_labelG">답변대기</span></c:if>

				</li>
					<%-- 비밀글 --%>
					<c:choose>
						<c:when test="${resultModel.sectYn eq 'Y'}">
							<c:if test="${resultModel.loginId eq user.session.loginId }">
								<li class="question" style="display: none;">
									<div class="text_area">
										<c:set value="${resultModel.content}" var="data"/>
										<c:set value="${fn:replace(data, cn, br)}" var="content"/>
											${content}
									</div>
									<div class="btn_area">
										<c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
											<c:if test="${resultModel.replyStatusYn != 'Y'}" >
												<button type="button" onclick="selectQuestion('${resultModel.lettNo}');" class="btn_modify">수정</button>
												<button type="button" onclick="deleteQuestion('${resultModel.lettNo}');">삭제</button>
											</c:if>
										</c:if>
									</div>
									<%-- 답변 --%>
									<c:if test="${resultModel.replyStatusYn == 'Y'}" >
										<c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
											<c:if test="${resultModel.lettNo eq replyList.grpNo}">
												<div class="anwser_area">
													<em>[답변]</em>${replyList.title}<br>
													<c:set value="${replyList.content}" var="rdata"/>
													<c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
														${rcontent}
														<%--<span class="date">관리자 <em>2018-01-08 18:02</em></span>--%>
												</div>
											</c:if>
										</c:forEach>
									</c:if>
									<%--// 답변 --%>
								</li>
							</c:if>
							<c:if test="${resultModel.loginId ne user.session.loginId }">
								<li class="question" style="display: none;">
								<div class="text_area">
									비밀글입니다.
								</div>
								</li>

							</c:if>
						</c:when>
						<c:otherwise>
							<li class="question" style="display: none;">
								<div class="text_area">
									<c:set value="${resultModel.content}" var="data"/>
									<c:set value="${fn:replace(data, cn, br)}" var="content"/>
										${content}
								</div>
								<div class="btn_area">
									<c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
										<c:if test="${resultModel.replyStatusYn != 'Y'}" >
											<button type="button" onclick="selectQuestion('${resultModel.lettNo}');" class="btn_modify">수정</button>
											<button type="button" onclick="deleteQuestion('${resultModel.lettNo}');">삭제</button>
										</c:if>
									</c:if>
								</div>
								<%-- 답변 --%>
								<c:if test="${resultModel.replyStatusYn == 'Y'}" >
									<c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
										<c:if test="${resultModel.lettNo eq replyList.grpNo}">
											<div class="anwser_area">
												<em>[답변]</em>${replyList.title}<br>
												<c:set value="${replyList.content}" var="rdata"/>
												<c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
													${rcontent}
													<%--<span class="date">관리자 <em>2018-01-08 18:02</em></span>--%>
											</div>
										</c:if>
									</c:forEach>
								</c:if>
								<%--// 답변 --%>
							</li>
						</c:otherwise>
					</c:choose>


				</c:if>
				</c:forEach>
				</c:when>
				<c:otherwise>
					<li style="text-align:center">상품문의 내역이 없습니다.</li>
				</c:otherwise>
				</c:choose>
			</ul>
				<%--- 페이징 ---%>
				<div class="tPages" id=div_question_paging>
					<grid:paging resultListModel="${questionList}" />
				</div>
				<%---// 페이징 ---%>
			</form:form>
		</div>
	<%--</div>	--%>

	<%--- popup 글쓰기 ---%>
	<div id="popup_question_write" style="display: none;">
		<!-- <div id="middle_area"> -->
			<form id="form_id_question" action="${_MOBILE_PATH}/front/question/question-update">
	        <input type="hidden" name="mode" id="mode" value="insert"/>
	        <input type="hidden" name="bbsId" id="bbsId" value="question"/>
	        <input type="hidden" name="lettNo" id="lettNo" value=""/>
	        <input type="hidden" name="goodsNo" id="goodsNo" value="${so.goodsNo}"/>
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
							<textarea id="content" name="content" rows="7"></textarea>
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
				<button type="button" class="btn_alert_cancel" id="btn_question_cancel">취소</button>
				<button type="button" class="btn_alert_ok" id="btn_question_confirm">등록</button>
			</div>
		<!-- </div>	 -->
	
	</div>
	<%---// popup 글쓰기 ---%>

		<%---// 배송/반품/환불 안내 ---%>
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
		<%---// 배송/반품/환불 안내 ---%>
<%--

	</t:putAttribute>
</t:insertDefinition>--%>
