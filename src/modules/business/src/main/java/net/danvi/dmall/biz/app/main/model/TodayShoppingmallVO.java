package net.danvi.dmall.biz.app.main.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-07-18.
 */
@Data
public class TodayShoppingmallVO extends BaseModel<TodayShoppingmallVO> {
    // 결제완료
    private Integer todayPaymentCmpltCnt;
    // 주문확정
    private Integer todayOrdCmpltCnt;
    // 오늘출발
    private Integer todayDlvrStartCnt;
    // 매장구매
    private Integer todayStorePicCnt;
    // 예약구매
    private Integer todayRsvCnt;
    // 배송준비
    private Integer todayDlvrReadyCnt;
    // 배송 중
    private Integer todayDlvrProgCnt;
    // 배송 완료
    private Integer todayDlvrCmpltCnt;
    // 결제취소 요청
    private Integer todayPaymentCancelClaimCnt;
    // 반품요청
    private Integer todayReturnClaimCnt;
    // 교환요청
    private Integer todayExchangeClaimCnt;
    // 구매확정
    private Integer todayBuyCmpltCnt;
    // 부분환불요청
    private Integer todayPartReturnCnt;
    // 부분교환요청
    private Integer todayPartExchangeCnt;


    private Integer todayOrdCnt;
    private Integer todayCancelCnt;

    private Integer todaySalesAmt;
    private Integer todayInquiryCnt;
    private Integer todayQuestionCnt;
    private Integer todayNewMemberCnt;
    private Integer todayVisitorCnt;

    private Integer monthOrdCnt;
    private Integer monthSalesAmt;
    private Integer monthInquiryCnt;
    private Integer monthQuestionCnt;
    private Integer monthNewMemberCnt;
    private Integer monthVisitorCnt;
}
