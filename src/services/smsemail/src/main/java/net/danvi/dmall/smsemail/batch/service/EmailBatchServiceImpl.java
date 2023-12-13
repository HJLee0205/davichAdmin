package net.danvi.dmall.smsemail.batch.service;

import java.util.List;

import net.danvi.dmall.smsemail.model.email.EmailSendHistVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import net.danvi.dmall.smsemail.dao.JtaDao;
import net.danvi.dmall.smsemail.dao.ProxyDao;

/**
 * <pre>
 * 프로젝트명 : 11.business
 * 작성일     : 2016. 9. 23.
 * 작성자     : kjw
 * 설명       : 대량메일 발송 관련 배치 Service
 * </pre>
 */
@Service("emailBatchService")
public class EmailBatchServiceImpl implements EmailBatchService {

    private static final Logger log = LoggerFactory.getLogger(EmailBatchServiceImpl.class);

    @Autowired
    private ProxyDao proxyDao;

    @Autowired
    private JtaDao jtaDao;

    public List<EmailSendHistVO> selectEmailSendingList() {
        return proxyDao.selectList("email.selectEmailSendingList");
    }

    public List<EmailSendHistVO> selectEmailSendCompletList(List<EmailSendHistVO> emailSendCompletList) {
        return jtaDao.selectList(jtaDao.getEmailXA(), "email.emailSendCompletList", emailSendCompletList);
    }

    public void updateEmailSendResult(EmailSendHistVO vo) {
        proxyDao.update("email.updateEmailSendResult", vo);
    }

    public String selectEmailSucsCnt(EmailSendHistVO vo) {
        return jtaDao.selectOne(jtaDao.getEmailXA(), "email.selectEmailSucsCnt", vo);
    }

}
