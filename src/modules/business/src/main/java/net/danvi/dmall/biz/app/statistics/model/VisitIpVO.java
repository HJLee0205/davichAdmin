package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 25.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class VisitIpVO {
    public String rank;
    public String periodGb;
    public String stDt;
    public String endDt;
    public String eqpmGbCd;
    public String visitIp;
    public String visitPathCd;
    public String visitPathNm;
    public String visitCnt;
    public String pageVw;
    public String connectTime;

}
