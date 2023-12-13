<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
        <script>
        
        //자주쓰는 배송지 목록 레이어 팝업 실행
        function openDeliveryLayer(memberNo){
            $("#memberNoDelivery").val(memberNo);
            selectDeliveryList();
        }
        
        //자주쓰는 배송지 리스트 조회
        function selectDeliveryList(){
            if(Dmall.validate.isValid('form_id_delivery_select')) {
                
                var url = '/admin/member/manage/frequently-delivery-list',
                    param = $('#form_id_delivery_select').serialize(), 
                    callback = deliveryListAppend || function() {

                    };
                Dmall.AjaxUtil.getJSON(url, param, callback);
            }
        }
        
        //자주쓰는 배송지 리스트 테이블에 입력
        function deliveryListAppend(result){
            var tbody = '';
            if(result.totalRows == 0){
                tbody = '<tr><td colspan = "7">등록하신 자주쓰는 배송지가 없습니다.</td></tr>'                
            }else{
                tbody = '', 
                template = new Dmall.Template('<tr><td>{{rownum}}</td><td>{{frgGb}}</td><td>{{gbNm}}</td><td>{{adrsNm}}</td><td class="txtl">{{addr}}</td><td>{{tel}}</td><td>{{mobile}}</td></tr>');
                jQuery.each(result.resultList, function(idx, obj) {
                    tbody += template.render(obj);
                });
            }
            $('#deliveryListTbody').html(tbody);
            
            Dmall.GridUtil.appendPaging('form_id_delivery_select', 'delivery_list_paging', result, 'paging_id_manager', selectDeliveryList);
        }
        
        </script>
    <!-- layer_popup1 -->
    <div id="deliveryListLayout" class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">자주 쓰는 배송지 </h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <!-- tblh -->
                    <form id="form_id_delivery_select" >
                    <input type="hidden" id="memberNoDelivery" name="memberNo" />
                    <div class="tblh mt0">
                        <table summary="이표는 자주 쓰는 배송지 리스트 표 입니다. 구성은 번호, 해외/국내, 배송지설명, 받는분, 유선전화, 주소, 휴대폰 입니다.">
                            <caption>자주 쓰는 배송지 리스트</caption>
                            <colgroup>
                                <col width="6%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="34%">
                                <col width="15%">
                                <col width="15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>해외/국내</th>
                                    <th>배송지설명</th>
                                    <th>받는분</th>
                                    <th>주소</th>
                                    <th>유선전화</th>
                                    <th>휴대폰</th>
                                </tr>
                            </thead>
                            <tbody id="deliveryListTbody"></tbody>
                        </table>
                    </div>
                    </form>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay" id="delivery_list_paging"></div>
                    <!-- //bottom_lay -->
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
