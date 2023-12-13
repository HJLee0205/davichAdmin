<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<sec:authentication var="user" property='details'/>
<script>
    $(document).ready(function(){
        //페이징
        $('#div_question_paging').grid(jQuery('#form_question_search'),ajaxQuestionList);
        /*상품평 쓰기*/
        $('#btn_write_question').on('click', function() {
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
                setDefaultQuestionForm();
                Dmall.LayerPopupUtil.open($('#popup_question_write'));
            }
        });
        
        // 마이페이지 문의하기 클릭시 문의팝업 바로 띄우는 처리
        if("${so.opt}" == "inquiry"){
        	$('#btn_write_question').click();
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
                var url = '/front/question/question-insert';
            }else{
                var url = '/front/question/question-update';
                if($('#form_id_question #emailRecvYn').is(':checked')){
                    $('#form_id_question #replyEmailRecvYn').val("Y");
                }else{
                    $('#form_id_question #replyEmailRecvYn').val("N");
                    $('#form_id_question #email').val("");
                }
            }
            var param = jQuery('#form_id_question').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerPopupUtil.close('popup_question_write');   //수정후 레이어팝업 닫기
                    location.href = '/front/goods/goods-detail?goodsNo=${so.goodsNo}'; //목록화면 갱신
                }
            });
        });

        /* 상품문의수정 팝업 닫기*/
        $('#btn_question_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_question_write');
        });
    });


    /*상품문의 상세조회*/
    function selectQuestion(idx){
        var url = '/front/question/question-detail',dfd = jQuery.Deferred();
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
            var url = '/front/question/question-delete';
            var param = {'lettNo' : idx,'bbsId' : "question"};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href = '/front/goods/goods-detail?goodsNo=${so.goodsNo}'; //목록화면 갱신
                 }
            });
        })
    }
    function setDefaultQuestionForm(){
        $('#form_id_question #mode').val("insert");
        $('#form_id_question #title').val();
        $('#form_id_question #email').val();
        $("#form_id_question input[name='emailRecvYn']:checkBox").prop('checked',false);
        $('#form_id_question #content').val();
    }
    </script>


<form:form id="form_question_search" commandName="so" action="/front/question/question-list-ajax">
    <form:hidden path="page" id="page" />
<div class="qna_top">
    <button type="button" class="btn_qna" id="btn_write_question">문의하기<i></i></button>
</div>
<table class="tProduct_Board my_qna_table">
    <caption>
        <h1 class="blind">상품문의 게시판 목록입니다.</h1>
    </caption>
    <colgroup>
        <col style="width:86px">
        <col style="width:106px">
        <col style="">
        <col style="width:144px">
        <col style="width:144px">
    </colgroup>
    <thead>
    <tr>
        <th>번호</th>
        <th>답변상태</th>
        <th>내용</th>
        <th>구매자</th>
        <th>등록일</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${questionList.resultList ne null}">
            <c:forEach var="resultModel" items="${questionList.resultList}" varStatus="status">
                <c:choose>
                    <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
                        <tr class="title">
                            <td>${resultModel.rowNum}</td>
                            <td>
                                <c:if test="${resultModel.replyStatusYn == 'Y'}" >답변완료</c:if>
                                <c:if test="${resultModel.replyStatusYn != 'Y'}" ><span class="qna_fGray">답변대기</span></c:if>
                            </td>
                            <td class="textL">
                                    ${resultModel.title}<!-- <span class="reply_no">(${resultModel.inqCnt})</span> -->
                            </td>
                            <td>${StringUtil.maskingName(resultModel.memberNm)}</td>
                            <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                        </tr>
                        <tr class="hide">
                            <td colspan="5" class="review_view">
                                    ${resultModel.content}
                                <c:if test="${resultModel.replyStatusYn != 'Y'}">
                                    <div class="view_btn_area">
                                        <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
                                            <button type="button" class="btn_modify" onclick="selectQuestion('${resultModel.lettNo}');">수정</button>
                                            <button type="button" class="btn_del" onclick="deleteQuestion('${resultModel.lettNo}');">삭제</button>
                                        </c:if>
                                    </div>
                                </c:if>
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

                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr class="title">
                            <td>${resultModel.rowNum}</td>
                            <td>
                                <img src="/front/img/product/icon_reply.png" alt="댓글 아이콘">
                            </td>
                            <td class="textL">
                                    ${resultModel.title}
                            </td>
                            <td>${StringUtil.maskingName(resultModel.memberNm)}</td>
                            <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                        </tr>
                        <tr class="hide">
                            <td colspan="5" class="review_view">
                                    ${resultModel.content}
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <td colspan="5">
                등록된 상품 문의가 없습니다.
            </td>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>
    <!---- 페이징 ---->
    <div class="tPages" id=div_question_paging>
        <grid:paging resultListModel="${questionList}" />
    </div>
    <!----// 페이징 ---->
</form:form>
<!--- popup 글쓰기 --->
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
            <input type="hidden" name="goodsNo" id="goodsNo" value="${so.goodsNo}"/>
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
<!---// popup 글쓰기 --->
