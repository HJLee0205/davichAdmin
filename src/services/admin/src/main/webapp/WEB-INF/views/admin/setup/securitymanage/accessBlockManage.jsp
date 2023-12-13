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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">접속차단 IP</t:putAttribute>
    <t:putAttribute name="script">
	    <script>
            jQuery(document).ready(function() {
                // 접속제한IP사용여부 변경 이벤트 처리
                jQuery('input[name="ipConnectLimitUseYn"]').on('change', function() {
                    if(this.value === 'Y') {
                        jQuery('#h3_id_ipList, #div_id_ipList').show();
                    } else {
                        jQuery('#h3_id_ipList, #div_id_ipList').hide();
                    }
                });

                // 저장버튼 이벤트 처리
                jQuery('#a_id_save').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var url = '/admin/setup/securitymanage/SecurityManage/accessblockip-config-insert',
                            param = {
                                ipConnectLimitUseYn : jQuery('input[name="ipConnectLimitUseYn"]:checked').val()
                            };

                    jQuery('#ul_id_ipList input[type="checkbox"][value="N"]').each(function(i, o) {
                        var $o = $(o),
                                key;
                        key = 'ipList[' + i + '].ipAddr1';
                        param[key] = $o.data('ip1');
                        key = 'ipList[' + i + '].ipAddr2';
                        param[key] = $o.data('ip2');
                        key = 'ipList[' + i + '].ipAddr3';
                        param[key] = $o.data('ip3');
                        key = 'ipList[' + i + '].ipAddr4';
                        param[key] = $o.data('ip4');
                    });

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Dmall.LayerUtil.alert('저장되었습니다.');
                            reload();
                        }
                    });
                });

                // 추가버튼 이벤트 처리
                jQuery('#btn_id_add').on('click', function(e) {
                    var param = {},
                        ip1 = jQuery('#txt_id_ip1').val(),
                        ip2 = jQuery('#txt_id_ip2').val(),
                        ip3 = jQuery('#txt_id_ip3').val(),
                        ip4 = jQuery('#txt_id_ip4').val();

                    if(!validValue(ip1, ip2, ip3, ip4)) {
                        Dmall.LayerUtil.alert('잘못된 IP주소입니다.');
                        return;
                    }
                    param.setNo = 'N';
                    param.ipAddr1 = ip1 || '*';
                    param.ipAddr2 = ip2 || '*';
                    param.ipAddr3 = ip3 || '*';
                    param.ipAddr4 = ip4 || '*';
                    param.ip = param.ipAddr1 + '.' + param.ipAddr2 + '.' + param.ipAddr3 + '.' + param.ipAddr4;

                    add(param);
                    jQuery('#txt_id_ip1, #txt_id_ip2, #txt_id_ip3, #txt_id_ip4').val('');
                });

                // 검색버튼 이벤트 처리
                jQuery('#btn_id_search').on('click', function(e) {
                    var ip1 = jQuery.trim(jQuery('#txt_id_ip_srch_1').val()),
                        ip2 = jQuery.trim(jQuery('#txt_id_ip_srch_2').val()),
                        ip3 = jQuery.trim(jQuery('#txt_id_ip_srch_3').val()),
                        ip4 = jQuery.trim(jQuery('#txt_id_ip_srch_4').val()),
                        $ul = jQuery('#ul_id_ipList'),
                        selector = 'li:has(input';

                    if(ip1 != '') {
                        selector += '[data-ip1="' + ip1 +'"]';
                    }
                    if(ip2 != '') {
                        selector += '[data-ip2="' + ip2 +'"]';
                    }
                    if(ip3 != '') {
                        selector += '[data-ip3="' + ip3 +'"]';
                    }
                    if(ip4 != '') {
                        selector += '[data-ip4="' + ip4 +'"]';
                    }
                    selector += ')';

                    $ul.find('li').hide().find('label').removeClass('on')
                            .end()
                            .find('input').prop('checked', false);
                    jQuery(selector).show();
                });

                // 삭제버튼 이벤트 처리
                jQuery('#btn_id_del').on('click', function(e) {
                    var url = '/admin/setup/securitymanage/SecurityManage/accessblockip-config-delete',
                            param = {},
                            cnt = 0;

                    // 삭제할 미저장 IP 삭제
                    jQuery('#ul_id_ipList li:has(label.on input[value="N"])').remove();

                    // 삭제할 저장된 IP 정보를 요청 파라미터에 세팅
                    jQuery('#ul_id_ipList label.on input[type="checkbox"]').each(function(i, o) {
                        var $o = $(o),
                                key;

                        key = 'ipList[' + cnt + '].setNo';
                        param[key] = $o.val();
                        cnt++;
                    });

                    // 삭제할 정보가 없으면 끝
                    if(cnt < 1) return;

                    // 서버 요청
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {

                        // 성공하면 차단 IP 리스트 리로드
                        if(result.success) {
                            reload();
                        }
                    });
                });
            });

            function validValue(ip1, ip2, ip3, ip4) {
                var result = true;

                if(jQuery.trim(ip1) === '') return false;

                if (!isValid(ip1) || !isValid(ip2) || !isValid(ip3) || !isValid(ip4)) {
                    return false;
                }

                function isValid(v) {
                    var ip;
                    v = jQuery.trim(v);
                    if(v === '*' || v === '') {
                        return true;
                    }

                    ip = parseInt(v, 10);
                    if (isNaN(ip) || ip < 0 || ip >= 256) {
                        result = false;
                    }

                    return true;
                }

                return result;
            }

            function reload() {
                var url = '/admin/setup/securitymanage/SecurityManage/accessblockip-list',
                        param = {};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    jQuery('#ul_id_ipList').html('');
                    jQuery.each(result.resultList, function(i, o) {
                        o.ip = o.ipAddr1 + '.' + o.ipAddr2 + '.' + o.ipAddr3 + '.' + o.ipAddr4;
                        add(o);
                    });

                });
            }

            function add(obj) {
                var template ='<li><label class="chack mr20"><span class="ico_comm">' +
                                '<input type="checkbox" name="table" value="{{setNo}}" data-ip1="{{ipAddr1}}" data-ip2="{{ipAddr2}}" data-ip3="{{ipAddr3}}" data-ip4="{{ipAddr4}}"></span>\n{{ip}}</label></li>',
                        li;
                li = new Dmall.Template(template);
                jQuery('#ul_id_ipList').append(li.render(obj));
            }
        </script>
	</t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">접속차단 IP</h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue shot" id="a_id_save">저장하기</a>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">
                    접속차단 IP 설정
                </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 접속차단 IP 설정 표 입니다. 구성은 접속제한IP 사용여부 입니다.">
                        <caption>접속차단 IP 설정</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>접속제한IP<br>사용여부</th>
                            <td>
                                <tags:radio codeStr="Y: 사용;N: 사용안함" name="ipConnectLimitUseYn" idPrefix="radio0_" value="${po.ipConnectLimitUseYn}" />
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->

                <c:if test="${po.ipConnectLimitUseYn eq 'N'}">
                    <c:set var="hide" value=" hide" />
                </c:if>

                <h3 class="tlth3${hide}" id="h3_id_ipList">
                    접속차단 IP 상세옵션
                </h3>
                <!-- tblw -->
                <div class="tblw${hide}" id="div_id_ipList">
                    <table summary="이표는 접속차단 IP 상세옵션 표 입니다. 구성은 IP주소, 차단 IP 리스트 입니다.">
                        <caption>접속차단 IP 상세옵션</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>IP주소</th>
                            <td>
                                <span class="intxt shot3"><input value="" id="txt_id_ip1" type="text" maxlength="3"></span>
                                -
                                <span class="intxt shot3"><input value="" id="txt_id_ip2" type="text" maxlength="3"></span>
                                -
                                <span class="intxt shot3"><input value="" id="txt_id_ip3" type="text" maxlength="3"></span>
                                -
                                <span class="intxt shot3"><input value="" id="txt_id_ip4" type="text" maxlength="3"></span>
                                <button class="btn_gray" id="btn_id_add">추가</button>
                            </td>
                        </tr>
                        <tr>
                            <th>차단 IP 리스트</th>
                            <td>
                                <span class="intxt shot3"><input value="" id="txt_id_ip_srch_1" type="text" maxlength="3"></span>
                                -
                                <span class="intxt shot3"><input value="" id="txt_id_ip_srch_2" type="text" maxlength="3"></span>
                                -
                                <span class="intxt shot3"><input value="" id="txt_id_ip_srch_3" type="text" maxlength="3"></span>
                                -
                                <span class="intxt shot3"><input value="" id="txt_id_ip_srch_4" type="text" maxlength="3"></span>
                                <button class="btn_gray" id="btn_id_search">검색</button>
                                <span class="br2"></span>
                                <div class="ip_box">
                                    <ul id="ul_id_ipList">
                                        <c:forEach var="ip" items="${po.ipList}" varStatus="status">
                                        <li>
                                            <label class="chack mr20">
                                                <span class="ico_comm"><input type="checkbox" name="table" value="${ip.setNo}" data-ip1="${ip.ipAddr1}" data-ip2="${ip.ipAddr2}" data-ip3="${ip.ipAddr3}" data-ip4="${ip.ipAddr4}"></span>
                                                ${ip.ipAddr1}.${ip.ipAddr2}.${ip.ipAddr3}.${ip.ipAddr4}
                                            </label>
                                        </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <button class="btn_gray ip_cancel" id="btn_id_del">선택IP삭제</button>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
        </div>

    </t:putAttribute>
</t:insertDefinition>