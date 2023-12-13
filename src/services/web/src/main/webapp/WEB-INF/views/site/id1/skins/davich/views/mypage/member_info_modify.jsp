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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 
		<c:choose>
		<c:when test="${so.integrationMemberGbCd eq '02'}">정회원 전환</c:when>
		<c:otherwise>회원정보수정</c:otherwise>
		</c:choose>
	</t:putAttribute>
 	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script src="/front/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
    <script>
    var totalFileLength=0;
    $(document).ready(function(){
        setCalendar();
        <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
        VarMobile.server = '${server}';

        // 우편번호
        jQuery('#btn_post').on('click', function(e) {
            Dmall.LayerPopupUtil.zipcode(setZipcode);
        });
        $('#select_id_month').on('change', function() {
            var d = new Date(),
                    lastDate,
                    html = '<option value="" selected="selected">일</option>';
            d.setFullYear($('#select_id_year').val(), this.value, 1);
            d.setDate(0);
            lastDate = d;
            for(var i = 1; i <= lastDate.getDate(); i++) {
                if(i<10){
                    html += '<option value="0' + i + '">0' + i + '</option>';
                }else{
                    html += '<option value="' + i + '">' + i + '</option>';
                }

            }
            $('#select_id_date').html(html).trigger('change');
        });
        //e-mail selectBox
        var emailSelect = $('#email03');
        var emailTarget = $('#email02');
        emailSelect.bind('change', null, function() {
            var host = this.value;
            if (host != 'etc' && host != '') {
                emailTarget.attr('readonly', true);
                emailTarget.val(host).change();
            } else if (host == 'etc') {
                emailTarget.attr('readonly'
                        , false);
                emailTarget.val('').change();
                emailTarget.focus();
            } else {
                emailTarget.attr('readonly', true);
                emailTarget.val('').change();
            }
        });
        
      	//휴대전화인증
        $('.btn_mobile_check').on('click',function (){
        	if($('#mobile01').val() == null || $('#mobile01').val() == '' || $('#mobile02').val() == '' || $('#mobile03').val() == ''){
        		Dmall.LayerUtil.alert("휴대전화를 입력해주세요.", "확인");
        		return false;
        	}
            var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
            var url = '/front/member/send-sms-certify';
            var param = {
            	mobile : mobile
            }
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
            	if(result.success) {
            		var certifyKey = result.extraString;
            		$('#certify_key').val('');
            		$('#certify_key').data('certifyKey',certifyKey);
            		fnCountDown();
            		$('#div_mobile_check').css('display','block');
    				$('#div_mobile_check_fail').css('display','none');
            		Dmall.LayerPopupUtil.open($('#popup_mobile_check'));
            	}
            });
            
        });
        
      	//휴대전화인증 인증확인
        $('#btn_mobile_confirm').click(function(){
			if($('#certify_key').val() == $('#certify_key').data('certifyKey')){
				$('#mobileCertifyYn').val('Y');
				Dmall.LayerUtil.alert("인증이 완료되었습니다.", "알림");
				$('#mobile01').attr('disabled', true);
				$('#mobile02').attr('readonly', true);
				$('#mobile03').attr('readonly', true);
				if('${so.integrationMemberGbCd}' == '02'){
					$('.btn_mobile_check').hide();
				}else{
					$('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
				}
				Dmall.LayerPopupUtil.close('popup_mobile_check');
			}else{
				Dmall.LayerUtil.alert("인증번호가 일치하지 않습니다.<br>다시 확인해주세요.", "알림");
				$('#mobileCertifyYn').val('N');
			}
		});
		
        //휴대전화인증 재전송
		$('#btn_mobile_resend').click(function(){
			$('#certify_key').val('');
			var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
            var url = '/front/member/send-sms-certify';
            var param = {
            	mobile : mobile
            }
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
            	if(result.success) {
            		var certifyKey = result.extraString;
            		$('#certify_key').data('certifyKey',certifyKey);
            		stopCountDown();
            		fnCountDown();
            	}
            });
		});
        
        // 아이디변경 버튼
        $('.btn_id_check').on('click',function (){
            $("#id_check").val('');
            $('#id_success_div').attr('style','display:none;')
            $('.id_duplicate_check_info').html('');
            Dmall.LayerPopupUtil.open($('#popup_id_duplicate_check'));
        });
        
        // 아이디변경 중복체크
        var check_id;
        $('#btn_id_duplicate_check').on('click',function (){
            var url = '/front/member/duplication-id-check';
            var loginId = $('#id_check').val();
            if(Dmall.validation.isEmpty($("#id_check").val())) {
                $('#id_success_div').attr('style','display:none;')
                Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
                return false;
            }else{
                if(idCheck(loginId)){
                var param = {loginId : loginId}
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         check_id = loginId;
                         $('#id_success_div').attr('style','display:block;')
                         $('.id_duplicate_check_info').html('사용 가능한 아이디 입니다.');
                     }else{
                         $('.id_duplicate_check_info').html('사용불가능한 아이디 입니다.');
                         $('#id_success_div').attr('style','display:none;')
                     }
                 });
               }
            }
        });
        
      	//아이디 사용하기
        $('#btn_popup_login').on('click',function (){
        	if(check_id != '' && check_id != null){
				$('#chgId').val(check_id);
				$('#idChgYn').val('Y');
        	} else{
        		Dmall.LayerUtil.alert('오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.', '','');	
        	}
        	Dmall.LayerPopupUtil.close('popup_id_duplicate_check');
        });
        
        $('.btn_close_popup').on('click',function (){
        	check_id = '';
        });

        //이메일
        var _email = '${resultModel.data.email}';
        var temp_email = _email.split('@');
        $('#email01').val(temp_email[0]);
        if(emailSelect.find('option[value="'+temp_email[1]+'"]').length > 0) {
           emailSelect.val(temp_email[1]);
        } else {
           emailSelect.val('etc');
        }
        emailSelect.trigger('change');
        emailTarget.val(temp_email[1]);

        //일반전화
        var _tel = '${resultModel.data.tel}';
        var temp_tel = Dmall.formatter.tel(_tel).split('-');
        $('#tel01').val(temp_tel[0]);
        $('#tel02').val(temp_tel[1]);
        $('#tel03').val(temp_tel[2]);
        $('#tel01').trigger('change');

        //모바일
        var _mobile = '${resultModel.data.mobile}';
        var temp_mobile = Dmall.formatter.mobile(_mobile).split('-');
        $('#mobile01').val(temp_mobile[0]);
        $('#mobile02').val(temp_mobile[1]);
        $('#mobile03').val(temp_mobile[2]);
        $('#mobile01').trigger('change');

        //성별
        var _gender = '${resultModel.data.genderGbCd}';
        $('input:radio[name="genderGbCd"]:input[value="'+_gender+'"]').prop("checked",true);

        //지역 구분
        var memberGbCd = '${resultModel.data.memberGbCd}';
        if(memberGbCd == '10')$('.radio_chack_a').click();
        if(memberGbCd == '20')$('.radio_chack_b').click();

        //회원정보 수정실행
        $('.btn_change_member').on('click',function (){
            var joinShopCd = "${resultModel.data.joinPathCd}";
            if(joinShopCd === 'SHOP') {
                if(Dmall.validation.isEmpty($("#pw").val())) {
                    Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "알림");
                    return false;
                }
            }else{
            	if(Dmall.validation.isEmpty($("#email01").val())|| Dmall.validation.isEmpty($("#email02").val())) {
	                Dmall.LayerUtil.alert("이메일을 입력해주세요.");
	                jQuery('#email01').focus();
	                return false;
	            }else{
	            	$('#email').val($('#email01').val()+"@"+$('#email02').val());
	            }
            }
            
            // 회원 이름 체크
            var memberNm = $('#memberNm').val();
            if(memberNm == ''){
        		Dmall.LayerUtil.alert("이름을 입력해주세요.", "확인");
                return false;
        	}else {
        		if(memberNm != '${resultModel.data.memberNm}'){
        			$('#chgMemberNm').val(memberNm);
        		}
        	}
            
            var memberGbCd = $('#memberGbCd').val();
            if(memberGbCd == '01'){
	            if ($('#birth').val().length != 8){
	            	Dmall.LayerUtil.alert("생년월일 형식이 잘못되었습니다.\n 생년월일 8자리를 입력하세요", "확인");
	                return false;
	            }else if (isValidDate($('#birth').val()) == false) {
                	return false;
            	}else{
	            	var birth = $('#birth').val();
	            	$('#bornYear').val(birth.substring(0,4));
	            	$('#bornMonth').val(birth.substring(4,6));
	            }
            }
            if(memberGbCd == '02'){
            	if($('#managerNm').val() == ''){
            		Dmall.LayerUtil.alert("담당자명을 입력해주세요.", "확인");
	                return false;
            	}
            }
            //회원정보수정일때
            if('${so.integrationMemberGbCd}' != '02'){
	            var input_mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
	            //기존 휴대전화와 현재 입력된 휴대전화 비교
	            if($('#mobile').val() != input_mobile){
	            	$('#mobileCertifyYn').val('N');
	            	
	                var url = '/front/member/send-sms-certify';
	                var param = {
	                	mobile : input_mobile
	                }
	                Dmall.AjaxUtil.getJSON(url, param, function(result) {
	                	if(result.success) {
	                		var certifyKey = result.extraString;
	                		$('#certify_key').val('');
	                		$('#certify_key').data('certifyKey',certifyKey);
	                		fnCountDown();
	                		$('#div_mobile_check').css('display','block');
	        				$('#div_mobile_check_fail').css('display','none');
	                		Dmall.LayerPopupUtil.open($('#popup_mobile_check'));
	                	}
	                });
	                
	                return false;
	            }
            }
            
            if($('#mobileCertifyYn').val() != 'Y'){
            	Dmall.LayerUtil.alert("휴대전화 인증을 해주세요.", "확인");
            	return false;
            }
            /* if($('#select_birth_year').length > 0) {
                var year = jQuery('#select_birth_year option:selected').val();
                var month = jQuery('#select_birth_month option:selected').val();
                var date = jQuery('#select_birth_day option:selected').val();

                if(year == '' || month == '' || date == '') {
                    Dmall.LayerUtil.alert("생일을  입력해주세요.", "확인");
                    return false;
                } else {
                    $('#birth').val(year+month+date);
                    $('#bornYear').val(year);
                    $('#bornMonth').val(month);
                }
            } */
            Dmall.validate.set('form_id_update');
            if(customerInputCheck()){
            	if('${so.integrationMemberGbCd}' == '02'){
            		//이름,휴대전화번호로 기존회원 여부 체크
                	var url = '/front/member/duplication-mem-check';
                	var memberNm = '${resultModel.data.memberNm}';
                	var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
    				var param = {memberNm : memberNm, mobile : mobile}
    				Dmall.AjaxUtil.getJSON(url, param, function(result) {
    					if(result.length > 0){
    						var html = '';
                        	var loginId = '';
                        	var integration = '01';
                        	for(var i=0; i<result.length;i++){
                        		if(html != '') html += ", ";
                        		if(result[i].joinPathCd == 'NV'){
                        			loginId += '네이버 로그인';
                        		}else if(result[i].joinPathCd == 'KT'){
                        			loginId += '카카오톡 로그인';
                        		}else if(result[i].joinPathCd == 'FB'){
                        			loginId += '페이스북 로그인';
                        		}else{
                            		loginId = result[i].loginId;
                            		loginId = loginId.substring(0,loginId.length - 3);
                            		loginId += '***';
                        		}
                        		html += loginId;
                        		
                        		if(result[i].integrationMemberGbCd == '03') {
                        			var integration = '03';
                        		}
                        	}
                        	if(integration == '03'){
                        		$('#txt_integration').text('이미 통합 된 아이디가 있습니다.');
                        	}else{
                        		$('#txt_integration').text('이미 가입 된 정회원 아이디가 있습니다.');
                        	}
                        	html = '(' + html + ')';
                        	$('#mem_dulicate_id_list').html(html);
                        	
                        	Dmall.LayerPopupUtil.open($('#popup_mem_duplicate_check'));
                        	
    					}else{
							memberUpdate();
    					}
    				});
            	}else{
            		memberUpdate();
            	}
            }
        });

        $('#btn_change_pw').on('click',function (){
            resetPwPopup();
            Dmall.LayerPopupUtil.open($('#popup_new_pw'));
        });
        $('#btn_change_cofirm').on('click',function (){
            if ($('#newPw').val().indexOf("${resultModel.data.loginId}") > -1) {
                Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "확인");
                return false;
            }
            if( $('#newPw').val() !=  $('#newPw_check').val()){
                Dmall.LayerUtil.alert("비밀번호 입력/확인이 일치하지 않습니다.", "알림");
                return;
            }
            if(passwordCheck($('#newPw').val())){
                var url = '/front/member/update-password';
                var param = $('#form_id_pw_pop').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         Dmall.LayerUtil.alert("비밀번호가 성공적으로 변경되었습니다.", "알림");
                         Dmall.LayerPopupUtil.close("popup_new_pw");
                     }else{
                    	 Dmall.LayerUtil.alert(result.message, "알림");
                     }
                });
            }
        });

        $("#mobile_auth").click(function(){
            openDRMOKWindow();
        });
        $("#ipin_auth").click(function(){
            openIPINWindow();
        });
        $('#btn_go_integration02').click(function(){
        	location.href = "/front/member/member-integration-form"
        });
        
      	//파일 변경
        var num = 1;
        jQuery(document).on('change',"input[type=file]", function(e) {
            var bbsId = "${so.bbsId}";
            var fileSize = 0;
            if(jQuery(this).attr('id') == "input_id_image"){
                return;
            }
            
            var fileSize = $(this)[0].files[0].size;
            var maxSize = <spring:eval expression="@front['system.upload.file.size']"/>;
            
            if(fileSize > maxSize){
            	var maxSize_MB = maxSize / (1024*1024);
            	Dmall.LayerUtil.alert('파일 용량 '+maxSize_MB.toFixed(2)+' Mb 이내로 등록해 주세요.','','');
            	return;
            }

            var ext = jQuery(this).val().split('.').pop().toLowerCase();
            //'pptx','ppt','xls','xlsx','doc','docx','hwp', 제외
            if($.inArray(ext, ['pdf','gif','png','jpg']) == -1) {
                Dmall.LayerUtil.alert('jpg, png, gif, pdf 형식의 파일만 업로드 할 수 있습니다.','','');
                $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                $("#input_id_files"+num).val("");
                return;
            }

            var fileNm = e.target.value.substring(e.target.value.lastIndexOf('\\') + 1);
            totalFileLength = totalFileLength+1;
            
            if(totalFileLength>1){
                Dmall.LayerUtil.alert('첨부파일는 최대 1개까지 등록 가능합니다.');
                totalFileLength = totalFileLength-1;
                $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                $("#input_id_files"+num).val("");
                return;
            }

            document.getElementById("fileSpan"+num).style.display = "none";

            var text = "<span class='file_add'  name='_fileNm"+num+"' id='_fileNm"+num+"'>" +
                            "<span id='tes"+num+"'>"+fileNm+"</span>" +
                            "<button type='button' onclick= 'return delNewFileNm("+num+","+fileSize+")' class='btn_del'>" +
                            "</button>" +
                        "</span>";

            $( "#viewFileInsert" ).empty().append( text );
            num = num+1;
            $( "#fileSetList" ).append(
                "<span id=\"fileSpan"+num+"\" style=\"visibility: visible\">"+
                "<label for=\"input_id_files"+num+"\">파일등록</label>"+
                "<input class=\"upload-hidden\" name=\"files"+num+"\" id=\"input_id_files"+num+"\" type=\"file\">"+
                " </span>"
            );
        });
        
    });

    var VarMobile = {
        server:''
    };

    // mobile auth popup
    var KMCIS_window;
    function openDRMOKWindow(){
        DRMOK_window = window.open('', 'DRMOKWindow', 'width=460, height=680, resizable=0, scrollbars=no, status=no, titlebar=no, toolbar=no, left=435, top=250' );
        if(DRMOK_window == null){
            alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
        }

        var certUrl = '';
        if(VarMobile.server === 'local') {
            certUrl = 'https://dev.mobile-ok.com/popup/common/hscert.jsp';
        } else {
            certUrl = 'https://www.mobile-ok.com/popup/common/hscert.jsp';
        }

        document.reqDRMOKForm.action = certUrl;
        document.reqDRMOKForm.target = 'DRMOKWindow';
        document.reqDRMOKForm.submit();
    }
    // ipin auth popup
    function openIPINWindow(){
        window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
        document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
        document.reqIPINForm.target = "popupIPIN2";
        document.reqIPINForm.submit();
    }

    function successIdentity(){
        var url = '/front/member/identity-success';
        var param = $('#form_id_update').serializeArray();
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                Dmall.LayerUtil.alert("본인인증 완료되었습니다.", "알림");
                location.href = "/front/member/information-update-form"
            }
        });
    }
  	//파일 삭제
    function delNewFileNm(fileNo, fileSize){
        totalFileLength = totalFileLength-1;
        $("#_fileNm"+fileNo).remove();
        $("#input_id_files"+fileNo).remove();
        return false;
    }
  	
  	//생년월일 유효성 체크
    function isValidDate(dateStr) {
         var year = Number(dateStr.substr(0,4)); 
         var month = Number(dateStr.substr(4,2));
         var day = Number(dateStr.substr(6,2));
         var today = new Date(); // 날자 변수 선언
         var yearNow = today.getFullYear();
         if (month < 1 || month > 12) { 
              alert("달은 1월부터 12월까지 입력 가능합니다.");
              return false;
         }
        if (day < 1 || day > 31) {
              alert("일은 1일부터 31일까지 입력가능합니다.");
              return false;
         }
         if ((month==4 || month==6 || month==9 || month==11) && day==31) {
              alert(month+"월은 31일이 존재하지 않습니다.");
              return false;
         }
         if (month == 2) {
              var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
              if (day>29 || (day==29 && !isleap)) {
                   alert(year + "년 2월은  " + day + "일이 없습니다.");
                   return false;
              }
         }
         
         if (year > yearNow) {
        	 alert("년도를 확인하세요. 생년월일 형식이 잘못되었습니다.");
             return false;
         }
         
         return true;
    }
  	
  	function memberUpdate(){
  		
  		var confirmTxt = '수정'
		var itgGbCd = $('#integrationMemberGbCd').val();
        if(itgGbCd == '02'){
        	confirmTxt = '정회원 전환'
        }
        Dmall.LayerUtil.confirm(confirmTxt+" 하시겠습니까?",
        	function() {
        		Dmall.waiting.start();
        	   	$('#form_id_update').ajaxSubmit({
            		url : '/front/member/member-update',
            		dataType : 'json',
                    success : function(result){
                    	Dmall.validate.viewExceptionMessage(result, 'form_id_update');
                    	if(result.success) {
                    		Dmall.waiting.stop();
                    		Dmall.LayerUtil.alert("수정 되었습니다.", "알림").done(function(){
								location.href="/front/member/information-update-form";
							});

                    	}else{
                       		Dmall.waiting.stop();
                       		Dmall.LayerUtil.alert(result.message, "알림");
                        }
                    }
                })
          	}
            , function() {
       			return false;
       		}
		);
  	}
  	
    var min = 0;
    var sec = 0;
    var time = 0;
    var runCount;
    function fnCountDown(){
    	time = 180;
    	runCount = setInterval(startCountDown, 1000);
    }
    
    function startCountDown(){
    	//hour = parseInt(time/3600);
		min = parseInt((time%3600)/60);
		sec = time%60;
		if(sec < 10){
			sec = '0' + sec;
		}
		$("#certify_timer").text(min+"분 "+sec+"초");
		if(parseInt(time) == 0){
			stopCountDown();
			$('#div_mobile_check').css('display','none');
			$('#div_mobile_check_fail').css('display','block');
		} else {
			time--;
		}
    }
    
    function stopCountDown() {
    	clearInterval(runCount);
	}
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->

    <!--- 02.LAYOUT: 마이페이지 --->
	<div class="mypage_middle">	
    
   		<!--- 마이페이지 왼쪽 메뉴 --->
       	<%@ include file="include/mypage_left_menu.jsp" %>
		<!---// 마이페이지 왼쪽 메뉴 --->

		<!--- 마이페이지 오른쪽 컨텐츠 --->
		<div id="mypage_content">
           	<form:form id="form_id_search" commandName="so">
              	<form:hidden path="page" id="page" />
              	<form:hidden path="rows" id="rows" />
           	</form:form>
           	
            <!--- 마이페이지 탑 --->
            <%@ include file="include/mypage_top_menu.jsp" %>
    
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_body">
				<h3 class="my_tit"><c:choose><c:when test="${so.integrationMemberGbCd eq '02'}">정회원 전환</c:when><c:otherwise>회원정보수정</c:otherwise></c:choose></h3>
				<div class="my_member_area">
					<form:form id="form_id_update" commandName="vo">
		                <form:hidden path="memberDi" id="memberDi" value=""/>
		                <form:hidden path="certifyMethodCd" id="certifyMethodCd" value=""/>
		                <form:hidden path="emailRecvYn" id="emailRecvYn" />
		                <form:hidden path="smsRecvYn" id="smsRecvYn" />
		                <form:hidden path="tel" id="tel" />
		                <form:hidden path="mobile" id="mobile" />
		                <form:hidden path="email" id="email" />
		                <form:hidden path="loginId" id="loginId" />
		                <c:if test="${!empty resultModel.data.birth}">
				            <c:set var="bornYear" value="${fn:substring(resultModel.data.birth,0,4)}"/>
				            <c:set var="bornMonth" value="${fn:substring(resultModel.data.birth,4,6)}"/>
				        </c:if>
		                <input type="hidden" name="bornYear" id="bornYear" value="${bornYear}" />
        				<input type="hidden" name="bornMonth" id="bornMonth" value="${bornMonth}" />
		                <form:hidden path="memberGbCd" id="memberGbCd" value="${resultModel.data.memberTypeCd }"/>
		                <input type="hidden" name="integrationMemberGbCd" id="integrationMemberGbCd" value="${so.integrationMemberGbCd}" />
		                <input type="hidden" id="mobileCertifyYn" value="<c:out value="${so.integrationMemberGbCd eq '02' ? 'N' : 'Y'}"/>" />
						<table class="tInsert">
							<caption>개인회원 정보입력 폼입니다.</caption>
							<colgroup>
								<col style="width:224px">
								<col style="">
							</colgroup>
							<tbody>
								<tr>
									<th class="vaT">아이디</th>
									<td>
										<c:choose>
											<c:when test="${resultModel.data.joinPathCd eq 'SHOP' }">
												<c:choose>
													<c:when test="${resultModel.data.idChgYn eq 'N' }">
														<input type="text" id="chgId" name="chgId" value="${resultModel.data.loginId}" readonly="readonly" style="width:124px;margin-right:10px">
														<input type="hidden" id="idChgYn" name="idChgYn" value="${resultModel.data.idChgYn}">
														<button type="button" class="btn_change_pw btn_id_check">아이디변경</button>
													</c:when>
													<c:otherwise>
														${resultModel.data.loginId}	
													</c:otherwise>
												</c:choose>
												
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${resultModel.data.joinPathCd eq 'FB'}">페이스북 로그인</c:when>
													<c:when test="${resultModel.data.joinPathCd eq 'NV'}">네이버 로그인</c:when>
													<c:when test="${resultModel.data.joinPathCd eq 'KT'}">카카오 로그인</c:when>
												</c:choose>
											</c:otherwise>
										</c:choose>
										<c:choose>
											<c:when test="${so.integrationMemberGbCd eq '01'}">
												<span class="label_basic marginL05">정회원</span>
												<button type="button" class="btn_membership_plus marginL03" id="btn_go_integration02">멤버쉽통합▶</button>
											</c:when>
											<c:when test="${so.integrationMemberGbCd eq '02'}">
												<span class="label_basic marginL05">간편회원</span>
											</c:when>
											<c:when test="${so.integrationMemberGbCd eq '03'}">
												<span class="label_basic marginL05">통합회원</span>
											</c:when>
										</c:choose>
										<c:if test="${resultModel.data.joinPathCd ne 'SHOP' }">
											<p class="info">* 정회원 전환 후에도 사용중이던 SNS 계정으로 로그인하시면 됩니다.</p>
										</c:if>
									</td>
								</tr>
								<c:if test="${resultModel.data.joinPathCd eq 'SHOP' }">
									<tr>
										<th>비밀번호</th>
										<td>
											<input type="password" id="pw" name="pw" style="width:124px;margin-right:10px" maxlength="16">
											<button type="button" class="btn_change_pw" id="btn_change_pw">비밀번호변경</button>
										</td>
									</tr>
								</c:if>
								<c:if test="${resultModel.data.memberTypeCd eq '01'}">
								<tr>
									<th>이름 <span class="important">*</span></th>
									<td>
										<input type="text" id="memberNm" name="memberNm" value="${resultModel.data.memberNm}">
										<input type="hidden" id="chgMemberNm" name="chgMemberNm">
									</td>
								</tr>
								<tr>
									<th>성별 <span class="important">*</span></th>
									<td>
										<input type="radio" id="female" name="genderGbCd" value="F" class="member_join">
										<label for="female"><span></span>여성</label>
										<input type="radio" id="male" name="genderGbCd" value="M" class="member_join">
										<label for="male" class="marginL20"><span></span>남성</label>
									</td>
								</tr>
								<tr>
									<th>생년월일 <span class="important">*</span></th>
									<td>
										<input type="text" id="birth" name="birth" value="${resultModel.data.birth}" placeholder="ex.19950315">
									</td>
								</tr>
								</c:if>

								<c:if test="${resultModel.data.memberTypeCd eq '02'}">
								<tr>
				                    <th>사업자등록번호</th>
				                    <td>
				                        ${resultModel.data.bizRegNo}
				                    </td>
				                </tr>
				                <tr>
				                    <th>사업자등록증 사본 <span class="important">*</span></th>
				                    <td>
				                        <div class="filebox">
				                            <span id = "fileSetList">
				                                <span id="fileSpan1" style="visibility: visible">
				                                    <label for="input_id_files1">파일등록</label>
				                                    <%--<input disabled="disabled" class="upload-name" value="">--%>
				
				                                    <input class="upload-hidden" name="files1" id="input_id_files1" type="file">
				                                </span>
				                            </span>
				                            <span id="viewFileInsert">${resultModel.data.bizOrgFileNm}</span>
				                        </div>
				                        <br>
				                        <input type="hidden" name="bizFileNm" value="${resultModel.data.bizFileNm }">
				                        <spring:eval expression="@front['system.upload.file.size']" var="maxSize" />
										<fmt:parseNumber value="${maxSize / (1024*1024) }" var="maxSize_MB" integerOnly="true" />
				                        <p>(jpg, png, gif, pdf 형식 ${maxSize_MB }Mb 이내)</p>
				                    </td>
				                </tr>
				                <tr>
									<th>업체명</th>
									<td>
										<input type="text" id="memberNm" name="memberNm" value="${resultModel.data.memberNm}">
										<input type="hidden" id="chgMemberNm" name="chgMemberNm">
									</td>
								</tr>
								<tr>
				                    <th>대표자명</th>
				                    <td>
				                        <input type="text" id="ceoNm" name="ceoNm" value="${resultModel.data.ceoNm}" maxlength="10" >
				                    </td>
				                </tr>
								</c:if>
								<c:if test="${resultModel.data.memberTypeCd eq '01'}">
								<tr>
									<th>휴대전화 <span class="important">*</span></th>
									<td>
										<select id="mobile01" class="phone">
											<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
										</select>
										<span class="bar">-</span>
										<input type="text" id="mobile02" class="phone" maxlength="4">
										<span class="bar">-</span>
										<input type="text" id="mobile03" class="phone" maxlength="4">
										<c:if test="${so.integrationMemberGbCd eq '02'}">
											<button type="button" class="btn_form btn_mobile_check">인증받기</button>
										</c:if>
									</td>
								</tr>
								<tr>
									<th>이메일 <span class="important">*</span></th>
									<td>
										<input type="text" id="email01" style="width:124px;"> @ <input type="text" id="email02" style="width:124px;">
										<div class="select_box28" style="display:inline-block">
											<label for="email03"></label>
											<select class="select_option" id="email03" title="select option">
												<option value="" selected="selected">- 이메일 선택 -</option>
												<option value="etc">직접입력</option>
												<option value="naver.com">naver.com</option>
												<option value="hanmail.net">hanmail.net</option>
												<option value="daum.net">daum.net</option>
												<option value="gmail.com">gmail.com</option>
												<option value="nate.com">nate.com</option>
												<!-- <option value="hotmail.com">hotmail.com</option>
												<option value="yahoo.com">yahoo.com</option>
												<option value="empas.com">empas.com</option>
												<option value="korea.com">korea.com</option>
												<option value="dreamwiz.com">dreamwiz.com</option> -->
											</select>
										</div>
									</td>
								</tr>
								</c:if>
								<tr>
									<th class="vaT">주소</th>
									<td>
										<input type="text" id="newPostNo" name="newPostNo" value="${resultModel.data.newPostNo}" readonly="readonly">
										<button type="button" class="btn_form" id="btn_post">우편번호</button><br>
										<input type="text" class="form_address" id="strtnbAddr" name="strtnbAddr" value="${resultModel.data.strtnbAddr}" style="width:371PX;" readonly="readonly"><br>
										<input type="text" class="form_address" id="roadAddr" name="roadAddr" value="${resultModel.data.roadAddr}" style="width:371PX;" readonly="readonly"><br>
										<input type="text" class="form_address" id="dtlAddr" name="dtlAddr" value="${resultModel.data.dtlAddr}" placeholder="상세주소">
									</td>
								</tr>
								<c:if test="${resultModel.data.memberTypeCd eq '02'}">
								<tr>
				                    <th>담당자명 <span class="important">*</span></th>
				                    <td>
				                        <input type="text" id="managerNm" name="managerNm" value="${resultModel.data.managerNm}" maxlength="10" >
				                    </td>
				                </tr>
				                <tr>
									<th>휴대전화 <span class="important">*</span></th>
									<td>
										<select id="mobile01" class="phone">
											<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
										</select>
										<span class="bar">-</span>
										<input type="text" id="mobile02" class="phone" maxlength="4">
										<span class="bar">-</span>
										<input type="text" id="mobile03" class="phone" maxlength="4">
										<c:if test="${so.integrationMemberGbCd eq '02'}">
											<button type="button" class="btn_form btn_mobile_check">인증받기</button> -->
										</c:if>
									</td>
								</tr>
								<tr>
									<th>이메일 <span class="important">*</span></th>
									<td>
										<input type="text" id="email01" style="width:124px;"> @ <input type="text" id="email02" style="width:124px;">
										<div class="select_box28" style="display:inline-block">
											<label for="email03"></label>
											<select class="select_option" id="email03" title="select option">
												<option value="" selected="selected">- 이메일 선택 -</option>
												<option value="etc">직접입력</option>
												<option value="naver.com">naver.com</option>
												<option value="hanmail.net">hanmail.net</option>
												<option value="daum.net">daum.net</option>
												<option value="gmail.com">gmail.com</option>
												<option value="nate.com">nate.com</option>
												<!-- <option value="hotmail.com">hotmail.com</option>
												<option value="yahoo.com">yahoo.com</option>
												<option value="empas.com">empas.com</option>
												<option value="korea.com">korea.com</option>
												<option value="dreamwiz.com">dreamwiz.com</option> -->
											</select>
										</div>
									</td>
								</tr>
								</c:if>
								<tr>
									<th class="vaT">마케팅수신동의</th>
									<td>
										<input type="checkbox" name="email_get" id="email_get" <c:if test="${resultModel.data.emailRecvYn eq 'Y'}">checked</c:if> class="agree_check">
										<label for="email_get"><span></span>이메일</label>
										<input type="checkbox" name="sms_get" id="sms_get" <c:if test="${resultModel.data.smsRecvYn eq 'Y'}">checked</c:if> class="agree_check">
										<label for="sms_get" class="marginL20"><span></span>SMS</label>
										<p class="info02">* 약관변경, 주문/배송 등과 같이 주요 정책, 정보에 대한 안내는 수신동의 여부와 무관하게 발송됩니다.</p>
									</td>
								</tr>
								<c:if test="${resultModel.data.recomMemberId ne null and resultModel.data.recomMemberId != ''}">
					            <tr>
									<th class="vaT">추천인 아이디</th>
									<td>${resultModel.data.recomMemberId}</td>
								</tr>
								</c:if>
							</tbody>
						</table>
					</form:form>
					<div class="btn_area">
						<button type="button" class="btn_change_member"><c:choose><c:when test="${so.integrationMemberGbCd eq '02'}">정회원 전환</c:when><c:otherwise>회원정보수정</c:otherwise></c:choose></button>
					</div>
				</div>
                <!---// 기본정보 --->
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->

    <!--- popup 새 비밀번호 입력 --->
    <div class="popup_new_pw" id="popup_new_pw" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">새 비밀번호 입력</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <span class="f13">새로운 비밀번호를 입력해 주세요.</span>
            <form id="form_id_pw_pop">
            <table class="tMember_Insert" style="margin-top:10px">
                <caption>
                    <h1 class="blind">새 비밀번호 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:140px">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th style="padding:5px 7px">현재 비밀번호</th>
                        <td style="padding:5px 7px"><input type="password" name="nowPw" id="nowPw" style="width:165px;" maxlength="16"></td>
                    </tr>
                    <tr>
                        <th style="padding:5px 7px">새 비밀번호</th>
                        <td style="padding:5px 7px"><input type="password" name="newPw" id="newPw" style="width:165px;" maxlength="16"></td>
                    </tr>
                    <tr>
                        <th style="padding:5px 7px">새 비밀번호 확인</th>
                        <td style="padding:5px 7px"><input type="password" name="newPw_check" id="newPw_check" style="width:165px;" maxlength="16"></td>
                    </tr>
                    <!--
                    <tr>
                        <td colspan="2" class="popup_imp txtc">비밀번호가 일치하지 않습니다.</td>
                    </tr>
                     <tr>
                        <td colspan="2" class="popup_imp txtc">영문(대소문자구분)/숫자/특수문자 조합 8~12자로 입력하세요.</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="popup_imp txtc">비밀번호가 일치하지 않습니다.</td>
                    </tr>
                     -->
                </tbody>
            </table>
            </form>
            <ul class="popup_slist">
                <li>비밀번호는 영문, 숫자, 특수문자 포함하여, 2가지 이상 조합하여 최소 8자~최대 16자로 만들어주세요.</li>
                <li>아이디와 동일하거나, 3자리 이상 반복되는 문구와 숫자는 불가합니다.</li>
            </ul>
            <div class="popup_btn_area">
                <button type="button" class="btn_popup_ok" id="btn_change_cofirm">변경하기</button>
            </div>
        </div>
    </div>
    <!---// popup 새 비밀번호 입력 --->
    <!--- popup 아이디 중복확인 --->
    <div id="popup_id_duplicate_check" style="width:500px;display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">아이디 중복확인</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <div class="pw_search_info" style="width:100%">
                아이디는 영문, 숫자 가능하며 6~20자 이내로 입력해주세요.
            </div>
            <ul class="id_duplicate_check">
                <li>
                    <input type="text" id="id_check" maxlength="20">
                    <button type="button" class="btn_id_duplicate_check" id="btn_id_duplicate_check">중복확인</button>
                </li>
            </ul>
            <div>
                <div class="id_duplicate_check_info" ></div>
                <div class="textC" id="id_success_div" style="display: none;">
                    <button type="button" class="btn_popup_login" id="btn_popup_login" style="margin-top:22px">사용하기</button>
                </div>
            </div>
        </div>
    </div>
    <!---// popup 아이디 중복확인 --->
    <!--- popup 회원 중복확인 --->
    <div id="popup_mem_duplicate_check" class="layer_popup popup_total_member" style="display:none;">
        <div class="pop_wrap">
            <button type="button" class="btn_close_popup"></button>
	        <div class="popup_content">
	        	<div class="total_member_tit">
	        		<span id="txt_integration">
	        			이미 가입 된 정회원 아이디가 있습니다.
	        		</span>
					<p class="total_id_box" id="mem_dulicate_id_list"></p>
				</div>
				<div class="total_member_text">
					비밀번호를 잊어버리셨다면 <a href="javascript:Dmall.FormUtil.submit('/front/login/account-search?mode=pass');" >비밀번호찾기</a>를 이용해주세요.
					<br>ID 변경을 원하시는 경우 마이페이지에서 변경 가능합니다.(1회)
				</div>
				<!-- <p class="total_member_ing">신규 정회원 전환을 원하시는 경우 <a href="javascript:;" id="mem_duplicate_continue">계속하기</a></p> -->
	        </div>
		</div>
    </div>
    <!---// popup 회원 중복확인 --->
    <!--- popup 모바일 인증 --->
    <div id="popup_mobile_check" style="width:500px;display:none;">
        <div class="popup_header">
            <h1 class="popup_tit">휴대전화 인증</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
        	<div class="mobile_certify_info" id="div_mobile_check" style="width:100%">휴대전화 문자메세지로 전송된 인증번호 6자리를</br>입력하신 후 확인 버튼을 눌러주세요.
        		<div style="padding:10px 0;">
		            <ul>
		                <li>
		                	<span class="insert_guide">인증번호</span>
		                	<input type="text" id="certify_key" maxLength="6">
		                	<button type="button" class="btn_mobile_certify_resend" id="btn_mobile_resend">재전송</button>
		                </li>
		                <li>
		                	<div style="padding:10px 0;">
		                		( 남은시간 <span id="certify_timer" style="color:red;">3분 00초</span> )
		                		<button type="button" class="btn_mobile_certify_timer_reset" onClick="javascript:stopCountDown();fnCountDown();">시간연장</button>
		                	</div>
		                </li>
		                <li>
		                	<div style="padding:10px 0;">
		                		<button type="button" class="btn_mobile_certify_confirm" id="btn_mobile_confirm">확인</button>
		                	</div>
		                </li>
		            </ul>
				</div>
			</div>
            <div class="mobile_certify_info" id="div_mobile_check_fail" style="width:100%;display:none;">인증시간 만료되었습니다. 다시 시도해주세요.
            	<div style="padding:30px 0 0 0;">
            		<button type="button" class="btn_mobile_certify_close" id="btn_mobile_close">닫기</button>
            	</div>
            </div>
        </div>
    </div>
    <!---// popup 모바일 인증 --->
    <form name="reqDRMOKForm" method="post">
        <input type="hidden" name="req_info" value ="${mo.reqInfo}" />
        <input type="hidden" name="rtn_url" value ="${mo.rtnUrl}" />
        <input type="hidden" name="cpid" value = "${mo.cpid}" />
        <input type="hidden" name="design" value="pc"/>
    </form>
    <form name="reqIPINForm" method="post">
        <input type="hidden" name="m" value="pubmain">                      <!-- 필수 데이타로, 누락하시면 안됩니다. -->
        <input type="hidden" name="enc_data" value="${io.encData}">       <!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
        <!-- 업체에서 응답받기 원하는 데이타를 설정하기 위해 사용할 수 있으며, 인증결과 응답시
        해당 값을 그대로 송신합니다. 해당 파라미터는 추가하실 수 없습니다. -->
        <input type="hidden" name="param_r1" value="s">
    </form>
    </t:putAttribute>
</t:insertDefinition>