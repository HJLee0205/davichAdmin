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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">상품후기</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        $( ".datepicker" ).datepicker();
        //검색
        $('.btn_date').on('click', function() {
            if($("#event_start").val() == '' || $("#event_end").val() == '') {
                Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                return;
            }
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('/front/review/review-list', param);
        });
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        /*상품평 수정*/
        $('.btn_review_ok').on('click', function() {
            var url = '/front/review/review-update';
            if (Dmall.FileUpload.checkFileSize('form_id_update')) {
                $('#form_id_update').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        Dmall.validate.viewExceptionMessage(result, 'form_id_update');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('popup_review_write');   //수정후 레이어팝업 닫기
                            Dmall.LayerUtil.alert(result.message).done(function(){
                                location.reload();
                            });
                        } else {
                            Dmall.LayerUtil.alert(result.message);
                        }
                    }
                });
            }
        });

        /* 상품평수정 팝업 닫기*/
        $('.btn_review_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_review_write');
        });

        //이미지파일 변경
        $('#input_id_image').on('change', function(e) {
            if($("#imgOldYn").val()=="Y"){
                $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                $("#filename").val("");
                Dmall.LayerUtil.alert("등록된 이미지 파일을 먼저 삭제하여 주세요.");
            }else{

                var files = e.originalEvent.target.files;
                var totalFileSize=0;
                for (var i = 0; i < files.length; i++){
                    totalFileSize = totalFileSize + files[i].size;
                }
                if(totalFileSize>1048576){
                    Dmall.LayerUtil.alert('이미지 파일은 최대 1Mbyte까지 등록 가능합니다.');
                    $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                    $("#filename").val("");
                    return;
                }

                var ext = jQuery(this).val().split('.').pop().toLowerCase();
                if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
                    Dmall.LayerUtil.alert('gif,png,jpg,jpeg 파일만 업로드 할수 있습니다.');
                    $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                    $("#filename").val("");
                    return;
                }
                $("#imgYn").val("Y");
                document.getElementById('filename').value=this.value;
            }
        });
    });

    //게시판 이미지파일 삭제
    function delOldImgFileNm(fileNo){
        var url = '/front/review/attach-file-delete';
        var param = {fileNo:fileNo,bbsId:"review"};

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            $("#span_imgFile").html("");
            $("#imgOldYn").val("");
        });
        return;
    }

    /*상품후기 상세조회*/
    function selectReview(idx){
        var url = '/front/review/review-detail',dfd = jQuery.Deferred();
        var param = {lettNo: idx};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $("#title").val(result.data.title);
                $("#content").val(result.data.content);
                $('#lettNo').val(idx);
                if(result.data.atchFileArr != null) {
                    var imgPath = "<img src='${_IMAGE_DOMAIN}/image/image-view?type=BBS&path="+result.data.atchFileArr[0].filePath+"&id1="+result.data.atchFileArr[0].fileNm+"' style='width:65px;height:65px;'>";
                    var button = "<img src='../img/product/btn_reply_del.gif' alt='삭제' style='cursor:hand' onclick='return delOldImgFileNm(\""+result.data.atchFileArr[0].fileNo+"\")'>";
                    $('#span_imgFile').html(imgPath+button);
                    $('#imgOldYn').val('Y');
                }
                $("input[name='score']:radio[value='"+result.data.score+"']").prop('checked',true);
                Dmall.LayerPopupUtil.open($('#popup_review_write'));
            }else{
                Dmall.LayerUtil.alert("데이터를 가져올수 없습니다.", "오류");
            }
        });
    };

    /*상품후기 삭제*/
    function deleteReview(idx){
        Dmall.LayerUtil.confirm('상품후기를 삭제하시겠습니까?', function() {
            var url = '/front/review/review-delete';
            var param = {'lettNo' : idx, 'bbsId':'review'};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href= "/front/review/review-list";
                 }
            });
        })
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 활동 <span>&gt;</span>상품후기
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    상품후기
                    <span class="row_info_text">고객님께서 등록하신 상품후기를 확인하실 수 있습니다.</span>
                </h3>
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <div class="date_select_area">
                    <p class="date_select_title">- 기간검색</p>
                    <button type="button" class="btn_date_select" style="border-left:1px solid #e5e5e5;">15일</button><button type="button" class="btn_date_select">1개월</button><button type="button" class="btn_date_select">3개월</button><button type="button" class="btn_date_select">6개월</button><button type="button" class="btn_date_select">1년</button>
                    <input type="text" name="fromRegDt" id="event_start" class="datepicker date" style="margin-left:8px" value="${so.fromRegDt}" readonly="readonly" onkeydown="return false"> ~ <input type="text" name="toRegDt" id="event_end" class="datepicker date" value="${so.toRegDt}" readonly="readonly" onkeydown="return false">
                    <button type="button" class="btn_date" style="margin-left:8px">조회하기</button>
                </div>

                <div class="table_top">
                    <span class="floatL" style="margin-top:15px">- 총 ${resultListModel.filterdRows}건의 상품평이 있습니다.</span>
                </div>

                <table class="tProduct_Board my_qna_table">
                    <caption>
                        <h1 class="blind">구매후기 게시판 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:48px">
                        <col style="width:68px">
                        <col style="width:140px">
                        <col style="width:100px">
                        <col style="">
                        <col style="width:120px">
                        <col style="width:100px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th colspan="2">주문상품정보</th>
                            <th>상품평가</th>
                            <th>제목</th>
                            <th>구매자</th>
                            <th>등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                            <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                            <c:choose>
                                <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
                                    <tr class="title">
                                        <td>${resultModel.rowNum}</td>
                                        <td class="pix_img">
                                            <img src="${_IMAGE_DOMAIN}${resultModel.goodsDispImgC}">
                                        </td>
                                        <td class="textL">
                                            ${resultModel.goodsNm}
                                        </td>
                                        <td>
                                            <div class="star_groups">
                                                <c:forEach begin="1" end="${resultModel.score}" ><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"></c:forEach>
                                            </div>
                                        </td>
                                        <td class="textL">
                                            ${resultModel.title}
                                        </td>
                                        <td>${resultModel.memberNm}</td>
                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                                    </tr>
                                    <tr class="hide">
                                        <td colspan="7" class="review_view">
                                            <c:if test="${resultModel.imgFilePath ne null}">
                                            <img id="imgFile" src="/image/image-view?type=BBS&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" width="100px" height="100px;">
                                            </c:if>
                                            ${resultModel.content}
                                            <div class="view_btn_area">
                                                <button type="button" class="btn_modify" onclick="selectReview('${resultModel.lettNo}');">수정</button>
                                                <button type="button" class="btn_del" onclick="deleteReview('${resultModel.lettNo}');">삭제</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr class="title">
                                        <td>${resultModel.rowNum}</td>
                                        <td>
                                            <img src="/front/img/product/icon_reply.png" alt="댓글 아이콘">
                                        </td>
                                        <td colspan="3" class="textL">
                                            <span>${resultModel.title}</span>
                                        </td>
                                        <td>${resultModel.memberNm}</td>
                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                                    </tr>
                                    <tr class="hide">
                                        <td colspan="7" class="review_view">
                                            ${resultModel.content}
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">조회된 데이터가 없습니다.</td>
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
                </form:form>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    <!--- popup 상품평쓰기 --->
    <div id="popup_review_write" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">상품평쓰기</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <form id="form_id_update" method="post">
            <input type="hidden" name="bbsId" id="bbsId" value="review"/>
            <input type="hidden" name="lettNo" id="lettNo" value=""/>
            <table class="tProduct_Insert">
                <caption>
                    <h1 class="blind">상품평가 입력 테이블입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:20%">
                    <col style="width:20%">
                    <col style="width:20%">
                    <col style="width:20%">
                    <col style="width:20%">
                </colgroup>
                <thead>
                    <tr>
                        <th colspan="5" class="star_tit">상품평가</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="star_check">
                            <input type="radio" id="star05" name="score" value="5">
                            <label for="star05">
                                <span></span>
                                <div class="star_groups" title="별점평가 별5개" style="margin-top:6px">
                                    <img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별">
                                </div>
                            </label>
                        </td>

                        <td class="star_check">
                            <input type="radio" id="star04" name="score" value="4">
                            <label for="star04">
                                <span></span>
                                <div class="star_groups" title="별점평가 별4개" style="margin-top:6px">
                                    <img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별">
                                </div>
                            </label>
                        </td>
                        <td class="star_check">
                            <input type="radio" id="star03" name="score" value="3">
                            <label for="star03">
                                <span></span>
                                <div class="star_groups" title="별점평가 별3개" style="margin-top:6px">
                                    <img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별">
                                </div>
                            </label>
                        </td>
                        <td class="star_check">
                            <input type="radio" id="star02" name="score" value="2">
                            <label for="star02">
                                <span></span>
                                <div class="star_groups" title="별점평가 별2개" style="margin-top:6px">
                                    <img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별">
                                </div>
                            </label>
                        </td>
                        <td class="star_check">
                            <input type="radio" id="star01" name="score" value="1">
                            <label for="star01">
                                <span></span>
                                <div class="star_groups" title="별점평가 별1개" style="margin-top:6px">
                                    <img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별"><img src="/front/img/product/icon_star_gray.png" alt="상품평가 별">
                                </div>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th style="vertical-align:top">제목</th>
                        <td colspan="4" class="textL"><input type="text" style="width:100%" name="title" id="title"></td>
                    </tr>
                    <tr>
                        <th style="vertical-align:top">내용</th>
                        <td colspan="4" class="textL"><textarea style="height:105px;width:100%" placeholder="내용 입력" name="content" id="content"></textarea></td>
                    </tr>
                    <tr>
                        <th rowspan="2" style="vertical-align:top">파일첨부</th>
                        <td colspan="4" class="textL" style="border-bottom:none">
                            <input type="text" id="filename" class="floatL" readonly="readonly" style="width:280px;">
                            <div class="file_up">
                                <button type="button" class="btn_fileup" value="Search files">찾아보기</button>
                                <input type="file" name="imageFile" id="input_id_image" accept="image/*" style="width:100%" onchange="javascript: document.getElementById('filename').value=this.value">
                                <input type="hidden" id="imgYn" name= "imgYn" >
                                <input type="hidden" id="imgOldYn" name= "imgOldYn">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <span id="span_imgFile"></span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" class="file_up_info">
                            ※ 첨부 이미지는 1Mb 미만의 gif, jpge, png 파일만 등록 가능합니다.
                        </td>
                    </tr>
                </tbody>
            </table>
            </form>
            <div class="popup_btn_area">
                <button type="button" class="btn_review_ok">등록</button>
                <button type="button" class="btn_review_cancel">취소</button>
            </div>
        </div>
    </div>
    <!---// popup 상품평쓰기 --->
    </t:putAttribute>
</t:insertDefinition>