package net.danvi.dmall.biz.app.order.deposit.service;

import java.util.List;

import net.danvi.dmall.biz.app.order.deposit.model.DepositSO;
import net.danvi.dmall.biz.app.order.deposit.model.DepositVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface DepositService {

    public ResultListModel<DepositVO> selectDepositListPaging(DepositSO so) throws CustomException;

    public List<DepositVO> selectDepositListExcel(DepositSO so) throws CustomException;

    /** 무통장 입금 결제처리 */
    public boolean updateOrdStatusPayDoneCommon(OrderGoodsVO vo, String curOrdStatusCd) throws CustomException;

    /** 무통장 입금 결제처리 -주문상태 변경 포함 */
    public boolean updateOrdStatusPayDone(OrderGoodsVO vo, String curOrdStatusCd) throws CustomException;
}
