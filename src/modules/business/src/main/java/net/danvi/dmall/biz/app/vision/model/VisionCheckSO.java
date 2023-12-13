package net.danvi.dmall.biz.app.vision.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class VisionCheckSO extends BaseSearchVO<VisionCheckSO> {
    
	private String ageCd;
	private String poMatrCd;
}
