/*   slider   */
    var carousel;
    var slider;
    $(document).ready(function() {
        var main_visual_slider = $('.main_visual_slider').bxSlider();
        if($('.main_visual_slider').length > 0) {
            var slideQty = main_visual_slider.getSlideCount();
            if(slideQty > 1) {
                main_visual_slider.startAuto();
            }
        }

        var Goodslider = $('.goods_view_slider').bxSlider({
            captions: true,
            controls: false,
            pagerCustom: '#goods_view_s_slider'
        });
		$('.btn_goods_view_prev').click(function () {
			var current = Goodslider.getCurrentSlide();
			Goodslider.goToPrevSlide(current) - 1;
		});
		$('.btn_goods_view_next').click(function () {
			var current = Goodslider.getCurrentSlide();
			Goodslider.goToNextSlide(current) + 1;
		});
	});
   
  /* popup */
	$(document).ready(function() {
		$('.popup01').hide();
		$(".pop_shop_view, .pop_alram, .pop_alert").click(function() {
			$('.popup01').show();
		});
		$(".btn_close_popup").click(function() {
			$('.popup01').hide();
		});

		$('.popup02').hide();
		$(".pop_customer01").click(function() {
			$('.popup02').show();
		});
		$(".btn_close_popup").click(function() {
			$('.popup02').hide();
		});
	});
