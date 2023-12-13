package net.danvi.dmall.biz.ifapi.prd.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
 * - 파일명        : BrandSearchReqDTO.java
 * - 작성일        : 2018. 5. 31.
 * - 작성자        : CBK
 * - 설명          : 브랜드 검색 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class BrandSearchReqDTO extends BaseReqDTO {

	/**
	 * 구분 [1:테, 2:렌즈, 3:콘택트렌즈, 4:소모품, 5:보청기]
	 */
	private String itmKind;
	
	/**
	 * 브랜드 이름
	 */
	private String brandName;
}
