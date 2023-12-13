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

<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">입점/제휴문의</t:putAttribute>
    <t:putAttribute name="script">
        <script src="${_MOBILE_PATH}/front/js/member.js" type="text/javascript" charset="utf-8"></script>
        <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
        <script>
            
            $(document).ready(function() {                
                
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
                
                //문의접수 등록
                $('.btn_go_site').on('click',function (){
                	
                	if (!checkValidation()) {
                		return false ;
                	}					
                	
                	$('#managerEmail').val($('#managerEmail01').val() + '@' + $('#managerEmail02').val());
                	$('#managerMobileNo').val($('#managerMobileNo1').val() + '-' + $('#managerMobileNo2').val() + '-' + $('#managerMobileNo3').val());
                	
                    var url = '${_MOBILE_PATH}/front/seller/seller-info-save',
                    param = jQuery('#form_id_sellerDtl').serialize();
                	
                    if (Dmall.FileUpload.checkFileSize('form_id_sellerDtl')) {
                        $('#form_id_sellerDtl').ajaxSubmit({
                            url : url,
                            dataType : 'json',
                            success : function(result){
                                Dmall.validate.viewExceptionMessage(result, 'form_id_sellerDtl');
                                if(result.success){
                                    Dmall.LayerUtil.alert(result.message).done(function(){
                                        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/main-view');
                                    })
                                }else{
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        });
                    }
                });
                
                
              //파일 변경
                jQuery(document).off('change',"input[type=file]");
                var num = 1;
                jQuery(document).on('change',"input[type=file]", function(e) {
                    var fileSize=0;
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
            		if($.inArray(ext, ['gif','png','jpg','pdf']) == -1) {
            			Dmall.LayerUtil.alert('gif,png,jpg,pdf 파일만 업로드 할수 있습니다.','','');
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

                    $( "#viewFileInsert" ).append( text );
                    num = num+1;
                    $( "#fileSetList" ).append(
                        "<span id=\"fileSpan"+num+"\" style=\"visibility: visible\">"+
                        "<label for=\"input_id_files"+num+"\">파일찾기</label>"+
                        "<input class=\"upload-hidden\" name=\"files"+num+"\" id=\"input_id_files"+num+"\" type=\"file\">"+
                        " </span>"
                    );
                });
                
                
            });
                      
            var totalFileLength=0;
            //파일 삭제
            function delNewFileNm(fileNo, fileSize){
                totalFileLength = totalFileLength-1;
                $("#_fileNm"+fileNo).remove();
                $("#input_id_files"+fileNo).remove();
                return false;
            }
            
          	//숫자
            function isNumber(v_num){
            	var expNum	= /^[0-9]+$/;	
            	if(!expNum.test(v_num)){
            		return false;
            	}else{
            		return true;
            	}
            }
            //숫자만 입력 가능 메소드
            function onlyNumDecimalInput(obj){
            	if(obj.value.length > 0){
            		if(isNumber(obj.value) == false){
            			alert("숫자를 입력하세요.");
            			obj.value = "";
            			obj.focus();
            		}
            	}
            }
            
			function checkValidation(){
                
                if(Dmall.validation.isEmpty($("#sellerNm").val())) {
                    Dmall.LayerUtil.alert("업체명을 입력해주세요.", "알림");
                    return false;
                }
                
                if(Dmall.validation.isEmpty($("#managerNm").val())) {
                    Dmall.LayerUtil.alert("담당자명을 입력해주세요.", "알림");
                    return false;
                }
                
                if(Dmall.validation.isEmpty($("#managerEmail01").val())) {
                    Dmall.LayerUtil.alert("이메일을 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#managerEmail02").val())) {
                    Dmall.LayerUtil.alert("이메일을 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#managerMobileNo1").val())) {
                    Dmall.LayerUtil.alert("휴대폰번호를 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#managerMobileNo2").val())) {
                    Dmall.LayerUtil.alert("휴대폰번호를 입력해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#managerMobileNo3").val())) {
                    Dmall.LayerUtil.alert("휴대폰번호를 입력해주세요.", "알림");
                    return false;
                }
                
                if(Dmall.validation.isEmpty($("#storeInquiryContent").val())) {
                    Dmall.LayerUtil.alert("문의내용을 입력해주세요.", "알림");
                    return false;
                }
                
                if($('#agree_check01').is(':checked') == false){
                	Dmall.LayerUtil.alert("개인정보수집에 동의해주세요.", "알림");
                	return false;
                }
                
                return true ;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">

         <!--- 02.LAYOUT: 카테고리 메인 --->
    <div class="category_middle">
		<div class="com_head">
			<h2 class="com_tit">입점/제휴문의</h2>
		</div>
		<div class="partnership_info_area">
			다비치마켓은 국내 최대 안경매장을 기반으로 한 O4O 쇼핑 플랫폼 기반의 종합 쇼핑몰 입니다.<br><br>
			<b>특징</b><br>
			  - 구매력이 강한 양질의 회원보유<br>
			  - 타사몰 대비 합리적이고 저렴한 수수료<br>
			  - 기존 회원이 보유한 포인트 & 쿠폰사용<br>
			  - 유사성이 매우 높은 연계상품 카테고리 구성으로 즉시구매율 증대<br>
			  - 고객관리 운영 노하우 (32년간)가 적용된 체계적인 고객관리 (빅데이터 보유) 시스템 <br><br>

			다비치마켓에 입점을 원하시는 분들은 아래 내용을 참고하신 후, 상담 요청을 각 항목에 맞게 작성 부탁드립니다.<br><br>
			<img src="${_SKIN_IMG_PATH}/company/seller_img.jpg">
		</div>
		<div class="partnership_insert">
		<form id="form_id_sellerDtl" method="post">
			<input type="hidden" name="inputGbn" id="inputGbn" value = "INSERT"/>
			<input type="hidden" name="managerEmail" id="managerEmail"/>
			<input type="hidden" name="managerMobileNo" id="managerMobileNo"/>
			<input type="hidden" name="statusCd" id="statusCd" value="01"/>
			<table class="tInsert">
				<caption>입점/제휴문의 정보입력 폼입니다.</caption>
				<colgroup>
					<col style="width:10%">
					<col style="">
				</colgroup>
				<tbody>
					<tr>
						<th>문의구분</th>
						<td>
							<code:radio name="storeInquiryGbCd" codeGrp="STORE_INQUIRY_GB_CD" idPrefix="storeInquiryGbCd" classNm="member_join"/>
						</td>
					</tr>
					<tr>
						<th>업체명</th>
						<td><input type="text" name="sellerNm" id="sellerNm" data-validation-engine="validate[required, maxSize[30]]" maxlength="30"></td>
					</tr>
					<tr>
						<th>담당자명</th>
						<td><input type="text" name="managerNm" id="managerNm" data-validation-engine="validate[required, maxSize[15]]"></td>
					</tr>
					<tr>
						<th>이메일</th>
						<td>
							<input type="text" id="managerEmail01" class="phone">
							<span class="bar">@</span>
							<input type="text" id="managerEmail02" class="phone">
							<select id="managerEmail03" class="phone">
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
						<th>휴대전화</th>
						<td>
							<select class="phone" id="managerMobileNo1" name="managerMobileNo1">
								<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
							</select>
							<span class="bar">-</span>
							<input type="text" id="managerMobileNo2" name="managerMobileNo2" class="phone" maxlength="4" onkeyup="onlyNumDecimalInput(this);">
							<span class="bar">-</span>
							<input type="text" id="managerMobileNo3" name="managerMobileNo3" class="phone" maxlength="4" onkeyup="onlyNumDecimalInput(this);">
						</td>
					</tr>
					<tr>
						<th class="vaT">문의내용</th>
						<td>
							<textarea class="form_partnership" id="storeInquiryContent" name="storeInquiryContent" placeholder="입점 및 문의  관련 내용을 남겨주세요."></textarea>
						</td>
					</tr>
					<tr>
						<th>참조파일</th>
						<td>
							<div class="filebox">
	                            <span id = "fileSetList">
	                                <span id="fileSpan1" style="visibility: visible">
	                                    <label for="input_id_files1">파일찾기</label>
	                                    <input class="upload-hidden" name="ref_file" id="input_id_files1" type="file">
	                                </span>
	                            </span>
	                            <br />
	                            <span id="viewFileInsert"></span>
	                        </div>
						</td>
					</tr>
					<tr>
						<th class="vaT">개인정보<br>수집동의</th>
						<td>
							<input type="checkbox" id="agree_check01" name="marketing" class="agree_check shop_join">
							<label for="agree_check01">
								<span></span>
								<p>수집하는 개인정보 항목, 수집/이용목적, 개인정보 보유기간에 동의합니다.</p>
							</label>
						</td>
					</tr>
					<tr>
						<td colspan="2">							
							<div class="agree_partnership_scroll">
<pre><em>[ 입점/제휴문의를 위한 개인정보수집 및 이용동의 ]</em>

다비치몰(이하 “회사”라 함)은 개인정보보호법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 관련 법령상의 개인정보보호 규정을 준수하며, 파트너의 개인정보 보호에 최선을 다하고 있습니다.

<b>1. 개인정보 수집 및 이용주체</b> 
입점/제휴문의를 통해 제공하신 정보는 “회사”가 직접 접수하고 관리합니다.

<b>2. 동의를 거부할 권리 및 동의 거부에 따른 불이익</b> 
신청자는 개인정보제공 등에 관해 동의하지 않을 권리가 있으며 이 경우 문의접수가 불가능합니다.

<b>3. 수집하는 개인정보 항목</b> 
필수항목: 담당자명, 담당자 이메일 주소, 담당자 휴대전화번호

<b>4. 수집 및 이용목적</b> 
입점 검토, 입점시스템의 운용, 공지사항의 전달 등

<b>5. 보유기간 및 이용기간</b>
수집된 정보는 입점/제휴문의 처리기간이 종료되는 시점까지 보관됩니다.
</pre>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_com_area">
			<button type="button" class="btn_go_site">문의접수</button>
		</div>	
	</div>
    <!---// 02.LAYOUT: 카테고리 메인 --->
        
        
    </t:putAttribute>
</t:insertDefinition>
