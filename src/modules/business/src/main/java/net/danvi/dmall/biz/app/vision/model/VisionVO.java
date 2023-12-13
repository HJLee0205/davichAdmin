package net.danvi.dmall.biz.app.vision.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 19.
 * 작성자     : yji
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class VisionVO extends BaseModel<VisionVO> {
	
	private String lensType;
	private String lensGbCd;
	private String age;
	private String ageCd;
	private String lifeStyleCd;
	private String relateActivity;
	private String checkNo;
}
