package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 13.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class PayWaySalesSttcsVO {
    public String periodGb;
    public String anlsGbCd;
    public String yr;
    public String mm;
    public String dd;
    public String dt;
    public String hr;
    public String nopbDpstCnt;
    public String nopbDpstAmt;
    public String virtActDpstCnt;
    public String virtActDpstAmt;
    public String credPaymentCnt;
    public String credPaymentAmt;
    public String actTransCnt;
    public String actTransAmt;
    public String mobilePaymentCnt;
    public String mobilePaymentAmt;
    public String simpPaymentCnt;
    public String simpPaymentAmt;
    public String paypalCnt;
    public String paypalAmt;
    public String totalCnt;
    public String totalAmt;
    public String svmnPaymentCnt;
    public String svmnPaymentAmt;
    public String sbnPaymentCnt;
    public String sbnPaymentAmt;
}
