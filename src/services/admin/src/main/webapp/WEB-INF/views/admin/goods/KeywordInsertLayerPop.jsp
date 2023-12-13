<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
    $(document).ready(function() {
        //필터 입력박스 추가 이벤트
        $(document).on('click', 'button.plus', function(e){
            Dmall.EventUtil.stopAnchorAction(e);

            if($(this).closest('ul').children('li').length >= 5) {
                return;
            }

            var keywordTxtTag =
                "<li>" +
                "<span class='url'></span>" +
                "<span class='intxt'>" +
                "<input type='text' name='insKeywordNm' maxlength='42'></span> <span class='txt'>0/42</span>" +
                "<button class='btn_comm plus' type='button'>등록</button><button class='btn_comm minus' type='button'>삭제</button>" +
                "</li>";

            $(".cate_name").append(keywordTxtTag);
        });

        //필터 입력박스 삭제 이벤트
        $(document).on('click', 'button.minus', function(e){
            $(this).parents('li').remove();
        });

        //필터명 글자수 체크
        $(document).on('keyup', 'input[name="insKeywordNm"]', function(e){
            var textLength = $(this).val().length;
            var maxLength = 42;
            if(textLength > maxLength){
                return false;
            }
            var $textLengthInfo = $(this).parent().next();
            $textLengthInfo.html(textLength + "/" + maxLength);
        });

        // 취소 버튼 이벤트
        $('#closeKeywordInsLayer').on('click', function(e) {
            init();
            Dmall.LayerPopupUtil.close("keywordInsLayer");
        });

        // 키워드 추가
        $('#keywordInsertBtn').on('click', function(e) {
            Dmall.EventUtil.stopAnchorAction(e);

            var keywordNmArr  = $('input[name="insKeywordNm"]');

            var keywordNmFlag = true;
            for(var i=0;i<keywordNmArr.length;i++){
                if(keywordNmArr[i].value === ''){
                    keywordNmFlag = false;
                }
            }

            if(!keywordNmFlag){
                Dmall.LayerUtil.alert("키워드를 입력하여 주십시오.");
                return;
            }

            if(Dmall.validate.isValid('keywordInsForm')) {
                var url = '/admin/goods/keyword-insert',
                    param = $('#keywordInsForm').serialize();

                console.log("param = ", param);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.validate.viewExceptionMessage(result, 'keywordInsForm');
                    if(result.success){
                        init();
                        Dmall.LayerPopupUtil.close("keywordInsLayer");
                        // keywordTreeListReload();
                        KeywordUtil.keywordTreeReload();
                    }
                });
            }
        });
    });

    function openKeywordInsLayer(treeLevel, upKeywordNo, upKeywordNm, goodsTypeCd){
        $("#popKeywordLvl").val(treeLevel);
        $("#popUpKeywordNo").val(upKeywordNo);
        $("#popUpKeywordNm").val(upKeywordNm);
        $("#keywordGoodsTypeCd").val(goodsTypeCd);

        $("p.message").text(upKeywordNm);
    }

    //초기화 함수
    function init(){
        $("input[name='insKeywordNm']").each(function(idx){
            if(idx == 0){
                $(this).val("");
            }else{
                $(this).closest('li').remove();
            }
        });

        $('input[name="insKeywordNm"]').trigger('keyup');
    }
</script>
<!-- layer_popup1 -->
<div id="keywordInsLayer" class="slayer_popup" style="display: none">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2" id="layerTitle">하위 키워드 추가</h2>
            <button class="close ico_comm" id="closeKeywordInsLayer">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form id="keywordInsForm">
        <input type="hidden" name="keywordLvl" id="popKeywordLvl" />
        <input type="hidden" name="upKeywordNo" id="popUpKeywordNo" />
        <input type="hidden" name="upKeywordNm" id="popUpKeywordNm" />
        <input type="hidden" name="goodsTypeCd" id="keywordGoodsTypeCd" />
        <div class="pop_con">
            <div class="cate">
                <p class="message le">{키워드 명}</p>
                <ul class="cate_name">
                    <li><span class="url"></span> <span class="intxt"><input type="text" name="insKeywordNm" maxlength="42" ></span> <span class="txt">0/42</span> <button class="btn_comm plus" type="button">등록</button></li>
<!--                         <li><span class="url"></span> <span class="intxt"><input type="text" name="insKeywordNm" maxlength="42"></span> <span class="txt">0/42</span> <button class="btn_comm plus" type="button">등록</button> <button class="btn_comm minus" type="button">삭제</button></li> -->
<!--                         <li><span class="url"></span> <span class="intxt"><input type="text" name="insKeywordNm" maxlength="42"></span> <span class="txt">0/42</span> <button class="btn_comm plus" type="button">등록</button> <button class="btn_comm minus" type="button">삭제</button></li> -->
                </ul>
                <p class="desc">
                    키워드 추가는 +,<br>
                    키워드 삭제는 - 버튼을 클릭하세요.
                </p>
                <div class="btn_box txtc">
                </div>
                <div class="btn_box txtc">
                    <button class="btn--blue_small" id="keywordInsertBtn" type="button">적용하기</button>
                </div>
            </div>
        </div>
        </form>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->
