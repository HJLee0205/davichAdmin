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
    <t:putAttribute name="title">홈 &gt; 디자인 &gt; 아이콘 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            jQuery(document).ready(function() {
                var selected;

                // 리스트 조회
                var iconSet = {
                    iconList : [],
                    getIconList : function() {
                        var url = '/admin/design/icon-list', dfd = jQuery.Deferred();
                        var param = jQuery('#form_id_search').serialize();

                        console.log("param = ", param);
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            var template1;
                            var template2;
                            var template3;
                            template1 =
                                    '<tr data-icon-no = "{{iconNo}}" >' +
                                        '<td>' +
                                        '    <label for="chkIconNo_{{iconNo}}" class="chack"> ' +
                                        '    <span class="ico_comm"><input type="checkbox" name="chkIconNo" id="chkIconNo_{{iconNo}}"  value="{{iconNo}}"/></span></label>' +
                                        '</td>' +
                                        '<td>{{rownum}}</td>';
                            template2 = '<td></td>';
                            template3 = '<td><a href="#none" class="btn_id_detail">{{IconDispnm}}</a></td>' +
                                        '<td>{{regDttm}}<input type="hidden" name="imgPath" id="imgPath_{{iconNo}}" value="{{imgPath}}" /></td>' +
                                        '<td><button class="btn_gray" onClick="javascript:fn_goods_list_Popup(\'{{iconNo}}\')">상품 목록</button></td>' +
                                    '</tr>';
                            managerTemplate1 = new Dmall.Template(template1),
                            managerTemplate3 = new Dmall.Template(template3),
                            tr = '';

                            jQuery.each(result.resultList, function(idx, obj) {
                                tr += managerTemplate1.render(obj);

                                var goodsTypeCd;
                                var comma = ', ';
                                var goodsTypeNm = '';
                                var lastIdx = 0;
                                if(obj.goodsTypeCdArr != null && obj.goodsTypeCdArr.length > 0) {
                                    lastIdx = obj.goodsTypeCdArr.length - 1;
                                }
                                jQuery.each(obj.goodsTypeCdArr, function (idx, obj) {
                                    if (obj != null && obj == "01") {
                                        goodsTypeCd = '안경테';
                                    } else if (obj != null && obj == "02") {
                                        goodsTypeCd = '선글라스';
                                    } else if (obj != null && obj == "03") {
                                        goodsTypeCd = '안경렌즈';
                                    } else if (obj != null && obj == "04") {
                                        goodsTypeCd = '콘택트렌즈';
                                    } else if (obj != null && obj == "05") {
                                        goodsTypeCd = '소모품';
                                    } else {
                                        goodsTypeCd = '';
                                    }
                                    if (idx != lastIdx) goodsTypeCd += comma;
                                    goodsTypeNm += goodsTypeCd;
                                });
                                template2 = '<td>' + goodsTypeNm + '</td>';
                                managerTemplate2 = new Dmall.Template(template2),
                                tr += managerTemplate2.render(obj);
                                tr += managerTemplate3.render(obj);
                            });

                            if(tr == '') {
                                tr = '<tr><td colspan="11">데이터가 없습니다.</td></tr>';
                            }
                            jQuery("#tbody_id_iconGoodsList").html(tr);
                            //jQuery('#tbody_id_iconList').html(tr);
                            iconSet.iconList = result.resultList;
                            dfd.resolve(result.resultList);

                            Dmall.GridUtil.appendPaging('form_id_search', 'div_id_topGoods_paging', result, 'paging_id_topGoods_icon', iconSet.getIconList);
                            $("#a_topGoods").text(result.filterdRows);

                        });

                        return dfd.promise();
                    }
                }
                
                // 검색
                jQuery('#btn_id_search').on('click', iconSet.getIconList);
                
                // 로딩시 자동검색 기능
                iconSet.getIconList();

                // 수정
                jQuery(document).on('click', '#tbody_id_iconGoodsList a.btn_id_detail', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var iconNo = jQuery(this).parents('tr').data('icon-no');
                    Dmall.FormUtil.submit('/admin/design/icon-detail', {iconNo : iconNo}, "_blank");
                });
                
                // 등록 화면
                jQuery('#btn_id_save').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.FormUtil.submit('/admin/design/icon-detail-new');
                });
                
                // 삭제 처리
                jQuery('#btn_id_delete').on('click', function(e) {
                    selected = fn_selectedList();
                    if (selected.length > 0) {
                        Dmall.LayerUtil.confirm('선택된 아이콘를 삭제하시겠습니까?', function() {
                            var url = '/admin/design/icon-delete',
                                    param = {},
                                    key,
                                    selected = fn_selectedList();

                                jQuery.each(selected, function(i, o) {
                                    key = 'list[' + i + '].iconNo';
                                    param[key] = o;
                                    key = 'list[' + i + '].imgNm';
                                    param[key] = jQuery('#imgNm_'+o).val();
                                    key = 'list[' + i + '].imgPath';
                                    param[key] = jQuery('#imgPath_'+o).val();
                                });            

                                console.log("param = ", param);
                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    //getSearchGoodsData();
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                                    //jQuery('#form_id_search').submit();
                                    iconSet.getIconList();
                                });
                        });
                    }
                });
            });
            
            // 선택된값 체크
            function fn_selectedList() {
                var selected = [];
                
                $("input[name='chkIconNo']:checked").each(function() {
                    selected.push($(this).val());     // 체크된 것만 값을 뽑아서 배열에 push
                });
                
                if (selected.length < 1) {
                    Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
                }
                return selected;
            }

            function fn_goods_list_Popup (iconNo) {
                var url = '/admin/design/icon-goods-list?iconNo=' + iconNo;
                Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_list'));

                GoodsListPopup._init( url );
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- content -->
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    디자인 설정<span class="step_bar"></span>  상품 아이콘 관리 <span class="step_bar"></span>
                </div>
                <h2 class="tlth2">상품 아이콘 관리</h2>
            </div>
            <div class="search_box_wrap">
                <!-- search_box -->
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="search_id_page" />
                <form:hidden path="rows" />
                <input type="hidden" name="sort" value="" />
                <div class="search_box">
                    <div class="search_tbl">
                        <table summary="이표는 아이콘 관리 검색 표 입니다. 구성은 스킨 검색, 메뉴 및 위치, 전시기간, 전시유형, 검색어 입니다.">
                            <caption>아이콘 관리 검색</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" fromValue="${so.fromRegDt}" toValue="${so.toRegDt}" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품군</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>
                                        <tags:checkboxs codeStr="01:안경테;02:선글라스;04:콘택트렌즈;03:안경렌즈;05:소모품;" name="goodsTypeCds" idPrefix="goodsTypeCd"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품명</th>
                                    <td>
                                        <span class="intxt wid100p"><input type="text" value="${so.goodsNm}" id="goodsNm" name="goodsNm"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt wid100p"><input type="text" value="${so.iconDispnm}" id="iconDispnm" name="iconDispnm"></span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                </form:form>
                <div class="btn_box txtc">
                    <button class="btn--black" id="btn_id_search">검색</button>
                </div>

                <!-- //search_box -->
                <!-- line_box -->

                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                              총 <strong class="be" id="a_topGoods">0</strong>개의 게시물이 검색되었습니다.
                            </span>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="이표는 아이콘 관리 리스트 표 입니다. 구성은 체크박스, 순번, 적용스킨, 전시상태, 메뉴 및 위치, 아이콘ID, 프로모션 명, 시작 일시, *종료 일시, 등록자명(ID), 등록 일시, 수정일시 입니다." style="min-width: 0px">
                            <caption>아이콘 관리 리스트</caption>
                            <colgroup>
                                    <col width="5%">
                                    <col width="8%">
                                    <col width="25%">
                                    <col width="30%">
                                    <col width="15%">
                                    <col width="15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>
                                        <label for="chack05" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="table" id="chack05" class="blind" /></span>
                                        </label>
                                    </th>
                                        <th>번호</th>
                                        <th>상품군</th>
                                        <th>아이콘 제목</th>
                                        <tH>작성일</tH>
                                        <th>관리</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_id_iconGoodsList">
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->

                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <!-- pageing -->
                            <%-- <grid:paging resultListModel="${resultListModel}" /> --%>
                        <div id="div_id_topGoods_paging"></div>
                        <!-- //pageing -->
                    </div>
                </div>
            </div>
            <!-- //line_box -->
            <!-- bottom_box -->
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_id_delete">선택 삭제</button>
                    <!-- <button class="btn--big btn--big-white" id="btn_list">목록</button> -->
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_id_save">등록</button>
                    <!-- <button class="btn--blue-round" id="btn_save">저장</button> -->
                    <!-- <button class="btn--blue-round" id="btn_change">수정</button> -->
                </div>
            </div>
            <!-- //bottom_box -->
            <jsp:include page="/WEB-INF/include/popup/goodsListPopup.jsp" />
        </div>
    <!-- //content -->

    </t:putAttribute>
</t:insertDefinition>