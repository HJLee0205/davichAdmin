package net.danvi.dmall.biz.batch.link.sabangnet;

import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import net.danvi.dmall.biz.batch.link.sabangnet.handler.SabangnetHandler;
import net.danvi.dmall.biz.batch.link.sabangnet.model.result.GoodsResult;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetResult;
import net.danvi.dmall.biz.batch.link.sabangnet.model.result.ClaimResult;
import net.danvi.dmall.biz.batch.link.sabangnet.model.result.CsResult;
import net.danvi.dmall.biz.batch.link.sabangnet.model.result.OrderResult;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계용 XML 리더 클래스
 * </pre>
 */
public class SabangnetReader {

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 주문 정보 XML을 읽어서 결과 반환(utf-8)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param url
     * @return
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws IOException
     */
    public static SabangnetResult<OrderResult> readOrder(String url)
            throws ParserConfigurationException, SAXException, IOException {
        return readOrder(url, "UTF-8");
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 주문 정보 XML을 읽어서 결과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param url
     * @param encoding
     * @return
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws IOException
     */
    public static SabangnetResult<OrderResult> readOrder(String url, String encoding)
            throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        SabangnetHandler<OrderResult> orderHandler = new SabangnetHandler<>(OrderResult.class);
        InputSource is = new InputSource(url);
        is.setEncoding(encoding);
        saxParser.parse(is, orderHandler);

        return orderHandler.getParsedResult();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 클레임 정보 XML을 읽어서 결과 반환(utf-8)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param url
     * @return
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws IOException
     */
    public static SabangnetResult<ClaimResult> readClaim(String url)
            throws ParserConfigurationException, SAXException, IOException {
        return readClaim(url, "UTF-8");
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 클레임 정보 XML을 읽어서 결과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param url
     * @param encoding
     * @return
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws IOException
     */
    public static SabangnetResult<ClaimResult> readClaim(String url, String encoding)
            throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        SabangnetHandler<ClaimResult> claimHandler = new SabangnetHandler<>(ClaimResult.class);
        InputSource is = new InputSource(url);
        is.setEncoding(encoding);
        saxParser.parse(is, claimHandler);

        return claimHandler.getParsedResult();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 문의사항 정보 XML을 읽어서 결과 반환(utf-8)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param url
     * @return
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws IOException
     */
    public static SabangnetResult<CsResult> readCs(String url)
            throws ParserConfigurationException, SAXException, IOException {
        return readCs(url, "UTF-8");
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 문의사항 정보 XML을 읽어서 결과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param url
     * @param encoding
     * @return
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws IOException
     */
    public static SabangnetResult<CsResult> readCs(String url, String encoding)
            throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        SabangnetHandler<CsResult> csHandler = new SabangnetHandler<>(CsResult.class);
        InputSource is = new InputSource(url);
        is.setEncoding(encoding);
        saxParser.parse(is, csHandler);

        return csHandler.getParsedResult();
    }


    public static SabangnetResult<CsResult> readCsXml(String xmlURI, String encoding)
            throws ParserConfigurationException, SAXException, IOException {
        // TODO Auto-generated method stub
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        SabangnetHandler<CsResult> orderHandler = new SabangnetHandler<>(CsResult.class);
        InputSource is = new InputSource(xmlURI);
        is.setEncoding(encoding);
        saxParser.parse(is, orderHandler);

        return orderHandler.getParsedResult();
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 7.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 7. dong - 최초생성
     * </pre>
     *
     * @param xmlURI
     * @param lang
     * @return
     * @throws SAXException
     * @throws ParserConfigurationException
     * @throws IOException
     */
    public static SabangnetResult<OrderResult> readOrderXml(String xmlURI, String encoding)
            throws ParserConfigurationException, SAXException, IOException {
        // TODO Auto-generated method stub
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        SabangnetHandler<OrderResult> orderHandler = new SabangnetHandler<>(OrderResult.class);
        InputSource is = new InputSource(xmlURI);
        is.setEncoding(encoding);
        saxParser.parse(is, orderHandler);

        return orderHandler.getParsedResult();
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 20.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 20. dong - 최초생성
     * </pre>
     *
     * @param string
     * @param lang
     * @return
     */
    public static SabangnetResult<ClaimResult> readClaimXml(String xmlURI, String encoding)
            throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        SabangnetHandler<ClaimResult> claimHandler = new SabangnetHandler<>(ClaimResult.class);
        InputSource is = new InputSource(xmlURI);
        is.setEncoding(encoding);
        saxParser.parse(is, claimHandler);

        return claimHandler.getParsedResult();
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 28.
     * 작성자 : dong
     * 설명   : 상품 정보 XML을 읽어서 결과 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 28. dong - 최초생성
     * </pre>
     *
     * @param url
     * @param encoding
     * @return
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws IOException
     */
    public static SabangnetResult<GoodsResult> readGoods(String url, String encoding)
            throws ParserConfigurationException, SAXException, IOException {
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        SabangnetHandler<GoodsResult> goodsHandler = new SabangnetHandler<>(GoodsResult.class);
        InputSource is = new InputSource(url);
        is.setEncoding(encoding);
        saxParser.parse(is, goodsHandler);

        return goodsHandler.getParsedResult();
    }

     /**
     * <pre>
     * 작성일 : 2016. 9. 7.
     * 작성자 : dong
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * </pre>
     *
     * @param xmlURI
     * @param lang
     * @return
     * @throws SAXException
     * @throws ParserConfigurationException
     * @throws IOException
     */
    public static SabangnetResult<GoodsResult> readGoodsXml(String xmlURI, String encoding)
            throws ParserConfigurationException, SAXException, IOException {
        // TODO Auto-generated method stub
        SAXParserFactory factory = SAXParserFactory.newInstance();
        SAXParser saxParser = factory.newSAXParser();
        SabangnetHandler<GoodsResult> orderHandler = new SabangnetHandler<>(GoodsResult.class);
        InputSource is = new InputSource(xmlURI);
        is.setEncoding(encoding);
        saxParser.parse(is, orderHandler);

        return orderHandler.getParsedResult();
    }
}
