<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<script type="text/javascript" charset="utf-8">
var totalMemberCnt=${totalSize};
var searchMemberCnt = 0;
var selectMemberCnt=0; 

$(document).ready(function() {
    //에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
    Dmall.DaumEditor.init();
    //emailContent 를 ID로 가지는 Textarea를 에디터로 설정
    Dmall.DaumEditor.create('emailContent');
    
    //레이어 팝업 
    memberListSet.getList();
    Dmall.validate.set('form_id_emailSendInsert');
    $("#searchMemberList").hide();
    $("#selectMemberList").hide();

    $("#totalMemberCnt").text("("+totalMemberCnt+"명)");
    
    $("#selectMemberCnt").text("("+selectMemberCnt+"명)");
    
    //회원검색
    $('#btn_id_search').on('click', function(e){
        if($("#join_sc01").val().replace(/-/gi, "") > $("#join_sc02").val().replace(/-/gi, "")){
            Dmall.LayerUtil.alert('가입일 검색 시작 날짜가 종료 날짜보다 큽니다.');
            return;
        }
        
        if($("#login_sc01").val().replace(/-/gi, "") > $("#login_sc02").val().replace(/-/gi, "")){
            Dmall.LayerUtil.alert('최종방문일 검색 시작 날짜가 종료 날짜보다 큽니다.');
            return;
        }
        
        if($("#birth_sc01").val().replace(/-/gi, "") > $("#birth_sc02").val().replace(/-/gi, "")){
            Dmall.LayerUtil.alert('생일 검색 시작 날짜가 종료 날짜보다 큽니다.');
            return;
        }
        
        $("#hd_page1").val("1");
        memberListSet.getList();
    });
    
    $('#emailIndividualSend').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        $('.sms_send').toggle();
    });
    $("input[name = 'EmailMember']").change(function(e) {
        if($(this).val()=="all"){
            $("#totalMemberList").show();
            $("#searchMemberList").hide();
            $("#selectMemberList").hide();
            $("#sendMemberCnt").text(totalMemberCnt);
        }
        else if($(this).val()=="search"){
            $("#totalMemberList").hide();
            $("#searchMemberList").show();
            $("#selectMemberList").hide();
            $("#sendMemberCnt").text(searchMemberCnt);
        }
        else {
            $("#totalMemberList").hide();
            $("#searchMemberList").hide();
            $("#selectMemberList").show();
            $("#sendMemberCnt").text(selectMemberCnt);
        }
    });
    
    $(document).on('click', '.chack', function(e) {
        Dmall.EventUtil.stopAnchorAction(e);
        var memberNo = $(this).parents('tr').data('member-no');
        var memberNm = $(this).parents('tr').data('member-nm');
        var email = $(this).parents('tr').data('email');
        var loginId = $(this).parents('tr').data('login-id');
        var $this = $(this), $input = $this.find('input'), checked = !($input.prop('checked'));
        
        var selectMember ='<li class="txt_del" id ="select_'+memberNo+'">'+memberNm+' '+email+
                          '<input type = "hidden" id="recvEmailSelect" name ="recvEmailSelect" value="'+email+'" />'+
                          '<input type = "hidden" id="receiverNoSelect" name ="receiverNoSelect" value="'+memberNo+'" />'+
                          '<input type = "hidden" id="receiverIdSelect" name ="receiverIdSelect" value="'+loginId+'" />'+
                          '<input type = "hidden" id="receiverNmSelect" name ="receiverNmSelect" value="'+memberNm+'" />'+
                          '  <button type = "button" class="btn_del btn_comm" onclick="deleteMemberInfo(\''+memberNo+'\',\'select\');">삭제</button></li>';
        
        if(checked==true){
            $("#select_"+memberNo).remove();
            selectMemberCnt = selectMemberCnt-1;
            if($("input[name = 'EmailMember']:checked").val()=="select"){
                $("#sendMemberCnt").text(selectMemberCnt);
            }
            $("#selectMemberCnt").text("("+selectMemberCnt+"명)");
        }else{
            $("#selectMemberList").append(selectMember);
            selectMemberCnt = selectMemberCnt+1;
            if($("input[name = 'EmailMember']:checked").val()=="select"){
                $("#sendMemberCnt").text(selectMemberCnt);
            }
            $("#selectMemberCnt").text("("+selectMemberCnt+"명)");
        }
    });
    
    //이메일 발송
    $('#sendEmailInsert').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        if($("#sendMemberCnt").text()=="0"){
            Dmall.LayerUtil.alert('회원이 없습니다.');
            return;
        }
        
        if($("#mailTitle").val()==""){
            Dmall.LayerUtil.alert('메일 제목을 입력하여 주십시오.');
            return;
        }

        if($("input[name = 'EmailMember']:checked").val()=="all"){
            $("#searchMemberList").remove();
            $("#selectMemberList").remove();
        }
        if($("input[name = 'EmailMember']:checked").val()=="search"){
            $("#totalMemberList").remove();
            $("#selectMemberList").remove();
        }
        if($("input[name = 'EmailMember']:checked").val()=="select"){
            $("#totalMemberList").remove();
            $("#searchMemberList").remove();
        }
        
        if(Dmall.validate.isValid('form_id_emailSendInsert')) {
            //에디터에서 폼으로 데이터 세팅
            Dmall.DaumEditor.setValueToTextarea('emailContent');
            
            $("#curPage").val($(location).attr("protocol")+"//"+$(location).attr("host"));
            
            var url = '/admin/operation/email-send',
                param = $('#form_id_emailSendInsert').serialize();

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                Dmall.validate.viewExceptionMessage(result, 'form_id_emailSendInsert');
                if(result.success){
//                     $('.sms_send').toggle();
                    location.reload();
                }
            });
        }
    });
    
    $('#sel_rows').on('change', function(e) {
        $('#hd_page1').val('1');
        
        $('#hd_rows1').val($(this).val());
        memberListSet.getList();
    });
    
    $('#sel_sord').on('change', function(e) {
        $('#sort').val($(this).val());
        memberListSet.getList();
    });
    
    $(document).on('click', '.plus', function(e) {
        if($('#addEmail').val() == ""){
            Dmall.LayerUtil.alert('추가할 이메일 주소가 없습니다 .');
            return;
        }
        
       var typeVal = $('input[name="EmailMember"]:checked').val();
       var gb = '';
       if(typeVal == 'all'){
           gb = 'Total'
       }else if(typeVal == 'search'){
           gb = 'Search'
       }else{
           gb = 'Select'
       }
       
       var flag = true;
       $('input[name="recvEmail' + gb + '"]').each(function(){
           if($(this).val() == $('#addEmail').val()){
               Dmall.LayerUtil.alert('이미 등록되어 있는 이메일 입니다.');
               flag = false;
           }
       });
       
       if(flag){
           var selectMember ='<li class="txt_del" id ="addEmail">'+$('#addEmail').val()+
           '<input type = "hidden" name ="recvEmail' + gb + '" value="'+$('#addEmail').val()+'" />'+
           '<input type = "hidden" name ="receiverNo' + gb + '" value="0" />'+
           '<input type = "hidden" name ="receiverId' + gb + '" value="" />'+
           '<input type = "hidden" name ="receiverNm' + gb + '" value="" />'+
           '  <button class="btn_del btn_comm" name="addEmailDel" type="button">삭제</button></li>';
           
           if(typeVal == 'all'){
               $("#totalMemberList").append(selectMember);
               totalMemberCnt = totalMemberCnt+1;
               $("#totalMemberCnt").text("("+totalMemberCnt+"명)");
               $("#sendMemberCnt").text(totalMemberCnt);
           }else if(typeVal == 'search'){
               $("#searchMemberList").append(selectMember);
               searchMemberCnt = searchMemberCnt+1;
               $("#searchMemberCnt").text("("+searchMemberCnt+"명)");
               $("#sendMemberCnt").text(searchMemberCnt);
           }else{
               $("#selectMemberList").append(selectMember);
               selectMemberCnt = selectMemberCnt+1;
               $("#selectMemberCnt").text("("+selectMemberCnt+"명)");
               $("#sendMemberCnt").text(selectMemberCnt);
           }
       }
    });
    
    $(document).on('click', 'button[name="addEmailDel"]', function(e) {
        var typeVal = $('input[name="EmailMember"]:checked').val();
        $(this).parent().remove();
        if(typeVal=="all"){
            totalMemberCnt = totalMemberCnt-1;
            $("#totalMemberCnt").text("("+totalMemberCnt+"명)");
            $("#sendMemberCnt").text(totalMemberCnt);
        }else if(typeVal=="search"){
            searchMemberCnt = searchMemberCnt-1;
            $("#searchMemberCnt").text("("+searchMemberCnt+"명)");
            $("#sendMemberCnt").text(searchMemberCnt);
        }else{
            selectMemberCnt = selectMemberCnt-1;
            $("#selectMemberCnt").text("("+selectMemberCnt+"명)");
            $("#sendMemberCnt").text(selectMemberCnt);
        }
    })
    
    //검색 타입 변경시 텍스트 입력 설정 변경(한글/영문/숫자 입력 제한)
    $('#srch_id_searchType').change(function(e){
        $('#searchWords').remove();
        var inputText = '';
        if($(this).val() == 'all' || $(this).val() == 'name'){
            inputText = '<input type="text" id="searchWords" name="searchWords" class="text" size="40" maxlength="50" >'
        }else if($(this).val() == 'id' || $(this).val() == 'email'){
            inputText = '<input type="text" id="searchWords" name="searchWords" class="text" size="40" maxlength="50" onkeyup="onlyHan(this);" style="ime-mode:disabled;">'
        }else if($(this).val() == 'tel' || $(this).val() == 'mobile'){
            inputText = '<input type="text" id="searchWords" name="searchWords" class="text" size="40" maxlength="50" onkeypress="return onlyNumber(event, \'numbers\');" onkeyup="onlyHan(this);" style="ime-mode:disabled;" >'
        }
        
        $('#searchDiv').append(inputText);
    });
});
var memberListSet = {
    memberList : [],
    getList : function(){
        var url = '/admin/operation/member-list',dfd = $.Deferred();
        var param = $('#form_member_list_search').serialize();

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            var searchMember = "";
            var template = 
                '<tr data-member-no="{{memberNo}}" data-member-nm="{{memberNm}}" data-email="{{email}}" data-login-id="{{loginId}}">'+
                '<td>'+
                '    <label for="chack05_{{rownum}}" class="chack" id= "chackLable05_{{memberNo}}" > '+
                '    <span class="ico_comm"><input type="checkbox" name="selectMember" id="chack05_{{memberNo}}"  value="{{lettNo}}" /></span></label>'+
                '</td>'+
                '<td>{{rowNum}}</td><td>{{memberGradeNm}}</td>' +
                '<td>{{joinPathNm}}</td><td>{{memberNm}}</td>'+
                '<td><a href="#none" class="tbl_link" onclick="viewMemInfoDtl({{memberNo}});">{{loginId}}</a></td>'+
                '<td><a href="#none" class="tbl_link">{{email}}</a></td>'+
                '<td><a href="#none" class="tbl_link">{{mobile}}</a><br><a href="#none" class="tbl_link">{{tel}}</a></td>'+
                '<td>{{joinDttm}}<br>{{lastLoginDttm}}</td>'+
                '<td><a href="#savedMnLayout" onclick="javascript:openSaveMnLayer(\'{{memberNo}}\',\'{{memberNm}}\',\'{{loginId}}\',\'{{prcAmt}}\');" class="tbl_link popup_open">{{prcAmt}}</a></td>'+
                '<td>{{loginCnt}}</td>'+
                '<td><div class="pop_btn"><a href="#none" class="btn_blue" onclick="viewMemInfoDtl(\'{{memberNo}}\');">상세</a></div></td>',
                managerGroup = new Dmall.Template(template),
                    tr = '';
  
            $("#searchMemberList").empty();
            $.each(result.resultList, function(idx, obj) {
                tr += managerGroup.render(obj);
                
                searchMember = '<li class="txt_del" id ="search_'+obj.memberNo+'">'+obj.memberNm+' '+obj.email+
                '<input type = "hidden" id="recvEmailSearch" name ="recvEmailSearch" value="'+obj.email+'" />'+
                '<input type = "hidden" id="receiverNoSearch" name ="receiverNoSearch" value="'+obj.memberNo+'" />'+
                '<input type = "hidden" id="receiverIdSearch" name ="receiverIdSearch" value="'+obj.loginId+'" />'+
                '<input type = "hidden" id="receiverNmSearch" name ="receiverNmSearch" value="'+obj.memberNm+'" />'+
                '  <button class="btn_del btn_comm" onclick="javascript:deleteMemberInfo(\''+obj.memberNo+'\',\'search\');">삭제</button></li>';

                $("#searchMemberList").append(searchMember);
            });

            if(tr == '') {
                tr = '<tr><td colspan="12">데이터가 없습니다.</td></tr>';
            }
            $('#tbody_id_memberList').html(tr);
            memberListSet.memberList = result.resultList;
            dfd.resolve(result.resultList);
            
            Dmall.GridUtil.appendPaging('form_member_list_search', 'div_member_paging', result, 'pagingt_smsIndividualSentHist',
                    memberListSet.getList);
            
            searchMemberCnt = result.filterdRows;
            $("#searchMemberCnt").text("("+searchMemberCnt+"명)");

            $("#sendSelect").text(result.filterdRows);
            $("#sendTotal").text(result.totalRows);
        });
    }
}

//회원 상세 정보
function viewMemInfoDtl(memberNo){
  var memNO = memberNo;
  Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', {memberNo : memNO});
}

function deleteMemberInfo(memberNo, gb){
    $("#"+gb+"_"+memberNo).remove();
    
    if(gb=="total"){
        totalMemberCnt = totalMemberCnt-1;
        $("#totalMemberCnt").text("("+totalMemberCnt+"명)");
        $("#sendMemberCnt").text(totalMemberCnt);
    }else if(gb=="search"){
        searchMemberCnt = searchMemberCnt-1;
        $("#searchMemberCnt").text("("+searchMemberCnt+"명)");
        $("#sendMemberCnt").text(searchMemberCnt);
    }else{
        selectMemberCnt = selectMemberCnt-1;
        $("#selectMemberCnt").text("("+selectMemberCnt+"명)");
        $("#sendMemberCnt").text(selectMemberCnt);

        $("#chackLable05_"+memberNo).removeClass('on');
        $("#chack05_"+memberNo).prop('checked', false);
    }
}

/* 한글입력 방지 */
function onlyHan(obj)
{
    //좌우 방향키, 백스페이스, 딜리트, 탭키에 대한 예외
    if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39
    || event.keyCode == 46 ) return;
    //obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
    obj.value = obj.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
}

/* 숫자만 입력받기 */
function onlyNumber(event, type) {
    if(type == "numbers") {
        if(event.keyCode < 48 || event.keyCode > 57) return false;
        //onKeyDown일 경우 좌, 우, tab, backspace, delete키 허용 정의 필요
    }
}

</script>

<!-- search_box -->
     <div class="search_box">
         <!-- search_tbl -->
         <form:form id="form_member_list_search" commandName="memberManageSO">
         <form:hidden path="page" id="hd_page1"  name = "page" value="1" />
         <form:hidden path="rows" id="hd_rows1"   name = "rows"  value="" />
         <input type="hidden" id = "sort" name="sort" value="member_No" />
         <div class="search_tbl">
             <table summary="이표는 [SMS발송] 설정 검색 표 입니다. 구성은 가입일, 최종방문일, 생일, SMS수신, 이메이수신, 회원등급, 구매금액, 마켓포인트, 주문횟수, 댓글횟수, 방문횟수, 성별, 포인트, 가입 방법, 검색어 입니다.">
                 <caption>[SMS발송] 설정 검색</caption>
                 <colgroup>
                     <col width="15%">
                     <col width="35%">
                     <col width="15%">
                     <col width="35%">
                 </colgroup>
                 <tbody>
                    <tr>
                        <th>가입일</th>
                        <td colspan="3">
                            <tags:calendar from="joinStDttm" to="joinEndDttm"  fromValue="" toValue="" idPrefix="join" />
                        </td>
                    </tr>
                    <tr>
                        <th>최종방문일</th>
                        <td colspan="3">
                            <tags:calendar from="loginStDttm" to="loginEndDttm"  fromValue="" toValue="" idPrefix="login" />
                        </td>
                    </tr>
                    <tr>
                        <th>생일</th>
                        <td colspan="3">
                            <tags:calendar from="stBirth" to="endBirth"  fromValue="" toValue="" idPrefix="birth" />
                        </td>
                    </tr>
                    <tr>
                        <th>SMS수신</th>
                        <td>
                            <tags:radio name="smsRecvYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_smsRecvYn" value="" />
<!--                             <label for="radio01" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="SMS" id="radio01" checked="checked" /></span> 전체</label> -->
<!--                             <label for="radio02" class="radio mr20"><span class="ico_comm"><input type="radio" name="SMS" id="radio02" /></span> 동의</label> -->
<!--                             <label for="radio03" class="radio mr20"><span class="ico_comm"><input type="radio" name="SMS" id="radio03" /></span> 거부</label> -->
                        </td>
                        <th class="line">이메일수신</th>
                        <td>
                            <tags:radio name="emailRecvYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_emailRecvYn" value="" />
<!--                             <label for="radio04" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="mail" id="radio04" checked="checked" /></span> 전체</label> -->
<!--                             <label for="radio05" class="radio mr20"><span class="ico_comm"><input type="radio" name="mail" id="radio05" /></span> 동의</label> -->
<!--                             <label for="radio06" class="radio mr20"><span class="ico_comm"><input type="radio" name="mail" id="radio06" /></span> 거부</label> -->
                        </td>
                    </tr>
                    <tr>
                        <th>회원등급</th>
                        <td>
                            <span class="select">
                                <label for="srch_id_memberGrade"></label>
                                <select name="memberGradeNo" id="srch_id_memberGrade">
                                    <option value="">전체</option>
                                    <c:forEach var = "gradeList" items="${memberGradeListModel.resultList}">
                                        <option value="${gradeList.memberGradeNo}" >${gradeList.memberGradeNm}</option>
                                    </c:forEach>
                                </select>
                            </span>
                        </td>
                        <th class="line">구매금액</th>
                        <td>
                            <span class="intxt">
                                <form:input path="stSaleAmt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50"  />
                            </span>
                            <form:errors path="stSaleAmt" cssClass="errors"  />
                            ~
                            <span class="intxt">
                                <form:input path="endSaleAmt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50" />
                            </span>
                            <form:errors path="endSaleAmt" cssClass="errors"  />
                        </td>
                    </tr>
                    <tr>
                        <th>마켓포인트</th>
                        <td>
                            <span class="intxt">
                                <form:input path="stPrcAmt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50"  />
                            </span>
                            <form:errors path="stPrcAmt" cssClass="errors"  />
                            ~
                            <span class="intxt">
                                <form:input path="endPrcAmt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50" />
                            </span>
                            <form:errors path="endPrcAmt" cssClass="errors"  />
                        </td>
                        <th>주문횟수</th>
                        <td>
                            <span class="intxt">
                                <form:input path="stOrdCnt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50"  />
                            </span>
                            <form:errors path="stOrdCnt" cssClass="errors"  />
                            ~
                            <span class="intxt">
                                <form:input path="endOrdCnt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50" />
                            </span>
                            <form:errors path="endOrdCnt" cssClass="errors"  />
                        </td>
                    </tr>
                    <tr>
                        <th>댓글횟수</th>
                        <td>
                            <span class="intxt">
                                <form:input path="stCommentCnt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50"  />
                            </span>
                            <form:errors path="stCommentCnt" cssClass="errors"  />
                            ~
                            <span class="intxt">
                                <form:input path="endCommentCnt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50" />
                            </span>
                            <form:errors path="endCommentCnt" cssClass="errors"  />
                        </td>
                        <th>방문횟수</th>
                        <td>
                            <span class="intxt">
                                <form:input path="stLoginCnt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50"  />
                            </span>
                            <form:errors path="stLoginCnt" cssClass="errors"  />
                            ~
                            <span class="intxt">
                                <form:input path="endLoginCnt" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50" />
                            </span>
                            <form:errors path="endLoginCnt" cssClass="errors"  />
                        </td>
                    </tr>
                    <tr>
                        <th>성별</th>
                        <td>
                            <tags:radio name="genderGbCd" codeStr=":전체;M:남;F:여" idPrefix="srch_id_genderGbCd" value="" />
                        </td>
                        <th>다비치포인트</th>
                        <td>
                            <span class="intxt">
                                <form:input path="stPrcPoint" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50"  />
                            </span>
                            <form:errors path="stPrcPoint" cssClass="errors"  />
                            ~
                            <span class="intxt">
                                <form:input path="endPrcPoint" cssClass="text" cssErrorClass="text medium error" onkeypress="return onlyNumber(event, 'numbers');" onkeyup="onlyHan(this);" size="40" maxlength="50" />
                            </span>
                            <form:errors path="endPrcPoint" cssClass="errors"  />
                        </td>
                    </tr>
                    <tr>
                        <th>가입정보</th>
                        <td colspan="3">
                            <label for="joinPathCd1" class="chack mr20">
                                <span class="ico_comm">
                                    <form:checkbox path="joinPathCd" id="joinPathCd1" value="SHOP" label="" cssClass="blind"/>
                                </span>
                                             쇼핑몰 ID
                            </label>
                            <label for="joinPathCd2" class="chack mr20">
                                <span class="ico_comm">
                                    <form:checkbox path="joinPathCd" id="joinPathCd2" value="FB" label="" cssClass="blind"/>
                                </span>
                                             페이스북
                            </label>
                            <label for="joinPathCd3" class="chack mr20">
                                <span class="ico_comm">
                                    <form:checkbox path="joinPathCd" id="joinPathCd3" value="KT" label="" cssClass="blind"/>
                                </span>
                                             카카오
                             </label>
                             <label for="joinPathCd4" class="chack mr20">
                                 <span class="ico_comm">
                                     <form:checkbox path="joinPathCd" id="joinPathCd4" value="NV" label="" cssClass="blind"/>
                                 </span>
                                              네이버
                             </label>
                        </td>
                    </tr>
                    <tr>
                        <th>검색어</th>
                        <td colspan="3">
                            <div class="select_inp" id="searchDiv">
                                <span>
                                    <label for="srch_id_searchType">전체</label>
                                    <select name="searchType" id="srch_id_searchType">
                                        <tags:option codeStr="all:전체;name:이름;id:아이디;email:이메일;tel:전화번호;mobile:핸드폰번호" value="" />
                                    </select>
                                </span>
                                <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="40" maxlength="50" />
                                <form:errors path="searchWords" cssClass="errors"  />
                            </div>
                        </td>
                    </tr>
                 </tbody>
             </table>
         </div>
         </form:form>
         <div class="btn_box txtc">
             <a href="#none" class="btn green" id="btn_id_search">검색</a>
         </div>
     </div>

     <!-- line_box -->
     <div class="line_box">
         <div class="top_lay">
             <div class="search_txt">
                 검색 <strong class="be" id = "sendSelect"></strong>개 /
                 총 <strong class="all" id = "sendTotal"></strong>개
             </div>
             <div class="select_btn">
                 <span class="select">
                     <label for="sel_sord"></label>
                     <select name="sord" id="sel_sord">
                         <tags:option codeStr="A.REG_DTTM DESC:최근 등록일 순▽;A.REG_DTTM ASC:나중 등록일 순△" />
                     </select>
                 </span>
                 <span class="select">
                    <label for="select1"></label>
                    <select name="rows" id="sel_rows">
                        <tags:option codeStr="10:10개 출력;20:20개 출력;50:50개 출력" />
                    </select>
                 </span>
                 <button class="btn_exl"  id="btn_download">Excel download <span class="ico_comm">&nbsp;</span></button>
             </div>
         </div>

         <!-- tblh -->
         <div class="tblh th_l">
             <table summary="게시판 리스트"  id="table_id_bbsList">
                 <caption>회원리스트</caption>
                 <colgroup>
                     <col width="5%">
                     <col width="6%">
                     <col width="8%">
                     <col width="8%">
                     <col width="8%">
                     <col width="8%">
                     <col width="14%">
                     <col width="11%">
                     <col width="9%">
                     <col width="8%">
                     <col width="8%">
                     <col width="7%">
                 </colgroup>
                 <thead>
                     <tr>
                         <th>
                             <input type="checkbox" name="table" id="chack05" class="blind" />
                             <label for="chack05" class="chack" onclick="chack_btn(this);">
                                 <span class="ico_comm">&nbsp;</span>
                             </label>
                         </th>
                         <th>번호</th>
                         <th>등급</th>
                         <th>가입경로</th>
                         <th>이름</th>
                         <th>아이디</th>
                         <th>이메일</th>
                         <th>휴대폰번호<br>전화번호</th>
                         <th>가입일<br>최종방문</th>
                         <th>마켓포인트</th>
                         <th>방문횟수</th>
                         <th>관리</th>
                     </tr>
                 </thead>
                 <tbody id=tbody_id_memberList>
                     <tr>
                         <td></td>
                         <td></td>
                         <td></td>
                         <td></td>
                         <td></td>
                         <td></td>
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
         <div class="bottom_lay" >
             <div class="left">
                 <div class="pop_btn">
                     <button class="btn_gray2 sms_click" id = "emailIndividualSend">이메일 발송</button>
                 </div>
             </div>
             <!-- pageing -->
             <div class="bottom_lay" id="div_member_paging"></div>
             <!-- //pageing -->
         </div>
         <!-- //bottom_lay -->
         <form id="form_id_emailSendInsert">
         <input type="hidden" name="curPage" id="curPage" />
         <div class="sms_send">
             <h3 class="tlth3">이메일 전송</h3>
             <!-- tblw -->
             <div class="tblw">
                 <table summary="이표는 이메일 전송 표 입니다. 구성은 보유 이메일 건수, 받는사람, 메시지 전송 입니다.">
                     <caption>이메일 전송</caption>
                     <colgroup>
                         <col width="15%">
                         <col width="85%">
                     </colgroup>
                     <tbody>
                         <tr>
                             <th>보유 이메일 건수</th>
                             <td>${possCnt}건</td>
                         </tr>
                         <tr>
                             <th>받는사람</th>
                             <td>
                                 <label for="radio01" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="EmailMember" id="radio01" value="all" checked="checked"></span> 전체회원 <span class="sdesc" id = "totalMemberCnt"></span></label>
                                 <span class="br2"></span>
                                 <label for="radio02" class="radio mr20"><span class="ico_comm"><input type="radio" name="EmailMember" id="radio02" value="search" ></span> 검색된 회원 <span class="sdesc" id = "searchMemberCnt"></span></label>
                                 <span class="br2"></span>
                                 <label for="radio03" class="radio mr20"><span class="ico_comm"><input type="radio" name="EmailMember" id="radio03" value="select" ></span> 선택된 회원 <span class="sdesc" id = "selectMemberCnt"></span></label>
                                 <span class="br"></span>
                                 추가이메일 : <span class="intxt long2">
                                        <input id="addEmail" type="text" onkeyup="return onlyHan(this);" style="ime-mode:disabled;">
                                    </span>
                                 <button class="plus btn_comm" type="button">더하기 버튼</button>
                                 <span class="br2"></span>
                                 <div class="disposal_log">
                                     <ul id = "totalMemberList">
                                         <c:forEach var="memTotalList" items="${resultListModelTotal}" varStatus="status">
                                             <li class="txt_del" id ="total_${memSearchList.memberNo}">${memTotalList.memberNm} ${memTotalList.email}
                                             <input type = "hidden" id="recvEmailTotal" name ="recvEmailTotal" value="${memTotalList.email}" />
                                             <input type = "hidden" id="receiverNoTotal" name ="receiverNoTotal" value="${memTotalList.memberNo}" />
                                             <input type = "hidden" id="receiverIdTotal" name ="receiverIdTotal" value="${memTotalList.loginId}" />
                                             <input type = "hidden" id="receiverNmTotal" name ="receiverNmTotal" value="${memTotalList.memberNm}" />
                                             <button type="button" class="btn_del btn_comm" onclick="deleteMemberInfo('total_${memSearchList.memberNo}','total');">삭제</button>
                                             </li>
                                         </c:forEach>
                                     </ul>
                                     <ul id = "searchMemberList">
     
                                     </ul>
                                     <ul id = "selectMemberList">
                                         
                                     </ul>
                                 </div>
                                 <span class="br2"></span>
<!--                                  <input type="checkbox" name="table1" id="chack44" class="blind" /> -->
<!--                                  <label for="chack44" class="chack mr20" onclick="chack_btn(this);"> -->
<!--                                      <span class="ico_comm">&nbsp;</span> -->
<!--                                      추가 이메일만 보냄 -->
<!--                                  </label> -->
                             </td>
                         </tr>
                         <tr>
                             <th class="line">메시지 전송</th>
                             <td>
                                 받는사람 : <span id="sendMemberCnt">${totalSize}</span>명
                                 <span class="br2"></span>
                                 보내는 사람 : <span class="intxt long2"><input type="text" id="sendEmail" name = "sendEmail" value="${adminEmail}" readonly="readonly"></span><br>
                                 <span class="br2"></span>
                                 제목 : <span class="intxt long"><input type="text" id="mailTitle" name = "mailTitle"></span><br>
                                 <span class="br2"></span>
                                 <div class="edit">
                                     <textarea id="emailContent" name="mailContent" class="blind"></textarea>
                                 </div>
                             </td>
                         </tr>
                     </tbody>
                 </table>
             </div>
             <!-- //tblw -->
             <div class="btn_box txtc">
                 <button type="button" class="btn green" id="sendEmailInsert">이메일 전송</button>
             </div>
         </div>
         </form>
         <!-- //sms_send -->
         <!-- //line_box -->
     </div>
