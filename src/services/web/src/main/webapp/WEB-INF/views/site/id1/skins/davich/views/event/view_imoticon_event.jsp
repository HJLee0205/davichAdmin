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
<t:insertDefinition name="popupLayout">
    <t:putAttribute name="title">다비치마켓 :: 마마무 이모티콘 무료증정!</t:putAttribute>
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
            	
            	$('#eventCommentWrite').hide();
	            EventUtil.memberNo = "${sessionMemberNo}";
	            
				
	            //이벤트 댓글 목록 
	            var eventNo = ${resultModel.data.eventNo};	         
	            var eventCmntUseYn = '${resultModel.data.eventCmntUseYn}';
	            var eventCd = '${so.eventCd}';
	            
	            
	            $('[id^=formEventNo]').val(eventNo);
	            eventCmntUseYn === 'Y' ? EventUtil.getLettList(eventNo) : $('#eventCommentWrite').hide();
            
	            //이벤트 댓글 등록
	            $('#btnInsertEventLett').on('click', function(e) {
	              	if(eventCd === 'ing'){
	            		EventUtil.insertEventLett(e);
	              	}else{
	              		Dmall.LayerUtil.alert('지난 이벤트에는 댓글을 달 수 없습니다.','','');
	              		$('textarea').val('');
	              		return;
	              	}
	            });
	            
	            //목록
	            $('#btn_view_list').on('click', function() {
	                var param = {eventCd:eventCd}
	                Dmall.FormUtil.submit('/front/event/event-list', param);
	            });
	            //비회원 댓글쓰기 방지
	            $('textarea').keydown(function(){
	                if(EventUtil.memberNo === '' || EventUtil.memberNo === 0) {
	                    //textarea에 계속입력하면 레이어를 무한정 오픈되기때문에 막아놓는다.
	                    $('textarea').prop('disabled', true);
	                    Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
	                        //확인버튼 클릭
                            function() {
	                    	var returnUrl = window.location.pathname+window.location.search;
                            location.href= "/front/login/member-login?returnUrl="+returnUrl;
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
                            };
                        };
                        return byteNum;
                    };
	            });
	            
	            //다른 이벤트 이동
	            $('.select_planning').on('change', function(){	        
                    var eventNo = $('#otherEvent option:selected').val();
                    var eventCd = eventCd;
                    Dmall.FormUtil.submit('/front/event/event-detail',  {eventNo : eventNo, eventCd : eventCd});      
	            });
	            
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
            		
            		var url = "/front/event/imoticon-reward";
		    		var param = { mobile : mobile, memMobile : member_mobile};
					Dmall.AjaxUtil.getJSON(url, param, function(result) {
						if(result.success){
							location.reload();
						}
					});
            		
            	});
                
            });

          	//글자수(byte) 체크
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
                            };
                        };
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
	        
	        //이벤트 상세내용
	        var EventUtil = {
	            eventNo:'${resultModel.data.eventNo}'
	            , memberNo:0
	            , deleteFlag:false
                , view:function(eventNo) {
                    EventUtil.getEvent(eventNo);
                }	        
                , getLettList:function(eventNo) {
                    $('#eventCommentWrite').show();
                    var url = '/front/event/event-comment-list',dfd = jQuery.Deferred();

                    //최초 페이지 접속시 1로 설정
                    var pageNum = 1;

                    //1번이상 페이지로 이동시 페이지번호 설정
                    if($('#page').val() !== '') {
                        pageNum = $('#page').val();
                    }

                    //댓글 삭제를 했다면 무조건 1페이지로 이동하고 페이지번호 초기화
                    if(EventUtil.deleteFlag === true) {
                        pageNum = 1;
                        $('#page').val(1);
                        EventUtil.deleteFlag = false;
                    }

                    var param = {eventNo: eventNo, page:pageNum};

                    Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                        var template =
                        '<tr class="event_comment_view">'+
                            '<td>'+
                                '{{memberNm}}'+                                
                            '</td>'+
                            '<td>'+
                                '{{content}}'+
                                '<button type="button" class="btn_review_del" data-member-no="{{memberNo}}" onclick="EventUtil.deleteEventLett({{lettNo}}, {{eventNo}})"><img src="../img/product/btn_reply_del.gif" alt="댓글삭제"></button>'+
                            '</td>'+
                            '<td>'+ 
                            		'{{regLettDttm}}'+                              
                            '</td>'+
                        '</tr>',
                            managerGroup = new Dmall.Template(template),
                                tr = '';
                        jQuery.each(result.resultList, function(idx, obj) {
                        	var key;
                            for(key in obj) {                              
                                //이름 마스킹 처리
                                if(key === 'memberNm') {
                                    obj[key] = EventUtil.maskingName(obj[key]);
                                }
                                if(key == 'content'){
                                	obj[key] = obj[key].replaceAll("\n", "<br/>");
                                }
                            }
                            tr += managerGroup.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr class="event_comment_view"><td width="100%">댓글이 없습니다.</td></tr>';
                        }
                        jQuery('#eventCommentList').html(tr);
                        dfd.resolve(result.resultList);
                        
                        $('#review_info').text("댓글 "+result.filterdRows);

                        //현재진행중 이벤트 페이징처리
                        Dmall.GridUtil.appendPaging('form_id_ing_search', 'div_id_ing_paging', result, 'paging_id_ing_eventLett', EventUtil.pagingCallBack);
                        $("#a").text(result.filterdRows);
                        $("#b").text(result.totalRows);

                        //이벤트 상세내용이 호출된후 본인의 댓글 삭제버튼만 보이도록 호출
                        EventUtil.btnHide();
                    });


                    return dfd.promise();
                }
                , insertEventLett:function(e) {
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

                    var url = '/front/event/event-comment-insert';
                    var param = $('#form_id_insert').serialize();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            $('textarea').text('');
                            $('#event_comment_write').val('');
                            EventUtil.getLettList('${resultModel.data.eventNo}');
                        }
                    });
                }
                , deleteEventLett:function(lettNo, eventNo) {
                    Dmall.LayerUtil.confirm("삭제하시겠습니까?",
                        function() {
                            var url = '/front/event/event-comment-delete';
                            var param = {lettNo:lettNo,eventNo:eventNo};
                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                //validate.viewExceptionMessage(result, 'form_id_cmntinsert');
                                if(result.success){
                                    EventUtil.getLettList(eventNo);
                                }
                        });
                    })
                    EventUtil.deleteFlag = true;
                }
                , btnHide:function() {
                    $('#eventCommentList .event_comment_view').each(function() {
                        var dataMemberNo = parseInt($(this).find('button').attr('data-member-no'), 10);
                        var sessionMemberNo = parseInt(EventUtil.memberNo, 10) || 0;
                        if(sessionMemberNo !== dataMemberNo) {
                            $(this).find('button').hide();
                        }
                    });
                }                              
                , pagingCallBack:function() {
                    EventUtil.getLettList(EventUtil.eventNo);
                }
                , maskingMobile:function(hp) {
                    var pattern = /^(\d{3})-?(\d{2,3})\d{1}-?(\d{1,2})\d{2}$/;
                    var result = "";
                    if(!hp) {
                        result = "*";
                        return result;
                    }

                    var match = pattern.exec(hp);
                    if(match) {
                        result = match[1]+"-"+match[2]+"*-"+match[3]+"**";
                    } else {
                        result = "***";
                    }
                    return result;
                }
                , maskingName:function(name) {
                    var pattern = /.$/;
                    return name.replace(pattern, "*");
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
          		var winOpen = window.open(twitterUrl, "twitter", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=500");

          	}

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
        <div class="category_middle">
        	<div class="cont_body event_mmm_area">
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
			</div>
			
			<!-- 댓글 -->
			<form:form id="form_id_ing_search">
			<input type="hidden" name="eventNo" id="formEventNo" />
			<input type="hidden" name="page" id="page" />
			</form:form>
			<table class="tEvent_Review"  id="eventCommentWrite">
				<caption>
					<h1 class="blind">이벤트 댓글 쓰기 목록입니다.</h1>
				</caption>
				<colgroup>
					<col style="width:106px">
					<col style="">
					<col style="width:210px">
				</colgroup>
				<thead>
					<tr>
						<td colspan="3">
							<div><p class="review_info" id="review_info">댓글 0</p>
	                        <form:form id="form_id_insert">                            
								<label for="event_comment_write" class="comment_length"><span id="inputCnt">0</span>/300</label></div>
	                            <input type="hidden" name="eventNo" id="formEventNo" />
								<textarea class="form_review" id="event_comment_write" name="content" placeholder="주제와 무관한 댓글, 악플은 삭제될 수 있습니다."></textarea>
	                        </form:form>                        
							<button type="button" class="btn_write" id="btnInsertEventLett">등록</button>
						</td>
					</tr>
				</thead>
				<tbody id="eventCommentList">
				</tbody>
			</table>
			<!--// 댓글 -->
	        <!---- 페이징 ---->
	        <div class="tPages" id="div_id_ing_paging"></div>
	        <!----// 페이징 ---->
			<!-- <div class="btn_event_area">
				<button type="button" class="btn_view_list" id="btn_view_list">목록</button>
			</div> -->
        </div>
    </t:putAttribute>
</t:insertDefinition>