package net.danvi.dmall.biz.app.hearingaid.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 작성일        : 2019. 1. 8.
 * - 작성자        : yji
 * </pre>
 */
@Data
@EqualsAndHashCode
public class HearingaidVO {
	private String haUse;
	private String step1Cd;
	private String step1CdFlg;
	private String ringing;
	private String step2CdFlg;
	private String haType;
	private String step3CdFlg;
	private List<Integer> hearingaidCdMap = new ArrayList<>();
	private String goodsNo;
	private String goodsNm;
	private String relateActivity;
	
}
