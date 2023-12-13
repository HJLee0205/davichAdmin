<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%--
<script>
function communicationPopup(){
    window.open("http://www.ftc.go.kr/info/bizinfo/communicationList.jsp", "통신판매사업자");
}

</script>

<!--- footer area --->
<div id="footer_area">
    <div class="footer_layout">
        <h1 class="f_logo">
            <img src="${_SKIN_IMG_PATH}/footer/f_logo.png" alt="하단 로고">
        </h1>
        <ul class="footer_address">
            <li><span>회사명 : ${site_info.companyNm}</span> <span>주소 : ${site_info.addrRoadnm} ${site_info.addrCmnDtl}</span> <span>TEL/FAX : ${su.phoneNumber(site_info.telNo)}/${su.phoneNumber(site_info.faxNo)}</span> <span>담당자 이메일 : ${site_info.email}</span></li>
            <li><span>대표자 : ${site_info.ceoNm}</span> <span>사업자등록번호 : ${su.bizNo(site_info.bizNo)}</span> <span>통신사업자번호 :${site_info.commSaleRegistNo}  <a href="javascript:communicationPopup();">사업자정보확인</a></span></li>
            <li><span>개인정보관리책임자 : ${site_info.privacymanager}</span></li>
        </ul>
    </div>
    <div class="copyright">
        Copyright (c) All rights reserved. Designed by ${site_info.siteNm}
    </div>
</div>
<!---// footer area --->

--%>

<ul class="address_info">				
	<li>${site_info.companyNm} | 대표 : ${site_info.ceoNm}</li>
	<li>${site_info.addrRoadnm}&nbsp;${site_info.addrCmnDtl}</li>
	<li>사업자번호 : ${site_info.bizNo}</li>
	<li>통신판매업신고 : ${site_info.commSaleRegistNo}</li>
	<li>대표번호 : ${site_info.certifySendNo}</li>
	<li class="copyright">Copyright (c) ${site_info.siteNm}. All Rights Reserved.</li>
</ul>