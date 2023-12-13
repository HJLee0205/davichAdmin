<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">보안서버</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                jQuery('input[name="securityServUseTypeCd"]').on('change', function() {
                    switch (this.value) {
                        case '1':
                            jQuery('#ctrl_id_div1').removeClass('hide');
                            jQuery('#ctrl_id_div2').addClass('hide');
                            break;
                        case '2':
                            jQuery('#ctrl_id_div1').addClass('hide');
                            jQuery('#ctrl_id_div2').removeClass('hide');
                            break;
                        default:
                            jQuery('#ctrl_id_div1').addClass('hide');
                            jQuery('#ctrl_id_div2').addClass('hide');
                            break;
                    }
                });

                jQuery('#btn_id_save').on('click', function() {
                    var url = '/admin/setup/securitymanage/SecurityManage/security-config-update',
                            param = {
                                securityServUseTypeCd : jQuery('input[name="securityServUseTypeCd"]:checked').val()
                            };

                    if(param.securityServUseTypeCd === '2' && jQuery('#input_id_securityServStatusCd').val() !== '1') {
                        Dmall.LayerUtil.alert('유료보안서버를 신청하신 후 사용이 가능합니다.');
                        return;
                    }

                    if(param.securityServUseTypeCd === '1') {
                        param.certifyMarkDispYn = jQuery('input[name="certifyMarkDispYn"]:checked').val()
                    }

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        window.location.reload();
                    });
                });
            })
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <input type="hidden" name="securityServStatusCd" id="input_id_securityServStatusCd" value="${securityManagePO.securityServStatusCd}" />
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">보안서버</h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue shot" id="btn_id_save">저장하기</a>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">
                    보안서버 설정
                </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 보안서버 설정 표 입니다. 구성은  입니다.">
                        <caption>보안서버 설정</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>보안서버 사용여부</th>
                            <td>
                                <code:radio codeGrp="SECURITY_SERV_USE_TYPE_CD" name="securityServUseTypeCd" idPrefix="ctrl_id_securityServUseTypeCd" value="${securityManagePO.securityServUseTypeCd}" />
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->

                <c:choose>
                    <c:when test="${securityManagePO.securityServUseTypeCd eq 1}">
                        <c:set var="sv1" value="" />
                        <c:set var="sv2" value=" hide" />
                    </c:when>
                    <c:when test="${securityManagePO.securityServUseTypeCd eq 2}">
                        <c:set var="sv1" value=" hide" />
                        <c:set var="sv2" value="" />
                    </c:when>
                </c:choose>

                <h3 class="tlth3">
                    보안서버 관리
                </h3>
                <!-- tblw -->
                <div class="tblw tblmany${sv1}" id="ctrl_id_div1">
                    <table summary="이표는 보안서버 관리 표 입니다. 구성은 보안서버명, 상태, 보안서버 사용기간, 보안서버 적용범위, 적용방법, 인증마크 표시 입니다.">
                        <caption>보안서버 관리</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>보안서버명</th>
                            <td>무료 보안서버 사용</td>
                        </tr>
                        <tr>
                            <th>상태</th>
                            <td>정상</td>
                        </tr>
                        <tr>
                            <th>보안서버 사용기간</th>
                            <td>제한 없음(호스팅 만료 시 자동 사용만료)</td>
                        </tr>
                        <tr>
                            <th>보안서버 적용범위</th>
                            <td>로그인, 회원가입, 회원정보수정 페이지에서 이용자의 개인정보 데이터가 암호화되어 전송됨</td>
                        </tr>
                        <%-- <tr>
                            <th>적용방법</th>
                            <td>회원 로그인, 회원가입 FORM의 ACTION태그의 값을 제공하는 치환코드로 변경하여야 함</td>
                        </tr> --%>
                        <tr>
                            <th>인증마크 표시</th>
                            <td>
                                <tags:radio codeStr="Y:표시;N:표시안함" name="certifyMarkDispYn" idPrefix="radio1" value="${securityManagePO.certifyMarkDispYn}" />
                                <span class="br2"></span>
                                <span class="fc_pr1 fs_pr1">
                                    * 스킨 디자인 수정 및 변경에 따른 수동으로 인증마크 표시 적용방법<br>
                                    - 스킨 소스를 변경하였거나, 스킨을 구매했을 경우, 또는 새로 스킨을 만든 경우를 위한 표시 방법입니다.<br>
                                    - 스킨에 따라 하단소스의 Table구조가 다르니, 이 부분 유의해서 원하는 위치에 치환코드를 넣어주세요.<br>
                                    - 위에서 인증마크 표시여부를 '표시함'으로 설정 후,<br>
                                    <span class="point_c3">[디자인 &gt; HTML 편집 &gt; views &gt; outline &gt; footer &gt; footer_area.html] 을 눌러 치환코드 \${SSL_SEAL_MARK} 를 삽입하세요.</span> <a href="/admin/design/html-edit-pc" class="btn_gray">바로가기</a><br>
                                    <%-- <span class="point_c3">[디자인 &gt; HTML 편집 &gt; views &gt; outline &gt; footer &gt; footer_area.html] 을 눌러 치환코드 \${SSL_SEAL_MARK} 를 삽입하세요.</span> <a href="#none" class="btn_gray">바로가기</a> --%>
                                </span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->

                <!-- tblw -->
                <div class="tblw${sv2}" id="ctrl_id_div2">
                    <table summary="이표는 보안서버 관리 표 입니다. 구성은 보안서버명, 보안서버 사용여부, 보안서버 사용기간, 보안서버 도메인, 보안서버 포트, 보안서버 적용범위, 적용방법, 인증마크 표시 입니다.">
                        <caption>보안서버 관리</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>보안서버명</th>
                            <td>유료 보안서버 사용</td>
                        </tr>
                        <tr>
                            <th>보안서버 사용여부</th>
                            <td><code:value grpCd="SECURITY_SERV_STATUS_CD" cd="${securityManagePO.securityServStatusCd}" /></td>
                        </tr>
                        <tr>
                            <th>보안서버 사용기간</th>
                            <td>
                                <c:if test="${securityManagePO.applyStartDt ne null}">
                                    ${securityManagePO.applyStartDt} ~ ${securityManagePO.applyEndDt}
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>보안서버 도메인</th>
                            <td><c:out value="${securityManagePO.domain}" /></td>
                        </tr>
                        <tr>
                            <th>보안서버 포트</th>
                            <td><c:out value="${securityManagePO.port}" /></td>
                        </tr>
                        <tr>
                            <th>보안서버 적용범위</th>
                            <td>로그인, 회원가입, 회원정보수정 페이지에서 이용자의 개인정보 데이터가 암호화되어 전송됨</td>
                        </tr>
                       <%--  <tr>
                            <th>적용방법</th>
                            <td>회원 로그인, 회원가입 FORM의 ACTION태그의 값을 제공하는 치환코드로 변경하여야 함</td>
                        </tr> --%>
                        <tr>
                            <th>인증마크 표시</th>
                            <td>
                                <tags:radio codeStr="Y:표시;N:표시안함" name="certifyMarkDispYn" idPrefix="radio2" value="${securityManagePO.certifyMarkDispYn}" />
                                <span class="br2"></span>
                                <span class="fc_pr1 fs_pr1">
                                    * 스킨 디자인 수정 및 변경에 따른 수동으로 인증마크 표시 적용방법<br>
                                    - 스킨 소스를 변경하였거나, 스킨을 구매했을 경우, 또는 새로 스킨을 만든 경우를 위한 표시 방법입니다.<br>
                                    - 스킨에 따라 하단소스의 Table구조가 다르니, 이 부분 유의해서 원하는 위치에 치환코드를 넣어주세요.<br>
                                    - 위에서 인증마크 표시여부를 '표시함'으로 설정 후,<br>
                                    <span class="point_c3">[디자인 &gt; HTML 편집 &gt; views &gt; outline &gt; footer &gt; footer_area.html] 을 눌러 치환코드 \${SSL_SEAL_MARK} 를 삽입하세요.</span> <a href="/admin/design/html-edit-pc" class="btn_gray">바로가기</a><br>
                                    <%-- <span class="point_c3">[디자인 &gt; HTML 편집 &gt; views &gt; outline &gt; footer &gt; footer_area.html] 을 눌러 치환코드 \${SSL_SEAL_MARK} 를 삽입하세요.</span> <a href="/admin/design/html-edit-pc" class="btn_gray">바로가기</a> --%>
                                </span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>