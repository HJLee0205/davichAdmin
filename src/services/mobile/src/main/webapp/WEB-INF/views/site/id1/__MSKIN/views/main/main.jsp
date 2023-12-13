<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <sec:authentication var="user" property='details'/>

    <t:putAttribute name="content">

        <%@ include file="main_visual.jsp" %>
		<c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
        <script>
        $(function(){
        	<c:if test="${server ne 'local'}">
        	var url = "${_MOBILE_PATH}/front/totalsearch/api/rankings";
        	var tempSplit;
        	Dmall.AjaxUtil.getJSON(url, "", function(result) {
        		var rankings = "";
        		var rankingsRight = "";
        		var tempRankings = JSON.stringify(result.data.rankings);
        		var eachRankings = tempRankings.split('],[');

        		for(var i = 0; i < eachRankings.length; i++){
        			eachRankings[i] = eachRankings[i].replace(/\]/g, "");
        			eachRankings[i] = eachRankings[i].replace(/\[/g, "");
        			eachRankings[i] = eachRankings[i].replace(/\"/g, '');
        			tempSplit = eachRankings[i].split(',');

        			if(i >= 5){
		       			for(var i = 5; i < eachRankings.length; i++){
		           			eachRankings[i] = eachRankings[i].replace(/\]/g, "");
		           			eachRankings[i] = eachRankings[i].replace(/\[/g, "");
		           			eachRankings[i] = eachRankings[i].replace(/\"/g, '');
		           			tempSplit = eachRankings[i].split(',');

	          				rankingsRight += '<li><a href="#"><em>'+ (i+1) +'</em><span>'+ tempSplit[0] +'</span>'
	          				if(tempSplit[1].charAt(0) == '-' && tempSplit[1].length >= 2){
	          					rankingsRight += '<i class="hot_down">하락</i></a></li>'
	          				}else if(tempSplit[1] == '-'){
	          					rankingsRight += '<i class="hot_same">동률</i></a></li>'
	          				}else{
	          					rankingsRight += '<i class="hot_up">상승</i></a></li>'
	          				}
		           		}
        			}else if(i == 0 || i == 1 || i == 2){
        				rankings += '<li><a href="#"><em class = "top">'+ (i+1) +'</em><span>'+ tempSplit[0] +'</span>'
        				if(tempSplit[1].charAt(0) == '-' && tempSplit[1].length >= 2){
        					rankings += '<i class="hot_down">하락</i></a></li>'
        				}else if(tempSplit[1] == '-'){
        					rankings += '<i class="hot_same">동률</i></a></li>'
        				}else{
        					rankings += '<i class="hot_up">상승</i></a></li>'
        				}
        			}else{
        				rankings += '<li><a href="#"><em>'+ (i+1) +'</em><span>'+ tempSplit[0] +'</span>'
        				if(tempSplit[1].charAt(0) == '-' && tempSplit[1].length >= 2){
        					rankings += '<i class="hot_down">하락</i></a></li>'
        				}else if(tempSplit[1] == '-'){
        					rankings += '<i class="hot_same">동률</i></a></li>'
        				}else{
        					rankings += '<i class="hot_up">상승</i></a></li>'
        				}
        			}
        		}
        		$(".hot_word_view ul").eq(0).append(rankings);
        		$(".hot_word_view ul").eq(1).append(rankingsRight);

        		var hotWord = eachRankings[0].split(',');

        		$(".hot_text").html("<em>0</em>" + hotWord[0]);
        		$(".hot_text em").html(1);

        		var i = 0;

        		setInterval(function() {
        			i++;
        			hotWord = eachRankings[i].split(',');

        			$(".hot_text").html("<em>" + (i+1) + "</em>" + hotWord[0]);

        			if(i >= (eachRankings.length - 1)){
        				i = -1;
        			}
        		}, 5000);
        	});
			</c:if>
        });

		$(document).on("click",".hot_word_view > ul > li",function(){
	    	Dmall.FormUtil.submit('/front/totalsearch/main?searchType=1&searchWord='+$(this).find('span').text());
	    });


        </script>

		<div class="promo_divice"></div>

        <!--- main content area --->
		<div id="middle_area">
			<!-- 퀵메뉴 영역 -->
			<ul class="main_quick_menu">
				<li>
					<a href="/front/vision2/vision-check">
						<i class="icon_qm01"></i>
						<p>내 눈에 딱!<br>안경&middot;렌즈 추천</p>
					</a>
				</li>
				<li>
					<a href="/front/customer/store-list">
						<i class="icon_qm02"></i>
						<p>매장찾기</p>  <!-- 20200220 -->
					</a>
				</li>
				<%--<li>
					<a href="/front/visit/visit-welcome">
						<i class="icon_qm03"></i>
						<p>방문예약</p>  <!-- 20200220 -->
					</a>
				</li>--%>
				<li>
					<a href="/front/search/category?ctgNo=747">
						<i class="icon_qm04"></i>
						<p>D 매거진</p>  <!-- 20200220 -->
					</a>
				</li>
				<%--<li>
					<a href="/front/search/category?ctgNo=426">
						<i class="icon_qm02"></i>
						<p>바로픽업!</p>
					</a>
				</li>
				<li>
					<a href="/front/search/category?ctgNo=762">
						<i class="icon_qm03"></i>
						<p>아이웨어</p>
					</a>
				</li>
				<li>
					<a href="/front/search/category?ctgNo=4">
						<i class="icon_qm04"></i>
						<p>콘택트렌즈</p>
					</a>
				</li>
				<li>
					<a href="/front/search/category?ctgNo=171">
						<i class="icon_qm05"></i>
						<p>뷰티&middot;메이크업</p>
					</a>
				</li>
				<li>
					<a href="/front/search/category?ctgNo=170">
						<i class="icon_qm06"></i>
						<p>건강&middot;헬스케어</p>
					</a>
				</li>
				<li>
					<a href="/front/search/category?ctgNo=169">
						<i class="icon_qm07"></i>
						<p>리빙&middot;인테리어</p>
					</a>
				</li>
				<li>
					<a href="javascript:alert('이벤트 오픈 전입니다.');">
						<i class="icon_qm08"></i>
						<p>출석이벤트!</p>
					</a>
				</li>--%>
				<%-- <li>
					<a href="javascript:window.open('${_MOBILE_PATH}/front/event/imoticon-event', '이모티콘 이벤트', 'titlebar=1, resizable=1, scrollbars=yes, width=700, height=500');">
						<i class="icon_qm08"></i>
						<p>이모티콘 이벤트!</b></p>
					</a>
				</li> --%>
				<!-- <li>
					<a href="javascript:fn_imoticon_event();">
						<i class="icon_qm08"></i>
						<p>이모티콘 이벤트!</b></p>
					</a>
				</li> -->
			</ul>
			<!--// 퀵메뉴 영역 -->
			<c:if test="${fn:length(mo_main_banner_top.resultList)>0}">
			<!-- 배너영역 -->
			<div class="mid_banner_area">
				<c:forEach var="resultModel" items="${mo_main_banner_top.resultList}" varStatus="status">
				<a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}"></a>
				</c:forEach>
			</div>
			<!--// 배너영역 -->
			</c:if>

			<div class="promo_divice"></div>

			<!-- 인기 검색어 -->
			<div class="hot_word">
				<span class="hot_lb">인기검색어</span>
				<!-- <span class="hot_text"><em>2</em>성유리 선그라스</span> -->
				<span class="hot_text"></span>
				<i class="arrow_hot"></i>
			</div>
			<div class="hot_word_view">
				<h1 class="hot_tit">
					실시간 인기 검색어
					<button type="button" class="btn_close_hot">닫기</button>
				</h1>
				<ul class="hot_list">
					<!-- <li><a href="#"><em class="top">1</em><span>동글이안경</span><i class="hot_up">상승</i></a></li>
					<li><a href="#"><em class="top">2</em><span>성유리선글라스</span><i class="hot_same">동율</i></a></li>
					<li><a href="#"><em class="top">3</em><span>온수매트</span><i class="hot_down">하락</i></a></li>
					<li><a href="#"><em>4</em><span>컬러원데이</span><i class="hot_up">상승</i></a></li>
					<li><a href="#"><em>5</em><span>곤약떡볶이</span><i class="hot_down">하락</i></a></li> -->
				</ul>
				<ul class="hot_list right">
					<!-- <li><a href="#"><em>6</em><span>동글이안경</span><i class="hot_up">상승</i></a></li>
					<li><a href="#"><em>7</em><span>동글이안경</span><i class="hot_same">동율</i></a></li>
					<li><a href="#"><em>8</em><span>동글이안경</span><i class="hot_down">하락</i></a></li>
					<li><a href="#"><em>9</em><span>동글이안경</span><i class="hot_up">상승</i></a></li>
					<li><a href="#"><em>10</em><span>동글이안경</span><i class="hot_up">상승</i></a></li> -->
				</ul>
				<div style="clear:both"></div>
			</div>
			<!--// 인기 검색어 -->

			<!-- 기획전 영역 -->
			<c:set value="01" var="prmtMainExpsPst"/> <!-- 기획전 메인노출 상단 -->
			<%@ include file="main_promotion_list.jsp" %>
 			<!-- //기획전 영역 -->

			<!-- D매거진 배너 20190308
			<div class="dzine_banner_area">
				<a href="#"><img src="${_SKIN_IMG_PATH}/main/d_banner_640_171.gif" alt="나도 난시 일까! 난시 자가 진단 테스트"></a>
			</div>
			D매거진 배너 -->

			<!-- 이벤트 배너영역 (에디터(컨텐츠)영역. 개발 중 이미지 노출로 대체) -->
			<ul class="event_banner_area">
				<c:forEach var="resultModel" items="${mo_main_banner_big.resultList}" varStatus="status">
				<li><a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
				<c:if test="${status.index eq 0}">
						<img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}">
                </c:if>
                <c:if test="${status.index ne 0}">
                <img class="lazy" data-original="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}">
                </c:if>
				</a></li>
				</c:forEach>
			</ul>
			<!--// 이벤트 배너영역 -->

			<h2 class="main_tit">Best of Best</h2>
			<div class="main_mid_tab">
			<ul class="hot_menu_list BB_list">
				<c:forEach var="mainAreaTypeA" items="${mainAreaTypeA}" varStatus="status">
					<li>
						<a href="#" data-slide-index="${status.index}" <c:if test="${status.index==0}"> class="active" </c:if>>
							<%--<i class="icon_hm01"></i>--%>
							<p>${mainAreaTypeA.dispNm}</p>
						</a>
					</li>
				</c:forEach>
			</ul>
			</div>
			<!-- 다비치마켓 인기상품 -->
		    <!-- slider -->
			<div class="BB_slider_area">
	         <div class="BB_slider">
	         <c:forEach var="mainAreaTypeA" items="${mainAreaTypeA}" varStatus="status">
		         <div class="BL_right">
		            <c:set var="mainAreaTypeAList" value="mainAreaTypeA${status.index}" />
			      	<c:set var="list" value="${requestScope.get(mainAreaTypeAList)}" />
			        <%--<ul class="hot_item_list">--%>
					<data:goodsList value="${list}" displayTypeCd="05" headYn="N" iconYn="N" />
		         	<%--</ul>--%>
		         </div>
	      	 </c:forEach>
	         </div>
			</div>
	       <!--// slider -->
		   <!--//다비치마켓 인기상품 -->

			<!-- 기획전 영역 -->
			<c:set value="02" var="prmtMainExpsPst"/> <!-- 기획전 메인노출 하단 -->
			<%@ include file="main_promotion_list.jsp" %>
 			<!-- //기획전 영역 -->
			<!-- D.매거진 영역 -->
 			<%@ include file="main_magazine_list.jsp" %>
 			<!-- //D.매거진 영역 -->

			<c:forEach var="mainAreaTypeB" items="${mainAreaTypeB}" varStatus="status">
				<div class="BL_right">
					<c:set var="mainAreaTypeBList" value="mainAreaTypeB${status.index}" />
					<c:set var="list" value="${requestScope.get(mainAreaTypeBList)}" />
	            	<%--<ul class="hot_item_list"> --%>
	            	<data:goodsList value="${list}" displayTypeCd="05" headYn="Y" iconYn="N" mobileMainYn="Y"/>
	            	<%--</ul>--%>
				</div>
			</c:forEach>

			<c:forEach var="mainAreaTypeC" items="${mainAreaTypeC}" varStatus="status">
				<div class="BL_right">
					<c:set var="mainAreaTypeCList" value="mainAreaTypeC${status.index}" />
					<c:set var="list" value="${requestScope.get(mainAreaTypeCList)}" />
	            	<%--<ul class="hot_item_list"> --%>
	            	<data:goodsList value="${list}" displayTypeCd="05" headYn="Y" iconYn="N" mobileMainYn="Y"/>
	            	<%--</ul>--%>
				</div>
			</c:forEach>

			<c:if test="${fn:length(mo_main_banner_bottom.resultList)>0}">
			<!-- 배너영역 -->
			<div class="btm_banner_area">
				<ul>
				<c:forEach var="resultModel" items="${mo_main_banner_bottom.resultList}" varStatus="status">
					<li><a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}"></a></li>
				</c:forEach>
				</ul>
				<div class="btm_banner_controls">
					<a href="#none" class="btn_btm_prev"><i></i></a>
					<a href="#none" class="btn_btm_next"><i></i></a>
				</div>
			</div>
			<!--// 배너영역 -->
			</c:if>

			<%-- <h2 class="main_tit">포토리뷰</h2>
			<div class="photo_review_area">
				<ul class="photo_review_list">
				<c:forEach var="reviewListModel" items="${reviewListModel.resultList}" varStatus="status">
					<li>
						<a href="javascript:goods_detail('${reviewListModel.goodsNo}');">
							<img class="lazy" data-original="${_IMAGE_DOMAIN}/image/image-view?type=BBS&path=${reviewListModel.imgFilePath}&id1=${reviewListModel.imgFileNm}" alt="" onerror="this.src='${_SKIN_IMG_PATH}/product_list/product_300_300.gif'">
								<img class="lazy" data-original="${reviewListModel.goodsDispImgA}" alt="" onerror="this.src='${_SKIN_IMG_PATH}/product_list/product_300_300.gif'">
							<p class="name">[${reviewListModel.brandNm}] ${reviewListModel.goodsNm}</p>
							<p class="review">${reviewListModel.title}</p>
							<p class="stars">
							<c:forEach begin="1" end="${reviewListModel.score}" >
								<img class="lazy" data-original="${_SKIN_IMG_PATH}/main/star_blue.png" alt="">
							</c:forEach>
							<c:forEach begin="1" end="${5-reviewListModel.score}" >
								<img class="lazy" data-original="${_SKIN_IMG_PATH}/main/star_gray.png" alt="">
							</c:forEach>
							</p>
						</a>
					</li>
				</c:forEach>
				</ul>

			</div> --%>
<!-- 			<div class="more_btn_area line">
				<button type="button" class="btn_view_more">인기리뷰 더보기 +</button>
			</div> -->
		</div>
		<%--<div id="middle_area">
			<!-- 추천상품 -->
			<!-- 인기상품 -->
			<!-- 판매베스트 -->

			<!--
				퍼블에는 추천상품(이미지보기),인기상품(이미지보기),판매베스트(리스트형)으로 되어있으나 웹버전에서 전시타입 설정을
				최대 5개까지 주어서 관리자가 개별의 타입마다 큰이미지형,이미지형,갤러리형,슬라이드형,리스트형으로 보여질 수 있게끔 되어있음
				관리자는 이 5개의 상품진열타입의 사용유무를 설정할 수 있어서 사용으로 설정된 데이터만 화면에 뿌려지게 되어있어 그대로 작업함.
			-->
			<data:goodsList value="${displayGoods1}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			<data:goodsList value="${displayGoods2}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			<data:goodsList value="${displayGoods3}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			<data:goodsList value="${displayGoods4}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>
			<data:goodsList value="${displayGoods5}" headYn="Y" iconYn="Y" mainPagingYn="Y"/>

		</div>--%>
		<!---// main content area --->
		<!---// 04.LAYOUT: MAIN CONTENTS --->

        <input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "MM" />
		<%@ include file="/WEB-INF/views/include/popupLayer.jsp" %>

		<!--- popup push --->
		<div class="popup_outline" id="popupPushAgree" style="display:none;">
			<div class="inner push">
				<div class="popup_head">
					<h1><em>쇼핑 혜택 정보</em>를<br>놓치고 계시나요?</h1>
					<p class="info_text">APP PUSH 알림에 수신 동의하세요</p>
				</div>
				<div class="btn_push_area">
					<button type="button" class="btn_nexttime" id="btnPushClose">다음에요</button>
					<button type="button" class="btn_push" id="btnPushAgree">알림 받을게요</button>
				</div>
				<div class="popup_body">
					<ul class="push_good">
						<li><i class="icon01"></i>할인, 쿠폰 정보 실시간 알림</li>
						<li><i class="icon02"></i>궁금증 해결 건강매거진 알림</li>
						<li><i class="icon03"></i>다양한 이벤트 소식</li>
					</ul>
					<p class="push_setting">푸쉬 알림 변경은 메뉴 > 설정에서 변경 가능합니다.</p>
					<div class="push_text_box">
						<div class="top_area">
							광고성 정보(PUSH)수신동의
							<label class="switch">
							  <input type="checkbox" id="btnAgreeSwich" checked>
							  <span class="slider round"></span>
							</label>
						</div>
						본  설정은 해당 기기에서만 유효하며, 수신에 동의하시면 쿠폰, 할인 상품정보 및 건강매거진 소식도 받으실 수 있습니다.
					</div>
					<c:if test="${appInfo.forcePushAgreeYn !='Y'}">
					<input type="checkbox" id="cookie_check" class="check_cookie" checked>
					<label for="cookie_check"><span></span>14일 동안 그만 보기</label>
					</c:if>
				</div>

			</div>
		</div>
		<!---// popup push --->

		<!--- popup push agree --->
		<div class="popup_outline" id="popupPushAgreeSucc" style="display:none;">
			<div class="inner push_agree">
				<div class="popup_head">
					<h1>광고성 정보(PUSH)수신동의</h1>
				</div>
				<div class="popup_body">
					<p class="push_agree_time"></p>
					<div class="push_agree_text">
						다비치마켓 광고성 정보(PUSH)알림<br>
						수신에 동의하였습니다.
						<p>[알림 설정 변경 : 메뉴 > 설정 알림허용]</p>
					</div>
				</div>
				<div class="btn_push_area">
					<button type="button" class="btn_push_agree" id="btnPushSuccClose">확인</button>
				</div>
			</div>
		</div>
		<!---// popup push agree --->

		<!-- 예약바로가기 20200706 -->
		<c:if test="${user.login}">
		<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-book" class="btn_go_reservation">
		</c:if>
		<c:if test="${!user.login}">
		<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-welcome" class="btn_go_reservation">
		</c:if>
		${storeTotCnt}개 매장예약
		</a>

		<!--// 예약바로가기 20200706 -->

		<div class="popup_outline" id="popupAuth" style="display:none ;">

			<div class="inner push">
				<%--<div class="popup_head">
					<h1><em>APP 접근 권한 안내</em></h1>
				</div>--%>
				<div class="popup_body">
					<%--<p class="push_setting" style="margin: 10px 5px 8px 12px;">서비스에 필요한 접근권한에 대해 안내 드립니다.</p>
					<ul class="push_good">
						&lt;%&ndash;<li>① 필수적 접근 권한
							<div class="push_text_box" style="color: #000;line-height: 16px;font-size: 14px;font-weight: 100;">
							   * 기기 및 앱 기록 <br>  - 앱 실행시 구동 오류확인, 사용성 개선
							</div>
						</li>&ndash;%&gt;
						<li style="padding: 6px 10px 6px 4%;">선택적 접근 권한
							<div class="push_text_box" style="color: #000;line-height: 16px;font-size: 14px;font-weight: 100;">
							   해당 기능을 이용할 때 동의를 받고 있으며, 동의를 하지 않아도 서비스의 이용이 가능합니다.<br><br>
                                <p style="font-weight: bold;">* 위치</p>
							    <p style="font-size: 13px;">  - 내 주변 매장찾기 , 쿠폰/혜택알림시 사용</p>
							    <p style="font-weight: bold;">* 카메라</p>
							    <p style="font-size: 13px;">- 사진/동영상 촬영 기능을 제공</p>
                                <p style="font-weight: bold;">* 저장공간</p>
                                <p style="font-size: 13px;">- 앱이 사진, 동영상, 파일을 전송하거나 저장하기 위해 사용</p>
							</div>
						</li>
					</ul>--%>
					<img src="${_MOBILE_PATH}/front/img/common/app_popup.jpg" alt="댓글 아이콘">
					<div class="btn_push_area">
						<input type="checkbox" id="cookie_auth_check" class="check_cookie" checked>
						<label for="cookie_auth_check"><span></span>14일 동안 그만 보기</label>
						<button type="button" class="btn_nexttime" id="btnAuthClose" style="float: right;width: 55px;height:24px;font-size:15px;color: #fff;background: #878787;margin-right: 20px;letter-spacing: -1px;">확인</button>
					</div>
				</div>

			</div>
		</div>

    </t:putAttribute>
    <t:putAttribute name="script">
		<!-- lazyload 1.9.3 CDN -->
		<script src="${_MOBILE_PATH}/front/js/lib/jquery.lazyload.min.js" charset="utf-8"></script>
        <script>
            $("img.lazy").lazyload({
                    threshold :1,        //뷰포트에 보이기 300px 전에 미리 로딩
                    effect : "fadeIn"       //효과
                });
            $(document).ready(function(){
                var loginYn = "${memberNoYn}";
                //앱접근 권한 팝업
                var authCookieValue = getCookie("cookieName_m_authAgree");
                if(authCookieValue == null || authCookieValue == ''){
        	    	$('#popupAuth').show();
				}else{
					//$('#popupAuth').hide();
				}

				 // 접근권한 팝업 닫기
				$('#btnAuthClose').on('click touch', function(e) {
					var ckkClick = $('input:checkbox[id=cookie_auth_check]').is(':checked');
					if(ckkClick){ //14일동안 그만보기 체크시 쿠기 생성
						var expdate = new Date();
						expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 14);
						var name = "cookieName_m_authAgree";
						var value = "cookieName_m_authAgree";
						setCookie(name,value,expdate);
					}
					$('#popupAuth').hide();
				});

                if(loginYn) {

                    var is_auto_login = "${appInfo.autoLoginGb}"; //자동로그인여부
                    var is_noti = "${appInfo.notiGb}";//공지안내 알림여부
                    var is_event = "${appInfo.eventGb}";//혜택이벤트 알림여부
                    var is_news = "${appInfo.newsGb}";//신제품 뉴스 알림여부
                    var is_location = "${appInfo.locaGb}"; //위치정보 수집이용 동의여부
					var is_forcePushAgreeYn= "${appInfo.forcePushAgreeYn}"; //위치정보 수집이용 동의여부

                    if (isAndroidWebview()) {
                       davichapp.bridge_app_init(is_auto_login, is_noti, is_event, is_news, is_location);
                    }

                    if (isIOSWebview()) {
                        window.webkit.messageHandlers.davichapp.postMessage({
                               func: 'bridge_app_init',
                               param1: is_auto_login,
                               param2: is_noti,
                               param3: is_event,
                               param4: is_news,
                               param5: is_location,
                       });
                    }

                    // 인트로화면의 멤버쉽 바로보기
                    var introYn = "${introYn}";
                    if(introYn == 'Y'){
                        $('.btn_view_card').click();
                    }

                 // 앱 푸쉬 동의 팝업
        	    	if((is_noti == 0 && is_event == 0 && is_news == 0) || is_forcePushAgreeYn=='Y' ){
        	    		var cookieValue = getCookie("cookieName_m_pushAgree");
        	    		if(is_forcePushAgreeYn!='Y') {
							// 쿠기 없을 시 팝업 열기
							if (cookieValue == null || cookieValue == '') {
								$('#popupPushAgree').show();
							}
						}else{
        	    			// 푸쉬 강제 동의 여부가 Y 면 무조건 노출
        	    			$('#popupPushAgree').show();
						}

        	    		// 팝업 닫기
        	            $('#btnPushClose').on('click touch', function(e) {
        	                var ckkClick = $('input:checkbox[id=cookie_check]').is(':checked');
        	                if(ckkClick){ //14일동안 그만보기 체크시 쿠기 생성
        	                    var expdate = new Date();
        	                    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 14);
        	                    var name = "cookieName_m_pushAgree";
        	                    var value = "cookieName_m_pushAgree";
        	                    setCookie(name,value,expdate);
        	                }
        	                $('#popupPushAgree').hide();
        	            });



        	    		// 알림 받기
        	    		$('#btnPushAgree').on('click touch', function(e) {
        	    			var agreeSwich = $('input:checkbox[id=btnAgreeSwich]').is(':checked');
        	    			if(agreeSwich){
        	    				var url = '${_MOBILE_PATH}/front/appPush-agree';
        		    			var memberNo = "${user.session.memberNo}";
        		    			var param = {memberNo : memberNo}
        		    			Dmall.AjaxUtil.getJSON(url, param, function(result) {
        		    				if(result.success) {
        		    					is_noti = '1';
        		    					is_event = '1';
        		    					is_news = '1';
        		    					if (isAndroidWebview()) {
        	    				    	   davichapp.bridge_app_init(is_auto_login, is_noti, is_event, is_news, is_location);
        	    				    	}

        	    				    	if (isIOSWebview()) {
        	    					   	    window.webkit.messageHandlers.davichapp.postMessage({
        	    						   	       func: 'bridge_app_init',
        	    						   	       param1: is_auto_login,
        	    						   	       param2: is_noti,
        	    						   	       param3: is_event,
        	    						   	       param4: is_news,
        	    						   	       param5: is_location,
        	    					   	   });
        	    				    	}

        		    					var now = new Date().format("yyyy-MM-dd");
        		    					$('.push_agree_time').text(now);
        		    					$('#popupPushAgree').hide();
        		    					$('#popupPushAgreeSucc').show();

        		    					// 수신동의 완료 팝업 닫기
        		    		    		$('#btnPushSuccClose').on('click touch', function(e) {
        		    		    			$('#popupPushAgreeSucc').hide();
        		    		    		});
        		    				}
        		    			});
        	    			}else{
        	    				Dmall.LayerUtil.alert("광고성 정보(PUSH)수신동의를 체크해 주세요.", "알림");
        	    			}

        	    		});

        	    	}
                }

                //이미지 슬라이더
                $('.product_slider').bxSlider({
                    auto: false,
                });
                $('#product_list_slider').bxSlider({
                  slideMargin: 5,
                  autoReload: true,
                  breaks: [{screen:0, slides:2, pager:true},{screen:640, slides:2},{screen:768, slides:3}]
                });

                $('div[name=image_view]').each(function(idx, item){
                    var $el = $(this);
                    $('div[name=goodsRow]', $el).hide();
                    $('div[name=goodsRow]', $el).first().show();
                    $('li[name=totalPage]', $el.next()).text($('div[name=goodsRow]', $el).size());
                });

                //이전 버튼을 클릭하면 이전 슬라이드로 전환
                $( 'li.prev' ).on( 'click', function () {
                    var $curPage = $(this).parent().find('span[name=curPage]');
                    var curPage = Number($curPage.text());
                    if(curPage > 1){
                        var $image_view = $(this).parent().parent().prev();
                        var $prevImageView = $image_view.find('div[name=goodsRow]:visible').prev();
                        $('div[name=goodsRow]', $image_view).hide();
                        $prevImageView.show();
                        $curPage.text(curPage-1);
                    }
                    return false;              //<a>에 링크 차단
                });


                //다음 버튼을 클릭하면 다음 슬라이드로 전환
                $( 'li.next' ).on( 'click', function () {
                    var $curPage = $(this).parent().find('span[name=curPage]');
                    var curPage = Number($curPage.text());
                    var totalPage = Number($(this).parent().find('li[name=totalPage]').text());
                    if(curPage < totalPage){
                        var $image_view = $(this).parent().parent().prev();
                        var $nextImageView = $image_view.find('div[name=goodsRow]:visible').next();
                        $('div[name=goodsRow]', $image_view).hide();
                        $nextImageView.show();
                        $curPage.text(curPage+1);
                    }
                    return false;
                });

                //포토리뷰 슬라이더
                $(function () {
                    var Photoslider = $('.photo_review_list').bxSlider({
                        pager:false,
                        auto:true,
                        infiniteLoop: true,
                        controls:false,
                        slideWidth: '187',
                        slideMargin:22,
                        minSlides:2,
                        maxSlides:2,
                        moveSlides:2,
                        onSlideAfter: function() {
                            Photoslider.startAuto();
                        }
                    });
                });

                /*   main best of best slider   */
                $(function () {
                   var BBslider = $('.BB_slider').bxSlider({
                        adaptiveHeight: true,
                        mode: 'fade',
                        auto: false,
                        controls: false,
                        pagerCustom: '.main_mid_tab'
                    });
                    $('.btn_BB_list_prev').click(function () {
                        var current = BBslider.getCurrentSlide();
                        BBslider.goToPrevSlide(current) - 1;
                    });
                    $('.btn_BB_list_next').click(function () {
                        var current = BBslider.getCurrentSlide();
                        BBslider.goToNextSlide(current) + 1;
                    });
                });

                /* setTimeout(function() {
                    cookieSetup();
                }, 1000);	 */
            });

            /* function cookieSetup() {
                var expdate = new Date();
                var jds = $.cookie("_JDS");
                var auto = $.cookie("dmallAutoLoginYn");

                if (auto == "Y")
                    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 365); // 1년
                else
                    expdate.setTime(expdate.getTime() + 1000 * 1800 );

                if (jds != null && jds != undefined) {
                    setCookie("jdsc", jds, expdate);
                }
            } */


    </script>
	</t:putAttribute>
</t:insertDefinition>