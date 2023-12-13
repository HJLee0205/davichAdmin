package net.danvi.dmall.smsemail.service;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.EmailSendPO;

/**
 * <pre>
 * 프로젝트명 : smsemail
 * 작성일     : 2016. 8. 29.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface EmailRemoteService {
    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 대량 메일 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param emailSendPO
     * @return
     */
    public RemoteBaseResult send(EmailSendPO emailSendPO);
}
