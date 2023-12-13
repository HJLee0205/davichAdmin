<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2023/01/05
  Time: 11:51 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">입점/제휴 문의 > 업체</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                Dmall.validate.set('form_partnership_info');
                Dmall.DaumEditor.init();
                Dmall.DaumEditor.create('ta_id_content1');

                // 다음에디터 내용 바인딩
                Dmall.DaumEditor.setContent('ta_id_content1', '${resultModel.data.storeInquiryReply}');
                Dmall.DaumEditor.setAttachedImage('ta_id_content1', JSON.parse('${attachImages}'));

                // 답변하기 버튼 클릭
                $('#insert_reply').on('click', function() {
                    Dmall.DaumEditor.setValueToTextarea('ta_id_content1');
                    if(Dmall.validate.isValid('form_partnership_info')) {
                        var url = '/admin/seller/seller-reply-insert';
                        var param = $('#form_partnership_info').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_partnership_info');
                            if(result.success) {
                                Dmall.FormUtil.submit('/admin/seller/stand-seller-list');
                            }
                        });
                    }
                });

                // 파일 사이즈 치환
                $('.fileSize').each(function(idx, obj) {
                    $(obj).text(convertSize($(obj).text(), 1));
                })

                // 파일 다운로드 버튼 클릭
                $('.tbl_link').on('click', function() {
                    var param = { sellerNo: $('#sellerNo').val(), fileGbn: 'ref' };
                    var url = '/admin/seller/download';

                    Dmall.FormUtil.submit(url, param, '_blank');
                });
            });

            function convertSize(size, unit) {
                for(let i = 0; i < unit; i++) {
                    size = size / 1024;
                }
                return size.toFixed(1).toLocaleString('ko-KR');
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <c:set var="sellerDtl" value="${resultModel.data}" />
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    업체 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">입점/제휴 문의</h2>
            </div>
            <form id="form_partnership_info">
                <c:choose>
                    <c:when test="${sellerDtl.storeInquiryReply eq null}">
                        <input type="hidden" name="saveType" value="I">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="saveType" value="U">
                    </c:otherwise>
                </c:choose>
                <!-- line_box -->
                <div class="line_box fri pb">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 등록 표 입니다. 구성은 작성자, 말머리, 제목, 내용 입니다.">
                            <caption>게시글 등록</caption>
                            <colgroup>
                                <col width="10%">
                                <col width="15%">
                                <col width="10%">
                                <col width="15%">
                                <col width="10%">
                                <col width="15%">
                                <col width="10%">
                                <col width="15%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>업체명</th>
                                <td>
                                    <input type="hidden" id="sellerNo" name="sellerNo" value='<c:out value="${sellerDtl.sellerNo}"/>'>
                                    <c:out value="${sellerDtl.sellerNm}"/>
                                </td>
                                <th>담당자명</th>
                                <td><c:out value="${sellerDtl.managerNm}"/></td>
                                <th>이메일</th>
                                <td><c:out value="${sellerDtl.managerEmail}"/></td>
                                <th>연락처</th>
                                <td><c:out value="${sellerDtl.managerMobileNo}"/></td>
                            </tr>
                            <tr>
                                <th>문의 구분</th>
                                <td colspan="7"><c:out value="${sellerDtl.storeInquiryGbCdNm}"/></td>
                            </tr>
                            <tr>
                                <th>문의 내용</th>
                                <td colspan="7"><c:out value="${sellerDtl.storeInquiryContent}"/></td>
                            </tr>
                            <tr>
                                <th>첨부파일</th>
                                <td colspan="7">
                                    <c:if test="${sellerDtl.refOrgFileNm ne null}">
                                    <span>
                                        <a href="#none" class="tbl_link">${sellerDtl.refOrgFileNm}
                                            (
                                            <span class="fileSize">${sellerDtl.refFileSize}</span>
                                            KB)
                                            <img src="../img/icons/icon-upload.png" alt="" class="icon_upload">
                                        </a>
                                    </span>
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <th>답변내용<span class="important">*</span></th>
                                <td colspan="7">
                                    <textarea id="ta_id_content1" name="storeInquiryReply" class="blind" data-validation-engine="validate[required], minSize[12]"></textarea>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <p class="desc_txt br2">
                            · 답변 시 담당자에게 알림톡, SMS와 이메일이 발송됩니다.
                            <br>· 알림톡, SMS : 답변완료 문자, 이메일 : 답변내용
                        </p>
                    </div>
                    <!-- //tblw -->
                </div>
                <!-- //line_box -->
            </form>
            <!-- bottom_box -->
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="insert_reply">답변하기</button>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>