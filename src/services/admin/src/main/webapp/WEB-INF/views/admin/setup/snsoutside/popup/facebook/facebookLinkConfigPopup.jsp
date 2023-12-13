<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<div id="facebookLinkConfigLayer" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">페이스북 전용앱 설정하기</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form id="facebookConfigForm">
            <div class="pop_con">
                <div>
                    <div class="btn_box txtr mb20">
                        <a href="#none" class="layerBtn btn_gray2" data-link-type="facebookLinkIssueInfoLayer">발급방법 안내</a>
                        <!-- 추후 사용할것 임, 일단 주석처리 by 이동준 -->
                        <!-- <a href="#none" class="layerBtn btn_gray2" data-link-type="facebookLinkDomainChgLayer">발급 시 주의사항: 한글도메인변환</a> -->
                    </div>
                    <p class="service_detail_txt">페이스북 전용앱으로 회원가입과 로그인, 좋아요가 되는 쇼핑몰을 운영하고 싶으시면 아래의 정보를 설정해주십시오.</p>
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 페이스북 전용앱 설정하기 표 입니다. 구성은 APP ID, APP Secret, APP Namespace 입니다.">
                            <caption>페이스북 전용앱 설정하기</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>APP ID</th>
                                    <td><span class="intxt wid100p"><input type="text" id="fbAppId" data-name="appId" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span></td>
                                </tr>
                                <tr>
                                    <th>APP Secret</th>
                                    <td><span class="intxt wid100p"><input type="text" id="fbAppSecret" data-name="appSecret" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span></td>
                                </tr>
                                <tr>
                                    <th>APP Namespace</th>
                                    <td><span class="intxt wid100p"><input type="text" id="fbAppNamespace" data-name="appNamespace" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <p class="desc_txt bottom">
                        <input type="checkbox" id="chk_linkUseYn_facebook" class="blind" value="Y">
                        <label for="chk_linkUseYn_facebook" class="chack mr20">
                            <span class="ico_comm">&nbsp;</span>
                            사용하여 운영함
                        </label>
                    </p>
                    <div class="btn_box txtc">
                        <button class="submitBtn btn green" data-link-cd="01" data-link-type="facebook">적용하기</button>
                    </div>
                </div>
            </div>
        </form>
        <!-- //pop_con -->
    </div>
</div>