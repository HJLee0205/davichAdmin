package net.danvi.dmall.biz.system.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

@Data
@EqualsAndHashCode(callSuper=false)
public class CmnCdGrpSO extends BaseSearchVO<CmnCdGrpSO> {
	private static final long serialVersionUID = 1L;

	/** 그룹 코드 */
	private String grpCd;

	/** 그룹 명 */
	private String grpNm;

}