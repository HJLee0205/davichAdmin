package net.danvi.dmall.front.web.view.interfaces.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.GoodsAddOptionDtlVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.core.model.payment.ItemStack;
import net.danvi.dmall.core.model.payment.NpayVO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

import javax.annotation.Resource;
import javax.net.ssl.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : NPAY 주문 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/interfaces")
public class NpayController {
    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    /** 개발서버 도메인 */
    @Value(value = "#{business['system.domain.dev']}")
    private String devDomain;

    /** NPAY 환경 (test/service) */
    @Value(value = "#{core['npay.mode']}")
    private String npayMode;

    /** NPAY ORDER API URL (TEST) */
    @Value(value = "#{core['core.payment.npay.test.order.url']}")
    private String npayTestApiUrl;

    /** NPAY ORDER API URL (REAL) */
    @Value(value = "#{core['core.payment.npay.service.order.url']}")
    private String npayApiUrl;

    /** NPAY ZZIM API URL (TEST) */
    @Value(value = "#{core['core.payment.npay.test.zzim.url']}")
    private String npayTestZzimApiUrl;

    /** NPAY ZZIM API URL (REAL) */
    @Value(value = "#{core['core.payment.npay.service.zzim.url']}")
    private String npayZzimApiUrl;

    private static final String ENCODING = "UTF-8";
    private static final String NCKEY_ITEMID = "ITEM_ID";
    private static final String NCKEY_ITEMNAME = "ITEM_NAME";
    private static final String NCKEY_COUNT = "ITEM_COUNT";
    private static final String NCKEY_TPRICE = "ITEM_TPRICE";
    private static final String NCKEY_UPRICE = "ITEM_UPRICE";
    private static final String NCKEY_OPTION = "ITEM_OPTION";
    private static final String NCKEY_SHIPPINGTYPE = "SHIPPING_TYPE";
    private static final String NCKEY_SHIPPINGPRICE = "SHIPPING_PRICE";
    private static final String NCKEY_TOTALPRICE = "TOTAL_PRICE";
    private static final String NCKEY_SHOPID = "SHOP_ID";
    private static final String NCKEY_CERTIKEY = "CERTI_KEY";
    private static final String NCKEY_BACKURL = "BACK_URL";
    private static final String NCKEY_RESERVE1 = "RESERVE1";
    private static final String NCKEY_RESERVE2 = "RESERVE2";
    private static final String NCKEY_RESERVE3 = "RESERVE3";
    private static final String NCKEY_RESERVE4 = "RESERVE4";
    private static final String NCKEY_RESERVE5 = "RESERVE5";
    private static final String NCKEY_SA_CLICK_ID = "SA_CLICK_ID"; //CTS
    private static final String NCKEY_CPA_INFLOW_CODE = "CPA_INFLOW_CODE";
    private static final String NCKEY_NAVER_INFLOW_CODE = "NAVER_INFLOW_CODE";

    private static final String NCKEY_ITEMIMAGE = "ITEM_IMAGE";
    private static final String NCKEY_ITEMTHUMB = "ITEM_THUMB";
    private static final String NCKEY_ITEMURL = "ITEM_URL";

    public URL _url;
    private SSLSocketFactory _sslSockFactory;

    public NpayController() {
        _url = null;
    }

    public NpayController(URL url) {
        _url = url;
        _initHttps();
    }

    public NpayController(String url) throws MalformedURLException {
        this(new URL(url));
    }

    public void setUrl(String url) throws MalformedURLException {
        _url = new URL(url);
    }

    private void _urlEncode(StringBuffer sb, String key, String value) {
        try {
            sb.append(URLEncoder.encode(key, ENCODING));
            sb.append('=');
            sb.append(URLEncoder.encode(value, ENCODING));
        } catch (UnsupportedEncodingException e) {             //일어나지 않음
            throw new Error(e);
        }
    }


    private String _makeQueryString(String shopId, String certificationKey, ItemStack[] items) {
        StringBuffer sb = new StringBuffer();
        _urlEncode(sb, NCKEY_SHOPID, shopId);
        sb.append('&');
        _urlEncode(sb, NCKEY_CERTIKEY, certificationKey);
        sb.append('&');
        for (ItemStack is : items) {
            _urlEncode(sb, NCKEY_ITEMID, is.getItemId());
            sb.append('&');
            _urlEncode(sb, NCKEY_ITEMNAME, is.getItemName());
            sb.append('&');
            _urlEncode(sb, NCKEY_UPRICE, String.valueOf(is.getItemUnitPrice()));
            sb.append('&');
            _urlEncode(sb, NCKEY_ITEMIMAGE, String.valueOf(is.getItemImage()));
            sb.append('&');
            _urlEncode(sb, NCKEY_ITEMTHUMB, String.valueOf(is.getItemThumb()));
            sb.append('&');
            _urlEncode(sb, NCKEY_ITEMURL, String.valueOf(is.getItemUrl()));
            sb.append('&');
        }
        _urlEncode(sb, NCKEY_RESERVE1, "");
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE2, "");
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE3, "");
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE4, "");
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE5, "");
        return sb.toString();
    }

    private String _makeQueryString(String shopId, String certificationKey, ItemStack[] items, int shippingPrice, String shippingType, String backURL, String saClickId,String cpaInflowCode,String naverInflowCode) {
        //주문 금액 = 각 상품 금액 + 배송비(단 선불일 경우)
        int totalPrice = shippingPrice > 0 ? shippingPrice : 0;
        StringBuffer sb = new StringBuffer();
        _urlEncode(sb, NCKEY_SHOPID, shopId);
        sb.append('&');
        _urlEncode(sb, NCKEY_CERTIKEY, certificationKey);
        sb.append('&');
        for (ItemStack is : items) {
            totalPrice += is.getItemTotalPrice();
            _urlEncode(sb, NCKEY_ITEMID, is.getItemId());
            sb.append('&');
            _urlEncode(sb, NCKEY_ITEMNAME, is.getItemName());
            sb.append('&');
            _urlEncode(sb, NCKEY_TPRICE, String.valueOf(is.getItemTotalPrice()));
            sb.append('&');
            _urlEncode(sb, NCKEY_UPRICE, String.valueOf(is.getItemUnitPrice()));
            sb.append('&');
            _urlEncode(sb, NCKEY_COUNT, String.valueOf(is.getCount()));
            sb.append('&');
            _urlEncode(sb, NCKEY_OPTION, is.getSelectedOption());
            sb.append('&');
        }
        _urlEncode(sb, NCKEY_SHIPPINGTYPE, shippingType);
        sb.append('&');
        _urlEncode(sb, NCKEY_SHIPPINGPRICE, String.valueOf(shippingPrice));
        sb.append('&');
        _urlEncode(sb, NCKEY_TOTALPRICE, String.valueOf(totalPrice));
        sb.append('&');
        _urlEncode(sb, NCKEY_BACKURL, backURL);
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE1, "");
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE2, "");
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE3, "");
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE4, "");
        sb.append('&');
        _urlEncode(sb, NCKEY_RESERVE5, "");
        sb.append('&'); //CTS
        _urlEncode(sb, NCKEY_SA_CLICK_ID, saClickId); //CTS         // CPA 스크립트 가이드 설치업체는 해당 값 전달
        sb.append('&');
        _urlEncode(sb, NCKEY_CPA_INFLOW_CODE, cpaInflowCode);
        sb.append('&');
        _urlEncode(sb, NCKEY_NAVER_INFLOW_CODE, naverInflowCode);
        return sb.toString();
    }

    /* test 환경에서는 인증서 오류가 날 수도 있다. 이 코드를 이용해 인증서 오류를 회피한다. */

    private void _initHttps() {
        TrustManager[] trustAllCerts = new TrustManager[]{new X509TrustManager() {
            public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
            }

            public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
            }

            public X509Certificate[] getAcceptedIssuers() {
                return new X509Certificate[0];
            }
        }};
        try {
            SSLContext sslContext = SSLContext.getInstance("SSL");
            sslContext.init(null, trustAllCerts, new SecureRandom());
            _sslSockFactory = sslContext.getSocketFactory();
        } catch (Exception e) {
            RuntimeException re = new RuntimeException(e);
            re.setStackTrace(e.getStackTrace());
            throw re;
        }
    }


    /**
    * @param items 주문 상품 목록.
    * @return 주문키
    * @throws IOException
    */
    public String[] sendZzimToNC(String shopId, String certificationKey, ItemStack[] items) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) _url.openConnection();                  /* test 환경에서는 인증서 오류가 날 수도 있다. 이 코드를 이용해 인증서 오류를 회피한다. */
        if (conn instanceof HttpsURLConnection) {
            ((HttpsURLConnection) conn).setSSLSocketFactory(_sslSockFactory);
            ((HttpsURLConnection) conn).setHostnameVerifier(new HostnameVerifier() {
                @Override
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            });
        }
        conn.setDoInput(true);
        conn.setDoOutput(true);
        conn.setUseCaches(false);
        conn.setRequestMethod("POST");
        conn.addRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        Writer writer = new OutputStreamWriter(conn.getOutputStream(), ENCODING);
        writer.write(_makeQueryString(shopId, certificationKey, items));
        writer.flush();
        writer.close();
        int respCode = conn.getResponseCode();
        if (respCode != 200) {
            throw new RuntimeException(String.format("NC Response fail : %d %s", respCode, conn.getResponseMessage()));
        }
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String retStr = reader.readLine();
        return retStr.split(",");
    }

    /**
     * @param items 주문 상품 목록.
     * @param shippingPrice 배송비.
     * @param shippingType 배송비결제 구분. "FREE": 무료. "PAYED": 선불. "ONDELIVERY": 착불
     * @return 주문키
     * @throws IOException
     */
    public String sendOrderInfoToNC(String shopId, String certificationKey, ItemStack[] items,
                                    int shippingPrice, String shippingType, String backURL, String nvadId,String cpaInflowCode,String naverInflowCode) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) _url.openConnection();
        /* test 환경에서는 인증서 오류가 날 수도 있다. 이 코드를 이용해 인증서 오류를 회피한다. */
        if (conn instanceof HttpsURLConnection) {
            ((HttpsURLConnection) conn).setSSLSocketFactory(_sslSockFactory);
            ((HttpsURLConnection) conn).setHostnameVerifier(new HostnameVerifier() {
                @Override
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            });
        }
        conn.setDoInput(true);
        conn.setDoOutput(true);
        conn.setUseCaches(false);
        conn.setRequestMethod("POST");
        conn.addRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        Writer writer = new OutputStreamWriter(conn.getOutputStream(), ENCODING);
        writer.write(_makeQueryString(shopId, certificationKey, items, shippingPrice, shippingType, backURL, nvadId,cpaInflowCode,naverInflowCode));
        writer.flush();
        writer.close();
        int respCode = conn.getResponseCode();
        if (respCode != 200) {
            throw new RuntimeException(String.format("NC Response fail : %d %s", respCode, conn.getResponseMessage()));
        }
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String orderKey = reader.readLine();
        return orderKey;
    }

    private static String getCookieValue(HttpServletRequest request, String name) {
        if (name == null || request == null) {
            return "";
        }
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (int i = 0; i < cookies.length; i++) {
                if (name.equals(cookies[i].getName())) {
                    return cookies[i].getValue();
                }
            }
        }
        return "";
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : npay 주문 정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/npay/payment")
    public @ResponseBody ResultModel<NpayVO> payment(@Validated OrderVO vo, BindingResult bindingResult, HttpServletRequest request) throws Exception {

        ResultModel<NpayVO> result = new ResultModel<>();

        /**  1. 필수 파라메터 검증 */
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new Exception("파라메터 오류");
        }

        // 01. 주문데이터 확인
        String[] itemArr = vo.getItemArr();

        OrderVO orderVO = new OrderVO();
        GoodsDetailSO goodsDetailSO = new GoodsDetailSO();
        ResultModel<GoodsDetailVO> goodsInfo = new ResultModel<>();
        // 주문 상품 정보
        log.debug(" ==== itemArr : {}", itemArr);
        List<OrderGoodsVO> orderGoodsList = new ArrayList();
        if (itemArr != null && itemArr.length > 0) {
            for (int i = 0; i < itemArr.length; i++) {
                /*
                 * 전송 데이터 예제
                 * itemArr[0] : G1607121100_0815▦I1607121106_0960^1^01▦▦82
                 * itemArr[1] : G1607121100_0815▦I1607121106_0961^1^02▦▦82
                 * itemArr[2] : G1607121100_0815▦I1607121106_0962^1^03▦▦82
                 * itemArr[3] : G1607121100_0815▦I1607121106_0963^1^04▦69^118^1*70^120^1*69^119^1▦82
                 */

                String itemArrSplit = itemArr[i].replace("&acirc;&brvbar;", "▦");
                // 상품번호
                String goodsNo = itemArrSplit.split("\\▦")[0];
                // 단품정보(단품번호:수량:배송비결제코드)
                String item = itemArrSplit.split("\\▦")[1];
                String itemNo = item.split("\\^")[0]; // 단품번호
                int buyQtt = Integer.parseInt(item.split("\\^")[1]); // 단품 구매수량
                String dlvrcPaymentCd = item.split("\\^")[2]; // 배송비 결제 코드
                // 추가옵션정보(옵션번호:상세번호:수량)
                String addOpt = "";
                if (itemArrSplit.split("\\▦").length == 4) {
                    addOpt = itemArrSplit.split("\\▦")[2];
                }
                // 카테고리 정보
                long ctgNo = 0;
                if (!"".equals(itemArrSplit.split("\\▦")[3])) {
                    ctgNo = Long.parseLong(itemArrSplit.split("\\▦")[3]);
                }

                goodsDetailSO.setGoodsNo(goodsNo);
                goodsDetailSO.setItemNo(itemNo);
                goodsDetailSO.setSiteNo(vo.getSiteNo());
                goodsDetailSO.setSaleYn("Y");
                OrderGoodsVO orderGoodsVO = orderService.selectOrderGoodsInfo(goodsDetailSO);

                if (orderGoodsVO == null) {
                    result.setSuccess(false);
                    result.setMessage(MessageUtil.getMessage("front.web.goods.noSale"));
                    return result;
                } else {
                    if ("Y".equals(orderGoodsVO.getAdultCertifyYn())) {
                        if (!SessionDetailHelper.getDetails().isLogin()) {
                            result.setSuccess(false);
                            result.setMessage(MessageUtil.getMessage("성인용품은 성인인증을 하셔야만 구매가 가능합니다."));
                            return result;
                        } else {
                            if (SessionDetailHelper.getSession().getAdult() == null
                                    || !SessionDetailHelper.getSession().getAdult()) {
                                result.setSuccess(false);
                                result.setMessage(MessageUtil.getMessage("성인용품은 성인인증을 하셔야만 구매가 가능합니다."));
                                return result;
                            }
                        }
                    }
                }

                // 기획전 할인정보 조회
                ExhibitionSO pso = new ExhibitionSO();
                pso.setSiteNo(vo.getSiteNo());
                pso.setGoodsNo(goodsNo);
                String prmtBrandNo ="";
                if(orderGoodsVO.getBrandNo()!=null && !orderGoodsVO.getBrandNo().equals("")) {
                    prmtBrandNo = orderGoodsVO.getBrandNo();
                    pso.setPrmtBrandNo(prmtBrandNo);
                }
                ResultModel<ExhibitionVO> exhibitionVO = exhibitionService.selectExhibitionByGoods(pso);
                if (exhibitionVO.getData() != null) {
                    orderGoodsVO.setPrmtNo(exhibitionVO.getData().getPrmtNo()); // 기획전 번호
                    orderGoodsVO.setDcRate(exhibitionVO.getData().getPrmtDcValue()); // 기획전 할인율
                }

                orderGoodsVO.setOrdQtt(buyQtt); // 구매수량
                orderGoodsVO.setDlvrcPaymentCd(dlvrcPaymentCd); // 배송비 결제 코드
                orderGoodsVO.setCtgNo(ctgNo); // 카테고리 정보
                List<GoodsAddOptionDtlVO> goodsAddOptList = new ArrayList();
                if (!"".equals(addOpt)) {
                    String[] addOptArr = addOpt.split("\\*");
                    for (int k = 0; k < addOptArr.length; k++) {
                        long addOptNo = Long.parseLong(addOptArr[k].split("\\^")[0]);
                        long addOptDtlSeq = Long.parseLong(addOptArr[k].split("\\^")[1]);
                        int optBuyQtt = Integer.parseInt(addOptArr[k].split("\\^")[2]);
                        goodsDetailSO.setAddOptNo(addOptNo);
                        goodsDetailSO.setAddOptDtlSeq(addOptDtlSeq);
                        // 추가옵션 정보 조회
                        GoodsAddOptionDtlVO goodsAddOptionDtlVO = orderService.selectOrderAddOptionInfo(goodsDetailSO);
                        goodsAddOptionDtlVO.setAddOptBuyQtt(optBuyQtt);
                        goodsAddOptList.add(goodsAddOptionDtlVO);
                    }
                    orderGoodsVO.setGoodsAddOptList(goodsAddOptList);
                }
                orderGoodsList.add(orderGoodsVO);
            }
        } else {
            throw new Exception(MessageUtil.getMessage("front.web.common.wrongapproach"));
        }

        // 배송비 계산(묶음 관련)
        String type = "order";
        Map map = orderService.calcDlvrAmt(orderGoodsList, type);
        List<OrderGoodsVO> list = (List<OrderGoodsVO>) map.get("list");
        Map dlvrPriceMap = (Map) map.get("dlvrPriceMap");
        Map dlvrCountMap = (Map) map.get("dlvrCountMap");

        int shippingPrice =  0;
        String shippingType = "";

        //주문 상품 내역으로 items 데이터를 생성한다.
        List<ItemStack> items = new ArrayList<ItemStack>();
        String grpId="";
        String preGrpId = "";
        for (int i=0;i<list.size();i++) {
            OrderGoodsVO orderGoodsVO = list.get(i);
            String goodsNo = orderGoodsVO.getGoodsNo();
            String goodsNm = orderGoodsVO.getGoodsNm();
            String itemNo = orderGoodsVO.getItemNo();
            String itemName = orderGoodsVO.getItemNm();

            int itemTPrice = (int) (orderGoodsVO.getSaleAmt()*orderGoodsVO.getOrdQtt());
            int itemUPrice = (int) vo.getTotalPrice();
            int count = (int) orderGoodsVO.getOrdQtt();
            List<GoodsAddOptionDtlVO> goodsAddOptList = orderGoodsVO.getGoodsAddOptList();
            if (goodsAddOptList!=null && goodsAddOptList.size() > 0){
                for (int j = 0; j < goodsAddOptList.size(); j++) {
                    GoodsAddOptionDtlVO goodsAddOpt = goodsAddOptList.get(j);
                    String selectedOption = goodsAddOpt.getAddOptNm();
                    items.add(new ItemStack(goodsNo, goodsNm, itemTPrice, itemUPrice, selectedOption, count));
                }
            }else{
                items.add(new ItemStack(goodsNo, goodsNm, itemTPrice, itemUPrice, itemName, count));
            }

            if ( ("1".equals(orderGoodsVO.getDlvrSetCd()) ) && ("01".equals(orderGoodsVO.getDlvrcPaymentCd()) || "02".equals(orderGoodsVO.getDlvrcPaymentCd()))) {
                grpId = orderGoodsVO.getDlvrSetCd() + "**" + orderGoodsVO.getDlvrcPaymentCd();
            } else if ("4".equals(orderGoodsVO.getDlvrSetCd()) && "02".equals(orderGoodsVO.getDlvrcPaymentCd())) {
                grpId = orderGoodsVO.getGoodsNo() + "**" + orderGoodsVO.getDlvrSetCd() + "**" + orderGoodsVO.getDlvrcPaymentCd();
            } else if ("6".equals(orderGoodsVO.getDlvrSetCd()) && "02".equals(orderGoodsVO.getDlvrcPaymentCd())) {
                grpId = orderGoodsVO.getGoodsNo() + "**" + orderGoodsVO.getDlvrSetCd() + "**" + orderGoodsVO.getDlvrcPaymentCd();
            } else {
                grpId = orderGoodsVO.getItemNo() + "**" + orderGoodsVO.getDlvrSetCd() + "**" + orderGoodsVO.getDlvrcPaymentCd();
            }

            if(!preGrpId.equals(grpId)) {
                shippingPrice += Long.valueOf((Long) dlvrPriceMap.get(grpId)).intValue();
                preGrpId = grpId;
            }

            if(shippingPrice == 0 ){
                shippingType ="FREE";
            }else if(shippingPrice > 0 ){
                shippingType ="PAYED";
            }else {
                shippingType="ONDELIVERY";
            }
        }

        String backURL = "";
        String mobileContext ="";
        if(SiteUtil.isMobile()){
            mobileContext="/m";
        }

        String protocol = request.getScheme();
        String domain =devDomain;

        if(vo.getNpayPageCode().equals("goods")){
            backURL = protocol+"://"+domain+mobileContext+"/front/goods/goods-detail?goodsNo=" + vo.getGoodsNo();
        }else{
            backURL = protocol+"://"+domain+mobileContext+"/front/basket/basket-list";
        }


        String nvadId = "11111+aa12345678901234";  //CTS
        // servlet인 경우 쿠키값을 넣어야 함
        nvadId = getCookieValue((HttpServletRequest) request, "NVADID");         // CPA 스크립트 가이드 설치 업체는 해당 값 전달
        String cpaInflowCode = getCookieValue((HttpServletRequest) request, "CPAValidator");
        String naverInflowCode = getCookieValue((HttpServletRequest) request, "NA_CO");

        String apiUrl = "";
        if(npayMode.equals("test")){
            apiUrl = npayTestApiUrl;
        }else{
            apiUrl = npayApiUrl;
        }

        NpayController sample = new NpayController(apiUrl);

        String orderKey = sample.sendOrderInfoToNC("np_uwgbi717535", "E4EC4467-D0EE-49E5-8514-63191A8460AB", items.toArray(new ItemStack[0]), shippingPrice, shippingType, backURL, nvadId,cpaInflowCode,naverInflowCode);
        //여기서 얻은 orderKey로 NC 결제창에 넘겨 결제를 진행한다.

        NpayVO npayvo = new NpayVO();
        npayvo.setOrderKey(orderKey);
        result.setData(npayvo);
        result.setSuccess(true);

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : npay 찜하기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/npay/zzim")
    public @ResponseBody ResultModel<NpayVO> zzim(@Validated OrderVO vo, BindingResult bindingResult, HttpServletRequest request) throws Exception {

        ResultModel<NpayVO> result = new ResultModel<>();

        /**  1. 필수 파라메터 검증 */
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new Exception("파라메터 오류");
        }

        GoodsDetailSO so = new GoodsDetailSO();
        so.setSaleYn("Y");
        so.setDelYn("N");
        String[] goodsStatus = { "1", "2" };
        so.setGoodsStatus(goodsStatus);
        so.setGoodsNo(vo.getGoodsNo());
        ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(so);

        //주문상품 내역으로 items 데이터를 생성한다.
        List<ItemStack> items = new ArrayList<ItemStack>();
        String itemId = goodsInfo.getData().getGoodsNo();
        String itemName = goodsInfo.getData().getGoodsNm();
        int itemTPrice = (int) (goodsInfo.getData().getSalePrice());
        String protocol = request.getScheme();
        String domain =devDomain;
        String itemImage = protocol+"://"+domain+goodsInfo.getData().getGoodsDispImgC().replace("&amp;","&");
        String itemThumb = protocol+"://"+domain+goodsInfo.getData().getGoodsDispImgC().replace("&amp;","&");
        String itemUrl = protocol+"://"+domain+"/front/goods/goods-detail?goodsNo="+goodsInfo.getData().getGoodsNo();
        items.add(new ItemStack(itemId, itemName, itemTPrice, itemImage, itemThumb, itemUrl));

        String zzimUrl = "";
        if(npayMode.equals("test")){
            zzimUrl = npayTestZzimApiUrl;
        }else{
            zzimUrl = npayZzimApiUrl;
        }

        NpayController sample = new NpayController(zzimUrl);
        String[] prodSeqs = sample.sendZzimToNC("np_uwgbi717535", "E4EC4467-D0EE-49E5-8514-63191A8460AB", items.toArray(new ItemStack[0]));         //여기서 얻은prodSeqs로 zzim popup을 띄운다.

        NpayVO npayvo = new NpayVO();
        String itemIds = "";
        if(prodSeqs.length>0){
            for (int i=0;i<prodSeqs.length;i++){
                if(i==0)
                    itemIds+=prodSeqs[i];
                else
                    itemIds+=","+prodSeqs[i];
            }
        }

        npayvo.setOrderKey(itemIds);
        result.setData(npayvo);
        result.setSuccess(true);

        return result;
    }
}
