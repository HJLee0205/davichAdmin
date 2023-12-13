<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2023/01/27
  Time: 6:29 PM
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
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">자동 발송 설정 > 푸시알림 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {

            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> 푸시알림<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">자동 발송 설정</h2>
            </div>
            <form action="" id="pushAutoSetForm">
                <div class="line_box fri">
                    <div class="tblw tbl_vagtop">
                        <table>
                            <colgroup>
                                <col width="190px" />
                                <col width="" />
                                <col width="190px" />
                                <col width="" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>
                                    타이틀1<br/><br/>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn"/>
                                </th>
                                <td>
                                    <div class="area_byte mt0">
                                        <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
                                        <div class="txt_area">
                                            <textarea name="sendWords"></textarea>
                                        </div>
                                    </div>
                                </td>
                                <th class="line">
                                    타이틀1<br/><br/>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn"/>
                                </th>
                                <td>
                                    <div class="area_byte mt0">
                                        <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
                                        <div class="txt_area">
                                            <textarea name="sendWords"></textarea>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    타이틀1<br/><br/>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn"/>
                                </th>
                                <td>
                                    <div class="area_byte mt0">
                                        <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
                                        <div class="txt_area">
                                            <textarea name="sendWords"></textarea>
                                        </div>
                                    </div>
                                </td>
                                <th class="line">
                                    타이틀1<br/><br/>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn"/>
                                </th>
                                <td>
                                    <div class="area_byte mt0">
                                        <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
                                        <div class="txt_area">
                                            <textarea name="sendWords"></textarea>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    타이틀1<br/><br/>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn"/>
                                </th>
                                <td>
                                    <div class="area_byte mt0">
                                        <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
                                        <div class="txt_area">
                                            <textarea name="sendWords"></textarea>
                                        </div>
                                    </div>
                                </td>
                                <th class="line">
                                    타이틀1<br/><br/>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn"/>
                                </th>
                                <td>
                                    <div class="area_byte mt0">
                                        <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
                                        <div class="txt_area">
                                            <textarea name="sendWords"></textarea>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_save">저장</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>