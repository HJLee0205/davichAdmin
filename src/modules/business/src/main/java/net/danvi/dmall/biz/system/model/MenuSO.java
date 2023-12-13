package net.danvi.dmall.biz.system.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

@Data
@EqualsAndHashCode(callSuper=false)
public class MenuSO extends BaseSearchVO<MenuSO> {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;


	/**그룹 코드*/
	private String grpCd;

}