package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.VisitPathSO;
import net.danvi.dmall.biz.app.statistics.model.VisitPathVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 24.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface VisitPathAnlsService {
    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 24.
     * 작성자 : sin
     * 설명   : 방문 경로 분석 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 24. sin - 최초생성
     * </pre>
     *
     * @param visitPathSO
     * @return
     */
    public ResultListModel<VisitPathVO> selectVisitPathList(VisitPathSO visitPathSO);
}
