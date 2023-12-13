package net.danvi.dmall.biz.app.operation.service;

import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointSO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointVO;

import java.util.List;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigPO;
import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigSO;
import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigVO;
import net.danvi.dmall.biz.app.operation.model.PointConfigPO;
import net.danvi.dmall.biz.app.operation.model.PointConfigSO;
import net.danvi.dmall.biz.app.operation.model.PointConfigVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface SavedMnPointService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 마켓포인트 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<SavedMoneyConfigVO> selectSavedMoneyConfig(SavedMoneyConfigSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 마켓포인트 설정 정보 값을 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<SavedMoneyConfigPO> updateSavedMoneyConfig(SavedMoneyConfigPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 회원별 마켓포인트 내역을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<SavedmnPointVO> selectSavedmnGetPaging(SavedmnPointSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 마켓포인트을 지급/차감 한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<SavedmnPointPO> insertSavedMn(SavedmnPointPO po);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 포인트 내역을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<SavedmnPointVO> selectPointGetPaging(SavedmnPointSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 포인트를 지급/차감 한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * 2016. 7. 24 cbk  - 포인트 미사용으로 인해 포인트 대신 마켓포인트이 적립 되도록 변경
     * </pre>
     *
     * @param po
     * @return
     */
    public ResultModel<SavedmnPointPO> insertPoint(SavedmnPointPO po);

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 검색한 전체 마켓포인트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. user - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<SavedmnPointVO> selectTotalSvmn(SavedmnPointSO so);

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : dong
     * 설명   : 검색한 전체 포인트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<SavedmnPointVO> selectTotalPoint(SavedmnPointSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 15.
     * 작성자 : KMS
     * 설명   : 기간내 마켓포인트 지급 내역이 있는지 카운트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 15. KMS - 최초생성
     * 2018. 7. 24. CBK - 포인트 대신 마켓포인트지급 내역을 조회하도록 수정(포인트 대신 마켓포인트 지급)
     * </pre>
     *
     * @param so
     * @return Integer
     */
    public int selectPointGiveHistoryCnt(SavedmnPointSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : kjw
     * 설명   : 지급/차감 된 마켓포인트 목록 삭제(회원탈퇴시)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. kjw - 최초생성
     * </pre>
     *
     * @param MemberManagePO
     * @return
     */
    public ResultModel<SavedmnPointPO> deleteSavedMn(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 8. 2.
     * 작성자 : hskim
     * 설명   : 오프라인 할인쿠폰 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 2. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public List<SavedmnPointVO> selectOfflineCouponList();

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 포인트 설정 정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    public ResultModel<PointConfigVO> selectPointConfig(PointConfigSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 23.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 포인트 설정 정보 값을 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 23. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<PointConfigPO> updatePointConfig(PointConfigPO po) throws Exception;
}
