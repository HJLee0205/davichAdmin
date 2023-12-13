package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : OnPointSearchResDTO.java
 * - 작성일        : 2018. 7. 16.
 * - 작성자        : CBK
 * - 설명          : 온라인 포인트 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OnPointSearchResDTO extends BaseResDTO {

	/**
	 * 온라인 포인트
	 */
	private Integer mallPointAmt;
}
