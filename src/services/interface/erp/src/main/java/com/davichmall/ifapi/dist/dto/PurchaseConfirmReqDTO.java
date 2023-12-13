package com.davichmall.ifapi.dist.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dto
 * - 파일명        : PurchaseConfirmReqDTO.java
 * - 작성일        : 2018. 7. 13.
 * - 작성자        : CBK
 * - 설명          : 구매확정 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PurchaseConfirmReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 주문 번호
	 */
	private String orderNo;
	
	/**
	 * 쇼핑몰 주문상세 정보 리스트
	 */
	private List<PurchaseConfirmOrdDtlDTO> ordDtlList;
	
	// 변환용 변수
	/**
	 * ERP 발주 KEY - 발주일자
	 */
	@ExceptLog
	private String ordDate;
	
	/**
	 * ERP 발주 KEY - 가맹점 코드
	 */
	@ExceptLog
	private String strCode;
	
	/**
	 * ERP 발주 KEY - 전표번호
	 */
	@ExceptLog
	private String ordSlip;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.dist.dto
	 * - 파일명        : PurchaseConfirmReqDTO.java
	 * - 작성일        : 2018. 7. 13.
	 * - 작성자        : CBK
	 * - 설명          : 구매확정 주문 상세 정보
	 * </pre>
	 */
	@Data
	public static class PurchaseConfirmOrdDtlDTO {
		
		/**
		 * 쇼핑몰 주문 상세 번호
		 */
		private String ordDtlSeq;
		
		// 변환용 변수
		/**
		 * ERP 주문 상세 번호
		 */
		@ExceptLog
		private String ordSeq;
		
		/**
		 * ERP 주문상세 추가구매 번호
		 */
		@ExceptLog
		private String ordAddNo;
	}
}
