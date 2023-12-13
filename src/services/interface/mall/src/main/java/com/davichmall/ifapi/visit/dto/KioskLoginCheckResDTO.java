package com.davichmall.ifapi.visit.dto;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.visit.dto
 * - 파일명        : KioskLoginCheckResDTO.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 키오스크 로그인 정보 확인 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class KioskLoginCheckResDTO extends BaseResDTO {

	/**
	 * 체크 결과(Y:일치, N:불일치)
	 */
	private String checkResult;
}
