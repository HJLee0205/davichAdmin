package net.danvi.dmall.smsemail.service;


import net.danvi.dmall.core.remote.homepage.model.request.PaymentInfoPO;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;

/**
 * <pre>
 * 프로젝트명 : smsemail
 * 작성일     : 2016. 8. 29.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface PointRemoteService {

    /**
     * <pre>
     * 작성일 : 2016. 8. 29.
     * 작성자 : dong
     * 설명   : SMS/이메일 포인트를 추가한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public RemoteBaseResult addPoint(PaymentInfoPO po);

    /**
     * <pre>
     * 작성일 : 2016. 10. 4.
     * 작성자 : dong
     * 설명   : 인증 키값을 생성하고 저장한뒤 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 4. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public String getCertKey(Long siteNo);
}
