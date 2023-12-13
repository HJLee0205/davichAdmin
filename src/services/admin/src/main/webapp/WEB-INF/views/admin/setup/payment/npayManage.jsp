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
 <t:putAttribute name="title">홈 &gt; 설정 &gt; 기본관리 &gt; NPAY 설정</t:putAttribute>
 <t:putAttribute name="script">
    <script type="text/javascript">
        $(document).ready(function() {
            $(document).ready(function() {
                NPayInitUtil.init();
                NPayRenderUtil.render();

                $('#btn_save').off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    NPaySubmitUtil.submit();
                });

                $('#copyBtn').off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    NPayUtil.copyToClipboard(); //IE의 경우 액세스를 허용하겠냐는 경고창이 나온다, 추후 복사방법을 바꿔야될수도있다.
                });

                Dmall.validate.set('form_npay_info');
            });
        });
        
        var NPayUtil = {
            copyToClipboard:function() {
                var textarea = document.getElementById( "replaceCd" );
                textToClipboard = textarea.value;

                var success = false;

                if ( window.clipboardData ) {
                    window.clipboardData.setData ( "Text", textToClipboard );
                    success = true;
                } else { 
                        textarea.value = textToClipboard;
                        var rangeToSelect = document.createRange();
                        rangeToSelect.selectNodeContents( textarea );

                        var selection = window.getSelection();
                        selection.removeAllRanges();
                        selection.addRange( rangeToSelect );

                        success = true; 

                        try { 
                            if ( window.netscape && (netscape.security && netscape.security.PrivilegeManager) ){
                                netscape.security.PrivilegeManager.enablePrivilege( "UniversalXPConnect" );
                            } 
                            textarea.select(); 
                            success = document.execCommand( "copy", false, null ); 
                        } catch ( error ) { 
                            success = false; 
                        }
                } 

                if ( success ){ 
                    alert('복사되었습니다. \n "Ctrl+v"를 사용하여 원하는 곳에 붙여넣기 하세요.');
                } else {
                    alert('복사하지 못했습니다.');
                }
            }
        };
        
        var NPayInitUtil = {
            init:function() {
                $('label.chack').off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var $this = $(this),
                        $input = $("#" + $this.attr("for")),
                        checked = !($input.prop('checked'));
                    $input.prop('checked', checked);
                    $this.toggleClass('on');
                });  
            }
            , setCheckoutUseYn:function(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
    
                $("input:radio[name=checkoutUseYn][value=" + value + "]").trigger('click');
            }
            , setCheckoutTestUseYn:function(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
    
                $("input:radio[name=checkoutTestUseYn][value=" + value + "]").trigger('click');
            }
            , setBtnLinkTarget:function(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
    
                $("input:radio[name=btnLinkTarget][value=" + value + "]").trigger('click');
            }
            , setStockLinkUseYn:function(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
    
                $("input:radio[name=stockLinkUseYn][value=" + value + "]").trigger('click');
            }
            , setOrdIntegrationManageUseYn:function(data, obj, bindName, target, area, row) {
                var bindValue = obj.data("bind-value")
                    , value = data[bindValue];
    
                $("input:radio[name=ordIntegrationManageUseYn][value=" + value + "]").trigger('click');
            }
            , setCourierSel:function(data, obj, bindName, target, area, row) {
                var courierCd = data["courierCd"];
                $('#sel_dlvrCompanySelect option').each(function(){
                    if( $(this).val() == courierCd ) {
                        $(this).attr("selected", "selected");
                    } else {
                        $(this).remove();
                    }
                });
                $('#lb_dlvrCompanySelect').text($('#sel_dlvrCompanySelect option:selected').text());
            }
        };
        
        var NPayRenderUtil = {
            addOption:function(courierList) {
                for(var i=0; i<courierList.length; i++) {
                    if(courierList[i].useYn === 'Y') {
                        $('#sel_dlvrCompanySelect').append($('<option>', { value : courierList[i].courierCd }).text(courierList[i].courierNm));
                    }
                }
            }
            , courierRender:function(data) {
                var url = '/admin/setup/delivery/courier-list-paging',
                param = '',
                dfd = jQuery.Deferred();
            
                Dmall.AjaxUtil.getJSON(url, param, function(result) {

                    if (result == null || result.success != true) {
                        return;
                    }                
                    var rstList = result.resultList;
                    if (rstList == null) {
                        return;
                    }
                    
                    //불러온 등록된 택배사 추가
                    NPayRenderUtil.addOption(rstList);
                    //선택된 배송업체 selected
                    $('#sel_dlvrCompanySelect').val(data.dlvrCompanySelect).trigger('change');
                });

                return dfd.promise();
            }
            , render:function() {
                var url = '/admin/setup/config/payment/npay-config-info',
                dfd = jQuery.Deferred();
                
                Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    
                    dfd.resolve(result.data);
                    NPayRenderUtil.bind(result.data);
                });
                return dfd.promise();
            }
            , bind:function(data) {
                NPayRenderUtil.courierRender(data); //배송업체 목록 추가
                $('[data-find="npay_config"]').DataBinder(data);
                NPayInitUtil.init();
            }
        };
        
        var NPaySubmitUtil = {
            submit:function() {
                if(Dmall.validate.isValid('form_npay_info')) {
                    var url = '/admin/setup/config/payment/npay-config-update'
                        , param = $('#form_npay_info').serialize();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_npay_info');
                        if (result == null || result.success != true) {
                            return;
                        } else {
                            NPayRenderUtil.render();
                        }
                    });
                }
            }
        };
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">NPAY 설정</h2>
                <div class="btn_box right">
                    <a href="#none" id="btn_save" class="btn blue shot">저장하기</a>
                </div>
            </div>
            
            <form id="form_npay_info" method="post">
                <!-- line_box -->
                <div class="line_box fri">
                    <%-- 사용안할 수도 있는 기능이라서 주석처리(기획팀(이동준 과장)과 얘기해서 결정된 사항) --%>
                    <%-- <h3 class="tlth3  btn1">공통유입 스크립트 설정</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 공통유입 스크립트 설정 표 입니다. 구성은 네이버공통인증키, White List 입니다.">
                            <caption>공통유입 스크립트 설정</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>네이버공통인증키</th>
                                    <td>
                                        <strong class="point_c1">※주의※</strong><br>
                                        한번 입력하신 “네이버공통인증키”는 변경하실 수 없습니다.<br>
                                        최초입력 시 유의하여 주시기 바랍니다.<br>
                                        만일 잘못 입력하였거나, 변경이 필요할 시에는 벨몰 고객센터로 문의주시기 바랍니다.
                                        <span class="br2"></span>
                                        <span class="intxt long"><input type="text" value="" id=""></span>
                                        <button class="btn_gray">중복확인</button>
                                    </td>
                                </tr>
                                <tr>
                                    <th>White List</th>
                                    <td>
                                        http://<span class="intxt long"><input type="text" value="" id=""></span>
                                        <button class="plus btn_comm">추가</button>
                                        <span class="br2"></span>
                                        http://<span class="intxt long"><input type="text" value="" id=""></span>
                                        <button class="minus btn_comm">삭제</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="info_box tblmany">
                        <strong class="tlt">※ 네이버 체크아웃 설정 시 필독!</strong>
                        <p class="con">
                            *네이버 체크아웃 서비스를 통해 지식쇼핑에 입점하는 방식을 선택해 주세요.
                            일반 쇼핑몰에서 별도의 다른 전자결제 서비스와 함께 네이버 체크아웃을 사용하는 경우는
                            네이버 체크아웃 설정/관리에서 사용함으로 설정해 주시면 됩니다.<br>
                            별도의 회원관리 없이 네이버회원 정보로만 구매할 수 있는 네이버 체크아웃 전용몰인 미니샵으로 운영하고자 하는 경우
                            네이버 미니샵 설정/관리에서 사용함으로 설정해 주시면 됩니다.<br>
                            <strong>네이버 지식 쇼핑입점은 위의 두 가지 운영형태 중 한 가지 방식만</strong>으로 입점할 수 있습니다.<br>
                            쇼핑몰 운영 형태는 언제든지 변경이 가능합니다.<br><br>
                            일반쇼핑몰에 네이버 체크아웃을 사용하고 있는 경우 이미 네이버 지식쇼핑에 입점되어 있기 때문에 미니샵 형태로
                            입점 형식을 변경하지 않으셔도 됩니다. 
                        </p>
                    </div> --%>
                    <!-- //tblw -->
                    <h3 class="tlth3">네이버 체크아웃 설정/관리</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 네이버 체크아웃 설정/관리 표 입니다. 구성은 사용여부, 테스트하기, 배송업체 선택, 착불 배송비 입니다.">
                            <caption>네이버 체크아웃 설정/관리</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>사용여부</th>
                                    <td id="td_checkoutUseYn" data-find="npay_config" data-bind-value="checkoutUseYn" data-bind-type="function" data-bind-function="NPayInitUtil.setCheckoutUseYn">
                                        <label for="rdo_checkoutUseYn1" class="radio mr20"><span class="ico_comm"><input type="radio" name="checkoutUseYn" id="rdo_checkoutUseYn1" value="Y"></span> 사용</label>
                                        <label for="rdo_checkoutUseYn2" class="radio mr20"><span class="ico_comm"><input type="radio" name="checkoutUseYn" id="rdo_checkoutUseYn2" value="N"></span> 사용안함</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>테스트하기</th>
                                    <td id="td_checkoutTestUseYn" data-find="npay_config" data-bind-value="checkoutTestUseYn" data-bind-type="function" data-bind-function="NPayInitUtil.setCheckoutTestUseYn">
                                        <label for="rdo_checkoutTestUseYn1" class="radio mr20"><span class="ico_comm"><input type="radio" name="checkoutTestUseYn" id="rdo_checkoutTestUseYn1" value="Y"></span> 사용</label>
                                        <label for="rdo_checkoutTestUseYn2" class="radio mr20"><span class="ico_comm"><input type="radio" name="checkoutTestUseYn" id="rdo_checkoutTestUseYn2" value="N"></span> 사용안함</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>배송업체 선택</th>
                                    <td>
                                        <span class="select nor">
                                            <label for="sel_dlvrCompanySelect" id="lb_dlvrCompanySelect"></label>
                                            <select id="sel_dlvrCompanySelect" name="dlvrCompanySelect">
                                                <%-- <code:option codeGrp="COURIER_CD" /> --%>
                                                <option value="">배송업체를 선택하세요</option>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>착불 배송비</th>
                                    <td><span class="intxt"><input type="text" id="recvpayDlvrc" name="recvpayDlvrc" data-find="npay_config" data-bind-value="recvpayDlvrc" data-bind-type="text" maxlength="20" data-validation-engine="validate[maxSize[20]]"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
        
                    <%-- 사용안할 수도 있는 기능이라서 주석처리(기획팀(이동준 과장)과 얘기해서 결정된 사항) --%>
                    <%-- <h3 class="tlth3">네이버 미니샵 설정/관리</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 네이버 미니샵 설정/관리 표 입니다. 구성은 사용여부 입니다.">
                            <caption>네이버 미니샵 설정/관리</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>사용여부</th>
                                    <td>
                                        <label for="radio03_1" class="radio mr20"><span class="ico_comm"><input type="radio" name="bb" id="radio03_1"></span> 사용</label>
                                        <label for="radio03_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="bb" id="radio03_2"></span> 사용안함</label>
                                        <span class="br"></span>
                                        <span class="fc_pr1 fs_pr1">
                                            * 별도의 회원관리 없이 네이버회원 정보로만 구매할 수 있는 네이버 체크아웃 전용몰인 미니샵으로 운영하고자 하는 경우, 네이버 미니샵 설정/관리에서 <strong>'사용함'</strong>으로 설정해 주시면 됩니다.<br><strong>'사용안함'</strong>으로 설정할 경우 일반쇼핑몰에서 적용되는 네이버체크아웃 서비스만 이용할 수 있습니다.
                                        </span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div> --%>
                    <!-- //tblw -->
        
                    <h3 class="tlth3">네이버 체크아웃 인증설정</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 네이버 체크아웃 인증설정 표 입니다. 구성은 네이버 가맹점ID, 연동 인증키, 이미지 인증키 입니다.">
                            <caption>네이버 체크아웃 인증설정</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>네이버 가맹점ID</th>
                                    <td><span class="intxt"><input type="text" id="naverFrcId" name="naverFrcId" data-find="npay_config" data-bind-value="naverFrcId" data-bind-type="text" maxlength="50" data-validation-engine="validate[maxSize[50]]"></span></td>
                                </tr>
                                <tr>
                                    <th>연동 인증키</th>
                                    <td><span class="intxt"><input type="text" id="linkCertKey" name="linkCertKey" data-find="npay_config" data-bind-value="linkCertKey" data-bind-type="text" maxlength="300" data-validation-engine="validate[maxSize[300]]"></span></td>
                                </tr>
                                <tr>
                                    <th>이미지 인증키</th>
                                    <td><span class="intxt"><input type="text" id="imgCertKey" name="imgCertKey" data-find="npay_config" data-bind-value="imgCertKey" data-bind-type="text" maxlength="300" data-validation-engine="validate[maxSize[300]]"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
        
                    <h3 class="tlth3">네이버 체크아웃 버튼 선택</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 네이버 체크아웃 버튼 선택 표 입니다. 구성은 PC용 버튼선택, 모바일용 버튼선택 입니다.">
                            <caption>네이버 체크아웃 버튼 선택</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>PC용 버튼선택</th>
                                    <td>
                                        <span class="select">
                                            <label for="">A타입 </label>
                                            <select name="" id="">
                                                <option value="">A타입 </option>
                                            </select>
                                        </span>
                                        <span class="select">
                                            <label for="">1색상 </label>
                                            <select name="" id="">
                                                <option value="">1색상 </option>
                                            </select>
                                        </span>
                                        <span class="br2"></span>
                                        <span class="naverpay_img">
                                            <img src="/admin/img/set/naverpay_img01.png" alt="naverpay" />
                                            <!-- temp(나중에 버튼 디자인부분 완성되고 설명문구 지울 것 -->
                                                <span class="br2"></span>
                                                            버튼 선택 디자인이 아직 퍼블리싱 되지 않았다. 이부분도 간편결제와 마찬가지로 기획쪽에 요청해야한다
                                            <!-- //temp -->
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>모바일용 버튼선택</th>
                                    <td id="td_btnLinkTarget" data-find="npay_config" data-bind-value="btnLinkTarget" data-bind-type="function" data-bind-function="NPayInitUtil.setBtnLinkTarget">
                                        <span class="select">
                                            <label for="">A타입 </label>
                                            <select name="" id="">
                                                <option value="">A타입 </option>
                                            </select>
                                        </span>
                                        <span class="select">
                                            <label for="">1색상 </label>
                                            <select name="" id="">
                                                <option value="">1색상 </option>
                                            </select>
                                        </span>
                                        <span class="br2"></span>
                                        <span class="naverpay_img">
                                            <img src="/admin/img/set/naverpay_img01.png" alt="naverpay" />
                                            <!-- temp(나중에 버튼 디자인부분 완성되고 설명문구 지울 것 -->
                                                <span class="br2"></span>
                                                            버튼 선택 디자인이 아직 퍼블리싱 되지 않았다. 이부분도 간편결제와 마찬가지로 기획쪽에 요청해야한다
                                            <!-- //temp -->
                                        </span>
                                        <span class="br2"></span>
                                        버튼링크 타겟:
                                        <label for="rdo_btnLinkTarget1" class="radio mr20"><span class="ico_comm"><input type="radio" name="btnLinkTarget" id="rdo_btnLinkTarget1" value="01"></span> 현재창</label>
                                        <label for="rdo_btnLinkTarget2" class="radio mr20"><span class="ico_comm"><input type="radio" name="btnLinkTarget" id="rdo_btnLinkTarget2" value="02"></span> 새창</label>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
        
                    <h3 class="tlth3">쇼핑몰에 네이버 체크아웃 버튼 삽입하기</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 쇼핑몰에 네이버 체크아웃 버튼 삽입하기 표 입니다. 구성은 치환코드, PC/모바일용 치환코드 삽입방법 입니다.">
                            <caption>쇼핑몰에 네이버 체크아웃 버튼 삽입하기</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>치환코드</th>
                                    <td>
                                        <span class="intxt"><input type="text" id="replaceCd" name="replaceCd" data-find="npay_config" data-bind-value="replaceCd" data-bind-type="text" maxlength="300" data-validation-engine="validate[maxSize[300]]"></span>
                                        <a href="#none" id="copyBtn" class="btn_gray">복사</a>
                                        <span class="br2"></span>
                                        <span class="fc_pr1 fs_pr1">* 복사하신 치환코드를 상품상세화면과 장바구니 페이지에 삽입하시면 체크아웃 기능이 동작합니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>PC/모바일용<br>치환코드<br>삽입방법</th>
                                    <td>
                                        "<span class="point_c3">쇼핑몰 관리자 > 디자인관리</span>" 좌측 트리 메뉴에서 "상품 > 장바구니" 메뉴 클릭<br>
                                        [바로구매] 또는 [주문하기] 버튼 아래에 치환코드 삽입을 권장합니다.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    
                    <h3 class="tlth3">주문연동하기</h3>
                    <!-- tblw -->
                    <div class="tblw">
                        <table summary="이표는 주문연동하기 표 입니다. 구성은 재고연동, 주문통합관리 입니다.">
                            <caption>주문연동하기</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>재고연동</th>
                                    <td id="td_stockLinkUseYn" data-find="npay_config" data-bind-value="stockLinkUseYn" data-bind-type="function" data-bind-function="NPayInitUtil.setStockLinkUseYn">
                                        <label for="rdo_stockLinkUseYn1" class="radio mr20"><span class="ico_comm"><input type="radio" name="stockLinkUseYn" id="rdo_stockLinkUseYn1" value="Y"></span> 사용</label>
                                        <label for="rdo_stockLinkUseYn2" class="radio mr20"><span class="ico_comm"><input type="radio" name="stockLinkUseYn" id="rdo_stockLinkUseYn2" value="N"></span> 사용안함</label>
                                        <span class="desc_txt2">* 주문을 연동한 후 설정하면 주문내역이 취합될 때 적용됩니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>주문통합관리</th>
                                    <td id="td_ordIntegrationManageUseYn" data-find="npay_config" data-bind-value="ordIntegrationManageUseYn" data-bind-type="function" data-bind-function="NPayInitUtil.setOrdIntegrationManageUseYn">
                                        <label for="rdo_ordIntegrationManageUseYn1" class="radio mr20"><span class="ico_comm"><input type="radio" name="ordIntegrationManageUseYn" id="rdo_ordIntegrationManageUseYn1" value="Y"></span> 사용</label>
                                        <label for="rdo_ordIntegrationManageUseYn2" class="radio mr20"><span class="ico_comm"><input type="radio" name="ordIntegrationManageUseYn" id="rdo_ordIntegrationManageUseYn2" value="N"></span> 사용안함</label>
                                        <span class="desc_txt2">* 쇼핑몰 주문관리에서 주문을 통합하여 관리합니다.</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <p class="desc_list mb0">*필독*</p>
                    <ul class="desc_list mt0">
                        <li>벨몰과 연동된 네이버 서비스 charset(문자셋)이 달라 텍스트가 깨지는 현상이 발생할 수 있습니다.</li>
                        <li>텍스트가 깨지는 경우 네이버 관리자에서 직접 확인하셔야 합니다.<br>(charset(문자셋)이란? 컴퓨터가 이용하는 특정코드를 특정 글자에 매핑시키는 것, 네이버 : UTF-8 벨몰: EUC-KR)</li>
                        <li class="point_c5">특히 상품제작에 필요한 정보나 상품에 삽입될 문구 등을 배송 메시지 등으로 받는 경우 반드시 네이버페이 관리자에서 직접 확인하셔야 합니다.<br>(예: 인쇄문구, 도장, 기타 상품제작 요구사항 등)</li>
                    </ul>
        
                </div>
                <!-- //line_box -->
            </form>
            <form:form id="form_id_search" >
                <input type="hidden" name="page" id="hd_page" value="1" />
                <input type="hidden" name="sord" id="hd_srod" value="" />
                <input type="hidden" name="rows" id="hd_rows" value="" />
            </form:form>
        </div>
    </t:putAttribute>
</t:insertDefinition>