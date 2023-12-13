package net.danvi.dmall.biz.app.basket.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.basket.model.BasketOptSO;
import net.danvi.dmall.biz.app.basket.model.BasketOptVO;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketSO;
import net.danvi.dmall.biz.app.basket.model.BasketVO;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface FrontBasketService {

    /** 장바구니에 등록된 상품수량을 조회 **/
    public Integer selectBasketTotalCount(BasketSO so);

    /**
     * 설명 : 장바구니에 정보 조회.
     *
     * @throws Exception
     **/
    public List<BasketVO> selectBasketList(BasketSO so) throws Exception;

    public BasketOptVO addOptInfo(BasketOptSO so);

    /** 설명 : 상품을 장바구니에 등록한다. **/
    public ResultModel<BasketPO> insertBasket(BasketPO po) throws Exception;

    public ResultModel<BasketPO> insertBasketSession(BasketPO po, HttpServletRequest request) throws Exception;

    /** 장바구니에 등록된 상품정보를 변경한다 **/
    public ResultModel<BasketPO> updateBasketCnt(BasketPO po) throws Exception;

    public ResultModel<BasketPO> updateBasketCntSession(BasketPO po, HttpServletRequest request) throws Exception;

    /** 장바구니에 등록된 상품정보를 삭제한다. **/
    public ResultModel<BasketPO> deleteBasket(BasketPO po) throws Exception;

    public ResultModel<BasketPO> deleteBasketSession(BasketPO po, HttpServletRequest request) throws Exception;

    /** 단품번호를 기준으로 장바구니를 조회한다. **/
    public List<BasketVO> selectBasketByItemNo(BasketSO so) throws Exception;

    /** Item 단건 조회 **/
    public BasketVO selectItemInfo(BasketSO so) throws Exception;

    /** 기획전 할인정보 조회 */
    public BasketVO promotionDcInfo(BasketVO basketVO) throws Exception;

    /** 장바구니 분석 데이터 등록 */
    public ResultModel<BasketPO> insertBasketAnls(BasketPO po);
}
