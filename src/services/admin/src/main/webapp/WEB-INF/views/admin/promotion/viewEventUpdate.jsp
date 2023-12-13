<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 이벤트 &gt; 이벤트 수정</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>    
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                EventUtil.init();

                // 저장
                $('#reg_btn').on('click', function(e) {
                    EventUtil.save();
                });

                // 이벤트 대표 이미지
                $('#input_id_image').on('change', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if($(this)[0].files.length < 1) {
                        $(this).siblings('.upload_file').html('');
                    }

                    if(this.files && this.files[0]) {
                        var fileNm = this.files[0].name;
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            var template =
                                '<img src="'+e.target.result+'" alt="미리보기 이미지">' +
                                '<span class="txt">'+fileNm+'</span>' +
                                '<button class="cancel">삭제</button>';

                            $('div.upload_file').append(template);
                        };
                        reader.readAsDataURL(this.files[0]);

                        $('input.upload-name').val(fileNm);
                    }
                });

                // 미리보기 삭제
                $(document).on('click', 'button.cancel', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var $obj = $(e.target).closest('div.upload_file');
                    $obj.closest('td').find('input.upload-name').val('');
                    $obj.siblings('input[type=file]').val('');
                    $obj.html('');
                });

                // 목록
                $('#btn_list').on('click', function () {
                    Dmall.FormUtil.submit('/admin/promotion/event');
                });
            });

            var EventUtil = {
                init: function () {
                    Dmall.DaumEditor.init();
                    Dmall.DaumEditor.create('eventContentHtml');

                    Dmall.DaumEditor.setContent('eventContentHtml', '${resultModel.data.eventContentHtml}');
                    Dmall.DaumEditor.setAttachedImage('eventContentHtml', JSON.parse('${attachImages}'));
                },
                validation: function () {
                    // 이벤트 기간
                    var $srch_sc01 = $("#srch_sc01");
                    var $srch_from_hour = $("#srch_from_hour");
                    var $srch_from_minute = $("#srch_from_minute");
                    var $srch_sc02 = $("#srch_sc02");
                    var $srch_to_hour = $("#srch_to_hour");
                    var $srch_to_minute = $("#srch_to_minute");

                    // 당첨자 발표
                    var $wng_sc01 = $("#wng_sc01");
                    var $wng_from_hour = $("#wng_from_hour");
                    var $wng_from_minute = $("#wng_from_minute");

                    // 상품군
                    if($('#goodsTypeCd').val() == '') {
                        Dmall.LayerUtil.alert("상품군을 선택하세요");
                        return false;
                    }
                    // 이벤트 명
                    if( $("#eventNm").val() == ""){
                        Dmall.LayerUtil.alert("이벤트 명을 입력하세요");
                        return false;
                    }
                    // 이벤트 설명
                    if( $("#eventDscrt").val() == ""){
                        Dmall.LayerUtil.alert("이벤트 설명을 입력하세요");
                        return false;
                    }
                    // 이벤트 기간
                    if ($srch_sc01.val() == '' || $srch_sc01.val() == null || $srch_sc02.val() == '' || $srch_sc02.val() == null) {
                        Dmall.LayerUtil.alert("일시를 선택해주세요.<br>[필드: 이벤트 기간]");
                        return false
                    } else if ($srch_sc01.val() > $srch_sc02.val()) {
                        Dmall.LayerUtil.alert("시작날짜가 종료날짜보다 큽니다.<br>[필드: 이벤트 기간]")
                        return false;
                    } else if ($srch_sc01.val() == $srch_sc02.val()) {
                        if ($srch_from_hour.val() > $srch_to_hour.val()) {
                            Dmall.LayerUtil.alert("시작시간이 종료시간보다 큽니다.<br>[필드: 이벤트 기간]")
                            return false;
                        } else if ($srch_from_hour.val() == $srch_to_hour.val()) {
                            if ($srch_from_minute.val() >= $srch_to_minute.val()) {
                                Dmall.LayerUtil.alert("시작시간이 종료시간보다 크거나 같습니다.<br>[필드: 이벤트 기간]")
                                return false;
                            }
                        }
                    }
                    // 당첨자 발표
                    if($wng_sc01.val() == '' || $wng_sc01.val() == null ){
                        Dmall.LayerUtil.alert("일시를 선택해주세요.<br>[필드: 당첨자 발표]");
                        return false
                    } else if($srch_sc02.val() > $wng_sc01.val()){
                        Dmall.LayerUtil.alert("종료날짜가 당첨자 발표날짜보다 큽니다.<br>[필드: 당첨자 발표]")
                        return false;
                    } else if($srch_sc02.val() == $wng_sc01.val()){
                        if($srch_to_hour.val() > $wng_from_hour.val()){
                            Dmall.LayerUtil.alert("종료시간이 당첨자 발표시간보다 큽니다.<br>[필드: 당첨자 발표]")
                            return false;
                        } else if($srch_to_hour.val() == $wng_from_hour.val()){
                            if($srch_to_minute.val() >= $wng_from_minute.val()){
                                Dmall.LayerUtil.alert("종료시간이 당첨자 발표시간보다 크거나 같습니다.<br>[필드: 당첨자 발표]")
                                return false;
                            }
                        }
                    }

                    return true;
                },
                save: function () {
                    if(!EventUtil.validation()) {
                        return false;
                    }

                    Dmall.LayerUtil.confirm('저장하시겠습니까?', function () {
                        Dmall.DaumEditor.setValueToTextarea('eventContentHtml');

                        var url = '/admin/promotion/event-update';

                        Dmall.waiting.start();
                        $('#form_info').ajaxSubmit({
                            url: url,
                            dataType: 'json',
                            success: function (result) {
                                Dmall.waiting.stop();
                                Dmall.LayerUtil.alert(result.message).done(function(){
                                    Dmall.FormUtil.submit('/admin/promotion/event');
                                });
                            },
                        });
                    });
                },
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <c:set var="eventVO" value="${resultModel.data}" />
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    프로모션 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">이벤트 관리</h2>
            </div>
            <form action="" id="form_info" method="post">
                <input type="hidden" name="eventNo" value="${eventVO.eventNo}">
                <div class="line_box fri pb">
                    <div class="tblw tblmany">
                        <table>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>상품군</th>
                                <td>
                                    <span class="select">
                                        <label for="">선택</label>
                                        <select name="" id="">
                                            <tags:option codeStr=":선택;01:안경테;02:선글라스;04:콘택트렌즈;03:안경렌즈" value="${eventVO.goodsTypeCd}"/>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>이벤트명</th>
                                <td>
                                    <span class="intxt wid100p"><input type="text" name="eventNm" id="eventNm" value="${eventVO.eventNm}" data-validation-engine="validate[required, maxSize[100]]"/></span>
                                </td>
                            </tr>
                            <tr>
                                <th>이벤트 설명</th>
                                <td>
                                    <span class="intxt wid100p"><input type="text" name="eventDscrt" id="eventDscrt" value="${eventVO.eventDscrt}" data-validation-engine="validate[required, maxSize[300]]"/></span>
                                </td>
                            </tr>
                            <tr>
                                <th>이벤트 기간</th>
                                <td>
                                    <tags:calendarTime from="from" to="to" idPrefix="srch" fromValue="${eventVO.applyStartDttm}" toValue="${eventVO.applyEndDttm}" />
                                </td>
                            </tr>
                            <tr>
                                <th>당첨자 발표</th>
                                <td>
                                    <tags:calendarTimeOne from="wngFrom" idPrefix="wng" fromValue="${eventVO.eventWngDttm}" />
                                </td>
                            </tr>
                            <tr>
                                <th>이벤트 내용</th>
                                <td>
                                    <div class="edit">
                                        <textarea id="eventContentHtml" name="eventContentHtml" class="blind"></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>이벤트 대표 이미지</th>
                                <td>
                                    <span class="intxt imgup2"><input id="file_route1" class="upload-name" type="text" name="dlgtImgOrgNm" readonly value="${eventVO.dlgtImgOrgNm}"></span>
                                    <label class="filebtn on" for="input_id_image">파일첨부</label>
                                    <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                                    <div class="desc_txt br2">
                                        · 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )<br>
                                        <em class="point_c6">· 845px X 475px  사이즈로 등록하여 주세요.</em>
                                    </div>
                                    <div class="upload_file">
                                        <c:if test="${fn:length(eventVO.eventWebBannerImgPath) gt 1}">
                                            <img src="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&path=${eventVO.eventWebBannerImgPath}&id1=${eventVO.eventWebBannerImg}" alt="">
                                            <span class="txt">${eventVO.dlgtImgOrgNm}</span>
                                            <button class="cancel">삭제</button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>SEO 검색용 태그</th>
                                <td>
                                    <div class="txt_area">
                                        <textarea name="seoSearchWord" id="txt_seo_search_word" data-validation-engine="validate[maxSize[2500]]">${eventVO.seoSearchWord}</textarea>
                                    </div>
                                    <span class="br2"></span>
                                    <span class="fc_pr1 fs_pr1">
                                        ※ 쉼표(,)로 구분하여 등록해주세요<br/>
										※ ex) 안경,안경테,안경렌즈
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>댓글사용여부</th>
                                <td>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="eventCmntUseYn" idPrefix="eventCmntUseYn" value="${eventVO.eventCmntUseYn}"/>
                                </td>
                            </tr>
                            <tr>
                                <th>게시물노출여부</th>
                                <td>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="eventUseYn" idPrefix="eventUseYn" value="${eventVO.eventUseYn}"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="reg_btn">저장</button>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
