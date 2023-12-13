<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2022/11/23
  Time: 5:06 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <t:putAttribute name="title">매거진 - 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {

            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">매거진</h2>
            </div>
            <form id="form_id_search">
                <input type="hidden" name="page" id="hd_page" value="1">
                <input type="hidden" name="sord" id="hd_srod" value="">
                <!-- search_box -->
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="매거진 리스트 검색 표">
                            <caption>매거진 검색</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                        </table>
                        <tbody>
                        <tr>
                            <th>등록일</th>
                            <td>
                                <tags:calendar from="fromRegDt" to="toRegDt" idPrefix="srch"/>
                            </td>
                        </tr>
                        <tr>
                            <th>카테고리</th>
                            <td>
                                <tags:checkboxs codeStr="01:눈건강;02:안경테;03:콘택트렌즈;04:안경렌즈;" name="searchCtgCd" idPrefix="searchCtgCd"/>
                                <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                            </td>
                        </tr>
                        <tr>
                            <th>전시상태</th>
                            <td>
                                <tags:checkboxs codeStr="01:전시;02:미전시;" name="searchDisplayCd" idPrefix="searchDisplayCd"/>
                                <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                            </td>
                        </tr>
                        <tr>
                            <th>검색어</th>
                            <td>
                                <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}"/>
                                <span class="intxt w100p">
                                    <input type="text" name="searchVal" id="searchVal">
                                </span>
                            </td>
                        </tr>
                        </tbody>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="btn_id_search">검색</button>
                    </div>
                </div>
                <!-- //search_box -->
                <!-- line_box -->
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                            총 <strong class="be" id="a"></strong>개의 상품이 검색되었습니다.
                            </span>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="매거진 리스트 표">
                            <caption>매거진 리스트 표</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="5%">
                                <col width="120px">
                                <col width="15%">
                                <col width="30%">
                                <col width="10%">
                                <col width="10%">
                                <col width="12%">
                                <col width="8%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack05" class="chack" onclick="chack_btn(this);">
                                        <span class="ico_comm">
                                            <input type="checkbox" name="table" id="chack05">
                                        </span>
                                    </label>
                                </th>
                                <th>No</th>
                                <th>이미지</th>
                                <th>카테고리</th>
                                <th>제목</th>
                                <th>조회수</th>
                                <th>등록일시</th>
                                <th>전시상태</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_bbsLettList">
                            <tr>
                                <td></td>
                                <td></td>
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
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div id="div_id_paging"></div>
                    </div>
                    <!-- //bottom_lay -->
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <button class="btn--big btn--big-white" id="btn_delete">선택삭제</button>
                    <button class="btn--big btn--big-white"  id="btn_display_Y">선택 전시</button>
                    <button class="btn--big btn--big-white" id="btn_display_N">선택 미전시</button>
                </div>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_regist">등록하기</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>