<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
$(document).ready(function() {
    
});

</script>
<!-- layer_popup1 -->
<div id="emailPreview" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">메일내용 미리보기</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <!-- tblw -->
                <div class="tblw tblmany2 mt0">
                    <table summary="이표는 메일내용 미리보기 표 입니다. 구성은 보내는사람, 받는사람, 이메일 제목, 이메일내용 입니다.">
                        <caption>메일내용 미리보기</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="30%">
                            <col width="20%">
                            <col width="30%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>보내는사람</th>
                                <td id="senderTd"></td>
                                <th>받는사람</th>
                                <td id="receiverTd"></td>
                            </tr>
                            <tr>
                                <th>이메일 제목</th>
                                <td colspan="3" id="emailTitleTd">(공지) 긴급공지 입니다.</td>
                            </tr>
                            <tr>
                                <th rowspan="2">이메일내용</th>
                                <td colspan="3" id="emailContentTd">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" id="footerTd">
                                
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->