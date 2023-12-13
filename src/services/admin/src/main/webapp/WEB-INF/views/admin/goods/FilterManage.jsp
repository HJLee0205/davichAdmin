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
    <t:putAttribute name="title">Filter관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>        
        <script>
            var level = 0;
            var ulId = "";
            var seq = "";
            $(document).ready(function() {
                //Filter 수정
                $("#updateFilterBtn").on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    if($("#prFilterLvl").val() == "" || $("#prFilterLvl").val() == null || $("#prFilterLvl").val() == "1"){
                        Dmall.LayerUtil.alert("Filter를 선택하여 주십시오.");
                        return;
                    }
                    
                    if(Dmall.validate.isValid('filterMngForm')) {
                        //에디터에서 폼으로 데이터 세팅

                        var url = '/admin/goods/filter-update',
                            param = $('#filterMngForm').serialize();

                        console.log("param = ", param);
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            
                            if(result.success){
                                filterTreeListReload();

                                $("#dftFilePath").val("");
                                $("#dftFileName").val("");
                                $("#moverFilePath").val("");
                                $("#moverFileName").val("");

                                selectFilterInfo($("#prUpFilterNo").val());
                            }
                            
                        });
                    }
                });
                
                //Filter 삭제
                $("#delFilterBtn").on('click', function(e) {
                    var node_id = $("#filterTree").jstree("get_selected");

                    if (node_id[0] === "GOODS_TYPE_CD00") {
                        Dmall.LayerUtil.alert("해당 필터는 삭제할 수 없습니다.");
                        return false;
                    }
                    console.log("filterRequire = ", $("#filterRequire").val());
                    if ($("#filterRequire").val() === "M") {
                        Dmall.LayerUtil.alert("해당 필터는 삭제할 수 없습니다.");
                        return false;
                    }
                    console.log("node_id = ", node_id);
                    Dmall.LayerUtil.confirm('삭제하시겠습니까?',
                        function(){
                            var deleteUrl = '/admin/goods/filter-delete';
                            Dmall.AjaxUtil.getJSON(deleteUrl, {filterNo:node_id[0]}, function(result) {
                                if(result.success){
//                                     selectFilterList();
                                    location.reload();
                                }
                            });
                        });
                });
                
                // Filter 등록 레이어 실행
                $('#filterInsBtn').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if($("#prFilterLvl").val() == "" || $("#prFilterLvl").val() == null){
                        Dmall.LayerUtil.alert("Filter를 선택하여 주십시오.");
                        return;
                    }

                    if($("#prFilterLvl").val() == "1"){
                        Dmall.LayerUtil.alert("Filter를 최상위 필터는 순서만 변경 할수 있습니다.");
                        return;
                    }

                    if($("#prFilterLvl").val() == "4"){
                        if($("#filterMenuType").val() != "CONTACT") {
                            Dmall.LayerUtil.alert("콘택트렌즈 Filter 외 단계는 대분류, 중분류, 소분류 까지 가능합니다.");
                            return;
                        }
                    }

                    if($("#prFilterLvl").val() == "5"){
                        Dmall.LayerUtil.alert("콘택트렌즈 Filter 단계는 4 Depth 까지 가능합니다.");
                        return;
                    }

                    Dmall.LayerPopupUtil.open($("#filterInsLayer"));
                    openFilterInsLayer($("#prFilterLvl").val(), $("#prUpFilterNo").val(), $("#prUpFilterNm").val(), $("#filterMenuType").val(), $("#filterType").val(), $("#goodsTypeCd").val());
                });
                
                // 이미지업로드 - 파일을 선택하면 바로 업로드
                $('#defaultImg').on('click', function (e) {
                    var imgSrc = '';
                    var idVal = this.id;
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.FileUpload.image()
                            .done(function (result) {
                                console.log("image upload result = ", result);
                                var file = result.files[0] || null;
                                if (file) {
                                    imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName
                                    $('#filterImgPath').attr('src',imgSrc);
                                    $("#filterImageNm").val(file.fileName);
                                    $("#dftFilePath").val(file.filePath);
                                    $("#dftFileName").val(file.fileName);
                                    $("#defaultImgSize").html('사이즈<br/>(' + file.fileWidth + 'X' + file.fileHeight + ')');
                                }
                            })
                            .fail(function (result) {

                            });
                });

                // 이미지삭제
                $('#dftImgDel').on('click', function (e) {
                    var idValue = this.id;

                    $("#dftDelYn").val("Y");
                    $('#filterImgPath').attr('src','/admin/img/product/tmp_img04.png');
                    
                    Dmall.LayerUtil.alert("적용하기 버튼을 클릭하시면 이미지가 삭제 됩니다.");
                });
                
                selectFilterList();

                /*$("[name=filterApplyYn]").on("click",function(){*/
                $("label.radio[for^=filterDispType]").on("click",function(){
                    var _val = $(this).find('input[type=radio]').val();
                    if(_val=='CO'){
                        $("#filterImgUseYnTr").show();

                        if($('input[name="filterImgUseYn"]').val() === 'Y') {
                            $("#filterImgTr").show();
                        } else {
                            $("#filterImgTr").hide();
                        }
                    }else{
                        $("#filterImgUseYnTr").hide();
                        $("#filterImgTr").hide();
                    }
                });

                /*$("label.radio[for^=filterImgUse]").on("click",function(){
                    var _val = $(this).find('input[type=radio]').val();
                    if(_val=='Y'){
                        $("#filterImgTr").show();
                    }else{
                        $("#filterImgTr").hide();
                    }
                });*/
            });
            
            //Filter 트리 목록 reload Data
            function filterTreeListReload(){
                var url = '/admin/goods/filter-list',
                    param = '';
                Dmall.AjaxUtil.getJSON(url, param, function(result){
                    //Filter 트리 refresh
                    $('#filterTree').jstree(true).settings.core.data = result;
                    $('#filterTree').jstree(true).refresh();
                });
            }
            
            
            //Filter 목록 조회
            function selectFilterList(){
                var url = '/admin/goods/filter-list',
                    param = '', 
                    callback = makeFilterList || function() {
                    };
                Dmall.AjaxUtil.getJSON(url, param, callback);
            }
            
            //Filter 트리 생성
            function makeFilterList(result){
                console.log("filter result = ", result);
                $('#filterTree').jstree({ 
                    'core' : {
							'themes' : { 'classic' : true },
							'data' : result,
							'icons' : true,
							'check_callback' :  function (op, node, par, pos, more) {
                                console.log("filter node = ", node);
                                console.log("filter filterRequire = ", node.original.filterRequire);
								if ((op === "move_node" || op === "copy_node") && node.type && node.type == "root" || node.original.filterRequire === "M") {
									return false;
								}
								
								if((op === "move_node" || op === "copy_node") && more && more.core 
										&& !Dmall.LayerUtil.confirm('순서를 변경하시겠습니까?',
											function() {
												//Filter 순서 저장
												var filterNo = node.id; //자신 ID
                                                var filterParent = node.parent; //자신 부모 ID
												var upFilterNo = par.id; //상위 ID
												var downFilterNo = (node.children_d).toString(); //하위 ID
												var orgFilterLvl = Number(node.original.filterLvl);  //변경 전 자신 LEVEL
												var filterLvl = Number(par.original.filterLvl)+1; //변경 후 자신 LEVEL ( = 하위 LEVEL +1)
												var sortSeq = pos+1; //변경할 위치
												
												console.log(node.children_d)
												console.log(downFilterNo)
												console.log("filterNo: "+filterNo+" | upFilterNo: "+upFilterNo+" | downFilterNo: "+downFilterNo+" | orgFilterLvl: "+orgFilterLvl+" | filterLvl: "+filterLvl+" | sortSeq: "+sortSeq)
                                                if(filterParent !== upFilterNo){
                                                    Dmall.LayerUtil.alert("상위나 하위 Filter로 이동할 수 없습니다.");
                                                    return;
                                                }
												var url = '/admin/goods/filter-sort',
												param = {filterNo:filterNo, upFilterNo:upFilterNo, downFilterNo:downFilterNo, orgFilterLvl:orgFilterLvl, filterLvl:filterLvl, sortSeq:sortSeq};
							                    console.log("param = ", param);
							                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
							                        Dmall.validate.viewExceptionMessage(result, 'filterMngForm');
							                        filterTreeListReload();
							                    });
												
											})){
									return false;
								}
								return true;
							}
					},
					'plugins' : ['wholerow', 'dnd']
				}).bind('select_node.jstree', function(event,data){       //선택 이벤트
					// 선택 필터 필요 하면 일단 모두 그리고
                    level = data.node.parents.length + 1;
                    console.log("filter data = ", data);
					$("#prFilterLvl").val(level);
                    $("#prUpFilterNo").val(data.node.id);
                    $("#prUpFilterNm").val(data.node.text);
                    $("#prFilterParent").val(data.node.parent);

                    $("#filterNo").val(data.node.id);
                    console.log("level ", level);
                    console.log("parents ", data.node.parents);
                    console.log("parents ", data.node.parents[0]);
                    if(level === 3){
                        if(data.node.parents[0] === '4') { // 컨택트렌즈
                            $("#filterDispTypeTr").hide();
                            $("#filterSlideTr").hide();
                        } else {
                            $("#filterDispTypeTr").show();
                        }
                    }else{
                        if(level === 4){
                            if(data.node.parents[1] === '4') {
                                $("#filterDispTypeTr").show();
                            } else {
                                $("#filterDispTypeTr").hide();
                                if(data.node.original.upFilterMainDispYn === 'Y' || data.node.original.upFilterDispType === 'CO') {
                                    $("#filterImgUseYnTr").show();
                                    //$("#filterImgTr").show();
                                }
                            }
                        } else {
                            if(level === 5){
                                if(data.node.parents[2] === '4') {
                                    if (data.node.original.upFilterMainDispYn === 'Y' || data.node.original.upFilterDispType === 'CO') {
                                        $("#filterDispTypeTr").hide();
                                        $("#filterImgUseYnTr").show();
                                        //$("#filterImgTr").show();
                                    } else {
                                        $("#filterDispTypeTr").hide();
                                        $("#filterSlideTr").hide();
                                    }
                                } else {
                                    $("#filterDispTypeTr").hide();
                                    $("#filterSlideTr").hide();
                                }
                            } else {
                                $("#filterDispTypeTr").hide();
                                $("#filterSlideTr").hide();
                            }
                        }
                    }

                    console.log("data.node = ", data.node);
                    // if(data.node.parent != "#"){
                        selectFilterInfo(data.node.id);
                        $("#defaultView").hide();
                        $("#filterView").show();
                    /*} else {
                        $("#defaultView").show();
                        $("#filterView").hide();
                    }*/
                });
                
                //Filter 트리 refresh
                $('#filterTree').jstree(true).settings.core.data = result;
                $('#filterTree').jstree(true).refresh();
            }
            
            //선택된 Filter 정보 조회
            function selectFilterInfo(filterNo){
                //hidden 데이터 초기화
                
                $("#dftFilePath").val("");
                $("#dftFileName").val("");
                
                var url = '/admin/goods/filter',
                    param = {filterNo:filterNo}, 
                    callback = setFilterInfoData || function() {

                    };
                console.log("param = ", param);
                Dmall.AjaxUtil.getJSON(url, param, callback);
            }
            
            //조회된 Filter 정보 값 셋팅
            function setFilterInfoData(result){
                // 그려진 화면에 받아온 필터 정보기반으로 값들 셋팅
                //Filter 이미지 파일 삭제 여부 초기화
                $("#dftDelYn").val("N");

                console.log("result = ", result);
                //조회된 Filter명 set
                if(result.data.filterRequire == 'M') {
                    $('#td_filterNm').html(result.data.filterNm);
                } else {
                    $('#td_filterNm').html(
                        '<span class="intxt wid100p">' +
                        '<input type="text" id="filterNm" name="filterNm" maxlength="10" value="'+ result.data.filterNm +'">' +
                        '</span>'
                    );
                }

                $("#filterMenuType").val(result.data.filterMenuType);
                $("#goodsTypeCd").val(result.data.goodsTypeCd);
                $("#filterRequire").val(result.data.filterRequire);
                $("#filterType").val(result.data.filterType);
               
                var filterImg = "/admin/img/product/tmp_img04.png";
                var filterImgNm = "/admin/img/product/tmp_img04.png";
                if(result.data.filterImgPath != null && result.data.filterImgNm !== ""){
                    filterImg = '${_IMAGE_DOMAIN}/image/image-view?type=FILTER&id1='+result.data.filterImgPath+"_"+result.data.filterImgNm;
                    filterImgNm = result.data.filterImgNm;
                }
                $("#filterImageNm").val(filterImgNm);

                $("#filterDscrt").val(result.data.filterDscrt);
                
                //$("#filterImgPath").attr('src',filterImg);

                $("#filterImgPath").attr('src', filterImg);
//                 $("#mouseoverImgPath").attr('src',result.data.mouseoverImgPath == null ? '/admin/img/product/tmp_img04.png' : result.data.mouseoverImgPath);
                
                $("#defaultImgSize").html('사이즈<br/>(' + result.data.filterNmImgWidth + 'X' + result.data.filterNmImgHeight + ')');

//                 $("input:radio[name='filterDispTypeCd']:radio[value='" + result.data.filterDispTypeCd + "']").attr('checked',true);
                
                Dmall.common.comma();
                

                var $input = $("input:radio[name='filterImgUseYn']:radio[value='" + (result.data.filterImgUseYn==null?"N":result.data.filterImgUseYn)+ "']").prop("checked",true);
                var $inputs = $('input[name="filterImgUseYn"]');
                $inputs.parents('label').removeClass('on');
                $input.parents().parents('label').addClass('on');
                
                $input = $("input:radio[name='useYn']:radio[value='" + result.data.useYn + "']");
                $inputs = $('input[name="useYn"]');
                $inputs.parents('label').removeClass('on');
                $input.parents().parents('label').addClass('on');

                $inputs = $('input[name="filterDispType"]');
                $inputs.closest('label').removeClass('on');
                $input = $("input:radio[name='filterDispType']:radio[value='" + result.data.filterDispType + "']");
                $input.closest('label').click();

                if(result.data.upFilterDispType === 'CO' || result.data.upFilterMainDispYn === 'Y'){

                    if(result.data.filterImgUseYn === 'Y') {
                        $("#filterImgTr").show();
                    } else {
                        $("#filterImgTr").hide();
                    }
                }else{
                    $("#filterImgUseYnTr").hide();
                    $("#filterImgTr").hide();
                }

            }
            
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품설정<span class="step_bar"></span> 필터 관리<span
                        class="step_bar"></span>
                </div>
                <h2 class="tlth2">필터 관리</h2>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <!-- cate_con -->
                <div class="filter_con">
                    <!-- cate_left -->
                    <div class="filter_left">
                        <a href="#filterInsLayer" class="btn--white btn--icon" id="filterInsBtn" >추가</a>
                        <a href="#" class="btn--white btn--icon btn--icon-minus" id="delFilterBtn">삭제</a>
                        <span class="br2"></span>
                        <div class="left_con">
                            <div id="filterTree"></div>
                        </div>
                    </div>
                    <!-- //cate_left -->
                    <!-- cate_right -->
                    <div class="filter_right">
                        <form id="filterMngForm">
                        <input type="hidden" name="filterNo" id="filterNo" />
                        <input type="hidden" name="dftFilePath" id="dftFilePath" />
                        <input type="hidden" name="dftFileName" id="dftFileName" />
                        <input type="hidden" name="prFilterParent" id="prFilterParent" />
                        <input type="hidden" name="prFilterLvl" id="prFilterLvl" />
                        <input type="hidden" name="prUpFilterNo" id="prUpFilterNo" />
                        <input type="hidden" name="prUpFilterNm" id="prUpFilterNm" />
                        <input type="hidden" name="dftDelYn" id="dftDelYn" value="N" />
                        <input type="hidden" name="filterImageNm" id="filterImageNm" />
                        <input type="hidden" name="filterMenuType" id="filterMenuType" />
                        <input type="hidden" name="filterType" id="filterType" />
                        <input type="hidden" name="goodsTypeCd" id="goodsTypeCd" />
                        <input type="hidden" name="filterRequire" id="filterRequire" />

                        <!-- tblw -->
                        <div class="warning_txt" id="defaultView">
                            필터 수정 &amp; 삭제 시 기존에 적용된 상품에 오류가<br> 발생할 수 있으므로 관리자와 상의 후 진행바랍니다.<span class="br2"></span> 각 상품군의 하위 필터 등록이 가능합니다.<span class="br2"></span>콘텍트렌즈상품은 2Depth까지 고정으로 노출됩니다.
                        </div>
                        <div class="tblw tblmany" id="filterView" style="display:none;">
                            <table summary="이표는 전시 Filter 관리 표 입니다. 구성은 Filter명, Filter 꾸미기, Filter 접속 권한, Filter등록 상품수, Filter 상품 전시 타입 입니다." >
                                <caption>필터 관리</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                    <tr>    
                                        <th>필터 명</th>
                                        <td id="td_filterNm"><span class="intxt wid100p"><input type="text" id="filterNm" name="filterNm" maxlength="10" ></span></td>
                                    </tr>
                                    <tr>
                                        <th>필터 설명</th>
                                        <td><span class="intxt wid100p"><input type="text" id="filterDscrt" name="filterDscrt" maxlength="20" ></span></td>
                                    </tr>
                                    <tr id="filterDispTypeTr" style="display:none;">
                                        <th>필터 타입</th>
                                        <td>
                                            <label for="filterDispTypeCh" class="radio mr20"><span class="ico_comm"><input type="radio" name="filterDispType" id="filterDispTypeCh" value="CH1"></span> 체크박스</label>
                                            <label for="filterDispTypeCh2" class="radio mr20"><span class="ico_comm"><input type="radio" name="filterDispType" id="filterDispTypeCh2" value="CH2"></span> 2라인 체크 박스</label>
                                            <label for="filterDispTypeSl" class="radio mr20"><span class="ico_comm"><input type="radio" name="filterDispType" id="filterDispTypeSl" value="SL"></span> 슬라이드</label>
                                            <label for="filterDispTypeCo" class="radio mr20"><span class="ico_comm"><input type="radio" name="filterDispType" id="filterDispTypeCo" value="CO"></span> 컬러</label>
                                        </td>
                                    </tr>
                                    <tr id="filterImgUseYnTr" style="display:none;">
                                        <th>이미지 사용 유무</th>
                                        <td>
                                            <label for="filterImgUseY" class="radio mr20"><span class="ico_comm"><input type="radio" name="filterImgUseYn" id="filterImgUseY" value="Y"></span> 사용</label>
                                            <label for="filterImgUseN" class="radio mr20"><span class="ico_comm"><input type="radio" name="filterImgUseYn" id="filterImgUseN" value="N"></span> 미사용</label>
                                        </td>
                                    </tr>
                                    <tr id="filterImgTr" style="display:none;">
                                        <th>이미지 첨부</th>
                                        <td>
                                            <span class="br2"></span>
                                            <div class="img_regist">
                                                <div class="img_con">
                                                    <div class="item">
                                                        <span class="txt">- 디폴트 이미지</span>
                                                        <span class="img"><img src="/admin/img/product/tmp_img04.png" id="filterImgPath" width="82" height="82" alt=""></span>
                                                        <div>
                                                            <span class="btn"><button class="btn_blue" id="defaultImg">이미지등록</button><img id="dftImgDel" src="/admin/img/product/trash_btn.png" style="height:20px;margin-left:5px;vertical-align:middle!importatnt;" /></span>
                                                            <span class="size" id="defaultImgSize">사이즈<br>(000X000)</span>
                                                        </div>
                                                    </div>
                                                    <div class="item"></div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="filterSlideTr" style="display:none;">
                                        <th>Slide 형 필터</th>
                                        <td>
                                            <span class="intxt wid100p"><input type="text" id="filterSlideMin" name="filterSlideMin" maxlength="10" ></span> Min
                                            ~
                                            <span class="intxt wid100p"><input type="text" id="filterSlideMax" name="filterSlideMax" maxlength="10" ></span> Max
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblw -->
                        <%--<div class="edit tblmany">
                            <textarea id="filterMainContent" name="content" class="blind"></textarea>
                        </div>--%>

                        </form>
                    </div>
                    <!-- //cate_right -->
                </div>
                <!-- //cate_con -->
            </div>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="updateFilterBtn">저장</button>
                </div>
            </div>
        </div>
        <%@ include file="FilterInsertLayerPop.jsp" %>
    </t:putAttribute>
</t:insertDefinition>
