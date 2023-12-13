package net.danvi.dmall.biz.ifapi.prd.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import java.util.List;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
 * - 파일명        : BrandSearchResDTO.java
 * - 작성일        : 2023. 03. 31.
 * - 작성자        : slims
 * - 설명          : 브랜드 검색 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class FilterSearchResDTO extends BaseResDTO {

	/**
	 * 브랜드 리스트
	 */
	private List<FilterDTO> filterList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
	 * - 파일명        : BrandSearchResDTO.java
	 * - 작성일        : 2018. 5. 31.
	 * - 작성자        : CBK
	 * - 설명          : 브랜드 정보 DTO
	 * </pre>
	 */
	@Data
	public static class FilterDTO {
		/**
		 * 브랜드 코드
		 */
		private String brandCode;
		
		/**
		 * 브랜드 이름
		 */
		private String brandName;
		
		/**
		 * 브랜드 한글 이름
		 */
		private String brandNameKr;
	}
}
