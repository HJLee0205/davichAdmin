<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-05-10
  Time: 오전 11:57
  To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<sec:authentication var="user" property='details'/>
<script>
    var Constant = {
        file: {
            maxSize: <spring:eval expression="@front['system.upload.file.size']"/>
        }
    }

    var loginYn = '${user.login}';
    var integration = '${user.session.integrationMemberGbCd}';
    var dailyEventNo = '${site_info.eventNo}';
    var siteNm = '${site_info.siteNm}';
    var sns_add_info_Yn = '${sns_add_info_Yn}';
    var basketPageMovYn = '${site_info.basketPageMovYn}';
    var anlsId = '${anlsId}';//"UA-128559357-1"
    var _IMAGE_DOMAIN = '${_IMAGE_DOMAIN}';


</script>

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=" +anlsId></script>
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-133188026-1"></script>
<script async src="https://www.googletagmanager.com/gtag/js?id=AW-774029432"></script>
<script async src="https://www.googletagmanager.com/gtag/js?id=AW-760445332"></script>
<script>
    window.dataLayer = window.dataLayer || [];

    function gtag() {
        dataLayer.push(arguments);
    }

    gtag('js', new Date());

    gtag('config', anlsId);
    gtag('config', ' UA-133188026-1');//구글광고 계정용 davichmarketah
    gtag('config', 'AW-774029432');
    gtag('config', 'AW-760445332');
</script>
<!-- adinsight 공통스크립트 start -->
<script type="text/javascript">
    /*var TRS_AIDX = 11477;
    var TRS_PROTOCOL = document.location.protocol;
    document.writeln();
    var TRS_URL = TRS_PROTOCOL + '//' + ((TRS_PROTOCOL == 'https:') ? 'analysis.adinsight.co.kr' : 'adlog.adinsight.co.kr') + '/emnet/trs_esc.js';
    document.writeln("<scr" + "ipt language='javascript' src='" + TRS_URL + "'></scr" + "ipt>");*/
</script>
<!-- adinsight 공통스크립트 end -->
<!-- Facebook Pixel Code -->
<script>
    !function (f, b, e, v, n, t, s) {
        if (f.fbq) return;
        n = f.fbq = function () {
            n.callMethod ?
                n.callMethod.apply(n, arguments) : n.queue.push(arguments)
        };
        if (!f._fbq) f._fbq = n;
        n.push = n;
        n.loaded = !0;
        n.version = '2.0';
        n.queue = [];
        t = b.createElement(e);
        t.async = !0;
        t.src = v;
        s = b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t, s)
    }(window, document, 'script',
        'https://connect.facebook.net/en_US/fbevents.js');
    fbq('init', '693906744367214');
    fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
               src="https://www.facebook.com/tr?id=693906744367214&ev=PageView&noscript=1"
/></noscript>
<script>
    !function (f, b, e, v, n, t, s) {
        if (f.fbq) return;
        n = f.fbq = function () {
            n.callMethod ?
                n.callMethod.apply(n, arguments) : n.queue.push(arguments)
        };
        if (!f._fbq) f._fbq = n;
        n.push = n;
        n.loaded = !0;
        n.version = '2.0';
        n.queue = [];
        t = b.createElement(e);
        t.async = !0;
        t.src = v;
        s = b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t, s)
    }(window, document, 'script',
        'https://connect.facebook.net/en_US/fbevents.js');
    fbq('init', '697623350663498');
    fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
               src="https://www.facebook.com/tr?id=697623350663498&ev=PageView&noscript=1"
/></noscript>
<!-- End Facebook Pixel Code -->
<!--
<script type="text/javascript">
    /*(function (w, d, a) {
        w.__beusablerumclient__ = {
            load: function (src) {
                var b = d.createElement("script");
                b.src = src;
                b.async = true;
                b.type = "text/javascript";
                d.getElementsByTagName("head")[0].appendChild(b);
            }
        };
        w.__beusablerumclient__.load(a);
    })(window, document, '//naverrum.beusable.net/script/b171222e160453u176/387ed48d94');*/
</script>

-->
<!-- Google Tag Manager 2021.07.21 -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-WZP57R7');</script>
<!-- End Google Tag Manager -->
