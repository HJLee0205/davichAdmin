package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 7.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class OrdSttcsVO {
    public String periodGb;
    public String anlsGbCd;
    public String yr;
    public String mm;
    public String dd;
    public String dt;
    public String hr;
    public String allBuyrCnt;
    public String allBuyCnt;
    public String allSaleAmt;
    public String pcBuyrCnt;
    public String pcBuyCnt;
    public String pcSaleAmt;
    public String mobileBuyrCnt;
    public String mobileBuyCnt;
    public String mobileSaleAmt;
    public String manualBuyrCnt;
    public String manualBuyCnt;
    public String manualSaleAmt;
    public String totBuyrCnt;
    public String totBuyCnt;
    public String totSaleAmt;
    public String rank;
}
