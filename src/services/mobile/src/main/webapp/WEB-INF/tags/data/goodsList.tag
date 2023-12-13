<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="상품리스트" trimDirectiveWhitespaces="true" %>
<%@tag import="java.util.Map"%>
<%@ tag import="dmall.framework.common.util.MobileUtil"%>
<%@ tag import="dmall.framework.common.util.TextReplacerUtil" %>
<%@ tag import="org.apache.commons.beanutils.BeanUtils" %>
<%@ tag import="java.io.File" %>
<%@ tag import="java.util.Map" %>
<%@ tag import="dmall.framework.common.constants.RequestAttributeConstants" %>
<%@ tag import="net.danvi.dmall.biz.app.goods.model.GoodsVO" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="value" required="true" description="태그의 값" type="java.util.List"%>
<%@ attribute name="displayTypeCd" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="topYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="headYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="iconYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="mainPagingYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="mobileMainYn" required="false" description="태그의 값" type="java.lang.String"%>
<%
    if(value == null || value.size() == 0) return;

    String skinPath = File.separator + request.getAttribute(RequestAttributeConstants.SKIN_VIEW_PATH);
    String skinImgPath = (String) request.getAttribute(RequestAttributeConstants.SKIN_IMG_PATH);
    String skinFilePath = "/template/list_type_e";
    String skinType = "E";
    if(displayTypeCd == null || "".equals(displayTypeCd)){
        displayTypeCd = ((GoodsVO)value.get(0)).getDispTypeCd();
    }
    
    if(mobileMainYn == null || "".equals(mobileMainYn)){
    	mobileMainYn = "N";
    }
    
    String preGoodsYn = ((GoodsVO)value.get(0)).getPreGoodsYn();
    
    /****
    * 모바일 프론트는 이미지보기(2개씩노출)와 리스트보기 2개의 타입으로만 되어 있으므로
    * displayTypeCd이 리스트형이 아닐경우 이미지보기(2개씩노출)모드로 강제변경
    ****/
    /*if(!"02".equals(displayTypeCd) && !"04".equals(displayTypeCd)){
        displayTypeCd = "05";
    }*/

    /****
    * list_type_a : 5개씩노출
    * list_type_b : 1개씩노출
    * list_type_c : 4개씩노출
    * list_type_d : 2개씩노출(슬라이딩)
    * list_type_e : 2개씩노출
    *****/
    if("01".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_b";
        skinType = "A";
    } else if("02".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_a";
        skinType = "B";
    } else if("03".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_c";
        skinType = "C";
    } else if("04".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_d";
        skinType = "D";
    } else if("05".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_e";
        skinType = "E";
    } else if("06".equals(displayTypeCd)) { // 4개씩 노출 베스트 아이콘
        skinFilePath = "/template/list_type_best";
        skinType = "A";
    } else if("07".equals(displayTypeCd)) { // 관련상품,비슷한상품
        skinFilePath = "/template/list_type_with";
        skinType = "A";
    }

    GoodsVO temp = (GoodsVO)value.get(0);
    Map m;
    m = BeanUtils.describe(temp);
    /*String dispTitle = temp.getDispTitle();
    if( "2".equals(temp.getDispExhbtionTypeCd())){
        dispTitle = temp.getDispImgPath()+temp.getDispImgNm();
        dispTitle = "<img src='/image/image-view?type=MAIN_DISPLAY&id1="+temp.getDispImgPath()+"_"+temp.getDispImgNm()+"'>";
    }else{
        dispTitle = temp.getDispNm();
    }
    m.put("dispTitle",dispTitle);*/

    String header = TextReplacerUtil.getSkinFileToString(skinPath +"/template/common_header.html");
    String top = TextReplacerUtil.getSkinFileToString(skinPath + skinFilePath + "_top.html");
    String bottom = TextReplacerUtil.getSkinFileToString(skinPath + skinFilePath + "_bottom.html");
    // 메인 페이징용
    /*if("Y".equals(mainPagingYn) && !"04".equals(displayTypeCd)){
    	String mainPaging = "<!---- 페이징 ---->";
        mainPaging += "<div class=\"tPages\">";
        mainPaging += "	<ul class=\"pages\">";
        mainPaging += "		<li class=\"prev\">";
        mainPaging += "			<a href=\"#\"><img src=\""+skinImgPath+"/common/btn_prev.png\" alt=\"이전페이지로 이동\"></a>";
        mainPaging += "		</li>";
        mainPaging += "		<li class=\"active\"><span name=\"curPage\">1</span></li>";
        mainPaging += "		<li class=\"bar\">/</li>";
        mainPaging += "		<li name=\"totalPage\">10</li>";
        mainPaging += "		<li class=\"next\">";
        mainPaging += "			<a href=\"#\"><img src=\""+skinImgPath+"/common/btn_next.png\" alt=\"이전페이지로 이동\"></a>";
        mainPaging += "		</li>";
        mainPaging += "	</ul>";
        mainPaging += "</div>";
        mainPaging += "<!----// 페이징 ---->";
        bottom += mainPaging;
    }*/

    if("Y".equals(headYn))out.print(TextReplacerUtil.replace(m, header, request));
    if(!"N".equals(topYn))out.print(TextReplacerUtil.replace(m, top, request));//반복문을 감싼 <ul>을 수동으로 지정

%>
<data:goods value="${value}" displayTypeCd="<%=displayTypeCd%>" iconYn="${iconYn}" preGoodsYn="<%=preGoodsYn%>" mainPagingYn="${mainPagingYn}" mobileMainYn="<%=mobileMainYn%>"/>
<%
    if(!"N".equals(topYn))out.print(TextReplacerUtil.replace(m, bottom, request));//반복문을 감싼 <ul>을 수동으로 지정
    // if("Y".equals(mainYn))out.print("</div>");//Main page에서만 사용
%>

