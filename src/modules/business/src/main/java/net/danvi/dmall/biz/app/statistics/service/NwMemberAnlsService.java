package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.NwMemberSO;
import net.danvi.dmall.biz.app.statistics.model.NwMemberVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 29.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface NwMemberAnlsService {

    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 29.
     * 작성자 : sin
     * 설명   : 신규회원 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 29. sin - 최초생성
     * </pre>
     *
     * @param nwMemberSO
     * @return
     */
    public ResultListModel<NwMemberVO> selectNwMemberList(NwMemberSO nwMemberSO);
}
