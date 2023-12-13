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
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 다비치 샘플링 2 텐션편</t:putAttribute>
    <t:putAttribute name="script">
    	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
            	Kakao.init('${snsMap.get('javascriptKey')}');
            	//본인의 댓글삭제버튼만 보이게 하기위한 변수, 실제 운영시에는 아래 주석을 해제하여야 한다.
	            EventUtil.memberNo = "${sessionMemberNo}";
	            EventUtil.btnHide();
	            
	          //비회원 댓글쓰기 방지
              $('textarea').keydown(function(){
                  	if(EventUtil.memberNo === '' || EventUtil.memberNo === 0) {
                      //textarea에 계속입력하면 레이어를 무한정 오픈되기때문에 막아놓는다.
                      $('textarea').prop('disabled', true);
                      Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                          //확인버튼 클릭
                             function() {
                    	  		 var returnUrl = window.location.pathname+window.location.search;
                                 location.href = "/m/front/login/member-login?returnUrl="+returnUrl;
                             }
                          //취소버튼 클릭
                          , function() {
                              $('textarea').prop('disabled', false);
                             })
                    }  
                  	
                 	// 댓글 권한 체크
	                var userAuth = "${user.session.integrationMemberGbCd}";
	                var cmntAuth = "${resultModel.data.eventCmntAuth}";
	                var cmntAuthNm = "${resultModel.data.eventCmntAuthNm}";
	                
	                if(cmntAuth != null && cmntAuth != ''){
	                	if(cmntAuth.indexOf(userAuth) < 0){
	                		$('textarea').prop('disabled', true);
	                		Dmall.LayerUtil.alert(cmntAuthNm+'만 입력이 허용된 댓글입니다.','','');
	                		$('#btn_id_alert_yes').click(function(){
	                			$('textarea').prop('disabled', false);	
	                		});
	                	}
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
				        $('.tEvent_Review').append(result);
			        })
		         });
	            
	          	//이벤트 댓글 등록
	            $('#btnInsertEventLett').on('click', function(e) {
	            	var eventCd = '${so.eventCd}';
	                if(eventCd === 'ing'){
	            		EventUtil.insertEventLett(e);
	              	}else{
	              		Dmall.LayerUtil.alert('지난 이벤트에는 댓글을 달 수 없습니다.','','');
	              		$('textarea').val('');
	              		return;
	              	}
	            });
		    	
		    	var eventNo=${so.eventNo}; 
		    	
		    	var url = '${_MOBILE_PATH}/front/event/m-event-detail',dfd = jQuery.Deferred();
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
					 template = '<li class="tit">{{eventNm}}</li>'+
                     			'<li class="date">{{applyStartDttm}} ~ {{applyEndDttm}}</li>'+
                     			'<li>{{eventContentHtml}}</li>';                               

                   /* 	template ='{{eventContentHtml}}';  */
					
                    viewEvent = new Dmall.Template(template);
                    jQuery('#id_view_event').html(viewEvent.render(result.data));
                    
                    //이벤트 댓글 등록시 필요한 이벤트번호
                    $('[id^=formEventNo]').val(result.data.eventNo);
                    dfd.resolve(result.data);

                    //이벤트 댓글 호출
                    //result.data.eventCmntUseYn === 'Y' ? EventUtil.getLettList(eventNo) : $('#eventCommentWrite').hide();
                    if (result.data.eventCmntUseYn == 'Y') {
                    	$('#eventCommentWrite').show();
                    	$('#div_id_paging').show();
					}
                    
                    //EventUtil.getLettList(eventNo);
                    
                });


                $('#btn_non_visit').on('click',function(){
					//공유하기 여부 조회
					if(loginYn != 'true') {
						Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
						//확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
						function() {
							$('#visitForm').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/login/member-login');
							$('#visitForm').find('#returnUrl').val(HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/event/teanseon-event');
							$('#visitForm').attr('method','post');
							$('#visitForm').submit();
						},'');
						return false;
					}

					var url = '${_MOBILE_PATH}/front/event/sns-shared-info';
					var param = {memberNo:'${sessionMemberNo}',eventNo:'${resultModel.data.eventNo}'};
					Dmall.AjaxUtil.getJSON(url, param, function(result) {
						if(result.success){
							var data = result.data;
							if(data.shareCnt > 0){
								$("#snsShareYn").val('Y');
								$('#visitForm').attr('action','${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=G2103261158_8727');
								$('#visitForm').attr('method','post');
								$('#visitForm').submit();
							}else{
								Dmall.LayerUtil.alert("공유하기를 (0/1)회 진행하셨으므로<br> 참여가 불가능 합니다.", "확인");
								return false;
							}
						}
					});
				});
                return dfd.promise();


                /*$("meta[property='og\\:title']").attr("content", '다비치 샘플링 2');
				$("meta[property='og\\:url']").attr("content", 'http://www.davichmarket.com/front/event/teanseon-event');
				$("meta[property='og\\:description']").attr("content", '다비치 샘플링 2 텐션편');
				$("meta[property='og\\:image']").attr("content", 'https://www.davichmarket.com/skin/img/event/event_210412_ts01.jpg?dt=1.2');*/
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
	                    if(parseInt($('#inputCnt').text(), 10) > 300) {
	                        Dmall.LayerUtil.alert('댓글은 최대 300자까지 입력 가능합니다.','','');
	                        $('textarea').focus();
	                        return;
	                    }
	                   
	                    var url = '${_MOBILE_PATH}/front/event/event-comment-insert';
	                    var param = $('#form_id_insert').serialize();
	                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
	                        if(result.success){
	                            $('textarea').text('');
	                            //EventUtil.getLettList(result.data.eventNo);
	                            //location.href="${_MOBILE_PATH}/front/event/event-ing-list?eventNo="+result.data.eventNo;
	                            location.reload();
	                        } 
	                    });
	                }
	                , deleteEventLett:function(lettNo, eventNo) {
	                    Dmall.LayerUtil.confirm("삭제하시겠습니까?",
	                        function() {
	                            var url = '${_MOBILE_PATH}/front/event/event-comment-delete';
	                            var param = {lettNo:lettNo,eventNo:eventNo};
	                
	                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
	                                //validate.viewExceptionMessage(result, 'form_id_cmntinsert');
	                                if(result.success){
	                                    //EventUtil.getLettList(eventNo);
	                                	//location.href="${_MOBILE_PATH}/front/event/event-ing-list?eventNo="+eventNo;
	                                	location.reload();
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

		        // 페이스북 공유하기
            function jsShareFacebook() {

				//공유하기 정보 저장
				if(loginYn != 'true') {
					Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                        $('#visitForm').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/login/member-login');
                        $('#visitForm').find('#returnUrl').val(HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/event/teanseon-event');
                        $('#visitForm').attr('method','post');
                        $('#visitForm').submit();
                    },'');
                    return false;
				}

            	var url = '${_MOBILE_PATH}/front/event/sns-shared-insert';
				var param = {memberNo:'${sessionMemberNo}',eventNo:'${resultModel.data.eventNo}',shareType:'F'};
				Dmall.AjaxUtil.getJSON(url, param, function(result) {
					if(result.success){
						$("#snsShareYn").val('Y');
						var location = document.location.href;
						/*location = location.replaceAll('id1.test.com', "www.davichmarket.com")*/
						var url = encodeURIComponent(location);
						url = url.replaceAll('%2Fm', "")
						var fbUrl = "http://www.facebook.com/sharer/sharer.php?u="+url;
						var winOpen = window.open(fbUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=500");
					}else{
						Dmall.LayerUtil.alert('공유하기 실패.','','');

					}
				});
            }

          	// 카카오톡 공유하기
            function jsShareKastory(){
            	//공유하기 정보 저장
				if(loginYn != 'true') {
					Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                        $('#visitForm').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/login/member-login');
                        $('#visitForm').find('#returnUrl').val(HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/event/teanseon-event');
                        $('#visitForm').attr('method','post');
                        $('#visitForm').submit();
                    },'');

                    return false;
				}

            	var url = '${_MOBILE_PATH}/front/event/sns-shared-insert';
				var param = {memberNo:'${sessionMemberNo}',eventNo:'${resultModel.data.eventNo}',shareType:'K'};
				Dmall.AjaxUtil.getJSON(url, param, function(result) {
					if(result.success){
						$("#snsShareYn").val('Y');
						Kakao.Link.sendDefault({
						objectType: 'feed',
						content: {
						  title: '다비치 샘플링 2 텐션편',
						  description: 'http://www.davichmarket.com/front/event/teanseon-event',
						  imageUrl: 'https://www.davichmarket.com/skin/img/event/event_210412_ts01.jpg?dt=1.2',
						  link: {
							  mobileWebUrl: 'http://www.davichmarket.com/front/event/teanseon-event',
							  webUrl: 'http://www.davichmarket.com/front/event/teanseon-event'
						  }
						},
						social: {
						  likeCount: 286,
						  commentCount: 45,
						  sharedCount: 845
						}
					  });

					}else{
						Dmall.LayerUtil.alert('공유하기 실패.','','');
					}
				});
            }

            function CopyUrlToClipboard(){
				//공유하기 정보 저장
				if(loginYn != 'true') {
					Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                        $('#visitForm').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/login/member-login');
                        $('#visitForm').find('#returnUrl').val(HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/event/teanseon-event');
                        $('#visitForm').attr('method','post');
                        $('#visitForm').submit();
                    },'');

                    return false;
				}

            	var url = '${_MOBILE_PATH}/front/event/sns-shared-insert';
				var param = {memberNo:'${sessionMemberNo}',eventNo:'${resultModel.data.eventNo}',shareType:'L'};
				Dmall.AjaxUtil.getJSON(url, param, function(result) {
					if(result.success){
						$("#snsShareYn").val('Y');
						var addrTxt = document.getElementById("hidUrl").value;
						// var isIE = (document.all)?true:false;
						var isIE = false;
						var agent = navigator.userAgent.toLowerCase();
						if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
							isIE = true;
						}
						if (isIE) {
							if (confirm("이 글의 주소를 클립보드에 복사하시겠습니까?")) window.clipboardData.setData("Text", addrTxt);
						} else {
							temp = prompt("Ctrl+C를 눌러 주소를 클립보드로 복사하세요.", addrTxt);
						}
					}else{
						Dmall.LayerUtil.alert('공유하기 실패.','','');
					}
				});
			}
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			이벤트
		</div>
		<!-- 이벤트  -->		
		<div class="cont_body event_tensean_area">
			<form name="visitForm" id="visitForm">
		    <input type="hidden" name="page" id="page" value="1" />
			<input type="hidden" name="rsvOnlyYn" id="rsvOnlyYn" value="N">
			<input type="hidden" name="teanseonSampleYn" id="teanseonSampleYn" value="Y">
			<input type="hidden" name="ch" id="ch" value="${so.ch eq null?"TSE05":so.ch}">
			<input type="hidden" id="nomobile" name="nomobile" value=""/>
    		<input type="hidden" id="memberYn" name="memberYn" value="Y"/>
    		<input type="hidden" id="hidUrl" name="hidUrl" value="http://www.davichmarket.com/front/event/teanseon-event"/>
    		<input type="hidden" id="snsShareYn" name="snsShareYn" value="N"/>
    		<input type="hidden" id="returnUrl" name="returnUrl" value="">

        	<div class="cont_body event_tensean_area">
				<img src="${_SKIN_IMG_PATH}/event/event_210412_ts01.jpg" alt="다비치 렌즈 샘플링 신청하기 1탄">
				<img src="${_SKIN_IMG_PATH}/event/event_210412_ts02.jpg" alt="2탄. 텐션편 텐션 베스트렌2즈 중 4알 증정">
				<img src="${_SKIN_IMG_PATH}/event/event_210412_ts03.jpg" alt="고객님들의 실제 리뷰">
				<img src="${_SKIN_IMG_PATH}/event/event_210412_ts04.jpg" alt="참여방법">

				<div class="sns_share_area">
					<a href="javascript:;" onclick="javascript:CopyUrlToClipboard();" class="share01">링크복사</a>
					<a href="javascript:;" onclick="javascript:jsShareKastory();" class="share02">카카오톡</a>
					<a href="javascript:;" onclick="javascript:jsShareFacebook();" class="share03">페이스북</a>
					<%--<a href="#" class="share04">SMS</a>--%>
					<img src="${_SKIN_IMG_PATH}/event/event_210412_ts05.jpg" alt="친구에게 공유하기 필수!">
				</div>
				<a href="javascript:;" id="btn_non_visit" class="btn_go_event">
					<img src="${_SKIN_IMG_PATH}/event/event_210412_ts06.jpg" alt="지금 샘플링 신청하러 가기">
				</a>
				<img src="${_SKIN_IMG_PATH}/event/event_210412_t07.jpg" alt="참여방법">
			</div>
			</form>
			
			<!--- event comment --->
			<c:if test="${resultModel.data.eventCmntUseYn eq 'Y' }">
				<ul class="tEvent_Review">
					<li>
						<form:form id="form_id_insert">
		                <input type="hidden" name="eventNo" id="formEventNo" />
						<div class="comment_wrap">
							<p class="review_info">댓글 ${eventLettList.filterdRows}</p>
							<label for="event_comment_write" class="comment_length"><span id="inputCnt">0</span>/300</label>
						</div>
						<textarea id="event_comment_write" class="form_review" name="content" placeholder="주제와 무관한 댓글, 악플은 삭제될 수 있습니다."></textarea>
						<button type="button" class="btn_write" id="btnInsertEventLett">등록</button>
						</form:form>
					</li>
		            <c:if test="${eventLettList ne null}">
						<c:forEach var="eventLettList" items="${eventLettList.resultList}" varStatus="status">
							
							<li>
								<div>
								<span class="name">${StringUtil.maskingName(eventLettList.memberNm)}</span>
								<span class="date"><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${eventLettList.regDttm}" /></span>
								</div>
								<c:set value="${eventLettList.content}" var="data"/>
								<c:set value="${fn:replace(data, cn, br)}" var="content"/>
								<p>${content}</p>
								<div class="event_comment_view">
								<button type="button" class="btn_review_del" id="" data-member-no="${eventLettList.memberNo}" onclick="EventUtil.deleteEventLett(${eventLettList.lettNo}, ${eventLettList.eventNo})">
									삭제
								</button>
								</div>
							</li>
						</c:forEach>
					</c:if>
				</ul>		
				<!---// comment --->
				<!--- 페이징 --->
				<div class="tPages" id="div_id_paging">
					<grid:paging resultListModel="${eventLettList}" />
				</div>
				<!---// 페이징 --->
			</c:if>
		</div>
		<!-- /이벤트  -->
	</div>
    </t:putAttribute>
</t:insertDefinition>