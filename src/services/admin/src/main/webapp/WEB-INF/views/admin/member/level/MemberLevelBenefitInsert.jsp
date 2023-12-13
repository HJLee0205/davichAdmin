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
                Dmall.validate.set('formMemberBebefitInsert');
                
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
                jQuery('#memberBenefitInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    if(Dmall.validate.isValid('formMemberBebefitInsert')) {
                        var url = '/admin/member/level/mambergrade-benefit-insert';
                        var param = jQuery('#formMemberBebefitInsert').serialize();
    
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formMemberBebefitInsert');
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
            <h2 class="tlth2">회원등급별 구매혜택 추가</h2>
            <div class="btn_box right">
                <a href="#none" class="btn blue" id ="memberBenefitInsert" >저장하기</a>
            </div>
        </div>
        <form action="" id="formMemberBebefitInsert">
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
                            <th>할인</th>
                            <th>마켓포인트</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var = "gradeList" items="${resultModel.resultList}" varStatus="status">
                        <tr>
                        <c:if test="${status.index eq 0}">
                            <th rowspan="${fn:length(resultModel.resultList)}">등급</th>
                        </c:if>
                                <th>${gradeList.memberGradeNm}</th>
                                <td class="txtl">
                                    <span class="intxt shot"><input type="text" value="" id="arrDcValue_${gradeList.memberGradeNo}" name = "arrDcValue" class="txtr" maxlength="2" numberOnly="true" style="ime-mode:disabled;" /></span>
                                    <span class="select one">
                                        <label for="">%</label>
                                        <select name="arrDcUnitCd" id="arrDcUnitCd">
                                            <option value="1">%</option>
                                            <option value="2">원</option>
                                        </select>
                                    </span>
                                    할인
                                </td>
                                <td class="txtl">
                                    <span class="intxt shot"><input type="text" value="" id="arrSvmnValue_${gradeList.memberGradeNo}" name = "arrSvmnValue"class="txtr" maxlength="2" numberOnly="true" style="ime-mode:disabled;" /></span>
                                    <input type ="hidden" id = "arrMemberGradeNo" name = "arrMemberGradeNo" value= "${gradeList.memberGradeNo}">
                                    <input type ="hidden" id = "arrSvmnUnitCd" name = "arrSvmnUnitCd" value= "11">
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