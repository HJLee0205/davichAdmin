package net.danvi.dmall.smsemail.batch.service;

import java.util.List;

import net.danvi.dmall.smsemail.dao.ProxyDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import net.danvi.dmall.smsemail.model.sms.SmsSendHistVO;

/**
 * <pre>
 * 프로젝트명 : 11.business
 * 작성일     : 2016. 8. 17.
 * 작성자     : parkyt
 * 설명       : 회원 관련 배치 Service
 * </pre>
 */
@Service("smsBatchService")
public class SmsBatchServiceImpl implements SmsBatchService {

    private static final Logger log = LoggerFactory.getLogger(SmsBatchServiceImpl.class);

    @Autowired
    private ProxyDao proxyDao;

    public List<SmsSendHistVO> smsFailCountListReader() {
        return proxyDao.selectList("sms.selectSmsFailListCount");
    }

    public List<SmsSendHistVO> lmsFailCountListReader() {
        return proxyDao.selectList("sms.selectLmsFailListCount");
    }

    public void updSmsStatus() {
        proxyDao.update("sms.updateSmsFailStatus");
    }

    public void updLmsStatus() {
        proxyDao.update("sms.updateLmsFailStatus");
    }

    public void updateSmsFailPointAdd(SmsSendHistVO vo) {
        proxyDao.update("sms.updateSmsFailPointAdd", vo);
    }
}
