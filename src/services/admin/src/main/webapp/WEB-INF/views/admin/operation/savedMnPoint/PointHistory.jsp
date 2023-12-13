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
<%-- <%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %> --%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">포인트 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                pointSet.getPointList();
                // 검색
                jQuery('#btn_id_search').on('click', function(e){
                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm > toDttm){
                        Dmall.LayerUtil.alert('발생일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }
                    
                    jQuery("#hd_page").val("1");
                    pointSet.getPointList();
                });
                
                jQuery('#sel_rows').on('change', function(e) {
                    jQuery('#hd_page').val('1');
                    
                    pointSet.getPointList();
                });
                jQuery('#sel_sord').on('change', function(e) {
                    jQuery('#hd_srod').val($(this).val());
                    pointSet.getPointList();
                });
                
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', pointSet.getPointList);
                
                Dmall.common.comma();
            });
            
            var pointSet = {
                pointList : [],
                getPointList : function() {
                    var url = '/admin/operation/savedMnPoint/point',dfd = jQuery.Deferred();
                    var param = jQuery('#form_id_search').serialize();
    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template = 
                            '<tr data-bbs-id = "{{memberNo}}" data-bbs-nm="{{loginId}}">'+
                            '<td>{{rowNum}}</td><td>{{memberNm}}</td><td>{{loginId}}</td><td>{{content}}</td>' +
                            '<td><span class="{{classNm}}">{{pointType}}</span><span class="comma">{{prcPoint}}</span></td><td>{{regDttm}}</td><td>{{pointTypeNm}}</td>';
                            managerGroup = new Dmall.Template(template),
                                tr = '';
    
                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += managerGroup.render(obj)
                        });
    
                        if(tr == '') {
                            tr = '<tr><td colspan="12">데이터가 없습니다.</td></tr>';
                        }
                        jQuery('#tbody_id_pointList').html(tr);
                        pointSet.pointList = result.resultList;
                        dfd.resolve(result.resultList);
                        
                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_point', pointSet.getPointList);
                        
                        $("#a").text(result.filterdRows);
                        $("#b").text(result.totalRows);
                        
                        Dmall.common.comma();
                    });
    
                    var url = '/admin/operation/savedMnPoint/total-point',dfd = jQuery.Deferred();
                    var param = jQuery('#form_id_search').serialize();
                    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        jQuery('#totalPointPvd').text(result.data.totalPointPvd+'P');
                        jQuery('#totalPointUse').text(result.data.totalPointUse+'P');
                    });
                    
                    return dfd.promise();
                } 
            } 
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">포인트 관리 </h2>
            </div>
            <!-- search_box -->
            <form id="form_id_search" >
            <input type="hidden" name="page" id="hd_page" value="1" />
            <input type="hidden" name="sord" id="hd_srod" value="" />
            <input type="hidden" name="rows" id="hd_rows" value="" />
                 <div class="search_box">
                     <!-- search_tbl -->
                     <div class="search_tbl">
                         <table summary="이표는 마켓포인트 관리 검색 표 입니다. 구성은 발생일, 검색어 입니다.">
                             <caption>마켓포인트 관리 검색</caption>
                             <colgroup>
                                 <col width="15%">
                                 <col width="85%">
                             </colgroup>
                             <tbody>
                                <tr>
                                    <th>발생일</th>
                                    <td>
                                        <tags:calendar from="stRegDttm" to="endRegDttm"  fromValue="" toValue="" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <tags:radio name="pointGbCd" codeStr=":전체;10:지급;20:차감" idPrefix="srch_id_svmnTypeCd" value="" />
                                    </td>
                                </tr>
                                <tr>
                                     <th>검색어</th>
                                     <td>
                                         <div class="select_inp">
                                             <span>
                                                 <label for="select1"></label>
                                                 <select name="searchKind" id="searchKind" >
                                                     <option value="searchMemberNm">회원 명 </option>
                                                     <option value="searchLoginId">회원 아이디 </option>
                                                 </select>
                                             </span>
                                             <input type="text"  name="searchVal" id="searchVal" />
                                         </div>
                                     </td>
                                 </tr>
                             </tbody>
                         </table>
                        
                     </div>
                     <div class="btn_box txtc">
                         <a href="#none" class="btn green" id="btn_id_search">검색</a>
                     </div>
                 </div>
     
                 <!-- line_box -->
                 <div class="line_box">
                     <!-- tblw -->
                     <div class="tblw tblmany2">
                         <table summary="이표는 포인트 관리 리스트 표 입니다. 구성은 총 마켓포인트, 총 사용액  입니다.">
                             <caption>포인트 관리 리스트</caption>
                             <colgroup>
                                 <col width="15%">
                                 <col width="35%">
                                 <col width="15%">
                                 <col width="35%">
                             </colgroup>
                             <tbody>
                                 <tr>
                                     <th>총 포인트지급액</th>
                                     <td id = "totalPointPvd"></td>
                                     <th>총 사용액</th>
                                     <td id = "totalPointUse"></td>
                                 </tr>
                             </tbody>
                         </table>
                     </div>
                     <!-- //tblw -->
                              
                     <div class="top_lay">
                        <div class="search_txt">
                            검색 <strong class="be" id = "a"></strong>개 /
                            총 <strong class="all" id = "b"></strong>개
                        </div>
                        <div class="select_btn">
                            <span class="select">
                                <label for="sel_sord"></label>
                                <select name="selSord" id="sel_sord">
                                    <tags:option codeStr="A.REG_DTTM ASC:최근 등록일 순▽;A.REG_DTTM DESC:나중 등록일 순△" />
                                </select>
                            </span>
                            <span class="select">
                               <label for="select1"></label>
                               <select name="rows" id="sel_rows">
                                   <tags:option codeStr="10:10개 출력;20:20개 출력;50:50개 출력" />
                               </select>
                            </span>
                        </div>
                     </div>
     
                     <!-- tblh -->
                     <div class="tblh th_l">
                         <table summary="게시판 리스트"  id="table_id_pointList">
                             <caption>게시판 리스트</caption>
                             <colgroup>
                                 <col width="6%">
                                 <col width="8%">
                                 <col width="10%">
                                 <col width="46%">
                                 <col width="10%">
                                 <col width="10%">
                                 <col width="10%">
                             </colgroup>
                             <thead>
                                 <tr>
                                     <th>번호</th>
                                     <th>회원명</th>
                                     <th>회원아이디</th>
                                     <th>내용</th>
                                     <th>포인트</th>
                                     <th>발생일</th>
                                     <th>상태</th>
                                 </tr>
                             </thead>
                             <tbody id="tbody_id_pointList">
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
                     <!-- //tblh -->
                     <!-- pageing -->
                     <%-- <grid:paging resultListModel="${resultListModel}" /> --%>
                     <div class="bottom_lay" id="div_id_paging"></div>
                     <!-- //pageing -->
                     <!-- //bottom_lay -->
                     <!-- //line_box -->
                </div>
           </form>
        </div>
    </t:putAttribute>
</t:insertDefinition>
