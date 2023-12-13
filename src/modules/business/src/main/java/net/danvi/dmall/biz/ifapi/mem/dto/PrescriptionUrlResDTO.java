package net.danvi.dmall.biz.ifapi.mem.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : PrescriptionUrlResDTO.java
 * - 작성일        : 2018. 7. 10.
 * - 작성자        : CBK
 * - 설명          : 처방전 URL 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PrescriptionUrlResDTO extends BaseResDTO {

	/**
	 * 처방전 이미지 URL
	 */
	private String imageUrl;
}
