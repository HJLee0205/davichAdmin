/**
 * 알림/확인 레이어를 출력하기 위한 클래스
 * @type {{alert_title: string, confirm_title: string, desc: string, alert_template: string, confirm_template: string, create: LayerUtil.create, close: LayerUtil.close, alert: LayerUtil.alert, confirm: LayerUtil.confirm}}
 */
Dmall.LayerUtil = {

    alert_title :  '알림',
    confirm_title : '확인',
    left_btn : '취소',
    right_btn : '확인',
    desc : '',
    alert_template : '<div id="div_id_alert" class="alert_body pop_front"><div class="pop_wrap">' +
    '<button type="button" class="btn_alert_close"><img src="/front/img/common/btn_close_popup02.png" alt="팝업창닫기"></button>' +
    '<div class="alert_content"><div class="alert_text">{{msg}}</div>' +
    '<div class="alert_btn_area">' +
    '<button type="button" id="btn_id_alert_yes" class="btn_alert_ok">확인</button>' +
    '</div>' +
    '</div>' +
    '</div></div>',
    confirm_template : '<div id="div_id_confirm" class="alert_body pop_front"><div class="pop_wrap">' +
    '<button type="button" class="btn_alert_close"><img src="/front/img/common/btn_close_popup02.png" alt="팝업창닫기"></button>' +
    '<div class="alert_content"><div class="alert_text">{{msg}}</div>' +
    '<div class="alert_btn_area">' +
    '<button type="button" id="btn_id_confirm_no" class="btn_alert_cancel">{{left_btn}}</button>' +
    '<button type="button" id="btn_id_confirm_yes" class="btn_alert_ok">{{right_btn}}</button> ' +
    '</div>' +
    '</div>' +
    '</div></div>',

    /**
     * <pre>
     * 함수명 : create
     * 설  명 : LayerUtil 에서 내부적으로 호출하는 레이어 생성 함수
     * 사용법 : LayerUtil.create()
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     * @param $layer 팝업 jQuery 객체
     */
    create : function($layer) {
        jQuery('body').append($layer);

        var left = ( $(window).scrollLeft() + ($(window).width() - $layer.width()) / 2 ),
            top = ( $(window).scrollTop() + ($(window).height() - $layer.height()) / 2 ),
            dimmed = jQuery('.dimmed').length > 0 ? true : false;
        $layer.fadeIn();
        $layer.css({top: top, left: left});

        if(dimmed) {
            $layer.prepend('<div class="dimmed2"></div>');
            $layer.css('z-index', 9999)
                .find('.pop_wrap').css('z-index', 9999);
        } else {
            $layer.prepend('<div class="dimmed2"></div>');
        }
        //$('body').css('overflow-y','hidden').bind('touchmove', function(e) {e.preventDefault()});
        // $layer.find('.btn_alert_close').on('click', function() {
        //     Dmall.LayerUtil.close($layer.prop('id'));
        // });
    },

    /**
     * <pre>
     * 함수명 : close
     * 설  명 : LayerUtil 에서 내부적으로 호출하는 레이어 제거 함수
     * 사용법 : LayerUtil.create()
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     * @param id 팝업 레이어 id(레이어 위에 레이어인 경우만 입력)
     */
    close : function(id) {
        var $body = $('body'),
            dimmed2 = jQuery('div.dimmed2').length > 0 ? true : false;
        if(id) {
            var $layer = $('#' + id);
            $layer.fadeOut().remove();
        } else {
            $body.find('.alert_body').fadeOut().remove();
        }

        $("html, body").css({'overflow':'visible'}).unbind('touchmove');//브라우져에 터치를 다시 활성화
    },

    /**
     * window.alert에 해당하는 함수
     * @param msg 출력할 메시지(필수)
     * @param title 레이어의 제목
     * @param desc 제목 옆에 조금 작게 들어가는 부연 설명
     */
    alert : function(msg, title, desc) {
        var title = title || Dmall.LayerUtil.alert_title,
            desc = desc || Dmall.LayerUtil.desc,
            template = new Dmall.Template(Dmall.LayerUtil.alert_template, {title: title, msg: msg, desc: desc}),
            html = template.render(),
            dfrd = new $.Deferred();

        if(jQuery('#div_id_alert').length > 0) {
            return false;
        }

        Dmall.LayerUtil.create(jQuery(html));

        jQuery('#btn_id_alert_yes, .alert_body button.btn_alert_close').on('click', function() {
            Dmall.LayerUtil.close('div_id_alert');
            dfrd.resolve();
        }).focus();

        return dfrd.promise();
    },

    /**
     * window.confirm에 해당하는 함수
     *
     *
     * @param msg 출력할 메시지(필수)
     * @param yesFunc 확인 버튼 클릭시 실행할 함수명
     * @param noFunc 취소 버튼 클릭시 실행할 함수명
     * @param title 레이어의 제목
     * @param desc 제목 옆에 조금 작게 들어가는 부연 설명
     */
    confirm : function(msg, yesFunc, noFunc, title, desc, left_btn, right_btn) {
        var function1 = yesFunc || function(){},
            funciton2 = noFunc || Dmall.LayerUtil.close,
            title = title || Dmall.LayerUtil.confirm_title,
            desc = desc || Dmall.LayerUtil.desc,
            left_btn = left_btn || Dmall.LayerUtil.left_btn,
            right_btn = right_btn || Dmall.LayerUtil.right_btn,
            template = new Dmall.Template(Dmall.LayerUtil.confirm_template, {title: title, msg: msg, desc: desc, left_btn: left_btn, right_btn: right_btn}),
            html = template.render();

        if(jQuery('#div_id_confirm').length > 0) {
            return false;
        }

        Dmall.LayerUtil.create(jQuery(html));

        $('#btn_id_confirm_yes').on('click', function() {function1(); Dmall.LayerUtil.close('div_id_confirm')});
        $('#btn_id_confirm_no, .alert_body button.btn_alert_close').on('click', function() {funciton2(); Dmall.LayerUtil.close('div_id_confirm')});
    }
};

/**
 * 레이어 팝업 클래스
 * 우편번호 스크립트만 있어 우변번호 유틸로 변경하거나, 다른 레이어 팝업이 많아지면 파일을 분리할 수 있음
 */
Dmall.LayerPopupUtil = {
    /**
     * <pre>
     * 함수명 : open
     * 설  명 : 문서의 영역을 레이어 팝업으로 생성하는 함수
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * </pre>
     * @param $popup
     */
    open : function($popup) {
        if(!$popup.hasClass('layer_popup')) {
            $popup.addClass('layer_popup')
                .children().wrapAll('<div class="pop_wrap"></div>');
        }
        
        var left = ( $(window).scrollLeft() + ($(window).width() - $popup.width()) / 2 ),
            top = ( $(window).scrollTop() + ($(window).height() - $popup.height()) / 2 ),
            dimmed = jQuery('.dimmed').length > 0 ? true : false;
        $popup.fadeIn();
        $popup.css({top: top, left: left});
        if(dimmed) {
            $popup.prepend('<div class="dimmed2"></div>');
            $popup.css('z-index', 9999)
                .find('.pop_wrap').css('z-index', 9999);
        } else {
            $popup.prepend('<div class="dimmed2"></div>');
        }
        $('body').css('overflow-y','hidden').bind('touchmove', function(e){e.preventDefault()});
        $popup.find('.btn_close_popup').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtil.close();
            }
        });
        $popup.find('.btn_popup_cancel').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtil.close();
            }
        });
        $popup.find('.btn_review_cancel').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtil.close();
            }
        });
    },

    open1 : function($popup) {
        if(!$popup.hasClass('layer_popup')) {
            $popup.addClass('layer_popup')
                .children().wrapAll('<div class="pop_wrap"></div>');
        }
        $popup.fadeIn();

        /*var dimmed = jQuery('.dimmed').length > 0 ? true : false;
        //$popup.css({top: top, left: left});
        if(dimmed) {
            $popup.prepend('<div class="dimmed2"></div>');
            $popup.css('z-index', 120)
                .find('.pop_wrap').css('z-index', 120);
        } else {
            $popup.prepend('<div class="dimmed"></div>');
        }*/
        //$('body').css('overflow-y','hidden').bind('touchmove', function(e){e.preventDefault()});
        $popup.find('.btn_close_popup').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtil.close();
            }
        });
        $popup.find('.btn_popup_cancel').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtil.close();
            }
        });
    },

    /**
     * <pre>
     * 함수명 : close
     * 설  명 : LayerPopupUtil 내부에서 호출하는 레이어 팝업 숨김 함수
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    close : function(id) {
        var $body = $('body'),
            $popup = $body,
            dimmed2 = jQuery('div.dimmed2').length > 0 ? true : false;

        if(id) {
            $popup = $('#' + id);
            $popup.fadeOut();
        } else {
            $body.find('.layer_popup').fadeOut();
        }

        if(dimmed2) {
            $popup.find('.dimmed2').remove();
        } else {
            $popup.find('.dimmed').remove();
        }

        $body.css('overflow-y','scroll').unbind('touchmove');
    },
    /**
     * <pre>
     * 함수명 : zipcode
     * 설  명 : 다음맵 우편번호API를 이용하는 팝업 생성
     * 사용법 : LayerPopupUtil.zipcode(callback)
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     * @param callback
     */
    zipcode :function(callback) {
        var template = '<div class="popup_address pop_front" id="popup_address">' +
                '<div class="popup_header">' +
                '<h1 class="popup_tit">주소찾기</h1>' +
                '<button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>' +
                '</div>' +
                '<div class="pop_con post">' +
                '<div id="layer_id_postList" style="overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;padding: 0;">' +
                '</div>' +
                '</div>' +
                '</div>',
            elementLayer,
            width = 394, //우편번호서비스가 들어갈 element의 width
            height = 490, //우편번호서비스가 들어갈 element의 height
            borderWidth = 0; //샘플에서 사용하는 border의 두께

        if(jQuery('#popup_address').length === 0) {
            jQuery('body').append(jQuery(template));
        }

        elementLayer = document.getElementById('layer_id_postList');
        Dmall.LayerPopupUtil.open(jQuery('#popup_address'));

        new daum.Postcode({
            oncomplete: function(data) {
                /** ====================================================================================
                 * http://postcode.map.daum.net/guide 참조
                 * zonecode : 우편번호
                 * address : 기본주소
                 * addressEnglish : 기본 영문 주소
                 * roadAddress : 도로명 주소
                 * roadAddressEnglish : 영문 도로명 주소
                 * jibunAddress : 지번 주소
                 * jibunAddressEnglish : 영문 지번 주소
                 * postcode : 구 우편번호
                 * ==================================================================================== */
                callback(data);
                // 레이어 팝업 닫기
                Dmall.LayerPopupUtil.close("popup_address");
            },
            width : '100%',
            height : '100%'
        }).embed(elementLayer);

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        elementLayer.style.width = width + 'px';
        elementLayer.style.height = height + 'px';
        elementLayer.style.border = borderWidth + 'px solid';
    }
};