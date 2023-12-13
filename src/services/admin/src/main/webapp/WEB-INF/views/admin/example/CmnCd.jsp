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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">공통코드</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {
                
                // 검색
                $('#btn_id_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    jQuery('#form_id_search').submit();
                });
                
                // 상세
                jQuery('#table_id_cmnCdGrp a.btn_normal').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var grpCd = jQuery(this).parents('tr').data('grp-cd');
                    Dmall.FormUtil.submit('/admin/example/common-code-detail', {grpCd : grpCd});
                });
                
                // 등록
                jQuery('#a_id_reg').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerUtil.alert('등록 테스트');
                    jQuery('#form_id_cmnCdGrp')[0].reset();
                    jQuery('#form_id_cmnCdGrp .bind_target').text('');
                    Dmall.FormUtil.setActionTypeInsert('form_id_cmnCdGrp');
                });
                
                // 삭제
                jQuery('#a_id_del').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerUtil.confirm('삭제하시겠습니까?', deleteCmnCdGrp);
                });
                
                // 상세
                jQuery('#tbody_id_cmnCdGrpList a.tbl_link').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var url = '/admin/example/common-group-code',
                            grpCd = jQuery(this).parents('tr').data('grp-cd');
                    Dmall.AjaxUtil.getJSONwoMsg(url, {'grpCd' : grpCd}, function(result) {

                        Dmall.FormUtil.jsonToForm(result.data, 'form_id_cmnCdGrp');
                    });
                });
                
                // 저장
                jQuery('#a_id_cmnCdGrpSave').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if(Dmall.validate.isValid('form_id_cmnCdGrp')) {

                        var url = '/admin/example/insert-group-code',
                            param = jQuery('#form_id_cmnCdGrp').serialize();
                        
                        if(Dmall.FormUtil.getActionType('form_id_cmnCdGrp') === 'UPDATE') {
                            url = '/admin/example/update-group-code';
                        }

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                $('#btn_id_search').trigger('click');
                            }

                            Dmall.validate.viewExceptionMessage(result, 'form_id_cmnCdGrp');
                        });
                    }
                });

                Dmall.validate.set('form_id_cmnCdGrp');
                jQuery('#grid_id_cdGrp').grid(jQuery('#form_id_search'));
            });

            function deleteCmnCdGrp() {
                var url = '/admin/example/delete-group-code',
                    param = {},
                    $selected = jQuery('#table_id_cmnCdGrp tr input[type="checkbox"]:checked'),
                    list = {},
                    grpCd;

                jQuery.each($selected, function(i, o) {
                    grpCd = {'grpCd' : $(o).parents('tr').data('grpCd'), 'name' :  $(o).parents('tr td:eq(2)').text()};
                    param['list[' + i + '].grpCd'] = $(o).parents('tr').data('grpCd');
                });

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        $('#btn_id_search').trigger('click');
                    }
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">공통코드</h2>
                <div class="btn_box left">
                    <a href="#none" class="btn green" id="btn_id_search">검색</a>
                </div>
            </div>
            <!-- search_box -->
            <div class="search_box">
                <!-- search_tbl -->
                <form:form action="/admin/example/common-code-view" id="form_id_search" commandName="cmnCdGrpSO">
                    <input type="hidden" name="_action_type" value="INSERT" />
                    <form:hidden path="page" id="search_id_page" />
                    <form:hidden path="rows" />
                    <input type="hidden" name="sort" value="${cmnCdGrpSO.sort}" />
                    <div class="search_tbl">
                        <table summary="이표는 회원리스트 검색 표 입니다. 구성은 가입일, 최종방문일, 생일, SMS수신, 이메이수신, 회원등급, 구매금액, 마켓포인트, 주문횟수, 댓글횟수, 방문횟수, 성별, 다비치포인트, 가입방법, 검색어 입니다.">
                            <caption>공통코드 관리</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="35%">
                                <col width="15%">
                                <col width="35%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>등록일</th>
                                <td colspan="3">
                                    <tag:calendar from="fromRegDt" to="toRegDt" fromValue="${cmnCdGrpSO.fromRegDt}" toValue="${cmnCdGrpSO.toRegDt}" idPrefix="srch" />
                                </td>
                            </tr>
                            <tr>
                                <th>사용 여부</th>
                                <td>
                                    <tags:radio name="useYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_useYn" value="${cmnCdGrpSO.useYn}" />
                                </td>
                                <th class="line">삭제 여부</th>
                                <td>
                                    <span class="select">
                                        <label></label>
                                        <select name="delYn" id="srch_id_delYn">
                                            <tags:option codeStr=":전체;Y:삭제;N:미삭제" value="${cmnCdGrpSO.delYn}" />
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>코드명</th>
                                <td colspan="3">
                                    <span class="intxt">
                                        <form:input path="grpNm" cssClass="text" cssErrorClass="text medium error" size="40" maxlength="50" placeholder="2자이상" />
                                    </span>
                                    <form:errors path="grpNm" cssClass="errors"  />
                                </td>
                            </tr>
                            <tr>
                                <th>사용자 정의 값 유무</th>
                                <td colspan="3">
                                    <tags:checkbox name="userDefine1Nm" id="srch_id_userDfn_01" value="1" compareValue="${cmnCdGrpSO.userDefine1Nm}" text="사용자정의1" />
                                    <tags:checkbox name="userDefine2Nm" id="srch_id_userDfn_02" value="2" compareValue="${cmnCdGrpSO.userDefine2Nm}" text="사용자정의2" />
                                    <tags:checkbox name="userDefine3Nm" id="srch_id_userDfn_03" value="3" compareValue="${cmnCdGrpSO.userDefine3Nm}" text="사용자정의3" />
                                    <tags:checkbox name="userDefine4Nm" id="srch_id_userDfn_04" value="4" compareValue="${cmnCdGrpSO.userDefine4Nm}" text="사용자정의4" />
                                    <tags:checkbox name="userDefine5Nm" id="srch_id_userDfn_05" value="5" compareValue="${cmnCdGrpSO.userDefine5Nm}" text="사용자정의5" />
                                </td>
                            </tr>
                            </tbody>
                        </table>

                    </div>
                </form:form>
            </div>
            <!-- //line_box -->
            <!-- line_box -->
            <grid:table id="grid_id_cdGrp" so="${cmnCdGrpSO}" resultListModel="${resultListModel}" hasExcel="true" sortOptionStr="">
                <!-- tblh -->
                <div class="tblh">
                    <table summary="공통 코드 그룹 관리"  id="table_id_cmnCdGrp">
                        <caption>공통 코드 그룹</caption>
                        <colgroup>
                            <col width="5%">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>
                                <label for="chack05" class="chack">
                                    <span class="ico_comm"><input type="checkbox" name="table" id="chack05" /></span>
                                </label>
                            </th>
                            <th>그룹 코드</th>
                            <th>그룹 명</th>
                            <th>그룹 설명</th>
                            <th>사용자 정의1 명</th>
                            <th>사용자 정의2 명</th>
                            <th>사용자 정의3 명</th>
                            <th>사용자 정의4 명</th>
                            <th>사용자 정의5 명</th>
                            <th>사용여부</th>
                            <th>삭제여부</th>
                            <th>상세</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_id_cmnCdGrpList">
                        <c:forEach var="grp" items="${resultListModel.resultList}" varStatus="status">
                        <tr data-grp-cd="${grp.grpCd}">
                            <td>
                                <label for="chack05_${status.count}" class="chack">
                                    <span class="ico_comm"><input type="checkbox" name="grpCd" id="chack05_${status.count}" value="${grp.grpCd}" /></span>
                                </label>
                            </td>
                            <td><a href="#none" class="tbl_link">${grp.grpCd}</a></td>
                            <td><a href="#none" class="tbl_link">${grp.grpNm}</a></td>
                            <td>${grp.grpDscrt}</td>
                            <td>${grp.userDefine1Nm}</td>
                            <td>${grp.userDefine2Nm}</td>
                            <td>${grp.userDefine3Nm}</td>
                            <td>${grp.userDefine4Nm}</td>
                            <td>${grp.userDefine5Nm}</td>
                            <td>${grp.useYn}</td>
                            <td>${grp.delYn}</td>
                            <td>
                                <div class="pop_btn">
                                    <a href="#none" class="btn_normal">상세</a>
                                </div>
                            </td>
                        </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->

                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <div class="left">
                        <div class="pop_btn">
                            <a href="#none" class="btn_normal" id="a_id_reg">등록</a>
                            <a href="#none" class="btn_normal" id="a_id_del">삭제</a>
                        </div>
                    </div>
                    <!-- pageing -->
                    <grid:paging resultListModel="${resultListModel}" />
                    <!-- //pageing -->
                </div>
                <!-- //bottom_lay -->
            </grid:table>
            <!-- //line_box -->

        <!-- line_box -->
        <div class="line_box fri">
            <h3 class="tlth3 btn1">공통 코드 그룹 <a href="#none" class="btn_blue">버튼</a></h3>
                <!-- tblw -->
                <form action="/admin/example/insert-group-code" id="form_id_cmnCdGrp">
                <div class="tblw tblmany">
                    <table summary="공통 코드 그룹">
                        <caption>기본정보</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="35%">
                            <col width="15%">
                            <col width="35%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>코드 그룹</th>
                            <td><span class="intxt"><input type="text" name="grpCd" id="input_id_grpCd" data-validation-engine="validate[required, maxSize[50]]" /></span></td>
                            <th class="line">그룹 명</th>
                            <td><span class="intxt"><input type="text" name="grpNm" id="input_id_grpNm" data-validation-engine="validate[maxSize[50]]" /></span></td>
                        </tr>
                        <tr>
                            <th>그룹 설명</th>
                            <td colspan="3">
                                <span class="intxt"><input type="text" name="grpDscrt" id="input_id_grp_dscrt" data-validation-engine="validate[maxSize[500]]" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>사용자정의1명</th>
                            <td>
                                <span class="intxt"><input type="text" name="userDefine1Nm" id="input_id_userDefine1Nm" data-validation-engine="validate[maxSize[50]]" /></span>
                            </td>
                            <th class="line">사용자정의2명</th>
                            <td>
                                <span class="intxt"><input type="text" name="userDefine2Nm" id="input_id_userDefine2Nm" data-validation-engine="validate[maxSize[50]]" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>사용자정의3명</th>
                            <td>
                                <span class="intxt"><input type="text" name="userDefine3Nm" id="input_id_userDefine3Nm" data-validation-engine="validate[maxSize[50]]" /></span>
                            </td>
                            <th class="line">사용자정의4명</th>
                            <td>
                                <span class="intxt"><input type="text" name="userDefine4Nm" id="input_id_userDefine4Nm" data-validation-engine="validate[maxSize[50]]" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>사용자정의5명</th>
                            <td colspan="3">
                                <span class="intxt"><input type="text" name="userDefine5Nm" id="input_id_userDefine5Nm" data-validation-engine="validate[maxSize[50]]" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>사용여부</th>
                            <td>
                                <tags:radio name="useYn" codeStr="Y:사용;N:미사용" idPrefix="radio_id_useYn" />
                                <%--<tags:checkboxs name="useYn" codeStr="Y:사용;N:미사용" idPrefix="radio_id_useYn" validator="validate[required]" />--%>
                            </td>
                            <th>삭제여부</th>
                            <td class="line">
                                <span class="select">
                                    <label></label>
                                    <select id="radio_id_delYn" name="delYn">
                                        <tags:option codeStr=":선택하세요;Y:삭제;N:정상" />
                                    </select>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>등록일자</th>
                            <td id="bind_target_id_regDttm" class="bind_target"></td>
                            <th>등록자</th>
                            <td id="bind_target_id_regrNo" class="bind_target"></td>
                        </tr>
                        <tr>
                            <th>수정일자</th>
                            <td id="bind_target_id_updDttm" class="bind_target"></td>
                            <th>수정자</th>
                            <td id="bind_target_id_updrNo" class="bind_target"></td>
                        </tr>
                        <tr>
                            <th>삭제일자</th>
                            <td id="bind_target_id_delDttm" class="bind_target"></td>
                            <th>삭제자</th>
                            <td id="bind_target_id_delNo" class="bind_target"></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                </form>
                <div class="btn_box right">
                    <a href="#none" class="btn blue shot" id="a_id_cmnCdGrpSave">저장</a>
                </div>
            </div>
        </div>

    </t:putAttribute>
</t:insertDefinition>
