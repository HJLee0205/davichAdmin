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
    var dailyEventNo = '${site_info.eventNo}';
    var siteNm = '${site_info.siteNm}';
    var sns_add_info_Yn = '${sns_add_info_Yn}';
    var basketPageMovYn = '${site_info.basketPageMovYn}';
    var anlsId = '${anlsId}';//"UA-112178390-1"

    // 토큰수집
    function mobile_set_push_token(push_token) {
        //서버에 mobile에서 보낸 push_token을 회원별로 보관처리
        var url = "${_MOBILE_PATH}/front/member/app-info-collect";
        var os_type = "";

        if ((navigator.userAgent.indexOf("davich_android")) > 0) {
            os_type = "android";
        }

        if ((navigator.userAgent.indexOf("davich_ios")) > 0) {
            os_type = "ios";
        }

        var param = {appToken: push_token, osType: os_type};

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result.success) {
            }
        });
    }

    // 자동로그인
    function mobile_set_auto_login(flag) {
        var url = "${_MOBILE_PATH}/front/member/app-info-collect";
        var param = {autoLoginGb: flag};

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result.success) {
            }
        });
    }

    // 공지안내 알림여부
    function mobile_set_noti(flag) {
        var url = "${_MOBILE_PATH}/front/member/app-info-collect";
        var param = {notiGb: flag};

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result.success) {
            }
        });
    }

    // 혜택/이벤트 알림여부
    function mobile_set_event(flag) {
        var url = "${_MOBILE_PATH}/front/member/app-info-collect";
        var param = {eventGb: flag};

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result.success) {
            }
        });
    }

    // 신제품 뉴스 알림여부
    function mobile_set_news(flag) {
        var url = "${_MOBILE_PATH}/front/member/app-info-collect";
        var param = {newsGb: flag};

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result.success) {
            }
        });
    }

    // 위치정보 수집이용 동의여부
    function mobile_set_location(flag) {
        var url = "${_MOBILE_PATH}/front/member/app-info-collect";
        var param = {locaGb: flag};

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            if (result.success) {
            }
        });
    }

    // 비콘 알림발송
    function mobile_beacon_push(beaconId) {

        if (beaconId != undefined && beaconId != '') {

            var url = "${_MOBILE_PATH}/front/push/beacon-push";
            var memberNo = '${user.session.memberNo}';
            var param = {memberNo: memberNo, beaconId: beaconId};

            Dmall.AjaxUtil.getJSON(url, param, function (result) {
                if (result.success) {
                }
            });
        }
    }


    // 푸시 확인
    function mobile_push_confirm(push_no) {

        if (push_no != undefined && push_no != '') {

            if (push_no.startsWith("S")) {
                var url = "${_MOBILE_PATH}/front/push/store-push-check";
                var param = {pushNo: push_no};
            } else {
                var url = "${_MOBILE_PATH}/front/push/push-check";
                var param = {pushNo: push_no};
            }

            Dmall.AjaxUtil.getJSON(url, param, function (result) {

                if (result.success) {

                    var link = result.link;
                    if (link != '' && link != undefined) {
                        document.location.href = result.link;
                    }

// 	            	if (!loginYn) {
// 	                    var returnUrl = result.link;
// 	                    document.location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
// 	            	} else {
// 	            		document.location.href = result.link;	
// 	            	}
                }
            });
        }
    }

    // 페이지 이동
    function mobile_move_page(gbn, param) {
        if (gbn == '1') {
            document.location.href = "${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=" + param;
        } else if (gbn == '2') {
            document.location.href = "${_MOBILE_PATH}/front/event/event-ing-list?eventNo=" + param;
        } else if (gbn == '3') {
            document.location.href = "${_MOBILE_PATH}/front/promotion/promotion-detail?prmtNo=" + param;
        }
    }

    function mypage_link() {
        if (loginYn) {
            location.href = "${_MOBILE_PATH}/front/member/mypage";
        } else {
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function () {
                    location.href = "${_MOBILE_PATH}/front/login/member-login?returnUrl=${_MOBILE_PATH}/front/member/mypage"
                }, '');
        }
    }

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

    gtag('config', anlsId); // 사이트 설정용
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
   /* (function (w, d, a) {
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
