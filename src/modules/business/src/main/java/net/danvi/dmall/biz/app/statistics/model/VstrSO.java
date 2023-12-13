package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 22.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class VstrSO extends BaseSearchVO<VstrSO> {
    private String periodGb;
    private String yr;
    private String mm;
    private String dd;
    private String dt;
    private String hr;
    private String eqpmGbCd;
}