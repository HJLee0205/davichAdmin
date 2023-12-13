package net.danvi.dmall.biz.ifapi.mem.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
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
