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
    <t:putAttribute name="title">이메일 자동 발송 설정 > 이메일 > 운영</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                Dmall.validate.set('formEmailAutoSendSetInsert');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

                // 치환코드
                $('#emailReplace').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    Dmall.LayerPopupUtil.open($("#replaceLayer"));
                });

                // 자동발송 상태 변경
                $("input[name='mailTypeCd']").change(function(e) {
                    var mailTypeCd = this.value;
                    var param = {mailTypeCd:mailTypeCd};
                    var url = '/admin/operation/email-autosend-detail';
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.FormUtil.jsonToForm(result.data, 'formEmailAutoSendSetInsert');
                        Dmall.DaumEditor.setContent('ta_id_content1', result.data.mailContent); // 에디터에 데이터 세팅
                    });
                });

                // 저장
                $('#btn_save').on('click', function(e) {
                    if(Dmall.validate.isValid('formEmailAutoSendSetInsert')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/operation/email-autosend-set';
                        var param = $('#formEmailAutoSendSetInsert').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formEmailAutoSendSetInsert');
                            if(result.success){
                                location.reload();
                            }
                        });
                    }
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> 이메일<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">이메일 자동 발송 설정</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri pb">
                <h3 class="tlth3">이메일 분류 선택 </h3>
                <form action="" id="formEmailAutoSendSetInsert">
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 이메일 자동발송 설정 표 입니다. 구성은 회원관련, 주문/결제 관련, 문의관련 입니다.">
                            <caption>이메일 자동발송 설정</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
<%--                            <tr>--%>
<%--                                <th>회원 관련</th>--%>
<%--                                <td>--%>
<%--                                    <code:radioUDV name="mailTypeCd" codeGrp="MAIL_TYPE_CD"  idPrefix="mailTypeCd1" usrDfn1Val="A" />--%>
<%--                                </td>--%>
<%--                            </tr>--%>
<%--                            <tr>--%>
<%--                                <th>주문/결제 관련</th>--%>
<%--                                <td>--%>
<%--                                    <code:radioUDV name="mailTypeCd" codeGrp="MAIL_TYPE_CD"  idPrefix="mailTypeCd2" usrDfn1Val="B" check ="false" />--%>
<%--                                </td>--%>
<%--                            </tr>--%>
                            <tr>
                                <th>문의 관련</th>
                                <td>
                                    <code:radioUDV name="mailTypeCd" codeGrp="MAIL_TYPE_CD"  idPrefix="mailTypeCd3" usrDfn2Val="MAIL" check="false"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <h3 class="tlth3">보내는 메일 </h3>
                    <!-- tblw -->
                    <div class="tblw">
                        <table summary="이표는 보내는 메일 표 입니다. 구성은 발송대상, 제목, 내용 입니다.">
                            <caption>보내는 메일</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>발송대상</th>
                                <td>
                                    <tags:checkbox id="" name="memberSendYn" compareValue="" text="회원" value="Y"/>
                                    <tags:checkbox id="" name="adminSendYn" compareValue="" text="관리자" value="Y"/>
                                    <tags:checkbox id="" name="sellerSendYn" compareValue="" text="판매자" value="Y"/>
                                    <tags:checkbox id="" name="storeSendYn" compareValue="" text="가맹점" value="Y"/>
                                    <tags:checkbox id="" name="staffSendYn" compareValue="" text="임직원" value="Y"/>
                                </td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td>
                                    <span class="intxt long">
                                        <input type="text" id="mailTitle" name="mailTitle">
                                    </span>
                                    <button class="btn_blue" id="emailReplace">치환코드</button>
                                </td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>
                                    <div class="edit">
                                        <textarea id="ta_id_content1" name="mailContent" class="blind"></textarea>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </form>
            </div>
            <!-- //line_box -->
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_save">저장</button>
            </div>
        </div>
        <!-- //bottom_box -->
        <jsp:include page="/WEB-INF/views/admin/operation/email/replaceCd.jsp"/>
    </t:putAttribute>
</t:insertDefinition>