package net.danvi.dmall.biz.batch.link.sabangnet.handler;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetResult;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 결과 XML 읽기를 위한 SAX 핸들러
 * </pre>
 */
@Slf4j
public class SabangnetHandler<T> extends DefaultHandler {
    private String positionInRaw;
    private String elementName;
    private SabangnetResult<T> result;
    private T data;
    private List<T> dataList;
    private Class<T> tClass;

    public SabangnetHandler(Class<T> orderClass) {
        this.tClass = orderClass;
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
     * @return
     */
    public SabangnetResult<T> getParsedResult() {
        return result;
    }

    @Override
    public void startDocument() throws SAXException {
        log.debug("startDocument");
        this.dataList = new ArrayList<>();
    }

    @Override
    public void endDocument() throws SAXException {
        log.debug("endDocument");
    }

    @Override
    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        log.debug("startElement");
        log.debug("uri : {}", uri);
        log.debug("localName : {}", localName);
        log.debug("qName : {}", qName);

        switch (qName) {
        case "SABANG_ORDER_LIST": // 주문/클레임
            result = new SabangnetResult<>(); // 결과 객체 생성
            positionInRaw = "base";
            break;
        case "SABANG_CS_LIST": // 문의사항
            result = new SabangnetResult<>(); // 결과 객체 생성
            positionInRaw = "base";
            break;
        case "DATA": // 상세 결과 데이터
            data = createNewInstance(); // 데이터 객체 생성
            positionInRaw = "data";
            break;
        case "HEADER": // 헤더
            elementName = "";
            break;
        default:
            elementName = qName;
        }
    }

    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        log.debug("endElement");

        switch (qName) {
        case "SABANG_ORDER_LIST": // 주문/클레임
            result.setData(dataList);
            break;
        case "SABANG_CS_LIST": // 문의사항
            result.setData(dataList);
            break;
        case "DATA": // 결과 데이터
            dataList.add(data);
            positionInRaw = "base";
            break;
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        log.debug("start : {}", start);
        log.debug("length : {}", length);
        log.debug("positionInOrderRaw : {}", positionInRaw);

        if (elementName == null || "".equals(elementName)) return;

        // XML의 엘리먼트로 Setter 메소드명을 생성해서 리플렉션을 이용해 데이터 세팅
        String methodName = "set" + StringUtil.toCamelCase(elementName, true);
        log.debug("methodName : {}", methodName);

        Class<? extends Object> cls;
        Object targetObject;
        Method m;

        // 원시 데이터에서의 위치로 리플렉션을 적용할 객체를 분기
        if ("data".equals(positionInRaw)) {
            cls = data.getClass();
            targetObject = data;
        } else {
            cls = result.getClass();
            targetObject = result;
        }

        try {
            m = cls.getMethod(methodName, String.class);
            m.invoke(targetObject, new String(ch, start, length).trim());
            elementName = "";
        } catch (NoSuchMethodException e) {
            log.debug("## No {} into the {} class.", methodName, cls.getName(), e);
        } catch (InvocationTargetException e) {
            log.debug("## {}, {} InvocationTargetException : {}", methodName, cls.getName(), e);
        } catch (IllegalAccessException e) {
            log.debug("## {}, {} InvocationTargetException : {}", methodName, cls.getName(), e);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 제네릭 타입에 해당하는 인스턴스를 생성
     *          오류시 null 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @return 사방넷 결과 객체의 Data에 해당하는 인스턴스
     */
    private T createNewInstance() {
        try {
            return tClass.newInstance();
        } catch (InstantiationException e) {
            log.debug("## InstantiationException : {}", e);
        } catch (IllegalAccessException e) {
            log.debug("## IllegalAccessException : {}", e);
        }

        return null;
    }
}
