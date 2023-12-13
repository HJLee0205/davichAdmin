package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 29.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class NwMemberVO {
    public String periodGb;
    public String yr;
    public String mm;
    public String dd;
    public String dt;
    public String hr;
    public String nwJonrCnt;
    public String pcJonrCnt;
    public String mobileJonrCnt;
    public String label;
}
