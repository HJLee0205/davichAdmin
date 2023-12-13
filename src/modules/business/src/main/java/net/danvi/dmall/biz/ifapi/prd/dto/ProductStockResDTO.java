package net.danvi.dmall.biz.ifapi.prd.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
 * - 파일명        : ProductStockResDTO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 상품재고 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ProductStockResDTO extends BaseResDTO {

	/**
	 * 다비젼 상품코드
	 */
	private String itmCode;
	
	/**
	 * 재고수량
	 */
	private int qty;
}
