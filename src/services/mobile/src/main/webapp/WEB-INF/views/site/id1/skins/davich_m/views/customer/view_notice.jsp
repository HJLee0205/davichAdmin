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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">변경해주세요</t:putAttribute>
	
	
	
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //목록
        $('.btn_notice_list').on('click', function() {
            location.href="/front/customer/notice-list";
        });
        $('.agree_notice_view a').click(function () {
            $(this).parent().next('.bottom_agree_area').slideToggle();
        });
    });

    //글 상세 보기
    function goBbsDtl(lettNo) {
        location.href="/front/customer/notice-detail?lettNo="+lettNo;
    }

    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <div class="contents">
        <!--- category header 카테고리 location과 동일 --->
        <div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			공지사항
		</div>
        <!---// category header --->
        <div class="customer">
            <!--- 고객센터 오른쪽 컨텐츠 --->
            <div class="customer_content">
                <!-- <h3 class="customer_con_tit">
                    공지사항
                    <span>새로운 이벤트 및 안내 가이드 게시글을 확인하실 수 있습니다.</span>
                </h3> -->
                <table class="tNotice_View wd-100p">
                    <caption>
                        <h1 class="blind">${resultModel}</h1>
                    </caption>
                    <colgroup>
                        <col style="width:20%">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th colspan="2" class="bbs_title">
							${resultModel.data.title}
							<span class="namedate">
								<!-- ${resultModel.data.memberNm} -->
								&nbsp; ( <fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.data.regDttm}" /> &nbsp;
                                <fmt:formatDate pattern="aa hh:mm:ss" value="${resultModel.data.regDttm}" />)
							</span>
							</th>
                        </tr>
                        <!-- <tr>
                            <th>작성자</th>
                            <td>${resultModel.data.memberNm}</td>
                            <th>게시일</th>
                            <td>
                                <fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.data.regDttm}" />
                                </br><fmt:formatDate pattern="aa hh:mm:ss" value="${resultModel.data.regDttm}" />
                            </td>
                        </tr> -->
                        <tr>
                            <td class="view" colspan="2">
                                ${resultModel.data.content}
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <c:if test="${preBbs.data ne null}">
                            <tr>
                                <th>이전글</th>
                                <td>
                                    <a href="javascript:goBbsDtl('${preBbs.data.lettNo}')">${preBbs.data.title}</a>
                                </td>
                            </tr>
                            </c:if>
                            <c:if test="${nextBbs.data ne null}">
                            <tr>
                                <th>다음글</th>
                                <td>
                                    <a href="javascript:goBbsDtl('${nextBbs.data.lettNo}')">${nextBbs.data.title}</a>
                                </td>
                            </tr>
                            </c:if>
                    </tfoot>
                </table>

                <div class="btn_customer_area">
                    <button type="button" class="btn_notice_list">목록</button>
                </div>
            </div>
            <!---// 고객센터 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>