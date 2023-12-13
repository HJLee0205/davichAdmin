package net.danvi.dmall.biz.system.remote.smseml;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.EmailSendPO;

public interface EmailDelegateService {

    public RemoteBaseResult send(EmailSendPO emailSendPO);
}
