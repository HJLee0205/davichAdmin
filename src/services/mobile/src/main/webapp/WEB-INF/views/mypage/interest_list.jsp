<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">나의관심상품</t:putAttribute>
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){

        /* 페이징 */
        $('#div_id_paging').grid(jQuery('#form_id_search'));
        
        /* 개별선택 */
        $('input:checkbox[name=goodsNoArr]').on('click', function() {
            var stockQtt = parseInt($(this).parents('li').attr('data-stock-qtt'), 10) || 0;
            var tgDelYn = $(this).parents('li').attr('data-tg-del-yn');
            var tiDelYn = $(this).parents('li').attr('data-ti-del-yn');
            if(stockQtt === 0 || tgDelYn === 'Y' || tiDelYn === 'Y') {
                Dmall.LayerUtil.alert('해당 상품은 재고가 존재하지 않습니다.');
                 $(this).trigger('click');
                return;
            }
        });
        
        /* 전체선택 */
        $("#allCheck").click(function(){
            //만약 전체 선택 체크박스가 체크된상태일경우
            InterestUtil.allCheckBox();
        })

        /* 개별 삭제 */
        $('.direct-delete-btn').on('click', function(e) {
             e.preventDefault();
             e.stopPropagation();
             
             InterestUtil.goodsNo = $(this).parents('li').attr('data-goods-no');
             Dmall.LayerUtil.confirm('삭제하시겠습니까?', InterestDeleteUtil.directDeleteProc);
        });

        /* 전체 삭제 */
        $('#del_btn_all_interest').on('click', function(e) {
             //만약 전체 선택 체크박스가 체크된상태일경우
            InterestUtil.allCheck();
            InterestUtil.allCheckBox();
         });

        /* 개별 삭제 */
        $('.direct-delete-btn').on('click', function(e) {
             e.preventDefault();
             e.stopPropagation();

             InterestUtil.goodsNo = $(this).parents('li').attr('data-goods-no');
             Dmall.LayerUtil.confirm('삭제하시겠습니까?', InterestDeleteUtil.directDeleteProc);
        });
        
        /* 선택 삭제 */
        $('#del_btn_select_interest').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            InterestDeleteUtil.checkDelete();
        });
        
        /* 개별 장바구니 등록 */
        $('.direct-basket-btn').on('click', function(e) {
             e.preventDefault();
             e.stopPropagation();
             
             InterestUtil.goodsNo = $(this).parents('li').attr('data-goods-no');
             InterestUtil.itemNo = $(this).parents('li').attr('data-item-no');

             Dmall.LayerUtil.confirm('장바구니에 등록 하시겠습니까?', InterestBasketUtil.directBasketProc);
        });
        
        /* 선택상품 장바구니 등록 */
        $('#insertCheckBastetBtn').on('click', function(e) {
             e.preventDefault();
             e.stopPropagation();
             
             InterestBasketUtil.checkBasketProc();
        });
        
        $('#btn_close_pop').on('click', function(){
            Dmall.LayerPopupUtil.close('success_basket');
        });

        //장바구니이동
        $('#btn_move_basket').on('click', function(){
            location.href = "${_MOBILE_PATH}/front/basket/basket-list";
        });

    });

    InterestUtil = {
        goodsNo:''
        , itemNo:''
        , allCheck:function() {
            $('#allCheck').trigger('click');
        }
        , validation:function() {
            var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부
            var optLayerCnt = $('[id^=option_layer_]').length; //필수옵션 레이어 갯수
            var optionSelectOk = true; //필수옵션 선택 확인
            var addOptionUseYn = '${goodsInfo.data.addOptUseYn}'; //추가 옵션 사용 여부
            var addOptRequiredYn = 'N'; //추가옵션(필수) 존재 여부;
            var addOptRequiredOptNo = new Array(); //추가옵션(필수) 선택한 옵션 번호 배열;
            var addOptBoxCnt = 0;//추가옵션(필수) 셀렉트박스 갯수
            var addOptionSelectOk = true; //추가옵션(필수) 선택 확인
            var optionNm = ''; //옵션명
            var itemNm = ''; //단품명
            $('[id^=add_option_layer_]').each(function(index){
                if($(this).data().requiredYn == 'Y') {
                    addOptRequiredOptNo.push($(this).data().addOptNo);
                }
            });
            $('select.select_option.goods_addOption').each(function(){
                if($(this).data().requiredYn == 'Y') {
                    addOptBoxCnt++;
                }
            });


            /* 필수 옵션 선택 확인 */
            if(multiOptYn == 'Y' && optLayerCnt == 0) {
                $('select.select_option.goods_option').each(function(){
                    if($(this).find(':selected').val() == ''){
                        optionNm = $(this).data().optNm;
                        optionSelectOk = false;
                        return false;
                    }
                });
                if(!optionSelectOk) {
                    Dmall.LayerUtil.alert(optionNm +'<br>옵션을 선택해 주십시요.');
                    return false;
                }
            }

            /* 필수 추가 옵션 선택 확인 */
            if(addOptionUseYn == 'Y' && addOptBoxCnt > 0) { // 필수 추가옵션이 있다면
                 $('select.select_option.goods_addOption').each(function(){
                     if($(this).data().requiredYn == 'Y') {
                         if(addOptRequiredOptNo.length == 0) {   //선택한 필수 추가 옵션이 없다면
                             optionNm = $(this).data().addOptNm;
                             addOptionSelectOk = false;
                             return false;
                         } else { //선택한 필수 추가 옵션이 있다면
                             if($.inArray($(this).data().addOptNo,addOptRequiredOptNo) == -1) {
                                 optionNm = $(this).data().addOptNm;
                                 addOptionSelectOk = false;
                                 return false;
                             }
                         }
                     }
                 });
                 if(!addOptionSelectOk) {
                     Dmall.LayerUtil.alert(optionNm +'<br>옵션을 선택해 주십시요.');
                     return false;
                 }
            }

            //재고 확인
            if(multiOptYn == 'Y') {
                $('[id^=option_layer_]').each(function(){
                    stockQttOk = jsCheckOptionStockQtt($(this));
                    itemNm = $(this).data().itemNm;
                    if(!stockQttOk) {
                        return false;
                    }
                });
            } else {
                stockQttOk = jsCheckOptionStockQtt($('#goods_form'));
            }
            if(!stockQttOk) {
                if(itemNm == '') {
                    Dmall.LayerUtil.alert('재고수량을 확인해 주시기 바랍니다.');
                } else {
                    Dmall.LayerUtil.alert(itemNm+'<br>재고수량을 확인해 주시기 바랍니다.');
                }
                return false;
            }
            return true;
        }
    }
    
    InterestBasketUtil = {
        customAjax:function(url, param, callback) {
            Dmall.waiting.start();
            $.ajax({
                type : 'post',
                url : url,
                data : param,
                dataType : 'json',
                traditional:true
            }).done(function(result) {
                if (result) {
                    Dmall.AjaxUtil.viewMessage(result, callback);
                } else {
                    callback();
                }
                Dmall.waiting.stop();
            }).fail(function(result) {
                Dmall.waiting.stop();
                Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
            });
        }
        , checkBasketProc:function() { //선택 장바구니 등록
            var basketPageMovYn = '${site_info.basketPageMovYn}';
            var chkItem = $('input:checkbox[name=goodsNoArr]:checked').length;
            if(chkItem == 0){
                Dmall.LayerUtil.alert('상품을 선택해 주십시요');
                return;
            }

            Dmall.LayerUtil.confirm('등록하시겠습니까?', function() {
                var url = '${_MOBILE_PATH}/front/interest/basket-insert'
                    , param = {}
                    , goodsNoArr = []
                    , itemNoArr = [];

                $('input:checkbox[name=goodsNoArr]:checked').each(function() {
                    goodsNoArr.push($(this).parents('li').attr('data-goods-no'));
                    itemNoArr.push($(this).parents('li').attr('data-item-no'));
                })
                param = {'goodsNoArr':goodsNoArr, 'itemNoArr':itemNoArr};

                InterestBasketUtil.customAjax(url, param, function(result) {
                    if(result.success){
                        if(basketPageMovYn === 'Y') {
                            Dmall.LayerPopupUtil.open($('#success_basket'));//장바구니 등록성공팝업
                        } else {
                            location.href = "${_MOBILE_PATH}/front/basket/basket-list";
                        }
                    } else {
                        if(result.data.adultFlag != '' && result.data.adultFlag === 'Y') {
                            location.href = '${_MOBILE_PATH}/front/interest/adult-restriction';
                        }
                    }
                });
            });
        }
        , directBasketProc:function() { //개별 장바구니 등록
            var basketPageMovYn = '${site_info.basketPageMovYn}';
            var url = '${_MOBILE_PATH}/front/interest/basket-insert'
                , param = {'goodsNoArr':InterestUtil.goodsNo, 'itemNoArr':InterestUtil.itemNo};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success){
                    if(basketPageMovYn === 'Y') {
                        Dmall.LayerPopupUtil.open($('#success_basket'));//장바구니 등록성공팝업
                    } else {
                        location.href = "${_MOBILE_PATH}/front/basket/basket-list";
                    }
                } else {
                    if(result.data.adultFlag != '' && result.data.adultFlag === 'Y') {
                        location.href = '${_MOBILE_PATH}/front/interest/adult-restriction';
                    }
                }
            });
        }
    }
    
    InterestDeleteUtil = {
        deleteUrl:'${_MOBILE_PATH}/front/interest/interest-item-delete'
        , completeDeleteMsg:function() { // 삭제 완료후 페이지 새로고침
            Dmall.LayerUtil.alert('관심상품이 삭제 되었습니다.').done(function(){
                location.reload();
            });
        }
        , allDelete:function() { //상품 전체삭제
            $('#allCheck').trigger('click');
            var chkItem = $('input:checkbox[name=goodsNoArr]:checked').length;
            if(chkItem == 0){
                Dmall.LayerUtil.alert('삭제할 상품이 없습니다.');
                $('#allCheck').trigger('click');
                return;
            }
            Dmall.LayerUtil.confirm('전체 삭제하시겠습니까?', InterestDeleteUtil.deleteProc, InterestUtil.allCheck);
        }
        , checkDelete:function() { //선택상품 삭제
            var chkItem = $('input:checkbox[name=goodsNoArr]:checked').length;
            if(chkItem == 0){
                Dmall.LayerUtil.alert('삭제할 상품을 선택해 주십시요');
                return;
            }
            Dmall.LayerUtil.confirm('삭제하시겠습니까?', InterestDeleteUtil.deleteProc);
        }
        , deleteProc:function() { //삭제 진행
            var param = $('#form_id_search').serialize();
            Dmall.AjaxUtil.getJSON(InterestDeleteUtil.deleteUrl, param, function(result) {
                if(result.success){
                    InterestDeleteUtil.completeDeleteMsg();
                }
            });
        }
        , directDeleteProc:function() { //개별 삭제 진행
            var url = '${_MOBILE_PATH}/front/interest/interest-item-delete';
            var param = {'goodsNoArr':InterestUtil.goodsNo};

            Dmall.AjaxUtil.getJSON(InterestDeleteUtil.deleteUrl, param, function(result) {
                if(result.success){
                    InterestDeleteUtil.completeDeleteMsg();
                }
            });
        }
    }
    
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			나의 관심상품
		</div>
		<div class="my_wishlist_top">
			<ul class="my_shopping_info">
				<li>최근 6개월간 저장하신 관심상품 리스트입니다.</li>
				<li>6개월 이전 저장하신 관심상품은 자동 삭제됩니다.</li>
			</ul>
		</div>
		<div class="my_wishlist_stit">
			* 총 <em>${so.totalCount }</em>개의 상품이 담겨 있습니다.
		</div>
        <form:form id="form_id_search" commandName="so">
        <form:hidden path="page" id="page" />		
		<ul class="product_list_typeA">
		<c:choose>
	       <c:when test="${resultListModel.resultList ne null}">
	           <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
	           <input type="hidden" name="itemNoArr" value="${resultModel.itemNo}"/>
				<li data-goods-no="${resultModel.goodsNo}" data-item-no="${resultModel.itemNo}" data-stock-qtt="${resultModel.stockQtt}"
                    data-tg-del-yn="${resultModel.tgDelYn}" data-ti-del-yn="${resultModel.tiDelYn}">
					<div class="goods_image_area">					
					   <a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${resultModel.goodsNo}">
						<img src="${resultModel.goodsDispImgC}">
						</a>
					</div>
					<div class="goods_title">
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${resultModel.goodsNo}">
							 ${resultModel.goodsNm}
						</a>
					</div>
					<div class="product_info">
						<c:choose>
                             <c:when test="${resultModel.stockQtt eq 0}">
                                 <span class="label_soldout" style="margin-right:3px">품절</span>
                             </c:when>
                             <c:otherwise>
                                 <button type="button" class="direct-basket-btn btn_mypage_s03" style="margin-right:3px">장바구니</button>
                             </c:otherwise>
                         </c:choose>
                        <button type="button" class="direct-delete-btn btn_mypage_s03">삭제</button>
					</div>
					<div class="price_info">
						\<fmt:formatNumber value="${resultModel.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
					</div>
				</li>
			  </c:forEach>
             </c:when>
            <c:otherwise>
                 <li style="text-align: center;width:100%">등록된 관심상품이 없습니다.</li>
            </c:otherwise>
        </c:choose>
		</ul>
		 <!---- 페이징 ---->
         <div class="my_list_bottom" id="div_id_paging">
             <grid:paging resultListModel="${resultListModel}" />
         </div>
         <!----// 페이징 ---->
         </form:form>
		 
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->
   
    </t:putAttribute>
</t:insertDefinition>