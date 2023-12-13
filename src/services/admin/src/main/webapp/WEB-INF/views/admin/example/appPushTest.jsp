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

<script src="/admin/js/lib/jquery/jquery-1.12.2.min.js" charset="utf-8"></script>
<script src="/admin/js/lib/jquery/jquery.form.min.js" charset="utf-8"></script>

<script type="text/javascript" charset="utf-8">


jQuery(document).ready(function() {
	
    var url = '/admin/example/beacon-push',
    param = jQuery('#form_id_appSendInsert').serialize();
    
    $('#sendAppInsert').on("click", function(){
        $('#form_id_appSendInsert').ajaxSubmit({
            url : url,
            dataType : 'json',
            success : function(result){
                if(result.success){
                    alert('푸시 알림을 발송 했습니다.');
                } else {
                    alert('푸시 알림 발송이 실패했습니다.');
                }
            }
        });
    })
});


</script>

    <!-- //bottom_lay -->
    <div id = "appIndividaulSendSave">
        <h3>푸시알림 발송 </h3>
        <form id="form_id_appSendInsert" method="post">
        <!-- tblw -->
        <div class="tblw">
            <table summary="이표는 푸시알림 발송 표 입니다. ">
                <colgroup>
                    <col width="12%">
                    <col width="82%">
                </colgroup>
                <tbody>
                    <tr>
                        <th style="text-align: right;">토큰</th>
                        <td>
                        	<input type="text" name="token" style="width:1200px;" value="eLYz-Jj5R5c:APA91bHc9ikrsoPqhULEZgS7rBK8SM4LAQiuw5KqBoxbJO3yKVVaBNMfcMjA8StQA8eb7VyDp56c3VNPKionZMSXXk3cMdqot1MA9Gqz7efywxObyOES3yFdbtxcVffLgPT9FZE-bvzs">
						</td>                    
                    </tr>
                    <tr>
                        <th style="text-align: right;">OS</th>
                        <td>
                             <label id="lb_radio01" for="radio01" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="osType" value="android" id="radio01" checked="checked" /></span>안드로이드</label>
                             <label id="lb_radio02" for="radio02" class="radio mr20"><span class="ico_comm"><input type="radio" name="osType" value="ios" id="radio02" /></span>IOS</label>
						</td>                    
                    </tr>
                    <tr>
                        <th style="text-align: right;">내용</th>
                        <td>
                        	<textarea name="sendMsg" id="sendMsg" maxlength="200" style="width:600px;height:100px;"></textarea>
						</td>                    
                    </tr>
                    <tr>
                        <th style="text-align: right;">링크</th>
                        <td>
                        	<input type="text" name="link" style="width:800px;" value="https://www.davichmarket.com/front/basket/basket-list">
						</td>                    
                    </tr>
                    <tr>
                        <th style="text-align: right;">이미지</th>
                        <td>
                        	<input type="text" name="imgUrl" style="width:800px;" value="http://davichmarket.com/image/image-view?type=BANNER&id1=20180731_1533018747346.jpg">
						</td>                    
                    </tr>
                </tbody>
            </table>
        </div>
        </form>
        <div class="btn_box txtc">
            <button class="btn green" id="sendAppInsert">메시지 전송</button>
        </div>
    </div>
<!-- //app_send -->