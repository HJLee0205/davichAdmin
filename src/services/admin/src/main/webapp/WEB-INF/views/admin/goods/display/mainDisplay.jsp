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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 상품 &gt; 메인상품 전시관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {

            	var idx = '${so.maxSiteDispSeq}';
            	var str = '${fn:length(resultModel.data.displayArr)}';
            	
            	if(str==0){
            		addSection();
            	}
            	
                if("${_DMALL_SITE_INFO.siteTypeCd}"=="1"){
                    jQuery("#mainAreaGbCd").toggleDesignEleReadonly();
                }                             
                $('.mainArea').on('change', function(e){
                	$('#mainAreaGbCd').val($('.mainArea').val());                	
                    var data = $('#form_id_detail').serializeArray();
                    var param = {};
                    $(data).each(function(index,obj){
                        param[obj.name] = obj.value;
                    });
                    Dmall.FormUtil.submit('/admin/goods/main-display', param);
                });

                // 섹션 추가버튼 클릭
                jQuery('#addSection').on('click', function(e) {
					addSection();
                });                
                //섹션추가
                function addSection(){

    				idx++;
    				str++;
    				
                	var html = '';
                	
                	html += '<input type="hidden" name="siteDispSeq'+idx+'" id="siteDispSeq'+idx+'" value="'+idx+'">';
                	html += '<h3 class="tlth3">메인페이지 상품진열';
                	html += '	<div class="right">';
                	html += ' 		<button class="btn_gray2" onclick="btnSave('+idx+', \'I\', '+str+');return false;">저장하기</button>';            
                	html += '	</div>';
                	html += '</h3>';
                	html += '<div class="tblw tblmany">';
                	html += '	<table summary="이표는 전시 메인페이지 상품진열표 입니다. 구성은 전시명, 사용유무, 전시타입, 전시상품 입니다.">';
                	html += '	<caption>메인페이지 상품진열 '+idx+'</caption>';
                	html += '	<colgroup>';
                	html += '		<col width="15%">';
                	html += '		<col width="85%">';
                	html += '	</colgroup>';
                	html += '	<tbody>';
                	html += '		<tr>';
                	html += '			<th>전시명</th>';
                	html += '			<td><span class="intxt wid100p"><input type="text" name="dispNm'+idx+'" id="dispNm'+idx+'" value=""></span></td>';
                	html += '		</tr>';
                	html += '		<tr>';
                	html += '			<th>전시명 꾸미기</th>';
                	html += '			<td>';
                	html += '				<label for="dispExhbtionTypeCd'+idx+'1" class="radio on">';
                	html += '				<span class="ico_comm"><input type="radio" name="dispExhbtionTypeCd'+idx+'" id="dispExhbtionTypeCd'+idx+'1" value="1" checked="checked"></span> 꾸미기 안함';
                	html += '				</label>';
                	html += '				<span class="br2"></span>';
                	html += '				<label for="dispExhbtionTypeCd'+idx+'2" class="radio">';
                	html += '				<span class="ico_comm"><input type="radio" name="dispExhbtionTypeCd'+idx+'" id="dispExhbtionTypeCd$'+idx+'2" value="2"></span> 이미지 <span class="size" id="defaultImgSize">(이미지 권장 사이즈 200*50)</span>';
                	html += '				</label>';
                	html += '				<span class="br2"></span>';
                	html += '				<div class="img_regist">';
               		html += '					<div class="img_con">';
               		html += '						<div class="item">';
               		html += '							<span class="img">';
               		html += '								<img src="/admin/img/product/tmp_img04.png" id="dispNmImgPath'+idx+'" width="82" height="82" alt="">';
               		html += '								<input type="hidden" name="dftFilePath'+idx+'" id="dftFilePath'+idx+'" />';
               		html += '								<input type="hidden" name="dftFileName'+idx+'" id="dftFileName'+idx+'" />';
               		html += '							</span>';
               		html += '						<div>';
               		html += '							<span class="btn"><button class="btn_blue defaultImg" id="${i}">이미지등록</button></span>';
               		html += '						</div>';
               		html += '					</div>';
               		html += '					<div class="item"></div>';
               		html += '				</div>';
               		html += '			</div>';
               		html += '		</td>';
               		html += '	</tr>';
               		html += '	<tr>';
               		html += '		<th>사용유무</th>';
               		html += '		<td>';
               		html += '			<label for="radio1'+idx+'_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn'+idx+'" id="radio1'+idx+'_1" value="Y"></span> 사용</label>';
               		html += '			<label for="radio1'+idx+'_2" class="radio on mr20"><span class="ico_comm"><input type="radio" name="useYn'+idx+'" id="radio1'+idx+'_2" value="N" checked="checked"></span> 미사용</label>';
               		html += '		</td>';
               		html += '	</tr>';
               		html += '	<tr>';
               		html += '		<th>전시타입</th>';
               		html += '		<td>';
               		html += '			<div class="gallery_lay">';
             		if(str == 1){
               		html += '				 <label for="radio0'+idx+'_1" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="01" id="radio0'+idx+'_1" checked="checked"></span><img src="/admin/img/product/gallery_01.png" class="img" alt=""> 몬드리안 슬라이드형 (6개)</label>';
               		html += '				 <label for="radio0'+idx+'_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="02" id="radio0'+idx+'_2"></span><img src="/admin/img/product/gallery_02.png" class="img" alt=""> 몬드리안 고정형(7개)</label>';
               		html += '				 <label for="radio0'+idx+'_3" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="03" id="radio0'+idx+'_3"></span><img src="/admin/img/product/gallery_04.png" class="img" alt=""> 이미지형</label>';
               		}else{
               			if('${resultModel.data.displayArr[0].dispTypeCd}' == '08'){
               				html += '				 <label for="radio0'+idx+'_1" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="08" id="radio0'+idx+'_1" checked="checked"></span><img src="/admin/img/product/gallery_01.png" class="img" alt=""> 몬드리안 슬라이드형 (6개)</label>';
                       		html += '				 <label for="radio0'+idx+'_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="09" id="radio0'+idx+'_2" disabled></span><img src="/admin/img/product/gallery_02.png" class="img" alt=""> 몬드리안 고정형(7개)</label>';
                       		html += '				 <label for="radio0'+idx+'_3" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="02" id="radio0'+idx+'_3" disabled></span><img src="/admin/img/product/gallery_04.png" class="img" alt=""> 이미지형</label>';
               			}else if('${resultModel.data.displayArr[0].dispTypeCd}' == '09'){
               				html += '				 <label for="radio0'+idx+'_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="08" id="radio0'+idx+'_1" disabled></span><img src="/admin/img/product/gallery_01.png" class="img" alt=""> 몬드리안 슬라이드형 (6개)</label>';
                       		html += '				 <label for="radio0'+idx+'_2" class="radio mr20  on"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="09" id="radio0'+idx+'_2"  checked="checked"></span><img src="/admin/img/product/gallery_02.png" class="img" alt=""> 몬드리안 고정형(7개)</label>';
                       		html += '				 <label for="radio0'+idx+'_3" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="02" id="radio0'+idx+'_3" disabled></span><img src="/admin/img/product/gallery_04.png" class="img" alt=""> 이미지형</label>';
               			}else if('${resultModel.data.displayArr[0].dispTypeCd}' == '02'){
               				html += '				 <label for="radio0'+idx+'_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="08" id="radio0'+idx+'_1" disabled></span><img src="/admin/img/product/gallery_01.png" class="img" alt=""> 몬드리안 슬라이드형 (6개)</label>';
                       		html += '				 <label for="radio0'+idx+'_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="09" id="radio0'+idx+'_2"  disabled></span><img src="/admin/img/product/gallery_02.png" class="img" alt=""> 몬드리안 고정형(7개)</label>';
                       		html += '				 <label for="radio0'+idx+'_3" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="dispTypeCd'+idx+'" value="02" id="radio0'+idx+'_3" checked="checked"></span><img src="/admin/img/product/gallery_04.png" class="img" alt=""> 이미지형</label>';
               			}
               			
               		}
               		html += '			</div>';
               		html += '		</td>';
               		html += '	</tr>';
               		html += '	<tr data-popup-no="'+idx+'">';
               		html += '		<th>전시상품</th>';
               		html += '		<td>';
               		html += '			 <a href="#none" class="btn_blue btn_goods_popup">상품검색</a>';
               		html += '			 <span class="br"></span>';
               		html += '			 <ul class="tbl_ul small" id="pop_goods_data'+idx+'">';
               		html += '			 </ul>';
               		html += '		</td>';
               		html += '	</tr>';
               		html += '</tbody>';
               		html += '</table>';
               		html += '</div>';
               		
                	$('#addedSection').append(html);
                }

               $(document).on('click','.btn_goods_popup',function(){
            	   var popupNo = jQuery(this).parents('tr').data('popup-no');
                   $('#goodsPopup').val(popupNo);
                   Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
                   GoodsSelectPopup._init( fn_callback_pop_goods );
		        });
               
               $(document).on('click','.defaultImg',function(e){
                       var imgSrc = '';
                       var idVal = this.id;
                       Dmall.EventUtil.stopAnchorAction(e);
                       Dmall.FileUpload.image()
                               .done(function (result) {


                                   var file = result.files[0] || null;
                                   if (file) {
                                       imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName
                                           $('#dispNmImgPath'+idVal).attr('src',imgSrc);
                                           $("#dftFilePath"+idVal).val(file.filePath);
                                           $("#dftFileName"+idVal).val(file.fileName);
                                           //$("#defaultImgSize").html('사이즈<br/>(' + file.fileWidth + 'X' + file.fileHeight + ')');
                                   }
                               })
                               .fail(function (result) {

                               });
                   });
               
             	  $(document).on('click','.btn_goods_popup',function(){   
             		 var popupNo = jQuery(this).parents('tr').data('popup-no');
                     $('#goodsPopup').val(popupNo);
                     Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
                     GoodsSelectPopup._init( fn_callback_pop_goods );
              	  });

                 $(document).on('click','.btnCancelControl',function(){   
                	 jQuery(this).parents('li').remove();
              	  });
     
                
            });

            
            // 상품 팝업 리턴 콜백함수
            function fn_callback_pop_goods(data) {
                var str = $('#goodsPopup').val();
                var numStr;
                $('input[name="goodsNo'+str+'"]').each(function(i){
                    numStr = $('input[name="goodsNo'+str+'"]').eq(i).val();
                    if(numStr == data["goodsNo"]){
                        Dmall.LayerUtil.alert(data["goodsNm"]+" <br/>이미 등록된 상품입니다.");
                        return false();
                    }
                });
                Dmall.LayerUtil.alert(data["goodsNm"]+" <br/>상품이 추가되었습니다.");
                var goodsData ="";
                //var goodsimg = "/admin/img/product/tmp_img04.png";
                // 차후 이미지정보에 맞게 처리해야함
                var goodsimg = data["goodsImg03"];
                if(goodsimg ==""){
                    goodsimg = "/admin/img/product/tmp_img04.png";
                }
                goodsData += "<li>";
                goodsData += "<button class='btn_comm cancel btnCancelControl'>삭제</button>";
                goodsData += "<span class='img'><img src='"+goodsimg+"' width='82' height='82' alt=''></span>";
                goodsData += "<span class='txt'>"+ data["goodsNm"] +" <br> "+ data["salePrice"].getCommaNumber() +"</span>";
                goodsData += "<input type='hidden' name='goodsNo"+str+"' value='"+ data["goodsNo"] +"'>";
                goodsData += "</li>";
                jQuery('#pop_goods_data'+str).append(goodsData);
                
            }
            
                   
            // 저장
            function btnSave(str, gb, idx){
            	
                $('#dispNm').val($('#dispNm'+str).val());
                $('#useYn').val($(':radio[name="useYn'+str+'"]:checked').val());
                $('#dispExhbtionTypeCd').val($(':radio[name="dispExhbtionTypeCd'+str+'"]:checked').val());
                $('#dftFilePath').val($('#dftFilePath'+str).val());
                $('#dftFileName').val($('#dftFileName'+str).val());
                // 상품진열이 5번째일경우 05로 무조건 처리하려고 함
                if(str =="5"){
                    $('#dispTypeCd').val("01");
                }else{
                    $('#dispTypeCd').val($(':radio[name="dispTypeCd'+str+'"]:checked').val());
                }
                $('#siteDispSeq').val($('#siteDispSeq'+str).val());
                $('#dispSeq').val(idx);
                var siteDispSeq = $('#siteDispSeq').val();
                //$('#goodsNo').val($('#goodsNo'+str).val());
                var numStr = ""; 
                $('input[name="goodsNo'+str+'"]').each(function(i){
                    numStr += $('input[name="goodsNo'+str+'"]').eq(i).val() +",";
                });
                $('#goodsNo').val(numStr);
                /*
                if(str > 1){
                    var str2 = str - 1;
                    if($('#siteDispSeq'+ str2).val() == ""){
                        Dmall.LayerUtil.alert('메인페이지 상품진열'+str2+' 먼저 등록하세요.');
                        return;
                    }
                }
                
                if($('#dispNm'+str).val() == "" && str != "5"){
                    Dmall.LayerUtil.alert('전시명을 입력하세요.');
                    return;
                }
                 
                if(numStr == ""){
                    Dmall.LayerUtil.alert('전시상품을 등록하세요.');
                    return;
                }
                */
                // 등록 수정 구분
                if(gb == "I"){
                    Dmall.LayerUtil.confirm('등록 하시겠습니까?', insertMainDisplay,'','메인 전시관리','등록');
                }else{
                    Dmall.LayerUtil.confirm('수정 하시겠습니까?', updateMainDisplay,'','메인 전시관리','수정');
                }  
                
            }
            
            function btnDel(str, gb, idx){
            	
            	if(str==1){
            		alert("첫번째 섹션은 삭제가 불가합니다.");
            		return false;
            	}else{
           			$('#siteDispSeq').val($('#siteDispSeq'+str).val());            	
            	  	Dmall.LayerUtil.confirm('삭제 하시겠습니까?', deleteMainDisplay,'','메인 전시관리','등록');
            	}
            }
            
            // 인서트
            function insertMainDisplay(){
                var url = '/admin/goods/main-display-insert',              
                param = jQuery('#form_id_detail').serialize();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail');
                    //location.replace("/admin/goods/main-display");
                    //document.location.href = '/admin/goods/main-display?mainAreaGbCd='+$('#mainAreaGbCd').val();
                });
            }

            // 수정
            function updateMainDisplay(){
                var url = '/admin/goods/main-display-update',
                param = jQuery('#form_id_detail').serialize();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail');
                    //location.replace("/admin/goods/main-display");
                    //document.location.href = '/admin/goods/main-display?mainAreaGbCd='+$('#mainAreaGbCd').val();
                });
            }
            
            // 삭제
            function deleteMainDisplay(){
                var url = '/admin/goods/main-display-delete',              
                param = jQuery('#form_id_detail').serialize();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail');
                    //location.replace("/admin/goods/main-display");
                    document.location.href = '/admin/goods/main-display?mainAreaGbCd='+$('#mainAreaGbCd').val();
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!-- content -->
        <div id="content">
            <div class="sec01_box">
                <div class="tlt_box">
                    <h2 class="tlth2">메인상품 전시관리</h2>
                </div>
                <div class="select_btn" style="padding-bottom: 10px;">
                      <span class="select">
                          <label for="select1"></label>
                          <select name="rows" id="mainArea" class="mainArea">
                             <code:option codeGrp="MAIN_AREA_GB_CD" />                            
                          	 <c:if test="${so.mainAreaGbCd == '01'}"><option selected="selected" value="${so.mainAreaGbCd}" style="display:none"><code:value grpCd="MAIN_AREA_GB_CD" cd="${so.mainAreaGbCd}"></code:value></c:if>
                          	 <c:if test="${so.mainAreaGbCd == '02'}"><option selected="selected" value="${so.mainAreaGbCd}" style="display:none"><code:value grpCd="MAIN_AREA_GB_CD" cd="${so.mainAreaGbCd}"></code:value></c:if>
                          	 <c:if test="${so.mainAreaGbCd == '03'}"><option selected="selected" value="${so.mainAreaGbCd}" style="display:none"><code:value grpCd="MAIN_AREA_GB_CD" cd="${so.mainAreaGbCd}"></code:value></c:if>
                          </select>                         
                      </span>
                      <button class="btn_gray2" id="addSection" onclick="return false;"> + 섹션추가</button>
                 </div>
                <!-- line_box -->
                <form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
                <input type="hidden" name="mainAreaGbCd" id="mainAreaGbCd" value="${so.mainAreaGbCd}">
                <input type="hidden" name="goodsPopup" id="goodsPopup" value="">
                <input type="hidden" name="siteDispSeq" id="siteDispSeq" value="">
                <input type="hidden" name="dispNm" id="dispNm" value="">
                <input type="hidden" name="useYn" id="useYn" value="">
                <input type="hidden" name="dispTypeCd" id="dispTypeCd" value="">
                <input type="hidden" name="goodsNo" id="goodsNo" value="">
                <input type="hidden" name="dispSeq" id="dispSeq" value="">
                <input type="hidden" name="dftFilePath" id="dftFilePath" />
                <input type="hidden" name="dftFileName" id="dftFileName" />
                <input type="hidden" name="dispExhbtionTypeCd" id="dispExhbtionTypeCd" />
                
                <div class="line_box fri">
                    <c:set var="listNum" value="0"></c:set>
                    <fmt:formatNumber value="${listNum}" type="number" var="listNumType"></fmt:formatNumber>
                    
                    <c:set var="startNum" value="1"></c:set>
                    <fmt:formatNumber value="${startNum}" type="number" var="startNumberType"></fmt:formatNumber>
                    <fmt:parseNumber value="${fn:length(resultModel.data.displayArr)}" pattern="000" var="num"/>
                    
                    <c:forEach var="displayList" items="${resultModel.data.displayArr}" varStatus="status">
                    <c:set var="listNum" value="${listNum + 1}"></c:set> 
                    <input type="hidden" name="siteDispSeq${listNum}" id="siteDispSeq${listNum}" value="${displayList.siteDispSeq}">
                    <h3 class="tlth3">
                        Section ${listNum}. <span style="font-size:13px; font-weight:400; color:#666;">(PC는  6개만, 모바일은 10개까지 노출. Section별 상품개수를 동일하게 설정해 주세요.)</span>
                        <div class="right">
                            <button class="btn_gray2" onclick="btnSave('${listNum}', 'U', '${displayList.dispSeq}');return false;">수정하기</button>
                            <button class="btn_gray2" onclick="btnDel('${listNum}', 'D', '${displayList.dispSeq}');return false;">삭제하기</button>
                        </div>
                    </h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 전시 메인페이지 상품진열표 입니다. 구성은 전시명, 사용유무, 전시타입, 전시상품 입니다.">
                            <caption>메인페이지 상품진열 ${listNum}</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <%-- <c:if test="${displayList.dispSeq != 5}"> --%>
                                <tr>
                                    <th>전시명</th>
                                    <td><span class="intxt wid100p"><input type="text" name="dispNm${listNum}" id="dispNm${listNum}" value="${displayList.dispNm}" maxlength="25"></span></td>
                                </tr>
                                <tr>
                                    <th>전시명 꾸미기</th>
                                    <td>
                                        <label for="dispExhbtionTypeCd${listNum}1" class="radio <c:if test="${displayList.dispExhbtionTypeCd eq '1'}">on</c:if>">
                                            <span class="ico_comm"><input type="radio" name="dispExhbtionTypeCd${listNum}" id="dispExhbtionTypeCd${listNum}1" value="1" <c:if test="${displayList.dispExhbtionTypeCd eq '1'}">checked="checked"</c:if>></span> 꾸미기 안함
                                        </label>
                                        <span class="br2"></span>
                                        <label for="dispExhbtionTypeCd${listNum}2" class="radio <c:if test="${displayList.dispExhbtionTypeCd eq '2'}">on</c:if>">
                                            <span class="ico_comm"><input type="radio" name="dispExhbtionTypeCd${listNum}" id="dispExhbtionTypeCd${listNum}2" value="2" <c:if test="${displayList.dispExhbtionTypeCd eq '2'}">checked="checked"</c:if>></span> 이미지 <span class="size" id="defaultImgSize">(이미지 권장 사이즈 200*50)</span>
                                        </label>
                                        <span class="br2"></span>
                                        <div class="img_regist">
                                            <div class="img_con">
                                                <div class="item">
                                                    <span class="img">
                                                    <c:set var="imgUrlInfo" value="/admin/img/product/tmp_img04.png"></c:set>
                                                    <c:if test="${displayList.dispImgPath != null && displayList.dispImgPath ne ''}">
                                                        <c:set var="imgUrlInfo" value="${_IMAGE_DOMAIN}/image/image-view?type=MAIN_DISPLAY&id1=${displayList.dispImgPath}_${displayList.dispImgNm}"></c:set>
                                                    </c:if>
                                                        <img src="${imgUrlInfo}" id="dispNmImgPath${listNum}" width="200" height="50" alt="">
                                                        <input type="hidden" name="dftFilePath${listNum}" id="dftFilePath${listNum}" />
                                                        <input type="hidden" name="dftFileName${listNum}" id="dftFileName${listNum}" />
                                                    </span>
                                                    <div>
                                                        <span class="btn"><button class="btn_blue defaultImg" id="${listNum}">이미지등록</button></span>
                                                        
                                                    </div>
                                                </div>
                                                <div class="item"></div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            <%-- </c:if> --%>
                                <tr>
                                    <th>사용유무</th>
                                    <td>
                                        <label for="radio1${listNum}_1" class="radio <c:if test="${displayList.useYn eq 'Y'}">on</c:if> mr20">
                                            <span class="ico_comm"><input type="radio" name="useYn${listNum}" id="radio1${listNum}_1" value="Y" <c:if test="${displayList.useYn eq 'Y'}">checked="checked"</c:if>></span> 사용
                                        </label>
                                        <label for="radio1${listNum}_2" class="radio <c:if test="${displayList.useYn eq 'N'}">on</c:if> mr20">
                                            <span class="ico_comm"><input type="radio" name="useYn${listNum}" id="radio1${listNum}_2" value="N" <c:if test="${displayList.useYn eq 'N'}">checked="checked"</c:if>></span> 미사용
                                        </label>
                                    </td>
                                </tr>
                            <c:if test="${displayList.dispSeq != 5}">
                                <tr>
                                    <th>전시타입</th>
                                    <td>
                                        <div class="gallery_lay">
                                            <label for="radio0${listNum}_1" class="radio mr20 <c:if test="${displayList.dispTypeCd eq '08'}">on</c:if>">
                                                <span class="ico_comm"><input type="radio" name="dispTypeCd${listNum}" value="08" id="radio0${listNum}_1" <c:if test="${displayList.dispTypeCd eq '08'}">checked="checked"></c:if><c:if test="${displayList.dispTypeCd ne '08'}"> disabled</c:if>></span>
                                                <img src="/admin/img/product/gallery_01.png" class="img" alt=""> 몬드리안 슬라이드형 (6개)
                                            </label>
                                            <label for="radio0${listNum}_2" class="radio mr20 <c:if test="${displayList.dispTypeCd eq '09'}">on</c:if>">
                                                <span class="ico_comm"><input type="radio" name="dispTypeCd${listNum}" value="09" id="radio0${listNum}_2" <c:if test="${displayList.dispTypeCd eq '09'}">checked="checked"></c:if><c:if test="${displayList.dispTypeCd ne '09'}"> disabled</c:if>></span>
                                                <img src="/admin/img/product/gallery_02.png" class="img" alt=""> 몬드리안 고정형 (7개)
                                            </label>
                                            <label for="radio0${listNum}_3" class="radio mr20 <c:if test="${displayList.dispTypeCd eq '02'}">on</c:if>">
                                                <span class="ico_comm"><input type="radio" name="dispTypeCd${listNum}" value="02" id="radio0${listNum}_3" <c:if test="${displayList.dispTypeCd eq '02'}">checked="checked"></c:if><c:if test="${displayList.dispTypeCd ne '02'}"> disabled</c:if>></span>
                                                <img src="/admin/img/product/gallery_04.png" class="img" alt=""> 이미지형
                                            </label>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                                <tr data-popup-no="${listNum}">
                                    <th>전시상품</th>
                                    <td>
                                        <a href="#none" class="btn_blue btn_goods_popup">상품검색</a>
                                        <span class="br"></span>
                                        <ul class="tbl_ul small" id="pop_goods_data${listNum}">
                                            <c:forEach var="displayListGoods" items="${resultModel.data.displayGoodsArr}" varStatus="status">
                                            <c:if test="${displayListGoods.siteDispSeq eq displayList.siteDispSeq}">
                                            <li>
                                                <button class="btn_comm cancel btnCancelControl">삭제</button>
                                                <!-- 차후 이미지정보에 맞게 처리해야함
                                                <span class="img"><img src="/admin/img/product/tmp_img04.png" width="82" height="82" alt=""></span>
                                                 -->
                                                <span class="img"><img src="${_IMAGE_DOMAIN}${displayListGoods.goodsImg03}" width="82" height="82" alt=""></span>
                                                <span class="txt">${displayListGoods.goodsNm} <br> <fmt:formatNumber value="${displayListGoods.salePrice}" pattern="#,###" />
                                                	<c:if test="${displayListGoods.dispYn eq 'N'}"><br> <span style="color:red;">미전시 상품</span></c:if>
                                                </span>
                                                <input type="hidden" name="goodsNo${listNum}" value="${displayListGoods.goodsNo}">
                                            </li>
                                            </c:if>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    </c:forEach>
                    
                   <%--  <c:forEach var="i" begin="${so.nextSiteDispSeq}" end="5" step="1" varStatus="x">  --%>
                   	<div id="addedSection">
                    <%-- <input type="text" name="siteDispSeq${i}" id="siteDispSeq${i}" value="">
                    <h3 class="tlth3">
                       	 메인페이지 상품진열 ${i}
                        <div class="right">
                            <button class="btn_gray2" onclick="btnSave('${i}');return false;">저장하기</button>
                        </div>
                    </h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 전시 메인페이지 상품진열표 입니다. 구성은 전시명, 사용유무, 전시타입, 전시상품 입니다.">
                            <caption>메인페이지 상품진열 ${i}</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <c:if test="${x.last == false}">
                                <tr>
                                    <th>전시명</th>
                                    <td><span class="intxt wid100p"><input type="text" name="dispNm${i}" id="dispNm${i}" value=""></span></td>
                                </tr>
                                <tr>
                                    <th>전시명 꾸미기</th>
                                    <td>
                                        <label for="dispExhbtionTypeCd${i}1" class="radio on">
                                            <span class="ico_comm"><input type="radio" name="dispExhbtionTypeCd${i}" id="dispExhbtionTypeCd${i}1" value="1" checked="checked"></span> 꾸미기 안함
                                        </label>
                                        <span class="br2"></span>
                                        <label for="dispExhbtionTypeCd${i}2" class="radio">
                                            <span class="ico_comm"><input type="radio" name="dispExhbtionTypeCd${i}" id="dispExhbtionTypeCd${i}2" value="2"></span> 이미지 <span class="size" id="defaultImgSize">(이미지 권장 사이즈 200*50)</span>
                                        </label>
                                        <span class="br2"></span>
                                        <div class="img_regist">
                                            <div class="img_con">
                                                <div class="item">
                                                    <span class="img">
                                                        <img src="/admin/img/product/tmp_img04.png" id="dispNmImgPath${i}" width="82" height="82" alt="">
                                                        <input type="hidden" name="dftFilePath${i}" id="dftFilePath${i}" />
                                                        <input type="hidden" name="dftFileName${i}" id="dftFileName${i}" />
                                                    </span>
                                                    <div>
                                                        <span class="btn"><button class="btn_blue defaultImg" id="${i}">이미지등록</button></span>
                                                    </div>
                                                </div>
                                                <div class="item"></div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                                <tr>
                                    <th>사용유무</th>
                                    <td>
                                        <label for="radio1${i}_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn${i}" id="radio1${i}_1" value="Y"></span> 사용</label>
                                        <label for="radio1${i}_2" class="radio on mr20"><span class="ico_comm"><input type="radio" name="useYn${i}" id="radio1${i}_2" value="N" checked="checked"></span> 미사용</label>
                                    </td>
                                </tr>
                            <c:if test="${x.last == false}">
                                <tr>
                                    <th>전시타입</th>
                                    <td>
                                        <div class="gallery_lay">
                                            <label for="radio0${i}_1" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="dispTypeCd${i}" value="03" id="radio0${i}_1" checked="checked"></span><img src="/admin/img/product/gallery_01.png" class="img" alt=""> 큰이미지형</label>
                                            <label for="radio0${i}_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd${i}" value="01" id="radio0${i}_2"></span><img src="/admin/img/product/gallery_02.png" class="img" alt=""> 이미지형</label>
                                            <label for="radio0${i}_3" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd${i}" value="05" id="radio0${i}_3"></span><img src="/admin/img/product/gallery_04.png" class="img" alt=""> 갤러리형</label>
                                            <label for="radio0${i}_4" class="radio mr20"><span class="ico_comm"><input type="radio" name="dispTypeCd${i}" value="04" id="radio0${i}_4"></span><img src="/admin/img/product/gallery_05.png" class="img" alt=""> 슬라이드형</label>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                                <tr data-popup-no="${i}">
                                    <th>전시상품</th>
                                    <td>
                                        <a href="#none" class="btn_blue btn_goods_popup">상품검색</a>
                                        <span class="br"></span>
                                        <ul class="tbl_ul small" id="pop_goods_data${i}">
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div> --%>
                    <!-- //tblw -->
                    <%-- </c:forEach> --%>
                    </div>
                </div>
                </form>
                <!-- //line_box -->
            </div>
        </div>
        <!-- //content -->
    <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
    </t:putAttribute>
</t:insertDefinition>
