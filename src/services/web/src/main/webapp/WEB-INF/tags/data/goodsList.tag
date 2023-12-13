<%@tag import="java.util.Map"%>
<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="상품리스트" trimDirectiveWhitespaces="true" %>
<%@ tag import="dmall.framework.common.util.SiteUtil"%>
<%@ tag import="dmall.framework.common.util.TextReplacerUtil" %>
<%@ tag import="org.apache.commons.beanutils.BeanUtils" %>
<%@ tag import="dmall.framework.common.constants.RequestAttributeConstants" %>
<%@ tag import="java.io.File" %>
<%@ tag import="net.danvi.dmall.biz.app.goods.model.GoodsVO" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="value" required="true" description="태그의 값" type="java.util.List"%>
<%@ attribute name="displayTypeCd" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="mainYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="topYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="headYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="iconYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="addClass" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="bestCtgYn" required="false" description="태그의 값" type="java.lang.String"%>

<%
    if(value == null || value.size() == 0) return;

    String skinPath = File.separator + request.getAttribute(RequestAttributeConstants.SKIN_VIEW_PATH);
    String skinFilePath = "/template/list_type_a";
    String skinType = "A";
    if(displayTypeCd == null || "".equals(displayTypeCd)){
        displayTypeCd = ((GoodsVO)value.get(0)).getDispTypeCd();
    }
    
    String rsvOnlyYn = ((GoodsVO)value.get(0)).getRsvOnlyYn();
    String preGoodsYn = ((GoodsVO)value.get(0)).getPreGoodsYn();

    /****
    * list_type_a : 5개씩노출
    * list_type_b : 1개씩노출
    * list_type_c : 4개씩노출
    * list_type_d : 2개씩노출(슬라이딩)
    * list_type_e : 2개씩노출
    *****/
    if("01".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_b";
        skinType = "B";
    } else if("02".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_a";
        skinType = "A";
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
    } else if("08".equals(displayTypeCd)) { // 몬드리안 슬라이드형(6개)
        skinFilePath = "/template/list_type_mondrian01";
        skinType = "F";
    } else if("09".equals(displayTypeCd)) { // 몬드리안 슬라이드형(7개)
        skinFilePath = "/template/list_type_mondrian02";
        skinType = "G";
    }

    GoodsVO temp = (GoodsVO)value.get(0);
    Map m;
    m = BeanUtils.describe(temp);
    String dispTitle = temp.getDispTitle();
    if( "2".equals(temp.getDispExhbtionTypeCd())){
        dispTitle = temp.getDispImgPath()+temp.getDispImgNm();
        dispTitle = "<img src='/image/image-view?type=MAIN_DISPLAY&id1="+temp.getDispImgPath()+"_"+temp.getDispImgNm()+"'>";
    }else{
        dispTitle = temp.getDispNm();
    }
    m.put("dispTitle",dispTitle);
    String header = TextReplacerUtil.getSkinFileToString(skinPath +"/template/common_header.html");
    String top = TextReplacerUtil.getSkinFileToString(skinPath + skinFilePath + "_top.html");
    String bottom = TextReplacerUtil.getSkinFileToString(skinPath + skinFilePath + "_bottom.html");

    //if("Y".equals(mainYn))out.print("<div id='main_new_product_type"+skinType+"'>");//Main page에서만 사용
    if("Y".equals(headYn))out.print(TextReplacerUtil.replace(m, header, request));//타이틀 노출여부에 따라 출력
    if(!"N".equals(topYn))out.print(TextReplacerUtil.replace(m, top, request));//반복문을 감싼 <ul>을 수동으로 지정
%>
<data:goods value="${value}" displayTypeCd="<%=displayTypeCd%>" iconYn="${iconYn}" addClass="${addClass}" rsvOnlyYn="<%=rsvOnlyYn%>" preGoodsYn="<%=preGoodsYn%>" bestCtgYn="${bestCtgYn}" />
<%
    if(!"N".equals(topYn))out.print(TextReplacerUtil.replace(m, bottom, request));//반복문을 감싼 <ul>을 수동으로 지정
   // if("Y".equals(mainYn))out.print("</div>");//Main page에서만 사용
%>