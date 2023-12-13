<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
    <script>
        $(document).ready(function() {
            
            //숫자, 하이폰(-) 만 입력가능
            $(document).on("keyup", "input:text[datetimeOnly]", function() {$(this).val( $(this).val().replace(/[^0-9\-]/gi,"") );});
            //숫자만 입력가능
            $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
            //영문만 입력가능
            $(document).on("keyup", "input:text[engOnly]", function() {$(this).val( $(this).val().replace(/[^\!-z]/g,"") );});
            
            //사유 선택 이벤트
            $('#pointReasonCd').on('change', function(e) {
                if(this.value == "04"){
                    $("#pointEtcReasonSpan").show();
                }else{
                    $("#pointEtcReasonSpan").hide();
                }
            });
            
            //유효기간 선택 이벤트
            $('#pointValidPeriod').on('change', function(e) {
                if(this.value == "03"){
                    $("#pointEtcValidImg").show();
                    $("#pointEtcValidSpan").show();                    
                }else{
                    $("#pointEtcValidImg").hide();
                    $("#pointEtcValidSpan").hide();
                }
            });
            
            // 포인트 지급
            $('#insertPointBtn').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                //포인트 유효성 체크
                if($("#prcPoint").val() == ""){
                    Dmall.LayerUtil.alert("포인트를 입력하여 주십시오");
                    return;
                }
                
                //사유 유효성 체크
                if($("#pointReasonCd").val() == ""){
                    Dmall.LayerUtil.alert("사유를 선택하여 주십시오");
                    return;
                }
                
                //직접입력 사유 유효성 체크
                if($("#pointReasonCd").val() == "04"){
                    if($("#pointEtcReason").val() == ''){
                        Dmall.LayerUtil.alert("사유를 입력하여 주십시오");
                        return;
                    }
                }
                
                //포인트 유효기간 유효성 체크
                if($("#pointValidPeriod").val() == "03"){
                    if($("#pointEtcValidPeriod").val() == ''){
                        Dmall.LayerUtil.alert("유효기간을 입력하여 주십시오");
                        return;
                    }
                    
                    var date = new Date();
                    var year  = date.getFullYear();
                    var month = date.getMonth() + 1; 
                    var day   = date.getDate();
                
                    if (("" + month).length == 1) {
                        month = "0" + month; 
                    }
                    if (("" + day).length   == 1) {
                        day   = "0" + day;   
                    }
                   
                    var toDayVal = year + month + day;
                    var validPeriod = $("#pointEtcValidPeriod").val().replace(/-/gi,"");
                    
                    if(validPeriod < toDayVal){
                        Dmall.LayerUtil.alert("포인트 유효기간이 포인트 지급/차감일보다 빠를 수 없습니다.");
                        return;
                    }
                }
                
                if($("#prcPoint").val() > 1000000000){
                    Dmall.LayerUtil.alert("1회 지급/차감 포인트 한도는 1,000,000,000 P  입니다. ");
                    return;
                }
                
                if(Dmall.validate.isValid('form_id_point_insert')) {
                    var url = '/admin/operation/savedMnPoint/point-insert',
                        param = $('#form_id_point_insert').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_id_point_insert');
                        if(result.success){
                            selectPointHis();
                        }
                    });
                }
            });
            
            // 포인트 내역 조회
            $('#getPointBtn').on('click', function(e) {
                $("#pointPage").val("1");
                selectPointHis()
            });
            
            Dmall.common.comma();
            
        });
        
        //포인트 레이어 팝업 실행
        function openPointLayer(memberNo, memberNm, memberLoginId, prcPoint){
            var pointInfo = "<strong>" + memberNm + "</strong>(" + memberLoginId + ")회원님이 보유한 포인트는 <strong>" + prcPoint + "</strong>p 입니다.";
            $(".sm_info").html(pointInfo);
            $("#memberNoSelect").val(memberNo);
            $("#memberNoInsert").val(memberNo);
            selectPointHis();
        }
        
        //포인트 내역 조회
        function selectPointHis(){
            if(Dmall.validate.isValid('form_id_point_select')) {
                
                var url = '/admin/operation/savedMnPoint/point',
                    param = $('#form_id_point_select').serialize(), 
                    callback = pointHistAppend || function() {
                    };
                Dmall.AjaxUtil.getJSON(url, param, callback);
            }
        }
        
        //포인트 내역 테이블에 입력
        function pointHistAppend(result){
            var tbody = '', 
            template = new Dmall.Template('<tr><td>{{rownum}}</td><td>{{regDttm}}</td><td><span class="{{classNm}}">{{pointType}}</span><span class="comma">{{prcPoint}}</span></td><td>{{reasonNm}}</td><td>{{validPeriod}}</td><td>{{typeNm}}</td></tr>');
            jQuery.each(result.resultList, function(idx, obj) {
                
                obj.prcPoint = parseInt(obj.prcPoint,10);
                tbody += template.render(obj);
            });

            $('#pointHisTbody').html(tbody);
            
            Dmall.GridUtil.appendPaging('form_id_point_select', 'point_paging', result, 'paging_id_manager', selectPointHis);
            
            Dmall.common.comma();
        }
        </script>
    <!-- layer_popup1 -->
    <div id="pointLayout" class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">포인트 관리</h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <p class="sm_info"></p>
                    <!-- heading_tbl -->
                    <div class="heading_tbl">
                    <form id="form_id_point_insert" >
                        <input type="hidden" id="memberNoInsert" name="memberNo" />
                        <input type="hidden" id="typeCd" name="typeCd" value="M" />                        
                        <h3 class="tlth3">포인트 지급/차감</h3>
                        <!-- tblw_h -->
                        <div class="tblw_h">
                            <table summary="이표는 포인트 지급/차감 표 입니다. 구성은 구분, 사유, 유효기간, 처리자 입니다.">
                                <caption>포인트 지급/차감</caption>
                                <colgroup>
                                    <col width="20%">
                                    <col width="80%">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>구분</th>
                                        <td>
                                            <span class="select">
                                                <label for="pointGbCd"></label>
                                                <select name="gbCd" id="pointGbCd">
                                                    <option value="10">지급(+)</option>
                                                    <option value="20">차감(-)</option>
                                                </select>
                                            </span>
                                            <span class="intxt"><input type="text" name="prcPoint" id="prcPoint" class="txtr" numberOnly="true" style="ime-mode:disabled;" /></span>
                                            <strong class="unit">p</strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>사유</th>
                                        <td>
                                            <span class="select long">
                                                <label for="pointReasonCd"></label>
                                                <select name="reasonCd" id="pointReasonCd">
                                                    <option value="01">출석체크</option>
                                                    <option value="04">직접입력</option>
                                                </select>
                                            </span>
                                            <span class="intxt" id="pointEtcReasonSpan" style="display:none;"><input type="text" value="" id="pointEtcReason"  name="etcReason" ></span>
                                        </td>
                                    </tr>
                                    <tr id="valedPeriodTr">
                                        <th>유효기간</th>
                                        <td>
                                            <span class="select long" >
                                                <label for="pointValidPeriod">유효기간</label>
                                                <select name="validPeriod" id="pointValidPeriod" >
                                                    <option value="01">제한하지 않음</option>
                                                    <option value="02">제한(12월 31일)</option>
                                                    <option value="03">제한(직접입력)</option>
                                                </select>
                                            </span>
                                            <span class="intxt" id="pointEtcValidSpan" style="display:none;"><input type="text" value="" id="pointEtcValidPeriod" name="etcValidPeriod" class="bell_date_sc" ></span>
                                            <a href="javascript:void(0)" class="date_sc ico_comm" id="pointEtcValidImg" style="display:none;">달력이미지</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>처리자</th>
                                        <td>${memberManageSO.prcNm}(${memberManageSO.prcId})</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblw_h -->
                        </form>
                    </div>
                    <!-- //heading_tbl -->
                    <div class="btn_box txtc">
                        <button class="btn green mt0" id="insertPointBtn">확인</button>
                    </div>
                    <h3 class="tlth3 mt50">포인트 내역 확인</h3>
                    <!-- tblw -->
                    <form id="form_id_point_select" >
                    <input type="hidden" id="memberNoSelect" name="memberNoSelect" />
                    <input type="hidden" name="page" id="pointPage" value="1" />
                    <div class="tblw mt0">
                        <table summary="이표는 포인트 내역 확인 표 입니다. 구성은 지급/차감일, 지급/차감 입니다.">
                            <caption>포인트 내역 확인</caption>
                            <colgroup>
                                <col width="12%">
                                <col width="88%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>지급/차감일</th>
                                    <td>
                                        <tags:calendar from="stRegDttm" to="endRegDttm" idPrefix="srchRegDttm" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>지급/차감</th>
                                    <td>
                                        <tags:radio name="pointGbCd" codeStr="A:전체;10:지급;20:차감" idPrefix="srch_id_pointGbCd" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </form>
                    <!-- //tblw -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="getPointBtn" >검색</button>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="이표는 포인트 내역 상세 리스트 표 입니다. 구성은 번호, 날짜, 지급/차감금액, 사유, 내역, 유효기간, 자동/수동 입니다.">
                            <caption>포인트 내역 상세 리스트</caption>
                            <colgroup>
                                <col width="10%">
                                <col width="18%">
                                <col width="18%">
                                <col width="18%">
                                <col width="18%">
                                <col width="18%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>날짜</th>
                                    <th>지급/차감포인트</th>
                                    <th>사유</th>
                                    <th>유효기간</th>
                                    <th>자동/수동</th>
                                </tr>
                            </thead>
                            <tbody id="pointHisTbody">
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay" id="point_paging"></div>
                    <!-- //bottom_lay -->
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
