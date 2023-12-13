package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.PayWaySalesSttcsSO;
import net.danvi.dmall.biz.app.statistics.model.PayWaySalesSttcsVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 13.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface PayWaySalesSttcsAnlsService {

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 13.
     * 작성자 : sin
     * 설명   : 결제수단별 매출 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 13. sin - 최초생성
     * </pre>
     *
     * @param payWaySalesSttcsSO
     * @return
     */
    public ResultListModel<PayWaySalesSttcsVO> selectPayWaySalesSttcsList(PayWaySalesSttcsSO payWaySalesSttcsSO);
}
