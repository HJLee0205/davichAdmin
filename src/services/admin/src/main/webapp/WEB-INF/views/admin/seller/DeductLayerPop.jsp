<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
        <script>
        
        //정산 공제목록 레이어 팝업 실행
        function openDeductLayer(calculateNo){
            $("#calculateNo").val(calculateNo);
            selectDeductList();
            Dmall.common.comma();
        }
        
        //정산 공제목록 조회
        function selectDeductList(){
            if(Dmall.validate.isValid('form_id_deduct_select')) {
                
                var url = '/admin/seller/calc-deduct-list',
                    param = $('#form_id_deduct_select').serialize(), 
                    callback = deductListAppend || function() {
                    };
                Dmall.AjaxUtil.getJSON(url, param, callback);
            }
        }
        
        //정산 공제목록 테이블에 입력
        function deductListAppend(result){
            if(result.length == 0){
            	var ept = [0,0,0,0];
                jQuery.each(ept, function(idx, obj) {
					$("input[name=deductNo" + (1 + idx) + "]").val(1 + idx);                	
					$("input[name=deductAmt" + (1 + idx) + "]").val("");                	
					$("input[name=deductDscrt" + (1 + idx) + "]").val("");                	
					$("label[for=srch_id_taxGbCd" + (1 + idx) + "_1]").removeClass("on");
					$("label[for=srch_id_taxGbCd" + (1 + idx) + "_2]").removeClass("on");
                });
                $("#inputGbn").val("I");
            }else{
                jQuery.each(result, function(idx, obj) {
					$("input[name=deductNo" + (1 + idx) + "]").val(obj.deductNo);                	
					$("input[name=deductAmt" + (1 + idx) + "]").val(obj.deductAmt);                	
					$("input[name=deductDscrt" + (1 + idx) + "]").val(obj.deductDscrt);                	
					
					if (obj.taxGbCd == "1") {
						$("label[for=srch_id_taxGbCd" + (1 + idx) + "_1]").removeClass("on").addClass("on");
					} else if (obj.taxGbCd == "2") {
						$("label[for=srch_id_taxGbCd" + (1 + idx) + "_2]").removeClass("on").addClass("on");
					}
                });
                $("#inputGbn").val("U");
            }
        }
        
        $(document).on('click', '#btn_save', function(){
            var url = '/admin/seller/calc-deduct-save',
            	param = {};
            
            for(var idx = 0; idx <4 ; idx++) {
            	param['list[' + idx + '].calculateNo'] = $("#calculateNo").val();
            	param['list[' + idx + '].deductNo'] = $("input[name=deductNo" + (1 + idx) + "]").val();
            	param['list[' + idx + '].deductGbCd'] = $("input[name=deductGbCd" + (1 + idx) + "]").val();
            	param['list[' + idx + '].deductAmt'] = $("input[name=deductAmt" + (1 + idx) + "]").val();
            	param['list[' + idx + '].deductDscrt'] = $("input[name=deductDscrt" + (1 + idx) + "]").val();
            	param['list[' + idx + '].inputGbn'] = $("#inputGbn").val();
            	
            	if ($("label[for=srch_id_taxGbCd" + (1 + idx) + "_1]").hasClass("on")) {
                	param['list[' + idx + '].taxGbCd'] = "1";
            	} else if ($("label[for=srch_id_taxGbCd" + (1 + idx) + "_2]").hasClass("on")) {
                	param['list[' + idx + '].taxGbCd'] = "2";
            	}
            }
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                Dmall.validate.viewExceptionMessage(result, 'form_id_deduct_select');
                
                if(result.success){
                    Dmall.LayerPopupUtil.close("deductLayout");
                    selectManagerList();
                }
            });        	
        });

        
        </script>
    <!-- layer_popup1 -->
    <div id="deductLayout" class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">정산상세</h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <!-- tblh -->
                    <form id="form_id_deduct_select" >
                    <input type="hidden" id="calculateNo" name="calculateNo" />
                    <input type="hidden" id="inputGbn" name="inputGbn" />
                    <div class="tblh mt0">
                        <table summary="정산 상세 목록입니다.. ">
                            <caption>정산 상세 리스트</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="20%">
                                <col width="45%">
                                <col width="20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>금액</th>
                                    <th>적요</th>
                                    <th>과세/면세</th>
                                </tr>
                            </thead>
                            <tbody id="deductListTbody">
                                <tr>
                                    <td rowspan="2">공제(+)</td>
                                    <td><span class="intxt"><input class="txtr comma" type="text" name="deductAmt1" value="" /></span>
                                    </td>
                                    <td><span class="intxt long"><input type="text" name="deductDscrt1" value="" /></span></td>
                                    <td>
                                		<input type="hidden" name="deductNo1" value="" />
                                		<input type="hidden" name="deductGbCd1" value="1" />
                                    	<tags:radio name="taxGbCd1"  idPrefix="srch_id_taxGbCd1" codeStr="1:과세;2:면세"/>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td><span class="intxt"><input class="txtr comma" type="text" name="deductAmt2" value="" /></span></td>
                                    <td><span class="intxt long"><input type="text" name="deductDscrt2" value="" /></span></td>
                                    <td>
                                		<input type="hidden" name="deductNo2" value="" />
                                		<input type="hidden" name="deductGbCd2" value="1" />
                                    	<tags:radio name="taxGbCd2"  idPrefix="srch_id_taxGbCd2" codeStr="1:과세;2:면세"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td rowspan="2">공제(-)</td>
                                    <td><span class="intxt"><input class="txtr comma" type="text" name="deductAmt3" value="" /></span></td>
                                    <td><span class="intxt long"><input type="text" name="deductDscrt3" value="" /></span></td>
                                    <td>
                                		<input type="hidden" name="deductNo3" value="" />
                                		<input type="hidden" name="deductGbCd3" value="2" />
                                    	<tags:radio name="taxGbCd3"  idPrefix="srch_id_taxGbCd3" codeStr="1:과세;2:면세"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="intxt"><input class="txtr comma" type="text" name="deductAmt4" value="" /></span></td>
                                    <td><span class="intxt long"><input type="text" name="deductDscrt4" value="" /></span></td>
                                    <td>
                                		<input type="hidden" name="deductNo4" value="" />
                                		<input type="hidden" name="deductGbCd4" value="2" />
                                    	<tags:radio name="taxGbCd4"  idPrefix="srch_id_taxGbCd4" codeStr="1:과세;2:면세"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </form>
                    <div class="btn_box txtc">
                        <button type="button" class="btn green" id="btn_save" >저장</button>
                    </div>                    
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
