package net.danvi.dmall.smsemail.service.impl;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.request.Sms080RecvRjtVO;
import net.danvi.dmall.smsemail.model.request.SmsSendPO;
import net.danvi.dmall.smsemail.model.request.SmsSendSO;
import net.danvi.dmall.smsemail.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by dong on 2016-09-01.
 */
@Service("smsRemoteService")
@Transactional
public class SmsRemoteServiceImpl implements SmsRemoteService {
    Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private SmsService smsService;

    @Autowired
    private Sms080RejectService sms080RejectService;

    @Autowired
    private CertKeyService certKeyService;

    @Resource(name = "memberService")
    private MemberService memberService;

    @Override
    public RemoteBaseResult send(Long siteNo, List<SmsSendPO> list, String certKey) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        try {
            // 전송
            /*String key = certKeyService.getCertKey(siteNo);*/
            /*if(key.equals(certKey)) {*/
                log.debug("SMS {}건 접수", list.size());
                smsService.send("" + siteNo, list);
                log.debug("SMS 전송 완료");
/*            } else {
                log.error("SMS/대량메일 인증키 불일치");
                result.setSuccess(false);
                result.setMessage("SMS/대량메일 인증키 불일치");
            }*/
        } catch (Exception e) {
            log.error("SMS 전송 에러", e);
            result.setSuccess(false);
            result.setMessage("SMS 메일 전송 에러");
        }

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Sms080RecvRjtVO> select080RectList(String certKey) {
        return sms080RejectService.select080RectList();
    }

    @Override
    public RemoteBaseResult updateProcYn(String certKey, List<Sms080RecvRjtVO> list) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);
        try {
            sms080RejectService.updateProcYn(list);
        } catch (Exception e) {
            result.setSuccess(false);
        }

        return result;
    }


     @Override
    public RemoteBaseResult send(Long siteNo, SmsSendPO po, String certKey, String smsMember, SmsSendSO smsSendSO) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        try {
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        	log.info("Sms LOG ... 전송시작");
        	log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

            // 전송
            List<MemberManageVO> rstList = null;

            if(smsMember.equals("all")){
                rstList = memberService.viewTotalSmsListPaging(smsSendSO,po);
            }else if(smsMember.equals("search")){
                rstList = memberService.viewTotalSmsListPaging(smsSendSO,po);
            }else{
            }
    		log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
    		log.info("Sms LOG ... 전송완료");
    		log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

            //smsService.send("" + siteNo, po,smsMember);
            //log.debug("SMS 전송 완료");
        } catch (Exception e) {
            log.error("SMS 전송 에러", e);
            result.setSuccess(false);
            result.setMessage("SMS 메일 전송 에러");
        }

        return result;
    }
}
