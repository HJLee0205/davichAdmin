<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<div id="accountManageLayer" class="layer_popup">
    <div class="pop_wrap size2">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">은행계좌 등록</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form id="popupForm">
        <div class="pop_con">
            <div>
                <!-- tblw -->
                <div class="tblw mt0">
                    <table summary="이표는 은행계좌 등록 표 입니다. 구성은 은행명, 계좌번호, 예금주 입니다.">
                        <caption>은행계좌 등록</caption>
                        <colgroup>
                            <col width="30%">
                            <col width="70%">
                        </colgroup>
                        <tbody id="tbodyPopup">
                            <tr>
                                <th>은행명</th>
                                <td>
                                    <span class="select nor">
                                        <label for="sel_bankCd" id="lb_bankCd"></label>
                                        <select id="sel_bankCd" name="bankCd">
                                            <option value="00">은행을 선택하세요</option>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>계좌번호</th>
                                <td><span class="intxt wid100p"><input type="text" id="actno" data-name="actno" maxlength="50" data-validation-engine="validate[required, maxSize[50]]"/></span></td>
                            </tr>
                            <tr>
                                <th>예금주</th>
                                <td><span class="intxt wid100p"><input type="text" id="holder" data-name="holder" maxlength="16" data-validation-engine="validate[required, maxSize[16]]"></span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <div class="btn_box txtc">
                    <button type="button" id="submitBtn" class="btn green">등록</button>
                </div>
            </div>
        </div>
        </form>
        <!-- //pop_con -->
    </div>
</div>