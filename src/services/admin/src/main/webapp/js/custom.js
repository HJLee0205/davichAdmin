'use strict';

/**
 * 각종 초기화 및 함수 추가/재정의
 */

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.df = function(len){return "0".string(len - this.length) + this;};
Number.prototype.df = function(len){return this.toString().df(len);};

String.prototype.isEmpty = function() {
    return this.length < 1 ? !0 : !1
}, String.prototype.replaceAll = function(a, b) {
    return this.replace(new RegExp(a, "gm"), b)
}, String.prototype.getFunction = function() {
    if (this.length < 1) return null;
    for (var a = window, b = this.split("."), c = b.length, d = 0; c - 1 > d; d++)
        if (a = a[b[d]], void 0 == a) return null;
    return a[b[b.length - 1]]
}, String.prototype.getCommaNumber = function() {
    var a = this + "";
    a = a.replace(/[^\+\-0-9]/g, "");
    var b = /(^[+-]?\d+)(\d{3})/;
    while (b.test(a)) a = a.replace(b, "$1,$2");
    return a
}, Number.prototype.getCommaNumber = function() {
    var a = this + "";
    return a.getCommaNumber()
};

var prev;
Dmall = Dmall || {};

/**
 * <pre>
 * 함수명 : format
 * 설  명 : Date 객체에 format 함수 추가 정의
 * 사용법 : new Date().format('yyyy-mm-dd')
 * 작성일 : 2016. 4. 28.
 * 작성자 : minjae
 * 수정내역(수정일 수정자 - 수정내용)
 * -------------------------------------
 * 2016. 4. 28. minjae - 최초 생성
 * </pre>
 * @param f 출력할 포멧 문자열
 * @return {String} Date 객체의 데이터가 포메팅된 문자열
 */
Date.prototype.format = function(f) {
    if (!this.valueOf()) return "";
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this,
    h;
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).df(2);
            case "MM": return (d.getMonth() + 1).df(2);
            case "dd": return d.getDate().df(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().df(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).df(2);
            case "mm": return d.getMinutes().df(2);
            case "ss": return d.getSeconds().df(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};
/**
 * <pre>
 * 함수명 : trim
 * 설  명 : String 객체에 trim 함수 추가 정의
 * 사용법 : "가나다라 ".trim()
 * 작성일 : 2016. 4. 28.
 * 작성자 : minjae
 * 수정내역(수정일 수정자 - 수정내용)
 * -------------------------------------
 * 2016. 4. 28. minjae - 최초 생성
 * </pre>
 * @param str
 * @returns {string} 앞뒤 공백이 제거된 문자열
 */
String.prototype.trim = function(str) {
    str = this != window ? this : str;
    return str.replace(/^\s+/g,'').replace(/\s+$/g,'');
};

/**
 * jQuery AJAX 초기 설정
 */
//jQuery.ajaxSetup({
//fail: function(xhr,st,err) {
// if (xhr.status == 403) {
//     LayerUtil.confirm('로그인 정보가 없거나 유효시간이 지났습니다.<br/>로그인페이지로 이동하시겠습니까?',
//         function() {
//             document.location.href = '/admin/login/member-login';
//         });
// } else {
//     if(xhr.responseJSON && xhr.responseJSON.message) {
//         LayerUtil.alert(xhr.responseJSON.message);
//     } else {
//         LayerUtil.alert("처리중 오류가 발생했습니다. 관리자에게 문의하십시오.");
//     }
// }
// return xhr.responseJSON;
// },
// always: function() {
// waiting.stop();
// }
//});

jQuery(document).ready(function() {
    /**
     * CSRF 공격 방지 설정 및 jQuery ajax 초기화
     */
    Dmall.init.ajax();
    jQuery('#id_a_webftp').on('click', function(e) {
        Dmall.EventUtil.stopAnchorAction(e);
        window.open(this.href, 'webftp', 'width=1280,height=720');
    });
});

/**
 * 간단한 템플릿을 구현하기 위한 클래스
 * template 에 Map 형태인 obj의 데이터를 매핑
 * obj 의 KEY에 해당하는 템플릿의 {{KEY}} 문자열이 obj의 VALUE로 치환됨
 *
 * @param template 템플릿 문자열 ex) <span>{{name}}</span>
 * @param obj map 형태의 데이터 객체 ex) {name : 'Dmall'}
 * @constructor template(필수), obj
 */
Dmall.Template = function(template, obj) {
    var srcTemplate = template || '',
    map = obj || {};

    /**
     * 정의된 템플릿에 obj의 데이터를 매핑하여 반환
     * @param obj map 형태의 데이터 객체 ex) {name : 'Dmall', since: 2016}
     * @returns {*|string}
     */
    this.render = function(obj) {
        var obj = obj || map,
        key,
        exp,
        temp = srcTemplate;

        for(key in obj) {
            exp = new RegExp('{{' + key + '}}', 'gi');
            temp = temp.replace(exp, Dmall.validation.isEmpty(obj[key]) ? '' : obj[key]);
        }
        return temp;
    };
};

Dmall.TemplateNoFormat = function(template, obj) {
    var srcTemplate = template || '',
    map = obj || {};

    /**
     * 정의된 템플릿에 obj의 데이터를 매핑하여 반환
     * @param obj map 형태의 데이터 객체 ex) {name : 'Dmall', since: 2016}
     * @returns {*|string}
     */
    this.render = function(obj) {
        var obj = obj || map,
        key,
        exp,
        temp = srcTemplate;

        for(key in obj) {
            exp = new RegExp('{{' + key + '}}', 'gi');
            var tmpKey = obj[key];
            temp = temp.replace(exp, Dmall.validation.isEmpty(obj[key]) ? '' : obj[key].format());
        }
        return temp;
    };
};

Boolean.prototype.format = function(){
    return 0;
};
//숫자 타입에서 쓸 수 있도록 format() 함수 추가
Number.prototype.format = function(){
    if(this==0) return 0;

    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (this + '');

    while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');

    return n;
};
//문자열 타입에서 쓸 수 있도록 format() 함수 추가
String.prototype.format = function(){
    var num = parseFloat(this);
    if( isNaN(num) ) return this;

    return num.format();
};
/**
 * 알림/확인 레이어를 출력하기 위한 클래스
 * @type {{alert_title: string, confirm_title: string, desc: string, alert_template: string, confirm_template: string, create: LayerUtil.create, close: LayerUtil.close, alert: LayerUtil.alert, confirm: LayerUtil.confirm}}
 */
Dmall.LayerUtil = {

        alert_title :  '알림',
        confirm_title : '확인',
        desc : '',
        alert_template : '<div id="div_id_alert" class="slayer_popup">' +
        '<div class="pop_wrap size1">' +
        '<div class="pop_tlt">' +
        '<h2 class="tlth2">{{title}} <span class="desc">{{desc}}</span></h2>' +
        '<a href="javascript:;" class="close ico_comm">닫기</a>' +
        '</div>' +
        '<div class="pop_con">' +
        '<div>' +
        '<p class="message">{{msg}}</p>' +
        '<div class="btn_box txtc">' +
        '<a href="javascript:;" id="a_id_alert_close" class="btn_green">확인</a>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>',
        confirm_template : '<div id="div_id_confirm" class="slayer_popup">' +
                                '<div class="pop_wrap size1">' +
                                    '<div class="pop_tlt">' +
                                        '<h2 class="tlth2">{{title}} <span class="desc">{{desc}}</span></h2>' +
                                        '<a href="javascript:;" class="close ico_comm">닫기</a>' +
                                    '</div>' +
                                    '<div class="pop_con">' +
                                        '<div>' +
                                            '<p class="message">{{msg}}</p>' +
                                            '<div class="btn_box txtc">' +
                                                '<a href="javascript:;" id="a_id_confirm_yes" class="btn_green">확인</a>\n' +
                                                '<a href="javascript:;" id="a_id_confirm_no" class="btn_red">취소</a>' +
                                            '</div>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>',

        /**
         * <pre>
         * 함수명 : create
         * 설  명 : LayerUtil 에서 내부적으로 호출하는 레이어 생성 함수
         * 사용법 : LayerUtil.create()
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param $popup 팝업 레이어
         */
        create : function($layer) {
            jQuery('body').append($layer);
            var left = ( $(window).scrollLeft() + ($(window).width() - $layer.width()) / 2 ),
                top = ( $(window).scrollTop() + ($(window).height() - $layer.height()) / 2 ),
                dimmed = jQuery('.dimmed').length > 0 ? true : false;
            $layer.css({top: top, left: left});
            $layer.fadeIn();

            if(dimmed) {
                $layer.prepend('<div class="dimmed2"></div>');
                // $layer.css('z-index', 120)
                //     .find('.pop_wrap').css('z-index', 120);
            } else {
                $layer.prepend('<div class="dimmed"></div>');
            }

            $('body').css('overflow-y','hidden').bind('touchmove', function(e) {e.preventDefault()});
        },

        /**
         * <pre>
         * 함수명 : create
         * 설  명 : LayerUtil 에서 내부적으로 호출하는 레이어 제거 함수
         * 사용법 : LayerUtil.create()
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param $popup 팝업 레이어
         */
        close : function(id) {
            var $body = $('body');
            if(id) {
                jQuery('#' + id).fadeOut().remove();
            } else {
                $body.find('.slayer_popup').fadeOut().remove();
            }
            // $body.find('.dimmed').remove();
            $body.css('overflow-y', 'scroll').unbind('touchmove');
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
                $layer = jQuery(template.render()),
                deferred = new $.Deferred();

            if(jQuery('#div_id_alert').length == 0) {
                Dmall.LayerUtil.create($layer);
            }

            $layer.find('#a_id_alert_close, .close').on('click', function() {
                Dmall.LayerUtil.close('div_id_alert');
                deferred.resolve();
            }).focus();

            return deferred.promise();
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
        confirm : function(msg, yesFunc, noFunc, title, desc) {
            var function1 = yesFunc || function(){},
                funciton2 = noFunc || function(){},
                title = title || Dmall.LayerUtil.confirm_title,
                desc = desc || Dmall.LayerUtil.desc,
                template = new Dmall.Template(Dmall.LayerUtil.confirm_template, {title: title, msg: msg, desc: desc}),
                $layer = jQuery(template.render());

            if(jQuery('#div_id_confirm').length == 0) {
                Dmall.LayerUtil.create($layer);
            }

            $layer.find('#a_id_confirm_yes').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                function1();
                Dmall.LayerUtil.close('div_id_confirm')});
            $layer.find('#a_id_confirm_no, .close').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                funciton2();
                Dmall.LayerUtil.close('div_id_confirm')});
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
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * 2016. 5. 20. minjae - create -> open, 이미 있는 영역을 레이어 팝업으로 처리하도록 수정
         * </pre>
         * @param $popup
         */
        open : function($popup) {
            var left = ( $(window).scrollLeft() + ($(window).width() - $popup.width()) / 2 ),
                top = ( $(window).scrollTop() + ($(window).height() - $popup.height()) / 2 );
            $popup.css({top: top, left: left});
            $popup.fadeIn();
            $popup.prepend('<div class="dimmed"></div>');
            $('body').css('overflow-y','hidden').bind('touchmove', function(e){e.preventDefault()});
            $popup.find('.close').on('click', function(){
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
         * 설  명 : LayerPopupUtil 내부에서 호출하는 레이어 팝업 제거 함수
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         */
        close : function(id) {
            var $body = $('body'),
                $popup = $body,
                dimmed2 = jQuery('div.dimmed2').length > 0 ? true : false;
            if(id) {
                var $popup = $('#' + id);
                $popup.fadeOut();
                // $popup.find('.dimmed').remove();
            } else {
                $body.find('.layer_popup, .slayer_popup').fadeOut();
                // $body.find('.dimmed').remove();
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
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param callback
         */
        zipcode :function(callback) {
            var template = '<div id="layer_id_post" class="layer_popup">' +
                    '<div class="pop_wrap size3">' +
                    '<div class="pop_tlt">' +
                    '<h2 class="tlth2">우편번호 검색</h2>' +
                    '<a href="#none" class="close ico_comm">닫기</a>' +
                    '</div>' +
                    '<div class="pop_con post">' +
                    '<div id="layer_id_postList" style="overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;padding: 0;">' +
                    '</div>' +
                    '</div>' +
                    '</div>',
                elementLayer,
                width = 600, //우편번호서비스가 들어갈 element의 width
                height = 500, //우편번호서비스가 들어갈 element의 height
                borderWidth = 0; //샘플에서 사용하는 border의 두께

            if(jQuery('#layer_id_post').length === 0) {
                jQuery('body').append(jQuery(template));
            }

            Dmall.LayerPopupUtil.open(jQuery('#layer_id_post'));
            elementLayer = document.getElementById('layer_id_postList');

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
                    Dmall.LayerPopupUtil.close('layer_id_post');
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
/**
 * 디자인 체크박스 클래스
 */
Dmall.CheckboxUtil = {
        /**
         * <pre>
         * 함수명 : check
         * 설  명 : 디자인 체크박스 내부의 체크박스에 값을 설정
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param obj 이벤트가 발생한 엘리먼트
         * @param checked 체크여부
         */
        check : function(obj, checked) {
            var $this = $(obj),
            $checkbox = $this.find('input');
            if(checked) {
                $this.addClass('on');
                $checkbox.prop('checked', true);
            } else {
                $this.removeClass('on');
                $checkbox.prop('checked', false);
            }
        }
};
/**
 * 디자인 셀렉트 클래스
 */
Dmall.SelectUtil = {
    /**
     * <pre>
     * 함수명 : reset
     * 설  명 : 디자인 셀렉트 이전 값으로 되돌린다.
     * 사용법 :
     * 작성일 : 2016. 6. 14.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 6. 14. minjae - 최초 생성
     * </pre>
     * @param obj 되돌릴 값의 SELECT 엘리먼트
     */
    reset : function(obj) {
        var $this = $(obj),
            select_name;
        $this.find('option[value="' + $this.data('prevValue') + '"]').prop('selected', true);
        select_name = $this.children('option:selected').text();
        $this.siblings('label').text(select_name);
    }
};

/**
 * 초기화에 관련된 클래스
 */
Dmall.init = {
    /**
     * <pre>
     * 함수명 : jQuery ajax의 요청/오류반환/완료 시에 대한 공통 처리 초기화
     * 설  명 :
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     */
    ajax : function() {
        var token = $("meta[name='_csrf']").attr("content"),
        header = $("meta[name='_csrf_header']").attr("content");

        $(document).ajaxSend(function(e, xhr, options) {
            // Dmall.waiting.start();
            xhr.setRequestHeader(header, token);
        });
        $(document).ajaxError(function(e, xhr, options) {
            Dmall.waiting.stop();
            if (xhr.status == 403) {
                Dmall.LayerUtil.confirm('로그인 정보가 없거나 유효시간이 지났습니다.<br/>로그인페이지로 이동하시겠습니까?',
                        function() {
                    document.location.href = '/admin/login/member-login';
                });
            } else {
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    Dmall.LayerUtil.alert(xhr.responseJSON.message);
                } else {
                    Dmall.LayerUtil.alert("처리중 오류가 발생했습니다.<br/>관리자에게 문의하십시오.");
                }
            }
        });
        $(document).ajaxComplete(function(e, xhr, options) {
            // Dmall.waiting.stop();

            return xhr.responseJSON;
        });

    },
    /**
     * <pre>
     * 함수명 : datepicker
     * 설  명 : 달력 입력란, 달력 이미지에 대한 이벤트 처리 및 jQuery UI 달력 설정 세팅
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     */
    datepicker : function() {
        // 달력 INPUT
        // $(".bell_date_sc").click(function () {
        //     $("#" + this.id).dmallCalandar();
        // });

        $(".bell_date_sc, .date_sc").dmallCalandar();

        // 달력 이미지
        // $(".date_sc").click(function () {
        //     var idx = this.id.indexOf('_date'),
        //     prefix = this.id.substring(0, this.id.indexOf('_date')),
        //     changeId = prefix + '_sc' + this.id.substring(idx + 5);
        //     $("#" + changeId).dmallCalandar();
        // });
    },

    /**
     * <pre>
     * 함수명 : datePeriodButton
     * 설  명 : 달력 옆에 달린 기간 버튼에 대한 이벤트 처리 및 설정
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     */
    datePeriodButton : function() {
        /**
         * 달력 버튼 클릭시 이벤트 처리
         */
        $('.tbl_btn button.btn_day').on('click', function(e){
            Dmall.EventUtil.stopAnchorAction(e);

            $(this).addClass('on').siblings().removeClass('on');

            //TODO: 클릭시 달력 데이터 변경
            var $this = jQuery(this),
            index = $this.index(),
            $parent = $this.parents('td').data('index', index),
            $to = $parent.find('input.bell_date_sc:eq(1)'),
            $from = $parent.find('input.bell_date_sc:eq(0)'),
            date,
            from,
            to = $to.val();
            if(jQuery.trim(to) == '') {
                date = new Date();
                to = date.format('yyyy-MM-dd');
            } else {
                date = new Date($to.val().replace(/-/g, '/'));
            }

            // TODO: 올바르지 않은 문자일때 오류처리

            switch (index) {
                case 0 :
                    date = new Date();
                    from = date.format('yyyy-MM-dd');
                    to = date.format('yyyy-MM-dd');
                    break;
                case 1 :
                    date.setDate(date.getDate() - 3);
                    break;
                case 2 :
                    date.setDate(date.getDate() - 7);
                    break;
                case 3 :
                    date.setMonth(date.getMonth() - 1);
                    break;
                case 4 :
                    date.setMonth(date.getMonth() - 3);
                    break;
                default :
                    from = '';
                to = '';
                break;
            }

            if(from != '') {
                from = date.format('yyyy-MM-dd');
            }

            $from.val(from);
            $to.val(to);
        });
    },

    /**
     * <pre>
     * 함수명 : checkbox
     * 설  명 : 그리드 헤더의 전체 체크박스에 대한 이벤트 처리
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * 2016. 7. 19. minjae - thead 안의 TH만 처리하도록 수정
     * </pre>
     */
    checkbox : function() {
        $(document).on('click', '.chack', function(e) {
            e.preventDefault();
            var $this = jQuery(this),
            // $checkbox = $this.prev(),
            // checked = !($checkbox.prop('checked'));
                $input = $this.find('input'),
                checked = !($input.prop('checked'));

            if(!$input.prop('disabled') && !$input.prop('readonly')) {
                $input.prop('checked', checked);

                if($this.parent()[0].tagName === 'TH' && $this.parents('thead').length === 1) {
                    $this.parents('table').find('tbody > tr > td > label.chack').each(function(i, o) {
                        Dmall.CheckboxUtil.check(o, checked);
                    });
                }
                $this.toggleClass('on');
            }
        });
    },

    checkboxAllBtn : function() {
        $(document).on('click', 'a.all_choice', function(e) {
            Dmall.EventUtil.stopAnchorAction(e);

            var $o = $(e.currentTarget);
            if ($o.hasClass('on')) {
                $o.removeClass("on");
                $o.siblings().removeClass("on").find('input').prop('checked', false);
            } else {
                $o.addClass("on");
                $o.siblings().addClass("on").find('input').prop('checked', true);
            }
        });
    },

    /**
     * <pre>
     * 함수명 : select
     * 설  명 : 디자인 셀렉트에 대한 이벤트 처리
     *          디자인 셀렉트 선택시 이전값 저장 및 라벨 처리
     *          디자인 셀렉트 초기화시 체인지 트리거 발생
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * 2016. 6. 14. minjae - 이전값 저장 기능 추가
     * </pre>
     */
    select : function() {
        jQuery(document).on('change', '.select select, .select_inp select', function () {
            var $this = $(this),
                select_name;
            select_name = $this.children('option:selected').text();
            $this.siblings('label').text(select_name);
        }).on('focus, click', '.select select, .select_inp select', function() {
            var $this = $(this);
            $this.data('prevValue', this.value);
        });
        jQuery('.select select, .select_inp select').trigger('change');
    },

    /**
     * <pre>
     * 함수명 : radio
     * 설  명 : 디자인 라디오 버튼에 대한 이벤트 처리(디자인 라디오 체크시 다른 디자인 라디오 버튼의 체크 해제)
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     */
    radio : function() {
        $(document).on('click', '.radio', function(e) {
            e.preventDefault();

            var $this = $(this),
                $input = $this.find('input');

            if(!$input.prop('disabled') && !$input.prop('readonly')) {
                var $inputs = jQuery('input[name="' + $input.attr('name') + '"]');
                $inputs.removeProp('checked');
                // $input.parents('label').siblings().find('input').removeProp('checked');
                $input.prop('checked', true).trigger('change');
                //
                if ($input.prop('checked')) {
                    $inputs.parents('label').removeClass('on');
                    $this.addClass('on');
                    // $this.addClass('on').siblings().removeClass('on');
                }
            }
        });
    },

    /**
     * <pre>
     * 함수명 : tab
     * 설  명 : 디자인 탭 버튼에 대한 이벤트 처리
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     */
    tab : function() {
        $('.tab_lay .tab').on('click', function(e) {
            //Dmall.EventUtil.stopAnchorAction(e);

            var $this = $(this);
            $this.addClass('on').siblings().removeClass('on');
            $this.next('.tab_con').show().siblings('.tab_con').hide();
        });
        $('.tab_lay2 ul li').on('click', function(){
            var $this = $(this);
            $this.addClass('on').siblings().removeClass('on');
            var tabHref = $($this.find('a').attr('href'));
            tabHref.fadeIn().siblings('.tab-2con').hide();
            return false;
        });
    },

    /**
     * <pre>
     * 함수명 : layerPopup
     * 설  명 : 레이어 팝업 버튼 및 레이어팝업의 닫기 버튼에 대한 이벤트 처리
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     */
    layerPopup : function() {
        //Layer popup
        // $('.popup_open').on('click', function(){
        //     var layHref = $($(this).attr('href'));
        //     var left = ( $(window).scrollLeft() + ($(window).width() - layHref.width()) / 2 );
        //     var top = ( $(window).scrollTop() + ($(window).height() - layHref.height()) / 2 );
        //     layHref.fadeIn();
        //     layHref.css({top: top, left: left});
        //     $('.layer_popup').prepend('<div class="dimmed"></div>');
        //     $('body').css('overflow-y','hidden').bind('touchmove', function(e){e.preventDefault()});
        //     return false;
        // });
        // $('.layer_popup .close').on('click', function(){
        //     $(this).parents('.layer_popup').fadeOut();
        //     $(this).parents().find('.dimmed').remove();
        //     $('body').css('overflow-y','scroll').unbind('touchmove');
        //     return false;
        // });
    },

    fileUpload : function() {
        $('input[type="file"]').on('change', function() {
            var $this = jQuery(this),
                $fileInput = $this.prev().prev().find('input');
            $fileInput.val($this.val())
        });
    },
    gnbLink : function() {
        $('.gnb_link').mouseleave(function() {
            var cls = $('div[id^="g_menu"]').attr('id');
            var wid = $('#'+cls).css('width','');
            $('.gl_bg').stop().animate({'width' : wid}, 500 );
        });
        $('.gnb_link li').mouseenter(function() {
            var obj = $(this).offset();
            $('.gl_bg').stop().removeClass('off').animate({'width' : obj.left - 110}, 700, 'easeOutBack' );
            var $this = $(this).addClass('on').find('a').find('.img');
            if ($(this).hasClass('current')){
                $this.css({top:'18px'});
            }else if ($(this).hasClass('off')){
                $this.css({top:'22px'});
                $('.gl_bg').stop().animate({'width' : obj.left - 110}, 700, 'easeOutBack' ).addClass('off');
            }else{
                $this.stop().animate({top:'14px'},300 ,function(){
                    $(this).animate({top:'18px'},300);
                });
            }
        }).mouseleave(function() {
            var $this = $(this).removeClass('on').find('a').find('.img');
            $('.gl_bg').removeClass('off');
            if ($(this).hasClass('current')) {
                $this.css({top: '18px'});
            } else {
                $this.stop().animate({top: '22px'}, 300);
            }
        });
    },
    gnbSet : function() {
        $('.gnb_set').mouseleave(function() {
            var cls = $('div[id^="gs_menu"]').attr('id');
            var wid = $('#'+cls).css('width','');
            $('.gs_bg').stop().animate({'width' : wid}, 500 );
        });
        $('.gnb_set li').mouseenter(function() {
            var $this = $(this).addClass('on').find('a').find('.img');
            if ($(this).hasClass('current')){
                $this.css({top:'18px'});
            }else if ($(this).hasClass('off')){
                $this.css({top:'22px'});
            }else{
                $this.stop().animate({top:'14px'},300 ,function(){
                    $(this).animate({top:'18px'},300);
                });
            }
        }).mouseleave(function() {
            var $this = $(this).removeClass('on').find('a').find('.img');
            if ($(this).hasClass('current')){
                $this.css({top:'18px'});
            }else{
                $this.stop().animate({top:'22px'},300);
            }
        });

        $('.gnb_set li .gnbs_ico1').mouseenter(function() {
            //$('.gs_bg').stop().animate({'width' : '180'}, 700, 'easeOutBack' );
        });
        /*$('.gnb_set li .gnbs_ico1').mouseenter(function() {
            $('.gs_bg').stop().animate({'width' : '270'}, 700, 'easeOutBack' );
        });
        $('.gnb_set li .gnbs_ico2').mouseenter(function() {
            $('.gs_bg').stop().animate({'width' : '180'}, 700, 'easeOutBack' );
        });*/
        $('.gnb_set li .gnbs_ico3').mouseenter(function() {
            //$('.gs_bg').stop().animate({'width' : '100'}, 700, 'easeOutBack' );
        });
    },
    lnbMenu : function() {
        $('.lnb ul > li > a.twotlt').on('click', function(){
            $(this).next().slideToggle();
            $(this).toggleClass('on');
        })
    },
    menuAco : function() {
        $(".menu_aco .admin_tlt > a").on('click', function(){
            $(this).toggleClass('on');
            if ($(this).hasClass('on')){
                $(this).parent().siblings('.aco_con').slideDown();
            }else{
                $(this).parent().siblings('.aco_con').slideUp();
            }
        }).one('click', Dmall.init.getAdminInfo);
    },
    catePoint : function() {
        $('.category_box .step .list ul li').on('click', function(){
            $(this).addClass('on').siblings().removeClass('on');
        });
    },
    tblUlbtn : function() {
        $('.tbl_ul li .link button').on('click', function(){
            $(this).toggleClass('on');
        });
    },
    changeTbl : function() {
        $('.change_tbl h3 .right .change_btn').on('click', function(){
            $(this).parents('.change_tbl').hide().siblings('.change_tbl').show();
            return false;
        });
    },
    pmBtnP : function() {
        $('.pm_btn thead .plus').on('click', function(){
            $(this).parents('thead').siblings('tbody').append('<tr><td class="fir"><button class="minus btn_comm">빼기 버튼</button></td><td><label for="" class="radio"><span class="ico_comm"><input type="radio" name="formula" id=""></span></label></td><td><span class="intxt shot2"><input type="text" value="" id=""></span></td><td><span class="intxt shot2"><input type="text" value="" id=""></span></td><td><span class="intxt shot"><input type="text" value="" id=""></span> 원</td><td><span class="intxt shot"><input type="text" value="" id=""></span> 원</td><td><span class="intxt shot"><input type="text" value="" id=""></span> 원</td><td><span class="intxt shot2"><input type="text" value="" id=""></span></td></tr>');
            Dmall.init.radio();
            Dmall.init.pmBtnP();
        });
        $('.pm_btn2 thead .plus').on('click', function(){
            $(this).parents('thead').siblings('tbody').append('<tr><td><button class="minus btn_comm">빼기 버튼</button></td><td><span class="intxt wid100p"><input type="text" value="" id=""></span></td><td><span class="intxt wid100p"><input type="text" value="" id=""></span></td></tr>');
            Dmall.init.radio();
            Dmall.init.pmBtnP();
        });
    },
    pmBtnM : function() {
        $('.pm_btn tbody .minus').on('click', function(){
            Dmall.init.pmBtnP();
            $(this).parents('tr').remove();
        });
        $('.pm_btn2 tbody .minus').on('click', function(){
            Dmall.init.pmBtnP();
            $(this).parents('tr').remove();
        });
    },
    tblAco : function() {
        $('.acd_tlt').on('click', function(){
            $(this).parents('tr').next('.acd_con').show().siblings('.acd_con').hide();
            return false;
        });
        $('.acd_con2').hide();
        $('.acd_tlt2').on('click', function(){
            $(this).parents('tr').next('.acd_con2').toggle();
            return false;
        })
    },
    updwCon : function() {
        $( ".updw_con button" ).hover(function() {
            $( this ).toggleClass('on');
        });
        $(document).on('click', '.move', function() {
            var mode = ($(this).attr('class') == "up_btn btn_comm move up" ? "up" : "dn");
            var element = $(this).closest('tr');
            if (mode == "up" && element.prev().html() != null) {
                // 위로 이동
                element.insertBefore(element.prev());
            } else if (mode == "dn" && element.next().html() != null){
                // 아래로 이동
                element.insertAfter(element.next());
            }
        });
    },
    txtDel : function() {
        $('.txt_del .btn_del').on('click', function(){
            $(this).parents('.txt_del').remove();
        });
    },
    inDel : function() {
        $('.in_del .btn_del').on('click', function(){
            $(this).siblings('input').val('');
        });
    },
    smsClick : function() {
        $('.sms_click').on('click', function(){
            $('.sms_send').toggle();
        });
    },
    clauseAccordion : function() {
        $('.clause_accordion dl dt .right').on('click', function(){
            $(this).addClass('on').find('span').text('닫기').parents('dt').next('dd').slideDown();
            $(this).parents('dl').siblings().find('dt a').removeClass('on').find('span').text('열기');
            $(this).parents('dl').siblings().find('dd').slideUp();
        });
    },
    checkTab : function() {
        $('.ra').on('click', function(){
            $('tr.radio_a').show();
            $('tr.radio_b').hide();
            $('tr.radio_c').hide();
        });
        $('.rb').on('click', function(){
            $('tr.radio_b').show();
            $('tr.radio_a').hide();
            $('tr.radio_c').hide();
        });
        $('.rc').on('click', function(){
            $('tr.radio_c').show();
            $('tr.radio_b').hide();
            $('tr.radio_a').hide();
        });
    },
    setCurrentGnb : function() {
        var path = document.location.pathname,
            token = path.split('/'),
            $li;

        token = token.slice(0, 3);
        path = token.join('/');

        switch (path) {
            case '/admin/main' :
                jQuery('#gnb .gnb_set li').removeClass('current, on');
                break;
            case '/admin/goods' :
                jQuery('#gnb .gnb_set li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_link li:eq(1)');
                break;
            case '/admin/order' :
                jQuery('#gnb .gnb_set li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_link li:eq(2)');
                break;
            case '/admin/member' :
                jQuery('#gnb .gnb_set li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_link li:eq(3)');
                break;
            case '/admin/operation' :
                jQuery('#gnb .gnb_set li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_link li:eq(4)');
                break;
            case '/admin/promotion' :
                jQuery('#gnb .gnb_set li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_link li:eq(5)');
                break;
            case '/admin/statistics' :
                jQuery('#gnb .gnb_set li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_link li:eq(6)');
                break;
            case '/admin/design' :
                jQuery('#gnb .gnb_link li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_set li:eq(0)');
                break;
            case '/admin/marketting' :
                jQuery('#gnb .gnb_link li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_set li:eq(1)');
                break;
            case '/admin/setup' :
                jQuery('#gnb .gnb_link li').removeClass('current, on');
                $li = jQuery('#gnb .gnb_set li:eq(2)');
                break;
        }
        if($li) {
            $li.siblings().removeClass('current, on');
            $li.addClass('current, on');
        }
    },
    disabledNotAllowedMenu : function() {
        jQuery('#gnb .gnb_set li a[href="#"]').parent().addClass('off opa');
        jQuery('#gnb .gnb_link li a[href="#"]').parent().addClass('off opa');
    },
    getAdminInfo : function() {
        var $admin = jQuery('#div_id_adminInfo');
        jQuery.getJSON('/admin/common/admin-info', {}, function(result) {
            $admin.find('#span_id_adminInfo_version').text(result.version);
            $admin.find('#span_id_adminInfo_regDttm').text(result.regDttm );
            $admin.find('#span_id_adminInfo_svcDt').text(result.svcStartDt + ' - ' + result.svcEndDt);
            $admin.find('#span_id_adminInfo_restDate').text(result.restDate + ' 일');
            $admin.find('#span_id_adminInfo_domain').text(result.domain);
            // $admin.find('#span_id_adminInfo_sms').text(result.sms + ' point');
            $admin.find('#span_id_adminInfo_disk').text(result.useSpace + ' ' + '(' + result.totalSpace + ')');
            $admin.find('#p_id_adminInfo_diskPercent').html('<strong>' + result.useSpacePercent + '%</strong> ' + result.useSpace);
            $admin.find('#div_id_adminInfo_diskPercent1').css('width', result.useSpacePercent + '%');
            $admin.find('#div_id_adminInfo_diskPercent2').css('left', result.useSpacePercent + '%');
        });
        /*$.ajax({
            type : 'get',
            url : Constant.smsemailServer + "/sms/point/" + Constant.siteNo,
            dataType : 'jsonp',
            jsonp : 'callback'
        }).done(function(result) {
            
            if(Dmall.validation.isEmpty(result)) {
                $admin.find('#span_id_adminInfo_sms').text('');
            } else {
                $admin.find('#span_id_adminInfo_sms').text(result + ' point');
            }
        });*/
    },
    refreshDiskSpace : function() {
        jQuery('#btn_id_refreshDiskSpace').on('click', function() {
            jQuery.getJSON('/admin/common/disk-info', {}, function(result) {
                var $admin = jQuery('#div_id_adminInfo');
                $admin.find('#span_id_adminInfo_disk').text(result.useSpace + ' ' + '(' + result.totalSpace + ')');
                $admin.find('#p_id_adminInfo_diskPercent').html('<strong>' + result.useSpacePercent + '%</strong> ' + result.useSpace);
                $admin.find('#div_id_adminInfo_diskPercent1').css('width', result.useSpacePercent + '%');
                $admin.find('#div_id_adminInfo_diskPercent2').css('left', result.useSpacePercent + '%');
            });
        });
    },

    /**
     * 주문 상세 페이지 : 할인 가격 마우스 오버
     */
    allSum : function() {
        $(".gray_box").mouseover(function() {
          $(this).children('.sum_area').stop().fadeIn('slow');
        });
        $(".gray_box").mouseleave(function() {
          $(this).children('.sum_area').stop().fadeOut();
        });
    },
    goodsDel : function() {
        $('.goods_del li .cancel').on('click', function(){
            var $this = $(this);
            $this.hide().siblings().find('.btn_gray').hide();
            $this.parents('li').css('opacity','0.5');

        });
    }
};

/**
 * 각종 값을 바인드하는 클래스
 *
 * @type {{setActionTypeUpdate: FormUtil.setActionTypeUpdate, jsonToForm: FormUtil.jsonToForm}}
 */
Dmall.FormUtil = {

        /**
         * <pre>
         * 함수명 : getActionTypeObj
         * 설  명 : formId의 해당하는 폼의 액션 타입을 반환하는 함수
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param formId
         * @return {Object} 액션 타입 input jQuery Object, 없으면 빈값을 가진 input jQuery Object
         */
        getActionTypeObj : function(formId) {
            var $form = jQuery('#' + formId),
            $actionType = $form.find('input[name="_action_type"]');
            if(!$actionType || $actionType.length === 0) {
                $actionType = jQuery('<input type="hidden" name="_action_type" />');
                $form.append($actionType);
            }

            return $actionType;
        },

        /**
         * <pre>
         * 함수명 : setActionTypeUpdate
         * 설  명 : formId 에 해당하는 폼의 액션 타입을 '수정'으로 변경
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param formId 폼 ID
         */
        setActionTypeUpdate : function(formId) {
            Dmall.FormUtil.getActionTypeObj(formId).val('UPDATE');
        },

        /**
         * <pre>
         * 함수명 : setActionTypeInsert
         * 설  명 : formId 에 해당하는 폼의 액션 타입을 '등록'으로 변경
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param formId 폼 ID
         */
        setActionTypeInsert : function(formId) {
            Dmall.FormUtil.getActionTypeObj(formId).val('INSERT');
        },
        getActionType : function(formId) {
            var actionType = Dmall.FormUtil.getActionTypeObj(formId).val();
            return actionType || 'INSERT';
        },

        /**
         * <pre>
         * 함수명 : jsonToForm
         * 설  명 : JSON 형태의 데이터를 formId에 해당하는 폼에 바인드
         *          JSON 객체의 KEY의 이름과 같은 INPUT, SELECT, TEXTAREA엘리먼트의 값으로 VALUE를 세팅
         *          없다면 'bind_target_id_[KEY]'에 해당하는 엘리먼트의 'TEXT'로 VALUE를 세팅
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * </pre>
         * @param json 폼에 매핑할 JSON 객체
         * @param formId 폼 ID
         */
        jsonToForm : function(json, formId) {
            var key,
            value,
            $form = jQuery('#' + formId),
            $obj;

            for(key in json) {
                $obj = $form.find('input[name="' + key + '"], select[name="' + key + '"], textarea[name="' + key + '"]');
                value = json[key] || '';

                if($obj.length == 0) {
                    $obj = $form.find('#bind_target_id_' + key);
                    if($obj.length == 0) continue;
                }
                switch ($obj[0].tagName) {
                    case 'INPUT' :
                        switch ($obj.attr('type')) {
                            case 'radio' :
                                var $o = $obj.filter('input[value="' + value + '"]');
                                $o.prop('checked', true);
                                $o.parents('label').addClass('on').siblings().removeClass('on');
                                break;
                            case 'checkbox' :
                                var $o = $obj.filter('input[value="' + value + '"]');
                                $obj.prop('checked', false).parents('label').removeClass('on');
                                if($o) {
                                    $o.prop('checked', true);
                                    $o.parents('label').addClass('on');
                                }
                                break;
                            default :
                                $obj.val(Dmall.HtmlUtil.unescape(value));
                        }
                        break;
                    case 'SELECT' :
                        var $o = $obj.find('option[value="' + value + '"]');
                        $o.prop('selected', true);
                        $o.parents('select').prev().text($o.text());
                        break;
                    case 'TEXTAREA' :
                    default :
                        $obj.text(Dmall.HtmlUtil.unescape(value));
                }
            }

            Dmall.FormUtil.setActionTypeUpdate(formId);
        },

        /**
         * <pre>
         * 함수명 : submit
         * 설  명 :
         * 사용법 :
         * 작성일 : 2016. 4. 28.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 2016. 4. 28. minjae - 최초 생성
         * 2016. 5. 16. minjae - target 추가
         * </pre>
         * @param url 서버로 요청할 URL
         * @param paramMap 서버로 요청시 전달할 파라미터 객체(맵형식)
         * @param target from 태그의 target
         * @returns {Boolean} 오류시 false
         */
        submit : function (url, paramMap, target) {
            jQuery('#_form_id_comm').remove();

            var token = $("meta[name='_csrf']").attr("content"),
            $form = jQuery('<form method="post"></form>'),
            inputTemplate = '<input type="hidden" name="{{name}}" value="{{value}}" />',
            template = new Dmall.Template(inputTemplate),
            key;

            $form.attr({'action' : url, 'method' : 'post', 'id' : '_form_id_comm'});

            if(target) {
                $form.attr('target', target);
            }

            if(paramMap != null && !$.isPlainObject(paramMap)) {
                Dmall.LayerUtil.alert('param 변수가 Object(Map) 형식이 아닙니다.');
                return false;
            }

            $form.append(template.render({name: '_csrf', value : token}));

            for(key in paramMap) {
                $form.append(template.render({name: key, value : paramMap[key]}));
            }
            jQuery('body').append($form);
            $form.submit();
        },
        /**
         * <pre>
         * 함수명 : setEnterSearch
         * 설  명 : 입력한 form ID에 해다하는 폼 안의 입력란에서 엔터키를 치면 조회 함수 호출
         * 사용법 :
         * 작성일 : 2016. 9. 8.
         * 작성자 : minjae
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------
         * 22016. 9. 8. minjae - 최초 생성
         * </pre>
         * @param formId 조회 조건 폼 ID
         * @param execFunc 엔터 입력시 실행할 함수
         */
        setEnterSearch : function(formId, execFunc) {
            jQuery(document).on('keydown', '#' + formId + ' input', function(e) {
                if(e.keyCode == 13) {
                    execFunc();
                }
            });
        }
};

/**
 * jQuery 플러그인 정의
 */
(function($) {
    /**
     * jQuery 그리드 플러그인
     * 그리드의 페이징 이벤트를 처리
     *
     * @param $form 조회조건 폼 jQuery 객체
     * @param callback 콜백함수 = 조회 함수
     */
    $.fn.grid = function($form, callback) {
        callback = callback || function () {$form.submit();};
        return this.each(function() {
            var $grid = $(this),
            $page = $form.find('input[name="page"]');
            $grid.find('a.strpre, a.pre, a.num:not(.on), a.nex, a.endnex').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);

                $page.val(jQuery(this).data('page'));
                callback();
            });
            $grid.find('select[name="sidx"]').on('change', function() {
                $form.find('input[name="sort"]').val(this.value);
                callback();
            });
            $grid.find('select[name="rows"]').on('change', function() {
                $page.val(1);
                $form.find('input[name="rows"]').val(this.value);
                callback();
            });
        });
    };

    /**
     * 디자인 처리된 라디오/셀렉트/체크박스/인풋박스의 Readonly 속성을 토글한다.
     * @returns {*}
     */
    $.fn.toggleDesignEleDisabled = function() {
        return this.each(function() {
            var $this = $(this),
                tagName = this.tagName,
                type = $this.prop('type'),
                p;
            if(type === 'text' || type == 'checkbox') {
                p = 'span';
            } else if(tagName === 'SELECT') {
                p = 'span';
            } else {
                p = 'label';
            }
            if ($this.prop('disabled')) {
                $this.parents(p).removeClass('disa');
                $this.prop('disabled', false);
            } else {
                $this.parents(p).addClass('disa');
                $this.prop('disabled', true);
            }
        });
    };

    /**
     * 디자인 처리된 라디오/셀렉트/체크박스/인풋박스의 Readonly 속성을 토글한다.
     * @returns {*}
     */
    $.fn.toggleDesignEleReadonly = function() {
        return this.each(function() {
            var $this = $(this),
                tagName = this.tagName,
                type = $this.prop('type'),
                prop = 'readonly',
                p = 'span',
                c = 'in_read';
            if(type === 'text') {
                p = 'span';
            } else if(type == 'checkbox') {
                c = 'read'
            } else if(type == 'radio') {
                p = 'label';
                c = 'read'
            } else if(tagName === 'SELECT') {
                c = 'sel_read';
                prop = 'disabled';
            } else {
                p = 'label';
            }
            if ($this.prop(prop)) {
                $this.parents(p).removeClass(c);
                $this.prop(prop, false);
            } else {
                $this.parents(p).addClass(c);
                $this.prop(prop, true);
            }
        });
    };

})(jQuery),
function($) {
    /**
     * jQuery 플러그인
     * 화면에 표시된 input 요소에서 값을 취득하여 JavaScript Object로 반환
     * 사용범 :
     *   HTML :
     *      <input type="hidden" name="siteNo" data-input-type="text" data-input-name="siteNo" class="certify_info_0" />
     *
     *   JavaScript :
     *      var data = $(".certify_info_0").UserInputBinderGet();
     *
     */
    "use strict";
    $.fn.UserInputBinderGet = function() {
    var retObj = {};
    return this.each(function() {
        var obj = $(this),
            type = obj.data("input-type"),
            name = obj.data("input-name") || obj.attr("id") || obj.attr("name");
        if (!(null == type || type.length < 1)) switch (type.toLowerCase()) {
            case "number":
            case "email":
            case "text":
                retObj[name] = obj.val();
                break;
            case "radio":
                retObj[name] = $("input[type=radio][name=" + name + "]:checked", obj).data("input-value") || "";
                break;
            case "checkbox":
                retObj[name] = obj.is(":checked") ? "Y" : "N";
                break;
        }
    }), retObj
}}(jQuery),

function($) {
    /**
     * jQuery 플러그인
     * 화면에 표시된 input 요소에서 값을 취득하여 JavaScript Object로 반환
     * @param data 화면에 매핑할 값을 지닌 JavaScript객체
     * @param target 매핑 대상 요소
     * @param area 매핑 대상 요소
     * @param row 매핑 대상 요소
     *
     * 사용범 :
     *   HTML :
     *      <input type="hidden" name="siteNo" data-find="person_info_1" data-bind-type="text" data-bind-value="siteNo" />
     *
     *   JavaScript :
     *      $('[data-find="person_info_1"]').DataBinder(data);
     *
     */
    "use strict";
    $.fn.DataBinder = function(data, target, area, row) {
        return this.each(function() {
            var $obj = $(this);
            if (null != data && "object" == typeof data) {
                var type = $obj.data("bind-type"), bindName = $obj.data("bind-value");
                if (null != type && ! $.isEmptyObject(type)) {
                    if (null == bindName || bindName.length < 1)
                        return void $obj.html("(no bind)");

                    var value = null == data[bindName] ? "" : data[bindName];

                    switch (type.toLowerCase()) {
                        case "function":
                            var func = $obj.data("bind-function");
                            func = null == func || func.isEmpty() ? null : func.getFunction(), null != func && "function" == typeof func ? func.apply(null, [data, $obj, bindName, target, area, row]) : "" ;
                            break;
                        case "radio":
                            $obj.prop("disabled", "disabled"), $obj.val() == value && $obj.prop("checked", "checked");
                            break;
                        case "checkbox":
                            $obj.prop("disabled", "disabled"), $obj.val() == value && $obj.prop("checked", "checked");
                            break;
                        case "labelcheckbox":
                            var $chkbox =  (value && 'Y' == value) ? $("input[value='Y']", $obj) : $("input[value='N']", $obj);
                            $chkbox.parents('label').addClass("on").siblings().find('input').removeAttr('checked');
                            $chkbox.attr('checked', 'checked').trigger('change');
                            break;
                        case "text":
                            // $obj.data("value", value).val(value);
                            // $obj.data("value", value).data("prev_value", value).val(value);
                            $obj.data("value", Dmall.HtmlUtil.unescape(value)).data("prev_value", Dmall.HtmlUtil.unescape(value)).val(Dmall.HtmlUtil.unescape(value));
                            break;
                        case "textcomma":
                            var commavalue = parseInt(value).getCommaNumber();
                            $obj.data("value", value).data("commavalue", commavalue).val(commavalue);
                            break;
                        case "bizno":
                            $obj.val(Dmall.formatter.bizNo(value));
                            break;
                        case "tel":
                            $obj.val(Dmall.formatter.tel(value));
                            break;
                        case "fax":
                            $obj.val(Dmall.formatter.fax(value));
                            break;
                        case "select":
                            $("option[value='"+ value +"']", $obj).attr("selected", "true");
                            break;
                        case "labelselect":
                            var label = $("option[value='"+ value +"']", $obj).attr("selected", "true").text();
                            $obj.data("value", value).siblings('label').text(label);
                            break;

                        case "password":
                            $obj.data("input-value", value).text("".padding(value.length, "*"));
                            break;

                        case "commanumber":
                            $obj.data("value", value).html(parseInt(value).getCommaNumber());
                            break;
                        case "img":
                            $obj.attr("src",_IMAGE_DOMAIN +value);
                            break;
                        case "textselect":
                            $obj.children('option').each(function () {
                                if($(this).text().toLowerCase() == value.toLowerCase()) {
                                    $(this).attr('selected', 'true');
                                    $obj.siblings('label').text(value);
                                }
                            });
                            break;
                        case "number":
                        case "string":
                        default:
                            $obj.data("value", value).html(value);
                            break;
                    }
                }
            }
        })
    },

    $.fn.serializeObject = function() {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function() {
            if (o[this.name] !== undefined) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    }
}(jQuery);

// 달력 플러그인 클래스 정의
function DmallCalnander() {
    this._visible = false;
    this._year;  // 년
    this._month;  // 월
    this._date;  // 일
    this._$cal;  // 달력 레이어
    this._$input;  // 달력과 연결된 인풋
    this.cal_frame  = '<div class="calendar" id="DmallCalDiv"><div class="head"><span class="left">YEAR</span><span class="right">MONTH</span></div>' +
            '<div class="day"><div class="year"><button class="pre"><span class="btn_comm">이전년</span></button><span class="num">2015</span><button class="nex"><span class="btn_comm">다음년</span></button></div>' +
            '<div class="month"><button class="pre"><span class="btn_comm">이전달</span></button><span class="num">4</span><button class="nex"><span class="btn_comm">다음달</span></button></div></div>' +
            '<table><caption>달력</caption><colgroup><col width="14.29%"><col width="14.29%"><col width="14.29%"><col width="14.29%"><col width="14.29%"><col width="14.29%"><col width="14.29%"></colgroup>' +
            '<thead><tr><th>SUN</th><th>MON</th><th>TUE</th><th>WED</th><th>THU</th><th>FRI</th><th>SAT</th></tr></thead><tbody></tbody></table></div>';
}
// 달력 플러그인 함수 정의
$.extend(DmallCalnander.prototype, {
    /**
     * 달력 초기화 함수
     */
    init : function() {
        if($('#DmallCalDiv').length === 0) {
            jQuery('body').append($.dmallCalandar.cal_frame);
        }

        $.dmallCalandar._$cal = jQuery('#DmallCalDiv');

        // 달력 이외의 부분 클릭시 달력 닫기
        $(document).on('click', function(e) {
            var target = e.target,
                $target = $(target);
            if(!$.dmallCalandar._visible) return;

            if(!$target.hasClass('bell_date_sc') && !$target.hasClass('date_sc') && $target.parents('#DmallCalDiv').length < 1) {
                $.dmallCalandar._$cal.hide();
                $.dmallCalandar._visible = false;
            }
        });

        // 년도 변경 버튼 클릭 이벤트
        $.dmallCalandar._$cal.find('div.day > div.year')
            .find('button.pre').on('click', function(e) {
            Dmall.EventUtil.stopAnchorAction(e);
            $.dmallCalandar.setYear(-1);
        })
            .end()
            .find('button.nex').on('click', function(e) {
            Dmall.EventUtil.stopAnchorAction(e);
            $.dmallCalandar.setYear(1);
        });
        // 월 변경 버튼 클릭 이벤트
        $.dmallCalandar._$cal.find('div.day > div.month')
            .find('button.pre').on('click', function(e) {
            Dmall.EventUtil.stopAnchorAction(e);
            $.dmallCalandar.setMonth(-1);
        })
            .end()
            .find('button.nex').on('click', function(e) {
            Dmall.EventUtil.stopAnchorAction(e);
            $.dmallCalandar.setMonth(1);
        });
    },

    /**
     * 달력 레이어 보이기
     */
    showCal : function() {
        var obj = $.dmallCalandar._$input.offset();

        $.dmallCalandar.getDateFromInput();
        $.dmallCalandar._$cal.css({
            'top' : obj.top + 50,
            'left' : obj.left
        }).fadeIn();
        $.dmallCalandar.displayDate();
        $.dmallCalandar._visible = true;
    },

    /**
     * 달력과 연결된 인풋박스에서 값 가져오기
     */
    getDateFromInput : function() {
        var val = $.dmallCalandar._$input.val();
        if(Dmall.validation.date(val)) {
            var date = val.split('-');
            $.dmallCalandar.setDate(date[0], date[1], date[2]);
        } else {
            var d = new Date();
            $.dmallCalandar.setDate(d.getFullYear(), d.getMonth() + 1, d.getDate());
        }
    },

    /**
     * 달력에 일자 세팅
     * @param y 년
     * @param m 월
     * @param d 일
     */
    setDate : function(y, m, d) {
        $.dmallCalandar._year = y;
        $.dmallCalandar._month = parseInt(m, 10);
        $.dmallCalandar._date = parseInt(d, 10);
        $.dmallCalandar._$cal.find('div.day > div.year > span.num').text(y);
        $.dmallCalandar._$cal.find('div.day > div.month > span.num').text(parseInt(m, 10));
    },

    /**
     * 달력의 년도 변경
     * @param weight 현재 설정된 년도에서 변경할 년도와의 차이값(1년 전이면 -1, 1년 후면 1, 20년 후면 20)
     */
    setYear : function(weight) {
        var year = $.dmallCalandar._$cal.find('div.day > div.year > span.num').text();
        $.dmallCalandar._year = parseInt(year, 10) + weight;
        $.dmallCalandar._$cal.find('div.day > div.year > span.num').text($.dmallCalandar._year);
        $.dmallCalandar.displayDate();
    },

    /**
     * 달력의 월 변경
     * @param weight 현재 설정된 월에서 변경할 월과의 차이값(한달 전이면 -1, 10달 전이면 -10, 2달 후면 2)
     */
    setMonth : function(weight) {
        var month = $.dmallCalandar._$cal.find('div.day > div.month > span.num').text();
        $.dmallCalandar._month = parseInt(month, 10) + weight;

        if($.dmallCalandar._month < 1) {
            $.dmallCalandar._month = 12;
            $.dmallCalandar.setYear(-1);
        } else if($.dmallCalandar._month > 12) {
            $.dmallCalandar._month = 1;
            $.dmallCalandar.setYear(1);
        }
        $.dmallCalandar._$cal.find('div.day > div.month > span.num').text($.dmallCalandar._month);
        $.dmallCalandar.displayDate();
    },

    /**
     * 현재 세팅된 년/월으로 달력의 일자 부분 출력
     */
    displayDate : function() {
        var date = new Date(),
            firstDate = new Date(), // 그 월의 첫째 날
            lastDate = new Date(), // 그 월의 마지막 날
            tmpDate = new Date(), // 그 월의 마지막 날
            firstDay,
            isFirstWeek = true,
            trs = '',
            on = '',
            index = 1;
        date.setFullYear($.dmallCalandar._year);
        date.setMonth($.dmallCalandar._month - 1);
        date.setDate($.dmallCalandar._date);

//        lastDate.setFullYear($.dmallCalandar._year);
//        lastDate.setMonth(1);
//        console.log("1 lastDate=" + lastDate);                
//        lastDate.setDate(0);
//        lastDate = lastDate.getDate();
//        console.log("2 lastDate=" + lastDate);       
        lastDate = (new Date($.dmallCalandar._year, $.dmallCalandar._month, 0).getDate());


        firstDate.setFullYear($.dmallCalandar._year);
        firstDate.setMonth($.dmallCalandar._month - 1);
        firstDate.setDate(1);
        firstDay = firstDate.getDay(); // 첫째날의 요일 인덱스(0:일, 6:토)


        while(index <= lastDate) {
            trs += '<tr>';
            for (var i = 0; i < 7; i++) {
                trs += '<td>';

                if(index == $.dmallCalandar._date) {
                    on = ' class="on"';
                } else {
                    on = '';
                }

                if (isFirstWeek) {
                    if (firstDay <= i) {
                        trs += '<a href="#none"' + on + '>' + index + '</a>';
                        index++;
                    }
                } else {
                    if(index <= lastDate) {
                        trs += '<a href="#none"' + on + '>' + index + '</a>';
                        index++;
                    }
                }
                trs += '</td>';
            }
            trs += '</tr>';
            isFirstWeek = false;
        }
        $.dmallCalandar._$cal.find('tbody').html(trs)
            .find('tr td a').on('click', function() {
            $.dmallCalandar._date = jQuery(this).text();
            $.dmallCalandar.returnDate();
        });
    },

    /**
     * 달력에 연결된 인풋 박스에 선택한 년월일 세팅
     */
    returnDate : function() {
        $.dmallCalandar._$input.val($.dmallCalandar._year + '-' + $.dmallCalandar._month.df(2) + '-' + $.dmallCalandar._date.df(2));
        $.dmallCalandar._$cal.hide();
        $.dmallCalandar._visible = false;
        $.dmallCalandar._$input.trigger('hidden');
    }
});

(function($) {
    /**
     * 디자인 달력
     * input 객체나 달력 이미지 클릭시 달력 노출
     * 달력 이미지인 a 엘리먼트에 적용하면 a엘리먼트 앞의 엘리먼트에서 input 엘리먼트를 찾아 적용됨
     * @returns {*}
     */
    $.fn.dmallCalandar = function() {
        if(!$.dmallCalandar.initialized) {
            // 초기화
            $.dmallCalandar.init();
            $.dmallCalandar.initialized = true;
        }

        return this.each(function() {
            var $this = jQuery(this);

            // 인풋박스&이미지 클릭, 포커스인 이벤트
            $this.on('click, focus', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);

                // 이미지인경우 인풋 박스로 대상 변경
                if($this.hasClass('date_sc')) {
                    $this = $this.prev().find('input');
                }

                // if($this.prop('disabled') || $this.prop('readonly')) {
                //     return;
                // }

                $.dmallCalandar._$input = $this;
                $.dmallCalandar.showCal();
            });
        });
    }
})(jQuery);

$.dmallCalandar = new DmallCalnander(); // 싱글턴
$.dmallCalandar.initialized = false; // 초기화

Dmall.HtmlUtil = {
    escape : function(text) {
        var entityMap = {
                "&": "&amp;",
                "<": "&lt;",
                ">": "&gt;",
                '"': '&quot;',
                "'": '&#39;',
                "/": '&#x2F;',
                "×":'&times;',
                '$':'&#36;'
        };

        return String(text).replace(/[&<>"'\/]/g, function (s) {
            return entityMap[s];
        });
    },
    unescape : function(text) {

        var entityMap = {
            '&amp;': '&',
            '&lt;': '<',
            '&gt;': '>',
            '&quot;': '"',
            '&#39;': "'",
            '&#x2F;': '/',
            '&times;':'×',
            '&#36;':'$'
        };
        if(text!=null){
            return String(text).replace(/(&amp;)|(&lt;)|(&gt;)|(&quot;)|(&#39;)|(&#x2F;)|(&times;)|(&#36;)/g, function (s) {
                return entityMap[s];
            });
        }else{
            return '';
        }
    }
};




/**
 * 레이어 팝업 클래스 custom
 */
Dmall.LayerPopupUtilNew = {
    /**
     * <pre>
     * 함수명 : open
     * 설  명 : 문서의 영역을 레이어 팝업으로 생성하는 함수
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. minjae - 최초 생성
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
            $popup.css('z-index', 120)
                .find('.pop_wrap').css('z-index', 120);
        } else {
            $popup.prepend('<div class="dimmed"></div>');
        }
        $('body').css('overflow-y','hidden').bind('touchmove', function(e){e.preventDefault()});
        $popup.find('.btn_close_popup').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtilNew.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtilNew.close();
            }
        });
        $popup.find('.btn_popup_cancel').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtilNew.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtilNew.close();
            }
        });
    },

    open1 : function($popup) {
        if(!$popup.hasClass('layer_popup')) {
            $popup.addClass('layer_popup')
                .children().wrapAll('<div class="pop_wrap"></div>');
        }
        $popup.fadeIn();

        $popup.find('.btn_close_popup').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtilNew.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtilNew.close();
            }
        });
        $popup.find('.btn_popup_cancel').on('click', function(){
            if($popup.prop('id')) {
                Dmall.LayerPopupUtilNew.close($popup.prop('id'));
            } else {
                Dmall.LayerPopupUtilNew.close();
            }
        });
    },


    /**
     * <pre>
     * 함수명 : close
     * 설  명 : LayerPopupUtil 내부에서 호출하는 레이어 팝업 숨김 함수
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
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
    }
};

//아이디 검증
function idCheck(val){
    if(Dmall.validation.isEmpty(val)) {
        $('#id_success_div').attr('style','display:none;');
        Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
        return false;
    }
    var spc = "!#$%&*+-./=?@^` {|}";
    for(var i=0;i<val.length;i++) {
        if (spc.indexOf(val.substring(i, i+1)) >= 0) {
            Dmall.LayerUtil.alert("특수문자나 공백을 입력할 수 없습니다.", "확인");
            return false;
        }
    }
    if (val.length<5 || val.length>20){
        Dmall.LayerUtil.alert("아이디는 5~20자입니다.", "확인");
        return false;
    }
    var hanExp = jQuery('#sellerId').val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
    if( hanExp > -1 ){
        Dmall.LayerUtil.alert("한글은 아이디에 사용하실수 없습니다.", "확인");
        return false;
    }
    return true;
}
