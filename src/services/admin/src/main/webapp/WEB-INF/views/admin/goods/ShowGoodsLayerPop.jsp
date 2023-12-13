<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
        <script>
        $(document).ready(function() {
            
            // 상품 정렬 클릭 이벤트
            $(document).on('change', "input:radio[name='expsGoodsSortCd']", function(e) {
                var sortType = $(this).val();
                
                if(sortType == "6"){
                    selectCtgGoodsList();
                    $("#ctgGoodsDiv").show();
                }else{
                    $("#ctgGoodsDiv").hide();
                }
                
            });
            
            // 판매상태>품절 체크박스 클릭 이벤트
            $('#soldoutGoodsYn').parents('label').on('click', function(e) {
//                 $(this).toggleClass('on');
                $('input[name="soldoutGoodsExpsYn"]').prop("checked",false);
                
                var checked = !($("input[name='soldoutGoodsYn']").prop('checked'));
                if(checked){
                    $("#radioBtnLabel").show();
                }else{
                    $("#radioBtnLabel").hide();
                }
            });
            
            // 즉시 전시, 즉시 미전시 이벤트 처리
            $(document).on('click', 'button.dispBtn', function(e){
                Dmall.EventUtil.stopAnchorAction(e);
                
                var dispType = $(this).attr("id");
                var goodsNoVal = $(this).parents('tr').data('goods-no');
                var ctgNo = $("#ctgNo").val();
                var dispYn = "";
                if(dispType == "dispBtn"){
                    dispYn = "Y";
                }else{
                    dispYn = "N";
                }
                
                var url = '/admin/goods/goods-display-update',
                param = {dispYn:dispYn,goodsNo:goodsNoVal,ctgNo:ctgNo};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_showgoods');
                    selectCtgGoodsList();
                });
            });
            
            // 노출 상품 관리 수정
            $(document).on('click', '#showGoodsUpdateBtn', function(e){
                Dmall.EventUtil.stopAnchorAction(e);
                var sortType = $(":radio[name='expsGoodsSortCd']:checked").val();
                
                //유효성 검사
                if(sortType != "6"){
                    if(!$('input:checkbox[name="dispGoodsExpsYn"]').is(":checked") && !$('input:checkbox[name="noDispGoodsExpsYn"]').is(":checked")){
                        Dmall.LayerUtil.alert("전시 유형을 선택하여 주십시오.");
                        return;
                    }
                    if(!$('input:checkbox[name="salemediumGoodsExpsYn"]').is(":checked") && !$('input:checkbox[name="salestnbyGoodsExpsYn"]').is(":checked") && !$('input:checkbox[name="soldoutGoodsYn"]').is(":checked")){
                        Dmall.LayerUtil.alert("판매 상태를 선택하여 주십시오.");
                        return;
                    }
                    if($('input:checkbox[name="soldoutGoodsYn"]').is(":checked")){
                        if(!$('input:radio[name="soldoutGoodsExpsYn"]').is(":checked")){
                            Dmall.LayerUtil.alert("품절 상품 노출 여부를 선택하여 주십시오.");
                            return;
                        }
                    }
                }
                
                $("#ctgNoUpdate").val($("#ctgNo").val());
                var url = '/admin/goods/goods-show-update',
                param = param = $('#form_id_showgoods').serialize();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'form_id_showgoods');
                    selectCtgGoodsList();
                });
            });
            
        });
        
        
        //해당 카테고리 상품 전체 조회
        function selectCtgGoodsList(){
            if(Dmall.validate.isValid('form_id_showgoods')) {
                $("#ctgGoodsTbody").empty();
                var url = '/admin/goods/category-rank-status',
                param = {ctgNo:$("#ctgNo").val()}; 
                
                Dmall.AjaxUtil.getJSON(url, param, function(result){
                    if(result.length > 0){
                        var goodsLi = '', 
                        template = new Dmall.Template(
                                '<tr class="updw_con" data-goods-no="{{goodsNo}}">'+
                                    '<input type="hidden" name="goodsNoArr" value="{{goodsNo}}">'+
                                    '<input type="hidden" name="dispYnArr" value="{{dispYn}}">'+
                                    '<input type="hidden" name="dlgtCtgYnArr" value="{{dlgtCtgYn}}">'+
                                    '<td>' +  
                                        '<button type="button" class="up_btn btn_comm move up">위로</button>'+
                                        '<span class="br2"></span>'+
                                        '<button type="button" class="down_btn btn_comm move dn">아래로</button>'+
                                    '</td>'+
                                    '<td class="txtl">' +
                                        '<img src="http://www.davichmarket.com/admin/img/product/tmp_img02.png" width="52" height="52" alt="" />{{goodsNm}}' +
                                    '</td>'+
                                    '<td class="comma">{{salePrice}}원</td>'+
                                    '<td>{{goodsSaleStatusNm}}</td>'+
                                    '<td>{{dispNm}}</td>'+
                                    '<td>{{buyCnt}}</td>'+
                                    '<td>' +
                                        '<button type="button" class="btn_gray dispBtn" id="dispBtn">즉시전시</button>' +
                                        '<span class="br2"></span>'+
                                        '<button type="button" class="btn_gray dispBtn" id="noDispBtn">즉시미전시</button>'+
                                    '</td>'+
                                 '</tr>');
                        $.each(result, function(idx, obj) {
                            goodsLi += template.render(obj);
                        });

                        $("#ctgGoodsTbody").html(goodsLi);
                        $("#ctgGoodsDiv").show();
                        Dmall.common.comma();
                    }
                });
            }
        }
        
        
        </script>
    <!-- layer_popup1 -->
    <div id="goodsLayout" class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">노출상품관리</h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <form id="form_id_showgoods" >
            <input type="hidden" name="ctgNo" id="ctgNoUpdate" />
            <div class="pop_con">
                <div>
                    <!-- search_box -->
                    <div class="search_box tblmany">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 노출상품관리 표 입니다. 구성은 전시유형, 상품노출(판매상태, 상품정렬) 입니다.">
                                <caption>노출상품관리</caption>
                                <colgroup>
                                    <col width="14%">
                                    <col width="14%">
                                    <col width="72%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>전시유형</th>
                                        <td colspan="2">
                                            <tags:checkbox name="dispGoodsExpsYn" id="dispGoodsExpsYn" value="Y" compareValue="" text="전시" />
                                            <tags:checkbox name="noDispGoodsExpsYn" id="noDispGoodsExpsYn" value="Y" compareValue="" text="미전시" />
                                            <a href="#none" onclick="chack_btnall(this);" class="all_choice"><span class="ico_comm"></span> 전체</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th rowspan="2">상품노출</th>
                                        <th>판매상태</th>
                                        <td>
                                            <tags:checkbox name="salemediumGoodsExpsYn" id="salemediumGoodsExpsYn" value="Y" compareValue="" text="판매중" />
                                            <tags:checkbox name="salestnbyGoodsExpsYn" id="salestnbyGoodsExpsYn" value="Y" compareValue="" text="판매대기" />
                                            <tags:checkbox name="soldoutGoodsYn" id="soldoutGoodsYn" value="Y" compareValue="" text="품절" />
                                            <label id="radioBtnLabel">(<tags:radio name="soldoutGoodsExpsYn" codeStr="Y:품절상품 노출;N:품절상품 미노출" idPrefix="soldoutGoodsExpsYn" value="" />)</label>
                                        </td>
                                    </tr>
                                    <tr id="goodsSort">
                                        <th>상품정렬</th>
                                        <td>
                                            <tags:radio name="expsGoodsSortCd" codeStr="1:인기순;2:최근등록순;3:판매인기순;4:낮은가격순;5:상품평 많은순;6:상품 정렬 순서 별도 지정" idPrefix="expsGoodsSortCd" value="" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                    </div>
                    <!-- //search_box -->
                    <ul class="desc_txt">
                        <li>* 판매 중지 상태의 상품 사용자 화면에 노출되지 않습니다.</li>
                        <li>* 품절 상품의 경우 사용자 화면 해당 카테고리 맨 뒤로 노출됩니다.</li>
                    </ul>
                    <!-- tblh -->
                    <div class="tblh tblmany line_no mt0" id="ctgGoodsDiv" style="display:none;">
                        <table summary="이표는 노출상품관리 리스트 표 입니다. 구성은 선택, 상품명, 판매가격, 판매상태, 전시상태, 주문건수, 전시처리 입니다.">
                            <caption>노출상품관리 리스트</caption>
                            <colgroup>
                                <col width="10%">
                                <col width="26%">
                                <col width="15%">
                                <col width="14%">
                                <col width="10%">
                                <col width="10%">
                                <col width="14%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>선택</th>
                                    <th>상품명</th>
                                    <th>판매가격</th>
                                    <th>판매상태</th>
                                    <th>전시상태</th>
                                    <th>주문건수</th>
                                    <th>전시처리</th>
                                </tr>
                            </thead>
                            <tbody id="ctgGoodsTbody"></tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <div class="btn_box txtc">
                        <button class="btn green" type="button" id="showGoodsUpdateBtn">적용하기</button>
                    </div>
                </div>
            </div>
            </form>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
