package com.davichmall.ifapi.prd.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.prd.dto
 * - 파일명        : ProductSearchResDTO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 상품조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ProductSearchResDTO extends BaseResDTO {

	/**
	 * 데이터 총 개수
	 */
	private int totalCnt = 0;
	
	/**
	 * 상품리스트
	 */
	private List<ProductInfoDTO> prdList;
	
	/**
	 * 상품정보 DTO
	 * (상품조회응답DTO에서 List형태로 담기 위한 DTO)
	 */
	@Data
	public static class ProductInfoDTO {
		String itmCode;
		String itmName;
		String stdPrc;
		String clsName;
		String makName;
		String brandName;
		String focusName;
		String refractionName;
		Float sph;
		Float cyl;
	}
}
