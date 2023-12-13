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
 * - 파일명        : OrderReleaseReqDTO.java
 * - 작성일        : 2018. 6. 5.
 * - 작성자        : CBK
 * - 설명          : 출고 처리 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OrderReleaseReqDTO extends BaseReqDTO {
	
	/**
	 * 출고 정보 리스트
	 */
	private List<OrderReleaseDtlDto> releaseList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.dist.dto
	 * - 파일명        : OrderReleaseReqDTO.java
	 * - 작성일        : 2018. 6. 5.
	 * - 작성자        : CBK
	 * - 설명          : 출고 처리 상세 DTO
	 * </pre>
	 */
	@Data
	public static class OrderReleaseDtlDto {

		/**
		 * 주문일자
		 */
		private String ordDate;
		
		/**
		 * 가맹점코드
		 */
		private String strCode;
		
		/**
		 * 전표번호
		 */
		private String ordSlip;
		
		/**
		 * 주문상세번호
		 */
		private String ordSeq;
		
		/**
		 * 택배사 코드 [02:한진, 05:CJ, 13:로젠, 16:우체국] - 쇼핑몰과 동기화해아함.
		 */
		private String courierCd;
		
		/**
		 * 송장번호
		 */
		private String invoiceNo;
		
		// 변환용 변수
		/**
		 * 쇼핑몰 주문번호
		 */
		@ExceptLog
		private String mallOrderNo;
		/**
		 * 쇼핑몰 주문 상세
		 */
		@ExceptLog
		private String mallOrdDtlSeq;
	}
}
