<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">메세지함(매장)</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
        	// 페이징 처리
    		$('.more_view').on('click', function() {
				var pageIndex = Number($('#page').val())+1;
				$("#page").val(pageIndex);
           	 	var param = $('#form_id_search').serialize();
             	var url = '${_MOBILE_PATH}/front/member/push-message-paging';
             	Dmall.AjaxUtil.loadByPost(url, param, function(result) {
             		
					if('${resultListModel.totalPages}' == pageIndex){
    		        	$('#div_id_paging').hide();
    		        }
    		        $("#page").val(pageIndex);
    		        $('.list_page_view em').text(pageIndex);
    		        $('#tbody').append(result);

    		        var article02 = (".my_qna_table02 .show");
					$(".my_qna_table02 .title").on( 'click', function () {

						$(this).toggleClass('active');
						$(".my_qna_table02 .title").not(this).removeClass('active');

						$(article02).removeClass('show').addClass('hide');

						var myArticle02 =$(this).next("tr");
						if($(myArticle02).hasClass('hide')) {
							$(article02).removeClass('show').addClass('hide');
							$(myArticle02).removeClass('hide').addClass('show');
						}
						else {
							$(myArticle02).addClass('hide').removeClass('show');
						}
					});
				});


			});
    		
            //달력
            $(function() {
                $( ".datepicker" ).datepicker();
            });
            
            //검색
            $('.btn_form').on('click', function() {
                if($("#event_start").val() == '' || $("#event_end").val() == '') {
                    Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                    return;
                }
                var data = $('#form_id_search').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('${_MOBILE_PATH}/front/member/push-message', param);
            });

        });
        
     	// 목록을 펼칠때 읽음처리
        function fn_push_confirm(obj) {
        	var $tr = $(obj);
			var d = $tr.data();
			if(d.readyn == 'N'){
				var param = {pushType:'store',pushNo:d.pushno};
				var url = MOBILE_CONTEXT_PATH+'/front/member/push-message-confirm';
			    Dmall.AjaxUtil.getJSON(url, param, function(result) {
			        if(result.success) {
			        	$tr.removeClass('no_read');
			        	$tr.data('readyn','Y');
			        	$('#newStorePushCnt').text(Number($('#newStorePushCnt').text())-1);
			        }
			    });
			}
        }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area" class="message">	
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			메세지함(매장)
		</div>		

		<!-- 분류 메뉴 추가 20190619 -->
		<div class="message_menu">
			<a href="${_MOBILE_PATH}/front/member/push-message-market">다비치 마켓<i><em>${newMarketPushCnt }</em></i></a>
			<a href="javascript:;" class="active">다비치 매장<i><em id="newStorePushCnt">${newStorePushCnt }</em></i></a>
		</div>
		
		<div class="cont_body">
			<form:form id="form_id_search" commandName="so">
				<form:hidden path="page" id="page" />
			
				<div class="filter_datepicker date_select_area">
					<input type="text" name="stAppDate" id="event_start" class="datepicker date" value="${so.stAppDate}" readonly="readonly" onkeydown="return false">
						~
						<input type="text" name="endAppDate" id="event_end" class="datepicker date" value="${so.endAppDate}" readonly="readonly" onkeydown="return false">
					<button type="button" class="btn_form">조회</button>
					<div class="btn_date_area">
						<button type="button" class="btn_date_select" style="display:none"></button>
						<button type="button" class="btn_date_select">15일</button>
						<button type="button" class="btn_date_select">1개월</button>
						<button type="button" class="btn_date_select">3개월</button>
						<button type="button" class="btn_date_select">6개월</button>
						<button type="button" class="btn_date_select">1년</button>
					</div>
				</div>

				<table class="tProduct_Board offline wd-100p my_qna_table02">
					<caption>
						<h1 class="blind">가맹점 PUSH 메세지 수신 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:22%">
						<col>
						<col style="width:13%">
						<col style="width:15%">
					</colgroup>
					<thead>
						<tr>
							<th class="textC">수신일자</th>
							<th class="textC">내용</th>
							<th class="textC">수신시간</th>
							<th class="textC">매장</th>
						</tr>
					</thead>
					<tbody id="tbody">
						<c:choose>
							<c:when test="${fn:length(resultListModel.resultList) > 0}">
                                	<c:forEach var="li" items="${resultListModel.resultList }">
                               			<tr class="title <c:if test="${li.readYn eq 'N' }">no_read</c:if>" data-readyn="${li.readYn }" data-pushno="${li.pushNo }" onClick="javascript:fn_push_confirm(this);">
                               				<td>${li.appDate }</td>
                                    		<td style="text-align:left;padding-left:10px;">${fn:substring(li.memo,0,30)}</td>
                                    		<td class="textC">${li.appTime }</td>
                                    		<td class="textC">${li.strName }</td>
                                    	</tr>
                                    	<tr class="hide">
											<td colspan="4">
												${li.memo}
												<c:if test="${li.imgUrl ne null}">
													<br><img src="${li.imgUrl}">
												</c:if>
											</td>
										</tr>
                                	</c:forEach>
                                </c:when>
							<c:otherwise>
								<tr>
                                    <th class="textC" colspan="4">수신받은 메세지가 없습니다.</th>
                                </tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
				
				<!--- 페이징 --->
				<div class="tPages" id="div_id_paging">
		            <grid:paging resultListModel="${resultListModel}" />
		        </div>
				<!---// 페이징 --->
		    </form:form>
		</div>
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->
         
    </t:putAttribute>
</t:insertDefinition>