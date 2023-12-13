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
<jsp:scriptlet> 
 pageContext.setAttribute("bLine", "\n"); 
</jsp:scriptlet>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">판매자</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            
            $(document).ready(function() {
            	
            	var bizOrgFileNm = "${resultModel.data.bizOrgFileNm}";
            	
            	if (bizOrgFileNm != null && bizOrgFileNm != "") {
                    var bizFile = '<a href="#none" class="tbl_link" onclick= "return fileDownload(1);">'+ bizOrgFileNm +'</a>';
	                jQuery("#bizFileInert").html(bizFile);
            	}
            	
	        	var bkCopyOrgFileNm = "${resultModel.data.bkCopyOrgFileNm}";
	        	
	        	if (bkCopyOrgFileNm != null && bkCopyOrgFileNm != "") {
	                var bkCopyFile = '<a href="#none" class="tbl_link" onclick= "return fileDownload(2);">'+ bkCopyOrgFileNm +'</a>';
	                jQuery("#bkFileInert").html(bkCopyFile);
	        	}
	                
	                
	        	var etcOrgFileNm = "${resultModel.data.etcOrgFileNm}";
	        	
	        	if (etcOrgFileNm != null && etcOrgFileNm != "") {
	                var etcFile = '<a href="#none" class="tbl_link" onclick= "return fileDownload(3);">'+ etcOrgFileNm +'</a>';
	                jQuery("#etcFileInert").html(etcFile);
	        	}   
	        	
	        	var ceoOrgFileNm = "${resultModel.data.ceoOrgFileNm}";
	        	
	        	if (ceoOrgFileNm != null && ceoOrgFileNm != "") {
	                var ceoFile = '<a href="#none" class="tbl_link" onclick= "return fileDownload(4);">'+ ceoOrgFileNm +'</a>';
	                jQuery("#ceoFileInert").html(ceoFile);
	        	}    
	        	
	        	var refOrgFileNm = "${resultModel.data.refOrgFileNm}";
	        	
	        	if (refOrgFileNm != null && refOrgFileNm != "") {
	                var refFile = '<a href="#none" class="tbl_link" onclick= "return fileDownload(5);">'+ refOrgFileNm +'</a>';
	                jQuery("#refFileInert").html(refFile);
	        	}   	        	
	        	
	        	
                //판매자 입점 리스트 화면으로 이동
                $("#viewStandSellerListBtn").on('click', function(e) {
                    location.replace("/admin/seller/stand-seller-list");
                });
                
                //판매자리스트 화면으로 이동
                $("#viewSellerListBtn").on('click', function(e) {
                    location.replace("/admin/seller/seller-list");
                });
                
                //판매자리스트 화면으로 이동
                $("#btn_update").on('click', function(e) {
                    var sellerNo = $('#sellerNo').val();;
                    Dmall.FormUtil.submit('/admin/seller/seller-detail', {sellerNo : sellerNo, inputGbn:"UPDATE"});
                });
                
                
            });
            
            function fileDownload(fileGbn){
                var url = '/admin/seller/download';
                
          		var param = {};
            	param.sellerNo = $('#sellerNo').val();
            	
            	if (fileGbn == "1") fileGbn = "biz";
            	if (fileGbn == "2") fileGbn = "bk";
            	if (fileGbn == "3") fileGbn = "etc";
            	if (fileGbn == "4") fileGbn = "ceo";
            	if (fileGbn == "5") fileGbn = "ref";
            	
            	param.fileGbn = fileGbn;
            	
                Dmall.FormUtil.submit(url, param, '_blank');
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
        <c:set var="sellerDtl" value="${resultModel.data}" />
        <c:set var="inputGbn" value="${sellerSO.inputGbn}" />
        <form id="form_id_sellerDtl" method="post">        
        <input type="hidden" name="email" id="email" value = "${sellerDtl.email}"/>
        <input type="hidden" name="managerEmail" id="managerEmail" value = "${sellerDtl.managerEmail}"/>
        <input type="hidden" name="chkSellerId" id="chkSellerId" value = ""/>
        <input type="hidden" name="inputGbn" id="inputGbn" value = "${sellerSO.inputGbn}"/>
		<input type="hidden" name="sellerNo" id="sellerNo" value="${sellerDtl.sellerNo}"/>
		<input type="hidden" name="sellerId" id="sellerId" value="${sellerDtl.sellerId}"/>
            <div class="tlt_box">
                <div class="btn_box left">
                    <c:if test="${sellerSO.inputGbn eq 'STAND-VIEW'}">
	                    <a href="#none" class="btn gray" id="viewStandSellerListBtn" style="min-width:150px;">판매자 입점 리스트</a>
	                </c:if>
                    <c:if test="${sellerSO.inputGbn eq 'VIEW'}">
	                    <a href="#none" class="btn gray" id="viewSellerListBtn">판매자리스트</a>
	                </c:if>    
                </div>

                <c:if test="${sellerSO.inputGbn eq 'STAND-VIEW'}">
	                <h2 class="tlth2">판매자 입점 내역</h2>
				</c:if>

                <c:if test="${sellerSO.inputGbn eq 'VIEW'}">
	                <h2 class="tlth2">판매자 내역</h2>
	                <div class="btn_box right">
	                	<button type="button" class="btn blue shot" id="btn_update">수정</button>
	                </div>
                </c:if>
            </div>
           
            <!-- line_box -->
            <div class="line_box fri">
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 기본정보 표 입니다. 구성은 이름/아이디, 실명확인, 성별, 생년월일, 이메일/수신여부, 핸드폰/수신여부, 전화번호, 주소 입니다.">
                        <caption>기본정보</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="35%">
                            <col width="15%">
                            <col width="">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>판매자ID</th>
                                <td>
                             		<c:out value="${sellerDtl.sellerId}" />
                             		(판매자번호 : <c:out value="${sellerDtl.sellerNo}"/>)
                                </td>
                                <th>업체명</th>
                                <td>
                             		<c:out value="${sellerDtl.sellerNm}" />
                                </td>
                            </tr>
                            <tr>
                                <th>사업자등록번호 </th>
                                <td>
                             		<c:out value="${sellerDtl.bizRegNo}" />
                                </td>
                                <th>판매자 소개</th>
                                <td>
                             		<c:out value="${sellerDtl.farmIntro}" escapeXml="false"/>
                                </td>
                            </tr>        
                            <tr>
                                <th>판매자 수수료율</th>
                                <td>
                             		<c:out value="${sellerDtl.sellerCmsRate}" /> %
                                </td>
                                <th>마켓포인트 추천인 지급 설정</th>
                                <td>
                             		<c:out value="${sellerDtl.recomPvdRate}" /> %
                                </td>
                            </tr>
                            <tr>
                                 <th>마켓포인트 지급 설정</th>
                                 <td>
                                 	<c:choose>
                                 		<c:when test="${sellerDtl.sellerSvmnGbCd eq '1'}">
		                                 	주문금액의
	                                 		<c:out value="${sellerDtl.sellerSvmnAmt}" /> %
	                                                                                을(를) 구매확정 시 지급 
                                 		</c:when>
                                 		<c:when test="${sellerDtl.sellerSvmnGbCd eq '2'}">
	                                     	주문금액의
	                                 		<c:out value="${sellerDtl.sellerSvmnAmt}" /> 금액
                                                                                       을(를) 구매확정 시 지급 
                                 		</c:when>
                                 		<c:otherwise>
                                 		</c:otherwise>
                                 	</c:choose>
                                 </td>
                                 <th>마켓포인트 사용 제한 설정(%)</th>
                                 <td>
                                 	주문금액의
                             		<c:out value="${sellerDtl.sellerSvmnMaxUseRate}" /> %
                                                                                을(를) 까지 사용가능 
                                 </td>
                             </tr>         
                             <tr>
                                 <th>마켓포인트 본사부담율</th>
                                 <td>
                             		<c:out value="${sellerDtl.svmnLoadrate}" /> %
                                 </td>
                                 <th></th>
                                 <td>
                                 </td>
                             </tr>                   
                            <tr>
                                <th>결제은행</th>
                                <td>
                             		<c:out value="${sellerDtl.paymentBankNm}" />
                                </td>
                                <th>결제계좌번호</th>
                                <td>
                             		<c:out value="${sellerDtl.paymentActNo}" />
                                </td>
                            </tr>
                            <tr>
                                <th>예금주명</th>
                                <td>
                             		<c:out value="${sellerDtl.paymentActNm}" />
                                </td>
                                <th>업태</th>
                                <td>
                             		<c:out value="${sellerDtl.bsnsCdts}" />
                                </td>
                            </tr>
                            <tr>
                                <th>종목</th>
                                <td>
                             		<c:out value="${sellerDtl.st}" />
                                </td>
                                <th>대표자명</th>
                                <td>
                             		<c:out value="${sellerDtl.ceoNm}" />
                                </td>
                            </tr>                            
                            <tr>
                                <th>대표 전화번호</th>
                                <td>
                             		<c:out value="${sellerDtl.dlgtTel}" />
                                </td>
                                <th>핸드폰번호</th>
                                <td>
                             		<c:out value="${sellerDtl.mobileNo}" />
                                </td>
                            </tr>                            
                            <tr>
                                <th>팩스</th>
                                <td>
                             		<c:out value="${sellerDtl.fax}" />
                                </td>
			                    <th>이메일</th>
			                    <td>
                             		<c:out value="${sellerDtl.email}" />
			                    </td>
			                </tr>
                            <tr class="radio_a">
                                <th>주소</th>
                                <td>
                                    <div>
	                             		<c:out value="${sellerDtl.postNo}" />
									</div>                                
                                    <div>
	                             		<c:out value="${sellerDtl.addr}" />
									</div>                                
                                    <div>
	                             		<c:out value="${sellerDtl.addrDtl}" />
									</div>                                
                                </td>
                                <th>반품지 주소 </th>
                                <td>
                                    <div>
	                             		<c:out value="${sellerDtl.retadrssPostNo}" />
									</div>                                
                                    <div>
	                             		<c:out value="${sellerDtl.retadrssAddr}" />
									</div>                                
                                    <div>
	                             		<c:out value="${sellerDtl.retadrssDtlAddr}" />
									</div>                                
                                </td>
                            </tr>
                            <tr>
                                <th>세금계산서 수신메일</th>
                                <td>
                             		<c:out value="${sellerDtl.taxbillRecvMail}" />
                                </td>
                                <th>홈페이지</th>
                                <td>
                             		<c:out value="${sellerDtl.homepageUrl}" />
                                </td>
                            </tr>
                            
                            <tr>
                                <th>담당자명 </th>
                                <td>
                             		<c:out value="${sellerDtl.managerNm}" />
                                </td>
                                <th>담당자 직급</th>
                                <td>
                             		<c:out value="${sellerDtl.managerPos}" />
                                </td>
                            </tr>
                            <tr>
                                <th>담당자 전화번호 </th>
                                <td>
                             		<c:out value="${sellerDtl.managerTelno}" />
                                </td>
                                <th>담당자 휴대폰번호</th>
                                <td>
                             		<c:out value="${sellerDtl.managerMobileNo}" />
                                </td>
                            </tr>
			                <tr>
			                    <th>담당자 이메일</th>
			                    <td>
                             		<c:out value="${sellerDtl.managerEmail}" />
			                    </td>

<%--                             <tr> --%>
<%--                                 <th>택배사</th> --%>
<%--                                 <td> --%>
<%--                              		<c:out value="${sellerDtl.courierCdNm}" /> --%>
<%--                                 </td> --%>
<%--                             </tr> --%>
<%--                             <tr> --%>
<%--                                 <th>택배비</th> --%>
<%--                                 <td> --%>
<%-- 				                    <c:choose> --%>
<%-- 				                        <c:when test="${sellerDtl.dlvrGb eq '01'}"> --%>
<!-- 	                                                                            무료 -->
<%-- 				                        </c:when> --%>
<%-- 				                        <c:when test="${sellerDtl.dlvrGb eq '02'}"> --%>
<%-- 		                                                                    상품별 배송비(유료) 개수와 상관없이 배송비  <c:out value="${sellerDtl.dlvrAmt}" /> --%>
<%-- 				                        </c:when> --%>
<%-- 				                        <c:otherwise> --%>
<%-- 	                                                                            주문합계 금액으로 배송시 부과 – 금액이   <c:out value="${sellerDtl.chrgSetAmt}" />  원 미만일 경우,  <c:out value="${sellerDtl.chrgDlvrAmt}" />  원 부과  --%>
<%-- 				                        </c:otherwise> --%>
<%-- 				                    </c:choose> --%>
<%--                                 </td> --%>
<%--                             </tr> --%>

                                <th>대표자 사진 </th>
                                <td>
                                    <span id = "ceoFileInert" ></span>
                                </td>
                            </tr>                            
                            <tr>
                                <th>사업자 등록증 파일 등록</th>
                                <td>
                                    <span id = "bizFileInert" ></span>
                                </td>
                                <th>통장 사본 파일 등록</th>
                                <td>
                                    <span id = "bkFileInert"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>기타 파일 등록</th>
                                <td>
                                    <span id = "etcFileInert"></span>
                                </td>
                                <th>참조 파일 등록</th>
                                <td>
                                    <span id = "refFileInert"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>문의내용</th>
                                <td>
                             		<c:out value="${fn:replace(sellerDtl.storeInquiryContent, bLine,'<br>')}" escapeXml="false"/>
                                </td>
                                <th>관리자 메모</th>
                                <td>
                             		<c:out value="${sellerDtl.managerMemo}" escapeXml="false"/>
                                </td>
                            </tr>                            
                                                        
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- //line_box -->
            </form>
        </div>
        
    </t:putAttribute>
</t:insertDefinition>