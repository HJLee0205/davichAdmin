package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.SalesSttcsSO;
import net.danvi.dmall.biz.app.statistics.model.SalesSttcsVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 9.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface SalesSttcsAnlsService {

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 9.
     * 작성자 : sin
     * 설명   : 매출 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 9. sin - 최초생성
     * </pre>
     *
     * @param salesSttcsSO
     * @return
     */
    public ResultListModel<SalesSttcsVO> selectSalesSttcsList(SalesSttcsSO salesSttcsSO);
}
