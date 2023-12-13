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
	<t:putAttribute name="title">다비치마켓 :: 게시글 상세</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            //코멘트 등록
            $('.btn_free_comment').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                if($('#free_comment_write').val() == '') {
                    Dmall.LayerUtil.alert('댓글 내용을 입력해 주십시요.');
                    return false;
                }

                var loginYn = ${user.login};
                if(!loginYn) {
                	Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                     //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                     function() {
                		var returnUrl = window.location.pathname+window.location.search;
                        location.href= "/front/login/member-login?returnUrl="+encodeURIComponent(returnUrl);
                     },'');
                    return false;
                }

                if(Dmall.validate.isValid('form_id_cmn')) {

                    var url = '/front/customer/lettter-comment-insert';
                    var param = $('#form_id_cmn').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_id_cmn');
                        if(result.success){
                            var param = {bbsId : "${so.bbsId}", lettNo : "${so.lettNo}", pw : "${resultModel.data.pw}"}
                            Dmall.FormUtil.submit('/front/customer/letter-detail', param);
                        }
                    });
                }
            });

            //코멘트 삭제
            $('.reply_del').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                var cmntSeq = $(this).attr("cmntSeq");

                if(Dmall.validate.isValid('form_id_cmn')) {
                    Dmall.LayerUtil.confirm("삭제하시겠습니까?",
                            function() {
                                var url = '/front/customer/letter-comment-delete';
                                var param = {bbsId : "${so.bbsId}", lettNo : "${so.lettNo}", cmntSeq : cmntSeq, pw : "${result.data.pw}"}

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_cmn');
                                    if(result.success){
                                        var param = {bbsId : "${so.bbsId}", lettNo : "${so.lettNo}"}
                                        Dmall.FormUtil.submit('/front/customer/letter-detail', param);
                                    }
                                });
                    })
                }
            });

            //답변 쓰기
            $('.btn_free_reply').on('click', function() {
                var writeReplyUseYn = '${bbsInfo.data.writeReplyUseYn}';
                if(writeReplyUseYn == 'Y') {
                    var loginYn = ${user.login};
                    if(!loginYn) {
                        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
	                        //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
	                        function() {
	                            var returnUrl = window.location.pathname+window.location.search;
	                            location.href= "/front/login/member-login?returnUrl="+encodeURIComponent(returnUrl);
	                        },'');
                        return false;
                    }
                    var param = {bbsId : "${so.bbsId}",grpNo : "${resultModel.data.grpNo}"
                            , lvl : "${resultModel.data.lvl}", lettLvl : "${resultModel.data.lettLvl}"
                            , lettNo:"${resultModel.data.lettNo}"};
                    Dmall.FormUtil.submit('/front/customer/letter-insert-form', param);
                } else {
                    Dmall.LayerUtil.alert("답변쓰기 권한이 없습니다.");
                    return false;
                }
            });

            //수정 화면
            $('.btn_free_modify').on('click', function(e) {
                goCheckLettPwYn('${so.lettNo}','update');
            });

            //삭제
            $('.btn_free_del').on('click', function(e) {
                goCheckLettPwYn('${so.lettNo}','delete')
            });

            //목록
            $('.btn_free_list').on('click', function() {
                location.href = '/front/customer/board-list?bbsId=${so.bbsId}';
            });

            //코멘트 더보기
            $('.btn_view_comment').on('click', function() {
                $(".free_comment_view").show();
                $(".btn_view_comment").hide();
            });

            //글자수(byte) 체크
            $(function(){
                function updateInputCount() {
                    var text =$('textarea').val();
                    var byteTxt = "";
                    var byte = function(str){
                        var byteNum=0;
                        for(i=0;i<str.length;i++){
                            byteNum+=(str.charCodeAt(i)>127)?2:1;
                            if(byteNum<600){
                                byteTxt+=str.charAt(i);
                            };
                        };
                        return byteNum;
                    };
                    $('#inputCnt').text(byte(text));
                }

                if($('#free_comment_write').length > 0) {
                    $('textarea')
                        .focus(updateInputCount)
                        .blur(updateInputCount)
                        .keypress(updateInputCount);
                        window.setInterval(updateInputCount,100);
                        updateInputCount();
                }
            })

            //비밀번호 확인 후 처리
            $('.btn_alert_ok').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                var actionNm = $('#actionNm').val()

                if(Dmall.validate.isValid('form_id_cmn')) {

                    var pw = $('#password_check').val();
                    var chkLettNo = $('#chkLettNo').val();
                    var url = '/front/customer/check-letter-password';
                    var param = {bbsId : "${so.bbsId}", lettNo : chkLettNo, pw : pw}

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result){
                            switch(actionNm) {
                                case 'view' :
                                    param = {bbsId : "${so.bbsId}", lettNo : chkLettNo, pw : pw}
                                    Dmall.FormUtil.submit('/front/customer/letter-detail', param);
                                    break;
                                case 'update' :
                                    param = {bbsId : "${so.bbsId}",lettNo : "${so.lettNo}"}
                                    Dmall.FormUtil.submit('/front/customer/letter-update-form', param);
                                    break;
                                case 'delete' :
                                    Dmall.LayerUtil.confirm("삭제 하시겠습니까?",
                                        function() {
                                            var url = '/front/customer/letter-delete';
                                            var param = {bbsId:"${so.bbsId}", lettNo:"${so.lettNo}"};

                                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                                if(result.success){
                                                    var param = {bbsId : "${so.bbsId}"}
                                                    Dmall.FormUtil.submit('/front/customer/board-list', param);
                                            }
                                        });
                                    })
                                    break;
                            }
                        } else {
                            Dmall.LayerUtil.alert('비밀번호가 일치하지 않습니다.','','');
                            Dmall.LayerPopupUtil.close('div_id_pw_popup');
                            $('#password_check').val('');
                        }
                    });
                }
            });

            // 비밀번호 입력 팝업창 닫기
            $('.btn_alert_close').on('click', function() {
                Dmall.LayerPopupUtil.close('div_id_pw_popup');
            });

            // 비밀번호 입력 팝업창 닫기
            $('.btn_alert_cancel').on('click', function() {
                Dmall.LayerPopupUtil.close('div_id_pw_popup');
            });
        });

        //글 비밀번호 여부 확인
        function goCheckLettPwYn(lettNo,actionNm) {
            $('#actionNm').val(actionNm);
            var url = '/front/customer/check-password-use';
            var param = {bbsId : "${so.bbsId}", lettNo : lettNo}

            var resultCheck = false;
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result){
                    $('#chkLettNo').val(lettNo);
                    Dmall.LayerPopupUtil.open(($('#div_id_pw_popup')));
                } else {
                    switch(actionNm) {
                        case 'view':
                            var param = {bbsId : "${so.bbsId}", lettNo : lettNo}
                            Dmall.FormUtil.submit('/front/customer/letter-detail', param);
                            break;
                        case 'update':
                            var param = {bbsId : "${so.bbsId}",lettNo : "${so.lettNo}"}
                            Dmall.FormUtil.submit('/front/customer/letter-update-form', param);
                            break;
                        case 'delete':
                            Dmall.LayerUtil.confirm("삭제 하시겠습니까?",
                                function() {
                                    var url = '/front/customer/letter-delete';
                                    var param = {bbsId:"${so.bbsId}", lettNo:"${so.lettNo}"};

                                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                        if(result.success){
                                            var param = {bbsId : "${so.bbsId}"}
                                            Dmall.FormUtil.submit('/front/customer/board-list', param);
                                    }
                                });
                            })
                            break;
                    }
                }
            });
        }

      //글 상세 보기
        function goCheckBbsDtl(lettNo) {
            goCheckLettPwYn(lettNo,'view');
        }

        //파일 다운로드
        function fileDownload(fileNo){
            Dmall.FileDownload.download("BBS", fileNo)
            return false;
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
                    <c:if test="${bbsInfo.data.topHtmlYn eq 'Y'}">
                    <div class="bbs_banner_top">${bbsInfo.data.topHtmlSet}</div><!-- 배너영역 -->
                    </c:if>
                    <h3 class="community_con_tit">
                        ${bbsInfo.data.bbsNm}
                        <!-- <c:choose>
                            <c:when test="${fn:contains(bbsInfo.data.bbsId,'freeBbs')}" >
                                <span>자유롭게 게시글 작성 및 활용할 수 있는 게시판입니다.</span>
                            </c:when>
                            <c:when test="${fn:contains(bbsInfo.data.bbsId,'gallery')}" >
                                <span>이미지를 활용하여 게시글을 작성할 수 있는 게시판입니다.</span>
                            </c:when>
                            <c:when test="${fn:contains(bbsInfo.data.bbsId,'data')}" >
                                <span>많은 자료 및 이미지를 등록할 수 있는 게시판입니다.</span>
                            </c:when>
                        </c:choose> -->
                    </h3>

                    <table class="tFree_View">
                        <caption>
                            <h1 class="blind">자유게시판 상세보기 테이블 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:130px">
                            <col style="width:">
                            <col style="width:130px">
                            <col style="width:114px">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th colspan="4" class="textL">
                                	<c:if test="${resultModel.data.grpNo eq resultModel.data.lettNo}">
                            			<c:if test="${bbsInfo.data.bbsKindCd eq 1}">
                                			<c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                                    			<span class="bbs_keyword">${resultModel.data.titleNm}</span>
			                                </c:if>
			                            </c:if>
			                        </c:if>
			                        <c:if test="${resultModel.data.lvl > 0 }">
                                        <img src='../img/community/icon_free_reply.png' alt='답변' style='vertical-align:middle'>
                                    </c:if>
                                	${resultModel.data.title}
                                </th>
                            </tr>
                            <tr>
                                <th>작성자</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${resultModel.data.regrDispCd eq '01' }">
                                        ${StringUtil.maskingName(resultModel.data.memberNm)}
                                        </c:when>
                                        <c:otherwise>
                                        ${StringUtil.maskingName(resultModel.data.loginId)}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <th>게시일</th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${resultModel.data.regDttm}" /></td>
                            </tr>
                            <tr>
                                <td class="view bbs_file" colspan="4">
                                    ${resultModel.data.content}
                                </td>
                            </tr>
                            <c:if test="${fn:length(resultModel.data.atchFileArr) gt 0 }">
                                <c:forEach var="fileList" items="${resultModel.data.atchFileArr}" varStatus="status">
                                    <c:if test="${fileList.imgYn ne 'Y' }">
                                        <c:set var="fileYn" value="Y"/>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fileYn eq 'Y' }">
                                <tr>
                                    <th>첨부파일</th>
                                    <td colspan="3" class="lnh_file">
                                        <ul>
                                        <c:forEach var="fileList" items="${resultModel.data.atchFileArr}" varStatus="status">
                                            <c:if test="${fileList.imgYn ne 'Y' }">
                                            <li><a href="#none" onclick= "return fileDownload('${fileList.fileNo}')">- ${fileList.orgFileNm}</a></li>
                                            </c:if>
                                        </c:forEach>
                                        </ul>
                                    </td>
                                </tr>
                                </c:if>
                            </c:if>
                            <c:if test="${bbsInfo.data.writeCommentUseYn eq 'Y'}">
                            <tr>
                                <td colspan="4" class="free_con">
                                    <!--- 자유게시판 comment 쓰기 --->
                                    <div class="free_comment_write">
                                        <form:form id="form_id_cmn" commandName="so">
                                        <form:hidden path="bbsId" id="bbsId" />
                                        <form:hidden path="lettNo" id="lettNo" />
                                        <div class="free_comment_warning">* 주제와 무관한 댓글, 악플은 삭제될 수 있습니다.</div>
                                        <div class="free_comment_form">
                                            <label for="free_comment_write"><span id="inputCnt">0</span>/300</label>
                                            <textarea id="free_comment_write" name="content"></textarea>
                                            <button type="button" class="btn_free_comment">등록</button>
                                        </div>
                                        <div class="free_comment_list">
                                            <c:if test="${null ne commentList.resultList}">
                                                <c:forEach var="commentList" items="${commentList.resultList}" varStatus="status">
                                                    <!--- comment 보기01 --->
                                                    <div class="free_comment_view">
                                                        <div class="free_comment_id">${StringUtil.maskingName(commentList.memberNm)}</div>
                                                        <div class="comment_info_date"><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${commentList.regDttm}" /></div>
                                                        <div class="free_comment_info">
                                                        	<div class="free_comment_text">${commentList.content}</div>
                                                            <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq commentList.regrNo || user.session.authGbCd eq 'A')}">
                                                            <button type="button" class="reply_del" cmntSeq="${commentList.cmntSeq}"><img src="../img/product/btn_reply_del.gif" alt="댓글삭제"></button>
                                                            </c:if>
                                                        </div> 
                                                    </div>
                                                    <!---// comment 보기01 --->
                                                </c:forEach>
                                            </c:if>
                                            <!-- <div class="view_more_comment">
                                                <c:if test="${commentList.totalRows > 2 }">
                                                <button type="button" class="btn_view_comment">더보기</button>
                                                </c:if>
                                            </div> -->
                                        </div>
                                        </form:form>
                                    </div>
                                    <!---// comment 쓰기 --->
                                </td>
                            </tr>
                            </c:if>
                        </tbody>
                        <tfoot>
                            <c:if test="${preBbs.data ne null}">
                            <tr>
                                <td colspan="4">
									<span class="tit_prev">이전글</span>
                                    <c:choose>
                                        <c:when test="${preBbs.data.sectYn eq 'Y'}">
                                            <c:set var="preTitle" value="<img src='../img/community/icon_free_lock.png'alt='비밀글' style='vertical-align:middle'> ${preBbs.data.title}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="preTitle" value="${preBbs.data.title}"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="javascript:goCheckBbsDtl('${preBbs.data.lettNo}')">${preTitle}</a>
                                </td>
                            </tr>
                            </c:if>
                            <c:if test="${nextBbs.data ne null}">
                            <tr>
                                <td colspan="4">
									<span class="tit_next">다음글</span>
                                    <c:choose>
                                        <c:when test="${nextBbs.data.sectYn eq 'Y'}">
                                            <c:set var="nextTitle" value="<img src='../img/community/icon_free_lock.png'alt='비밀글' style='vertical-align:middle'> ${nextBbs.data.title}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="nextTitle" value="${nextBbs.data.title}"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="javascript:goCheckBbsDtl('${nextBbs.data.lettNo}')">${nextTitle}</a>
                                </td>
                            </tr>
                            </c:if>
                        </tfoot>
                    </table>

                    <div class="btn_free_area floatC">
                        <div class="floatL">
                            <button type="button" class="btn_free_list">목록</button>
                        </div>
                        <div class="floatR">
                        <c:if test="${bbsInfo.data.bbsKindCd eq 1 && bbsInfo.data.writeReplyUseYn eq 'Y'}">
                            <c:if test="${resultModel.data.noticeYn ne 'Y' }">
                                <c:if test="${resultModel.data.lvl eq '0' }">
                                    <button type="button" class="btn_free_reply">답변</button>
                                </c:if>
                            </c:if>
                        </c:if>
                        <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.data.regrNo || user.session.authGbCd eq 'A')}">
                            <button type="button" class="btn_free_modify">수정</button>
                            <button type="button" class="btn_free_del">삭제</button>
                        </c:if>
                        </div>
                    </div>
                    <c:if test="${bbsInfo.data.bottomHtmlYn eq 'Y'}">
                    <div class="bbs_banner_bottom">${bbsInfo.data.bottomHtmlSet}</div><!-- 배너영역 -->
                    </c:if>
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
                    <input type="hidden" id="actionNm" name="actionNm">
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