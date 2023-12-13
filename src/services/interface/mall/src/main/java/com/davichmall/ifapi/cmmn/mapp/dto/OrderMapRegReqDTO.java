package com.davichmall.ifapi.cmmn.mapp.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.mapp.dto
 * - 파일명        : OrderMapRegReqDTO.java
 * - 작성일        : 2018. 7. 17.
 * - 작성자        : CBK
 * - 설명          : 발주 매핑 정보 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OrderMapRegReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 주문번호
	 */
	private String mallOrderNo;
	
	/**
	 * ERP주문번호 - 발주일자
	 */
	private String erpOrdDate;
	
	/**
	 * ERP주문번호 - 가맹점코드
	 */
	private String erpStrCode;
	
	/**
	 * ERP주문번호 - 전표번호
	 */
	private String erpOrdSlip;
	
	/**
	 * 주문 상세 정보 목록
	 */
	private List<OrderDtlMapDTO> ordDtlMapList;
	
	/**
	 * 배송루트(다비치상품 직접수령:1, 다비치상품 매장수령:2, 셀러상품 매장수령:3)
	 */
	private String ordRute;
	
	@Data
	public static class OrderDtlMapDTO {

		/**
		 * 쇼핑몰 주문번호
		 */
		private String mallOrderNo;
		
		/**
		 * 쇼핑몰주문상세번호
		 */
		private String mallOrderDtlNo;
		
		/**
		 * ERP 주문상세번호
		 */
		private String erpOrderDtlNo;
		
		/**
		 * ERP 주문상세 추가옵션번호
		 */
		private String erpOrderAddNo;
	}
}
