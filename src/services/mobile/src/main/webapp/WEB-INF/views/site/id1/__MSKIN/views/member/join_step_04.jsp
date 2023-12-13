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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">가입완료</t:putAttribute>

	<t:putAttribute name="script">
    <script>
        gtag('event', 'conversion', {'send_to': 'AW-774029432/CO_WCLHVwJEBEPiAi_EC'});
        gtag('event', 'conversion', {'send_to': 'AW-760445332/hVu-CMyYwpYBEJTzzeoC','value': 1.0,'currency': 'KRW'});
    </script>
    <%-- 텐션DA SCRIPT --%>
    <script>
        ex2cts.push('track', 'join');
    </script>
    <%--// 텐션DA SCRIPT --%>

    <%--Cauly CPA 광고--%>
   <%-- <script type="text/javascript" src="//image.cauly.co.kr/cpa/util_sha1.js" ></script>
    <script type="text/javascript">
      var strUser = '${po.memberCardNo}';
      window._paq = window._paq || [];
      _paq.push(['track_code',"a9a01f1f-8e03-4d4d-af16-1b95e46fe041"]);
      _paq.push(['user_id',SHA1(strUser)]); // option
      _paq.push(['event_name','CA_REGIST']);
      _paq.push(['send_event']);
      (function() { var u="//image.cauly.co.kr/script/"; var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'caulytracker_async.js'; s.parentNode.insertBefore(g,s); }
      )();
    </script>--%>
    <%-- // Cauly CPA 광고--%>
    <%-- 카카오 모먼트 --%>
    <script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
    <script type="text/javascript">
          kakaoPixel('59690711162928695').pageView();
          kakaoPixel('59690711162928695').completeRegistration();
          kakaoPixel('7385103066531646539').pageView();
          kakaoPixel('7385103066531646539').completeRegistration();
    </script>
    <%-- // 카카오 모먼트 --%>
    <!-- End of event snippet: Please do not remove -->
    <script src="${_SKIN_JS_PATH}/jquery-barcode.js" charset="utf-8"></script>
    <script>
		$(document).ready(function(){
		    //move login
		    $('.btn_go_login').on('click',function(){
		        location.href = '${_MOBILE_PATH}/front/login/member-login';
		    });
		    //move main
	        $('.btn_go_home').on('click', function(){
	            location.href = '${_MOBILE_PATH}/front/main-view';
	        });

            //    바코드 타입
            //    codabar
            //    code11 (code 11)
            //    code39 (code 39)
            //    code93 (code 93)
            //    code128 (code 128)
            //    ean8 (ean 8)
            //    ean13 (ean 13)
            //    std25 (standard 2 of 5 - industrial 2 of 5)
            //    int25 (interleaved 2 of 5)
            //    msi
            //    datamatrix (ASCII + extended)
            
            $("#bcTarget_reg").barcode("${po.memberCardNo}", "code128");


		});
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	 <%-- logCorpAScript --%>
     <%--시나리오(cart:카트,cartend:주소기입,payend:결제완료,REGC:회원가입 또는 약관동의,REGF:입력폼,REGO:회원완료)--%>
     <c:set var="http_SO" value="REGO" scope="request"/>
     <%--// logCorpAScript --%>
    <!--- contents --->
    <div id="member_container">
        <h3 class="member_sub_tit mgt-20">"다비치마켓 회원이 되신 것을<br>진심으로 환영합니다."</h3>
        <%--<div class="member_card">
            <p class="logo_card"><em>DAVICH</em> Membership Card</p>
            <p class="member_name"><em>${memberManagePO.memberNm}</em>님</p>
            <div class="qr_code">
                <div id="bcTarget" style="margin: 0 auto"></div>
                &lt;%&ndash;<img src="${_SKIN_IMG_PATH}/member/qr_code.gif" alt="">&ndash;%&gt;
            </div>
            <p class="id_no">NO.${fn:substring(po.memberCardNo,0,2)} - ${fn:substring(po.memberCardNo,2,5)}-${fn:substring(po.memberCardNo,5,9)}</p>
        </div>--%>
        <div class="card_area">
			<div class="member_card_name">DAVICH Membership</div>
            <div class="member_barcode">
				<div class="member_name"><em>${memberManagePO.memberNm}</em>님</div>
                <div id="bcTarget_reg" style="margin: 0 auto"></div>
                <p class="member_no">NO. ${fn:substring(po.memberCardNo,0,2)} - ${fn:substring(po.memberCardNo,2,5)} - ${fn:substring(po.memberCardNo,5,9)}</p>
            </div>
        </div>
        <ul class="membership_list">
            <li>
                <div class="box">
                    <div class="icon_area">
                        <i class="icon01"></i>
                        다비치멤버쉽
                    </div>
                    <div class="text_area">
                        포인트 적립(일반 5%, VIP 10%)<br>
                        - 행사 제품 일부품목 미적립(3년후 자동소멸)<br>
                        전국 어디에서나 적립 포인트 사용가능<br>
                        검사-구매정보 및 AS 가능<br>
                        Caffe & daon 1일 1회 무료이용(동반 1인까지)
                    </div>
                </div>
            </li>
            <li>
                <div class="box">
                    <div class="icon_area">
                        <i class="icon02"></i>
                        통합회원
                    </div>
                    <div class="text_area">
                        다비치 멤버쉽 혜택 + a<br>
                        온라인 구매(일부 품목에 한함), 픽업서비스, 간편 검사-방문 예약, 시력정보 확인, 내눈에 맞는 렌즈-콘택트-안경테 찾기<br>
                        가상 착장 서비스 이용
                    </div>
                </div>
            </li>
            <li>
                <div class="box">
                    <div class="icon_area">
                        <i class="icon03"></i>
                        온라인혜택
                    </div>
                    <div class="text_area">
                        온라인 구매후 다비치 DDS 서비스(다비치 다이렉트 배송 서비스)<br>
                        안경테 구매시 전국 다비치 매장에서 픽업-피팅-AS까지<br>
                        온라인 마켓포인트 적립 및 사용
                    </div>
                </div>
            </li>
            <li>
                <div class="box">
                    <div class="icon_area">
                        <i class="icon04"></i>
                        사업자회원
                    </div>
                    <div class="text_area">
                        1. “오프라인 대비 가격경쟁력, 상품구성 등과 간략한 증빙서류 절차<br>
                        2. 빠른 배송 등의 편의성 등이 저렴한 이용료를 통해 점주를 공략<br>
                        3. 사업자 전용 상품, 전용쿠폰<br>
                        4. 사업자 전용 포인트 적립율
                    </div>
                </div>
            </li>
        </ul>
        <div class="btn_member_area">
            <button type="button" class="btn_go_home">홈화면으로</button>
            <button type="button" class="btn_go_login">로그인하기</button>
        </div>
    </div>
    <!---// contents --->
	</t:putAttribute>
</t:insertDefinition>