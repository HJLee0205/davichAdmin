package com.davichmall.ifapi.cmmn.mapp.dto;

import lombok.Data;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.mapp.dto
 * - 파일명        : OrderMapDTO.java
 * - 작성일        : 2018. 6. 8.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰-ERP 주문번호(주문상세포함) 매핑 검색조건/결과용 DTO
 * </pre>
 */
@Data
public class OrderMapDTO {

	/**
	 * 쇼핑몰 주문번호
	 */
	private String mallOrderNo;
	
	/**
	 * 쇼핑몰 주문상세번호(주문상세일때만 사용)
	 */
	private String mallOrderDtlNo;
	
	/**
	 * 쇼핑몰 발주구분 [1:주문, 2:반품]
	 */
//	private String mallOrderType;
	
	/**
	 * 쇼핑몰 반품 번호
	 */
	private String mallClaimNo;
	
	/**
	 * ERP 주문번호 - 주문일자
	 */
	private String erpOrdDate;
	
	/**
	 * ERP 주문번호 - 가맹점코드
	 */
	private String erpStrCode;
	
	/**
	 * ERP 주문번호 - 전표번호
	 */
	private String erpOrdSlip;
	
	/**
	 * ERP 주문상세번호
	 */
	private String erpOrderDtlNo;
	
	/**
	 * ERP 주문상세 추가옵션번호 (ERP는 추가옵션상품인 경우 주문상세번호를 새로 따지 않는다.)
	 */
	private String erpOrderAddNo;
	
	/**
	 * 배송루트(다비치상품 직접수령:1, 다비치상품 매장수령:2, 셀러상품 매장수령:3)
	 */
	private String ordRute;
	
}
