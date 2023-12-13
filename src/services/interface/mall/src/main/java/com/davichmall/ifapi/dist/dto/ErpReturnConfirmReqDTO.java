package com.davichmall.ifapi.dist.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

// 물류센터 반품확정 요청 DTO
@Data
@EqualsAndHashCode(callSuper=false)
public class ErpReturnConfirmReqDTO extends BaseReqDTO {

	/**
	 * ERP 주문번호 - 발주일자
	 */
	private String ordDate;
	
	/**
	 * ERP 주문번호 - 가맹점코드
	 */
	private String strCode;
	
	/**
	 * ERP 주문번호 - 전표번호
	 */
	private String ordSlip;
	
	/**
	 * 주문 상세 목록
	 */
	private List<ErpReturnOrdDtlDto> ordDtlList;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 주문번호
	 */
//	@ExceptLog
//	private String orderNo;
	
	// DB 처리를 위한 변수
	/**
	 * 수정자
	 */
	@ExceptLog(force=true)
	private Long updrNo;
	
	// 반품주문 상세 정보 DTO
	@Data
	public static class ErpReturnOrdDtlDto {
		/**
		 * 반품주문 상세 번호
		 */
		private String ordSeq;
		
		/**
		 * 반품 주문 추가구매번호
		 */
		private String ordAddNo;
		
		/**
		 * 반품주문 수량
		 */
		private Integer qty;
		
		// 변환용 변수
		/**
		 * 쇼핑몰 반품 번호
		 */
		@ExceptLog
		private String claimNo;
		
		/**
		 * 쇼핑몰 주문번호
		 */
		@ExceptLog
		private String ordNo;
		
		/**
		 * 쇼핑몰 주문상세 번호
		 */
		@ExceptLog
		private String ordDtlSeq;
	}
}

