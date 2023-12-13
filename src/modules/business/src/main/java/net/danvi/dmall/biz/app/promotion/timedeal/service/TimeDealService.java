package net.danvi.dmall.biz.app.promotion.timedeal.service;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.timedeal.model.*;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 기획전 서비스
 * </pre>
 */
public interface TimeDealService {
    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : 이헌철
     * 설명   : 기획전 관리 목록 조회 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. 이헌철 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<TimeDealVO> selectTimeDealListPaging(TimeDealSO so);


    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : 이헌철
     * 설명   : 기획전 정보 등록 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. 이헌철 - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<TimeDealPO> insertTimeDeal(TimeDealPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : 이헌철
     * 설명   : 기획전 정보 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. 이헌철 - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<TimeDealPO> updateTimeDeal(TimeDealPOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : 이헌철
     * 설명   : 기획전 정보 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. 이헌철 - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     * @throws Exception
     */
    public ResultModel<TimeDealPO> deleteTimeDeal(TimeDealPOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : 이헌철
     * 설명   : 기획전 정보 조회(단건)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. 이헌철 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultModel<TimeDealVO> selectTimeDealDtl(TimeDealSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : 
     * 설명   : 기획전 정보 조회(단건, 프론트용)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28.   - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<TimeDealVO> selectTimeDealInfo(TimeDealSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : Administrator
     * 설명   : 기획전상품목록 조회(프론트용) 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<GoodsVO> selectTimeDealGoodsList(TimeDealSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : Administrator
     * 설명   : 기획전 할인정보 조회(프론트용)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultModel<TimeDealVO> selectTimeDealByGoods(TimeDealSO so) throws Exception;

    // 기획전대상 전체조회
    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : 이헌철
     * 설명   : 기획전대상(상품) 전체조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. 이헌철 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<TimeDealTargetVO> selectTimeDealTargetTotal(TimeDealSO so);


    /**
     * <pre>
     * 작성일 : 2022. 12. 12.
     * 작성자 : slims
     * 설명   : 기획전정보 복사
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 12. 12. slims - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<TimeDealPO> copyTimeDealInfo(TimeDealPO po) throws Exception;

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : TimeDeal 등록 상품, 판매중인 상품 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. slims - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return KeywordVO
     */
    public List<GoodsVO> selectTimeDealTargetGoodsList(TimeDealSO timeDealSO);

    /**
     * <pre>
     * 작성일 : 2023. 03. 17.
     * 작성자 : slims
     * 설명   : 프로모션에 이미 등록 되어있으면 1 없으면 0을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 03. 17. slims - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public Integer selectTimeDealTargetGoodsExist(TimeDealSO so);
}
