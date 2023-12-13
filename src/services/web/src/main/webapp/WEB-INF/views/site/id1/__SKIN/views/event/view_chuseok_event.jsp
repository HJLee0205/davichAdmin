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
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 추석 이벤트</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function(){

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

				$('#btn_visit').on('click',function(){
				    var loginYn = ${user.login};

				    if (loginYn) {
                        $('#visitForm').attr('action','/front/visit/visit-book');
                        $('#visitForm').attr('method','post');
                        $('#visitForm').submit();
                    } else {
                    	location.href ="/front/visit/visit-welcome?ch=${so.ch}";
                        /*Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function () {
                                location.href = "/front/login/member-login?returnUrl=/front/event/chuseok-event?ch=${so.ch}"
                            }, '');*/
                    }

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


		function scrollController() {
			var ETheight = $('.event_float_top').height();
			currentScrollTop = $(window).scrollTop();
			if (currentScrollTop < ETheight + 100) {
				if ($('.btn_scroll_move').hasClass('fixed')) {
					$('.btn_scroll_move').removeClass('fixed');
				}
			} else {
				if (!$('.btn_scroll_move').hasClass('fixed')) {
					$('.btn_scroll_move').css('bottom', 30);
					$('.btn_scroll_move').addClass('fixed');
				}
			}

			/*var scrollBottom = $(document).height() - $(window).height() - $(window).scrollTop();
			currentScrollTop = $(window).scrollTop();
			 if (scrollBottom < 250) {
				if ($('.btn_scroll_move').css('bottom', 30)) {
					$('.btn_scroll_move').css('bottom', 449);
				}
			} if (scrollBottom > 250) {
				if ($('.btn_scroll_move').hasClass('fixed')) {
					$('.btn_scroll_move').css('bottom', 30);
				}
			} else {
				if (!$('.btn_scroll_move').hasClass('fixed')) {
					$('.btn_scroll_move').css('bottom', 30);
					$('.btn_scroll_move').addClass('fixed');
				}
			}*/
			var ETBottom = $(document).height() - $(window).height() - $(window).scrollTop();
			currentScrollTop = $(window).scrollTop();
			if (ETBottom < 800) {
				if ($('.btn_scroll_move').css('bottom', 30)) {
					$('.btn_scroll_move').addClass('btm');
				}
			} if (ETBottom > 800) {
				if ($('.btn_scroll_move').hasClass('btm')) {
					$('.btn_scroll_move').removeClass('btm');
				}
			} else {
				if (!$('.btn_scroll_move').hasClass('fixed')) {
					$('.btn_scroll_move').css('bottom', 30);
					$('.btn_scroll_move').addClass('fixed');
				}
			}
		}

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">


        <!--- contents --->
        <div class="category_middle">
        	<div class="event_head">
			<h2 class="event_tit">이벤트</h2>
			<select class="select_planning" id="otherEvent">
				<c:choose>
					<c:when test="${so.eventCd eq 'ing'}">
						<option selected="selected" value="">진행중인 이벤트</option>
					</c:when>
					<c:otherwise>
						<option selected="selected" value="">종료된 이벤트</option>
					</c:otherwise>
				</c:choose>
  				<c:forEach var="eventList" items="${eventList.resultList}" varStatus="status">
	            <option value="${eventList.eventNo}">${eventList.eventNm}</option>
	            </c:forEach>
			</select>
		</div>
        	<table class="tEvent_view">
			<caption>
				<h1 class="blind">당첨자 발표 게시판 목록입니다.</h1>
			</caption>
			<colgroup>
				<col style="">
				<col style="width:215px">
			</colgroup>
			<thead>
				<tr>
					<th class="textL">${resultModel.data.eventNm}</th>
					<th class="textR">
					<fmt:parseDate var="startDate" value="${fn:substring(resultModel.data.applyStartDttm, 0, 8)}" pattern="yyyyMMdd" />
					<fmt:formatDate value="${startDate}" pattern="yyyy-MM-dd"/>
					~
					<fmt:parseDate var="endDate" value="${fn:substring(resultModel.data.applyEndDttm, 0, 8)}" pattern="yyyyMMdd" />
					<fmt:formatDate value="${endDate}" pattern="yyyy-MM-dd"/>
					</th>
				</tr>
			</thead>
			<tbody>

			</tbody>
		</table>
		<br>
			<form name="visitForm" id="visitForm">
            <%--<input type="hidden" name="goodsNoArr" id="goodsNoArr" value="${goodsInfo.data.goodsNo}">
            <input type="hidden" name="goodsNo" id="goodsNo" value="${goodsInfo.data.goodsNo}">--%>
			<input type="hidden" name="rsvOnlyYn" id="rsvOnlyYn" value="N">
			<input type="hidden" name="teanseonMiniYn" id="teanseonMiniYn" value="N">
			<input type="hidden" name="ch" id="ch" value="${so.ch eq null?"Chuseok-00":so.ch}">
			<%--<input type="hidden" name="itemNoArr" id="itemNoArr" class="itemNoArr" value="${goodsInfo.data.itemNo}">
			<input type="hidden" name="itemPriceArr" id="itemPriceArr" class="itemPriceArr" value="${salePrice}">
			<input type="hidden" name="stockQttArr" id="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">--%>
			<%--<input type="hidden" name="itemArr" id="itemArr_1" class="itemArr" value="">
			<input type="hidden" name="itemArr" id="itemArr_2" class="itemArr" value="">--%>
			<input type="hidden" id="nomobile" name="nomobile" value=""/>
    		<input type="hidden" id="memberYn" name="memberYn" value="Y"/>

        	<div class="cont_body event_fall_area">
			<div class="event_float_top">
				<img src="${_SKIN_IMG_PATH}/event/event_fall01.jpg" alt="2020년 추석 특선 할인 풍성한 추석 다비치답게 쏜 달">
			</div>
			<div class="event_float_area">
				<%--<c:if test="${user.login}">--%>
				<a href="javascript:;" class="btn_scroll_move" id="btn_visit">
					<img src="${_SKIN_IMG_PATH}/event/event_fall_btn01.jpg" alt="방문예약하기">
				</a>
				<img src="${_SKIN_IMG_PATH}/event/event_fall02.jpg" alt="2020년 추석 특선 할인 풍성한 추석 다비치답게 쏜 달">
				<a href="/front/promotion/promotion-list">
					<img src="${_SKIN_IMG_PATH}/event/event_fall_btn03.jpg" alt="다른 기획전 보러가기">
				</a>
				<%--</c:if>--%>

				<img src="${_SKIN_IMG_PATH}/event/event_fall03.jpg" alt="2020년 추석 특선 할인 풍성한 추석 다비치답게 쏜 달">
				<img src="${_SKIN_IMG_PATH}/event/event_fall04.jpg" alt="2020년 추석 특선 할인 풍성한 추석 다비치답게 쏜 달">
				<img src="${_SKIN_IMG_PATH}/event/event_fall05.jpg" alt="2020년 추석 특선 할인 풍성한 추석 다비치답게 쏜 달">
			</div>
		</div>
		</form>

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