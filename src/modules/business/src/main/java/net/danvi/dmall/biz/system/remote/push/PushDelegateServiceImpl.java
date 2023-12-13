package net.danvi.dmall.biz.system.remote.push;

import javax.annotation.Resource;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.service.AppPushService;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import net.danvi.dmall.smsemail.service.PushRemoteService;

@Slf4j
@Service("pushDelegateService")
public class PushDelegateServiceImpl implements PushDelegateService {

    @Resource(name = "pushRemoteService")
    private PushRemoteService pushRemoteService;

    @Resource(name = "siteService")
    private SiteService siteService;
    

    @Override
    public RemoteBaseResult send(PushSendPO pushSendPO) throws Exception {
        RemoteBaseResult result;
        try {
            /**
             * 푸시서버 전송호출 (연계)
             */
        	pushRemoteService.send(pushSendPO);
            result = new RemoteBaseResult();
            result.setSuccess(true);
        } catch (Exception e) {
            log.error("푸시 전송 에러", e);
            result = new RemoteBaseResult();
            result.setSuccess(false);
//            throw new Exception("푸시서버 전송시 오류가 발생했습니다.");
        }

        log.debug(result.toString());
        return result;
    }
    
    @Override
    public RemoteBaseResult isConnect(PushSendPO pushSendPO) throws Exception {
        RemoteBaseResult result;
        try {
        	pushRemoteService.isConnect(pushSendPO);
            result = new RemoteBaseResult();
            result.setSuccess(true);
        } catch (Exception e) {
            log.error("푸시 전송 에러", e);
            result = new RemoteBaseResult();
            result.setSuccess(false);
        }

        log.debug(result.toString());
        return result;
    }
    
    
    @Override
    public RemoteBaseResult beaconSend(PushSendPO pushSendPO) throws Exception {
        RemoteBaseResult result;
        try {
            /**
             * 푸시서버 전송호출 (연계)
             */
        	pushRemoteService.beaconSend(pushSendPO);
            result = new RemoteBaseResult();
            result.setSuccess(true);
        } catch (Exception e) {
            log.error("푸시 전송 에러", e);
            result = new RemoteBaseResult();
            result.setSuccess(false);
        }

        log.debug(result.toString());
        return result;
    }    
    
    
    @Override
    public RemoteBaseResult pushConfirm(PushSendPO pushSendPO) throws Exception {
        RemoteBaseResult result;
        try {
            /**
             * 푸시서버 전송호출 (연계)
             */
        	result = pushRemoteService.pushConfirm(pushSendPO);
            result.setSuccess(true);
        } catch (Exception e) {
            log.error("푸시 전송 에러", e);
            result = new RemoteBaseResult();
            result.setSuccess(false);
        }

        log.debug(result.toString());
        return result;
    }       
}
