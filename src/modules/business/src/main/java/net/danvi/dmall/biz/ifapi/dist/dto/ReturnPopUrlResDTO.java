package net.danvi.dmall.biz.ifapi.dist.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.dist.dto
 * - 파일명        : ReturnPopUrlResDTO.java
 * - 작성일        : 2018. 8. 13.
 * - 작성자        : CBK
 * - 설명          : 반품 팝업 URL 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ReturnPopUrlResDTO extends BaseResDTO {
	
	/**
	 * 반품 상세 팝업 URL
	 */
	private String popUrl;

}
