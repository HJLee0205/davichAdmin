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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 결제관리 &gt; 회원정보 변경 관리 &gt; 무통장 결제 설정</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function() {
                NopbPayUtil.regLitmitFlag = "${regLitmitFlag}" === 'true' ? true : false;
                
                //무통장결제 설정 호출
                NopbPayUtil.render();
                
                //무통장 은행계좌 리스트 호출
                NopbPayUtil.renderList();

                // 계좌추가등록 버튼 클릭시
                $('#insertLayerBtn').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    NopbPayUtil.layerOpen(this, 'insert');
                });
                
                //팝업 등록/수정 버튼 클릭시
                $('#submitBtn').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    NopbPayUtil.submit(NopbPayUtil.mappingVo($(this).attr('data-btn-type')), 'noDelete');
                });
                
                // 저장하기 버튼 클릭시
                $('#nopbBtnSave').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    NopbPayUtil.submit(NopbPayUtil.mappingVo('save'), 'noDelete');
                });
                
                Dmall.validate.set('popupForm');
            });
            
            var NopbPayInitUtil = {
                setNopbpaymentUseYn:function(data, obj, bindName, target, area, row) {
                    var bindValue = obj.data("bind-value")
                        , value = data[bindValue];
     
                    $("input:radio[name=nopbpaymentUseYn][value=" + value + "]").trigger('click');
                }
                , getBankOptionValue:function(callback, btnObj, typeCode) {
                    var url = '/admin/setup/config/payment/nopbbank-list',
                        param = '';
                
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {

                        if (result == null || result.success != true) {
                            return;
                        }                
                        var rstList = result.resultList;
                        if (rstList == null) {
                            return;
                        }
                        
                        for(var i=0; i<rstList.length; i++) {
                            $('#sel_bankCd').append($('<option>', { value : rstList[i].dtlCd }).text(rstList[i].dtlNm));
                        }
                        
                        callback(btnObj, typeCode);
                    });
                } 
            };
            
            var NopbPayUtil = { 
                regLitmitFlag:'' //무통장계좌 등록 제한 여부
                , initNopbDlgtSeq:0
                , nopbPaymentSeq:0
                , nopbAccountList:[]
                , render:function() {
                    //무통장 계좌 사용여부 정보 조회
                    var url = '/admin/setup/config/payment/nopbpayment-info',
                    dfd = jQuery.Deferred();
                    
                    Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }

                        dfd.resolve(result.data);
                        NopbPayUtil.bind(result.data);
                    });
                    return dfd.promise();
                }
                , renderList:function() {
                    //리스트 정보
                    var url = '/admin/setup/config/payment/nopbpayment-list',
                    dfd = $.Deferred();
                    Dmall.AjaxUtil.getJSONwoMsg(url, null, function(result) {
                        var template = '<tr><td>{{rownum}}</td>'+
                            //'<td><input type="radio" name="dlgtActYn" id="rdo_dlgtActYn_{{nopbPaymentSeq}}" value="{{dlgtActYn}}" data-seq="{{nopbPaymentSeq}}" style="cursor:pointer"></td>'+
                            '<td>{{bankNm}}</td><td>{{actno}}</td><td>{{holder}}</td>'+
                            '<td><a href="#none" class="updateLayerBtn btn_gray" data-seq="{{nopbPaymentSeq}}">수정</a></td>'+
                            '<td><a href="#none" class="deleteBtn btn_gray" data-seq="{{nopbPaymentSeq}}">삭제</a></td></tr>',
                            managerGroup = new Dmall.Template(template),
                                tr = '';
        
                        $.each(result.resultList, function(idx, obj) {
                            tr += managerGroup.render(obj)
                        });
        
                        if(tr == '') {
                            tr = '<tr><td colspan="6">데이터가 없습니다.</td></tr>';
                        }
                        $('#tbodyList').html(tr);
                        
                        dfd.resolve(result.resultList);
                        NopbPayUtil.nopbAccountList = result.resultList;
                        
                        //DOM이 모두 그려지고 난뒤에 수정버튼클릭시 이벤트 처리가 불러와줘야한다.
                        NopbPayUtil.updateBtnHandlerAdd();
                        
                        //대표계좌 라디오버튼 checked
                        /* NopbPayUtil.renderDlgtAct(); */
                    });
        
                    return dfd.promise();
                }
                , renderDlgtAct:function() {
                    $.each(NopbPayUtil.nopbAccountList, function(idx, obj) {
                        for(var key in obj) {
                            //리스트 항목중 대표계좌 설정 여부인데
                            if(key === 'dlgtActYn') {
                                //값이 Y라면
                                if(obj[key] === 'Y') {
                                    //랜더링된 계좌 정보중 기본키값이 똑같은 것을 체크해준다.
                                    $('#tbodyList input[name=dlgtActYn]').each(function() {
                                        if($(this).attr('data-seq') === obj['nopbPaymentSeq']) {
                                            $(this).prop('checked', true).trigger('click');
                                            NopbPayUtil.initNopbDlgtSeq = $(this).attr('data-seq');
                                        }
                                    });
                                }
                            }
                        }
                    });
                }
                , bind:function(data) {
                    $('[data-find="nopb_info"]').DataBinder(data);
                    //위에서 DataBinder를 하지만 다시 라디오버튼을 checked를 해주는 이유는
                    //설정정보 변경시 사용여부를 한번도 클릭하지 않고 그대로 저장하기 버튼을 클릭하면 현재 체크된 값을 가지고 오질 못해서
                    $("input:radio[id='rdo_nopbpaymentUseYn_"+data.nopbpaymentUseYn+"']").prop('checked', 'checked');
                }
                , layerInit:function(btnObj, typeCode) {
                    NopbPayInitUtil.getBankOptionValue(NopbPayUtil.layerMappingHandler, btnObj, typeCode);
                }
                , layerOpen:function(obj, typeCode) {
                    // 등록여부 판단
                    if(typeCode === 'insert' && NopbPayUtil.regLitmitFlag === false) {
                        alert('계좌를 추가로 등록하시려면 계좌등록 상품을 구매하여 주세요.');
                        return;
                    }
                    NopbPayUtil.layerInit(obj, typeCode);
                    Dmall.LayerPopupUtil.open($('#accountManageLayer'));
                }
                , layerMappingHandler:function(btnObj, typeCode) {
                    if(typeCode === 'insert') {
                        $("#sel_bankCd").val('00').trigger('change');
                        $('#submitBtn').text('등록');
                        $('#submitBtn').attr('data-btn-type', 'insert');
                        $('#popupForm')[0].reset();
                    } else {
                        $('#submitBtn').text('수정');
                        $('#submitBtn').attr('data-btn-type', 'update');
                        //계좌 수정시 팝업창에 데이터 매핑
                        NopbPayUtil.updatePopupMapping(btnObj);
                        
                        //계좌 내용 수정시 필요한 고유시퀀스
                        NopbPayUtil.nopbPaymentSeq = $(btnObj).attr('data-seq');
                    }
                }
                , updatePopupMapping:function(obj) {
                    for(var vo in NopbPayUtil.nopbAccountList) {
                        if(NopbPayUtil.nopbAccountList[vo].nopbPaymentSeq === $(obj).attr('data-seq')) {
                            for(var key in NopbPayUtil.nopbAccountList[vo]) {
                                $('#tbodyPopup').find('input[data-name='+key+']').val(NopbPayUtil.nopbAccountList[vo][key]);
                                
                                if(key === 'bankCd') {
                                    //선택된 은행 selected
                                    $('#sel_bankCd').val(NopbPayUtil.nopbAccountList[vo][key]).trigger('change');
                                }

                                if(key === 'bankNm') {
                                    $('#hd_bankNm').val(NopbPayUtil.nopbAccountList[vo][key]);
                                }
                            }
                        }
                    }
                }
                , mappingVo:function(typeCode) {
                    var url = '', param;
                    if(typeCode === 'save') {
                        url = '/admin/setup/config/payment/nopbpayment-config-update';
                        param = {
                            'nopbpaymentUseYn':$("input:radio[name='nopbpaymentUseYn']:checked").val()
                            , 'nopbPaymentSeq':$("input:radio[name=dlgtActYn]:checked").attr('data-seq')
                            , 'dlgtActYn':'Y'
                            , 'initNopbDlgtSeq':NopbPayUtil.initNopbDlgtSeq
                        };
                    } else if(typeCode === 'delete') { 
                        url = '/admin/setup/config/payment/nopbaccount-delete';
                        param = {'nopbPaymentSeq':NopbPayUtil.nopbPaymentSeq};
                    } else {
                        url = '/admin/setup/config/payment/';
                        typeCode === 'insert' ? url = 'nopbaccount-insert' : url = 'nopbaccount-update';
                        param = {
                            'bankCd':$('#sel_bankCd').val()
                            , 'actno':$('#actno').val()
                            , 'holder':$('#holder').val()
                            , 'dlgtActYn':$("input:radio[name=dlgtActYn]:checked").val()
                            , 'nopbPaymentSeq':NopbPayUtil.nopbPaymentSeq
                            , 'typeCode':'insert'
                        }
                    }

                    return {
                        url:url
                        , param:param
                    };
                }
                , updateBtnHandlerAdd:function() {
                    // 계좌수정 버튼 클릭시
                    $('.updateLayerBtn').on('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        NopbPayUtil.layerOpen(this, 'update');
                    });
                    
                    // 계좌삭제 버튼 클릭시
                    $('.deleteBtn').on('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        //계좌 내용 수정시 필요한 고유시퀀스
                        NopbPayUtil.nopbPaymentSeq = $(this).attr('data-seq');
                        Dmall.LayerUtil.confirm('정말로 삭제하시겠습니까?',
                            NopbPayUtil.nopbDelete
                        );
                    });
                }
                , nopbDelete:function() {
                    NopbPayUtil.submit(NopbPayUtil.mappingVo('delete'), 'delete');
                }
                , submit:function(vo, type) {
                    if(vo.param.typeCode === 'insert') {
                        if($('#sel_bankCd').val() === '00') {
                            alert('은행을 선택해주세요.');
                            return;
                        }
                    }
                    
                    if(Dmall.validate.isValid('popupForm')) {
                        Dmall.AjaxUtil.getJSON(vo.url, vo.param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'popupForm');
                            
                            if (result == null || result.success != true) {
                                return;
                            } else {
                              //무통장결제 설정 호출
                                NopbPayUtil.render();
                                
                                //무통장 은행계좌 리스트 호출
                                NopbPayUtil.renderList();
                                
                                //팝업 제거
                                Dmall.LayerPopupUtil.close('accountManageLayer');
                            }
                        });
                    }
                    return false;
                }
            };
        </script>
    </t:putAttribute>

    <t:putAttribute name="content">
       <div class="sec01_box">
           <div class="tlt_box">
               <h2 class="tlth2">무통장 결제 설정</h2>
                   <div class="btn_box right">
                       <a href="#none" class="btn blue shot" id="nopbBtnSave">저장하기</a>
                   </div>
           </div>
    
           <!-- line_box -->
           <div class="line_box fri">
               <h3 class="tlth3">무통장결제 설정</h3>
               <!-- tblw -->
               <form id="form_nopb_info">
                   <div class="tblw tblmany">
                       <table summary="이표는 무통장결제 설정 변경 안내 설정 표 입니다. 구성은 사용여부 입니다.">
                           <caption>무통장결제 설정</caption>
                           <colgroup>
                               <col width="15%">
                               <col width="85%">
                           </colgroup>
                           <tbody>
                               <tr>
                                   <th>사용여부</th>
                                   <td id="td_nopbpaymentUseYn" data-find="nopb_info" data-bind-value="nopbpaymentUseYn" data-bind-type="function" data-bind-function="NopbPayInitUtil.setNopbpaymentUseYn">
                                       <label for="rdo_nopbpaymentUseYn_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="nopbpaymentUseYn" id="rdo_nopbpaymentUseYn_Y" value="Y"></span> 사용</label>
                                       <label for="rdo_nopbpaymentUseYn_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="nopbpaymentUseYn" id="rdo_nopbpaymentUseYn_N" value="N"></span> 사용안함</label>                                   
                                   </td>
                               </tr>
                           </tbody>
                       </table>
                   </div>
               </form>
               <!-- //tblw -->
               <h3 class="tlth3 btn1">
                        은행계좌 설정
                   <div class="right">
                       <a href="#layout1" id="insertLayerBtn" class="btn_blue popup_open btn_gray2">계좌추가등록</a>
                   </div>
               </h3>
               <!-- tblh -->
               <div class="tblh">
                   <table summary="이표는 은행계좌 설정 표 입니다. 구성은  입니다.">
                       <caption>은행계좌 설정</caption>
                       <colgroup>
                           <col width="5%">
                           <%-- <col width="10%"><!--160607 수정--> --%>
                           <col width="10%"><!--160607 수정-->
                           <col width="30%">
                           <col width="15%">
                           <col width="15%">
                           <col width="15%">
                       </colgroup>
                       <thead>
                           <tr>
                               <th>번호</th>
                               <%-- <th>대표계좌</th> --%>
                               <th>은행명</th>
                               <th>계좌번호</th>
                               <th>예금주</th>
                               <th>수정</th>
                               <th>삭제</th>
                           </tr>
                       </thead>
                       <tbody id="tbodyList"></tbody>
                   </table>
               </div>
               <!-- //tblh -->
           </div>
           <!-- //line_box -->
       </div>
       <%@ include file="popup/nopbConfig/nopbPayManagePopup.jsp" %>
    </t:putAttribute>
</t:insertDefinition>