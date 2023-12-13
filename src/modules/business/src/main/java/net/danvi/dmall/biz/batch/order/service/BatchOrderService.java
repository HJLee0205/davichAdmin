package net.danvi.dmall.biz.batch.order.service;

import java.util.List;
import java.util.Map;

public interface BatchOrderService {

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : 김남근
     * 설명   : 입금누락 주문목록조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. KNG - 최초생성
     * </pre>
     *
     * @param vo
     */
    public List<Map> OrdNoneDepositList(Map vo);

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : 김남근
     * 설명   : 자동SMS발송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. KNG - 최초생성
     * </pre>
     *
     * @param sendTypeCd
     * @param siteNo
     * @param ordNo
     */
    public void sendOrdAutoSms(String templateCode,String sendTypeCd, String siteNo, String ordNo);

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : 김남근
     * 설명   : 자동메일발송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. KNG - 최초생성
     * </pre>
     *
     * @param sendTypeCd
     * @param siteNo
     * @param ordNo
     */
    public void sendOrdAutoEmail(String sendTypeCd, String siteNo, String ordNo);
}
