package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.VisitIpSO;
import net.danvi.dmall.biz.app.statistics.model.VisitIpVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 25.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface VisitIpAnlsService {

    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 25.
     * 작성자 : sin
     * 설명   : 방문자 IP분석 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 25. sin - 최초생성
     * </pre>
     *
     * @param visitIpSO
     * @return
     */
    public ResultListModel<VisitIpVO> selectVisitIpList(VisitIpSO visitIpSO);
}
