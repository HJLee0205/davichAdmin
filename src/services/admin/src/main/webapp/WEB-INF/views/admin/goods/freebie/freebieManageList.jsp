<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 상품 &gt; 사은품관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 사은품 목록 조회
                FreebieUtil.getListData();

                // 검색
                $('#btn_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#hd_page').val('1');
                    FreebieUtil.getListData();
                });

                // 엑셀 다운로드
                $('#btn_download').on('click', function() {
                    FreebieUtil.downloadExcel();
                });

                // 선택삭제
                $('#selected_delete').on('click', function() {
                    FreebieUtil.deleteSelected();
                });

                // 사용
                $('#selected_useY').on('click', function() {
                    FreebieUtil.updateSelected('Y');
                });

                // 미사용
                $('#selected_useN').on('click', function() {
                    FreebieUtil.updateSelected('N');
                });

                // 사은품 등록
                $('#btn_regist').on('click', function() {
                    Dmall.FormUtil.submit('/admin/goods/freebie-detail', {procType: 'I'});
                });

                // 수정/복사
                $(document).on('click', '#tbody_freebie_data a.btn_gray', function () {
                    if($(this).text() == '수정') {
                        var param = $(this).closest('td').siblings().eq(0).find('input:checkbox[name=chkFreebieNo]').val();
                        Dmall.FormUtil.submit('/admin/goods/freebie-detail', {freebieNo: param, procType: 'U'});
                    } else {
                        var url = '/admin/goods/copy-freebie-contents';

                        var freebieNo = $(this).closest('td').siblings().eq(0).find('input:checkbox[name=chkFreebieNo]').val();
                        var param = {freebieNo: freebieNo};

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            Dmall.FormUtil.submit('/admin/goods/freebie-detail', {freebieNo: result, procType: 'U'});
                        });
                    }
                });
            });

            var FreebieUtil = {
                getListData: function() {
                    var url = '/admin/goods/freebie-list',
                        param = $('#form_id_search').serialize(),
                        dfd = $.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                                '<tr>' +
                                    '<td>' +
                                        '<label for="chk_freebieNo_{{freebieNo}}" class="chack"><span class="ico_comm">' +
                                        '<input type="checkbox" name="chkFreebieNo" id="chk_freebieNo_{{freebieNo}}" value="{{freebieNo}}" class="blind">' +
                                        '</span></label>' +
                                    '</td>' +
                                    '<td>{{rowNum}}</td>' +
                                    '<td><img src="${_IMAGE_DOMAIN}/image/image-view?type=FREEBIEDTL&id1={{imgPath}}_{{imgNm}}" alt="{{imgNm}}"></td>' +
                                    '<td>{{freebieNm}}</td>' +
                                    '<td>{{freebieNo}}</td>' +
                                    '<td>{{useNm}}</td>' +
                                    '<td>' +
                                        '<a href="#none" class="btn_gray mr5">수정</a>' +
                                        '<a href="#none" class="btn_gray mr5">복사</a>' +
                                    '</td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if (tr == '') {
                            tr = '<tr><td colspan="7">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_freebie_data').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_freebie_list', FreebieUtil.getListData);

                        $('#cnt_total').text(result.filterdRows);
                    });
                },
                downloadExcel: function() {
                    $('#form_id_search').attr('action', '/admin/goods/freebie-excel-download');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '/admin/goods/freebie');
                },
                deleteSelected: function() {
                    var selected = [];
                    $('input:checkbox[name=chkFreebieNo]:checked').each(function() {
                        selected.push($(this).val());
                    });

                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해주세요.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 사은품은 복구할 수 없습니다.<br>정말 삭제하시겠습니까?', function () {
                        var url = '/admin/goods/check-freebie-delete',
                            param = {paramFreebieNo: selected};

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if (result.success) {
                                FreebieUtil.getListData();
                            }
                        });
                    });
                },
                updateSelected: function(use) {
                    var selected = [];
                    $('input:checkbox[name=chkFreebieNo]:checked').each(function () {
                        selected.push($(this).val());
                    });

                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('변경할 데이터를 체크해주세요.');
                        return;
                    }

                    var url = '/admin/goods/check-freebie-update',
                        param = {paramFreebieNo: selected, useYn: use};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result.success) {
                            FreebieUtil.getListData();
                        }
                    });
                }
            }
        </script>
        <script type="text/javascript">
            $(document).ready(function() {
                return;
                FreebieInitUtil.init();

                // 검색일자 기본값 선택
                $('#btn_cal_3').trigger('click');
                $('#hd_page').val('1');
                FreebieRenderUtil.renderList();

                // 검색버튼
                $('#btn_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    $('#hd_page').val('1');
                    FreebieRenderUtil.renderList();
                });
                
                // 정렬순서 변경 변경시 이벤트
                $('#sel_sord').on('change', function(e) {
                    $('#hd_srod').val($(this).val());
                    FreebieRenderUtil.renderList();
                });
             
                // 표시갯수 변경 변경시 이벤트
                $('#sel_rows').on('change', function(e) {
                    $('#hd_page').val('1');
                    $('#hd_rows').val($(this).val());
                    FreebieRenderUtil.renderList();
                });
                
                // 엑셀 다운로드 버튼
                $('#btn_download').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    FreebieUtil.excelDownload();
                });
                
                // 선택 삭제
                $('#btn_check_delete').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    FreebieUtil.confirmDelete();
                });
            });

            var FreebieInitUtil = {
                init:function() {
                    $(".chack").on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        var $this = $(this),
                            $input = $("#" + $this.attr("for")),
                            checked = !($input.prop('checked'));

                        $input.prop('checked', checked);
                        $this.toggleClass('on');
                    });
                }
                , defaultValue:function() {
                    $('#hd_srod').val($('#sel_sord').val());
                    $('#hd_rows').val($('#sel_rows').val());
                }
            };
            
            var FreebieBtnUtil = {
                btnHandler:function() {
                    $('.row-chack').on('click', function(e){
                        Dmall.EventUtil.stopAnchorAction(e);
                        var $this = $(this),
                            $input = $("#" + $this.attr("for")),
                            checked = !($input.prop('checked'));
                        
                        $input.prop('checked', checked);
                        $this.toggleClass('on');
                    });
                    
                    //수정, 삭제버튼 핸들러는 DOM이 모두 그려지고 난뒤에 호출
                    // 단일 삭제 버튼
                    $('.deleteBtn').on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        FreebieUtil.directDelete(this);
                    });
                    
                    // 수정버튼
                    $('.updateBtn').on('click', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        location.href='/admin/goods/freebie-detail?freebieNo='+$(this).attr('data-freebie-no');
                    });
                }
            };
            
            var FreebieRenderUtil = {
                renderList:function() {
                    // 페이징 관련 초기화
                    FreebieInitUtil.defaultValue();
                    
                    var url = '/admin/goods/freebie-list',
                        param = $('#form_id_search').serialize(),
                        dfd = $.Deferred();
        
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }
                        
                        $("#cnt_search").html('0');
                        
                        //아래 chk_select_freebie_template값은 바뀔것이다(id는 중복될수 없다)
                        var template = '<tr>'+
                                           '<td><input type="checkbox" id="chk_freebieNo_{{freebieNo}}" name="chkFreebieNo" value="{{freebieNo}}" class="blind"><label for="chk_freebieNo_{{freebieNo}}" class="chack mr20 row-chack"><span class="ico_comm">&nbsp;</span></label></td>'+
                                           '<td>{{rowNum}}</td>'+
                                           '<td><img src="{{freebieNo}}"></td>'+
                                           '<td class="txtl"><a href="/admin/goods/freebie-detail?freebieNo={{freebieNo}}" class="tbl_link">{{freebieNm}}</a></td>'+
                                           '<td>{{freebieNo}}</td>'+
                                           '<td>{{useNm}}</td>'+
                                           '<td>'+
                                               '<button class="btn_gray updateBtn" data-freebie-no="{{freebieNo}}">수정</button>'+
                                               '<a href="#none" class="btn_gray deleteBtn" data-freebie-no="{{freebieNo}}" style="margin-left:5px">삭제</a>'+
                                           '</td>'+
                                       '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';
        
                        $.each(result.resultList, function(idx, obj) {
                            tr += managerGroup.render(obj);
                        });
                        
                        if(tr == '') {
                            tr = '<tr><td colspan="7">데이터가 없습니다.</td></tr>';
                        }
                        
                        $('#tbody_freebie_data').html(tr);
                        dfd.resolve(result.resultList);

                        // 총 갯수 처리
                        var cnt_total = result["totalRows"],
                            cnt_total = null == cnt_total ? 0 : cnt_total;
                        $("#cnt_total").html(cnt_total);
                        
                        // 페이징 처리
                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_freebie_list', FreebieRenderUtil.renderList);
                        FreebieBtnUtil.btnHandler();
                    });
                    return dfd.promise();
                }
            };
            
            // var FreebieUtil = {
            //     checkedList:[]
            //     , confirmDelete:function() {
            //         var selected = [];
            //         $('#tbody_freebie_data input:checkbox').each(function() {
            //             if($(this).prop('checked')) {
            //                 selected.push($(this).val());
            //             }
            //         });
            //
            //         if (selected.length < 1) {
            //             Dmall.LayerUtil.alert('선택된 사은품이 없습니다.');
            //             return;
            //         }
            //
            //         FreebieUtil.checkedList = selected;
            //         Dmall.LayerUtil.confirm('삭제하시겠습니까?', FreebieUtil.checkDelete);
            //     }
            //     , checkDelete:function() {
            //         var url = '/admin/goods/check-freebie-delete';
            //         var param = {'paramFreebieNo':FreebieUtil.checkedList}
            //
            //         Dmall.AjaxUtil.getJSON(url, param, function(result) {
            //             if(result.success){
            //                 $('#btn_cal_3').trigger('click');
            //                 FreebieRenderUtil.renderList();
            //             }
            //         });
            //     }
            //     , directDelete:function(obj) {
            //         Dmall.LayerUtil.confirm('삭제하시겠습니까?', function() {
            //             var url = '/admin/goods/freebie-delete';
            //             var param = {'freebieNo':$(obj).attr('data-freebie-no')};
            //
            //             Dmall.AjaxUtil.getJSON(url, param, function(result) {
            //                 if(result.success){
            //                     $('#btn_cal_3').trigger('click');
            //                     FreebieRenderUtil.renderList();
            //                 }
            //             });
            //         });
            //     }
            //     , excelDownload:function() {
            //         $('#form_id_search').attr('action', '/admin/goods/freebie-excel-download');
            //         $('#form_id_search').submit();
            //         $('#form_id_search').attr('action', '/admin/goods/freebie');
            //     }
            //     ,
            // };
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">사은품 관리 </h2>
            </div>
            <div class="search_box_wrap">
                <form:form id="form_id_search" >
                <input type="hidden" name="page" id="hd_page" value="1" />
                <input type="hidden" name="sord" id="hd_srod" value="" />
                <input type="hidden" name="rows" id="hd_rows" value="" />
                <input type="hidden" name="searchType" id="sel_search_type" value="1" />
                <!-- search_box -->
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 사은품 관리 검색 표 입니다. 구성은 등록일, 판매상태, 전시상태, 검색어 입니다.">
                            <caption>사은품 관리 검색</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>사은품 등록일</th>
                                    <td>
                                        <tags:calendar from="searchDateFrom" to="searchDateTo" idPrefix="srch" hasTotal="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>사은품 상태</th>
                                    <td>
                                        <tags:radio codeStr=":전체;Y:사용;N:미사용" name="useYn" idPrefix="useYn" value=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>사은품 코드</th>
                                    <td>
                                        <span class="intxt long">
                                            <input type="text" name="searchCode" id="txt_search_code">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt wid100p">
                                            <input type="text" name="searchWord" id="txt_search_word">
                                        </span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <button id="btn_search" class="btn green">검색</button>
                    </div>
                </div>
                <!-- //search_box -->
                </form:form>
                <!-- line_box -->
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total"></strong>개의 사은품이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="btn_download">
                                <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                            </button>
                        </div>
                    </div>
                    <div class="tblh">
                        <table summary="이표는 사은품 관리 리스트 표 입니다. 구성은 체크박스, 선택, 번호, 사은품명, 재고, 등록일, 수정일, 판매상태, 전시상태, 관리 입니다.">
                            <caption>사은품 관리 리스트</caption>
                            <colgroup>
                                <col width="50px">
                                <col width="7%">
                                <col width="100px">
                                <col width="40%">
                                <col width="">
                                <col width="">
                                <col width="200px">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="allcheck" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="allcheck"></span>
                                    </label>
                                </th>
                                <th>No</th>
                                <th>이미지</th>
                                <th>사은품명</th>
                                <th>사은품코드</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_freebie_data"></tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <div class="pageing"  id="div_id_paging"></div>
                    </div>
                </div>
                <!-- //line_box -->

                <div class="bottom_box">
                    <div class="left">
                        <div class="pop_btn">
                            <button class="btn--big btn--big-white" id="selected_delete">선택 삭제</button>
                            <button class="btn--big btn--big-white" id="selected_useY">사용</button>
                            <button class="btn--big btn--big-white" id="selected_useN">미사용</button>
                        </div>
                    </div>
                    <div class="right">
                        <button class="btn--blue-round" id="btn_regist">사은품 등록</button>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>