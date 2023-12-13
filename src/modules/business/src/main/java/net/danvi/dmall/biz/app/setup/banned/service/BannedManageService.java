package net.danvi.dmall.biz.app.setup.banned.service;

import java.util.List;

import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.setup.banned.model.*;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface BannedManageService {
    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 금칙어 목록 조회를 한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<BannedManageVO> selectBannedList(BannedManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 금칙어를 등록한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<BannedManagePO> insertBanned(BannedManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 금칙어를 삭제한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<BannedManagePO> deleteBanned(BannedManagePO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 금칙어를 초기화한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<BannedManagePO> updateBannedInit(BannedManagePO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 설명   : 금칙어 중복 체크 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 20. user - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public int selectBannedWordChk(BannedManagePO po);

    /**
     * <pre>
     * 작성일 : 2022. 9. 22.
     * 작성자 : slims
     * 설명   : 금칙어 사용 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 22. slims - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<BannedConfigVO> selectBannedConfig(Long siteNo);

    /**
     * <pre>
     * 작성일 : 2022. 9. 22.
     * 작성자 : slims
     * 설명   : 금칙어 사용 설정 정보를 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 22. slims - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<BannedConfigPO> updateBannedConfig(BannedConfigPO po) throws Exception;
}
