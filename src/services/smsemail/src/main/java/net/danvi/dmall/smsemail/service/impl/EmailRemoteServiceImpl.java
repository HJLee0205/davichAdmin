package net.danvi.dmall.smsemail.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.email.CustomerInfoPO;
import net.danvi.dmall.smsemail.model.request.EmailSendPO;
import net.danvi.dmall.smsemail.service.CertKeyService;
import net.danvi.dmall.smsemail.service.EmailRemoteService;
import net.danvi.dmall.smsemail.service.EmailService;

/**
 * Created by dong on 2016-08-30.
 */
@Service("emailRemoteService")
public class EmailRemoteServiceImpl implements EmailRemoteService {
    Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private EmailService emailService;

    @Autowired
    private CertKeyService certKeyService;

    @Override
    public RemoteBaseResult send(EmailSendPO emailSendPO) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        try {
            String key = certKeyService.getCertKey(Long.parseLong(emailSendPO.getSiteNo()));
            CustomerInfoPO customerInfoPO;
            if (key.equals(emailSendPO.getCertKey())) {
                // 전송
                log.debug("대량메일 {}건 접수", emailSendPO.getEmailReceiverPOList().size());
                customerInfoPO = emailService.send(emailSendPO);
            } else {
                log.error("SMS/대량메일 인증키 불일치");
                result.setSuccess(false);
                result.setMessage("SMS/대량메일 인증키 불일치");
                return result;
            }
            // 등록 완료 플래그 처리
            /**
             * 이메일 정보를 발송 대기로 상태 변경
             * 현재 처음 소프트의 이메일 전송 테이블은 innoDB엔진이 아니라 트랜잭션 처리 안되서 send() 메소드 완료 후, 별도 처리
             */
            emailService.sendFinish(customerInfoPO);
            log.error("이메일 전송 완료");
        } catch (Exception e) {
            log.error("이메일 전송 에러", e);
            result.setSuccess(false);
            result.setMessage("대량 메일 전송 에러");
        }

        return result;
    }

}
