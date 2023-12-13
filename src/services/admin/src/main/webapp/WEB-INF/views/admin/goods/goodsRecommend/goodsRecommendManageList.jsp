<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">추천 상품 관리 > 상품</t:putAttribute>
    <t:putAttribute name="style">
        <style>
            .sort_up, .sort_down {
                width: 24px !important;
                height: 24px !important;
                cursor: pointer !important;
            }
        </style>
    </t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 추천 상품 조회
                RcmdUtil.getListData();

                // 탭 클릭
                $('#ul_tab_main').find('li').on('click', function() {
                    $(this).siblings().removeClass('on');
                    $(this).addClass('on');
                    RcmdUtil.renderList($(this).data('goods-type'));
                });

                // 상단 이동
                $(document).on('click', 'img.sort_up', function() {
                    RcmdUtil.sortUpdateUp($(this));
                });

                // 하단 이동
                $(document).on('click', 'img.sort_down', function() {
                    RcmdUtil.sortUpdateDown($(this));
                });

                // 선택 추천 삭제
                $('#btn_cancel').on('click', function() {
                    RcmdUtil.deleteGoods();
                });

                // 추천 등록
                $('#btn_regist').on('click', function() {
                    Dmall.FormUtil.submit('/admin/goods/recommend-item-insert?recType=${typeCd}');
                });
            });

            var typeCd = '${typeCd}';
            var RcmdUtil = {
                list: [],
                getListData: function() {
                    var url = '/admin/goods/recommend-list',
                        param = {recType: typeCd},
                        dfd = $.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result == null || result.length <= 0) return;

                        RcmdUtil.list = result;
                        RcmdUtil.renderList('01');
                    });
                    return dfd.promise();
                },
                renderList: function(goodsTypeCd) {
                    $('#tbody_recommend_data').html('');

                    var template =
                            '<tr>' +
                            '<input type="hidden" name="sortSeq" value="{{sortSeq}}">' +
                            '<td>' +
                            '<label for="chk_rcmd_no_{{goodsNo}}" class="chack">' +
                            '<span class="ico_comm"><input type="checkbox" name="chkRcmdNo" id="chk_rcmd_no_{{goodsNo}}" value="{{goodsNo}}" class="blind"></span>' +
                            '</label>' +
                            '</td>' +
                            '<td>{{rowNum}}</td>' +
                            '<td><img src="{{latelyImg}}" alt=""></td>' +
                            '<td>{{goodsNm}}</td>' +
                            '<td>{{goodsNo}}</td>' +
                            '<td>{{brandNm}}</td>' +
                            '<td>{{sellerNm}}</td>' +
                            '<td class="comma">{{salePrice}}</td>' +
                            '<td class="comma">{{supplyPrice}}</td>' +
                            '<td class="comma">{{stockQtt}}</td>' +
                            '<td>{{goodsSaleStatusNm}}</td>' +
                            '<td>{{erpItmCode}}</td>' +
                            '<td>' +
                            '<img class="sort_up" src="../img/common/new/icon/order_up_btn.png" alt="">&nbsp;&nbsp;' +
                            '<img class="sort_down" src="../img/common/new/icon/order_down_btn.png" alt="">' +
                            '</td>' +
                            '</tr>',
                        templateMgr = new Dmall.Template(template),
                        tr = '';

                    var regExp = new RegExp('http');
                    var totalRows = 0;
                    $.each(RcmdUtil.list, function(idx, obj) {
                        if(!regExp.test(obj.latelyImg)) {
                            obj.latelyImg = '${_IMAGE_DOMAIN}' + obj.latelyImg;
                        }

                        if(obj.goodsTypeCd == goodsTypeCd) {
                            tr += templateMgr.render(obj);
                            totalRows++;
                        }
                    });

                    if(tr == '') {
                        tr = '<tr><td colspan="13">데이터가 없습니다.</td></tr>';
                    }

                    $('#tbody_recommend_data').html(tr);

                    $('#cnt_total').html(totalRows);

                    Dmall.common.comma();
                },
                sortUpdateUp: function($obj) {
                    if(!$obj.closest('tr').prev().is('tr')) {
                        return;
                    }

                    var orgSortSeq = $obj.closest('tr').find('input:hidden[name=sortSeq]').val();
                    var sortSeq = $obj.closest('tr').prev().find('input:hidden[name=sortSeq]').val();
                    var orgGoodsNo = $obj.closest('tr').find('input[type=checkbox]').val();
                    var goodsNo = $obj.closest('tr').prev().find('input[type=checkbox]').val();

                    var url = '/admin/goods/recommend-sort-update',
                        param = {orgSortSeq: orgSortSeq,
                            sortSeq: sortSeq,
                            orgGoodsNo: orgGoodsNo,
                            goodsNo: goodsNo,
                            recType: typeCd};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        RcmdUtil.list = result;
                        $('#ul_tab_main').find('li.on').trigger('click');
                    });
                },
                sortUpdateDown: function($obj) {
                    if(!$obj.closest('tr').next().is('tr')) {
                        return;
                    }

                    var orgSortSeq = $obj.closest('tr').find('input:hidden[name=sortSeq]').val();
                    var sortSeq = $obj.closest('tr').next().find('input:hidden[name=sortSeq]').val();
                    var orgGoodsNo = $obj.closest('tr').find('input[type=checkbox]').val();
                    var goodsNo = $obj.closest('tr').next().find('input[type=checkbox]').val();

                    var url = '/admin/goods/recommend-sort-update',
                        param = {orgSortSeq: orgSortSeq,
                            sortSeq: sortSeq,
                            orgGoodsNo: orgGoodsNo,
                            goodsNo: goodsNo,
                            recType: typeCd};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        RcmdUtil.list = result;
                        $('#ul_tab_main').find('li.on').trigger('click');
                    });
                },
                deleteGoods: function() {
                    var selected = [];
                    $('#tbody_recommend_data').find('input[type=checkbox]').each(function() {
                        if($(this).prop('checked')) {
                            selected.push($(this).val());
                        }
                    });

                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제하시겠습니까?', function() {
                        var url = '/admin/goods/check-recommend-delete',
                            param = {recType: typeCd, paramRecommendNo: selected};

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                location.reload();
                            }
                        });
                    });
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>   추천 상품 관리<span class="step_bar"></span>
                </div>
                <div class="tlt_box">
                    <div class="tlt_box">
                        <c:if test="${typeCd eq 'none'}"><h2 class="tlth2">비회원 추천 상품 관리</h2></c:if>
                        <c:if test="${typeCd eq 'code'}"><h2 class="tlth2">CODEPICK 상품 관리</h2></c:if>
                    </div>
                </div>
            </div>
            <div class="tab_link">
                <ul class="six long" id="ul_tab_main">
                    <li class="_main on" data-goods-type="01"><a href="javascript:;">안경테</a></li>
                    <li class="_main" data-goods-type="02"><a href="javascript:;">선글라스</a></li>
                    <li class="_main" data-goods-type="04"><a href="javascript:;">콘택트렌즈</a></li>
                    <li class="_main" data-goods-type="03"><a href="javascript:;">안경렌즈</a></li>
                </ul>
            </div>
            <!-- line_box -->
            <div class="line_box pb">
                <div class="top_lay">
                    <div class="search_txt">
                        총 <strong id="cnt_total" class="be">0</strong>개의 추천 상품이 검색되었습니다.
                    </div>
                </div>
                <!-- tblh -->
                <div class="tblh">
                    <table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                        <caption>판매상품관리 리스트</caption>
                        <colgroup>
                            <col width="50px">
                            <col width="50px">
                            <col width="100px">
                            <col width="10%">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="">
                            <col width="110px">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>
                                    <label for="allcheck" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="allcheck"></span>
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
                                <th>판매상태</th>
                                <th>다비전<br>상품코드</th>
                                <th>비고</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_recommend_data"></tbody>
                    </table>
                </div>
                <!-- //tblh -->
            </div>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="left">
                    <div class="pop_btn">
                        <button class="btn--big btn--big-white" id="btn_cancel">선택 추천 삭제</button>
                    </div>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_regist">추천 등록</button>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>