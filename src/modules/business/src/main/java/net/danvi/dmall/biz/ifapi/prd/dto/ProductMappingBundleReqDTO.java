package net.danvi.dmall.biz.ifapi.prd.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
 * - 파일명        : ProductMappingBundleReqDTO.java
 * - 작성일        : 2018. 8. 2.
 * - 작성자        : CBK
 * - 설명          : 상품 매핑 등록/삭제 일괄처리 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ProductMappingBundleReqDTO extends BaseReqDTO {

	/**
	 * 등록 리스트
	 */
	private List<ProductMappingReqDTO> insertList;
	
	/**
	 * 삭제 리스트
	 */
	private List<ProductMappingReqDTO> deleteList;
	
}
