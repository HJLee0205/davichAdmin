<%@tag import="dmall.framework.common.util.MobileUtil"%>
<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="상품리스트" trimDirectiveWhitespaces="true" %>
<%@ tag import="net.danvi.dmall.biz.app.goods.model.GoodsVO" %>
<%@ tag import="net.danvi.dmall.biz.system.security.SessionDetailHelper" %>
<%@ tag import="org.apache.commons.beanutils.BeanUtils" %>
<%@ tag import="dmall.framework.common.constants.RequestAttributeConstants"%>
<%@ tag import="dmall.framework.common.util.TextReplacerUtil" %>
<%@ tag import="java.io.File" %>
<%@ tag import="java.util.Map" %>
<%@ tag import="dmall.framework.common.util.StringUtil" %>
<%@ attribute name="value" required="true" description="태그의 값" type="java.util.List" %>
<%@ attribute name="displayTypeCd" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="iconYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="mainPagingYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="mobileMainYn" required="false" description="태그의 값" type="java.lang.String"%>
<%@ attribute name="preGoodsYn" required="false" description="태그의 값" type="java.lang.String"%>

<%
    if(value == null || value.size() == 0) return;

    String skinPath = File.separator + request.getAttribute(RequestAttributeConstants.SKIN_VIEW_PATH);
    String skinFilePath = "/template/list_type_e.html";
    String skinImgPath = (String)request.getAttribute(RequestAttributeConstants.SKIN_IMG_PATH);
    String mobilePath = RequestAttributeConstants.MOBILE_PATH;

    /*****
    list_type_a : 5개씩노출
    list_type_b : 1개씩노출
    list_type_c : 4개씩노출
    list_type_d : 2개씩노출(슬라이딩)
    list_type_e : 2개씩노출
    *****/


    if("01".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_b.html";
    } else if("02".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_a.html";
    } else if("03".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_c.html";
    } else if("04".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_d.html";
    } else if("05".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_e.html";
    } else if("06".equals(displayTypeCd)) {
        skinFilePath = "/template/list_type_best.html";
    } else if("07".equals(displayTypeCd)) { // 관련상품,비슷한상품
        skinFilePath = "/template/list_type_with.html";
    }

    String content = TextReplacerUtil.getSkinFileToString(skinPath + skinFilePath);
    GoodsVO temp;
    Map m;
    String no_image = mobilePath+"/front/img/common/no_image.png";
    String product_adult = mobilePath+"/front/img/common/product_adult.png";
    int bestRow = 1;
    int goodsIdx = 1;
    int goodsRow = 1;
    int valueRowIdx = 0;
    for(Object vo : value) {
    	
    	if(mobileMainYn == "Y"){
    		if(valueRowIdx >= 10){
    			break;
    		}
    	}

        temp = (GoodsVO)vo;
        m = BeanUtils.describe(vo);
        m.put("mobilePath",mobilePath);
        if(mobileMainYn == "Y") {
            m.put("lazy", "class=\"lazy\" data-original");
        }else{
            m.put("lazy", "src");
        }
        if("Y".equals(temp.getAdultCertifyYn())) {
            if(!SessionDetailHelper.getDetails().isLogin()){
                m.put("goodsDispImgA", product_adult);
                m.put("goodsDispImgB", product_adult);
                m.put("goodsDispImgC", product_adult);
                m.put("goodsDispImgD", product_adult);
                m.put("goodsDispImgE", product_adult);
            }else{
                if(SessionDetailHelper.getSession().getAdult() == null || !SessionDetailHelper.getSession().getAdult()) {
                    m.put("goodsDispImgA", product_adult);
                    m.put("goodsDispImgB", product_adult);
                    m.put("goodsDispImgC", product_adult);
                    m.put("goodsDispImgD", product_adult);
                    m.put("goodsDispImgE", product_adult);
                }else{
                    if(StringUtil.isEmpty(temp.getGoodsDispImgA())) m.put("goodsDispImgA", no_image);
                    if(StringUtil.isEmpty(temp.getGoodsDispImgB())) m.put("goodsDispImgB", no_image);
                    if(StringUtil.isEmpty(temp.getGoodsDispImgC())) m.put("goodsDispImgC", no_image);
                    if(StringUtil.isEmpty(temp.getGoodsDispImgD())) m.put("goodsDispImgD", no_image);
                    if(StringUtil.isEmpty(temp.getGoodsDispImgE())) m.put("goodsDispImgE", no_image);
                }
            }
        }else{
            if(StringUtil.isEmpty(temp.getGoodsDispImgA())) m.put("goodsDispImgA", no_image);
            if(StringUtil.isEmpty(temp.getGoodsDispImgB())) m.put("goodsDispImgB", no_image);
            if(StringUtil.isEmpty(temp.getGoodsDispImgC())) m.put("goodsDispImgC", no_image);
            if(StringUtil.isEmpty(temp.getGoodsDispImgD())) m.put("goodsDispImgD", no_image);
            if(StringUtil.isEmpty(temp.getGoodsDispImgE())) m.put("goodsDispImgE", no_image);
        }
        long customerPrice = temp.getCustomerPrice();
        long salePrice = temp.getSalePrice(); // 판매금액
        String prmtDcGbCd = temp.getPrmtDcGbCd();//기획전 할인구분 코드 (01:정율,02:정액)
        long prmtDcValue = temp.getPrmtDcValue();//기획전 할인율/값

        long goodseachDlvrc = temp.getGoodseachDlvrc();//상품별 배송비
        double totalSaleRate = 0; // 최종 할인율
        double dcAmt = 0;//할인금액

        String prmtTypeCd = temp.getPrmtTypeCd();//기획전 유형코드
        long firstBuySpcPrice = temp.getFirstBuySpcPrice();//첫구매 가격

        if(customerPrice == 0){ // 소비자가가 없을경우 판매가를 셋팅
            customerPrice = salePrice;
        }

        //기획전할인
        if(prmtDcGbCd!=null && prmtDcGbCd.equals("01")){
            dcAmt = Math.floor(salePrice*((double)prmtDcValue/100)/10)*10;
        }else if(prmtDcGbCd!=null && prmtDcGbCd.equals("02")){
            dcAmt =prmtDcValue;
        }else{

        }

        //out.print("<br>dcAmt : "+dcAmt);
        salePrice = salePrice-(long)dcAmt;

        if(prmtTypeCd!=null && prmtTypeCd.equals("06")){
           salePrice =firstBuySpcPrice;
        }

        totalSaleRate = (100-((double)salePrice/customerPrice*100));//총할인율

        long couponApplyAmt = 0;
        if(temp.getCouponApplyAmt()!=null && !StringUtil.trim(temp.getCouponApplyAmt()).equals("")){
        couponApplyAmt = Long.parseLong(temp.getCouponApplyAmt());
        }

        if(salePrice <= couponApplyAmt) {
            if ("3".equals(temp.getGoodsSaleStatusCd())) { // 품절상태
                m.put("salePrice", "<del><font color=red>sold out</font></del>");
            } else {
                m.put("salePrice", String.format("%,d", salePrice) + "원");
            }

            if (salePrice != customerPrice) {
                m.put("customerPrice", "<del>" + String.format("%,d", customerPrice) + "원</del>");
            } else {
                m.put("customerPrice", "");
            }

            if (totalSaleRate > 0) {
                m.put("saleRate", "<span class=\"icon_down\">" + String.format("%,d", Math.round(totalSaleRate)) + "%</span>");
            } else {
                m.put("saleRate", "");
            }

            if(temp.getCouponBnfCd()!=null && temp.getCouponBnfCd().equals("03")) {
                 m.put("customerPrice", "<span style=\"color:#214bbb\">" + temp.getCouponBnfTxt() + "</span>");
                 m.put("saleRate", "");
             }
        }else{
            if(couponApplyAmt<=0){
                if ("3".equals(temp.getGoodsSaleStatusCd())) { // 품절상태
                    m.put("salePrice", "<del><font color=red>sold out</font></del>");
                } else {
                    m.put("salePrice", String.format("%,d", salePrice) + "원");
                }

                if (salePrice != customerPrice) {
                    m.put("customerPrice", "<del>" + String.format("%,d", customerPrice) + "원</del>");
                } else {
                    m.put("customerPrice", "");
                }

                if (totalSaleRate > 0) {
                    m.put("saleRate", "<span class=\"icon_down\">" + String.format("%,d", Math.round(totalSaleRate)) + "%</span>");
                } else {
                    m.put("saleRate", "");
                }

                if(temp.getCouponBnfCd()!=null && temp.getCouponBnfCd().equals("03")) {
                     m.put("customerPrice", "<span style=\"color:#214bbb\">" + temp.getCouponBnfTxt() + "</span>");
                     m.put("saleRate", "");
                 }

            }else{

                if ("3".equals(temp.getGoodsSaleStatusCd())) { // 품절상태
                    m.put("salePrice", "<del><font color=red>sold out</font></del>");
                } else {
                    m.put("salePrice", "");
                }

                m.put("customerPrice", "<span class=\"icon_down\">" + temp.getCouponDcRate() + "% ↓ </span><span>쿠폰 적용가</span>");
                m.put("saleRate", String.format("%,d", Long.parseLong(temp.getCouponApplyAmt())) + "원" );

                if(temp.getCouponBnfCd()!=null && temp.getCouponBnfCd().equals("03")) {
                     m.put("customerPrice", "<span style=\"color:#214bbb\">" + temp.getCouponBnfTxt() + "</span>");
                     m.put("saleRate", "");
                 }
                /*if ("3".equals(temp.getGoodsSaleStatusCd())) { // 품절상태
                    m.put("salePrice", "<del><font color=red>sold out</font></del>");
                } else {
                    m.put("salePrice", String.format("%,d", salePrice) + "원");
                }

                if (salePrice != customerPrice) {
                    m.put("customerPrice", "<del>" + String.format("%,d", customerPrice) + "원</del>");
                } else {
                    m.put("customerPrice", "");
                }

                if (totalSaleRate > 0) {
                    m.put("saleRate", "<span class=\"icon_down\">" + String.format("%,d", Math.round(totalSaleRate)) + "%</span>");
                } else {
                    m.put("saleRate", "");
                }*/
            }
        }

        String goodsSvmnAmt ="";
        if(temp.getGoodsSvmnPolicyUseYn()!=null && temp.getGoodsSvmnPolicyUseYn().equals("Y")){
            //기본적립금
            if(temp.getGoodsSvmnAmt()!=null && !temp.getGoodsSvmnAmt().equals("0")){
                goodsSvmnAmt = "<span class=\"view_point\">"+String.format("%,d", Math.round(Double.parseDouble(StringUtil.nvl(temp.getGoodsSvmnAmt(), "0"))))+" % 적립 </span>";
            }
        }else{
            //개별적립금
            if(temp.getGoodsSvmnAmt()!=null && !temp.getGoodsSvmnAmt().equals("0")){
                goodsSvmnAmt = "<span class=\"view_point\">"+String.format("%,d", Math.round(Double.parseDouble(StringUtil.nvl(temp.getGoodsSvmnAmt(), "0"))))+" 원 적립 </span>";
            }
        }

        m.put("goodsSvmnAmt", goodsSvmnAmt);
        m.put("accmGoodslettCnt", String.format("%,d", Math.round(Double.parseDouble(StringUtil.nvl(temp.getAccmGoodslettCnt(),"0")))));

        String goodsDlvrc ="";
        if(goodseachDlvrc>0){
            goodsDlvrc = "<span class=\"view_point\">"+String.format("%,d", Math.round(Double.parseDouble(StringUtil.nvl(String.valueOf(goodseachDlvrc),"0"))))+"원</span>";
        }else{
            goodsDlvrc ="<span class=\"view_point\">무료배송</span>";
        }

        m.put("goodseachDlvrc", goodsDlvrc);

		if("N".equals(iconYn)){
            m.put("iconImgs","");
        }else{
            if(temp.getIconImgs() != null) {
	        	String iconImgs = temp.getIconImgs().replaceAll("<img src=\"/skin/img", "<img src=\"" + skinImgPath);
	        	iconImgs = iconImgs.replaceAll("/product/", "/product_list/");
	            m.put("iconImgs", iconImgs);
	        }
        }

        //평점별노출
        long score = Math.round(Double.parseDouble(StringUtil.nvl(temp.getGoodsScore(), "0"))/2);
        String starCnt ="";
        for (int i=0; i<5;i++){
            if(score > i){
                starCnt += "<img src='"+mobilePath+"/front/img/product/icon_star_yellow.png' alt=상품평가 별'>";
            }else{
                starCnt += "<img src='"+mobilePath+"/front/img/product/icon_star_gray.png' alt='상품평가 별'>";
            }
        }
        m.put("starCnt",starCnt);
        m.put("bestIcon","<span class='icon_best_mark' title='베스트 순위'>"+bestRow+"</span>");
        // list type이 E일때 ul 추가
        if("05".equals(displayTypeCd)){
        	// main페이징 용
        	if("Y".equals(mainPagingYn)){
        		if(goodsRow < 4){
        			if(goodsRow == 1){
        				m.put("divS", "<div name=\"goodsRow\">");
        			}
	        		if(value.size() == valueRowIdx+1){
	            		m.put("divE", "</div>");
	        		}
        			goodsRow++;
            	}else if(goodsRow == 4){
            		m.put("divE", "</div>");
            		goodsRow = 1;
        		}
        	}
        	if(goodsIdx == 1){
            	m.put("ulS", "<ul class=\"product_list_typeA\">");
            	if(value.size() == valueRowIdx+1){
                	m.put("ulE", "</ul>");
                }
            	goodsIdx++;
            }else if(goodsIdx == 2){
            	m.put("ulE", "</ul>");
            	goodsIdx = 1;
            }
        }

        if("Y".equals(temp.getPreGoodsYn()) && salePrice == 0){
     	   m.put("salePrice", "샘플증정상품");
        }
        
        out.print(TextReplacerUtil.replace(m, content, request));
        bestRow++;
        valueRowIdx++;
    }
%>
