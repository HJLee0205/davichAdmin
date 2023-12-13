package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

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
public class VisitIpSO extends BaseSearchVO<VisitIpSO> {
    private String periodGb;
    private String stDt;
    private String endDt;
    private String eqpmGbCd;
    private String excelYn;
    private String searchFrom;
    private String searchTo;
}
