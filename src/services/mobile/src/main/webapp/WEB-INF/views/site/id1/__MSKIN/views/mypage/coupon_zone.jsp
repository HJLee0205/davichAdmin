<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">쿠폰존</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    	<%-- 텐션DA SCRIPT --%>
		<script>
			ex2cts.push('track', 'coupon');
		</script>
		<%--// 텐션DA SCRIPT --%>
        <script type="text/javascript">
        $(document).ready(function(){
            $('#searchCouponOnlineYn, #searchGoodsTypeCd, #searchAgeCd').change(function(){
            	/*var couponOnlineYn = $('#searchCouponOnlineYn').val();
            	var goodsTypeCd = $('#searchGoodsTypeCd').val();
            	var ageCd = $('#searchAgeCd').val();
            	var param = {couponOnlineYn : couponOnlineYn, goodsTypeCd : goodsTypeCd, ageCd : ageCd};
            	Dmall.FormUtil.submit('${_MOBILE_PATH}/front/coupon/coupon-zone', param);*/

            	var couponOnlineYn = $('#searchCouponOnlineYn').val();
            	var ageCd = $('#searchAgeCd').val();
				var ageRange = calcAge('${user.session.birth}');
				var goodsTypeCd=$('.tabs_coupon li.active').data('goodsTypeCd');

				var url = '${_MOBILE_PATH}/front/coupon/coupon-zone-ajax';
				var param = {couponOnlineYn : couponOnlineYn, goodsTypeCd : goodsTypeCd, ageCd : ageCd,ageRange:ageRange};
				Dmall.waiting.start();
				Dmall.AjaxUtil.loadByPost(url, param, function(result) {
					if(result){
						$('.tab_content_zone').html(result);
						Dmall.waiting.stop();
					}else{
						$('.tab_content_zone').html('');
						Dmall.waiting.stop();
					}
				});
            });


            var goodsTypeCd = '${param.goodsTypeCd}';
			$('.tabs_coupon li[data-goods-type-cd="'+goodsTypeCd+'"]').trigger('click');


			var drtCpIssuYn = '${so.drtCpIssuYn}';
			var drtCpNo = '${so.drtCpNo}';

			if(drtCpIssuYn=='Y'){
				drtIssueCoupon(drtCpNo);

			}

        });

        //상품유형 Tab 선택시..
            jQuery('.tabs_coupon li').off("click").on('click', function(e) {
				Dmall.EventUtil.stopAnchorAction(e);

				$('.tabs_coupon li').removeClass("active");
				$(this).addClass('active');
				var goodsTypeCd=$(this).data('goodsTypeCd');
				var url = '${_MOBILE_PATH}/front/coupon/coupon-zone-ajax';

				var couponOnlineYn = $('#searchCouponOnlineYn').val();
            	var ageCd = $('#searchAgeCd').val();
				var ageRange = calcAge('${user.session.birth}');
				var param = {couponOnlineYn : couponOnlineYn, goodsTypeCd : goodsTypeCd, ageCd : ageCd,ageRange:ageRange};

				Dmall.waiting.start();
				Dmall.AjaxUtil.loadByPost(url, param, function(result) {

					if(result){
						$('.tab_content_zone').html(result);
						Dmall.waiting.stop();

					}else{
						$('.tab_content_zone').html('');
						Dmall.waiting.stop();
					}
				});

			});
        
        /* 쿠폰 건별 직접 발급 */
        function drtIssueCoupon(couponNo) {
        	var memberNo =  '${user.session.memberNo}';
        	if(memberNo == '') {
        		Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+encodeURIComponent(returnUrl);
                    },''
                );
                return false;
            }else{
                var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';
             	if (integrationMemberGbCd == '02' ) {
             		Dmall.LayerUtil.confirm("간편회원은 사용하실 수 없습니다.<br>정회원 전환 후 이용해 주세요."
                 		, function() {
                 			var returnUrl = window.location.pathname+window.location.search;
                 			location.href= "${_MOBILE_PATH}/front/member/information-update-form";
                   		},'','', '', '닫기', '정회원 전환');
                 	return false;
             	}
        	}
        	
            var url = '${_MOBILE_PATH}/front/coupon/coupon-issue?drtCpIssuYn=Y';
            var param = {couponNo:couponNo};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                	var target_li = $('#li_'+couponNo); 
                	$(target_li).find('p.couponzone_name').addClass('end');
                	$(target_li).find('div.coupon').addClass('end');
                	$(target_li).find('button.btn_zone_down').attr('disabled','disabled');
                	$(target_li).find('button.btn_zone_down').find('i').remove();
                	$(target_li).find('button.btn_zone_down').text('쿠폰받기 완료');

					/*Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                    			couponPrintPop(couponNo);
                			},'','','','닫기','쿠폰보기'
                        );*/
					couponPrintPop(couponNo);
                } else {
                	couponPrintPop(couponNo);
                    /*Dmall.LayerUtil.alert('오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.', '','');*/
                }
            });
        }

        function issueCoupon(couponNo, offYn) {
        	var memberNo =  '${user.session.memberNo}';
        	if(memberNo == '') {
        		Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                    },''
                );
        		<!-- 190415 개발적용 -->
        		/* Dmall.LayerUtil.confirm("로그인을 하시면 고객님의 쿠폰이 추가 적용됩니다.",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
        			},'','','','닫기','로그인'
                ); */
                return false;
            }else{
                var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';
             	if (integrationMemberGbCd == '02' ) {
             		Dmall.LayerUtil.confirm("간편회원은 사용하실 수 없습니다.<br>정회원 전환 후 이용해 주세요."
                 		, function() {
                 			var returnUrl = window.location.pathname+window.location.search;
                 			location.href= "${_MOBILE_PATH}/front/member/information-update-form";
                   		},'','', '', '닫기', '정회원 전환');
                 	return false;
             	}
        	}

            var url = '${_MOBILE_PATH}/front/coupon/coupon-issue';
            var param = {couponNo:couponNo};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                	var target_li = $('#li_'+couponNo);
                	$(target_li).find('p.couponzone_name').addClass('end');
                	$(target_li).find('div.coupon').addClass('end');
                	$(target_li).find('button.btn_zone_down').attr('disabled','disabled');
                	$(target_li).find('button.btn_zone_down').find('i').remove();
                	$(target_li).find('button.btn_zone_down').text('쿠폰받기 완료');

                    if(offYn == 'Y'){
                    	Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                    			couponPrintPop(couponNo);
                			},'','','','닫기','쿠폰보기'
                        );
                    }else{
                    	Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                    			location.href= "${_MOBILE_PATH}/front/coupon/coupon-list";
                			},'','','','닫기','마이페이지'
                        );
                    }
                } else {
                    /*Dmall.LayerUtil.alert('오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.', '','');*/
                }
            });
        }
        
        function couponPrintPop(couponNo) {
        	
        	var url = "${_MOBILE_PATH}/front/coupon/coupon-info-ajax";
            var param = {couponNo:couponNo};
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success){
                	var data = result.data;
                	
                	var endDttm = data.cpApplyStartDttm + ' ~ ' + data.cpApplyEndDttm;
                	if(data.couponApplyPeriodCd != '01'){
                		endDttm = data.couponApplyPeriodDttm;
                	}
                	var bnfDc = data.couponUseLimitAmt + '원 이상 구매시';
                	if(data.couponBnfCd == '01' && data.couponBnfDcAmt > 0){
                		bnfDc += '/ 최대 ' + data.couponBnfDcAmt + '원';
                	}
                	var dcAmt = data.couponBnfDcAmt;
                	var dcUnit = '원';
                	if(data.couponBnfCd == '01'){
                		dcAmt = data.couponBnfValue;
                		dcUnit = '%';
                	}
                	var divType = "coupon";
                	if(data.goodsTypeCd == '01') divType += " off01";
                	else if(data.goodsTypeCd == '02') divType += " off04";
                	else if(data.goodsTypeCd == '03') divType += " off03";
                	else if(data.goodsTypeCd == '04') divType += " off02";
                	else divType += " off00";
                	$('#print_div').attr('class', divType);
                	$('#print_regDttm').text(data.issueDttm);
                	$('#print_usePeriod').text(endDttm);
                	$('#print_couponNm').text(data.couponNm);
                	$('#print_useLimitAmt').text(commaNumber(bnfDc));
                	if(data.couponBnfCd != '03') {
						$('#print_bnfValue').html('<em>' + commaNumber(dcAmt) + '</em>' + dcUnit + ' 할인');
					}else{
						$('#print_bnfValue').html('<em style="font-size:23px;">' + data.couponBnfTxt+'</em>');
					}
                	$('#print_dscrt').text(data.couponDscrt);
                	
                	var cpIssueNo = data.cpIssueNo;
                	
                	$("#bcTarget_coupon").barcode(cpIssueNo, "code128",{barWidth:2});
                	$('#cp_issue_no').text("NO. " + cpIssueNo.substring(0,2) + "-" + cpIssueNo.substring(2,5) + "-" + cpIssueNo.substring(5,9) + "-" + cpIssueNo.substring(9,13));
                	
                	Dmall.LayerUtil.close('div_id_alert');
                	$('#couponPop').remove();
                	Dmall.LayerPopupUtil.open($('#coupon_print_popup'));
                }
            });
        }
        
        /* 쿠폰 전체 발급 */
        function issueCouponAll() {
        	
        	var memberNo =  '${user.session.memberNo}';
        	if(memberNo == '') {
        		Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                    },''
                );
        		<!-- 190415 개발적용 -->
        		/* Dmall.LayerUtil.confirm("로그인을 하시면 고객님의 쿠폰이 추가 적용됩니다.",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
        			},'','','','닫기','로그인'
                ); */
                return false;
            }else{
                var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';
             	if (integrationMemberGbCd == '02' ) {
             		Dmall.LayerUtil.confirm("간편회원은 사용하실 수 없습니다.<br>정회원 전환 후 이용해 주세요."
                 		, function() {
                 			var returnUrl = window.location.pathname+window.location.search;
                 			location.href= "${_MOBILE_PATH}/front/member/information-update-form";
                   		},'','', '', '닫기', '정회원 전환');
                 	return false;
             	}
        	}
        	
            var couponAvailCnt = 0;
            $('button.btn_zone_down').each(function(){
                if($(this).attr('disabled') != 'disabled' ){
                	couponAvailCnt++;
                }
            });
            
            if(couponAvailCnt > 0) {
                var url = '${_MOBILE_PATH}/front/coupon/coupon-zone-issue-all';
                var param = {};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {

                    	$('ul.conpon_zone_list li').each(function(){
                        	$(this).find('p.couponzone_name').addClass('end');
                        	$(this).find('div.coupon').addClass('end');
                        	$(this).find('button.btn_zone_down').attr('disabled','disabled');
                        	$(this).find('button.btn_zone_down').find('i').remove();
                        	$(this).find('button.btn_zone_down').text('쿠폰받기 완료');
                    	});
                	
                    	Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                    			location.href= "${_MOBILE_PATH}/front/coupon/coupon-list";
                			},'','','','닫기','마이페이지'
                        );
                    } else {
                        Dmall.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
                    }
                });
            } else {
                Dmall.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
            }
        }
        function calcAge(birth) {
			var date = new Date();
			var year = date.getFullYear();
			var month = (date.getMonth() + 1);
			var day = date.getDate();
			if (month < 10) month = '0' + month;
			if (day < 10) day = '0' + day;
			var monthDay = month + day;
			birth = birth.replace('-', '').replace('-', '');
			var birthdayy = birth.substr(0, 4);
			var birthdaymd = birth.substr(4, 4);
			var age = monthDay < birthdaymd ? year - birthdayy - 1 : year - birthdayy;
			age= String(age).substr(0,1)+"0";
			return age;
		}
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    	<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			쿠폰존
		</div>
		<div class="cont_body">

			<!-- 쿠폰존 -->
			<div class="zone_area" style="margin-top: 10px;">
				<a class="zone_top_area">
					<button type="button" class="btn_all_zone" onclick="issueCouponAll();">전체받기<i></i></button>
					<a class="zone_top_area" href="${_MOBILE_PATH}/front/coupon/coupon-list"><button type="button" style="float: right;" class="btn_all_zone">내 보유 쿠폰</button></a>
					<div class="right_select" style="    margin-top: 10px;">
						<select name="couponOnlineYn" id="searchCouponOnlineYn">
							<tags:option codeStr=":전체;Y:온라인;N:오프라인;F:온/오프라인;" value="${so.couponOnlineYn }"/>
						</select>
						<select name="ageCd" id="searchAgeCd">
							<tags:option codeStr=":연령대별;10:10대;20:20대;30:30대;40:40대;50:50대;60:60대;" value="${so.ageCd }"/>
						</select>
					</div>
				</div>

				<h2 class="zone_tit"><img src="${_SKIN_IMG_PATH}/visit/coupon_tit.gif" alt="쿠폰존 쿠폰도 쇼핑하자"></h2>	

				<ul class="tabs_coupon">
					<li class="active">전체</li>
					<li data-goods-type-cd="01">안경</li>
					<li data-goods-type-cd="02">선글라스</li>
					<li data-goods-type-cd="04">콘택트렌즈</li>
				</ul>

				<div class="tab_content_zone">
					<c:forEach var="couponTypeList" items="${couponTypeList}" varStatus="status">
					<h3 class="zone_stit">${couponTypeList.goodsTypeCdNm}</h3>
					<c:set var="couponList" value="couponList${status.index}" />
		           	<c:set var="resultList" value="${requestScope.get(couponList)}" />
					<ul class="conpon_zone_list">
						<c:forEach var="couponList" items="${resultList }" varStatus="status">
						<c:set var="couponType" value=""/>
						<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn eq 'Y' or couponList.offlineOnlyYn eq 'F'}">
							<c:choose>
								<c:when test="${couponList.goodsTypeCd eq '01' }"><c:set var="couponType" value="off01"/></c:when>
								<c:when test="${couponList.goodsTypeCd eq '02' }"><c:set var="couponType" value="off04"/></c:when>
								<c:when test="${couponList.goodsTypeCd eq '03' }"><c:set var="couponType" value="off03"/></c:when>
								<c:when test="${couponList.goodsTypeCd eq '04' }"><c:set var="couponType" value="off02"/></c:when>
								<c:otherwise><c:set var="couponType" value="off00"/></c:otherwise>
							</c:choose>
						</c:if>
						<c:if test="${couponList.issueYn eq 'Y'}">
							<c:set var="couponType" value="${couponType } end"/>
						</c:if>
						<li id="li_${couponList.couponNo }">
							<p class="couponzone_name <c:if test="${couponList.issueYn eq 'Y'}">end</c:if>">${couponList.couponNm }</p>
							<div class="coupon ${couponType}">
								<p class="price">
								<em <c:if test="${couponList.couponBnfCd eq '03' }">style="font-size: 20px;"</c:if>>
										<c:choose>
											<c:when test="${couponList.couponBnfCd eq '01' }">
												<fmt:formatNumber value="${couponList.couponBnfValue}" type="currency" maxFractionDigits="0" currencySymbol=""/>
											</c:when>
											<c:when test="${couponList.couponBnfCd eq '02' }">
												<fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
											</c:when>
											<c:otherwise>
												${couponList.couponBnfTxt}
											</c:otherwise>
										</c:choose>
								</em>
								<c:choose>
									<c:when test="${couponList.couponBnfCd eq '01'}">%</c:when>
									<c:when test="${couponList.couponBnfCd eq '02'}">원</c:when>
								</c:choose>
								<c:if test="${couponList.couponBnfCd ne '03' }">
								할인
								</c:if>

								</p>
								<p class="text">
									<c:if test="${couponList.couponUseLimitAmt > 0 }">
										<fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 구매시
									</c:if>
									<c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
										<c:if test="${couponList.couponUseLimitAmt > 0 }"> / </c:if>
                       					최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                           			</c:if>
								</p>
							</div>
							<c:choose>
								<c:when test="${couponList.issueYn eq 'Y'}">
									<button type="button" class="btn_zone_down" disabled>쿠폰받기 완료</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn_zone_down" data-couponNo="${couponList.couponNo }" onClick="issueCoupon('${couponList.couponNo}','${couponList.offlineOnlyYn}')">쿠폰받기<i></i></button>
								</c:otherwise>
							</c:choose>
						</li>
						</c:forEach>
					</ul>
					</c:forEach>
				</div>

			</div>
			<!-- 쿠폰존 -->


			<!-- 쿠폰존 -->
			<%--<div class="zone_area">
				<div class="zone_top_area">
					<button type="button" class="btn_all_zone" onclick="issueCouponAll();">전체받기<i></i></button>
					<div class="right_select">
						<select name="couponOnlineYn" id="searchCouponOnlineYn">
							<tags:option codeStr=":전체;Y:온라인;N:오프라인;" value="${so.couponOnlineYn }"/>
						</select>
						<select name="goodsTypeCd" id="searchGoodsTypeCd">
							<tags:option codeStr=":제품별;01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;" value="${so.goodsTypeCd }"/>
						</select>
						<select name="ageCd" id="searchAgeCd">
							<tags:option codeStr=":연령대별;10:10대;20:20대;30:30대;40:40대;50:50대;60:60대;" value="${so.ageCd }"/>
						</select>
					</div>
				</div>

				<div class="conpon_zone_tit">
					<i class="icon_zone"></i><em>쿠폰</em>도 <em>쇼핑</em>하자
				</div>

				<ul class="conpon_zone_list">
					<c:forEach var="couponList" items="${resultList }" varStatus="status">
						<li id="li_${couponList.couponNo }">
							<c:set var="couponType" value=""/>
							<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn eq 'Y'}">
								<c:choose>
									<c:when test="${couponList.goodsTypeCd eq '01' }"><c:set var="couponType" value="off01"/></c:when>
									<c:when test="${couponList.goodsTypeCd eq '02' }"><c:set var="couponType" value="off04"/></c:when>
									<c:when test="${couponList.goodsTypeCd eq '03' }"><c:set var="couponType" value="off03"/></c:when>
									<c:when test="${couponList.goodsTypeCd eq '04' }"><c:set var="couponType" value="off02"/></c:when>
									<c:otherwise><c:set var="couponType" value="off00"/></c:otherwise>
								</c:choose>
							</c:if>
							<c:if test="${couponList.issueYn eq 'Y'}">
								<c:set var="couponType" value="${couponType } end"/>
							</c:if>

							<p class="couponzone_name <c:if test="${couponList.issueYn eq 'Y'}">end</c:if>">${couponList.couponNm }</p>
							<div class="coupon ${couponType }">
								<p class="price">
									<em <c:if test="${couponList.couponBnfCd eq '03' }">style="font-size: 13px;"</c:if>>
										<c:choose>
											<c:when test="${couponList.couponBnfCd eq '01' }">
												<fmt:formatNumber value="${couponList.couponBnfValue}" type="currency" maxFractionDigits="0" currencySymbol=""/>		
											</c:when>
											<c:when test="${couponList.couponBnfCd eq '02' }">
												<fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
											</c:when>
											<c:otherwise>
												${couponList.couponBnfTxt}
											</c:otherwise>
										</c:choose>
									</em>
									<c:choose>
										<c:when test="${couponList.couponBnfCd eq '01'}">%</c:when>
										<c:when test="${couponList.couponBnfCd eq '02'}">원</c:when>
									</c:choose>
									<c:if test="${couponList.couponBnfCd ne '03' }">
									할인
									</c:if>
								</p>
								<p class="text">
									<c:if test="${couponList.couponUseLimitAmt > 0 }">
										<fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 구매시
									</c:if>
									<c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
										<c:if test="${couponList.couponUseLimitAmt > 0 }"> / </c:if>
                       					최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                           			</c:if>
								</p>
							</div>
							<c:choose>
								<c:when test="${couponList.issueYn eq 'Y'}">
									<button type="button" class="btn_zone_down" disabled>쿠폰받기 완료</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn_zone_down" data-couponNo="${couponList.couponNo }" onClick="issueCoupon('${couponList.couponNo}','${couponList.offlineOnlyYn}')">쿠폰받기<i></i></button>
								</c:otherwise>
							</c:choose>
						</li>
					</c:forEach>
				</ul>
			</div>--%>
			<!-- 쿠폰존 -->
		</div>
		
		<!-- popup 쿠폰 보기-->
		<div class="popup_coupon_select" id="coupon_print_popup" style="display:none;">
			<div class="popup_header">
				<h1 class="popup_tit">쿠폰정보</h1>
				<button type="button" class="btn_close_popup"><img src="../img/common/btn_close_popup.png" alt="팝업창닫기"></button>
			</div>
			<div class="popup_content"> 
				<div id="print_area">
					<div class="popup_coupon_area">
						<div class="coupon" id="print_div">
							<p class="price" id="print_bnfValue"></p>
							<p class="text" id="print_useLimitAmt"></p>
						</div>
						<div class="barcode">
							<div id="bcTarget_coupon" style="margin: 0 auto"></div>
							<p class="member_no"><span id="cp_issue_no" style="font-size:20px;"></span></p>
						</div>
					</div>
					<div class="popup_coupon_outline">
						<table class="tb_coupon">
							<caption>쿠폰 정보 내용입니다.</caption>
							<colgroup>
								<col style="width:70px">
								<col style="width:">
							</colgroup>
							<tbody>
								<tr>
									<th>이벤트명</th>
									<td id="print_couponNm">0000-00-00</td>
								</tr>
								<tr>
									<th>사용기간</th>
									<td id="print_usePeriod">0000-00-00 00:00 ~ 0000-00-00 00:00</td>
								</tr>
								<tr>
									<th>사용</th>
									<td>전국 다비치매장 (일부매장 제외)</td>
								</tr>
							</tbody>
						</table>
					</div>
						
					<div class="popup_bottom_coupon">
						<p class="tit">※  쿠폰사용안내</p>
						<div class="text_area" id="print_dscrt">
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--// popup 쿠폰 보기-->
    </t:putAttribute>
</t:insertDefinition>