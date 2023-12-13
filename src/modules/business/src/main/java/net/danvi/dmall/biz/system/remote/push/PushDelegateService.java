package net.danvi.dmall.biz.system.remote.push;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.PushSendPO;

public interface PushDelegateService {

    public RemoteBaseResult send(PushSendPO pushSendPO) throws Exception;
    
    public RemoteBaseResult isConnect(PushSendPO pushSendPO) throws Exception;
    
    public RemoteBaseResult beaconSend(PushSendPO pushSendPO) throws Exception;
    
    public RemoteBaseResult pushConfirm(PushSendPO pushSendPO) throws Exception;
    
}
