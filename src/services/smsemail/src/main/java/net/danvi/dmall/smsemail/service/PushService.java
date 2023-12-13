package net.danvi.dmall.smsemail.service;

import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.PushSendVO;
import net.danvi.dmall.smsemail.model.email.CustomerInfoPO;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import org.springframework.scheduling.annotation.Async;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : push service
 * 작성일     : 2018. 8. 31.
 * 작성자     : khy
 * 설명       :
 * </pre>
 */
public interface PushService {

    /**
     * <pre>
     * 작성일 : 2018. 8. 31.
     * 작성자 : khy
     * 설명   : 대량 푸시 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 31. khy - 최초생성
     * </pre>
     *
     * @param pushSendPO
     * @return
     */
    public CustomerInfoPO send(PushSendPO pushSendPO) throws CloneNotSupportedException;

    @Async
    public void sendPush(List<MemberManageVO> list, PushSendVO vo) throws Exception;
}
