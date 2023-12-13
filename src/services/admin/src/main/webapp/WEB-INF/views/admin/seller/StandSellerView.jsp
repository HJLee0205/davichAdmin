<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="net.danvi.dmall.biz.app.operation.model.AtchFileVO" %>
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
<jsp:scriptlet> 
 pageContext.setAttribute("bLine", "\n");
</jsp:scriptlet>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">입점/제휴 문의 > 업체</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                // 목록 버튼 클릭
                $('#btn_list').on('click', function() {
                    Dmall.FormUtil.submit('/admin/seller/stand-seller-list');
                });

                // 입점 등록 버튼 클릭
                $('#btn_regist').on('click', function() {
                    Dmall.LayerUtil.confirm('판매자를 입점 등록하시겠습니까?', function() {
                        var url = '/admin/seller/seller-approve';
                        var param = {};
                        var key = 'list[0].sellerNo';
                        param[key] = $('input[name=sellerNo]').val();
                        key = 'list[0].statusCd';
                        param[key] = '03';
                        key = 'list[0].managerMemo';
                        param[key] = 'approve';

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                Dmall.FormUtil.submit('/admin/seller/stand-seller-list');
                            }
                        });
                    });
                });

                // 답변하기 버튼 클릭
                $('#insert_reply').on('click', function() {
                    var param = { sellerNo: $('input[name=sellerNo]').val() };
                    Dmall.FormUtil.submit('/admin/seller/seller-reply-form', param);
                });

                // 파일 사이즈 치환
                $('.fileSize').each(function(idx, obj) {
                    $(obj).text(convertSize($(obj).text(), 1));
                });

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
            <!-- line_box -->
            <div class="line_box fri">
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
                            <td colspan="7"><c:out value="${fn:replace(sellerDtl.storeInquiryContent, bLine,'<br>')}" escapeXml="false"/></td>
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
                            <th>답변내용</th>
                            <td colspan="7"><c:out value="${sellerDtl.storeInquiryReply}" escapeXml="false"/></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
            <!-- bottom_box -->
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_regist">입점 등록</button>
                    <button class="btn--blue-round" id="insert_reply">답변하기</button>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>


<%--        <div class="sec01_box">--%>
<%--        <c:set var="sellerDtl" value="${resultModel.data}" />--%>
<%--        <c:set var="inputGbn" value="${sellerSO.inputGbn}" />--%>
<%--        <form id="form_id_sellerDtl" method="post">        --%>
<%--        <input type="hidden" name="email" id="email" value = "${sellerDtl.email}"/>--%>
<%--        <input type="hidden" name="managerEmail" id="managerEmail" value = "${sellerDtl.managerEmail}"/>--%>
<%--        <input type="hidden" name="chkSellerId" id="chkSellerId" value = ""/>--%>
<%--        <input type="hidden" name="inputGbn" id="inputGbn" value = "${sellerSO.inputGbn}"/>--%>
<%--		<input type="hidden" name="sellerNo" id="sellerNo" value="${sellerDtl.sellerNo}"/>--%>
<%--		<input type="hidden" name="sellerId" id="sellerId" value="${sellerDtl.sellerId}"/>--%>
<%--            <div class="tlt_box">--%>
<%--                <div class="btn_box left">--%>
<%--                    <c:if test="${sellerSO.inputGbn eq 'STAND-VIEW'}">--%>
<%--	                    <a href="#none" class="btn gray" id="viewStandSellerListBtn" style="min-width:150px;">판매자 입점 리스트</a>--%>
<%--	                </c:if>--%>
<%--                    <c:if test="${sellerSO.inputGbn eq 'VIEW'}">--%>
<%--	                    <a href="#none" class="btn gray" id="viewSellerListBtn">판매자리스트</a>--%>
<%--	                </c:if>    --%>
<%--                </div>--%>

<%--                <c:if test="${sellerSO.inputGbn eq 'STAND-VIEW'}">--%>
<%--	                <h2 class="tlth2">판매자 입점 내역</h2>--%>
<%--				</c:if>--%>

<%--                <c:if test="${sellerSO.inputGbn eq 'VIEW'}">--%>
<%--	                <h2 class="tlth2">판매자 내역</h2>--%>
<%--	                <div class="btn_box right">--%>
<%--	                	<button type="button" class="btn blue shot" id="btn_update">수정</button>--%>
<%--	                </div>--%>
<%--                </c:if>--%>
<%--            </div>--%>
<%--           --%>
<%--            <!-- line_box -->--%>
<%--            <div class="line_box fri">--%>
<%--                <!-- tblw -->--%>
<%--                <div class="tblw tblmany">--%>
<%--                    <table summary="이표는 기본정보 표 입니다. 구성은 이름/아이디, 실명확인, 성별, 생년월일, 이메일/수신여부, 핸드폰/수신여부, 전화번호, 주소 입니다.">--%>
<%--                        <caption>기본정보</caption>--%>
<%--                        <colgroup>--%>
<%--                            <col width="20%">--%>
<%--                            <col width="80%">--%>
<%--                        </colgroup>--%>
<%--                        <tbody>--%>
<%--                            <tr>--%>
<%--                                <th>문의구분</th>--%>
<%--                                <td>--%>
<%--                             		<c:out value="${sellerDtl.storeInquiryGbCdNm}" />--%>
<%--                                </td>--%>
<%--                            </tr>--%>
<%--                            <tr>--%>
<%--                                <th>업체명</th>--%>
<%--                                <td>--%>
<%--                             		<c:out value="${sellerDtl.sellerNm}" />--%>
<%--                                </td>--%>
<%--                            </tr>                            --%>
<%--                            <tr>--%>
<%--                                <th>담당자명 </th>--%>
<%--                                <td>--%>
<%--                             		<c:out value="${sellerDtl.managerNm}" />--%>
<%--                                </td>--%>
<%--                            </tr>--%>
<%--                            <tr>--%>
<%--                                <th>담당자 휴대폰번호</th>--%>
<%--                                <td>--%>
<%--                             		<c:out value="${sellerDtl.managerMobileNo}" />--%>
<%--                                </td>--%>
<%--                            </tr>--%>
<%--			                <tr>--%>
<%--			                    <th>담당자 이메일</th>--%>
<%--			                    <td>--%>
<%--                             		<c:out value="${sellerDtl.managerEmail}" />--%>
<%--			                    </td>--%>
<%--			                </tr>--%>
<%--                            <tr>--%>
<%--                                <th>문의내용 </th>--%>
<%--                                <td>		--%>
<%--                                    <c:out value="${fn:replace(sellerDtl.storeInquiryContent, bLine,'<br>')}" escapeXml="false"/>--%>
<%--                                </td>--%>
<%--                            </tr>  --%>
<%--                            <tr>--%>
<%--                                <th>참조파일</th>--%>
<%--                                <td>--%>
<%--                                    <span id = "refFileInert"></span>--%>
<%--                                </td>--%>
<%--                            </tr>                                                        --%>
<%--                        </tbody>--%>
<%--                    </table>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <!-- //line_box -->--%>
<%--            </form>--%>
<%--        </div>--%>
        
    </t:putAttribute>
</t:insertDefinition>
