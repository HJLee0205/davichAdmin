<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 기획전 &gt; 기획전 목록</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function () {
                ExhibitionUtil.init();

                // 검색
                $('#btn_id_search_btn').on('click', function () {
                    ExhibitionUtil.search();
                });

                // 선택삭제
                $("#del_exhibition_btn").on('click', function () {
                    ExhibitionUtil.delete();
                });

                // 수정
                $('#tbody_id_exhibitionList').on('click', 'a.updt_btn', function () {
                    var prmtNo = $(this).closest('tr').data('prmt-no');
                    Dmall.FormUtil.submit('/admin/promotion/exhibition-update-form', {prmtNo: prmtNo});
                });

                // 복사
                $('#tbody_id_exhibitionList').on('click', 'a.copy_btn', function () {
                    ExhibitionUtil.copy();
                });

                // 미리보기btn 클릭 
                $(document).on('click', '#preview', function () {
                    var prmtNo = jQuery(this).parent().parent().parent().data("prmt-no");
                    window.open('/front/promotion/promotion-detail?prmtNo=' + prmtNo, '미리보기', 'height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes');
                    /*                    var w = 880;
                                       var h = 600;
                                       var left = Number((screen.width/2)-(w/2));
                                       var top = Number((screen.height/2)-(h/2));
                                       popupWindow = window.open('/front/promotion/promotion-detail?prmtNo='+prmtNo, '', 'toolbar=no, status=no, menubar=no, scrollbars=yes, resizable=1, width='+w+', height='+h+', top='+top+', left='+left);
                                       window.open("/front/promotion/promotion-detail?prmtNo="+prmtNo, "", 'height=485,width=700,left='+x+',top='+y);
                                       window.open("/front/promotion/promotion-detail?prmtNo="+prmtNo, "", "width=850,height=750,left=1000,top=1000"); */
                });
            });

            var ExhibitionUtil = {
                init: function () {
                    $('#grid_id_exhibitionList').grid($('#form_id_search'));

                    //엔터키 입력시 검색 기능
                    Dmall.FormUtil.setEnterSearch('form_id_search', function () {
                        $('#btn_id_search_btn').trigger('click')
                    });
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
                    var selected = $('#grid_id_exhibitionList').find('input:checkbox[name=prmtNo]:checked');
                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('삭제할 기획전을 선택해주세요.');
                        return false;
                    }

                    var param = {};
                    $.each(selected, function (idx, obj) {
                        param['list['+idx+'].prmtNo'] = $(obj).closest('tr').data('prmt-no');
                    });

                    var url = '/admin/promotion/exhibition-delete';

                    Dmall.LayerUtil.confirm('삭제된 정보는 복구할 수 없습니다.<br>정말 삭제하시겠습니까?', function () {
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if(result.success) {
                                $('#btn_id_search_btn').trigger('click');
                            }
                        });
                    });
                },
                copy: function () {
                    var prmtNo = $(this).closest('tr').data('prmt-no');

                    Dmall.LayerUtil.confirm('기획전 정보를 복사하시겠습니까?', function () {
                        var url = '/admin/promotion/exhibition-copy',
                            param = {prmtNo: prmtNo};

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            Dmall.validate.viewExceptionMessage(result, 'popupForm');

                            if (result == null || result.success != true) {
                                return;
                            } else {
                                Dmall.LayerUtil.alert("기획전 정보가 복사 되었습니다.").done(function () {
                                    $('#btn_id_search_btn').trigger('click');
                                });
                            }
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
                <h2 class="tlth2">기획전 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form id="form_id_search" commandName="so">
                        <form:hidden path="page" id="search_id_page" value=""/>
                        <form:hidden path="rows" id="rows" value=""/>
<%--                        <form:hidden path="goodsTypeCds" id="goods_type_cd_s" value=""/>--%>
<%--                        <form:hidden path="prmtTypeCds" id="prmt_type_cds_s" value=""/>--%>
                        <form:hidden path="prmtMainExpsUseYns" id="prmt_main_exps_use_yn_s" value=""/>
                        <input type="hidden" name="sort" value="${so.sort}"/>
                        <div class="search_tbl">
                            <table summary="이표는 기획전  검색 표 입니다. 구성은 기간, 상태, 검색어 입니다.">
                                <caption>판매상품관리 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="searchStartDate" to="searchEndDate"
                                                       fromValue="${so.searchStartDate}" toValue="${so.searchEndDate}"
                                                       idPrefix="srch" hasTotal="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품군</th>
                                    <td id="search_goodsTypeCd">
                                        <c:set var="goodsTypeCds" value="${fn:join(so.goodsTypeCds, ' ')}"/>
                                        <a href="#none" id="goodsTypeCd" class="all_choice  mr20"><span class="ico_comm"></span> 전체</a>
                                        <label for="goodsTypeCds1" class="chack mr20<c:if test="${fn:contains(goodsTypeCds,'01')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="goodsTypeCds" id="goodsTypeCds1" value="01" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            안경테
                                        </label>
                                        <label for="goodsTypeCds2" class="chack mr20<c:if test="${fn:contains(goodsTypeCds,'02')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="goodsTypeCds" id="goodsTypeCds2" value="02" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            선글라스
                                        </label>
                                        <label for="goodsTypeCds3" class="chack mr20<c:if test="${fn:contains(goodsTypeCds,'03')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="goodsTypeCds" id="goodsTypeCds3" value="03" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            안경렌즈
                                        </label>
                                        <label for="goodsTypeCds4" class="chack mr20<c:if test="${fn:contains(goodsTypeCds,'04')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="goodsTypeCds" id="goodsTypeCds4" value="04" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            콘택트렌즈
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>

                                        <c:set var="prmtStatusCds" value="${fn:join(so.prmtStatusCds, ' ')}"/>
                                        <label for="prmtStatusCds1" class="chack mr20<c:if test="${fn:contains(prmtStatusCds,'01')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="prmtStatusCds" id="prmtStatusCds1" value="01" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            진행 전
                                        </label>
                                        <label for="prmtStatusCds2" class="chack mr20<c:if test="${fn:contains(prmtStatusCds,'02')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="prmtStatusCds" id="prmtStatusCds2" value="02" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            진행 중
                                        </label>
                                        <label for="prmtStatusCds3" class="chack mr20<c:if test="${fn:contains(prmtStatusCds,'03')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="prmtStatusCds" id="prmtStatusCds3" value="03" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            종료
                                        </label>

                                    </td>
                                </tr>
                                <tr>
                                    <th>유형</th>
                                    <td id="search_prmtTypeCd">
                                        <a href="#none" id="prmtTypeCd" class="all_choice  mr20"><span class="ico_comm"></span> 전체</a>

                                        <c:set var="prmtTypeCds" value="${fn:join(so.prmtTypeCds, ' ')}"/>
                                        <label for="prmtTypeCds2" class="chack mr20<c:if test="${fn:contains(prmtTypeCds,'02')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="prmtTypeCds" id="prmtTypeCds2" value="02" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            쿠폰
                                        </label>
                                        <label for="prmtTypeCds3" class="chack mr20<c:if test="${fn:contains(prmtTypeCds,'03')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="prmtTypeCds" id="prmtTypeCds3" value="03" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            사은품
                                        </label>
                                        <label for="prmtTypeCds4" class="chack mr20<c:if test="${fn:contains(prmtTypeCds,'06')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="prmtTypeCds" id="prmtTypeCds4" value="06" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            첫 구매 특가
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>노출</th>
                                    <td id="search_prmtMainExpsUseYn">
                                        <a href="#none" id="prmtMainExpsUseYn" class="all_choice  mr20"><span class="ico_comm"></span> 전체</a>

                                        <c:set var="prmtMainExpsUseYns" value="${fn:join(so.prmtMainExpsUseYns, ' ')}"/>
                                        <label for="prmtMainExpsUseYns1" class="chack mr20<c:if test="${fn:contains(prmtMainExpsUseYns,'N')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="prmtMainExpsUseYns" id="prmtMainExpsUseYns1" value="N" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            미사용
                                        </label>
                                        <label for="prmtMainExpsUseYns2" class="chack mr20<c:if test="${fn:contains(prmtMainExpsUseYns,'Y')}"> on</c:if>">
                                            <span class="ico_comm">
                                                <form:checkbox path="prmtMainExpsUseYns" id="prmtMainExpsUseYns2" value="Y" label=""
                                                               cssClass="blind"/>
                                            </span>
                                            사용
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <form:input path="searchWords" cssClass="text"
                                                        cssErrorClass="text medium error" size="20" maxlength="30"/>
                                            <form:errors path="searchWords" cssClass="errors"/>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                    </form:form>
                    <div class="btn_box txtc">
                        <a href="#none" class="btn green" id="btn_id_search_btn">검색</a>
                    </div>
                </div>
                <grid:tableSearchCnt id="grid_id_exhibitionList" so="${so}" resultListModel="${resultListModel}"
                                     rowsOptionStr="" sortOptionStr="" type="기획전">
                    <div class="tblh">
                        <table summary="이표는 기획전 검색 표 입니다. 구성은 기획전명, 기획전 시작일, 기획전 종료일, 기획전 진행상태, 관리 입니다.">
                            <caption> 기획전 리스트</caption>
                            <colgroup>
                                <col width="50px" />
                                <col width="80px" />
                                <col width="" />
                                <col width="" />
                                <col width="" />
                                <col width="80px" />
                                <col width="90px" />
                                <col width="80px" />
                                <col width="110px" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack05" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05"/></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>생성일</th>
                                <th>기획전 명</th>
                                <th>기획전 기간</th>
                                <th>상태</th>
                                <th>미리보기</th>
                                <th>노출</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_exhibitionList">
                            <c:forEach var="exhibitionList" items="${resultListModel.resultList}" varStatus="status">
                                <tr data-prmt-no="${exhibitionList.prmtNo}">
                                    <td>
                                        <label for="chack05_${status.count}" class="chack">
                                            <span class="ico_comm">
                                                <input type="checkbox" name="prmtNo" id="chack05_${status.count}" value="${exhibitionList.prmtNo}"/>
                                            </span>
                                        </label>
                                    </td>
                                    <td>${exhibitionList.sortNum}</td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${exhibitionList.regDttm}"/></td>
                                    <td>${exhibitionList.prmtNm}</td>
                                    <td>${fn:substring(exhibitionList.applyStartDttm, 0, 16)} ~
                                        <br/> ${fn:substring(exhibitionList.applyEndDttm, 0, 16)} </td>
                                    <td>${exhibitionList.prmtStatusNm}</td>
                                    <td><a href="#none" class="btn_gray" id="preview">보기</a></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${exhibitionList.prmtMainExpsUseYn eq 'Y' }">
                                                사용
                                            </c:when>
                                            <c:otherwise>미사용</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="pop_btn btn_gray4_wrap">
                                            <a href="#none" class="btn_gray4 updt_btn">수정</a>
                                            <a href="#none" class="btn_gray4 btn_gray4_right copy_btn">복사</a>
                                        </div>
                                    </td>
                                    <td style="display:none">
                                        <input type="hidden" name="prmtWebBannerImgPath"
                                               value="${exhibitionList.prmtWebBannerImgPath}"/>
                                        <input type="hidden" name="prmtWebBannerImg"
                                               value="${exhibitionList.prmtWebBannerImg}"/>
                                        <input type="hidden" name="prmtMobileBannerImgPath"
                                               value="${exhibitionList.prmtMobileBannerImgPath}"/>
                                        <input type="hidden" name="prmtMobileBannerImg"
                                               value="${exhibitionList.prmtMobileBannerImg}"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${resultListModel.filterdRows == 0}">
                                <tr>
                                    <td colspan="9">데이터가 없습니다.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <grid:paging resultListModel="${resultListModel}"/>
                    </div>
                </grid:tableSearchCnt>
            </div>
        </div>
        <div class="bottom_box">
            <div class="left">
                <button id="del_exhibition_btn" class="btn--big btn--big-white">선택삭제</button>
            </div>
            <div class="right">
                <button type="button" class="btn--blue-round"
                        onclick="location.href='/admin/promotion/exhibition-insert-form' ">등록
                </button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>