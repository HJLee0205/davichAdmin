<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="layer_upload_image" class="slayer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">상품 이미지 <span class="image-upload-title-text"></span></h2>
            <button type="button" id="btn_close_layer_upload_image" class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <form action="/admin/goods/freebie-image-upload" name="imageUploadForm" id="form_id_imageUploadForm" method="post">
                    <p class="message txtl"><span class="image-upload-title-text"></span> 사이즈 설정 값을 기준으로 노출 위치별 필요한 사이즈로 자동 등록됩니다</p>
                    <span class="br"></span>
                    <span class="intxt imgup1"><input id="file_route1" class="upload-name" type="text" value="이미지선택" disabled="disabled"></span>
                    <label class="filebtn" for="input_id_image">파일찾기</label>
                    <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                    <span class="br2"></span>
                    <span class="intxt imgup2">
                        <input type="hidden" id="hd_img_param_1" name="img_param_1" />
                        <input type="hidden" id="hd_img_param_2" name="img_param_2" />
                        <input type="hidden" id="hd_img_detail_width" name="img_detail_width" />
                        <input type="hidden" id="hd_img_detail_height" name="img_detail_height" />
                        <input type="hidden" id="hd_img_thumb_width" name="img_thumb_width" />
                        <input type="hidden" id="hd_img_thumb_height" name="img_thumb_height" />
                    </span>
                    <div class="btn_box txtc">
                        <button type="button" class="btn_green" id="btn_regist_image">등록</button>
                        <button type="button" class="close btn_red" id="btn_cancel">취소</button>
                    </div>
                </form>

            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>