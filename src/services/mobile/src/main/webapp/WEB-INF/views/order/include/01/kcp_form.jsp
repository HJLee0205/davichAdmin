<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
  function chk_pay()
  {
    self.name = "tar_opener";
    var pay_form = document.pay_form;

    if (pay_form.res_cd.value == "3001" )
    {
      alert("사용자가 취소하였습니다.");
      pay_form.res_cd.value = "";

    }
    else if (pay_form.res_cd.value == "3000" )
    {
      alert("30만원 이상 결제를 할 수 없습니다.");
      pay_form.res_cd.value = "";

    } 

    if (pay_form.enc_info.value)
      pay_form.submit();
  }
   
  $(document).ready(function(){
       	chk_pay();
  });


</script>
<form name="pay_form" method="post" action="${_MOBILE_PATH}/front/order/order-insert">
    <input type="hidden" name="req_tx"         value="${param.req_tx}">               <!-- 요청 구분          -->
    <input type="hidden" name="res_cd"         value="${param.res_cd}">               <!-- 결과 코드          -->
    <input type="hidden" name="tran_cd"        value="${param.tran_cd}">              <!-- 트랜잭션 코드      -->
    <input type="hidden" name="ordr_idxx"      value="${param.ordr_idxx}">            <!-- 주문번호           -->
    <input type="hidden" name="good_mny"       value="${param.good_mny}">             <!-- 휴대폰 결제금액    -->
    <input type="hidden" name="good_name"      value="${param.good_name}">            <!-- 상품명             -->
    <input type="hidden" name="buyr_name"      value="${param.buyr_name}">            <!-- 주문자명           -->
    <input type="hidden" name="buyr_tel1"      value="${param.buyr_tel1}">            <!-- 주문자 전화번호    -->
    <input type="hidden" name="buyr_tel2"      value="${param.buyr_tel2}">            <!-- 주문자 휴대폰번호  -->
    <input type="hidden" name="buyr_mail"      value="${param.buyr_mail}">            <!-- 주문자 E-mail      -->
    <input type="hidden" name="cash_yn"		   value="${param.cash_yn}">              <!-- 현금영수증 등록여부-->
    <input type="hidden" name="enc_info"       value="${param.enc_info}">
    <input type="hidden" name="enc_data"       value="${param.enc_data}">
    <input type="hidden" name="use_pay_method" value="${param.use_pay_method}">
    <input type="hidden" name="cash_tr_code"   value="${param.cash_tr_code}">
    <!-- 추가 파라미터 -->
    <input type="hidden" name="param_opt_1"	   value="${param.param_opt_1}">
    <input type="hidden" name="param_opt_2"	   value="${param.param_opt_2}">
    <input type="hidden" name="param_opt_3"	   value="${param.param_opt_3}">
</form>