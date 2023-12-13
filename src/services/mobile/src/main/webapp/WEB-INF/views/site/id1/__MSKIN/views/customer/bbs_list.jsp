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
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">${bbsInfo.data.bbsNm}</t:putAttribute>
	
	
	
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
	    <script type="text/javascript">
        $(document).ready(function(){
            var searchKind = '${so.searchKind}';
            if(searchKind !='') {
                $("#searchKind").val(searchKind);
                $("#searchKind").trigger("change");
            }

            //검색
            $('#btn_id_search').on('click', function() {
                var data = $('#form_id_search').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('${_MOBILE_PATH}/front/customer/board-list?bbsId=${so.bbsId}', param);
            });

            //글쓰기
            $('.btn_free_write').on('click', function() {
            	var writeLettUseYn = '${bbsInfo.data.writeLettUseYn}';
                if(writeLettUseYn == 'Y') {
	                var loginYn = ${user.login};
	                if(!loginYn) {
	                	Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
	                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
	                            function() {
	                				var returnUrl = window.location.pathname+window.location.search;
	                                location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login?returnUrl="+encodeURIComponent(returnUrl);
	                            },'');
	                	return false;
	                }
	                location.href="${_MOBILE_PATH}/front/customer/letter-insert-form?bbsId=${so.bbsId}";
                } else {
                    Dmall.LayerUtil.alert("글쓰기 권한이 없습니다.");
                    return false;
                }
            });

            //비밀번호 확인 후 게시글 이동
            $('.btn_alert_ok').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                //if(validate.isValid('form_id_cmn')) {

                    var pw = $('#password_check').val();
                    var chkLettNo = $('#chkLettNo').val();
                    var url = '${_MOBILE_PATH}/front/customer/check-letter-password';
                    var param = {bbsId : "${so.bbsId}", lettNo : chkLettNo, pw : pw}

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        //validate.viewExceptionMessage(result, 'form_id_cmntinsert');
                        if(result){
                            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/customer/letter-detail', param);
                        } else {
                            Dmall.LayerUtil.alert('비밀번호가 일치하지 않습니다.','','');
                            Dmall.LayerPopupUtil.close('div_id_pw_popup');
                            $('#password_check').val('');
                        }
                    });
                //}
            });

            // 비밀번호 입력 팝업창 닫기
            $('.btn_alert_close').on('click', function() {
                Dmall.LayerPopupUtil.close('div_id_pw_popup');
            });

            // 비밀번호 입력 팝업창 닫기
            $('.btn_alert_cancel').on('click', function() {
                Dmall.LayerPopupUtil.close('div_id_pw_popup');
            });

            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

            $('.more_view').on('click', function() {
	        	var pageIndex = Number($('#page').val())+1;
	        	$("#page").val(pageIndex);
	        	var param = $('#form_id_search').serialize();
	     		var url = '${_MOBILE_PATH}/front/customer/bbs-list-ajax';
	     		Dmall.AjaxUtil.loadByPost(url, param, function(result) {

    		    	if('${resultListModel.totalPages}' == pageIndex){
    		        	$('#div_id_paging').hide();
    		        }
    		        $('.bbs_list').append(result);
    	        })
	         });

        });

        //글 상세 보기
        function goCheckBbsDtl(lettNo) {
            var url = '${_MOBILE_PATH}/front/customer/check-password-use';
            var param = {bbsId : "${so.bbsId}", lettNo : lettNo}

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result){
                    $('#chkLettNo').val(lettNo);
                    $('#password_check').val("");
                    Dmall.LayerPopupUtil.open(($('#div_id_pw_popup')));
                } else {
                    location.href = '${_MOBILE_PATH}/front/customer/letter-detail?bbsId=${so.bbsId}&lettNo='+lettNo;
                }
            });
        }
        </script>
	</t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
        <div class="contents">
            <!--- category header 카테고리 location과 동일 --->
            <div class="product_head">
				<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
				${bbsInfo.data.bbsNm}
			</div>
            <!---// category header --->
            <div class="community">
                <!--- 커뮤니티 컨텐츠 --->
                <div class="community_content">
                    <c:if test="${bbsInfo.data.topHtmlYn eq 'Y'}">
                    <div class="bbs_banner_top">${bbsInfo.data.topHtmlSet}</div><!-- 배너영역 -->
                    </c:if>
                    <form:form id="form_id_search" commandName="so">
                        <form:hidden path="page" id="page" />
                        <form:hidden path="rows" id="rows" />
                        <form:hidden path="bbsId" id="bbsId" />
                        <!-- <h3 class="community_con_tit">
                            ${bbsInfo.data.bbsNm}
                            <c:choose>
                                <c:when test="${fn:contains(bbsInfo.data.bbsKindCd,'1')}" >
                                    <span>자유롭게 게시글을 작성하고 활용하세요!</span>
                                </c:when>
                                <c:when test="${fn:contains(bbsInfo.data.bbsKindCd,'2')}" >
                                    <span>이미지를 활용하여 게시글을 작성하세요!</span>
                                </c:when>
                                <c:when test="${fn:contains(bbsInfo.data.bbsKindCd,'3')}" >
                                    <span>다양한 자료 및 이미지를 등록하세요!</span>
                                </c:when>
                            </c:choose>
                        </h3> -->
                        <div class="table_top notice">
							<select id="searchKind" title="select option" name="searchKind" >
								<option value="all">전체</option>
								<option value="searchBbsLettTitle">제목</option>
								<option value="searchBbsLettContent">내용</option>
							</select>
							<input type="text" name="searchVal" id="searchVal" value="${so.searchVal}"><button type="button" id="btn_id_search"></button>
                        </div>

                        <table class="tFree_Board">
                            <caption>
                                <h1 class="blind">게시판 목록 입니다.</h1>
                            </caption>
							<colgroup>
								<col style="width:*">
								<col style="width:130px">
							</colgroup>
                            <!-- <colgroup>
                                <!--col style="width:10%"->
                                <c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                                <col style="">
                                </c:if>
                                <col style="width:90px">
                            </colgroup> -->
                            <!-- <thead>
                                <tr>
                                    <!--th>번호</th>
									<th>
										<c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
										말머리 <span class="bar">/</span>
										</c:if>
										제목
									</th>
                                    <th class="font12">작성자<br>게시일</th>
									<th class="font12">조회수</th>
                                </tr>
                            </thead> -->
                            <tbody class="bbs_list">
                            <c:choose>
                                <c:when test="${null ne resultListModel.resultList}">
                                    <c:forEach var="bbsList" items="${resultListModel.resultList}" varStatus="status">
                                        <c:set var="lvl" value="0"/>
                                        <%-- 비밀글 --%>
                                        <c:choose>
                                            <c:when test="${bbsList.sectYn eq 'Y'}">
                                                <c:set var="title" value="<img src='../img/mypage/icon_free_lock.png' alt='비밀글' style='vertical-align:middle'>  ${bbsList.title}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="title" value="${bbsList.title}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:choose>
                                            <%-- 공지 --%>
                                            <c:when test="${bbsList.noticeYn eq 'Y'}">
                                                <c:set var="bbsNum" value="<span class='label_red'>공지</span>"/>
                                                <c:set var="bbsTitle" value="${title}"/>
                                            </c:when>
                                            <%-- 답변 --%>
                                            <c:when test="${bbsList.lvl > 0 }">
                                                <c:set var="bbsNum" value="${bbsList.rowNum}"/>
                                                <c:set var="bbsTitle" value="<img src='../img/mypage/icon_reply.gif' alt='답변' style='vertical-align:middle'>  ${title}"/>
                                                <c:set var="lvl" value="${(bbsList.lvl-2)*15}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="bbsNum" value="${bbsList.rowNum}"/>
                                                <c:set var="bbsTitle" value="${title}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${bbsList.lvl > 1 }">
                                            <c:set var="lvl" value="${(bbsList.lvl)*10}"/>
                                        </c:if>
                                        <tr>											
                                            <td>
                                            <!--td class="textC">${bbsNum}</td-->												
												<c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
													<c:if test="${bbsList.lvl eq '0'}">
	                                                    <span class="label_keyword"> ${bbsList.titleNm}</span>
	                                                </c:if> 
												</c:if>												
                                                <div class="ellipsis">
                                                    <a href="javascript:goCheckBbsDtl('${bbsList.lettNo}')">
                                                        <span style="padding-left:${lvl}px">
                                                            ${bbsTitle}
                                                            <c:if test="${bbsList.iconCheckValueNew eq 'Y'}">
                                                                <i class='bbs_icon_new'>NEW</i>
                                                            </c:if>
                                                            <c:if test="${bbsList.iconCheckValueHot eq 'Y'}">
                                                                <i class='bbs_icon_hot'>HOT</i>
                                                            </c:if>
                                                        </span>
                                                        <c:if test="${bbsList.cmntCnt > 0 }">(${bbsList.cmntCnt })</c:if>
                                                    </a>
                                                </div>
                                            </td>
                                           <td class="bbs_date">
                                           		<c:choose>
	                                           		<c:when test="${bbsList.regrDispCd eq '01' }">
	                                                	${StringUtil.maskingName(bbsList.memberNm)}
	                                                </c:when>
	                                                <c:otherwise>
	                                                	${StringUtil.maskingName(bbsList.loginId)}
	                                                </c:otherwise> 
												</c:choose>
                                           		&nbsp; (<fmt:formatDate pattern="yyyy-MM-dd" value="${bbsList.regDttm}" /> )
											</td>
											<!--<td class="font12 textC">
												${bbsList.inqCnt}
											</td> -->
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                    <c:choose>
                                        <c:when test="${bbsInfo.data.titleUseYn eq 'Y'}">
                                        <td class="textC" colspan="3">등록된 게시물이 없습니다.</td>
                                        </c:when>
                                        <c:otherwise>
                                        <td class="textC" colspan="3">등록된 게시물이 없습니다.</td>
                                        </c:otherwise>
                                    </c:choose>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>

                        <!---- 페이징 ---->
                        <div class="tPages" id="div_id_paging">
                            <grid:paging resultListModel="${resultListModel}" />
                        </div>
                        <!----// 페이징 ---->
                        <c:if test="${bbsInfo.data.writeLettUseYn eq 'Y'}">
                        <div class="community_btn_area">
                            <button type="button" class="btn_free_write">글쓰기</button>
                        </div>
                        </c:if>
                    </form:form>
                    <c:if test="${bbsInfo.data.bottomHtmlYn eq 'Y'}">
                    <div class="bbs_banner_bottom">${bbsInfo.data.bottomHtmlSet}</div><!-- 배너영역 -->
                    </c:if>
                </div>
                <!---// 커뮤니티 컨텐츠 --->
            </div>
        </div>
        <!---// contents--->
        <!--- popup 비밀번호 입력창 --->
        <div id="div_id_pw_popup" class="alert_body" style="background: #ffffff;display:none;">
            <button type="button" class="btn_alert_close"><img src="../img/common/btn_close_popup02.png" alt="팝업창닫기"></button>
            <div class="alert_content">
                <div class="alert_text" style="padding:28px 0 12px">
                    비밀번호를 입력해주세요.<br>
                    <input type="password" id="password_check" name="password_check" style="margin-top:3px">
                    <input type="hidden" id="chkLettNo" name="chkLettNo">
                </div>
                <div class="alert_btn_area">
                    <button type="button" class="btn_alert_ok">확인</button>
                    <button type="button" class="btn_alert_cancel">취소</button>
                </div>
            </div>
        </div>
        <!---// popup 비밀번호 입력창 --->
    </t:putAttribute>
</t:insertDefinition>