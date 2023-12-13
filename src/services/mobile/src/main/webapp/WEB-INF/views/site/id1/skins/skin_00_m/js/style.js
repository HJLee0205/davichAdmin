/*   gnb menu   */
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
			$("#" + activeTab).fadeIn()
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


	/* === popup coupon === */
	$(document).ready(function() {
		/*$("#btn").click(function(){
			$.blockUI({
				message:$('#popup_coupon_select')
				,css:{
					width:     '100%',
					position:  'fixed',
					top:       '50px',
					left:      '0',
				}
				,onOverlayClick: $.unblockUI
			});
		});*/
		$(".closepopup").click(function(){
			$.unblockUI();
		});
	});

	/* === alret agree === */
	$(document).ready(function() {
		/*$("#btn_agree").click(function(){
			 
			$.blockUI({
				message:$('#popup_agress_alert')
				,css:{
					width:     '100%',
					height:    '200px',
					position:  'fixed',
					top:       '50px',
					left:      '0',
				}
				,onOverlayClick: $.unblockUI
			});
		});*/
		$(".closepopup").click(function(){
			$.unblockUI();
		});
	});

	/* === popup post === */
	$(document).ready(function() { 
		/*$(".btn_post").click(function(){
			
		});*/
		$(".closepopup").click(function(){
			$.unblockUI();
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

	/* === search area === */
	$(function () {
		$( "#search_area" ).hide();
		$(".btn_search_view").click(function () {
			$("#search_area").slideToggle( "800");
		});
	}); 

	/* === go to top  버튼 위치변경 === */	
	$(window).scroll(function(){
		if($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
			$('#toTop').css('position','fixed');
			$('#toTop').css('bottom','281px');
			$('.f_go_top').css('display','none');
		}else{
			$('#toTop').css('position','fixed');
			$('#toTop').css('bottom','10px');
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
			move_category(ctgNo);
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
	
	