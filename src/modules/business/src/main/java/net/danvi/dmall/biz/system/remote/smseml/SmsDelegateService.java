package net.danvi.dmall.biz.system.remote.smseml;


import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.Sms080RecvRjtVO;
import net.danvi.dmall.smsemail.model.request.SmsSendPO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;


import java.util.List;

public interface SmsDelegateService {

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
     * @return
     */
    public RemoteBaseResult send(Long siteNo, List<SmsSendPO> list);

    public RemoteBaseResult send(Long siteNo, SmsSendPO po, String smsMember, SmsSendSO smsSendSO);

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
     * @return
     */
    public List<Sms080RecvRjtVO> select080RectList();

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
     * @param list
     * @return
     */
    public RemoteBaseResult updateProcYn(List<Sms080RecvRjtVO> list);
}
