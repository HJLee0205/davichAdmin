package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.MemberSvmnSO;
import net.danvi.dmall.biz.app.statistics.model.MemberSvmnVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 30.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
public interface MemberSvmnAnlsService {
    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 30.
     * 작성자 : sin
     * 설명   : 회원 마켓포인트 분석결과 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 30. sin - 최초생성
     * </pre>
     *
     * @param memberSvmnSO
     * @return
     */
    public ResultListModel<MemberSvmnVO> selectMemberSvmnList(MemberSvmnSO memberSvmnSO);
}
