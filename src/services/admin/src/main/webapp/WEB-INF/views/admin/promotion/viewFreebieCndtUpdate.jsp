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
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 사은품이벤트 &gt; 사은품이벤트 수정</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        // 사은품행사 시작일시 종료일시
        var $srch_sc01 = $("#srch_sc01");
        var $srch_sc02 = $("#srch_sc02");
        var $srch_from_hour = $("#srch_from_hour");
        var $srch_to_hour = $("#srch_to_hour");
        var $srch_from_minute = $("#srch_from_minute");
        var $srch_to_minute = $("#srch_to_minute");
        
            jQuery(document).ready(function() {
                
              //사은품이벤트리스트 페이지로 돌아가기 : 기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,페이지번호
                jQuery("#freebieCndt_list").on("click", function(){
                    var periodSelOption = $("#periodSelOption").val();
                    var searchStartDate = $("#searchStartDate").val();
                    var searchEndDate = $("#searchEndDate").val();
                    var freebieStatusCds = $("#freebieStatusCds").val();
                    var searchWords = $("#searchWords").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#pageNoOri").val();
                    Dmall.FormUtil.submit('/admin/promotion/freebie-event',
                            {periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, freebieStatusCds : freebieStatusCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});
                });
                
                // 사은품대상 검색
                jQuery('#goods_srch_btn').on('click', function(e) {
                    if($("#freebiePresentCndtCd_1_label").hasClass("on")){
                        Dmall.LayerUtil.alert("개별상품으로 선정을 체크하지 않았습니다");
                        return false;
                    };
                    Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
                    GoodsSelectPopup._init( fn_callback_pop_goods );
                    $("#btn_popup_goods_search").trigger("click");
                });
                
                // 사은품상품 검색
                jQuery('#freebie_srch_btn').on('click', function(e) {
                    Dmall.LayerPopupUtil.open(jQuery('#layer_popup_freebie_select'));
                    FreebieSelectPopup._init( fn_callback_pop_freebie );
                    $("#btn_popup_freebie_search").trigger("click");
                });
                
                jQuery("#freebieEventAmt").on('focus', function(){
                    //해당 라디오버튼 미선택 시, 경고
                    if( $("#freebiePresentCndtCd_2_label").hasClass('on') ) {
                        Dmall.LayerUtil.alert("해당 라디오버튼을 체크하지 않았습니다");
                        return;
                    }
                });
                
                // Validation  - 사은품 이벤트명, 사은품 이벤트 설명
                Dmall.validate.set('formFreebieUpdate');
                
                // 저장
                jQuery('#freebie_reg').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    //사은품
                    if(freebieSelCheck() == false){
                        return
                    }
                        
                    //기간
                    if(dttmCheck() == false){
                        return
                    }  
        
                    //증정조건코드 체크
                    if(presentCndtCdCheck() == false){
                        return
                    }
                    
                    //사은품이벤트 상품 기간 중복 허용해서 주석처리
                    //종료된 이벤트를 기간을 변경하여 다시 진행하려할 때 상품중복 피하기
                    /* if(restartFreebieEventCheck() == false){
                        return
                    } */
                    
                    // 천단위로 찍은 콤마 없애기
                    $('#freebieEventAmt').val( $('#freebieEventAmt').val().trim().replaceAll(',', '') )
                    
                    // 수정
                    if(Dmall.validate.isValid('formFreebieUpdate')) {
                        var url = '/admin/promotion/freebieevent-update';
                        var param = jQuery('#formFreebieUpdate').serialize();
                        
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formFreebieUpdate');
                            if(result.success) {
                                Dmall.FormUtil.submit('/admin/promotion/freebie-event');
                            }
                        });
                    }
                });
                
                // 상품 삭제
                jQuery(document).on("click", "button[name='minus_btn']", function(e){
                    var $minus_btn = $("button[name='minus_btn']")
                    var i = $minus_btn.index(this);
                    
                    // 삭제하려는 사은품대상 상품번호
//                     var delGoodsNo = $minus_btn.eq(i).siblings('input[name="goodsNoArr"]').prop('value');
                    
                    // 이벤트 걸린 전체상품 속에, 지우려하는 상품도 들어있음(수정 전 상품일 경우). 
                    // 그래서 지울 때 전체목록에서도 함께 삭제해야, 나중에 재추가 시 중복alert 안뜸
//                     var totalTarget = $("#totalFreebieTarget").children();
//                     for(var j = 0; j < totalTarget.length; j++) {
//                      if(totalTarget.eq(j).val() == delGoodsNo){
//                            totalTarget.eq(j).remove()
//                            totalTarget.eq(j+1).remove() /* 해당상품이 걸린 사은품이벤트명도 함께 삭제 */
//                       }
//                     } 
                    
                    $minus_btn.eq(i).parent().remove()
                    
                    // 선택한 사은품 대상이 없으면 공간없애기 
                    if($("#sel_goods_list").children().length == 0){
                        $("#sel_goods_list").removeClass("display_block")
                    }
                    // 선택사은품이 없으면 공간없애기 
                    if($("#sel_freebie_list").children().length == 0){
                        $("#sel_freebie_list").removeClass("display_block")
                    }
                    
                });
                
                // 숫자만 입력하게 만들기 : 총 결제금액
                $('#freebieEventAmt').on('focus', function () {
                    onlyNumberInput($(this));
                });     
                // 천단위로 콤마 삽입  
                $('#freebieEventAmt').mask('#,##0', {reverse : true, maxlength:false});
            });
            
            // 상품 설정 체크         
            function freebieSelCheck(){
                         // 수정화면에서 선택한 사은품 , 수정 이전에 갖고 있던 사은품 모두 체크
                         if($("#sel_freebie_list").children().length == 0){
//                          if($("#freebie_list").parent().children().length == 0 && $("#sel_freebie_list").children().length == 0){
                             Dmall.LayerUtil.alert("사은품이벤트 상품설정에서 상품을 설정해주세요");
                             return false
                         }
            }
            
            
//          기간 선택 체크
            function dttmCheck(){
                if($srch_sc01.val() == '' || $srch_sc01.val() == null || $srch_sc02.val() == '' || $srch_sc02.val() == null) {
                    Dmall.LayerUtil.alert("기간을 선택해주세요");
                    return false
                } else if($srch_sc01.val() > $srch_sc02.val()){
                    Dmall.LayerUtil.alert("시작날짜가 종료날짜보다 큽니다.")
                    return false;
                } else if($srch_sc01.val() == $srch_sc02.val()){
                             if($srch_from_hour.val() > $srch_to_hour.val()){
                                       Dmall.LayerUtil.alert("시작시간이 종료시간보다 큽니다.")
                                       return false;
                             } else if($srch_from_hour.val() == $srch_to_hour.val()){
                                          if($srch_from_minute.val() >= $srch_to_minute.val()){
                                              Dmall.LayerUtil.alert("시작시간이 종료시간보다 크거나 같습니다.")
                                              return false;
                                          }
                             }
                }
            }
            
            // 사은품 증정조건 선택 체크
            function presentCndtCdCheck(){
                  // 지정금액 이상 구매시
                  if($("#freebiePresentCndtCd_1_label").hasClass("on")){
                      if($("#freebieEventAmt").val() == null || $("#freebieEventAmt").val() == "" || $("#freebieEventAmt").val() == '0'){
                          Dmall.LayerUtil.alert("금액을 입력해주세요");
                          return false;
                      }    
                  } 
                  
                  // 지정 상품 구매시
                  if($("#freebiePresentCndtCd_2_label").hasClass("on")){
                      if($("#sel_goods_list li").length == 0){
                          Dmall.LayerUtil.alert("상품을 검색하여 선택해주세요");
                          return false;
                      } else {
                          $("#freebieEventAmt").prop("value", 0)
                      }
                  }
            }    
            
           // 중복체크를 fn_callback_pop_goods(data) 상품검색 콜백함수에서 하는데, 
           // 사은품이벤트 진행상태변경으로 부활한 사은품대상상품은 여기에서 별도로 점검
           /* function restartFreebieEventCheck(){
               // 기획전 대상으로 쓰이는 상품번호와 현재 지정한 상품번호가 같을 경우
               // 기획전상품에 걸린 사은품이벤트명과 현재 지정한 상품에 걸린 사은품이벤트명이 같아야 한다. 
               // 같지 않다면 경고메시지 띄운다.
               var $totalTargetGoodsNo = $('#totalFreebieTarget').children('input:nth-child(odd)');
               var $totalTargetFreebieNm = $('#totalFreebieTarget').children('input:nth-child(even)');
               var $currentTargetGoodsNo = $('input[name="goodsNoArr"]');               
               
               for ( var i = 0; i < $totalTargetGoodsNo.length; i++ ){
                   for ( var j = 0; j < $currentTargetGoodsNo.length; j++ ){
                       if( $totalTargetGoodsNo.eq(i).prop('value') == $currentTargetGoodsNo.eq(j).prop('value') ){
                           if( $totalTargetFreebieNm.eq(i).prop('value') != $("#freebieEventNm").prop('value') ){
                               alert("이미 " + $totalTargetFreebieNm.eq(i).prop('value') + " 사은품이벤트 대상으로 사용되고 있습니다.")
                           }
                       }
                   }
               }
           } */
                
           // 상품(사은품대상) 팝업 리턴 콜백함수 
           function fn_callback_pop_goods(data) {
              var $sel_goods_list = $("#sel_goods_list");
              
              // 선택 중복 체크
               for(var i = 0; i < $sel_goods_list.children('li').length; i++){
                   if( $sel_goods_list.children('li').eq(i).children('input').eq(1).prop('value') == data['goodsNo']){
                       Dmall.LayerUtil.alert("이미 선택하셨습니다");
                       return false;
                   } 
               }
              
               //다른 이벤트 중복 체크
               /* var $totalTargetGoodsNo = $('#totalFreebieTarget').children('input:nth-child(odd)');
               var $totalTargetFreebieNm = $('#totalFreebieTarget').children('input:nth-child(even)');
               for ( var j = 0; j < $totalTargetGoodsNo.length; j++ ){
                   if( $totalTargetGoodsNo.eq(j).prop('value') ==  data['goodsNo'] ) {
                      alert("이미 " + $totalTargetFreebieNm.eq(j).prop('value') + " 사은품이벤트에서 사은품대상으로 쓰이고 있습니다. " )
                      return false;
                   }
               } */
               
              var template  = "";
                  template += "<li class='pr_thum'>";
                  template +=       "<button name='minus_btn' type='button' class='minus btn_comm'></button>";
                  template +=       "<img src='" + data["goodsImg02"] + "' width='82' height='82' alt='상품이미지'/><br/>";
//                   template +=       "<input type='text' value='" + data["imgPath"] + "' readonly/>";
                  template +=       "<input type='text' value='" + data["goodsNm"] + "' readonly/>";
                  template +=       "<input type='hidden' value='" + data["goodsNo"] + "' name='goodsNoArr' readonly/>";
                  template += "</li>";
                  
               $sel_goods_list.addClass("display_block");
               $sel_goods_list.append(template);
           }
           
           // 사은품상품 팝업 리턴 콜백함수 
           function fn_callback_pop_freebie(data) {
              var $sel_freebie_list = $("#sel_freebie_list");
              // 선택 중복 체크
               for(var i = 0; i < $sel_freebie_list.children('li').length; i++){
                   if( $sel_freebie_list.children('li').eq(i).children('input').eq(1).prop('value') == data['freebieNo']){
                       Dmall.LayerUtil.alert("이미 선택하셨습니다");
                       return false;
                   } 
               }
              
              var template  = "";
                  template += "<li class='pr_thum'>"; 
                  template +=       "<button name='minus_btn' type='button' class='minus btn_comm'></button>";
                  template +=       "<img src='${_IMAGE_DOMAIN}/image/image-view?type=FREEBIEDTL&id1=" + data["imgPath"] + "_" + data["imgNm"] + "' width='82' height='82' alt='사은품이미지' /><br/>";
                  template +=       "<input type='text' value='" + data["freebieNm"] + "' readonly/>";
                  template +=       "<input type='hidden' value='" + data["freebieNo"] + "' name='freebieNoArr' readonly/>";
                  template += "</li>";
                  
               $sel_freebie_list.addClass("display_block");
               $sel_freebie_list.append(template);
           }
           
           function onlyNumberInput(obj){
               obj.on('keydown', function (event) {
                   event = event || window.event;
                   var keyID = (event.which) ? event.which : event.keyCode;
                   // 48 ~ 57 일반숫자키 0~9,  96~105 키보드 우측 숫자키패드,  백스페이스 8, 탭 9, end 35, home 36, 왼쪽 방향키 37, 오른쪽 방향키 39, 인서트 45, 딜리트 46, 넘버락 144 
                   if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 9 || keyID == 35 || keyID == 36 || keyID == 37 || keyID == 39 || keyID == 45 || keyID == 46 || keyID == 144 ){
                       return;
                   } else {
                       return false;
                   }
               });
                obj.on('keyup', function (event) {
                   event = event || window.event;
                   var keyID = (event.which) ? event.which : event.keyCode;
                   if ( keyID == 8 || keyID == 9 || keyID == 35 || keyID == 36 || keyID == 37 || keyID == 39 || keyID == 45 || keyID == 46 || keyID == 144 ){
                       return;
                   } 
               });
           }   
        </script>        
    </t:putAttribute>
    <t:putAttribute name="content">
          <div class="sec01_box">
              <div class="tlt_box">
                  <div class="btn_box left">
                      <button id="freebieCndt_list" class="btn gray">사은품리스트</button>
                  </div>
                  <h2 class="tlth2">사은품 이벤트 수정</h2>
                  <div class="btn_box right">
                      <a href="#none" class="btn blue shot" id="freebie_reg">저장하기</a>
                  </div>
              </div>
              
              
             <!-- 다른 사은품이벤트에서 사은품대상으로 쓰이고 있는 전체 상품번호 : 중복방지-->
             <%-- <span id="totalFreebieTarget">
                   <c:forEach var = "goodsResult" items = "${goodsListModel.extraData.goodsResult}">
                           <input type="hidden" value="${goodsResult.goodsNo}" />
                           <input type="hidden" value="${goodsResult.freebieEventNm}" />
                   </c:forEach>
             </span>     --%>
                
                
              <!-- line_box -->
              <c:set var="prmtDtl" value="${resultModel.data}" />
              <form id="formFreebieUpdate">
              <input type="hidden" name="periodSelOption" id="periodSelOption" value="${so.periodSelOption}" />
              <input type="hidden" name="searchStartDate" id="searchStartDate" value="${so.searchStartDate}" />
              <input type="hidden" name="searchEndDate"   id="searchEndDate" value="${so.searchEndDate}" />
              <input type="hidden" name="freebieStatusCds" id="freebieStatusCds" value="${fn:join(so.freebieStatusCds, ',')}" />
              <input type="hidden" name="searchWords"     id="searchWords" value="${so.searchWords}" />
              <input type="hidden" name="rows"       id="rows" value="${so.rows}" />
              <input type="hidden" name="pageNoOri"       id="pageNoOri" value="${so.pageNoOri}" />
              <input type="hidden" name="freebieEventNo"  id="freebieEventNo" value="${prmtDtl.freebieEventNo}" />
              <input type="hidden" name="freebiePresentCndtCdOrigin" value="${prmtDtl.freebiePresentCndtCd}" />
              <div class="line_box fri">
                  <h3 class="tlth3">사은품 이벤트 정보</h3>
                  
                  <!-- tblw -->
                  <div class="tblw tblmany">
                      <table summary="이표는 사은품등록표 입니다. 구성은 사은품 이벤트명, 설명, 기간, 사은품명, 사은품설정, 증정 사은품 등록 입니다.">
                          <caption>상품 기본정보</caption>
                          <colgroup>
                              <col width="20%">
                              <col width="80%">
                          </colgroup>
                          <tbody>
                             <tr>
                                 <th>사은품 이벤트명</th>
                                    <td>
                                        <a class="intxt wid100p"><input type="text" name="freebieEventNm" id="freebieEventNm" data-validation-engine="validate[required, maxSize[100]]" value="${prmtDtl.freebieEventNm}" /></a>
                                    </td>
                                </tr>
                                <tr>
                                    <th>사은품 이벤트 설명</th>
                                    <td>
                                        <span class="intxt wid100p"><input type="text" name="freebieEventDscrt" id="freebieEventDscrt" data-validation-engine="validate[required, maxSize[300]]" value="${prmtDtl.freebieEventDscrt}" /></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>사은품 이벤트 기간</th>
                                        
                                    <td>
                                         <tags:calendarTime from="from" to="to" idPrefix="srch" fromValue="${prmtDtl.applyStartDttm}" toValue="${prmtDtl.applyEndDttm}"></tags:calendarTime>
                                         <br/>
                                        <span class="fc_pr1 fs_pr1">* 이벤트 기간이 종료 후 이벤트 페이지를 접속하였을 때,<br/>
                                        <strong>방문자</strong> - 이벤트가 종료되었습니다!라고 안내되어집니다.<br/>
                                        <strong>관리자</strong> - 계속해서 이벤트의 페이지의 내용을 확인 할 수 있습니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>사은품 증정 조건</th>
                                    <td>
                                        <label for="freebiePresentCndtCd_1" id="freebiePresentCndtCd_1_label" class="radio<c:if test='${prmtDtl.freebiePresentCndtCd eq 01}'> on</c:if>" >
                                               <span class="ico_comm"> 
                                                   <input type="radio" name="freebiePresentCndtCd" id="freebiePresentCndtCd_1" value="01" 
                                                      <c:if test='${prmtDtl.freebiePresentCndtCd eq 01}'> checked="checked"</c:if>
                                                   />
                                               </span>
                                        </label> 
                                        총 결제금액이 <span class="intxt shot">
                                                          <input type="text" name="freebieEventAmt" id="freebieEventAmt" maxlength="10" value="<c:if test='${prmtDtl.freebiePresentCndtCd eq 01}'>${prmtDtl.freebieEventAmt}</c:if>" >
                                                      </span> 원 이상이면 해당 사은품 증정 <span class="br"></span>
                                        
                                        <label for="freebiePresentCndtCd_2" id="freebiePresentCndtCd_2_label" class="radio<c:if test='${prmtDtl.freebiePresentCndtCd eq 02}'> on</c:if>" >
                                               <span class="ico_comm"> 
                                                   <input type="radio" name="freebiePresentCndtCd" id="freebiePresentCndtCd_2" value="02" 
                                                      <c:if test='${prmtDtl.freebiePresentCndtCd eq 02}'> checked="checked"</c:if>
                                                   />
                                               </span>
                                        </label> 
                                        개별상품으로 선정 <button type="button" id="goods_srch_btn" class="btn_blue">상품 검색</button>
                                              <ul class="tbl_ul pr_ul1<c:if test='${prmtDtl.freebiePresentCndtCd eq 02}'> display_block </c:if>" id="sel_goods_list">
                                                 <c:forEach var = "targetResult" items="${resultModel.extraData.targetResult}">
                                                         <li class='pr_thum'>
                                                               <button name='minus_btn' type='button' class='minus btn_comm'></button>
                                                               <img src="${targetResult.imgPath}" width='82' height='82' alt='상품이미지'/><br/>
                                                               <input type="text" value="${targetResult.goodsNm}" readonly/>
                                                               <input type="hidden" name='goodsNoArr' value="${targetResult.goodsNo}" readonly/>
                                                         </li>
                                                 </c:forEach>
                                              </ul>
                                     </td>    
                                 </tr>            
                                 <tr>
                                     <th>사은품이벤트 상품설정</th>
                                     <td> <button type="button" id="freebie_srch_btn" class="btn_blue">사은품 검색</button>
                                             <ul class="tbl_ul pr_ul1 display_block" id="sel_freebie_list">  
                                                <c:forEach var = "goodsResult" items="${resultModel.extraData.goodsResult}">
                                                        <li class='pr_thum' >
                                                              <button name='minus_btn' type='button' class='minus btn_comm'></button>
                                                              <img src="${_IMAGE_DOMAIN}/image/image-view?type=FREEBIEDTL&id1=${goodsResult.imgPath}_${goodsResult.imgNm}" width='82' height='82' alt='사은품 이미지' /><br/>
                                                              <input type="text" value="${goodsResult.freebieNm}" readonly/>
                                                              <input type='hidden' name='freebieNoArr' value='${goodsResult.freebieNo}' readonly/>
                                                        </li>
                                                </c:forEach>
                                             </ul>
                                     </td>
                                </tr>
                          </tbody>
                      </table>
                  </div>
                  <!-- //tblw -->
              </div>
              </form>
              <!-- //line_box -->
          </div>
     <%@ include file="/WEB-INF/include/popup/goodsSelectPopup.jsp" %>
     <%@ include file="/WEB-INF/include/popup/freebieCndtSelectPopup.jsp" %>
    </t:putAttribute>
</t:insertDefinition>
