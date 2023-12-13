package net.danvi.dmall.biz.app.setup.base.service;

import net.danvi.dmall.biz.app.setup.base.model.ManagerGroupPO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerGroupSO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerGroupVO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerPO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerPOListWrapper;
import net.danvi.dmall.biz.app.setup.base.model.ManagerSO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 관리자 권한 설정 서비스
 * </pre>
 */
public interface AdminAuthConfigService {
    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 회원(운영자) 목록 페이징 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<ManagerVO> selectManagerPaging(ManagerSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 회원(운영자) 정보 저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<ManagerPO> saveManager(ManagerPOListWrapper wrapper);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 관리자 그룹 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<ManagerGroupVO> selectManagerGroupList(ManagerGroupSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 관리자 그룹 상세 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    ResultModel<ManagerGroupVO> selectManagerGroup(ManagerGroupVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 관리자 그룹 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<ManagerGroupPO> insertManagerGroup(ManagerGroupPO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 관리자 그룹 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<ManagerGroupPO> updateManagerGroup(ManagerGroupPO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 관리자 그룹 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<ManagerGroupPO> deleteManagerGroup(ManagerGroupPO po);

    ResultModel isAddible(ManagerSO so);
}