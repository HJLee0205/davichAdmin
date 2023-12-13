<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2022/12/13
  Time: 7:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
  <t:putAttribute name="title">스타일 픽 > 게시물</t:putAttribute>
  <t:putAttribute name="script">
    <script>
      $(document).ready(function() {
        // 인플루언서 찾기 팝업 초기화
        InfluencerSelectPopup._init(fn_callback_pop_apply_influencer);

        // 상세 데이터 조회
        var url = '/admin/board/board-letter-detail';
        var param = { bbsId: '${so.bbsId}', lettNo: '${so.lettNo}'};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
          // json 데이터 바인딩
          Dmall.FormUtil.jsonToForm(result.data, 'form_stylepick_info');

          // 인플루언서 닉네임 바인딩
          bindInfluencer(result.data);

          // 첨부 이미지 미리보기 바인딩
          bindAtchFile(result.data.atchFileArr);

          // 등록 상품 정보 바인딩
          bindRegGoods(result.data);
        });

        // 댓글 리스트 표시
        bbsCmntSet.getBbsCmntList();

        // 인플루언서 삭제 버튼 클릭
        $('.influencerNm').on('click', '.cancel', function(e) {
          Dmall.EventUtil.stopAnchorAction(e);

          $('.influencerNm').html('');
        });

        // 인플루언서 찾기 버튼 클릭
        $('#influencer_srch_btn').on('click', function(e) {
          Dmall.EventUtil.stopAnchorAction(e);

          Dmall.LayerPopupUtil.open($('#layer_popup_influencer_select'));
          InfluencerSelectPopup.reset();
          $('#btn_popup_influencer_search').trigger('click');
        });

        // 이미지 첨부 시 미리보기 이미지 표시
        $('input[type=file]').change(function() {
          var name = $(this).attr('name');
          if($('.preview_' + name).children().is('button')) {
            $('input[name=' + name + ']').val('');
            Dmall.LayerUtil.alert('이미 이미지가 등록되어 있습니다.<br/>기존 이미지를 삭제 후 진행 바랍니다.');
            return;
          }

          if(this.files && this.files[0]) {
            var fileNm = this.files[0].name;
            var reader = new FileReader();
            reader.onload = function(e) {
              var template =
                      '<span class="txt">' + fileNm + '</span>' +
                      '<button class="cancel">삭제</button><br/>' +
                      '<img src="' + e.target.result + '" alt="미리보기 이미지">';
              $('.preview_' + name).html(template);
            };
            reader.readAsDataURL(this.files[0]);
          }
        });

        // 이미지 삭제 버튼 클릭
        $('.upload_file').on('click', '.cancel', function(e) {
          Dmall.EventUtil.stopAnchorAction(e);

          var obj = $(e.target).parents('.upload_file');
          if(obj.attr('id')) {
            delRemoteImgFileNm(obj.attr('id'));
          } else {
            var strIdx = obj.attr('class').lastIndexOf('file');
            var name = obj.attr('class').substring(strIdx, strIdx + 5);
            $('input[name=' + name + ']').val('');
            obj.html('');
          }
        });

        // 상품 삭제 버튼 클릭
        $('#btn_check_delete').on('click', function(e) {
          $('#tbody_recommend_data').children('tr').each(function() {
            if($(this).find('label[for^=chk_recommendNo_]').hasClass('on')) {
              $(this).remove();
            }
          });
          var $sel_expt_goods_list = $("#tbody_recommend_data");
          var cnt_total = $sel_expt_goods_list.children('tr').length - 1;

          for(var i = 0; i <= cnt_total; i++){
            $sel_expt_goods_list.children('tr').eq(i).children('td').eq(1).text(i);
          }

          $("#cnt_total").html(cnt_total);

          if(cnt_total === 0){
            $("#goods_search_empty").show();
            $("#goods_search_exist").hide();
          }
        });

        // 목록 버튼 클릭
        $('#viewBbsLettList').on('click', function(e) {
          Dmall.EventUtil.stopAnchorAction(e);

          var param = {bbsId : "${so.bbsId}"};

          Dmall.FormUtil.submit('/admin/board/letter', param);
        });

        // 수정 버튼 클릭
        $('#bbsLettListUpdate').on('click', function(e) {
          Dmall.EventUtil.stopAnchorAction(e);

          var url = '/admin/board/board-letter-update';

          $('#form_stylepick_info').ajaxSubmit({
            url : url,
            dataType : 'json',
            success : function(result) {
              if(result.success) {
                var param = { bbsId : '${so.bbsId}'};
                Dmall.LayerUtil.alert(result.message).done(function() {
                  Dmall.FormUtil.submit('/admin/board/letter', param);
                });
              } else {
                Dmall.LayerUtil.alert(result.message)
              }
            }
          });
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

        // 회원 페이지 이동 기능
        $(document).on('click', 'a.tbl_link', function() {
          var regrNo = $(this).parents('tr').data('regr-no');
          var param = { memberNo: regrNo };
          Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', param, '_blank');
        });
      });

      var bbsCmntSet = {
        bbsCmntList: [],
        getBbsCmntList: function() {
          var url = '/admin/board/board-comment-list';
          var param = $('#form_id_bbsCmnt').serialize();
          var dfd = jQuery.Deferred();

          Dmall.AjaxUtil.getJSON(url, param, function (result) {
            var template =
                    '<tr data-cmnt-seq="{{cmntSeq}}" data-regr-no="{{regrNo}}">' +
                    '<td>' +
                    '   <label for="delCmntSeq_{{cmntSeq}}" class=chack>' +
                    '   <span class="ico_comm"><input type="checkbox" name="delCmntSeq" id="delCmntSeq_{{cmntSeq}}" value="{{cmntSeq}}" class="blind"></span></label>' +
                    '</td>' +
                    '<td>{{rowNum}}</td>' +
                    '<td><a href="#none" class="tbl_link">{{memberNn}}</a></td>' +
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

      // 인플루언서 정보 바인딩
      function bindInfluencer(data) {
        var template =
                '<input type="hidden" name="memberNo" value="' + data.memberNo + '">' +
                '<span class="txt">' + data.memberNn + '</span>' +
                '<button class="cancel">삭제</button>';
        $('.influencerNm').html(template);
      }

      // 첨부 이미지 정보 바인딩
      function bindAtchFile(data) {
        jQuery.each(data, function(i, obj) {
          $('.preview_file'+(i+1)).attr('id', obj.fileNo);

          var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=BBS&path=' + obj.filePath + '&id1=' + obj.fileNm;
          var template =
                  '<span class="txt">' + obj.orgFileNm + '</span>' +
                  '<button class="cancel">삭제</button><br/>' +
                  '<img src="' + imgSrc + '" alt="미리보기 이미지">';
          $('.preview_file'+(i+1)).html(template);
        });
      }

      // 등록 상품 정보 바인딩
      function bindRegGoods(data) {
        if(data.styleGoodsArr == null || data.styleGoodsArr.length < 1) {
          return;
        }
        $('#goods_search_empty').hide();
        $('#goods_search_exist').show();
        jQuery.each(data.styleGoodsArr, function(i, obj) {
          var template  = '<tr id="tr_goods_' + obj["goodsNo"] + '" class="searchGoodsResult">'+
                  '<td>' +
                  '<input type="hidden" name="recommendNo" value="' + obj["goodsNo"] + '">' +
                  '<label for="chk_recommendNo_' + obj["rowNum"] + '" class="chack"><span class="ico_comm">' +
                  '<input type="checkbox" id="chk_recommendNo_' + obj["rowNum"] + '" class="blind">' +
                  '</span></label></td>'+
                  '<td>' + obj["rowNum"] + '</td>'+
                  '<td><img src=' + obj["goodsImg"] + '></td>'+
                  '<td>' + obj["goodsNm"] + '</td>'+
                  '<td>' + obj["goodsNo"] + '</td>'+
                  '<td>' + obj["brandNm"] + '</td>'+
                  '<td>' + obj["sellerNm"] + '</td>'+
                  '<td>' + Dmall.common.numberWithCommas(obj["salePrice"]) + '</td>'+
                  '<td>' + Dmall.common.numberWithCommas(obj["supplyPrice"]) + '</td>'+
                  '<td>' + Dmall.common.numberWithCommas(obj["stockQtt"]) + '</td>'+
                  '<td>' + obj["goodsSaleStatusNm"] + '</td>'+
                  '<td>' + obj["erpItmCode"] + '</td>'+
                  '</tr>';
          $('#tbody_recommend_data').append(template);
        });
        var cnt_total = $('#tbody_recommend_data').children('tr').length - 1;
        $('#cnt_total').html(cnt_total);
      }

      // 서버 이미지 파일 삭제
      function delRemoteImgFileNm(fileNo) {
        Dmall.LayerUtil.confirm('삭제된 이미지는 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
          var url = '/admin/board/attach-file-delete';
          var param = { fileNo: fileNo, bbsId: '${so.bbsId}' };

          Dmall.AjaxUtil.getJSON(url, param, function(result) {
            $('#'+fileNo).html('');
            $('#'+fileNo).removeAttr('id');
          });
        })
      }

      // 인플루언서 팝업 콜백
      function fn_callback_pop_apply_influencer(data) {
        if($('.influencerNm').children().is('button')) {
          Dmall.LayerUtil.alert('이미 인플루언서가 등록되어 있습니다.<br/>기존 인플루언서를 삭제 후 진행 바랍니다.');
        } else {
          var template =
                  '<input type="hidden" name="memberNo" value="' + this.memberNo + '">' +
                  '<span class="txt">' + this.memberNn + '</span>' +
                  '<button class="cancel">삭제</button>';
          $('.influencerNm').html(template);
        }
      }

      // 상품찾기 버튼 클릭
      function fn_goods_srch(obj) {
        Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
        GoodsSelectPopup._init( fn_callback_pop_apply_goods );
        getBrandOptionValue(jQuery('#searchBrand'));
        $("#btn_popup_goods_search").trigger("click");
      }

      // 상품찾기 팝업 콜백
      function fn_callback_pop_apply_goods(data) {
        var $sel_apply_goods_list = $("#tbody_recommend_data");

        // 상품 등록 갯수 제한
        if($sel_apply_goods_list.children('tr').length > 2) {
          Dmall.LayerUtil.alert('상품은 2개 이상 등록할 수 없습니다.');
          return false;
        }

        // 선택 중복 체크
        for(var i = 0; i <= $sel_apply_goods_list.children('tr').length; i++){
          if( $sel_apply_goods_list.children('tr').children('td').children('label').children('span').children('input').eq(i).prop('value') == data['goodsNo']){
            Dmall.LayerUtil.alert("이미 선택하셨습니다");
            return false;
          }
        }
        var index = $sel_apply_goods_list.children('tr').length;
        console.log("fn_callback_pop_apply_keyword_goods index = ", index);
        if(index === 1){
          $("#goods_search_empty").hide();
          $("#goods_search_exist").show();
        }

        var template  = '<tr id="tr_goods_' + data["goodsNo"] + '" class="searchGoodsResult">'+
                '<td>' +
                '<input type="hidden" name="recommendNo" value="' + data["goodsNo"] + '">' +
                '<label for="chk_recommendNo_' + index + '" class="chack"><span class="ico_comm">' +
                '<input type="checkbox" id="chk_recommendNo_' + index + '" class="blind">' +
                '</span></label></td>'+
                '<td>' + index + '</td>'+
                '<td><img src=' + data["goodsImg02"] + '></td>'+
                '<td>' + data["goodsNm"] + '</td>'+
                '<td>' + data["goodsNo"] + '</td>'+
                '<td>' + data["brandNm"] + '</td>'+
                '<td>' + data["sellerNm"] + '</td>'+
                '<td>' + Dmall.common.numberWithCommas(data["salePrice"]) + '</td>'+
                '<td>' + Dmall.common.numberWithCommas(data["supplyPrice"]) + '</td>'+
                '<td>' + Dmall.common.numberWithCommas(data["stockQtt"]) + '</td>'+
                '<td>' + data["goodsSaleStatusNm"] + '</td>'+
                '<td>' + data["erpItmCode"] + '</td>'+
                '</tr>';

        $sel_apply_goods_list.append(template);

        // 총 갯수 처리
        var cnt_total = index;
        $("#cnt_total").html(cnt_total);
      }

      // 상품찾기 팝업 브랜드 정보 세팅
      function getBrandOptionValue($sel) {
        var url = '/admin/goods/brand-list',
                param = '';

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
          if (result == null || result.success != true) {
            return;
          }

          var sortData = result.resultList;
          sortData.sort(function(a,b){
            return (a.brandNm < b.brandNm) ? -1 : (a.brandNm > b.brandNm) ? 1 : 0;
          });

          // 취득결과 셋팅
          jQuery.each(sortData, function(idx, obj) {
            var selectedValue = $('#sel_brand').data('searchBrand');
            if (selectedValue && selectedValue === obj.brandNo) {
              $sel.append('<option value="'+ obj.brandNo + '" selected>'+ obj.brandNm + '</option>');
              $('label[for='+ $sel.attr('id') +']', $sel.parent()).html(obj.brandNm);
            } else {
              $sel.append('<option value="'+ obj.brandNo + '">' + obj.brandNm + '</option>');
            }
          });
        });
      }
    </script>
  </t:putAttribute>
  <t:putAttribute name="content">
    <div class="sec01_box">
      <div class="tlt_box">
        <div class="tlt_head">
          게시물 설정<span class="step_bar"></span>
        </div>
        <h2 class="tlth2">스타일 픽</h2>
      </div>
      <!-- line_box -->
      <div class="line_box fri pb">
        <!-- tblw -->
        <form id="form_stylepick_info" method="post">
          <input type="hidden" name="bbsId" value="${so.bbsId}"/>
          <input type="hidden" name="lettNo" value="${so.lettNo}"/>
          <div class="tblw tblmany">
          <table summary="이 표는 스타일픽 등록 표입니다.">
            <caption>상품 기본정보</caption>
            <colgroup>
              <col width="15%">
              <col width="85%">
            </colgroup>
            <tbody>
            <tr>
              <th>인플루언서</th>
              <td>
                <span class="influencerNm mr5"></span>
                <button class="filebtn on" id="influencer_srch_btn">인플루언서 찾기</button>
              </td>
            </tr>
            <tr>
              <th>이미지 첨부</th>
              <td>
                <span class="intxt imgup2"><input type="text" class="upload-name" disabled></span>
                <label class="filebtn on">파일첨부
                  <input type="file" class="filebox" name="file1" accept="image/*">
                </label>
                <span class="desc">· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )</span>
                <div class="upload_file preview_file1"></div>
                <span class="intxt imgup2"><input type="text" class="upload-name" disabled></span>
                <label class="filebtn on">파일첨부
                  <input type="file" class="filebox" name="file2" accept="image/*">
                </label>
                <div class="upload_file preview_file2"></div>
                <span class="intxt imgup2"><input type="text" class="upload-name" disabled></span>
                <label class="filebtn on">파일첨부
                  <input type="file" class="filebox" name="file3" accept="image/*">
                </label>
                <div class="upload_file preview_file3"></div>
                <span class="intxt imgup2"><input type="text" class="upload-name" disabled></span>
                <label class="filebtn on">파일첨부
                  <input type="file" class="filebox" name="file4" accept="image/*">
                </label>
                <div class="upload_file preview_file4"></div>
                <span class="intxt imgup2"><input type="text" class="upload-name" disabled></span>
                <label class="filebtn on">파일첨부
                  <input type="file" class="filebox" name="file5" accept="image/*">
                </label>
                <div class="upload_file preview_file5"></div>
              </td>
            </tr>
            <tr>
              <th>이미지 비율</th>
              <td>
                <cd:radioUDV codeGrp="IMG_RATIO_GB_CD" name="imgRatioGbCd" idPrefix="imgRatioGbCd" />
              </td>
            </tr>
            <tr>
              <th>내용</th>
              <td>
                <div class="txt_area">
                  <textarea name="content" cols="30" rows="10" maxlength="300"></textarea>
                </div>
              </td>
            </tr>
            <tr>
              <th>상품 설정</th>
              <td id="goods_search_empty">
                <button type="button" class="btn--black_small goods" onclick="fn_goods_srch(this)">상품 찾기</button>
              </td>
              <td id="goods_search_exist" style="display: none;">
                <div class="top_lay">
                  <div class="select_btn_left">
                    <a href="#none" class="btn_gray2" id="btn_check_delete">삭제</a>
                  </div>
                  <div class="select_btn_right">
                      <span class="search_txt">
                      총 <strong class="be" id="cnt_total">2</strong>개의 상품이 등록되었습니다.
                      </span>
                    <span class="btn_box">
                        <button type="button" class="btn--black_small goods" onclick="fn_goods_srch(this)">상품 찾기</button>
                      </span>
                  </div>
                </div>
                <div class="tblh">
                  <table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                    <caption>판매상품관리 리스트</caption>
                    <colgroup>
                      <col width="66px">
                      <col width="66px">
                      <col width="100px">
                      <col width="15%">
                      <col width="12%">
                      <col width="10%">
                      <col width="10%">
                      <col width="10%">
                      <col width="10%">
                      <col width="10%">
                      <col width="10%">
                      <col width="12%">
                    </colgroup>
                    <thead>
                    <tr>
                      <th>
                        <label for="check01" class="chack">
                          <span class="ico_comm"><input type="checkbox" name="table" id="check01" /></span>
                        </label>
                      </th>
                      <th>번호</th>
                      <th>이미지</th>
                      <th>상품명</th>
                      <th>상품코드</th>
                      <th>브랜드</th>
                      <th>판매자</th>
                      <th>판매가</th>
                      <th>공급가</th>
                      <th>재고</th>
                      <th>판매상태</th>
                      <th>다비전<br>상품코드</th>
                    </tr>
                    </thead>
                    <tbody id="tbody_recommend_data">
                    <tr id="tr_goods_data_template" style="display: none;">
                      <td data-bind="goodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="setGoodsChkBox">
                        <label for="chk_select_goods_template" class="chack"><span class="ico_comm"><input type="checkbox" id="chk_select_goods_template" class="blind">&nbsp;</span></label>
                      </td>
                      <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="rownum" >1</td>
                      <td><img src="" data-bind="goodsInfo" data-bind-type="img" data-bind-value="goodsImg01"></td>

                      <td class="txtl" data-bind="goodsInfo" data-bind-type="function" data-bind-function="setGoodsDetail" data-bind-value="goodsNm"></td>
                      <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNo">상품코드</td>
                      <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="brandNm" >브렌드명</td>
                      <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sellerNm" >판매자명</td>
                      <td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSalePrice"  data-bind-value="salePrice" data-validation-engine="validate[required, maxSize[10]]" maxlength="10"></td>
                      <td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setSupplyPrice"  data-bind-value="supplyPrice" data-validation-engine="validate[required, maxSize[10]]" maxlength="10"></td>
                      <td data-bind="goodsInfo" data-bind-type="function" data-bind-function="setStockQtt"  data-bind-value="stockQtt" data-validation-engine="validate[required, maxSize[10]]" maxlength="10"></td>
                      <td data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusText">
                        <input type="hidden" data-bind="goodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="setGoodsStatusInput">
                      </td>
                      <c:if test="${sellerNo eq '1'}">
                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
                      </c:if>
                    </tr>
                    </tbody>
                  </table>
                </div>
              </td>
            </tr>
            <tr>
              <th>댓글 노출 설정</th>
              <td>
                <cd:radioUDV codeGrp="CMNT_DISP_GB_CD" name="cmntDispGbCd" idPrefix="cmntDispGbCd" check="false"/>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
        </form>
        <form id="form_id_bbsCmnt">
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
            <table style="table-layout: fixed" summary="스타일 픽 댓글 리스트표 입니다. 구성은 체크박스,번호,닉네임,댓글, 등록일시,관리 입니다.">
              <caption>
                스타일 픽_댓글 목록
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
                  <label for="check02" class="chack">
                    <span class="ico_comm">
                        <input type="checkbox" name="table" id="check02"/>
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
        </form>
      </div>
    </div>
    <!-- bottom_box -->
    <div class="bottom_box">
      <div class="left">
        <button class="btn--big btn--big-white" id="viewBbsLettList">목록</button>
      </div>
      <div class="right">
        <button class="btn--blue-round" id="bbsLettListUpdate">수정</button>
      </div>
    </div>
    <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
    <jsp:include page="/WEB-INF/include/popup/influencerSelectPopup.jsp" />
  </t:putAttribute>
</t:insertDefinition>