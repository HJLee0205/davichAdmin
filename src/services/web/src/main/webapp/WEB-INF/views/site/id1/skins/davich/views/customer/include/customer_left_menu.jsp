<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<sec:authentication var="user" property='details'/>
<script>

	 //FAQ 해당페이지 이동
	 function selectFaqList(faqGbCd){
	      var param = {faqGbCd:faqGbCd};
	      var url = "/front/customer/faq-list";
	      Dmall.FormUtil.submit(url, param)
	 }
	 
	//문의하기 페이지 이동
	function moveInquiryInsert(){
			var param = {};
			var url = "/front/customer/inquiry-insert-form";
	    	//Dmall.FormUtil.submit(url, param);
	          var memberNo =  '${user.session.memberNo}';
	          if(memberNo == '') {
	              Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
	                  //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
	                  function() {
	                      var returnUrl = "/front/customer/inquiry-insert-form";
	                      location.href= "/front/login/member-login?returnUrl="+returnUrl;
	                  }
	              );
	          } else {
	        	  Dmall.FormUtil.submit(url, param);
	          }

   		  }
	
	
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

     //게시판 이동
     function goCustomer(bbsId) {
         //var param = {bbsId : bbsId}
         //Dmall.FormUtil.submit('/front/customer/board-list', param);
         location.href= "/front/customer/board-list?bbsId="+bbsId;
     }
</script>
<!-- snb -->
<div id="customer_snb">
	<div class="customer_snb_top">
		<a href="/front/customer/customer-main">고객센터</a>
	</div>
	<div class="customer_snb_area">
		<ul class="customer_snb_menu">
			<li>
				<a href="javascript:move_page('faq');">자주묻는 질문</a>
				<ul class="customer_snb_smenu">
					<c:forEach var="faqcodeListModel" items="${faqcodeListModel}" varStatus="status">
						<li><a href="javascript:selectFaqList('${faqcodeListModel.dtlCd}');" id="faq_${faqcodeListModel.dtlCd}" >${faqcodeListModel.dtlNm}</a></li>
					</c:forEach>
				</ul>
			</li>
			<li>
				<a href="javascript:move_page('inquiry');" class="active">1:1 문의</a>
				<ul class="customer_snb_smenu">
					<li><a href="javascript:moveInquiryInsert();" <c:if test="${leftMenu2 eq 'inquiry'}" >class="active"</c:if>>문의하기</a></li>
					<li><a href="javascript:moveInquiryList();">나의 문의내역</a></li>
				</ul>
			</li>
			<c:forEach var="menuList" items="${leftMenu.resultList}" varStatus="status">
				<c:if test="${menuList.bbsId ne 'faq' and menuList.bbsId ne 'inquiry' and menuList.bbsId ne 'notice'}">
				<li><a href="javascript:goCustomer('${menuList.bbsId}')" <c:if test="${fn:contains(bbsId,menuList.bbsId)}"> class='selected'</c:if>>${menuList.bbsNm}</a></li>
				</c:if>
			</c:forEach>
			<li>
				<a href="javascript:move_page('notice');">공지사항</a>
			</li>
			<li>
				<a href="/front/customer/store-list" >매장찾기</a>
			</li>
		</ul>
	</div>
</div>
<!--// snb -->