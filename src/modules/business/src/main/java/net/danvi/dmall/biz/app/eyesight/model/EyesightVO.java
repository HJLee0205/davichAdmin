package net.danvi.dmall.biz.app.eyesight.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : 03.business
 * - 패키지명      : net.danvi.dmall.biz.app.eyesight.model
 * - 파일명        : EyesightVO.java
 * - 작성일        : 2018. 7. 6.
 * - 작성자        : CBK
 * - 설명          : 시력정보 O
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class EyesightVO extends BaseModel<EyesightVO> {
	
	private static final long serialVersionUID = -5282144230895018127L;

	/**
	 * 검사일자
	 */
	private String checkupDt;
	
	/**
	 * 검사기관명
	 */
	private String checkupInstituteNm;

	/**
	 * 근시원시 좌
	 */
	private String sphL;
	
	/**
	 * 근시원시 우
	 */
	private String sphR;
	
	/**
	 * 난시 좌
	 */
	private String cylL;
	
	/**
	 * 난시 우
	 */
	private String cylR;
	
	/**
	 * 난시축 좌
	 */
	private String axisL;
	
	/**
	 * 난시축 우
	 */
	private String axisR;
	
	/**
	 * ADD 좌
	 */
	private String addL;
	
	/**
	 * ADD 우
	 */
	private String addR;
	
	/**
	 * PD 좌
	 */
	private String pdL;
	
	/**
	 * PD 우
	 */
	private String pdR;
	
	/**
	 * BASE 좌
	 */
	private String baseL;
	
	/**
	 * BASE 우
	 */
	private String baseR;
	
	/**
	 * PRISM 좌
	 */
	private String prismL;
	
	/**
	 * PRISM 우
	 */
	private String prismR;
	
	/**
	 * 최종 수정 일시
	 */
	private String lastUpdDttm;
}
