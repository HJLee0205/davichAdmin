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
    <t:putAttribute name="title">다비치마켓 :: 텐션 신제품 사전예약</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function(){
                //숫자만 입력가능
            $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
            	
				$('.event_mmm_rule').hide();
				$('.event_mmm_check a.arrow').click(function() { 
					$('.event_mmm_rule').slideToggle();
					$(this).toggleClass('active');
				});
         	   
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
	            

				/*$('#visit_check').on('click',function(){
					if($(this).prop("checked")){
					$("#btn_non_visit").show();
					}else{
					$("#btn_non_visit").hide();
					}
				});*/

				$('#btn_non_visit').on('click',function(){


					if($("#nomemberNm").val()==''){
						Dmall.LayerUtil.alert("이름을 입력하세요.", "확인").done(function (){
						$("#nomemberNm").focus();
						});
						return false;
					}

					if($.trim($("#mobile02").val())==''){
						Dmall.LayerUtil.alert("휴대폰 번호를 입력하세요.", "확인").done(function (){
						$("#mobile02").focus();
						});
						return false;
					}

					if($.trim($("#mobile03").val())==''){
						Dmall.LayerUtil.alert("휴대폰 번호를 입력하세요.", "확인").done(function (){
						$("#mobile03").focus();
						});
						return false;
					}

					if(!$("#visit_check").prop("checked")){
						Dmall.LayerUtil.alert("개인정보 수집 이용에 동의해 주세요..", "확인").done(function (){
						$("#visit_check").focus();
						});
						return false;
					}

					$("#memberYn").val("N");
					$('#nomobile').val($('#mobile01').val()+'-'+$.trim($('#mobile02').val())+'-'+$.trim($('#mobile03').val()));

					/*var itemArr_1 = '';
					var itemArr_2 = '';*/
					var goodsNo = '${goodsInfo.data.goodsNo}';

					//itemArr += goodsNo +'▦'+$('#itemNoArr').val()+'^1^04▦';
					/*itemArr_1 += 'G2008041558_7972▦I2008041558_11674^1^04▦';*/
					//추가옵션 배열 생성
					/*var addOptArr = '';*/
					/*$('[id^=add_option_layer_]').each(function(index){
						if(addOptArr != '') {
							addOptArr += '*';
						}
						addOptArr += $(this).find('.addOptNoArr').val()+'^'+$(this).find('.addOptDtlSeqArr').val()+'^'+$(this).find('.input_goods_no').val();
					});*/
					/*itemArr_1 += addOptArr + '▦';
					itemArr_1 += '${ctgNo}';
					$('#itemArr_1').val(itemArr_1);*/


					//itemArr += goodsNo +'▦'+$('#itemNoArr').val()+'^1^04▦';
					/*itemArr_2 += 'G2008041551_7970▦I2008041551_11672^1^04▦';*/
					//추가옵션 배열 생성
					/*var addOptArr = '';
					itemArr_2 += addOptArr + '▦';
					itemArr_2 += '${ctgNo}';
					$('#itemArr_2').val(itemArr_2);*/

					/*var data = $('#visitForm').serializeArray();
					var param = {};
					$(data).each(function(index,obj){
						param[obj.name] = obj.value;
					});
					Dmall.FormUtil.submit('/front/visit/visit-book',param);*/

					$('#visitForm').attr('action','/front/visit/visit-book');
					$('#visitForm').attr('method','post');
					$('#visitForm').submit();
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

			<input type="hidden" name="rsvOnlyYn" id="rsvOnlyYn" value="N">
			<input type="hidden" name="teanseonNewYn" id="teanseonNewYn" value="Y">
			<input type="hidden" name="ch" id="ch" value="${so.ch eq null?"TSE06-00":so.ch}">

			<input type="hidden" id="nomobile" name="nomobile" value=""/>
    		<input type="hidden" id="memberYn" name="memberYn" value="Y"/>

        	<div class="cont_body event_211020_area">

        	<img src="${_SKIN_IMG_PATH}/event/event_211020_01.jpg" alt="텐션 신제품 사전 예약 이벤트">

			<%--<c:choose>
				<c:when test="${!user.login or (user.session.mobile=='' or user.session.mobile==null)}">--%>
				<div class="event_tensean_form">
					<div class="tensean_form_row">
						<span>이름</span>
						<input type="text" id="nomemberNm" name="nomemberNm" maxlength="10" value="${user.session.memberNm}">
					</div>
					<div class="tensean_form_row">
						<span>연락처</span>
						<select id="mobile01" class="tell">
							<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
						</select>
						<span class="form_bar">-</span>
						<input type="text" id="mobile02" name="mobile02" class="tell"  maxlength="4" numberOnly="true">
						<span class="form_bar">-</span>
						<input type="text" id="mobile03" name="mobile03" class="tell"  maxlength="4" numberOnly="true">
					</div>
					<div class="tensean_agree_tit">
						개인정보의 수집 및 이용동의
					</div>
					<div class="tensean_agree_text">
						<p>1. 수집 &middot; 이용 목적 : 비회원 고객 매장방문예약 확인 취소에</p>
						<p class="marginLeft">대한 이용 기록 보관</p>
						<p>2. 수집하는 항목 : 이름, 휴대전화번호</p>
						<p>3. 개인정보의 보유 및 이용기간 : 1년</p>
					</div>
					<div class="tensean_agree_check">
						<input type="checkbox" class="agree_check" id="visit_check">
						<label for="visit_check"><span></span>개인정보 수집&middot;이용에 동의 합니다.</label>
						<%--<button type="button" class="btn_non_visit" style="display:none;">비회원 방문예약</button>--%>
					</div>
				</div>
				<%--</c:when>
				<c:otherwise>
				<div style="padding: 58px 47px;"></div>
				</c:otherwise>
			</c:choose>--%>

			<a href="javascript:;" class="btn_go_event" id="btn_non_visit">
				<img src="${_SKIN_IMG_PATH}/event/event_211020_btn.jpg" alt="텐션 신제품 사전 예약하기">
			</a>
			<img src="${_SKIN_IMG_PATH}/event/event_211020_03.jpg" alt="텐션">
		</div>
		</form>
        	<!-- 비회원 방문예약신청시 -->
			<%--<div class="visit_non_member">
				<ul class="info_form_area">
					<li>
						<span>이름</span>
						<input type="text" id="nomemberNm" name="nomemberNm" maxlength="10">
					</li>
					<li class="tell">
						<span>연락처</span>
						<select id="mobile01" class="phone check_ok">
							<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
						</select>
						<span class="bar">-</span>
						<input type="text" id="mobile02" name="mobile02" maxlength="4" numberOnly="true">
						<span class="bar">-</span>
						<input type="text" id="mobile03" name="mobile03" maxlength="4" numberOnly="true">
					</li>
				</ul>
				<div class="privacy_agree_tit">
					개인정보의 수집 및 이용동의
				</div>
				<div class="privacy_agree">
					1. 수집&middot;이용 목적 : 비회원 고객 매장방문예약 확인 취소에 대한 이용 기록 보관<br>
					2. 수집하는 항목 : 이름, 휴대전화번호<br>
					3. 개인정보의 보유 및 이용기간 : 1년
				</div>
				<input type="checkbox" class="agree_check" id="visit_check">
				<label for="visit_check"><span></span>개인정보 수집&middot;이용에 동의 합니다.</label>

				<button type="button" class="btn_non_visit" style="display:none;">비회원 방문예약</button>
			</div>--%>
			<!--// 비회원 방문예약신청시 -->
			
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