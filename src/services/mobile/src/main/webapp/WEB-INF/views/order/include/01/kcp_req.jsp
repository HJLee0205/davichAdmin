<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<!-- <link href="./css/style.css" rel="stylesheet" type="text/css" id="cssLink"/> -->
<script src="${_MOBILE_PATH}/front/js/approval_key.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
  var controlCss = "/m/css/style_mobile.css";
  var isMobile = {
    Android: function() {
      return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
      return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function() {
      return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function() {
      return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
      return navigator.userAgent.match(/IEMobile/i);
    },
    any: function() {
      return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
  };

  //if( isMobile.any() )
    //document.getElementById("cssLink").setAttribute("href", controlCss);
  
</script>
<script type="text/javascript">

    // jquery 확장
    jQuery.fn.serializeObject = function() {
        var obj = null;
        try {
            // this[0].tagName이 form tag일 경우
            if (this[0].tagName && this[0].tagName.toUpperCase() == "FORM") {
                var arr = this.serializeArray();
                if (arr) {
                    obj = {};
                    jQuery.each(arr, function() {
                        // obj의 key값은 arr의 name, obj의 value는 value값
                        obj[this.name] = this.value;
                    });
                }
            }
        } catch (e) {
            alert(e.message);
        } finally {
        }
        return obj;
    };

    /* kcp web 결제창 호츨 (변경불가) */
    function call_pay_form() {
        var v_frm = document.frmAGS_pay;
        // frmAGS_pay Form 의 값을 KCP 로 전달후 리턴받는다.
       try{
           //$("[name=param_opt_1]").val($("[name=itemArr]").val());
        $("[name=param_opt_1]").val(JSON.stringify($("#frmAGS_pay").serializeObject()));
	        if (v_frm.encoding_trans == undefined) {
	            v_frm.action = PayUrl;
	        } else {
	            if (v_frm.encoding_trans.value == "UTF-8") {
	                v_frm.action = PayUrl.substring(0, PayUrl.lastIndexOf("/"))+ "/jsp/encodingFilter/encodingFilter.jsp";
	                v_frm.PayUrl.value = PayUrl;
	            } else {
	                v_frm.action = PayUrl;
	            }
	        } // 인코딩 방식에 따른 변경 -- End
	        if (v_frm.Ret_URL.value == "") {
	            /* Ret_URL값은 현 페이지의 URL 입니다. */
	            alert("연동시 Ret_URL을 반드시 설정하셔야 됩니다.");
	            return false;
	        } else {
	           v_frm.submit();
	        }
		}catch(e){
		    alert(e);
		}
    }

    function jsf__chk_type() {
        if (document.frmAGS_pay.ActionResult.value == "card") {
            document.frmAGS_pay.pay_method.value = "CARD";
        } else if (document.frmAGS_pay.ActionResult.value == "acnt") {
            document.frmAGS_pay.pay_method.value = "BANK";
        } else if (document.frmAGS_pay.ActionResult.value == "vcnt") {
            document.frmAGS_pay.pay_method.value = "VCNT";
        } else if (document.frmAGS_pay.ActionResult.value == "mobx") {
            document.frmAGS_pay.pay_method.value = "MOBX";
        } else if (document.frmAGS_pay.ActionResult.value == "ocb") {
            document.frmAGS_pay.pay_method.value = "TPNT";
            document.frmAGS_pay.van_code.value = "SCSK";
        } else if (document.frmAGS_pay.ActionResult.value == "tpnt") {
            document.frmAGS_pay.pay_method.value = "TPNT";
            document.frmAGS_pay.van_code.value = "SCWB";
        } else if (document.frmAGS_pay.ActionResult.value == "scbl") {
            document.frmAGS_pay.pay_method.value = "GIFT";
            document.frmAGS_pay.van_code.value = "SCBL";
        } else if (document.frmAGS_pay.ActionResult.value == "sccl") {
            document.frmAGS_pay.pay_method.value = "GIFT";
            document.frmAGS_pay.van_code.value = "SCCL";
        } else if (document.frmAGS_pay.ActionResult.value == "schm") {
            document.frmAGS_pay.pay_method.value = "GIFT";
            document.frmAGS_pay.van_code.value = "SCHM";
        }
    }

    function createGoodsInfo() {
        var chr30 = String.fromCharCode(30); // ASCII 코드값 30
        var chr31 = String.fromCharCode(31); // ASCII 코드값 31
        var good_info = '';
        var len = $('[name=itemNo]').length;
        $('[name=itemNo]').each(
                function(i) {
                    var good_name = $('[name=goodsNm]').eq(i).val();
                    if (good_name.length > 30) {
                        good_name = goods_name.substring(0, 30);
                    }
                    var good_cntx = $('[name=ordQtt]').eq(i).val();
                    var good_amtx = $('[name=escwAmt]').eq(i).val();
                    good_info += 'seq=' + (i + 1) + chr31
                            + 'ordr_numb=${ordNo}' + chr31 + 'good_name='
                            + good_name + chr31 + 'good_cntx=' + good_cntx
                            + chr31 + 'good_amtx=' + good_amtx;
                    if (i != len - 1) {
                        good_info += chr30;
                    }
                })
        /* 
           var good_info = "seq=1" + chr31 + "ordr_numb=20060310_0001" + chr31 + "good_name=양말" + chr31 + "good_cntx=2" + chr31 + "good_amtx=2000" + chr30 +
	                       "seq=2" + chr31 + "ordr_numb=20060310_0002" + chr31 + "good_name=신발" + chr31 + "good_cntx=1" + chr31 + "good_amtx=1500" + chr30 +
	                       "seq=3" + chr31 + "ordr_numb=20060310_0003" + chr31 + "good_name=바지" + chr31 + "good_cntx=1" + chr31 + "good_amtx=1500";
        */

        document.frmAGS_pay.good_info.value = good_info;
        document.frmAGS_pay.bask_cntx.value = len;
    }
</script>

  <!-- 공통정보 -->
  <input type="hidden" name="req_tx"          value="${param.req_tx==null?'pay':param.req_tx}">                           <!-- 요청 구분 -->
  <!-- 사이트 이름 -->
  <input type="hidden" name="shop_name"       value="${site_info.siteNm}">
  <!-- <input type="hidden" name="shop_name"       value="KCP TEST SHOP"> -->
  <!-- 사이트 키 -->
  <input type="hidden" name="site_cd"         value="${pgPaymentConfig.data.pgId}">
  <input type="hidden" name="ordr_idxx"   value="${param.ordr_idxx==null?ordNo:param.ordr_idxx}"/>
  <input type="hidden" name="pay_method"      value="${param.pay_method==null?'':param.pay_method}">
  <input type="hidden" name="ActionResult" id="ActionResult" value="card"/> 
  <input type="hidden" name="good_name"   value="${param.good_name==null?'':param.good_name}"/>
  <!-- 결제등록 키 -->
  <input type="hidden" name="approval_key"    id="approval">
  <input type="hidden" name="van_code"        value="${param.van_code}">
  <!-- 리턴 URL (kcp와 통신후 결제를 요청할 수 있는 암호화 데이터를 전송 받을 가맹점의 주문페이지 URL) -->
    <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
    <c:set var="domain"><spring:eval expression="@system['system.domain']"/></c:set>
    <c:if test="${server eq 'local'}">
        <input type="hidden" name="Ret_URL"         value="http://id1.${domain}/m/front/order/order-form">
    </c:if>
    <c:if test="${server ne 'local'}">
        <input type="hidden" name="Ret_URL"         value="http://${domain}/m/front/order/order-form">
    </c:if>

    <!-- 추가 파라미터 ( 가맹점에서 별도의 값전달시 param_opt 를 사용하여 값 전달` ) -->
  <%-- <input type="hidden" name="param_opt_1"     value="${param_opt_1}"> --%>
  <input type="hidden" name="param_opt_1"     value='${param.param_opt_1}'>
  <input type="hidden" name="param_opt_2"     value="">
  <input type="hidden" name="param_opt_3"     value="">
  <input type="hidden" name="PayUrl" id="PayUrl"   value=""/>
  <input type="hidden" name="good_mny"    value="${param.good_mny==null?'':param.good_mny}"/>
  <input type="hidden" name="buyr_name"   value="${param.buyr_name==null?'':param.buyr_name}"/>
  <input type="hidden" name="buyr_mail"   value="${param.buyr_mail==null?'':param.buyr_mail}"/>
<%--     <input type="hidden" name="buyr_tel1"      value="${param.buyr_tel1}"> --%><!-- 주문자 전화번호    -->
<%--     <input type="hidden" name="buyr_tel2"      value="${param.buyr_tel2}"> --%>            <!-- 주문자 휴대폰번호  -->
  <input type="hidden" name="currency"        value="410"/>                          <!-- 통화 코드 -->
  <!-- 가맹점에서 관리하는 고객 아이디 설정을 해야 합니다.(필수 설정) -->
  <input type="hidden" name="shop_user_id"    value="${user.session.loginId}"/>
  <!-- <input type="hidden" name="shop_user_id"    value=""/> -->
  <!-- 신용카드 설정 -->
  <%-- <input type="hidden" name="quotaopt"        value="${pgPaymentConfig.data.instPeriod}"/> --%>                           <!-- 최대 할부개월수 -->
  <input type="hidden" name="quotaopt"        value="12"/>
  <input type="hidden" name="kcp_noint"       value="N"/>
  <input type="hidden" name="kcp_noint_quota" value=""/>  
  <input type="hidden" name='used_card'    value="">
  <!-- 가상계좌 설정 -->
  <input type="hidden" name="ipgm_date"       value=""/>
  <input type="hidden" name="used_bank"       value="">
  <!-- 현금영수증 설정 -->
  <input type="hidden" name="disp_tax_yn"     value="Y"/>
  <input type="hidden" name="eng_flag"        value="N"/>                            <!-- 한 / 영 -->
  <!-- 인증시 필요한 파라미터(변경불가)-->
  <input type="hidden" name="escw_used"       value="N">
  <!-- 복지포인트 결제시 가맹점에 할당되어진 코드 값을 입력해야합니다.(필수 설정) -->
  <input type="hidden" name="pt_memcorp_cd"   value=""/>
  <!-- 화면 크기조정 -->
  <input type="hidden" name="tablet_size"     value="1.0">
  <!-- 결제 정보 등록시 응답 타입 ( 필드가 없거나 값이 '' 일경우 TEXT, 값이 XML 또는 JSON 지원 -->
  <input type="hidden" name="response_type"  value="JSON"/>
  <input type="hidden" name="traceNo"  id="traceNo"  value=""/>
  <input type="hidden" name="encoding_trans" value="UTF-8">
<!--//  공통정보 -->

	<!-- 사이트 로고 -->
	<!-- <input type="hidden" name="site_logo"   value="" /> -->
	
	<!-- 에스크로 설정정보 -->
	<!-- 수취인명 -->
	<!-- <input type="hidden" name="rcvr_name" value=""> -->
	<!-- 수취인 전화번호 -->
	<!-- <input type="hidden" name="rcvr_tel1" value=""> -->
	<!-- 수취인 핸드폰번호 -->
	<!-- <input type="hidden" name="rcvr_tel2" value=""> -->
	<!-- 수취인 이메일 -->
	<!-- <input type="hidden" name="rcvr_mail" value=""> -->
	<!-- 수취인 우편번호 -->
	<!-- <input type="hidden" name="rcvr_zipx" value=""> -->
	<!-- 수취인 주소 -->
	<!-- <input type="hidden" name="rcvr_add1" value=""> -->
	<!-- 수취인 상세주소 -->
	<!-- <input type="hidden" name="rcvr_add2" value=""> -->
	
	<%-- <input type="hidden" name="site_name"       value="${site_info.siteNm}" /> --%>
	
	<!-- 배송 소요일 : 예상 배송 소요일을 입력 -->
	<input type="hidden"  name="deli_term" value="03"/>
	<!-- 장바구니 상품 개수 : 장바구니에 담겨있는 상품의 개수를 입력(good_info의 seq값 참조) -->
	<input type="hidden"  name="bask_cntx" value="0"/>
	<!-- 장바구니 상품 상세 정보 (자바 스크립트 샘플 create_goodInfo()가 온로드 이벤트시 설정되는 부분입니다.) -->
	<input type="hidden" name="good_info"       value=""/>
<%
    /* ============================================================================== */
    /* =   옵션 정보                                                                = */
    /* = -------------------------------------------------------------------------- = */
    /* =   ※ 옵션 - 결제에 필요한 추가 옵션 정보를 입력 및 설정합니다.             = */
    /* = -------------------------------------------------------------------------- = */
    /* 카드사 리스트 설정
    예) 비씨카드와 신한카드 사용 설정시
    <input type="hidden" name='used_card'    value="CCBC:CCLG">

    /*  무이자 옵션
            ※ 설정할부    (가맹점 관리자 페이지에 설정 된 무이자 설정을 따른다)                             - "" 로 설정
            ※ 일반할부    (KCP 이벤트 이외에 설정 된 모든 무이자 설정을 무시한다)                           - "N" 로 설정
            ※ 무이자 할부 (가맹점 관리자 페이지에 설정 된 무이자 이벤트 중 원하는 무이자 설정을 세팅한다)   - "Y" 로 설정
    <input type="hidden" name="kcp_noint"       value=""/> */

    /*  무이자 설정
            ※ 주의 1 : 할부는 결제금액이 50,000 원 이상일 경우에만 가능
            ※ 주의 2 : 무이자 설정값은 무이자 옵션이 Y일 경우에만 결제 창에 적용
            예) 전 카드 2,3,6개월 무이자(국민,비씨,엘지,삼성,신한,현대,롯데,외환) : ALL-02:03:04
            BC 2,3,6개월, 국민 3,6개월, 삼성 6,9개월 무이자 : CCBC-02:03:06,CCKM-03:06,CCSS-03:06:04
    <input type="hidden" name="kcp_noint_quota" value="CCBC-02:03:06,CCKM-03:06,CCSS-03:06:09"/> */

    /* KCP는 과세상품과 비과세상품을 동시에 판매하는 업체들의 결제관리에 대한 편의성을 제공해드리고자, 
       복합과세 전용 사이트코드를 지원해 드리며 총 금액에 대해 복합과세 처리가 가능하도록 제공하고 있습니다
       복합과세 전용 사이트 코드로 계약하신 가맹점에만 해당이 됩니다
       상품별이 아니라 금액으로 구분하여 요청하셔야 합니다
       총결제 금액은 과세금액 + 부과세 + 비과세금액의 합과 같아야 합니다. 
       (good_mny = comm_tax_mny + comm_vat_mny + comm_free_mny)

        <input type="hidden" name="tax_flag"       value="TG03">  <!-- 변경불가	   -->
        <input type="hidden" name="comm_tax_mny"   value=""    >  <!-- 과세금액	   --> 
        <input type="hidden" name="comm_vat_mny"   value=""    >  <!-- 부가세	   -->
        <input type="hidden" name="comm_free_mny"  value=""    >  <!-- 비과세 금액 --> */
    /* = -------------------------------------------------------------------------- = */
    /* =   옵션 정보 END                                                            = */
    /* ============================================================================== */
%>

<%!
    /* ============================================================================== */
    /* =   null 값을 처리하는 메소드                                                = */
    /* = -------------------------------------------------------------------------- = */
      public String f_get_parm( String val )
        {
        if ( val == null ) val = "";
            return  val;
        }
    /* ============================================================================== */
%>
<%
	/* request.setCharacterEncoding( "euc-kr" );

    // kcp와 통신후 kcp 서버에서 전송되는 결제 요청 정보 /
    String req_tx          = f_get_parm( request.getParameter( "req_tx"         ) ); // 요청 종류         
    String res_cd          = f_get_parm( request.getParameter( "res_cd"         ) ); // 응답 코드         
    String tran_cd         = f_get_parm( request.getParameter( "tran_cd"        ) ); // 트랜잭션 코드     
    String ordr_idxx       = f_get_parm( request.getParameter( "ordr_idxx"      ) ); // 쇼핑몰 주문번호   
    String good_name       = f_get_parm( request.getParameter( "good_name"      ) ); // 상품명            
    String good_mny        = f_get_parm( request.getParameter( "good_mny"       ) ); // 결제 총금액       
    String buyr_name       = f_get_parm( request.getParameter( "buyr_name"      ) ); // 주문자명          
    String buyr_tel1       = f_get_parm( request.getParameter( "buyr_tel1"      ) ); // 주문자 전화번호   
    String buyr_tel2       = f_get_parm( request.getParameter( "buyr_tel2"      ) ); // 주문자 핸드폰 번호
    String buyr_mail       = f_get_parm( request.getParameter( "buyr_mail"      ) ); // 주문자 E-mail 주소
    String use_pay_method  = f_get_parm( request.getParameter( "use_pay_method" ) ); // 결제 방법         
    String ipgm_date       = f_get_parm( request.getParameter( "ipgm_date"      ) ); // 가상계좌 마감시간 
	String enc_info        = f_get_parm( request.getParameter( "enc_info"       ) ); // 암호화 정보       
    String enc_data        = f_get_parm( request.getParameter( "enc_data"       ) ); // 암호화 데이터     
    String van_code        = f_get_parm( request.getParameter( "van_code"       ) );
    String cash_yn         = f_get_parm( request.getParameter( "cash_yn"        ) );
    String cash_tr_code    = f_get_parm( request.getParameter( "cash_tr_code"   ) );
    // 기타 파라메터 추가 부분 - Start - /
    String param_opt_1    = f_get_parm( request.getParameter( "param_opt_1"     ) ); // 기타 파라메터 추가 부분
    String param_opt_2    = f_get_parm( request.getParameter( "param_opt_2"     ) ); // 기타 파라메터 추가 부분
    String param_opt_3    = f_get_parm( request.getParameter( "param_opt_3"     ) ); // 기타 파라메터 추가 부분
    // 기타 파라메터 추가 부분 - End -   
 */
  String tablet_size     = "1.0"; // 화면 사이즈 고정
//  String url             = request.getRequestURL().toString();
%>

<script type="text/javascript">


   /* kcp 통신을 통해 받은 암호화 정보 체크 후 결제 요청 (변경불가) */
  function chk_pay(){
   try{
    self.name = "tar_opener";
    var pay_form = document.frmAGS_pay;

    if (pay_form.res_cd.value == "3001" ){
      alert("사용자가 취소하였습니다.");
      pay_form.res_cd.value = "";
    }else if (pay_form.res_cd.value == "3000" ){
      alert("30만원 이상 결제를 할 수 없습니다.");
      pay_form.res_cd.value = "";
    }

    if (pay_form.enc_info.value){

      var param_opt_1 = $("[name=param_opt_1]").val();

      var jsonParam =  JSON.parse(param_opt_1);
      //리턴받은 param_opt_1을 form에 세팅한다.
      Dmall.FormUtil.jsonToForm(jsonParam, 'frmAGS_pay');
      
      //필수값 세팅
	    $('[name=req_tx]').val('${param.req_tx}');  
	    $('[name=res_cd]').val('${param.res_cd}'); 
	    $('[name=tran_cd]').val('${param.tran_cd}'); 
	    $('[name=cash_yn]').val('${param.cash_yn}');  
	    $('[name=enc_info]').val('${param.enc_info}');
	    $('[name=enc_data]').val('${param.enc_data}');
	    $('[name=use_pay_method]').val('${param.use_pay_method}');
	    $('[name=cash_tr_code]').val('${param.cash_tr_code}');
	    $('[name=van_code]').val('${param.van_code}');
	    $('[name=ordr_idxx]').val('${param.ordr_idxx}');
		$('[name=good_name]').val('${param.good_name}');
		$('[name=good_mny]').val('${param.good_mny}');
		$('[name=buyr_name]').val('${param.buyr_name}');
		$('[name=buyr_mail]').val('${param.buyr_mail}');

      pay_form.ordNo.value=pay_form.ordr_idxx.value;
      pay_form.action="${_MOBILE_PATH}/front/order/order-insert";
      pay_form.submit();
    }  
       }catch(e){

           alert(e);
       }
  }


   $(document).ready(function(){
       chk_pay();
   });

</script>
<%--     <input type="hidden" name="req_tx"         value="${param.req_tx}"> --%>               <!-- 요청 구분          -->
    <input type="hidden" name="res_cd"         value="${param.res_cd}">               <!-- 결과 코드          -->
    <input type="hidden" name="tran_cd"        value="${param.tran_cd}">              <!-- 트랜잭션 코드      -->
<%--     <input type="hidden" name="ordr_idxx"      value="${param.ordr_idxx}"> --%>            <!-- 주문번호           -->
    <%-- <input type="hidden" name="good_mny"       value="${param.good_mny}">  --%>            <!-- 휴대폰 결제금액    -->
<%--     <input type="hidden" name="good_name"      value="${param.good_name}"> --%>            <!-- 상품명             -->
<%--     <input type="hidden" name="buyr_name"      value="${param.buyr_name}"> --%>            <!-- 주문자명           -->
<%--     <input type="hidden" name="buyr_mail"      value="${param.buyr_mail}"> --%>            <!-- 주문자 E-mail      -->
    <input type="hidden" name="cash_yn"		   value="${param.cash_yn}">              <!-- 현금영수증 등록여부-->
    <input type="hidden" name="enc_info"       value="${param.enc_info}">
    <input type="hidden" name="enc_data"       value="${param.enc_data}">
    <input type="hidden" name="use_pay_method" value="${param.use_pay_method}">
    <input type="hidden" name="cash_tr_code"   value="${param.cash_tr_code}">
    <input type="hidden" name="cash_id_info"   value="${param.cash_id_info}">
    
    
    <!-- 추가 파라미터 -->
