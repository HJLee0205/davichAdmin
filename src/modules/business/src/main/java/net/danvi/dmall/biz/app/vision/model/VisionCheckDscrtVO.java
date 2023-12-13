package net.danvi.dmall.biz.app.vision.model;

import java.util.Date;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 25.
 * 작성자     : yji
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class VisionCheckDscrtVO extends BaseModel<VisionCheckDscrtVO> {
	//체크 번호
	private int checkNo; 
	//체크 명
	private String checkNm;
	//이미지명
	private String imgNm;
	//간단 설명
	private String simpleDscrt; 
}
