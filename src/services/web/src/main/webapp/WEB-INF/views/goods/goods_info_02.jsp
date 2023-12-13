<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<sec:authentication var="user" property='details'/>
<script>
    $(document).ready(function(){
        //페이징
        jQuery('#div_review_paging').grid(jQuery('#form_review_search'),ajaxReviewList);

        //쓰기
        var ordYn = ${ordYn};
        var reviewYn = ${reviewYn};
        $('#btn_write_review').on('click', function() {

            var memberNo =  '${user.session.memberNo}';
            if(memberNo == '') {
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                        var returnUrl = window.location.pathname+window.location.search;
                        location.href= "/front/login/member-login?returnUrl="+returnUrl;
                    }
                );
            } else {
                if(!ordYn) {
                    Dmall.LayerUtil.alert('상품 구매 후(배송완료 이후) 작성 가능합니다.') ;
                } else {
                    if(reviewYn) {
                        Dmall.LayerUtil.alert('구매 후기는 한번만 작성 가능합니다.') ;
                    } else {
                        setDefaultReviewForm();
                        Dmall.LayerPopupUtil.open($('#popup_review_write'));
                    }
                }
            }
        });
        // 등록/수정
        $('#btn_review_cofirm').on('click', function() {
            var url = '';
            if($('#form_id_review #mode').val() == 'insert'){
                url = '/front/review/review-insert';
            }else{
                url = '/front/review/review-update';
            }

            if (Dmall.FileUpload.checkFileSize('form_id_review')) {
                $('#form_id_review').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        Dmall.validate.viewExceptionMessage(result, 'form_id_review');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('popup_review_write');   //수정후 레이어팝업 닫기
                            Dmall.LayerUtil.alert(result.message).done(function(){
                                location.href = '/front/goods/goods-detail?goodsNo=${so.goodsNo}'; //목록화면 갱신
                            });
                        } else {
                            //Dmall.LayerUtil.alert("오류가 발생하였습니다.<br>관리자에게 문의 하시기 바랍니다.");
                            Dmall.LayerUtil.alert("파일사이즈가 2MB를 초과합니다.");
                        }
                    }
                });
            }
        });

        // 상품평수정 팝업 닫기
        $('#btn_review_cancel').on('click', function() {
            setDefaultReviewForm();
            Dmall.LayerPopupUtil.close('popup_review_write');
        });

        //이미지파일 변경
        $('#input_id_image').on('change', function(e) {
            if($("#imgOldYn").val()=="Y"){
                $("#input_id_image").replaceWith( $("#input_id_image").clone(true) );
                $("#filename").val("");
                Dmall.LayerUtil.alert("등록된 이미지 파일을 먼저 삭제하여 주세요.");
            }else{
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

    //상품후기 상세조회
    function selectReview(idx){
        var url = '/front/review/review-detail',dfd = jQuery.Deferred();
        var param = {lettNo: idx};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $("#form_id_review #mode").val("update");
                $("#form_id_review #title").val(result.data.title);
                $("#form_id_review #content").val(result.data.content);
                $("#form_id_review #lettNo").val(idx);
                if(result.data.atchFileArr != null) {
                    var imgPath = "<img src='${_IMAGE_DOMAIN}/image/image-view?type=BBS&path="+result.data.atchFileArr[0].filePath+"&id1="+result.data.atchFileArr[0].fileNm+"' style='width:65px;height:65px;'>";
                    var button = "<img src='../img/product/btn_reply_del.gif' alt='삭제' style='cursor:hand' onclick='return delOldImgFileNm(\""+result.data.atchFileArr[0].fileNo+"\")'>";
                    $('#form_id_review #span_imgFile').html(imgPath+button);
                    $('#form_id_review #imgOldYn').val('Y');
                    $('#form_id_review #span_imgFile').show()
                }
                //$("#form_id_review  input[name='score']:radio[value='"+result.data.score+"']").prop('checked',true);
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
            var param = {'lettNo' : idx, bbsId : "review"};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href = '/front/goods/goods-detail?goodsNo=${so.goodsNo}'; //목록화면 갱신
                 }
            });
        })
    }

    function setDefaultReviewForm(){
        $('#form_id_review #mode').val('insert');
        $('#form_id_review #title').val('');
        $('#form_id_review #content').val('');
        $('#form_id_review #filename').val('');
        $('#form_id_review #input_id_image').val('');
        $('#form_id_review #content').val('');
        $('#form_id_review #imgOldYn').val('');
        $('#form_id_review #span_imgFile').html('')
        $('#form_id_review #span_imgFile').hide()
        $("#form_id_review input[name='score']:radio[value='5']").prop('checked',true);
    }

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
</script>
    <ul class="shopping_review_box">
        <li class="graphview">
            <span class="per_no">${averageScore}</span>
            <div class="review_graph_area">
                <p class="review_graph_bar" style="width:${averageScore*20}%"></p>
            </div>
            <div class="graph_star_groups">
                <c:forEach begin="1" end="${fn:substring(averageScore, 0, 1)}" >
                <img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별">
                </c:forEach>
                <c:if test="${fn:substring(averageScore, 0, 1) lt 5}">
                <c:forEach begin="${fn:substring(averageScore, 0, 1)+1}" end="5" >
                <img src="/front/img/product/icon_star_gray.png" alt="상품평가 별">
                </c:forEach>
                </c:if>
            </div>
            <span class=""><em>${reviewList.filterdRows}</em>분이 평가에 참여하셨습니다.</span>
        </li>
        <li>
            - 상품평은 주관적인 의견으로 보는 사람에 따라 다를 수 있습니다.<br>
            - 허위, 과대광고, 비방, 표절, 도용 등의 내용은 통보 없이 삭제 될 수 있습니다.<br>
            <button type="button" class="btn_review_ok" id="btn_write_review"style="margin-top:10px">상품평 쓰기</button>
        </li>
    </ul>
    <form:form id="form_review_search" commandName="so" >
    <form:hidden path="page" id="page" />
    <table class="tProduct_Board my_qna_table">
        <caption>
            <h1 class="blind">구매후기 게시판 목록입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:85px">
            <col style="width:130px">
            <col style="">
            <col style="width:100px">
            <col style="width:150px">
        </colgroup>
        <thead>
            <tr>
                <th>번호</th>
                <th>상품평가</th>
                <th>제목</th>
                <th>구매자</th>
                <th>등록일</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
            <c:when test="${reviewList.resultList ne null}">
                <c:forEach var="resultModel" items="${reviewList.resultList}" varStatus="status">
                <c:choose>
                <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
                <tr class="title">
                    <td>${resultModel.rowNum}</td>
                    <td>
                        <div class="star_groups">
                            <c:forEach begin="1" end="${resultModel.score}" ><img src="/front/img/product/icon_star_yellow.png" alt="상품평가 별"></c:forEach>
                        </div>
                    </td>
                    <td class="textL">
                        <span>${resultModel.title}</span>
                    </td>
                    <td>${StringUtil.maskingName(resultModel.memberNm)}</td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                </tr>
                <tr class="hide">
                    <td colspan="5" class="review_view">
                        <c:if test="${resultModel.imgFilePath ne null}">
                        <img src="/image/image-view?type=BBS&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" width="100px" height="100px;">
                        </c:if>
                        ${resultModel.content}
                        <div class="view_btn_area">
                            <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
                            <button type="button" class="btn_modify" onclick="selectReview('${resultModel.lettNo}');">수정</button>
                            <button type="button" class="btn_del" onclick="deleteReview('${resultModel.lettNo}');">삭제</button>
                            </c:if>
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
                    <td class="textL">
                        <span>${resultModel.title}</span>
                    </td>
                    <td>${StringUtil.maskingName(resultModel.memberNm)}</td>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                </tr>
                <tr class="hide">
                    <td colspan="5" class="review_view">
                        ${resultModel.content}
                    </td>
                </tr>
                </c:otherwise>
                </c:choose>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <td colspan="5">
                등록된 구매 후기가 없습니다.
                </td>
            </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    <!---- 페이징 ---->
    <div class="tPages" id=div_review_paging>
        <grid:paging resultListModel="${reviewList}" />
    </div>
    <!----// 페이징 ---->
    </form:form>
<!--- popup 상품평쓰기 --->
<div id="popup_review_write" style="display: none;">
    <div class="popup_header">
        <h1 class="popup_tit">상품평쓰기</h1>
        <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
    </div>
    <div class="popup_content">
        <form:form id="form_id_review">
        <input type="hidden" name="mode" id="mode" value="insert"/>
        <input type="hidden" name="bbsId" id="bbsId" value="review"/>
        <input type="hidden" name="lettNo" id="lettNo" value=""/>
        <input type="hidden" name="goodsNo" id="goodsNo" value="${so.goodsNo}"/>
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
                        ※ 첨부 이미지는 2Mb 미만의 gif, jpge, png 파일만 등록 가능합니다.
                    </td>
                </tr>
            </tbody>
        </table>
        </form:form>
        <div class="popup_btn_area">
            <button type="button" class="btn_review_ok" id="btn_review_cofirm">등록</button>
            <button type="button" class="btn_review_cancel" id="btn_review_cancel">취소</button>
        </div>
    </div>
 </div>
<!---// popup 상품평쓰기 --->
