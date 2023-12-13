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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 기본관리 &gt; 약관/개인정보 설정 &gt; 이용약관</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
      <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
      <script type="text/javascript">
            jQuery(document).ready(function() {
                // 저장하기 버튼 이벤트 처리
                jQuery('#btn_confirm').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if(Dmall.validate.isValid('form_term_info')) {
                        Dmall.DaumEditor.setValueToTextarea(['ta_content', 'ta_content_nomember', 'ta_content_exchange', 'ta_content_refund']);  // 에디터에서 폼으로 데이터 세팅

                        var url;
                        var param = $('#form_term_info').serialize();
                        var type = $("#hid_type").val();

                        if (type === "update") {
                            url = '/admin/setup/config/term/term-config-update';
                        } else {
                            url = '/admin/setup/config/term/term-config-insert';
                        }

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_term_info');

                            if (result == null || result.success != true) {
                                return;
                            } else {
                                var siteinfocd = $("input:hidden[name=siteInfoCd]").val();
                                Dmall.FormUtil.submit('/admin/setup/config/term/terms-config-list', {siteInfoCd : siteinfocd});
                            }
                        });

                    }
                    return false;
                });

                // 다음에디터 로딩
                fn_loadEditor();

                // Valicator 셋팅
                Dmall.validate.set('form_term_info');
            });

            function fn_loadEditor() {
                var siteinfocd = $("input:hidden[name=siteInfoCd]").val();

                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_content'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

                if ('04' === siteinfocd) {
                    Dmall.DaumEditor.create('ta_content_nomember'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                }
                if ('11' === siteinfocd) {
                    Dmall.DaumEditor.create('ta_content_exchange'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                    Dmall.DaumEditor.create('ta_content_refund'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                }

                var type = $("#hid_type").val();

                if (type === "update") {
                    getEditorDataInfo();
                }
            }

             function getEditorDataInfo() {
                var siteinfocd = $('input:hidden[name=siteInfoCd]').val();
                 var siteinfono = $("#hid_siteInfoNo").val();

                 Dmall.AjaxUtil.getJSON('/admin/setup/config/term/term-config', { siteInfoCd: siteinfocd, siteInfoNo : siteinfono }, function(result) {
                     if (result == null || result.success != true) {
                         return;
                     } else {
                         if (result.data) {
                             Dmall.FormUtil.jsonToForm(result.data, 'form_term_info');

                             Dmall.DaumEditor.setContent('ta_content', result.data.content); // 에디터에 데이터 세팅
                             Dmall.DaumEditor.setAttachedImage('ta_content', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                         }
                     }
                 });

                 if ('04' === siteinfocd) {
                     Dmall.AjaxUtil.getJSON('/admin/setup/config/term/term-config', { siteInfoCd : '20', siteInfoNo : siteinfono }, function(result) {
                         if (result == null || result.success != true) {
                             return;
                         } else {
                             if (result.data) {
                                 //$('#ta_content_nomember').val(result.data.content);
                                 Dmall.DaumEditor.setContent('ta_content_nomember', result.data.content); // 에디터에 데이터 세팅
                                 Dmall.DaumEditor.setAttachedImage('ta_content_nomember', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                             }
                         }
                     })
                 }
                 if ('11' === siteinfocd) {
                     Dmall.AjaxUtil.getJSON('/admin/setup/config/term/term-config', { siteInfoCd : '15', siteInfoNo : siteinfono }, function(result) {
                         if (result == null || result.success != true) {
                             return;
                         } else {
                             if (result.data) {
                                 Dmall.DaumEditor.setContent('ta_content_exchange', result.data.content); // 에디터에 데이터 세팅
                                 Dmall.DaumEditor.setAttachedImage('ta_content_exchange', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                             }
                         }
                     })
                     Dmall.AjaxUtil.getJSON('/admin/setup/config/term/term-config', { siteInfoCd : '16', siteInfoNo : siteinfono }, function(result) {
                         if (result == null || result.success != true) {
                             return;
                         } else {
                             if (result.data) {
                                 Dmall.DaumEditor.setContent('ta_content_refund', result.data.content); // 에디터에 데이터 세팅
                                 Dmall.DaumEditor.setAttachedImage('ta_content_refund', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                             }
                         }
                     })
                 }
             }
      </script>
   </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <c:if test="${so.siteInfoCd eq '03'}">
                    <h2 class="tlth2">이용약관 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '04'}">
                    <h2 class="tlth2">개인정보 처리방침 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '05'}">
                    <h2 class="tlth2">개인정보 처리방침 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '07'}">
                    <h2 class="tlth2">개인정보제공 제3자 제공 동의 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '08'}">
                    <h2 class="tlth2">개인정보 처리 위탁 동의 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '09'}">
                    <h2 class="tlth2">멤버쉽 회원약관 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '10'}">
                    <h2 class="tlth2">온라인몰 이용약관 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '11'}">
                    <h2 class="tlth2">기타이용안내 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '21'}">
                    <h2 class="tlth2">청소년 보호정책 </h2>
                </c:if>
                <c:if test="${so.siteInfoCd eq '22'}">
                    <h2 class="tlth2">위치정보 이용약관 </h2>
                </c:if>
                <input type="hidden" id="hid_type" value="${so.type}"/>
            </div>

            <!-- line_box -->
            <form id="form_term_info" >
                <input type="hidden" id="hid_siteInfoNo" name="siteInfoNo" value="${so.siteInfoNo}"/>
                <div class="line_box fri" id="div_tab_site_info">
                    <div class="tblh tblmany">
                        <table summary="이표는 기본 표 입니다.">
                            <caption>사용여부</caption>
                            <colgroup>
                                <col width="150px"/>
                                <col width=""/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>제목<span class="important">*</span></th>
                                    <td>
                                        <span class="intxt w100p">
                                            <input type="text" id="form_title" name="title" value="${so.title}">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>사용여부</th>
                                    <td id="td_useYn">
                                        <tags:radio name="useYn" idPrefix="sel_useYn" codeStr="Y:사용함;N:사용안함" value="Y"/>
                                    </td>
                                </tr>
                            <c:choose>
                                <c:when test="${so.siteInfoCd ne '04' && so.siteInfoCd ne '11'}" >
                                <tr>
                                    <th>내용<span class="important">*</span></th>
                                    <td>
                                        <div class="clause_box edit">
                                            <textarea id="ta_content" name="content" class="blind"></textarea>
                                            <input type="hidden" name="siteInfoCd" value="${so.siteInfoCd}"/>
                                        </div>
                                    </td>
                                </tr>
                                </c:when>
                                <c:otherwise>
                                <c:if test="${so.siteInfoCd eq '04'}" >
                                <tr>
                                    <th>회원<span class="important">*</span></th>
                                    <td id="td_member">
                                        <div class="clause_box edit">
                                            <textarea id="ta_content" name="content" class="blind"></textarea>
                                            <input type="hidden" name="siteInfoCd" value="${so.siteInfoCd}"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>비회원<span class="important">*</span></th>
                                    <td id="td_nomember">
                                        <div class="clause_box edit">
                                            <textarea id="ta_content_nomember" name="contentNoMember" class="blind"></textarea>
                                            <input type="hidden" name="siteInfoCdNoMember" value="20"/>
                                        </div>
                                    </td>
                                </tr>
                                </c:if>
                                <c:if test="${so.siteInfoCd eq '11'}" >
                                <tr>
                                    <th>배송안내<span class="important">*</span></th>
                                    <td id="td_delivery">
                                        <div class="clause_box edit">
                                            <textarea id="ta_content" name="content" class="blind"></textarea>
                                            <input type="hidden" name="siteInfoCd" value="${so.siteInfoCd}"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>반품/교환<br>안내<span class="important">*</span></th>
                                    <td id="td_exchange">
                                        <div class="clause_box edit">
                                            <textarea id="ta_content_exchange" name="contentExchange" class="blind"></textarea>
                                            <input type="hidden" name="siteInfoCdExchange" value="15"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>취소/환불<br>안내<span class="important">*</span></th>
                                    <td id="td_refund">
                                        <div class="clause_box edit">
                                            <textarea id="ta_content_refund" name="contentRefund" class="blind"></textarea>
                                            <input type="hidden" name="siteInfoCdRefund" value="16"/>
                                        </div>
                                    </td>
                                </tr>
                                </c:if>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                </div>
            </form>

            <!-- //line_box -->
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="btn_confirm">저장하기</button>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>