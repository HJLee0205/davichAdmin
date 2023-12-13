package net.danvi.dmall.biz.app.hearingaid.model;

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
public class HearingaidStep1VO {
	private String grpCd;
	private String cd;
	private String cdNm;
	private String cdShortNm;
	private String userDefine1;
	private String userDefine2;
	private String userDefine3;
	private String userDefine4;
	private String stepCd;	
}
