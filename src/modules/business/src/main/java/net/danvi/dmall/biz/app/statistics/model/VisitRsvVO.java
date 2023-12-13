package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 1.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class VisitRsvVO {
    public String periodGb;
    public String yr;
    public String mm;
    public String dd;
    public String dt;
    public int rank;
    public String largeClsf;
    public String mediumClsf;
    public String largeClsfNm;
    public String mediumClsfNm;
    public String allSaleQtt;
    public String allSaleAmt;
    public String reviewCnt;
    public String pcSaleQtt;
    public String pcSaleAmt;
    public String mobileSaleQtt;
    public String mobileSaleAmt;

}
