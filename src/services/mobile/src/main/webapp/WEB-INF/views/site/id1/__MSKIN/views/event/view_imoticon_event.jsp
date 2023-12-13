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
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<t:insertDefinition name="popupLayout">
    <t:putAttribute name="title">마마무 이모티콘 무료증정!</t:putAttribute>
    <t:putAttribute name="script">
    	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
    	<sec:authentication var="user" property='details'/>
        <script type="text/javascript">

            $(document).ready(function(){                
            	
            	$('.event_mmm_rule').hide();
				$('.event_mmm_check a.arrow').click(function() { 
					$('.event_mmm_rule').slideToggle();
					$(this).toggleClass('active');
				});
				
            	Kakao.init('${snsMap.get('javascriptKey')}');
            	
            	// 동의 체크 여부
                $('#mmm_check').change(function(){
                	if($(this).is(":checked") == true){
                		$('#mobile').attr('readonly', false);
                	}else{
                		$('#mobile').val('');
                		$('#mobile').attr('readonly', true);
                	}
                });
            	
             	// 이모티콘 받기
            	$('#btn_get_imoticon').click(function(){
            		var mobile = $("#mobile").val();
            		if(Dmall.validation.isEmpty(mobile)) {
            	        Dmall.LayerUtil.alert("휴대폰 번호를 입력해주세요.");
            	        return false;
            	    }
            		if(mobile.length < 11) {
            			Dmall.LayerUtil.alert('유효하지 않은 휴대폰 번호 입니다.<br>휴대폰 번호를 정확히 입력해 주십시요.');
            			return false;
            		}
            		var member_mobile = mobile.replace(/(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
            		mobile = "82"+mobile.substr(1,10);
            		
            		var url = "${_MOBILE_PATH}/front/event/imoticon-reward";
            		var param = { mobile : mobile, memMobile : member_mobile};
					Dmall.AjaxUtil.getJSON(url, param, function(result) {
						if(result.success){
							location.reload();
						}
					});
            		
            	});
             	
            	//본인의 댓글삭제버튼만 보이게 하기위한 변수, 실제 운영시에는 아래 주석을 해제하여야 한다.
	            EventUtil.memberNo = "${sessionMemberNo}";
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
                
                return dfd.promise();
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
	                            location.href="${_MOBILE_PATH}/front/event/event-ing-list?eventNo="+result.data.eventNo;
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
		    
         	// 페이스북 공유하기
            function jsShareFacebook() {
                var fbUrl = "http://www.facebook.com/sharer/sharer.php?u=https://youtu.be/8YATVYrMBPw";
                var winOpen = window.open(fbUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=500");
            }
         	
         	// 카카오톡 공유하기
            function jsShareKastory(){
            	Kakao.Link.sendDefault({
                    objectType: 'feed',
                    content: {
                      title: '마마무 이모티콘 무료증정!',
                      description: 'http://www.davichmarket.com/front/event/imoticon-event',
                      imageUrl: 'https://www.davichmarket.com/skin/img/event/youtube_share_img.jpg?dt=1.2',
                      link: {
                    	  mobileWebUrl: 'http://www.davichmarket.com/front/event/imoticon-event',
                          webUrl: 'http://www.davichmarket.com/front/event/imoticon-event'
                      }
                    },
                    social: {
                      likeCount: 286,
                      commentCount: 45,
                      sharedCount: 845
                    }
                  });
            }
          	
          	// 밴드 공유하기
          	function jsShareNaverBand(){
          		var bandUrl = "http://band.us/plugin/share?body=https://youtu.be/8YATVYrMBPw&route=마마무 이모티콘 무료증정!";
          		var winOpen = window.open(bandUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=500");
          	}
          	
          	//트위터 공유하기
          	function jsShareTwitter(){
          		var twitterUrl = "https://twitter.com/intent/tweet?url=https://youtu.be/8YATVYrMBPw";
          		var winOpen = window.open(twitterUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=500");

          	}
          	
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
		<!-- 이벤트  -->		
		<div class="cont_body event_mmm_area">
			<form id="form_id_ing_search">
				<input type="hidden" name="eventNo" id="formEventNo" />
		    	<input type="hidden" name="ingPage" id="ingPage" />
		    	<input type="hidden" name="page" id="page" value="1" />
		    	<!-- <ul class="event_detail" id="id_view_event"></ul> -->
			</form>
			<img src="${_SKIN_IMG_PATH}/event/event_mmm01.jpg" alt="카카오 이모티콘 출시">
			<img src="${_SKIN_IMG_PATH}/event/event_mmm02.jpg" alt="영상 공유하고 이모티콘 받자!">
			<img src="${_SKIN_IMG_PATH}/event/event_mmm03.jpg" alt="믿고쓰는 마마무 추천템 다 빛이나 CF를 확인해보세요">
			<div class="movie_area">
				<iframe width="1280" height="720" src="https://www.youtube.com/embed/8YATVYrMBPw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
			</div>				
			<div class="event_mmm_sns">
				<img src="${_SKIN_IMG_PATH}/event/event_mmm04.jpg" alt="CF 공유하기">
				<div class="sns_area">
					<a href="javascript:jsShareKastory();"><img src="${_SKIN_IMG_PATH}/event/event_mmm09_01.jpg" alt="카카오톡"></a>
					<a href="javascript:jsShareNaverBand();"><img src="${_SKIN_IMG_PATH}/event/event_mmm09_02.jpg" alt="밴드"></a>
					<a href="javascript:jsShareFacebook();"><img src="${_SKIN_IMG_PATH}/event/event_mmm09_03.jpg" alt="페이스북"></a>
					<a href="javascript:jsShareTwitter();"><img src="${_SKIN_IMG_PATH}/event/event_mmm09_04.jpg" alt="트위터"></a>
				</div>
				<img src="${_SKIN_IMG_PATH}/event/event_mmm06.jpg" alt="이모티콘 받는 법">
			</div>
			<div class="event_mmm_check">
				<input type="checkbox" id="mmm_check">
				<label for="mmm_check"><span></span><img src="${_SKIN_IMG_PATH}/event/event_mmm_text.jpg" alt="[필수] 개인정보 수집 및 제공 동의"></label>
				<a href="#none" class="arrow"><img src="${_SKIN_IMG_PATH}/event/event_mmm_arrow.jpg" alt="화살표"></a>
			</div>
			<div class="event_mmm_rule">
				<img src="${_SKIN_IMG_PATH}/event/event_mmm07.jpg" alt="수집항목, 이용목적, 보유기간, 취급안내">
			</div>
			<img src="${_SKIN_IMG_PATH}/event/event_mmm08.jpg" alt="본 이벤트 참여를 위해서는 개인정보 수집, 이용 동의가 필요합니다. 동의하지 않으실 경우 이벤트 참여가 제한됩니다.">
			<img src="${_SKIN_IMG_PATH}/event/event_mmm10.jpg" alt="휴대번호를 입력하고 이모티콘 받기 버튼을 클릭해주세요">
			<div class="event_mmm_form">
				<input type="text" id="mobile" name="mobile" readonly="readonly" maxlength="11" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" placeholder="휴대폰 번호를 '-'없이 입력해주세요">
				<button type="button" id="btn_get_imoticon"><img src="${_SKIN_IMG_PATH}/event/event_mmm11.jpg" alt="이모티콘 받기"></button>
			</div>
			<img src="${_SKIN_IMG_PATH}/event/event_mmm12.jpg" alt="유의사항">
			
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
    </t:putAttribute>
</t:insertDefinition>