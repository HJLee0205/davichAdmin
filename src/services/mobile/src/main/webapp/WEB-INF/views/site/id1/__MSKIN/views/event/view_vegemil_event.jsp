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
    <t:putAttribute name="title">다비치마켓 :: 다비치안경 X 베지밀 이벤트</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function(){

            //옵션 정보 호출
			jsSetOptionInfo(0,'','${goodsItemInfo5003}','5003');
			jsSetOptionInfo(0,'','${goodsItemInfo5007}','5007');
			jsSetOptionInfo(0,'','${goodsItemInfoT509}','T509');
			jsSetOptionInfo(0,'','${goodsItemInfoT511}','T511');
			jsSetOptionInfo(0,'','${goodsItemInfoT514}','T514');
			jsSetOptionInfo(0,'','${goodsItemInfoT519}','T519');
			jsSetOptionInfo(0,'','${goodsItemInfoT521}','T521');

			$('[name=daon_radio]').on('click',function(){
				var li = $(this).val().split('|')[0];
				var goodsNo=$(this).val().split('|')[1];
				$('[id^=option]').hide();
				$("#option"+li).show();

			});

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
              /*$('textarea').keydown(function(){
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
	            });*/
		    	
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
	            /*$('#btnInsertEventLett').on('click', function(e) {
	            	var eventCd = '${so.eventCd}';
	                if(eventCd === 'ing'){
	            		EventUtil.insertEventLett(e);
	              	}else{
	              		Dmall.LayerUtil.alert('지난 이벤트에는 댓글을 달 수 없습니다.','','');
	              		$('textarea').val('');
	              		return;
	              	}
	            });*/
		    	
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

                $('.btn_go_vegemil').on('click',function(){
		            if(!$('input:radio[name=daon_radio]').is(':checked')){
					Dmall.LayerUtil.alert("상품을 선택하세요.", "확인").done(function (){
					$("[name=daon_radio]").focus();
					});
					return false;
				}

				var goodsNo = $(':radio[name="daon_radio"]:checked').val().split("|")[1];
				var optionNo = $(':radio[name="daon_radio"]:checked').val().split("|")[0];
				var itemNo = $("#goods_option"+optionNo+"_0 option:selected").val();

				if(itemNo==''){
					Dmall.LayerUtil.alert("옵션을 선택하세요.", "확인").done(function (){
					});
					return false;
				}

				if($("#nomemberNm").val()==''){
					Dmall.LayerUtil.alert("이름을 입력하세요.", "확인").done(function (){
					$("#nomemberNm").focus();
					});
					return false;
				}

				if($.trim($("#nomobile").val())==''){
					Dmall.LayerUtil.alert("휴대폰 번호를 입력하세요.", "확인").done(function (){
					$("#mobile02").focus();
					});
					return false;
				}

				if(!$("#visit_check").prop("checked")){
					Dmall.LayerUtil.alert("개인정보 수집 · 이용에 동의해야 예약이 가능합니다.", "확인").done(function (){
					$("#visit_check").focus();
					});
					return false;
				}
				$("#memberYn").val("N");
				/*$('#nomobile').val($('#hp01').val()+'-'+$.trim($('#hp02').val())+'-'+$.trim($('#hp03').val()));*/


				var itemArr_1 = '';

				itemArr_1 += goodsNo +'▦'+itemNo+'^1^04▦';

				$('#itemArr_1').val(itemArr_1);

				var url = '${_MOBILE_PATH}/front/visit/winner-chk';
       			var param = {memberNm:$("#nomemberNm").val(), mobile:$("#nomobile").val()};
       			Dmall.AjaxUtil.getJSON(url, param, function(result) {
	       			if(!result.success){
	       				Dmall.LayerUtil.alert('귀하가 입력하신 이름 또는 연락처는 이벤트 당첨자에 포함되어 있지 않습니다.<br>이벤트 당첨 안내 문자(SMS)를 확인해주세요 ', '','');
	      	      		return false;
	       			}else{
	       				var data = $('#visitForm').serializeArray();
						var param = {};
						$(data).each(function(index,obj){
							param[obj.name] = obj.value;
						});
						Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-book',param);
	       			}
	       		});

				});
                return dfd.promise();
            });
		  	
		  	//댓글 카운트
            /*$(function(){
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
            });*/
	    	
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

		/* 옵션 셀렉트 박스 동적 생성 */
		function jsSetOptionInfo(seq, val,itemInfo,id) {
			$('#goods_option'+id+'_'+seq).find("option").remove();

			//var itemInfo = '${goodsItemInfo}'
			var standardPrice = 0;
			if(itemInfo != '') {
				var obj = jQuery.parseJSON(itemInfo); //단품정보
				var optionHtml = '<option selected="selected"  value="">색상을 선택해 주세요.</option>';
				var preAttrNo = ''
				var selectBoxCount = $('[id^=goods_option'+id+'_]').length;

				if(seq == 0) {  //최초 셀렉트박스 옵션 생성

					//기준가격 설정
					for(var i=0; i<obj.length; i++) {
						if (obj[i].standardPriceYn == 'Y') {
							standardPrice = obj[i].salePrice;
						}
					}

					for(var i=0; i<obj.length; i++) {
					   /* if(obj[i].standardPriceYn=='Y'){
							standardPrice=obj[i].salePrice;
						}*/
						var addPrice ="";
						addPrice = obj[i].salePrice-standardPrice;
						if(addPrice > 0 ){
							addPrice = " (+"+addPrice+")";
						}else if(addPrice < 0 ){
							addPrice = " ("+addPrice+")";
						}else{
							addPrice="";
						}


						if(preAttrNo != obj[i].attrNo1) {
							optionHtml += '<option value="'+obj[i].itemNo+'">'+obj[i].attrValue1+addPrice+'</option>';
							preAttrNo = obj[i].attrNo1;
						}
					}
				} else {

					var attrNo = [];
					for(var i=0; i<seq; i++) {
						attrNo[i] = $('#goods_option'+id+'_'+i).find(':selected').val();
					}

					//하위 옵션 셀렉트 박스 초기화
					if(val == '') {
						for(var i=seq; i<selectBoxCount; i++) {
							$('#goods_option'+id+'_'+i).find("option").remove();
						}
					}

					for(var i=0; i<obj.length; i++) {
						var len = attrNo.length;

						if(seq==1) {
							if(attrNo[0] == obj[i].attrNo1) {
								if(preAttrNo != obj[i].attrNo2) {
									optionHtml += '<option value="'+obj[i].itemNo+'">'+obj[i].attrValue2+'</option>';
									preAttrNo = obj[i].attrNo1;
								}
							}
						} else if(seq==2) {
							if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2) {
								if(preAttrNo != obj[i].attrNo3) {
									optionHtml += '<option value="'+obj[i].itemNo+'">'+obj[i].attrValue3+'</option>';
									preAttrNo = obj[i].attrNo1;
								}
							}
						} else if(seq==3) {
							if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2 && attrNo[3] == obj[i].attrNo3) {
								if(preAttrNo != obj[i].attrNo4) {
									optionHtml += '<option value="'+obj[i].itemNo+'">'+obj[i].attrValue4+'</option>';
									preAttrNo = obj[i].attrNo1;
								}
							}
						}
					}
				}
				$('#goods_option'+id+'_'+seq).append(optionHtml);
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
		<div class="cont_body event_tensean_area">
			<form name="visitForm" id="visitForm">
			<input type="hidden" name="vegemilYn" id="vegemilYn" value="Y">
            <input type="hidden" name="rsvOnlyYn" id="rsvOnlyYn" value="Y">
			<input type="hidden" name="ch" id="ch" value="${so.ch}">
			<input type="hidden" name="itemArr" id="itemArr_1" class="itemArr" value="">
			<input type="hidden" id="memberYn" name="memberYn" value="Y"/>

			<div class="cont_body event_vegemil_area">
				<img src="${_SKIN_IMG_PATH}/event/event_vegemil_img01.jpg" alt="다비치안경 정식품 베지밀 루테인두유 구매 고객대상 이벤트">
				<ul class="vegemil_daon">
					<li>
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=G2009141410_8234" target="_blank"><img src="${_SKIN_IMG_PATH}/event/event_vegemil_product01.gif" alt="DAON 5-5003 상세보기"></a>
						<input type="radio" class="radio_vegemil" id="daon_radio01" name="daon_radio" value="5003|G2009141410_8234">
						<label for="daon_radio01"><span></span></label>
					</li>
					<li>
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=G2009141415_8236" target="_blank"><img src="${_SKIN_IMG_PATH}/event/event_vegemil_product02.gif" alt="DAON 5-5007 상세보기"></a>
						<input type="radio" class="radio_vegemil" id="daon_radio02" name="daon_radio" value="5007|G2009141415_8236">
						<label for="daon_radio02"><span></span></label>
					</li>
					<li>
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=G2009141422_8237" target="_blank"><img src="${_SKIN_IMG_PATH}/event/event_vegemil_product03.gif" alt="DAON 5-T509 상세보기"></a>
						<input type="radio" class="radio_vegemil" id="daon_radio03"  name="daon_radio" value="T509|G2009141422_8237">
						<label for="daon_radio03"><span></span></label>
					</li>
					<li>
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=G2009141426_8238" target="_blank"><img src="${_SKIN_IMG_PATH}/event/event_vegemil_product04.gif" alt="DAON 5-T511 상세보기"></a>
						<input type="radio" class="radio_vegemil" id="daon_radio04"  name="daon_radio" value="T511|G2009141426_8238">
						<label for="daon_radio04"><span></span></label>
					</li>
					<li>
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=G2009141434_8240" target="_blank"><img src="${_SKIN_IMG_PATH}/event/event_vegemil_product05.gif" alt="DAON 5-T514 상세보기"></a>
						<input type="radio" class="radio_vegemil" id="daon_radio05" name="daon_radio" value="T514|G2009141434_8240">
						<label for="daon_radio05"><span></span></label>
					</li>
					<li>
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=G2009141439_8241" target="_blank"><img src="${_SKIN_IMG_PATH}/event/event_vegemil_product06.gif" alt="DAON 5-T519 상세보기"></a>
						<input type="radio" class="radio_vegemil" id="daon_radio06" name="daon_radio" value="T519|G2009141439_8241">
						<label for="daon_radio06"><span></span></label>
					</li>
					<li>
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=G2009141442_8242" target="_blank"><img src="${_SKIN_IMG_PATH}/event/event_vegemil_product07.gif" alt="DAON 5-T521 상세보기"></a>
						<input type="radio" class="radio_vegemil" id="daon_radio07" name="daon_radio" value="T521|G2009141442_8242">
						<label for="daon_radio07"><span></span></label>
					</li>
				</ul>
				<ul class="event_vegemil_form">
					<c:forEach var="optionList" items="${goodsInfo5003.data.goodsOptionList}" varStatus="status">
					<li id="option5003" style="display: none;">
						<span>색상 옵션</span>
						<div>
							<select class="select_options" id="goods_option5003_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
								<option>색상을 선택해 주세요.</option>
							</select>
						</div>
					</li>
					</c:forEach>
					<c:forEach var="optionList" items="${goodsInfo5007.data.goodsOptionList}" varStatus="status">
					<li id="option5007" style="display: none;">
						<span>색상 옵션</span>
						<div>
							<select class="select_options" id="goods_option5007_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
								<option>색상을 선택해 주세요.</option>
							</select>
						</div>
					</li>
					</c:forEach>
					<c:forEach var="optionList" items="${goodsInfoT509.data.goodsOptionList}" varStatus="status">
					<li id="optionT509" style="display: none;">
						<span>색상 옵션</span>
						<div>
							<select class="select_options" id="goods_optionT509_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
								<option>색상을 선택해 주세요.</option>
							</select>
						</div>
					</li>
					</c:forEach>
					<c:forEach var="optionList" items="${goodsInfoT511.data.goodsOptionList}" varStatus="status">
					<li id="optionT511" style="display: none;">
						<span>색상 옵션</span>
						<div>
							<select class="select_options" id="goods_optionT511_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
								<option>색상을 선택해 주세요.</option>
							</select>
						</div>
					</li>
					</c:forEach>
					<c:forEach var="optionList" items="${goodsInfoT514.data.goodsOptionList}" varStatus="status">
					<li id="optionT514" style="display: none;">
						<span>색상 옵션</span>
						<div>
							<select class="select_options" id="goods_optionT514_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
								<option>색상을 선택해 주세요.</option>
							</select>
						</div>
					</li>
					</c:forEach>
					<c:forEach var="optionList" items="${goodsInfoT519.data.goodsOptionList}" varStatus="status">
					<li id="optionT519" style="display: none;">
						<span>색상 옵션</span>
						<div>
							<select class="select_options" id="goods_optionT519_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
								<option>색상을 선택해 주세요.</option>
							</select>
						</div>
					</li>
					</c:forEach>
					<c:forEach var="optionList" items="${goodsInfoT521.data.goodsOptionList}" varStatus="status">
					<li id="optionT521" style="display: none;">
						<span>색상 옵션</span>
						<div>
							<select class="select_options" id="goods_optionT521_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
								<option>색상을 선택해 주세요.</option>
							</select>
						</div>
					</li>
					</c:forEach>
					<li class="name">
						<span>이름</span>
						<div>
							<input type="text" id="nomemberNm" name="nomemberNm" maxlength="10">
						</div>
					</li>
					<li>
						<span>연락처</span>
						<div>
							<input type="text" id="nomobile" name="nomobile" maxlength="11" placeholder="'-'없이 입력해주세요." numberOnly="true">
						</div>
					</li>
				</ul>
				
				<div class="event_vegemil_agree">
					<div class="vegemil_agree_tit">
						개인정보의 수집 및 이용동의
					</div>
					<div class="vegemil_agree_text">
						<p>1. 수집 &middot; 이용 목적 : 비회원 고객</p>
						<p class="marginLeft">매장방문예약 확인 취소에 대한 이용 기록 보관</p>
						<p>2. 수집하는 항목 : 이름, 휴대전화번호</p>
						<p>3. 개인정보의 보유 및 이용기간 : 3개월(제품 지급 후 즉시 파기)</p>
					</div>
					<div class="vegemil_agree_check">
						<input type="checkbox" class="agree_check" id="visit_check">
						<label for="visit_check"><span></span>개인정보 수집 &middot; 이용에 동의 합니다.</label>
					</div>
				</div>
				<a href="javascript:;" class="btn_go_vegemil">
					<img src="${_SKIN_IMG_PATH}/event/event_vegemil_btn.gif" alt="예약하기 바로가기">
				</a>
			</div>
			</form>
		</div>
		<!-- /이벤트  -->
		</div>
    </t:putAttribute>
</t:insertDefinition>