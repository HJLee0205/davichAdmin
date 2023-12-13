package net.danvi.dmall.biz.app.hearingaid.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 작성일        : 2019. 1. 18.
 * - 작성자        : yji
 * </pre>
 */
@Data
@EqualsAndHashCode
public class HearingaidCheckVO {
	private long hearingaidSeq;
	private long memberNo;
	private String goodsNo;
	private String goodsNm;
	private String goodsNos;
	private String goodsNms;
	private String ctgNos;
	private String resultAll;
	private String regDttm;
	private String relateActivity;
}
