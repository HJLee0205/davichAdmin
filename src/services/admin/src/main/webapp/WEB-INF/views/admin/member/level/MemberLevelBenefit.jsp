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
    <t:putAttribute name="title">회원등급별 혜택</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                // 등록 화면
                jQuery('#viewMemberLevelBenefitInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var param = {}
                    Dmall.FormUtil.submit('/admin/member/level/membergradebenefit-insert-form', param);
                });
                
                jQuery("input[name = 'memberGradeBnfNo']").change(function(e) {
                    var memberGradeBnfNo = this.value;
                    Dmall.LayerUtil.confirm("사용여부를 수정 하시겠습니까?",
                        function() {
                             var url = '/admin/member/level/membergrade-use-update';
                             var param = {memberGradeBnfNo:memberGradeBnfNo};
                             
                             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                             
                             }); 
                        }, 
                        function(){
                            var param = {}
                            Dmall.FormUtil.submit('/admin/member/level/membergrade-benefit', param);
                        })
                });
            });
            
            function viewMemberLevelBenefitUpdate(memberGradeBnfNo, useYn){
                var param = {memberGradeBnfNo : memberGradeBnfNo, useYn:useYn}
                Dmall.FormUtil.submit('/admin/member/level/membergradebenefit-update-form', param);
            }
            
            function memberLevelBenefitDelete(memberGradeBnfNo, memberGradeNo){
                var url = '/admin/member/level/mambergrade-benefit-delete';
                var param = {memberGradeBnfNo : memberGradeBnfNo, memberGradeNo: memberGradeNo};
                
                Dmall.LayerUtil.confirm("삭제 하시겠습니까?", function() {
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            var param = {}
                            Dmall.FormUtil.submit('/admin/member/level/membergrade-benefit', param);
                        }
                    });
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">회원등급별 구매혜택 </h2>
                <div class="btn_box right">
                    <a href="#none" id="viewMemberLevelBenefitInsert"  class="btn blue">할인혜택 추가하기</a>
                </div>
            </div>
           
            <!-- line_box -->
            <div class="line_box fri">
                 <c:forEach var = "gradeBenefitGrpList" items="${memGradeBenefitGrpList}" varStatus="statusGrp">
                <!-- tblh -->
                <div class="tblh thcol th_l tblmany">
                    <table summary="이표는 회원등급별 구매혜택 표 입니다. 구성은 등급종류, 등급(플래티넘, 골드, 실버, 브론즈) 입니다.">
                        <caption>회원등급별 구매혜택</caption>
                        <colgroup>
                            <col width="4%">
                            <col width="16%">
                            <col width="16%">
                            <col width="17%">
                            <col width="17%">
                            <col width="6%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th rowspan="2" class="borbno">
                                    <c:if test="${gradeBenefitGrpList.useYn eq 'Y'}">
                                        <label for="radio01" class="radio on"><span class="ico_comm"><input type="radio" name="memberGradeBnfNo" id="memberGradeBnfNo_Y" value="${gradeBenefitGrpList.memberGradeBnfNo}" checked="checked"></span> </label>
                                    </c:if>
                                    <c:if test="${gradeBenefitGrpList.useYn ne 'Y'}">
                                        <label for="radio01" class="radio"><span class="ico_comm"><input type="radio" name="memberGradeBnfNo" id="memberGradeBnfNo_N" value="${gradeBenefitGrpList.memberGradeBnfNo}" checked="checked"></span> </label>
                                    </c:if>
                                </th>
                                <th colspan="2" rowspan="2">등급종류</th>
                                <th>할인</th>
                                <th>마켓포인트</th>
                                <th rowspan="2">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var = "gradeBenefitList" items="${gradeBenefitGrpList.memGradeBenefitList}" varStatus="status">
                            <tr>
                                <c:if test="${status.index eq 0}">
                                    <th rowspan="${fn:length(gradeBenefitGrpList.memGradeBenefitList)}"></th>
                                    <th rowspan="${fn:length(gradeBenefitGrpList.memGradeBenefitList)}">등급</th>
                                </c:if>
                                <th class="line_l">${gradeBenefitList.memberGradeNm}</th>
                                <td class="txtl">${gradeBenefitList.dcValueText}</td>
                                <td class="txtl">${gradeBenefitList.svmnValueText}</td>
                                <c:if test="${statusGrp.index eq 0}">
                                    <c:if test="${status.index eq 0}">
                                        <td rowspan="${fn:length(gradeBenefitGrpList.memGradeBenefitList)}">
                                            <a href="#none" class="btn_gray" onclick = "viewMemberLevelBenefitUpdate('${gradeBenefitList.memberGradeBnfNo}','${gradeBenefitList.useYn}')">수정</a>
                                        </td>
                                    </c:if>
                                </c:if>
                                <c:if test="${statusGrp.index ne 0}">
                                    <c:if test="${status.index eq 0}">
                                        <td rowspan="${fn:length(gradeBenefitGrpList.memGradeBenefitList)}">
                                            <a href="#none" class="btn_blue" onclick = "viewMemberLevelBenefitUpdate('${gradeBenefitList.memberGradeBnfNo}','${gradeBenefitList.useYn}')">수정</a>
                                                        <span class="br2"></span>
                                            <a href="#none" class="btn_gray" onclick = "memberLevelBenefitDelete(${gradeBenefitList.memberGradeBnfNo})">삭제</a>
                                        </td>
                                    </c:if>   
                                </c:if>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                </c:forEach>
            </div>
            <!-- //line_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>
