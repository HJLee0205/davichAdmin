package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : StoreEyesightInfoResDTO.java
 * - 작성일        : 2018. 6. 20.
 * - 작성자        : CBK
 * - 설명          : 매장 시력정보 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreEyesightInfoResDTO extends BaseResDTO {

	/**
	 * 검사일자(YYYYMMDD)
	 */
	private String testDate;
	
	/**
	 * 검사 가맹점 코드
	 */
	private String testStrCd;
	
	/**
	 * 검사 가맹점 명
	 */
	private String testStrNm;
	
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
	 * BASE 좌 (IO/UD가 모두 있는 경우 "/"구분자로 두값을 모두 설정)
	 */
	private String baseL;
	
	/**
	 * BASE 우 (IO/UD가 모두 있는 경우 "/"구분자로 두값을 모두 설정)
	 */
	private String baseR;
	
	/**
	 * BASE PRISM 좌 (IO/UD가 모두 있는 경우 "/"구분자로 두값을 모두 설정)
	 */
	private String prismL;
	
	/**
	 * BASE PRISM 우 (IO/UD가 모두 있는 경우 "/"구분자로 두값을 모두 설정)
	 */
	private String prismR;
}
