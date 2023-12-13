package net.danvi.dmall.biz.app.interest.service;

import java.util.List;

import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.interest.model.InterestPO;
import net.danvi.dmall.biz.app.interest.model.InterestSO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface FrontInterestService {

    /** 설명 : 관심상품에 등록된 상품정보를 조회한다. **/
    public ResultModel<GoodsVO> selectInterest(InterestSO so);

    public List<GoodsVO> selectInterestList(InterestSO so);

    public ResultListModel<GoodsVO> selectInterestListPaging(InterestSO so);

    /** 설명 : 관심상품에 등록된 상품수량을 조회 **/
    public Integer selectInterestTotalCount(InterestSO so);

    /** 설명 : 관심상품에 등록된 상품수량을 조회한다. **/
    public Integer duplicationCheck(InterestPO po);

    /** 설명 : 입력 받은 상품정보를 관심상품 에 등록한다. **/
    public ResultModel<InterestPO> insertInterest(InterestPO po) throws Exception;

    /** 설명 : 입력 받은 상품정보를 관심상품에서 삭제한다 **/
    public ResultModel<InterestPO> deleteInterest(InterestPO po) throws Exception;

    /** 설명 : 입력 받은 상품정보를 장바구니 에 등록한다. **/
    public ResultModel<BasketPO> insertBasket(BasketPO po) throws Exception;
}
