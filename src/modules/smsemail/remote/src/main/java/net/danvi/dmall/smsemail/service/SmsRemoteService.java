package net.danvi.dmall.smsemail.service;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.Sms080RecvRjtVO;
import net.danvi.dmall.smsemail.model.request.SmsSendPO;
import net.danvi.dmall.smsemail.model.request.SmsSendSO;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : smsemail
 * 작성일     : 2016. 8. 29.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface SmsRemoteService {
    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : SMS 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @param list
     * @param certKey
     * @return
     */
    public RemoteBaseResult send(Long siteNo, List<SmsSendPO> list, String certKey);

    public RemoteBaseResult send(Long siteNo, SmsSendPO po, String certKey, String smsMember, SmsSendSO smsSendSO);

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 080 수신 거부 미처리 목록 반환 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param certKey
     * @return
     */
    public List<Sms080RecvRjtVO> select080RectList(String certKey);

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 080 수신 거부 처리 여부 변경
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param certKey
     * @param list
     * @return
     */
    public RemoteBaseResult updateProcYn(String certKey, List<Sms080RecvRjtVO> list);
}
