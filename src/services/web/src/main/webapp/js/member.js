function customerInputCheck() {
    if(jQuery('#memberNm').val() === '') {
        Dmall.LayerUtil.alert("이름을 입력해주세요.");
        jQuery('#memberNm').focus();
        return false;
    }
    if(jQuery('#loginId').val() === '') {
        Dmall.LayerUtil.alert("아이디를 입력해주세요.");
        jQuery('#loginId').focus();
        return false;
    }
    //=== 특수문자 및 공백 입력 방지
    //원본
    //var spc = "!#$%&*+-./=?@^_` {|}";
    //수정(sns 로그인을 사용하면 아이디에 _(underscore)가 들어가 있어서 수정이 안되기때문에 제거한다.)
   /* var spc = "!#$%&*+-./=?@^` {|}";
    for(i=0;i<jQuery('#loginId').val().length;i++) {
        if (spc.indexOf(jQuery('#loginId').val().substring(i, i+1)) >= 0) {
            Dmall.LayerUtil.alert("특수문자나 공백을 입력할 수 없습니다.", "확인");
            return false;
        }
    }*/
    /*if (jQuery('#loginId').val().length<6 || jQuery('#loginId').val().length>20){
        Dmall.LayerUtil.alert("아이디는 6~20자입니다.", "확인");
        return false;
    }*/

    /*var hanExp = jQuery('#loginId').val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
    if( hanExp > -1 ){
        Dmall.LayerUtil.alert("한글은 아이디에 사용하실수 없습니다.", "확인");
        return false;
    }*/

    if($('#sms_get').is(":checked") == true){
        $('#smsRecvYn').val('Y');
    }else{
        $('#smsRecvYn').val('N');
    }
    if($('#email_get').is(":checked") == true){
        $('#emailRecvYn').val('Y');
    }else{
        $('#emailRecvYn').val('N');
    }
    
    if(Dmall.validation.isEmpty($("#mobile01").val())||Dmall.validation.isEmpty($("#mobile02").val())||Dmall.validation.isEmpty($("#mobile03").val())) {
        Dmall.LayerUtil.alert("휴대전화를 입력해주세요.");
        $('#mobile01').focus();
        return false;
    }
    else {
    	$('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
    	var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
        if(!regExp.test($('#mobile').val())) {
            Dmall.LayerUtil.alert('유효하지 않은 휴대전화번호 입니다.<br>휴대전화번호를 정확히 입력해 주십시요.').done(function(){
                $('#mobile01').focus();
            });
            return false;
        }
    }
    
    if(Dmall.validation.isEmpty($("#email01").val())|| Dmall.validation.isEmpty($("#email02").val())) {
        Dmall.LayerUtil.alert("이메일을 입력해주세요.");
        jQuery('#email01').focus();
        return false;
    }
    
    if(!checkPost()){//주소검증
        return false;
    }
    $('#email').val($('#email01').val().trim() + "@" + $('#email02').val().trim() );
    //$('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
    /*if($('#tel01').val() != '' && $('#tel02').val() != '' && $('#tel03').val() != ''){
        $('#tel').val($('#tel01').val()+'-'+$('#tel02').val()+'-'+$('#tel03').val());
    }*/
    return true;
}

function birthInputCheck(){
    var year = jQuery('#select_id_year option:selected').val();
    var month = jQuery('#select_id_month option:selected').val();
    var date = jQuery('#select_id_date option:selected').val();
    if(year === '') {
        Dmall.LayerUtil.alert("년도를 선택해 주세요");
        jQuery('#select_id_year').focus();
        return false;
    }
    if(month === '') {
        Dmall.LayerUtil.alert("월을 선택해 주세요");
        jQuery('#select_id_month').focus();
        return false;
    }
    if(date === '') {
        Dmall.LayerUtil.alert("일을 선택해 주세요");
        jQuery('#select_id_date').focus();
        return false;
    }
    $('#birth').val(year+month+date);
    return true;
}

function deliveryInputCheck() {
    if(jQuery('#gbNm').val() === '') {
        Dmall.LayerUtil.alert("배송지명을 입력해주세요.");
        jQuery('#gbNm').focus();
        return false;
    }
    if(jQuery('#adrsNm').val() === '') {
        Dmall.LayerUtil.alert("이름을 입력해주세요.");
        jQuery('#adrsNm').focus();
        return false;
    }
    //배송지
  	if($('#newPostNo').val() == ''){
		Dmall.LayerUtil.alert("배송지를 입력해 주세요.", "확인");
		$('#newPostNo').focus();
		return false;
  	}
  	//상세주소
  	if($('#dtlAddr').val() == ''){
		Dmall.LayerUtil.alert("상세주소를 입력해 주세요.", "확인");
		$('#dtlAddr').focus();
		return false;
  	}
    /*if(!checkPost()){//주소검증
        return false;
    }*/
    if(Dmall.validation.isEmpty($("#mobile01").val())||Dmall.validation.isEmpty($("#mobile02").val())||Dmall.validation.isEmpty($("#mobile03").val())) {
        Dmall.LayerUtil.alert("휴대전화를 입력해주세요.");
        $('#mobile01').focus();
        return false;
    }
    else {
    	$('#mobile').val($('#mobile01').val()+$('#mobile02').val()+$('#mobile03').val());
        var regExp = /^\d{3}\d{3,4}\d{4}$/;
        if(!regExp.test($('#mobile').val())) {
            Dmall.LayerUtil.alert('유효하지 않은 휴대전화번호 입니다.<br>휴대전화번호를 정확히 입력해 주십시요.').done(function(){
                $('#mobile01').focus();
            });
            return false;
        }
    }
    
    //기본 국내설정
    $('#memberGbCd').val('10');
    
    $('#tel').val($('#tel01').val()+$('#tel02').val()+$('#tel03').val());
    var defaultYn = $("input:checkbox[name='defaultYn_check']:checked").val();
    if(defaultYn == 'on'){
        $('#defaultYn').val("Y");
    }else{
        $('#defaultYn').val("N");
    }
    return true;
}

function snsInputCheck() {
    if(!checkPost()){
        return false;
    }
    if(Dmall.validation.isEmpty($("#mobile01").val())||Dmall.validation.isEmpty($("#mobile02").val())||Dmall.validation.isEmpty($("#mobile03").val())) {
        Dmall.LayerUtil.alert("휴대전화를 입력해주세요.");
        $("#mobile01").focus();
        return false;
    }
    $('#mobile').val($('#mobile01').val()+$('#mobile02').val()+$('#mobile03').val());
    return true;
}

//주소입력 검증(국내/해외)
function checkPost(){
    if($('#shipping_internal').is(":checked") == true){
        $('#memberGbCd').val('10');
        if(Dmall.validation.isEmpty($("#newPostNo").val())) {
            Dmall.LayerUtil.alert("우편번호를 입력해주세요.");
            jQuery('#newPostNo').focus();
            return false;
        }
        if(Dmall.validation.isEmpty($("#strtnbAddr").val()) && Dmall.validation.isEmpty($("#roadAddr").val())) {
            Dmall.LayerUtil.alert("주소를 입력해주세요.");
            jQuery('#roadAddr').focus();
            return false;
        }
        /*
        if(Dmall.validation.isEmpty($("#strtnbAddr").val())) {
            jQuery('#strtnbAddr').focus();
            jQuery('#strtnbAddr').validationEngine('showPrompt', '지번주소를 입력해주세요.', 'error');
            return false;
        }
        if(Dmall.validation.isEmpty($("#roadAddr").val())) {
            jQuery('#roadAddr').focus();
            jQuery('#roadAddr').validationEngine('showPrompt', '도로명주소를 입력해주세요.', 'error');
            return false;
        }
        */
        if(Dmall.validation.isEmpty($("#dtlAddr").val())) {
            Dmall.LayerUtil.alert("상세주소를 입력해주세요.");
            jQuery('#dtlAddr').focus();
            return false;
        }
    }else if($('#shipping_oversea').is(":checked") == true) {
        $('#memberGbCd').val('20');
        if (Dmall.validation.isEmpty($("#frgAddrZipCode").val())) {
            Dmall.LayerUtil.alert("Zip을 입력해주세요.");
            jQuery('#frgAddrZipCode').focus();
            return false;
        }
        if (Dmall.validation.isEmpty($("#frgAddrState").val())) {
            Dmall.LayerUtil.alert("State를 입력해주세요.");
            jQuery('#frgAddrState').focus();
            return false;
        }
        if (Dmall.validation.isEmpty($("#frgAddrCity").val())) {
            Dmall.LayerUtil.alert("City를 입력해주세요.");
            jQuery('#frgAddrCity').focus();
            return false;
        }
        if (Dmall.validation.isEmpty($("#frgAddrDtl1").val())) {
            Dmall.LayerUtil.alert("address1를 입력해주세요.");
            jQuery('#frgAddrDtl1').focus();
            return false;
        }
        if (Dmall.validation.isEmpty($("#frgAddrDtl2").val())) {
            Dmall.LayerUtil.alert("address2를 입력해주세요.");
            jQuery('##frgAddrDtl2').focus();
            return false;
        }
    }else{
        //기본 국내설정
        $('#memberGbCd').val('10');
    }
    return true;
}

//id popup 초기화
function reset_id_popup(){
    $('#loginId').val('');
    $('#id_check').val('');
    $('#id_success_div').attr('style','display:none;')
    $('.id_duplicate_check_info').html('');
}

//password popup 초기화
function resetPwPopup(){
    $('#nowPw').val('');
    $('#newPw').val('');
    $('#newPw_check').val('');
}
//생년월일 select box 초기화
function setCalendar() {
    var html = '',
        d = new Date(),
        firstYear = d.getFullYear() - 100;
    for (var i = d.getFullYear(); i >= firstYear; i--) {
        html += '<option value="' + i + '">' + i + '</option>';
    }
    $('#select_id_year').append(html);
    html = '';
    for(var i = 1; i <= 12; i++) {
        if(i<10){
            html += '<option value="0' + i + '">0' + i + '</option>';
        }else{
            html += '<option value="' + i + '">' + i + '</option>';
        }
    }
    $('#select_id_month').append(html);
}

//우편번호 정보 반환
function setZipcode(data) {
    var fullAddr = data.address; // 최종 주소 변수
    var extraAddr = ''; // 조합형 주소 변수
    // 기본 주소가 도로명 타입일때 조합한다.
    if (data.addressType === 'R') {
        //법정동명이 있을 경우 추가한다.
        if (data.bname !== '') {
            extraAddr += data.bname;
        }
        // 건물명이 있을 경우 추가한다.
        if (data.buildingName !== '') {
            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
        }
        // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
        fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
    }
    // 우편번호와 주소 정보를 해당 필드에 넣는다.
    $('#oldPostNo').val(data.postcode);
    $('#newPostNo').val(data.zonecode);
    $('#strtnbAddr').val(data.jibunAddress);
    $('#roadAddr').val(data.roadAddress);
}

// 팝업 리사이징
function popupAutoResize() {
    var thisX = parseInt(document.body.scrollWidth);
    var thisY = parseInt(document.body.scrollHeight);
    var maxThisX = screen.width - 50;
    var maxThisY = screen.height - 50;
    var marginY = 0;
    //alert(thisX + "===" + thisY);
    //alert("임시 브라우저 확인 : " + navigator.userAgent);
    // 브라우저별 높이 조절. (표준 창 하에서 조절해 주십시오.)
    if (navigator.userAgent.indexOf("MSIE 6") > 0) marginY = 45;        // IE 6.x
    else if(navigator.userAgent.indexOf("MSIE 7") > 0) marginY = 75;    // IE 7.x
    else if(navigator.userAgent.indexOf("MSIE 8") > 0) marginY = 80;    // IE 8.x
    else if(navigator.userAgent.indexOf("Firefox") > 0) marginY = 50;   // FF
    else if(navigator.userAgent.indexOf("Opera") > 0) marginY = 30;     // Opera
    else if(navigator.userAgent.indexOf("Netscape") > 0) marginY = -2;  // Netscape

    if (thisX > maxThisX) {
        window.document.body.scroll = "yes";
        thisX = maxThisX;
    }
    if (thisY > maxThisY - marginY) {
        window.document.body.scroll = "yes";
        thisX += 19;
        thisY = maxThisY - marginY;
    }
    window.resizeTo(thisX+10, thisY+marginY);
}

function passwordInputCheck(){
    var txt = $("#pw").val();
    var loginId = $("#loginId").val();
    var len_all = /^[a-z]+[a-z0-9]{5,11}$/g;
    var len_num = txt.search(/[0-9]/g);
    var len_eng = txt.search(/[a-z]/g);
    var len_asc = txt.search(/[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi);
    var pass_level =0;
    //alert("숫자 : "+len_num+"\n 영문자 : "+len_eng+"\n 특수문자 : "+len_asc);
    //안전: 3가지 조합(영문,숫자,특수문자)
    //보통: 2가지 조합(영문+숫자,영문+특수문자)
    //미흡: 2가지 조합(영문+숫자)
    $("#passCheck").html("<i class='caution_3depth'>미흡</i>");
    if( (len_eng > -1&&len_num > -1) || (len_eng > -1&&len_asc > -1) ){
        $("#passCheck").html("<i class='caution_2depth'>보통</i>");
    }
    if(len_num > -1 && len_eng > -1 && len_asc > -1){
        $("#passCheck").html("<i class='caution_1depth'>안전</i>");
    }
    if(/(\w)\1\1/.test(txt) || $.trim(loginId) == $.trim(txt)){ // 동일문구 3번 반복시, 아이디와 동일 무조건 미흡
        $("#passCheck").html("<i class='caution_3depth'>미흡</i>");
    }
    if(Dmall.validation.isEmpty(txt)) {
        $("#passCheck").html("");
    }
}
//비밀번호 검증
function passwordCheck(val){
    var len_all = /^[a-z]+[a-z0-9]{5,11}$/g;
    var len_num = val.search(/[0-9]/g);
    var len_eng = val.search(/[a-z]/g);
    var len_asc = val.search(/[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi);
    var pass_level =0;
    //alert("숫자 : "+len_num+"\n 영문자 : "+len_eng+"\n 특수문자 : "+len_asc);
    //안전: 3가지 조합(영문,숫자,특수문자)
    //보통: 2가지 조합(영문+숫자,영문+특수문자)
    //미흡: 2가지 조합(영문+숫자)
    var level_check = false;
    if( (len_eng > -1&&len_num > -1) || (len_eng > -1&&len_asc > -1) ){
        level_check = true;
    }
    if(len_num > -1 && len_eng > -1 && len_asc > -1){
        level_check = true;
    }
    if(!level_check){
        Dmall.LayerUtil.alert("비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.", "확인")
        return false;
    }
    if (val.length<8 || val.length>16){
        Dmall.LayerUtil.alert("비밀번호는 8~16자입니다.", "확인");
        return false;
    }
    if(/(\w)\1\1/.test(val)){
        Dmall.LayerUtil.alert("동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.", "확인");
        return false;
    }
    return true;
}
//아이디 검증
function idCheck(val){
    if(Dmall.validation.isEmpty(val)) {
        $('#id_success_div').attr('style','display:none;')
        Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
        return false;
    }
    var spc = "!#$%&*+-./=?@^` {|}";
    for(i=0;i<val.length;i++) {
        if (spc.indexOf(val.substring(i, i+1)) >= 0) {
            Dmall.LayerUtil.alert("특수문자나 공백을 입력할 수 없습니다.", "확인");
            return false;
        }
    }
    if (val.length<6 || val.length>20){
        Dmall.LayerUtil.alert("아이디는 6~20자입니다.", "확인");
        return false;
    }
    var hanExp = val.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
    if( hanExp > -1 ){
        Dmall.LayerUtil.alert("한글은 아이디에 사용하실수 없습니다.", "확인");
        return false;
    }
    return true;
}

