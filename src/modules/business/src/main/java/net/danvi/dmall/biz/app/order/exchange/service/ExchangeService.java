
package net.danvi.dmall.biz.app.order.exchange.service;

import java.util.List;

import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 반품/교환을 담당하는 컴포넌트
 * </pre>
 */
public interface ExchangeService {

    public ResultListModel<ClaimGoodsVO> selectExchangeListPaging(ClaimSO so) throws CustomException;

    public List<ClaimGoodsVO> selectExchangeListExcel(ClaimSO so) throws CustomException;

    public ResultListModel<ClaimGoodsVO> selectOrdDtlExchange(ClaimSO so) throws CustomException;

    public ResultModel<OrderVO> selectOrdDtlForExchange(OrderInfoVO vo) throws CustomException;

    // public ResultModel<ClaimGoodsVO> insertClaimExchange(ClaimGoodsPO po) throws CustomException;

    public ResultModel<ClaimGoodsVO> processClaimExchange(ClaimGoodsPO po) throws Exception;

    public ResultModel<ClaimGoodsVO> updateClaimExchange(ClaimGoodsPO po) throws CustomException;

}
