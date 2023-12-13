<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">관리자 권한 설정</t:putAttribute>
    <t:putAttribute name="script">
	    <script>
            $(document).ready(function() {
                // 관리자그룹 조회
                Dmall.waiting.start();
                admAuthConfig.getAdmGrp();
                admAuthConfig.getManager().done(function () {
                    Dmall.waiting.stop();
                });
                
                // 관리자그룹 팝업 초기화
                admAuthConfigPopup.init();

                // 관리자그룹추가
                $('#a_id_addAdminGrp').on('click', function(e) {
                    admAuthConfig.resetAdmGrpForm();

                    Dmall.LayerPopupUtil.open($('#layer_id_admin'));
                });

                // 관리자그룹 > 수정
                $(document).on('click', '#tbody_id_managerGrp .btn_gray.ctrl_class_edit', function() {
                    var url = '/admin/setup/base/baseInfoConfig/adminAuthConfig/manager-group-detail',
                        $this = $(this),
                        param = {authGrpNo : $this.data('auth-grp-no')};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            admAuthConfig.setAdmGrpForm(result.data);
                        }
                    });
                });

                // 관리자그룹 > 삭제
                $(document).on('click', '#tbody_id_managerGrp .btn_gray.ctrl_class_del', function(e) {
                    var $this = $(this);

                    if($this.data('auth-gb-cd') === 'A') {
                        Dmall.LayerUtil.alert("전체 권한을 가진 관리자 그룹은 삭제할 수 없습니다.");
                        return false;
                    }

                    Dmall.LayerUtil.confirm('삭제하시겠습니까?', function() {
                        var url = '/admin/setup/base/baseInfoConfig/adminAuthConfig/manager-group-delete',
                            param = {authGrpNo : $this.data('auth-grp-no')};

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                admAuthConfig.getAdmGrp();
                            }
                        });
                    });
                });

                // 검색
                $('#btn_id_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#form_id_manager input[name="page"]').val(1);

                    Dmall.waiting.start();
                    admAuthConfig.getManager().done(function () {
                        Dmall.waiting.stop();
                    });
                });
                
                // 검색(엔터)
                Dmall.FormUtil.setEnterSearch('form_id_manager', function() { $('#btn_id_search').trigger('click'); });

                // 관리자추가 > 수정
                $(document).on('click', '#tbody_id_manager tr td a.btn_gray', function() {
                    var $this = $(this);
                    var $select = $this.parents('tr').find('select[name=authGrpNo]');

                    var orgAuthGrpNo = $select.data('auth-grp-no');
                    var authGrpNo = $select.val();
                    var memberNo = $select.data('member-no');

                    var message = '';
                    if(orgAuthGrpNo == '0' && authGrpNo != '0') {
                        message = '해당 회원을 관리자로 추가하시겠습니까?';
                    }
                    if(orgAuthGrpNo != '0' && authGrpNo == '0') {
                        message = '해당 관리자를 일반회원으로 변경하시겠습니까?';
                    }
                    if(orgAuthGrpNo != '0' && authGrpNo != '0') {
                        message = '해당 관리자의 그룹을 변경하시겠습니까?';
                    }

                    Dmall.LayerUtil.confirm(message, function() {
                        var url = '/admin/setup/base/baseInfoConfig/adminAuthConfig/manager-info-insert';
                        var param = {};

                        param['list[0].memberNo'] = memberNo;
                        param['list[0].orgAuthGrpNo'] = orgAuthGrpNo;
                        param['list[0].authGrpNo'] = authGrpNo;

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                location.reload();
                            }
                        });
                    });
                });

                // 관리자추가 > 아이디
                $(document).on('click', '#tbody_id_manager tr td a.tbl_link', function() {
                    var url = '/admin/member/manage/memberinfo-detail',
                        param = { memberNo: $(this).data('member-no') };

                    Dmall.FormUtil.submit(url, param, '_new');
                });
            });

            var admAuthConfig = {
                isChecked : false,
                admAuthGrpList : [],
                getAdmGrp : function() {
                    var url = '/admin/setup/base/baseInfoConfig/adminAuthConfig/manager-group-list',
                        dfd = jQuery.Deferred();

                    Dmall.AjaxUtil.post(url, null, function(result) {
                        var template =
                                '<tr>' +
                                '   <td>{{sortNum}}</td>' +
                                '   <td>{{authNm}}</td>' +
                                '   <td>{{cnt}}</td>' +
                                '   <td class="txtl">{{menuNm}}</td>' +
                                '   <td>' +
                                '       <a href="#none" class="btn_gray ctrl_class_edit" data-auth-grp-no="{{authGrpNo}}">수정</a>' +
                                '       <a href="#none" class="btn_gray ctrl_class_del" data-auth-grp-no="{{authGrpNo}}" data-auth-gb-cd="{{authGbCd}}">삭제</a>' +
                                '   </td>' +
                                '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += managerGroup.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="5">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_managerGrp').html(tr);
                        admAuthConfig.admAuthGrpList = result.resultList;
                        dfd.resolve(result.resultList);
                    });

                    return dfd.promise();
                },
                getManager : function() {
                    var url = '/admin/setup/base/baseInfoConfig/adminAuthConfig/manager-list',
                        param = $('#form_id_manager').serialize(),
                        dfd = jQuery.Deferred();
                    Dmall.AjaxUtil.post(url, param, function(result) {
                        var template1 =
                                '<tr>' +
                                    '<td class="comma">{{sortNum}}</td>' +
                                    '<td>{{memberNm}}</td>' +
                                    '<td><a href="#none" class="tbl_link" data-member-no="{{memberNo}}">{{loginId}}</a></td>' +
                                    '<td>' +
                                        '<span class="select wid_p100p">',
                            template2 =
                                        '</span>' +
                                    '</td>' +
                                    '<td>{{joinDttm}}</td>' +
                                    '<td>{{loginDttm}}</td>' +
                                    '<td>' +
                                        '<a href="#none" class="btn_gray" data-member-no="{{memberNo}}">수정</a>' +
                                    '</td>' +
                                '</tr>',
                            managerTemplate1 = new Dmall.Template(template1),
                            managerTemplate2 = new Dmall.Template(template2),
                            tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += managerTemplate1.render(obj);
                            tr += admAuthConfig.getAdmGrpSelect(obj);
                            tr += managerTemplate2.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="7">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_manager').html(tr).find('select').trigger('change');
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_manager', 'div_id_paging', result, 'paging_id_manager', admAuthConfig.getManager);

                        Dmall.common.comma();
                    });

                    return dfd.promise();
                },
                getAdmGrpSelect : function(data) {
                    var select =
                        '<label></label>' +
                        '<select name="authGrpNo" data-auth-grp-no="' + data.authGrpNo + '" data-member-no="' + data.memberNo + '">' +
                        '<option value="0">일반회원</option>';

                    jQuery.each(admAuthConfig.admAuthGrpList, function(i, obj) {
                        select += '<option value="' + obj.authGrpNo + '"';

                        if(data.authGrpNo === obj.authGrpNo) {
                            select += ' selected="selected"';
                        }

                        select += '>' + obj.authNm + '</option>';
                    });

                    select += '</select>';
                    return select;
                },
                resetAdmGrpForm : function() {
                    var $layer = $('#layer_id_admin');
                    $layer.find('#admin_auth_pop_title').text('관리자 그룹 추가');
                    $layer.find('form')[0].reset();
                    $layer.find('input[type="checkbox"]')
                        .prop('checked', false)
                        .parents('label')
                        .removeClass("on");
                    $('#span_id_cnt').text('');
                    $('#input_id_authGrpNo').val('');
                    admAuthConfig.isChecked = false;
                },
                setAdmGrpForm : function(data) {
                    admAuthConfig.resetAdmGrpForm();

                    var $layer = $('#layer_id_admin'),
                        menuIdStr = data.menuId,
                        menuIds = [];
                    $layer.find('#admin_auth_pop_title').text('관리자 그룹 수정');
                    $layer.find('#input_id_authGrpNo').val(data.authGrpNo);
                    $layer.find('#input_id_authNm').val(data.authNm);
                    $layer.find('#span_id_cnt').text(data.cnt);

                    if (data.authGbCd === 'A') {
                        $layer.find('input[type="checkbox"][value="A"]')
                            .prop('checked', true)
                            .parents('label')
                            .addClass("on");
                    } else {
                        if(menuIdStr) {
                            menuIds = menuIdStr.split(',');
                        }

                        for (var i = 0; i < menuIds.length; i++) {
                            $layer.find('input[type="checkbox"][value="' + jQuery.trim(menuIds[i]) + '"]')
                                .prop('checked', true)
                                .parents('label')
                                .addClass("on");
                        }
                    }

                    admAuthConfig.isChecked = true;
                    Dmall.LayerPopupUtil.open($layer);
                }
            }
        </script>
	</t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span> 기본 관리<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">관리자 권한</h2>
            </div>
            <div class="line_box fri">
                <h3 class="tlth3 btn1">
                    관리자 그룹 설정
                    <div class="right">
                        <a href="#none" class="btn_gray2" id="a_id_addAdminGrp">관리자 그룹 추가</a>
                    </div>
                </h3>
                <div class="tblh tblmany">
                    <table>
                        <colgroup>
                            <col width="6%" />
                            <col width="15%" />
                            <col width="10%" />
                            <col width="54%" />
                            <col width="15%" />
                        </colgroup>
                        <thead>
                        <tr>
                            <th>No</th>
                            <th>그룹명</th>
                            <th>소속인원</th>
                            <th>권한</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_id_managerGrp">
                        </tbody>
                    </table>
                </div>
                <h3 class="tlth3 btn1">
                    관리자 추가
                    <span class="desc">&#8251; 관리자로 추가될 계정은 반드시 회원으로 가입되어있어야 합니다.</span>
                    <div class="right">
                        <form id="form_id_manager" onsubmit="return false;">
                            <input type="hidden" name="page" value="1" />
                            <span class="intxt long3 search_bar">
                                <input type="hidden" name="type" value="ALL">
                                <input name="keyword" id="input_id_keyword" placeholder="이름, 아이디, 그룹명으로 검색해 주세요." type="text" maxlength="16"/>
                            </span>
                            <button class="search_bar_btn" id="btn_id_search">검색</button>
                        </form>
                    </div>
                </h3>
                <div class="tblh">
                    <table>
                        <colgroup>
                            <col width="6%" />
                            <col width="15%" />
                            <col width="15%" />
                            <col width="" />
                            <col width="15%" />
                            <col width="15%" />
                            <col width="10%" />
                        </colgroup>
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>그룹</th>
                            <th>가입일</th>
                            <th>최근 로그인</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_id_manager">
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="bottom_lay" id="div_id_paging"></div>
            </div>
        </div>
        <%@ include file="/WEB-INF/include/popup/admGrpPopup.jsp" %>
    </t:putAttribute>
</t:insertDefinition>