package net.danvi.dmall.biz.system.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.WebLogPO;
import net.danvi.dmall.biz.system.remote.homepage.model.HomepageIfLogPO;
import net.danvi.dmall.biz.system.remote.maru.model.MaruResult;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import dmall.framework.common.BaseService;

/**
 * Created by dong on 2016-07-13.
 */
@Slf4j
@Service("loggerService")
public class LoggerServiceImpl extends BaseService implements LoggerService {

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Async
    public void insert(WebLogPO po) {
        proxyDao.insert("system.logger.insertAccessLog", po);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Async
    public void insertHomepageIf(HomepageIfLogPO po) {
        proxyDao.insert("system.logger.insertHomepageIFLog", po);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Async
    public void insertMaruResultIf(MaruResult result) {
        ObjectMapper om = new ObjectMapper();
        String ifContent;
        try {
            ifContent = om.writeValueAsString(result);
        } catch (JsonProcessingException e) {
            log.error("인터페이스 객체 매핑 처리 오류", e);
            return;
        }
        HomepageIfLogPO po = new HomepageIfLogPO();
        po.setSiteId(result.getSiteId());
        po.setSiteNo(result.getSiteNo());
        po.setIoGb("M");
        po.setIfContent(ifContent);
        proxyDao.insert("system.logger.insertHomepageIFLog", po);
    }
}
