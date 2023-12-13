package net.danvi.dmall.biz.batch.link.sabangnet;

/**
 * Created by dong on 2016-07-15.
 */
public class SabangnetConstant {
    // 공통 헤더
    public static final String SEND_COMPAYNY_ID = "sendCompaynyId";
    public static final String SEND_AUTH_KEY = "sendAuthKey";
    public static final String SEND_DATE = "sendDate";
    public static final String SITE_NO = "siteNo";
    public static final String SITE_ID = "siteId";
    public static final String SITE_NM = "siteNm";
    public static final String DOMAIN = "domain";
    public static final String IF_GB_CD = "1";
    // 상품 등록 헤더
    public static final String SEND_GOODS_CD_RT = "Y";
    public static final String ST_DATE = "stDate";
    public static final String ED_DATE = "edDate";
    public static final String ORD_PRT_FIELD = "IDX|ORDER_ID|MALL_ID|MALL_USER_ID|ORDER_STATUS|USER_NAME|USER_TEL|USER_CEL|USER_EMAIL|RECEIVE_TEL|RECEIVE_CEL|DELV_MSG|RECEIVE_NAME|RECEIVE_ZIPCODE|RECEIVE_ADDR|TOTAL_COST|PAY_COST|ORDER_DATE|P_PRODUCT_NAME|P_SKU_VALUE|SALE_COST|SALE_CNT|DELIVERY_METHOD_STR|DELV_COST|COMPAYNY_GOODS_CD|ORDER_GUBUN|copy_idx|REG_DATE|ORD_CONFIRM_DATE|RTN_DT|CHNG_DT|DELIVERY_CONFIRM_DATE|CANCEL_DT|DELIVERY_ID|INVOICE_NO";
    public static final String CLM_PRT_FIELD = "IDX|ORDER_ID|MALL_ID|MALL_USER_ID|ORDER_STATUS|USER_NAME|USER_TEL|USER_CEL|USER_EMAIL|RECEIVE_TEL|RECEIVE_CEL|DELV_MSG|RECEIVE_NAME|RECEIVE_ZIPCODE|RECEIVE_ADDR|TOTAL_COST|PAY_COST|ORDER_DATE|P_PRODUCT_NAME|P_SKU_VALUE|SALE_COST|SALE_CNT|COMPAYNY_GOODS_CD|CLAME_STATUS_GUBUN|CLAME_CONTENT|CLAME_INS_DATE|CLAME_REG_DATE|CL_IDX";


    public static final String GOODS_PRT_FIELD = "GOODS_NM|MODEL_NM|BRAND_NM|GOODS_SEARCH|MAKER|ORIGIN|MAKE_YEAR|MAKE_DM|GOODS_SEASON|SEX|STATUS|TAX_YN|DELV_TYPE|DELV_COST|GOODS_COST|GOODS_PRICE|GOODS_CONSUMER_PRICE|CHAR1NM|CHAR1VAL|CHAR2NM|CHAR2VAL|IMG_PATH|IMG_PATH1|IMG_PATH2|IMG_PATH3|IMG_PATH4|IMG_PATH5|GOODS_REMARKS|MATERIAL|STOCK_USE_YN|OPT_TYPE|PROP_EDIT_YN|PROP1CD|PROP_VAL1|PROP_VAL2|PROP_VAL3|PROP_VAL4|PROP_VAL5|PROP_VAL6|PROP_VAL7|PROP_VAL8|PROP_VAL9|PROP_VAL10|PROP_VAL11|PROP_VAL12|PROP_VAL13|PROP_VAL14|PROP_VAL15|PROP_VAL16|PROP_VAL17|PROP_VAL18|PROP_VAL19|PROP_VAL20|PROP_VAL21|PROP_VAL22|PROP_VAL23|PROP_VAL24|IMPORTNO";

    // 주문 수집 요청 조건
    public static final String JUNG_CHK_YN2 = "jungChkYn2";
    public static final String ORDER_STATUS = "orderStatus";
    public static final String ORDER_ID = "orderId";
    public static final String MALL_ID = "mallId";
    public static final String LANG = "lang";
    // 송장 등록 헤더
    public static final String SEND_INV_EDIT_YN = "N";
    // 클레임 수집 요청 조건
    // 문의사항수집 요청 조건
    public static final String CS_STATUS = "001";
    // XML 파일명
    public static final String XML_NM_GOODS = "goods.xml";
    public static final String XML_NM_GOODS_SMR_UPD = "goodsSmrUpd.xml";
    public static final String XML_NM_ORDER_REQUEST = "orderRequest.xml";
    public static final String XML_NM_INVOICE = "invoice.xml";
    public static final String XML_NM_CLAIM_REQUEST = "claimRequest.xml";
    public static final String XML_NM_CS_REQUEST = "csRequest.xml";
    public static final String XML_NM_CS_REPLY = "csReply.xml";
    public static final String XML_NM_GOODS_READ = "goodsRequest.xml";

    // 연계ID
    public static final String IF_ID_GOODS = "IF-J-001";
    public static final String IF_ID_GOODS_SMR_UPD = "IF-J-002";
    public static final String IF_ID_ORDER = "IF-J-003";
    public static final String IF_ID_INVOICE = "IF-J-004";
    public static final String IF_ID_CLAIM = "IF-J-005";
    public static final String IF_ID_INQUIRY = "IF-J-006";
    public static final String IF_ID_INQUIRY_REPLY = "IF-J-007";

    public static final String IF_ID_GOODS_READ = "IF-J-008";

    // 연계프로그램명
    public static final String IF_PGM_NM_GOODS = "1.상품등록&수정 연계";
    public static final String IF_PGM_NM_GOODS_SMR_UPD = "2.상품요약수정 연계";
    public static final String IF_PGM_NM_ORDER_XML = "3.주문수집 연계 XML생성";
    public static final String IF_PGM_NM_ORDER = "3.주문수집 연계";
    public static final String IF_PGM_NM_INVOICE = "4.송장등록 연계";
    public static final String IF_PGM_NM_CLAIM_XML = "5.클레임수집 연계 XML생성";
    public static final String IF_PGM_NM_CLAIM = "5.클레임수집 연계";
    public static final String IF_PGM_NM_INQUIRY_XML = "6.문의사항수집 연계 XML생성";
    public static final String IF_PGM_NM_INQUIRY = "6.문의사항수집 연계";
    public static final String IF_PGM_NM_INQUIRY_REPLY = "7.문의답변등록 연계";

    public static final String IF_PGM_NM_GOODS_READ_XML = "8.상품 수집 연계 XML 생성";
    public static final String IF_PGM_NM_GOODS_READ = "8.상품 수집 연계";

    // 연계프로그램ID
    public static final String IF_PGM_ID_GOODS = "SabangnetService.registGoods";
    public static final String IF_PGM_ID_GOODS_SMR_UPD = "SabangnetService.smrUpdGoods";
    public static final String IF_PGM_ID_ORDER_XML = "SabangnetService.createOrderRequestXml";
    public static final String IF_PGM_ID_ORDER = "SabangnetService.getherOrder";
    public static final String IF_PGM_ID_INVOICE = "SabangnetService.registInvoice";
    public static final String IF_PGM_ID_CLAIM_XML = "SabangnetService.createClaimRequestXml";
    public static final String IF_PGM_ID_CLAIM = "SabangnetService.getherClaim";
    public static final String IF_PGM_ID_INQUIRY_XML = "SabangnetService.createInquiryRequestXml";
    public static final String IF_PGM_ID_INQUIRY = "SabangnetService.getherInquiry";
    public static final String IF_PGM_ID_INQUIRY_REPLY = "SabangnetService.registInquiryReply";

    public static final String IF_PGM_ID_GOODS_READ_XML = "SabangnetService.createGoodsRequestXml";
    public static final String IF_PGM_ID_GOODS_READ = "SabangnetService.getherGoods";

    // 사방넷 연계 API URL
    // 1.상품등록&수정 URL
    public static final String XML_GOODS_REG_UPD_URL = "http://r.sabangnet.co.kr/RTL_API/xml_goods_info.html?xml_url=";
    // 2.상품요약 수정 URL
    public static final String XML_GOODS_SMR_UPD_URL = "http://r.sabangnet.co.kr/RTL_API/xml_goods_info2.html?xml_url=";
    // 3.주문 수집 URL
    public static final String XML_READ_ORDER_URL = "https://r.sabangnet.co.kr/RTL_API/xml_order_info.html?xml_url=";
    // 4.송장 등록 URL
    public static final String XML_INVOICE_REG_URL = "https://r.sabangnet.co.kr/RTL_API/xml_order_invoice.html?xml_url=";
    // 5.클레임 수집 URL
    public static final String XML_READ_CLAIM_URL = "https://r.sabangnet.co.kr/RTL_API/xml_clm_info.html?xml_url=";
    // 6.문의사항 수집 URL
    public static final String XML_READ_INQUIRY_URL = "https://r.sabangnet.co.kr/RTL_API/xml_cs_info.html?xml_url=";
    // 7.문의답변 등록 URL
    public static final String XML_INQUIRY_REPLY_URL = "http://r.sabangnet.co.kr/RTL_API/xml_cs_ans.html?xml_url=";

    // 8.상품 수집 URL
    public static final String XML_READ_GOODS_URL = "http://r.sabangnet.co.kr/RTL_API/xml_goods_read.html?xml_url=";
}



