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
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<script>
$(document).ready(function() {
    var obj = ${popup_json};
    var popupGrpCd = jQuery("#popupGrpCd").val();
    $.each(obj, function(i) {
        var name = "cookieName_"+i;
        var search = name+"=", offset,end;
        var value = "cookieValue_"+i;
        var cookieValue = getCookie(name);
        
        /* var expdate = new Date();
        expdate.setTime(expdate.getTime() -1);
        setCookie(name,value,expdate); */
        
        //쿠기 생성
        jQuery('#cookieInsert_'+i).on('click', function(e) {
            var ckkClick = $('input:checkbox[id=today_check_'+i+']').is(':checked');
            if(ckkClick){
                var expdate = new Date();
                expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * obj[i].cookieValidPeriod);
                var name = "cookieName_"+i;
                var value = "cookieValue_"+i;
                setCookie(name,value,expdate);
            }
            
            Dmall.LayerPopupUtil.close('layerPopup_'+i);
        });
      
        if(obj[i].popupGbCd == "P"){
            var width=obj[i].widthSize;
            var height=obj[i].heightSize;
            var left = obj[i].pstLeft;
            var top = obj[i].pstTop;
            var specs = "position:absolute, width=" + width;
            specs += ",height=" + height;
            specs += ",left=" + left;
            specs += ",top=" + top;
            
            if(obj[i].popupGrpCd == popupGrpCd){
                if(cookieValue != value){
                    var frmObj = document.frmPopup;
                    var url = "/front/open-pop";
                    window.open("", "mywindow"+i, specs );
                    frmPopup.action = url;
                    frmPopup.method="post";
                    frmPopup.target = "mywindow"+i;
                    frmPopup.popupNm.value = obj[i].popupNm;
                    frmPopup.content.value = obj[i].content;
                    frmPopup.popupNo.value = i;
                    frmPopup.cookieValidPeriod.value = obj[i].cookieValidPeriod;
                    frmPopup.submit();
                }
            }
        }else{
            if(obj[i].popupGrpCd == popupGrpCd){
               if(cookieValue != value){
                   Dmall.LayerPopupUtil.open1($("#layerPopup_"+i));
               }
            }
            $('.btn_alert_close').on('click', function() {
                Dmall.LayerPopupUtil.close("layerPopup_"+i);
            });
        }
    });
});
</script>
<form name="frmPopup">
<input type="hidden" name="popupNm" id = "popupNm" >
<input type="hidden" name="content" id = "content" >
<input type="hidden" name="popupNo" id = "popupNo" >
<input type="hidden" name="cookieValidPeriod" id = "cookieValidPeriod" >

</form>
<c:forEach var = "popupList" items="${popup_info}" varStatus="status">
<c:if test="${popupList.popupGbCd eq 'L'}">
   <c:if test="${popupList.popupGrpCd eq 'MM'}">
        <div class="popup_main_day" id="layerPopup_${status.index}" style="width:${popupList.widthSize}px; height:${popupList.heightSize}px; left:${popupList.pstLeft}px; top:${popupList.pstTop}px; display:none; position:absolute;">
            <div class="popup_close">
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" style="height:20px;height:20px;" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="pop_mainimg">
                    <span>${popupList.content}</span>
                </div>
                <div class="popup_btn_area popdloat">
                    <div class="today_check">
                        <label>
                            <input type="checkbox" id="today_check_${status.index}">
                            <span></span>
                        </label>
                        <label for="today_check_${status.index}">${popupList.cookieValidPeriod}일 동안 이 창을 표시하지 않음</label>
                    </div>
                    <button type="button" id="cookieInsert_${status.index}" class="today_cancel">닫기</button>
                </div>  
            </div>
        </div>
   </c:if>
   <c:if test="${popupList.popupGrpCd eq 'SG'}">
        <div class="popup_main_day" id="layerPopup_${status.index}" style="width:${popupList.widthSize}px; height:${popupList.heightSize}px; left:${popupList.pstLeft}px; top:${popupList.pstTop}px; display:none; position:absolute;">
            <div class="popup_close">
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" style="height:20px;height:20px;" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="pop_mainimg">
                    <span>${popupList.content}</span>
                </div>
                <div class="popup_btn_area popdloat">
                    <div class="today_check">
                        <label>
                            <input type="checkbox" id="today_check_${status.index}">
                            <span></span>
                        </label>
                        <label for="today_check_${status.index}">${popupList.cookieValidPeriod}일 동안 이 창을 표시하지 않음</label>
                    </div>
                    <button type="button" id="cookieInsert_${status.index}" class="today_cancel">닫기</button>
                </div>  
            </div>
        </div>
   </c:if>
   <c:if test="${popupList.popupGrpCd eq 'SM'}">
        <div class="popup_main_day" id="layerPopup_${status.index}" style="width:${popupList.widthSize}px; height:${popupList.heightSize}px; left:${popupList.pstLeft}px; top:${popupList.pstTop}px; display:none; position:absolute;">
            <div class="popup_close">
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" style="height:20px;height:20px;" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="pop_mainimg">
                    <span>${popupList.content}</span>
                </div>
                <div class="popup_btn_area popdloat">
                    <div class="today_check">
                        <label>
                            <input type="checkbox" id="today_check_${status.index}">
                            <span></span>
                        </label>
                        <label for="today_check_${status.index}">${popupList.cookieValidPeriod}일 동안 이 창을 표시하지 않음</label>
                    </div>
                    <button type="button" id="cookieInsert_${status.index}" class="today_cancel">닫기</button>
                </div>  
            </div>
        </div>
   </c:if>
   <c:if test="${popupList.popupGrpCd eq 'SO'}">
        <div class="popup_main_day" id="layerPopup_${status.index}" style="width:${popupList.widthSize}px; height:${popupList.heightSize}px; left:${popupList.pstLeft}px; top:${popupList.pstTop}px; display:none; position:absolute;">
            <div class="popup_close">
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" style="height:20px;height:20px;" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="pop_mainimg">
                    <span>${popupList.content}</span>
                </div>
                <div class="popup_btn_area popdloat">
                    <div class="today_check">
                        <label>
                            <input type="checkbox" id="today_check_${status.index}">
                            <span></span>
                        </label>
                        <label for="today_check_${status.index}">${popupList.cookieValidPeriod}일 동안 이 창을 표시하지 않음</label>
                    </div>
                    <button type="button" id="cookieInsert_${status.index}" class="today_cancel">닫기</button>
                </div>  
            </div>
        </div>
   </c:if>
</c:if>
</c:forEach>