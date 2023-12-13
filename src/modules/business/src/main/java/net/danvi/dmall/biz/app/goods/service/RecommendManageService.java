package net.danvi.dmall.biz.app.goods.service;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.goods.model.*;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 11. 08.
 * 작성자     : slims
 * 설명       : 사은품 서비스 인터페이스
 * </pre>
 */
public interface RecommendManageService {
    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 목록 조회.
     */
    public List<GoodsRecommendVO> selectGoodsRecommendList(GoodsRecommendSO so);

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 단건 조회.
     */
    public ResultModel<GoodsRecommendVO> selectGoodsRecommendContents(GoodsRecommendSO so) throws Exception;

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 등록.
     */
    public ResultModel<GoodsRecommendPO> insertGoodsRecommendItems(GoodsRecommendPO po) throws Exception;

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 수정.
     */
    public ResultModel<GoodsRecommendPO> updateGoodsRecommendContents(GoodsRecommendPO po) throws Exception;

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 삭제.
     */
    public ResultModel<GoodsRecommendPO> deleteGoodsRecommendContents(GoodsRecommendPO po) throws Exception;

    /**
     * 작성자 : truesol
     * 설명 : 추천상품 순서 변경
     */
    public List<GoodsRecommendVO> updateRecommendSort(GoodsRecommendPO po) throws Exception;
}
