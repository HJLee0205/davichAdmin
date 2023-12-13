<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script type="text/javascript">
$(document).ready(function(){
    $('.btn_quick_top').click(function(){
        $('html, body').animate({scrollTop:0},400);
        return false;
    });

    //최근본상품 출력
    var goods_list = getCookie('LATELY_GOODS');
    var items = goods_list? goods_list.split(/,/) :new Array();//상품구분
    var items_cnt = items.length;
    var lately_goods = "";
    for(var i=0; i< items_cnt-1;i++){
        var attr = items[i]? items[i].split(/@/) :new Array();//상품속성구분
        var item = '<li><a href="javascript:goods_detail(\''+attr[0]+'\');"><img src=\''+attr[2]+'\'></a>'+attr[1]+'</li>';
        lately_goods +=item;
    }
    if( items_cnt != 0 ) items_cnt = items_cnt-1;
    $("#lately_count").html(items_cnt);//최근본상품 갯수노출
    $(".quick_view").html(lately_goods);
    var url = '/front/member/quick-info';
    Dmall.AjaxUtil.getJSON(url, '', function(result) {
        if(result.success) {
            $("#basket_count").html(result.data.basketCnt);//장바구니갯수
            $("#interest_count").html(result.data.interestCnt);//관심상품갯수
        }
    });
});

$( function () {
   var mySlider = $( '.quick_view' ).bxSlider( {
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
   } );
   $( '.btn_quick_pre' ).on( 'click', function () {
       mySlider.goToPrevSlide();
       return false;
   } );
   $( '.btn_quick_next' ).on( 'click', function () {
       mySlider.goToNextSlide();
       return false;
   } );
} );
</script>
<div id="quick_menu">
        <div class="quick_area">
            <h2 class="quick_title">QUICK MENU</h2>
            <div class="quick_body">
                <ul class="quick_smenu">
                    <li><a href="#none">최근본상품 <span id="lately_count"></span></a></li>
                    <li><a href="/front/basket/basket-list">장바구니 <span id="basket_count"></span></a></li>
                    <li><a href="/front/interest/interest-item-list">위시리스트 <span id="interest_count"></span></a></li>
                </ul>
                <p>
                    <a href="#" class="btn_quick_pre">
                        <img src="${_SKIN_IMG_PATH}/quick/btn_quick_pre.png" alt="이전">
                    </a>
                </p>
                <!-- 최근본상품 -->
                <ul class="quick_view"></ul>
                <!-- 최근본상품 -->
                <p>
                    <a href="#" class="btn_quick_next">
                        <img src="${_SKIN_IMG_PATH}/quick/btn_quick_next.png" alt="다음">
                    </a>
                </p>
            </div>
            <a href="#none" class="btn_quick_top">TOP</a>
        </div>
    </div>