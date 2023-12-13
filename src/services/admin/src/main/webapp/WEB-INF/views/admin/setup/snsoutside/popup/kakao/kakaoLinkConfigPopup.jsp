<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<div id="kakaoLinkConfigLayer" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">KAKAO 로그인 설정</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form id="kakaoConfigForm">
            <input type="hidden" name="outsideLinkCd" value="03">
            <input type="hidden" name="linkUseYn" value="Y">
            <div class="pop_con">
                <div>
                    <div class="tblw mt0">
                        <table>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>Javascript Key</th>
                                <td>
                                    <span class="intxt wid100p"><input type="text" id="javascriptKey" data-name="javascriptKey" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>발급 방법 안내</th>
                                <td>
                                    <ol class="desc_list mt10 mb10 ml5">
                                        <li>1 https://developers.kakao.com/apps 접속한 후 하단의 ‘앱 개발 시작하기’ 버튼 클릭</li>
                                        <li>2 카카오계정으로 로그인</li>
                                        <li>3 앱 이름을 입력 후 ‘만들기’ 버튼 클릭 </li>
                                        <li>4 해당 앱에 대한 키값이 발급되며 3번째 항목의 Javascript 키값을 확인합니다.</li>
                                        <li>5 좌측 메뉴에서 설정 – 일반 클릭 → 페이지 중간의 플랫폼 추가 버튼 클릭</li>
                                        <li>6 ‘웹’ 클릭 → 사이트 도메인주소 입력(사용하려는 모든 도메인 주소 입력)후 추가 클릭<br><span class="point_c3">※ 필독 : 도메인은 http://bellmall.kr, http://www.bellmall.net http://m.bellmall.net 등, 모바일 도메인과 www 포함한 것과 포함하지 않은 것 모두 입력 </span></li>
                                        <li>7 추가 버튼 클릭</li>
                                        <li>8 화면의 사이트 도메인주소와 Javascript 키 값을 확인 후 관리자페이지에 위의 API Javascript Key 를 입력 하세요.</li>
                                    </ol>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btn_box txtc">
                        <button class="btn submitBtn green" data-link-cd="03" data-link-type="kakao">적용하기</button>
                    </div>


<%--                    <div class="btn_box txtr mb20">--%>
<%--                        <a href="#none" class="layerBtn btn_gray2" data-link-type="kakaoLinkIssueInfoLayer">발급방법 안내</a>--%>
<%--                        <!-- 추후 사용할것 임, 일단 주석처리 by 이동준 -->--%>
<%--                        <!-- <a href="#none" class="layerBtn btn_gray2" data-link-type="kakaoLinkDomainChgLayer">발급 시 주의사항: 한글도메인변환</a> -->--%>
<%--                    </div>--%>
<%--                    <p class="service_detail_txt">카카오로 회원가입과 로그인이 되는 쇼핑몰을 운영하고 싶으시면 아래의 정보를 설정해주십시오.</p>--%>
<%--                    <!-- tblw -->--%>
<%--                    <div class="tblw mt0">--%>
<%--                        <table summary="이표는 카카오 아이디로 로그인 설정하기 표 입니다. 구성은 Javascript Key 입니다.">--%>
<%--                            <caption>카카오 아이디로 로그인 설정하기</caption>--%>
<%--                            <colgroup>--%>
<%--                                <col width="20%">--%>
<%--                                <col width="80%">--%>
<%--                            </colgroup>--%>
<%--                            <tbody>--%>
<%--                                <tr>--%>
<%--                                    <th>Javascript Key</th>--%>
<%--                                    <td><span class="intxt wid100p"><input type="text" id="javascriptKey" data-name="javascriptKey" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span></td>--%>
<%--                                </tr>--%>
<%--                            </tbody>--%>
<%--                        </table>--%>
<%--                    </div>--%>
<%--                    <!-- //tblw -->--%>
<%--                    <p class="desc_txt bottom">--%>
<%--                        <input type="checkbox" id="chk_linkUseYn_kakao" class="blind" value="Y">--%>
<%--                        <label for="chk_linkUseYn_kakao" class="chack mr20">--%>
<%--                            <span class="ico_comm">&nbsp;</span>--%>
<%--                            사용하여 운영함--%>
<%--                        </label>--%>
<%--                    </p>--%>
<%--                    <div class="btn_box txtc">--%>
<%--                        <button class="btn submitBtn green" data-link-cd="03" data-link-type="kakao">적용하기</button>--%>
<%--                    </div>--%>
                </div>
            </div>
        </form>
        <!-- //pop_con -->
    </div>
</div>