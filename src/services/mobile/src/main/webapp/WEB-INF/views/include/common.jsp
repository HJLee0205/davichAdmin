<%@ page import="dmall.framework.common.constants.RequestAttributeConstants" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<sec:authentication var="user" property='details'/>
<jsp:useBean id="today" class="java.util.Date" />
<fmt:formatDate value="${today}" pattern="yyyyMMddmmss" var="nowDate"/>

<sec:authentication var="user" property='details'/>

<!-- Google Tag Manager -->
<script>
    (function(w,d,s,l,i){
        w[l]=w[l]||[];
        w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js'});
        var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';
        j.async=true;
        j.src= 'https://www.googletagmanager.com/gtm.js?id='+i+dl;
        f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-K72KQL7');
</script>
<!-- End Google Tag Manager -->

<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-W5FD5C6');</script>
<!-- End Google Tag Manager -->

<!-- 모바일 context -->
<script type="text/javascript">
	var MOBILE_CONTEXT_PATH ="/m";
</script>
<!-- // 모바일 context -->
<link rel="stylesheet" type="text/css" href="${_SKIN_CSS_PATH}/custom.css?dt=${nowDate}" /> <!--- 개발 추가 css ---->
<link rel="stylesheet" type="text/css" href="${_SKIN_CSS_PATH}/skin.css?dt=${nowDate}" /> <!--- 스킨 css ---->
<!--[if lt IE 9]>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/html5shiv.js"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/html5shiv.printshiv.js"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/IE9.js"></script>
<![endif]-->
<!-- 모바일 -->
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/jquery-ui.1.11.4.js"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/jquery.bxslider-rahisified.min.js"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/jquery.ui.totop.js"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/menu.js" charset="utf-8"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/swiper.min.js" charset="utf-8"></script>
<!-- //모바일 -->

<!-- <script type="text/javascript" src="${_MOBILE_PATH}/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/lib/jquery/jquery-ui-1.11.4/jquery-ui.min.js"></script> -->
<script src="${_MOBILE_PATH}/front/js/lib/jquery/jquery.cookie.js" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/lib/jquery/jquery.mask.min.js" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/lib/jquery/jquery.form.min.js" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/lib/jquery/jquery.blockUI.js" charset="utf-8"></script>

<script src="${_MOBILE_PATH}/front/js/common.js?dt=${nowDate}" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/custom.js?dt=${nowDate}" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/layer.js?dt=${nowDate}" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/link.js?dt=${nowDate}" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/paging.js?dt=${nowDate}" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/cookie.js?dt=${nowDate}" charset="utf-8"></script>
<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/masonry.pkgd.min.js"></script><!-- 디매거진 -->

<!-- Jquery Validation Engine -->
<link type="text/css" rel="stylesheet" href="${_MOBILE_PATH}/front/js/lib/jquery/validation-Engine-2.6.2/css/validationEngine.jquery.css" />
<script src="${_MOBILE_PATH}/front/js/lib/jquery/validation-Engine-2.6.2/js/jquery.validationEngine.js" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/lib/jquery/validation-Engine-2.6.2/js/languages/jquery.validationEngine-ko.js" charset="utf-8"></script>
<script src="${_MOBILE_PATH}/front/js/lib/jquery.bxslider.min.js"></script>
<!-- Criteo 로더 파일 -->
<script type="text/javascript" src="//dynamic.criteo.com/js/ld/ld.js?a=89928" async="true"></script>
<!-- END Criteo 로더 파일 -->

<script type="text/javascript">
	var HTTP_SERVER_URL = '<%= request.getAttribute(RequestAttributeConstants.HTTP_SERVER_URL) %>',
            HTTPS_SERVER_URL = '<%= request.getAttribute(RequestAttributeConstants.HTTPS_SERVER_URL) %>',
            HTTPX_SERVER_URL = '<%= request.getAttribute(RequestAttributeConstants.HTTPX_SERVER_URL) %>';


    $(document).ready(function() {
        /*
         * 네이버 공통 유입 스크립트
         */
        var naverCmnCertKey = 's_1426268671b2'; // 네이버 공통 인증키 c3b693a7ac3c70
        var dlgtDomain = 'www.davichmarket.com'; // 대표도메인
        var tempDomain = 'davichmarket.com'; // 임시도메인

        if(naverCmnCertKey !== '') { // 공통 코드 데이터가 존재하면 무조건 적용
            if(!wcs_add) window.wcs_add = {};
            wcs_add["wa"] = 's_1426268671b2';

            // 프리미엄 로그(전환 페이지용 스크립트)
            var _nasa={};
            if (!_nasa) var _nasa={};
            if(location.pathname.match('order-payment-complete')) { //구매 완료
            if($('#naverPaymentAmt').val())
                _nasa["cnv"] = wcs.cnv("1", $('#naverPaymentAmt').val().replace('.00', ''));
            } else if(location.pathname.match('member-join-complete')) { //회원가입 완료
                _nasa["cnv"] = wcs.cnv("2", "0");
            } else if(location.pathname.match('basket-list')) { //장바구니 페이지
                _nasa["cnv"] = wcs.cnv("3", "0");
            } else if(location.pathname.match('visit-complete')) { //예약하기 완료
                _nasa["cnv"] = wcs.cnv("4", "0");
            }

            /*
             * 네이버페이 white list
             * white list는 원래 어드민 npay 설정에 존재하였으나 현재는 사용하지 않고
             * 가맹점내 최대 도메인 운용갯수는 2개이기 때문에 이곳에서 강제로 두가지 도메인을 설정한다.
             */
            wcs.checkoutWhitelist = [dlgtDomain,tempDomain]
            wcs.inflow(dlgtDomain);// 유입 추적 함수 호출
            wcs_do(_nasa);// 로그 수집 함수 호출

            // 애널리틱스 계정 추가
            wcs_add["wa"] = 'd6da2ffc1ff620';
            wcs_do();

        }
    });
</script>
<%--<script type="text/javascript">
  // Cauly CPA 광고
  window._paq = window._paq || [];
  _paq.push(['track_code',"a9a01f1f-8e03-4d4d-af16-1b95e46fe041"]);
  _paq.push(['event_name','OPEN']);
  _paq.push(['send_event']);
  (function(){
    var u="//image.cauly.co.kr/script/";
    var d=document,
        g=d.createElement('script'),
        s=d.getElementsByTagName('script')[0];

          g.type='text/javascript';
          g.async=true;
          g.defer=true;
          g.src=u+'caulytracker_async.js';
          s.parentNode.insertBefore(g,s);
      })();
</script>--%>


<!-- Enliple Common Tracker v3.5 [공용] start -->
<script type="text/javascript">
<!--
    function mobRf(){
        var rf = new EN();
		rf.setData("userid", "davich2");
        rf.setSSL(true);
        rf.sendRf();
    }
//-->
</script>
<script src="https://cdn.megadata.co.kr/js/en_script/3.5/enliple_min3.5.js" defer="defer" onload="mobRf()"></script>
<!-- Enliple Common Tracker v3.5 [공용] end -->

<!--  LOG corp Web Analitics & Live Chat  START -->
<script type="text/javascript">
//<![CDATA[
    /*custom parameters*/
    var _HCmz={
        CP:"${http_CP}", //캠페인ID
        PC:"${http_PC}", //상품명 (상품명에 언더바[_]가 포함되어서는안됩니다.)
        PT:"${http_PT}", //카테고리명(카테고리가 여러단계일 경우 ';'으로 구분 [예] AA;BB;CC)
        OZ:"${http_OZ}", //내부광고/배너분석
        SO:"${http_SO}", //시나리오(cart:카트,cartend:주소기입,payend:결제완료,REGC:회원가입 또는 약관동의,REGF:입력폼,REGO:회원완료)
        MP:"${http_MP}", //구매전환상품 (상품명_가격_제품수량) 여러개 경우 ';'로 구분 / 상품명에 언더바[_]가 포함되어서는 안됩니다.
        MA:"${http_MA}", //회원연령(예:39)
        MS:"${http_MS}", //회원성별(M 또는 W)
        IS:"${http_IS}", //내부검색어
        IC:"${http_IC}", //내부검색어성공여부(성공:Y,실패:N)
        ES:"${http_ES}", //에러Type
        MR:"${http_MR}", //회원지역(서울)
        PS:"${http_PS}", //상품가격(예:29000)
        PA:"${http_PA}", //장바구니(상품명_수량)  여러개 경우 ';'로 구분 (상품명1_수량;상품명2_수량)
        OD:"${http_OD}"  //주문서코드
    };
function logCorpAScript_full(){
	LOGSID = "<%=(session.getAttribute("logsid") != null ? session.getAttribute("logsid") : "")%>";/*logsid*/
	LOGREF = "<%=(session.getAttribute("logref") != null ? session.getAttribute("logref") : "")%>";/*logref*/
	HTTP_MSN_MEMBER_NAME="";/*member name*/
	var prtc=(document.location.protocol=="https:")?"https://":"http://";
	var hst=prtc+"asp36.http.or.kr";
	var rnd="r"+(new Date().getTime()*Math.random()*9);
	this.ch=function(){
		if(document.getElementsByTagName("head")[0]){logCorpAnalysis_full.dls();}else{window.setTimeout(logCorpAnalysis_full.ch,30)}
	}
	this.dls=function(){
		var h=document.getElementsByTagName("head")[0];
		var s=document.createElement("script");s.type="text/jav"+"ascript";try{s.defer=true;}catch(e){};try{s.async=true;}catch(e){};
		if(h){s.src=hst+"/HTTP_MSN/UsrConfig/davichmarket/js/ASP_Conf.js?s="+rnd;h.appendChild(s);}
	}

    this.init= function(){
                var img = document.createElement("img");
                img.style.cssText = "width:1px;height:1px;position:absolute;display:none";
                img.alt = "";
                img.src = hst+"/sr.gif?d="+rnd;
                img.onload = function(){
                    logCorpAnalysis_full.ch();
                };
                (document.documentElement || document.body).appendChild(img);
            }
    }
/*if(typeof logCorpAnalysis_full=="undefined"){var logCorpAnalysis_full=new logCorpAScript_full();logCorpAnalysis_full.init();}*/
</script>
<%--<noscript><img src="http://asp36.http.or.kr/HTTP_MSN/Messenger/Noscript.php?key=davichmarket" style="display:none;width:0;height:0;" alt="" /></noscript>--%>
<!-- LOG corp Web Analitics & Live Chat END  -->
<%-- 카카오 모먼트 --%>
<script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
<script type="text/javascript">
      kakaoPixel('59690711162928695').pageView();
      kakaoPixel('7385103066531646539').pageView();
</script>
<%-- // 카카오 모먼트 --%>

<%-- 텐션DA SCRIPT --%>
<script type='text/javascript'>
    !function (w,d,s,u,t,ss,fs) {
        if(w.ex2cts)return;t=w.ex2cts={};if(!window.t) window.t = t;
        t.push = function() {t.callFunc?t.callFunc.apply(t,arguments) : t.cmd.push(arguments);};
        t.cmd=[];ss = document.createElement(s);ss.async=!0;ss.src=u;
        fs=d.getElementsByTagName(s)[0];fs.parentNode.insertBefore(ss,fs);
    }(window,document,'script','//st2.exelbid.com/js/cts.js');
    ex2cts.push('init', '5e6f198af1c49a235e8b4567');
</script>
<%--// 텐션DA SCRIPT --%>

<!-- Criteo 홈페이지 태그 -->
<script type="text/javascript">
    (function() {
        let email = "${sessionScope.criteoEmail}";
        let zipcode = "${sessionScope.criteoZipcode}";

        window.criteo_q = window.criteo_q || [];

        //주문완료 페이지
        let isThankPage = /order-payment-complete/.test(window.location.href);
        let item = [];
        let transactionId = Math.floor(Math.random()*99999999999);
        if (isThankPage){
            <c:if test="${orderVO ne null && orderVO.orderGoodsVO ne null}">
            transactionId = ${orderVO.orderInfoVO.ordNo};
            <c:forEach var="goods" items="${orderVO.orderGoodsVO}" varStatus="status">
            item.push({id:"${goods.goodsNo}", price: ${goods.paymentAmt}, quantity: ${goods.ordQtt}});
            </c:forEach>
            </c:if>
        }

        let deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
        window.criteo_q.push({ event: "setAccount", account: 89928});
        window.criteo_q.push({ event: "setEmail", email: email });
        window.criteo_q.push({ event: "setZipcode", zipcode: zipcode });
        window.criteo_q.push({ event: "setSiteType", type: deviceType});
        if (isThankPage){
            window.criteo_q.push({ event: "trackTransaction", id: transactionId, item:item});
        }else{
            window.criteo_q.push({ event: "viewHome"});
        }
    })();
</script>
<!-- END Criteo 홈페이지 태그 -->

<!-- Global site tag (gtag.js) - Google Ads: 10907591142 -->
<script async src="https://www.googletagmanager.com/gtag/js?id=AW-10932091774"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'AW-10932091774');
</script>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-NBPFZY130L"></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-NBPFZY130L');
</script>

<!-- Global site tag (gtag.js) - Google Ads: 10924983490 -->
<script async src=https://www.googletagmanager.com/gtag/js?id=AW-10924983490></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'AW-10924983490');
</script>

<%
    // 상품상세페이지 만 노출
    String uri = request.getRequestURI();
    if(uri.matches(".+(goods_detail)[.]jsp")){
%>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-230712428-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'UA-230712428-1');
</script>
<!-- Meta Pixel Code -->
<script>
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script', 'https://connect.facebook.net/en_US/fbevents.js' [connect.facebook.net]);
fbq('init', '539572121108168');
fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none" src="https://www.facebook.com/tr?id=539572121108168&ev=PageView&noscript=1 [facebook.com]"/></noscript>
<!-- End Meta Pixel Code -->
<%}%>

<%if(uri.matches(".+(goods_detail|promotion_view)[.]jsp")){ // 상품상세페이지, 기획전에만 노출%>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-W5FD5C6"
                  height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<%}%>
