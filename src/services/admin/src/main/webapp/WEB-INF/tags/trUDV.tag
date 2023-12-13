<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="SMS 자동 발송 설정 페이지 tr 태그" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ tag import="java.util.List" %>
<%@ tag import="net.danvi.dmall.biz.system.util.ServiceUtil" %>
<%@ tag import="net.danvi.dmall.biz.system.model.CmnCdDtlVO" %>
<%@ tag import="net.danvi.dmall.biz.app.operation.model.SmsSendVO" %>
<%@ tag import="java.util.ArrayList" %>
<%@ attribute name="codeGrp" required="false" description="코드 그룹" %>
<%@ attribute name="usrDfn1Val" required="false" description="사용자 정의 값1" %>
<%@ attribute name="usrDfn2Val" required="false" description="사용자 정의 값2" %>
<%@ attribute name="usrDfn3Val" required="false" description="사용자 정의 값3" %>
<%@ attribute name="usrDfn4Val" required="false" description="사용자 정의 값4" %>
<%@ attribute name="usrDfn5Val" required="false" description="사용자 정의 값5" %>
<%@ attribute name="compare" required="true" type="java.util.List<net.danvi.dmall.biz.app.operation.model.SmsSendVO>" %>
<%
    List<CmnCdDtlVO> codes = ServiceUtil.listCode("SEND_TYPE_CD", usrDfn1Val, usrDfn2Val, usrDfn3Val, usrDfn4Val, usrDfn5Val);
    List<CmnCdDtlVO> codesCopy = new ArrayList<CmnCdDtlVO>(codes);

    String checkOn = "";
    String checkVal = "Y";
    String checkTog = "";

    String radioInput = "";

    String sendWords = "";
%>
<tr>
<%
    for(int i = 0; i < codesCopy.size(); i++) {
%>
    <th>
        <%= codesCopy.get(i).getDtlNm()%><br/><br/>
        <%
            try {
                if(("Y").equals(compare.get(i).getUseYn())) {
                    radioInput = "Y";
                } else {
                    radioInput = "N";
                }
            } catch (Exception e) {
                radioInput = "Y";
            }
        %>
        <label for="useYn" class="radio mr20<%= radioInput.equals("Y") ? " on" : "" %>">
            <span class="ico_comm"><input type="radio" name="<%= codesCopy.get(i).getDtlCd() %>" id="useYn" value="Y"<%= radioInput.equals("Y") ? " checked" : "" %>></span>사용
        </label>
        <label for="useYn" class="radio mr20<%= radioInput.equals("N") ? " on" : "" %>">
            <span class="ico_comm"><input type="radio" name="<%= codesCopy.get(i).getDtlCd() %>" id="useYn" value="N"<%= radioInput.equals("N") ? " checked" : "" %>></span>미사용
        </label>
    </th>
    <td>
        <%
            //System.out.println("SellerSendYn : " + compare.get(i).getSellerSendYn());

            try {
                if(("Y").equals(compare.get(i).getMemberSendYn())) {
                    checkOn = " on";
                    checkTog = " checked";
                } else {
                    checkOn = "";
                    checkTog = "";
                }
                sendWords = compare.get(i).getMemberSendWords();
                sendWords = sendWords == null || sendWords.equals("") ? "" : sendWords;
            } catch (Exception e) {
                checkOn = "";
                checkTog = "";
                sendWords = "";
            }
        %>
        <label for="memberSendYn" class="chack mr20<%= checkOn %>">
            <span class="ico_comm">
                <input type="checkbox" name="memberSendYn" id="memberSendYn" value="<%= checkVal %>"<%= checkTog %>/>
            </span>고객
        </label>
        <div class="area_byte mt0">
            <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
            <div class="txt_area">
                <textarea name="memberSendWords"><%= sendWords %></textarea>
            </div>
        </div>
        <%
            //System.out.println("SellerSendYn : " + compare.get(i).getSellerSendYn());

            try {
                if(("Y").equals(compare.get(i).getAdminSendYn())) {
                    checkOn = " on";
                    checkTog = " checked";
                } else {
                    checkOn = "";
                    checkTog = "";
                }
                sendWords = compare.get(i).getAdminSendWords();
                sendWords = sendWords == null || sendWords.equals("") ? "" : sendWords;
            } catch (Exception e) {
                checkOn = "";
                checkTog = "";
                sendWords = "";
            }
        %>
        <label for="adminSendYn" class="chack mr20<%= checkOn %>">
            <span class="ico_comm">
                <input type="checkbox" name="adminSendYn" id="adminSendYn" value="<%= checkVal %>"<%= checkTog %>/>
            </span>관리자
        </label>
        <div class="area_byte mt0">
            <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
            <div class="txt_area">
                <textarea name="adminSendWords"><%= sendWords %></textarea>
            </div>
        </div>
        <%
            //System.out.println("SellerSendYn : " + compare.get(i).getSellerSendYn());

            try {
                if(("Y").equals(compare.get(i).getSellerSendYn())) {
                    checkOn = " on";
                    checkTog = " checked";
                } else {
                    checkOn = "";
                    checkTog = "";
                }
                sendWords = compare.get(i).getSellerSendWords();
                sendWords = sendWords == null || sendWords.equals("") ? "" : sendWords;
            } catch (Exception e) {
                checkOn = "";
                checkTog = "";
                sendWords = "";
            }
        %>
        <label for="sellerSendYn" class="chack mr20<%= checkOn %>">
            <span class="ico_comm">
                <input type="checkbox" name="sellerSendYn" id="sellerSendYn" value="<%= checkVal %>"<%= checkTog %>/>
            </span>판매자
        </label>
        <div class="area_byte mt0">
            <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
            <div class="txt_area">
                <textarea name="sellerSendWords"><%= sendWords %></textarea>
            </div>
        </div>
        <%
            //System.out.println("SellerSendYn : " + compare.get(i).getSellerSendYn());

            try {
                if(("Y").equals(compare.get(i).getStoreSendYn())) {
                    checkOn = " on";
                    checkTog = " checked";
                } else {
                    checkOn = "";
                    checkTog = "";
                }
                sendWords = compare.get(i).getStoreSendWords();
                sendWords = sendWords == null || sendWords.equals("") ? "" : sendWords;
            } catch (Exception e) {
                checkOn = "";
                checkTog = "";
                sendWords = "";
            }
        %>
        <label for="storeSendYn" class="chack mr20<%= checkOn %>">
            <span class="ico_comm">
                <input type="checkbox" name="storeSendYn" id="storeSendYn" value="<%= checkVal %>"<%= checkTog %>/>
            </span>가맹점
        </label>
        <div class="area_byte mt0">
            <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
            <div class="txt_area">
                <textarea name="storeSendWords"><%= sendWords %></textarea>
            </div>
        </div>
        <%
            //System.out.println("SellerSendYn : " + compare.get(i).getSellerSendYn());

            try {
                if(("Y").equals(compare.get(i).getStaffSendYn())) {
                    checkOn = " on";
                    checkTog = " checked";
                } else {
                    checkOn = "";
                    checkTog = "";
                }
                sendWords = compare.get(i).getStaffSendWords();
                sendWords = sendWords == null || sendWords.equals("") ? "" : sendWords;
            } catch (Exception e) {
                checkOn = "";
                checkTog = "";
                sendWords = "";
            }
        %>
        <label for="staffSendYn" class="chack mr20<%= checkOn %>">
            <span class="ico_comm">
                <input type="checkbox" name="staffSendYn" id="staffSendYn" value="<%= checkVal %>"<%= checkTog %>/>
            </span>임직원
        </label>
        <div class="area_byte mt0">
            <span class="byte"><span class="ico_comm post"></span> (0 / 90 bytes)</span>
            <div class="txt_area">
                <textarea name="staffSendWords"><%= sendWords %></textarea>
            </div>
        </div>
    </td>
<%
        if(i % 2 == 1) {
%>
</tr>
<tr>
<%
        }
    }
%>
</tr>