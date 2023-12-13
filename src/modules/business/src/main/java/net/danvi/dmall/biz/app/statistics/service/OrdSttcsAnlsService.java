package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.OrdSttcsSO;
import net.danvi.dmall.biz.app.statistics.model.OrdSttcsVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 7.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface OrdSttcsAnlsService {
    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 7.
     * 작성자 : sin
     * 설명   : 주문 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 7. sin - 최초생성
     * </pre>
     *
     * @param ordSttcsSO
     * @return
     */
    public ResultListModel<OrdSttcsVO> selectOrdSttcsList(OrdSttcsSO ordSttcsSO);
}
