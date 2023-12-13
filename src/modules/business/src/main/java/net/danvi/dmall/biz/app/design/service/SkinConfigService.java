package net.danvi.dmall.biz.app.design.service;

import java.util.List;

import dmall.framework.common.model.ResultListModel;
import net.danvi.dmall.biz.app.design.model.*;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 21.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface SkinConfigService {

    /**
     * <pre>
     * 작성자 : dong
     * 설명   : 검색조건에 따른 스킨 목록을 조회한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 21. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public List<SkinVO> selectSkinList(SkinSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 26.
     * 작성자 : dong
     * 설명   : 스킨을 실제스킨으로 아님 작업용 스킨으로 변경
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 26. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SkinPO> updateRealSkin(SkinPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 26.
     * 작성자 : dong
     * 설명   : 스킨을 실제스킨으로 아님 작업용 스킨으로 변경
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 26. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SkinPO> updateWorkSkin(SkinPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 26.
     * 작성자 : dong
     * 설명   : 스킨 업로드 등록한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 26. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SkinPO> insertZipUpload(SkinPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 27.
     * 작성자 : dong
     * 설명   : 스킨을 복사 등록한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 27. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SkinPO> insertCopySkin(SkinPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 전시 삭제한다 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SkinPO> deleteSkin(SkinPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 26.
     * 작성자 : dong
     * 설명   : 스킨을 실제스킨으로 아님 작업용 스킨으로 변경
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 26. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SkinPO> updateRealMobileSkin(SkinPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 27.
     * 작성자 : dong
     * 설명   : 쇼핑몰 등록시 기본 스킨 정보를 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 27. dong - 최초생성
     * </pre>
     *
     * @param po
     * @throws Exception
     */
    public void insertDefaultSkin(SkinPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 27.
     * 작성자 : dong
     * 설명   : 구매 스킨 정보를 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 27. dong - 최초생성
     * </pre>
     *
     * @param po
     * @throws Exception
     */
    public void insertBuySkin(SkinPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 12.
     * 작성자 : dong
     * 설명   : 스킨 ID로 스킨 번호를 구한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 12. dong - 최초생성
     * </pre>
     *
     * @param skinId
     */
    public Integer getSkinNoBySkinId(SkinVO skinId);

    /**
     * <pre>
     * 작성일 : 2023. 01. 17.
     * 작성자 : slims
     * 설명   : 스플래시 리스트.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 01. 17. slims - 최초생성
     * </pre>
     *
     * @param so
     */
    public ResultListModel<SplashVO> selectSplashManagePaging(SplashSO so);

    /**
     * <pre>
     * 작성일 : 2023. 01. 17.
     * 작성자 : slims
     * 설명   : 스플래시 상세.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 01. 17. slims - 최초생성
     * </pre>
     *
     * @param so
     */
    public ResultModel<SplashVO> selectSplashManage(SplashSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2023. 01. 17.
     * 작성자 : slims
     * 설명   : 스플래시 생성.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 01. 17. slims - 최초생성
     * </pre>
     *
     * @param po
     */
    public ResultModel<SplashPO> insertSplashManage(SplashPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2023. 01. 17.
     * 작성자 : slims
     * 설명   : 스플래시 업데이트.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 01. 17. slims - 최초생성
     * </pre>
     *
     * @param po
     */
    public ResultModel<SplashPO> updateSplashManage(SplashPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2023. 01. 17.
     * 작성자 : slims
     * 설명   : 스플래시 삭제.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 01. 17. slims - 최초생성
     * </pre>
     *
     * @param wrapper
     */
    public ResultModel<SplashPO> deleteSplashManage(SplashPOListWrapper wrapper) throws Exception;
}
