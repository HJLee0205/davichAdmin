package com.davichmall.ifapi.prd.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.prd.dto
 * - 파일명        : BrandSearchResDTO.java
 * - 작성일        : 2018. 5. 31.
 * - 작성자        : CBK
 * - 설명          : 브랜드 검색 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class BrandSearchResDTO extends BaseResDTO {

	/**
	 * 브랜드 리스트
	 */
	private List<BrandDTO> brandList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.prd.dto
	 * - 파일명        : BrandSearchResDTO.java
	 * - 작성일        : 2018. 5. 31.
	 * - 작성자        : CBK
	 * - 설명          : 브랜드 정보 DTO
	 * </pre>
	 */
	@Data
	public static class BrandDTO {
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
