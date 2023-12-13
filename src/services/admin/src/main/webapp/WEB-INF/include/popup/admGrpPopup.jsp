<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="layer_id_admin" class="layer_popup">
    <div class="pop_wrap size3">
        <div class="pop_tlt">
            <h2 class="tlth2" id="admin_auth_pop_title">관리자 그룹 추가</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <div class="pop_con">
            <div>
                <form id="form_id_managerGrp">
                    <input type="hidden" name="authGrpNo" id="input_id_authGrpNo"/>
                    <input type="hidden" name="check" id="input_id_checked"/>
                    <div class="tblw mt0">
                        <table summary="이표는 관리자 그룹 추가 표 입니다. 구성은  입니다.">
                            <caption>관리자 그룹 추가</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>그룹명</th>
                                <td>
                                    <span class="intxt"><input type="text" name="authNm" id="input_id_authNm"></span>
                                    <button class="btn_gray" id="btn_id_checkDuplication">중복확인</button>
                                </td>
                            </tr>
                            <tr>
                                <th>그룹소속인원</th>
                                <td>
                                    <span id="span_id_cnt"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>관리권한 설정</th>
                                <td>
                                    <label for="input_id_super" class="chack mr20" id="label_id_super">
                                        <span class="ico_comm"><input type="checkbox" name="menuId" id="input_id_super" class="blind" value="A"></span>
                                        슈퍼관리자 (전체관리자에게만 부여됩니다.)
                                    </label>
                                    <span class="br2"></span>
                                    <c:forEach var="m" items="${MENU}" varStatus="status" >
                                        <label for="chack_${status.count}" class="chack mr20">
                                            <span class="ico_comm"><input type="checkbox" name="menuId" id="chack_${status.count}" value="${m.menuId}" /></span>
                                            <c:out value="${m.menuNm}" />
                                        </label>
                                    </c:forEach>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </form>
                <div class="btn_box txtc">
                    <button class="btn green" id="btn_id_saveManagerAuthGrp">저장</button>
                </div>
            </div>
        </div>
    </div>
</div>