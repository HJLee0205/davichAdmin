package net.danvi.dmall.biz.app.vision.model;

import java.util.ArrayList;
import java.util.List;

import dmall.framework.common.model.BaseModel;
import lombok.Data;

/**
 * Created by yang on 2019-02-18.
 */
@Data
public class VisionCheckContactPO extends BaseModel<VisionCheckContactPO> {
	private String lensType;
	private String ageCdC;
	private String ageCdCNm;
	private String wearCd;
	private String wearCdNm;
	private String contactTypeCd;
	private String contactTypeCdNm;
	private String wearTimeCd;
	private String wearTimeCdNm;
	private String wearDayCd;
	private String wearDayCdNm;
	private String incon1Cd;
	private String incon1CdNm;
	private String incon2Cd;
	private String incon2CdNm;
	private String contactPurpCd;
	private String contactPurpCdNm;
	
	private List<String> incon1CdArr = new ArrayList<>();
	private List<String> incon2CdArr = new ArrayList<>();
	private List<String> ContactPurpCdArr = new ArrayList<>();
}
