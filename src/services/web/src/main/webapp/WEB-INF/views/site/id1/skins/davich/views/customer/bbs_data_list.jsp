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
	<t:putAttribute name="title">다비치마켓 :: ${bbsInfo.data.bbsNm}</t:putAttribute>


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
                Dmall.FormUtil.submit('/front/customer/board-list', param);
            });

            //글쓰기
            $('.btn_free_write').on('click', function() {
                var writeLettUseYn = '${bbsInfo.data.writeLettUseYn}';
                if(writeLettUseYn == 'Y') {
                    var loginYn = ${user.login};
                    if(!loginYn) {
                        Dmall.LayerUtil.alert("로그인이 필요한 서비스 입니다..","","").done(function(){
                           //location.href = "/front/login/member-login";
                        });
                        return;
                    }
                    location.href="/front/customer/letter-insert-form?bbsId=${so.bbsId}";
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
                    var url = '/front/customer/check-letter-password';
                    var param = {bbsId : "${so.bbsId}", lettNo : chkLettNo, pw : pw}

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        //validate.viewExceptionMessage(result, 'form_id_cmntinsert');
                        if(result){
                            Dmall.FormUtil.submit('/front/customer/letter-detail', param);
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
        });

        //글 상세 보기
        function goCheckBbsDtl(lettNo) {
            var readLettContentUseYn = '${bbsInfo.data.readLettContentUseYn}';
            if(readLettContentUseYn == "Y") {
                var url = '/front/customer/check-password-use';
                var param = {bbsId : "${so.bbsId}", lettNo : lettNo}

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result){
                        $('#chkLettNo').val(lettNo);
                        $('#password_check').val("");
                        Dmall.LayerPopupUtil.open(($('#div_id_pw_popup')));
                    } else {
                        var param = {bbsId : "${so.bbsId}", lettNo : lettNo}
                        Dmall.FormUtil.submit('/front/customer/letter-detail', param);
                    }
                });
            } else {
                Dmall.LayerUtil.alert("글 내용 조회 권한이 없습니다.");
                return false;
            }
        }

        </script>
	</t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
        <div class="contents fixwid">
            <!--- category header 카테고리 location과 동일 --->
            <div id="category_header">
                <div id="category_location">
					<ul class="category_menu">
						<li><a href="/front/main-view">홈</a></li>
						<li>고객센터</li>
						<li>${bbsInfo.data.bbsNm}</li>
					</ul>
						<!-- <span class="location_bar"></span><a href="/">홈</a><span></span><a>고객센터</a><span></span>${bbsInfo.data.bbsNm} -->
				</div>
            </div>
            <!---// category header --->
            <!-- <h2 class="sub_title">커뮤니티<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2> -->
            <div class="community">
                <!--- 커뮤니티 왼쪽 메뉴 --->
                <%@ include file="include/customer_left_menu.jsp" %>
                <!---// 커뮤니티 왼쪽 메뉴 --->
                <!--- 커뮤니티 오른쪽 컨텐츠 --->
                <div class="community_content">
                <c:choose>
                    <c:when test="${bbsInfo.data.readListUseYn eq 'Y' }">
                        <c:if test="${bbsInfo.data.topHtmlYn eq 'Y'}">
                        <div class="bbs_banner_top">${bbsInfo.data.topHtmlSet}</div><!-- 배너영역 -->
                        </c:if>
                        <form:form id="form_id_search" commandName="so">
                            <form:hidden path="bbsId" id="bbsId" />
                            <form:hidden path="page" id="page" />
                            <h3 class="community_con_tit">
                                ${bbsInfo.data.bbsNm}
                                <!-- <c:choose>
                                    <c:when test="${fn:contains(bbsInfo.data.bbsKindCd,'1')}" >
                                        <span>자유롭게 게시글 작성 및 활용할 수 있는 게시판입니다.</span>
                                    </c:when>
                                    <c:when test="${fn:contains(bbsInfo.data.bbsKindCd,'2')}" >
                                        <span>이미지를 활용하여 게시글을 작성할 수 있는 게시판입니다.</span>
                                    </c:when>
                                    <c:when test="${fn:contains(bbsInfo.data.bbsKindCd,'3')}" >
                                        <span>많은 자료 및 이미지를 등록할 수 있는 게시판입니다.</span>
                                    </c:when>
                                </c:choose> -->
                            </h3>
                            <div class="table_top">
                                <div class="select_box28" style="width:100px;display:inline-block">
                                    <label for="searchKind">전체</label>
                                    <select class="select_option" id="searchKind" title="select option" name="searchKind" >
                                        <option value="all">전체</option>
                                        <option value="searchBbsLettTitle">제목</option>
                                        <option value="searchBbsLettContent">내용</option>
                                    </select>
                                </div>
                                <input type="text" name="searchVal" id="searchVal" value="${so.searchVal}"><button type="button" id="btn_id_search"></button>
                            </div>

                            <table class="tDownload_Board">
                                <caption>
                                    <h1 class="blind">자료실 게시판 목록 입니다.</h1>
                                </caption>
                                <colgroup>
                                    <col style="width:70px">
                                    <col style="width:100px">
                                    <col style="width:*">
                                    <col style="width:100px">
                                    <col style="width:120px">
                                    <col style="width:80px">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th></th>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>게시일</th>
                                        <th>조회수</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${null ne resultListModel.resultList}">
                                        <c:forEach var="bbsList" items="${resultListModel.resultList}" varStatus="status">
                                            <c:set var="lvl" value="0"/>
                                            <%-- 비밀글 --%>
                                            <c:choose>
                                                <c:when test="${bbsList.sectYn eq 'Y'}">
                                                    <c:set var="title" value="<img src='../img/community/icon_free_lock.png'alt='비밀글' style='vertical-align:middle'> ${bbsList.title}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="title" value="${bbsList.title}"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <%-- 리스트 이미지 --%>
                                            <c:choose>
                                                <c:when test="${bbsList.imgFilePath ne null}">
                                                    <c:set var="bbsImg" value="<img src='${_IMAGE_DOMAIN}/image/image-view?type=BBS&path=${bbsList.imgFilePath}&id1=${bbsList.imgFileNm}'  width='65px' height='65px' alt=''>"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="bbsImg" value="<img src='../img/community/download_img01.gif' alt=''>"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:set var="bbsTitle" value="${title}"/>
                                            <tr>
                                                <td class="textC">${bbsList.rowNum}</td>
                                                <td class="textC pix_img">
                                                    ${bbsImg}
                                                </td>
                                                <td>
                                                    <div class="ellipsis" style="width:310px">
                                                        <a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}')">
                                                            <span style="padding-left:${lvl}px">
                                                                ${bbsTitle}
                                                                <c:if test="${bbsList.iconCheckValueNew eq 'Y'}">
                                                                    <i class='bbs_icon_new'>NEW</i>
                                                                </c:if>
                                                                <c:if test="${bbsList.iconCheckValueHot eq 'Y'}">
                                                                    <i class='bbs_icon_hot'>HOT</i>
                                                                </c:if>
                                                            </span>
                                                        </a>
                                                    </div>
                                                </td>
                                                <td class="textC">
                                                    <c:choose>
                                                        <c:when test="${bbsList.regrDispCd eq '01' }">
                                                        ${bbsList.memberNm}
                                                        </c:when>
                                                        <c:otherwise>
                                                        ${bbsList.loginId}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="textC"><fmt:formatDate pattern="yyyy-MM-dd" value="${bbsList.regDttm}" /></td>
                                                <td class="textC">${bbsList.inqCnt}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td class="textC" colspan="6">등록된 게시물이 없습니다.</td>
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
                            <div class="community_btn_area">
                                <button type="button" class="btn_free_write">글쓰기</button>
                            </div>
                        </form:form>
                        <c:if test="${bbsInfo.data.bottomHtmlYn eq 'Y'}">
                        <div class="bbs_banner_bottom">${bbsInfo.data.bottomHtmlSet}</div><!-- 배너영역 -->
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align:center;font-size:20px;padding:50px 0 50px 0;">
                        일반회원은 접근이 불가능한 게시판입니다.<br><br>
                        관리자에게 문의하시기 바랍니다.<br><br>
                        감사합니다.<br><br>
                        </p>
                    </c:otherwise>
                    </c:choose>
                </div>
                <!---// 커뮤니티 오른쪽 컨텐츠 --->
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