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
    <t:putAttribute name="title">전시 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {

                // 체크
                Dmall.validate.set('form_id_detail');
                
                // 등록
                jQuery('#a_id_save').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var dispNo = "${resultModel.data.dispNo}";
                    
                    if(Dmall.validate.isValid('form_id_detail')) {
                        if(dispNo == ""){
                            Dmall.LayerUtil.confirm('등록 하시겠습니까?', UpdateDisp);
                        }else{
                            Dmall.LayerUtil.confirm('수정 하시겠습니까?', UpdateDisp);
                        }
                    }
                });
                
                // 상세
                jQuery('#dispNo').change(function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var dispOrgNo = "${resultModel.data.dispNo}";
                    var dispNo = $(this).val();
                    //alert("==dispOrgNo==="+dispOrgNo+"\n==dispNo==="+dispNo);
                    if(dispNo == ""){
                        Dmall.LayerUtil.alert("선택된 배너위치는 저장할수 없는 빈값입니다.");
                        DetailDispOrg();
                    }else if(dispOrgNo == "" && dispNo != dispOrgNo){
                        DetailDisp();
                    }else if(dispOrgNo != "" && dispNo != dispOrgNo){
                        Dmall.LayerUtil.confirm('변경된 배너 위치 정보에 맞는 데이터를 불러올까요?', DetailDisp, DetailDispOrg,'배너위치 변경하기','조회');
                    }
                });
                
                // 리스트 화면
                jQuery('#btn_id_list').on('click', function(e) {
                    location.replace("/admin/design/display");
                });

                // 배너 수정 버튼 이벤트 처리
                jQuery('#btn_id_banner_detail').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    Dmall.LayerPopupUtil.open(jQuery('#layer_id_disp_banner'));
                    dispBannerInit();
                });

                // 배너 수정 버튼 이벤트 처리
                jQuery('#btn_id_banner_update').on('click', function(e) {
                    var value ='';
                    var eqValue ='';
                    var keyValue ='';
                    dispNoSel = fn_selectedList();
                    // 수정된 파일 처리
                    if (dispNoSel.length > 0) {
                        Dmall.LayerUtil.confirm('변경된 내역으로 수정하시겠습니까?', function() {
                            var url = '/admin/design/display-banner-update',
                                    param = {},
                                    key,
                                    dispNoSel = fn_selectedList();
                                jQuery.each(dispNoSel, function(i, o) {
                                    key = 'list[' + i + '].dispNo';
                                    param[key] = o;
                                }); 
                                    dispCdNmSel = fn_selectedList2();
                                jQuery.each(dispCdNmSel, function(i, o) {
                                    key = 'list[' + i + '].dispCdNm';
                                    param[key] = o;
                                }); 

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    
                                });
                        });
                    }else{
                        Dmall.LayerUtil.alert("수정된 데이터가 없습니다.");
                    }
                    
                });
                
            });
            
        </script>
        <script>
            // 수정
            function UpdateDisp(){
                var url = '/admin/design/display-update',
                param = jQuery('#form_id_detail').serialize();

                $('#form_id_detail').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                            Dmall.LayerUtil.alert(result.message);
                        } else {
                            //dfd.resolve(result);
                        }
                    }
                });
            }
            
            function DetailDisp(){
                var dispNo = $('#dispNo').val();
                Dmall.FormUtil.submit('/admin/design/display-detail-info', {dispNo : dispNo});
            }
            
            function DetailDispOrg(){
                var dispOrgNo = "${resultModel.data.dispNo}";
                jQuery('#dispNo').val(dispOrgNo);
            }
            
            // 배너 정보 불러오기
            function dispBannerInit(){
                jQuery('#disp_body_info').empty( );
                var url = '/admin/design/display-banner',
                        param = "",
                        dfd = jQuery.Deferred();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var bannerList = result.data.titleNmArr;
                    var fir = '';
                    var end = '';
                    var tot = '';
                    for(i=0;i<bannerList.length;i++){
                        fir = '';
                        end = '';
                        if(i%2==0){
                            fir += "<tr>";
                            fir += "<th>배너위치 "+bannerList[i].dispCd;
                            fir += "<input type='hidden' id='dispNoChk' name='dispNoChk' value='"+bannerList[i].dispNo+"'>";
                            fir += "<input type='hidden' id='dispCdNmOrg' name='dispCdNmOrg' value='"+bannerList[i].dispCdNm+"'></th>";
                            fir += "<td><span class='intxt wid100p'><input type='text' placeholder='로고위치입력' id='dispCdNm' name='dispCdNm' value='"+bannerList[i].dispCdNm+"'></span></td>";
                        }else{
                            end += "<th class='line'>배너위치 "+bannerList[i].dispCd;
                            end += "<input type='hidden' id='dispNoChk' name='dispNoChk' value='"+bannerList[i].dispNo+"'>";
                            end += "<input type='hidden' id='dispCdNmOrg' name='dispCdNmOrg' value='"+bannerList[i].dispCdNm+"'></th>";
                            end += "<td><span class='intxt wid100p'><input type='text' placeholder='로고위치입력' id='dispCdNm' name='dispCdNm' value='"+bannerList[i].dispCdNm+"'></span></td>";
                            end += "</tr>";
                        }
                        tot += fir+end;
                    }
                    jQuery('#disp_body_info').append(tot);
                });
            }

            // 선택된값 체크
            function fn_selectedList() {
                var dispNoSel = [];
                var dispCdNmSel = [];
                jQuery("input[name=dispCdNm]").each(function(idx){
                    value = $(this).val();
                    eqValue = $("input[name=dispCdNmOrg]:eq(" + idx + ")").val();
                    keyValue = $("input[name=dispNoChk]:eq(" + idx + ")").val();
                    if(value != eqValue){
                        dispNoSel.push(keyValue);
                        dispCdNmSel.push(value);
                    }
                });
                return dispNoSel;
            }
            
            function fn_selectedList2() {
                var dispNoSel = [];
                var dispCdNmSel = [];
                jQuery("input[name=dispCdNm]").each(function(idx){
                    value = $(this).val();
                    eqValue = $("input[name=dispCdNmOrg]:eq(" + idx + ")").val();
                    keyValue = $("input[name=dispNoChk]:eq(" + idx + ")").val();
                    if(value != eqValue){
                        dispNoSel.push(keyValue);
                        dispCdNmSel.push(value);
                    }
                });
                return dispCdNmSel;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- content -->
    <div id="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="btn_box left">
                    <a href="#none" class="btn gray" id="btn_id_list">전시 관리 리스트</a>
                </div>
                <h2 class="tlth2">전시 관리</h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue shot" id="a_id_save">저장하기</a>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <!-- tblw -->
                <form name="form_id_detail" id="form_id_detail" method="post" accept-charset="utf-8">
                <div class="tblw">
                    <table summary="이표는 전시만들기 표 입니다. 구성은 전시코드, 전시명, 사용 여부, 연결링크, 파일업로드 입니다.">
                        <caption>전시만들기</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>배너위치</th>
                                <td>
                                    <span class="select">
                                        <label for="">배너 위치 선택</label>
                                        <select name="dispNo" id="dispNo">
                                            <option value="">선택하세요</option>
                                            <c:forEach var="titleList" items="${resultModel.data.titleNmArr}" varStatus="status">
                                            <c:set var="selected" value=""/>
                                            <c:if test="${titleList.dispNo eq resultModel.data.dispNo}">
                                                <c:set var="selected" value=" selected=\"selected\""/>
                                            </c:if>
                                            <option value="${titleList.dispNo}" ${selected}>${titleList.dispCdNm}</option>
                                            </c:forEach>
                                        </select>
                                    </span>
                                    <button class="btn_gray" id="btn_id_banner_detail">추가하기</button>
                                </td>
                            </tr>
                            <tr>
                                <th>전시 명</th>
                                <td><span class="intxt wid100p"><input type="text" value="${resultModel.data.dispNm}" id="dispNm" name="dispNm" data-validation-engine="validate[maxSize[50]]"></span></td>
                            </tr>
                            <tr>
                                <th>사용 여부</th>
                                <td>
                                    <tags:radio name="dispYn" idPrefix="srch_id_dispYn" codeStr="Y:사용;N:미사용" value="${resultModel.data.dispYn}" />
                                </td>
                            </tr>
                            <tr>
                                <th>연결링크</th>
                                <td>
                                    <span class="intxt long"><input type="text" value="${resultModel.data.linkUrl}" id="linkUrl" name="linkUrl" data-validation-engine="validate[maxSize[100],custom[url]]"></span>
                                    <span class="select">
                                        <label for="">현재창</label>
                                        <select name="dispLinkCd" id="dispLinkCd">
                                            <option value="">선택하세요</option>
                                            <code:option codeGrp="DISP_LINK_CD" value="${resultModel.data.dispLinkCd}" />
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>파일 업로드</th>
                                <td>
                                    <span class="intxt"><input id="file_route1" class="upload-name" type="text" value="" disabled="disabled"></span>
                                    <label class="filebtn" for="ex_file1">파일찾기</label>
                                    <input class="filebox" type="file" name="ex_file1" id="ex_file1" >
                                    ${resultModel.data.fileNm}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                </form>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
        </div>
    </div>
    <!-- //content -->
    <%@ include file="/WEB-INF/include/popup/dispBannerPopup.jsp" %>

    </t:putAttribute>
</t:insertDefinition>
