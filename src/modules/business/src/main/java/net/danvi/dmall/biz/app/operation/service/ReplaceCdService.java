package net.danvi.dmall.biz.app.operation.service;

import java.util.List;

import net.danvi.dmall.biz.app.operation.model.ReplaceCdSO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 24.
 * 작성자     : kjw
 * 설명       :
 * </pre>
 */
public interface ReplaceCdService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 24.
     * 작성자 : dong
     * 설명   : 치환 코드 목록을 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 24. kjw - 최초생성
     * </pre>
     *
     * @param ReplaceCdSO
     * @return
     */
    public List<ReplaceCdVO> selectReplaceCdList(ReplaceCdSO so);

}
