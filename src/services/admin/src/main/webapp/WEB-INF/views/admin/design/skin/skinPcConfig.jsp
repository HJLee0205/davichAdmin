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
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; 스킨 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            jQuery(document).ready(function() {
                
                // 선택한 스킨을 실제 적용 스킨으로 설정
                jQuery('#btn_id_applySkin').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var chkRadioVal = $("input:radio[name='chkRadio']:checked").val();
                    if(chkRadioVal == undefined || chkRadioVal == '') {
                        Dmall.LayerUtil.alert('선택된 스킨이 없습니다.');
                        return;
                    }
                    $("#skinNo").val(chkRadioVal);
                    Dmall.LayerUtil.confirm('선택한 스킨을 실제적용 스킨으로 설정하시겠습니까?', realSkinUpdate,'','스킨관리','설정변경');
                });
                
                // 선택한 스킨을 실제 적용 스킨으로 설정
                jQuery('#btn_id_workSkin').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var chkRadioVal = $("input:radio[name='chkRadio']:checked").val();
                    if(chkRadioVal == undefined || chkRadioVal == '') {
                        Dmall.LayerUtil.alert('선택된 스킨이 없습니다.');
                        return;
                    }
                    $("#skinNo").val(chkRadioVal);
                    Dmall.LayerUtil.confirm('선택한 스킨을 작업용 스킨으로 설정하시겠습니까?', workSkinUpdate,'','스킨관리','설정변경');
                });
                
                // zip 파일 업로드 - 레이어 열기
                jQuery('#btn_id_zipUpload').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $("#ex_file1").val("");
                    $("#file_route1").val("");
                    
                    Dmall.LayerPopupUtil.open(jQuery('#layout1s'));
                });

                // zip 파일 업로드 - 레이어 닫기
                jQuery('#btn_close_zipUpload2').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('layout1s');
                });

                // zip 파일 업로드 - 레이어 닫기
                jQuery('#btn_close_zipUpload').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.close('layout1s');
                });
                
                // 이미지 파일 업로드 - 이미지 등록
                jQuery('#btn_save_zipUpload').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    // 처리중 표시 처리
                    Dmall.LayerPopupUtil.close('layout1s');
                    Dmall.LayerPopupUtil.open(jQuery('#confirmLayout1s'));
                    
                    var url = '/admin/design/zip-upload',
                    param = jQuery('#form_id_detail').serialize();
                    
                    var ex_file1 = $("#ex_file1").val();
                    var fileExt = ex_file1.substring(ex_file1.lastIndexOf('.')+1); //파일의 확장자를 구합니다.
                    
                    if(ex_file1 == ""){
                        //Dmall.LayerPopupUtil.close('layout1s');
                        Dmall.LayerPopupUtil.close('confirmLayout1s');
                        Dmall.LayerUtil.alert("업로드할 압축파일을 선택하세요.");
                        return;
                    }
                    
                    if (fileExt.toUpperCase() != "ZIP"){
                        //Dmall.LayerPopupUtil.close('layout1s');
                        Dmall.LayerPopupUtil.close('confirmLayout1s');
                        Dmall.LayerUtil.alert("ZIP 압축 파일만 업로드 하실 수 있습니다.");
                        return false;
                    } 
                    
                    $('#form_id_detail').ajaxSubmit({
                        url : url,
                        dataType : 'json',
                        success : function(result){
                            if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                                //Dmall.LayerPopupUtil.close('layout1s');
                                Dmall.LayerPopupUtil.close('confirmLayout1s');
                                Dmall.LayerUtil.alert(result.message);
                            } else {
                                //Dmall.LayerPopupUtil.close('layout1s');
                                Dmall.LayerPopupUtil.close('confirmLayout1s');
                                Dmall.LayerUtil.alert(result.message);
                                if($("#pcGbCd").val() == "M"){
                                    location.replace("/admin/design/mobile-skin");
                                }else{
                                    location.replace("/admin/design/pc-skin");
                                }
                                //var filePath = $("#filePath").val();
                                //var searchNm = $("#searchNm").val();
                                //viewDtl(filePath,searchNm);
                            }
                        }
                    });
                    
                });
                
                
            });
            
            // 스킨을 실제적용 스킨 처리
            function realSkinUpdate() {
                var chkUrl = "/admin/design/real-skin-update";
                if($("#pcGbCd").val() == "M"){
                    chkUrl = "/admin/design/realmobile-skin-update";
                }
                
                var url = chkUrl,
                param = jQuery('#form_id_detail').serialize();
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail');
                    if($("#pcGbCd").val() == "M"){
                        location.replace("/admin/design/mobile-skin");
                    }else{
                        location.replace("/admin/design/pc-skin");
                    }
                });
            }
            
            // 스킨을 작업용 스킨 처리
            function workSkinUpdate() {
                var url = '/admin/design/work-skin-update',
                param = jQuery('#form_id_detail').serialize();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail');
                    if($("#pcGbCd").val() == "M"){
                        location.replace("/admin/design/mobile-skin");
                    }else{
                        location.replace("/admin/design/pc-skin");
                    }
                });
            }
            
            // 스킨 복사 확인창
            function copySkinConfirm(skinNo, skinId){
                $("#skinNo2").val(skinNo);
                $("#skinId2").val(skinId);
                Dmall.LayerUtil.confirm('선택한 스킨을 복사하시겠습니까?', copySkin,'','스킨관리','스킨추가');
            }
            
            // 스킨 복사 처리
            function copySkin() {
                var url = '/admin/design/skin-copy',
                param = jQuery('#form_id_detail2').serialize();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail2');
                    if($("#pcGbCd").val() == "M"){
                        location.replace("/admin/design/mobile-skin");
                    }else{
                        location.replace("/admin/design/pc-skin");
                    }
                });
            }
            
            // 파일 다운로드 
            function fn_downloadSkin(skinNo, skinId) {
                
                $("#skinNo2").val(skinNo);
                $("#skinId2").val(skinId);
                jQuery('#form_id_detail2').attr('action', '/admin/design/skin-download');
                jQuery('#form_id_detail2').submit();
            }
            
            // 스킨 삭제 확인창
            function deleteSkinConfirm(skinNo, skinId){
                $("#skinNo2").val(skinNo);
                $("#skinId2").val(skinId);
                Dmall.LayerUtil.confirm('선택한 스킨을 삭제하시겠습니까?', deleteSkin,'','스킨관리','스킨삭제');
            }
            
            // 스킨 삭제 처리
            function deleteSkin() {
                var url = '/admin/design/skin-delete',
                param = jQuery('#form_id_detail2').serialize();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail2');
                    if($("#pcGbCd").val() == "M"){
                        location.replace("/admin/design/mobile-skin");
                    }else{
                        location.replace("/admin/design/pc-skin");
                    }
                });
            }
            
            // 스킨 미리보기 처리
            function fn_preViewSkin(skinNo, skinId){
                var mobile = "";
                if($("#pcGbCd").val() == "M"){
                    mobile = "/m";
                }
                var url = mobile + "/front/main-view?_SKIN_ID="+skinId;
                window.open(url);
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- content -->
<form name="form_id_detail2" id="form_id_detail2" method="post" accept-charset="utf-8">
<input type="hidden" name="skinNo" id="skinNo2" value="" />
<input type="hidden" name="skinId" id="skinId2" value="" />
<input type="hidden" name="pcGbCd" id="pcGbCd2" value="${so.pcGbCd}" />
</form>
<form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
<input type="hidden" name="skinNo" id="skinNo" value="" />
<input type="hidden" name="pcGbCd" id="pcGbCd" value="${so.pcGbCd}" />
    <div id="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">
                    <c:if test="${so.pcGbCd eq 'M'}">모바일 </c:if>스킨관리
                    <c:if test="${so.pcGbCd eq 'C'}">

                    </c:if>
                    <c:if test="${so.pcGbCd eq 'M'}">

                    </c:if>
                </h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <!-- skin_wrap -->
                <c:set var="realSkinImg" value="" /><!-- 차후 빈이미지 넣엇음 좋겠다 -->
                <c:set var="workSkinImg" value="" />

                <c:forEach var="skinList" items="${resultListModel}" varStatus="status">
                    <c:if test="${skinList.applySkinYn eq 'Y'}">
                        <c:set var="realSkinImg" value="${skinList.imgPath}/${skinList.imgNm}" />
                    </c:if>
                    <c:if test="${skinList.workSkinYn eq 'Y'}">
                        <c:set var="workSkinImg" value="${skinList.imgPath}/${skinList.imgNm}" />
                    </c:if>
                </c:forEach>
                <div class="skin_wrap">
                    <!-- skin_con -->
                    <div class="skin_con">
                        <div>
                            <div class="btn">
                                <strong class="txt">실제적용 스킨</strong>
                            </div>
                            <div class="skin"><img src="${realSkinImg}" class="img" alt=""<%-- onerror="this.src='/admin/img/design/noImage.jpg'"--%>></div>
                        </div>
                    </div>
                    <!-- //skin_con -->
                    <!-- skin_con -->
                    <div class="skin_con">
                        <div>
                            <div class="btn">
                                <strong class="txt">디자인작업용 스킨</strong>
                            </div>
                            <div class="skin"><img src="${workSkinImg}" class="img" alt="" onerror="this.src='/admin/img/design/noImage.jpg'"></div>
                        </div>
                    </div>
                    <!-- //skin_con -->
                </div>
                <!-- //skin_wrap -->
                <h3 class="tlth3 btn1">
                    보유스킨
                    <div class="right">
                        <button class="btn_gray2" id="btn_id_zipUpload">스킨업로드</button>
                    </div>
                </h3>
                <!-- tblh -->
                <div class="tblh line_no">
                    <table summary="이표는 보유스킨 리스트 표 입니다. 구성은 선택, 스킨명, 현재상태, 미리보기, 관리 입니다.">
                        <caption>보유스킨 리스트</caption>
                        <colgroup>
                            <col width="10%">
                            <col width="36%">
                            <col width="18%">
                            <col width="18%">
                            <col width="18%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>선택</th>
                                <th>스킨명</th>
                                <th>현재상태</th>
                                <th>미리보기</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="skinList" items="${resultListModel}" varStatus="status">
                            <tr>
                                <td><label for="radio${status.count}" class="radio"><span class="ico_comm"><input type="radio" name="chkRadio" id="radio${status.count}" value="${skinList.skinNo}"></span> </label></td>
                                <td class="txtl">${skinList.skinNm}</td>
                                <td>
                                    <c:if test="${skinList.applySkinYn eq 'Y'}">
                                    실제적용
                                    </c:if>
                                    <c:if test="${skinList.applySkinYn eq 'Y' && skinList.workSkinYn eq 'Y'}">
                                     / 
                                    </c:if>
                                    <c:if test="${skinList.workSkinYn eq 'Y'}">
                                    디자인작업용
                                    </c:if>
                                </td>
                                <td><button class="btn_gray" onclick="fn_preViewSkin('${skinList.skinNo}','${skinList.skinId}');return false;">미리보기</button></td>
                                <td>
                                    <button class="btn_gray" onclick="fn_downloadSkin('${skinList.skinNo}','${skinList.skinId}');return false;">백업</button>
                                    <button class="btn_gray" onclick="copySkinConfirm('${skinList.skinNo}','${skinList.skinId}');return false;">복사</button>
                                    <c:choose>
                                       <c:when test="${skinList.applySkinYn eq 'Y'}">
                                       </c:when>
                                       <c:when test="${skinList.workSkinYn eq 'Y'}">
                                       </c:when>
                                       <c:when test="${skinList.defaultSkinYn eq 'B'}">
                                       </c:when>
                                       <c:otherwise>
                                           <button class="btn_gray" onclick="deleteSkinConfirm('${skinList.skinNo}','${skinList.skinId}');return false;">삭제</button>
                                       </c:otherwise>
                                   </c:choose>
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <div class="btn_box txtc">
                    <button class="btn blue" id="btn_id_applySkin">선택한 스킨을 실제적용 스킨으로 설정</button>
                    <button class="btn green" id="btn_id_workSkin">선택한 스킨을 작업용 스킨으로 설정</button>
                </div>
                <!-- 
                <h3 class="tlth3 mt85">디자인센터</h3>
                <div class="design_center">
                    <div class="dc_tlt">
                        <h4>무료스킨 <button class="btn_gray"><span class="btn_comm btn_more">더보기</span></button></h4>
                    </div>
                    <div class="dc_con">
                        <ul class="list">
                            <li>
                                <span class="img"><img src="../inc/img/design/img_skin2.jpg" class="img" alt=""></span><br>
                                <span class="txt">skin_basic_01</span><br>
                                <a href="#none" class="btn_gray" target="_blank" title="새 창">상세정보</a>
                            </li>
                            <li>
                                <span class="img"><img src="../inc/img/design/img_skin2.jpg" class="img" alt=""></span><br>
                                <span class="txt">skin_basic_01</span><br>
                                <a href="#none" class="btn_gray" target="_blank" title="새 창">상세정보</a>
                            </li>
                            <li>
                                <span class="img"><img src="../inc/img/design/img_skin2.jpg" class="img" alt=""></span><br>
                                <span class="txt">skin_basic_01</span><br>
                                <a href="#none" class="btn_gray" target="_blank" title="새 창">상세정보</a>
                            </li>
                            <li>
                                <span class="img"><img src="../inc/img/design/img_skin2.jpg" class="img" alt=""></span><br>
                                <span class="txt">skin_basic_01</span><br>
                                <a href="#none" class="btn_gray" target="_blank" title="새 창">상세정보</a>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="dc_tlt">
                        <h4>유료스킨 <button class="btn_gray"><span class="btn_comm btn_more">더보기</span></button></h4>
                    </div>
                    <div class="dc_con">
                        <ul class="list">
                            <li>
                                <span class="img"><img src="../inc/img/design/img_skin2.jpg" class="img" alt=""></span><br>
                                <span class="txt">skin_basic_01</span><br>
                                <span class="pri">100.000원</span><br>
                                <a href="#none" class="btn_gray" target="_blank" title="새 창">상세정보</a>
                            </li>
                            <li>
                                <span class="img"><img src="../inc/img/design/img_skin2.jpg" class="img" alt=""></span><br>
                                <span class="txt">skin_basic_01</span><br>
                                <span class="pri">100.000원</span><br>
                                <a href="#none" class="btn_gray" target="_blank" title="새 창">상세정보</a>
                            </li>
                            <li>
                                <span class="img"><img src="../inc/img/design/img_skin2.jpg" class="img" alt=""></span><br>
                                <span class="txt">skin_basic_01</span><br>
                                <span class="pri">100.000원</span><br>
                                <a href="#none" class="btn_gray" target="_blank" title="새 창">상세정보</a>
                            </li>
                            <li>
                                <span class="img"><img src="../inc/img/design/img_skin2.jpg" class="img" alt=""></span><br>
                                <span class="txt">skin_basic_01</span><br>
                                <span class="pri">100.000원</span><br>
                                <a href="#none" class="btn_gray" target="_blank" title="새 창">상세정보</a>
                            </li>
                        </ul>
                    </div>
                </div>
                 -->
            </div>
            <!-- //line_box -->
        </div>
    </div>
<!-- layout1s -->
<div id="layout1s" class="slayer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">스킨 등록</h2>
            <button class="close ico_comm" id="btn_close_zipUpload2">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <p class="message txtl">스킨 관리에 사용할 압축 파일 등록</p>
                <span class="br"></span>
                <p class="message txtl">스킨 업로드 경로 : <span id="fileUrlInfo2"></span></p>
                <span class="br"></span>
                <span class="intxt imgup1"><input id="file_route1" class="upload-name" type="text" value="" disabled="disabled"></span>
                <label class="filebtn" for="ex_file1">파일찾기</label>
                <input class="filebox" type="file" name="ex_file1" id="ex_file1" >
                <span class="br2"></span>
                <div class="btn_box txtc">
                    <button class="btn_green" id="btn_save_zipUpload">등록</button>
                    <button class="btn_red" id="btn_close_zipUpload">취소</button>
                </div>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layout1s -->
<!-- layout1s -->
<div id="confirmLayout1s" class="slayer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">스킨 등록</h2>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <p class="message txtl">스킨 업로드 처리중입니다.</p>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layout1s -->
</form>
    <!-- //content -->
    </t:putAttribute>
</t:insertDefinition>