<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%-- <%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %> --%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">금칙어 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                bannedSet.getBannedList();

                fn_setDefault();

                // 검색
                jQuery('#btn_id_search').on('click', bannedSet.getBannedList);
                
                jQuery(document).on('click', '#updateBanned', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    bannedSet.setBannedWordConfig();
                });
                
                // 등록 함수
                jQuery(document).on('click', '#insertBanned', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    var bannedWord = $("#bannedWord").val();
                    //var bannedWord = {bannedWord : $("#bannedWord").val()};
                    if(bannedWord==""){Dmall.LayerUtil.alert('금칙어을 입력 하세요.'); return;}

                    var template = '<span class="banned_list">' +
                        '<input type="hidden" name="bannedList" value="'+bannedWord+'">' +
                        '{{bannedWord}}<button class="cancel" ></button></span>', managerGroup = new Dmall.Template(template), td = '';

                    bannedWord = {bannedWord :'<span class="point_c6">'+bannedWord+'</span>'};

                    td += managerGroup.render(bannedWord)

                    jQuery('#div_bannedList').append(td);

                    var param = {bannedWord : $("#bannedWord").val()};
                    var url = '/admin/setup/banned-insert';
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        $("#bannedWord").val("");
                        bannedSet.getBannedList();
                    });

                });

                // 삭제 함수
                jQuery(document).on('click', '#deleteBanned', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    if($("#bannedWord").val()==""){Dmall.LayerUtil.alert('금칙어을 입력 하세요.'); return;}
                    var param = {bannedWord : $("#bannedWord").val()};
                    var url = '/admin/setup/banned-delete';
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        $("#bannedWord").val("");
                        bannedSet.getBannedList();
                    });
                });

                $(document).on('click', 'button.cancel', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    var url = '/admin/setup/banned-delete',
                        param = {bannedWord : $(this).parent().text()},
                        dfd = jQuery.Deferred();

                    console.log("param = ", param);
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if (result != null && result.success == true) {
                            dfd.resolve(result);
                            bannedSet.getBannedList();
                        } else {
                            alert(result.message);
                        }
                    });
                    return dfd.promise();

                });
            });
            
            var bannedSet = {
                bannedList : [],
                getBannedList : function() {
                    var url = '/admin/setup/banned-list',dfd = jQuery.Deferred();
                    var param = {bannedWord : ""};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template = '<span class="banned_list">' +
                            '<input type="hidden" name="bannedWord" value="{{bannedWord}}">' +
                            '{{bannedWord}}<button class="cancel" ></button></span>', managerGroup = new Dmall.Template(template), td = '';
                        
                        jQuery.each(result, function(idx, obj) {
                            var text = obj.bannedWord;
                            var searchText = jQuery("#bannedWord").val();
                            if(text.indexOf(searchText)>-1 && searchText !=""){
                                obj.bannedWord = '<span class="point_c6">'+obj.bannedWord+'</span>';
                            }
                            td += managerGroup.render(obj)
                            /*if(idx != result.length-1)td += "   ";*/
                        });

                        if(td == '') {
                            td = '데이터가 없습니다.';
                        }
                        jQuery('#div_bannedList').html(td);
                        bannedSet.bannedList = result;
                        dfd.resolve(result);
                    });

                    return dfd.promise();
                },
                setBannedWordConfig : function() {
                    if(Dmall.validate.isValid('form_banned_config')) {
                        var url = '/admin/setup/banned-config-update',
                            param = jQuery('#form_banned_config').serialize();

                        console.log("param = ", param);
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_banned_config');

                            if (result == null || result.success != true) {
                                return;
                            } else {
                                fn_get_Info();
                            }
                        });
                    }
                }
            }

            // 금칙어 제거
            function fn_banned_del(obj) {


                //if($("#bannedWord").val()==""){Dmall.LayerUtil.alert('금칙어을 입력 하세요.'); return;}

                var url = '/admin/setup/banned-delete',
                    param = {bannedWord : $(obj).parent().text()},
                    dfd = jQuery.Deferred();

                console.log("param = ", param);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    dfd.resolve(result.resultList);


                    if (result != null && result.success == true) {
                        dfd.resolve(result);
                    } else {
                        alert(result.message);
                    }
                });
                return dfd.promise();
            }

            function fn_setDefault() {
                $('input:text, textarea').val('');

                fn_get_Info();
            }

            function fn_get_Info() {
                var url = '/admin/setup/banned-config-info',
                    param = '',
                    dfd = jQuery.Deferred();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    console.log("result.data = ", result.data);
                    fn_set_result(result.data);

                    dfd.resolve(result.resultList);

                });
                return dfd.promise();
            }

            function fn_set_result(data) {
                if (!'goodsKeepDcnt' in data || !data['goodsKeepDcnt'] ) {
                    // data['goodsKeepDcnt'] = 10;
                }
                if (!'goodsKeepQtt' in data || !data['goodsKeepQtt'] ) {
                    // data['goodsKeepQtt'] = 50;
                }

                $('[data-find="banned_config"]').DataBinder(data);

                setDefaultRadioValue();
            }

            function setDefaultRadioValue() {
                $('input:radio', '#form_banned_config').each(function(){
                    var name =$(this).attr('name')
                        , $radios = $('input:radio[name='+ name +']')
                        , $radio = $radios.filter(':visible:first');

                    console.log("name = ", name);
                    if ($('input:radio[name='+ name +']:checked').length < 1) {
                        $('label[for='+ $radio.attr('id') +']').trigger('click');
                    }
                });
            }

            function fn_save() {
                if(Dmall.validate.isValid('form_banned_config')) {
                    var url = '/admin/setup/banned-config-update',
                        param = jQuery('#form_banned_config').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        console.log("result = ", result);
                        Dmall.validate.viewExceptionMessage(result, 'form_banned_config');

                        if (result == null || result.success != true) {
                            return;
                        } else {
                            $("#bannedWord").val("");
                            bannedSet.getBannedList();
                        }
                    });
                }
                return false;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span> 기본 관리<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">금칙어</h2>
            </div>
            <form:form id="form_banned_config">
                <div class="line_box">
                    <h3 class="tlth3">금칙어 관리</h3>
                    <div class="tblw">
                        <table summary="이표는 금칙어관리 표 입니다. 구성은 금칙어 설정 입니다.">
                            <caption>금칙어관리</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>사용여부 설정</th>
                                    <td id="td_bannedWordYn" data-find="banned_config" data-bind-value="bannedWordYn" data-bind-type="labelcheckbox">
                                        <label for="rdo_bannedWordYn_Y" class="radio mr20">
                                            <input type="radio" name="bannedWordYn" value="Y" id="rdo_bannedWordYn_Y" class="blind">
                                            <span class="ico_comm"></span>
                                            사용
                                        </label>
                                        <label for="rdo_bannedWordYn_N" class="radio mr20">
                                            <input type="radio" name="bannedWordYn" value="N" id="rdo_bannedWordYn_N"class="blind">
                                            <span class="ico_comm"></span>
                                            사용 안함
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>금칙어 등록</th>
                                    <td>
                                        <span class="intxt long">
                                            <input type="text" id="bannedWord" maxlength="10">
                                        </span>
                                        <a href="#none" id="insertBanned" class="btn_gray">등록</a>
                                        <span class="desc ml10">* 최대 10자(20byte)입력가능</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>등록된 금칙어</th>
                                    <td>
                                        <div class="disposal_log" style="height:400px;" id="div_bannedList">
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form:form>
        </div>
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="updateBanned">저장하기</button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
