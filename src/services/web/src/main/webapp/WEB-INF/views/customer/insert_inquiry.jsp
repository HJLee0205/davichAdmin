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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">1:1문의</t:putAttribute>


	<t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
        // 게시글 등록 함수
        jQuery('#insertInquiry').on('click', function(e) {
            if(jQuery('#inquiryCd').val() == 0){
                Dmall.LayerUtil.alert("문의유형을 선택해주세요.");
                return;
            }
            if(jQuery('#title').val() == ""){
                Dmall.LayerUtil.alert("제목을 입력해주세요.");
                return;
            }
            if(jQuery('#content').val() == ""){
                Dmall.LayerUtil.alert("문의글 내용을 입력해주세요.");
                return;
            }
            var url = '/front/customer/inquiry-insert';
            var param = $('#insertForm').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if (result.success) {
                    location.href = "/front/customer/inquiry-list";
                }
            })
        });
    });
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>고객센터
            </div>
        </div>
        <h2 class="sub_title">고객센터<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="customer">
            <!--- 고객센터 왼쪽 메뉴 --->
            <%@ include file="include/customer_left_menu.jsp" %>
            <!---// 고객센터 왼쪽 메뉴 --->
            <!--- 고객센터 오른쪽 컨텐츠 --->
            <div class="customer_content">
                <h3 class="customer_con_tit">
                    1:1문의
                </h3>
                <form action="/front/customer/inquiry-insert" id="insertForm" >
                <table class="tQna_Insert" style="margin-top:63px">
                    <caption>
                        <h1 class="blind">1:1문의 입력 테이블 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:130px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>문의유형</th>
                            <td>
                                <div class="select_box28" style="width:150px;">
                                    <label for="select_option">선택하세요</label>
                                    <select class="select_option" title="select option" id="inquiryCd" name="inquiryCd">
                                        <code:option codeGrp="INQUIRY_CD"  />
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td>
                                <input type="text" name="title" id="title" style="width:100%">
                            </td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td class="insert">
                                <textarea name="content" id="content" style="width:612px"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
                <div class="btn_customer_area">
                    <button type="button" class="btn_qna_insert" id="insertInquiry">문의하기</button>
                </div>
            </div>
            <!---// 고객센터 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>