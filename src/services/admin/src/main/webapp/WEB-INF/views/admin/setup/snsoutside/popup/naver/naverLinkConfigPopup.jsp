<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<div id="naverLinkConfigLayer" class="layer_popup">
    <div class="pop_wrap size3">
        <div class="pop_tlt">
            <h2 class="tlth2">NAVER 로그인 설정</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <form id="naverConfigForm" method="post" accept-charset="utf-8" enctype="multipart/form-data">
            <input type="hidden" id="naverLinkOperYn" name="linkOperYn"/>
            <!-- 네이버 설정은 submit을 따로 관리하기 때문에 외부연동 코드를 고정으로해도 상관없다. -->
            <input type="hidden" name="outsideLinkCd" value="02"/>
            <input type="hidden" name="linkUseYn" value="Y">
            <div class="pop_con">
                <div>
                    <div class="tblw mt0">
                        <table>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>타이틀</th>
                                <td>
                                    <span class="intxt wid70p"><input type="text" id="spmallNm" name="spmallNm" data-name="spmallNm" maxlength="16" data-validation-engine="validate[maxSize[16]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>도메인</th>
                                <td>
                                    <span class="intxt wid70p"><input type="text" id="domainReg" name="domainReg" data-name="domainReg" maxlength="50" data-validation-engine="validate[maxSize[50]]"></span><br>
                                    <span class="desc"> ( http: // 없이 입력 )</span>
                                    <ul class="desc_list mb0">
                                        <li>현재 운영하고 있는 쇼핑몰의 실제 도메인을 입력해주세요.</li>
                                        <li>정식도메인이 없을 경우 임시도메인으로도 등록가능합니다.</li>
                                        <li>모바일도메인은 자동등록됩니다. (예: http://m/도메인)</li>
                                        <li>2개 이상 도메인 사용 시 하나만 등록해도 모두 연동 가능합니다.</li>
                                    </ul>
                                </td>
                            </tr>
                            <tr>
                                <th>Client ID</th>
                                <td>
                                    <span class="intxt wid70p"><input type="text" id="appId" name="appId" data-name="appId" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>Client Secret</th>
                                <td>
                                    <span class="intxt wid70p"><input type="text" id="appSecret" name="appSecret" data-name="appSecret" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>로고 이미지</th>
                                <td>
                                    <span class="intxt imgup2">
                                        <input type="text" id="spmallLogoImg" class="upload-name" name="spmallLogoImg" data-name="spmallLogoImg" value="" readonly>
                                    </span>
                                    <label class="filebtn on" for="input_id_image">파일첨부
                                        <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                                    </label>
                                    <div class="upload_file"></div>
                                    <!-- <div id="naverImgWrap"><span id="fileImg" width="110" height="110" style="position:relative; float:left; cursor:pointer; background-image:url(/image/image-view?type=NAVERLOGO&amp;id1=); background-repeat:no-repeat"><input type="file" id="updateBtn" name="uploadFile" style="position：absolute; margin-left:-10px; width:110px; height:110px; filter:alpha(opacity=0); opacity:0; -moz-opacity:0; cursor:pointer;"></span></div> -->
                                    <!-- 이미지 사이즈를 검증하기 위한 가짜이미지 태그 -->
                                    <img id="tempImg" style="display:block">
                                    <ul class="desc_list mb0" style="clear:both">
                                        <li>네이버 아이디 로그인 연동 과정에서 사용자에게 노출되는 이미지입니다.</li>
                                        <li>110*110사이즈 jpg/png/gif 확장자로 500KB 이하의 파일을 업로드 해주세요.</li>
                                    </ul>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btn_box txtc">
                        <button type="button" class="btn submitBtn green" data-link-cd="02" data-link-type="naver">수정신청</button>
                    </div>


<%--                    <p class="desc_txt top">아래의 정보를 정확히 설정해주십시오.</p>--%>
<%--                    <!-- tblw -->--%>
<%--                    <div class="tblw mt0">--%>
<%--                        <table summary="이표는 네이버 아이디로 로그인 설정하기 표 입니다. 구성은  입니다.">--%>
<%--                            <caption>네이버 아이디로 로그인 설정하기</caption>--%>
<%--                            <colgroup>--%>
<%--                                <col width="20%">--%>
<%--                                <col width="80%">--%>
<%--                            </colgroup>--%>
<%--                            <tbody>--%>
<%--                                <tr>--%>
<%--                                    <th>쇼핑몰 이름</th>--%>
<%--                                    <td>--%>
<%--                                        <span class="intxt wid100p"><input type="text" id="spmallNm" name="spmallNm" data-name="spmallNm" maxlength="16" data-validation-engine="validate[maxSize[16]]"></span>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <th>도메인 등록</th>--%>
<%--                                    <td>--%>
<%--                                        http:// <span class="intxt long2"><input type="text" id="domainReg" name="domainReg" data-name="domainReg" maxlength="50" data-validation-engine="validate[maxSize[50]]"></span>--%>
<%--                                        <ul class="desc_list mb0">--%>
<%--                                            <li>현재 운영하고 있는 쇼핑몰의 실제 도메인(정식도메인)을 입력해주세요.</li>--%>
<%--                                            <li>정식도메인이 없을 경우 임시도메인으로도 등록가능합니다.</li>--%>
<%--                                            <li>모바일도메인(http://m/자사도메인)은 자동등록됩니다.</li>--%>
<%--                                            <li>2개 이상 도메인 사용 시 하나만 등록해도 모두 연동 가능합니다.</li>--%>
<%--                                        </ul>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <th>Client ID</th>--%>
<%--                                    <td><span class="intxt wid100p"><input type="text" id="appId" name="appId" data-name="appId" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span></td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <th>Client Secret</th>--%>
<%--                                    <td><span class="intxt wid100p"><input type="text" id="appSecret" name="appSecret" data-name="appSecret" maxlength="100" data-validation-engine="validate[maxSize[100]]"></span></td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <th>쇼핑몰 <br>로고 이미지</th>--%>
<%--                                    <td>--%>
<%--                                        <input type="hidden" id="spmallLogoImg" class="upload-name" name="spmallLogoImg" data-name="spmallLogoImg"/>--%>
<%--                                        <div id="naverImgWrap"></div>--%>
<%--                                        <!-- 이미지 사이즈를 검증하기 위한 가짜이미지 태그 -->--%>
<%--                                        <img id="tempImg" style="display:none"/>--%>
<%--                                        <ul class="desc_list mb0" style="clear:both">--%>
<%--                                            <li>네이버 아이디 로그인 연동 과정에서 사용자에게 노출되는 이미지입니다.</li>--%>
<%--                                            <li>권장크기는 110*110사이즈이며, jpg/png/gif만 등록 가능합니다.</li>--%>
<%--                                            <li>500KB 이하의 파일을 업로드 해주세요.</li>--%>
<%--                                        </ul>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                            </tbody>--%>
<%--                        </table>--%>
<%--                    </div>--%>
<%--                    <!-- //tblw -->--%>
<%--                    <p class="desc_txt bottom">--%>
<%--                        <input type="checkbox" id="chk_linkUseYn_naver" name="linkUseYn" class="blind" value="Y">--%>
<%--                        <label for="chk_linkUseYn_naver" class="chack mr20">--%>
<%--                            <span class="ico_comm">&nbsp;</span>--%>
<%--                            사용하여 운영함--%>
<%--                        </label>--%>
<%--                    </p>--%>
<%--                    <div class="btn_box txtc">--%>
<%--                        <button type="button" class="btn naverSubmitBtn green" data-link-cd="02" data-link-type="naver">수정신청</button>--%>
<%--                        <button type="button" class="btn close gray">취소</button>--%>
<%--                    </div>--%>
                </div>
            </div>
        </form>
        <!-- //pop_con -->
    </div>
</div>