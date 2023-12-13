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
                my_window = window.open("", "mywindow"+i, specs );
                my_window.document.write(obj[i].content);
            }
        }else{
            if(obj[i].popupGrpCd == popupGrpCd){
                Dmall.LayerPopupUtil.open1($("#smsUseInfo_"+i));        // 서브 주문
            }
            $('.btn_alert_close').on('click', function() {
                Dmall.LayerPopupUtil.close("smsUseInfo_"+i);
            });
        }
    });
});

</script>
<c:forEach var = "popupList" items="${popup_info}" varStatus="status">
<c:if test="${popupList.popupGbCd eq 'L'}">
   <c:if test="${popupList.popupGrpCd eq 'MM'}">
        <div id="smsUseInfo_${status.index}" style="width:${popupList.widthSize}px; height:${popupList.heightSize}px; left:${popupList.pstLeft}px; top:${popupList.pstTop}px; border:8px solid #6e6e6e; background: #ffffff;display:none; position:absolute;" >
            <div class="popup_header">
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                        ${popupList.content}
            </div>
        </div>
   </c:if>
   <c:if test="${popupList.popupGrpCd eq 'SG'}">
        <div id="smsUseInfo_${status.index}" style="width:${popupList.widthSize}px; height:${popupList.heightSize}px; left:${popupList.pstLeft}px; top:${popupList.pstTop}px; border:8px solid #6e6e6e; background: #ffffff;display:none; position:absolute;" >
            <div class="popup_header">
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                        ${popupList.content}
            </div>
        </div>
   </c:if>
   <c:if test="${popupList.popupGrpCd eq 'SM'}">
        <div id="smsUseInfo_${status.index}" style="width:${popupList.widthSize}px; height:${popupList.heightSize}px; left:${popupList.pstLeft}px; top:${popupList.pstTop}px; border:8px solid #6e6e6e; background: #ffffff;display:none; position:absolute;" >
            <div class="popup_header">
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                        ${popupList.content}
            </div>
        </div>
   </c:if>
   <c:if test="${popupList.popupGrpCd eq 'SO'}">
        <div id="smsUseInfo_${status.index}" style="width:${popupList.widthSize}px; height:${popupList.heightSize}px; left:${popupList.pstLeft}px; top:${popupList.pstTop}px; border:8px solid #6e6e6e; background: #ffffff;display:none; position:absolute;" >
            <div class="popup_header">
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                        ${popupList.content}
            </div>
        </div>
   </c:if>
</c:if>
</c:forEach>