jQuery(document).ready(function(){
		
	
    //상단 네비게이션 이동 함수 setting
    $("[id^=navigation_combo_]").on("change",function(){
        move_category(this.value);
    });
    // 페이지당 상품 조회수량 변경
    $("#view_count").on("change",function(){
        change_view_count();
    });
    //이전으로 가기
    $("#goto_back").on("click",function (){
        history.back();
    });

    //장바구니 팝업 닫기
    $('#btn_close_pop').on('click', function(){
        Dmall.LayerPopupUtil.close('success_basket');
    });

    //장바구니이동
    $('#btn_move_basket').on('click', function(){
        //location.href = "/front/basket/basket-list";
        Dmall.FormUtil.submit("/front/basket/basket-list");
    });

    //sns부가정보입력 팝업여부
    if( sns_add_info_Yn == "Y"){
        //window.open("/front/login/sns-addinfo-pop", "", "width=700,height=600");
    }

    //TOP BOTTON 클릭시 상단으로이동
    $('.btn_quick_top').click(function(){
        $('html, body').animate({scrollTop:0},400);
        return false;
    });

    //오른쪽 퀵메뉴 조회
    RightQuickMenu();

    //bxSlider 로드
    BxSliderUtil.render();

    // 왼쪽 날개배너 조회
   /* var selectLeftWing = '/front/promotion/leftwing-info';
    Dmall.AjaxUtil.load(selectLeftWing, function(result) {
        $('#banner').html(result);
    });*/

    // 상단 상품검색
/*    $('#btn_search').on('click',function(){

        if($('#searchText').val() != '') {
            $('#searchText').attr("placeholder", "");
        }

        if ($('#searchText').attr("placeholder") != '') {
            //location.href = "/front/goods/goods-detail?goodsNo=G1810181136_2368";
            Dmall.FormUtil.submit("/front/goods/goods-detail?goodsNo=G1810181136_2368");
        }else{
            if($('#searchText').val() === '') {
                Dmall.LayerUtil.alert("입력된 검색어가 없습니다.", "알림");
                return false;
            }else{

            }
            var param = {searchType:'1',searchWord : $("#searchText").val()};
            Dmall.FormUtil.submit('/front/search/goods-list-search?searchType=1&searchWord='+$("#searchText").val());
        }
    });*/

    // top-menu-cart
    $('#move_cart').on('click',function(){
        //location.href = "/front/basket/basket-list"
        Dmall.FormUtil.submit("/front/basket/basket-list");
    });

    // top-menu-order/delivery
    $('[id^=move_order]').on('click',function(){
        if(loginYn == 'true') {
            //location.href = "/front/order/order-list";
            Dmall.FormUtil.submit("/front/order/order-list");
        }else{
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    //location.href= "/front/login/member-login"
                    Dmall.FormUtil.submit("/front/login/member-login");
                },'');
        }
    });
    //top-menu-mypage
    $('[id^=move_mypage]').on('click',function(){
        if(loginYn == 'true') {
            //location.href = "/front/member/mypage";
            Dmall.FormUtil.submit("/front/member/mypage");
        }else{
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                function() {
                    //location.href= "/front/login/member-login?returnUrl=/front/member/mypage"
                    Dmall.FormUtil.submit("/front/login/member-login?returnUrl=/front/member/mypage");
                },'');
        }
    });

    //비회원, 회원 재구매
    $('#btn_rebuy').on('click',function(){
        $('#form_id_order_info').attr('action','/front/order/order-form');
        $('#form_id_order_info').attr('method','post');
        $('#form_id_order_info').submit();
    });

    // 카테고리검색 정렬기준 변경
    $('select[name=selectAlign]').on('change',function(){
            chang_sort($(this).val());
    });


    //렌즈추천 링크
    $('.btn_recomm').click(function(){
    	var lensType = 'G';
    
    	var d = $(this).attr('data-lensType');
    	if(d != undefined && d != null && d != '') lensType = d;
    	
    	//location.href="/front/vision2/vision-check?lensType="+lensType;
    	Dmall.FormUtil.submit("/front/vision2/vision-check?lensType="+lensType);
    });

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
//연말정산이동
function fn_go_yearend_tax(){
	if(loginYn == 'true') {
		if(integration == '03'){
			//location.href = "/front/member/yearend-taxList";
			Dmall.FormUtil.submit("/front/member/yearend-taxList");
		}
		else if(integration == '01'){
			Dmall.LayerUtil.confirm('통합멤버쉽 회원만 이용하실 수 있습니다.<br>지금 멤버쉽 통합절차를 진행할까요?', function() {
	            //location.href="/front/member/member-integration-form";
	            Dmall.FormUtil.submit("/front/member/member-integration-form");
	        });
	        
		}
		else if(integration == '02'){
			Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
	            //location.href="/front/member/information-update-form";
	            Dmall.FormUtil.submit("/front/member/information-update-form");
	        });
		}
	}else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
            function() {
                //location.href= "/front/login/member-login?returnUrl=/front/member/yearend-taxList";
                Dmall.FormUtil.submit("/front/login/member-login?returnUrl=/front/member/yearend-taxList");
            },'');
	}
	
}
//장바구니이동
function move_basket(){
    //location.href = "/front/basket/basket-list"
    Dmall.FormUtil.submit("/front/basket/basket-list");
}
//공지사항이동
function move_notice(){
    //location.href = "/front/customer/notice-list";
    Dmall.FormUtil.submit("/front/customer/notice-list");
}
// 주문내역이동
function move_order(){
    if(loginYn == 'true') {
        //location.href = "/front/order/order-list";
        Dmall.FormUtil.submit("/front/order/order-list");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
            function() {
                //location.href= "/front/login/member-login"
                Dmall.FormUtil.submit("/front/login/member-login");
            },'');
    }
}
//관심상품이동
function move_interest(){
    if(loginYn == 'true') {
        //location.href = "/front/interest/interest-item-list";
        Dmall.FormUtil.submit("/front/interest/interest-item-list");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
        function() {
            //location.href= "/front/login/member-login"
            Dmall.FormUtil.submit("/front/login/member-login");
        },'');
    }
}
//마이페이지 이동
function move_mypage(){
    if(loginYn == 'true') {
        //location.href = "/front/member/mypage";
        Dmall.FormUtil.submit("/front/member/mypage");
    }else{
        Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
            function() {
                //location.href= "/front/login/member-login"
                Dmall.FormUtil.submit("/front/login/member-login");
            },'');
    }
}

//오른쪽 퀵메뉴 조회
var RightQuickMenu = function() {
    //최근본상품 조회
	$('.quick_view_area').html('');
	$('.btn_quick_area').html('');
    var goods_list = getCookie('LATELY_GOODS');
    var items = goods_list? goods_list.split('||') :[];//상품구분

    var items_cnt = items.length;
    var lately_goods = '<ul class="quick_view">';
    var quick_text ="";
    for(var i=0; i< items_cnt-1;i++){
        var attr = items[i]? items[i].split(/@/) :[];//상품속성구분
        /*var item = '<li><a href="javascript:goods_detail(\''+attr[0]+'\');"><img src=\''+attr[2]+'\'></a></li>';*/
        var item = '<li rel="qv0'+(i+1)+'">'+
            '<a href="javascript:goods_detail(\''+attr[0]+'\');">'+
            /*(i+1)+*/
            '<img src="'+_IMAGE_DOMAIN+attr[2]+'" alt="최근 본 상품">'+
            '</a>'+
            '<button type="button" class="btn_del_quick" onClick="javascript:fn_del_quick(\''+attr[0]+'\')">최근본 상품 삭제</button>'+
            '</li>';
        lately_goods +=item;
        quick_text += '<div class="quick_text" id="qv0'+(i+1)+'">' ;
        quick_text += '       <p class="name">'+attr[1]+'</p>' ;
        if(attr[3])
        quick_text += '       <p class="price">'+commaNumber(attr[3])+'원</p>' ;
        quick_text += '</div>';

    }
    lately_goods += '</ul>';
    lately_goods += quick_text;
    if( items_cnt != 0 ) items_cnt = items_cnt-1;
    var totPage = items_cnt/4;
	totPage = Math.ceil(totPage);
	if(items_cnt == 0){
		totPage = 1;
	}
    
    var paging = ' <button type="button" class="btn_quick_prev">이전</button>' +
        '                <span class="count"><em>1</em>/<em>'+ totPage +'</em></span>' +
        '          <button type="button" class="btn_quick_next">다음</button>';

    //최근본상품 갯수노출
    $(".quick_view_area").html(lately_goods);
    
    $(".btn_quick_area").html(paging);
    
    $('#lately_count').text(items_cnt);

    //장바구니,관심상품카운트 조회
    var url = '/front/member/quick-info';
    Dmall.AjaxUtil.getJSON(url, '', function(result) {
        if(result.success) {
            $("#basket_count").html(result.data.basketCnt);//장바구니갯수
            $("#interest_count").html(result.data.interestCnt);//관심상품갯수
            $("#delivery_count").html(result.data.deliveryCnt);//배송중인갯수
            $("#move_cart .cart_won").html("("+result.data.basketCnt+")");//장바구니갯수
            if(result.data.cpCnt != null && result.data.cpCnt > 0){
            	$('#coupon_count').html(result.data.cpCnt);	//쿠폰갯수
            }
        }
    });
    //관심상품이동
    $( '#btn_move_interest' ).on( 'click', function () {
        if(loginYn == 'true') {
            //location.href = "/front/interest/interest-item-list";
            Dmall.FormUtil.submit("/front/interest/interest-item-list");
        }else{
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
            function() {
                //location.href= "/front/login/member-login"
                Dmall.FormUtil.submit("/front/login/member-login");
            },'');
        }
    } );
};

//우측 퀵메뉴 스크립트
var BxSliderUtil = {
    object:{}
    , render:function() {
        /*var quick_mySlider = $( '.quick_view' ).bxSlider( {
            mode: 'vertical',// 가로  방향 수평 슬라이드
            speed: 500,        // 이동 속도를 설정
            pager: false,      // 현재 위치 페이징 표시 여부 설정
            moveSlides: 1,     // 슬라이드 이동시 개수
            slideWidth: 100,   // 슬라이드 너비
            minSlides: 3,      // 최소 노출 개수
            maxSlides: 3,      // 최대 노출 개수
            slideMargin: 16,    // 슬라이드간의 간격
            auto: false,        // 자동 실행 여부
            autoHover: true,   // 마우스 호버시 정지 여부
            controls: false    // 이전 다음 버튼 노출 여부
            //infiniteLoop: false,//무한루프여부
            //hideControlOnEnd: true //마지막으로 갔을때 이동버튼 삭제
        } );*/

        //bxslider
        function insertCount(curr_page, tot_goods) {
        	var totPage = tot_goods/4;
        	totPage = Math.ceil(totPage);
        	$(".btn_quick_area").find(".count").html('<em>'+curr_page+'</em>/<em>'+totPage+'</em>');
        	$('.quick_area').find('#lately_count').html(tot_goods);
        };

        var quick_mySlider = $( '.quick_view ' ).bxSlider( {
            mode: 'vertical',// 가로  방향 수평 슬라이드
            speed: 500,        // 이동 속도를 설정
            pager: false,      // 현재 위치 페이징 표시 여부 설정
            moveSlides: 4,     // 슬라이드 이동시 개수
            slideWidth: 81,   // 슬라이드 너비
            minSlides: 4,      // 최소 노출 개수
            maxSlides: 4,      // 최대 노출 개수
            slideMargin: 5,    // 슬라이드간의 간격
            auto: false,        // 자동 실행 여부
            autoHover: true,   // 마우스 호버시 정지 여부
            controls: false,    // 이전 다음 버튼 노출 여부
            infiniteLoop: false,//무한루프여부
            //hideControlOnEnd: true //마지막으로 갔을때 이동버튼 삭제
            onSliderLoad: function (currentIndex){
                //quick_mySlider.goToNextSlide();
            },
            onSlideAfter: function(){
                var latelyTotCnt = Number($("#latelyTotcnt").text());
                /*quick_mySlider.getSlideCount()*/
                /*$('.slide-number').text((slider.getCurrentSlide()+1)+'/'+slider.getSlideCount());*/
            },
            onSlideNext: function () {
                var tot_goods = quick_mySlider.getSlideCount();
                var curr_page = quick_mySlider.getCurrentSlide()+1;
                tot_goods = $('.quick_view li:not(.bx-clone)').length;
                /*  var current = (quick_mySlider.getCurrentSlide()+1);
                  if(current>latelyTotCnt){
                      current=1;
                  }*/
                insertCount(curr_page, tot_goods);
            },
            onSlidePrev: function () {
                var tot_goods = quick_mySlider.getSlideCount();
                var curr_page = quick_mySlider.getCurrentSlide()+1;
                tot_goods = $('.quick_view li:not(.bx-clone)').length;
                insertCount(curr_page, tot_goods);
            }
        } );


        $('.btn_quick_prev').click(function () {
            quick_mySlider.goToPrevSlide();
        });
        $('.btn_quick_next').click(function () {
        	var totPage = quick_mySlider.getSlideCount()/4;
        	totPage = Math.ceil(totPage);
            var currPage = quick_mySlider.getCurrentSlide()+1;
            if(totPage <= currPage){
            	return false;
            }
            quick_mySlider.goToNextSlide();
        });

        $(".quick_view li").hover(function() {
            var quickName = $(this).attr("rel");
            $("#" + quickName).show();
            $(this).children(".btn_del_quick").show();

            var idx = $('li').index(this)%4;
            var obj = $('li').eq(idx).position();
            
            $("#" + quickName).css("top", obj.top + "px");
        });
        $(".quick_view li").mouseleave(function() {
            var quickName = $(this).attr("rel");
            $("#" + quickName).hide();
            $(".btn_del_quick").hide();
        });

        BxSliderUtil.object = quick_mySlider;
        
        $('.bx-wrapper').css('margin-left','8px');
    }
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
    Dmall.FormUtil.submit('/front/event/attendance-check-deatil');
}
//인기검색어조회
function keywordSearch(keyword){
    $("#searchText").val(keyword);
    var param = {searchWord : $("#searchText").val()};
    Dmall.FormUtil.submit('/front/search/goods-list-search', param);
}
//최근본상품 삭제
function fn_del_quick(goodsNo){
	var goods_list = getCookie('LATELY_GOODS');
    var items = goods_list? goods_list.split('||') :[];//상품구분
    var items_cnt = items.length;
    var new_items = '';
    for(var i=0; i< items_cnt-1;i++){
    	if(items[i].indexOf(goodsNo) == -1){
    		new_items += items[i] + '||';
    	}
    }
    
    var expdate = new Date();
    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
    
    setCookie('LATELY_GOODS',new_items,expdate);
    // 퀵메뉴 갱신
    RightQuickMenu();
    //bxSlider 로드
    BxSliderUtil.render();

}
/******************************************************************************
**  페이징이동 관련함수
*******************************************************************************/
// 카테고리 이동
function move_category(no, type) {
	//Dmall.waiting.start();
	var url = "/front/search/category?ctgNo="+no;
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
    //location.href = "/front/order/order-detail?ordNo="+no;
    Dmall.FormUtil.submit("/front/order/order-detail?ordNo="+no);
}

function move_nonmember_order_detail(no) {
	//location.href = "/front/order/nomember-order-detail?ordNo="+no;
	Dmall.FormUtil.submit("/front/order/nomember-order-detail?ordNo="+no);
}


// 페이지 이동
function move_page(idx){
	//Dmall.waiting.start();
    if(idx == 'faq'){ // FAQ 목록페이지
        //location.href = "/front/customer/faq-list";
        Dmall.FormUtil.submit("/front/customer/faq-list");
    }else if (idx == 'notice'){ // 공지사항 목록페이지
        //location.href = "/front/customer/notice-list";
    	Dmall.FormUtil.submit("/front/customer/notice-list");
    }else if (idx == 'inquiry'){ // 마이페이지-상품문의목록페이지
        if(loginYn == 'true') {
            //location.href = "/front/customer/inquiry-list";
            Dmall.FormUtil.submit("/front/customer/inquiry-list");
        }else{
            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",function() {
            	//location.href= "/front/login/member-login"
            	Dmall.FormUtil.submit("/front/login/member-login");
            	},'');
        }
    }else if(idx == 'login'){ //로그인페이지
        //location.href = "/front/login/member-login";
        Dmall.FormUtil.submit("/front/login/member-login");
    }else if(idx == 'main'){ //메인페이지
        //location.href = "/front/main-view";
        Dmall.FormUtil.submit("/front/main-view");
    }else if(idx == 'id_search'){ //아이디찾기 페이지
        //location.href = "/front/login/account-search?mode=id";
        Dmall.FormUtil.submit("/front/login/account-search?mode=id");
    }else if(idx == 'pass_search'){ //비밀번호찾기 페이지
        //location.href = "/front/login/account-search?mode=pass";
        Dmall.FormUtil.submit("/front/login/account-search?mode=pass");
    }else if(idx == 'interest'){ //관심상품 페이지
        //location.href = "/front/interest/interest-item-list";
        Dmall.FormUtil.submit("/front/interest/interest-item-list");
    }else{
        alert("페이지경로가 정상적이지 않습니다.")
    }
}


/******************************************************************************
** 기획전 전시존 관련함수
*******************************************************************************/
//기획전 전시타입변경
function Ehb_dispType(type){
    $('#displayTypeCd').val(type);
    detailEhb();    
}

//기획전 전시
function detailEhb(){
    $('#form_id_search').attr("action",'/front/promotion/promotion-detail')
    $('#form_id_search').submit();
}
/******************************************************************************
** 기획전 전시존 관련함수
*******************************************************************************/

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
    $('#form_id_search').attr("action",'/front/search/category');
    $('#form_id_search').submit();
}

/******************************************************************************
** 상품검색 관련함수
*******************************************************************************/

// 상품검색
function goods_search(){
    $('#form_id_search').attr("method",'POST');
    $('#form_id_search').attr("action",'/front/search/goods-list-search');
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
    //location.href = "/front/goods/goods-detail?goodsNo="+idx + param+"&refererType="+refererType;
    Dmall.FormUtil.submit("/front/goods/goods-detail?goodsNo="+idx + param+"&refererType="+refererType);
    }else{
    //location.href = "/front/goods/goods-detail?goodsNo="+idx + param;
    Dmall.FormUtil.submit("/front/goods/goods-detail?goodsNo="+idx + param);
    }
}

// 상품이미지 미리보기
function goods_preview(goodsNo){
    var param = 'goodsNo='+goodsNo;
    var url = '/front/goods/goods-image-preview?'+param;
    Dmall.AjaxUtil.load(url, function(result) {
        var goodsNm = $(".goods_tltle span").text();
        $('#goodsPreview').html(result);
        $('#goodsPreview .head h1').html(goodsNm);

        Dmall.LayerPopupUtil.open($("#div_goodsPreview"));
    })
}
// 상품이미지 미리보기 닫기
function close_goods_preview(){
    Dmall.LayerPopupUtil.close("div_goodsPreview");
}

//교환팝업
function order_exchange_pop(no){
    var url = '/front/order/order-exchange-pop?ordNo='+no;
    Dmall.AjaxUtil.load(url, function(result) {
        $('#popup_my_order_replace').html(result).promise().done(function(){
            $('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
        });
        Dmall.LayerPopupUtil.open($("#div_order_exchange"));
        //에디터
        Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
        Dmall.DaumEditor.create('claimDtlReason2'); // claimDtlReason 를 ID로 가지는 Textarea를 에디터로 설정
        $('.tx-resize-bar').hide();
    })
}
//교환신청
function claim_exchange(){
	Dmall.DaumEditor.setValueToTextarea('claimDtlReason2');  // 에디터에서 폼으로 데이터 세팅
	
    var url = '/front/order/exchange-claim-apply'
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

    Dmall.LayerUtil.confirm('교환신청 하시겠습니까?', function() {
        $('input:checkbox[name=itemNoArr]:checked').each(function(i) {
            var _idx = $(this).attr("id").split("_")[1];
            ordNoArr += ($(this).parents('tr').attr('data-ord-no'));
            ordNoArr += comma;
            ordDtlSeqArr += ($(this).parents('tr').attr('data-ord-dtl-seq'));
            ordDtlSeqArr += comma;
            claimReasonCdArr += ($("#claimReasonCd_"+_idx).val());
            claimReasonCdArr += comma;
            claimQttArr += ($("#claimQtt_"+_idx).val());
            claimQttArr += comma;
        });
/*        var param = {
             ordNo:$("#ordNo").val()
            ,claimDtlReason:$("#claimDtlReason").val()
            ,claimReasonCdArr:claimReasonCdArr
            ,ordNoArr:ordNoArr
            ,ordDtlSeqArr:ordDtlSeqArr
            };*/
        $("#ordNo").val($("#ordNo").val());
        $("#claimDtlReason2").val($("#claimDtlReason2").val());
        $("#claimReasonCdArr").val(claimReasonCdArr);
        $("#ordNoArr").val(ordNoArr);
        $("#ordDtlSeqArr").val(ordDtlSeqArr);
        $("#claimQttArr").val(claimQttArr);
        
        var param = jQuery('#form_id_exchage').serialize();

        Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
            if( !result.success){
                close_exchange_pop();
                Dmall.LayerUtil.alert("교환신청에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                    location.reload();
                });
            }else{
                close_exchange_pop();
                Dmall.LayerUtil.alert("교환신청 되었습니다.", "알림").done(function(){
                    location.reload();
                });
            }
        });
    });
}
//교환팝업 닫기
function close_exchange_pop(){
    Dmall.LayerPopupUtil.close("div_order_exchange");
}

//반품/환불팝업
function order_refund_pop(no){
    var url = '/front/order/order-refund-pop?ordNo='+no;
    Dmall.AjaxUtil.load(url, function(result) {
        $('#popup_my_order_refund').html(result);

        Dmall.LayerPopupUtil.open($("#div_order_refund"));
        //에디터
        Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
        Dmall.DaumEditor.create('claimDtlReason'); // claimDtlReason 를 ID로 가지는 Textarea를 에디터로 설정
        $('.tx-resize-bar').hide();
    })
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
            if(Dmall.validation.isEmpty($("#holderNm").val())){
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
            }
        }
    }

    var chkItem = $('input:checkbox[name=itemNoArr]:checked').length;
    if(chkItem == 0){
        Dmall.LayerUtil.alert('반품신청할 상품을 선택해 주십시요');
        return;
    }

    if($("#claimReasonCd option:selected").val() == '') {
        Dmall.LayerUtil.alert("반품 사유를 선택해 주세요");
        return;
    }



    if($.trim($('#claimDtlReason').val()) == '') {
        Dmall.LayerUtil.alert("상세 사유를 입력해 주세요.");
        return;
    }

    var url = '/front/order/refund-claim-apply'
        , ordNoArr = ""
        , ordDtlSeqArr = ""
        , claimReasonCdArr = ""
        , claimQttArr = ""
        , ordQttArr="";
    var comma = ',';
    var chkItem = $('input:checkbox[name=itemNoArr]:checked').length;
    if(chkItem == 0){
        Dmall.LayerUtil.alert('반품신청할 상품을 선택해 주십시요');
        return;
    }

    Dmall.LayerUtil.confirm('반품신청 하시겠습니까?', function() {

        $('input:checkbox[name=itemNoArr]:checked').each(function(i) {
            var _idx = $(this).attr("id").split("_")[1];
            ordNoArr += ($(this).parents('tr').attr('data-ord-no'));
            ordNoArr += comma;
            ordQttArr += ($(this).parents('tr').attr('data-ord-qtt'));
            ordQttArr += comma;
            ordDtlSeqArr += ($(this).parents('tr').attr('data-ord-dtl-seq'));
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


        /*var param = {
            ordNo:$("#ordNo").val()
            ,claimDtlReason:$("#claimDtlReason").val()
            ,claimReasonCdArr:claimReasonCdArr
            ,ordNoArr:ordNoArr
            ,ordDtlSeqArr:ordDtlSeqArr
            ,claimQttArr:claimQttArr
            ,memberOrdYn : $("#memberOrdYn").val()
            ,paymentWayCd:$("#memberOrdYn").val()
            ,holderNm:$("#holderNm").val()
            ,bankNm:$("#bankNm").val()
            ,actNo:$("#actNo").val()
            ,bankCd:$("#bankCd:selected").val()
        };*/
        var param = jQuery('#form_id_refund').serialize();
        Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
            if( !result.success){
                Dmall.LayerPopupUtil.close("div_order_refund");//레이어팝업 닫기
                Dmall.LayerUtil.alert("반품신청에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                    location.reload();
                });
            }else{
                Dmall.LayerPopupUtil.close("div_order_refund");//레이어팝업 닫기
                Dmall.LayerUtil.alert("반품신청 되었습니다.", "알림").done(function(){
                    location.reload();
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
    var url = '/front/order/order-cancel-pop?ordNo='+no;
    Dmall.AjaxUtil.load(url, function(result) {
        $('#popup_my_order_cancel').html(result).promise().done(function(){
            $('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
        });
        Dmall.LayerPopupUtil.open($("#div_order_cancel"));
    })
}

//주문전체취소
function order_cancel_all(){
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
    Dmall.LayerUtil.confirm('전체 취소 하시겠습니까?', function() {
        var comma = ',';
        var ordDtlSeqArr = "";
        $('input:checkbox[name=itemNoArr]').prop('checked',true);
        $('input:checkbox[name=itemNoArr]:checked').each(function(i) {
            if(i != 0 )ordDtlSeqArr += comma;
            ordDtlSeqArr += ($(this).parents('tr').attr('data-ord-dtl-seq'));
        });
        var param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,partCancelYn:"N",cancelType:$('#cancelType').val(),
            claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val(),holderNm:$('#holderNm').val(),
            bankCd:$('#bankCd').val(),actNo:$('#actNo').val()};
        var url = '/front/order/order-cancel-all';
        //var param = $('#form_id_cancel').serializeArray();
        Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
            if( !result.success){
                Dmall.LayerPopupUtil.close("div_order_cancel");//레이어팝업 닫기
                Dmall.LayerUtil.alert("취소에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                    location.reload();
                });
            }else{
                Dmall.LayerPopupUtil.close("div_order_cancel");//레이어팝업 닫기
                Dmall.LayerUtil.alert("전체취소 되었습니다.", "알림").done(function(){
                    location.reload();
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

    var url = '/front/order/bundle-delivery-amt'
    , param = {}
    , ordDtlSeqArr = "";
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
        ordDtlSeqArr += ($(this).parents('tr').attr('data-ord-dtl-seq'));

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
            url = "/front/order/order-cancel";
            Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerUtil.alert(notiMsg+" 되었습니다.", "알림").done(function(){
                        Dmall.LayerPopupUtil.close("div_order_cancel");
                        location.reload();
                    });
                } else {
                    Dmall.LayerPopupUtil.close("div_order_cancel");
                    Dmall.LayerUtil.alert(notiMsg+result.exMsg+"<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                        /*location.reload();*/
                    });
                }
            })
        });

    });
}

// 구매확정 처리
function updateBuyConfirm(ordNo,ordDtlSeq){
    var url = '/front/order/buy-confirm-update';
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
    var url = '/front/order/nomember-order-check';
    var param = jQuery('#nonMemberloginForm').serialize();
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        if(result.success) {
            $('#nonMemberloginForm').attr("action",'/front/order/nomember-order-list');
            $('#nonMemberloginForm').submit();
        }else{
            Dmall.LayerUtil.alert("주문정보를 확인해주시기 바랍니다.","알림");
        }
    });
}

// 비회원방문예약
function nonMember_rsv_list(){
    var url = '/front/visit/nomember-rsv-check';
    var param = jQuery('#nonMemberRsvForm').serialize();
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        if(result.success) {
            $('#nonMemberRsvForm').attr("action",'/front/visit/nomember-rsv-list');
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
        window.open('http://www.kdexp.com', '_blank');
        /*trans_url = "http://www.kdexp.com/sub4_1.asp?stype=1&p_item="+tranNo;*/
        /*window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');*/
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

    var notiMsg = "";
    if(Dmall.validation.isEmpty($("#issueWayNo").val())){
        Dmall.LayerUtil.alert("인증번호를 입력해주세요.");
        $("#issueWayNo").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#cash_email01").val())|| Dmall.validation.isEmpty($("#cash_email02").val())) {
        Dmall.LayerUtil.alert('이메일을 입력해주세요.');
        jQuery('#cash_email01').focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#cashTelNo").val())){
        Dmall.LayerUtil.alert('전화번호를 입력해주세요.');
        $("#cashTelNo").focus();
        return false;
    }
    $('#telNo').val($('#cashTelNo').val());
    if($('#cash_personal').is(":checked") == true){
        $("#useGbCd").val("01");
    }else{
        $("#useGbCd").val("02");
    }
    if($('#pgCd').val() == '00') {
        notiMsg = "신청";
    } else {
        notiMsg = "처리";
    }
    $('#email').val($('#cash_email01').val()+"@"+$('#cash_email02').val());
    Dmall.LayerUtil.confirm('현금영수증 발급신청 하시겠습니까?', function() {
        var url = '/front/order/cash-receipt-apply';
        var param = $('#form_id_order_info').serializeArray();
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if( !result.success){
                Dmall.LayerUtil.alert("현금영수증 발급"+notiMsg+"에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                    Dmall.LayerPopupUtil.close("popup_my_cash");
                    location.reload();
                });
            }else{
                Dmall.LayerUtil.alert("현금영수증 발급"+notiMsg+" 되었습니다.", "알림").done(function(){
                    Dmall.LayerPopupUtil.close("popup_my_cash");
                    location.reload();
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
        Dmall.LayerUtil.alert('상호명을 입력해주세요.');
        $("#companyNm").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#bizNo").val())){
        Dmall.LayerUtil.alert('사업자 번호를 입력해주세요.');
        $("#bizNo").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#ceoNm").val())){
        Dmall.LayerUtil.alert('대표자명을 입력해주세요.');
        $("#ceoNm").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#bsnsCdts").val())){
        Dmall.LayerUtil.alert('업태를 입력해주세요.');
        $("#bsnsCdts").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#item").val())){
        Dmall.LayerUtil.alert('업종을 입력해주세요.');
        $("#item").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#postNo").val())){
        Dmall.LayerUtil.alert('주소를 입력해주세요.');
        $("#postNo").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#managerNm").val())){
        Dmall.LayerUtil.alert('담당자명을 입력해주세요.');
        $("#managerNm").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#tax_email01").val())|| Dmall.validation.isEmpty($("#tax_email02").val())) {
        Dmall.LayerUtil.alert('담당자 이메일을 입력해주세요.');
        $("#tax_email01").focus();
        return false;
    }
    if(Dmall.validation.isEmpty($("#taxTelNo").val())){
        Dmall.LayerUtil.alert('담당자 전화번호를 입력해주세요.');
        $("#taxTelNo").focus();
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
        var url = '/front/order/tax-bill-apply';
        var param = $('#form_id_order_info').serializeArray();
        Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
            if( !result.success){
                Dmall.LayerUtil.alert(result.message, "알림").done(function(){
                    Dmall.LayerPopupUtil.close("popup_my_tax");
                });
            }else{
                Dmall.LayerUtil.alert("세금계산서 신청처리 되었습니다.", "알림").done(function(){
                    Dmall.LayerPopupUtil.close("popup_my_tax");
                    //location.href = "/front/order/order-list";
                    Dmall.FormUtil.submit("/front/order/order-list");
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
    }else if(pgCd == '81'){ //PAY PAL
        Dmall.LayerUtil.alert("PAY PAL로 결재하신 주문건의 영수증은 고객님의 메일로 발송됩니다.", "알림")
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
        window.open("https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&tno="+tid+"&order_no="+ordNo+"&trade_mony="+totAmt, "kcpReceipt", "width=470,height=815");
    }else if(pgCd == '02'){//이니시스
        window.open("https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=" +tid + "&noMethod=1", "iniReceipt" + tid, "width=405,height=525");
    }else if(pgCd == '03'){//LGU
        var showreceiptUrl = "http://pgweb.dacom.net"+ (mode=="test"? ":7080" : "") +"/pg/wmp/etc/jsp/Receipt_Link.jsp?mertid="+mid+"&tid="+tid+"&authdata="+confirmHashData;
        window.open(showreceiptUrl,"showreceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
    }else if(pgCd == '04'){ //ALLTHEGATE
        var showreceiptUrl = "http://allthegate.com/customer/receiptLast3.jsp?sRetailer_id="+mid+"&approve="+confirmNo+"&send_no="+tid+"&send_dt="+confirmDttm;
        window.open(showreceiptUrl,"showreceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
    }else if(pgCd == '41'){ //PAYCO
        var realServiceYn = $('#realServiceYn').val();
        var receiptUrl = '';
        if(realServiceYn === 'Y') {
            receiptUrl = 'https://bill.payco.com';
        } else {
            receiptUrl = 'https://alpha-bill.payco.com';
        }
        var showreceiptUrl = receiptUrl + "/outseller/receipt/"+confirmNo+"?receiptKind=card";
        window.open(showreceiptUrl,"paycoReceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
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
                    //location.href= "/front/login/member-login?returnUrl="+returnUrl;
                    Dmall.FormUtil.submit("/front/login/member-login?returnUrl="+returnUrl);
                    },''
                );
        } else {
            var url = '/front/interest/interest-item-insert';
            var param = {goodsNo : goodsNo};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                    RightQuickMenu(); //퀵메뉴갱신
                    BxSliderUtil.object.reloadSlider();
                    Dmall.LayerUtil.confirm('관심상품으로 이동 하시겠습니까?', function() {
                        //location.href="/front/interest/interest-item-list";
                    	Dmall.FormUtil.submit("/front/interest/interest-item-list");
                    })
                 }
            })
        }
    }
    , insertBasket:function(goodsNo, rsvOnlyYn) {
    	if(rsvOnlyYn == 'Y'){
    		Dmall.LayerUtil.alert("매장 전용 상품으로 '예약하기'를 이용해 주세요.", "알림");
    		return false;
    	}
        /*Dmall.LayerUtil.confirm('장바구니에 등록하시겠습니까?', function() {*/
            var url = '/front/interest/check-basket-insert'
                , param = {'goodsNoArr':goodsNo};

            ListBtnUtil.customAjax(url, param, function(result) {
                if(result.success){
                    RightQuickMenu(); //퀵메뉴갱신
                    BxSliderUtil.object.reloadSlider();
                    if(basketPageMovYn === 'Y') {
                        Dmall.LayerPopupUtil.open($('#success_basket'));//장바구니 등록성공팝업
                    } else {
                        //location.href = "/front/basket/basket-list";
                        Dmall.FormUtil.submit("/front/basket/basket-list");
                    }
                } else {
                    if(result.data.adultFlag != '' && result.data.adultFlag === 'Y') {
                        //location.href = '/front/interest/adult-restriction';
                        Dmall.FormUtil.submit('/front/interest/adult-restriction');
                    }
                }
            });
        /*});*/
    }
};
/* 상세보기 LayerPopup */
//상품상세페이지 이동
function order_cancel_detail(ordNo,ordDtlSeq,ordDtlStatusCd){
    var url = '/front/order/order-cancel-detail?ordNo='+ordNo+'&ordDtlSeq='+ordDtlSeq;
    Dmall.AjaxUtil.load(url, function(result) {
        $('#popup_my_order_cancel_layer').html(result);
        Dmall.LayerPopupUtil.open($("#div_order_cancel_layer"));
    })
}
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



