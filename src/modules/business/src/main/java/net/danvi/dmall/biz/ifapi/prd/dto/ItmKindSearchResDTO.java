package net.danvi.dmall.biz.ifapi.prd.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
 * - 파일명        : ItmKindSearchResDTO.java
 * - 작성일        : 2018. 5. 31.
 * - 작성자        : CBK
 * - 설명          : 상품 분류 목록 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ItmKindSearchResDTO extends BaseResDTO {

	/**
	 * 상품분류 목록
	 */
	private List<ItmKindDTO> itmKindList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
	 * - 파일명        : ItmKindSearchResDTO.java
	 * - 작성일        : 2018. 5. 31.
	 * - 작성자        : CBK
	 * - 설명          : 상품 분류 DTO
	 * </pre>
	 */
	@Data
	public static class ItmKindDTO {
		/**
		 * 상품분류 코드
		 */
		private String code;
		
		/**
		 * 상품분류이름
		 */
		private String name;
	}
}
