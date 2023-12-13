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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 결제 관리 &gt; 통합전자결제설정</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            var editYn = "${editYn}";
            $(document).ready(function() {
                // form validation 적용
                Dmall.validate.set('form_payment_config');

                // 목록
                $('#btn_list').on('click', function() {
                    location.href = "/admin/setup/config/payment/payment-list?pgCd=02";
                });

                // 저장
                $('#btn_save').on('click', function() {
                    dataUtil.save();
                });

                if(editYn === 'Y') {
                    dataUtil.select('');
                }
            });

            var dataUtil = {
                select: function(pgCd) {
                    var shopCd = $('#beforeShopCd').val();
                    var paramPgCd = (pgCd === '') ? '02' : pgCd;
                    var url = '/admin/setup/config/payment/payment-config-info',
                        param = {pgCd: paramPgCd, shopCd: shopCd};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result == null || result.success != true) {
                            return;
                        }

                        $('[data-find="payment_config"]').DataBinder(result.data);
                        $('input:radio[name=useYn][value='+result.data.useYn+']')
                            .prop('checked', true).parents('label').addClass('on')
                            .siblings().removeClass('on')
                    });
                },
                save: function() {
                    if(Dmall.validate.isValid('form_payment_config')) {
                        var url;
                        if(editYn === 'Y') {
                            url = '/admin/setup/config/payment/payment-config-update';
                        } else {
                            url = '/admin/setup/config/payment/payment-config-insert';
                        }
                        var param = $('#form_payment_config').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_payment_config');
                            if(result == null || result.success != true) {
                                return;
                            } else {
                                location.href = "/admin/setup/config/payment/payment-list?pgCd=02";
                            }
                        });
                    }
                }
            };
        </script>
       <script>
           var editYn = "${editYn}";
           $(document).ready(function() {
               return;

               $('#invididualBtn').hide();
               PaymentInitUtil.init();
               //두번쨰 파라미터에 PaymentInitUtil.initPgCd메서드를 콜백으로 넣는이유는
               //pgCd 라디오 초기화 메서드인 setPaymentCd에서 pgCd를 trigger시키기 때문에
               //render 무한루프가 되어서 pgCd만 trigger -> addClass로 변경하고 기존 선택된 결제구분을 지우기위해서이다.
               if(editYn === 'Y') {
                   PaymentRenderUtil.render('', PaymentInitUtil.initPgCd);
               }

               // 입금확인 URL, 카드사별 기간코드 버튼 클릭시
               $('.layerBtn').on('click', function(e) {
                   e.preventDefault();
                   e.stopPropagation();
                   PaymentPopupUtil.layerOpen(this);
               });

               //PG 업체선택 클릭시 이벤트
               $("input:radio[name=pgCd]").on('change', function(e) {
                   Dmall.EventUtil.stopAnchorAction(e);
                   //PaymentInicisUtil.tagOpen(this, '');
                   PaymentRenderUtil.render($(this).val(), PaymentInitUtil.initPgCd);
               });

               $('#btn_save').off('click').on('click', function(e) {
                   Dmall.EventUtil.stopAnchorAction(e);
                   PaymentSubmitUtil.save();
               });

               //무이자 여부 클릭시 이벤트(사용하지 않기로 기획쪽과 합의하였으나 추후 어떻게 될지모르므로 주석처리만 해놓는다. 2016-07-15 dong)
               /* $("input:radio[name=nointTypeCd]").on('change', function(e) {
                   Dmall.EventUtil.stopAnchorAction(e);
                   PaymentInicisUtil.nointHandler($(this).val());
               }); */

               //에스크로 여부 클릭시 이벤트
               $("input:radio[name=escrowUseYn]").on('change', function(e) {
                   Dmall.EventUtil.stopAnchorAction(e);
                   PaymentInicisUtil.escrowHandler($(this).val());
               });

               //입금확인 URL 세팅 방법 버튼 클릭시 이벤트
               $('#confirmUrlBtn').on('click', function(e) {
                   Dmall.EventUtil.stopAnchorAction(e);
                   var pgCd = $(this).attr('data-bind-value');
                   var tag = $('#paymentConfirmLayer').find('.payment-'+pgCd).trigger('click');
               });

               Dmall.validate.set('form_payment_config');
               Dmall.common.numeric();

               // 목록
               jQuery('#btn_list').off("click").on('click', function(e) {
                   Dmall.EventUtil.stopAnchorAction(e);
                   location.href = "/admin/setup/config/payment/payment-list?pgCd=02";
               });
           });

           var PaymentInicisUtil = {
               pgCd:''
               , tagOpen:function(obj, pgCd) {
                   if($(obj).val() === '02' || pgCd === '02') {
                       $('.tr-non-inicis').hide();
                       $('#nonInicisPgKey').prop('disabled', true);
                       $('#nonNointPeriodCd').prop('disabled', true);
                       $('#nointPeriodCd').prop('disabled', false);

                       //올더게이트 휴대폰 정보를 닫는다
                       $('#form_payment_config').find('.tr-allthe').each(function() {
                           $(this).find('input[type=text]').prop('disabled', true);
                           $(this).hide();

                       });
                       //이니시스 key파일을 항목을 오픈한다
                       $('#form_payment_config').find('.tr-inicis').each(function() {
                           $(this).find('input[type=text]').prop('disabled', false);
                           $(this).show();
                       });
                   } else if($(obj).val() === '04' || pgCd === '04') {
                       $('.tr-non-inicis').hide();
                       $('#nonInicisPgKey').prop('disabled', true);
                       $('#nonNointPeriodCd').prop('disabled', true);
                       $('#nointPeriodCd').prop('disabled', false);

                       //이니시스 key파일을 항목을 닫는다
                       $('#form_payment_config').find('.tr-inicis').each(function() {
                           $(this).find('input[type=text]').prop('disabled', true);
                           $(this).hide();
                       });
                       //올더게이트 휴대폰 정보를 오픈한다
                       $('#form_payment_config').find('.tr-allthe').each(function() {
                           $(this).find('input[type=text]').prop('disabled', false);
                           $(this).show();
                       });
                   } else {
                       $('.tr-non-inicis').show();
                       $('#nonInicisPgKey').prop('disabled', false);
                       $('#nonNointPeriodCd').prop('disabled', false);
                       $('#nointPeriodCd').prop('disabled', true);

                       //이니시스 key파일을 항목을 닫는다
                       $('#form_payment_config').find('.tr-inicis').each(function() {
                           $(this).find('input[type=text]').prop('disabled', true);
                           $(this).hide();
                       });
                       //올더게이트 휴대폰 정보를 닫는다.
                       $('#form_payment_config').find('.tr-allthe').each(function() {
                           $(this).find('input[type=text]').prop('disabled', true);
                           $(this).hide();
                       });
                   }
               }
               , nointHandler:function(value) {
                   value === '2' ? $('.tr-noint-text').show() : $('.tr-noint-text').hide();
               }
               , escrowHandler:function(value) {
                   if(value === 'Y') {
                       $('.tr-escrow').show()

                       if(PaymentInicisUtil.pgCd === '02') { //02: 이니시스
                           $('.tr-inicis-escrow').show();
                       }
                   } else {
                       $('.tr-escrow').hide();

                       if(PaymentInicisUtil.pgCd === '02') { //02: 이니시스
                           $('.tr-inicis-escrow').hide();
                       }
                   }
               }
           };

           var PaymentPopupUtil = {
               layerOpen:function(obj) {
                   Dmall.LayerPopupUtil.open($('#'+$(obj).attr('data-layer-type')+'Layer'));
               }
           };

           var PaymentInitUtil = {
               fileLoopSize:5
               , codeToNameJson:{'01':'KCP', '02':'KG이니시스', '03':'LGU+', '04':'올더게이트'}
               , initPgName:{'01':'KCP (ESCROW AX-HUB V6)', '02':'INIpay V5.0 - 오픈웹 (V 0.1.1 - 20120302)', '03':'LGU+', '04':'올더게이트'}
               , init:function() {
                   $('label.chack').off('click').on('click', function(e) {
                       Dmall.EventUtil.stopAnchorAction(e);
                       var $this = $(this),
                           $input = $("#" + $this.attr("for")),
                           checked = !($input.prop('checked'));
                       $input.prop('checked', checked);
                       $this.toggleClass('on');
                   });
               }
               , setUseYn:function(data, obj, bindName, target, area, row) {
                       var value = obj.data("bind-value")
                       , useYn = data[value]
                       , $label = jQuery(obj)
                       , $input = jQuery("#" + $label.attr("for"));


                   useYn = (useYn && ('Y' == useYn || '1' == useYn ));
                   // 체크박스 값 설정
                   if (useYn) {
                       $label.addClass('on');
                       $input.data('value','Y').prop('checked', true);
                   } else {
                       $label.removeClass('on');
                       $input.data('value','N').prop('checked', false);
                   }
               }
               , setPaymentCd:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];

                   $("input:radio[name=pgCd][value=" + value + "]").parent().parent().addClass('on');
                   $("input:radio[name=pgCd][value=" + value + "]").prop('checked', true);
               }
               , setNointTypeCd:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];

                   $("input:radio[name=nointTypeCd][value=" + value + "]").trigger('click');
               }
               , setCashRctUseYn:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];

                   $("input:radio[name=cashRctUseYn][value=" + value + "]").trigger('click');
               }
               , setEscrowUseYn:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];

                   $("input:radio[name=escrowUseYn][value=" + value + "]").trigger('click');
               }
               , setSafebuyImgDispSetCd:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];

                   $("input:radio[name=safebuyImgDispSetCd][value=" + value + "]").trigger('click');
               }
               , initPgCd:function(paramPgCd) {
                   var pgCd = (paramPgCd === '') ? '02' : paramPgCd;
                   $('#form_payment_config input:radio[name=pgCd]').each(function() {
                       if(pgCd !== $(this).val()) {
                           $(this).parent().parent().removeClass('on');
                       } else {
                           $(this).parent().parent().addClass('on');
                           $(this).attr('checked', 'checked');
                           $(this).prop('checked', true);

                           $('#tdPgNm').text(PaymentInitUtil.initPgName[$(this).val()]);
                           $('#pgNm').val(PaymentInitUtil.initPgName[$(this).val()]);
                       }
                   });

                   $('#confirmUrlBtn').attr('data-bind-value', pgCd);
               }
               , formReset:function() {
                   //input text 초기화
                   $('#form_payment_config')[0].reset();

                   //radio, checkbox 초기화
                   $('#form_payment_config input').each(function() {
                       var type = $(this).attr('type');
                       switch (type) {
                           case "text":
                               break;
                           case "radio":
                               if($(this).attr('name') !== 'pgCd') {
                                   $(this).parent().parent().removeClass('on');
                               }
                               break;
                           case "checkbox":
                               $(this).next().removeClass('on');
                               break;
                       }
                   });
               }
               , changeCodeToName:function(pgCd) {
                   return PaymentInitUtil.codeToNameJson[pgCd];
               }
               , fileTagPropInit:function(typeCode) {
                   if(typeCode === 'render') {
                       //이니시스 파일업로드 inputbox는 언제나 disabled상태여야 한다.
                       $('#file_escrowId').prop('disabled', true);
                       for(var i=1; i<PaymentInitUtil.fileLoopSize; i++) {
                           $('#file_pgKey'+i).prop('disabled', true);
                           $('#file_escrowKey'+i).prop('disabled', true);
                       }
                   } else {
                       $('#file_escrowId').removeAttr('disabled');
                       for(var i=1; i<PaymentInitUtil.fileLoopSize; i++) {
                           $('#file_pgKey'+i).removeAttr('disabled');
                           $('#file_escrowKey'+i).removeAttr('disabled');
                       }
                   }
               }
           };

           var PaymentSafeImageUtil = {
               initImageSet:function(data, pgCd) {
                   //$('#safeBuyImg').attr('src', '/front/img/footer/safe_'+pgCd+'.jpg');

               }
           };

           var PaymentRenderUtil = {
               render:function(pgCd, callback) {
                   var shopCd = "${shopCd}";
                   var paramPgCd = /*(pgCd === '') ? '02' : pgCd*/'02';
                   var url = '/admin/setup/config/payment/payment-config-info',
                   /* param = {'pgCd':pgCd === '' ? '01' : pgCd}, */

                   //통합전자결제 설정 페이지 첫 접속시에는 사용 여부가 Y인것을 불러오고 그외 PG선택시에는 사용여부를 공백으로 보낸다.
                   param = {'useYn':'Y', 'pgCd':'02', 'shopCd':shopCd},
                   dfd = jQuery.Deferred();

                   //새로운 PG를 선택했을떄 이전 정보들은 다 clear시켜야한다.
                   PaymentInitUtil.formReset();

                   console.log("param = ", param);
                   Dmall.AjaxUtil.getJSON(url, param, function(result) {
                       if (result == null || result.success != true) {
                           return;
                       }

                       dfd.resolve(result.data);
                       if(result.data != null) {
                           //PaymentInicisUtil.tagOpen('', result.data.pgCd);
                           $('.pg-title').text(PaymentInitUtil.changeCodeToName(result.data.pgCd));
                           PaymentRenderUtil.bind(result.data, paramPgCd);
                           callback(result.data.pgCd);
                       } else {
                           //PaymentInicisUtil.tagOpen('', paramPgCd);
                           $('.pg-title').text(PaymentInitUtil.changeCodeToName(paramPgCd));
                           PaymentInicisUtil.pgCd = paramPgCd;
                           PaymentSafeImageUtil.initImageSet(null, paramPgCd);
                           callback(paramPgCd);
                       }
                   });
                   return dfd.promise();
               }
               , bind:function(data, pgCd) {
                   PaymentInicisUtil.pgCd = data.pgCd;
                   PaymentInicisUtil.escrowHandler(data.escrowUseYn);
                   PaymentInicisUtil.nointHandler(data.nointTypeCd);

                   $('[data-find="payment_config"]').DataBinder(data);
                   PaymentSafeImageUtil.initImageSet(data, pgCd);
                   PaymentInitUtil.init();

                   //이니시스일경우에만
                   if(pgCd ==='02' || data !== null && data.pgCd === '02') {
                       PaymentInitUtil.fileTagPropInit('render');
                   }
               }
           };

           var PaymentSubmitUtil = {
               customAjax:function(url, callback) {

                   $('#form_payment_config').ajaxSubmit({
                       url : url,
                       dataType: 'json',
                       contentType: false,
                       processData: false,
                       success:function(result) {
                           if (result) {
                               Dmall.AjaxUtil.viewMessage(result, callback);
                           } else {
                               callback();
                           }
                       }
                       , error:function(result) {
                           Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
                       }
                   });
               }
               , save:function() {
                   //이니시스일경우에만 폼전송시 파일업로드를 하기위해 잠시 disabled 상태를 제거한다.
                   if($("input:radio[name=pgCd]:checked").val() === '02') {
                       PaymentInitUtil.fileTagPropInit('submit');
                   }
                   if(Dmall.validate.isValid('form_payment_config')) {
                       //아래 검증주석은 오픈후 주석 풀것
                       /* if($('#pgId').val().substring(0, 2) !== 'bl') {
                           Dmall.LayerUtil.alert('PG ID항목 값 앞자리에 "bl" 문구가 존재하지 않습니다', "알림");
                           return;
                       } */
                       var url;
                       if(editYn === 'Y') {
                           url = '/admin/setup/config/payment/payment-config-update';
                       } else {
                           url = '/admin/setup/config/payment/payment-config-insert';
                       }
                       var param = $('#form_payment_config').serialize();
                       console.log("param = ", param);
                       //Ajax를 공통 템플릿에 있는것을 사용안하고 새로 만들어서 사용하는 이유는
                       //Multipart 폼을 Ajax로 넘기려면 공통 템플릿에서 제공하는 Ajax함수로는 IE에서 작동하지 않는다.
                       //따라서 jquery.form.js에 존재하는 ajaxSubmit방식을 사용하여 통신한다.
                       PaymentSubmitUtil.customAjax(url, function(result) {
                           Dmall.validate.viewExceptionMessage(result, 'form_payment_config');
                           if (result == null || result.success != true) {
                               return;
                           } else {
                               PaymentRenderUtil.render(result.data.pgCd, PaymentInitUtil.initPgCd);
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
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">통합전자결제관리</h2>
            </div>
            <form action="" id="form_payment_config">
                <div class="line_box fri">
                    <input type="hidden" name="pgCd" value="02">
                    <input type="hidden" name="pgNm" value="INIpay V5.0 - 오픈웹 (V 0.1.1 - 20120302)">
                    <c:if test="${shopCd != null and shopCd != ''}">
                        <input type="hidden" name="beforeShopCd" id="beforeShopCd" value="${shopCd}">
                    </c:if>
                    <div class="tblw">
                        <table>
                            <colgroup>
                                <col width="160px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>가입자명</th>
                                <td>
                                    <span class="intxt long"><input type="text" id="shopNm" name="shopNm" data-find="payment_config" data-bind-value="shopNm" data-bind-type="text" maxlength="50" data-validation-engine="validate[required, maxSize[50]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>가맹점코드</th>
                                <td>
                                    <span class="intxt long"><input type="text" id="shopCd" name="shopCd" data-find="payment_config" data-bind-value="shopCd" data-bind-type="text" maxlength="50" data-validation-engine="validate[required, maxSize[50]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>KG이니시스 KEY</th>
                                <td>
                                    <span class="intxt long"><input type="text" id="inicisSignKey" name="signKey" data-find="payment_config" data-bind-value="signKey" data-bind-type="text" maxlength="300" data-validation-engine="validate[required, maxSize[300]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>사용여부</th>
                                <td>
                                    <tags:radio codeStr="Y:사용;N:사용안함" name="useYn" idPrefix="useYn" value="Y"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_list">목록</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_save">등록</button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>