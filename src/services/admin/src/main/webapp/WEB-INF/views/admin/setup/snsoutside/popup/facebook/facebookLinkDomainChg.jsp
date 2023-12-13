<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<div id="facebookLinkDomainChgLayer" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">발급 시 주의사항: 한글도메인변환</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form id="facebookDomainForm">
            <div class="pop_con">
                <div>
                    <p class="service_detail_txt">
                        페이스북에서 연동 정보를 발급받을 때 사이트 도메인을 입력하시게 됩니다.<br>
                        이 때, 한글도메인을 입력하시고자하면 한글도메인은 반드시 퓨니코드로 변환하여 입력해 주십시오.<br>
                        만약 그렇지 않을 경우 연동을 통한 회원가입 및 로그인이 정상동작 되지 않습니다.
                    </p>
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 발급 시 주의사항: 한글도메인변환 표 입니다. 구성은  입니다.">
                            <caption>발급 시 주의사항: 한글도메인변환</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>한글도메인</th>
                                    <td>
                                        http:// <span class="intxt long2"><input type="text" id="facebookKoreanDomain" data-name="koreanDomain"></span> <button class="btn_gray">변환</button>
                                        <span class="br2"></span>
                                        (입력예시) 벨몰.com 또는 벨몰.한국
                                    </td>
                                </tr>
                                <tr>
                                    <th>변환 결과</th>
                                    <td>http:// <span class="intxt long2"><input type="text" id="facebookChgResult" data-name="chgResult"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
            </div>
        </form>
        <!-- //pop_con -->
    </div>
</div>