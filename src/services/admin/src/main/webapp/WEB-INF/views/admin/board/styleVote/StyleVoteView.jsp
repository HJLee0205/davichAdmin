<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2022/11/28
  Time: 11:11 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">스타일 추천 투표 > 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                // 상세 데이터 표시
                var param = {bbsId: "${so.bbsId}", lettNo: "${so.lettNo}",};
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_id_bbsCmnt');
                    $('#bind_target_id_profile').html(result.data.memberNm + ' / <span>' + result.data.memberNn + '</span>');

                    voteInfo(result.data.styleGoodsArr);

                    calcRemainTime(result.data.regDttm, result.data.endDttm);
                });

                // 댓글 리스트 표시
                bbsCmntSet.getBbsCmntList();

                // 회원, 상품 페이지 이동 기능
                $(document).on('click', 'a.tbl_link', function () {
                    if ($(this).hasClass('id')) {
                        viewMemberDetail($('#memberNo').val());
                    } else if ($(this).hasClass('goods')) {
                        console.log('a tag has \'goods\' class');

                        $(this).parents('.tgoods').data('goods-no');
                    } else if ($(this).hasClass('nickname')) {
                        var regrNo = $(this).parents('tr').data('regr-no');
                        viewMemberDetail(regrNo);
                    }
                });

                // 댓글 삭제 버튼 클릭
                $(document).on('click', 'a.btn_gray', function() {
                    if($(this).hasClass('cmnt_del')) {
                        var param = {
                            cmntSeq: $(this).parents('tr').data('cmnt-seq')
                        };
                        var url = '/admin/board/board-comment-delete';
                        Dmall.LayerUtil.confirm('삭제된 댓글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                    $('#hd_page').val('1');
                                    bbsCmntSet.getBbsCmntList();
                                }
                            });
                        });
                    }
                });

                // 목록 버튼 클릭
                $('#viewBbsLettList').on('click', function () {
                    var param = {bbsId: "${so.bbsId}"};

                    Dmall.FormUtil.submit('/admin/board/letter', param);
                });

                // 댓글 선택 삭제 버튼 클릭
                $('#delSelectBbsCmnt').on('click', function() {
                    var delChk = $('input:checkbox[name=delCmntSeq]').is(':checked');
                    if(delChk == false) {
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해주세요.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 댓글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', bbsCmntSet.delSelectBbsCmnt);
                });

                // 댓글 검색 버튼 클릭
                $('#btn_id_search').on('click', function() {
                    $('#hd_page').val('1');
                    bbsCmntSet.getBbsCmntList();
                });
            });

            var bbsCmntSet = {
                bbsCmntList: [],
                getBbsCmntList: function () {
                    var url = '/admin/board/board-comment-list';
                    var param = jQuery('#form_id_bbsCmnt').serialize();
                    var dfd = jQuery.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                            '<tr data-cmnt-seq="{{cmntSeq}}" data-regr-no="{{regrNo}}">' +
                            '<td>' +
                            '   <label for="delCmntSeq_{{cmntSeq}}" class=chack>' +
                            '   <span class="ico_comm"><input type="checkbox" name="delCmntSeq" id="delCmntSeq_{{cmntSeq}}" value="{{cmntSeq}}" class="blind"></span></label>' +
                            '</td>' +
                            '<td>{{rowNum}}</td>' +
                            '<td><a href="#none" class="tbl_link nickname">{{memberNn}}</a></td>' +
                            '<td>{{content}}</td>' +
                            '<td>{{regDttm}}</td>' +
                            '<td><a class="btn_gray cmnt_del">삭제</a></td>';
                        var templateMgr = new Dmall.Template(template);
                        var tr = '';

                        jQuery.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if (tr == '') {
                            tr = '<tr><td colspan="6">데이터가 없습니다.</td></tr>';
                        }

                        jQuery('#tbody_id_bbsCmntList').html(tr);
                        bbsCmntSet.bbsCmntList = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_bbsCmnt', 'div_id_paging', result, 'paging_id_bbsCmnt', bbsCmntSet.getBbsCmntList);

                        $('#a').text(result.filterdRows);
                        $('#b').text(result.totalRows);
                    });
                    return dfd.promise();
                },
                delSelectBbsCmnt: function() {
                    var url = '/admin/board/board-checkedcomment-delete';
                    var param = $('#form_id_bbsCmnt').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            $('#hd_page').val('1');
                            bbsCmntSet.getBbsCmntList();
                        }
                    });
                }
            }

            function viewMemberDetail(memberNo) {
                var param = { memberNo: memberNo };
                Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', param, '_blank');
            }

            let timer = 0;
            function calcRemainTime(regDttm, endDttm) {
                const endDate = new Date(endDttm);
                const cur = new Date();
                const utc = cur.getTime() + (cur.getTimezoneOffset() * 60 * 1000);
                const kr_cur = new Date(utc + (9 * 60 * 60 * 1000));
                let diff = endDate - kr_cur;

                if (diff < 1000) {
                    clearTimeout(timer);
                    $('#bind_target_id_voteStatus').html('투표종료');
                    $('#bind_target_id_dttm').html(regDttm + ' / 00일 00:00:00');
                } else {
                    const diffDay = Math.floor(diff / (1000 * 60 * 60 * 24));
                    const diffHour = Math.floor((diff / (1000 * 60 * 60)) % 24);
                    const diffMinute = Math.floor((diff / (1000 * 60)) % 60);
                    const diffSec = Math.floor(diff / 1000 % 60);

                    $('#bind_target_id_voteStatus').html('투표중');
                    $('#bind_target_id_dttm').html(regDttm + ' / ' +
                        diffDay.toString().padStart(2, '0') + '일 ' +
                        diffHour.toString().padStart(2, '0') + ':' +
                        diffMinute.toString().padStart(2, '0') + ':' +
                        diffSec.toString().padStart(2, '0'));

                    timer = setTimeout(calcRemainTime, 1000, regDttm, endDttm);
                }
            }

            function voteInfo(styleGoodsArr) {
                var template = '';
                var totalVote = 0;
                styleGoodsArr.forEach(function(data) {
                    totalVote += parseInt(data.voteCnt);
                });
                jQuery.each(styleGoodsArr, function(i, obj) {
                    var goodsImgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=' + obj.goodsImg;
                    var fitImgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=BBS&path=' + obj.imgFilePath + '&amp;id1=' + obj.imgFileNm;
                    var percent = 0;
                    if(totalVote != 0) {
                        percent = obj.voteCnt / totalVote * 100.0;
                    }
                    template +=
                        '<div class="t_table box">' +
                        '   <div class="tblw tblmany">' +
                        '       <table summary="이 표는 스타일 추천 투표_투표 정보 표입니다.">' +
                        '           <caption>투표 정보</caption>' +
                        '           <colgroup>' +
                        '               <col width="30%"/>' +
                        '               <col width="70%"/>' +
                        '           </colgroup>' +
                        '           <tbody>' +
                        '               <tr>' +
                        '                   <th>피팅 상품</th>' +
                        '                   <td>' +
                        '                       <div class="tgoods" data-goods-no="' + obj.goodsNo + '">' +
                        '                           <div class="tgoods box pr20">' +
                        '                               <div class="img">' +
                        '                                   <a href="#none" class="tbl_link goods">' +
                        '                                       <img src="' + goodsImgSrc + '" alt="상품 이미지"/>' +
                        '                                   </a>' +
                        '                               </div>' +
                        '                           </div>' +
                        '                           <div class="tgoods box">' +
                        '                               <span class="fg_goods_nm">' +
                        '                                   <span class="fwb">' + obj.brandNm + '</span><br/>' +
                        '                                   <a href="#none" class="tbl_link goods">' + obj.goodsNm + '</a><br/><br/>' + parseInt(obj.supplyPrice).toLocaleString('ko-KR') + '원' +
                        '                               </span>' +
                        '                           </div>' +
                        '                       </div>' +
                        '                   </td>' +
                        '               </tr>' +
                        '               <tr>' +
                        '                   <th>피팅 이미지</th>' +
                        '                   <td>' +
                        '                       <div class="tgoods">' +
                        '                           <div class="tgoods box">' +
                        '                               <div class="img">' +
                        '                                   <a href="#none">' +
                        '                                       <img src="' + fitImgSrc + '" alt="피팅 이미지"/>' +
                        '                                   </a>' +
                        '                               </div>' +
                        '                           </div>' +
                        '                       </div>' +
                        '                   </td>' +
                        '               </tr>' +
                        '               <tr>' +
                        '                   <th>투표수</th>' +
                        '                   <td>' + obj.voteCnt + ' <span>(' + percent.toFixed(1) + '%)</span></td>' +
                        '               </tr>' +
                        '           </tbody>' +
                        '       </table>' +
                        '   </div>' +
                        '</div>';
                });
                jQuery("#vote_info").html(template);
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">스타일 추천 투표</h2>
            </div>
            <form id="form_id_bbsCmnt">
                <div class="line_box pb">
                    <!-- 회원 정보 -->
                    <h3 class="tlth3">회원 정보</h3>
                    <div class="tblw tblmany">
                        <table summary="이표는 스타일 추천 투표_ 회원 정보표입니다">
                            <caption>
                                게시글 보기
                            </caption>
                            <colgroup>
                                <col width="15%"/>
                                <col width="18.33%"/>
                                <col width="15%"/>
                                <col width="18.33%"/>
                                <col width="15%"/>
                                <col width="18.33%"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>작성자 / 닉네임</th>
                                <td id="bind_target_id_profile" class="bind_target"></td>
                                <th class="line">아이디</th>
                                <td>
                                    <input type="hidden" id="memberNo" name="memberNo" value="">
                                    <a href="#none" class="tbl_link id" id="bind_target_id_loginId" class="bind_target"></a>
                                </td>
                                <th>등급</th>
                                <td id="bind_target_id_memberGradeNm" class="bind_target"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <!-- 기본 정보 -->
                    <h3 class="tlth3">기본 정보</h3>
                    <div class="tblw tblmany">
                        <table summary="이표는 스타일 추천 투표_ 기본 정보표입니다.구성은 구분표시, 상태표시, 등록일시/남은시간, 추천유저 선택, 댓글 허용 여부, 내용 입니다.">
                            <caption>
                                게시글 보기
                            </caption>
                            <colgroup>
                                <col width="15%"/>
                                <col width="85%"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>구분</th>
                                <td id="bind_target_id_goodsTypeCdNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>상태</th>
                                <td id="bind_target_id_voteStatus" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>등록일시 / 남은시간</th>
                                <td id="bind_target_id_dttm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>추천유저 선택</th>
                                <td id="bind_target_id_dispGbCdNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>댓글 허용 여부</th>
                                <td id="bind_target_id_cmntGbNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td id="bind_target_id_content" class="bind_target"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <!-- 투표 정보 -->
                    <h3 class="tlth3">투표 정보</h3>
                    <div class="t_table" id="vote_info"></div>
                    <!-- //t_table -->
                    <!-- 댓글 -->
                    <h3 class="tlth3 mb0">댓글 (<strong class="all" id="b"></strong>) </h3>
                    <div class="top_lay">
                        <div class="select_btn_left">
                    <span class="search_txt">
                      총 <strong class="be" id="a"></strong>개의 댓글이 검색되었습니다.
                    </span>
                        </div>
                        <div class="select_btn_right">
                            <form>
                                <input type="hidden" name="page" id="hd_page" value="1">
                                <input type="hidden" name="sord" id="hd_sord" value="">
                                <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}">
                                <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}">

                                <span class="intxt long"
                                ><input
                                        name="searchWord"
                                        id="input_search_word"
                                        type="text"
                                        maxlength="16"
                                /></span>
                                <a class="btn_gray" id="btn_id_search">검색</a>
                            </form>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table
                                style="table-layout: fixed"
                                summary="스타일 추천투표 댓글 리스트표 입니다. 구성은 체크박스,번호,닉네임,댓글, 등록일시,관리 입니다."
                        >
                            <caption>
                                스타일 추천 투표_댓글 목록
                            </caption>
                            <colgroup>
                                <col width="5%"/>
                                <col width="10%"/>
                                <col width="15%"/>
                                <col width="45%"/>
                                <col width="15%"/>
                                <col width="10%"/>
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="allcheck" class="chack">
                                        <span class="ico_comm">
                                            <input type="checkbox" name="table" id="allcheck"/>
                                        </span>
                                    </label>
                                </th>
                                <th>No</th>
                                <th>닉네임</th>
                                <th>댓글</th>
                                <th>등록일시</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_bbsCmntList">
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_box -->
                    <div class="bottom_lay">
                        <div class="left">
                            <div class="pop_btn">
                                <a href="#none" class="btn_gray2" id="delSelectBbsCmnt"
                                >선택삭제</a
                                >
                            </div>
                        </div>
                        <div class="pageing" id="div_id_paging"></div>
                    </div>
                    <!-- //bottom_box -->
                </div>
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="viewBbsLettList">목록</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>