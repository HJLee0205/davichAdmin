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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 티임딜 &gt; 타임딜 목록</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function() {
                TimedealUtil.init();

                // 검색
                $('#btn_id_search_btn').on('click', function() {
                    TimedealUtil.search();
                });

                // 선택삭제
                $('#del_timeDeal_btn').on('click', function () {
                    TimedealUtil.delete();
                });

                // 할인율 변경
                $('#change_dc_rate').on('click', function () {
                    TimedealUtil.changeDcValue();
                });

                // 기간 변경
                $('#change_apply_date').on('click', function () {
                    TimedealUtil.changeApplyDate();
                });
            });

            var TimedealUtil = {
                init: function () {
                    $('#grid_id_timeDealList').grid($('#form_id_search'));

                    Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search_btn').trigger('click') });
                },
                search: function () {
                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return false;
                    }

                    $("#search_id_page").val("1");
                    $("#form_id_search").submit();
                },
                delete: function () {
                    var selected = $('#grid_id_timeDealList').find('input:checkbox[name=prmtNo]:checked');
                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('삭제할 상품을 선택해주세요.');
                        return false;
                    }

                    var param = {};
                    $.each(selected, function (idx, obj) {
                        param['list['+idx+'].prmtNo'] = $(obj).closest('tr').data('prmt-no');
                    });

                    var url = '/admin/promotion/timeDeal-delete';

                    Dmall.LayerUtil.confirm('삭제된 정보는 복구할 수 없습니다.<br>정말 삭제하시겠습니까?', function () {
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if(result.success) {
                                $('#btn_id_search_btn').trigger('click');
                            }
                        });
                    });
                },
                changeDcValue: function () {
                    var selected = $('#grid_id_timeDealList').find('input:checkbox[name=prmtNo]:checked');
                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('변경할 상품을 선택해주세요.');
                        return false;
                    }

                    var param = {};
                    $.each(selected, function (idx, obj) {
                        var $obj = $(obj).closest('tr');
                        param['list['+idx+'].prmtNo'] = $obj.data('prmt-no');
                        param['list['+idx+'].prmtDcValue'] = $obj.find('input[name=prmtDcValue]').val();
                    });

                    var url = '/admin/promotion/timeDeal-update';

                    Dmall.LayerUtil.confirm('수정하시겠습니까?', function () {
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {

                        });
                    });
                },
                changeApplyDate: function () {
                    var selected = $('#grid_id_timeDealList').find('input:checkbox[name=prmtNo]:checked');
                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('변경할 상품을 선택해주세요.');
                        return false;
                    }

                    var param = {};
                    $.each(selected, function (idx, obj) {
                        var $obj = $(obj).closest('tr');
                        param['list['+idx+'].prmtNo'] = $obj.data('prmt-no');
                        param['list['+idx+'].applyStartDttm'] = $obj.find('input[name=applyStartDttm]').val();
                        param['list['+idx+'].applyEndDttm'] = $obj.find('input[name=applyEndDttm]').val();
                        if($obj.find('input[name=applyAlwaysYn]').is(':checked')) {
                            param['list['+idx+'].applyAlwaysYn'] = 'Y';
                        } else {
                            param['list['+idx+'].applyAlwaysYn'] = 'N';
                        }
                    });

                    console.log(param);

                    var url = '/admin/promotion/timeDeal-update';

                    Dmall.LayerUtil.confirm('수정하시겠습니까?', function () {
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {

                        });
                    });
                },
            }
        </script>   
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    프로모션 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">타임딜 관리 </h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form id="form_id_search" commandName="so">
                        <form:hidden path="page" id="search_id_page" value="" />
                        <form:hidden path="rows" id="rows" value="" />
                        <%--<form:hidden path="searchGoodsTypeCds" id="goods_type_cd_s" value="" />--%>
                        <input type="hidden" name="sort" value="${so.sort}" />
                        <div class="search_tbl">
                            <table summary="이표는 타임딜  검색 표 입니다. 구성은 기간, 상태, 검색어 입니다.">
                                <caption>판매상품관리 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th >기간</th>
                                    <td>
                                        <tags:calendar from="searchStartDate" to="searchEndDate" fromValue="${so.searchStartDate}" toValue="${so.searchEndDate}" idPrefix="srch" hasTotal="true" />
                                    </td>
                                </tr>
                                <%--<tr>
                                    <td>
                                        <tags:checkbox id="searchApplyAlwaysYn" name="searchApplyAlwaysYn" value="N" compareValue="${so.searchApplyAlwaysYn}" text="무제한"/>
                                    </td>
                                </tr>--%>
                                <tr>
                                    <th>할인율</th>
                                    <td>
                                        <div class="flex">
                                            <tags:radio name="prmtDcGbCd" codeStr="01:전체;02:직접입력" idPrefix="prmtDcGbCd" value="01"/>
                                            <span class="intxt shot">
                                                <input type="text" name="searchDcValue" id="searchDcValue" data-validation-engine="validate[required, maxSize[3]]" value="0" style="width:80px;">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품군</th>
                                    <td id="search_goodsTypeCd">
                                        <c:set var="searchGoodsTypeCds" value="${fn:join(so.searchGoodsTypeCds, ' ')}"/>
                                        <a href="#none" id="searchGoodsTypeCds"  class="all_choice  mr20"><span class="ico_comm"></span> 전체</a>

                                        <label for="goodsTypeCd1" class="chack mr20<c:if test="${fn:contains(searchGoodsTypeCds,'01')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="searchGoodsTypeCds" id="goodsTypeCd1" value="01" label="" cssClass="blind"/>
                                            </span>
                                            안경테
                                        </label>
                                        <label for="goodsTypeCd2" class="chack mr20<c:if test="${fn:contains(searchGoodsTypeCds,'02')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="searchGoodsTypeCds" id="goodsTypeCd2" value="02" label="" cssClass="blind"/>
                                            </span>
                                            선글라스
                                        </label>
                                        <label for="goodsTypeCd3" class="chack mr20<c:if test="${fn:contains(searchGoodsTypeCds,'03')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="searchGoodsTypeCds" id="goodsTypeCd3" value="03" label="" cssClass="blind"/>
                                            </span>
                                            안경렌즈
                                        </label>
                                        <label for="goodsTypeCd4" class="chack mr20<c:if test="${fn:contains(searchGoodsTypeCds,'04')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="searchGoodsTypeCds" id="goodsTypeCd4" value="04" label="" cssClass="blind"/>
                                            </span>
                                            콘택트렌즈
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매자</th>
                                    <td>
                                        <span class="select">
                                            <label for="sel_seller">전체</label>
                                            <select name="searchSeller" id="sel_seller">
                                                <code:sellerOption siteno="${siteNo}" includeTotal="true"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품코드</th>
                                    <td>
                                        <span class="intxt long"><input type="text" name="searchGoodsNo" id="searchGoodsNo"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="20" maxlength="30" />
                                            <form:errors path="searchWords" cssClass="errors"  />
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </form:form>
                    <div class="btn_box txtc">
                        <a href="#none" class="btn green" id="btn_id_search_btn">검색</a>
                    </div>
                </div>
                <grid:tableSearchCnt id="grid_id_timeDealList" so="${so}" resultListModel="${resultListModel}" rowsOptionStr="" sortOptionStr="" type="타임딜">
                    <div class="tblh">
                        <table summary="이표는 타임딜 검색 표 입니다. 구성은 타임딜명, 타임딜 시작일, 타임딜 종료일, 타임딜 진행상태, 관리 입니다.">
                            <caption> 타임딜 리스트</caption>
                            <colgroup>
                                <col width="40px">
                                <col width="60px">
                                <col width="90px">
                                <col width="">
                                <col width="80px">
                                <col width="">
                                <col width="">
                                <col width="80px">
                                <col width="80px">
                                <col width="80px">
                                <col width="75px">
                                <col width="100px">
                                <col width="160px">
                                <col width="80px">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack05" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05" /></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>이미지</th>
                                <th>상품명</th>
                                <th>상품코드</th>
                                <th>브랜드</th>
                                <th>판매자</th>
                                <th>판매가</th>
                                <th>공급가</th>
                                <th>재고</th>
                                <th>판매<br>상태</th>
                                <th>할인율</th>
                                <th>타임딜 기간</th>
                                <th>다비전<br>상품코드</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_timeDealList">
                            <c:forEach var="timeDealItem" items="${resultListModel.resultList}" varStatus="status">
                                <tr data-prmt-no="${timeDealItem.prmtNo}" class="applyGoodsResult">
                                    <td>
                                        <label for="chack05_${status.count}" class="chack"><span class="ico_comm">
                                            <input type="checkbox" name="prmtNo" id="chack05_${status.count}" value="${timeDealItem.prmtNo}" />
                                        </span></label>
                                    </td>
                                    <td>${timeDealItem.sortNum}</td>
                                    <td><img src="${_IMAGE_DOMAIN}${timeDealItem.goodsImg02}"></td>
                                    <td>${timeDealItem.goodsNm}</td>
                                    <td>${timeDealItem.goodsNo}</td>
                                    <td>${timeDealItem.brandNm}</td>
                                    <td>${timeDealItem.sellerNm}</td>
                                    <td><fmt:formatNumber value="${timeDealItem.salePrice}" pattern="#,###"/></td>
                                    <td><fmt:formatNumber value="${timeDealItem.supplyPrice}" pattern="#,###"/></td>
                                    <td><fmt:formatNumber value="${timeDealItem.stockQtt}" pattern="#,###"/></td>
                                    <td>${timeDealItem.goodsSaleStatusNm}</td>
                                    <td>
                                        <span class="intxt shot"><input type="number" id="prmtDcValue" name="prmtDcValue" onKeyUp="if(this.value>100){this.value='100';}else if(this.value<0){this.value='0';}" data-validation-engine="validate[required, maxSize[3]]" value="${timeDealItem.prmtDcValue}" ></span>%
                                    </td>
                                    <td>
                                        <tags:calendarDate from="StartDttm" to="EndDttm" fromValue="${timeDealItem.applyStartDttm}" toValue="${timeDealItem.applyEndDttm}" idPrefix="apply" />
                                        <%--<tags:checkbox id="applyAlwaysYn" name="applyAlwaysYn" value="Y" compareValue="${timeDealItem.applyAlwaysYn}" text="무제한" />--%>
                                    <td>${timeDealItem.erpItmCode}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${resultListModel.filterdRows == 0}">
                                <tr>
                                    <td colspan="14">데이터가 없습니다.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <grid:paging resultListModel="${resultListModel}" />
                    </div>
                </grid:tableSearchCnt>
            </div>
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="del_timeDeal_btn">선택 타임딜 삭제</button>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="change_dc_rate">할인율 변경</button>
                    <button class="btn--blue-round" id="change_apply_date">기간 변경</button>
                    <button class="btn--blue-round" onclick="location.href='/admin/promotion/timeDeal-insert-form' ">타임딜 등록</button>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>