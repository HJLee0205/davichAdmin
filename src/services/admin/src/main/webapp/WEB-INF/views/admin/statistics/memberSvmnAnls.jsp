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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">회원 분석</t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/js/Chart2.1.4.js"></script>
        <script>
            jQuery(document).ready(function() {
                // 검색일자 기본값 선택
                jQuery('#btn_srch_cal_1').trigger('click');
             
                jQuery("#search_id_page").val("1");
                memberSvmnSet.getMemberSvmnList();
            });
            
            //조회
            jQuery('#btn_id_search').on('click', function(e){
                jQuery("#search_id_page").val("1");
                memberSvmnSet.getMemberSvmnList();
            });
            var memberSvmnSet = {
                    memberSvmnAnlsList : [],
                    getMemberSvmnList : function() {
                        
                        setDefaultValue();
                        
                        var url = "/admin/statistics/savedmoney-analysis",dfd = jQuery.Deferred();
                        
                        // 파라미터 값 셋팅
                        if(setSubmitValue() == false){
                            return;
                        }
                        
                        var param = jQuery("#form_id_search").serialize();
                        
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            var template = "", totalTr= "", tr = "";

                            template = "<tr data-rank='{{rank}}' data-member-nm= '{{memberNm}}' data-member-id='{{memberId}}' data-pvd-svmn-cnt='{{pvdSvmnCnt}}' data-pvd-svmn='{{pvdSvmn}}' data-use-svmn-cnt='{{useSvmnCnt}}' data-use-svmn='{{useSvmn}}' data-cancel-svmn-cnt='{{cancelSvmnCnt}}' data-cancel-svmn='{{cancelSvmn}}' data-remain-svmn='{{remainSvmn}}'>"+
                                       "<td class='bgray'>{{rank}}</td><td class='bgray'>{{memberNm}}</td><td class='bgray'>{{memberId}}</td><td>{{pvdSvmnCnt}}</td><td>{{pvdSvmn}}</td><td>{{useSvmnCnt}}</td><td>{{useSvmn}}</td><td>{{cancelSvmnCnt}}</td><td>{{cancelSvmn}}</td><td>{{remainSvmn}}</td>";
                            
                            var managerGroup = new Dmall.Template(template);
                                
                            var vstrCntSum = 0;
                            var rtoSum = 0;
                            var cnt = 0;
                            
                            jQuery.each(result.resultList, function(idx, obj) {
                                tr += managerGroup.render(obj)
                            });
                            
                            if(result.extraData.resultListTotalSum.length > 0){
                                totalTr = "<tr><td>" + result.extraData.resultListTotalSum[0].totPvdSvmnCnt + "</td>" +
                                          "<td>"+ result.extraData.resultListTotalSum[0].totPvdSvmn +"</td>"+
                                          "<td>"+ result.extraData.resultListTotalSum[0].totUseSvmnCnt +"</td>"+
                                          "<td>"+ result.extraData.resultListTotalSum[0].totUseSvmn +"</td>"+
                                          "<td>"+ result.extraData.resultListTotalSum[0].totCancelSvmnCnt +"</td>"+
                                          "<td>"+ result.extraData.resultListTotalSum[0].totCancelSvmn +"</td>"+
                                          "<td>"+ result.extraData.resultListTotalSum[0].totRemainSvmn +"</td></tr>";
                            }else{
                                totalTr = "<tr><td colspan='7'>데이터가 없습니다.</td></tr>";
                            }
                            
                            if(tr == "") {
                                tr = "<tr><td colspan='10'>데이터가 없습니다.</td></tr>";
                            }else{
                                // 회원 마켓포인트 분석결과 합계
                                tr += "<tr><td class='bbray'>합계</td><td class='bbray'></td><td class='bbray'></td>"+
                                      "<td class='bbray'>"+ result.extraData.resultListSum[0].totPvdSvmnCnt + "</td>" +
                                      "<td class='bbray'>"+ result.extraData.resultListSum[0].totPvdSvmn + "</td>" +
                                      "<td class='bbray'>"+ result.extraData.resultListSum[0].totUseSvmnCnt + "</td>" +
                                      "<td class='bbray'>"+ result.extraData.resultListSum[0].totUseSvmn+ "</td>" +
                                      "<td class='bbray'>"+ result.extraData.resultListSum[0].totCancelSvmnCnt + "</td>" +
                                      "<td class='bbray'>"+ result.extraData.resultListSum[0].totCancelSvmn+ "</td>" +
                                      "<td class='bbray'>"+ result.extraData.resultListSum[0].totRemainSvmn+ "</td></tr>";
                            }
                            
                            jQuery("#tbody_id_memberSvmnAnlsTotalSum").html(totalTr);
                            jQuery("#tbody_id_memberSvmnAnlsList").html(tr);
                            
                            memberSvmnSet.memberSvmnAnlsList = result.resultList;
                            dfd.resolve(result.resultList);
                            
                            Dmall.GridUtil.appendPaging("form_id_search", "div_id_paging", result, "paging_id_memberSvmn", memberSvmnSet.getMemberSvmnList);
                        });
                        
                        return dfd.promise();
                    }
            }
            
            //검색 타입 변경시 텍스트 입력 설정 변경(한글/영문/숫자 입력 제한)
            jQuery('#srch_id_searchType').change(function(e){
                jQuery('#searchWords').remove();
                var inputText = '';
                if(jQuery(this).val() == 'all' || jQuery(this).val() == 'name'){
                    inputText = '<input type="text" id="searchWords" name="searchWords" class="text" size="40" maxlength="50" >'
                }else if(jQuery(this).val() == 'id' || jQuery(this).val() == 'email'){
                    inputText = '<input type="text" id="searchWords" name="searchWords" class="text" size="40" maxlength="50" onkeyup="onlyHan(this);" style="ime-mode:disabled;">'
                }else if(jQuery(this).val() == 'tel' || jQuery(this).val() == 'mobile'){
                    inputText = '<input type="text" id="searchWords" name="searchWords" class="text" size="40" maxlength="50" onkeypress="return onlyNumber(event, \'numbers\');" onkeyup="onlyHan(this);" style="ime-mode:disabled;" >'
                }
                
                jQuery('#searchDiv').append(inputText);
            });
            
            // 서버에 보낼 파라미터 값 셋팅
            function setSubmitValue(){
                var srch_sc01 = jQuery("#srch_sc01").val();
                var srch_sc02 = jQuery("#srch_sc02").val();
                
                if(srch_sc01.replace(/-/gi, "") > srch_sc02.replace(/-/gi, "")){
                    Dmall.LayerUtil.alert('기간검색 시작 날짜가 종료 날짜보다 큽니다.');
                    return false;
                }else{
                    // 3개월 이상 체크
                    if(srch_sc01 != "" && srch_sc02 != ""){
                        var sc01Array = srch_sc01.split("-");
                        var sc02Array = srch_sc02.split("-");
                        var sc02Sum = Number(sc02Array[1]) - 3;
                        var sc01Re = "";
                        var sc01Sum = "";
                        var year = "";
                    
                        if(sc02Sum == 0){
                            sc01Sum = "12";
                            year = Number(sc02Array[0]) - 1;
                        }else if(sc02Sum == -1){
                            sc01Sum = "11";
                            year = Number(sc02Array[0]) - 1;
                        }else if(sc02Sum == -2){
                            sc01Sum = "10";
                            year = Number(sc02Array[0]) - 1;
                        }else{
                            sc01Sum = "0" + sc02Sum;
                        }
                    
                        sc01Re = year + "-" + sc01Sum + "-" + sc02Array[2];
                        
                        if(sc01Re.replace(/-/gi, "") > srch_sc01.replace(/-/gi, "")){
                            Dmall.LayerUtil.alert('3개월 이상은 입력할 수 없습니다.');
                            return false;
                        }
                    }
                }
                
                
                // 기간
                jQuery("#stDt").val(srch_sc01);
                jQuery("#endDt").val(srch_sc02);
                
                return true;
            }
            
            // 페이징 관련 초기화
            function setDefaultValue() {
                jQuery('#hd_srod').val(jQuery('#sel_sord').val());
                jQuery('#hd_rows').val(jQuery('#sel_rows').val());
            }
            
            // 정렬순서 변경 변경시 이벤트
            jQuery('#sel_sord').on('change', function(e) {
                jQuery('#hd_srod').val($(this).val());
                memberSvmnSet.getMemberSvmnList();
            });
            
            // 표시갯수 변경 변경시 이벤트
            jQuery('#sel_rows').on('change', function(e) {
                jQuery('#hd_page').val('1');
                jQuery('#hd_rows').val($(this).val());
                memberSvmnSet.getMemberSvmnList();
            });
            
            // 엑셀다운로드
            jQuery(".btn_exl").on("click", function(){
                // 파라미터 값 셋팅
                if(setSubmitValue() == false){
                    return;
                }
                
                jQuery('#form_id_search').attr('action', '/admin/statistics/savedmoney-excel-download');
                jQuery('#form_id_search').submit();
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">회원 마켓포인트 분석</h2>

            </div>
            <!-- search_box -->
            <div class="search_box">
                <!-- search_box -->
                <form:form action="/admin/statistics/savedmoney-analysis" id="form_id_search" commandName="memberSvmnSO">
                    <input type="hidden" name="periodGb" id="periodGb"/>
                    <input type="hidden" name="stDt" id="stDt"/>
                    <input type="hidden" name="endDt" id="endDt"/>
                    <input type="hidden" name="page" id="hd_page" value="1" />
                    <input type="hidden" name="sord" id="hd_srod" value="" />
                    <input type="hidden" name="rows" id="hd_rows" value="" />
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 회원 마켓포인트 분석표 입니다. 구성은 일별, 월별등의 기간검색 입니다.">
                                <caption>방문자 분석 기간검색</caption>
                                <colgroup>
                                    <col width="15%">
                                    <col width="85%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>기간검색</th>
                                        <td id="selectId">
                                            <tags:calendar idPrefix="srch" to="searchDateTo" from="searchDateFrom" hasTotal="false"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>검색어</th>
                                        <td>
                                            <div class="select_inp" id="searchDiv">
                                                <span>
                                                    <label for="">전체</label>
                                                    <select name="searchType" id=srch_id_searchType>
                                                        <tags:option codeStr="all:전체;name:이름;id:아이디;email:이메일;tel:전화번호;mobile:핸드폰번호"></tags:option>
                                                    </select>
                                                </span>
                                                <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="40" maxlength="50" />
                                                <form:errors path="searchWords" cssClass="errors"  />
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" type="button" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </div>
                </form:form>
            </div>
        
        
            <!-- line_box -->
            <div class="line_box">
                <div class="tab-2con">
                    <h3 class="tlth3">전체회원 마켓포인트 분석결과</h3>
                    <!-- tblh -->
                    <div class="tblh th_l tblmany">
                        <table summary="이표는 전체회원 마켓포인트 분석결과 표 입니다. 구성은 총지급 마켓포인트, 총사용 마켓포인트, 총잔여 마켓포인트 입니다.">
                            <caption>지역별 회원분석 리스트</caption>
                            <colgroup>
                                <col width="13%">
                                <col width="13%">
                                <col width="13%">
                                <col width="13%">
                                <col width="13%">
                                <col width="13%">
                                <col width="22%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th colspan="2" class="line_b">총 지급 마켓포인트</th>
                                    <th colspan="2" class="line_b">총 사용 마켓포인트</th>
                                    <th colspan="2" class="line_b">총 취소 마켓포인트</th>
                                    <th class="line_b">총 잔여 마켓포인트</th>
                                </tr>
                                <tr>
                                    <th>건수</th>
                                    <th>금액</th>
                                    <th>건수</th>
                                    <th>금액</th>
                                    <th>건수</th>
                                    <th>금액</th>
                                    <th>금액</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_id_memberSvmnAnlsTotalSum">
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <h3 class="tlth3" style="float:left;">회원 마켓포인트 분석결과</h3>
                    <div class="top_lay">
                        <div class="select_btn">
                            <span class="select">
                                <label for="sel_sord"></label>
                                <select name="sord" id="sel_sord">
                                    <tags:option codeStr="A.PVD_SVMN DESC:지급마켓포인트▽;A.USE_SVMN DESC:사용마켓포인트▽;A.REMAIN_SVMN DESC:잔여마켓포인트▽" />
                                </select>
                            </span>
                            <span class="select">
                                <label for="sel_rows"></label>
                                <select name="rows" id="sel_rows">
                                    <tags:option codeStr="10:10개 출력;50:50개 출력;100:100개 출력;200:200개 출력" />
                                </select>
                            </span>
                            <button class="btn_exl">Excel download <span class="ico_comm">&nbsp;</span></button>
                        </div>
                    </div>
                </div>
                <div style="clear:both;"></div>
                <!-- tblh -->
                <div class="tblh th_l tblmany">
                    <table summary="이표는 회원 마켓포인트 표 입니다. 구성은 순위,이름,아이디,지급마켓포인트, 사용마켓포인트, 잔여마켓포인트 입니다.">
                        <caption>회원 마켓포인트 리스트</caption>
                        <colgroup>
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th rowspan="2">순위</th>
                                <th rowspan="2">이름</th>
                                <th rowspan="2">아이디</th>
                                <th colspan="2" class="line_b">지급 마켓포인트</th>
                                <th colspan="2" class="line_b">사용 마켓포인트</th>
                                <th colspan="2" class="line_b">취소 마켓포인트</th>
                                <th class="line_b">잔여 마켓포인트</th>
                            </tr>
                            <tr>
                                <th class="line_l">건수</th>
                                <th>금액</th>
                                <th>건수</th>
                                <th>금액</th>
                                <th>건수</th>
                                <th>금액</th>
                                <th>금액</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_id_memberSvmnAnlsList">
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <!-- pageing -->
                    <div class="pageing" id="div_id_paging"></div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>