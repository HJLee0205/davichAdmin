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
    <t:putAttribute name="title">키워드 상품 관리</t:putAttribute>
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
                // 키워드 조회
                KeywordUtil.getListData();

                // 키워드 추가
                $('#keywordInsBtn').on('click', function() {
                    if($('#keywordNo').val() == null || $('#keywordNo').val() == '') {
                        Dmall.LayerUtil.alert('키워드를 선택해주세요.');
                        return;
                    }

                    if($('#keywordLvl').val() != '1') {
                        Dmall.LayerUtil.alert('키워드는 1Depth에만 추가할 수 있습니다.');
                        return;
                    }

                    Dmall.LayerPopupUtil.open($('#keywordInsLayer'));
                    openKeywordInsLayer($('#prKeywordLvl').val(), $('#prKeywordNo').val(), $('#prKeywordNm').val(), $('#goodsTypeCd').val());
                });

                // 삭제
                $('#delKeywordBtn').on('click', function() {
                    var selected = $('#keywordTree').jstree('get_selected');
                    var selectedNode = $('#keywordTree').jstree('get_node', selected[0]);
                    if(selectedNode.parent == '#') {
                        Dmall.LayerUtil.alert('해당 카테고리는 삭제할 수 없습니다.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제하시겠습니까?', function() {
                        var url = '/admin/goods/keyword-delete',
                            param = {keywordNo:$('#keywordNo').val()};

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                KeywordUtil.keywordTreeReload();
                            }
                        });
                    })
                });

                // 저장
                $('#reg_btn').on('click', function() {
                    var url = '/admin/goods/keyword-update',
                        param = $('#form_keyword_info').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        location.reload();
                    });
                });

                // 상단 이동
                $(document).on('click', 'img.sort_up', function() {
                    KeywordUtil.sortUp($(this));
                });

                // 하단 이동
                $(document).on('click', 'img.sort_down', function() {
                    KeywordUtil.sortDown($(this));
                });
            });

            var KeywordUtil = {
                getListData: function() {
                    var url = '/admin/goods/keyword-list',
                        param = {};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        $('#keywordTree').jstree({
                            'core' : {
                                'themes' : { 'classic' : true },
                                'data' : result,
                                'icons' : true,
                                'check_callback' :  function (op, node, par, pos, more) {

                                    if ((op === "move_node" || op === "copy_node")/* && node.type && node.type == "root"*/) {
                                        return false;
                                    }

                                    if((op === "move_node" || op === "copy_node") && more && more.core
                                        && !Dmall.LayerUtil.confirm('순서를 변경하시겠습니까?',
                                            function() {
                                                //Keyword 순서 저장
                                                var keywordNo = node.id; //자신 ID
                                                var keywordParent = node.parent; //자신 부모 ID
                                                var upKeywordNo = par.id; //상위 ID
                                                var downKeywordNo = (node.children_d).toString(); //하위 ID
                                                var orgKeywordLvl = Number(node.original.keywordLvl);  //변경 전 자신 LEVEL
                                                var keywordLvl = Number(par.original.keywordLvl)+1; //변경 후 자신 LEVEL ( = 하위 LEVEL +1)
                                                var sortSeq = pos+1; //변경할 위치

                                                console.log(node.children_d)
                                                console.log(downKeywordNo)
                                                console.log("keywordNo: "+keywordNo+" | upKeywordNo: "+upKeywordNo+" | downKeywordNo: "+downKeywordNo+" | orgKeywordLvl: "+orgKeywordLvl+" | keywordLvl: "+keywordLvl+" | sortSeq: "+sortSeq)
                                                if(keywordParent !== upKeywordNo){
                                                    Dmall.LayerUtil.alert("상위나 하위 Keyword로 이동할 수 없습니다.");
                                                    return;
                                                }
                                                var url = '/admin/goods/keyword-sort',
                                                    param = {keywordNo:keywordNo, upKeywordNo:upKeywordNo, downKeywordNo:downKeywordNo, orgKeywordLvl:orgKeywordLvl, keywordLvl:keywordLvl, sortSeq:sortSeq};
                                                console.log("param = ", param);
                                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                                    Dmall.validate.viewExceptionMessage(result, 'keywordMngForm');
                                                    keywordTreeListReload();
                                                });

                                            })){
                                        return false;
                                    }

                                    return true;
                                }
                            },
                            'plugins' : ['wholerow', 'dnd']
                        }).bind('select_node.jstree', function(event,data){       //선택 이벤트
                            data.instance.toggle_node(data.node);

                            if($('#keywordNo').val() == data.node.id) {
                                return;
                            }

                            var level = data.node.parents.length;

                            $("#keywordNo").val(data.node.id);
                            $('#keywordLvl').val(level);
                            $("#prKeywordLvl").val(level+1);
                            $("#prKeywordNo").val(data.node.id);
                            $("#prKeywordNm").val(data.node.text);

                            if(level < 2) {
                                $('#keywordInsDiv').hide();
                            } else {
                                $('#keywordInsDiv').show();
                                KeywordUtil.selectKeywordInfo(data.node.id);
                            }
                        });

                        $('#keywordTree').jstree(true).settings.core.data = result;
                        $('#keywordTree').jstree(true).refresh();
                    });
                },
                selectKeywordInfo: function(keywordNo) {
                    this.initKeywordGoods();

                    var url = '/admin/goods/keyword',
                        param = {keywordNo: keywordNo},
                        dfd = $.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var $prDiv = $('#keywordInsDiv');

                        // input 값 바인딩
                        $prDiv.find('input:radio[name=useYn][value='+result.data.useYn+']').trigger('click');
                        $prDiv.find('input:text[name=keywordNm]').val(result.data.keywordNm);
                        $prDiv.find('input:text[name=goodsTypeCd]').val(result.data.goodsTypeCd);
                        if(result.extraData.goods_list == null || result.extraData.goods_list.length == 0) {
                            return;
                        }
                        // 키워드 상품 데이터 바인딩
                        var template =
                            '<tr id="tr_goods_{{goodsNo}}">' +
                            '<td>' +
                            '<input type="hidden" name="insKeywordGoodsNoList" value="{{goodsNo}}">' +
                            '<label for="chk_keyword_{{sortNum}}" class="chack"><span class="ico_comm">' +
                            '<input type="checkbox" id="chk_keyword_{{sortNum}}" class="blind"></span></label>' +
                            '</td>' +
                            '<td>{{sortNum}}</td>' +
                            '<td><img src="{{goodsImg02}}" alt=""></td>' +
                            '<td>{{goodsNm}}</td>' +
                            '<td>{{goodsNo}}</td>' +
                            '<td>{{brandNm}}</td>' +
                            '<td>{{sellerNm}}</td>' +
                            '<td class="comma">{{salePrice}}</td>' +
                            '<td class="comma">{{stockQtt}}</td>' +
                            '<td>{{goodsSaleStatusNm}}</td>' +
                            '<td>{{erpItmCode}}</td>' +
                            '<td>' +
                            '<img class="sort_up" src="../img/common/new/icon/order_up_btn.png" alt="">&nbsp;&nbsp;&nbsp;&nbsp;' +
                            '<img class="sort_down" src="../img/common/new/icon/order_down_btn.png" alt="">' +
                            '</td>' +
                            '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.extraData.goods_list, function(idx, obj) {
                            obj.goodsImg02 = '${_IMAGE_DOMAIN}' + obj.goodsImg02;
                            tr += templateMgr.render(obj);
                        });

                        $('#tbody_keyword_data').html(tr);
                        dfd.resolve(result.extraData.goods_list);

                        $('#cnt_total').text($('#tbody_keyword_data').children('tr').length);

                        $('#goods_search_empty').hide();
                        $('#goods_search_exist').show();

                        Dmall.common.comma();
                    });
                },
                initKeywordGoods: function() {
                    $('#tbody_keyword_data').html('');
                    $('#goods_search_empty').show();
                    $('#goods_search_exist').hide();
                },
                goodsSrch: function() {
                    Dmall.LayerPopupUtil.open($('#layer_popup_goods_select'));
                    GoodsSelectPopup._init(this.callbackApply);
                    $('#btn_popup_goods_search').trigger('click');
                },
                callbackApply: function(data) {
                    var $tbody = $('#tbody_keyword_data');
                    var index = $tbody.children('tr').length;

                    // 중복등록 검사
                    for(var i = 0; i < index; i++) {
                        if($tbody.children('tr').eq(i).find('input:hidden[name=insKeywordGoodsNoList]').prop('value') == data['goodsNo']) {
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }

                    if(index == 0) {
                        $('#goods_search_empty').hide();
                        $('#goods_search_exist').show();
                    }

                    var template =
                        '<tr id="tr_goods_'+data['goodsNo']+'">' +
                        '<td>' +
                        '<input type="hidden" name="insKeywordGoodsNoList" value="'+data['goodsNo']+'">' +
                        '<label for="chk_keyword_'+(index+1)+'" class="chack"><span class="ico_comm">' +
                        '<input type="checkbox" id="chk_keyword_'+index+'" class="blind"></span></label>' +
                        '</td>' +
                        '<td>'+(index+1)+'</td>' +
                        '<td><img src="${_IMAGE_DOMAIN}'+data['goodsImg02']+'" alt=""></td>' +
                        '<td>'+data['goodsNm']+'</td>' +
                        '<td>'+data['goodsNo']+'</td>' +
                        '<td>'+data['brandNm']+'</td>' +
                        '<td>'+data['sellerNm']+'</td>' +
                        '<td class="comma">'+data['salePrice']+'</td>' +
                        '<td class="comma">'+data['stockQtt']+'</td>' +
                        '<td>'+data['goodsSaleStatusNm']+'</td>' +
                        '<td>'+data['erpItmCode']+'</td>' +
                        '<td>' +
                        '<img class="sort_up" src="../img/common/new/icon/order_up_btn.png" alt="">&nbsp;&nbsp;&nbsp;&nbsp;' +
                        '<img class="sort_down" src="../img/common/new/icon/order_down_btn.png" alt="">' +
                        '</td>' +
                        '</tr>';

                    $tbody.append(template);

                    $('#cnt_total').html($tbody.children('tr').length);

                    Dmall.common.comma();
                },
                deleteGoods: function() {
                    var $tbody = $('#tbody_keyword_data');
                    $tbody.children('tr').each(function() {
                        if($(this).find('label[for^=chk_keyword_]').hasClass('on')) {
                            $(this).remove();
                        }
                    });

                    var cnt_total = $tbody.children('tr').length;
                    if(cnt_total == 0) {
                        $('#goods_search_empty').show();
                        $('#goods_search_exist').hide();
                        return;
                    }

                    for(var i = 0; i < cnt_total; i++) {
                        $tbody.children('tr').eq(i).children('td').eq(1).text(i+1);
                    }

                    $('#cnt_total').html(cnt_total);
                },
                keywordTreeReload: function() {
                    var url = '/admin/goods/keyword-list',
                        param = {};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        $('#keywordTree').jstree(true).settings.core.data = result;
                        $('#keywordTree').jstree(true).refresh();
                    });
                },
                sortUp: function($obj) {
                    var $tr = $obj.closest('tr');

                    if(!$tr.prev().is('tr')) {
                        return;
                    }

                    var orgTrIdx = $tr.find('td').eq(1).text();
                    var trIdx = $tr.prev().find('td').eq(1).text();

                    $tr.find('td').eq(1).text(trIdx);
                    $tr.prev().find('td').eq(1).text(orgTrIdx);

                    $tr.prev().before($tr);
                },
                sortDown: function($obj) {
                    var $tr = $obj.closest('tr');

                    if(!$tr.next().is('tr')) {
                        return;
                    }

                    var orgTrIdx = $tr.find('td').eq(1).text();
                    var trIdx = $tr.next().find('td').eq(1).text();

                    $tr.find('td').eq(1).text(trIdx);
                    $tr.next().find('td').eq(1).text(orgTrIdx);

                    $tr.next().after($tr);
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">키워드 상품 관리</h2>
            </div>
            <div class="line_box fri pb">
                <div class="cate_con">
                    <div class="cate_left">
                        <a href="#keywordInsLayer" class="bt--white btn--icon" id="keywordInsBtn">키워드 추가</a>
                        <a href="#" class="btn--white btn--small" id="delKeywordBtn">삭제</a>
                        <span class="br2"></span>
                        <div class="left_con">
                            <div id="keywordTree"></div>
                        </div>
                    </div>
                    <div class="cate_right">
                        <form action="" id="form_keyword_info">
                            <input type="hidden" name="keywordNo" id="keywordNo" />
                            <input type="hidden" name="keywordLvl" id="keywordLvl">
                            <input type="hidden" name="prKeywordLvl" id="prKeywordLvl">
                            <input type="hidden" name="prKeywordNo" id="prKeywordNo">
                            <input type="hidden" name="prKeywordNm" id="prKeywordNm">
                            <input type="hidden" name="goodsTypeCd" id="goodsTypeCd">
                            <div class="tblw tblmany" id="keywordInsDiv" style="display:none;">
                                <table>
                                    <colgroup>
                                        <col width="150px" />
                                        <col width="" />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>사용 여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn" value="Y"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>키워드 명</th>
                                        <td>
                                            <span class="intxt wid100p">
                                                <input type="text" name="keywordNm" id="keywordNm" maxlength="10">
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>상품 선택</th>
                                        <td id="goods_search_empty">
                                            <span class="btn_box">
                                                <button type="button" id="apply_goods_srch_btn" class="btn--black_small goods" onclick="KeywordUtil.goodsSrch();">상품 검색</button>
                                            </span>
                                        </td>
                                        <td id="goods_search_exist" style="display:none;">
                                            <div class="top_lay">
                                                <div class="select_btn_left">
                                                    <a href="#none" class="btn_gray2" id="a_id_delete" onclick="KeywordUtil.deleteGoods();">삭제</a>
                                                </div>
                                                <div class="select_btn_right">
                                                    <span class="search_txt">
                                                        총 <strong class="all" id="cnt_total"></strong>개의 상품이 등록되었습니다.
                                                    </span>
                                                    <span class="btn_box">
                                                        <a href="#none" class="btn--black_small goods" onclick="KeywordUtil.goodsSrch();">상품 찾기</a>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="tblh">
                                                <table>
                                                    <colgroup>
                                                        <col width="50px">
                                                        <col width="50px">
                                                        <col width="100px">
                                                        <col width="14%">
                                                        <col width="">
                                                        <col width="">
                                                        <col width="">
                                                        <col width="">
                                                        <col width="">
                                                        <col width="">
                                                        <col width="">
                                                        <col width="105px">
                                                    </colgroup>
                                                    <thead>
                                                    <tr>
                                                        <th>
                                                            <label for="all_check" class="chack">
                                                                <span class="ico_comm"><input type="checkbox" name="table" id="all_check"></span>
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
                                                        <th>비고</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="tbody_keyword_data"></tbody>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="reg_btn">저장</button>
                </div>
            </div>
        </div>
        <%@ include file="KeywordInsertLayerPop.jsp" %>
        <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
    </t:putAttribute>
</t:insertDefinition>
