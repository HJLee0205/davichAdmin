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
				
            	// 동의 체크 여부
                $('#mmm_check').change(function(){
                	if($(this).is(":checked") == true){
                		$('#mobile').attr('readonly', false);
                	}else{
                		$('#mobile').val('');
                		$('#mobile').attr('readonly', true);
                	}
                });
            	
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
					if($("#nomemberNm").val()==''){
						Dmall.LayerUtil.alert("이름을 입력하세요.", "확인").done(function (){
						$("#nomemberNm").focus();
						});
						return false;
					}

					if($.trim($("#hp02").val())==''){
						Dmall.LayerUtil.alert("휴대폰 번호를 입력하세요.", "확인").done(function (){
						$("#hp02").focus();
						});
						return false;
					}

					if($.trim($("#hp03").val())==''){
						Dmall.LayerUtil.alert("휴대폰 번호를 입력하세요.", "확인").done(function (){
						$("#hp03").focus();
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
					$('#nomobile').val($('#hp01').val()+'-'+$.trim($('#hp02').val())+'-'+$.trim($('#hp03').val()));


					/*var itemArr = '';
					var goodsNo = '${goodsInfo.data.goodsNo}';

					itemArr += goodsNo +'▦'+$('#itemNoArr').val()+'^1^04▦';*/
					//추가옵션 배열 생성
					/*var addOptArr = '';*/
					/*$('[id^=add_option_layer_]').each(function(index){
						if(addOptArr != '') {
							addOptArr += '*';
						}
						addOptArr += $(this).find('.addOptNoArr').val()+'^'+$(this).find('.addOptDtlSeqArr').val()+'^'+$(this).find('.input_goods_no').val();
					});*/
					/*itemArr += addOptArr + '▦';
					itemArr += '${ctgNo}';
					$('#itemArr').val(itemArr);*/

					/*var data = $('#visitForm').serializeArray();
					var param = {};
					$(data).each(function(index,obj){
						param[obj.name] = obj.value;
					});
					Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-book',param);*/

					$('#visitForm').attr('action','${_MOBILE_PATH}/front/visit/visit-book');
					$('#visitForm').attr('method','post');
					$('#visitForm').submit();
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
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			이벤트
		</div>
		<!-- 이벤트  -->		
		<div class="cont_body event_211020_area">
			<form name="visitForm" id="visitForm">
		    <input type="hidden" name="page" id="page" value="1" />

			<input type="hidden" name="rsvOnlyYn" id="rsvOnlyYn" value="N">
			<input type="hidden" name="teanseonNewYn" id="teanseonNewYn" value="Y">
			<input type="hidden" name="ch" id="ch" value="${so.ch eq null?"TSE06-00":so.ch}">

			<input type="hidden" id="nomobile" name="nomobile" value=""/>
    		<input type="hidden" id="memberYn" name="memberYn" value="Y"/>

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
					<select id="hp01" class="tell">
						<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
					</select>
					<span class="form_bar">-</span>
					<input type="text" id="hp02" name="hp02" class="tell"  maxlength="4" numberOnly="true">
					<span class="form_bar">-</span>
					<input type="text" id="hp03" name="hp03" class="tell"  maxlength="4" numberOnly="true">
				</div>
				<div class="tensean_agree_tit">
					개인정보의 수집 및 이용동의
				</div>
				<div class="tensean_agree_text">
					<p>1. 수집 &middot; 이용 목적 : 비회원 고객</p>
					<p class="marginLeft">매장방문예약 확인 취소에 대한</p>
					<p class="marginLeft">이용 기록 보관</p>
					<p>2. 수집하는 항목 : 이름, 휴대전화번호</p>
					<p>3. 개인정보의 보유 및 이용기간 : 1년</p>
				</div>
				<div class="tensean_agree_check">
					<input type="checkbox" class="agree_check" id="visit_check">
					<label for="visit_check"><span></span>개인정보 수집&middot;이용에 동의 합니다.</label>
				</div>
			</div>
			<%--</c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose>--%>
			<a href="javascript:;" id="btn_non_visit">
				<img src="${_SKIN_IMG_PATH}/event/event_211020_btn.jpg"  alt="아이럽 라이트 사전 예약하기">
			</a>
			<img src="${_SKIN_IMG_PATH}/event/event_211020_03.jpg" alt="텐션">
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