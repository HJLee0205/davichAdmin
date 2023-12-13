package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 5.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class BasketGoodsVO {
    public String periodGb;
    public String anlsGbCd;
    public String yr;
    public String mm;
    public String dd;
    public String dt;
    public String eqpmGbCd;
    public String rank;
    public String goodsNo;
    public String goodsNm;
    public String basketCnt;
    public String basketMemberCnt;
    public String saleQtt;
    public String saleAmt;
    public String stockQtt;
    public String availQtt;
    public String basketQtt;
    public String favGoodsQtt;
    public String reviewCnt;
}
