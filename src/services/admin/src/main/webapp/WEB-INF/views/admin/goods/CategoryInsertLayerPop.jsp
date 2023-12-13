<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
$(document).ready(function() {
    // 닫기
    $('button.close').on('click', function(e) {
        init();
    });

    // 카테고리명 글자수 체크
    $(document).on('keyup', 'input[name="insCtgNm"]', function(e){
        var textLength = $(this).val().length;
        var maxLength = 42;
        if(textLength > maxLength){
            return false;
        }
        var $textLengthInfo = $(this).parent().next();
        $textLengthInfo.html(textLength + "/" + maxLength);
    });

    // 입력박스 추가
    $(document).on('click', '#categoryInsLayer button.plus', function(e){
        if($('.cate_name').children().length < 5) {
            var ctgTxtTag =
                "<li>" +
                "<span class='url'></span>" +
                "<span class='intxt'><input type='text' name='insCtgNm' maxlength='42'></span>&nbsp;" +
                "<span class='txt'>0/42</span>" +
                "<button class='btn_comm plus' type='button'>등록</button>" +
                "<button class='btn_comm minus' type='button'>삭제</button>" +
                "</li>";

            $(".cate_name").append(ctgTxtTag);
        }
    });

    // 입력박스 삭제
    $(document).on('click', '#categoryInsLayer button.minus', function(e){
        $(this).parents('li').remove();
    });

    // 적용하기
    $('#ctgInsertBtn').on('click', function(e) {
        Dmall.EventUtil.stopAnchorAction(e);

        var ctgNmArr  = $('input[name="insCtgNm"]');

        var ctgNmFlag = false;
        for(var i=0;i<ctgNmArr.length;i++){
            if(ctgNmArr[i].value != ''){
                ctgNmFlag = true;
            }
        }

        if(!ctgNmFlag){
            Dmall.LayerUtil.alert("카테고리명을 입력하여 주십시오.");
            return;
        }

        if(Dmall.validate.isValid('categoryInsForm')) {
            var url = '/admin/goods/category-insert',
                param = $('#categoryInsForm').serialize();

            console.log("insertPopup param = ", param);
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                Dmall.validate.viewExceptionMessage(result, 'categoryInsForm');
                if(result.success){
                    init();
                    Dmall.LayerPopupUtil.close("categoryInsLayer");
                    // ctgTreeListReload();
                    location.reload();
                }
            });
        }
    });
});

function openCtgInsLayer(treeLevel, upCtgNo, upCtgNm, ctgType, goodsTypeCd){
    $("#popCtgLvl").val(treeLevel);
    $("#popUpCtgNo").val(upCtgNo);
    $("#popInsCtgType").val(ctgType);
    $("#popGoodTypeCd").val(goodsTypeCd);

    var titleTxt = "";

    switch(treeLevel){
        case "2":
            titleTxt = "2Depth 카테고리 추가";
            break;
        case "3":
            titleTxt = "3Depth 카테고리 추가";
            break;
        case "4":
            titleTxt = "4Depth 카테고리 추가";
            break;
        case "5":
            titleTxt = "세분류 카테고리 추가";
            break;
    }
    console.log("insertPopup ctgType = ", ctgType);

    $("#layerTitle").text(titleTxt);
    $("p.message").text(upCtgNm);

}

//초기화 함수
function init(){
    $("input[name='insCtgNm']").each(function(idx){
        if(idx == 0){
            $(this).val("");
        }else{
            $(this).parents().parents('li').remove();
        }
    });

    $('input[name="insCtgNm"]').trigger('keyup');
}

</script>
<!-- layer_popup1 -->
<div id="categoryInsLayer" class="slayer_popup" style="display: none">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2" id="layerTitle" >대분류 카테고리 추가</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form id="categoryInsForm">
            <input type="hidden" name="ctgLvl" id="popCtgLvl" />
            <input type="hidden" name="upCtgNo" id="popUpCtgNo" />
            <input type="hidden" name="ctgType" id="popInsCtgType" />
            <input type="hidden" name="goodsTypeCd" id="popGoodTypeCd" />
            <div class="pop_con">
                <div class="cate">
                    <p class="message le">{카테고리 명}</p>
                    <ul class="cate_name">
                        <li>
                            <span class="url"></span>
                            <span class="intxt"><input type="text" name="insCtgNm" maxlength="42"></span>&nbsp;
                            <span class="txt">0/42</span>
                            <button class="btn_comm plus" type="button">등록</button>
                        </li>
                    </ul>
                    <p class="desc">
                        카테고리 추가는 +,<br>
                        카테고리 삭제는 - 버튼을 클릭하세요.
                    </p>
                    <div class="btn_box txtc">
                        <button class="btn--blue_small" id="ctgInsertBtn" type="button">적용하기</button>
                    </div>
                </div>
            </div>
        </form>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->
