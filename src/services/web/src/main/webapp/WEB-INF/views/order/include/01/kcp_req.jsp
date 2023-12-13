<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<!-- KCP연동 -->
<script type="text/javascript">
    /****************************************************************/
    /* m_Completepayment  설명                                      */
    /****************************************************************/
    /* 인증완료시 재귀 함수                                         */
    /* 해당 함수명은 절대 변경하면 안됩니다.                        */
    /* 해당 함수의 위치는 payplus.js 보다먼저 선언되어여 합니다.    */
    /* Web 방식의 경우 리턴 값이 form 으로 넘어옴                   */
    /* EXE 방식의 경우 리턴 값이 json 으로 넘어옴                   */
    /****************************************************************/
    function m_Completepayment( FormOrJson, closeEvent )
    {
        var frm = document.frmAGS_pay;

        /********************************************************************/
        /* FormOrJson은 가맹점 임의 활용 금지                               */
        /* frm 값에 FormOrJson 값이 설정 됨 frm 값으로 활용 하셔야 됩니다.  */
        /* FormOrJson 값을 활용 하시려면 기술지원팀으로 문의바랍니다.       */
        /********************************************************************/
        GetField( frm, FormOrJson );


        if( frm.res_cd.value == "0000" )
        {
            /*
                가맹점 리턴값 처리 영역
            */

            frm.submit();
        }
        else
        {
            alert( "[" + frm.res_cd.value + "] " + frm.res_msg.value );

            closeEvent();
        }
    }
</script>
<c:choose>
    <c:when test="${server eq 'local' }">
    <script type="text/javascript" src="https://testpay.kcp.co.kr/plugin/payplus_web.jsp"></script>
    </c:when>
    <c:otherwise>
    <script type="text/javascript" src="https://pay.kcp.co.kr/plugin/payplus_web.jsp"></script>
    </c:otherwise>
</c:choose>

<script type="text/javascript">

    /* Payplus Plug-in 실행 */
    function jsf__pay( form )
    {
        try
        {
            KCP_Pay_Execute( form );

        }
        catch (e)
        {
            /* IE 에서 결제 정상종료시 throw로 스크립트 종료 */
        }
    }

    function createGoodsInfo() {
        var chr30 = String.fromCharCode(30);    // ASCII 코드값 30
        var chr31 = String.fromCharCode(31);    // ASCII 코드값 31
        var good_info = '';
        var len = $('[name=itemNo]').length;
        $('[name=itemNo]').each(function(i){
            var good_name = $('[name=goodsNm]').eq(i).val();
            if(good_name.length > 30) {
                good_name = goods_name.substring(0,30);
            }
            var good_cntx = $('[name=ordQtt]').eq(i).val();
            var good_amtx = $('[name=escwAmt]').eq(i).val();
            good_info += 'seq='+(i+1)+ chr31 + 'ordr_numb=${ordNo}' + chr31 + 'good_name='+ good_name + chr31 + 'good_cntx='
                       + good_cntx + chr31 + 'good_amtx=' + good_amtx;
            if(i != len -1) {
                good_info += chr30;
            }
        })
        /* var good_info = "seq=1" + chr31 + "ordr_numb=20060310_0001" + chr31 + "good_name=양말" + chr31 + "good_cntx=2" + chr31 + "good_amtx=2000" + chr30 +
                        "seq=2" + chr31 + "ordr_numb=20060310_0002" + chr31 + "good_name=신발" + chr31 + "good_cntx=1" + chr31 + "good_amtx=1500" + chr30 +
                        "seq=3" + chr31 + "ordr_numb=20060310_0003" + chr31 + "good_name=바지" + chr31 + "good_cntx=1" + chr31 + "good_amtx=1500"; */

        document.frmAGS_pay.good_info.value = good_info;
        document.frmAGS_pay.bask_cntx.value = len;
    }

</script>
<!-- 에스크로 설정정보 -->
<!-- 수취인명 -->
<input type="hidden" name="rcvr_name" value="">
<!-- 수취인 전화번호 -->
<input type="hidden" name="rcvr_tel1" value="">
<!-- 수취인 핸드폰번호 -->
<input type="hidden" name="rcvr_tel2" value="">
<!-- 수취인 이메일 -->
<input type="hidden" name="rcvr_mail" value="">
<!-- 수취인 우편번호 -->
<input type="hidden" name="rcvr_zipx" value="">
<!-- 수취인 주소 -->
<input type="hidden" name="rcvr_add1" value="">
<!-- 수취인 상세주소 -->
<input type="hidden" name="rcvr_add2" value="">

<input type="hidden" name="req_tx"          value="pay" />
<input type="hidden" name="site_cd"         value="${pgPaymentConfig.data.pgId}" />
<input type="hidden" name="site_name"       value="${site_info.siteNm}" />

<input type="hidden" name="quotaopt"        value="${pgPaymentConfig.data.instPeriod}"/>
<!-- 필수 항목 : 결제 금액/화폐단위 -->
<input type="hidden" name="currency"        value="WON"/>
<!-- 가상계좌 입금 기한 -->
<input type="hidden" name="vcnt_expire_term" value="5"/>

<!-- PLUGIN 설정 정보입니다(변경 불가) -->
<input type="hidden" name="module_type"     value="01"/>

<!-- Payplus Plugin 에스크로결제 사용시 필수 정보 -->
<!-- 에스크로 사용 여부 : 반드시 Y 로 설정 -->
<input type="hidden" name="escw_used"       value="Y"/>
<!-- 에스크로 결제처리 모드 : 에스크로: Y, 일반: N, KCP 설정 조건: O  -->
<input type="hidden" name="pay_mod"         value="Y"/>
<!-- 배송 소요일 : 예상 배송 소요일을 입력 -->
<input type="hidden"  name="deli_term" value="03"/>
<!-- 장바구니 상품 개수 : 장바구니에 담겨있는 상품의 개수를 입력(good_info의 seq값 참조) -->
<input type="hidden"  name="bask_cntx" value="0"/>
<!-- 장바구니 상품 상세 정보 (자바 스크립트 샘플 create_goodInfo()가 온로드 이벤트시 설정되는 부분입니다.) -->
<input type="hidden" name="good_info"       value=""/>
<!--
  ※ 필 수
      필수 항목 : Payplus Plugin에서 값을 설정하는 부분으로 반드시 포함되어야 합니다
      값을 설정하지 마십시오
-->
<input type="hidden" name="res_cd"          value=""/>
<input type="hidden" name="res_msg"         value=""/>
<input type="hidden" name="tno"             value=""/>
<input type="hidden" name="trace_no"        value=""/>
<input type="hidden" name="enc_info"        value=""/>
<input type="hidden" name="enc_data"        value=""/>
<input type="hidden" name="ret_pay_method"  value=""/>
<input type="hidden" name="tran_cd"         value=""/>
<input type="hidden" name="bank_name"       value=""/>
<input type="hidden" name="bank_issu"       value=""/>
<input type="hidden" name="use_pay_method"  value=""/>

<!--  현금영수증 관련 정보 : Payplus Plugin 에서 설정하는 정보입니다 -->
<input type="hidden" name="cash_tsdtime"    value=""/>
<input type="hidden" name="cash_yn"         value=""/>
<input type="hidden" name="cash_authno"     value=""/>
<input type="hidden" name="cash_tr_code"    value=""/>
<input type="hidden" name="cash_id_info"    value=""/>

<!-- 2012년 8월 18일 전자상거래법 개정 관련 설정 부분 -->
<!-- 제공 기간 설정 0:일회성 1:기간설정(ex 1:2012010120120131)  -->
<input type="hidden" name="good_expr" value="0">

<!-- 가맹점에서 관리하는 고객 아이디 설정을 해야 합니다.(필수 설정) -->
<input type="hidden" name="shop_user_id"    value="${user.session.loginId}"/>
<!-- 복지포인트 결제시 가맹점에 할당되어진 코드 값을 입력해야합니다.(필수 설정) -->
<input type="hidden" name="pt_memcorp_cd"   value=""/>
<div style="text-align:center">
<!-- KCP 결제 수단 선택 :&nbsp;&nbsp;
<select name="pay_method">
    <option value="100000000000">신용카드</option>
    <option value="010000000000">계좌이체</option>
    <option value="001000000000">가상계좌</option>
    <option value="000010000000">휴대폰</option>
</select>
<br/><br/> -->
</div>
<input type="hidden" name="ordr_idxx"   value="${ordNo}"/>
<input type="hidden" name="good_name"   value=""/>
<input type="hidden" name="good_mny"   value=""/>
<input type="hidden" name="buyr_name"   value=""/>
<input type="hidden" name="buyr_mail"   value=""/>
<input type="hidden" name="pay_method"   value=""/>
<!-- 사이트 로고 -->
<input type="hidden" name="site_logo"   value="" />
<!-- 현금영수증 -->
<input type="hidden" name="disp_tax_yn"     value="N"/>
<!--// KCP연동 -->