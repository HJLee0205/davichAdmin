package net.danvi.dmall.biz.app.statistics.model;

import dmall.framework.common.model.BaseSearchVO;
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
public class LoginCurrentStatusSO extends BaseSearchVO<LoginCurrentStatusSO> {
    private String eqpmGbCd;
    private String searchFrom;
    private String searchTo;
}
