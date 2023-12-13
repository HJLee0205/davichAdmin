package net.danvi.dmall.biz.app.vision.model;

import java.util.ArrayList;
import java.util.List;

import dmall.framework.common.model.BaseModel;
import lombok.Data;

/**
 * Created by yang on 2019-02-18.
 */
@Data
public class VisionCheckGlassesPO extends BaseModel<VisionCheckGlassesPO> {
	private String lensType;
	private String ageCdG;
	private String ageCdGNm;
	private String wearCd;
	private String wearCdNm;
	private String incon1Cd;
	private String incon1CdNm;
	private String incon2Cd;
	private String incon2CdNm;
	private String lifestyleCd;
	private String lifestyleCdNm;
	
	private List<String> incon2CdArr = new ArrayList<>();
	private List<String> lifestyleCdCdArr = new ArrayList<>();
}
