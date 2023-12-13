package com.davichmall.ifapi.prd.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.prd.dto
 * - 파일명        : ProductStockReqDTO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 상품재고 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ProductStockReqDTO extends BaseReqDTO {
	
	/**
	 * 쇼핑몰 단품 코드
	 */
	private String itmCode;

	/**
	 * ERP 상품코드
	 */
	private String erpItmCode;
}
