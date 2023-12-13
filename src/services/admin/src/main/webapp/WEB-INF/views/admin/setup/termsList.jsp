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
    <t:putAttribute name="title">약관/개인정보</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            jQuery(document).ready(function() {
                admAuthConfig.getAdmGrp();

                // tab init
                var siteinfocd = $("#hid_siteInfoCd").val();
                $("li[data-site-info-cd='" + siteinfocd + "']", "#ul_tab_main").addClass("on");

                // tab click event
                $("#ul_tab_main li, #ul_tab_sub li").click(function(){
                    var site_info_cd = $(this).data("site-info-cd");

                    Dmall.FormUtil.submit('/admin/setup/config/term/terms-config-list', {siteInfoCd : site_info_cd});
                });

                // 수정 버튼 이벤트 처리
                $(document).on('click', '#tbody_id_managerGrp .btn_gray.ctrl_class_edit', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var $this = $(this);
                    var param = {
                        siteInfoCd: siteinfocd,
                        siteInfoNo: $this.siblings('input[type=hidden]').val(),
                        type: 'update'
                    }
                    Dmall.FormUtil.submit('/admin/setup/config/term/terms-config', param);
                });

                // 삭제 버튼 이벤트 처리
                $(document).on('click', '#tbody_id_managerGrp .btn_gray.ctrl_class_del', function(e) {
                    var $this = $(this);

                    Dmall.LayerUtil.confirm('삭제하시겠습니까?', function() {
                        var url = '/admin/setup/config/term/term-config-delete',
                            param = { siteInfoNo: $this.siblings('input[type=hidden]').val() };

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                admAuthConfig.getAdmGrp();
                            }
                        });
                    })
                });

                // 등록하기
                $('#btn_regist').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.FormUtil.submit('/admin/setup/config/term/terms-config', { siteInfoCd: siteinfocd, type: 'insert' });
                });

                // Valicator 셋팅
                Dmall.validate.set('form_term_info');
            });

            var admAuthConfig = {
                isChecked : false,
                admAuthGrpList : [],
                getAdmGrp : function() {
                    var url = '/admin/setup/config/term/terms-list',
                        dfd = jQuery.Deferred();
                    var site_info_cd = $("#hid_siteInfoCd").val();
                    var site_no = $("#hid_siteNo").val();
                    var param = { siteInfoCd : site_info_cd, siteNo : site_no };

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                                '<tr>' +
                                '<td>{{sortNum}}</td>' +
                                '<td class="txtl">{{title}}</td>' +
                                '<td>{{regDt}}</td>' +
                                '<td>' +
                                '<input type="hidden" value="{{siteInfoNo}}">' +
                                '<a href="#none" class="btn_gray ctrl_class_edit">수정</a> ' +
                                '<a href="#none" class="btn_gray ctrl_class_del">삭제</a>' +
                                '</td>' +
                                '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += managerGroup.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="5">데이터가 없습니다.</td></tr>';
                        }

                        jQuery('#tbody_id_managerGrp').html(tr);
                        admAuthConfig.admAuthGrpList = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_term_info', 'div_id_paging', result, 'paging_id_terms', admAuthConfig.getAdmGrp);

                        $('#cnt_total').text(result.filterdRows);
                    });

                    return dfd.promise();
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본설정<span class="step_bar"></span> 기본관리<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">약관/개인정보 </h2>
            </div>
            <div class="tab_link">
                <ul class="six long" id="ul_tab_main">
                    <li data-site-info-cd="03" data-tab-div="div_tab_site_info_03" class="_main"><a href="javascript:;">다비치회원 이용약관</a></li>
                        <%--신규 20210426--%>
                    <%--<li data-site-info-cd="09" data-tab-div="div_tab_site_info_09" class="_main"><a href="javascript:;">멤버쉽 회원약관</a></li>--%>
                    <li data-site-info-cd="10" data-tab-div="div_tab_site_info_10" class="_main"><a href="javascript:;">온라인몰 이용약관</a></li>
                        <%--// 신규 20210426--%>
                    <li data-site-info-cd="04" data-tab-div="div_tab_site_info_05" class="_main"><a href="javascript:;">개인정보 처리방침</a></li>
                    <li data-site-info-cd="22" data-tab-div="div_tab_site_info_04" class="_main"><a href="javascript:;">위치정보 이용약관</a></li>
                    <%--<li data-site-info-cd="21" data-tab-div="div_tab_site_info_06" class="_main"><a href="javascript:;">청소년 보호정책</a></li>--%>
                    <%--<li data-site-info-cd="07" data-tab-div="div_tab_site_info_07" class="_main"><a href="javascript:;">개인정보제공 제3자 제공 동의</a></li>
                    <li data-site-info-cd="08" data-tab-div="div_tab_site_info_08" class="_main"><a href="javascript:;">개인정보 처리 위탁 동의</a></li>--%>
                    <li data-site-info-cd="11" data-tab-div="div_tab_site_info_11" class="_main"><a href="javascript:;">기타이용안내</a></li>
                </ul>
            </div>
            <!-- line_box -->
            <div class="clause_box_hide edit">
                <textarea id="ta_content" name="content" class="blind"></textarea>
                <input type="hidden" id="hid_siteInfoCd" name="siteInfoCd" value="${termInfo.siteInfoCd}"/>
                <input type="hidden" id="hid_siteNo" name="siteNo" value="${termInfo.siteNo}"/>
            </div>
            <form id="form_term_info">
                <div class="line_box fri" id="div_form_term_info">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <div class="search_txt">
                                데이터 : <strong class="all" id="cnt_total">0</strong>개
                            </div>
                        </div>
                    </div>
                    <!-- search_tbl -->
                    <div class="tblh tblmany">
                        <table summary="이표는 관리자 그룹 설정 표 입니다. 구성은 No, 그룹명, 그룹레벨, 권한, 관리 입니다.">
                            <caption>약관/개인정보</caption>
                            <colgroup>
                                <col width="6%" />
                                <col width="54%" />
                                <col width="20%" />
                                <col width="20%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>No</th>
                                <th>제목</th>
                                <th>등록일시</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_managerGrp">
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <div class="pageing" id="div_id_paging"></div>
                    </div>
                </div>
            </form>
            <!-- line_box -->
        </div>
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_regist">등록하기</button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
