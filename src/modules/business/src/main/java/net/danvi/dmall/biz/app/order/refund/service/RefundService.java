package net.danvi.dmall.biz.app.order.refund.service;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.order.manage.model.*;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface RefundService {

    public ResultListModel<ClaimGoodsVO> selectRefundListPaging(ClaimSO so) throws Exception;

    public List<ClaimGoodsVO> selectRefundListExcel(ClaimSO so) throws Exception;

    /** 환불 처리를 위한 목록 */
    public List<ClaimGoodsVO> selectOrdDtlRefund(ClaimGoodsVO vo) throws Exception;

    /** 전체환불신청 **/
    public ResultModel<ClaimGoodsVO> updateClaimAllRefund(ClaimGoodsPO po) throws Exception;

    /** 클레임 결제 현금 환불 정보 등록 **/
    public ResultModel<ClaimPayRefundPO> insertPaymerCashRefund(ClaimPayRefundPO po) throws Exception;

    /** 프론트용 주문 취소 신청 **/
    public ResultModel<OrderPO> frontOrderCancelRequest(OrderPO po) throws Exception;

    /** 취소 정보 ( 결제 메모 등 ) */
    public ResultModel<ClaimVO> selectOrdDtlPayCancelInfo(ClaimSO so) throws Exception;

    /** 부분 취소 정보 ( 결제 메모 등 ) */
    public ResultModel<ClaimVO> selectOrdDtlPayPartCancelInfo(ClaimSO so) throws Exception;

    /** 환불, 취소 수정 */
    public ResultModel<ClaimGoodsVO> updateClaimRefund(ClaimGoodsPO po) throws Exception;

    /** 현금 환불 정보 등록 확인 **/
    public Integer selectCashRefundCount(ClaimPayRefundPO po);

    /** 환불 정보 수정 **/
    public ResultModel<OrderPayPO> updateRefund(OrderPO po) throws Exception;

    /** 물류 반품 체크 팝업 **/
	public ClaimVO selectRefundChk(ClaimPO po) throws Exception;

	/** 물류 반품 체크 수정 **/
	public ResultModel<ClaimVO> updateRefundChk(ClaimPO po) throws Exception;

    /** 반품등록 **/
    public void returnRegist(ClaimGoodsPO po) throws Exception;

    /** 발주취소 **/
    public void orderCancel(ClaimGoodsPO claimGodosPo) throws Exception;

    /** 반품확정 **/
    public void returnConfirm(ClaimGoodsPO claimGodosPo) throws Exception;

    /** 반품 취소 **/
    public void returnCancel(ClaimGoodsPO claimGodosPo) throws Exception;

    /** 환불완료 **/
    public void refundConfirm(ClaimGoodsPO claimGodosPo) throws Exception;

    /** 교환완료 **/
    public void exchangeConfirm(ClaimGoodsPO claimGodosPo) throws Exception;
    
    /** 반품 신청 사유 조회 */
    public ClaimGoodsVO selectClaimReason(ClaimPO po) throws Exception;

    public ResultModel<OrderVO> selectRefundRequestList(OrderInfoVO vo);
}