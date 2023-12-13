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
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">이벤트 상세</t:putAttribute>
	
	<t:putAttribute name="script">
	    <script type="text/javascript">
		    jQuery(document).ready(function() {
	            //본인의 댓글삭제버튼만 보이게 하기위한 변수, 실제 운영시에는 아래 주석을 해제하여야 한다.
	            EventUtil.memberNo = "${lettSo.memberNo}";
	            //EventUtil.memberNo = 1000;
	            
	            EventUtil.btnHide();
	            
	          //비회원 댓글쓰기 방지
              $('textarea').keydown(function(){
                  	if(EventUtil.memberNo === '' || EventUtil.memberNo === 0) {
                      //textarea에 계속입력하면 레이어를 무한정 오픈되기때문에 막아놓는다.
                      $('textarea').prop('disabled', true);
                      Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                          //확인버튼 클릭
                             function() {
                                 location.href = '/m/front/login/member-login';
                             }
                          //취소버튼 클릭
                          , function() {
                              $('textarea').prop('disabled', false);
                             })
                    }  
            	  
	              	var text =$('textarea').val();
	                var byteTxt = "";
	                var byte = function(str){
	                var byteNum=0;
	                for(i=0;i<str.length;i++){
		                byteNum+=(str.charCodeAt(i)>127)?2:1;
		                if(byteNum<600){
		                	byteTxt+=str.charAt(i);
                        }
                    }
                        return byteNum;
	                };
	            });
		    	
	            $('#eventCommentWrite').hide();
            	$('#div_id_paging').hide();
		    	
	            jQuery('#div_id_paging').grid(jQuery('#form_id_search'));
	            
	            $('.more_view').on('click', function() {
		        	var pageIndex = Number($('#page').val())+1;
		          	var param = "page="+pageIndex;
		          	var eventNo = ${so.eventNo};
		     		var url = '${_MOBILE_PATH}/front/event/event-ing-ajax?'+param+'&eventNo='+eventNo;
			        Dmall.AjaxUtil.load(url, function(result) {
				    	if('${lettSo.totalPageCount}'==pageIndex){
				        	$('#div_id_paging').hide();
				        }
				        $("#page").val(pageIndex);
				        $('.list_page_view em').text(pageIndex);
				        $('.comment_list').append(result);
			        })
		         });
		    	
		    	var eventNo=${so.eventNo}; 
		    	
		    	var url = '${_MOBILE_PATH}/front/event/event-detail',dfd = jQuery.Deferred();
		    	var param = {eventNo: eventNo};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    result.data.applyStartDttm = 
                        result.data.applyStartDttm.substring(0,4)
                        +'-'+result.data.applyStartDttm.substring(4,6)
                        +'-'+result.data.applyStartDttm.substring(6,8);
                    
                    result.data.applyEndDttm =
                        result.data.applyEndDttm.substring(0,4)
                        +'-'+result.data.applyEndDttm.substring(4,6)
                        +'-'+result.data.applyEndDttm.substring(6,8);

                    var template ='';
                   	/* template = '<img src="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&path={{eventMobileBannerImgPath}}&id1={{eventMobileBannerImg}}" alt="{{eventNm}}" style="width: 100%;" onerror="this.src=&#39;../img/event/event_ing01.jpg&#39;">'; */
					template ='{{eventContentHtml}}'; 
					
                    viewEvent = new Dmall.Template(template);
                    jQuery('#id_view_event').html(viewEvent.render(result.data));
                    
                    //이벤트 댓글 등록시 필요한 이벤트번호
                    $('#formEventNo').val(result.data.eventNo);
                    dfd.resolve(result.data);

                    //이벤트 댓글 호출
                    //result.data.eventCmntUseYn === 'Y' ? EventUtil.getLettList(eventNo) : $('#eventCommentWrite').hide();
                    if (result.data.eventCmntUseYn == 'Y') {
                    	$('#eventCommentWrite').show();
                    	$('#div_id_paging').show();
					}
                    
                    //EventUtil.getLettList(eventNo);
                    
                });
                
                return dfd.promise();
            
		    });
		    
		  	//이벤트 댓글 등록
            $('#btnInsertEventLett').on('click', function(e) {
                EventUtil.insertEventLett(e);
            });
		  	
		  	//댓글 카운트
            $(function(){
                function updateInputCount() {
                    var text =$('textarea').val();
                    var byteTxt = "";
                    var byte = function(str){
                        var byteNum=0;
                        for(i=0;i<str.length;i++){
                            byteNum+=(str.charCodeAt(i)>127)?2:1;
                            if(byteNum<600){
                                byteTxt+=str.charAt(i);
                            }
                        }
                        return byteNum;
                    };
                    $('#inputCnt').text(byte(text));
                }
                
                $('textarea')
                    .focus(updateInputCount)
                    .blur(updateInputCount)
                    .keypress(updateInputCount);
                    window.setInterval(updateInputCount,100);
                    //updateInputCount(); 
            });
	    	
		    var EventUtil = {
		  		memberNo:0,
		    
		    		 insertEventLett:function(e) {
	                    e.preventDefault();
	                    e.stopPropagation();
	                    
	                    if(parseInt($('#inputCnt').text(), 10) === 0) {
	                        Dmall.LayerUtil.alert('내용을 입력해 주십시요.','','');
	                        $('textarea').focus();
	                        return;
	                    }
	                   
	                    var url = '${_MOBILE_PATH}/front/event/event-comment-insert';
	                    var param = $('#form_id_insert').serialize();
	                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
	                        if(result.success){
	                            $('textarea').text('');
	                            //EventUtil.getLettList(result.data.eventNo);
	                            location.href="${_MOBILE_PATH}/front/event/event-ing-list?eventNo="+result.data.eventNo;
	                        } 
	                    });
	                }
	                , deleteEventLett:function(lettNo, eventNo) {
	                    Dmall.LayerUtil.confirm("삭제하시겠습니까?",
	                        function() {
	                            var url = '${_MOBILE_PATH}/front/event/event-comment-delete';
	                            var param = {lettNo:lettNo};
	                
	                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
	                                //validate.viewExceptionMessage(result, 'form_id_cmntinsert');
	                                if(result.success){
	                                    //EventUtil.getLettList(eventNo);
	                                	location.href="${_MOBILE_PATH}/front/event/event-ing-list?eventNo="+eventNo;
	                                }
	                        });
	                    });
	                    EventUtil.deleteFlag = true;
	                }
	                , btnHide:function() {
	                    $('.event_comment_view').each(function() {
	                        var dataMemberNo = parseInt($(this).find('button').attr('data-member-no'), 10);
	                        if(EventUtil.memberNo != dataMemberNo) {
	                            $(this).find('button').hide();
	                        }
	                    });
	                }
		    		
		        }
		    
        </script>
	</t:putAttribute>
	
    <t:putAttribute name="content">
    
    <div id="middle_area">
		<div class="event_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			이벤트
		</div>
		
		<!-- 진행중인 이벤트 -->
		<h2 class="event_stit">
			<span>진행중인 이벤트</span>
		</h2>
		
		<form id="form_id_ing_search">
	    <input type="hidden" name="ingPage" id="ingPage" />
			<ul class="event_content" id="id_view_event">
			</ul>
		</form>
		<!-- /진행중인 이벤트 -->
		
		<!--- event comment --->
		
		<div class="event_comment_area" id="eventCommentWrite">
			<div class="event_comment_write">
				<label for="event_comment_write"><span id="inputCnt">0</span>/300</label>
                <form:form id="form_id_insert">
                <input type="hidden" name="eventNo" id="formEventNo" />
				<textarea id="event_comment_write" name="content" placeholder="지나친 비방, 인신공격, 욕설 및 광고, 도배는 통보없이 삭제될 수 있습니다."></textarea>
				</form:form>
				<button type="button" class="btn_comment_ok" id="btnInsertEventLett">등록</button>
			</div>
			<form id="form_id_search">
            <input type="hidden" name="page" id="page" value="1" />
			<div class="comment_list">
				<c:if test="${eventLettList ne null}">
					<c:forEach var="eventLettList" items="${eventLettList.resultList}" varStatus="status">
						<div class="comment_view">
							<span class="comment_writer">
		                      		${eventLettList.loginId}
							</span>
							<div class="comment_content">
								${eventLettList.content}
								<c:set value="${eventLettList.content}" var="data"/>
									<c:set value="${fn:replace(data, cn, br)}" var="content"/>
									${content}<br>
								<div class="event_comment_view">
									<fmt:formatDate pattern="yyyy-MM-dd" value="${eventLettList.regDttm}" />
									<button type="button" id="" data-member-no="${eventLettList.memberNo}" onclick="EventUtil.deleteEventLett(${eventLettList.lettNo}, ${eventLettList.eventNo})">
										<img src="../img/web/product/btn_reply_del.gif" alt="댓글삭제">
									</button>
								</div>
							</div>
						</div>
					</c:forEach>	
				</c:if>
			</div>
		</div>	
		<!---// comment --->	
		<!--- 페이징 --->
		<div class="tPages" id="div_id_paging">
			<grid:paging resultListModel="${eventLettList}" />
		</div>
		<!---// 페이징 --->	
		</form>
		
	</div>	

    </t:putAttribute>
</t:insertDefinition>