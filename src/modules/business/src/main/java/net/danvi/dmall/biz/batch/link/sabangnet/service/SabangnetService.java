package net.danvi.dmall.biz.batch.link.sabangnet.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import net.danvi.dmall.biz.batch.link.sabangnet.batch.job.model.SabangnetTargetCompanyVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;
import net.danvi.dmall.biz.batch.link.sabangnet.model.request.*;
import org.xml.sax.SAXException;

public interface SabangnetService {

    List<SabangnetTargetCompanyVO> selectTargetCompany(String ifPgmNo);

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 :
     * 설명   : 사방넷 연계
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 13.        - 최초생성
     * </pre>
     *
     * @param param
     * @param domain
     */
    // 1.사방넷 상품등록&수정
    public void registGoods(ProcRunnerVO param, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 2.사방넷 상품요약수정
    public void smrUpdGoods(ProcRunnerVO param, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 3.사방넷 주문수집 요청XML 생성
    public String createOrderRequestXml(OrderRequest orderRequest, List<Order> order, ProcRunnerVO param)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 3.사방넷 주문수집
    public void getherOrder(String domain, String xmlFileName, ProcRunnerVO vo)
            throws ParserConfigurationException, SAXException, IOException;

    // 4.사방넷 송장등록
    public void registInvoice(ProcRunnerVO param, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 5.사방넷 클레임수집 요청XML 생성
    public String createClaimRequestXml(ClaimRequest claimRequest, List<Claim> claim, ProcRunnerVO param)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 5.사방넷 클레임수집
    public void getherClaim(String domain, String xmlFileName, ProcRunnerVO vo)
            throws ParserConfigurationException, SAXException, IOException;

    // 6.사방넷 문의사항수집 요청XML 생성
    public String createInquiryRequestXml(InquiryRequest inquiryRequest, List<Inquiry> inquiry, ProcRunnerVO param)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 6.사방넷 문의사항수집
    public void getherInquiry(String domain, String xmlFileName, ProcRunnerVO vo)
            throws ParserConfigurationException, SAXException, IOException;

    // 7.사방넷 문의답변등록
    public void registInquiryReply(ProcRunnerVO param, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;


    // 8.사방넷 상품수집 요청XML 생성
    public String createGoodsRequestXml(GoodsRequest goodsRequest, List<Goods> goods, ProcRunnerVO param)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;
}
