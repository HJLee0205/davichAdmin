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
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">홈 &gt; 상품 &gt; 상품등록(대량)</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {
                // 팝업 테스틍용 - 삭제대상
                jQuery('#btn_upload').off("click").on('click', function(e) {
                    Dmall.LayerPopupUtil.open($("#layer_upload_pop"));
                });

                // 엑셀 업로드
                jQuery('#btn_excelUp').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    excelUpload();
                });

                jQuery('#btn_excelSample').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    excelSample();
                });

                // 상품등록(건별) 버튼 이벤트 설정
                jQuery('#btn_regist').off("click").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    location.href= "/admin/seller/goods/goods-detail";
                });
            });

            // 상품 엑셀 업로드 테스트용
            function excelUpload() {

                if(jQuery('#file_route1').val()=='파일선택')
                    return;
                if(Dmall.validate.isValid('form_excel_insert')) {
                    var url = '/admin/goods/goods-excel-upload';

                    var param = $('#form_excel_insert').serialize();
                    if (Dmall.FileUpload.checkFileSize('form_excel_insert')) {
                        $('#form_excel_insert').ajaxSubmit({
                            url : url,
                            dataType : 'json',
                            success : function(result){
                                Dmall.validate.viewExceptionMessage(result, 'form_excel_insert');
                                //
                                if(result.success && result.totalRows !=0){
                                    Dmall.LayerUtil.alert(result.message);
                                    Dmall.LayerPopupUtil.close('layer_upload_pop');
                                } else if(!result.success){
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        });
                    }
                }
            }

            function excelSample() {
                var url = '/admin/goods/goods-download',
                    param = {};
                Dmall.FormUtil.submit(url, param, '_blank');
                return false;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">상품등록(대량) <a href="/admin/doc/201-01.pdf" class="down"><img src="/admin/img/common/q_btn.jpg" alt="다운로드" /></a></h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue" id="btn_regist">상품등록(건별)</a>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box">

                <div class="top_lay">
                    <div class="select_btn">
                        <%--<button class="btn_exl"  id="btn_upload">Excel upload <span class="ico_comm">&nbsp;</span></button>--%>
                            <button class="btn_exlup" id="btn_excelUp">등록<span class="ico_comm">&nbsp;</span></button>
                            <button class="btn_exlup" id="btn_excelSample">대량등록 템플릿 <span class="ico_comm">&nbsp;</span></button>
                    </div>
                </div>
                <div class="tblw mt0">
                    <form:form id="form_excel_insert" action="javascript:excelUpload()" enctype="multipart/form-data">
                        <table summary="이표는 파일 업로드 표 입니다. 구성은 첨부파일 입니다.">
                            <caption>파일 업로드</caption>
                            <colgroup>
                                <col width="100%">

                            </colgroup>
                            <tbody>
                            <tr>
                                <th>상품 대량등록</th>
                            </tr>
                            <tr>
                                <td>
                                    <span class="intxt"><input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled"></span>
                                    <label class="filebtn" for="ex_file1_id">파일찾기</label>
                                    <input class="filebox" type="file" name="excel" id="ex_file1_id" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </form:form>
                </div>
            </div>
            <!-- //line_box -->
        </div>
        <!-- //content -->
        <div id="layer_upload_pop" class="layer_popup">
            <div class="pop_wrap size3">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">상품업로드</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                <!-- pop_con -->
                <div class="pop_con">
                    <div>
                        <!-- tblw -->
                        <div class="tblw mt0">
                            <form:form id="form_excel_insert" action="javascript:excelUpload()" enctype="multipart/form-data">
                                <table summary="이표는 파일 업로드 표 입니다. 구성은 첨부파일 입니다.">
                                    <caption>파일 업로드</caption>
                                    <colgroup>
                                        <col width="10%">
                                        <col width="90%">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>파일업로드</th>
                                        <td>
                                            <span class="intxt"><input id="file_route1" class="upload-name" type="text" value="파일선택" disabled="disabled"></span>
                                            <label class="filebtn" for="ex_file1_id">파일찾기</label>
                                            <input class="filebox" type="file" name="excel" id="ex_file1_id" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">

                                            <button class="btn_exlup" id="btn_excelUp">Excel upload <span class="ico_comm">&nbsp;</span></button>
                                            <button class="btn_exlup" id="btn_excelSample">템플릿 <span class="ico_comm">&nbsp;</span></button>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </form:form>
                        </div>
                        <!-- //tblw -->
                        <div class="btn_box txtc">
                            <button class="btn green" id="btn_confirm_bottom_logo_upload">확인</button>
                        </div>
                    </div>
                </div>
                <!-- //pop_con -->
            </div>
        </div>

    </t:putAttribute>
</t:insertDefinition>
