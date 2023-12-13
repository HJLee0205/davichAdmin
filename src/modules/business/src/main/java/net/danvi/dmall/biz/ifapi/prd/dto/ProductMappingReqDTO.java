package net.danvi.dmall.biz.ifapi.prd.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
 * - 파일명        : ProductMappingReqDTO.java
 * - 작성일        : 2018. 5. 21.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰-ERP 상품코드 매핑등록 요청 DTO 
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ProductMappingReqDTO extends BaseReqDTO {
	
	/**
	 * 쇼핑몰 상품코드
	 */
	private String mallGoodsNo;
	
	/**
	 * 쇼핑몰 단품코드
	 */
	private String mallItmCode;
	
	/**
	 * ERP 상품코드
	 */
	private String erpItmCode;
}
