package net.danvi.dmall.biz.batch.link.sabangnet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.*;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetRequest;
import dmall.framework.common.annotation.CDATA;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계 XML 롸이터 클래스
 * </pre>
 */
@Slf4j
public class SabangnetWriter {

    /**
     * <pre>
     * 작성일 : 2016. 7. 19.
     * 작성자 : dong
     * 설명   : 사방넷 연계 등록 XML 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param goodsRequest
     * @param pathName
     * @throws ParserConfigurationException
     * @throws IOException
     * @throws IllegalAccessException
     * @throws NoSuchMethodException
     * @throws InvocationTargetException
     */
    // 1.사방넷 상품등록&수정 XML 생성
    public static void writeGoods(GoodsRequest goodsRequest, String pathName, String encoding)
            throws IOException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Document doc = new Document();
        Element root = new Element("SABANG_GOODS_REGI"); // rootElement 생성
        addGoodsHeader(root, goodsRequest); // 헤더 생성
        addData(root, goodsRequest.getData()); // 데이터 생성
        doc.addContent(root);
        write(doc, pathName, encoding);
    }

    // 1.사방넷 상품등록&수정 헤더 추가
    private static void addGoodsHeader(Element root, GoodsRequest request) {
        Element header = new Element("HEADER");
        addElement(header, "SEND_COMPAYNY_ID", request.getSendCompaynyId());
        addElement(header, "SEND_AUTH_KEY", request.getSendAuthKey());
        addElement(header, "SEND_DATE", request.getSendDate());
        addElement(header, "SEND_GOODS_CD_RT", request.getSendGoodsCdRt());

        // if ("UTF-8".equals(request.getSendGoodsCdRt())) {
        // addElement(header, "SEND_GOODS_CD_RT", request.getSendGoodsCdRt());
        // }
        root.addContent(header);
    }

    // 2.사방넷 상품요약수정 XML 생성
    public static void writeGoodsSmrUpd(GoodsSmrUpdRequest goodsSmrUpdRequest, String pathName, String encoding)
            throws IOException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Document doc = new Document();
        Element root = new Element("SABANG_GOODS_REGI"); // rootElement 생성
        addGoodsSmrUpdHeader(root, goodsSmrUpdRequest); // 헤더 생성
        addData(root, goodsSmrUpdRequest.getData()); // 데이터 생성
        doc.addContent(root);
        write(doc, pathName, encoding);
    }

    // 2.사방넷 상품요약수정 헤더 추가
    private static void addGoodsSmrUpdHeader(Element root, GoodsSmrUpdRequest request) {
        Element header = new Element("HEADER");
        addElement(header, "SEND_COMPAYNY_ID", request.getSendCompaynyId());
        addElement(header, "SEND_AUTH_KEY", request.getSendAuthKey());
        addElement(header, "SEND_DATE", request.getSendDate());
        addElement(header, "SEND_GOODS_CD_RT", request.getSendGoodsCdRt());

        // if ("UTF-8".equals(request.getSendGoodsCdRt())) {
        // addElement(header, "SEND_GOODS_CD_RT", request.getSendGoodsCdRt());
        // }
        root.addContent(header);
    }

    // 4.사방넷 송장등록 XML 생성
    public static void writeInvoice(InvoiceRequest invoiceRequest, String pathName, String encoding)
            throws IOException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Document doc = new Document();
        Element root = new Element("SABANG_INV_REGI"); // rootElement 생성
        addInvoiceHeader(root, invoiceRequest); // 헤더 생성
        addData(root, invoiceRequest.getData()); // 데이터 생성
        doc.addContent(root);
        write(doc, pathName, encoding);
    }

    // 4.사방넷 송장등록 헤더 추가
    private static void addInvoiceHeader(Element root, InvoiceRequest request) {
        Element header = new Element("HEADER");
        addElement(header, "SEND_COMPAYNY_ID", request.getSendCompaynyId());
        addElement(header, "SEND_AUTH_KEY", request.getSendAuthKey());
        addElement(header, "SEND_DATE", request.getSendDate());
        addElement(header, "SEND_INV_EDIT_YN", request.getSendInvEditYn());

        // if ("UTF-8".equals(request.getSendInvEditYn())) {
        // addElement(header, "SEND_INV_EDIT_YN", request.getSendInvEditYn());
        // }
        root.addContent(header);
    }

    // 7.사방넷 문의답변등록 XML 생성
    public static void writeInquiryReply(InquiryReplyRequest inquiryReplyRequest, String pathName, String encoding)
            throws IOException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Document doc = new Document();
        Element root = new Element("SABANG_CS_ANS_REGI"); // rootElement 생성
        addInquiryReplyHeader(root, inquiryReplyRequest); // 헤더 생성
        addData(root, inquiryReplyRequest.getData()); // 데이터 생성
        doc.addContent(root);
        write(doc, pathName, encoding);
    }

    // 7.사방넷 문의답변등록 헤더 추가
    private static void addInquiryReplyHeader(Element root, InquiryReplyRequest request) {
        Element header = new Element("HEADER");
        addElement(header, "SEND_COMPAYNY_ID", request.getSendCompaynyId());
        addElement(header, "SEND_AUTH_KEY", request.getSendAuthKey());
        addElement(header, "SEND_DATE", request.getSendDate());

        root.addContent(header);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 19.
     * 작성자 : dong
     * 설명   : 사방넷 연계 수집 요청용 XML 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param request
     * @param pathName
     * @throws IOException
     * @throws IllegalAccessException
     * @throws NoSuchMethodException
     * @throws InvocationTargetException
     */
    // 3.사방넷 주문수집 요청 XML 생성
    public static void writeOrder(OrderRequest request, String pathName, List<Order> listData, String encoding)
            throws IOException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Document doc = new Document();
        Element root = new Element("SABANG_ORDER_LIST"); // rootElement 생성
        addHeader(root, request); // 헤더 생성
        addData(root, listData); // 데이터 생성
        doc.setRootElement(root);
        write(doc, pathName, encoding);
    }

    // 5.사방넷 클레임수집 요청 XML 생성
    public static void writeClaim(ClaimRequest request, String pathName, List<Claim> listData, String encoding)
            throws IOException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Document doc = new Document();
        Element root = new Element("SABANG_CLAIM_LIST"); // rootElement 생성
        addHeader(root, request); // 헤더 생성
        addData(root, listData); // 데이터 생성
        doc.setRootElement(root);
        write(doc, pathName, encoding);
    }

    // 6.사방넷 문의사항수집 요청 XML 생성
    public static void writeInquiry(InquiryRequest request, String pathName, List<Inquiry> listData, String encoding)
            throws IOException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Document doc = new Document();
        Element root = new Element("SABANG_CS_LIST"); // rootElement 생성
        addHeader(root, request); // 헤더 생성
        addData(root, listData); // 데이터 생성
        doc.setRootElement(root);
        write(doc, pathName, encoding);
    }

    // 8.사방넷 상품수집 요청 XML 생성
    public static void writeGoods(GoodsRequest request, String pathName, List<Goods> listData, String encoding)
            throws IOException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Document doc = new Document();
        Element root = new Element("SABANG_GOODS_LIST"); // rootElement 생성
        addHeader(root, request); // 헤더 생성
        addData(root, listData); // 데이터 생성
        doc.setRootElement(root);
        write(doc, pathName, encoding);
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 문서에 공통 헤더 엘리먼트생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param root
     * @param request
     */
    private static void addHeader(Element root, SabangnetRequest<? extends SabangnetData> request) {
        Element header = new Element("HEADER");
        addElement(header, "SEND_COMPAYNY_ID", request.getSendCompaynyId());
        addElement(header, "SEND_AUTH_KEY", request.getSendAuthKey());
        addElement(header, "SEND_DATE", request.getSendDate());
        root.addContent(header);
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 문서에 데이터 엘리먼트 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param root
     * @param dataList
     */
    private static void addData(Element root, List<? extends SabangnetData> dataList)
            throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        Element data;

        if (dataList == null) {
            return;
        }

        for (Object obj : dataList) {
            data = new Element("DATA");
            addElement(data, obj);
            root.addContent(data);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 리플렉션을 이용해 부모 엘리먼트에 엘리먼트 추가
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param parent
     * @param elementName
     * @param value
     */
    private static void addElement(Element parent, String elementName, String value) {
        Element element = new Element(elementName);
        element.setText(value);
        parent.addContent(element);
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param parent
     * @param obj
     * @throws IllegalAccessException
     * @throws InvocationTargetException
     */
    private static void addElement(Element parent, Object obj)
            throws IllegalAccessException, InvocationTargetException {
        Element element;

        Class<? extends Object> cls = obj.getClass();
        Field[] fields = cls.getDeclaredFields();
        Annotation a;
        String name;
        String value;
        org.jdom2.CDATA cdata;

        for (Field field : fields) {
            name = field.getName();
            if ("serialVersionUID".equals(name)) continue; // Serializable 을 위한 UID 제외

            field.setAccessible(true);
            if (name.equals("char1Nm")) {
                name = "CHAR_1_NM";
            } else if (name.equals("char1Val")) {
                name = "CHAR_1_VAL";
            } else if (name.equals("char2Nm")) {
                name = "CHAR_2_NM";
            } else if (name.equals("char2Val")) {
                name = "CHAR_2_VAL";
            } else if (name.equals("prop1Cd")) {
                name = "PROP1_CD";
            } else if (name.equals("propVal1")) {
                name = "PROP_VAL1";
            } else if (name.equals("propVal2")) {
                name = "PROP_VAL2";
            } else if (name.equals("propVal3")) {
                name = "PROP_VAL3";
            } else if (name.equals("propVal4")) {
                name = "PROP_VAL4";
            } else if (name.equals("propVal5")) {
                name = "PROP_VAL5";
            } else if (name.equals("propVal6")) {
                name = "PROP_VAL6";
            } else if (name.equals("propVal7")) {
                name = "PROP_VAL7";
            } else if (name.equals("propVal8")) {
                name = "PROP_VAL8";
            } else if (name.equals("propVal9")) {
                name = "PROP_VAL9";
            } else if (name.equals("propVal10")) {
                name = "PROP_VAL10";
            } else if (name.equals("propVal11")) {
                name = "PROP_VAL11";
            } else if (name.equals("propVal12")) {
                name = "PROP_VAL12";
            } else if (name.equals("propVal13")) {
                name = "PROP_VAL13";
            } else if (name.equals("propVal14")) {
                name = "PROP_VAL14";
            } else if (name.equals("propVal15")) {
                name = "PROP_VAL15";
            } else if (name.equals("propVal16")) {
                name = "PROP_VAL16";
            } else if (name.equals("propVal17")) {
                name = "PROP_VAL17";
            } else if (name.equals("propVal18")) {
                name = "PROP_VAL18";
            } else if (name.equals("propVal19")) {
                name = "PROP_VAL19";
            } else if (name.equals("propVal20")) {
                name = "PROP_VAL20";
            } else if (name.equals("propVal21")) {
                name = "PROP_VAL21";
            } else if (name.equals("propVal22")) {
                name = "PROP_VAL22";
            } else if (name.equals("propVal23")) {
                name = "PROP_VAL23";
            } else if (name.equals("propVal24")) {
                name = "PROP_VAL24";
            } else if (name.equals("propVal25")) {
                name = "PROP_VAL25";
            } else if (name.equals("propVal26")) {
                name = "PROP_VAL26";
            } else if (name.equals("propVal27")) {
                name = "PROP_VAL27";
            } else if (name.equals("propVal28")) {
                name = "PROP_VAL28";
            } else {
                name = StringUtil.toUnCamelCase(name);
            }


            element = new Element(name);
            value = String.valueOf(field.get(obj));

            if (name.equals("SKU_INFO")) {
                if (!value.equals("null") && value != "" && value != null) {
                    String[] skuInfo = value.split(",");
                    for (int i = 0; i < skuInfo.length; i++) {
                        addElement(element, "SKU_VALUE", skuInfo[i]);
                    }
                }
                parent.addContent(element);
            } else {


                StringBuffer out = new StringBuffer();
                char current;

                for (int i = 0; i < value.length(); i++) {
                    current = value.charAt(i);
                    if ((current == 0x9) ||
                            (current == 0xA) ||
                            (current == 0xD) ||
                            ((current >= 0x20) && (current <= 0xD7FF)) ||
                            ((current >= 0xE000) && (current <= 0xFFFD)) ||
                            ((current >= 0x10000) && (current <= 0x10FFFF)))
                        out.append(current);
                }
                value = out.toString();

                a = field.getAnnotation(CDATA.class);

                if ("null".equals(value)) {
                    // value가 "null"이면 에리먼트트엔 빈값 세팅
                    element.setText("");
                }

                if (a != null && a.annotationType() == CDATA.class) {
                    if ("null".equals(value)) {
                        value = "";
                    }
                    cdata = new org.jdom2.CDATA(value);

                    element.setContent(cdata);
                } else {
                    if ("null".equals(value)) {
                        // value가 "null"이면 에리먼트트엔 빈값 세팅
                        element.setText("");
                    } else {
                        element.setText(value);
                    }
                }

                parent.addContent(element);
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 지정한 경로에 XML 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param doc
     * @param pathName
     * @throws IOException
     */
    private static void write(Document doc, String pathName, String encoding) throws IOException {
        File file = new File(pathName);

        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        log.debug("sabangnet doc to XML : {}", doc);
        log.debug("sabangnet XML : {}", file.getAbsolutePath());

        FileOutputStream out = new FileOutputStream(file);
        try {
            // xml 파일을 떨구기 위한 경로와 파일 이름 지정해 주기
            XMLOutputter serializer = new XMLOutputter(Format.getPrettyFormat().setEncoding(encoding));
            serializer.output(doc, out);
            out.flush();
            out.close();

        } catch (IOException e) {
            log.debug("Sabangnet XML Writer Exception ERORR!", e);
            throw e;
        } finally {
            try {
                out.close();
            } catch (Exception e) {
                log.debug("Sabangnet XML Writer finally Exception ERORR!", e);
            }
        }
    }
}
