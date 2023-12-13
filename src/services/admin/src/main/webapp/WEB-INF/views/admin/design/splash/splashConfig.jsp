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
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; 스플래시 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            var editYn = "${editYn}";
            jQuery(document).ready(function() {

                if (editYn === 'Y') {
                    bindAtchFile();
                }

                // 이미지 첨부 시 미리보기 이미지 표시
                $('input[type=file]').change(function() {
                    //console.log("this.files = ", this.files);
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
                    e.preventDefault();
                    e.stopPropagation();
                    var splashNo = "${resultListModel.data.splashNo}";
                    
                    if(Dmall.validate.isValid('form_id_detail')) {
                        //Dmall.editordata.saveContent();
                        
                        // 에디터 처리 할 부분만 적용 start
                        //Dmall.DaumEditor.setValueToTextarea('ta_content');  // 에디터에서 폼으로 데이터 세팅
                        // 에디터 처리 할 부분만 적용 end
                        
                        dateSum();
                        var param = jQuery('#form_id_detail').serialize();
                        //console.log("InsertSplash param = ", param);

                        if(splashNo == ""){
                            Dmall.LayerUtil.confirm('등록 하시겠습니까?', InsertSplash);
                        }else{
                            Dmall.LayerUtil.confirm('수정 하시겠습니까?', UpdateSplash);
                        }
                    }
                });
                
                // 리스트 화면
                jQuery('#btn_id_list').on('click', function(e) {
                    location.replace("/admin/design/splash-manage");
                });

                // 삭제
                /*jQuery('#a_id_del').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    Dmall.LayerUtil.confirm('삭제 하시겠습니까?', DeleteSplash,'','스플래시관리','삭제');
                });*/

                jQuery('#a_id_list').on('click', function(e) {
                    location.replace("/admin/design/splash-manage");
                });
            });

            
        </script>
        <script>

            function finalData(str){
                jQuery("textarea#content").val(str);
            }
            
            // 날짜함수 합치기
            function dateSum(){
                var startDate = $("#date_val_sc01").val().replace(/-/g,'');
                var startSi = $("#dispStartDttmSi").val();
                var startMi = $("#dispStartDttmMi").val();
                $("#dispStartDttm").val(startDate+startSi+startMi+"00");
                var endDate = $("#date_val_sc02").val().replace(/-/g,'');
                var endSi = $("#dispEndDttmSi").val();
                var endMi = $("#dispEndDttmMi").val();
                $("#dispEndDttm").val(endDate+endSi+endMi+"00");
            }
            
            // 인서트
            function InsertSplash(){
                var url = '/admin/design/splash-insert',
                param = jQuery('#form_id_detail').serialize();

                var $srch_sc01 = $("#date_val_sc01");

                var $srch_sc02 = $("#date_val_sc02");


                if($srch_sc01.val() == '' || $srch_sc01.val() == null || $srch_sc02.val() == '' || $srch_sc02.val() == null) {
                    Dmall.LayerUtil.alert("기간을 선택해주세요");
                    return false;
                } else if($srch_sc01.val() > $srch_sc02.val()){
                    Dmall.LayerUtil.alert("시작날짜가 종료날짜보다 큽니다.")
                    return false;
                }
                console.log("InsertSplash param = ", param);
                $('#form_id_detail').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                            Dmall.LayerUtil.alert(result.message);
                        } else {
                            Dmall.LayerUtil.alert(result.message).done(function () {
                                location.replace("/admin/design/splash-manage");
                            });
                        }
                    }
                });
            }
            
            // 수정
            function UpdateSplash(){
                var url = '/admin/design/splash-update',
                param = jQuery('#form_id_detail').serialize();

                console.log("UpdateSplash param = ", param);
                $('#form_id_detail').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                            Dmall.LayerUtil.alert(result.message);
                        } else {
                            Dmall.LayerUtil.alert(result.message).done(function () {
                                location.replace("/admin/design/splash-manage");
                            });
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

            console.log("fileInfo = ", fileInfo);
            console.log("fileNm = ", fileNm);
            console.log("orgFileNm = ", orgFileNm);

            var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=SPLASH&id1=' + fileInfo;
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
                <div class="tlt_box">
                    <div class="tlt_head">
                        디자인 설정<span class="step_bar"></span>  스플래시 관리 <span class="step_bar"></span>
                    </div>
                    <h2 class="tlth2">스플래시 관리</h2>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <!-- tblw -->
                <form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
                <input type="hidden" name="splashNo" class="blind" value="${resultListModel.data.splashNo}" />
                <input type="hidden" name="filePath" class="blind" value="${resultListModel.data.filePath}" />
                <input type="hidden" name="fileNm" class="blind" value="${resultListModel.data.fileNm}" />
                <input type="hidden" name="orgFileNm" class="blind" value="${resultListModel.data.orgFileNm}" />
                <input type="hidden" name="fileSize" class="blind" value="${resultListModel.data.fileSize}" />
                <div class="tblw tblmany">
                    <table summary="이표는 스플래시 관리 설정 표 입니다. 구성은  입니다.">
                        <caption>스플래시 관리 설정</caption>
                        <colgroup>
                            <col width="150px">
                            <col width="">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>스플래시 노출 기간 <span class="important">*</span></th>
                                <td colspan="3">
                                    <span class="intxt"><input type="text" name="dispStartDttmDate" value="${fn:substring(resultListModel.data.dispStartDttm, 0, 8)}" id="date_val_sc01" class="bell_date_sc" data-validation-engine="validate[required]"></span>
                                    <a href="javascript:void(0)" class="date_sc ico_comm" id="date_val_date01">달력이미지</a>
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
                                    <span class="intxt ml10"><input type="text" name="dispEndDttmDate" value="${fn:substring(resultListModel.data.dispEndDttm, 0, 8)}" id="date_val_sc02" class="bell_date_sc" data-validation-engine="validate[required]"></span>
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
                                    <label for="applyAlwaysYn" class="chack mr20">
                                        <input type="checkbox" name="applyAlwaysYn" id="applyAlwaysYn" value="Y" class="blind" />
                                        <span class="ico_comm">&nbsp;</span>
                                        무제한
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th>스플래시 제목<span class="important">*</span></th>
                                <td colspan="3"><span class="intxt wid100p"><input type="text" value="${resultListModel.data.splashNm}" id="splashNm" name="splashNm" data-validation-engine="validate[required, maxSize[50]]"></span></td>
                            </tr>
                            <tr>
                                <th>이미지<span class="important">*</span></th>
                                <td colspan="3">
                                    <span class="intxt"><input class="upload-name" type="text" value="" disabled="disabled"></span>
                                    <label class="filebtn">파일첨부
                                        <input class="filebox" type="file" name="filePc" accept="image/*">
                                    </label>
                                    <div class="desc_txt br2 ">
                                        · 파일 첨부 시 10MB 이하 업로드 ( jpg / png / gif / bmp )
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