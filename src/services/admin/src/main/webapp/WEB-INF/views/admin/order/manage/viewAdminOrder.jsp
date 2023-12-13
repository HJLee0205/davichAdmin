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
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 주문관리 &gt; 수기 주문 등록</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        var paymentTotalAmt = 0,
        basketTotalAmt = 0,
        dlvrWay = ""; 
        dlvrTotalAmt = 0,
        promotionTotalDcAmt = 0,
        // 적용
        jQuery(document).ready(function() {
            showBasketList();
            // 상품 검색 
            jQuery('#apply_goods_srch_btn').on('click', function(e) {
                Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
                GoodsSelectPopup._init(fn_callback_pop_apply_goods);
                $("#btn_popup_goods_search").trigger("click");
            });
                        
            /* 결제하기 */
            $('#btn_payment').on("click", function() {

                //결제수단
                if(Number($('#paymentAmt').val()) == 0) {
                    Dmall.LayerUtil.alert('상품을 선택해 주십시요.').done();
                    return false;
                }
                
                //주문자명
                if($.trim($('#ordrNm').val()) == '') {
                    Dmall.LayerUtil.alert('주문자명을 입력해 주십시요.').done(function(){
                        $('#ordrNm').focus();
                    });
                    return false;
                }

                //주문자 전화번호(필수X)
                $('#ordrTel').val($('#ordrTel01').val()+'-'+$.trim($('#ordrTel02').val())+'-'+$.trim($('#ordrTel03').val()));

                //주문자 핸드폰
                if($.trim($('#ordrMobile02').val()) == '' || $.trim($('#ordrMobile03').val()) == '') {
                    Dmall.LayerUtil.alert('휴대폰번호를 입력해 주십시요.').done(function(){
                        $('#ordrMobile01').focus();
                    });
                    return false;
                } else {
                    $('#ordrMobile').val($('#ordrMobile01').val()+'-'+$.trim($('#ordrMobile02').val())+'-'+$.trim($('#ordrMobile03').val()));
                    var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                    if(!regExp.test($('#ordrMobile').val())) {
                        Dmall.LayerUtil.alert('유효하지 않은 휴대폰번호 입니다.<br>휴대폰번호를 정확히 입력해 주십시요.').done(function(){
                            $('#ordrMobile01').focus();
                        })
                        return false;
                    }
                }
                
                //주문자이메일
                if($.trim($('#email01').val()) == '' || $.trim($('#email02').val()) == '') {
                    Dmall.LayerUtil.alert('이메일을 입력해 주십시요.').done(function(){
                        $('#email01').focus();
                    });
                    return false;
                } else {
                    $('#ordrEmail').val($.trim($('#email01').val())+'@'+$.trim($('#email02').val()));
                }
                //수령인
                if($.trim($('#adrsNm').val()) == '') {
                    Dmall.LayerUtil.alert('수령인을 입력해 주십시요.').done(function(){
                        $('#adrsNm').focus();
                    });
                    return false;
                }

                if($('[name=memberGbCd]:checked').val() == '10') {
                    //국내배송지
                    if($.trim($('#postNo').val()) == '' || $.trim($('#numAddr').val()) == '' || $.trim($('#roadnmAddr').val()) == '') {
                        Dmall.LayerUtil.alert('배송지를 입력해 주십시요.').done(function(){
                            $('#postNo').focus();
                        });
                        return false;
                    }
                    //국내배송지 상세
                    if($.trim($('#dtlAddr').val()) == '' ) {
                        Dmall.LayerUtil.alert('상세주소를 입력해 주십시요.').done(function(){
                            $('#dtlAddr').focus();
                        });
                        return false;
                    }
                    $('[name=adrsAddr]').val( $('#postNo').val() + " " + (($('#roadnmAddr').val() == "")? $('#numAddr').val() :  $('#roadnmAddr').val())+ " " + $('#dtlAddr').val()  );
                } else {
                    //해외주소
                    $('[name=adrsAddr]').val($('#frgAddrCountry').val()+ " "+$('#frgAddrZipCode').val() + " " + $('#frgAddrState').val() + " " + $('#frgAddrCity').val()+ " " + $('#frgAddrDtl1').val()+ " " + $('#frgAddrDtl2').val());
                }
                
                //수령인 전화번호(필수X)
                $('#adrsTel').val($('#adrsTel01').val()+'-'+$.trim($('#adrsTel02').val())+'-'+$.trim($('#adrsTel03').val()));

                //수령인 휴대폰
                if( $.trim($('#adrsMobile02').val()) == '' || $.trim($('#adrsMobile03').val()) == '') {
                    Dmall.LayerUtil.alert('휴대폰번호를 입력해 주십시요.').done(function(){
                        $('#adrsMobile01').focus();
                    });
                    return false;
                } else {
                    $('#adrsMobile').val($('#adrsMobile01').val()+'-'+$.trim($('#adrsMobile02').val())+'-'+$.trim($('#adrsMobile03').val()));
                    var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                    if(!regExp.test($('#adrsMobile').val())) {
                        Dmall.LayerUtil.alert('유효하지 않은 휴대폰번호 입니다.<br>휴대폰번호를 정확히 입력해 주십시요.').done(function(){
                            $('#adrsMobile01').focus();
                        })
                        return false;
                    }
                }

                if($('[name=bankCd]').val() == '') {
                    Dmall.LayerUtil.alert('입금은행을 선택해 주십시요.').done(function(){
                        $('[name=bankCd]').focus();
                    });
                    return false;
                } else {
                    $('[name=bankCd]').find('option:selected').each(function(){
                        var d = $(this).data();
                        $('#depositActNo').val(d.actNo);
                        $('#depositHolderNm').val(d.holderNm);
                    })
                }
                checked = $("#smsYn").hasClass('on');

                // SMS 수신이면
                if(checked) {
                    if($('#recvTelNo').val()=='') {
                        Dmall.LayerUtil.alert('SMS 수신번호를 입력해 주십시요.')
                        return false;
                    }
                    if($('#sendWords').val()=='') {
                        Dmall.LayerUtil.alert('SMS 내용을 입력해 주십시요.')
                        return false;
                    }
                }
                $('#frmAGS_pay').attr('action','/admin/order/manage/order-insert');
                $('#frmAGS_pay').submit();
            });
            
            // 회원 검색
            $('#btn_memSrch').on("click", function(e) {
                e.preventDefault();
                e.stopPropagation();
                jQuery("#memberCheckAll").parents('label').removeClass('on')
                //회원 조회
                searchMember();
                
            });
            
            $('#smsYnChk').on("click", function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                checked = $("#smsYn").hasClass('on');
                // SMS 수신이면
                if(!checked) {
                    //SMS 보유 건수 확인
                    if($("#byteVal").text() >= 80){
                        $("#sendFrmCd").val("02");
                        if($("#smsPossCnt").val() < 3){
                            Dmall.LayerUtil.alert("SMS 보유 건수가 부족합니다.");
                            $("#recvTelNo").val('');
                            $("#sendWords").val('');
                            return;
                        }
                    }else{
                        $("#sendFrmCd").val("01");
                        if($("#smsPossCnt").val() <= 0){
                            Dmall.LayerUtil.alert("SMS 보유 건수가 부족합니다.");
                            $("#recvTelNo").val('');
                            $("#sendWords").val('');
                            return;
                        }
                    }
                    $("#recvTelNo").val($('#adrsMobile01').val()+ $('#adrsMobile02').val()+$('#adrsMobile03').val());
                } else {
                    $("#recvTelNo").val('');
                }
            });
            
            //sms 내용 글자 byte 출력
            $(document).on('keyup', '#sendWords', function(e){
                var text = $(this).val();
                var $textLengthInfo = $(this).parent().parent().find('strong.byte');
                $textLengthInfo.html("<span class='point_c3' id='byteVal'> " + getTextLength(text) + "</span> byte");
            });
            
            //sms 보유 건수 조회
            var url = Constant.smsemailServer + '/sms/point/'+siteNo,
            param = "";
            
            /*Dmall.AjaxUtil.getJSONP(url, param, function(result) {
                $("#smsPossCnt").val(result);
            });*/
        });

        //발급하기POPUP : 회원검색POPUP 띄우기
        function searchMember(){
             //화면 리셋 : 회원검색POPUP : 검색결과 지우기
             $("#tbody_popup_member_data").children("tr").each(function() {
                $(this).remove(); 
             });
             
            var url = '/admin/member/manage/member-list-pop';
            var param = $('#form_member_search').serialize();
//             dfd = jQuery.Deferred();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if (result == null || result.success != true) {
                    return;
                }
                // 취득결과 셋팅
                jQuery.each(result.resultList, function(idx, obj) {
                     setMemberData(obj);
                }); 
                
                $("#couponNmMemPop").text($("#coupon_nm_pop").text() + "- 회원검색");
                Dmall.LayerPopupUtil.open(jQuery('#member_popup'));
//                 dfd.resolve(result.resultList);

                //회원검색POPUP : 회원목록 페이징 처리
                Dmall.GridUtil.appendPaging('form_member_search', 'member_paging', result, 'paging_id_member_list', searchMember);
                $("#searchedCnt").text(result.filterdRows);
                $("#totalCnt").text(result.totalRows);
                $("#currentPage").text(result.page);
                $("#totalPages").text(result.totalPages);
                
                if(result.filterdRows == 0){
                    template = '<tr><td colspan = "10">데이터가 없습니다.</td></tr>'                
                    $('#tbody_popup_member_data').html(template);
                }    
            });
//             return dfd.promise();
        }; 
        
        function setMemInfo(obj) {
            if(!$(obj).hasClass('on')) {
                var ordrNm = $(obj).parents('tr').data('nm');
                var email = $(obj).parents('tr').data('email');
                var mobile = $(obj).parents('tr').data('mobile');
                var tel = $(obj).parents('tr').data('tel');
                var ordrMobile = mobile.split('-');
                var ordrTel = tel.split('-');
                var ordrEmail = email.split('@');
                $('#ordrNm').val(ordrNm);
                $('#ordrMobile01').val(ordrMobile[0]);
                $('#ordrMobile02').val(ordrMobile[1]);
                $('#ordrMobile03').val(ordrMobile[2]);
                $('#ordrTel01').val(ordrTel[0]);
                $('#ordrTel02').val(ordrTel[1]);
                $('#ordrTel03').val(ordrTel[2]);
                $('#email01').val(ordrEmail[0]);
                $('#email02').val(ordrEmail[1]);
                
            } else {
                $('#ordrNm').val('');
                $('#ordrMobile01').val('');
                $('#ordrMobile02').val('');
                $('#ordrMobile03').val('');
                $('#ordrTel01').val('');
                $('#ordrTel02').val('');
                $('#ordrTel03').val('');
                $('#email01').val('');
                $('#email02').val('');
            }
            Dmall.LayerPopupUtil.close('member_popup');
        }
        
        //회원검색POPUP : 취득한 데이터를 회원검색결과에 바인딩
        function setMemberData(result){
            var template = '';
                template += '<tr data-nm="'+result.memberNm +'" data-email="'+result.email +'" data-mobile="'+Dmall.formatter.mobile(result.mobile) +'" data-tel="'+Dmall.formatter.tel(result.tel) + '">';
                template +=     '<td>'
                template +=          '<label for="chack0' + result.rownum + '" class="chack" oncliCk="javascript:setMemInfo(this)">';
                template +=             '<span class="ico_comm">';
                template +=                 '<input type="checkbox" name="table" id="chack0' + result.rownum + '" class="blind" value="' + result.memberNo + '">';
                template +=             '</span>';
                template +=          '</label>'; 
                template +=     '</td>';
                template +=     '<td>' + result.rownum + '</td>';
                template +=     '<td>' + result.memberGradeNm + '</td>';
                template +=     '<td>' + result.loginId + '</td>';
                template +=     '<td>' + result.memberNm + '</td>';
                template +=     '<td>' + result.email + '</td>';  
                template +=     '<td>' + result.mobile +'</td>'; 
                template +=     '<td>' + result.tel + '</td>';
                template +=     '<td style="display:none"  id="memberNo0' + result.rownum + '">' + result.memberNo + '</td>';
                template += '</tr>';
                $('#tbody_popup_member_data').append(template);
        };   
        //byte 계산
        function getTextLength(str){
            var len = 0;
            for (var i = 0; i < str.length; i++) {
                if (escape(str.charAt(i)).length == 6) {
                    len++;
                }
                len++;
            }
            return len;
        }
            // 적용
        // 상품 팝업 리턴 콜백함수 - 테스트용
        function fn_callback_pop_apply_goods(data) {
            var formCheck = true;
//            formCheck = jsFormValidation();
            jQuery('#goods_form input[name=goodsNoArr]').val(data['goodsNo']);
            jQuery('#goods_form input[name=goodsNo]').val(data['goodsNo']);
            jQuery('#goods_form input[name=itemNoArr]').val(data['itemNo']);

            $('#ajaxGoodsList').find('tr').each(function(){
                var d= $(this).data();
                if(d.goodsNo == data['goodsNo']) {
                    formCheck = false;
                }
            });
            if(data['goodsSaleStatusCd'] != 1) {
                Dmall.LayerUtil.alert('판매중 상품이 아닙니다.');
            } else if(!formCheck) {
                Dmall.LayerUtil.alert('이미 등록된 상품입니다.');
                return false;
            } else {
                if(formCheck) {
                    var url = '/admin/order/manage/basket-insert';
                    var param = $('#goods_form').serialize();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Dmall.LayerUtil.alert('상품이 등록 되었습니다.');
                            showBasketList();
                            Dmall.LayerPopupUtil.close('layer_popup_goods_select');
                        }
                    });
                }
            }
        }
        
        function showBasketList() {
            paymentTotalAmt = 0,
            basketTotalAmt = 0,
            dlvrWay = "", 
            dlvrTotalAmt = 0,
            promotionTotalDcAmt = 0;
            
            var url = "/admin/order/manage/order-goods-list";
            param = jQuery('#goods_form').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                
                var tr = ''; 
                if(result.success) {
                    jQuery.each(result.data.basketList, function(idx, obj) {
                        var totalAddOptionAmt = 0,
                     // 할인금액 계산(기획전 -> 등급할인 순서)
                        dcPrice = 0, // 할인금액SUM(기획전+등급할인)
                        prmtDcPrice=0;  // 기획전 할인
                        // 할인금액 계산(기획전)
                        if(obj.dcRate == 0)
                            prmtDcPrice = 0;
                        else {
                            prmtDcPrice = obj.salePrice * (obj.dcRate/100)/10;
                            prmtDcPrice = (prmtDcPrice - (prmtDcPrice%1))*10*obj.buyQtt;
                        }
                        var grpId = '';
                        // 배송비 계산 
                        if(obj.dlvrSetCd == '1' && obj.dlvrcPaymentCd=='01') {
                            grpId =obj.sellerNo + '**' + obj.dlvrSetCd + '**' + obj.dlvrcPaymentCd;
                        } else if(obj.dlvrSetCd == '1' && obj.dlvrcPaymentCd=='02') {
                            grpId =obj.sellerNo + '**' + obj.dlvrSetCd + '**' + obj.dlvrcPaymentCd;
                        } else if(obj.dlvrSetCd == '4' && obj.dlvrcPaymentCd=='02') {
                            grpId = obj.goodsNo + '**' + obj.dlvrSetCd + '**' + obj.dlvrcPaymentCd;
                        } else if(obj.dlvrSetCd == '6' && obj.dlvrcPaymentCd=='02') {
                            grpId = obj.goodsNo + '**' + obj.dlvrSetCd + '**' + obj.dlvrcPaymentCd;
                        } else  {
                            grpId = obj.itemNo + '**' + obj.dlvrSetCd + '**' + obj.dlvrcPaymentCd;
                        }
                        var preGrpId = '';
                        if(preGrpId !=grpId) {
                            if(result.data.dlvrPriceMap[grpId] == 0) {
                                if(obj.dlvrcPaymentCd!='03' && obj.dlvrcPaymentCd!='04')
                                    dlvrWay = '무료';
                            } else
                                dlvrWay = result.data.dlvrPriceMap[grpId] + '원';
                        }
                        preGrpId = grpId;

                        dlvrTotalAmt = dlvrTotalAmt + result.data.dlvrPriceMap[grpId];
                        
                        var template1 = '<tr data-goods-no="{{goodsNo}}" data-item-no="{{itemNo}}" data-item-nm="{{goodsNm}}"' + 
                            '    data-item-price= "{{salePrice}}" data-session-index="' + idx + '" data-basket-no = "{{basketNo}}">' +
                            '    <td><a href="javascript:deleteBasket(this)" class="ico_comm trdel" id = "btnBasketDelete"  name = "btnBasketDelete">삭제</a></td>' +
//                            '    <td>' + 
//                            '        <div class="cart_check">' + 
//                            '            <label>' + 
//                            '                <input type="checkbox" name="delBasketNoArr" id="delBasketNoArr_' + idx + '" value = ' + idx +' >' + 
//                            '                <span></span>' + 
//                            '            </label>' + 
//                            '        </div>' + 
//                            '    </td>' + 
                            '    <td class="textl">' + 
                            '        <img src="{{imgPath}}">' + 
//                            '        <a href="/front/goods/goods-detail?goodsNo={{goodsNo}}">{{goodsNm}}</a>' +
                            '        <a href="#none">{{goodsNm}}</a>' + 
                            '        <ul class="cart_s_list">' ; 
                         var template2_1 = '<li>{{optNo1Nm}} : {{attrNo1Nm}}</li>', 
                         template2_2 = '<li>{{optNo2Nm}} : {{attrNo2Nm}}</li>', 
                         template2_3 = '<li>{{optNo3Nm}} : {{attrNo3Nm}}</li>', 
                         template2_4 = '<li>{{optNo4Nm}} : {{attrNo4Nm}}</li>',
                         template_opt_1 = 
                            '                <li>' +
                            '                    {{addOptValue}} ( ' ;

                         template_opt_2 = 
                            '                    {{addOptAmt}}원)' +
                            '                              수량 : ${basketAddOptList.optBuyQtt} 개' +
                            '                </li>' ;
                         template3 =
                            '        </ul>' +
                            '    </td>' ,
                                <%-- 상품금액 --%>

                         template4 =
                            '    <td>' ;
                         template4 += '                    <span class="intxt shot3"> <input type="text" name="buyQtt_' + idx +'" id="buyQtt_' + idx +'" value="{{buyQtt}}"></span>' ;
                         template4 += '                    <button type="button" class="btn_gray" onClick="javascript:updateBasketCnt(this)">수정</button>';
                         template4 += '<input type="hidden" name="itemArr" id="itemArr" value="{{itemArr}}">';
                         template4 += '<input type="hidden" name="goodsDcPriceInfo" id="goodsDcPriceInfo" value="' + dcPrice + '"/>';  

                         if (Number(prmtDcPrice) >  0)
                             template4 += '<input type="hidden" name="goodsPromotionDcInfo" value="{{prmtNo}}▦01▦{{dcRate}}▦' + prmtDcPrice + '"/>';
                         else 
                             template4 += '<input type="hidden" name="goodsPromotionDcInfo" value=""/>';
                         template4 += '    </td>' ;
                                <%-- 합계 --%>
                         var mTemplate1 = new Dmall.Template(template1),
                         mTemplate1 = new Dmall.Template(template1),
                         mTemplate2_1 = new Dmall.Template(template2_1),
                         mTemplate2_2 = new Dmall.Template(template2_2),
                         mTemplate2_3 = new Dmall.Template(template2_3),
                         mTemplate2_4 = new Dmall.Template(template2_4);
                         tr += mTemplate1.render(obj);
                         if(obj.optNo1Nm!='N')
                             tr += mTemplate2_1.render(obj);
                         if(obj.optNo2Nm!='N')
                             tr += mTemplate2_2.render(obj);
                         if(obj.optNo3Nm!='N')
                             tr += mTemplate2_3.render(obj);
                         if(obj.optNo4Nm!='N')
                             tr += mTemplate2_4.render(obj);
                         jQuery.each(obj.basketOptList, function(idx2, obj2) {
                             var mTemplate_opt_1 =  new Dmall.Template(template_opt_1);
                             tr += mTemplate_opt_1.render(obj2);
                             if(obj2.addOptAmtChgCd == '1')  tr += '+';
                             else tr += '-';
                             totalAddOptionAmt =totalAddOptionAmt+obj2.addOptAmt*obj2.optBuyQtt;
                             var mTemplate_opt_2 = new Dmall.Template(template_opt_2);
                             tr += mTemplate_opt_2.render(obj2);
                         });
                         
                         var goodstotalAmt = obj.salePrice*obj.buyQtt+totalAddOptionAmt;
                         basketTotalAmt = Number(basketTotalAmt) + Number(goodstotalAmt);
                           
                         promotionTotalDcAmt = Number(promotionTotalDcAmt)+Number(prmtDcPrice);

                         var mTemplate3 = new Dmall.Template(template3),
                         mTemplate4 = new Dmall.Template(template4);
                         tr += mTemplate3.render(obj);
                         tr += '    <td>' ;
                         tr += commaNumber(Number(obj.salePrice)-Number(obj.dcAmt))  + ' 원' ;
                         tr += '    </td>' ;
                         tr += mTemplate4.render(obj);
                         tr += '    <td>' ;
                         tr += commaNumber(Number(goodstotalAmt)-Number(obj.dcAmt))  + ' 원' ;
                         tr += '    </td></tr>' ;
                     });
                     orderTotalAmt = Number(basketTotalAmt)-Number(promotionTotalDcAmt);

                     jQuery('#ajaxGoodsList').html(tr);
                     
                     // 총 판매금액(hidden)
                     jQuery('#orderTotalAmt').val(Number(orderTotalAmt));

                  // 할인 금액
                     $('#dcAmt').val(promotionTotalDcAmt);
                     $('#dlvrTotalAmt').val(dlvrTotalAmt);
                     $('#dlvrPriceMap').val(result.data.dlvrPriceMapStr);
                     $('#dlvrCountMap').val(result.data.dlvrCountMap);
                     jsCalcTotalAmt();
                     
                }
            });
        }

        /* currency(3자리수 콤마) */
        var commaNumber = (function(p){
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        });

        function  deleteBasket(obj) {
            var basketNo = jQuery(obj).parents('tr').data('basket-no');
            var goodsNo = jQuery(obj).parents('tr').data('goods-no');
            var itemNo = jQuery(obj).parents('tr').data('item-no');
            var sessionIndex = jQuery(obj).parents('tr').data('session-index');
            var buyQtt = jQuery("#buyQtt_"+sessionIndex).val();

            var url = '/admin/order/manage/basket-delete';
            var param = {basketNo:basketNo, goodsNo : goodsNo, itemNo:itemNo, sessionIndex:sessionIndex, buyQtt:buyQtt}

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                  showBasketList();
                }
            });
        }
        
       function  updateBasket(obj) {
            var goodsNo = jQuery(obj).parents('tr').data('goods-no');
            var itemNo = jQuery(obj).parents('tr').data('item-no');
            var itemNm = jQuery(obj).parents('tr').data('item-nm');
            var itemPrice = jQuery(obj).parents('tr').data('item-price');
            var sessionIndex = jQuery(obj).parents('tr').data('session-index');

            var param = 'goodsNo='+goodsNo+'&itemNo='+itemNo+'&sessionIndex='+sessionIndex;
            var url = '/admin/order/manage/goods-detail?'+param;

            Dmall.AjaxUtil.load(url, function(result) {
                $('#goodsDetail').html(result);
            })
            Dmall.LayerPopupUtil.open($("#success_basket"));
        }

        function  updateBasketCnt(obj) {
            var basketNo = jQuery(obj).parents('tr').data('basket-no');
            var goodsNo = jQuery(obj).parents('tr').data('goods-no');
            var itemNo = jQuery(obj).parents('tr').data('item-no');
            var sessionIndex = jQuery(obj).parents('tr').data('session-index');
            var buyQtt = jQuery("#buyQtt_"+sessionIndex).val();
            var url = '/admin/order/manage/basket-count-update';
            var param = {basketNo:basketNo, goodsNo : goodsNo, itemNo:itemNo, sessionIndex:sessionIndex, buyQtt:buyQtt}

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     showBasketList();
                 }
            });
        }

        //숫자만 입력 가능 메소드
        function onlyNumDecimalInput(event){
            var code = window.event.keyCode;
            if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
                window.event.returnValue = true;
                return;
            }else{
                window.event.returnValue = false;
                return false;
            }
        }
        function btn_post() {
            Dmall.LayerPopupUtil.zipcode(setZipcode);
        };

        /* 우편번호 정보 반환 */
        function setZipcode(data) {
            var fullAddr = data.address; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수
            // 기본 주소가 도로명 타입일때 조합한다.
            if (data.addressType === 'R') {
                //법정동명이 있을 경우 추가한다.
                if (data.bname !== '') {
                    extraAddr += data.bname;
                }
                // 건물명이 있을 경우 추가한다.
                if (data.buildingName !== '') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
            }
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $('#postNo').val(data.zonecode);
            $('#numAddr').val(data.jibunAddress);
            $('#roadnmAddr').val(data.roadAddress);
            //지역 추가 배송비 설정
            jsSetAreaAddDlvr();
        }

        //지역 추가 배송비 설정
        function jsSetAreaAddDlvr() {
            var flag = false;
            var postNo = $('#postNo').val();
            var url = '/admin/order/manage/area-additional-cost';
            var param = {};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    for(var i=0; i<result.resultList.length;i++) {
                        if(result.resultList[i].postNo == postNo) {
                            flag = true;
                            var addDlvrPrice = result.resultList[i].dlvrc;
                            var areaDlvrSetNo = result.resultList[i].areaDlvrSetNo;
                            $('#addDlvrAmt').val(parseInt(addDlvrPrice));
//                            $('#dlvrTotalAmt').val(parseInt(dlvrTotalAmt));
                            $('#areaDlvrSetNo').val(areaDlvrSetNo);
                            $('#totalAddDlvrAmt').html('(+) '+commaNumber(parseInt(addDlvrPrice))+' 원');
                            jsCalcTotalAmt();
                            break;
                        }
                    }
                    if(!flag) {
                        $('#addDlvrAmt').val(0);
                        $('#totalAddDlvrAmt').html('(+) '+0+' 원');
                        jsCalcTotalAmt();
                    }
                }
            });
        }
        
        /* 결제금액 계산 */
        function jsCalcTotalAmt() {
            var orderTotalAmt = Number($('#orderTotalAmt').val()); //총주문금액
            var dcTotalAmt = Number($('#dcAmt').val()); //총할인금액
            var dlvrTotalAmt = Number($('#dlvrTotalAmt').val()); //배송비
            var addDlvrAmt = Number($('#addDlvrAmt').val()); //추가배송비
            // 폼에 넘길 결제할 금액 
            $('#paymentAmt').val(orderTotalAmt+dlvrTotalAmt+addDlvrAmt-dcTotalAmt);
            $('#totalPaymentAmt').html(commaNumber(orderTotalAmt+dlvrTotalAmt+addDlvrAmt-dcTotalAmt)+' 원');
        }

        </script>
        </t:putAttribute>
        <t:putAttribute name="content">
        <form name="goods_form" id="goods_form">
        <input type="hidden" name="goodsNoArr" id="goodsNoArr" value="${goodsInfo.data.goodsNo}">
        <input type="hidden" name="goodsNo" id="goodsNo" value="${goodsInfo.data.goodsNo}">
        <input type="hidden" name="dlvrMethodCd" id="dlvrMethodCd" value="01"> <!--  택배 -->
        <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="02"> <!--  선불 -->
        <input type="hidden" name="buyQttArr" id="input_goods_no" value="1">
        <input type="hidden" name="itemNoArr" id="itemNoArr" class="itemNoArr" value="">
        <input type="hidden" name="addOptNoArr" id="addOptNoArr" class="addOptNoArr" value="">
        
        <input type="hidden" name="noBuyQttArr" class="noBuyQttArr" value  ="N" >
        
        </form>
        <form name="frmAGS_pay" id="frmAGS_pay" method="post" action="">
        <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="11"/>
        <input type="hidden" name="ordNo" value="${ordNo}"/>
        <input type="hidden" name="manualOrdYn" value="Y"/>
        
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">수기 주문 등록</h2>
                <div class="btn_box right">
                    <!-- a href="#none" class="btn blue">등록</a-->
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <div class="btn_lay">
                    <a href="#none" class="btn_gray2" id="apply_goods_srch_btn">상품검색</a>
                </div>
                <!-- tblh -->
                <div class="tblh tblmany line_no">
                    <table summary="이표는 상품검색 리스트 표 입니다. 구성은 상품명, 판매가격(개), 수량, 합계 입니다.">
                        <caption>상품검색 리스트</caption>
                        <colgroup>
                            <col width="4%">
                            <col width="56%">
                            <col width="13%">
                            <col width="14%">
                            <col width="13%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th colspan="2">상품명</th>
                                <th>판매가격(개)</th>
                                <th>수량</th>
                                <th>합계</th>
                            </tr>
                        </thead>
                        <tbody id="ajaxGoodsList">
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <h3 class="tlth3 btn1">주문자 및 배송정보 </h3>
                <!-- hr_line -->
                <div class="hr_line">
                    <!-- tblw_gw -->
                    <div class="tblw_gw fri">
                        <div class="gw_tlt">01. 주문하시는 분</div>
                        <table summary="이표는 기본정보 표 입니다. 구성은 이름, 유선전화, 휴대폰, 이메일 입니다.">
                            <caption>기본정보</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>이름</th>
                                    <td><span class="intxt"><input type="text" id="ordrNm"  name="ordrNm" maxlength="20" /></span></td>
                                </tr>
                                <tr>
                                    <th>유선전화</th>
                                    <td>
                                        <span class="select">
                                        <label for="ordrTel01"></label>
                                        <select name="ordrTel01" id="ordrTel01" style="width:69px">
                                           <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                        </select>
                                        </span>
                                        -
                                        <span class="intxt shot3"><input type="text" name="ordrTel02" id="ordrTel02" maxlength="4" onKeydown="return onlyNumDecimalInput(event);"/></span>
                                        -
                                        <span class="intxt shot3"><input type="text" name="ordrTel03" id="ordrTel03" maxlength="4" onKeydown="return onlyNumDecimalInput(event);"/></span>
                                        <input type="hidden" name="ordrTel" id="ordrTel" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <th>휴대폰</th>
                                    <td>
                                        <span class="select">
                                        <label for="ordrMobile01"></label>
                                        <select name="ordrMobile01" id="ordrMobile01" style="width:69px">
                                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                        </select>
                                        </span>
                                        -
                                        <span class="intxt shot3"><input type="text" id="ordrMobile02" name="ordrMobile02" maxlength="4" /></span>
                                        -
                                        <span class="intxt shot3"><input type="text" id="ordrMobile03" name="ordrMobile03"  maxlength="4" /></span>
                                        <input type="hidden" name="ordrMobile" id="ordrMobile" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <th>이메일</th>
                                    <td>
                                        <span class="intxt"><input type="text" name="email01" id="email01" /></span>
                                        @
                                        <span class="intxt"><input type="text" name="email02" id="email02" /></span>
                                        <input type="hidden" name="ordrEmail" id="ordrEmail" value="">
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw_gw -->
                    <ul class="desc_list">
                        <li>주문자명이 실명이 아닐 경우 실명으로 수정해주세요.</li>
                        <li>주문내용을 이메일과 휴대폰으로 안내해드립니다.</li>
                    </ul>
                    <!-- tblw_gw -->
                    <div class="tblw_gw">
                        <div class="gw_tlt">02. 배송받는 분</div>
                        <table summary="이표는 기본정보 표 입니다. 구성은 이름, 배송방법, 주소, 휴대폰, 유선전화, 입니다.">
                            <caption>기본정보</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>이름</th>
                                    <td><span class="intxt"><input type="text" name="adrsNm" id="adrsNm" maxlength="20" ></span></td>
                                </tr>
                                <tr>
                                    <th>배송방법</th>
                                    <td>
                                        <label for="radio01_1" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="sex" id="radio01_1" checked="checked" /></span> 택배</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>거주지</th>
                                    <td colspan="3">
                                        <label for="radio01" class="radio mr20 ra on"><span class="ico_comm"><input type="radio" value="10" name="memberGbCd" id="radio01" checked="checked" /></span> 국내</label>
                                        <label for="radio02" class="radio mr20 rb"><span class="ico_comm"><input type="radio" value="20" name="memberGbCd" id="radio02" /></span> 해외</label>
                                    </td>
                                </tr>
                                
                                <!--국내 선택시 default-->
                                <tr class="radio_a">
                                    <th>주소</th>
                                    <td colspan="3">
                                        <div class="addr_field">
                                            <span class="intxt shot"><input type="text" name="postNo" id="postNo" readOnly/></span>
                                            <a href="#none" class="btn_gray" onClick="javascript:btn_post()">우편번호</a>
                                            <span class="br"></span>
                                            <label for="" class="in_long"><strong>지번</strong> <span class="intxt"><input type="text" name="numAddr" id="numAddr" /></span></label>
                                            <span class="br"></span>
                                            <label for="" class="in_long"><strong>도로명</strong> <span class="intxt"><input type="text" name="roadnmAddr" id="roadnmAddr" /></span></label>
                                            <span class="br"></span>
                                            <label for="" class="in_long"><strong>공통상세</strong> <span class="intxt"><input type="text" name="dtlAddr" id="dtlAddr"/></span></label>
                                        </div>
                                    </td>
                                </tr>
                                <!--//국내 선택시 default-->
                                
                                <!--해외 선택시 default-->
                                <tr class="radio_b" style="display:none;">
                                    <th>주소</th>
                                    <td colspan="3">
                                        <div class="addr_field">
                                            <label for="" class="in_long"><strong>Country</strong> 
                                                <span class="select">
                                                    <label for="">Select</label>
                                                    <select name="" id="">
                                                        <option value="">Select</option>
                                                    </select>
                                                </span>
                                            </label>
                                            <span class="br"></span>
                                            <label for="" class="in_long"><strong>Zip</strong> <span class="intxt"><input type="text" name="frgAddrZipCode" id="frgAddrZipCode" /></span></label>
                                            <span class="br"></span>
                                            <label for="" class="in_long"><strong>State</strong> <span class="intxt"><input type="text" name="frgAddrState" id="frgAddrState" /></span></label>
                                            <span class="br"></span>
                                            <label for="" class="in_long"><strong>City</strong> <span class="intxt"><input type="text" name="frgAddrCity" id="frgAddrCity" /></span></label>
                                            <span class="br"></span>
                                            <label for="" class="in_long"><strong>Address1</strong> <span class="intxt"><input type="text" name="frgAddrDtl1" id="frgAddrDtl1" /></span></label>
                                            <span class="br"></span>
                                            <label for="" class="in_long"><strong>Address2</strong> <span class="intxt"><input type="text" name="frgAddrDtl2" id="frgAddrDtl2" /></span></label>
                                        </div>
                                    </td>
                                </tr>
                                <!--//해외 선택시 default-->
                                <tr>
                                    <th>휴대폰</th>
                                    <td>
                                        <span class="select">
                                        <label for="adrsMobile01"></label>
                                        <select name="adrsMobile01" id="adrsMobile01" style="width:69px">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                        </select>
                                        </span>
                                        -
                                        <span class="intxt shot3"><input type="text" name="adrsMobile02" id="adrsMobile02" maxlength="4" onKeydown="return onlyNumDecimalInput(event);"></span>
                                        -
                                        <span class="intxt shot3"><input type="text" name="adrsMobile03" id="adrsMobile03" maxlength="4" onKeydown="return onlyNumDecimalInput(event);"></span>
                                        <input type="hidden" name="adrsMobile" id="adrsMobile" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <th>유선전화</th>
                                    <td>
                                        <span class="select">
                                        <label for="adrsTel01"></label>
                                        <select name="adrsTel01" id="adrsTel01" style="width:69px">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                        </select>
                                        </span>
                                        -
                                        <span class="intxt shot3"><input type="text" name="adrsTel02" id="adrsTel02" maxlength="4" onKeydown="return onlyNumDecimalInput(event);"></span>
                                        -
                                        <span class="intxt shot3"><input type="text" name="adrsTel03" id="adrsTel03" maxlength="4" onKeydown="return onlyNumDecimalInput(event);"></span>
                                        <input type="hidden" name="adrsTel" id="adrsTel" value="">
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <th>배송메시지</th>
                                    <td>
                                        <div class="txt_area tblin">
                                            <textarea name="dlvrMsg" id="dlvrMsg"></textarea>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw_gw -->
                    <p class="desc_p">※ 배송정보는 결제 시 회원이 직접 입력하는 영역이기 때문에 결제 후 회원이 등록하지 않은 경우에 관리자가 등록해 주시기 바랍니다.</p>
                </div>
                <!-- //hr_line -->
                <h3 class="tlth3">결제하기</h3>
                <!-- tblw -->
                <div class="tblw">
                    <table summary="이표는 결제하기 표 입니다. 구성은 결제수단 입니다.">
                        <caption>결제하기</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>결제수단</th>
                                <td>
                                    <label for="radio01" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="paymentWayCd" id="paymentWayCd" checked="checked" value="11"></span> 무통장 결제</label>
                                </td>
                            </tr>
                            <tr>
                                <th>입금은행</th>
                                <td>
                                    <span class="select">
                                    <label for="select_option">- 선택 -</label>
                                    <select class="select_option" title="select option" name="bankCd">
                                        <option value="" selected="selected">- 선택 - </option>
                                    <c:if test="${nopbListModel.resultList ne null }">
                                    <c:forEach var="nopbList" items="${nopbListModel.resultList}" varStatus="status">
                                        <option value="${nopbList.bankCd}" data-act-no="${nopbList.actno}" data-holder-nm="${nopbList.holder}">
                                        ${nopbList.bankNm}(${nopbList.actno}-${nopbList.holder})
                                        </option>
                                    </c:forEach>
                                    </c:if>
                                    </select>
                                    </span>
                                    <input type="hidden" name="depositActNo" id="depositActNo" value="">
                                    <input type="hidden" name="depositHolderNm" id="depositHolderNm" value="">
                                </td>
                            </tr>
                            <tr>
                            <th>총 결제금액</th>
                            <td><span id="totalPaymentAmt">0</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <div class="indi_pay_box">
                    <h3 class="tlth3">개인 결제 SMS</h3>
                    <div class="inpad">
                        <input type="checkbox" name="smsYnChk" class="blind" id="smsYnChk"/>
                        <label for="chack02" class="chack mr20" id="smsYn">
                            <span class="ico_comm">&nbsp;</span>
                            개인결제가 등록되었음을 소비자에게 알리겠습니다.
                        </label>
                        <span class="br"></span>
                        <span class="intxt shot" style="width:80px!important;"><input type="text" id="recvTelNo" name="recvTelnoSelect" style="width:80px!important;"/></span>
                        <span class="intxt long"><input type="text" id="sendWords" name="sendWords" /></span>
                        <strong class="byte"><span class="point_c3" id="byteVal">00</span> byte</strong>
                    </div>
                </div>
                <%-- 총 판매금액 --%>
                <input type="hidden" name="orderTotalAmt" id="orderTotalAmt" value="">
                <%-- 총 결제금액 --%>
                <input type="hidden" name="paymentAmt" id="paymentAmt" value=""/>
                <input type="hidden" name="dcAmt" id="dcAmt" value=""/>
                <input type="hidden" name="mileageTotalAmt" id="mileageTotalAmt" value="0"/>
                <input type="hidden" name="dlvrTotalAmt" id="dlvrTotalAmt" value="0"/>
                <input type="hidden" name="addDlvrAmt" id="addDlvrAmt" value="0">
                <input type="hidden" name="areaDlvrSetNo" id="areaDlvrSetNo" value="0">
                
                <input type="hidden" name="pvdSvmnTotalAmt" id="pvdSvmnTotalAmt" value="0">
                <input type="hidden" name="dlvrPriceMap" id="dlvrPriceMap" value="">
                <input type="hidden" name="dlvrCountMap" id="dlvrCountMap" value="">
                <!-- SMS 관련 -->
                <input type="hidden" id="receiverNo" name="receiverNoSelect" />
                <input type="hidden" id="receiverNm" name="receiverNmSelect" />
                <input type="hidden" id="receiverId" name="receiverIdSelect" />
                <input type="hidden" value="select" name="smsMember" />
                <input type="hidden" name="smsPossCnt" id="smsPossCnt" />
                <input type="hidden" value="01" name="sendTargetCd" />
                <input type="hidden" name="sendFrmCd" id="sendFrmCd" />
                
                <div class="btn_box txtc">
                    <button class="btn green" id="btn_payment" type="button">등록</button>
                    <button class="btn gray" onClick="history.back()" type="button">취소</button>
                </div>
            </div>
            <!-- //line_box -->
        </div>
    </form>
<!-- //content -->
    <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
        <!--- popup 주문조건 추가/변경 --->
    <div id="success_basket"  class="layer_popup" style="display: none;"><div id ="goodsDetail"></div></div>
    
<!-- 회원검색 -->
<div id="member_popup" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2" id="couponNmMemPop"></h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
          <div>
            <form id="form_member_search" action="/admin/member/manage/member-list-pop" method="post">
<!--             <input type="hidden" name="_action_type" value="INSERT" />                     -->
            <input type="hidden" id="member_search_page" name="page"/>
            <input type="hidden" name="rows"  value="10"/>
<!--             <input type="hidden" name="sort" value="REG_DTTM DESC" /> -->
            
            <!-- search_box -->
            <div class="tblw tblmany2 mt0">
                <!-- search_tbl -->
                        <table summary="이표는 회원리스트 검색 표 입니다. 구성은 가입일, 최종방문일, 생일, SMS수신, 이메이수신, 회원등급, 구매금액, 마켓포인트, 주문횟수, 댓글횟수, 방문횟수, 성별, 포인트, 가입방법, 검색어 입니다.">
                            <caption>회원 관리</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="30%">
                                <col width="20%">
                                <col width="30%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>가입일</th>
                                    <td colspan="3">
                                        <tags:calendar from="joinStDttm" to="joinEndDttm" fromValue="" toValue="" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>최종방문일</th>
                                    <td colspan="3">
                                        <tags:calendar from="loginStDttm" to="loginEndDttm" fromValue="" toValue="" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>생일</th>
                                     <td colspan="3">
                                        <tags:calendar from="stBirth" to="endBirth" fromValue="" toValue="" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>SMS수신</th>
                                    <td>
                                        <tags:radio name="smsRecvYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_smsRecvYn" value="" />
                                    </td>
                                    <th>이메일수신</th>
                                    <td>
                                        <tags:radio name="emailRecvYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_emailRecvYn" value="" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>회원등급</th>
                                    <td>
                                        <span class="select">
                                            <label for="srch_id_memberGrade"></label>
                                            <select name="memberGradeNo" id="srch_id_memberGrade">
                                                <option value="">전체</option>
                                                <option value="1"  >브론즈</option>
                                                <option value="2"  >실버</option>
                                                <option value="3"  >골드</option>
                                                <option value="4"  >플래티늄</option>
                                                <option value="5"  >VIP</option>
                                                <option value="6"  >VVIP</option>
                                                </select>
                                        </span>
                                    </td>
                                    <th>구매금액</th>
                                    <td>
                                        <span class="intxt intxt_50">
                                            <input id="stSaleAmt" name="stSaleAmt" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                        
                                        ~
                                        <span class="intxt intxt_50">
                                            <input id="endSaleAmt" name="endSaleAmt" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                        </td>
                                </tr>
                                <tr>
                                    <th>댓글횟수</th>
                                    <td>
                                        <span class="intxt intxt_50">
                                            <input id="stCommentCnt" name="stCommentCnt" class="text" type="text" value="" size="40" maxlength="50" /></span>
                                        
                                        ~
                                        <span class="intxt intxt_50">
                                            <input id="endCommentCnt" name="endCommentCnt" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                    </td>
                                    <th>주문횟수</th>
                                    <td>
                                        <span class="intxt intxt_50">
                                            <input id="stOrdCnt" name="stOrdCnt" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                        
                                        ~
                                        <span class="intxt intxt_50">
                                            <input id="endOrdCnt" name="endOrdCnt" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                     </td>
                                </tr>
                                <tr>
                                    <th>성별</th>
                                    <td>
                                        <label for="srch_id_genderGbCd_1" class="radio mr20 on">
                                            <span class="ico_comm"><input type="radio" name="genderGbCd" id="srch_id_genderGbCd_1" checked="checked" value="" /></span>전체</label>
                                        <label for="srch_id_genderGbCd_2" class="radio mr20">
                                            <span class="ico_comm"><input type="radio" name="genderGbCd" id="srch_id_genderGbCd_2" value="M" /></span>남</label>
                                        <label for="srch_id_genderGbCd_3" class="radio mr20">
                                            <span class="ico_comm"><input type="radio" name="genderGbCd" id="srch_id_genderGbCd_3" value="F" /></span>여</label>
                                    </td>
                                    <th>방문횟수</th>
                                    <td>
                                        <span class="intxt intxt_50">
                                            <input id="stLoginCnt" name="stLoginCnt" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                        
                                        ~
                                        <span class="intxt intxt_50">
                                            <input id="endLoginCnt" name="endLoginCnt" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp wid180x">
                                            <span class="wid80x">
                                                <label for="srch_id_searchType">전체</label>
                                                <select name="searchType" id="srch_id_searchType">
                                                    <tags:option codeStr="name:이름;id:아이디;email:이메일;tel:전화번호;mobile:핸드폰번호" value="" />
                                                </select>
                                            </span>
                                            <input id="searchWordsMember" name="searchWords" class="text" type="text" value="" maxlength="50" style="width:76px;"/>
                                       </div>
                                    </td>
                                    <th>다비치포인트</th>
                                    <td>
                                        <span class="intxt intxt_50">
                                            <input id="stPrcPoint" name="stPrcPoint" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                        
                                        ~
                                        <span class="intxt intxt_50">
                                            <input id="endPrcPoint" name="endPrcPoint" class="text" type="text" value="" size="40" maxlength="50"/></span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="btn_box txtc">
                        <button type="button" class="btn green" id="btn_id_search">검색</button>
                    </div>
            </div>
            </form>
            <!-- //line_box -->
            
            <div class="pr_lineBox">
                - 검색 <span class="pr_p_tx1" id="searchedCnt"></span>개 / 총 <span class="pr_p_tx2" id="totalCnt"></span> (현재 <span id="currentPage"></span>페이지 / 총 <span id="totalPages"></span> 페이지)
            </div>

            <!-- tblh -->
            <div class="tblh mt0" id="a">
                <table summary="이표는 회원검색 리스트 표 입니다. 구성은 등급, 아이디, 이름, 이메일, 핸드폰, 전화번호 입니다.">
                    <caption>회원검색</caption>
                    <colgroup>
                        <col width="5%">
                        <col width="5%">
                        <col width="10%">
                        <col width="17%">
                        <col width="8%">
                        <col width="25%">
                        <col width="15%">
                        <col width="15%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th></th>
                        <th>번호</th>
                        <th>등급</th>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>이메일(수신)</th>
                        <th>핸드폰(수신)</th>
                        <th>전화번호</th>
                        <th style="display:none">회원번호</th>
                    </tr>
                    </thead>
                    <tbody id="tbody_popup_member_data">
                    </tbody>
                </table>
            </div>
           <!-- //tblh -->
           <!-- bottom_lay -->
           <div class="bottom_lay" id="member_paging"></div>
           <!-- //bottom_lay -->
           <div class="btn_box txtc">
               <button class="btn green close" >닫기</button>
           </div>
        </div>
        </div>
     </div>
</div>
    </t:putAttribute>
</t:insertDefinition>