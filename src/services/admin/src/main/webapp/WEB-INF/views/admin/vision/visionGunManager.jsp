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
<t:insertDefinition name="defaultLayout">
<t:putAttribute name="title">홈 &gt; 비전체크관리 &gt; ${ctgVO.goodsTypeCdNm} 군 관리</t:putAttribute>
	<t:putAttribute name="script">
    	<script type="text/javascript" src="/admin/js/lib/jquery/jquery.qrcode.min.js"></script>
    	<script>
        var totalFileLength=0;
        
     	jQuery(document).ready(function() {
     		getGunList();
     	});
     	
    	//군 정보 수정
        $("#updateCtgBtn").on('click', function(e) {
       	 	 var v_gunNo = $("#gunNo").val();
             
             if(v_gunNo == "" || v_gunNo == "0"){
            	 Dmall.LayerUtil.alert("군을 선택하세요.","확인");
             }else{
            	 var url = "/admin/vision/vision-check-gun-update";
            	 var param = jQuery('#formGunInsert').serialize();
            	 if (Dmall.FileUpload.checkFileSize('formGunInsert')) {
                     $('#formGunInsert').ajaxSubmit({
                          url : url,
                          dataType : 'json',
                          success : function(result){
                              Dmall.validate.viewExceptionMessage(result, 'formGunInsert');
                              Dmall.LayerUtil.alert(result.message);         
                              
                              getGunInfo(v_gunNo);
                          }
                     });
                  } 
             }
        });
    	
     	// 군 등록 레이어 실행
        $('#ctgInsBtn').on('click', function (e) {
			Dmall.LayerPopupUtilNew.open($('#layer_upload_gun'));
			$('#new_gun_nm').focus();
        });
     	
     	// 군 등록 레이어 닫기       
        jQuery('#btn_cancel').on('click', function(e) {
            $('#new_gun_nm').val('');
            Dmall.LayerPopupUtil.close('layer_upload_gun');
        });     	
        jQuery('#btn_close_layer').on('click', function(e) {
            $('#new_gun_nm').val('');
            Dmall.LayerPopupUtil.close('layer_upload_gun');
        });
    	
     	// 군 등록
        jQuery('#btn_regist_gun').on('click', function(e) {
            var v_goodsTypeCd = $("#goodsTypeCd").val();
            var v_gunNm = $("#new_gun_nm").val();
            
            $.ajax({
    	 		type : "POST",
    	 		url : "/admin/vision/vision-check-gun-insert",
    	 		data : {
    	 			goodsTypeCd : v_goodsTypeCd,
    	 			gunNm : v_gunNm
    	 		},
    	 		dataType : "xml",
    	 		success : function(result) {	
    	 			
    	 		},
    	 		error : function(result, status, err) {
    	 			//alert(result.status + " / " + status + " / " + err);
    	 		},
    	 		beforeSend: function() {
    	 		    
    	 		},
    	 		complete: function(){				
    	 			getGunList();
    	 		}
    	 	});	
            
            $('#new_gun_nm').val('');
            Dmall.LayerPopupUtil.close('layer_upload_gun');
        });
        
     	// 군 삭제 실행
        $('#delCtgBtn').on('click', function (e) {
        	alert("삭제 준비중.");
        });
     	
        var getGunList = function(){
        	var v_goodsTypeCd = $("#goodsTypeCd").val();
     		var append_str = "";
     		$.ajax({
     			type : "POST",
     			url : "/admin/vision/vision-check-gun-list",    	
     			data : {
     				goodsTypeCd 		: v_goodsTypeCd
     			},
     			dataType : "xml",
     			success : function(result) {
     				$('#gun_list').find("li").remove();
     				$("row",result).each(function(){
     					append_str = "<li style='height:25px;'>&gt; <a href=\"#none\" onclick=\"getGunInfo("+$("gun_no",this).text()+")\">";     					
     					if($("is_use",this).text() != "Y") append_str += "<strike>";
     					append_str += $("gun_nm",this).text();
     					if($("is_use",this).text() != "Y") append_str += "</strike>";
     					append_str += "</a></li>";
     					$('#gun_list').append(append_str);
     				});     				
     			},
     			error : function(result, status, err) {
     				alert(result.status + " / " + status + " / " + err);
     			},
     			beforeSend: function() {
     			    
     			},
     			complete: function(){
     			}
     		});
     	}
        
        function getGunInfo(v_gunNo){
        	totalFileLength=0;
        	$("#fileBoxNm").val("파일 찾기");
        	$("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
        	$("#input_id_image").val("");
        	$('input[id^=input_id_files]').each(function(index){
        		var idx = index+1;
        		$("#input_id_files"+idx).replaceWith($("#input_id_files"+idx).clone(true));
        		$("#input_id_files"+idx).val("");
        	});
        	$("#imgYn").val("N");
        	
        	var v_goodsTypeCd = $("#goodsTypeCd").val();
        	$.ajax({
     			type : "POST",
     			url : "/admin/vision/vision-check-gun-info",    	
     			data : {
     				gunNo : v_gunNo,
     				goodsTypeCd : v_goodsTypeCd
     			},
     			dataType : "json",
     			success : function(result) {
     				var data = result.data;
     				
     				$("#gunNo").val(data.gunNo);     				
     				$("#gunNm").val(data.gunNm);
     				$("#priceRange").val(data.priceRange);
     				$("#simpleDscrt").val(data.simpleDscrt);     
     				$('input:radio[name="isUse"]:input[value=' + data.isUse + ']').prop("checked", true);
     				
     				var atchFileArr = "";
                    var imgFile = "";
                    
                    jQuery("#imgFileInert").html("");
                    $("#imgOldYn").val("N");
                    jQuery("#viewFileInsert").html("");
                    
     				for(var i=0;i<(data.atchFileArr).length;i++){
     					var atchFile = data.atchFileArr[i];
     					
     					if(atchFile.imgYn == 'Y') {
     						imgFile = '<span id="'+atchFile.fileNo+'"><span>'+atchFile.orgFileNm+'</span>'+
                            '<button class="btn_del btn_comm" onclick= "return delOldImgFileNm('+atchFile.fileNo+')" ></button>'+
                            '<br><img src="${_IMAGE_DOMAIN}/image/image-view?type=VISION&path=' + atchFile.filePath + '&id1=' + atchFile.fileNm + '"></span>';
                            jQuery("#imgFileInert").html(imgFile);
                            $("#imgOldYn").val("Y");
     					}else{
     						atchFileArr += '<li class="txt_del" id="'+atchFile.fileNo+'">'+atchFile.orgFileNm+
                            '    <button class="btn_del btn_comm" onclick= "return delOldFileNm('+atchFile.fileNo+')" ></button>' +
                            '<br><img src="${_IMAGE_DOMAIN}/image/image-view?type=VISION&path=' + atchFile.filePath + '&id1=' + atchFile.fileNm + '"></li>';
                            totalFileLength = totalFileLength+1;
     					}
     				}

                    jQuery("#viewFileInsert").html(atchFileArr);
     			},
     			error : function(result, status, err) {
     				alert(result.status + " / " + status + " / " + err);
     			},
     			beforeSend: function() {
     			    
     			},
     			complete: function(){
     			}
     		});
        }
        
        var num = 1;
        jQuery(document).on('change',"input[type=file]", function(e) {
            var bbsId = "${so.bbsId}";
            if(jQuery(this).attr('id') == "input_id_image"){
                return;
            }
            var ext = jQuery(this).val().split('.').pop().toLowerCase();
            if(bbsId=="data"){
                if($.inArray(ext, ['pptx','ppt','xls','xlsx','doc','docx','hwp','pdf','gif','png','jpg']) == -1) {
                    Dmall.LayerUtil.alert('pptx,ppt,xls,xlsx,doc,docx,hwp,pdf,gif,png,jpg 파일만 업로드 할수 있습니다.','','');
                    $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                    $("#input_id_files"+num).val("");
                    return;
                }
            } else {
                if($.inArray(ext, ['gif','png','jpg']) == -1) {
                    Dmall.LayerUtil.alert('gif,png,jpg 파일만 업로드 할수 있습니다.','','');
                    $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                    $("#input_id_files"+num).val("");
                    return;
                }
            }
            
            totalFileLength = totalFileLength+1;
            var fileNm = e.target.value.substring(e.target.value.lastIndexOf('\\') + 1);
            
            if(totalFileLength>5){
                Dmall.LayerUtil.alert('첨부파일는 최대 5개까지 등록 가능합니다.');
                totalFileLength = totalFileLength-1;
                $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                $("#files"+num).val("");
                return;
            }
            
            document.getElementById("fileSpan"+num).style.display = "none";
            var text = '<li class="txt_del" id="'+num+'">'+fileNm+
            '    <button class="btn_del btn_comm" onclick= "return delNewFileNm('+num+')" ></button></li>';
            $( "#viewFileInsert" ).append( text );
            
            num = num+1;
            $( "#fileSetList" ).append( 
                    "<span id=\"fileSpan"+num+"\"   style=\"visibility: visible\">"+
                    "<label class=\"filebtn\" for=\"input_id_files"+num+"\">이미지찾기</label>"+
                    "<input class=\"filebox\" name=\"files"+num+"\" type=\"file\" id=\"input_id_files"+num+"\" accept=\"image/*\">"+
                    " </span>"
            );
        });
        
        jQuery('#input_id_image').on('change', function(e) {
        	if($("#imgOldYn").val()=="Y"){
                $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                $("#input_id_image").val("");
                $("#fileBoxNm").val("파일 찾기");
                Dmall.LayerUtil.alert("등록된 이미지 파일을 먼저 삭제하여 주세요.");
                return;
             }else{
                $("#imgYn").val("Y");
             }

             var ext = jQuery(this).val().split('.').pop().toLowerCase();
             if($.inArray(ext, ['gif','png','jpg']) == -1) {
                 Dmall.LayerUtil.alert('gif,png,jpg 파일만 업로드 할수 있습니다.');
                 $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                 $("#input_id_image").val("");
                 $("#fileBoxsNm").val("파일 찾기");
                 return;
             }
        });        

        function delNewFileNm(fileNo){
            totalFileLength = totalFileLength-1;
            $("#"+fileNo).remove();
            $("#input_id_files"+fileNo).remove();
            return false;
        }

        function delOldImgFileNm(fileNo){
            var url = '/admin/vision/attach-file-delete';
            var param = {fileNo:fileNo,bbsId:"${so.bbsId}"};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                $("#"+fileNo).remove();
                $("#imgOldYn").val("");
            });
            return false;
        }
        
        function delOldFileNm(fileNo){
            totalFileLength = totalFileLength-1;
            var url = '/admin/vision/attach-file-delete';
            var param = {fileNo:fileNo,bbsId:"${so.bbsId}"};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                $("#"+fileNo).remove();
            });

            return false;
        }
    	</script>
    </t:putAttribute>
     <t:putAttribute name="content">
		<div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">${ctgVO.goodsTypeCdNm} 군 관리 </h2>
            </div>
            <form action="" id="formGunInsert" method="post">
            <input type="hidden" name="goodsTypeCd" id="goodsTypeCd" value="${ctgVO.goodsTypeCd}">
            <input type="hidden" name="gunNo" id="gunNo" value="">
     		<!-- line_box -->
            <div class="line_box fri">
            	 <!-- cate_con -->
                <div class="cate_con">
                	<!-- cate_left -->
                    <div class="cate_left" >
                    	<a href="#categoryInsLayer" class="popup_open btn_gray2" id="ctgInsBtn" >+ 군 등록</a>
                       <!--  <a href="#" class="btn_gray" id="delCtgBtn">삭제</a> -->
                        <span class="br2"></span>
                    	<div class="left_con">	
                    		<div style="padding: 5px 5px;">
								<ul id="gun_list"></ul>					
							</div>		
	                	</div>
                    </div>
                    <!-- //cate_left -->
                    <!-- cate_right -->
                    <div class="cate_right">                    	
                    	<h3 class="tlth3">선택 군 관리</h3>
                    	<!-- tblw -->
                        <div class="tblw tblmany" style="margin-bottom:0px;">
                    		<table summary="군 등록">
                                <caption>선택 군 관리</caption>
                                <colgroup>
                                    <col width="20%">
                                    <col width="80%">
                                </colgroup>
                                <tbody>
                                    <tr>    
                                        <th>군 명</th>
                                        <td><span class="intxt wid100p"><input type="text" id="gunNm" name="gunNm" maxlength="20" ></span></td>
                                    </tr>
                                    <tr>    
                                        <th>가격대</th>
                                        <td><span class="intxt wid100p"><input type="text" id="priceRange" name="priceRange" maxlength="50" ></span></td>
                                    </tr>
                                    <tr>    
                                        <th>간단설명</th>
                                        <td><span class="intxt wid100p"><textarea id="simpleDscrt" name="simpleDscrt" style="width:95%; height:60px;" maxlength="200"></textarea></span></td>
                                    </tr>
                                    <tr>    
                                        <th>사용유무</th>
                                        <td>
                                        	<input type="radio" id="isUseY" name="isUse" value="Y"><label for="isUseY">사용</label> 
                                        	<input type="radio" id="isUseN" name="isUse" value="N"><label for="isUseN">미사용</label>
                                        </td>
                                    </tr>
                                    <tr>    
                                        <th>대표이미지</th>
                                        <td>		                                    
		                                     <span class="intxt"><input class="upload-name" id="fileBoxNm" type="text" value="파일 찾기" disabled="disabled"></span>
			                                 <label class="filebtn" id = "filebtn" for="input_id_image">이미지찾기</label>
			                                 <input class="filebox" name="imageFile" type="file" id="input_id_image" accept="image/*">
			                                 <input type="hidden" id="imgYn" name= "imgYn" >			                                 
                                        	 <input type="hidden" id="imgOldYn" name= "imgOldYn" ><span class="select_desc tbl_desc">
			                                        * 이미지 파일은 최대 2Mbyte입니다. <span style="color:#ff0000">( Size : 152 * 120 px )</span>
			                                 </span>
			                                 <div style="padding-top:10px;"><span id="imgFileInert"></span></div>
			                                 
                                        </td>
                                    </tr>
                                    <tr>    
                                        <th>설명이미지</th>
                                        <td>                                        	                                    
		                                    <span class="intxt"><input class="upload-name" id="fileBoxsNm" type="text" value="파일 찾기" disabled="disabled"></span>
		                                    <span id = "fileSetList">
		                                    <span id="fileSpan1" style="visibility: visible">
		                                    <label class="filebtn" for="input_id_files1">이미지찾기</label>
		                                    <input class="filebox" name="files1" type="file" id="input_id_files1" name= "input_id_files" accept="image/*">
		                                    </span>
		                                    </span>
		                                    <span class="select_desc tbl_desc">
		                                           * 첨부 파일은 최대 2Mbyte, 최대 5개 입니다. <span style="color:#ff0000">( Size : 600 * 600 px )</span>
		                                    </span>
		                                    <span class="br2"></span>
		                                    <!-- <div class="disposal_log"> -->
		                                        <ul id = "viewFileInsert">
		                                        
		                                        </ul>
		                                    <!-- </div> -->
                                        </td>
                                    </tr>
                                </tbody>
                             </table>                        
                        </div>
                        <!-- //tblw -->                                                  
	                    <div class="btn_box txtc">
	                       <a href="javascript:;" class="btn green" id="updateCtgBtn">적용하기</a>
	                    </div>
                    </div>
                    <!-- //cate_right -->
                </div>
                <!-- //cate_con -->
            </div>
            <!-- //line_box -->
            </form>
		</div>
		
		<!--- popup 군 등록 --->
		<div id="layer_upload_gun" class="slayer_popup">
			<div class="pop_wrap size1">
				<div class="pop_tlt">
					<h2 class="tlth2">${ctgVO.goodsTypeCdNm} 군 등록</h1>
					<button type="button" id="btn_close_layer" class="close ico_comm">닫기</button>
				</div>
				<div class="pop_con">
					<div class="tblw tblmany2 mt0">
						<input type="text" id="new_gun_nm" maxlength="20" style="width:95%">
					</div>
	                <div class="btn_box txtc">
	                    <button class="btn_green" id="btn_regist_gun">등록</button>
	                    <button class="btn_red" id="btn_cancel">취소</button>
	                </div>
				</div>
			</div>
		</div>
		<!---// popup 군 등록 --->
		
		<!-- layout1s -->
		<div id="layer_upload_image" class="slayer_popup">
		    <div class="pop_wrap size1">
		        <!-- pop_tlt -->
		        <div class="pop_tlt">
		            <h2 class="tlth2">상품 이미지 등록</h2>
		            <button id="btn_close_layer_upload_image" class="close ico_comm">닫기</button>
		        </div>
		        <!-- //pop_tlt -->
		        <!-- pop_con -->
		        <div class="pop_con">
		            <div>
		                <form action="/admin/common/file-upload" name="imageUploadForm" id="form_id_imageUploadForm" method="post" >
		                    <p class="message txtl">이미지 사이즈 설정 값을 기준으로 노출 위치별 필요한 사이즈로 자동 등록됩니다</p>
		                    <span class="br"></span>
		                    <span class="intxt imgup1"><input id="file_route1" class="upload-name" type="text" value="이미지선택" disabled="disabled"></span>
		                    <label class="filebtn" for="input_id_image">파일찾기</label>
		                    <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
		                    <span class="br2"></span>
		                    <span class="imgup2">
		                        <input type="hidden" id="hd_img_param_1" name="img_param_1" />
		                        <input type="hidden" id="hd_img_param_2" name="img_param_2" />
		                        <input type="hidden" id="hd_img_detail_width" name="img_detail_width" />
		                        <input type="hidden" id="hd_img_detail_height" name="img_detail_height" />
		                        <input type="hidden" id="hd_img_thumb_width" name="img_thumb_width" />
		                        <input type="hidden" id="hd_img_thumb_height" name="img_thumb_height" />
		                        <input type="hidden" id="hd_img_width_disp_type_a" name="img_width_disp_a" />
		                        <input type="hidden" id="hd_img_height_disp_type_a" name="img_height_disp_a" />
		                        <input type="hidden" id="hd_img_width_disp_type_b" name="img_width_disp_b" />
		                        <input type="hidden" id="hd_img_height_disp_type_b" name="img_height_disp_b" />
		                        <input type="hidden" id="hd_img_width_disp_type_c" name="img_width_disp_c" />
		                        <input type="hidden" id="hd_img_height_disp_type_c" name="img_height_disp_c" />                                                
		                        <input type="hidden" id="hd_img_width_disp_type_d" name="img_width_disp_d" />
		                        <input type="hidden" id="hd_img_height_disp_type_d" name="img_height_disp_d" />
		                        <input type="hidden" id="hd_img_width_disp_type_e" name="img_width_disp_e" />
		                        <input type="hidden" id="hd_img_height_disp_type_e" name="img_height_disp_e" />
		                        <input type="hidden" id="hd_img_width_disp_type_f" name="img_width_disp_f" />
		                        <input type="hidden" id="hd_img_height_disp_type_f" name="img_height_disp_f" />
		                        <input type="hidden" id="hd_img_width_disp_type_g" name="img_width_disp_g" />
		                        <input type="hidden" id="hd_img_height_disp_type_g" name="img_height_disp_g" />
		                        <input type="hidden" id="hd_img_width_disp_type_s" name="img_width_disp_s" />
		                        <input type="hidden" id="hd_img_height_disp_type_s" name="img_height_disp_s" />
		                    </span>
		                    <div class="btn_box txtc">
		                        <button class="btn_green" id="btn_regist_image">등록</button>
		                        <button class="btn_red" id="btn_cancel">취소</button>
		                    </div>
		                </form>
		                
		            </div>
		        </div>
		        <!-- //pop_con -->
		    </div>
		</div>
	</t:putAttribute>
</t:insertDefinition>