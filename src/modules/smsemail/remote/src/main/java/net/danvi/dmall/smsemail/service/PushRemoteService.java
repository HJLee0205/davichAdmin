package net.danvi.dmall.smsemail.service;

import org.apache.poi.ss.formula.functions.T;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.PushSendPO;

/**
 * <pre>
 * 프로젝트명 : 앱 push 
 * 작성일     : 2018. 8. 31.
 * 작성자     : khy
 * 설명       :
 * </pre>
 */
public interface PushRemoteService {
    /**
     * <pre>
     * 작성일 : 2018. 09. 04.
     * 작성자 : khy
     * 설명   : 푸시 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 09. 04. khy - 최초생성
     * </pre>
     *
     * @param PushSendPO
     * @return
     */
    public RemoteBaseResult send(PushSendPO pushSendPO);
    
    /**
     * <pre>
     * 작성일 : 2018. 09. 04.
     * 작성자 : khy
     * 설명   : 푸시 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 09. 04. khy - 최초생성
     * </pre>
     *
     * @param PushSendPO
     * @return
     */
    public RemoteBaseResult isConnect(PushSendPO pushSendPO);
    
    
    /**
     * <pre>
     * 작성일 : 2018. 09. 06.
     * 작성자 : khy
     * 설명   : 비콘 - 푸시 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 09. 06. khy - 최초생성
     * </pre>
     *
     * @param PushSendPO
     * @return
     */
    public RemoteBaseResult beaconSend(PushSendPO pushSendPO) throws Exception;
    
    
    

    /**
     * <pre>
     * 작성일 : 2018. 09. 06.
     * 작성자 : khy
     * 설명   : 비콘 - 푸시 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 09. 06. khy - 최초생성
     * </pre>
     *
     * @param PushSendPO
     * @return
     */
    public RemoteBaseResult pushConfirm(PushSendPO pushSendPO) throws Exception;    

    
}
