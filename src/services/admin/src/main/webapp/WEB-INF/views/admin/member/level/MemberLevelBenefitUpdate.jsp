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
    <t:putAttribute name="title">회원 등급별 혜택 관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            jQuery(document).ready(function() {
                
                //숫자, 하이폰(-) 만 입력가능
                $(document).on("keyup", "input:text[datetimeOnly]", function() {$(this).val( $(this).val().replace(/[^0-9\-]/gi,"") );});
                //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
                //영문만 입력가능
                $(document).on("keyup", "input:text[engOnly]", function() {$(this).val( $(this).val().replace(/[^\!-z]/g,"") );});
                
                // 게시글 목록 화면 이동
                Dmall.validate.set('formMemberBebefitUpdate');
                
                // 할인 종류 변경
                jQuery("select[name = 'arrDcUnitCd']").change(function(e) {
                    jQuery(this).closest('.txtl').children('.shot').children().val("");
                    if(jQuery(this).val()=="1"){
                        jQuery(this).closest('.txtl').children('.shot').children().attr('maxlength','2');
                    }else{
                        jQuery(this).closest('.txtl').children('.shot').children().attr('maxlength','8');
                    }
                });
             
                // 저장
                jQuery('#memberBenefitUpdate').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    if(Dmall.validate.isValid('formMemberBebefitUpdate')) {
                        var url = '/admin/member/level/membergrade-benefit-update';
                        var param = jQuery('#formMemberBebefitUpdate').serialize();
    
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formMemberBebefitUpdate');
                            if(result.success){
                                var param = {}
                                Dmall.FormUtil.submit('/admin/member/level/membergrade-benefit', param);
                            }
                        });
                    }
                });
                
                // 구매혜택 리스트
                jQuery('#memberBenefitMain').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    var param = {}
                    Dmall.FormUtil.submit('/admin/member/level/membergrade-benefit', param);
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
        <div class="tlt_box">
            <div class="btn_box left">
                <a href="#none" class="btn gray" id="memberBenefitMain">구매혜택 리스트</a>
            </div>
            <h2 class="tlth2">회원등급별 구매혜택 수정 </h2>
            <div class="btn_box right">
                <a href="#none" class="btn blue" id ="memberBenefitUpdate" >저장하기</a>
            </div>
        </div>
        <form action="" id="formMemberBebefitUpdate">
        <!-- line_box -->
        <div class="line_box fri">
            <!-- tblh -->
            <div class="tblh th_l">
                <table summary="이표는 회원등급별 구매혜택 추가 표 입니다. 구성은 등급종류, 등급(플래티넘, 골드, 실버, 브론즈) 입니다.">
                    <caption>회원등급별 구매혜택 추가</caption>
                    <colgroup>
                        <col width="10%">
                        <col width="10%">
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                        <col width="20%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="2" rowspan="2">등급종류</th>
                            <th>할인<input type ="hidden" id = "memberGradeBnfNo" name = "memberGradeBnfNo" value= "${so.memberGradeBnfNo}">
                                   <input type ="hidden" id = "useYn" name = "useYn" value= "${so.useYn}">
                            </th>
                            <th>마켓포인트</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var = "gradeList" items="${memGradeBenefitList}" varStatus="status">
                        <tr>
                        <c:if test="${status.index eq 0}">
                            <th rowspan="${fn:length(memGradeBenefitList)}">등급</th>
                        </c:if>
                                <th>${gradeList.memberGradeNm}</th>
                                <td class="txtl">
                                    <span class="intxt shot">
                                    <c:if test="${gradeList.dcUnitCd ne '2'}">
                                    <input type="text" value="${gradeList.dcValue}" id="arrDcValue" name = "arrDcValue" class="txtr" maxlength="2" numberOnly="true" style="ime-mode:disabled;" />
                                    </c:if>
                                    <c:if test="${gradeList.dcUnitCd eq '2'}">
                                    <input type="text" value="${gradeList.dcValue}" id="arrDcValue" name = "arrDcValue" class="txtr" maxlength="8" numberOnly="true" style="ime-mode:disabled;" />
                                    </c:if>
                                    </span>
                                    <span class="select one">
                                        <c:if test="${gradeList.dcUnitCd ne '2'}">
                                        <label for="">%</label>
                                        <select name="arrDcUnitCd" id="arrDcUnitCd">
                                            <option value="1" selected>%</option>
                                            <option value="2">원</option>
                                        </select>
                                        </c:if>
                                        <c:if test="${gradeList.dcUnitCd eq 2}">
                                        <label for="">원</label>
                                        <select name="arrDcUnitCd" id="arrDcUnitCd">
                                            <option value="1">%</option>
                                            <option value="2" selected>원</option>
                                        </select>
                                        </c:if>
                                    </span>
                                    할인
                                </td>
                                <td class="txtl">
                                    <span class="intxt shot"><input type="text" value="${gradeList.svmnValue}" id="arrSvmnValue" name = "arrSvmnValue"class="txtr" maxlength="2" numberOnly="true" style="ime-mode:disabled;" /></span>
                                    <input type ="hidden" id = "arrMemberGradeNo" name = "arrMemberGradeNo" value= "${gradeList.memberGradeNo}">
                                    <input type ="hidden" id = "arrSvmnUnitCd" name = "arrSvmnUnitCd" value= "11">
                                    <input type ="hidden" id = "arrChk" name = "arrChk" value= "${gradeList.chk}">
                                    % 적립
                                </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <!-- //tblh -->
            <!-- <div class="btn_box txtc">
                <button class="btn green">확인</button>
            </div> -->
        </div>
        <!-- //line_box -->
        </form>
    </div>
    </t:putAttribute>
</t:insertDefinition>