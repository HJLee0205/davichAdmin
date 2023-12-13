'use strict';
var console = window.console || {log:function(){}};
var Dmall = {};

// IE8인 경우 jQuery ajax 캐시를 비활성화
if(document.documentMode == 8) {
    jQuery.ajaxSetup({cache: false});
}

jQuery(document).ready(function() {
    var d = $(".bell_date_sc");
    d.mask("9999-99-99", {
        placeholder : ''
    });
    d.on('blur', function() {
        if (!Dmall.validation.isEmpty($(this).val()) && !Dmall.validation.date($(this).val())) {
            $(this).val('');
            $(this).focus();
            alert('올바르지 않은 날짜입니다.');
        }
    });

    $(".datepickerBtn").on('click', function() {
        $(this).prev().focus();
    });

    $('#a_id_logout').on('click', function(e) {
        Dmall.EventUtil.stopAnchorAction(e);
        Dmall.FormUtil.submit('/front/login/logout', {});
    });

    Dmall.design();

    // 로컬에서 개발시 개발에 이미지가 없으면 테스트서버의 이미지를 보여주기위한 임시 처리
   /* jQuery('img').on('error', function(e) {
        var $this = jQuery(this),
            src = $this.attr('src'),
            hostname = document.location.hostname;

        if(hostname.indexOf('test.com') > 0) {
            hostname = hostname.replaceAll('id1.test.com', "www.davichmarket.com")
            $this.attr('src', '//'+hostname + $this.attr('src'));
        }
        $this.off('error');
    });*/
});
/**
 * 디자인 관련 초기화 스크립트
 */
Dmall.design = function() {
    // 달력 기간 버튼
    Dmall.init.datePeriodButton();
    Dmall.init.radio();
    Dmall.init.select();
};

/**
 * 로딩 화면 처리 클래스
 */
Dmall.waiting = {
    /**
     * <pre>
     * 함수명 : start
     * 설  명 : 화면 전체에 로딩 중 처리
     * 사용법 : waiting.start()
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    start : function() {
        $.blockUI({
            message : '<img src="/front/img/ajax-loader-white.gif" alt="Loading..." />'
        });
    },
    /**
     * <pre>
     * 함수명 : start
     * 설  명 : 화면 전체에 결제처리 중 처리
     * 사용법 : waiting.payStart()
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    payStart : function() {
        $('.popup_pay_ing').show();
    },

    /**
     * <pre>
     * 함수명 : stop
     * 설  명 : 화면 전체의 로딩 중 처리 해제
     * 사용법 : waiting.stop()
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    stop : function() {
        $.unblockUI();
    },
    /**
     * <pre>
     * 함수명 : stop
     * 설  명 : 화면 전체의 결제 처리 중 처리 해제
     * 사용법 : waiting.payStop()
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    payStop : function() {
        $('.popup_pay_ing').hide();
    }
};

/**
 * 포메터 클래스
 */
Dmall.formatter = {
    /**
     * <pre>
     * 함수명 : tel
     * 설  명 : 전화번호 포멧 변경(0212345678 -&gt; 02-1234-5678)
     * 사용법 : formatter.tel('0212345678')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param tel
     *            전화번호
     * @return {String} 포메팅된 전화번호 또는 ""
     */
    tel : function(tel) {
        if (!Dmall.validation.isNull(tel)) {
            return tel.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3");
        } else {
            return "";
        }
    },

    /**
     * <pre>
     * 함수명 : fax
     * 설  명 : 팩스번호 포멧 변경(0212345678 -&gt; 02-1234-5678)
     * 사용법 : formatter.fax('0212345678')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param fax
     *            팩스번호
     * @return {String} 포메팅된 팩스번호 또는 ""
     */
    fax : function(fax) {
        if (!Dmall.validation.isNull(fax)) {
            return fax.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3");
        } else {
            return "";
        }
    },

    /**
     * <pre>
     * 함수명 : mobile
     * 설  명 : 휴대전화번호 포멧 변경(01012345678 -&gt; 010-1234-5678)
     * 사용법 : formatter.mobile('01012345678')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param no
     *            휴대전화번호
     * @return {String} 포메팅된 휴대전화번호 또는 ""
     */
    mobile : function(no) {
        if (!Dmall.validation.isNull(no)) {
            return no.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3");
        } else {
            return "";
        }
    },

    /**
     * <pre>
     * 함수명 : post
     * 설  명 : 구우편번호 포멧 변경(123456 -&gt; 123-456)
     * 사용법 : formatter.post('123456')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param no
     *            구우편번호(6자리)
     * @return {String} 포매팅된 구우편번호 또는 ""
     */
    post : function(no) {
        if (!Dmall.validation.isNull(no)) {
            return no.replace(/([0-9]{3})([0-9]{3})/, "$1-$2");
        } else {
            return "";
        }
    },

    /**
     * <pre>
     * 함수명 : bizNo
     * 설  명 : 사업자번호 포멧 변경(1234567890 -&gt; 123-45-67890)
     * 사용법 : formatter.bizNo('1234567890')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param no
     *            사업자번호
     * @return {String} 포매팅된 사업자번호 또는 ""
     */
    bizNo : function(no) {
        if (!Dmall.validation.isNull(no)) {
            return no.replace(/([0-9]{3})([0-9]{2})([0-9]{5})/, "$1-$2-$3");
        } else {
            return "";
        }
    },

    /**
     * <pre>
     * 함수명 : cprNo
     * 설  명 : 주민번호 포멧 변경(1234561234567 -&gt; 123456-1234567)
     * 사용법 : formatter.cprNo('1234561234567')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param no
     *            주민번호
     * @return {String} 포매팅된 주민번호 또는 ""
     */
    cprNo : function(no) {
        if (!Dmall.validation.isNull(no)) {
            return no.replace(/([0-9]{6})([0-9]{7})/, "$1-$2");
        } else {
            return "";
        }
    }
};

/**
 * 검증 헬퍼 클래스
 */
Dmall.validation = {

    /**
     * <pre>
     * 함수명 : date
     * 설  명 : 입력받은 문자열을 Date 형식으로 변환할 수 있는지(정상적인 날자 데이터인지) 여부 반환
     * 사용법 : validation.date('20160428')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param str
     *            yyyymmdd 또는 yymmdd 형식의 문자열
     * @return {Boolean} 정상적인 날짜 데이터 여부
     */
    date : function(str) {
        // Checks for the following valid date formats:
        // Also separates date into month, day, and year variables
        var datePat = /^(\d{2}|\d{4})(\/|-)(\d{1,2})\2(\d{1,2})$/, year, month, day;

        var matchArray = str.match(datePat); // is the format ok?
        if (matchArray == null) {
            return false;
        }
        year = matchArray[1];
        month = matchArray[3]; // parse date into variables
        day = matchArray[4];

        if (month < 1 || month > 12) { // check month range
            return false;
        }
        if (day < 1 || day > 31) {
            return false;
        }
        if ((month == 4 || month == 6 || month == 9 || month == 11) && day == 31) {
            return false
        }
        if (month == 2) { // check for february 29th
            var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));

            if (day > 29 || (day == 29 && !isleap)) {
                return false;
            }
        }
        return true; // date is valid
    },

    /**
     * <pre>
     * 함수명 : isUndefined
     * 설  명 : 입력받은 인자가 undefined 인지 여부 반환
     * 사용법 : validation.isUndefined(obj)
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * &lt;/pr&gt;
     * @param obj 문자열 또는 객체
     * @return {Boolean} undefined 여부
     *
     */
    isUndefined : function(obj) {
        return obj === undefined;
    },

    /**
     * <pre>
     * 함수명 : isNull
     * 설  명 : 입력받은 인자가 null 인지 여부 반환
     * 사용법 : validation.isNull(obj)
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param obj
     *            문자열 또는 객체
     * @return {Boolean} null 여부
     */
    isNull : function(obj) {
        return obj === null;
    },

    /**
     * <pre>
     * 함수명 : isEmpty
     * 설  명 : 입력받은 객체가 비었는지 여부 반환
     * 사용법 : validation.isEmpty(obj)
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param str
     *            문자열 또는 객체
     * @return {Boolean} 빈 값 여부
     */
    isEmpty : function(obj) {
        return Dmall.validation.isUndefined(obj) || Dmall.validation.isNull(obj) || obj === '' || obj === 'null'
                || obj.length === 0;
    }
};

/**
 * jQuery Validation Engine 을 이용한 헬퍼 클래스
 */
Dmall.validate = {
    /**
     * <pre>
     * 함수명 : set
     * 설  명 : 입력받은 인자에 해당하는 폼에 검증 엔진을 세팅
     * 사용법 : validate.set('form_id_save')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param formId
     *            폼 ID
     */
    set : function(formId) {
        $("#" + formId).validationEngine('attach', {promptPosition : "centerRight", scroll: false});
    },

    /**
     * <pre>
     * 함수명 : hide
     * 설  명 : 입력받은 인자에 해당하는 폼에 출력된 에러 메시지 툴팁을 숨김
     * 사용법 : validate.hide('form_id_save')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param formId
     *            폼 ID
     */
    hide : function(formId) {
        $("#" + formId).validationEngine("hide");
    },

    /**
     * <pre>
     * 함수명 : isValid
     * 설  명 : 입력받은 인자에 해당하는 폼의 검증 결과를 반환, 실패시 에러 메시지 툴팁이 출력됨
     * 사용법 : validate.isValid('form_id_save')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param formId
     *            폼 ID
     * @return {Boolean} 폼 검증 결과
     */
    isValid : function(formId) {
        return $("#" + formId).validationEngine("validate");
    },

    /**
     * <pre>
     * 함수명 : viewExceptionMessage
     * 설  명 : 인자로 받은 서버의 검증 결과에 오류 메시지가 있으면 이를 폼에 출력
     * 사용법 : validate.viewExceptionMessage(result, 'form_id_save')
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param result
     *            Ajax 요청후 받은 JSON형태의 결과 데이터
     * @param formId
     *            폼 ID
     */
    viewExceptionMessage : function(result, formId) {
        var error_template = '<div class="formError" style="opacity: 0.87; position: absolute; top: 1px; left: 11px; margin-top: 0;"><div class="formErrorContent">* {{msg}}<br></div></div>', template, errors, $form, error, $target;

        if (result.exError && result.exError.length > 0) {
            errors = result.exError;
        } else {
            return;
        }

        $form = jQuery('#' + formId);
        $form.validationEngine();

        jQuery.each(errors, function(idx, error) {
            template = new Template(error_template, {
                msg : error.message
            });
            $target = $form.find('input[name="' + error.name + '"], select[name="' + error.name + '"], textarea[name="'
                    + error.name + '"]');

            if ($target.length === 0) {
                Dmall.LayerUtil.alert('모델의 ' + error.name + '의 검증식이 잘못되었거나 해당 데이터가 전송시 누락되었습니다.');
                return false;
            }

            switch ($target[0].tagName) {
                case 'INPUT' :
                    switch ($target.attr('type')) {
                        case 'radio' :
                        case 'checkbox' :
                            $target = $target.parents('label:first');
                            break;
                        default :
                    }
                    break;
                default :
            }
            $target.validationEngine('showPrompt', error.message, 'error');
        });
    }
};

/**
 * 공통 클래스
 */
Dmall.common = {
    /**
     * <pre>
     * 함수명 : numeric
     * 설  명 : numeric 클래스를 가진 엘리먼트에 숫자 마스크 세팅
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    numeric : function() {
        $(".numeric").css("ime-mode", "disabled") // 한글입력 X
        .mask("#0", {
            reverse : true,
            maxlength : false
        });
    },

    /**
     * <pre>
     * 함수명 : decimal
     * 설  명 : decimal 클래스를 가진 엘리먼트에 정부 마스크 세팅
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    decimal : function() {
        $(".decimal").css("ime-mode", "disabled") // 한글입력 X
        .autoNumeric("init", {
            aSep : ',',
            aDec : '.',
            vMax : '9999999999999.9',
            vMin : '-9999999999999.9'
        });
    },
    /**
     * <pre>
     * 함수명 : phoneNumber
     * 설  명 : phoneNumber 클래스를 가진 엘리먼트에 전화번호 마스크 세팅
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    phoneNumber : function() {
        var phoneMask = function(val) {
            var mask = "000-000-00000";
            var value = val.replace(/\D/g, '');

            if (value.length > 2) {
                if (value.substring(0, 2) == "02") {
                    mask = "00-000-00000";
                    if (value.length == 10) {
                        mask = "00-0000-0000"
                    }
                } else {
                    if (value.length == 11) {
                        mask = "000-0000-0000"
                    }
                }
            }

            return mask;
        };

        var option = {
            onKeyPress : function(val, e, field, options) {
                field.mask(phoneMask.apply({}, arguments), options);
            },
            onComplete : function(val, e, field, options) {
                var mask = "000-000-00000";
                var value = val.replace(/\D/g, '');
                if (value.substring(0, 2) == "02") {
                    mask = "00-000-00000";
                    if (value.length == 10) {
                        mask = "00-0000-0000"
                    }
                } else {
                    if (value.length == 11) {
                        mask = "000-0000-0000"
                    }
                }
                field.mask(mask, options);
            }
        };

        $('.phoneNumber').mask(phoneMask, option);
    },
    /**
     * <pre>
     * 함수명 : comma
     * 설  명 : comma 클래스를 가진 엘리먼트를 숫자(콤마) 형식의 마스크를 세팅
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     */
    comma : function() {
        $('.comma').mask("#,##0", {
            reverse : true,
            maxlength : false
        });
    }
};

/**
 * 이벤트 헬퍼 클래스
 */
Dmall.EventUtil = {
    /**
     * <pre>
     * 함수명 : stopAnchorAction
     * 설  명 : 기본 이벤트 처리를 막고 이벤트의 처리의 전파를 중단시킴
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param e
     *            이벤트 객체
     */
    stopAnchorAction : function(e) {
        e.stopPropagation();
        e.preventDefault();
    }
};

/**
 * Ajax 요청 헬퍼 클래스
 */
Dmall.AjaxUtil = {
    /**
     * 결과 객체에 메시지가 있으면 출력하고 콜백 함수를 호출한다.
     *
     * @param result
     * @param callback
     */
    viewMessage : function(result, callback) {

        if (result && result.message) {
            Dmall.LayerUtil.alert(result.message).done(function() {
                callback(result);
            });
        } else {
            callback(result);
        }
    },
    /**
     *
     * <pre>
     * 함수명 : getJSON
     * 설  명 : 서버에 post 방식으로 요청하여 JSON 데이터를 결과로 반환 받는다.
     *          메시지가 있을 경우 출력한다.
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param url
     *            요청할 서버의 URL
     * @param param
     *            요청시 전송할 파라미터
     * @param callback
     *            결과를 받아 실행할 콜백함수
     */
    getJSON : function(url, param, callback) {
        Dmall.waiting.start();
        $.ajax({
            type : 'post',
            url : url,
            data : param,
            dataType : 'json'
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
    },
    getJSONwoMsg : function(url, param, callback) {
        Dmall.waiting.start();
        $.ajax({
            type : 'post',
            url : url,
            data : param,
            dataType : 'json'
        }).done(function(result) {

            if (result) {
                callback(result);
            } else {
                callback();
            }
            Dmall.waiting.stop();
        }).fail(function(result) {
            Dmall.waiting.stop();
            Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
        });
    },
    getPayCert : function(url, param, callback) {
        Dmall.waiting.start();
        $.ajax({
            type : 'post',
            url : url,
            data : param,
            dataType : 'json'
        }).done(function(result) {

            if (result) {
                callback(result);
            } else {
                callback();
            }
            Dmall.waiting.stop();
            Dmall.waiting.payStart();
        }).fail(function(result) {
            Dmall.waiting.stop();
            Dmall.waiting.payStop();
            Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
        });
    },
    post : function(url, param, callback) {

    },
    load : function(url, callback) {
        $.ajax({
            type : 'get',
            url : url,
            dataType : 'html'
        }).done(function(result) {

            if (result) {
                callback(result);
            } else {
                callback();
            }
        }).fail(function(result) {
            Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
        });
    },
    loadByPost : function(url, param, callback) {
        $.ajax({
            type : 'post',
            url : url,
            data : param,
            dataType : 'html'
        }).done(function(result) {

            if (result) {
                callback(result);
            } else {
                callback();
            }
        }).fail(function(result) {
            Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
        });
    }

};

/**
 * 공통코드 헬퍼 클래스
 */
Dmall.CodeUtil = {
    /**
     * <pre>
     * 함수명 : getCodeList
     * 설  명 : 인자로 받은 코드 그룹의 코드 목록을 조회한다.
     * 사용법 : CodeUtil.getCodeList('AUTH_GB_CD', cbFunc)
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param cdGrp
     *            조회할 코드 그룹
     * @param callback
     *            콜백함수
     */
    getCodeList : function(cdGrp, callback) {
        var url = '/admin/code/code-list', param = {
            'cdGrp' : cdGrp
        }, callback = callback || function() {
        };
        Dmall.AjaxUtil.getJSON(url, param, callback);
    },

    /**
     * <pre>
     * 함수명 : setCodeToOption
     * 설  명 : 입력받은 코드목록으로 option 태그를 생성하여 $select의 option을 변경한다.
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param codeList
     *            코드목록
     * @param $select
     *            option 태그를 붙일 select jQuery 객체
     */
    setCodeToOption : function(codeList, $select) {
        var option = '', template = new Dmall.Template('<option value="{{dtlCd}}">{{dtlNm}}</option>');
        jQuery.each(codeList, function(i, o) {
            option += template.render(o);
        });

        $select.html(option);
    },

    /**
     * <pre>
     * 함수명 : setCodeToRadio
     * 설  명 : 입력받은 코드목록으로 radio 태그를 생성하여 $parent에 추가한다.
     *          ID는 접두어에 순번으로 생성됨
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param codeList
     *            모드목록
     * @param $parent
     *            radio 태그를 붙일 부모 jQuery 객체
     * @param name
     *            생성할 radio 태그의 이름
     * @param prefix
     *            생성할 radio 태그의 ID 접두어
     */
    setCodeToRadio : function(codeList, $parent, name, prefix) {
        var radio = '', idx = 1, template = new Dmall.Template(
                '<label for="{{id}}" class="radio mr20"><span class="ico_comm"><input type="radio" name="{{name}}" id="{{id}}" value="{{dtlCd}}"></span>{{dtlNm}}</label>');
        jQuery.each(codeList, function(i, o) {
            o.name = name;
            o.id = prefix + idx++;
            radio += template.render(o);
        });

        $parent.append(radio);
    },

    /**
     * <pre>
     * 함수명 : setCodeToRadio
     * 설  명 : 입력받은 코드목록으로 checkbox 태그를 생성하여 $parent에 추가한다.
     *          ID는 접두어에 순번으로 생성됨
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. dong - 최초 생성
     * </pre>
     *
     * @param codeList
     *            모드목록
     * @param $parent
     *            checkbox 태그를 붙일 부모 jQuery 객체
     * @param name
     *            생성할 checkbox 태그의 이름
     * @param prefix
     *            생성할 checkbox 태그의 ID 접두어
     */
    setCodeToCheckbox : function(codeList, $parent, name, prefix) {
        var checkbox = '', idx = 1, template = new Dmall.Template(
                '<label for="{{id}}" class="chack mr20"><span class="ico_comm">&nbsp;</span>{{dtlNm}}</label><input type="checkbox" name="{{name}}" id="{{id}}" class="blind" value="{{value}}">');
        jQuery.each(codeList, function(i, o) {
            o.name = name;
            o.id = prefix + idx++;
            checkbox += template.render(o);
        });

        $parent.append(checkbox);
    }
};

/**
 * 파일 업로드 클래스
 * file, image, excel 함수는 jQuery.Deferred 객체를 반환하므로 done, fail등을 사용가능한다.
 *
 * @type {{file: FileUpload.file, excel: FileUpload.excel, image: FileUpload.image, fileForm: FileUpload.fileForm, upload: FileUpload.upload, checkFileSize: FileUpload.checkFileSize}}
 */
Dmall.FileUpload = {
    /**
     * <pre>
     * 함수명 : file
     * 설  명 : 간단 파일 업로드 - 업로드할 파일을 선택하면 바로 업로드
     * 사용법 :
     * 작성일 : 2016. 5. 16.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. dong - 최초 생성
     * </pre>
     * @returns
     */
    file : function() {
        return Dmall.FileUpload.fileForm("file");
    },
    /**
     * <pre>
     * 함수명 : excel
     * 설  명 : 간단 엑셀 업로드 - 업로드할 엑셀 파일을 선택하면 바로 업로드
     * 사용법 :
     * 작성일 : 2016. 5. 16.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. dong - 최초 생성
     * </pre>
     * @returns
     */
    excel : function() {
        return Dmall.FileUpload.fileForm("xls");
    },
    /**
     * <pre>
     * 함수명 : image
     * 설  명 : 간단 이미지 파일 업로드 - 업로드할 이미지 파일을 선택하면 바로 업로드
     * 사용법 :
     * 작성일 : 2016. 5. 16.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. dong - 최초 생성
     * </pre>
     * @returns
     */
    image : function(){
        return Dmall.FileUpload.fileForm("image");
    },
    /**
     * <pre>
     * 함수명 : fileForm
     * 설  명 : 간단 파일 업로드를 위한 파일 업로드 폼 생성 및 업로드 처리
     *          다른 함수들에 의해 내부적으로 호출된다.
     * 사용법 :
     * 작성일 : 2016. 5. 16.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 16. dong - 최초 생성
     * </pre>
     * @returns
     */
    fileForm : function(type) {
        $("#form_id_fileUploadForm").remove();
        var html = '',
            accept = '',
            dfd = jQuery.Deferred();
        switch(type) {
            case  'xls' :
                accept = ' accept="application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"';
                break;
            case 'image' :
                accept = ' accept="image/*"';
                break;
            default :
                break;
        }
        html += '<form name="fileUploadForm" id="form_id_fileUploadForm" method="post" class="blind">';
        html += '<input type="file" name="uploadFile" id="file_id_commonUpload" class="blind"' + accept +' />';
        html += '</form>';
        $("body").append(html);
        $("#file_id_commonUpload")
            .on('change', function() {
                $('#form_id_fileUploadForm').ajaxSubmit({
                    url : '/admin/common/file-upload'
                    , dataType : 'json'
                    , success : function(result){
                        $("#form_id_fileUploadForm").remove();
                        if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                            alert(result.message);
                        } else {
                            dfd.resolve(result);
                        }
                    }
                });
            })
            .trigger('click');

        return dfd.promise();
    },

    upload : function(formId) {
        var dfd = jQuery.Deferred(),
            $form = $('#' + formId),
            url = $form.attr("action") || '/admin/common/file-upload';

        $form.ajaxSubmit({
            url : url,
            dataType : 'json',
            success : function(result) {
                if(result.exCode != null && result.exCode != undefined && result.exCode != ""){
                    alert(result.message);
                } else {
                    dfd.resolve(result);
                }
            }
        });

        return dfd.promise();
    },
    checkFileSize : function (formId) {
        var $files = jQuery('#' + formId + ' input[type="file"]'),
            files, file;
        
        if(document.documentMode && document.documentMode < 10) {
            return true;
        }
        
        for(var i = 0, len = $files.length; i < len; i++) {
            files = $files[i].files;
            if(files&&files.length){
                for(var j = 0, l = files.length; j < l; j++) {
                    file = files[j];
    
                    // 파일 사이즈 수정 필요
                    if(file.size > Constant.file.maxSize) {
                        Dmall.LayerUtil.alert('파일 ' + file.name + '의 파일사이즈가 2MB를 초과합니다.');
                        return false;
                    }
                }
            }
        }
        return true;
    }
};

// 파일다운로드
Dmall.FileDownload = {
    download : function(filePath, fileName) {
        var url = '/front/common/common-download',
        key,
        param = {};
            for(var i = 0; i < arguments.length ; i++) {
                if(i === 0) {
                    key = "type";
                } else {
                    key = "id" + i;
                }

                param[key] = arguments[i];
            }

            Dmall.FormUtil.submit(url, param, '_blank');
    }
};

Dmall.DaumEditor = {
    html : '',
    isEditorLoad : false,
    isLoading : false,
    queue : [],
    initializedCnt : 0,
    /**
     * <pre>
     * 함수명 : init
     * 설  명 : 다음 에디터 사용을 위한 초기화 함수
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * </pre>
     */
    init : function() {
        var url = '/front/daumeditor/editor.html';
        jQuery('body').append('<form id="tx_editor_form" name="tx_editor_form" method="post" accept-charset="utf-8" />');

        $.ajax({
            async: false,
            type: 'get',
            url: url,
            dataType: 'html'
        }).done(function (result) {
            Dmall.DaumEditor.html = result;
        });

        TrexMessage.addMsg({
            '@fontfamily.NanumGothic': '나눔고딕'
        });
    },
    /**
     * <pre>
     * 함수명 : create
     * 설  명 : id에 해당하는 Textarea의 다음 에디터를 생성한다.
     *          Textarea에 데이터가 있으면 그 내용을 에디터에 노출한다.
     *          실제 에디터 생성은 create2 함수가 하고 여기선 다중 에디터 생성을 위한 데이터를 세팅한다.
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * 2016. 8. 8.  dong - 에디터 개별 설정 추가 가능하도록 수정
     * </pre>
     * @param id 다음에디터 ID
     * @param config 다음에디터 설정 객체
     */

    create : function(id, config) {
        Dmall.DaumEditor.queue.push({id: id, config: config});
        Dmall.DaumEditor.initializedCnt++;

        if(Dmall.DaumEditor.queue.length === 1) {
            Dmall.DaumEditor.next();
        }
    },
    /**
     * <pre>
     * 함수명 : next
     * 설  명 : 다중 에디터를 위한 에디터 생성 함수
     *          내부적으로 사용한다.
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * 2016. 8. 8.  dong - 에디터 개별 설정 추가 가능하도록 수정
     * </pre>
     */
    next : function() {
        var id = Dmall.DaumEditor.queue[0].id,
            config = Dmall.DaumEditor.queue[0].config;
        Dmall.DaumEditor.create2(id, config).done(function() {
            Dmall.DaumEditor.initializedCnt--;
            Dmall.DaumEditor.queue.shift();

            if (Dmall.DaumEditor.queue.length > 0) {
                Dmall.DaumEditor.next();
            }
        });
    },
    /**
     * <pre>
     * 함수명 : create2
     * 설  명 : 실제 에디터 생성 함수
     *          내부적으로 사용한다.
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * 2016. 8. 8.  dong - 에디터 개별 설정 추가 가능하도록 수정
     * </pre>
     * @param id
     * @param conf 다음 데이터 설정 객체
     * @returns
     */
    create2 : function(id, conf) {
        var html = Dmall.DaumEditor.html,
            dfd = $.Deferred();

        html = html.replace(/(id="[a-zA-Z0-9_]*)"/gi, '$1' + id + '"');
        $('#' + id).after(html);

        var config = {
            txHost: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) http://xxx.xxx.com */
            txPath: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) /xxx/xxx/ */
            txService: 'sample', /* 수정필요없음. */
            txProject: 'sample', /* 수정필요없음. 프로젝트가 여러개일 경우만 수정한다. */
            initializedId: id, /* 대부분의 경우에 빈문자열 */
            wrapper: 'tx_trex_container' + id, /* 에디터를 둘러싸고 있는 레이어 이름(에디터 컨테이너) */
            //form: 'form_id_editor, /* 등록하기 위한 Form 이름 */
            txIconPath: "/front/daumeditor/images/icon/editor/", /*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
            txDecoPath: "/front/daumeditor/images/deco/contents/", /*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
            canvas: {
                exitEditor:{
                    /*
                     desc:'빠져 나오시려면 shift+b를 누르세요.',
                     hotKey: {
                     shiftKey:true,
                     keyCode:66
                     },
                     nextElement: document.getElementsByTagName('button')[0]
                     */
                },
                styles: {
                    color: "#000000", /* 기본 글자색 */
                    fontFamily: "굴림", /* 기본 글자체 */
                    fontSize: "10pt", /* 기본 글자크기 */
                    backgroundColor: "#fff", /*기본 배경색 */
                    lineHeight: "1.5", /*기본 줄간격 */
                    padding: "8px" /* 위지윅 영역의 여백 */
                },
                showGuideArea: false
            },
            events: {
                preventUnload: false
            },
            sidebar: {
                attachbox: {
                    show: true,
                    confirmForDeleteAll: true
                }
            },
            toolbar: {
                fontfamily: {
                    options : [
                        { label: TXMSG('@fontfamily.gulim')+' (<span class="tx-txt">가나다라</span>)', title: TXMSG('@fontfamily.gulim'), data: 'Gulim,굴림,AppleGothic,sans-serif', klass: 'tx-gulim' },
                        { label: TXMSG('@fontfamily.batang')+' (<span class="tx-txt">가나다라</span>)', title: TXMSG('@fontfamily.batang'), data: 'Batang,바탕,serif', klass: 'tx-batang' },
                        { label: TXMSG('@fontfamily.dotum')+' (<span class="tx-txt">가나다라</span>)', title: TXMSG('@fontfamily.dotum'), data: 'Dotum,돋움,sans-serif', klass: 'tx-dotum' },
                        { label: TXMSG('@fontfamily.gungsuh')+' (<span class="tx-txt">가나다라</span>)', title: TXMSG('@fontfamily.gungsuh'), data: 'Gungsuh,궁서,serif', klass: 'tx-gungseo' },
                        { label: TXMSG('@fontfamily.NanumGothic')+' (<span class="tx-txt">가나다라</span>)', title: TXMSG('@fontfamily.NanumGothic'), data: 'NanumGothic', klass: 'tx-nanumgothic' },
                        { label: 'Arial (<span class="tx-txt">abcde</span>)', title: 'Arial', data: 'Arial,sans-serif', klass: 'tx-arial' },
                        { label: 'Verdana (<span class="tx-txt">abcde</span>)', title: 'Verdana', data: 'Verdana,sans-serif', klass: 'tx-verdana' },
                        { label: 'Courier New (<span class="tx-txt">abcde</span>)', title: 'Courier New', data: 'Courier New,monspace', klass: 'tx-courier-new' }
                    ]
                }
            },
            size: {
                contentWidth: 1133 /* 지정된 본문영역의 넓이가 있을 경우에 설정 */
            }
        };

        if(conf) {
            // 설정이 있으면 기본 설정에 병합
            jQuery.extend(config, conf);
        }

        EditorJSLoader.ready(function(Editor) {
            var editor = new Editor(config);

            Editor.getCanvas().observeJob(Trex.Ev.__IFRAME_LOAD_COMPLETE, function() {
                var textbox = $('#' + id);
                textbox.html(Dmall.HtmlUtil.unescape(textbox.html()));
                Editor.modify({
                    "content": document.getElementById(id)
                });
                dfd.resolve(id);
            });
            Editor.getToolbar().observeJob(Trex.Ev.__TOOL_CLICK, function (type) {
                Editor.switchEditor(id);
            });
        });

        return dfd.promise();
    },
    /**
     * <pre>
     * 함수명 : setValueToTextarea
     * 설  명 : 저장을 위하여 에디터의 데이터를 폼으로 옮긴다.
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * </pre>
     * @param id Textarea 아이디 또는 Textarea 아이디 배열
     */
    setValueToTextarea : function(id) {
        var idArray = [],
            index,
            idStr,
            $textarea,
            images,
            allAttachedImages,
            allAttachedImages,
            inputs;

        if(!jQuery.isArray(id)) {
            $textarea = jQuery('#' + id);
            Editor.switchEditor(id);
            images = Editor.getAttachments('image');
            allAttachedImages = Editor.getAttachBox().datalist;
            index = 0;
            inputs = '';

            // 에디터 내용을 Textarea에 세팅
            $textarea.val(Dmall.DaumEditor.getContent(id));
            // 기존의 첨부파일 정보가 있으면 제거
            $textarea.parents('form').find('input[name^="attachImages["], input[name^="deletedImages["]').remove();

            // 에디터에 쓰이는 첨부 이미지 처리
            for (var i = 0; i < images.length; i++) {
                // existStage는 현재 본문에 존재하는지 여부
                if (images[i].existStage) {
                    // data는 팝업에서 execAttach 등을 통해 넘긴 데이터
                    inputs += '<input type="hidden" name="attachImages[' + index + '].orgFileNm" value="' + images[i].data.filename + '" />';
                    inputs += '<input type="hidden" name="attachImages[' + index + '].tempFileNm" value="' + images[i].data.tempfilename + '" />';
                    inputs += '<input type="hidden" name="attachImages[' + index + '].fileSize" value="' + images[i].data.filesize + '" />';
                    inputs += '<input type="hidden" name="attachImages[' + index + '].temp" value="' + images[i].data.temp + '" />';
                    index++;
                }
            }

            index = 0;
            // 모든 첨부 이미지 처리
            for (var i = 0; i < allAttachedImages.length; i++) {
                // deletedMark 는 삭제된 파일
                if (allAttachedImages[i].deletedMark) {
                    inputs += '<input type="hidden" name="deletedImages[' + index + '].tempFileNm" value="' + allAttachedImages[i].data.tempfilename + '" />';
                    inputs += '<input type="hidden" name="deletedImages[' + index + '].temp" value="' + allAttachedImages[i].data.temp + '" />';
                    index++;
                }
            }

            $textarea.after(inputs);
        } else {
            idArray = id;
            for(var editorIndex = 0, length = idArray.length; editorIndex < length; editorIndex++ ) {
                idStr = idArray[editorIndex];
                $textarea = jQuery('#' + idStr);
                Editor.switchEditor(idStr);
                images = Editor.getAttachments('image');
                allAttachedImages = Editor.getAttachBox().datalist;
                index = 0;
                inputs = '';

                // 에디터 내용을 Textarea에 세팅
                $textarea.val(Dmall.DaumEditor.getContent(idStr));

                if (editorIndex === 0) {
                    $textarea.parents('form').find('input[name^="attachImages["], input[name^="deletedImages["]').remove();
                }

                // 에디터에 쓰이는 첨부 이미지 처리
                for (var i = 0; i < images.length; i++) {
                    // existStage는 현재 본문에 존재하는지 여부
                    if (images[i].existStage) {
                        // data는 팝업에서 execAttach 등을 통해 넘긴 데이터
                        inputs += '<input type="hidden" name="attachImages[' + editorIndex + '][' + index + '].orgFileNm" value="' + images[i].data.filename + '" />';
                        inputs += '<input type="hidden" name="attachImages[' + editorIndex + '][' + index + '].tempFileNm" value="' + images[i].data.tempfilename + '" />';
                        inputs += '<input type="hidden" name="attachImages[' + editorIndex + '][' + index + '].fileSize" value="' + images[i].data.filesize + '" />';
                        inputs += '<input type="hidden" name="attachImages[' + editorIndex + '][' + index + '].temp" value="' + images[i].data.temp + '" />';
                        index++;
                    }
                }

                index = 0;
                // 모든 첨부 이미지 처리
                for (var i = 0; i < allAttachedImages.length; i++) {
                    // deletedMark 는 삭제된 파일
                    if (allAttachedImages[i].deletedMark) {
                        inputs += '<input type="hidden" name="deletedImages[' + editorIndex + '][' + index + '].tempFileNm" value="' + allAttachedImages[i].data.tempfilename + '" />';
                        inputs += '<input type="hidden" name="deletedImages[' + editorIndex + '][' + index + '].temp" value="' + allAttachedImages[i].data.temp + '" />';
                        index++;
                    }
                }

                $textarea.after(inputs);
            }
        }
    },
    /**
     * <pre>
     * 함수명 : getContent
     * 설  명 : 에디터의 내용(html텍스트만, 첨부파일은 아님)을 가져온다.
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * </pre>
     * @param id 가져올 에디터에 연결된 textarea의 ID
     * @returns
     */
    getContent : function(id) {
        Editor.switchEditor(id);
        return Editor.getContent();
    },
    /**
     * <pre>
     * 함수명 : setContent
     * 설  명 : 에디터에 내용을 세팅한다.
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * </pre>
     * @param id 세팅할 에디터에 연결된 textarea의 ID
     * @param content 세팅할 내용
     */
    setContent : function(id, content) {

        if(Dmall.DaumEditor.initializedCnt > 0) {
            setTimeout(function() {
                Dmall.DaumEditor.setContent(id, content);
            }, 50)
        } else {
            Editor.switchEditor(id);
            Editor.canvas.setContent(Dmall.HtmlUtil.unescape(content));
        }
    },
    setAttachedImage : function(id, images) {
        if(Dmall.DaumEditor.initializedCnt > 0) {
            setTimeout(function() {
                Dmall.DaumEditor.setAttachedImage(id, images);
            }, 50)
        } else {
            var attachments = {};
            attachments.image = [];
            jQuery.each(images, function (index, image) {
                attachments.image.push({
                    'attacher': 'image',
                    'data': {
                        'imageurl': image.imageUrl,
                        'filename': image.fileName,
                        'tempfilename': image.tempFileName,
                        'filesize': image.fileSize,
                        'thumburl': image.thumbUrl,
                        'temp': image.temp
                    }
                });
            });
            Editor.switchEditor(id);
            Editor.modify({
                "attachments": function () { /* 저장된 첨부가 있을 경우 배열로 넘김, 위의 부분을 수정하고 아래 부분은 수정없이 사용 */
                    var allattachments = [];
                    for (var i in attachments) {
                        allattachments = allattachments.concat(attachments[i]);
                    }
                    return allattachments;
                }()
            });
        }
    },
    /**
     * <pre>
     * 함수명 : addContent
     * 설  명 : 에디터에 내용을 추가한다.
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * </pre>
     * @param id 세팅할 에디터에 연결된 textarea의 ID
     * @param content 내용
     */
    addContent : function(id, content) {
        Editor.switchEditor(id);
        Editor.getCanvas().pasteContent(content);
    },
    /**
     * <pre>
     * 함수명 : clearContent
     * 설  명 : 에디터에 내용을 초기화한다.
     * 사용법 :
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. dong - 최초 생성
     * </pre>
     * @param id 세팅할 에디터에 연결된 textarea의 ID
     */
    clearContent : function(id) {
        Editor.switchEditor(id);
        Editor.modify({
            'content': '<p></p>',
            'attachments': []
        });
        Editor.modify({
            'content': '<p></p>',
            'attachments': []
        });
    }
};

