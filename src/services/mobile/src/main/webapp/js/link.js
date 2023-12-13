jQuery(document).ready(function(){
    //상단 네비게이션 이동 함수 setting
    $("[id^=navigation_combo_]").on("change",function(){
        move_category(this.value);
    })
    // 페이지당 상품 조회수량 변경
    $("#view_count").on("change",function(){
        change_view_count();
    })
    //이전으로 가기
    $(".btn_prev_page").on("click",function (){
        history.back();
    });

    //장바구니 팝업 닫기
    $('#btn_close_pop').on('click', function(){
        Dmall.LayerPopupUtil.close('success_basket');
    });

    //장바구니이동
    $('#btn_move_basket').on('click', function(){
        //location.href = MOBILE_CONTEXT_PATH+"/front/basket/basket-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/basket/basket-list");

    });

    //sns부가정보입력 팝업여부
    if( sns_add_info_Yn == "Y"){

        var target = MOBILE_CONTEXT_PATH+"/front/login/sns-addinfo-pop";
       popup =  window.open('about:blank', "SNS부가정보 입력","width=700,height=600", false);


       popup.location =target;
    }

    //TOP BOTTON 클릭시 상단으로이동
    $('.btn_quick_top').click(function(){
        $('html, body').animate({scrollTop:0},400);
        return false;
    });

    //오른쪽 퀵메뉴 조회(모바일제외)
    //RightQuickMenu();

    // 왼쪽 날개배너 조회
    /*var selectLeftWing = MOBILE_CONTEXT_PATH+'/front/promotion/leftwing-info';
    Dmall.AjaxUtil.load(selectLeftWing, function(result) {
        $('#banner').html(result);
    })*/

    // 상단 상품검색
    /*$('#btn_search').on('click',function(){
        if($('#searchText').val() === '') {
            Dmall.LayerUtil.alert("입력된 검색어가 없습니다.", "알림");
            return false;
        }
        var param = {searchType:'1',searchWord : $("#searchText").val()}
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+'/front/search/goods-list-search', param);
    });*/

    // top-menu-cart
    $('#move_cart').on('click',function(){
        //location.href = MOBILE_CONTEXT_PATH+"/front/basket/basket-list"
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/basket/basket-list");
    });
    // top-menu-order/delivery
    $('[id^=move_order]').on('click',function(){
        if(loginYn == 'true') {
            //location.href = MOBILE_CONTEXT_PATH+"/front/order/order-list";
            Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/order/order-list");
        }else{
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
                    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");

                },'');
        }
    });
    //top-menu-mypage
    $('#move_mypage').on('click',function(){
        if(loginYn == 'true') {
            //location.href = MOBILE_CONTEXT_PATH+"/front/member/mypage";
            Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/member/mypage");
        }else{
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login?returnUrl="+MOBILE_CONTEXT_PATH+"/front/member/mypage"
                    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login?returnUrl="+MOBILE_CONTEXT_PATH+"/front/member/mypage");
                },'');
        }
    })
});

//금액 소수점
function commaNumber(p){
    if(p==0) return 0;
    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (p + '');
    while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
    return n;
}
//이모티콘 이벤트
function fn_imoticon_event(){
	var startDate = '2019091814';
	var endDate = '2019100100';
	var now = new Date();   //현재시간
    
	year = now.getFullYear();   //현재시간 중 4자리 연도
	month = now.getMonth()+1;   //현재시간 중 달. 달은 0부터 시작하기 때문에 +1 
	if((month+"").length < 2){
	    month="0"+month;   //달의 숫자가 1자리면 앞에 0을 붙임.
	}
	date = now.getDate();      //현재 시간 중 날짜.
	if((date+"").length < 2){
	    date="0"+date;      
	}
	hour = now.getHours();   //현재 시간 중 시간.
	if((hour+"").length < 2){
	hour="0"+hour;      
	}
	today = year + "" + month + "" + date+ "" +hour;      //오늘 날짜 완성.
    
	if(eval(today) >= eval(startDate) && eval(today) < eval(endDate)){
    	window.open('/front/event/imoticon-event', '이모티콘 이벤트', 'titlebar=1, resizable=1, scrollbars=yes, width=1200, height=760');
    }else{
    	//Dmall.LayerUtil.alert('마마무 이모티콘 무료증정 이벤트는<br>2019.09.18 오후 2시부터 진행될 예정입니다.','','');
    	Dmall.LayerUtil.alert('종료된 이벤트입니다.','','');
    }
}
//장바구니이동
function move_basket(){
    //location.href = MOBILE_CONTEXT_PATH+"/front/basket/basket-list"
    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/basket/basket-list");
}
//공지사항이동
function move_notice(){
    //location.href = MOBILE_CONTEXT_PATH+"/front/customer/notice-list";
    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/customer/notice-list");
}
// 주문내역이동
function move_order(){
    if(loginYn == 'true') {
        //location.href = MOBILE_CONTEXT_PATH+"/front/order/order-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/order/order-list");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
            function() {
                //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
                Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");
            },'');
    }
}
//관심상품이동
function move_interest(){
    if(loginYn == 'true') {
        //location.href = MOBILE_CONTEXT_PATH+"/front/interest/interest-item-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/interest/interest-item-list");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
        function() {
            //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
            Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");

        },'');
    }
}

//주문배송이동
function move_delivery(){
    if(loginYn == 'true') {
        //location.href = MOBILE_CONTEXT_PATH+"/front/order/order-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/order/order-list");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
        function() {
            //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
            Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");
        },'');
    }
}

//쿠폰이동
function move_coupon(){
    if(loginYn == 'true') {
        //location.href = MOBILE_CONTEXT_PATH+"/front/coupon/coupon-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/coupon/coupon-list");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
        function() {
            //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
            Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");
        },'');
    }
}

//마켓포인트 이동
function move_dmoney(){
    if(loginYn == 'true') {
        //location.href = MOBILE_CONTEXT_PATH+"/front/member/savedmoney-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/member/savedmoney-list");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
        function() {
            //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
            Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");
        },'');
    }
}

//마이페이지 이동
function move_mypage(){
    if(loginYn == 'true') {
        //location.href = MOBILE_CONTEXT_PATH+"/front/member/mypage";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/member/mypage");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
            function() {
                //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
                Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");
            },'');
    }
}

//오른쪽 퀵메뉴 조회
var RightQuickMenu = function() {
    //최근본상품 조회
    var goods_list = getCookie('LATELY_GOODS');
    var items = goods_list? goods_list.split('||') :new Array();//상품구분
    var items_cnt = items.length;
    var lately_goods = "";
    for(var i=0; i< items_cnt-1;i++){
        var attr = items[i]? items[i].split(/@/) :new Array();//상품속성구분
        var item = '<li><a href="javascript:goods_detail(\''+attr[0]+'\');"><img src=\''+attr[2]+'\'></a></li>';
        lately_goods +=item;
    }
    //최근본상품 갯수노출
    if( items_cnt != 0 ) items_cnt = items_cnt-1;
    $("#lately_count").html(items_cnt);
    $(".quick_view").html(lately_goods);
    //장바구니,관심상품카운트 조회
    var url = MOBILE_CONTEXT_PATH+'/front/member/quick-info';
    Dmall.AjaxUtil.getJSON(url, '', function(result) {
        if(result.success) {
            $("#basket_count").html(result.data.basketCnt);//장바구니갯수
            $("#interest_count").html(result.data.interestCnt);//관심상품갯수
        }
    });
    //관심상품이동
    $( '#btn_move_interest' ).on( 'click', function () {
        if(loginYn == 'true') {
            //location.href = MOBILE_CONTEXT_PATH+"/front/interest/interest-item-list";
            Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/interest/interest-item-list");
        }else{
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
            function() {
                //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
                Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");
            },'');
        }
    } );
};

//즐겨찾기 추가
function add_favorite(){
    var url = location.href;
    if (window.sidebar && window.sidebar.addPanel){ // Mozilla Firefox
        window.sidebar.addPanel(siteNm, url, "");
    }else if(window.opera && window.print) { // Opera
        var elem = document.createElement('a');
        elem.setAttribute('href',url);
        elem.setAttribute('title',siteNm);
        elem.setAttribute('rel','sidebar');
        elem.click();
    }else if(window.external && document.all){ // ie
        window.external.AddFavorite(url,siteNm);
    }else if((navigator.appName == 'Microsoft Internet Explorer') || ((navigator.appName == 'Netscape') && (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null))){ // ie11
        window.external.AddFavorite(url, siteNm);
    }else{ // crome safari
        alert("Ctrl+D키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
    }
}
// 출석체크이벤트이동
function viewAttendance() {
    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+'/front/event/attendance-check-deatil');
}
//인기검색어조회
function keywordSearch(keyword){
    $("#searchText").val(keyword);
    var param = {searchWord : $("#searchText").val()}
    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+'/front/search/goods-list-search', param);
}
/******************************************************************************
**  페이징이동 관련함수
*******************************************************************************/
// 카테고리 이동
function move_category(no, type) {
	//Dmall.waiting.start();
    var url = MOBILE_CONTEXT_PATH+"/front/search/category?ctgNo="+no;
	if(type != null && type != ''){
		if(type == 'all'){
			url += '&searchAll=all';
		}
		if(type == 'best'){
			url += '&bestCtg=Y';
		}
	}
    //location.href = url;
    Dmall.FormUtil.submit(url);
}

function move_order_detail(no) {
    //location.href = MOBILE_CONTEXT_PATH+"/front/order/order-detail?ordNo="+no;
    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/order/order-detail?ordNo="+no);
}

function move_nonmember_order_detail(no) {
    //location.href = MOBILE_CONTEXT_PATH+"/front/order/nomember-order-detail?ordNo="+no;
    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/order/nomember-order-detail?ordNo="+no);
}


// 페이지 이동
function move_page(idx){
	//Dmall.waiting.start();
    var hiddenUserId = $('#hiddenUserId').val();
    if(idx == 'faq'){ // FAQ 목록페이지
        //location.href = MOBILE_CONTEXT_PATH+"/front/customer/faq-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/customer/faq-list");
    }else if (idx == 'notice'){ // 공지사항 목록페이지
        //location.href = MOBILE_CONTEXT_PATH+"/front/customer/notice-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/customer/notice-list");
    }else if (idx == 'inquiry'){ // 마이페이지-상품문의목록페이지
        if(loginYn == 'true') {
            //location.href = MOBILE_CONTEXT_PATH+"/front/customer/inquiry-list";
            Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/customer/inquiry-list");
        }else{
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",function() {
                //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login"
                Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");
                },'');
        }
    }else if(idx == 'login'){ //로그인페이지
        //location.href = MOBILE_CONTEXT_PATH+"/front/login/member-login";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login");
    }else if(idx == 'main'){ //메인페이지
        //location.href = MOBILE_CONTEXT_PATH+"/front/main-view";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/main-view");
    }else if(idx == 'id_search'){ //아이디찾기 페이지
        //location.href = MOBILE_CONTEXT_PATH+"/front/login/account-search?mode=id";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/account-search?mode=id");
    }else if(idx == 'pass_search'){ //비밀번호찾기 페이지
        //location.href = MOBILE_CONTEXT_PATH+"/front/login/account-search?mode=pass";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/account-search?mode=pass");
    }else if(idx == 'interest'){ //관 페이지
        //location.href = MOBILE_CONTEXT_PATH+"/front/interest/interest-item-list";
        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/interest/interest-item-list");
    }else{
        alert("페이지경로가 정상적이지 않습니다.")
    }
}
/******************************************************************************
** 카테고리검색 관련함수
*******************************************************************************/
//노출상품갯수변경
function change_view_count(){
    $('#rows').val($('#view_count option:selected').val());
    if('${so.rows}' != $('#rows').val()){
        if($('#searchType').val() == undefined || $('#searchType').val() == ''){
            category_search();
        }else{
            goods_search()
        }
    }
}
// 카테고리검색 전시타입변경
function chang_dispType(type){
	$('#page').val('1');
    $('#displayTypeCd').val(type);
    if($('#searchType').val() == undefined || $('#searchType').val() == ''){
        category_search();
    }else{
        goods_search()
    }
}
// 카테고리검색 정렬기준 변경
function chang_sort(type){
    $('#sortType').val(type);
    if($('#searchType').val() == undefined || $('#searchType').val() == ''){
        category_search();
    }else{
        goods_search()
    }
}
// 카테고리상품검색
function category_search(){
    $('#form_id_search').attr("method",'POST');
    $('#form_id_search').attr("action",MOBILE_CONTEXT_PATH+'/front/search/category')
    $('#form_id_search').submit();
}

/******************************************************************************
** 상품검색 관련함수
*******************************************************************************/

// 상품검색
function goods_search(){
    $('#form_id_search').attr("action",MOBILE_CONTEXT_PATH+'/front/search/goods-list-search')
    $('#form_id_search').submit();
}

// 상품상세페이지 이동
function goods_detail(idx, opt){
	//Dmall.waiting.start();
	var param = '';
	// 문의하기
	if(opt == 'inquiry'){
		param = '&opt=inquiry';
	}else if(opt == 'review'){
		param = '&opt=review';
	}
	var refererType = $('#visitForm [name=refererType]').val();
    if(refererType!=undefined && refererType!=''){
    //location.href = MOBILE_CONTEXT_PATH+"/front/goods/goods-detail?goodsNo="+idx + param+"&refererType="+refererType;
    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/goods/goods-detail?goodsNo="+idx + param+"&refererType="+refererType);
    }else{
    //location.href = MOBILE_CONTEXT_PATH+"/front/goods/goods-detail?goodsNo="+idx + param;
    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/goods/goods-detail?goodsNo="+idx + param);
    }
}

// 상품이미지 미리보기
function goods_preview(goodsNo){
    var param = 'goodsNo='+goodsNo;
    var url = MOBILE_CONTEXT_PATH+'/front/goods/goods-image-preview?'+param;
    Dmall.AjaxUtil.load(url, function(result) {
        $('#goodsPreview').html(result);
        Dmall.LayerPopupUtil.open($("#div_goodsPreview"));
    })
}
// 상품이미지 미리보기 닫기
function close_goods_preview(){
    Dmall.LayerPopupUtil.close("div_goodsPreview");
}

//교환팝업
function order_exchange_pop(no){
    var url = MOBILE_CONTEXT_PATH+'/front/order/order-exchange-pop?ordNo='+no;
    //location.href=url;
    Dmall.FormUtil.submit(url);
    //모바일에선 화면이동
    /*Dmall.AjaxUtil.load(url, function(result) {
        $('#popup_my_order_replace').html(result);
        Dmall.LayerPopupUtil.open($("#div_order_exchange"));
    })*/
}
//교환신청
function claim_exchange(){
	Dmall.DaumEditor.setValueToTextarea('claimDtlReason');  // 에디터에서 폼으로 데이터 세팅
	
        var url = MOBILE_CONTEXT_PATH+'/front/order/exchange-claim-apply'
            , param = {}
            , ordNoArr = ""
            , ordDtlSeqArr = ""
            , claimReasonCdArr = ""
            , claimQttArr = "";

        var comma = ',';
        var chkItem = $('input:checkbox[name=itemNoArr]:checked').length;

        if(chkItem == 0){
            Dmall.LayerUtil.alert('교환신청할 상품을 선택해 주십시요');
            return;
        }
        
        var qttCheck = true;
        $('input:checkbox[name=itemNoArr]:checked').each(function(i) {
            var _idx = $(this).attr("id").split("_")[1];
            if($("#claimQtt_"+_idx).val() == null || $("#claimQtt_"+_idx).val() == ''){
            	qttCheck = false;
                return;
            }
        });
        if(qttCheck === false){
        	Dmall.LayerUtil.alert('교환수량을 선택해 주세요.');
        	return;
        }

        Dmall.LayerUtil.confirm('교환신청 하시겠습니까?', function() {
        $('input:checkbox[name=itemNoArr]:checked').each(function(i) {
            var _idx = $(this).attr("id").split("_")[1];
            ordNoArr += ($(this).parents('.my_order').attr('data-ord-no'));
            ordNoArr += comma;
            ordDtlSeqArr += ($(this).parents('.my_order').attr('data-ord-dtl-seq'));
            ordDtlSeqArr += comma;
            claimReasonCdArr += ($("#claimReasonCd_"+_idx).val());
            claimReasonCdArr += comma;
            claimQttArr += ($("#claimQtt_"+_idx).val());
            claimQttArr += comma;
        });

        /*var param = {ordNo:$("#ordNo").val(),claimDtlReason:$("#claimDtlReason").val(),
            claimReasonCdArr:claimReasonCdArr,ordNoArr:ordNoArr,ordDtlSeqArr:ordDtlSeqArr};*/
            $("#ordNo").val($("#ordNo").val());
            $("#claimDtlReason").val($("#claimDtlReason").val());
            $("#claimReasonCdArr").val(claimReasonCdArr);
            $("#ordNoArr").val(ordNoArr);
            $("#ordDtlSeqArr").val(ordDtlSeqArr);
            $("#claimQttArr").val(claimQttArr);
            var param = jQuery('#form_id_exchage').serialize();

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if( !result.success){
                Dmall.LayerUtil.alert("교환신청에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림");
            }else{
                Dmall.LayerUtil.alert("교환신청 되었습니다.", "알림").done(function(){
                    //$(".all_btn_cancel_area").hide();
                    if(loginYn == 'true') {
                    	//location.href = MOBILE_CONTEXT_PATH +'/front/order/order-list';
                    	Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH +'/front/order/order-list');

                	}
                });
            }
        });
    });
}
//교환팝업 닫기
function close_exchange_pop(){
    Dmall.LayerPopupUtil.close("div_order_exchange");
}

//환불팝업
function order_refund_pop(no){
    var url = MOBILE_CONTEXT_PATH+'/front/order/order-refund-pop?ordNo='+no;
    //location.href=url;
    Dmall.FormUtil.submit(url);
    //모바일에선 화면이동
    /*Dmall.AjaxUtil.load(url, function(result) {
        $('#popup_my_order_refund').html(result);
        Dmall.LayerPopupUtil.open($("#div_order_refund"));
    })*/
}

//반품/환불신청
function claim_refund(){
	Dmall.DaumEditor.setValueToTextarea('claimDtlReason');  // 에디터에서 폼으로 데이터 세팅
	
    if($('#paymentWayCd').val() == '11' || $('#paymentWayCd').val() == '22') {
        if($('#memberOrdYn').val() == 'Y') {
            if($.trim($('#holderNm').val()) == '' || $.trim($('#bankNm').val()) == '' || $.trim($('#actNo').val()) == '') {
                Dmall.LayerUtil.alert('환불계좌 등록 후 진행해 주시기 바랍니다.','알림');
                return false;
            }
        } else {
        	if(Dmall.validation.isEmpty($("#holderNm").val()) || $("#bankCd option:selected").val() == '' || Dmall.validation.isEmpty($("#actNo").val())){
                Dmall.LayerUtil.alert("등록된 환불계좌가 없습니다.<br>PC에서 환불계좌 등록 후 신청해 주세요.");
                return;
            }
            /*if(Dmall.validation.isEmpty($("#holderNm").val())){
                Dmall.LayerUtil.alert("예금주를 입력해주세요.");
                return;
            }
            if($("#bankCd option:selected").val() == ''){
                Dmall.LayerUtil.alert("은행명을 선택해 주세요.");
                return;
            }
            if(Dmall.validation.isEmpty($("#actNo").val())){
                Dmall.LayerUtil.alert("계좌번호를 입력해 주세요.");
                return;
            }*/
        }
    }

    var chkItem = $('input:checkbox[name=itemNoArr]:checked').length;
    if(chkItem == 0){
        Dmall.LayerUtil.alert('반품신청할 상품을 선택해 주십시요');
        return;
    }
    
    var qttCheck = true;
    $('input:checkbox[name=itemNoArr]:checked').each(function(i) {
        var _idx = $(this).attr("id").split("_")[1];
        if($("#claimQtt_"+_idx).val() == null || $("#claimQtt_"+_idx).val() == ''){
        	qttCheck = false;
            return;
        }
    });
    if(qttCheck === false){
    	Dmall.LayerUtil.alert('반품수량을 선택해 주세요.');
    	return;
    }

    var url = MOBILE_CONTEXT_PATH+'/front/order/refund-claim-apply'
        , ordNoArr = ""
        , ordDtlSeqArr = ""
        , claimReasonCdArr = ""
        , claimQttArr = ""
        , ordQttArr=""
        , comma = ','

    Dmall.LayerUtil.confirm('반품신청 하시겠습니까?', function() {
        $('input:checkbox[name=itemNoArr]:checked').each(function(i) {
            var _idx = $(this).attr("id").split("_")[1];
            ordNoArr += ($(this).parents('.my_order').attr('data-ord-no'));
            ordNoArr += comma;
            ordQttArr += ($(this).parents('.my_order').attr('data-ord-qtt'));
            ordQttArr += comma;
            ordDtlSeqArr += ($(this).parents('.my_order').attr('data-ord-dtl-seq'));
            ordDtlSeqArr += comma;
            claimReasonCdArr += ($("#claimReasonCd_"+_idx).val());
            claimReasonCdArr += comma;
            claimQttArr += ($("#claimQtt_"+_idx).val());
            claimQttArr += comma;
        });

        $("#ordNo").val($("#ordNo").val());
        $("#claimDtlReason").val($("#claimDtlReason").val());
        $("#claimReasonCdArr").val(claimReasonCdArr);
        $("#ordNoArr").val(ordNoArr);
        $("#ordQttArr").val(ordQttArr);

        $("#ordDtlSeqArr").val(ordDtlSeqArr);
        $("#claimQttArr").val(claimQttArr);

        var param = $('#form_id_refund').serializeArray();
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if( !result.success){
                Dmall.LayerPopupUtil.close("div_order_refund");//레이어팝업 닫기
                Dmall.LayerUtil.alert("반품신청에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                  location.reload();
                });
            }else{
                Dmall.LayerPopupUtil.close("div_order_refund");//레이어팝업 닫기
                Dmall.LayerUtil.alert("반품신청 되었습니다.", "알림").done(function(){
                    //$(".all_btn_cancel_area").hide();
                	if(loginYn == 'true') {
                		//location.href = MOBILE_CONTEXT_PATH +'/front/order/order-list?refrequest=Y';
                		Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH +'/front/order/order-list?refrequest=Y');
                	}
                });
            }
        });
    });
}
//환불팝업 닫기
function close_refund_pop(){
    Dmall.LayerPopupUtil.close("div_order_refund");
}

//주문취소 팝업
function order_cancel_pop(no){
    var url = MOBILE_CONTEXT_PATH+'/front/order/order-cancel-pop?ordNo='+no;
    //location.href=url;
    Dmall.FormUtil.submit(url);
    /*Dmall.AjaxUtil.load(url, function(result) {
        $('#popup_my_order_cancel').html(result);
        Dmall.LayerPopupUtil.open($("#div_order_cancel"));
    })*/
}

//주문전체취소
function order_cancel_all(){
    Dmall.LayerUtil.confirm('주문 전체신청 하시겠습니까?', function() {
        var url = MOBILE_CONTEXT_PATH+'/front/order/order-cancel-all';
        var param = $('#form_id_cancel').serializeArray();
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if( !result.success){
                Dmall.LayerPopupUtil.close("div_order_cancel");//레이어팝업 닫기
                Dmall.LayerUtil.alert("취소에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                	if(loginYn == 'true') {
                		//location.href = MOBILE_CONTEXT_PATH +'/front/order/order-list';
                		Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH +'/front/order/order-list');
                	}
                });
            }else{
                Dmall.LayerPopupUtil.close("div_order_cancel");//레이어팝업 닫기
                Dmall.LayerUtil.alert("전체취소 되었습니다.", "알림").done(function(){
                	if(loginYn == 'true') {
                		//location.href = MOBILE_CONTEXT_PATH +'/front/order/order-list';
                		Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH +'/front/order/order-list');
                	}
                });
            }
        });
    })
}

// 선택상품취소
function order_cancel(){
    if($('#paymentWayCd').val() == '11' || $('#paymentWayCd').val() == '22') {
        if($('#memberOrdYn').val() == 'Y') {
            if($.trim($('#holderNm').val()) == '' || $.trim($('#bankCd').val()) == '' || $.trim($('#actNo').val()) == '') {
                Dmall.LayerUtil.alert('환불계좌 등록 후 진행해 주시기 바랍니다.','알림');
                return false;
            }
        } else {
            if(Dmall.validation.isEmpty($("#holderNm").val())){
                Dmall.LayerUtil.alert("예금주를 입력해주세요.");
                return;
            }
            if($("#bankCd option:selected").val() == ''){
                Dmall.LayerUtil.alert("은행명을 선택해주세요.");
                return;
            }
            if(Dmall.validation.isEmpty($("#actNo").val())){
                Dmall.LayerUtil.alert("계좌번호를 입력해주세요.");
                return;
            }
        }
    }

    if($('#claimReasonCd').val() == '') {
        Dmall.LayerUtil.alert('취소 사유를 선택해 주십시요.','알림');
        return false;
    }
    if($.trim($('#claimDtlReason').val()) == '') {
        Dmall.LayerUtil.alert('취소 상세사유를 입력해 주십시요.','알림');
        return false;
    }
    var url = MOBILE_CONTEXT_PATH+'/front/order/bundle-delivery-amt'
    , param = {}
    , ordDtlSeqArr = ""
    var comma = ',';
    var partCancelYn = '';
    var itemLength = $('input:checkbox[name=itemNoArr]').length;
    var chkItem = $('input:checkbox[name=itemNoArr]:checked').length;
    if(chkItem < 1) {
        Dmall.LayerUtil.alert('취소하실 상품을 선택해 주십시요.','알림');
        return false;
    }

    if($('#ordStatusCd').val() == '10') {
        if(itemLength != chkItem) {
            Dmall.LayerUtil.alert('입금 전 취소는 전체 취소만 가능합니다.','알림');
            return false;
        }
    }

    if($('#escrowYn').val() == 'Y') {
        if(itemLength != chkItem) {
            Dmall.LayerUtil.alert('에스크로 결제는 전체 취소만 가능합니다.','알림');
            return false;
        }
    }

    if($('#paycoYn').val() == 'Y') {
        if(itemLength != chkItem) {
            Dmall.LayerUtil.alert('페이코 결제는 전체 취소만 가능합니다.','알림');
            return false;
        }
    }

    if($('#claimReasonCd').val() == '') {
        Dmall.LayerUtil.alert('취소 사유를 선택해 주십시요.','알림');
        return false;
    }

    if($.trim($('#claimDtlReason').val()) == '') {
        Dmall.LayerUtil.alert('취소 상세사유를 입력해 주십시요.','알림');
        return false;
    }

    if(itemLength == chkItem) {
        partCancelYn = 'N';
    } else {
        partCancelYn = 'Y';
    }
    var claimQttArr ="";
    $('input:checkbox[name=itemNoArr]:checked').each(function(i) {
        if(i != 0 )ordDtlSeqArr += comma;
        ordDtlSeqArr += ($(this).parents('.my_order').attr('data-ord-dtl-seq'));

        if(i != 0 )claimQttArr += comma;
        claimQttArr += $(this).siblings('[name=claimQttArr]').val();

    });

    var param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,claimQttArr:claimQttArr,partCancelYn:partCancelYn,cancelType:$('#cancelType').val(),
        claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val(),holderNm:$('#holderNm').val(),
        bankCd:$('#bankCd').val(),actNo:$('#actNo').val(),paymentNo:$('#paymentNo').val()};
    var notiMsg = "결제취소 ";
    Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
        if(result.data.dlvrChangeYn){
            notiMsg = "결제취소신청 "
        }
        Dmall.LayerUtil.confirm("선택한 상품을 "+notiMsg+" 하시겠습니까?", function() {
            url = MOBILE_CONTEXT_PATH+"/front/order/order-cancel";
            Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                if(result.success) {
                	
                    Dmall.LayerUtil.alert(notiMsg+" 되었습니다.", "알림").done(function(){
                        /*Dmall.LayerPopupUtil.close("div_order_cancel");
                        location.reload();*/
                    	if(loginYn == 'true') {
                    		//location.href = MOBILE_CONTEXT_PATH +'/front/order/order-list';
                    		Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH +'/front/order/order-list');
                    	}
                    });
                } else {
                    /*Dmall.LayerPopupUtil.close("div_order_cancel");*/
                    Dmall.LayerUtil.alert(notiMsg+result.exMsg+"<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                        location.reload();
                    });
                }
            })
        });

    });
}

// 구매확정 처리
function updateBuyConfirm(ordNo,ordDtlSeq){
    var url = MOBILE_CONTEXT_PATH+'/front/order/buy-confirm-update';
    var param = {ordNo:ordNo,ordDtlSeq:ordDtlSeq};
    var returnUrl = '';
    Dmall.LayerUtil.confirm('구매확정 하시겠습니까?', function() {
        Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
            if(result.success) {
                Dmall.LayerUtil.alert('구매확정 처리되었습니다.','알림').done(function(){
                    location.reload();
                })
            } else {
                Dmall.LayerUtil.alert('구매확정 처리가 실패하였습니다.<br>고객센터로 문의 바랍니다.', '알림').done(function(){
                    location.reload();
                })
            }
        })
    });
}

// 주문취소팝업 닫기
function close_cancel_pop(){
    Dmall.LayerPopupUtil.close("div_order_cancel");
}
// 비회원주문조회
function nonMember_order_list(){
    var url = MOBILE_CONTEXT_PATH+'/front/order/nomember-order-check';
    var param = jQuery('#nonMemberloginForm').serialize();
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        if(result.success) {
            $('#nonMemberloginForm').attr("action",MOBILE_CONTEXT_PATH+'/front/order/nomember-order-list')
            $('#nonMemberloginForm').submit();
        }else{
            Dmall.LayerUtil.alert("주문정보를 확인해주시기 바랍니다.","알림");
        }
    });
}


// 비회원방문예약
function nonMember_rsv_list(){
    var url = MOBILE_CONTEXT_PATH+'/front/visit/nomember-rsv-check';
    var param = jQuery('#nonMemberRsvForm').serialize();
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        if(result.success) {
            $('#nonMemberRsvForm').attr("action",MOBILE_CONTEXT_PATH+'/front/visit/nomember-rsv-list');
            $('#nonMemberRsvForm').submit();
        }else{
            Dmall.LayerUtil.alert("예약정보를 확인해주시기 바랍니다.","알림");
        }
    });
}

/**********************************************************************************************************************
CJ대한통운   https://www.doortodoor.co.kr/parcel/doortodoor.do?fsp_action=PARC_ACT_002&fsp_cmd=retrieveInvNoACT&invc_no=
우체국택배   https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=
한진택배    http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num=
현대택배    http://www.hlc.co.kr/hydex/jsp/tracking/trackingViewCus.jsp?InvNo=
로젠택배    http://d2d.ilogen.com/d2d/delivery/invoice_tracesearch_quick.jsp?slipno=
KG로지스   http://www.kglogis.co.kr/delivery/delivery_result.jsp?item_no=
CVsnet 편의점택배    http://www.cvsnet.co.kr/postbox/m_delivery/local/local.jsp?invoice_no=
KGB택배   http://www.kgbls.co.kr//sub5/trace.asp?f_slipno=
경동택배    http://kdexp.com/sub3_shipping.asp?stype=1&yy=&mm=&p_item=
대신택배    http://home.daesinlogistics.co.kr/daesin/jsp/d_freight_chase/d_general_process2.jsp?billno1=
일양로지스   http://www.ilyanglogis.com/functionality/tracking_result.asp?hawb_no=
합동택배    http://www.hdexp.co.kr/parcel/order_result_t.asp?stype=1&p_item=
GTX로지스  http://www.gtxlogis.co.kr/tracking/default.asp?awblno=
건영택배    http://www.kunyoung.com/goods/goods_01.php?mulno=
천일택배    http://www.chunil.co.kr/HTrace/HTrace.jsp?transNo=
한의사랑택배  http://www.hanips.com/html/sub03_03_1.html?logicnum=
한덱스 http://www.hanjin.co.kr/Logistics_html
EMS http://service.epost.go.kr/trace.RetrieveEmsTrace.postal?ems_gubun=E&POST_CODE=
DHL http://www.dhl.co.kr/content/kr/ko/express/tracking.shtml?brand=DHL&AWB=
TNTExpress  http://www.tnt.com/webtracker/tracking.do?respCountry=kr&respLang=ko&searchType=CON&cons=
UPS http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=
Fedex   http://www.fedex.com/Tracking?ascend_header=1&clienttype=dotcomreg&cntry_code=kr&language=korean&tracknumbers=
USPS    http://www.tnt.com/webtracker/tracking.do?respCountry=kr&respLang=ko&searchType=CON&cons=
i-Parcel    https://tracking.i-parcel.com/Home/Index?trackingnumber=
DHL Global Mail http://webtrack.dhlglobalmail.com/?trackingnumber=
범한판토스   http://totprd.pantos.com/jsp/gsi/vm/popup/notLoginTrackingListExpressPoPup.jsp?quickType=HBL_NO&quickNo=
에어보이 익스프레스  http://www.airboyexpress.com/Tracking/Tracking.aspx?__EVENTTARGET=ctl00$ContentPlaceHolder1$lbtnSearch&__EVENTARGUMENT=__VIEWSTATE:/wEPDwUKLTU3NTA3MDQxMg9kFgJmD2QWAgIDD2QWAgIED2QWBGYPDxYCHgdWaXNpYmxlaGRkAgYPDxYCHwBnZGQYAQUeX19Db250cm9sc1JlcXVpcmVQb3N0QmFja
GSMNtoN http://www.gsmnton.com/gsm/handler/Tracking-OrderList?searchType=TrackNo&trackNo=
APEX(ECMS Express)  http://www.apexglobe.com
KGL 네트웍스    http://www.hydex.net/ehydex/jsp/home/distribution/tracking/tracingView.jsp?InvNo=
굿투럭 http://www.goodstoluck.co.kr/#modal
호남택배    http://honamlogis.co.kr
**********************************************************************************************************************/

// 배송추적 팝업
function trackingDelivery(company,tranNo){
    var trans_url ="";
    if(company == '01'){//현대택배
        trans_url = "http://www.hlc.co.kr/hydex/jsp/tracking/trackingViewCus.jsp?InvNo="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '02'){//한진택배
        trans_url = "http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '03'){//하나로택배
        trans_url = "http://www.hanarologis.com/branch/chase/listbody.html?a_gb=center&a_cd=4&a_item=0&fr_slipno="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '04'){//KT로지스
        trans_url = "http://www.kglogis.co.kr/delivery/delivery_result.jsp?item_no="+tranNo;
    }else if(company == '05'){//CJ택배
        trans_url = "http://www.cjgls.co.kr/kor/service/service02_01.asp?slipno="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '06'){//CJ HTH택배
        trans_url = "http://www.doortodoor.co.kr/servlets/cmnChnnel?tc=dtd.cmn.command.c03condiCrg01Cmd&amp;amp;invc_no="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '07'){//천일택배
        trans_url = "http://www.cyber1001.co.kr/kor/taekbae/HTrace.jsp?transNo="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '08'){//아주택배
        Dmall.LayerUtil.alert("아주택배 > 존재하지 않는 택배사입니다.","안내");
    }else if(company == '09'){//동부익스프레스
        trans_url = "http://www.dongbuexpress.co.kr/Html/Delivery/DeliveryCheck.jsp?mode=SEARCH&search_type=1&search_item_no="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '10'){//옐로우캡 택배
        trans_url = "http://www.yellowcap.co.kr/custom/inquiry_result.asp?INVOICE_NO="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '11'){//우리택배
        Dmall.LayerUtil.alert("우리택배 > 존재하지 않는 택배사입니다.","안내");
    }else if(company == '12'){//KGB택배
        trans_url = "http://www.kgbls.co.kr/sub5/trace.asp?f_slipno="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '13'){//로젠택배
        //trans_url = "http://d2d.ilogen.com/d2d/delivery/invoice_tracesearch_quick.jsp?slipno="+tranNo;
    	trans_url = "http://www.ilogen.com/m/personal/trace.pop/"+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '14'){//중앙택배
        Dmall.LayerUtil.alert("중앙택배 > 존재하지 않는 택배사입니다.","안내");
    }else if(company == '15'){//경동택배
        trans_url = "http://www.kdexp.com/sub4_1.asp?stype=1&p_item="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '16'){//우체국택배
        trans_url = "http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '17'){//용마택배
        trans_url = "http://eis.yongmalogis.co.kr/dm/DmTrc060?ordno="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '18'){//드림택배
        trans_url = "http://www.idreamlogis.com/delivery/popup_tracking.jsp?item_no="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '19'){//롯데택배
       trans_url = " https://www.lotteglogis.com/open/tracking?invno="+tranNo;
       window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '98'){//직접배송
        Dmall.LayerUtil.alert("수령방식이 택배가 아닙니다.","안내");
    }
}
// 현금영수증 발급신청팝업
function cash_receipt_pop(){
    Dmall.LayerPopupUtil.open($("#popup_my_cash"));
}
// 현금영수증 발급신청
function apply_cash_receipt(){


    if(Dmall.validation.isEmpty($("#issueWayNo").val())){
        $('#issueWayNo').validationEngine('showPrompt', '인증번호를 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#cash_email01").val())|| Dmall.validation.isEmpty($("#cash_email02").val())) {
        jQuery('#cash_email01').focus();
        jQuery('#cash_email01').validationEngine('showPrompt', '이메일을 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#cashTelNo").val())){
        $('#cashTelNo').validationEngine('showPrompt', '전화번호를 입력해주세요.', 'error');
        return false;
    }
    $('#telNo').val($('#cashTelNo').val());
    if($('#cash_personal').is(":checked") == true){
        $("#useGbCd").val("01");
    }else{
        $("#useGbCd").val("02");
    }
    $('#email').val($('#cash_email01').val()+"@"+$('#cash_email02').val());
    Dmall.LayerUtil.confirm('현금영수증 발급신청 하시겠습니까?', function() {
        var url = MOBILE_CONTEXT_PATH+'/front/order/cash-receipt-apply';
        var param = $('#form_id_order_info').serializeArray();
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if( !result.success){
                Dmall.LayerUtil.alert("현금영수증 발급에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                    Dmall.LayerPopupUtil.close("popup_my_cash");
                    //location.href = MOBILE_CONTEXT_PATH+"/front/order/order-list";
                });
            }else{
                Dmall.LayerUtil.alert("현금영수증 발급처리 되었습니다.", "알림").done(function(){
                    Dmall.LayerPopupUtil.close("popup_my_cash");
                    //location.href = MOBILE_CONTEXT_PATH+"/front/order/order-list";
                });
            }
        });
    })
}
// 현금영수증 팝업닫기
function close_cash_receipt_pop(){
    Dmall.LayerPopupUtil.close("popup_my_cash");
}
// 세금계산서 발급신청팝업
function tax_bill_pop(){
    Dmall.LayerPopupUtil.open($("#popup_my_tax"));
}
// 세금계산서 발급신청
function apply_tax_bill(){
    if(Dmall.validation.isEmpty($("#companyNm").val())){
        $('#companyNm').validationEngine('showPrompt', '상호명을 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#bizNo").val())){
        $('#bizNo').validationEngine('showPrompt', '사업자 번호를 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#ceoNm").val())){
        $('#ceoNm').validationEngine('showPrompt', '대표자명을 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#bsnsCdts").val())){
        $('#bsnsCdts').validationEngine('showPrompt', '업태를 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#item").val())){
        $('#item').validationEngine('showPrompt', '업종을 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#postNo").val())){
        $('#postNo').validationEngine('showPrompt', '주소를 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#managerNm").val())){
        $('#managerNm').validationEngine('showPrompt', '담당자명을 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#tax_email01").val())|| Dmall.validation.isEmpty($("#tax_email02").val())) {
        $('#tax_email01').validationEngine('showPrompt', '담당자 이메일을 입력해주세요.', 'error');
        return false;
    }
    if(Dmall.validation.isEmpty($("#taxTelNo").val())){
        $('#taxTelNo').validationEngine('showPrompt', '담당자 전화번호를 입력해주세요.', 'error');
        return false;
    }
    $('#telNo').val($('#taxTelNo').val());
    if($('#tax_Yes').is(":checked") == true){
        $("#useGbCd").val("03");
    }else{
        $("#useGbCd").val("04");
    }
    $('#email').val($('#tax_email01').val()+"@"+$('#tax_email02').val());
    Dmall.LayerUtil.confirm('세금계산서 발급신청 하시겠습니까?', function() {
        var url = MOBILE_CONTEXT_PATH+'/front/order/tax-bill-apply';
        var param = $('#form_id_order_info').serializeArray();
        Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
            if( !result.success){
                Dmall.LayerUtil.alert(result.message, "알림").done(function(){
                    Dmall.LayerPopupUtil.close("popup_my_tax");
                });
            }else{
                Dmall.LayerUtil.alert("세금계산서 신청처리 되었습니다.", "알림").done(function(){
                    Dmall.LayerPopupUtil.close("popup_my_tax");
                    if(loginYn == 'true') {
                		//location.href = MOBILE_CONTEXT_PATH +'/front/order/order-list';
                		Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/order/order-list");
                	}
                });
            }
        });
    })
}
// 세금계산서 팝업닫기
function close_tax_bill_pop(){
    Dmall.LayerPopupUtil.close("popup_my_tax");
}
/*
 * 현금영수증조회 popup
 * pg_cd : pg사코드
 * tid : 연계승인코드
 */
function show_cash_receipt(){
    var pgCd = $("#pgCd").val();
    var tid = $("#txNo").val();
    var ordNo = $("#ordNo").val();
    var totAmt = $("#totAmt").val();

    // 추가할 변수
    var paymentWayCd = $("#paymentWayCd").val(); // 결제수단코드
    var mid = $("#mid").val(); //상점ID
    var confirmHashData = $("#confirmHashData").val(); // 검증용 Hash값
    var confirmNo = $("#confirmNo").val(); // 승인번호
    var confirmDttm = $("#confirmDttm").val(); // 승인일시(8자리)
    var mode = "test";  //서비스 구분 ( test:테스트서버,  service:실서버 )

    if(pgCd == '01'){// KCP
       var showreceiptUrl = "https://admin8.kcp.co.kr/assist/bill.BillActionNew.do?cmd=cash_bill&cash_no="+tid+"&order_no="+ordNo+"&trade_mony="+totAmt;
       window.open(showreceiptUrl,"showreceipt","width=420,height=670, scrollbars=no,resizable=no");
    }else if(pgCd == '02'){ //이니시스
        var showreceiptUrl = "https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/Cash_mCmReceipt.jsp?noTid="+tid + "&clpaymethod=22";
        window.open(showreceiptUrl,"showreceipt","width=380,height=540, scrollbars=no,resizable=no");
    }else if(pgCd == '03'){ //LGU
        var paramStr = "";
        var stype = "";

        if (mid == "" || ordNo == "") {
            return ;
        } else {
                 if(paymentWayCd == "23") stype = "SC0010"; //신용카드
            else if(paymentWayCd == "21") stype = "SC0030"; //계좌이체
            else if(paymentWayCd == "22") stype = "SC0040"; //무통장

            if(stype == "CAS" || stype == "cas" || stype == "SC0040"){
                stype = "SC0040";
                if (seqno == "") seqno = "001";
                paramStr = "orderid="+ordNo+"&mid="+mid+"&seqno="+seqno+"&servicetype="+stype;
            }else if(stype == "BANK" || stype == "bank" || stype == "SC0030"){
                stype = "SC0030";
                paramStr = "orderid="+ordNo+"&mid="+mid+"&servicetype="+stype;
            }else if(stype == "CR" || stype == "cr" || stype == "SC0100"){
                stype = "SC0100";
                paramStr = "orderid="+ordNo+"&mid="+mid+"&servicetype="+stype;
            }

            var showreceiptUrl = "http://pg.dacom.net"+ (mode=="service"? "": ":7080") +"/transfer/cashreceipt_mp.jsp?"+paramStr;
            window.open(showreceiptUrl, "showreceipt","width=380,height=600,menubar=0,toolbar=0,scrollbars=no,resizable=no, resize=1,left=252,top=116");
        }
    }else if(pgCd == '04'){ //ALLTHEGATE
        var showreceiptUrl = "http://allthegate.com/customer/receiptLast3.jsp?sRetailer_id="+mid+"&approve="+confirmNo+"&send_no="+tid+"&send_dt="+confirmDttm;
        window.open(showreceiptUrl,"showreceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
    }else{ //국세청조회사이트
        var showreceiptUrl = "http://www.taxsave.go.kr/servlets/AAServlet?tc=tss.web.aa.ntc.cmd.RetrieveMainPageCmd";
        window.open(showreceiptUrl,"showreceipt","width=380,height=540, scrollbars=no,resizable=no");
    }
}

/*  신용카드결제정보 조회 popup
 * pg_cd : pg사코드
 * tid : 연계승인코드
 */
function show_card_bill(){
    var pgCd = $("#pgCd").val();
    var tid = $("#txNo").val();
    var ordNo = $("#ordNo").val();;
    var totAmt = $("#totAmt").val();

    // 추가할 변수
    var paymentWayCd = $("#paymentWayCd").val(); // 결제수단코드
    var mid = $("#mid").val(); //상점ID
    var confirmHashData = $("#confirmHashData").val(); // 검증용 Hash값
    var confirmNo = $("#confirmNo").val(); // 승인번호
    var confirmDttm = $("#confirmDttm").val(); // 승인일시(8자리)
    var mode = "test";  //서비스 구분 ( test:테스트서버,  service:실서버 )

    if(pg_cd == '01'){// KCP
        window.open("https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&tno="+tid+"&order_no="+ordNo+"&trade_mony="+totAmt, "kcpReceipt", "width=470,height=815");
    }else if(pg_cd == '02'){//이니시스
        window.open("https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=" +tid + "&noMethod=1", "iniReceipt" + tid, "width=405,height=525");
    }else if(pg_cd == '03'){//LGU
        var showreceiptUrl = "http://pgweb.dacom.net"+ (mode=="test"? ":7080" : "") +"/pg/wmp/etc/jsp/Receipt_Link.jsp?mertid="+mid+"&tid="+tid+"&authdata="+confirmHashData;
        window.open(showreceiptUrl,"showreceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
    }else if(pg_cd == '04'){ //ALLTHEGATE
        var showreceiptUrl = "http://allthegate.com/customer/receiptLast3.jsp?sRetailer_id="+mid+"&approve="+confirmNo+"&send_no="+tid+"&send_dt="+confirmDttm;
        window.open(showreceiptUrl,"showreceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
    }else{
        Dmall.LayerUtil.alert("해당하는 PG사 코드가 없습니다.", "알림");
    }
}

/*  세금계산서발급정보 조회 popup
 * pg_cd : pg사코드
 * tid : 연계승인코드
 */
function show_tax_bill(){
    var showreceiptUrl = "http://www.taxsave.go.kr/servlets/AAServlet?tc=tss.web.aa.ntc.cmd.RetrieveMainPageCmd";
    window.open(showreceiptUrl,"showreceipt","width=380,height=540, scrollbars=no,resizable=no");
}
//통신판매사업자 팝업
function communicationPopup(){
    window.open("http://www.ftc.go.kr/info/bizinfo/communicationList.jsp", "통신판매사업자");
}

function click_banner(mod, link){
    if(mod == "N"){
        window.open(link);
    }else{
        //location.href = link;
        Dmall.FormUtil.submit(link);
    }

}

/*  관심상품, 장바구니 등록 */
var ListBtnUtil = {
    customAjax:function(url, param, callback) {
        Dmall.waiting.start();
        $.ajax({
            type : 'post',
            url : url,
            data : param,
            dataType : 'json',
            traditional:true
        }).done(function(result) {
            if (result) {
                Dmall.AjaxUtil.viewMessage(result, callback);
            } else {
                callback();
            }
            Dmall.waiting.stop();
        }).fail(function(result) {
            Dmall.waiting.stop();
            Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
        });
    }
    , insertInterest:function(goodsNo){ //관심상품담기
        if(loginYn == 'false') {
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    //location.href= MOBILE_CONTEXT_PATH+"/front/login/member-login?returnUrl="+returnUrl;
                    Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/login/member-login?returnUrl="+returnUrl);
                    },''
                );
        } else {
            var url = MOBILE_CONTEXT_PATH+'/front/interest/interest-item-insert';
            var param = {goodsNo : goodsNo}
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                    //RightQuickMenu(); //퀵메뉴갱신
                    Dmall.LayerUtil.confirm('관심상품으로 이동 하시겠습니까?', function() {
                        //location.href=MOBILE_CONTEXT_PATH+"/front/interest/interest-item-list";
                        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/interest/interest-item-list");

                    })
                 }
            })
        }
    }
    , insertBasket:function(goodsNo) {
        Dmall.LayerUtil.confirm('장바구니에 등록하시겠습니까?', function() {
            var url = MOBILE_CONTEXT_PATH+'/front/interest/check-basket-insert'
                , param = {'goodsNoArr':goodsNo};

            ListBtnUtil.customAjax(url, param, function(result) {
                if(result.success){
                    //RightQuickMenu(); //퀵메뉴갱신
                    if(basketPageMovYn === 'Y') {
                        Dmall.LayerPopupUtil.open($('#success_basket'));//장바구니 등록성공팝업
                    } else {
                        //location.href = MOBILE_CONTEXT_PATH+"/front/basket/basket-list";
                        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+"/front/basket/basket-list");
                    }
                } else {
                    if(result.data.adultFlag != '' && result.data.adultFlag === 'Y') {
                        //location.href = MOBILE_CONTEXT_PATH+'/front/interest/adult-restriction';
                        Dmall.FormUtil.submit(MOBILE_CONTEXT_PATH+'/front/interest/adult-restriction');
                    }
                }
            });
        });
    }
};

/************************** 상품검색관련 script ****************************/


function hearingAidChk() {
    // 상품유형 체크 (보청기 : 05)
    var len = $("input[name='goodsTypeCd']").length;
    var chk = 0;
    for(var i=0; i<len; i++){       
         if ($("input[name='goodsTypeCd']")[i].value == "05") {
        	 chk++;
         }
    }
    // 전부 보청기를 선택했을경우
    if (len > 0 && len == chk) {
    	var hearingAidYn = 'Y';	
    } else {
    	var hearingAidYn = 'N';	
    }
	
    return hearingAidYn;
	
}

function youtube_link_move(url){
	console.log(url)
	if(navigator.userAgent.indexOf("davich_android")> 0){
		if(url != null && url != ''){
			var intent_url = url;
			if(intent_url.indexOf('https://') != -1){
				intent_url = intent_url.replace('https://','intent://');
			}
			if(intent_url.indexOf('http://') != -1){
				intent_url = intent_url.replace('http://','intent://');
			}
			intent_url += '#Intent;scheme=http;package=com.android.chrome;end';
			location.href = intent_url; 
		}else{
			location.href = "intent://www.youtube.com/channel/UCJoAvzt6GNBZLuXYY50F3Yw#Intent;scheme=http;package=com.android.chrome;end";
		}
	}else{
		if(url != null && url != ''){
			window.open(url,'_blank');
		}else{
			window.open("https://www.youtube.com/channel/UCJoAvzt6GNBZLuXYY50F3Yw",'_blank');
		}
	}
}
