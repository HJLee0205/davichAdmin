<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%
    Calendar cal = Calendar.getInstance();
    cal.setTime(new Date());
    cal.add(Calendar.DATE, 5);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    String date = sdf.format(cal.getTime());
%>
<script type="application/x-javascript">

    addEventListener("load", function()
    {
        setTimeout(updateLayout, 0);
    }, false);

    var currentWidth = 0;

    function updateLayout()
    {
        if (window.innerWidth != currentWidth)
        {
            currentWidth = window.innerWidth;

            var orient = currentWidth == 320 ? "profile" : "landscape";
            document.body.setAttribute("orient", orient);
            setTimeout(function()
            {
                window.scrollTo(0, 1);
            }, 100);
        }

    }

    setInterval(updateLayout, 400);

</script>

<script language=javascript>
    window.name = "BTPG_CLIENT";

    var width = 330;
    var height = 480;
    var xpos = (screen.width - width) / 2;
    var ypos = (screen.width - height) / 2;
    var position = "top=" + ypos + ",left=" + xpos;
    var features = position + ", width=320, height=440";
    var date = new Date();
    var date_str = "testoid_"+date.getFullYear()+""+date.getMinutes()+""+date.getSeconds();
    if( date_str.length != 16 )
    {
        for( i = date_str.length ; i < 16 ; i++ )
        {
            date_str = date_str+"0";
        }
    }

    function on_web()
    {
        var order_form = document.frmAGS_pay;
        var paymethod = order_form.paymethod.value;


        if (wallet == null)
        {
            if ((webbrowser.indexOf("Windows NT 5.1")!=-1) && (webbrowser.indexOf("SV1")!=-1))
            {    // Windows XP Service Pack 2
                alert("팝업이 차단되었습니다. 브라우저의 상단 노란색 [알림 표시줄]을 클릭하신 후 팝업창 허용을 선택하여 주세요.");
            }
            else
            {
                alert("팝업이 차단되었습니다.");
            }
            return false;
        }

        // 요청 전 캐릭터셋을 대상 서비스의 캐릭터셋으로 설정한다.
        $("#frmAGS_pay").attr("accept-charset","euc-kr");
        //승인데이터 캐릭터셋 설정
        $("#frmAGS_pay input[name=P_CHARSET]").val("utf8");
        order_form.target = "BTPG_WALLET";
        order_form.action = "https://mobile.inicis.com/smart/" + paymethod + "/";

        order_form.submit();

    }

    function on_app()
    {
        //alert('2');
        //	alert(	$("#frmAGS_pay input[name=P_RESERVED]").val());
        var order_form = document.frmAGS_pay;
        var paymethod = order_form.paymethod.value;


        // 요청 전 캐릭터셋을 대상 서비스의 캐릭터셋으로 설정한다.
        $("#frmAGS_pay").attr("accept-charset","euc-kr");
        //승인데이터 캐릭터셋 설정
        $("#frmAGS_pay input[name=P_CHARSET]").val("utf8");
        order_form.target = "BTPG_WALLET";
        order_form.action = "https://mobile.inicis.com/smart/" + paymethod + "/";

        order_form.submit();
    }


    function inisisSubmit()
    {
        checkChilde();
        var order_form = document.frmAGS_pay;
        var inipaymobile_type = order_form.inipaymobile_type.value;
        if(isAndroidWebview() || isIOSWebview()){
            //document.href = 'GET방식 결제URL';
            return on_app();
        }else{
            if( inipaymobile_type == "web" ) {
                return on_web();
            }
        }

    }
    //앱에서 호출
    function app_popup_close(){
            Dmall.waiting.stop();
            Dmall.waiting.payStop();
    }

    function checkChilde(){

        if(wallet.closed){
            Dmall.waiting.stop();
            Dmall.waiting.payStop();
        }else{
            setTimeout("checkChilde()",1);
        }
    }

</script>
<input type="hidden" name="inipaymobile_type" value="web"/>
<input type="hidden" name="paymethod" id="paymethod"/><!-- wcard:신용카드 ,bank:계좌이체 , vbank:가상계좌 ,mobile:휴대폰  -->
<input type="hidden" name="onlykakaopay" value="N" >

<!-- ************************************************** 전 지불수단 공통 필드 ************************************************** -->

<input type="hidden" name="P_MID" value="${foreignPaymentConfig.data.frgPaymentStoreId}">  <!-- 상점아이디 :계약된 당사발급 아이디 -->
<input type="hidden" name="P_OID" value="${ordNo}"/><!-- 주문번호 :한글을 제외한, 숫자/영문/특수기호의 형태 필수대상 : 가상계좌 -->
<input type="hidden" name="P_AMT" value=""/><!-- 거래금액 단위 표시 기호(콤마) 를 반드시 제거 요망 -->
<input type="hidden" name="P_UNAME" value=""/><!-- 고객성명 -->
<input type="hidden" name="P_MNAME" value="${site_info.siteNm}"/><!-- 가맹점 이름 -->

<!--
기타주문정보 :
이 값은 가맹점에서 이용하는 추가 정보
필드로 전달한 값이 그대로 반환됩니다. 결제처리 시, 꼭 필요한 내용만 사용하세요.
800byte를 초과하는 P_NOTI의 값은 차후 문제가 생길 여지가 있으니 반드시 800byte를 초과하지 않도록 설정해야 합니다.
-->
<input type="hidden" name="P_NOTI" value=""/><!-- 기타주문정보 -->
<input type="hidden" name="P_GOODS" value=""/><!-- 결제상품명 -->
<input type="hidden" name="P_MOBILE" /> <!-- 구매자 휴대폰번호 -->
<input type="hidden" name="P_EMAIL" value=""/><!-- 구매자 E-mail -->


<input type=hidden name="P_HPP_METHOD" value="1">
<!-- 인증결과수신 URL -->
<!-- <input type=hidden name="P_NEXT_URL" value="https://mobile.inicis.com/smart/testmall/next_url_test.php"> -->
<input type=hidden name="P_NEXT_URL" value="${siteDomain}/inicis-stdpay-return">

<!--
가맹점과 인증/승인과정을 거치지 않고 승인결과를 통보하는 용도로 사용합니다.
단, 가상계좌의 경우, 입금완료시각이 비동기식 이므로, 입금완료 통보를 위해 사용됩니다.
Method : post
Parameters : *INIpayMobile Receive GUIDE 참조
적용대상 : 계좌이체, 가상계좌, 삼성월렛, Kpay
이 Url 은 네트워크 사정에 따라 중복전송 될 수 있으니, 중복수신여부 체크루틴을 반드시 구현하시기 바랍니다.
-->
<!-- 승인결과 통보 URL -->

<!-- <input type=hidden name="P_NOTI_URL" value="https://mobile.inicis.com/rnoti/rnoti.php"> -->
<input type=hidden name="P_NOTI_URL" value="${siteDomain}/inicis-stdpay-notice">


<!--
승인결과통보 Url 을 사용하는 (비동기식으로 승인결과를 통보받는) 지불수단에서 사용되는 방식으로,
사용자가 이니페이 모바일TM 에서 모든 결제과정을 마친 후, 이동할 가맹점 Url 입니다. 이 Url 은 당사에서 변조없이 그대로 호출하여 드립니다.
Method : get
적용대상 : 계좌이체, 삼성월렛, Kpay
-->
<!-- 결제완료 URL -->
 <input type=hidden name="P_RETURN_URL" value="${siteDomain}/inicis-stdpay-return">

<!--
영수증에 표기할 부가세 금액
주 의 : 전체금액의 10%이하로 설정
대상 : ‘부가세업체정함’ 설정업체에 한함
-->
<input type=hidden name="P_TAX" value=""><!-- 부가세 -->

<!--
과세 되지 않는 금액
대상 : ‘부가세업체정함’ 설정업체에 한함
-->
<input type=hidden name="P_TAXFREE" value=""><!-- 비과세 -->


<!--
상품의 제공기간을 설정해야 하는 경우, 사용되는 옵션으로, 이니페이 모바일에 디스플레이 하는 용도로만 사용됩니다.
1) 상점에서 16자리 값 입력 시 (2013012920130229): 날짜 표시 Ex. 2013.01.29 ~ 2013.02.29
2) 상점에서 24자리 값 입력 시 (201301291130201302291230): 날짜시간표시 Ex. 2013.01.29 11:30 ~ 2013.02.29 12:30
3) 상점에서 M2 값 설정 시 (M2) : 월 자동결제
4) 상점에서 Y2 값 설정 시 (Y2): 연 자동결제
5) 1 ~ 4번의 조건을 만족하지 않으면 ( 글자길이가 맞지 않거나 문자를 삽입하는 경우 ) ‘별도 제공 기간 없음’ 으로 표기
-->
<input type=hidden name="P_OFFER_PERIOD" value=""><!-- 제공기간 -->


<!-- **************************************************  신용카드전용 **************************************************  -->
<!-- 설정 시, 해당 카드코드에 해당하는 카드가 선택된 채로 Display 됩니다. -->
<input type=hidden name="P_CARD_OPTION" value=""><!-- 신용카드 우선선택 옵션 -->

<!--
선택된 카드 리스트만 출력되며, 나머지 카드리스트는 출력되지 않습니다
적용 예시 : 롯데, 외환, BC 카드만 사용할 경우, 롯데카드코드 : 03, 외환카드코드 : 01, BC카드코드 : 11 이므로, 03:01:11 로 설정
-->
<input type=hidden name="P_CARD_OPTION" value=""><!-- 신용카드 노출제한 옵션 -->

<!--
50,000원 이상 결제 시, 할부기간 지정 (36개월 MAX)
Ex. 01:02:03:04.. 01은 일시불, 02는 2개월
-->
<input type=hidden name="P_QUOTABASE" value="${pgPaymentConfig.data.instPeriod}"><!-- 신용카드 할부기간 지정 -->

<!-- ************************************************** 휴대폰 전용 필드 ************************************************** -->
<!--
컨텐츠 일 경우 : 1
실물일 경우 : 2
컨텐츠/실물 여부는 계약담당자에게 확인요
-->
<input type=hidden name="P_HPP_METHOD" value="1"><!-- 실물여부 구분 -->


<!-- **************************************************  가상계좌 전용 필드 **************************************************  -->
<!--
설정을 하지 않으면,
요청일 + 10일로 자동설정 됩니다.
-->
<input type=hidden name="P_VBANK_DT" value="<%=date%>"><!-- 가상계좌 입금기한 날짜 -->

<!--
시분까지 설정 가능합니다. (4자리)
-->
<input type=hidden name="P_VBANK_TM" value="0000"><!-- 가상계좌 입금기한 시간 -->



<!--**************************************************  기타옵션 필드 **************************************************  -->
<!--
인증, 승인결과 CHARSET 정의
default는 euc-kr이며, 인증·승인 결과를 utf-8로 받기를 원하시면 해당 옵션 설정 값을 utf8로 하시면 됩니다.
-->
<input type=hidden name="P_CHARSET" value=""> <!-- 캐릭터셋 설정 -->

<input type=hidden name="P_RESERVED" value="">



<!-- 인증후 파라미터 세팅 -->
<input type=hidden id="P_STATUS" name="P_STATUS" value="">
<input type=hidden id="P_REQ_URL" name="P_REQ_URL" value="">
<input type=hidden id="P_TID" name="P_TID" value="">


