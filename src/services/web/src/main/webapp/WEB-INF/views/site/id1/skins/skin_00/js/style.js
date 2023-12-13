/*   gnb menu   */
    var carousel;
    var slider;
    $(document).ready(function() {
        $('.gnb_list li').mouseenter(function() {
            var gnbHref = $($(this).find('a').attr('href'));
                $(this).addClass('on').siblings().removeClass('on');
                gnbHref.show();
        }).mouseleave(function() {
            var gnbHref = $($(this).find('a').attr('href'));
                gnbHref.hide();
        });

        var main_visual_slider = $('.main_visual_slider').bxSlider();
        if($('.main_visual_slider').length > 0) {
            var slideQty = main_visual_slider.getSlideCount();
            if(slideQty > 1) {
                main_visual_slider.startAuto();
            }
        }

        carousel = $('#goods_view_s_slider').bxSlider({
            slideWidth: 91,
            minSlides: 2,
            maxSlides: 5,
            moveSlides: 1,
            slideMargin: 10,
            pager: false
        });
        var sliderAlen = $('#goods_view_s_slider a.bx-clone').length;
        if($("#goods_view_s_slider a").length - sliderAlen < 5){
            $("#product_photo .bx-wrapper").css({
                'margin' : '0'
            })
            $("#product_photo .bx-next").hide();
            $("#product_photo .bx-prev").hide();
        }
        slider = $('.goods_view_slider').bxSlider({
            captions: true,
            controls: false,
            pager: false
        });
    });

    //이미지 슬라이더 관련
    function clicked(position) {
        slider.goToSlide(position);
    }
	/*   select box   */
	jQuery(document).ready(function(){
		var select = $("select");
		select.change(function(){
			var select_name = $(this).children("option:selected").text();
			$(this).siblings("label").text(select_name);
		});
	});

	/*   tab   */
	 $(function () {
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function () {
			$("ul.tabs li").removeClass("active").css("color", "#383838");
			$(this).addClass("active").css("color", "#383838");
			$(".tab_content").hide()
			var activeTab = $(this).attr("rel");

			if($(this).attr('id') !== 'closeTab' && $(this).attr('id') !== 'wngTab') {
			    $("#" + activeTab).fadeIn()
			}
		});
	});

	$(function () {
		$(".skin_tab_content").hide();
		$(".skin_tab_content:first").show();

		$("ul.skin_tabs li").click(function () {
			$("ul.skin_tabs li").removeClass("active").css("color", "#383838");
			$(this).addClass("active").css("color", "#383838");
			$(".skin_tab_content").hide()
			var activeTab = $(this).attr("rel");
			$("#" + activeTab).fadeIn()
		});
	});

	$(function () {
		$(".faq_tabs_content").hide();
		$(".faq_tabs_content:first").show();

		$("ul.faq_tabs li").click(function () {
			$("ul.faq_tabs li").removeClass("active").css("color", "#383838");
			$(this).addClass("active").css("color", "#383838");
			$(".faq_tabs_content").hide()
			var activeTab = $(this).attr("rel");
			$("#" + activeTab).fadeIn()
		});
	});


	/* 퀵메뉴 */
	$(document).ready(function() {
		$("#quick_menu").animate( { "top": $(document).scrollTop() + 180 +"px" }, 500 );
		  $(window).scroll(function(){
			$("#quick_menu").stop();
			$("#quick_menu").animate( { "top": $(document).scrollTop() + 180 + "px" }, 1000 );
		});
	});

	/* 배너 */
	$(document).ready(function() {
		$("#banner").animate( { "top": $(document).scrollTop() + 180 +"px" }, 500 );
		  $(window).scroll(function(){
			$("#banner").stop();
			$("#banner").animate( { "top": $(document).scrollTop() + 180 + "px" }, 1000 );
		});
	});

	$( function () {
        var mySlider = $( '.product_list_typeD_slider' ).bxSlider( {
            auto: false,
            slideWidth: 400,
            pager: false,
            maxSlides: 2,
            moveSlides: 2,
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
        } );
        $( '.btn_product_list_pre' ).on( 'click', function () {
            mySlider.goToPrevSlide();
            return false;
        } );
        $( '.btn_product_list_next' ).on( 'click', function () {
            mySlider.goToNextSlide();
            return false;
        } );
    } );

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
		$(".img_menu").hide();
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
	//관련상품
	$(function(){
        var mySlider = $( '#with_item .product_list_typeA' ).bxSlider({
            pager: false,
            slideWidth: 194,
            infiniteLoop: false,
            moveSlides: 1,
            minSlides: 5,      // 최소 노출 개수
            maxSlides: 5,      // 최대 노출 개수
            auto: false
        });

        $( '.btn_with_list_pre' ).on( 'click', function () {
            mySlider.goToPrevSlide();
            return false;
        } );
        $( '.btn_with_list_nex' ).on( 'click', function () {
            mySlider.goToNextSlide();
            return false;
        } );
    })

	//우측 퀵메뉴 스크립트
	$( function () {
	    var quick_mySlider = $( '.quick_view' ).bxSlider( {
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
	        controls: false,    // 이전 다음 버튼 노출 여부
	        infiniteLoop: false,//무한루프여부
	        //hideControlOnEnd: true //마지막으로 갔을때 이동버튼 삭제
	    } );
	    $( '.btn_quick_pre' ).on( 'click', function () {
	        quick_mySlider.goToPrevSlide();
	        return false;
	    } );
	    $( '.btn_quick_next' ).on( 'click', function () {
	        quick_mySlider.goToNextSlide();
	        return false;
	    } );
	});