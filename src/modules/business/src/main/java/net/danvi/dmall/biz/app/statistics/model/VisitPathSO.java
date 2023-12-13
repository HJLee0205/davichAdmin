package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 24.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class VisitPathSO extends BaseSearchVO<VisitPathSO> {
    private String periodGb;
    private String yr;
    private String mm;
    private String dd;
    private String dt;
    private String eqpmGbCd;
    private String visitPage;

    private String searchFrom;
    private String searchTo;
}
