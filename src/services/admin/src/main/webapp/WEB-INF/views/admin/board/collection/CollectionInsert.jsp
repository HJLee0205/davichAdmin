<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2022/12/16
  Time: 1:51 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <t:putAttribute name="title">컬렉션 관리 > 게시물</t:putAttribute>
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
        <script type="text/javascript" src="/admin/js/lib/jquery/jquery.qrcode.min.js"></script>
        <script>
            $(document).ready(function() {
                // 이미지 첨부 시 미리보기 이미지 표시
                $('input[type=file]').change(function() {
                    var name = $(this).attr('name');

                    if($(this)[0].files.length < 1) {
                        $(this).closest('label').prev().children('input.upload-name').val('');
                        $('.preview_'+ name).html('');
                    }

                    if(this.files && this.files[0]) {
                        var fileNm = this.files[0].name;
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            var template =
                                '<span class="txt">' + fileNm + '</span>' +
                                '<button class="cancel">삭제</button><br/>' +
                                '<img src="' + e.target.result + '" alt="미리보기 이미지">';
                            $('.preview_' + name).html(template);
                        };
                        reader.readAsDataURL(this.files[0]);
                    }
                });

                // 이미지 삭제 버튼 클릭
                $('.upload_file').on('click', '.cancel', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var obj = $(e.target).parents('.upload_file');
                    var strIdx = obj.attr('class').lastIndexOf('file');
                    var name = obj.attr('class').substring(strIdx, strIdx + 5);
                    $('input[name=' + name + ']').val('');
                    obj.html('');
                });

                // 상품 삭제 버튼 클릭
                $('#btn_check_delete').on('click', function(e) {
                    $('#tbody_recommend_data').children('tr').each(function() {
                        if($(this).find('label[for^=chk_recommendNo_]').hasClass('on')) {
                            $(this).remove();
                        }
                    });
                    var $sel_expt_goods_list = $("#tbody_recommend_data");
                    var cnt_total = $sel_expt_goods_list.children('tr').length - 1;

                    for(var i = 0; i <= cnt_total; i++){
                        $sel_expt_goods_list.children('tr').eq(i).children('td').eq(1).text(i);
                    }

                    $("#cnt_total").html(cnt_total);

                    if(cnt_total === 0){
                        $("#goods_search_empty").show();
                        $("#goods_search_exist").hide();
                    }
                });

                // 목록 버튼 클릭
                $('#viewBbsLettList').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var param = { bbsId: $('#bbsId').val() };
                    Dmall.FormUtil.submit('/admin/board/letter', param);
                });

                // 저장 버튼 클릭
                $('#bbsLettListInsert').on('click',function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var url = '/admin/board/board-letter-insert';

                    $('#form_collection_info').ajaxSubmit({
                        url: url,
                        dataType: 'json',
                        success: function(result) {
                            if(result.success) {
                                var param = { bbsId: $('#bbsId').val() };
                                Dmall.LayerUtil.alert(result.message).done(function() {
                                    Dmall.FormUtil.submit('/admin/board/letter', param);
                                });
                            } else {
                                Dmall.LayerUtil.alert(result.message);
                            }
                        }
                    });
                });

                // 상단 이동
                $(document).on('click', 'img.sort_up', function () {
                    var $tr = $(this).closest('tr');

                    if(!$tr.prev().is('tr')) {
                        return;
                    }

                    var orgTrIdx = $tr.find('td').eq(1).text();
                    var trIdx = $tr.prev().find('td').eq(1).text();

                    $tr.find('td').eq(1).text(trIdx);
                    $tr.prev().find('td').eq(1).text(orgTrIdx);

                    $tr.prev().before($tr);
                });

                // 하단 이동
                $(document).on('click', 'img.sort_down', function () {
                    var $tr = $(this).closest('tr');

                    if(!$tr.next().is('tr')) {
                        return;
                    }

                    var orgTrIdx = $tr.find('td').eq(1).text();
                    var trIdx = $tr.next().find('td').eq(1).text();

                    $tr.find('td').eq(1).text(trIdx);
                    $tr.next().find('td').eq(1).text(orgTrIdx);

                    $tr.next().after($tr);
                });

                //qrcode
                $('#qrcodeCanvas').qrcode({
                    width: 100,
                    height: 100,
                    text: "https://devnewmarket.fittingmonster.com/collection/${so.lettNo}"
                });
            });

            // 상품찾기 버튼 클릭
            function fn_goods_srch(obj) {
                Dmall.LayerPopupUtil.open($('#layer_popup_goods_select'));
                GoodsSelectPopup._init(fn_callback_pop_apply_goods);
                $('#btn_popup_goods_search').trigger('click');
            }

            // 상품찾기 팝업 콜백
            function fn_callback_pop_apply_goods(data) {
                var $sel_apply_goods_list = $("#tbody_recommend_data");

                // 상품 등록 갯수 제한
                if($sel_apply_goods_list.children('tr').length > 10) {
                    Dmall.LayerUtil.alert('상품은 10개 이상 등록할 수 없습니다.');
                    return false;
                }

                // 선택 중복 체크
                for(var i = 0; i <= $sel_apply_goods_list.children('tr').length; i++){
                    if( $sel_apply_goods_list.children('tr').children('td').children('label').children('span').children('input').eq(i).prop('value') == data['goodsNo']){
                        Dmall.LayerUtil.alert("이미 선택하셨습니다");
                        return false;
                    }
                }
                var index = $sel_apply_goods_list.children('tr').length;
                console.log("fn_callback_pop_apply_keyword_goods index = ", index);
                if(index === 1){
                    $("#goods_search_empty").hide();
                    $("#goods_search_exist").show();
                }

                var template  =
                    '<tr id="tr_goods_' + data["goodsNo"] + '" class="searchGoodsResult">'+
                    '<td>' +
                    '<input type="hidden" name="recommendNo" value="' + data["goodsNo"] + '">' +
                    '<label for="chk_recommendNo_' + index + '" class="chack"><span class="ico_comm">' +
                    '<input type="checkbox" id="chk_recommendNo_' + index + '" class="blind">' +
                    '</span></label></td>'+
                    '<td>' + index + '</td>'+
                    '<td><img src="${_IMAGE_DOMAIN}' + data["goodsImg02"] + '"></td>'+
                    '<td>' + data["goodsNm"] + '</td>'+
                    '<td>' + data["goodsNo"] + '</td>'+
                    '<td>' + (!data["brandNm"] ? '' : data["brandNm"]) + '</td>'+
                    '<td>' + data["sellerNm"] + '</td>'+
                    '<td>' + Dmall.common.numberWithCommas(data["salePrice"]) + '</td>'+
                    '<td>' + Dmall.common.numberWithCommas(data["supplyPrice"]) + '</td>'+
                    '<td>' + Dmall.common.numberWithCommas(data["stockQtt"]) + '</td>'+
                    '<td>' + data["goodsSaleStatusNm"] + '</td>'+
                    '<td>' + (!data["erpItmCode"] ? '' : data["erpItmCode"]) + '</td>' +
                    '<td>' +
                    '<img src="../img/common/new/icon/order_up_btn.png" alt="" class="sort_up">&nbsp;&nbsp;&nbsp;&nbsp;' +
                    '<img src="../img/common/new/icon/order_down_btn.png" alt="" class="sort_down">' +
                    '</td>'+
                    '</tr>';

                $sel_apply_goods_list.append(template);

                // 총 갯수 처리
                var cnt_total = index;
                $("#cnt_total").html(cnt_total);
            }

            // qrcode 다운로드 버튼 클릭
            function qrcode_download(obj) {
                if($('#qrcodeWidth').val() == '' || $('#qrcodeHeight').val() == '') {
                    Dmall.LayerUtil.alert('사이즈를 지정해주세요.');
                    var div = document.createElement('div');
                    $(div).qrcode({
                        width: $('#qrcodeWidth').val(),
                        height: $('#qrcodeHeight').val(),
                        text: ''
                    });
                    var canvas = $(div).find('canvas');
                    var img = canvas.get(0).toDataURL('image/png');
                    var link = document.createElement('a');

                    link.download = '';
                    link.href = img;
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                    delete link;
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">컬렉션 관리</h2>
            </div>
            <!-- line_box -->
            <form id="form_collection_info" method="post">
                <input type="hidden" name="bbsId" id="bbsId" value="${so.bbsId}"/>
                <input type="hidden" name="lettNo" value="${so.lettNo}">
                <div class="line_box fri pb ofh">
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 컬렉션 등록 표입니다. 구성은 상품분류,컬렉션 명,컬렉션 설명,컬렉션 대표미이미지, 내지 이미지, 컬렉셔 상품 설정,QR코드 입니다.">
                            <caption>
                                상품 기본정보
                            </caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>상품 분류</th>
                                <td>
                                    <span class="select">
                                        <select name="goodsTypeCd">
                                            <tags:option codeStr=":선택;01:안경테;02:선글라스;04:콘택트렌즈"/>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>컬렉션 명</th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="title">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>컬렉션 설명</th>
                                <td>
                                    <div class="txt_area">
                                        <textarea name="content" maxlength="300"></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>컬렉션 대표 이미지</th>
                                <td>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file0" type="file" accept="image/*">
                                    </label>
                                    <div class="desc_txt br2 ">
                                        · 파일 첨부 시 10MB 이하 업로드 (jpg / png / gif / bmp)<br>
                                        <em class="point_c6">· 860px X 860px 사이즈로 등록하여 주세요.</em>
                                    </div>
                                    <div class="upload_file preview_file0"></div>
                                </td>
                            </tr>
                            <tr>
                                <th>컬렉션 내지 이미지</th>
                                <td>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" readonly></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file1" type="file" accept="image/*">
                                    </label>
                                    <div class="desc_txt br2 ">
                                        · 파일 첨부 시 10MB 이하 업로드 (jpg / png / gif / bmp)<br>
                                        <em class="point_c6">· 860px X 860px 사이즈로 등록하여 주세요.</em>
                                    </div>
                                    <div class="upload_file preview_file1"></div>
                                    <span class="br"></span>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file2" type="file" accept="image/*">
                                    </label>
                                    <div class="upload_file preview_file2"></div>
                                    <span class="br"></span>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file3" type="file" accept="image/*">
                                    </label>
                                    <div class="upload_file preview_file3"></div>
                                    <span class="br"></span>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file4" type="file" accept="image/*">
                                    </label>
                                    <div class="upload_file preview_file4"></div>
                                    <span class="br"></span>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file5" type="file" accept="image/*">
                                    </label>
                                    <div class="upload_file preview_file5"></div>
                                    <span class="br"></span>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file6" type="file" accept="image/*">
                                    </label>
                                    <div class="upload_file preview_file6"></div>
                                    <span class="br"></span>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file7" type="file" accept="image/*">
                                    </label>
                                    <div class="upload_file preview_file7"></div>
                                    <span class="br"></span>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file8" type="file" accept="image/*">
                                    </label>
                                    <div class="upload_file preview_file8"></div>
                                    <span class="br"></span>
                                    <span class="intxt imgup2"><input class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on">파일첨부
                                        <input class="filebox" name="file9" type="file" accept="image/*">
                                    </label>
                                    <div class="upload_file preview_file9"></div>
                                </td>
                            </tr>
                            <tr>
                                <th>컬렉션 상품 설정</th>
                                <td id="goods_search_empty">
                                    <button type="button" class="btn--black_small goods" onclick="fn_goods_srch(this)">상품 찾기</button>
                                </td>
                                <td id="goods_search_exist" style="display: none; max-height: 500px;">
                                    <div class="top_lay">
                                        <div class="select_btn_left">
                                            <a href="#none" class="btn_gray2" id="btn_check_delete">삭제</a>
                                        </div>
                                        <div class="select_btn_right">
                                            <span class="search_txt">
                                                총 <strong class="be" id="cnt_total">2</strong>개의 상품이 등록되었습니다.
                                            </span>
                                            <span class="btn_box">
                                                <button type="button" class="btn--black_small goods" onclick="fn_goods_srch(this)">상품 찾기</button>
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
                                                <col width="">
                                                <col width="115px">
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
                                                <th>공급가</th>
                                                <th>재고</th>
                                                <th>판매상태</th>
                                                <th>다비전<br>상품코드</th>
                                                <th>비고</th>
                                            </tr>
                                            </thead>
                                            <tbody id="tbody_recommend_data">
                                            <tr id="tr_goods_data_template" style="display: none;">
                                                <td data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsChkBox">
                                                    <label for="chk_select_goods_template" class="chack"><span class="ico_comm"><input type="checkbox" id="chk_select_goods_template" class="blind">&nbsp;</span></label>
                                                </td>
                                                <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="rownum" >1</td>
                                                <td><img src="" data-bind="goodsInfo" data-bind-type="img" data-bind-value="goodsImg01"></td>
                                                <td class="txtl" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setGoodsDetail" data-bind-value="goodsNm"></td>
                                                <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNo">상품코드</td>
                                                <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="brandNm" >브렌드명</td>
                                                <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sellerNm" >판매자명</td>
                                                <td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSalePrice"  data-bind-value="salePrice" data-validation-engine="validate[required, maxSize[10]]" maxlength="10"></td>
                                                <td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSupplyPrice"  data-bind-value="supplyPrice" data-validation-engine="validate[required, maxSize[10]]" maxlength="10"></td>
                                                <td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setStockQtt"  data-bind-value="stockQtt" data-validation-engine="validate[required, maxSize[10]]" maxlength="10"></td>
                                                <td data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusText">
                                                    <input type="hidden" data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusInput">
                                                </td>
                                                <c:if test="${sellerNo eq '1'}">
                                                    <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
                                                </c:if>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>SEO 검색용 태그</th>
                                <td>
                                    <label for="" class="txt_area w100p">
                                        <textarea name="seoSearchWord" maxlength="300"></textarea>
                                    </label>
                                    <p class="desc_txt br2">&#183; 쉼표 (,)로 구분하여 등록해주세요. ex) 안경, 안경테, 안경렌즈</p>
                                </td>
                            </tr>
                            <tr>
                                <th>게시물 노출 여부</th>
                                <td>
                                    <tags:radio codeStr="01:전체공개;04:비공개;" name="dispGbCd" idPrefix="radio_id_dispGbCd"/>
                                </td>
                            </tr>
                            <tr>
                                <th>QR코드</th>
                                <td class="txtl qrcode">
                                    <span id="qrcodeCanvas"></span>
                                    <br>
                                    <span>
                                        <input type="text" id="qrcodeWidth" value="100" class="ml5 mr10">
                                        <img src="/admin/img/common/btn_close_popup02.png" alt="" class="icon_close ml5 mr5">
                                        <input type="text" id="qrcodeHeight" value="100" class="mr5">
                                        <button type="button" class="btn--black_small f-en" onclick="qrcode_download(this);">
                                            download
                                        </button>
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
            <!-- //line_box -->
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="viewBbsLettList">목록</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="bbsLettListInsert">저장</button>
            </div>
        </div>
        <!-- //bottom_box -->
        <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp"/>
    </t:putAttribute>
</t:insertDefinition>