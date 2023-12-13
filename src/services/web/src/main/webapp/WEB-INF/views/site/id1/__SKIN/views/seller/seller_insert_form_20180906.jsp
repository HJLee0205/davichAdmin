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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>

<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">판매자</t:putAttribute>
    <t:putAttribute name="script">
        <script src="/front/js/member.js" type="text/javascript" charset="utf-8"></script>
        <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
        <script>
            
            $(document).ready(function() {
                //우편번호 팝업 
                jQuery('#a_id_post').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.zipcode(setZipcode);

                });
                
                //반품 우편번호 팝업 
                jQuery('#b_id_post').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.zipcode(ret_setZipcode);
                });
                
                
                // 대표 e-mail selectBox
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
                
                //담당자 e-mail selectBox
                var mEmailSelect = $('#managerEmail03');
                var mEmailTarget = $('#managerEmail02');
                mEmailSelect.bind('change', null, function() {
                    var host = this.value;
                    if (host != 'etc' && host != '') {
                    	mEmailTarget.attr('readonly', true);
                    	mEmailTarget.val(host).change();
                    } else if (host == 'etc') {
                    	mEmailTarget.attr('readonly'
                                , false);
                    	mEmailTarget.val('').change();
                    	mEmailTarget.focus();
                    } else {
                    	mEmailTarget.attr('readonly', true);
                    	mEmailTarget.val('').change();
                    }
                });
                
                //담당자 이메일
                var _managerEmail = '${resultModel.data.managerEmail}';
                
                var temp_managerEmail = _managerEmail.split('@');
                $('#managerEmail01').val(temp_managerEmail[0]);
                
                if(mEmailSelect.find('option[value="'+temp_managerEmail[1]+'"]').length > 0) {
                	mEmailSelect.val(temp_managerEmail[1]);
                } else {
                	mEmailSelect.val('etc');
                }
                mEmailSelect.trigger('change');
                mEmailTarget.val(temp_managerEmail[1]);
                
                
                //판매자리스트 화면으로 이동
                $("#viewMemListBtn").on('click', function(e) {
                    location.replace("/admin/seller/seller-list");
                });
                
				// id 중복체크
                $('#btn_id_check').on('click',function (){
                    $("#id_check").val( $('#loginId').val());
                    Dmall.LayerPopupUtil.open($('#popup_id_duplicate_check'));
                    if(!Dmall.validation.isEmpty($("#id_check").val())) {
                        $('.btn_id_duplicate_check').click();
                    }
                });
				
	            var check_id;
	            $('.btn_id_duplicate_check').on('click',function (){
	                var url = '/front/seller/duplication-id-check';
	                var loginId = $('#id_check').val();
	                if(Dmall.validation.isEmpty($("#id_check").val())) {
	                    $('#id_success_div').attr('style','display:none;');
	                    Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
	                    return false;
	                }else{
	                    if(idCheck(loginId)){
	                    var param = {sellerId : loginId};
	                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
	                         if(result.success) {
	                             check_id = loginId;
	                             $('#id_success_div').attr('style','display:block;');
	                             $('.id_duplicate_check_info').html('사용 가능한 아이디 입니다.')
	                         }else{
	                             $('.id_duplicate_check_info').html('사용불가능한 아이디 입니다.');
	                             $('#id_success_div').attr('style','display:none;');
	                             $('#loginId').val('');
	                         }
	                     });
	                   }
	                }
	            });
	            
                //아이디 사용하기
                $('.btn_popup_login').on('click',function (){
                    Dmall.LayerPopupUtil.close('popup_id_duplicate_check');
                    $('#loginId').val(check_id);
                    $('#chkSellerId').val(true);
                });
                
                
                //판매자 등록
                $('#btn_save').on('click',function (){
                	
                	if (!checkValidation()) {
                		return false ;
                	}
					
                	// 이메일 세팅
                	$('#email').val($('#email01').val() + '@' + $('#email02').val());
                	$('#managerEmail').val($('#managerEmail01').val() + '@' + $('#managerEmail02').val());
                	
                    var url = '/front/seller/seller-info-save',
                    param = jQuery('#form_id_sellerDtl').serialize();
                	
                    if (Dmall.FileUpload.checkFileSize('form_id_sellerDtl')) {
                        $('#form_id_sellerDtl').ajaxSubmit({
                            url : url,
                            dataType : 'json',
                            success : function(result){
                                Dmall.validate.viewExceptionMessage(result, 'form_id_sellerDtl');
                                if(result.success){
                                    Dmall.LayerUtil.alert(result.message).done(function(){
                                        Dmall.FormUtil.submit('/front/main-view');
                                    })
                                }else{
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        });
                    }
                });
                
                
//                 jQuery('label.radio').off('click').on('click', function(e) {
                	
//                     var dlvrGb = $(this).find('input:radio[name=DlvrGb]').val();
                    
//                     fn_radio_set(dlvrGb);
//                 });                
                
                //배송비 설정
//              fn_delivery_set();
                
                //첨부파일 설정
                fn_file_set();
                
                jQuery(document).on('change',"input[type=file]", function(e) {
                    var type_gb = jQuery(this).attr('id');
                    
                    var ext = jQuery(this).val().split('.').pop().toLowerCase();
                    if(type_gb=="input_id_files1"){
                        if($.inArray(ext, ['jpg', 'gif', 'pdf']) == -1) {
                            Dmall.LayerUtil.alert('jpg,gif,pdf 파일만 업로드 할수 있습니다.','','');
                            $("#fileBoxsNm1").val("파일찾기");
                            return;
                        }
                    } else if(type_gb=="input_id_files2"){
                        if($.inArray(ext, ['jpg', 'gif', 'pdf']) == -1) {
                            Dmall.LayerUtil.alert('jpg,gif,pdf 파일만 업로드 할수 있습니다.','','');
                            $("#fileBoxsNm2").val("파일찾기");
                            return;
                        }
                    } else if(type_gb=="input_id_files3"){
                        if($.inArray(ext, ['zip']) > 0) {
                            Dmall.LayerUtil.alert('zip 파일은 업로드 할수 없습니다..');
                            $("#fileBoxsNm3").val("파일찾기");
                            return;
                        }
                    } else if(type_gb=="input_id_files4"){
                        if($.inArray(ext, ['jpg']) == -1) {
                            Dmall.LayerUtil.alert('jpg 파일만 업로드 할수 없습니다..');
                            $("#fileBoxsNm4").val("파일찾기");
                            return;
                        }
                    }
                });                
                
            });
            
            function fn_delivery_set() {
            	
           	   $('input:radio[name=DlvrGb]').each(function() {
                   var $chkinput = $(this)
                       , $chk = $chkinput.parent().parent()
                       , chkId = $chkinput.attr("id");

                   $chk.removeClass('on');
                   $chkinput.attr('checked', false);
               });
           	   
               //배송비 구분
               var dlvrGb = "${resultModel.data.dlvrGb}";
               
               $("#rd" + dlvrGb).addClass('on');
               $("#radio" + dlvrGb).attr("checked",true);
               
               fn_radio_set(dlvrGb);
               
               $('#dlvrAmt').val('${resultModel.data.dlvrAmt}');
               $('#chrgSetAmt').val('${resultModel.data.chrgSetAmt}');
               $('#chrgDlvrAmt').val('${resultModel.data.chrgDlvrAmt}');
            }
            
            
            function fn_radio_set(dlvrGb) {
            	
                if (dlvrGb == "01") {
                    $('#dlvrAmt').attr("disabled",true).val('');
                    $('#chrgSetAmt').attr("disabled",true).val('');
                    $('#chrgDlvrAmt').attr("disabled",true).val('');
                } else if (dlvrGb == "02") {
                    $('#dlvrAmt').attr("disabled",false).val('');
                    $('#chrgSetAmt').attr("disabled",true).val('');
                    $('#chrgDlvrAmt').attr("disabled",true).val('');
                } else if (dlvrGb == "03") {
                    $('#dlvrAmt').attr("disabled",true).val('');
                    $('#chrgSetAmt').attr("disabled",false).val('');
                    $('#chrgDlvrAmt').attr("disabled",false).val('');
                }
            }
            
            function fn_file_set() {
            	
            	var bizOrgFileNm = "${resultModel.data.bizOrgFileNm}";
            	
            	if (bizOrgFileNm != null && bizOrgFileNm != "") {
	                var bizFile = '<span>'+bizOrgFileNm+'</span>'+
	                '    <button class="btn_del btn_comm" onclick= "return delFileNm(1)" ></button>';
	                jQuery("#bizFileInert").html(bizFile);
            	}
                
	        	var bkCopyOrgFileNm = "${resultModel.data.bkCopyOrgFileNm}";
	        	
	        	if (bkCopyOrgFileNm != null && bkCopyOrgFileNm != "") {
	                var bkCopyFile = '<span>'+bkCopyOrgFileNm+'</span>'+
	                '    <button class="btn_del btn_comm" onclick= "return delFileNm(2)" ></button>';
	                jQuery("#bkFileInert").html(bkCopyFile);
	        	}
	                
	                
	        	var etcOrgFileNm = "${resultModel.data.etcOrgFileNm}";
	        	
	        	if (etcOrgFileNm != null && etcOrgFileNm != "") {
	                var etcFile = '<span>'+etcOrgFileNm+'</span>'+
	                '    <button class="btn_del btn_comm" onclick= "return delFileNm(3)" ></button>';
	                jQuery("#etcFileInert").html(etcFile);
	        	}
	        	
	        	
	        	var ceoOrgFileNm = "${resultModel.data.ceoOrgFileNm}";
	        	
	        	if (ceoOrgFileNm != null && ceoOrgFileNm != "") {
	                var ceoFile = '<span>'+ceoOrgFileNm+'</span>'+
	                '    <button class="btn_del btn_comm" onclick= "return delFileNm(4)" ></button>';
	                jQuery("#ceoFileInert").html(ceoFile);
	        	}	        	
	        	
            }
            
            function delFileNm(fileGbn){
                var url = '/admin/seller/attach-file-delete';
                
          		var param = {};
            	param.sellerNo = $('#sellerNo').val();
            	
            	if (fileGbn == "1") fileGbn = "biz";
            	if (fileGbn == "2") fileGbn = "bk";
            	if (fileGbn == "3") fileGbn = "etc";
            	if (fileGbn == "4") fileGbn = "ceo";
            	
            	param.fileGbn = fileGbn;

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                	jQuery("#" + fileGbn + "FileInert").html("");
                });
                return false;
            }

            
            //우편번호, 주소 값 입력
            function setZipcode(data) {
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                $('#postNo').val(data.zonecode); //5자리 새우편번호 사용
                if (data.jibunAddress || data.roadAddress) {
                    $('#addr').val(data.jibunAddress || data.roadAddress);
                }
                $('#addrDtl').val('').focus();
            }
            
            //반품 우편번호, 주소 값 입력
            function ret_setZipcode(data) {
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                $('#retadrssPostNo').val(data.zonecode); //5자리 새우편번호 사용
                if (data.jibunAddress || data.roadAddress) {
                    $('#retadrssAddr').val(data.jibunAddress || data.roadAddress);
                }
                $('#retadrssDtlAddr').val('').focus();
            }            
            
            //비밀번호 형식 체크
            function pwChk(pw){
                var num = pw.search(/[0-9]/g);
                var eng = pw.search(/[a-z]/ig);
                var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
                
                if (pw.indexOf(memberLoginId) > -1) {
                    Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "확인");
                    return false;
                }
                
                if(pw.length < 8 || pw.length > 16){
                    Dmall.LayerUtil.alert(" 비밀번호 형식이 잘못되었습니다. 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.");
                    return false;
                }
                
                if( (num < 0 && eng < 0) || (eng < 0 && spe < 0) || (spe < 0 && num < 0) ){
                    Dmall.LayerUtil.alert(" 비밀번호 형식이 잘못되었습니다. 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.");
                    return false;
                }
                
                var SamePass_0 = 0; //동일문자 카운트
                var SamePass_1 = 0; //연속성(+) 카운트
                var SamePass_2 = 0; //연속성(-) 카운트
                
                var chr_pass_0;
                var chr_pass_1;
                
                for(var i=0; i < pw.length; i++) {
                    chr_pass_0 = pw.charAt(i);
                    chr_pass_1 = pw.charAt(i+1);
                   
                    //동일문자 카운트
                    if(chr_pass_0 == chr_pass_1) {
                        SamePass_0 = SamePass_0 + 1
                    } 
                   
                    //연속성(+) 카운드
                    if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1) {
                        SamePass_1 = SamePass_1 + 1
                    } 
                   
                    //연속성(-) 카운드
                    if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1) {
                        SamePass_2 = SamePass_2 + 1
                    } 
                } 
                
                if(SamePass_0 > 1) {
                    Dmall.LayerUtil.alert("3자리 이상 반복되는 문구와 숫자는 불가합니다.");
                    return false;
                } 
                
                return true;
            }
            
            //전화번호 형식 체크 및 자동 하이픈 넣기
            function chk_tel(str, field){
                var str;
                str = checkDigit(str);
                len = str.length;
                
                if(len==8){
                    if(str.substring(0,2)==02){
                    }else{
                        field.value  = phone_format(1,str);
                    }   
                }else if(len==9){
                    if(str.substring(0,2)==02){
                        field.value = phone_format(2,str);
                    }else{
                        error_numbr(str, field);
                    }
                }else if(len==10){
                    if(str.substring(0,2)==02){
                        field.value = phone_format(2,str);
                    }else{
                        field.value = phone_format(3,str);
                    }
                }else if(len==11){
                    if(str.substring(0,2)==02){
                        error_numbr(str, field);
                    }else{
                        field.value  = phone_format(3,str);
                    }
                }
            }
            
            function checkDigit(num){
                var Digit = "1234567890";
                var string = num;
                var len = string.length;
                var retVal = "";
                for (i = 0; i < len; i++){
                    if (Digit.indexOf(string.substring(i, i+1)) >= 0){
                        retVal = retVal + string.substring(i, i+1);
                    }
                }
                return retVal;
            }
            
            function phone_format(type, num){
                if(type==1){
                    return num.replace(/([0-9]{4})([0-9]{4})/,"$1-$2");
                }else if(type==2){
                    return num.replace(/([0-9]{2})([0-9]+)([0-9]{4})/,"$1-$2-$3");
                }else{
                    return num.replace(/(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
                }
            }
            
            
            function checkValidation(){
            	
                if($("#inputGbn").val() != "UPDATE") {
                    if(Dmall.validation.isEmpty($("#loginId").val())) {
                        Dmall.LayerUtil.alert("판매자ID를 입력해주세요.", "알림");
                        return false;
                    }
                    
                    if(Dmall.validation.isEmpty($("#pw").val())) {
                        Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "알림");
                        return false;
                    }
                    
                	if (!$('#chkSellerId').val()) {
                        Dmall.LayerUtil.alert("판매자ID의 중복체크를 확인해주세요.", "알림");
                        return false;
                	}
                } 
                
                
                if(!Dmall.validation.isEmpty($("#pw").val())) {
                	
                    if( $('#pw').val() !=  $('#pwChk').val()){
                        Dmall.LayerUtil.alert("비밀번호 입력/확인이 일치하지 않습니다.", "알림");
                        return false;
                    }
                    if (jQuery('#pw').val().length<8 || jQuery('#pw').val().length>16){
                        Dmall.LayerUtil.alert("비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.", "확인");
                        return false;
                    }
                    if(/(\w)\1\1/.test($('#pw').val())){
                        Dmall.LayerUtil.alert("비밀번호에 동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.", "확인");
                        return false;
                    }
                    if ($('#pw').val().indexOf($('#loginId').val()) > -1) {
                        Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "확인");
                        return false;
                    }                	
                }
                
                if(Dmall.validation.isEmpty($("#sellerNm").val())) {
                    Dmall.LayerUtil.alert("업체명을 입력해주세요.", "알림");
                    return false;
                }
                
                if(Dmall.validation.isEmpty($("#bizRegNo").val())) {
                    Dmall.LayerUtil.alert("사업자등록번호를 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#ceoNm").val())) {
                    Dmall.LayerUtil.alert("대표자명을 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#dlgtTel").val())) {
                    Dmall.LayerUtil.alert("대표전화번호를 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#mobileNo").val())) {
                    Dmall.LayerUtil.alert("휴대폰번호를 입력해주세요.", "알림");
                    return false;
                }
                if(Dmall.validation.isEmpty($("#email01").val())) {
                    Dmall.LayerUtil.alert("이메일을 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#email02").val())) {
                    Dmall.LayerUtil.alert("이메일을 입력해주세요.", "알림");
                    return false;
                }
                /*if(Dmall.validation.isEmpty($("#bsnsCdts").val())) {
                    Dmall.LayerUtil.alert("업태를 입력해주세요.", "알림");
                    return false;
                }*/

                /*if(Dmall.validation.isEmpty($("#st").val())) {
                    Dmall.LayerUtil.alert("종목을 입력해주세요.", "알림");
                    return false;
                }*/
                
                if(Dmall.validation.isEmpty($("#postNo").val())) {
                    Dmall.LayerUtil.alert("우편번호를 입력해주세요.", "알림");
                    return false;
                }
            	
                if(Dmall.validation.isEmpty($("#addr").val())) {
                    Dmall.LayerUtil.alert("주소를 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#addrDtl").val())) {
                    Dmall.LayerUtil.alert("상세주소를 입력해주세요.", "알림");
                    return false;
                }
                
//                 if(Dmall.validation.isEmpty($("#managerNm").val())) {
//                     Dmall.LayerUtil.alert("담당자명을 입력해주세요.", "알림");
//                     return false;
//                 }
                
//                 if(Dmall.validation.isEmpty($("#managerTelno").val())) {
//                     Dmall.LayerUtil.alert("담당자 전화번호를 입력해주세요.", "알림");
//                     return false;
//                 }


                
                return true ;
            }
            
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">

        <div class="top_title noline">
            <div class="location">
                <a href="#" class="btn_go_prev">이전페이지</a> > <a href="#">홈</a> > <a href="#">입점하기</a>
            </div>
            <h2 class="sub_tit"><img src="${_SKIN_IMG_PATH}/bottom/top_tit_bottom02.gif" alt="생산자가 주인공이 되는 곳 제철농장 입점하기!"></h2>
        </div>
        <div class="sub_content">
            <c:set var="sellerDtl" value="${resultModel.data}" />
            <c:set var="inputGbn" value="${sellerSO.inputGbn}" />
            <form id="form_id_sellerDtl" method="post">
                <input type="hidden" name="email" id="email" value = "${sellerDtl.email}"/>
                <input type="hidden" name="managerEmail" id="managerEmail" value = "${sellerDtl.managerEmail}"/>
                <input type="hidden" name="chkSellerId" id="chkSellerId" value = ""/>
                <input type="hidden" name="inputGbn" id="inputGbn" value = "${sellerSO.inputGbn}"/>
                <input type="hidden" name="sellerNo" id="sellerNo" value="${sellerDtl.sellerNo}"/>
                <input type="hidden" name="statusCd" id="statusCd" value="01"/>
            <table class="tInsert shop">
                <caption>입점하기 기본정보 입력폼입니다.</caption>
                <colgroup>
                    <col style="width:137px">
                    <col style="">
                </colgroup>
                <tbody>
                <tr>
                    <th>
                        <label for="">아이디</label><em>*</em>
                    </th>
                    <td>
                        <input type="text" class="form_id" name="sellerId" id="loginId" value="${sellerDtl.sellerId}" data-validation-engine="validate[required, maxSize[20]]"><button type="button" class="btn_doubled_check" id="btn_id_check">중복확인</button>
                    </td>
                </tr>
                <tr>
                    <th>
                        <label for="">비밀번호</label><em>*</em>
                    </th>
                    <td><input type="password" id="pw" name="pw" placeholder="비밀번호입력"></td>
                </tr>
                <tr>
                    <th>
                        <label for="">비밀번호 확인</label><em>*</em>
                    </th>
                    <td><input type="password" id="pwChk" placeholder="비밀번호확인"></td>
                </tr>
                <tr>
                    <th>
                        <label for="">업체명</label><em>*</em>
                    </th>
                    <td><input type="text" name="sellerNm" id="sellerNm" value="${sellerDtl.sellerNm}" data-validation-engine="validate[required, maxSize[30]]" maxlength="30"></td>
                </tr>
                <tr>
                    <th>
                        <label for="">사업자등록번호</label><em>*</em>
                    </th>
                    <td>
                        <input type="text" name="bizRegNo" id="bizRegNo" maxlength="10" value="${sellerDtl.bizRegNo}" data-validation-engine="validate[required, maxSize[10]]">

                    </td>
                </tr>
                <tr>
                    <th>
                        <label for="">대표자명</label><em>*</em>
                    </th>
                    <td><input type="text" name="ceoNm" id="ceoNm" value="${sellerDtl.ceoNm}" ></td>
                </tr>
                <tr>
                    <th>
                        <label for="">대표전화</label><em>*</em>
                    </th>
                    <td><input type="text" name="dlgtTel" id="dlgtTel" value="${sellerDtl.dlgtTel}"></td>
                </tr>
                <tr>
                    <th>
                        <label for="">휴대폰번호</label><em>*</em>
                    </th>
                    <td><input type="text" name="mobileNo" id="mobileNo" value="${sellerDtl.mobileNo}"></td>
                </tr>
                <tr>
                    <th>
                        <label for="">이메일</label><em>*</em>
                    </th>
                    <td>
                        <input type="text" class="form_email" id="email01">
                        <span><img src="${_SKIN_IMG_PATH}/member/text_email.jpg" alt="@"></span>
                        <input type="text" class="form_email" id="email02" >
                        <select class="email" id="email03">
                            <option value="etc" selected="selected">직접입력</option>
                            <option value="naver.com">naver.com</option>
                            <option value="daum.net">daum.net</option>
                            <option value="hanmail.net">hanmail.net</option>
                            <option value="nate.com">nate.com</option>
                            <option value="hotmail.com">hotmail.com</option>
                            <option value="yahoo.com">yahoo.com</option>
                            <option value="empas.com">empas.com</option>
                            <option value="korea.com">korea.com</option>
                            <option value="dreamwiz.com">dreamwiz.com</option>
                            <option value="gmail.com">gmail.com</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>
                        <label for="">주소</label><em>*</em>
                    </th>
                    <td>
                        <input type="text" id="postNo" name="postNo" value="${sellerDtl.postNo}" data-validation-engine="validate[required]" class="form_email">
                        <button type="button" class="btn_doubled_check" id="a_id_post">주소검색</button>
                        <input type="text" id="addr" name="addr" value="${sellerDtl.addr}" data-validation-engine="validate[required]" class="marginT05">
                        <input type="text" id="addrDtl" name="addrDtl" value="${sellerDtl.addrDtl}" data-validation-engine="validate[required]" class="marginT05">
                    </td>
                </tr>
                </tbody>
            </table>

            <table class="tInsert shop">
                <caption>입점하기 추가정보 입력폼입니다.</caption>
                <colgroup>
                    <col style="width:137px">
                    <col style="width:300px">
                    <col style="width:90px">
                    <col style="width:">
                </colgroup>
                <tbody>
                <tr>
                    <th>
                        <label for="">홈페이지</label>
                    </th>
                    <td colspan="3"><input type="text" name="homepageUrl" id="hompageUrl" value="${sellerDtl.homepageUrl}"></td>
                </tr>
                <tr>
                    <th>
                        <label for="">담당자명</label>
                    </th>
                    <td><input type="text" name="managerNm" id="managerNm" value="${sellerDtl.managerNm}" data-validation-engine="validate[required, maxSize[15]]" class="form_staff"></td>
                    <th class="textC">
                        <label for="">직급</label>
                    </th>
                    <td><input type="text" id="managerPos" name="managerPos" value="${sellerDtl.managerPos}" class="form_email"></td>
                </tr>
                <tr>
                    <th>
                        <label for="">휴대폰번호</label>
                    </th>
                    <td colspan="3"><input type="text" id="managerMobileNo" name="managerMobileNo" value="${sellerDtl.managerMobileNo}"></td>
                </tr>
                <tr>
                    <th>
                        <label for="">이메일</label>
                    </th>
                    <td colspan="3">
                        <input type="text" id="managerEmail01" class="form_email">
                        <span><img src="${_SKIN_IMG_PATH}/member/text_email.jpg" alt="@"></span>
                        <input type="text" id="managerEmail02" class="form_email">
                        <select id="managerEmail03" class="email">
                            <option value="etc" selected="selected">직접입력</option>
                            <option value="naver.com">naver.com</option>
                            <option value="daum.net">daum.net</option>
                            <option value="hanmail.net">hanmail.net</option>
                            <option value="nate.com">nate.com</option>
                            <option value="hotmail.com">hotmail.com</option>
                            <option value="yahoo.com">yahoo.com</option>
                            <option value="empas.com">empas.com</option>
                            <option value="korea.com">korea.com</option>
                            <option value="dreamwiz.com">dreamwiz.com</option>
                            <option value="gmail.com">gmail.com</option>
                        </select>
                    </td>
                </tr>
                </tbody>
            </table>
            </form>
            <div class="btn_area">
                <button type="button" class="btn_shop_member" id="btn_save">고생하셨슴돠!</button>
            </div>
        </div>

        
<!--- popup 아이디 중복확인 --->
<div id="popup_id_duplicate_check" style="width:500px;display: none;">
	<div class="popup_header">
		<h1 class="popup_tit">아이디 중복확인</h1>
		<button type="button" class="btn_close_popup"><img src="/admin/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
	</div>
	<div class="popup_content">
		<div class="pw_search_info">
			아이디는 영문, 숫자 가능하며 5~20자 이내로 입력해주세요.
		</div>
		<ul class="id_duplicate_check">
			<li>
				<input type="text" id="id_check" maxlength="20">
				<button type="button" class="btn_id_duplicate_check">중복확인</button>
			</li>
		</ul>
		<div>
			 <div class="id_duplicate_check_info" ></div>
			 <div class="textC" id="id_success_div" style="display: none;">
				 <button type="button" class="btn_popup_login" style="margin-top:22px">사용하기</button>
			 </div>
		</div>
	</div>
</div>
<!---// popup 아이디 중복확인 --->
        
        
    </t:putAttribute>
</t:insertDefinition>
