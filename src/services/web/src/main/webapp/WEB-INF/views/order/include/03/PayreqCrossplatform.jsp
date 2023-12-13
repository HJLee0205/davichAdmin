<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="//xpay.uplus.co.kr/xpay/js/xpay_crossplatform.js" charset="utf-8"></script>
<script type="text/javascript">
/*
* 수정불가
*/
function launchCrossPlatform(){
    //alert('PG 테스트계정으로 결제를 진행합니다.(실제로 결제가 되지는 않습니다.');
    if($('#LGD_CUSTOM_FIRSTPAY').val() == "SC0010") {
        $('.LGD_SC0010').prop('disabled',false);
        $('.LGD_SC0034').prop('disabled',true);
        $('.LGD_SC0040').prop('disabled',true);
        $('.LGD_SC0090').prop('disabled',true);
    } else if($('#LGD_CUSTOM_FIRSTPAY').val() == "SC0030") {
        $('.LGD_SC0010').prop('disabled',true);
        $('.LGD_SC0034').prop('disabled',false);
        $('.LGD_SC0040').prop('disabled',true);
        $('.LGD_SC0090').prop('disabled',true);
    } else if($('#LGD_CUSTOM_FIRSTPAY').val() == "SC0040") {
        $('.LGD_SC0010').prop('disabled',true);
        $('.LGD_SC0034').prop('disabled',false);
        $('.LGD_SC0040').prop('disabled',false);
        $('.LGD_SC0090').prop('disabled',true);
    } else if($('#LGD_CUSTOM_FIRSTPAY').val() == "SC0090") {
        $('.LGD_SC0010').prop('disabled',true);
        $('.LGD_SC0034').prop('disabled',true);
        $('.LGD_SC0040').prop('disabled',true);
        $('.LGD_SC0090').prop('disabled',false);
    }
    lgdwin = openXpay(document.getElementById("frmAGS_pay"), document.getElementById('CST_PLATFORM').value, document.getElementById('LGD_WINDOW_TYPE').value, null, "", "");
}
/*
* FORM 명만  수정 가능
*/
function getFormObject() {
        return document.getElementById("frmAGS_pay");
}

/*
 * 인증결과 처리
 */
function payment_return() {
    var fDoc;
    fDoc = lgdwin.contentWindow || lgdwin.contentDocument;

    if (fDoc.document.getElementById('LGD_RESPCODE').value == "0000") {

            document.getElementById("LGD_PAYKEY").value = fDoc.document.getElementById('LGD_PAYKEY').value;
            document.getElementById("frmAGS_pay").target = "_self";
            document.getElementById("frmAGS_pay").action = "/front/order/order-insert";
            document.getElementById("frmAGS_pay").submit();
    } else {
        alert("결제실패 코드=" + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "결제실패 메시지=" + fDoc.document.getElementById('LGD_RESPMSG').value);
        closeIframe();
    }
}

</script>
<div id="LGD_PAYREQFORM" style="display:none;">
<br />
<!-- #01-certReq.인증요청 - 화면처리용  -->
결제하기버튼                        <input type="button" value="결제하기" onclick="javascript:launchCrossPlatform();" /><br />
##화면처리용 기본값 ==========================================================================================<br />
CST_PLATFORM                        <input type="text" class="LGD_COMMON" name="CST_PLATFORM" id="CST_PLATFORM" value="test" />서비스,테스트<br />
<%-- CST_MID                             <input type="text" class="LGD_COMMON" name="CST_MID" id="CST_MID" value="${pgPaymentConfig.data.pgId}" /><!-- 상점아이디(t를 제외한 아이디)  --><br /> --%>
LGD_WINDOW_TYPE                     <input type="text" class="LGD_COMMON" name="LGD_WINDOW_TYPE" id="LGD_WINDOW_TYPE" value="iframe" /><!-- 결제창 호출 방식  --><br />
LGD_CUSTOM_SWITCHINGTYPE            <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_SWITCHINGTYPE" id="LGD_CUSTOM_SWITCHINGTYPE" value="IFRAME" /><!-- 신용카드 카드사 인증 페이지 연동 방식 --><br />
LGD_VERSION                         <input type="text" class="LGD_COMMON" name="LGD_VERSION" id="LGD_VERSION"  /><!-- LGU+버전  --><br />

<!-- #01-certReq.인증요청 -->
##공통  ==========================================================================================<br />
LGD_MID                             <input type="text" class="LGD_COMMON" name="LGD_MID" id="LGD_MID" value="${pgPaymentConfig.data.pgId}" /><!-- LG유플러스에서 부여한 상점ID --><br />
LGD_OID                             <input type="text" class="LGD_COMMON" name="LGD_OID" id="LGD_OID" value="${ordNo}" /><!-- 주문번호상점ID별로 유일한 값을(유니크하게) 상점에서 생성☞영문,숫자, -, _ 만 사용가능(한글금지), 최대 63자 --><br />
LGD_AMOUNT                          <input type="text" class="LGD_COMMON" name="LGD_AMOUNT" id="LGD_AMOUNT"  /><!-- 결제금액","가 없는 형태 (예 : 23400) --><br />
LGD_BUYER                           <input type="text" class="LGD_COMMON" name="LGD_BUYER" id="LGD_BUYER"  /><!-- 구매자명 --><br />
LGD_PRODUCTINFO                     <input type="text" class="LGD_COMMON" name="LGD_PRODUCTINFO" id="LGD_PRODUCTINFO"  /><!-- 구매내역 --><br />
LGD_TIMESTAMP                       <input type="text" class="LGD_COMMON" name="LGD_TIMESTAMP" id="LGD_TIMESTAMP"  /><!-- 타임스탬프(현재시간을 넘겨주세요)거래 위변조를 막기위해 사용숫자형식으로만 전달해 주세요 예)20090226110637 --><br />
LGD_HASHDATA                        <input type="text" class="LGD_COMMON" name="LGD_HASHDATA" id="LGD_HASHDATA"  /><!-- 해쉬데이타거래 위변조를 막기 위한 파라미터 입니다.☞샘플페이지 참조(자동생성) --><br />
LGD_BUYERID                         <input type="text" class="LGD_COMMON" name="LGD_BUYERID" id="LGD_BUYERID"  /><!-- 구매자아이디(상품권 결제시 필수) --><br />
LGD_BUYERIP                         <input type="text" class="LGD_COMMON" name="LGD_BUYERIP" id="LGD_BUYERIP"  /><!-- 구매자IP(상품권 결제시 필수) --><br />
LGD_RETURNURL                       <input type="text" class="LGD_COMMON" name="LGD_RETURNURL" id="LGD_RETURNURL"  /><!-- 인증요청 결과를 받을 URL --><br />

LGD_BUYERADDRESS                    <input type="text" class="LGD_COMMON" name="LGD_BUYERADDRESS" id="LGD_BUYERADDRESS"  /><!-- 구매자주소 --><br />
LGD_BUYERPHONE                      <input type="text" class="LGD_COMMON" name="LGD_BUYERPHONE" id="LGD_BUYERPHONE"  /><!-- 구매자휴대폰번호 --><br />
LGD_BUYEREMAIL                      <input type="text" class="LGD_COMMON" name="LGD_BUYEREMAIL" id="LGD_BUYEREMAIL"  /><!-- 구매자이메일(결제성공시 해당 이메일로 결제내역 전송) --><br />
<!-- LGD_BUYERSSN                   <input type="text" class="LGD_COMMON" name="LGD_BUYERSSN" id="LGD_BUYERSSN"  />구매자주민번호<br /> -->
<!-- LGD_CHECKSSNYN                 <input type="text" class="LGD_COMMON" name="LGD_CHECKSSNYN" id="LGD_CHECKSSNYN"  />구매자주민번호 체크여부(기본값 : N)<br /> -->
LGD_PRODUCTCODE                     <input type="text" class="LGD_COMMON" name="LGD_PRODUCTCODE" id="LGD_PRODUCTCODE"  /><!-- 상품코드 --><br />
LGD_RECEIVER                        <input type="text" class="LGD_COMMON" name="LGD_RECEIVER" id="LGD_RECEIVER"  /><!-- 수취인 --><br />
LGD_RECEIVERPHONE                   <input type="text" class="LGD_COMMON" name="LGD_RECEIVERPHONE" id="LGD_RECEIVERPHONE"  /><!-- 수취인전화번호 --><br />
LGD_DELIVERYINFO                    <input type="text" class="LGD_COMMON" name="LGD_DELIVERYINFO" id="LGD_DELIVERYINFO"  /><!-- 배송정보 --><br />
LGD_CUSTOM_FIRSTPAY                 <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_FIRSTPAY" id="LGD_CUSTOM_FIRSTPAY"  /><!-- 상점정의초기결제수단(기본값 : SC0010) --><br />
LGD_CUSTOM_PROCESSTYPE              <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_PROCESSTYPE" id="LGD_CUSTOM_PROCESSTYPE" value="TWOTR" /><!-- 상점정의프로세스타입(기본값 : TWOTR) --><br />
<!-- LGD_CUSTOM_SESSIONTIMEOUT      <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_SESSIONTIMEOUT" id="LGD_CUSTOM_SESSIONTIMEOUT"  />상점정의승인가능타임(기본값 : 10분)<br /> -->
LGD_CUSTOM_USABLEPAY                <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_USABLEPAY" id="LGD_CUSTOM_USABLEPAY"  /><!-- 상점정의결제가능수단특정결제수단만 보이게 할 경우 사용예)신용카드,계좌이체만 사용할 경우SC0010-SC0030  --><br />
LGD_CUSTOM_SKIN                     <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_SKIN" id="LGD_CUSTOM_SKIN" value="red" /><!-- 상점정의스킨 (red, purple, yellow)(기본값 : red) --><br />
LGD_WINDOW_VER                      <input type="text" class="LGD_COMMON" name="LGD_WINDOW_VER" id="LGD_WINDOW_VER" value="2.5" /><!-- 2.5 (리뉴얼버젼, 2013/11) --><br />
<!-- LGD_CUSTOM_CEONAME             <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_CEONAME" id="LGD_CUSTOM_CEONAME"  />상점정의대표자명<br /> -->
<!-- LGD_CUSTOM_MERTNAME            <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_MERTNAME" id="LGD_CUSTOM_MERTNAME"  />상점정의 상점명<br /> -->
<!-- LGD_CUSTOM_MERTPHONE           <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_MERTPHONE" id="LGD_CUSTOM_MERTPHONE"  />상점정의 상점전화번호<br /> -->
<!-- LGD_CUSTOM_BUSINESSNUM         <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_BUSINESSNUM" id="LGD_CUSTOM_BUSINESSNUM"  />상점정의 사업자번호<br /> -->
<!-- LGD_CUSTOM_LOGO                <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_LOGO" id="LGD_CUSTOM_LOGO"  />상점정의 로고높이21pix * (폭은 결제창 사이즈에 맞게 정의)☞상점정의 로고 이미지URL을 넘겨주세요.<br /> -->
<!-- LGD_CUSTOM_CARDPOINTUSEYN      <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_CARDPOINTUSEYN" id="LGD_CUSTOM_CARDPOINTUSEYN"  />상점정의 신용카드 포인트 사용여부포인트가맹점이 무조건 포인트를 사용하게 할때 'Y'(기본값 : N)<br /> -->
<!-- LGD_TAXFREEAMOUNT              <input type="text" class="LGD_COMMON" name="LGD_TAXFREEAMOUNT" id="LGD_TAXFREEAMOUNT"  />결제금액(amount)중 면세금액*기본적으로 amount의 1/11을vat(부가가치세)로 국세청에 신고합니다.<br /> -->
<!-- LGD_CLOSEDATE                  <input type="text" class="LGD_COMMON" name="LGD_CLOSEDATE" id="LGD_CLOSEDATE"  />상점정의 결제마감시간형식 , 무통장마감시간 : yyyyMMddHHmmss<br /> -->
LGD_ESCROW_USEYN                    <input type="text" class="LGD_COMMON" name="LGD_ESCROW_USEYN" id="LGD_ESCROW_USEYN"  /><!-- 에스크로 적용 여부Y :에스크로 적용, N : 에스크로 미적용 --><br />
LGD_ENCODING                        <input type="text" class="LGD_COMMON" name="LGD_ENCODING" id="LGD_ENCODING"  /><!-- 결제창 호출문자 인코딩방식 (기본값: EUC-KR)☞UTF-8사용시, 최종 결제결과처리 인코딩 방식을 mall.conf 에서 설정함 --><br />
LGD_ENCODING_NOTEURL                <input type="text" class="LGD_COMMON" name="LGD_ENCODING_NOTEURL" id="LGD_ENCODING_NOTEURL"  /><!-- 결제창 NOTEURL 인코딩방식 (기본값: EUC-KR)☞UTF-8사용시, 최종 결제결과처리 인코딩 방식을 mall.conf 에서 설정함 --><br />
LGD_ENCODING_RETURNURL              <input type="text" class="LGD_COMMON" name="LGD_ENCODING_RETURNURL" id="LGD_ENCODING_RETURNURL"  /><!-- 결제창 RETURNURL 인코딩방식 (기본값: EUC-KR)☞UTF-8사용시, 최종 결제결과처리 인코딩 방식을 mall.conf 에서 설정함 --><br />
LGD_CUSTOM_ROLLBACK                 <input type="text" class="LGD_COMMON" name="LGD_CUSTOM_ROLLBACK" id="LGD_CUSTOM_ROLLBACK"  /><!-- 비동기 ISP/계좌이체 결제 후, 결제성공결과 DB 처리오류시 자동취소 여부 (디폴트: “N”)☞ 비동기 결제시에만 적용되는 옵션 --><br />
##신용카드 =======================================================================<br />
<!-- LGD_INSTALLRANGE                    <input type="text" class="LGD_SC0010" name="LGD_INSTALLRANGE" id="LGD_INSTALLRANGE" />표시할부개월수 구분자는 반드시 ‘:’ 으로 해야함(기본값 : 0:2:3:4:5:6:7:8:9:10:11:12)<br /> -->
<!-- LGD_NOINTINF                        <input type="text" class="LGD_SC0010" name="LGD_NOINTINF" id="LGD_NOINTINF" />특정카드/특정개월무이자 셋팅카드-개월수 : 개월수, 카드-개월수 형식으로 전달예) 국민 3,6개월, 삼성 3-6개월 무이자 적용시,11-3:6,51-3:4:5:6<br /> -->
<!-- LGD_USABLECARD                 <input type="text" class="LGD_SC0010" name="LGD_USABLECARD" id="LGD_USABLECARD" />사용가능카드사<br /> -->
LGD_KVPMISPAUTOAPPYN                <input type="text" class="LGD_SC0010" name="LGD_KVPMISPAUTOAPPYN" id="LGD_KVPMISPAUTOAPPYN" /><!-- ISP결제 처리방식 (동기/비동기)Y: ISP비동기처리, A: ISP 동기처리,N: ISP동기 결제처리(iOS Web-to-Web경우)☞ 첨부의 “연동스펙_결제창2.0.xls 참조 --><br />
LGD_KVPMISPWAPURL                   <input type="text" class="LGD_SC0010" name="LGD_KVPMISPWAPURL" id="LGD_KVPMISPWAPURL" /><!-- ISP승인완료 화면처리 URL* ISP비동기방식 사용시, 승인 완료후 사용자에게 보여지는 결제성공 화면페이지 URL *승인성공시에만 호출되는 URL로, 결제 요청시 GET방식으로 넘겨주는 파라미터가 그대로 전달됨. DB처리후 결과값(LGD_KVPMISPNOTEURL)을 확인하여 결제성공 화면 처리필요. ISP 동기방식 사용시에도 파라미터는 전달되어야 함☞ ISP 동기방식 사용시에도 파라미터는 전달 필수 --><br />
LGD_KVPMISPCANCELURL                <input type="text" class="LGD_SC0010" name="LGD_KVPMISPCANCELURL" id="LGD_KVPMISPCANCELURL" /><!-- ISP결제취소 결과화면 URL* ISP비동기방식 사용시, 결제중 ISP 앱에서 취소시에 사용자에게 보여지는 취소페이지 URL☞ ISP 동기방식 사용시에도 파라미터는 전달 필수 --><br />
LGD_KVPMISPNOTEURL                  <input type="text" class="LGD_SC0010" name="LGD_KVPMISPNOTEURL" id="LGD_KVPMISPNOTEURL" /><!-- ISP승인결과 처리 URL* ISP비동기방식 사용시, 승인결과를 받는 DB처리 페이지 URL☞ ISP 비동기 결제시에만 필수 --><br />
##계좌이체 ================================================================<br />
LGD_CASHRECEIPTYN                   <input type="text" class="LGD_SC0034" name="LGD_CASHRECEIPTYN" id="LGD_CASHRECEIPTYN" /><!-- 현금영수증 사용 여부Y :현금영수증 사용함N :현금영수증 사용안함(기본값 : Y) --><br />
<!-- LGD_USABLEBANK                 <input type="text" class="LGD_SC0034" name="LGD_USABLEBANK" id="LGD_USABLEBANK" />사용가능 은행(실시간계좌이체)<br /> -->
LGD_ACTIVEXYN                       <input type="text" class="LGD_SC0034" name="LGD_ACTIVEXYN" id="LGD_ACTIVEXYN"  value='N' /><!-- ActiveX 사용 여부 N: NonActiveX 사용(반드시 “N”으로 값을 넘길 것) 아니면 ActiveX설치됨 --><br /> 
LGD_MTRANSFERAUTOAPPYN              <input type="text" class="LGD_SC0034" name="LGD_MTRANSFERAUTOAPPYN" id="LGD_MTRANSFERAUTOAPPYN" /><!-- 계좌이체 결제 처리방식 (동기/비동기)Y:계좌이체 비동기 처리, A: 계좌이체 동기처리, N: 계좌이체 동기처리(iOS Web-to-Web경우)☞ 첨부의 “연동스펙_결제창2.0.xls 참조 --><br />
LGD_MTRANSFERWAPURL                 <input type="text" class="LGD_SC0034" name="LGD_MTRANSFERWAPURL" id="LGD_MTRANSFERWAPURL" /><!-- 계좌이체 승인완료 화면처리 URL*계좌이체 비동기방식 사용시, 승인완료후 사용자에게 보여지는 결제성공 화면페이지 URL * 승인성공시에만 호출되는 URL로, 결제요청시 GET방식으로 넘겨주는 파라미터가 그대로 전달됨. DB처리후 결과값(LGD_MTRANSFERNOTEURL)을 확인하여 결제성공 화면 처리함☞ 계좌이체 동기 사용시에도 파라미터는 전달 필수 --><br />
LGD_MTRANSFERCANCELURL              <input type="text" class="LGD_SC0034" name="LGD_MTRANSFERCANCELURL" id="LGD_MTRANSFERCANCELURL" /><!-- 계좌이체 결제실패(오류) 결과화면 URL*계좌이체 비동기방식 사용시, 계좌이체중 결제timeout 또는 비정상오류로 인해 결제실패시 사용자에게 보여지는 취소페이지 URL☞ 계좌이체 동기 사용시에도 파라미터는 전달 필수 --><br />
LGD_MTRANSFERNOTEURL                <input type="text" class="LGD_SC0034" name="LGD_MTRANSFERNOTEURL" id="LGD_MTRANSFERNOTEURL" /><!-- 계좌이체 승인결과 DB처리 URL*계좌이체 비동기방식 사용시, 승인결과를 받는 DB처리 페이지 URL☞ 계좌이체 비동기 결제시에만 필수 --><br />
##가상계좌 ================================================================<br />
<!--  LGD_CASHRECEIPTYN             <input type="text" class="LGD_SC0040" name="LGD_CASHRECEIPTYN" id="LGD_CASHRECEIPTYN" />  -->
LGD_CASNOTEURL                      <input type="text" class="LGD_SC0040" name="LGD_CASNOTEURL" id="LGD_CASNOTEURL" />무통장 수신결과페이지☞입금하실 계좌번호 발급 및 입금 통보를 받아 DB연동을 할 페이지<br />
<!--  LGD_USABLECASBANK             <input type="text" class="LGD_SC0040" name="LGD_USABLECASBANK" id="LGD_USABLECASBANK" />사용가능 은행(가상계좌)<br /> -->
<!--  LGD_CLOSEDATE                 <input type="text" class="LGD_SC0040" name="LGD_CLOSEDATE" id="LGD_CLOSEDATE" />  -->
LGD_CASASSIGNNOTIYN                 <input type="text" class="LGD_SC0040" name="LGD_CASASSIGNNOTIYN" id="LGD_CASASSIGNNOTIYN" value="N" /><!-- 가상계좌할당결과 수신여부=>  N: 가상계좌할당결과를 가상계좌수신페이지(CAS_NOTEURL) 에서 수신받고 싶지않을 때     -->
##OK캐쉬백 ================================================================<br />
<!-- LGD_OCBITEMCODE                <input type="text" class="LGD_SC0090" name="LGD_OCBITEMCODE" id="LGD_OCBITEMCODE" />다날에서 제공한 대표아이템코드(LG유플러스로 문의 바랍니다)<br /> -->

<!-- #01-certRes.인증요청결과 -->
##인증요청결과===================================================================<br />
LGD_RESPCODE                        <input type="text" name="LGD_RESPCODE" id="LGD_RESPCODE"  /><!-- 응답코드, '0000' 이면 성공 이외는 실패 --><br />
LGD_RESPMSG                         <input type="text" name="LGD_RESPMSG" id="LGD_RESPMSG"  /><!-- 응답메세지 --><br />
LGD_PAYKEY                          <input type="text" name="LGD_PAYKEY" id="LGD_PAYKEY"  /><!-- LG유플러스 인증KEY --><br />

<!--  이전 기본 파라메터 
<input type="text" name="CST_PLATFORM" id="CST_PLATFORM" value="test" />
<input type="text" name="CST_MID" id="CST_MID" value="${pgPaymentConfig.data.pgId}" />
<input type="text" name="LGD_MID" id="LGD_MID"  />
<input type="text" name="LGD_WINDOW_TYPE" id="LGD_WINDOW_TYPE" value="iframe" />
<input type="text" name="LGD_CUSTOM_SWITCHINGTYPE" id="LGD_CUSTOM_SWITCHINGTYPE" value="IFRAME" />
<input type="text" name="LGD_CUSTOM_SKIN" id="LGD_CUSTOM_SKIN"  />
<input type="text" name="LGD_CUSTOM_PROCESSTYPE" id="LGD_CUSTOM_PROCESSTYPE"  />
<input type="text" name="LGD_VERSION" id="LGD_VERSION"  />
<input type="text" name="LGD_WINDOW_VER" id="LGD_WINDOW_VER"  />
<input type="text" name="LGD_CUSTOM_USABLEPAY" id="LGD_CUSTOM_USABLEPAY" value="SC0010" />
<input type="text" name="LGD_BUYER" id="LGD_BUYER"  />
<input type="text" name="LGD_PRODUCTINFO" id="LGD_PRODUCTINFO" value="myLG070-인터넷전화기" />
<input type="text" name="LGD_AMOUNT" id="LGD_AMOUNT"  />
<input type="text" name="LGD_BUYEREMAIL" id="LGD_BUYEREMAIL"  />
<input type="text" name="LGD_OID" id="LGD_OID" value="${ordNo}" />
<input type="text" name="LGD_TIMESTAMP" id="LGD_TIMESTAMP"  />
<input type="text" name="LGD_HASHDATA" id="LGD_HASHDATA"  />
<input type="text" name="LGD_RETURNURL" id="LGD_RETURNURL"  />
<input type="text" name="LGD_CASNOTEURL" id="LGD_CASNOTEURL"  />
<input type="text" name="LGD_RESPCODE" id="LGD_RESPCODE"  />
<input type="text" name="LGD_RESPMSG" id="LGD_RESPMSG"  />
<input type="text" name="LGD_PAYKEY" id="LGD_PAYKEY"  />
<input type="button" value="결제하기" onclick="javascript:launchCrossPlatform();" />
 -->
 </div>