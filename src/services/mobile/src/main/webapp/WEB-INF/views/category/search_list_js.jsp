<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
    var ctgArray = ['${param.get("searchCtg1")}', '${param.get("searchCtg2")}', '${param.get("searchCtg3")}', '${param.get("searchCtg4")}'],
            init = false;

    $(document).ready(function(){
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        // 이전 검색조건 셋팅
        var searchWord = '${so.searchWord}';
        var searchType = '${so.searchType}';
        var searchPriceFrom = '${so.searchPriceFrom}';
        var searchPriceTo = '${so.searchPriceTo}';
        $("#searchType option:eq("+searchType+")").attr("selected", "selected");
        $('#searchType').change();
        $('#searchWord').val(searchWord);
        $('#searchPriceFrom').val(searchPriceFrom);
        $('#searchPriceTo').val(searchPriceTo);

        //검색버튼 클릭
        $('.btn_category_search').on('click',function(){
            goods_search();
        });
        //검색초기화버튼 클릭
        $('.btn_category_search_reset').on('click',function(){
            $("#searchType").val("0").attr("selected", "selected");
            $("#searchType").trigger('change');//검색조건 초기화
            $("#sel_ctg_1").val('');
            $('#sel_ctg_1').trigger('change');
            $('#searchWord').val('');//검색어 초기화
            $('#searchPriceFrom').val('');//최소판매가격대 초기화
            $('#searchPriceTo').val('');//최대판매가격대 초기화
        });

//        getCategoryOptionValue('1', jQuery('#sel_ctg_1')).done(defaultSetting); //1차 카테고리 조회
        // 카테고리1 변경시 이벤트
        $('#sel_ctg_1').on('change', function(e) {
            var $this = $(this);
            resetCategoryOptionValue('2', $this);
            resetCategoryOptionValue('3', $this);
            resetCategoryOptionValue('4', $this);
            changeCategoryOptionValue('2', $this);
            jQuery('#opt_ctg_2_def').focus();
        });
        // 카테고리2 변경시 이벤트
        $('#sel_ctg_2').on('change', function(e) {
            var $this = $(this);
            resetCategoryOptionValue('3', $this);
            resetCategoryOptionValue('4', $this);
            changeCategoryOptionValue('3', $this);
            jQuery('#opt_ctg_3_def').focus();
        });
        // 카테고리3 변경시 이벤트
        $('#sel_ctg_3').on('change', function(e) {
            var $this = $(this);
            resetCategoryOptionValue('4', $this);
            changeCategoryOptionValue('4', $this);
            jQuery('#opt_ctg_4_def').focus();
        });

        defaultSetting();
    });
    // 초기셋팅
    function defaultSetting(){
        if(ctgArray[0] != '') { // 카테고리 검색조건이 있을경우
            getCategoryOptionValue(1, jQuery('#sel_ctg_1')).done(function(level) {
                jQuery('#sel_ctg_' + level).val(ctgArray[level - 1]).trigger('change');
            });
        } else { // 카테고리 검색조건이 없을경우
            getCategoryOptionValue('1', jQuery('#sel_ctg_1'));
        }

    }

    function resetCategoryOptionValue(level, $target) {
        var $sel = $('#sel_ctg_' + level),
                $label = $('label[for=sel_ctg_' + level + ']', '#td_goods_select_ctg');
        $sel.find('option').not(':first').remove();
        $label.text($sel.find("option:first").text());
    }

    // 상위 카테고리 설정에 따른 하위 카테고리 옵션값 변경
    function changeCategoryOptionValue(level, $upCtg) {
        var $sel = $('#sel_ctg_' + level),
                dfd = jQuery.Deferred(),
                val = $upCtg.val();

        if(val != null && val != '') {
            getCategoryOptionValue(level, $sel, val).done(function (ctgVal) {
                jQuery('#sel_ctg_' + ctgVal).val(ctgArray[ctgVal -1]).trigger('change');
            });
        } else {
            jQuery('#sel_ctg_' + level).val('').trigger('change');
            init = true;
        }

        if(level == 4) {
            init = true;
        }

        return dfd.promise();
    }
    // 카테고리 정보 취득
    function getCategoryOptionValue(ctgLvl, $sel, upCtgNo) {
        if (ctgLvl != '1' && upCtgNo == '') {
            return;
        }
        var url = '${_MOBILE_PATH}/front/search/category-list',
            param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl},
            dfd = jQuery.Deferred();

        if(init) {
            ctgArray[ctgLvl - 1] = '';
        }

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if (result == null || result.success != true) {
                return;
            }
            $sel.find('option').not(':first').remove();
            // 취득결과 셋팅
            jQuery.each(result.resultList, function(idx, obj) {
                $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');
            });
            dfd.resolve(ctgLvl);
        });
        return dfd.promise();
    }
</script>