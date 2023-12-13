<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2022/12/07
  Time: 11:07 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<div id="layer_popup_influencer_select" class="layer_popup">
    <div class="pop_wrap size3">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">인플루언서 검색</h2>
            <button class="close ico_comm">
                닫기
            </button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <form id="form_id_pop_influencer_search">
                <input type="hidden" name="memberTypeCd" value="04">
                <input type="hidden" name="page" id="hd_pop_page" value="1"/>
                <input type="hidden" name="sord" id="hd_pop_sord" value=""/>
                <!-- search_box -->
                <div class="search_box mb20">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 인플루언서 검색 표 입니다. 구성은 상품 코드, 검색어 입니다.">
                            <caption>인플루언서 검색</caption>
                            <colgroup>
                                <col width="20%"/>
                                <col width="80%"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>회원 아이디</th>
                                <td>
                                  <span class="intxt wid100p ">
                                    <input type="text" name="searchLoginId" id="txt_pop_member_id"/>
                                  </span>
                                </td>
                            </tr>
                            <tr>
                                <th>회원 닉네임</th>
                                <td>
                                  <span class="intxt wid100p ">
                                    <input type="text" name="searchNn" id="txt_pop_member_nn"/>
                                  </span>
                                </td>
                            </tr>
                            <tr>
                                <th>회원 이름</th>
                                <td>
                                  <span class="intxt wid100p ">
                                    <input type="text" name="searchName" id="txt_pop_member_nm"/>
                                  </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <button class="btn--black_small" id="btn_popup_influencer_search">검색</button>
                    </div>
                </div>
                <!-- //search_box -->
                <!-- tblh -->
                <div class="top_lay">
                    <div class="select_btn_left">
                      <span class="search_txt">
                        총 <strong class="all" id="influencer_cnt_total"></strong>명의 회원이 검색되었습니다.
                      </span>
                    </div>
                    <div class="select_btn_right">
                        <button class="btn_gray btn_popup_influencer_reg">등록</button>
                    </div>
                </div>
                <div class="tblh">
                    <table summary="이표는 상품 조회 목록입니다.">
                        <caption>다비젼 상품 목록</caption>
                        <colgroup>
                            <col width="10%">
                            <col width="100px">
                            <col width="30%">
                            <col width=30%">
                            <col width="30%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th></th>
                            <th>프로필 이미지</th>
                            <th>회원 아이디</th>
                            <th>회원 닉네임</th>
                            <th>회원 이름</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_popup_influencer_data">
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <!-- pageing -->
                    <div class="pageing"  id="div_id_pop_paging_influencer"></div>
                    <!-- //pageing -->
                </div>
                <!-- //bottom_lay -->
                <div class="btn_box txtc">
                    <button class="btn blue btn_popup_influencer_reg">등록</button>
                </div>
            </form>
        </div>
        <!-- //pop_con -->
    </div>
</div>