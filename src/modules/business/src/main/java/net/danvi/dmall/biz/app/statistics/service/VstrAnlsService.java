package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.VstrSO;
import net.danvi.dmall.biz.app.statistics.model.VstrVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 22.
 * 작성자     : sin
 * 설명       : 방문자분석 통계 서비스 인터페이스
 * </pre>
 */
public interface VstrAnlsService {

    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : sin
     * 설명   : 접속자 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. sin - 최초생성
     * </pre>
     *
     * @param vstrSO
     * @return
     */
    public ResultListModel<VstrVO> selectVstrList(VstrSO vstrSO);
}
