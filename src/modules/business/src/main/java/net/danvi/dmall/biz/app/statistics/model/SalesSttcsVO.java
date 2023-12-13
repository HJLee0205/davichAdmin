package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 9.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class SalesSttcsVO {
    public String periodGb;
    public String anlsGbCd;
    public String yr;
    public String mm;
    public String dd;
    public String dt;
    public String hr;
    public String paymentCnt;
    public String paymentAmt;
    public String cpDcAmt;
    public String etcDcAmt;
    public String realPaymentAmt;
    public String returnRefundAmt;
    public String cancelRefundAmt;
    public String refundAmt;
    public String salesAmt;
    public String totBuyrCnt;
    public String totSalesAmt;
    public String totSaleAmt;
    public String svmnPaymentCnt;
    public String svmnPaymentAmt;
    public String rank;
}
