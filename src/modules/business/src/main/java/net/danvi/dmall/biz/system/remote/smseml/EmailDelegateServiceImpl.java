package net.danvi.dmall.biz.system.remote.smseml;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.EmailSendPO;
import net.danvi.dmall.smsemail.service.EmailRemoteService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Slf4j
@Service("emailDelegateService")
public class EmailDelegateServiceImpl implements EmailDelegateService {

    @Resource(name = "emailRemoteService")
    private EmailRemoteService emailRemoteService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public RemoteBaseResult send(EmailSendPO emailSendPO) {
        RemoteBaseResult result;
        try {
            log.debug("대량메일 전송 건수 : {}", emailSendPO.getEmailReceiverPOList().size());
            emailSendPO.setCertKey(siteService.getSiteInfo(Long.parseLong(emailSendPO.getSiteNo())).getCertKey());
//            result = emailRemoteService.send(emailSendPO);
            result = new RemoteBaseResult();
            result.setSuccess(true);
        } catch (Exception e) {
            log.error("대량메일 전송 에러", e);
            result = new RemoteBaseResult();
            result.setSuccess(false);
        }

        log.debug(result.toString());
        return result;
    }
}
