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
    <t:putAttribute name="title">팝업 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            var editYn = "${editYn}";
            jQuery(document).ready(function() {

                if (editYn === 'Y') {
                    bindAtchFile();
                }

                // 이미지 첨부 시 미리보기 이미지 표시
                $('input[type=file]').change(function() {
                    console.log("this.files = ", this.files);
                    if(this.files && this.files[0]) {
                        var fileNm = this.files[0].name;
                        var name = $(this).attr('name');
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            var template =
                                '<img src="' + e.target.result + '" alt="미리보기 이미지"><br>' +
                                '<span class="txt">' + fileNm + '</span>' +
                                '<button class="cancel">삭제</button>';
                            $('.preview_' + name).html(template);
                        };
                        reader.readAsDataURL(this.files[0]);
                    }
                });

                // 이미지 삭제 버튼 클릭
                $('.upload_file').on('click', '.cancel', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var obj = $(e.target).parents('.upload_file');
                    var strIdx = obj.attr('class').lastIndexOf('file');
                    var name = obj.attr('class').substring(strIdx, strIdx + 5);
                    $('input[name=' + name + ']').val('');
                    obj.html('');
                });
                
                
                // 체크
                //Dmall.validate.set('form_id_detail');
                
                // 등록
                jQuery('#a_id_save').on('click', function(e) {
                    console.log("a_id_save clicked");
                    e.preventDefault();
                    e.stopPropagation();
                    var popupNo = "${resultListModel.data.popupNo}";
                    var $srch_sc01 = $("#date_val_start");
                    var $srch_sc02 = $("#date_val_end");
                    var $applyAlwaysYn = $("#lb_applyAlwaysYn");


                    if (!$applyAlwaysYn.hasClass('on')) {
                        if ($srch_sc01.val() == '' || $srch_sc01.val() == null || $srch_sc02.val() == '' || $srch_sc02.val() == null) {
                            Dmall.LayerUtil.alert("기간을 선택해주세요");
                            return false;
                        } else if ($srch_sc01.val() > $srch_sc02.val()) {
                            Dmall.LayerUtil.alert("시작날짜가 종료날짜보다 큽니다.")
                            return false;
                        }
                    }
                    if(Dmall.validate.isValid('form_id_detail')) {
                        //Dmall.editordata.saveContent();
                        
                        // 에디터 처리 할 부분만 적용 start
                        //Dmall.DaumEditor.setValueToTextarea('ta_content');  // 에디터에서 폼으로 데이터 세팅
                        // 에디터 처리 할 부분만 적용 end
                        
                        dateSum();
                        if(popupNo === ""){
                            Dmall.LayerUtil.confirm('등록 하시겠습니까?', InsertPopup);
                        }else{
                            Dmall.LayerUtil.confirm('수정 하시겠습니까?', UpdatePopup);
                        }
                    }
                });
                
                // 리스트 화면
                jQuery('#btn_id_list').on('click', function(e) {
                    location.replace("/admin/design/pop-manage");
                });
                
                var attachImages = [];
                <c:forEach var="file" items="${resultListModel.data.attachImages}">
                attachImages.push({
                    imageUrl : "${file.imageUrl}",
                        fileName : "${file.fileName}",
                        tempFileName : "${file.tempFileName}",
                        fileSize : "${file.fileSize}",
                        thumbUrl : "${file.thumbUrl}",
                        temp : "${file.temp}"
                    });
                </c:forEach>

                //Dmall.DaumEditor.setAttachedImage('ta_content', attachImages); // 에디터에 첨부 이미지 데이터 세팅


                // 삭제
                /*jQuery('#a_id_del').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var poopupNo = "2";

                    Dmall.LayerUtil.confirm('삭제 하시겠습니까?', DeletePopup,'','팝업관리','삭제');
                });*/

                jQuery('#a_id_list').on('click', function(e) {
                    location.replace("/admin/design/pop-manage");
                });
            });

            
        </script>
        <script>
        // 기본 값 호출해야함. textarea 값은 화면에 맞게 처리 하시길 바랍니다.
            function onLoadEditorData(){
                var str = jQuery("textarea#content").val();
                editordata.iframeContent(str);
            } 
        // 에디터에서 수정된 내용이 우리쪽에 옮기는 기능
            function finalData(str){
                jQuery("textarea#content").val(str);
            }
            // 저장 전에 호출해야 하는 함수
            // editordata.saveContent();
            
            // 날짜함수 합치기
            function dateSum(){
                var startDate = $("#date_val_start").val().replace(/-/g,'');
                var startSi = $("#dispStartDttmSi").val();
                var startMi = $("#dispStartDttmMi").val();
                $("#dispStartDttm").val(startDate+startSi+startMi+"00");
                var endDate = $("#date_val_end").val().replace(/-/g,'');
                var endSi = $("#dispEndDttmSi").val();
                var endMi = $("#dispEndDttmMi").val();
                $("#dispEndDttm").val(endDate+endSi+endMi+"00");
            }
            
            // 인서트
            function InsertPopup(){
                var url = '/admin/design/pop-insert',
                param = jQuery('#form_id_detail').serialize();

                /*Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_detail');
                    if(result.success){
                        location.replace("/admin/design/pop-manage");
                    } 
                });*/
                var param = jQuery('#form_id_detail').serialize();
                console.log("param = ", param);
                $('#form_id_detail').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                            Dmall.LayerUtil.alert(result.message);
                        } else {
                            Dmall.LayerUtil.alert(result.message);
                            location.replace("/admin/design/pop-manage");
                        }
                    }
                });
            }
            
            // 수정
            function UpdatePopup(){
                var url = '/admin/design/pop-update',
                param = jQuery('#form_id_detail').serialize();

                console.log("param = ", param);
                $('#form_id_detail').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                            Dmall.LayerUtil.alert(result.message);
                        } else {
                            Dmall.LayerUtil.alert(result.message);
                        }
                    }
                });
            }

        // 첨부 이미지 정보 바인딩
        function bindAtchFile() {

            var fileInfo = "${resultListModel.data.imgFileInfo}";
            var fileNm = "${resultListModel.data.fileNm}";
            var orgFileNm = "${resultListModel.data.orgFileNm}";

            //$('.preview_filePc').attr('id', fileNo);

            /*console.log("fileInfo = ", fileInfo);
            console.log("fileNm = ", fileNm);
            console.log("orgFileNm = ", orgFileNm);*/

            var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=POPUP&id1=' + fileInfo;
            var template =
                '<img src="' + imgSrc + '" alt="미리보기 이미지"><br>' +
                '<span class="txt">' + orgFileNm + '</span>' +
                '<button class="cancel">삭제</button>';
            $('.preview_filePc').html(template);

        }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- content -->
        <div class="sec01_box">
            <div class="tlt_box">
                <%--<div class="btn_box left">
                    <a href="#none" class="btn gray" id="btn_id_list">팝업 관리</a>
                </div>
                <h2 class="tlth2">팝업 관리</h2>--%>
                <div class="tlt_box">
                    <div class="tlt_head">
                        디자인 설정<span class="step_bar"></span>  팝업 관리 <span class="step_bar"></span>
                    </div>
                    <h2 class="tlth2">팝업 관리</h2>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <!-- tblw -->
                <form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
                <input type="hidden" name="popupNo" class="blind" value="${resultListModel.data.popupNo}" />
                <input type="hidden" name="pcGbCd" class="blind" value="C" />
                <input type="hidden" name="popupGrpCd" class="blind" value="MM" />
                <input type="hidden" name="popupGbCd" class="blind" value="P" />
                <div class="tblw tblmany">
                    <table summary="이표는 팝업 관리 설정 표 입니다. 구성은  입니다.">
                        <caption>팝업 관리 설정</caption>
                        <colgroup>
                            <col width="150px">
                            <col width="">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>팝업 노출 기간 <span class="important">*</span></th>
                                <td colspan="3">
                                    <span class="intxt">
                                        <input type="text" name="dispStartDttmDate" value="${fn:substring(resultListModel.data.dispStartDttm, 0, 8)}" id="date_val_start" class="bell_date_sc" data-validation-engine="validate[required]">
                                    </span>
                                    <%--<a href="javascript:void(0)" class="date_sc ico_comm" id="date_val_date01">달력이미지</a>--%>
                                    <span class="select shot">
                                        <label for="">시간 선택</label>
                                        <select name="dispStartDttmSi" id="dispStartDttmSi" data-validation-engine="validate[required]">
                                            <option value="">선택</option>
                                            <c:forEach var="i" begin="0" end="23">
                                            <c:set var="selected" value=""/>
                                            <fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
                                            <c:if test="${fn:substring(resultListModel.data.dispStartDttm, 8, 10) eq timePattern}">
                                                <c:set var="selected" value="selected"/>
                                            </c:if>
                                            <option value="${timePattern}" ${selected}>${timePattern}시</option>
                                            </c:forEach>
                                        </select>
                                    </span>
                                    <span class="select shot">
                                        <label for="">시간 선택</label>
                                        <select name="dispStartDttmMi" id="dispStartDttmMi" data-validation-engine="validate[required]">
                                            <option value="">선택</option>
                                            <c:forEach var="i" begin="0" end="59">
                                            <c:set var="selected" value=""/>
                                            <fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
                                            <c:if test="${fn:substring(resultListModel.data.dispStartDttm, 10, 12) eq timePattern}">
                                                <c:set var="selected" value="selected"/>
                                            </c:if>
                                            <option value="${timePattern}" ${selected}>${timePattern}분</option>
                                            </c:forEach>
                                        </select>
                                    </span>
                                    <input type="hidden" name="dispStartDttm" id="dispStartDttm" class="blind" value="" /> 
                                    ~
                                    <span class="intxt ml10"><input type="text" name="dispEndDttmDate" value="${fn:substring(resultListModel.data.dispEndDttm, 0, 8)}" id="date_val_end" class="bell_date_sc" data-validation-engine="validate[required]"></span>
                                    <a href="javascript:void(0)" class="date_sc ico_comm" id="date_val_date02">달력이미지</a>
                                    <span class="select shot">
                                        <label for="">시간 선택</label>
                                        <select name="dispEndDttmSi" id="dispEndDttmSi" data-validation-engine="validate[required]">
                                            <option value="">선택</option>
                                            <c:forEach var="i" begin="0" end="23">
                                            <c:set var="selected" value=""/>
                                            <fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
                                            <c:if test="${fn:substring(resultListModel.data.dispEndDttm, 8, 10) eq timePattern}">
                                                <c:set var="selected" value="selected"/>
                                            </c:if>
                                            <option value="${timePattern}" ${selected}>${timePattern}시</option>
                                            </c:forEach>
                                        </select>
                                    </span>
                                    <span class="select shot">
                                        <label for="">시간 선택</label>
                                        <select name="dispEndDttmMi" id="dispEndDttmMi" data-validation-engine="validate[required]">
                                            <option value="">선택</option>
                                            <c:forEach var="i" begin="0" end="59">
                                            <c:set var="selected" value=""/>
                                            <fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
                                            <c:if test="${fn:substring(resultListModel.data.dispEndDttm, 10, 12) eq timePattern}">
                                                <c:set var="selected" value="selected"/>
                                            </c:if>
                                            <option value="${timePattern}" ${selected}>${timePattern}분</option>
                                            </c:forEach>
                                        </select>
                                    </span>
                                    <input type="hidden" name="dispEndDttm" id="dispEndDttm" class="blind" value="" />
                                    <label for="applyAlwaysYn" id="lb_applyAlwaysYn" class="chack mr20">
                                        <input type="checkbox" name="applyAlwaysYn" id="applyAlwaysYn" value="Y" class="blind" />
                                        <span class="ico_comm">&nbsp;</span>
                                        무제한
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th>팝업 제목<span class="important">*</span></th>
                                <td colspan="3"><span class="intxt wid100p"><input type="text" value="${resultListModel.data.popupNm}" id="popupNm" name="popupNm" data-validation-engine="validate[required, maxSize[50]]"></span></td>
                            </tr>
                            <tr>
                                <th>URL</th>
                                <td colspan="3">
                                    <span class="intxt long"><input type="text" value="${resultListModel.data.linkUrl}" id="linkUrl" name="linkUrl" data-validation-engine="validate[maxSize[100],custom[url]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>이미지<span class="important">*</span></th>
                                <td colspan="3">
                                    <span class="intxt"><input class="upload-name" type="text" value="" disabled="disabled"></span>
                                    <label class="filebtn">파일첨부
                                        <input class="filebox" type="file" name="filePc" accept="image/*">
                                    </label>
                                    <div class="desc_txt br2 ">
                                        <div class="desc_txt br2 ">
                                            · 파일 첨부 시 10MB 이하 업로드 (jpg / png / gif / bmp)<br>
                                            <em class="point_c6">· 550px X 700px 사이즈로 등록하여 주세요.</em>
                                    </div>

                                    <div class="upload_file preview_filePc"></div>
                                </td>
                            </tr>
                            <tr>
                                <th>사용여부 <span class="important">*</span></th>
                                <td colspan="3">
                                    <tags:radio name="dispYn"  idPrefix="srch_id_dispYn" codeStr="Y:사용;N:미사용" value="${resultListModel.data.dispYn}" validate="validate[required]" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                </form>
                <!-- //tblw -->
                <!-- 화면이 너무 달라서 수정 
                <div class="bottom_lay">
                    <div class="right">
                        <a href="none" class="btn_gray2" id="a_id_save">등록/수정</a>
                    </div>
                </div>
                 -->

            </div>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="left">
                    <!-- <button class="btn--big btn--big-white" id="btn_sel_delete">선택 삭제</button> -->
                    <button class="btn--big btn--big-white" id="a_id_list">목록</button>
                </div>
                <div class="right">
                    <!-- <button class="btn--blue-round" id="btn_regist">등록</button> -->
                    <button class="btn--blue-round" id="a_id_save">저장</button>
                    <!-- <button class="btn--blue-round" id="btn_change">수정</button> -->
                </div>
            </div>
        </div>
    <!-- //content -->
    </t:putAttribute>
</t:insertDefinition>
