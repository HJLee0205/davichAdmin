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
public class VisionCategoryVO extends BaseModel<VisionCategoryVO> {
	private int ctgNo;
	private String ctgNm;
	private String ctgComment;
}
