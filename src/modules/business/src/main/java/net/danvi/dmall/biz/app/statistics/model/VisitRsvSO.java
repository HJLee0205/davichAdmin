package net.danvi.dmall.biz.app.statistics.model;

import dmall.framework.common.model.BaseSearchVO;
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
public class VisitRsvSO extends BaseSearchVO<VisitRsvSO> {
    private String periodGb;
    private String yr;
    private String mm;
    private String dd;
    private String dt;
    private String eqpmGbCd;
    private String excelYn;

    private String searchFrom;
    private String searchTo;
}
