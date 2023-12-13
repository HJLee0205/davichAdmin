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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">상품문의</t:putAttribute>
	
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	var totalpage = ${resultListModel.getTotalPages()};
    	
/*         //검색시 구분값 셋팅
        var searchKind = '${so.searchKind}';
        if(searchKind !='') {
            $("#searchKind").val(searchKind);
            $("#searchKind").trigger("change");
        }
        //검색
        $('#btn_id_search').on('click', function() {
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/question/question-list', param);
        }); */
        //페이징
        //$('#div_id_paging').grid(jQuery('#form_id_search'));
        
        $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
     		var url = '${_MOBILE_PATH}/front/question/question-pagnig?'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if(totalpage==pageIndex){
		        	$('#div_id_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('.qna_list').append(result);
	        })
         }); 

        /*상품문의 수정*/
        $('.btn_review_ok').on('click', function() {
            var url = '${_MOBILE_PATH}/front/question/question-update',dfd = jQuery.Deferred();
            /* if($('#emailRecvYn').is(':checked')){
                $('#replyEmailRecvYn').val("Y");
            }else{
                $('#replyEmailRecvYn').val("N");
                $('#email').val("");
            } */
            var param = jQuery('#form_id_update').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerPopupUtil.close('popup_question_write');   //수정후 레이어팝업 닫기
                    location.href= "${_MOBILE_PATH}/front/question/question-list";//목록화면 갱신
                }
            });
        });
        /* 상품문의수정 팝업 닫기*/
        $('.btn_review_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_question_write');
        });
    });

    /*상품문의 상세조회*/
    function selectQuestion(idx){
        var url = '${_MOBILE_PATH}/front/question/question-detail'
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
    };

    /*상품문의 삭제*/
    function deleteQuestion(idx){
        Dmall.LayerUtil.confirm('상품후기를 삭제하시겠습니까?', function() {
            var url = '${_MOBILE_PATH}/front/question/question-delete';
            var param = {'lettNo' : idx,'bbsId' : "question"};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href= "${_MOBILE_PATH}/front/question/question-list";
                 }
            });
        })
    }
    </script>
    </t:putAttribute>
    
    <t:putAttribute name="content">
    
    <div id="middle_area">	
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			상품문의
		</div>	
		<div class="product_qna_top">
			<div class="qna_warning">
				고객님께서 문의하신 내용을 확인하실 수 있습니다.
			</div>
		</div>
		<form:form id="form_id_search" commandName="so">
        <form:hidden path="page" id="page"/>
		<div class="product_qna_area">			
			<div class="product_qna_btn_area">
				<!-- <button type="button" class="btn_qna_write">상품문의 쓰기</button> -->
			</div>
			<ul class="qna_list">
				<c:choose>
                	<c:when test="${resultListModel.resultList ne null}">
                    	<c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                        	<c:choose>
                            	<c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
									<li>
										<ul class="qna_view">
											<li class="qna_view_title">
												<div class="qna_view_title_area">
													[${resultModel.goodsNm}]<br>
													${resultModel.title}
												</div>
												<span class="qna_time">
													<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" />
												</span>
												<div class="qna_check">
													<c:if test="${resultModel.replyStatusYn eq 'Y'}" >답변유무<span class="answerLB">YES</span></c:if>
                                               		<c:if test="${resultModel.replyStatusYn ne 'Y'}" >답변유무<span class="answerLR">NO</span></c:if>
												</div>
											</li>
											<li class="qna_view_text">
												<!-- 질문 -->
												<div class="qna_question_text">
													<c:set value="${resultModel.content}" var="data"/>
													<c:set value="${fn:replace(data, cn, br)}" var="content"/>
													${content}<br>
													<%-- ${resultModel.content} --%>
													<c:if test="${resultModel.replyStatusYn != 'Y'}" >
		                                                <div class="view_btn_area">
		                                                    <button type="button" class="" onclick="selectQuestion('${resultModel.lettNo}');"><span class="answerLB">수정</span></button>
		                                                    <button type="button" class="" onclick="deleteQuestion('${resultModel.lettNo}');"><span class="answerLR">삭제</span></button>
		                                                </div>
		                                            </c:if>	
												</div>
												<!--// 질문 -->
												
												<!-- 답변 -->
												<c:if test="${resultModel.replyStatusYn == 'Y'}" >
													<c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
													<c:if test="${resultModel.lettNo eq replyList.grpNo}">
														<div class="qna_answer_text">
															${replyList.title}<br>
															<c:set value="${replyList.content}" var="rdata"/>
															<c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
															${rcontent}
															<%-- ${replyList.content} --%>
														</div>
													</c:if>
												</c:forEach>
												</c:if>
												<!--// 답변 -->
																			
											</li>						
										</ul>
									</li>
								</c:when>
                          </c:choose>
                      </c:forEach>
                  </c:when>
                  <c:otherwise>
                  	<li><ul class="qna_view"><li style="text-align:center">등록된 상품문의 내역이 없습니다.</li></ul></li>
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
    

    <!--- popup 글쓰기 --->
    <div id="popup_question_write" style="display: none;">
    
	    <div id="middle_area">	
			<div class="product_head">
				<!-- <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button> -->
				상품문의 쓰기
			</div>	
			<div class="product_qna_top">
				<div class="qna_warning">
					- 상품과 관련 없는 내용, 비방, 광고, 불건전한 내용의 글은 사전동의 없이 삭제될 수 있습니다.
				</div>
			</div>
			
			<form id="form_id_update" action="${_MOBILE_PATH}/front/question/question-update">
            <input type="hidden" name="bbsId" id="bbsId" value="question"/>
            <input type="hidden" name="lettNo" id="lettNo" value=""/>
            <input type="hidden" name="replyEmailRecvYn" id="replyEmailRecvYn" value=""/>
			<div class="product_qna_area" style="border-top:1px solid #000;margin-top:-1px">
				<ul class="product_review_list" style="margin-top:0">
					<li class="form" style="border-top:none">
						<span class="title">제목</span>
						<p class="detail">
							<input type="text" style="width:calc(100% - 14px)" id="title" name="title">
						</p>
					</li>
					<li class="form" style="border-top:none">
						<span class="title">이름</span>
						<p class="detail">
							<input type="text" style="width:calc(100% - 14px)" value="${user.session.memberNm}">
						</p>
					</li>
					<li class="form">
						<span class="title">내용</span>
						<p class="detail">
							<textarea style="width:calc(100% - 14px);height:80px" id="content" name="content"></textarea>
						</p>
					</li>
					<!-- <li class="form checkbox_area">
						<span class="title">이메일</span>
						<div class="checkbox" style="margin-top:10px;color:#000">			
							<label>
								<input type="checkbox" name="select_order" id="email" name="email">
								<span></span>
							</label>
							답변글을 이메일로 받기
						</div>
					</li> -->
				</ul>
			</div>	
			</form>
			<div class="btn_review_area">
				<button type="button" class="btn_review_ok">등록</button>
				<button type="button" class="btn_review_cancel">취소</button>
			</div>
		</div>	
    
    </div>
    <!---// popup 글쓰기 --->
    </t:putAttribute>
</t:insertDefinition>