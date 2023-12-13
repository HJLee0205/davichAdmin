package com.davichmall.ifapi.prd.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.prd.dto
 * - 파일명        : ProductSearchReqDTO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 상품 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ProductSearchReqDTO extends BaseReqDTO {

	/**
	 * 상품코드
	 */
	private String itmCode;
	
	/**
	 * 상품명
	 */
	private String itmName;
	
	/**
	 * 상품분류코드
	 */
	private String itmKind;
	
	/**
	 * 브랜트코드
	 */
	private String brandCode;
	
	
	/**
	 * 페이지번호 (zero-base)
	 */
	private Integer pageNo = 0;
	
	/**
	 * 페이지당 표시할 데이터 개수
	 */
	private Integer cntPerPage = 10;
	
}
