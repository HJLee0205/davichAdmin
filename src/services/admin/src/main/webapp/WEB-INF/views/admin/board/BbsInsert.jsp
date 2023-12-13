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
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
        var i= 1;
        var cnt= 0;
            jQuery(document).ready(function() {
                Dmall.validate.set('formBbsListInsert');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                Dmall.DaumEditor.create('ta_id_content2'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

                //jQuery("input[name = 'bbsGbCd']").toggleDesignEleReadonly();
                //jQuery("#srch_id_bbsGbCd_1").toggleDesignEleReadonly();
                
                if("${_DMALL_SITE_INFO.siteTypeCd}"=="1"){
                    jQuery("#bbsKindCd").toggleDesignEleReadonly();
                }
                
                //게시판 말머리 등록 버튼 클릭 함수
                jQuery('#bbsTitleInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var inputTitleNm = jQuery('#inputTitleNm').val();
                    
                    if("${_DMALL_SITE_INFO.siteTypeCd}"=="1"){
                        Dmall.LayerUtil.alert('무료사이트는 게시판 노출메뉴로 커뮤니티는 불가능 합니다.');
                        return;
                    }
                    
                    if(inputTitleNm=="") {
                        Dmall.LayerUtil.alert('타이틀을 입력 하세요.');
                        return;
                    }else{
                        var text = "<li class='txt_del'  name='_titleNm"+i+"' id='_titleNm"+i+"'>"+inputTitleNm+"<button class='btn_del btn_comm' id = 'delTitleNm"+i+"'>_titleNm"+i+"</button></li>";
                        $( "#viewTitleInsert" ).append( text );

                        jQuery('#delTitleNm'+i).on('click', function(e) {
                            e.preventDefault();
                            e.stopPropagation();
                            
                            var delText =  jQuery(this).text();
                            $("#"+delText).remove();
                            cnt--;
                        });
                        
                        jQuery('#inputTitleNm').val("");
                        i++;
                        cnt++
                    }
                });
                
                // 게시판 등록 함수
                jQuery('#bbsListInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    titleNmSet();

                    $("#bbsKindCd").removeAttr("disabled");
                    if(jQuery("input[name = 'titleUseYn']:checked").val()=="Y"){
                        if(cnt==0){
                            Dmall.LayerUtil.alert('말머리 사용은 타이틀 입력을 필수로 해주세요.');
                            return;
                        }
                    }
                    if(Dmall.validate.isValid('formBbsListInsert')) {
                        Dmall.EventUtil.stopAnchorAction(e);
                        Dmall.DaumEditor.setValueToTextarea(['ta_id_content1', 'ta_id_content2']);  // 에디터에서 폼으로 데이터 세팅
                        
                        var url = '/admin/operation/board-insert';
                        var param = jQuery('#formBbsListInsert').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsListInsert');
                            if(result.success){
                                Dmall.FormUtil.submit('/admin/operation/board', {bbsId : ""});
                            }
                        });
                    }
                });
                
                // 게시판 노출 메뉴 변경 이벤트
                jQuery("input[name = 'bbsGbCd']").change(function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    jQuery("#bbsKindCd option:eq(0)").prop('selected', true);
                    jQuery("#bbsKindCd option:eq(0)").parents('select').prev().text(jQuery("#bbsKindCd option:eq(0)").text());
                    
                    if(jQuery(this).val()=="2"){
                        jQuery("#bbsKindCd").toggleDesignEleReadonly();
                        jQuery("#oldBbsGbCd").val("2");
                        jQuery("#bbsAddr").val("customer/board-list?bbsId=");
                    }else{
                        if(jQuery("#oldBbsGbCd").val() != "1"){
                            jQuery("#bbsKindCd").toggleDesignEleReadonly();
                        }
                        jQuery("#oldBbsGbCd").val("1");
                        jQuery("#bbsAddr").val("community/board-list?bbsId=");
                    }
                    
                    jQuery("#titleSet").show();
                });
                
                // 게시판 종류 변경 이벤트
                jQuery("#bbsKindCd").change(function(e) {
                    if(jQuery(this).val()=="1"){
                        jQuery("#titleSet").show();
                    }else{
                        jQuery("#titleSet").hide();
                        jQuery("input[name = 'titleUseYn']").val("");
                        jQuery("#inputTitleNm").val("");
                        jQuery("#titleNmArr").val("");
                        $( "#viewTitleInsert" ).empty();
                    }
                });
                
                // 게시판 종류 변경 이벤트
                jQuery("input[name = 'iconSetUseYn']").change(function(e) {
                    if(jQuery(this).val()=="Y"){
                        jQuery("#iconViewYn").show();
                        $('#iconValue').attr('rowspan', '2');
                    }else{
                        jQuery("#iconViewYn").hide();
                        $('#iconValue').attr('rowspan', '1');
                    }
                });
                
                jQuery("#topBottomTitle").hide();
                jQuery("#topBottomView").hide();
                jQuery("#topView").hide();
                jQuery("#bottomView").hide();
                
                
                // 게시판 상단 표출 여부
                jQuery("input[name = 'topHtmlYn']").change(function(e) {
                    if(jQuery(this).val()=="Y"){
                        jQuery("#topBottomTitle").show();
                        jQuery("#topBottomView").show();
                        jQuery("#topView").show();
                    }else{
                        if(jQuery("input[name = 'bottomHtmlYn']:checked").val()=="N"){
                            jQuery("#topBottomTitle").hide();
                            jQuery("#topBottomView").hide();
                        }
                        jQuery("#topView").hide();
                    }
                });
                // 게시판 하단 표출 여부
                jQuery("input[name = 'bottomHtmlYn']").change(function(e) {
                    if(jQuery(this).val()=="Y"){
                        jQuery("#topBottomTitle").show();
                        jQuery("#topBottomView").show();
                        jQuery("#bottomView").show();
                    }else{
                        if(jQuery("input[name = 'topHtmlYn']:checked").val()=="N"){
                            jQuery("#topBottomTitle").hide();
                            jQuery("#topBottomView").hide();
                        }
                        jQuery("#bottomView").hide();
                    }
                });
            });
            // 게시판 말머리 설정 함수
            function titleNmSet(){
                var titleNmArr = new Array();
                var z=0;
                for(var j=1;j<i;j++){
                    var temp = jQuery('#_titleNm'+j).text().split('_');

                    if(temp!=""){
                        titleNmArr[z] = temp[0];
                        z++;
                    }
                }        

                jQuery('#titleNmArr').val(titleNmArr);
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div id="content">
            <div class="sec01_box">
                <div class="tlt_box">
                    <div class="btn_box left">
                        <a href="/admin/operation/board" class="btn gray">게시판리스트</a>
                    </div>
                    <h2 class="tlth2">게시판만들기</h2>
                    <div class="btn_box right">
                        <a href="#none" id ="bbsListInsert" class="btn blue shot">저장하기</a>
                    </div>
                </div>
                <form action="" id="formBbsListInsert">
                <div class="line_box fri">
                   <h3 class="tlth3">기본 설정 </h3>
                   <!-- tblw -->
                   <div class="tblw tblmany">
                       <table summary="이표는 기본 설정 표 입니다. 구성은 게시판아이디, 게시판 명, 게시판 종류, 말머리 설정, 게시판 주소 입니다.">
                           <caption>기본 설정</caption>
                           <colgroup>
                               <col width="15%">
                               <col width="85%">
                           </colgroup>
                           <tbody>
                               <tr>
                                   <th>게시판아이디</th>
                                   <td>
                                       <span class="intxt">
                                            <input type="text" value="" id="bbsId" name = "bbsId" data-validation-engine="validate[required,custom[onlyEng]], maxSize[20]]" >
                                       </span>
                                       <span class="tbl_desc">(영문 입력/ 다른 게시판 아이디와 중복 불가)</span>
                                   </td>
                               </tr>
                               <tr>
                                   <th>게시판 명</th>
                                   <td>
                                       <span class="intxt"><input type="text" value="" id="bbsNm" name = "bbsNm" data-validation-engine="validate[required], maxSize[50]]" ></span>
                                       <span class="tbl_desc">(영문, 한글 가능)</span>
                                   </td>
                               </tr>
                               <tr>
                                   <th>게시판 노출메뉴</th>
                                   <td>
                                       <input type = "hidden" id = "oldBbsGbCd" value = "1" />
                                       <input type = "hidden" id = "bbsAddr" name = "bbsAddr" value="community/board-list?bbsId=" />
                                       <tags:radio name="bbsGbCd" codeStr="1:커뮤니티;2:고객센터;" idPrefix="srch_id_bbsGbCd" value="1"  /> 
                                   </td>
                               </tr>
                               <tr>
                                   <th>게시판 종류</th>
                                   <td>
                                       <input type = "hidden" id = "oldBbsKindCd" value = "N" />
                                       <span class="select">
                                           <label for="select1"></label>
                                           <select id ="bbsKindCd" name = "bbsKindCd" >
                                               <code:option codeGrp="BBS_KIND_CD" />
                                           </select>
                                       </span>
                                       <span class="select_desc tbl_desc">
                                           *리스트형은 일반적인 형태의 게시판을 의미합니다.<br>
                                           *갤러리형은 리스트페이지에서 업로드된 이미지가 같이 보여집니다.<br>
                                           *자료실형은 이미지 우측에 제목이 같이 노출되는 게시판을 의미합니다.
                                       </span>
                                   </td>
                               </tr>
                               <tr id="titleSet">
                                   <th>말머리 설정</th>
                                   <td>
                                       <tags:checkbox name="titleUseYn" id="srch_id_titleUseYn" value="Y" compareValue="" text="말머리사용 (글 작성시 제목앞에 특정단어를 넣는 기능입니다. Ex: [긴급공지])" />
                                       <span class="br"></span>
                                       타이틀입력 : <span class="intxt" ><input type="text" value="" id="inputTitleNm" name = "inputTitleNm" maxlength="10" >
                                                             <input type="hidden" value="" id="titleNmArr" name = "titleNmArr">
                                         </span> <button class="btn_comm plus" id = "bbsTitleInsert" >더하기</button>
                                       <span class="br2"></span>
                                       <div class="disposal_log">
                                           <ul id = "viewTitleInsert">
                                           
                                           </ul>
                                       </div>
                                   </td>
                               </tr>
                               <%-- <tr>
                                   <th>게시판 주소</th>
                                   <td>(쇼핑몰주소)/shop/board/list.java/notice <button class="btn_gray">복사</button></td>
                               </tr> --%>
                           </tbody>
                       </table>
                   </div>
                   <ul class="desc_txt bottom tblmany">
                       <li>※ 게시판종류, 게시판 노출메뉴는 등록 후 수정이 불가능합니다.</li>
                       <li>※ 말머리 설정 여부은 리스트형 게시판에 한하여 설정 가능합니다.</li>
                   </ul>
                   <!-- //tblw -->
                   <h3 class="tlth3">사용여부 </h3>
                   <!-- tblh -->
                   <div class="tblh th_l tblmany">
                       <table summary="이표는 사용여부 및 사용자 권한 설정 표 입니다. 구성은 항목 읽기(목록보기, 글내용보기), 쓰기(글쓰기, 댓글쓰기, 답글쓰기) 입니다.">
                           <caption>사용여부</caption>
                           <colgroup>
                               <col width="16%">
                               <col width="16%">
                               <col width="17%">
                               <col width="17%">
                               <col width="17%">
                               <col width="17%">
                           </colgroup>
                           <thead>
                               <tr>
                                   <th rowspan="2">항목</th>
                                   <th colspan="2" class="line_b">읽기</th>
                                   <th colspan="3" class="line_b">쓰기</th>
                               </tr>
                               <tr>
                                   <th class="line_l">목록보기</th>
                                   <th>글내용 보기</th>
                                   <th>글쓰기</th>
                                   <th>댓글 쓰기</th>
                                   <th>답변 쓰기</th>
                               </tr>
                           </thead>
                           <tbody>
                               <tr>
                                   <th>사용여부</th>
                                   <td>
                                       <span class="select">
                                           <label for="select1"></label>
                                           <select name="readListUseYn" id="readListUseYn">
                                                <tags:option codeStr="Y:사용함;N:사용안함" value = ""/>
                                           </select>
                                       </span>
                                   </td>
                                   <td>
                                       <span class="select">
                                           <label for="select1"></label>
                                           <select name="readLettContentUseYn" id="readLettContentUseYn">
                                                <tags:option codeStr="Y:사용함;N:사용안함" value = ""/>
                                           </select>
                                       </span>
                                   </td>
                                   <td>
                                       <span class="select">
                                           <label for="select1"></label>
                                           <select name="writeLettUseYn" id="writeLettUseYn">
                                               <tags:option codeStr="Y:사용함;N:사용안함" value = ""/>
                                           </select>
                                       </span>
                                   </td>
                                   <td>
                                       <span class="select">
                                           <label for="select1"></label>
                                           <select name="writeCommentUseYn" id="writeCommentUseYn">
                                               <tags:option codeStr="Y:사용함;N:사용안함" value = ""/>
                                           </select>
                                       </span>
                                   </td>
                                   <td>
                                       <span class="select">
                                           <label for="select1"></label>
                                           <select name="writeReplyUseYn" id="writeReplyUseYn">
                                                <tags:option codeStr="Y:사용함;N:사용안함" value = ""/>
                                           </select>
                                       </span>
                                   </td>
                               </tr>
                           </tbody>
                       </table>
                   </div>
                   <!-- //tblh -->
                   <h3 class="tlth3">상세 옵션 설정 </h3>
                   <!-- tblw -->
                   <div class="tblw tblmany">
                       <table summary="이표는 상세 옵션 설정 표 입니다. 구성은 작성자 표기, 아이콘 삽입 설정/조건, 비밀글 설정, 공지글 설정, 부정태그 사용방지, 게시글 스팸방지, 댓글 스팸방지 입니다.">
                           <caption>상세 옵션 설정</caption>
                           <colgroup>
                               <col width="15%">
                               <col width="85%">
                           </colgroup>
                           <tbody>
                               <tr>
                                   <th>작성자 표기</th>
                                   <td>
                                       <tags:radio name="regrDispCd" codeStr="01:이름;02:아이디" idPrefix="srch_id_useYn" value="01" /> 
                                   </td>
                               </tr>
                               <tr>
                                   <th id = "iconValue" rowspan="2">아이콘 삽입<br>설정/조건</th>
                                   <td>
                                        <tags:radio name="iconSetUseYn" codeStr="Y:사용함;N:사용안함" idPrefix="srch_id_useYn" value="Y" /> 
                                   </td>
                               </tr>
                               <tr id="iconViewYn">
                                   <td>
                                       <tags:checkbox name="iconUseYnHot" id="srch_id_iconUseYnHot" value="Y" compareValue="" text="<strong class='point_c1'>HOT</strong>" />
                                            조회수<span class="intxt shot4"><input type="text" id="iconCheckValueHot" name = "iconCheckValueHot" 
                                            maxlength="3" data-validation-engine="validate[custom[onlyNum]], maxSize[3]]">
                                       </span> 회 이상
                                       <tags:checkbox name="iconUseYnNew" id="srch_id_iconUseYnNew" value="Y" compareValue="" text="<strong class='point_c3'>NEW</strong>" />
                                       <span class="intxt shot4"><input type="text" id="iconCheckValueNew" name = "iconCheckValueNew" 
                                            maxlength="3" data-validation-engine="validate[custom[onlyNum]], maxSize[3]]" >
                                       </span> 시간
                                   </td>
                               </tr>
                               <tr>
                                   <th>비밀글 설정</th>
                                   <td>
                                       <tags:radio name="sectLettSetYn" codeStr="Y:사용함;N:사용안함" idPrefix="srch_id_useYn" value="Y" /> 
                                   </td>
                               </tr>
                               <tr>
                                   <th>공지글 설정</th>
                                   <td>
                                       <tags:radio name="noticeLettSetYn" codeStr="Y:사용함;N:사용안함" idPrefix="srch_id_noticeLettSetYn" value="Y" /> 
                                   </td>
                               </tr>
                               <tr>
                                   <th>게시글 스팸방지</th>
                                   <td>
                                        <tags:radio name="bbsSpamPrvntYn" codeStr="Y:사용함;N:사용안함" idPrefix="srch_id_bbsSpamPrvntYn" value="Y" /> 
                                   </td>
                               </tr>
                               <tr>
                                   <th>상단 HTML 표출 여부</th>
                                   <td>
                                        <tags:radio name="topHtmlYn" codeStr="Y:사용함;N:사용안함" idPrefix="srch_id_topHtmlYn" value="N" /> 
                                   </td>
                               </tr>
                               <tr>
                                   <th>하단 HTML 표출 여부</th>
                                   <td>
                                        <tags:radio name="bottomHtmlYn" codeStr="Y:사용함;N:사용안함" idPrefix="srch_id_bottomHtmlYn" value="N" /> 
                                   </td>
                               </tr>
                           </tbody>
                       </table>
                   </div>
                   <!-- //tblw -->
                   <h3 class="tlth3" id = "topBottomTitle">게시판 상/하단 HTML 설정 </h3>
                   <!-- tblw -->
                   <div class="tblw tblmany" id = "topBottomView">
                       <table summary="이표는 게시판 상/하단 HTML 설정 표 입니다. 구성은 상단디자인, 하단디자인 입니다.">
                           <caption>게시판 상/하단 HTML 설정</caption>
                           <colgroup>
                               <col width="15%">
                               <col width="85%">
                           </colgroup>
                           <tbody>
                               <tr id = "topView">
                                   <th>상단디자인</th>
                                   <td>
                                        <div class="edit">
                                            <textarea id="ta_id_content1" name="topHtmlSet" class="blind"></textarea>
                                        </div>
                                   </td>
                               </tr>
                               <tr id = "bottomView">
                                   <th>하단디자인</th>
                                   <td>
                                        <div class="edit">
                                            <textarea id="ta_id_content2" name="bottomHtmlSet" class="blind"></textarea>
                                        </div>
                                   </td>
                               </tr>
                           </tbody>
                       </table>
                   </div>
                   <!-- //tblw -->
               </div>
               </form>
               <!-- //line_box -->
           </div>  
        </div>
    </t:putAttribute>
</t:insertDefinition>
