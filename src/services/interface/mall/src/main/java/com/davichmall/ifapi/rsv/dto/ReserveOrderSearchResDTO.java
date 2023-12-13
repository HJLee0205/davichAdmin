package com.davichmall.ifapi.rsv.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.dto
 * - 파일명        : ReserveOrderSearchResDTO.java
 * - 작성일        : 2018. 6. 29.
 * - 작성자        : CBK
 * - 설명          : 방문 예약 주문 목록 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ReserveOrderSearchResDTO extends BaseResDTO {

	/**
	 * 주문 목록
	 */
	private List<ReserveOrderDTO> ordList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.rsv.dto
	 * - 파일명        : ReserveOrderSearchResDTO.java
	 * - 작성일        : 2018. 6. 29.
	 * - 작성자        : CBK
	 * - 설명          : 방문 예약 주문 DTO
	 * </pre>
	 */
	@Data
	public static class ReserveOrderDTO {
	
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

		// 조회용 변수
		/**
		 * 쇼핑몰 주문 번호
		 */
		private String mallOrdNo;
	}
}
