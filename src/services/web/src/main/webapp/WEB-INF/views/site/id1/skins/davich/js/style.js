/*   gnb menu   */
    var carousel;
    var slider;
    $(document).ready(function() {
        var main_visual_slider = $('.main_visual_slider').bxSlider({
            pause: 4000,
            touchEnabled: false,
			onSliderLoad: function(){ 
				$("#main_visual").css("visibility", "visible").animate({opacity:1});
			}

        });
        if($('.main_visual_slider').length > 0) {
            var slideQty = main_visual_slider.getSlideCount();
            if(slideQty > 1) {
                main_visual_slider.startAuto();
            }
        }

        var Goodslider = $('.goods_view_slider').bxSlider({
            captions: true,
            controls: false,
            pagerCustom: '#goods_view_s_slider',
            maxSlides:1,
            minSlides:1,
            auto:false,
            infiniteLoop: false,
            touchEnabled: false

        });
		$('.btn_goods_view_prev').click(function () {
			var current = Goodslider.getCurrentSlide();
			Goodslider.goToPrevSlide(current) - 1;
		});
		$('.btn_goods_view_next').click(function () {
			var current = Goodslider.getCurrentSlide();
			Goodslider.goToNextSlide(current) + 1;
		});
		
		var Magazinemslider = $('.dzine_banner_area ul' ).bxSlider({
			controls: false,
			pager: false,
			auto:true,
	        pause: 4000,
	        touchEnabled: false
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


	/*   main best of best slider   */
	$(function () {
       $('.BB_slider').bxSlider({
            auto: false,
			controls: false,
			pagerCustom: '.main_mid_tab',
			touchEnabled: false
		});
		 var BBannerslider = $('.BB_list_banner > ul').bxSlider({
			mode: 'horizontal',
            auto: false,
			controls: false,
			pager: false,
		});
		$('.btn_BB_list_prev').click(function () {
			var current = BBannerslider.getCurrentSlide();
			BBannerslider.goToPrevSlide(current) - 1;
		});
		$('.btn_BB_list_next').click(function () {
			var current = BBannerslider.getCurrentSlide();
			BBannerslider.goToNextSlide(current) + 1;
		});
	});

	/*   sub visual slider   */
	$(function () {
       var subslider = $('.sub_visual_slider').bxSlider({
            auto: false,
			controls: false,
			pager: true,
			touchEnabled: false
		});
		$('.btn_sub_slider_prev').click(function () {
			var current = subslider.getCurrentSlide();
			subslider.goToPrevSlide(current) - 1;
		});
		$('.btn_sub_slider_next').click(function () {
			var current = subslider.getCurrentSlide();
			subslider.goToNextSlide(current) + 1;
		});
	});

	/* 전체 메뉴 */
	 $(document).ready(function() {
		 $('#gnb').find('.layer_2depth').each(function(){
			var height = $(this).find('.gnb_box.left').height() + 20;
			$(this).css('height',height);
		 });
		 
		$(".layer_all").css('visibility','hidden');
		$(".layer_2depth").css('visibility','hidden');
		$('.gnb_menu').hover(function() {
			 $(this).addClass('active');
			 var activeLayer = $(this).attr("rel");
			 //$("." + activeLayer).slideDown('50');
			 $("." + activeLayer).css('visibility','visible');
			 $(".layer_2depth").not("." + activeLayer).css('visibility','hidden');	
			 $(".layer_all").not("." + activeLayer).css('visibility','hidden');	
			 $(".gnb_menu").not(this).removeClass('active');	
			 var inner_width = $('.'+activeLayer).find('.gnb_box_inner').css('width');
			 $('.'+activeLayer).find('.depth04_btm_hot').css('width',inner_width);
		}, function() {
			 var activeLayer = $(this).attr("rel");
			 $(".layer_2depth").not("." + activeLayer).css('visibility','hidden');	
			 $(".gnb_menu").not(this).removeClass('active');	
		});

		$('#header').hover(function() {
			 $('.layer_all').css('visibility','hidden');
			 $('.layer_2depth').css('visibility','hidden');
			 $(".gnb_menu").removeClass('active');
		});

		$(".layer_all, .layer_2depth").mouseleave(function() {
		   $('.layer_all').css('visibility','hidden');
		   $('.layer_2depth').css('visibility','hidden');
		   $(".gnb_menu").removeClass('active');
		});
	});

	/*   tab   */
	 $(function () {
		$(".tab_content").hide();
		$(".tab_content:first").show();
		$("ul.tabs li").click(function () {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide()
			var activeTab = $(this).attr("rel");

			if($(this).attr('id') !== 'closeTab' && $(this).attr('id') !== 'wngTab') {
			    $("#" + activeTab).fadeIn()
			}

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

		$(".skin_tab_content").hide();
		$(".skin_tab_content:first").show();
		$("ul.skin_tabs li").click(function () {
			$("ul.skin_tabs li").removeClass("active");
			$(this).addClass("active");
			$(".skin_tab_content").hide()
			var activeTab = $(this).attr("rel");
			$("#" + activeTab).fadeIn()
            window.location.href = "#product_bottom";
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

		$(".com_tab_content").hide();
		$(".com_tab_content:first").show();
		$("ul.com_tabs li span").click(function () {
			$("ul.com_tabs li span").removeClass("active");
			$(this).addClass("active");
			$(".com_tab_content").hide()
			var activeTab = $(this).attr("rel");
			$("#" + activeTab).fadeIn()
		});
	});

	//관련상품
	$(function(){
		var withSliderLeft = $( '#with_item .left .product_list_typeA.leftslider' ).bxSlider({
			pager: false,
			slideWidth: 187,
			infiniteLoop: true,
			moveSlides: 1,
			minSlides: 3,      // 최소 노출 개수
			maxSlides: 3,      // 최대 노출 개수
			auto: false,
			speed: 120,
			touchEnabled: false
		});
		$('.left .btn_with_list_prev').click(function () {
			var current = withSliderLeft.getCurrentSlide();
			withSliderLeft.goToPrevSlide(current) - 1;
		});
		$('.left .btn_with_list_next').click(function () {
			var current = withSliderLeft.getCurrentSlide();
			withSliderLeft.goToNextSlide(current) + 1;
		});
	});

	//비슷한 상품
	$(function(){
		var withSliderRight = $( '#with_item .right .product_list_typeA.rightslider' ).bxSlider({
			pager: false,
			slideWidth: 187,
			infiniteLoop: true,
			moveSlides: 1,
			minSlides: 3,      // 최소 노출 개수
			maxSlides: 3,      // 최대 노출 개수
			auto: false,
			speed: 120,
			touchEnabled: false
		});
		$('.right .btn_with_list_prev').click(function () {
			var current = withSliderRight.getCurrentSlide();
			withSliderRight.goToPrevSlide(current) - 1;
		});
		$('.right .btn_with_list_next').click(function () {
			var current = withSliderRight.getCurrentSlide();
			withSliderRight.goToNextSlide(current) + 1;
		});
	});



	//브랜드 관
	$(function(){
		var BsetAreaSlider = $( '.brand_area .product_bb' ).bxSlider({
			pager: false,
			slideWidth: 285,
			infiniteLoop: true,
			moveSlides: 1,
			minSlides: 4,      // 최소 노출 개수
			maxSlides: 4,      // 최대 노출 개수
			auto: false,
			touchEnabled: false
		});
		$('.brand_area .btn_product_bb_prev').click(function () {
			var current = BsetAreaSlider.getCurrentSlide();
			BsetAreaSlider.goToPrevSlide(current) - 1;
		});
		$('.brand_area .btn_product_bb_next').click(function () {
			var current = BsetAreaSlider.getCurrentSlide();
			BsetAreaSlider.goToNextSlide(current) + 1;
		});
	});

	/* 퀵메뉴 */
	$(document).ready(function() {
		
		//고해상도
		if ($("#quick_menu").height() > $(window).height()) {
			$("#quick_menu").animate( { "top": $(document).scrollTop() +"px" }, 500 );
			
			$(window).scroll(function(){
				$("#quick_menu").stop();
				
				var scrollHeight = Math.floor($(document).height());
				var scrollPosition = Math.floor($(window).height() + $(window).scrollTop());
				
				if ((scrollHeight - scrollPosition) / scrollHeight === 0) {
					$("#quick_menu").animate( { "top": $(document).scrollTop() - ($("#quick_menu").height() - $(window).height() + 1)  + "px" }, 1000 );
				}else{
					$("#quick_menu").animate( { "top": $(document).scrollTop() +"px" }, 1000 );
				}
			});
		//저해상도	
		}else{
			$("#quick_menu").animate( { "top": $(document).scrollTop() + (($(window).height() - $("#quick_menu").height()) / 2) +"px" }, 500 );
			
			$(window).scroll(function(){
				$("#quick_menu").stop();
				
				var scrollHeight = Math.floor($(document).height());
				var scrollPosition = Math.floor($(window).height() + $(window).scrollTop());
				
				$("#quick_menu").animate( { "top": $(document).scrollTop() + (($(window).height() - $("#quick_menu").height()) / 2) +"px" }, 1000 );
			});
			
		}
		
	});

	/* 배너 */
	$(document).ready(function() {
		$("#banner").animate( { "top": $(document).scrollTop() + 180 +"px" }, 500 );
		  $(window).scroll(function(){
			$("#banner").stop();
			$("#banner").animate( { "top": $(document).scrollTop() + 180 + "px" }, 1000 );
		});
	});

	/* 자주묻는 질문 */
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
			$(".my_qna_table02 .title").click(function() {
				var myArticle02 =$(this).next("tr");
				if($(myArticle02).hasClass('hide')) {
					$(article02).removeClass('show').addClass('hide');
					$(myArticle02).removeClass('hide').addClass('show');
				}
				else {
					$(myArticle02).addClass('hide').removeClass('show');
				}
			});
			$(".my_qna_table02 .title").click(function() {
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

	/* 상품이미지 메뉴 */
	 $(document).ready(function() {
		$(".img_menu").hide();
		$(".goods_image_area").mouseover(function() {
		  $(this).children('.img_menu').stop().fadeIn('slow');
		});
		$(".goods_image_area").mouseleave(function() {
		  $(this).children('.img_menu').stop().fadeOut();
		});
		$("ul.product_list_typeB > li, ul.product_list_typeList > li").mouseover(function() {
			var img = $(this).find('.img_area2').find('img').data().img;
			if(img != null && img != ''){
				$(this).find('.img_area').hide();
				$(this).find('.img_area2').stop().fadeIn('slow');
			}
		});
		$("ul.product_list_typeB > li, ul.product_list_typeList > li").mouseleave(function() {
			var img = $(this).find('.img_area2').find('img').data().img;
			if(img != null && img != ''){
				$(this).find('.img_area').stop().fadeIn('slow');
				$(this).find('.img_area2').hide();
			}
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
	});


    $(document).ready(function() {
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
		$('.radio_chack_a').on('click', function(){
			$('tr.radio_con_a').show();
			$('tr.radio_con_b').hide();
		})
		$('.radio_chack_b').on('click', function(){
			$('tr.radio_con_b').show();
			$('tr.radio_con_a').hide();
		})
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

	//우측 퀵메뉴 스크립트
	$( function () {
	    /*var quick_mySlider = $( '.quick_view' ).bxSlider( {
	        mode: 'vertical',// 가로  방향 수평 슬라이드
	        speed: 500,        // 이동 속도를 설정
	        pager: false,      // 현재 위치 페이징 표시 여부 설정
	        moveSlides: 1,     // 슬라이드 이동시 개수
	        slideWidth: 81,   // 슬라이드 너비
	        minSlides: 3,      // 최소 노출 개수 
	        maxSlides: 3,      // 최대 노출 개수
	        slideMargin: 5,    // 슬라이드간의 간격
	        auto: false,        // 자동 실행 여부
	        autoHover: true,   // 마우스 호버시 정지 여부
	        controls: false,    // 이전 다음 버튼 노출 여부
	        infiniteLoop: false,//무한루프여부
	        //hideControlOnEnd: true //마지막으로 갔을때 이동버튼 삭제
	    } );
	    $('.btn_quick_prev').click(function () {
			var current = quick_mySlider.getCurrentSlide();
           /!* current = current-1;

            if(current<=1){
                current=Number($("#latelyTotcnt").text());
            }else{
                current = (current)-1;
            }
            *!/
            $(this).parents(".btn_quick_area").find("em").html(current+1);
            quick_mySlider.goToPrevSlide(current) - 1;
		});
		$('.btn_quick_next').click(function () {
			var current = quick_mySlider.getCurrentSlide();
            var curTxt =1;
            /!*current = current+1;

            if(current==Number($("#latelyTotcnt").text())){
                current = 0;
            }else{
                current=current+1;
            }
            *!/

            quick_mySlider.goToNextSlide(current) + 1;
             curTxt +=current+1;
            $(this).parents(".btn_quick_area").find("em").html(curTxt);
		});	
		
		$(".quick_view li").hover(function() {
			var quickName = $(this).attr("rel");
			$("#" + quickName).show();
			$(this).children().children(".btn_del_quick").show();
			
			var obj = $(this).position();
			console.log("top: " + obj.top + "px");
			$("#" + quickName).css("top", obj.top);	
		});
		$(".quick_view li").mouseleave(function() {
			var quickName = $(this).attr("rel");
			$("#" + quickName).hide();
			$(".btn_del_quick").hide();
		});*/
	});

	/* === fileup === */
/*
    $(document).ready(function(){
      var fileTarget = $('.filebox .upload-hidden');
      fileTarget.on('change', function(){
        if(window.FileReader){  // modern browser
          var filename = $(this)[0].files[0].name;
        }
        else {  // old IE
          var filename = $(this).val().split('/').pop().split('\\').pop();
        }

        $(this).siblings('.upload-name').val(filename);
      });
	});
*/
	/* category */
	 $(document).ready(function() {
		$(".category_2depth").hide();
		$(".category_3depth").hide();
		$(".category_4depth").hide();
		$(".btn_category_2depth").click(function() {
		  $('.category_2depth').slideDown('10');
		});
		$(".btn_category_3depth").click(function() {
		  $('.category_3depth').slideDown('10');
		});
		$(".btn_category_4depth").click(function() {
		  $('.category_4depth').slideDown('10');
		});

		$(".category_2depth").mouseleave(function() {
		   $(this).slideUp('slow');
		});
		$(".category_3depth").mouseleave(function() {
		   $(this).slideUp('slow');
		});
		$(".category_4depth").mouseleave(function() {
		   $(this).slideUp('slow');
		});
	});

	/* 공유하기 */
	 $(document).ready(function() {
		$(".layer_share").hide();
		$(".btn_share").click(function() {
			$('.layer_share').show();
		});
		$(".btn_close_share").click(function() {
			$('.layer_share').hide();
		});
	});

	/* 좋아요 */
	$(document).ready(function() {
		$(".btn_favorite_go").click(function() {
			$(this).toggleClass("active");
		});

		$(".btn_cart_favorite").click(function() {
			$(this).toggleClass("active");
		});
	});

	/* 목록선택 */
	$(document).ready(function() {
		$(".btn_img_type").click(function() {
			$(this).toggleClass("active");
			$(".btn_list_type").toggleClass("active");
		});
		$(".btn_list_type").click(function() {
			$(this).toggleClass("active");
			$(".btn_img_type").toggleClass("active");
		});
	});

	/* 카테고리 베스트 */
	$(document).ready(function() {
		/*$(".btn_count_open").hide();
		$(".btn_count_close").click(function() {
			$(this).hide();
			$(".category_bb").slideUp("100");
			$(".btn_count_open").show();
		});

		$(".btn_count_open").click(function() {
			$(this).hide();
			$(".category_bb").slideDown("100");
			$(".btn_count_close").show();
		});*/
	});

	/* 필터 상세 */
	$(document).ready(function() {
		$(".filter_detail_area").hide();
		$(".btn_view_filter").click(function() {
			$(this).toggleClass("active");
			$(".filter_detail_area").slideToggle("100");
		});
	});

	/* 사진 크게보기 */
	$(document).ready(function() {
		$(".layer_preview").hide();
		$(".btn_preview").click(function() {
			$(".layer_preview").show();
		});
		$(".btn_close_preview").click(function() {
			$(".layer_preview").hide();
		});

		var PrevSlider = $( '.layer_preview .goods_preview_slider' ).bxSlider({
			pager: false,
			infiniteLoop: true,
			auto: false,
			touchEnabled: false
		});
		$('.layer_preview .btn_goods_preview_prev').click(function () {
			var current = PrevSlider.getCurrentSlide();
			PrevSlider.goToPrevSlide(current) - 1;
		});
		$('.layer_preview .btn_goods_preview_next').click(function () {
			var current = PrevSlider.getCurrentSlide();
			PrevSlider.goToNextSlide(current) + 1;
		});
	});


	/*  === 상품상세 탭메뉴 고정 === */
	var currentScrollTop = 0;
	window.onload = function() {
		scrollController();
		$(window).on('scroll', function() {
			scrollController();
		});
	}
	function scrollController() {
		currentScrollTop = $(window).scrollTop();
		if (currentScrollTop < 1425) {
			$('.skin_tabs').css('top', 1425 - (currentScrollTop));
			if ($('.skin_tabs').hasClass('fixed')) {
				$('.skin_tabs').removeClass('fixed');
			}
		} else {
			if (!$('.skin_tabs').hasClass('fixed')) {
				$('.skin_tabs').css('top', 0);
				$('.skin_tabs').addClass('fixed');
			}
		}
	}
	function scrollController() {
		currentScrollTop = $(window).scrollTop();
		if (currentScrollTop < 330) {
			$('.brand_category').css('top', 330 - (currentScrollTop));
			if ($('.brand_category').hasClass('fixed')) {
				$('.brand_category').removeClass('fixed');
			}
		} else {
			if (!$('.brand_category').hasClass('fixed')) {
				$('.brand_category').css('top', 0);
				$('.brand_category').addClass('fixed');
			}
		}
	}

	/* 브랜드명 선택 */
	$(document).ready(function() {
		$(".brand_name.eng").hide();
		$(".btn_kor").hide();
		$(".btn_eng").click(function() {
			$(".brand_name.eng, .btn_kor").show();
			$(".brand_name.kor, .btn_eng").hide();
		});
		$(".btn_kor").click(function() {
			$(".brand_name.eng, .btn_kor").hide();
			$(".brand_name.kor, .btn_eng").show();
		});
	});

	/* 주문상세보기 */
	$(document).ready(function() {
		$(".btn_cart_view").click(function() {
			$(this).toggleClass("active");
			$(this).parents().next(".layer_view_detail").toggleClass("active");
		});
	});

	/* datepicker */
	$(function () {
		$(".datepicker").datepicker({
			dateFormat: "yy-mm-dd"
		});
	});

	/* popup */
	$(document).ready(function() {
		$('.popup').hide();
		/*$(".btn_cash_bill").click(function() {
			$('.popup').show();
		});*/
		$(".btn_close_popup, .btn_close_popup02, .layer_lens_datil").click(function() {
			$('.popup').hide();
			$('body').css('overflow-y', 'auto');
		});

		/*$(".btn_cancel_view").click(function() {
			$('.popup').show();
		});*/

		$(".btn_go_exchange").click(function() {
			$('.popup').show();
		});

		$(".btn_presc_registration").click(function() {
			$('.popup').show();
		});

		/*$(".btn_view_card").click(function() {
			$('.popup').show();
		});*/

		$(".btn_view_winner").click(function() {
			$('.popup').show();
		});
		/*$(".btn_coupon_product").click(function() {
			$('.popup').show();
		});*/
		$(".pop_view_shop").click(function() {
			$('.popup').show();
		});
		/*$(".btn_exchage_off").click(function() {
			$('.popup').show();
		});*/

		//개발적용후 주석처리
		/*$(".btn_view_lens").hover(function() {
			$('.layer_lens_datil').show();
		});
		$(".btn_view_lens").mouseleave(function() {
			$('.layer_lens_datil').hide();
		});*/
		//
		$(".btn_view_lens_new").click(function() {
			$('.layer_lens_slide').show();
		});
		$('.btn_alert_close').click(function(){
			Dmall.LayerPopupUtil.close('success_basket');
		});
	});

	/* 매장찾기 팝업2 2018-07-23 */
	$(document).ready(function() {
		$('.popup02').hide();
		$(".pop_view_shop02").click(function() { //매장선택 팝업2 2018-07-23
			$('.popup02').show();
		});
		$(".btn_close_popup, .btn_close_popup02").click(function() {
			$('.popup02').hide();
		});
	});
	/* 렌즈추천 */
	$(document).ready(function() {
		/*$(".lens_type li").click(function () {
			$(this).toggleClass("active");
			$(".lens_type li").not(this).removeClass("active");
		});
		$(".lens_age li span").click(function() {
			$(this).toggleClass("active");
			$(".lens_age li span").not(this).removeClass("active");
		});*/

		$(".lens_choice li").click(function() {
			$(this).toggleClass("active");
		});

		var fileTarget = $('.family_site');
		  fileTarget.on('change', function(){
			 var value= $(this).val();
			window.open(value,'_blank');
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
		$(".vision_write img").click(function() {
			$(".vision_write_area").slideDown('200');
		});
		$(".btn_vision_cancel, .btn_vision_close").click(function() {
			$(".vision_write_area").slideUp('200');
		});
    });

	/* 헤드 영역 배너 */
	$(document).ready(function() {
		$(".btn_close_tbanner").click(function () {
			//탑배너를 닫을때 인스턴트 쿠키 세팅(브라우저 종료시 쿠키 지워짐)
			setInstantCookie("tbanner","close");
			$(".head_banner_area").slideUp('fast');
		});
	});

	/* 검색 */
	$(document).ready(function() {
		$(".search_filter.option").hide();

		$('.btn_view_filter').click(function() {
			$(this).addClass('active');
			$('.search_filter.option').slideDown('fast');
		});
		$('.btn_option_close').click(function() {
			$('.btn_view_filter').removeClass("active");
			$('.search_filter.option').slideUp('80');
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
	
	/* 인기검색어 */
	$(document).ready(function() {
		$('.hot_word_view').hide();
		$('.hot_word a, .btn_hot_word').hover(function() { 
			$('.hot_word_view').show();
		});
		$('.hot_word_view').mouseleave(function() { 
			$('.hot_word_view').hide();
		});
		$('.hot_word_view').hover(function() { 
			$('.layer_2depth').hide();
		});
	});
