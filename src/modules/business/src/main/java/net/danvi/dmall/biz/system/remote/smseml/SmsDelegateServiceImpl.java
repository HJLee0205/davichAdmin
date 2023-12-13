package net.danvi.dmall.biz.system.remote.smseml;

import dmall.framework.common.util.BeansUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.Sms080RecvRjtVO;
import net.danvi.dmall.smsemail.model.request.SmsSendPO;

import net.danvi.dmall.smsemail.service.SmsRemoteService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Slf4j
@Service("smsDelegateService")
public class SmsDelegateServiceImpl implements SmsDelegateService {

    @Resource(name = "smsRemoteService")
    private SmsRemoteService smsRemoteService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public RemoteBaseResult send(Long siteNo, List<SmsSendPO> list) {
        RemoteBaseResult result;
        try {
            log.debug("SMS 전송 건수 : {}", list.size());
            result = smsRemoteService.send(siteNo, list, siteService.getSiteInfo(siteNo).getCertKey());
            result = new RemoteBaseResult();
            result.setSuccess(true);
        } catch (Exception e) {
            log.error("SMS 전송 에러", e);
            result = new RemoteBaseResult();
            result.setSuccess(false);
        }

        log.debug(result.toString());

        return result;
    }

   /* @Override
    public RemoteBaseResult send(Long siteNo, SmsSendPO po, String smsMember) {
        RemoteBaseResult result;
        try {
            result = smsRemoteService.send(siteNo, po, siteService.getSiteInfo(siteNo).getCertKey(),smsMember);
            result = new RemoteBaseResult();
            result.setSuccess(true);
        } catch (Exception e) {
            log.error("SMS 전송 에러", e);
            result = new RemoteBaseResult();
            result.setSuccess(false);
        }

        log.debug(result.toString());

        return result;
    }*/

    @Override
    public RemoteBaseResult send(Long siteNo, SmsSendPO po, String smsMember, SmsSendSO smsSendSO) {
        RemoteBaseResult result = new RemoteBaseResult();
        try {
            net.danvi.dmall.smsemail.model.request.SmsSendSO so = BeansUtil.copyProperties(smsSendSO, null, net.danvi.dmall.smsemail.model.request.SmsSendSO.class);
            if(smsSendSO.getMemberManageSO()!=null) {
                net.danvi.dmall.smsemail.model.request.MemberManageSO memberManageSO = BeansUtil.copyProperties(smsSendSO.getMemberManageSO(), null, net.danvi.dmall.smsemail.model.request.MemberManageSO.class);
                so.setMemberManageSO(memberManageSO);
            }
            result = smsRemoteService.send(siteNo, po, siteService.getSiteInfo(siteNo).getCertKey(),smsMember,so);
            result.setSuccess(true);
        } catch (Exception e) {
            log.error("SMS 전송 에러", e);
            result = new RemoteBaseResult();
            result.setSuccess(false);
        }

        log.debug(result.toString());

        return result;
    }


    @Override
    public List<Sms080RecvRjtVO> select080RectList() {
        return smsRemoteService.select080RectList("");
    }

    @Override
    public RemoteBaseResult updateProcYn(List<Sms080RecvRjtVO> list) {
        return smsRemoteService.updateProcYn("", list);
    }


}
