package net.danvi.dmall.biz.app.promotion.exhibition.service;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.model.KeywordSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.*;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierVO;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 기획전 서비스
 * </pre>
 */
public interface ExhibitionService {
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
    public ResultListModel<ExhibitionVO> selectExhibitionListPaging(ExhibitionSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : 이헌철
     * 설명   : 진행 중이거나 진행예정인 기획전 전체 조회 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. 이헌철 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<ExhibitionVO> selectOtherExhibitionList(ExhibitionSO so);

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
    public ResultModel<ExhibitionPO> insertExhibition(ExhibitionPO po, HttpServletRequest request) throws Exception;

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
    public ResultModel<ExhibitionPO> updateExhibition(ExhibitionPO po, HttpServletRequest request) throws Exception;

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
    public ResultModel<ExhibitionPO> deleteExhibition(ExhibitionPOListWrapper wrapper) throws Exception;

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
    public ResultModel<ExhibitionVO> selectExhibitionDtl(ExhibitionSO so) throws Exception;

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
    public ResultModel<ExhibitionVO> selectExhibitionInfo(ExhibitionSO so);

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
    public ResultListModel<GoodsVO> selectExhibitionGoodsList(ExhibitionSO so);

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
    public ResultModel<ExhibitionVO> selectExhibitionByGoods(ExhibitionSO so) throws Exception;

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
    public ResultListModel<ExhibitionTargetVO> selectExhibitionTargetTotal(ExhibitionSO so);
    // 기획전 전시존 전체조회
    /**
     * <pre>
     * 작성일 : 2018. 7. 2.
     * 작성자 : 이현진
     * 설명   : 기획전 전시존 전체조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 2. 이현진 - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
	public List<ExhibitionVO> selectEhbDispMngList(ExhibitionSO so) throws Exception;
	
	/**
     * <pre>
     * 작성일 : 2018. 7. 02.
     * 작성자 : 이현진
     * 설명   : 기획전 전시존 상품 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 02. 이현진 - 최초생성
     * </pre>
     *
     * @param ExhibitionSO
     * @return ExhibitionVO
     */    
	public List<GoodsVO> selectEhbDispGoodsList(ExhibitionSO so) throws Exception;

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
    ResultModel<ExhibitionPO> copyExhibitionInfo(ExhibitionPO po) throws Exception;

    /**
     * <pre>
     * 작성일     : 2022. 9. 28.
     * 작성자     : slims
     * 설명   : Exhibition 등록 상품, 판매중인 상품 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. slims - 최초생성
     * </pre>
     *
     * @param KeywordSO
     * @return KeywordVO
     */
    public List<GoodsVO> selectExhibitionTargetGoodsList(ExhibitionSO exhibitionSO);

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
    public Integer selectExhibitionTargetGoodsExist(ExhibitionSO exhibitionSO);

    public String selectNewPrmtNo();
}
