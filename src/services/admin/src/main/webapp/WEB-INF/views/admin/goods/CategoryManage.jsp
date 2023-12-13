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
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">카테고리관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            var prDiv = null;

            $(document).ready(function() {
                ctgUtil.init();
                fileUtil.init();

                ctgUtil.selectCtgList();
            });

            var ctgUtil = {
                init: function() {
                    // 카테고리 추가
                    $('#ctgInsBtn').on('click', function() {
                        if(!prDiv) {
                            Dmall.LayerUtil.alert("카테고리를 선택하여 주십시오.");
                            return;
                        }
                        var goodsTypeCd;
                        console.log("ctgInsBtn prDiv id = ", prDiv.attr('id'));
                            if(prDiv.attr('id') == 'd1_div') {
                                goodsTypeCd = $('#dv1GoodsTypeCd').val();
                            } else {
                                goodsTypeCd = $('#dv2GoodsTypeCd').val();
                            }
                        console.log("ctgInsBtn goodsTypeCd = ", goodsTypeCd);
                        Dmall.LayerPopupUtil.open($("#categoryInsLayer"));
                        openCtgInsLayer(prDiv.find("#prCtgLvl").val(), prDiv.find("#prUpCtgNo").val(), prDiv.find("#prUpCtgNm").val(), prDiv.find("#ctgType").val(), goodsTypeCd);
                    });

                    // 삭제
                    $('#delCtgBtn').on('click', function() {
                        if(!prDiv) {
                            Dmall.LayerUtil.alert("카테고리를 선택하여 주십시오.");
                            return;
                        }

                        var selected = $('#ctgTree').jstree('get_selected');
                        var selectedNode = $('#ctgTree').jstree('get_node', selected[0]);
                        if(prDiv.attr('id') == 'd1_div') {
                            if ($("#dv1CtgRequire").val() === "M") {
                                Dmall.LayerUtil.alert("해당 카테고리는 삭제할 수 없습니다.");
                                return false;
                            }
                        } else {
                            if ($("#dv2CtgRequire").val() === "M") {
                                Dmall.LayerUtil.alert("해당 카테고리는 삭제할 수 없습니다.");
                                return false;
                            }
                        }
                        if(selectedNode.parent == '#') {
                            Dmall.LayerUtil.alert("해당 카테고리는 삭제할 수 없습니다.");
                            return;
                        }

                        var url = '/admin/goods/category-goods-coupon';
                        var param = {ctgNo : prDiv.find('#ctgNo').val()};

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.message){
                                return;
                            }
                            // 카테고리 적용된 상품 검증
                            if(result.ctgGoodsCnt > 0){
                                Dmall.LayerUtil.alert('해당 카테고리에 등록된 상품이 존재해 삭제할 수 없습니다.');
                                return;
                            }
                            // 카테고리 적용된 쿠폰 검증
                            if(result.cpCnt > 0){
                                Dmall.LayerUtil.alert('해당 카테고리에 등록된 쿠폰이 존재해 삭제할 수 없습니다.');
                                return;
                            }

                            Dmall.LayerUtil.confirm('삭제하시겠습니까?', function(){
                                var deleteUrl = '/admin/goods/category-delete';
                                Dmall.AjaxUtil.getJSON(deleteUrl, param, function(result) {
                                    if(result.success){
                                        location.reload();
                                    }
                                });
                            });
                        });
                    });

                    // 저장
                    $('#btn_regist').on('click', function() {
                        if(prDiv.find('#ctgNo').val() == null || prDiv.find('#ctgNo').val() == '') {
                            Dmall.LayerUtil.alert("카테고리를 선택하여 주십시오.");
                            return;
                        }

                        var url = '/admin/goods/category-update';
                        // var param = prDiv.parent('form').serialize();
                        // console.log("btn_regist param = ", param);
                        if(prDiv.find('#ctgLvl').val() == '1') {
                            prDiv.parent('form').ajaxSubmit({
                                url: url,
                                dataType: 'json',
                                success: function(result) {
                                    if(result.success) {
                                        Dmall.LayerUtil.alert(result.message).done(function() {
                                            location.reload();
                                        });
                                    }
                                }
                            });
                        } else {
                            var param = prDiv.parent('form').serialize();
                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                    location.reload();
                                }
                            });
                        }
                    });
                },
                selectCtgList: function() {
                    var url = '/admin/goods/category-list',
                        param = '';

                    Dmall.AjaxUtil.getJSON(url, param, ctgUtil.setCtgList);
                },
                setCtgList: function(result) {
                    console.log("category result = ", result);
                    $('#ctgTree').jstree({
                        'core' : {
                            'themes' : { 'classic' : true },
                            'data' : result,
                            'icons' : false,
                            'check_callback' :  function (op, node, par, pos, more) {

                                if ((op === "move_node" || op === "copy_node") && node.type && node.type == "root"  || node.original.ctgRequire === "M") {
                                    return false;
                                }

                                /* if((op === "move_node" || op === "copy_node") && more && more.core && node.children.length > 0) {
                                    alert("자식 카테고리가 존재합니다.");
                                    return false;
                                } */
                                if((op === "move_node" || op === "copy_node") && more && more.core) {
                                    // console.log("parent = ", par);
                                    // console.log("my = ", node);
                                    var upCtgNo = par.id;
                                    if(upCtgNo === '#') {
                                        Dmall.LayerUtil.alert("최상위 카테고리 정보는 변경 수 없습니다.");
                                        return false;
                                    }
                                }
                                if((op === "move_node" || op === "copy_node") && more && more.core
                                    && !Dmall.LayerUtil.confirm('순서를 변경하시겠습니까?',
                                        function() {
                                            //카테고리 순서 저장
                                            var ctgNo = node.id; //자신 ID
                                            var upCtgNo = par.id; //상위 ID
                                            var downCtgNo = (node.children_d).toString(); //하위 ID
                                            var orgCtgLvl = Number(node.original.ctgLvl);  //변경 전 자신 LEVEL
                                            var ctgLvl = Number(par.original.ctgLvl)+1; //변경 후 자신 LEVEL ( = 하위 LEVEL +1)
                                            var sortSeq = pos+1; //변경할 위치
                                            var goodsTypeCd = (par.original.goodsTypeCd).toString();
                                            // console.log("goodsTypeCd = ", goodsTypeCd);
                                            // console.log("my = ", node);
                                            // console.log(downCtgNo);
                                            // console.log("ctgNo: "+ctgNo+" | upCtgNo: "+upCtgNo+" | downCtgNo: "+downCtgNo+" | orgCtgLvl: "+orgCtgLvl+" | ctgLvl: "+ctgLvl+" | sortSeq: "+sortSeq)

                                            var url = '/admin/goods/category-sort',
                                                param = {ctgNo:ctgNo, upCtgNo:upCtgNo, downCtgNo:downCtgNo, orgCtgLvl:orgCtgLvl, ctgLvl:ctgLvl, sortSeq:sortSeq, goodsTypeCd:goodsTypeCd};
                                            // console.log("param = ", param);
                                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                                Dmall.validate.viewExceptionMessage(result, 'ctgMngForm');
                                                location.reload();
                                            });
                                        })){
                                    return false;
                                }

                                return true;
                            }
                        },
                        'plugins' : ['wholerow', 'dnd']
                    }).bind('select_node.jstree', function(event,data){       //선택 이벤트
                        data.instance.toggle_node(data.node);

                        var level = data.node.parents.length;

                        if(prDiv != null) {
                            // 상품 목록 초기화
                            prDiv.find('#goods_exist').find('tbody').children('tr').each(function(idx) {
                                if(idx != 0) {
                                    $(this).remove();
                                }
                            });

                            if(prDiv.find('#goods_exist').find('tbody').children('tr').length == 1) {
                                prDiv.find('#goods_empty').show();
                                prDiv.find('#goods_exist').hide();
                            }
                        }

                        if(level < 2) {
                            // 목록배너(PC) 초기화
                            $('#d1_div').find('#pc_banner').find('td').children('div').each(function(idx) {
                                if(idx == 0) {
                                    $(this).find('input[name=pcBannerImgNmArr]').val('');
                                    $(this).find('input[type=file]').val('');
                                    $(this).find('div.upload_file').html('');
                                } else {
                                    $(this).remove();
                                }
                            });
                            // 목록배너(MOBILE) 초기화
                            $('#d1_div').find('#mobile_banner').find('td').children('div').each(function(idx) {
                                if(idx == 0) {
                                    $(this).find('input[name=mobBannerImgNmArr]').val('');
                                    $(this).find('input[type=file]').val('');
                                    $(this).find('div.upload_file').html('');
                                } else {
                                    $(this).remove();
                                }
                            });
                            fileUtil.pcInputCnt = 1;
                            fileUtil.mobileInputCnt = 1;

                            $('#default_div').hide();
                            $('#d1_div').show();
                            $('#d2_div').hide();

                            prDiv = $('#d1_div');
                        } else {
                            $('#default_div').hide();
                            $('#d1_div').hide();
                            $('#d2_div').show();

                            prDiv = $('#d2_div');
                        }

                        console.log(data);

                        prDiv.find('#ctgNo').val(data.node.id);
                        prDiv.find('#prCtgLvl').val(level + 1);
                        prDiv.find('#prUpCtgNo').val(data.node.id);
                        prDiv.find('#prUpCtgNm').val(data.node.text);

                        console.log("id = ", data.node.id);
                        ctgUtil.selectCtgInfo(data.node.id);
                    });

                    //카테고리 트리 refresh
                    $('#ctgTree').jstree(true).settings.core.data = result;
                    $('#ctgTree').jstree(true).refresh();
                },
                selectCtgInfo: function(ctgNo) {
                    var url = '/admin/goods/category',
                        param = {ctgNo:ctgNo};

                    Dmall.AjaxUtil.getJSON(url, param, ctgUtil.setCtgInfoData);
                },
                setCtgInfoData: function(result) {
                    console.log("result.data = ", result.data);

                    if(prDiv.attr('id') == 'd1_div') {
                        //조회된 카테고리명 set
                        $('#td_ctgNm').text(result.data.ctgNm);
                        $('#ctgNo').text(result.data.ctgNo);
                        $('#dv1GoodsTypeCd').val(result.data.goodsTypeCd);
                        $("#dv1CtgRequire").val(result.data.ctgRequire);
                        // 목록배너
                        jQuery.each(result.data.imgList, function(idx, obj) {
                            if(obj.imgPath.includes('mobile')) {
                                // 첫번째 input이 비어있을 때 실행
                                if(!$('#mobile_banner').find('div.upload_file_wrap').eq(0).find('input[name=mobBannerImgNmArr]').val()) {
                                    var $pr = $('#mobile_banner').find('div.upload_file_wrap').eq(0);
                                    $pr.find('input[name=mobBannerImgNmArr]').val(obj.orgImgNm);
                                    var preview =
                                        '<span class="txt">'+obj.orgImgNm+'</span>' +
                                        '<button class="cancel">삭제</button><br>' +
                                        '<img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&path='+obj.imgPath+'&id1='+obj.imgNm+'" alt="미리보기 이미지">';
                                    $pr.find('div.upload_file').append(preview);
                                    return true;
                                }

                                var template =
                                    '<div class="upload_file_wrap">' +
                                    '<span class="intxt">' +
                                    '<input type="text" name="mobBannerImgNmArr" value="'+obj.orgImgNm+'" readonly>' +
                                    '</span>' +
                                    '<label for="mobBannerImgFile_'+(++fileUtil.mobileInputCnt)+'" class="filebtn">파일첨부</label>' +
                                    '<input type="file" name="mobBannerImgFile_'+(++fileUtil.mobileInputCnt)+'" id="mobBannerImgFile_'+(++fileUtil.mobileInputCnt)+'" class="filebox" accept="image/*">' +
                                    '<button class="btn_comm plus"></button>' +
                                    '<button class="btn_comm minus"></button>' +
                                    '<div class="desc_txt br2">' +
                                    '· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )<br>860px * 400px 사이즈로 등록하여 주세요.' +
                                    '</div>' +
                                    '<div class="upload_file">' +
                                    '<span class="txt">'+obj.orgImgNm+'</span>' +
                                    '<button class="cancel">삭제</button><br>' +
                                    '<img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&path='+obj.imgPath+'&id1='+obj.imgNm+'" alt="미리보기 이미지">' +
                                    '</div>' +
                                    '</div>';

                                $('#mobile_banner').children('td').append(template);
                            } else {
                                // 첫번째 input이 비어있을 때 실행
                                if(!$('#pc_banner').find('div.upload_file_wrap').eq(0).find('input[name=pcBannerImgNmArr]').val()) {
                                    var $pr = $('#pc_banner').find('div.upload_file_wrap').eq(0);
                                    $pr.find('input[name=pcBannerImgNmArr]').val(obj.orgImgNm);
                                    var preview =
                                        '<span class="txt">'+obj.orgImgNm+'</span>' +
                                        '<button class="cancel">삭제</button><br>' +
                                        '<img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&path='+obj.imgPath+'&id1='+obj.imgNm+'" alt="미리보기 이미지">';
                                    $pr.find('div.upload_file').append(preview);
                                    return true;
                                }

                                var template =
                                    '<div class="upload_file_wrap">' +
                                    '<span class="intxt">' +
                                    '<input type="text" name="pcBannerImgNmArr" value="'+obj.orgImgNm+'" readonly>' +
                                    '</span>' +
                                    '<label for="pcBannerImgFile_'+(++fileUtil.pcInputCnt)+'" class="filebtn">파일첨부</label>' +
                                    '<input type="file" name="pcBannerImgFile_'+(++fileUtil.pcInputCnt)+'" id="pcBannerImgFile_'+(++fileUtil.pcInputCnt)+'" class="filebox" accept="image/*">' +
                                    '<button class="btn_comm plus"></button>' +
                                    '<button class="btn_comm minus"></button>' +
                                    '<div class="desc_txt br2">' +
                                    '· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )<br>1920px * 600px 사이즈로 등록하여 주세요.' +
                                    '</div>' +
                                    '<div class="upload_file">' +
                                    '<span class="txt">'+obj.orgImgNm+'</span>' +
                                    '<button class="cancel">삭제</button><br>' +
                                    '<img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&path='+obj.imgPath+'&id1='+obj.imgNm+'" alt="미리보기 이미지">' +
                                    '</div>' +
                                    '</div>';

                                $('#pc_banner').children('td').append(template);
                            }
                        });
                        // 전시상품
                        jQuery.each(result.data.dispGoodsList, function(idx, obj) {
                            prDiv.find('#goods_empty').hide();
                            prDiv.find('#goods_exist').show();

                            idx += 1;
                            var template  =
                                '<tr id="tr_goods_'+obj.goodsNo+'" class="searchGoodsResult">'+
                                '<td>' +
                                '    <input type="hidden" name="goodsNoArr" value="'+ obj.goodsNo +'">' +
                                '    <label for="chk_recommendNo_' + idx + '" class="chack">' +
                                '        <span class="ico_comm">' +
                                '            <input type="checkbox" id="chk_recommendNo_' + idx + '" class="blind">' +
                                '        </span>' +
                                '    </label>' +
                                '</td>'+
                                '<td>' + idx + '</td>'+
                                '<td><img src=' + obj.goodsImg02 + '></td>'+
                                '<td>' + obj.goodsNm + '</td>'+
                                '<td>' + obj.goodsNo + '</td>'+
                                '<td>' + obj.brandNm + '</td>'+
                                '<td>' + obj.sellerNm + '</td>'+
                                '<td>' + Dmall.common.numberWithCommas(obj.salePrice) + '</td>'+
                                '<td>' + Dmall.common.numberWithCommas(obj.stockQtt) + '</td>'+
                                '<td>' + obj.goodsSaleStatusNm + '</td>'+
                                '<td>' + obj.erpItmCode + '</td>'+
                                '</tr>';

                            prDiv.find('#tbody_goods_data').append(template);
                        });
                        prDiv.find('#cnt_total').text(result.data.dispGoodsList.length);
                    } else {
                        //조회된 카테고리명 set
                        if(result.data.ctgRequire == 'M') {
                            $('#td_dv2CtgNm').html(result.data.ctgNm);
                        } else {
                            $('#td_dv2CtgNm').html(
                                '<span class="intxt wid50p">' +
                                '<input type="text" id="ctgNm" name="ctgNm" maxlength="10" value="'+ result.data.ctgNm +'">' +
                                '</span>'
                            )
                        }
                        $('#dv2GoodsTypeCd').val(result.data.goodsTypeCd);
                        $("#dv2CtgRequire").val(result.data.ctgRequire);
                    }

                    // hidden 필드
                    prDiv.find('#ctgDispzoneNo').val(result.data.ctgDispzoneNo);
                    // 컨텐츠 구분
                    prDiv.find('input:radio[name=goodsContsGbCd][value='+ result.data.goodsContsGbCd +']').trigger('click');
                    // 사용여부
                    prDiv.find('input:radio[name=useYn][value='+ result.data.useYn +']').trigger('click');
                },
            }

            var fileUtil = {
                pcInputCnt: 1,
                mobileInputCnt: 1,
                input: null,
                init: function() {
                    // 파일첨부 input 추가
                    $(document).on('click', '#d1_div button.plus', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        if($(this).parents('td').children().length < 5) {
                            var type = '';
                            var idx = '';
                            var desc = '';

                            if($(this).parents('tr').attr('id') == 'pc_banner') {
                                idx = ++fileUtil.pcInputCnt;
                                type = 'pc';
                                desc = '· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )<br>1920px * 600px 사이즈로 등록하여 주세요.';
                            } else {
                                idx = ++fileUtil.mobileInputCnt;
                                type = 'mob';
                                desc = '· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )<br>860px * 400px 사이즈로 등록하여 주세요.';
                            }

                            var template =
                                '<div class="upload_file_wrap">' +
                                '<span class="intxt">' +
                                '<input type="text" name="'+type+'BannerImgNmArr" readonly>' +
                                '</span>' +
                                '<label for="'+type+'BannerImgFile_'+idx+'" class="filebtn">파일첨부</label>' +
                                '<input type="file" name="'+type+'BannerImgFile_'+idx+'" id="'+type+'BannerImgFile_'+idx+'" class="filebox" accept="image/*">' +
                                '<button class="btn_comm plus"></button>' +
                                '<button class="btn_comm minus"></button>' +
                                '<div class="desc_txt br2">' +
                                desc +
                                '</div>' +
                                '<div class="upload_file"></div>' +
                                '</div>';

                            $(this).parents('td').append(template);
                        }
                    });

                    // 파일첨부 input 제거
                    $(document).on('click', '#d1_div button.minus', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        $(this).parent('div.upload_file_wrap').remove();
                    });

                    // 파일첨부 미리보기
                    $(document).on('click', '#d1_div input[type=file]', function(e) {
                        fileUtil.input = $(this);
                    });
                    $(document).on('change', '#d1_div input[type=file]', function(e) {
                        Dmall.EventUtil.stopAnchorAction(e);

                        if($(this)[0].files.length < 1) {
                            fileUtil.input.siblings('div.upload_file').html('');
                        }

                        if(this.files && this.files[0]) {
                            var fileNm = this.files[0].name;
                            var reader = new FileReader();
                            reader.onload = function(e) {
                                var template =
                                    '<span class="txt">'+fileNm+'</span>' +
                                    '<button class="cancel">삭제</button><br>' +
                                    '<img src="'+e.target.result+'" alt="미리보기 이미지">';

                                fileUtil.input.siblings('div.upload_file').append(template);
                            };
                            reader.readAsDataURL(this.files[0]);

                            fileUtil.input.siblings('span.intxt').children('input').val(fileNm);
                        }
                    });

                    // 미리보기 삭제
                    $(document).on('click', 'div.upload_file button.cancel', function(e) {
                       Dmall.EventUtil.stopAnchorAction(e);

                       var $obj = $(e.target).parents('div.upload_file');
                       $obj.siblings('span.intxt').children('input').val('');
                       $obj.siblings('input[type=file]').val('');
                       $obj.html('');
                    });
                }
            }

            var goodsUtil = {
                showSrchPop: function(obj) {
                    Dmall.LayerPopupUtil.open($('#layer_popup_goods_select'));
                    GoodsSelectPopup._init(goodsUtil.callbackApply);
                    $('#btn_popup_goods_search').trigger('click');
                },
                callbackApply: function(data) {
                    var $goods_table = prDiv.find('#tbody_goods_data');
                    var index = $goods_table.children('tr').length;

                    // 1depth & 상품유형 검사
                    if(prDiv.attr('id') == 'd1_div') {
                        if($('#ctgNo').val() != 4) {
                            if(index > 2) {
                                Dmall.LayerUtil.alert('상품은 2개 이상 등록할 수 없습니다.');
                                return false;
                            }
                        } else {
                            if(index > 1) {
                                Dmall.LayerUtil.alert('상품은 1개 이상 등록할 수 없습니다.');
                                return false;
                            }
                        }
                    }

                    // 중복등록 검사
                    for(var i = 0; i <= index; i++){
                        if( $goods_table.children('tr').children('td').children('input').eq(i).prop('value') == data['goodsNo']){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }

                    if(index === 1) {
                        prDiv.find('#goods_empty').hide();
                        prDiv.find('#goods_exist').show();
                    }

                    var template  =
                        '<tr id="tr_goods_' + data["goodsNo"] + '" class="searchGoodsResult">'+
                        '<td>' +
                        '    <input type="hidden" name="goodsNoArr" value="' + data["goodsNo"] + '">' +
                        '    <label for="chk_recommendNo_' + index + '" class="chack">' +
                        '        <span class="ico_comm">' +
                        '            <input type="checkbox" id="chk_recommendNo_' + index + '" class="blind">' +
                        '        </span>' +
                        '    </label>' +
                        '</td>'+
                        '<td>' + index + '</td>'+
                        '<td><img src=' + data["goodsImg02"] + '></td>'+
                        '<td>' + data["goodsNm"] + '</td>'+
                        '<td>' + data["goodsNo"] + '</td>'+
                        '<td>' + data["brandNm"] + '</td>'+
                        '<td>' + data["sellerNm"] + '</td>'+
                        '<td>' + Dmall.common.numberWithCommas(data["salePrice"]) + '</td>'+
                        '<td>' + Dmall.common.numberWithCommas(data["stockQtt"]) + '</td>'+
                        '<td>' + data["goodsSaleStatusNm"] + '</td>'+
                        '<td>' + data["erpItmCode"] + '</td>'+
                        '</tr>';

                    $goods_table.append(template);

                    prDiv.find('#cnt_total').html(index);
                },
                delGoods: function() {
                    var $goods_table = prDiv.find('#tbody_goods_data');
                    $goods_table.children('tr').each(function() {
                        if($(this).find('label[for^=chk_recommendNo_]').hasClass('on')) {
                            $(this).remove();
                        }
                    });
                    var cnt_total = $goods_table.children('tr').length - 1;

                    for(var i = 0; i <= cnt_total; i++) {
                        $goods_table.children('tr').eq(i).children('td').eq(1).text(i);
                    }

                    prDiv.find('#cnt_total').html(cnt_total);

                    if(cnt_total === 0) {
                        prDiv.find('#goods_empty').show();
                        prDiv.find('#goods_exist').hide();
                    }
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">카테고리 관리</h2>
            </div>
            <div class="line_box fri pb">
                <div class="cate_con">
                    <div class="cate_left">
                        <a href="#categoryInsLayer" class="btn--white btn--icon" id="ctgInsBtn">카테고리 추가</a>
                        <a href="#" class="btn--white btn--small" id="delCtgBtn">삭제</a>
                        <span class="br2"></span>
                        <div class="left_con">
                            <div class="category_info" id="ctgTree"></div>
                        </div>
                    </div>
                    <div class="cate_right">
                        <div class="warning_txt" id="default_div">
                            카테고리 수정 & 삭제 시 기존에 적용된 상품에 오류가<br> 발생할 수 있으므로 관리자와 상의 후 진행바랍니다.<span class="br2"></span>
                            각 상품군의 하위 필터 등록이 가능합니다.<span class="br2"></span>
                            콘택트렌즈상품은 2Depth까지 고정으로 노출됩니다.
                        </div>

                        <form action="" id="d1_div_form" method="post">
                            <div class="tblw tblmany" style="display: none;" id="d1_div">
                                <input type="hidden" name="ctgNo" id="ctgNo">
                                <input type="hidden" name="ctgDispzoneNo" id="ctgDispzoneNo">
                                <input type="hidden" name="ctgLvl" id="ctgLvl" value="1">
                                <input type="hidden" name="prCtgLvl" id="prCtgLvl" />
                                <input type="hidden" name="prUpCtgNo" id="prUpCtgNo" />
                                <input type="hidden" name="prUpCtgNm" id="prUpCtgNm" />
                                <input type="hidden" name="goodsTypeCd" id="dv1GoodsTypeCd" />
                                <input type="hidden" name="ctgRequire" id="dv1CtgRequire" />
                                <table>
                                    <colgroup>
                                        <col width="20%" />
                                        <col width="80%" />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="txtc">구분</th>
                                        <td>
                                            <tags:radio codeStr="01:메뉴;02:콘텐츠" name="goodsContsGbCd" idPrefix="goodsContsGbCd"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="txtc">카테고리 명</th>
                                        <td id="td_ctgNm"></td>
                                    </tr>
                                    <tr id="pc_banner">
                                        <th class="txtc">상품 목록 배너<div>(PC)</div></th>
                                        <td>
                                            <div class="upload_file_wrap">
                                                <span class="intxt">
                                                    <input type="text" name="pcBannerImgNmArr" readonly>
                                                </span>
                                                <label for="pcBannerImgFile_1" class="filebtn">파일첨부</label>
                                                <input type="file" name="pcBannerImgFile_1" id="pcBannerImgFile_1" class="filebox" accept="image/*">
                                                <button class="btn_comm plus"></button>
                                                <div class="desc_txt br2">
                                                    · 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )<br>1920px * 600px 사이즈로 등록하여 주세요.
                                                </div>
                                                <div class="upload_file"></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="mobile_banner">
                                        <th class="txtc">상품 목록 배너<div>(MOBILE)</div></th>
                                        <td>
                                            <div class="upload_file_wrap">
                                                <span class="intxt">
                                                    <input type="text" name="mobBannerImgNmArr" readonly>
                                                </span>
                                                <label for="mobBannerImgFile_1" class="filebtn">파일첨부</label>
                                                <input type="file" name="mobBannerImgFile_1" id="mobBannerImgFile_1" class="filebox" accept="image/*">
                                                <button class="btn_comm plus"></button>
                                                <div class="desc_txt br2">
                                                    · 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )<br>860px * 400px 사이즈로 등록하여 주세요.
                                                </div>
                                                <div class="upload_file"></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="txtc">메뉴바 노출 상품 설정</th>
                                        <td id="goods_empty">
                                        <span class="btn_box">
                                            <a href="#none" class="btn--black_small goods" onclick="goodsUtil.showSrchPop(this);">상품 찾기</a>
                                        </span>
                                        </td>
                                        <td id="goods_exist" style="display:none;">
                                            <div class="top_lay">
                                                <div class="select_btn_left">
                                                    <a href="#none" class="btn_gray2" id="a_id_delete" onclick="goodsUtil.delGoods();">삭제</a>
                                                </div>
                                                <div class="select_btn_right">
                                                <span class="search_txt">
                                                    총 <strong class="all" id="cnt_total"></strong>개의 상품이 등록되었습니다.
                                                </span>
                                                    <span class="btn_box">
                                                    <a href="#none" class="btn--black_small goods" onclick="goodsUtil.showSrchPop(this);">상품 찾기</a>
                                                </span>
                                                </div>
                                            </div>
                                            <div class="tblh">
                                                <table>
                                                    <colgroup>
                                                        <col width="50px">
                                                        <col width="50px">
                                                        <col width="130px">
                                                        <col width="20%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="15%">
                                                    </colgroup>
                                                    <thead>
                                                    <tr>
                                                        <th>
                                                            <label for="allcheck" class="chack">
                                                                <span class="ico_comm"><input type="checkbox" name="table" id="allcheck"></span>
                                                            </label>
                                                        </th>
                                                        <th>번호</th>
                                                        <th>이미지</th>
                                                        <th>상품명</th>
                                                        <th>상품코드</th>
                                                        <th>브랜드</th>
                                                        <th>판매자</th>
                                                        <th>판매가</th>
                                                        <th>재고</th>
                                                        <th>판매상태</th>
                                                        <th>다비전 상품코드</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="tbody_goods_data">
                                                    <tr id="tr_goods_data_template" style="display: none;">
                                                        <td>
                                                            <label for="chk_select_goods_template" class="chack">
                                                                <span class="ico_comm"><input type="checkbox" id="chk_select_goods_template" class="blind"></span>
                                                            </label>
                                                        </td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="rownum"></td>
                                                        <td>
                                                            <img src="" alt="" data-bind="goodsInfo" data-bind-type="img" data-bind-value="goodsImg01">
                                                        </td>
                                                        <td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNm"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNo"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="brandNm"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sellerNm"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="salePrice"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="stockQtt"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsStatusNm"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="txtc">사용 여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </form>

                        <form action="" id="d2_div_form">
                            <div class="tblw tblmany" style="display: none;" id="d2_div">
                                <input type="hidden" name="ctgNo" id="ctgNo">
                                <input type="hidden" name="ctgDispzoneNo" id="ctgDispzoneNo">
                                <input type="hidden" name="ctgLvl" id="ctgLvl" value="2">
                                <input type="hidden" name="prCtgLvl" id="prCtgLvl" />
                                <input type="hidden" name="prUpCtgNo" id="prUpCtgNo" />
                                <input type="hidden" name="prUpCtgNm" id="prUpCtgNm" />
                                <input type="hidden" name="goodsTypeCd" id="dv2GoodsTypeCd" />
                                <input type="hidden" name="ctgRequire" id="dv2CtgRequire" />
                                <table>
                                    <colgroup>
                                        <col width="20%" />
                                        <col width="80%" />
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th class="txtc">구분</th>
                                        <td>
                                            <tags:radio codeStr="01:메뉴;02:콘텐츠" name="goodsContsGbCd" idPrefix="goodsContsGbCd"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="txtc">카테고리 명</th>
                                        <td id="td_dv2CtgNm">
                                        <span class="intxt wid50p">
                                            <input type="text" id="ctgNm" name="ctgNm" maxlength="10" >
                                        </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="txtc">상품 선택</th>
                                        <td id="goods_empty">
                                        <span class="btn_box">
                                            <a href="#none" class="btn--black_small goods" onclick="goodsUtil.showSrchPop(this);">상품 찾기</a>
                                        </span>
                                        </td>
                                        <td id="goods_exist" style="display: none;">
                                            <div class="top_lay">
                                                <div class="select_btn_left">
                                                    <a href="#none" class="btn_gray2" id="a_id_delete" onclick="goodsUtil.delGoods();">삭제</a>
                                                </div>
                                                <div class="select_btn_right">
                                                <span class="search_txt">
                                                    총 <strong class="all" id="cnt_total"></strong>개의 상품이 등록되었습니다.
                                                </span>
                                                    <span class="btn_box">
                                                    <a href="#none" class="btn--black_small goods" onclick="goodsUtil.showSrchPop(this);">상품 찾기</a>
                                                </span>
                                                </div>
                                            </div>
                                            <div class="tblh">
                                                <table>
                                                    <colgroup>
                                                        <col width="50px">
                                                        <col width="50px">
                                                        <col width="130px">
                                                        <col width="20%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="12%">
                                                        <col width="15%">
                                                    </colgroup>
                                                    <thead>
                                                    <tr>
                                                        <th>
                                                            <label for="allcheck" class="chack">
                                                                <span class="ico_comm"><input type="checkbox" name="table" id="allcheck"></span>
                                                            </label>
                                                        </th>
                                                        <th>번호</th>
                                                        <th>이미지</th>
                                                        <th>상품명</th>
                                                        <th>상품코드</th>
                                                        <th>브랜드</th>
                                                        <th>판매자</th>
                                                        <th>판매가</th>
                                                        <th>재고</th>
                                                        <th>판매상태</th>
                                                        <th>다비전 상품코드</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="tbody_goods_data">
                                                    <tr id="tr_goods_data_template" style="display: none;">
                                                        <td>
                                                            <label for="chk_select_goods_template" class="chack">
                                                                <span class="ico_comm"><input type="checkbox" id="chk_select_goods_template" class="blind"></span>
                                                            </label>
                                                        </td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="rownum"></td>
                                                        <td>
                                                            <img src="" alt="" data-bind="goodsInfo" data-bind-type="img" data-bind-value="goodsImg01">
                                                        </td>
                                                        <td class="txtl" data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNm"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsNo"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="brandNm"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="sellerNm"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="salePrice"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="stockQtt"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="goodsStatusNm"></td>
                                                        <td data-bind="goodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="txtc">사용 여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:사용;N:미사용" name="useYn" idPrefix="useYn"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="btn_regist">저장</button>
                </div>
            </div>
        </div>



<%--        <div class="sec01_box">--%>
<%--            <div class="tlt_box">--%>
<%--                <h2 class="tlth2">카테고리관리</h2>--%>
<%--                <div class="btn_box right">--%>
<%--                    <a href="#" class="btn blue shot" id="updateCtgBtn">적용하기</a>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <!-- line_box -->--%>
<%--            <div class="line_box fri">--%>
<%--                <!-- cate_con -->--%>
<%--                <div class="cate_con">--%>
<%--                    <!-- cate_left -->--%>
<%--                    <div class="cate_left">--%>
<%--                        <a href="#categoryInsLayer" class="popup_open btn_gray2" id="ctgInsBtn" >+ 카테고리 추가</a>--%>
<%--                        <a href="#" class="btn_gray" id="delCtgBtn">삭제</a>--%>
<%--                        <span class="br2"></span>--%>
<%--                        <div class="left_con">--%>
<%--                            <div id="ctgTree"></div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                    <!-- //cate_left -->--%>
<%--                    <!-- cate_right -->--%>
<%--                    <div class="cate_right">--%>
<%--                        <h3 class="tlth3">카테고리 관리 </h3>--%>
<%--                        <form id="ctgMngForm">--%>
<%--                        <input type="hidden" name="ctgNo" id="ctgNo" />--%>
<%--                        <input type="hidden" name="dftFilePath" id="dftFilePath" />--%>
<%--                        <input type="hidden" name="dftFileName" id="dftFileName" />--%>
<%--                        <input type="hidden" name="prCtgLvl" id="prCtgLvl" />--%>
<%--                        <input type="hidden" name="prUpCtgNo" id="prUpCtgNo" />--%>
<%--                        <input type="hidden" name="prUpCtgNm" id="prUpCtgNm" />--%>
<%--                        <input type="hidden" name="dftDelYn" id="dftDelYn" value="N" />--%>
<%--                        <input type="hidden" name="filterApplyYn" id="filterApplyYn" value="Y" />--%>
<%--                        <input type="hidden" name="ctgType" id="ctgType" />--%>

<%--                        <!-- tblw -->--%>
<%--                        <div class="tblw tblmany">--%>
<%--                            <table summary="이표는 전시 카테고리 관리 표 입니다. 구성은 카테고리명, 카테고리 꾸미기, 카테고리 접속 권한, 카테고리등록 상품수, 카테고리 상품 전시 타입 입니다.">--%>
<%--                                <caption>전시 카테고리 관리</caption>--%>
<%--                                <colgroup>--%>
<%--                                    <col width="30%">--%>
<%--                                    <col width="70%">--%>
<%--                                </colgroup>--%>
<%--                                <tbody>--%>
<%--                                    <tr>--%>
<%--                                        <th>컨텐즈 구분</th>--%>
<%--                                        <td>--%>
<%--                                            <tags:radio name="goodsContsGbCd" codeStr="01:실물;02:컨텐츠" idPrefix="goodsContsGbCd" />--%>
<%--                                        </td>--%>
<%--                                    </tr>--%>
<%--                                    <tr>    --%>
<%--                                        <th>카테고리명</th>--%>
<%--                                        <td><span class="intxt wid100p"><input type="text" id="ctgNm" name="ctgNm" maxlength="10" ></span></td>--%>
<%--                                    </tr>--%>
<%--                                    <tr>--%>
<%--                                        <th>카테고리 꾸미기</th>--%>
<%--                                        <td>--%>
<%--                                            <label for="ctgExhbtionTypeCd1" class="radio"><span class="ico_comm"><input type="radio" name="ctgExhbtionTypeCd" id="ctgExhbtionTypeCd1" value="1"></span> 꾸미기 안함</label>--%>
<%--                                            <span class="br2"></span>--%>
<%--                                            <label for="ctgExhbtionTypeCd2" class="radio"><span class="ico_comm"><input type="radio" name="ctgExhbtionTypeCd" id="ctgExhbtionTypeCd2" value="2"></span> 이미지 (이미지 권장 사이즈 : 95*50)</label>--%>
<%--                                            <span class="br2"></span>--%>
<%--                                            <p class="img_reg_t">디폴트 노출 이미지 변경되는 이미지 각각 등록 해주세요.</p>--%>
<%--                                            <span class="br2"></span>--%>
<%--                                            <div class="img_regist">--%>
<%--                                                <div class="img_con">--%>
<%--                                                    <div class="item">--%>
<%--                                                        <span class="txt">- 디폴트 이미지</span>--%>
<%--                                                        <span class="img"><img src="/admin/img/product/tmp_img04.png" id="ctgImgPath" width="82" height="82" alt=""></span>--%>
<%--                                                        <div>--%>
<%--                                                            <span class="btn"><button class="btn_blue" id="defaultImg">이미지등록</button><img id="dftImgDel" src="/admin/img/product/trash_btn.png" style="height:20px;margin-left:5px;vertical-align:middle!importatnt;" /></span>--%>
<%--                                                            <span class="size" id="defaultImgSize">사이즈<br>(000X000)</span>--%>
<%--                                                        </div>--%>
<%--                                                    </div>--%>
<%--                                                    <div class="item"></div>--%>
<%--                                                </div>--%>
<%--                                            </div>--%>
<%--                                        </td>--%>
<%--                                    </tr>--%>

<%--                                    <tr id="goodsTypeTr" style="display:none;">--%>
<%--                                        <th>필터 유형</th>--%>
<%--                                        <td>--%>
<%--                                            <code:radio name="goodsTypeCd" codeGrp="GOODS_TYPE_CD" idPrefix="goodsTypeCd" />--%>
<%--                                        </td>--%>
<%--                                    </tr>--%>
<%--                                    <tr>--%>
<%--                                    	<th>사용 여부</th>--%>
<%--                                    	<td>--%>
<%--                                    		<label for="useY" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn" id="useY" value="Y"></span> 사용</label>--%>
<%--                                            <label for="useN" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn" id="useN" value="N"></span> 미사용</label>--%>
<%--                                    	</td>--%>
<%--                                    </tr>--%>

<%--                                </tbody>--%>
<%--                            </table>--%>
<%--                        </div>--%>
<%--                        </form>--%>

<%--                        <form id="ctgDispzoneForm">--%>
<%--                        <input type="hidden" name="ctgNo" id="dispzoneCtgNo" />--%>
<%--                        <input type="hidden" name="dispzoneFilePath1" id="dispzoneFilePath1" />--%>
<%--                        <input type="hidden" name="dispzoneFileName1" id="dispzoneFileName1" />--%>
<%--                        <input type="hidden" name="dispzoneFilePath2" id="dispzoneFilePath2" />--%>
<%--                        <input type="hidden" name="dispzoneFileName2" id="dispzoneFileName2" />--%>
<%--                        <input type="hidden" name="dispZoneDelYn1" id="dispZoneDelYn1" value="N" />--%>
<%--                        <input type="hidden" name="dispZoneDelYn2" id="dispZoneDelYn2" value="N" />--%>
<%--                         --%>
<%--                         &lt;%&ndash; 주력제품 세팅... &ndash;%&gt;--%>
<%--                        <p class="check_txt">--%>
<%--                             <input type="hidden" name="ctgDispzoneNoArr" id="ctgDispzoneNo6" />--%>
<%--                             <tags:checkbox name="useYnArr" id="dispzoneUseYn6" value="Y" compareValue="" text="사용" />--%>
<%--                             <strong>--%>
<%--                             	<input type="hidden" id="dipzoneNm6" name="dispzoneNmArr" value="MAIN_DISP_GOODS">--%>
<%--                             	<input type="hidden" name="ctgDispDispTypeCd6" value="01">--%>
<%--                                주력제품 설정--%>
<%--                             </strong>--%>
<%--                         </p>--%>
<%--                          &lt;%&ndash;tblw&ndash;%&gt;--%>
<%--                         <div class="tblw tblmany">--%>
<%--                             <table summary="이표는 전시 카테고리 꾸미기 표 입니다. 구성은 전시타입, 전시상품 입니다.">--%>
<%--                                 <caption>카테고리 꾸미기</caption>--%>
<%--                                 <colgroup>--%>
<%--                                     <col width="30%">--%>
<%--                                     <col width="70%">--%>
<%--                                 </colgroup>--%>
<%--                                 <tbody>--%>
<%--                                     <tr>--%>
<%--                                         <th>전시상품</th>--%>
<%--                                         <td>--%>
<%--                                             <a href="#none" class="btn_blue goods">상품검색</a>--%>
<%--                                             <span class="br"></span>--%>
<%--                                             <ul class="tbl_ul small" id="dispZoneGoods6">--%>
<%--                                             </ul>--%>
<%--                                         </td>--%>
<%--                                     </tr>--%>
<%--                                 </tbody>--%>
<%--                             </table>--%>
<%--                         </div>--%>
<%--                         &lt;%&ndash;// 주력제품 &ndash;%&gt;--%>
<%--                         --%>
<%--                        </form>--%>
<%--                    </div>--%>
<%--                    <!-- //cate_right -->--%>
<%--                </div>--%>
<%--                <!-- //cate_con -->--%>
<%--            </div>--%>
<%--            <!-- //line_box -->--%>
<%--        </div>--%>
        <%@ include file="CategoryInsertLayerPop.jsp" %>
        <%@ include file="ShowGoodsLayerPop.jsp" %>
        <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
    </t:putAttribute>
</t:insertDefinition>
