package net.danvi.dmall.biz.app.operation.service;

import net.danvi.dmall.biz.app.operation.model.PushSendVO;
import net.danvi.dmall.smsemail.model.request.PushSendPO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 12. 21.
 * 작성자     : khy
 * 설명       :
 * </pre>
 */
public interface AppStorePushService {

    
    /**
     * <pre>
     * 작성일 : 2018. 12. 21.
     * 작성자 : khy
     * 설명   : push 발송내역을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 12. 21. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public PushSendVO selectPushCheck(PushSendPO po);

}
