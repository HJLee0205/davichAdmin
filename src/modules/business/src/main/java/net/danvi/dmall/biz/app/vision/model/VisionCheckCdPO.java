package net.danvi.dmall.biz.app.vision.model;

import java.util.ArrayList;
import java.util.List;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerPO;

/**
 * Created by yang on 2019-02-18.
 */
@Data
public class VisionCheckCdPO extends BaseModel<VisionCheckCdPO> {
	private String lensType;
	private String grpCd;
	private String cd;
	private String cdNm;
	private String cdShortNm;
	private String userDefine1;
	private String userDefine2;
	private String userDefine3;
	private String userDefine4;
	
	private List<String> cdArr = new ArrayList<>();
	private List<String> userDefine1Arr = new ArrayList<>();
	private List<String> userDefine2Arr = new ArrayList<>();
}
