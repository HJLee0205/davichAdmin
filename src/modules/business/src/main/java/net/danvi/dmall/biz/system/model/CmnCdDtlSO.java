package net.danvi.dmall.biz.system.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

@Data
@EqualsAndHashCode(callSuper=false)
public class CmnCdDtlSO extends BaseSearchVO<CmnCdDtlSO> {

	private static final long serialVersionUID = 1L;

	/** 그룹 코드 */
	private String grpCd;

	/** 상세 코드 */
	private String dtlCd;

	/** 사용자 정의1 값 */
	private String userDefien1;

	/** 사용자 정의2 값 */
	private String userDefien2;

	/** 사용자 정의3 값 */
	private String userDefien3;

	/** 사용자 정의4 값 */
	private String userDefien4;

	/** 사용자 정의5 값 */
	private String userDefien5;

	private String selectKey;

	private String defaultName;

	private String showValue;

	private int usrDfnValIdx;
}