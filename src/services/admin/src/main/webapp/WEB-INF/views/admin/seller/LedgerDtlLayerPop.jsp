<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
        <script>
        
        //정산 상세 목록 레이어 팝업 실행
        function openLedgerDtlLayer(calculateNo){
            $("#calculateNo").val(calculateNo);
            selectLedgerDtlList();
        }
        
        //정산 상세 리스트 조회
        function selectLedgerDtlList(){
            if(Dmall.validate.isValid('form_id_ledger_select')) {
                
                var url = '/admin/seller/calc-dtl-list',
                    param = $('#form_id_ledger_select').serialize(), 
                    callback = ledgerListAppend || function() {
                    };
                Dmall.AjaxUtil.getJSON(url, param, callback);
            }
        }
        
        //정산 상세 리스트 테이블에 입력
        function ledgerListAppend(result){
            var tbody = '';
            if(result.totalRows == 0){
                tbody = '<tr><td colspan = "7">검색된 데이터가 존재하지 않습니다.</td></tr>'                
            }else{
                var tmp = '<tr><td>{{rownum}}</td>'
        			   + '<td>{{buyDecideDttm}}</td>'	 
        			   + '<td>{{ordNo}}</td>'	 
        			   + '<td>{{ordDtlSeq}}</td>'	 
        			   + '<td>{{goodsNm}}</td>'	 
        			   + '<td>{{purchaseAmt}}</td>'	 
        			   + '<td>{{ordQtt}}</td>'	 
        			   + '<td>{{taxGbNm}}</td>'	 
        			   + '<td>{{dlvrAmt}}</td></tr>';	 
            	
                tbody = '', 
                template = new Dmall.Template(tmp);
                jQuery.each(result.resultList, function(idx, obj) {
                    tbody += template.render(obj);
                });
            }
            $('#ledgerListTbody').html(tbody);
            
            Dmall.GridUtil.appendPaging('form_id_ledger_select', 'ledger_list_paging', result, 'paging_id_manager', selectLedgerDtlList);
        }
        
        </script>
    <!-- layer_popup1 -->
    <div id="ledgerDtlLayout" class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">정산상세</h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <!-- tblh -->
                    <form id="form_id_ledger_select" >
                    <input type="hidden" id="calculateNo" name="calculateNo" />
                    <div class="tblh mt0">
                        <table summary="정산 상세 목록입니다.. ">
                            <caption>정산 상세 리스트</caption>
                            <colgroup>
                                <col width="6%">
                                <col width="10%">
                                <col width="14%">
                                <col width="10%">
                                <col width="20%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>구매확정일자</th>
                                    <th>주문번호</th>
                                    <th>주문상세번호</th>
                                    <th>상품명</th>
                                    <th>공급가액</th>
                                    <th>수량</th>
                                    <th>과세구분</th>
                                    <th>배송비</th>
                                </tr>
                            </thead>
                            <tbody id="ledgerListTbody"></tbody>
                        </table>
                    </div>
                    </form>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay" id="ledger_list_paging"></div>
                    <!-- //bottom_lay -->
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
