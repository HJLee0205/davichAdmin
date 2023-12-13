<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
        <script>
        $(document).ready(function() {
            
            //필터 입력박스 삭제 이벤트
            $(document).on('click', 'button.sminus', function(e){
                $(this).parents('li').remove();
            });
            
            //필터명 글자수 체크
            $(document).on('keyup', 'input[name="insFilterNm"]', function(e){
                var textLength = $(this).val().length;
                var maxLength = 42;
                if(textLength > maxLength){
                    return false;
                }
                var $textLengthInfo = $(this).parent().next();
                $textLengthInfo.html(textLength + "/" + maxLength);
                
            });
            
            //필터 입력박스 추가 이벤트
            $(document).on('click', 'button.plus', function(e){
                var filterTxtTag = "<li><span class='url'></span> <span class='intxt'><input type='text' name='insFilterNm' maxlength='42'></span> <span class='txt'>0/42</span> <button class='btn_comm plus' type='button'>등록</button> <button class='btn_comm minus' type='button'>삭제</button></li>";
                
                $(".cate_name").append(filterTxtTag);
            });
            
            // 취소 버튼 이벤트
            $('#closeFilterInsLayer').on('click', function(e) {
                init();
                Dmall.LayerPopupUtil.close("filterInsLayer");
            });
            
            // 필터 추가
            $('#filterInsertBtn').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                var filterNmArr  = $('input[name="insFilterNm"]');
                
                var filterNmFlag = false;
                for(var i=0;i<filterNmArr.length;i++){
                    if(filterNmArr[i].value != ''){
                        filterNmFlag = true;
                    }
                }
                
                if(!filterNmFlag){
                    Dmall.LayerUtil.alert("필터명을 입력하여 주십시오.");
                    return;
                }
                
                if(Dmall.validate.isValid('filterInsForm')) {
                    var url = '/admin/goods/filter-insert',
                        param = $('#filterInsForm').serialize();

                    console.log("param = ", param);
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'filterInsForm');
                        if(result.success){
                            Dmall.LayerPopupUtil.close("filterInsLayer");
                            filterTreeListReload();
                            init();
                        }
                    });
                }
            });
        });

        function openFilterInsLayer(treeLevel, upFilterNo, upFilterNm, filterMenuType, filterType, goodsTypeCd){

            $("#filterLvl").val(treeLevel);
            $("#upFilterNo").val(upFilterNo);
            $("#upFilterMenuType").val(filterMenuType);
            $("#upFilterType").val(filterType);
            $("#upGoodsTypeCd").val(goodsTypeCd);

            var titleTxt = "";

            switch(treeLevel){
                case "1":
                    titleTxt = "대분류 필터 추가";
                    break;
                case "2":
                    titleTxt = "중분류 필터 추가";
                    break;
                case "3":
                    titleTxt = "소분류 필터 추가";
                    break;
                case "4":
                    titleTxt = "세분류 필터 추가";
                    break;
            }
            console.log("treeLevel = ", treeLevel);
            console.log("upFilterNm = ", upFilterNm);
            $("#layerTitle").text(titleTxt);
            $("p.message").text(upFilterNm + " 필터");
            var param = $('#filterInsForm').serialize();
            console.log("param = ", param);
        }
        
        //초기화 함수
        function init(){
            $("input[name='insFilterNm']").each(function(idx){
                if(idx == 0){
                    $(this).val("");
                }else{
                    $(this).parents().parents('li').remove();
                }
            });
            
            $('input[name="insFilterNm"]').trigger('keyup');
        }
        
        </script>
    <!-- layer_popup1 -->
    <div id="filterInsLayer" class="slayer_popup" style="display: none">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2" id="layerTitle" >대분류 필터 추가</h2>
                <button class="close ico_comm" id="closeFilterInsLayer">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <form id="filterInsForm">
            <input type="hidden" name="filterLvl" id="filterLvl" />
            <input type="hidden" name="upFilterNo" id="upFilterNo" />
            <input type="hidden" name="upFilterNm" id="upFilterNm" />
            <input type="hidden" name="filterMenuType" id="upFilterMenuType" />
            <input type="hidden" name="filterType" id="upFilterType" />
            <input type="hidden" name="goodsTypeCd" id="upGoodsTypeCd" />
            <div class="pop_con">
                <div class="cate">
                    <p class="message le">{쇼핑몰네임} 필터</p>
                    <ul class="cate_name">
                        <li>
                            <span class="url"></span>
                            <span class="intxt">
                                <input type="text" name="insFilterNm" maxlength="42" >
                            </span>
                            <span class="txt">0/42</span>
                            <button class="btn_comm plus" type="button">등록</button>
                        </li>
<!--                         <li><span class="url"></span> <span class="intxt"><input type="text" name="insFilterNm" maxlength="42"></span> <span class="txt">0/42</span> <button class="btn_comm plus" type="button">등록</button> <button class="btn_comm minus" type="button">삭제</button></li> -->
<!--                         <li><span class="url"></span> <span class="intxt"><input type="text" name="insFilterNm" maxlength="42"></span> <span class="txt">0/42</span> <button class="btn_comm plus" type="button">등록</button> <button class="btn_comm minus" type="button">삭제</button></li> -->
                    </ul>
                    <p class="desc">
                        필터 추가는 +,<br>
                        필터 삭제는 - 버튼을 클릭하세요.
                    </p>
                    <div class="btn_box txtc">
                        <button class="btn_green" id="filterInsertBtn" type="button">확인</button>
                    </div>
                </div>
            </div>
            </form>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
