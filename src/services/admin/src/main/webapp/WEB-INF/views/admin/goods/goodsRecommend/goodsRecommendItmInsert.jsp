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
    <t:putAttribute name="title">추천 상품 관리 > 상품</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 기존 데이터 조회
                RcmdUtil.getListData();

                // 상품군 select
                $('#goods_type_cd').on('change', function() {
                    RcmdUtil.renderList($(this).val());
                });

                // 삭제
                $('#btn_check_delete').on('click', function() {
                    GoodsUtil.deleteRegistGoods();
                });

                // 목록
                $('#btn_list').on('click', function() {
                    Dmall.FormUtil.submit('/admin/goods/recommend-info?typeCd='+$('#rec_type').val());
                });

                // 저장
                $('#reg_btn').on('click', function() {
                    RcmdUtil.saveGoods();
                });
            });

            var RcmdUtil = {
                list: [],
                delList: [],
                getListData: function() {
                    var url = '/admin/goods/recommend-list',
                        param = {recType: $('#rec_type').val()},
                        dfd = $.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result != null && result.length == 0) {
                            return;
                        }

                        $('#goods_search_empty').hide();
                        $('#goods_search_exist').show();

                        var $tbody = $('#tbody_recommend_data');

                        var template =
                                '<tr id="tr_goods_{{goodsNo}}" class="searchGoodsResult">' +
                                '<td>' +
                                '<input type="hidden" name="insRecommendGoodsNoList" value="{{goodsNo}}">' +
                                '<label for="chk_recommendNo_{{rowNum}}" class="chack"><span class="ico_comm">' +
                                '<input type="checkbox" id="chk_recommendNo_{{rowNum}}" class="blind">' +
                                '</span></label>' +
                                '</td>' +
                                '<td>{{rowNum}}</td>' +
                                '<td><img src="{{latelyImg}}" alt=""></td>' +
                                '<td>{{goodsNm}}</td>' +
                                '<td>{{goodsNo}}</td>' +
                                '<td>{{brandNm}}</td>' +
                                '<td>{{sellerNm}}</td>' +
                                '<td class="comma">{{salePrice}}</td>' +
                                '<td class="comma">{{stockQtt}}</td>' +
                                '<td>{{goodsSaleStatusNm}}</td>' +
                                '<td>{{erpItmCode}}</td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result, function(idx, obj) {
                            obj.latelyImg = '${_IMAGE_DOMAIN}' + obj.latelyImg;
                            if(obj.goodsTypeCd == $('#goods_type_cd').val()) {
                                tr += templateMgr.render(obj);
                            }
                        });

                        $tbody.html(tr);

                        RcmdUtil.list = result;
                        dfd.resolve(result);

                        $('#cnt_total').html($('#tbody_recommend_data').children('tr').length);

                        Dmall.common.comma();
                    });
                    return dfd.promise();
                },
                renderList: function(goodsTypeCd) {
                    $('#tbody_recommend_data').html('');

                    var template =
                            '<tr id="tr_goods_{{goodsNo}}" class="searchGoodsResult">' +
                            '<td>' +
                            '<input type="hidden" name="insRecommendGoodsNoList" value="{{goodsNo}}">' +
                            '<label for="chk_recommendNo_{{rowNum}}" class="chack"><span class="ico_comm">' +
                            '<input type="checkbox" id="chk_recommendNo_{{rowNum}}" class="blind">' +
                            '</span></label>' +
                            '</td>' +
                            '<td>{{rowNum}}</td>' +
                            '<td><img src="{{latelyImg}}" alt=""></td>' +
                            '<td>{{goodsNm}}</td>' +
                            '<td>{{goodsNo}}</td>' +
                            '<td>{{brandNm}}</td>' +
                            '<td>{{sellerNm}}</td>' +
                            '<td class="comma">{{salePrice}}</td>' +
                            '<td class="comma">{{stockQtt}}</td>' +
                            '<td>{{goodsSaleStatusNm}}</td>' +
                            '<td>{{erpItmCode}}</td>' +
                            '</tr>',
                        templateMgr = new Dmall.Template(template),
                        tr = '';

                    var totalRows = 0;
                    $.each(this.list, function(idx, obj) {
                        if(obj.goodsTypeCd == goodsTypeCd) {
                            tr += templateMgr.render(obj);
                            totalRows++;
                        }
                    });

                    if(tr == '') {
                        $('#goods_search_empty').show();
                        $('#goods_search_exist').hide();
                    } else {
                        $('#goods_search_empty').hide();
                        $('#goods_search_exist').show();
                    }

                    $('#tbody_recommend_data').html(tr);

                    $('#cnt_total').html(totalRows);

                    Dmall.common.comma();
                },
                saveGoods: function() {
                    var url = '/admin/goods/recommend-items-insert',
                        param = $('#form_recommend_itm_insert').serialize() + '&delList=' + RcmdUtil.delList;
                    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Dmall.FormUtil.submit('/admin/goods/recommend-info?typeCd='+$('#rec_type').val());
                        }
                    });
                }
            }

            var GoodsUtil = {
                showSrchPop: function() {
                    Dmall.LayerPopupUtil.open($('#layer_popup_goods_select'));
                    GoodsSelectPopup._init(this.callbackPopApply);
                    $('#btn_popup_goods_search').trigger('click');
                },
                callbackPopApply: function(data) {
                    var $tbody = $('#tbody_recommend_data');
                    // 첫 등록이면 노출 table 변경
                    var index = $tbody.children('tr').length;
                    if(index == 0) {
                        $('#goods_search_empty').hide();
                        $('#goods_search_exist').show();
                    }
                    // 상품등록 중복 체크
                    for(var i = 0; i < $tbody.children('tr').length; i++) {
                        if($tbody.find('tr').eq(i).find('input:hidden[name=insRecommendGoodsNoList]').prop('value') == data['goodsNo']) {
                            Dmall.LayerUtil.alert("이미 선택하셨습니다.");
                            return false;
                        }
                    }
                    // 최대개수 체크
                    if(index >= 20) {
                        Dmall.LayerUtil.alert("상품은 최대 20개까지 등록할 수 있습니다.");
                        return;
                    }

                    index++;

                    var template =
                        '<tr id="tr_goods_'+data['goodsNo']+'" class="searchGoodsResult">' +
                        '<td>' +
                        '<input type="hidden" name="insRecommendGoodsNoList" value="'+data['goodsNo']+'">' +
                        '<label for="chk_recommendNo_'+index+'" class="chack"><span class="ico_comm">' +
                        '<input type="checkbox" id="chk_recommendNo_'+index+'" class="blind">' +
                        '</span></label></td>' +
                        '<td>'+index+'</td>' +
                        '<td><img src="${_IMAGE_DOMAIN}'+data['goodsImg02']+'" alt=""></td>' +
                        '<td>'+data['goodsNm']+'</td>' +
                        '<td>'+data['goodsNo']+'</td>' +
                        '<td>'+data['brandNm']+'</td>' +
                        '<td>'+data['sellerNm']+'</td>' +
                        '<td>'+Dmall.common.numberWithCommas(data['salePrice'])+'</td>' +
                        '<td>'+Dmall.common.numberWithCommas(data['stockQtt'])+'</td>' +
                        '<td>'+data['goodsSaleStatusNm']+'</td>' +
                        '<td>'+data['erpItmCode']+'</td>' +
                        '</tr>';

                    $tbody.append(template);

                    $('#cnt_total').html(index);
                },
                deleteRegistGoods: function() {
                    $('#tbody_recommend_data').children('tr').each(function() {
                        if($(this).find('label[for^=chk_recommendNo_]').hasClass('on')) {
                            // 데이터 list 삭제
                            var delVal = $(this).find('input:hidden[name=insRecommendGoodsNoList]').val();
                            $.each(RcmdUtil.list, function(idx, obj) {
                                if(obj.goodsNo == delVal) {
                                    RcmdUtil.list.splice(idx, 1);
                                    return false;
                                }
                            });

                            RcmdUtil.delList.push(delVal);

                            $(this).remove();
                        }
                    });

                    var $tbody = $('#tbody_recommend_data');
                    var totalRows = $tbody.children('tr').length;

                    if(totalRows == 0) {
                        $('#goods_search_empty').show();
                        $('#goods_search_exist').hide();
                        return;
                    }

                    for(var i = 0; i < totalRows; i++) {
                        $tbody.children('tr').eq(i).children('td').eq(1).text(i+1);
                    }

                    $('#cnt_total').html(totalRows);

                    // 데이터 list rowNum 수정
                    var index = 1;
                    $.each(RcmdUtil.list, function(idx, obj) {
                        if(obj.goodsTypeCd == $('#goods_type_cd').val()) {
                            obj.rowNum = index++;
                        }
                    });
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_head">
                상품 설정<span class="step_bar"></span>   추천 상품 관리<span class="step_bar"></span>
            </div>
            <div class="tlt_box">
            <c:if test="${po.recType eq 'none'}">
                <h2 class="tlth2">비회원 추천 상품 관리</h2>
            </c:if>
            <c:if test="${po.recType eq 'code'}">
                <h2 class="tlth2">CODEPICK 상품 관리</h2>
            </c:if>
            </div>
            <!-- line_box -->
            <form id="form_recommend_itm_insert">
                <input type="hidden" name="recType" id="rec_type" value="${po.recType}" />
                <div class="line_box pb">
                    <!-- tblw -->
                    <div class="tblw">
                        <table summary="이표는 추천 사품 정보표 입니다.구성은 추천사용 여부, 추천 기간, 상품 설정입니다.">
                            <caption>쿠폰 상세정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>상품군</th>
                                <td>
                                    <span class="select">
                                        <select name="goodsTypeCd" id="goods_type_cd">
                                            <tags:option codeStr="01:안경테;02:선글라스;04:콘택트렌즈;03:안경렌즈" value="01"/>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>상품 설정</th>
                                <td id="goods_search_empty">
                                    <span class="btn_box">
                                        <button type="button" id="apply_goods_srch_btn" class="btn--black_small goods" onClick="GoodsUtil.showSrchPop();">상품 검색</button>
                                    </span>
                                </td>
                                <td id="goods_search_exist" style="display: none;">
                                    <div class="top_lay">
                                        <div class="select_btn_left">
                                            <a href="#none" class="btn_gray2" id="btn_check_delete">삭제</a>
                                        </div>
                                        <div class="select_btn_right">
                                            <span class="search_txt">
                                                총 <strong class="be" id="cnt_total">0</strong>개의 상품이 검색되었습니다.
                                            </span>
                                            <span class="btn_box">
                                                <button type="button" id="apply_goods_srch_btn" class="btn--black_small goods" onClick="GoodsUtil.showSrchPop();">상품 검색</button>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="tblh">
                                        <table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                                            <caption>판매상품관리 리스트</caption>
                                            <colgroup>
                                                <col width="66px">
                                                <col width="66px">
                                                <col width="100px">
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
                                                        <label for="allcheck" class="chack">
                                                            <span class="ico_comm"><input type="checkbox" name="table" id="allcheck" /></span>
                                                        </label>
                                                    </th>
                                                    <th>번호</th>
                                                    <th>이미지</th>
                                                    <th>상품명</th>
                                                    <th>상품코드</th>
                                                    <th>브랜드</th>
                                                    <th>판매자</th>
                                                    <th>판매가</th>
                                                    <th>재고</th>
                                                    <th>판매상태</th>
                                                    <th>다비전<br>상품코드</th>
                                                </tr>
                                            </thead>
                                            <tbody id="tbody_recommend_data"></tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
            </form>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="reg_btn">저장</button>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
    </t:putAttribute>
</t:insertDefinition>
