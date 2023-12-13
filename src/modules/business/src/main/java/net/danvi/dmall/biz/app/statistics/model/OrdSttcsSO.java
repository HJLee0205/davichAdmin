package net.danvi.dmall.biz.app.statistics.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

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
public class OrdSttcsSO extends BaseSearchVO<OrdSttcsSO> {
    private String periodGb;
    private String anlsGbCd;
    private String yr;
    private String mm;
    private String dd;
    private String dt;
    private String searchFrom;
    private String searchTo;
}
