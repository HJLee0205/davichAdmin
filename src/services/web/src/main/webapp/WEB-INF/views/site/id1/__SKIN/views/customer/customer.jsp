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
	<t:putAttribute name="title">다비치마켓 :: 고객센터</t:putAttribute>


    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //FAQ 더보기
        $('#best_qna5').on('click', function(e) {
            location.href = "/front/customer/faq-list";
        });

        //공지사항 더보기
        $('#notice_more').on('click', function(e) {
            location.href = "/front/customer/notice-list";
        });
        
        //나의문의 더보기
/*         $('#inquiry_more').on('click', function(e) {
        	var param = {};
			var url = "/front/customer/inquiry-list";
	    	Dmall.FormUtil.submit(url, param);	         
        }); */
       //나의문의내역 이동
    	function moveInquiryList(){
    			var param = {};
    			var url = "/front/customer/inquiry-list";
    	    	//Dmall.FormUtil.submit(url, param);
    	          var memberNo =  '${user.session.memberNo}';
    	          if(memberNo == '') {
    	              Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
    	                  //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
    	                  function() {
    	                      var returnUrl = "/front/customer/inquiry-list";
    	                      location.href= "/front/login/member-login?returnUrl="+returnUrl;
    	                  }
    	              );
    	          } else {
    	        	  Dmall.FormUtil.submit(url, param);
    	          }

       		  }
        
        
        //FAQ 검색
        $('#btn_qna_search').on('click', function() {
            var searchVal = $("#qna_search").val();
            var param = {searchVal : searchVal, faqGbCd:'', searchKind:'customerMain'};
            var url = "/front/customer/faq-list";
            Dmall.FormUtil.submit(url, param)
        });

        $('#qna_search').on('keydown',function(event){
            if (event.keyCode == 13) {
                $('#btn_qna_search').click();
            }
        })

        //아이디/비번 찾기
        $('.customer_bottom_menu01').on('click', function(e) {
            location.href = "/front/login/account-search?mode=id";
        });

        //주문 / 배송조회
        $('.customer_bottom_menu02').on('click', function(e) {
            if(loginYn) {
                location.href = "/front/order/order-list";
            }else{
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    location.href= "/front/login/member-login"
                },'');
            }
        });

        //회원정보 수정
        $('.customer_bottom_menu03').on('click', function(e) {
            if(loginYn) {
                location.href = "/front/member/information-update-form";
            }else{
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    location.href= "/front/login/member-login"
                },'');
            }
        });

        // 미확인 입금내역
        $('.customer_bottom_menu04').on('click', function(e) {
            if(loginYn) {
                location.href = "/front/member/refund-account";
            }else{
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    location.href= "/front/login/member-login"
                },'');
            }
        });
    });
    function viewFaq(idx){
        location.href = "/front/customer/faq-list?faqGbCd="+idx;
    }
    function viewNotice(idx){
        location.href="/front/customer/notice-detail?lettNo="+idx
    }
    function viewInquiry(idx){
        //location.href = "/front/customer/inquiry-list";
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- category header 카테고리 location과 동일 --->
    <div id="category_header">
        <div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>고객센터</li>
            </ul>
            <!-- <span class="location_bar"></span><a href="/">홈</a><span>&gt;</span>고객센터 -->
        </div>
    </div>
    <!---// category header --->
     <!--- 02.LAYOUT: 마이페이지 --->
    <div class="customer_middle">	
		<!-- snb -->
		<%@ include file="include/customer_left_menu.jsp" %> 	
		<!-- //snb -->
		<!-- content -->
		<div id="customer_content">
			<div class="customer_top">		
				<div class="text_area">
					<em>자주묻는질문 검색</em>으로<br>
					더 빠르게 궁금증을 해결해 보세요.
				</div>
				<div class="search_area">
					<input type="text" id="qna_search"><button type="button" class="btn_q_search" id="btn_qna_search">검색</button>
				</div>
			</div>
			<div class="customer_body">
				<ul class="top_menu_list">
					<li>
						<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=287">
							<i class="icon_guide01"></i>
							안경테<br>구매가이드
						</a>
					</li>
					<li>
						<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=288">
							<i class="icon_guide02"></i>
							콘택트렌즈<br>구매가이드
						</a>
					</li>
					<li>
						<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=289">
							<i class="icon_guide03"></i>
							안경렌즈<br>구매가이드
						</a>
					</li>
					<li>
						<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=290">
							<i class="icon_guide04"></i>
							나의 시력<br>체크
						</a>
					</li>
					<li>
						<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=291">
							<i class="icon_guide05"></i>
							방문예약<br>안내
						</a>
					</li>
					<li>
						<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=292">
							<i class="icon_guide06"></i>
							할인권<br>사용방법
						</a>
					</li>
					<li>
						<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=293">
							<i class="icon_guide07"></i>
							비회원<br>주문조회
						</a>
					</li>
					<li>
						<a href="/front/customer/letter-detail?bbsId=freeBbs&lettNo=294">
							<i class="icon_guide08"></i>
							마켓회원등급<br>포인트안내
						</a>
					</li>
				</ul>
				<h4 class="my_stit">
					자주묻는 질문 <b>TOP 10</b>
					<a href="#" class="btn_view_alllist" id="best_qna5">전체보기</a>
				</h4>							
				<table class="tProduct_Board my_qna_table02">
					<caption>
						<h1 class="blind">상품문의 게시판 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:128px">
						<col style="">
					</colgroup>
					<tbody>						
						<c:choose>
							<c:when test="${fn:length(faqList.resultList) eq 0}">
								<td colspan="2"><p>등록된 데이터가 없습니다.</p></td>
							</c:when>
							<c:otherwise>
								<c:forEach var="faqList" items="${faqList.resultList}" varStatus="status" end="9">
			                        <tr class="title" id="faqDetail">
										<td><span class="bar_tit">${faqList.faqGbNm}</span></td>
										<td class="textL">${faqList.title}</td>
									</tr>
									<tr class="hide">
										<td colspan="2" class="que_text_area">${faqList.content}</td>
									</tr>
		                        </c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
				<div class="bottom_notice_area">
					<div class="left">
						<h4 class="my_stit">
							공지사항
							<a href="#" class="btn_view_alllist" id="notice_more">전체보기</a>
						</h4>	
						<ul class="notice_list">
							<c:choose>
								<c:when test="${fn:length(noticeList.resultList) eq 0}">
									<td colspan="2"><p>공지사항이 없습니다.</p></td>
								</c:when>
								<c:otherwise>
									<c:forEach var="noticeList" items="${noticeList.resultList}" varStatus="status" end="2">
										<li>
											<a href="javascript:viewNotice('${noticeList.lettNo}');">${noticeList.title}</a>
											<span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${noticeList.regDttm}" /></span>
										</li>
			                        </c:forEach>
								</c:otherwise>
							</c:choose>							
						</ul>
					</div>
					<div class="right">
						<h4 class="my_stit">
							나의 문의
							<a href="javascript:moveInquiryList();" class="btn_view_alllist" id="inquiry_more">전체보기</a>
						</h4>	
						<ul class="notice_list">
							<c:choose>
								<c:when test="${user.session.memberNo ne null}">
									<c:choose>
										<c:when test="${fn:length(inquiryList.resultList) eq 0}">
											<td colspan="2"><p>문의내역이 없습니다.</p></td>
										</c:when>
										<c:otherwise>
											<c:forEach var="inquiryList" items="${inquiryList.resultList}" varStatus="status" end="2">
												<li>
													<a href="javascript:viewInquiry('${inquiryList.lettNo}');">${inquiryList.title}</a>
													<span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${inquiryList.regDttm}" /></span>
												</li>
					                        </c:forEach>
										</c:otherwise>
									</c:choose>		
								</c:when>
								<c:otherwise>
									<td colspan="2"><p>로그인 후 확인해 주세요.</p></td>
								</c:otherwise>
							</c:choose>												
						</ul>
					</div>
				</div>
			</div>
		</div>		
		<!--// content -->
	</div>
    <!---// 02.LAYOUT: 마이페이지 --->	
    </t:putAttribute>
</t:insertDefinition>