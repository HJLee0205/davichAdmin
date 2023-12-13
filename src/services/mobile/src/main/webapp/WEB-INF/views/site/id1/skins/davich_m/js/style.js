
/*  === 헤드 영역 배너 === */
$(function () {
	$(".btn_close_tbanner").click(function () {
		//탑배너를 닫을때 인스턴트 쿠키 세팅(브라우저 종료시 쿠키 지워짐)
		setInstantCookie("tbanner","close");
		$(".head_banner_area").slideUp('fast');
	});
});

/*  === 헤드 고정 === */
var currentScrollTop = 0;
window.onload = function() {
	scrollController();
	$(window).on('scroll', function() {
		scrollController();
	});
}
function scrollController() {
	currentScrollTop = $(window).scrollTop();
	if (currentScrollTop < 100) {
		$('#header').css('top', 100 - (currentScrollTop));
		if ($('#header').hasClass('fixed')) {
			$('#header').removeClass('fixed');
			$('#search_area').show();
		}
	} else {
		if (!$('#header').hasClass('fixed')) {
			$('#header').css('top', 0);
			$('#header').addClass('fixed');
			$('#search_area').hide();
		}
	}
	if (currentScrollTop < 950) {
		$('.tabs.product').css('top', 950 - (currentScrollTop));
		if ($('.tabs.product').hasClass('fixed')) {
			$('.tabs.product').removeClass('fixed');
		}
	} else {
		if (!$('.tabs.product').hasClass('fixed')) {
			$('.tabs.product').css('top', 46);
			$('.tabs.product').addClass('fixed');
		}
	}
}
/* === search area === */
$(function () {
	$( "#header.fixed #search_area" ).hide();
	$(".btn_view_search").click(function () {
		$("#header.fixed #search_area").show();
	});
	$(".btn_close_search").click(function () {
		$("#header.fixed #search_area").hide();
	});

    $('.search_slider_area ul').bxSlider({
		controls: false,
		pager: true,
		slideWidth: '570',
		slideMargin:10,
		minSlides:2,
		maxSlides:2,
		moveSlide:1,
	});

	$(".btn_search_lnb").click(function () {
		var $this = $(this);
		$this.toggleClass('active');
		if($this.hasClass('active')){
			$('.search_lnb').css('height', 'auto');
		} else {
			$('.search_lnb').css('height', '42px');
		}
	});
	$(".btn_search_keyword").click(function () {
		var $this = $(this);
		$this.toggleClass('active');
		if($this.hasClass('active')){
			/*$('.search_keyword').css('height', 'auto');  검색_연관검색*/
			$('.search_keyword').css('height', '45px');
		} else {
			//$('.search_keyword').css('height', '49px');
			$('.search_keyword').css('height', '25px');
		}
	});
});

/* === search area === */
$(function () {
	$( "#header.fixed #search_area" ).hide();
	$(".btn_view_search").click(function () {
		$("#header.fixed #search_area").show();
	});
	$(".btn_close_search").click(function () {
		$("#header.fixed #search_area").hide();
	});
});

/* 검색 페이지 */
$(function() {
	$(".search_filter.option").hide();
		$('.btn_view_filter').click(function() {
			var $this = $(this);
			$this.toggleClass('active');
			if($this.hasClass('active')){
			$this.text('닫기');
			$('.search_filter.option').slideDown('fast');
			} else {
			$this.text('열기');
			$('.search_filter.option').slideUp('80');
		}
	});

})

/* == lnb_all == */
$(function() {
    $('#c-menu--slide-left').hide();
    $('.btn_all_menu').click(function() {
        $('#c-menu--slide-left').show();
        $("html, body").css({overflow:'hidden'}).bind('touchmove');
    });

	$('.c-menu__close').click(function() {
        $('#c-menu--slide-left').hide();
        $("html, body").css({'overflow':'visible'}).unbind('touchmove');//브라우져에 터치를 다시 활성화
    });
});

/* footer menu */
//$.fn.scrollEnd = function(callback, timeout) {
//  $(this).scroll(function(){
//    var $this = $(this);
//    if ($this.data('scrollTimeout')) {
//      clearTimeout($this.data('scrollTimeout'));
//    }
//    $this.data('scrollTimeout', setTimeout(callback,timeout));
//  });
//};
//
//$(window).scroll(function(){
//    $('#footer-menu').fadeOut();
//	$('#footer-content').fadeOut();
//});
//
//$(window).scrollEnd(function(){
//    $('#footer-menu').fadeIn();
//}, 350);

$(function() {
	$('#footer-content').hide();
	$('.btn_f_menu').click(function(e) {
		e.preventDefault();
		$('#footer-content').fadeIn();
		 $("html, body").css({'overflow':'visible'}).unbind('touchmove');//브라우져에 터치를 다시 활성화
	});
	$('.toggle-footer.close').click(function() {
		$('#footer-content').hide();
	});
});

/* == main slider == */
$(function () {
    $('.main_visual_slider' ).bxSlider({
		pager: false,
		controls: false,
		auto:true,
        pause: 4000
    });

	/*$('.product_slider_area' ).bxSlider({
		controls: false
    });*/

	var Bottomslider = $('.btm_banner_area ul' ).bxSlider({
		controls: false,
		pager: false,
	});
	$('.btn_btm_prev').click(function () {
		var current = Bottomslider.getCurrentSlide();
		Bottomslider.goToPrevSlide(current) - 1;
	});
	$('.btn_btm_next').click(function () {
		var current = Bottomslider.getCurrentSlide();
		Bottomslider.goToNextSlide(current) + 1;
	});

	var Brandslider = $('.brand_top_slider' ).bxSlider({
		controls: false,
		pager: false,
	});
	$('.brand_top .btn_sub_slider_prev').click(function () {
		var current = Brandslider.getCurrentSlide();
		Brandslider.goToPrevSlide(current) - 1;
	});
	$('.brand_top .btn_sub_slider_next').click(function () {
		var current = Brandslider.getCurrentSlide();
		Brandslider.goToNextSlide(current) + 1;
	});

	var typeBslider = $('.brand_top02 .product_list_typeB' ).bxSlider({
		controls: false,
		pager: false,
		slideWidth: '187',
		slideMargin:22,
		minSlides:2,
		maxSlides:2,
	});
	$('.brand_top02 .btn_sub_slider_prev').click(function () {
		var current = typeBslider.getCurrentSlide();
		typeBslider.goToPrevSlide(current) - 1;
	});
	$('.brand_top02 .btn_sub_slider_next').click(function () {
		var current = typeBslider.getCurrentSlide();
		typeBslider.goToNextSlide(current) + 1;
	});

	var Magazinemslider = $('.dzine_banner_area ul' ).bxSlider({
		controls: false,
		pager: false,
		auto:true,
        pause: 4000
	});
	$('.btn_magazine_prev').click(function () {
		var current = Magazinemslider.getCurrentSlide();
		Magazinemslider.goToPrevSlide(current) - 1;
	});
	$('.btn_magazine_next').click(function () {
		var current = Magazinemslider.getCurrentSlide();
		Magazinemslider.goToNextSlide(current) + 1;
	});
});

/* == view sitemap == */
$(function () {
	$(".view_sitemap_area" ).hide();
	$("#lnb #btn_view_all").click(function() {
		$(this).toggleClass('active');
		$( ".view_sitemap_area" ).slideToggle();
   })
});

/* == menu all_gnb == */
$(function () {
/*	$( ".site_nav_list_s" ).hide();
	$("div.site_nav_list").click(function () {
		var arrow = $(this);
		if(arrow.hasClass('active')){
			arrow.removeClass('active');
		}else{
			arrow.addClass('active');
		}
		$(this).next( ".site_nav_list_s" ).slideToggle();
	});*/
});

/* == menu all_gnb == */
$(function () {
	$(".hot_menu_list li a").click(function () {
		$(this).toggleClass('active');
	});
});


/* == gnb menu == */
$(document).ready(function() {
	$('.gnb_list li').mouseenter(function() {
		var gnbHref = $($(this).find('a').attr('href'));
			$(this).addClass('on').siblings().removeClass('on');
			gnbHref.show();
	}).mouseleave(function() {
		var gnbHref = $($(this).find('a').attr('href'));
			gnbHref.hide();
	});
});

/* == select box == */
$(document).ready(function() {
	var select = $("select");
	select.change(function(){
		var select_name = $(this).children("option:selected").text();
		$(this).siblings("label").text(select_name);
	});
});

/* == tab == */
 $(function () {
	$(".tab_content").hide();
	$(".tab_content:first").show();
	$("ul.tabs li").click(function () {
		$("ul.tabs li").removeClass("active").css("color", "#383838");
		$(this).addClass("active").css("color", "#383838");
		$(".tab_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn();
        window.location.href = "#goods_content";
	});

	$(".skin_tab_content").hide();
	$(".skin_tab_content:first").show();
	$("ul.skin_tabs li").click(function () {
		$("ul.skin_tabs li").removeClass("active").css("color", "#383838");
		$(this).addClass("active").css("color", "#383838");
		$(".skin_tab_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});

	$(".faq_tabs_content").hide();
	$(".faq_tabs_content:first").show();
	$("ul.faq_tabs li").click(function () {
		$("ul.faq_tabs li").removeClass("active").css("color", "#383838");
		$(this).addClass("active").css("color", "#383838");
		$(".faq_tabs_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});

	$(".tabs_member_content").hide();
	$(".tabs_member_content:first").show();
	$("ul.tabs_member li").click(function () {
		$("ul.tabs_member li").removeClass("active");
		$(this).addClass("active");
		$(".tabs_member_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});

	$(".my_tabs_content").hide();
	$(".my_tabs_content:first").show();
	$("ul.my_tabs li").click(function () {
		$("ul.my_tabs li").removeClass("active");
		$(this).addClass("active");
		$(".my_tabs_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});

	$(".event_tab_content").hide();
	$(".event_tab_content:first").show();
	$("ul.event_tabs li").click(function () {
		$("ul.event_tabs li").removeClass("active");
		$(this).addClass("active");
		$(".event_tab_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});

});


/* == 퀵메뉴 == */
$(document).ready(function() {
	$("#quick_menu").animate( { "top": $(document).scrollTop() + 180 +"px" }, 500 );
	  $(window).scroll(function(){
		$("#quick_menu").stop();
		$("#quick_menu").animate( { "top": $(document).scrollTop() + 180 + "px" }, 1000 );
	});
});

/* == 배너 == */
$(document).ready(function() {
	$("#banner").animate( { "top": $(document).scrollTop() + 180 +"px" }, 500 );
	  $(window).scroll(function(){
		$("#banner").stop();
		$("#banner").animate( { "top": $(document).scrollTop() + 180 + "px" }, 1000 );
	});
});

$(function () {
	var mySlider = $( '.product_list_typeD_slider' ).bxSlider( {
		auto: false,
		slideWidth: 400,
		pager: false,
		maxSlides: 2,
		moveSlides: 1,
		slideMargin: 30,
		controls: false,
		onSliderLoad: function(){
			$(".bx-clone .goods_image_area").mouseover(function() {
			  $(this).find('.product_list_typeD_info_area').stop().fadeIn('slow');
			  $(this).children('.img_menu').stop().fadeIn('slow');
			});
			$(".bx-clone .goods_image_area").mouseleave(function() {
			  $(this).find('.product_list_typeD_info_area').stop().fadeOut();
			  $(this).children('.img_menu').stop().fadeOut();
			});
		}
	});
	$( '.btn_product_list_pre' ).on( 'click', function () {
		mySlider.goToPrevSlide();
		return false;
	});
	$( '.btn_product_list_next' ).on( 'click', function () {
		mySlider.goToNextSlide();
		return false;
	});
});

/* == 자주묻는 질문 == */
$(function(){
	$(".accordion-section-content").hide();
	$(".accordion-section-title").click(function(){
		if($(this).hasClass('active')){
			$(this).removeClass('active');
		}else{
			$(this).addClass('active');}
		$(".accordion-section-content:visible").slideUp("middle");
		$(this).next('.accordion-section-content:hidden').slideDown("middle");
		return false;
	})
});


/* location 선택 메뉴 selectbox */
$(document).ready(function() {
	enableSelectBoxes();
});

function enableSelectBoxes(){
	$('div.category_selectBox').each(function(){
		$(this).children('span.selected').html($(this).children('div.selectOptions').children('span.selectOption:first').html());
		$(this).attr('value',$(this).children('div.selectOptions').children('span.selectOption:first').attr('value'));

		$(this).children('span.selected,span.selectArrow').click(function(){
			if($(this).parent().children('div.selectOptions').css('display') == 'none'){
				$(this).parent().children('div.selectOptions').css('display','block');
			}
			else
			{
				$(this).parent().children('div.selectOptions').css('display','none');
			}
		});

		$(this).find('span.selectOption').click(function(){
			$(this).parent().css('display','none');
			$(this).closest('div.selectBox').attr('value',$(this).attr('value'));
			$(this).parent().siblings('span.selected').html($(this).html());
		});
	});
}

/* style selectbox */
jQuery(document).ready(function(){
	var select = $("select.select_option");
	select.change(function(){
		var select_name = $(this).children("option:selected").text();
		$(this).siblings("label").text(select_name);
	});
});

/* 문의 */
$(function(){
	var article = (".my_qna_table .show");
	$(".my_qna_table .title td").click(function() {
		var myArticle =$(this).parents().next("tr");
		if($(myArticle).hasClass('hide')) {
			$(article).removeClass('show').addClass('hide');
			$(myArticle).removeClass('hide').addClass('show');
		}
		else {
			$(myArticle).addClass('hide').removeClass('show');
		}
	});

	var article02 = (".my_qna_table02 .show");
	$(".my_qna_table02 .title").on( 'click', function () {
		var myArticle02 =$(this).next("tr");
		if($(myArticle02).hasClass('hide')) {
			$(article02).removeClass('show').addClass('hide');
			$(myArticle02).removeClass('hide').addClass('show');
		}
		else {
			$(myArticle02).addClass('hide').removeClass('show');
		}
	});
	$(".my_qna_table02 .title").on( 'click', function () {
		$(this).toggleClass('active');
		$(".my_qna_table02 .title").not(this).removeClass('active');
	});
});

/* row 삭제 */
function deleteLine(obj) {
	var tr = $(obj).parent().parent();
	var title = $(obj).parents().prev('tr.title');
	var community = $(obj).parents().prev('div.free_comment_view');
	var event = $(obj).parents().prev('div.event_comment_view');
	var goods = $(obj).parents('li');

	//라인 삭제
	tr.remove();
	title.remove();
	event.remove();
	community.remove();
	goods.remove();
}

/* 재입고 알림 */
$(function () {
	$(".alarm_view_layer").hide();

	$("#btn_alarm_view").hover(function () {
		$(".alarm_view_layer").show();
	});
	$("#btn_alarm_view").mouseleave(function () {
		$(".alarm_view_layer").hide();
	});
});

/* 카테고리 리스트 보기 선택 */
$(function () {
	$(".category_view_content").hide();
	$(".category_view_content:first").show();

	$("ul.product_menu_view_select li.btn_view_image").click(function () {
		$("ul.product_menu_view_select li.btn_view_image").removeClass("selected");
		$(this).addClass("selected");
		$(".category_view_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});
});

/* selectbox option 선택 */
 $(document).ready(function() {
	$('#goods_option_01_view').hide();
	$('#goods_option_02_view').hide();
	$('#goods_option_03_view').hide();

	$(".goods_option_select01").change(function() {
	  var selected = $(".goods_option_select01 option:selected").val() ;
	  $('#goods_option_01_view').show();
	});
	$(".goods_option_select02").change(function() {
	  var selected = $("#goods_option_select02 option:selected").val() ;
	  $('#goods_option_02_view').show();
	});
	$(".goods_option_select03").change(function() {
	  var selected = $("#goods_option_select03 option:selected").val() ;
	  $('#goods_option_03_view').show();
	});
});

/* 상품이미지 메뉴 */
 $(document).ready(function() {
	/*$(".img_menu").hide();*/
	$(".goods_image_area").mouseover(function() {
	  $(this).children('.img_menu').stop().fadeIn('slow');
	});
	$(".goods_image_area").mouseleave(function() {
	  $(this).children('.img_menu').stop().fadeOut();
	});
});

$(document).ready(function() {
	$(".product_list_typeD_info_area").hide();
	$(".product_list_typeD_slider .goods_image_area").mouseover(function() {
	  $(this).children().next('.product_list_typeD_info_area').stop().fadeIn('slow');
	});
	$(".product_list_typeD_slider .goods_image_area").mouseleave(function() {
	  $(this).children().next('.product_list_typeD_info_area').stop().fadeOut();
	});

	$(".product_list_typeE_info_area").hide();
	$(".product_list_typeE_slider .goods_image_area").mouseover(function() {
	  $(this).children().next('.product_list_typeE_info_area').stop().fadeIn('slow');
	});
	$(".product_list_typeE_slider .goods_image_area").mouseleave(function() {
	  $(this).children().next('.product_list_typeE_info_area').stop().fadeOut();
	});
});

/* 체크 텝 */
$(document).ready(function() {

});

/* 상품 결제수단 탭 */
$(document).ready(function() {
	$('.radio_chack1_a').on('click', function(){
		$(this).siblings('div.radio1_con_a').hide();
		$(this).siblings('div.radio1_con_b').hide();
	})
	$('.radio_chack1_b').on('click', function(){
		$(this).siblings('div.radio1_con_a').show();
		$(this).siblings('div.radio1_con_b').hide();
	})
	$('.radio_chack1_c').on('click', function(){
		$(this).siblings('div.radio1_con_b').show();
		$(this).siblings('div.radio1_con_a').hide();
	})

	$('.radio_chack2_a').on('click', function(){
		$(this).parents().siblings('tr[class^="radio2_con"]').hide();
		$('tr.radio2_con_a').show();
	})
	$('.radio_chack2_b').on('click', function(){
		$(this).parents().siblings('tr[class^="radio2_con"]').hide();
		$('tr.radio2_con_b').show();
	})
	$('.radio_chack2_c').on('click', function(){
		$(this).parents().siblings('tr[class^="radio2_con"]').hide();
		$('tr.radio2_con_c').show();
	})
	$('.radio_chack2_d').on('click', function(){
		$(this).parents().siblings('tr[class^="radio2_con"]').hide();
		$('tr.radio2_con_d').show();
	})
	$('.radio_chack2_e').on('click', function(){
		$(this).parents().siblings('tr[class^="radio2_con"]').hide();
		$('tr.radio2_con_e').show();
	})
	$('.radio_chack2_f').on('click', function(){
		$(this).parents().siblings('tr[class^="radio2_con"]').hide();
		$('tr.radio2_con_f').show();
	})
	$('.radio_chack2_g').on('click', function(){
		$(this).parents().siblings('tr[class^="radio2_con"]').hide();
		$('tr.radio2_con_g').show();
	})
});

/*********************************************************/

/* === 리스트 선택 메뉴 selectbox === */
$(document).ready(function() {
	enableSelectBoxes_score();
});

function enableSelectBoxes_score(){
	$('div.list_selectBox').each(function(){
		$(this).children('span.selected').html($(this).children('div.selectOptions').children('span.selectOption:first').html());
		$(this).attr('value',$(this).children('div.selectOptions').children('span.selectOption:first').attr('value'));

		$(this).children('span.selected,span.selectArrow').click(function(){
			if($(this).parent().children('div.selectOptions').css('display') == 'none'){
				$(this).parent().children('div.selectOptions').css('display','block');
			}
			else
			{
				$(this).parent().children('div.selectOptions').css('display','none');
			}
		});

		$(this).find('span.selectOption').click(function(){
			$(this).parent().css('display','none');
			$(this).closest('div.selectBox').attr('value',$(this).attr('value'));
			$(this).parent().siblings('span.selected').data('value', $(this).attr('value'));
			$(this).parent().siblings('span.selected').html($(this).html());
		});
	});
}

$(function () {
	/*$("#list_view").hide();
	$(this).find('span#selectOption_list').click(function(){
		$('#image_view').hide();
		$('#list_view').show();
	});
	$(this).find('span#selectOption_image').click(function(){
		$('#image_view').show();
		$('#list_view').hide();
	})*/;
});

/* === 좋아요 버튼 === */
$(function () {
	$(".btn_check_like").click(function () {
	if($(this).hasClass('active')){
		$(this).removeClass('active');
	}else{
		$(this).addClass('active');}
	});
});
/* === sns 버튼 === */
$(function () {
	$('.btn_sns_area').hide();
	$(".btn_view_sns").click(function () {
		$('.btn_sns_area').show();
	});
	$( ".btn_sns" ).click(function() {
		$(".btn_sns_area" ).hide();
		return false;
	});
});

/* === selectbox option 선택 === */
 $(document).ready(function() {
	$('.product_option_list').hide();

	$("#goods_option_select01").change(function() {
	  var selected = $("#goods_option_select01 option:selected").val() ;
	  $('#goods_option_01_view').show();
	  $('.product_option_list').addClass('product_option_list_line');
	});
	$("#goods_option_select02").change(function() {
	  var selected = $("#goods_option_select02 option:selected").val() ;
	  $('#goods_option_02_view').show();
	  $('.product_option_list').addClass('product_option_list_line');
	});
	$("#goods_option_select03").change(function() {
	  var selected = $("#goods_option_select03 option:selected").val() ;
	  $('#goods_option_03_view').show();
	  $('.product_option_list').addClass('product_option_list_line');
	});
});


/* === row 삭제 === */
function deleteLine(obj) {
	var row = $(obj).parents().parents().parents('.product_option_list');
	var comment = $(obj).parents().parents().parents('.comment_view');

	//라인 삭제
	row.remove();
	row2.remove();
	comment.remove();
}

/* === review 보기 === */
$(function () {
	$( ".review_view_text" ).hide();
	$( ".review_view_title" ).click(function() {
		$(".review_view_text:visible" ).slideUp("middle");
		$(this).next(".review_view_text:hidden" ).slideDown("middle");
		return false;
	})
});

/* === 상품문의 보기 === */
$(function () {
	$( ".qna_view_text" ).hide();
	$( ".qna_view_title" ).click(function() {
		$(".qna_view_text:visible").slideUp("middle");
		$(this).next('.qna_view_text:hidden').slideDown("middle");
		return false;
	})
});

/* === notice === */
$(function () {
	$( ".notice_view_text" ).hide();
	$( ".notice_view_title" ).click(function() {
		$(".notice_view_text:visible").slideUp("middle");
		$(this).next('.notice_view_text:hidden').slideDown("middle");
		return false;
	})
});

/* === 자주묻는 질문 === */
$(function(){
	$(".faq_anwser_view").hide();
	$(".faq_title").click(function(){
		$(".faq_anwser_view:visible").slideUp("middle");
		$(this).next('.faq_anwser_view:hidden').slideDown("middle");
		return false;
	})
});
$(function () {
	$( "div.faq_content" ).hide();
	$( "div.faq_content:first" ).show();

	$("ul.faq_menu li").click(function () {
		$("ul.faq_menu li").removeClass("active");
		$(this).addClass("active");
		$("div.faq_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});
});

/* === 로그인 === */
$(function () {
	$( "div.login_content" ).hide();
	$( "div.login_content:first" ).show();

	$("ul.login_menu li").click(function () {
		$("ul.login_menu li").removeClass("active");
		$(this).addClass("active");
		$("div.login_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});
});

/* === 비밀번호 찾기 === */
 $(document).ready(function() {
	/*$('.auth_email_form').hide();

	$("#pw_auth_select01").change(function() {
	  var checked = $("#goods_option_select01 option:checked").val() ;
	  $(".auth_email_form").hide();
	  $(".auth_id_form").show();
	});
	$("#pw_auth_select02").change(function() {
	  var checked = $("#goods_option_select02 option:checked").val() ;
	  $(".auth_email_form").hide();
	  $(".auth_id_form").show();
	});
	$("#pw_auth_select03").change(function() {
	  var checked = $("#goods_option_select03 option:checked").val() ;
	  $(".auth_email_form").show();
	  $(".auth_id_form").hide();
	});*/
});

/* === 신규배송지 === */
 $(document).ready(function() {
	$('.new_address_form').hide();

	$("#address_select03").change(function() {
	  var checked = $("#address_select03 option:checked").val() ;
	  $(".new_address_form").show();
	});
	$("#address_select01").change(function() {
	  var checked = $("#address_select01 option:checked").val() ;
	  $(".new_address_form").hide();
	});
	$("#address_select02").change(function() {
	  var checked = $("#address_select02 option:checked").val() ;
	  $(".new_address_form").hide();
	});
});

/* === mypage bottom menu === */
$(function () {
	$( ".mypage_smenu" ).hide();
	$(".mypage_menu a").click(function () {
		if($(this).hasClass('active')){
			$(this).parents().next( ".mypage_smenu" ).hide();
			$(this).removeClass('active');

		}else{
			$(this).parents().next( ".mypage_smenu" ).show();
			$(this).addClass('active');
		}
		//$(this).parents().next( ".mypage_smenu" ).slideToggle( "middle");
		//$('html, body').animate({ scrollTop: $(document).height() }, 5000);
	});
});

/* === mypage 주문상세 === */
$(function () {
	$( "div.my_order_content" ).hide();
	$( "div.my_order_content:first" ).show();
	$("ul.my_order_menu li").click(function () {
		$("ul.my_order_menu li").removeClass("active");
		$(this).addClass("active");
		$("div.my_order_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});
});

/* === 회원가입 약관 === */
$(function () {
	$( "div.rules_area" ).hide();
	$(".btn_view_rules").click(function () {
		if($(this).children('span').hasClass('active')){
			$(this).children('span').removeClass('active');
		}else{
			$(this).children('span').addClass('active');}
		$(this).next("div.rules_area").slideToggle('middle')
	});
});


/* popup */
$(document).ready(function() {
	$('.popup_outline').hide();
	$('.popup').hide();

	// 헤더 멤버쉽카드 보기
	$(".btn_view_card").click(function() {
		var _dimed =$('#member_card_popup').find(".dimmed")
        $('.dimmed').css({'overflow': 'hidden', 'height': '100%'}); // 모달팝업 중 html,body의 scroll을 hidden시킴
        $(".dimmed").on('scroll touchmove mousewheel', function(event) { // 터치무브와 마우스휠 스크롤 방지
         event.preventDefault();
         event.stopPropagation();
         return false;
         });

		if(_dimed.length==0) {
            $('#member_card_popup').prepend('<div class="dimmed2"></div>');
            $('#member_card_popup').show();
        }

        $('#btn_close_card').click(function(){
            $('#member_card_popup').hide();
            $('#member_card_popup').find('.dimmed').remove();

            $('.dimmed').css({'overflow': 'auto', 'height': '100%'}); //scroll hidden 해제
            $('.dimmed').off('scroll touchmove mousewheel'); // 터치무브 및 마우스휠 스크롤 가능


        });
	});



	/*$(".btn_go_exchange").click(function() {
		$('.popup').show();
	});*/
	$(".btn_close_popup").click(function() {
		$('.popup_outline, .popup').hide();
		$(body).css('overflow-y', 'auto');
	});
	$(".btn_view_membershipcard").click(function() {
		$('.popup').show();
	});
	$(".btn_view_lens_new").click(function() {
		$('.layer_lens_slide').show();
	});
});


$(function () {
	$( ".site_gnb_list_s" ).hide();
	$(".site_gnb_list > a").click(function () {
		if($(this).hasClass('active')){
			$(this).removeClass('active');
		}else{
			$(this).addClass('active');}
		$(this).parents().next( ".site_gnb_list_s" ).slideToggle( "slow");
	});
});



/* === go to top  버튼 위치변경 === */
$(window).scroll(function(){
	if($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
		$('#toTop').css('position','fixed');
		$('#toTop').css('bottom','370px');
		$('.f_go_top').css('display','none');
	}else{
		$('#toTop').css('position','fixed');
		$('#toTop').css('bottom','60px');
	}
});

$(function () {
	$('.btn_go_prev').off('click').on('click',function(){
		history.back();
	});
});

/* === 카테고리 선택 select box === */
$(function () {
	$('#selCategoryHead').off('change').on('change',function(){
		var ctgNo = $(this).val();
		if(ctgNo!=''){
			move_category(ctgNo);
		}
	});
});
/* === 카테고리 검색조건 select box === */
$(document).ready(function() {
	enableCategorySelectBoxes();
});
function enableCategorySelectBoxes(){
	$('div.list_selectBox').each(function(){
		var $selectedOption = $(this).children('div.selectOptions').children('span.selectOption.selected');
		if($selectedOption == null){
			$selectedOption = $(this).children('div.selectOptions').children('span.selectOption:first');
		}
		$(this).children('span.selected').html($selectedOption.html());
		$(this).attr('value',$selectedOption.attr('value'));

		$(this).off('click').on('click', function(){
			if($(this).parent().children('div.selectOptions').css('display') == 'none'){
				$(this).parent().children('div.selectOptions').css('display','block');
			}
			else
			{
				$(this).parent().children('div.selectOptions').css('display','none');
			}
		});

		$(this).find('span.selectOption').off('click').on('click', function(){
			$(this).parent().css('display','none');
			$(this).closest('div.selectBox').attr('value',$(this).attr('value'));
			$(this).parent().siblings('span.selected').html($(this).html());
		});

		$selectedOption.removeClass('selected');
	});
}

/* datepicker */
$(function () {
	$(".datepicker").datepicker({
		dateFormat: "yy-mm-dd"
	});
});

/* filter_area */
$(function () {
	$( ".filter_row ul.filter_list" ).hide();
	$(".filter_row > a").click(function(e) {
		e.preventDefault();
		var OpenList = $(this).next(".filter_row ul.filter_list");
		$(this).toggleClass("active");
		$(OpenList).stop().slideToggle(300);
		$(".filter_row > a").not(this).removeClass("active");
		$(".filter_row ul.filter_list").not(OpenList).stop().hide();
	});
});

/* 렌즈추천 */
$(document).ready(function() {
	$(".lens_type li").click(function () {
		$(this).toggleClass("active");
		$(".lens_type li").not(this).removeClass("active");
	});
	$(".lens_age li span").click(function() {
		$(this).toggleClass("active");
		$(".lens_age li span").not(this).removeClass("active");
	});

	$(".lens_choice li").click(function() {
		$(this).toggleClass("active");
	});
});
/* 렌즈추천 상품보기 */
$(document).ready(function() {
	$(".result_product_list").hide();
	$(".btn_view_result").click(function() {
		if($(this).html() == '상품닫기' ) {
			$(this).html('상품보기').removeClass('active');
		}
		else {
			$(this).html('상품닫기').addClass('active');
		}
		$(this).parent().next(".result_product_list").slideToggle('200');
	});
	$(".vision_write_area").hide();
	$(".vision_write a").click(function() {
		$(".vision_write_area").slideDown('200');
	});
	$(".btn_vision_cancel, .btn_vision_close").click(function() {
		$(".vision_write_area").slideUp('200');
	});
});
$(function () {
	var LensSlider = $('.lens_slider ul').bxSlider({
		auto: true,
		controls: false,
		speed:400,
		infiniteLoop:true,
		pager:true,
	});
	$(".btn_view_lens_new").click(function() {
		$("#trainings-slide").show();
		LensSlider.reloadSlider();
	});
	$('.btn_lens_list_prev').click(function () {
		var current = LensSlider.getCurrentSlide();
		LensSlider.goToPrevSlide(current) - 1;
	});
	$('.btn_lens_list_next').click(function () {
		var current = LensSlider.getCurrentSlide();
		LensSlider.goToNextSlide(current) + 1;
	});
});

/* swiper */
//$(document).ready(function() {
//	var swiper_1 = new Swiper('.swiper-container', {
//        slidesPerView:4,
//        paginationClickable: true,
//		spaceBetween:0,
//        freeMode: true,
//		pagination: false,
//		speed:1
//    });
//
//	$('.lnb_menu > li > a').on('click', function(){
//		$(this).parent().toggleClass('active');
//	});
//});



/*footer slide 2018-08-28*/
$(document).ready(function() {
/*	$(".toggle-footer").click(function(){
		$("#footer-content").slideToggle();
		//$('#body').css("overflow-y","auto");
        $("html, body").css({'overflow':'visible'}).unbind('touchmove');//브라우져에 터치를 다시 활성화

	});
	$(".toggle-footer").click(function(){
		$(".footer_bg").css('display', 'block');
	});*/
});

function footerCategory() {
	$("#footer-content").slideToggle();
	//$('#body').css("overflow-y","hidden");
    $("html, body").css({overflow:'hidden'}).bind('touchmove');

}

/* lens view slider */
$(function () {
	 $('.lens_view_slider ul.slider').bxSlider({
		mode: 'horizontal',
		auto: false,
		controls: true,
		pager: false
	});
});

/* 이벤트 마마무 */
$(document).ready(function() {
	$('.event_mmm_rule').hide();
	$('.event_mmm_check a.arrow').click(function() {
		$('.event_mmm_rule').slideToggle();
		$(this).toggleClass('active');
	});
})

/* swiper */
$(document).ready(function() {
	var swiper = new Swiper('.best_swiper_slider', {
		slidesPerView: 'auto',
		spaceBetween: 10,
		pagination: {
		el: '.best_swiper_pagination',
		clickable: true,
	},
		navigation: {
		nextEl: '.best_next',
		prevEl: '.best_prev',
	},
	});
});

/* 인기검색어 */
$(document).ready(function() {
	$('.hot_word_view').hide();
	$('.hot_word').click(function() {
		$('.hot_word_view').show();
		$('.hot_word').hide();
	});
	$('.btn_close_hot').click(function() {
		$('.hot_word_view').hide();
		$('.hot_word').show();
	});
});