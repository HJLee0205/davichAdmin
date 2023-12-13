package net.danvi.dmall.biz.app.vision.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 비전체크 군 관리
 * 작성일     : 2019. 2. 1.
 * 작성자     : yang ji
 * 설명       : 
 * </pre>
 */
@Data
@EqualsAndHashCode
public class VisionCheckResultVO extends BaseModel<VisionCheckResultVO> {
	private int visionCheckNo;
	private long memberNo;
	private String lensType;
	private String ageCd;
	private String wearCd;
	private String incon1Cd;
	private String incon2Cd;
	private String lifestyleCd;
	private String contactTypeCd;
	private String wearTimeCd;
	private String wearDayCd;
	private String contactPurpCd;
	private String inconEtc;
}
