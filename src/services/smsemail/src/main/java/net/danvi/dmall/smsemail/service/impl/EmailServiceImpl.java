package net.danvi.dmall.smsemail.service.impl;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.dao.JtaDao;
import net.danvi.dmall.smsemail.dao.ProxyDao;
import net.danvi.dmall.smsemail.model.EmailHistDelPO;
import net.danvi.dmall.smsemail.model.SmsEmailPointHistPO;
import net.danvi.dmall.smsemail.model.SmsEmailPointPO;
import net.danvi.dmall.smsemail.model.email.*;
import net.danvi.dmall.smsemail.model.request.EmailReceiverPO;
import net.danvi.dmall.smsemail.model.request.EmailSendPO;
import net.danvi.dmall.smsemail.service.EmailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import dmall.framework.common.model.ResultListModel;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dong on 2016-08-30.
 */
@Service("emailService")
public class EmailServiceImpl implements EmailService {
    Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ProxyDao proxyDao;

    @Autowired
    private JtaDao jtaDao;

    @Value(value = "#{smsemail['mail.id']}")
    private String mailId;

    @Value(value = "#{smsemail['mail.retryYn']}")
    private String retryYn;

    @Value(value = "#{smsemail['mail.retryCnt']}")
    private Integer retryCnt;

    @Value(value = "#{smsemail['mail.linkYn']}")
    private String linkYn;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Integer addPoint(String siteNo, Integer point, String gbCd) {

        log.debug("{} 에 {}포인트 추가", siteNo, point);

        SmsEmailPointPO po = new SmsEmailPointPO();
        po.setSiteNo(siteNo);
        po.setPoint(point);
        proxyDao.insert("email.updatePoint", po);
        SmsEmailPointHistPO histPO = new SmsEmailPointHistPO(po);
        histPO.setGbCd(gbCd);
        insertPointHist(histPO);

        return getPoint(siteNo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 포인트 이력 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    @Transactional(rollbackFor = Exception.class)
    private void insertPointHist(SmsEmailPointHistPO po) {
        if (po.getGbCd() == null) throw new RuntimeException("포인트 구분 코드가 존재하지 않습니다.");
        proxyDao.insert("email.insertPointHist", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : XA 처리중 포인트 이력 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    @Transactional(transactionManager = "jtaTransactionManager", rollbackFor = Exception.class)
    private void insertPointHistXa(SmsEmailPointHistPO po) {
        if (po.getGbCd() == null) throw new RuntimeException("포인트 구분 코드가 존재하지 않습니다.");
        jtaDao.insert(jtaDao.getMainXA(), "email.insertPointHist", po);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Integer subPoint(String siteNo, Integer point) {

        log.debug("{} 에서 {}포인트 차감", siteNo, point);

        SmsEmailPointPO po = new SmsEmailPointPO();
        po.setSiteNo(siteNo);
        po.setPoint(-(Math.abs(point)));
        proxyDao.insert("email.updatePoint", po);
        SmsEmailPointHistPO histPO = new SmsEmailPointHistPO(po);
        histPO.setGbCd("02"); // 전송차감
        insertPointHist(histPO);

        return getPoint(siteNo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : XA 처리중 포인트 차감
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @param point
     */
    @Transactional(transactionManager = "jtaTransactionManager", rollbackFor = Exception.class)
    private void subPointXa(String siteNo, Integer point) {
        log.debug("{} 에서 {}포인트 차감", siteNo, point);

        SmsEmailPointPO po = new SmsEmailPointPO();
        po.setSiteNo(siteNo);
        po.setPoint(-(Math.abs(point)));
        jtaDao.insert(jtaDao.getMainXA(), "email.updatePoint", po);
        SmsEmailPointHistPO histPO = new SmsEmailPointHistPO(po);
        histPO.setGbCd("02"); // 전송차감
        insertPointHistXa(histPO);
    }

    @Override
    @Transactional(transactionManager = "jtaTransactionManager", rollbackFor = Exception.class)
    public CustomerInfoPO send(EmailSendPO emailSendPO) throws CloneNotSupportedException {
        // 포인트 차감
        subPointXa(emailSendPO.getSiteNo(), emailSendPO.getEmailReceiverPOList().size());

        CustomerInfoPO customerInfoPO = new CustomerInfoPO(emailSendPO);
        CustomerDataPO customerDataPO;
        List<CustomerDataPO> customerDataPOList = new ArrayList<>();

        customerInfoPO.setUserId(mailId);
        customerInfoPO.setNeedRetry(retryYn);
        customerInfoPO.setRetryCount(retryCnt);
        customerInfoPO.setLinkYn(linkYn);
        customerInfoPO.setTotalCount(emailSendPO.getEmailReceiverPOList().size());

        // 처음 소프트 이메일 정보 등록(보내는이, 제목, 내용)
        jtaDao.insert(jtaDao.getEmailXA(), "email.insertCustomerInfo", customerInfoPO);
        emailSendPO.setMailSendNo(customerInfoPO.getId());
        EmailSendPO rawEmailSendPO = emailSendPO.clone();

        for (EmailReceiverPO po : emailSendPO.getEmailReceiverPOList()) {
            customerDataPO = new CustomerDataPO(po);
            customerDataPO.setId(customerInfoPO.getId());
            customerDataPOList.add(customerDataPO);
        }

        // 처음소프트 이메일 데이타 등록(받는이)
        jtaDao.insert(jtaDao.getEmailXA(), "email.insertCustomerData", customerDataPOList);

        // 메일 전송 이력 등록
        MailSendHistPO mailSendHistPO = new MailSendHistPO(emailSendPO);
        jtaDao.insert(jtaDao.getMainXA(), "email.insertMailSendHist", mailSendHistPO);

        // 메일 전송 상세 이력 등록
        List<MailSendHistDtlPO> mailSendHistDtlPOList = new ArrayList<>();
        MailSendHistDtlPO mailSendHistDtlPO;
        int dtlIdx = 0;
        for (EmailReceiverPO emailReceiverPO : rawEmailSendPO.getEmailReceiverPOList()) {
            mailSendHistDtlPO = new MailSendHistDtlPO(emailReceiverPO);
            mailSendHistDtlPO.setMailSendNo(emailSendPO.getMailSendNo());
            mailSendHistDtlPO.setMailSendDtlNo(++dtlIdx);
            mailSendHistDtlPO.setSiteNo(emailSendPO.getSiteNo());
            mailSendHistDtlPOList.add(mailSendHistDtlPO);
        }
        if (mailSendHistDtlPOList.size() > 0) {
            jtaDao.insert(jtaDao.getMainXA(), "email.insertMailSendDtlHist", mailSendHistDtlPOList);
        }

        return customerInfoPO;
    }

    @Override
    public void sendFinish(CustomerInfoPO customerInfoPO) {
        jtaDao.update(jtaDao.getEmailXA(), "email.updateCustomerInfo", customerInfoPO);
    }

    @Override
    public ResultListModel selectSendHistoryPaging(InnerEmailSendHistSO so) {
        return proxyDao.selectListPage("email.selectSendHistoryPaging", so);
    }

    @Override
    public EmailSendHistVO viewSendHistory(InnerEmailSendHistSO so) {
        // EmailSendHistVO result = proxyDao.selectOne("email.viewSendHistory", so);
        return proxyDao.selectOne("email.viewSendHistory", so);
    }

    @Override
    public Integer getPoint(String siteNo) {
        return proxyDao.selectOne("email.getPoint", siteNo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : XA 처리중 포인트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    private Integer getPointXa(Long siteNo) {
        return jtaDao.selectOne(jtaDao.getMainXA(), "email.getPoint", siteNo);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult deleteSendHistory(EmailHistDelPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        proxyDao.update("email.updateDelYn", po);

        return result;
    }
}
